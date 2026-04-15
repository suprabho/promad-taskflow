"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { supabase } from "@/lib/supabase";
import { Notification } from "@/types/user";
import { useCurrentUser } from "@/hooks/use-current-user";

export function useNotifications() {
  const { userId } = useCurrentUser();
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const channelRef = useRef<ReturnType<typeof supabase.channel> | null>(null);

  const unreadCount = notifications.filter((n) => !n.read).length;

  // Fetch initial
  useEffect(() => {
    if (!userId) return;
    async function fetch() {
      setLoading(true);
      const { data } = await supabase
        .from("notifications")
        .select("*")
        .eq("user_id", userId)
        .order("created_at", { ascending: false })
        .limit(50);

      if (data) setNotifications(data);
      setLoading(false);
    }
    fetch();
  }, [userId]);

  // Realtime subscription
  useEffect(() => {
    if (!userId) return;
    const channel = supabase
      .channel("notifications-realtime")
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "notifications",
          filter: `user_id=eq.${userId}`,
        },
        (payload) => {
          const notif = payload.new as Notification;
          setNotifications((prev) => {
            if (prev.some((n) => n.id === notif.id)) return prev;
            return [notif, ...prev];
          });
        }
      )
      .subscribe();

    channelRef.current = channel;

    return () => {
      supabase.removeChannel(channel);
    };
  }, [userId]);

  const markAsRead = useCallback((id: string) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, read: true } : n))
    );
    supabase
      .from("notifications")
      .update({ read: true })
      .eq("id", id)
      .then(({ error }) => {
        if (error) console.error("Failed to mark notification read:", error.message);
      });
  }, []);

  const markAllAsRead = useCallback(() => {
    const unreadIds = notifications.filter((n) => !n.read).map((n) => n.id);
    if (unreadIds.length === 0) return;

    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));
    supabase
      .from("notifications")
      .update({ read: true })
      .in("id", unreadIds)
      .then(({ error }) => {
        if (error) console.error("Failed to mark all read:", error.message);
      });
  }, [notifications]);

  return { notifications, unreadCount, loading, markAsRead, markAllAsRead };
}

// Helper to create a notification (called from task store when assigning, commenting, etc.)
// actorId = the user performing the action (so we don't self-notify)
export async function createNotification(params: {
  user_id: string;
  task_id: string;
  type: "assigned" | "commented" | "due_soon";
  message: string;
  actorId?: string;
}) {
  // Don't notify yourself
  if (params.actorId && params.user_id === params.actorId) return;

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const { actorId: _actor, ...insertData } = params;
  const { error } = await supabase.from("notifications").insert({
    id: crypto.randomUUID(),
    ...insertData,
    read: false,
    created_at: new Date().toISOString(),
  });

  if (error) console.error("Failed to create notification:", error.message);
}
