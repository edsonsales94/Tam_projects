#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function CARARQ1(cCampo)
Local cRet := ""
 
cRet := cGetFile("Arquivos de NF (*.txt) |*.txt","Informe o arquivo", 0, "C:\Temp\", .F., GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE)
 
//Atualiza o campo com o caminho selecionado
&(cCampo) := cRet
 
Return (!Empty(cRet))
