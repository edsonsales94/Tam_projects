#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CBARCALIB³ Autor ³ Carlos Nina           ³ Data ³ 28/07/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Codigo de Barras dos Produtos de Calibracao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Engenharia: validacao no banco de calibracao               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBARCALIB()

Local   aStru     := {}

Private oDlg,oMemo,oMark
Private lDigitado := .T.
Private lInverte  := .F.
Private cMarca    := GetMark()
Private aCampos   := {}
Private cProduto  := SPACE(10)
Private cTitulo   := "Gera codigo de barras para verificação do produto no banco de calibração."

AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_PRODUTO" , "C" , 30 , 0 } )
AADD(aStru,{"TB_DESC"    , "C" , 80 , 0 } )
AADD(aStru,{"TB_STRU"    , "C" , 03 , 0 } )
AADD(aStru,{"TB_OPER"    , "C" , 03 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)

AADD(aCampos , { "TB_OK"       , , "Ok"                     } )
AADD(aCampos , { "TB_PRODUTO"  , , "Produto"                } )
AADD(aCampos , { "TB_DESC"     , , "Descrição"              } )
AADD(aCampos , { "TB_STRU"     , , "Estrutura?"             } )
AADD(aCampos , { "TB_OPER"     , , "Operações?"             } )

dbSelectArea("SB1")
dbSetOrder(1)
*
dbSelectArea("SG1")
dbSetOrder(1)
*
dbSelectArea("TRB")

DEFINE MSDIALOG oDlg TITLE OemToAnsi(":::... GERA CODIGO DE BARRA P/VALIDAÇÃO NO BANCO DE CALIBRAÇÃO ...:::") FROM 000, 000  TO 522, 994 COLORS 0, 16777215 PIXEL   ///514

oTBar := TBar():New( oDlg,40,25,.T.,,,'tbar_coel',.F. )   ///40,25

@ 038,001 GROUP oGroup1 To 087,497 PROMPT OemToAnsi("Parametros")                     OF oDlg COLOR 0, 16777215 PIXEL
@ 089,001 GROUP oGroup1 To 255,497 PROMPT OemToAnsi("Seleção")                        OF oDlg COLOR 0, 16777215 PIXEL

@ 015,004 Say OemToAnsi("Digite o codigo do Produto e/ou os 3 primeiros digito do codigo do Modelo, ambos separados por ponto-e-virgula ( ; ).")	Size 700,7  OF oDlg COLOR CLR_HBLUE   PIXEL
@ 023,004 Say OemToAnsi("Ex.: B05EHRRRR----0MF--;P03S-BB--S01--;X34;B05;AD-;MT7;MT4") 		           	                                             Size 700,7  OF oDlg COLOR CLR_HBLUE   PIXEL
@ 044,006 Say OemToAnsi("Produto / Modelo")                          				Size 120,7  OF oDlg COLOR CLR_HBLUE PIXEL

@ 051,006 Get oMemo          Var  cProduto   MEMO                                Size 488,34 OF oDlg PIXEL WHEN lDigitado

oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{096,003,252,494},,oDlg)
//oMark:oBrowse:bldblclick := { || f_Mark(cMarca) }   

oTBmp1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
					{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
oTBmp2 := TBtnBmp2():New( 00, 00, 40, 70,'prtetq' , , , ,;
						{|| IIF(!lDigitado , f_printcbar() , nil ) }  ,oTBar,'Imprime codigo de barra',,.F.,.F.)
oTBmp3 := TBtnBmp2():New( 00, 00, 40, 70,'ok' , , , ,;
					{ || IIF(lDigitado , f_confirma() , nil ) }  ,oTBar,'Confirma parametros',,.F.,.F.)
oTBmp4 := TBtnBmp2():New( 00, 00, 40, 70,'cancel' , , , ,;
					{ || IIF(!lDigitado , f_cancela() , nil ) }  ,oTBar,'Limpa Grid de Seleção',,.F.,.F.)
oTBmp55 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
					{ || lSair := .T. , oDlg:End() }  ,oTBar,'Sair',,.F.,.F.)

Activate MsDialog oDlg Center Valid lSair

TRB->(dbCloseArea())

Return


//////////////////////////////////////////////////////////////////////////////
Static Function f_confirma()
//////////////////////////////////////////////////////////////////////////////
Local cQuery,xCod,mProd,mModelo
Local nz
Local mProd   := ""
Local mModelo := ""
Local cCods   := ""
Local cProds  := RTRIM(cProduto)+"  "
Local nw      := LEN(RTRIM(cProduto))+1
Local nx      := 1

DO WHILE !EMPTY(SUBS(cProds,nx,1))
	nz   := AT(";" , cProds )
	nz   := IIF(nz > 0 , nz , nw )
	xCod := SUBS(cProds,nx,(nz-nx))
	IF ( LEN(xCod) > 5 )
		mProd += IIF(EMPTY(mProd) , mProd , "," ) + xCod
	ELSE
		mModelo += IIF(EMPTY(mModelo) , mModelo , "," ) + xCod
	ENDIF
	cProds := STUFF(cProds , nz , 1 , ":" )
	nx += ( LEN(xCod) + 1 )
ENDDO
mProd   := STRTRAN(mProd,",",";")
mProd   := FormatIn (mProd , ";")
mModelo := STRTRAN(mModelo,",",";")
mModelo := FormatIn (mModelo , ";")

cQuery := "SELECT B1_COD,B1_DESC FROM " + RetSqlName("SB1")
cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "'"
cQuery += " AND D_E_L_E_T_ = ' '"
cQuery += " AND ( B1_COD  IN " + mProd + " OR LEFT(B1_COD,3) IN " + mModelo + " )"
cQuery += " AND LEN(B1_COD) > 5"
cQuery += " ORDER BY B1_COD "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	lSG2 := SG2->(dbSeek(xFilial("SG2")+TMP->B1_COD))
	lSG1 := SG1->(dbSeek(xFilial("SG1")+TMP->B1_COD))
	
	RecLock("TRB",.T.)
	TRB->TB_OK      := cMarca
	TRB->TB_PRODUTO := TMP->B1_COD
	TRB->TB_DESC    := TMP->B1_DESC
	TRB->TB_STRU    := IIF(!lSG1 , "Não" , "" )
	TRB->TB_OPER    := IIF(!lSG2 , "Não" , "" )
	MsUnlock()
	
	dbSelectArea("TMP")
	dbSkip()
	
ENDDO

TMP->(dbCloseArea())

dbSelectArea("TRB")
dbGoTop()

oMark:oBrowse:Refresh()

lDigitado := .F.

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_cancela()
//////////////////////////////////////////////////////////////////////////////

lDigitado := .T.

dbSelectArea("TRB")
__dbZap()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_printcbar()
//////////////////////////////////////////////////////////////////////////////

oPrn := TMSPrinter():New(cTitulo)
oPrn:Setup()

oPrn:SetPortrait() //Retrato
//oPrn:SetLandscape()// Paisagem()
//oPrn:StartPage()

RptStatus({|| f_codbar()})

oPrn:Preview()
oPrn:EndPage()
oPrn:End()

Return

/////////////////////////////////////////////////////////////////////////////////
Static Function f_Mark(cMarca)
/////////////////////////////////////////////////////////////////////////////////
Local lResp := .T.

IF ( lResp )
	RecLock("TRB",.F.)
	IF ( !EMPTY(TRB->TB_OK) )
		TRB->TB_OK := " "
	ELSE
		TRB->TB_OK := cMarca
	ENDIF
	MsUnlock()
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_codbar()
//////////////////////////////////////////////////////////////////////////////

// Definicao de fontes
oFont1 		:= TFont():New("Arial"      	   ,09,08,,.F.,,,,,.F.) //Titulos dos Campos
oFont2 		:= TFont():New("Arial"      	   ,09,10,,.F.,,,,,.F.) //Conteudo dos Campos
oFont3Bold	:= TFont():New("Arial Black"	   ,09,15,,.T.,,,,,.F.) //
oFont4 		:= TFont():New("Arial"      	   ,09,11,,.T.,,,,,.F.) //
oFont5 		:= TFont():New("Arial"      	   ,09,18,,.T.,,,,,.F.) //
oFont6 		:= TFont():New("Arial"      	   ,09,14,,.T.,,,,,.F.) //
oFont7 		:= TFont():New("Arial"           ,09,10,,.T.,,,,,.F.) //Conteudo dos Campos em Negrito
oFont8 		:= TFont():New("Arial"           ,09,09,,.F.,,,,,.F.) //Dados do Cliente
oFont9 		:= TFont():New("Times New Roman" ,09,14,,.T.,,,,,.F.) //

nSeq := 0
nLin := 1.3
dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
	IF ( !EMPTY(TRB->TB_OK).AND.EMPTY(TRB->TB_STRU).AND.EMPTY(TRB->TB_OPER) )
		nSeq++
		
		IF ( nSeq == 1 )
			cCod1 := STRTRAN(TRB->TB_PRODUTO,"-",".")
		ELSE
			cCod2 := STRTRAN(TRB->TB_PRODUTO,"-",".")
			MsBar("CODE128",nLin,02,alltrim(cCod1),oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
			MsBar("CODE128",nLin,13,alltrim(cCod2),oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
			cCod1 := cCod2 := ""
			nSeq  := 0
			nLin+=1.3
		ENDIF
		
		IF ( nLin > 20 )
			oPrn:EndPage()
			nLin := 1.3
		ENDIF
		
	ENDIF
	
	dbSkip()
	
ENDDO
IF ( nSeq == 1 )
	MsBar("CODE128",nLin,02,alltrim(cCod1),oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
ENDIF

MS_FLUSH()

TRB->(dbGoTop())
oMark:oBrowse:SetFocus()

Return