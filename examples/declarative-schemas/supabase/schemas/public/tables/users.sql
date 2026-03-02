-- Users table using custom types and UDF in CHECK constraint
-- Tests: #3483 — CHECK constraint references validate_email() function
-- Tests: custom enum type used as column type

CREATE TABLE IF NOT EXISTS public.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  display_name text NOT NULL,
  email text NOT NULL UNIQUE,
  role public.user_role NOT NULL DEFAULT 'member'::public.user_role,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT valid_email CHECK (public.validate_email(email))
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
