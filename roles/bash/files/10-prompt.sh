#!/usr/bin/env bash
#
# Set up the bash prompt.
#
# The __ps1 prefixed functions exist to be called from the prompts.

__ps1_exit_code() {
    local exit_code=$1
    local green=$2
    local red=$3
    if [ ${exit_code:-0} -ne 0 ]; then
        printf "$red ✗ [$exit_code] "
    else
        printf "$green ✓ "
    fi
}

__ps1_pwd() {
    printf "${PWD/$HOME/~}"
}

__ps1_git_info() {
    [ -x "$(which git)" ] || return    # git not found
    local GIT_BRANCH_SYMBOL=' '
    local GIT_BRANCH_CHANGED_SYMBOL='+'
    local GIT_NEED_PUSH_SYMBOL='⇡'
    local GIT_NEED_PULL_SYMBOL='⇣'

    # force git output in English to make our work easier
    local git_eng="env LANG=C git"
    # get current branch name or short SHA1 hash for detached head
    local branch
    branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || \
        $git_eng describe --tags --always 2>/dev/null)"
    [ -n "$branch" ] || return  # git branch not found

    local marks

    # branch is modified?
    [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

    # how many commits local branch is ahead/behind of remote?
    local stat
    stat="$($git_eng status --porcelain --branch \
        | grep '^##' | grep -o '\[.\+\]$')"
    local aheadN
    aheadN="$(echo "$stat" \
        | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    local behindN
    behindN="$(echo "$stat" \
        | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
    [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

    # print the git branch segment without a trailing newline
    printf " %s%s%s " "$GIT_BRANCH_SYMBOL" "$branch" "$marks"
}


__build_prompts() {
    local exit_code=$?

    local red="\e[38;5;1m"
    local green="\e[38;5;2m"
    local yellow="\e[38;5;3m"
    local blue="\e[38;5;4m"
    local magenta="\e[38;5;5m"
    local cyan="\e[38;5;6m"
    local white="\e[38;5;7m"

    # solarized aliases
    local orange="\e[38;5;9m"
    local violet="\e[38;5;13m"

    local reset="\e[0m"


    # Always start on a clean line.
    PS1="\n"
    PS1+="\[${white}\] "
    PS1+="\[${yellow}\]  \$(__ps1_pwd)"
    PS1+="\[${blue}\]  \$(__ps1_git_info)"
    PS1+="\[${reset}\]\n"
    PS1+="\$(__ps1_exit_code $exit_code \"\[${green}\]\" \"\[${red}\]\" )"
    PS1+="\[${cyan}\]  \D{%H:%M:%S} » \[${reset}\]  "
}

PROMPT_COMMAND=__build_prompts
