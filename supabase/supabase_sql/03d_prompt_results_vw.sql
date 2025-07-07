CREATE OR REPLACE VIEW prompt_results_vw AS

SELECT 
  a.id, -- AS result_id,
  a.llm_epoch_id,
  a.entity_type, 
  a.entity_rank,
  a.entity_name,
  a.entity_description,
  a.entity_url,

  b.llm_run_id,
  b.epoch,

  c.llm_generation,

  -- d.id AS report_result_id,
  d.report_run_id,
  d.prompt_id,
  -- d.target_found,
  -- d.target_rank,
  -- d.status AS report_result_status,
  d.created_at,
  d.updated_at,
  d.deleted_at,

  e.report_id,

  CASE
    WHEN d.target_found IS TRUE AND a.entity_rank = d.target_rank THEN TRUE 
    ELSE FALSE 
  END AS is_target

FROM llm_results AS a
INNER JOIN llm_epochs AS b
  ON a.llm_epoch_id = b.id
INNER JOIN llm_runs AS c
  ON b.llm_run_id = c.id
INNER JOIN report_results AS d
  ON a.llm_epoch_id = d.llm_epoch_id
INNER JOIN report_runs AS e
  ON d.report_run_id = e.id

WHERE
  c.status = 'completed'
  AND a.deleted_at IS NULL
  AND b.deleted_at IS NULL
  AND d.deleted_at IS NULL
  AND e.deleted_at IS NULL
;


