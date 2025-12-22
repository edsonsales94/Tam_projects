/*
Padrao DATAMAX
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img01     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³produto. Padrao Microsiga                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img01 //dispositivo de identificacao de produto
Local cCodigo, sConteudo,cTipoBar, nX
Local nqtde 	:= If(len(paramixb) >= 1,paramixb[ 1],0)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],"")
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],Nil)
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],1)
Local cNFEnt  	:= If(len(paramixb) >= 5,paramixb[ 5],"")
Local cSeriee   := If(len(paramixb) >= 6,paramixb[ 6],"")
Local cFornec   := If(len(paramixb) >= 7,paramixb[ 7],"")
Local cLojafo   := If(len(paramixb) >= 8,paramixb[ 8],"")
Local cArmazem  := If(len(paramixb) >= 9,paramixb[ 9],"")
Local cOP       := If(len(paramixb) >= 10,paramixb[10],"")
Local cNumSeq   := If(len(paramixb) >= 11,paramixb[11],"")
Local cLote     := If(len(paramixb) >= 12,paramixb[12],"")
Local cSLote    := If(len(paramixb) >= 13,paramixb[13],"")
Local dValid    := If(len(paramixb) >= 14,paramixb[14],CToD("  /  /  "))
Local cCC  		:= If(len(paramixb) >= 15,paramixb[15],"")
Local cLocOri   := If(len(paramixb) >= 16,paramixb[16],"")
Local cOPREQ    := If(len(paramixb) >= 17,paramixb[17],"")
Local cNumSerie := If(len(paramixb) >= 18,paramixb[18],"")
Local cOrigem   := If(len(paramixb) >= 19,If(vALtYPE(paramixb[19])!="C","",ParamIXB[19] ) ,"")
Local cEndereco := If(len(paramixb) >= 20,If(vALtYPE(paramixb[20])!="C","",ParamIXB[20] ),"")
Local cPedido   := If(len(paramixb) >= 21,If(vALtYPE(paramixb[21])!="C","",ParamIXB[21] ),"")
Local nResto    := If(len(paramixb) >= 22,If(vALtYPE(paramixb[22])!="N",0,ParamIXB[22] ),0)
Local xdPeso    := If(len(paramixb) >= 23,If(vALtYPE(paramixb[23])!="N",0,ParamIXB[23] ),0)

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

	//Inicio do Bloco da geração da etiqueta em Spool .
	
	MsCbBegin( 1, 4)
		
	MSCBSay(45,1,cCodigo,"N","3","01","01")
	MSCBSayBar(25,4,cCodigo,"N","MB07",12,.F.,.F.,.F.,,3,3,.F.,.F.,"1",.T.)
		
	MSCBSay(5,17,"QTDE: " + CValToChar(nqtde) + " " + AllTrim(SB1->B1_UM) +;
			If( xdPeso > 0,"       Peso: " + Transform(xdPeso,"@E 999,999.999"),"") ,"N","4","01","01")

	//MSCBSay(5,17,"QTDE 2UM: " + CValToChar(ConvUM (cCodigo, nqtde, 0,2 ) + " " + AllTrim(SB1->B1_SEGUM) +;
	//MSCBSay(5,17,"QTDE 2UM: " + CValToChar(ConvUM (cCodigo, nqtde, 0,2 )) + " " + AllTrim(SB1->B1_SEGUM) ) 
	
	If !(AllTrim(FWCodEmp()) + AllTrim(FwCodFil()) $ "0101,0100")
		MSCBSay(70,25,"QTDE 2UM: " + CValToChar(Round (ConvUM (SB1->B1_COD, nqtde, 0,2 ),2)) + " " + AllTrim(SB1->B1_SEGUM), "N","3","01","01")
	EndIf 	
	
	//Pesquisa fornecedor
	If Empty(Alltrim(cFornec))
		cFor:=""
	Else
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2") + PadR(cFornec,TamSX3("A2_COD")[1]) + PadR(cLojafo,TamSx3("A2_LOJA")[1])))
			cFor := Alltrim(SA2->A2_NOME)
		Else	
			cFor := ""
		End
	EndIf
	
	If FunName() == "AAPCPP02"
		cFor := ""
	EndIf
	
	MSCBSay(40,25,"LC: " + Alltrim(cArmazem),"N","3","01","01")
	MSCBSay(5 ,25,"FOR. : " + SubStr(cFor,1,NMAXWIDCOL),"N","3","01","01")
	
	cOc := IIf(Empty(cPedSD1),Alltrim(cOp),Alltrim(cPedSD1))
	MSCBSay(40,29,"OC: " + Alltrim(cOc),"N","3","01","01")
	MSCBSay(5,29,"NFE: " + Alltrim(cNFEnt),"N","3","01","01")		
	
	MSCBSay(40,33,"DI: " + Alltrim(cDI),"N","3","01","01")
	MSCBSay(5,33,"PROC: ","N","3","01","01")
		
	MSCBSay(5 ,37,"LOTE: " + Alltrim(cLote),"N","3","01","01")
	If cOp != Nil
		MSCBSay(45,37,"MAQ.: " + Alltrim(Posicione("SC2",1,xFilial("SC2")+cOp,"C2_RECURSO")),"N","3","01","01")
	EndIf
	//Trata a quebra de linhas na descriçao do produto
	nLinDescProd := 47
	For nY := 1 To nMaxLinProd
	     If ! Empty(MLCount(SB1->B1_ESPECIF,NMAXWIDCOL))
	          If ! Empty(MemoLine(SB1->B1_ESPECIF,NMAXWIDCOL,nY))
	               MSCBSay(5,nLinDescProd,MemoLine(SB1->B1_ESPECIF,NMAXWIDCOL,nY),"N","4","01","01")
	               nLinDescProd := nLinDescProd - 5
	          EndIf
	     EndIf
	Next nY		
	
	MSCBSay(5,52,"ITEM: " + Alltrim(SB1->B1_COD),"N","3","01","01")
	
	If !(AllTrim(FWCodEmp()) + AllTrim(FwCodFil()) $ "0101,0100")
	
		MSCBSay(70,33,"2°UM: " + Alltrim(SB1->B1_SEGUM),"N","3","01","01")
	eNDiF 	

	MSCBSay(65,53,cHora,"N","2","01","01")
	MSCBSay(60,56,DToC(dDataBase),"N","2","01","01")
		
	MSCBInfoEti("Produto","30X100")
	
	sConteudo:=MSCBEND()  
    
	If Type('cProgImp')=="C" .and. cProgImp=="ACDV120"
	    GravaCBE(CB0->CB0_CODETI,SB1->B1_COD,nQtde,cLote,dValid)
	EndIf
		    
Next

//Return sConteudo

Return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img01cx   ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³produto para caixa a agranel                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img01CX //dispositivo de identificacao de produto
Local cCodigo, sConteudo,cTipoBar, nX
Local nqtde 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],NIL)
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],NIL)
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],NIL)
Local cArmazem := If(len(paramixb) >= 5,paramixb[ 5],NIL)
Local cEndereco:= If(len(paramixb) >= 6,paramixb[ 6],NIL)

nQtde   := If(nQtde==NIL,SB1->B1_QE,nQtde)
cCodSep := If(cCodSep==NIL,'',cCodSep)

For nX := 1 to nCopias
	If Usacb0("01")
		cCodigo := If(cCodID ==NIL,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,NIL,NIL,NIL,NIL,NIL,cEndereco,cArmazem,,,,,,,,}),cCodID)
	Else
		cCodigo := SB1->B1_CODBAR
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
	
	MSCBLOADGRF("SIGA.BMP")
	MSCBBEGIN(1,6)
	MSCBBOX(02,01,76,34,1)
	MSCBLineH(30,30,76,1)
	MSCBLineH(02,23,76,1)
	MSCBLineH(02,15,76,1)
	MSCBLineV(30,23,34,1)
	MSCBGRAFIC(2,26,"SIGA",.T.)
	MSCBSAY(33,31,'CAIXA',"N","2","01,01")
	MSCBSAY(33,27,"CODIGO","N","2","01,01")
	MSCBSAY(33,24, AllTrim(SB1->B1_COD), "N", "2", "01,01")
	MSCBSAY(05,20,"DESCRICAO","N","2","01,01")
	MSCBSAY(05,16,SB1->B1_DESC,"N", "2", "01,01")
	MSCBSAYBAR(22,03,cCodigo,"N",cTipoBar,8.36,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
	
	MSCBInfoEti("Produto Granel","30X100")
	sConteudo:=MSCBEND()
Next
Return sConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img01De   ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao da     º±±
±±º          ³Unidade de despacho                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img01DE //dispositivo de identificacao de unidade de despacho produto
Local nCopias 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodigo 	:= If(len(paramixb) >= 2, Alltrim(paramixb[ 2]),NIL)
MSCBLOADGRF("SIGA.BMP")
MSCBBEGIN(nCopias,6)
MSCBBOX(02,01,76,34,1)
MSCBLineH(30,30,76,1)
MSCBLineH(02,23,76,1)
MSCBLineH(02,15,76,1)
MSCBLineV(30,23,34,1)
MSCBGRAFIC(2,26,"SIGA",.T.)
MSCBSAY(33,31,'UNID. DE DESPACHO',"N","2","01,01")
MSCBSAY(33,27,"CODIGO","N","2","01,01")
MSCBSAY(33,24, AllTrim(SB1->B1_COD), "N", "2", "01,01")
MSCBSAY(05,20,"DESCRICAO","N","2","01,01")
MSCBSAY(05,16,SB1->B1_DESC,"N", "2", "01,01")
MSCBSAYBAR(22,03,cCodigo,"N","MB01",8.36,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
MSCBInfoEti("Unid.Despacho","30X100")
sConteudo:=MSCBEND()
Return sConteudo
