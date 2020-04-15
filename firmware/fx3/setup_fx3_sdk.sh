#!/bin/bash

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || echo "You must source this script. Use source setup_fx3_sdk.sh"
[[ "${BASH_SOURCE[0]}" != "${0}" ]] || exit 1

if [[ $1 == clean ]]; then
  rm -rf arc-2013.11
  rm -rf fw_lib
  rm -rf fw_build
  rm -rf boot_lib
  rm -rf boot_fw
  rm -rf common
  rm -rf u3p_firmware
  rm -rf lpp_source
  rm -rf elf2img
  echo "Cleaned SDK"
  return
fi

if [ ! -d "common" ]; then
  echo "Detected that FX3 SDK is not installed."
  FX3_SDK="FX3_SDK_1.3.4_Linux.tar.gz"
  FX3_SDK_LISTING_PAGE="https://www.cypress.com/documentation/software-and-drivers/ez-usb-fx3-software-development-kit"
  FX3_SDK_URL="https://www.cypress.com/file/424271/download"
  if [ ! -f "$FX3_SDK" ]; then
    echo "You need to manually download $FX3_SDK from $FX3_SDK_URL and place besides this script and run it once again"
    echo "The file was found on the website $FX3_SDK_LISTING_PAGE"
    return
  else
    echo "Extracting SDK and moving files to expected locations, hang tight"
    TMP_DIR=fx3_extracted
    mkdir $TMP_DIR
    tar -xzf $FX3_SDK --directory $TMP_DIR
    tar -xzf $TMP_DIR/ARM_GCC.tar.gz
    tar -xzf $TMP_DIR/fx3_firmware_linux.tar.gz --directory $TMP_DIR
    mv $TMP_DIR/cyfx3sdk/fw_lib .
    mv $TMP_DIR/cyfx3sdk/fw_build .
    mv $TMP_DIR/cyfx3sdk/boot_lib .
    mv $TMP_DIR/cyfx3sdk/firmware/boot_fw .
    mv $TMP_DIR/cyfx3sdk/firmware/common .
    mv $TMP_DIR/cyfx3sdk/firmware/u3p_firmware .
    mv $TMP_DIR/cyfx3sdk/firmware/lpp_source .
    mv $TMP_DIR/cyfx3sdk/util/elf2img .
    rm -rf $TMP_DIR
    echo "SDK extracted"

    echo "Patching SDK"
    # Can now build version 1_2_3 as well
    patch common/fx3_build_config.mak < common.fx3_build_config.mak.patch

    # Use ARMGCC_INSTALL_PATH
    patch fw_build/boot_fw/fx3_armgcc_config.mak < fw_build.boot_fw.fx3_armgcc_config.mak.patch
    patch fw_build/fx3_fw/fx3_armgcc_config.mak < fw_build.fx3_fw.fx3_armgcc_config.mak.patch
    echo "Done patching SDK"
  fi
fi

if [ -d "common" ]; then
  echo "Installed FX3 SDK detected, setting up required variables"
  export ARMGCC_INSTALL_PATH=`pwd`/arm-2013.11
  export ARMGCC_VERSION=4.8.1
  export CYCONFOPT=fx3_release
  export CYSDKVERSION=1_3_4
  echo "Environment has been set up to build using FX version 1.3.4"
  echo "You can also build using FX3 version 1.2.3 by running 'export CYSDKVERSION=1_2_3'"
else
  echo "Error in setup script, SDK not set up correctly"
fi
