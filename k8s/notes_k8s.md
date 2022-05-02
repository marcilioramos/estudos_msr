```sh
VPC AWS = Permite criar rede virtuais
Por padrão a AWS cria para vc uma VPC padrão, nunca devemos deletar ela.
```

```sh
### Docker

### buildando uma imagem para numve docker

docker build -t marcilioramos/redis:devops .

### lista todos os IDs do containners
docker ps -a -q

### apaga todos os containers usando o comando acima
docker rm -f $(docker ps -a -q)

### para a stack do docker-compose e remove os containers e a rede.
docker-compose down

```
