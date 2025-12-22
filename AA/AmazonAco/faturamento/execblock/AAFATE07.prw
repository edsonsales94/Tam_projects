#INCLUDE "RWMAKE.CH"

User Function AAFATE07()
	Local lRet    := .T.
	Local _ndPosL := aScan(aHeader,{|x| AllTrim(x[02]) == "C6_QTDLIB" }) // Quantidade a liberar
	Local _ndPosV := aScan(aHeader,{|x| AllTrim(x[02]) == "C6_QTDVEN" }) // Quantidade vendida
	Local _ndPosS := aScan(aHeader,{|x| AllTrim(x[02]) == "C6_SLDALIB"}) // Quantidade ja liberada             
	Local _ndPosI := aScan(aHeader,{|x| AllTrim(x[02]) == "C6_ITEM"   }) // Item do pedido                     
	Local _ndPosP := aScan(aHeader,{|x| AllTrim(x[02]) == "C6_PRODUTO"}) // Código do Produto                  	
	Local cCampo  := readvar()   
   Local cArea   := GetArea()

	SC6->( dbSetOrder(1) ) 
	SC6->( dbSeek(xFilial("SC6")+M->C5_NUM+aCols[n][_ndPosI]+aCols[n][_ndPosP]) )
   
	// Não valida caso esteja na venda assistida ou não seja um pedido de venda com reserva
	If Trim(FunName()) <> "LOJA701"
		//If Empty(M->C5_XORCRES)
			_nQtdALib := ( ( aCols[n][_ndPosV] - SC6->C6_QTDENT )  * GetMv("MV_XPERLIB") / 100)  + ( aCols[n][_ndPosV] - SC6->C6_QTDENT ) 
			
			If cCampo == "M->C6_QTDLIB" .And. &cCampo >  _nQtdALib 
				Aviso('Atencao','Não é Possivel liberar quantidade acima de '+AllTrim(Str( GetMv("MV_XPERLIB") ))+'%',{'OK'},2)
				lRet := .F.
			EndIf
			//alert('sortudo')
			If !Empty(SC5->C5_ORCRES) 
			//alert (&cCampo)
			    If _ndPosS > 0
					If &cCampo > aCols[n][_ndPosS]//aCols[n][_ndPosV] - M->C6_QTDENT //cCampo == "M->C6_QTDLIB" .And. &cCampo >  00   
						Aviso('Atencao','Não e Possivel altera a Quantidade de Pedidos com Reserva',{'OK'},2)
						lRet := .F.
					EndIf
				EndIf
			EndIF
			
		/*ElseIf cCampo == "M->C6_QTDLIB" .And. &cCampo >  aCols[n][_ndPosV]
			Alert("Quantidade não pode ser maior que a quantidade do pedido !")
			lRet := .F.
		Endif*/
	Endif                    
	
	
	RestArea(cArea)
	
Return lRet