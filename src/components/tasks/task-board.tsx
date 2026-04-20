"use client";

import { useMemo, useState } from "react";
import {
  DndContext,
  DragEndEvent,
  DragOverEvent,
  PointerSensor,
  useSensor,
  useSensors,
  closestCorners,
} from "@dnd-kit/core";
import { Task, TaskStatus, STATUS_ORDER, STATUS_LABELS } from "@/types/task";
import { useTaskStore } from "@/store/task-store";
import { BoardColumn } from "./board-column";

type GroupBy = "status" | "project";

const NO_PROJECT = "__none__";

const statusColors: Record<TaskStatus, string> = {
  todo: "bg-gray-400",
  in_progress: "bg-yellow-400",
  review: "bg-purple-400",
  done: "bg-green-400",
  paused: "bg-slate-400",
};

const projectPalette = [
  "bg-indigo-400",
  "bg-pink-400",
  "bg-teal-400",
  "bg-amber-400",
  "bg-rose-400",
  "bg-sky-400",
  "bg-lime-400",
  "bg-fuchsia-400",
  "bg-orange-400",
  "bg-emerald-400",
];

function projectColor(project: string) {
  let hash = 0;
  for (let i = 0; i < project.length; i++) {
    hash = (hash * 31 + project.charCodeAt(i)) | 0;
  }
  return projectPalette[Math.abs(hash) % projectPalette.length];
}

export function TaskBoard() {
  const { tasks, updateTask } = useTaskStore();
  const [groupBy, setGroupBy] = useState<GroupBy>("status");

  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } })
  );

  const columns = useMemo(() => {
    if (groupBy === "status") {
      return STATUS_ORDER.map((status) => ({
        id: status,
        label: STATUS_LABELS[status],
        dotColor: statusColors[status],
        tasks: tasks.filter((t) => t.status === status),
      }));
    }

    // Group by project — one column per distinct project, plus one for unassigned
    const projectSet = new Set<string>();
    let hasUnassigned = false;
    for (const t of tasks) {
      if (t.project && t.project.trim()) projectSet.add(t.project);
      else hasUnassigned = true;
    }
    const projectNames = Array.from(projectSet).sort((a, b) =>
      a.localeCompare(b)
    );

    const cols = projectNames.map((name) => ({
      id: name,
      label: name,
      dotColor: projectColor(name),
      tasks: tasks.filter((t) => t.project === name),
    }));

    if (hasUnassigned) {
      cols.push({
        id: NO_PROJECT,
        label: "No project",
        dotColor: "bg-gray-300",
        tasks: tasks.filter((t) => !t.project || !t.project.trim()),
      });
    }

    return cols;
  }, [tasks, groupBy]);

  function applyDrop(taskId: string, targetColumnId: string) {
    if (groupBy === "status") {
      updateTask(taskId, { status: targetColumnId as TaskStatus });
    } else {
      updateTask(taskId, {
        project: targetColumnId === NO_PROJECT ? null : targetColumnId,
      });
    }
  }

  function columnIdForTask(task: Task): string {
    if (groupBy === "status") return task.status;
    return task.project && task.project.trim() ? task.project : NO_PROJECT;
  }

  function isColumnId(id: string): boolean {
    return columns.some((c) => c.id === id);
  }

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over) return;

    const taskId = active.id as string;
    const overId = over.id as string;

    if (isColumnId(overId)) {
      applyDrop(taskId, overId);
      return;
    }

    const overTask = tasks.find((t) => t.id === overId);
    if (overTask) {
      applyDrop(taskId, columnIdForTask(overTask));
    }
  }

  function handleDragOver(event: DragOverEvent) {
    const { active, over } = event;
    if (!over) return;

    const taskId = active.id as string;
    const overId = over.id as string;

    if (isColumnId(overId)) {
      const activeTask = tasks.find((t) => t.id === taskId);
      if (activeTask && columnIdForTask(activeTask) !== overId) {
        applyDrop(taskId, overId);
      }
    }
  }

  return (
    <div className="flex flex-col gap-3">
      {/* Group-by toggle */}
      <div className="flex items-center gap-2 px-1">
        <span className="text-xs font-medium text-gray-500">Group by</span>
        <div className="inline-flex rounded-lg border border-gray-200 bg-white p-0.5">
          {(["status", "project"] as GroupBy[]).map((g) => (
            <button
              key={g}
              onClick={() => setGroupBy(g)}
              className={`rounded-md px-2.5 py-1 text-xs font-medium capitalize transition-colors ${
                groupBy === g
                  ? "bg-gray-900 text-white"
                  : "text-gray-600 hover:bg-gray-100"
              }`}
            >
              {g}
            </button>
          ))}
        </div>
      </div>

      <DndContext
        sensors={sensors}
        collisionDetection={closestCorners}
        onDragEnd={handleDragEnd}
        onDragOver={handleDragOver}
      >
        <div className="flex flex-col gap-4 pb-4 px-1 md:flex-row md:overflow-x-auto">
          {columns.map((col) => (
            <BoardColumn
              key={col.id}
              id={col.id}
              label={col.label}
              dotColor={col.dotColor}
              tasks={col.tasks}
            />
          ))}
        </div>
      </DndContext>
    </div>
  );
}
