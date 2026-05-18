---
name: jswidget-script-gen
description: >-
  Generate JSWidget (iOS/macOS widget) JSX scripts. Use when the user asks to
  create, write, or generate a widget script, main.jsx, or mentions JSWidget,
  $render, $dynamic_island, or widget JSX code.
---

# JSWidget Script Generator

Generate `main.jsx` scripts for JSWidget — an iOS/macOS widget runtime
powered by JavaScript and JSX.

## Core Rules

1. Entry script uses **top-level code** with top-level `await`.
2. Desktop widgets call **`$render(<jsx>)`**; Dynamic Island uses **`$dynamic_island(config)`** — never mix them.
3. JSX tags are **lowercase** (`row`, `col`, `text`, `image`, etc.) — never use HTML/React DOM tags.
4. Function components must be **synchronous**. Fetch async data outside, pass via props.
5. Color format: named (`"red"`), hex (`"#ff0000"`), `rgb()`/`rgba()`.
6. Use `$getenv("widget-size")` for responsive layout (`"small"` | `"medium"` | `"large"` …).

## Output Template

When generating a script, output:

1. **Brief implementation notes** (2-3 sentences).
2. **Complete `main.jsx`** ready to paste into JSWidget.

## Quick Reference

### Layout

| Tag       | Purpose        | Key Props                |
|-----------|----------------|--------------------------|
| `col`     | Vertical stack | `spacing`, `align`, `justify` |
| `row`     | Horizontal stack | `spacing`, `justify` (no `align`) |
| `stack`   | Z-axis overlay | —                        |
| `spacer`  | Flexible space | `length`                 |
| `grid`    | Grid layout    | `columns`, `rows`, `spacing` |

### Content

| Tag       | Purpose         | Key Props                       |
|-----------|-----------------|---------------------------------|
| `text`    | Text            | `font`, `color`, `lineLimit`, `textAlign` |
| `date`    | Live date/time  | `style` (`date`/`time`/`relative`/`timer`) |
| `image`   | Image           | `url`, `name`, `filePath`, `mode`, `ratio` |
| `icon`    | SF Symbol       | `systemName`, `size`, `color`   |

### Interaction

| Tag       | Purpose   | Key Props                     |
|-----------|-----------|-------------------------------|
| `button`  | Button    | `action="reload"` or `onClick` |
| `toggle`  | Switch    | `on`, `onClick`               |
| `link`    | Tap link  | `url` (required)              |

### Data Display

| Tag        | Purpose        | Key Props                              |
|------------|----------------|----------------------------------------|
| `chart`    | Swift Charts   | `data`, `type`, `category`, `color`    |
| `progress` | Progress bar   | `value`, `total`, `style`, `color`     |
| `ring`     | Ring progress  | `value`, `thickness`, `color`          |
| `gauge`    | Gauge          | `type` (`original`/`system`), `value`  |
| `stat`     | Stat card      | `title`, `value`, `subtitle`           |

### Shape / Decoration

`rect`, `roundedrect`, `capsule`, `ellipse`, `circle`, `line`, `divider`,
`badge`, `chip`

### Common Attributes (most tags)

`size`, `padding`, `backgroundColor`, `foregroundColor`, `cornerRadius`,
`opacity`, `rotationEffect`, `scaleEffect`, `offset`, `shadow`, `blur`

### Global APIs

| API            | Purpose                 |
|----------------|-------------------------|
| `$http`        | HTTP requests (get/post/put/patch/delete) |
| `fetch`        | Shorthand GET           |
| `$storage`     | Local persistence       |
| `$getenv(key)` | Runtime env vars        |
| `$device`      | Device info             |
| `$system`      | System info             |
| `$file`        | Read/write package files|
| `$health`      | HealthKit (iOS)         |
| `$location`    | Location (iOS)          |
| `$import`      | Import .js/.jsx files   |
| `console`      | Logging                 |

## Detailed References

For full component props and API signatures, read these files:

- [Components reference](references/components/index.md) — all JSX elements and attributes
- [API reference](references/api/index.md) — all runtime APIs with signatures and examples

Read them **before** generating any non-trivial script.

## Example: Data-Fetching Widget

```jsx
const res = await $http.get("https://api.example.com/weather");
const weather = JSON.parse(res);
const size = $getenv("widget-size");

$render(
  <col size="max" padding={16} spacing={8}>
    <row>
      <icon systemName="cloud.sun.fill" size={24} color="#f59e0b" />
      <text font="headline" color="#0f172a">{weather.city}</text>
      <spacer />
      <text font="caption" color="#64748b">{weather.time}</text>
    </row>
    <text font={{ name: "title", weight: "bold" }} color="#0f172a">
      {weather.temp}°C
    </text>
    {size !== "small" && (
      <chart
        type="line"
        data={weather.hourly.map((h) => ({ label: h.hour, value: h.temp }))}
        hideXAxis
        hideYAxis
        color="#3b82f6"
      />
    )}
  </col>
);
```

## Example: Simple Static Widget

```jsx
$render(
  <col size="max" padding={16}>
    <text font="title" color="#0f172a">Hello World</text>
    <spacer />
    <text font="caption" color="#64748b">Built with JSWidget</text>
  </col>
);
```

## Checklist Before Output

- [ ] Only used documented tags and APIs
- [ ] `$render` or `$dynamic_island` called exactly once
- [ ] Async data fetched at top level, not inside function components
- [ ] Responsive layout via `$getenv("widget-size")` if relevant
- [ ] Error handling with try/catch + `$storage` cache fallback for network calls
