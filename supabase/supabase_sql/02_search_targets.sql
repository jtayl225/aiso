CREATE TABLE IF NOT EXISTS search_targets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  industry_id UUID NOT NULL REFERENCES industries(id) ON DELETE RESTRICT,
  entity_type entity_type, -- 👈 enum column
  name text NOT NULL,
  description text NOT NULL,
  url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE search_targets
ADD CONSTRAINT search_targets_unique_key
UNIQUE (user_id, industry_id, entity_type, name, description);

CREATE INDEX idx_search_targets_user_industry
ON search_targets(user_id, industry_id);
