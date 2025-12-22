#include "Protheus.ch"

User Function A415TDOK()
Local lRet       := .T.
Local lRetorno   := .T.
Local _lDescItem := .F.

If !(FunName() $ "MATA415/MATA416")
	Return lRet
EndIf

If lRet
   TMP1->(dbGotop())
	While ( !TMP1->(Eof()) .And. lRetorno)
		aResult := u_VLDESCPRD(TMP1->CK_PRODUTO , TMP1->CK_DESCONT,M->CJ_VEND1)
		If aResult[01] //.Or. u_VLDESCPRD(aCols[i,nProduto] , _nPercLQ) //Adicionado Por Diego
			_lDescItem := .T.
			lRetorno := .F.
		EndIf
		TMP1->(dbSkip())
		
	EndDo
	/*
	If !_lDescItem
		nSoma  := 0
		nTotal := 0
		
		TMP1->(dbGotop())
		While ( !TMP1->(Eof()) )
			nSoma  += TMP1->CK_VALOR * u_VLDESCPRD(TMP1->CK_PRODUTO,,M->CJ_VEND1)[02] / 100
			nTotal += TMP1->CK_VALOR
			//aEval(aCols,{|x| nSoma += Round(x[nPosTot] * u_VLDESCPRD(x[nProduto],,M->C5_VEND1)[02] / 100,2) })
			//aEval(aCols,{|x| nTotal += Round(x[nPosTot],2) } )
			TMP1->(dbSkip())
		EndDo
		
		If(Max( M->CJ_DESCONT, M->CJ_PDESCAB * nTotal / 100  ) > nSoma)
			_lDescItem := .T.
		Endif
	EndIf
   */
EndIF
If _lDescItem
	If Aviso("Atencao","Este Orcamento será Bloqueado por Desconto, Continuar?",{"Sim","Nao"}) = 1
		lRet := .T.
		M->CJ_XBLQORC := Left(M->CJ_XBLQORC,1)+'D'
	else
		lRet := .F.
	EndIf
else
	M->CJ_XBLQORC := Left(M->CJ_XBLQORC,1)+' '
EndIf


If lRet
	Private aPgtos := {}
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA))
	lRetLC := !u_LJ7014()
	If lRetLC
		If M->CJ_CLIENTE == GETMV("MV_CLIPAD")
			MSGALERT("Venda em CHEQUE-PRÉ ou BOLETO não pode ser finalizada com CLIENTE PADRÃO !!!", "ATENÇÃO")
			lRet := .F.
		Else
			if Aviso("Atencao","Este Pedido será Bloqueado por Credito, Continuar?",{"Sim","Nao"}) = 1
				M->CJ_XBLQORC := 'C'+Right(M->CJ_XBLQORC,1)
			else
				lRet := .F.
			EndIf
		EndIf
	else
		M->CJ_XBLQORC := ' '+Right(M->CJ_XBLQORC,1)
	EndIf   
	//IO
	
	If SA1->A1_VEND <> Posicione("SA3",7,XFILIAL("SA3")+RetCodUsr(),"A3_COD") .And. lRet .And. Posicione("SA3",7,XFILIAL("SA3")+RetCodUsr(),"A3_TIPO") == 'E'    
			MSGALERT("Cliente Informado não pertence a este representante", "ATENÇÃO")
			lRet := .F.	
			M->CJ_XBLQORC := ' '+Right(M->CJ_XBLQORC,1) 
    EndIf 
	
EndIf

If lRet 

 	if !EMPTY(M->CJ_XBLQORC)
   	aBloqueio := {}
	   aAdd(aBloqueio,{"Z3_FILIAL",M->CJ_FILIAL})
	   aAdd(aBloqueio,{"Z3_VENDA",M->CJ_NUM})
	   aAdd(aBloqueio,{"Z3_TIPO","3"})
	   aAdd(aBloqueio,{"Z3_CLIENTE",M->CJ_CLIENTE})
	   aAdd(aBloqueio,{"Z3_LOJA",M->CJ_LOJA    })
	   aAdd(aBloqueio,{"Z3_TIPOCLI", Posicione('SA1',1,xFilial("SA1") +SCJ->(CJ_CLIENTE  + CJ_LOJA   ),"A1_TIPO") })
	   aAdd(aBloqueio,{"Z3_VEND",M->CJ_VEND1})
	   aAdd(aBloqueio,{"Z3_EMISSAO",M->CJ_EMISSAO})
	   
	   aAdd(aBloqueio,{"Z3_ENDENT",M->CJ_ENDENT})
	   aAdd(aBloqueio,{"Z3_BAIRROE",M->CJ_BAIRROE})
	   aAdd(aBloqueio,{"Z3_MUNE",M->CJ_MUNE})
	   aAdd(aBloqueio,{"Z3_ESTE",M->CJ_ESTE})
	   //aAdd(aBloqueio,{"Z3_DESCONT",M->CJ_DESCONT})	   
	   aAdd(aBloqueio,{"Z3_PESOL",M->CJ_PESOL})
	   aAdd(aBloqueio,{"Z3_PESOB",M->CJ_PBRUTO})
	   
	   aAdd(aBloqueio,{"Z3_FONEENT",M->CJ_FONEENT})
	   aAdd(aBloqueio,{"Z3_OBS1",M->CJ_OBSENT1})
	   aAdd(aBloqueio,{"Z3_OBS2",M->CJ_OBSENT2})
	   
	   aAdd(aBloqueio,{"Z3_BLOQUEI",M->CJ_XBLQORC})
	   aAdd(aBloqueio,{"Z3_NOMCLI",Posicione('SA1',1,xFilial("SA1") +SCJ->(CJ_CLIENTE  + CJ_LOJA   ),"A1_NOME") })
	   
	   If ExistBlock("AALJ05GRV")
	      u_AALJ05GRV(aBloqueio)
	   EndIf
	   
	EndIf
EndIf

Return lRet




/*powered by DXRCOVRB*/