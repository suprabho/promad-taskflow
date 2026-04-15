"use client";

import { Task } from "@/types/task";
import { PriorityBadge, StatusBadge, TypeBadge } from "@/components/ui/badge";
import { AvatarGroup } from "@/components/ui/avatar";
import { useTaskStore } from "@/store/task-store";
import { CalendarBlank } from "@phosphor-icons/react";

function formatDate(dateStr: string | null) {
  if (!dateStr) return "—";
  const d = new Date(dateStr);
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

export function TaskRow({ task }: { task: Task }) {
  const { openDetail, getUserById } = useTaskStore();
  const assigneeUsers = task.assignees
    .map((id) => getUserById(id))
    .filter(Boolean) as { name: string; avatar_url: string | null }[];

  return (
    <tr
      onClick={() => openDetail(task.id)}
      className="group cursor-pointer border-b border-gray-100 hover:bg-gray-50 transition-colors"
    >
      <td className="py-3 px-4">
        <span className="text-sm font-medium text-gray-900 group-hover:text-indigo-600 transition-colors">
          {task.name || "Untitled task"}
        </span>
      </td>
      <td className="py-3 px-4">
        <StatusBadge status={task.status} />
      </td>
      <td className="py-3 px-4">
        <PriorityBadge priority={task.priority} />
      </td>
      <td className="py-3 px-4">
        <TypeBadge type={task.task_type} />
      </td>
      <td className="py-3 px-4">
        {task.due_date ? (
          <span className="flex items-center gap-1.5 text-sm text-gray-600">
            <CalendarBlank className="h-3.5 w-3.5" />
            {formatDate(task.due_date)}
          </span>
        ) : (
          <span className="text-sm text-gray-400">—</span>
        )}
      </td>
      <td className="py-3 px-4">
        {assigneeUsers.length > 0 ? (
          <AvatarGroup
            users={assigneeUsers.map((u) => ({
              name: u.name,
              src: u.avatar_url,
            }))}
          />
        ) : (
          <span className="text-sm text-gray-400">—</span>
        )}
      </td>
    </tr>
  );
}
