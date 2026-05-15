"use client";

import { useState, useRef, useEffect } from "react";
import { useDroppable } from "@dnd-kit/core";
import { Task } from "@/types/task";
import { CalendarTaskChip } from "./calendar-task-chip";

const MONTH_VISIBLE_CHIPS = 3;

export function CalendarDayCell({
  dateKey,
  day,
  tasks,
  isToday,
  isOutsideMonth,
  granularity,
}: {
  dateKey: string;
  day: number;
  tasks: Task[];
  isToday: boolean;
  isOutsideMonth: boolean;
  granularity: "month" | "week";
}) {
  const { setNodeRef, isOver } = useDroppable({ id: dateKey });
  const [showAll, setShowAll] = useState(false);
  const popoverRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!showAll) return;
    function onClickOutside(e: MouseEvent) {
      if (popoverRef.current && !popoverRef.current.contains(e.target as Node)) {
        setShowAll(false);
      }
    }
    document.addEventListener("mousedown", onClickOutside);
    return () => document.removeEventListener("mousedown", onClickOutside);
  }, [showAll]);

  const isMonth = granularity === "month";
  const visibleTasks = isMonth ? tasks.slice(0, MONTH_VISIBLE_CHIPS) : tasks;
  const overflowCount = isMonth ? tasks.length - visibleTasks.length : 0;

  return (
    <div
      ref={setNodeRef}
      className={`relative flex flex-col gap-1 border-r border-b border-gray-200 p-1.5 transition-colors ${
        isMonth ? "min-h-[96px]" : "min-h-[480px]"
      } ${isOver ? "bg-indigo-50" : "bg-white"} ${
        isOutsideMonth ? "bg-gray-50" : ""
      }`}
    >
      <div className="flex items-center justify-between">
        <span
          className={`flex h-5 min-w-[20px] items-center justify-center rounded-full px-1 text-[11px] font-medium ${
            isToday
              ? "bg-indigo-600 text-white"
              : isOutsideMonth
              ? "text-gray-400"
              : "text-gray-700"
          }`}
        >
          {day}
        </span>
      </div>

      <div
        className={`flex flex-col gap-1 ${
          !isMonth ? "overflow-y-auto" : ""
        }`}
      >
        {visibleTasks.map((task) => (
          <CalendarTaskChip key={task.id} task={task} multiline={!isMonth} />
        ))}
        {overflowCount > 0 && (
          <button
            type="button"
            onClick={(e) => {
              e.stopPropagation();
              setShowAll(true);
            }}
            className="mt-0.5 self-start rounded px-1 text-[10px] font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-700"
          >
            +{overflowCount} more
          </button>
        )}
      </div>

      {showAll && (
        <div
          ref={popoverRef}
          className="absolute left-1 top-7 z-20 w-56 rounded-lg border border-gray-200 bg-white p-2 shadow-lg"
        >
          <div className="mb-1.5 px-1 text-[10px] font-semibold uppercase tracking-wide text-gray-500">
            {tasks.length} task{tasks.length === 1 ? "" : "s"}
          </div>
          <div className="flex max-h-64 flex-col gap-1 overflow-y-auto">
            {tasks.map((task) => (
              <CalendarTaskChip key={task.id} task={task} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
