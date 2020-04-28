#!/bin/bash

#file to find
echo "Please enter file to search for:"
read input #gets input

#where to look
if [ -d "$1" ];then
	base=$1
else
	cd
	base=$(pwd)
fi
echo "Searching from directory: $base"
declare -a dir=("$base") #starting directory
temp="$base/temp.txt" #temporary list of directory contents
out="$base/out.txt" #contains found locations
>$out #resets file
found=0

#breadth first search function
bfs(){
	cd $1
	pointer=$2
	found=$3
	ls -d $PWD/* > $temp #write contents to temp file
	while IFS= read line
	do
		substr=${line##*/} #gets last field
		if [[ $input == $substr ]];then
			found=$((++found))
			echo $line>>$out #adds directory to file
		fi
		#if directory and not empty
		if [[ -d "$line" ]];then
			if [ "$(ls -A $line)" ];then
				dir+=("${line}")
			fi
		fi

	done<"$temp" #input file
	#recursion
	pointer=$((++pointer))
	if [ -v dir[pointer] ];then
		bfs "${dir[pointer]}" $pointer $found	
	fi
	return				
}

#start search from  base directory
bfs "${dir[0]}" 0 $found

#outcome
echo "-------search complete-------"
if [ "$found" -gt 0 ];then
	echo "Found $found cases of $input in the following locations:"
	#display locations of file
	while IFS= read line
	do
		echo "$line"
	done<"$out" #removes .txt suffix
else
	echo  "Found 0 cases of $input"
fi
