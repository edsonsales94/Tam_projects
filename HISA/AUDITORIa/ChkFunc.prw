// #include "fivewin.ch"
#include "PROTHEUS.ch"

/*==========================================================================
|Funcao    | ChkFunc     |Autor | Claudio Cavalcante    | Data | 25/08/03  |
============================================================================
|Descricao | Verifica se uma determinada funcao podera ser utilizado por   |
|          | um determinado usuário                                        |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:                                                                  |
|	                                                                       |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function ChkFunc( _cFunction, _cNivel, _cGrupo, _cUserId, _cDesc,;
					   _lMess, _lAdm, bUnlock )
	Local _xArea	:= {}
	Local _lRet 	:= .F. 
	Local _cAdmChkf    
	Local _cMens
	Local bAviso 	:= {|cMens,aOptions| Eval(bUnlock),IIF(_lMess,Aviso('Aviso!',cMens,IIF(aOptions==NIL,{'Ok'},aOptions)),0) }

	Default _cFunction := Upper( ProcName(1) )
	Default _cNivel    := cNivel
	Default _cGrupo    := __GrpUser
	Default _cUserId   := __cUserId
	Default _cDesc	   := 'a função'
	Default _lMess     := .T.
	Default _lAdm      := .T.
	Default bUnlock    := {|| .T. }

	_cFunction := Upper(AllTrim(_cFunction))
	
	_cAdmChkf := U_GetAdmCk()

	Do Case
		Case _cAdmChkf=='S'
			_lAdm := .T.
		Case _cAdmChkf=='N'
			_lAdm := .F.
	EndCase

	If _cUserId = '000000' .And. _lAdm
		Return( .T. )
	EndIf         
	
	If Empty( _cGrupo )
		_cGrupo := u_fGrupo( _cUserId )
	EndIf
		
	If !("UB2"$cFOPENed)
		If !ChkFile("UB2", .F. )
			_cMens := 'Favor contactar o administrador de sistema, tabela de acessos não disponível!'
			Eval(bAviso,_cMens)
			Return( .F. )
		EndIf
	EndIf
	
	_cFunction := RTrim( Upper( _cFunction ) )
	
	AAdd(_xArea, UB2->( GetArea() ) )

	UB2->( OrdSetFocus(1) )  //UB2_FILIAL+UB2_FUNCAO+UB2_USERID

	// Procurar pelo grupo generico
	If UB2->( DbSeek( xFilial('UB2') + PadR(_cFunction,Len(UB2->UB2_FUNCAO))  ) )
		Do While UB2->( !Eof() ) .And. _cFunction == RTrim(UB2->UB2_FUNCAO) .And. xFilial('UB2') = UB2->UB2_FILIAL

			If ( _cUserId = UB2->UB2_USERID ) .Or. ( UB2->UB2_USERID = '******' .And. UB2->UB2_GRUPO $ _cGrupo )
				If ( UB2->UB2_CONSDT = '1' .And. Date() <= UB2->UB2_DTVLD ) .Or. UB2->UB2_CONSDT = '0'
					_lRet := .T.
					Exit
				EndIf
			EndIf

			UB2->( DbSkip() )
		EndDo
	EndIf

	If !_lRet
		_cMens := 'Caro usuário: ' + rtrim(cUserName) + ' você não possui acesso para executar ' + _cDesc +': ' + _cFunction+'!'
		Eval(bAviso,_cMens)
	EndIf

	U_PushArea( _xArea )
	
Return( _lRet )

/*==========================================================================
|Funcao    | LAccFunc    |Autor | Raimundo Santana      | Data | 18/05/11  |
============================================================================
|Descricao | Lista os acessos por função de um determinado usuário         |
============================================================================
|Observações:                                                              |
|                                                                          |
============================================================================ 
|Retorno: Array com os acessos ativos                                      |
|	                                                                       |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function LAccFunc( _cUserId, _cGrupo, _cFunction )
	Local _xArea	:= {}
	Local _aRet 	:= {}                    

	Default _cUserId   := __cUserId
	Default _cGrupo    := __GrpUser
	Default _cFunction := ""

	If !("UB2"$cFOPENed)
		If !ChkFile("UB2", .F. )
			Return _aRet
		EndIf
	EndIf

	If Empty( _cGrupo )
		_cGrupo := u_fGrupo( _cUserId )
	EndIf
		
	_cFunction := RTrim( Upper( _cFunction ) )
	
	AAdd(_xArea, UB2->( GetArea() ) )

	UB2->( OrdSetFocus(4) )	//UB2_FILIAL+UB2_USERID+UB2_FUNCAO
	
	// Procurar acessos pelo usuário
	UB2->( DbSeek( xFilial('UB2')+_cUserId+_cFunction  ) )
	Do While UB2->( !Eof() ) .And.;
		     xFilial('UB2')==UB2->UB2_FILIAL .And.;
		     UB2->UB2_USERID==_cUserId .And.;
		     ( _cFunction=="" .Or. Left(UB2->UB2_FUNCAO,Len(_cFunction))==_cFunction )

		If (( UB2->UB2_CONSDT = '1' .And. Date() <= UB2->UB2_DTVLD ) .Or. UB2->UB2_CONSDT = '0')
			If aScan(_aRet,{|cItem| cItem==RTrim(UB2->UB2_FUNCAO) })==0
				AAdd(_aRet,RTrim(UB2->UB2_FUNCAO))
			EndIf
		EndIf

		UB2->( DbSkip() )
	EndDo
		
	UB2->( OrdSetFocus(3) )	//UB2_FILIAL+UB2_GRUPO+UB2_FUNCAO

	// Procurar acessos pelo grupo
	UB2->( DbSeek( xFilial('UB2')+_cGrupo+_cFunction  ) )
	Do While UB2->( !Eof() ) .And.;
		     xFilial('UB2')==UB2->UB2_FILIAL .And.;
		     UB2->UB2_GRUPO==_cGrupo .And.;
		     ( _cFunction=="" .Or. Left(UB2->UB2_FUNCAO,Len(_cFunction))==_cFunction )

		If UB2->UB2_USERID = '******' .And.;
		   (( UB2->UB2_CONSDT = '1' .And. Date() <= UB2->UB2_DTVLD ) .Or. UB2->UB2_CONSDT = '0')

			If aScan(_aRet,{|cItem| cItem==RTrim(UB2->UB2_FUNCAO) })==0
				AAdd(_aRet,RTrim(UB2->UB2_FUNCAO))
			EndIf
		EndIf

		UB2->( DbSkip() )
	EndDo

	U_PushArea( _xArea )
Return _aRet

/*==========================================================================
|Funcao    | MataUb2           | Claudio Cavalcante    | Data | 25/08/03   |
============================================================================
|Descricao | Controle de Acesso a funcoes do sistema                       |
==========================================================================*/
User Function MATAUB2()
Private cCadastro, aRotina, cDelFunc

	cCadastro := "Controle de Acessos a Funções do Sistema"

	//|=====================================================================|
	//| Monta um aRotina proprio                                            |
	//|=====================================================================|

	aRotina   := { { "Pesquisar"    ,'AxPesqui'  , 0, 1},;
				   { "Visualizar"   ,'AxVisual'  , 0, 2},;
	               { "Incluir"      ,'AxInclui'  , 0, 3},;
	               { "Alterar"      ,'AxAltera'  , 0, 4},;
	               { "Excluir"      ,'AxDeleta'  , 0, 5},;
	               { "Cópia"        ,'U_CopiaUB2()', 0, 7}}
	
	If !ChkFile( 'UB2', .f. )
		RETURN
	EndIf
	dbSelectArea("UB2")
	mBrowse( 6,1,22,75,"UB2")
	
Return 

/*==========================================================================
|Funcao    | CopiaUB2    |Autora | Flávia Rocha         | Data | 19/09/16  |
============================================================================
|Descricao | Copia os acessos de um usuário para outro                     |
|          |                                                               |
============================================================================
|Observações: chamado #12564                                               |
============================================================================ 
|Retorno:                                                                  |
==========================================================================*/
User Function CopiaUB2(cAlias,nRec,nOpc) 
	Local _nOpca	:= 0
	Local _aSays    := {}
	Local _aButtons := {}
	Local _xArea	:= {}   
	Local _cPerg    := "COPYUB2"
	Local _cUserOri := ""
	Local _cUserDest:= ""
	Local _lSucesso := .F.
	
	Private cCadastro:= "Cópia de Access Function"
	
	If !u_ChkFunc(Replace(ProcName(),"U_",""),,,,'a '+cCadastro)
		Return
	EndIf
	
	AAdd(_xArea, UB2->( GetArea() ) )
	
	//Configura e Inicializa a rotina	
	ConfPergs(_cPerg)
		
	pergunte(_cPerg,.T.)
	_cUserOri := MV_PAR01
	_cUserDest:= MV_PAR02
	
	aAdd(_aSays," Este programa tem como objetivo copiar os acessos de um usuário do sistema " )
	aAdd(_aSays," para outro usuário a ser definido pelo operador, mediante o preenchimento" )
	aAdd(_aSays," parâmetros.")
	aAdd(_aButtons, { 5,.T.,{|| Pergunte(_cPerg,.T.) } } )
	aAdd(_aButtons, { 1,.T.,{|o| _nOpca:=1, o:oWnd:End() } } )
	aAdd(_aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	_nOpca := 0
		
	FormBatch( cCadastro, _aSays, _aButtons )
	             
	Do Case
		Case _nOpcA == 1			
			MsAguarde( {|| _lSucesso := fCopiaUB2(_cUserOri,_cUserDest)} , "Copiando Acessos...") 		
	EndCase

	If _lSucesso
		MsgInfo("Acessos Copiados com Sucesso !!!")
	Endif
	U_PushArea( _xArea )
	
Return

/*==========================================================================
|Funcao     | ConfPergs         | Flávia Rocha          | Data | 19/09/16  |
============================================================================
|Descricao  | Configura automaticamente as perguntas utilizadas	           |
|           |                                                              |
============================================================================
|Observações|  	                                                           |
==========================================================================*/
Static Function	ConfPergs(cPerg)
Local aPerg    := {}

aAdd(aPerg,{"Usuário Origem ?"       ,"mv_ch1","C",06,0,0,"G",""                  ,"MV_PAR01",""   ,""   ,"","","","US1",Space(06)           ,""})
aAdd(aPerg,{"Usuário Destino?"       ,"mv_ch2","C",06,0,0,"G",""                  ,"MV_PAR02",""   ,""   ,"","","","US1",Space(06)           ,""})


//Ajusta o dicionario SX1 corrigindo ou inserido as perguntas necessárias
U_ConfigSx1(cPerg,aPerg)

Return .T.  

/*==========================================================================
|Funcao     | fCopiaUB2         | Flávia Rocha          | Data | 27/09/16  |
============================================================================
|Descricao  | Copia os acessos de um usuário para outro baseado nos        |
|           | parâmetros informados                                        |
============================================================================
|Observações|  	                                                           |
==========================================================================*/
Static Function fCopiaUB2(_cUserOri,_cUserDest)                 
	Local nInd     := 0
	Local nPos     := 0
	Local cCpodest := ""
	Local cNomeUser:= ""
	Local cFuncao  := ""
	Local aDados   := {} 
	Local aCampos  := {}
	Local aUser    := {}
	Local lGravou  := .F.
	
	DbSelectArea("UB2") 
	Dbgotop()		
	UB2->( OrdSetFocus(4) )	//UB2_FILIAL+UB2_USERID+UB2_FUNCAO
	
	// Procurar acessos pelo usuário
	If UB2->( DbSeek( xFilial('UB2')+ _cUserOri  ) )
		Do While UB2->( !Eof() ) .And.  xFilial('UB2') == UB2->UB2_FILIAL .And.  UB2->UB2_USERID == _cUserOri			
			Aadd( aDados , { UB2->UB2_FILIAL,;
							UB2->UB2_USERID,;
							UB2->UB2_NOME,;
							UB2->UB2_GRUPO,;
							UB2->UB2_FUNCAO,;
							UB2->UB2_DTVLD,;
							UB2->UB2_CONSDT} )		
			UB2->(Dbskip())
		Enddo
		
		PswOrder(1)
		PswSeek( _cUserDest, .T. )
		aUser     := PSWRET() 					// Retorna vetor com informações do usuário		   
		cNomeUser := Alltrim(aUser[1][4])	    //Nome Completo do usuário		
	
		If Len(aDados) > 0
			UB2->( OrdSetFocus(4) )	//UB2_FILIAL+UB2_USERID+UB2_FUNCAO			
			For fr := 1 to Len(aDados) 			
				cFuncao := Alltrim(aDados[fr,5])
				UB2->( OrdSetFocus(4) )	//UB2_FILIAL+UB2_USERID+UB2_FUNCAO
				If !UB2->( DbSeek( xFilial('UB2')+ _cUserDest + Alltrim(cFuncao)  ) ) 
					RecLock("UB2", .T.)
					
					UB2->UB2_FILIAL := aDados[fr,1]
					UB2->UB2_USERID := _cUserDest
					UB2->UB2_NOME   := cNomeUser
					UB2->UB2_GRUPO  := aDados[fr,4]
					UB2->UB2_FUNCAO := aDados[fr,5]
					UB2->UB2_DTVLD  := dDatabase
					UB2->UB2_CONSDT := aDados[fr,7]
					
					UB2->(MsUnlock())
					lGravou := .T.	
				Endif
			Next
		Endif		 
	Endif

Return(lGravou)


/*==========================================================================
|Funcao    | RetCampo    |Autor | Claudio Cavalcante    | Data | 04/09/03  |
============================================================================
|Descricao | Retorna titulo do campo a partir de readvar()                 |
|          |                                                               |
============================================================================
|Observações:                                                              |
|                                                                          | 
|                                                                          |
============================================================================ 
|Retorno:                                                                  |
|	                                                                       |
|                                                                          |
|                                                                          |
==========================================================================*/
User Function RetCampo()
Return( RetTitle( SubStr( ReadVar(), 4) ) )

/*==========================================================================
|Funcao    | RetGrupo    |Autor | Claudio Cavalcante    | Data | 22/10/03  |
============================================================================
|Descricao | Retorna a lista dos grupos de um determinado usuario          |
|          |                                                               |
==========================================================================*/
User Function RetGrupo( _cUserCod )
Local _aGrupos:= {}

	Default _cUserCod := __cUserid
	If __cUserId = '000000'
		Return( _aGrupos ) 
	EndIf
	
	PswOrder(1)
	PswSeek( _cUserCod )
	_aGrupos := PswRet(1)[1][10]
	
Return( _aGrupos )


/*==========================================================================
|Funcao    | RetGrupo    |Autor | Claudio Cavalcante    | Data | 22/10/03  |
============================================================================
|Descricao | Retorna a lista dos grupos de um determinado usuario          |
|          |                                                               |
==========================================================================*/
User Function fGrupo( _cUserCod )
Local _aGrupos, _nCt, _cGrupos:= ''

	_aGrupos := u_RetGrupo( _cUserCod )
	
	For _nCt := 1 to Len( _aGrupos )
		_cGrupos +=  _aGrupos[_nCt] + '/'
	Next

Return( _cGrupos )


/*==========================================================================
|Funcao    | f650Check   |Autor | Claudio Cavalcante    | Data | 31/10/05  |
============================================================================
|Descricao | Verifica se um determinado usuario pode baixar uma ordem de   |
|          | producao                                                      |
==========================================================================*/
User Function f650Check()
Local _lRet := .f., _xArea:= {}

	aAdd( _xArea, SF5->( GetArea() ) )
	aAdd( _xArea, GetArea() )

	dbSelectArea('SF5')
	OrdSetFocus(1)
	If dbSeek( xFilial( 'SF5' ) + &(ReadVar()) ) 
		If SF5->F5_TIPO = 'P'
			_lRet := u_ChkFunc('BXPRODUCAO',,,,'a baixar ordem de producao', nil, .f. )
		EndIf
    EndIf

	u_PushArea( _xArea )

Return( _lRet )

User Function GetAdmCk(_cVal)
	Local _cRet
	Static __cAdmChkF := ""

	If Empty(__cAdmChkF)
		_cRet := Upper(AllTrim(GetNewPar('MV_ADMCHKF','S')))
	Else
		_cRet := __cAdmChkF
	EndIf                   
	
	If !Empty(_cVal)
		__cAdmChkF := _cVal
	EndIf
Return _cRet

User Function ChgAdmCk(_cVal)
	If _cVal==NIL
		_cVal := U_GetAdmCk()

		_cVal := IIF(_cVal=="S","N","S")
	EndIf

	If _cVal != U_GetAdmCk()
		U_MsgWait("Acesso a funçoes (ChkFunc) do Administrador",1,IIF(_cVal=="S","Acesso Liberado","Acesso Negado"))
	EndIf
	
	U_GetAdmCk(_cVal)
Return
