#include "protheus.ch"
#include "msobject.ch"
/*/{protheus.doc}SCxSSize
Classe para a manipulacao de coordenadas de acordo com a resolucao de cada terminal
@author Matheus Nogueira
@since 11/08/2008
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³SCxSSize  ºAutor  ³Matheus Nogueira    º Data ³  11/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Classe para a manipulacao de coordenadas de acordo com a    º±±
±±º          ³resolucao de cada terminal.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto   ³ - Siga Campinas -                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Class SCxSSize

	Data aSSize		as Array
	Data nColunas	as Integer
	Data nBorda		as Integer
	Data nPercent	as Integer
	Data nHDialog	as Integer
	Data nVDialog	as Integer
	Data nHorSize	as Integer
	Data nVerSize	as Integer
	Data nHorMax	as Integer
	Data nVerMax	as Integer

	Method New(nParPercent, nParBorda, nParColunas) Constructor
	Method GetCDialog(nParCol, nParLin)
	Method GetCEnchoice(nParCol, nParLin)
	Method GetCGetDados(nParCol, nParLin)
	Method GetCListBox(nParCol, nParLin)
	Method GetCAllClient()

    && Metodos Especias para controle de tela cheia
	Method GetCWindow(nParLin, nParCol)
	Method GetCWLisBox(nParLin, nParCol)	
	Method GetCWGetDados(nParLin, nParCol)
	
EndClass


****************************************************************************************************************************************************
&& Metodo Construtor
****************************************************************************************************************************************************
Method New(nParPercent,nParBorda,nParColunas) Class SCxSSize

	::nPercent	:= iif(Valtype(nParPercent) == "U", 	100, nParPercent)
	::nColunas	:= iif(Valtype(nParColunas) == "U", 	1, nParColunas)
	::nBorda	:= iif(Valtype(nParBorda) == "U", 		5, nParBorda)
	&& Captura as informacoes de resolucao do monitor
	//::aSSize 	:= {0,12,634,304,1268,626,17} //1280x800
	//::aSSize 	:= {0,12,506,271,1012,560,17} //1024x768
	::aSSize 	:= MSAdvSize()

	::nHorSize	:= Round( (((::aSSize[5]/2) / 100) * ::nPercent) ,0)     //3
	::nVerSize	:= Round( (((::aSSize[6]/2) / 100) * ::nPercent) ,0)     //4
	::nHDialog	:= ::nHorSize * 2
	::nVDialog	:= ::nVerSize * 2
	::nHorMax	:= ::aSSize[5] + 8
	::nVerMax	:= ::aSSize[6] + 8 
			
Return .T.


****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas do Dialogo
****************************************************************************************************************************************************
Method GetCAllClient() Class SCxSSize

Local aRet := {::aSSize[7], 0, ::aSSize[6], ::aSSize[5] }
	
Return aRet


****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas do Dialogo
****************************************************************************************************************************************************
Method GetCDialog(nParLin, nParCol) Class SCxSSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= ::nVDialog + nParLin
Local nSizeH	:= ::nHDialog + nParCol
Local aRet := {nParLin, nParCol, nSizeV, nSizeH }
	
Return aRet


&& *********************************************************************************************************************************************************************
&& Metodo para retorno de coodenadas da Enchoice
Method GetCEnchoice(nParLin, nParCol) Class SCxSSize

Local nParLin	:= Round(  iif(Valtype(nParLin) == "U", 	::nBorda, nParLin)  ,0)
Local nParCol	:= Round(  iif(Valtype(nParCol) == "U", 	::nBorda, nParCol)  ,0)
Local nSizeV	:= ::nVerSize - ::nBorda
Local nSizeH	:= ::nHorSize - ::nBorda
Local aRet		:= {nParLin, nParCol , nSizeV, nSizeH }

Return aRet
                                     

****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas da GetDados
****************************************************************************************************************************************************
Method GetCGetDados(nParLin, nParCol) Class SCxSSize

Local nParLin	:= Round(  iif(Valtype(nParLin) == "U", 	::nBorda, nParLin)  ,0)
Local nParCol	:= Round(  iif(Valtype(nParCol) == "U", 	::nBorda, nParCol)  ,0)
Local nSizeV	:= ::nVerSize - ::nBorda
Local nSizeH	:= ::nHorSize - ::nBorda
Local aRet		:= {nParLin, nParCol , nSizeV, nSizeH }

Return aRet


****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas da GetDados
****************************************************************************************************************************************************
Method GetCListBox(nParLin, nParCol) Class SCxSSize

Local nParLin	:= Round(  iif(Valtype(nParLin) == "U", 	::nBorda, nParLin)  ,0)
Local nParCol	:= Round(  iif(Valtype(nParCol) == "U", 	::nBorda, nParCol)  ,0)
Local nSizeV	:= ::nVerSize - (::nBorda * 2) - iif(nParLin > ::nBorda, nParLin - ::nBorda,0)
Local nSizeH	:= ::nHorSize - (::nBorda * 2) - iif(nParCol > ::nBorda, nParCol - ::nBorda,0)
Local aRet		:= {nParLin, nParCol, nSizeH, nSizeV }

Return aRet


****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas de Janela Total
****************************************************************************************************************************************************
Method GetCWindow(nParLin, nParCol) Class SCxSSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= ::nVerMax + if( nParLin > 0, 0, nParLin)+ 4
Local nSizeH	:= ::nHorMax + if( nParCol > 0, 0, nParCol)
Local aRet := {nParLin, nParCol, nSizeV, nSizeH }

Return aRet


****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas de Janela Total
****************************************************************************************************************************************************
Method GetCWLisBox(nParLin, nParCol) Class SCxSSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= Round((((::nVerMax + if( nParLin > 0, 0, nParLin) ) / 2 ) - nParLin) - ::nBorda + 2, 0 )
Local nSizeH	:= Round((((::nHorMax + if( nParCol > 0, 0, nParCol) ) / 2 ) - nParCol) - ::nBorda, 0 )
Local aRet := {nParLin, nParCol, nSizeH, nSizeV }
	
Return aRet


****************************************************************************************************************************************************
&& Metodo para retorno de coodenadas de Janela Total
****************************************************************************************************************************************************
Method GetCWGetDados(nParLin, nParCol) Class SCxSSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= ::nVerSize - ::nBorda
Local nSizeH	:= ::nHorSize - ::nBorda
Local aRet := {nParLin, nParCol, nSizeV, nSizeH }
	
Return aRet


****************************************************************************************************************************************************
&& Fim da rotina
****************************************************************************************************************************************************
