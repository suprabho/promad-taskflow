import { Lightning } from "@phosphor-icons/react/dist/ssr";

export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50">
      <div className="w-full max-w-sm space-y-6 px-4">
        <div className="flex flex-col items-center gap-2">
          <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-indigo-600">
            <Lightning weight="bold" className="h-6 w-6 text-white" />
          </div>
          <h1 className="text-xl font-bold text-gray-900">Taskflow</h1>
        </div>
        {children}
      </div>
    </div>
  );
}
