#!/bin/bash

if [[ "$(uname -s)" =~ "Darwin" ]]
then
    red=''
    green=''
    yellow=''
    magenta=''
    cyan=''
    none=''
else
    red='\e[91m'
    green='\e[92m'
    yellow='\e[93m'
    magenta='\e[95m'
    cyan='\e[96m'
    none='\e[0m'
fi

WORK_PATH=$(dirname $(readlink -f $0))

## ----------------------------------------
## 第一阶段     确认运行
## ----------------------------------------

## 起始提示
echo -e "${green}"
echo -e "----------------------------------------------------"
echo -e " ____        _                      _____"
echo -e "/ ___|  __ _| | ___   _ _ __ __ _  |  ___| __ _ __"
echo -e "\___ \ / _\` | |/ / | | | '__/ _\` | | |_ | '__| '_ \\"
echo -e " ___) | (_| |   <| |_| | | | (_| | |  _|| |  | |_) |"
echo -e "|____/ \__,_|_|\_\\\\___,_|_|  \__,_| |_|  |_|  | .__/"
echo -e "                                             |_|"
echo -e "----------------------------------------------------"
echo -e "${none}"
echo -e ""
echo -e "提示:"
echo -e "  1. 如需退出脚本, 请按下 ${magenta}Ctrl-C${none} 组合键退出."
echo -e "  2. 在 Linux Shell 中, 复制并不是使用 ${magenta}Ctrl-C${none} 组合键, 请自行寻找你所使用的的终端程序的复制按钮."
echo -e "  3. 如果你的系统没有安装 curl , 请先安装 curl ."
echo -e "      Ubuntu/Debian 安装 curl 命令: ${magenta}apt-get install -y curl${none}"
echo -e "      CentOS 安装 curl 命令:        ${magenta}yum install -y curl${none}"
echo -e "  4. 安装前请检查网络连接以及系统权限."
echo -e "  5. 隧道 ID 可在 ${yellow}https://www.natfrp.com/tunnel/${none} 处获得."
echo -e "  6. 访问密钥可在 ${yellow}https://www.natfrp.com/user/profile/${none} 处获得."
echo -e "  7. 本脚本已经适配 macOS 系统."
echo -e ""

read -p "$(echo -e "继续运行请按 ${yellow}Enter${none} 键, 退出请按 ${magenta}Ctrl-C${none} 键.")" go


## ----------------------------------------
## 第二阶段     检测
## ----------------------------------------

clear && clear                                                                  # 清屏

echo "正在检测运行环境..."

# 判断权限
# [[ $(id -u) != 0 ]] && echo -e "\n 请使用 ${red}root${none} 用户运行此脚本! \n 示例: ${magenta}sudo bash \"${0}\"${none}" && exit -1

FRP_OS_DETECT="$(uname -m)"                                                     # 检测硬件架构
FRP_OS_L_D="$(uname -s)"                                                        # 检测系统类型 [Linux, macOS]
# FRP_OS_B="$(lsb_release -d -s)"                                               # 注: 本命令在某些系统上不可用

[[ "${FRP_OS_DETECT}" =~ "arm"    ]] && FRP_OS_DETECT="arm"                     # 判断架构是否包含 arm
[[ "${FRP_OS_L_D}"    =~ "Darwin" ]] && FRP_OS="darwin"     || FRP_OS="linux"   # 判断系统是否为 macOS

## 输出提示
echo -e "|- 当前系统类型是: ${yellow}${FRP_OS}${none}"
echo -e "|- 系统硬件架构是: ${yellow}${FRP_OS_DETECT}${none}"
# echo -e "|- 你的系统版本是: ${yellow}${FRP_OS_B}${none}"                       # 注: 本命令对应的指令在某些系统上不可用
echo -e "|- 当前系统时间是: ${yellow}$(date +"%Y 年 %m 月 %d 日   %H 时 %M 分")${none}"

case "${FRP_OS_DETECT}" in
"i386")     FRP_ARCH="386"      ;;     # [ x86  架构 ] 32 位系统  (i386)
"x86_64")   FRP_ARCH="amd64"    ;;     # [ x86  架构 ] 64 位系统  (x86_64)
"arm")      FRP_ARCH="arm"      ;;     # [ arm  架构 ] arm
"arm64")    FRP_ARCH="arm64"    ;;     # [ arm  架构 ] arm64
"aarch")    FRP_ARCH="arm"      ;;     # [ arm  架构 ] armv8     (aarch)
"aarch64")  FRP_ARCH="arm64"    ;;     # [ arm  架构 ] armv8 x64 (aarch64)
"mips")     FRP_ARCH="mips"     ;;     # [ mips 架构 ] mips
"mips64")   FRP_ARCH="mips64"   ;;     # [ mips 架构 ] mips64
"mipsle")   FRP_ARCH="mipsle"   ;;     # [ mips 架构 ] mipsle
"mips64le") FRP_ARCH="mips64le" ;;     # [ mips 架构 ] mips64le
*)
    ## 抛出异常&输出帮助讯息
    clear
    echo -e "\n\e[41;30m                    ERROR                    \033[0m"
    echo -e "${red}我们无法自动下载适合你所用的系统的客户端.${none}"
    echo -e ""
    echo -e "              可用的客户端程序列表"
    echo -e "\033[45;37m ID     系统     架构             文件名          \033[0m"
    echo -e "[01]  Windows    i386       ${cyan}frpc_windows_386.exe${none}"
    echo -e "[02]  Windows    amd64      ${cyan}frpc_windows_amd64.exe${none}"
    echo -e "[03]   Linux     i386       ${cyan}frpc_linux_386${none}"
    echo -e "[04]   Linux     amd64      ${cyan}frpc_linux_amd64${none}"
    echo -e "[05]   Linux     arm        ${cyan}frpc_linux_arm${none}"
    echo -e "[06]   Linux     arm64      ${cyan}frpc_linux_arm64${none}"
    echo -e "[07]   Linux     Mips       ${cyan}frpc_linux_mips${none}"
    echo -e "[08]   Linux     Mips64     ${cyan}frpc_linux_mips64${none}"
    echo -e "[09]   Linux     Mipsle     ${cyan}frpc_linux_mipsle${none}"
    echo -e "[10]   Linux     Mips64le   ${cyan}frpc_linux_mips64le${none}"
    echo -e "[11]  FreeBSD    i386       ${cyan}frpc_freebsd_386${none}"
    echo -e "[12]  FreeBSD    amd64      ${cyan}frpc_freebsd_amd64${none}"
    echo -e "[13]   MacOS     amd64      ${cyan}frpc_darwin_amd64${none}"
    echo -e ""
    echo -e ""
    echo -e "如果你的硬件架构在上方列表之中, 请前往 ${yellow}https://www.natfrp.com/tunnel/download/${none} 下载适合的客户端. "
    echo -e "如果条件允许, 也可将下方给出的错误提示上报给网站管理员或脚本作者 [宝硕(${yellow}i@baoshuo.ren${none}), fengberd(${yellow}berd@rbq.email${none})]."
    echo -e "下载完成后请使用 ${magenta}chmod +x 文件名${none} 命令给予运行权限."
    echo -e ""
    read -p "$(echo -e "请按 ${yellow}Enter${none} 键继续显示下一页(调试信息)...")" go
    clear && clear
    echo -e "\n\e[41;93m          [调试用]系统信息          \e[0m\n"
    cat /etc/os-release
    echo -e ""
    uname -a
    echo -e "\n当前时间: ${yellow}$(date +"%Y 年 %m 月 %d 日   %H 时 %M 分")${none}\n\n正在退出...\n"
    exit -1
    ;;
esac


## 脚本异常退出提示
abort(){
    echo -e >&2 ""
    echo -e >&2 "********************"
    echo -e >&2 "*** ${red}脚本执行中断${none} ***"
    echo -e >&2 "********************"
    echo -e >&2 ""
    read -p "$(echo -e "请按 ${yellow}Enter${none} 键退出...")" go
    echo -e "\n当前时间: ${yellow}$(date +"%Y 年 %m 月 %d 日   %H 时 %M 分")${none}\n正在退出...\n"
    exit -1
}

trap 'abort' 0
set -e

## ----------------------------------------
## 第三阶段     下载 & 权限处理
## ----------------------------------------

# 创建文件夹
FRP_EXEC_DIR="/usr/local/frp/"
mkdir -p ${FRP_EXEC_DIR}

# 生成文件名
FRP_EXEC="frpc_${FRP_OS}_${FRP_ARCH}"

# 下载客户端
echo -e "|- 下载客户端...\c"
curl -sSLO "https://getfrp.sh/d/${FRP_EXEC}"
echo -e "      ${green}成功!${none}"

# 移动客户端
echo -e "|- 移动客户端...\c"
mv "./${FRP_EXEC}" "${FRP_EXEC_DIR}"
echo -e "      ${green}成功!${none}"

echo -e "|- 权限处理...\c"
chmod +x "${FRP_EXEC_DIR}${FRP_EXEC}"
echo -e "        ${green}成功!${none}"

trap : 0

## ----------------------------------------
## 第四阶段     命令生成
## ----------------------------------------

echo -e ""
read -p "$(echo -e "请输入你的${yellow}访问密钥${none}: ")" FRP_KEY
read -p "$(echo -e "请输入你的${yellow}隧道 ID${none} : ")" FRP_TID
if [[ "${FRP_OS}" == "darwin" ]]
then
FRP_SERVICE="n"
else
read -p "$(echo -e "是否安装为系统服务?(y/N) : ")"          FRP_SERVICE
fi
echo -e ""

if [[ "${FRP_SERVICE}" == "y" || "${FRP_SERVICE}" == "Y" ]]
then
    echo -e "即将安装为系统服务..."
    clear && clear
else
    echo -e ""
    echo -e "请使用 ${magenta}${FRP_EXEC_DIR}${FRP_EXEC} -f ${FRP_KEY}:${FRP_TID}${none} 命令来启动隧道."
fi

## ----------------------------------------
## 第五阶段     安装服务
## ----------------------------------------

if [[ "${FRP_SERVICE}" == "y" || "${FRP_SERVICE}" == "Y" ]]
then
    # 写配置文件
    echo "[Unit]
Description=Sakura Frp Client Service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=${FRP_EXEC_DIR}${FRP_EXEC} -f ${FRP_KEY}:${FRP_TID}

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/frpc.service

systemctl daemon-reload

    # 启动 frpc 服务
    systemctl enable frpc
    systemctl start  frpc

echo -e ""
echo -e "使用 ${magenta}systemctl stop frpc && systemctl disable frpc${none} 命令停止服务"
echo -e "使用 ${magenta}systemctl status frpc${none} 命令查看服务状态和 frpc 日志"
echo -e "使用 ${magenta}rm -f /lib/systemd/system/frpc.service${none} 命令${red}删除${none}服务配置"
fi

echo -e ""
echo -e "Source by BaoShuo&FENGberd"
echo -e "Thanks for Installing! "
echo -e ""
