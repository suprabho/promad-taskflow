"use client";

import { useState } from "react";
import { usePathname } from "next/navigation";
import { Plus, WifiHigh, WifiSlash, UserCircle, List, SignOut } from "@phosphor-icons/react";
import { Button } from "@/components/ui/button";
import { Avatar } from "@/components/ui/avatar";
import { useTaskStore } from "@/store/task-store";
import { ViewsMenu } from "./views-menu";
import { NotificationBell } from "./notification-bell";

const pageTitles: Record<string, string> = {
  "/": "Tasks",
  "/board": "Board",
  "/settings": "Settings",
};

export function Header({ onMenuToggle }: { onMenuToggle?: () => void }) {
  const pathname = usePathname();
  const { addTask, openDetail, connected, myTasksOnly, toggleMyTasks, currentUserId, users, signOut } = useTaskStore();
  const [menuOpen, setMenuOpen] = useState(false);

  const title = pageTitles[pathname] || "Tasks";
  const showViewToggle = pathname === "/" || pathname === "/board";
  const currentUser = currentUserId ? users.find((u) => u.id === currentUserId) : null;

  function handleNewTask() {
    const task = addTask({ name: "" });
    openDetail(task.id);
  }

  return (
    <header className="sticky top-0 z-20 flex h-14 w-full items-center justify-between gap-2 border-b border-gray-200 bg-white/80 backdrop-blur-sm px-3 sm:px-6">
      <div className="flex min-w-0 flex-1 items-center gap-2 sm:gap-3">
        {onMenuToggle && (
          <button
            onClick={onMenuToggle}
            className="shrink-0 rounded-lg p-1.5 text-gray-500 hover:bg-gray-100 lg:hidden"
          >
            <List weight="bold" className="h-5 w-5" />
          </button>
        )}
        <h1 className="truncate text-lg font-semibold text-gray-900">{title}</h1>
        {showViewToggle && <ViewsMenu />}
      </div>

      <div className="flex shrink-0 items-center gap-2 sm:gap-3">
        {/* Live indicator */}
        {connected ? (
          <div className="hidden lg:flex items-center gap-1.5 text-xs text-emerald-600">
            <WifiHigh weight="bold" className="h-3.5 w-3.5" />
            <span>Live</span>
          </div>
        ) : (
          <div className="hidden lg:flex items-center gap-1.5 text-xs text-gray-400">
            <WifiSlash weight="bold" className="h-3.5 w-3.5" />
            <span>Connecting</span>
          </div>
        )}

        {showViewToggle && (
          <>
            <button
              onClick={toggleMyTasks}
              className={`hidden md:inline-flex items-center gap-1.5 rounded-lg px-2.5 py-1.5 text-xs font-medium transition-colors ${
                myTasksOnly
                  ? "bg-indigo-100 text-indigo-700"
                  : "text-gray-500 hover:bg-gray-100 hover:text-gray-700"
              }`}
              title="Toggle my tasks"
            >
              <UserCircle weight={myTasksOnly ? "fill" : "regular"} className="h-4 w-4" />
              My tasks
            </button>
            <Button size="sm" onClick={handleNewTask}>
              <Plus weight="bold" className="h-3.5 w-3.5" />
              <span className="hidden sm:inline">New task</span>
            </Button>
          </>
        )}

        <NotificationBell />

        {/* User avatar + dropdown */}
        <div className="relative">
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className="rounded-full focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            <Avatar
              name={currentUser?.name || "User"}
              src={currentUser?.avatar_url}
              size="sm"
            />
          </button>

          {menuOpen && (
            <>
              <div className="fixed inset-0 z-30" onClick={() => setMenuOpen(false)} />
              <div className="absolute right-0 top-full z-40 mt-2 w-56 rounded-xl border border-gray-200 bg-white py-1 shadow-lg">
                <div className="px-4 py-2.5 border-b border-gray-100">
                  <p className="text-sm font-medium text-gray-900 truncate">
                    {currentUser?.name || "User"}
                  </p>
                  <p className="text-xs text-gray-500 truncate">
                    {currentUser?.email || ""}
                  </p>
                </div>
                <button
                  onClick={() => {
                    setMenuOpen(false);
                    signOut();
                  }}
                  className="flex w-full items-center gap-2 px-4 py-2.5 text-sm text-gray-600 hover:bg-gray-50 transition-colors"
                >
                  <SignOut className="h-4 w-4" />
                  Sign out
                </button>
              </div>
            </>
          )}
        </div>
      </div>
    </header>
  );
}
