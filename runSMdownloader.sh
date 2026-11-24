#!/usr/bin/env bash
set -euo pipefail

# Always run relative to the script's folder, regardless of where it's called from
cd "$(dirname "${BASH_SOURCE[0]}")"

VENV_PY="$PWD/.SMdownloadervenv/bin/python"
HOST=127.0.0.1
PORT=5000
URL="http://$HOST:$PORT"

[ -x "$VENV_PY" ] || { echo "Venv not found. Run setup_venv.sh first." >&2; exit 1; }
[ -d app-files ]  || { echo "app-files folder not found." >&2; exit 1; }

cd app-files

# Start the server in the background (venv python directly, no activation needed)
"$VENV_PY" SMdownloader.py &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM

# Wait until the server accepts connections (max ~30s), bail if it crashes
for _ in $(seq 1 60); do
  kill -0 "$SERVER_PID" 2>/dev/null || { echo "Server exited unexpectedly." >&2; exit 1; }
  (exec 3<>"/dev/tcp/$HOST/$PORT") 2>/dev/null && break
  sleep 0.5
done

# Open the browser only once the server is ready
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL" >/dev/null 2>&1 &
else
  echo "Open $URL in your browser."
fi

# Keep running until the server stops (Ctrl+C stops it cleanly)
wait "$SERVER_PID"
