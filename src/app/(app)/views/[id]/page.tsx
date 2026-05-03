"use client";

import { Suspense, useEffect, useRef } from "react";
import { useParams, useRouter } from "next/navigation";
import { useTaskStore } from "@/store/task-store";
import { TaskList } from "@/components/tasks/task-list";
import { TaskBoard } from "@/components/tasks/task-board";
import { FilterBar } from "@/components/tasks/filter-bar";
import { filtersToParams } from "@/hooks/use-filter-params";

function ViewPageInner() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const { savedViews, loading, applyView, activeViewId, filters } = useTaskStore();

  const viewId = params?.id;
  const view = savedViews.find((v) => v.id === viewId);
  const lastAppliedIdRef = useRef<string | null>(null);

  useEffect(() => {
    if (!view) return;
    if (lastAppliedIdRef.current === view.id) return;
    applyView(view);
    lastAppliedIdRef.current = view.id;
  }, [view, applyView]);

  useEffect(() => {
    if (loading) return;
    if (!view) {
      router.replace("/");
      return;
    }
    if (lastAppliedIdRef.current === view.id && activeViewId !== view.id) {
      const target = view.mode === "board" ? "/board" : "/";
      const qs = filtersToParams(filters).toString();
      router.replace(qs ? `${target}?${qs}` : target);
    }
  }, [loading, view, activeViewId, filters, router]);

  if (loading || !view) return null;

  return (
    <>
      <FilterBar />
      {view.mode === "board" ? <TaskBoard /> : <TaskList />}
    </>
  );
}

export default function ViewPage() {
  return (
    <Suspense>
      <ViewPageInner />
    </Suspense>
  );
}
