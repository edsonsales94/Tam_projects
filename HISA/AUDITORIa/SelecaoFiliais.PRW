// #include "FIVEWIN.CH"
#include "PROTHEUS.CH"
#include "dbtree.ch"
#define BMPOK1 "FOLDER5"
#define BMPOK2 "FOLDER6"
#define BMPNOK "FOLDER7"

Static _cFiliais := ""

/*/
|==========|==========|=======|=======================|======|==============|
|Funcao    | fSelFil  | Autor | Claudio Cavalcant     | Data | 05/07/2002   |
|==========|==========|=======|=======================|======|==============|
|Descricao | Selecao de filiais                                             |
|==========|================================================================|
|Sintax    | fSelFil()                                                      |
|==========|================================================================|
|Parametros| Sem Argumentos                                                 |
|==========|================================================================|
| Uso      | Uso generico     | Funcao Relacionada | Entrada Dados (Todos)  |
|==========|================================================================|
/*/
DEFAULT	_lFiltra := .f.
DEFAULT _aSelect := {}

User Function fSelFil( _lFiltra, _aSelect )
Local i
Local _oDlg
Local _oAll
Local _oListFil
Local _lAll := .F.
Local _aListFil := {}, _aListLast:= {}
Local oOk := LoadBitmap(GetResources(), "LBOK")
Local oNo := LoadBitmap(GetResources(), "LBNO")
Local aModDefault := {}
Local bLine := {|| {If(_aListFil[_oListFil:nAt,1],oOk,oNo), _aListFil[_oListFil:nAt,2], _aListFil[_oListFil:nAt,3], _aListFil[_oListFil:nAt,4], _aListFil[_oListFil:nAt,5]}}


_aListFil := u_ReadFil( _lFiltra, _aSelect )  // Processa leituras das filiais
_aListLast:= aClone( _aListFil )

DEFINE MSDIALOG _oDlg TITLE 'Selecione as Filiais' FROM 0,0 TO 245,410 OF oMainWnd PIXEL //"Selecione as Filiais"

@05,05 LISTBOX _oListFil FIELDS HEADER "",'Cod.','Nome', 'Cidade', 'UF' FIELDSIZES 14, 14, 55, 45, 14 SIZE 160, 102 PIXEL OF _oDlg 

_oListFil:SetArray(_aListFil)
_oListFil:bLine := bLine
_oListFil:bLDblClick := {|nRowPix, nColPix, nKeyFlags| ValSelection(@_aListFil,_oListFil),_oListFil:Refresh(),;
If(_lAll,(_lAll := .F., _oAll:Refresh()),)}

@ 110,06 CHECKBOX _oAll VAR _lAll PROMPT "&Todas as Filiais" FONT _oDlg:oFont PIXEL SIZE 80, 09 OF _oDlg ; 
ON CLICK (Aeval(_aListFil,{|x,y| _aListFil[y][1] := _lAll } ), _oListFil:Refresh())

DEFINE SBUTTON FROM 05,170 TYPE 1 ENABLE OF _oDlg;
ACTION ( _oDlg:End() )

DEFINE SBUTTON FROM 20,170 TYPE 2 ENABLE OF _oDlg ACTION ( _aListFil:= aClone( _aListLast ), _oDlg:End() )

DEFINE SBUTTON FROM 35,170 TYPE 15 ENABLE OF _oDlg ACTION FindFilial(@_oListFil,_aListFil) ONSTOP "Localizar"

ACTIVATE DIALOG _oDlg CENTERED

Return( _aListFil )

/*/
|==========|==========|=======|=======================|======|==============|
|Funcao    | ReadFil  | Autor | Claudio Cavalcant     | Data | 05/07/2002   |
|==========|==========|=======|=======================|======|==============|
|Descricao | Selecao de filiais                                             |
|==========|================================================================|
|Sintax    | fSelFil()                                                      |
|==========|================================================================|
|Parametros| Sem Argumentos                                                 |
|==========|================================================================|
| Uso      | Uso generico     | Funcao Relacionada | Entrada Dados (Todos)  |
|==========|================================================================|
/*/
User Function ReadFil( _lFiltra, _aSelect )
Local i,j, _nx, _ny, _nz
Local _aList:= {}, _xArea:= GetArea(), _xAreaSM0:= SM0->( GetArea() )
Local _aUser:= {}, _nCt, _aEmpresas := {}, _aEmp:= {}
Local _idUser := __cUserId //RetCodUsr(cUserName)
                                                                      
	If _idUser <> '000000' // administrador
		If _lFiltra <> nil 
			If _lFiltra
				pswOrder(1)
				If pswSeek( _idUser, .t. )
//					 _aUser := pswRet(2)
//					 If _aUser[1,11]
					 	_aUser := pswRet(1)
					 	For _nCt:= 1 to Len( _aUser[1,10] ) // vetor com os grupos - seleção pelo grupo
					 		If pswSeek( _aUser[1][10][_nCt], .f. ) // procura o ID do grupo
					 			_aEmp := FWGrpEmp(_aUser[1][10][_nCt]) //Carrega as filiais de acesso do grupo
//								_aEmp := pswRet(nil)[1][11]
								For _nx:= 1 to Len( _aEmp )
									_ny:= aScan( _aEmpresas, { |a| a = _aEmp[_nx] } ) // verifica se já existe esta empresa na lista
									If _ny = 0
										aAdd( _aEmpresas, _aEmp[_nx] ) // adiciona empresas
									EndIf
								Next
					 		EndIf
					 	Next
//					 Else
						_aUser := pswRet(2)
					 	For _nCt:= 1 to Len( _aUser[1,6] ) // Vetor com as empresas - seleção pelo usuário.
							_ny:= aScan( _aEmpresas, { |a| a = _aUser[1,6,_nCt] } ) // verifica se já existe esta empresa na lista
							If _ny = 0
								aAdd( _aEmpresas, _aUser[1,6,_nCt] ) // adiciona empresas
							EndIf					 		
					 	Next
//					 EndIf
				EndIf
			
			EndIf
		Else
			_lFiltra := .f.
		EndIf
	Else
		_lFiltra := .f.
	EndIf
	       
	// Verifica se o usuário tem direito a utilizar qualquer empresa que venha a ser cadastrada.
	For _nCt:= 1 to Len( _aEmpresas )
		If _aEmpresas[_nCt] = '@@@@'
			_lFiltra := .f.
			Exit
		EndIf
	Next
                
	dbSelectArea('SM0')
	dbSeek( cEmpAnt )
	While !Eof() .and. SM0->M0_CODIGO = cEmpAnt 
		_nz := aScan( _aSelect, { |a| a = SM0->M0_CODIGO + FWCodFil() } )
		If _lFiltra 
			_ny := aScan( _aEmpresas, { |a| a = SM0->M0_CODIGO + FWCodFil() } )
			If _ny > 0
				aAdd( _aList, { IIf( _nz > 0, .T., .f. ), FWCodFil(), Capital( SM0->M0_NOME ), Capital( SM0->M0_CIDENT ), Capital( SM0->M0_ESTENT ) } )
			EndIf
		Else
			aAdd( _aList, { IIf( _nz > 0, .T., .f. ), FWCodFil(), Capital( SM0->M0_NOME ), Capital( SM0->M0_CIDENT ), Capital( SM0->M0_ESTENT ) } )
		EndIf
		dbSkip()
	End
	
	RestArea( _xAreaSM0 )
	RestArea( _xArea )

	If Len( _aList ) = 0
		aAdd( _aList, { .T., FWCodFil(), Capital( SM0->M0_NOME ), Capital( SM0->M0_CIDENT ), Capital( SM0->M0_ESTENT ) } )	
	EndIf
	
Return _aList

User Function FilsUsrF(_cFilMin, _cFilMax )
	Local _aFiliais := {}
	Local _nCt
	
	Default _cFilMin := Space(FWSizeFilial())
	Default _cFilMax := Replicate('z',FWSizeFilial())
	
	If _cFilMin==_cFilMax .And. _cFilMin==cFilAnt
		aAdd( _aFiliais, { .T., FWCodFil(), Capital( SM0->M0_NOME ), Capital( SM0->M0_CIDENT ), Capital( SM0->M0_ESTENT ) } )	
	Else
		_aFiliais := U_ReadFil( .T., {} )
	EndIf

	_nCt:=1
		
	While _nCt <= Len(_aFiliais)
	  If _aFiliais[_nCt][2] < _cFilMin .Or. _aFiliais[_nCt][2] > _cFilMax
	  	ADel(_aFiliais,_nCt)
	  	ASize(_aFiliais,Len(_aFiliais)-1)
	  Else
	  	_nCt++
	  EndIf
	EndDo       
	
Return _aFiliais

/*/
|==========|===============|=======|==================|======|==============|
|Funcao    | ValSelection  |Autor  | Tecnologia       | Data |              |
|==========|===============|=======|==================|======|==============|
|Descricao | Validacao da selecao                                           |
|==========|================================================================|
|Sintax    | ValSelection                                                   |
|==========|================================================================|
|Parametros| Sem Argumentos                                                 |
|==========|================================================================|
| Uso      | Uso generico     | Funcao Relacionada | Entrada Dados (Todos)  |
|==========|================================================================|
/*/
Static Function ValSelection(_aListFil,_oListFil)
Local _nAt := _oListFil:nAt
	
	_aListFil[_nAt,1] := !_aListFil[_nAt,1]
			
Return
   

/*/
|==========|===============|=======|==================|======|==============|
|Funcao    | FindFilial    |Autor  | Tecnologia       | Data |              |
|==========|===============|=======|==================|======|==============|
|Descricao | Localiza filial                                                |
|==========|================================================================|
|Sintax    | FindFilial                                                     |
|==========|================================================================|
|Parametros| Sem Argumentos                                                 |
|==========|================================================================|
| Uso      | Uso generico     | Funcao Relacionada | Entrada Dados (Todos)  |
|==========|================================================================|
/*/
Static Function FindFilial( _oListFil, _aListFil )
Local _oDlgSeek
Local _cSeek := Space(20)
Local _lCase := .F.
Local _lWord := .F.
Local _nLastSeek := 0
Local _cLastSeek := ""
Local _nPos := _oListFil:nAt
Local _aSeek := {}

Aeval(_aListFil,{|x,y| Aadd(_aSeek,x[2])})

DEFINE MSDIALOG _oDlgSeek FROM 00,00 TO 105,370 TITLE "Localizar" PIXEL

@07,02 SAY "Código:" OF _oDlgSeek PIXEL 
@05,30 GET _cSeek OF _oDlgSeek PIXEL SIZE 100,9

@20,02 TO 51,130 LABEL "Opções" PIXEL OF _oDlgSeek 
@27,05 CHECKBOX _lCase PROMPT "&Coincidir maiúsc./minúsc." FONT _oDlgSeek:oFont PIXEL SIZE 80,09 //"&Coincidir maiúsc./minúsc."
@38,05 CHECKBOX _lWord PROMPT "Localizar palavra &inteira" FONT _oDlgSeek:oFont PIXEL SIZE 80,09

@05,135 BUTTON "&Próximo" PIXEL OF _oDlgSeek SIZE 44,11; //"&Próximo"
ACTION (_nPos := FastSeek(_cSeek,_nPos,_aSeek,_lCase,_lWord),_oListFil:nAt := _nPos,_oListFil:Refresh())

@18,135 BUTTON "&Cancelar" PIXEL ACTION _oDlgSeek:End() OF _oDlgSeek SIZE 44,11 //"&Cancelar"

ACTIVATE MSDIALOG _oDlgSeek CENTERED

Return


/*/
|==========|===============|=======|==================|======|==============|
|Funcao    | FastSeek      |Autor  | Tecnologia       | Data |              |
|==========|===============|=======|==================|======|==============|
|Descricao | Produra string                                                 |
|==========|================================================================|
|Sintax    | FastSeek                                                       |
|==========|================================================================|
|Parametros| Sem Argumentos                                                 |
|==========|================================================================|
| Uso      | Uso generico     | Funcao Relacionada | Entrada Dados (Todos)  |
|==========|================================================================|
/*/
Static Function FastSeek(cGet,nLastSeek,aArray,lCase,lWord)
Local nSearch := 0
Local bSearch

	cGet := Trim(cGet)
	
	If ( lCase .And. lWord )
		bSearch := {|x| Trim(x) == cGet}
	ElseIf ( !lCase .And. !lWord )
		bSearch := {|x| Trim(Upper(SubStr(x,1,Len(cGet)))) == Upper(cGet)}
	ElseIf ( lCase .And. !lWord )
		bSearch := {|x| Trim(SubStr(x,1,Len(cGet))) == cGet}
	ElseIf ( !lCase .And. lWord )
		bSearch := {|x| Trim(Upper(x)) == Upper(cGet)}
	EndIf
	
	nSearch := Ascan(aArray,bSearch,nLastSeek+1)
	If ( nSearch == 0 )
		nSearch := Ascan(aArray,bSearch)
		If ( nSearch == 0 )
			nSearch := nLastSeek
		EndIf
	EndIf     
	
Return nSearch

User Function RetSelFil(cNewFil)
	If cNewFil != NIL
		_cFiliais := cNewFil
	EndIf 
Return _cFiliais

User Function SelFiliais(cFiliais)
	Local cFiliais     
	Local cOldList
	Local lRet := .F.
	Local nTam
	Local nPos
	
	Default cFiliais := &(ReadVar())	 
	
	nTam := Len(cFiliais)

	If !Empty(cFiliais) .And. !U_VldSelFil(@cFiliais)	
		Return .F.
	EndIf
	
	cOldList := cFiliais
	
	U_RetSelFil(cFiliais)
	
	U_A050SelFil( .t., @cFiliais )

	If !( cFiliais  == cOldList )                  
		cFiliais := AllTrim(cFiliais)
		
		If Len(cFiliais) > nTam              
			Aviso("Atenção!","Não foi possível manter a seleção atual de filiais! Uma ou mais filiais foram ignoradas devido a limitação de quantidade. Por favor verifique a lista de filiais remanecentes.",{"Ok"})
		EndIf        
		
		cFiliais := Left(cFiliais,nTam)        
		
		nPos := Rat(",",cFiliais)
		
		If nPos != ( Len(cFiliais)-FWSizeFilial() )
			cFiliais := Left(cFiliais,nPos-1)
		EndIf

		cFiliais := PadR( AllTrim(cFiliais), nTam)
		
		U_RetSelFil( cFiliais )
		lRet := .T.
	EndIf

Return lRet 

User Function VldSelFil(cFiliais,lMostraMsg,lValidFil,lMultCGC,nNumEmp)
	Local lRet := .F.     
	Local nCt           
	Local nItemErro
	Local lReadVar := .F.
	Local nTam 
	Local nPos
	Local cMsg := ""      
	Local _aFiliais
	Local cCodFil
	
	lReadVar := (cFiliais==NIL)
	                         
	Default cFiliais   := &(ReadVar())
	Default lMostraMsg := .T.               
	Default lValidFil  := .T.
	Default lMultCGC   := .T.
	Default nNumEmp	   := 1

	nTam := Len(cFiliais)
	
	cFiliais := AllTrim(cFiliais)
	
	If !Empty(cFiliais)  
		_aFiliais := U_ReadFil( .T., {} )
		
		lRet := U_IsListVld(cFiliais,',',{|cVar| U_SoNumeros(cVar) },@nItemErro )    
		If !lRet
			cMsg := "Lista de filiais preenchida incorretamente! Verifique o item "+AllTrim(Str(nItemErro))+"."
		EndIf

		If lRet                   
			cFiliais := AllTrim(U_ConvList(cFiliais,',',{|cItem| StrZero(Val(cItem),FWSizeFilial()) }))

			//Variavel cCodFil utilizada como auxiliar devido a bug do compilador ADVPL que não permite
			//o uso do parametro de um codeblock em outro codeblock mais interno.
			If lValidFil 
				lRet := U_IsListVld(cFiliais,',',{|cItem| cCodFil:=cItem, aScan(_aFiliais,{|aItem| aItem[2]==cCodFil }) > 0 },@nItemErro )
				If !lRet
					cMsg := "Usuário sem acesso a filial "+U_ListItem(cFiliais,nItemErro,',')+"! Verifique o item "+AllTrim(Str(nItemErro))+"."
				EndIf
			EndIf
		EndIf    
		
		If lRet		
			If Len(cFiliais) > nTam              
				cMsg := "Não foi possível manter a seleção atual de filiais! Uma ou mais filiais foram ignoradas devido a limitação de quantidade. Por favor verifique a lista de filiais remanecentes."
				lRet := .F.

				cFiliais := Left(cFiliais,nTam)        
		
				nPos := Rat(",",cFiliais)
		
				If nPos != ( Len(cFiliais)-FWSizeFilial() )
					cFiliais := Left(cFiliais,nPos-1)
				EndIf
			Else 
				cFiliais := PadR(cFiliais,nTam)
			EndIf
			
			If lReadVar
				&(ReadVar()) := cFiliais
			EndIf
		EndIf

		If lRet .And. !lMultCGC
			lRet := U_VldFUCGC(cFiliais,lMostraMsg,nNumEmp)
		EndIf

		If lMostraMsg .And. (!lRet) .And. !Empty(cMsg)
			Aviso("Atenção!",cMsg,{"Ok"})
		EndIf
	EndIf
Return lRet                  

User Function VldFlUsu(_cFiliais,lMostraMsg)
	Local lRet   
	Local _aFiliais
	Local _cCodFil
	Local nItemErro         
	Local _cMsg                  
	
	Default lMostraMsg := .T.
	
	_aFiliais := U_ReadFil( .T., {} )
	
	_cFiliais := AllTrim(U_ConvList(_cFiliais,',',{|cItem| StrZero(Val(cItem),FWSizeFilial()) }))

	//Variavel cCodFil utilizada como auxiliar devido a bug do compilador ADVPL que não permite
	//o uso do parametro de um codeblock em outro codeblock mais interno.
	lRet := U_IsListVld(_cFiliais,',',{|cItem| _cCodFil:=cItem, aScan(_aFiliais,{|aItem| aItem[2]==_cCodFil }) > 0 },@nItemErro )
	
	If lMostraMsg .And. !lRet
		_cMsg := "Usuário sem acesso a filial "+U_ListItem(_cFiliais,nItemErro,',')+"! Verifique o item "+AllTrim(Str(nItemErro))+"."
		Aviso("Atenção!",_cMsg,{"Ok"})
	EndIf

Return lRet

User Function VldFUCGC(_cFiliais,lMostraMsg,nNumEmp)
	Local _lRet    := .T.
	Local _nPos 
	Local _xArea  := {}                
	Local _aCNPJ  := {}  
	Local _cFilial
	
	Default lMostraMsg := .T.                              
	Default nNumEmp    := 1

	aAdd( _xArea, SM0->( GetArea() ) )

	Do While _lRet .And. !Empty(_cFiliais)     
		_nPos := At(",",_cFiliais)

		If _nPos > 0
			_cFilial  := AllTrim(Left(_cFiliais,_nPos-1))
			_cFiliais := SubStr(_cFiliais,_nPos+1)
		Else
			_cFilial  := AllTrim(_cFiliais)
			_cFiliais := ""
		EndIf                               
	
		SM0->( dbSeek( cEmpAnt + _cFilial ) )

		If aScan(_aCNPJ,{ |cItem| cItem == Left(SM0->M0_CGC,8) }) == 0
			AAdd(_aCNPJ,Left(SM0->M0_CGC,8))			
		EndIf
			
		If Len(_aCNPJ) > nNumEmp
			_lRet := .F.
		EndIf
	EndDo
	
	u_PushArea( _xArea )
	
	If !_lRet
		Aviso("Atenção!","As Filiais selecionadas pertencem a mais de "+AllTrim(Str(nNumEmp))+" empresa"+IIF(nNumEmp>1,"s","")+"!"+;
			  " Esta rotina não permite utilizar a lista de filiais fornecida.",{"Ok"})
	EndIf
return _lRet

/*/
========================================================================|
|Função    |A050SelFil | Autor| AP5 IDE            | Data |  26/08/02   |
|==========|==================|===========================|=============|
|Descrição | Seleciona as filiais a serem usadas                        |
|          |                                                            |
|==========|============================================================|
|Uso       | Programa principal                                         |
=========================================================================
/*/
User Function A050SelFil( _lFiltra, _cLista )
Local _aTemp := {}, _nCt, _aListNew:= {}, _aSelect:= {}
Local _aLista := {}

	If !Empty( _cLista )
		_aLista := &( "{" + _cLista + "}" )
	EndIf

	For _nCt:= 1 to Len( _aLista )
		If !Empty( _aLista[_nCt] )
			aAdd( _aSelect,  cEmpAnt + StrZero(_aLista[_nCt],FWSizeFilial()) )
		EndIf
	Next

	_aTemp := u_fSelFil( _lFiltra, _aSelect )
	_cLista:= ''
	
	For _nCt:= 1 to Len( _aTemp )
		If _aTemp[_nCt][1]
			_cLista+= _aTemp[_nCt][2] + ','
		EndIf
	Next
	
	_cLista := SubStr( _cLista, 1, Len( _cLista ) -1 )
	    
Return(.t.)
