#!/bin/bash -e
# Install the required dependencies in CI.

pip install --upgrade pip

pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

pip uninstall sgl-kernel -y || true


pip install torch-npu==2.6.0rc1
pip install triton-ascend==3.2.0rc2

pip install -e "python[all_npu]"

pip install modelscope
pip install pytest
