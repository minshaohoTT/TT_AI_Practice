#!/bin/bash

# AES-128 Verification Environment Setup Script
# This script sets up the environment for AES-128 UVM verification

set -e  # Exit on error

echo "=========================================="
echo "AES-128 Verification Environment Setup"
echo "=========================================="
echo ""

# Step 1: Load module system
echo "[1/4] Loading module system..."
if [ -f /tools_soc/tt/Modules/init/bash ]; then
    source /tools_soc/tt/Modules/init/bash
    echo "✓ Module system loaded"
else
    echo "✗ Module system not found at /tools_soc/tt/Modules/init/bash"
    exit 1
fi

# Step 2: Load QuestaSim
echo "[2/4] Loading QuestaSim..."
if module load siemens/questasim/2025.3 2>/dev/null; then
    echo "✓ QuestaSim 2025.3 loaded"
elif module load siemens/questasim/2025.1 2>/dev/null; then
    echo "✓ QuestaSim 2025.1 loaded"
else
    echo "✗ QuestaSim module not found"
    echo "Available QuestaSim versions:"
    module avail 2>&1 | grep questasim || echo "  None found"
    exit 1
fi

# Step 3: Verify tools
echo "[3/4] Verifying tools..."
if command -v vsim &> /dev/null; then
    VSIM_VERSION=$(vsim -version 2>&1 | head -1)
    echo "✓ QuestaSim found: $VSIM_VERSION"
else
    echo "✗ vsim command not found"
    exit 1
fi

if command -v vlog &> /dev/null; then
    echo "✓ vlog compiler found"
else
    echo "✗ vlog command not found"
    exit 1
fi

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✓ $PYTHON_VERSION found"
else
    echo "✗ python3 not found"
    exit 1
fi

# Step 4: Check Python dependencies
echo "[4/4] Checking Python dependencies..."
if python3 -c "from Crypto.Cipher import AES" 2>/dev/null; then
    echo "✓ PyCryptodome library available"
else
    echo "⚠ PyCryptodome library not found"
    echo "  Installing PyCryptodome..."
    if pip3 install --user pycryptodome 2>/dev/null; then
        echo "✓ PyCryptodome installed successfully"
    else
        echo "✗ Failed to install PyCryptodome"
        echo "  Please run manually: pip3 install pycryptodome"
    fi
fi

echo ""
echo "=========================================="
echo "Environment Setup Complete!"
echo "=========================================="
echo ""
echo "Current directory: $(pwd)"
echo ""
echo "To run simulation:"
echo "  cd UVM"
echo "  vsim -do run.do"
echo ""
echo "Or with GUI:"
echo "  cd UVM"
echo "  vsim -do run.do -gui"
echo ""
echo "To generate test vectors:"
echo "  cd SYS\\ MODEL"
echo "  python3 gen_random.py"
echo "  python3 encrypt.py"
echo ""
