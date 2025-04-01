"use client";

const ViewComponent = ({ value }: { value: string}) => {
  if (value == null) return null;

  return (
    <span className="flex items-center gap-x-1.5">
     <span className={`inline rounded-[2px] border bg-[${value}]`}></span>
     <span className={`inline px-2 py-0.5 text-sm font-medium`}>{value}</span>
    </span>
  );
};

export { ViewComponent };