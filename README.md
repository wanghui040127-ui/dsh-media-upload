# DSH Media Upload

一个让 DeepSeek Harness 支持**上传图片和 PDF 文件**的补丁包。

DeepSeek Harness 默认只允许上传 png/jpeg/webp/gif 图片，本补丁扩展了上传类型校验，支持 PDF 及其他图片格式（bmp/tiff/svg 等），并让模型能识别 PDF 内容。

## 原理

本补丁通过替换 Harness 应用包内的 4 个宿主模块文件实现（不是标准插件，无法从插件市场安装）：

| 应用包内模块文件 | 作用 |
|---|---|
| `@deepseek-ai/dsh-host-apiproxy/lib/index.js` | 上传文件类型校验 |
| `@deepseek-ai/dsh-attachment-local/lib/index.js` | 媒体类型与大小限制 |
| `@deepseek-ai/dsh-llm-deepseek/lib/index.js` | 附件转文本占位符 |
| `@deepseek-ai/dsh-client-ui-conversation/lib/client.js` | 前端附件类型映射 |

## 一键安装

```bash
# 默认路径（$HOME/Desktop/DeepSeek-Harness-极简版/DeepSeek Harness.app）
./install.sh

# 或指定应用路径
./install.sh "/path/to/DeepSeek Harness.app"
```

安装完成后**退出并重新打开 DeepSeek Harness**，然后在对话中上传图片或 PDF 即可。

## 卸载

```bash
./uninstall.sh
```

卸载脚本会从 `*.bak` 备份恢复原始文件，返回默认行为。

## 文件结构

```
dsh-media-upload/
├── install.sh                 # 一键安装脚本
├── uninstall.sh               # 卸载脚本（恢复备份）
├── README.md                  # 本说明
└── packages/                  # 补丁文件（按目标模块路径组织）
    ├── dsh-host-apiproxy/lib/index.js
    ├── dsh-attachment-local/lib/index.js
    ├── dsh-llm-deepseek/lib/index.js
    └── dsh-client-ui-conversation/lib/client.js
```

## 注意事项

- 本补丁直接修改应用包内文件，**Harness 更新后可能被覆盖**，需要重新运行 `install.sh`。
- 安装时应用需处于关闭或可写状态。
- 原始文件会备份为 `<文件>.bak`，卸载时自动恢复。