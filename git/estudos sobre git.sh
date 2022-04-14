#iniciar um projeto com o git
git init

#mostrar o status do trabalho
git status

#add arquivo ao controle de versão
git add "nome do arquivo"
ou 
#adiciona tudo para versionamento
git add . 

git commit -m "resumo"

#config global do git
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

#envia os codigos para nuvem
git push

#diz para que destino seu condigo está sendo enviado
git remote add origin https://github.com/marcilioramos/estudos_msr

#ver historico dos commits
git reflog

#retornar a uma versão do codigo, vc no caso vai restaurar um commit
git reset --hard "codigo do commit" (esse codigo está disponivel ao rodar o comando git reflog)


###branchens
### branches são caminhos diferentes para o desenvolvimento do seu código, a padrão é a master.

### lista as branchs disponivel no diretorio
git branch

###cria uma nova branch
## essa branch geralmente é usado local onde estão recebando atualizações que ainda não estão sendo testadas
git branch staging

##muda a branch em que estão trabalhando 
git checkout staging

### como fazer um merger entre branchs?, segue os passos
git checkout master (mudar para branch que irá receber o merger)
git merge staging (chama os dados a branch com dados alterados, que irão complementar a branch selecionada acima, com o comando acima)






