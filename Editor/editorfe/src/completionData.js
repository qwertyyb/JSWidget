/** Auto-generated from docs/dts/ by Tools/completion-gen/generate.mjs — do not edit by hand */

export const jsxTags = [
  "row",
  "col",
  "stack",
  "grid",
  "grid-row",
  "text",
  "date",
  "image",
  "gif",
  "spacer",
  "chart",
  "link",
  "divider",
  "icon",
  "label",
  "progress",
  "button",
  "toggle",
  "ring",
  "badge",
  "chip",
  "stat",
  "roundedrect",
  "line",
  "rect",
  "capsule",
  "ellipse",
  "circle",
  "gauge"
];

export const commonAttributes = [
  {
    "name": "size",
    "info": "尺寸（\"max\" 或 {width, height}）"
  },
  {
    "name": "justify",
    "info": "内容/子组件的水平对齐方式，需配合 size 使用。\n对 hstack：控制子元素组在主轴（水平）上的位置。\n对 vstack：控制子元素在交叉轴（水平）上的对齐（通过构造器生效，不依赖 size）。\n对 zstack：控制子元素水平堆叠锚点（通过构造器生效，不依赖 size）。\n对其他组件：在 size 指定的空间内水平定位内容。",
    "values": [
      "start",
      "center",
      "end"
    ]
  },
  {
    "name": "align",
    "info": "内容/子组件的垂直对齐方式，需配合 size 使用。\n对 vstack：控制子元素组在主轴（垂直）上的位置。\n对 hstack：控制子元素在交叉轴（垂直）上的对齐（通过构造器生效，不依赖 size）。\n对 zstack：控制子元素垂直堆叠锚点（通过构造器生效，不依赖 size）。\n对其他组件：在 size 指定的空间内垂直定位内容。",
    "values": [
      "start",
      "center",
      "end"
    ]
  },
  {
    "name": "padding",
    "info": "内边距（数字或 {horizontal, vertical, top, bottom, leading, trailing, left, right}）"
  },
  {
    "name": "backgroundColor",
    "info": "背景色"
  },
  {
    "name": "foregroundColor",
    "info": "前景色"
  },
  {
    "name": "cornerRadius",
    "info": "圆角"
  },
  {
    "name": "opacity",
    "info": "透明度 0-1"
  },
  {
    "name": "rotationEffect",
    "info": "旋转角度"
  },
  {
    "name": "scaleEffect",
    "info": "缩放"
  },
  {
    "name": "offset",
    "info": "偏移"
  },
  {
    "name": "shadow",
    "info": "阴影"
  },
  {
    "name": "blur",
    "info": "模糊"
  },
  {
    "name": "animation",
    "info": "动画名"
  }
];

export const tagAttributes = {
  "row": [
    {
      "name": "spacing",
      "info": "水平间距"
    }
  ],
  "col": [
    {
      "name": "spacing",
      "info": "垂直间距"
    }
  ],
  "stack": [],
  "grid": [
    {
      "name": "rows",
      "info": "行配置 JSON 字符串"
    },
    {
      "name": "columns",
      "info": "列数"
    },
    {
      "name": "spacing",
      "info": "间距"
    }
  ],
  "grid-row": [
    {
      "name": "align",
      "info": "垂直对齐",
      "values": [
        "start",
        "end",
        "center",
        "firstBaseline",
        "lastBaseline"
      ]
    },
    {
      "name": "rows",
      "info": "行数"
    },
    {
      "name": "columns",
      "info": "列配置 JSON 字符串"
    },
    {
      "name": "spacing",
      "info": "间距"
    }
  ],
  "text": [
    {
      "name": "font",
      "info": "字体：语义名 / 数字字号 / {name,weight,design,size} / {custom,size}"
    },
    {
      "name": "color",
      "info": "文字颜色"
    },
    {
      "name": "textAlign",
      "info": "多行文本内部每一行的水平对齐方式。\n仅影响文本框内各行文字的排列，不改变组件盒子本身的位置。\n与 justify 的区别：justify 移动的是整个组件盒子，textAlign 对齐的是盒子内的文字行。\n两者可组合使用，例如 justify=\"start\" + textAlign=\"center\" 表示组件靠左、内部文字居中。\nleft 为 start 的别名，right 为 end 的别名。",
      "values": [
        "start",
        "center",
        "end",
        "left",
        "right"
      ]
    },
    {
      "name": "lineLimit",
      "info": "行数限制"
    }
  ],
  "date": [
    {
      "name": "style",
      "info": "显示样式",
      "values": [
        "date",
        "time",
        "relative",
        "offset",
        "timer"
      ]
    },
    {
      "name": "font",
      "info": "字体：语义名 / 数字字号 / {name,weight,design,size} / {custom,size}"
    },
    {
      "name": "color",
      "info": "文字颜色"
    },
    {
      "name": "textAlign",
      "info": "多行文本内部每一行的水平对齐方式。\n仅影响文本框内各行文字的排列，不改变组件盒子本身的位置。\n与 justify 的区别：justify 移动的是整个组件盒子，textAlign 对齐的是盒子内的文字行。\n两者可组合使用，例如 justify=\"start\" + textAlign=\"center\" 表示组件靠左、内部文字居中。\nleft 为 start 的别名，right 为 end 的别名。",
      "values": [
        "start",
        "center",
        "end",
        "left",
        "right"
      ]
    },
    {
      "name": "lineLimit",
      "info": "行数限制"
    }
  ],
  "image": [
    {
      "name": "name",
      "info": "包内 image/ 目录下的图片名（读取 image/{name}.png）"
    },
    {
      "name": "filePath",
      "info": "相对于脚本目录的图片路径，支持任意图片格式"
    },
    {
      "name": "url",
      "info": "网络 URL"
    },
    {
      "name": "ratio",
      "info": "宽高比"
    },
    {
      "name": "mode",
      "info": "显示模式：`fit` 或 `fill`",
      "values": [
        "fit",
        "fill"
      ]
    },
    {
      "name": "font",
      "info": "仅 systemName 时生效（控制 SF Symbol 大小）"
    }
  ],
  "gif": [
    {
      "name": "file",
      "info": "GIF 文件名。可以是包含扩展名的完整名称（如 \"cat.gif\"），也可以是不含扩展名的裸名称（如 \"cat\"，会自动补 .gif）。文件需放在脚本包的 images 目录下"
    },
    {
      "name": "ratio",
      "info": "宽高比"
    },
    {
      "name": "mode",
      "info": "显示模式：`fit` 或 `fill`",
      "values": [
        "fit",
        "fill"
      ]
    }
  ],
  "spacer": [
    {
      "name": "length",
      "info": "最小占用长度"
    }
  ],
  "chart": [
    {
      "name": "data",
      "info": "图表数据数组"
    },
    {
      "name": "type",
      "info": "图表类型，默认 `bar`。\n`bar-gantt` 数据项为 `JSWidgetChartGanttDataItem`；\n`rule-x` 为 `JSWidgetChartRuleDataItem`；\n其余为 `JSWidgetChartDataItem`。",
      "values": [
        "bar",
        "bar-x",
        "bar-y",
        "bar-gantt",
        "line",
        "point",
        "line-point",
        "area",
        "rect",
        "rule-x"
      ]
    },
    {
      "name": "category",
      "info": "是否按数据项 `category` 字段分色（默认 false）"
    },
    {
      "name": "hideLegend",
      "info": "是否隐藏图例"
    },
    {
      "name": "hideXAxis",
      "info": "是否隐藏 X 轴"
    },
    {
      "name": "hideYAxis",
      "info": "是否隐藏 Y 轴"
    },
    {
      "name": "color",
      "info": "前景色"
    }
  ],
  "link": [
    {
      "name": "url",
      "info": "链接地址"
    }
  ],
  "divider": [
    {
      "name": "thickness",
      "info": "线宽（默认 1）"
    },
    {
      "name": "axis",
      "info": "方向",
      "values": [
        "horizontal",
        "vertical"
      ]
    },
    {
      "name": "color",
      "info": "颜色"
    }
  ],
  "icon": [
    {
      "name": "systemName",
      "info": "SF Symbol 名"
    },
    {
      "name": "size",
      "info": "图标大小"
    },
    {
      "name": "color",
      "info": "颜色"
    },
    {
      "name": "font",
      "info": "字体：语义名 / 数字字号 / {name,weight,design,size} / {custom,size}"
    }
  ],
  "label": [
    {
      "name": "title"
    },
    {
      "name": "systemName"
    },
    {
      "name": "color"
    },
    {
      "name": "font"
    }
  ],
  "progress": [
    {
      "name": "value",
      "info": "当前值（与 total 一起决定进度，默认 0）"
    },
    {
      "name": "total",
      "info": "总值（默认 1）"
    },
    {
      "name": "label",
      "info": "进度条旁/上的说明文字"
    },
    {
      "name": "style",
      "info": "linear（默认）| circular",
      "values": [
        "linear",
        "circular"
      ]
    },
    {
      "name": "color",
      "info": "进度条着色"
    },
    {
      "name": "trackColor",
      "info": "轨道/背景色（设置后使用自定义绘制，默认 `#e2e8f0`）"
    },
    {
      "name": "font",
      "info": "label 的字体"
    }
  ],
  "button": [
    {
      "name": "action",
      "info": "预定义动作，目前仅支持 \"reload\""
    },
    {
      "name": "onClick",
      "info": "点击时调用的 JS 函数名"
    }
  ],
  "toggle": [
    {
      "name": "on",
      "info": "开关是否开启，默认 false"
    },
    {
      "name": "onClick",
      "info": "切换时调用的 JS 函数名"
    }
  ],
  "ring": [
    {
      "name": "value",
      "info": "当前值（0–1）"
    },
    {
      "name": "thickness",
      "info": "圆环粗细（默认 8）"
    },
    {
      "name": "color",
      "info": "进度颜色（默认 `#3b82f6`）"
    },
    {
      "name": "trackColor",
      "info": "轨道颜色（默认 `#e2e8f0`）"
    }
  ],
  "badge": [
    {
      "name": "text",
      "info": "徽章文本"
    },
    {
      "name": "radius",
      "info": "圆角半径（默认 6）"
    },
    {
      "name": "backgroundColor",
      "info": "背景色（默认 `#0f172a`）"
    },
    {
      "name": "color",
      "info": "文字颜色（默认 `#e2e8f0`）"
    }
  ],
  "chip": [
    {
      "name": "text",
      "info": "标签文本"
    },
    {
      "name": "radius",
      "info": "圆角半径（默认 14）"
    },
    {
      "name": "backgroundColor",
      "info": "背景色（无则使用默认）"
    },
    {
      "name": "borderColor",
      "info": "边框颜色（默认 `#cbd5f5`）"
    },
    {
      "name": "color",
      "info": "文字颜色（默认 `#0f172a`）"
    }
  ],
  "stat": [
    {
      "name": "title",
      "info": "标题（默认 `Title`）"
    },
    {
      "name": "value",
      "info": "数值（默认 `0`）"
    },
    {
      "name": "subtitle",
      "info": "副标题"
    },
    {
      "name": "color",
      "info": "数值颜色（默认 `#0f172a`）"
    },
    {
      "name": "mutedColor",
      "info": "辅助文字颜色（默认 `#64748b`）"
    }
  ],
  "roundedrect": [
    {
      "name": "radius",
      "info": "圆角半径（默认 6）"
    },
    {
      "name": "color",
      "info": "颜色"
    }
  ],
  "line": [
    {
      "name": "thickness",
      "info": "线宽（默认 2）"
    },
    {
      "name": "length",
      "info": "长度（默认 48）"
    },
    {
      "name": "axis",
      "info": "方向",
      "values": [
        "horizontal",
        "vertical"
      ]
    },
    {
      "name": "color",
      "info": "颜色"
    }
  ],
  "rect": [
    {
      "name": "cornerRadius"
    }
  ],
  "capsule": [],
  "ellipse": [],
  "circle": [],
  "gauge": []
};

export const apis = [
  {
    "name": "$http",
    "methods": [
      "get",
      "post",
      "put",
      "patch",
      "delete"
    ]
  },
  {
    "name": "$fetch",
    "methods": []
  },
  {
    "name": "fetch",
    "methods": []
  },
  {
    "name": "$console",
    "methods": [
      "log",
      "info",
      "warn",
      "error"
    ]
  },
  {
    "name": "console",
    "methods": [
      "log",
      "info",
      "warn",
      "error"
    ]
  },
  {
    "name": "$device",
    "methods": [
      "name",
      "model",
      "language",
      "systemVersion",
      "screen",
      "battery",
      "isdarkmode",
      "totalDiskSpace",
      "freeDiskSpace"
    ]
  },
  {
    "name": "$file",
    "methods": [
      "readString",
      "writeString",
      "remove",
      "list"
    ]
  },
  {
    "name": "$system",
    "methods": [
      "appInfo",
      "locale",
      "preferredLanguages",
      "timeZone",
      "is24HourClock",
      "calendarInfo",
      "systemUptime",
      "memory",
      "thermalState",
      "lowPowerMode",
      "brightness",
      "reduceMotionEnabled",
      "platform",
      "hostName",
      "processName",
      "osVersionString",
      "processorCount",
      "activeProcessorCount"
    ]
  },
  {
    "name": "$health",
    "methods": [
      "isAvailable",
      "requestAuthorization",
      "stepCountToday",
      "activeEnergyToday",
      "heartRateLatest"
    ]
  },
  {
    "name": "$location",
    "methods": [
      "isAvailable",
      "authorizationStatus",
      "requestAuthorization",
      "current"
    ]
  },
  {
    "name": "$storage",
    "methods": [
      "getString",
      "setString",
      "getJSON",
      "setJSON",
      "remove",
      "keys",
      "clear"
    ]
  },
  {
    "name": "$getenv",
    "methods": []
  },
  {
    "name": "$import",
    "methods": []
  },
  {
    "name": "$render",
    "methods": []
  },
  {
    "name": "$dynamic_island",
    "methods": []
  },
  {
    "name": "$element",
    "methods": [
      "createElement"
    ]
  },
  {
    "name": "$component",
    "methods": []
  },
  {
    "name": "$error",
    "methods": []
  }
];
