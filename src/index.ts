import type { CapCoreMLPlugin } from "./definitions";
import { registerPlugin } from "@capacitor/core";

const CapCoreML = registerPlugin<CapCoreMLPlugin>("CapCoreML", {
  web: () => import("./web").then((m) => new m.CapCoreMLWeb()),
});

export * from "./definitions";
export { CapCoreML };
