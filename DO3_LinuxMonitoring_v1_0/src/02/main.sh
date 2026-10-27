#!/bin/bash

HOSTNAME=$(hostname)
TIMEZONE="$(timedatectl show -p Timezone --value) UTC $(date +%:::z | sed -E 's/^([+-])0([0-9])/\1\2/')"
USER=$(whoami)
OS=$(cat /etc/os-release | grep PRETTY_NAME | awk -F= '{print $2}')
DATE=$(date +'%d %B %Y %H:%M:%S')
UPTIME=$(uptime -p | sed 's/up //')
UPTIME_SEC=$(cat /proc/uptime | awk -F.  '{print $1}')

IP_ROUTE=$(ip r get 8.8.8.8 | head -1)
IP=$(echo "$IP_ROUTE" | awk '{ for (i = 1; i <= NF; i++) if ($i == "src") print $(i+1)}')
DEV=$(echo "$IP_ROUTE" | awk ' { for (i = 1; i <= NF; i++) if ($i=="dev") print $(i+1)}')
GATEWAY=$(echo "$IP_ROUTE" | awk ' { for (i = 1; i <= NF; i++) if ($i=="via") print $(i+1)}')
MASK_CIDR=$(ip -4 -o addr show dev "$DEV" | awk '{split($4, a, "/"); print a[2]}')
MASK=""

for octet in 1 2 3 4; do
  if [ "$MASK_CIDR" -ge 8 ]; then
    value=255
    MASK_CIDR=$((MASK_CIDR - 8))
  elif [ "$MASK_CIDR" -gt 0 ]; then
    value=$((256 - 2 ** (8 - MASK_CIDR)))
    MASK_CIDR=0
  else
    value=0
  fi
  MASK="${MASK}${value}"
  [ "$octet" -lt 4 ] && MASK="${MASK}."
done

RAM=$(free -b | grep Mem)
RAM_TOTAL="$(echo "$RAM"| awk '{printf "%.3f", $2/10^9}') GB"
RAM_USED="$(echo "$RAM"| awk '{printf "%.3f", $3/10^9}') GB"
RAM_FREE="$(echo "$RAM"| awk '{printf "%.3f", $4/10^9}') GB"

DF_KB=$(df -P -B1000 /)
read SPACE_ROOT SPACE_ROOT_USED SPACE_ROOT_FREE <<< $(echo "$DF_KB" | awk 'NR == 2 {printf "%.2f %.2f %.2f", $2/10^3, $3/10^3, $4/10^3}')
SPACE_ROOT="${SPACE_ROOT} MB"
SPACE_ROOT_USED="${SPACE_ROOT_USED} MB"
SPACE_ROOT_FREE="${SPACE_ROOT_FREE} MB"

OUTPUT="HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
RAM_TOTAL = $RAM_TOTAL
RAM_USED = $RAM_USED
RAM_FREE = $RAM_FREE
SPACE_ROOT = $SPACE_ROOT
SPACE_ROOT_USED = $SPACE_ROOT_USED
SPACE_ROOT_FREE = $SPACE_ROOT_FREE"

echo "$OUTPUT"
echo

read -p "Хотите записать данные в файл? (Y/N): " answr
if [[ "$answr" = "Y" || "$answr" = "y" ]]; then
  echo "$OUTPUT" > "$(date +%d_%m_%y_%H_%M_%S.status)"
  echo "Данные сохранены!"
else
  echo "Сохранение данных отменено!"
fi