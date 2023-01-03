#!/bin/bash
ZMPROV="/opt/zimbra/bin/zmprov"
#
for CONTAS in $($ZMPROV -l gaa) ; do
#$ZMPROV ma $CONTAS zimbraFeatureHtmlComposeEnabled TRUE
#$ZMPROV ma $CONTAS zimbraFeatureViewInHtmlEnabled TRUE
#$ZMPROV ma $CONTAS zimbraPrefComposeFormat html
#$ZMPROV ma $CONTAS zimbraPrefSkin basic
#$ZMPROV ma $CONTAS zimbraPop3Enabled FALSE
$ZMPROV ma $CONTAS zimbraMailQuota 51000000000
done
zimbra@zimbra01:/tmp$ ./altera_contas.sh 
