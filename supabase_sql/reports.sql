-- create users table
CREATE TABLE users (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  stripe_customer_id text DEFAULT NULL,
  email text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);


-- Create enum type
CREATE TYPE cadence AS ENUM ('hour', 'day', 'week', 'month');

-- create reports table
CREATE TABLE reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  title text NOT NULL,
  -- description text,
  cadence cadence, -- 👈 enum column
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  last_run_at timestamp with time zone
);

-- create prompt templates table
CREATE TABLE prompt_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  raw_prompt text NOT NULL,
  subject text NOT NULL,
  context text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone DEFAULT NULL
);

-- insert values
INSERT INTO prompt_templates (raw_prompt, subject, context)
VALUES
  ('Top {subject} in {context}.', 'Real Estate Agency', 'Frankston'),
  ('Best {subject} for {context}.', 'Sports Bra', 'Netball'),
  ('Affordable {subject} in {context}.', 'gym memberships', 'Sydney'),
  ('Where to buy {subject} in {context}?', 'Decaf coffee', 'Brisbane')
 ;

-- create prompts table
-- CREATE TABLE prompts (
--   id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
--   report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
--   template_id uuid REFERENCES public.prompt_templates(id) ON DELETE SET NULL,
--   raw_prompt text, -- could be NULL if a template was not used,
--   formatted_prompt text NOT NULL,
--   subject text NOT NULL,
--   context text NOT NULL,
--   created_at timestamp with time zone DEFAULT now(),
--   updated_at timestamp with time zone DEFAULT now(),
--   deleted_at timestamp with time zone,
--   last_run_at timestamp with time zone
-- );

CREATE TABLE prompts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  -- template_id uuid REFERENCES public.prompt_templates(id) ON DELETE SET NULL,
  prompt text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  last_run_at timestamp with time zone
);

-- create search_target table
CREATE TYPE search_target_type AS ENUM ('product', 'service', 'business', 'person');

CREATE TABLE search_target (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  type search_target_type, -- 👈 enum column
  name text NOT NULL,
  description text NOT NULL,
  url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

-- Create report_runs table
CREATE TABLE report_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone,
  status text NOT NULL CHECK (status IN ('pending', 'running', 'completed', 'failed')),
  error_message text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

CREATE INDEX idx_report_runs_report_id_status ON report_runs(report_id, status);



-- create report_results table
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


CREATE TABLE report_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,
  epoch INT NOT NULL,
  temperature DOUBLE PRECISION NOT NULL,
  llm llm NOT NULL,
  llm_model TEXT NOT NULL DEFAULT 'unknown',
  search_target_found BOOL NOT NULL,
  search_target_rank INT,
  result_json jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  UNIQUE (run_id, report_id, prompt_id, epoch, llm)
);


CREATE TYPE entity_type AS ENUM ('product', 'service', 'business', 'person');

CREATE TABLE prompt_search_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,
  epoch INT NOT NULL,
  llm llm NOT NULL,
  -- entity details:
  entity_type entity_type NOT NULL, 
  rank INT NOT NULL,
  name text NOT NULL,
  description text NOT NULL,
  url text, -- optional
  -- result_json jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
);

ALTER TABLE prompt_search_results
DROP CONSTRAINT prompt_search_results_unique_key;

ALTER TABLE prompt_search_results
ADD CONSTRAINT prompt_search_results_unique_key
UNIQUE (run_id, report_id, prompt_id, epoch, llm, rank);


CREATE OR REPLACE VIEW report_results_summary_vw AS
SELECT
  a.report_id,
  a.prompt_id,
  b.prompt,
  a.llm,
  SUM(CASE WHEN a.search_target_found THEN 1 ELSE 0 END) AS alpha,
  COUNT(*) AS n,
  AVG(CASE WHEN a.search_target_found THEN a.search_target_rank END) AS mean_rank
FROM report_results AS a
INNER JOIN prompts AS b
  ON a.report_id = b.report_id
  AND a.prompt_id = b.id
WHERE
	a.deleted_at IS NULL
	AND b.deleted_at IS NULL
GROUP BY a.report_id, a.prompt_id, b.prompt, a.llm;


-- prompts results view
CREATE OR REPLACE VIEW prompt_results_vw AS
SELECT
  a.id,
  a.report_id,
  a.run_id,
  a.prompt_id,
  a.epoch,
  a.llm,
  a.entity_type,
  a.rank,
  a.name,
  a.description,
  CASE
    WHEN b.search_target_found IS FALSE THEN FALSE
    WHEN a.rank = b.search_target_rank THEN TRUE 
    ELSE FALSE 
  END AS is_target,
  a.url,
  a.created_at,
  a.updated_at,
  a.deleted_at
FROM public.prompt_search_results as a
INNER JOIN public.report_results as b
  ON a.report_id = b.report_id
  AND a.run_id = b.run_id
  AND a.prompt_id = b.prompt_id
  AND a.epoch = b.epoch
  AND a.llm = b.llm
ORDER BY a.epoch, a.rank
;

-- function to get reports to run
CREATE OR REPLACE FUNCTION get_due_reports(current_time timestamp with time zone)
RETURNS SETOF reports AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM reports
  WHERE deleted_at IS NULL
  AND (
    last_run_at IS NULL
    OR
    (cadence = 'hour' AND last_run_at <= current_time - interval '1 hour')
    OR
    (cadence = 'day' AND last_run_at <= current_time - interval '1 day')
    OR
    (cadence = 'week' AND last_run_at <= current_time - interval '7 days')
    OR
    (cadence = 'month' AND last_run_at <= current_time - interval '1 month')
  );
END;
$$ LANGUAGE plpgsql STABLE;


-- subscriptions
CREATE TABLE subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign key to your internal user
  user_id uuid REFERENCES users(user_id) ON DELETE CASCADE,

  -- Stripe references
  stripe_customer_id text NOT NULL,
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

  -- Metadata
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);



