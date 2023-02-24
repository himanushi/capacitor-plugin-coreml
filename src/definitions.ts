export interface LoadOptions {
  completionHandler: (error?: any) => void;
  config?: {
    modelDisplayName?: string;
    parameters?: Record<string, any>;
  };
  path: string;
}

export interface PredictionOptions {
  config?: {
    modelDisplayName?: string;
    parameters?: Record<string, any>;
  };
  path: string;
}

export interface CapCoreMLPlugin {
  compile(options: { value: string }): Promise<any>;
  download(options: { value: string }): Promise<any>;
  echo(options: { value: string }): Promise<{ value: string }>;
  load(options: { value: string }): Promise<any>;
  prediction(options: { value: string }): Promise<any>;
}
