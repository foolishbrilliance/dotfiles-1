# zsh aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias c="tr -d '\n' | pbcopy" # Trim new lines and copy to clipboard
alias calc='bc <<<'
alias epoch='date +%s'
alias e2u=epoch2utc
alias fpath='[[ `uname` == "Darwin" ]] && cpath || readlink -f' # cpath is another alias, think "canonical path"
alias irca='growl-irc.sh; ssh -t trundle tmux attach -d'
alias isearch='ircsearch' # Function to search irssi logs
alias js='jekyll serve --limit_posts 10 -w'
alias github="open \`git remote -v | grep github.com | grep fetch | head -1 | field 2 | sed 's/git:/http:/g'\`"
alias gityolo="git commit -am 'Updating everything.'; git push origin master"
alias gpm="git push origin master"
alias lscert=listcert
alias mt='truecrypt ~/Dropbox/random.things /media/truecrypt1'
alias reload!='. ~/.zshrc'
alias removetimestamp='sed -i.bak "s/\(.*\)..:..:..$/\1/"'
alias removetimestampandcopy='sed "s/\(.*\)..:..:..$/\1/" $@ |pbcopy'
alias rs='screen -RD'
alias sl='ls'
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app" # Start ScreenSaver. This will lock the screen if locking is enabled.
alias trim="pbpaste |sed -e 's/[[[:space:]]\r\n]//g' |pbcopy" # Trim all whitespace
alias ud='cd ~/dotfiles && git pull; cd -'
alias utc='date -u'
alias worddiff='git diff --word-diff=color'