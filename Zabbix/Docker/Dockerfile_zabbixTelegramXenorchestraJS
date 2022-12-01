FROM zabbix/zabbix-server-mysql:6.0-ubuntu-latest
USER root
 
RUN apt-get update
RUN apt-get install python3 python3-pip wget dos2unix sudo git unzip bc libssl-dev mosquitto mosquitto-clients curl -y
RUN pip3 install requests pyTelegramBotAPI pyrogram 
RUN pip3 install -U tgcrypto && pip3 install pycryptodome
RUN cd /tmp ; wget https://raw.githubusercontent.com/sansaoipb/scripts/master/telegram.sh -O telegram.sh ; dos2unix telegram.sh ; sh telegram.sh
RUN cd /tmp/ ; curl -sL https://deb.nodesource.com/setup_14.x -o setup_14.sh ; sh ./setup_14.sh ; 
RUN apt-get install nodejs -y
RUN npm install --global xo-cli ; npm install --global args-parser
