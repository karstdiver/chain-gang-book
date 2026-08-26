#!/usr/bin/env bash
# repo-status.sh — human-readable git status for chain-gang-book
# Report only; does not fetch, commit, or change the working tree.
# Auth checks are best-effort and may use the network.
# Exit 0 unless this is not a git repo / git is missing.

set -euo pipefail

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is not on PATH."
  exit 1
fi

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${ROOT}" ]]; then
  echo "Error: not inside a git repository."
  exit 1
fi
cd "${ROOT}"

BRANCH="$(git branch --show-current 2>/dev/null || true)"
if [[ -z "${BRANCH}" ]]; then
  BRANCH="(detached HEAD)"
fi

HEAD_SHORT="$(git log -1 --format='%h %s' 2>/dev/null || echo '(no commits)')"

# Remote name / URL (origin)
REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
REMOTE_PROTOCOL="unknown"
REMOTE_NAME="(unknown)"
if [[ -z "${REMOTE_URL}" ]]; then
  REMOTE_LINE="Remote:     (no origin remote)"
  URL_LINE="URL:        (n/a)"
else
  if [[ "${REMOTE_URL}" == git@*:* ]]; then
    REMOTE_PROTOCOL="ssh"
    # git@github.com:owner/repo.git
    REMOTE_NAME="${REMOTE_URL#*:}"
    REMOTE_NAME="${REMOTE_NAME%.git}"
  elif [[ "${REMOTE_URL}" == ssh://* ]]; then
    REMOTE_PROTOCOL="ssh"
    REMOTE_NAME="${REMOTE_URL#ssh://}"
    REMOTE_NAME="${REMOTE_NAME#*github.com/}"
    REMOTE_NAME="${REMOTE_NAME#*/}" # rare path forms
    # Prefer owner/repo from path after host
    if [[ "${REMOTE_URL}" =~ ssh://[^/]+/(.+)$ ]]; then
      REMOTE_NAME="${BASH_REMATCH[1]}"
      REMOTE_NAME="${REMOTE_NAME%.git}"
    fi
  elif [[ "${REMOTE_URL}" == https://* || "${REMOTE_URL}" == http://* ]]; then
    REMOTE_PROTOCOL="https"
    REMOTE_NAME="${REMOTE_URL#https://}"
    REMOTE_NAME="${REMOTE_NAME#http://}"
    REMOTE_NAME="${REMOTE_NAME#github.com/}"
    REMOTE_NAME="${REMOTE_NAME%.git}"
  else
    REMOTE_PROTOCOL="other"
    REMOTE_NAME="${REMOTE_URL}"
  fi
  REMOTE_LINE="Remote:     ${REMOTE_NAME}"
  URL_LINE="URL:        ${REMOTE_URL}  (${REMOTE_PROTOCOL})"
fi

# Best-effort auth (may touch the network)
AUTH_WARN=0
GH_PART="gh: (not installed)"
SSH_PART=""

GH_BIN="$(command -v gh 2>/dev/null || true)"
if [[ -z "${GH_BIN}" && -x /usr/local/bin/gh ]]; then
  GH_BIN="/usr/local/bin/gh"
fi

if [[ -n "${GH_BIN}" ]]; then
  GH_OUT="$("${GH_BIN}" auth status 2>&1 || true)"
  if printf '%s\n' "${GH_OUT}" | grep -q 'Logged in to github.com'; then
    GH_USER="$(printf '%s\n' "${GH_OUT}" | sed -n 's/.*Logged in to github.com account \([^ ]*\).*/\1/p' | head -1)"
    if [[ -z "${GH_USER}" ]]; then
      GH_USER="(unknown user)"
    fi
    if printf '%s\n' "${GH_OUT}" | grep -qi 'token.*invalid\|Failed to log in\|authentication failed'; then
      GH_PART="gh: logged in as ${GH_USER}, but token looks invalid"
      AUTH_WARN=1
    else
      GH_PART="gh: logged in as ${GH_USER}"
    fi
  elif printf '%s\n' "${GH_OUT}" | grep -qi 'not logged\|You are not logged\|no github.com credentials\|Failed to log in\|token in keyring is invalid'; then
    GH_PART="gh: not logged in / token invalid"
    AUTH_WARN=1
  else
    GH_PART="gh: status unclear (run: gh auth status)"
  fi
fi

if [[ "${REMOTE_PROTOCOL}" == "ssh" ]]; then
  if command -v ssh >/dev/null 2>&1; then
    SSH_TRY="$(ssh -T -o BatchMode=yes -o ConnectTimeout=5 git@github.com 2>&1 || true)"
    if printf '%s\n' "${SSH_TRY}" | grep -qiE 'successfully authenticated|Hi .+!'; then
      SSH_PART="ssh: OK"
    elif printf '%s\n' "${SSH_TRY}" | grep -qiE 'Permission denied|publickey'; then
      SSH_PART="ssh: failed (Permission denied)"
      AUTH_WARN=1
    elif printf '%s\n' "${SSH_TRY}" | grep -qiE 'Could not resolve|Connection timed out|Network is unreachable'; then
      SSH_PART="ssh: unavailable (network)"
    else
      SSH_PART="ssh: unclear"
    fi
  else
    SSH_PART="ssh: (ssh not installed)"
  fi
elif [[ "${REMOTE_PROTOCOL}" == "https" ]]; then
  SSH_PART="ssh: n/a (origin is https)"
fi

if [[ -n "${SSH_PART}" ]]; then
  AUTH_LINE="Auth:       ${GH_PART}; ${SSH_PART}"
else
  AUTH_LINE="Auth:       ${GH_PART}"
fi

UPSTREAM="$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || true)"
if [[ -n "${UPSTREAM}" ]]; then
  TRACKING_LINE="Tracking:   ${UPSTREAM}"
else
  TRACKING_LINE="Tracking:   (no upstream — branch not pushed, or not set)"
fi

# Working tree
DIRTY=0
PORCELAIN="$(git status --porcelain 2>/dev/null || true)"
if [[ -n "${PORCELAIN}" ]]; then
  DIRTY=1
  TOTAL="$(printf '%s\n' "${PORCELAIN}" | grep -c . || true)"
  UNTRACKED="$(printf '%s\n' "${PORCELAIN}" | grep -cE '^\?\?' || true)"
  CHANGED=$((TOTAL - UNTRACKED))
  TREE_LINE="Tree:       dirty — ${CHANGED} modified/staged, ${UNTRACKED} untracked (${TOTAL} total)"
else
  TREE_LINE="Tree:       clean (nothing to commit)"
fi

# Sync vs origin/main (uses last fetched refs; no network fetch)
MAIN_REF="origin/main"
if git show-ref --verify --quiet "refs/remotes/${MAIN_REF}"; then
  AHEAD_MAIN="$(git rev-list --count "${MAIN_REF}..HEAD" 2>/dev/null || echo 0)"
  BEHIND_MAIN="$(git rev-list --count "HEAD..${MAIN_REF}" 2>/dev/null || echo 0)"
  if [[ "${BRANCH}" == "main" ]]; then
    if [[ "${AHEAD_MAIN}" -eq 0 && "${BEHIND_MAIN}" -eq 0 ]]; then
      SYNC_LINE="Sync:       up to date with ${MAIN_REF}"
      SYNC_STATE="uptodate"
    elif [[ "${AHEAD_MAIN}" -gt 0 && "${BEHIND_MAIN}" -eq 0 ]]; then
      SYNC_LINE="Sync:       ahead of ${MAIN_REF} by ${AHEAD_MAIN} commit(s) (local commits not pushed?)"
      SYNC_STATE="ahead"
    elif [[ "${AHEAD_MAIN}" -eq 0 && "${BEHIND_MAIN}" -gt 0 ]]; then
      SYNC_LINE="Sync:       behind ${MAIN_REF} by ${BEHIND_MAIN} commit(s) — run: git pull"
      SYNC_STATE="behind"
    else
      SYNC_LINE="Sync:       diverged from ${MAIN_REF} (ahead ${AHEAD_MAIN}, behind ${BEHIND_MAIN})"
      SYNC_STATE="diverged"
    fi
  else
    if [[ "${AHEAD_MAIN}" -eq 0 && "${BEHIND_MAIN}" -eq 0 ]]; then
      SYNC_LINE="Sync:       same commit as ${MAIN_REF} (no unique commits yet)"
      SYNC_STATE="same"
    elif [[ "${BEHIND_MAIN}" -gt 0 && "${AHEAD_MAIN}" -eq 0 ]]; then
      SYNC_LINE="Sync:       behind ${MAIN_REF} by ${BEHIND_MAIN} — consider merging/rebasing main"
      SYNC_STATE="behind"
    elif [[ "${AHEAD_MAIN}" -gt 0 && "${BEHIND_MAIN}" -eq 0 ]]; then
      SYNC_LINE="Sync:       ${AHEAD_MAIN} commit(s) on this branch not in ${MAIN_REF}"
      SYNC_STATE="ahead"
    else
      SYNC_LINE="Sync:       diverged from ${MAIN_REF} (ahead ${AHEAD_MAIN}, behind ${BEHIND_MAIN})"
      SYNC_STATE="diverged"
    fi
  fi
else
  SYNC_LINE="Sync:       ${MAIN_REF} not found locally — run: git fetch"
  SYNC_STATE="unknown"
  AHEAD_MAIN=0
  BEHIND_MAIN=0
fi

# Upstream sync for current branch (if any)
if [[ -n "${UPSTREAM}" ]]; then
  AHEAD_UP="$(git rev-list --count "@{upstream}..HEAD" 2>/dev/null || echo 0)"
  BEHIND_UP="$(git rev-list --count "HEAD..@{upstream}" 2>/dev/null || echo 0)"
  if [[ "${AHEAD_UP}" -eq 0 && "${BEHIND_UP}" -eq 0 ]]; then
    UP_SYNC_LINE="Upstream:   up to date with ${UPSTREAM}"
  elif [[ "${AHEAD_UP}" -gt 0 && "${BEHIND_UP}" -eq 0 ]]; then
    UP_SYNC_LINE="Upstream:   ahead of ${UPSTREAM} by ${AHEAD_UP} (need push)"
  elif [[ "${AHEAD_UP}" -eq 0 && "${BEHIND_UP}" -gt 0 ]]; then
    UP_SYNC_LINE="Upstream:   behind ${UPSTREAM} by ${BEHIND_UP} (need pull)"
  else
    UP_SYNC_LINE="Upstream:   diverged from ${UPSTREAM} (ahead ${AHEAD_UP}, behind ${BEHIND_UP})"
  fi
else
  UP_SYNC_LINE="Upstream:   n/a"
fi

# Verdict
VERDICT_LEVEL="ok"   # ok | caution | stop
VERDICT="Safe to edit?  Yes."
NOTE=""

if [[ "${BRANCH}" == "(detached HEAD)" ]]; then
  VERDICT_LEVEL="stop"
  VERDICT="Safe to edit?  Stop — detached HEAD."
  NOTE="Check out a branch before editing: git checkout main"
elif [[ "${DIRTY}" -eq 1 && "${BRANCH}" == "main" ]]; then
  VERDICT_LEVEL="caution"
  VERDICT="Safe to edit?  Caution — dirty tree on main."
  NOTE="Commit/stash these changes, then start a feature branch before new work."
elif [[ "${DIRTY}" -eq 1 ]]; then
  VERDICT_LEVEL="caution"
  VERDICT="Safe to edit?  Caution — dirty working tree."
  NOTE="Finish or commit current work (or stash) before starting something unrelated."
elif [[ "${BRANCH}" == "main" && "${SYNC_STATE}" == "uptodate" ]]; then
  VERDICT_LEVEL="ok"
  VERDICT="Safe to edit?  Yes — on main and clean."
  NOTE="Create a feature branch before changing files: git checkout -b your-change"
elif [[ "${BRANCH}" == "main" && "${SYNC_STATE}" == "behind" ]]; then
  VERDICT_LEVEL="caution"
  VERDICT="Safe to edit?  Caution — main is behind origin/main."
  NOTE="Run: git pull   then create a feature branch."
elif [[ "${BRANCH}" == "main" ]]; then
  VERDICT_LEVEL="caution"
  VERDICT="Safe to edit?  Caution — on main."
  NOTE="Prefer a feature branch for edits. Check sync/push state above."
elif [[ "${SYNC_STATE}" == "diverged" ]]; then
  VERDICT_LEVEL="stop"
  VERDICT="Safe to edit?  Stop — branch has diverged from origin/main."
  NOTE="Reconcile with main before more edits to avoid painful merges."
elif [[ "${SYNC_STATE}" == "behind" ]]; then
  VERDICT_LEVEL="caution"
  VERDICT="Safe to edit?  Caution — branch is behind origin/main."
  NOTE="Update from main before / while editing to avoid painful merges."
else
  VERDICT_LEVEL="ok"
  VERDICT="Safe to edit?  Yes — on feature branch '${BRANCH}', tree clean."
  NOTE="Continue work here, then commit / push / PR when ready."
fi

if [[ "${AUTH_WARN}" -eq 1 ]]; then
  if [[ "${VERDICT_LEVEL}" == "ok" ]]; then
    VERDICT_LEVEL="caution"
    VERDICT="Safe to edit?  Caution — auth may block push/PR."
  fi
  if [[ -n "${NOTE}" ]]; then
    NOTE="${NOTE} Also check Auth above (gh login / SSH keys)."
  else
    NOTE="Check Auth above (gh login / SSH keys) before push/PR."
  fi
fi

# Colored icon for verdict (TTY only; plain emoji otherwise)
if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[1;32m'
  C_YELLOW=$'\033[1;33m'
  C_RED=$'\033[1;31m'
else
  C_RESET="" C_GREEN="" C_YELLOW="" C_RED=""
fi

case "${VERDICT_LEVEL}" in
  ok)
    VERDICT_ICON="${C_GREEN}✅${C_RESET}"
    VERDICT_COLOR="${C_GREEN}"
    ;;
  caution)
    VERDICT_ICON="${C_YELLOW}⚠️${C_RESET}"
    VERDICT_COLOR="${C_YELLOW}"
    ;;
  stop)
    VERDICT_ICON="${C_RED}🛑${C_RESET}"
    VERDICT_COLOR="${C_RED}"
    ;;
  *)
    VERDICT_ICON="•"
    VERDICT_COLOR=""
    ;;
esac

# "Safe to edit?" stays default color; only icon + verdict phrase are colored.
VERDICT_TAIL="${VERDICT#Safe to edit?  }"

echo ""
echo "Repo status"
echo "==========="
echo "Root:       ${ROOT}"
echo "${REMOTE_LINE}"
echo "${URL_LINE}"
echo "${AUTH_LINE}"
echo "Branch:     ${BRANCH}"
echo "${TRACKING_LINE}"
echo "${SYNC_LINE}"
echo "${UP_SYNC_LINE}"
echo "${TREE_LINE}"
echo "HEAD:       ${HEAD_SHORT}"
echo ""
printf 'Safe to edit?  %b  %b%s%b\n' "${VERDICT_ICON}" "${VERDICT_COLOR}" "${VERDICT_TAIL}" "${C_RESET}"
if [[ -n "${NOTE}" ]]; then
  echo "             ${NOTE}"
fi
echo ""
echo "Note: Sync uses last-fetched remotes (no network). Run 'git fetch' to refresh."
echo "      Auth is best-effort and may use the network."
echo ""
