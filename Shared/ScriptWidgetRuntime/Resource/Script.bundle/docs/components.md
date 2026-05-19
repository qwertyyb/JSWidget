# JSWidget JSX 元素完整文档

本文档描述 JSWidget 支持的所有 JSX 元素、属性及其用法。

各组件专有属性均与 `JSWidgetCommonAttributes` 交叉组合（`row` 除外，见下文）。除另有说明外，均可使用[通用属性](#通用属性jswidgetcommonattributes)。

---

## 布局容器

### `row`（水平堆叠）

水平排列子元素。继承 `JSWidgetCommonAttributes`，但**不包含** `align`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `spacing` | `number` | 子元素水平间距 |
| `justify` | `"start" \| "center" \| "end"` | 主轴分布（需配合 `size` 使用） |
| `size` | 见[通用属性](#通用属性jswidgetcommonattributes) | 尺寸 |
| 其他 | 见[通用属性](#通用属性jswidgetcommonattributes) | 不含 `align` |

```jsx
<row justify="center" spacing={8} size={{ width: "fill" }}>
  <text>Left</text>
  <text>Right</text>
</row>
```

---

### `col`（垂直堆叠）

垂直排列子元素。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `spacing` | `number` | 子元素垂直间距 |
| `align` | `"start" \| "center" \| "end"` | 子元素水平对齐（交叉轴） |
| `justify` | `"start" \| "center" \| "end"` | 主轴分布（需配合 `size` 使用） |

```jsx
<col align="center" spacing={10}>
  <text>Hello</text>
  <text>World</text>
</col>
```

---

### `stack`（层叠容器）

按 z 轴顺序层叠子元素。仅继承 `JSWidgetCommonAttributes`，无额外专有属性。

```jsx
<stack>
  <roundedrect radius={8} color="#f1f5f9" size={{ width: 100, height: 60 }} />
  <text>覆盖在上面</text>
</stack>
```

---

### `grid`（网格）

网格排列子元素。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `rows` | `string \| number \| boolean` | 行配置 JSON 字符串 |
| `columns` | `string \| number \| boolean` | 列数 / 列配置 |
| `spacing` | `number` | 间距 |

```jsx
<grid
  columns='[{"type":"adaptive","min":"60"},{"type":"fixed","value":"80"}]'
  spacing={10}
>
  <text>Item 1</text>
  <text>Item 2</text>
</grid>
```

---

### `grid-row`（网格行）

网格行布局。继承 `JSWidgetCommonAttributes`，但**不包含**通用 `align`（使用下方专用 `align`）。

| 属性 | 类型 | 说明 |
|------|------|------|
| `align` | `"start" \| "end" \| "center" \| "firstBaseline" \| "lastBaseline"` | 垂直对齐 |
| `rows` | `string \| number \| boolean` | 行数 |
| `columns` | `string \| number \| boolean` | 列配置 JSON 字符串 |
| `spacing` | `number` | 间距 |

---

## 文本

### `text`

显示文本。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `font` | `JSWidgetFont` | 字体：语义名 / 数字字号 / 对象 |
| `color` | `string` | 文字颜色 |
| `textAlign` | `"start" \| "center" \| "end"` | 文本对齐 |
| `lineLimit` | `number` | 行数限制 |

**`JSWidgetFont`** 支持三种形式：

- **语义名**：`"largeTitle"` \| `"title"` \| `"title2"` \| `"title3"` \| `"headline"` \| `"subheadline"` \| `"body"` \| `"callout"` \| `"footnote"` \| `"caption"` \| `"caption2"`
- **数字**：直接指定字号
- **对象**：精细控制

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | 语义名 | 基础字体名 |
| `weight` | `"ultraLight"` \| `"thin"` \| `"light"` \| `"regular"` \| `"medium"` \| `"semibold"` \| `"bold"` \| `"heavy"` \| `"black"` | 字重 |
| `design` | `"monospaced"` \| `"rounded"` \| `"serif"` \| `"default"` | 字体设计 |
| `size` | `number` | 字号 |
| `custom` | `string` | 自定义字体名 |

```jsx
<text font="title" color="#333">Hello World</text>
<text font={{ name: "body", weight: "bold" }} lineLimit={1}>Single line</text>
```

---

### `date`

动态显示日期和时间。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `style` | `"date" \| "time" \| "relative" \| "offset" \| "timer"` | 显示样式 |
| `font` | `JSWidgetFont` | 字体 |
| `color` | `string` | 文字颜色 |
| `textAlign` | `"start" \| "center" \| "end"` | 文本对齐 |
| `lineLimit` | `number` | 行数限制 |

```jsx
<date style="time" />
<date style="relative" color="#64748b" />
```

---

## 图片与媒体

### `image`

显示图片。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `name` | `string` | 包内 `image/` 目录下的图片名（读取 `image/{name}.png`） |
| `filePath` | `string` | 相对于脚本目录的图片路径，支持任意图片格式 |
| `url` | `string` | 网络 URL |
| `ratio` | `number` | 宽高比 |
| `mode` | `"fit" \| "fill"` | 显示模式 |
| `font` | `JSWidgetFont` | 仅 `systemName` 时生效（控制 SF Symbol 大小） |

```jsx
<image name="logo" />
<image url="https://example.com/image.png" mode="fit" />
```

---

### `gif`

显示 GIF 动画。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `file` | `string` | **必填**。GIF 文件名；可为 `"cat.gif"` 或 `"cat"`（自动补 `.gif`）。文件放在脚本包的 `images` 目录下 |
| `ratio` | `number` | 宽高比 |
| `mode` | `"fit" \| "fill"` | 显示模式 |

```jsx
<gif file="animation.gif" mode="fit" />
```

---

## 交互

### `button`

可点击按钮。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `action` | `"reload"` | 预定义动作，目前仅支持 `"reload"`（重载小组件） |
| `onClick` | `string` | 点击时调用的 JS 函数名（在 `main.jsx` 顶层声明） |

`action` 与 `onClick` 二选一：有 `action="reload"` 时走系统重载；否则按 `onClick` 调用脚本函数。

```jsx
<button action="reload">
  <text>重新加载</text>
</button>

<button onClick="handleClick">
  <text>点击我</text>
</button>
```

---

### `toggle`

开关控件。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `on` | `boolean` | 开关是否开启，默认 `false` |
| `onClick` | `string` | 切换时调用的 JS 函数名 |

```jsx
<toggle on={true} onClick="toggleHandler">
  <text>设置选项</text>
</toggle>
```

---

### `link`

可点击链接。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `url` | `string` | **必填**。跳转目标 URL |

```jsx
<link url="widget-deeplink://action">
  <text>点击跳转</text>
</link>
```

---

## 图表

### `chart`

基于 Swift Charts 的图表。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `data` | 见下方 | **必填**。图表数据数组 |
| `type` | 见下方 | 图表类型，默认 `"bar"` |
| `category` | `boolean` | 是否按数据项 `category` 字段分色，默认 `false` |
| `hideLegend` | `boolean` | 是否隐藏图例 |
| `hideXAxis` | `boolean` | 是否隐藏 X 轴 |
| `hideYAxis` | `boolean` | 是否隐藏 Y 轴 |
| `color` | `string` | 前景色 |

**`type` 可选值**：

| 值 | 说明 | `data` 项类型 |
|----|------|----------------|
| `bar` | 柱状图（X 轴为标签） | `JSWidgetChartDataItem` |
| `bar-x` | 水平柱状图 | `JSWidgetChartDataItem` |
| `bar-y` | 垂直柱状图 | `JSWidgetChartDataItem` |
| `bar-gantt` | 甘特图 | `JSWidgetChartGanttDataItem` |
| `line` | 折线图 | `JSWidgetChartDataItem` |
| `point` | 点图 | `JSWidgetChartDataItem` |
| `line-point` | 带点折线图 | `JSWidgetChartDataItem` |
| `area` | 面积图 | `JSWidgetChartDataItem` |
| `rect` | 矩形图 | `JSWidgetChartDataItem` |
| `rule-x` | X 轴规则线 | `JSWidgetChartRuleDataItem` |

**数据项类型**：

```ts
// 通用（bar / line / point / area / rect 等）
interface JSWidgetChartDataItem {
  label: string;
  value: number;
  category?: string;
}

// bar-gantt
interface JSWidgetChartGanttDataItem {
  job: string;
  start: number;
  end: number;
  category?: string;
}

// rule-x
interface JSWidgetChartRuleDataItem {
  xstart: number;
  xend: number;
  y: number;
  category?: string;
}
```

```jsx
const data = [
  { label: "A", value: 10 },
  { label: "B", value: 20 },
];

<chart type="bar" data={data} hideXAxis={true} color="red" />
```

---

## 形状与装饰

### `rect`

矩形。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `cornerRadius` | `number` | 圆角半径 |

```jsx
<rect size={{ width: 50, height: 30 }} backgroundColor="blue" cornerRadius={5} />
```

---

### `capsule`

胶囊形。仅继承 `JSWidgetCommonAttributes`，无专有属性。

```jsx
<capsule size={{ width: 50, height: 30 }} backgroundColor="blue" />
```

---

### `ellipse`

椭圆。仅继承 `JSWidgetCommonAttributes`，无专有属性。

```jsx
<ellipse size={{ width: 50, height: 30 }} backgroundColor="blue" />
```

---

### `circle`

圆形。仅继承 `JSWidgetCommonAttributes`，无专有属性。

```jsx
<circle size={{ width: 40, height: 40 }} backgroundColor="blue" />
```

---

### `roundedrect`

圆角矩形色块，常用于背景或占位。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `radius` | `number` | 圆角半径，默认 `12` |
| `color` | `string` | 填充颜色 |

```jsx
<roundedrect radius={12} color="#38bdf8" size={{ width: 140, height: 60 }} />
```

---

### `line`

固定长度线段。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `thickness` | `number` | 线宽，默认 `2` |
| `length` | `number` | 长度，默认 `48` |
| `axis` | `"horizontal" \| "vertical"` | 方向 |
| `color` | `string` | 颜色 |

```jsx
<line length={120} thickness={2} color="#94a3b8" />
<line axis="vertical" length={24} thickness={2} color="#f59e0b" />
```

---

### `divider`

分隔线。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `thickness` | `number` | 线宽，默认 `1` |
| `axis` | `"horizontal" \| "vertical"` | 方向 |
| `color` | `string` | 颜色 |

---

## 图标与标签

### `icon`

SF Symbol 图标。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `systemName` | `string` | **必填**。SF Symbol 名 |
| `size` | `number` | 图标大小 |
| `color` | `string` | 颜色 |
| `font` | `JSWidgetFont` | 字体（语义名 / 数字 / 对象） |

```jsx
<icon systemName="star.fill" size={24} color="#f59e0b" />
```

---

### `label`

带图标的文字（也可用 `icon` + `text` 组合实现）。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `title` | `string` | 标题文本 |
| `systemName` | `string` | 图标名 |
| `color` | `string` | 颜色 |
| `font` | `JSWidgetFont` | 字体 |

---

## 进度与数据展示

### `progress`

进度条。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `value` | `number` | 当前值，默认 `0` |
| `total` | `number` | 总值，默认 `1` |
| `label` | `string` | 进度条旁/上的说明文字 |
| `style` | `"linear" \| "circular"` | 样式，默认 `linear` |
| `color` | `string` | 进度条着色 |
| `trackColor` | `string` | 轨道/背景色（设置后使用自定义绘制，默认 `#e2e8f0`） |
| `font` | `JSWidgetFont` | `label` 的字体 |

```jsx
<progress value={0.6} total={1} label="Loading" style="circular" />
```

---

### `ring`

0–1 的环形进度条（轻量，类似 `progress` 的 `circular`）。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `value` | `number` | 当前值（0–1） |
| `thickness` | `number` | 圆环粗细，默认 `8` |
| `color` | `string` | 进度颜色，默认 `#3b82f6` |
| `trackColor` | `string` | 轨道颜色，默认 `#e2e8f0` |

```jsx
<ring value={0.68} thickness={10} color="#22c55e" trackColor="#e2e8f0" size={72} />
```

---

### `badge`

小号圆角标签，适合 `PRO`、`NEW` 等。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `text` | `string` | 徽章文本 |
| `radius` | `number` | 圆角半径，默认 `6` |
| `backgroundColor` | `string` | 背景色，默认 `#0f172a` |
| `color` | `string` | 文字颜色，默认 `#e2e8f0` |

```jsx
<badge text="PRO" backgroundColor="#22c55e" color="#ffffff" />
```

---

### `chip`

带边框的胶囊标签。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `text` | `string` | 标签文本 |
| `radius` | `number` | 圆角半径，默认 `14` |
| `backgroundColor` | `string` | 背景色（未设置则用默认） |
| `borderColor` | `string` | 边框颜色，默认 `#cbd5f5` |
| `color` | `string` | 文字颜色，默认 `#0f172a` |

```jsx
<chip text="Today" />
<chip text="Focus" borderColor="#38bdf8" color="#0f172a" />
```

---

### `stat`

标题 + 大数字 + 可选副标题，适合仪表盘。继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `title` | `string` | 标题，默认 `"Title"` |
| `value` | `string` | 数值，默认 `"0"` |
| `subtitle` | `string` | 副标题 |
| `color` | `string` | 数值颜色，默认 `#0f172a` |
| `mutedColor` | `string` | 辅助文字颜色，默认 `#64748b` |

```jsx
<stat title="Downloads" value="12.4k" subtitle="Today" color="#0f172a" />
```

---

## 仪表

### `gauge`

仪表盘。继承 `JSWidgetCommonAttributes`。按 `type` 分为两种属性集。

#### `type` 省略或 `"original"`（默认）

| 属性 | 类型 | 说明 |
|------|------|------|
| `type` | `"original"` | 内部自定义仪表 |
| `value` | `number` | 当前值（0–1） |
| `angle` | `number` | 弧度 |
| `thickness` | `number` | 厚度 |
| `needleColor` | `string` | 指针颜色 |
| `label` | `string` | 中心标签 |
| `title` | `string` | 副标题 |
| `sections` | `string` | 分段配置 JSON 字符串 |

#### `type="system"`

| 属性 | 类型 | 说明 |
|------|------|------|
| `type` | `"system"` | SwiftUI 系统 `Gauge` |
| `value` | `number` | 当前值（0–1） |
| `style` | `"circular" \| "linear" \| "automatic"` | 样式 |
| `text` | `string` | 标题文本 |
| `current` | `string` | 当前值标签文字 |
| `min` | `string` | 最小值端**标签**文字（非数值范围） |
| `max` | `string` | 最大值端**标签**文字（非数值范围） |

```jsx
<gauge type="system" value={0.6} style="circular" text="Battery" current="60%" />

<gauge value={0.72} label="72%" title="CPU" needleColor="#ef4444" />
```

---

## 布局辅助

### `spacer`

占用空间，用于布局分隔；在 `col` 中沿垂直方向扩展，在 `row` 中沿水平方向扩展。**不**继承 `JSWidgetCommonAttributes`。

| 属性 | 类型 | 说明 |
|------|------|------|
| `length` | `number` | 最小占用长度 |

```jsx
<col>
  <text font="title">Title</text>
  <spacer length={8} />
  <text font="caption">Footer</text>
</col>
```

---

## 通用属性（`JSWidgetCommonAttributes`）

多数标签通过交叉类型继承。

| 属性 | 类型 | 说明 |
|------|------|------|
| `size` | `string \| { width?, height?, minWidth?, maxWidth?, minHeight?, maxHeight? }` | `"max"` 或尺寸对象；`width` / `height` 等为 `number \| "fill"` |
| `justify` | `"start" \| "center" \| "end"` | 水平对齐 / 主轴分布（需配合 `size` 使用；容器的交叉轴对齐不依赖 size） |
| `align` | `"start" \| "center" \| "end"` | 垂直对齐（需配合 `size` 使用；容器的交叉轴对齐不依赖 size）。`row` 无此项；`grid-row` 使用专用 `align` |
| `padding` | `JSWidgetPadding` | 内边距 |
| `backgroundColor` | `string` | 背景色 |
| `foregroundColor` | `string` | 前景色 |
| `cornerRadius` | `number` | 圆角 |
| `opacity` | `number` | 透明度 0–1 |
| `rotationEffect` | `number` | 旋转角度 |
| `scaleEffect` | `number` | 缩放 |
| `offset` | `string` | 偏移 |
| `shadow` | `string` | 阴影 |
| `blur` | `number` | 模糊 |
| `animation` | `string` | 动画名 |

#### `JSWidgetPadding`

`number`（四边统一）或对象，按需指定各方向：

| 字段 | 类型 | 说明 |
|------|------|------|
| `horizontal` | `number` | 左右内边距 |
| `vertical` | `number` | 上下内边距 |
| `top` | `number` | 顶部内边距 |
| `bottom` | `number` | 底部内边距 |
| `leading` | `number` | 左内边距 |
| `trailing` | `number` | 右内边距 |
| `left` | `number` | 左内边距（同 `leading`） |
| `right` | `number` | 右内边距（同 `trailing`） |

```jsx
<text size="max" padding={10} backgroundColor="#1e293b" />
<text size={{ width: "fill", height: 48 }} justify="center" align="center" />
<rect cornerRadius={12} opacity={0.9} rotationEffect={15} />
```

---

## 颜色格式

支持的颜色格式：

- **颜色名称**：`"red"`, `"blue"`, `"green"`, `"secondary"`, `"white"`, `"black"` 等
- **十六进制**：`"#ff0000"`, `"#f00"`, `"#ff000080"`（RGBA 顺序）
- **RGB 函数**：`"rgb(255, 0, 0)"`
- **RGBA 函数**：`"rgba(255, 0, 0, 0.5)"`

---

## 函数组件

除了内置 JSX 元素外，你还可以编写**函数组件**来封装和复用 UI 片段。函数组件接收一个 `props` 对象（包含传入的属性和 `children`），返回 JSX 元素。

```jsx
function Greeting(props) {
  return (
    <col>
      <text font="headline" color={props.color}>Hello, {props.name}!</text>
      {props.children}
    </col>
  );
}

$render(
  <col size="max" padding={16}>
    <Greeting name="World" color="#0f172a">
      <text font="caption">Welcome to JSWidget</text>
    </Greeting>
  </col>
);
```

**注意**：函数组件**必须是同步函数**，不支持 `async` 函数组件。如果需要异步数据，请在函数组件外部获取数据后通过 props 传入。

```jsx
// ✅ 正确：在外部获取数据，通过 props 传入
const data = await $http.get("https://api.example.com/data");

function DataCard(props) {
  return <text>{props.data}</text>;
}

$render(<DataCard data={data} />);
```

```jsx
// ❌ 错误：不支持 async 函数组件
async function DataCard() {
  const data = await $http.get("https://api.example.com/data");
  return <text>{data}</text>;
}
```

---

## 元素汇总表

| 标签 | 分类 | 说明 |
|------|------|------|
| `row` | 布局 | 水平堆叠（无 `align`） |
| `col` | 布局 | 垂直堆叠 |
| `stack` | 布局 | 层叠 |
| `grid` | 布局 | 网格 |
| `grid-row` | 布局 | 网格行 |
| `text` | 文本 | 文本 |
| `date` | 文本 | 日期/时间 |
| `image` | 媒体 | 图片 |
| `gif` | 媒体 | GIF |
| `button` | 交互 | 按钮 |
| `toggle` | 交互 | 开关 |
| `link` | 交互 | 链接 |
| `chart` | 图表 | 图表 |
| `rect` | 形状 | 矩形 |
| `capsule` | 形状 | 胶囊 |
| `ellipse` | 形状 | 椭圆 |
| `circle` | 形状 | 圆 |
| `roundedrect` | 形状 | 圆角矩形色块 |
| `line` | 形状 | 线段 |
| `divider` | 形状 | 分隔线 |
| `gauge` | 仪表 | 仪表盘 |
| `icon` | 展示 | SF Symbol |
| `label` | 展示 | 图标+文字 |
| `progress` | 展示 | 进度条 |
| `ring` | 展示 | 圆环进度 |
| `badge` | 展示 | 徽章 |
| `chip` | 展示 | 标签 chip |
| `stat` | 展示 | 统计块 |
| `spacer` | 布局 | 间距（仅 `length`） |
