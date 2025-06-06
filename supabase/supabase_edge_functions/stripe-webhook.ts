import { createClient } from 'jsr:@supabase/supabase-js@2';
import Stripe from 'https://esm.sh/stripe@14?target=denonext';

const stripeKey = Deno.env.get('STRIPE_API_KEY');
const stripe = new Stripe(stripeKey, {apiVersion: "2025-04-30.basil"});

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const supabase = createClient(supabaseUrl, supabaseKey);

// This is needed in order to use the Web Crypto API in Deno.
const cryptoProvider = Stripe.createSubtleCryptoProvider();
console.log('Hello from Stripe Webhook!');

Deno.serve(async (request)=>{
  const signature = request.headers.get('Stripe-Signature');
  // First step is to verify the event. The .text() method must be used as the
  // verification relies on the raw request body rather than the parsed JSON.
  const body = await request.text();
  let receivedEvent;
  try {

    receivedEvent = await stripe.webhooks.constructEventAsync(body, signature, Deno.env.get('STRIPE_WEBHOOK_SIGNING_SECRET'), undefined, cryptoProvider);

    if (receivedEvent.type === 'customer.subscription.created') {
      await handleSubscriptionCreated(receivedEvent);
    }

    if (receivedEvent.type === 'customer.subscription.deleted') {
      await handleSubscriptionDeleted(receivedEvent);
    }

    if (receivedEvent.type === 'customer.subscription.updated') {
      await handleSubscriptionUpdated(receivedEvent);
    }

  } catch (err) {
    return new Response(err.message, {
      status: 400
    });
  }
  console.log(`🔔 Event received: ${receivedEvent.type}`);
  return new Response(JSON.stringify({
    ok: true
  }), {
    status: 200
  });
});

// ----------
// funcitons
// ----------

export async function handleSubscriptionCreated(event: Stripe.Event) {
  const subscription = event.data.object as Stripe.Subscription;

  const stripeCustomerId = subscription.customer as string;
  const stripeSubscriptionId = subscription.id;
  const price = subscription.items.data[0]?.price;
  const quantity = subscription.quantity;
  const status = subscription.status;
  const startDate = subscription.start_date != null
    ? new Date(subscription.start_date * 1000)
    : new Date(); // fallback to now
  const endedAt = subscription.ended_at != null
    ? new Date(subscription.ended_at * 1000)
    : null;
  const created = subscription.created != null
    ? new Date(subscription.created * 1000)
    : new Date();
  const cancelAt = subscription.cancel_at != null
    ? new Date(subscription.cancel_at * 1000)
    : null;
  const canceledAt = subscription.canceled_at != null
    ? new Date(subscription.canceled_at * 1000)
    : null;

  const stripePriceId = price?.id ?? null;
  const stripeProductId = price?.product ?? null;

  // Get user from your Supabase users table
  const { data: user, error: userError } = await supabase
    .from('users')
    .select('user_id')
    .eq('stripe_customer_id', stripeCustomerId)
    .single();

  if (userError || !user) {
    console.error('Error fetching user for Stripe customer:', userError);
    return;
  }

  // Insert or update subscription record
  const { error: insertError } = await supabase
    .from('subscriptions')
    .upsert({
      user_id: user.user_id,
      stripe_customer_id: stripeCustomerId,
      stripe_subscription_id: stripeSubscriptionId,
      stripe_price_id: stripePriceId,
      stripe_product_id: stripeProductId as string,
      stripe_quantity: quantity as int,
      stripe_status: status,
      stripe_created: created.toISOString(),
      stripe_start_date: startDate.toISOString(),
      stripe_ended_at: endedAt?.toISOString(),
      stripe_cancel_at: cancelAt?.toISOString() ?? null,
      stripe_canceled_at: canceledAt?.toISOString() ?? null,
    }, { onConflict: 'stripe_subscription_id' });

  if (insertError) {
    console.error('Failed to upsert subscription:', insertError);
  } else {
    console.log('Successfully recorded Stripe subscription.');
  }
}

export async function handleSubscriptionDeleted(event: Stripe.Event) {
  const subscription = event.data.object as Stripe.Subscription;

  const stripeSubscriptionId = subscription.id;
  const canceledAt = subscription.canceled_at
    ? new Date(subscription.canceled_at * 1000)
    : new Date(); // fallback to now

  const status = subscription.status ?? 'canceled';

  // Update your subscriptions table
  const { error } = await supabase
    .from('subscriptions')
    .update({
      stripe_status: status,
      stripe_canceled_at: canceledAt.toISOString(),
    })
    .eq('stripe_subscription_id', stripeSubscriptionId);

  if (error) {
    console.error(`Failed to update subscription ${stripeSubscriptionId} as canceled:`, error);
  } else {
    console.log(`Subscription ${stripeSubscriptionId} marked as canceled.`);
  }
}

export async function handleSubscriptionUpdated(event: Stripe.Event) {
  const subscription = event.data.object as Stripe.Subscription;

  const stripeSubscriptionId = subscription.id;
  const stripeCustomerId = subscription.customer as string;
  const price = subscription.items.data[0]?.price;
  const stripePriceId = price?.id ?? null;
  const stripeProductId = price?.product ?? null;
  const quantity = subscription.quantity;
  const status = subscription.status;
  const cancelAt = subscription.cancel_at
    ? new Date(subscription.cancel_at * 1000).toISOString()
    : null;
  const canceledAt = subscription.canceled_at
    ? new Date(subscription.canceled_at * 1000).toISOString()
    : null;
  const startDate = subscription.start_date
    ? new Date(subscription.start_date * 1000).toISOString()
    : null;
  const endedAt = subscription.endedAt
    ? new Date(subscription.endedAt * 1000).toISOString()
    : null;

  const updateFields: Record<string, any> = {
    stripe_customer_id: stripeCustomerId,
    stripe_price_id: stripePriceId,
    stripe_product_id: stripeProductId as string,
    stripe_quantity: quantity as int,
    stripe_status: status,
    stripe_start_date: startDate,
    stripe_ended_at: endedAt,
    stripe_cancel_at: cancelAt,
    stripe_canceled_at: canceledAt,
  };

  const { error } = await supabase
    .from('subscriptions')
    .update(updateFields)
    .eq('stripe_subscription_id', stripeSubscriptionId);

  if (error) {
    console.error(`❌ Failed to update subscription ${stripeSubscriptionId}:`, error);
  } else {
    console.log(`✅ Subscription ${stripeSubscriptionId} updated.`);
  }
}
