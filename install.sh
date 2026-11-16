#!/usr/bin/env bash
# One-liner install for rocai-cloudflare plugin (hermes-agent v0.3.0+ compatible)
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/ivansslo/rocai-cloudflare/main/install.sh | bash
#
set -euo pipefail

PLUGIN_DIR="$HOME/.hermes/plugins/rocai-cloudflare"
REPO="https://github.com/ivansslo/rocai-cloudflare.git"
TMP_DIR="$(mktemp -d)"

echo "Installing rocai-cloudflare plugin..."

# Clone just the plugin directory (shallow, single-branch)
git clone --depth 1 --single-branch "$REPO" "$TMP_DIR" 2>/dev/null

# Copy plugin into place
mkdir -p "$HOME/.hermes/plugins"
rm -rf "$PLUGIN_DIR"
cp -r "$TMP_DIR/rocai-cloudflare-plugin" "$PLUGIN_DIR"

# Install Python dependency (httpx) if missing
if ! python3 -c "import httpx" 2>/dev/null; then
    echo "Installing httpx..."
    pip install httpx 2>/dev/null || pip3 install httpx 2>/dev/null || echo "Warning: could not install httpx — install it manually"
fi

# Cleanup
rm -rf "$TMP_DIR"

echo "rocai-cloudflare plugin installed to $PLUGIN_DIR"
echo "  Set CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID in your environment."
echo "  Restart hermes-gateway, then run /plugins to verify."
