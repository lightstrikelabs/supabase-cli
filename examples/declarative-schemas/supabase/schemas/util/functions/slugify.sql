-- Cross-schema utility function
-- Tests: #4314 — called by public.validate_email(), must be created first

CREATE OR REPLACE FUNCTION util.slugify(input text)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
  RETURN lower(regexp_replace(trim(input), '[^a-zA-Z0-9]+', '-', 'g'));
END;
$$;
