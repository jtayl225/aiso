-- subscriptions
CREATE TABLE IF NOT EXISTS subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  -- user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Stripe references
  stripe_customer_id text NOT NULL REFERENCES public.stripe_users(stripe_customer_id) ON DELETE CASCADE,
  stripe_subscription_id text UNIQUE NOT NULL,
  stripe_price_id text,
  stripe_product_id text,
  stripe_quantity int,

  -- Stripe status (e.g., active, trialing, canceled)
  stripe_status text NOT NULL,

  -- Key stripe timestamps 
  stripe_created timestamptz NOT NULL DEFAULT now(),
  stripe_start_date  timestamptz NOT NULL, -- change from current_period_start
  stripe_ended_at timestamptz, -- current_period_end, can be NULL
  stripe_cancel_at timestamptz,
  stripe_canceled_at timestamptz,

  -- timestamps
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  deleted_at timestamp with time zone
);

CREATE INDEX idx_subscriptions_status ON subscriptions(stripe_status);
CREATE INDEX idx_subscriptions_stripe_customer_id ON subscriptions(stripe_customer_id);


--------------------
-- subscriptions_vw
--------------------
CREATE OR REPLACE VIEW subscriptions_vw AS
SELECT
  a.*,
  b.user_id
FROM subscriptions AS a
INNER JOIN stripe_users AS b
  ON a.stripe_customer_id = b.stripe_customer_id
;
