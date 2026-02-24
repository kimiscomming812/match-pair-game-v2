#!/bin/bash

# 设置 NVIDIA NIM 端点
export LOCAL_ENDPOINT="https://integrate.api.nvidia.com/v1"
export OPENAI_API_KEY="nvapi-V9hPqDwFpJNv0X7YkT5m1j1kcR1"

# 运行 OpenCode
/Users/kim/.opencode/bin/opencode "$@"
