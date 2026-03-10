#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")
log_file="$script_dir/report.log"

source "$script_dir/output.sh"

rm -f "$log_file"
touch "$log_file"

start_time=$(date +%s)
echo "Script started at: $(date -d @$start_time +"%Y-%m-%d %H:%M:%S")" >> "$log_file"
echo -e "\e[32mScript started at: $(date -d @$start_time +"%Y-%m-%d %H:%M:%S")\e[0m"

create_folders_and_files

end_time=$(date +%s)
echo "Script finished at: $(date -d @$end_time +"%Y-%m-%d %H:%M:%S")" >> "$log_file"
echo -e "\e[32mScript finished at: $(date -d @$end_time +"%Y-%m-%d %H:%M:%S")\e[0m"

duration=$((end_time - start_time))
echo "Total execution time: $duration seconds" >> "$log_file"
echo -e "\e[32mTotal execution time: $duration seconds\e[0m"

echo -e "\e[32mDirectories and files have been created successfully\e[0m"
