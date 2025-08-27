## rfSOC DFE  Hardware Platform 

This is a custom designed hardware platform using the Xilinx rfSOC chip for various applications from the NSLS2 Diagnostics Group.

Uses the DESY FWK FPGA Firmware Framework https://fpgafw.pages.desy.de/docs-pub/fwk/index.html

## Requires

* Xilinx 2022.2
* git
* python3


## Building

```sh

Clone with --recurse-submodules to get the FWK repos

git clone --recurse-submodules https://github.com/NSLS-II/rfsoc-dfe

Setup Environment: make env (first time only)

To build firmware make cfg=hw project (Sets up project)

make cfg=hw gui (Open in Vivado)

make cfg=hw build (Builds bit file)

To build Software

make cfg=sw project (Sets up project)

make cfg=sw gui (Opens in Vitis)

make cfg=sw build (Builds executable)

```
