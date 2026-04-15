"use client";

import { useEffect, useRef, useState } from "react";
import { TaskProvider, useTaskStore } from "@/store/task-store";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";
import { TaskDetail } from "@/components/tasks/task-detail";
import { ErrorBoundary } from "@/components/ui/error-boundary";
import { useCurrentUser } from "@/hooks/use-current-user";
import { supabase } from "@/lib/supabase";

// Ensures the Supabase Auth user exists in public.users table
function UserSync() {
  const { user } = useCurrentUser();
  const synced = useRef(false);

  useEffect(() => {
    if (!user || synced.current) return;
    synced.current = true;

    const name =
      user.user_metadata?.full_name ||
      user.user_metadata?.name ||
      user.email?.split("@")[0] ||
      "User";

    supabase.from("users").upsert(
      {
        id: user.id,
        name,
        email: user.email!,
        avatar_url: user.user_metadata?.avatar_url || null,
        role: "member",
      },
      { onConflict: "id" }
    );
  }, [user]);

  return null;
}

function KeyboardShortcuts() {
  const { addTask, openDetail, detailOpen } = useTaskStore();

  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if (detailOpen) return;
      const tag = (e.target as HTMLElement).tagName;
      if (tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT") return;

      if (e.key === "n" || e.key === "N") {
        e.preventDefault();
        const task = addTask({ name: "" });
        openDetail(task.id);
      }
    }
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [addTask, openDetail, detailOpen]);

  return null;
}

export default function AppLayout({ children }: { children: React.ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <TaskProvider>
      <UserSync />
      <KeyboardShortcuts />
      <div className="flex min-h-screen">
        <Sidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />
        <div className="flex-1 lg:ml-56">
          <Header onMenuToggle={() => setSidebarOpen(true)} />
          <main className="p-4 sm:p-6">
            <ErrorBoundary>{children}</ErrorBoundary>
          </main>
        </div>
      </div>
      <TaskDetail />
    </TaskProvider>
  );
}
