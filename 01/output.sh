#!/bin/bash
source input.sh

memcheck() {
    local avail_kb=$(df / | awk 'NR==2 {print $4}')
    if [ "$avail_kb" -lt 1048576 ]; then
        echo "1"
    else
        echo "0"
    fi
}

gen_folder_name() {
    local idx=$1
    local base="$folders_names"
    local min_len=4
    local base_len=${#base}
    local base_repeats=0
    if [ $base_len -lt $min_len ]; then
        base_repeats=$((min_len - base_len))
    fi
    local repeats=$((base_repeats + idx))
    local last_char="${base: -1}"
    local name="$base"
    for ((i=0; i<repeats; i++)); do
        name+="$last_char"
    done
    echo "$name"
}

gen_file_name() {
    local idx=$1
    local base="$file_base"
    local min_len=4
    local base_len=${#base}
    local base_repeats=0
    if [ $base_len -lt $min_len ]; then
        base_repeats=$((min_len - base_len))
    fi
    local repeats=$((base_repeats + idx))
    local last_char="${base: -1}"
    local name="$base"
    for ((i=0; i<repeats; i++)); do
        name+="$last_char"
    done
    echo "$name"
}

create_folders() {
    local i=$1
    local folder_name=$(gen_folder_name $i)
    folder_name+="_"$(date +"%d%m%y")
    mkdir -p "$dir/$folder_name"
    echo "PATH: $dir/$folder_name, DATE: $(date +"%d:%m:%y"), NAME: $folder_name" >> "$log_file"

    for ((k=0; k<$files_num; k++)); do
        if [ $(memcheck) -eq 1 ]; then
            echo -e "\e[91mMemory is full. Stopping.\e[0m"
            echo "Memory is full. Stopping." >> "$log_file"
            exit 1
        fi
        local file_name=$(gen_file_name $k)
        file_name+="_"$(date +"%d%m%y").$file_ext
        touch "$dir/$folder_name/$file_name"
        head -c ${file_size}K /dev/zero > "$dir/$folder_name/$file_name"
        echo "PATH: $dir/$folder_name/$file_name, DATE: $(date +"%d:%m:%y"), NAME: $file_name, SIZE: ${file_size}kb" >> "$log_file"
    done
}
