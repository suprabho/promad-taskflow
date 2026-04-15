"use client";

import { useTaskStore } from "@/store/task-store";
import { TaskRow } from "./task-row";
import {
  CaretUp,
  CaretDown,
  CheckSquareOffset,
} from "@phosphor-icons/react";

type SortField = "name" | "due_date" | "priority" | "status";

const columns: { key: SortField | null; label: string }[] = [
  { key: "name", label: "Task" },
  { key: "status", label: "Status" },
  { key: "priority", label: "Priority" },
  { key: null, label: "Type" },
  { key: "due_date", label: "Due date" },
  { key: null, label: "Assignees" },
];

export function TaskList() {
  const { tasks, loading, sortField, sortDir, setSort } = useTaskStore();

  if (loading) {
    return (
      <div className="space-y-3 py-4">
        {[...Array(5)].map((_, i) => (
          <div key={i} className="h-12 rounded-lg bg-gray-100 animate-pulse" />
        ))}
      </div>
    );
  }

  return (
    <div className="overflow-x-auto">
      {tasks.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-gray-400">
          <CheckSquareOffset className="h-12 w-12 mb-3" />
          <p className="text-lg font-medium text-gray-500">No tasks yet</p>
          <p className="text-sm">
            Click &quot;New task&quot; to create your first task.
          </p>
        </div>
      ) : (
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
      )}
    </div>
  );
}
