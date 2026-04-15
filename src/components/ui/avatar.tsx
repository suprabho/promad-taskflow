"use client";

type AvatarProps = {
  name: string;
  src?: string | null;
  size?: "sm" | "md" | "lg";
  className?: string;
};

const sizeMap = {
  sm: "h-6 w-6 text-[10px]",
  md: "h-8 w-8 text-xs",
  lg: "h-10 w-10 text-sm",
};

const colors = [
  "bg-indigo-500",
  "bg-emerald-500",
  "bg-amber-500",
  "bg-rose-500",
  "bg-violet-500",
  "bg-cyan-500",
  "bg-fuchsia-500",
  "bg-lime-600",
];

function getColor(name: string) {
  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash);
  }
  return colors[Math.abs(hash) % colors.length];
}

function getInitials(name: string) {
  return name
    .split(" ")
    .map((w) => w[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);
}

export function Avatar({ name, src, size = "md", className = "" }: AvatarProps) {
  if (src) {
    return (
      <img
        src={src}
        alt={name}
        className={`rounded-full object-cover ${sizeMap[size]} ${className}`}
      />
    );
  }

  return (
    <div
      className={`rounded-full flex items-center justify-center text-white font-medium ${sizeMap[size]} ${getColor(name)} ${className}`}
      title={name}
    >
      {getInitials(name)}
    </div>
  );
}

export function AvatarGroup({
  users,
  max = 3,
}: {
  users: { name: string; src?: string | null }[];
  max?: number;
}) {
  const visible = users.slice(0, max);
  const extra = users.length - max;

  return (
    <div className="flex -space-x-1.5">
      {visible.map((u, i) => (
        <Avatar
          key={i}
          name={u.name}
          src={u.src}
          size="sm"
          className="ring-2 ring-white"
        />
      ))}
      {extra > 0 && (
        <div className="h-6 w-6 rounded-full bg-gray-200 text-gray-600 text-[10px] font-medium flex items-center justify-center ring-2 ring-white">
          +{extra}
        </div>
      )}
    </div>
  );
}
