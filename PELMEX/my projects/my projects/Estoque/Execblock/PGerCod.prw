#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ Marcio Macedo      บ Data ณ  11/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gerar sequencial de codigo do Produto          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PGerCod()
	Local cQry    := ""
	Local _SB1    := RetSqlName("SB1")
	Local cAliasT := Alias() 
	Local nSeq    := ""
	Local cRet    := ""
	Local cEMP := cempant

	/*cQry := " SELECT ISNULL(MAX(SB1.B1_COD),10000001)+1 B1_COD"
	cQry += " FROM "+RETSQLNAME("SB1")+" SB1"
	cQry += " WHERE SB1.D_E_L_E_T_ <> '*' "
	cQry += " AND SUBSTRING(SB1.B1_COD,1,4) = '"+M->B1_GRUPO+"' " */
	//STAN 29/01/2019
	/*
	cQry := "SELECT SUBSTRING(B1_GRUPO,1,3)+CAST(SUBSTRING(MAX(B1_COD),4,13)+1 AS varchar) B1_COD
	cQry += "FROM "+RETSQLNAME("SB1")+" SB1
	cQry += "WHERE SB1.D_E_L_E_T_ <> '*' 
	cQry += "AND SUBSTRING(SB1.B1_COD,1,4) LIKE '"+M->B1_GRUPO+"%' 
	cQry += "AND B1_GRUPO = '"+M->B1_GRUPO+"'
	cQry += "AND SB1.B1_MSBLQL !='1'
	cQry := " GROUP BY B1_GRUPO 
	*/

	// JUNIOR 20/04/2021
	IF cEMP = '10'//PELMEX
	
	cQry := " SELECT " 
	cQry += " CASE WHEN SUBSTRING(SB1.B1_GRUPO,1,1) = '0' THEN replicate('0',9-len(MAX(B1_COD)))+cast(MAX(B1_COD)+1 as varchar) " 
	cQry += " ELSE  replicate('0',8-len(MAX(B1_COD)))+cast(MAX(B1_COD)+1 as varchar) END B1_COD " 
	cQry += " FROM "+RETSQLNAME("SB1")+" SB1 " 
	cQry += " WHERE SB1.D_E_L_E_T_ <> '*' " 
	cQry += " AND SUBSTRING(SB1.B1_COD,1,4) LIKE '"+M->B1_GRUPO+"'  " 
	cQry += " AND B1_GRUPO = '"+M->B1_GRUPO+"'  " 
	cQry += " AND LEN(LTRIM(RTRIM(B1_COD))) >=8 " 
	cQry += " GROUP BY B1_GRUPO "

	else
	//AMAZON
	cQry := "SELECT replicate('0',9-len(MAX(B1_COD)))+cast(MAX(B1_COD)+1 as varchar) as B1_COD "
	cQry += " FROM "+RETSQLNAME("SB1")+" SB1 "
	cQry += " WHERE SB1.D_E_L_E_T_ <> '*' "
	cQry += " AND SUBSTRING(SB1.B1_COD,1,4) = '"+M->B1_GRUPO+"' "
	cQry += " AND B1_GRUPO = '"+M->B1_GRUPO+"' " 
	cQry += " AND LEN(LTRIM(RTRIM(B1_COD))) >=8 "
	cQry += " GROUP BY B1_GRUPO "
	endif

	/*
	cQry := " SELECT B1_GRUPO+SUBSTRING(CAST(MAX(B1_COD)+1 AS VARCHAR),5,12) B1_COD "
	cQry += " FROM "+RETSQLNAME("SB1")+" SB1"
	cQry += " WHERE SB1.D_E_L_E_T_ <> '*' "
	cQry += " AND SUBSTRING(SB1.B1_COD,1,4) = '"+M->B1_GRUPO+"' "
	//JUNIOR 12/08/2020
	cQry += "AND SB1.B1_MSBLQL !='1'"
	cQry += " GROUP BY B1_GRUPO "
	*/
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TMP", .T., .F. )
	dbSelectArea("TMP")

	cRet := TMP->B1_COD
	//FIM

	//nSeq := SUBSTR(ALLTRIM(STR(TMP->B1_COD)),5,4)  
	//nSeq := TMP->B1_COD
	dbCloseArea("TMP")

	//cRet := M->B1_GRUPO+SOMA1(nSeq,4) 
	//cRet := STR(nSeq)

	dbSelectArea(cAliasT)

Return cRet
