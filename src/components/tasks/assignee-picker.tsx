"use client";

import { useState, useRef, useEffect } from "react";
import { MagnifyingGlass, X, Plus } from "@phosphor-icons/react";
import { useTaskStore } from "@/store/task-store";
import { Avatar } from "@/components/ui/avatar";

type AssigneePickerProps = {
  assignees: string[];
  onChange: (assignees: string[]) => void;
};

export function AssigneePicker({ assignees, onChange }: AssigneePickerProps) {
  const { users } = useTaskStore();
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  const assignedUsers = assignees
    .map((id) => users.find((u) => u.id === id))
    .filter(Boolean);

  const available = users.filter(
    (u) =>
      !assignees.includes(u.id) &&
      u.name.toLowerCase().includes(query.toLowerCase())
  );

  // Close dropdown on outside click
  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (
        containerRef.current &&
        !containerRef.current.contains(e.target as Node)
      ) {
        setOpen(false);
        setQuery("");
      }
    }
    document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, []);

  // Focus input when dropdown opens
  useEffect(() => {
    if (open && inputRef.current) {
      inputRef.current.focus();
    }
  }, [open]);

  return (
    <div ref={containerRef}>
      <label className="text-sm font-medium text-gray-700 mb-2 block">
        Assignees
      </label>

      {/* Assigned list */}
      <div className="space-y-2 mb-2">
        {assignedUsers.map(
          (u) =>
            u && (
              <div
                key={u.id}
                className="flex items-center justify-between rounded-lg border border-gray-200 px-3 py-2"
              >
                <div className="flex items-center gap-2">
                  <Avatar name={u.name} src={u.avatar_url} size="sm" />
                  <span className="text-sm text-gray-700">{u.name}</span>
                </div>
                <button
                  onClick={() =>
                    onChange(assignees.filter((id) => id !== u.id))
                  }
                  className="text-gray-400 hover:text-red-500 transition-colors"
                  title="Remove assignee"
                >
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>
            )
        )}
      </div>

      {/* Add assignee trigger / dropdown */}
      <div className="relative">
        {!open ? (
          <button
            onClick={() => setOpen(true)}
            className="flex w-full items-center gap-2 rounded-lg border border-dashed border-gray-300 px-3 py-2 text-sm text-gray-500 hover:border-indigo-400 hover:text-indigo-600 transition-colors"
          >
            <Plus className="h-3.5 w-3.5" />
            Add assignee
          </button>
        ) : (
          <div className="rounded-lg border border-indigo-300 bg-white shadow-lg overflow-hidden">
            {/* Search input */}
            <div className="flex items-center gap-2 border-b border-gray-100 px-3 py-2">
              <MagnifyingGlass className="h-4 w-4 text-gray-400" />
              <input
                ref={inputRef}
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Search members..."
                className="flex-1 text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none bg-transparent"
              />
            </div>

            {/* Results */}
            <div className="max-h-40 overflow-y-auto">
              {available.length === 0 ? (
                <p className="px-3 py-3 text-xs text-gray-400 text-center">
                  {query ? "No matches" : "Everyone is assigned"}
                </p>
              ) : (
                available.map((u) => (
                  <button
                    key={u.id}
                    onClick={() => {
                      onChange([...assignees, u.id]);
                      setQuery("");
                      setOpen(false);
                    }}
                    className="flex w-full items-center gap-2 px-3 py-2 text-sm text-gray-700 hover:bg-indigo-50 transition-colors"
                  >
                    <Avatar name={u.name} src={u.avatar_url} size="sm" />
                    <span>{u.name}</span>
                    <span className="ml-auto text-xs text-gray-400">
                      {u.email}
                    </span>
                  </button>
                ))
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
