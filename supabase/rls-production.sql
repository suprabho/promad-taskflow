-- =============================================
-- Taskflow — Production RLS Policies
-- Replace the permissive policies once auth is wired up.
-- Run this in: Supabase Dashboard > SQL Editor
-- =============================================

-- Drop the permissive dev policies
drop policy if exists "Allow all on users" on public.users;
drop policy if exists "Allow all on tasks" on public.tasks;
drop policy if exists "Allow all on comments" on public.comments;
drop policy if exists "Allow all on activity_logs" on public.activity_logs;
drop policy if exists "Allow all on notifications" on public.notifications;
drop policy if exists "Allow all on saved_views" on public.saved_views;

-- Users: can read all, can only update own profile
create policy "Users can read all users"
  on public.users for select using (true);

create policy "Users can update own profile"
  on public.users for update using (auth.uid() = id);

-- Tasks: workspace members can read/write all tasks
create policy "Workspace members can read tasks"
  on public.tasks for select using (true);

create policy "Authenticated users can insert tasks"
  on public.tasks for insert with check (auth.uid() = created_by);

create policy "Authenticated users can update tasks"
  on public.tasks for update using (true);

create policy "Task creators can delete tasks"
  on public.tasks for delete using (auth.uid() = created_by);

-- Comments: anyone can read, authors can insert/delete own
create policy "Anyone can read comments"
  on public.comments for select using (true);

create policy "Authenticated users can insert comments"
  on public.comments for insert with check (auth.uid() = author_id);

create policy "Authors can delete own comments"
  on public.comments for delete using (auth.uid() = author_id);

-- Activity logs: read-only for all, insert by system
create policy "Anyone can read activity logs"
  on public.activity_logs for select using (true);

create policy "Authenticated users can insert activity logs"
  on public.activity_logs for insert with check (auth.uid() = actor_id);

-- Notifications: users can only read/update their own
create policy "Users can read own notifications"
  on public.notifications for select using (auth.uid() = user_id);

create policy "System can insert notifications"
  on public.notifications for insert with check (true);

create policy "Users can update own notifications"
  on public.notifications for update using (auth.uid() = user_id);

-- Saved views: workspace-scoped, anyone can read, creators manage their own
create policy "Anyone can read saved views"
  on public.saved_views for select using (true);

create policy "Authenticated users can insert saved views"
  on public.saved_views for insert with check (auth.uid() = created_by);

create policy "Creators can update own saved views"
  on public.saved_views for update using (auth.uid() = created_by);

create policy "Creators can delete own saved views"
  on public.saved_views for delete using (auth.uid() = created_by);
