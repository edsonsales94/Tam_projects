#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ AACTBE01 º Autor ³ Wagner Correa      ³ Data ³  03/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Escolhe conta a partir do cadastro do Centro de Custos.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Amazon Aco                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AACTBE01
_cArea := GetArea()

_cConta := Space(20)

dbSelectArea("CTT")
dbSetOrder(1)
dbSeek(xFilial()+SE2->E2_CCD)

Do Case
	Case CTT->CTT_XTPOCC = "0"
		_cConta := SED->ED_CONTA
	Case CTT->CTT_XTPOCC = "1" 
		_cConta := SED->ED_XCTADM
	Case CTT->CTT_XTPOCC = "2"
		_cConta := SED->ED_XCTCOM
	Case CTT->CTT_XTPOCC = "3"
		_cConta := SED->ED_XCTFAB
EndCase

RestArea(_cArea)
Return _cConta