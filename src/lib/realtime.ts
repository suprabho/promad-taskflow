import { supabase } from "./supabase";
import { Task } from "@/types/task";
import { RealtimeChannel } from "@supabase/supabase-js";

type TaskChangeHandler = (payload: {
  eventType: "INSERT" | "UPDATE" | "DELETE";
  new: Task | null;
  old: Task | null;
}) => void;

export function subscribeToTasks(
  workspaceId: string,
  onChangeHandler: TaskChangeHandler
): RealtimeChannel {
  const channel = supabase
    .channel(`tasks:workspace_id=eq.${workspaceId}`)
    .on(
      "postgres_changes",
      {
        event: "*",
        schema: "public",
        table: "tasks",
        filter: `workspace_id=eq.${workspaceId}`,
      },
      (payload) => {
        onChangeHandler({
          eventType: payload.eventType as "INSERT" | "UPDATE" | "DELETE",
          new: (payload.new as Task) ?? null,
          old: (payload.old as Task) ?? null,
        });
      }
    )
    .subscribe();

  return channel;
}

export function unsubscribe(channel: RealtimeChannel) {
  supabase.removeChannel(channel);
}
