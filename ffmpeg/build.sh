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

    dep_build extras/mp3lame
    dep_build extras/x264
    dep_build extras/x265
    dep_build extras/fdk-aac
    dep_build extras/zeromq
    # dep_build extras/libgd
}

if [ "${DEBUG}" != "debug" ]; then
    run_init_folder
    run_init_dep    
fi

# 编译ffmpeg
cd ${OUTPUT_FOLDER}
cp -R /Users/zhangyoulun/codes/github/FFmpeg ${OUTPUT_FOLDER}

cd ${OUTPUT_FOLDER}/FFmpeg
PKG_CONFIG_PATH=${OUTPUT_FOLDER}/lib/pkgconfig && ./configure --prefix=${PREFIX_FOLDER} \
    --extra-cflags="-I${OUTPUT_FOLDER}/include" \
	--extra-ldflags="-L${OUTPUT_FOLDER}/lib" \
    --pkg-config-flags="--static" \
    --enable-libzmq \
    --enable-gpl \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libmp3lame \
    --enable-libfdk-aac \
    --enable-nonfree \
    --enable-debug \
    --disable-asm \
    --disable-optimizations \
    --enable-shared
make -j ${NUM_PROC}
make install
