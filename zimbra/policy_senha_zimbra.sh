#!/bin/bash

###################################################################################################################
# Autor: Marcilio Ramos
# Data: 21.04.2024
# Finalidade: Alterar a senha de todas as contas do zimbra e enviar ordem de mudar a senha no próxima login
###################################################################################################################

# Obtém todas as contas do domínio "cabedelo.pg.gov.br" e itera sobre elas
for conta in $(/opt/zimbra/bin/zmprov -l gaa | grep 'cabedelo.pb.gov.br'| grep -vE 'galsync|spam|admin|marcilio'); do
  clear
	echo "$conta"
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMinLength 8
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMinAlphaChars 1
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMinNumericChars 1
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMinUpperCaseChars 1
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMinLowerCaseChars 1
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMinPunctuationChars 1

        # Força a conta a alterar a senha no próximo login
        /opt/zimbra/bin/zmprov ma "$conta" zimbraPasswordMustChange TRUE
done
