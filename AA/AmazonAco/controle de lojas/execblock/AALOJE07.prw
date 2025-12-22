#include "Protheus.ch"

User Function AALOJE07(_nLin)
  Local aPos := {}
  Local _cTes := ""
  
  aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_PRODUTO"}) ) 
  aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_ENTBRAS"}) ) 
  aAdd(aPos, Ascan(aPosCpoDet	,{|x|Alltrim(x[1]) == "LR_TES" }) )
  aAdd(aPos, Ascan(aPosCpoDet	,{|x|Alltrim(x[1]) == "LR_CF"  }) )  
  
  SA1->(dbSetOrder(1))
  SA1->(dbSeek(xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA))
  
  SB1->(dbSetORder(1))
  SB1->(dbSeek(xFilial('SB1') + aCols[n][aPos[01]] ))

  //If(ExistBlock('AALOJE07'),  aColsDet[n][Ascan(aPosCpoDet,{|x| trim(x[1])="LR_TES"})]:=u_AALOJE07(),'')
  
  If M->LQ_ENTREGA = 'S' .And. Alltrim(SA1->A1_GRPTRIB) = '005' .And. Alltrim(SB1->B1_GRTRIB) = '001' .And. Alltrim(aCols[n][aPos[02]]) $ "00/01"   
     SF4->(dbSetORder(1))          
     lContinua := SF4->(dbSeek(xFilial('SF4') + SuperGetMv("MV_XTESST",.F.,aColsDet[n][aPos[03]]) ))
  else 
     _ctes := Iif(Empty(SB1->B1_TS),GetMv("MV_TESSAI"),SB1->B1_TS)
     SF4->(dbSetORder(1))     
     lContinua := SF4->(dbSeek(xFilial('SF4') + _cTes ))       
  Endif
  If lContinua
    aColsDet[n][aPos[03]] := SF4->F4_CODIGO
    M->LR_TES := SF4->F4_CODIGO
    
    nPosVlItem		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VLRITEM"})][2]
    nVlrItem := If( MaFisFound("IT",n), MaFisRet( n, "IT_TOTAL" ), aCols[n][nPosVlItem] )    
    MaFisAlt("IT_TES", SF4->F4_CODIGO, n)
    aColsDet[n][aScan(aHeaderDet,{ |ExpA1| AllTrim( ExpA1[2] ) == "LR_CF" })] := MaFisRet(n, "IT_CF")

    nVlrTotal := LJ7T_Subtotal(2) - nVlrItem + If( MaFisFound("IT",n), MaFisRet( n, "IT_TOTAL" ), aCols[n][nPosVlItem] )
    Lj7T_Subtotal	( 2, nVlrTotal )
	Lj7T_Total		( 2, LJ7T_SubTotal(2) - Lj7T_DescV(2) )
  EndIf
Return .T.


User Function AALOJE7A()
  Local lret        := .F.
  Local aPos        := {}
  Local cVar        := ReadVar()
  Local _nPos       := Ascan(aPosCpoDet	,{|x|Alltrim(x[01]) == "LR_TES" }) 
  Local nPosProd    := aScan(aHeader,{|x| Alltrim(x[02])=="LR_PRODUTO"})
  Local nPosQuant   := Ascan(aHeader,{|x| AllTrim(Upper(x[2])) == "LR_QUANT"})			// Posicao da Quantidade
  Local nPosVlUnit	:= Ascan(aHeader,{|x| AllTrim(Upper(x[2])) == "LR_VRUNIT"})			// Posicao do Valor unitario do item
  Local nPosVlItem	:= Ascan(aHeader,{|x| AllTrim(Upper(x[2])) == "LR_VLRITEM"}) 			// Posicao do Valor do item
  Local nPosValDesc	:= Ascan(aHeader,{|x| AllTrim(Upper(x[2])) == "LR_VALDESC"})			// Posicao do valor de desconto
  
  If Len(aCols) == 1 .And. Len(Alltrim(aCols[1,nPosProd])) = 0
     Return .T.
  EndIf
    
  If cVar $ "M->LQ_CLIENTE/M->LQ_LOJA"
     If MaFisFound("NF")
		  MaFisEnd()
	  EndIf
	  
     If !MaFisFound("NF")
         MaFisIni( M->LQ_CLIENTE, M->LQ_LOJA, "C" , "S" , ;
		          NIL          , NIL        , NIL , .F., ;
		          "SB1"        , "LOJA701"  )
         For n := 1 to Len(aCols)         
		   MaFisAdd( aCols[n][nPosProd],;			// Produto
				aColsDet[n][_nPos],;					// Tes
				aCols[n][nPosQuant],;		// Quantidade
				aCols[n][nPosVlUnit],;		// Preco unitario
				aCols[n][nPosValDesc],;		// Valor do desconto
				"",; 						// Numero da NF original
				"",; 						// Serie da NF original
				0,;							// Recno da NF original
				0,; 						// Valor do frete do item
				0,; 						// Valor da despesa do item
				0,; 						// Valor do seguro do item
				0,; 					   // Valor do frete autonomo
				aCols[n][nPosVlItem] + IIf(cPaisLoc == "BRA", aCols[n][nPosValDesc], 0),;		// Valor da mercadoria
				0 )							// Valor da embalagem
				
			nPosVlItem		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VLRITEM"})][2]
            nVlrItem := If( MaFisFound("IT",n), MaFisRet( n, "IT_TOTAL" ), aCols[n][nPosVlItem] )    
			aColsDet[n][aScan(aHeaderDet,{ |ExpA1| AllTrim( ExpA1[2] ) == "LR_CF" })] := MaFisRet(n, "IT_CF")
            nVlrTotal := LJ7T_Subtotal(2) - nVlrItem + If( MaFisFound("IT",n), MaFisRet( n, "IT_TOTAL" ), aCols[n][nPosVlItem] )
            Lj7T_Subtotal	( 2, nVlrTotal )
	        Lj7T_Total		( 2, LJ7T_SubTotal(2) - Lj7T_DescV(2) )
		   Next
		   
	    EndIf	
  EndIf
  
  For nI := 1 To Len(aCols)
      n:=nI
      u_GetSZG(n,1)
      If lRet := u_AALOJE07()
      else
        nI := len(aCols) + 1
      EndIf
  Next
  
Return lRet

User Function AALOJE7B()

  Local aPos := {}
  Local _cTes := ""
  Local lRet := .T.
  
  aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_PRODUTO"}) ) 
  aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_ENTBRAS"}) ) 
  aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_QUANT"}) )
  aAdd(aPos, Ascan(aPosCpoDet	,{|x|Alltrim(x[1]) == "LR_TES" }) )
  aAdd(aPos, Ascan(aPosCpoDet	,{|x|Alltrim(x[1]) == "LR_CF"  }) )
  
  
  aColsDet[n][aPos[03]] := ConvUm( aColsDet[n][aPos[01]], aColsDet[n][aPos[03]] ,aColsDet[n][aPos[02]],1 )
  M->LR_QUANT := aColsDet[n][aPos[03]]
  Lj7detalhe()
  LJ7Prod(.T.)
Return lRet

User Function AALOJE7C()
Return Posicione('SA1',1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_GRPTRIB") != '005'//M->LQ_CLIENTE == GetMv('MV_CLIPAD') .Or. Empty(M->LQ_CLIENTE) .Or.  Empty(M->LQ_LOJA) .Or. !SA1->(dbSeek(xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA ))