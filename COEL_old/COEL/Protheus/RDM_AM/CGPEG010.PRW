/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CGPEG010 º Autor ³ Carlos Nina        º Data ³  03/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Gera Verba Fixa para calculo da Folha                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ R.H.                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "protheus.ch"     
#include "rwmake.ch"  
#include "totvs.ch"
#include "colors.ch"
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

User Function CGPEG010()        

SetPrvt("ACOLS,CARQ,CXARQ,LRESP,OMARK,OBROWSE,OGROUP1,OGRUOUP2,OBUTTON1,OBUTTON2,OBUTTON3,OBUTTON4,OVERBA,ODATA,OTOTAIS,OFNT,OEXCLUSIVO,OFILE,OVALOR")

dbSelectArea("SRA")
dbSetOrder(1)
*
dbSelectArea("SRV")
dbSetOrder(1)
*
dbSelectArea("SX5")
dbSetOrder(1)
*
aStru := {}
AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_MAT"     , "C" , 06 , 0 } )
AADD(aStru,{"TB_NOME"    , "C" , 30 , 0 } )
AADD(aStru,{"TB_VALOR"   , "N" , 11 , 2 } )
AADD(aStru,{"TB_SIT"     , "C" , 15 , 0 } )
AADD(aStru,{"TB_CC"      , "C" , 09 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
*
nMaskDef	 := 1 								// Mascara .TXT
cTipo     := "Marcação (*.CSV)        | *.CSV | "
cTipo     := cTipo + "Todos os Arquivos (*.*)   | *.*     "
cxPath    := "C:\"
cArq      := ""
cDescri   := ""
cPlanilha := SPACE(40)
c_ArqRel  := "@@@@@@@@@"
nValor    := 0
cVerba    := SPACE(3)
dDatProc  := CTOD("")
cTotais   := ""
nTtlSel   := 0
cDatFech  := GETMV("MV_FOLMES")
cMarca    := GetMark()
lInverte  := .T.
lSair     := .F.
lGerar    := .F.
aCampos   := {}
AADD(aCampos , { "TB_OK"      ,                    , "Ok"           } )
AADD(aCampos , { "TB_MAT"     ,                    , "MATRICULA"    } )
AADD(aCampos , { "TB_NOME"    ,                    , "NOME"         } )
AADD(aCampos , { "TB_VALOR"   , "@E 999,999.99"    , "     VALOR"   } )
AADD(aCampos , { "TB_CC"      ,                    , "C.CUSTO"      } )
AADD(aCampos , { "TB_SIT"     ,                    , "SITUAÇAO"     } )
*
DEFINE MSDIALOG oDlg TITLE "Folha de Pagamento: Geração de verba fixa para Folha de Pagto." FROM 000, 000  TO 540, 810 OF oMainWnd           COLORS 0, 16777215           PIXEL

DEFINE FONT oFnt  NAME "Arial" Size 10,14             ///LARG. X ALT.
DEFINE FONT oFnt2 NAME "Arial" Size 10,16             ///LARG. X ALT.

@ 004,003 GROUP oGroup1 TO 056,230 PROMPT "Parametros"                                       OF oDlg               COLOR 0, 16777215        PIXEL
@ 060,003 GROUP oGroup2 TO 250,405 PROMPT "Lançamentos"                                      OF oDlg               COLOR 0, 16777215        PIXEL
@ 006,240 SAY oExclusivo PROMPT OemToAnsi("*** Exclusivo para Coelmatic ***")    Size 380,12 OF oDlg  FONT oFnt2   COLOR 256, 16777215      PIXEL
@ 014,008 Say OemToAnsi("Verba")                                                 Size 40,10  OF oDlg                                        PIXEL
@ 027,008 Say OemToAnsi("Valor")                                                 Size 40,10  OF oDlg                                        PIXEL
@ 027,110 Say OemToAnsi("Data")                                                  Size 40,10  OF oDlg                                        PIXEL
@ 042,008 Say OemToAnsi("Planilha")                                              Size 50,10  OF oDlg                                        PIXEL
@ 012,030 MsGet oVerba      Var cVerba      F3 "SRV"                             Size 30,10  OF oDlg PIXEL  Valid f_Verba()                 
@ 012,064 Say cDescri                                                            Size 90,10  OF oDlg                                        PIXEL
@ 026,030 MsGet oValor      Var nValor      PICTURE "@E 9999,999.99"             Size 060,10 OF oDlg PIXEL  
@ 026,128 MsGet oData       Var dDatProc                                         Size 055,10 OF oDlg PIXEL  
@ 041,030 MsGet oFile       Var cPlanilha   PICTURE "@!"                         Size 195,10 OF oDlg PIXEL  Valid f_Planilha()
@ 256,003 SAY oTotais  PROMPT cTotais                                            Size 380,12 OF oDlg PIXEL  FONT oFnt     COLOR 255, 16777215      

oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{68,08,245,400})
oMark:oBrowse:bldblclick := { || f_gpe010() }

@ 022,240 BUTTON oButton1    PROMPT "Confirma Parametro"     SIZE 065,015 OF oDlg  PIXEL Action IIF(!lGerar , f_Parametro() , nil )
@ 022,320 BUTTON oButton2    PROMPT "Gera Verba"             SIZE 065,015 OF oDlg  PIXEL Action IIF(lGerar  , f_GeraVerba() , nil )
@ 041,240 BUTTON oButton3    PROMPT "Cancela operação"       SIZE 065,015 OF oDlg  PIXEL Action IIF(lGerar  , f_Cancela()   , nil )
@ 041,320 BUTTON oButton4    PROMPT "Sair"                   SIZE 065,015 OF oDlg  PIXEL Action f_CloseDlg()     

Activate MsDialog oDlg CENTER  Valid lSair

TRB->(dbCloseArea())

Return

/////////////////////////////////////////////
Static Function f_gpe010()
/////////////////////////////////////////////
Local x := 0

RecLock("TRB",.F.)
IF ( EMPTY(TRB->TB_OK) )
	TRB->TB_OK := cMarca 
	nTtlSel--
ELSE	
	TRB->TB_OK := "  " 
	nTtlSel++
ENDIF
MsUnlock()

cTotais := Stuff(cTotais,42,4,STRZERO(nTtlSel,4))
oTotais:Refresh()

Return(.T.)


//////////////////////////////////////////////
Static Function f_Cancela()
/////////////////////////////////////////////
Local lResp

lResp := MsgBox("Deseja mesmo cancelar a operação?","Selecione a opção","YESNO")

IF ( lResp )
	cVerba    := Space(3)
	nValor    := 0
	cPlanilha := Space(40)
	cDescri   := Space(40)
	cTotais   := ""
	dDatProc  := CTOD("")
   lGerar    := .F.
	dbSelectArea("TRB")
	__dbZap()
	*
	oMark:oBrowse:Refresh()
	oMark:oBrowse:GoTop()
	oVerba:Enable()
	oValor:Enable()
	oFile:Enable()
	oData:Enable()
ENDIF

Return(lResp)

///////////////////////////////////////////
Static Function f_CloseDlg()
///////////////////////////////////////////
Local lResp := .T.

IF ( lGerar )
	lResp := MsgBox("Existe verba para processar. Deseja mesmo sair desta operação?","Selecione a opção","YESNO") 
ENDIF	

IF ( lResp )
	lSair := .T.
	oDlg:End()
ENDIF

Return(lResp)

///////////////////////////////////////////
Static Function f_Verba()
///////////////////////////////////////////
Local lResp := .T.

IF ( !EMPTY(cVerba) )

	SRV->(dbSeek(xFilial("SRV")+cVerba))

	lResp := SRV->(!EOF())

	IF ( !lResp )
		MsgStop("Verba NÃO cadastrada.","Verba inválida")
	ELSE
		/*
		IF ( cVerba < "117" ) .OR. ( cVerba >= "119" .AND. cVerba <= "129" ) .OR. ( cVerba >= "134" .AND. cVerba <= "156" )          .OR. ;
			( cVerba >= "158" .AND. cVerba <= "186" ) .OR. ( cVerba $ "188,194,195,196,197,198,215,220,222,226,227,228,229,320,438" ) .OR. ;
			( cVerba >= "252" .AND. cVerba <= "309" ) .OR. ( cVerba >= "401" .AND. cVerba <= "421" ) .OR. ;
			( cVerba >= "425" .AND. cVerba <= "434" ) .OR. ( cVerba >= "449" .AND. cVerba <= "456" ) .OR. ;
			( cVerba >= "460" .AND. cVerba <= "470" ) .OR. ( cVerba > "479" )
			MsgStop("Verba nao permitida para esta operacao.","Verba invalida")
			lResp := .F.
		ENDIF
		*/
		cDescri := SRV->RV_DESC
	ENDIF

ENDIF

Return(lResp)
	
/////////////////////////////////////////////////////////
Static Function f_Planilha()
/////////////////////////////////////////////////////////
Local cArq

IF ( !EMPTY(cPlanilha) )

	cArq := IIF(SUBS(cPlanilha,2,2)==":\" , RTRIM(cPlanilha) , ( cxPath + RTRIM(cPlanilha) ) )

	IF ( !FILE(cArq) )
		cArq := cGetFile( cTipo,"Selecione arquivo...",@nMaskDef    , cxPath , .T. , CGETFILE_TYPE )
		IF ( !EMPTY(cArq) )
			cPlanilha := RTRIM(cArq)
			ObjectMethod(oFile,"REFRESH()")
		ENDIF	
	ENDIF

ENDIF

Return(.T.)

/////////////////////////////////////////////////////////
Static Function f_Parametro()
/////////////////////////////////////////////////////////

IF ( EMPTY(cVerba) )
	MsgStop("Falta informar a verba.","Codigo da verba")
	Return
ENDIF
IF ( EMPTY(dDatProc).OR.LEFT(DTOS(dDatProc),6)<>cDatFech )
	MsgStop("Falta informar a data de processamento ou data fora do periodo.","Data invalida")
	Return
ENDIF
IF ( EMPTY(cPlanilha) )
	IF ( nValor = 0 )
		MsgStop("Falta informar o valor.","Valor da verba")
		Return
	ELSEIF ( nValor < 0 )
		MsgStop("Valor nao pode ser negativo.","Valor invalido")
		Return
	ENDIF
ENDIF

DO CASE
	CASE EMPTY(cPlanilha)
		nCtd1 := 0
		dbSelectArea("SRA")
		dbSetOrder(1)
		dbSeek(xFilial("SRA"),.T.)
		DO WHILE !EOF().AND.RA_FILIAL == xFilial("SRA")
			IF ( SRA->RA_SITFOLH <> "D" )
				nCtd1++
				SX5->(dbSeek(xFilial("SX5")+"31"+SRA->RA_SITFOLH))
				RecLock("TRB",.T.)
				TRB->TB_MAT   := SRA->RA_MAT
				TRB->TB_NOME  := SRA->RA_NOME
				TRB->TB_VALOR := nValor
				TRB->TB_SIT   := IIF(EMPTY(SRA->RA_SITFOLH) , "ATIVO" , SX5->X5_DESCRI )
				TRB->TB_CC    := SRA->RA_CC
				MsUnlock()
				dbSelectArea("SRA")
			ENDIF
			dbSkip()
		ENDDO
		nTtlSel := nCtd1
		cTotais := "Total de funcionários selecionados...... "+STRZERO(nTtlSel,4)+" de "+STRZERO(nCtd1,4)
		lGerar  := .T.
		dbSelectArea("TRB")
		dbGoTop()
		oMark:oBrowse:Refresh()
		oMark:oBrowse:GoTop()
		oVerba:Disable()
		oValor:Disable()
		oFile:Disable()
		oData:Disable()
		
	OTHERWISE
	
		aArqTemp := U_CCONVCSV("1" , cPlanilha , "Verba.txt" , "Tempor.txt" )
	
		IF ( !EMPTY(aArqTemp[1]) )
			Processa( {|| ReadTxt(aArqTemp[1]) } )
			lGerar := .T.
		ENDIF	

ENDCASE

Return(.T.)

//////////////////////////////////////////////////////////
Static Function f_GeraVerba()
//////////////////////////////////////////////////////////
Local lResp
Local xArq := RTRIM(cPlanilha)     

lResp := MsgBox("Confirma a geração da verba?","Selecione a opção","YESNO")

IF ( lResp )	

	dbSelectArea("TRB")
	dbGoTop()
	DO WHILE !EOF()
		IF ( EMPTY(TRB->TB_OK) )
			dbSelectArea("SRC")
			dbSetOrder(1)
			dbSeek(xFilial("SRC")+TRB->TB_MAT+cVerba+TRB->TB_CC)
			IF ( EOF() )
				RecLock("SRC",.T.)
				SRC->RC_FILIAL  := xFilial("SRC")
				SRC->RC_MAT     := TRB->TB_MAT
				SRC->RC_PD      := cVerba
				SRC->RC_TIPO1   := "V"
				SRC->RC_VALOR   := TRB->TB_VALOR
				SRC->RC_DATA    := dDatProc
				SRC->RC_CC      := TRB->TB_CC
				SRC->RC_TIPO2   := "I"
				MsUnlock()				
			ENDIF
			dbSelectArea("TRB")
		ENDIF
		dbSkip()
	ENDDO
   MsgInfo("*** Operação finalizada com sucesso!")
   lSair := .T.
   Close(oDlg)

ENDIF

Return(lResp)

////////////////////////////////////////////////////////////
Static Function ReadTXT(cArq)
////////////////////////////////////////////////////////////
Local cxLinha,cxMatr,nxValor
Local cQuebra := Chr(13) + Chr(10)
Local nCtd1   := 0

	Ft_fuse(cArq)
	ft_fgotop()
	ProcRegua(1000)
	DO WHILE !ft_feof()
   	cxLinha := StrTran(ft_freadln(), cQuebra, "")
		cxMatr  := SUBS(cxLinha,1,6)
		nxValor := ( VAL(SUBS(cxLinha,7,12)) / 100 )
		IF ( !EMPTY(cxMatr) )
			nCtd1++
			SRA->(dbSeek(xFilial("SRA")+cxMatr))
			SX5->(dbSeek(xFilial("SX5")+"31"+SRA->RA_SITFOLH))
			RecLock("TRB",.T.)
			TRB->TB_MAT   := SRA->RA_MAT
			TRB->TB_NOME  := SRA->RA_NOME
			TRB->TB_VALOR := nxValor
			TRB->TB_SIT   := IIF(EMPTY(SRA->RA_SITFOLH) , "ATIVO" , SX5->X5_DESCRI )
			TRB->TB_CC    := SRA->RA_CC
			MsUnlock()
		ENDIF
		ft_fskip()
	ENDDO	
	ft_fuse()
   *
	nTtlSel := nCtd1
	cTotais := "Total de funcionarios selecionados...... "+STRZERO(nTtlSel,4)+" de "+STRZERO(nCtd1,4)
	dbSelectArea("TRB")
	dbGoTop()
	oMark:oBrowse:Refresh()
	oMark:oBrowse:GoTop()
	oVerba:Disable()
	oValor:Disable()
	oFile:Disable()
	oData:Disable()
	
Return