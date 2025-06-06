--------------------
-- enums
--------------------

CREATE TYPE llm AS ENUM (
  'chatgpt',         -- OpenAI (GPT-3.5, GPT-4, GPT-4o)
  'gemini',          -- Google (Gemini 1.5, formerly Bard)
  'claude',          -- Anthropic (Claude 2, Claude 3)
  'mistral',         -- Mistral (Mistral 7B, Mixtral)
  'llama'            -- Meta (LLaMA 2, LLaMA 3)
  -- 'groq',            -- Groq (LLaMA 3 8B on Groq hardware)
  -- 'command-r',       -- Cohere (Command R+ for RAG)
  -- 'xgen',            -- Salesforce (XGen models)
  -- 'jurassic',        -- AI21 Labs (Jurassic-2)
  -- 'palm'             -- Older Google models (PaLM, PaLM 2)
);

CREATE TYPE entity_type AS ENUM ('product', 'service', 'business', 'person');

CREATE TYPE cadence AS ENUM ('hour', 'day', 'week', 'month');

--------------------
-- tables
--------------------

CREATE TABLE IF NOT EXISTS llm_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  -- search target details
  target_entity_type entity_type NOT NULL, -- 👈 enum column
  target_industry text NOT NULL,
  
  -- metadata
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone,
  status text NOT NULL CHECK (status IN ('pending', 'running', 'completed', 'failed')),
  error_message text,
  llm llm NOT NULL,
  llm_model TEXT NOT NULL DEFAULT 'unknown',
  result_json jsonb,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS llm_prompt_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  llm_run_id uuid REFERENCES public.llm_runs(id) ON DELETE CASCADE,
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,
  epoch INT NOT NULL,
  temperature DOUBLE PRECISION NOT NULL,

  -- entity details
  entity_type entity_type NOT NULL, 
  entity_rank INT NOT NULL,
  entity_name text NOT NULL,
  entity_description text NOT NULL,
  entity_url text NULL, -- optional

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE llm_prompt_results
ADD CONSTRAINT llm_prompt_results_unique_key
UNIQUE (llm_run_id, prompt_id, epoch, entity_rank);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS prompts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prompt text NOT NULL,

  -- automatically generated hash of normalised prompt
  prompt_hash text GENERATED ALWAYS AS (
    encode(digest(lower(trim(prompt)), 'sha256'), 'hex')
  ) STORED,

  -- timetsamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone

);

ALTER TABLE prompts ADD CONSTRAINT unique_prompt_hash UNIQUE (prompt_hash);
CREATE INDEX idx_prompts_prompt_hash ON prompts(prompt_hash);


CREATE TABLE IF NOT EXISTS report_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.reports(id) ON DELETE CASCADE,

  -- metadata
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone,
  status text NOT NULL CHECK (status IN ('pending', 'running', 'completed', 'failed')),
  error_message text,
  llm llm NOT NULL,
  llm_model TEXT NOT NULL DEFAULT 'unknown',
  result_json jsonb,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

CREATE INDEX idx_report_runs ON report_runs(report_id, llm, status);

CREATE TABLE IF NOT EXISTS report_prompt_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  llm_prompt_results_id uuid REFERENCES public.llm_prompt_results(id) ON DELETE CASCADE,
  report_run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  -- report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,
  epoch INT NOT NULL,
  search_target_found BOOL NOT NULL,
  search_target_rank INT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE report_prompt_results
ADD CONSTRAINT report_prompt_results_unique_key
UNIQUE (llm_prompt_results_id, report_run_id, prompt_id, epoch);

CREATE TABLE IF NOT EXISTS report_prompts (

  report_id uuid NOT NULL REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone

  PRIMARY KEY (report_id, prompt_id)

);

CREATE TABLE IF NOT EXISTS reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title text NOT NULL,
  cadence cadence, -- 👈 enum column

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  last_run_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS search_target (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  type entity_type, -- 👈 enum column
  industry text NOT NULL,
  name text NOT NULL,
  description text NOT NULL,
  url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS stripe_users (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  stripe_customer_id text UNIQUE NOT NULL,
  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

-- subscriptions
CREATE TABLE IF NOT EXISTS subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  -- user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Stripe references
  stripe_customer_id text NOT NULL REFERENCES public.stripe_users(stripe_customer_id),
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
-- views
--------------------

CREATE OR REPLACE VIEW report_prompt_results_summary_vw AS
SELECT
  rr.report_id,
  rr.id AS report_run_id, -- optional
  rpr.prompt_id,
  p.prompt,
  lr.llm,
  SUM(CASE WHEN rpr.search_target_found THEN 1 ELSE 0 END) AS alpha,
  COUNT(*) AS n,
  AVG(CASE WHEN rpr.search_target_found AND rpr.search_target_rank IS NOT NULL THEN rpr.search_target_rank END) AS mean_rank
FROM report_prompt_results AS rpr
INNER JOIN report_runs AS rr -- to get report_id
  ON rpr.report_run_id = rr.id
INNER JOIN prompts AS p -- to get prompt text
  ON rpr.prompt_id = p.id
INNER JOIN llm_prompt_results AS lpr -- to get llm_runs
  ON rpr.llm_prompt_results_id = lpr.id
INNER JOIN llm_runs AS lr -- to get llm
  ON lpr.llm_run_id = lr.id
WHERE
  rpr.deleted_at IS NULL
  AND rr.deleted_at IS NULL
  AND rr.status = 'completed'
GROUP BY 1,2,3,4
;

