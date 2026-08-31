#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CNAB
//TODO Descrição auto-gerada.
@author FOliveira
@since 15/08/2018
@version undefined
@param _cBco, CARACTER, Código do Banco
@param _cExec, CARACTER, Função à ser executada
@param _aParam, ARRAY, Array opcional com os parâmetros para execução das rotinas
@return xRet, Retorno qualquer, depende da função executada
@example
(examples)
@see (links_or_references)
/*/

User Function CNAB(_cBco, _cExec, _aParam)
	Local _cRet		:= ""
	Local _aArea	:= GetArea()

	DEFAULT _aParam	:= {}

	If _cBco == "237"
		_cRet := fProc237(_cExec, _aParam)
	ElseIf _cBco == "756"
		_cRet := fProc756(_cExec, _aParam)
	EndIF

	RestArea(_aArea)
Return(_cRet)

//||==================================================================||
//|| Função para executar os Procedimento para o Banco 237 - Bradesco ||
//||==================================================================||
Static Function fProc237(_cExec, _aParam)
	Local _cRet	:= ""

	If _cExec == "VLR_DESC" //Retorna o Valor do Desconto
		_cRet := StrZero( (IIF(SE1->E1_DESCFIN > 0, NoRound( ((SE1->E1_SALDO + SE1->E1_ACRESC) - SE1->E1_DECRESC) * (SE1->E1_DESCFIN / 100), 02 ), 0 ) * 100), 13 )
	ElseIf _cExec == "VLR_TITULO" //Retorna o Valor do Título enviado ao Banco
		_cRet := StrZero( (((SE1->E1_SALDO + SE1->E1_ACRESC) - SE1->E1_DECRESC) * 100), 13 )
	ElseIF _cExec == "VLR_JUROS" //Retorno o Valor por dia de Atraso para cobrança de Juros
		_cRet := StrZero( ((((SE1->E1_SALDO + SE1->E1_ACRESC) - SE1->E1_DECRESC) * (GetMv("MV_TXPER")/100))*100), 13 )	
	EndIF

Return(_cRet)

//||==================================================================||
//|| Função para executar os Procedimento para o Banco 756 - SICOOB   ||
//||==================================================================||
Static Function fProc756(_cExec, _aParam)
	Local _cRet	:= ""
	local _nPar := val(SE1->E1_PARCELA)
	If _cExec == "PARCELA" //Retorna a Parcela
		//Devido situação do Próprio Banco SICOOB, o mesmo não aceita o campo parcela
		//em branco e para as vendas à vista do Protheus não está sendo gravado a informação
		//do Número da Parcela. Dessa forma será preenchido automaticamente o campo Parcela com
		//'01' quando este estiver em braco.
		_cRet := StrZero(Val(IIF(EMPTY(SE1->E1_PARCELA),"01",_nPar)),2)
	EndIF

Return(_cRet)