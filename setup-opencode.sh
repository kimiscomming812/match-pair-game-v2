#!/bin/bash

echo "=========================================="
echo "  OpenCode 直接启动（无配置）"
echo "=========================================="
echo ""
echo "清理所有配置..."

CONFIGS=(
    "$HOME/.config/opencode/opencode.json"
    "$HOME/opencode.json" 
    "$PWD/opencode.json"
)

for file in "${CONFIGS[@]}"; do
    rm -f "$file"
done

echo ""
echo "正在启动 OpenCode (临时调试模式)..."
echo ""
echo "关键快捷键："
echo "  - 按 / : 打开命令面板"
echo "  - 按 i : 进入输入模式"
echo "  - 按 ESC : 返回"
echo "  - 按 q : 退出"
echo ""
echo "如果看到提示符，尝试："
echo "  1. 按 ESC 多次确保在正常模式"
echo "  2. 按 / 然后输入 connect"
echo "  3. 或者查看帮助 按 ? 或 h"
echo ""
echo "=========================================="
echo ""

read -p "按 Enter 启动..."

cd /Users/kim/.openclaw/workspace/myopencode
/Users/kim/.opencode/bin/opencode
