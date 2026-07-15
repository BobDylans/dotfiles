if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting ""
set -p PATH ~/.local/bin
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
    set -gx NO_PROXY localhost,127.0.0.1,fastai.enncloud.cn
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

    # 先试一下 DNS 是否可解析
    if not command -q host
        echo "⚠️  未安装 host 命令，跳过 DNS 检查"
    else if not host cnvpn.enn.cn >/dev/null 2>&1
        echo "❌ DNS 无法解析 cnvpn.enn.cn"
        echo "   试试用 ping 手动检查：ping -c 2 cnvpn.enn.cn"
        return 1
    end

    # 连接 VPN（前台运行，ldap-sms 会提示输入短信验证码）
    echo "📱 请输入短信验证码（如果提示）："
    LD_LIBRARY_PATH=/opt/MotionPro /opt/MotionPro/vpn_cmdline \
        -h cnvpn.enn.cn \
        -u chengzihao \
        -p "$vpn_pass" \
        -m ldap-sms

    # 根据返回码判断
    if test $status -eq 0
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

# opencode
fish_add_path /home/ivan/.opencode/bin

fish_add_path ~/.cargo/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
