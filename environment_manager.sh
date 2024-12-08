# 文件名: environment_manager.sh
# 版本: v1.1
# 描述: 这个脚本用于管理常用的计算机环境，支持安装、删除和管理多种开发环境。

#!/bin/bash

set -euo pipefail

# 设置初始语言为英语
LANG="en"

# 定义环境列表
environments=(
    "Docker"
    "Java"
    "Python"
    "C++"
    "Node.js"
    "Go"
    "Ruby"
    "Rust"
    "PHP"
    "MySQL"
)

# 语言字典
declare -A messages
messages["en,welcome"]="Welcome to the Environment Manager!"
messages["zh,welcome"]="欢迎使用环境管理器！"
messages["en,select_lang"]="Select language (en/zh):"
messages["zh,select_lang"]="选择语言 (en/zh)："
messages["en,main_menu"]="Main Menu:"
messages["zh,main_menu"]="主菜单："
messages["en,install_all"]="Install All Environments"
messages["zh,install_all"]="安装所有环境"
messages["en,remove_all"]="Remove All Environments"
messages["zh,remove_all"]="删除所有环境"
messages["en,manage_individual"]="Manage Individual Environments"
messages["zh,manage_individual"]="管理单个环境"
messages["en,batch_operations"]="Batch Operations"
messages["zh,batch_operations"]="批量操作"
messages["en,switch_language"]="Switch Language"
messages["zh,switch_language"]="切换语言"
messages["en,advanced_options"]="Advanced Options"
messages["zh,advanced_options"]="高级选项"
messages["en,exit"]="Exit"
messages["zh,exit"]="退出"
messages["en,choice"]="Enter your choice:"
messages["zh,choice"]="输入您的选择："
messages["en,invalid_choice"]="Invalid choice. Please try again."
messages["zh,invalid_choice"]="无效的选择。请重试。"
messages["en,installing"]="Installing"
messages["zh,installing"]="正在安装"
messages["en,removing"]="Removing"
messages["zh,removing"]="正在删除"
messages["en,installed_successfully"]="installed successfully."
messages["zh,installed_successfully"]="安装成功。"
messages["en,removed_successfully"]="removed successfully."
messages["zh,removed_successfully"]="删除成功。"
messages["en,operation_failed"]="Operation failed."
messages["zh,operation_failed"]="操作失败。"
messages["en,select_environment"]="Select an environment to manage:"
messages["zh,select_environment"]="选择要管理的环境："
messages["en,install"]="Install"
messages["zh,install"]="安装"
messages["en,remove"]="Remove"
messages["zh,remove"]="删除"
messages["en,invalid_env_selection"]="Invalid environment selection."
messages["zh,invalid_env_selection"]="无效的环境选择。"
messages["en,enter_env_numbers"]="Enter the numbers of environments to operate on (space-separated):"
messages["zh,enter_env_numbers"]="输入要操作的环境编号（用空格分隔）："
messages["en,select_action"]="Action (1 for install, 2 for remove):"
messages["zh,select_action"]="操作（1 表示安装，2 表示删除）："
messages["en,invalid_action"]="Invalid action for"
messages["zh,invalid_action"]="无效的操作："
messages["en,advanced_menu"]="Advanced Options:"
messages["zh,advanced_menu"]="高级选项："
messages["en,check_system"]="Check System Requirements"
messages["zh,check_system"]="检查系统要求"
messages["en,update_manager"]="Update Environment Manager"
messages["zh,update_manager"]="更新环境管理器"
messages["en,generate_report"]="Generate Environment Report"
messages["zh,generate_report"]="生成环境报告"
messages["en,change_mirror"]="Change System Mirror"
messages["zh,change_mirror"]="更改系统镜像源"
messages["en,custom_mirror"]="Set Custom Mirror"
messages["zh,custom_mirror"]="设置自定义镜像源"
messages["en,invalid_advanced_option"]="Invalid advanced option."
messages["zh,invalid_advanced_option"]="无效的高级选项。"
messages["en,checking_system"]="Checking system requirements..."
messages["zh,checking_system"]="正在检查系统要求..."
messages["en,updating_manager"]="Updating Environment Manager..."
messages["zh,updating_manager"]="正在更新环境管理器..."
messages["en,generating_report"]="Generating environment report..."
messages["zh,generating_report"]="正在生成环境报告..."
messages["en,changing_mirror"]="Changing system mirror..."
messages["zh,changing_mirror"]="正在更改系统镜像源..."
messages["en,enter_custom_mirror"]="Enter custom mirror URL:"
messages["zh,enter_custom_mirror"]="输入自定义镜像源 URL："
messages["en,operation_completed"]="Operation completed."
messages["zh,operation_completed"]="操作完成。"
messages["en,exiting"]="Exiting..."
messages["zh,exiting"]="正在退出..."
messages["en,unsupported_distribution"]="Unsupported distribution:"
messages["zh,unsupported_distribution"]="不支持的发行版："
messages["en,cannot_detect_os"]="Cannot detect OS"
messages["zh,cannot_detect_os"]="无法检测操作系统"
messages["en,detected_system"]="Detected system:"
messages["zh,detected_system"]="检测到的系统："
messages["en,using"]="using"
messages["zh,using"]="使用"
messages["en,selecting_mirror"]="Selecting best mirror for"
messages["zh,selecting_mirror"]="正在为以下系统选择最佳镜像源："
messages["en,mirror_updated"]="Mirror updated."
messages["zh,mirror_updated"]="镜像源已更新。"
messages["en,running_system_update"]="Running system update..."
messages["zh,running_system_update"]="正在运行系统更新..."
messages["en,language_switched"]="Language switched to"
messages["zh,language_switched"]="语言已切换为"
messages["en,invalid_language_choice"]="Invalid language choice. Keeping current language."
messages["zh,invalid_language_choice"]="无效的语言选择。保持当前语言。"
messages["en,installation_not_implemented"]="Installation command not implemented for"
messages["zh,installation_not_implemented"]="未实现安装命令："
messages["en,removal_not_implemented"]="Removal command not implemented for"
messages["zh,removal_not_implemented"]="未实现删除命令："
messages["en,system"]="System"
messages["zh,system"]="系统"
messages["en,memory"]="Memory"
messages["zh,memory"]="内存"
messages["en,disk_space"]="Disk space"
messages["zh,disk_space"]="磁盘空间"
messages["en,available"]="available"
messages["zh,available"]="可用"
messages["en,environment_report"]="Environment Report"
messages["zh,environment_report"]="环境报告"
messages["en,date"]="Date"
messages["zh,date"]="日期"
messages["en,installed_environments"]="Installed Environments"
messages["zh,installed_environments"]="已安装的环境"
messages["en,installed"]="Installed"
messages["zh,installed"]="已安装"
messages["en,not_installed"]="Not installed"
messages["zh,not_installed"]="未安装"
messages["en,report_generated"]="Report generated"
messages["zh,report_generated"]="报告已生成"
messages["en,error_occurred"]="An error occurred:"
messages["zh,error_occurred"]="发生错误："
messages["en,press_enter"]="Press Enter to continue..."
messages["zh,press_enter"]="按回车键继续..."
messages["en,operation_timeout"]="Operation timed out."
messages["zh,operation_timeout"]="操作超时。"
messages["en,operation_interrupted"]="Operation interrupted."
messages["zh,operation_interrupted"]="操作已中断。"

# 全局变量
PACKAGE_MANAGER=""
INSTALL_CMD=""
REMOVE_CMD=""
UPDATE_CMD=""
CUSTOM_MIRROR=""

# 函数：错误处理
handle_error() {
    echo "$(get_message 'error_occurred') $1" >&2
    echo "$(get_message 'press_enter')" >&2
    read -r
}

# 函数：获取翻译后的消息
get_message() {
    local key="$LANG,$1"
    echo "${messages[$key]}"
}

# 函数：显示进度条
show_progress() {
    local pid=$1
    local duration=$2
    local steps=20
    local delay=$(( duration / steps ))
    
    (
        for ((i=0; i<=steps; i++)); do
            printf "\r[%-${steps}s] %d%%" "$(printf "%${i}s" | tr ' ' '#')" "$(( i * 100 / steps ))"
            sleep "$delay"
        done
    ) &
    
    local progress_pid=$!
    
    if ! wait "$pid"; then
        kill "$progress_pid" 2>/dev/null
        wait "$progress_pid" 2>/dev/null
        printf "\r%-${steps}s\n" "$(get_message 'operation_failed')"
        return 1
    fi
    
    kill "$progress_pid" 2>/dev/null
    wait "$progress_pid" 2>/dev/null
    printf "\r[%-${steps}s] 100%%\n" "$(printf "%${steps}s" | tr ' ' '#')"
    return 0
}

# 函数：检测系统类型和包管理器
detect_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu|linuxmint)
                PACKAGE_MANAGER="apt"
                INSTALL_CMD="apt-get install -y"
                REMOVE_CMD="apt-get remove -y"
                UPDATE_CMD="apt-get update"
                ;;
            fedora|centos|rhel)
                PACKAGE_MANAGER="dnf"
                INSTALL_CMD="dnf install -y"
                REMOVE_CMD="dnf remove -y"
                UPDATE_CMD="dnf check-update"
                ;;
            arch|manjaro)
                PACKAGE_MANAGER="pacman"
                INSTALL_CMD="pacman -S --noconfirm"
                REMOVE_CMD="pacman -R --noconfirm"
                UPDATE_CMD="pacman -Sy"
                ;;
            *)
                handle_error "$(get_message 'unsupported_distribution') $ID"
                return 1
                ;;
        esac
    else
        handle_error "$(get_message 'cannot_detect_os')"
        return 1
    fi
    echo "$(get_message 'detected_system') $ID, $(get_message 'using') $PACKAGE_MANAGER"
}

# 函数：选择镜像源
select_mirror() {
    echo "$(get_message 'changing_mirror')"
    case $PACKAGE_MANAGER in
        apt)
            echo "$(get_message 'selecting_mirror') Debian/Ubuntu..."
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
            if [ -n "$CUSTOM_MIRROR" ]; then
                sudo sed -i "s|http://.*archive.ubuntu.com|$CUSTOM_MIRROR|g" /etc/apt/sources.list
                sudo sed -i "s|http://.*security.ubuntu.com|$CUSTOM_MIRROR|g" /etc/apt/sources.list
            else
                sudo sed -i 's|http://.*archive.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list
                sudo sed -i 's|http://.*security.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list
            fi
            ;;
        dnf)
            echo "$(get_message 'selecting_mirror') Fedora..."
            if [ -n "$CUSTOM_MIRROR" ]; then
                sudo sed -i "s|^metalink=|#metalink=|g" /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
                sudo sed -i "s|^#baseurl=http://download.example/pub/fedora/linux|baseurl=$CUSTOM_MIRROR|g" /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
            else
                sudo sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
                sudo sed -i 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
            fi
            ;;
        pacman)
            echo "$(get_message 'selecting_mirror') Arch Linux..."
            sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
            if [ -n "$CUSTOM_MIRROR" ]; then
                echo "Server = $CUSTOM_MIRROR/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist
            else
                echo "Server = https://mirrors.aliyun.com/archlinux/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist
            fi
            ;;
    esac
    echo "$(get_message 'mirror_updated')"
    echo "$(get_message 'running_system_update')"
    (sudo $UPDATE_CMD > /dev/null 2>&1) &
    if show_progress $! 10; then
        echo "$(get_message 'operation_completed')"
    else
        handle_error "$(get_message 'operation_failed')"
    fi
}

# 函数：设置自定义镜像源
set_custom_mirror() {
    echo "$(get_message 'enter_custom_mirror')"
    read -r CUSTOM_MIRROR
    if ! select_mirror; then
        handle_error "$(get_message 'operation_failed')"
        CUSTOM_MIRROR=""
    fi
}

# 函数：切换语言
switch_language() {
    echo "$(get_message 'select_lang')"
    read -r lang_choice
    if [[ "$lang_choice" == "en" || "$lang_choice" == "zh" ]]; then
        LANG=$lang_choice
        echo "$(get_message 'language_switched') $LANG"
    else
        echo "$(get_message 'invalid_language_choice')"
    fi
}

# 函数：安装环境
install_environment() {
    local env=$1
    echo "$(get_message 'installing') $env..."
    case $env in
        "Docker")
            (sudo $INSTALL_CMD docker.io > /dev/null 2>&1) &
            ;;
        "Java")
            (sudo $INSTALL_CMD default-jdk > /dev/null 2>&1) &
            ;;
        "Python")
            (sudo $INSTALL_CMD python3 python3-pip > /dev/null 2>&1) &
            ;;
        "C++")
            (sudo $INSTALL_CMD build-essential > /dev/null 2>&1) &
            ;;
        "Node.js")
            (sudo $INSTALL_CMD nodejs npm > /dev/null 2>&1) &
            ;;
        "Go")
            (sudo $INSTALL_CMD golang > /dev/null 2>&1) &
            ;;
        "Ruby")
            (sudo $INSTALL_CMD ruby-full > /dev/null 2>&1) &
            ;;
        "Rust")
            (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1) &
            ;;
        "PHP")
            (sudo $INSTALL_CMD php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath > /dev/null 2>&1) &
            ;;
        "MySQL")
            (sudo $INSTALL_CMD mysql-server > /dev/null 2>&1) &
            ;;
        *)
            handle_error "$(get_message 'installation_not_implemented') $env."
            return 1
            ;;
    esac
    local pid=$!
    if show_progress $pid 30; then
        echo "$env $(get_message 'installed_successfully')"
        return 0
    else
        handle_error "$(get_message 'operation_failed')"
        return 1
    fi
}

# 函数：删除环境
remove_environment() {
    local env=$1
    echo "$(get_message 'removing') $env..."
    case $env in
        "Docker")
            (sudo $REMOVE_CMD docker.io > /dev/null 2>&1) &
            ;;
        "Java")
            (sudo $REMOVE_CMD default-jdk > /dev/null 2>&1) &
            ;;
        "Python")
            (sudo $REMOVE_CMD python3 python3-pip > /dev/null 2>&1) &
            ;;
        "C++")
            (sudo $REMOVE_CMD build-essential > /dev/null 2>&1) &
            ;;
        "Node.js")
            (sudo $REMOVE_CMD nodejs npm > /dev/null 2>&1) &
            ;;
        "Go")
            (sudo $REMOVE_CMD golang > /dev/null 2>&1) &
            ;;
        "Ruby")
            (sudo $REMOVE_CMD ruby-full > /dev/null 2>&1) &
            ;;
        "Rust")
            (rustup self uninstall -y > /dev/null 2>&1) &
            ;;
        "PHP")
            (sudo $REMOVE_CMD php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath > /dev/null 2>&1) &
            ;;
        "MySQL")
            (sudo $REMOVE_CMD mysql-server > /dev/null 2>&1) &
            ;;
        *)
            handle_error "$(get_message 'removal_not_implemented') $env."
            return 1
            ;;
    esac
    local pid=$!
    if show_progress $pid 30; then
        echo "$env $(get_message 'removed_successfully')"
        return 0
    else
        handle_error "$(get_message 'operation_failed')"
        return 1
    fi
}

# 函数：安装所有环境
install_all_environments() {
    for env in "${environments[@]}"; do
        if ! install_environment "$env"; then
            handle_error "$(get_message 'operation_failed') $env"
        fi
    done
}

# 函数：删除所有环境
remove_all_environments() {
    for env in "${environments[@]}"; do
        if ! remove_environment "$env"; then
            handle_error "$(get_message 'operation_failed') $env"
        fi
    done
}

# 函数：管理单个环境
manage_individual_environment() {
    echo "$(get_message 'select_environment')"
    for i in "${!environments[@]}"; do
        echo "$((i+1)). ${environments[$i]}"
    done
    read -rp "$(get_message 'choice') " env_choice
    if [[ "$env_choice" =~ ^[0-9]+$ ]] && [ "$env_choice" -ge 1 ] && [ "$env_choice" -le "${#environments[@]}" ]; then
        selected_env="${environments[$((env_choice-1))]}"
        echo "1. $(get_message 'install') $selected_env"
        echo "2. $(get_message 'remove') $selected_env"
        read -rp "$(get_message 'choice') " action_choice
        case $action_choice in
            1) install_environment "$selected_env" ;;
            2) remove_environment "$selected_env" ;;
            *) handle_error "$(get_message 'invalid_choice')" ;;
        esac
    else
        handle_error "$(get_message 'invalid_env_selection')"
    fi
}

# 函数：批量操作
batch_operations() {
    echo "$(get_message 'enter_env_numbers')"
    for i in "${!environments[@]}"; do
        echo "$((i+1)). ${environments[$i]}"
    done
    read -rp "$(get_message 'choice') " env_numbers
    read -rp "$(get_message 'select_action') " batch_action

    for num in $env_numbers; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#environments[@]}" ]; then
            selected_env="${environments[$((num-1))]}"
            case $batch_action in
                1) install_environment "$selected_env" ;;
                2) remove_environment "$selected_env" ;;
                *) handle_error "$(get_message 'invalid_action') $selected_env." ;;
            esac
        else
            handle_error "$(get_message 'invalid_env_selection')"
        fi
    done
}

# 函数：高级选项
advanced_options() {
    echo "$(get_message 'advanced_menu')"
    echo "1. $(get_message 'check_system')"
    echo "2. $(get_message 'update_manager')"
    echo "3. $(get_message 'generate_report')"
    echo "4. $(get_message 'change_mirror')"
    echo "5. $(get_message 'custom_mirror')"
    read -rp "$(get_message 'choice') " adv_choice
    case $adv_choice in
        1) check_system_requirements ;;
        2) update_environment_manager ;;
        3) generate_environment_report ;;
        4) select_mirror ;;
        5) set_custom_mirror ;;
        *) handle_error "$(get_message 'invalid_advanced_option')" ;;
    esac
}

# 函数：检查系统要求
check_system_requirements() {
    echo "$(get_message 'checking_system')"
    echo "$(get_message 'system'): $(uname -a)"
    echo "CPU: $(lscpu | grep 'Model name' | cut -f 2 -d ":")"
    echo "$(get_message 'memory'): $(free -h | awk '/^Mem:/ {print $2}')"
    echo "$(get_message 'disk_space'): $(df -h / | awk 'NR==2 {print $4}') $(get_message 'available')"
    (sleep 5) &
    show_progress $! 5
    echo "$(get_message 'operation_completed')"
}

# 函数：更新环境管理器
update_environment_manager() {
    echo "$(get_message 'updating_manager')"
    # 这里可以添加从远程仓库拉取最新版本的逻辑
    (sleep 5) &
    show_progress $! 5
    echo "$(get_message 'operation_completed')"
}

# 函数：生成环境报告
generate_environment_report() {
    echo "$(get_message 'generating_report')"
    echo "$(get_message 'environment_report')" > env_report.txt
    echo "==================" >> env_report.txt
    echo "$(get_message 'date'): $(date)" >> env_report.txt
    echo "$(get_message 'system'): $(uname -a)" >> env_report.txt
    echo "$(get_message 'installed_environments'):" >> env_report.txt
    for env in "${environments[@]}"; do
        if command -v "$env" &> /dev/null; then
            echo "- $env: $(get_message 'installed')" >> env_report.txt
        else
            echo "- $env: $(get_message 'not_installed')" >> env_report.txt
        fi
    done
    (sleep 5) &
    show_progress $! 5
    echo "$(get_message 'report_generated'): env_report.txt"
}

# 函数：处理脚本中断
handle_interrupt() {
    echo -e "\n$(get_message 'operation_interrupted')"
    exit 1
}

# 主菜单
main_menu() {
    while true; do
        echo "----------------------------------------"
        echo "$(get_message 'welcome')"
        echo "$(get_message 'main_menu')"
        echo "1. $(get_message 'install_all')"
        echo "2. $(get_message 'remove_all')"
        echo "3. $(get_message 'manage_individual')"
        echo "4. $(get_message 'batch_operations')"
        echo "5. $(get_message 'switch_language')"
        echo "6. $(get_message 'advanced_options')"
        echo "7. $(get_message 'exit')"
        echo "----------------------------------------"
        read -rp "$(get_message 'choice') " choice

        case $choice in
            1) install_all_environments ;;
            2) remove_all_environments ;;
            3) manage_individual_environment ;;
            4) batch_operations ;;
            5) switch_language ;;
            6) advanced_options ;;
            7) echo "$(get_message 'exiting')"; exit 0 ;;
            *) handle_error "$(get_message 'invalid_choice')" ;;
        esac
    done
}

# 脚本入口
trap handle_interrupt INT TERM
detect_system
main_menu