-- Create enum type
CREATE TYPE cadence AS ENUM ('hour', 'day', 'week', 'month');

-- create reports table
CREATE TABLE reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  title text NOT NULL,
  description text,
  cadence cadence, -- 👈 enum column
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  last_run_at timestamp with time zone
);

-- create prompt templates table
CREATE TABLE prompt_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  raw_prompt text NOT NULL,
  subject text NOT NULL,
  context text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone DEFAULT NULL
);

-- insert values
INSERT INTO prompt_templates (raw_prompt, subject, context)
VALUES
  ('Top {subject} in {context}.', 'Real Estate Agency', 'Frankston'),
  ('Best {subject} for {context}.', 'Sports Bra', 'Netball'),
  ('Affordable {subject} in {context}.', 'gym memberships', 'Sydney'),
  ('Where to buy {subject} in {context}?', 'Decaf coffee', 'Brisbane')
 ;

-- create prompts table
CREATE TABLE prompts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid REFERENCES public.reports(id),
  template_id uuid REFERENCES public.prompt_templates(id) ON DELETE SET NULL,
  raw_prompt text, -- could be NULL if a template was not used,
  formatted_prompt text NOT NULL,
  subject text NOT NULL,
  context text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  last_run_at timestamp with time zone
);

-- create search_target table
CREATE TYPE search_target_type AS ENUM ('product', 'service', 'business', 'person');

CREATE TABLE search_target (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid REFERENCES public.reports(id) ON DELETE CASCADE,
  type search_target_type, -- 👈 enum column
  name text NOT NULL,
  description text NOT NULL,
  url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);
