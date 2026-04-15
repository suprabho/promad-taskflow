"use client";

import { useEffect, useState } from "react";
import { X, Trash } from "@phosphor-icons/react";
import { useTaskStore } from "@/store/task-store";
import { Input, Textarea } from "@/components/ui/input";
import { Select } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { AssigneePicker } from "@/components/tasks/assignee-picker";
import { CommentThread } from "@/components/tasks/comment-thread";
import { ActivityFeed } from "@/components/tasks/activity-feed";
import {
  TaskStatus,
  Priority,
  TaskType,
  STATUS_LABELS,
  PRIORITY_LABELS,
  TASK_TYPE_LABELS,
} from "@/types/task";

export function TaskDetail() {
  const {
    tasks,
    selectedTaskId,
    detailOpen,
    closeDetail,
    updateTask,
    deleteTask,
  } = useTaskStore();

  const task = tasks.find((t) => t.id === selectedTaskId);
  const [confirmDelete, setConfirmDelete] = useState(false);

  // Reset delete confirmation when task changes
  useEffect(() => {
    setConfirmDelete(false);
  }, [selectedTaskId]);

  if (!detailOpen || !task) return null;

  const statusOptions = Object.entries(STATUS_LABELS).map(([v, l]) => ({
    value: v,
    label: l,
  }));
  const priorityOptions = Object.entries(PRIORITY_LABELS).map(([v, l]) => ({
    value: v,
    label: l,
  }));
  const typeOptions = Object.entries(TASK_TYPE_LABELS).map(([v, l]) => ({
    value: v,
    label: l,
  }));

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 z-40 bg-black/20 backdrop-blur-[2px]"
        onClick={closeDetail}
      />

      {/* Panel */}
      <div className="fixed right-0 top-0 z-50 h-screen w-full max-w-lg overflow-y-auto border-l border-gray-200 bg-white shadow-xl animate-in slide-in-from-right">
        {/* Header */}
        <div className="sticky top-0 z-10 flex items-center justify-between border-b border-gray-200 bg-white px-6 py-4">
          <h2 className="text-lg font-semibold text-gray-900">Task details</h2>
          <button
            onClick={closeDetail}
            className="rounded-lg p-1.5 text-gray-400 hover:bg-gray-100 hover:text-gray-600"
          >
            <X weight="bold" className="h-5 w-5" />
          </button>
        </div>

        <div className="space-y-5 px-6 py-5">
          {/* Name */}
          <Input
            label="Task name"
            value={task.name}
            placeholder="Enter task name..."
            onChange={(e) => updateTask(task.id, { name: e.target.value })}
          />

          {/* Details */}
          <Textarea
            label="Details"
            value={task.details}
            placeholder="Add a description..."
            rows={4}
            onChange={(e) => updateTask(task.id, { details: e.target.value })}
          />

          {/* Status & Priority row */}
          <div className="grid grid-cols-2 gap-4">
            <Select
              label="Status"
              options={statusOptions}
              value={task.status}
              onChange={(e) =>
                updateTask(task.id, {
                  status: e.target.value as TaskStatus,
                })
              }
            />
            <Select
              label="Priority"
              options={priorityOptions}
              value={task.priority}
              onChange={(e) =>
                updateTask(task.id, {
                  priority: e.target.value as Priority,
                })
              }
            />
          </div>

          {/* Type & Due date row */}
          <div className="grid grid-cols-2 gap-4">
            <Select
              label="Type"
              options={typeOptions}
              value={task.task_type}
              onChange={(e) =>
                updateTask(task.id, {
                  task_type: e.target.value as TaskType,
                })
              }
            />
            <Input
              label="Due date"
              type="date"
              value={task.due_date || ""}
              onChange={(e) =>
                updateTask(task.id, {
                  due_date: e.target.value || null,
                })
              }
            />
          </div>

          {/* Assignees */}
          <AssigneePicker
            assignees={task.assignees}
            onChange={(assignees) => updateTask(task.id, { assignees })}
          />

          {/* Comments */}
          <div className="border-t border-gray-200 pt-4">
            <CommentThread taskId={task.id} />
          </div>

          {/* Activity */}
          <div className="border-t border-gray-200 pt-4">
            <ActivityFeed taskId={task.id} />
          </div>

          {/* Metadata */}
          <div className="border-t border-gray-200 pt-4 space-y-1">
            <p className="text-xs text-gray-400">
              Created{" "}
              {new Date(task.created_at).toLocaleDateString("en-US", {
                month: "short",
                day: "numeric",
                year: "numeric",
              })}
            </p>
            <p className="text-xs text-gray-400">
              Updated{" "}
              {new Date(task.updated_at).toLocaleDateString("en-US", {
                month: "short",
                day: "numeric",
                year: "numeric",
              })}
            </p>
          </div>

          {/* Delete */}
          <div className="border-t border-gray-200 pt-4">
            {confirmDelete ? (
              <div className="flex items-center gap-2">
                <span className="text-sm text-red-600">Are you sure?</span>
                <Button
                  variant="danger"
                  size="sm"
                  onClick={() => deleteTask(task.id)}
                >
                  Yes, delete
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setConfirmDelete(false)}
                >
                  Cancel
                </Button>
              </div>
            ) : (
              <Button
                variant="ghost"
                size="sm"
                className="text-red-500 hover:bg-red-50 hover:text-red-600"
                onClick={() => setConfirmDelete(true)}
              >
                <Trash className="h-4 w-4" />
                Delete task
              </Button>
            )}
          </div>
        </div>
      </div>
    </>
  );
}
