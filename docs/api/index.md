# JSWidget JavaScript 运行时 API 文档

JSWidget JS 运行时暴露给 JavaScript 的所有 API。

---

## 概述

JSWidget 使用 JavaScriptCore 框架，在 Swift 端通过 `JSExport` 协议将原生 API 暴露给 JavaScript 环境。

**入口脚本**（如 `main.jsx`）：直接编写顶层语句，可使用顶层 **`await`**。**桌面小组件**在脚本中调用 **`$render`** 输出界面；**灵动岛 / Live Activity** 等场景调用 **`$dynamic_island`**（见下文「灵动岛 API」），同一入口脚本只取其一作为输出方式。通过 **`$import`** 加载的其它文件按模块方式编译执行，多用于导出变量、函数或 JSX 片段，与入口脚本的装载方式不同，详见「文件导入 API」章节。

在 JS 上下文中可用的全局对象包括：
- `$http` - HTTP 请求
- `$fetch` / `fetch` - 简化的 GET 请求
- `$console` / `console` - 日志输出
- `$device` - 设备信息
- `$file` - 脚本包内文件读写
- `$system` - 系统信息
- `$health` - HealthKit 健康数据
- `$location` - 位置服务
- `$storage` - 本地存储
- `$getenv` - 环境变量
- `$import` - 导入其他文件
- `$render` - 渲染组件
- `$dynamic_island` - 灵动岛配置
- `$element` - 元素构造函数
- `$component` - 组件定义
- `$error` - 错误处理
- `Promise` - Promise 支持

---

## 1. HTTP 请求 API

### `$http`

完整的 RESTful HTTP 请求支持。

#### 方法列表

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `get(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 发送 GET 请求 |
| `post(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 发送 POST 请求 |
| `put(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 发送 PUT 请求 |
| `patch(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 发送 PATCH 请求 |
| `delete(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 发送 DELETE 请求 |

`HttpParams` 字段见下文「`$fetch` / `fetch`」章节。

#### 使用示例

```jsx
// GET 请求
const result = await $http.get("https://api.example.com/data");

// GET 请求带 header
const data = await $http.get("https://api.github.com/users", {
  headers: {
    Accept: "application/json"
  }
});

// POST 请求带 JSON body
const response = await $http.post("https://api.example.com/posts", {
  body: {
    title: "Hello",
    content: "World"
  }
});

// POST 请求带字符串 body
const response = await $http.post("https://api.example.com/login", {
  headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  },
  body: "username=admin&password=123"
});
```

---

### `$fetch` / `fetch`

与 `$http.get` 等效的 fetch API 封装（`params` 类型同 `HttpParams`）。

| 函数 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `$fetch(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 发送 GET 请求 |
| `fetch(url, params?)` | `url: string`, `params?: HttpParams` | `Promise<string>` | 与 `$fetch` 相同 |

#### HttpParams

| 字段 | 类型 | 说明 |
|------|------|------|
| `headers` | `Record<string, string>` | 可选，HTTP 请求头 |
| `body` | `string \| Record<string, any>` | 可选，请求体（对象会序列化为 JSON） |
| `timeoutInterval` | `number` | 可选，超时时间（秒） |

```jsx
const result = await fetch("https://jsonplaceholder.typicode.com/todos/1");
const data = JSON.parse(result);

const withHeaders = await $fetch("https://api.example.com/data", {
  headers: { Accept: "application/json" },
  timeoutInterval: 30,
});
```

---

## 2. 控制台 API

### `$console` / `console`

用于输出日志和错误信息。`$console` 与 `console` 等价。

支持**多个参数**，会格式化为单行文本（对象自动 `JSON.stringify`）。在 App 预览控制台中，`log` / `info` / `warn` / `error` 会以不同颜色显示。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `log(...args)` | 任意参数 | `void` | 普通日志 |
| `info(...args)` | 任意参数 | `void` | 信息日志 |
| `warn(...args)` | 任意参数 | `void` | 警告日志 |
| `error(...args)` | 任意参数 | `void` | 错误日志 |

```jsx
console.log("Hello JSWidget");
console.log("Value:", someVariable);
console.info("Fetched", { count: 3 });
console.warn("Rate limited");
console.error("Something went wrong!");
```

---

## 3. 设备信息 API

### `$device`

提供设备相关信息。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `name()` | - | `string` | 设备名称（如 "iPhone 15 Pro"） |
| `model()` | - | `string` | 设备型号（如 "iPhone"） |
| `language()` | - | `string` | 当前语言代码（如 "zh"、"en"） |
| `systemVersion()` | - | `string` | 系统版本（如 "17.0"） |
| `screen()` | - | `{ scale: number, width: number, height: number }` | 屏幕信息 |
| `battery()` | - | `{ level: number, state: string }` | 电池信息 |
| `isdarkmode()` | - | `boolean` | 是否深色模式 |
| `totalDiskSpace()` | - | `number` | 磁盘总空间（字节） |
| `freeDiskSpace()` | - | `number` | 磁盘可用空间（字节） |

#### battery() 返回值说明

- `level`: 电池电量，0-1
- `state`: 电池状态

| state 值 | 说明 |
|----------|------|
| `unknown` | 未知 |
| `charging` | 充电中 |
| `full` | 已充满 |
| `unplugged` | 未充电 |

```jsx
console.log($device.name());           // "iPhone 15 Pro"
console.log($device.model());           // "iPhone"
console.log($device.language());        // "zh"
console.log($device.systemVersion());   // "17.0"
console.log(JSON.stringify($device.screen()));
// { "scale": 3, "width": 393, "height": 852 }
console.log(JSON.stringify($device.battery()));
// { "level": 0.85, "state": "charging" }
console.log($device.isdarkmode());      // true
```

---

## 4. 文件操作 API

### `$file`

操作**当前脚本包根目录**内的文件（与 `main.jsx` 同级或其子路径）。路径为包内相对路径；`list("")` 表示列出包根目录。不支持 `..` 或绝对路径越出包外。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `readString(path)` | `path: string` | `string` | 读取文件为 UTF-8 字符串；失败返回 `""` |
| `writeString(path, content)` | `path: string`, `content: string` | `boolean` | 写入文件（自动创建父目录）；只读包返回 `false` |
| `remove(path)` | `path: string` | `boolean` | 删除文件；不可删除 `main.jsx` |
| `list(path)` | `path: string` | `string[]` | 列出目录下一层条目（文件名与子目录名，非递归） |

```jsx
const raw = $file.readString("data.json");
const json = JSON.parse(raw);
console.log(json.name);

$file.writeString("notes.txt", "hello");
console.log($file.list("")); // 包根目录
console.log($file.remove("notes.txt"));
```

---

## 5. 系统信息 API

### `$system`

提供系统相关信息。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `appInfo()` | - | `{ name, bundleId, version, build }` | 应用信息 |
| `locale()` | - | `string` | 当前区域设置 |
| `preferredLanguages()` | - | `[string]` | 首选语言列表 |
| `timeZone()` | - | `{ identifier, abbreviation, offsetSeconds }` | 时区信息 |
| `is24HourClock()` | - | `boolean` | 是否为 24 小时制 |
| `calendarInfo()` | - | `{ identifier, firstWeekday, minimumDaysInFirstWeek }` | 日历信息 |
| `systemUptime()` | - | `double` | 系统运行时间（秒） |
| `memory()` | - | `{ physical: number }` | 物理内存（字节） |
| `thermalState()` | - | `"nominal" \| "fair" \| "serious" \| "critical" \| "unknown"` | 热状态 |
| `lowPowerMode()` | - | `boolean` | 低电量模式 |
| `brightness()` | - | `number` | 屏幕亮度：iOS 为 `0`–`1`；macOS 为 `-1` |
| `reduceMotionEnabled()` | - | `boolean` | 减弱动态效果 |
| `platform()` | - | `"ios" \| "macos"` | 平台类型 |
| `hostName()` | - | `string` | 主机名 |
| `processName()` | - | `string` | 进程名 |
| `osVersionString()` | - | `string` | OS 版本字符串 |
| `processorCount()` | - | `number` | 处理器数量 |
| `activeProcessorCount()` | - | `number` | 活跃处理器数量 |

#### thermalState 返回值

| 值 | 说明 |
|----|------|
| `nominal` | 正常 |
| `fair` | 轻微发热 |
| `serious` | 发热严重 |
| `critical` | 过热 |
| `unknown` | 未知 |

```jsx
const app = $system.appInfo();
const tz = $system.timeZone();
const memory = $system.memory();
const cpuCount = $system.processorCount();

$render(
  <col>
    <text font="title">{app.name}</text>
    <text font="caption">Version: {app.version} ({app.build})</text>
    <text font="caption">Platform: {$system.platform()}</text>
    <text font="caption">Timezone: {tz.identifier}</text>
  </col>
);
```

---

## 6. 健康数据 API

### `$health`

读取 HealthKit 健康数据（仅 iOS，仅读操作）。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `isAvailable()` | - | `boolean` | HealthKit 是否可用 |
| `requestAuthorization()` | - | `Promise<boolean>` | 请求健康数据授权 |
| `stepCountToday()` | - | `Promise<HealthSample>` | 今日步数 |
| `activeEnergyToday()` | - | `Promise<HealthSample>` | 今日活动能量 |
| `heartRateLatest()` | - | `Promise<HealthSample>` | 最新心率 |

#### HealthSample

| 字段 | 类型 | 说明 |
|------|------|------|
| `value` | `number` | 数值 |
| `unit` | `string` | 单位 |
| `start` | `string` | 区间开始时间 |
| `end` | `string` | 区间结束时间 |

```jsx
if (!$health.isAvailable()) {
  $render(
    <col>
      <text font="title3" color="#f87171">HealthKit Unavailable</text>
    </col>
  );
} else {
  const granted = await $health.requestAuthorization();

  if (!granted) {
    $render(
      <col>
        <text font="title3" color="#fbbf24">Permission Needed</text>
      </col>
    );
  } else {
    const steps = await $health.stepCountToday();
    const energy = await $health.activeEnergyToday();
    const heart = await $health.heartRateLatest();

    $render(
      <col>
        <text font="title3">Steps: {steps.value.toFixed(0)}</text>
        <text font="caption">Active Energy: {energy.value.toFixed(0)} kcal</text>
        <text font="caption">Latest HR: {heart.value.toFixed(0)} bpm</text>
      </col>
    );
  }
}
```

---

## 7. 位置服务 API

### `$location`

获取设备位置（仅 iOS）。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `isAvailable()` | - | `boolean` | 位置服务是否可用 |
| `authorizationStatus()` | - | `LocationAuthorizationStatus` | 授权状态 |
| `requestAuthorization(options?)` | `options?: LocationRequestOptions` | `Promise<boolean>` | 请求位置授权 |
| `current(options?)` | `options?: LocationCurrentOptions` | `Promise<LocationPayload>` | 获取当前位置 |

#### LocationAuthorizationStatus

| 值 | 说明 |
|----|------|
| `notDetermined` | 未决定 |
| `restricted` | 受限制 |
| `denied` | 被拒绝 |
| `authorizedAlways` | 始终授权 |
| `authorizedWhenInUse` | 使用时授权 |
| `disabled` | 定位服务关闭（iOS） |
| `unknown` | 未知 |
| `unavailable` | 不可用（非 iOS stub） |

#### LocationRequestOptions

| 字段 | 类型 | 说明 |
|------|------|------|
| `timeout` | `number` | 可选，超时（秒） |
| `timeoutMs` | `number` | 可选，超时（毫秒） |

#### LocationCurrentOptions

继承 `LocationRequestOptions`，并额外支持：

| 字段 | 类型 | 说明 |
|------|------|------|
| `maxAge` | `number` | 可选，可接受缓存位置的最大年龄（秒） |
| `maxAgeMs` | `number` | 可选，同上（毫秒） |
| `accuracy` | `"full" \| "reduced"` | 可选，精度 |
| `purposeKey` | `string` | 可选，用途键（iOS） |

#### LocationPayload

| 字段 | 类型 | 说明 |
|------|------|------|
| `latitude` | `number` | 纬度 |
| `longitude` | `number` | 经度 |
| `altitude` | `number` | 海拔 |
| `accuracy` | `number` | 水平精度（米） |
| `verticalAccuracy` | `number` | 垂直精度 |
| `speed` | `number` | 速度 |
| `course` | `number` | 航向 |
| `timestamp` | `string` | ISO8601 时间戳 |
| `accuracyAuthorization` | `"full" \| "reduced" \| "unknown"` | 精度授权 |
| `age` | `number` | 缓存年龄（秒） |
| `isStale` | `boolean` | 是否过期 |

```jsx
if (!$location.isAvailable()) {
  $render(
    <col>
      <text font="title3" color="#f87171">Location Unavailable</text>
    </col>
  );
} else {
  const status = $location.authorizationStatus();
  let granted = status === "authorizedWhenInUse" || status === "authorizedAlways";

  if (!granted) {
    granted = await $location.requestAuthorization({ timeout: 10 });
  }

  if (!granted) {
    $render(
      <col>
        <text font="title3" color="#fbbf24">Permission Needed</text>
      </col>
    );
  } else {
    const location = await $location.current({
      timeout: 10,
      accuracy: "full",
      purposeKey: "JSWidgetLocation"
    });

    $render(
      <col>
        <text font="title3">
          {location.latitude.toFixed(5)}, {location.longitude.toFixed(5)}
        </text>
        <text font="caption">
          Accuracy: {Math.round(location.accuracy)}m ({location.accuracyAuthorization})
        </text>
      </col>
    );
  }
}
```

---

## 8. 本地存储 API

### `$storage`

使用 UserDefaults 存储数据。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `getString(key)` | `key: string` | `string` | 获取字符串值 |
| `setString(key, value)` | `key: string`, `value: string` | `boolean` | 存储字符串 |
| `getJSON(key)` | `key: string` | `Record<string, unknown>` | 获取 JSON 对象 |
| `setJSON(key, value)` | `key: string`, `value: Record<string, unknown>` | `boolean` | 存储 JSON 对象 |
| `remove(key)` | `key: string` | `boolean` | 删除指定键 |
| `keys()` | - | `[string]` | 获取所有键 |
| `clear()` | - | `boolean` | 清空所有数据 |

```jsx
// 存储字符串
$storage.setString("greeting", "Hello JSWidget");
const greeting = $storage.getString("greeting");

// 存储 JSON
$storage.setJSON("profile", {
  name: "Alex",
  city: "Shanghai",
  updatedAt: new Date().toISOString()
});
const profile = $storage.getJSON("profile");

// 获取所有键
const allKeys = $storage.keys();

$render(
  <col>
    <text font="title">{greeting}</text>
    <text font="caption">Name: {profile.name}</text>
    <text font="caption">Keys: {allKeys.join(", ")}</text>
  </col>
);
```

---

## 9. 环境变量 API

### `$getenv`

获取运行时的环境变量（按 `key` 重载返回值类型）。

| 调用 | 参数 | 返回值 |
|------|------|--------|
| `$getenv("widget-size")` | 字面量 `"widget-size"` | `JSWidgetSize \| ""` |
| `$getenv("widget-param")` | 字面量 `"widget-param"` | `string` |
| `$getenv("script-dir")` | 字面量 `"script-dir"` | `string` |
| `$getenv(key)` | 其它 `string` | `string` |

#### JSWidgetSize（`widget-size` 的可能值）

`"small"` | `"medium"` | `"large"` | `"extraLarge"` | `"accessoryInline"` | `"accessoryCircular"` | `"accessoryRectangular"` | `"live-activity"` | `"dynamic-island"` | `"function"`

| 变量名 | 说明 |
|--------|------|
| `widget-param` | 用户配置的参数字符串 |
| `script-dir` | 当前脚本包目录的绝对路径 |

```jsx
const widget_size = $getenv("widget-size");
const widget_param = $getenv("widget-param");

$render(
  <col>
    <text font="title">Widget Size: {widget_size}</text>
    <text font="caption">Parameter: {widget_param}</text>
  </col>
);
```

---

## 10. 文件导入 API

### `$import`

导入并执行**同包内**的 `.js` / `.jsx` 文件（包内相对路径）。被导入文件的顶层变量/函数会进入当前 JS 上下文的**全局作用域**。

| 函数 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `$import(relativePath)` | `relativePath: string` | `boolean` | 文件是否存在；执行是否成功需自行保证（调用为同步，编译/执行为异步调度） |

```jsx
// util.jsx — 顶层定义
const textItems = [<text>Item 1</text>, <text>Item 2</text>];
const sum = (a, b) => a + b;

// main.jsx
$import("util.jsx");

$render(
  <col>
    <text font="title">test</text>
    {textItems}
    <text font="title">{sum(1, 2)}</text>
  </col>
);
```

---

## 11. 渲染 API

### `$render`

将 JSX 元素树渲染为小组件。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `$render(element)` | `element: unknown` | `void` | 渲染 JSX 元素树 |

```jsx
$render(
  <col size="max" backgroundColor="#0f172a">
    <text font="title" color="#e2e8f0">Hello JSWidget</text>
    <spacer />
    <text font="caption" color="#94a3b8">Welcome!</text>
  </col>
);
```

---

## 12. 灵动岛 API

### `$dynamic_island`

灵动岛入口脚本使用 `$dynamic_island(config)` 输出布局（与桌面小组件的 `$render` 互斥）。

| 函数 | 参数 | 返回值 |
|------|------|--------|
| `$dynamic_island(config)` | `config: DynamicIslandConfig` | `void` |

#### DynamicIslandConfig

| 字段 | 类型 | 说明 |
|------|------|------|
| `expanded` | `DynamicIslandExpandedConfig` | 展开态（必填） |
| `compactLeading` | `unknown` | 紧凑态左侧 |
| `compactTrailing` | `unknown` | 紧凑态右侧 |
| `minimal` | `unknown` | 最小态 |

#### DynamicIslandExpandedConfig

| 字段 | 类型 | 说明 |
|------|------|------|
| `leading` | `unknown` | 可选 |
| `trailing` | `unknown` | 可选 |
| `center` | `unknown` | 可选 |
| `bottom` | `unknown` | 可选 |

```jsx
$dynamic_island({
  expanded: {
    leading: <text>Left</text>,
    trailing: <text>Right</text>,
    center: <text>Center</text>,
    bottom: <text>Bottom</text>,
  },
  compactLeading: <text>Lead</text>,
  compactTrailing: <text>Trail</text>,
  minimal: <text>...</text>
});
```

---

## 13. 组件定义 API

### `$component`

定义可复用的组件。

| 函数 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `$component(name, builder)` | `name: string`, `builder: (...args: unknown[]) => unknown` | `void` | 注册命名组件 |

```jsx
$component("MyCard", (title, content) => {
  return (
    <col backgroundColor="#f1f5f9" cornerRadius={12}>
      <text font="headline">{title}</text>
      <text font="body">{content}</text>
    </col>
  );
});
```

---

## 14. 元素构造函数

### `$element`

创建 JSX 元素（与 `JSWidget.createElement` 等价）。

| 属性 / 方法 | 类型 | 说明 |
|-------------|------|------|
| `createElement(tag, props?, ...children)` | `tag: string \| ((...args: unknown[]) => unknown)`, `props?: Record<string, unknown> \| null`, `...children: unknown[]` | `unknown` |

```jsx
const textElement = $element.createElement("text", { font: "title" }, ["Hello"]);
```

---

## 15. 错误处理 API

### `$error`

报告错误信息。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `$error(message)` | `message: string` | `void` | 报告错误 |

```jsx
try {
  // some code
} catch(e) {
  $error(`${e}`);
}
```

---

## 16. 全局 Promise 支持

### `Promise`

内置 Promise 支持，可用于 async/await 模式。

```jsx
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

await delay(1000);
const result = await $http.get("https://api.example.com/data");

$render(
  <col>
    <text>{result}</text>
  </col>
);
```

---

## 附录：API 汇总表

| API | 说明 | 平台 |
|-----|------|------|
| `$http` | HTTP 请求 | iOS / macOS |
| `$fetch` / `fetch` | 简化的 GET 请求 | iOS / macOS |
| `$console` / `console` | 日志输出 | iOS / macOS |
| `$device` | 设备信息 | iOS / macOS |
| `$file` | 脚本包内文件读写 | iOS / macOS |
| `$system` | 系统信息 | iOS / macOS |
| `$health` | HealthKit 健康数据 | iOS |
| `$location` | 位置服务 | iOS |
| `$storage` | 本地存储 | iOS / macOS |
| `$getenv` | 环境变量 | iOS / macOS |
| `$import` | 文件导入 | iOS / macOS |
| `$render` | 渲染组件 | iOS / macOS |
| `$dynamic_island` | 灵动岛配置 | iOS |
| `$component` | 组件定义 | iOS / macOS |
| `$element` | 元素构造函数 | iOS / macOS |
| `$error` | 错误处理 | iOS / macOS |