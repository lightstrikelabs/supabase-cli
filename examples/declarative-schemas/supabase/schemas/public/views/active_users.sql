-- View referencing the users table
-- Tests: view security settings preservation (#3973)

CREATE OR REPLACE VIEW public.active_users
WITH (security_invoker = true)
AS
  SELECT
    id,
    display_name,
    email,
    role,
    created_at
  FROM public.users
  WHERE is_active = true;
