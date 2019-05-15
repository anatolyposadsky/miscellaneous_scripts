zbx_to_tgm.sh: Zabbix notifications sender (markdown version).

You must create a new "Media type" with script parameters like:

#1 {ALERT.SUBJECT}
#2 {ALERT.MESSAGE}

And an Action with Operations "Default subject" e.g. *{TRIGGER.STATUS}:* {TRIGGER.NAME} and
"Default message" like:

#1 *HOST:* {HOST.NAME}
#2 *TRIGGER-SEVERITY:* {TRIGGER.SEVERITY}
#3 *ITEM-VALUE:* {ITEM.VALUE}
#4 *EVENT-ID:* {EVENT.ID}
#5 *ITEM-ID:* {ITEM.ID}