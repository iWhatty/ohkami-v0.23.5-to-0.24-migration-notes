#!/bin/bash
# Setup script to prepare dependencies for Ohkami benchmarks
# This attempts to vendor the crates so cargo can run offline.

set -euo pipefail

# navigate to workspace root of the 0.24 code
cd "$(dirname "$0")/ohkami-0.24"

# always vendor crates for the core library and benches
echo "Vendoring dependencies for ohkami and benches..."
cargo vendor --sync ohkami/Cargo.toml --sync benches/Cargo.toml --no-delete \
    > /tmp/vendor-config.toml
mkdir -p .cargo
cp /tmp/vendor-config.toml .cargo/config.toml

# fetch all dependencies using the vendor directory
cargo fetch --manifest-path ohkami/Cargo.toml
