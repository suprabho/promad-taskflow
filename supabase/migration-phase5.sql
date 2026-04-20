-- =============================================
-- Taskflow — Phase 5 Migration: Project field
-- Run this in: Supabase Dashboard > SQL Editor
-- =============================================

-- 1. Add project column to tasks
alter table public.tasks
  add column if not exists project text;

-- 2. Index for grouping/filtering by project
create index if not exists idx_tasks_project on public.tasks(project);
