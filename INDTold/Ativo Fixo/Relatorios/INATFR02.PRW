#INCLUDE "rwmake.ch"

/*/
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  09/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
/*/

User Function INATFR02()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatório de Custos do Ativo Fixo"
Local cPict        := ""
Local titulo       := "Relatório de Custos do Ativo Fixo"
Local nLin         := 80
//                                                                                                                        1         1         1         1         1         1         1         1         1         1
//                              1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9
//                     1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := "Data         Fornecedor                 CPF / CNPJ     DOCUMENTO    DESCRIÇÃO DO PRODUTO                     VALOR ENTRADA        LOCAL                    Cod. Bem        Plaqueta      "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 180
Private tamanho    := "G"
Private nomeprog   := "INATF02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CUSTO" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString    := ""
Private cPerg      := Padr("ATFR02",Len(SX1->X1_GRUPO))

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem, cAnt := "" , nTotal := 0, cCusto := ""

BUSCADADOS()
cAnt := WRK1->D1_PRCOMP
SetRegua(REGS->regs)
//REGS->regs
if empty(mv_par03)
	cTotais := "Area"
else
	cTotais := "Centro de custo"
endif

dbGoTop()
While !WRK1->(EOF())	

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
    
   If lAbortPrint
    	  @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif
   	     
   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   	Endif
   	
	nLin++
   	@nLin,001 PSAY "Nro. Processo "+WRK1->D1_PRCOMP
   	nLin++
   	
   WHILE WRK1->D1_PRCOMP == cAnt .AND. !WRK1->(EOF())
   	If lAbortPrint
    	  @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Impressao do cabecalho do relatorio. . .                            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   	Endif
    	INCREGUA()
    	@nLin,001 PSAY DTOC(WRK1->N1_AQUISIC)
		@nLin,014 PSAY POSICIONE("SA2",1,XFILIAL("SA2")+WRK1->D1_FORNECE+WRK1->D1_LOJA,"A2_NREDUZ")
		@nLin,040 PSAY POSICIONE("SA2",1,XFILIAL("SA2")+WRK1->D1_FORNECE+WRK1->D1_LOJA,"A2_CGC")
		@nLin,056 PSAY WRK1->D1_SERIE+WRK1->D1_DOC
		@nLin,068 PSAY WRK1->N1_DESCRIC
		@nLin,110 PSAY transform(POSICIONE("SN3",1,XFILIAL("SN3")+WRK1->N1_CBASE+WRK1->N1_ITEM,"N3_VORIG1"),"@e 999,999,999,999.99")
		@nLin,131 PSAY WRK1->N3_CCUSTO
		@nLin,156 PSAY WRK1->N1_CBASE
		@nLin,172 PSAY WRK1->N1_CHAPA
	    nTotal += POSICIONE("SN3",1,XFILIAL("SN3")+WRK1->N1_CBASE+WRK1->N1_ITEM,"N3_VORIG1")

   	nLin := nLin + 1 // Avanca a linha de impressao
	cAnt := WRK1->D1_PRCOMP 
	cCusto := alltrim(WRK1->N3_CCUSTO)
   	WRK1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   	
   ENDDO
   cAnt := WRK1->D1_PRCOMP
   
 //  nTotal := 0
 //  WRK1->(dbSkip())
EndDo
	@nLin,000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";nLin++
	if mv_par04 == " "
		@nLin,001 PSAY POSICIONE("CTT",1,XFILIAL("CTT")+cCusto,"CTT_DESC01")
	endif
   	@nLin,030 PSAY "TOTAL DO "+cTotais+" = "+TRANSFORM(nTotal,"@e 999,999,999,999.99")   ; @nLin,080 PSAY "Streaming : "+POSICIONE("CTT",1,XFILIAL("CTT")+IIF(EMPTY(MV_PAR04),PADR(SUBSTR(MV_PAR03,1,1),9),PADR(MV_PAR04,9)),"CTT_DESC01");nLin++
   	@nLin,000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
WRK1->(DBCLOSEAREA())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

STATIC FUNCTION BUSCADADOS()
Local cCons := ""
Local nCons := ""

nCons := " SELECT count(*) as regs FROM "+RetSqlName("SD1")
nCons += " INNER JOIN "+RetSqlName("SN1")+" ON D1_PRCOMP = N1_XPRCOMP AND D1_FILIAL = N1_FILIAL "
NCons += " INNER JOIN "+RetSqlName("SN3")+" ON N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N3_FILIAL = N1_FILIAL"
nCons += " WHERE N1_AQUISIC BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"      
IF !EMPTY(MV_PAR03)
	NCons += " AND N3_CCUSTO = '"+MV_PAR03+"' "
ENDIF
IF !EMPTY(MV_PAR04)
	NCons += " AND N3_CCUSTO LIKE '"+MV_PAR04+"%'"
ENDIF

dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(nCons)), "REGS", .T., .T.)

cCons := " SELECT D1_FILIAL, D1_PRCOMP, D1_ITEM, D1_COD, N3_CCUSTO, D1_CC, D1_DESCRI, N1_DESCRIC, D1_CBASEAF, D1_DOC, N1_NFISCAL, "
cCons += " D1_PEDIDO, D1_SERIE, N1_CHAPA, N1_CBASE, N1_FILIAL, N1_AQUISIC,N1_ITEM, D1_LOJA, D1_FORNECE, N1_CODBAR FROM "+RetSqlName("SD1")
cCons += " INNER JOIN "+RetSqlName("SN1")+" ON D1_CBASEAF = N1_CODBAR AND D1_FILIAL = N1_FILIAL "
cCons += " INNER JOIN "+RetSqlName("SN3")+" ON N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N3_FILIAL = N1_FILIAL"
cCons += " WHERE N1_AQUISIC >= '"+DTOS(MV_PAR01)+"' AND N1_AQUISIC <= '"+DTOS(MV_PAR02)+"'"
IF !EMPTY(MV_PAR03)
	cCons += " AND N3_CCUSTO = '"+MV_PAR03+"' "
ENDIF
IF !EMPTY(MV_PAR04)
	cCons += "AND N3_CCUSTO LIKE '"+MV_PAR04+"%'"
ENDIF
cCons += " ORDER BY D1_PEDIDO, N1_CBASE"

dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cCons)), "WRK1", .T., .T.)
TcSetField("WRK1","N1_AQUISIC","D")

RETURN

Static Function ValidPerg(cPerg)

u_INPutSX1(cPerg,"01","Da Data    :","","","mv_ch1","D",30,0,0,"G","","",   "","","mv_par01")
u_INPutSX1(cPerg,"02","Até Data   :","","","mv_ch2","D",20,0,0,"G","","",	"","","mv_par02")
u_INPutSX1(cPerg,"03","Centro Custo   :","","","mv_ch3","C",09,0,0,"G","","CTT",	"","","mv_par03")
u_INPutSX1(cPerg,"04","Streaming  :","","","mv_ch4","C",01,0,0,"G","","",	"","","mv_par04")
u_INPutSX1(cPerg,"05","Do Processo  :","","","mv_ch5","C",06,0,0,"G","","",	"","","mv_par05")
u_INPutSX1(cPerg,"06","Ao processo  :","","","mv_ch6","C",06,0,0,"G","","",	"","","mv_par06")

Return Nil
