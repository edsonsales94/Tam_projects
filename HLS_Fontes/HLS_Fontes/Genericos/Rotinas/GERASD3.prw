#include "totvs.ch"
#include "topconn.ch"

User Function GeraSD3()

If MsgYesNo("Inicia processamento?","Aviso")
	Processa({|| Gera()})
Endif

Return

Static Function Gera()

Local cQuery 		:= ""

cQuery := " SELECT *, CAST(ROUND(D3_QUANT - QTD_ESTR_PROP,6) AS DECIMAL(16,6)) DIF" + CRLF
cQuery += " FROM (" + CRLF
cQuery += " SELECT  G1_COD," + CRLF 
cQuery += "             C2_NUM," + CRLF 
cQuery += "             C2_ITEM," + CRLF
cQuery += "             C2_SEQUEN," + CRLF
cQuery += "             C2_SEQMRP," + CRLF 
cQuery += "             C2_EMISSAO," + CRLF 
cQuery += "             C2_DATPRI," + CRLF 
cQuery += "             C2_DATRF," + CRLF 
cQuery += "             C2_QUANT," + CRLF 
cQuery += "             C2_QUJE," + CRLF 
cQuery += "             G1_COMP," + CRLF 
cQuery += "             B1_DESC," + CRLF
cQuery += "             ISNULL(CASE WHEN LEFT(D3_CF,1) = 'D' THEN SUM(D3_QUANT) * -1 ELSE SUM(D3_QUANT) END,0) D3_QUANT," + CRLF 
cQuery += "             CAST(ROUND(G1_QUANT * C2_QUJE,6) AS DECIMAL(15,6)) QTD_ESTR_PROP," + CRLF 
cQuery += "             CAST(ROUND(G1_QUANT * C2_QUANT,6) AS DECIMAL(15,6)) QTD_ESTR_CHEIA," + CRLF
cQuery += "             ISNULL(D4_QTDEORI,0) QTD_EMP" + CRLF
cQuery += " FROM SG1010 (NOLOCK) G1" + CRLF
cQuery += "     INNER JOIN SC2010 (NOLOCK) C2 ON C2.D_E_L_E_T_=' ' AND C2_PRODUTO = G1_COD AND C2_REVISAO >= G1_REVINI AND C2_REVISAO <= G1_REVFIM" + CRLF
cQuery += "     LEFT JOIN SD3010 (NOLOCK) D3 ON D3.D_E_L_E_T_=' ' AND D3_FILIAL = '01' AND D3_ESTORNO <> 'S' AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D3_COD = G1_COMP" + CRLF 
cQuery += "     LEFT JOIN SD4010 (NOLOCK) D4 ON D4.D_E_L_E_T_=' ' AND D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D3_COD = D4_COD" + CRLF
cQuery += "     INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_=' ' AND B1_COD = G1_COMP" + CRLF
cQuery += "     WHERE G1.D_E_L_E_T_=' '" + CRLF
cQuery += "     AND C2_EMISSAO >= '20180108'" + CRLF
cQuery += "     AND G1_INI <= C2_DATPRI" + CRLF
cQuery += "     AND G1_FIM >= C2_DATPRI" + CRLF
cQuery += "     AND C2_QUJE > 0" + CRLF
cQuery += "     GROUP BY G1_COD," + CRLF 
cQuery += " 			C2_NUM," + CRLF 
cQuery += " 			C2_ITEM," + CRLF 
cQuery += " 			C2_SEQUEN," + CRLF 
cQuery += "             C2_SEQMRP," + CRLF 
cQuery += "             C2_EMISSAO," + CRLF 
cQuery += "             C2_DATPRI," + CRLF 
cQuery += "             C2_DATRF," + CRLF 
cQuery += "             C2_QUANT," + CRLF 
cQuery += "             C2_QUJE," + CRLF 
cQuery += "             G1_COMP," + CRLF
cQuery += "             B1_DESC," + CRLF
cQuery += "             D3_CF," + CRLF
cQuery += "             G1_QUANT," + CRLF
cQuery += "             C2_QUJE," + CRLF
cQuery += "             C2_QUANT," + CRLF
cQuery += "             D4_QTDEORI" + CRLF
cQuery += " ) ZZ" + CRLF
cQuery += " WHERE (D3_QUANT <> QTD_ESTR_PROP)" + CRLF
cQuery += " AND C2_SEQMRP = '001093'" + CRLF
//cQuery += " AND C2_NUM = '405505'" + CRLF
cQuery += " ORDER BY C2_EMISSAO, DIF" + CRLF

MemoWrite("GeraSD3.sql", cQuery)

If Select("QSD3") > 0
	QSD3->(dbCloseArea())
Endif

tcQuery cQuery New Alias "QSD3"

Count to nRegs

ProcRegua(nRegs)

QSD3->(dbGoTop())

Begin Transaction

While QSD3->(!eof())

	IncProc()

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+QSD3->G1_COMP))
	
	Reclock("SD3",.T.)
		SD3->D3_FILIAL 	:= "01"
		SD3->D3_TM 		:= "999"
		SD3->D3_COD		:= QSD3->G1_COMP
		SD3->D3_UM		:= SB1->B1_UM
		SD3->D3_QUANT	:= QSD3->DIF*-1
		SD3->D3_CF		:= "RE2"
		SD3->D3_CONTA	:= SB1->B1_CONTA
		SD3->D3_OP		:= QSD3->(C2_NUM+C2_ITEM+C2_SEQUEN)
		SD3->D3_LOCAL	:= IIf(SB1->B1_APROPRI == "D", SB1->B1_LOCPAD, "99")
		SD3->D3_DOC		:= "AJUSTEOP"
		SD3->D3_EMISSAO := StoD(QSD3->C2_DATRF)
		SD3->D3_GRUPO	:= SB1->B1_GRUPO
		SD3->D3_NUMSEQ	:= "000000"
		SD3->D3_TIPO	:= SB1->B1_TIPO
		SD3->D3_CHAVE	:= "E0"
		SD3->D3_IDENT	:= "000000"
		SD3->D3_USUARIO := "AJUSTE"
	SD3->(MsUnlock())
	
	QSD3->(dbSkip())
EndDo

End Transaction

MsgInfo("Inclusao SD3 concluida. Favor executar saldo atual para armazem 99.","Aviso")

Return