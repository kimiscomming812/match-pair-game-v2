# OpenCode NVIDIA NIM 配置深入研究

## 问题诊断

### 症状
OpenCode 非交互模式（`-p`）硬编码使用 `https://api.openai.com/v1`，忽略配置文件中的 `baseURL` 设置。

### 已尝试的配置位置（全部无效）
1. `~/.config/opencode/opencode.json`
2. `~/opencode.json`
3. 项目目录 `opencode.json`
4. 环境变量 `OPENAI_BASE_URL`
5. OpenCode 内置配置系统
6. Provider 配置对象

### 源码分析结论
- `config.ts`: 配置文件搜索逻辑正确
- `provider.ts`: 支持自定义提供商配置
- **问题**: 非交互模式可能有限制或有 bug

---

## 深入研究方向

### 方向 1: @ai-sdk/openai 包行为研究

**目标**: 找到 AI SDK 如何处理 baseURL 的逻辑

**步骤**:
1. 在 OpenCode 缓存目录中查找 SDK:
   ```bash
   ls -la ~/.cache/opencode/node_modules/@ai-sdk/openai/
   ```

2. 读取 SDK 源码:
   ```bash
   cd ~/.cache/opencode/node_modules/@ai-sdk/openai/
   find . -name "*.ts" -o -name "*.js" | xargs grep -l "baseURL"
   ```

3. 分析 `createOpenAI` 或类似函数的实现

---

### 方向 2: 环境变量完整列表

**目标**: 找到所有可能影响提供商配置的环境变量

**步骤**:
1. 搜索 OpenCode 源码中 `process.env` 的使用:
   ```bash
   cd /tmp/opencode-0.0.55
   grep -rn "process.env" packages/opencode/src/
   ```

2. 检查 AI SDK 文档中关于环境变量的说明

---

### 方向 3: 创建自定义 Provider

**目标**: 通过 OpenCode 的 Provider API 创建 NVIDIA 提供商

**思路**:
根据源码 `provider.ts`，可以尝试：

1. 创建一个本地 npm 包: `@ai-sdk/nvidia`

2. 在该包中导出与 OpenAI 兼容的函数:

```javascript
// @ai-sdk/nvidia/index.js
export function createNVIDIA({
  baseURL = "https://integrate.api.nvidia.com/v1",
  apiKey,
  ...options
}) {
  // Reuse OpenAI SDK with custom base URL
  return createOpenAI({
    baseURL,
    apiKey,
    ...options
  });
}

export const nvidia = createNVIDIA;
```

3. 在 OpenCode 配置中使用:

```json
{
  "provider": {
    "nvidia": {
      "options": {
        "apiKey": "nvapi-V9***",
        "baseURL": "https://integrate.api.nvidia.com/v1"
      },
      "models": {
        "nvidia/glm-4.7": {...}
      }
    }
  }
}
```

---

### 方向 4: 修改 OpenCode 源码

**目标**: 编译自定义版本的 OpenCode

**步骤**:
1. 克隆 OpenCode 仓库:
   ```bash
   git clone https://github.com/sst/opencode.git
   cd opencode
   ```

2. 修改非交互模式的默认行为:
   - 定位到处理 `-p` 参数的代码
   - 添加对配置文件 `baseURL` 的支持

3. 编译:
   ```bash
   bun run build
   ```

4. 安装自定义版本到本地:
   ```bash
   cd packages/opencode
   npm link
   npm link opencode
   ```

---

### 方向 5: 使用 ACP (Agent Client Protocol)

**目标**: 通过 JSON-RPC 协议直接控制 OpenCode

**之前的问题**:
- `process.write` 显示 "Wrote 0 bytes"
- PTY 模式下启动 TUI 而非 ACP

**可能的解决方案**:
1. 使用 Node.js 的 `child_process` 模块直接调用:
   ```javascript
   const { spawn } = require('child_process');

   const opencode = spawn('/Users/kim/.opencode/bin/opencode', ['acp'], {
     cwd: '/Users/kim/.openclaw/workspace/myopencode',
     stdio: ['pipe', 'pipe', 'pipe']
   });

   // 发送初始化消息
   opencode.stdin.write(JSON.stringify({
     jsonrpc: "2.0",
     id: 0,
     method: "initialize",
     params: {...}
   }) + "\n");
   ```

2. 使用 `expect` 工具自动化 TUI 操作:
   ```bash
   brew install expect
   ```

---

## 推荐优先级

| 优先级 | 方案 | 难度 | 预计时间 | 推荐度 |
|--------|------|------|----------|--------|
| 1 | 方向 3: 自定义 Provider | 中 | 30分钟 | ⭐⭐⭐⭐⭐ |
| 2 | 方向 5: ACP 协议 | 中 | 45分钟 | ⭐⭐⭐⭐ |
| 3 | 方向 2: 环境变量研究 | 低 | 15分钟 | ⭐⭐⭐ |
| 4 | 方向 4: 修改源码 | 高 | 2小时 | ⭐⭐ |
| 5 | 方向 1: SDK 源码研究 | 中 | 1小时 | ⭐⭐⭐ |

---

## 立即可用的替代方案

在深入研究的同时，您可以直接使用 OpenClaw 写代码：
- ✅ 已配置 NVIDIA `z-ai/glm4.7` 模型
- ✅ API Key 已设置
- ✅ 完全可用，零配置
- ✅ 已验证可行（贪食蛇项目）

**示例**:
```
请写一个贪食蛇游戏，保存到 /Users/kim/.openclaw/workspace/myopencode/snake.html
```
→ 我会直接使用 NVIDIA 模型生成代码并保存文件
