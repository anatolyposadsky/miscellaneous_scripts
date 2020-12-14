#!/bin/bash

#zabbix variables
USER="user"
PASS="password"
URL="https://examle.com"
COOKIE="/tmp/zabbix_c.tmp"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
SUBJECT="$3"
MESSAGE="$4"

#telegram variables
CHAT_ID="$1"
TOKEN="$2"
TG_URL="https://api.telegram.org/bot${TOKEN}"
IMG_TYPE="attach" #embedded not working yet

#misc. variables
TEXT=$(echo "${MESSAGE}" | grep -vE "^graphimg;")
SUB=$(echo "${MESSAGE}" | awk -F "graphimg;title:" '{if ($2 != "") print $2}' | tail -1 | cut -d" " -f1)
CAPTION_ORIG=$(echo -e "${SUBJECT}\n${TEXT}")
CAPTION=$(echo -e $(echo "${CAPTION_ORIG}" | sed ':a;N;$!ba;s/\n/\\n/g' | awk '{print substr( $0, 0, 200 )}'))
ITEM_ID=$(echo "${MESSAGE}" | awk -F "graphimg;itemid:" '{if ($2 != "") print $2}' | tail -1 | grep -Eo '[0-9]+')
CACHE_IMAGE="/tmp/graph.${ITEM_ID}.png"
PNG_URL="${URL}/chart3.php?period=1800&name=${SUB}&width=900&height=200&graphtype=0&legend=1&items[0][itemid]=${ITEM_ID}&items[0][sortorder]=0&items[0][drawtype]=5&items[0][color]=00CC00"

send_message () {
if [ "$IMG_TYPE" = attach ]; then
  curl -s ${TG_URL}/sendPhoto?chat_id=${CHAT_ID} --form "caption=${CAPTION}" -F "photo=@${CACHE_IMAGE}"
elif [ "$IMG_TYPE" = embedded ]; then
  curl -s --header 'Content-Type: application/json' \
        -X POST -d "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"[​​​​​​​​​​​](${CACHE_IMAGE})\n${CAPTION}\"}"  \
        "${TG_URL}/sendMessage?parse_mode=markdown"
else
  echo "Check IMG_TYPE variable (supported values: embedded, attach)" && exit 1
fi
}

get_graph () {
  URL=$(echo "$1" | sed -e 's/\ /%20/g')
  IMG_NAME="$2"
  curl -s -b ${COOKIE} -g "${URL}" -o ${IMG_NAME}
  send_message;
}

login () {
  curl -c "${COOKIE}" -H "${UA}" -X POST -d "name=${USER}&password=${PASS}&autologin=1&enter=Sign%20in" ${URL}
  get_graph ${PNG_URL} ${CACHE_IMAGE}
}

login;

if [ -f "${CACHE_IMAGE}" ]; then
  rm ${CACHE_IMAGE}
fi
