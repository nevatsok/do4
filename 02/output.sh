#!/bin/bash
source input.sh

log_file="$(dirname "$(realpath "$0")")/report.log"
date_suffix=$(date +"%d%m%y")

# Массив для отслеживания использованных директорий
used_dirs=()

memcheck() {
    # Получаем свободное место командой из задания
    local avail=$(df -h / | awk 'NR==2 {print $4}')
    
    # Если в выводе есть M - значит меньше гигабайта, пора останавливаться
    if [[ "$avail" == *M ]]; then
        echo "1"  # Останавливаемся
    else
        echo "0"  # Продолжаем
    fi
}

gen_folder_name() {
    local idx=$1
    local base="$folders_names"
    local min_len=5
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
    local min_len=5
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

# Функция для получения уникальной директории из /home
get_unique_dir() {
    local max_attempts=1000
    local attempt=0
    local random_dir=""
    
    while [ $attempt -lt $max_attempts ]; do
        # Ищем только в /home, исключая bin/sbin
        random_dir=$(sudo find /home -type d 2>/dev/null | \
                    grep -v -E '/(bin|sbin)/' | \
                    shuf -n 1)
        
        # Проверяем, не использовали ли мы уже эту директорию
        if [ -n "$random_dir" ]; then
            local dir_used=0
            for used in "${used_dirs[@]}"; do
                if [ "$used" == "$random_dir" ]; then
                    dir_used=1
                    break
                fi
            done
            
            if [ $dir_used -eq 0 ]; then
                used_dirs+=("$random_dir")
                echo "$random_dir"
                return 0
            fi
        fi
        
        ((attempt++))
    done
    
    echo ""
    return 1
}

create_folders_and_files() {
    local folders_num=$((RANDOM % 100 + 1))
    local folders_created=0
    
    # Очищаем массив использованных директорий перед началом
    used_dirs=()
    
    for ((i=0; i<folders_num; i++)); do
        # Получаем уникальную директорию из /home
        local parent_dir=$(get_unique_dir)
        
        if [ -z "$parent_dir" ]; then
            echo -e "\e[91mWarning: Could not find unique directory in /home. Stopping creation.\e[0m"
            echo "Warning: Could not find unique directory in /home after $i folders" >> "$log_file"
            break
        fi
        
        local folder_name=$(gen_folder_name $i)_$date_suffix
        local folder_path="$parent_dir/$folder_name"
        
        sudo mkdir -p "$folder_path"
        echo "PATH: $folder_path, DATE: $(date +"%d:%m:%y"), NAME: $folder_name" >> "$log_file"
        
        local files_num=$((RANDOM % 100 + 1))
        
        for ((j=0; j<files_num; j++)); do
            if [ $(memcheck) -eq 1 ]; then
                echo -e "\e[91mMemory is full. Stopping.\e[0m"
                echo "Memory is full. Stopping." >> "$log_file"
                exit 1
            fi
            
            local file_name=$(gen_file_name $j)_${date_suffix}.$file_ext
            local file_path="$folder_path/$file_name"
            
            sudo touch "$file_path"
            sudo dd if=/dev/zero of="$file_path" bs=1024 count=$file_size 2>/dev/null
            
            echo "PATH: $file_path, DATE: $(date +"%d:%m:%y"), NAME: $file_name, SIZE: ${file_size}kb" >> "$log_file"
        done
        
        ((folders_created++))
    done
    
    echo "Created $folders_created folders in /home directory" >> "$log_file"
}
