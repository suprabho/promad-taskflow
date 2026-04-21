"use client";

import { useState, useRef, useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import { Bookmark, CaretDown, Check, Plus, Trash, X } from "@phosphor-icons/react";
import { useTaskStore, SavedView, ViewMode } from "@/store/task-store";
import { filtersToParams } from "@/hooks/use-filter-params";

export function ViewsMenu() {
  const pathname = usePathname();
  const router = useRouter();
  const { savedViews, activeViewId, applyView, saveView, deleteView } = useTaskStore();

  const [open, setOpen] = useState(false);
  const [saveOpen, setSaveOpen] = useState(false);
  const [name, setName] = useState("");
  const [saving, setSaving] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const currentMode: ViewMode = pathname === "/board" ? "board" : "list";
  const activeView = savedViews.find((v) => v.id === activeViewId);
  const label = activeView ? activeView.name : "Views";

  useEffect(() => {
    if (saveOpen) {
      requestAnimationFrame(() => inputRef.current?.focus());
    } else {
      setName("");
    }
  }, [saveOpen]);

  function handleApply(view: SavedView) {
    const { mode } = applyView(view);
    setOpen(false);

    const qs = filtersToParams(view.filters).toString();
    const target = mode === "board" ? "/board" : "/";
    router.push(qs ? `${target}?${qs}` : target);
  }

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    const trimmed = name.trim();
    if (!trimmed || saving) return;
    setSaving(true);
    await saveView(trimmed, currentMode);
    setSaving(false);
    setSaveOpen(false);
    setOpen(false);
  }

  async function handleDelete(e: React.MouseEvent, id: string) {
    e.stopPropagation();
    await deleteView(id);
  }

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className={`inline-flex items-center gap-1.5 rounded-lg px-2.5 py-1.5 text-xs font-medium transition-colors ${
          activeView
            ? "bg-indigo-50 text-indigo-700 hover:bg-indigo-100"
            : "text-gray-600 hover:bg-gray-100"
        }`}
      >
        <Bookmark weight={activeView ? "fill" : "regular"} className="h-3.5 w-3.5" />
        <span className="max-w-[140px] truncate">{label}</span>
        <CaretDown weight="bold" className="h-3 w-3" />
      </button>

      {open && (
        <>
          <div className="fixed inset-0 z-30" onClick={() => { setOpen(false); setSaveOpen(false); }} />
          <div className="absolute left-0 top-full z-40 mt-2 w-72 rounded-xl border border-gray-200 bg-white py-1 shadow-lg">
            <div className="max-h-64 overflow-y-auto py-1">
              {savedViews.length === 0 && (
                <div className="px-4 py-3 text-xs text-gray-400">No saved views yet.</div>
              )}
              {savedViews.map((view) => {
                const isActive = view.id === activeViewId;
                return (
                  <button
                    key={view.id}
                    onClick={() => handleApply(view)}
                    className={`group flex w-full items-center gap-2 px-3 py-2 text-left text-sm transition-colors ${
                      isActive ? "bg-indigo-50 text-indigo-700" : "text-gray-700 hover:bg-gray-50"
                    }`}
                  >
                    <span className="flex h-4 w-4 shrink-0 items-center justify-center">
                      {isActive && <Check weight="bold" className="h-3.5 w-3.5" />}
                    </span>
                    <span className="flex-1 truncate">{view.name}</span>
                    <span className="text-[10px] uppercase tracking-wide text-gray-400">
                      {view.mode}
                    </span>
                    {!view.is_builtin && (
                      <span
                        role="button"
                        tabIndex={0}
                        onClick={(e) => handleDelete(e, view.id)}
                        onKeyDown={(e) => {
                          if (e.key === "Enter" || e.key === " ") {
                            e.preventDefault();
                            handleDelete(e as unknown as React.MouseEvent, view.id);
                          }
                        }}
                        className="rounded p-1 text-gray-400 opacity-0 hover:bg-gray-200 hover:text-gray-700 group-hover:opacity-100 cursor-pointer"
                        title="Delete view"
                      >
                        <Trash className="h-3.5 w-3.5" />
                      </span>
                    )}
                  </button>
                );
              })}
            </div>

            <div className="border-t border-gray-100 p-1">
              {saveOpen ? (
                <form onSubmit={handleSave} className="flex items-center gap-1 p-1">
                  <input
                    ref={inputRef}
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="View name"
                    className="flex-1 rounded-md border border-gray-300 px-2 py-1.5 text-xs focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                    maxLength={60}
                  />
                  <button
                    type="submit"
                    disabled={!name.trim() || saving}
                    className="rounded-md bg-indigo-600 px-2.5 py-1.5 text-xs font-medium text-white hover:bg-indigo-700 disabled:opacity-50"
                  >
                    Save
                  </button>
                  <button
                    type="button"
                    onClick={() => setSaveOpen(false)}
                    className="rounded-md p-1.5 text-gray-400 hover:bg-gray-100 hover:text-gray-700"
                  >
                    <X className="h-3.5 w-3.5" />
                  </button>
                </form>
              ) : (
                <button
                  onClick={() => setSaveOpen(true)}
                  className="flex w-full items-center gap-2 rounded-md px-3 py-2 text-sm text-gray-700 hover:bg-gray-50"
                >
                  <Plus weight="bold" className="h-3.5 w-3.5 text-gray-500" />
                  Save current view
                  <span className="ml-auto text-[10px] uppercase tracking-wide text-gray-400">
                    {currentMode}
                  </span>
                </button>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
}
