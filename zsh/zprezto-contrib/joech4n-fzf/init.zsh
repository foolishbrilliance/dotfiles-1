# Fzf - A command-line fuzzy finder written in Go -  https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew
xsource ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 90% --reverse --border --exact'
# auto select if only 1 result, exit if no results
export FZF_CTRL_T_OPTS="--select-1 --exit-0 $FZF_CTRL_T_OPTS"

# Dedicated completion key
# > Instead of using `TAB` key with a trigger sequence (`**<TAB>`), you can assign a dedicated key for fuzzy completion while retaining the default behavior of `TAB` key.
# > https://github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion#dedicated-completion-key
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^[r' fzf-completion
bindkey '^I' $fzf_default_completion

# Prefer the following (in order) over find, if available
# - fd (https://github.com/sharkdp/fd)
# - rg (https://github.com/BurntSushi/ripgrep)
if ((${+FZF_FORCE_DEFAULT_SEARCH})); then
  # nop - i.e. use default file search, probably `find`
  # can set in ~/.zshrc.pre, which gets sourced by grml config
elif check_com -c fd; then
  # Setting fd as the default source for fzf
  export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden"
  export FZF_CTRL_T_COMMAND="fd --type file"
  export FZF_ALT_C_COMMAND="fd --type d"

  # Use fd for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
elif check_com -c rg; then
  export FZF_DEFAULT_COMMAND="rg --files --follow --hidden"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

if check_com -c bat; then
  # preview using bat
  export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
fi
# Preview full command in CTRL+R with ?
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

