"use client";

import { useDroppable } from "@dnd-kit/core";
import {
  SortableContext,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { CaretDown } from "@phosphor-icons/react";
import { Task } from "@/types/task";
import { TaskCard } from "./task-card";

export function BoardColumn({
  id,
  label,
  dotColor,
  tasks,
  isCollapsed,
  onToggleCollapse,
}: {
  id: string;
  label: string;
  dotColor: string;
  tasks: Task[];
  isCollapsed: boolean;
  onToggleCollapse: () => void;
}) {
  const { setNodeRef, isOver } = useDroppable({ id });

  return (
    <div
      ref={setNodeRef}
      className={`flex w-full shrink-0 flex-col overflow-hidden rounded-xl bg-gray-50 transition-[background-color,width] md:h-full ${
        isCollapsed ? "md:w-12" : "md:w-72"
      } ${isOver ? "bg-indigo-50 ring-2 ring-indigo-200" : ""}`}
    >
      <button
        onClick={onToggleCollapse}
        aria-expanded={!isCollapsed}
        aria-label={isCollapsed ? `Expand ${label}` : `Collapse ${label}`}
        className={`flex shrink-0 items-center gap-2 px-3 py-3 text-left transition-colors hover:bg-gray-100/60 ${
          isCollapsed
            ? "md:h-full md:flex-col md:items-center md:gap-3 md:px-2 md:py-4"
            : ""
        }`}
      >
        <CaretDown
          weight="bold"
          className={`h-3.5 w-3.5 shrink-0 text-gray-400 transition-transform ${
            isCollapsed ? "-rotate-90" : ""
          }`}
        />
        <div className={`h-2 w-2 shrink-0 rounded-full ${dotColor}`} />
        <span
          className={`flex-1 truncate text-sm font-semibold text-gray-700 ${
            isCollapsed ? "md:[writing-mode:vertical-rl]" : ""
          }`}
        >
          {label}
        </span>
        <span className="text-xs font-medium text-gray-400">
          {tasks.length}
        </span>
      </button>

      {!isCollapsed && (
        <div className="flex max-h-[55vh] min-h-0 flex-1 flex-col gap-2 overflow-y-auto px-2 pb-2 md:max-h-none">
          <SortableContext
            items={tasks.map((t) => t.id)}
            strategy={verticalListSortingStrategy}
          >
            {tasks.map((task) => (
              <TaskCard key={task.id} task={task} />
            ))}
          </SortableContext>
        </div>
      )}
    </div>
  );
}
