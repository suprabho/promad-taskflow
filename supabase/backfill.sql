-- =============================================
-- Taskflow — Backfill from Notion export
-- Generated: 2026-04-15T11:44:35.647Z
-- Total tasks: 175
-- =============================================

-- Clear existing tasks (safe for initial backfill)
DELETE FROM public.tasks WHERE workspace_id = 'ws-1';

INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '29d3eaeb-54d2-4a6f-b806-09b740ed8748',
  'KYBB watchlist demo',
  'Update header text to better reflect latest product offerings; task is high priority, medium effort, and marked as done with a due date of February 3, 2025.',
  'done',
  '2025-03-14',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-17T03:14:00.000Z',
  '2025-03-17T03:14:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '558f78d9-31c7-4c36-9e36-d6ba20831ade',
  'Informational landing page for Employers',
  'Update support documents to reflect new product releases, with a medium priority and a due date of February 20, 2025. The task is currently in progress.',
  'done',
  '2025-04-17',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-23T10:44:00.000Z',
  '2025-04-23T10:44:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'be8a89f5-94e2-4e28-94b8-91e0b95d66d7',
  'Babbage Video',
  'Feature request to include product updates in the next release note, with a low priority and small effort level. Task is not started and due by February 28, 2025.',
  'done',
  '2025-03-23',
  'low',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-20T12:12:00.000Z',
  '2025-03-20T12:12:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7a533d6a-5e7b-4dfd-b181-e02d1d618b99',
  'Cart Page for RE',
  '',
  'done',
  '2025-03-14',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-17T03:15:00.000Z',
  '2025-03-17T03:15:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '15e1a718-6444-4779-80d1-91be400a3a8f',
  'Self Service: Money Transaction (inflow)',
  '',
  'done',
  '2025-03-13',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-13T08:17:00.000Z',
  '2025-03-13T08:17:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'cafa0e15-8e4e-4a44-8591-40fb36dc1af5',
  'Self Service: Withdraw Funds (outflow)',
  '',
  'done',
  '2025-03-13',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-13T08:17:00.000Z',
  '2025-03-13T08:17:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '1463bad9-8c05-43bb-97fa-87c3dbb15b66',
  'Wireframes for TOPGreen Crew App',
  '',
  'paused',
  NULL,
  'low',
  'wireframe',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'dbde86cf-1f3e-4336-80d5-9a20cba2758b',
  'Footer for Proffy',
  '',
  'done',
  '2025-04-17',
  'low',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-16T11:16:00.000Z',
  '2025-04-16T11:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'bdb9e30f-32b1-4f82-a6ae-5ca5c8e748a4',
  'Toggle between operator inside rule engine in Compass',
  '',
  'done',
  '2025-03-14',
  'medium',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-17T03:15:00.000Z',
  '2025-03-17T03:15:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '46d91c87-0f1f-47c5-a209-6ad8dae0e79c',
  'Web pages designs for TMP',
  '',
  'done',
  '2025-03-15',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-16T16:55:00.000Z',
  '2025-03-16T16:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ab922736-cdae-4b35-85ca-5d48081d27eb',
  'Support Hashtags in Merkle Science Tracker',
  '',
  'done',
  '2025-03-25',
  'low',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-02T14:39:00.000Z',
  '2025-04-02T14:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '40ab9485-2752-44fd-9790-8490c2a54d1b',
  'Success icons for RE',
  '',
  'done',
  '2025-03-18',
  'high',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-18T05:37:00.000Z',
  '2025-03-18T05:37:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '8d1f890f-8627-4248-a223-0b591c423776',
  'Product section in TMP brochure',
  '',
  'done',
  '2025-03-19',
  'medium',
  'bug',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-19T15:16:00.000Z',
  '2025-03-19T15:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c54be223-17fe-4aac-a5e6-ec9940dc8d8d',
  'Product section in TMP > Construction website',
  '',
  'done',
  '2025-03-20',
  'medium',
  'bug',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-19T15:16:00.000Z',
  '2025-03-19T15:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '605c26a9-fea1-4134-8ec3-de67ff0b6bdb',
  'Sketch style interior rendering for TMP',
  '',
  'paused',
  NULL,
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0acb25f1-7fed-4930-b1a1-d168dcd4eeeb',
  'RE feedback updates',
  '',
  'done',
  '2025-03-18',
  'high',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-18T06:31:00.000Z',
  '2025-03-18T06:31:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'baf7294e-7218-4423-ad86-5d83c4f4563d',
  'Compass features for Laser Digital',
  '',
  'done',
  '2025-04-18',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-16T07:25:00.000Z',
  '2025-04-16T07:25:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c4507e9a-2770-45fd-912b-8e69ee1d1e2c',
  'Mockup: Self Service: Portfolio view (General details)',
  '',
  'done',
  '2025-03-24',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-21T17:39:00.000Z',
  '2025-03-21T17:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ab40f6d3-57ad-41ce-ac58-4093f0ec5fc7',
  'Mockups: Transaction Statement',
  '',
  'done',
  '2025-03-24',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-21T17:39:00.000Z',
  '2025-03-21T17:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '6f375321-efdd-4599-b897-cbb481e921af',
  'Download Manager for Merkle Products',
  '',
  'done',
  '2025-03-21',
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-21T07:54:00.000Z',
  '2025-03-21T07:54:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'cdb4ac4d-bc9c-4fef-9f93-e81a40df867f',
  'Uploads for TOPGreen Planner',
  '',
  'done',
  '2025-03-20',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-21T05:54:00.000Z',
  '2025-03-21T05:54:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'af5bfbf3-6205-4601-801e-e619d87b6377',
  'Iconography for Top green crew app',
  '',
  'paused',
  NULL,
  'medium',
  'iconography',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '1dcf7a86-9fcb-4f81-b8d9-f7a5a67622ed',
  'Kidzovo visiting card',
  '',
  'done',
  '2025-03-26',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-25T08:37:00.000Z',
  '2025-03-25T08:37:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '24916117-6884-457d-9392-fdb16a0ee6d7',
  'Mockup: Information and Privacy Policy',
  '',
  'done',
  '2025-03-27',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-02T14:40:00.000Z',
  '2025-04-02T14:40:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '236dcced-6f4a-4f74-83e5-5d23436fe9f8',
  'Mockup: Help & FAQ',
  '',
  'done',
  '2025-03-25',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-24T12:44:00.000Z',
  '2025-03-24T12:44:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a2bb697d-ac5c-4d48-b864-79525e3baee5',
  'Icons for RE',
  '',
  'done',
  '2025-03-24',
  'high',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-24T12:59:00.000Z',
  '2025-03-24T12:59:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '5df2038e-7a79-4d2a-a2fd-aad0aa218990',
  'Profile Update Section',
  '',
  'done',
  '2025-03-24',
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-21T17:39:00.000Z',
  '2025-03-21T17:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd7a5b845-e0b7-4482-9f94-4921efca42dc',
  'Design System / web brand guidelines',
  '',
  'done',
  NULL,
  'high',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T06:02:00.000Z',
  '2025-04-29T06:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ce0f1ce0-ad5f-4b99-958d-2963ea2ce766',
  'Placeholder for Investigation Graph empty State',
  '',
  'done',
  '2025-03-21',
  'medium',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-21T07:54:00.000Z',
  '2025-03-21T07:54:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '471b0f59-952c-4ef7-a16e-28fe34c434f3',
  'Webinar Flyer',
  '',
  'done',
  '2025-03-24',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-03-24T06:49:00.000Z',
  '2025-03-24T06:49:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '130ebb7b-ac2d-48a6-8ae8-26fa2e6237a3',
  'Asset Export for Proffy',
  '',
  'done',
  '2025-03-24',
  'high',
  'bug',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-24T07:40:00.000Z',
  '2025-03-24T07:40:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7b46580d-51aa-4ffb-963c-aef3dde50c54',
  'Brand Asset Repo for Merklescience',
  '',
  'done',
  '2025-03-26',
  'medium',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-25T08:35:00.000Z',
  '2025-03-25T08:35:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '67d3c5e9-25b7-4248-bc22-0134d8d5b091',
  'New Images for onboarding cards',
  '',
  'done',
  '2025-03-25',
  'high',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-02T14:39:00.000Z',
  '2025-04-02T14:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd57203df-e67b-498a-9dca-1d273d9d6034',
  'Comments on Proffy Landing Page',
  '',
  'done',
  '2025-03-27',
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-02T14:40:00.000Z',
  '2025-04-02T14:40:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7bef57d4-c3d9-41e4-8dab-32ce63d4d082',
  'Detailed selection feature',
  '',
  'done',
  '2025-03-27',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-03-27T07:42:00.000Z',
  '2025-03-27T07:42:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '317c7c05-2e44-41ed-9ebe-aed09a43690c',
  'Responsive Designs for RE',
  '',
  'done',
  '2025-04-21',
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T06:02:00.000Z',
  '2025-04-29T06:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a52e7726-4e69-4cb7-acee-06923f933e19',
  'Blog to Report design',
  '',
  'done',
  '2025-03-30',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-02T14:40:00.000Z',
  '2025-04-02T14:40:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '53572b98-0548-4526-9618-f86e8e4354d0',
  'One Pager Design',
  '',
  'done',
  '2025-03-30',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-02T14:39:00.000Z',
  '2025-04-02T14:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '9fba621f-3f86-48d6-ab84-e09fb83eb1fd',
  'Changes in RE design',
  '',
  'done',
  '2025-04-03',
  'high',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-04T04:16:00.000Z',
  '2025-04-04T04:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'e0cd116e-f96b-4310-9a1e-165e6f527fae',
  'myAIcademy DS',
  '',
  'done',
  NULL,
  'high',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-05-19T10:28:00.000Z',
  '2025-05-19T10:28:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'bdbeed08-7af4-4ca6-8208-beca098fb5e6',
  'myAIcademy Course design',
  '',
  'done',
  '2025-04-29',
  'low',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-05-13T03:31:00.000Z',
  '2025-05-13T03:31:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'dd28274a-59a2-477b-b69d-eb9e8fc8a426',
  'myAIcademy Wireflow',
  '',
  'done',
  '2025-04-25',
  'high',
  'wireframe',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T06:02:00.000Z',
  '2025-04-29T06:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c5af660d-93fd-48c6-a0cb-d252744e45db',
  'Kidzovo webby nomination kit',
  '',
  'done',
  '2025-04-04',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-07T18:25:00.000Z',
  '2025-04-07T18:25:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '5e14ef35-777c-4a60-b21d-30cdbe0a8a70',
  'Design Changes for Tracker',
  '',
  'done',
  '2025-04-16',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-17T05:13:00.000Z',
  '2025-04-17T05:13:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '73d4b5b5-6cb5-4200-bc80-71e0c3f6e507',
  'Promad Website',
  '',
  'paused',
  NULL,
  'low',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '526b72e2-46f5-4e1d-a4ab-930f701bae3b',
  'Shared link Data Viewer',
  '',
  'done',
  '2025-04-17',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-21T04:41:00.000Z',
  '2025-04-21T04:41:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '96d5476e-a76f-4e1d-ae4c-25730a7c7460',
  'Kidzovo Weather Rive',
  '',
  'done',
  '2025-05-28',
  'medium',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-05-26T09:12:00.000Z',
  '2025-05-26T09:12:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '51931e1b-6a83-4104-8d28-b0947920c661',
  'Kidzovo Watch Rive',
  '',
  'done',
  '2025-05-30',
  'low',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-06-12T14:39:00.000Z',
  '2025-06-12T14:39:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0be1207d-f373-422e-9585-091139a91e40',
  'Kidzovo Calendar',
  '',
  'done',
  NULL,
  'medium',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-06-12T14:40:00.000Z',
  '2025-06-12T14:40:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '13697b9a-d94b-4975-899a-f92d842afc7c',
  'Intex branding',
  '',
  'done',
  '2025-05-13',
  'high',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-05-19T10:16:00.000Z',
  '2025-05-19T10:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0ac5b7e4-b0e6-4485-8d94-580531f982ec',
  'Forgot Password for Proffy',
  '',
  'done',
  '2025-04-23',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-23T10:45:00.000Z',
  '2025-04-23T10:45:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c8c389f1-b93f-4691-981c-668301ecbac1',
  'For Employer Button',
  '',
  'done',
  '2025-04-18',
  'low',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-18T16:08:00.000Z',
  '2025-04-18T16:08:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '54f3ef3e-cf4f-44e1-a1f6-83ac7557dfc8',
  'Olga’s edits',
  '',
  'done',
  '2025-04-16',
  'low',
  'bug',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-04-16T11:15:00.000Z',
  '2025-04-16T11:15:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ee4b38c8-abaa-405d-bc82-a96d95875e54',
  'TOPGreen Self Serve',
  '',
  'done',
  NULL,
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-05-26T09:12:00.000Z',
  '2025-05-26T09:12:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'f4e5f730-c552-45bb-bc1c-bdf1818ff492',
  'Merkle Science Smart Contract Watchlist',
  '',
  'done',
  '2025-04-22',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-21T11:22:00.000Z',
  '2025-04-21T11:22:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2f11686c-8805-4f14-8fad-2c6cb471346f',
  'Soiree video edit',
  '',
  'done',
  '2025-04-17',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-17T04:08:00.000Z',
  '2025-04-17T04:08:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2e8c5bab-c780-4fa8-a059-902d84ff84da',
  'Waxwing onboarding',
  '',
  'paused',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'cf8be529-5522-423e-aa11-643041c8fddb',
  'CurioTraveller Logo',
  '',
  'done',
  '2025-04-23',
  'medium',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T05:49:00.000Z',
  '2025-04-29T05:49:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '11b512fe-e318-4f70-a279-bdef9d16ace6',
  'CurioTraveller Website',
  '',
  'done',
  '2025-04-25',
  'medium',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-09-29T04:44:00.000Z',
  '2025-09-29T04:44:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0a29eaab-5cba-45e9-955a-af9515113976',
  'Curio Traveller Fonts',
  '',
  'done',
  '2025-04-23',
  'medium',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T05:49:00.000Z',
  '2025-04-29T05:49:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'cdf60ec3-ad5d-4952-b0df-969ffe4082d5',
  'Curio Traveller Colors',
  '',
  'done',
  '2025-04-23',
  'medium',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T05:49:00.000Z',
  '2025-04-29T05:49:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'af136a93-ca46-470c-bfe6-85d4f24f70cb',
  'TOPGreen App Mascot',
  '',
  'paused',
  NULL,
  'low',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '013d32a1-6025-4ffe-ab54-e014e5f39bb6',
  'CurioTraveller DS',
  '',
  'done',
  '2025-05-02',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-05-13T03:30:00.000Z',
  '2025-05-13T03:30:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '5460164b-0fb6-4869-ab0b-950540b03c57',
  'CurioTraveller MVP',
  '',
  'paused',
  NULL,
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c7b9d20c-d458-42bd-a04b-320c9e132122',
  'myAIcademy UX',
  '',
  'done',
  '2025-05-22',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-05-22T07:07:00.000Z',
  '2025-05-22T07:07:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '59fb33f9-9a82-4c86-95fb-783bcd6401a1',
  'myAIcademy Icons and Illustration',
  '',
  'done',
  '2025-05-16',
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-05-19T10:17:00.000Z',
  '2025-05-19T10:17:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '6c8b2dd0-d419-4a20-9b29-d1d023724174',
  'Tracker Annotations',
  '',
  'done',
  '2025-04-29',
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-04-29T11:16:00.000Z',
  '2025-04-29T11:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '6aace36d-8741-4323-b008-e997b415e6fc',
  'myAIcademy Mascot',
  '',
  'done',
  '2025-05-14',
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-05-19T10:16:00.000Z',
  '2025-05-19T10:16:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '065f3a1f-389a-4633-aefd-8bf58af10e53',
  'Update in TMP brochure',
  '',
  'paused',
  NULL,
  'low',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-09T12:56:00.000Z',
  '2026-03-09T12:56:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'b26cc322-6e4c-42d7-bba9-207d070852e5',
  'TOPGreen Intel Data Dashboard',
  '',
  'done',
  NULL,
  'medium',
  'polish',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-09T05:35:00.000Z',
  '2025-10-09T05:35:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '429210da-0d78-4a45-aa8c-c9019ba77688',
  'TOPGreen Intel Vest Status',
  '',
  'done',
  '2025-05-26',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-08T04:56:00.000Z',
  '2025-07-08T04:56:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '8d11ed34-bfaa-452a-bd89-edd3fc983563',
  '2D inputs in Rule Engine for Compass',
  '',
  'done',
  '2025-05-27',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-06-16T07:35:00.000Z',
  '2025-06-16T07:35:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a9d65ce4-f84e-4f94-bfef-478a28f7cfda',
  'MyAIcademy Course',
  '',
  'done',
  '2025-07-09',
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-07-09T10:21:00.000Z',
  '2025-07-09T10:21:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '17e60999-be54-4e9e-bb97-7ce815cc2311',
  'MerkleScience Tracker Extra Tabs',
  '',
  'done',
  '2025-06-20',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-08T04:56:00.000Z',
  '2025-07-08T04:56:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a2c0d3a9-a103-4829-9442-2e80bbe69a06',
  'MerkleScience Unified Login',
  '',
  'done',
  '2025-06-20',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-08T04:56:00.000Z',
  '2025-07-08T04:56:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ac325013-d330-4b1e-9f1e-a0d5919226f2',
  'Merkle Science Tracker Filter and Add',
  '',
  'done',
  NULL,
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-21T22:24:00.000Z',
  '2025-07-21T22:24:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ce6b3b70-7596-409c-bc42-017a9e17c263',
  'Merkle Science Tracker Improvements',
  '',
  'done',
  NULL,
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-31T06:46:00.000Z',
  '2025-07-31T06:46:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7dde5b8a-d3cb-40ce-a24d-aae98c5f14c2',
  'Flywl Social Media Videos',
  '',
  'done',
  '2025-07-23',
  'medium',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-31T06:48:00.000Z',
  '2025-07-31T06:48:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '5ffb238a-52be-4bd3-b4ab-140b278a9b89',
  'Olly UX/UI',
  '',
  'done',
  NULL,
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-18T07:02:00.000Z',
  '2025-07-18T07:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '3400e2a6-b8f2-4192-b0a8-4a0469ae3b0d',
  'Olly Visuals',
  '',
  'done',
  NULL,
  'medium',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-18T07:02:00.000Z',
  '2025-07-18T07:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'e34bd6d7-af5e-4062-992e-531c0580f4bc',
  'TMPal Catalog',
  '',
  'done',
  NULL,
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-09T12:55:00.000Z',
  '2026-03-09T12:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '9a928c4d-eeaf-4267-9809-fab9c30e8cc3',
  'TOPGreen Planner North Star',
  '',
  'paused',
  NULL,
  'medium',
  'ui_component',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-10T06:55:00.000Z',
  '2025-10-10T06:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '54a8adaf-b25e-4a6b-a96c-308be0f63a62',
  'myAIcademy Phase 2 UI',
  '',
  'done',
  '2025-09-30',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-09T05:33:00.000Z',
  '2025-10-09T05:33:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ad03e3fb-afcc-46fc-b40e-cf3911301947',
  'Magnus UI',
  '',
  'done',
  '2025-07-22',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-31T06:44:00.000Z',
  '2025-07-31T06:44:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'dcb6b5db-ca0d-4cc5-baf9-86c332de6308',
  'Munh Dikhayi Titles and Credit',
  '',
  'done',
  NULL,
  'medium',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-09-09T08:20:00.000Z',
  '2025-09-09T08:20:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'aba042b0-a78e-4057-86bd-5447d4623cce',
  'Merkle Science Compass Error codes',
  '',
  'done',
  '2025-07-25',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-23T07:25:00.000Z',
  '2025-07-23T07:25:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd98fa486-3925-4c4f-8112-fb4f8ee87c97',
  'Merkle Science Compass Rule Engine - Jurisdiction',
  '',
  'done',
  '2025-07-23',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-07-23T06:20:00.000Z',
  '2025-07-23T06:20:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a2eab977-bc23-4a38-8abe-f830f9d88e9a',
  'Tracker Chat',
  '',
  'done',
  '2025-08-18',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-08-27T10:25:00.000Z',
  '2025-08-27T10:25:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '4630ab62-6b26-4ab7-b9e5-5c0ac8c40dbe',
  'CARCI videos',
  '',
  'done',
  '2025-08-25',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-09-24T08:24:00.000Z',
  '2025-09-24T08:24:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '13900881-785c-47e0-bf48-625a566b68ec',
  'Compass List file upload',
  '',
  'done',
  '2025-08-04',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-08-13T04:41:00.000Z',
  '2025-08-13T04:41:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c0fcc085-e073-49f6-8799-0738a7957eb1',
  'myAIcademy Teaser',
  '',
  'paused',
  '2025-12-13',
  'high',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-13T07:09:00.000Z',
  '2025-12-13T07:09:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '3e8e2bac-65ed-4d55-9f35-2ad52687c69b',
  'Merkle Science Compass Demo',
  '',
  'done',
  NULL,
  'medium',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-12-02T00:19:00.000Z',
  '2025-12-02T00:19:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '361ff4a9-6098-4a89-bb13-5ce56ea089ac',
  'Merkle Science Guide',
  '',
  'done',
  NULL,
  'medium',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-09T05:34:00.000Z',
  '2025-10-09T05:34:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd5792503-b10f-4209-97ed-9a74835bd9d2',
  'Merkle Science Compass OSINT',
  '',
  'done',
  NULL,
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-08-27T10:24:00.000Z',
  '2025-08-27T10:24:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0d942296-d252-4b1a-a787-50e57ffc7f0c',
  'Merkle Science Tracker expandable panel feature',
  '',
  'done',
  '2025-08-29',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-09-09T08:19:00.000Z',
  '2025-09-09T08:19:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ddf05773-069c-420d-a73f-039ad4d065ac',
  'Merkle Science Tracker Legends',
  '',
  'done',
  '2025-09-30',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-03T11:37:00.000Z',
  '2025-10-03T11:37:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7c9f5e09-0cb6-4350-ab2e-73e74d4e2989',
  'CARCI Visual Design Assets',
  '',
  'done',
  '2025-09-30',
  'high',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-03T11:37:00.000Z',
  '2025-10-03T11:37:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a55fa176-fe79-471c-a7f7-f56e03784faa',
  'MyAIcademy Course thumbnails',
  '',
  'done',
  '2025-10-06',
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-09T05:33:00.000Z',
  '2025-10-09T05:33:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '93ade03a-de2f-419a-b108-31431ee438b5',
  'TMP Product Page update',
  '',
  'paused',
  NULL,
  'low',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '146e1a9e-fbf6-475b-a3c1-d54af3b2d95a',
  'Merkle Science Booth Design',
  '',
  'done',
  '2025-10-16',
  'high',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-21T02:30:00.000Z',
  '2025-10-21T02:30:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '52f911ab-e91f-4374-aedd-b1bb9d1f6f66',
  'Merkle Science Genius Act Guide',
  '',
  'paused',
  '2025-10-31',
  'low',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-28T04:46:00.000Z',
  '2025-10-28T04:46:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c53ff442-93ef-4955-a275-21e7be92d329',
  'Merkle Science Compass Custom List Alerts',
  '',
  'done',
  '2025-10-15',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-15T09:34:00.000Z',
  '2025-10-15T09:34:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'be28afb1-a9ec-461d-bb07-fa8ea233b45c',
  'Merkle Science Tracker LIFO',
  '',
  'done',
  '2025-10-13',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-15T09:34:00.000Z',
  '2025-10-15T09:34:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'aede6ba2-4e29-4906-a0ed-5dfb6da1d1f3',
  'TopGreen Planner Home Page',
  '',
  'paused',
  '2025-11-07',
  'low',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-11-06T13:21:00.000Z',
  '2025-11-06T13:21:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '52cd4d5d-42bd-436d-ba96-832c8b650ab3',
  'TopGreen Planner Plan screen',
  '',
  'paused',
  NULL,
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-11-13T18:00:00.000Z',
  '2025-11-13T18:00:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'fb31c070-d200-459c-b92d-aaf83c92f699',
  'TMP Contract Manufacturing Brochure',
  '',
  'paused',
  NULL,
  'medium',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-09T12:56:00.000Z',
  '2026-03-09T12:56:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2603bb69-3aa5-452c-9028-af1d81813e97',
  'WorkBase Research',
  '',
  'done',
  '2025-10-24',
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-21T02:31:00.000Z',
  '2025-10-21T02:31:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '00621977-677f-40bb-ae73-4faa19f07686',
  'myAIcademy Product Teaser',
  '',
  'done',
  '2025-11-07',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-11-07T10:58:00.000Z',
  '2025-11-07T10:58:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '57905ad1-5470-4c38-bcf8-b1699820fe6c',
  'WorkBrowser Product Design',
  '',
  'done',
  '2025-11-08',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-11-17T06:59:00.000Z',
  '2025-11-17T06:59:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'fb6800fc-d476-48da-91ae-cad2cb6598ff',
  'Merkle Science Report: Parallel Reconstructions of Chen Zi Sanctions',
  '',
  'done',
  '2025-11-07',
  'high',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-11-13T18:00:00.000Z',
  '2025-11-13T18:00:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'b8b81283-f06f-484b-a1ae-d18fdb7cbad3',
  'Merkle Science: Token Issuer toolkit',
  '',
  'done',
  NULL,
  'medium',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-12-02T00:19:00.000Z',
  '2025-12-02T00:19:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '52a9afbf-455c-4ed2-989d-68b62563ee40',
  'Merkle Science Testimonials',
  '',
  'done',
  '2025-10-24',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-24T11:47:00.000Z',
  '2025-10-24T11:47:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0ee41d38-3ede-46af-adf4-45817fc0ff00',
  'Merkle Science Compass: AI Summary',
  '',
  'done',
  '2025-10-31',
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-10-28T14:08:00.000Z',
  '2025-10-28T14:08:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'bc438cfb-adec-4f8a-8ec5-515cc06ddb1e',
  'Merkle Science: Bridges one Pager',
  '',
  'done',
  '2025-10-27',
  'low',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-10-28T03:06:00.000Z',
  '2025-10-28T03:06:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '69a63717-575d-4e49-a461-87d452cb92cb',
  'Stablecoin Trust Forum 2025 Branding',
  'Create a core branding template and repurpose across all required sizes for the event co-hosted by Merkle Science, Mastercard, WireX, and Notabene. Confirm final event name before lock.',
  'done',
  '2025-12-05',
  'medium',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-12-13T06:59:00.000Z',
  '2025-12-13T06:59:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7e9f1b79-c15d-47b5-bde8-52a49dbc64d8',
  'Mekle Science Compass GCP Demo',
  '',
  'done',
  NULL,
  'medium',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-02T00:19:00.000Z',
  '2025-12-02T00:19:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '3367e357-af45-4d6a-8fb1-b774396a1a94',
  'Mekle Science Marketing Social Media Edits',
  '',
  'done',
  '2025-11-10',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-11-13T18:00:00.000Z',
  '2025-11-13T18:00:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ab8ce788-d98f-458e-b5d9-004d80d4f16d',
  'Merkle Science Marketing News Clipping',
  '',
  'done',
  '2025-11-07',
  'medium',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-11-07T10:58:00.000Z',
  '2025-11-07T10:58:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '4e288564-d257-43ed-87b7-600c0ac75216',
  'Merkle Science Compass AI Chat',
  '',
  'in_progress',
  '2025-11-17',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-02T00:23:00.000Z',
  '2025-12-02T00:23:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2c0be358-c246-41a4-9f8e-47c55333fee4',
  'TopGreen UX to-do list',
  '',
  'paused',
  '2025-11-28',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-02T00:20:00.000Z',
  '2025-12-02T00:20:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'f34c3f2c-0e8f-48c2-a70c-cfb9fb15f0e1',
  'FLP Home Page Explorations',
  '',
  'done',
  '2025-11-18',
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-02T00:21:00.000Z',
  '2025-12-02T00:21:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '4f9b9c8e-8fa2-4750-8dd6-6f15ccfd67c7',
  'Merkle Meets branding',
  '',
  'done',
  '2025-12-16',
  'high',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2025-12-16T14:22:00.000Z',
  '2025-12-16T14:22:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'fc647515-2783-41c6-8224-147b9447a31a',
  'TMPal Social media Calander',
  '',
  'done',
  NULL,
  'high',
  'social_media',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-09T12:54:00.000Z',
  '2026-03-09T12:54:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a7ac71bf-6832-4c57-8f9d-eee9167c865a',
  'Merkle Science Re-branding',
  '',
  'paused',
  NULL,
  'low',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '829959d0-1cf4-45e3-841e-ffcc6af4e284',
  'Merkle Science Events Page',
  '',
  'done',
  '2026-01-09',
  'high',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-01-19T03:30:00.000Z',
  '2026-01-19T03:30:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2442faba-40dc-4b07-886d-1450c3304173',
  'FLP Builder experience',
  '',
  'done',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-01-19T04:59:00.000Z',
  '2026-01-19T04:59:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'f4933e41-0f3a-4a20-9ae9-8c820ca4fca5',
  'myAIcademy corporate video',
  '',
  'paused',
  '2025-12-22',
  'high',
  'video',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-29T03:28:00.000Z',
  '2025-12-29T03:28:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '77ed71c2-d9c8-4678-aef7-14d8cb0704ad',
  'Merkle Science Relay',
  '',
  'done',
  NULL,
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-19T15:01:00.000Z',
  '2025-12-19T15:01:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '280cfe22-6ba3-4e1d-9951-d3b1fb4c6222',
  'TMP Branding and naming strategy',
  '',
  'done',
  '2025-12-20',
  'high',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2025-12-29T03:28:00.000Z',
  '2025-12-29T03:28:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a2c08c65-4cd9-45cd-9a50-1a3bea8df910',
  'Merkle Science Lovable',
  '',
  'done',
  '2025-12-26',
  'low',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-01-06T05:42:00.000Z',
  '2026-01-06T05:42:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ac137675-79f9-4878-853e-f852f4648ff6',
  'TMPal x Promad Design Direction',
  '',
  'paused',
  NULL,
  'high',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'e772c7ec-2dac-4600-b75c-648024bf3adc',
  'Kidzovo Website Icons / Illustrations',
  '',
  'done',
  '2026-01-23',
  'high',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-02-03T07:33:00.000Z',
  '2026-02-03T07:33:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '6a092913-2747-49ed-9590-1ec0320c4537',
  'Promad Research Passive Income Streams',
  '',
  'in_progress',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T17:36:00.000Z',
  '2026-03-30T17:36:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '0c5987cd-a688-4b62-9760-cc96f257d1b9',
  'Promad Aura',
  '',
  'in_progress',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-01-06T05:42:00.000Z',
  '2026-01-06T05:42:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '79968f74-25d9-4034-b3a4-e332262cbd13',
  'Stablecoin Trust Forum Speaker Creatives',
  '',
  'done',
  '2026-01-07',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-01-07T08:00:00.000Z',
  '2026-01-07T08:00:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '4ee31fa1-cd89-489e-b2d2-e04d7aad56c9',
  'Merkle Meet thumbnail template',
  '',
  'paused',
  '2026-01-06',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-01-07T08:00:00.000Z',
  '2026-01-07T08:00:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd6244b36-a399-4515-9382-10c73eb8f7a7',
  'Merkle Science Compass Whiteslisting Config',
  '',
  'done',
  NULL,
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-01-21T10:52:00.000Z',
  '2026-01-21T10:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'cd9cf63f-6335-46bf-8d6c-592eedb2880e',
  'TMP Id Card',
  '',
  'done',
  '2026-01-20',
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-02-03T07:33:00.000Z',
  '2026-02-03T07:33:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '1b22a595-c007-4a5c-b963-5872f6089886',
  'Merkle Science Compass Custom Taxonomy Mapping',
  '',
  'done',
  NULL,
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-01-21T10:52:00.000Z',
  '2026-01-21T10:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '7808bfd8-62a0-45ae-aad4-d08e46d01058',
  'Merkle Science Compass Custom Lists',
  '',
  'paused',
  NULL,
  'medium',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-09T12:54:00.000Z',
  '2026-03-09T12:54:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c798d88b-7539-48de-8223-91c8e4d39b8b',
  'Green Mentor Growth Ideas',
  '',
  'paused',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '17d0b933-fefe-46fe-9805-ecff80f4e9cf',
  'Explainer Video',
  '',
  'done',
  '2026-03-24',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T09:45:00.000Z',
  '2026-03-30T09:45:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '72addb24-dc94-4ec0-aac4-da5eeba7630d',
  'Kidzovo SXSW visuals',
  '',
  'done',
  '2026-01-20',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-01-20T07:07:00.000Z',
  '2026-01-20T07:07:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '1749a58f-db13-4b87-936e-30856bb01417',
  'Homer January Creatives',
  '',
  'paused',
  '2026-02-20',
  'medium',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-09T12:52:00.000Z',
  '2026-03-09T12:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '8974c3d0-2093-49f3-aac2-0d5f561c54be',
  'Little Passports Creative Refresh',
  '',
  'done',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-02-03T07:34:00.000Z',
  '2026-02-03T07:34:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '03a0092d-c4f9-4bbc-8dcb-c9fea87c83c9',
  'Merkle Science Homepage Certification Section Refresh',
  '',
  'paused',
  NULL,
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '877d34ca-a2c0-4fe3-a89a-8e6f5eac746a',
  'Merkle Science Roll-up Standees',
  '',
  'done',
  '2026-02-06',
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-02-10T10:42:00.000Z',
  '2026-02-10T10:42:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'db77da29-b428-4613-a07b-b655cbd99652',
  'Merkle Science Webinar Design',
  '',
  'done',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-02-10T10:48:00.000Z',
  '2026-02-10T10:48:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ee93fc7f-8051-4e9e-b057-89491e30a287',
  'Merkle Science Merkle Meet DC Collaterals',
  '',
  'done',
  '2026-03-11',
  'high',
  'video',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-24T08:21:00.000Z',
  '2026-03-24T08:21:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ca4c1c51-5b44-4d94-914a-7b09f7049b45',
  'Merkle Science Brochure',
  '',
  'done',
  NULL,
  'medium',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-30T11:51:00.000Z',
  '2026-03-30T11:51:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '09317f32-bfbb-49bb-9844-8a672f83fc30',
  'Promad AI Playbook',
  '',
  'done',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '34db4b7f-c558-4959-a416-fe4afc559fc2',
  'TMPal WhatsApp Deck',
  '',
  'done',
  '2026-02-19',
  'high',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-09T12:52:00.000Z',
  '2026-03-09T12:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '04294ea8-9944-40ae-8d05-d06bc5598e13',
  'Merkle Science Webinar Thumbnail: A Certified Training on Navigating the GENIUS Act: What Stablecoin',
  '',
  'done',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-09T13:02:00.000Z',
  '2026-03-09T13:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'bb3abeb4-b1d5-4405-b841-33a805cb3c79',
  'TMPal Social Media Update',
  '',
  'review',
  '2026-03-11',
  'medium',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-30T09:45:00.000Z',
  '2026-03-30T09:45:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '081ba984-7ad4-4636-9ea0-977fa22d1137',
  'TMP Profile Document',
  '',
  'done',
  '2026-03-10',
  'medium',
  'print',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-30T11:50:00.000Z',
  '2026-03-30T11:50:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'c31c2d5f-2115-4b0e-9212-457d69b8c50f',
  'Merkle Science Meet New York Collaterals',
  '',
  'done',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-24T08:21:00.000Z',
  '2026-03-24T08:21:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '6c8e9389-6b94-4a79-a421-58453907eba3',
  'Merkle Science Meet  Paris',
  '',
  'in_progress',
  '2026-04-09',
  'low',
  'viz',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-04-07T12:41:00.000Z',
  '2026-04-07T12:41:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'a0db3c1c-9ed4-4f99-ace5-591de14825f8',
  'Merkle Science Meet  Amsterdam (Mini Meet)',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-03-30T11:52:00.000Z',
  '2026-03-30T11:52:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '70c739df-94a9-4cff-b8bf-e57846d1e7eb',
  'Chidiya Udd Game',
  '',
  'in_progress',
  NULL,
  'high',
  'product_design',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-07T12:42:00.000Z',
  '2026-04-07T12:42:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'b830a45a-f76b-4665-87d6-cafb58a55c2d',
  'Promad Invoice Builder',
  '',
  'done',
  NULL,
  'low',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T14:02:00.000Z',
  '2026-03-30T14:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'dcce62bc-a8ff-42f9-8f41-e2352172d927',
  'Begin Sage Branding',
  '',
  'review',
  NULL,
  'medium',
  'branding',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T11:56:00.000Z',
  '2026-03-30T11:56:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2e857f0a-4c66-4717-b84b-a6724fb559c8',
  'Begin Stepback Prototype',
  '',
  'review',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-07T12:41:00.000Z',
  '2026-04-07T12:41:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '10662344-4ce6-4561-8d4f-f228b1b1c791',
  'Begin Content Item update',
  '',
  'done',
  '2026-03-31',
  'high',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T16:38:00.000Z',
  '2026-03-30T16:38:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '22b305cd-4a04-4a7e-b6c0-2f276e6db6d9',
  'Kidzovo Chrome Extension UI',
  '',
  'todo',
  NULL,
  'medium',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-30T16:55:00.000Z',
  '2026-03-30T16:55:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '528dca55-a1f8-4727-b89b-4c25d6440aa3',
  'Kidzovo Bao Zi Demo',
  '',
  'done',
  '2026-04-03',
  'high',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-07T12:32:00.000Z',
  '2026-04-07T12:32:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '70f6825d-3d16-4e9e-bb2d-37c99f69d0b3',
  'Kidzovo Ms Monica Reachout',
  '',
  'review',
  NULL,
  'high',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-07T12:42:00.000Z',
  '2026-04-07T12:42:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd63aa639-5dfb-49db-a433-6748b7944f7b',
  'Kidzovo Coloring App Page',
  '',
  'todo',
  NULL,
  'medium',
  'frontend',
  ARRAY['00000000-0000-0000-0000-000000000001']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-03-31T05:13:00.000Z',
  '2026-03-31T05:13:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd6557f52-d1e3-4e9b-b93e-d1e1d99a8c12',
  'Merkle Meets Miami',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-04-07T12:32:00.000Z',
  '2026-04-07T12:32:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '1c409cc7-70d8-479b-872f-9bf0f300b08d',
  'Vizmaya Korea GPU story',
  '',
  'in_progress',
  '2026-04-20',
  'high',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-09T06:00:00.000Z',
  '2026-04-09T06:00:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'f8632b36-6324-4030-9838-0157c045e5ed',
  'Vizmaya Branding',
  '',
  'todo',
  '2026-04-20',
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-07T12:43:00.000Z',
  '2026-04-07T12:43:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'd3a8bef1-4b6e-4895-b1f1-0a8f9c394c98',
  'Groupies Sample Asset Generatiom',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  ARRAY['00000000-0000-0000-0000-000000000002']::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000002',
  '2026-04-07T12:44:00.000Z',
  '2026-04-07T12:44:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '75a0b006-fefc-44a3-88c9-3852d1361426',
  'Open Studio website',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-07T12:44:00.000Z',
  '2026-04-07T12:44:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '4702c773-ffbb-44dc-bd42-5759e4063de6',
  'Begin Math Printable Generation Report',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-09T06:02:00.000Z',
  '2026-04-09T06:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '2d993127-9799-4960-9a4c-9abac9c0cc02',
  'Begin Sage Branding Report',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-09T06:02:00.000Z',
  '2026-04-09T06:02:00.000Z'
);
INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  'ed803b49-19bc-4c00-b481-f9f750c44c90',
  'MandarinX demo videos',
  '',
  'todo',
  NULL,
  'medium',
  'chore',
  '{}'::uuid[],
  'ws-1',
  '00000000-0000-0000-0000-000000000001',
  '2026-04-09T06:34:00.000Z',
  '2026-04-09T06:34:00.000Z'
);

-- Summary:
--   done: 131
--   paused: 24
--   in_progress: 6
--   review: 4
--   todo: 10
