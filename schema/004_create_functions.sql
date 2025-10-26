-- ================================================================
-- Create Utility Functions and Triggers
-- ================================================================

-- Function to update updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update conversations.updated_at
DROP TRIGGER IF EXISTS update_conversations_updated_at ON conversations;
CREATE TRIGGER update_conversations_updated_at
  BEFORE UPDATE ON conversations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function to clean up expired conversation files
CREATE OR REPLACE FUNCTION cleanup_expired_files()
RETURNS TABLE(deleted_count BIGINT) AS $$
DECLARE
  count_deleted BIGINT;
BEGIN
  DELETE FROM conversation_files WHERE expires_at < NOW();
  GET DIAGNOSTICS count_deleted = ROW_COUNT;
  RETURN QUERY SELECT count_deleted;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION cleanup_expired_files() IS 'Deletes expired conversation files (run via cron/scheduler)';

-- Function to get conversation statistics
CREATE OR REPLACE FUNCTION get_conversation_stats(conv_id BIGINT)
RETURNS TABLE(
  message_count BIGINT,
  user_message_count BIGINT,
  assistant_message_count BIGINT,
  first_message_at TIMESTAMP WITH TIME ZONE,
  last_message_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*)::BIGINT as message_count,
    COUNT(*) FILTER (WHERE role = 'user')::BIGINT as user_message_count,
    COUNT(*) FILTER (WHERE role = 'assistant')::BIGINT as assistant_message_count,
    MIN(created_at) as first_message_at,
    MAX(created_at) as last_message_at
  FROM messages
  WHERE conversation_id = conv_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_conversation_stats(BIGINT) IS 'Get statistics for a specific conversation';

-- Function to search documents by similarity
CREATE OR REPLACE FUNCTION search_similar_documents(
  query_embedding vector(1536),
  agent_filter INTEGER,
  result_limit INTEGER DEFAULT 5
)
RETURNS TABLE(
  chunk_id BIGINT,
  file_id BIGINT,
  filename VARCHAR(255),
  content TEXT,
  similarity FLOAT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    dc.id as chunk_id,
    dc.file_id,
    f.filename,
    dc.content,
    1 - (dc.embedding <=> query_embedding) as similarity
  FROM document_chunks dc
  JOIN files f ON dc.file_id = f.id
  WHERE dc.agent_id = agent_filter
    AND dc.embedding IS NOT NULL
  ORDER BY dc.embedding <=> query_embedding
  LIMIT result_limit;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION search_similar_documents(vector(1536), INTEGER, INTEGER) IS 'Semantic search using vector similarity (cosine distance)';

-- Verification
DO $$
BEGIN
  RAISE NOTICE '✓ Created utility functions and triggers';
  RAISE NOTICE '  - update_updated_at_column() trigger function';
  RAISE NOTICE '  - cleanup_expired_files() cleanup function';
  RAISE NOTICE '  - get_conversation_stats() stats function';
  RAISE NOTICE '  - search_similar_documents() vector search function';
END $$;
