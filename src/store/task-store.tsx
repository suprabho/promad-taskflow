"use client";

import React, {
  createContext,
  useContext,
  useState,
  useCallback,
  useEffect,
  useRef,
} from "react";
import { Task, TaskStatus, Priority, STATUS_LABELS, PRIORITY_LABELS } from "@/types/task";
import { User } from "@/types/user";
import { supabase } from "@/lib/supabase";

type SortField = "name" | "due_date" | "priority" | "status";
type SortDir = "asc" | "desc";

type TaskStore = {
  tasks: Task[];
  users: User[];
  loading: boolean;
  connected: boolean;
  selectedTaskId: string | null;
  detailOpen: boolean;
  sortField: SortField;
  sortDir: SortDir;
  myTasksOnly: boolean;
  selectTask: (id: string | null) => void;
  openDetail: (id: string) => void;
  closeDetail: () => void;
  addTask: (task: Partial<Task>) => Task;
  updateTask: (id: string, updates: Partial<Task>) => void;
  deleteTask: (id: string) => void;
  setSort: (field: SortField) => void;
  toggleMyTasks: () => void;
  getUserById: (id: string) => User | undefined;
};

const TaskContext = createContext<TaskStore | null>(null);

const DEFAULT_USER_ID = "00000000-0000-0000-0000-000000000001";

const PRIORITY_ORDER: Record<Priority, number> = {
  urgent: 0,
  high: 1,
  medium: 2,
  low: 3,
};

const STATUS_ORDER_MAP: Record<TaskStatus, number> = {
  todo: 0,
  in_progress: 1,
  review: 2,
  done: 3,
  paused: 4,
};

export function TaskProvider({ children }: { children: React.ReactNode }) {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [connected, setConnected] = useState(false);
  const [selectedTaskId, setSelectedTaskId] = useState<string | null>(null);
  const [detailOpen, setDetailOpen] = useState(false);
  const [sortField, setSortField] = useState<SortField>("priority");
  const [sortDir, setSortDir] = useState<SortDir>("asc");
  const [myTasksOnly, setMyTasksOnly] = useState(false);
  const channelRef = useRef<ReturnType<typeof supabase.channel> | null>(null);

  // --- Fetch initial data ---
  useEffect(() => {
    async function fetchData() {
      setLoading(true);

      const [tasksRes, usersRes] = await Promise.all([
        supabase
          .from("tasks")
          .select("*")
          .eq("workspace_id", "ws-1")
          .order("created_at", { ascending: false }),
        supabase.from("users").select("*"),
      ]);

      if (tasksRes.data) {
        setTasks(
          tasksRes.data.map((t) => ({
            ...t,
            due_date: t.due_date ?? null,
            assignees: t.assignees ?? [],
          }))
        );
      }

      if (usersRes.data) {
        setUsers(usersRes.data);
      }

      setLoading(false);
    }

    fetchData();
  }, []);

  // --- Realtime subscription ---
  useEffect(() => {
    const channel = supabase
      .channel("tasks-realtime")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "tasks",
          filter: "workspace_id=eq.ws-1",
        },
        (payload) => {
          const { eventType } = payload;

          if (eventType === "INSERT") {
            const newTask = payload.new as Task;
            setTasks((prev) => {
              if (prev.some((t) => t.id === newTask.id)) return prev;
              return [
                { ...newTask, due_date: newTask.due_date ?? null, assignees: newTask.assignees ?? [] },
                ...prev,
              ];
            });
          }

          if (eventType === "UPDATE") {
            const updated = payload.new as Task;
            setTasks((prev) =>
              prev.map((t) =>
                t.id === updated.id
                  ? { ...updated, due_date: updated.due_date ?? null, assignees: updated.assignees ?? [] }
                  : t
              )
            );
          }

          if (eventType === "DELETE") {
            const old = payload.old as { id: string };
            setTasks((prev) => prev.filter((t) => t.id !== old.id));
          }
        }
      )
      .subscribe((status) => {
        setConnected(status === "SUBSCRIBED");
      });

    channelRef.current = channel;

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const selectTask = useCallback((id: string | null) => {
    setSelectedTaskId(id);
  }, []);

  const openDetail = useCallback((id: string) => {
    setSelectedTaskId(id);
    setDetailOpen(true);
  }, []);

  const closeDetail = useCallback(() => {
    setDetailOpen(false);
    setSelectedTaskId(null);
  }, []);

  // Optimistic add — insert locally, then persist to Supabase
  const addTask = useCallback((partial: Partial<Task>) => {
    const now = new Date().toISOString();
    const id = crypto.randomUUID();
    const task: Task = {
      id,
      name: partial.name || "Untitled task",
      details: partial.details || "",
      status: partial.status || "todo",
      due_date: partial.due_date || null,
      priority: partial.priority || "medium",
      task_type: partial.task_type || "product_design",
      assignees: partial.assignees || [],
      workspace_id: "ws-1",
      created_by: DEFAULT_USER_ID,
      created_at: now,
      updated_at: now,
    };

    setTasks((prev) => [task, ...prev]);

    // Persist to Supabase (fire-and-forget, realtime will reconcile)
    supabase.from("tasks").insert(task).then(({ error }) => {
      if (error) console.error("Failed to insert task:", error.message);
    });

    return task;
  }, []);

  // Optimistic update — also logs activity for meaningful field changes
  const updateTask = useCallback((id: string, updates: Partial<Task>) => {
    // Grab the old task to diff against
    const oldTask = tasks.find((t) => t.id === id);

    setTasks((prev) =>
      prev.map((t) =>
        t.id === id
          ? { ...t, ...updates, updated_at: new Date().toISOString() }
          : t
      )
    );

    // Only send mutable fields to Supabase
    const mutableKeys = ["name", "details", "status", "due_date", "priority", "task_type", "assignees"];
    const dbUpdates: Record<string, unknown> = {};
    for (const key of mutableKeys) {
      if (key in updates) {
        dbUpdates[key] = (updates as Record<string, unknown>)[key];
      }
    }
    supabase
      .from("tasks")
      .update(dbUpdates)
      .eq("id", id)
      .then(({ error }) => {
        if (error) console.error("Failed to update task:", error.message);
      });

    // Log activity for meaningful changes
    if (!oldTask) return;

    const activityActions: string[] = [];

    if (updates.status && updates.status !== oldTask.status) {
      activityActions.push(
        `changed status to ${STATUS_LABELS[updates.status]}`
      );
    }
    if (updates.priority && updates.priority !== oldTask.priority) {
      activityActions.push(
        `changed priority to ${PRIORITY_LABELS[updates.priority]}`
      );
    }
    if (updates.assignees && JSON.stringify(updates.assignees) !== JSON.stringify(oldTask.assignees)) {
      const newAssignees = updates.assignees;
      const added = newAssignees.filter((a) => !oldTask.assignees.includes(a));
      const removed = oldTask.assignees.filter((a) => !newAssignees.includes(a));
      const getNames = (ids: string[]) =>
        ids.map((uid) => users.find((u) => u.id === uid)?.name || "someone").join(", ");

      if (added.length) activityActions.push(`assigned ${getNames(added)}`);
      if (removed.length) activityActions.push(`unassigned ${getNames(removed)}`);
    }

    for (const action of activityActions) {
      supabase.from("activity_logs").insert({
        id: crypto.randomUUID(),
        task_id: id,
        actor_id: DEFAULT_USER_ID,
        action,
        created_at: new Date().toISOString(),
      }).then(({ error }) => {
        if (error) console.error("Failed to log activity:", error.message);
      });
    }
  }, [tasks, users]);

  // Optimistic delete
  const deleteTask = useCallback(
    (id: string) => {
      setTasks((prev) => prev.filter((t) => t.id !== id));
      if (selectedTaskId === id) {
        setDetailOpen(false);
        setSelectedTaskId(null);
      }

      supabase
        .from("tasks")
        .delete()
        .eq("id", id)
        .then(({ error }) => {
          if (error) console.error("Failed to delete task:", error.message);
        });
    },
    [selectedTaskId]
  );

  const setSort = useCallback(
    (field: SortField) => {
      if (field === sortField) {
        setSortDir((d) => (d === "asc" ? "desc" : "asc"));
      } else {
        setSortField(field);
        setSortDir("asc");
      }
    },
    [sortField]
  );

  const toggleMyTasks = useCallback(() => {
    setMyTasksOnly((prev) => !prev);
  }, []);

  const getUserById = useCallback(
    (id: string) => users.find((u) => u.id === id),
    [users]
  );

  const filtered = myTasksOnly
    ? tasks.filter((t) => t.assignees.includes(DEFAULT_USER_ID))
    : tasks;

  const sortedTasks = [...filtered].sort((a, b) => {
    let cmp = 0;
    switch (sortField) {
      case "name":
        cmp = a.name.localeCompare(b.name);
        break;
      case "due_date": {
        const da = a.due_date || "9999";
        const db = b.due_date || "9999";
        cmp = da.localeCompare(db);
        break;
      }
      case "priority":
        cmp = PRIORITY_ORDER[a.priority] - PRIORITY_ORDER[b.priority];
        break;
      case "status":
        cmp = STATUS_ORDER_MAP[a.status] - STATUS_ORDER_MAP[b.status];
        break;
    }
    return sortDir === "asc" ? cmp : -cmp;
  });

  return (
    <TaskContext.Provider
      value={{
        tasks: sortedTasks,
        users,
        loading,
        connected,
        selectedTaskId,
        detailOpen,
        sortField,
        sortDir,
        myTasksOnly,
        selectTask,
        openDetail,
        closeDetail,
        addTask,
        updateTask,
        deleteTask,
        setSort,
        toggleMyTasks,
        getUserById,
      }}
    >
      {children}
    </TaskContext.Provider>
  );
}

export function useTaskStore() {
  const ctx = useContext(TaskContext);
  if (!ctx) throw new Error("useTaskStore must be used within TaskProvider");
  return ctx;
}
