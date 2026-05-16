# ScriptWidget Store 说明

本目录存放 **脚本商店** 的静态数据：索引与每个脚本的源码、元数据、截图与可选资源文件。iOS 应用内的 **Store** Tab 通过 GitHub `raw.githubusercontent.com` 拉取 `store/index.json`，再按需下载各脚本目录下的文件（合并到默认分支后线上即可访问）。

本文档是 Store **结构的权威说明**，供维护者、贡献者与 AI 生成/校验 `index.json`、`meta.json` 及目录布局时使用。字段名以 **JSON 中的 snake_case** 为准（应用内使用 `JSONDecoder` 的 `convertFromSnakeCase` 解码）。

---

## 一、目录与文件约定

```
store/
  index.json                 # 商店总索引（列表、过滤、缩略图入口）
  README.md                  # 本说明
  scripts/
    <脚本 id>/               # 目录名必须等于该脚本的 id，且与 index / meta 中 id 一致
      main.jsx               # 必需。用户安装后的入口脚本
      meta.json              # 必需。详情页、安装时拉取资源列表等
      screenshots/           # 必需。仅用于商店展示，不写入用户脚本包
        small.png            # 建议至少一张，供详情轮播与列表预览
      image/                 # 可选。运行时被 main.jsx 引用的图片等，须在 meta.resources 中列出需安装的文件
      *.json 等              # 可选。其它数据文件，同样须在 meta.resources 中列出才会被安装
```

### 与用户设备上脚本包的关系

安装后，应用会在用户脚本目录下创建与 `meta.json` 中 `name` 对应的包目录（重名时自动加后缀），结构需符合运行时 `ScriptWidgetPackage` 约定：

- `main.jsx`：入口文件。
- `image/`：小组件引用的图片等资源（与仓库内 `store/scripts/<id>/image/` 中列在 `resources` 里的路径对应）。
- 其它在 `resources` 中列出的相对路径文件：会原样写入用户包内相同相对路径（例如 `data.json` 在包根目录）。

**不要**把 `meta.json`、仅用于展示的 `screenshots/` 下文件写进 `resources`；也不要把 `main.jsx` 写进 `resources`（安装逻辑单独拉取 `main.jsx`）。

---

## 二、`index.json`（根对象）

根对象描述整个索引的版本与时间；列表数据在 `scripts` 数组中。

### 2.1 根级字段

| 字段名 (JSON) | 类型 | 必需 | 说明 |
|---------------|------|------|------|
| `version` | 整数 | 是 | 索引格式版本。当前应用按 `1` 解析；后续若 breaking 变更可递增。 |
| `updated_at` | 字符串 | 是 | 人类可读或 ISO-8601 时间戳，用于展示「索引更新时间」；应用不依赖其做缓存失效逻辑时可仅作文案。 |
| `scripts` | 对象数组 | 是 | 每个元素是一条可在列表中展示的脚本摘要，字段见下表。 |

### 2.2 `scripts[]` 中每个对象的字段

| 字段名 (JSON) | 类型 | 必需 | 说明 |
|---------------|------|------|------|
| `id` | 字符串 | 是 | 脚本唯一标识；**必须**等于目录名 `store/scripts/<id>/`，且与对应 `meta.json` 的 `id` 一致。建议使用小写字母、数字、连字符，避免空格与特殊符号（影响 URL）。 |
| `name` | 字符串 | 是 | 展示名称；安装时作为推荐包名（若与用户已有脚本重名，应用会自动加后缀）。 |
| `description` | 字符串 | 是 | 列表与搜索用的简短描述。 |
| `author` | 字符串 | 是 | 作者或组织名。 |
| `category` | 字符串 | 是 | 分类 slug，用于应用内分类筛选。建议使用稳定小写英文，如：`weather`、`productivity`、`health`、`finance`、`utility`、`fun`、`other`（可按项目约定扩展）。 |
| `platforms` | 字符串数组 | 是 | 适用平台。每项为 `"ios"` 或 `"macos"`（小写）。可同时包含两者。**若为空数组 `[]`**，应用当前实现会视为「不限制平台」，列表与安装均可见。 |
| `version` | 字符串 | 是 | 语义化版本字符串，如 `1.0.0`；与 `meta.json` 的 `version` 建议保持一致。 |
| `min_app_version` | 字符串或 `null` | 否 | 预留：未来可表示最低应用版本；当前解码允许缺省或 `null`。 |
| `has_resources` | 布尔或缺省 | 否 | 是否与 `meta.json` 中非空的 `resources` 一致，便于列表展示「含资源」；安装仍以 `meta.json` 为准。 |
| `preview_screenshot` | 字符串或缺省 | 否 | 相对于 `store/scripts/<id>/` 的截图路径，用于**列表缩略图**（如 `screenshots/small.png`）。缺省时列表用占位图，详情仍可从 `meta.json` 的 `screenshots` 加载。 |

### 2.3 `index.json` 与 `meta.json` 的一致性建议

- `id`、`name`、`description`、`author`、`category`、`platforms`、`version` 应与同目录下 `meta.json` **一致**，避免列表与详情矛盾。
- `index.json` 体量应小、适合一次下载；长说明、多图路径、完整 `resources` 以 `meta.json` 为准。

### 2.4 根对象示例

```json
{
  "version": 1,
  "updated_at": "2026-05-16T00:00:00Z",
  "scripts": [
    {
      "id": "hello-store",
      "name": "Hello Store",
      "description": "Minimal sample widget to verify Store install from GitHub.",
      "author": "ScriptWidget",
      "category": "utility",
      "platforms": ["ios", "macos"],
      "version": "1.0.0",
      "min_app_version": null,
      "has_resources": false,
      "preview_screenshot": "screenshots/small.png"
    }
  ]
}
```

---

## 三、`meta.json`（每个脚本目录一份）

路径：`store/scripts/<id>/meta.json`。应用在**安装前**会拉取该文件以获取 `resources`、`screenshots` 等；详情页亦依赖其展示完整信息。

### 3.1 字段说明

| 字段名 (JSON) | 类型 | 必需 | 说明 |
|---------------|------|------|------|
| `id` | 字符串 | 是 | 与目录名、`index.json` 中该条目的 `id` 相同。 |
| `name` | 字符串 | 是 | 与 `index.json` 建议一致；安装时作为推荐包名。 |
| `description` | 字符串 | 是 | 详情页完整说明，可长于 `index.json` 中的列表描述。 |
| `author` | 字符串 | 是 | 作者或组织名。 |
| `category` | 字符串 | 是 | 与 `index.json` 中 `category` 建议一致。 |
| `platforms` | 字符串数组 | 是 | 同 `index.json`：`"ios"` / `"macos"`；空数组表示不限制（与当前应用过滤逻辑一致）。 |
| `version` | 字符串 | 是 | 与 `index.json` 建议一致。 |
| `widget_sizes` | 字符串数组或缺省 | 否 | 建议适配的小组件尺寸，如 `small`、`medium`、`large`；仅作文案与筛选提示，运行时仍以脚本与系统为准。 |
| `tags` | 字符串数组或缺省 | 否 | 标签，用于详情展示或后续扩展搜索；当前应用主要用于详情 UI。 |
| `screenshots` | 字符串数组或缺省 | 否 | 相对于 `store/scripts/<id>/` 的图片路径列表，用于**详情页轮播**（不参与安装）。至少建议提供一张，与 `screenshots/` 目录中文件一致。 |
| `resources` | 字符串数组或缺省 | 否 | 需要随 `main.jsx` **一并安装进用户包**的相对路径列表（相对于 `store/scripts/<id>/`）。示例：`image/icon.png`、`data/config.json`。**禁止**包含：`main.jsx`、`meta.json`、`screenshots/` 下任意路径。 |
| `created_at` | 字符串或缺省 | 否 | 创建日期，ISO 日期或任意展示字符串。 |
| `updated_at` | 字符串或缺省 | 否 | 最后更新日期。 |

### 3.2 `resources` 与磁盘布局

- 列表中每项为「相对脚本根目录」的正斜杠路径，例如 `image/bg.png`。
- 安装时应用会请求：  
  `https://raw.githubusercontent.com/<owner>/<repo>/<branch>/store/scripts/<id>/<resources 中的路径>`  
  将下载得到的**二进制**写入用户脚本包内相同相对路径（必要时创建父目录）。
- 若脚本仅需网络 API、无本地文件，使用 `"resources": []` 或省略 `resources`。

### 3.3 `meta.json` 示例

```json
{
  "id": "hello-store",
  "name": "Hello Store",
  "description": "Minimal sample widget to verify Store install from GitHub.",
  "author": "ScriptWidget",
  "category": "utility",
  "platforms": ["ios", "macos"],
  "version": "1.0.0",
  "widget_sizes": ["small", "medium"],
  "tags": ["sample", "store"],
  "screenshots": ["screenshots/small.png"],
  "resources": [],
  "created_at": "2026-05-16",
  "updated_at": "2026-05-16"
}
```

---

## 四、Raw URL 与客户端配置

应用默认从以下模式拼接 URL（具体 owner/repo/branch 见 iOS 工程内 `StoreRemoteConfig`）：

```
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/store/index.json
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/store/scripts/<id>/main.jsx
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/store/scripts/<id>/meta.json
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/store/scripts/<id>/<resources 或 screenshots 中的相对路径>
```

在官方仓库合并到 `main` 前，若要在本地构建的应用中测试自己的 fork，需将 `StoreRemoteConfig` 中的 base URL 改为对应 fork 与分支。

---

## 五、新增脚本的检查清单（贡献 / AI 生成后自检）

1. 新建 `store/scripts/<id>/`，且 `<id>` 与 `meta.json` 的 `id`、`index.json` 条目的 `id` 三者相同。  
2. 放置 `main.jsx`、`meta.json`、`screenshots/`（至少一张图）。  
3. 若有随包安装的资源：放入对应子路径，并在 `meta.json` 的 `resources` 中**逐项列出**；`has_resources` 与 `index.json` 保持一致。  
4. 在 `store/index.json` 的 `scripts` 数组中增加一条，字段与 `meta.json` 对齐，并尽量填写 `preview_screenshot`。  
5. 打开 Pull Request。

---

## 六、给 AI 的简要规则摘要

生成或修改 Store 数据时：

- 使用 **snake_case** JSON 键名，与上表一致。  
- `id` 贯穿目录名、`index.json`、`meta.json`，必须一致。  
- `screenshots` 仅用于商店展示；**安装**只包含 `main.jsx` + `resources` 中的文件。  
- `platforms` 使用 `ios` / `macos` 小写字符串数组。  
- 所有相对路径均相对于 `store/scripts/<id>/`。

应用侧解码类型定义见：`iOS/ScriptWidget/App/Store/StoreModels.swift`（字段与上表一一对应，解码时使用 `convertFromSnakeCase`）。
