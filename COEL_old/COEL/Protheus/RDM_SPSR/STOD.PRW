#include "rwmake.ch"

User Function STOD(_xDATA,_cForm)
//****************************************************************************
//** FUNCAO  : STOD                                         ** Data : 30/10/03
//****************************************************************************
//** Descricao : Funcao que converte e retorna a data do formato Sting para Data ou TXT
//****************************************************************************

SetPrvt("_xDATA,_cForm") 
_cRet 	:= _xDATA  
_cDia	:= Substr(_xDATA,7,2)
_cMes	:= Substr(_xDATA,5,2)
_cAno	:= Substr(_xDATA,3,2)
_cAno4  := Substr(_xDATA,1,4)
Do Case
	Case _cForm = "D"
		_cRet := CTOD(_cDia+"/"+_cMes+"/"+_cAno)
	Case _cForm = "C"
		_cRet := _cDia+"/"+_cMes+"/"+_cAno
	Case _cForm = "C4"
		_cRet := _cDia+"/"+_cMes+"/"+_cAno4
EndCase				
Return(_cRet)

