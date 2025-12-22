#include "rwmake.ch"

//************************************************************************************
//** Funcao : M410LIOK    ** Autor : Rogerio Oliveira            ** Data : 02/05/2019
//************************************************************************************
//** Descricao : PONTO DE ENTRADA para gravacao de ZX1 - Log de pedidos
//************************************************************************************


/*
User Function m410agrv()    
///
SetPrvt("_lRet")
_nPedido	:= M->C5_NUM
_nCliente   := M->C5_CLIENTE
_nLoja  	:= M->C5_LOJACLI


_nPosNum	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_NUM"})    // Pedido
_nPosItem	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEM"})]   // Item
_nPosPrd	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO"})] // Produto
_nPosDtNew	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ENTREG"})]  // Data Entrega
_nPosDtold	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_X_DT2"})]   // Data Antiga
_nPosEmis 	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_X_EMIS"})]  // Emissao do item  
_nQuant     := aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_QTDVEN"})]  // Quantidade
//_nPosClient	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_CLI"})]     // Cliente
//_nPosLoja 	:= aCols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_LOJA"})]    // Loja
              

///   _cTES  := aCols[n,aScan(aHeader,{|x| upper(alltrim(x[2]))=="C6_TES"})]                                     

	    	dbSelectArea( "ZX1" )
			RecLock("ZX1",.T.)
			ZX1_FILIAL := xFilial("SC6")
			ZX1_PEDIDO := _nPedido
			ZX1_ITEM   := _nPosItem
			ZX1_PRODUT := _nPosPrd
			ZX1_DTNEW  := _nPosDtNew
			ZX1_DTOLD  := _nPosDtold//stod(_nPosDtold)
			ZX1_HORA   := Time()
        	ZX1_DTBASE := dDatabase
			ZX1_USUARI := SUBST(CUSUARIO,7,15)
			ZX1_ORIGEM := "INCLUSAO"
			ZX1_EMISSA := _nPosEmis//stod(_nPosEmis)
			ZX1_CLIENT := _nCliente
			ZX1_LOJA   := _nLoja  
			ZX1_QUANT  := _nQuant
			MsUnLock()
			
///
Return(.T.)
*/
   
User Function M410AGRV()

Local  c_Alias := ALIAS()
Local  aItens  := {}
Local  xOrdProd :=""
Local cCodUser  :=retcodusr()
_nPedido	:= M->C5_NUM

//If SC5->C5_TIPO =="N" 
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+_nPedido)
		DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==SC5->C5_NUM
		
	
			dbSelectArea( "ZX1" )
			RecLock("ZX1",.T.)
			ZX1_FILIAL := xFilial("SC6")
			ZX1_PEDIDO := SC6->C6_NUM
			ZX1_ITEM   := SC6->C6_ITEM
			ZX1_PRODUT := SC6->C6_PRODUTO
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
			dbSkip()
		
		ENDDO
	Endif	
	////
	////Envia e-mail p/o responsavel da liberacao da regra
	////
	
//Endif		
dbSelectArea(c_Alias)

Return
                                     
//Return(_nRet)