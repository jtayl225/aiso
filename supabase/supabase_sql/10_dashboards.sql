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
  d.created_at AS report_run_date,

  dd.locality_id as report_locality_id,
  dd.user_id,

  e.prompt,
  e.locality_id as prompt_locality_id,

  f.name AS prompt_locality_name,
  ff.name AS report_locality_name

FROM public.report_results AS a
INNER JOIN public.llm_epochs AS b
  ON a.llm_epoch_id = b.id
INNER JOIN public.llm_runs AS c
  ON b.llm_run_id = c.id
INNER JOIN public.report_runs AS d
  ON a.report_run_id = d.id
INNER JOIN public.reports AS dd
  ON d.report_id = dd.id
INNER JOIN prompts AS e
  ON a.prompt_id = e.id
LEFT JOIN localities AS f
  ON e.locality_id = f.id
LEFT JOIN localities AS ff
  ON dd.locality_id = ff.id
WHERE
  a.status = 'completed'
;
