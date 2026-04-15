"use client";

import { TaskList } from "@/components/tasks/task-list";
import { FilterBar } from "@/components/tasks/filter-bar";

export default function ListPage() {
  return (
    <>
      <FilterBar />
      <TaskList />
    </>
  );
}
