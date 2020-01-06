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

    local ps1_bg="\e[48;5;0m"  #base02
    local ps1_bg_as_fg="\e[38;5;0m"  #base02

    if [[ "${ITERM_PROFILE}" == "Light" ]]; then
        ps1_bg="\e[48;5;7m"  #base02
        ps1_bg_as_fg="\e[38;5;7m"  #base02
    fi

    local ssh_bg="\e[48;5;3m"
    local ssh_bg_as_fg="\e[38;5;3m"

    local local_bg="\e[48;5;10m"
    local local_bg_as_fg="\e[38;5;10m"

    local black="\e[38;5;0m"
    local red="\e[38;5;1m"
    local green="\e[38;5;2m"
    local yellow="\e[38;5;3m"
    local blue="\e[38;5;4m"
    local magenta="\e[38;5;5m"
    local cyan="\e[38;5;6m"
    local white="\e[38;5;7m"
    local bright_black="\e[38;5;8m"
    local bright_red="\e[38;5;9m"
    local bright_green="\e[38;5;10m"
    local bright_yellow="\e[38;5;11m"
    local bright_blue="\e[38;5;12m"
    local bright_magenta="\e[38;5;13m"
    local bright_cyan="\e[38;5;14m"
    local bright_white="\e[38;5;15m"

    # solarized aliases
    local base03="\e[38;5;8m"
    local base02="\e[38;5;0m"
    local base01="\e[38;5;10m"
    local base00="\e[38;5;11m"
    local base0="\e[38;5;12m"
    local base1="\e[38;5;14m"
    local base2="\e[38;5;7m"
    local base3="\e[38;5;15m"
    local orange="\e[38;5;9m"
    local violet="\e[38;5;13m"

    local reset="\e[0m"


    # Always start on a clean line.
    PS1="\n"

    ## PS1 line 1
    #PS1+="\[${ps1_bg}\]"

    #if [[ -n "${SSH_CONNECTION}" ]]; then
    #    #PS1+="\[${ssh_bg}${base02}\] ⇄  \h ${ssh_bg_as_fg}${ps1_bg}\] "
    #    PS1+="\[${ssh_bg}${black}\] @ \h ${ssh_bg_as_fg}${ps1_bg}\] "
    #    PS1+="\[${yellow}\]\$(__ps1_pwd) "
    #else
    #    PS1+="\[${local_bg}${base2}\]  ${local_bg_as_fg}${ps1_bg}\] "
    #    PS1+="\[${yellow}\]\$(__ps1_pwd) "
    #fi

    #PS1+=" \[${blue}\]\$(__ps1_git_info) "
    #PS1+="\[\e[K\]"  # Fill the rest of the line w/ the bg color.

    ## PS1 line 2
    #PS1+="\n"
    #PS1+="\$(__ps1_exit_code $exit_code \"\[${green}\]\" \"\[${red}\]\" )"
    #PS1+="\[${base1}\] \D{%H:%M:%S} "  # Time
    #PS1+="\$ \[$reset\]"
    #PS1+="\[${ps1_bg_as_fg}\]"  # End prompt with powerline arrow.
    #PS1+="\[${reset}\] "

    # Command continuation prompt
    PS2="\[${ps1_bg}\] … "
    PS2+="\[${reset}\]\[${ps1_bg_as_fg}\]\[${reset}\] "

    PS1+="\[${white}\] "
    PS1+="\[${yellow}\]  \$(__ps1_pwd)"
    PS1+="\[${blue}\]  \$(__ps1_git_info)"
    if [[ -z "$AWS_VAULT" && -n "$AWS_VAULT_LABEL" ]]; then
        unset AWS_VAULT_LABEL
    elif [[ -n "$AWS_VAULT" && -z "$AWS_VAULT_LABEL" ]]; then
        local arn=$(aws sts get-caller-identity --query Arn --output text)
        export AWS_VAULT_LABEL=$(echo "$arn" | cut -d: -f6)
    fi
    if [[ -n "$AWS_VAULT_LABEL" ]]; then
        PS1+="\[${orange}\]  🔒\${AWS_VAULT_LABEL} "
    fi
    PS1+="\[${reset}\]\n"
    PS1+="\$(__ps1_exit_code $exit_code \"\[${green}\]\" \"\[${red}\]\" )"
    PS1+="\[${cyan}\]  \D{%H:%M:%S} » \[${reset}\]  "
}
PROMPT_COMMAND=__build_prompts
