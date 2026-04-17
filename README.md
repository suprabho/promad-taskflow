This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Claude Code skills

This project ships with a [Claude Code](https://claude.com/claude-code) skill that lets you file tasks from natural language.

### `create-task`

Creates a row in the Supabase `tasks` table from a prompt.

**Where it lives:** [`.claude/skills/create-task/SKILL.md`](.claude/skills/create-task/SKILL.md) — auto-discovered by Claude Code when you run it from the project root.

**How to use it** — open Claude Code in this directory and either:

- Invoke it explicitly: `/create-task fix the crash on the board page when dragging a done card`
- Or just ask in natural language: `create a task to redesign the sidebar, high priority, due next Friday`

Claude will parse the prompt into `name`, `details`, `priority`, `task_type`, `due_date`, and `status` (with sensible defaults), then `POST` to Supabase using the credentials in `.env.local`. It reports the created task's `id` on success.

**Requirements:** `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` must be set in `.env.local`, and the `tasks` table must allow inserts from the anon role (see [`supabase/migration.sql`](supabase/migration.sql)).

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
