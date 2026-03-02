-- RLS policies using get_user_role() function
-- Tests: policy depends on function
-- Tests: ALTER POLICY detection (modify condition and verify diff)

CREATE POLICY users_select_own ON public.users
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY users_select_admin ON public.users
  FOR SELECT
  USING (public.get_user_role(auth.uid()) IN ('admin'::public.user_role, 'moderator'::public.user_role));

CREATE POLICY users_update_own ON public.users
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY users_insert_admin ON public.users
  FOR INSERT
  WITH CHECK (public.get_user_role(auth.uid()) = 'admin'::public.user_role);

CREATE POLICY users_delete_admin ON public.users
  FOR DELETE
  USING (public.get_user_role(auth.uid()) = 'admin'::public.user_role);
