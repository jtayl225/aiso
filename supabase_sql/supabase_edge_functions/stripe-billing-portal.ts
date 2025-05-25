import { createClient } from 'jsr:@supabase/supabase-js@2';
import Stripe from 'https://esm.sh/stripe@14?target=denonext';

const stripeKey = Deno.env.get('STRIPE_API_KEY');
const stripe = new Stripe(stripeKey, {apiVersion: "2025-04-30.basil"});

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const supabase = createClient(supabaseUrl, supabaseKey);

Deno.serve(async (req) => {
  console.log("DEBUG: request received:", req.method);
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    console.log("OPTIONS request received");
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Authorization, Content-Type, apikey, x-client-info'
      },
    });
  }

  if (req.method !== "POST") {
    console.log("DEBUG: not POST request");
    return new Response("Method Not Allowed", {
      status: 405
    });
  }

  // Require Authorization header
  console.log("DEBUG: about to check Authorization header.");
  const authHeader = req.headers.get('Authorization');
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return new Response('Unauthorized', { status: 401 });
  }
  console.log("DEBUG: Authorization header received:", authHeader);

  try {
    // Get the session or user object
    const token = authHeader.replace('Bearer ', '');
    const { data } = await supabase.auth.getUser(token);
    const user = data.user;
    console.log(`DEBUG: user ID: ${user.id}`);
    console.log(`DEBUG: user email: ${user.email}`);

    // Lookup user’s Stripe customer ID
    const { data: userRecord, error: dbError } = await supabase
      .from('users')
      .select('stripe_customer_id')
      .eq('user_id', user.id)
      .single();

    if (dbError || !userRecord?.stripe_customer_id) {
      console.error('User not found or missing Stripe ID:', dbError);
      return new Response('Stripe customer not found', { status: 404 });
    }

    console.log(`DEBUG: stripe customer ID found: ${userRecord?.stripe_customer_id}`); 

    // Create a billing portal session
    const session = await stripe.billingPortal.sessions.create({
      customer: userRecord.stripe_customer_id,
      return_url: 'https://example.com/success', // ✅ Replace with your actual return URL
    });

    console.log(`DEBUG: stripe billin gportal URL: ${session.url}`);

    return new Response(JSON.stringify({ url: session.url }), {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
    });
  } catch (error) {
    console.error('Internal error:', error);
    return new Response(JSON.stringify({ error: 'Internal Server Error' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
    });
  }
});
