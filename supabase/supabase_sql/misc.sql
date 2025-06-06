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
