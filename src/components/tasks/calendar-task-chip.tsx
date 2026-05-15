"use client";

import { useDraggable } from "@dnd-kit/core";
import { CSS } from "@dnd-kit/utilities";
import { Task, Priority } from "@/types/task";
import { useTaskStore } from "@/store/task-store";

const priorityDot: Record<Priority, string> = {
  low: "bg-gray-400",
  medium: "bg-blue-400",
  high: "bg-orange-400",
  urgent: "bg-red-500",
};

export function CalendarTaskChip({
  task,
  multiline = false,
}: {
  task: Task;
  multiline?: boolean;
}) {
  const { openDetail } = useTaskStore();
  const { attributes, listeners, setNodeRef, transform, isDragging } =
    useDraggable({ id: task.id, data: { task } });

  const style = {
    transform: CSS.Translate.toString(transform),
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
      onClick={() => openDetail(task.id)}
      className={`group flex items-center gap-1.5 rounded-md border border-gray-200 bg-white px-1.5 py-1 text-[11px] text-gray-700 shadow-sm cursor-pointer hover:border-gray-300 hover:bg-gray-50 ${
        isDragging ? "opacity-40" : ""
      }`}
    >
      <span
        className={`h-1.5 w-1.5 shrink-0 rounded-full ${priorityDot[task.priority]}`}
      />
      <span
        className={`flex-1 ${
          multiline ? "line-clamp-2 leading-tight" : "truncate"
        }`}
      >
        {task.name || "Untitled task"}
      </span>
    </div>
  );
}
