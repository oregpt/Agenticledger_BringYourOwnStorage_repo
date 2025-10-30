-- ============================================================
-- AgenticLedger Mode 3 (Customer-Hosted Database) Schema
-- Complete schema for all 12 tables that store customer data
-- ============================================================

-- ============================================================
-- REGULAR/LEGACY AGENT TABLES (File-based agents)
-- ============================================================

-- Files table (for regular file-based agents)
CREATE TABLE IF NOT EXISTS files (
  id SERIAL PRIMARY KEY,
  agent_id INTEGER NOT NULL,
  filename VARCHAR(255) NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  size INTEGER NOT NULL,
  content TEXT,
  uploaded_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE files IS 'Uploaded documents and knowledge base files for regular agents';
COMMENT ON COLUMN files.agent_id IS 'Reference to agent in platform database';
COMMENT ON COLUMN files.content IS 'Extracted text content from file';

-- Document chunks (for regular agents)
CREATE TABLE IF NOT EXISTS document_chunks (
  id SERIAL PRIMARY KEY,
  file_id INTEGER NOT NULL,
  agent_id INTEGER NOT NULL,
  chunk_index INTEGER NOT NULL,
  content TEXT NOT NULL,
  embedding TEXT,
  token_count INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE document_chunks IS 'Text chunks for regular file-based agents';
COMMENT ON COLUMN document_chunks.embedding IS 'Vector embedding stored as JSON array text';
COMMENT ON COLUMN document_chunks.chunk_index IS 'Position of chunk in original document';

-- ============================================================
-- ADVANCED KNOWLEDGE AGENT TABLES (Advanced file management)
-- ============================================================

-- Advanced folders (folder structure for advanced agents)
CREATE TABLE IF NOT EXISTS advanced_folders (
  id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
  agent_id INTEGER NOT NULL,
  name VARCHAR NOT NULL,
  parent_folder_id VARCHAR,
  path VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE advanced_folders IS 'Folder structure for advanced knowledge agents';
COMMENT ON COLUMN advanced_folders.path IS 'Full folder path for quick lookups';
COMMENT ON COLUMN advanced_folders.parent_folder_id IS 'Parent folder ID for hierarchical structure';

-- Advanced files (files for advanced knowledge agents)
CREATE TABLE IF NOT EXISTS advanced_files (
  id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
  agent_id INTEGER NOT NULL,
  folder_id VARCHAR,
  original_name VARCHAR NOT NULL,
  stored_path VARCHAR NOT NULL,
  size INTEGER NOT NULL,
  mime_type VARCHAR NOT NULL,
  processing_status VARCHAR DEFAULT 'pending',
  chunk_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE advanced_files IS 'Files for advanced knowledge agents with folder organization';
COMMENT ON COLUMN advanced_files.processing_status IS 'File processing status: pending, processing, completed, failed';
COMMENT ON COLUMN advanced_files.chunk_count IS 'Number of chunks created from this file';

-- Advanced processing jobs (background file processing)
CREATE TABLE IF NOT EXISTS advanced_processing_jobs (
  id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
  file_id VARCHAR NOT NULL,
  agent_id INTEGER NOT NULL,
  status VARCHAR DEFAULT 'queued',
  priority INTEGER DEFAULT 1,
  error TEXT,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE advanced_processing_jobs IS 'Background processing jobs for advanced agent files';
COMMENT ON COLUMN advanced_processing_jobs.status IS 'Job status: queued, processing, completed, failed';
COMMENT ON COLUMN advanced_processing_jobs.priority IS 'Job priority (higher number = higher priority)';

-- Advanced chunks (with vector embeddings for semantic search)
CREATE TABLE IF NOT EXISTS advanced_chunks (
  id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
  agent_id INTEGER NOT NULL,
  file_id VARCHAR NOT NULL,
  folder_id VARCHAR,
  chunk_index INTEGER NOT NULL,
  content TEXT NOT NULL,
  embedding vector(1536),
  token_count INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE advanced_chunks IS 'Text chunks with vector embeddings for advanced agents';
COMMENT ON COLUMN advanced_chunks.embedding IS 'Vector embedding (1536-dim for OpenAI ada-002)';
COMMENT ON COLUMN advanced_chunks.folder_id IS 'Folder context for scoped search';

-- ============================================================
-- REGULAR CONVERSATION TABLES (Simple chat agents)
-- ============================================================

-- Conversations (for simple chat agents)
CREATE TABLE IF NOT EXISTS conversations (
  id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
  agent_id INTEGER NOT NULL,
  user_id VARCHAR NOT NULL,
  title VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE conversations IS 'Chat sessions for simple agents';
COMMENT ON COLUMN conversations.user_id IS 'Reference to user in platform database';

-- Messages (for simple chat agents)
CREATE TABLE IF NOT EXISTS messages (
  id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
  conversation_id VARCHAR NOT NULL,
  role VARCHAR NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE messages IS 'Chat messages for simple agents';
COMMENT ON COLUMN messages.role IS 'Message sender: user, assistant, or system';

-- ============================================================
-- ADVANCED CONVERSATION TABLES (Advanced knowledge agents)
-- ============================================================

-- Advanced conversations (for advanced knowledge agents)
CREATE TABLE IF NOT EXISTS advanced_conversations (
  id SERIAL PRIMARY KEY,
  agent_id INTEGER NOT NULL,
  user_id VARCHAR NOT NULL,
  title VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE advanced_conversations IS 'Chat sessions for advanced knowledge agents';
COMMENT ON COLUMN advanced_conversations.user_id IS 'Reference to user in platform database';

-- Advanced messages (for advanced knowledge agents)
CREATE TABLE IF NOT EXISTS advanced_messages (
  id SERIAL PRIMARY KEY,
  conversation_id INTEGER NOT NULL,
  role VARCHAR NOT NULL,
  content TEXT NOT NULL,
  tokens_used INTEGER,
  model_used VARCHAR,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE advanced_messages IS 'Chat messages for advanced knowledge agents with usage tracking';
COMMENT ON COLUMN advanced_messages.tokens_used IS 'Number of tokens used in this message';
COMMENT ON COLUMN advanced_messages.model_used IS 'AI model used for this message';

-- ============================================================
-- EXTERNAL MESSAGING PLATFORM TABLES (Slack, Telegram, etc.)
-- ============================================================

-- External conversations (for Slack, Telegram, etc.)
CREATE TABLE IF NOT EXISTS external_conversations (
  id SERIAL PRIMARY KEY,
  platform_id INTEGER NOT NULL,
  agent_id INTEGER NOT NULL,
  external_chat_id VARCHAR(255) NOT NULL,
  external_user_id VARCHAR(255) NOT NULL,
  external_user_name VARCHAR(255),
  conversation_type VARCHAR(50) DEFAULT 'direct',
  title VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  last_message_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE external_conversations IS 'Conversations from external platforms like Slack and Telegram';
COMMENT ON COLUMN external_conversations.platform_id IS 'Reference to messaging platform in main database';
COMMENT ON COLUMN external_conversations.conversation_type IS 'Type: direct, group, channel';
COMMENT ON COLUMN external_conversations.external_chat_id IS 'Chat ID from external platform';

-- External messages (for Slack, Telegram, etc.)
CREATE TABLE IF NOT EXISTS external_messages (
  id SERIAL PRIMARY KEY,
  conversation_id INTEGER NOT NULL,
  external_message_id VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL,
  content TEXT NOT NULL,
  user_name VARCHAR(255),
  mentioned_agents TEXT[],
  response_time INTEGER,
  tokens_used INTEGER,
  model_used VARCHAR(100),
  thread_ts VARCHAR(255),
  is_thread_reply BOOLEAN DEFAULT false,
  parent_message_id INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE external_messages IS 'Messages from external platforms with rich metadata';
COMMENT ON COLUMN external_messages.mentioned_agents IS 'Array of agent IDs mentioned in message';
COMMENT ON COLUMN external_messages.response_time IS 'Response time in milliseconds';
COMMENT ON COLUMN external_messages.thread_ts IS 'Thread timestamp for Slack threads';

-- ============================================================
-- FOREIGN KEY CONSTRAINTS
-- ============================================================

-- Advanced files -> Advanced folders
ALTER TABLE advanced_files
  DROP CONSTRAINT IF EXISTS advanced_files_folder_id_fkey;

ALTER TABLE advanced_files
  ADD CONSTRAINT advanced_files_folder_id_fkey
  FOREIGN KEY (folder_id)
  REFERENCES advanced_folders(id)
  ON DELETE SET NULL;

-- Advanced folders -> Advanced folders (self-referencing)
ALTER TABLE advanced_folders
  DROP CONSTRAINT IF EXISTS advanced_folders_parent_folder_id_fkey;

ALTER TABLE advanced_folders
  ADD CONSTRAINT advanced_folders_parent_folder_id_fkey
  FOREIGN KEY (parent_folder_id)
  REFERENCES advanced_folders(id)
  ON DELETE CASCADE;

-- Advanced processing jobs -> Advanced files
ALTER TABLE advanced_processing_jobs
  DROP CONSTRAINT IF EXISTS advanced_processing_jobs_file_id_fkey;

ALTER TABLE advanced_processing_jobs
  ADD CONSTRAINT advanced_processing_jobs_file_id_fkey
  FOREIGN KEY (file_id)
  REFERENCES advanced_files(id)
  ON DELETE CASCADE;

-- Advanced chunks -> Advanced files
ALTER TABLE advanced_chunks
  DROP CONSTRAINT IF EXISTS advanced_chunks_file_id_fkey;

ALTER TABLE advanced_chunks
  ADD CONSTRAINT advanced_chunks_file_id_fkey
  FOREIGN KEY (file_id)
  REFERENCES advanced_files(id)
  ON DELETE CASCADE;

-- Messages -> Conversations
ALTER TABLE messages
  DROP CONSTRAINT IF EXISTS messages_conversation_id_fkey;

ALTER TABLE messages
  ADD CONSTRAINT messages_conversation_id_fkey
  FOREIGN KEY (conversation_id)
  REFERENCES conversations(id)
  ON DELETE CASCADE;

-- Advanced messages -> Advanced conversations
ALTER TABLE advanced_messages
  DROP CONSTRAINT IF EXISTS advanced_messages_conversation_id_fkey;

ALTER TABLE advanced_messages
  ADD CONSTRAINT advanced_messages_conversation_id_fkey
  FOREIGN KEY (conversation_id)
  REFERENCES advanced_conversations(id)
  ON DELETE CASCADE;

-- External messages -> External conversations
ALTER TABLE external_messages
  DROP CONSTRAINT IF EXISTS external_messages_conversation_id_fkey;

ALTER TABLE external_messages
  ADD CONSTRAINT external_messages_conversation_id_fkey
  FOREIGN KEY (conversation_id)
  REFERENCES external_conversations(id)
  ON DELETE CASCADE;

-- ============================================================
-- VERIFICATION
-- ============================================================

DO $$
DECLARE
  table_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO table_count
  FROM information_schema.tables
  WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
    AND table_name IN (
      'files', 'document_chunks',
      'advanced_folders', 'advanced_files', 'advanced_processing_jobs', 'advanced_chunks',
      'conversations', 'messages',
      'advanced_conversations', 'advanced_messages',
      'external_conversations', 'external_messages'
    );

  IF table_count = 12 THEN
    RAISE NOTICE '✓ All 12 tables created successfully';
  ELSE
    RAISE WARNING 'Expected 12 tables, found %', table_count;
  END IF;
END $$;
