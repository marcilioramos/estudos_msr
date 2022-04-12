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

##muda a branch em que estão trabalhando 
git checkout staging


###branchens
## essa branch geralmente é usado local onde estão recebando atualizações que ainda não estão sendo testadas
## git branch staging






