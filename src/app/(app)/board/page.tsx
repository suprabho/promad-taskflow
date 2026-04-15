"use client";

import { TaskBoard } from "@/components/tasks/task-board";
import { FilterBar } from "@/components/tasks/filter-bar";

export default function BoardPage() {
  return (
    <>
      <FilterBar />
      <TaskBoard />
    </>
  );
}
