#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#Include "Protheus.ch"
#include "rwmake.ch"

*****************************************
USER FUNCTION AARECIBO(cOrcamento,nTipo)
*****************************************
Default cOrcamento := ""
Default nTipo      := 2

PRIVATE oDlg
PRIVATE TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTOTUS,ARETURN
PRIVATE NLASTKEY,M_PAG,WNREL,CTES,LI,NVLRUS
PRIVATE DULTDAT,NTOTGER,NTOTGERUS,NRECNO,CNODI,CCOR,NNIVEL
PRIVATE NREGSG1,VIMPEST,VESTRU,X,CCODPRD,NTOTAL,CCOMP
PRIVATE NREGSB1,CDESCRI,LSOMA,NVLRREA,CCODCOM,VDAD
PRIVATE NVALUE, CEMAIL
PRIVATE cPerg := PADR("O_RECI    ",Len(SX1->X1_GRUPO))

CEMAIL := SuperGETMV("MV_XEMAILV",.F.,"noemail@amazonaco.com.br")
//CEMAIL := "noemail@amazonaco.com.br"
//alert(CEMAIL)
ValidPerg(cPerg)
If Empty(cOrcamento)
	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Impressao de Recibo")
	@ 02,10 TO 080,190
	@ 10,018 Say " Esse programa tem finalidade imprimir um recibo       "
	@ 18,018 Say "                                                       "
	
	@ 60,088 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 60,118 BMPBUTTON TYPE 01 ACTION OkEstru(.T.)
	@ 60,148 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg Centered
else
    Pergunte(cPerg,.F.)
    mv_par01 := cOrcamento
    mv_par02 := nTipo
    OkEstru(.F.)
Endif

Return

Static Function OkEstru(lTipo)

if lTipo
    Pergunte(cPerg,.F.)
	Close(oDlg)
endif

AVPRINT oPrn NAME "IMPRESSAO DE RECIBO"

DEFINE FONT oFont1  NAME "Arial"		   SIZE 0,10 Bold OF oPrn
DEFINE FONT oFont2  NAME "Courier New"     SIZE 0,11 Bold OF oPrn//"Times New Roman"
DEFINE FONT oFont3  NAME "Arial"           SIZE 0,14 Bold OF oPrn
DEFINE FONT oFont3n NAME "Arial"          SIZE 0,14 OF oPrn
DEFINE FONT oFont4  NAME "Arial"           SIZE 0,20 Bold OF oPrn
DEFINE FONT oFont5  NAME "Arial"           SIZE 0,22 Bold OF oPrn
DEFINE FONT oFontT  NAME "Arial"           SIZE 0,16 Bold OF oPrn
DEFINE FONT oFont6  NAME "Trebuchet MS"    SIZE 0,13 Bold OF oPrn
DEFINE FONT oFontX  NAME "Courier New"     SIZE 0,12 Bold Italic Underline OF oPrn//"Times New Roman"

oPrn:SETPORTRAIT()

AVPAGE
Processa({|X| lEnd := X, RPrint() })
AVENDPAGE

AVENDPRINT
oPrn:SETPORTRAIT()
oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()
oFontT:End()
oFont6:End()
Return .T.

*****************************************
Static Function RPrint()
*****************************************


Private xCor, cReserv
Private nLarg:=300,nAlt:=200
Private nPage:=1,nLine,nLinVert := 150,nColIni:=160,nColFim:=2300

NVALUE := 0

nCol1:=nColIni       //Produto
nCol2:=nCol1+1100    //Desconto
nCol3:=nCol2+230     //Preço unitário
nCol4:=nCol3+250     //Quantidade
nCol5:=nCol4+180     //Total
nLinFim:=3000

If(Mv_Par02 == 1)
	
	//IDA FRACOTE PARA PEGAR O VALOR ORÇAMENTO
	DbSelectArea("SC5")
	DbSetOrder(1)
	//dbGoTop()
	IF SC5->(DbSeek(xFilial("SC5")+MV_PAR01)) .And. !EMPTY(SC5->C5_NOTA)
		
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
		
		While !SC6->(EOF()) .and. SC6->C6_NUM = SC5->C5_NUM
			
			NVALUE +=SC6->C6_VALOR
			SC6->(dbSkip())
			
		End
		
	Endif
	
	
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	dbGoTop()
	IF SC5->(DbSeek(xFilial("SC5")+MV_PAR01)) .And. !EMPTY(SC5->C5_NOTA)
		
		SB1->(dbSetOrder(1))
		SA1->(dbSetOrder(1))
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		
		F_Cabec()
		
		oPrn:Say(nLine ,0510,"                           RECIBO",oFont4,,,,3)
		
		oPrn:Say(nLine += 200 ,0510,"                                               R$ "+ALLTRIM(Transform(NVALUE,"@E 999,999,999.99")),oFont4,,,,3)
		oPrn:Say(nLine += 150 ,nColIni,"Recebi de: "+ALLTRIM(SA1->A1_NOME) ,oFont3n,,,,3)
		oPrn:Say(nLine += 80 ,nColIni,"O Valor de: ("+Extenso(NVALUE)+")",oFont3n,,,,3)
		oPrn:Say(nLine += 80 ,nColIni,"Referente ao pagamento conforme Nota Fiscal nr. "+SC5->C5_NOTA+" - "+SC5->C5_SERIE ,oFont3n,,,,3)
		oPrn:Say(nLine += 80 ,nColIni,"Orcamento "+SC5->C5_XORCRES + " - Vendedor : " + SC5->C5_VEND1 + "-" + Posicione('SA3',1,xFilial('SA3') + SC5->C5_VEND1,'A3_NOME' )  ,oFont3n,,,,3)
		
		oPrn:Say(nLine += 150 ,nColIni,"Descricao",oFont3,,,,3)
		oPrn:Say(nLine       ,nCol1+1250 ,"Qtd.",oFont3,,,,3)
		oPrn:Say(nLine       ,nCol2+300  ,"Preco Unt.",oFont3,,,,3)
		oPrn:Say(nLine       ,nCol4+200  ,"Preco Ttl.",oFont3,,,,3)
		
		
		F_Itens()
		F_Rod()
		
	Endif
	
Elseif mv_par02 == 2
	
	DbSelectArea("SL1")
	DbSetOrder(1)
	//dbGoTop()
	IF SL1->(DbSeek(SL1->(xFilial("SL1")) + Padr(MV_PAR01,Len(SL1->L1_NUM)))) .And. ( !EMPTY(SL1->L1_DOC) .OR. SL1->L1_ENTREGA == "S")
		
		SB1->(dbSetOrder(1))
		SA1->(dbSetOrder(1))
		SL2->(dbSetOrder(1))
		SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
		SA1->(dbSeek(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
		
		F_Cabec()
		
		oPrn:Say(nLine ,0510,"                           RECIBO",oFont4,,,,3)
		
		oPrn:Say(nLine += 200 ,0510,"                                               R$ "+ALLTRIM(Transform(SL1->L1_VLRTOT,"@E 999,999,999.99")),oFont4,,,,3)
		oPrn:Say(nLine += 150 ,nColIni,"Recebi de: "+ALLTRIM(SA1->A1_NOME),oFont3n,,,,3)
		oPrn:Say(nLine += 80 ,nColIni,"O Valor de: ("+Extenso(SL1->L1_VLRTOT)+")",oFont3n,,,,3)
		oPrn:Say(nLine += 80 ,nColIni,"Referente ao pagamento conforme Cupom Fiscal nr. "+iIf(Empty(SL1->L1_DOC),SL1->L1_DOCPED,SL1->L1_DOC)+" - "+If(Empty(SL1->L1_DOCPED),SL1->L1_SERIE,SL1->L1_SERPED) ,oFont3n,,,,3)
		xdForm := StaticCall(AAFATC02,AAFATC22,SL1->L1_FILIAL,SL1->L1_NUM,SL1->L1_CONDPG)
		oPrn:Say(nLine += 80 ,nColIni,"Forma de pagamento " + xdForm ,oFont3n,,,,3)
		oPrn:Say(nLine += 80 ,nColIni,"Orcamento "+SL1->L1_NUM + " - Vendedor : " + SL1->L1_VEND + "-" + Posicione('SA3',1,xFilial('SA3') + SL1->L1_VEND,'A3_NOME' )  ,oFont3n,,,,3)
		
		
		oPrn:Say(nLine += 150 ,nColIni,"Descricao",oFont3,,,,3)
		oPrn:Say(nLine       ,nCol1+1250 ,"Qtd.",oFont3,,,,3)
		oPrn:Say(nLine       ,nCol2+300  ,"Preco Unt.",oFont3,,,,3)
		oPrn:Say(nLine       ,nCol4+200  ,"Preco Ttl.",oFont3,,,,3)
		
		F_Itens()
		F_Rod()
		
	Endif
	
Endif

Return

Static Function F_Cabec()

nLine := 150     

oPrn:SayBitmap(nLine+20,nColIni,"lgMID1.bmp",nLarg,nAlt)

_cdCGC  := If(SM0->M0_CODIGO == '01' .And. SM0->M0_CODFIL == '03' , '05477207000175' , SM0->M0_CGC )
_cdInsc := If(SM0->M0_CODIGO == '01' .And. SM0->M0_CODFIL == '03' , '063000016' , SM0->M0_INSC )

oPrn:Say(nLine  ,0510,PADC(SM0->M0_NOMECOM,75),oFont4,,,,3)
oPrn:Say(nLine += 100 ,0510,ALLTRIM(SM0->M0_ENDENT) + ", - CEP "+Transform(SM0->M0_CEPENT,"@R 99.999-999")+" - "+Alltrim(SM0->M0_CIDENT)+"-"+SM0->M0_ESTENT ,oFont1,,,,3)
oPrn:Say(nLine += 50  ,0510,"CNPJ.: "+Transform(_cdCGC,"@R 99.999.999/9999-99")+" - IE.: "+_cdInsc + " /"+CEMAIL ,oFont1,,,,3)
oPrn:Say(nLine += 50  ,0510,"Fone: "+Transform(SM0->M0_TEL,"@R (99) 9999-9999")+" Fax: "+Transform(SM0->M0_FAX,"@R (99) 9999-9999") ,oFont1,,,,3)

oPrn:Say(nLine += 50  ,0510,"Manaus                                                                                                        Amazonas",oFont1,,,,3)
oPrn:Say(nLine += 10  ,0510,"_____________________________________________________________________",oFont1,,,,3)
nLine +=200
Return

Static Function F_Itens
nLine += 160


IF(MV_PAR02 == 1)
	While !SC6->(EOF()) .and. SC5->C5_NUM = SC5->C5_NUM
		
		SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		oPrn:Say(nLine, nColIni   ,PadR(Left(SB1->B1_DESC,40),40)                        ,oFont6,,,,3)
		oPrn:Say(nLine,nCol1+1200         ,PadL(Transform(SC6->C6_QTDVEN ,"@E 999,999.99"),10)       ,oFont6,,,,3)
		oPrn:Say(nLine,nCol2+300    ,PadL(Transform(SC6->C6_PRCVEN,"@E 999,999.99"),12)    ,oFont6,,,,3)
		oPrn:Say(nLine,nCol4+200    ,PadL(Transform((SC6->C6_QTDVEN*SC6->C6_PRCVEN)   ,"@E 99,999,999.99"),15),oFont6,,,,3)
		nLine+=60
		SC6->(dbSkip())
		if nLine > 2200 .And. !SC6->(EOF()) .And. SC6->C6_NUM = SC5->C5_NUM
			oPrn:Say(3000,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
			//F_Rod()
			nPage += 1
			AVNEWPAGE
			F_Cabec()
		Endif
		
	End
	
	oPrn:Say(nLine+=60,nCol2+350    , "Total" ,oFont3,,,,3)
	oPrn:Say(nLine,nCol4+200    , ALLTRIM(Transform(NVALUE,"@E 999,999,999.99"))  ,oFont3,,,,3)
	
	
ELSE
	
	While !SL2->(EOF()) .and. SL2->L2_NUM = SL1->L1_NUM
		
		SB1->(dbSeek(xFilial("SB1")+SL2->L2_PRODUTO))
		oPrn:Say(nLine, nColIni   ,PadR(Left(SB1->B1_DESC,40),40)                        ,oFont6,,,,3)
		oPrn:Say(nLine,nCol1+1200         ,PadL(Transform(SL2->L2_QUANT ,"@E 999,999.99"),10)       ,oFont6,,,,3)
		oPrn:Say(nLine,nCol2+300    ,PadL(Transform(SL2->L2_VRUNIT,"@E 999,999.99"),12)    ,oFont6,,,,3)
		oPrn:Say(nLine,nCol4+200    ,PadL(Transform((SL2->L2_QUANT*SL2->L2_VRUNIT)   ,"@E 99,999,999.99"),15),oFont6,,,,3)
		nLine+=60
		SL2->(dbSkip())
		if nLine > 2200 .And. !SL2->(EOF()) .And. SL2->L2_NUM = SL1->L1_NUM
			oPrn:Say(3000,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
			//F_Rod()
			nPage += 1
			AVNEWPAGE
			F_Cabec()
		Endif
		
	End
	
	oPrn:Say(nLine+=60,nCol2+350    , "Total" ,oFont3,,,,3)
	oPrn:Say(nLine,nCol4+200    , ALLTRIM(Transform(SL1->L1_VLRTOT,"@E 999,999,999.99"))  ,oFont3,,,,3)
	
ENDIF

Return


Static Function F_Rod

oPrn:Say(2500 ,nColIni,"                                                 Manaus, "+ALLTRIM(STR(DAY(DDATABASE)))+" de "+ALLTRIM(MESEXTENSO(MONTH(DDATABASE))) +" de "+ALLTRIM(STR(YEAR(DDATABASE))) ,oFont3,,,,3)
oPrn:Say(2820 ,nColIni,"                                          ________________________________________",oFont3,,,,3)
oPrn:Say(2900 ,nColIni,"                                         " + SM0->M0_NOMECOM,oFont3,,,,3)
oPrn:Say(3000,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)

Return

Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Orcamento           ?" ,29),PADR("Orcamento           ?" ,29),PADR("Orcamento           ?"   ,29),"mv_ch1","C",06,0,0,"G","","" ,""   ,"","","mv_par01")
PutSX1(cPerg,"02",PADR("Origem              ?" ,29),PADR("Origem              ?" ,29),PADR("Origem              ?"   ,29),"mv_ch2","N",01,0,0,"C","" ,""   ,"","","mv_par02","Faturamento","","","","Loja","","","","","","","","","","","","","","","")

Return
