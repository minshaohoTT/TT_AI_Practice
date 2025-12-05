#!/bin/bash

# FFT Generator Verification Script
# Quick start script for running FFT verification

set -e

FFTGEN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$FFTGEN_DIR"

echo "=========================================="
echo "FFT Generator Verification"
echo "=========================================="
echo ""

# Default parameters
N_POINTS=${1:-8}
N_UNITS=${2:-1}
MEM_TYPE=${3:-1port}
SIMULATOR=${4:-vcs}
DUMP_WAVEFORM=0

# Parse arguments
ARGS=()
for arg in "$@"; do
    case $arg in
        --dump|-d|--waveform|-w)
            DUMP_WAVEFORM=1
            ;;
        --help|-h)
            # Will be handled later
            ARGS+=("$arg")
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
done

# Reassign positional arguments
set -- "${ARGS[@]}"
N_POINTS=${1:-8}
N_UNITS=${2:-1}
MEM_TYPE=${3:-1port}
SIMULATOR=${4:-vcs}

# Help message
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    cat <<EOF
Usage: $0 [n_points] [n_units] [mem_type] [simulator] [options]

Arguments:
  n_points   : FFT points (8, 16, 32, 64, 128, 256, 512, 1024) [default: 8]
  n_units    : Butterfly units (1, 2, 4) [default: 1]
  mem_type   : Memory type (1port, 2port, dpump) [default: 1port]
  simulator  : Simulator (vcs, verilator) [default: vcs]

Options:
  --dump, -d, --waveform, -w  : Enable waveform dump (VPD for VCS, VCD for Verilator)

Examples:
  $0                          # Run 8-point FFT with defaults (VCS)
  $0 32 2 1port vcs           # 32-point, 2 units, 1port, VCS
  $0 128 4 2port verilator     # 128-point, 4 units, 2port, Verilator
  $0 32 1 1port vcs --dump    # 32-point FFT with waveform dump enabled

For full regression test:
  $FFTGEN_DIR/bin/golden_test.sh -sim vcs

Waveform files:
  VCS:     vcdplus.vpd (use DVE to view: dve -vpd vcdplus.vpd)
  Verilator: fft.vcd (use GTKWave or other VCD viewer)

EOF
    exit 0
fi

# Setup Genesis2
echo "Setting up Genesis2..."
source "$FFTGEN_DIR/bin/setup_genesis.sh"

# Check simulator
if [ "$SIMULATOR" == "vcs" ]; then
    # Try to load VCS module if not available
    if ! command -v vcs &> /dev/null; then
        echo "VCS not found in PATH, attempting to load module..."
        if [ -f /tools_soc/tt/Modules/init/bash ]; then
            source /tools_soc/tt/Modules/init/bash
            module load synopsys/vcs/R-2020.12 2>/dev/null || \
            module load synopsys/vcs/Q-2020.03-SP2 2>/dev/null || \
            module load synopsys/vcs/latest 2>/dev/null || true
        fi
    fi

    # Check again after loading module
    if ! command -v vcs &> /dev/null; then
        echo "ERROR: VCS not found"
        echo "Please load VCS module manually:"
        echo "  source /tools_soc/tt/Modules/init/bash"
        echo "  module load synopsys/vcs/R-2020.12"
        exit 1
    fi
    echo "Using VCS: $(vcs -ID 2>&1 | head -1)"
elif [ "$SIMULATOR" == "verilator" ]; then
    if ! command -v verilator &> /dev/null; then
        echo "ERROR: verilator not found"
        echo "Install with: sudo apt-get install verilator"
        exit 1
    fi
    echo "Using Verilator: $(verilator --version | head -1)"
else
    echo "ERROR: Unknown simulator '$SIMULATOR'"
    echo "Supported: vcs, verilator"
    exit 1
fi

echo ""
echo "Configuration:"
echo "  FFT Points: $N_POINTS"
echo "  Butterfly Units: $N_UNITS"
echo "  Memory Type: $MEM_TYPE"
echo "  Simulator: $SIMULATOR"
if [ $DUMP_WAVEFORM -eq 1 ]; then
    echo "  Waveform Dump: Enabled"
else
    echo "  Waveform Dump: Disabled"
fi
echo ""

# Export DUMP_WAVEFORM for Makefile
export DUMP_WAVEFORM

# Run golden test
echo "Running verification..."
echo "=========================================="
"$FFTGEN_DIR/bin/golden_test.sh" "$N_POINTS" "$N_UNITS" "$MEM_TYPE" -sim "$SIMULATOR"

EXIT_CODE=$?

echo ""
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "Verification completed successfully!"
else
    echo "Verification failed with exit code $EXIT_CODE"
fi
echo "=========================================="

exit $EXIT_CODE
