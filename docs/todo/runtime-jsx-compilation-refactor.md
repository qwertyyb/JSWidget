# Runtime JSX 编译重构方案

## 现状分析

### 当前架构

每次 Widget 刷新时执行完整流程：

```
用户 JSX 源码 → 加载 Babel (2.8MB) → 编译 JSX → 执行 JS → 渲染 Widget
```

- `ScriptWidgetRuntime.transform()` 每次调用都新建 `JSContext`，加载 `core.js`（@babel/standalone v7.17.6 定制版，2.8MB），然后编译
- `$import` 导入的子文件也会触发 `transform()`，同样走完整的编译流程
- 没有任何缓存机制

### 存在的问题

1. **性能开销高**：每次 Widget 刷新都要加载 2.8MB 的 Babel 并执行编译
2. **内存占用大**：Widget Extension 内存限制约 30MB，Babel 占用了大量内存
3. **职责不清晰**：`ScriptWidgetRuntime` 同时承担编译和执行两个职责
4. **过度依赖**：项目实际只需要 JSX 转换这一个功能，却引入了完整的 Babel

### Babel 在项目中的用途

Babel 在这里的作用**不是 ES 语法降级**（JavaScriptCore 已支持大部分现代 ES 特性），而是将 JSX 语法转换为函数调用：

```
<text font="title">Hello</text>
↓ Babel transform (preset: scriptwidget)
ScriptWidget.createElement("text", { font: "title" }, "Hello")
```

`core.js` 是定制版 @babel/standalone，把所有 `React` 引用替换为 `ScriptWidget`。

---

## 重构方案

### 目标

- Runtime 保持简洁，只负责执行 JS 和渲染组件，不包含编译逻辑
- 支持用户直接用纯 JS 创建组件（`ScriptWidget.createElement`）
- JSX 作为可选的语法糖，在保存时预编译为 JS
- 不引入整个 Babel，使用轻量方案只编译 JSX 语法

### 新架构

```
编辑时：用户编写 JSX → 保存时编译为 JS（App 端，轻量 JSX 编译器）
运行时：加载编译后的 JS → 直接执行 → 渲染 Widget
```

### 具体设计

#### 1. Runtime 简化

- 移除 `ScriptWidgetRuntime` 中的 `transform()` 方法
- 移除 `core.js`（Babel standalone）依赖
- Runtime 只执行 `.js` 文件，不再理解 JSX 语法
- `$import` 也只加载 `.js` 文件

#### 2. 纯 JS 组件创建支持

用户可以直接使用 `ScriptWidget.createElement` 创建组件，不写 JSX：

```javascript
const el = ScriptWidget.createElement("text", { font: "title" }, "Hello")
$render(el)
```

这已经由现有的 `util.js` 支持，不需要额外改动。

#### 3. JSX 预编译（App 端）

在 App 端实现轻量 JSX 编译器，在用户保存脚本时触发编译：

- **编译时机**：用户保存 `.jsx` 文件时
- **编译范围**：只转换 JSX 语法，不做其他 ES 语法转换

##### 轻量 JSX 编译器选型

| 方案 | 体积 | 优缺点 |
|------|------|--------|
| Swift 原生实现 | 0 | 可控性最强，不需要 JSContext；但实现工作量较大 |
| acorn + acorn-jsx | ~几十 KB | 成熟的 JS parser，只在 App 端使用；但仍需 JSContext |
| 手写简易 parser | 0 | 项目 JSX 用法相对固定，可以覆盖常见 case；但边界 case 需注意 |

倾向 Swift 原生实现，因为编译只在 App 端做（资源充裕），不需要启动 JSContext。

需要处理的 JSX 语法特性：
- 基础标签：`<tag prop="val">children</tag>`
- 表达式嵌套：`<text>{variable}</text>`
- Fragment：`<>...</>`
- 展开属性：`<tag {...obj} />`
- 自闭合标签：`<image src="url" />`
- 嵌套 JSX

#### 4. 编译产物存储

两个方案待定：

- **方案 A - 并排存储**：`script.jsx` → 生成 `script.compiled.js`，Runtime 优先加载 `.compiled.js`
- **方案 B - 隐藏目录**：编译产物存到 `.compiled/` 目录，对用户不可见

方案 A 更简单直接；方案 B 更干净但 `$import` 路径映射会复杂一些。

#### 5. 向后兼容

- 已有的 JSX 脚本：首次打开旧脚本时自动触发一次编译，生成对应 JS 文件
- Runtime 检测：如果只有 `.jsx` 没有对应编译产物，可给出提示而不是直接报错

---

## 预期收益

| 维度 | 现在 | 重构后 |
|------|------|--------|
| Runtime 职责 | 编译 + 执行 | 仅执行 |
| Widget Extension 内存 | 需加载 2.8MB Babel | 无编译器开销 |
| Widget 刷新延迟 | 每次编译 | 直接执行预编译产物 |
| 运行时依赖 | core.js (2.8MB) + util.js | 仅 util.js |
| 复杂度分布 | 运行时承担编译复杂度 | App 端承担，运行时简洁 |

---

## 实施步骤（待细化）

1. [ ] 实现轻量 JSX 编译器（Swift 原生 / JS 轻量库，待定）
2. [ ] App 端集成编译流程（保存时触发编译）
3. [ ] 设计编译产物存储方案
4. [ ] 简化 Runtime：移除 `transform()`，移除 `core.js` 依赖
5. [ ] `$import` 适配：只加载 `.js` 文件
6. [ ] 向后兼容：旧 JSX 脚本自动迁移编译
7. [ ] 测试验证：确保现有脚本行为不变
