INSTRUCTIONS
================================

# Building the B2xx FX3 Firmware

The USRP B200 and B210 each use the Cypress FX3 USB3 PHY for USB3 connectivity.
This device has an ARM core on it, which is programmed in C. This README will
show you how to build our firmware and bootloader source.

**A brief "Theory of Operations":**
The host sends commands to the FX3, our USB3 PHY, which has an on-board ARM
which runs the FX3 firmware code (hex file). That code is responsible for
managing the transport from the host to the FPGA by configuring IO and DMA.

## Setting up the Cypress SDK

In order to compile the USRP B200 and B210 firmware, you will need the FX3 SDK
distributed by the FX3 manufacturer, Cypress Semiconductor.

This step has been somewhat scripted. Run `source setup_fx3_sdk.sh` for help
setting up the SDK. You can clean up the SDK by running `source setup_fx3_sdk.sh clean`.

## Applying the Patch to the Toolchain

THIS WAS PREVIOUSLY SUPPORTED. However, this patching has not been migrated to
the 1.3.4 SDK. Therfore `HAS_HEAP` AND `ENABLE_MSG` was uncommented in
`firmware/fx3/b200/firmware/b200_main.c`. Old description below:

Now, you'll need to apply a patch to a couple of files in the Cypress SDK. Head
into the `common/` directory you just copied from the Cypress SDK, and apply the
patch `b200/fx3_mem_map.patch`.

```
    # cd uhd.git/firmware/fx3
    $ patch -p1 < ../b200/fx3_mem_map.patch
```

If you don't see any errors print on the screen, then the patch was successful.

## Building the Firmware

Now, you should be able to head into the `b200/firmware` directory and simply
build the firmware:

```
    $ cd uhd.git/firmware/fx3/b200/firmware
    $ make
```

It will generate a `usrp_b200_fw.hex` file, which you can then give to UHD to
program your USRP B200 or USRP B210.

## Building the Bootloader

The bootloader is built in the `b200/bootloader` directory:

```
    $ cd uhd.git/firmware/fx3/b200/bootloader
    $ make
```

It will generate a `usrp_b200_bl.img` file, which you can supply as an argument
to b2xx_fx3_utils to load it onto the device.
