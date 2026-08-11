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
    set -gx NO_PROXY localhost,127.0.0.1,fastai.enncloud.cn,cnvpn.enn.cn
    echo "✅ 代理已开启 (7890)"
end

function proxyOff
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    set -e ALL_PROXY
    set -e NO_PROXY
    echo "❌ 代理已关闭"
end

# VPN 开关（如果有名字不对告诉我改）
# MotionPro VPN: cnvpn.enn.cn / chengzihao / LDAP-SMS
# 凭证存储在 ~/.config/motionpro-creds
# MotionPro VPN: cnvpn.enn.cn / LDAP-SMS
# 凭证存储在 ~/.config/motionpro-creds
function workVpnOn
    # 先单独输入 sudo 密码（避免后台进程的提示和输出混在一起）
    sudo -v || return 1

    # 检查 vpnd 是否已经在运行
    if command pidof vpnd >/dev/null 2>&1
        echo "  ✓ vpnd 已在运行"
    else
        # 启动 vpnd 守护进程（sudo 密码已缓存，不会弹窗）
        sudo -n LD_LIBRARY_PATH=/opt/MotionPro /usr/bin/vpnd &
        # 等待 vpnd 就绪（最多等 5 秒）
        for i in (seq 1 10)
            if command pidof vpnd >/dev/null 2>&1
                echo "  ✓ vpnd 已就绪"
                break
            end
            sleep 0.5
        end
        if not command pidof vpnd >/dev/null 2>&1
            echo "❌ vpnd 启动失败"
            return 1
        end
    end

    # 从凭证文件读取密码
    set -l vpn_pass (grep '^pass=' ~/.config/motionpro-creds | head -1 | sed 's/^pass=//')
    if test -z "$vpn_pass"
        echo "❌ 未找到凭证文件 ~/.config/motionpro-creds"
        return 1
    end

    # 保存当前代理状态，临时清除（VPN 需要直连，不能走 Clash 代理）
    set -l saved_http "$HTTP_PROXY"
    set -l saved_https "$HTTPS_PROXY"
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    # 确保 VPN 域名不走代理
    set -gx NO_PROXY "$NO_PROXY,cnvpn.enn.cn"

    # 连接 VPN（ldap-sms 会提示输入短信验证码）
    # 前端提示语
    echo "📱 请输入短信验证码："
    # 用 timeout 限制 vpn_cmdline 的总运行时间，避免卡在 status 轮询
    # 30 秒足够输入验证码 + 建立 VPN 隧道
    set -l vpn_timeout 45
    timeout $vpn_timeout env -u HTTP_PROXY -u HTTPS_PROXY \
        LD_LIBRARY_PATH=/opt/MotionPro /opt/MotionPro/vpn_cmdline \
        -h cnvpn.enn.cn \
        -u chengzihao \
        -p "$vpn_pass" \
        -m ldap-sms
    set -l vpn_result $status

    # timeout 返回码 124 = 超时
    if test $vpn_result -eq 124
        echo ""
        echo "⏱️  VPN 登录成功，隧道建立中（后台已连上，返回终端）"
        set vpn_result 0
    end

    # 恢复代理状态
    if test -n "$saved_http"
        set -gx HTTP_PROXY "$saved_http"
    end
    if test -n "$saved_https"
        set -gx HTTPS_PROXY "$saved_https"
    end

    # 根据返回码判断
    if test $vpn_result -eq 0
        echo "✅ Work VPN 已开启"
        return 0
    else
        echo "❌ VPN 连接失败"
        echo "   可能原因：短信验证码错误 / DNS 解析失败 / 网络不通"
        echo "   - 试试手动执行：ping -c 2 cnvpn.enn.cn"
        echo "   - 或者换个网络环境重试"
        return 1
    end
end

function workVpnOff
    # 检查 vpnd 是否在运行
    if not command pidof vpnd >/dev/null 2>&1
        echo "⚠️  VPN 未在运行"
        # 即使 vpnd 没运行，也可能有 DNS / 路由残留，顺手清理
    end

    # 先尝试用 stop 命令优雅断开
    LD_LIBRARY_PATH=/opt/MotionPro /opt/MotionPro/vpn_cmdline -s 2>/dev/null
    sleep 1

    # 杀掉 vpnd 守护进程
    sudo killall vpnd 2>/dev/null
    sleep 1
    # 如果没杀掉，强制杀
    if command pidof vpnd >/dev/null 2>&1
        sudo killall -9 vpnd 2>/dev/null
    end

    # 清理 VPN 留下的 DNS / 路由残留
    # 通知 NetworkManager 重新检查连接
    if command -q nmcli >/dev/null
        # 禁用并重新启用网络，重置 DNS 和路由
        nmcli networking off 2>/dev/null
        sleep 1
        nmcli networking on 2>/dev/null
        echo "  ↻ 网络已重置"
    end
    echo "❌ Work VPN 已关闭"
end

function vpnReset
    # 一键重置 VPN 状态 + 网络
    workVpnOff
    echo "  等待 3 秒让网络恢复..."
    sleep 3
    echo "✅ 网络已重置，可以重新连接"
end

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
