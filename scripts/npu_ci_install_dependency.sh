#!/bin/bash
# Install the required dependencies in CI.
sed -i 's|ports.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list
apt update -y
apt install software-properties-common -y
pip install --upgrade pip

pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

pip uninstall sgl-kernel -y || true

# official PPA comes with ffmpeg 2.8, which lacks tons of features, we use ffmpeg 4.0 here
add-apt-repository -y ppa:jonathonf/ffmpeg-4 # for ubuntu20.04 official PPA is already version 4.2, you may skip this step
apt-get update -y
apt-get install -y build-essential python3-dev python3-setuptools make cmake
apt-get install -y ffmpeg libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev
# build decord
git clone --recursive https://github.com/dmlc/decord
cd decord
mkdir build && cd build
cmake .. -DUSE_CUDA=0 -DCMAKE_BUILD_TYPE=Release
make
cd ../python
sed -i 's/maintainer_email.*/&\n    dependency_links=[\n        "https:\/\/mirrors.tuna.tsinghua.edu.cn\/pypi\/web\/simple"\n    ],/g' setup.py
python3 setup.py install --user
cd ../..
pwd
# note: make sure you have cmake 3.8 or later, you can install from cmake official website if it's too old

pip install torch-npu==2.6.0rc1
pip install triton-ascend==3.2.0rc2
pip install vllm==0.8.5

pip install -e "python[all_npu]"

pip install modelscope
pip install pytest
