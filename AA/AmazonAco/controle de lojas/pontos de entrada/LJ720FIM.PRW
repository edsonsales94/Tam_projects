#Include "rwmake.ch"

User Function LJ720FIM()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada após a DEVOLUÇÃO da Nota Fiscal (LOJA720-Troca/Devolução)
OBJETIVO 1: Deletar os títulos de CRÉDITO (CR) após a Devolução no Contas a Receber
OBJETIVO 2: Gravar os campos F1_ESPECIE, F3_ESPECIE e FT_ESPECIE com o valor "SPED".
-----------------------------------------------------------------------------------------------------------------------------------------------------*/

DbSelectArea("SE1")
DbSetOrder(1)
                  
cNotaDev  := SE1->E1_NUM+"/"+SE1->E1_SERIE
cWNomeCli := SE1->E1_NOMCLI 
cwValor   := SE1->E1_VALOR

DbSelectArea("SD1")
DbSetOrder(1)

If SD1->(DbSeek(xFilial("SD1")+ParamIxb[1][2]+ParamIxb[1][1]+ParamIxb[1][3]+ParamIxb[1][4]))
	
	cDocOrig := SD1->D1_NFORI
	cSerOrig := SD1->D1_SERIORI
	cNotaOri := cDocOrig+"/"+cSerOrig  
			
	If SE1->(DbSeek(xFilial("SE1")+cSerOrig+cDocOrig))
		
		Do While !SE1->(Eof()) .And. xFilial("SE1")+cSerOrig+cDocOrig == SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM
			
			If Alltrim(SE1->E1_TIPO) == "CR" .And.  SE1->E1_SALDO > 0
				
				Begin Transaction
				
				RecLock("SE1")
				SE1->(DbDelete())
				MsUnLock()
				
				End Transaction
				
			EndIf
			
			SE1->(DbSkip())
			
		EndDo
		
	EndIf
	
EndIf


SF1->(dbSETORDER(1))
SF3->(dbSETORDER(5))
SFT->(dbSETORDER(1))

If SF1->(DbSeek(xFilial("SF1") + ParamIxb[1][2] + ParamIxb[1][1] + ParamIxb[1][3] + ParamIxb[1][4]))
	RecLock("SF1",.F.)
	SF1->F1_ESPECIE := "SPED"
	MsUnLock()
EndIF

If SF3->(DbSeek(xFilial("SF3") + ParamIxb[1][1] + ParamIxb[1][2] + ParamIxb[1][3] + ParamIxb[1][4]))
	RecLock("SF3",.F.)
	SF3->F3_ESPECIE := "SPED"
	MsUnLock()
EndIF

If SFT->(DbSeek(xFilial("SFT") + "E" + ParamIxb[1][1] + ParamIxb[1][2] + ParamIxb[1][3] + ParamIxb[1][4]))
_cChave := SFT->(FT_FILIAL + FT_TIPOMOV + FT_SERIE + FT_NFISCAL + FT_CLIEFOR + FT_LOJA)
 WHile !SFT->(EOF()) .And. SFT->(FT_FILIAL + FT_TIPOMOV + FT_SERIE + FT_NFISCAL + FT_CLIEFOR + FT_LOJA) == _cChave
	RecLock("SFT",.F.)
	SFT->FT_ESPECIE := "SPED"
	MsUnLock()
	SFT->(dbSkip())
 EndDo	
EndIF

If !Empty(SE1->E1_NUMBCO)
	Alert("Este Titulo foi enviado ao Banco. Será enviado um email ao setor Financeiro!")
	U_AAFINW01(cNotaDev,cNotaOri, cwNomeCli, cwValor )
endif

Return