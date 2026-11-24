#!/usr/bin/env bash
# Installs: python3 + venv, ffmpeg, deno
# Supports: Debian/Ubuntu (apt), Arch (pacman), Fedora (dnf)
set -euo pipefail

log()  { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

# --- privilege handling ---
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  command -v sudo >/dev/null 2>&1 || die "Run as root or install sudo."
  SUDO="sudo"
fi

# --- detect distro family ---
[ -r /etc/os-release ] || die "Cannot detect distro (/etc/os-release missing)."
# shellcheck disable=SC1091
. /etc/os-release
ID_ALL="${ID:-} ${ID_LIKE:-}"

case " $ID_ALL " in
  *" debian "*|*" ubuntu "*) FAMILY="debian" ;;
  *" arch "*)                FAMILY="arch" ;;
  *" fedora "*)              FAMILY="fedora" ;;
  *) die "Unsupported distro: ${PRETTY_NAME:-unknown}" ;;
esac
log "Detected family: $FAMILY (${PRETTY_NAME:-})"

# --- deno via official installer (used where no native package exists) ---
install_deno_official() {
  if command -v deno >/dev/null 2>&1; then
    log "deno already installed: $(deno --version | head -n1)"
    return
  fi
  log "Installing deno via official installer into /usr/local"
  command -v curl  >/dev/null 2>&1 || die "curl is required."
  command -v unzip >/dev/null 2>&1 || die "unzip is required."
  curl -fsSL https://deno.land/install.sh | $SUDO env DENO_INSTALL=/usr/local sh -s -- -y
}

case "$FAMILY" in
  debian)
    $SUDO apt-get update
    $SUDO apt-get install -y python3 python3-venv python3-pip ffmpeg curl unzip ca-certificates
    install_deno_official
    ;;
  arch)
    # python on Arch already includes venv
    $SUDO pacman -Syu --needed --noconfirm python python-pip ffmpeg deno
    ;;
  fedora)
    # python3 on Fedora already includes venv
    $SUDO dnf install -y python3 python3-pip curl unzip
    if command -v ffmpeg >/dev/null 2>&1; then
      log "ffmpeg already installed"
    else
      # full ffmpeg needs RPM Fusion; fall back to Fedora's ffmpeg-free
      $SUDO dnf install -y ffmpeg || {
        warn "ffmpeg not in enabled repos, installing ffmpeg-free"
        $SUDO dnf install -y ffmpeg-free
      }
    fi
    install_deno_official
    ;;
esac

# --- verify ---
echo
log "Verification:"
python3 --version
python3 -c "import venv; print('venv: OK')"
ffmpeg -version | head -n1
deno --version | head -n1
echo
read -p "Press Enter to exit..."
