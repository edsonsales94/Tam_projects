#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"

user function MWC_PUXADA()
	Prepare Environment Empresa '01' Filial '01'
return


WSRESTFUL PUXADA DESCRIPTION "Serviço de Transferencia "
WSDATA count AS INTEGER
WSMETHOD POST DESCRIPTION "Inserir a Transferencia Solicitada" WSSYNTAX "/PUXADA || /PUXADA/"

End WsRestful




WSMETHOD POST WSSERVICE PUXADA
	Local lPost := .T.
	Local cBody

	cBody     := ::GetContent()
	aRetornos := _Puxas(cBody)
	cReturn   := FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
	::SetResponse(EncodeUtf8(cReturn))
Return lPost

Static Function _Puxas(cdJson)

	Local aAuto      := {}
	Local odPuxada   := Nil
	Local aErros     := {}
	Local lSucesso   := .F.
    LOCAL _XdI       := 0
    Local _cArmTran  := ""
    Local _cLocEnd   := ""
    Local _cArmMat   := ""
    Local _cDestArm  := ""
    Local _cDestEnd  := ""
    LOCAL cEndRec    := ""
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	lOK := .T.
	cMessage := ""
	//RpcSetType(3)
	//RpcSetEnv('01','01')

    _cArmTran  := AllTrim( GetMv("MV_XARMTRA") )
    _cLocEnd   := Substr(Alltrim(GETMV("MV_DISTAUT")),3) 
    _cArmMat   := AllTrim( GetMv("MV_XARMMAT") )
    cEndRec    := Alltrim(GETMV("MV_XENDREC"))   //Endereï¿½o automatico do Rrecebimento 

    //PRIMEIRA ETAPA TENTA FAZER A TRANSFERENCIA
    If FWJsonDeserialize(cdJson,@odPuxada)

        cDocumento := NextNumero("SD3",4,"D3_DOC",.T.)
        ConfirmSx8()
        aAdd(aAuto,{cDocumento,dDataBase})

        SB1->(dbSetOrder(1))            

        For _XdI := 01 To Len(odPuxada:lotes)

            SB1->(dbGoTop())
            SB1->(dbSeek(xFilial('SB1') + odPuxada:lotes[_XdI]:produto))
            _cDestArm  := ""
            _cDestEnd  := ""

            iF SuperGetMv("MV_XCORRI",.F.,.F.) .and. SB1->B1_XCTLCOR == "S"
                _cDestArm  := "06"
                _cDestEnd  := "CQ"
		    Else
                _cDestArm  := _cArmMat
                _cDestEnd  := _cLocEnd
		    Endif

            qout(SB1->B1_COD)
            qout(_cArmTran+ "-"+ _cLocEnd)
            qout(_cDestArm+ "-"+ _cDestEnd)
            qout(odPuxada:lotes[_XdI]:lotectl)
            qout(odPuxada:lotes[_XdI]:quantidade)

           
            aAdd(aAuto, {SB1->B1_COD,;  //Prod Origem
            SB1->B1_DESC,;  //Descrição
            SB1->B1_UM,;  //Unid Medida
            _cArmTran,;  //Armazem origem
            _cLocEnd,;  //End. Origem
            SB1->B1_COD,;  //Prod Dest.
            SB1->B1_DESC,;  //Descrição
            SB1->B1_UM,;  //Unid Medida
            _cDestArm,;  //Armazem Destino
            _cDestEnd,;  //End. Destino
            "",;  //Num. Serie
            odPuxada:lotes[_XdI]:lotectl ,;  //Lote
            "",;  //Sub-Lote
            ctod(odPuxada:lotes[_XdI]:valid),;  //Validade
            0,;  //Potencia
            odPuxada:lotes[_XdI]:quantidade,;  //Quantidade
            ConvUm(SB1->B1_COD,odPuxada:lotes[_XdI]:quantidade,0,2),;  //Qtde 2ª UM
            "",;  //Estornado
            "",;  //Seq.
            odPuxada:lotes[_XdI]:lote,;  //Lote Dest. `
            ctod(odPuxada:lotes[_XdI]:valid),;  //Valid Dest.
            "",;
            ""})  //Documento da transferencia

           
        
        Next 

        Conout('Efetuando Chamada Rotina Automatica'+time())
        MSExecAuto({|x,y| mata261(x,y)},aAuto,3)  // inclusão
        
        If lMsErroAuto 
            cMessage := u_MDResumeErro(MostraErro("\","Error.log"))
            aAdd(aErros,{"400",cMessage})
            conout(cMessage)
            DisarmTransaction()			
        Else
            CONOUT("sucesso!")
            lSucesso := .T.
            cMessage := "Operação Executada com Sucesso"
            aAdd(aErros,{"200",cMessage})
        EndIf
    EndIF

	//SE DEU CERTO FAZ A GRAVACAO DO REGISTRO E BAIXA DOS SALDOS 
    If !lMsErroAuto .and. FWJsonDeserialize(cdJson,@odPuxada)

        cDocs      := GETSXENUM("SZX","ZX_CODIGO",XFILIAL("SZX")+"SZX",1)  
        cxUsuario  := odPuxada:usuario       
        ConfirmSx8()

        RecLock("SZX",.T.)                                                                         
        SZX->ZX_FILIAL	 := XFILIAL("SZX")
        SZX->ZX_CODIGO	 := cDocs
        SZX->ZX_CODMOT	 := "000805"
        SZX->ZX_TIPOV	 := "0004"
        SZX->ZX_LOCENT	 :=	"0002"
        SZX->ZX_VALOR	 := 525
        SZX->ZX_DATA	 := DATE()
        SZX->ZX_HORA	 := SUBSTR(TIME(),1,5)                                                                                                              
        SZX->ZX_USUARIO	 := cxUsuario + "-"+UsrRetName (cxUsuario )                                                                                                       
        MsUnlock()

        If FWJsonDeserialize(cdJson,@odPuxada)
            ConOut("["+Dtoc(date())+" "+Time()+"] Iniciando integracao da rotina de Tranferencia mensagem:"+odPuxada:uuid)
            
            lOK := .T.
            Conout("Esta no for")
            For _XdI := 01 To Len(odPuxada:lotes)

                RecLock("SZY",.T.)
                SZY->ZY_FILIAL	:= xFilial("SZY")               
                SZY->ZY_CODIGO	:= cDocs
                SZY->ZY_LOTEFOR	:= odPuxada:lotes[_XdI]:lote
                SZY->ZY_PACLIS  := odPuxada:lotes[_XdI]:packlist
                SZY->ZY_DOC     := odPuxada:lotes[_XdI]:nota
                SZY->ZY_SERIE   := odPuxada:lotes[_XdI]:serie
                SZY->ZY_FORNECE	:= odPuxada:lotes[_XdI]:fornece
                SZY->ZY_LOJA    := odPuxada:lotes[_XdI]:loja
                SZY->ZY_ITEM    := odPuxada:lotes[_XdI]:item
                SZY->ZY_CODPRO  := odPuxada:lotes[_XdI]:produto
                SZY->ZY_DESCR   := odPuxada:lotes[_XdI]:descr
                SZY->ZY_UM      := odPuxada:lotes[_XdI]:um
                SZY->ZY_LOCAL   := odPuxada:lotes[_XdI]:local
                SZY->ZY_QUANT   := odPuxada:lotes[_XdI]:quantidade
                SZY->ZY_NUMDI   := odPuxada:lotes[_XdI]:numdi
                MSUNLOCK()

                // Atualiza quantidade em transito apos tranferencia.
				SZW->(dbSetOrder(1))
				If SZW->(dbSeek(xFilial("SZW")+SZY->(ZY_PACLIS+ZY_DOC+ZY_SERIE+ZY_FORNECE+ZY_LOJA+ZY_ITEM)))
					RecLock("SZW",.F.)
					SZW->ZW_SALDO -= SZY->ZY_QUANT
					MsUnLock()
				Endif

                SB1->(DbSeek(xFilial("SB1")+SZY->ZY_CODPRO))
                	
                If !CB5SetImp(Alltrim("13"),IsTelNet()) //MV_IACD02
                    QOUT("Codigo do local de impressao invalido!")   //'Codigo do tipo de impressao invalido'
                    Return .f.
                EndIF
                //Alteração Arlindo dia 21/06/2019
                iF SuperGetMv("MV_XCORRI",.F.,.F.) .and. SB1->B1_XCTLCOR=="S"
                    cEndRec := "CQ"
                EndIf
                fimpEtq({SZY->ZY_QUANT,,,1,SZY->ZY_DOC,SZY->ZY_SERIE,SZY->ZY_FORNECE,SZY->ZY_LOJA,SZY->ZY_LOCAL,,,SZY->ZY_LOTEFOR,,,,,,,,cEndRec,})
                SB1->(DbSeek(xFilial("SB1")+SZY->ZY_CODPRO))
		
		    	ExecBlock('IMG01',,,{SZY->ZY_QUANT,,,3,SZY->ZY_DOC,SZY->ZY_SERIE,SZY->ZY_FORNECE,SZY->ZY_LOJA,SZY->ZY_LOCAL,,,SZY->ZY_LOTEFOR,,,,,,,,cEndRec,})
            
            NEXT 
                        
        Else
            lOK := .F.
            cMessage := "Falha ao Efetuar a Leitura do JSON"
            conout(cMesagem)
            aAdd(aErros,{"400",cMessage})
        EndIf
    ENDIF


		
//u_fGeraLog(odTransferencia:imei,odTransferencia:uuid,Iif(lSucesso,"1","2"),odTransferencia:usuario,cdJson,"T",cMessage)
ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Concluindo a integracao da rotina de Tranferencia, mensagem:"+odPuxada:uuid)
Return {aErros,lSucesso}



STATIC Function fimpEtq(aparamixb) //dispositivo de identificacao de produto
Local cCodigo, sConteudo,cTipoBar, nX
Local nqtde 	:= If(len(aparamixb) >= 1,aparamixb[ 1],0)
Local cCodSep 	:= If(len(aparamixb) >= 2,aparamixb[ 2],"")
Local cCodID 	:= If(len(aparamixb) >= 3,aparamixb[ 3],Nil)
Local nCopias	:= If(len(aparamixb) >= 4,aparamixb[ 4],1)
Local cNFEnt  	:= If(len(aparamixb) >= 5,aparamixb[ 5],"")
Local cSeriee   := If(len(aparamixb) >= 6,aparamixb[ 6],"")
Local cFornec   := If(len(aparamixb) >= 7,aparamixb[ 7],"")
Local cLojafo   := If(len(aparamixb) >= 8,aparamixb[ 8],"")
Local cArmazem  := If(len(aparamixb) >= 9,aparamixb[ 9],"")
Local cOP       := If(len(aparamixb) >= 10,aparamixb[10],"")
Local cNumSeq   := If(len(aparamixb) >= 11,aparamixb[11],"")
Local cLote     := If(len(aparamixb) >= 12,aparamixb[12],"")
Local cSLote    := If(len(aparamixb) >= 13,aparamixb[13],"")
Local dValid    := If(len(aparamixb) >= 14,aparamixb[14],CToD("  /  /  "))
Local cCC  		:= If(len(aparamixb) >= 15,aparamixb[15],"")
Local cLocOri   := If(len(aparamixb) >= 16,aparamixb[16],"")
Local cOPREQ    := If(len(aparamixb) >= 17,aparamixb[17],"")
Local cNumSerie := If(len(aparamixb) >= 18,aparamixb[18],"")
Local cOrigem   := If(len(aparamixb) >= 19,If(vALtYPE(aparamixb[19])!="C","",aparamixb[19] ) ,"")
Local cEndereco := If(len(aparamixb) >= 20,If(vALtYPE(aparamixb[20])!="C","",aparamixb[20] ),"")
Local cPedido   := If(len(aparamixb) >= 21,If(vALtYPE(aparamixb[21])!="C","",aparamixb[21] ),"")
Local nResto    := If(len(aparamixb) >= 22,If(vALtYPE(aparamixb[22])!="N",0,aparamixb[22] ),0)
Local xdPeso    := If(len(aparamixb) >= 23,If(vALtYPE(aparamixb[23])!="N",0,aparamixb[23] ),0)

Local NMAXWIDCOL 	:= 30				//Largura maxima para a descriçao do produto
Local nMaxLinProd	:= 2				//Quantidade de linhas maxima para descricao do produto
Local nLinDescProd	:= 0				//Posicionamento da linha da descricao do produto

Local cHora := SubStr(Time(),1,5)
Local cDI := ""
Local cPedSD1 := ""

nResto := if(vALtYPE(nResto) != 'N',0, nResto)
////alert( vALtYPE(paramixb[23] ))
//alert(xdPeso)

cLocOri := If(cLocOri==cArmazem,' ',cLocOri)
nQtde   := If(nQtde==0,SB1->B1_QE,nQtde)
cCodSep := If(cCodSep=="",'',cCodSep)

If nResto > 0
   nCopias++
EndIf

For nX := 1 to nCopias
	If !cCodID == Nil
		CBRetEti(cCodID)
		nqtde 	:= CB0->CB0_QTDE
		cCodSep  := CB0->CB0_USUARIO
		cNFEnt   := CB0->CB0_NFENT
		cSeriee  := CB0->CB0_SERIEE
		cFornec  := CB0->CB0_FORNEC
		cLojafo  := CB0->CB0_LOJAFO
		cArmazem := CB0->CB0_LOCAL
		cOP      := CB0->CB0_OP
		cNumSeq  := CB0->CB0_NUMSEQ
		cLote    := CB0->CB0_LOTE
		cSLote   := CB0->CB0_SLOTE
		cCC      := CB0->CB0_CC
		cLocOri  := CB0->CB0_LOCORI
		cOPReq	 := CB0->CB0_OPREQ
		cNumserie:= CB0->CB0_NUMSER		
		cOrigem  := CB0->CB0_ORIGEM
		cEndereco:= CB0->CB0_LOCALI
		cPedido  := CB0->CB0_PEDCOM
	EndIf
   If nResto > 0 .and. nX==nCopias
      nQtde  := nResto
   EndIf  
    If FunName() == "AAESTA01"
        If nX==1
			If Usacb0("01")//Chamada para gravação da etiqueta após a transferencia realizada para Puxada
				cCodigo := If(cCodID == Nil,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem}),cCodID)
			Else
				cCodigo := SB1->B1_CODBAR
			EndIf   
		EndIf 
	Else
		If Usacb0("01")
			cCodigo := If(cCodID == Nil,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem}),cCodID)
		Else
			cCodigo := SB1->B1_CODBAR
		EndIf 		
	EndIf
	cCodigo := Alltrim(cCodigo)
	cTipoBar := 'MB07' //128
	If ! Usacb0("01")
		If Len(cCodigo) == 8
			cTipoBar := 'MB03'
		ElseIf Len(cCodigo) == 13
			cTipoBar := 'MB04'
		EndIf
	EndIf
	
	If cNFEnt != Nil 
		SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If SD1->(dbSeek(xFilial("SD1") + cNFEnt + cSeriee + cFornec + cLojafo + SB1->B1_COD))
			cDI := SD1->D1_XDI
			cPedSD1 := SD1->D1_PEDIDO
		EndIf
	Else
		cNFEnt := cSeriee := cFornec := cLojafo := ""	
	EndIf

	
	If Type('cProgImp')=="C" .and. cProgImp=="ACDV120"
	    GravaCBE(CB0->CB0_CODETI,SB1->B1_COD,nQtde,cLote,dValid)
	EndIf
		    
Next

Return .t.

