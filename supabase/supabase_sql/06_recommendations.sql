--------------------
-- framework
--------------------

CREATE TABLE IF NOT EXISTS frameworks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE frameworks
ADD CONSTRAINT frameworks_unique_key
UNIQUE (name);

--------------------
-- framework_pillars
--------------------

CREATE TABLE IF NOT EXISTS framework_pillars (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  framework_id UUID NOT NULL REFERENCES frameworks(id) ON DELETE RESTRICT,
  name text NOT NULL CHECK (name IN ('experience','expertise','authoritativeness','trustworthiness','profile')),
  description text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE framework_pillars
ADD CONSTRAINT framework_pillars_unique_key
UNIQUE (framework_id, name);

--------------------
-- recommendations
--------------------
CREATE TABLE IF NOT EXISTS recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  industry_id UUID NOT NULL REFERENCES industries(id) ON DELETE RESTRICT,
  name text NOT NULL,
  description text NOT NULL,
  category text CHECK (category IN ('tech', 'non-tech')),
  cadence cadence, -- 👈 enum column
  effort INT NOT NULL,
  reward INT NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

--------------------
-- recommendation_framework_pillars
--------------------
CREATE TABLE IF NOT EXISTS recommendation_framework_pillars (
  recommendation_id uuid NOT NULL REFERENCES recommendations(id) ON DELETE RESTRICT,
  framework_pillar_id uuid NOT NULL REFERENCES framework_pillars(id) ON DELETE RESTRICT,
  PRIMARY KEY ( recommendation_id, framework_pillar_id )
);

--------------------
-- report run recommendations
--------------------
CREATE TABLE IF NOT EXISTS report_run_recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_run_id uuid REFERENCES public.report_runs(id) ON DELETE CASCADE,
  recommendation_id uuid REFERENCES public.recommendations(id) ON DELETE CASCADE,
  generated_comment text NOT NULL,
  is_done BOOL NOT NULL DEFAULT FALSE,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

--------------------
-- report run recommendations view
--------------------
CREATE OR REPLACE VIEW report_run_recommendations_vw AS
SELECT
  a.id,
  a.report_run_id,
  a.recommendation_id,
  a.generated_comment,
  a.is_done,
  a.created_at,
  a.updated_at,
  a.deleted_at,
  b.name,
  b.description,
  b.cadence,
  b.category,
  b.effort,
  b.reward,
  c.report_id
FROM report_run_recommendations AS a
INNER JOIN recommendations AS b
  ON a.recommendation_id = b.id
INNER JOIN report_runs AS c
  ON a.report_run_id = c.id
;

--------------------
-- report run recommendations view
--------------------
CREATE OR REPLACE VIEW recommendations_vw AS
SELECT
  *,
  random() AS rand
FROM recommendations
;


