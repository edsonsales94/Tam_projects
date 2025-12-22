#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 14/12/01
// #include "fivewin.ch"   
#include "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "PROTHEUS.CH"

/*=========================================================================
|Funcao    | fVisual     |Autor | Claudio               | Data | 07/02/01  |
============================================================================
|Descricao | Funcao usada para retornar se está no modo de visualização    |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fVisual()
Return( Inclui .or. Altera )

/*=========================================================================
|Funcao    | PicUm              | Claudio Cavalcante    | Data | 20/02/01  |
============================================================================
|Descricao | Ajusta a Picture da quantidade a depender da Unidade de Medida|
|          |                                                               |
============================================================================
|Observações: O objetivo desta função é retorna uma mascara de digitação   |
|             adequada para cada tipo de unidade de medida.                | 
|             Caso uma determinada unidade de medida não suporte           |
|             francionamento a mascara não contará decimais                |
|Parâmetro:   cUm -  é a variável que contém o valor a ser comparado,  ou  |
|             seja, a unidade de medida                                    |
============================================================================ 
|Retorno:  Picture                                                         |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function PicUm( cUM, cVar )
Local cAlias := Alias(), cPict, nPos, cAliasTmp := ''
Local lFrac 
                                    
            
    If Empty( cVar )
    	cVar := ReadVar()
    EndIf        
    
	lFrac   := Posicione( 'SAH', 1, FWXFilial('SAH') + cUM, "AH_FRACION" )
	If Empty( lFrac )
		lFrac := '2'
	EndIf
         
	cVar  := SubStr( cVar,4 )
    nPos  := At( "_", cVar )
    If nPos > 0
    	cAliasTmp := SubStr( cVar, 1, nPos -1 )
    EndIf
    
	If !Empty( cAliasTmp )
		cPict := PesqPict( cAliasTmp, cVar )
	Else
		cPict := "@E 999,999.99"
	EndIf
	
	If lFrac = '2'
	   cPict  := SubStr( cPict, 1, At( ".", cPict )- 1 )
	EndIf  
	
	Select( cAlias )		

Return( cPict )


/*=========================================================================
|Funcao    | fSetPicture |Autor | Claudio               | Data | 20/02/01  |
============================================================================
|Descricao | Define a picture de um determinado campo                      |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function SetPicUm( cVar, cProduto )          
Local cUm, nPosUm
	If Empty( cProduto )
		cProduto := &( ReadVar() )
	EndIf
    cUm := Posicione( 'SB1', 1, FWXFilial('SB1') + cProduto, "B1_UM" )
    If !Empty( cUm )
    	
	    If Valtype( aHeader )  = "A"
	    	nPosUM  := Ascan( aHeader, { |a| Rtrim(a[2]) == "UB_QUANT"  } )
	    	If nPosUm > 0
	    	   aHeader[nPosUm][3] := u_PicUm( cUm, "UB_QUANT" )
	    	EndIf
	    EndIf
	EndIf       
	
Return( .t. )

/*=========================================================================
|Funcao    | fRetNivel   |Autor | Claudio               | Data | 22/02/01  |
============================================================================
|Descricao | Retorna o nível de acesso do usuário.                         |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fRetNivel()
Local nNivel

	nNivel := Val( cNivel )

Return( nNivel )

/*=========================================================================
|Funcao    | fRetUser    |Autor | Claudio               | Data | 22/02/01  |
============================================================================
|Descricao | Retorna o nome do usuário                                     |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fRetUser()

Return( cUserName )

/*=========================================================================
|Funcao    | fCampos     |Autor | Claudio               | Data | 02/03/01  |
============================================================================
|Descricao | Retorno o nome dos campos que o usuario atual tem direito de  |
|          | visualizacao                                                  |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fCampos( cAlias )
Local aCampos:= {}

	cAlias := Alias()

	dbSelectArea('SX3')
	OrdSetFocus(1)
	If dbSeek( cAlias )
		While !Eof() .and. X3_ARQUIVO = cAlias
			If X3USO(x3_usado) .AND. cNivel >= X3_NIVEL
		        AADD( aCampos, X3_CAMPO  )
		 	EndIf
		   dbSkip()
		End

	EndIF
        
	Select( cAlias )
	
Return( aCampos )



/*=========================================================================
|Funcao    | PushField   |Autor | Claudio               | Data | 30/01/01  |
============================================================================
|Descricao | Usada para obtenção dos campos cadastrados no dicionário de   |
|          | campos SX3                                                    |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function PushField( cAlias )
Local aDbf

	dbSelectArea("SX3")
	dbSetOrder(1)
	
	aDbf := {}
	dbSeek( cAlias )
	
	While !Eof() .and. SX3->X3_ARQUIVO == cAlias
	
		If UPPER( SX3->X3_CONTEXT ) <> "V"
			If SX3->X3_TAMANHO > 0
				AADD( aDbf, { AllTrim( SX3->X3_CAMPO ),;
			    						SX3->X3_TIPO   ,;
										SX3->X3_TAMANHO,;
										SX3->X3_DECIMAL })
			EndIf
		EndIf
		
		dbSkip()

	End

Return( aDbf )



/*=========================================================================
|Funcao    | fEnchoice         | Claudio Cavalcante    | Data | 07/03/01   |
============================================================================
|Descricao | Monta Enchoice para visualizacao no browse                    |
|          |                                                               |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fEnchoice(cAlias)
	Local aUserEnch	:= {}
	Local _xArea	:= {}
	
	Default cAlias  := Alias()

	aAdd( _xArea, SX3->( GetArea() ) )                  

	SX3->( OrdSetFocus(1) ) //X3_ARQUIVO, X3_ORDEM
	SX3->( DbSeek( cAlias ) )
	While SX3->(!Eof()) .And. (SX3->X3_ARQUIVO==cAlias)
        If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CONTEXT <> "V"
           Aadd(aUserEnch, AllTrim(SX3->X3_CAMPO) )
        Endif
	    SX3->( DbSkip() )
	End

	u_pushArea( _xArea ) 

Return( aUserEnch )

/*=========================================================================
|Funcao    | Eom       | Autor | Claudio Cavalcante    | Data | 19/01/01   |
============================================================================
|Descricao | Calcula qual o último dia do mes                              |
==========================================================================*/
User Function Eom( _dData )
Local _nAno, _nMes, _nDia, _xFormatDate := Set(4) 

	_DFSET( "dd/mm/yyyy", "dd/mm/yy" )
	
	_nAno   := Year( _dData )
	_nMes   := Month( _dData ) + 1
	If _nMes = 13
		_nMes := 1
		_nAno++
	EndIf 
	_nDia   := 1
	_dData  := CTod(StrZero(_nDia,2)+"/"+StrZero(_nMes,2)+"/"+StrZero(_nAno,4)) - 1
	
	Set( 4, _xFormatDate )

Return( _dData )

/*=========================================================================
|Funcao    | fIsRepres   |Autor | Claudio Cavalcante    | Data | 16/02/01  |
============================================================================
|Descricao | Verificar de um determinado vendedor é representante          |
|          |                                                               |
============================================================================
|Parâmetros: cVendedor - Código do Vendedor                                |
|                                                                          |
============================================================================ 
|Retorno:                                                                  |
|			                                                               |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function fIsRepres( _cVendedor ) 
Local _lRet, _cAlias := Alias()
                    
	_lRet := Posicione( 'SA3', 1, FWXFilial('SA3') + _cVendedor, "A3_TIPO" )
	Select( _cAlias )
	
Return( IIf( _lRet = 'R', .t., .f. ) )


/*=========================================================================
|Funcao    | fExplode    |Autor | Claudio Cavalcante    | Data | 26/03/01  |
============================================================================
|Descricao | Retorna da extrutura de produtos os componente de último nível|
|          |                                                               |
============================================================================
|Parâmetros: cProduto - Código do produto base da estrutura                |
|                                                                          |
============================================================================ 
|Retorno:  Array  [x][1] - Produto                                         |
|			      [x][2] - Quantidade                                      |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function fExplode( _cProduto, _nQuant, _cFantasm, _cOrigem )
Local _nx, _aComp, _aStru, _cProd, _nDel, _aRet := {}
Local _bOrigem, _bFantasm
Private nEstru := 0, aEstrutura:= {}


	If Empty( _nQuant )
	   _nQuant := 1
	EndIf               
	
	nEstru     := 0
    _aComp     := {}    // Acumulador de componentes
	_aStru     := Estrut( _cProduto ) 
	// {Nº , Código , Comp. , Qtd. , TRT }
  
	For _nX := 1 to Len( _aStru )      
      	_cProd := _aStru[_nX][3] 
      	_nDel  := aScan( _aStru, { |a| a[2] == _cProd } )
      	_aStru[_nX][5] := .t.
      	If _nDel > 0
        	_aStru[_nX][5] := .f.
    	EndIf
  	Next
                
    If !Empty( _cFantasm ) .or. !Empty( _cOrigem )
    	dbSelectArea('SB1')
    	OrdSetFocus(1)
		_bFantasm := { |a| a $ _cFantasm } 
		_bOrigem  := { |a| a $ _cOrigem }
		
    EndIf
    
  	For _nx := 1 to Len( _aStru )   
    	
	    /* ============================================================
        | Verifica se o componente está no último nível da extrutura   |
        |=============================================================*/
        
    	If _aStru[_nx][5]                                      
    		SB1->( dbSeek( FWXFilial('SB1') + _aStru[_nx][3] ) )
    		If !Empty( _cFantasm ) .or. !Empty( _cOrigem )
    			If Eval( _bFantasm, SB1->B1_FANTASM ) .and. Eval( _bOrigem, SB1->B1_ORIGEM )
	    			aAdd( _aRet,  { _aStru[_nx][3], ( _nQuant * _aStru[_nx][4] ), SB1->B1_CUSTD  } )
	    		EndIf
    		Else
	    		aAdd( _aRet,  { _aStru[_nx][3], ( _nQuant * _aStru[_nx][4] ), SB1->B1_CUSTD } )
	    	EndIf
    	EndIf
        
    Next       
    
    If Len( _aRet ) = 0
        Alert( 'Produto sem estrutura' )
    EndIf
    
Return( _aRet )


/*=========================================================================
|Funcao    |  AtivaFx   | Autor | Claudio Cavalcante    | Data | 31/01/01  |
============================================================================
|Descricao | Ativa Funções de teclado (ShotCut)                            |
============================================================================
|Modulo    | Generico                                                      |
==========================================================================*/
User Function AtivaFx( nTecla, cFuncao, cVar, lOk )
Local _bBlock, _cRet := ""

	If Empty( cVar )
 	   cVar := ReadVar()
	   cVar := SubStr( cVar, 4 )
	EndIf
	
	If Empty( lOK )
		lOK := .t.
	EndIf
	
	_bBlock := &("{ || " + cFuncao + " }" )
	SetKey( nTecla, _bBlock )
	
	If lOK 
		_cRet := Criavar( (cVar), .f. )
	EndIf
	
Return( _cRet )

/*=========================================================================
|Funcao    | fValor            | Claudio Cavalcante    | Data | 19/03/01   |
============================================================================
|Descricao | Retorno a valor de um determinado campos em aCols             |
|          |                                                               |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fValor( _cCampo, _nLinha, _aLista, _aHead, _lShowErro )
	Local _xRet := NIL
	Local _nPos := 0

	Default _nLinha	   := n
	Default _aLista    := aCols
	Default _aHead	   := aHeader
	Default _lShowErro := .T.

	_nPos := Ascan( _aHead, { |a| Rtrim(a[2]) == AllTrim( _cCampo ) } )
	If _nPos > 0
		_xRet := _aLista[_nLinha][_nPos ]
	Else     
		_xRet := U_CpoVazio(_cCampo)
				         
		If _lShowErro
			Aviso( 'Aviso!', 'O campo: '+ _cCampo + ' não existe em aCOLS', {'OK'} )
		EndIf
	EndIf

Return( _xRet )

/*=========================================================================
|Funcao    | fValorUp          | Claudio Cavalcante    | Data | 20/01/02   |
============================================================================
|Descricao | Atualiza o valor de acols de acordo ao parâmetro fornecido.   |
|          |                                                               |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fValorUp( _cCampo, _xValor, _nLinha, _aLista, _aHead, ;
					    _lShowErro )
	Local _nPos
	
	Default _nLinha	   := n
	Default _aLista    := aCols
	Default _aHead	   := aHeader
	Default _lShowErro := .T.

	_nPos := Ascan( _aHead, { |a| Rtrim(a[2]) == AllTrim( _cCampo ) } )
	If _nPos = 0
		If _lShowErro
			Aviso( 'Aviso!', 'Campo: ' + _cCampo + ' não encontrado', { 'OK' } )
		EndIf
	Else
		_aLista[_nLinha][_nPos ] := _xValor
	EndIf
Return


/*=========================================================================
|Funcao    | CpoVal            | Raimundo Santana      | Data | 24/07/08   |
============================================================================
|Descricao | Retorno a valor de um determinado campo utilizando a variavel |
|          | de memória se existir ou o aCols caso não exista			   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function CpoVal(_cCampo,_lShowErro,_xDefault)
	Local xRet

	Default _lShowErro := .T.
	
	_cCampo:=AllTrim(_cCampo)
		
	If Type("M->"+_cCampo)=="U"
		If Type("n")=="U" .Or. Type("aCols")=="U" .Or. Type("aHeader")=="U"
			If _lShowErro
				Aviso( 'Aviso!', 'O campo: '+ _cCampo + ' não definido! aCOLS não existe.', {'OK'} )
			EndIf
		Else
			xRet := U_fValor(_cCampo,,,,_lShowErro)
		EndIf
	Else
		xRet := &("M->"+_cCampo)
	EndIf                               
	
	Default xRet := _xDefault
	
Return xRet                           
 
/*=========================================================================
|Funcao    | CpoSetVl          | Raimundo Santana      | Data | 24/07/08   |
============================================================================
|Descricao | Atribui valor a um determinado campo utilizando a variavel    |
|          | de memória se existir ou o aCols caso não exista			   |
============================================================================
|Observações: Permite executar a validação e/ou o Trigger do campo.        |
|             Se utilizar a validação somente será atribuido o valor se a  |
|             validação permitir.										   |
==========================================================================*/
User Function CpoSetVl(_cCampo,_xVal,_lValid,_lTrigger,_lShowErro)
	Local _cReadVar
	Local _lRet		   := .T.
	Local _xOldVal
	Local _cOldReadV
	Local _nPos
	Local _lGetDados	   := .T.

	Default _lValid	   := .T.
	Default _lTrigger  := .T.
	Default _lShowErro := .T.

	_cCampo:=Upper(AllTrim(_cCampo))
	
	If Left(_cCampo,3)=="M->"
		_cReadVar := _cCampo
		_cCampo   := SubStr(_cCampo,4)
	Else
		_nPos := At("->",_cCampo)
		
		If _nPos > 0
			_cCampo := SubStr(_cCampo,_nPos+3)
		EndIf
		
		_cReadVar := "M->"+_cCampo
	EndIf

	If Type(_cReadVar)=="U"
		If Type("n")=="U" .Or. Type("aCols")=="U" .Or. Type("aHeader")=="U"
			If _lShowErro
				Aviso( 'Aviso!', 'O campo: '+ _cCampo + ' não definido! aCOLS não existe.', {'OK'} )
				Return .F.
			EndIf
		Else              
			_xOldVal := U_fValor(_cCampo,,,,_lShowErro)
			
			U_fValorUP(_cCampo,_xVal,,,,_lShowErro)
			
			If _lValid .Or. _lTrigger
				Private &(_cReadVar) := _xVal
			EndIf
		EndIf
	Else
		_xOldVal := &(_cReadVar)
		&(_cReadVar) := _xVal
		_lGetDados := .F.
	EndIf

	If _lValid .Or. _lTrigger
		If ValType("__ReadVar")=="U"
			Private __ReadVar
		Else
		    _cOldReadV := __ReadVar
		EndIf     
		
		__ReadVar := _cReadVar

		If _lValid
			_lRet := U_RunValid(_cCampo)
		EndIf
	
		If _lRet
			If _lTrigger .And. ExistTrigger(_cCampo)
				_lRet := U_RunTrig(_cCampo,_lGetDados)
	  		EndIf
	  	Else
			U_fValorUP(_cCampo,_xOldVal,,,,.F.)
        EndIf

    	__ReadVar := _cOldReadV
  	EndIf
Return _lRet                           

/*=========================================================================
|Funcao    | GetValid          | Raimundo Santana      | Data | 14/09/09   |
============================================================================
|Descricao | Função que retorna o codeblock com a validação de um campo    |
|          | Específico.    											   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function GetValid(_cCampo,_nTipoVld,_lSavArea)
	Local _xArea	 := {}
	Local _cValid	 := ""
	Local _nPos

	Default _cCampo	  := ""
	Default _nTipoVld := 0
	Default _lSavArea := .T.   

	If !Empty(_cCampo)	
		_cCampo:=Upper(AllTrim(_cCampo))

		_nPos := At('->',_cCampo)

		If _nPos > 0
			_cCampo := SubStr(_cCampo,_nPos+2)  
		EndIf

		If _lSavArea	
			aAdd( _xArea, SX3->( GetArea() ) )                  
			SX3->( OrdSetFocus(2) ) //X3_CAMPO
		EndIf
	
		SX3->( DbSeek( PadR(_cCampo,10) ) )
	EndIf

	If ( _nTipoVld == 0 .Or. _nTipoVld == 1 ) .And. !Empty(SX3->X3_VALID)
		_cValid:=AllTrim(SX3->X3_VALID)
	EndIf
         
	If ( _nTipoVld == 0 .Or. _nTipoVld == 2 ) .And. !Empty(SX3->X3_VLDUSER)
		_cValid +=IIF(!Empty(_cValid)," .AND. ","")+AllTrim(SX3->X3_VLDUSER)
	Endif
       
	If !Empty(_cValid)
		_cValid:="{||"+_cValid+"}"
	EndIf

	If _lSavArea
		u_pushArea( _xArea ) 
	EndIf
Return _cValid
                   

/*=========================================================================
|Funcao    | GetVldAC          | Raimundo Santana      | Data | 14/09/09   |
============================================================================
|Descricao | Função que retorna um array com os campos e respectivos       |
|          | codeblocks de validação segundo paramatros.				   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function GetVldAC(_cAlias,_nTipoVld,_lCpoVirt,_nCpoBrw,_cCpoInc,_cCpoExc)
	Local _xArea 	:= {}    
	Local _aCpoVld  := {}
	Local _cValid
	
	Default _cAlias 	:= Alias()
	Default _nTipoVld   := 0
	Default _lCpoVirt	:= .T.  
	Default _nCpoBrw    := 0                               
	Default _cCpoInc	:= ""
	Default _cCpoExc	:= ""      
	
	If !Empty(_cCpoInc)
		_cCpoInc := "|" + _cCpoInc + "|"
	EndIf

	If !Empty(_cCpoExc)
		_cCpoExc := "|" + _cCpoExc + "|"
	EndIf
	
	aAdd( _xArea, SX3->( GetArea() ) )                  

	SX3->( OrdSetFocus(1) ) //X3_ARQUIVO+X3_ORDEM    

	_cAlias := PadR(_cAlias,3)
	
	SX3->( DbSeek( _cAlias ) )
	Do While SX3->( !Eof() ) .And. SX3->X3_ARQUIVO==_cAlias
        If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
           (_lCpoVirt .Or. SX3->X3_CONTEXT <> "V") .And.;
           ( _nCpoBrw==0 .Or. (_nCpoBrw==1 .And. SX3->X3_BROWSE=="S") .Or. (_nCpoBrw==2 .And. SX3->X3_BROWSE!="S")  ) .And.;
           ( Empty(_cCpoInc) .Or. "|"+AllTrim(SX3->X3_CAMPO)+"|" $ _cCpoInc) .And.;
           ( Empty(_cCpoExc) .Or. !( "|"+AllTrim(SX3->X3_CAMPO)+"|" $ _cCpoExc ))
           
        	_cValid := U_GetValid(,_nTipoVld,.F.)
        	
        	If !Empty(_cValid)
        		AAdd(_aCpoVld,{ AllTrim(SX3->X3_CAMPO), MontaBlock(_cValid) })
        	EndIf
        EndIf

		SX3->( DbSkip() )
	EndDo

	u_pushArea( _xArea ) 

Return _aCpoVld
 
 
/*=========================================================================
|Funcao    | RunValid          | Raimundo Santana      | Data | 31/03/09   |
============================================================================
|Descricao | Função que executa a validação do campo retornando o          |
|          | resultado.    											       |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function RunValid(_cCampo,_nTipoVld,_lSavArea,_cAliasTMP,_bValid)
	Local _cValid
	Local _cOldReadV        
	Local _nPos
	Local _lRet		 := .T.        
	
	Default _cCampo	  := ReadVar()
	Default _cAliasTMP:= "M"
	
	_cAliasTMP := Upper(AllTrim(_cAliasTMP))

	_cCampo:=Upper(AllTrim(_cCampo))

	_nPos := At('->',_cCampo)

	If _nPos > 0
		_cCampo := SubStr(_cCampo,_nPos+2)  
	EndIf

	If ValType(_bValid) != "B"
		_cValid := U_GetValid(_cCampo,_nTipoVld,_lSavArea)
		
		If !Empty(_cValid)
			_bValid := MontaBlock(_cValid)
		EndIf
	EndIf
	
	If ValType(_bValid) == "B"
		If ValType("__ReadVar")=="U"
			Private __ReadVar
		Else
		    _cOldReadV := __ReadVar
		EndIf 
	
		__ReadVar := _cAliasTMP+"->"+_cCampo

		_lRet := Eval(_bValid)

	   	__ReadVar := _cOldReadV
	EndIf
    
Return _lRet

/*=========================================================================
|Funcao    | RunTrig           | Raimundo Santana      | Data | 31/03/09   |
============================================================================
|Descricao | Função que executa a trigger de um campo específico.		   |
|          | 									   						   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function RunTrig(_cCampo,_lGetDados)
	Local _cOldReadV
	Local _nCt
	Local _xArea	:= {}
	Local _cLinPos
	Local _lObrigat

	Default _cCampo	:= ReadVar()
	Default _lGetDados	:= .F.

	_cCampo:=Upper(AllTrim(_cCampo))

	If ValType("__ReadVar")=="U"
		Private __ReadVar
	Else
	    _cOldReadV := __ReadVar
	EndIf

	If Left(_cCampo,3)=="M->"	
		__ReadVar := _cCampo
		_cCampo   := SubStr(_cCampo,4)
	Else
		__ReadVar := "M->"+_cCampo
	EndIf
	

	If _lGetDados
		For _nCt:=1 To Len(aHeader)
			Private &(aHeader[_nCt][2]) := aCols[n][_nCt]
		Next
	EndIf

    RunTrigger(IIF(_lGetDados,2,1),IIF(_lGetDados,n,NIL),,,PadR(_cCampo,10))

   	__ReadVar := _cOldReadV
Return .T.

/*=========================================================================
|Funcao    | fExistCpo         | Claudio Cavalcante    | Data | 05/04/01   |
============================================================================
|Descricao | Verifica se existe um determinada chave num arquivo especifico|
|          |                                                               |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fExistCpo( _cAlias, _cChave, _nOrdem)
Local _lRet
Local _aArea

    If Empty( _nOrdem )
    	_nOrdem := 1
    EndIf           

	(_cAlias)->( OrdSetFocus(_nOrdem) )
	
	_lRet := (_cAlias)->( DbSeek( FWXFilial(_cAlias) + _cChave )  )

Return( _lRet )

/*==========================================================================
|Funcao    | StoD       | Autor | Claudio Cavalcante    | Data | 25/04/01  |
============================================================================
|Descricao | Converte uma string literal em data                           |
==========================================================================*/
USER FUNCTION StoD( _cData )
Local _cDataRet

    _cDataRet := SubStr( _cData, 7,2 ) + "/" + SubStr( _cData, 5,2 ) + "/" + SubStr( _cData, 1,4 )

Return( CtoD( _cDataRet ) )


/*=========================================================================
|Funcao     | BuscaSE1   | Autor | Claudio Cavalcante    | Data | 28/12/00 |
============================================================================
|Descricao  | Funcao Utilizada para busca todas as duplicatas de uma N.F.  |
============================================================================
|Retorno    | Array do tipo: [1] - Numero                                  |
|           |                [2] - Vencimento                              |
|           |                [3] - Valor                                   |
============================================================================
|Alteracoes |                                                              |
|           |                                                              |
==========================================================================*/
User Function BuscaSe1( cPrefixo, cNumero )
Local aDupl:= {}, cAlias := Alias()

   /* ============================================================
   | Posiciona o SE1 Duplicatas a Receber                         |
   |=============================================================*/
      
   dbSelectArea("SE1")
   OrdSetFocus(1)
   dbSeek( FWXFilial('SE1') + cPrefixo + cNumero )
   Do While !Eof() .and. E1_FILIAL + E1_PREFIXO + E1_NUM == FWXFilial("SE1") + cPrefixo + cNumero
     /* =======================================
     | Posiciona o SE1 Duplicatas a Receber    |
     | Estrutura do array de Itens da DUPL     |
     |=========================================|
     | DUPL[n][1] | DUPL[n][2] | DUPL[n][3]    |
     | Numero     | Vencto     | Valor         |
     |========================================*/
      aAdd( aDupl, { Alltrim( SE1->E1_NUM +" " + SE1->E1_PARCELA ), SE1->E1_VENCTO, SE1->E1_VALOR } )
      
      dbSkip()
      
   EndDo

Return( aDupl )


/*=========================================================================
|Funcao     | vZ1NUML    | Autor | Claudio Cavalcante    | Data | 08/01/02 |
============================================================================
|Descricao  | Funcao Utilizada devolver o proximo numero de caixas de um   |
|           | determinado lote de producao                                 |
============================================================================
|Retorno    | _cCaixa - Numero da caixa                                    |
|                                                                          |
============================================================================
|Alteracoes |                                                              |
|           |                                                              |
==========================================================================*/
User Function vZ1Numl( _cNumLote )
Local _aArea := GetArea(), _cCaixa := '001'

	If Empty( _cNumLote )
		_cNumLote  := &( ReadVar())
		If !Empty( _cNumLote )
		     dbSelectArea('SZ1')
		     OrdSetFocus(1)
		     If dbSeek( FWXFilial('SZ1') + _cNumLote + M->Z1_SLOTE )
		     	While !Eof() .and. FWXFilial('SZ1') + _cNumLote + M->Z1_SLOTE == ;
		     		SZ1->Z1_FILIAL + SZ1->Z1_NUMLOTE + SZ1->Z1_SLOTE 
		     		
		     		_cCaixa := SZ1->Z1_CAIXA
		     		dbSkip()
		     	EndDo
		     EndIf
		     _nCaixa := Soma1( _cCaixa )
		EndIf
	EndIf
	
	M->Z1_CAIXA := _cCaixa
	
    RestArea( _aArea )
    
Return( .t. )                

/*=========================================================================
|Funcao    | vMoeda             | Claudio Cavalcante    | Data | 21/01/02  |
============================================================================
|Descricao |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:                                                                  |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function vMoeda(_nMoeda)
Local _lRet := .t.

	If Empty( _nMoeda )
		_nMoeda := 2
	EndIf

	If ( FuncaMoeda( dDataBase, 1, _nMoeda )[1] = 0  ) 
		Help( '',1,'GENERICO',Nil,'Cotação do Dolar não cadastrada! Favor contactar setor responsável.',4,1)
		_lRet := .f.
	EndIf
	
Return( _lRet )



/*=========================================================================
|Funcao    | vDescMax           | Claudio Cavalcante    | Data | 21/01/02  |
============================================================================
|Descricao | Checa qual o desconto máximo de um determinado produtos em    |
|          | relacao a classificacao do cliente x grupo x segmento de      |
|          | negocios.                                                     |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:                                                                  |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function vDescMax( _cProduto, _cCliente, _cLoja )
Local _nDesc := 0, _aArea := GetArea(), _cClass:= '', _cSeg := '', _cGrupo:= ''

	dbSelectArea( 'SA1' )
	OrdSetFocus(1)
	If dbSeek( FWXFilial('SA1') + _cCliente + _cLoja )
		_cClass := SA1->A1_CLASVEN
		_cSeg   := SA1->A1_SATIV1
	EndIf
	
	dbSelectArea( 'SB1' )
	OrdSetFocus(1)
	If dbSeek( FWXFilial('SB1') + _cProduto )
	     _nGrupo := SB1->B1_GRUPO
	EndIf
	
	dbSelectArea('UAO')
	OrdSetFocus(1)
	If dbSeek( FWXFilial('UAO') + _cSeg + _cClass + _cGrupo )
         _nDesc := UAO->UAO_DESCON
	EndIf		                 
	
    RestArea( _aArea )
    
Return( _nDesc )

/*=========================================================================
|Funcao    | Mascara    | Autor | Claudio Cavalcante    | Data | 15/07/02  |
============================================================================
|Descricao | Monta Mascara para string de uma Instrução Sql                |
============================================================================
|Modulo    | Call Center ou Faturamento                                    |
|          | 1=Inicio     2=Fim     3=Ambos                                |
==========================================================================*/
User Function Mascara( _cStr, _nSel )
Local _cMask
	If Empty( _nSel )
		_nSel := 1
	EndIf
	If _nSel = 1
		_cMask := "'" + Alltrim( _cStr ) + "%'" 
	ElseIf _nSel = 2
		_cMask := "'%" + Alltrim( _cStr ) + "'"
	ElseIf _nSel = 3
		_cMask := "'%" + Alltrim( _cStr ) + "%'"
	EndIf

Return( _cMask )

/*=========================================================================
|Funcao    | fSetField  | Autor | Claudio Cavalcante    | Data | 01/02/02  |
============================================================================
|Descricao | Define o tamanho ideal dos campos numericos                   |
============================================================================
|Observações                                                               |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function fSetField( _aDbf, _cAlias, _lOnlyNumber )
Local _nCt:= 0                                       

	If _lOnlyNumber = nil
		_lOnlyNumber := .t.	
	EndIf
          
	For _nCt := 1 to Len ( _aDbf )
		If _lOnlyNumber .and. _aDbf[_nCt][2] = 'N'
			TCSetField( _cAlias, _aDbf[_nCt][1], _aDbf[_nCt][2], _aDbf[_nCt][3], _aDbf[_nCt][4] )
		Else     
			If _aDbf[_nCt][2] $ 'D/L/N'
				TCSetField( _cAlias, _aDbf[_nCt][1], _aDbf[_nCt][2], _aDbf[_nCt][3], _aDbf[_nCt][4] )
			EndIf
		EndIf
	Next
    
Return


/*=============================================================================
|Rotina     | fSelFilial            | Claudio Cavalcante    | Data | 30/10/01 |
===============================================================================
|Descrição  | seleção de Varias Filiais em Grid                               |
===============================================================================
|Uso        | Clientes Microsiga                                              |
=============================================================================*/
User Function fSelFilial(_cFiliais, _lRet )
Local _nx, _nRecno := SM0->( Recno() ), _aArray:= {}, _cCod, _nLen:= 0
Local _xArea := {}
Private aHeader := {}, aCols, _oMult, _aCheck := { .f., .f. }, _cFil := ''

	aAdd( _xArea, SX3->( getarea() ) )                  
	aAdd( _xArea, SM0->( getarea() ) )
	aAdd( _xArea, getarea() )
	
If _lRet = nil
	_lRet := .f.
EndIf

// Aadd(aHeader,{ Trim(SX3->X3_Titulo), SX3->X3_Campo,   SX3->X3_Picture,;
//                     SX3->X3_Tamanho, SX3->X3_Decimal, SX3->X3_Usado  ,;
//                     SX3->X3_Tipo,    SX3->X3_Arquivo, SX3->X3_Context })
DBSELECTAREA("SX3")
DBSETORDER(2)
DBSEEK("C6_PRODUTO")

_nLen := Len( _cFiliais ) 
If !Empty( _cFiliais )
	_cFiliais := u_fReadFilial( _cFiliais )
	_aArray   := &("{" + _cFiliais + "}")
EndIf

// A sexta coluna do AHEADER, controla a edicao do campo.
	AADD(aHeader, { 'OK'         , '_cOk'   , '@!X', 01, 00,".T.", SX3->X3_USADO, 'C',SX3->X3_F3, SX3->X3_CONTEXT})
	AADD(aHeader, { 'Filial'     , '_cFil'  , '@!X', 02, 00,".F.", SX3->X3_USADO, 'C',SX3->X3_F3, SX3->X3_CONTEXT})
	AADD(aHeader, { 'Descricao'  , '_cDesc' , '@!X', 30, 00,".F.", SX3->X3_USADO, 'C',SX3->X3_F3, SX3->X3_CONTEXT})
	aCols := {}

	dbSelectArea('SM0')
	
	dbGoTop()
	While !Eof()
		_nx := aScan( _aArray, { |a| a = FWCodFil() } )
		If _nx > 0
			_cCod := "X"
		Else
			_cCod := " "
		EndIf
		AADD(aCols,{ _cCod, FWCodFil(), Rtrim(SM0->M0_FILIAL) + "/ " + SM0->M0_NOME, .f. } )
		dbSkip()	
		
	End
	
	SM0->( dbGoto( _nRecno ) )
	    
	_cOK   := Space(1)
	_cFil  := Space(2)
	_cDesc := Space(30)
	
	_oDlg := msDialog():New( 200,1, 400, 450, "Selecione as Filiais",,,,,,,, oMainWnd, .t. )

	@ 006, 005 TO 080, 223 MULTILINE MODIFY OBJECT _oMult
                                      
	@ 85,103 CHECKBOX "Selecionar"      VAR _aCheck[1] Object _oCheck1
	@ 85,143 CHECKBOX "Marcar Todos"    VAR _aCheck[2] Object _oCheck2
	@ 85,195 BMPBUTTON TYPE 01 ACTION _cFil := Confirma( _oDlg )
	
	_oCheck1:bChange := { || u_fMarcar(_oDlg, @_aCheck[1], .f. ) }
	_oCheck2:bChange := { || u_fMarcar(_oDlg, _aCheck[2], .t. ) }
	
	_oMult:nMax:= Len( aCols )
	
	ACTIVATE DIALOG _oDlg CENTERED 

	u_pushArea( _xArea ) 
	
	_cFil     := _cFil + Space( _nLen - Len( _cFil ) )
	// Atualiza variavel, caso tenha sido passada por referencia
	_cFiliais := _cFil
	If _lRet 
		Return( IIf( Empty( _cfil ), .f., .t. ) )
	EndIf 

Return( _cFil )

/*=============================================================================
|Rotina     | Confirma     | Autor  | Claudio Cavalcante    | Data | 30/10/01 |
===============================================================================
|Descrição  | Teste da funcao MULTILINE                                       |
===============================================================================
|Uso        | Clientes Microsiga                                              |
=============================================================================*/
Static Function Confirma(_oDlg)
Local _nx, _cFil := ''
	
	For _nx := 1 to len( aCols )
		If !Empty( aCols[_nx][1] )
			_cFil := _cFil + aCols[_nx][2] + ','
		EndIf
	Next
	
	If Empty( _cFil )
		MsgInfo( 'Nenhuma filial selecionada!')
	Else
		_cFil := SubStr( _cFil, 1, Len( _cFil ) -1 )
		Close( _oDlg )
	EndIf

Return( _cFil )

/*=============================================================================
|Rotina     | Marcar       | Autor  | Claudio Cavalcante    | Data | 30/10/01 |
===============================================================================
|Descrição  | Marca todos os items                                            |
===============================================================================
|Uso        | Clientes Microsiga                                              |
=============================================================================*/
User Function fMarcar( _oDlg, _lCheck, _lAll )
Local _nx, _nTam

	_nTam := Len( aCols )

	If _lAll
		For _nx:= 1 to _nTam
		    aCols[_nx][1] := IIf( _lCheck, 'X', ' ' )
		Next     
	Else
		aCols[n][1] := IIf( _lCheck, 'X', ' ' )
		_lCheck     := .f.
	EndIf
		
	DlgRefresh(_oDlg)
	ObjectMethod(_oMult:oBrowse,"Refresh()")
	
Return
/*=============================================================================
|Rotina     | fReadFilial  | Autor  | Claudio Cavalcante    | Data | 30/10/01 |
===============================================================================
|Descrição  | Marca todos os items                                            |
===============================================================================
|Uso        | Clientes Microsiga                                              |
=============================================================================*/
User Function fReadFilial( _cFiliais )
Local _nx, _cFil:= '', _nPos := 0

	While At( ",", _cFiliais ) > 0
	    _nPos     := At( ",", _cFiliais )
		_cFil     := _cFil + "'" + SubStr( _cFiliais, 1, _nPos -1 ) + "',"
		_cFiliais := SuBStr( _cFiliais, _nPos +1 )
	End
	If !Empty( _cFiliais )
		_cFil := _cFil + "'" + _cFiliais + "',"
	EndIf
	_cFil := SubStr( _cFil, 1, Len( _cFil ) -1 )
         
Return( _cFil )

/*=========================================================================
|Funcao    | RetAnos    | Autor | Claudio Cavalcante    | Data | 14/03/01  |
============================================================================
|Descricao | Retorna o número de anos utilizados na consulta               |
==========================================================================*/ 
User Function RetAnos( dDat, nMeses )
Local aPos := {}, aMes := Array(4), cAnoAtu, cAnoAnt, aScopo:= {}, nPos:= 0, nCt, nLoop
Local cString:= '' 

	nLoop := Int( nMeses/12 )
    nLoop := Iif( nLoop * 12 < nMeses, nLoop + 1, nLoop )

	For nCt:= 1 to nLoop	
		
	     aMes[2] := Month( dDat )
	     aMes[1] := 1
	     aMes[4] := If( aMes[2] < 12, 12, 0 )
	     aMes[3] := If( aMes[2] < 12, aMes[2] + 1, 0 )
	
	     cAnoAtu := StrZero( Year( dDat ), 4 )
	     cAnoAnt := StrZero( Year( dDat ) -1, 4 )
	     aScopo  := { aMes[1], aMes[2], aMes[3], aMes[4] }
	   
	     For n1:= aScopo[2] to aScopo[1] Step -1
	         nPos:= nPos + 1
	         aAdd( aPos, { n1, nPos, cAnoAtu } )
	     Next
	
	     For n1:= aScopo[4] to aScopo[3] Step -1
	         nPos:= nPos + 1
	         aAdd( aPos, { n1, nPos, cAnoAnt } )
	     Next
                       
         dDat := CtoD( '01/' + StrZero( Month( dDat ), 2 ) + '/' + StrZero( Year( dDat, 4 ) -1 ) )
       
	Next
	                                        
	aSort( aPos,,, { |x, y| x[2] < y[2] } )
	aSize( aPos , nMeses )	 
		
	aScopo := {}
	
	For nCt := 1 to nMeses
		
		n1 := aScan( aScopo, { |a| a[1] == aPos[nCt][3] } )
		
		If n1 == 0
			aAdd( aScopo, { aPos[nCt][3], { aPos[nCt][1] } } )
		Else
		    aAdd( aScopo[n1][2], aPos[nCt][1] )
		EndIf
	
	Next

	For nCt := 1 to Len( aScopo )
		cString := cString + "'" + aScopo[nCt][1] + "',"
	Next                                                              
	
	cString := Left( cString, Len( cString ) - 1 )
		 
Return( cString )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fMultiline  ³ Autor ³ Claudio Cavalcante ³ Data ³08/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Browse                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fMultiline( nTop,nLeft,nBottom,nRight,lAlter,lDeleta,cLinhaOk,nFreeze, _nOpc )
	Local aSavRot, lNeedRest := .f., _oGetDados
	Private aRotina := { { "RDMAKE" ,"SIGAIXB", 0 , If(lAlter,3,2)}}

	If Empty( _nOpc )
		_nOpc := 3
	EndIf

	If Type("aRotina") == "A"
		lNeedRest := .t.
		aSavRot := aClone(aRotina)
	EndIf


	AADD(aRotina,aClone(aRotina[1]))
	AADD(aRotina,aClone(aRotina[1]))

	_oGetDados := MsGetDados():New(nTop, nLeft, nBottom, nRight, _nOpc, cLinhaOk,,,lDeleta,,nFreeze )

	If lNeedRest
		aRotina := aClone(aSavRot)
	EndIf

Return _oGetDados


/*=========================================================================
|Funcao    | xMoeda      |Autor | Claudio               | Data | 07/02/01  |
============================================================================
|Descricao | Funcao usada para retornar se está no modo de visualização    |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
USER FUNCTION xMoeda(nValor,nMoedp,nMoedd,dData,nDecimal,nTaxap,nTaxad)
Local nValret
dData := Iif(dData == Nil,dDataBase,dData)
nDecimal:= Iif(nDecimal == Nil,2,nDecimal)
nMoedp:= Iif(nMoedp == Nil,1,nMoedp)
nMoedp:= Iif(nMoedp == 0,1,nMoedp)
nMoedd:= Iif(nMoedd == Nil,1,nMoedd)

nTaxap := Iif(nTaxap==Nil,0,nTaxap)
nTaxad := Iif(nTaxad==Nil,0,nTaxad)

If nMoedd == nMoedp
	nValRet := nValor
Else
	nValRet := (nValor * Iif (nMoedp!=1,Iif(nTaxap==0,RecMoeda(dData,nMoedp),nTaxap) ,1 ))
	nValRet := NoRound (nValRet / Iif (nMoedd!=1, Iif(nTaxad==0,RecMoeda(dData,nMoedd),nTaxad) ,1 ) ,nDecimal)
EndIf
Return (nValRet)

/*==========================================================================
|Funcao    | Chr155  | Autor | Claudio Cavalcante    | Data | 18/02/03     |
============================================================================
|Descricao | Identifica se uma string está em branco e coloca o chr(155)   |
|          |                                                               |
============================================================================
|Modulo    | Uso módulo de compras                                         |
==========================================================================*/
User Function Chr155( _cString )
Local _cRet := ''

	If Valtype( _cString ) = 'N' .and. Empty( _cString )
		_cRet := 0
	ElseIf Valtype( _cString ) = 'C'
		_cRet := rtrim( If( Empty( _cString ), '.', _cString ))
	Else
		_cRet := '.'
	EndIf
	
Return( _cRet )

/*/
========================================================================|
|Função    |SelectCar | Autor | AP5 IDE            | Data |  07/08/02   |
|==========|==================|===========================|=============|
|Descrição | Seleciona as carteiras a serem usadas                      |
|          |                                                            |
|==========|============================================================|
|Uso       | Programa principal                                         |
=========================================================================
/*/
User Function SelectCar( _oCombo )
Local _aTemp := {}, _nCt, _aListNew:= {}, _aSelect:= {}
Local _nTam := TamSx3( 'A3_CARTEIR' )[1]
Local _cCart := ''

	If cNivel < 5
		_cCart := Posicione( 'SA3', 7, FWXFilial('SA3') + __cUserId, 'A3_CARTEIR' )
	EndIf

	For _nCt:= 1 to Len( _oCombo:AITEMS )
		aAdd( _aSelect,  SubStr( _oCombo:AITEMS[_nCt], 1, _nTam ) )
	Next

	_aTemp := u_fSelCart( _aSelect, _nTam, IIf( Empty(_cCart), nil, _cCart )  )
	
	For _nCt:= 1 to Len( _aTemp )
		If _aTemp[_nCt][1]
			aAdd( _aListNew, _aTemp[_nCt][2] + '-' + Rtrim( _aTemp[_nCt][3] ) )
		EndIf
	Next
	
	If Len( _aListNew ) = 0
		_aListNew:= { '' }
	EndIf
	
	_oCombo:AITEMS:= _aListNew
 
Return

/*=========================================================================
|Funcao    | MontaCart | Autor | Claudio Cavalcante    | Data | 27/02/03   |
============================================================================
|Descricao | Prepara clausula WHERE para query                             |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function MontaCart( _aCarteiras )
	Local _nx
	Local _cCart:= ''
	
	If ValType(_aCarteiras)=="A" .And. Len(_aCarteiras) > 0
		For _nx := 1 to Len( _aCarteiras )
	        _cCart += SubStr( _aCarteiras[_nx],1, At( '-', _aCarteiras[_nx]) -1 ) + ','
		Next

		_cCart := SubStr( _cCart, 1, Len( _cCart ) -1 )
	EndIf
	
Return( _cCart )

/*=========================================================================
|Funcao    |  GetMeses  | Autor | Claudio Cavalcante    | Data | 07/03/03  |
============================================================================
|Descricao | Retorna a lista de meses para seleção em combobox             |
|          |                                                               |
============================================================================
|Modulo    | Uso genérico                                                  |
==========================================================================*/
User Function GetMeses
Local _aMeses := {}, _nCt

	For _nCt := 1 to 12
	    aAdd( _aMeses, StrZero( _nCt, 2 ) + '-' + MesExtenso( _nCt ) )
	Next
	
Return(_aMeses)

/*=========================================================================
|Funcao    |  GetAnos   | Autor | Claudio Cavalcante    | Data | 07/03/03  |
============================================================================
|Descricao | Retorna a lista de anos para seleção em combobox              |
|          |                                                               |
============================================================================
|Modulo    | Uso genérico                                                  |
==========================================================================*/
User Function GetAnos(_nAnos, _nIncr )
Local _aAnos := {}, _nCt
Local _nAno:= Year( dDataBase )
	                               
    _nAnos := If( _nAnos = nil, 4, _nAnos )
    _nIncr := If( _nIncr = nil, 0, _nIncr )
    
	_nAno += _nIncr
	_nAnos+= _nIncr

	For _nCt := _nAnos to 1 step -1
	    aAdd( _aAnos, 'Ano - ' + StrZero( _nAno, 4 ) )
	    _nAno--
	Next
	
Return(_aAnos)

/*=========================================================================
|Funcao    | PushFil   | Autor | Claudio Cavalcante    | Data | 07/03/03   |
============================================================================
|Descricao | Prepara string pra insercao em query                          |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function PushFil( _aFiliais )
Local _nx, _cFiliais := ''
      
	For _nx := 1 to Len( _aFiliais )
        _cFiliais += SubStr( _aFiliais[_nx],1, At( '-', _aFiliais[_nx]) -1 ) + ','
	Next
	
	_cFiliais := SubStr( _cFiliais, 1, Len( _cFiliais ) -1 )
	
Return( _cFiliais )

/*/
========================================================================|
|Função    |SelectFil | Autor | AP5 IDE            | Data |  07/03/03   |
|==========|==================|===========================|=============|
|Descrição | Seleciona as filiais a serem usadas                        |
|          |                                                            |
|==========|============================================================|
|Observacao| Passar parâmento por referencia                            |
|==========|============================================================|
|Uso       | Programa principal                                         |
=========================================================================
/*/
User Function SelectFil( _oCombo )
Local _aTemp := {}, _nCt, _aListNew:= {}, _aSelect:= {}

	For _nCt:= 1 to Len( _oCombo:AITEMS )
		aAdd( _aSelect,  cEmpAnt + SubStr( _oCombo:AITEMS[_nCt], 1, FWSizeFilial() ) )
	Next

	_aTemp := u_fSelFil( .t., _aSelect )
	
	For _nCt:= 1 to Len( _aTemp )
		If _aTemp[_nCt][1]
			aAdd( _aListNew, _aTemp[_nCt][2] + '-' + Rtrim( _aTemp[_nCt][3] ) )
		EndIf
	Next
	                          
	If Len( _aListNew ) = 0
		_aListNew:= { '' }
	EndIf
	
	_oCombo:AITEMS:= _aListNew
    
Return

/*==========================================================================
|Funcao    | Recycle    | Autor | Claudio Cavalcante    | Data | 07/03/03  |
============================================================================
|Descricao | Apaga arquivos temporários e fecha área de trabalho           |
|          |                                                               |
============================================================================
|Modulo    | Uso genérico                                                  |
==========================================================================*/
User Function Recycle( _aArea, _lMantem )
	Local _nCt 
	Local _cDbFile
	Local _cOrdFile

	Default _lMantem := .F.
	Default _aArea   := {}
	                                          
	For _nCt:= 1 to Len( _aArea )
		If (!Empty( _aArea[_nCt][1] )) .And. Select(_aArea[_nCt][1]) > 0
			If Len(_aArea[_nCt]) >= 2 .And. !_lMantem
				_cOrdFile := &(_aArea[_nCt][1])->(_aArea[_nCt][2] + OrdBagExt() )
				_cDbFile  := &(_aArea[_nCt][1])->(_aArea[_nCt][2] + GetDbExtension() )
			Else  
				_cOrdFile := ""
				_cDbFile  := ""
			EndIf        
			
			&(_aArea[_nCt][1])->( dbCloseArea() )
			
			If !Empty(_cOrdFile)
				fErase(_cOrdFile)
			Endif                                
			
			If !Empty(_cDbFile)
				fErase(_cDbFile)
			Endif
		EndIf
	Next
	
Return

/*=========================================================================
|Funcao    | PushUF    | Autor | Claudio Cavalcante    | Data | 21/03/03   |
============================================================================
|Descricao | Prepara string pra insercao em query                          |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function PushUf(_aUf )
Local _nx, _cUf:= ''
      
	For _nx := 1 to Len( _aUF )
        _cUf += SubStr( _aUf[_nx],1, At( '-', _aUf[_nx]) -1 ) + ','
	Next
	
	_cUf := SubStr( _cUf, 1, Len( _cUf ) -1 )
	
Return( _cUf )

/*=========================================================================
|Funcao    | IsDetour   | Autor | Raimundo Santana      | Data | 22/07/09  |
============================================================================
|Descricao | Função para definir se deve fazer o desvio de e-mail para o   |
|          | administrador					                               |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function IsDetour()
	Local _lRet
	
	_lRet := ( GetNewPar( 'MV_WFDETOU', 'N' ) = 'S' .Or. !U_IsSrvProd() )

Return _lRet

/*=========================================================================
|Funcao    | PushDetour | Autor | Claudio Cavalcante    | Data | 11/07/03  |
============================================================================
|Descricao | Retorno o email do administrador                              |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function PushDetour( _cEmail, _lDetour )
	Local _cRet := ''
	Local _cUsrMail
	
	Default _lDetour := .F.
                       
	If _lDetour .Or. U_IsDetour()
		_cRet := GetNewPar( 'MV_WFEMAIL',AllTrim(UsrRetMail('000000')))

		If U_IsSrvProd() .Or. "|"+__cUserId+"|" $ GetNewPar('MV_WFCDUBT','')
			_cUsrMail := AllTrim(UsrRetMail( __cUserId ))
			
			If !(_cUsrMail $ _cRet)
				_cRet += IIF(Empty(_cRet),'',';')+_cUsrMail
			EndIf
		EndIf
	Else
		_cRet := _cEmail
	EndIf
	
Return( _cRet )  

/*=========================================================================
|Funcao    |  GetDias   | Autor | Claudio Cavalcante    | Data | 24/09/03  |
============================================================================
|Descricao | Retorna a lista de dias para seleção em combobox de um        |
|          | determinado mes do ano                                        |
============================================================================
|Modulo    | Uso genérico                                                  |
==========================================================================*/
User Function GetDias( _cMes, _cAno )
Local _aDias := {}, _nCt, _nLast
	                            
	_nLast := Day( u_Eom( cTod( '01/' + _cMes +'/' + _cAno, 'ddmmyyyy' ) ) )
    
	For _nCt := _nLast to 1 step -1
	    aAdd( _aDias, 'Dia - ' + StrZero( _nCt, 2 ) )
	Next
	
	aAdd( _aDias, 'Todos' ) 

	aSort( _aDias,,, { |x, y| x < y } )
	
Return(_aDias)

/*==========================================================================
|Funcao    |  fBissexto | Autor | Claudio Cavalcante    | Data | 29/11/05  |
============================================================================
|Descricao | Retorna se o ano é bissexto ou nao                            |
|          | determinado mes do ano                                        |
============================================================================
|Modulo    | Uso genérico                                                  |
==========================================================================*/
User Function fBissexto( _nAno )
Local _lAno
            
	If _nAno = nil 
		_nAno := Year( Date() )
	EndIf
     _lAno := .f.
     If (_nAno % 4 = 0 .And. _nAno % 100 <> 0) .Or. (_nAno % 400 = 0)
        _lAno := .t.
     EndIf
     
Return _lAno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CODBARVL2 ºAutor  ³Claudio D. de Souza º Data ³  14/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar o codigo de barras ou a linha digitavel de titulos º±±
±±º          ³ a pagar ou a receber                                       º±±
±±º          ³ Parametros: cCodBar - Codigo de barras ou linha digitavel  º±±
±±º          ³ Retorno   : aRet    - Matriz com os retornos possiveis     º±±
±±º          ³             aRet[1] - 0 Codigo de barras de titulos/Boletosº±±
±±º          ³                       1 Codigo de barras de concessionariasº±±
±±º          ³                       2 Linha digitavel de titulos/Boletos º±±
±±º          ³                       3 Linha digitavel de concessionarias º±±
±±º          ³             aRet[2] - .T. Codigo de barras ou linha digita-º±±
±±º          ³                           vel validos                      º±±
±±º          ³                       .F. Caso contrario                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BARRAS(cCodBar)
	Local lRet := .T.,;
		nX			  ,;
		cCampo     ,;
		nRet := 0

	Default cCodBar := Alltrim(M->E2_CODBAR)

//cCodBar := Alltrim(cCodBar) . Isso estava no programa original.
// Completa o tamanho do codigo de barras se ele for menor que 44 por se tratar de uma
// linha digitavel.
	If Len(cCodBar) < 44
		cCodBar := Left(cCodBar+Replicate("0", 48-Len(cCodBar)),47)
	Endif

	Do Case
	Case Len(cCodBar)==44 // Validacao do codigo de Barras
		// Boletos
		nRet := 0
		// Se nao conseguir validar o DV do codigo de barras, tenta validar como
		// se fosse titulo de concessionaria.
		If Dv_BarCode(Left(cCodBar,4)+SubStr(cCodBar,6))!=SubStr(cCodBar,5,1)
			nRet := 1 // Codigo de barras de concessionarias
			// Concessionarias
			If Mod10(Left(cCodBar,3)+SubStr(cCodBar,5))!=SubStr(cCodBar,4,1)
				lRet := .F. // Invalido
			Endif
		Endif
	Case Len(cCodBar)==47 // Validacao da linha digitavel
		nRet := 2
		// Elimina os digitos
		cCodSemDv := Left(cCodBar,9)+SubStr(cCodBar,11,10)+SubStr(cCodBar,22,10)
		// Calcula os digitos e os compara com os digitos informados
		For nX := 1 To 3
			cCampo := SubStr(cCodSemDv,If(nX==1,1,If(nX==2,10,20)),If(nX==1,9,10))
			If Mod10(cCampo) != SubStr(cCodBar,If(nX==1,10,If(nX==2,21,32)),1)
				help(" ",1,"INVALCODBAR")
				lRet := .F.
//			Exit
			Endif
		Next
	OtherWise // Validacao da linha digitavel de concessionarias
		nRet := 3
		// Elimina os digitos
		cCodSemDv := Left(cCodBar,11)+SubStr(cCodBar,13,11)+SubStr(cCodBar,25,11)+SubStr(cCodBar,37,11)
		// Calcula os digitos e os compara com os digitos informados
		For nX := 1 To Len(cCodSemDv) Step 11
			cCampo := SubStr(cCodSemDv,nX,11)
			If Mod10(cCampo) != SubStr(cCodBar,nX+If(nX==1,11,12),1)
				lRet := .F.
				help(" ",1,"INVALCODBAR")
//			Exit
			Endif
		Next
	EndCase
Return {nRet,lRet}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³Dv_BarCodeºAutor  ³Claudio D. de Souza º Data ³  14/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula o digito verificador de um codigo de barras padrao  º±±
±±º          ³Febraban.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CodBarVl2                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DV_BarCode( cBarCode )
	Local cDig     ,;
		nPos     ,;
		nAux := 0

	For nPos := 1 To 43
		nAux += Val(SubStr(cBarCode,nPos,1)) * If( nPos<= 3, ( 5-nPos),     ;
			If( nPos<=11, (13-nPos),     ;
				If( nPos<=19, (21-nPos),     ;
					If( nPos<=27, (29-nPos),     ;
						If( nPos<=35, (37-nPos),     ;
							(45-nPos) )))))
					Next
					nAux := nAux % 11
					cDig := If( (11-nAux)>9, 1, (11-nAux) )

					Return StrZero( cDig, 1 )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³Mod10     ºAutor  ³Claudio D. de Souza º Data ³  14/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula o digito verificador de uma sequencia de numeros    º±±
±±º          ³baseando-se no modulo 10. Utilizado para verificar o digito º±±
±±º          ³em linhas digitaveis e codigo de barras de concessionarias  º±±
±±º          ³de servicos publicos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CodBarVl2                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Mod10( cNum )
	Local nFor    := 0,;
		nTot    := 0,;
		cNumAux

	If Len(cNum)%2 #0
		cNum := "0"+cNum
	EndIf

	For nFor := 1 To Len(cNum)
		If nFor%2 == 0
			cNumAux := StrZero(2 * Val(SubStr(cNum,nFor,1)), 2)
		Else
			cNumAux := StrZero(Val(SubStr(cNum,nFor,1))    , 2)
		Endif
		nTot += ( Val(LEFT(cNumAux,1)) + Val(Right(cNumAux,1)) )
	Next

	nTot := nTot % 10
	nTot := If( nTot#0, 10-nTot, nTot )

Return StrZero(nTot,1)

User Function RetQuery( _cQuery )
Return( _cQuery )


/*=========================================================================
|Procedure | fGetFilial  |Autor | Marcos                | Data | 18/02/01  |
============================================================================
|Descricao | Retorna do arquivo empresa SIGAMAT um determinado campo       |
|          | especificado em cCampo                                        |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fGetFilial( cEmpresa, cFil, cCampo )
Local bCampo, cRet:= '', _xArea := {}

	If Empty( cEmpresa )
		cEmpresa := SM0->M0_CODIGO
	EndIf
                                     
	aAdd( _xArea, SM0->( GetArea() ) )
	aAdd( _xArea, GetArea() ) 
		
    dbSelectArea( 'SM0' )
   	nOrdem := SM0->( IndexOrd() )
	nRec   := SM0->( RecNo() )
    If dbSeek( cEmpresa + cFil )
		bCampo:= FieldwBlock( cCampo, Select('SM0') )
		cRet  := Eval( bCampo )
    EndIf
                              
	u_PushArea( _xArea )
		
Return( cRet )

/*=========================================================================
|Procedure | fIsExec     |Autor | Raimundo Santana      | Data | 27/04/06  |
============================================================================
|Descricao | Verifica se uma função está sendo executada verificando a     |
|          | pilha de chamadas											   |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fIsExec( _cFuncao )
Local _lRet := .F.
Local _cProc
Local _nIndex := 0

	Default _cFuncao := ''

	_cFuncao := Upper(Trim(_cFuncao))
	
	//Se não passou nenhuma funcao não execute e retorne .F.
	_cProc := _cFuncao
	Do While (!Empty(_cProc)) .And. !_lRet
		 _cProc := Upper(Trim(ProcName(_nIndex++)))           

		 _lRet:=( _cProc==_cFuncao )
	EndDo		 
Return _lRet

/*=========================================================================
|Procedure | fCtExec     |Autor | Raimundo Santana      | Data | 27/04/06  |
============================================================================
|Descricao | Retorna o número de vezes que uma função está sendo executada |
|          | verificando a pilha de chamadas							   |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fCtExec( _cFuncao )
Local _cProc
Local _nIndex := 0
Local _nRet   := 0

	Default _cFuncao := ''

	_cFuncao := Upper(Trim(_cFuncao))
	
	//Se não passou nenhuma funcao não execute e retorne 0
	_cProc := _cFuncao
	Do While !Empty(_cProc)
		 _cProc := Upper(Trim(ProcName(_nIndex++)))           
		 If  _cProc==_cFuncao
		 	_nRet++
		 EndIf   
	EndDo		 
Return _nRet

/*=========================================================================
|Funcao    | fStrManad   |Autor | Claudio               | Data | 21/09/06  |
============================================================================
|Descricao | Funcao usada para retornar um valor em string, conforme       |
|          | picture definida                                              |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fStrManad( _nValor, _cPicture )
Local _cRet   := ''
Local _nResto := 0 
Local _cPictTmp := StrTran( _cPicture, ".", "9" )

	_nValor := Abs( _nValor * 100)
	_nResto := _nValor - Int( _nValor )

	If _nValor = 0
		_cRet     := '0'
	ElseIf _nResto = 0
		_cRet     := Transform( _nValor, _cPictTmp )
	Else
		_cRet     := StrTran( Transform( _nValor, _cPictTmp ), ".", "," )
	EndIf

Return( _cRet )

/*==========================================================================
|Funcao    | ConfigSx1	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Ajusta o dicionario de perguntas SX1 						   |
|          | Cadastra e/ou atualiza as perguntas necessárias a rotina      |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function ConfigSx1(_cPerg,_aPerg)
	Local _aConf    := {}
	Local _nCt
	Local _lInc
	Local _lAlt     
	Local _cKey
	Local _aHelpPor	:= {}
	Local _aHelpEng	:= {}
	Local _aHelpSpa	:= {}
	Local _aRegs    := {}
	Local _nAreaSX1 := 0

	If ! Select("SX1") > 0
		DbSelectArea('SX1')
	EndIf
	
	_nAreaSX1 := Select("SX1")
		
	_cPerg := PadR(_cPerg,Len(SX1->X1_GRUPO))

	aAdd(_aConf,{ FieldWBlock("X1_GRUPO",_nAreaSX1),	{|| _cPerg }, 		    .F.,  0 } )
	aAdd(_aConf,{ FieldWBlock("X1_ORDEM",_nAreaSX1),	{|| StrZero(_nCt,2) },  .T.,  0 } )
	aAdd(_aConf,{ FieldWBlock("X1_PERGUNT",_nAreaSX1),	{|| _aPerg[_nCt][1] },  .T.,  1 } )
	aAdd(_aConf,{ FieldWBlock("X1_VARIAVL",_nAreaSX1),	{|| _aPerg[_nCt][2] },  .T.,  2 } )
	aAdd(_aConf,{ FieldWBlock("X1_TIPO",_nAreaSX1),		{|| _aPerg[_nCt][3] },  .T.,  3 } )
	aAdd(_aConf,{ FieldWBlock("X1_TAMANHO",_nAreaSX1),	{|| _aPerg[_nCt][4] },  .T.,  4 } )
	aAdd(_aConf,{ FieldWBlock("X1_DECIMAL",_nAreaSX1),	{|| _aPerg[_nCt][5] },  .T.,  5, 0 } )
	aAdd(_aConf,{ FieldWBlock("X1_PRESEL",_nAreaSX1),	{|| _aPerg[_nCt][6] },  .F.,  6, 0 } )
	aAdd(_aConf,{ FieldWBlock("X1_GSC",_nAreaSX1),		{|| _aPerg[_nCt][7] },  .T.,  7, "G" } )
	aAdd(_aConf,{ FieldWBlock("X1_VALID",_nAreaSX1),	{|| _aPerg[_nCt][8] },  .T.,  8, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_VAR01",_nAreaSX1),	{|| _aPerg[_nCt][9] },  .T.,  9, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEF01",_nAreaSX1),	{|| _aPerg[_nCt][10] }, .T., 10, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFSPA1",_nAreaSX1),	{|| _aPerg[_nCt][10] }, .T., 10, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFENG1",_nAreaSX1),	{|| _aPerg[_nCt][10] }, .T., 10, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEF02",_nAreaSX1),	{|| _aPerg[_nCt][11] }, .T., 11, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFSPA2",_nAreaSX1),	{|| _aPerg[_nCt][11] }, .T., 11, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFENG2",_nAreaSX1),	{|| _aPerg[_nCt][11] }, .T., 11, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEF03",_nAreaSX1),	{|| _aPerg[_nCt][12] }, .T., 12, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFSPA3",_nAreaSX1),	{|| _aPerg[_nCt][12] }, .T., 12, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFENG3",_nAreaSX1),	{|| _aPerg[_nCt][12] }, .T., 12, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEF04",_nAreaSX1),	{|| _aPerg[_nCt][13] }, .T., 13, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFSPA4",_nAreaSX1),	{|| _aPerg[_nCt][13] }, .T., 13, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFENG4",_nAreaSX1),	{|| _aPerg[_nCt][13] }, .T., 13, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEF05",_nAreaSX1),	{|| _aPerg[_nCt][14] }, .T., 14, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFSPA5",_nAreaSX1),	{|| _aPerg[_nCt][14] }, .T., 14, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_DEFENG5",_nAreaSX1),	{|| _aPerg[_nCt][14] }, .T., 14, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_F3",_nAreaSX1),		{|| _aPerg[_nCt][15] }, .T., 15, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_CNT01",_nAreaSX1),	{|| _aPerg[_nCt][16] }, .F., 16, "" } )
	aAdd(_aConf,{ FieldWBlock("X1_PICTURE",_nAreaSX1),	{|| _aPerg[_nCt][17] }, .T., 17, "" } )
	aAdd(_aConf,{ {|xVal|IIF(xVal==NIL,_aHelpPor,_aHelpPor:=xVal) }, {|| _aPerg[_nCt][18] }, .F., 18, {} } )
	aAdd(_aConf,{ {|xVal|IIF(xVal==NIL,_aHelpSpa,_aHelpSpa:=xVal) }, {|| _aPerg[_nCt][19] }, .F., 19, {} } )
	aAdd(_aConf,{ {|xVal|IIF(xVal==NIL,_aHelpEng,_aHelpEng:=xVal) }, {|| _aPerg[_nCt][20] }, .F., 20, {} } )
	
	For _nCt := 1 To Len(_aPerg)                   
		_lAlt:=.F.
		_lInc := !SX1->( DbSeek(_cPerg+StrZero(_nCt,2)) )

		If !_lInc
			_lAlt:=( aScan(_aConf,{|_aItem| IIF(_aItem[3], ConfComp(_aPerg[_nCt],_aItem),.F.) } ) > 0 )
		EndIf
		
		If _lInc .Or. _lAlt
			If RecLock("SX1",_lInc)     
				AEval(_aConf,{|_aItem| Eval(_aItem[1],IIF(Len(_aPerg[_nCt])>=_aItem[4],Eval(_aItem[2]),_aItem[5])) } )

				//Chave para gravar o Help
				_cKey := "P."+AllTrim(_cPerg)+AllTrim(StrZero(_nCt,2))+"."

				//Limpa o help atual
				PutSX1Help(_cKey,,,,.T.)

				//Grava novo help
				If Len(_aHelpPor) > 0 .Or. Len(_aHelpEng) > 0 .Or. Len(_aHelpSpa) > 0
					PutSX1Help(_cKey,_aHelpPor,_aHelpEng,_aHelpSpa,.T.)
				EndIf
				
				SX1->( MsUnLock() )
			EndIf
		EndIf

		AAdd(_aRegs, { SX1->(RecNo()), SX1->X1_ORDEM } )
	Next _nCt

	SX1->( DbSeek( _cPerg ) )             
	
	Do While !SX1->(Eof()) .And. SX1->X1_GRUPO==_cPerg
		//Verifica se não é um registro valido
		If aScan(_aRegs,{|aItem| aItem[1] == SX1->(RecNo()) })==0
			If RecLock("SX1",.F.)
				//Verifica se a ordem não está em uso
				If aScan(_aRegs,{|aItem| aItem[2] == SX1->X1_ORDEM } )==0
					//Chave para limpar o Help
					_cKey := "P."+AllTrim(_cPerg)+AllTrim(StrZero(_nCt,2))+"."

					//Limpa o help atual
					PutSX1Help(_cKey,,,,.T.)
				EndIf
			
				SX1->( DbDelete() )

				SX1->( MsUnLock() )
			EndIf           
		EndIf
		
		SX1->( DbSkip() )
    EndDo
Return .T.                               

/*==========================================================================
|Funcao    | ConfComp	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Compara Configuracões para ConfigSx1						   |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
Static Function ConfComp(_aItPerg,_aItConf)
	Local _lRet      
	Local _xVal1
	Local _xVal2
	
	_xVal1 := Eval(_aItConf[1])
	
	If Len(_aItPerg) >= _aItConf[4]
		_xVal2 := Eval(_aItConf[2])
	Else
		_xVal2 := _aItConf[5]
	EndIf
	
	If ValType(_xVal1)=="C"
		_xVal2 := Left(_xVal2,Len(_xVal1))
	EndIf
	
	_lRet:=!ValComp(_xVal1,_xVal2)
	
Return _lRet
			
/*==========================================================================
|Funcao    | ValComp	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Compara valores de duas variáveis levando em conta o tipo	   |
|          | Nas strings será retirado os espaços a direita para comparar  |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
Static Function ValComp(_xVal1,_xVal2,_lStrict)
  Local _lRet := .F.
  Local _nCt
  Local _nTam
  
  Default _lStrict := .T.

  Do Case
  	Case ValType(_xVal1)=="C"   
	  	_lRet:=( RTrim(_xVal1)==RTrim(_xVal2) )
  	Case ValType(_xVal1)=="A" 
  		For _nCt:=1 To Len(_xVal1)
  			If _xVal1[_nCt] != _xVal2[_nCt]
  				Exit
  			EndIf
			_lRet := .T.
  		Next
  	Otherwise
  		_lRet:=( _xVal1 == _xVal2 )
  EndCase
Return _lRet

/*==========================================================================
|Funcao    | StrToBlock	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Converte uma string no codeblock equivalente para retorna-la  |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function StrToBlock(_cStr)
Local _cRet := _cStr

Return {|| _cRet }

/*==========================================================================
|Funcao    | SoNumeros	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Verifica se a variavel contem somente numeros				   |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function SoNumeros(cStr)
	Local lRet
	Local nCt     
	Local cCh

	lRet := !Empty(cStr) 	
	
	For nCt:=1 To Len(cStr)
		cCh:=SubStr(cStr,nCt,1)
		If cCh < '0' .Or. cCh > '9'
			lRet:=.F.
			Exit
		EndIf
	Next     
return lRet      

/*==========================================================================
|Funcao    | VrfStChr	        | Raimundo Santana      | Data | 10/07/12  |
============================================================================
|Descricao | Verifica se a variavel contem somente os especificados na 	   |
|          | validação.													   |
============================================================================
|Parametros| cStr     : String a verificar caracter a caracter             |
|			 xChValid : Code Block para validar o caracter ou uma string   |
|                       com as validações conforme regras a baixo:         |
|																		   |
|						Operadores:										   |
|			            a) >,>=,<,<=									   |
|                          Aplica as comparações conforme simbolo para um  |
|						   caracter. Ex.: >A,<Z                            |
|						b) !											   |
|                          Simbolo de negação, equivale a <> ou != e pode  |
|			               ser aplicado a um caracter ou a uma lista de    |
|                          caracteres. Ex.: !A,![A-B],!{ABC}               |
|																		   |
|						Estruturas de controle:							   |
|			            a) ()								   			   |
|                          Abre ou fecha parenteses de forma a permitir    |
|						   a definição de regras complexas. 			   |
|                          Ex.: (>A & <Z) | (>a & <z)                      |
|																		   |
|						Estruturas de associação:						   |
|			            a) &								   			   |
|                          Efetua o AND entre as regras. Ex.: (>A & <Z)    |
|			            b) |								   			   |
|                          Efetua o OR entre as regras. Ex.: [A-Z]|[a-z]   |
|																		   |
|						Faixas e Listas:								   |
|						a) [A-B],[A-],[-B]                                 |
|                          Define uma lista por faixa de caracteres onde   |
|						   A é o caracter inicial e B o final. Na falta de |
|                          um dos limites é convertido em >=A para [A-] e  |
|                          <=B para [-B]. Ex.: [A-Z],[a-z]                 |
|						b) {ABC}                                           |
|                          Define uma lista específica de caracteres, onde |
|                          A,B e C são os caracteres da lista, podem ser   |
|						   definida uma sequencia de vários caracteres na  |
|                          lista. Ex. {ABCabc}                             |
|																		   |
|						Caracteres de Controle:							   |
|						a) \                                               |
|                          Caracter de proteção que pode ser utilizado em  |
|                          listas, permitindo a inclusão de caracteres ou  |
|                          simbolos, sempre define o caracter a seguir.    |
|                          Ex. {+-\\\}} (lista onde \\ é equivalente ao    |
|                              caracter "\" e \} ao caracter "}").         |
|						b) #                                               |
|                          Caracter de proteção que converte o número a    |
|                          seguir em seu caracter equivalente na tabela    |
|                          ASCII. Ex.: #13,#65 (#13 = Cariage Return e     |
|                                      #65 = "A").                         |
|																		   |
|						Regras gerais:									   |
|						a) Para representar o espaço em branco utilize     |
|						   \ antes Ex.: "\ " ou #32                        |
|						a) Todos os espaços entre caracteres e regras não  |
|                          protegidos com a \ serão ignorados              |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function VrfStChr(cStr,xChValid)
	Local lRet
	Local nCt     
	Local cCh
	Local bValid

	If ValType(xChValid)=="B"
		bValid=xChValid
	Else      
		bValid=StrChCnv(xChValid,0)
	EndIf

	lRet := !Empty(cStr) 	

	For nCt:=1 To Len(cStr)       
		If !Eval(bValid,SubStr(cStr,nCt,1))
			lRet:=.F.
			Exit
		EndIf
	Next     
return lRet 

Static Function StrChCnv(cRegras,nNivPar)
	Local bRet 	  := {|| .F. }
	Local cValid
	Local cOper
	Local cLista
	Local aFaixa
	Local nTipo
	Local lErro   := .F.

	Default nNivPar := 0
	
	cRegras := AllTrim(cRegras)

	cValid    := ""	
	
	Do While !Empty(cRegras)
		cStr := Left(cRegras,1)
		
		Do Case       
			Case cStr $ "("
			    cRegras := AllTrim(SubStr(cRegras,2)) 

				cValid += "("

			    cValid += StrChCnv(@cRegras,nNivPar+1)

			    If Left(cRegras,1)==")"
				  cValid += ")"
				  cRegras:=AllTrim(SubStr(cRegras,2))
				Else
				  lErro := .T.
				Endif
			Case cStr $ ")"
				If lNivPar<=0
				  lErro := .T.
				Endif         
				
				Exit
			Case cStr $ "><"                           
			    cOper := cStr

			    If SubStr(cRegras,2,1)=="="
				  cOper += "="
				  cRegras := AllTrim(SubStr(cRegras,3))
				Else 
				  cRegras := AllTrim(SubStr(cRegras,2))
				EndIf

				cLista := StrChVal(@cRegras)

				cValid += "(cCh" + cOper + cLista + ")"
			Case cStr = "!"
			    cOper := cStr
			    
			    cRegras := AllTrim(SubStr(cRegras,2))

			    If SubStr(cRegras,2,1)=="["
					aFaixa := StrChFxa(@cRegras)             

					cValid += "!("
					If !Empty(aFaixa[1])             
						If Upper(Left(aFaixa[1],4))=="CHR("
						  cValid+="cCh>="+aFaixa[1]
						Else
						  cValid+="cCh>="+Chr(34)+aFaixa[1]+Chr(34)
						Endif
					Endif
					If !Empty(aFaixa[2])
						If !Empty(aFaixa[1])
						  cValid+=".And."
						Endif
						If Upper(Left(aFaixa[2],4))=="CHR("
						  cValid+="cCh<="+aFaixa[2]
						Else
						  cValid+="cCh<="+Chr(34)+aFaixa[2]+Chr(34)
						Endif
					Endif
					cValid += ")"
			    Else
					cLista := StrChLst(@cRegras)

					cValid += ".And.!(cCh$" + cLista + ")"
				EndIf
			Case cStr = "["
				aFaixa := StrChFxa(@cRegras)             

				cValid += "("
				If !Empty(aFaixa[1])
					If Upper(Left(aFaixa[1],4))=="CHR("
					  cValid+="cCh>="+aFaixa[1]
					Else
					  cValid+="cCh>="+Chr(34)+aFaixa[1]+Chr(34)
					Endif
				Endif
				If !Empty(aFaixa[2])
					If !Empty(aFaixa[1])
					  cValid+=".And."
					Endif
					If Upper(Left(aFaixa[2],4))=="CHR("
					  cValid+="cCh<="+aFaixa[2]
					Else
					  cValid+="cCh<="+Chr(34)+aFaixa[2]+Chr(34)
					Endif
				Endif
				cValid += ")"
			Case cStr = "{"
				cLista := StrChLst(@cRegras)

				cValid += "(cCh$" + cLista + ")"
		    OtherWise
		    	lErro := .T.
		End Case

		cRegras := AllTrim(cRegras)
		
		If !Empty(cRegras)  
			Do Case 
			  Case Left(cRegras,1)=="&"
			    cRegras:=AllTrim(SubStr(cRegras,2))

			    cValid += ".And."
			  Case Left(cRegras,1)=="|"
			    cRegras:=AllTrim(SubStr(cRegras,2))

			    cValid += ".Or."
			  OtherWise
			    lErro := .T.
			EndCase
		Endif
	End Do

    If lErro
      bRet := NIL
    Else	
	  If !Empty(cValid)
		bRet := MontaBlock("{|cCh| "+cValid+" }")
	  EndIf
	Endif
Return bRet 

Static Function StrChLst(cRegras)
	Local cRet 	 := ''
	Local cVal
	Local lErro  := .F.

	cRegras := Alltrim(cRegras)
	
	If (Left(cRegras,1)=="{")
	  cRegras+=SubStr(cRegras,2)

	  Do While !Empty(cRegras) .And. Left(cRegras,1)<>"}"      
	  	  cVal := StrChVal(@cRegras)
	  	  
	  	  If Upper(SubStr(cVal,1,4))=="CHR("
  		    cRet += '"+'+cVal+'+"'
	  	  Else
  		    cRet += cVal
  		  EndIf
	  End Do

	  If Left(cRegras,1)=="}"
	    cRegras := SubStr(cRegras,2)
      Else 
    	lErro := .T.
	  EndIf
	Else
	  cVal := StrChVal(@cRegras)

  	  If Upper(SubStr(cVal,1,4))=="CHR("
	    cRet += '"+'+cVal+'+"'
  	  Else
	    cRet += cVal
	  EndIf
	Endif

	If lErro
	  cRet := NIL
	Else
  	  If !(cRet=='')
 	    cRet := '"'+cRet+'"'
  	    cRet := StrTran(cRet,'""+','')
	    cRet := StrTran(cRet,'+""','')
	  EndIf
	Endif
Return cRet

Static Function StrChFxa(cRegras)
	Local aRet 	 := {"",""}
	Local cVal
	Local lErro  := .F.

	cRegras := Alltrim(cRegras)
	
	If (Left(cRegras,1)=="[")
      cRegras:=AllTrim(SubStr(cRegras,2))
	  
	  If Left(cRegras,1)!="-"
	  	  aRet[1] := StrChVal(@cRegras)
	  EndIf

	  If Left(cRegras,1)=="-"
	    cRegras:=AllTrim(SubStr(cRegras,2))
	  Else 
	    lErro := .T.
	  Endif
	  
	  If Left(cRegras,1)<>"]"
	  	  aRet[2] := StrChVal(@cRegras)
	  Endif

	  If Left(cRegras,1)=="]"
	    cRegras:=AllTrim(SubStr(cRegras,2))
	  Else 
	    lErro := .T.
	  EndIf	  
    Else 
	  lErro := .T.
	Endif
	
	If lErro
	  aRet := NIL
	EndIf
	
Return aRet

Static Function StrChVal(cRegras)
	Local cRet   := "" 
	Local lErro  := .F.
	
	cRegras := AllTrim(cRegras)

	Do Case
	  Case SubStr(cRegras,1,1)=="\"
	    cRet := SubStr(cRegras,2,1)
	    
	    If cRegras==""
	      lErro := .T.
	    Else
          cRet += Left(cRegras,1)
	      cRegras := AllTrim(SubStr(cRegras,2))
	    EndIf
	  Case SubStr(cRegras,1,1)=="#"
	    cRegras := SubStr(cRegras,2)

	    Do While Left(cRegras,1)>='0' .And. Left(cRegras,1)<='9'
	      cRet += Left(cRegras,1)

	      cRegras := SubStr(cRegras,2)
	    End Do

	    cRegras := AllTrim(cRegras)

	    If cRet==""
	      lErro := .T.
	    Else
  	      cRet := "Chr("+cRet+")"
  	    Endif
	  Otherwise
	    If cRegras==""
	      lErro := .T.
	    Else
          cRet += Left(cRegras,1)
        
          If cRet == '"' 
	        cRet := "Chr(34)"
	      Endif

          cRegras := SubStr(cRegras,2)
		Endif          
	End Case	    
	
	If lErro
	  cRet := NIL
	Endif
	
Return cRet

User Function IsListVld(cLista,xSep,bVldItem,nItemErro)
	Local lRet := .T.
	Local nCt
	Local nPos  
	Local cItem
	
	Default xSep 		:= ','       
	Default bVldItem	:= {|| .T. }

	nItemErro := 0
	cLista 	  := AllTrim(cLista) 
	
	If !Empty(cLista)
		lRet := .T.

		nCt := 1		

		Do While !Empty(cLista)
			If ValType(xSep)=="C"
				nPos:=At(xSep,cLista)                                 
			Else
				nPos:=IIF(Len(cLista) > xSep,xSep,0)
			EndIf
			
			If nPos==0  
				cItem  := cLista
				cLista := ""
			Else
				cItem  := Left(cLista,nPos-IIF(ValType(xSep)=="C",1,0))
				cLista := SubStr(cLista,nPos+1)
			EndIf                  

			If Empty(cItem)
				lRet := .F.
				Exit
			EndIf
			
			If !Eval(bVldItem,cItem)
				lRet := .F.
				Exit
			EndIf
			
			nCt++
		EndDo

		If lRet .And. nPos!=0 .And. Empty(cLista)  
			lRet := .F.
		EndIf
		
		If !lRet
			nItemErro := nCt
		EndIf
	EndIf

return lRet

User Function ConvList(cLista,xSep,bConv,lToArray,cNewSep)
	Local xRet
	Local nPos  
	Local cItem
	
	Default xSep 	 := ','       
	Default bConv	 := {|cItem| cItem }
	Default lToArray := .F. 
	
	If ValType(xSep) == "C"
		Default cNewSep  := xSep           
	Else
		Default cNewSep  := ""
	EndIf
                                     
	If lToArray
		xRet := {}
	Else
		xRet := ""
	EndIf
	
	cLista := AllTrim(cLista) 
	
	If !Empty(cLista)
		Do While !Empty(cLista)
			If ValType(xSep)=="C"
				nPos:=At(xSep,cLista)                                 
			Else
				nPos:=IIF(Len(cLista) > xSep,xSep,0)
			EndIf
			
			If nPos==0  
				cItem  := cLista
				cLista := ""
			Else
				cItem  := Left(cLista,nPos-IIF(ValType(xSep)=="C",1,0))
				cLista := SubStr(cLista,nPos+1)
			EndIf  			

			If lToArray
				AAdd(xRet,Eval(bConv,cItem))
			Else
				xRet+=IIF(Empty(xRet),"",cNewSep)+Eval(bConv,cItem)
			EndIf
		EndDo
	EndIf

return xRet

User Function ArrayToLst(aLista,cSep,bConv,bFiltra)
	Local cRet := ""     
	
	Default cSep    := ","
	Default bConv   := { |xItem| cVar }       
	Default bFiltra := { |xItem| .T. }       
	
	AEval(aLista,{ |xItem| If(Eval(bFiltra,xItem),cRet+=Eval(bConv,xItem)+cSep,) } )
	
	If !Empty(cRet)
		cRet := Left(cRet,Len(cRet)-Len(cSep))
	EndIf
Return cRet

User Function ListItem(cLista,nItem,xSep,bConv)
	Local xRet
	Local nPos  
	Local nCt
	Local cItem
	
	Default xSep 	 := ','       
	Default bConv	 := {|cItem| cItem }
                                     
	cLista := AllTrim(cLista) 
	
	If !Empty(cLista)
		nCt := 1
		
		Do While !Empty(cLista)
			If ValType(xSep)=="C"
				nPos:=At(xSep,cLista)                                 
			Else
				nPos:=IIF(Len(cLista) > xSep,xSep,0)
			EndIf

			If nPos==0  
				cItem  := cLista
				cLista := ""
			Else
				cItem  := Left(cLista,nPos-IIF(ValType(xSep)=="C",1,0))
				cLista := SubStr(cLista,nPos+1)
			EndIf                  

			If nCt==nItem
				xRet := Eval(bConv,cItem)
				Exit
			EndIf

			nCt++
		EndDo
	EndIf
return xRet

/*==========================================================================
|Funcao    | VldAnoMes	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Valida campo Ano/Mes										   |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function VldAnoMes(cAnoMes,lShowMsg,lCharSep)
	Local lRet	           
	Local cVal       
	
	Default cAnoMes  := &(ReadVar())      
	Default lShowMsg := .T.              
	Default lCharSep := .T.

	lRet := (Len(cAnoMes)==IIF(lCharSep,7,6))
	If lRet
		cVal := Left(cAnoMes,4)
		lRet := (U_SoNumeros(cVal).And. Val(cVal) >= 1900)
	EndIf
	If lRet .And. lCharSep
		cVal := SubStr(cAnoMes,5,1)
		lRet := (cVal=="/")
	EndIf
	If lRet
		cVal := SubStr(cAnoMes,IIF(lCharSep,6,5),2)
		lRet := (U_SoNumeros(cVal).And. Val(cVal) >= 1 .And. Val(cVal) <= 12)
	EndIf  
	
	If lShowMsg .And. !lRet 
		Aviso('Aviso!', 'Ano/Mes inválido!', {'OK'},1)
	EndIf

Return lRet

User Function CnvLstItem(xItemCnv,cLstOrigem,cLstDest,cSep,bConv,bScan)
	Local aOrigem
	Local aDestino
	Local nPos                                 
	Local xRet
	
	Default bScan := {|xItem| xItem==xItemCnv }
	
	aOrigem  := U_ConvList(cLstOrigem,cSep,bConv,.T.)
	aDestino := U_ConvList(cLstDest,cSep,bConv,.T.)
	
	nPos := aScan(aOrigem,bScan)
	If nPos > 0 
		If nPos <= Len(aDestino)
			xRet := aDestino[nPos]
		EndIf
	Else
		xRet := xItemCnv
	EndIf

Return xRet

/*==========================================================================
|Funcao    | GetLstEmail          | Raimundo Santana      | Data | 04/09/06  |
============================================================================
|Descricao | Pega lista de e-mails para informar						   |
|          | 															   |
============================================================================
|Parametros| _cEmailUsr : Retorna e-mails principais para informar		   |
|			 _cEmailsCC : Retorna e-mails para serem copiados			   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function GetLstEmail(_cEmailUsr,_cEmailsCC,_xWFParam,cIdUser,_lUsrSeWF)
	Local _nPos                      
	Local cAux

	Default cIdUser   := __cUserID 	
	Default _lUsrSeWF := .F.

	//Email do usuário
	If !Empty(cIdUser)
		_cEmailUsr	:= Trim(u_PushDetour( UsrRetMail(cIdUser) ))
	Else
		_cEmailUsr := ""
	EndIf
	
	//Lista de e-mails a serem copiados
	If ValType(_xWFParam)=="B"
		_xWFParam := Eval(_xWFParam)
	EndIf    
	
	_cEmailsCC := ""

	If ValType(_xWFParam)=="C"
		If At(",",_xWFParam) > 0
			_xWFParam := U_ConvList(_xWFParam,',',{|cItem| AllTrim(cItem) },.T.)
		Else
			_cEmailsCC := Trim(GetNewPar(_xWFParam,""))
		EndIf
	EndIf
	
	If ValType(_xWFParam)=="A"
		AEval(_xWFParam,{|cItem| cAux := IIF(!Empty(cItem),Trim(GetNewPar(cItem,"")),""),;
											 IIF( !Empty(cAux),_cEmailsCC += IIF(!Empty(_cEmailsCC),";","")+AllTrim(cAux),) } )
	EndIf
	
	If !Empty(_cEmailsCC)
		_cEmailsCC := Trim(u_PushDetour( _cEmailsCC ))
	ElseIf _lUsrSeWF //Limpa e-mail do usuário se não tem e-mails no(s) parametro(s) passado(s)
		_cEmailUsr := ""
	EndIf

	If Empty(_cEmailUsr)
		_cEmailUsr := _cEmailsCC
		_cEmailsCC := ""                    
	ElseIf ( _nPos:=AT(_cEmailUsr,_cEmailsCC) ) > 0
		_cEmailsCC:=Trim(Left(_cEmailsCC,_nPos-1))+Trim(SubStr(_cEmailsCC,_nPos+Len(_cEmailUsr)))
	EndIf   

	_cEmailUsr := U_RetEmail(_cEmailUsr)
	_cEmailsCC := U_RetEmail(_cEmailsCC)
Return	

/*==========================================================================
|Funcao    | RetEmail	        | Raimundo Santana      | Data | 04/09/06  |
============================================================================
|Descricao | Retorna lista de e-mails passada retirando duplicidades	   |
|          | 															   |
============================================================================
|Parametros| _cEmail : Lista de e-mails									   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function RetEmail(cLstEmail)
	Local nPos
	Local cEmail
	Local cRet := ""
	
//	cLstEmail:=Trim(StrTran(cLstEmail,";;",";"))
	cLstEmail:=Trim(StrTran(cLstEmail," ",""))

	Do While !Empty(cLstEmail)
		nPos := At(";",cLstEmail)

		If nPos == 0     
			cEmail := cLstEmail
			cLstEmail := ""      
		Else
			cEmail := Left(cLstEmail,nPos-1)
			cLstEmail := SubStr(cLstEmail,nPos+1)
		EndIf
		
		If !Empty(cEmail)
			If At(cEmail,cRet) == 0
				cRet += IIF(Empty(cRet),"",";")+cEmail
			Endif
		EndIf
	EndDo
	
Return cRet

/*==========================================================================
|Funcao    | EnviaEmail        | Claudio Cavalcante     | Data | 01/08/00  |
============================================================================
|Descricao | Função para enviar e-mails com ou sem arquivos atachados	   |
|          | 															   |
============================================================================
|Parametros| 															   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function EnviaEmail(_cTo, _cAssunto, _cTexto, _cFrom, _cCC, _aAttach, _lShowError )
	Local _cBCC	 	 := AllTrim(GETMV('MV_WFBCC'))
	Local _cAccount  := AllTrim(GETMV('MV_WFACC'))
	Local _cMailFrom := AllTrim(GETMV('MV_WFMAIL'))
	Local _cPass     := AllTrim(GETMV('MV_WFPASSW'))
	Local _cPOP3Addr := AllTrim(GETMV('MV_WFPOP3'))
	Local _cSMTPAddr := AllTrim(GETMV('MV_WFSMTP'))
    Local _nPOP3Port := 110
    Local _nSMTPPort := 25
    Local _lSMTPSSL  := NIL
    Local _lSMTPTLS  := NIL
    Local _nSMTPTime := 60        
	Local _oServer   := NIL
	Local _oMessage  := NIL
	Local _nErr		 := 0
	Local _lSend 	 := .F.                                                                       
	Local _cError
    Local _nIndex                      
                    
	Default _aAttach    := {}
	Default _lShowError := .F.

	If Empty( _cCC )
		_cCC := ''
	EndIf
         
	If Empty( _cFrom )
		_cFrom := _cMailFrom
	EndIf

	If U_IsDetour()
		_cTo := u_PushDetour( _cTo, .T. )
		_cCC := ""
	Else
		_cTo := U_RetEmail(_cTo)
		_cCC := U_RetEmail(_cCC)
	EndIf
	
	If !U_IsSrvProd()
		_cAssunto := RTrim(_cAssunto)+" [Base Teste]"
	EndIf  

    If _lSMTPSSL <> NIL .And. _lSMTPSSL
    	_nSMTPPort := 465
	ElseIf _lSMTPTLS <> NIL .And. _lSMTPTLS
    	_nSMTPPort := 587
	EndIf
	
    If (_nIndex := At(":",_cPOP3Addr)) > 0
      _nPOP3Port := Val(AllTrim(SubStr(_cPOP3Addr,_nIndex+1)))
      _cPOP3Addr := AllTrim(Left(_cPOP3Addr,_nIndex-1))
    EndIf
    	
    If (_nIndex := At(":",_cSMTPAddr)) > 0
      _nSMTPPort := Val(AllTrim(SubStr(_cSMTPAddr,_nIndex+1)))
      _cSMTPAddr := AllTrim(Left(_cSMTPAddr,_nIndex-1))
    EndIf                        
                                       
    Default _lSMTPSSL := (_nSMTPPort==465)
    Default _lSMTPTLS := (_nSMTPPort==587)
    
    _oMessage := TMailMessage():New()
    
    _oMessage:Clear()
    
	_oMessage:cDate    := cValToChar( MsDate() )
    _oMessage:cFrom    := _cMailFrom
    _oMessage:cTo      := _cTo
    _oMessage:cCC      := _cCC
    _oMessage:cBCC     := _cBCC
    _oMessage:cSubject := _cAssunto
    _oMessage:cBody    := _cTexto
      
    For _nIndex:=1 To Len(_aAttach)
	    _nErr := _oMessage:AttachFile(_aAttach[_nIndex])    
	    
		If _nErr < 0
		  _cError := "Falha ao anexar arquivo: " + _aAttach[_nIndex]
		  Exit
		EndIf		            
    Next      
    
    If _nErr >= 0
	    _oServer := TMailManager():New()
	    
	    _oServer:SetUseSSL(_lSMTPSSL)
		_oServer:SetUseTLS(_lSMTPTLS)

	    _oServer:Init(_cPOP3Addr, _cSMTPAddr, _cAccount, _cPass, _nPOP3Port, _nSMTPPort)
		
	    _nErr := _oServer:SetSMTPTimeout(_nSMTPTime)

	    If _nErr <> 0
    	  _cError := "Falha ao definir SMTP Timeout."
	    Endif
	EndIf

	If _nErr==0    
	    _nErr := _oServer:SMTPConnect()
	    
	    If _nErr <> 0
	      _cError := "Falha ao conectar servidor SMTP: " + _oServer:GetErrorString(_nErr)
	    EndIf
	EndIf
    
	If _nErr==0    
	    _nErr := _oServer:SMTPAuth(_cAccount, _cPass)
	    
	    If _nErr <> 0
	      _cError := "Falha ao autenticar no servidor SMTP: " + _oServer:GetErrorString(_nErr)
	    Endif
	EndIf
	
	If _nErr==0    
		_nErr := _oMessage:Send(_oServer)
		
		_lSend := (_nErr==0)
		
		If _nErr <> 0
		  _cError := "Falha ao enviar e-mail: " + _oServer:GetErrorString(_nErr)
		EndIf
	Endif  
	
	If _oServer <> NIL
		_oServer:SMTPDisconnect()   
	Endif
	
	If _lShowError .And. _nErr<>0 
		Aviso('Aviso!', 'Erro no envio do e-mail!'+Chr(13)+Chr(10)+_cError, {'OK'},2)
	EndIf

Return( _lSend )                                   

/*==========================================================================
|Funcao    | CpoToStr	        | Raimundo Santana      | Data | 13/12/06  |
============================================================================
|Descricao | Retorna string com o valor do campo formatado segundo o SX3   |
|          | 															   |
============================================================================
|Parametros| cCampo 	: Nome do Campo                                    |
|			 xValor 	: Valor a converter                       		   |
|			 cDefVazio	: String default caso o campo esteja vazio		   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function CpoToStr(cCampo,xValor,cDefVazio)
	Local cRet := ""
	Local cBox
	Local cPicture
	Local cTipo
	Local _xArea  := {}                
	Local _aCBox
	Local nPos         
	
	Default cDefVazio := ""
	
	cCampo :=PadR(AllTrim(cCampo),10)

	aAdd( _xArea, SX3->( GetArea() ) )
	
	SX3->( OrdSetFocus(2) ) //X3_CAMPO

	If SX3->(DbSeek(cCampo))
		cTipo	 := AllTrim(SX3->X3_TIPO)
		cBox 	 := Alltrim(SX3->X3_CBOX)
		cPicture := AllTrim(SX3->X3_PICTURE)
		
		If cTipo=="C" .And. !Empty(cBox)
			_aCBox:=U_ConvList(cBox,";",{|cItem| nPos:=At("=",cItem),IIF(nPos==0,NIL,{ AllTrim(Left(cItem,nPos-1)),AllTrim(SubStr(cItem,nPos+1)) } ) },.T.)
			nPos := aScan(_aCBox,{|aItem| aItem[1]==AllTrim(xValor) })
			If nPos > 0
				cRet := _aCBox[nPos][2]
			EndIf
		Else
			cRet := Transform(xValor,cPicture)
		EndIf
	EndIf                           
	
	If Empty(cRet)
		cRet := cDefVazio		
	EndIf

	u_PushArea( _xArea )
Return cRet

/*==========================================================================
|Funcao    | DefSeVazio	        | Raimundo Santana      | Data | 13/12/06  |
============================================================================
|Descricao | Retorna um valor default caso o valor passado seja NIL ou 	   |
|		   | Vazio, do contrário retorna o valor passado				   |
|          | 															   |
============================================================================
|Parametros| xValor 	: Valor de referencia                      		   |
|			 xDefault	: Valor default									   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function DefSeVazio(xValor,xDefault)
Return IIF(xValor==NIL .Or. Empty(xValor),xDefault,xValor)   

/*==========================================================================
|Funcao    | CpoVazio	        | Raimundo Santana      | Data | 15/09/08  |
============================================================================
|Descricao | Retorna valor do campo vazio se existir no dicionário ou um   |
|          | valor default caso não exista.							       |
|          | 															   |
============================================================================
|Parametros| _cCampo 	: Nome do campo									   |
|			 _xDefault	: Valor default									   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function CpoVazio(_cCampo,_xDefault)
	Local _aRet
	Local _xRet

	_aRet := TamSX3(_cCampo)

    Do Case
       	Case _aRet[3] == "L"
			_xRet := .F.
       	Case _aRet[3] == "C"
			_xRet := Space(_aRet[1])
       	Case _aRet[3] == "N"
			_xRet := 0
       	Case _aRet[3] == "D"
			_xRet := CtoD("  /  /  ")
		OtherWise
			_xRet := _xDefault
	EndCase                   
	
Return _xRet

/*==========================================================================
|Funcao    | OpenNewDbf	        | Raimundo Santana      | Data | 26/01/07  |
============================================================================
|Descricao | Tenta abrir um arquivo de dados em um número específido de    |
|		   | Vezes.									  					   |
|          | 															   |
============================================================================
|Parametros| lNewAlias = Abre em nova area								   |
|			 cRddName  = RDD [DBFCDX,CTREECDX,TOPCONN] 					   |
|			 cFilename = Nome do arquivo								   |
|			 cAlias    = Alias do arquivo, fecha se ja estiver aberto      |
|			 lShared   = Modo .T. p/ Compartilhado e .F. p/ Exclusivo      |
|			 lReadOnly = .T. p/ Somente Leitura e .F. p/ Leitura e Escrita |
|			 cDescricao= Descrição p/ mensagens   Default: cFileName       |
|			 nQtdTry   = Quantidade de tentativas Default: 40			   |
|			 nTime     = Tempo entre tentativas   Default: 250 			   |
|			 lQuit	   = .T. p/ sair do sistema se não consequir		   |
============================================================================
|Observações: 															   |
==========================================================================*/
User Function OpenNewDbf(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly,;
						 cDescricao,nQtdTry,nTime,lQuit)
   Local lRet := .T.
   Local nCt

   Default nQtdTry    := 40
   Default nTime      := 250 //Milisegundos
   Default cDescricao := RetFileName(cFileName)    
   Default lQuit	  := .F.
   
   If Select(cAlias) > 0
     (cAlias)->( DbCloseArea() )
   EndIf

   If !DbOpenDbf(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly)
     Processa( {|| lRet := TryOpenDbf(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly,cDescricao,nQtdTry,nTime) },"Tentando abrir "+cDescricao+"..." )
   Endif     

   If lQuit .And. !lRet
     Final("Impossível abrir "+cDescricao+" no modo "+IIF(lShared,"compartilhado","exclusivo")+".")
   EndIf
Return lRet

Static Function TryOpenDbf(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly,cDescricao,nQtdTry,nTime)
   Local nCt

   ProcRegua(nQtdTry)

   nCt := nQtdTry
   Do While nCt > 0 .And. !DbOpenDbf(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly)
     Sleep(nTime) 
     nCt--
 	 IncProc()
   EndDo
Return nCt > 0

Static Function DbOpenDbf(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly)

	DBUseArea(lNewAlias,cRddName,cFilename, cAlias,lShared,lReadOnly)
	
Return Select(cAlias) > 0
     
/*==========================================================================
|Funcao    | ExistFile	        | Raimundo Santana      | Data | 26/01/07  |
============================================================================
|Descricao | Verifica a existência dos arquivos de dados e indices em um   |
|		   | RDD específico.						  					   |
|          | 															   |
============================================================================
|Parametros| cDataFile = Nome do arquivo de dados						   |
|			 cIndFile  = Nome do arquivo de índice 						   |
|			 cRddName  = RDD [DBFCDX,CTREECDX,TOPCONN]					   |
============================================================================
|Observações: Para verificar a existencia do arquivo de dados forneça	   |
|			  somente o nome do arquivo de dados sem o índice.			   |
|             Para verificar a existencia do indice forneça o nome do      |
|             do arquivo de dados e indice em conjunto.                    |
==========================================================================*/
User Function ExistFile(cDataFile,cIndFile,cRddName)
   Local lRet
   
   If cRddName=="TOPCONN"     
     If cDataFile!=NIL
	   cDataFile := RetFileName(cDataFile)
     EndIf
     If cIndFile!=NIL
	   cIndFile  := RetFileName(cIndFile)
     EndIf
     lRet := MsFile(cDataFile,cIndFile,cRddName)
   Else
     If !Empty(cIndFile)
       lRet := File(cIndFile)
     Else
       lRet := File(cDataFile)
     Endif
   Endif
Return lRet

/*==========================================================================
|Funcao    | BagMultInd	        | Raimundo Santana      | Data | 26/01/07  |
============================================================================
|Descricao | Verifica se o RDD permite varios indices em um mesmo BAG      |
|          | 															   |
============================================================================
|Parametros| cRddName  = RDD [DBFCDX,CTREECDX,TOPCONN]					   |
============================================================================
|Observações: 											                   |
==========================================================================*/
User Function BagMultInd(cRddName)
	Local lRet := .F.

	lRet := Upper(AllTrim(cRddName)) $ "DBFCDX|CTREECDX"	
	
Return lRet

/*==========================================================================
|Funcao    | TopDelInd	        | Raimundo Santana      | Data | 26/01/07  |
============================================================================
|Descricao | Exclui indice de uma tabela no topconnect				       |
|          | 															   |
============================================================================
|Parametros| cFileName  = Nome da tabela no banco						   |
|			 cIndexName = Nome do índice na tabela						   |
============================================================================
|Observações: 											                   |
==========================================================================*/
User Function TopDelInd(cFileName,cIndexName)
  If Empty(cFileName)
    Return .F.
  EndIf

  If Empty(cIndexName)
    Return .F.
  EndIf
  
  cFileName  := RetFileName(cFileName) 
  cIndexName := RetFileName(cIndexName) 
  
  TCSqlExec("DROP INDEX "+cFileName+"."+cIndexName)
  TCRefresh(cFileName)
Return .T.

/*==========================================================================
|Funcao    | RetNumeros	        | Raimundo Santana      | Data | 21/06/06  |
============================================================================
|Descricao | Retorna os numeros contidos no parametro					   |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function RetNumeros(cStr)
	Local nCt     
	Local cCh           
	Local cRet := ""
	
	For nCt:=1 To Len(cStr)
		cCh:=SubStr(cStr,nCt,1)
		If cCh >= '0' .And. cCh <= '9'
		  cRet += cCh		
		EndIf
	Next     
return cRet             


/*==========================================================================
|Funcao    | TabToArray	        | Raimundo Santana      | Data | 13/02/07  |
============================================================================
|Descricao | Cria um array a partir de uma tabela do sistema			   |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function TabToArray(cTabela,bConvItem,bFiltro,cFilTab)
	Local aRet := {}
	Local _aArea := SX5->( GetArea() )  
	Local cBusca        
	Local xValor

	Default cTabela   := ""
	Default bConvItem := { |cChave,cDesc| { cChave, cDesc } }
	Default bFiltro   := { |xItem| .T. }
	Default cFilTab   := FWXFilial("SX5")

	cTabela := Right("  "+cTabela,2)

	SX5->( OrdSetFocus(1) ) //X5_FILIAL+X5_TABELA+X5_CHAVE

	cBusca := cFilTab+cTabela 
	
	SX5->( DbSeek( cBusca) )
	
	Do While SX5->( !Eof() ) .And.;
		     SX5->X5_FILIAL+SX5->X5_TABELA==cBusca

		xValor := Eval(bConvItem,SX5->X5_CHAVE,SX5->X5_DESCRI)
		
		If Eval(bFiltro,xValor)	
			AAdd( aRet, xValor )
		EndIf
		     
	  	SX5->( DbSkip() )
	EndDo		
	
    RestArea( _aArea )
Return aRet

/*==========================================================================
|Funcao    | GetValCpo	        | Raimundo Santana      | Data | 13/02/07  |
============================================================================
|Descricao | Pega valores de campos em um arquivo                          |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function GetValCpo( cAlias,nOrdem,cChave,xCampo,xDefault)
	Local xRet
	Local nArea
	Local aArea                      
	Local nCt

    If Empty( nOrdem )
    	nOrdem := 1
    EndIf           

	aArea := (cAlias)->( GetArea() )
	
	nArea := Select(cAlias)
	
	(cAlias)->( OrdSetFocus(nOrdem) )
	
	lAchou := (cAlias)->( DbSeek( cChave )  )
	
	If ValType(xCampo)=="A"
	    xRet := {}
		    
	    For nCt:=1 To Len(xCampo)
	      If lAchou .Or. ValType(xDefault)<>"A" .Or. Len(xDefault) < nCt .Or. xDefault[nCt]==NIL
		      If ValType(xCampo[nCt])=="B"
				AAdd(xRet,(cAlias)->(Eval(xCampo[nCt])))
			  Else
				AAdd(xRet,(cAlias)->(Eval(FieldWBlock(xCampo[nCt],nArea))))
		      EndIf
		  Else 
		    AAdd(xRet,xDefault[nCt])
		  EndIf
	    Next
	Else
        If lAchou .Or. ValType(xDefault)=="U"
		    If ValType(xCampo)=="B"
				xRet := (cAlias)->(Eval(xCampo))
			Else
				xRet := (cAlias)->(Eval(FieldWBlock(xCampo,nArea)))
		    EndIf
		Else
			xRet := xDefault
		Endif
	Endif
				
	(cAlias)->( RestArea( aArea ) )
Return xRet

/*==========================================================================
|Funcao    | fCadVal	        | Raimundo Santana      | Data | 13/02/07  |
============================================================================
|Descricao | Pega valores de campos no browser (cabeçalho e itens)         |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fCadVal(cCampo,nLinha, aLista, aHead)
  	Local xRet 
  	
	If Type(cCampo) != "U"
		xRet := Eval(MemVarBlock(cCampo))
	Else
		xRet := U_fValor( cCampo, nLinha, aLista, aHead )
	EndIf
Return xRet

/*==========================================================================
|Funcao    | fCpoExists	        | Raimundo Santana      | Data | 13/02/07  |
============================================================================
|Descricao | Verifica se uma chave existe em um arquivo específifo,        |
|          | mantendo posicionado ou não o registro encontrado de acordo   |
|          | com o parametro lSaveArea									   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fCpoExists( cAlias, nOrdem, cChave, lSaveArea)
	Local lRet
	Local aArea

    Default lSaveArea  := .T.
    Default nOrdem := 1

	If lSaveArea
	  aArea := ( cAlias )->( GetArea() )
	EndIf
	
	(cAlias)->( OrdSetFocus(nOrdem) )
	
	lRet := (cAlias)->( DbSeek( cChave )  )

	If lSaveArea    
	  (cAlias)->( RestArea( aArea ) )
	EndIf
Return( lRet )

/*==========================================================================
|Funcao    | fCpoFil	        | Raimundo Santana      | Data | 13/02/07  |
============================================================================
|Descricao | Verifica se uma chave existe em um arquivo específifo para    |
|		   | qualquer filial caso o arquivo seja exclusivo, mantendo o     |
|		   | posicionado ou não o registro encontrado de acordo com o      |
|          | parametro lSaveArea									  	   |
============================================================================
|Observações:  Se cCodFil for NIL procura em todas as filiais			   |
|                                                                          |
==========================================================================*/
User Function fCpoFil( cAlias, nOrdem, cCodFil, cChave, lSaveArea, cCpoFil)
	Local lRet := .F.
	Local aArea
	Local nPos     
	Local bCpoFil

    Default lSaveArea  := .T.
    Default nOrdem := 1
    
    If cCpoFil==NIL                          
    	If Left(cAlias,1)="S"
			cCpoFil:=SubStr(cAlias,2,2)
		Else
			cCpoFil:=cAlias
		Endif
		    		
    	cCpoFil+="_FILIAL"
    EndIf 
    
    bCpoFil:=FieldWBlock(cCpoFil,Select(cAlias))

	If lSaveArea
	  aArea := ( cAlias )->( GetArea() )
	EndIf
	
	(cAlias)->( OrdSetFocus(nOrdem) )
	
	If cCodFil!=NIL
		lRet := (cAlias)->( DbSeek( cCodFil+cChave )  )
	Else
		(cAlias)->( DbSeek( "  ", .T. ) )
		
		Do While !lRet .And. (cAlias)->(!Eof())
			cCodFil := Eval(bCpoFil)
			lRet := (cAlias)->( DbSeek( cCodFil+cChave )  )
			If !lRet
				(cAlias)->( DbSeek( cCodFil+Replicate(Chr(255),Len(cChave)), .T. ) )
			EndIf
		EndDo
	EndIf
	

	If lSaveArea    
	  (cAlias)->( RestArea( aArea ) )
	EndIf
Return( lRet )

/*=========================================================================\
|Funcao    | IsChFName          | Raimundo Santana      | Data | 01/08/07  |
============================================================================
|Descricao | Verifica se o caracter é permitido em nomes de arquivos	   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function IsChFName(cCh)
	Local lRet
	
	lRet :=( ( cCh >= 'A' .And. cCh <= 'Z' ) .Or.;
	 	      ( cCh >= 'a' .And. cCh <= 'z' ) .Or.;
	 	      ( cCh >= '0' .And. cCh <= '9' ) .Or.;
		      ( cCh $ 'áàãÁÀÃéêÉÊìíÌÍóòõôÓÒÕÔúùûüÚÙÛÜçÇ' ) .Or.;
	 	      cCh $ "-_" )
Return lRet

/*=========================================================================\
|Funcao    | ToFName            | Raimundo Santana      | Data | 01/08/07  |
============================================================================
|Descricao | Convert String para um nome de arquivo						   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function ToFName(_cFile,_lSemTraco)
	Local nCt
	Local cCh
	Local _cOldFile

	Default _lSemTraco := .F.
		
	_cFile := AllTrim(_cFile)

	If !Empty(_cFile)
		For nCt:=1 To Len(_cFile)
			cCh := SubStr(_cFile,nCt,1)
		
			If !U_IsChFName(cCh)
				_cFile := Replace(_cFile,cCh,"_")         
			EndIf
		Next		                           
		
		_cOldFile:=""
		
		While !( _cFile==_cOldFile )
			_cOldFile := _cFile
			
			_cFile := Replace(_cFile," ","_")
			_cFile := Replace(_cFile,"_-","-")
			_cFile := Replace(_cFile,"-_","-")
			_cFile := Replace(_cFile,"/","-")
			_cFile := Replace(_cFile,",","_")
			_cFile := Replace(_cFile,"+","_")
			_cFile := Replace(_cFile,"__","_")
			_cFile := Replace(_cFile,".","")
		EndDo

		If _lSemTraco
			_cFile := Replace(_cFile,"-","")         
			_cFile := Replace(_cFile,"_","")         
		EndIf		
	Endif

Return _cFile
		
/*=========================================================================\
|Funcao    | ChkFName           | Raimundo Santana      | Data | 06/10/06  |
============================================================================
|Descricao | Verifica o nome do arquivo excel sem extensão				   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function ChkFName(_cFile)
	Local nCt
	Local cCh
	
	If Empty(_cFile)
		MsgStop( 'Nome do arquivo não está preenchido!' )
		return .F.
	EndIf    

	If At(".",_cFile) > 0
		MsgStop( 'Nome do arquivo não pode conter extensão!' )
		return .F.
	EndIf    

	For nCt:=1 To Len(_cFile)
		cCh := SubStr(_cFile,nCt,1)
	
		If !U_IsChFName(cCh)
			MsgStop( 'Nome do arquivo inválido!' )        
			return .F.
		EndIf
	Next		 
Return .T.

/*=========================================================================\
|Funcao    | ChkPName           | Raimundo Santana      | Data | 06/10/06  |
============================================================================
|Descricao | Verifica o diretório destino do arquivo excel				   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function ChkPName(_cPath,nTpPathSel,lChkExists)
	Local lOk

	Default _cPath	   := &( ReadVar() )
	Default nTpPathSel := 0
	Default lChkExists := .F.
	
	_cPath := AlLTrim(_cPath)

	If Empty(_cPath)
		MsgStop( 'Diretório destino não está preenchido!' )
		return .F.
	EndIf 

	If At("?",_cPath) > 0 .Or. At("*",_cPath) > 0
		MsgStop( 'Diretório destino inválido! Não utilize "?" ou "*" no nome do diretório.' )
		return .F.
	EndIf                                              

	lOk := .T.

	If At(":",_cPath) > 0	  
		lOk:=( Len(_cPath) >= 3 .And. SubStr(_cPath,2,1) == ":" .And. At("\\",_cPath) == 0 )
	Else 
		lOk:=( Left(_cPath,1) == "\" .And. Left(_cPath,2) != "\\" )
	EndIf

	If !lOk
		MsgStop( 'Diretório destino inválido! Utilize o(s) formato(s): '+;
			     IIF(nTpPathSel==0 .Or. nTpPathSel==2,'"c:\diretorio" para os diretórios locais','')+;
			     IIF(nTpPathSel==0,' ou ','')+;
			     IIF(nTpPathSel==0 .Or. nTpPathSel==1,'"\diretorio" para os diretórios no servidor','')+'.' )
		return .F.
	EndIf

	Do Case
		Case nTpPathSel == 2 .And. At(":",_cPath) == 0
			MsgStop( 'Diretório destino inválido! Não selecione nenhum diretório do Servidor.' )
			return .F.
		Case nTpPathSel == 1 .And. At(":",_cPath) <> 0
			MsgStop( 'Diretório destino inválido! Não selecione nenhum diretório local.' )
			return .F.
	EndCase		

	If lChkExists
		If !U_DirExist(_cPath)
			MsgStop( 'Diretório destino ['+_cPath+'] não existe!' )
			return .F.
		EndIf
	EndIf
return .T.	

/*=========================================================================\
|Funcao    | DirExist           | Raimundo Santana      | Data | 06/10/06  |
============================================================================
|Descricao | Verifica se um diretório existe.                              |
|          |                                                               |
============================================================================
|Parametros| cPath = String com o diretório a verificar.                   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function DirExist(cPath)       
	Local nPos 
	
	cPath:=AllTrim(cPath)
	
 	nPos:=At(":",cPath)
 	If nPos > 0
 		If (Len(cPath)-nPos)==1
 			If Right(cPath,1)=="\"
	 			cPath += "*"
	 		EndIf
	 	Else
 			If Right(cPath,1)=="\"
 				cPath := Left(cPath,Len(cPath)-1)
 			EndIf
 		EndIf
 	Else 
 		If cPath=="\"
 			cPath += "*"
 		Else
 			If Right(cPath,1)=="\"
 				cPath := Left(cPath,Len(cPath)-1)
 			EndIf
 		Endif
 	EndIf
	
Return Len(Directory(cPath,"D")) > 0

/*=========================================================================\
|Funcao    | MakeTree           | Raimundo Santana      | Data | 15/08/09  |
============================================================================
|Descricao | Cria uma arvore de diretórios caso não exista.                |
|          |                                                               |
============================================================================
|Parametros| cPath = String com o diretório a criar.                       |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function MakeTree(_cPath)
	Local _nPos
	Local _cDir := ""
	Local _lRet := .T.  
	
	_cPath := RTrim(_cPath)
	
	If Right(_cDir,1)=="\"
		_cPath := Left(_cPath,Len(_cPath)-1)
	EndIf

	If !Empty(_cPath) .And. !U_DirExist(_cPath)
		Do While _lRet .And. !Empty(_cPath)
			_nPos := At("\",_cPath)
		
			If _nPos==0
				_cDir  += IIF(Empty(_cDir).Or.Right(_cDir,1)=="\","","\")+_cPath
				_cPath := ""
			Else                        
				If _nPos==1
					_cDir  += "\"
				Else
					_cDir  += IIF(Empty(_cDir).Or.Right(_cDir,1)=="\","","\")+Left(_cPath,_nPos-1)
				EndIf
				_cPath := SubStr(_cPath,_nPos+1)
			EndIf		                           
		
			If !Empty(_cDir) .And. !(Right(_cDir,1) $ ":\")
				If !U_DirExist(_cDir)
					_lRet := ( MakeDir(_cDir) == 0 )
				EndIf
			EndIf
		EndDo
	EndIf                    
	
Return _lRet

/*=========================================================================\
|Funcao    | fNomeMes           | Raimundo Santana      | Data | 06/10/06  |
============================================================================
|Descricao | Retorna o nome do mes.										   |
|          |                                                               |
============================================================================
|Parametros| nMes 		= Numero do Mes                                    |
|          | lMaiuscula = .T. para retornar em Maiusculas                  |
|          | lReduzido  = .T. para retornar sumente as 3 primeiras letras  |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function fNomeMes(nMes,lMaiuscula,lReduzido)
	Local sRet	 := ""
	Local aMeses := { 'Janeiro','Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro' }

	If nMes >= 1 .And. nMes <= 12
		sRet := aMeses[nMes]
		If lReduzido 
			sRet := Left(sRet,3)
		EndIf                   
		If lMaiuscula
			sRet := Upper(sRet)
		EndIf
	EndIf
Return sRet

/*=========================================================================\
|Funcao    | fNomeMes           | Raimundo Santana      | Data | 06/10/06  |
============================================================================
|Descricao | Retorna o nome do mes.										   |
|          |                                                               |
============================================================================
|Parametros| nDia 		= Numero do Dia                                    |
|          | lMaiuscula = .T. para retornar em Maiusculas                  |
|          | lReduzido  = .T. para retornar sumente as 3 primeiras letras  |
|          | nPriDia    = Define o primeiro dia da semana (Default 1)      |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function fNomeDia(nDia,lMaiuscula,lReduzido,nPriDia)
	Local sRet  := ""                           
	Local aDias := { 'Domingo','Segunda','Terca', 'Quarta', 'Quinta', 'Sexta', 'Sabado' }

    Default nPriDia := 1
    
	If nDia >= nPriDia .And. nDia <= (nPriDia+6)
		sRet := aDias[nDia-nPriDia+1]
		If lReduzido 
			sRet := Left(sRet,3)
		EndIf                   
		If lMaiuscula
			sRet := Upper(sRet)
		EndIf
	EndIf
Return sRet

/*=========================================================================
|Funcao    | fLocWIP     |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão do WIP						   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocWIP()
	Local cRet := GetNewPar( 'MV_LOCWIP', '41' )

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	
Return cRet
                                                                            
/*=========================================================================
|Funcao    | fLocPBn     |Autor | Thiago Torelli        | Data | 09/04/14  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão do Produto 					   |
|          | para Beneficiamento                                           |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocPBn()
	Local cRet := GetNewPar( 'MV_LOCPBN', '01' )

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	
Return cRet
           
/*=========================================================================
|Funcao    | fLocEBn     |Autor | Thiago Torelli        | Data | 09/04/14  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão do Empenho 					   |
|          | para Beneficiamento                                           |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocEBn()
	Local cRet := GetNewPar( 'MV_LOCEBN', '08' )

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	
Return cRet

/*=========================================================================
|Funcao    | fLocTER     |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão de Terceiros					   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocTER()
	Local cRet := GetNewPar( 'MV_LOCTER', '03' )

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	
Return cRet         

/*=========================================================================
|Funcao    | fLocRPT     |Autor | Raimundo Santana      | Data | 27/05/14  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão para retorno de Produtos de     |
|          | Terceiros.													   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocRPT()
	Local cRet := GetNewPar( 'MV_LOCRPT', '03' )

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	
Return cRet         

/*=========================================================================
|Funcao    | fLocPad     |Autor | Raimundo Santana      | Data | 15/09/10  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão para produtos próprios		   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocPad()
	Local cRet := GetNewPar( 'MV_LOCPAD', '01' )

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	
Return cRet

/*=========================================================================
|Funcao    | fLocPROD    |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão do Produto 					   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocPROD(cProduto,lLocPad)
	Local cRet := ""
	
	Default lLocPad := .T.
	
	If lLocPad
		cRet := U_fLocPad()
	EndIf
	
	If cProduto != NIL
		cRet := U_GetValCpo( "SB1",1,FWXFilial("SB1")+cProduto,"B1_LOCPAD",cRet)	
	EndIf

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
Return cRet

/*=========================================================================
|Funcao    | fLocPA      |Autor | Raimundo Santana      | Data | 15/09/10  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão para Produtos Acabados		   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocPA(cProduto,lLocPad)
	Local cRet := ""
	
	Default lLocPad := .T.
	
	If lLocPad
		cRet := U_fLocPad()
	EndIf

	Do Case
		Case U_fNewAlm()
			If cProduto!=NIL .And. U_A240PROD(cProduto)
				cRet := GetNewPar( 'MV_LOCPATR', '50' )		
			Else			
				cRet := GetNewPar( 'MV_LOCPA', '50' )		
			End
		Case cProduto!=NIL
			cRet := U_GetValCpo( "SB1",1,FWXFilial("SB1")+cProduto,"B1_LOCPAD",cRet)	
	End Case                                            
	
	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
Return cRet

/*=========================================================================
|Funcao    | fLocPrOP    |Autor | Raimundo Santana      | Data | 15/09/10  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão do Produto Acabado para a OP	   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocPrOP(cProduto,lLocPad,lRemInd)
	Local cRet := ""
	
	Default lLocPad := .T.    
	Default lRemInd := .F.
	
	If lLocPad
		cRet := U_fLocPad()
	EndIf

	Do Case
		Case lRemInd
			cRet := U_fLocPBN()
		Case U_fCtlAlBN() .And. U_A240PROD(cProduto)
			cRet := U_fLocTER()
		Case U_fPANoWIP()
			cRet := U_fLocWIP()
		Case U_fNewAlm()
			cRet := U_fLocPA(cProduto)
		Case cProduto != NIL
			cRet := U_GetValCpo( "SB1",1,FWXFilial("SB1")+cProduto,"B1_LOCPAD",cRet)	
	EndCase

	cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
Return cRet        

/*==========================================================================
|Funcao    | fLocENTR    |Autor | Bianca Massarotto     | Data | 25/03/14  |
============================================================================
|Descricao | Retorna o Almoxarifado Padrão para Entrada de NF              |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fLocENTR(cProduto)
	Local cRet     := ""
	Local lProdTer := .F.
                
	lProdTer := u_a240Prod( cProduto )
                
	//Se produto é de terceiros                       
	If lProdTer
		cRet := U_fLocTER()
	Else

	If cProduto != NIL
		cRet := U_GetValCpo( "SB1",1,FWXFilial("SB1")+cProduto,"B1_LOCPAD",cRet)      
	EndIf
		cRet := PadR(cRet,TamSX3("B2_LOCAL")[1])
	EndIf

Return cRet



/*=========================================================================
|Funcao    | fNewAlm     |Autor | Raimundo Santana      | Data | 15/09/10  |
============================================================================
|Descricao | Indica se utiliza a nova estrutura de almoxarifados           |
|          | Retorna .T. se usa a nova estrtura                            |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fNewAlm()
Return ( GetNewPar( 'MV_NEWALM', 'N' ) = 'S' )

/*=========================================================================
|Funcao    | fTemWIP     |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Verifica se existe o WIP									   |
|          | Retorna .T. se a filial tem o almoxarifado de WIP             |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fTemWIP()
Return GetNewPar( 'MV_HASWIP', 'N' ) = 'S'	


/*=========================================================================
|Funcao    | fTemMRP     |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Verifica se usa o MRP										   |
|          | Retorna .T. se a filial utiliza o MRP 						   |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fTemMRP()
Return GetNewPar( 'MV_HASMRP', 'N' ) = 'S'	

/*=========================================================================
|Funcao    | fPANoWIP     |Autor | Raimundo Santana      | Data | 15/09/10 |
============================================================================
|Descricao | Verifica o Produto Acabado deve ser apontado no WIP		   |
|          | Retorna .T. se a filial aponta o PA no almoxarifado de WIP    |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fPANoWIP()
Return U_fTemWIP() .And. GetNewPar( 'MV_PANOWIP', 'N' ) = 'S'	                                               

/*=========================================================================
|Funcao    | fCtlAlBN    |Autor | Raimundo Santana      | Data | 21/05/14  |
============================================================================
|Descricao | Verifica se o controle do almoxarifado no processo  		   |
|		   | de beneficiamento para terceiros é estrito ou não.			   |
|          | Retorna .T. se deve controlar o almoxarifado ou .F. se não    |
|          |                                                               |
============================================================================
|Observações: Se utilizar controle estrito não será possível transferir    |
|             materiais de terceiros (Beneficiamento) entre almoxarifados  | 
|             ou endereços.                                                |
==========================================================================*/
User Function fCtlAlBN()
Return GetNewPar('MV_CTLALBN','N')='S'	

/*=========================================================================
|Funcao    | fConvWIP    |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Converte Almoxarifado para o WIP se estiver ativo			   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fConvWIP(cLocal)
	Local cRet := cLocal

	If U_fTemWIP()
		cRet := U_fLocWIP()
	Endif
Return cRet

/*=========================================================================
|Funcao    | fConvLoc    |Autor | Raimundo Santana      | Data | 06/07/07  |
============================================================================
|Descricao | Converte Almoxarifado para o WIP ou Terceiros de acordo com   |
|          | o cadastro do produto                                         |
|          |                                                               |
============================================================================
|Observações:                                                              |           
|				Muda o almoxarifado destino das ordens intermediárias 	   |
|				segundo as regras abaixo:								   |
|				- Almox. de Terceiros quando o produto for de terceiros	   |
|				- Almox. WIP quando o produto for próprio e o WIP existir  |
|				- Almox. do produto quando o produto for próprio e o       |
|				  almoxarifado selecionado for de terceiros e o o WIP 	   |
|				  não existir											   |
|				- Não muda quando as regras acima não se aplicarem		   |
|                                                                          |
==========================================================================*/
User Function fConvLoc(cProduto,cLocal)
	Local cRet                                 
	Local lProdTer
	
	lProdTer := u_a240Prod( cProduto )
	
	//Se produto é de terceiros 		
	If lProdTer .And. U_fCtlAlBN()
		cRet := U_fLocTER()
	Else                         
		//Converte para o WIP se existir
		cRet := U_fConvWIP(cLocal)

		//Converte para o almoxarifado padrão do produto se o produto não for de terceiros
		//e o almoxarifado selecionado for de terceiros
		If cRet == U_fLocTER() .And. !lProdTer
			cRet := U_fLocPROD(cProduto)
		EndIf
	Endif
Return cRet                                 

/*=========================================================================
|Funcao    | a240Prod  | Autor | Claudio Cavalcante    | Data | 14/12/04   |
============================================================================
|Descricao | Valida digitacao do movimento interno, identificando se existe|
|          | algo produto lançado com controle de poder de terceiros       |
============================================================================
|Observações:                                                              |
|                                                                          |
|                                                                          |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function a240Prod( _cProduto, _lMess )
	Local _xArea := {}
	Local _lRet  := .F.

	Default _lMess := .F.
	
	aAdd( _xArea, ULA->( GetArea() ) )
	aAdd( _xArea, SB1->( GetArea() ) )
	aAdd( _xArea, GetArea() )	

	ULA->( OrdSetFocus(1) ) //ULA_FILIAL+ULA_COD
	SB1->( OrdSetFocus(1) ) //B1_FILIAL+B1_COD

	//procurar se o produto eh de terceiro na tabela por filial
	//caso nao encontre, retornar o valor padrao de B1_PRODTER
	If ULA->( DbSeek( FWXFilial( 'ULA' ) + _cProduto ) )
		_lRet := ULA->ULA_TIPO = '1'
	Else
		If SB1->( DbSeek( FWXFilial('SB1') + _cProduto ) )
			_lRet := SB1->B1_PRODTER = '1'
		EndIf
	EndIf
	
	If !_lRet .and. _lMess
		Aviso( 'Aviso!', 'O produto selecionado não é um materior de terceiro', { 'OK' } )
	EndIf

	U_PushArea( _xArea )
	
Return( _lRet )

/*=========================================================================\
|Funcao    | FlLibEst           | Raimundo Santana      | Data | 22/07/07  |
============================================================================
|Descricao | Verifica se a filial está liberada para manter estoque		   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function FlLibEst(_cFilial,_cMens,_lMens)
	Local _lRet := .T.
	
	Default _cFilial := cFilAnt
	Default _cMens	 := "Não é possível realizar movimentação de estoque "+IIF(_cFilial==cFilAnt,"nesta filial"," na filial ")+_cFilial+"!"
	Default _lMens	 := .T.

 	_lRet := !( _cFilial < '01' .Or. _cFilial > '50' .Or. _cFilial $ GetNewPar('MV_FBLQEST', '' ) )

	If _lMens .And. !_lRet
		Aviso("Atenção!",_cMens,{"Ok"} )
	EndIf

Return _lRet

/*=========================================================================\
|Funcao    | FlLibPrd           | Raimundo Santana      | Data | 22/07/07  |
============================================================================
|Descricao | Verifica se a filial está liberada para produções			   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function FlLibPrd(_cFilial,_cMens,_lMens)
	Local _lRet := .T.
	
	Default _cFilial := cFilAnt
	Default _cMens	 := "Não é possível realizar produções "+IIF(_cFilial==cFilAnt,"nesta filial"," na filial ")+_cFilial+"!"
	Default _lMens	 := .T.
	
	_lRet := U_FlLibEst(_cFilial,_cMens,_lMens)
	
	If _lRet
	 	_lRet := !( _cFilial < '01' .Or. _cFilial > '50' .Or. _cFilial $ GetNewPar('MV_FBLQPRD', '16' ) )
	EndIf

	If _lMens .And. !_lRet
		Aviso("Atenção!",_cMens,{"Ok"} )
	EndIf

Return _lRet


/*=========================================================================\
|Funcao    | ChkFiliais         | Raimundo Santana      | Data | 06/10/06  |
============================================================================
|Descricao | Verifica a lista de filiais								   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function ChkFiliais(_cFiliais,_lMultCGC)
	Local _cFilial
	Local _nPos   
	Local _cFilAux
	Local _xArea  := {}
	Local _lRet	  := .T.

	Default _cFiliais := IIF(!Empty(ReadVar()),&(ReadVar()),NIL)	
	Default _lMultCGC := .F.
	
	If Empty(_cFiliais)
		Aviso("Atenção!",'Não existe filiais selecionadas! Verifique os parametros!',{"Ok"})
		return .F.
	EndIf

	_cFilAux := _cFiliais
	
	Do While _lRet .And. !Empty(_cFilAux)     
		_nPos := At(",",_cFilAux)
		
		If _nPos > 0
			_cFilial := AllTrim(Left(_cFilAux,_nPos-1))
			_cFilAux := SubStr(_cFilAux,_nPos+1)
		Else
			_cFilial := AllTrim(_cFilAux)
			_cFilAux := ""
		EndIf                               
		
		If Empty(_cFilial) .Or. Len(_cFilial) <> FWSizeFilial()
			Aviso("Atenção!","Lista de filiais preenchida incorretamente!",{"Ok"})
			_lRet	  := .F.
		EndIf
	EndDo
	
	If _lRet
		_lRet := U_VldFlUsu(_cFiliais)
	EndIf

	If _lRet .And. _lMultCGC
		_lRet := U_VldFUCGC(_cFiliais)
	EndIf

return _lRet

/*=========================================================================\
|Funcao    | ChkLocLs         | Raimundo Santana        | Data | 29/09/08  |
============================================================================
|Descricao | Verifica a lista de almoxarifados							   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
User Function ChkLocLs(_cLocais)
	Local _lRet         
	Local _nItemErro
	Local _bVldItem := {|cItem| Len(AllTrim(cItem))==2 }

	Default _cLocais := IIF(!Empty(ReadVar()),&(ReadVar()),NIL)	

	_lRet := U_IsListVld(_cLocais,',',_bVldItem,@_nItemErro)
		
	If !_lRet
		Aviso( 'Atenção!', "Lista de almoxarifados fornecida incorretamente! Verifique o item "+AllTrim(Str(_nItemErro))+".", {'ok'} )
	EndIf

Return _lRet

/*==========================================================================
|Funcao    | GetMVFl          | Raimundo Santana      | Data | 04/09/06  |
============================================================================
|Descricao | Retorna valor de um parametro por filial					   |
|          | 															   |
============================================================================
|Parametros| _cFilial : Codigo da Filial								   |
|			 _cParam  : Nome do Parametro								   |
|			 _xDef    : Valor Default									   |
|			 _lSoFil  : .T. para somente considerar parametro por filial   |
| 						ignorando o paramentro com filial em branco        |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function GetMVFl(_cFilial,_cParam,_xDef,_lSoFil)
	Local cAlias := Alias()
	Local aParm := { " ", NIL }     
	Local xRet
	
	Default _cFilial := cFilAnt  
	Default _lSoFil  := .F.

	If SX6->( dbSeek( _cFilial + _cParam )  )
		aParm := { SX6->X6_TIPO, AllTrim( SX6->X6_CONTEUD ) } 
    ElseIf !_lSoFil
    	If SX6->( dbSeek('  '+_cParam ) ) 
      	    aParm := { SX6->X6_TIPO, AllTrim( SX6->X6_CONTEUD ) } 
     	EndIf
    EndIf     
    
    Do Case
       	Case aParm[1] = "L"
			xRet := IIf( Upper( aParm[2] ) =  "T", .T., .F. )
       	Case aParm[1] = "C"
			xRet := aParm[2] 
       	Case aParm[1] = "N"
			xRet := Val( aParm[2] )
       	Case aParm[1] = "D"
       		If At("/",aParm[2]) > 0
				xRet := CtoD( aParm[2] )
			ElseIf Len(aParm[2])==8
				xRet := CtoD(Substr(aParm[2],7,2)+"/"+Substr(aParm[2],5,2)+"/"+Left(aParm[2],4) )
			EndIf                      
		OtherWise
			xRet := _xDef
	EndCase
Return xRet      

/*==========================================================================
|Funcao    | CreMVFil           | Raimundo Santana      | Data | 04/09/06  |
============================================================================
|Descricao | Cria ou atualiza parametro por filial						   |
|          | 															   |
============================================================================
|Parametros|															   |
|			 															   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CreMVFil( _cParam,_cTipo,_cFilial,_cPropri,;
						_xConteudo,_cDescric,_cDesc1,_cDesc2,;
						_xContSPA,_cDscSPA,_cDscSPA1,_cDscSPA2,;
						_xContENG,_cDscENG,_cDscENG1,_cDscENG2,;
						_cPYME )  
	Local _xArea   := {}
	Local _lUpdate

	If ValType(_xConteudo)=="B"
		_xConteudo := Eval(_xConteudo,_cParam,_cTipo,_cFilial)
	EndIf
	
	Default _xConteudo:= ""
	Default _cTipo 	  := ValType(_xConteudo)
	
	If ValType(_xConteudo) != "C"
		Do Case
			Case _cTipo=="D"
				_xConteudo := DtoS(_xConteudo)
			Case _cTipo=="L"
				_xConteudo := IIF(_xConteudo,"T","F")
			Case _cTipo=="N"
				_xConteudo := AllTrim(Str(_xConteudo))
		End Case
	EndIf
	
	Default _cFilial  := Space(FWSizeFilial())
	Default _cPropri  := "U"
	Default _cDescric := ""
	Default _cDesc1   := ""
	Default _cDesc2	  := ""
	Default _xContSPA := _xConteudo
	Default _cDscSPA  := _cDescric
	Default _cDscSPA1 := _cDesc1
	Default _cDscSPA2 := _cDesc2
	Default _xContENG := _xConteudo
	Default _cDscENG  := _cDescric
	Default _cDscENG1 := _cDesc1
	Default _cDscENG2 := _cDesc2
	Default _cPYME    := ""

	AAdd(_xArea,SX6->( GetArea() ))    
	
	SX6->( OrdSetFocus(1) ) //X6_FILIAL+X6_VAR
	
	_lUpdate := SX6->( DbSeek(_cFilial+_cParam) )

	If RecLock("SX6",!_lUpdate)
		If !_lUpdate
			SX6->X6_FIL := _cFilial
			SX6->X6_VAR := _cParam            
		EndIf
		
		SX6->X6_TIPO	:= _cTipo
		SX6->X6_DESCRIC := _cDescric
		SX6->X6_DSCSPA  := _cDscSPA
		SX6->X6_DSCENG  := _cDscENG
		SX6->X6_DESC1   := _cDesc1
		SX6->X6_DSCSPA1 := _cDscSPA1
		SX6->X6_DSCENG1 := _cDscENG1
		SX6->X6_DESC2   := _cDesc2
		SX6->X6_DSCSPA2 := _cDscSPA2
		SX6->X6_DSCENG2 := _cDscENG2
		SX6->X6_CONTEUD := _xConteudo
		SX6->X6_CONTSPA := _xContSPA
		SX6->X6_CONTENG := _xContENG
		SX6->X6_PROPRI  := _cPropri
		SX6->X6_PYME    := _cPYME
		
		SX6->( MsUnlock() )
	EndIf
			
	U_PushArea( _xArea )
Return .T.

/*==========================================================================
|Funcao    | CnvItemC           | Raimundo Santana      | Data | 29/12/07  |
============================================================================
|Descricao | Converte Item Contabil antigo no novo item contábil baseado   |
|          | na tabela de amarração item antigo X item novo (UTD) levando  |
|          | em conta a data do sistema e a data inicial de existencia da  |
|          | amarração na tabela UTD									   |
============================================================================
|Parametros| _cItemCC : Codigo do item contabil							   |
|						 												   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CnvItemC(_cItemCC)                       
	Local _xArea	:= {}  
	Local _lReadVar	:= .F.

	If _cItemCC==NIL
		_cItemCC  := &(ReadVar())
		_lReadVar := .T.
	EndIf
	
	If !Empty(_cItemCC) .And. !( Upper(Trim(FunName()))=="MATA330" .Or. ( Upper(Trim(FunName()))=="RPC" .And. U_fIsExec("M330JCTB") ) )
	    _cItemCC := PadR(RTrim(_cItemCC),Len(UTD->UTD_ITEMCA))
	    
		aAdd( _xArea, UTD->( GetArea() ) )
		
		UTD->( OrdSetFocus(1) )

		If 	UTD->( DbSeek(FWXFilial("UTD")+_cItemCC) ) .And. dDataBase >= UTD->UTD_DTEXIS
			_cItemCC := UTD->UTD_ITEMCN 
			
			If _lReadVar
				&(ReadVar()) := _cItemCC
			EndIf
		EndIf

	    u_PushArea( _xArea )
	EndIf
Return _cItemCC

/*==========================================================================
|Funcao    | ItemCPad           | Raimundo Santana      | Data | 30/12/07  |
============================================================================
|Descricao | Retorna o Item Contabil padrão da filial					   |
|						 												   |
============================================================================
|Parametros| _cItemCC : Codigo do item contabil a ser retornado se não 	   |
|			            existe item padrão na filial					   |
============================================================================
|Observações: Utiliza o parametro MV_ITCCPAD nos formatos:				   |
|			  1 - Item padrão Ex.: 1102									   |
|			  2 - Lista Ano X Item padrão Ex.: 2007=1102,2008=1103,*=1104  |
|			 															   |
==========================================================================*/
User Function ItemCPad(_cItemCC)
	Local _cItemPad
	Local _nPos
	Local _cBusca
	
	Default _cItemCC := ""
	
	_cItemPad := AllTrim(GetNewPar('MV_ITCCPAD',''))

	If !Empty(_cItemPad)
		Do While At(" ",_cItemPad) > 0
			_cItemPad := StrTran(_cItemPad," ","")
		EndDo
		
		_cBusca := StrZero(Year(dDataBase),4)+"="
		
		_nPos := At(_cBusca,_cItemPad)
		If _nPos==0
			_cBusca := "*="
		EndIf            
		
		If _nPos > 0
			_cItemPad := AllTrim(SubStr(_cItemPad,_nPos+Len(_cBusca)))
		ElseIf At("=",_cItemPad) > 0 .Or. At(",",_cItemPad) > 0
			_cItemPad := ""
		EndIf
			
		_nPos := At(",",_cItemPad)
		If _nPos > 0
			_cItemPad := AllTrim(Left(_cItemPad,_nPos-1))
		EndIf
		
		_cItemCC := _cItemPad
	EndIf
	
Return _cItemCC

/*==========================================================================
|Funcao    | CnvCFOP            | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Converte CFOP para o CFOP básico. Ex. 6101 para 5101 ou       |
|			 3101 para 1101.											   |
============================================================================
|Parametros| _cCF = CFOP a converter									   |
|																		   |
============================================================================
|Observações: Mantem CFOPs que não podem ser convertidos. Ex. 6107		   |
|			 															   |
==========================================================================*/
User Function CnvCFOP(_cCF)
	_cCF := AllTrim(_cCF)
	
	Do Case
		Case _cCF $ '6107/6108/6404'
			_cCF := '6'+SubStr(_cCF,2,3)
		Case Left(_cCF,1) >= '5'
			_cCF := '5'+SubStr(_cCF,2,3)
		OtherWise
			_cCF := '1'+SubStr(_cCF,2,3)
	End Case
Return _cCF

/*==========================================================================
|Funcao    | AjtCFOP            | Raimundo Santana      | Data | 30/03/11  |
============================================================================
|Descricao | Ajusta o CFOP para o adequado à operação.					   |
|			      														   |
============================================================================
|Parametros| _cCF 		= CFOP a converter								   |
|			 _cUFClFor	= UF do Destinatário/Remetente					   |
|			 _cTipoCli  = Tipo do CLiente:								   |
|							F = Consumidor Final						   |
|							R = Revenda									   |
============================================================================
|Observações: Mantem CFOPs que não podem ser convertidos. Ex. 6107		   |
|			 															   |
==========================================================================*/
User Function AjtCFOP(_cCF,_cUFClFor,_cTipoCli)
	Local _cUFEmp := GetNewPar("MV_ESTADO","  ")
	
	Default _cUFClFor := _cUFEmp
	Default _cTpClFor := "R"
	
	_cCF 	  := AllTrim(_cCF)
	_cUFEmp   := Upper(Alltrim(_cUFEmp))
	_cUFClFor := Upper(Alltrim(_cUFClFor))
	_cTipoCli := Upper(Alltrim(_cTipoCli))
	
	If Left(_cCF,1) $ "15" .And. _cUFClFor<>_cUFEmp
		If _cUFClFor=="EX"
			_cCF := IIF(Left(_cCF,1)=="1","3","7") + SubStr(_cCF,2)
		Else
			_cCF := IIF(Left(_cCF,1)=="1","2","6") + SubStr(_cCF,2)
			
			If _cTipoCli=="F"
				Do Case
					Case _cCF=='6101'
						_cCf := '6107'
					Case _cCf=='6102'
						_cCF := '6108'
				EndCase
    		EndIf
		Endif
	EndIf
		
Return _cCF

/*==========================================================================
|Funcao    | TpCFOP             | Raimundo Santana      | Data | 06/06/08  |
============================================================================
|Descricao | Retorna tipo de CFOP (C,T,V) incluindo D na frente para       |
|			 devoluções. 												   |
============================================================================
|Parametros| _cCF = CFOP 												   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function TpCFOP(_cCf)
  Local _cSCF
  Local _cRet := ""   
  
  _cCF  := AllTrim(_cCF)
  _cSCF := SubStr(_cCF,2,3)
  
  If _cCF < '5000'
  	Do Case
  		Case ( _cSCF >= '101' .And. _cSCF <= '123' ) .Or.;
  			 ( _cSCF >= '251' .And. _cSCF <= '257' ) .Or.;
  			 ( _cSCF >= '401' .And. _cSCF <= '407' ) .Or.;
  			 ( _cSCF >= '651' .And. _cSCF <= '653' ) .Or.;
  			 ( _cSCF $ '126|551|556|604|922' )

  			_cRet := 'C'
  		Case ( _cSCF >= '151' .And. _cSCF <= '154' ) .Or.;
  			 ( _cSCF >= '408' .And. _cSCF <= '409' )
  			_cRet := 'T'
  		Case ( _cSCF >= '410' .And. _cSCF <= '411' ) .Or.;
  			 ( _cSCF >= '201' .And. _cSCF <= '207' )
  			_cRet := 'DV'
  		Case ( _cSCF >= '208' .And. _cSCF <= '209' )
  			_cRet := 'DT'
	End Case  			
  Else
  	Do Case
  		Case ( _cSCF >= '101' .And. _cSCF <= '123' ) .Or.;
  			 ( _cSCF >= '401' .And. _cSCF <= '405' )
  			_cRet := 'V'
  		Case ( _cSCF >= '151' .And. _cSCF <= '156' ) .Or.;
  			 ( _cSCF >= '408' .And. _cSCF <= '409' )
  			_cRet := 'T'
  		Case ( _cSCF >= '410' .And. _cSCF <= '413' ) .Or.;
  			 ( _cSCF >= '201' .And. _cSCF <= '207' ) .Or.;
  			 ( _cSCF >= '660' .And. _cSCF <= '662' ) .Or.;
  			 ( _cSCF $ '210|553|556' )

  			_cRet := 'DC'
 		Case ( _cSCF >= '208' .And. _cSCF <= '209' )
  			_cRet := 'DT'
	End Case   
  EndIf 

Return _cRet

/*==========================================================================
|Funcao    | TpFilFis            | Raimundo Santana      | Data | 02/06/08 |
============================================================================
|Descricao | Retorna tipos de operações fiscais permitidas na filial.      |
|			 															   |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: Retorna lista de operações fiscais permitidas:			   |
|			  I = CFOPs de Industrialização								   |
|			  R = CFOPs de Revenda										   |
|			 															   |
==========================================================================*/
User Function TpFilFis()
	Local _cRet

    //I=Industrializaçao, R=Revenda
	_cRet := Upper(AllTrim(GetNewPar("MV_TPFLFIS","IR")))
	
Return _cRet

/*==========================================================================
|Funcao    | CfopIND            | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Retorna lista de CFOPs de Industrialização baseando-se no     |
|			 parametro MV_CFOPIND.										   |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CfopIND()
	Local _cRet
	
	_cRet := GetNewPar("MV_CFOPIND","1101|1111|1116|1122|1151|1201|1203|1208|1401|1408|1414|5101|5103|5105|5109|5111|5113|5116|5118|5122|5151|5155|5201|5208|5401|5402|5408|5414")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet  

/*==========================================================================
|Funcao    | CfopREV            | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Retorna lista de CFOPs de revenda baseando-se no parametro    |
|			 MV_CFOPREV.  										           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CfopREV()
	Local _cRet
	
	_cRet := GetNewPar("MV_CFOPREV","1102|1113|1117|1118|1121|1152|1202|1204|1209|1403|1409|1411|1415|5102|5104|5106|5112|5114|5115|5117|5119|5123|5152|5156|5202|5209|5403|5405|5409|5411|5415")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet

/*==========================================================================
|Funcao    | CtaMC              | Raimundo Santana      | Data | 06/09/11  |
============================================================================
|Descricao | Retorna lista de contas contábeis para materiais de consumo   |
|			 baseando-se no parametro MV_CTACMC.                           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CtaMC()
	Local _cRet
	
	_cRet := GetNewPar("MV_CTACMC","42102014")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet     


/*==========================================================================
|Funcao    | CtaPI              | Raimundo Santana      | Data | 06/09/11  |
============================================================================
|Descricao | Retorna lista de contas contábeis para produtos intermediarios|
|			 baseando-se no parametro MV_CTACPI.                           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CtaPI()
	Local _cRet
	
	_cRet := GetNewPar("MV_CTACPI","11302003")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet

/*==========================================================================
|Funcao    | CtaIND             | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Retorna lista de contas contábeis para produtos               |
|			 industrializados baseando-se no parametro MV_CTACIND.         |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CtaIND()
	Local _cRet
	
	_cRet := GetNewPar("MV_CTACIND","11302002|11302003|11302013|11302014")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet

/*==========================================================================
|Funcao    | CtaREV             | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Retorna lista de contas contábeis para produtos de  revenda   |
|			 baseando-se no parametro MV_CTACREV.				           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CtaREV()
	Local _cRet
	
	_cRet := GetNewPar("MV_CTACREV","11302001|11302015|11302016")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet     

/*==========================================================================
|Funcao    | CtaCOMP            | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Retorna lista de contas contábeis para componentes            |
|			 baseando-se no parametro MV_CTACCOM.				           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CtaCOMP()
	Local _cRet
	
	_cRet := GetNewPar("MV_CTACCOM","11301001|11301002|11301003|11301004|11301005|11301006")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet       


/*==========================================================================
|Funcao    | CtaEst            | Raimundo Santana      | Data | 02/06/08  |
============================================================================
|Descricao | Retorna lista de contas contábeis válidas para o estoque      |
|			 baseando-se no parametro MV_CTACEST.				           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CtaEst()
	Local _cRet
	
	_cRet := GetNewPar("MV_CTACEST","11301001|11301002|11301003|11301004|11301005|11301006|11302001|11302015|11302016|11302002|11302003|11302013|11302014|11302005|11302008|42113004")
	_cRet := "|"+AllTrim(_cRet)+"|"
Return _cRet
              

/*==========================================================================
|Funcao    | TMNObrOP           | Raimundo Santana      | Data | 02/04/09  |
============================================================================
|Descricao | Verifica se a TM fornecida não tem obrigatoriedade do número  |
|            da OP. Baseia-se no parametro MV_LTMNOOP.			           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: Depende do parametro MV_NROPOBR = "S"						   |
|			 															   |
==========================================================================*/
User Function TMNObrOP(_cTM)
	Local _lRet := .F.
	Local _cLstTM
	
	Default _cTM := ""
	
	If !Empty(_cTM)
		_cLstTM := "|"+GetNewPar('MV_LTMNOOP','201|701')+"|"
		_lRet := ( PadR(_cTM,3) $ _cLstTM)
	EndIf
Return _lRet 
 
/*==========================================================================
|Funcao    | TMDesmon           | Raimundo Santana      | Data | 26/03/09  |
============================================================================
|Descricao | Verifica se a TM fornecida é de desmonte.					   |
|            Baseia-se no parametro MV_LTMDESM.					           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function TMDesmon(_cTM)
	Local _lRet := .F.
	Local _cLstTM
	
	Default _cTM := ""
	
	If !Empty(_cTM)
		_cLstTM := "|"+GetNewPar('MV_LTMDESM', '203|703')+"|"
		_lRet := ( PadR(_cTM,3) $ _cLstTM)
	EndIf
Return _lRet         

/*==========================================================================
|Funcao    | TMDesmon           | Raimundo Santana      | Data | 07/12/11  |
============================================================================
|Descricao | Verifica se o usuário tem acesso a TM fornecida sem OP.       |
|                                                 				           |
============================================================================
|Parametros| 															   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function AcTmQSOP(_cTM,_lShowMens)
	Local _lRet

	Default _lShowMens := .T.

	_lRet := u_ChkFunc( 'TMQTDSEMOP'+_cTM,,,, 'processos utilizando a TM '+_cTM+' sem OP',.F. )

	If !_lRet		
		_lRet := u_ChkFunc( 'TMQTDSEMOP',,,, 'processos utilizando TMs com quantidade e sem OP',_lShowMens )
	EndIf
	
Return _lRet

/*==========================================================================
|Funcao    | RgbColor           | Raimundo Santana      | Data | 05/06/08  |
============================================================================
|Descricao | Convert cores fornecidas no formato RGB para um número que    |
|			 representa a cor no sistema.								   |
============================================================================
|Parametros| nRed   = Luminosidade da cor vermelha 0 à 255				   |
|			 nGreen = Luminosidade da cor verde 0 à 255					   |	
|			 nBlue  = Luminosidade da cor azul 0 à 255	                   |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function RgbColor(nRed,nGreen,nBlue)
	Default nRed   := 0
	Default nGreen := 0
	Default nBlue  := 0
	
	If nRed < 0
		nRed := 0
	ElseIf nRed > 255
		nRed := 255
	EndIf

	If nGreen < 0
		nGreen := 0
	ElseIf nGreen > 255
		nGreen := 255
	EndIf			

	If nBlue < 0
		nBlue := 0
	ElseIf nBlue > 255
		nBlue := 255
	EndIf			
	
Return ( nRed + ( nGreen * 256 ) + ( nBlue * 65536 ) )

/*==========================================================================
|Funcao    | CnvColor           | Raimundo Santana      | Data | 05/06/08  |
============================================================================
|Descricao | Converte string com cores fornecidas no formato RGB para o    |
|			 equivalente numerico que possa ser avaliado internamente	   |
============================================================================
|Parametros| _cColor = String com as cores							       |
|																		   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function CnvColor(_cColor)            
	Default _cColor := ""
	
	_cColor := Replace(_cColor," ","")

	_cColor := Replace(_cColor,"CLR_BLACK","0")
	_cColor := Replace(_cColor,"CLR_BLUE","8388608")
	_cColor := Replace(_cColor,"CLR_GREEN","32768")
	_cColor := Replace(_cColor,"CLR_CYAN","8421376")
	_cColor := Replace(_cColor,"CLR_RED","128")
	_cColor := Replace(_cColor,"CLR_MAGENTA","8388736")
	_cColor := Replace(_cColor,"CLR_BROWN","32896")
	_cColor := Replace(_cColor,"CLR_HGRAY","12632256")
	_cColor := Replace(_cColor,"CLR_LIGHTGRAY","12632256")
	_cColor := Replace(_cColor,"CLR_GRAY","8421504")
	_cColor := Replace(_cColor,"CLR_HBLUE","16711680")
	_cColor := Replace(_cColor,"CLR_HGREEN","65280")
	_cColor := Replace(_cColor,"CLR_HCYAN","16776960")
	_cColor := Replace(_cColor,"CLR_HRED","255")
	_cColor := Replace(_cColor,"CLR_HMAGENTA","16711935")
	_cColor := Replace(_cColor,"CLR_YELLOW","65535")
	_cColor := Replace(_cColor,"CLR_WHITE","16711935")

	_cColor := Replace(_cColor,"RGB(","U_RgbColor(")
	
Return _cColor                          

/*==========================================================================
|Funcao    | fxFilDef           | Raimundo Santana      | Data | 08/04/08  |
============================================================================
|Descricao | Retorna o código da filial para um determinado arquivo        |
|          | permitindo que se defina a filial a retornar caso o arquivo   |
|          | seja exclusivo.											   |
============================================================================
|Parametros| _cAlias  : Alias do arquivo. Case não fornecido utiliza o 	   |
|					    arquivo em uso.									   |
|			 _cFilial : Filial a retornar. Caso não fornecido retorna a    |
|			            a filial em uso                                    |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function fxFilDef(_cAlias,_cFilial)   
	Local _cRet        
	
	Default _cAlias := Alias()
	
	_cRet := FWXFilial(_cAlias)

	If _cFilial!=NIL .And. !Empty(_cRet)
		_cRet := _cFilial
	EndIf
Return _cRet

/*==========================================================================
|Funcao    | AddCpoDf           | Raimundo Santana      | Data | 25/11/08  |
============================================================================
|Descricao | Adiciona novo campo a um array de campos utilizando as        |
|          | caracteristicas de um campo do dicionario de dados como       |
|          | padrão. 													   |
============================================================================
|Parametros| 															   |
============================================================================
|Observações: 															   |
|			 															   |
==========================================================================*/
User Function AddCpoDf(_aCampos,_cCampo,_cCpoDef,_cTipo,_nTam,_nDec,;
 					   _cPicture, _cTitulo, _nQtdRet, _aCpoExtra, _aValExtra )
    Local _aCampo
    
	Default _cCpoDef := _cCampo
	Default _cTipo   := GetSx3Cache(_cCpoDef,"X3_TIPO")
	Default _nTam    := TamSX3(_cCpoDef)[1]
	Default _nDec    := TamSX3(_cCpoDef)[2]

	Default _nQtdRet  := 4
	
	_aCampo := { _cCampo, _cTipo, _nTam, _nDec }
	
	If _nQtdRet >= 5
		Default _cPicture := AllTrim(GetSx3Cache(_cCpoDef,"X3_PICTURE"))

		AAdd(_aCampo, _cPicture)
	EndIf

	If _nQtdRet >= 6
		If _cTitulo==NIL
			#IFDEF SPANISH
				_cTitulo := AllTrim(GetSx3Cache(_cCpoDef,"X3_TITSPA"))
			#ELSE
				#IFDEF ENGLISH
					_cTitulo := AllTrim(GetSx3Cache(_cCpoDef,"X3_TITENG"))
				#ELSE
					_cTitulo := AllTrim(GetSx3Cache(_cCpoDef,"X3_TITULO"))
				#ENDIF
			#ENDIF
		EndIf
		
		AAdd(_aCampo, _cTitulo)
	EndIf 
	
	If ValType(_aCpoExtra)=="A"
		AEval(_aCpoExtra,{|xCpoX3| AAdd(_aCampo,IIF(ValType(xCpoX3)=="B",Eval(xCpoX3,_cCpoDef),GetSx3Cache(_cCpoDef,xCpoX3))) })
	EndIf

	If ValType(_aValExtra)=="A"
		AEval(_aValExtra,{|xItem| AAdd(_aCampo,xItem) })
	EndIf
	
	AAdd(_aCampos, _aCampo )
Return .T.


/*==========================================================================
|Funcao    | fCriaTrb           | Raimundo Santana      | Data | 01/08/08  |
============================================================================
|Descricao | Retorna o nome de um arquivo temporário.					   |
|          | 															   |
============================================================================
|Parametros| _aStruct : Estrutura do arquivo temporário a criar (Opcional) |
|			 _lCria   : Define se cria o arquivo temporário (Opcional)     |
|			            Default .T.										   |
|			 _cDriver : Nome do driver a utilizar (Opcional)			   |
|			 	        Default padrão do sistema (DBFCDX)				   |
|			 	        Se utilizar "TOPCONN" o nome do arquivo iniciará   |
|			 	        com "ZZ" 										   |
============================================================================
|Observações: O nome do arquivo retornado sempre terá 8 caracteres,		   |
|			  compondo-se de 2 letras + 6 numeros aleatorios			   |
==========================================================================*/
User Function fCriaTrb(_aStruct,_lCria,_cDriver)
	Local _cFileName  
	
	Default _lCria 	 := .T.
	
	If _cDriver == NIL
		_cFileName := CriaTrab(_aStruct,_lCria)
	Else
		_cFileName := CriaTrab(NIL, .F.)
		_cDriver := Upper(AllTrim(_cDriver))
		
		If _cDriver=="TOPCONN"
			_cFileName := Replace(_cFileName,"SC","ZZ")
		EndIf

		If _lCria
			DbCreate(_cFileName,_aStruct,_cDriver)	
		EndIf
	EndIf	

Return _cFileName      

/*==========================================================================
|Funcao    | MsgWait            | Raimundo Santana      | Data | 01/01/07  |
============================================================================
|Descricao | Mostra uma mensagem na tela e espera um tempo especificado    |
|          | atualizando a barra de status automaticamente com incproc	   |
============================================================================
|Parametros| cMens  : Mensagem no caption da tela de mensagem			   |
|			 nSeg   : Numero de Segundos a esperar						   |
|			 cMens2 : Mensagem acima da barra de status (Opcional)		   |	
|																		   |
============================================================================
|Observações: 															   |
|																		   |
==========================================================================*/
User Function MsgWait(cMens,nSeg,cMens2,_lBtnCan)
	Default nSeg	 := 3
	Default cMens2	 := ""                      
	Default _lBtnCan := .T.

	Processa( {|lEnd| U_Espera(nSeg,@lEnd) }, cMens,cMens2,_lBtnCan )
Return .T.

/*==========================================================================
|Funcao    | Espera             | Raimundo Santana      | Data | 01/01/07  |
============================================================================
|Descricao | Espera um tempo especificado atualizando automaticamente a    |
|          | barra de status com incproc								   |
============================================================================
|Parametros| nSeg : Numero de Segundos a esperar						   |
|			 lEnd : Retorno do botao de cancelar (Passagem por referencia) |
|																		   |
============================================================================
|Observações: 															   |
|																		   |
==========================================================================*/
User Function Espera(nSeg,lEnd)
	nSeg *= 10
	
    ProcRegua(nSeg,.T.)

	Do While nSeg > 0
		nSeg--

	    IncProc()

		If lEnd
			Exit
		EndIf
		
		Sleep(100)
	EndDo
Return         

/*==========================================================================
|Funcao    | TypeObjP           | Raimundo Santana      | Data | 08/09/08  |
============================================================================
|Descricao | Retorna o Tipo de uma propriedade do objeto fornecido         |
|          | barra de status com incproc								   |
============================================================================
|Parametros| _oObj  : Variavel objeto a verificar                          |
|			 _cProp : String com o nome da propriedade para verificar      |
|					  é possível verificar encadeamento de propriedades    |
|					  tipo PropA:PropB                                     |
============================================================================
|Observações: Utiliza uma variável private para efetuar a verificação do   |
|			  objeto fornecido											   |
==========================================================================*/
User Function TypeObjP(_oObj,_cProp)
	Private __oObjTstL
	
	__oObjTstL := _oObj     
	
	_cProp := AllTrim(_cProp)

Return Type("__oObjTstL:"+_cProp)


/*==========================================================================
|Funcao    | DlgCtlVC           | Raimundo Santana      | Data | 08/09/08  |
============================================================================
|Descricao | Retorna um controle específico contido no objeto dialogo      |
|          | fornecido												       |
============================================================================
|Parametros| _oDlg     : Variavel objeto dialogo						   |
|			 _cReadVar : String com o nome da variável ReadVar associada   |
|			  	       ao controle                                         |
|			_cClassNam : String com o nome da classe do objeto (Opcional)  |
============================================================================
|Observações: 															   |
|																		   |
==========================================================================*/
User Function DlgCtlVC(_oDlg,_cReadVar,_cClassNam)
	Local _nIndex := 0
	Local _nCt

	Default _cClassNam := ""
	
	_cClassNam := Upper(AllTrim(_cClassNam))
	_cReadVar  := Upper(AllTrim(_cReadVar))

	If ValType(_oDlg)=="O" 
		If U_TypeObjP(_oDlg,"aControls")=="A"
			For _nCt:=1 To Len(_oDlg:aControls)
				If ( Empty(_cClassNam) .Or. _oDlg:aControls[_nCt]:ClassName()==_cClassNam )
					If U_TypeObjP(_oDlg:aControls[_nCt],"cReadVar")=="C" .And. Upper(AllTrim(_oDlg:aControls[_nCt]:cReadVar))==_cReadVar 
						_nIndex := _nCt
						Exit
					EndIf
				EndIf
			Next
		EndIf
	EndIf

Return IIF(_nIndex > 0,_oDlg:aControls[_nIndex],NIL)	

/*==========================================================================
|Funcao    | NormIPAD           | Raimundo Santana      | Data | 28/02/09  |
============================================================================
|Descricao | Função utilizada para normalizar o endereço IP.               |
|          | Ex.: 192.168.1.23 -> 192.168.001.023						   |
============================================================================
|Parametros| _cIpAddr  : String com o endereço IP						   |
|																		   |
============================================================================
|Retorno   | Endereço IP normalizado									   |
|																		   |
==========================================================================*/
User Function NormIPAD(_cIpAddr)
	Local _cRet	:= ""
	Local _nPos
	Local _nPos2
	Local _cNum 
	
	_cIpAddr := AllTrim(_cIpAddr)

	Do While !Empty(_cIpAddr)
		_nPos := AT(".",_cIpAddr)
		_nPos2 := AT(",",_cIpAddr)
		If _nPos2==0
			_nPos2 := AT(";",_cIpAddr)
		Else             
			If AT(";",_cIpAddr) > 0
				_nPos2 := Min(AT(";",_cIpAddr))
			EndIf
		EndIf

		If _nPos2 > 0
			If _nPos==0
				_nPos:=_nPos2
			Else
				_nPos:=Min(_nPos,_nPos2)
			EndIf
		EndIf

		If _nPos==0
			_cNum 	 := AllTrim(_cIpAddr)
			_cIpAddr := ""
		Else
			_cNum 	 := AllTrim(Left(_cIpAddr,_nPos-1))
			_cIpAddr := AllTrim(SubStr(_cIpAddr,_nPos+1))
		EndIf
			
		_cRet += PadL(_cNum,3,"0")
		If !Empty(_cIpAddr)
			_cRet += "."
		EndIf
	EndDo
Return PadR(_cRet,15)
	 
/*==========================================================================
|Funcao    | GtDuraca           | Raimundo Santana      | Data | 28/02/09  |
============================================================================
|Descricao | Função utilizada para calcular a duração entre 2 períodos     |
|          | com data, hora, minutos e segundos.						   |
============================================================================
|Parametros| _dDataIni : Data inicial									   |
| 			 _cHoraIni : Hora Inicial Formato hh:mm:ss					   |
|		     _dDataFim : Data Final										   |
| 			 _cHoraFim : Hora Final Formato hh:mm:ss					   |
|																		   |
============================================================================
|Retorno   | String com a duração no formato dd:hh:mm:ss				   |
|																		   |
==========================================================================*/
User Function GtDuraca(_dDataIni,_cHoraIni,_dDataFim,_cHoraFim)
	Local _cRet                  
	Local _nSegIni
	Local _nSegFim
	Local _nSeg
	Local _nMin
	Local _nHoras
	Local _nDias                   
	
	Default _cHoraIni := "00:00:00"
	Default _cHoraFim := "24:00:00" 
	
	_nSegIni := Val(Left(_cHoraIni,2))*3600
	_nSegIni += Val(SubStr(_cHoraIni,4,2))*60
	_nSegIni += Val(SubStr(_cHoraIni,7,2))

	_nSegFim := Val(Left(_cHoraFim,2))*3600
	_nSegFim += Val(SubStr(_cHoraFim,4,2))*60
	_nSegFim += Val(SubStr(_cHoraFim,7,2))
	
	_nSeg := _nSegFim-_nSegIni
	_nSeg += (_dDataFim-_dDataIni)*86400
	
	_nDias := Int(_nSeg/86400)
	_nSeg  -= _nDias*86400
	
	_nHoras := Int(_nSeg/3600)
	_nSeg   -= _nHoras*3600
	
	_nMin := Int(_nSeg/60)
	_nSeg -= _nMin*60
	
	_cRet := PadL(AllTrim(Str(_nDias)),2,"0")
	_cRet += ":"+PadL(AllTrim(Str(_nHoras)),2,"0")	
	_cRet += ":"+PadL(AllTrim(Str(_nMin)),2,"0")	
	_cRet += ":"+PadL(AllTrim(Str(_nSeg)),2,"0")	
	
Return _cRet

/*==========================================================================
|Funcao    | DefObCpo        | Autor | Raimundo Santana   | Data |16/03/09 |
============================================================================
|Descricao | Muda a definição de campos obrigatórios para os campos        |
|            fornecidos para a tela atual                                  |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function DefObCpo(_lAtiva,_aCampos)
	Local _nPos

	Default _lAtiva := .T.     

	If Type('aGets')=='A'
		For _nCt:=1 To Len(_aCampos)
			_nPos := aScan( aGets, { |cDef| Upper(AllTrim(Substr(cDef,9,10))) == Upper(AllTrim(_aCampos[_nCt])) } )

			If _nPos > 0
				aGets[_nPos]:=Stuff(aGets[_nPos],25,1,IIF(_lAtiva,'T','F'))
			EndIf
		Next
	EndIf
Return .T.

/*==========================================================================
|Funcao    | OrdSoma1        | Autor | Raimundo Santana   | Data |17/03/09 |
============================================================================
|Descricao | Funcão soma1 para ordem de campos do SX3                      |
|																		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function OrdSoma1(_cOrdem)
	If _cOrdem==Replicate("9",Len(_cOrdem))
		_cOrdem := "A"+Replicate("0",Len(_cOrdem)-1)
	Else
		_cOrdem=Soma1(_cOrdem)
	EndIf
Return _cOrdem

/*==========================================================================
|Funcao    | StatPedV        | Autor | Raimundo Santana   | Data |19/03/09 |
============================================================================
|Descricao | Funcão que retorna o status do pedido de venda, onde:		   |
|		   | 	0    = Pedido de venda não encontrado					   |
|		   | 	1    = Pedido de venda Em Aberto						   |
|		   | 	2    = Pedido de venda Encerrado						   |
|		   | 	3    = Pedido de venda Liberado							   |
|		   | 	4    = Pedido de venda bloqueado por Regra				   |
|		   | 	5    = Pedido de venda bloqueado por Verba				   |
|		   | 	6..8 = Status reservado para uso futuro					   |
|		   | 	9    = Pedido de venda com bloqueado não especificado	   |
|		   | 	99   = Pedido de venda com status não especificado		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function StatPedV(_cPedido,_cFilial)
	Local _nRet := 0
	Local _xArea	:= {}
	
	Default _cFilial := FWXFilial("SC5")
	
	aAdd( _xArea, SC5->( GetArea() ) )                  

	SC5->( OrdSetFocus(1) ) //C5_FILIAL+C5_NUM
	
	If SC5->( DbSeek(_cFilial+_cPedido) )
		Do Case
			Case Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)
				_nRet := 1	//Pedido em Aberto
			Case !Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ)
				_nRet := 2	//Pedido Encerrado
			Case !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)
				_nRet := 3  //Pedido Liberado
			Case SC5->C5_BLQ == '1'
				_nRet := 4 	//Pedido Bloquedo por regra
			Case SC5->C5_BLQ == '2'
				_nRet := 5 	//Pedido Bloquedo por verba
			Case !Empty(SC5->C5_BLQ)
				_nRet := 5 	//Pedido com bloqueio não especificado
			OtherWise
				_nRet := 99 //Não especificado
		EndCase
	EndIf

	u_pushArea( _xArea ) 

Return _nRet

/*==========================================================================
|Funcao    | EspSerie        | Autor | Raimundo Santana   | Data |26/03/09 |
============================================================================
|Descricao | Funcão que determina a especie da nota fiscal baseando-se na  |
|            serie fornecida.											   |
|																		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function EspSerie(_cSerie)
	Local _nPos
	Local _cLstEspec
	Local _cSerNF
	Local _cEspNF
	Local _cRet		 := "NF"

	_cSerie	:= PadR(_cSerie,3)

	_cLstEspec := AllTrim(GetNewPar("MV_ESPECIE",""))
    
	Do While !Empty(_cLstEspec)
		_nPos := At(";",_cLstEspec)       
		
		If _nPos > 0
			_cSerNF	   := AllTrim(Left(_cLstEspec,_nPos-1))
			_cLstEspec := AllTrim(SubStr(_cLstEspec,_nPos+1))
		Else
			_cSerNF	   := _cLstEspec
			_cLstEspec := ""
		EndIf
		
		If !Empty(_cSerNF)
			_nPos := At("=",_cSerNF)
			
			If _nPos > 0
				_cEspNF := AllTrim(SubStr(_cSerNF,_nPos+1))
				_cSerNF := PadR(AllTrim(Left(_cSerNF,_nPos-1)),3)
				
				If _cSerNF==_cSerie 
					_cRet := _cEspNF
					_cLstEspec := ""
				EndIf
			EndIf    
		EndIf
	EndDo		
	
Return PadR(_cRet,5)

/*==========================================================================
|Funcao    | IsSerNFE        | Autor | Raimundo Santana   | Data |26/03/09 |
============================================================================
|Descricao | Funcão que determina se a serie fornecida é NF-e.			   |
|																		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function IsSerNFE(_cSerie)
	Local _lRet := .F.

	_lRet := (AllTrim(U_EspSerie(_cSerie))=="SPED") 
	
Return _lRet


/*==========================================================================
|Funcao    | SeriesNF        | Autor | Raimundo Santana   | Data |26/03/09 |
============================================================================
|Descricao | Funcão para retornar um array com as séries de notas fiscais  |
|			 disponíveis para a filial.									   |
|																		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function SeriesNF()
	Local _xArea	:= {}
	Local _aSeries  := {}   
	Local _cSerie
	Local _cFilSx5	:= FWXFilial("SX5")
	
	aAdd( _xArea, SX5->( GetArea() ) )                  
	SX5->( OrdSetFocus(1) ) //X5_FILIAL, X5_TABELA, X5_CHAVE

	IF ExistBlock("CHGX5FIL")
		_cFilSx5 := ExecBlock("CHGX5FIL",.f.,.f.)
	Endif

	SX5->( DbSeek(_cFilSX5+"01",.F.) )
	
	Do While ( SX5->X5_FILIAL == _cFilSX5 .And.;
			   SX5->X5_TABELA == "01" )

		//Se a Série for CPF, não mostra no aChoice, pois ‚ utilizada
		//internamente para emissao de Cupom Fiscal.
		If ( AllTrim(SX5->X5_CHAVE)!="CPF" .And. AllTrim(SX5->X5_CHAVE)!="CP")
			_cSerie := PadR(SX5->X5_CHAVE,3)
			
			AADD( _aSeries,{ _cSerie, U_IsSerNFE(_cSerie) })
		EndIf

		SX5->( DbSkip() )
	EndDo

	u_pushArea( _xArea )
Return _aSeries

/*==========================================================================
|Funcao    | XMLStruc        | Autor | Raimundo Santana   | Data |28/03/09 |
============================================================================
|Descricao | Funcão para retornar a estrutura (somente chaves) de uma      |
|			 string XML													   |
|																		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function XMLStruc(_cXML,_lDados,_nQtDesl)
	Local _nPosIni
	Local _nPosFim
	Local _nNivel                     
	Local _cChave        
	Local _cDados
	Local _cOldCh
	Local _cRet 	 := ""

	Default _lDados  := .F.                   
	Default _nQtDesl := 2
	
	_cOldCh := ""
	_cDados := ""
	_nNivel := 0

	Do While !Empty(_cXML)      
		_cChave := ""

		_nPosIni := At("<",_cXML)

		If _nPosIni > 0  
			_cDados := Left(_cXML,_nPosIni-1)
			_cXML 	:= SuBStr(_cXML,_nPosIni)
			
			If Left(_cXML,2)=="</"
				_nNivel--
			Else       
				_cDados := ""
				_nNivel++
			EndIf
			
			_nPosFim := At(">",_cXML)		
			
			If _nPosFim > 0       
				_cChave := AllTrim(Left(_cXML,_nPosFim))
				_cXML   := SuBStr(_cXML,_nPosFim+1)
			Else
				_cXML := ""
				_cRet := NIL
			EndIf
		Else
			_cXML := ""
			_cRet := NIL
		EndIf       

		If _cRet != NIL .And. !Empty(_cChave)  
			If Left(_cChave,2)!="</" 
				If !Empty(_cOldCh) .And. Left(_cOldCh,2)!="</" 
					_cRet += Chr(13)+Chr(10)
				EndIf

				_cRet += IIF(_nNivel==0,"",Space(_nNivel*_nQtDesl-_nQtDesl))+_cChave
			Else
				If Upper(Replace(_cChave,"</","<"))==Upper(Replace(_cOldCh,"</","<"))
					If _lDados
						_cRet += _cDados
					EndIf
					_cRet += _cChave+Chr(13)+Chr(10)
				Else
					If !Empty(_cRet) .And. Right(_cRet,2) <> Chr(13)+Chr(10)
						_cRet += Chr(13)+Chr(10)
					EndIf

					_cRet += Space((_nNivel+1)*_nQtDesl-_nQtDesl)+_cChave+Chr(13)+Chr(10)
				EndIf			
			EndIf
		EndIf

		_cOldCh := _cChave
	EndDo      
	
	If !Empty(_cRet) .And. Right(_cRet,2) <> Chr(13)+Chr(10)
		_cRet += Chr(13)+Chr(10)
	EndIf
	
Return _cRet

/*==========================================================================
|Funcao    | NoAcento        | Autor | Raimundo Santana   | Data |08/07/09 |
============================================================================
|Descricao | Funcão para retirar letras acentuadas de uma string		   |
|			 string XML													   |
|																		   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function NoAcento(cString,cStrCAlt,cCharDef)
	Local cChar  := ""
	Local nX     := 0 
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
	Local cTio   := "ãõÃÕñÑ"
	Local cCecid := "çÇ"       
	
	Default cStrCAlt := "&"
	Default cCharDef := "."
	
	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)

		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)

			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cCircu)

			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cTrema)

			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cCrase)

			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf		

			nY:= At(cChar,cTio)

			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAOnN",nY,1))
			EndIf		

			nY:= At(cChar,cCecid)

			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next

	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)

		If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ cStrCAlt
			cString:=StrTran(cString,cChar,cCharDef)
		Endif
	Next nX

Return cString

/*==========================================================================
|Funcao    | fGetEnd         | Autor | Raimundo Santana   | Data |07/07/09 |
============================================================================
|Descricao | Funcão para separar o endereço em Logradouro, Numero e        |
|			 complemento. Substitui a função FisGetEnd do sistema.         |
|																		   |
============================================================================
|Parametros| _cEnd      : String com o Endereço (Log., Num. e Complemento) |
|			 _lSoLogr   : Define se o Endereço somente contém o Logradouro |
|			 _lSemNum   : Define se retorna a string contendo a expressão  |
|						  contina no parametro _cSemNum (Default "SN")     |
|                         para endereços sem número.                       |
|			 _cSemNum   : String que representa Sem Número (Default "SN")  |
|            _lNSVirg   : Define tenta separar o número caso o endereço    |
|                         não contenha virgula.							   |
============================================================================
|Retorno:  Array  [1] - Logradouro                                         |
|			      [2] - Número (Numérico) (0=Sem Número)                   |
|			      [3] - Número (String) ("" ou _cSemNum para sem número)   |
|			      [4] - Complemento (String)                               |
============================================================================
|Observações: O Endereço tem que seguir o formato padrão do sistema        |
|             conforme regras abaixo:                                      |
|			  - Endereços sem virgula terminados com um número, SN ou S/N  |
|			    Será tratado como Logradouro e Número interpretendo SN ou  |
|               S/N como sem número.                                       |
|               Ex.: Av. XYZ 45                                            |
|                    Logradouro = "Av. XYZ"                                |
|                    Numero     = "45"                                     |
|                    Complemento= ""                                       |
|				Ex.: Av. XYZ S/N                                           |
|                    Logradouro = "Av. XYZ"                                |
|                    Numero     = ""                                       |
|                    Complemento= ""                                       |
|			  - Endereços com virgula                                      |
|			    Tudo antes da última virgula será tratado como Logradouro  |
|				e restante será tratado como Número+Complemento caso a     |
|				primeira incidência depois da virgula seja um número,SN ou |
|               S/N) ou do contrário somente Complemento.                  |
|               Ex.: Av. XYZ, 45                                           |
|                    Logradouro = "Av. XYZ"                                |
|                    Numero     = "45"                                     |
|                    Complemento= ""                                       |
|               Ex.: Av. XYZ, 45 BL A                                      |
|                    Logradouro = "Av. XYZ"                                |
|                    Numero     = "45"                                     |
|                    Complemento= "BL A"                                   |
|               Ex.: Av. XYZ, BL A                                         |
|                    Logradouro = "Av. XYZ"                                |
|                    Numero     = ""                                       |
|                    Complemento= "BL A"                                   |
==========================================================================*/
User Function fGetEnd(_cEnd,_lSoLogr,_lSemNum,_cSemNum,_lNSVirg)
	Local _aRet := {"",0,"",""}
	Local _nPos
	                                
	Default _lSoLogr := .F.
	Default _lSemNum := .F.
	Default _cSemNum := "SN"
	Default _lNSVirg := .F.
	
	_cEnd := AllTrim(_cEnd)
	
	If !Empty(_cEnd)
		If _lSoLogr
			_aRet[1] := _cEnd
		Else
			_nPos := Rat(",",_cEnd)
			
			If _nPos==0
				If (!_lNSVirg) .Or. (_nPos := Rat(" ",_cEnd))==0
					_aRet[1] := _cEnd
				Else				
					If U_SoNumeros(AllTrim(SubStr(_cEnd,_nPos+1))) .Or. "|"+Upper(AllTrim(SubStr(_cEnd,_nPos+1)))+"|" $ "|SN|S/N|"
						_aRet[1] := AllTrim(Left(_cEnd,_nPos-1))
						
						_aRet[3] := AllTrim(SubStr(_cEnd,_nPos+1))
					Else
						_aRet[1] := _cEnd
					EndIf                
				EndIf
			Else
				_aRet[1] := AllTrim(Left(_cEnd,_nPos-1))
				_cEnd    := AllTrim(SubStr(_cEnd,_nPos+1))

				_nPos := At(" ",_cEnd)
				
				If _nPos == 0
					If U_SoNumeros(_cEnd) .Or. "|"+Upper(_cEnd)+"|" $ "|SN|S/N|"
						_aRet[3] := _cEnd
					Else
						_aRet[4] := _cEnd
					EndIf
				Else
					If U_SoNumeros(AllTrim(Left(_cEnd,_nPos-1))) .Or. "|"+Upper(AllTrim(Left(_cEnd,_nPos-1)))+"|" $ "|SN|S/N|"
						_aRet[3] := AllTrim(Left(_cEnd,_nPos-1))
						_aRet[4] := AllTrim(SubStr(_cEnd,_nPos+1))
					Else
						_aRet[4] := _cEnd
					EndIf
				EndIf
			EndIf
		EndIf			
		
		If U_SoNumeros(_aRet[3])
			_aRet[2] := Val(_aRet[3])
		Else
			If _lSemNum
				_aRet[3] := "SN"
			Else
				_aRet[3] := ""
			EndIf
		EndIf                        

	EndIf

Return _aRet

/*==========================================================================
|Funcao    | AjStrEnd        | Autor | Raimundo Santana   | Data |13/07/09 |
============================================================================
|Descricao | Funcão para ajustar endereços, retira letras acentuadas e     |
|			 comprime espaços.											   |
============================================================================
|Modulo    |                                                               |
==========================================================================*/
User Function AjStrEnd(_cEnd)
	Local _nTam
	
	_nTam := Len(_cEnd)

	_cEnd := U_NoAcento(_cEnd)
	
	Do While At("  ",_cEnd) > 0
	  _cEnd := StrTran(_cEnd,"  "," ")
	EndDo         
	
	_cEnd := PadR(_cEnd,_nTam)
Return _cEnd

/*==========================================================================
|Funcao    | AtStrEnd        | Autor | Raimundo Santana   | Data |13/07/09 |
============================================================================
|Descricao | Funcão para montar o endereço a partir do Logradouro, Numero  |
|            e Complemento.                                                |
|																		   |
============================================================================
|Parametros| _cLog	    : String com o Logradouro						   |
|            _nNum      : Numero                 						   |
|            _cComp     : String com o Complemento                         |
============================================================================
|Retorno:  String com o endereço montato.                                  |
==========================================================================*/
User Function AtStrEnd(_cLog,_xNum,_cComp)
	Local _cNewEnd
	
	_cLog  := U_AjStrEnd(_cLog)
	_cComp := U_AjStrEnd(_cComp)
	
	_cNewEnd := AllTrim(_cLog)
		
	If !Empty(_xNum) .Or. !Empty(_cComp)
		_cNewEnd+=","
	EndIf
		
	If !Empty(_xNum)
		_cNewEnd+=" "+IIF(ValType(_xNum)=="N",AllTrim(Str(_xNum)),U_AjStrEnd(_xNum))
	EndIf
		
	If !Empty(_cComp)
		_cNewEnd+=" "+AllTrim(_cComp)
	EndIf        
	
	_cNewEnd := AllTrim(_cNewEnd)

Return _cNewEnd

/*==========================================================================
|Funcao    | VdEndSep        | Autor | Raimundo Santana   | Data |13/07/09 |
============================================================================
|Descricao | Funcão para validar digitação de endereço separado em         |
|            Logradouro, Numero e Complemento.                             |
|																		   |
============================================================================
|Parametros| _cLog	    : String com o Logradouro						   |
|            _nNum      : Numero                 						   |
|            _cComp     : String com o Complemento                         |
|            _cEnd      : String para retornar o endereço montado.         |
|                         (passar por referência)						   |
============================================================================
|Retorno:  .T. se o endereço for válido ou .F. se não.                     |
==========================================================================*/
User Function VdEndSep(_cLog,_nNum,_cComp,_cEnd,_lEndInv,_lAjusta)
	Local _lRet 	:= .T.
	Local _cNewEnd        
	
	Default _cEnd    := ""
	Default _lEndInv := .F.
	Default _lAjusta := .T.
	
	If _lRet .And. Empty(_cLog) .And. (!Empty(_nNum) .Or. !Empty(_cComp))
		Aviso("Atenção!","O Logradouro não pode ser vazio quando o número ou o complemente estiver preenchido!",{"Ok"})
		_lRet := .F.
	EndIf

	If _lRet .And. _lEndInv .And. Len(_cEnd) > 0 .And. !Empty(_cEnd)
		If Empty(_cLog) .And. Empty(_nNum) .And. Empty(_cComp)
			Aviso("Atenção!","O Endereço está inválido! Preencha os dados corretamente.",{"Ok"})
			_lRet := .F.
		EndIf
	
		If _lRet	
			_lRet := U_VdStrEnd(@_cEnd,"Endereço",_lAjusta,.F.)
		EndIf
	EndIf
	
	If _lRet
		_lRet := U_VdStrEnd(@_cLog,"Logradouro",_lAjusta)
	EndIf

	If _lRet
		_lRet := U_VdStrEnd(@_cComp,"Complemento",_lAjusta)
	EndIf
	
	If _lRet .And. Len(_cEnd) > 0
		_cNewEnd := U_AtStrEnd(_cLog,_nNum,_cComp)
		
		If Len(_cNewEnd) > Len(_cEnd)
			Aviso("Atenção!","O tamanho do endereço excede o total permitido em "+AllTrim(Str(Len(_cNewEnd)-Len(_cEnd)))+" caracteres! Reduza a quantidade de caracteres utilizados.",{"Ok"})
			_lRet := .F.
		EndIf

		If _lRet		
			_cEnd := PadR(_cNewEnd,Len(_cEnd))
		EndIf
	EndIf         
	
Return _lRet

/*==========================================================================
|Funcao    | VdStrEnd        | Autor | Raimundo Santana   | Data |13/07/09 |
============================================================================
|Descricao | Funcão para validar digitação de Logradouro e Complemento.    |
|																		   |
============================================================================
|Parametros| _cEnd	    : String com o Logradouro ou Complemento		   |
|                         (Se passado por referência retornará ajustado)   |
|            _cDescCpo  : String com a descrição do campo                  |
|                         "Logradouro" ou "Complemento"                    |
============================================================================
|Retorno:  .T. se válido ou .F. se não.                                    |
==========================================================================*/
User Function VdStrEnd(_cEnd,_cDescCpo,_lAjusta,_lBlqVirg)
	Local _lRet := .T.
	Local _nTam
	Local _cStrBlqF
	Local _cStrBlqI       
	Local _nCt

	Default _lAjusta  := .T.	
	Default _lBlqVirg := .T.
	
	_cStrBlqF := ",;:" 
	
	_cStrBlqI := IIF(_lBlqVirg,",","")

	If _lAjusta
		_cEnd :=  U_AjStrEnd(_cEnd)
	EndIf
	
	If !Empty(_cEnd)
		_lRet := !( Right(AllTrim(_cEnd),1) $ _cStrBlqF )

		If !_lRet
			Aviso("Atenção!","Não utilize '"+Right(AllTrim(_cEnd),1)+"' no final do "+_cDescCpo+"! Retire este caractere antes de finalizar a edição.",{"Ok"})
		EndIf    

		If _lRet
			For _nCt:=1 To Len(_cStrBlqI)
				If At(SubStr(_cStrBlqI,_nCt,1),_cEnd) > 0
					Aviso("Atenção!","Não utilize '"+SubStr(_cStrBlqI,_nCt,1)+"' dentro do "+_cDescCpo+"! Retire este caractere antes de finalizar a edição.",{"Ok"})
					_lRet := .F.
					Exit
				EndIf
			Next
		EndIf
		
		If _lRet .And. !( _cEnd==U_NoAcento(_cEnd) )
			Aviso("Atenção!","Não utilize letras acentuadas ou os caracteres 'çÇ' dentro do "+_cDescCpo+"! Altere este caractere antes de finalizar a edição.",{"Ok"})
			_lRet := .F.
		EndIf
	EndIf
		
Return _lRet      

/*==========================================================================
|Funcao    | MEndComp        | Autor | Raimundo Santana  | Data | 12/08/09 |
============================================================================
|Descricao | Funcão para montar o endereço completo a partir do Endereço,  |
|            CEP, Municipio e Estado								       |
|																		   |
============================================================================
|Parametros| _xEnd	    : String com o Endereço ou Array com Logradouro,   |
				          Numero e Complemento.							   |
|            _cCep      : String com o CEP         						   |
|            _cMun      : String com o Municipio	                       |
|            _cEst      : String com a UF do Estado						   |
============================================================================
|Retorno:  .T. se o endereço for válido ou .F. se não.                     |
==========================================================================*/
User Function MEndComp(_xEnd,_cBai,_cCep,_cMun,_cEst)
	Local _aEnd	  := { "", 0, "", "" }
	Local _cRet  

	Default _cBai := ""	
	Default _cCep := ""
	Default _cMun := ""
	Default _cEst := ""
	
	If ValType(_xEnd)=="A"     
		_aEnd[1] := AllTrim(_xEnd[1])                     
		
		If !Empty(_aEnd[1])
			If Len(_xEnd) >= 2
				Do Case
					Case ValType(_xEnd[2])=="C"
						_aEnd[3] := AllTrim(_xEnd[2])
	
						If U_SoNumeros(_aEnd[3])
							_aRet[2] := Val(_aEnd[3])
						EndIf
					Case ValType(_xEnd[2])=="N"
						_aEnd[2] := AllTrim(_xEnd[2])
                    
						If _aEnd[2] < 0
							_aEnd[2] := 0
						Else
							_aEnd[3] := AllTrim(Str(_aEnd[2]))
						EndIf
				EndCase
			EndIf
			
			If Len(_xEnd) >= 3
				_aEnd[4] := AllTrim(_xEnd[3])
			EndIf
		EndIf
	ElseIf ValType(_xEnd)=="C"     
		_aEnd := U_fGetEnd(_xEnd)
	EndIf		

	_cRet := U_AtStrEnd(_aEnd[1],_aEnd[3],_aEnd[4])
	
	If !Empty(_cRet) .And. !Empty(_cBai)
		_cRet += ", "+U_AjStrEnd(AllTrim(_cBai))
	EndIf

	If !Empty(_cRet) .And. !Empty(_cCep)
		_cRet += ", "+U_AjStrEnd(Transform( _cCep, PesqPict("SA1","A1_CEP")))
	EndIf

	If !Empty(_cRet) .And. !Empty(_cMun)
		_cRet += ", "+U_AjStrEnd(AllTrim(_cMun))
	   			
		If !Empty(_cEst)
  			_cRet += "-"+_cEst
   		EndIf
	EndIf
	
Return _cRet




/*=========================================================================
|Funcao    | fExistSX2         | Claudio Cavalcante    | Data | 26/01/10   |
============================================================================
|Descricao | Verifica se uma tabela existe no SX2                          | 
|          |                                                               |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function fExistSX2( _cAlias )
Local _lRet := .f.
Local _xArea:= {} 

	aAdd( _xArea, GetArea() )
	aAdd( _xArea, SX2->( GetArea() ) )
	
	dbSelectArea( 'SX2' )
	OrdSetFocus(1)
	If SX2->( dbSeek( _cAlias ) )
		_lRet:= .t.                    
	EndIf
	
	U_PushArea( _xArea )

Return( _lRet )


/*=========================================================================
|Funcao    | DtRefNFE          | Raimundo Santana      | Data | 21/03/10   |
============================================================================
|Descricao | Retorna data de entrada para notas fiscais de entrada que não |
|          | tem o recebimento efetuado (31/12/2048)					   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function DtNFESR()
Return CtoD("31/12/2048")

/*=========================================================================
|Funcao    | fTemCTra    |Autor | Raimundo Santana      | Data | 28/10/10  |
============================================================================
|Descricao | Verifica se existe o controle de Transportadoras.			   |
|          | Retorna .T. se a filial tem o controle ativo.                 |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fTemCTra()
Return GetNewPar( 'MV_HASCTRA', 'N' ) = 'S'	

/*=========================================================================
|Funcao    | CdTraPrv          | Raimundo Santana      | Data | 28/10/10   |
============================================================================
|Descricao | Retorna o codigo fornecidor é da transportadora provisória.   |
|          | 															   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function CdTraPrv()
	Local _cTransp
	
	_cTransp:=AllTrim(GetNewPar( 'MV_TRANPRV','00000A'))
	
	_cTransp := PadR(_cTransp,TamSX3("C5_TRANSP")[1])
	
Return _cTransp
                                                       
/*=========================================================================
|Funcao    | IsTraPrv          | Raimundo Santana      | Data | 28/10/10   |
============================================================================
|Descricao | Retorna .T. se o codigo fornecidor é da transportadora        |
|          | provisória.												   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function IsTraPrv(_cTransp)
Return ( _cTransp==U_CdTraPrv() )

/*=========================================================================
|Funcao    | CnvCdNIt          | Raimundo Santana      | Data | 10/08/10   |
============================================================================
|Descricao | Retorna o número do item referente ao código do item.         |
|          | Range utilizado 00-99 A0-ZZ								   |
============================================================================
|Observações:  	                                                           |
|                                                                          |
==========================================================================*/
User Function CnvCdNIt(_cItem,_nTam)
	Local _nRet
	Local _cCh
                              
	_cItem := Upper(AllTrim(_cItem))

	Default _nTam := Len(_cItem)
	
	If _cItem <= Replicate("9",_nTam)
		_nRet := Val(_cItem)	 
	Else         
		_nRet := 0

		Do While !Empty(_cItem)
			_nRet *= 36
			
			_cCh := Left(_cItem,1)
			_cItem := SubStr(_cItem,2)
			 
			If _cCh <= "9" 
				_nRet += Val(_cCh)
			Else
				_nRet += Asc(_cCh)-55
			EndIf                   
		EndDo

		_nRet=_nRet-(10*(36^(_nTam-1)))+(10^_nTam)
	Endif
	
Return _nRet

User Function GtIndBag(cAlias,cFilename,cRddName)
	Local _cOrdem
	Local _cOrdName
	Local _cIndexKey
	Local _aIndBags  := {}
	Local _xArea     := {}
	Local _lBagMInd
	
	Default cAlias    := Alias()
	Default cFilename := AllTrim(U_GetValCpo( "SX2",1,cAlias,{|| X2Nome() },""))
	
	_lBagMInd := U_BagMultInd(cRddName)

	If At(".",cFilename) > 0
		cFilename := Left(cFilename,At(".",cFilename)-1)
	EndIf
	
	cFilename := AllTrim(cFilename) 

	If _lBagMInd
		AAdd(_aIndBags,{ cFileName, {} })
	EndIf
	
	aAdd( _xArea, SX1->( GetArea() ) )                  

	SIX->( OrdSetFocus(1) ) //INDICE+ORDEM

    SIX->( DbSeek(cAlias) )

    Do While !SIX->(Eof()) .And. SIX->INDICE==cAlias
	    _cOrdem    := AllTrim(SIX->ORDEM)
	    _cIndexKey := AllTrim(SIX->CHAVE)
	    _cOrdName  := AllTrim(SIX->NICKNAME)
	    
		If _lBagMInd
			AAdd(_aIndBags[1][2],{ _cIndexKey,_cOrdName,.F. })
		Else
			AAdd(_aIndBags,{ Left(cFileName,7)+_cOrdem,{ { _cIndexKey,_cOrdName,.F. } } } )
		EndIf

	    SIX->( DbSkip() )		
    EndDo                         

	u_pushArea( _xArea ) 
Return _aIndBags

User Function CrIndBag(cAlias,cFilename,aIndBags,cRddName,lForceInd)
	Local aIndices
	Local cIndBagName
	Local cIndexName
	Local cIndexKey
	Local lIndexUniq
	Local cOrdName
	Local nBag                                        
	Local nInd               
	Local lExistInd
	
	Default cRddName  := "DBFCDX"
	Default lForceInd := .F.
	
	If At(".",cFilename) > 0
		cFilename := Left(cFilename,At(".",cFilename)-1)
	EndIf

	//Abre todos os indices fornecidos
    For nBag := 1 To Len(aIndBags)    
  	  cIndBagName := Upper(AllTrim(aIndBags[nBag][1]))
	
	  If cRddName == "TOPCONN"
	    cIndBagName := RetFileName(cIndBagName)		
	  ElseIf At(".",cIndBagName) == 0
	    cIndBagName += RetIndExt()
	  EndIf

	  If U_BagMultInd(cRddName)
		lExistInd := U_ExistFile(cFilename,cIndBagName,cRddName)

		If lForceInd .And. lExistInd
		  If cRddName == "TOPCONN"
			U_TopDelInd(cIndBagName)
		  Else
		  	FErase(cIndBagName)
		  Endif           
		  
		  lExistInd := .F.
		EndIf
      Else
      	lExistInd := .F. //Força a avaliação da existencia do índice dentro da rotina de criação
      EndIf
	  
	  If !lExistInd
	    For nInd:=1 To Len(aIndBags[nBag][2])                                  
	      If cRddName == "TOPCONN"		    		
		      cIndexName := RetFileName(cIndBagName)//+U_Int2Alpha(nInd,1)
		  Else
		      cIndexName := Left(FileNoExt(cIndBagName),7)+U_Int2Alpha(nInd,1)+RetIndExt()
		  Endif

		  If !U_BagMultInd(cRddName)
		    lExistInd := U_ExistFile(cFilename,cIndexName,cRddName)

		    If lForceInd .And. lExistInd
		      If cRddName == "TOPCONN"
		  	    U_TopDelInd(cFileName,cIndexName)
		      Else
		   	    FErase(cIndexName)
		      Endif           
		      lExistInd := .F.
		    EndIf
		  EndIf
		  
	      cIndexKey  := aIndBags[nBag][2][nInd][1]
	      cOrdName   := IIF(Len(aIndBags[nBag][2][nInd]) < 2 .Or. aIndBags[nBag][2][nInd][2] == NIL,RetFileName(cIndexName),aIndBags[nBag][2][nInd][2])
	      lIndexUniq := IIF(Len(aIndBags[nBag][2][nInd]) < 3 .Or. aIndBags[nBag][2][nInd][3] == NIL,.F.,aIndBags[nBag][2][nInd][3])

		  If lExistInd
	   		(cAlias)->( DbSetIndex(cIndBagName) )
		  Else
		    If U_BagMultInd(cRddName)
		      OrdCreate( cIndBagName, cOrdName, cIndexKey,&("{|| "+cIndexKey+"}"),IIF(lIndexUniq,.T.,NIL) )		    	
		    Else 
		      DbCreateIndex( cIndexName,cIndexKey,&("{|| "+cIndexKey+"}"),IIF(lIndexUniq,.T.,NIL) )		    	
		    EndIf 
		  EndIf
	    Next                        
  	  EndIf
	Next
Return

User Function DbOrdNic(_xOrder,_cKeyChk,_lShowErro,_lAbortar)
	Local _lRet   := .T.              
	Local _cKey	  := ""
	Local _cMens  := ""
	Local _cProb  := ""
	Local _cTexto := ""
	Local _nCt
	
	Default _cKeyChk   := ''
	Default _lShowErro := .T.
	Default _lAbortar  := .T.
	
	If ValType(_xOrder)=="C"
		_lRet := DBOrderNickname(_xOrder)
	Else 
		OrdSetFocus(_xOrder)
	EndIf
	
	If !_lRet
		_cProb := "Indice não encontrado"
		_cMens := 'Não foi possível selecionar o indice '+IIF(ValType(_xOrder)=="C",'"'+_xOrder+'"','número '+AllTrim(Str(_xOrder)))+' do arquivo '+Alias()
	EndIf
	
	If _lRet .And. !Empty(_cKeyChk)
		_cKeyChk := Upper(AllTrim(_cKeyChk))
		_cKeyChk := Replace(_cKeyChk,Upper(Alias())+'->','')        
		Do While ' ' $ _cKeyChk
			_cKeyChk := Replace(_cKeyChk,' ','')        
		EndDo
		_cKeyChk := Upper(_cKeyChk) 
		
		If !Empty(_cKeyChk)
			_cKey := AllTrim(Upper(IndexKey()))
			_cKey := Replace(_cKey,Upper(Alias())+'->','')
			Do While ' ' $ _cKey
				_cKey := Replace(_cKeyChk,' ','')        
			EndDo
			
			_lRet := ( Left(_cKey,Len(_cKeyChk))==_cKeyChk )
			If !_lRet
				_cProb := "Chave difere da esperada"
				_cMens := 'Chave do indice '+IIF(ValType(_xOrder)=="C",'"'+_xOrder+'"','número '+AllTrim(Str(_xOrder)))+' do arquivo '+Alias()+' difere da chave esperada'
			EndIf
    	EndIf
	Endif
	
	If !_lRet              
		_cTexto := '<html>'+Chr(13)+Chr(10)
		_cTexto += '<body>'+Chr(13)+Chr(10)
		_cTexto += '<b>Indice não selecionado em '+AllTrim(ProcName())+'</b><br>'
		_cTexto += '<br>'
		_cTexto += 'Empresa: '+cEmpAnt+'<br>'
		_cTexto += 'Arquivo: '+Alias()+'<br>'
		_cTexto += 'Indice: '+IIF(ValType(_xOrder)=="C",'"'+_xOrder+'"',AllTrim(Str(_xOrder)))+'<br>'
		_cTexto += 'Chave do Indice: '+_cKey+'<br>'
		_cTexto += 'Chave Esperada: '+_cKeyChk+'<br>'
		_cTexto += 'Problema: '+_cProb+'<br>'
		_cTexto += 'Usuário: '+cUserName+'<br>'
		_cTexto += 'E-Mail: '+UsrRetMail(__cUserId)+'<br>'		
		_cTexto += 'Data: '+DtoC(MsDate())+'<br>'
		_cTexto += 'Hora: '+Time()+'<br>'
		_cTexto += 'Rotina: '+FunName()+'<br>'
		_cTexto += 'Pilha de Chamadas:<br>'

		_nCt := 1		
		Do While !Empty(ProcName(_nCt))
			_cTexto += '<p style="margin-top:0;margin-right:0;margin-bottom:0;margin-left:16;margin-bottom:0;line-height:normal">'+AllTrim(ProcName(_nCt))+" ("+AllTrim(Str(ProcLine(_nCt)))+')</p>'
			_nCt++
		EndDo
		_cTexto += '</body>'+Chr(13)+Chr(10)
		_cTexto += '</html>'+Chr(13)+Chr(10)

		U_EnviaEmail(GetNewPar('MV_WFINDNS',AllTrim(UsrRetMail('000000'))), "Indice não selecionado "+IIF(ValType(_xOrder)=="C",'"'+_xOrder+'"','número '+AllTrim(Str(_xOrder)))+" no "+Alias()+" - "+DtoC(MsDate())+" "+Time(), _cTexto )

		If _lShowErro	
			Aviso( 'Aviso!', _cMens+'!'+Chr(13)+Chr(10)+'Por favor informe ao administrador do sistema.', {'OK'}, 2 )
		EndIf
		If _lAbortar
			Final("Erro ao selecionar indice "+IIF(ValType(_xOrder)=="C",'"'+_xOrder+'"','número '+AllTrim(Str(_xOrder)))+" no arquivo "+Alias()+".")
		EndIf
	EndIf

Return _lRet

/*==========================================================================
|Funcao    | GetACFOP           | Raimundo Santana      | Data | 30/03/11  |
============================================================================
|Descricao | Retorna o CFOP ajustado para a operação com o cliente/forn..  |
|			      														   |
============================================================================
|Parametros| _cCF 		= CFOP a converter								   |
|			 _cTipoCli  = Tipo do CLiente:								   |
|							F = Consumidor Final						   |
|							R = Revenda									   |
|			_cCliFor    = Indicador de Cliente ou Fornecedor			   |
|							C = Cliente									   |
|							F = Fornecedor								   |
|			_cCodClFor  = Código do Cliente ou Fornecedor			   	   |
|			_cLojClFor  = Loja do Cliente ou Fornecedor			   	   	   |
============================================================================
|Observações: Mantem CFOPs que não podem ser convertidos. Ex. 6107		   |
|			 															   |
==========================================================================*/
User Function GetACFOP(_cCF,_cFipoCli,_cCliFor,_cCodClFor,_cLojClFor)
	Local _cUFClFor

	If _cCliFor=="C"
		_cUFClFor := U_GetValCpo("SA1",1,FWXFilial("SA1")+_cCodClFor+_cLojClFor,"A1_EST")	
	Else
		_cUFClFor := U_GetValCpo("SA2",1,FWXFilial("SA2")+_cCodClFor+_cLojClFor,"A2_EST")	
	EndIf

Return U_AjtCFOP(_cCF,_cUFClFor,_cTipoCli)

/*==========================================================================
|Funcao    | SetUAcc            | Raimundo Santana      | Data | 11/05/11  |
============================================================================
|Descricao | Altera acesso do usuário pelo número do acesso                |
|			      														   |
============================================================================
|Parametros| _nAcc 		= Número do acesso								   |
|			 _lAcc      = .T. para definir o acesso como liberado          |
|						  .F. para negar o acesso                          |
|			_cAcesso    = String de acessos (Opcional)                     |
|                         Se passada será utilizada como base dos acessos  |
|						  e não será alterada a variável padrão de         |
|                         controle de acessos do sistema (cAcesso).        |
|						  Se não passada a variavel padrão de acessos do   |
|						  sistema (cAcesso) será utilizada e atualizada.   |
============================================================================
|Retorno: String de acessos alterada                                       |
|			 															   |
==========================================================================*/
User Function SetUAcc(_nAcc,_lAcc,_cAcesso)
	Local _lUsaAcc
	
	_lUsaAcc := (_cAcesso==NIL)
	
	If _lUsaAcc
		_cAcesso := cAcesso
	EndIf
	
	If _nAcc >= 1 .And. _nAcc <= Len(_cAcesso)
		_cAcesso := Left(_cAcesso,_nAcc-1)+IIF(_lAcc,"S","N")+SubStr(_cAcesso,_nAcc+1)
	Endif

	If _lUsaAcc
		cAcesso := _cAcesso
	EndIf

Return _cAcesso

/*==========================================================================
|Funcao    | GetUAcc            | Raimundo Santana      | Data | 11/05/11  |
============================================================================
|Descricao | Altera acesso do usuário pelo número do acesso                |
|			      														   |
============================================================================
|Parametros| _nAcc 		= Número do acesso								   |
|			_cAcesso    = String de acessos (Opcional)                     |
|                         Se passada será utilizada como base dos acessos. |
|						  Se não passada a variavel padrão de acessos do   |
|						  sistema (cAcesso) será utilizada.				   |
============================================================================
|Retorno: .T. para acesso liberado										   |
|		  .F. para acesso negado				                           |
|			 															   |
==========================================================================*/
User Function GetUAcc(_nAcc,_cAcesso)
	Local _lUsaAcc
	Local _lRet := .F.
	
	_lUsaAcc := (_cAcesso==NIL)
	
	If _lUsaAcc
		_cAcesso := cAcesso
	EndIf
	
	If _nAcc >= 1 .And. _nAcc <= Len(_cAcesso)
		_lRet := (SubStr(_cAcesso,_nAcc)=="S")	
	Endif

Return _lRet

/*==========================================================================
|Funcao    | TOpICMST           | Raimundo Santana      | Data | 06/02/12  |
============================================================================
|Descricao | Retorna se o tipo da operação deve ou não calcular o ICMS ST  |
|			      														   |
============================================================================
|Parametros| cTpOper 	= Tipo da Operação								   |
============================================================================
|Retorno: .T. Permite o calculo do ICMS ST                                 |
|		  .F. Não permite o calculo do ICMS ST                             |
|			 															   |
==========================================================================*/
User Function TOpICMST(cTpOper)
	Local _lRet := .F.
	                  
	cTpOper := AllTrim(cTpOper)
	
	If !Empty(cTpOper)
		cTpOper := "|"+cTpOper+"|"

		_lRet := (cTpOper $ "|"+AllTrim(GetNewPar('MV_TPOPVEN','10'))+"|" )	//Tipo de operação é venda

		If !_lRet
			_lRet := (cTpOper $ "|"+AllTrim(GetNewPar('MV_TOPICST',''))+"|" )	//Tipo de operação permite calculo do ICMS ST
		EndIf
	EndIf
Return _lRet                                                               

/*==========================================================================
|Funcao    | ViewText           | Raimundo Santana      | Data | 06/08/12  |
============================================================================
|Descricao | Abre tela para visualizar texto.							   |
|			      														   |
============================================================================
|Parametros| _cTexto = String com o texto para visualizar.				   |
============================================================================
|Retorno: .T. 															   |
|			 															   |
==========================================================================*/
User Function ViewText(_cTexto,_cTitulo)
	Local _oDlg  
	Local _oTexto
	Local _oFont
	
	DEFAULT _cTitulo := "Texto"

	DEFINE FONT _oFont NAME "Courier New" SIZE 5,0

	DEFINE MSDIALOG _oDlg TITLE _cTitulo From 3,0 to 340,417 PIXEL

	@ 5,5 GET _oTexto  VAR _cTexto MEMO SIZE 200,160 OF _oDlg PIXEL READONLY

	_oTexto:bRClicked := {||AllwaysTrue()}
	_oTexto:oFont:=_oFont

	ACTIVATE MSDIALOG _oDlg CENTER
Return                                                    

/*==========================================================================
|Funcao    | GtEndPad           | Raimundo Santana      | Data | 06/08/12  |
============================================================================
|Descricao | Retorna endereço padrao para o almoxarifado conforme          |
|		   | parametros.	      										   |
============================================================================
|Parametros| _cLocal = String com o almoxarifado para verificar o endereço |
|				   | 															   															 |
============================================================================
|Observações: Utiliza o parametro MV_ENDNF@@ onde @@ é o almoxarifado para |
|             definir o endereço padrão, caso esteja em branco ou não      |
|             exista, verifica o parametro MV_ENDAUNF e caso este esteja   |
|             com "S" lista os endereços cadastrados para o alamoxarifado  |
|             retornando o endereço encontrado caso somente exista um ou   |
|             retorna espaços em branco caso tenha mais de um cadastrado   |
|             indicando que não foi possível definir o endereço padrão.    |
|          																   | 
============================================================================
|Retorno: String com o Endereço ou somente espaços em branco caso não      |
|		  seja possível definir o endereço padrão.						   |
==========================================================================*/
User Function GtEndPad(_cLocal)     
	Local _xArea	 := {} 
	Local _nQtdEnd   := 0  
	Local _cLocaliz 
	Local _cKey

	_cLocaliz := AllTrim(GetNewPar('MV_ENDNF'+_cLocal,''))
	_cLocaliz := PadR(_cLocaliz,TamSX3("BE_LOCALIZ")[1])

	If Empty(_cLocaliz) .And. GetNewPar('MV_ENDAUNF', 'N' ) = 'S'
		aAdd( _xArea, SBE->( GetArea() ) )

		SBE->(OrdSetFocus(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
		
		_cKey := FWXFilial("SBE")+_cLocal
	
		SBE->(DbSeek(_cKey))
		Do While SBE->(!Eof()) .And.;
				 SBE->BE_FILIAL+SBE->BE_LOCAL == _cKey   
			 
			_cLocaliz := SBE->BE_LOCALIZ
			 
			_nQtdEnd++
		
			If _nQtdEnd > 1
				Exit
			Endif
		
			SBE->(DbSkip())
		EndDo            

		_cLocaliz := IIF(_nQtdEnd==1,_cLocaliz,Space(Len(_cLocaliz)))
	EndIf       

	u_pushArea( _xArea ) 
Return _cLocaliz

/*==========================================================================
|Funcao    | NormVal           | Raimundo Santana       | Data | 06/02/12  |
============================================================================
|Descricao | Retorna valor em string normalizado com pontos separadores    |
|		   | de milhares e decimal se necessário.						   |
|		   | Exemplos:													   |
|          |   72219 	retornará "72.219"								   |
|          |   72219,03 retornará "72.219,03"							   |
|          |   0,23		retornará "0,23"								   |
============================================================================
|Parametros| _nValor 	= Valor a normalizar							   |
|		   | _nMinTam   = Tamanho Mínimo a esquerda da virgula. Default	0  |
|		   |			  Ex. Tam. Min. = 10, 72219 ret. "       72.219"   |
|          | _nMinDec   = Número de casas decimais mínimas. Default 0	   |
|		   |			  Ex. Dec. Min. = 4, 72219,03 ret. "72.219,0300"   |
============================================================================
|Retorno: String com o valor normalizado								   |
|			 															   |
==========================================================================*/
User Function NormVal(_nValor,_nMinTam,_nMinDec)
	Local _nTam
	Local _nDec
	Local _nPos
	Local _cRet
	Local _cPicture     
	
	Default _nMinTam := 0
	Default _nMinDec := 0 
	
	_cRet := AllTrim(Str(_nValor))

	If Left(_cRet,1)=="."
		_cRet := "0"+_cRet
	Endif
	
	_nPos := At(".",_cRet)

	If _nPos > 0
		_nTam := _nPos-1
		_nDec := Len(_cRet)-_nPos
		_nTam := Max(_nTam,_nMinTam)
	Else
		_nTam := Len(_cRet)
		_nDec := 0
	EndIf          

	_nTam := Max(_nTam,_nMinTam)
	_nDec := Max(_nDec,_nMinDec)

	_cPicture := ""
		
	Do While _nTam > 0
		If _nTam > 3
			_cPicture := ",999"+_cPicture
			_nTam-=3
		Else
			_cPicture := Replicate("9",_nTam)+_cPicture
			_nTam := 0
		EndIf         
	EndDo       
	
	If _nDec > 0 
	  _cPicture += "."+Replicate("9",_nDec)
	EndIf
	
	_cPicture := "@E "+_cPicture

	_cRet := Transform(_nValor,_cPicture)
Return _cRet

/*=========================================================================
|Funcao    | fCdUAuto    |Autor | Raimundo Santana      | Data | 19/11/12  |
============================================================================
|Descricao | Retorna o código do usuário para rotinas automáticas		   |
|          |                                                               |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fCdUAuto()
	Local cCdUsu := GetNewPar( 'MV_CDUAUTO', '' )
	
	If Empty(cCdUsu)
		cCdUsu := "000000"
	EndIf

Return cCdUsu

/*=========================================================================
|Funcao    | fUsaComV    |Autor | Raimundo Santana      | Data | 25/03/15  |
============================================================================
|Descricao | Verifica se existe o comissionamento variável deve ser        |
|          | utilizado.                                                    |
|          | Retorna .T. se o comissionamento variável esta ativo.         |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fUsaComV()
Return GetNewPar( 'MV_USACOMV', 'N' ) = 'S'	  

/*=========================================================================
|Funcao    | fUsaEFOP    |Autor | Raimundo Santana      | Data | 01/07/15  |
============================================================================
|Descricao | Verifica se o endereço utilizado nos empenhos de componentes  |
|          | no apontamento de produção deverá ser forçado conforme        |
|          | definição da ordem de produção.                               |
|          | Retorna .T. se endereço conforme OP ou .F. se processo padrão.|
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fUsaEFOP()
Return GetNewPar( 'MV_USAEFOP', 'N' ) = 'S'

/*=========================================================================
|Funcao    | LsFlAbMC    |Autor | Raimundo Santana      | Data | 24/08/15  |
============================================================================
|Descricao | Retorna lista de filiais que compõe a consolidação na         |
|          | absorção de MOD/CIF caso a filial tenha consolidação, se não  |
|          | retorna somente a própria filial.                             |
============================================================================
|Parametros| _cFilial = String com a Filial (Default filial corrente)      |
============================================================================
|Retorno   | String com a lista das filiais a consolidar ou a própria      |
|          | se não consolida.                                             |
==========================================================================*/
User Function LsFlAbMC(_cFilial)
	Local _cFiliais := ","
	Local _aLista
	Local _aItemLst
	Local _cLstPar       
	Local _nTamFil
	Local _nCt     
	
	Default _cFilial := cFilAnt
	
	_nTamFil := FWSizeFilial()
	
	_cFiliais += _cFilial+','

	_cLstPar := AllTrim(GetNewPar('MV_LFABSMC','04=04,17,19;38=38,39'))
	
	If !Empty(_cLstPar)
		_aLista := U_ConvList(_cLstPar,";",{|cItem|AllTrim(cItem)},.T.)
		
		For _nCt:=1 To Len(_aLista)
			_cLstPar := _aLista[_nCt]
			_aItemLst	 := U_ConvList(_cLstPar,"=",{|cItem| AllTrim(cItem) },.T.)

			If Len(_aItemLst) >= 1
				_aItemLst[1] := PadR(_aItemLst[1],_nTamFil)
			EndIf
			
			If Len(_aItemLst) > 1
				_aItemLst[2] := ","+U_ConvList(_aItemLst[2],",",{|cItem| PadR(cItem,_nTamFil) },.F.)+","
			Else
				AAdd(_aItemLst,","+_aItemLst[1]+",")
			EndIf 
			
			_aLista[_nCt] := _aItemLst
		Next
		
		_nCt := AScan(_aLista,{|aItem| aItem[1]==_cFilial })
		
		If _nCt > 0
			//Retira a filial corrente da lista a retornar
			_cLstPar  := Replace(_aLista[_nCt][2],_cFiliais,",")

			//Adiciona filiais a lista                                  
			_cFiliais += SubStr(_cLstPar,2)
		EndIf
	EndIf

	_cFiliais := SubStr(_cFiliais,2,Len(_cFiliais)-2)
	
Return _cFiliais

/*==========================================================================
|Funcao    | fExecSQL           | Flávia Rocha          | Data | 11/08/2015|
============================================================================
|Descricao | Executa a query e retorna o resultado	     				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fExecSQL(xSql,xNom)
	Local lRet := .F.
	 
	Iif(Select(xNom) # 0,&(xNom)->(dbCloseArea()),.T.)
	TcQuery xSql New Alias &(xNom)
	&(xNom)->(dbSelectArea(xNom))
	&(xNom)->(dbGoTop())
	
	If &(xNom)->(EOF()) .AND. &(xNom)->(BOF())
		&(xNom)->(dbCloseArea())
	Else
		lRet := .T.
	EndIf

Return(lRet)

/*==========================================================================
|Funcao    | fMontTela          | Flávia Rocha          | Data | 11/08/2015|
============================================================================
|Descricao | Função para posicionar todo o objeto na Dialog				   |
|Parametros oBjet = Objeto a ser dimencionado                              |
|           cTipo = Tipo de posicionamento                                 |
|            		"UP"   = Posiciona na parte de cima da Dialog          |
|            		"DOWN" = Posiciona na parte de baixo da Dialog         |
|            		"TOT"  = Posiciona em toda Dialog                      |
|                                                                          |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
User Function fMontTela(oBjet,cTipo,xVerMDI)
	Local aPosicao := {}
	
	Do Case
		Case cTipo = "TOT"
			aPosicao    := {1,1,(oBjet:nClientHeight-6)/2,(oBjet:nClientWidth-4)/2}
			If Empty(xVerMDI)
				aPosicao[3] -= Iif(SetMdiChild(),14,0)
			EndIf
			
		Case cTipo = "UP"
			aPosicao:= {1,1,(oBjet:nClientHeight-6)/4-1,(oBjet:nClientWidth-4)/2}
			//Versão MDI
			If Empty(xVerMDI)
				If SetMdiChild()
					aPosicao[3] += 4
					aPosicao[4] += 3
				EndIf
			EndIf
			
		Case cTipo = "DOWN"
			aPosicao:= {(oBjet:nClientHeight-6)/4+1,1,(oBjet:nClientHeight-6)/4-2,(oBjet:nClientWidth-4)/2}
			//Versão MDI
			If Empty(xVerMDI)
				aPosicao[3] -= Iif(SetMdiChild(),14,0)		
			EndIf
	
	End Case

Return(aPosicao)

/*==========================================================================
|Funcao    | fBuscArr           | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Retorna array e quantidade de itens usados					   | 
|            do alias soliticados				  						   |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
User Function fBuscArr(xAlias,xArrFim,xQtde,xlNF,xCpos,xNivel)	
	Local aRet
	Local nRet
	Local lUsad
	
	aRet     := {}
	nRet     := 0
	lUsad    := .F.
	
	dbSelectArea(xAlias)
	If Empty(xCpos)
		SX3->(dbSetOrder(1))
		If SX3->(dbSeek(xAlias))
			While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = xAlias
				lUsad := Iif(!Empty(xNivel),Iif(SX3->X3_NIVEL==xNivel,.T.,.F.),Iif(!xlNF,X3USO(SX3->X3_USADO),Iif(SX3->X3_NIVEL==2,.T.,.F.)))
				aAdd(aRet,{Alltrim(SX3->X3_TITULO),SubStr(SX3->X3_CAMPO,xQtde,Len(SX3->X3_CAMPO)),;
							SX3->X3_TIPO,SX3->X3_DECIMAL,lUsad,X3Obrigat(SX3->X3_CAMPO)})
				nRet += Iif(lUsad,1,0)
				SX3->(dbSkip())
			EndDo
		EndIf
	EndIf

	If Len(xArrFim) > 0
		For yh := 1 To Len(xArrFim)
			aAdd(aRet,xArrFim[yh])
			nRet += Iif(xArrFim[yh,5],1,0)
		Next
	EndIf

Return({aRet,nRet})


/*==========================================================================
|Funcao    | FRScan             | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Retorna posição do campo no array selecionado				   | 
|                                   	  						   |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
User Function FRScan(aArr,cCamp,nPosi)
	Local nPos := 0
	
	nPos := Ascan(aArr,{|x| Alltrim(x[nPosi]) == Alltrim(cCamp) } )
	nPos := Iif(ValType(nPos) <> "N",0,nPos)
	
Return nPos
	
                   

/*==========================================================================
|Funcao    | FRX3               | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Pega conteudo do SX3                       				   | 
|Parametros| xCampo  = Campo que deseja pegar o conteudo                   |
|            xColuna = Coluna no SX3                                       |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
User Function FRX3(xCampo,xColuna)
	Local aArea    := GetArea()
	Local aAreaSX3 := SX3->(GetArea())
	Local cRet     := ""
	
	If Empty(xCampo) .OR. Empty(xColuna)
		Return(cRet) 
	EndIf
	
	SX3->(dbSetOrder(2))
	If SX3->(dbSeek(xCampo))
		If SX3->(FieldPos(xColuna)) > 0 
	       cRet := SX3->(FieldGet(FieldPos(xColuna)))	
		EndIf
	EndIf
	
	RestArea(aAreaSX3)
	RestArea(aArea)

Return(cRet)

User Function RLockReg(_cAlias,_nReg,_nWaitMSeg)
	Local _xArea := {}
	Local _lRet  := .F.  

	Default _nWaitMSeg  := 1000
	Default _cAlias		:= Alias()
	
	If !Empty(_cAlias)  
		If _nReg != NIL               
			AAdd(_xArea,(_cAlias)->( GetArea() ) )

			(_cAlias)->(DbGoTo(_nReg))
		EndIf                                   
		          
		Do While !(_lRet := (_cAlias)->( MSRLock() ))
			If (_nWaitMSeg-=100) < 0
				Exit						
			EndIf

			Sleep(100)    
		EndDo
	EndIf

	U_PushArea( _xArea )
Return _lRet	

User Function MLockChv(_cAlias,_xChave,_nOrdem,_bFiltro,_nWaitMSeg,_aLock)
	Local _aLock := {}
	Local _xArea := {}
	Local _lRet  := .T.  
	Local _nCt                     
	
	Default _bFiltro 	:= {|cAlias,nOrdem| .T. }
	Default _aLock      := {}
	
	AAdd(_xArea,(_cAlias)->( GetArea() ) )
	
	(_cAlias)->( OrdSetFocus(_nOrdem) )
	
	If ValType(_xChave)=="B"
		_xChave := Eval(_xChave,_cAlias,_nOrdem)
	EndIf
	
	For _nCt:=1 To Len(_xChave)
		(_cAlias)->(DbSeek(_xChave[_nCt]))
		
		Do While (_cAlias)->(!Eof()) .And. Left(&(_cAlias+"->("+(_cAlias)->(IndexKey())+")"),Len(_xChave[_nCt])) == _xChave[_nCt]
			If Eval(_bFiltro,_cAlias,_nOrdem)
				_lRet := U_RLockReg(_cAlias,,_nWaitMSeg)

				If !_lRet
					Exit
				EndIf                
			EndIf    
			
			AAdd(_aLock,(_cAlias)->(Recno()))
		
			(_cAlias)->( DbSkip() )
		End Do		
	Next
	
	If !_lRet
		AEval(_aLock,{|nRec| (_cAlias)->(DbGoTo(nRec)),(_cAlias)->(MsUnlock()) }) 
	EndIf

	U_PushArea( _xArea )
Return _lRet	

User Function MLockReg(_cAlias,_xRegs,_nWaitMSeg,_aLock)
	Local _aLock := {}
	Local _xArea := {}
	Local _lRet  := .F.  
	Local _nWait
	Local _nCt                     
	
	Default _aLock      := {}
	
	AAdd(_xArea,(_cAlias)->( GetArea() ) )
	
	(_cAlias)->( OrdSetFocus(_nOrdem) )
	
	If ValType(_xRegs)=="B"
		_xRegs := Eval(_xChave,_cAlias)
	EndIf
	
	For _nCt:=1 To Len(_xRegs)
		(_cAlias)->(DbGoTo(_xRegs[_nCt]))
		
		_lRet := U_RLockReg(_cAlias,,_nWaitMSeg)

		If !_lRet
			Exit
		EndIf                
		
		AAdd(_aLock,(_cAlias)->(Recno()))
	Next
	
	If !_lRet
		AEval(_aLock,{|nRec| (_cAlias)->(DbGoTo(nRec)),(_cAlias)->(MsUnlock()) }) 
	EndIf

	U_PushArea( _xArea )
Return _lRet	

/*=========================================================================
|Funcao    | fUsaSFIS    |Autor | Raimundo Santana      | Data | 02/05/17  |
============================================================================
|Descricao | Verifica se utiliza a integração com o SFIS				   |
|          | Retorna .T. se utiliza a integração.                          |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fUsaSFIS()
Return (GetNewPar('MV_USASFIS','N'))="S"  


/*==========================================================================
|Funcao    | fNivCPrd       |Autora    | Flávia Rocha   | Data | 23/05/17  |
============================================================================
|Descricao | Retorna a composição dos níveis para codificação da           |
|          | classificação de produto.                                     |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
==========================================================================*/
User Function fNivCPrd()
Return AllTrim(GetNewPar('MV_NIVCLASS','223344'))

/*==========================================================================
|Funcao    | GaNvCPrd       |Autor   | Raimundo Santana | Data | 14/06/17  |
============================================================================
|Descricao | Retorna um Array com o tamanho do código da classificação de  |
|          | produto por nível.			                                   |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:  Array de n Itens, sendo um item para cada nível existente 	   |
|          ordenados segundo a sequência dos níveis.				       |
|			[1] = Total de caracter no nível 1							   |
|			[2] = Total de caracter no nível 2							   |
|			[3] = Total de caracter no nível 3							   |
|			[n] = Total de caracter no nível n							   |
|                                                                          |
==========================================================================*/
User Function GaNvCPrd()
	Local _cNiv := U_fNivCPrd()
	Local _aRet := {}
	Local _nTot := 0

	Do While _cNiv!=""
		_nTot += Val(Left(_cNiv,1))
		_cNiv := SubStr(_cNiv,2)
		
		AAdd(_aRet,_nTot)
	EndDo

Return _aRet

/*==========================================================================
|Funcao    | GuNvCPrd       |Autor   | Raimundo Santana | Data | 14/06/17  |
============================================================================
|Descricao | Retorna o número do último nível da classificação de produto  |
|          | (Nível analítico).											   |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:  Número do último nível da classificação (Nível Analítico)       |
|                                                                          |
==========================================================================*/
User Function GuNvCPrd()
	Local _aNivel := U_GaNvCPrd()
Return Len(_aNivel)

/*==========================================================================
|Funcao    | GnNvCPrd       |Autor   | Raimundo Santana | Data | 14/06/17  |
============================================================================
|Descricao | Retorna o número do nível da classificação de produto para    |
|          | o código da classificação ou -1 se não houver coincidência.   |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:  Número do nível ou -1 se o nível não coincidir				   |
|                                                                          |
==========================================================================*/
User Function GnNvCPrd(_cCodigo)
	Local _aNivel := U_GaNvCPrd()
	Local _aIndex := 0
	Local _nTam
	
 	_cCodigo:=RTrim(_cCodigo) 
 	
 	If (!Empty(_cCodigo)) .And. U_SoNumeros(_cCodigo)
	 	_nTam := Len(_cCodigo)
	
	 	If _nTam > 0
		 	_aIndex := AScan(_aNivel,{|nItem| nItem==_nTam })
		 	
		 	If _aIndex==0
		 		_aIndex := -1
		 	EndIf
	 	EndIf	
	EndIf
	
Return _aIndex

/*==========================================================================
|Funcao    | GtNvCPrd       |Autor   | Raimundo Santana | Data | 14/06/17  |
============================================================================
|Descricao | Retorna o total de caracters (tamanho do código) para o nível |
|          | da classificação de produto fornecido.                        |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:  Número de caracteres ou 0 se nível inválido.					   |
|                                                                          |
==========================================================================*/
User Function GtNvCPrd(_nNivel)
	Local _aNivel := U_GaNvCPrd()
	Local _nRet	  := 0
	                  
	If (_nNivel>0 .And. _nNivel<=Len(_aNivel))
	 	_nRet := _aNivel[_nNivel]
 	EndIf	

Return _nRet

/*==========================================================================
|Funcao    | GtUsrDir       |Autor   | Raimundo Santana | Data | 29/11/17  |
============================================================================
|Descricao | Retorna o diretório de usuário utilizado no sistema.          |
|          | Este diretório contém todos os menus dos grupos de usuários.  |
|          |                                                               |
============================================================================
|Observações: No futuro poderá ser alterado ou definido por parâmetro.     |
|                                                                          |
============================================================================ 
|Retorno:  String com o diretório em uso.                                  |
|                                                                          |
==========================================================================*/
User Function GtUsrDir()
	Local _cDir := "\USR\"	//Definido diretamente no momento
	
	_cDir := AllTrim(_cDir)
	
	If !Empty(_cDir)
		If Right(_cDir,1)!="\"
			_cDir += "\"
		EndIf
	EndIf
	
Return _cDir

/*==========================================================================
|Funcao    | GtDefDir       |Autor   | Raimundo Santana | Data | 03/12/17  |
============================================================================
|Descricao | Retorna o diretório de configuração default utilizado no      |
|          | Sistema.                                                      |
|          | Este diretório contém todos arquivos de configurações         |
|          | adicionais.                                                   |
|          |                                                               |
============================================================================
|Observações: No futuro poderá ser alterado ou definido por parâmetro.     |
|                                                                          |
============================================================================ 
|Retorno:  String com o diretório em uso.                                  |
|                                                                          |
==========================================================================*/
User Function GtDefDir()
	Local _cDir := "\DEFS\"	//Definido diretamente no momento
	
	_cDir := AllTrim(_cDir)
	
	If !Empty(_cDir)
		If Right(_cDir,1)!="\"
			_cDir += "\"
		EndIf
	EndIf
	
Return _cDir
