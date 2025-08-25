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


alias :wq='exit'
alias up='sudo pacman -Syuu'
alias lz='lazygit'
alias ninit='nvim ~/.config/nvim/init.vim'
alias tf='gdu / -i /mnt/c,/usr/lib/wsl -C'
alias about='fastfetch'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias src='source ~/.bashrc'
alias ls='lsd --color=auto'
alias grep='grep --color=auto'
alias ll='lsd -FXlah --color=auto'
alias la='ls -a'
alias yayc='yay -Rc $(yay -Qtdq)'
alias bak='cp ~/.bashrc ~/bakup/bash && cp ~/.config/nvim/init.vim ~/bakup/nvim'
alias web='explorer.exe "C:\Program Files\Zen Browser\zen.exe"'
alias web2='torbrowser-launcher'
alias down='wsl.exe --shutdown'
alias pyt='cd ~/dev/python/django/next_kazi && source ../.venv/bin/activate'
alias stop='sudo btop'
alias sql='psql -U rom -d test'


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

	case "$file" in
		*.cpp) echo "compiling cpp file"
			g++ $file -o $val
			./$val
		;;
		*.c) echo "compiling c file"
			clang $file -o $val
			./$val
		;;
		*.py) echo "running python file"
			python $file
		;;
		*.cs) echo "running C sharp file"
			dotnet run $file
		;;
		*.java) echo "running Java file"
			java $file
		;;
		*) echo "not good file"
		;;
	esac
	
}
export -f r;

del (){
	yay -Rc $(yay -Qq | grep $1)
}
export -f del;

nvf(){
	file=$(fzf --preview "cat {}")
	if [ -n "$file" ]; then
		nvim "$file"
	fi
}
export -f nvf;

rr (){
	rm -r $1
}
export -f rr;


. "$HOME/.local/bin/env"
