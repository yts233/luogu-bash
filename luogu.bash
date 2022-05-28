#!/usr/bin/env bash

# 使用前请给脚本添加执行权限
# chmod +x luogu.sh

# 请在这里配置源代码文件夹路径 LUOGU_PATH
LUOGU_PATH=/home/ye_tianshun/桌面/luogu

# 请在~/.bash_aliases内添加以下内容
# LUOGU_PATH=/home/ye_tianshun/桌面/luogu
# alias "luogu"="$LUOGU_PATH/luogu.sh"
# if [ -f "$LUOGU_PATH/luogu-completion.bash" ]; then
#         . "$LUOGU_PATH/luogu-completion.bash"
# fi
#

readonly INVALID_LUOGU_PATH_MESSAGE="script error: please edit LUOGU_PATH varrible in luogu"
readonly UNKNOW_COMMAND_MESSAGE="Unknown command:"
readonly T_NUMBER_NEEDED_MESSAGE="T1234 number needed."
readonly NO_ARGUMENTS_MESSAGE="G++ Helper by Ye_Tianshun. use 'luogu help' for help message."
readonly NOT_EXISTING_MESSAGE="is not existing. use 'luogu new <number>' to create a source"
readonly INVALID_WORKING_DIRECTORY_MESSAGE="Invalid working directory. use 'luogu cd <number>' to switch to your source directory"
readonly HELP_MESSAGE=\
"G++ Helper by Ye_Tianshun
new <number>	创建一个新的源代码
delete <number>	删除现有源代码
cd <number>	切换到指定源代码的路径并打开新的bash
show [number]	显示源代码目录 (使用 nautilus)
edit [number]	编辑源代码、输入
code [number]	用 Visual Studio Code 打开工作区
complie	[number]编译当前目录下的源代码
run [number]	运行当前目录下的源代码并输出到out文件
rrun [number]	先complie再run
help		显示此消息"

new_T() {
	readonly CPP_TEMPLATE=\
"// Luogu $1: https://www.luogu.com.cn/problem/$1
// g++ helper by Ye_Tianshun

// #define GPPH_OUTPUT
#include <iostream>
using namespace std;

int main () {
#ifdef GPPH_OUTPUT
	freopen(\"$1.in\",\"r\",stdin);
	freopen(\"$1.out\",\"w\",stdout);
	freopen(\"$1.err\",\"w\",stderr);
#endif
	
	
	return 0;
}
"
	if [ -d "$LUOGU_PATH/$1" ]; then
		echo "luogu $cmd: $1 already exists!">&2
		return 1
	fi
	mkdir "$LUOGU_PATH/$1"
	echo "$CPP_TEMPLATE" > "$LUOGU_PATH/$1/$1.cpp"
	echo "" > "$LUOGU_PATH/$1/$1.in" > "$LUOGU_PATH/$1/$1.out" > "$LUOGU_PATH/$1/$1.err"
	echo "Finished creating source: $LUOGU_PATH/$1/$1.cpp"
}

delete_T() {
	if [ ! -d "$LUOGU_PATH/$1" ]; then
		echo "luogu $cmd: $1 is not existing!">&2
		return
	fi
	echo "You will delete $1 from computer.
Are you sure? [y/N] "
	read -n 1 PROMPT
	echo
	if [ "$PROMPT" = "Y" -o "$PROMPT" = "y" ]; then
		rm -r "$LUOGU_PATH/$1"
		echo Finished.
	fi
}

get_number() {
	if [ -n "$1" ]; then
		if [ -d "$LUOGU_PATH/$1" ]; then
			echo $1
			return
		else
			echo "luogu $cmd: $cur_number $NOT_EXISTING_MESSAGE">&2
			return 1
		fi
	fi
	var="$(pwd)"
	cur_path="${var##*/}"
	if [ "$var" = "$LUOGU_PATH/$cur_path" -a -d "$LUOGU_PATH/$cur_path" ]; then
		echo $cur_path
	else
		echo "luogu $cmd: $INVALID_WORKING_DIRECTORY_MESSAGE">&2
		return 1
	fi
}

complie() {
	echo "Compling..."
	time env -C "$LUOGU_PATH/$1" g++ "./$1.cpp" -o "./a.out"
	code=$?
	echo ""
	if [ $code -ne 0 ]; then
		echo "luogu $cmd: Complie Error. code: $code">&2
		return $code
	fi
	echo "Finished. $LUOGU_PATH/$1/a.out"
}

runenv() {
	env -C "$LUOGU_PATH/$1" "$LUOGU_PATH/$1/a.out" 0<"$LUOGU_PATH/$1/$1.in" 1>"$LUOGU_PATH/$1/$1.out" 2>"$LUOGU_PATH/$1/$1.err"
	code=$?
	return $code
}

run() {
	cd "$LUOGU_PATH/$1"
	if [ ! -f "$LUOGU_PATH/$1/a.out" ]; then
		echo "luogu $cmd: Complie first! use 'luogu complie'.">&2
		return 1
	fi
	echo "Running."
	time runenv $1
	code=$?
	echo "Program exited with code: $code
Print/Open output or Run/ComplieAndRun? [p/o/r/c/N]">&2
	read -n 1 PROMPT
	echo
	if [ "$PROMPT" == "p" -o "$PROMPT" == "P" ]; then
		cat "$LUOGU_PATH/$1/$1.out"
	elif [ "$PROMPT" == "o" -o "$PROMPT" == "O" ]; then
		gnome-text-editor "$LUOGU_PATH/$1/$1.out"
        elif [ "$PROMPT" == "r" -o "$PROMPT" == "R" ]; then
		"$LUOGU_PATH/luogu.bash" run
        elif [ "$PROMPT" == "c" -o "$PROMPT" == "C" ]; then
		"$LUOGU_PATH/luogu.bash" rrun
	fi
	return $?
}


if [ ! -d "$LUOGU_PATH" ]; then
	echo "$INVALID_LUOGU_PATH_MESSAGE">&2
fi

cmd=$1

if [ -z "$cmd" ]; then
	echo "$NO_ARGUMENTS_MESSAGE">&2
	exit 1
fi

if [ "$cmd" = "new" ]; then
	if [ -z "$2" ]; then
		echo "luogu $cmd: $T_NUMBER_NEEDED_MESSAGE">&2
		exit 1
	fi
	new_T $2
	exit $?
elif [ "$cmd" = "delete" ]; then
	if [ -z "$2" ]; then
		echo "luogu $cmd: $T_NUMBER_NEEDED_MESSAGE">&2
		exit 1
	fi
	delete_T $2
	exit $?
elif [ "$cmd" = "cd" ]; then
	if [ -z "$2" ]; then
		echo "luogu $cmd: $T_NUMBER_NEEDED_MESSAGE">&2
		exit 1
	fi
	if [ -d "$LUOGU_PATH/$2" ]; then
		cd "$LUOGU_PATH/$2"
		bash
	else
		echo "luogu $cmd: $2 $NOT_EXISTING_MESSAGE">&2
		exit 1
	fi
elif [ "$cmd" = "show" ]; then
	cur_number=$(get_number "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
	nautilus "$LUOGU_PATH/$cur_number"&
elif [ "$cmd" = "complie" ]; then
	cur_number=$(get_number "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
	complie $cur_number
	exit $?
elif [ "$cmd" = "run" ]; then
	cur_number=$(get_number "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
	run $cur_number
	exit $?
elif [ "$cmd" = "rrun" ]; then
	cur_number=$(get_number "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
	complie $cur_number
	if [ $? -ne 0 ]; then
		if [ -f "$LUOGU_PATH/$cur_number/a.out" ]; then
			echo "Still running? [y/N] "
			read -n 1 PROMPT
			echo
			if [ "$PROMPT" == "Y" -o "$PROMPT" == "y" ]; then
				run $cur_number
				exit $?
			fi
		fi
		exit 0
	fi
	run $cur_number
	exit $?
elif [ "$cmd" = "edit" ]; then
	cur_number=$(get_number "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
	gnome-text-editor "$LUOGU_PATH/$cur_number/$cur_number.cpp" "$LUOGU_PATH/$cur_number/$cur_number.in" "$LUOGU_PATH/$cur_number/$cur_number.out" "$LUOGU_PATH/$cur_number/$cur_number.err"&
elif [ "$cmd" = "code" ]; then
	cur_number=$(get_number "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
	code "$LUOGU_PATH/$cur_number"
elif [ "$cmd" = "help" ]; then
	echo "$HELP_MESSAGE"
else
	echo "luogu: $UNKNOW_COMMAND_MESSAGE $cmd">&2
fi

