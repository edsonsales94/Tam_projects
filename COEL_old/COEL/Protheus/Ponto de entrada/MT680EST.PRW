////
////P.E. = ESTORNA SOLICITACAO AO ARMAZEM NO APONTAMENTO DA OPERACAO 01 (SEP.MATERIAIS)
////       CARLOS - 07/10/14
////
#Include "rwmake.ch"

User Function MT680EST() 

Local nAcao  := PARAMIXB[1]
Local _aArea := GetArea()
Local lRet   := ( nAcao == 2 )

IF ( lRet )
	IF ( SH6->H6_OPERAC == "01" )
		/*
		dbSelectArea("SCP")
		dbSetOrder(5)
		dbSeek(xFilial("SCP")+SH6->H6_OP,.T.)
		DO WHILE !EOF().AND.CP_FILIAL==xFilial("SCP").AND.CP_OP==SH6->H6_OP
			
		ENDDO
		*/
	ENDIF	
ENDIF

RestArea(_aArea)

Return(lRet)