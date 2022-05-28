#!/usr/bin/env bash

_completion_gpph() {
	if [ "$3" = "luogu" ]; then
		COMPREPLY=($(echo 'new
delete
cd
show
edit
code
complie
run
rrun
help' | grep ^"$2"))
	elif [ "$3" = "new" -o "$3" = "delete" -o "$3" = "cd" -o "$3" = "show" -o "$3" = "edit" -o "$3" = "code" -o "$3" = "complie" -o "$3" = "run" -o "$3" = "rrun" ]; then
		arr=( $(ls -d1 $LUOGU_PATH/*/ | grep "$2") )
		size=${#arr[@]}
		for ((i=0;i<size;i++)) do
			arr[$i]=${arr[$i]%/*}
			COMPREPLY[$i]=${arr[$i]##*/}
		done
	fi
}

complete -F _completion_gpph luogu

