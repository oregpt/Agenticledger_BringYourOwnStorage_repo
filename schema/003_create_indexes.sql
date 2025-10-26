-- ================================================================
-- Create Indexes for Performance
-- ================================================================

-- Files table indexes
CREATE INDEX IF NOT EXISTS files_agent_id_idx ON files(agent_id);
CREATE INDEX IF NOT EXISTS files_uploaded_at_idx ON files(uploaded_at DESC);
CREATE INDEX IF NOT EXISTS files_mime_type_idx ON files(mime_type);

-- Document chunks indexes
CREATE INDEX IF NOT EXISTS document_chunks_agent_id_idx ON document_chunks(agent_id);
CREATE INDEX IF NOT EXISTS document_chunks_file_id_idx ON document_chunks(file_id);
CREATE INDEX IF NOT EXISTS document_chunks_created_at_idx ON document_chunks(created_at DESC);

-- Vector similarity index for semantic search
-- Using HNSW for better performance with OpenAI embeddings
CREATE INDEX IF NOT EXISTS document_chunks_embedding_idx
  ON document_chunks
  USING hnsw (embedding vector_cosine_ops);

-- Conversations indexes
CREATE INDEX IF NOT EXISTS conversations_agent_id_idx ON conversations(agent_id);
CREATE INDEX IF NOT EXISTS conversations_user_id_idx ON conversations(user_id);
CREATE INDEX IF NOT EXISTS conversations_created_at_idx ON conversations(created_at DESC);
CREATE INDEX IF NOT EXISTS conversations_updated_at_idx ON conversations(updated_at DESC);

-- Messages indexes
CREATE INDEX IF NOT EXISTS messages_conversation_id_idx ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS messages_created_at_idx ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS messages_review_status_idx ON messages(review_status);
CREATE INDEX IF NOT EXISTS messages_role_idx ON messages(role);

-- Conversation files indexes
CREATE INDEX IF NOT EXISTS conversation_files_conversation_id_idx ON conversation_files(conversation_id);
CREATE INDEX IF NOT EXISTS conversation_files_expires_at_idx ON conversation_files(expires_at);
CREATE INDEX IF NOT EXISTS conversation_files_uploaded_at_idx ON conversation_files(uploaded_at DESC);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS messages_conversation_role_idx ON messages(conversation_id, role);
CREATE INDEX IF NOT EXISTS document_chunks_agent_file_idx ON document_chunks(agent_id, file_id);

-- Verification
DO $$
DECLARE
  index_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO index_count
  FROM pg_indexes
  WHERE schemaname = 'public';

  RAISE NOTICE '✓ Created % indexes for performance', index_count;
END $$;
