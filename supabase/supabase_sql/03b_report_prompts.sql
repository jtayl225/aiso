CREATE TABLE IF NOT EXISTS report_prompts (

  report_id uuid NOT NULL REFERENCES public.reports(id) ON DELETE CASCADE,
  prompt_id uuid NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,

  PRIMARY KEY (report_id, prompt_id)

);
