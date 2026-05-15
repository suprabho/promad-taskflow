"use client";

import { TaskCalendar } from "@/components/tasks/task-calendar";
import { FilterBar } from "@/components/tasks/filter-bar";

export default function CalendarPage() {
  return (
    <>
      <FilterBar />
      <TaskCalendar />
    </>
  );
}
