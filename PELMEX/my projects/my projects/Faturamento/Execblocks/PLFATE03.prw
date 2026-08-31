#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATE03    ºAutor  ³Stan Lee Lopes     				º Data ³  24/07/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o Cliente tem títulos em aberto no Financeiro				 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function MT410TOK()
	//Local lRet             := .T.				// Conteudo de retorno

	//Valida títulos vencidos no Financeiros por cliente
	//if !U_PLFATE03()
		//return .F.
	//endif


Return(lRet)

User Function PLFATE03

	//Local aArea       := GetArea()
	Local cQuery      := ""
	Local nRecCount   := 0  
	Local lRet 	      := .T.
	Local cCliente    := M->C5_CLIENTE

	//object oGetcCliente

	//Faço a consulta para pegar as informações
	cQuery := "SELECT CONVERT(VARCHAR,GETDATE(),112),* "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SE1")+" SE1 " 
	cQuery += "WHERE SE1.D_E_L_E_T_ = '' "
	cQuery += "AND E1_SALDO > 0 "
	cQuery += "AND E1_TIPO IN ('BO','BOL','NF') "
	cQuery += "AND E1_VENCTO < CONVERT(VARCHAR,GETDATE(),112) "
	cQuery += "AND E1_CLIENTE = '"+cCliente+"' "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	If Select("TRBSE1") <> 0
		DbSelectArea("TRBSE1")
		TRBSE1->(DbCloseArea())
	EndIf

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSE1"	

	dbSelectArea("TRBSE1")
	TRBSE1->(dbGoTop())

	//Se não tiver em branco
	If !Empty(TRBSE1->E1_CLIENTE)

		Count To nRecCount

		ProcRegua( nRecCount )

		If nRecCount > 0
			//Alert("Cliente com "+cValToChar(nRecCount)+" Título(s) Vencido(s). Por favor, procurar o setor Financeiro para mais detalhes.")
			//lRet := .F.
		EndIf
		/*		
		If Empty(mLeitor)
		oLeitor:SetFocus()
		Return .T.
		EndIf  
		*/
	//EndIf



//Return (lRet)*/