MTR - TESTE DE REDE 

Olá!



Para um melhor esclarecimento da natureza do problema e melhor resolução do mesmo, precisamos analisar alguns testes de rede partindo da infraestrutura do serviço conciliador com destino à sua aplicação e nos envie os resultado dos testes abaixo:



1. Realize os testes abaixo de acordo com o sistema operacional de sua máquina local:



||===WINDOWS===|

Acesse o prompt de comando do seu sistema operacional (botão iniciar → programas → acessórios → Prompt de comando) e, por favor digite os seguintes comandos (um por vez):

----
tracert IPDOSERVIDOR
----

Baixe o software WinMTR e execute-o para o IP do servidor:
mtr(https://winmtr-portable.br.uptodown.com/windows): IP_DO_SERVIDOR

Se possível deixe os testes de MTR executando por mais de 5 minutos.
================



||===Mac OS===|


Inicie o Utilitário de rede(Network Utility), Clique em Traceroute como mostra a imagem abaixo:

http://internal-tools.hostdime.com.br/screenshots-suporte/13c364251177.png

Insira o nome de domínio para o qual você gostaria de executar um Traceroute: IP_DO_SERVIDOR

Clique em Rastrear.

Selecione os resultados, clique com o botão direito e selecione Copiar ou pressione COMMAND+C para copiar o texto.
Cole o texto no editor de texto (TextEdit, entre outros) e salve o arquivo, para nos enviar
Repita os passos também na aba Ping, digitando o IP_DO_SERVIDOR

Novamente repita o passo em lookup digitando o domínio: SEU_DOMINIO_PRINCIPAL
============



||===LINUX===||

Acesse o terminal e execute os comandos abaixo (um por vez):

----
traceroute IP_DO_SERVIDOR
mtr -bewz IP_DO_SERVIDOR
mtr IP_DO_SERVIDOR -udp -n
----

Se possível deixe os testes de MTR executando por mais de 5 minutos.
============



2. Acesse 'https://hostdime.com.br/ferramentas/' e nos informe o IP da conexão que apresenta o problema em questão.



3. Copie o resultado do comando acima junto com o IP, cole em um arquivo de texto e nos envie anexado a este chamado. Com o resultado, poderemos descobrir qual variável causa o problema e a melhor solução para o caso.
