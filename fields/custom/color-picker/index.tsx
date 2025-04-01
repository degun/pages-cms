import { z } from "zod";
import { Field } from "@/types/field";
import { EditComponent } from "./edit-component";
import { ViewComponent } from "./view-component";

const defaultValue = "#000000";

const schema = (field: Field) => {
  let zodSchema = z.string();

  return zodSchema;
};

export { EditComponent, ViewComponent, defaultValue, schema };