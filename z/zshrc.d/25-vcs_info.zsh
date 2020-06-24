autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats "$(echo '\ue0a0') %b"
