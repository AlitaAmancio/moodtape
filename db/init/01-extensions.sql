-- Enable pgvector. The tracks table is created later, once Phase 1 fixes
-- which audio features go into the vector (and therefore its dimension).
CREATE EXTENSION IF NOT EXISTS vector;
