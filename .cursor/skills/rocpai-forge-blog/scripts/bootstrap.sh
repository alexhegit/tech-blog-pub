#!/usr/bin/env bash
# Bootstrap rocPAI-Forge blog workflow on a fresh machine.
# Usage: bash bootstrap.sh [WORK_DIR]
set -euo pipefail

WORK_DIR="${1:-${ROCPAI_WORK_DIR:-$HOME/rocpai-forge}}"
PUB_REPO="${PUB_REPO:-https://github.com/alexhegit/tech-blog-pub.git}"
SITE_REPO="${SITE_REPO:-https://github.com/rocPAI-Forge/rocPAI-Forge.github.io.git}"

echo "==> Work directory: $WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

clone_if_missing() {
  local name="$1" url="$2"
  if [[ -d "$name/.git" ]]; then
    echo "==> $name already exists — pulling latest"
    git -C "$name" pull --ff-only
  else
    echo "==> Cloning $name"
    git clone "$url" "$name"
  fi
}

clone_if_missing tech-blog-pub "$PUB_REPO"
clone_if_missing rocPAI-Forge.github.io "$SITE_REPO"

missing=()
for cmd in git python3 ffmpeg; do
  command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if [[ ${#missing[@]} -gt 0 ]]; then
  echo "WARNING: missing tools: ${missing[*]}"
fi

if command -v hugo >/dev/null 2>&1; then
  echo "==> Hugo: $(hugo version)"
else
  echo "NOTE: hugo not found — optional for local preview (extended 0.148.2)"
fi

echo "==> Running sync_from_pub.py"
cd rocPAI-Forge.github.io
python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .

echo ""
echo "Done. Open in Cursor:"
echo "  $WORK_DIR"
echo ""
echo "Next: cd $WORK_DIR/rocPAI-Forge.github.io && hugo server -D"
