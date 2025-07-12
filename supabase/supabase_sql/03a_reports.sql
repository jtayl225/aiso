CREATE TABLE IF NOT EXISTS reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  search_target_id NOT NULL REFERENCES public.search_targets(id) ON DELETE CASCADE,
  title text NOT NULL,
  is_paid BOOLEAN NOT NULL DEFAULT false,
  cadence cadence, -- 👈 enum column

  -- timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone,
  last_run_at timestamp with time zone
);