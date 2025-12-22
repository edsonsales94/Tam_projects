#include "Protheus.ch"
#include "rwMake.ch"

User Function AALOGE02(aDadoPed)
        
/*    Local nPosPed := aScan(aDadoPed,{|x| x[01] == "Z5_PEDIDO"  })
    Local nPosItem:= aScan(aDadoPed,{|x| x[01] == "Z5_ITEM"    })
    Local nPosPrd := aScan(aDadoPed,{|x| x[01] == "Z5_PRODUTO" })
    Local nPosSt  := aScan(aDadoPed,{|x| x[01] == "Z5_STATUS" })
    Local nPosFil := aScan(aDadoPed,{|x| x[01] == "Z5_FILIAL" })
    
    Default aDadoPed := {}
                 
    If Len(aDadoPed)> 0
        
        If nPosItem = 0
           aAdd(aDadoPed,{"Z5_ITEM",getNextIt(aDadoPed[nPosPed][02]  , aDadoPed[nPosPrd][02]  ) } )
           nPosItem := len(aDadoPed)
        EndIF
        iF nPosFil = 0
           aAdd(aDadoPed,{"Z5_FILIAL",xFilial('SZ5')})
        EndIf
        
        IF nPosSt!= 0 .And. SC5->(FieldPos("C5_XSTATUS")) > 0        
              SC5->(dbSetOrder(1))
           If SC5->(dBSeek( xFilial('SC5') + aDadoPed[01][nPosPed] ))
              SC5->C5_XSTATUS := aDadoPed[01][nPosSt]
           EndIf
        elseif SC5->(FieldPos("C5_XSTATUS")) <= 0
           CONOUT('ERRO : CAMPO C5_XTATUS Nao Criado BASE DE DADOS')
        EndIf
        
	    SZ5->(dbSetOrder(1))
	    SZ5->( RecLock('SZ5', !SZ5->(dbSeek( aDadoPed[nPosPed][02] + aDadoPed[nPosItem][02]  )) ) )
	    
	    For nI := 1 To Len(aDadoPed)
	       iF SZ5->(FieldPos(aDadoPed[nI][01])) > 0
		      SZ5->&(aDadoPed[nI][01]) := aDadoPed[nI][02]
		   Else
		      CONOUT('ERRO : CAMPO ' + aDadoPed[nI][01] + " Nao Criado BASE DE DADOS")
		   EndIf 
		   
	    Next
	    	    
	    SZ5->(MsUnlock())
	    
	EndIf
  */  
Return Nil

User Function AALOGE2A(_cAlias,_nOpc,_nRecno)
    
    /*If _cAlias == "SC2" .And. empty(SC2->C2_XPEDIDO ) 
       Alert("Pedido nao Definido na OP, Favor Alterar e Informar o Pedido Relacionado a Mesma")
       Return Nil
    EndIf
   
    _dData :=  AAGETDATA("Data Prevista de Entrega")
    
    If !Empty(_dData)
	    If _cAlias == "SC2"
	       
	       aAdd(aDados,{'Z5_PEDIDO',SC2->C2_XPEDIDO})
	 	   aAdd(aDados,{'Z5_PRODUTO',SC2->C2_PRODUTO })
		   aAdd(aDados,{'Z5_DATA',dDataBase})
		   aAdd(aDados,{'Z5_HORA',SubStr(Time(),1,5)})
		   aAdd(aDados,{'Z5_USER',cUserName})
		   aAdd(aDados,{'Z5_OP'  , SC2->(C2_NUM + C2_ITEM + C2_SEQUEN) })
	       aAdd(aDados,{'Z5_OBS'    ,If(SC2->C2_QUJE == SC2->C2_QUANT,"PRODUZIDO", "EM PRODUCAO") })
	       aAdd(aDados,{'Z5_STATUS' ,If(SC2->C2_QUJE == SC2->C2_QUANT,"3", "2")})
		   
		   // Implementar TELA PARA INFORMAR A DATA DE ENTREGA PREVISTA
		   aAdd(aDados,{'Z5_ENTREGA', _dData }  )
	       
	       If ExistBlock("AALOGE02")
		      u_AALOGE02(aDados)
	       EndIf
	    elseif _cAlias == "SC5"
	    
	       SC6->(dbSetOrder(1))
	       SC6->(dbSeek( SC5->C5_FILIAL + SC5->C5_NUM  ))
	       
	       
	       While (SC6->(C6_FILIAL + C6_NUM) == SC5->(C5_FILIAL + C5_NUM))	            
	            _adSt := GetLastSt(SC5->C5_NUM,SC6->C6_PRODUTO)
	            
    	        aAdd(aDados,{'Z5_PEDIDO',SC5->C5_NUM})
	 	   		aAdd(aDados,{'Z5_PRODUTO',SC6->C6_PRODUTO })
		   		aAdd(aDados,{'Z5_DATA',dDataBase})
		   		aAdd(aDados,{'Z5_HORA',SubStr(Time(),1,5)})
		   		aAdd(aDados,{'Z5_USER',cUserName})
		   		aAdd(aDados,{'Z5_OP',''})
	       		aAdd(aDados,{'Z5_OBS'    , _adSt[02] })
	       		aAdd(aDados,{'Z5_STATUS' , _adSt[01] })
	            
	            aAdd(aDados,{'Z5_ENTREGA', _dData }  )
	            
	           SC6->(dbSkip())
	       EndDo
        EndIf
    EndIf */
Return Nil

Static Function AAGETDATA(_cMensagem)

Local _dData  := STOD("  /  /  ")
Local _lCont  := .T.

Define Font oFnt3 Name "Ms Sans Serif" Bold

while EMPTY(_dData) .And. _lCont

	DEFINE MSDIALOG oDialog TITLE _cMensagem FROM 190,110 TO 300,370 PIXEL //STYLE nOR(WS_VISIBLE,WS_POPUP)
	@ 005,004 SAY Alltrim(_cMensagem)+" :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
	@ 025,004 GET _dData         SIZE 50,10  Pixel of oSenhas
	
	@ 045,042 BMPBUTTON TYPE 1 ACTION(  IIF(_fdValid(_dData),oDialog:End(), NIL)  )	
	@ 045,072 BMPBUTTON TYPE 2 ACTION(  lCont := .F.,oDialog:End() )
	
	ACTIVATE DIALOG oDialog CENTERED
Enddo

Return _dData

Static Function getNextIt(_cPedido,_cProduto)
Local _cQry := ''
Local _cTbl := GetNextAlias()

_cQry += " Select MAX(Z5_ITEM) Z5_ITEM from " + RetSqlName('SZ5') 
_cQry += " Where D_E_L_E_T_ = ''
_cQry += " And Z5_PEDIDO  = '" + _cPedido  + "'"
_cQry += " And Z5_PRODUTO = '" + _cProduto + "'

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),_cTbl,.T.,.T.)

_cItem := (_cTbl)->Z5_ITEM

(_cTbl)->(dbCloseArea(_cTbl))

Return _cItem

Static function getStatus(_cPedido)
   
Local _cQry := ''   
Local _cTbl := getNextAlias()


_cQry += " Select Count(*) ITENS from " + RetSqlName('SD2') 
_cQry += " where D_E_L_E_T_ = ''
_cQry += " And D2_PEDIDO = '" + _cPedido + "'

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuerfy(_cQry)),_cTbl,.T.,.T.)   

If (_cTbl)->ITENS > 0
   cStatus := '4' // Pedido Faturado
EndIf



Return _cStatus
Static Function _fdValid(_dData)

   Local _lRet := .T.
   
   If _dData < dDataBase
      AVISO("DATA INVALIDA","Data não pode ser inferior a DATA ATUAL" ,{"OK"})
      _lRet := .F.
   EndIf

Return _lRet

Static Function GetLastSt(_cPed,_cProd)

    Local _cQry  := ""
    Local cTable := GetNextAlias()
    LOCAL _cdStatus := ""
    Local _cdObs    := ""
    
    _cQry += " Select MAX(R_E_C_N_O) Z5_RECNO from " + RetSqlName("SZ5") 
    _cQry += " Where D_E_L_E_T_ = ''
    _cQry += " And Z5_PEDIDO  = '" + _cPed  + "'"
    _cQry += " And Z5_PRODUTO = '" + _cProd + "'"
    _cQry += " And Z5_STATUS != '2'
    
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)
        SZ5->(dbGoto(  (cTable)->Z5_RECNO ))
       _cdStatus := SZ5->Z5_STATUS
       _cdObs    := SZ5->Z5_OBS
    (cTable)->(dbCloseArea(cTable))

Return {_cdStatus,_cdObs}
 


    

/*DXRCOVRB*/