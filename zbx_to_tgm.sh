#!/bin/bash

TOKEN_API=
CHAT_ID=
msg=$* #debug

send_message() {
	curl -s --header 'Content-Type: application/json' \
	--request 'POST' --data "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"${*}\n${msg}\"}"  \
	"https://api.telegram.org/bot${TOKEN_API}/sendMessage?parse_mode=markdown"
}

zabbix_alert() {
	HEADER="[<200b><200b><200b><200b><200b><200b><200b><200b><200b><200b><200b>](https://assets.zabbix.com/img/logo/zabbix_logo_313x82.png)"
	send_message ${HEADER};
}

#debug
case $1 in
        *)
                zabbix_alert;
                ;;
esac