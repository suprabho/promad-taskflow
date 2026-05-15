"use client";

import { useMemo, useState } from "react";
import {
  DndContext,
  DragEndEvent,
  PointerSensor,
  useSensor,
  useSensors,
} from "@dnd-kit/core";
import {
  addMonths,
  addWeeks,
  eachDayOfInterval,
  endOfMonth,
  endOfWeek,
  format,
  isSameDay,
  isSameMonth,
  startOfMonth,
  startOfWeek,
  subMonths,
  subWeeks,
} from "date-fns";
import { CaretLeft, CaretRight } from "@phosphor-icons/react";
import { Task } from "@/types/task";
import { useTaskStore } from "@/store/task-store";
import { CalendarDayCell } from "./calendar-day-cell";

type Granularity = "month" | "week";

const WEEKDAY_LABELS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

function dateKey(d: Date): string {
  return format(d, "yyyy-MM-dd");
}

export function TaskCalendar() {
  const { tasks, updateTask } = useTaskStore();
  const [granularity, setGranularity] = useState<Granularity>("month");
  const [cursor, setCursor] = useState<Date>(() => new Date());

  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } })
  );

  const days = useMemo(() => {
    if (granularity === "month") {
      const start = startOfWeek(startOfMonth(cursor));
      const end = endOfWeek(endOfMonth(cursor));
      return eachDayOfInterval({ start, end });
    }
    const start = startOfWeek(cursor);
    const end = endOfWeek(cursor);
    return eachDayOfInterval({ start, end });
  }, [cursor, granularity]);

  const tasksByDate = useMemo(() => {
    const map = new Map<string, Task[]>();
    for (const t of tasks) {
      if (!t.due_date) continue;
      const key = t.due_date;
      const bucket = map.get(key);
      if (bucket) bucket.push(t);
      else map.set(key, [t]);
    }
    return map;
  }, [tasks]);

  const today = new Date();

  const periodLabel = useMemo(() => {
    if (granularity === "month") return format(cursor, "MMMM yyyy");
    const start = startOfWeek(cursor);
    const end = endOfWeek(cursor);
    const sameMonth = isSameMonth(start, end);
    if (sameMonth) {
      return `${format(start, "MMM d")} – ${format(end, "d, yyyy")}`;
    }
    return `${format(start, "MMM d")} – ${format(end, "MMM d, yyyy")}`;
  }, [cursor, granularity]);

  function handlePrev() {
    setCursor((c) => (granularity === "month" ? subMonths(c, 1) : subWeeks(c, 1)));
  }

  function handleNext() {
    setCursor((c) => (granularity === "month" ? addMonths(c, 1) : addWeeks(c, 1)));
  }

  function handleToday() {
    setCursor(new Date());
  }

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over) return;
    const taskId = active.id as string;
    const targetDate = over.id as string;
    const task = tasks.find((t) => t.id === taskId);
    if (!task || task.due_date === targetDate) return;
    updateTask(taskId, { due_date: targetDate });
  }

  return (
    <div className="flex flex-col gap-3">
      <div className="flex flex-wrap items-center gap-2 px-1">
        <div className="flex items-center gap-1">
          <button
            onClick={handlePrev}
            className="rounded-md p-1.5 text-gray-600 hover:bg-gray-100"
            aria-label="Previous"
          >
            <CaretLeft weight="bold" className="h-3.5 w-3.5" />
          </button>
          <button
            onClick={handleToday}
            className="rounded-md border border-gray-200 px-2.5 py-1 text-xs font-medium text-gray-700 hover:bg-gray-100"
          >
            Today
          </button>
          <button
            onClick={handleNext}
            className="rounded-md p-1.5 text-gray-600 hover:bg-gray-100"
            aria-label="Next"
          >
            <CaretRight weight="bold" className="h-3.5 w-3.5" />
          </button>
        </div>

        <span className="text-sm font-semibold text-gray-800">{periodLabel}</span>

        <div className="ml-auto inline-flex rounded-lg border border-gray-200 bg-white p-0.5">
          {(["month", "week"] as Granularity[]).map((g) => (
            <button
              key={g}
              onClick={() => setGranularity(g)}
              className={`rounded-md px-2.5 py-1 text-xs font-medium capitalize transition-colors ${
                granularity === g
                  ? "bg-gray-900 text-white"
                  : "text-gray-600 hover:bg-gray-100"
              }`}
            >
              {g}
            </button>
          ))}
        </div>
      </div>

      <DndContext sensors={sensors} onDragEnd={handleDragEnd}>
        <div className="overflow-hidden rounded-xl border border-gray-200 bg-white">
          <div className="grid grid-cols-7 border-b border-gray-200 bg-gray-50">
            {WEEKDAY_LABELS.map((label) => (
              <div
                key={label}
                className="px-2 py-1.5 text-[10px] font-semibold uppercase tracking-wide text-gray-500"
              >
                {label}
              </div>
            ))}
          </div>

          <div className="grid grid-cols-7">
            {days.map((day) => {
              const key = dateKey(day);
              return (
                <CalendarDayCell
                  key={key}
                  dateKey={key}
                  day={day.getDate()}
                  tasks={tasksByDate.get(key) || []}
                  isToday={isSameDay(day, today)}
                  isOutsideMonth={
                    granularity === "month" && !isSameMonth(day, cursor)
                  }
                  granularity={granularity}
                />
              );
            })}
          </div>
        </div>
      </DndContext>
    </div>
  );
}
