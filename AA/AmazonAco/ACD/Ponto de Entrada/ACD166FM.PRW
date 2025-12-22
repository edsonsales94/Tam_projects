#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "APVT100.CH"

//Ponto de entrada Executado apos o encerramento da separação
User Function ACD166FM
  if !EMPTY(CB7->CB7_NUMSOL) //.Or. !EMPTY(CB7->CB7_PEDIDO)
    //Criado array com valores para transferencia com base na lista de separacao
    TrataArray(CB7->CB7_ORDSEP, CB7->CB7_NUMSOL)
  Endif
return

*********************************************************************************************************************
            
Static Function TrataArray(cOrdSep, cPedido)
Local lTransf := .F.
Local aHisEti := {}
Local aLista  := {}
Local lErro := .f.
Private lTM503 := .F.

  CB9->(DbSeek(xFilial("CB9")+cOrdSep))
  While CB9->CB9_ORDSEP = cOrdSep
	
	aadd(aHisEti,CB9->CB9_CODETI)
	CB9->(dbSkip())
	lTransf := .T.
	
  EndDo
    
  CB8->(DbSeek(xFilial("CB8")+cOrdSep))
  While CB8->CB8_ORDSEP = cOrdSep
	
	aadd(aLista,{CB8->CB8_PROD,CB8->CB8_QTDORI,CB8->CB8_LOCAL,CB8->CB8_LCALIZ,CB8->CB8_LOTECT,"","",CB8->CB8_LOTECT, ""})
	
	CB8->(dbSkip())
	lTransf := .T.
	
  EndDo
  
  if lTransf
    
	    LibEmpenho(aLista,.t.)
		   
	    //Realiza a transferencia entre armazens
	    lErro := GravaTransf(aLista,aHisEti)
	    //Se aconteceu algum erro na transferencia
	    if !lErro
	       //Atualiza Status MATA311 - Transf Armazem
		  	if NNS->(DbSeek(xFilial("NNS")+CB7->CB7_NUMSOL))
		      RecLock("NNS",.F.)
		        NNS->NNS_STATUS := '2' //Transferencia entre armazem concluido
		      MsUnLock()
		    Endif
		Endif
			    
	Endif    
	//caso tenha ocorrido algum erro desfaz toda movimentacao de separacao.	    
	if lErro
		if NNS->(DbSeek(xFilial("NNS")+CB7->CB7_NUMSOL))
		      RecLock("NNS",.F.)
		        NNS->NNS_STATUS := '3' //Transferencia entre armazem concluido
		      MsUnLock()
		Endif
	   	RestSolic(cOrdSep)
	Else
	// Realiza checagem se todas as etiquetas foram transferias para o local correto
	// Existe uma falha na hora da atualização das etiquetas que nem todas sao movimentadas
	/*
		if  EMPTY(cPedido)
			CheckCB0(cOrdSep,"N2","ACEITE")
		    //libera etiquetas lidas para evitar bloqueio (ETIQUETA JA LIDA)
		    LibEtiqCB9(cOrdSep)
		Endif
	*/	
	Endif
	
  
Return

*********************************************************************************************************************
Static Function checkCB0(cOrdSep, cLocal, cLocaliz,cProds)
Local cQry := ""

//SELECT CB9_FILIAL, CB9_ORDSEP, CB9_CODETI, CB0_LOCAL, CB0_LOCALI
cQry := " UPDATE "+RetSQLName("CB0")+" SET CB0_LOCAL = '"+cLocal+"', CB0_LOCALI = '"+cLocaliz+"' "
cQry += " FROM "+RetSQLName("CB9")+" A, "+RetSQLName("CB0")+" B "
cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'  "
cQry += " AND CB9_FILIAL = CB0_FILIAL "
cQry += " AND CB9_CODETI = CB0_CODETI "
cQry += " AND CB9_ORDSEP = '"+cOrdSep+"' "
cQry += " AND CB9_PROD   = '"+cProds+"' "

TCSqlExec(cQry) 

Return

*********************************************************************************************************************

Static Function GrvTM503(aHisBax)
Local lErro := .F.
Local nx
Local aEtiqueta2 := {}

For nx:=1 to len(aHisBax)
	aEtiqueta := CBRetEti(aHisBax[nx],"01",,.t.)
	aadd(aEtiqueta2,aEtiqueta)
Next

lErro := AI130GRMD2(aEtiqueta2)

if lErro
	If(UsaCB0("01"))
		aSort(aEtiqueta2,,, {|x,y| y[1] > x[1]}) //Ordena o array por produto
		SD3->(DbSetOrder(2))
		If ( Len(aEtiqueta2) >= 1 )
			if SD3->( DbSeek(xFilial("SD3")+SD3->D3_DOC+aEtiqueta2[1][1]) )
				For nx:= 1 To Len(aEtiqueta2)      
					CB0->(DbSeek(xFilial("CB0")+aHisBax[nx]))
					AI130GrCB0(aEtiqueta2[nx],aHisBax[nx])
					SD3->(DbSkip())
				Next
			Endif
		EndIf
	EndIf
Endif

Return lErro

*********************************************************************************************************************

Static Function AI130GRMD2(aEtiqueta)
Local aAreaSF5  := SF5->(GetArea())
Local cDocumento:= CriaVar("D3_DOC",.T.) 
Local nX        := 0
Local aItens    := {}
Local aCab      := {} 

Private nModulo := 4

IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)

aCab := {	{"D3_DOC"		,cDocumento							,NIL},;
			{"D3_TM"    	,"503"	   							,NIL},;
            {"D3_EMISSAO"	,dDataBase	   						,Nil} } 

For nX:= 1 to Len(aEtiqueta)
	//nQE := CBQtdEmb(aEtiqueta[nX][1])
	If UsaCB0("01")
		aAdd(aItens,{	{"D3_COD"		,aEtiqueta[nX][1]	,nil},;
						{"D3_QUANT"		,aEtiqueta[nX][2]   ,nil},;
						{"D3_LOCAL"		,aEtiqueta[nX][10]	,nil},;
						{"D3_LOCALIZ"	,aEtiqueta[nX][9]	,nil},;
						{"D3_EMISSAO"	,dDataBase	    	,nil}})
						
		If Rastro(aEtiqueta[nX][1])
			aadd(aItens[nX],{"D3_LOTECTL",aEtiqueta[nX][16]        ,nil})
			aadd(aItens[nX],{"D3_NUMLOTE",aEtiqueta[nX][17]        ,nil})
			aadd(aItens[nX],{"D3_DTVALID",aEtiqueta[nX][18]        ,nil})
		EndIf          

		If ! Empty(aEtiqueta[nX][23])
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aEtiqueta[nX][1]))
			If SB1->(FieldPos("B1_QTDSER"))>0 .and.  SB1->B1_QTDSER <> 1
				aadd(aItens[nX],{"D3_QTSEGUM",1 , nil})
			EndIf
			aadd(aItens[nX],{"D3_NUMSERI", aEtiqueta[nX][23] , Nil})
		EndIf		
	Else
		aAdd(aItens,{	{"D3_COD"		,aEtiqueta[nX][1]	,nil},;
						{"D3_QUANT"		,aEtiqueta[nX][2]   ,nil},;
						{"D3_LOCAL"		,cArmazem			,nil},;
						{"D3_LOCALIZ"	,cEndereco			,nil},;
						{"D3_EMISSAO"	,dDataBase	    	,nil}})
						
		If Rastro(aEtiqueta[nX][1])
			aAdd(aItens,{"D3_LOTECTL"	,aEtiqueta[nX][3]	,nil})
			aAdd(aItens,{"D3_NUMLOTE"	,cSLote				,nil})
			aAdd(aItens,{"D3_DTVALID"	,aEtiqueta[nX][4]	,nil})
		EndIf          

		If ! Empty(aEtiqueta[nX][5])
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aEtiqueta[1]))
			If SB1->(FieldPos("B1_QTDSER")) > 0 .And. SB1->B1_QTDSER <> 1
				aAdd(aItens,{"D3_QTSEGUM",1 , nil})
			EndIf
			aAdd(aItens, {"D3_NUMSERI", aEtiqueta[nX][5], Nil})
		EndIf
	EndIf
Next
lMSErroAuto := .F.
lMSHelpAuto := .T.
MSEXECAUTO({|x,y|MATA241(x,y)},aCab,aItens)
lMSHelpAuto := .F.
If lMSErroAuto
	VTBeep(2)
	VTAlert("Falha na gravacao da movimentacao, tente novamente.","Aviso",.T.,6000)  //"Falha na gravacao da movimentacao, tente novamente."###"Aviso"
EndIf

RestArea(aAreaSF5)
Return lMsErroAuto

*********************************************************************************************************************

Static Function AI130GrCB0(aEtiqueta, cEti)
Local lGrava 	:= .F.
Local aAreaCB0  := CB0->(GetArea())

If Empty(aEtiqueta[4]+aEtiqueta[5]+aEtiqueta[6]+aEtiqueta[7]+; //NOTA+SERIE+FORNEC+LOJA
	aEtiqueta[11]+aEtiqueta[12]) //OP+NUMSEQ
	If SF5->F5_TIPO == "D" .And. ! CBProdUnit(aEtiqueta[1])
		aEtiqueta[2] := nQE
		If !Localiza(aEtiqueta[1])
			aEtiqueta[11]:= SD3->D3_OP
			aEtiqueta[12]:= SD3->D3_NUMSEQ
			aEtiqueta[24]:= "SD3"
		EndIf	
	EndIf
	lGrava := .T.
EndIf

If SF5->F5_TIPO == "D" .And. (Localiza(aEtiqueta[1]) .Or. Rastro(aEtiqueta[1]))
	//-- Se devolucao limpa os campos.
	aEtiqueta[4]  := "" 			 //NOTA
	aEtiqueta[5]  := "" 			 //SERIE
	aEtiqueta[6]  := "" 			 //FORNEC
	aEtiqueta[7]  := "" 			 //LOJA
	aEtiqueta[25] := ""				 //ITEM NOTA FISCAL
	aEtiqueta[9]  := "" 			 //ENDERECO
	aEtiqueta[11] := SD3->D3_OP 	 //OP
	aEtiqueta[12] := SD3->D3_NUMSEQ //NUMERO DE SEQUENCIA
	aEtiqueta[21] := "" 			 //CODIGO DO PALLET
	aEtiqueta[24] := "SD3" 			 //ORIGEM
	lGrava := .T.
EndIf

If lGrava
	CBGrvEti("01",aEtiqueta,If(!UsaCB0("01"),aEtiqueta[len(aEtiqueta)],cEti))
EndIf

RecLock("CB0",.f.)
CB0->CB0_STATUS:= If(SF5->F5_TIPO=="R","1"," ")
CB0->CB0_NUMSEQ:= If(SF5->F5_TIPO=="R",SD3->D3_NUMSEQ," ")
CB0->(MsUnLock())
RestArea(aAreaCB0)
Return

*********************************************************************************************************************

Static Function GravaTransf(aLista,aHisEti)
Local aEtiqueta
Local aSave
Local aTransf    :={}
Local aNumSeqSD3 :={}
Local cArmOri2   := ""
Local cDoc       := ""
Local cEndOri2   := ""
Local dValid
Local nI,nX	     	 	
Local nPos       := 0

Local aHisTrf := {} //Item para transferencia 
Local aHisBax := {} //Item para baixa via TM 530


Private nModulo  := 4

	aSave := VTSAVE()
	VTClear()
	VTMsg('Aguarde...') //
	Begin Transaction
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	aTransf:=Array(len(aLista)+1)
	aTransf[1] := {"",dDataBase}
	For nI := 1 to Len(aLista)
		SB1->(DbSetOrder(1))
		If !SB1->(MsSeek(xFilial("SB1")+aLista[nI,1]))
			VTALERT('Produto "'+aLista[nI,1]+'" nao localizado no cadastro de produtos.',"Aviso",.T.,NIL,3) //###
			DisarmTransaction()
			Break
		EndIf

		NNT->(DbSetOrder(1))
		NNT->(DbSeek(xFilial("NNT")+CB7->CB7_NUMSOL+CB7->CB7_FILIAL+aLista[nI,1]+aLista[nI,3]))

		Aadd(aHisTrf,aHiseti[nI])

		dValid := dDatabase+SB1->B1_PRVALID
		If Rastro(aLista[nI,1])
			SB8->(DbSetOrder(3))
			SB8->(DbSeek(xFilial("SB8")+aLista[nI,1]+aLista[nI,3]+aLista[nI,5]+AllTrim(aLista[nI,6])))
			dValid := SB8->B8_DTVALID
		EndIf

		aTransf[nI+1]:= {{"D3_COD"    , SB1->B1_COD                ,NIL}} 
		aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC               ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM                 ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_LOCAL"  , aLista[nI,3]               ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_LOCALIZ", aLista[nI,4]           	  ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_COD"    , SB1->B1_COD             	  ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC               ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM             	  ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_LOCAL"  , NNT->NNT_LOCLD          	  ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_LOCALIZ", NNT->NNT_LOCDES         	  ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_NUMSERI", aLista[nI,7]               ,NIL})//numserie 
		aAdd(aTransf[nI+1],{"D3_LOTECTL", aLista[nI,5]               ,NIL})//lote
		aAdd(aTransf[nI+1],{"D3_NUMLOTE", aLista[nI,6]               ,NIL})//sublote
		aAdd(aTransf[nI+1],{"D3_DTVALID", dValid                     ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_POTENCI", criavar("D3_POTENCI")      ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_QUANT"  , aLista[nI,2]               ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_QTSEGUM", criavar("D3_QTSEGUM")      ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_ESTORNO", criavar("D3_ESTORNO")      ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_NUMSEQ" , criavar("D3_NUMSEQ")		  ,NIL}) 
		aAdd(aTransf[nI+1],{"D3_LOTECTL", IIF(!Empty(aLista[nI,8]),aLista[nI,8],aLista[nI,5])     ,NIL})
		aAdd(aTransf[nI+1],{"D3_DTVALID", dValid                     ,NIL})
		aAdd(aTransf[nI+1],{"D3_NUMLOTE", IIF(!Empty(aLista[nI,9]),aLista[nI,9],aLista[nI,6])     ,NIL})
		
		If ! UsaCB0("01")
			CBLog("02",{SB1->B1_COD,aLista[nI,2],aLista[nI,5],aLista[nI,6],aLista[nI,3],aLista[nI,4],NNT->NNT_LOCLD,NNT->NNT_LOCDES })
		EndIf

		CheckCB0(CB7->CB7_ORDSEP,NNT->NNT_LOCLD,NNT->NNT_LOCDES,SB1->B1_COD )

	Next
	
	iF Len(aHisTrf) > 0
		MSExecAuto({|x| MATA261(x)},aTransf)
	Endif

	If lMsErroAuto
		VTALERT("Falha na gravacao da transferencia","ERRO",.T.,4000,3) //###
		DisarmTransaction()
		Break
	EndIf
	/*
	If	UsaCb0("01") .And. Len(aHisTrf) > 0

		//Esta possicionado no documento anterior devo possicionar no ultimo documento
   		SD3->(DbSetOrder(4))
   		SD3->(DBGoBottom())   
  		cDoc := SD3->D3_DOC
  		While SD3->D3_DOC == cDoc
 			SD3->(DbSkip(-1))
	 	EndDo       
 	
	 	SD3->(DbSkip())
	
		//Agora estou posicionado no ultimo documento
		cDoc := SD3->D3_DOC
		While SD3->(!Eof() .AND. D3_FILIAL+D3_DOC==xFilial("SD3")+cDoc)
			Aadd(aNumSeqSD3,{SD3->D3_DOC,SD3->D3_NUMSEQ,SD3->D3_COD})
			SD3->(DbSkip())
		EndDo

		For nx:= 1 to len(aHisTrf)
			aEtiqueta := CBRetEti(aHisTrf[nX],"01")
			cArmOri2   := aEtiqueta[10]
			cEndOri2   := aEtiqueta[09]
			If CBProdUnit(aEtiqueta[01])
				aEtiqueta[10] := cArmDes
				aEtiqueta[09] := cEndDes
				nPos	:= AsCan(aNumSeqSD3,{|x| Trim(x[3])==Trim(aEtiqueta[01])})
				If nPos > 0
					aEtiqueta[12] := aNumSeqSD3[nPos,2]
					aEtiqueta[24] := "SD3"
				EndIf
				CBGrvEti("01",aEtiqueta,aHisTrf[nX])
			EndIf
			CBLog("02",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,cArmOri2,cEndOri2,cArmDes,NNT->NNT_LOCDES ,CB0->CB0_CODETI})
		Next
	Else
		// ----
	EndIf

	//Se nao encontrou nenhum erro processa baxia via TM se existir
	If !lMsErroAuto
		if Len(aHisBax) > 0 //!Empty(aHisBax)
			//lMsErroAuto := GrvTM503(aHisBax)
		Endif
	Endif
*/
	End Transaction
	VtRestore(,,,,aSave)
	If	lMsErroAuto
		VTDispFile(NomeAutoLog(),.t.)
	EndIf


Return lMsErroAuto
                  
****************************************************************************************************************************************************************************************************************

Static Function LibEmpenho(aLista,lLiberar)
Local nx
Local nQtd := 0

	SBF->(DbSetOrder(1))
	for nx:=1 to len(aLista)
		//   1                    2              3             4                     5
		//{CB8->CB8_PROD,CB8->CB8_QTDORI,CB8->CB8_LOCAL,CB8->CB8_LCALIZ,CB8->CB8_LOTECT,"","",CB8->CB8_LOTECT, ""}		
		//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
		if( SBF->( dbSeek(xFilial("SBF")+aLista[nx][3]+aLista[nx][4]+aLista[nx][1]+Space(TamSx3("BF_NUMSERI")[1])+aLista[nx][5]))  )
			
			if lLiberar
				nQtd := iif(aLista[nx][2] < SBF->BF_EMPENHO , SBF->BF_EMPENHO - aLista[nx][2] , 0)
			Else
				nQtd := (SBF->BF_EMPENHO + aLista[nx][2])
			Endif
			
			Reclock("SBF",.f.)
				SBF->BF_EMPENHO := nQtd
			SBF->(MSUnlock())
		Endif
	Next
	
Return

****************************************************************************************************************************************************************************************************************

Static Function RestSolic(cOrdSep)

	//Reabre cabecalho para contagem
	TCSqlExec("UPDATE "+RetSQLName("CB7")+" SET CB7_STATUS='1', CB7_STATPA='1', CB7_DTFIMS='', CB7_HRFIMS='' WHERE D_E_L_E_T_<>'*' AND CB7_ORDSEP = '"+cOrdSep+"'") 
	//Reabre itens para contagem
	TCSqlExec("UPDATE "+RetSQLName("CB8")+" SET CB8_SALDOS=CB8_QTDORI WHERE D_E_L_E_T_<>'*' AND CB8_ORDSEP = '"+cOrdSep+"'") 
	//Libera etiquetas lidas
	LibEtiqCB9(cOrdSep)
Return

****************************************************************************************************************************************************************************************************************

Static Function LibEtiqCB9(cOrdSep)
	//Libera etiquetas lidas
	TCSqlExec("UPDATE "+RetSQLName("CB9")+" SET D_E_L_E_T_='*' WHERE D_E_L_E_T_<>'*' AND CB9_ORDSEP = '"+cOrdSep+"'") 
Return

