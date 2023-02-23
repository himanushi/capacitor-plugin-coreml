export interface CapCoreMLPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
