#!/bin/bash

# VCS Simulation Script for AES-128 UVM Verification
# Alternative to run.do for QuestaSim

set -e

# Default parameters
DUMP_WAVEFORM=0

# Parse arguments
for arg in "$@"; do
    case $arg in
        --dump|-d|--waveform|-w)
            DUMP_WAVEFORM=1
            ;;
        --help|-h)
            cat <<EOF
Usage: $0 [options]

Options:
  --dump, -d, --waveform, -w  : Enable waveform dump (VPD format)
  --help, -h                   : Show this help message

Examples:
  $0                    # Run simulation without waveform dump
  $0 --dump             # Run simulation with waveform dump enabled
  $0 -w                 # Same as --dump

Waveform files:
  VPD file: vcdplus.vpd (use DVE to view: dve -vpd vcdplus.vpd)

EOF
            exit 0
            ;;
    esac
done

echo "=========================================="
echo "AES-128 UVM Verification with VCS"
echo "=========================================="
echo ""

# Load VCS if not available
if ! command -v vcs &> /dev/null; then
    echo "Loading VCS module..."
    source /tools_soc/tt/Modules/init/bash
    module load synopsys/vcs/R-2020.12 || module load synopsys/vcs/Q-2020.03-SP2
fi

echo "Using VCS: $(vcs -ID 2>&1 | head -1)"
echo ""

# Clean previous runs
echo "Cleaning previous simulation files..."
if [ $DUMP_WAVEFORM -eq 1 ]; then
    rm -rf csrc simv simv.daidir ucli.key vc_hdrs.h *.log *.fsdb
    echo "  Waveform dump enabled - VPD files will be preserved"
else
    rm -rf csrc simv simv.daidir ucli.key vc_hdrs.h *.log *.vpd *.fsdb
fi

# Use vcs directly to compile and elaborate in one step
# Only compile files that are not included by others
# top.sv includes AES_if.svh and AES_128.v, so we only need AES_package.sv and top.sv
echo "Compiling, elaborating and running simulation..."
if [ $DUMP_WAVEFORM -eq 1 ]; then
    echo "  Waveform dump: Enabled (VPD format)"
    VCS_WAVE_FLAGS="+vcs+dumparrays +vpdbufsize+100 +vpdfileswitchsize+1000 +vpdports"
else
    echo "  Waveform dump: Disabled"
    VCS_WAVE_FLAGS=""
fi

vcs -full64 \
    -sverilog \
    -ntb_opts uvm-1.2 \
    +incdir+../RTL \
    +incdir+. \
    -timescale=1ns/1ps \
    -debug_access+all \
    $VCS_WAVE_FLAGS \
    +UVM_TESTNAME=aes_test \
    +UVM_VERBOSITY=UVM_MEDIUM \
    AES_package.sv \
    top.sv \
    -l vcs.log \
    -o simv

if [ $? -ne 0 ]; then
    echo "ERROR: Compilation/Elaboration failed. Check vcs.log"
    exit 1
fi

# Run simulation
echo "Running simulation..."
echo "=========================================="
if [ $DUMP_WAVEFORM -eq 1 ]; then
    ./simv -l simulation.log +UVM_TESTNAME=aes_test +UVM_VERBOSITY=UVM_MEDIUM +vcs+dumparrays
else
    ./simv -l simulation.log +UVM_TESTNAME=aes_test +UVM_VERBOSITY=UVM_MEDIUM
fi

SIM_EXIT=$?

# Check test results from scoreboard
PASS_COUNT=$(grep -c "SCB-PASS" simulation.log 2>/dev/null || echo "0")
FAIL_COUNT=$(grep -c "SCB-FAIL" simulation.log 2>/dev/null || echo "0")
CORRECT_COUNT=$(grep -oP "total no of valid correct tnx is \K\d+" simulation.log 2>/dev/null | tail -1)
INCORRECT_COUNT=$(grep -oP "total no of valid incorrect tnx is \K\d+" simulation.log 2>/dev/null | tail -1)

# Ensure variables are numeric (default to 0 if empty)
CORRECT_COUNT=${CORRECT_COUNT:-0}
INCORRECT_COUNT=${INCORRECT_COUNT:-0}

echo ""
echo "=========================================="
if [ $SIM_EXIT -eq 0 ]; then
    echo "Simulation completed!"
    echo ""
    echo "Test Results Summary:"
    echo "  SCB-PASS: $PASS_COUNT"
    echo "  SCB-FAIL: $FAIL_COUNT"
    echo "  Valid Correct:   $CORRECT_COUNT"
    echo "  Valid Incorrect: $INCORRECT_COUNT"
    echo ""
    if [ "${CORRECT_COUNT:-0}" -eq 0 ] && [ "${INCORRECT_COUNT:-0}" -gt 0 ]; then
        echo "⚠️  WARNING: All tests FAILED! Check simulation.log for details"
        echo "=========================================="
        exit 1
    elif [ "${CORRECT_COUNT:-0}" -gt 0 ] && [ "${INCORRECT_COUNT:-0}" -eq 0 ]; then
        echo "✅ All tests PASSED!"
        if [ $DUMP_WAVEFORM -eq 1 ]; then
            echo ""
            echo "Waveform file: vcdplus.vpd"
            echo "  View with DVE: dve -vpd vcdplus.vpd"
        fi
        echo "=========================================="
    else
        echo "⚠️  Some tests FAILED. Check simulation.log for details"
        if [ $DUMP_WAVEFORM -eq 1 ]; then
            echo ""
            echo "Waveform file: vcdplus.vpd (available for debugging)"
        fi
        echo "=========================================="
        exit 1
    fi
else
    echo "Simulation failed with exit code $SIM_EXIT"
    echo "Check simulation.log for errors"
    if [ $DUMP_WAVEFORM -eq 1 ]; then
        echo ""
        echo "Waveform file: vcdplus.vpd (may be incomplete)"
    fi
    echo "=========================================="
    exit $SIM_EXIT
fi
