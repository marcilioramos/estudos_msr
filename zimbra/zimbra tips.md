~~~
verificação de black list:
https://mxtoolbox.com/blacklists.aspx
~~~
#### trocar todas as senhas:
~~~
Para trocar a senha de todos, acredito que somente sendo uma senha padrão para todas as contas. Seria algo do tipo:

$ zmprov -l gaa dominio.com.br >> users.txt
$ for i in $(cat users.txt); do zmprov sp $i senha; done
~~~
