-- Custom types used across functions, tables, and policies
-- Tests: type dependency ordering (types must be created before objects that use them)

CREATE TYPE public.user_role AS ENUM ('admin', 'moderator', 'member', 'guest');

CREATE TYPE public.user_profile AS (
  id uuid,
  display_name text,
  role public.user_role,
  created_at timestamptz
);
