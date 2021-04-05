#!/bin/bash
set -x
BASE_FOLDER=$(cd `dirname $0`; pwd)
OUTPUT_FOLDER=${BASE_FOLDER}/output
PREFIX_FOLDER=${OUTPUT_FOLDER}/install
NUM_PROC=$(getconf _NPROCESSORS_ONLN)
DEBUG=$1

run_init_folder(){
    rm -rf ${OUTPUT_FOLDER}
    mkdir -p ${OUTPUT_FOLDER}
}

if [ "${DEBUG}" != "debug" ]; then
    run_init_folder
    run_init_dep    
fi

# 编译openresty
cd ${OUTPUT_FOLDER}
tar -zxvf ${BASE_FOLDER}/src/openresty-1.19.3.1.tar.gz
cd ${OUTPUT_FOLDER}/openresty-1.19.3.1

# openssl
tar -zxvf ${BASE_FOLDER}/extras/openssl/openssl-OpenSSL_1_1_1j.tar.gz

./configure --prefix=${PREFIX_FOLDER} \
    --with-openssl=${OUTPUT_FOLDER}/openresty-1.19.3.1/openssl-OpenSSL_1_1_1j
make -j ${NUM_PROC}
make install