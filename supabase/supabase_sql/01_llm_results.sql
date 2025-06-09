--------------------
-- llm_runs
--------------------

CREATE TABLE IF NOT EXISTS llm_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prompt_id uuid REFERENCES public.prompts(id) ON DELETE CASCADE,

  -- search target details
  target_entity_type entity_type NOT NULL, -- 👈 enum column
  target_entity_industry text NOT NULL,
  
  -- metadata
  is_paid BOOLEAN NOT NULL DEFAULT false,
  epochs INT NOT NULL, -- total number of epochs
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone,
  status processing_status NOT NULL DEFAULT 'initialising', -- 👈 enum column
  error_message text,
  llm_generation llm NOT NULL,
  llm_generation_model TEXT NOT NULL DEFAULT 'unknown',

  -- result_json jsonb,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

--------------------
-- llm_epochs
--------------------
CREATE TABLE IF NOT EXISTS llm_epochs (
  -- IDs
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  llm_run_id uuid REFERENCES public.llm_runs(id) ON DELETE CASCADE,

  -- data
  epoch INT NOT NULL,
  temperature DOUBLE PRECISION NOT NULL,
  status processing_status NOT NULL DEFAULT 'initialising', -- 👈 enum column

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone

);

ALTER TABLE llm_epochs
ADD CONSTRAINT llm_epochs_unique_key
UNIQUE (llm_run_id, epoch);

--------------------
-- llm_results
--------------------
CREATE TABLE IF NOT EXISTS llm_results (
  -- IDs
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  llm_epoch_id uuid REFERENCES public.llm_epochs(id) ON DELETE CASCADE,

  -- entity details
  entity_type entity_type NOT NULL, 
  entity_rank INT NOT NULL,
  entity_name text NOT NULL,
  entity_description text NOT NULL,
  entity_url text NULL, -- optional

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE llm_results
ADD CONSTRAINT llm_results_unique_key
UNIQUE (llm_epoch_id, entity_rank);

--------------------
-- llm_results_vw
--------------------
CREATE OR REPLACE VIEW public.llm_results_vw AS
SELECT
  -- IDs
  lr.id AS llm_run_id,
  le.id AS llm_epoch_id,
  res.id AS llm_result_id,

  -- Prompt and LLM metadata
  lr.prompt_id,
  lr.llm_generation,
  lr.llm_generation_model,
  lr.epochs AS total_epochs,
  lr.status AS run_status,
  lr.error_message,
  lr.target_entity_type,
  lr.target_entity_industry,

  -- Epoch metadata
  le.epoch,
  le.temperature,

  -- Result details
  res.entity_rank,
  res.entity_type,
  res.entity_name,
  res.entity_description,
  res.entity_url,

  -- Timestamps
  lr.created_at AS run_created_at,
  le.created_at AS epoch_created_at,
  res.created_at AS result_created_at

FROM llm_runs AS lr
INNER JOIN llm_epochs AS le 
  ON lr.id = le.llm_run_id
INNER JOIN llm_results AS res 
  ON le.id = res.llm_epoch_id

WHERE
  lr.deleted_at IS NULL
  AND le.deleted_at IS NULL
  AND res.deleted_at IS NULL
;

--------------------
-- recent_llm_runs_vw
--------------------
CREATE OR REPLACE VIEW recent_llm_runs_vw AS
SELECT
  id,
  prompt_id,

  -- search target details
  target_entity_type, 
  target_entity_industry,
  
  -- metadata
  epochs, 
  started_at,
  finished_at,
  status,
  error_message,
  llm_generation,
  llm_generation_model,

  -- result_json jsonb,

  -- timestamps
  created_at,
  updated_at,
  deleted_at

FROM llm_runs
WHERE
  created_at >= NOW() - INTERVAL '28 days'
  AND deleted_at IS NULL
  AND status != 'failed'
;

--------------------
-- llm_results_with_epochs_vw
--------------------

CREATE OR REPLACE VIEW llm_results_with_epochs_vw AS
SELECT 
  lr.*,
  le.llm_run_id,
  le.status AS epoch_status,
  le.epoch,
  le.temperature,
  le.created_at AS epoch_created_at,
  le.updated_at AS epoch_updated_at
FROM public.llm_results lr
INNER JOIN public.llm_epochs le 
  ON lr.llm_epoch_id = le.id
;

