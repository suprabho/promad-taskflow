"use client";

import { useState } from "react";
import { Bell, CheckCircle, Checks } from "@phosphor-icons/react";
import { useNotifications } from "@/hooks/use-notifications";
import { useTaskStore } from "@/store/task-store";

export function NotificationBell() {
  const [open, setOpen] = useState(false);
  const { notifications, unreadCount, markAsRead, markAllAsRead } =
    useNotifications();
  const { openDetail } = useTaskStore();

  function handleClick(notifId: string, taskId: string) {
    markAsRead(notifId);
    setOpen(false);
    openDetail(taskId);
  }

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="relative rounded-lg p-1.5 text-gray-500 hover:bg-gray-100 hover:text-gray-700 transition-colors"
        title="Notifications"
      >
        <Bell weight={unreadCount > 0 ? "fill" : "regular"} className="h-5 w-5" />
        {unreadCount > 0 && (
          <span className="absolute -right-0.5 -top-0.5 flex h-4 min-w-[16px] items-center justify-center rounded-full bg-red-500 px-1 text-[10px] font-bold text-white">
            {unreadCount > 9 ? "9+" : unreadCount}
          </span>
        )}
      </button>

      {open && (
        <>
          <div className="fixed inset-0 z-30" onClick={() => setOpen(false)} />
          <div className="absolute right-0 top-full z-40 mt-2 w-80 rounded-xl border border-gray-200 bg-white shadow-xl">
            {/* Header */}
            <div className="flex items-center justify-between border-b border-gray-100 px-4 py-3">
              <h3 className="text-sm font-semibold text-gray-900">
                Notifications
              </h3>
              {unreadCount > 0 && (
                <button
                  onClick={markAllAsRead}
                  className="flex items-center gap-1 text-xs font-medium text-indigo-600 hover:text-indigo-700"
                >
                  <Checks weight="bold" className="h-3.5 w-3.5" />
                  Mark all read
                </button>
              )}
            </div>

            {/* List */}
            <div className="max-h-80 overflow-y-auto">
              {notifications.length === 0 ? (
                <div className="flex flex-col items-center justify-center py-8 text-gray-400">
                  <Bell className="h-8 w-8 mb-2" />
                  <p className="text-sm">No notifications yet</p>
                </div>
              ) : (
                notifications.map((notif) => (
                  <button
                    key={notif.id}
                    onClick={() => handleClick(notif.id, notif.task_id)}
                    className={`flex w-full items-start gap-3 px-4 py-3 text-left transition-colors hover:bg-gray-50 ${
                      !notif.read ? "bg-indigo-50/50" : ""
                    }`}
                  >
                    <div className="mt-0.5 flex-shrink-0">
                      {notif.read ? (
                        <CheckCircle
                          weight="fill"
                          className="h-4 w-4 text-gray-300"
                        />
                      ) : (
                        <div className="h-2 w-2 mt-1 rounded-full bg-indigo-500" />
                      )}
                    </div>
                    <div className="min-w-0 flex-1">
                      <p
                        className={`text-sm ${
                          notif.read
                            ? "text-gray-500"
                            : "text-gray-900 font-medium"
                        }`}
                      >
                        {notif.message}
                      </p>
                      <p className="mt-0.5 text-xs text-gray-400">
                        {formatTimeAgo(notif.created_at)}
                      </p>
                    </div>
                  </button>
                ))
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
}

function formatTimeAgo(dateStr: string): string {
  const now = Date.now();
  const then = new Date(dateStr).getTime();
  const diff = now - then;

  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "Just now";
  if (mins < 60) return `${mins}m ago`;

  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours}h ago`;

  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;

  return new Date(dateStr).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
  });
}
