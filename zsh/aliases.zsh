# zsh aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias calc='bc <<<'

cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

alias cl="fc -e -|pbcopy && echo Copied output of last command to clipboard"
alias clitxt='curl -sF "upfile=@-" https://clitxt.com |tee /dev/tty | pbcopy'
epoch2utc() { perl -e "print scalar(localtime($1)) . ' UTC'" } # Usage: epoch2utc 1395249613
alias e2u=epoch2utc
alias epoch='date +%s'
edownload() {
  if [ $# -ne 2 ];
  then
      echo -e "Wrong arguments specified. Usage example:\nedownload https://transfer.sh/nPIxk/test.txt /tmp/test"
      return 1
  fi
  curl $1| gpg -dio- > $2
}

etransfer() {
  cat $1|gpg -ac -o-|curl --progress-bar -X PUT --upload-file "-" https://transfer.sh/test.txt |tee
}

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

alias fpath='perl -MCwd -e "print Cwd::abs_path shift"' # cpath is another alias, think "canonical path"

fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
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

v() {
    local file
    if [[ -e "$1" ]]; then
        les "$1"
    else
        file=$(fzf --query="$1"\
          --select-1 --exit-0)
        [ -n "$file" ] && les "$file"
    fi
}
alias vi='vim'
alias worddiff='git diff --word-diff=color'
alias zpup='cd .zprezto && git pull && git submodule update --init --recursive; cd -' # Update prezto

# fasd
eval "$(fasd --init auto)"
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
alias v='f -e vim' # quick opening files with vim
alias o='a -e open' # quick opening files with open (OSX)
