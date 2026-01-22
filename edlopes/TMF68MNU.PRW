#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
 
//-----------------------------------------------------------------
/*/{Protheus.doc} TMF68MNU()
 
PE permite alterar o array utilizado para montagem do menu da Viagem Modelo 3.
 
@author User: Jonathan
@since 09/12/2024
@version 1.0
/*/
//--------------------------------------------------------------------
 
User Function TMF68MNU()
 
Local aRet  := PARAMIXB[1]
  
ADD OPTION aRet TITLE "Integrar AutoTrac" ACTION "u_ELOBJP01(1)"   OPERATION  2 ACCESS 0   //-- "TESTE"
ADD OPTION aRet TITLE "Fechar Viagem"     ACTION "u_ELViagens(1)"  OPERATION  3 ACCESS 0   //-- "TESTE"
ADD OPTION aRet TITLE "Estornar Viagem"   ACTION "u_ELViagens(2)"  OPERATION  4 ACCESS 0   //-- "TESTE"
ADD OPTION aRet TITLE "Informar Abastecimento" ACTION "u_EDTMSE03()"   OPERATION  3 ACCESS 0   //-- "TESTE"
ADD OPTION aRet TITLE "Invoice Mod. 01" ACTION "u_EDTMSR01()"   OPERATION  2 ACCESS 0   //-- "TESTE"
ADD OPTION aRet TITLE "Imp. carga e descarga"   ACTION "u_EDCTCR01(DTQ->DTQ_VIAGEM)"  OPERATION  4 ACCESS 0   //-- "TESTE"

Return aRet
 
User Function ELViagens(nOpc)
	Private cFiltro    := ''
	Private bFiltraBrw
	Private cSerTms    := '3'   //cServico // Tipo do Servico
	Private cTipTra    := '3'   //cTransp  // Tipo do Transporte
	Private lLocaliz   := SuperGetMv("MV_LOCALIZ",.F.,"") == 'S'
	Private aIndex     := {}
	
	oBrw144	 	:= nil 

	If nOpc == 1
		TMSA144Sub(5, 3)
	Else
		TMSA144Sub(5, 5)
	Endif

	// integrar encerramento da viagem ou estorno do encerramento.
	U_ELOBJP01(3)
	
Return
