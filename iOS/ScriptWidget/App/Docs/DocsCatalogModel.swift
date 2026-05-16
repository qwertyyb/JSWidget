//
//  DocsCatalogModel.swift
//  ScriptWidget
//

import Foundation

struct DocItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let file: String
    let anchor: String?

    init(title: String, icon: String, file: String, anchor: String? = nil) {
        self.title = title
        self.icon = icon
        self.file = file
        self.anchor = anchor
    }
}

struct DocSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [DocItem]
}

enum DocsCatalog {
    static let sections: [DocSection] = [
        DocSection(title: "Getting Started", items: [
            DocItem(title: "Quick Start", icon: "sparkles", file: "getting-started.md"),
        ]),
        DocSection(title: "AI", items: [
            DocItem(title: "AI Guide", icon: "wand.and.stars", file: "ai.md"),
        ]),
        DocSection(title: "Components", items: [
            DocItem(title: "All Components", icon: "square.stack.3d.up", file: "components.md"),
            DocItem(title: "Layout Containers", icon: "rectangle.split.3x1", file: "components.md", anchor: "布局容器"),
            DocItem(title: "Text Elements", icon: "textformat", file: "components.md", anchor: "文本元素"),
            DocItem(title: "Image & Media", icon: "photo", file: "components.md", anchor: "图片与媒体"),
            DocItem(title: "Interactive Elements", icon: "hand.tap", file: "components.md", anchor: "交互元素"),
            DocItem(title: "Charts", icon: "chart.bar", file: "components.md", anchor: "图表"),
            DocItem(title: "Shapes", icon: "circle", file: "components.md", anchor: "形状"),
            DocItem(title: "Extra Components", icon: "puzzlepiece", file: "components.md", anchor: "扩展组件"),
            DocItem(title: "Common Attributes", icon: "slider.horizontal.3", file: "components.md", anchor: "通用属性"),
        ]),
        DocSection(title: "APIs", items: [
            DocItem(title: "All APIs", icon: "book", file: "api.md"),
            DocItem(title: "HTTP Requests", icon: "network", file: "api.md", anchor: "1-http-请求-api"),
            DocItem(title: "Console", icon: "terminal", file: "api.md", anchor: "2-控制台-api"),
            DocItem(title: "Device Info", icon: "iphone", file: "api.md", anchor: "3-设备信息-api"),
            DocItem(title: "File Operations", icon: "folder", file: "api.md", anchor: "4-文件操作-api"),
            DocItem(title: "System Info", icon: "cpu", file: "api.md", anchor: "5-系统信息-api"),
            DocItem(title: "Health Data", icon: "heart", file: "api.md", anchor: "6-健康数据-api"),
            DocItem(title: "Location", icon: "location", file: "api.md", anchor: "7-位置服务-api"),
            DocItem(title: "Storage", icon: "externaldrive", file: "api.md", anchor: "8-本地存储-api"),
            DocItem(title: "Environment", icon: "gear", file: "api.md", anchor: "9-环境变量-api"),
            DocItem(title: "Import", icon: "arrow.down.circle", file: "api.md", anchor: "10-文件导入-api"),
            DocItem(title: "Render", icon: "paintbrush", file: "api.md", anchor: "11-渲染-api"),
            DocItem(title: "Dynamic Island", icon: "circle.dotted", file: "api.md", anchor: "12-灵动岛-api"),
        ]),
    ]
}
