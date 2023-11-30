#!/bin/python3

import pandas as pd
from pyzabbix import ZabbixAPI

# Configurações do Zabbix
zabbix_url = 'http://10.93.49.31:81'
zabbix_user = 'user-write-api'
zabbix_password = '0JjOQ4TxfjYJ4fMTZra7zz2ebQQaRb9LDsFyQiLaM/E'

# Configurações do arquivo XLS
xls_file = 'hosts.xls'
sheet_name = 'hosts'
columns = ['hostname', 'ip', 'template', 'group']  # Adicione 'group' na lista de colunas

# Ler dados do arquivo XLS em um DataFrame do pandas
data = pd.read_excel(xls_file, sheet_name=sheet_name, usecols=columns)

# Conectar-se ao Zabbix API
zapi = ZabbixAPI(zabbix_url)
zapi.login(zabbix_user, zabbix_password)

# Adicionar hosts ao Zabbix
for index, row in data.iterrows():
    hostname = row['hostname']
    ip = row['ip']
    template = row['template']
    group_name = row['group']  # Novo campo para o nome do grupo
    
    # Verificar se o grupo já existe no Zabbix
    group_exists = zapi.hostgroup.get(filter={'name': group_name})
    if not group_exists:
        print(f'O grupo {group_name} não existe no Zabbix.')
        continue
    
    # Verificar se o host já existe no Zabbix
    host_exists = zapi.host.get(filter={'host': hostname})
    if host_exists:
        print(f'O host {hostname} já existe no Zabbix.')
    else:
        # Adicionar o host ao Zabbix com o grupo especificado
        host = zapi.host.create(
            host=hostname,
            interfaces=[{'type': 2, 'main': 1, 'useip': 1, 'ip': ip, 'dns': '', 'port': '161', "details":{ 'version': 2, 'community': '{$SNMP_COMMUNITY_DCO}'}}],
            groups=[{'groupid': group_exists[0]['groupid']}],
            templates=[{'templateid': zapi.template.get(filter={'host': template})[0]['templateid']}]
        )
        print(f'O host {hostname} foi adicionado ao Zabbix com o grupo {group_name}.')
