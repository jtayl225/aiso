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
