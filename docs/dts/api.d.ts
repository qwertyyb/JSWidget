/**
 * JSWidget global API declarations.
 * Run `pnpm generate` in Tools/completion-gen/ after editing.
 */
type HttpParams = {
  headers?: Record<string, string>;
  body?: string | Record<string, any>;
  timeoutInterval?: number;
};

declare const $http: {
  get(url: string, params?: HttpParams): Promise<string>;
  post(url: string, params?: HttpParams): Promise<string>;
  put(url: string, params?: HttpParams): Promise<string>;
  patch(url: string, params?: HttpParams): Promise<string>;
  delete(url: string, params?: HttpParams): Promise<string>;
};

declare function $fetch(url: string, params?: HttpParams): Promise<string>;
declare function fetch(url: string, params?: HttpParams): Promise<string>;

type JSWidgetConsole = {
  /** 普通日志 */
  log(...args: any[]): void;
  /** 信息日志 */
  info(...args: any[]): void;
  /** 警告日志 */
  warn(...args: any[]): void;
  /** 错误日志 */
  error(...args: any[]): void;
};
declare const $console: JSWidgetConsole;
declare const console: JSWidgetConsole;

declare const $device: {
  name(): string;
  model(): string;
  language(): string;
  systemVersion(): string;
  screen(): { scale: number; width: number; height: number };
  battery(): { level: number; state: string };
  isdarkmode(): boolean;
  totalDiskSpace(): number;
  freeDiskSpace(): number;
};

/** 操作脚本包内的文件 API */
declare const $file: {
  readString(path: string): string;
  writeString(path: string, content: string): boolean;
  remove(path: string): boolean;
  /** 列出目录下一层条目；path 为 "" 表示包根目录 */
  list(path: string): string[];
};

declare const $system: {
  appInfo(): { name: string; bundleId: string; version: string; build: string };
  locale(): string;
  preferredLanguages(): string[];
  timeZone(): { identifier: string; abbreviation: string; offsetSeconds: number };
  is24HourClock(): boolean;
  calendarInfo(): {
    identifier: string;
    firstWeekday: number;
    minimumDaysInFirstWeek: number;
  };
  systemUptime(): number;
  memory(): { physical: number };
  thermalState(): "nominal" | "fair" | "serious" | "critical" | "unknown";
  lowPowerMode(): boolean;
  /** iOS: 0–1; macOS: -1 */
  brightness(): number;
  reduceMotionEnabled(): boolean;
  platform(): "ios" | "macos";
  hostName(): string;
  processName(): string;
  osVersionString(): string;
  processorCount(): number;
  activeProcessorCount(): number;
};

type LocationAuthorizationStatus =
  | "notDetermined"
  | "restricted"
  | "denied"
  | "authorizedAlways"
  | "authorizedWhenInUse"
  | "disabled"      // iOS：定位服务关闭
  | "unknown"
  | "unavailable";  // 非 iOS stub

type LocationRequestOptions = {
  timeout?: number;
  timeoutMs?: number;
};

type LocationCurrentOptions = LocationRequestOptions & {
  maxAge?: number;
  maxAgeMs?: number;
  accuracy?: "full" | "reduced";
  purposeKey?: string;
};

type LocationPayload = {
  latitude: number;
  longitude: number;
  altitude: number;
  accuracy: number;
  verticalAccuracy: number;
  speed: number;
  course: number;
  timestamp: string;
  accuracyAuthorization: "full" | "reduced" | "unknown";
  age: number;
  isStale: boolean;
};

declare const $location: {
  isAvailable(): boolean;
  authorizationStatus(): LocationAuthorizationStatus;
  requestAuthorization(options?: LocationRequestOptions): Promise<boolean>;
  current(options?: LocationCurrentOptions): Promise<LocationPayload>;
};

declare const $storage: {
  getString(key: string): string;
  setString(key: string, value: string): boolean;
  getJSON(key: string): Record<string, unknown>;
  setJSON(key: string, value: Record<string, unknown>): boolean;
  remove(key: string): boolean;
  keys(): string[];
  clear(): boolean;
};

type JSWidgetSize =
  | "small"
  | "medium"
  | "large"
  | "extraLarge"
  | "accessoryInline"
  | "accessoryCircular"
  | "accessoryRectangular"
  | "live-activity"
  | "dynamic-island"
  | "function";

declare function $getenv(key: "widget-size"): JSWidgetSize | "";
declare function $getenv(key: "widget-param" | "script-dir"): string;
declare function $getenv(key: string): string;

/**
 * 导入并执行同包内的 .js / .jsx 文件（相对路径）。
 * 被导入文件的顶层变量/函数会进入当前 JS 上下文的全局作用域。
 * @returns 文件是否存在；执行是否成功需自行保证（调用为同步，编译/执行为异步调度）。
 */
declare function $import(relativePath: string): boolean;

declare function $render(element: unknown): void;

type DynamicIslandExpandedConfig = {
  leading?: unknown;
  trailing?: unknown;
  center?: unknown;
  bottom?: unknown;
};

type DynamicIslandConfig = {
  expanded: DynamicIslandExpandedConfig;
  compactLeading: unknown;
  compactTrailing: unknown;
  minimal: unknown;
};

declare function $dynamic_island(config: DynamicIslandConfig): void;

declare const $element: {
  createElement(
    tag: string | ((...args: unknown[]) => unknown),
    props?: Record<string, unknown> | null,
    ...children: unknown[]
  ): unknown;
};

declare function $component(
  name: string,
  builder: (...args: unknown[]) => unknown
): void;

declare function $error(message: string): void;
