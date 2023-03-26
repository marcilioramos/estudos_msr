#!/bin/bash

############################################################################
# Autor: Marcilio Ramos
# Data: 26 03 2023
# Fim: Resolver dependencias para automacao do Zabbix via API usando Python
############################################################################

apt update
apt python-pip3
apt install python-pip3
apt install pip3
pip3 install pandas
pip3 install urllib3
pip install openpyxl
pip install --upgrade urllib3 chardet
pip install xlrd
