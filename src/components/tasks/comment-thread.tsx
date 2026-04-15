"use client";

import { useState, useRef, useEffect } from "react";
import { PaperPlaneRight, Trash } from "@phosphor-icons/react";
import { useComments } from "@/hooks/use-comments";
import { useTaskStore } from "@/store/task-store";
import { Avatar } from "@/components/ui/avatar";

const DEFAULT_USER_ID = "00000000-0000-0000-0000-000000000001";

export function CommentThread({ taskId }: { taskId: string }) {
  const { comments, loading, addComment, deleteComment } = useComments(taskId);
  const { getUserById } = useTaskStore();
  const [body, setBody] = useState("");
  const scrollRef = useRef<HTMLDivElement>(null);

  // Auto-scroll to bottom when new comments arrive
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [comments.length]);

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!body.trim()) return;
    addComment(body);
    setBody("");
  }

  function handleKeyDown(e: React.KeyboardEvent) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSubmit(e);
    }
  }

  return (
    <div>
      <label className="text-sm font-medium text-gray-700 mb-2 block">
        Comments
      </label>

      {/* Comment list */}
      <div
        ref={scrollRef}
        className="max-h-64 overflow-y-auto space-y-3 mb-3"
      >
        {loading && comments.length === 0 && (
          <p className="text-xs text-gray-400 py-2">Loading comments...</p>
        )}

        {!loading && comments.length === 0 && (
          <p className="text-xs text-gray-400 py-2">No comments yet</p>
        )}

        {comments.map((comment) => {
          const author = getUserById(comment.author_id);
          const isOwn = comment.author_id === DEFAULT_USER_ID;

          return (
            <div
              key={comment.id}
              className="group rounded-lg border border-gray-100 bg-gray-50 px-3 py-2.5"
            >
              <div className="flex items-center justify-between mb-1">
                <div className="flex items-center gap-2">
                  <Avatar
                    name={author?.name || "Unknown"}
                    src={author?.avatar_url}
                    size="sm"
                  />
                  <span className="text-xs font-medium text-gray-700">
                    {author?.name || "Unknown"}
                  </span>
                  <span className="text-xs text-gray-400">
                    {formatTime(comment.created_at)}
                  </span>
                </div>
                {isOwn && (
                  <button
                    onClick={() => deleteComment(comment.id)}
                    className="opacity-0 group-hover:opacity-100 text-gray-400 hover:text-red-500 transition-opacity"
                    title="Delete comment"
                  >
                    <Trash className="h-3.5 w-3.5" />
                  </button>
                )}
              </div>
              <p className="text-sm text-gray-600 whitespace-pre-wrap pl-8">
                {comment.body}
              </p>
            </div>
          );
        })}
      </div>

      {/* Input */}
      <form onSubmit={handleSubmit} className="flex gap-2">
        <textarea
          value={body}
          onChange={(e) => setBody(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder="Write a comment..."
          rows={1}
          className="flex-1 resize-none rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-900 placeholder:text-gray-400 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        />
        <button
          type="submit"
          disabled={!body.trim()}
          className="rounded-lg bg-indigo-600 px-3 py-2 text-white hover:bg-indigo-700 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
        >
          <PaperPlaneRight weight="bold" className="h-4 w-4" />
        </button>
      </form>
    </div>
  );
}

function formatTime(iso: string) {
  const d = new Date(iso);
  const now = new Date();
  const diffMs = now.getTime() - d.getTime();
  const diffMin = Math.floor(diffMs / 60000);

  if (diffMin < 1) return "just now";
  if (diffMin < 60) return `${diffMin}m ago`;

  const diffHr = Math.floor(diffMin / 60);
  if (diffHr < 24) return `${diffHr}h ago`;

  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}
