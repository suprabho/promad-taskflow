export type TaskStatus = "todo" | "in_progress" | "review" | "done" | "paused";

export type Priority = "low" | "medium" | "high" | "urgent";

export type TaskType =
  | "product_design"
  | "ui_component"
  | "wireframe"
  | "branding"
  | "viz"
  | "video"
  | "frontend"
  | "bug"
  | "polish"
  | "iconography"
  | "social_media"
  | "print"
  | "docs"
  | "chore";

export type Task = {
  id: string;
  name: string;
  details: string;
  status: TaskStatus;
  due_date: string | null;
  priority: Priority;
  task_type: TaskType;
  assignees: string[];
  workspace_id: string;
  created_by: string;
  created_at: string;
  updated_at: string;
};

export const STATUS_LABELS: Record<TaskStatus, string> = {
  todo: "To do",
  in_progress: "In progress",
  review: "Review",
  done: "Done",
  paused: "Paused",
};

export const STATUS_ORDER: TaskStatus[] = [
  "todo",
  "in_progress",
  "review",
  "done",
  "paused",
];

export const PRIORITY_LABELS: Record<Priority, string> = {
  low: "Low",
  medium: "Medium",
  high: "High",
  urgent: "Urgent",
};

export const TASK_TYPE_LABELS: Record<TaskType, string> = {
  product_design: "Product Design",
  ui_component: "UI Component",
  wireframe: "Wireframe",
  branding: "Branding",
  viz: "Visual Design",
  video: "Video",
  frontend: "Frontend",
  bug: "Bug",
  polish: "Polish",
  iconography: "Iconography",
  social_media: "Social Media",
  print: "Print",
  docs: "Docs",
  chore: "Chore",
};
