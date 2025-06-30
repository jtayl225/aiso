CREATE TABLE IF NOT EXISTS report_prompts (

  report_id uuid NOT NULL REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,

  PRIMARY KEY (report_id, prompt_id)

);

-- --------------------
-- -- report run recommendations view
-- --------------------
-- CREATE OR REPLACE VIEW report_prompts_vw AS
-- SELECT
--   a.report_id,
--   a.prompt_id as id,
--   a.created_at,
--   a.updated_at,
--   a.deleted_at,
--   b.prompt
-- FROM report_prompts AS a
-- INNER JOIN prompts AS b
--   ON a.recommendation_id = b.id
-- ;
