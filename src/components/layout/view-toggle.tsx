"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { List, Kanban } from "@phosphor-icons/react";

export function ViewToggle() {
  const pathname = usePathname();

  return (
    <div className="flex items-center rounded-lg border border-gray-200 bg-gray-50 p-0.5">
      <Link
        href="/"
        className={`flex items-center gap-1.5 rounded-md px-2.5 py-1 text-xs font-medium transition-colors ${
          pathname === "/"
            ? "bg-white text-gray-900 shadow-sm"
            : "text-gray-500 hover:text-gray-700"
        }`}
      >
        <List weight="bold" className="h-3.5 w-3.5" />
        List
      </Link>
      <Link
        href="/board"
        className={`flex items-center gap-1.5 rounded-md px-2.5 py-1 text-xs font-medium transition-colors ${
          pathname === "/board"
            ? "bg-white text-gray-900 shadow-sm"
            : "text-gray-500 hover:text-gray-700"
        }`}
      >
        <Kanban weight="bold" className="h-3.5 w-3.5" />
        Board
      </Link>
    </div>
  );
}
