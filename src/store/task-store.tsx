"use client";

import React, {
  createContext,
  useContext,
  useState,
  useCallback,
  useEffect,
  useRef,
} from "react";
import { Task, TaskStatus, Priority, TaskType, STATUS_LABELS, PRIORITY_LABELS } from "@/types/task";
import { User } from "@/types/user";
import { supabase } from "@/lib/supabase";
import { createNotification } from "@/hooks/use-notifications";
import { useCurrentUser } from "@/hooks/use-current-user";

export type SortField = "name" | "due_date" | "priority" | "status";
export type SortDir = "asc" | "desc";
export type ViewMode = "list" | "board";
export type GroupBy = "status" | "project";

export type Filters = {
  search: string;
  status: TaskStatus[];
  priority: Priority[];
  task_type: TaskType[];
  assignee: string[];
  due_from: string;
  due_to: string;
};

export type SavedView = {
  id: string;
  name: string;
  mode: ViewMode;
  group_by: GroupBy;
  sort_field: SortField;
  sort_dir: SortDir;
  my_tasks_only: boolean;
  filters: Filters;
  is_builtin?: boolean;
};

const EMPTY_FILTERS: Filters = {
  search: "",
  status: [],
  priority: [],
  task_type: [],
  assignee: [],
  due_from: "",
  due_to: "",
};

const BUILTIN_VIEWS: SavedView[] = [
  {
    id: "my-open-tasks",
    name: "My open tasks",
    mode: "list",
    group_by: "status",
    sort_field: "priority",
    sort_dir: "asc",
    my_tasks_only: true,
    filters: {
      ...EMPTY_FILTERS,
      status: ["todo", "in_progress", "review"],
    },
    is_builtin: true,
  },
];

type TaskStore = {
  currentUserId: string | null;
  tasks: Task[];
  allTasks: Task[];
  users: User[];
  loading: boolean;
  connected: boolean;
  selectedTaskId: string | null;
  detailOpen: boolean;
  sortField: SortField;
  sortDir: SortDir;
  myTasksOnly: boolean;
  filters: Filters;
  hasActiveFilters: boolean;
  groupBy: GroupBy;
  savedViews: SavedView[];
  activeViewId: string | null;
  selectTask: (id: string | null) => void;
  openDetail: (id: string) => void;
  closeDetail: () => void;
  addTask: (task: Partial<Task>) => Task;
  updateTask: (id: string, updates: Partial<Task>) => void;
  deleteTask: (id: string) => void;
  setSort: (field: SortField) => void;
  toggleMyTasks: () => void;
  getUserById: (id: string) => User | undefined;
  setFilters: (filters: Partial<Filters>) => void;
  clearFilters: () => void;
  setGroupBy: (g: GroupBy) => void;
  applyView: (view: SavedView) => { mode: ViewMode };
  saveView: (name: string, mode: ViewMode) => Promise<string>;
  deleteView: (id: string) => Promise<void>;
  signOut: () => void;
};

const TaskContext = createContext<TaskStore | null>(null);

const FALLBACK_USER_ID = "00000000-0000-0000-0000-000000000001";

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
  const { userId: currentUserId } = useCurrentUser();
  const actorId = currentUserId || FALLBACK_USER_ID;
  const [tasks, setTasks] = useState<Task[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [connected, setConnected] = useState(false);
  const [selectedTaskId, setSelectedTaskId] = useState<string | null>(null);
  const [detailOpen, setDetailOpen] = useState(false);
  const [sortField, setSortField] = useState<SortField>("priority");
  const [sortDir, setSortDir] = useState<SortDir>("asc");
  const [myTasksOnly, setMyTasksOnly] = useState(false);
  const [filters, setFiltersState] = useState<Filters>(EMPTY_FILTERS);
  const [groupBy, setGroupByState] = useState<GroupBy>("status");
  const [remoteViews, setRemoteViews] = useState<SavedView[]>([]);
  const [activeViewId, setActiveViewId] = useState<string | null>(null);
  const channelRef = useRef<ReturnType<typeof supabase.channel> | null>(null);
  const tasksRef = useRef<Task[]>(tasks);
  const usersRef = useRef<User[]>(users);
  tasksRef.current = tasks;
  usersRef.current = users;

  // --- Fetch initial data ---
  useEffect(() => {
    async function fetchData() {
      setLoading(true);

      const [tasksRes, usersRes, viewsRes] = await Promise.all([
        supabase
          .from("tasks")
          .select("*")
          .eq("workspace_id", "ws-1")
          .order("created_at", { ascending: false }),
        supabase.from("users").select("*"),
        supabase
          .from("saved_views")
          .select("*")
          .eq("workspace_id", "ws-1")
          .order("created_at", { ascending: true }),
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

      if (viewsRes.data) {
        setRemoteViews(
          viewsRes.data.map((v) => ({
            id: v.id,
            name: v.name,
            mode: v.mode,
            group_by: v.group_by,
            sort_field: v.sort_field,
            sort_dir: v.sort_dir,
            my_tasks_only: v.my_tasks_only,
            filters: { ...EMPTY_FILTERS, ...(v.filters || {}) },
          }))
        );
      }

      setLoading(false);
    }

    fetchData();
  }, []);

  // --- Realtime: saved_views ---
  useEffect(() => {
    const channel = supabase
      .channel("saved-views-realtime")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "saved_views",
          filter: "workspace_id=eq.ws-1",
        },
        (payload) => {
          const { eventType } = payload;

          if (eventType === "INSERT" || eventType === "UPDATE") {
            const row = payload.new as {
              id: string;
              name: string;
              mode: ViewMode;
              group_by: GroupBy;
              sort_field: SortField;
              sort_dir: SortDir;
              my_tasks_only: boolean;
              filters: Partial<Filters> | null;
            };
            const view: SavedView = {
              id: row.id,
              name: row.name,
              mode: row.mode,
              group_by: row.group_by,
              sort_field: row.sort_field,
              sort_dir: row.sort_dir,
              my_tasks_only: row.my_tasks_only,
              filters: { ...EMPTY_FILTERS, ...(row.filters || {}) },
            };
            setRemoteViews((prev) => {
              const idx = prev.findIndex((v) => v.id === view.id);
              if (idx === -1) return [...prev, view];
              const next = [...prev];
              next[idx] = view;
              return next;
            });
          }

          if (eventType === "DELETE") {
            const old = payload.old as { id: string };
            setRemoteViews((prev) => prev.filter((v) => v.id !== old.id));
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
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
      project: partial.project ?? null,
      assignees: partial.assignees || [],
      workspace_id: "ws-1",
      created_by: actorId,
      created_at: now,
      updated_at: now,
    };

    setTasks((prev) => [task, ...prev]);

    // Persist to Supabase (fire-and-forget, realtime will reconcile)
    supabase.from("tasks").insert(task).then(({ error }) => {
      if (error) console.error("Failed to insert task:", error.message);
    });

    return task;
  }, [actorId]);

  // Optimistic update — also logs activity for meaningful field changes
  const updateTask = useCallback((id: string, updates: Partial<Task>) => {
    // Grab the old task to diff against
    const oldTask = tasksRef.current.find((t) => t.id === id);

    setTasks((prev) =>
      prev.map((t) =>
        t.id === id
          ? { ...t, ...updates, updated_at: new Date().toISOString() }
          : t
      )
    );

    // Only send mutable fields to Supabase
    const mutableKeys = ["name", "details", "status", "due_date", "priority", "task_type", "project", "assignees"];
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
        ids.map((uid) => usersRef.current.find((u) => u.id === uid)?.name || "someone").join(", ");

      if (added.length) {
        activityActions.push(`assigned ${getNames(added)}`);
        // Notify newly assigned users
        for (const userId of added) {
          createNotification({
            user_id: userId,
            task_id: id,
            type: "assigned",
            message: `You were assigned to "${oldTask.name || "Untitled task"}"`,
            actorId,
          });
        }
      }
      if (removed.length) activityActions.push(`unassigned ${getNames(removed)}`);
    }

    for (const action of activityActions) {
      supabase.from("activity_logs").insert({
        id: crypto.randomUUID(),
        task_id: id,
        actor_id: actorId,
        action,
        created_at: new Date().toISOString(),
      }).then(({ error }) => {
        if (error) console.error("Failed to log activity:", error.message);
      });
    }
  }, [actorId]);

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
      setActiveViewId(null);
    },
    [sortField]
  );

  const toggleMyTasks = useCallback(() => {
    setMyTasksOnly((prev) => !prev);
    setActiveViewId(null);
  }, []);

  const getUserById = useCallback(
    (id: string) => users.find((u) => u.id === id),
    [users]
  );

  const setFilters = useCallback((partial: Partial<Filters>) => {
    setFiltersState((prev) => ({ ...prev, ...partial }));
    setActiveViewId(null);
  }, []);

  const clearFilters = useCallback(() => {
    setFiltersState(EMPTY_FILTERS);
    setActiveViewId(null);
  }, []);

  const setGroupBy = useCallback((g: GroupBy) => {
    setGroupByState(g);
    setActiveViewId(null);
  }, []);

  const applyView = useCallback((view: SavedView) => {
    setFiltersState(view.filters);
    setSortField(view.sort_field);
    setSortDir(view.sort_dir);
    setMyTasksOnly(view.my_tasks_only);
    setGroupByState(view.group_by);
    setActiveViewId(view.id);
    return { mode: view.mode };
  }, []);

  const saveView = useCallback(
    async (name: string, mode: ViewMode) => {
      const id = crypto.randomUUID();
      const row = {
        id,
        workspace_id: "ws-1",
        name,
        mode,
        group_by: groupBy,
        sort_field: sortField,
        sort_dir: sortDir,
        my_tasks_only: myTasksOnly,
        filters,
        created_by: actorId,
      };
      setRemoteViews((prev) => [
        ...prev,
        { id, name, mode, group_by: groupBy, sort_field: sortField, sort_dir: sortDir, my_tasks_only: myTasksOnly, filters },
      ]);
      const { error } = await supabase.from("saved_views").insert(row);
      if (error) {
        console.error("Failed to save view:", error.message);
        setRemoteViews((prev) => prev.filter((v) => v.id !== id));
      }
      return id;
    },
    [filters, sortField, sortDir, myTasksOnly, groupBy, actorId]
  );

  const deleteView = useCallback(
    async (id: string) => {
      setRemoteViews((prev) => prev.filter((v) => v.id !== id));
      setActiveViewId((cur) => (cur === id ? null : cur));
      const { error } = await supabase.from("saved_views").delete().eq("id", id);
      if (error) console.error("Failed to delete view:", error.message);
    },
    []
  );

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
    window.location.href = "/login";
  }, []);

  const hasActiveFilters =
    filters.search !== "" ||
    filters.status.length > 0 ||
    filters.priority.length > 0 ||
    filters.task_type.length > 0 ||
    filters.assignee.length > 0 ||
    filters.due_from !== "" ||
    filters.due_to !== "";

  // Apply all filters
  let filtered = tasks;

  if (myTasksOnly) {
    filtered = filtered.filter((t) => t.assignees.includes(actorId));
  }

  if (filters.search) {
    const q = filters.search.toLowerCase();
    filtered = filtered.filter(
      (t) =>
        t.name.toLowerCase().includes(q) ||
        t.details.toLowerCase().includes(q)
    );
  }

  if (filters.status.length > 0) {
    filtered = filtered.filter((t) => filters.status.includes(t.status));
  }

  if (filters.priority.length > 0) {
    filtered = filtered.filter((t) => filters.priority.includes(t.priority));
  }

  if (filters.task_type.length > 0) {
    filtered = filtered.filter((t) => filters.task_type.includes(t.task_type));
  }

  if (filters.assignee.length > 0) {
    filtered = filtered.filter((t) =>
      t.assignees.some((a) => filters.assignee.includes(a))
    );
  }

  if (filters.due_from) {
    filtered = filtered.filter(
      (t) => t.due_date && t.due_date >= filters.due_from
    );
  }

  if (filters.due_to) {
    filtered = filtered.filter(
      (t) => t.due_date && t.due_date <= filters.due_to
    );
  }

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

  const savedViews = [...BUILTIN_VIEWS, ...remoteViews];

  return (
    <TaskContext.Provider
      value={{
        currentUserId,
        tasks: sortedTasks,
        allTasks: tasks,
        users,
        loading,
        connected,
        selectedTaskId,
        detailOpen,
        sortField,
        sortDir,
        myTasksOnly,
        filters,
        hasActiveFilters,
        groupBy,
        savedViews,
        activeViewId,
        selectTask,
        openDetail,
        closeDetail,
        addTask,
        updateTask,
        deleteTask,
        setSort,
        toggleMyTasks,
        getUserById,
        setFilters,
        clearFilters,
        setGroupBy,
        applyView,
        saveView,
        deleteView,
        signOut,
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
