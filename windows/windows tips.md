#### alterar na mão o servidor ntp 

~~~
1 – net stop w32time
2 – w32tm /unregister (execute esse comando 2 vezes)
3 – w32tm /register
4 – net start w32time
5 – w32tm /config /syncfromflags:manual /manualpeerlist:a.ntp.br
6 – w32tm /config /update
7 – w32tm /resync

https://dicastech.info/corrigir-a-hora-do-windows-server-2008-2012/
~~~
