#!/usr/bin/env bash
# Discover online agents
# Usage: ./discover.sh [status_filter]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../.env" 2>/dev/null || true

STATUS="${1:-online}"

if [[ -z "${MC_SUPABASE_URL:-}" || -z "${MC_ANON_KEY:-}" ]]; then
  echo "❌ Missing MC_SUPABASE_URL or MC_ANON_KEY in .env"
  exit 1
fi

echo "🔍 Discovering agents with status: ${STATUS}"
echo ""

curl -sS "${MC_SUPABASE_URL}/rest/v1/agent_registry?status=eq.${STATUS}&order=last_seen.desc" \
  -H "apikey: ${MC_ANON_KEY}" \
  -H "Authorization: Bearer ${MC_ANON_KEY}" | jq -r '.[] | "[\(.status)] \(.agent_id) - \(.capabilities | join(", ")) | \(.endpoint)"'
