#!/bin/bash

###################################################################
#Script Name	:   build-toolchain                                                                                            
#Description	:   build toolchain for the Motorola 68000   
#Date           :   samedi, 4 avril 2020                                                                          
#Args           :   Welcome to the next level!                                                                                        
#Author       	:   Jacques Belosoukinski (kentosama)                                                   
#Email         	:   kentosama@genku.net                                          
###################################################################

BUILD_BINUTILS="yes"
BUILD_GCC_STAGE_1="yes"
BUILD_GCC_STAGE_2="no"
BUILD_NEWLIB="no"
CPU="m68000"
PREFIX="m68k-elf-"

# Check if user is root
if [ ${EUID} == 0 ]; then
    echo "Please don't run this script as root!"
    exit
fi

# Check all args
i=1

for arg do
    if [[ "$arg" == "--with-newlib" ]]; then
        ${BUILD_NEWLIB}="yes"
        ${BUILD_GCC_STAGE_2}="yes"
        export WITH_NEWLIB="--with-newlib"
    elif [[ "$arg" == "--with-cpu=" ]]; then
        ${CPU} = ${i}
    elif [[ "$arg" == "--program-prefix=" ]]; then
        ${PREFIX} = ${i}
    fi

    i=$((i + 1))
done

# Export
export ARCH=$(uname -m)
export TARGET="m68k-elf"
export BUILD_MACH="${ARCH}-pc-linux-gnu"
export HOST_MACH="${ARCH}-pc-linux-gnu"
export NUM_PROC=$(nproc)
export PROGRAM_PREFIX=${PREFIX}
export INSTALL_DIR="${PWD}/m68k-toolchain"
export DOWNLOAD_DIR="${PWD}/download"
export ROOT_DIR="${PWD}"
export BUILD_DIR="${ROOT_DIR}/build"
export SRC_DIR="${ROOT_DIR}/source"
export WITH_CPU=${CPU}

# Create main folders in the root dir
mkdir -p ${INSTALL_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${SRC_DIR}
mkdir -p ${DOWNLOAD_DIR}

export PATH=$INSTALL_DIR/bin:$PATH

# Build binutils
if [ ${BUILD_BINUTILS} == "yes" ]; then
    ./build-binutils.sh
    if [ $? -ne 0 ]; then
        "Failed to build binutils, please check build.log"
        exit 1
    fi
fi

# Build GCC stage 1
if [ ${BUILD_GCC_STAGE_1} == "yes" ]; then
    ./build-gcc.sh
    if [ $? -ne 0 ]; then
        "Failed to build gcc stage 1, please check build.log"
        exit
    fi
fi

# Build newlib
if [ ${BUILD_NEWLIB} == "yes" ]; then
    ./build-newlib.sh
    if [ $? -ne 0 ]; then
        "Failed to build newlib, please check build.log"
        exit
    else
        # Build GCC stage 2 (with newlib)
        if [ ${BUILD_GCC_STAGE_2} == "yes" ]; then
            ./build-gcc.sh
            if [ $? -ne 0 ]; then
                "Failed to build gcc stage 2, please check build.log"
                exit
            fi
        fi
    fi
fi

echo "m68k toolchain build was terminated"