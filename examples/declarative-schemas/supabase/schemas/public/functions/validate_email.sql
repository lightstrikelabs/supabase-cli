-- Function used in CHECK constraint
-- Tests: #3483 — must be created before ALTER TABLE that references it
-- Tests: #4314 — depends on util.slugify() (cross-schema dependency)

CREATE OR REPLACE FUNCTION public.validate_email(email text)
RETURNS boolean
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  slug text;
BEGIN
  -- Cross-schema dependency: calls util.slugify()
  slug := util.slugify(split_part(email, '@', 1));
  RETURN email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    AND length(slug) > 0;
END;
$$;
