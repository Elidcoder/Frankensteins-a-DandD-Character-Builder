#!/bin/bash
# Check Dart naming conventions guidelines
set -euo pipefail

# ColoUrs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

printf "%b\n" "${BLUE}🔍 Checking Dart naming conventions..."

# Find all Dart files that are staged for commit
staged_dart_files=$(git diff --cached --name-only --diff-filter=ACMR | grep '\.dart$' || true)

if [[ -z "$staged_dart_files" ]]; then
    printf "%b\n" "${GREEN}✅ No staged Dart files ${NC}"
    exit 0
fi

naming_issues=()

add_issue() { naming_issues+=("$1"); }

is_camel_case() { [[ "$1" =~ ^[a-z][a-zA-Z0-9]*$ ]]; }
is_pascal_case() { [[ "$1" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; }
is_snake_case() { [[ "$1" =~ ^[a-z][a-z0-9_]*$ ]]; }
is_screaming_snake_case() { [[ "$1" =~ ^[A-Z][A-Z0-9_]*$ ]]; }

# Iterate staged Dart files (NUL-delimited)
while IFS= read -r -d '' file; do
    [[ -f "$file" ]] || continue
    printf "%s\n" "Analyzing: $file..."

    filename=$(basename "$file" .dart)
    if ! is_snake_case "$filename"; then
        add_issue "$file: Filename should be snake_case, found: $filename"
    fi

    line_num=0
    in_block_comment=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))

        # Comment skipping
        if [[ "$line" =~ ^[[:space:]]*/\* ]]; then
            if [[ "$line" =~ \*/ ]]; then
                rest="${line#*\*/}"
                if [[ ! "$rest" =~ [^[:space:]] ]]; then
                    continue
                else
                    line="$rest"
                fi
            else
                in_block_comment=1
                continue
            fi
        fi

        if (( in_block_comment )); then
            if [[ "$line" =~ \*/ ]]; then
                in_block_comment=0
                rest="${line#*\*/}"
                if [[ ! "$rest" =~ [^[:space:]] ]]; then
                    continue
                else
                    line="$rest"
                fi
            else
                continue
            fi
        fi

        if [[ "$line" =~ ^[[:space:]]*// ]]; then
            continue
        fi


        if [[ "$line" =~ abstract[[:space:]]+class[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            class_name="${BASH_REMATCH[1]}"
            if ! is_pascal_case "$class_name"; then
                add_issue "$file:$line_num: Abstract class name should be PascalCase, found: $class_name"
            fi
        elif [[ "$line" =~ class[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            class_name="${BASH_REMATCH[1]}"
            if ! is_pascal_case "$class_name"; then
                add_issue "$file:$line_num: Class name should be PascalCase, found: $class_name"
            fi
        fi

        if [[ "$line" =~ enum[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            enum_name="${BASH_REMATCH[1]}"
            if ! is_pascal_case "$enum_name"; then
                add_issue "$file:$line_num: Enum name should be PascalCase, found: $enum_name"
            fi
        fi

        if [[ "$line" =~ mixin[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            mixin_name="${BASH_REMATCH[1]}"
            if ! is_pascal_case "$mixin_name"; then
                add_issue "$file:$line_num: Mixin name should be PascalCase, found: $mixin_name"
            fi
        fi

        if [[ "$line" =~ typedef[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            typedef_name="${BASH_REMATCH[1]}"
            if ! is_pascal_case "$typedef_name"; then
                add_issue "$file:$line_num: Typedef name should be PascalCase, found: $typedef_name"
            fi
        fi

        if [[ "$line" =~ extension[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            extension_name="${BASH_REMATCH[1]}"
            if ! is_pascal_case "$extension_name"; then
                add_issue "$file:$line_num: Extension name should be PascalCase, found: $extension_name"
            fi
        fi

        if [[ "$line" =~ ^[[:space:]]*(static[[:space:]]+)?([A-Za-z_][A-Za-z0-9_<>?.,\[\] ]+[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\( ]] &&
           [[ ! "$line" =~ (class|enum|mixin|typedef|extension|import|export|part|library) ]]; then
            func_name="${BASH_REMATCH[3]}"
            if [[ ! "$func_name" =~ ^(operator|main)$ ]] && [[ ! "$line" =~ \.$func_name\( ]]; then
                if ! is_pascal_case "$func_name" && ! is_camel_case "$func_name"; then
                    add_issue "$file:$line_num: Function name should be camelCase, found: $func_name"
                fi
            fi
        fi

        if [[ "$line" =~ ^[[:space:]]*(final|const|var|late)[[:space:]]+([a-zA-Z_<>?]*[[:space:]]+)?([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*= ]]; then
            var_name="${BASH_REMATCH[3]}"
        elif [[ "$line" =~ ^[[:space:]]*([a-zA-Z_][a-zA-Z0-9_<>?]*)[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*= ]]; then
            var_name="${BASH_REMATCH[2]}"
        else
            var_name=""
        fi

        if [[ -n "$var_name" ]]; then
            if [[ "$line" =~ const[[:space:]] ]]; then
                if ! is_screaming_snake_case "$var_name" && ! is_camel_case "$var_name"; then
                    add_issue "$file:$line_num: Constant should be SCREAMING_SNAKE_CASE or camelCase, found: $var_name"
                fi
            else
                if ! is_camel_case "$var_name"; then
                    add_issue "$file:$line_num: Variable name should be camelCase, found: $var_name"
                fi
            fi
        fi

        if [[ "$line" =~ ^[[:space:]]+(static[[:space:]]+)?(final[[:space:]]+|const[[:space:]]+)?([a-zA-Z_][a-zA-Z0-9_<>?]*[[:space:]]+)?([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*[=] ]] &&
           [[ ! "$line" =~ (class|enum|mixin|typedef|function|method) ]]; then
            field_name="${BASH_REMATCH[4]}"
            if [[ "$field_name" =~ ^_(.+)$ ]]; then
                actual_name="${BASH_REMATCH[1]}"
                if ! is_camel_case "$actual_name"; then
                    add_issue "$file:$line_num: Private field should be _camelCase, found: $field_name"
                fi
            else
                if ! is_camel_case "$field_name"; then
                    add_issue "$file:$line_num: Field name should be camelCase, found: $field_name"
                fi
            fi
        fi
    done < "$file"
done < <(git diff --cached -z --name-only --diff-filter=ACMR -- '*.dart')

issue_count=${#naming_issues[@]}
if (( issue_count > 0 )); then
    printf "%b\n" "${RED}❌ Found $issue_count naming convention issue(s):"
    printf "\n"
    for issue in "${naming_issues[@]}"; do printf "%s\n" "  $issue"; done
    printf "\n"
    printf "%b\n" "${YELLOW}To fix automatically: dart fix --apply"
    printf "%b\n" "To skip this check: git commit --no-verify${NC}"
    exit 1
else
    printf "%b\n" "${GREEN}✅ All naming conventions meet standards${NC}"
fi
