"use client";

import { useDroppable } from "@dnd-kit/core";
import {
  SortableContext,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { Task } from "@/types/task";
import { TaskCard } from "./task-card";

export function BoardColumn({
  id,
  label,
  dotColor,
  tasks,
}: {
  id: string;
  label: string;
  dotColor: string;
  tasks: Task[];
}) {
  const { setNodeRef, isOver } = useDroppable({ id });

  return (
    <div
      className={`flex min-h-[200px] w-full flex-col rounded-xl bg-gray-50 transition-colors md:w-72 md:flex-shrink-0 ${
        isOver ? "bg-indigo-50 ring-2 ring-indigo-200" : ""
      }`}
    >
      {/* Column header */}
      <div className="flex items-center gap-2 px-3 py-3">
        <div className={`h-2 w-2 rounded-full ${dotColor}`} />
        <span className="truncate text-sm font-semibold text-gray-700">
          {label}
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
