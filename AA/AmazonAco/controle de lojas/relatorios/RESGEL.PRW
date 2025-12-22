#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RESGEL     ¦ Autor ¦               ¦ Data ¦ 				  ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦  RESGEL   ¦ Relatorio emissão de Vendas Diaria PILOTO                     ¦¦¦
¦¦¦           ¦                               								  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function RESGEL()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio Conferencia de Vendas"
Local cPict         := ""
Local titulo        := "Relatorio de Vendas Geral PILOTO "
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd 		    := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "RESGEL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RESGEL" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		:= Padr("RESGEL",Len(SX1->X1_GRUPO))
Private cString     := "SD2"

CriaSx1(cPerg)
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
Titulo := AllTrim(Titulo)
Cabec1 := " Periodo: " + DtoC(mv_par01) + " A " + DtoC(mv_par02)
Cabec2 := " LOJA                       |      VENDA BRUTA       |     TROCA/DEVOLUCAO     |     VENDA LIQUIDA      | NOTAS EMITIDAS"
//          12 - 12345678901234567980         999.999.999.99            999.999.999.99           999.999.999.99       999.999.999
//          000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
//          000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
//          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456879012345678901

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQry, x , bimp
Local cDatIni := DtoS(mv_par01)
Local cDatFim := DtoS(mv_par02)

_cTESVendas := GetMv("MV_YTESVEN")
_cTESDevol  := GetMv("MV_YTESDEV")
//
//  .----------------------------------------------------------------------------------------.
// |     Inicio da Query para selecionar os produtos de acordo com o Parametro Informado.     |
//  '------------------------------------------------------------------	----------------------'
//
cQry := " SELECT RFILIAL, SUM(SAIDA) SAIDA, SUM(ENTRADA) ENTRADA, SUM(DESCONTO) DESCONTO, SUM(NOTAS) NOTAS "
cQry += " FROM (SELECT L2_FILIAL RFILIAL, L1_NUM DOC, 'ORC' SERIE, 1 NOTAS, SUM(L2_VLRITEM)SAIDA, SUM(0) ENTRADA, SUM(0) DESCONTO "
cQry += " FROM " + RetSqlName("SL2") + " A, " + RetSqlName("SL1") + " B "
cQry += " WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' "
cQry += " AND L1_FILIAL = L2_FILIAL "
cQry += " AND L1_NUM = L2_NUM "
cQry += " AND L1_EMISNF BETWEEN '"+cDatIni+"' AND '"+cDatFim+"' "
cQry += " AND ( (L1_TIPO = 'V' AND L2_VENDIDO='S') OR (L1_TIPO = 'P' AND L1_DOCPED <> ' ') ) "
cQry += " AND L2_LOCAL = '01' AND L2_TES NOT IN " + FormatIn( _cTESVendas, ",") + " AND L2_FILIAL = '"+xFilial("SL2")+"' " 
cQry += " GROUP BY L2_FILIAL, L1_NUM "
cQry += " UNION "
cQry += " SELECT D1_FILIAL RFILIAL, D1_DOC DOC, D1_SERIE SERIE, 0 NOTAS, SUM(0) SAIDA, SUM(D1_TOTAL) ENTRADA, SUM(D1_VALDESC) DESCONTO "
cQry += " FROM " + RetSqlName("SD1")+ " "
cQry += " WHERE D_E_L_E_T_=' ' "
cQry += " AND D1_DTDIGIT BETWEEN '"+cDATINI+"' AND '"+cDATFIM+"' AND D1_TIPO = 'D'"
cQry += " AND D1_LOCAL IN ('01','02') AND D1_TES IN " + FormatIn(_cTESDevol, ",") + " AND D1_FILIAL <= '17'"
cQry += " GROUP BY D1_FILIAL, D1_DOC, D1_SERIE, D1_DTDIGIT) A "
cQry += " GROUP BY RFILIAL "
cQry += " ORDER BY RFILIAL "

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRZ", .T., .F. )
TcSetField("TRZ", "EMISSAO", "D", 8, 0)

dbSelectArea("TRZ")
dbGoTop()
SetRegua(RecCount())

nTotVE  := 0
nTotDE  := 0
nTotliq := 0
vVenliq := 0
nTotmet := 0
nMetad  := 0
nTotper := 0
nPERC   := 0
nTotNot := 0

While !Eof()
	
	If nLin > 55
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
	Endif
	vVenliq := (TRZ->SAIDA-(TRZ->ENTRADA-TRZ->DESCONTO) )
	cRazao := Alltrim(SM0->M0_FILIAL)+"/"+Alltrim(SM0->M0_NOME)
	
	@nLin,000 PSAY RFILIAL + " - " + Left(cRazao,20)
	@nLin,034 PSAY Transform( TRZ->SAIDA,                   "@E 999,999,999.99")
	@nLin,060 PSAY Transform( (TRZ->ENTRADA-TRZ->DESCONTO), "@E 999,999,999.99")
	@nLin,085 PSAY Transform( vVenliq,                      "@E 999,999,999.99")
	@nLin,106 PSAY Transform(  TRZ->NOTAS,                     "@E 999,999,999"); nLin++
	
	nTotVE  += TRZ->SAIDA
	nTotDE  += (TRZ->ENTRADA-TRZ->DESCONTO)
	nTotliq += vVenliq
	nTotNot += TRZ->NOTAS
	
	dbSkip()
End

dbCloseArea()

If nTotve<>0
	@nLin,000 PSAY Replicate("-",132);	nLin++
	@nLin,000 PSAY ">>>   TOTAL GERAL   >>>"
	@nLin,034 PSAY Transform( nTotve,  "@E 999,999,999.99")
	@nLin,060 PSAY Transform( nTotDe,  "@E 999,999,999.99")
	@nLin,085 PSAY Transform( nTotliq, "@E 999,999,999.99")
	@nLin,106 PSAY Transform( nTotNot, "@E 999,999,999")
EndIf

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return
//
//
//
//
//
Static Function CriaSx1()

PutSX1(cPerg,"01","Da Data"         ,"Da Data"         ,"Da Data"         ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","Ate Data"        ,"Ate Data"        ,"Ate Data"        ,"mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return Nil
