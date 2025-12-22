#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
#include "TbiCode.ch"
/*/{protheus.doc}MTA010OK
Ponto de Entrada no botão ok na exclusao do produto
@author Leandro Nascimento
@since 16/09/2013
/*/

USER FUNCTION MTA010OK

Local cPula    	:= CHR(13) + CHR(10)
Local cDataA := Substring(dtos(date()),7,2)+"/"+Substring(dtos(date()),5,2)+"/"+Substring(dtos(date()),1,4)
Private cCodUsr := RetCodUsr()
Private aGrupos := UsrRetGrp(cCodUsr)
Private cUser   := UsrRetName(cCodUsr)                  
Private cNomeUsr:= UsrFullName(cCodUsr)

IF SB1->B1_ZZNIVWF <> "6"
	If Aviso('EXCLUSÃO - Em WorkFlow', 'O Produto: '+Alltrim(SB1->B1_COD)+' - '+Alltrim(SB1->B1_DESC)+' esta aguardando processos WorkFlow, se continuar os processos atuais serão encerrados.'+cPula+'Deseja Continuar?', {'Continuar', 'Cancelar'}) == 1
		
		DbSelectArea("ZB1")
		DbSetOrder(4)
		DbSeek(xFilial("ZB1")+SB1->B1_ZZIDWF,.F.)
		
		Do While ZB1->ZB1_COD ==SB1->B1_COD .And. Alltrim(SB1->B1_ZZIDWF) = Alltrim(ZB1->ZB1_PROCES) .And. ZB1->(!Eof())
			IF  !ZB1->ZB1_STATUS $ ("3|4|") //Concluido ou Bloqueado
				RecLock ("ZB1", .F.)
				ZB1->ZB1_STATUS	:= "4" //Encerrado
				ZB1->ZB1_END	:= cCodUsr    
				ZB1->ZB1_DTEND	:= dDataBase
				ZB1->ZB1_HREND	:= time()
				ZB1->ZB1_OBS	:= "Processo Encerrado [EXCLUSÃO] - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
				MsUnlock ()
			Endif
			DbSkip()
		EndDo
		Return(.T.)
	Endif
Endif


Return(.F.)
