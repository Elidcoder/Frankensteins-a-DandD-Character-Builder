#!/bin/bash
# Prevent direct commits to master, warn on bad branch names
set -euo pipefail

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

printf "%b\n" "${BLUE}🔍 Checking branch protection rules..."

# Block commits to master
if [[ "$current_branch" == "master" ]]; then
    printf "%b\n" "${RED}❌ Direct commits to 'master' are not allowed!"
    printf "\n"
    printf "%b\n" "${YELLOW}Fix by checking out to a new branch:${NC}"
    printf "%s\n" "  git checkout -b type/your-branch-name"
    exit 1
fi

# Warn on bad branch names (not starting with type/)
if [[ ! "$current_branch" =~ ^(feat|fix|perf|style|refactor|test|chore|docs|ci|build)/ ]]; then
    printf "%b\n" "${YELLOW}⚠️  Branch name doesn't follow conventional naming."
    printf "%b\n" "Consider starting branch names with a type/"
    printf "%b\n" "Current branch: $current_branch"
    printf "\n"
    printf "%b\n" "This is a warning - commit will proceed."
fi

printf "%b\n" "${GREEN}✅ Branch protection check passed: $current_branch${NC}"
