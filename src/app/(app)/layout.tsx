"use client";

import { useEffect } from "react";
import { TaskProvider, useTaskStore } from "@/store/task-store";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";
import { TaskDetail } from "@/components/tasks/task-detail";

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
  return (
    <TaskProvider>
      <KeyboardShortcuts />
      <div className="flex min-h-screen">
        <Sidebar />
        <div className="flex-1 ml-56">
          <Header />
          <main className="p-6">{children}</main>
        </div>
      </div>
      <TaskDetail />
    </TaskProvider>
  );
}
