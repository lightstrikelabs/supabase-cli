-- Function returning custom enum type, used in RLS policy
-- Tests: custom type dependency (user_role enum must exist first)
-- Tests: RLS policy depends on this function

CREATE OR REPLACE FUNCTION public.get_user_role(user_id uuid)
RETURNS public.user_role
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  result public.user_role;
BEGIN
  SELECT role INTO result
  FROM public.users
  WHERE id = user_id;
  RETURN COALESCE(result, 'guest'::public.user_role);
END;
$$;
