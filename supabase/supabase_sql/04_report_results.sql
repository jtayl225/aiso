--------------------
-- report_runs
--------------------
CREATE TYPE report_run_status AS ENUM (
  'initialising',
  'generating',
  'searching',
  'completed',
  'failed'
);


CREATE TABLE IF NOT EXISTS report_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.reports(id) ON DELETE CASCADE,

  -- metadata
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone,
  status report_run_status NOT NULL DEFAULT 'initialising';
  error_message text,
  llm_classification llm NOT NULL,
  llm_classification_model TEXT NOT NULL DEFAULT 'unknown',
  -- result_json jsonb,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

CREATE INDEX idx_report_runs ON report_runs(report_id, llm_classification, status);

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

