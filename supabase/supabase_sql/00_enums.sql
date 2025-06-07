--------------------
-- enums
--------------------

CREATE TYPE llm AS ENUM (
  'chatgpt',         -- OpenAI (GPT-3.5, GPT-4, GPT-4o)
  'gemini',          -- Google (Gemini 1.5, formerly Bard)
  'claude',          -- Anthropic (Claude 2, Claude 3)
  'mistral',         -- Mistral (Mistral 7B, Mixtral)
  'llama'            -- Meta (LLaMA 2, LLaMA 3)
  -- 'groq',            -- Groq (LLaMA 3 8B on Groq hardware)
  -- 'command-r',       -- Cohere (Command R+ for RAG)
  -- 'xgen',            -- Salesforce (XGen models)
  -- 'jurassic',        -- AI21 Labs (Jurassic-2)
  -- 'palm'             -- Older Google models (PaLM, PaLM 2)
);

CREATE TYPE entity_type AS ENUM ('product', 'service', 'business', 'person');

CREATE TYPE cadence AS ENUM ('hour', 'day', 'week', 'month');

CREATE TYPE processing_status AS ENUM (
  'initialising',   -- or 'initializing' if you prefer US spelling
  'running',        -- when the LLM calls are in flight
  'completed',      -- happy-path finish
  'failed'          -- any error case
);