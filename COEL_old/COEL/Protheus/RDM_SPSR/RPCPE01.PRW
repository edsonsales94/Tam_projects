#include "rwmake.ch"

User Function RPCPE01()


SetPrvt("_AAREA,_CROT,_CTM,CLOCAL1,_CRET,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA250  ³ Autor ³ Rogerio Batista       ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para alertar se o almoxarifado esta correto,      ³±±
±±³          ³ quando a filial for Sao Roque deve ser "01"                ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EXECBLOCK nos campos D3_LOCAL                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_aArea := GetArea()

_cRot    := AllTrim(FunName())  
_cRet    := M->D3_LOCAL
                         

If SM0->M0_CODFIL=="02"// Somente na filial Sao Roque
	
	If (_cRot $ "MATA240/MATA250/MATA241") //Internos e Producao
		_cLocal1 := M->D3_LOCAL
		
		If (_cLocal1 $ "01/02/03")
			_cRet := _cLocal1
		Else
			MSgBOX("ATENCAO, ESTE ALMOXARIFADO NAO EXISTE")
			_cRet := " "
		EndIf
		
	ElseIf _cRot == "MATA103" // Nota Fiscal de Entrada
		_cLocal1 := M->D1_LOCAL
		
		If (_cLocal1 $ "01/02/03")
			_cRet := _cLocal1
		Else
			MSgBOX("ATENCAO, ESTE ALMOXARIFADO NAO EXISTE")
			_cRet := " "
		EndIf
		
	EndIf
//Else
//	RestArea(_aArea)
//	_cLocal1 := M->D3_LOCAL
//    Return(_cRet)
EndIf

RestArea(_aArea)

Return(_cRet)

