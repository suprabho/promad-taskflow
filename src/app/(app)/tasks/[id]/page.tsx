"use client";

import { Suspense, useEffect, useRef } from "react";
import { useParams, useRouter } from "next/navigation";
import { useTaskStore } from "@/store/task-store";
import { TaskList } from "@/components/tasks/task-list";
import { FilterBar } from "@/components/tasks/filter-bar";

function TaskPageInner() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const { allTasks, loading, openDetail } = useTaskStore();

  const taskId = params?.id;
  const opened = useRef(false);

  useEffect(() => {
    if (loading || !taskId || opened.current) return;
    const exists = allTasks.some((t) => t.id === taskId);
    if (!exists) {
      router.replace("/");
      return;
    }
    opened.current = true;
    openDetail(taskId);
    router.replace("/");
  }, [loading, taskId, allTasks, openDetail, router]);

  return (
    <>
      <FilterBar />
      <TaskList />
    </>
  );
}

export default function TaskPage() {
  return (
    <Suspense>
      <TaskPageInner />
    </Suspense>
  );
}
