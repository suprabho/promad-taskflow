"use client";

import { Priority, TaskStatus, TaskType, TASK_TYPE_LABELS } from "@/types/task";

const priorityColors: Record<Priority, string> = {
  low: "bg-gray-100 text-gray-600",
  medium: "bg-blue-100 text-blue-700",
  high: "bg-orange-100 text-orange-700",
  urgent: "bg-red-100 text-red-700",
};

const statusColors: Record<TaskStatus, string> = {
  todo: "bg-gray-100 text-gray-600",
  in_progress: "bg-yellow-100 text-yellow-700",
  review: "bg-purple-100 text-purple-700",
  done: "bg-green-100 text-green-700",
  paused: "bg-slate-200 text-slate-600",
};

const typeColors: Record<TaskType, string> = {
  product_design: "bg-indigo-100 text-indigo-700",
  ui_component: "bg-sky-100 text-sky-700",
  wireframe: "bg-violet-100 text-violet-700",
  branding: "bg-amber-100 text-amber-700",
  viz: "bg-pink-100 text-pink-700",
  video: "bg-rose-100 text-rose-700",
  frontend: "bg-cyan-100 text-cyan-700",
  bug: "bg-red-100 text-red-700",
  polish: "bg-lime-100 text-lime-700",
  iconography: "bg-fuchsia-100 text-fuchsia-700",
  social_media: "bg-orange-100 text-orange-700",
  print: "bg-emerald-100 text-emerald-700",
  docs: "bg-teal-100 text-teal-700",
  chore: "bg-gray-100 text-gray-600",
};

type BadgeProps = {
  children: React.ReactNode;
  className?: string;
};

export function Badge({ children, className = "" }: BadgeProps) {
  return (
    <span
      className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${className}`}
    >
      {children}
    </span>
  );
}

export function PriorityBadge({ priority }: { priority: Priority }) {
  return (
    <Badge className={priorityColors[priority]}>
      {priority.charAt(0).toUpperCase() + priority.slice(1)}
    </Badge>
  );
}

export function StatusBadge({ status }: { status: TaskStatus }) {
  const labels: Record<TaskStatus, string> = {
    todo: "To do",
    in_progress: "In progress",
    review: "Review",
    done: "Done",
    paused: "Paused",
  };
  return <Badge className={statusColors[status]}>{labels[status]}</Badge>;
}

export function TypeBadge({ type }: { type: TaskType }) {
  return (
    <Badge className={typeColors[type]}>
      {TASK_TYPE_LABELS[type] || type}
    </Badge>
  );
}
