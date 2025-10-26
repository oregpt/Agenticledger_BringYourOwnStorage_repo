-- ================================================================
-- Create AgenticLedger Customer Database Tables
-- ================================================================

-- Table 1: Files (uploaded documents and knowledge base files)
CREATE TABLE IF NOT EXISTS files (
  id BIGSERIAL PRIMARY KEY,
  agent_id INTEGER NOT NULL,
  filename VARCHAR(255) NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  size INTEGER NOT NULL,
  content TEXT,
  uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT files_filename_check CHECK (length(filename) > 0),
  CONSTRAINT files_size_check CHECK (size >= 0)
);

COMMENT ON TABLE files IS 'Uploaded documents and knowledge base files';
COMMENT ON COLUMN files.agent_id IS 'Reference to agent in platform database';
COMMENT ON COLUMN files.content IS 'Extracted text content from file';

-- Table 2: Document chunks (text chunks with vector embeddings for RAG)
CREATE TABLE IF NOT EXISTS document_chunks (
  id BIGSERIAL PRIMARY KEY,
  file_id BIGINT NOT NULL,
  agent_id INTEGER NOT NULL,
  chunk_index INTEGER NOT NULL,
  content TEXT NOT NULL,
  embedding vector(1536),  -- OpenAI ada-002 embeddings (1536 dimensions)
  token_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT document_chunks_chunk_index_check CHECK (chunk_index >= 0),
  CONSTRAINT document_chunks_token_count_check CHECK (token_count >= 0 OR token_count IS NULL),

  CONSTRAINT document_chunks_file_id_fkey
    FOREIGN KEY (file_id)
    REFERENCES files(id)
    ON DELETE CASCADE
);

COMMENT ON TABLE document_chunks IS 'Text chunks with vector embeddings for semantic search';
COMMENT ON COLUMN document_chunks.embedding IS 'Vector embedding (1536-dim for OpenAI ada-002)';
COMMENT ON COLUMN document_chunks.chunk_index IS 'Position of chunk in original document';

-- Table 3: Conversations (chat sessions)
CREATE TABLE IF NOT EXISTS conversations (
  id BIGSERIAL PRIMARY KEY,
  agent_id INTEGER NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  title VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT conversations_user_id_check CHECK (length(user_id) > 0)
);

COMMENT ON TABLE conversations IS 'Chat sessions between users and AI agents';
COMMENT ON COLUMN conversations.user_id IS 'Reference to user in platform database';

-- Table 4: Messages (chat messages with review tracking)
CREATE TABLE IF NOT EXISTS messages (
  id BIGSERIAL PRIMARY KEY,
  conversation_id BIGINT NOT NULL,
  role VARCHAR(20) NOT NULL,
  content TEXT NOT NULL,
  attachments JSONB,
  agent_summaries JSONB,
  reviewed_at TIMESTAMP WITH TIME ZONE,
  reviewer_id VARCHAR(255),
  review_notes TEXT,
  review_status VARCHAR(50) DEFAULT 'unreviewed',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT messages_role_check CHECK (role IN ('user', 'assistant', 'system')),
  CONSTRAINT messages_review_status_check CHECK (
    review_status IN ('unreviewed', 'reviewed', 'flagged', 'approved', 'rejected')
  ),

  CONSTRAINT messages_conversation_id_fkey
    FOREIGN KEY (conversation_id)
    REFERENCES conversations(id)
    ON DELETE CASCADE
);

COMMENT ON TABLE messages IS 'Chat messages with review tracking capabilities';
COMMENT ON COLUMN messages.role IS 'Message sender: user, assistant, or system';
COMMENT ON COLUMN messages.agent_summaries IS 'Contribution summaries for team assistants';
COMMENT ON COLUMN messages.review_status IS 'Review workflow status';

-- Table 5: Conversation files (temporary file attachments)
CREATE TABLE IF NOT EXISTS conversation_files (
  id BIGSERIAL PRIMARY KEY,
  conversation_id BIGINT NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  file_size INTEGER NOT NULL,
  content TEXT,
  uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW() + INTERVAL '24 hours',

  CONSTRAINT conversation_files_file_size_check CHECK (file_size >= 0),
  CONSTRAINT conversation_files_expires_check CHECK (expires_at > uploaded_at),

  CONSTRAINT conversation_files_conversation_id_fkey
    FOREIGN KEY (conversation_id)
    REFERENCES conversations(id)
    ON DELETE CASCADE
);

COMMENT ON TABLE conversation_files IS 'Temporary file attachments that auto-expire after 24 hours';
COMMENT ON COLUMN conversation_files.expires_at IS 'Automatic expiration timestamp (24 hours from upload)';
COMMENT ON COLUMN conversation_files.content IS 'Extracted text content for AI processing';

-- Verification
DO $$
DECLARE
  table_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO table_count
  FROM information_schema.tables
  WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
    AND table_name IN ('files', 'document_chunks', 'conversations', 'messages', 'conversation_files');

  IF table_count = 5 THEN
    RAISE NOTICE '✓ All 5 tables created successfully';
  ELSE
    RAISE WARNING 'Expected 5 tables, found %', table_count;
  END IF;
END $$;
