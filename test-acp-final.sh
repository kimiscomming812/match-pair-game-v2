#!/bin/bash

# 清理可能的旧进程
pkill -9 opencode 2>/dev/null
sleep 1

# 转到项目目录
cd /Users/kim/.openclaw/workspace/myopencode

# 启动 OpenCode ACP
(opencode acp < /tmp/acp-pipe.in > /tmp/acp.log 2>&1) &
OPENCODE_PID=$!

sleep 2

# 初始化（单行，不换行）
printf '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1,"clientCapabilities":{"fs":{"readTextFile":true,"writeTextFile":true},"terminal":true},"clientInfo":{"name":"javis","title":"Javis","version":"1.0.0"}}}' > /tmp/acp-pipe.in

sleep 1

# 创建会话
printf '{"jsonrpc":"2.0","id":2,"method":"session/new","params":{"cwd":"/Users/kim/.openclaw/workspace/myopencode"}}' > /tmp/acp-pipe.in

sleep 3

# 提取 Session ID
SESSION=$(grep -o '"sessionId":"[^"]*"' /tmp/acp.log | tail -1 | cut -d'"' -f4)
echo "提取的 Session ID: $SESSION"

# 发送提示（使用正确的 Session ID，避免单引号）
printf '{"jsonrpc":"2.0","id":3,"method":"session/prompt","params":{"sessionId":"'$SESSION'","messages":[{"role":"user","text":"Create hello.js file with console.log(1)"}]}}' > /tmp/acp-pipe.in

echo ""
echo "等待执行... (30秒)"
sleep 30

echo ""
echo "====== OpenCode 日志 (最后 80 行) ======"
tail -80 /tmp/acp.log

echo ""
echo "====== 文件内容 ======"
cat hello.js 2>/dev/null || echo "文件未找到"

echo ""
echo "====== 当前目录文件列表 ======"
ls -la

# 清理
kill $OPENCODE_PID 2>/dev/null
rm -f /tmp/acp-pipe.in /tmp/acp.log
