# OpenCode 模型选择指南

## 在 TUI 中选择（推荐）

启动 OpenCode 后：
```bash
opencode
```

### 方法 1：命令面板
1. 按 `/` 打开命令面板
2. 输入 `model`
3. 从列表中选择模型

### 方法 2：快捷键（根据 config）
按 `Ctrl+M` 显示模型列表

### 方法 3：按 Tab 键
有些版本可以按 `Tab` 在不同模型/Agent 之间切换

---

## 查看可用模型
```bash
opencode models
# 或
opencode models nvidia    # 只看 NVIDIA 提供商的模型
```

---

## 命令行指定模型
```bash
opencode -m nvidia/z-ai/glm4.7
```

或在 `run` 命令中：
```bash
opencode run "你的任务" -m nvidia/z-ai/glm4.7
```

---

## 快捷键参考（根据您的配置）

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+M` | 显示模型列表 |
| `Ctrl+A` | 显示提供商列表 |
| `F2` | 循环最近使用的模型 |
| `Shift+F2` | 反向循环 |
| `/` | 命令面板（输入 `model`） |

---

## 推荐的 NVIDIA 模型

- `nvidia/z-ai/glm4.7` - 高性能大模型
- `nvidia/z-ai/glm5` - 最新版本
- `nvidia/nvidia/nemotron-4-340b-instruct` - 超大规模（340B）
- `nvidia/qwen/qwen2.5-coder-7b-instruct` - 代码专用
