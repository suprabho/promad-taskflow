"use client";

import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { Task } from "@/types/task";
import { PriorityBadge, TypeBadge } from "@/components/ui/badge";
import { AvatarGroup } from "@/components/ui/avatar";
import { useTaskStore } from "@/store/task-store";
import { CalendarBlank } from "@phosphor-icons/react";

function formatDate(dateStr: string | null) {
  if (!dateStr) return null;
  const d = new Date(dateStr);
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

export function TaskCard({ task }: { task: Task }) {
  const { openDetail, getUserById } = useTaskStore();
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: task.id, data: { task } });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  const assigneeUsers = task.assignees
    .map((id) => getUserById(id))
    .filter(Boolean) as { name: string; avatar_url: string | null }[];

  const due = formatDate(task.due_date);

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
      onClick={() => openDetail(task.id)}
      className={`rounded-lg border border-gray-200 bg-white p-3 shadow-sm cursor-pointer hover:shadow-md transition-shadow ${
        isDragging ? "opacity-50 shadow-lg" : ""
      }`}
    >
      <p className="text-sm font-medium text-gray-900 mb-2">
        {task.name || "Untitled task"}
      </p>

      <div className="flex items-center gap-1.5 mb-2 flex-wrap">
        <PriorityBadge priority={task.priority} />
        <TypeBadge type={task.task_type} />
      </div>

      <div className="flex items-center justify-between">
        {due ? (
          <span className="flex items-center gap-1 text-xs text-gray-500">
            <CalendarBlank className="h-3 w-3" />
            {due}
          </span>
        ) : (
          <span />
        )}

        {assigneeUsers.length > 0 && (
          <AvatarGroup
            users={assigneeUsers.map((u) => ({
              name: u.name,
              src: u.avatar_url,
            }))}
            max={2}
          />
        )}
      </div>
    </div>
  );
}
