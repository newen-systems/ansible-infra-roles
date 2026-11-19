#!/usr/bin/env bash
# Syntax-check every runnable playbook against the example inventory.
#   scripts/syntax-check.sh            (run from anywhere; needs collections installed)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${root}"
inv="inventories/example/hosts.yml"

# Not playbooks, same list as exclude_paths in .ansible-lint.
skip=(
  audit_multi_logger.yml audit_multi_play.yml audit_semaphore.yml
  audit_single_logger.yml networks_views.yml pools.yml
)

# Some plays decrypt vaulted group_vars at parse time; any value parses.
export ANSIBLE_VAULT_PASSWORD="${ANSIBLE_VAULT_PASSWORD:-syntax-check}"

fail=0
for pb in playbooks/*.yml; do
  name="$(basename "${pb}")"
  if printf '%s\n' "${skip[@]}" | grep -qx "${name}"; then
    echo "skip  ${name}"
    continue
  fi
  if out="$(ansible-playbook -i "${inv}" --syntax-check "${pb}" 2>&1)"; then
    echo "ok    ${name}"
  else
    echo "FAIL  ${name}"
    echo "${out}" | grep -E "ERROR|error" | head -3
    fail=1
  fi
done
exit "${fail}"
