import { defineConfig } from 'vitepress'
import { execSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'

function env(name: string): string | undefined {
  const proc = (globalThis as unknown as { process?: { env?: Record<string, string | undefined> } })
    .process
  return proc?.env?.[name]
}

/** GitHub project pages are served at /<repo>/; user/org root sites use repo named *.github.io (base "/"). */
function resolveBase(): string {
  const explicit = env('VITEPRESS_BASE')?.trim()
  if (explicit) {
    if (explicit === '' || explicit === '/') return '/'
    const withTrailing = explicit.endsWith('/') ? explicit : `${explicit}/`
    return withTrailing.startsWith('/') ? withTrailing : `/${withTrailing}`
  }
  const repo = env('GITHUB_REPOSITORY')?.split('/')?.[1]
  if (!repo) return '/'
  if (repo.toLowerCase().endsWith('.github.io')) return '/'
  return `/${repo}/`
}

const docsDir = fileURLToPath(new URL('../docs', import.meta.url))

export default defineConfig({
  base: resolveBase(),
  vite: {
    plugins: [{
      name: 'gen-skill',
      async buildStart() {
        execSync('node Tools/gen-skill.mjs', { cwd: fileURLToPath(new URL('..', import.meta.url)), stdio: 'inherit' })
      },
    }],
  },
  markdown: {
    config: (md) => {
      // Escape {{ and }} in inline code to prevent Vue template processing
      const defaultCodeInline = md.renderer.rules.code_inline
      md.renderer.rules.code_inline = (tokens, idx, options, env, self) => {
        const rendered = defaultCodeInline
          ? defaultCodeInline(tokens, idx, options, env, self)
          : self.renderToken(tokens, idx, options)
        return rendered
          .replace(/\{\{/g, '&#123;&#123;')
          .replace(/\}\}/g, '&#125;&#125;')
      }
    },
  },
  srcDir: docsDir,
  srcExclude: ['**/plans/**', '**/todo/**', '**/dts/**', '**/jswidget-script-gen/**'],

  title: 'JSWidget',
  description: 'Create native widgets for iOS & macOS using JavaScript and JSX',
  lang: 'zh-CN',

  themeConfig: {
    nav: [
      { text: '快速入门', link: '/guide/getting-started' },
      { text: 'AI 指南', link: '/guide/ai' },
      { text: '远程编辑器', link: '/editor/index.html', target: '_self' },
      { text: '组件', link: '/components' },
      { text: 'API', link: '/api' },
      {
        text: 'GitHub',
        link: 'https://github.com/qwertyyb/JSWidget',
      },
    ],

    sidebar: {
      '/guide/': [
        {
          text: '指南',
          items: [
            { text: '快速入门', link: '/guide/getting-started' },
            { text: 'AI 使用指南', link: '/guide/ai' },
          ],
        },
      ],
      '/components/': [
        {
          text: '组件文档',
          items: [
            { text: '概览', link: '/components' },
            { text: '布局容器', link: '/components#布局容器' },
            { text: '文本元素', link: '/components#文本元素' },
            { text: '图片与媒体', link: '/components#图片与媒体' },
            { text: '交互元素', link: '/components/#交互元素' },
            { text: '图表', link: '/components/#图表' },
            { text: '形状', link: '/components/#形状' },
            { text: '扩展组件', link: '/components/#扩展组件' },
            { text: '通用属性', link: '/components/#通用属性' },
            { text: '颜色格式', link: '/components/#颜色格式' },
          ],
        },
      ],
      '/api/': [
        {
          text: 'API 文档',
          items: [
            { text: '概览', link: '/api/' },
            { text: 'HTTP 请求', link: '/api/#_1-http-请求-api' },
            { text: '控制台', link: '/api/#_2-控制台-api' },
            { text: '设备信息', link: '/api/#_3-设备信息-api' },
            { text: '文件操作', link: '/api/#_4-文件操作-api' },
            { text: '系统信息', link: '/api/#_5-系统信息-api' },
            { text: '健康数据', link: '/api/#_6-健康数据-api' },
            { text: '位置服务', link: '/api/#_7-位置服务-api' },
            { text: '本地存储', link: '/api/#_8-本地存储-api' },
            { text: '环境变量', link: '/api/#_9-环境变量-api' },
            { text: '文件导入', link: '/api/#_10-文件导入-api' },
            { text: '渲染', link: '/api/#_11-渲染-api' },
            { text: '灵动岛', link: '/api/#_12-灵动岛-api' },
            { text: '组件定义', link: '/api/#_13-组件定义-api' },
          ],
        },
      ],
    },

    search: {
      provider: 'local',
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/qwertyyb/JSWidget' },
    ],

    footer: {
      message: 'Released under the MIT License.',
    },
  },
})
