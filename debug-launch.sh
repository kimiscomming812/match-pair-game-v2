#!/bin/bash

echo "OpenCode Debug Mode..."
cd /Users/kim/.openclaw/workspace/myopencode
/Users/kim/.opencode/bin/opencode -d 2>&1 | tee opencode-debug.log
