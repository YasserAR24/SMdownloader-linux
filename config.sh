#!/usr/bin/env bash
# Creates .SMdownloadervenv next to this script and installs yt-dlp + flask in it.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.SMdownloadervenv"

command -v python3 >/dev/null 2>&1 || { echo "python3 not found. Run install_deps.sh first." >&2; exit 1; }
python3 -c "import venv" 2>/dev/null || { echo "python3-venv missing. Run install_deps.sh first." >&2; exit 1; }

if [ -d "$VENV_DIR" ]; then
  echo "[+] Venv already exists: $VENV_DIR"
else
  echo "[+] Creating venv: $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi

"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install --upgrade "yt-dlp[default]" flask

echo
echo "[+] Installed:"
"$VENV_DIR/bin/yt-dlp" --version | sed 's/^/yt-dlp /'
"$VENV_DIR/bin/python" -c "import flask; from importlib.metadata import version; print('flask', version('flask'))"
echo
read -p "Press Enter to exit..."
