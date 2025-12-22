#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function CFAT12R()

SetPrvt("CBTXT,CBCONT,NORDEM,TAMANHO,NLIMITE,CIMPRI")
SetPrvt("NTOTAL,NVIPI,NTITEM,AVIPI,NCONT,NVITEM")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NOMEPROG")
SetPrvt("CPERG,NLASTKEY,LCONTINUA,WNREL,CSTRING,NLIN")
SetPrvt("NVDESC,NVACRE,XNUM,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT12R  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 22/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo de Orcamento                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data Manut³ Descricao da Alteracao / Modificacao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³i-22/08/00³ Mudan‡a de Lay-Out c/Inclusao do Campo Total Item e Valor  ³±±
±±³t-25/08/00³ de IPI, Embutir Custo Financeiro quando Ouver e Efetuar    ³±±
±±³Por: AMT  ³ Salto de Pagina corretamente quando a quantidade de itens  ³±±
±±³          ³ Exceder o tamanho da Pagina                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbTxt   := ""
cbCont	:= ""
nOrdem 	:= 0
Tamanho := "P"
nLimite := 80
cImpri  := ""
nTotal  := 0
nVipi   := 0
nTitem  := 0
aVipi   := 0
nCont   := 0
nVitem  := 0
Titulo := PadC(OemToAnsi("Or‡amento de Venda"),74)
cDesc1 := PadC(OemToAnsi("Este programa ira emitir o Orcamento de Venda, conforme"),74)
cDesc2 := PadC(OemToAnsi("os parametros solicitados"),74)
cDesc3 := PadC(OemToAnsi(""),74)

aReturn   := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
NomeProg  := "CFAT12R"
cPerg     := ""
nLastKey  := 0
lContinua := .T.
wnrel     := "CFAT12R"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg,.F.)
cString:="SCK"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
If ( nLastKey == 27 .Or. LastKey() == 27 )
	Return(.F.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)
If ( nLastKey == 27 .Or. LastKey() == 27 )
	Return(.F.)
Endif

RptStatus({|| ImprOrc()})

Return( .T. )

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImprOrc  ³ Autor ³ Alberto Nunes Gama Jr ³ Data ³ 25/06/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo de Orcamento                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function ImprOrc()

dbSelectArea("SCJ")
dbSetOrder(1)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial()+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SCJ->CJ_CONDPAG)

dbSelectArea("SB1")
dbSetOrder(1)

@ 00,  00 PSAY AvalImp(80)

IMPCAB()

@ 11, 01 PSAY "Conforme sua solicitacao, informamos a seguir nossos precos e condicoes comer-"
@ 12, 01 PSAY "ciais para os seguintes equipamentos:"
@ 15, 00 PSAY Replic("-",80)
@ 16, 00 PSAY " Produto Descricao            Quantid   Preco Unit        Total IPI    Valor IPI"
@ 17, 00 PSAY Replic("-",80)

nLIN := 19

dbSelectArea("SCK")
dbSetOrder(1)
dbSeek(xFilial("SCK")+SCJ->CJ_NUM,.T.)

nVdesc  := SCJ->CJ_CLDESC
nVacre  := SCJ->CJ_ACRFIN

While !Eof() .And. SCK->CK_FILIAL == xFilial() .And. SCK->CK_NUM == SCJ->CJ_NUM
	
	dbSelectArea("SB1")
	dbSeek( xFilial() + SCK->CK_PRODUTO )
	nCont := nCont + 1
	@ nLin, 00 PSAY SCK->CK_PRODUTO
	@ nLin, 10 PSAY Subst(SCK->CK_DESCRI,1,20)
	@ nLin, 31 PSAY SCK->CK_QTDVEN       Picture "999,999"
	If SCJ->CJ_CLTXFI == "N"
		nVitem := SCK->CK_PRCVEN
	else
		nVitem := SCK->CK_PRCVEN + ( (SCK->CK_PRCVEN * SCJ->CJ_ACRFIN) / 100 )
	Endif
	
	@ nLin, 39 PSAY nVitem               Picture "@E 999,999.9999"
	nTitem := SCK->CK_QTDVEN * nVitem
	@ nLin, 52 PSAY nTitem               Picture "@E 9,999,999.99"
	@ nLin, 65 PSAY SB1->B1_IPI          Picture "99"
	@ nLin, 67 PSAY "%"
	nVipi := (nTitem * (SB1->B1_IPI / 100))
	aVipi := aVipi + nVipi
	@ nLin, 69 PSAY nVipi                Picture "@E 9,999,999.99"
	
	nTotal := nTotal + nTitem
	nLin := nLin + 1
	
	If nLin >= 57
		@ nLin, 01 PSAY "... Continua na proxima pagina ..."
		IMPRODA()
		IMPCAB()
		@ 10, 00 PSAY " .... continuacao da pagina anterior "
		@ 11, 00 PSAY Replic("-",80)
		@ 12, 00 PSAY " Produto Descricao            Quantid   Preco Unit        Total IPI    Valor IPI"
		@ 13, 00 PSAY Replic("-",80)
		nLin := 14
	Endif
	dbSelectArea("SCK")
	dbSkip()
	
EndDo
If nLin >= 39
	@ nLin, 01 PSAY "... Continua na proxima pagina ..."
	IMPRODA()
	IMPCAB()
	nLin := 14
Endif

@ nLIN, 51 PSAY "------------"
@ nLIN, 68 PSAY "------------"
nLIN := nLIN +1
@ nLin, 25 PSAY "          S O M A  ----->"
@ nLin, 51 PSAY nTotal               Picture "@E 9,999,999.99"
@ nLin, 68 PSAY aVipi                Picture "@E 9,999,999.99"
nLin := nLin + 1
@ nLIN, 51 PSAY "============"
nLin := nLin + 1
@ nLin, 17 PSAY "TOTAL DESTA COTACAO COM IPI ---->"
@ nLin, 51 PSAY aVipi + nTotal  Picture "@E 9,999,999.99"
nLin := nLin + 1
@ nLIN, 51 PSAY "============"

IMPRES()

IMPRODA()
Set Device to Screen
Set Printer To

dbCommitAll()
DbSelectArea("SCK")
DbSetOrder(1)
DbSelectArea("SCJ")
DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	ourspool(wnrel)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_FLUSH()

Return(.T.)

Static FUNCTION IMPCAB()
@ 02, 01 PSAY "COEL Controles Eletricos Ltda"
@ 02, 55 PSAY "COTACAO Numero:  " + SCJ->CJ_NUM
@ 03, 00 PSAY Replic("_",79)
@ 05, 01 PSAY "Para.....: " + SA1->A1_NOME
@ 06, 01 PSAY "Codigo...: " + SA1->A1_COD + "/" + SA1->A1_LOJA
@ 06, 55 PSAY "Data.....: " + DtoC( SCJ->CJ_EMISSAO )
@ 07, 01 PSAY "Att.Sr(a): " + SCJ->CJ_CLSOLIC
@ 08, 01 PSAY "Assunto..: COTACAO DE PREcOS"
@ 08, 55 PSAY "FAX Nr...: " + SA1->A1_FAX
@ 09, 01 PSAY "Vendedor.: " + SCJ->CJ_CLVEND
Return

Static FUNCTION IMPRES()
@ 40, 01 PSAY "Obs....................: " + SCJ->CJ_X_OBS
@ 41, 01 PSAY "Condicao de Pagamento..: " + SE4->E4_DESCRI
@ 42, 01 PSAY "Prazo de Entrega.......: 05 a 10 dias. "
@ 43, 01 PSAY "Garantia...............: 01 (um) Ano.  "
@ 44, 01 PSAY "Validade desta Cotacao.: " + DTOC(SCJ->CJ_CLVALID)
@ 47, 01 PSAY "Agradecendo a sua consulta, colocamo-nos a disposicao para quaisquer esclare-"
@ 48, 01 PSAY "cimentos que se facam necessarios."
@ 50, 01 PSAY "Outrossim, solicitamos que para o fechamento desta cotacao sera necessario   "
@ 51, 01 PSAY "informar-nos o numero desta cotacao: " + SCJ->CJ_NUM + "."
@ 53, 01 PSAY "Atenciosamente,"
@ 55, 01 PSAY SCJ->CJ_CLATEND
@ 56, 01 PSAY "Depto. Vendas"
xnum := VAL(SCJ->CJ_NUM) - VAL(SA1->A1_COD)
@ 57, 01 PSAY "controle: " + SCJ->CJ_NUM +"-"+ALLTRIM(STR(INT(SCJ->CJ_ACRFIN*100))) + "-" + ALLTRIM(STR(INT(SCJ->CJ_CLDESC*100))) + "-" + ALLTRIM(STR(xnum))
Return

Static FUNCTION IMPRODA()
@ 58, 00 PSAY Replic("_",79)
//@ 59, 00 PSAY PadC("RUA MARIZ E BARROS, 146 - CEP: 01545-010 - SaO PAULO - SP", 80)
@ 59, 00 PSAY PadC("      TELEFONES: VENDAS      - (0xx11)2066-3211", 80)
@ 60, 00 PSAY PadC("                  : ASS.TECNICA - (0xx11)3848-3302/03", 80 )
@ 61, 00 PSAY PadC("      FAX      : ASS.TECNICA - (0xx11)3848-3301", 80 )
@ 62, 00 PSAY PadC("       WWW.COEL.COM.BR - VENDAS@COEL.COM.BR", 80 )
Eject

Return
