CREATE SCHEMA IF NOT EXISTS dashboards;

--------------------
-- views
--------------------
-- OR REPLACE

CREATE MATERIALIZED VIEW dashboards.report_results_vw AS
SELECT
  
  -- report results
  report_results.id as report_results_id,
  report_results.report_run_id,
  report_results.prompt_id,
  report_results.target_found,
  report_results.target_rank,
  report_results.llm_epoch_id,

  -- report runs
  report_runs.report_id,

  -- reports
  reports.title,
  reports.user_id,

  -- prompts
  p.prompt,

  -- llm epochs
  llm_epochs.epoch,
  llm_epochs.llm_run_id,

  -- llm_runs
  llm_runs.llm_generation

FROM report_results
INNER JOIN report_runs
  ON report_results.report_run_id = report_runs.id
INNER JOIN reports
  ON report_runs.report_id = reports.id
INNER JOIN prompts AS p
  ON report_results.prompt_id = p.id
INNER JOIN llm_epochs
  ON report_results.llm_epoch_id = llm_epochs.id
INNER JOIN llm_runs
  ON llm_epochs.llm_run_id = llm_runs.id
WHERE
  report_results.deleted_at IS NULL
  AND report_results.status = 'completed'
  AND report_runs.deleted_at IS NULL
  AND report_runs.status = 'completed'
ORDER BY
  report_runs.report_id, report_results.report_run_id, llm_epochs.llm_run_id, llm_epochs.epoch
;
