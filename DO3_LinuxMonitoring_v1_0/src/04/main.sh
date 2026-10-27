#!/bin/bash

CONFIG_FILE="$(dirname "$0")/config.config"
COUNT_PARAM="Необходимы 4 числовых параметра."
TXT_PARAM1="Параметр 1 — это фон названий значений"
TXT_PARAM2="Параметр 2 — это цвет шрифта названий значений"
TXT_PARAM3="Параметр 3 — это фон значений"
TXT_PARAM4="Параметр 4 — это цвет шрифта значений"
COLOR_DESIGN="Обозначения цветов: (1 — white, 2 — red, 3 — green, 4 — blue, 5 – purple, 6 — black)."
HELP_PARAM="\n$COUNT_PARAM\n$TXT_PARAM1\n$TXT_PARAM2\n$TXT_PARAM3\n$TXT_PARAM4\n$COLOR_DESIGN"

declare -A txt_codes=( [1]="37" [2]="31" [3]="32" [4]="34" [5]="35" [6]="30" )
declare -A bg_codes=( [1]="47" [2]="41" [3]="42" [4]="44" [5]="45" [6]="40" )
declare -A name_color=( [1]="white" [2]="red" [3]="green" [4]="blue" [5]="purple" [6]="black" )

#цветовая схема по умолчанию
column1_background=6; c1_bg_def="default (black)"
column1_font_color=1; c1_fc_def="default (white)"
column2_background=2; c2_bg_def="default (red)"
column2_font_color=4; c2_fc_def="default (blue)"

set_color() {
  echo "${name_color[$1]}"
}

if [ -f "$CONFIG_FILE" ]; then
  while IFS='=' read -r key value; do
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    if [[ "$value" =~ ^[1-6]$ ]]; then
      case "$key" in
        column1_background) column1_background=$value; c1_bg_def="$value ($(set_color $value))" ;;
        column1_font_color) column1_font_color=$value; c1_fc_def="$value ($(set_color $value))" ;;
        column2_background) column2_background=$value; c2_bg_def="$value ($(set_color $value))" ;;
        column2_font_color) column2_font_color=$value; c2_fc_def="$value ($(set_color $value))" ;;
      esac
    fi
  done < "$CONFIG_FILE"
fi

if [[ $column1_font_color -eq $column1_background || $column2_font_color -eq $column2_background ]]; then
  echo "Цвет текста и фона не должны совпадать" >&2
  echo -e "$HELP_PARAM"
  exit 3
fi

KEY_CODE="\033[0;${txt_codes[$column1_font_color]};${bg_codes[$column1_background]}m"
VALUE_CODE="\033[0;${txt_codes[$column2_font_color]};${bg_codes[$column2_background]}m"
RESET='\033[0m'

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

print_line() {
  local key="$1"
  local value="$2"

  echo -e "${KEY_CODE}${key}${RESET} = ${VALUE_CODE}${value}${RESET}"
}

print_line "HOSTNAME" "$HOSTNAME"
print_line "TIMEZONE" "$TIMEZONE"
print_line "USER" "$USER"
print_line "OS" "$OS"
print_line "DATE" "$DATE"
print_line "UPTIME" "$UPTIME"
print_line "UPTIME_SEC" "$UPTIME_SEC"
print_line "IP" "$IP"
print_line "MASK" "$MASK"
print_line "GATEWAY" "$GATEWAY"
print_line "RAM_TOTAL" "$RAM_TOTAL"
print_line "RAM_USED" "$RAM_USED"
print_line "RAM_FREE" "$RAM_FREE"
print_line "SPACE_ROOT" "$SPACE_ROOT"
print_line "SPACE_ROOT_USED" "$SPACE_ROOT_USED"
print_line "SPACE_ROOT_FREE" "$SPACE_ROOT_FREE"

echo
echo "Column 1 background = $c1_bg_def"
echo "Column 1 font color = $c1_fc_def"
echo "Column 2 background = $c2_bg_def"
echo "Column 2 font color = $c2_fc_def"