#Include "rwmake.ch"

User Function VServico(nTam)

Local nProduto
Local nColUm
Local cdFuncao := FunName()

If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
   nProduto 		:= AScan( aHeader , {|x| Trim(x[2]) == "LR_PRODUTO" })   
   nColUm        := AScan( aHeader , {|x| Trim(x[2]) == "LR_UM" })
else
   nProduto 		:= AScan( aHeader , {|x| Trim(x[2]) == "C6_PRODUTO" })   
   nColUm        := AScan( aHeader , {|x| Trim(x[2]) == "C6_UM" })
EndIf
nTamanho := Len(Acols)

If nTamanho > 1
   
   If Acols[nTam][nColUM] == "SV"

      If Acols[nTam-1][nColUM] <> "SV"
         MsgAlert("Para Serviço deve ser feito um orçamento separado","ATENÇÃO")
         Acols[nTam][ Len(Acols[nTam]) ] := .T.
         Acols[nTam][nProduto] := Space(15)
      Endif
   
   Else
   
     If Acols[nTam-1][nColUM] == "SV"    
	     MsgAlert("Para Serviço deve ser feito um orçamento separado","ATENÇÃO")
         Acols[nTam][ Len(Acols[nTam]) ] := .T.
         Acols[nTam][nProduto] := Space(15)
     EndIf
   
   EndIf

EndIf     
   
cProduto := Acols[nTam][nProduto]
   
Return(cProduto)