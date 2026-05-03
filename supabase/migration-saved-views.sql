-- =============================================
-- Taskflow — Saved Views
-- Shared, workspace-scoped view presets
-- =============================================

create table if not exists public.saved_views (
  id uuid primary key default gen_random_uuid(),
  workspace_id text not null default 'ws-1',
  name text not null,
  mode text not null check (mode in ('list', 'board')),
  group_by text not null default 'status' check (group_by in ('status', 'project')),
  sort_field text not null default 'priority' check (sort_field in ('name', 'due_date', 'priority', 'status')),
  sort_dir text not null default 'asc' check (sort_dir in ('asc', 'desc')),
  my_tasks_only boolean not null default false,
  filters jsonb not null default '{}'::jsonb,
  created_by uuid references public.users(id),
  created_at timestamptz not null default now()
);

create index if not exists idx_saved_views_workspace on public.saved_views(workspace_id);

alter table public.saved_views enable row level security;
drop policy if exists "Allow all on saved_views" on public.saved_views;
create policy "Allow all on saved_views" on public.saved_views for all using (true) with check (true);

-- Enable Realtime so multi-user sessions see new views immediately
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'saved_views'
  ) then
    alter publication supabase_realtime add table public.saved_views;
  end if;
end $$;
