# zsh aliases

# fasd
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init auto >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# fasd & fzf change directory - jump using `fasd` if given argument, filter output of `fasd` using `fzf` else
unalias z # TODO this is being defined somewhere and causing conflicts
z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

alias zz='fasd_cd -d -i' # cd with interactive selection
alias e='f -e $EDITOR' # quick opening files with vim
alias o='a -e open' # quick opening files with open (OSX)

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# c - fuzzy browse chrome history
c() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
  from urls order by last_visit_time desc" |
    awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
    fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

alias calc='bc <<<'

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# cdp - cd to selected parent directory (fdr from https://github.com/junegunn/fzf/wiki/examples)
cdp() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}

alias cl="fc -e -|pbcopy && echo Copied output of last command to clipboard"
alias clitxt='curl -sF "upfile=@-" https://clitxt.com |tee /dev/tty | pbcopy'

edownload() {
    if [ $# -ne 2 ];
    then
        echo -e "Wrong arguments specified. Usage example:\nedownload https://transfer.sh/nPIxk/test.txt /tmp/test"
        return 1
    fi
    curl $1| gpg -dio- > $2
}
alias e2u=epoch2utc
alias epoch='date +%s'

epoch2utc() { perl -e "print scalar(localtime($1)) . ' UTC'" } # Usage: epoch2utc 1395249613

etransfer() {
  cat $1|gpg -ac -o-|curl --progress-bar -X PUT --upload-file "-" https://transfer.sh/test.txt |tee
}

# fcd - cd to selected directory
# from https://github.com/junegunn/fzf/wiki/examples | change to fcd to avoid conflict with https://github.com/sharkdp/fd
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fuzzy find clipboard Alfred history
alias fclip='sqlite3 -header -csv ~/Library/Application\ Support/Alfred\ 3/Databases/clipboard.alfdb "select * from clipboard" |fzf |pbcopy'

alias fpath='perl -MCwd -e "print Cwd::abs_path shift"' # cpath is another alias, think "canonical path"

# fe - fuzzy edit
fe() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fasd & fzf edit file - open best matched file using `fasd` if given argument, filter output of `fasd` using `fzf` else
ff() {
    [ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return
    local file
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}

# fv - fuzzy view
fv() {
    local file
    if [[ -e "$1" ]]; then
        les "$1"
    else
        file=$(fzf --query="$1"\
          --select-1 --exit-0)
        [ -n "$file" ] && les "$file"
    fi
}

# Git aliases from zprezto: https://github.com/sorin-ionescu/prezto/blob/master/modules/git/alias.zsh

# Log
zstyle -s ':prezto:module:git:log:medium' format '_git_log_medium_format' \
  || _git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
zstyle -s ':prezto:module:git:log:oneline' format '_git_log_oneline_format' \
  || _git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
zstyle -s ':prezto:module:git:log:brief' format '_git_log_brief_format' \
  || _git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
# Commit (c)
alias gcm='git commit --message'
# Index (i)
alias gia='git add'
alias gid='git diff --no-ext-diff --cached'
alias giD='git diff --no-ext-diff --cached --word-diff'
# Log (l)
alias gl='git log --topo-order --pretty=format:"${_git_log_medium_format}"'
alias gls='git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'
alias gld='git log --topo-order --stat --patch --full-diff --pretty=format:"${_git_log_medium_format}"'
alias glo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"'
alias glb='git log --topo-order --pretty=format:"${_git_log_brief_format}"'
alias glc='git shortlog --summary --numbered'
# Working Copy (w)
alias gwd='git diff --no-ext-diff'
alias gwD='git diff --no-ext-diff --word-diff'
alias gws='git status --short'
alias gwS='git status'

# From https://gist.github.com/vlymar/4e43dbeae70ff71f861d
# fuzzy multi-select modified file
gfmod() {
  git ls-files -m | fzf -m
}
# stage files multi-selected modified files
gfadd() {
  git add $(gfmod)
}

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias github="open \`git remote -v | grep github.com | grep fetch | head -1 | field 2 | sed 's/git:/http:/g'\`"
alias gityolo="git commit -am 'Updating everything.'; git push origin master"
alias gpm="git push origin master"
alias irca='growl-irc.sh; ssh -t trundle tmux attach -d'
alias isearch='ircsearch' # Function to search irssi logs

j() {
    local dir="$(fasd -ld "$@")"
    [[ -d "$dir" ]] && pushd "$dir"
}

jd() {
    local dir
    dir=$(find ${1:-*} -path '*/\.*'\

        -prune -o -type d\
        -print 2> /dev/null | fzf +m)
    [ -d "$dir" ] && pushd "$dir"
}

jj() {
    local dir
    dir=$(fasd -Rdl |\
        sed "s:$HOME:~:" |\
        fzf --no-sort +m -q "$*" |\
        sed "s:~:$HOME:")\
    && pushd "$dir"
}

alias js='jekyll serve --limit_posts 10 -w'
alias krbcurl='curl --negotiate -u :'
listcert() { openssl s_client -showcerts -connect $1:443 </dev/null 2>/dev/null | openssl x509 -inform PEM -text } # Usage: listcert google.com
alias lscert=listcert

les() {
    ftype=$(pygmentize -N "$1")
    pygmentize -l "$ftype"\
      -f terminal "$1" |\
        less -R
}

alias mt='truecrypt ~/Dropbox/random.things /media/truecrypt1'
alias msgviewer='java -jar ~/Dropbox/Thumbdrive/PortableApps/MSGViewer-1.9/MSGViewer.jar'
alias myip='curl -s checkip.amazonaws.com'
# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias ql='qlmanage -p "$@" >& /dev/null'
alias reload!='. ~/.zshrc'
alias removetimestamp='sed -i.bak "s/\(.*\)..:..:..$/\1/"'
alias removetimestampandcopy='sed "s/\(.*\)..:..:..$/\1/" $@ |pbcopy'
alias rg='rg --smart-case'
alias rs='screen -RD'
alias sl='ls'
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app" # Start ScreenSaver. This will lock the screen if locking is enabled.

transfer() { # transfer.sh function from https://gist.github.com/nl5887/a511f172d3fb3cd0e42d#gistcomment-2093683
    # check arguments
    if [ $# -ne 1 ];
    then
        echo -e "Wrong arguments specified. Usage:\ntransfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporary filename, output is written to this file so show progress can be showed
    tmpfile="$( mktemp -t transferXXX )"

    # upload stdin or file
    file="$1"

    if tty -s;
    then
        basefile="$( basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g' )"

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi

        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile="$( mktemp -t transferXXX.zip )"
            cd "$(dirname "$file")" && zip -r -q - "$(basename "$file")" >> "$zipfile"
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> "$tmpfile"
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> "$tmpfile"
        fi
    else
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> "$tmpfile"
    fi

    # cat output link
    cat "$tmpfile"
    echo

    # cleanup
    rm -f "$tmpfile"
}

alias trimw="pbpaste |sed -e 's/[[[:space:]]\r\n]//g' |pbcopy" # Trim all whitespace
alias ud='cd ~/dotfiles && git pull; cd -'
alias utc='date -u'

alias vi='vim'
if check_com -c vimr ; then
  vim () { # from https://github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc#L3130
    VIM_PLEASE_SET_TITLE='yes' command vimr ${VIM_OPTIONS} "$@"
  }
fi
alias worddiff='git diff --word-diff=color'

alias zpup='cd .zprezto && git pull && git submodule update --init --recursive; cd -' # Update prezto

