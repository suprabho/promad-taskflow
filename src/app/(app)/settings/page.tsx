"use client";

import { useTaskStore } from "@/store/task-store";
import { Avatar } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Lightning, Envelope, Crown, User } from "@phosphor-icons/react";

export default function SettingsPage() {
  const { users } = useTaskStore();

  return (
    <div className="max-w-2xl space-y-8">
      {/* Workspace info */}
      <section>
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Workspace</h2>
        <div className="rounded-xl border border-gray-200 bg-white p-5">
          <div className="flex items-center gap-3 mb-4">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
              <Lightning weight="bold" className="h-5 w-5 text-white" />
            </div>
            <div>
              <p className="font-semibold text-gray-900">Taskflow Workspace</p>
              <p className="text-sm text-gray-500">
                {users.length} members
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Members */}
      <section>
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Members</h2>
          <Button size="sm" variant="secondary">
            <Envelope className="h-3.5 w-3.5" />
            Invite
          </Button>
        </div>
        <div className="rounded-xl border border-gray-200 bg-white divide-y divide-gray-100">
          {users.map((user) => (
            <div
              key={user.id}
              className="flex items-center justify-between px-5 py-3.5"
            >
              <div className="flex items-center gap-3">
                <Avatar name={user.name} src={user.avatar_url} size="md" />
                <div>
                  <p className="text-sm font-medium text-gray-900">
                    {user.name}
                  </p>
                  <p className="text-xs text-gray-500">{user.email}</p>
                </div>
              </div>
              <Badge
                className={
                  user.role === "admin"
                    ? "bg-indigo-100 text-indigo-700"
                    : "bg-gray-100 text-gray-600"
                }
              >
                {user.role === "admin" ? (
                  <span className="flex items-center gap-1">
                    <Crown weight="fill" className="h-3 w-3" /> Admin
                  </span>
                ) : (
                  <span className="flex items-center gap-1">
                    <User weight="fill" className="h-3 w-3" /> Member
                  </span>
                )}
              </Badge>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
