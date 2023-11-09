if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/fenglielie/miniconda3/bin/conda
    eval /home/fenglielie/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

