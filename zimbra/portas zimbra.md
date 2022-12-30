~~~
A porta 25 tem que deixar aberta para receber emails de outros servidores, essa não tem discussão.
Liberar as demais portas depende dos serviços que tu oferece na tua rede...
Portas 80 e 443 para liberar o webmail. A 80 é opcional, mas se os teus usuários não colocarem https:// no endereço talvez não redirecione.
Portas 143 e 993 para o protocolo IMAP/s - pra uso em aplicativos e softwares de email
Portas 110 e 995 para o protocolo POP3/s - também pra uso em aplicativos e softwares de email, mas esse é o protocolo que baixa a mensagem do servidor
Porta 587 para SMTP submission - envio de email por aplicativos e softwares
Porta 465 pra SMTP submission antigo - esse é pra softwares mais velhos
Porta 7071 pro painel de administração

Sem contar portas do próprio Linux, como a porta 22 para SSH.

Também não é muito interessante bloquear conexões de loopback, vários serviços do Zimbra (como o antispam) usam conexões loopback
~~~
