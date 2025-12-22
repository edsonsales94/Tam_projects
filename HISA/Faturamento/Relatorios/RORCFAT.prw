#INCLUDE "rwmake.ch"
/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RORCFAT    ¦ Autor ¦Orismar Silva         ¦ Data ¦ 12/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELGRU    ¦ Relatorio de Orçamento.                                       ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
User Function RORCFAT()

Local cDesc1        := "Este programa ira emitir o Orcamento de Venda, conforme"
Local cDesc2        := "os parametros solicitado"
Local cDesc3        := ""
Local titulo        := "Orçamento de Venda"
Local nLin          := 80
Local Cabec1        := "Orçamento de Venda"
Local Cabec2        := ""
Local aOrd 		     := ""

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RORCFAT"
Private nTipo       := 10
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "RORCFAT"
Private cPerg       := ""
Private cString     := "SCJ"

//CriaSx1(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Cabec1 := "                                                                                                                                                                               Preço Referencial                  Quantidade"
Cabec2 := " Produto                                       Descrição do Componente                                    Quantidade                 Preço Venda                      Unitário                    Total                Caixa"
//          9999999999999999         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                999,999,999.99          999,999,999.999999            999,999,999.999999           999,999,999.99           999,999.99
//          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)     
Return
*************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin) 
**************************************************
*

Private cPedido	   := SCJ->CJ_NUM

_nToTal  := 0
nTotVal  := 0
nTotDesc := 0
nTotVal1 := 0
titulo := ALLTRIM(titulo)+" - N. "+SCJ->CJ_NUM
dbSelectArea("SCK")
dbSetOrder(1)
dbSeek(xFilial("SCK")+SCJ->CJ_NUM)
While !Eof() .And. SCK->CK_FILIAL+SCK->CK_NUM == SCJ->CJ_FILIAL+SCJ->CJ_NUM
      *
      nQtdCaixa := 0
		If nLin > 55
		   nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		   @ nLin,000 PSAY "Cliente        :" +SCJ->CJ_CLIENTE+"/"+SCJ->CJ_LOJA+ " - " +POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME");nLin++
		   @ nLin,000 PSAY "Cidade/UF      :" +ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_MUN"))+"/"+POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_EST");nLin++
		   @ nLin,000 PSAY "Ped. Cliente   :" +ALLTRIM(StrTran(StrTran(StrTran(SCJ->CJ_COTCLI,"/",""),"-",""),".",""));nLin++
         @ nLin,000 PSAY "Cond. Pag      :" +SCJ->CJ_CONDPAG+" - " +POSICIONE("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI");nLin++
         @ nLin,000 PSAY "Vendedor       :" +ALLTRIM(SCJ->CJ_XVEND)+" - " +POSICIONE("SA3",1,xFilial("SA3")+SCJ->CJ_XVEND,"A3_NOME");nLin++   
         @ nLin,000 PSAY "Tabela         :" +SCJ->CJ_TABELA;nLin++   
         cTransp := POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TRANSP")
         @ nLin,000 PSAY "Transportadora :" +ALLTRIM(POSICIONE("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"));nLin++  
         if !EMPTY(ALLTRIM(SCJ->CJ_XOBS))
		      @ nLin,000 PSAY "Observação     :"	+ALLTRIM(SCJ->CJ_XOBS);nLin++
		      if !EMPTY(ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_XOBS")))
		         @ nLin,000 PSAY "                "	+ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_XOBS"));nLin++  
		      endif
		   elseif !EMPTY(ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_XOBS")))
		      @ nLin,000 PSAY "Observação     :"	+ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_XOBS"));nLin++  
		   endif
		   if SCJ->CJ_DESC1 > 0
            @ nLin,000 PSAY "Desconto       : Desconto Comercial "+Transform(SCJ->CJ_DESC1,"@E 999.99")+"%" ;nLin++  
         endif
         @nLin,000 PSAY Replicate("-",Limite)
         nLin++
		Endif
		*
      @ nLin,000 PSAY SCK->CK_PRODUTO
      @ nLin,025 PSAY SCK->CK_DESCRI
	   @ nLin,101 PSAY Transform(SCK->CK_QTDVEN ,"@E 999,999,999.99")
      @ nLin,125 PSAY Transform(SCK->CK_PRCVEN ,"@E 999,999,999.999999")
	   //@ nLin,084 PSAY Transform(SCK->CK_VALOR  ,"@E 999,999,999.99")
	   @ nLin,155 PSAY Transform(POSICIONE("DA1",1,xFilial("DA1")+SCJ->CJ_TABELA+SCK->CK_PRODUTO,"DA1_XPRCFI"),"@E 999,999,999.999999")	   
	   @ nLin,184 PSAY Transform(SCK->CK_XPRCFIN,"@E 999,999,999.99")
	   nQtdCaixa := POSICIONE("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_XCAIXA") 
  	   @ nLin,209 PSAY Transform(ROUND(SCK->CK_QTDVEN/nQtdCaixa,2),"@E 999,999.99")	   	   
	   nLin++
	   *
	   _nToTal += SCK->CK_XPRCFIN
	   *
		If (SCK->CK_PRUNIT > SCK->CK_PRCVEN)
			nTotVal  += A410Arred((SCK->CK_PRUNIT * SCK->CK_QTDVEN),"CK_VALOR")
		Else           
		   nTotVal  += A410Arred((SCK->CK_PRCVEN * SCK->CK_QTDVEN),"CK_VALOR")
		EndIf
      *
		SCK->(dbSkip())     		
EndDo  
nTotVal += SCJ->CJ_FRETE
nTotVal += SCJ->CJ_SEGURO
nTotVal += SCJ->CJ_DESPESA
nTotVal += SCJ->CJ_FRETAUT
nTotDesc += ROUND((nTotVal*SCJ->CJ_PDESCAB/100),2)  
if SCJ->CJ_DESC1 > 0
   nTotVal1 += nTotVal-nTotDesc
   nTotDesc += Round((nTotVal1*SCJ->CJ_DESC1/100),2)
endif
nLin++
@nLin,000 PSAY Replicate("-",Limite)
nLin++
@ nLin,000 PSAY "Total do Orçamento ---->"
@ nLin,040 PSAY Transform(nTotVal ,"@E 999,999,999.99")
@ nLin,079 PSAY "Desconto: "
@ nLin,120 PSAY Transform(nTotDesc  ,"@E 999,999,999.99")
@ nLin,164 PSAY "="
@ nLin,200 PSAY Transform(nTotVal-nTotDesc  ,"@E 999,999,999.99")
nLin++
@nLin,000 PSAY Replicate("-",Limite)
nLin++
*
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)                  	
Endif

MS_FLUSH()

Return 
