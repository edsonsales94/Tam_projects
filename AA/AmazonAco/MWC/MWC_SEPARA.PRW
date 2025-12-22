#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_SEPARA()
Prepare Environment Empresa '01' Filial '01'
return                      

WSRESTFUL SEPARA DESCRIPTION "Servico de Separacao"

WSDATA cLista AS String

WSMETHOD GET  DESCRIPTION  "Retornar as informacoes das Listas Separacao" WSSYNTAX "/SEPARA/{cLista} || /SEPARA{cLista}"  
WSMETHOD POST DESCRIPTION "Inserir a Separacao Solicitada" WSSYNTAX "/SEPARA || /SEPARA/"


End WsRestful

WsMethod Get WSRECEIVE cLista WSSERVICE SEPARA
	
	Local oSepara  := JsonObject():New()
	Local lExiste  := .T.             
	Local cxLista  := ""
	Local nX       := 0
	Private aErros := {}
	cReturn := ""

	RpcSetType(3)
	ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")

	If Len(::aURLParms) > 0
		cxLista   := ::aURLParms[01]
	Else
		cxLista   := "" 
	EndIf        
	
	CB7->(dbSetOrder(1))

	
    If !CB7->(DbSeek(xFilial("CB7")+cxLista))
        lExiste := .F.
        aAdd(aErros,{"400","Lista de Separacao Invalida"})
        cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)

        ::SetResponse(EncodeUtf8(cReturn))
    EndIf

    if CB7->CB7_STATUS <> '0'
        lExiste := .F.
        aAdd(aErros,{"400","A Lista de Separacao e invalida para esta operacao"})
        cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)

        ::SetResponse(EncodeUtf8(cReturn))
    endif    
	
	If lExiste

            SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SC5")+CB7->CB7_CLIENT+CB7->CB7_LOJA))
			oSepara['ordem' ] 	        := CB7->CB7_ORDSEP
			oSepara['numeroPedido' ] 	:= CB7->CB7_PEDIDO
			oSepara['codigoCliente' ] 	:= CB7->CB7_CLIENT	
            oSepara['lojaCliente' ] 	:= CB7->CB7_LOJA	
            oSepara['descCliente' ] 	:= SA1->A1_NOME

			//conout(ldOk)
			xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName("CB8")+" CB8 INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_COD = CB8_PROD AND SB1.D_E_L_E_T_ = ''  WHERE CB8.D_E_L_E_T_='' AND CB8_ORDSEP = '"+cxLista+"'AND CB8_SALDOS > 0 ")
			oSepara["itens"] :={}
			//Percorre todos as condicoes e faz a montagem do array de fornecedores
			While !(xdTbl)->(Eof())
					nX++
					Aadd(oSepara["itens"],JsonObject():New())

						oSepara["itens"][nX]['codigo']	  := Alltrim((xdTbl)->CB8_PROD)
						oSepara["itens"][nX]['itempv']	  := Alltrim((xdTbl)->CB8_XITPED)
						oSepara["itens"][nX]['itemsp']	  := Alltrim((xdTbl)->CB8_ITEM)
						oSepara["itens"][nX]['desc']      := Alltrim((xdTbl)->B1_DESC)
						oSepara["itens"][nX]['qtd']       := (xdTbl)->CB8_SALDOS
						oSepara["itens"][nX]['UM']        := Alltrim((xdTbl)->B1_UM)
						oSepara["itens"][nX]['lote']      := alltrim((xdTbl)->CB8_LOTECT)
                        oSepara["itens"][nX]['local']     := alltrim((xdTbl)->CB8_LOCAL)
						oSepara["itens"][nX]['import']    := alltrim((xdTbl)->B1_XCODIMP)
				(xdTbl)->(dbSkip())
			EndDo

			
		cReturn := FWJsonSerialize(oSepara, .F., .F., .T.)
		::SetResponse(EncodeUtf8(cReturn))
	EndIf
	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.



WSMETHOD POST WSSERVICE SEPARA
	Local lPost := .T.
	Local cBody

	cBody     := ::GetContent()
	aRetornos := _Separas(cBody)
	cReturn   := FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
	::SetResponse(EncodeUtf8(cReturn))
Return lPost


Static Function _Separas(cdJson)

	Local aAuto      := {}
	Local odSepara   := Nil
	Local aErros     := {}
	Local lSucesso   := .F.
    LOCAL _XdI       := 0
    Local _cArmTran  := ""
    Local _cLocEnd   := ""
    Local _cArmMat   := ""
    Local _cDestArm  := ""
    Local _cDestEnd  := ""
    LOCAL cEndRec    := ""
    //local  cCodSep   := ""
    local nx , ny 
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao
	pRIVATE cCodSep,cArm
	Private cVolume     := Space(10)

	lOK := .T.
	cMessage := ""
	//RpcSetType(3)
	//RpcSetEnv('01','01')


     //PRIMEIRA ETAPA TENTA FAZER A TRANSFERENCIA
    If FWJsonDeserialize(cdJson,@odSepara)
    cCodSep := odSepara:ordem
	      
    //fluxo da separacao
    CB7->(DbSetOrder(1))
    CB7->(DbSeek(xFilial("CB7")+cCodSep))

    For nX := 1 to LEn(odSepara:itens )
		QOUT(odSepara:itens[nx]:isImport )
		iF odSepara:itens[nx]:isImport 
			fAjustaPrd(xFilial("CB7"),cCodSep,odSepara:numeroPedido,odSepara:itens[nx]:import,odSepara:itens[nx]:itempv,odSepara:itens[nx]:itemsp)
		ENDIF	
	
        for Ny := 1 to len(odSepara:itens[nx]:etiquetas)
			cArm    := odSepara:itens[nx]:etiquetas[ny]:local
            GravaCB8(odSepara:itens[nx]:etiquetas[ny]:saldo,odSepara:itens[nx]:etiquetas[ny]:local,odSepara:itens[nx]:etiquetas[ny]:localiz,odSepara:itens[nx]:etiquetas[ny]:produto,odSepara:itens[nx]:etiquetas[ny]:lote,"",odSepara:itens[nx]:etiquetas[ny]:lote,"","",odSepara:itens[nx]:etiquetas[ny]:numetiqueta,"")
        next  

    next 

    If  Separou(cCodSep)
		If CB7->CB7_STATUS == "9"
			cMessage := "Processo de separacao finalizado"
            aAdd(aErros,{"200",cMessage})
			
		Else
			SD3->(DbSetOrder(2))
			If !SD3->(DbSeek(xFilial("SD3")+PadR(CB7->CB7_ORDSEP,TamSx3("D3_DOC")[1])))
				IF FimProcesso(cCodSep) = 1
					cMessage := "Operao Executada com Sucesso"
					aAdd(aErros,{"200",cMessage})
				Else
					cMessage := "FALHA "
					aAdd(aErros,{"400",cMessage})
				ENDIF
			Else
				Reclock("CB7",.f.)
				CB7->CB7_STATUS := "9"   //  "2" -- separacao finalizada
				CB7->CB7_STATPA := " "
				CB7->CB7_DTFIMS := dDataBase
				CB7->CB7_HRFIMS := StrTran(Time(),":","")
				FAltSta("3")
				iF EMPTY(CB7->CB7_NUMSOL)
					FMudaEtiq(CB7->CB7_ORDSEP, u_AACDP02A(CB7->CB7_LOCAL))
				ENDIF
				
                lSucesso := .T.
                cMessage := "Operao Executada com Sucesso"
                aAdd(aErros,{"200",cMessage})
			EndIf
		EndIf
	Else

	cMessage := "Leitura realizada mas ainda esta pendente saldo  "
	aAdd(aErros,{"200",cMessage})
				 

	EndIf

	endif

    
		
//u_fGeraLog(odTransferencia:imei,odTransferencia:uuid,Iif(lSucesso,"1","2"),odTransferencia:usuario,cdJson,"T",cMessage)
//ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Concluindo a integracao da rotina de Tranferencia, mensagem:"+odSepara:uuid)
Return {aErros,lSucesso}


Static Function Separou(cOrdSep)
	Local lRet:= .t.
	Local aCB8	:= CB8->(GetArea('CB8'))

	CB8->(DBSetOrder(1))
	CB8->(DbSeek(xFilial("CB8")+cOrdSep))
	While CB8->(! Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial("CB8")+cOrdSep)
		If CB8->CB8_SALDOS > 0
			lRet:= .f.
			Exit
		EndIf
		CB8->(DbSkip())
	EndDo
	CB8->(RestArea(aCB8))
Return(lRet)



Static Function FimProcesso(cCodSep)
	Local lDiverg := .f.
	Local lRet    := .t.
	Local nSai    := 1
	Local nX 	  := 0
	Local cStatus := "2"
	Local aEmp	  := {}
	Private aTransferencia := {}
	Default lEstorno :=.F.
	//  fim  esta implemntacao dever ser melhor analisada
	//BEGIN TRANSACTION 
		If Separou(cCodSep)
			//Amazon Aco
			if !lEstorno
				CB8->(DbSetOrder(1))
				CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))

				iF EMPTY(CB7->CB7_NUMSOL)
				
				While !CB8->(Eof()) .and. (CB8->CB8_ORDSEP == CB7->CB7_ORDSEP)
					lFinanceiro := CB8->CB8_XULTRA=="N"
					SC6->(DbSetOrder(1))
					aEmpenho :={}
					If SC6->(DbSeek(xFilial("SC6")+CB8->CB8_PEDIDO+CB8->CB8_XITPED+CB8->CB8_PROD))
						SC9->(DbSetOrder(1))
						SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
						While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM==xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))
							If ! Empty(SC9->C9_NFISCAL)
								SC9->(DbSkip())
								Loop
							EndIf
							if  SC9->C9_ORDSEP != CB7->CB7_ORDSEP
								SC9->(DbSkip())
								Loop
							EndIf
							SC9->(a460Estorna())      //estorna o que estava liberado no sdc e sc9
							SC9->(DbSkip())
						Enddo

						CB9->(DbSetOrder(10))
						CB9->(DbSeek(xFilial("CB9")+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD))
						While !CB9->(Eof()) .And. xFilial("CB9")+CB9->CB9_ORDSEP+CB9->CB9_ITESEP+CB9->CB9_PROD==xFilial("CB8")+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD
							nX++

							_xdPos := aScan(aTransferencia, {|x| x[01] == CB9->CB9_PROD .And. x[02] == CB9->CB9_LOCAL .And. x[03]==CB9->CB9_LCALIZ .And. x[06]==CB9->CB9_LOTECT } )
							If _xdPos>0
								aTransferencia[_xdPos,7] += CB9->CB9_QTESEP
								aTransferencia[_xdPos,11]+= ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2)									
							Else
								aAdd(aTransferencia,{CB9->CB9_PROD  ,;//1
													 CB9->CB9_LOCAL ,;//2
													 CB9->CB9_LCALIZ,;
													 u_AACDP02A(CB9->CB9_LOCAL)            ,;
													 "SEPARA"       ,;
													 CB9->CB9_LOTECT,;
													 CB9->CB9_QTESEP,;
													 SC6->C6_NUM    ,;
													 .F.            ,;
													 CB9->CB9_ORDSEP,;
													 ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),;
													 lFinanceiro    ,;
													 SC6->(Recno()) ,;
													 CB9->CB9_ITESEP})
							EndIf	
							CB9->(DbSkip())
						EndDo
					EndIf

					CB8->(Dbskip())
					//EndIf
				EndDo

				ENDIF

				//Amazon Aco
				iF EMPTY(CB7->CB7_NUMSOL)
					lFinaliza := FFinaliza(aTransferencia)
				else
					lFinaliza := .T.	
				ENDIF

				If !lFinaliza
					Reclock("CB7",.f.)
					CB7->CB7_STATUS := "1"  // separando
					CB7->CB7_STATPA := "1"  // Em pausa
					CB7->CB7_DTFIMS := Ctod("  /  /  ")
					CB7->CB7_HRFIMS := "     "
					nSai := 10
				Else
					//Placa()
					If lRet
						Reclock("CB7",.f.)
						CB7->CB7_STATUS := "9"   //  "2" -- separacao finalizada
						CB7->CB7_STATPA := " "
						CB7->CB7_DTFIMS := dDataBase
						CB7->CB7_HRFIMS := StrTran(Time(),":","")
					EndIf


					//Amazon Aco
					//Amazon Aco
					//-- Ponto de entrada no final da separacao
					If ExistBlock("ACD166FM")
						ExecBlock("ACD166FM")
					EndIf
					If CB7->CB7_STATUS == "2" .OR. CB7->CB7_STATUS == "9"
						IF 	UsaCb0("01") 
							CB8->(DbSetOrder(1))
							CB8->(DbGotop())
							If CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))
								CB9->(Dbsetorder(1))
								CB9->(Dbgotop())
								CB9->(Dbseek(xFilial('CB9')+CB7->CB7_ORDSEP))
								while !CB9->(EOF()) .and. CB9->CB9_FILIAL+CB9->CB9_ORDSEP == xfilial('CB9')+CB7->CB7_ORDSEP
									CB0->(Dbsetorder(1))
									CB0->(Dbgotop())
									If CB0->(Dbseek(xFilial('CB0')+CB9->CB9_CODETI))
										Reclock("CB0",.F.)
										CB0->CB0_NFSAI := CB8->CB8_NOTA
										CB0->CB0_SERIES:= CB8->CB8_SERIE
										CB0->(MsUnlock())
									EndIf
									CB9->(Dbskip())
								endDo	
							EndIF
						EndIf		   		
						FAltSta("3")
						iF EMPTY(CB7->CB7_NUMSOL)
							FMudaEtiq(CB7->CB7_ORDSEP, u_AACDP02A(CB7->CB7_LOCAL))
						endif
    					//VTAlert(STR0012,STR0010,.t.,4000)  //"Processo de separacao finalizado"###"Aviso"
					EndIf
				EndIf
			EndIf	

		Else
			
				Reclock("CB7",.f.)
				CB7->CB7_STATUS := "1"  // separando
				CB7->CB7_STATPA := "1"  // Em pausa
				CB7->CB7_DTFIMS := Ctod("  /  /  ")
				CB7->CB7_HRFIMS := "     "
			
			
				CB7->(MsUnlock())
		endif


	//END TRANSACTION
Return nSai




Static Function FMudaEtiq(cOrdem, cLocal)

	cQry := " UPDATE "+RetSQLName("CB0")+" "
	cQry += " SET CB0_LOCAL='"+cLocal+"',CB0_LOCALI='SEPARA',CB0_LOTE='SEPARA' "
	cQry += " FROM "+RetSQLName("CB0")+" CB0 "
	cQry += " INNER JOIN "+RetSQLName("CB9")+" CB9 ON "
	cQry += " CB9.D_E_L_E_T_='' "
	cQry += " AND CB9.CB9_CODETI=CB0.CB0_CODETI "
	cQry += " AND CB9.CB9_PROD=CB0.CB0_CODPRO "
	cQry += " AND CB9.CB9_ORDSEP='"+cOrdem+"' "
	cQry += " WHERE CB0.D_E_L_E_T_='' "

	TCSqlExec( cQry )
Return


Static Function FAltSta(cStatus)
	PA1->(DbSetOrder(1))
	PA1->(DbSeek(xFilial("PA1")+CB7->CB7_ORDSEP))
	RecLock("PA1",.F.)
	PA1->PA1_STATUS := cStatus
	MsUnlock()
Return 


Static Function GravaCB8(nQtde,cArm,cEnd,cProd,cLote,cSLote,cLoteNew,cSLoteNew,cNumSer,cCodCB0,cNumSerNew)

	Local cEndNew	:= CriaVar("CB8_LCALIZ")
	Local cSequen	:= ""	
	Local aCB8		:= GetArea("CB8")
	Local lACDVCB8 	:= ExistBlock("ACDVCB8")
	Local lRet		:= .F.

	CB8->(DbSetOrder(7))
	CB8->(DbSeek(xFilial("CB8")+cCodSep+cArm))
	qout("aqui 1")
	While !CB8->(Eof()) .and. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_LOCAL==xFilial("CB8")+cCodSep+cArm)

		qout("aqui 2")
		cEndNew := cEnd
		cSequen	:= CB8->CB8_SEQUEN

		If !CB8->(CB8_PROD==cProd)
			CB8->(DbSkip())
			Loop
		EndIf
		qout("aqui 3")

		If Empty(CB8->CB8_SALDOS) // ja separado
			CB8->(DbSkip())
			Loop
		EndIf
		qout("aqui 4")

		If CB7->CB7_ORIGEM == "1" .And. !Empty(CB8->CB8_NUMSER) .And. cNumSerNew # CB8->CB8_NUMSER
			If FindFunction("CBVSUBNSER") .And. SuperGetMV("MV_SUBNSER",.F.,'1') $ '2|3'
				// Faz a troca do numero de serie
				SubNSer(@cLoteNew,@cSLoteNew,@cEndNew,cNumSerNew,@cSequen)
			EndIf
		EndIF
		qout("aqui 5")
		
		RecLock("CB8",.F.)
		If nQtde >= CB8->CB8_SALDOS
			GravaCB9(CB8->CB8_SALDOS,cEndNew,cLoteNew,cSLoteNew,cCodCB0,cNumSerNew,cSequen)
			nQtde -= CB8->CB8_SALDOS
			CB8->CB8_SALDOS := 0
			If "01" $ CB7->CB7_TIPEXP .And. !"02" $ CB7->CB7_TIPEXP
				CB8->CB8_SALDOE := 0
			EndIf
		Else
			CB8->CB8_SALDOS -= nQtde
			If "01" $ CB7->CB7_TIPEXP .And. !"02" $ CB7->CB7_TIPEXP
				CB8->CB8_SALDOE -= nQtde
			EndIf
			GravaCB9(nQtde,cEndNew,cLoteNew,cSLoteNew,cCodCB0,cNumSerNew,cSequen)
			nQtde:=0
		EndIf


		CB8->CB8_LOTECT := cLoteNew
		CB8->CB8_NUMLOT := cSLoteNew	
		CB8->CB8_LCALIZ := cEndNew			
		CB8->CB8_SEQUEN := cSequen

		CB8->(MsUnlock())

		If Empty(nQtde)
			Exit
		EndIf
		CB8->(DbSkip())
	EndDo
	RestArea(aCB8)

	Reclock("CB7",.f.)
	CB7->CB7_STATUS := "1"  // inicio separacao
	CB7->(MsUnLock())
Return



Static Function GravaCB9(nQtde,cEndNew,cLoteNew,cSLoteNew,cCodCB0,cNumSerNew,cSequen)
	Default cCodCB0 := Space(10)

	CB9->(DbSetOrder(10))
	If !CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+cLoteNew+cSLoteNew+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER+cVolume+cCodCB0+CB8_PEDIDO)))
		RecLock("CB9",.T.)
		CB9->CB9_FILIAL := xFilial("CB9")
		CB9->CB9_ORDSEP := CB7->CB7_ORDSEP
		CB9->CB9_CODETI := cCodCB0
		CB9->CB9_PROD   := CB8->CB8_PROD
		CB9->CB9_CODSEP := CB7->CB7_CODOPE
		CB9->CB9_ITESEP := CB8->CB8_ITEM
		CB9->CB9_SEQUEN := cSequen
		CB9->CB9_LOCAL  := CB8->CB8_LOCAL
		CB9->CB9_LCALIZ := cEndNew
		CB9->CB9_LOTECT := cLoteNew
		CB9->CB9_NUMLOT := cSLoteNew
		CB9->CB9_NUMSER := cNumSerNew
		CB9->CB9_LOTSUG := CB8->CB8_LOTECT
		CB9->CB9_SLOTSU := CB8->CB8_NUMLOT
		If FieldPos("CB9_NSERSU") > 0
			CB9->CB9_NSERSU := CB8->CB8_NUMSER
		EndIf	
		CB9->CB9_PEDIDO := CB8->CB8_PEDIDO

		If '01' $ CB7->CB7_TIPEXP .Or. !Empty(cVolume)
			If !('02' $ CB7->CB7_TIPEXP)
				CB9->CB9_VOLUME := cVolume
			Else
				CB9->CB9_SUBVOL := cVolume
			EndIf
		EndIf

	Else
		RecLock("CB9",.F.)
	EndIf
	CB9->CB9_QTESEP += nQtde
	CB9->CB9_STATUS := "1"  // separado
	CB9->(MsUnlock())

	If ExistBlock("ACDGCB9")
		ExecBlock("ACDGCB9",.F.,.F.,{nQtde})
	EndIf

Return



Static Function FFinaliza(aTransferencia)
	Local aAuto 		:= {}
	Local aItem			:= {}
	Local cNumSeq := ProxNum()
	Local nY
	Local lRet := .T.
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.


	Conout("Finalizando o Processo Ordem:"+aTransferencia[1,10])
	AAdd(aAuto,{aTransferencia[1,10],dDataBase}) //Adiciona o cabealho da rotina automtica
	lMsErroAuto := .F.

	For nY:=1 To Len(aTransferencia)
		aItem := {}
		conout("Transferindo")

		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aTransferencia[nY,1]))

		SB2->(dbSetOrder(1))
		If ( !SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+aTransferencia[nY,4])) )
			CriaSB2( SB1->B1_COD,aTransferencia[nY,4] )
		EndIf

		//Origem
		aadd(aItem,SB1->B1_COD)  	//D3_COD
		aadd(aItem,SB1->B1_DESC)    //D3_DESCRI
		aadd(aItem,SB1->B1_UM)  	//D3_UM
		aadd(aItem,aTransferencia[nY,2])   	//D3_LOCAL
		aadd(aItem,aTransferencia[nY,3])		//D3_LOCALIZ

		//qout(SB1->B1_COD+"-"+aTransferencia[nY,2]+"-"+aTransferencia[nY,3]+"-"+aTransferencia[nY,6])
		//qout(aTransferencia[nY,7])
		QOUT(POSICIONE("SB8",3,XFILIAL('SB8')+SB1->B1_COD+aTransferencia[nY,4]+aTransferencia[nY,6],"B8_DTVALID"))
		//QOUT(SB1->B1_COD+aTransferencia[nY,4]+aTransferencia[nY,6])

		//Destino
		aadd(aItem,SB1->B1_COD)  	//D3_COD
		aadd(aItem,SB1->B1_DESC)    //D3_DESCRI
		aadd(aItem,SB1->B1_UM)  	//D3_UM
		aadd(aItem,aTransferencia[nY,4])   		//D3_LOCAL
		aadd(aItem,aTransferencia[nY,5])		//D3_LOCALIZ

		aadd(aItem,"")         		//D3_NUMSERI
		aadd(aItem,aTransferencia[nY,6])	//D3_LOTECTL
		aadd(aItem,"")         		//D3_NUMLOTE
		aadd(aItem,POSICIONE("SB8",3,XFILIAL('SB8')+SB1->B1_COD+aTransferencia[nY,2]+aTransferencia[nY,6],"B8_DTVALID"))  //Validade
		aadd(aItem,0)				//D3_POTENCI
		aadd(aItem,aTransferencia[nY,7]) 				//D3_QUANT
		aadd(aItem,aTransferencia[nY,11])				//D3_QTSEGUM
		aadd(aItem,"")   			//D3_ESTORNO
		aadd(aItem,cNumSeq)     		//D3_NUMSEQ
		//aadd(aItem,"SEPARA")//D3_LOTECTL  //Alterado: Williams Messa - 21/01/2020
		//aadd(aItem,"      ")//D3_LOTECTL // Ao invs de passar o Lote como Separa, passando o Lote Original, para gerar o SC9
		aadd(aItem,aTransferencia[nY,6])	//D3_LOTECTL
		aadd(aItem,POSICIONE("SB8",3,XFILIAL('SB8')+SB1->B1_COD+aTransferencia[nY,2]+aTransferencia[nY,6],"B8_DTVALID"))
		aadd(aItem,"")				//D3_ITEMGRD
		aadd(aItem,"")				//D3_OBSERVA

		aadd(aAuto,aItem)

	Next 

	MSExecAuto({|x,y| mata261(x,y)},aAuto,3)

	If lMsErroAuto
		lRet := .F.
		While .T.
			Conout("Erro na transferencia da Ordem:"+aTransferencia[1,10])
			cMessage := u_MDResumeErro(MostraErro("\","Error.log"))
			QOUT(cMessage)
			//VTDispFile(NomeAutoLog(),.t.)
			DisarmTransaction()
		
		EndDo
	Else
		For nY:=1 To Len(aTransferencia)
			aEmp := {}
			//aAdd(aTransferencia,{CB9->CB9_PROD,CB9->CB9_LOCAL,CB9->CB9_LCALIZ,"70","SEPARA",CB9->CB9_LOTECT,CB9->CB9_QTESEP,SC6->C6_NUM,.F.,CB9->CB9_ORDSEP,ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),lFinanceiro,SC6->(Recno())})
			//aadd(aEmp,{CB9->CB9_LOTECT     ,CB9->CB9_NUMLOT,"SEPARA",CB9->CB9_NUMSER,CB9->CB9_QTESEP,ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),,,,,"70",0})
			//aadd(aEmp,{"SEPARA",Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aTransferencia[nY,7],aTransferencia[nY,11],,,,,"75",0}) //Antigo do Arlindo
			//Alterado: Williams Messa - 21/01/2020
			aadd(aEmp,{aTransferencia[nY,6],Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aTransferencia[nY,7],aTransferencia[nY,11],,,,,aTransferencia[nY,4],0})

			SC6->(DbGoto(aTransferencia[nY,13])) 
			cOldLoc := aTransferencia[nY,2]			
			RecLock("SC6",.F.)
			SC6->C6_LOCAL := aTransferencia[nY,4]
			MsUnlock()

			MaLibDoFat(aTransferencia[nY,13],aTransferencia[nY,7],lFinanceiro,.T.     ,.F.    ,.F.   ,    .F.,.F.      ,  ,,aEmp,.F.)


			SC6->(DbGoto(aTransferencia[nY,13])) 				
			RecLock("SC6",.F.)
			SC6->C6_LOCAL := aTransferencia[nY,2]
			MsUnlock()

		
			//Conout("Nro.Ord:"+aTransferencia[1,10]+"Nro.Pedido:"+aTransferencia[1,8]+"Item:"+aTransferencia[1,14])

		Next 

		Conout("Atualizao do SC9, Nro da Ordem: "+aTransferencia[1,10])
		//Chama a Funo para Atualizar o SC9.
		FAtuaSC9(aTransferencia[1,10])
		//
		Conout("Concluiu a liberao do faturamento da Ordem:"+aTransferencia[1,10])

	EndIf	

Return lRet
/*_______________________________________________________________________________

+-----------+------------+-------+----------------------+------+------------+
 Fun?o     FAtuaSC9    Autor  WILLIAMS MESSA        Data  10/01/2020 
+-----------+------------+-------+----------------------+------+------------+
 Descri?o  Funo relacionar o Nro da Ordem com o SC9                    
+-----------+---------------------------------------------------------------+
*/
Static Function FAtuaSC9(cNumOrd)

Local cQry:=""
Local aArea := GETAREA()

cQry := " SELECT CB8_PEDIDO,CB8_PROD,CB8_XITPED,CB8_ORDSEP  FROM " + RetSqlName("CB8") "
cQry += " WHERE D_E_L_E_T_='' AND CB8_QTDORI > 0 AND CB8_ORDSEP='"+Alltrim(cNumOrd)+"'"

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP1", .T., .T. )

While !TMP1->(EOF())
		cQuery := " UPDATE "+ RetSqlName("SC9")
		cQuery += " SET C9_ORDSEP = '"+Alltrim(TMP1->CB8_ORDSEP)+"'"
		cQuery += " WHERE C9_ORDSEP ='' AND C9_PEDIDO='"+Alltrim(TMP1->CB8_PEDIDO)+"'" 
		cQuery += " AND C9_ITEM='"+Alltrim(TMP1->CB8_XITPED)+"'"  
		TCSQLEXEC(cQuery)
		//Conout(TMP1->CB8_XITPED)	
	TMP1->(dbSkip())
End
TMP1->(dbCloseArea())
RestArea(aArea)		

Return


static function fAjustaPrd(cfil,csepara,cnumero,cxprd, citempv,citemsp)
Local cQry := ""

//SELECT CB9_FILIAL, CB9_ORDSEP, CB9_CODETI, CB0_LOCAL, CB0_LOCALI
cQry := " UPDATE "+RetSQLName("SC6")+" SET C6_PRODUTO = '"+cxprd+"' "
cQry += " WHERE C6_FILIAL = '"+cfil+"' "
cQry += " AND C6_ITEM  = '"+citempv+"' "
cQry += " AND C6_NUM  = '"+cnumero+"' "

TCSqlExec(cQry) 

cQry := ""

//SELECT CB9_FILIAL, CB9_ORDSEP, CB9_CODETI, CB0_LOCAL, CB0_LOCALI
cQry := " UPDATE "+RetSQLName("CB8")+" SET CB8_PROD = '"+cxprd+"' "
cQry += " WHERE CB8_FILIAL = '"+cfil+"' "
cQry += " AND CB8_ITEM  = '"+citemsp+"' "
cQry += " AND CB8_ORDSEP  = '"+csepara+"' "

TCSqlExec(cQry) 

cQry := ""

//SELECT CB9_FILIAL, CB9_ORDSEP, CB9_CODETI, CB0_LOCAL, CB0_LOCALI
cQry := " UPDATE "+RetSQLName("PA2")+" SET PA2_PROD = '"+cxprd+"' "
cQry += " WHERE PA2_FILIAL = '"+cfil+"' "
cQry += " AND PA2_ITEM  = '"+citemsp+"' "
cQry += " AND PA2_NUM  = '"+csepara+"' "

TCSqlExec(cQry) 



return 
