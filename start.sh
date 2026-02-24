#!/bin/bash

cd /Users/kim/.openclaw/workspace/myopencode

echo "正在清除缓存..."

# 清除 OpenCode 缓存
rm -rf ~/.cache/opencode/providers

echo "缓存已清除"
echo ""
echo "即将启动 OpenCode..."
echo ""

# 启动 OpenCode
/Users/kim/.opencode/bin/opencode
