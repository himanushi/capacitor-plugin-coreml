import { registerPlugin } from '@capacitor/core';

import type { CapCoreMLPlugin } from './definitions';

const CapCoreML = registerPlugin<CapCoreMLPlugin>('CapCoreML', {
  web: () => import('./web').then(m => new m.CapCoreMLWeb()),
});

export * from './definitions';
export { CapCoreML };
