"use client";

import { useEffect, useRef, useState } from "react";
import { X, Trash, Link as LinkIcon, Check } from "@phosphor-icons/react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
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

const MARKDOWN_COMPONENTS = {
  h1: (p: { children?: React.ReactNode }) => (
    <h1 className="mb-1.5 mt-3 text-lg font-semibold text-gray-900 first:mt-0">
      {p.children}
    </h1>
  ),
  h2: (p: { children?: React.ReactNode }) => (
    <h2 className="mb-1.5 mt-3 text-base font-semibold text-gray-900 first:mt-0">
      {p.children}
    </h2>
  ),
  h3: (p: { children?: React.ReactNode }) => (
    <h3 className="mb-1 mt-2 text-sm font-semibold text-gray-900 first:mt-0">
      {p.children}
    </h3>
  ),
  p: (p: { children?: React.ReactNode }) => (
    <p className="my-1.5 text-sm text-gray-700 first:mt-0 last:mb-0">
      {p.children}
    </p>
  ),
  ul: (p: { children?: React.ReactNode }) => (
    <ul className="my-1.5 list-disc space-y-0.5 pl-5 text-sm text-gray-700">
      {p.children}
    </ul>
  ),
  ol: (p: { children?: React.ReactNode }) => (
    <ol className="my-1.5 list-decimal space-y-0.5 pl-5 text-sm text-gray-700">
      {p.children}
    </ol>
  ),
  a: (p: { href?: string; children?: React.ReactNode }) => (
    <a
      href={p.href}
      target="_blank"
      rel="noopener noreferrer"
      className="text-indigo-600 hover:underline"
      onClick={(e) => e.stopPropagation()}
    >
      {p.children}
    </a>
  ),
  code: (p: { children?: React.ReactNode; className?: string }) => {
    const isBlock = p.className?.startsWith("language-");
    return isBlock ? (
      <code className="block font-mono text-xs text-gray-800">
        {p.children}
      </code>
    ) : (
      <code className="rounded bg-gray-100 px-1 py-0.5 font-mono text-[0.85em] text-gray-800">
        {p.children}
      </code>
    );
  },
  pre: (p: { children?: React.ReactNode }) => (
    <pre className="my-2 overflow-x-auto rounded bg-gray-50 p-2 font-mono text-xs">
      {p.children}
    </pre>
  ),
  blockquote: (p: { children?: React.ReactNode }) => (
    <blockquote className="my-1.5 border-l-2 border-gray-300 pl-3 italic text-gray-600">
      {p.children}
    </blockquote>
  ),
  hr: () => <hr className="my-3 border-gray-200" />,
  strong: (p: { children?: React.ReactNode }) => (
    <strong className="font-semibold text-gray-900">{p.children}</strong>
  ),
  em: (p: { children?: React.ReactNode }) => (
    <em className="italic">{p.children}</em>
  ),
  table: (p: { children?: React.ReactNode }) => (
    <div className="my-2 overflow-x-auto">
      <table className="w-full border-collapse text-sm text-gray-700">
        {p.children}
      </table>
    </div>
  ),
  th: (p: { children?: React.ReactNode }) => (
    <th className="border border-gray-200 bg-gray-50 px-2 py-1 text-left font-semibold">
      {p.children}
    </th>
  ),
  td: (p: { children?: React.ReactNode }) => (
    <td className="border border-gray-200 px-2 py-1">{p.children}</td>
  ),
};

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
  const [copied, setCopied] = useState(false);
  const [name, setName] = useState(task?.name ?? "");
  const [details, setDetails] = useState(task?.details ?? "");
  const [project, setProject] = useState(task?.project ?? "");
  const [editingDetails, setEditingDetails] = useState(false);
  const detailsRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    setConfirmDelete(false);
    setCopied(false);
    setEditingDetails(false);
    if (task) {
      setName(task.name);
      setDetails(task.details);
      setProject(task.project ?? "");
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedTaskId]);

  useEffect(() => {
    if (editingDetails && detailsRef.current) {
      const ta = detailsRef.current;
      ta.focus();
      const end = ta.value.length;
      ta.setSelectionRange(end, end);
    }
  }, [editingDetails]);

  async function copyLink() {
    if (!task) return;
    const url = `${window.location.origin}/tasks/${task.id}`;
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch {
      // ignored — clipboard unavailable
    }
  }

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
      <div className="fixed right-0 top-0 z-50 flex h-screen w-full flex-col border-l border-gray-200 bg-white shadow-xl animate-in slide-in-from-right sm:max-w-lg lg:max-w-none lg:w-1/2">
        {/* Header */}
        <div className="z-10 flex shrink-0 items-center justify-between border-b border-gray-200 bg-white px-6 py-4">
          <h2 className="text-lg font-semibold text-gray-900">Task details</h2>
          <div className="flex items-center gap-1">
            <button
              onClick={copyLink}
              title={copied ? "Link copied" : "Copy link to task"}
              className="flex items-center gap-1.5 rounded-lg px-2 py-1.5 text-xs font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-700"
            >
              {copied ? (
                <>
                  <Check weight="bold" className="h-4 w-4 text-green-600" />
                  <span className="text-green-600">Copied</span>
                </>
              ) : (
                <>
                  <LinkIcon weight="bold" className="h-4 w-4" />
                  <span>Copy link</span>
                </>
              )}
            </button>
            <button
              onClick={closeDetail}
              className="rounded-lg p-1.5 text-gray-400 hover:bg-gray-100 hover:text-gray-600"
            >
              <X weight="bold" className="h-5 w-5" />
            </button>
          </div>
        </div>

        {/* Body — single scroll on small screens, two columns on lg+ */}
        <div className="flex-1 overflow-y-auto lg:flex lg:overflow-hidden">
          {/* Main column: Name + Details */}
          <div className="space-y-5 px-6 py-5 lg:flex-1 lg:min-w-0 lg:overflow-y-auto">
            {/* Name */}
            <Input
              label="Task name"
              value={name}
              placeholder="Enter task name..."
              onChange={(e) => setName(e.target.value)}
              onBlur={() => {
                if (name !== task.name) updateTask(task.id, { name });
              }}
            />

            {/* Details */}
            <div className="flex flex-col gap-1.5">
              <label className="text-sm font-medium text-gray-700">
                Details
              </label>
              {editingDetails ? (
                <Textarea
                  ref={detailsRef}
                  value={details}
                  placeholder="Add a description... (markdown supported)"
                  rows={10}
                  onChange={(e) => setDetails(e.target.value)}
                  onBlur={() => {
                    if (details !== task.details)
                      updateTask(task.id, { details });
                    setEditingDetails(false);
                  }}
                />
              ) : (
                <div
                  role="button"
                  tabIndex={0}
                  onClick={() => setEditingDetails(true)}
                  onKeyDown={(e) => {
                    if (e.key === "Enter" || e.key === " ") {
                      e.preventDefault();
                      setEditingDetails(true);
                    }
                  }}
                  className="min-h-[10rem] cursor-text rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-900 hover:border-gray-400 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  {details ? (
                    <ReactMarkdown
                      remarkPlugins={[remarkGfm]}
                      components={MARKDOWN_COMPONENTS}
                    >
                      {details}
                    </ReactMarkdown>
                  ) : (
                    <span className="text-gray-400">
                      Add a description... (markdown supported)
                    </span>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Sidebar: properties + comments + activity + metadata + delete */}
          <div className="space-y-5 px-6 pb-5 border-gray-200 lg:w-72 lg:shrink-0 lg:border-l lg:overflow-y-auto lg:pt-5">
            {/* Status */}
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

            {/* Priority */}
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

            {/* Type */}
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

            {/* Due date */}
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

            {/* Project */}
            <Input
              label="Project"
              value={project}
              placeholder="e.g. Merkle Science, Kidzovo, Begin..."
              onChange={(e) => setProject(e.target.value)}
              onBlur={() => {
                const next = project.trim() ? project : null;
                if (next !== task.project)
                  updateTask(task.id, { project: next });
              }}
            />

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
      </div>
    </>
  );
}
