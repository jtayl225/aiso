-- Lookup table for industries
CREATE TABLE IF NOT EXISTS industries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

-- Optional: index on (deleted_at) for efficient filtering of “active” industries
CREATE INDEX IF NOT EXISTS idx_industries_deleted_at
  ON industries(deleted_at);
