"use client";

import { useState, Suspense } from "react";
import {
  MagnifyingGlass,
  Funnel,
  X,
  CaretDown,
} from "@phosphor-icons/react";
import { useTaskStore } from "@/store/task-store";
import { useFilterParams } from "@/hooks/use-filter-params";
import {
  TaskStatus,
  Priority,
  TaskType,
  STATUS_LABELS,
  PRIORITY_LABELS,
  TASK_TYPE_LABELS,
} from "@/types/task";

type MultiSelectProps = {
  label: string;
  options: { value: string; label: string }[];
  selected: string[];
  onChange: (selected: string[]) => void;
};

function MultiSelect({ label, options, selected, onChange }: MultiSelectProps) {
  const [open, setOpen] = useState(false);

  function toggle(value: string) {
    if (selected.includes(value)) {
      onChange(selected.filter((v) => v !== value));
    } else {
      onChange([...selected, value]);
    }
  }

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className={`inline-flex items-center gap-1.5 rounded-lg border px-2.5 py-1.5 text-xs font-medium transition-colors ${
          selected.length > 0
            ? "border-indigo-300 bg-indigo-50 text-indigo-700"
            : "border-gray-300 bg-white text-gray-600 hover:bg-gray-50"
        }`}
      >
        {label}
        {selected.length > 0 && (
          <span className="flex h-4 w-4 items-center justify-center rounded-full bg-indigo-600 text-[10px] text-white">
            {selected.length}
          </span>
        )}
        <CaretDown weight="bold" className="h-3 w-3" />
      </button>

      {open && (
        <>
          <div className="fixed inset-0 z-30" onClick={() => setOpen(false)} />
          <div className="absolute left-0 top-full z-40 mt-1 w-48 rounded-lg border border-gray-200 bg-white py-1 shadow-lg max-h-56 overflow-y-auto">
            {options.map((opt) => (
              <label
                key={opt.value}
                className="flex cursor-pointer items-center gap-2 px-3 py-1.5 text-sm hover:bg-gray-50"
              >
                <input
                  type="checkbox"
                  checked={selected.includes(opt.value)}
                  onChange={() => toggle(opt.value)}
                  className="h-3.5 w-3.5 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                />
                {opt.label}
              </label>
            ))}
          </div>
        </>
      )}
    </div>
  );
}

function FilterBarInner() {
  const { filters, hasActiveFilters, setFilters, clearFilters, users } =
    useTaskStore();

  // Sync filters ↔ URL search params
  useFilterParams(filters, setFilters);

  const statusOptions = Object.entries(STATUS_LABELS).map(([v, l]) => ({
    value: v,
    label: l,
  }));
  const priorityOptions = Object.entries(PRIORITY_LABELS).map(([v, l]) => ({
    value: v,
    label: l,
  }));
  const typeOptions = Object.entries(TASK_TYPE_LABELS).map(([v, l]) => ({
    value: v,
    label: l,
  }));
  const assigneeOptions = users.map((u) => ({ value: u.id, label: u.name }));

  return (
    <div className="flex flex-col flex-wrap md:flex-row justify-between gap-3 pb-4">
      {/* Search */}
      <div className="p-2 flex flex-row border items-center rounded-lg border-gray-300 bg-white focus-within:border-indigo-500 focus-within:outline-none focus:ring-1 focus-within:ring-indigo-500 overflow-hidden gap-2">
        <MagnifyingGlass className="flex h-4 w-4 text-gray-400" />
        <input
          type="text"
          placeholder="Search tasks..."
          value={filters.search}
          onChange={(e) => setFilters({ search: e.target.value })}
          className="w-full text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none"
        />
        {filters.search && (
          <button
            onClick={() => setFilters({ search: "" })}
            className="flex right-2 rounded p-0.5 text-gray-400 hover:text-gray-600"
          >
            <X className="h-4 w-4" />
          </button>
        )}
      </div>

      {/* Filter chips row */}
      <div className="flex flex-wrap items-center gap-2">
        <Funnel weight="bold" className="h-3.5 w-3.5 text-gray-400" />

        <MultiSelect
          label="Status"
          options={statusOptions}
          selected={filters.status}
          onChange={(status) => setFilters({ status: status as TaskStatus[] })}
        />

        <MultiSelect
          label="Priority"
          options={priorityOptions}
          selected={filters.priority}
          onChange={(priority) =>
            setFilters({ priority: priority as Priority[] })
          }
        />

        <MultiSelect
          label="Type"
          options={typeOptions}
          selected={filters.task_type}
          onChange={(task_type) =>
            setFilters({ task_type: task_type as TaskType[] })
          }
        />

        <MultiSelect
          label="Assignee"
          options={assigneeOptions}
          selected={filters.assignee}
          onChange={(assignee) => setFilters({ assignee })}
        />

        {/* Due date range */}
        <div className="flex items-center gap-1.5">
          <input
            type="date"
            value={filters.due_from}
            onChange={(e) => setFilters({ due_from: e.target.value })}
            className="rounded-lg border border-gray-300 px-2 py-1.5 text-xs text-gray-600 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            title="Due from"
          />
          <span className="text-xs text-gray-400">to</span>
          <input
            type="date"
            value={filters.due_to}
            onChange={(e) => setFilters({ due_to: e.target.value })}
            className="rounded-lg border border-gray-300 px-2 py-1.5 text-xs text-gray-600 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            title="Due to"
          />
        </div>

        {/* Clear all */}
        {hasActiveFilters && (
          <button
            onClick={clearFilters}
            className="ml-1 inline-flex items-center gap-1 rounded-lg px-2 py-1.5 text-xs font-medium text-red-600 hover:bg-red-50 transition-colors"
          >
            <X weight="bold" className="h-3 w-3" />
            Clear filters
          </button>
        )}
      </div>
    </div>
  );
}

export function FilterBar() {
  return (
    <Suspense>
      <FilterBarInner />
    </Suspense>
  );
}
