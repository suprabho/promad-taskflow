"use client";

import {
  DndContext,
  DragEndEvent,
  DragOverEvent,
  PointerSensor,
  useSensor,
  useSensors,
  closestCorners,
} from "@dnd-kit/core";
import { TaskStatus, STATUS_ORDER } from "@/types/task";
import { useTaskStore } from "@/store/task-store";
import { BoardColumn } from "./board-column";

export function TaskBoard() {
  const { tasks, updateTask } = useTaskStore();

  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } })
  );

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over) return;

    const taskId = active.id as string;
    const overId = over.id as string;

    // Dropped onto a column
    if (STATUS_ORDER.includes(overId as TaskStatus)) {
      updateTask(taskId, { status: overId as TaskStatus });
      return;
    }

    // Dropped onto another card — get its status
    const overTask = tasks.find((t) => t.id === overId);
    if (overTask) {
      updateTask(taskId, { status: overTask.status });
    }
  }

  function handleDragOver(event: DragOverEvent) {
    const { active, over } = event;
    if (!over) return;

    const taskId = active.id as string;
    const overId = over.id as string;

    if (STATUS_ORDER.includes(overId as TaskStatus)) {
      const activeTask = tasks.find((t) => t.id === taskId);
      if (activeTask && activeTask.status !== overId) {
        updateTask(taskId, { status: overId as TaskStatus });
      }
    }
  }

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCorners}
      onDragEnd={handleDragEnd}
      onDragOver={handleDragOver}
    >
      <div className="flex gap-4 overflow-x-auto pb-4 px-1">
        {STATUS_ORDER.map((status) => (
          <BoardColumn
            key={status}
            status={status}
            tasks={tasks.filter((t) => t.status === status)}
          />
        ))}
      </div>
    </DndContext>
  );
}
