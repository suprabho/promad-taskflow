"use client";

import { useEffect, useRef } from "react";
import { useSearchParams, useRouter, usePathname } from "next/navigation";
import { Filters } from "@/store/task-store";

const ARRAY_KEYS = ["status", "priority", "task_type", "assignee"] as const;
const STRING_KEYS = ["search", "due_from", "due_to"] as const;

export function parseFiltersFromParams(
  params: URLSearchParams
): Partial<Filters> {
  const filters: Partial<Filters> = {};

  for (const key of STRING_KEYS) {
    const val = params.get(key);
    if (val) (filters as Record<string, string>)[key] = val;
  }

  for (const key of ARRAY_KEYS) {
    const val = params.get(key);
    if (val) {
      (filters as Record<string, string[]>)[key] = val.split(",");
    }
  }

  return filters;
}

export function filtersToParams(filters: Filters): URLSearchParams {
  const params = new URLSearchParams();

  for (const key of STRING_KEYS) {
    if (filters[key]) params.set(key, filters[key]);
  }

  for (const key of ARRAY_KEYS) {
    if (filters[key].length > 0) params.set(key, filters[key].join(","));
  }

  return params;
}

export function useFilterParams(
  filters: Filters,
  setFilters: (f: Partial<Filters>) => void
) {
  const searchParams = useSearchParams();
  const router = useRouter();
  const pathname = usePathname();
  const initialized = useRef(false);

  // On mount: read URL params into store
  useEffect(() => {
    if (initialized.current) return;
    initialized.current = true;

    const parsed = parseFiltersFromParams(searchParams);
    if (Object.keys(parsed).length > 0) {
      setFilters(parsed);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // On filter change: push to URL
  useEffect(() => {
    if (!initialized.current) return;

    const params = filtersToParams(filters);
    const qs = params.toString();
    const target = qs ? `${pathname}?${qs}` : pathname;

    router.replace(target, { scroll: false });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filters]);
}
