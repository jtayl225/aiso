--------------------
-- GEOMAX recommendations
--------------------
CREATE TABLE IF NOT EXISTS geomax_recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  title text NOT NULL,
  action text NOT NULL,
  description text NOT NULL,
  status text NOT NULL CHECK (status IN ('todo', 'doing', 'done')),
  category text NOT NULL CHECK (category IN ('tech', 'non-tech')),
  cadence text NOT NULL CHECK (cadence IN ('once', 'week', 'month', 'quarter', 'year')),
  effort INT NOT NULL CHECK (effort IN (1,2,3)),
  reward INT NOT NULL CHECK (reward IN (1,2,3)),
  framework_pillars text[] NOT NULL DEFAULT '{}',
  feedback INT NOT NULL DEFAULT 0 CHECK (feedback IN (-1,0,1)),
  llm_model TEXT NOT NULL DEFAULT 'unknown',
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  deleted_at timestamp with time zone
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_geomax_reco_report_run_id ON geomax_recommendations(report_run_id);

--------------------
-- GEOMAX recommendations view
--------------------
CREATE OR REPLACE VIEW geomax_recommendations_vw AS
SELECT
  a.id,
  a.report_run_id,
  a.title,
  a.action,
  a.description,
  a.status,
  a.category,
  a.cadence,
  a.effort,
  a.reward,
  a.framework_pillars,
  a.feedback,
  a.llm_model,
  a.created_at,
  a.updated_at,
  a.deleted_at,

  b.report_id,

  c.locality_id,
  c.user_id

FROM geomax_recommendations AS a
INNER JOIN report_runs AS b
  ON a.report_run_id = b.id
INNER JOIN reports AS c
  ON b.report_id = c.id
WHERE
  b.status = 'completed'
;