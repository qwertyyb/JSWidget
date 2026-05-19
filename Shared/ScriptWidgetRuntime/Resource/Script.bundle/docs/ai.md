# AI 指南

在 JSWidget 里，小组件脚本使用 JavaScript / JSX（例如 `main.jsx`）。你也可以借助大语言模型（ChatGPT、Claude、Cursor 等）来生成或改写脚本。

## 如何使用

1. **复制**下面「发给 AI 的提示词」框中的**全部文字**。
2. 粘贴到你使用的 AI 对话里。
3. **用中文或英文描述**你想要的桌面小组件（布局、数据、刷新方式等）。
4. AI 会依据提示词里的**官方文档链接**生成可在本应用中使用的 **`main.jsx`**。

提示词**不会**附带整份文档，只包含链接；请确保 AI 能访问互联网以便打开这些 Markdown 源文件（若使用离线模型，请自行把链接中的内容提供给模型）。

## 发给 AI 的提示词

以下整段可复制：

```
你正在协助用户编写 JSWidget（iOS / macOS 桌面小组件）脚本。

在写出任何 API 或 JSX 标签之前，请先根据下列官方文档（Markdown 源）作答；不要臆造文档中不存在的 API 或组件名：

1. 快速入门：https://raw.githubusercontent.com/qwertyyb/JSWidget/main/docs/guide/getting-started.md
2. 运行时 API：https://raw.githubusercontent.com/qwertyyb/JSWidget/main/docs/api/index.md
3. 组件与属性：https://raw.githubusercontent.com/qwertyyb/JSWidget/main/docs/components/index.md

规则摘要（若与上述文档冲突，以文档为准）：
- 入口脚本写顶层代码；桌面小组件用 $render；灵动岛相关场景用 $dynamic_island，勿混淆。
- JSX 使用文档中的小写标签（如 row、text），不要使用 HTML 或 React DOM 标签名臆造。

用户接下来会用自然语言描述想要的组件。请输出：
（1）简短实现思路；
（2）一份完整、可直接粘贴到 JSWidget 中的 main.jsx 源码；
```

## Skill（推荐）

安装 **JSWidget Script Generator** Skill，让 Agent 生成 JSWidget 脚本。

### 安装方法

将下方整段**复制并发送给 Agent**，即可一键安装：

```
帮我安装SKILL: https://qwertyyb.github.io/JSWidget/jswidget-script-gen.zip
```
