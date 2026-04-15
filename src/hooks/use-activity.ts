"use client";

import { useState, useEffect } from "react";
import { ActivityLog } from "@/types/user";
import { supabase } from "@/lib/supabase";

export function useActivity(taskId: string | null) {
  const [logs, setLogs] = useState<ActivityLog[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!taskId) {
      setLogs([]);
      return;
    }

    setLoading(true);
    supabase
      .from("activity_logs")
      .select("*")
      .eq("task_id", taskId)
      .order("created_at", { ascending: false })
      .then(({ data, error }) => {
        if (error) {
          console.error("Failed to fetch activity:", error.message);
        } else {
          setLogs(data ?? []);
        }
        setLoading(false);
      });
  }, [taskId]);

  // Allow manual refresh after a change is logged
  const refresh = () => {
    if (!taskId) return;
    supabase
      .from("activity_logs")
      .select("*")
      .eq("task_id", taskId)
      .order("created_at", { ascending: false })
      .then(({ data }) => {
        if (data) setLogs(data);
      });
  };

  return { logs, loading, refresh };
}
