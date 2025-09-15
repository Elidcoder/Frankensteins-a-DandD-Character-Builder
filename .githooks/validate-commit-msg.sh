#!/usr/bin/env bash
# Validate commit message first line styling
set -euo pipefail

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Read commit message file, fail on empty path
file="${1:-}"
[[ -n "$file" ]] || { printf '%b\n' "${RED}❌ No commit message file provided${NC}"; exit 1; }

# First line strips trailing stuff
message="$(sed -n '1{s/\r$//;s/[[:space:]]*$//;p}' -- "$file")"
full_msg="$(cat -- "$file")"

# Skip merges and reverts 
if [[ "$message" =~ ^(Merge|Revert)($|[[:space:]]) ]]; then
  printf '%b\n' "${GREEN}✅ Merge/Revert commit - skipping validation${NC}"
  exit 0
fi

printf '%b\n' "${BLUE}💬 Validating commit subject..."

# Format: type(scope?)!?: description
type_regex='feat|fix|perf|style|refactor|test|chore|docs|ci|build'
scope_regex='\([a-z0-9._/-]+\)'
pattern="^(${type_regex})((${scope_regex})?)!?: [^[:cntrl:]]{1,}$"

if [[ ! "$message" =~ $pattern ]]; then
  printf '%b\n' "${RED}❌ Invalid commit message format!"
  printf '%s\n' "Current message:"
  printf '%s\n' "$message"
  printf '\n'
  printf '%b\n' "${YELLOW}Expected:${NC} type(scope)!: description"
  exit 1
fi

# Max 72 chars
if (( ${#message} > 72 )); then
  printf '%b\n' "${RED}❌ message too long (${#message}). Keep it ≤ 72 characters.${NC}"
  exit 1
fi

# No trailing '.'
if [[ "$message" =~ \.$ ]]; then
  printf '%b\n' "${RED}❌ message should not end with a '.'${NC}"
  exit 1
fi

# Warn on uppercase anywhere
if [[ "$full_msg" =~ [A-Z] ]]; then
  printf '%b\n' "${YELLOW}⚠️  Consider using lowercase in the message.${NC}"
fi

printf '%b\n' "${GREEN}✅ Commit message is valid!"
printf '%b\n' "message:${NC}"
printf '%s\n' "$message"
