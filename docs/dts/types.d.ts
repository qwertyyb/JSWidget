/**
 * JSWidget common type definitions.
 * Run `pnpm generate` in Tools/completion-gen/ after editing.
 */

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
  | "largeTitle"
  | "title"
  | "title2"
  | "title3"
  | "headline"
  | "subheadline"
  | "body"
  | "callout"
  | "footnote"
  | "caption"
  | "caption2";

/** 字体粗细 */
type JSWidgetFontWeight =
  | "ultraLight"
  | "thin"
  | "light"
  | "regular"
  | "medium"
  | "semibold"
  | "bold"
  | "heavy"
  | "black";

/** 字体设计 */
type JSWidgetFontDesign =
  | "monospaced"
  | "rounded"
  | "serif"
  | "default";

/** 字体 */
type JSWidgetFont =
  | JSWidgetFontName
  | number
  | {
    name?: JSWidgetFontName;
    weight?: JSWidgetFontWeight;
    design?: JSWidgetFontDesign;
    size?: number;
    custom?: string;
  };

/**
 * 颜色值。支持以下几种形式：
 *
 * - 颜色名：内置颜色（`"red"`、`"blue"` 等）或语义色（`"label"`、`"systemBackground"`、`"separator"`、`"systemBlue"` 等）。
 *   语义色会自动跟随系统深浅色，**无需重新执行脚本**。
 * - HEX：`"#fff"`、`"#ff0000"`、`"#ff000080"`（CSS 标准 RGBA 顺序）。
 * - CSS 函数：`"rgb(255, 0, 0)"` / `"rgba(255, 0, 0, 0.5)"`。
 * - `{ value, opacity }`：在已有颜色基础上叠加透明度。
 * - `{ light, dark }`：动态颜色，深浅色下分别使用对应值；切换主题时自动重绘，
 *   不依赖 `$device.isdarkmode()`，也不需要等待下一次 widget timeline。
 *   `light` / `dark` 内部可继续嵌套上述任意形式。
 */
type JSWidgetColorValue =
  | string
  | { value: string; opacity?: number }
  | { light: JSWidgetColorValue; dark: JSWidgetColorValue };

/** 阴影描述 */
type JSWidgetShadow = {
  color?: JSWidgetColorValue;
  radius?: number;
  x?: number;
  y?: number;
};

/** 渐变描述（线性 / 径向 / 角向） */
type JSWidgetGradient =
  | {
    type: "linear";
    colors: JSWidgetColorValue[];
    startPoint?: string;
    endPoint?: string;
  }
  | {
    type: "radial";
    colors: JSWidgetColorValue[];
    center?: string;
    startRadius?: number;
    endRadius?: number;
  }
  | {
    type: "angular";
    colors: JSWidgetColorValue[];
    center?: string;
  };

