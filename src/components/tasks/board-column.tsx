"use client";

import { useDroppable } from "@dnd-kit/core";
import {
  SortableContext,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { Task, TaskStatus, STATUS_LABELS } from "@/types/task";
import { TaskCard } from "./task-card";

const columnColors: Record<TaskStatus, string> = {
  todo: "bg-gray-400",
  in_progress: "bg-yellow-400",
  review: "bg-purple-400",
  done: "bg-green-400",
  paused: "bg-slate-400",
};

export function BoardColumn({
  status,
  tasks,
}: {
  status: TaskStatus;
  tasks: Task[];
}) {
  const { setNodeRef, isOver } = useDroppable({ id: status });

  return (
    <div
      className={`flex min-h-[200px] w-72 flex-shrink-0 flex-col rounded-xl bg-gray-50 transition-colors ${
        isOver ? "bg-indigo-50 ring-2 ring-indigo-200" : ""
      }`}
    >
      {/* Column header */}
      <div className="flex items-center gap-2 px-3 py-3">
        <div className={`h-2 w-2 rounded-full ${columnColors[status]}`} />
        <span className="text-sm font-semibold text-gray-700">
          {STATUS_LABELS[status]}
        </span>
        <span className="ml-auto text-xs font-medium text-gray-400">
          {tasks.length}
        </span>
      </div>

      {/* Cards */}
      <div ref={setNodeRef} className="flex flex-1 flex-col gap-2 px-2 pb-2">
        <SortableContext
          items={tasks.map((t) => t.id)}
          strategy={verticalListSortingStrategy}
        >
          {tasks.map((task) => (
            <TaskCard key={task.id} task={task} />
          ))}
        </SortableContext>
      </div>
    </div>
  );
}
