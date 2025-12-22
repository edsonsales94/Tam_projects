#Include "rwmake.ch"
#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"

/*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  Orcamento ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 02/09/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressao de Orçamento de Vendas                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/                              

/*
Parametros:
lsenha: (DIEGO) Nao sei a utilidade do pametro, aparentemente nenhuma
ldAuto: Caso este esteja como true imprime direto na posta LPT2: a porta referente ao Caixa, caso contrario escolhe a impressora
*/
User Function Orcamen(lSenha,ldAuto, lReserva)

SetPrvt("ARETURN,NPAG,LI,TOTPAGINA,DESCPAGINA,TOTGERAL,LIMITE,NTIPO")
SetPrvt("DESCITEM,DESCTOTAL,FORMA,NLASTKEY,DESCTOTAL1")

DEfault ldAuto := .F.
DEfault lReserva := .F.

Private cPerg := Padr("ORCAMEN",Len(SX1->X1_GRUPO))
Private nwTam := 132

CriaSx1(cPerg)
Pergunte(cPerg,!ldAuto)

nLastKe2   	:= 0
lSenha  	:= If( lSenha == Nil , .T., lSenha)
lImprime    := .F.
lRet := .T.

If !ldAuto
   SL1->(dbSeek(SL1->(xFilial("SL1")) + mv_par01))
EndIf

If lRet
	
	titulo   := PADC("IMPRESSAO DE ORCAMENTO",120)
	cDesc1   := PADC("Este programa ir  emitir um orcamento",120)
	cDesc2   := ""
	cDesc3   := ""
	cNatureza := ""
	cResp     := "N"
	cString  := "SL1"
	aReturn   := { "Especial", 1,"Administracao", 1, 3, 8, "",1 }
	nomeprog  := "ORCAME1"
	wnrel    := "ORCAMENT"
	Li       := 01
	nLastKey := 0
	limite   := 132
	aDriver := ReadDriver()
	
	p_negrit_l := "E"
	p_reset    := "@"
	p_negrit_d := "F"
	/* Solicitacao francisco dia 10/11
	if ldAuto
	   //wnrel := SetPrint(cString,wnrel,""   ,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"M",,,,"EPSON.DRV",.T.,.F.,"LTP2")
//	   wnrel := SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"P",,,,"EPSON.DRV",.T.,.F.,"LPT2")
//	   wnrel:= SetPrint("SL1",NomeProg,,@Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"M",,,,"EPSON.DRV",.T.,.F.,"LPT1")
      wnrel := SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"P",,,,"EPSON.DRV",.T.,.F.,"LPT2")
	else
	   wnrel := SetPrint(cString,wnrel,"",Titulo ,cDesc1,cDesc2,cDesc3,.T.,,   ,"M") 
	EndIf*/
	wnrel := SetPrint(cString,wnrel,"",Titulo ,cDesc1,cDesc2,cDesc3,.T.,,   ,"M")
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	/*aDriver := ReadDriver() //Instru;áo caveira do mestre Ronilton
	
	@ 00,000 PSAY &(aDriver[aReturn[4]+2]) // Complemento da instru;áo*/
	For nX:=1 To 2
		RunReport(lReserva)
	Next nX
	//RptStatus({|| RunReport() }, Titulo) - Estranho problema de paisagem ao se usar o rptstatus ?
	
EndIf

//If lImprime

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

//	Lj010EndPrint("O")
//Endif

Return       


//Relatorio 
Static Function RunReport(lReserva)


Private _nTImcsSol := 0
Li       := 01
nPag       := 1
Cabec1() //Imprime o cabecalho do Orcamento
Cabec2(lReserva) //Cabecalho de Venda
TotPagina  := 0

DescPagina := 0
TotGeral   := 0
DescTotal  := 0
DescTotal1 := 0
TotPeso    := 0

DbSelectArea("SG1")
DbSetOrder(1)

DbSelectArea("SL1")

DbSelectArea("SL2")
SL2->(DbSetOrder(1))
SL2->(DbGotop())
If SL2->(DbSeek(Xfilial()+SL1->L1_Num))

	   _nTImcsSol := 0
	Do While SL1->L1_NUM == SL2->L2_NUM .And. SL2->(!Eof())
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial('SF4')+SL2->L2_TES))

		//DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+SL2->L2_PRODUTO))
		
				nPrcUnit  := SL2->L2_VLRITEM / SL2->L2_QUANT
				nTotal    := SL2->L2_VLRITEM
				_ndQtSeg  := SL2->L2_QTSEGUM//convUm(SB1->B1_COD, SL2->L2_QUANT,0,2)
				//_ndTotIcms+= iIF(SF4->F4_INCSOL == 'S',SL2->L2_ICMSRET,0)
				_cdDescr := SB1->B1_ESPECIF
				
				@ li,02  PSay SubStr(SB1->B1_COD,1,10)
				@ li,13  Psay SubStr(_cdDescr,1,50)
				
				@ li,74 - 11  Psay SL2->L2_UM
				@ li,79 - 13  PSay Transform( SL2->L2_QUANT,"@E   999,999.99")
				
				@ li,091 - 11 Psay SB1->B1_SEGUM
				@ li,096 - 13 PSay Alltrim( Transform(_ndQtSeg ,"@E   999,999.99")  )
				
				@ li,95 PSay Alltrim(Transform(nPrcUnit      ,PesqPict("SL2","L2_VRUNIT",18,2) )  )
				
				@ li,108  PSay Alltrim(Transform(nTotal        ,PesqPict("SL2","L2_VLRITEM",18,2) ) )
				
				//@ li,120 PSay (cTable)->(L1_PEDRES + '/' + L1_FILIAL)
				
				li := li + 1
				_cdDescr := SubStr(_cdDescr,51,50)
				While !EMpty(_cdDescr)
					@ li,13  Psay SubStr(_cdDescr,1,50)
					li := li + 1
					_cdDescr := SubStr(_cdDescr,51,50)
				EndDo
		    /*
		    If FwCodEmp() != "05" 
			    _ldTpUm  := !Empty(SB1->B1_SEGUM)
			   
				_cdUm    := IiF(!Empty(SB1->B1_SEGUM),SB1->B1_SEGUM,SB1->B1_UM)
				_ndQuant := Round( IiF(!Empty(SB1->B1_SEGUM),ConvUm(SB1->B1_COD,SL2->L2_QUANT,0,2),SL2->L2_QUANT ) ,5)
				_ndPrcTab:= IiF(!Empty(SB1->B1_SEGUM),(SL2->L2_PRCTAB * SL2->L2_QUANT) / _ndQuant , SL2->L2_PRCTAB)
				_ndPrUnit:= IiF(!Empty(SB1->B1_SEGUM),(SL2->L2_VRUNIT * SL2->L2_QUANT) / _ndQuant , SL2->L2_VRUNIT)
				
				@ li,01  PSay SubStr(SB1->B1_COD,1,9)
				@ li,11  Psay Transform(_ndQuant,"@E 99,999.99999")
				@ li,24  PSay _cdUm
				//@ li,30  PSay SB1->B1_SEGUM
				@ li,30  PSay Left(SB1->B1_ESPECIF,40)
				@ li,76  Psay Left(SB1->B1_NOMFAB,12)
				// @ li,90  PSay Transform(SB1->B1_PESO,"@E 9,999.9")
				@ li,93  PSay Transform(_ndPrcTab, "@E 999,999.99")
				@ li,107 PSay Transform(_ndPrcTab * _ndQuant,"@E 9,999,999.99")
				
				li := li + 1
			Else
			     _ldTpUm  := .F.//!Empty(SB1->B1_SEGUM)
			   
				_cdUm    := SL2->L2_UM//IiF(!Empty(SB1->B1_SEGUM),SB1->B1_SEGUM,SB1->B1_UM)
				_ndQuant := SL2->L2_QUANT//Round( IiF(!Empty(SB1->B1_SEGUM),ConvUm(SB1->B1_COD,SL2->L2_QUANT,0,2),SL2->L2_QUANT ) ,5)
				_ndPrcTab:= SL2->L2_PRCTAB//IiF(!Empty(SB1->B1_SEGUM),(SL2->L2_PRCTAB * SL2->L2_QUANT) / _ndQuant , SL2->L2_PRCTAB)
				_ndPrUnit:= SL2->L2_VRUNIT//IiF(!Empty(SB1->B1_SEGUM),(SL2->L2_VRUNIT * SL2->L2_QUANT) / _ndQuant , SL2->L2_VRUNIT)
				
				@ li,01  PSay SubStr(SB1->B1_COD,1,9)
				@ li,11  PSay iIf(SL2->L2_SEGUM=="KG",SL2->L2_QTSEGUM,SB1->B1_PESO * SL2->L2_QUANT)				
				//@ li,11  Psay Transform(_ndQuant,"@E 99,999.99999")
				@ li,24  PSay SL2->L2_UM				
				@ li,30  PSay SL2->L2_QUANT
				@ li,47  PSay Left(SB1->B1_ESPECIF,40)
				//@ li,76  Psay Left(SB1->B1_NOMFAB,12)
				// @ li,90  PSay Transform(SB1->B1_PESO,"@E 9,999.9")
				@ li,93  PSay Transform(_ndPrcTab, "@E 999,999.99")
				@ li,107 PSay Transform(_ndPrcTab * _ndQuant,"@E 9,999,999.99")				
				li := li + 1
			EndIf
			*/
		Endif
		
		TotPeso  += iIf(SL2->L2_SEGUM=="KG",SL2->L2_QTSEGUM,SB1->B1_PESO * SL2->L2_QUANT)//SB1->B1_PESO * iIf(_ldTpUm, ConvUm(SB1->B1_COD,0,_ndQuant,1) , _ndQuant )
		TotGeral += nTotal//Round((_ndPrcTab * _ndQuant),2)

		DescTotal1 += (SL2->L2_PRCTAB - SL2->L2_VRUNIT) * SL2->L2_QUANT //(_ndPrcTab-_ndPrUnit)*_ndQuant
		_nTImcsSol += iIF(SF4->F4_INCSOL == 'S',SL2->L2_ICMSRET,0)
		
		SL2->(DbSkip())
		
	EndDo
	
    DescTotal := iif(SL1->L1_DESCONT != 0.0, SL1->L1_DESCONT, 	DescTotal1) //	DescTotal := SL1->L1_DESCONT
	
	Geral()
	RodapeForm()
EndIf

Return
***************************************************************************************
Static Function Cabec1()

li:=01

@ li,001 PSay PADC(SM0->M0_NOMECOM,120); li := li + 1
@ li,001 Psay PADC("FONE: "+SM0->M0_TEL+" FAX: "+SM0->M0_FAX,100); li := li + 1
@ li,001 PSay "DATA :" +DTOC(SL1->L1_EMISSAO)+" - "+Time(); li := li + 1
@ li,001 PSay Replicate("-",130)

Return
***************************************************************************************

Static Function Cabec2(lReserva)

li := 05
DbSelectArea("SL1")
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial()+SL1->L1_CLIENTE+SL1->L1_LOJA,.T.)


@ li,001 PSay "PRE-VENDA: "+SL1->L1_NUM

If lReserva
    @ li,080 PSay "Reserva: "+SL1->L1_DOCPED + "/" + SL1->L1_SERPED
  Else 
    @ li,080 PSay "NF/CUPOM: "+SL1->L1_DOC + "/" + SL1->L1_SERIE
EndIf 

li := li + 1
@ li,001 PSay "CLIENTE  : "+Alltrim(SA1->(A1_COD + '/' + A1_LOJA ) )  +  AllTrim(SA1->A1_NOME) + "  ( " + AllTrim(SA1->A1_NREDUZ) + " )"
@ li,080 PSay "VENDEDOR: " +Posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"SA3->A3_NREDUZ") ; li := li + 1
@ li,001 PSay "ENDERECO : "+Alltrim(Left(SA1->A1_END,50)) + ", " + AllTrim(SA1->A1_BAIRRO); li := li + 1
@ li,001 PSay "CIDADE: "+Alltrim(Left(SA1->A1_MUN,25)) + " - " + Alltrim(Left(SA1->A1_EST,2))
@ li,040 PSay "FONE : "+Transform(SA1->A1_TEL,'@R (99)9999-9999')
@ li,080 PSay "CEP.: "+Transform(SA1->A1_CEP,'@R 999999-99'); li := li + 1
@ li,001 PSay "CNPJ/CPF: "+ A1_CGC + " I.E: " + A1_INSCR

DbSelectArea("SE4")
DbSetOrder(1)
SE4->(DbSeek(XFilial()+SL1->L1_CONDPG,.T.))
DbSelectArea("SL1")

aPagtos := GetForm(SL1->L1_FILIAL,SL1->L1_NUM)
If Len(aPagtos) = 0
   @ li,060 PSay "C. PAGTO :  " + If(ALLTRIM(SL1->L1_CONDPG) == "CN","COND. NEGOCIADA"," - "+AllTrim(SE4->E4_DESCRI))
else
 For nK := 1 To Len(aPagtos)
     li++
	@ li,001 PSay iIf(nK==1,"C. Pagto :  ","            ") + aPagtos[nK]
	  li++
 Next
EndIf
cFormPag := SL1->L1_FORMPG
cDescPag := Posicione("SX5",1,XFILIAL("SX5")+"24"+cFormPag,"X5_DESCRI"); li := li + 1

DbSelectArea("SA3")
DbSetOrder(1)
SA3->(DbSeek(XFilial()+SL1->L1_VEND,.T.))
@ li,01 PSay "OBS.: "+AllTrim(SL1->L1_OBSERV)
//li++
//@ li,001 PSay "Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ)
li++
@ li,001 PSay "Observacoes: "
If Len(Alltrim(SL1->L1_OBSENT1)) > 0 
	@ li,015 PSay SL1->L1_OBSENT1 ; li++
EndIf
If Len(Alltrim(SL1->L1_OBSENT2)) > 0
	@ li,015 PSay SL1->L1_OBSENT2 ; li++
EndIf

If !Empty( SL1->L1_XNUMOS)
	@ li,001 PSay p_negrit_l + "ORDEM DE SERVICO: " + SL1->L1_XNUMOS + p_negrit_d
	li++
EndIf

iF SL1->(FieldPos("L1_OBSENT3")) > 0
	If Len(Alltrim(SL1->L1_OBSENT3)) > 0 
		@ li,015 PSay SL1->L1_OBSENT3 ; li++
	EndIf	
EndIf

If SL1->(FieldPos("L1_OBSENT4")) > 0
    If Len(Alltrim(SL1->L1_OBSENT4)) > 0 
	   @ li,015 PSay SL1->L1_OBSENT4 ; li++
	EndIf	
EndIf

If SL1->L1_RECLOC == "S"
	li := li + 1
	@ li,034 PSAY p_negrit_l + " *****    R E C E B E R     N O     L O C A L    *****" + p_negrit_d
EndIf
li := li + 1
//@ li,001 PSay "Orcamento: " + SL1->L1_NUM
//Impressão dos Itens
@ li,01 PSay Replicate("-",nwTam); li := li + 1
//   @ li,01 PSay "  PRODUTO           DESCRICAO                                            1.UM  QTD 1.UM   2.UM   QTD 2.UM    PRC UNI   TOTAL "

@ li,02  PSay "PRODUTO"
@ li,12  Psay "DESCRICAO"

@ li,74 - 13  Psay "1.UM "
@ li,79 - 11  PSay "QTD 1.UM"

@ li,091 - 12 Psay "2.UM"
@ li,096 - 11 PSay "QTD 2.UM"

@ li,108 - 12 PSay "PRC UNI"
@ li,120 - 12 PSay "TOTAL"

//@ li,132 - 12 PSay "Pedido"

//                        1         2         3         4         5         6         7         8         9        10        11        12
//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//               99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX 99,999  999,999.99  9,999.99  99.9 999,999.99  X
li := li + 1
@ li,01 Psay Replicate("-",nwTam)
li := li + 1
/*
li := li + 1
li := li + 1
@ li,01 PSay Replicate("-",130); li := li + 1
If fwCodEmp() != "05"
  @ li,01 PSay " CODIGO      QTD      UM     DESCRICAO                                     FABRICANTE            PRECO         TOTAL        "
Else
  @ li,01 PSay " CODIGO      PESO     UM     QTD         DESCRICAO                                               PRECO         TOTAL        "
EndIf

//                     1         2         3         4         5         6         7         8         9        10        11        12
//            123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//            99999999  9,999.99   XXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXX    999,999.99    999,999.99   9,999,999.99

li := li + 1
@ li,01 Psay Replicate("-",130)
li := li + 1
*/
Return
***************************************************************************************

Static Function RodapeForm()

@ li,01 Psay Replicate("-",130); li := li +1
@ li,01 PSay PADC("",130)
li := li + 17
@ li,000 Psay " "

Return
***************************************************************************************

Static Function Geral()
Local x, nCol
Local cNumOrc    := SL1->L1_NUM
Local cFilSL4    := SL4->(XFILIAL("SL4"))
Local nAcrescimo := 0
Local aParc      := {}

SL4->(dbSetOrder(1))
SL4->(dbSeek(cFilSL4+cNumOrc,.T.))
While !SL4->(Eof()) .And. cFilSL4+cNumOrc == SL4->(L4_FILIAL+L4_NUM)
	AAdd( aParc , { SL4->L4_VALOR, SL4->L4_DATA, SL4->L4_FORMA, SL4->L4_ADMINIS})
	nAcrescimo += SL4->L4_VALOR
	SL4->(dbSkip())
Enddo

nAcrescimo -= SL1->L1_VALMERC //- SL1->L1_VLRTOT
nAcrescimo := If( nAcrescimo < 0 , 0, nAcrescimo)


@ li,01 PSay Replicate("-",130) ; li := li + 1
@ li,01       PSay "PESO: "      + Alltrim( Transform(TotPeso  ,"@E 999,999.99") )
@ li,PCol()+2 PSay "SUB-TOTAL: " + Alltrim(Transform(TotGeral  ,"@E 999,999.99") )
@ li,PCol()+2 PSay "DESC:  "     + Alltrim(Transform(DescTotal ,"@E 999,999.99") )
@ li,PCol()+2 PSay "ICMS Retido:"+ Alltrim(Transform(_nTImcsSol ,"@E 999,999.99") )
@ li,PCol()+3 PSay "TOTAL: "     + Alltrim(Transform((TotGeral-DescTotal) + _nTImcsSol,"@E 9,999,999.99") )
li++
@ li,01       PSay "Ordem de Servico: " + SL1->L1_XNUMOS
li++
li++
@ li,01       PSay Replicate("-",130) ; li := li + 1

iF(SL1->L1_ENTREGA == 'S')
@ li,001 PSay "RECEBEDOR  : "+AllTrim(SL1->L1_RECENT)   
@ li,060 PSay "ENDERECO ENTREGA : "+Alltrim(Left(SL1->L1_ENDENT,50)) ; li := li + 1
@ li,001 PSay "CIDADE ENTREGA: "+Alltrim(SL1->L1_MUNE) + " - " + Alltrim(SL1->L1_ESTE)
@ li,040 PSay "FONE ENTREGA: "+Transform(SL1->L1_FONEENT,'@R 9999-9999') ; li := li + 1
@ li,001 PSay "OBSERVACAO ENT.: "+ SL1->L1_OBSENT1 ; li := li + 1
ENDIF

@ li,01       PSay "EMISSAO: " +DTOC(SL1->L1_EMISSAO)
@ li,PCol()+1 PSay "ENTREGAR ATE: " + DTOC(SL1->L1_DTLIM)
@ li,PCol()+1 PSay "RECEBI:    /    /  "
@ li,PCol()+1 PSay "ASS. CLIENTE:_________________________________ "
@ li,PCol()+3 PSay "PEDIDO: " + SL1->L1_NUM ; li := li + 1


	
Col    := 1
QtdCol := 1
nItem  := 1

Return

Static Function GetForm(_cdFilial,_cdOrcamento)
Local _cdForm  := ""
Local _adForm  := {}
Local _adForma := {}

SL4->(dBSetOrder(1))

If SL4->(dbSeek(_cdFilial + _cdOrcamento))
	
	While(!SL4->(EOF()) .And. (_cdFilial + _cdOrcamento) == SL4->(L4_FILIAL + L4_NUM)  )
	   _ndPos := iIf( Len(_adForm) !=0, aScan(_adForm,{|x| x[01] == SL4->L4_FORMA} ),0)
		If _ndPos > 0
			_adForm[_ndPos][02] += SL4->L4_VALOR
			_adForm[_ndPos][03] += 1
		else
			aAdd(_adForm,{SL4->L4_FORMA,SL4->L4_VALOR,1})
		Endif
		SL4->(dbSkip())
	EndDo
	
	_adForma := {""}
	_ndItem  := 01
	For nI := 1 to Len(_adForm)
		_cdForm := iIf(Empty(_adForma[_ndItem]),"","/") + Alltrim(Transform(_adForm[nI][02],"@E 999,999,999.99")) + " " + Alltrim(Str(_adForm[nI][03]) + "x" + Alltrim(_adForm[nI][01]) )
		If Len(_adForma[_ndItem]) + Len(_cdForm) + iIf(Empty(_adForma[_ndItem]),0,1) >= 132
			_ndItem++
		EndIf
		_adForma[_ndItem] += _cdForm
	Next
Else
	_adForma := {""}
EndiF

Return _adForma

*----------------------------------------------------------------------------------------------*
Static Function CriaSx1(cPerg)
*----------------------------------------------------------------------------------------------*
Local aTam := {}
aAdd(aTam,{TamSx3("L1_NUM")[01],TamSx3("L1_NUM")[02]})
aAdd(aTam,{TamSx3("C5_NUM")[01],TamSx3("C5_NUM")[02]})

PutSX1(cPerg,"01","Orcamento ?" ,"","","mv_ch1","C",aTam[01][01],aTam[01][02],0,"G","","SL1","","","mv_par01")
Return
