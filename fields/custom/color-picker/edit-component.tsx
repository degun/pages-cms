"use client";

import { forwardRef } from "react";
import React from "react";
import { HexColorPicker } from "react-colorful";

const EditComponent = forwardRef((props: any, ref: React.Ref<HTMLInputElement>) => {
  return (
    <div className="flex flex-col items-center gap-4 p-4 rounded-2xl shadow-md w-fit bg-white" ref={ref}>
      <HexColorPicker color={props.value} onChange={props.onChange} />
      <div
        className="w-16 h-16 rounded-full border"
        style={{ backgroundColor: props.value }}
      />
      <p className="text-sm font-mono">{props.value}</p>
    </div>
  );
});

export { EditComponent };