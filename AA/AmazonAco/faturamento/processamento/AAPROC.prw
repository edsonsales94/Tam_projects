User Function AAPROC(cOrcTo,cOrcFrom)

SL1->(dbSetOrder(1))
SL1->(dbSeek('03' + cOrcTo))
while !SL1->(EOF()) .AND. SL1->L1_NUM <= cOrcFrom
if !EMPTY(SL1->L1_XBLQORC)
   	aBloqueio := {}
   	conout('salvando')
	   aAdd(aBloqueio,{"Z3_FILIAL",SL1->L1_FILIAL})
	   aAdd(aBloqueio,{"Z3_VENDA",SL1->L1_NUM})
	   aAdd(aBloqueio,{"Z3_TIPO","1"})
	   aAdd(aBloqueio,{"Z3_CLIENTE",SL1->L1_CLIENTE})
	   aAdd(aBloqueio,{"Z3_LOJA",SL1->L1_LOJA })
	   aAdd(aBloqueio,{"Z3_TIPOCLI",SL1->L1_TIPOCLI})
	   aAdd(aBloqueio,{"Z3_VEND",SL1->L1_VEND})
	   aAdd(aBloqueio,{"Z3_EMISSAO",SL1->L1_EMISSAO})
	   aAdd(aBloqueio,{"Z3_ENDENT",SL1->L1_ENDENT})
	   aAdd(aBloqueio,{"Z3_BAIRROE",SL1->L1_BAIRROE})
	   aAdd(aBloqueio,{"Z3_MUNE",SL1->L1_MUNE})
	   aAdd(aBloqueio,{"Z3_ESTE",SL1->L1_ESTE})
	   aAdd(aBloqueio,{"Z3_DESCONT",SL1->L1_DESCONT})
	   aAdd(aBloqueio,{"Z3_PESOL",SL1->L1_PLIQUI})
	   aAdd(aBloqueio,{"Z3_PESOB",SL1->L1_PBRUTO})
	   aAdd(aBloqueio,{"Z3_FONEENT",SL1->L1_FONEENT})
	   aAdd(aBloqueio,{"Z3_OBS1",SL1->L1_OBSENT1})
	   aAdd(aBloqueio,{"Z3_OBS2",SL1->L1_OBSENT2})
	   aAdd(aBloqueio,{"Z3_BLOQUEI",SL1->L1_XBLQORC})
	   aAdd(aBloqueio,{"Z3_NOMCLI",Posicione('SA1',1,xFilial("SA1") +SL1->(L1_CLIENTE  + L1_LOJA),"A1_NOME") })
	   
	   If ExistBlock("AALJ05GRV")
	      u_AALJ05GRV(aBloqueio)
	      ALERT('FOI')
	   else 
	   EndIf
	   
	EndIf
SL1->(dbSkip())
EndDo
Return Nil