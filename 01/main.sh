#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")
log_file="$script_dir/report.log"

source output.sh

rm -f "$log_file"
touch "$log_file"

for ((i=0; i<$folders_num; i++)); do
    create_folders $i
done

echo -e "\e[32mDirectories and files have been created successfully\e[0m"
