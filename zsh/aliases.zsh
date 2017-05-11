# zsh aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias calc='bc <<<'
alias clitxt='curl -sF "upfile=@-" https://clitxt.com |tee /dev/tty | pbcopy'
alias epoch='date +%s'
epoch2utc() { perl -e "print scalar(localtime($1)) . ' UTC'" } # Usage: epoch2utc 1395249613
alias e2u=epoch2utc
alias fpath='perl -MCwd -e "print Cwd::abs_path shift"' # cpath is another alias, think "canonical path"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias github="open \`git remote -v | grep github.com | grep fetch | head -1 | field 2 | sed 's/git:/http:/g'\`"
alias gityolo="git commit -am 'Updating everything.'; git push origin master"
alias gpm="git push origin master"
alias irca='growl-irc.sh; ssh -t trundle tmux attach -d'
alias isearch='ircsearch' # Function to search irssi logs
alias js='jekyll serve --limit_posts 10 -w'
alias krbcurl='curl --negotiate -u :'
listcert() { openssl s_client -showcerts -connect $1:443 </dev/null 2>/dev/null | openssl x509 -inform PEM -text } # Usage: listcert google.com
alias lscert=listcert
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
alias trimw="pbpaste |sed -e 's/[[[:space:]]\r\n]//g' |pbcopy" # Trim all whitespace
alias ud='cd ~/dotfiles && git pull; cd -'
alias utc='date -u'
alias vi='vim'
alias worddiff='git diff --word-diff=color'
alias zpup='cd .zprezto && git pull && git submodule update --init --recursive; cd -' # Update prezto

# fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

