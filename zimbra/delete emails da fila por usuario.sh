postqueue -p | grep -B1 "nome do usuario" | awk '/^[0-9A-F]+/ {print $1}' | xargs -n1 sudo /opt/zimbra/common/sbin/postsuper -d
