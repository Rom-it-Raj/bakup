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
gitcol=$(tput setaf 189);
export EDITOR=nvim

function git_prompt() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local status=''
        if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
            status=" ${red}󱘒${gitcol} "
				else
					status=" ${lime}${gitcol} "
        fi
        echo " [ ${branch} ][${status}]"
		else
			echo " [ 󰟢 ]"
    fi
}

PS1="\n\[${usrblue}\]󰣇 \[${dividerOrange}\]\[${cyan}\](";
PS1+=" \[${usrblue}\]\u \[${cyan}\])";
PS1+="\[${red}\]  \[${dividerOrange}\]\[${cyan}\](";
PS1+="\[${orange}\] \W \[${cyan}\])";
PS1+="\[${orange}\]  \[${dividerOrange}\]\[${cyan}\](";
PS1+="\[${lime}\] \@ \[${cyan}\])";
PS1+="\[${dividerOrange}\] \[${gitcol}\] \$(git_prompt)\n\[${arr}\] 󰘍 \[${white}\]"

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
alias web='explorer.exe "C:\Program Files\Zen Browser\zen.exe"'
alias web2='torbrowser-launcher'
alias down='wsl.exe --shutdown'
alias stop='sudo btop'
alias sql='psql -U rom -d test'
alias smp='GDK_SCALE=2 java -jar ~/dev/mp8085/8085Compiler.jar'
alias mp='java -jar ~/dev/kollege/mp8085/8085Compiler.jar'
alias yt='youtube-tui'
alias kaz='cd ~/dev/web/kazilen-backend/djangoproj && source .env/bin/activate'
alias yc='yazi'


bak (){
	main="$PWD"
	cp "$HOME/.bashrc" "$HOME//bakup/bashrc"
	cp "$HOME/.config/nvim/init.vim" "$HOME/bakup/nvim"
	cd "$HOME/bakup"
	git add .
	git commit -m "automatic bakup `date`"
	cd $main
}

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
		*.lua) echo "running luau"
			luau $file
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
	sudo rm -r $1
}
export -f rr;


. "$HOME/.local/bin/env"
