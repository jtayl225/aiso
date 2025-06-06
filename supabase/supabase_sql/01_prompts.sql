CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS prompts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prompt text NOT NULL,

  -- automatically generated hash of normalised prompt
  prompt_hash text GENERATED ALWAYS AS (
    encode(digest(lower(trim(prompt)), 'sha256'), 'hex')
  ) STORED,

  -- timetsamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone

);

ALTER TABLE prompts ADD CONSTRAINT unique_prompt_hash UNIQUE (prompt_hash);
CREATE INDEX idx_prompts_prompt_hash ON prompts(prompt_hash);

