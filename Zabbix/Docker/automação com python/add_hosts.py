import pandas as pd
from pyzabbix import ZabbixAPI

# Configurações do Zabbix
zabbix_url = 'http://server/zabbix' # URL do Zabbix
zabbix_user = 'Admin' # Usuário do Zabbix
zabbix_password = 'senha' # Senha do Zabbix

# Configurações do arquivo XLS
xls_file = 'hosts.xls' # Nome do arquivo XLS
sheet_name = 'hosts' # Nome da planilha no arquivo XLS
columns = ['hostname','ip','template'] # Nomes das colunas no arquivo XLS

# Ler dados do arquivo XLS em um DataFrame do pandas
data = pd.read_excel(xls_file, sheet_name=sheet_name, usecols=columns, engine='xlrd')

# Conectar-se ao Zabbix API
zapi = ZabbixAPI(zabbix_url)
zapi.login(zabbix_user, zabbix_password)

# Adicionar hosts ao Zabbix
for index, row in data.iterrows():
    hostname = row['hostname']
    ip = row['ip']
    template = row['template']
    
    # Verificar se o host já existe no Zabbix
    host_exists = zapi.host.get(filter={'host': hostname})
    if host_exists:
        print(f'O host {hostname} já existe no Zabbix.')
    else:
        # Adicionar o host ao Zabbix
        host = zapi.host.create(host=hostname, interfaces=[{'type': 1, 'main': 1, 'useip': 1, 'ip': ip, 'dns': '', 'port': '10050'}], groups=[{'groupid': 1}], templates=[{'templateid': zapi.template.get(filter={'host': template})[0]['templateid']}])
        print(f'O host {hostname} foi adicionado ao Zabbix.')
