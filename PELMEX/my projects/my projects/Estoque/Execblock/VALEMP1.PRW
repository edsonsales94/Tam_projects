#INCLUDE "rwmake.ch"
#include "TOPCONN.CH"


User Function VALEMP1                                    
	Local cXVALEMP := GETMV("MV_XVALEMP")
	Local cAlias := Alias()   

	If FUNNAME() <> "MATA250" .Or. !Inclui .OR. cXVALEMP !="S"
		Return .T.
	End If
/*
	BeginSql Alias "TD4"
		Select *
		From %Table:SD4% SD4
		Where %notdel%
		And D4_FILIAL = %xFilial:SD4%
		And D4_OP = %Exp:M->D3_OP%
		And D4_QUANT > 0
	EndSql

	If TD4->(Eof())
		Alert("OP " + M->D3_OP + "Não possui Empenho. Verifique o Ajuste de Empenhos ou Estrutura do Produto.", "ATENÇÃO!!!")
		TD4->(dbCloseArea())
		Return .f.
	EndIf

	TD4->(dbCloseArea()) 

	dbSelectArea(cAlias)
*/
Return .T.
