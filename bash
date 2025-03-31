white=$(tput sgr0);
bule=$(tput setaf 222);
usrblue=$(tput setaf 33);
orange=$(tput setaf 208);
cyan=$(tput setaf 165);
red=$(tput setaf 196);
green=$(tput setaf 118);
yellow=$(tput setaf 46);
lime=$(tput setaf 83);
arr=$(tput setaf 123);
dividerOrange=$(tput setaf 166);

export EDITOR=nvim

PS1="\n\[${usrblue}\]󰣇 \[${dividerOrange}\]\[${cyan}\](";
PS1+=" \[${usrblue}\]\u \[${cyan}\])";
PS1+="\[${red}\]  \[${dividerOrange}\]\[${cyan}\](";
PS1+="\[${orange}\] \W \[${cyan}\])";
PS1+="\[${orange}\]  \[${dividerOrange}\]\[${cyan}\](";
PS1+="\[${lime}\] \@ \[${cyan}\])\n\[${arr}\] 󰘍 \[${white}\]"

export PS1;

alias up='yay -Syuu'
alias lz='lazygit'
alias ninit='nvim ~/.config/nvim/init.vim'
alias tf='gdu / -i /mnt/c,/usr/lib/wsl -C'
alias about='neofetch'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias src='source ~/.bashrc'
alias ls='lsd --color=auto'
alias grep='grep --color=auto'
alias ll='lsd -lah --color=auto'
alias la='ls -a'
alias yayc='yay -Rc $(yay -Qtdq)'
alias py='cd ~/dev/python && source ~/dev/python/.venv/bin/activate'
alias de='deactivate && cd ~'
alias bak='cp ~/.bashrc ~/bakup/bash && cp ~/.config/nvim/init.vim ~/bakup/nvim'
alias exp='cd dev/express'
alias web='explorer.exe "C:\Program Files\Zen Browser\zen.exe"'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

mcd (){
	mkdir $1 
	cd $1 
}
export -f mcd;

r (){
	file=$1
	base=${file%.*}
	val="O"
	val+=$base
	clang $file -o $val
	./$val
}
export -f r;

del (){
	yay -Rc $(yay -Qq | grep $1)
}
export -f del;

