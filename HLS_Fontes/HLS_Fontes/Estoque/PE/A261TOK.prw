#include 'Protheus.ch'

/*/{protheus.doc}a261tok
Valida A Movimentação no Aramzen 91 / 02 / 90
@author Honda Lock
/*/
User Function A261TOK()

Local lRet        := .T.
Local _MV_XUSUTRA := GetMv("MV_XUSUTRA")
Local nI          := 0

Private cCodOrig  := ''
Private cCodDest  := ''
Private cLocOrig  := ''
Private cLocDest  := ''

For nI := 1 to Len(aCols)
	
	cCodOrig   := aCols[nI,1]
	cCodDest  := aCols[nI,6]
	cLocOrig   := aCols[nI,4]
	cLocDest  := aCols[nI,9]
	
	If !Empty(cCodOrig) .And. !Empty(cCodDest) .And.  cCodOrig <> cCodDest
		
		
		
		If lRet .And. !( __cUserId $ _MV_XUSUTRA )
			
			Alert("Usuário sem permissão para realizar transferencias entre Produtos diferentes!")
			lRet := .F.
			
		EndIf
		
		
		
	EndIf
	
	iF !lRet
		nI := Len(aCols) + 1
	EndIf
	
Next

Return lRet
