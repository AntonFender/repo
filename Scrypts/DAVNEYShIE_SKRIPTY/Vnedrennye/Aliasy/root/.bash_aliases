alias tail='tail -f -n 40'
alias ls='ls --color=auto -Xh'
alias nano='nano -m$'

# Лог УТМ
alias tra='tail /opt/utm/transport/l/transport_info.log'
alias upd='tail /opt/utm/updater/l/update.log'
alias transaction='tail /opt/utm/transport/l/transport_transaction.log'

# Лог терминал
alias ter='tail /linuxcash/logs/current/terminal.log'
alias ternano='nano -m$ /linuxcash/logs/current/terminal.log'

# Лог изиегаиса
alias eels='ls -l /root/easyegais2/log'
alias ee='tail /root/easyegais2/log/$(echo "$(ls /root/easyegais2/log -t | grep -m1 'cash')")'
alias eenano='nano /root/easyegais2/log/$(echo "$(ls /root/easyegais2/log -t | grep -m1 'cash')")'

# Отправка чеков и клавиш на интерфейс кассира
alias sendtype='DISPLAY=:0 XAUTHORITY=/home/autologon/.Xauthority sudo -u autologon xdotool type'
alias sendkey='DISPLAY=:0 XAUTHORITY=/home/autologon/.Xauthority sudo -u autologon xdotool key'