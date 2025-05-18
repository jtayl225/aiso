-- Create enum type
CREATE TYPE cadence AS ENUM ('hour', 'day', 'week', 'month');

-- create reports table
CREATE TABLE reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  title text NOT NULL,
  description text,
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
  template_id uuid REFERENCES public.prompt_templates(id) ON DELETE SET NULL,
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
  updated_at timestamp with time zone DEFAULT now()
);

CREATE INDEX idx_report_runs_report_id_status ON report_runs(report_id, status);



-- create report_results table
CREATE TYPE llm AS ENUM ('chatgpt', 'gemini');

CREATE TABLE report_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,
  llm llm NOT NULL,
  result_json jsonb,
  search_target_found BOOL NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  UNIQUE (run_id, report_id, prompt_id, llm)
);

CREATE OR REPLACE VIEW report_results_summary_vw AS
SELECT
  a.report_id,
  a.prompt_id,
  b.prompt,
  a.llm,
  SUM(CASE WHEN a.search_target_found THEN 1 ELSE 0 END) AS alpha,
  COUNT(*) AS n
FROM report_results AS a
INNER JOIN prompts AS b
  ON a.report_id = b.report_id
  AND a.prompt_id = b.id
WHERE a.deleted_at IS NULL
GROUP BY a.report_id, a.prompt_id, b.prompt, a.llm;




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


