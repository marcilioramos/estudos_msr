### Conceitos


<b>Ingress</b> = é o recurso que permite expor seu serviço para a rede externa. É  possível usar porta, hostname ou path para rotear seu serviço. 
Existem várias maneiras de se configurar um recurso de Ingress e vários provedores desse recurso


```sh
VPC AWS = Permite criar rede virtuais
Por padrão a AWS cria para vc uma VPC padrão, nunca devemos deletar ela.
```

## Docker

```sh

### buildando uma imagem para numve docker

docker build -t marcilioramos/redis:devops .

### lista todos os IDs do containners
docker ps -a -q

### apaga todos os containers usando o comando acima
docker rm -f $(docker ps -a -q)

### para a stack do docker-compose e remove os containers e a rede.
docker-compose down

```
## Kubernetes

``` sh
### conecta no cluster e mostra os nodes que estão funcionando e como estão funcionando
kubectl get nodes

### lista todos os pods que estao rodando no namespace "kube-system"
kubectl get pods -n kube-system


```
