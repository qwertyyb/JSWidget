# ScriptWidget：面向语言模型的编写说明

本文档供 **大语言模型与自动化工具** 阅读，**不收录**在 VitePress 文档站中。面向最终用户的说明与可复制 prompt 见 **`docs-site/guide/ai.md`**（部署文档站后路径一般为 `/guide/ai`）。

---

## 建议阅读顺序（仓库内路径）

1. `docs/getting-started.md` — 顶层脚本、`$render` / `$dynamic_island`、JSX 小写标签、尺寸与存储的典型写法。
2. `docs/components.md` — 可用元素、布局、图表与通用属性。
3. `docs/api.md` — `$http`、`$storage`、`$getenv`、`$dynamic_island` 等运行时 API。

仓库内还有机器可读索引：`docs-site/public/llms.txt`（构建文档站后也可通过站点根路径 `/llms.txt` 访问）。

---

## 生成代码时必须满足的结构

- 输出 **顶层脚本**：桌面小组件调用 **`$render(...)`**；灵动岛 / Live Activity 类脚本以 **`$dynamic_island(...)`** 作为输出（见 `docs/api.md`），不要笼统写成「都用 `$render`」。
- 使用 **`await`** / **`async/await`** 处理网络与异步 API（入口脚本支持顶层 **`await`**）；对 `$http` 返回值按需 **`JSON.parse`**（若接口返回 JSON 字符串）。
- 根布局常用 **`<vstack frame="max" padding={…}>`** 或 `hstack` / `zstack`，与目标小组件尺寸协调。

```jsx
$render(
  <vstack frame="max" padding={16}>
    <text font="title">Hello</text>
  </vstack>
);
```

上例适用于**桌面小组件**；**灵动岛**请使用 `$dynamic_island({ ... })`，见 `docs/api.md` 中「灵动岛 API」章节。

---

## 易混淆点（减少幻觉）

| 误区 | 说明 |
|------|------|
| 灵动岛仍写 `$render` 当唯一输出 | 灵动岛脚本应以 **`$dynamic_island`** 配置内容；`$render` 在该管线中会被忽略。 |
| 使用 React DOM 标签 | 应使用 `docs/components.md` 中的小写标签（如 `text`、`image`、`spacer`），不是 `div` / `span`。 |
| 忽略小组件尺寸 | 用 `$getenv("widget-size")` 区分 `small` / `medium` / `large`，避免大布局塞进小尺寸。 |
| 臆造 API 或 props | 仅使用 `docs/api.md` 与 `docs/components.md` 中出现的名称与参数；不确定时写明假设或省略该能力。 |
| 与标准浏览器环境混淆 | 运行时为 JavaScriptCore；以文档列出的全局对象为准，不要默认存在 `window` / `document`。 |

---

## 推荐输出格式（面向用户）

当用户描述「想要的小组件」时，建议助手输出：

1. **简短说明**：数据从哪来、如何适配 small/medium/large（若相关）。
2. **完整可粘贴脚本**：单文件 `main.jsx` 风格，顶层逻辑 + 输出调用（桌面用 `$render`，灵动岛用 `$dynamic_island`）。
3. **权限与限制**（如适用）：例如 HealthKit、定位、网络域名需在 App 侧配置或用户授权；不要承诺文档未说明的能力。

若用户需求依赖未在文档中出现的 API，应明确标注 **「当前文档未涵盖，需人工核对运行时」**，避免编造。

---

## 与维护者的约定

- API 与组件正文维护在 **`docs/api.md`** 与 **`docs/components.md`**；`docs-site` 通过 include 引用其中部分页面。
- 快速入门正文维护在 **`docs/getting-started.md`**；文档站 `docs-site/guide/getting-started.md` 仅作 include；App 内嵌 **`Script.bundle/docs/getting-started.md`** 需与前者保持内容一致（发布前同步拷贝）。
- 面向模型的补充约定维护在 **`docs/ai-for-llms.md`**（本文件）。
- 用户侧「复制 prompt」与入口链接维护在 **`docs-site/guide/ai.md`**。
- 更新路径或 raw URL 约定时，请同步 **`docs-site/public/llms.txt`**。
