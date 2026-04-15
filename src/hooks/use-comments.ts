"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { Comment } from "@/types/user";
import { supabase } from "@/lib/supabase";
import { createNotification } from "@/hooks/use-notifications";
import { useCurrentUser } from "@/hooks/use-current-user";

export function useComments(taskId: string | null) {
  const { userId: currentUserId } = useCurrentUser();
  const [comments, setComments] = useState<Comment[]>([]);
  const [loading, setLoading] = useState(false);
  const channelRef = useRef<ReturnType<typeof supabase.channel> | null>(null);

  // Fetch comments when taskId changes
  useEffect(() => {
    if (!taskId) {
      setComments([]);
      return;
    }

    setLoading(true);
    supabase
      .from("comments")
      .select("*")
      .eq("task_id", taskId)
      .order("created_at", { ascending: true })
      .then(({ data, error }) => {
        if (error) {
          console.error("Failed to fetch comments:", error.message);
        } else {
          setComments(data ?? []);
        }
        setLoading(false);
      });
  }, [taskId]);

  // Realtime subscription for comments on this task
  useEffect(() => {
    if (!taskId) return;

    const channel = supabase
      .channel(`comments:task_id=${taskId}`)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "comments",
          filter: `task_id=eq.${taskId}`,
        },
        (payload) => {
          const newComment = payload.new as Comment;
          setComments((prev) => {
            if (prev.some((c) => c.id === newComment.id)) return prev;
            return [...prev, newComment];
          });
        }
      )
      .on(
        "postgres_changes",
        {
          event: "DELETE",
          schema: "public",
          table: "comments",
          filter: `task_id=eq.${taskId}`,
        },
        (payload) => {
          const old = payload.old as { id: string };
          setComments((prev) => prev.filter((c) => c.id !== old.id));
        }
      )
      .subscribe();

    channelRef.current = channel;

    return () => {
      supabase.removeChannel(channel);
    };
  }, [taskId]);

  const addComment = useCallback(
    (body: string, taskAssignees?: string[], taskName?: string) => {
      if (!taskId || !body.trim() || !currentUserId) return;

      const optimistic: Comment = {
        id: crypto.randomUUID(),
        task_id: taskId,
        author_id: currentUserId,
        body: body.trim(),
        created_at: new Date().toISOString(),
      };

      setComments((prev) => [...prev, optimistic]);

      supabase
        .from("comments")
        .insert(optimistic)
        .then(({ error }) => {
          if (error) console.error("Failed to add comment:", error.message);
        });

      // Notify assignees about the new comment
      if (taskAssignees) {
        for (const userId of taskAssignees) {
          createNotification({
            user_id: userId,
            task_id: taskId,
            type: "commented",
            message: `New comment on "${taskName || "a task"}": "${body.trim().slice(0, 60)}${body.trim().length > 60 ? "..." : ""}"`,
            actorId: currentUserId,
          });
        }
      }
    },
    [taskId, currentUserId]
  );

  const deleteComment = useCallback((commentId: string) => {
    setComments((prev) => prev.filter((c) => c.id !== commentId));

    supabase
      .from("comments")
      .delete()
      .eq("id", commentId)
      .then(({ error }) => {
        if (error) console.error("Failed to delete comment:", error.message);
      });
  }, []);

  return { comments, loading, addComment, deleteComment };
}
