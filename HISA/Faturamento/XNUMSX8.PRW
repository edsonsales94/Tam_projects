//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ XNUMSX8    ¦ Autor ¦Edson Sales           ¦ Data ¦ 13/01/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Controle de numeração pedido de vendas, chamada no            ¦¦¦
¦¦¦           ¦ inicializado SX3 - campo C5_NUM GETSXENUM("SC5","C5_NUM")     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

// GETSXENUM("SC5","C5_NUM")
User function XNUMSX8()
	Local aArea := GetArea()
	Local cAlias := GetnextAlias()
    Local lAmb := RpcSetEnv('02', '01',,,"FAT")
    Local CCODIGO
    Local cAno
    Local CQRY := ''
    
    cAno := Right( Str( Year( Date() ), 4 ), 2 ) 
	
    CQRY += " SELECT LEFT(LTRIM(MAX(C5_NUM)),4) COD FROM "+RetSQLName("SC5")
    CQRY += "  WHERE D_E_L_E_T_='' AND  C5_NUM LIKE '%."+cAno +"'"

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

    if Empty((cAlias)->COD)
        CCODIGO := '0001'
    Else
        CCODIGO := SOMA1((cAlias)->COD)
    endif


    CCODIGO += "."+cAno   // PADRAO ADOTADO PELA HISAMITSU (SEQUENCIAL.ANO) - O SEQUENNCIAL REINICIA A CADA ANO.

	RestArea(aArea)

Return CCODIGO
