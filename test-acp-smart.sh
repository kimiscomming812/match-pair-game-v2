#!/bin/bash

cd /Users/kim/.openclaw/workspace/myopencode

# 启动 OpenCode ACP 并使用命名管道
mkfifo /tmp/acp-pipe
exec 3>/tmp/acp-pipe  # 打开管道用于写入
exec 4</tmp/acp-pipe  # 打开管道用于读取（后台）

(opencode acp < /tmp/acp-pipe > /tmp/acp-response.log 2>&1) &
OPENCODE_PID=$!

sleep 2

# 初始化
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1,"clientCapabilities":{"fs":{"readTextFile":true,"writeTextFile":true},"terminal":true},"clientInfo":{"name":"javis","title":"Javis","version":"1.0.0"}}}' >&3
sleep 1

# 创建会话
echo '{"jsonrpc":"2.0","id":2,"method":"session/new","params":{"cwd":"/Users/kim/.openclaw/workspace/myopencode"}}' >&3
sleep 3

# 从响应中提取 Session ID
SESSION_ID=$(grep -o '"sessionId":"[^"]*"' /tmp/acp-response.log | head -1 | cut -d'"' -f4)
echo "获取到 Session ID: $SESSION_ID"

# 发送提示（使用提取的 Session ID）
echo "{\"jsonrpc\":\"2.0\",\"id\":3,\"method\":\"session/prompt\",\"params\":{\"sessionId\":\"$SESSION_ID\",\"messages\":[{\"role\":\"user\",\"text\":\"Create hello.js with console.log(1)\"}]}}" >&3

# 等待响应
echo "等待 OpenCode 执行..."
sleep 30

# 显示结果
echo "====== OpenCode 响应最后 50 行 ======"
tail -50 /tmp/acp-response.log
echo ""
echo "====== 创建的文件内容 ======"
cat hello.js 2>/dev/null || echo "文件未生成"

# 清理
kill $OPENCODE_PID 2>/dev/null
exec 3>&-  # 关闭文件描述符
exec 4<&-
rm -f /tmp/acp-pipe
