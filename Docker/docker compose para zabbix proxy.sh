#### criando pasta do projeto
mkdir -p /opt/dockerzabbixproxy/ && cd /opt/dockerzabbixproxy/
 
#### Instalando docker
curl -fsSL https://get.docker.com | sh
 
#### Instalando o docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
 
### criar arquivo compose
touch docker-compose.yml
 
###########################
### editar arquivo compose
##########################
echo "version: '3.6'
 
services:
  zabbix-proxy:
    image: zabbix/zabbix-proxy-sqlite3:alpine-6.0-latest
    ports:
      - 0.0.0.0:${ZABBIX_PROXY_PORT:-10051}:10041
    environment:
      ZBX_PROXYMODE: 0
      ZBX_HOSTNAME: zbxproxy-Zadara
      ZBX_SERVER_HOST: IP DO SERVIDOR:porta
      ZBX_SERVER_PORT: 10051 PORTA USADA
      ZBX_ACTIVESERVERS: 5
      ZBX_METADATA: zabbix-proxy
      ZBX_DEBUGLEVEL: 1
      ZBX_STARTAGENTS: 100
      ZBX_TIMEOUT: 30
      BX_BUFFERSIZE: 1000
      ZBX_STARTPINGERS: 50
      ZBX_STARTDISCOVERERS: 60
 
    volumes:
      - /opt/zbx-proxy/zabbix_agentd.d:/etc/zabbix/zabbix_agentd.d:rw
    stop_grace_period: 1m
    restart: always" > docker-compose.yml
 
 
### executado o docker-compose
docker-compose up -d
