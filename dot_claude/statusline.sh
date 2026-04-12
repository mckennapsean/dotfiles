#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract essential data from JSON
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "Unknown"')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // "0"')

# Function to abbreviate directory path (fish shell style)
abbreviate_path() {
    local path="$1"
    local home_dir="$HOME"
    
    # Replace home directory with ~
    if [[ "$path" == "$home_dir"* ]]; then
        path="~${path#$home_dir}"
    fi
    
    # Split path into components
    IFS='/' read -ra ADDR <<< "$path"
    local result=""
    
    for i in "${!ADDR[@]}"; do
        if [[ -n "${ADDR[$i]}" ]]; then
            if [[ $i -eq $((${#ADDR[@]} - 1)) ]]; then
                # Last component - show full name
                if [[ -n "$result" ]]; then
                    result="$result/${ADDR[$i]}"
                else
                    result="${ADDR[$i]}"
                fi
            else
                # Not last component - abbreviate to first letter
                if [[ -n "$result" ]]; then
                    result="$result/${ADDR[$i]:0:1}"
                else
                    result="${ADDR[$i]:0:1}"
                fi
            fi
        fi
    done
    
    echo "$result"
}

# Function to format cost for display
format_cost() {
    local cost="$1"
    if [[ -n "$cost" && "$cost" != "0" ]]; then
        # Format as simple dollar amount with 2 decimal places
        printf "\$%.2f" "$cost"
    else
        echo "\$0.00"
    fi
}


# Get data for display
formatted_cost=$(format_cost "$cost")
abbrev_path=$(abbreviate_path "$current_dir")

# Output the status line (Path | Model | Cost)
printf "\033[36m%s\033[0m | \033[1m%s\033[0m | \033[2m%s\033[0m" \
    "$abbrev_path" \
    "$model_name" \
    "$formatted_cost"