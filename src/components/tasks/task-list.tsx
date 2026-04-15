"use client";

import { useTaskStore } from "@/store/task-store";
import { TaskRow } from "./task-row";
import { PriorityBadge, StatusBadge, TypeBadge } from "@/components/ui/badge";
import { AvatarGroup } from "@/components/ui/avatar";
import {
  CaretUp,
  CaretDown,
  CheckSquareOffset,
  FunnelSimple,
  CalendarBlank,
} from "@phosphor-icons/react";
import { Task } from "@/types/task";

type SortField = "name" | "due_date" | "priority" | "status";

const columns: { key: SortField | null; label: string }[] = [
  { key: "name", label: "Task" },
  { key: "status", label: "Status" },
  { key: "priority", label: "Priority" },
  { key: null, label: "Type" },
  { key: "due_date", label: "Due date" },
  { key: null, label: "Assignees" },
];

function formatDate(dateStr: string | null) {
  if (!dateStr) return null;
  const d = new Date(dateStr);
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

function MobileTaskCard({ task }: { task: Task }) {
  const { openDetail, getUserById } = useTaskStore();
  const assigneeUsers = task.assignees
    .map((id) => getUserById(id))
    .filter(Boolean) as { name: string; avatar_url: string | null }[];
  const due = formatDate(task.due_date);

  return (
    <div
      onClick={() => openDetail(task.id)}
      className="rounded-xl border border-gray-200 bg-white p-4 cursor-pointer hover:shadow-md transition-shadow"
    >
      <p className="text-sm font-medium text-gray-900 mb-2">
        {task.name || "Untitled task"}
      </p>
      <div className="flex flex-wrap items-center gap-1.5 mb-3">
        <StatusBadge status={task.status} />
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
            max={3}
          />
        )}
      </div>
    </div>
  );
}

export function TaskList() {
  const { tasks, loading, sortField, sortDir, setSort, hasActiveFilters, clearFilters } = useTaskStore();

  if (loading) {
    return (
      <div className="space-y-3 py-4">
        {[...Array(5)].map((_, i) => (
          <div key={i} className="h-12 rounded-lg bg-gray-100 animate-pulse" />
        ))}
      </div>
    );
  }

  if (tasks.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-gray-400">
        {hasActiveFilters ? (
          <>
            <FunnelSimple className="h-12 w-12 mb-3" />
            <p className="text-lg font-medium text-gray-500">No matching tasks</p>
            <p className="text-sm mb-3">
              Try adjusting your filters to see more results.
            </p>
            <button
              onClick={clearFilters}
              className="text-sm font-medium text-indigo-600 hover:text-indigo-700"
            >
              Clear all filters
            </button>
          </>
        ) : (
          <>
            <CheckSquareOffset className="h-12 w-12 mb-3" />
            <p className="text-lg font-medium text-gray-500">No tasks yet</p>
            <p className="text-sm">
              Click &quot;New task&quot; or press <kbd className="rounded border border-gray-300 bg-gray-50 px-1.5 py-0.5 text-xs font-mono">N</kbd> to create your first task.
            </p>
          </>
        )}
      </div>
    );
  }

  return (
    <>
      {/* Mobile: card layout */}
      <div className="grid gap-3 sm:hidden">
        {tasks.map((task) => (
          <MobileTaskCard key={task.id} task={task} />
        ))}
      </div>

      {/* Desktop: table layout */}
      <div className="hidden sm:block overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="border-b border-gray-200">
              {columns.map((col, i) => (
                <th
                  key={i}
                  className={`py-2.5 px-4 text-left text-xs font-medium uppercase tracking-wider text-gray-500 ${
                    col.key ? "cursor-pointer select-none hover:text-gray-700" : ""
                  }`}
                  onClick={() => col.key && setSort(col.key)}
                >
                  <span className="flex items-center gap-1">
                    {col.label}
                    {col.key && col.key === sortField && (
                      sortDir === "asc" ? (
                        <CaretUp weight="bold" className="h-3 w-3" />
                      ) : (
                        <CaretDown weight="bold" className="h-3 w-3" />
                      )
                    )}
                  </span>
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {tasks.map((task) => (
              <TaskRow key={task.id} task={task} />
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
