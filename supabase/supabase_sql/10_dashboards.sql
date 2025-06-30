CREATE SCHEMA IF NOT EXISTS dashboards;


CREATE OR REPLACE VIEW dashboards.dash_01_vw AS
SELECT

  a.id, 
  a.report_run_id,
  a.prompt_id,
  a.llm_epoch_id,
  a.status,
  a.target_found,
  a.target_rank,
  a.created_at,
  a.updated_at,
  a.deleted_at,

  c.llm_generation,

  d.report_id,
  d.created_at as report_run_date,

  e.prompt

FROM public.report_results AS a
INNER JOIN public.llm_epochs AS b
  ON a.llm_epoch_id = b.id
INNER JOIN public.llm_runs AS c
  ON b.llm_run_id = c.id
INNER JOIN public.report_runs AS d
  ON a.report_run_id = d.id
INNER JOIN prompts AS e
 ON a.prompt_id = e.id
WHERE
  a.status = 'completed'
;


--------------------
-- report_results
--------------------

CREATE TABLE IF NOT EXISTS report_results (
  -- IDs
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,
  llm_epoch_id uuid REFERENCES public.llm_epochs(id) ON DELETE CASCADE,

  -- data
  status text NOT NULL CHECK (status IN ('running', 'completed', 'failed')),
  target_found BOOL NOT NULL,
  target_rank INT NULL,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE report_results
ADD CONSTRAINT report_results_unique_key
UNIQUE (report_run_id, prompt_id, llm_epoch_id);