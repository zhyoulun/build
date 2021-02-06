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

run_init_dep(){
    # 编译依赖
    dep_build(){
        if test $? -ne 0; then
            echo "dep build fail: $1"
            exit 1
        fi

        cd ${BASE_FOLDER}/$1
        chmod +x build.sh
        ./build.sh

        if test $? -ne 0; then
            echo "dep build fail: $1"
            exit 1
        fi
    }

    dep_build extras/geoip
    dep_build extras/libgd
}

if [ "${DEBUG}" != "debug" ]; then
    run_init_folder
    run_init_dep    
fi

# 编译nginx
cd ${OUTPUT_FOLDER}
tar -zxvf ${BASE_FOLDER}/src/nginx-1.18.0.tar.gz
cd ${OUTPUT_FOLDER}/nginx-1.18.0

patch -p1 < ${BASE_FOLDER}/src/proxy_connect_rewrite_1018.patch
tar -zxvf ${BASE_FOLDER}/extras/ngx_http_proxy_connect_module/ngx_http_proxy_connect_module-0.0.2.tar.gz

./configure --prefix=${PREFIX_FOLDER} \
    --with-cc-opt="-I${OUTPUT_FOLDER}/include" \
    --with-ld-opt="-L${OUTPUT_FOLDER}/lib" \
    --with-http_geoip_module \
    --add-module=${OUTPUT_FOLDER}/nginx-1.18.0/ngx_http_proxy_connect_module-0.0.2
make -j ${NUM_PROC}
make install
