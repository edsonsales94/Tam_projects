#INCLUDE "rwmake.ch"
#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"

User Function FOR_PRECOS()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função chamada pelo Menu de Compras
OBJETIVO 1: Chamada da Função que forma o Preço de Venda;
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
aItems := {}
Private oTipo       := NIL
Private _cTipo      := Space(30)
Private oDlg     	:= Nil

Define Font oFnt3 Name "Ms Sans Serif" Bold

DEFINE MSDIALOG oDlg TITLE "Formacão de Preços" From 10,40 To 20,70 //OF oMainWnd

AADD(aItems,"Nota Fiscal"); AADD(aItems,"Produto")

@ 020,05 Say "Tipo : "  Size 35,8 Of oDlg Pixel Font oFnt3
@ 020,25 MSCOMBOBOX oTipo VAR _cTipo ITEMS aItems SIZE 70,40 OF  oDlg PIXEL

@ 050,042 BmpButton Type 1 Action Valida()

Activate Dialog oDlg Centered

Return


Static Function Valida()

oDlg:End()
If Alltrim(_cTipo) == "Nota Fiscal"
	U_FPrec("M") //Chamada da função para formação de preço por NOTA FISCAL DE ENTRADA- MANUALMENTE
Else
	U_FPrec("P") //Chamada da função para formação de preço por PRODUTO - MANUALMENTE
Endif

Return()	
