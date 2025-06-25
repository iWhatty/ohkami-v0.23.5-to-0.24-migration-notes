#!/bin/bash
# Setup script to prepare dependencies for Ohkami benchmarks
# This attempts to vendor the crates so cargo can run offline.

set -euo pipefail

# navigate to workspace root of the 0.24 code
cd "$(dirname "$0")/ohkami-0.24"

# vendor dependencies if not already vendored
if [ ! -d vendor ]; then
    echo "Vendor directory not found. Running cargo vendor..."
    cargo vendor vendor > /tmp/vendor-config.toml
    mkdir -p .cargo
    cat /tmp/vendor-config.toml > .cargo/config.toml
fi

# fetch all dependencies (uses vendor if available)
cargo fetch
