# 快速入门

ScriptWidget 让你可以使用 JavaScript 和 JSX 语法编写 iOS/macOS 小组件。

---

## 基本结构

入口脚本（如 `main.jsx`）直接写**顶层代码**即可。**桌面小组件**在该文件中调用 **`$render()`** 渲染组件树；**灵动岛**等场景请改用 **`$dynamic_island`**，详见 [API 文档](/api/#_12-灵动岛-api)。

```jsx
$render(
  <vstack>
    <text font="title">Hello World</text>
  </vstack>
);
```

---

## JSX 元素

ScriptWidget 提供了一套类似 SwiftUI 的 JSX 元素，直接对应到原生 SwiftUI 组件。

**元素名称使用小写**（与标准 JSX 不同）：

```jsx
// 布局容器
<vstack>  // 垂直排列
<hstack>  // 水平排列
<zstack>  // 层叠排列

// 内容元素
<text>    // 文本
<image>   // 图片
<spacer>  // 间距
```

---

## 常用属性

```jsx
<vstack frame="max" padding={16}>
  <text font="title" color="#1e293b">标题</text>
  <text font="caption" color="#64748b">副标题</text>
  <spacer />
  <text font="body">内容</text>
</vstack>
```

**font 可选值**：`largeTitle` | `title` | `title2` | `title3` | `headline` | `subheadline` | `body` | `callout` | `footnote` | `caption`

**color 格式**：颜色名称（`"red"`）| 十六进制（`"#ff0000"`）| rgba（`"rgba(255,0,0,0.5)"`）

---

## 获取数据

使用 `$http` 或 `fetch` 发起网络请求，配合 `async/await`：

```jsx
const response = await $http.get("https://api.example.com/data");
const data = JSON.parse(response);

$render(
  <vstack frame="max" padding={16}>
    <text font="headline">{data.title}</text>
    <text font="body">{data.description}</text>
  </vstack>
);
```

---

## 适配小组件尺寸

通过 `$getenv("widget-size")` 获取当前小组件尺寸，实现响应式布局：

```jsx
const size = $getenv("widget-size"); // "small" | "medium" | "large"

$render(
  <vstack frame="max" padding={size === "small" ? 8 : 16}>
    {size === "small" ? (
      <text font="caption">简略内容</text>
    ) : (
      <vstack>
        <text font="title">完整内容</text>
        <text font="body">详细描述...</text>
      </vstack>
    )}
  </vstack>
);
```

---

## 本地存储

使用 `$storage` 在脚本运行间持久化数据：

```jsx
// 存储数据
$storage.setString("lastUpdate", new Date().toISOString());
$storage.setJSON("config", { theme: "dark", fontSize: 14 });

// 读取数据
const lastUpdate = $storage.getString("lastUpdate");
const config = $storage.getJSON("config");
```

---

## 下一步

- 查看 [组件文档](/components/) 了解所有可用的 JSX 元素和属性
- 查看 [API 文档](/api/) 了解所有可用的 JavaScript 运行时 API
- 若使用 AI 辅助编写脚本，请打开 [AI 指南](./ai) 复制提示词，并参阅站点根路径的 [llms.txt](/llms.txt)（路径索引）
- 在 App 的 **Templates** 选项卡中浏览 40+ 模板，找到合适的起点
