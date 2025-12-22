#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE APSWDET_USER_PWD			aPswDet[01][03]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CESTC130  ³ Autor ³ Carlos Nina           ³ Data ³09/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Analise de alteracoes na Carteira de Vendas.               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Definido com  Francisco/Teddy em 01/09/2015                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CESTC130()

Local oTBar,oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oGroup7,oChange,oLAlt,oLExc
Local oASUser,oASNome,oASSenha
Local oTBitmap1,oTBitmap2,oTBitmap3,oTBmp1,oTBmp2
Local oAProduto,oAQtdVen,oAPrcVen,oAEntrega,oAOP,oACF
Local oStA,oStB,oStC,oStD,oStE,oStF
Local cQuery
Local aGrp
Local _aArea := GetArea()
Local aUsers := AllUsers()

Private _oDlg		      	                         	          ///Dialog Principal
Private oAGUser,oAGNome,oAGSenha,oAtualiza
Private lBrowse,lAdmin
Private aCols
Private cAtualiza,cCompara,cAPassw,cAUser,cANome,cASenha
Private nAcao

Private lLooping := .T.
Private lSaida   := .F.
Private aRet     := FwTimeUF("AM")                              ///aRet[1] = 20140227  ; aRet[2] = 17:32:33		
Private cHora    := LEFT(STRTRAN(aRet[2],":",""),4)
Private aAcao    := {"Atualizar","Comparar"}
Private mvLocPad := IIF(M->cNumEmp=="0301","02","01")    
Private cEmpresa := RetSqlName("SC6")
Private cTempor  := "ZZ6"+SUBS(cEmpresa,4,3)

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')

DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt1 NAME "Arial"				SIZE 0, -12 BOLD	// "Times New Roman" Menor
DEFINE FONT 	oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor
DEFINE FONT 	oFnt5 NAME "Arial"				SIZE 0, -26 BOLD	// "Times New Roman" Maior

dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
dbSelectArea("SC6")
dbSetOrder(1)
////
////Verifica se o usuario faz parte do Grupo de usuarios para executar esta rotina
////
nX     := ASCAN(aUsers , { |x| x[1,1] == M->__cUserID } )
aGrp   := ACLONE(aUsers[nX,1,10])
nW     := ASCAN(aGrp , "000000" )                              ////Grupo Administradores
lAdmin := ( nW > 0 )

DO WHILE lLooping

	cQuery := "SELECT TOP 1 * FROM "+cTempor+" "

	IF ( TCSQLExec(cQuery) < 0 )
		cAtualiza := SPACE(22)
	ELSE	
		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP', .T., .T.)

		cAtualiza := TMP->ZZ6_DATA

		TMP->(dbCloseArea())
	ENDIF
	
	lBrowse   := .F.
	aCols 	 := { {"0","","","","","","","","","","","","","","","","","","",""} }
	cAUser    := IIF(lAdmin , M->__cUserId , Space(8) )
	cANome    := IIF(lAdmin , M->cUserName , Space(15) )
	cASenha   := IIF(lAdmin , "9999" , Space(4) )
	nAcao     := 1
	dEmissao  := ddatabase
	cProduto  := SPACE(30)
	nQtdVen   := 0
	nPrcVen   := 0
	cEntrega  := SPACE(8)
	cOP       := SPACE(9)
	cCF       := SPACE(5)	

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi(":::... Consulta de Alterações na Carteira de Vendas ...:::") FROM 000,000 TO 530,984 COLORS 0, 16777215 PIXEL  

	oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   

	@ 015, 001 GROUP oGroup1 TO 047, 228 PROMPT "IDENTIFICAÇÃO"            						  			  OF _oDlg COLOR  0, 16777215 		 PIXEL 
	@ 015, 236 GROUP oGroup2 TO 058, 444 PROMPT "PARAMETROS"               						  			  OF _oDlg COLOR  0, 16777215 		 PIXEL
	@ 023, 239 GROUP oGroup3 TO 055, 312 PROMPT "AÇÃO"                      		  			  			  OF _oDlg COLOR  16744448, 16777215 PIXEL 
	@ 073, 001 GROUP oGroup4 TO 230, 490 PROMPT "POSIÇÃO ANTERIOR"                 			  			  OF _oDlg COLOR  0, 16777215 		 PIXEL 
	@ 048, 001 GROUP oGroup5 TO 072, 064 PROMPT "LEGENDA"                  						  			  OF _oDlg COLOR  0, 16777215 		 PIXEL
	@ 048, 068 GROUP oGroup6 TO 073, 228 PROMPT "STATUS"                   						  			  OF _oDlg COLOR  0, 16777215 		 PIXEL
	@ 231, 001 GROUP oGroup4 TO 262, 490 PROMPT "POSIÇÃO ATUAL"                    			  			  OF _oDlg COLOR  0, 16777215 		 PIXEL 

	@ 022, 004 SAY   oASUser		PROMPT  "Usuário"                							SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 022, 066 SAY   oASNome   	PROMPT  "Nome"                   							SIZE 040, 009 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt2
	@ 022, 184 SAY   oASSenha  	PROMPT  "Senha"                  							SIZE 040, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 031, 004 MSGET oAGUser      VAR     cAUser        PICTURE "@R 99999999"				SIZE 040, 010 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt3  Valid(_fVlDlg("MATR",cAUser))
	@ 031, 066 MSGET oAGNome   	VAR     cANome                     							SIZE 110, 010 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt   WHEN .F.
	@ 031, 184 MSGET oAGSenha  	VAR     cASenha       PASSWORD     							SIZE 040, 010 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt   Valid(_fVlDlg("APASSW",cASenha))

	@ 024, 320 SAY   oChange  	   PROMPT  "Última Atualização"      							SIZE 120, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 033, 320 MSGET oAtualiza		VAR     cAtualiza                              			SIZE 120, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   WHEN .F.
	
	@ 238, 006 SAY   oAProduto    PROMPT  "Produto"                                     SIZE 050, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	@ 238, 141 SAY   oAQtdVen     PROMPT  "Quantidade"                                  SIZE 050, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	@ 238, 212 SAY   oAPrcVen     PROMPT  "Preço"                                       SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	@ 238, 282 SAY   oAEntrega    PROMPT  "Entrega"                                     SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	@ 238, 352 SAY   oAOP         PROMPT  "O.P."                                        SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	@ 238, 424 SAY   oACF         PROMPT  "C.F."                                        SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	@ 247, 006 MSGET oProduto     VAR     cProduto                                      SIZE 120, 010 OF _oDlg COLOR  CLR_HRED           PIXEL Font oFnt2  WHEN .F.
	@ 247, 141 MSGET oQtdVen      VAR     nQtdVen                                       SIZE 060, 010 OF _oDlg COLOR  CLR_HRED           PIXEL Font oFnt2  WHEN .F.
	@ 247, 212 MSGET oPrcVen      VAR     nPrcVen                                       SIZE 060, 010 OF _oDlg COLOR  CLR_HRED           PIXEL Font oFnt2  WHEN .F.
	@ 247, 282 MSGET oEntrega     VAR     cEntrega                                      SIZE 060, 010 OF _oDlg COLOR  CLR_HRED           PIXEL Font oFnt2  WHEN .F.
	@ 247, 352 MSGET oOP          VAR     cOP                                           SIZE 060, 010 OF _oDlg COLOR  CLR_HRED           PIXEL Font oFnt2  WHEN .F.
	@ 247, 424 MSGET oCF          VAR     cCF                                           SIZE 050, 010 OF _oDlg COLOR  CLR_HRED           PIXEL Font oFnt2  WHEN .F.

	oTBmp1 := TBitmap():Create(_oDlg,054,004,14,14,,'br_verde',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	  
	oTBmp1:lAutoSize := .T.
	@ 054, 014 SAY   oLAlt        PROMPT  OemToAnsi("Alteração")                        SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2
	oTBmp2 := TBitmap():Create(_oDlg,063,004,14,14,,'br_vermelho',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	  
	oTBmp2:lAutoSize := .T.
	@ 063, 014 SAY   oLExc        PROMPT  OemToAnsi("Exclusão")                         SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt2

	@ 055, 071 SAY   oStA         PROMPT  OemToAnsi("A=Produto")                        SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt1
	@ 063, 071 SAY   oStB         PROMPT  OemToAnsi("B=Quantidade")                     SIZE 050, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt1
	@ 055, 130 SAY   oStC         PROMPT  OemToAnsi("C=Preço")                          SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt1
	@ 063, 130 SAY   oStD         PROMPT  OemToAnsi("D=Entrega")                        SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt1
	@ 055, 180 SAY   oStE         PROMPT  OemToAnsi("E=O.P.")                           SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt1
	@ 063, 180 SAY   oStF         PROMPT  OemToAnsi("F=C.F.")                           SIZE 040, 010 OF _oDlg COLOR  CLR_HBLUE          PIXEL Font oFnt1
	
	oAcao := TRadMenu():New (031,242,aAcao,,_oDlg,,,,,,,,036,014,,,,.T.)
	oAcao:bSetGet := {|u1|Iif (PCount()==0,nAcao,nAcao:=u1)} 
		
	oTBitmap4 := TBtnBmp2():New( 030, 914, 70, 30,'conf_coel',,,,;      
						{ || f_confirma() }  ,_oDlg,OemToAnsi('Processa Consulta'),,.F.,.F.)
	oTBitmap5 := TBtnBmp2():New( 064, 914, 70, 30,'canc_coel',,,,;   
						{ || f_cancela() } , _oDlg,OemToAnsi('Cancela a Consulta'),,.F.,.F.)

	oBrowse := TCBrowse():New( 081 , 004, 484, 144,,{"","STATUS","PEDIDO","PRODUTO","DESCRIÇÃO","QUANT.","PREÇO","ENTREGA","O.P","C.F.","USUARIO"},{10,30,30,60,110,36,40,36,30,20,45},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oBrowse:SetArray(aCols)
	oBrowse:bChange := { || f_alteracao(oBrowse:nAt) }  
	oBrowse:bLine   := { || { IIF(aCols[oBrowse:nAt,1]=="1",oVd,oVm) , ;
											aCols[oBrowse:nAt,2]  , ;
											aCols[oBrowse:nAt,3]  , ;
											aCols[oBrowse:nAt,4]  , ;
											aCols[oBrowse:nAt,5]  , ;
											aCols[oBrowse:nAt,6]  , ;
											aCols[oBrowse:nAt,7]  , ;
											aCols[oBrowse:nAt,8]  , ;
											aCols[oBrowse:nAt,9]  , ;
											aCols[oBrowse:nAt,10] , ;
											aCols[oBrowse:nAt,11] } }
	oBrowse:lAdjustColsize := .F.

	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70,'pmsexcel' , , , ,;
							{|| f_prtmov() }  ,oTBar,'Impressão do movimento interno',,.F.,.F.)					
	oTBitmap3 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || f_Saida() }  ,oTBar,'Sair',,.F.,.F.)

	IF ( lAdmin )
		oAGUser:Disable()
		oAGSenha:Disable()
	ENDIF	
						
	ACTIVATE MSDIALOG _oDlg CENTER VALID lSaida

ENDDO
	
Return

///////////////////////////////////////////////////////////
Static Function f_Saida()
///////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(aCols[1,3]) )

	lRsp := MsgBox("Deseja realmente sair da Rotina?","Escolha a opção","YESNO")
	
ENDIF

IF ( lRsp )
	lSaida   := .T.
	lLooping := .F.
	_oDlg:End()
ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_confirma()
//////////////////////////////////////////////////////////////////////////////
Local nX
Local cTime
Local cQry,cArqInd,cChave
Local lRsp := .T.

IF ( !oAcao:lActive )
	Return
ENDIF
	
IF ( nAcao == 1 )
	
	IF ( !EMPTY(cAtualiza) )
		lRsp := MsgBox("Confirma a Atualização da Consulta?","Escolha a opção","YESNO")	
	   IF ( lRsp )
			cQry := "DROP TABLE "+cTempor+" "
			IF ( TCSQLExec(cQry) < 0 )
				MsgAlert(TCSQLError())
				Return
			ENDIF	
			INKEY(2)
		ENDIF
	ENDIF

	IF ( lRsp )
		
		cQry := "DECLARE @DATA VARCHAR(10) "
		cQry += "DECLARE @HORA VARCHAR(22) "
		cQry += "DECLARE @DTHR VARCHAR(22) "
		cQry += "SET @DATA = CONVERT(char(10), GETDATE(), 103) "
		cQry += "SET @HORA = switchoffset (CONVERT(datetimeoffset, GETDATE(), 108),'-01:00') "
		cQry += "SET @DTHR = @DATA + ' as ' + SUBSTRING(@HORA,12,8) "

		cQry += "SELECT C6_NUM ZZ6_NUM,C6_ITEM ZZ6_ITEM,C6_PRODUTO ZZ6_PRODUT,C6_DESCRI ZZ6_DESCRI,C6_QTDVEN ZZ6_QTDVEN,C6_QTDENT ZZ6_QTDENT,C6_PRCVEN ZZ6_PRCVEN,C6_DATFAT ZZ6_DATFAT,C6_NOTA ZZ6_NOTA,"
		cQry += "C6_ENTREG ZZ6_ENTREG,C6_CF ZZ6_CF,C6_NUMOP ZZ6_NUMOP,C6_ITEMOP ZZ6_ITEMOP,C6_USERLGA ZZ6_USERLA,C6_USERLGI ZZ6_USERLI,C6.R_E_C_N_O_ ZZ6_RECNO,@DTHR ZZ6_DATA "
		cQry += "INTO "+cTempor+" FROM "+cEmpresa+" C6,"+RetSqlName("SB1")+" B1 "
		cQry += "WHERE C6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+xFilial("SC6")+"' "
		cQry += "AND C6_QTDVEN > C6_QTDENT AND C6_CF IN ('5101','5102','5107','5109','5401','5405','5901','6101','6102','6107','6109','6401','6405','6905','7101','7102','7107') "
		cQry += "AND B1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND B1_TIPO = 'PA' "
		cQry += "ORDER BY C6_NUM,C6_ITEM "
		
		IF ( TCSQLExec(cQry) < 0 ) 
			MsgAlert(TCSQLError())
			Return
		ENDIF	
		
		cQry := "SELECT TOP 1 * FROM "+cTempor+" "

		IF ( TCSQLExec(cQry) < 0 )
			cAtualiza := SPACE(22)
		ELSE	
			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

			cAtualiza := TMP->ZZ6_DATA
			
			oAtualiza:Refresh()

			TMP->(dbCloseArea())
		ENDIF
		
	ENDIF
		
ELSEIF ( !EMPTY(cAtualiza) )
	
	////
	////Abre arquivo de trabalho
	////
	cQry := "SELECT * FROM "+cTempor+" ZZ6 "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP1', .T., .T.)

	TcSetField("TMP1","ZZ6_ENTREG","D",08,0)
	TcSetField("TMP1","ZZ6_QTDVEN","N",14,2)
	TcSetField("TMP1","ZZ6_QTDENT","N",14,2)
	TcSetField("TMP1","ZZ6_PRCVEN","N",14,4)
	TcSetField("TMP1","ZZ6_RECNO","N",7,0)

	/*
	////
	////Abre arquivo da carteira para analise com o arquivo de trabalho
	////
	cQry  := "SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,"
	cQry  += "C6_ENTREG,C6_CF,C6_NUMOP,C6_ITEMOP,C6_USERLGA,C6_USERLGI,C6.R_E_C_N_O_ C6_RECNO "
	cQry  += "FROM "+cEmpresa+" C6 "
	cQry  += "WHERE C6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+xFilial("SC6")+"' "
	cQry  += "AND C6_QTDVEN > C6_QTDENT "
	cQry  += "ORDER BY C6_NUM,C6_ITEM "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP2', .T., .T.)

	TcSetField("TMP2","C6_ENTREG","D",08,0)
	TcSetField("TMP2","C6_DATFAT","D",08,0)
	TcSetField("TMP2","C6_QTDVEN","N",10,2)
	TcSetField("TMP2","C6_QTDENT","N",10,2)
	TcSetField("TMP2","C6_PRCVEN","N",14,4)
	TcSetField("TMP2","C6_RECNO","N",7,0)
			
	cArqInd := CriaTrab(Nil,.F.)
	cChave := "STRZERO(C6_RECNO,7)"
	IndRegua("TMP2",cArqInd,cChave,,,"Indexando Registros...")			
	*/
	
	aCols := {}
	dbSelectArea("TMP1")
	dbGoTop()
	DO WHILE TMP1->(!EOF())
		SET DELE ON
		SC6->(dbGoTo(TMP1->(ZZ6_RECNO)))
		cLegenda := IIF(SC6->(DELETED()) , "0" , "1" )
		IF ( !EMPTY(SC6->C6_USERLGA) )
			cUserA := FWLeUserlg("C6_USERLGA")
			cDataA := FWLeUserlg("C6_USERLGA", 2)
		ELSE
			cUserA := FWLeUserlg("C6_USERLGI")
			cDataA := FWLeUserlg("C6_USERLGI", 2)
		ENDIF
		cStatus  := ""
		cProduto := SPACE(30)
		cDescri  := SPACE(60)
		nQtdVen  := 0
		nPrcVen  := 0
		cEntrega := SPACE(8)
		cOP      := SPACE(9)
		cCF      := SPACE(5)	
		IF ( cLegenda <> "0" )	
			/*		
		   cStatus := IIF(TMP1->ZZ6_PRODUT <> SC6->C6_PRODUTO , "A" , cStatus )
			cStatus := IIF(TMP1->ZZ6_QTDVEN <> SC6->C6_QTDVEN  , IIF(!EMPTY(cStatus) , "+B" , "B" ) , cStatus )
			cStatus := IIF(TMP1->ZZ6_PRCVEN <> SC6->C6_PRCVEN  , IIF(!EMPTY(cStatus) , "+C" , "C" ) , cStatus )
			cStatus := IIF(TMP1->ZZ6_ENTREG <> SC6->C6_ENTREG  , IIF(!EMPTY(cStatus) , "+D" , "D" ) , cStatus )
			cStatus := IIF(TMP1->(ZZ6_NUMOP+ZZ6_ITEMOP) <> SC6->(C6_NUMOP+C6_ITEMOP) , IIF(!EMPTY(cStatus) , "+E" , "E" ) , cStatus )
			cStatus := IIF(TMP1->ZZ6_CF     <> SC6->C6_CF      , IIF(!EMPTY(cStatus) , "+F" , "F" ) , cStatus )
			*/
		   IF ( TMP1->ZZ6_PRODUT <> SC6->C6_PRODUTO )
				cStatus  := "A"
				cProduto := SC6->C6_PRODUTO
				cDescri  := SC6->C6_DESCRI
			ENDIF	
			IF ( TMP1->ZZ6_QTDVEN <> SC6->C6_QTDVEN )
				cStatus := IIF(!EMPTY(cStatus) , "+B" , "B" )
				nQtdVen := SC6->C6_QTDVEN
			ENDIF	
			IF ( TMP1->ZZ6_PRCVEN <> SC6->C6_PRCVEN )
				cStatus := IIF(!EMPTY(cStatus) , "+C" , "C" )
				nPrcVen := SC6->C6_PRCVEN
			ENDIF	
			IF ( TMP1->ZZ6_ENTREG <> SC6->C6_ENTREG )
				cStatus  := IIF(!EMPTY(cStatus) , "+D" , "D" ) 
				cEntrega := DTOC(SC6->C6_ENTREG)
			ENDIF	
			IF ( TMP1->(ZZ6_NUMOP+ZZ6_ITEMOP) <> SC6->(C6_NUMOP+C6_ITEMOP) )
				cStatus := IIF(!EMPTY(cStatus) , "+E" , "E" )
				cOP     := SC6->C6_NUMOP+"-"+SC6->C6_ITEMOP
			ENDIF	
			IF ( TMP1->ZZ6_CF <> SC6->C6_CF )
				cStatus := IIF(!EMPTY(cStatus) , "+F" , "F" )
				cCF     := SC6->C6_CF
			ENDIF	
		ENDIF	  
		SET DELE OFF		
		IF ( cLegenda == "0" .OR. !EMPTY(cStatus) )
			AADD(aCols , { cLegenda         , ;
								cStatus          , ;
								TMP1->ZZ6_NUM+"/"+TMP1->ZZ6_ITEM   , ;
								TMP1->ZZ6_PRODUT , ;
								TMP1->ZZ6_DESCRI , ;
								TMP1->ZZ6_QTDVEN , ;
								TMP1->ZZ6_PRCVEN , ;
								TMP1->ZZ6_ENTREG , ;
								TMP1->ZZ6_NUMOP+"-"+TMP1->ZZ6_ITEMOP , ;
								TMP1->ZZ6_CF     , ;
								RTRIM(cUserA)+" -- "+cDataA  , ;
								cProduto   , ;
								cDescri    , ;
								nQtdVen    , ;
								nPrcVen    , ;
								cEntrega   , ;
								cOP        , ;
								cCF        , ;
								cUserA     , ;
								cDataA } )
		ENDIF						

		TMP1->(dbSkip())
		
	ENDDO
	
	TMP1->(dbCloseArea())
	
	IF ( LEN(aCols) == 0 )
		aCols := { {"0","","","","","","","","","","","","","","","","","","",""} }		
	ENDIF
	
	cTime    := LEFT(FwTimeUF("AM",,.F.)[2],5)              
	cCompara := DTOC(MsDate())+" as "+cTime
	cProduto := aCols[1,12]	
	nQtdVen  := aCols[1,13]	
	nPrcVen  := aCols[1,14]	
	cEntrega := aCols[1,15]	
	cOP      := aCols[1,16]	
	cCF      := aCols[1,17]	

	oProduto:Refresh()
	oQtdVen:Refresh()
	oPrcVen:Refresh()
	oEntrega:Refresh()
	oOP:Refresh()
	oCF:Refresh()	
	
	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,oVm) , ;
								  aCols[oBrowse:nAt,2]  , ;
								  aCols[oBrowse:nAt,3]  , ;
								  aCols[oBrowse:nAt,4]  , ;
								  aCols[oBrowse:nAt,5]  , ;
								  aCols[oBrowse:nAt,6]  , ;
								  aCols[oBrowse:nAt,7]  , ;
								  aCols[oBrowse:nAt,8]  , ;
								  aCols[oBrowse:nAt,9]  , ;
								  aCols[oBrowse:nAt,10] , ;
								  aCols[oBrowse:nAt,11] } }
	oBrowse:lAdjustColsize := .F.
	oBrowse:Refresh()
	oAcao:Disable()
	
ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_cancela()
///////////////////////////////////////////////////////////

cProduto := SPACE(30)
nQtdVen  := 0
nPrcVen  := 0
cEntrega := SPACE(8)
cOP      := SPACE(9)
cCF      := SPACE(5)	
aCols    := { {"0","","","","","","","","","","","","","","","","","","",""} }		

oProduto:Refresh()
oQtdVen:Refresh()
oPrcVen:Refresh()
oEntrega:Refresh()
oOP:Refresh()
oCF:Refresh()	

oBrowse:SetArray(aCols)
oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,oVm) , ;
							  aCols[oBrowse:nAt,2]  , ;
							  aCols[oBrowse:nAt,3]  , ;
							  aCols[oBrowse:nAt,4]  , ;
							  aCols[oBrowse:nAt,5]  , ;
							  aCols[oBrowse:nAt,6]  , ;
							  aCols[oBrowse:nAt,7]  , ;
							  aCols[oBrowse:nAt,8]  , ;
							  aCols[oBrowse:nAt,9]  , ;
							  aCols[oBrowse:nAt,10] , ;
							  aCols[oBrowse:nAt,11] } }
oBrowse:lAdjustColsize := .F.
oBrowse:Refresh()
oAcao:Enable()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_alteracao(nItem)
///////////////////////////////////////////////////////////////////////

cProduto := aCols[nItem,12]	
nQtdVen  := aCols[nItem,14]	
nPrcVen  := aCols[nItem,15]	
cEntrega := aCols[nItem,16]	
cOP      := aCols[nItem,17]	
cCF      := aCols[nItem,18]	

oProduto:Refresh()
oQtdVen:Refresh()
oPrcVen:Refresh()
oEntrega:Refresh()
oOP:Refresh()
oCF:Refresh()

Return

///////////////////////////////////////////////////////////
Static Function f_prtmov()
///////////////////////////////////////////////////////////
Local oExcelApp
Local cProduto,cAno,cExt,dxData
Local mLinDet,cLinDet,c_User,c_Tp
Local aLinhas,aRows
Local nW         := 1
Local oExcel     := FWMSEXCEL():New()
Local cWorkSheet := "PEDIDOS"

IF ( EMPTY(aCols[1,3]) )
	Return
ENDIF
	
cRelato := "CESTC130"

cLinDet := "CONSULTA DE ALTERAÇÕES DA CARTEIRA DE VENDAS - POSIÇÃO ANTERIOR: "+cAtualiza+" - POSIÇÃO ATUAL: "+cCompara

oExcel:AddworkSheet(cWorkSheet)
oExcel:AddTable (cWorkSheet,cLinDet)
oExcel:AddColumn(cWorkSheet,cLinDet,"PEDIDO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"PRODUTO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"DESCRIÇÃO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"QUANT.",3,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"PREÇO",3,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"ENTREGA",1,1)                                        ///Alinhamento da coluna [3] - ( 1-Left,2-Center,3-Right )
oExcel:AddColumn(cWorkSheet,cLinDet,"O.P.",1,1)                                           ///Codigo de formatação  [2] - ( 1-General,2-Number,3-Monetário,4-DateTime )
oExcel:AddColumn(cWorkSheet,cLinDet,"C.F",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"USUARIO",1,1)
*********************************************

Do While nW <= LEN(aCols)
	c_Tp    := IIF(aCols[nW,1]=="0" , "EXCLUSÃO" , "ALTERAÇÃO" )
	aRows   := { c_Tp                  , ;
					 aCols[nW,3]           , ;
					 aCols[nW,4]           , ;
					 aCols[nW,5]           , ;
					 aCols[nW,6]           , ;
					 aCols[nW,7]           , ;
					 aCols[nW,8]           , ;
					 aCols[nW,9]           , ;
					 aCols[nW,10]          , ;
					 aCols[nW,11]  }
	
	oExcel:AddRow(cWorkSheet,cLinDet,aRows)

	c_User := aCols[nW,19]+" as "+aCols[nW,20]
	aRows   := { SPACE(10)             , ;
					 aCols[nW,12]          , ;
					 aCols[nW,13]          , ;
					 aCols[nW,14]          , ;
					 aCols[nW,15]          , ;
					 aCols[nW,16]          , ;
					 aCols[nW,17]          , ;
					 aCols[nW,18]          , ;
					 c_User        }

	oExcel:AddRow(cWorkSheet,cLinDet,aRows)
					 
	nW++
			
Enddo
oExcel:Activate()
oExcel:GetXMLFile("C:\RELATO\"+cRelato)
oExcel:DeActivate()

///
///Abre o Excel
///

If ! ApOleClient( 'MsExcel' )                                                 //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf

oExcelApp := MsExcel():New()                                                  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open("C:\Relato\"+cRelato)               						// Atribui à propriedade WorkBooks do Excel
oExcelApp:SetVisible(.T.)                                                     // Abre o Excel com o arquivo criado exibido na Primeira planilha.
oExcelApp:Destroy()                                                           //Encerra o processo do gerenciador de tarefas

Return

////////////////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_cTipo,_xConteudo)
////////////////////////////////////////////////////////////////////////////////////
Local cAutoriza,CPNUM,x_Barra,x_OP
Local _lRet	 := .t. 
Local _nX    := 0

IF ( lBrowse )
	lBrowse := .F.
	Return
ENDIF
	
Do Case

	Case Upper(Alltrim(_cTipo)) == "TMOV"                                           ////Selecionando o tipo do movimento:Sao Paulo-Scrape-Defeito-Falta-Transferencia-Outros
	
		IF ( _xConteudo == 5 )
			oCodigo:Hide()
			oPrd:Hide()
			oProduto:Hide()
			oNumOP:Hide()
			oOP:Hide()
			oCodOri:Show()
			oProdOri:Show()
			oCodDest:Show()
			oProdDest:Show()
		ELSE	
			IF oCodOri:lActive                 ///lVisible
				oCodOri:Hide()
				oProdOri:Hide()
				oCodDest:Hide()
				oProdDest:Hide()
				oCodigo:Show()
				oNumOP:Show()
				lBrowse := .T.
				oProduto:Show()
				lBrowse := .T.
				oOP:Show()
				
				cProdDest := Space(30)
			ENDIF	
			IF ( _xConteudo == 1 .OR. _xConteudo == 6 )
				cOP      := SPACE(8)		
				mOP      := cOP
				aEmpenho := {SPACE(130)}
				lBrowse  := .T.
				oPrd:SetItems(aEmpenho) 
				oOP:Disable()
				oPrd:Hide()
				lBrowse := .T.
				oProduto:Show()
			ELSE
				lBrowse := .T.
				oOP:Enable()
			ENDIF
		ENDIF

		oEmissao:SetFocus()
		
	Case Upper(Alltrim(_cTipo)) == "MATR"
	
		IF ( !EMPTY(_xConteudo) )
			x_Barra    := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
			_xConteudo := IIF(x_Barra == "99" , SUBSTRING(_xConteudo,2,6) , RTRIM(_xConteudo) )
			_xConteudo := STRZERO( VAL(ALLTRIM(_xConteudo)) , 6 )
			
			dbSelectArea("SX5")
			dbSetOrder(1)
			dbSeek(xFilial("SX5")+"Z@"+_xConteudo)
			IF ( SX5->(EOF()) )
				IF ( x_Barra <> "99" )
					MsgStop("Erro de leitura no Codigo de Barras do Crachá.")
				ELSE	
					MsgStop("Usuário não autorizado para executar esta rotina.","Atenção")
				ENDIF	
				_lRet := .f.	
			ELSE
				cANome    := SUBS(SX5->X5_DESCRI,8,10)
				cAutoriza := SUBS(SX5->X5_DESCRI,5,1)
				IF ( ! cAutoriza $ "TZ" )
					MsgStop(OemToAnsi("Usuário ")+RTRIM(cANome)+OemToAnsi(" sem permissão para executar esta rotina."),OemToAnsi("Atenção"))
					Return(.F.)
				ENDIF
			
				dbSelectArea("SRA")
				dbSetOrder(1)
				dbSeek(xFilial("SRA")+_xConteudo)
			
				cAPassw := SUBSTRING(SRA->RA_CIC,10,2)+SUBSTRING(SRA->RA_CIC,1,2)
				oAGSenha:SetFocus()
			ENDIF
		ENDIF

	Case Upper(Alltrim(_cTipo)) == "APASSW"
		
		IF ( !EMPTY(_xConteudo) )
			IF ( _xConteudo <> cAPassw )
				MsgStop(OemToAnsi("Usuário ")+RTRIM(cANome)+OemToAnsi(" sem permissão para executar esta rotina."),OemToAnsi("Senha Não Confere!"))
				_lRet := .f.
			ELSE
				oAGUser:Disable()
				oAGSenha:Disable()
			ENDIF
		ENDIF
		
EndCase

Return(_lRet)

User Function GALH0002()           ///CESTC130()

RETURN