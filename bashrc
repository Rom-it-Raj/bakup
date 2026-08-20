
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
alias yayc='yay -Rnsc $(yay -Qtdq)'
alias btop='btop --force-utf'
alias stop='sudo btop --force-utf'
alias sql='psql -U rom -d test'
alias yt='youtube-tui'
alias kaz='cd ~/dev/web/kazilen-backend/djangoproj && source ../venv/bin/activate'
alias nkaz='cd /home/romit/dev/new_web/kazilen-backend/ && source /home/romit/dev/new_web/kazilen-backend/.venv/bin/activate'
alias yc='yazi'
alias min='minio server ~/minio-data --address ":8888" --console-address ":8889"'
alias pio_run='pio run --target upload'
alias pio_com='pio run -t compiledb'

bak (){
	main="$PWD"
	cp "$HOME/.bashrc" "$HOME/bakup/bashrc"
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
	local file=$1
	local base=${file%.*}
	local val="O"
	local val+=$base

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
	yay -Rnsc $(yay -Qq | grep $1)
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

gac (){
	local Ctime=$(date)
	local dmsg="auto@${Ctime}"
	if [ -n "$1" ]; then
		local cmsg="$1"
	else
		local cmsg="$dmsg"
	fi

	git add .
	git commit -m "${cmsg}"
}
export -f gac;


export STM32_PRG_PATH=/home/romit/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin


run_hdl (){
	local main_v=$1
	local file="${1##*/}"
	local base=${file%.*}
	local test_b="tb/${base}_tb.v"
	echo "running verilog sim"
	echo ""
	echo "select TestBench :"
	select test_b in tb/*v; do
		if [ -n "$test_b" ]; then
			echo "Selected: $test_b"
			break
		else 
			echo "something wrong"
		fi
	done

	shopt -s nullglob
  local rtl_files=(rtl/include/*.v)
  local tb_files=(tb/*.v)
  shopt -u nullglob
	
	iverilog -o "simulation" $main_v "${rtl_files[@]}" $test_b
	mv "simulation" sim/
	vvp "sim/simulation"
	echo " "
	echo "=================================================="
	echo " "
	echo "opening gtkwave"
	surfer "build/sim.vcd"
}
export -f run_hdl;

hdl_make() {
	local base=$1
	local v_file="${base}.v"
	local test_b="${base}_tb.v"
	mkdir $base
	cd $base
	git init
	cat<<EOF > "$v_file"
module ${base}();

endmodule
EOF
	
cat<<EOF > "$test_b"
\`timescale 1ns / 10ps

module ${base}_tb;

${base} uut();
initial begin
	\$dumpfile("build/sim.vcd");
	\$dumpvars(0, ${base}_tb);
	\$finish;
end
endmodule
EOF

	mkdir rtl
	mkdir rtl/include
	mv $v_file rtl/$v_file
	mkdir tb
	mv $test_b tb/$test_b
	mkdir build
	mkdir sim
	touch verible.filelist

	find rtl tb -type f \( -name "*.v" -o -name "*.sv" -o -name "*.svh" \) | sort > verible.filelist

}
export -f hdl_make;

load_verible_list () {
	find rtl tb -type f \( -name "*.v" -o -name "*.sv" -o -name "*.svh" \) | sort > verible.filelist
}
export -f load_verible_list;

make_schem() {
	local main_v=$1
	local file="${1##*/}"
	local base=${file%.*}
	echo $file
	yosys -p "read_verilog rtl/${base}.v ; synth -auto-top ; abc -g gates ; write_json build/${base}.json"
	netlistsvg build/$base.json -o build/$base.svg
}
export BUN_INSTALL="$HOME/.BUN"
export PATH="$BUN_INSTALL/bin:$PATH"
