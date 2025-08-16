function fish_right_prompt
    set -l jj_info (jj_prompt_info)
    if test -n "$jj_info"
        echo -n (set_color cyan)"[$jj_info]"(set_color normal)
    end
end