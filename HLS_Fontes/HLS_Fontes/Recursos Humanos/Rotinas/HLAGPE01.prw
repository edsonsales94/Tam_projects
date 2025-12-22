#Include "Protheus.ch"

/*/{Protheus.doc} HLAGPE01

Rotina responsável pela atualização da verba dos funcionários 001414 e 001618 
 
@author Ectore Cecato - Totvs IP
@since 06/05/2015
@version Protheus 12 - Gestão de Pessoal

/*/

User Function HLAGPE01()

	Local lContinua	:= .F.
	Local aSays 	:= {}
	Local aButtons	:= {}
		
	aAdd(aSays, "Rotina para atualização de verda")
	
	aAdd(aButtons, {1, 	.T., {|o| lContinua := .T., o:oWnd:End()}})
	aAdd(aButtons, {2, 	.T., {|o| lContinua := .F., o:oWnd:End()}})
	
	FormBatch( "Atualização de verba", aSays, aButtons)
	
	If lContinua
        Processa({|| AtuVerba()}, "Aguarde", "Atualizando verbas")
	Endif

Return

Static Function AtuVerba()

    ProcRegua(11)

	UpdSRC('001', '460')

	UpdSRC('002', '461')

	UpdSRC('284', '462')

	UpdSRC('286', '463')

	UpdSRC('289', '467')

	UpdSRC('340', '464')

	UpdSRC('396', '465')

	UpdSRC('436', '466')

	UpdSRC('337', '338')

	UpdSRC('344', '345')

	UpdSRC('438', '439')

	UpdSRC('536', '540')
		
	UpdSRC('580', '583')

	UpdSRC('684', '689')

	//UpdSRC('438', '439')	// ADD VERBAS DE RESCISAO

	//UpdSRC('438', '439')

	//UpdSRC('438', '439')

Return Nil

Static Function UpdSRC(cVerbaDe, cVerbaPara)
	
	Local cQuery := ""

	IncProc("Atualizando verba "+ cVerbaDe)

	cQuery := "UPDATE "+ RetSqlName("SRC") +" "
	cQuery += "SET "
	cQuery += "		RC_PD = '"+ cVerbaPara +"' "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = ' ' "
	cQuery += "		AND RC_FILIAL = '"+ FWxFilial("SCR") +"' "
	cQuery += "		AND RC_MAT IN ('001414','001618','001639') "			//atualização Luciano Lamberti - 25/08/2021
    cQuery += "     AND RC_PD = '"+ cVerbaDe +"' "

	If TcSqlExec(cQuery) != 0
		UserException(TCSQLError())
	EndIf 

Return Nil
