#!/bin/bash
TABLE="$2"
FILTER='housekeeper [deleted'
LOG="/var/log/zabbix/zabbix_server.log"

function discovery {
  echo "{"
  echo "\"data\":["
  grep -F "$FILTER" "$LOG" | awk 'END{print $5, $7, $9, $11, $13, $15, $17}' | sed 's/,//g' | tr ' ' '\n' | while read -r line;do
    echo "${addcomma}"
    echo "{ \"{#HOUSEKEEPER}\" : \"${line}\" }"
    addcomma=","
  done;
  echo "]}"
  echo $out;
}

function overview {
  grep -F "$FILTER" "$LOG" | awk 'END{print}' | awk -F "$TABLE" '{print $1}' | awk '{print $NF}';
}


function tempo {
  grep -F "$FILTER" "$LOG" | awk 'END{print $20}';
}

case $1 in
  discover)
    discovery ;;
  table)
    overview ;;
  tempo)
    tempo ;;
  *)
echo "# Ex: /bin/bash housekeeper.sh discover"
echo "# Ex: /bin/bash housekeeper.sh tempo"
echo "# Ex: /bin/bash housekeeper.sh table hist/trends"
echo "# Ex: /bin/bash housekeeper.sh table items/triggers"
exit ;;
esac