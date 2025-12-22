/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CESTG200  ³ Autor ³ Carlos Nina           ³ Data ³ 30/11/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Copia de Cad. Produto/Estrutura entre bases                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Engenharia de Produto                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
//--------------------------------------------------------------
#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

User Function CESTG200()

Private oDlg,oMulti,oBrowse,oBtnConf,oBtnSair,oChkBoxSB1,oChkBoxSG1,oEmprDe,oEmprPra,oProduto,oDesc,oGroup1,oGroup2,oGroup3
Private oSay1,oSay2,oSay3,oSay4
Private cProduto   := SPACE(30)
Private mProduto   := SPACE(30)
Private cDesc      := SPACE(200)
Private cEmprDe    := SPACE(41)
Private cEmprPra   := SPACE(41)
Private c_Tipo     := SPACE(2)
Private n          := 1
Private lSair      := .F.
Private lFirstTime := .T.
Private lSB1Dest   := .F.
Private lSG1Dest   := .F.
Private lSG1Orig   := .T.
Private lChkBoxSB1 := .F.
Private lChkBoxSG1 := .F.
Private aEmprDe    := {SPACE(41),"01/01 - Coel Contr. Eletricos           C","03/01 - Coelmatic Manaus                E","03/02 - Coelmatic São Paulo             E","09/01 - CoelSensores                E"}
Private aEmprPra   := {SPACE(41),"01/01 - Coel Contr. Eletricos           C","03/01 - Coelmatic Manaus                E","03/02 - Coelmatic São Paulo             E","09/01 - CoelSensores                E"}
Private aCols      := {{SPACE(3),SPACE(30),SPACE(30),SPACE(30),SPACE(30),SPACE(50)}}
Private aHeader    := {}

AADD(aHeader,{"Seq. "                , "B1_NARRA  " ,"                 " ,03,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Produto"              , "B1_COD    " ,"                 " ,30,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Da Empresa"           , "B1_NARRA  " ,"                 " ,21,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Para a Empresa"       , "B1_NARRA  " ,"                 " ,21,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Cadastro de"          , "B1_NARRA  " ,"                 " ,20,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Mensagem"             , "B1_NARRA  " ,"                 " ,50,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})

dbSelectArea("SG1")
dbSetOrder(1)
*
dbSelectArea("SB5")
dbSetOrder(1)
*
dbSelectArea("SB1")
dbSetOrder(1)

DEFINE MSDIALOG oDlg TITLE "Cópia de Codigos de Produto" FROM 000, 000  TO 480, 864 COLORS 0, 16777215 PIXEL

    @ 002, 004 GROUP oGroup1 TO 077, 359 PROMPT "Parametros"                                         OF oDlg COLOR  0, 16777215 PIXEL
    @ 010, 008 SAY oSay1                 PROMPT "Empresa Origem"                       SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017, 008 MSCOMBOBOX oEmprDe        VAR cEmprDe     ITEMS aEmprDe                 SIZE 085, 010 OF oDlg COLORS 0, 16777215 VALID f_Produto1(cProduto, LEFT(cEmprDe,5), RIGHT(cEmprDe,1) , 1 )  PIXEL
    @ 031, 008 SAY oSay2                 PROMPT "Empresa Destino"                      SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL	 	 
    @ 038, 008 MSCOMBOBOX oEmprPra       VAR cEmprPra    ITEMS aEmprPra                SIZE 085, 010 OF oDlg COLORS 0, 16777215 VALID f_Produto2(cProduto, LEFT(cEmprPra,5), RIGHT(cEmprPra,1) ) PIXEL
    @ 053, 008 SAY oSay3                 PROMPT "Código do Produto"                    SIZE 047, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 053, 105 SAY oSay4                 PROMPT "Descrição"                            SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 008 MSGET oProduto            VAR cProduto                  F3 "SB1"        SIZE 090, 010 OF oDlg COLORS 0, 16777215 VALID f_Produto1(cProduto, LEFT(cEmprDe,5), RIGHT(cEmprDe,1) , 2 ) PIXEL
    @ 060, 105 MSGET oDesc               VAR cDesc                                     SIZE 250, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

    @ 010, 105 GROUP oGroup2 TO 050, 196 PROMPT "Copiar para"                                        OF oDlg COLOR  0, 16777215 PIXEL
    @ 020, 110 CHECKBOX oChkBoxSB1       VAR lChkBoxSB1 PROMPT "Cadastro de Produto"   SIZE 060, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 035, 110 CHECKBOX oChkBoxSG1       VAR lChkBoxSG1 PROMPT "Estrutura de Produto"  SIZE 060, 008 OF oDlg COLORS 0, 16777215 PIXEL
	 
    @ 010, 370 BUTTON oBtnConf PROMPT "Confirma Parametros"                            SIZE 060, 012 OF oDlg ACTION f_copystru() PIXEL
    @ 029, 370 BUTTON oBtnSair PROMPT "Sair"                                           SIZE 060, 012 OF oDlg ACTION f_sair() PIXEL
    
	 @ 083, 004 GROUP oGroup3 TO 234, 430 PROMPT "Processamento"                                      OF oDlg COLOR 0, 16777215 PIXEL
	 @ 090, 008 TO 230, 427 MULTILINE  Object oMulti      
	 ///oMulti:oBrowse:bchange  := { || LineOkk("CHANGE") }
	 ///oMulti:oBrowse:baltered := { || LineOkk("ALTERED") }

ACTIVATE MSDIALOG oDlg CENTER Valid lSair

Return

//////////////////////////////////////////////////////
Static Function f_sair()
//////////////////////////////////////////////////////
Local lResp

lResp := MsgBox("Deseja sair da rotina?","Escolha a opção","YESNO")

IF ( lResp )
	lSair := .T.
	oDlg:End()
ENDIF

Return(lResp)

/////////////////////////////////////////////////////////////////
Static Function f_Produto1(c_Produto,c_Filial,c_Modo,n_Seq)
/////////////////////////////////////////////////////////////////
Local l_Rsp    := .T.
Local x_Filial := IIF(c_Modo=="C" , SPACE(2) , RIGHT(c_Filial,2) )

IF ( !EMPTY(c_Produto) )
	IF ( EMPTY(c_Filial) )
		IF ( n_Seq==2 )
			MsgStop("Falta informar a Empresa Origem.")
		ELSE
			oProduto:SetFocus()
		ENDIF	
	ELSEIF ( cEmprDe == cEmprPra )
		MsgStop("Empresa Origem inválida: igual a Empresa Destino. Favor verificar!")
		cEmprDe := SPACE(41)
		oEmprDe:Refresh()
		oEmprDe:nAt := 1
	ELSE
		c_Filial := STRTRAN(c_Filial,"/","")
		////
		//// Pesquisa o codigo do produto na empresa origem. (falta definir se executa a copia pela empresa selecionada no acesso ao protheus.
		////
		cQry  := "SELECT B1_COD,B1_DESC,B1_TIPO FROM SB1"+LEFT(c_Filial,3)
		cQry  += " WHERE D_E_L_E_T_ = ' '"
		cQry  += " AND B1_FILIAL = '"+x_Filial+"'"
		cQry  += " AND B1_COD = '"+c_Produto+"' "

		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMPSB1', .T., .T.)
		
		c_Descri := TMPSB1->B1_DESC
		c_Tipo   := TMPSB1->B1_TIPO
		
		TMPSB1->(dbCloseArea())

		IF ( EMPTY(c_Descri) )
			MsgStop("Produto não cadastrado na Empresa Origem. Favor verificar!"+CHR(13)+CHR(10)+"      Empresa Origem: "+SUBS(cEmprDe,9,21))
			cEmprDe := SPACE(41)
			oEmprDe:Refresh()
			oEmprDe:nAt := 1
		ELSE
			IF ( !EMPTY(cEmprPra) )
				f_Produto2(cProduto, LEFT(cEmprPra,5), RIGHT(cEmprPra,1) )
			ENDIF
			SB5->(dbSeek(xFilial("SB5")+c_Produto))
			cDesc := IIF(SB5->(EOF()) , c_Descri , SB5->B5_CEME )
			IF ( SB5->(EOF()) )
				MsgInfo("Atenção!!! Produto informado não existe no Cadastro de Complemento de Produtos. Favor verificar.")
			ENDIF
		ENDIF
	ENDIF	
ELSEIF ( !EMPTY(cDesc) )
	cDesc := SPACE(200)
ENDIF	

Return(.T.)

/////////////////////////////////////////////////////////////////
Static Function f_Produto2(c_Produto,c_Filial,c_Modo)
/////////////////////////////////////////////////////////////////
Local lRsp     := .T.
Local x_Filial := IIF(c_Modo=="C" , SPACE(2) , RIGHT(c_Filial,2) )

IF ( !EMPTY(c_Filial) )
	IF ( cEmprDe == cEmprPra )
		MsgStop("Empresa Destino inválida: não pode ser igual a Empresa Origem. Favor verificar!")
		cEmprPra := SPACE(41)
		oEmprPra:Refresh()
		oEmprPra:nAt := 1
	ELSEIF ( !EMPTY(c_Produto) )
		lSB1Dest := .F.
		c_Filial := STRTRAN(c_Filial,"/","")
		////
		//// Pesquisa o codigo do produto na empresa destino (tem que ser por query)
		////
		cQry  := "SELECT B1_COD,B1_DESC,B1_TIPO FROM SB1"+LEFT(c_Filial,3)
		cQry  += " WHERE D_E_L_E_T_ = ' '"
		cQry  += " AND B1_FILIAL = '"+x_Filial+"'"
		cQry  += " AND B1_COD = '"+c_Produto+"' "

		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMPSB1D', .T., .T.)
		
		IF ( TMPSB1D->(!EOF()) )
			MsgInfo("** Produto já cadastrado na Empresa Destino."+CHR(13)+CHR(10)+"Favor verificar!")
			lSB1Dest := .T.
		ENDIF
		TMPSB1D->(dbCloseArea())
		*****
		f_Chk2Stru(cProduto)            ///Verifica se está cadastrado na Estrutura do Produto
		*****
	ENDIF		
ENDIF	

Return

/////////////////////////////////////////////////////////////////
Static Function f_Chk2Stru(c_Produto)
/////////////////////////////////////////////////////////////////
Local l_Rsp       := .T.
Local c_FilialDe  := LEFT(cEmprDe,5)
Local c_FilialPra := LEFT(cEmprPra,5)
Local c_ModoDe    := RIGHT(cEmprDe,1)
Local c_ModoPra   := RIGHT(cEmprPra,1)
Local x_FilialDe  := IIF(c_ModoDe=="C" , SPACE(2) , RIGHT(c_FilialDe,2) )
Local x_FilialPra := IIF(c_ModoPra=="C" , SPACE(2) , RIGHT(c_FilialPra,2) )

	IF ( !EMPTY(c_FilialDe) )
		lSG1Orig   := .T.
		c_FilialDe := STRTRAN(c_FilialDe,"/","")
		////
		//// Pesquisa o codigo do produto na estrutura da empresa origem. (falta definir se executa a copia pela empresa selecionada no acesso ao protheus.)
		////
		cQry  := "SELECT TOP 1 G1_COD,G1_COMP,G1_QUANT FROM SG1"+LEFT(c_FilialDe,3)
		cQry  += " WHERE D_E_L_E_T_ = ' '"
		cQry  += " AND G1_FILIAL = '"+x_FilialDe+"'"
		cQry  += " AND G1_COD = '"+c_Produto+"' "

		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMPSG1', .T., .T.)
		
		c_Componente := TMPSG1->G1_COMP
		
		TMPSG1->(dbCloseArea())

		IF ( EMPTY(c_Componente) )
			IF ( c_Tipo $ "PA,PI" )
				MsgInfo("Produto não cadastrado na Estrutura da Empresa Origem."+CHR(13)+CHR(10)+"Favor verificar o tipo desse produto!")
			ENDIF	
			lSG1Orig := .F.
		ELSE
			lSG1Dest    := .F.
			c_FilialPra := STRTRAN(c_FilialPra,"/","")
			////
			//// Pesquisa o codigo do produto na estrutura da empresa destino. (falta definir se executa a copia pela empresa selecionada no acesso ao protheus.)
			////
			cQry  := "SELECT TOP 1 G1_COD,G1_COMP,G1_QUANT FROM SG1"+LEFT(c_FilialPra,3)
			cQry  += " WHERE D_E_L_E_T_ = ' '"
			cQry  += " AND G1_FILIAL = '"+x_FilialPra+"'"
			cQry  += " AND G1_COD = '"+c_Produto+"' "

			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMPSG1', .T., .T.)
		
			c_Componente := TMPSG1->G1_COMP
		
			TMPSG1->(dbCloseArea())
		
			IF ( lSG1Orig )
				IF ( !EMPTY(c_Componente) )
					MsgInfo("Produto já se encontra cadastrado na Estrutura da Empresa Destino."+CHR(13)+CHR(10)+"Favor verificar!")
					lSG1Dest := .T.
				ENDIF	
			ENDIF
		ENDIF
	ENDIF
	
Return

//////////////////////////////////////////////////////
Static Function f_copystru()
//////////////////////////////////////////////////////
Local lResp,cQry,cMensagem
Local cCadastro   := ""
Local c_FilialDe  := LEFT(cEmprDe,5)
Local c_FilialPra := LEFT(cEmprPra,5)
Local c_ModoDe    := RIGHT(cEmprDe,1)

lResp := MsgBox("Confirma o processamento?","Escolha a opção","YESNO")

IF ( lResp )
	IF ( EMPTY(cProduto) .OR. EMPTY(cEmprDe) .OR. EMPTY(cEmprPra) .OR. ( !lChkBoxSB1 .AND. !lChkBoxSG1 ) )
		lResp := .F.
		MsgStop("Atenção!!! Falta informar parametros...")
	ELSE
		IF ( lFirstTime )
			lFirstTime := .F.
			aCols      := {}
		ENDIF
		c_ModoPra   := RIGHT(cEmprPra,1)
		c_FilialDe  := STRTRAN(c_FilialDe,"/","")
		c_FilialPra := STRTRAN(c_FilialPra,"/","")
		x_FilialDe  := IIF(c_ModoDe=="C" , SPACE(2) , RIGHT(c_FilialDe,2) )
		x_FilialPra := IIF(c_ModoPra=="C" , SPACE(2) , RIGHT(c_FilialPra,2) )
		IF ( lChkBoxSB1 )
			IF ( !lSB1Dest )
				////
				//// Pesquisa o codigo do produto na empresa origem para efetuar a copia pra empresa destino.
				////
				cQry := "SELECT * FROM SB1"+LEFT(c_FilialDe,3)
				cQry += " WHERE D_E_L_E_T_ = ' '"
				cQry += " AND B1_FILIAL = '"+x_FilialDe+"'"
				cQry += " AND B1_COD = '"+cProduto+"' "

				cQry := ChangeQuery(cQry)

				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMPSB1', .T., .T.)

				dbSelectArea("SB1")
				aSB1 := SB1->(Array(Fcount()))
				SB1->(AFields(aSB1))
			
				dbSelectArea("TMPSB1")
				dbGoTop()
				
				DBUSEAREA(.T.,"TOPCONN","SB1090","SB1090",.T.)
                TcCanOpen("SB1090","SB10901")
                ORDLISTADD("SB10901")
                
				DO WHILE !EOF()
					RecLock("SB1090",.T.)
					For ix := 1 to fCount()
						*
						dbSelectArea("TMPSB1")
						c_Campo    := Field(ix)
						c_Conteudo := FieldGet(ix)
						*
						dbSelectArea("SB1090")
						/*
						IF ( c_Campo == "B1_FILIAL" )
							FieldPut( Ascan(aSB1,c_Campo), x_FilialPra )						
						ELSEIF ( c_Campo == "B1_LOCPAD" )
							IF ( c_FilialPra $ "0101,0302" )
								FieldPut( Ascan(aSB1,c_Campo), "01" )						
							ELSE
								FieldPut( Ascan(aSB1,c_Campo), "02" )						
							ENDIF	
						ELSEIF ( c_Campo == "B1_X_DCR" .OR. c_Campo == "B1_X_FABRI" .OR. c_Campo == "B1_X_MRPAM" )
							FieldPut( Ascan(aSB1,c_Campo), " " )						
						ELSE
*/							FieldPut( Ascan(aSB1,c_Campo), c_Conteudo )
//						ENDIF
					Next
					MsUnlock()
					dbSelectArea("TMPSB1")
					dbSkip()
				ENDDO
				TMPSB1->(dbCloseArea())
				cCadastro := "B1"
			ELSE
				cCadastro := "B0"
			ENDIF	
		ENDIF	
		*
		
		dbSelectArea("SB1090")
        DbCloseArea()
        
		IF ( lChkBoxSG1 )
			IF ( lSG1Orig .AND. !lSG1Dest )
				////
				//// Pesquisa o codigo do produto na empresa origem para efetuar a copia pra empresa destino.
				////
				cQry  := "SELECT * FROM SG1"+LEFT(c_FilialDe,3)
				cQry  += " WHERE D_E_L_E_T_ = ' '"
				cQry  += " AND G1_FILIAL = '"+x_FilialDe+"'"
				cQry  += " AND G1_COD = '"+cProduto+"' "

				cQry := ChangeQuery(cQry)

				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMPSG1', .T., .T.)
		
				dbSelectArea("SG1")
				aSG1 := SG1->(Array(Fcount()))
				SG1->(AFields(aSG1))

				dbSelectArea("TMPSG1")
				dbGoTop()
				DO WHILE !EOF()
					RecLock("SG1",.T.)
					For ix := 1 to fCount()
						*
						dbSelectArea("TMPSG1")
						c_Campo    := Field(ix)
						c_Conteudo := FieldGet(ix)
						*
						dbSelectArea("SG1")
						IF ( c_Campo == "G1_FILIAL" )
							FieldPut( Ascan(aSG1,c_Campo), x_FilialPra )						
						ELSE
							FieldPut( Ascan(aSG1,c_Campo), c_Conteudo )
						ENDIF
					Next
					MsUnlock()
					dbSelectArea("TMPSG1")			
					dbSkip()
				ENDDO
				TMPSG1->(dbCloseArea())
				cCadastro += "G1"
			ELSE	
				cCadastro += "G0"
			ENDIF	
		ENDIF	
		*
		cMensagem := IIF( AT("1" , cCadastro) > 0 , "COPIA EFETUADA COM SUCESSO!" , "*** COPIA NAO EFETUADA ***" )
		cCadastro := IIF(cCadastro=="B1G1".OR.cCadastro=="B0G0" , "Produtos e Estruturas" , IIF(cCadastro $ "B1,B0" , "Produtos" , "Estruturas" ) )
		nx        := ( LEN(aCols) + 1 )
		nx        := STRZERO(nx,3)
		AADD(aCols , { nx                   , ;
							cProduto             , ;
							SUBS(cEmprDe,9,21)   , ;
							SUBS(cEmprPra,9,21)  , ;
							cCadastro            , ;
							cMensagem } )

		aSort(aCols,,, {|x,y| x[1] > y[1] } )
							
		cProduto    := SPACE(30)
		cDesc       := SPACE(200)
		cEmprDe     := SPACE(41)
		cEmprPra    := SPACE(41)
		n           := 1
		lChkBoxSB1  := .F.
		lChkBoxSG1  := .F.
		lSB1Dest    := .F.
		lSG1Dest    := .F.
		lSG1Orig    := .T.
		oEmprDe:SetFocus()
		oMulti:Refresh()
	ENDIF	
ENDIF

Return(lResp)