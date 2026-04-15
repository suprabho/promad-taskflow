-- =============================================
-- Taskflow — Phase 4 Migration: Notifications
-- Run this in: Supabase Dashboard > SQL Editor
-- =============================================

-- 1. Notifications table
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  task_id uuid not null references public.tasks(id) on delete cascade,
  type text not null check (type in ('assigned', 'commented', 'due_soon')),
  message text not null,
  read boolean not null default false,
  created_at timestamptz not null default now()
);

-- 2. Indexes
create index if not exists idx_notifications_user on public.notifications(user_id);
create index if not exists idx_notifications_unread on public.notifications(user_id, read) where read = false;

-- 3. Enable Realtime on notifications
alter publication supabase_realtime add table public.notifications;

-- 4. RLS (permissive for now — tighten after auth)
alter table public.notifications enable row level security;
create policy "Allow all on notifications" on public.notifications for all using (true) with check (true);

-- 5. Full-text search index on tasks (for global search performance)
create index if not exists idx_tasks_search on public.tasks using gin (
  to_tsvector('english', coalesce(name, '') || ' ' || coalesce(details, ''))
);
