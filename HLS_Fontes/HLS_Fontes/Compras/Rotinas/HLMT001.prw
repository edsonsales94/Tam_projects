#include "protheus.ch"

//{protheus.doc} hlmt001
//Gatilho executado no Código do Grupo de Fornecedor retorna o próximo Código do Fornecedor
//@author Felipe Pieroni
//@since 19/06/08

User Function HLMT001()

Private _aArea := GetArea()
Private _cGrupo  := AllTrim(M->A2_GF) 
Private _cCodNew := _cGrupo+"0001"

DbSelectArea("SA2")
DbSetOrder(1)  
DbSeek(xFilial("SA2")+_cCodNew,.F.)
Do While Substr(SA2->A2_COD,1,2) == (_cGrupo) .And. SA2->(!Eof())

	_cCodNew := Substr(SA2->A2_COD,1,2)+Soma1(SubStr(SA2->A2_COD,3,4))

	DbSelectArea("SA2")
	DbSkip()

EndDo

RestArea(_aArea)
Return(_cCodNew)