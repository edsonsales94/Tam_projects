#include "Protheus.ch"

User Function MA920MNU()
Local aBotao := {}

If ExistBlock("AAFATE04")
   AAdd( aRotina, {'Cred. Restituicao','U_AAFATE04' , 0 , 2,0,NIL} )
EndIf

Return aRotina