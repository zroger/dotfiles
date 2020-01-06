# Shell configuration for GPG

test -n "$GPG_TTY" && return

# GPG needs to be told what TTY it's running in.
GPG_TTY=$(tty)
export GPG_TTY

# This has the side-effect of starting the gpg agent if necessary.
gpg-connect-agent /bye

# Use the gpg-agent for ssh.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi
