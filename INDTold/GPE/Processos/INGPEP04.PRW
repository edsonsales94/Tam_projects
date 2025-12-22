#include 'Protheus.ch' 
#include 'ApWebSrv.ch'
#Include 'TopConn.Ch'
#include "Tbiconn.ch"     
#INCLUDE "rwmake.ch" 
#INCLUDE "Fileio.ch"

**********************************************************************************************************************************

User Function INGPEP04()
 
Local _xdQry := ""
Local nCont  := 0.0000
Local aArea  := GetArea()

// Gera Qry para Alimentar os Dados 
 _xdQry := " SELECT MAX(CAST(RIGHT(RTRIM(RCC_CONTEU),11) AS FLOAT))*20 * 0.058 N20SAL , "
 _xdQry += " (  "
 _xdQry += " SELECT COUNT(*) NFUNS FROM ( "
 _xdQry += " SELECT RA_MAT, RA_CATFUNC FROM " + RetSqlName('SRC') + " RC "
 _xdQry += "  INNER JOIN " + RetSqlName('SRA') + " RA ON RA_FILIAL = RC_FILIAL AND RA_MAT = RC_MAT  AND RC_PD = '749'" 
 _xdQry += "  AND RA.D_E_L_E_T_ = ' ' "
 _xdQry += "  WHERE RC_FILIAL BETWEEN '01' AND '99'"
 _xdQry += "   AND RA_CATFUNC NOT IN ('A','E','P')"
 _xdQry += "   AND RC.D_E_L_E_T_ = '' "
 _xdQry += "  GROUP BY RA_MAT, RA_CATFUNC "
 _xdQry += " ) D ) NVALRAT "
 _xdQry += "  FROM " + RetSqlName('RCC') + " "
 _xdQry += " WHERE RCC_CODIGO = 'S004' AND D_E_L_E_T_ = '' "

_xdAls := MpSysOpenQuery(_xdQry)

If (_xdAls)->NVALRAT > 0
    nCont := (_xdAls)->N20SAL/(_xdAls)->NVALRAT
EndIf 

(_xdAls)->(dbclosearea())

RestArea(aArea)

Return nCont

