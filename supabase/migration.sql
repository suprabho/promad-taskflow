-- =============================================
-- Taskflow — Supabase Schema Migration
-- Run this in: Supabase Dashboard > SQL Editor
-- =============================================

-- 1. Users table
create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text unique not null,
  avatar_url text,
  role text not null default 'member' check (role in ('admin', 'member')),
  joined_at timestamptz not null default now()
);

-- 2. Tasks table
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Untitled task',
  details text not null default '',
  status text not null default 'todo' check (status in ('todo', 'in_progress', 'review', 'done', 'paused')),
  due_date date,
  priority text not null default 'medium' check (priority in ('low', 'medium', 'high', 'urgent')),
  task_type text not null default 'product_design' check (task_type in (
    'product_design', 'ui_component', 'wireframe', 'branding', 'viz',
    'video', 'frontend', 'bug', 'polish', 'iconography',
    'social_media', 'print', 'docs', 'chore'
  )),
  assignees uuid[] not null default '{}',
  workspace_id text not null default 'ws-1',
  created_by uuid references public.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3. Comments table
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  author_id uuid not null references public.users(id),
  body text not null,
  created_at timestamptz not null default now()
);

-- 4. Activity log table
create table if not exists public.activity_logs (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  actor_id uuid not null references public.users(id),
  action text not null,
  created_at timestamptz not null default now()
);

-- 5. Indexes
create index if not exists idx_tasks_workspace on public.tasks(workspace_id);
create index if not exists idx_tasks_status on public.tasks(status);
create index if not exists idx_comments_task on public.comments(task_id);
create index if not exists idx_activity_task on public.activity_logs(task_id);

-- 6. Auto-update updated_at on tasks
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_updated_at on public.tasks;
create trigger set_updated_at
  before update on public.tasks
  for each row execute function public.handle_updated_at();

-- 7. Enable Realtime on the tasks and comments tables
alter publication supabase_realtime add table public.tasks;
alter publication supabase_realtime add table public.comments;

-- 8. Row Level Security (permissive for now — tighten after auth is wired up)
alter table public.users enable row level security;
alter table public.tasks enable row level security;
alter table public.comments enable row level security;
alter table public.activity_logs enable row level security;

create policy "Allow all on users" on public.users for all using (true) with check (true);
create policy "Allow all on tasks" on public.tasks for all using (true) with check (true);
create policy "Allow all on comments" on public.comments for all using (true) with check (true);
create policy "Allow all on activity_logs" on public.activity_logs for all using (true) with check (true);

-- 9. Seed users
insert into public.users (id, name, email, role)
values
  ('00000000-0000-0000-0000-000000000001', 'Suprabho Dhenki', 'suprabho@promad.design', 'admin'),
  ('00000000-0000-0000-0000-000000000002', 'Vanshika Garg', 'vanshika@promad.design', 'member')
on conflict (email) do nothing;
