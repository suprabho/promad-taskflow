"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  CheckSquare,
  Kanban,
  Gear,
  Lightning,
  Users,
} from "@phosphor-icons/react";

const navItems = [
  { href: "/", label: "List", icon: CheckSquare },
  { href: "/board", label: "Board", icon: Kanban },
  { href: "/settings", label: "Settings", icon: Gear },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="fixed left-0 top-0 z-30 flex h-screen w-56 flex-col border-r border-gray-200 bg-white">
      {/* Logo */}
      <div className="flex items-center gap-2 px-5 py-5">
        <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-indigo-600">
          <Lightning weight="bold" className="h-4 w-4 text-white" />
        </div>
        <span className="text-lg font-bold text-gray-900">Taskflow</span>
      </div>

      {/* Navigation */}
      <nav className="flex-1 px-3 py-2">
        <ul className="space-y-1">
          {navItems.map((item) => {
            const active =
              pathname === item.href ||
              (item.href !== "/" && pathname.startsWith(item.href));
            const Icon = item.icon;
            return (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={`flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
                    active
                      ? "bg-indigo-50 text-indigo-700"
                      : "text-gray-600 hover:bg-gray-100 hover:text-gray-900"
                  }`}
                >
                  <Icon
                    weight={active ? "fill" : "regular"}
                    className="h-[18px] w-[18px]"
                  />
                  {item.label}
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>

      {/* Team section */}
      <div className="border-t border-gray-200 px-3 py-3">
        <div className="flex items-center gap-2 px-3 py-2 text-sm text-gray-500">
          <Users weight="regular" className="h-4 w-4" />
          <span>3 members</span>
        </div>
      </div>
    </aside>
  );
}
