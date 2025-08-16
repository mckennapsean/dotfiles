function jj_prompt_info
    if not command -v jj >/dev/null 2>&1; or not test -d .jj
        return
    end

    set -l cache_file /tmp/jj_prompt_cache_(pwd | string replace -a '/' '_')
    
    # Always show cached data first (instant)
    if test -f "$cache_file"
        cat "$cache_file" 2>/dev/null
    end
    
    # Update cache in background if older than 5 seconds
    set -l cache_time (stat -c %Y "$cache_file" 2>/dev/null; or echo 0)
    set -l current_time (date +%s)
    if test (math "$current_time - $cache_time") -gt 5
        bash -c "
            change_id=\$(jj --ignore-working-copy --at-op=@ log -r '@' -T 'change_id.shortest(4)' 2>/dev/null | grep -o '[a-zA-Z0-9]\+' | head -1)
            if [ -n \"\$change_id\" ]; then
                result=\"@ \$change_id\"
                nearest_bookmark=\$(jj --ignore-working-copy --at-op=@ log -r 'heads(::@ & bookmarks())' -T 'bookmarks' 2>/dev/null | grep -o '[a-zA-Z0-9_-]\+' | head -1)
                if [ -n \"\$nearest_bookmark\" ]; then
                    distance=\$(jj --ignore-working-copy --at-op=@ log -r \"\$nearest_bookmark..@\" --no-graph -T '' 2>/dev/null | wc -l)
                    if [ \"\$distance\" -gt 1 ]; then
                        result=\"\$result | \$nearest_bookmark+\$((distance - 1))\"
                    else
                        result=\"\$result | \$nearest_bookmark\"
                    fi
                fi
                echo \"\$result\" > '$cache_file'
            fi
        " >/dev/null 2>&1 &
    end
end