# ScriptWidget JavaScript 运行时 API 文档

本文档描述 ScriptWidget JS 运行时暴露给 JavaScript 的所有 API。

---

## 概述

ScriptWidget 使用 JavaScriptCore 框架，在 Swift 端通过 `JSExport` 协议将原生 API 暴露给 JavaScript 环境。

在 JS 上下文中可用的全局对象包括：
- `$http` - HTTP 请求
- `$fetch` / `fetch` - 简化的 GET 请求
- `$console` / `console` - 日志输出
- `$device` - 设备信息
- `$file` - 文件读取
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
| `get(url, params?)` | `url: string`, `params?: { headers?, timeoutInterval? }` | `Promise<string>` | 发送 GET 请求 |
| `post(url, params?)` | `url: string`, `params?: { headers?, body?, timeoutInterval? }` | `Promise<string>` | 发送 POST 请求 |
| `put(url, params?)` | `url: string`, `params?: { headers?, body?, timeoutInterval? }` | `Promise<string>` | 发送 PUT 请求 |
| `patch(url, params?)` | `url: string`, `params?: { headers?, body?, timeoutInterval? }` | `Promise<string>` | 发送 PATCH 请求 |
| `delete(url, params?)` | `url: string`, `params?: { headers?, timeoutInterval? }` | `Promise<string>` | 发送 DELETE 请求 |

#### params 参数说明

- `headers`: `{ [key: string]: string }` - HTTP 请求头
- `body`: `object | string` - 请求体，object 会序列化为 JSON
- `timeoutInterval`: `number` - 超时时间（秒）

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

与 `$http.get` 等效的 fetch API 封装。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `fetch(url)` | `url: string` | `Promise<string>` | 发送 GET 请求 |

```jsx
const result = await fetch("https://jsonplaceholder.typicode.com/todos/1");
const data = JSON.parse(result);
```

---

## 2. 控制台 API

### `$console` / `console`

用于输出日志和错误信息。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `log(message)` | `message: string` | `void` | 输出普通日志 |
| `error(message)` | `message: string` | `void` | 输出错误日志 |

```jsx
console.log("Hello ScriptWidget");
console.log("Value:", someVariable);
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
| `totalDiskSpace()` | - | `int64` | 磁盘总空间（字节） |
| `freeDiskSpace()` | - | `int64` | 磁盘可用空间（字节） |

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

读取包内文件。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `read(relativePath)` | `relativePath: string` | `string` | 读取文件内容为字符串 |
| `readJSON(relativePath)` | `relativePath: string` | `object` | 读取文件内容为 JSON 对象 |

```jsx
// 读取为字符串
const content = $file.read("data.txt");

// 读取为 JSON
const json = $file.readJSON("data.json");
console.log(json.name);
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
| `memory()` | - | `{ physical: int64 }` | 物理内存（字节） |
| `thermalState()` | - | `string` | 热状态 |
| `lowPowerMode()` | - | `boolean` | 低电量模式 |
| `brightness()` | - | `double` | 屏幕亮度（仅 iOS，0-1） |
| `reduceMotionEnabled()` | - | `boolean` | 减弱动态效果 |
| `platform()` | - | `string` | 平台类型（"ios" / "macos"） |
| `hostName()` | - | `string` | 主机名 |
| `processName()` | - | `string` | 进程名 |
| `osVersionString()` | - | `string` | OS 版本字符串 |
| `processorCount()` | - | `int` | 处理器数量 |
| `activeProcessorCount()` | - | `int` | 活跃处理器数量 |

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
  <vstack>
    <text font="title">{app.name}</text>
    <text font="caption">Version: {app.version} ({app.build})</text>
    <text font="caption">Platform: {$system.platform()}</text>
    <text font="caption">Timezone: {tz.identifier}</text>
  </vstack>
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
| `stepCountToday()` | - | `Promise<[{ value, unit, start, end }]>` | 今日步数 |
| `activeEnergyToday()` | - | `Promise<[{ value, unit, start, end }]>` | 今日活动能量 |
| `heartRateLatest()` | - | `Promise<[{ value, unit, start, end }]>` | 最新心率 |

```jsx
if (!$health.isAvailable()) {
  $render(
    <vstack>
      <text font="title3" color="#f87171">HealthKit Unavailable</text>
    </vstack>
  );
} else {
  const granted = await $health.requestAuthorization();

  if (!granted) {
    $render(
      <vstack>
        <text font="title3" color="#fbbf24">Permission Needed</text>
      </vstack>
    );
  } else {
    const steps = await $health.stepCountToday();
    const energy = await $health.activeEnergyToday();
    const heart = await $health.heartRateLatest();

    $render(
      <vstack>
        <text font="title3">Steps: {steps.value.toFixed(0)}</text>
        <text font="caption">Active Energy: {energy.value.toFixed(0)} kcal</text>
        <text font="caption">Latest HR: {heart.value.toFixed(0)} bpm</text>
      </vstack>
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
| `authorizationStatus()` | - | `string` | 授权状态 |
| `requestAuthorization(options?)` | `options?: { timeout?, timeoutMs? }` | `Promise<boolean>` | 请求位置授权 |
| `current(options?)` | `options?: { timeout?, timeoutMs?, maxAge?, maxAgeMs?, accuracy?, purposeKey? }` | `Promise<object>` | 获取当前位置 |

#### authorizationStatus() 返回值

| 值 | 说明 |
|----|------|
| `notDetermined` | 未决定 |
| `restricted` | 受限制 |
| `denied` | 被拒绝 |
| `authorizedAlways` | 始终授权 |
| `authorizedWhenInUse` | 使用时授权 |
| `unavailable` | 不可用 |

#### current() 返回值结构

```typescript
{
  latitude: number,
  longitude: number,
  altitude: number,
  accuracy: number,           // 水平精度（米）
  verticalAccuracy: number,
  speed: number,
  course: number,
  timestamp: string,          // ISO8601 格式
  accuracyAuthorization: "full" | "reduced" | "unknown",
  age: number,                // 缓存年龄（秒）
  isStale: boolean            // 是否过期
}
```

```jsx
if (!$location.isAvailable()) {
  $render(
    <vstack>
      <text font="title3" color="#f87171">Location Unavailable</text>
    </vstack>
  );
} else {
  const status = $location.authorizationStatus();
  let granted = status === "authorizedWhenInUse" || status === "authorizedAlways";

  if (!granted) {
    granted = await $location.requestAuthorization({ timeout: 10 });
  }

  if (!granted) {
    $render(
      <vstack>
        <text font="title3" color="#fbbf24">Permission Needed</text>
      </vstack>
    );
  } else {
    const location = await $location.current({
      timeout: 10,
      accuracy: "full",
      purposeKey: "ScriptWidgetLocation"
    });

    $render(
      <vstack>
        <text font="title3">
          {location.latitude.toFixed(5)}, {location.longitude.toFixed(5)}
        </text>
        <text font="caption">
          Accuracy: {Math.round(location.accuracy)}m ({location.accuracyAuthorization})
        </text>
      </vstack>
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
| `getJSON(key)` | `key: string` | `object` | 获取 JSON 对象 |
| `setJSON(key, value)` | `key: string`, `value: object` | `boolean` | 存储 JSON 对象 |
| `remove(key)` | `key: string` | `boolean` | 删除指定键 |
| `keys()` | - | `[string]` | 获取所有键 |
| `clear()` | - | `boolean` | 清空所有数据 |

```jsx
// 存储字符串
$storage.setString("greeting", "Hello ScriptWidget");
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
  <vstack>
    <text font="title">{greeting}</text>
    <text font="caption">Name: {profile.name}</text>
    <text font="caption">Keys: {allKeys.join(", ")}</text>
  </vstack>
);
```

---

## 9. 环境变量 API

### `$getenv`

获取运行时的环境变量。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `getenv(key)` | `key: string` | `string` | 获取环境变量值 |

#### 常用环境变量

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `widget-size` | 小组件尺寸 | `large` / `medium` / `small` |
| `widget-param` | 用户配置的参数 | 用户自定义字符串 |

```jsx
const widget_size = $getenv("widget-size");
const widget_param = $getenv("widget-param");

$render(
  <vstack>
    <text font="title">Widget Size: {widget_size}</text>
    <text font="caption">Parameter: {widget_param}</text>
  </vstack>
);
```

---

## 10. 文件导入 API

### `$import`

导入同一包内的其他 JS/JSX 文件。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `import(relativePath)` | `relativePath: string` | `boolean` | 导入并执行文件 |

导入后，文件中定义的变量和函数可以在当前文件中使用。

```jsx
// util.jsx
export const textItems = [
  <text>Item 1</text>,
  <text>Item 2</text>
];

export const sum = (a, b) => a + b;

// main.jsx
$import("util.jsx");

$render(
  <vstack>
    <text font="title">test</text>
    {textItems}
    <text font="title">{sum(1, 2)}</text>
  </vstack>
);
```

---

## 11. 渲染 API

### `$render`

将 JSX 元素树渲染为小组件。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `render(element)` | `element: JSX` | `void` | 渲染 JSX 元素树 |

```jsx
$render(
  <vstack frame="max" backgroundColor="#0f172a">
    <text font="title" color="#e2e8f0">Hello ScriptWidget</text>
    <spacer />
    <text font="caption" color="#94a3b8">Welcome!</text>
  </vstack>
);
```

### `$main` 函数

入口函数，必须定义 `$main` 函数作为脚本入口点。

```jsx
const $main = () => {
  $render(
    <vstack>
      <text>Hello</text>
    </vstack>
  );
};
```

或者使用 async 函数：

```jsx
const $main = async () => {
  const data = await $http.get("https://api.example.com/data");
  const json = JSON.parse(data);

  $render(
    <vstack>
      <text>{json.title}</text>
    </vstack>
  );
};
```

---

## 12. 灵动岛 API

### `$dynamic_island`

配置灵动岛（Dynamic Island）的显示内容。

| 参数 | 类型 | 说明 |
|------|------|------|
| expanded | `{ leading?, trailing?, center?, bottom? }` | 展开状态的内容 |
| compactLeading | `JSX element` | 紧凑状态左侧内容 |
| compactTrailing | `JSX element` | 紧凑状态右侧内容 |
| minimal | `JSX element` | 最小化状态内容 |

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

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `define(name, builder)` | `name: string`, `builder: function` | `void` | 定义组件 |

```jsx
$component("MyCard", (title, content) => {
  return (
    <vstack backgroundColor="#f1f5f9" cornerRadius={12}>
      <text font="headline">{title}</text>
      <text font="body">{content}</text>
    </vstack>
  );
});
```

---

## 14. 元素构造函数

### `$element`

创建 JSX 元素。

```jsx
const textElement = $element("text", { font: "title" }, ["Hello"]);
```

---

## 15. 错误处理 API

### `$error`

报告错误信息。

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `error(message)` | `message: string` | `void` | 报告错误 |

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

const $main = async () => {
  await delay(1000);
  const result = await $http.get("https://api.example.com/data");

  $render(
    <vstack>
      <text>{result}</text>
    </vstack>
  );
};
```

---

## 附录：API 汇总表

| API | 说明 | 平台 |
|-----|------|------|
| `$http` | HTTP 请求 | iOS / macOS |
| `$fetch` / `fetch` | 简化的 GET 请求 | iOS / macOS |
| `$console` / `console` | 日志输出 | iOS / macOS |
| `$device` | 设备信息 | iOS / macOS |
| `$file` | 文件读取 | iOS / macOS |
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