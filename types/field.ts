export type Field = {
  name: string;
  label?: string | false;
  description?: string | null;
  type: "boolean" | "code" | "date" | "image" | "number" | "object" | "rich-text" | "select" | "string" | "text" | "uuid" | "color-picker" | string;
  default?: any;
  list?: boolean | { min?: number; max?: number; default?: any };
  hidden?: boolean | null;
  required?: boolean | null;
  pattern?: string | { regex: string; message?: string };
  options?: Record<string, unknown> | null;
  fields?: Field[];
};