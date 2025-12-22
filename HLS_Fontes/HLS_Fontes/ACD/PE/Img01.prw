#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "FileIO.ch"
/*/{protheus.doc}Img01
Ponto de entrada para impressao de etiquetas
@author Honda Lock
/*/
User Function Img01 //Identificacao de produto
Local cCodigo,sConteudo,cTipoBar, nX
Local nqtde 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],NIL)
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],NIL)
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],0)
Local cNFEnt  	:= If(len(paramixb) >= 5,paramixb[ 5],NIL)
Local cSeriee  := If(len(paramixb) >= 6,paramixb[ 6],NIL)
Local cFornec  := If(len(paramixb) >= 7,paramixb[ 7],NIL)
Local cLojafo  := If(len(paramixb) >= 8,paramixb[ 8],NIL)
Local cArmazem := If(len(paramixb) >= 9,paramixb[ 9],NIL)
Local cOP      := If(len(paramixb) >=10,paramixb[10],NIL)
Local cNumSeq  := If(len(paramixb) >=11,paramixb[11],NIL)
Local cLote    := If(len(paramixb) >=12,paramixb[12],NIL)
Local cSLote   := If(len(paramixb) >=13,paramixb[13],NIL)
Local dValid   := If(len(paramixb) >=14,paramixb[14],NIL)
Local cCC  	   := If(len(paramixb) >=15,paramixb[15],NIL)
Local cLocOri  := If(len(paramixb) >=16,paramixb[16],NIL)
Local cOPREQ   := If(len(paramixb) >=17,paramixb[17],NIL)
Local cNumSerie:= If(len(paramixb) >=18,paramixb[18],NIL)
Local cOrigem  := If(len(paramixb) >=19,paramixb[19],NIL)
Local cEndereco:= If(len(paramixb) >=20,paramixb[20],NIL)
Local cPedido  := If(len(paramixb) >=21,paramixb[21],NIL)
Local nResto   := If(len(paramixb) >=22,paramixb[22],0)
Local cItNFE   := If(len(paramixb) >=23,paramixb[23],NIL)

cLocOri := If(cLocOri==cArmazem,' ',cLocOri)
nQtde   := If(nQtde==NIL,SB1->B1_QE,nQtde)
cCodSep := If(cCodSep==NIL,'',cCodSep)

If nResto > 0 
   nCopias++
EndIf

For nX := 1 to nCopias
	If cCodID#NIL
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
		cOPReq	:= CB0->CB0_OPREQ
		cNumserie:= CB0->CB0_NUMSER		
		cOrigem  := CB0->CB0_ORIGEM
		cEndereco:= CB0->CB0_LOCALI
		cPedido  := CB0->CB0_PEDCOM
		If CB0->(FieldPos("CB0_ITNFE"))>0
			cItNFE 	 := CB0->CB0_ITNFE
		EndIf
	EndIf
   If nResto > 0 .and. nX==nCopias
      nQtde  := nResto
   EndIf
	If Usacb0("01")
		cCodigo := If(cCodID ==NIL,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem,cItNFE}),cCodID)
	Else
		cCodigo := SB1->B1_COD
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
	MSCBLOADGRF("LGHONDA.BMP")
	MSCBBEGIN(1,10,70)
   
   MSCBLineH(02,02,125,4)   
	MSCBLineH(02,100,125,4)
     MSCBLineH(02,12,125,4)
      MSCBLineH(02,21,125,4)
       MSCBLineH(02,36,125,4)
		MSCBLineH(02,42,125,4)
		 MSCBLineH(02,48,125,4)
		  MSCBLineH(02,56,125,4)
		   MSCBLineH(02,74,125,4)   
			MSCBLineH(02,80,125,4)  
	MSCBLineV(125,02,100,4)
	MSCBLineV(02,02,100,4)						 
	MSCBLineV(65,56,100,4)
	MSCBLineV(30,80,100,4)
//	MSCBLineV(95,74,100,4)					
	//---------------
	MSCBSAY(05,06,'Honda Lock',"N","0","035,035")
	MSCBSAY(50,06,'PART NUMBER',"N","0","035,035")//OK
	MSCBSAY(35,16, AllTrim(SB1->B1_COD), "N", "0", "032,035")
//	MSCBSAYBAR(35,22,cCodigo,"N",cTipoBar,8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	MSCBSAYBAR(30,22,cCodigo,"N","3",8.36,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)
	MSCBSAY(50,38,"DESCRICAO","N","0","025,035")
	MSCBSAY(35,44,SB1->B1_DESCHL,"N", "0", "025,035")
	MSCBSAY(50,50,"LOTE","N","0","035,035")
    MSCBSAY(20,60,DTOC(SC2->C2_EMISSAO),"N", "0", "035,042")	
   	MSCBSAYBAR(69,58,DTOC(SC2->C2_EMISSAO),"0","3"/*/cTipoBar/*/,8.36,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)    
	MSCBSAY(22,76,"QUANTIDADE","N","0","030,020")
	MSCBSAYBAR(36,86,cValtoChar(SB1->B1_QE),"N","3"/*/cTipoBar/*/,8.36,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)    	
    MSCBSAY(10,86,cValtoChar(SB1->B1_QE),"N", "0", "040,040")	
	MSCBSAY(84,76,"SEQUENCIA","N","0","030,025")
	MSCBSAY(85,86,cValtoChar(nX),"N", "0", "040,040")
	MSCBSAY(93,86,"/","N", "0", "040,040")
	MSCBSAY(96,86,cValtoChar(nCopias),"N", "0", "040,040")
//	MSCBSAY(100,76,"RESPONSAVEL","N","0","030,020")
//   	MSCBInfoEti("Produto","100X70")
	sConteudo:=MSCBEND()
Next
Return sConteudo
