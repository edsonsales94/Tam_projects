#INCLUDE "PROTHEUS.CH"

User Function AAFATE02()

Local lRet  := .T.
Local cVar  := Readvar()
Local nPosD := aScan(aHeader,{|x| x[02] == "C6_DESCONT"})
Local nPosW := aScan(aHeader,{|x| x[02] == "C6_VALDESC"})
Local lDescont := .T.


If cVar="M->C5_PDESCAB"
   aEval(aCols,{|x| lDescont := lDescont .And. x[nPosD] =0})
   If (M->C5_DESCONT != 0 .Or. !lDescont) .And. M->C5_PDESCAB != 0
      Aviso("Atencao","Desconto ja Efetuado no Campo 'Desconto %'  Ou Nos items, Nao Permitido Novo Desconto",{'OK'})
      lRet := .F.
   EndIf   
elseif cVar="M->C5_DESCONT"
   aEval(aCols,{|x| lDescont := lDescont .And. x[nPosD] =0})
   If (M->C5_PDESCAB != 0 .Or. !lDescont) .And. M->C5_DESCONT != 0
      Aviso("Atencao","Desconto ja Efetuado no Campo 'Desconto R$'  Ou Nos items, Nao Permitido Novo Desconto",{'OK'})
      lRet := .F.
   EndIf   
elseif cVar="M->C6_DESCONT" .Or. cVar="M->C6_VALDESC"
  If (M->C5_PDESCAB != 0 .Or. M->C5_DESCONT != 0 ) .And. (aCols[n,nPosD] != 0 .Or. aCols[n,nPosW] != 0 )
      Aviso("Atencao","Desconto ja Efetuado no Cabeçalho do Pedido, Nao Permitido Desconto nos Itens",{'OK'})
      lRet := .F.
   EndIf
EndIf

Return lRet


User Function AA410VLR()
   Local xPQt   := aScan(aHeader, {|x| Alltrim(x[02]) == 'C6_VALOR' } )
   Local nI     := 0
   Local xVar   := 0
   Local nValue := 0
   
  	For nI := 01 To Len(aCols)
			nValue += aCols[nI][xPQt]
	Next	  

   xVar := round(M->C5_XENTRAD*100/nValue,2)
   M->C5_DESCFI := xVar
   
Return xVar



/*powered by DXRCOVRB*/
