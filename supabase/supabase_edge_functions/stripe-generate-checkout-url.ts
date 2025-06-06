// import { serve } from 'std/http/server.ts'
// import { stripe } from 'stripe'
// import { decode } from 'jsonwebtoken'  // Use the appropriate JWT decoding library for Deno
import { createClient } from 'jsr:@supabase/supabase-js@2';
import Stripe from 'https://esm.sh/stripe@14?target=denonext';

// const stripeSecretKey = Deno.env.get('STRIPE_SECRET_KEY');
const stripeWebhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET');
const stripeKey = Deno.env.get('STRIPE_API_KEY');
const stripe = new Stripe(stripeKey, {apiVersion: "2025-04-30.basil"});

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const supabase = createClient(supabaseUrl, supabaseKey);

Deno.serve(async (req)=>{
  if (req.method === 'OPTIONS') {
    console.log("OPTIONS request received");
    return new Response(null, {
      headers: {
        // 'Access-Control-Allow-Origin': '*',
        // 'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
        // 'Access-Control-Allow-Headers': 'Authorization, Content-Type',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
      }
    });
  }

  if (req.method !== "POST") {
    return new Response("Method Not Allowed", {
      status: 405
    });
  }

  // Extract the Authorization token from the request headers
  const authHeader = req.headers.get('Authorization');
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return new Response('Unauthorized', { status: 401 });
  }

  try {
    // Get the session or user object
    const token = authHeader.replace('Bearer ', '');
    const { data } = await supabase.auth.getUser(token);
    const user = data.user;
    console.log(`DEBUG: user ID: ${user.id}`);
    console.log(`DEBUG: user email: ${user.email}`);

    const stripeCustomerId = await getOrCreateStripeCustomerId({
      supabaseClient: supabase,
      stripeClient: stripe,
      userId: user.id,
      userEmail: user.email
      // firstName: metadata.first_name,
      // lastName: metadata.last_name
    });

    const body = await req.json();
    const { productType } = body;
    console.log('DEBUG: incoming productType:', productType); // 👈 ADD THIS
    const { price_id, quantity, mode } = getProductDetails(productType);
    const checkoutUrl = await createCheckoutSession(stripeCustomerId, price_id, quantity, mode);
    console.log(`DEBUG: Stripe checkout URL: ${checkoutUrl}`);

    // Return the checkout URL to the client
    return new Response(JSON.stringify({
      success: true,
      checkout_url: checkoutUrl
    }), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    });

  } catch (error) {
    console.error('Error handling the request:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error'
    }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
});

// ----------
// FUNCTIONS
// ----------

// Fetch existing Stripe customer ID by email
async function fetchStripeCustomerId(email) {
  try {
    const customers = await stripe.customers.list({
      email
    });
    if (customers.data.length > 0) {
      return customers.data[0].id;
    }
    return null;
  } catch (err) {
    console.error('Error fetching Stripe customer ID:', err);
    throw new Error('Error fetching Stripe customer ID');
  }
}
  
async function fetchStripeCustomerIdFromUsersTable(supabase, userId) {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('stripe_customer_id')
      .eq('user_id', userId)
      .single();

    if (error) {
      console.error('Error fetching from users table:', error);
      throw new Error('Failed to fetch user');
    }

    return data?.stripe_customer_id || null;
  } catch (err) {
    console.error('Error fetching Stripe customer ID from users table:', err);
    throw new Error('Error fetching Stripe customer ID');
  }
}


async function updateStripeCustomerIdInUsersTable(supabase, userId, stripeCustomerId) {
  try {
    const { error } = await supabase
      .from('users')
      .update({ stripe_customer_id: stripeCustomerId })
      .eq('user_id', userId);

    if (error) {
      console.error('Error updating stripe_customer_id:', error);
      throw new Error('Failed to update Stripe customer ID');
    }
  } catch (err) {
    console.error('Exception while updating Stripe customer ID:', err);
    throw new Error('Error updating users table');
  }
}

async function getOrCreateStripeCustomerId({
  supabaseClient,
  stripeClient,
  userId,
  userEmail,
  firstName = '',
  lastName = ''
}) {
  try {
    let stripeCustomerId = await fetchStripeCustomerIdFromUsersTable(supabaseClient, userId);
    console.log(`DEBUG: user stripe ID: ${stripeCustomerId}`);

    if (!stripeCustomerId) {
      stripeCustomerId = await createStripeCustomer(userEmail, userId, firstName, lastName);
      console.log(`DEBUG: new Stripe ID created: ${stripeCustomerId}`);

      await updateStripeCustomerIdInUsersTable(supabaseClient, userId, stripeCustomerId);
      console.log('Successfully updated users table with Stripe customer ID');
    }

    return stripeCustomerId;
  } catch (error) {
    console.error('Failed to get or create Stripe customer ID:', error.message);
    throw error;
  }
}

// Create a new Stripe customer
async function createStripeCustomer(email, userId, firstName, lastName) {
  try {
    const customer = await stripe.customers.create({
      email,
      // name: `${firstName} ${lastName}`,
      metadata: {
        user_id: userId
      }
    });
    return customer.id;
  } catch (err) {
    console.error('Error creating Stripe customer:', err);
    throw new Error('Error creating Stripe customer');
  }
}

var ProductType;
(function(ProductType) {
  ProductType["PURCHASE"] = "purchase";
  ProductType["SUBSCRIBE_MONTHLY"] = "subscribe_monthly";
  ProductType["SUBSCRIBE_YEARLY"] = "subscribe_yearly";
})(ProductType || (ProductType = {}));

// Helper function to get product details (price_id, quantity, mode) based on product type
function getProductDetails(productType) {
  switch(productType){
    case ProductType.PURCHASE:
      return {
        price_id: 'price_1RS6SPB2OiNJ3WZg69w688ZG',
        quantity: 1,
        mode: 'payment'
      };
    case ProductType.SUBSCRIBE_MONTHLY:
      return {
        price_id: 'price_1RS6MZB2OiNJ3WZgO4hTys2G',
        quantity: 1,
        mode: 'subscription'
      };
    case ProductType.SUBSCRIBE_YEARLY:
      return {
        price_id: 'price_1RS6VTB2OiNJ3WZg5YnHvsGv',
        quantity: 1,
        mode: 'subscription'
      };
    default:
      throw new Error('Invalid product type');
  }
}

// Create a Stripe checkout session
async function createCheckoutSession(stripeCustomerId, price_id, quantity, mode) {
  try {
    const session = await stripe.checkout.sessions.create({
      customer: stripeCustomerId,
      line_items: [
        {
          price: price_id,
          quantity: quantity
        }
      ],
      mode: mode,
      success_url: 'https://example.com/success',
      cancel_url: 'https://example.com/cancel'
    });
    return session.url;
  } catch (err) {
    console.error('Error creating Stripe checkout session:', err);
    throw new Error('Error creating checkout session');
  }
}
