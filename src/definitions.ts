export interface LoadOptions {
  path: string;
  config?: {
    modelDisplayName?: string;
    parameters?: Record<string, any>;
  };
  completionHandler: (error?: any) => void;
}

export interface PredictionOptions {
  path: string;
  config?: {
    modelDisplayName?: string;
    parameters?: Record<string, any>;
  };
}

export interface CapCoreMLPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  load(options: { value: string }): Promise<any>;
  compile(options: { value: string }): Promise<any>;
  prediction(options: { value: string }): Promise<any>;
}
