#!/usr/bin/env bash
# Refresh rulesync outputs: resolve declarative skill sources, then regenerate
# tool-specific configs (see rulesync.jsonc). The CLI has generate, not build;
# install + generate covers the usual end-to-end refresh.
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$repo_root"


rulesync install
rulesync generate