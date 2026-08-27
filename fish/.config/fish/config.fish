if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting ""
set -p PATH ~/.local/bin

# GitHub MCP server (github plugin) token from gh CLI login
set -gx GITHUB_PAT_TOKEN (gh auth token 2>/dev/null)

oh-my-posh init fish --config /usr/share/oh-my-posh/themes/the-unnamed.omp.json | source
zoxide init fish --cmd cd | source
# 111
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function cat 
	command bat $argv
end
function ls
	command eza --icons $argv
end

function lt
	command eza --icons --tree $argv
end
# grub
abbr grub 'LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 sudo grub-mkconfig -o /boot/grub/grub.cfg'
# 小黄鸭补帧 需要steam安装正版小黄鸭
abbr lsfg 'LSFG_PROCESS="miyu"'
# fa运行fastfetch
abbr fa fastfetch
abbr ff fastfetch
abbr reboot 'systemctl reboot'
function sl 
	command sl | lolcat	
end
function 滚
	sysup 
end
function raw
	command ~/.local/bin/random-anime-wallpaper-dms $argv
end

function 安装
	command yay -S $argv
end

function 卸载
	command yay -Rns $argv
end 



# 代理开关
function proxyOn
    set -gx HTTP_PROXY http://127.0.0.1:7890
    set -gx HTTPS_PROXY http://127.0.0.1:7890
    set -gx ALL_PROXY http://127.0.0.1:7890
    set -gx NO_PROXY localhost,127.0.0.1,fastai.enncloud.cn,cnvpn.enn.cn,registry.npmmirror.com,npmmirror.com,mirrors.ustc.edu.cn,mirrors.tuna.tsinghua.edu.cn,mirrors.hit.edu.cn,repo.huaweicloud.com
    # GitHub 显式走代理（git https 方式）
    git config --global http.proxy http://127.0.0.1:7890
    git config --global https.proxy http://127.0.0.1:7890
    echo "✅ 代理已开启 (7890, GitHub→7890)"
end

function proxyOff
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    set -e ALL_PROXY
    set -e NO_PROXY
    # GitHub 代理同步关闭（git https 方式）
    git config --global --unset http.proxy 2>/dev/null
    git config --global --unset https.proxy 2>/dev/null
    echo "❌ 代理已关闭"
end

# VPN 开关（如果有名字不对告诉我改）

# Steam 启动时自动走 7890 代理 + 修复中文输入法
function steam
    env HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890 NO_PROXY=localhost,127.0.0.1 GTK_IM_MODULE=xim XMODIFIERS=@im=fcitx /usr/bin/steam $argv
end

# opencode
fish_add_path /home/ivan/.opencode/bin

fish_add_path ~/.cargo/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by jcode installer
if not contains "/home/ivan/.local/bin" $PATH
    set -gx PATH "/home/ivan/.local/bin" $PATH
end

# 开新终端窗口时自动执行 fastfetch
if status --is-interactive && not set -q FASTFETCH_DONE
    set -gx FASTFETCH_DONE 1
    fastfetch
end

# archlinux-java 别名
alias archJava='archlinux-java'

# ─── nvim 双配置切换 ───
# nvim        → LazyVim（默认，日常使用）
# nvim-mini   → 精简版（快速编辑/服务器）
alias nvim-mini 'NVIM_APPNAME=nvim-mini nvim'

# ─── fff 禁用 home 目录索引（避免大目录扫描消耗资源）───
set -gx FFF_ENABLE_HOME_SCAN 0

# ─── 编辑器：yazi 等工具用 $EDITOR 打开文件 ───
set -gx EDITOR nvim
set -gx VISUAL nvim
