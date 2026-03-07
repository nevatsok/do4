#!/bin/bash
dir=$1
folders_num=$2
folders_names=$3
files_num=$4
files_names=$5
file_size=$6

if [ "$#" -ne 6 ]; then
    echo -e "\e[91mError. The script must be run with 6 parameters.\e[0m"
    exit 1
fi

if ! [ -d "$dir" ]; then
    echo -e "\e[91mError. Invalid directory name: $dir\e[0m"
    exit 1
fi

if [[ "$dir" != /* ]]; then
    echo -e "\e[91mError: Path must be absolute: $dir\e[0m"
    exit 1
fi

if [[ "$folders_num" =~ [^0-9]+ ]]; then
    echo -e "\e[91mError. Parameter is not a number: $folders_num\e[0m"
    exit 1
fi

if [ "$folders_num" -gt 248 ]; then
    echo -e "\e[91mError. Number of folders cannot exceed 248: $folders_num\e[0m"
    exit 1
fi

if [[ ! "$folders_names" =~ ^[a-zA-Z]{1,7}$ ]]; then
    echo -e "\e[91mError. Invalid folder name: $folders_names\e[0m"
    exit 1
fi

if [[ "$files_num" =~ [^0-9]+ ]]; then
    echo -e "\e[91mError. Parameter is not a number: $files_num\e[0m"
    exit 1
fi

if [[ ! "$files_names" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
    echo -e "\e[91mError. Invalid file name format: $files_names\e[0m"
    exit 1
fi

parts=(${files_names//./ })
file_base="${parts[0]}"
file_ext="${parts[1]}"

if [[ ! "$file_size" =~ ^[1-9][0-9]?kb$|^100kb$ ]]; then
    echo -e "\e[91mError. Invalid file size: $file_size\e[0m"
    exit 1
fi

file_size=${file_size%kb}
