import { WebPlugin } from '@capacitor/core';

import type { CapCoreMLPlugin } from './definitions';

export class CapCoreMLWeb extends WebPlugin implements CapCoreMLPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async load(options: { value: string }): Promise<void> {
    console.log('LOAD', options);
  }

  async compile(options: { value: string }): Promise<void> {
    console.log('LOAD', options);
  }

  async prediction(options: { value: string }): Promise<void> {
    console.log('LOAD', options);
  }
}
