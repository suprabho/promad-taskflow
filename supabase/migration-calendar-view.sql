-- =============================================
-- Taskflow — Allow 'calendar' as a saved-view mode
-- =============================================

alter table public.saved_views
  drop constraint if exists saved_views_mode_check;

alter table public.saved_views
  add constraint saved_views_mode_check
  check (mode in ('list', 'board', 'calendar'));
