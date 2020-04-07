#!/bin/bash

###################################################################
#Script Name	:   build-newlib                                                                                            
#Description	:   build newlib for the Motorola 68000 toolchain   
#Date           :   samedi, 7 avril 2020                                                                          
#Args           :   Welcome to the next level!                                                                                        
#Author       	:   Jacques Belosoukinski (kentosama)                                                   
#Email         	:   kentosama@genku.net                                          
###################################################################

VERSION="3.3.0"
ARCHIVE="newlib-${VERSION}.tar.gz"
URL="ftp://sourceware.org/pub/newlib/${ARCHIVE}"
SHA512SUM="2f0c6666487520e1a0af0b6935431f85d2359e27ded0d01d02567d0d1c6479f2f0e6bbc60405e88e46b92c2a18780a01a60fc9281f7e311cfd40b8d5881d629c"
DIR="newlib-${VERSION}"

# Check if user is root
if [ ${EUID} == 0 ]; then
    echo "Please don't run this script as root"
    exit
fi

# Create build folder
mkdir ${BUILD_DIR}/${DIR}

# Move into download folder
cd ${DOWNLOAD_DIR}

# Download newlib if is needed
if ! [ -f "${ARCHIVE}" ]; then
    wget ${URL}
fi

# Extract the newlib archive if is needed
if ! [ -d "${SRC_DIR}/${DIR}" ]; then
    if [ $(sha512sum ${ARCHIVE} | awk '{print $1}') != ${SHA512SUM} ]; then
        echo "SHA512SUM verification of ${ARCHIVE} failed!"
        exit
    else
        tar -zxvf ${ARCHIVE} -C ${SRC_DIR}
    fi
fi

# Export
PREFIX=${PROGRAM_PREFIX}
export CC_FOR_TARGET=${PREFIX}gcc
export LD_FOR_TARGET=${PREFIX}ld
export AS_FOR_TARGET=${PREFIX}as
export AR_FOR_TARGET=${PREFIX}ar
export RANLIB_FOR_TARGET=${PREFIX}ranlib
export newlib_cflags="${newlib_cflags} -DPREFER_SIZE_OVER_SPEED -D__OPTIMIZE_SIZE__"

# Move into build dir
cd ${BUILD_DIR}/${DIR}

# Configure before build
../../source/${DIR}/configure   --prefix=${INSTALL_DIR} \
                                --build=${BUILD_MACH} \
                                --host=${HOST_MACH} \
                                --target=${TARGET} \
                                --program-prefix=${PREFIX} \
                                --disable-newlib-multithread \
                                --disable-newlib-io-float \
                                --enable-lite-exit \
                                --disable-newlib-supplied-syscalls \

# Build and install newlib
make -j${NUM_PROC} 2<&1 | tee build.log

# Install newlib
if [ $? -eq 0 ]; then
    make install
fi