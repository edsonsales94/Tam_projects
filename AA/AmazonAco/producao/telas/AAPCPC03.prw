//-------------------------------------------------------. 
// Declaracao das Bibliotecas                             |
//-------------------------------------------------------' 
#INCLUDE "PROTHEUS.CH"
#include 'TBICONN.ch'

//-------------------------------------------------------. 
// Declaracao das Constantes                              |
//-------------------------------------------------------' 
#DEFINE APOS { 15, 1, 65, 315 }

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAPCPC03   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Check List de Producao                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/	

User Function AAPCPC03()
 //-------------------------------------------------------. 
 // Declaracao de variveis Privadas                        |
 //-------------------------------------------------------' 
 Private cCadastro := "Check List de Producao"
 Private aRotina   := { { "Pesquisar" ,"AxPesqui"  , 0, 1, 0, .F.},; //"Pesquisar"
	                     { "Visualizar","u_PCPC03a" , 0, 2, 0, NIL},; //"Visualiza"
					         { "Incluir"   ,"u_PCPC03a" , 0, 3, 0, nil} } //"Incluir"

	//-------------------------------------------------------. 
	// Exibi o mbrowser com os dados da SZJ                   |
	//-------------------------------------------------------' 
	mBrowse(6, 1, 22, 75, "SZJ",,,,,,)

Return (.T.)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fInclui    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Check List de Producao                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PCPC03a(cAlias,nReg,nOpcx)

 //-------------------------------------------------------. 
 // Declaracao de Variaveis Locais                         |
 //-------------------------------------------------------' 
 Local aSize      := MsAdvSize()
 Local aPosObj    := {}
 Local aObjects   := {}
 Local aArea      := GetArea()
 Local aTitles    := {"Pessoal","Processo", "Qualidade", "5S"} //'Notas Fiscais'###'Itens da Nota Fiscal'
 Local nGd1       := 0
 Local nGd2       := 0
 Local nGd3       := 0
 Local nGd4       := 0
 Local nPosDoc	 := 0
 Local nX         := 0
 Local nY         := 0
 Local nOpcA      := 0
 Local nSaveSX8   := GetSX8Len()
 Local oDlg
 Local aCpos      := {}
 Local aAlter     := If ( nOpcx == 3, {"ZL_ACAO", "ZL_RESPOST","ZL_DATA"}, {} )
 Local aNewVec    := {}

 //-------------------------------------------------------. 
 // Declaracao de Variaveis privadas                       |
 //-------------------------------------------------------' 
 Private oFolder  := {}
 Private aTELA[0][0],aGETS[0]
 Private aHeader1 := {}
 Private aHeader2 := {}
 Private aHeader3 := {}
 Private aHeader4 := {}
 Private aCols1   := {}
 Private aCols2   := {}
 Private aCols3   := {}
 Private aCols4   := {}
 Private oGetDad1 := Nil 
 Private oGetDad2 := Nil
 Private oGetDad3 := Nil
 Private oGetDad4 := Nil


	dbSelectArea('SZJ')
	dbSetOrder(1)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem da Variaveis de Memoria                      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To FCount()   
			M->&(FieldName(nX)) := If ( nOpcx == 3, CriaVar(FieldName(nX)), FieldGet(nX) ) 
				Aadd(aCpos,FieldName(nX))   
                                              
			
	Next nX

	aHeader1 := aHeader2 := aHeader3 := aHeader4 := CriaHeader("SZL", "ZL_TURNO|ZL_LINHA")     
	
	For nW := 1 to 4 
		&( 'aCols' + AllTrim(Str(nw)) ) := CarregaAcols(nOpcx, aHeader1, nW)		
	Next nW  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a tela principal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	aAdd( aObjects, {   0,  90, .t., .f. } )
	aAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	
	aNewVec    := aClone(APOSOBJ[1])
	aNewVec[3] := aNewVec[3]-50
	
	EnChoice( cAlias ,nReg, nOpcx, , , , {"ZJ_TURNO", "ZJ_LINHA", "ZJ_LIDER", "ZJ_CHEFE"} , aNewVec, aCpos , nOpcx)
	
	oFolder := TFolder():New(aPosObj[2,1]-60,aPosObj[2,2],aTitles,{'','', '', ''},oDlg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1]-80)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define as posicoes da Getdados a partir do folder    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nGd1 := 2
	nGd2 := 2
	nGd3 := aPosObj[2,3]-aPosObj[2,1]-15
	nGd4 := aPosObj[2,4]-aPosObj[2,2]-4                                       
	
	oGetDad1 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4, GD_INSERT + GD_UPDATE, /*VLOK*/, /*TOK*/, '',aAlter,0 ,Len(Acols1), /*COK*/, .F. ,.F., oFolder:aDialogs[1], aHeader1, aCols1)
	oGetDad1:oBrowse:lDisablePaint := .T.
	oGetDad1:lF3Header = .T.
 
	oGetDad2 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4, GD_INSERT + GD_UPDATE, /*VLOK*/, /*TOK*/, '',aAlter,0 ,Len(Acols2), /*COK*/, .F. ,.F., oFolder:aDialogs[2], aHeader2, aCols2)
	oGetDad2:oBrowse:lDisablePaint := .T.                                                                                                                            
	oGetDad2:lF3Header = .T.

	oGetDad3 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4, GD_INSERT + GD_UPDATE, /*VLOK*/, /*TOK*/, '',aAlter,0 ,Len(Acols3), /*COK*/, .F. ,.F., oFolder:aDialogs[3], aHeader3, aCols3)
	oGetDad3:oBrowse:lDisablePaint := .T.
	oGetDad3:lF3Header = .T.

	oGetDad4 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4, GD_INSERT + GD_UPDATE, /*VLOK*/, /*TOK*/, '',aAlter,0 ,Len(Acols4), /*COK*/, .F. ,.F., oFolder:aDialogs[4], aHeader4, aCols4)
	oGetDad4:oBrowse:lDisablePaint := .T.
	oGetDad4:lF3Header = .T.
		
	oFolder:bSetOption:={|nAtu| M145Fld(nAtu,oFolder:nOption,oFolder,{oGetDad1,oGetDad2,oGetDad3,oGetDad4})}
	
	ACTIVATE MSDIALOG oDlg ON INIT (M145Refre({oGetDad1,oGetDad2,oGetDad3,oGetDad4}), EnchoiceBar(oDlg,{|| If(Obrigatorio(aGets,aTela) .And. fTudoOk(nOpcx) .And. A145FldRfr(oFolder),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||(nOpcA:=2,oDlg:End())},,{}))
		
	If nOpcA == 1
		Begin Transaction    			
		  lwInclui := fSalvar( nOpcx )
		End Transaction
		
		If lwInclui 
			fwEmail(SZJ->ZJ_DATA, SZJ->ZJ_TURNO, SZJ->ZJ_LINHA, SZJ->ZJ_LIDER, SZJ->ZJ_CHEFE)
		EndIf 
		
	EndIf

	MsUnLockAll()

	RestArea(aArea)

Return(.T.)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ M145Fld    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Manutencao nos folders                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function M145Fld(nFldDst,nFldAtu,oFolder,aGetDad)

 Local lRetorno:= .T. // .f.

Return(lRetorno)


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ M145Refre  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Manutencao nos folders                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function M145Refre( aGetDad )

 Local nLoop      := 0

	For nLoop := 1 To Len( aGetDad )
		aGetDad[nLoop]:oBrowse:lDisablePaint := .F.
		aGetDad[nLoop]:oBrowse:Refresh(.T.)
	Next nLoop
	
Return( .T. )

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fSalvar    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para salvar os dados do Check-List                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/	
Static Function fSalvar(nOpc,aRecDB3)
 Local nCntFor	  := 0
 Local nCntFor2	  := 0
 Local nUsado	  := Len(oGetDad1:aHeader)
 Local lwInclui  := .F.
				
	If nOpc == 3		// Inclusao
			dbSelectArea("SZJ")
			Reclock("SZJ",.T.)
			For nCntFor := 1 To SZJ->(FCount())
				If ( FieldName(nCntFor)!="ZJ_FILIAL"  )
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				Else
					SZJ->ZJ_FILIAL := xFilial("SZJ")  
					//SZJ->ZJ_DATA   := Date()
				EndIf
			Next nCntFor
			MsUnlock()     
			
			dbSelectArea("SZL")                         						
			For nwX := 1 to 4                           
				aAuxAcols := &("oGetDad"+AllTrim(Str(nwX)) + ":aCols")
				For nCntFor := 1 To Len( aAuxAcols )
					Reclock("SZL",.T.)
						For nCntFor2 := 1 To nUsado
							If ( oGetDad1:aHeader[nCntFor2][10] != "V" )
								FieldPut(FieldPos(oGetDad1:aHeader[nCntFor2][2]),aAuxAcols[nCntFor][nCntFor2])
							EndIf
						Next nCntFor2 
						
						SZL->ZL_FILIAL := xFilial("SZL")
						SZL->ZL_DATA   := SZJ->ZJ_DATA
						SZL->ZL_LINHA  := SZJ->ZJ_LINHA
						SZL->ZL_TURNO  := SZJ->ZJ_TURNO
					MsUnlock()
				Next nCntFor
	   	Next nwX 	        
                                
         lwInclui := .T.
    EndIf 

Return lwInclui

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fTudoOk    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validacao Geral do Check List                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/	
Static Function fTudoOk(nOpcx)
 Local nCntFor := 0
 Local lRet    := .T.
 Local _nCol3  := Ascan( oGetDad1:aHeader , {|x| Trim(x[2]) == "ZL_RESPOST"} )  
 Local aAux    := {"Pessoal","Processo", "Qualidade", "5S"} 
	
	For nwX := 1 to 4                           
		aAuxAcols := &("oGetDad"+AllTrim(Str(nwX)) + ":aCols")
		For nCntFor := 1 To Len( aAuxAcols )
			
			If lRet .And. Empty( aAuxAcols[nCntFor][_nCol3] ) 
			 	lRet := .F. 
			 	MsgStop("Favor responder todas as perguntas da aba " +aAux[nwx]+ "!")
			EndIf 
			
		Next nCntFor
  	Next nwX            
  
	SZJ->(dbSetOrder(1))
	
	If lRet .And. 	SZJ->(dbSeek( xFilial("SZJ") + DTOS(M->ZJ_DATA) + M->ZJ_LINHA + M->ZJ_TURNO ) )
	
		MsgStop("Jã existe Check-List nesta data para esta Linha/Turno!")
		Return lRet
	
	EndIf 


Return lRet    

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A145FldRfr ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Atualiza posicao do folder para manter integridade dos dados  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/	
Static Function A145FldRfr(oFolder)

	If oFolder:nOption == 2
		oFolder:SetOption(1)
	EndIf
                                                                                     
Return .T.                                                                           

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 03/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para a montagem do Header do MSNewGetDados             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader(cTbl,cCampos)
 Local aHeader := {}
 Local aAreaSX3:= SX3->(GetArea())

	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cTbl))

	WHile cTbl = SX3->X3_ARQUIVO
		If cNivel >= SX3->X3_NIVEL .And. X3USO(SX3->X3_USADO) .And. !(Alltrim(SX3->X3_CAMPO) $ cCampos)
			aAdd(aHeader,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
			               SX3->X3_CAMPO   , ;  //2  Nome do Campo
			               SX3->X3_PICTURE , ;  //3  Picture Campo
			               SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
			               SX3->X3_DECIMAL , ;  //5  Casas decimais
			               SX3->X3_VALID   , ;  //6  Validacao do campo
			               SX3->X3_USADO   , ;  //7  Usado ou naum
			               SX3->X3_TIPO    , ;  //8  Tipo do campo			               			               
                           SX3->X3_F3	   , ;  //9 Consulta padrao 
                  		   SX3->X3_CONTEXT , ;  // Contexto
                      	   SX3->X3_CBOX    , ;  // Combo
                      	   SX3->X3_RELACAO } )  //10 Visualizar ou alterar
			               	
		EndIf                                                               			
		SX3->(dbSkip())
	EndDo
	SX3->(GetArea())
	
Return aHeader                                                                       


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦CarregaAcols¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina onde serão carregados os dados para o acols            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CarregaAcols(nOpcy, awHeader, nwTipo)
 Local lRet   := .T.
 Local awCols := {}

  _nCol1 := Ascan( awHeader , {|x| Trim(x[2]) == "ZL_CODPERG"} )
  _nCol2 := Ascan( awHeader , {|x| Trim(x[2]) == "ZL_PERGUNT"} )
  _nCol3 := Ascan( awHeader , {|x| Trim(x[2]) == "ZL_RESPOST"} )
  _nCol4 := Ascan( awHeader , {|x| Trim(x[2]) == "ZL_ACAO"   } ) 

  cArea   := GetArea()  
    
  fTabTmp(nwTipo, nOpcy) 
  
  If !TMP01->(Eof())  
      	While !TMP01->(Eof())
      		fCriaVar(@awCols, awHeader)
 	  	 	awCols[Len(awCols)][_nCol1] := TMP01->ZL_CODPERG
 		 	awCols[Len(awCols)][_nCol2] := TMP01->ZL_PERGUNT
 		  	awCols[Len(awCols)][_nCol3] := TMP01->ZL_RESPOST
 	  	  	awCols[Len(awCols)][_nCol4] := TMP01->ZL_ACAO
	  	  	TMP01->(dbSkip())              
  		End
  	Else 
   		fCriaVar(@awCols, awHeader)
  EndIf  
  
  TMP01->(dbCloseArea())
Return awCols      

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fCriaVar   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida o campo do acols                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fCriaVar(awCols, awHeader)
  aAdd(awCols,Array(Len(awHeader)+1))                	
  For i:= 1 to Len(awHeader)		  
    awCols[Len(awCols)][i] := CriaVar(Trim(awHeader[i][2]),.T.)
  Next    
  awCols[Len(awCols)][len(awHeader)+1] := .F.
Return nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fTabTmp    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Retorna as O.S. do pedido selecionado                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fTabTmp(nTipo, nOpcy)
 Local cQuery := ""
                               
  If nOpcy == 3        
	  	  
		  cQuery := " SELECT ZI_COD AS ZL_CODPERG, ZI_DESC AS ZL_PERGUNT, '' AS ZL_RESPOST, ZI_ACAO AS ZL_ACAO "
		  cQuery +=   " FROM "+RetSQLName("SZI")+" A "   
		  cQuery +=  " WHERE A.D_E_L_E_T_ = ' ' "
		  cQuery +=    " AND ZI_TIPO = '" + Alltrim(Str(nTipo)) + "' "
		  cQuery +=    " AND ZI_MSBLQL <> '1' " 
		  cQuery += "  ORDER BY ZI_COD "	      
	  Else 	  	  	  
		  cQuery := " SELECT ZL_CODPERG, ZL_PERGUNT, ZL_RESPOST, ZL_ACAO "
		  cQuery +=   " FROM "+RetSQLName("SZL")+" A (NOLOCK) "   
		  cQuery +=  " INNER JOIN " +RetSQLName("SZI")+" B (NOLOCK) "   
		  cQuery +=     " ON B.D_E_L_E_T_ = ' ' AND ZI_COD = ZL_CODPERG "
		  cQuery +=  " WHERE A.D_E_L_E_T_ = ' ' "
		  cQuery +=    " AND ZL_DATA  = '" + dTos(M->ZJ_DATA) + "' "
		  cQuery +=    " AND ZL_TURNO = '" +      M->ZJ_TURNO + "' "
		  cQuery +=    " AND ZL_LINHA = '" +      M->ZJ_LINHA + "' "
		  cQuery +=    " AND ZI_TIPO = '"  + Alltrim(Str(nTipo)) + "' "
		  cQuery += "  ORDER BY ZI_COD "	      
	  
  EndIf                               
     
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP01", .T., .F. )

Return Nil
                                                                                     

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwEmail    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ennvia um e-mail com a o check List Cadastrado                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwEmail(_dData, _cTurno, _cLinha)
 Local cAccount  := ""
 Local cServer   := ""
 Local cPass     := ""
 Local cMens	    := ""
 Local nQtde     := 0
 Local lRet      := .T. 	
 Local cMsg      := GetHtml(_dData, _cTurno, _cLinha)
 Local cEmail    := SuperGetMv("MV_XCHECKA",.f.,"francisco@amazonaco.com.br")
 Local cTitulo   := 'Check List de Produçao'

	cUser    := SuperGetMv("MV_RELAUSER",.F.,"")
	cAccount := SuperGetMv("MV_RELACNT" ,.F.,"")  // Conta de Envio de Relatorios por e-mail do acr
	cServer  := SuperGetMv("MV_RELSERV" ,.F.,"")  // IP do Servidor de e-mails
	cPass    := SuperGetMv("MV_RELPSW"  ,.F.,"")  //"260687" Senha da Conta de e-mail    
	lRelAuth := SuperGetMv("MV_RELAUTH" ,.F., .T.)
 	cCC      := SuperGetMv("MV_XCHECKB" ,.F.,"wermeson.hp7@gmail.com;wermeson.ramos@fvncional.com.br") + SuperGetMv("MV_XCHECKC",.F.,"") 
    
   CONOUT( CSERVER  )
   conout(  at(":",cServer)  )
   CONOUT( SubStr(cServer,at(":",cServer) + 1 )  )
   
	nPorta   := Val( SubStr(cServer,at(":",cServer) + 1 ) )
	cServer := If(at(":",cServer) > 0, SubStr(cServer,1,at(":",cServer) - 1 ), cServer)
	
   nPorta := iIf(nPorta == 0,25,nPorta)
	conout(nPorta)
	conout(cserver)

	oMail := TMailManager():New()
	oMsg  := TMailMessage():New()
    
                
	oMail:SetUseSSL(.T.)
   oMail:SetUseTLS(.T.)
	if nRet := oMail:Init("" , cServer,cAccount,cPass,0 ,nPorta) != 0
		CONOUT( '[ERRO]' , oMail:GetErrorString(nRet) )
	Else		                                              
		nRet := oMail:SetSmtpTimeOut( 60 )
		If nRet != 0
			conout("[TIMEOUT] Fail to set")
			conout("[TIMEOUT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			lRet := .F.
		EndIf

		if lRet
			nRet := oMail:SmtpConnect()
			If nRet != 0
				conout("[CONECT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
				lRet := .F.
			EndIf
		EndIf

		if lRelAuth .And. lRet
			nRet := oMail:SMTPAuth(cAccount, cPass)
			If nRet != 0
				conout("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
				conout("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))

				conout("[AUTH] TRY with USER() and PASS()")
				// try with user and pass
				nRet := oMail:SMTPAuth(cUser, cPass)
				If nRet != 0
					conout("[AUTH] FAIL TRY with USER() and PASS()")
					conout("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
					lRet := .F.
				else
					conout("[AUTH] SUCEEDED TRY with USER() and PASS()")
				Endif
			else
				conout("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
			Endif
		Else
			conout("[AUTH] WHITHOUT AUTHENTICATION  TO ACCOUNT ")
		EndIf


		If lRet

			oMsg:Clear()
			oMsg:cFrom := cAccount
			oMsg:cTo   := cEmail
			oMsg:cCC   := cCC
			oMSg:cSubject:= cTitulo
			oMsg:cBody := cMsg

			nRet := oMsg:Send(oMail)
			If nRet != 0
				Conout("[SEND] Fail to send message" )
				conout("[SEND][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			else
				Conout( "[SEND] Sucess to send message" )
			EndIf

			conout("[DISCONNECT] smtp disconnecting ... ")
			nRet := oMail:SmtpDisconnect()
			If nRet != 0
				conout("[DISCONNECT] Fail smtp disconnecting ... ")
				conout("[DISCONNECT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			else
				conout("[DISCONNECT] Sucess smtp disconnecting ... ")
			EndIf
		EndIf
	EndIf

Return lRet


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ getHtml    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta html de envio de e-mail com o Check-List                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function getHtml(_dData, _cTurno, _cLinha)
 Local _cdHtml  := ''
 Local _adCabec := {'Codigo','Pergunta','Resposta','Acão'}
 Local aTitles  := {"Pessoal","Processo", "Qualidade", "5S"} //'Notas Fiscais'###'Itens da Nota Fiscal'
 Local _adDados := {}

	_cdHtml += "<html> "
  	_cdHtml += '	<head> '
  	_cdHtml += '		<title> Romaneios </title> '
  	_cdHtml += '    	<meta name="author" content="Wermeson Gadelha do Canto" /> '
  	_cdHtml += '	</head> '
  	_cdHtml += 		GetStyle()
  	_cdHtml += '  	<body> '      
  
//  	_cdHtml += ' 		Check List de Producao                <br>
	_cdHtml += ' 		Data  : ' + dToc(_dData) //+ //' <br>
	_cdHtml += ' 		Turno : ' +      _cTurno //+ //' <br>
	_cdHtml += ' 		Linha : ' +      _cLinha + ' <br> <br>
                      
	For nwX := 1 To Len(aTitles) 
	
		_adDados := aClone(_GetDados(_dData, _cTurno, _cLinha, nwX))
	
		_cdHtml += " 		<table border='1', cellspacing='0' cellpadding='1'>"
		_cdHtml += '  			<caption>'+aTitles[nwX]+'</caption>' 
		     	     
		_cdHtml += '  			<tHead> '
		_cdHtml +=  				MakeTbl(_adCabec,'C')
		_cdHtml += ' 	 		</tHead> '
	
		_cdHtml +=  '  		<tBody> '        
	
		For nI := 1 To Len(_adDados)
			_cdHtml +=  			MakeTbl(_adDados[nI],'D')
		Next
	
		_cdHtml += ' 	 		</tBody> '
		_cdHtml += ' 	 	</table> '
	
	Next nwX 
		  	
  	_cdHtml += ' 	 </body> '
	_cdHtml += "</html> "
Return _cdHtml

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ _GetDados  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta tabela temporária com os dados a serem enviado no E-mail¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function _GetDados(_dData, _cTurno, _cLinha, _nTipo)

 Local _aBrowse := {}

	cQuery := " SELECT ZL_CODPERG, ZL_PERGUNT, ZL_RESPOST, ZL_ACAO "
	cQuery +=   " FROM "+RetSQLName("SZL")+" A (NOLOCK) "   
	cQuery +=  " INNER JOIN " +RetSQLName("SZI")+" B (NOLOCK) "   
	cQuery +=     " ON B.D_E_L_E_T_ = ' ' AND ZI_COD = ZL_CODPERG "
	cQuery +=  " WHERE A.D_E_L_E_T_ = ' ' "
	cQuery +=    " AND ZL_DATA  = '" + dTos(_dData) + "' "
	cQuery +=    " AND ZL_TURNO = '" +      _cTurno + "' "
	cQuery +=    " AND ZL_LINHA = '" +      _cLinha + "' "
	cQuery +=    " AND ZI_TIPO = '"  + Alltrim(Str(_nTipo)) + "' "
	cQuery += "  ORDER BY ZI_COD "	      
	      
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP02", .T., .F. )
   
	dbselectarea("TMP02")
	TMP02->(DBGOTOP())        	
	        
	While !TMP02->(EOF())


		aAdd( _aBrowse, { TMP02->ZL_CODPERG  ,; //01
								TMP02->ZL_PERGUNT  ,; //02
								TMP02->ZL_RESPOSTA ,; //03						
								TMP02->ZL_ACAO     }) //04
	
		TMP02->(dbSkip())
	EndDo 	
	 
	TMP02->(dbCLoseArea())
   
Return _aBrowse

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MakeTbl    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta tabela em Html conforme os dados do Check-List          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MakeTbl(_adDados,_cdTp)
   
    _cdTbl := ' <tr> '
    For _ndI := 1 To Len(_adDados)	
      If _cdTp == 'C'
		   _cdTbl += ' <th> ' + _adDados[_ndI] + ' </th> '
      ElseIf _cdTp == 'D'
		   _cdTbl += ' <td> ' + _adDados[_ndI] + ' </td> '
      EndIf
	Next
   _cdTbl += ' </tr> '

Return _cdTbl

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwEmail    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Define a Folha de estilo padrao                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GetStyle()
 Local _cdStyle := ""     
 
	_cdStyle += '  <style  type="text/css"> '
	_cdStyle += "        caption {"
	_cdStyle += "  	   color: #FF0000;"
	_cdStyle += "  		font-size : 28px;"
	_cdStyle += "  		font-style: italic;"
	_cdStyle += "  	  } "
	_cdStyle += "  	  thead{"
	_cdStyle += "  	    color: #000080; "
	_cdStyle += "  		 font-size: 14px; "
	_cdStyle += "  		 font-style: oblique;	"		
	_cdStyle += "  	  } "
	_cdStyle += "  	  th{ "
	_cdStyle += "  	    border-style: solid;  "
	_cdStyle += "  	    border-right-width: 1px;  "
	_cdStyle += "  		 border-left-width: 1px;  "
	_cdStyle += "  		 border-top-width: 1px;  "
	_cdStyle += "  		 border-bottom-width: 1px;  "
	_cdStyle += "  		 border-color: #00f;		    "
	_cdStyle += "  	  } "
	_cdStyle += "  	  td{  "
	_cdStyle += "  	    font-weight: bold; "
	_cdStyle += "  	    border-style: solid;  "
	_cdStyle += "  	    border-right-width: 1px;  "
	_cdStyle += "  		 border-left-width: 1px;  "
	_cdStyle += "  		 border-top-width: 1px;  "
	_cdStyle += "  		 border-bottom-width: 1px;  "
	_cdStyle += "  		 border-color: #ff0000;	  "
	_cdStyle += "  	  } "
		  
	_cdStyle += "  	  tbody{  "
	_cdStyle += "  	    font-size: 12px; "
	_cdStyle += "  		 font-style: normal;	"
	_cdStyle += "  	  }  "
	_cdStyle += "  	  table{
	//_cdStyle += '  	     style="width:680px; '
	_cdStyle += "  		  color:#343434;        "
	_cdStyle += "  		  font-size:13px;   "
	_cdStyle += "  		  text-align:justify;  "
	_cdStyle += "  	  }
		  
	_cdStyle += "     </style>   
	
Return _cdStyle

/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
************************************************************************************/