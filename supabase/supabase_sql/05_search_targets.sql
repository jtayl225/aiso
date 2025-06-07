CREATE TABLE IF NOT EXISTS search_targets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  industry_id UUID NOT NULL REFERENCES industries(id) ON DELETE RESTRICT,
  type entity_type, -- 👈 enum column
  name text NOT NULL,
  description text NOT NULL,
  url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

ALTER TABLE search_targets
ADD CONSTRAINT search_targets_unique_key
UNIQUE (report_id);

