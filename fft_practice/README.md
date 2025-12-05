FFT Generator
======

[![Build Status][1]][2] [![Build Status][3]][4]

[1]: https://github.com/steveri/fftgen/actions/workflows/CI.yml/badge.svg
[2]: https://github.com/steveri/fftgen/actions/workflows/CI.yml
[3]: https://app.travis-ci.com/steveri/fftgen.svg?branch=master
[4]: https://app.travis-ci.com/steveri/fftgen






This repo contains code for an FFT generator and testbench. The generator can build an 8-point FFT, a 1024-point FFT, or any power-of-two in between. It also provides a choice of 1, 2, or 4 butterfly units. The generator is powered by [Genesis2](https://github.com/StanfordVLSI/Genesis2).

This FFT uses a conflict-free schedule, meaning that it runs to completion without ever having to pause for memory-conflict resolution. Not counting setup and takedown simulation time, the FFT will therefore complete its operation in minimal time. So, for instance, if local memory access takes one cycle to complete, and if you use the generator to build a 1024-point FFT with only a single butterfly unit, it will complete its operation in (n/2)log2(n) or 5120 cycles. An FFT built with two butterflies working in parallel will take just half that amount of time, and so on.

The conflict-free schedule works on a variety of memory configurations, including single-ported SRAM. The single-ported version of this FFT would thus be the least-area memory configuration for a resource-constrained FFT.

Also see

* Richardson et al., "Building Conflict-Free FFT Schedules," April 2015, doi: 10.1109/TCSI.2015.2402935. https://ieeexplore.ieee.org/document/7070875

* Richardson et al., "An area-efficient minimum-time FFT schedule using single-ported memory," 2013, doi: 10.1109/VLSI-SoC.2013.6673242. https://ieeexplore.ieee.org/document/6673242


## Building FFT's with fftgen: A Quick How-To

You will need csh and perl (sorry!). If you don't already have them, see internet for instructions on how to install. You'll also need either Verilator or VCS simulator. VCS is fully supported and recommended for all memory configurations.

### Quick Start with run_verification.sh

The easiest way to run verification is using the `run_verification.sh` script:

```bash
  # 1. Navigate to the fftgen directory
  cd /path/to/fftgen

  # 2. Run a quick test (default: 8-point FFT, 1 unit, 1port, VCS)
  ./run_verification.sh

  # 3. Run with custom parameters
  ./run_verification.sh 32 2 1port vcs

  # 4. Enable waveform dump
  ./run_verification.sh 32 1 1port vcs --dump

  # 5. See help for more options
  ./run_verification.sh --help
```

### Using golden_test.sh Directly

For more control, you can use `golden_test.sh` directly:

```bash
  # 1. Clone the repo
  git clone https://github.com/steveri/fftgen
  FFTGEN=$PWD/fftgen

  # 2. The `setup_genesis` script installs Genesis.pl
  #    if it's not already in your path
  source $FFTGEN/bin/setup_genesis.sh

  # 3. Build a scratch/build area inside the clone
  mkdir fftgen/build; cd fftgen/build

  # 4. Build and test a single FFT design against a golden model,
  #    e.g. to build a 32-point in-place FFT using two butterfly units
  #    and one bank of single-port SRAM:
  $FFTGEN/bin/golden_test.sh 32 2 1port -sim vcs

  # 5. (Optional) Exhaustive test of multiple models
  $FFTGEN/bin/golden_test.sh -sim vcs

  # 6. (optional) More information
  $FFTGEN/bin/golden_test.sh --help
```

Our CI scripts also provide a good guide on how to build and run fftgen using an extensive test suite. Scripts are here:

* https://github.com/steveri/fftgen/tree/master/.github/workflows
* https://github.com/steveri/fftgen/blob/master/.travis.yml

And you can see the results of previous runs here:

* https://github.com/steveri/fftgen/actions/workflows/CI.yml
* https://app.travis-ci.com/github/steveri/fftgen/builds


## Using RTL examples

If you want to not fool with genesis and just use see/use straight SystemVerilog RTL, there are example configurations in the subdirectory `examples-rtl`, along with `README.md` instructions on how to build and use a Verilator testbench to verify its correctness.



## Simulator Support

### VCS (Synopsys VCS) - Recommended
- ✅ Fully supports all memory configurations (1port, 2port, dpump)
- ✅ All regression tests pass (47/47)
- ✅ Better debugging capabilities (DVE, VPD waveforms)
- ✅ Faster simulation speed for large designs
- ✅ Waveform dump support (VPD format)

To use VCS:
```bash
# Load VCS module (if using module system)
source /tools_soc/tt/Modules/init/bash
module load synopsys/vcs/R-2020.12

# Run verification
./run_verification.sh 32 1 1port vcs --dump
```

### Verilator
- ⚠️ Limited support: only works with 2port memory configuration
- ✅ Open source and free
- ✅ Waveform dump support (VCD format)

To use Verilator:
```bash
./run_verification.sh 32 1 2port verilator --dump
```

## Waveform Dump

Waveform dump is supported for both simulators:

- **VCS**: Generates `vcdplus.vpd` file
  - View with DVE: `dve -vpd vcdplus.vpd`
- **Verilator**: Generates `counter.vcd` file
  - View with GTKWave or other VCD viewers

Enable waveform dump using the `--dump`, `-d`, `--waveform`, or `-w` option:
```bash
./run_verification.sh 32 1 1port vcs --dump
```

**Note**: Waveform dump increases simulation time and disk space usage. Use only when debugging.

## Current Status

- All regression tests PASS (47/47) using VCS
- VCS fully supports all memory configurations
- Verilator only works with 2port configuration
- See `0notes-fft.txt`, `rtl/README.txt` for latest/best info
