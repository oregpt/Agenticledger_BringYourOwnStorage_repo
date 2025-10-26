-- ================================================================
-- Enable Required PostgreSQL Extensions
-- ================================================================

-- Enable pgvector for AI/vector embeddings
CREATE EXTENSION IF NOT EXISTS vector;

-- Enable UUID generation (optional, for future use)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Verify extensions
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'vector') THEN
    RAISE EXCEPTION 'pgvector extension not found. Please install it first.';
  END IF;
  RAISE NOTICE '✓ pgvector extension enabled';
END $$;
