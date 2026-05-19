/** Auto-generated from docs/dts/ by Tools/completion-gen/generate.mjs — do not edit by hand */

type JSWidgetPadding = number | {
  /** 左右内边距 */
  horizontal?: number;
  /** 上下内边距 */
  vertical?: number;
  /** 顶部内边距 */
  top?: number;
  /** 底部内边距 */
  bottom?: number;
  /** 左内边距 */
  leading?: number;
  /** 右内边距 */
  trailing?: number;
  /** 左内边距 */
  left?: number;
  /** 右内边距 */
  right?: number;
};

/** 字体名称 */
type JSWidgetFontName =
  "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";

/** 字体粗细 */
type JSWidgetFontWeight =
  "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";

/** 字体设计 */
type JSWidgetFontDesign =
  "monospaced" | "rounded" | "serif" | "default";

/** 字体 */
type JSWidgetFont =
  "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
        name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
        weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
        design?: "monospaced" | "rounded" | "serif" | "default";
        size?: number;
        custom?: string;
      };


type HttpParams = {
  headers?: Record<string, string>;
  body?: string | Record<string, any>;
  timeoutInterval?: number;
};

declare const $http: {
  get(url: string, params?: {
    headers?: Record<string, string>;
    body?: string | Record<string, any>;
    timeoutInterval?: number;
  }): Promise<string>;
  post(url: string, params?: {
    headers?: Record<string, string>;
    body?: string | Record<string, any>;
    timeoutInterval?: number;
  }): Promise<string>;
  put(url: string, params?: {
    headers?: Record<string, string>;
    body?: string | Record<string, any>;
    timeoutInterval?: number;
  }): Promise<string>;
  patch(url: string, params?: {
    headers?: Record<string, string>;
    body?: string | Record<string, any>;
    timeoutInterval?: number;
  }): Promise<string>;
  delete(url: string, params?: {
    headers?: Record<string, string>;
    body?: string | Record<string, any>;
    timeoutInterval?: number;
  }): Promise<string>;
};

declare function $fetch(url: string, params?: {
  headers?: Record<string, string>;
  body?: string | Record<string, any>;
  timeoutInterval?: number;
}): Promise<string>;
declare function fetch(url: string, params?: {
  headers?: Record<string, string>;
  body?: string | Record<string, any>;
  timeoutInterval?: number;
}): Promise<string>;

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
declare const $console: {
  /** 普通日志 */
  log(...args: any[]): void;
  /** 信息日志 */
  info(...args: any[]): void;
  /** 警告日志 */
  warn(...args: any[]): void;
  /** 错误日志 */
  error(...args: any[]): void;
};
declare const console: {
  /** 普通日志 */
  log(...args: any[]): void;
  /** 信息日志 */
  info(...args: any[]): void;
  /** 警告日志 */
  warn(...args: any[]): void;
  /** 错误日志 */
  error(...args: any[]): void;
};

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

type HealthSample = {
  value: number;
  unit: string;
  start: string;
  end: string;
};
declare const $health: {
  isAvailable(): boolean;
  requestAuthorization(): Promise<boolean>;
  stepCountToday(): Promise<{
        value: number;
        unit: string;
        start: string;
        end: string;
      }>;
  activeEnergyToday(): Promise<{
        value: number;
        unit: string;
        start: string;
        end: string;
      }>;
  heartRateLatest(): Promise<{
        value: number;
        unit: string;
        start: string;
        end: string;
      }>;
};

type LocationAuthorizationStatus =
  "notDetermined" | "restricted" | "denied" | "authorizedAlways" | "authorizedWhenInUse" | "disabled" | "unknown" | "unavailable";  // 非 iOS stub

type LocationRequestOptions = {
  timeout?: number;
  timeoutMs?: number;
};

type LocationCurrentOptions = {
  timeout?: number;
  timeoutMs?: number;
} & ({
  maxAge?: number;
  maxAgeMs?: number;
  accuracy?: "full" | "reduced";
  purposeKey?: string;
});

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
  authorizationStatus(): "notDetermined" | "restricted" | "denied" | "authorizedAlways" | "authorizedWhenInUse" | "disabled" | "unknown" | "unavailable";
  requestAuthorization(options?: {
    timeout?: number;
    timeoutMs?: number;
  }): Promise<boolean>;
  current(options?: {
    timeout?: number;
    timeoutMs?: number;
  } & ({
    maxAge?: number;
    maxAgeMs?: number;
    accuracy?: "full" | "reduced";
    purposeKey?: string;
  })): Promise<{
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
      }>;
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
  "small" | "medium" | "large" | "extraLarge" | "accessoryInline" | "accessoryCircular" | "accessoryRectangular" | "live-activity" | "dynamic-island" | "function";

declare function $getenv(key: "widget-size"): "small" | "medium" | "large" | "extraLarge" | "accessoryInline" | "accessoryCircular" | "accessoryRectangular" | "live-activity" | "dynamic-island" | "function" | "";
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
  expanded: {
      leading?: unknown;
      trailing?: unknown;
      center?: unknown;
      bottom?: unknown;
    };
  compactLeading: unknown;
  compactTrailing: unknown;
  minimal: unknown;
};

declare function $dynamic_island(config: {
  expanded: {
      leading?: unknown;
      trailing?: unknown;
      center?: unknown;
      bottom?: unknown;
    };
  compactLeading: unknown;
  compactTrailing: unknown;
  minimal: unknown;
}): void;

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

/// <reference path="./types.d.ts" />

/** 所有组件共享的公共属性 */
interface JSWidgetCommonAttributes {
  /** 尺寸（"max" 或 {width, height}） */
  size?: string | {
    width?: number | "fill";
    height?: number | "fill";
    minWidth?: number;
    maxWidth?: number | "fill";
    minHeight?: number;
    maxHeight?: number | "fill";
  };
  /**
   * 内容/子组件的水平对齐方式，需配合 size 使用。
   * 对 hstack：控制子元素组在主轴（水平）上的位置。
   * 对 vstack：控制子元素在交叉轴（水平）上的对齐（通过构造器生效，不依赖 size）。
   * 对 zstack：控制子元素水平堆叠锚点（通过构造器生效，不依赖 size）。
   * 对其他组件：在 size 指定的空间内水平定位内容。
   */
  justify?: "start" | "center" | "end";
  /**
   * 内容/子组件的垂直对齐方式，需配合 size 使用。
   * 对 vstack：控制子元素组在主轴（垂直）上的位置。
   * 对 hstack：控制子元素在交叉轴（垂直）上的对齐（通过构造器生效，不依赖 size）。
   * 对 zstack：控制子元素垂直堆叠锚点（通过构造器生效，不依赖 size）。
   * 对其他组件：在 size 指定的空间内垂直定位内容。
   */
  align?: "start" | "center" | "end";
  /** 内边距（数字或 {horizontal, vertical, top, bottom, leading, trailing, left, right}） */
  padding?: number | {
      /** 左右内边距 */
      horizontal?: number;
      /** 上下内边距 */
      vertical?: number;
      /** 顶部内边距 */
      top?: number;
      /** 底部内边距 */
      bottom?: number;
      /** 左内边距 */
      leading?: number;
      /** 右内边距 */
      trailing?: number;
      /** 左内边距 */
      left?: number;
      /** 右内边距 */
      right?: number;
    };
  /** 背景色 */
  backgroundColor?: string;
  /** 前景色 */
  foregroundColor?: string;
  /** 圆角 */
  cornerRadius?: number;
  /** 透明度 0-1 */
  opacity?: number;
  /** 旋转角度 */
  rotationEffect?: number;
  /** 缩放 */
  scaleEffect?: number;
  /** 偏移 */
  offset?: string;
  /** 阴影 */
  shadow?: string;
  /** 模糊 */
  blur?: number;
  /** 动画名 */
  animation?: string;
}

/** 通用图表数据项（bar / bar-x / bar-y / line / point / line-point / area / rect） */
interface JSWidgetChartDataItem {
  label: string;
  value: number;
  category?: string;
}

/** 甘特图数据项（bar-gantt） */
interface JSWidgetChartGanttDataItem {
  job: string;
  start: number;
  end: number;
  category?: string;
}

/** 规则线数据项（rule-x） */
interface JSWidgetChartRuleDataItem {
  xstart: number;
  xend: number;
  y: number;
  category?: string;
}

declare namespace JSWidget {
  function createElement<T extends keyof JSWidget.JSX.IntrinsicElements>(
    tag: T,
    props?: JSWidget.JSX.IntrinsicElements[T] | null,
    ...children: unknown[]
  ): unknown;
  /**
   * 函数组件重载——仅支持**同步**函数，不支持 async 函数。
   * 函数接收 props 对象（含 children），必须同步返回 JSX 元素。
   */
  function createElement(
    tag: ((props: Record<string, unknown>) => unknown),
    props?: Record<string, unknown> | null,
    ...children: unknown[]
  ): unknown;
  const Fragment: string;
  namespace JSX {
    interface IntrinsicElements {
      row: Omit<JSWidgetCommonAttributes, "align"> & {
        /** 水平间距 */
        spacing?: number;
      };
      col: JSWidgetCommonAttributes & {
        /** 垂直间距 */
        spacing?: number;
      };
      stack: JSWidgetCommonAttributes;
      grid: JSWidgetCommonAttributes & {
        /** 行配置 JSON 字符串 */
        rows?: string | number | boolean;
        /** 列数 */
        columns?: string | number | boolean;
        /** 间距 */
        spacing?: number;
      };
      "grid-row": Omit<JSWidgetCommonAttributes, "align"> & {
        /** 垂直对齐 */
        align?: "start" | "end" | "center" | "firstBaseline" | "lastBaseline";
        /** 行数 */
        rows?: string | number | boolean;
        /** 列配置 JSON 字符串 */
        columns?: string | number | boolean;
        /** 间距 */
        spacing?: number;
      };
      text: JSWidgetCommonAttributes & {
        /** 字体：语义名 / 数字字号 / {name,weight,design,size} / {custom,size} */
        font?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
                  name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
                  weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
                  design?: "monospaced" | "rounded" | "serif" | "default";
                  size?: number;
                  custom?: string;
                };
        /** 文字颜色 */
        color?: string;
        /**
         * 多行文本内部每一行的水平对齐方式。
         * 仅影响文本框内各行文字的排列，不改变组件盒子本身的位置。
         * 与 justify 的区别：justify 移动的是整个组件盒子，textAlign 对齐的是盒子内的文字行。
         * 两者可组合使用，例如 justify="start" + textAlign="center" 表示组件靠左、内部文字居中。
         * left 为 start 的别名，right 为 end 的别名。
         */
        textAlign?: "start" | "center" | "end" | "left" | "right";
        /** 行数限制 */
        lineLimit?: number;
      };
      date: JSWidgetCommonAttributes & {
        /** 显示样式 */
        style?: "date" | "time" | "relative" | "offset" | "timer";
        /** 字体：语义名 / 数字字号 / {name,weight,design,size} / {custom,size} */
        font?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
                name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
                weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
                design?: "monospaced" | "rounded" | "serif" | "default";
                size?: number;
                custom?: string;
              };
        /** 文字颜色 */
        color?: string;
        /**
         * 多行文本内部每一行的水平对齐方式。
         * 仅影响文本框内各行文字的排列，不改变组件盒子本身的位置。
         * 与 justify 的区别：justify 移动的是整个组件盒子，textAlign 对齐的是盒子内的文字行。
         * 两者可组合使用，例如 justify="start" + textAlign="center" 表示组件靠左、内部文字居中。
         * left 为 start 的别名，right 为 end 的别名。
         */
        textAlign?: "start" | "center" | "end" | "left" | "right";
        /** 行数限制 */
        lineLimit?: number;
      };
      image: JSWidgetCommonAttributes & {
        /** 包内 image/ 目录下的图片名（读取 image/{name}.png） */
        name?: string;
        /** 相对于脚本目录的图片路径，支持任意图片格式 */
        filePath?: string;
        /** 网络 URL */
        url?: string;
        /** 宽高比 */
        ratio?: number;
        /** 显示模式：`fit` 或 `fill` */
        mode?: "fit" | "fill";
        /** 仅 systemName 时生效（控制 SF Symbol 大小） */
        font?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
                name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
                weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
                design?: "monospaced" | "rounded" | "serif" | "default";
                size?: number;
                custom?: string;
              };
      };
      gif: JSWidgetCommonAttributes & {
        /** GIF 文件名。可以是包含扩展名的完整名称（如 "cat.gif"），也可以是不含扩展名的裸名称（如 "cat"，会自动补 .gif）。文件需放在脚本包的 images 目录下 */
        file: string;
        /** 宽高比 */
        ratio?: number;
        /** 显示模式：`fit` 或 `fill` */
        mode?: "fit" | "fill";
      };
      spacer: {
        /** 最小占用长度 */
        length?: number;
      };
      chart: JSWidgetCommonAttributes & {
        /** 图表数据数组 */
        data: JSWidgetChartDataItem[] | JSWidgetChartGanttDataItem[] | JSWidgetChartRuleDataItem[];
        /**
         * 图表类型，默认 `bar`。
         * `bar-gantt` 数据项为 `JSWidgetChartGanttDataItem`；
         * `rule-x` 为 `JSWidgetChartRuleDataItem`；
         * 其余为 `JSWidgetChartDataItem`。
         */
        type?:
          | "bar"
          | "bar-x"
          | "bar-y"
          | "bar-gantt"
          | "line"
          | "point"
          | "line-point"
          | "area"
          | "rect"
          | "rule-x";
        /** 是否按数据项 `category` 字段分色（默认 false） */
        category?: boolean;
        /** 是否隐藏图例 */
        hideLegend?: boolean;
        /** 是否隐藏 X 轴 */
        hideXAxis?: boolean;
        /** 是否隐藏 Y 轴 */
        hideYAxis?: boolean;
        /** 前景色 */
        color?: string;
      };
      link: JSWidgetCommonAttributes & {
        /** 链接地址 */
        url: string;
      };
      divider: JSWidgetCommonAttributes & {
        /** 线宽（默认 1） */
        thickness?: number;
        /** 方向 */
        axis?: "horizontal" | "vertical";
        /** 颜色 */
        color?: string;
      };
      icon: JSWidgetCommonAttributes & {
        /** SF Symbol 名 */
        systemName: string;
        /** 图标大小 */
        size?: number;
        /** 颜色 */
        color?: string;
        /** 字体：语义名 / 数字字号 / {name,weight,design,size} / {custom,size} */
        font?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
                name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
                weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
                design?: "monospaced" | "rounded" | "serif" | "default";
                size?: number;
                custom?: string;
              };
      };
      /** 带图标的文字，可以用 icon + text 组合实现 */
      label: JSWidgetCommonAttributes & {
        title?: string;
        systemName?: string;
        color?: string;
        font?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
                name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
                weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
                design?: "monospaced" | "rounded" | "serif" | "default";
                size?: number;
                custom?: string;
              };
      };
      progress: JSWidgetCommonAttributes & {
        /** 当前值（与 total 一起决定进度，默认 0） */
        value?: number;
        /** 总值（默认 1） */
        total?: number;
        /** 进度条旁/上的说明文字 */
        label?: string;
        /** linear（默认）| circular */
        style?: "linear" | "circular";
        /** 进度条着色 */
        color?: string;
        /** 轨道/背景色（设置后使用自定义绘制，默认 `#e2e8f0`） */
        trackColor?: string;
        /** label 的字体 */
        font?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2" | number | {
                name?: "largeTitle" | "title" | "title2" | "title3" | "headline" | "subheadline" | "body" | "callout" | "footnote" | "caption" | "caption2";
                weight?: "ultraLight" | "thin" | "light" | "regular" | "medium" | "semibold" | "bold" | "heavy" | "black";
                design?: "monospaced" | "rounded" | "serif" | "default";
                size?: number;
                custom?: string;
              };
      };
      button: JSWidgetCommonAttributes & {
        /** 预定义动作，目前仅支持 "reload" */
        action?: "reload";
        /** 点击时调用的 JS 函数名 */
        onClick?: string;
      };
      toggle: JSWidgetCommonAttributes & {
        /** 开关是否开启，默认 false */
        on?: boolean;
        /** 切换时调用的 JS 函数名 */
        onClick?: string;
      };

      /** 0–1 的环形进度条（类似 progress 的 circular，但是独立轻量组件）。 */
      ring: JSWidgetCommonAttributes & {
        /** 当前值（0–1） */
        value?: number;
        /** 圆环粗细（默认 8） */
        thickness?: number;
        /** 进度颜色（默认 `#3b82f6`） */
        color?: string;
        /** 轨道颜色（默认 `#e2e8f0`） */
        trackColor?: string;
      };
      /** 小号圆角标签，适合 PRO、NEW 等标签使用。 */
      badge: JSWidgetCommonAttributes & {
        /** 徽章文本 */
        text?: string;
        /** 圆角半径（默认 6） */
        radius?: number;
        /** 背景色（默认 `#0f172a`） */
        backgroundColor?: string;
        /** 文字颜色（默认 `#e2e8f0`） */
        color?: string;
      };
      /** 带边框的胶囊标签，比 badge 更大、有描边。 */
      chip: JSWidgetCommonAttributes & {
        /** 标签文本 */
        text?: string;
        /** 圆角半径（默认 14） */
        radius?: number;
        /** 背景色（无则使用默认） */
        backgroundColor?: string;
        /** 边框颜色（默认 `#cbd5f5`） */
        borderColor?: string;
        /** 文字颜色（默认 `#0f172a`） */
        color?: string;
      };
      /** 标题 + 大数字 + 可选副标题，适合仪表盘。 */
      stat: JSWidgetCommonAttributes & {
        /** 标题（默认 `Title`） */
        title?: string;
        /** 数值（默认 `0`） */
        value?: string;
        /** 副标题 */
        subtitle?: string;
        /** 数值颜色（默认 `#0f172a`） */
        color?: string;
        /** 辅助文字颜色（默认 `#64748b`） */
        mutedColor?: string;
      };
      /** 圆角矩形，可以用于各种形状的背景。 */
      roundedrect: JSWidgetCommonAttributes & {
        /** 圆角半径（默认 6） */
        radius?: number;
        /** 颜色 */
        color?: string;
      };
      line: JSWidgetCommonAttributes & {
        /** 线宽（默认 2） */
        thickness?: number;
        /** 长度（默认 48） */
        length?: number;
        /** 方向 */
        axis?: "horizontal" | "vertical";
        /** 颜色 */
        color?: string;
      };
      rect: JSWidgetCommonAttributes & {
        cornerRadius?: number;
      }
      capsule: JSWidgetCommonAttributes;
      ellipse: JSWidgetCommonAttributes;
      circle: JSWidgetCommonAttributes;
      /** 仪表盘，支持两种类型：original（内部实现） 或 system（SF Symbols）。 */
      gauge: JSWidgetCommonAttributes & (
        | {
            type?: "original";
            value?: number;
            angle?: number;
            thickness?: number;
            needleColor?: string;
            label?: string;
            title?: string;
            sections?: string;
          }
        | {
            type: "system";
            value?: number;
            style?: "circular" | "linear" | "automatic";
            text?: string;
            current?: string;
            min?: string;
            max?: string;
          }
      );
    }
  }
}
