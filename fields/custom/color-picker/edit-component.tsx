"use client";

import { forwardRef } from "react";
import React from "react";

import "./edit-component.css";

const EditComponent = forwardRef((props: any, ref: React.Ref<HTMLInputElement>) => {
  return (
    <div className="flex content-center items-center gap-2">
      <input type="color" ref={ref} value={props.value} onChange={props.onChange} />
      <input type="text" value={props.value} onChange={props.onChange} />
    </div>
  );
});

export { EditComponent };