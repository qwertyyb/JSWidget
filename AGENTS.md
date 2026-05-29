# Repository Guidelines

## Project Structure & Module Organization
- `Shared/ScriptWidgetRuntime/`: core Swift runtime (JavaScriptCore host, JSX → SwiftUI rendering, helper APIs).
- `iOS/ScriptWidget*`: iOS app, widget, and share extension sources (SwiftUI views under `View/`, managers under `Manager/`).
- `macOS/ScriptWidgetMac*`: macOS app + widget targets reusing the shared runtime.
- `Editor/editorfe/`: React 17 + CodeMirror 6 editor frontend (CRA).
- `Resource/`: marketing assets, screenshots, icons.
- `docs/`: VitePress 文档源（`srcDir`），**仅面向应用用户**；含 `guide/`、`api/index.md`、`components/index.md`、`public/editor/` 等。贡献者开发流程见根目录 [`DEVELOPMENT.md`](DEVELOPMENT.md)。
- `.vitepress/`: 文档站配置（根目录）；`pnpm docs:dev` / `pnpm docs:build` 在仓库根目录执行。
- `docs/dts/`: **source of truth** for widget/API TypeScript contracts (`types.d.ts`, `api.d.ts`, `components.d.ts`). After edits, run `cd Tools/completion-gen && pnpm generate`. See [`DEVELOPMENT.md`](DEVELOPMENT.md).
- `Scripts/<PackageName>/main.jsx`: runtime widget packages (synced via iCloud/app group); build artifacts land in `__Build/`.

## Build, Test, and Development Commands
- `open iOS/ScriptWidget.xcodeproj` and `open macOS/ScriptWidgetMac.xcodeproj`: build/run in Xcode (schemes: `ScriptWidget`, `ScriptWidgetWidget`, `ScriptWidgetShare`, `ScriptWidgetMac`, `ScriptWidgetMacWidget`).
- **Package manager**: use **pnpm** (not npm/yarn). Each JS sub-project enforces this via `only-allow pnpm` preinstall hook.
- `cd Editor/editorfe && pnpm install`: install editor dependencies.
- `pnpm start`: run the editor dev server at `http://localhost:3000`.
- `pnpm test`: run editor tests (react-scripts).
- `pnpm run build`: 直接把编辑器静态产物写入 `iOS/ScriptWidget/View/CodeEditor/MirrorEditor/MirrorEditor.bundle/build/`（通过 `BUILD_PATH`），Xcode 构建时会随该 bundle 一起打包，无需再手动复制。
- `pnpm install` (repo root): install workspace dependencies (`Tools/jsx-compiler`, `Tools/completion-gen`, etc.).
- `pnpm build:jsx-compiler`: bundle JSX compiler and copy to `Shared/ScriptWidgetRuntime/Widget/Resource/support.bundle/jsx-compiler.js`.
- `pnpm --filter jsx-compiler test`: run JSX compiler tests (`Tools/jsx-compiler/test.mjs`).
- `pnpm generate:completion`: regenerate `completionData.js` and `docs/public/editor/jswidget.d.ts` from `docs/dts/`.
- `pnpm build:tools`: run both `build:jsx-compiler` and `generate:completion`.
- `pnpm docs:dev` / `pnpm docs:build`: build or preview the VitePress site (requires `pnpm install` at repo root).
- When running iOS/macOS targets, enable the `iCloud.JSWidget` container and `group.qwertyyb.jswidget` app group so script storage works.
- The GitHub repository is at `https://github.com/qwertyyb/JSWidget`.

## Coding Style & Naming Conventions
- Swift: 4-space indentation, Xcode defaults, `UpperCamelCase` for types, `lowerCamelCase` for methods/vars. Keep SwiftUI views in `View/` and managers in `Manager/`.
- JavaScript/React: 2-space indentation (match existing files), `UpperCamelCase` for components, `lowerCamelCase` for functions. Prettier is available but not wired; avoid broad reformatting.
- Runtime scripts: packages live under `Scripts/<PackageName>/` with `main.jsx` entrypoint.

## Testing Guidelines
- Editor: `pnpm test` (Jest via react-scripts + Testing Library). Add tests next to related components when feasible.
- Swift: no dedicated unit-test target yet; validate by running the iOS/macOS app and widget schemes. Smoke-test Live Activity/Dynamic Island rendering and iCloud migration paths when touching runtime or storage.

## Commit & Pull Request Guidelines
- History shows short, informal summaries (often lowercase) and merge commits; no strict convention. Use concise, action-oriented summaries and add a short body when context helps.
- PRs should include: a clear description, linked issue (if applicable), and screenshots for UI changes. Note which schemes/commands you ran (e.g., `JSWidgetWidget`, `pnpm test`).
