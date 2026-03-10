#!/bin/bash
folders_names=$1
files_names=$2
file_size=$3

if [ "$#" -ne 3 ]; then
    echo -e "\e[91mError. The script must be run with 3 parameters.\e[0m"
    exit 1
fi

if [[ ! "$folders_names" =~ ^[a-zA-Z]{1,7}$ ]]; then
    echo -e "\e[91mError. Invalid folder name: $folders_names\e[0m"
    exit 1
fi

if [[ ! "$files_names" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
    echo -e "\e[91mError. Invalid file name format: $files_names\e[0m"
    exit 1
fi

parts=(${files_names//./ })
file_base="${parts[0]}"
file_ext="${parts[1]}"

if [[ ! "$file_size" =~ ^[1-9][0-9]?Mb$|^100Mb$ ]]; then
    echo -e "\e[91mError. Invalid file size: $file_size\e[0m"
    exit 1
fi

file_size=${file_size%Mb}
