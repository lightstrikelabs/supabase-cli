-- Function accepting and returning composite type
-- Tests: composite type dependency (user_profile type must exist first)

CREATE OR REPLACE FUNCTION public.create_user(
  display_name text,
  email text,
  role public.user_role DEFAULT 'member'::public.user_role
)
RETURNS public.user_profile
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER
AS $$
DECLARE
  new_id uuid;
  result public.user_profile;
BEGIN
  INSERT INTO public.users (display_name, email, role)
  VALUES (display_name, email, role)
  RETURNING id INTO new_id;

  result := ROW(new_id, display_name, role, now())::public.user_profile;
  RETURN result;
END;
$$;
