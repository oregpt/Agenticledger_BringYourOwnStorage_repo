-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================

-- Regular agent indexes
CREATE INDEX IF NOT EXISTS idx_files_agent_id ON files(agent_id);
CREATE INDEX IF NOT EXISTS idx_document_chunks_agent_id ON document_chunks(agent_id);
CREATE INDEX IF NOT EXISTS idx_document_chunks_file_id ON document_chunks(file_id);

-- Advanced agent indexes
CREATE INDEX IF NOT EXISTS idx_advanced_folders_agent_id ON advanced_folders(agent_id);
CREATE INDEX IF NOT EXISTS idx_advanced_files_agent_id ON advanced_files(agent_id);
CREATE INDEX IF NOT EXISTS idx_advanced_files_folder_id ON advanced_files(folder_id);
CREATE INDEX IF NOT EXISTS idx_advanced_chunks_agent_id ON advanced_chunks(agent_id);
CREATE INDEX IF NOT EXISTS idx_advanced_chunks_file_id ON advanced_chunks(file_id);

-- Conversation indexes
CREATE INDEX IF NOT EXISTS idx_conversations_agent_id ON conversations(agent_id);
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);

-- Advanced conversation indexes
CREATE INDEX IF NOT EXISTS idx_advanced_conversations_agent_id ON advanced_conversations(agent_id);
CREATE INDEX IF NOT EXISTS idx_advanced_conversations_user_id ON advanced_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_advanced_messages_conversation_id ON advanced_messages(conversation_id);

-- External conversation indexes
CREATE INDEX IF NOT EXISTS idx_external_conversations_platform_id ON external_conversations(platform_id);
CREATE INDEX IF NOT EXISTS idx_external_conversations_agent_id ON external_conversations(agent_id);
CREATE INDEX IF NOT EXISTS idx_external_messages_conversation_id ON external_messages(conversation_id);

-- Unique constraint for external conversations (prevent duplicate platform-chat-agent combinations)
CREATE UNIQUE INDEX IF NOT EXISTS platform_chat_agent_unique
ON external_conversations(platform_id, external_chat_id, agent_id);

-- Vector similarity search index (HNSW for performance)
CREATE INDEX IF NOT EXISTS idx_advanced_chunks_embedding
ON advanced_chunks USING hnsw (embedding vector_cosine_ops);

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
