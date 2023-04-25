# pd: Previous Directory
# ~/.config/fish/functions/pd.fish
#
# Based on mcd (Menu cd) by Kurtis Rader (krader1961) 2016-2017
# https://github.com/fish-shell/fish-shell/issues/2847
#
# Changed by Evert Mouw to use fzf (2023)

# Provide a menu of the directories recently navigated to and ask the user
# to choose one to make the new current working directory (cwd).

function pd --description "cd into a previous directory using fzf"
    set -l all_dirs $dirprev $dirnext
    if not set -q all_dirs[1]
        echo 'No previous directories to select. You have to cd at least once.'
        return 0
    end
    if not which fzf > /dev/null
        echo 'The program `fzf` was not found.'
        return 1
    end

    # Eliminate duplicates; i.e., we only want the most recent visit to a
    # given directory in the selection list.
    # Also remove the currend directory from the list.
    set -l uniq_dirs
    for dir in $all_dirs[-1..1]
        if not contains $dir $uniq_dirs
            if test "$dir" != "$PWD"
                set uniq_dirs $uniq_dirs $dir
            end
        end
    end

    # Add the current directory back to the list.
    set uniq_dirs "$PWD" $uniq_dirs

    set selection (
        for dir in $uniq_dirs
            echo $dir
        end | fzf --no-sort --header "cd into a previous directory"
    )

    if test "$selection" != ""
        echo $selection
        cd $selection
    end

end
