Para resolver o problema de history e internal sync será preciso analisar o processo dele via ps e ver se existe fila e demora para escrita

~~~
Every 0.1s: ps aux | grep sync                                                                                                                                     aa0231af558d: Thu Apr 18 10:58:26 2024

root         243  0.0  0.0 2820336 11452 ?       S    10:31   0:00 /usr/sbin/zabbix_server: service manager #1 [processed 0 events, updated 0 event tags, deleted 0 problems, synced 0 service updates, i
root         244  2.8  0.5 2837556 93244 ?       S    10:31   0:46 /usr/sbin/zabbix_server: configuration syncer [synced configuration in 24.058528 sec, idle 60 sec]
root         270  0.6  0.7 2862196 123020 ?      S    10:31   0:10 /usr/sbin/zabbix_server: history syncer #1 [processed 0 values, 0 triggers in 0.000051 sec, idle 1 sec]
root         271  0.6  0.7 2863072 121972 ?      S    10:31   0:11 /usr/sbin/zabbix_server: history syncer #2 [processed 848 values, 761 triggers in 6.785870 sec, syncing history]
root         272  0.6  0.7 2861732 119532 ?      S    10:31   0:10 /usr/sbin/zabbix_server: history syncer #3 [processed 0 values, 0 triggers in 0.000054 sec, idle 1 sec]
root         273  0.6  0.7 2865580 123024 ?      S    10:31   0:10 /usr/sbin/zabbix_server: history syncer #4 [processed 0 values, 0 triggers in 0.000057 sec, syncing history]
root         274  0.7  0.7 2860448 122284 ?      S    10:31   0:11 /usr/sbin/zabbix_server: history syncer #5 [processed 35 values, 2 triggers in 0.191955 sec, syncing history]
root         275  0.7  0.7 2859020 120400 ?      S    10:31   0:11 /usr/sbin/zabbix_server: history syncer #6 [processed 103 values, 85 triggers in 1.073040 sec, syncing history]
root         276  0.7  0.7 2866008 121304 ?      S    10:31   0:11 /usr/sbin/zabbix_server: history syncer #7 [processed 0 values, 0 triggers in 0.000052 sec, idle 1 sec]
root         277  0.6  0.7 2861824 119680 ?      S    10:31   0:10 /usr/sbin/zabbix_server: history syncer #8 [processed 0 values, 0 triggers in 0.000131 sec, idle 1 sec]
root         415  0.1  0.0 2819584 10064 ?       S    10:31   0:02 /usr/sbin/zabbix_server: alert syncer [queued 0 alerts(s), flushed 0 result(s) in 0.005233 sec, idle 1 sec]
root        2432  0.1  0.0   3748  2828 pts/0    S+   10:48   0:01 watch ps ax | grep sync
root        4115  2.0  0.0   3748  2868 pts/1    S+   10:55   0:03 watch -n 0.1 ps aux | grep sync
root        9734  0.0  0.0   3748  1220 pts/1    S+   10:58   0:00 watch -n 0.1 ps aux | grep sync
root        9735  0.0  0.0   2888   944 pts/1    S+   10:58   0:00 sh -c ps aux | grep sync
root        9737  0.0  0.0   3468  1512 pts/1    R+   10:58   0:00 grep syn
~~~
