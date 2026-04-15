export type UserRole = "admin" | "member";

export type User = {
  id: string;
  name: string;
  email: string;
  avatar_url: string | null;
  role: UserRole;
  joined_at: string;
};

export type Comment = {
  id: string;
  task_id: string;
  author_id: string;
  body: string;
  created_at: string;
};

export type ActivityLog = {
  id: string;
  task_id: string;
  actor_id: string;
  action: string;
  created_at: string;
};
