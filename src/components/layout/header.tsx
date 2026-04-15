"use client";

import { usePathname } from "next/navigation";
import { Plus, WifiHigh, WifiSlash } from "@phosphor-icons/react";
import { Button } from "@/components/ui/button";
import { Avatar } from "@/components/ui/avatar";
import { useTaskStore } from "@/store/task-store";
import { ViewToggle } from "./view-toggle";

const pageTitles: Record<string, string> = {
  "/": "Tasks",
  "/board": "Board",
  "/settings": "Settings",
};

export function Header() {
  const pathname = usePathname();
  const { addTask, openDetail, connected } = useTaskStore();
  const title = pageTitles[pathname] || "Tasks";
  const showViewToggle = pathname === "/" || pathname === "/board";

  function handleNewTask() {
    const task = addTask({ name: "" });
    openDetail(task.id);
  }

  return (
    <header className="sticky top-0 z-20 flex h-14 items-center justify-between border-b border-gray-200 bg-white/80 backdrop-blur-sm px-6">
      <div className="flex items-center gap-4">
        <h1 className="text-lg font-semibold text-gray-900">{title}</h1>
        {showViewToggle && <ViewToggle />}
      </div>

      <div className="flex items-center gap-3">
        {/* Live indicator */}
        {connected ? (
          <div className="flex items-center gap-1.5 text-xs text-emerald-600">
            <WifiHigh weight="bold" className="h-3.5 w-3.5" />
            <span>Live</span>
          </div>
        ) : (
          <div className="flex items-center gap-1.5 text-xs text-gray-400">
            <WifiSlash weight="bold" className="h-3.5 w-3.5" />
            <span>Connecting</span>
          </div>
        )}

        {showViewToggle && (
          <Button size="sm" onClick={handleNewTask}>
            <Plus weight="bold" className="h-3.5 w-3.5" />
            New task
          </Button>
        )}

        <Avatar name="Suprabho Dhenki" size="sm" />
      </div>
    </header>
  );
}
