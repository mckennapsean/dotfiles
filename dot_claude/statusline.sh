#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract essential data from JSON
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"' | sed 's/ (.*//')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "Unknown"')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // "0"')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // "0"')

# Abbreviate directory path (fish shell style)
abbreviate_path() {
    local path="$1"
    local home_dir="$HOME"

    if [[ "$path" == "$home_dir"* ]]; then
        path="~${path#$home_dir}"
    fi

    IFS='/' read -ra parts <<< "$path"
    local result=""

    for i in "${!parts[@]}"; do
        if [[ -n "${parts[$i]}" ]]; then
            if [[ $i -eq $((${#parts[@]} - 1)) ]]; then
                result="${result:+$result/}${parts[$i]}"
            else
                result="${result:+$result/}${parts[$i]:0:1}"
            fi
        fi
    done

    echo "$result"
}

# Format cost for display
format_cost() {
    local cost="${1:-0}"
    printf "\$%.2f" "$cost"
}

# Format context percentage with color thresholds (green < 60%, yellow 60-79%, red 80%+)
format_context() {
    local pct="${1:-0}"
    local rounded=$(printf "%.0f" "$pct")
    if (( rounded >= 80 )); then
        printf "\033[31m%d%%\033[0m" "$rounded"
    elif (( rounded >= 60 )); then
        printf "\033[33m%d%%\033[0m" "$rounded"
    else
        printf "\033[32m%d%%\033[0m" "$rounded"
    fi
}

# Check sandbox status from settings files (highest precedence first)
check_sandbox() {
    local proj="$1"
    local files=(
        "$proj/.claude/settings.local.json"
        "$proj/.claude/settings.json"
        "$HOME/.claude/settings.local.json"
        "$HOME/.claude/settings.json"
    )

    for f in "${files[@]}"; do
        if [[ -f "$f" ]]; then
            # Check sandbox.enabled (set by /sandbox toggle)
            # Note: jq's // treats false as falsy, so use tostring instead
            local enabled
            enabled=$(jq -r '.sandbox.enabled | tostring' "$f" 2>/dev/null)
            if [[ "$enabled" == "false" ]]; then
                echo "off"
                return
            elif [[ "$enabled" == "true" ]]; then
                echo "on"
                return
            fi
        fi
    done
    echo "on"
}

# Build display components
abbrev_path=$(abbreviate_path "$current_dir")
formatted_cost=$(format_cost "$cost")
context_display=$(format_context "$context_pct")
sandbox_status=$(check_sandbox "$project_dir")

if [[ "$sandbox_status" == "on" ]]; then
    sandbox_display="🔒"
else
    sandbox_display=$'\033[33m⚠ Unsandboxed\033[0m'
fi

# Output: Path | Model (XX%) | 🔒 | $X.XX
printf "\033[36m%s\033[0m | \033[1m%s\033[0m (%s) | %s | \033[2m%s\033[0m" \
    "$abbrev_path" \
    "$model_name" \
    "$context_display" \
    "$sandbox_display" \
    "$formatted_cost"
