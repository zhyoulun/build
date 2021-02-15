#!/bin/bash
set -x
BASE_FOLDER=$(cd `dirname $0`; pwd)
TEMP_FOLDER=${BASE_FOLDER}/temp

NAME="zeromq-4.3.4"
FILE=${BASE_FOLDER}/$NAME".tar.gz"
UNZIP_FOLDER=${TEMP_FOLDER}/${NAME}
INSTALL=${BASE_FOLDER}/../../output
NUM_PROC=$(getconf _NPROCESSORS_ONLN)

# 检查压缩包是否存在
if test ! -f ${FILE}; then
    echo "${FILE} not exist"
    exit 1
fi

# 创建临时文件夹
if test -d ${TEMP_FOLDER}; then
    rm -rf ${TEMP_FOLDER}
fi
mkdir -p ${TEMP_FOLDER}

# 进入临时文件夹并解压
cd ${TEMP_FOLDER} && tar -zxvf ${FILE}
if test $? -ne 0; then
    echo "unzip ${FILE} fail"
    exit 1
fi

# 判断解压文件夹是否存在
if test ! -d ${UNZIP_FOLDER}; then
    echo "unzip folder ${UNZIP_FOLDER} not exist"
    exit 1
fi

cd ${UNZIP_FOLDER}
./configure --prefix=${INSTALL} && make -j ${NUM_PROC} && make install

if test $? -ne 0; then
    echo "configure&make&make install fail"
    exit 1
fi

# 清理
rm -rf ${TEMP_FOLDER}