#include "Protheus.ch"

/*
Autor     : Marcel Robinson Grosselli
Rotina    : AAFINE02
Descricao : Rotina para Retorno dos dados do Endereco do Cliente 
*/

user function AAFINE02(_cTipo)
Local   _cReturn := ''
Default _cTipo   := ''


If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
	If _cTipo == '1'
		_cReturn := AllTrim(SA1->A1_END )
	elseif _cTipo == '2'
		_cReturn := AllTrim(SA1->A1_MUN )
	elseif _cTipo == '3'
		_cReturn := SA1->A1_EST
	elseif _cTipo == '4'
		_cReturn := SA1->A1_CEP
	elseif _cTipo == '5'
		_cReturn := SA1->A1_CGC
	elseif _cTipo == '6'
		_cReturn := AllTrim(SA1->A1_BAIRRO)
	EndIf
Else
	If _cTipo == '1'
		_cReturn := AllTrim(SA1->A1_ENDCOB )
	elseif _cTipo == '2'
		_cReturn := AllTrim(SA1->A1_MUNC )
	elseif _cTipo == '3'
		_cReturn := SA1->A1_ESTC
	elseif _cTipo == '4'
		_cReturn := SA1->A1_CEPC
	elseif _cTipo == '5'
		_cReturn := SA1->A1_CGCC
	elseif _cTipo == '6'
		_cReturn := AllTrim(SA1->A1_BAIRROC)
	EndIf
EndIf

Return _cReturn