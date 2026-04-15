"use client";

import Link from "next/link";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export default function LoginPage() {
  return (
    <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
      <h2 className="text-lg font-semibold text-gray-900 mb-1">Welcome back</h2>
      <p className="text-sm text-gray-500 mb-5">
        Sign in to your workspace
      </p>

      <form
        className="space-y-4"
        onSubmit={(e) => {
          e.preventDefault();
          // Auth will be wired up with Clerk/NextAuth
          window.location.href = "/";
        }}
      >
        <Input
          id="email"
          label="Email"
          type="email"
          placeholder="you@team.com"
          required
        />
        <Input
          id="password"
          label="Password"
          type="password"
          placeholder="••••••••"
          required
        />
        <Button type="submit" className="w-full">
          Sign in
        </Button>
      </form>

      <p className="mt-4 text-center text-sm text-gray-500">
        Don&apos;t have an account?{" "}
        <Link
          href="/signup"
          className="font-medium text-indigo-600 hover:text-indigo-700"
        >
          Sign up
        </Link>
      </p>
    </div>
  );
}
