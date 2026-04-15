import { createBrowserClient } from "@supabase/ssr";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

// Browser client — used in client components (realtime, optimistic writes, etc.)
export const supabase = createBrowserClient(supabaseUrl, supabaseAnonKey);
