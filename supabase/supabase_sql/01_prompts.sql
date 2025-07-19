CREATE EXTENSION IF NOT EXISTS pgcrypto;

--------------------
-- prompts
--------------------
CREATE TABLE IF NOT EXISTS prompts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  locality_id UUID REFERENCES public.localities(id) ON DELETE SET NULL,
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

--------------------
-- prompt_grounding
--------------------
CREATE TABLE IF NOT EXISTS prompt_grounding (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prompt_id UUID REFERENCES public.prompts(id) ON DELETE CASCADE,
  entity_type entity_type NOT NULL, -- 👈 enum column
  grounding_text text NOT NULL,
  llm_grounding text, -- gemini
  llm_grounding_model text, -- gemini-2.5-pro

  -- timetsamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone

);

CREATE INDEX idx_prompt_grounding_prompt_id ON prompt_grounding(prompt_id);
