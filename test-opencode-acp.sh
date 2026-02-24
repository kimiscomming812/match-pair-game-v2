#!/bin/bash

cd /Users/kim/.openclaw/workspace/myopencode

mkfifo /tmp/acp-pipe

# 启动 OpenCode ACP
opencode acp < /tmp/acp-pipe > /tmp/acp-response.log 2>&1 &
OPENCODE_PID=$!

sleep 2

# 初始化
cat > /tmp/acp-pipe << 'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1,"clientCapabilities":{"fs":{"readTextFile":true,"writeTextFile":true},"terminal":true},"clientInfo":{"name":"javis","title":"Javis","version":"1.0.0"}}}
EOF
sleep 1

# 创建会话
cat > /tmp/acp-pipe << 'EOF'
{"jsonrpc":"2.0","id":2,"method":"session/new","params":{"cwd":"/Users/kim/.openclaw/workspace/myopencode","mcpServers":[]}}
EOF
sleep 2

# 发送提示（更简单的内容）
cat > /tmp/acp-pipe << 'EOF'
{"jsonrpc":"2.0","id":3,"method":"session/prompt","params":{"sessionId":"NEW_SESSION","messages":[{"role":"user","text":"创建文件 hello.js 写 console.log(1)"}]}}
EOF

# 等待响应
sleep 30

# 显示结果
echo "====== OpenCode 响应 ======"
tail -100 /tmp/acp-response.log
echo "====== 文件内容 ======"
cat hello.js 2>/dev/null || echo "文件未生成"

# 清理
kill $OPENCODE_PID 2>/dev/null
rm -f /tmp/acp-pipe
