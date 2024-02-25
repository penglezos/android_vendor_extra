#!/bin/bash
#
# Copyright (C) 2019-2024 Panagiotis Englezos <panagiotisegl@gmail.com>
#
# Android Build script 
#
# Usage (in root of source):
# 	./build.sh [options]
#

# Set defaults
DEVICE='raphael'
BUILD_TYPE='userdebug'
ZRAM_VALUE='32'
export CCACHE_EXEC=$(command -v ccache)
export CCACHE_DIR=$(pwd)/.ccache
export USE_CCACHE=1
ccache -M 50G

clean () {
    source build/envsetup.sh
    lunch lineage_${DEVICE}-${BUILD_TYPE}
    make clean && rm -rf out
}

installclean () {
    source build/envsetup.sh
    lunch lineage_${DEVICE}-${BUILT_TYPE}
    make installclean
}

sync () {
    repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
    rm -rf .repo/local_manifests && mkdir -p .repo/local_manifests
    curl https://raw.githubusercontent.com/penglezos/android_vendor_extra/main/.repo/local_manifests/lineage.xml -o .repo/local_manifests/lineage.xml
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

zram () {
    sudo swapoff --all
    sudo bash -c "echo ${ZRAM_VALUE}G > /sys/block/zram0/disksize"
    sudo mkswap --label zram0 /dev/zram0
    sudo swapon --priority 32767 /dev/zram0
}

patches () {
    . build/envsetup.sh
    croot
    
    PATCHES_PATH=$PWD/vendor/extra/patches

    for project_name in $(cd "${PATCHES_PATH}"; echo */); do
        project_path="$(tr _ / <<<$project_name)"

        cd $(gettop)/${project_path}
        git am "${PATCHES_PATH}"/${project_name}/*.patch --no-gpg-sign
        git am --abort &> /dev/null
    done

    croot
}

build () {
    source build/envsetup.sh
    lunch lineage_${DEVICE}-${BUILD_TYPE}
    make bacon -j$(nproc --all)
}

kernel () {
    source build/envsetup.sh
    lunch lineage_${DEVICE}-${BUILD_TYPE}
    make bootimage -j$(nproc --all)
}

recovery () {
    source build/envsetup.sh
    lunch lineage_${DEVICE}-${BUILD_TYPE}
    make recoveryimage -j$(nproc --all)
}

# Usage information when there are no arguments
if [[ $# -eq 0 ]]; then
	echo -e "\nUsage: ./build.sh [options]\n"
	echo "Options:"
    echo "  -c, --clean                    Clean entire build directory"
    echo "  -i, --installclean             Dirty build"
    echo "  -z, --zram                     Setup ZRAM"
	echo "  -s, --sync                     Sync ROM and device sources"
	echo "  -p, --patches                  Apply patches"
	echo "  -b, --build                    Perform ROM build"
	echo "  -k, --kernel                   Perform kernel build"
	echo "  -r, --recovery                 Perform recovery build"
	echo ""
	exit 0
fi

# Parse arguments
while [[ "$#" -gt 0 ]]; do case $1 in
	-c|--clean) clean;;
	-i|--installclean) installclean;;
    -z|--zram) zram;;
	-s|--sync) sync;;
	-p|--patches) patches;;
	-b|--build) build;;
	-k|--kernel) kernel;;
    -r|--recovery) recovery;;
	*) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done