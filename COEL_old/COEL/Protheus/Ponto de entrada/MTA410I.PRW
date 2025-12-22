#include "rwmake.ch"

//************************************************************************************
//** Funcao : MTA410I    ** Autor : Rogerio Oliveira            ** Data : 04/09/2019
//************************************************************************************
//** Descricao : PONTO DE ENTRADA para gravacao de ZX1 - Log de pedidos - INCLUSAO
//************************************************************************************

 
User Function MTA410I()

Local  c_Alias := ALIAS()
Local  aItens  := {}
Local  xOrdProd :=""
Local cCodUser  :=retcodusr()

If SC5->C5_TIPO =="N" 

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SC5->C5_NUM)
		DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.SC6->C6_NUM==SC5->C5_NUM
		 
	        dbSelectArea( "ZX1" )    
	        dbSetOrder(1)
	        If !dbSeek(xFilial("ZX1")+SC6->C6_NUM+SC6->C6_ITEM)
			RecLock("ZX1",.T.)
			 ZX1_FILIAL := xFilial("SC6")
			 ZX1_PEDIDO := SC6->C6_NUM
			 ZX1_PRODUT := SC6->C6_PRODUTO 
			 ZX1_ITEM   := SC6->C6_ITEM
			 ZX1_DTNEW  := SC6->C6_ENTREG
			 ZX1_DTOLD  := SC6->C6_X_DT2
			 ZX1_HORA   := Time()
        	 ZX1_DTBASE := dDatabase
			 ZX1_USUARI := SUBST(CUSUARIO,7,15)
			 ZX1_ORIGEM := "INCLUSAO"
			 ZX1_EMISSA := SC6->C6_X_EMIS
			 ZX1_CLIENT := SC6->C6_CLI
			 ZX1_LOJA   := SC6->C6_LOJA  
			 ZX1_QUANT  := SC6->C6_QTDVEN
			MsUnLock()
            EndIf

		    dbSelectArea("SC6")
			dbSkip()
			
		ENDDO
	Endif	

Endif		
dbSelectArea(c_Alias)

Return