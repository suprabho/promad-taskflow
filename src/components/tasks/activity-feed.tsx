"use client";

import { ClockCounterClockwise } from "@phosphor-icons/react";
import { useActivity } from "@/hooks/use-activity";
import { useTaskStore } from "@/store/task-store";
import { Avatar } from "@/components/ui/avatar";

export function ActivityFeed({ taskId }: { taskId: string }) {
  const { logs, loading } = useActivity(taskId);
  const { getUserById } = useTaskStore();

  return (
    <div>
      <label className="text-sm font-medium text-gray-700 mb-2 flex items-center gap-1.5">
        <ClockCounterClockwise className="h-4 w-4" />
        Activity
      </label>

      <div className="max-h-48 overflow-y-auto space-y-2">
        {loading && logs.length === 0 && (
          <p className="text-xs text-gray-400 py-2">Loading activity...</p>
        )}

        {!loading && logs.length === 0 && (
          <p className="text-xs text-gray-400 py-2">No activity yet</p>
        )}

        {logs.map((log) => {
          const actor = getUserById(log.actor_id);

          return (
            <div key={log.id} className="flex items-start gap-2 py-1">
              <Avatar
                name={actor?.name || "Unknown"}
                src={actor?.avatar_url}
                size="sm"
              />
              <div className="flex-1 min-w-0">
                <p className="text-xs text-gray-600">
                  <span className="font-medium text-gray-700">
                    {actor?.name || "Unknown"}
                  </span>{" "}
                  {log.action}
                </p>
                <p className="text-xs text-gray-400">
                  {formatActivityTime(log.created_at)}
                </p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function formatActivityTime(iso: string) {
  const d = new Date(iso);
  const now = new Date();
  const diffMs = now.getTime() - d.getTime();
  const diffMin = Math.floor(diffMs / 60000);

  if (diffMin < 1) return "just now";
  if (diffMin < 60) return `${diffMin}m ago`;

  const diffHr = Math.floor(diffMin / 60);
  if (diffHr < 24) return `${diffHr}h ago`;

  const diffDay = Math.floor(diffHr / 24);
  if (diffDay < 7) return `${diffDay}d ago`;

  return d.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
  });
}
