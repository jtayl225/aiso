CREATE OR REPLACE VIEW recent_llm_prompt_results_vw AS
SELECT
	lpr.id AS llm_prompt_result_id,
  lpr.llm_run_id,
  lpr.prompt_id,
  lpr.epoch,

	-- entity details
	lpr.entity_type, 
	lpr.entity_rank,
	lpr.entity_name,
	lpr.entity_description,
	lpr.entity_url,

	-- timestamps
	lpr.created_at,

	lr.llm,
	lr.target_industry,
	lr.target_entity_type

FROM llm_prompt_results AS lpr
INNER JOIN llm_runs AS lr
	ON lr.id = lpr.llm_run_id
WHERE
	lr.status != 'failed'
	and lpr.created_at BETWEEN now() - interval '28 days' AND now()
	and lpr.deleted_at IS NULL
;



-- SELECT *
-- FROM recent_llm_prompt_results_vw
-- WHERE
--   target_industry = 'real estate'
--   AND target_entity_type = 'business'
--   AND prompt_id = 'your-prompt-id-here'
-- ;
