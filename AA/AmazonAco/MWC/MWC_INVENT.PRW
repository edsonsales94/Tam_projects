#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_INVENT()
Prepare Environment Empresa '01' Filial '01'
private aProdEnd := {}
private aProdOK  := {}
 CBA->(DbSetOrder(1))
            CBA->(DbSeek(xFilial('CBA')+"000100457"))
CBLoadEst(aProdEnd,.F.)
CBAnaInv()
return                      

WSRESTFUL INVENT DESCRIPTION "Serviço de Etiquetas"

WSDATA Label AS String

WSMETHOD GET DESCRIPTION "Retornar as informações do inventario " WSSYNTAX "/INVENT/{tipo}/{codigo}/{usuario}" 
WSMETHOD POST DESCRIPTION "Retornar as informações de etiqueta" WSSYNTAX "/INVENT/{tipo}/{codigo}/{usuario}"
End WsRestful



WsMethod Get WSRECEIVE xTipo, xCodigo, xcodusr WSSERVICE INVENT
	
	Local oEtiqueta := JsonObject():New()
	Local lExiste  := .F.             
	Local xTipo    := ""
    Local xCodigo  := ""
    Local cQry     := ""
    local aArray  := {}
	Private aErros := {}
	cReturn := ""

	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")

	If Len(::aURLParms) > 0
		xTipo    := ::aURLParms[01]
        xCodigo  := ::aURLParms[02]
        xcodusr  := posicione("CB1",2,XFILIAL("CB1")+::aURLParms[02],"CB1_CODOPE")
        lExiste  := .T.   
	EndIf        
	

	If lExiste     
       
		cQry := " SELECT * "
        cQry += " FROM "+RetSQLName("CBA")+" CBA (NOLOCK) "
        cQry += " WHERE CBA.D_E_L_E_T_ = '' AND CBA_DATA  = '"+DTOS( DATE() )+"' AND CBA_FILIAL = '"+XFILIAL("CBA")+"'"
        IF xTipo = "M"
            cQry += " AND CBA.CBA_CODINV = '"+xCodigo+"'"
        ELSEIF xTipo = "E"
            cQry += " AND CBA.CBA_LOCALI = '"+xCodigo+"'"
        ELSEIF xTipo = "P"
            cQry += " AND CBA.CBA_PROD = '"+xCodigo+"'"
        ENDIF    
        //cQry += " AND CBA.CBA_STATUS IN ('0','1','2') "

        xdTb2 := MpSysOpenQUery(cQry)
        While !(xdTb2)->(Eof())
            jsonObject =  JsonObject():new()
            jsonObject["filial"]     := AllTrim((xdTb2)->CBA_FILIAL )
            jsonObject["mestre"]     := AllTrim((xdTb2)->CBA_CODINV )
            jsonObject["produto"]    := AllTrim((xdTb2)->CBA_PROD)
            jsonObject["armazem"]    := AllTrim((xdTb2)->CBA_LOCAL)
            jsonObject["endereco"]   := AllTrim((xdTb2)->CBA_LOCALI)
            jsonObject["contagem"]   := (xdTb2)->CBA_CONTR
            AAdd(aArray, jsonObject)
            (xdTb2)->( DbSkip() ) 
        EndDO
        cJson := FWJsonSerialize(aArray)
        ::SetResponse(cJson)
	EndIf


	//MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.





WSMETHOD POST  WSRECEIVE  WSSERVICE INVENT 
	
    Local lPost  := .T.
	Local xCorpo

    ::SetContentType("application/json")


    xCorpo    := ::GetContent()

    aRetornos := _Inventas(xCorpo)
    cReturn   := FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
    ::SetResponse(EncodeUtf8(cReturn))


	
Return lPost

Static Function _Inventas(xdJson)


	Local odInvent   := Nil
	Local aErros     := {}
	Local lSucesso   := .F.
    LOCAL _XdI,_XdY  := 0
    Local _cdNum     := ""
    private aProdEnd := {}
    private aProdOK  := {}

	lOK      := .T.
	cMessage := ""
    
    If FWJsonDeserialize(xdJson,@odInvent)
          
            ConOut("["+Dtoc(date())+" "+Time()+"] Iniciando integracao da rotina de Inventario mensagem:"+odInvent:uuid)
            lOK := .T.
            Conout("Esta no for")
            For _XdY := 01 To Len(odInvent:produtos)

                _cdNum   := CBProxCod('MV_USUINV')
                xdMestre := odInvent:produtos[_XdY]:mestre
                xdCodUsr := posicione("CB1",2,XFILIAL("CB1")+odInvent:usuario,"CB1_CODOPE")

                CBB->(DbSetOrder(1))
                // Se for encontrado verifica o modelo e altera o status
                If CBB->(DbSeek(xFilial('CBB')+xdMestre+xdCodUsr))
                    Reclock("CBB",.F.)  
                    CBB->CBB_FILIAL := xFilial("CBB")
                    CBB->CBB_STATUS := "2"
                    CBB->(MsUnlock())
                Else
                    Reclock("CBB",.T.)  
                    CBB->CBB_FILIAL := xFilial("CBB")
                    CBB->CBB_NUM    := _cdNum
                    CBB->CBB_CODINV := xdMestre
                    CBB->CBB_USU    := xdCodUsr
                    CBB->CBB_STATUS := "2"
                    CBB->(MsUnlock())
                EndIf
                    
                For _XdI:= 1 To Len(odInvent:produtos[_XdY]:etiquetas)
                        CBC->(dbSetOrder(1))
                        If  !CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM+odInvent:produtos[_XdY]:etiquetas[_XdI]:numetiqueta))
                            RecLock("CBC",.T.)
                            CBC->CBC_FILIAL := xFilial("CBC")
                            CBC->CBC_CODINV := xdMestre
                            CBC->CBC_NUM    := _cdNum
                            CBC->CBC_LOCAL  := odInvent:produtos[_XdY]:etiquetas[_XdI]:local
                            CBC->CBC_LOCALI := odInvent:produtos[_XdY]:etiquetas[_XdI]:localiz
                            CBC->CBC_COD    := odInvent:produtos[_XdY]:etiquetas[_XdI]:produto
                            CBC->CBC_LOTECT := odInvent:produtos[_XdY]:etiquetas[_XdI]:lote
                            CBC->CBC_CODETI := odInvent:produtos[_XdY]:etiquetas[_XdI]:numetiqueta
                            CBC->CBC_QUANT  := odInvent:produtos[_XdY]:etiquetas[_XdI]:saldo
                            CBC->CBC_QTDORI := odInvent:produtos[_XdY]:etiquetas[_XdI]:saldo
                            CBC->(MSUNLOCK())
                        endif
                Next 
            NEXT 

            CONOUT("sucesso!")
            lSucesso := .T.
            cMessage := "Operação Executada com Sucesso"
            aAdd(aErros,{"200",cMessage})

            CBA->(DbSetOrder(1))
            CBA->(DbSeek(xFilial('CBA')+xdMestre))
            
            /*
            lxFecha  := lxAna(xFilial('CBA')+xdMestre)
            
            CBA->(DbSetOrder(1))
            
            If CBA->(DbSeek(xFilial('CBA')+xdMestre))
                Reclock("CBA",.F.)  
                CBA->CBA_STATUS := "1"
                CBA->CBA_CONTR  := CBA->CBA_CONTR+1 

                If lxFecha
                    CBA->CBA_STATUS := "4"
                endif 
                CBA->(MsUnlock())
            Endif    
            */    
            CBLoadEst(aProdEnd,.F.)
            CBAnaInv()

            ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Concluindo a integracao da rotina de Inventario, mensagem:"+odInvent:uuid)

        else
            
            lOK := .F.
            cMessage := "Falha ao Efetuar a Leitura do JSON"
            conout(cMesagem)
            aAdd(aErros,{"400",cMessage})    

        ENDIF      
		
//u_fGeraLog(odTransferencia:imei,odTransferencia:uuid,Iif(lSucesso,"1","2"),odTransferencia:usuario,cdJson,"T",cMessage)

Return {aErros,lSucesso}



Static Function lxAna(cxMestre)
Local lxRet  := .F.
Local nxQtd  := {} 

xdTbl := MpSysOpenQUery("select CBC_FILIAL,CBC_CODINV, CBC_NUM, SUM(CBC_QUANT) CBC_QUANT  from  "+RetSQLName("CBC")+" WHERE CBC_FILIAL+CBC_CODINV = ' "+  cxMestre +"' GROUP BY CBC_FILIAL,CBC_CODINV, CBC_NUM ")

While !(xdTbl)->(Eof())
	aAdd(nxQtd,(xdTbl)->CBC_QUANT)	
	(xdTbl)->(dbSkip())
EndDo

If len(nxQtd) >= 2
  lxRet :=   nxQtd[1] <> nxQtd[2]
endif

Return lxRet


static Function CBAnaInv(lMonitor,lAutomatico)
Local nX	       := 0
Local lRet		   := .f.
Local lModelo1 	   := SuperGetMv("MV_CBINVMD")=="1"
DEFAULT lMonitor   := .f.
DEFAULT lAutomatico:= .f.

//Begin Transaction
If Type('aLogMestre')# 'A'
	Private aLogMestre := {}
EndIf

__cMestre   := ""
__aRetCount := AnalisaInv(lMonitor)
If __aRetCount[1]
	qout("foi pro AcertoInv")
	lRet := AcertoInv(aClone(__aRetCount[2]),aClone(__aRetCount[3]),aClone(__aRetCount[4]),lMonitor,lAutomatico)
	
	If ! lRet
		DisarmTransaction()
		If !lAutomatico
			qout("deu ruim")
		EndIf
		Break
	Endif
	
Endif

DbSelectArea("CBA")
RecLock("CBA",.F.)
If __aRetCount[5] .and. !lMsErroAuto .and. CBA->CBA_STATUS # "5"
	CBA->CBA_STATUS := "4"  // 4-finalizado
Else
	CBA->CBA_CONTR := CBA->CBA_CONTR + 1
Endif

CBA->(MsUnlock())
//End Transaction

return


Static Function AcertoInv(aProdOk,aEtiQtdOk,aEtiLidas,lMonitorInv,lAutomatico)
Local aVetor
Local nX
Local cProduto
Local cLote
Local cSLote
Local cNumSeri
Local nPos
Local cArm,cEnd
Local aEtiqueta     := {}
Local lDigitaQtde   := (GetMv("MV_VQTDINV") == "1")
Local dDataInv      := dDataBase
Local dDtValid      := ctod("")
Local aAreaSB7      := GetArea("SB7")
Local nTamCod       := TamSX3('B1_COD')[1]
Local nTamLoc       := TamSX3('B1_LOCPAD')[1]

Private lMsHelpAuto := .T.
Private nModulo     := 4

DEFAULT lMonitorInv := .F.
DEFAULT lAutomatico := .F.

RecLock("CBA",.f.)
CBA->CBA_STATUS := "4"  // 4-finalizado
CBA->(MsUnlock())
If Empty(aProdOK) .and. Empty(aProdEnd)
    qout("primeiro laco")
	// desbloquer o inventario
	CBLoadEst(aProdEnd,.F.)
	For nX := 1 to len(aProdEnd)
		cProduto := Subs(aProdEnd[nX,1],01,nTamCod)
		CBUnBlqInv(CBA->CBA_CODINV,cProduto)
	Next
	RecLock("CBA",.f.)
	CBA->CBA_STATUS := "5"  // 5-Processado sem registro no SB7
	CBA->(MsUnlock())
	Return .t.
EndIf

If !IsTelnet()
	dDataInv := CBA->CBA_DATA
EndIf

For nX := 1 to len(aProdOK)
    qout("laco 2")
	cProduto := Subs(aProdOk[nX,1],01                   ,nTamCod)
	cArm     := Subs(aProdOk[nX,1],nTamCod+01           ,nTamLoc)
	cEnd     := Subs(aProdOk[nX,1],nTamCod+nTamLoc+01   ,15)
	cLote    := Subs(aProdOk[nX,1],nTamCod+nTamLoc+16   ,10)
	cSLote   := Subs(aProdOk[nX,1],nTamCod+nTamLoc+26   ,06)
	cNumSeri := Subs(aProdOk[nX,1],nTamCod+nTamLoc+32   ,20)
	If Empty(cNumSeri) 
		cNumSeri:=Space(20)
	EndIf
	nPos := ascan(aProdEnd,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]==cProduto+cLote+cSLote+cArm+cEnd+cNumSeri})
	If npos > 0
		dDtValid := aProdEnd[npos,8]
	EndIf

	qout("Incluindo Inventario")
    qout(cProduto)
    qout(cArm)
    qout(cEnd)
    qout(CBA->CBA_CODINV)
    qout(dtos(dDataInv))
    qout(aProdOk[nX,2])
    qout(cLote)
    qout(cSLote)
    qout(cNumSeri)

	If !AcdvGSB7(cProduto,cArm,cEnd,CBA->CBA_CODINV,dDataInv,aProdOk[nX,2],cLote,cSLote,cNumSeri,dDtValid)
		qout("lol")
		Return .F.
	Endif

	If npos > 0
		aDel(aProdEnd,nPos)
		aSize(aProdEnd,len(aProdEnd)-1)
	EndIf
Next

/*
For nX := 1 to len(aProdEnd)
	qout("não deve entrar")
	cProduto := aProdEnd[nX,1]
	cArm     := aProdEnd[nX,4]
	cEnd     := aProdEnd[nX,5]
	cLote    := aProdEnd[nX,2]
	cSLote   := aProdEnd[nX,3]
	cNumSeri := aProdEnd[nX,6]
	dDtValid := aProdEnd[nX,8]
	If !AcdvGSB7(cProduto,cArm,cEnd,CBA->CBA_CODINV,dDataInv,0,cLote,cSLote,cNumSeri,dDtValid) //GeraSB7(cProduto,cArm,cEnd,CBA->CBA_CODINV,dDataBase,0,cLote,cSLote,cNumSeri)
        //qout("bla")
		Return .F.
	Endif
Next
*/


Return .T.


Static Function AnalisaInv(lMonitor)
Local aProds  := {}
Local aProdAux:= {}
Local aProdOK := {}
Local aProdOK2:= {}
Local aProdNoOk:={}
Local aEtiQtdOK:={}
Local aEtiLidas:={}
Local nPos
Local i, j
Local cCodCBB := CBB->CBB_NUM
Local cAux:=''
Local nSaldo
Local cProduto,cArm,cEnd,cLote,cSLote,cNumSeri
Local lOK:= .f.
Local lModelo1 := SuperGetMv("MV_CBINVMD")=="1"
Local lUsaCB001:=UsaCB0("01")
Local nTamProd	:= Tamsx3("B1_COD")[1]
Local nTamArm	:= TamSx3("B2_LOCAL")[1]
Private aCods  := {}    

If lModelo1
	CBB->(dbSetOrder(1))
	CBB->(dbSeek(xFilial('CBB')+CBA->CBA_CODINV))
	While ! CBB->(Eof()) .and. xFilial("CBB") == CBB->CBB_FILIAL .and. CBB->CBB_CODINV == CBA->CBA_CODINV
		If CBB->CBB_STATUS == "2"
			Aadd(aCods,CBB->CBB_NUM)
		EndIf
		CBB->(dbSkip())
	EndDo

	For i := 1 To Len(aCods)
		CBC->(dbSetOrder(1))
		CBC->(dbSeek(xFilial('CBC')+aCods[i]))
		While !CBC->(Eof()) .and. xFilial("CBC") == CBC->CBC_FILIAL .and. CBC->CBC_NUM == aCods[i]

			cAux:=Space(10)
			If lUsaCB001 .and.  CBProdUnit(CBC->CBC_COD) //.and. !CBQtdVar(CBC->CBC_COD)
				cAux:= CBC->CBC_CODETI
			EndIf
			If lUsaCB001
				If Ascan(aEtiLidas,CBC->CBC_CODETI) == 0 .And. !Empty(CBC->CBC_CODETI)
					aadd(aEtiLidas,CBC->CBC_CODETI)
				EndIf
			EndIf
			nPos := Ascan(aProds,{|x| x[1] == CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux) .and. x[3]==CBC->CBC_NUM })
			If nPos > 0
				aProds[nPos,2] +=  CBC->CBC_QUANT
			Else
				Aadd(aProds,{CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux),CBC->CBC_QUANT,CBC->CBC_NUM,CBC->CBC_LOCAL,CBC->CBC_LOCALI})
			Endif
			If cCodCBB == CBC->CBC_NUM
				CBC->(CBLog("04",{CBC_COD,CBC_QUANT,CBC_LOTECT,CBC_NUMLOT,CBC_LOCAL,CBC_LOCALI,CBA->CBA_CODINV,CBC_NUM,CBC_CODETI}))
			EndIf
			CBC->(dbSkip())
		EndDo
	Next 
	For i := 1 to len(aProds)
		For j:= 1 to len(aCods)
			CBC->(dbSetOrder(2))
			If ! CBC->(DBSeek(xFilial('CBC')+aCods[j]+aProds[i,1]))
				If Ascan(aProds,{|x| x[1] == aProds[i,1] .and. x[2] ==0 .and. x[3] == aCods[j]  }) == 0
					Aadd(aProds,{aProds[i,1],0,aCods[j],aProds[i,4],aProds[i,5]})
				EndIF
			EndIf
		Next
	Next
	For i := 1 to len(aProds)
		nPos := Ascan(aProdAux,{|x| Padr(x[1],LEN(aProds[i,1]))==Padr(aProds[i,1],LEN(CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux))) .and. StrZero(x[2],12,4) == StrZero(aProds[i,2],12,4) })
		If nPos==0
			Aadd(aProdAux,{aProds[i,1],aProds[i,2],1,aProds[i,4],aProds[i,5]})
		Else
			aProdAux[nPos,3]++
		EndIF
	Next
	For i := 1 to len(aProdAux)
		If aProdAux[i,3] >= CBA->CBA_CONTS
			nPos := Ascan(aProdOK,{|x| x[1] == aProdAux[i,1]})
			If nPos== 0
				aadd(aProdOk,{aProdAux[i,1],aProdAux[i,2],aProdAux[i,4],aProdAux[i,5]})
				If Subs(aProdAux[i,1],LEN(CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER)),10) <> Space(10)
					aadd(aEtiQtdOK,{Subs(aProdAux[i,1],70,10),aProdAux[i,2],aProdAux[i,4],aProdAux[i,5]})
				EndIf
			EndIf
		Else
			nPos := Ascan(aProdNoOK,{|x| x[1] == aProdAux[i,1]})
			If nPos == 0
				aadd(aProdNoOK,{aProdAux[i,1]})
			EndIf
		EndIf
	Next
	For i := 1 to len(aProdOk)
		nPos := Ascan(aProdNoOK,{|x| x[1] == aProdOK[i,1]})
		If nPos > 0
			aDel(aProdNoOk,nPos)
			aSize(aPRodNoOk,Len(aProdNoOK)-1)
		EndIf
	Next
	aProdOk2:={}
	For i:= 1 to len(aProdOK)
		nPos := Ascan(aProdOK2,{|x| Left(x[1],TamSX3("B1_COD")[1]+TamSX3("B2_LOCAL")[1]+15+10+6+20) == Left(aProdOK[i,1],TamSX3("B1_COD")[1]+TamSX3("B2_LOCAL")[1]+15+10+6+20)})
		If nPos == 0
			aadd(aProdOk2,{Left(aProdOK[i,1],TamSX3("B1_COD")[1]+TamSX3("B2_LOCAL")[1]+15+10+6+20),aProdOK[i,2],aProdOK[i,3],aProdOK[i,4]})
		Else
			aProdOk2[npos,2] +=aProdOk[i,2]
		EndIF
	Next

	DbSelectArea("CBA")
	RecLock("CBA",.F.)
	If Empty(aProdNoOK)
		CBA->CBA_ANALIS := "1"
	Else
		CBA->CBA_ANALIS := "2"
	EndIf
	CBA->(MsUnLock())

Else
	// posicionar na ultima contagem
	CBB->(dbSetOrder(3))
	If ! CBB->(dbSeek(xFilial('CBB')+CBA->CBA_CODINV))
		MsgInTrans(1,"Mestre de Inventario"+CBA->CBA_CODINV+" Nao encontrado") //###
	EndIf
	While ! CBB->(Eof()) .and. xFilial("CBB") == CBB->CBB_FILIAL .and. CBB->CBB_CODINV == CBA->CBA_CODINV
		CBB->(dbSkip())
	EndDo
	CBB->(dbSkip(-1))
	// Aglutinar as quantidade pela chave
	CBC->(dbSetOrder(1))
	CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM))
	While CBC->( !Eof() .and. xFilial("CBC")+CBB->CBB_NUM == CBC_FILIAL+CBC_NUM)
		cAux:=Space(10)
		If lUsaCB001 .and.  CBProdUnit(CBC->CBC_COD) //.and. CBQtdVar(CBC->CBC_COD)
			cAux:= CBC->CBC_CODETI
		EndIf
		If lUsaCB001
			If Ascan(aEtiLidas,CBC->CBC_CODETI) == 0 .And. !Empty(CBC->CBC_CODETI)
				aadd(aEtiLidas,CBC->CBC_CODETI)
			EndIf
		EndIf
		nPos := Ascan(aProds,{|x| x[1] == CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux) })
		If nPos > 0
			aProds[nPos,2] += CBC->CBC_QUANT
		Else
			Aadd(aProds,{CBC->( CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux),CBC->CBC_QUANT,CBC->CBC_LOCAL,CBC->CBC_LOCALI})
		EndIf
		CBC->(CBLog("04",{CBC_COD,CBC_QUANT,CBC_LOTECT,CBC_NUMLOT,CBC_LOCAL,CBC_LOCALI,CBA->CBA_CODINV,CBC_NUM,CBC_CODETI}))
		CBC->(dbSkip())
	EndDo
	// aglutinar o mesmo produto
	For i:= 1 to len(aProds)
		nPos := Ascan(aProdAux,{|x| Left(x[1],68) == Left(aProds[i,1],68)})
		If nPos== 0
			aadd(aProdAux,{Left(aProds[i,1],nTamProd+nTamArm+15+10+6+20),aProds[i,2]})
		Else
			aProdAux[nPos,2]+=aProds[i,2]
		EndIf
		If lUsaCB001
			aadd(aEtiQtdOK,{Subs(aProds[i,1],69,10),aProds[i,2],aProds[i,3],aProds[i,4]})
		EndIf
	Next

	For i:= 1 to len(aProdAux)
		//CBC_COD
		//               CBC_LOCAL
		//                 CBC_LOCALI
		//                                CBC_LOTECT
		//                                          CBC_NUMLOT
		//                                                CBC_NUMSER
		//12345678901234512123456789012345123456789012345612345678901234567890
		//1234567890123456789012345678901234567890123456789012345678901234567980  regua
		//         1         2         3         4         5         6
		cProduto := Subs(aProdAux[i,1],01,nTamProd)
		cArm     := Subs(aProdAux[i,1],nTamProd+1,nTamArm)
		cEnd     := Subs(aProdAux[i,1],nTamProd+nTamArm+1,15)
		cLote    := Subs(aProdAux[i,1],nTamProd+nTamArm+15,10)
		cSLote   := Subs(aProdAux[i,1],nTamProd+nTamArm+25,06)
		cNumSeri := Subs(aProdAux[i,1],nTamProd+nTamArm+31,20)


		If Localiza(cProduto)
			nSaldo := SaldoSBF(cArm,cEnd,cProduto,cNumSeri,cLote,cSlote)
		ElseIf Rastro(cProduto)
			nSaldo := SaldoLote(cProduto,cArm,cLote,cSLote,.F.)
		Else
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial('SB2')+cProduto+cArm))
			nSaldo := SaldoSB2(,.F.)
		EndIf
		If Str(aProdAux[i,2],12,4) == Str(nSaldo,12,4)
			nPos := Ascan(aProdOK,{|x| x[1] == aProdAux[i,1]})
			If nPos== 0
				aadd(aProdOk,{aProdAux[i,1],aProdAux[i,2]})
			EndIf
			nPos := ascan(aProdEnd,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]==cProduto+cLote+cSLote+cArm+cEnd+cNumSeri })
			If npos > 0
				aDel(aProdEnd,nPos)
				aSize(aProdEnd,len(aProdEnd)-1)
			EndIf
		Else
			nPos := Ascan(aProdNoOK,{|x| x[1] == aProdAux[i,1]})
			If nPos == 0
				aadd(aProdNoOK,{aProdAux[i,1],aProdAux[i,2]})
			EndIf
		EndIf
	Next

	DbSelectArea("CBA")
	RecLock("CBA",.F.)
	If Empty(aProdNoOK)
		CBA->CBA_ANALIS := "1"
	Else
		CBA->CBA_ANALIS := "2"
	EndIf
	CBA->(MsUnLock())

	If lMonitor .and. ! Empty(aProdNoOK)
		aProdOk2 := aClone(aProdNoOk)
		aProdNoOk := {}
	Else
		If Empty(aProdNoOK) .and. ! Empty(aProdEnd)
			aProdNoOK := {"atribuicao simbolica somente para nao validar a contagem"} 
		Elseif Empty(aProdNoOK) .and. Empty(aProdEnd)
			lOK:= .t.
		EndIf
	EndIf
EndIf
Return {(len(aProdNoOK) == 0),aProdOk2,aEtiQtdOK,aEtiLidas,lOK}


static Function AcdvGSB7(cProduto,cArm,cEnd,cDoc,dData,nQuant,cLote,cSLote,cNumSeri,dDtValid)
Local aVetor     := {}
Local aAreaSB1   := {}
Local lCBINV05   :=ExistBlock('CBINV05')
Default cNumSeri := ''
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

aVetor:= {	{"B7_COD",		cProduto,	Nil},;
			{"B7_LOCAL",	cArm,		Nil},;
			{"B7_LOCALIZ",	cEnd,		Nil},;
			{"B7_DOC",		cDoc,		Nil},;
			{"B7_DATA",		dData,		Nil},;
			{"B7_QUANT",	nQuant,		Nil},;
			{"B7_LOTECTL",	cLote,		Nil},;
			{"B7_NUMLOTE",	cSLote,		Nil} }

If ! Empty(cNumSeri)
	aAreaSB1:= GetArea('SB1')
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	If SB1->(FieldPos("B1_QTDSER"))>0 .and.  SB1->B1_QTDSER <> 1
		aadd(aVetor,{"B7_QTSEGUM",1 , nil})
	EndIf
	aadd(aVetor,{"B7_NUMSERI", cNumSeri, Nil})
	RestArea(aAreaSB1)
EndIf
If !Empty(dDtValid)
	aadd(aVetor,{"B7_DTVALID", dDtValid, Nil})
EndIf
MsExecAuto({|x| Mata270(x)},aVetor)
If !lMsErroAuto .AND. lCBINV05
	ExecBlock("CBINV05",,,{cProduto,cArm,cEnd,cDoc,dData,cLote,cSLote,cNumSeri})
Endif
Return ! lMsErroAuto
