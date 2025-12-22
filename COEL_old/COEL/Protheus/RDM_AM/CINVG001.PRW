#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CINVG001 º Autor ³ Carlos Nina        º Data ³  27/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Digitacao da Contagem de Inventario                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Inventario Geral                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CINVG001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ZPFICHA,ZPCOD,ZPDATA,ZPLOCAL,ZPQUANT,ZPDESC,ZPLOCALIZ,ZPCONTAG")
SetPrvt("ZPUM,N,ACOLS,AHEADER,LFICHA,LPRIVEZ,OFICHA,OPROD")

dbSelectArea("SZP")
dbSetOrder(1)
dbGoBottom()
ZPDATA    := SZP->ZP_DATA
aCols     := {}
n         := 1
cContag   := "1"
lPriVez   := .T.
lLocaliz  := .T.
aHeader   := {}

fLimpa()

AADD(aHeader,{"Ficha"           , "TB_FICHA  " ,"@R 99999-9     " ,06,0 , "   " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Código"          , "TB_COD    " ,"@!             " ,30,0 , "   " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Local"           , "TB_LOCAL  " ,"@!             " ,02,0 , "   " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Contagem"        , "TB_CONTAG " ,"               " ,03,0 , "   " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Quantidade"      , "TB_QUANT  " ,"@E 9999999.999 " ,11,3 , "   " , "€€€€€€€","N","TRB"})
AADD(aHeader,{"Localização"     , "TB_LOCALIZ" ,"@!             " ,15,0 , "   " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Item"            , "TB_ITEM   " ,"               " ,05,0 , "   " , "€€€€€€€","C","TRB"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 151,134 To 575,890 Dialog oDlg Title OemToAnsi("Contagem de Inventário")
@ 075,002 To 210,321 Title OemToAnsi("Digitação")
@ 001,002 Say OemToAnsi("Data do Inventário")     Size 45,8
@ 013,002 Say OemToAnsi("Contagem")               Size 45,8
@ 025,002 Say OemToAnsi("Ficha Nro.")             Size 45,8
@ 037,002 Say OemToAnsi("Código")                 Size 45,8
@ 058,002 Say OemToAnsi("Almoxarifado")           Size 45,8
@ 058,080 Say OemToAnsi("Quantidade:")            Size 46,8
@ 058,160 Say OemToAnsi("U.M:")                   Size 22,8
@ 058,200 Say OemToAnsi("Localização:")           Size 45,8
*
@ 082,003 TO 206,317 MULTILINE                    Object oMulti
*
@ 001,049 Get ZPDATA                              Size 35,10
@ 013,049 Get ZPCONTAG   Picture "!"              Size 10,10           VALID ZPCONTAG $ "123"
@ 025,049 Get ZPFICHA    Picture "@E 999999"      Size 30,10           WHEN lFicha VALID f_Ficha() Object oFicha    
@ 037,049 Get ZPCOD      Picture "@!"             Size 100,10 F3 "SB1" WHEN lFicha VALID f_Prod()  Object oProd
@ 037,150 Get ZPDESC                              Size 160,10          WHEN .F.
@ 058,049 Get ZPLOCAL    Picture "@!"             Size 15,10           WHEN lFicha VALID ZPLOCAL $ "02,60,62"    //fLocal()
@ 058,110 Get ZPQUANT    Picture "@E 9999999.99"  Size 42,10           VALID ZPQUANT >= 0.00
@ 058,172 Get ZPUM                                Size 15,10           WHEN .F.
@ 058,232 Get ZPLOCALIZ  Picture "@!"             Size 50,10 F3 "SBE"  VALID f_localiz() WHEN !llocaliz
*
@ 005,315 Button "_Confirma Contagem"             Size 60,15 Action CloseOk()
@ 024,315 Button "Cance_la Contagem"              Size 60,15 Action CloseCan()
@ 042,315 Button "_Sair da Digitação"             Size 60,15 Action Close(oDlg)

Activate Dialog oDlg Center

Return

************************
Static Function fProd()
************************
lResp := .T.
IF ( !EMPTY(ZPCOD) )
	dbSelectArea("SZP")
	dbSetOrder(3)
	dbSeek(xFilial("SZP")+DTOS(ZPDATA)+ZPCOD)
	IF ( EOF() )
	   MsgAlert("** Ficha não existe. Verifique a Data do Inventário.")
	   //lResp := .F.
	ELSE
		ZPFICHA   := VAL(SZP->ZP_FICHA)
		ZPCOD     := SZP->ZP_COD
		ZPDESC    := SZP->ZP_DESC
		ZPLOCAL   := SZP->ZP_LOCAL
		ZPUM      := SZP->ZP_UM
	   ZPLOCALIZ := SZP->ZP_LOCALIZ
		ZPQUANT   := IIF(ZPCONTAG=="1",SZP->ZP_CONT1,IIF(ZPCONTAG=="2",SZP->ZP_CONT2,SZP->ZP_CONT3))
		lFicha    := ( EMPTY(SZP->ZP_COD) )
   ENDIF
ENDIF
Return(lResp)

************************
Static Function f_Ficha()
************************
lResp := .T.
IF ( ZPFICHA > 0 )
	dbSelectArea("SZP")
	dbSetOrder(1)
	dbSeek(xFilial("SZP")+DTOS(ZPDATA)+STRZERO(ZPFICHA,6))
	IF ( EOF() )
	   MsgStop("Ficha não existe. Verifique a Data do Inventário.","Atenção")
	   lResp := .F.
	ELSE
		ZPCOD     := SZP->ZP_COD
   	///fProd()
		ZPDESC    := SZP->ZP_DESC
		ZPLOCAL   := SZP->ZP_LOCAL
	   ZPLOCALIZ := IIF(EMPTY(SZP->ZP_LOCALIZ) , ZPLOCALIZ , SZP->ZP_LOCALIZ )
		ZPQUANT   := IIF(ZPCONTAG=="1",SZP->ZP_CONT1,IIF(ZPCONTAG=="2",SZP->ZP_CONT2,SZP->ZP_CONT3))
		lFicha    := ( EMPTY(SZP->ZP_COD) )
		lLocaliz  := ( !EMPTY(ZPLOCALIZ) )
   ENDIF
ENDIF
Return(lResp)

***********************
Static Function f_Prod()
***********************
lRsp := .T.
IF ( !EMPTY(ZPCOD) )
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+ZPCOD)
	IF ( EOF() )
	   dbSetOrder(8)
   	dbSeek(xFilial("SB1")+ZPCOD)
      IF ( EOF() )
   	   MsgAlert("** Produto não cadastrado. Verifique o Código digitado.")
	      lRsp := .F.
      ENDIF
   ENDIF
   ZPCOD    := SB1->B1_COD
   ZPDESC   := SB1->B1_DESC
   ZPUM     := SB1->B1_UM
ENDIF
Return(lRsp)

***************************
Static Function f_localiz()
***************************
lResp := .T.
IF ( !EMPTY(ZPLOCALIZ) )
	
   dbSelectArea("SBE")
   dbSetOrder(1)
   dbSeek(xFilial("SBE")+ZPLOCAL+ZPLOCALIZ)
   IF ( EOF() )
      MsgAlert("Endereçamento não cadastrado.","Atenção")
      lResp := .F.
      ZPLOCALIZ := SPACE(15)
		
   ENDIF
	
ENDIF
Return(lResp)

************************
Static Function fLocal()
************************
lResp := .T.
IF ( !EMPTY(ZPLOCAL) )
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"Z2"+ZPLOCAL)
	IF ( EOF() )
	   MsgAlert("** Almoxarifado não cadastrado. Verifique o Código digitado.")
	   lResp := .F.
   ENDIF
ENDIF
Return(lResp)

**************************
Static Function CloseCan()
**************************
lResp := MsgBox("Cancela a Contagem?","Selecione a Opção","YESNO")
IF ( lResp )
   fLimpa()
ENDIF
Return(lResp)

*************************
Static Function CloseOk()
*************************
Local lResp := .T.

IF ( ZPFICHA<>0.AND.!EMPTY(ZPCOD).AND.!EMPTY(ZPLOCAL) )
	///lResp := MsgBox("Confirma os dados da Contagem?","Selecione a Opção","YESNO")
	IF ( lResp )
      dbSelectArea("SZP")
   	IF ( EOF() )
	   	MsgAlert("** Ficha não existe. Verifique a Data do Inventário.")
	   	lResp := .F.
      ELSE
			IF ( ZPCONTAG=="1".AND.SZP->ZP_CONTAG $ "23" )
				MsgStop("Já Digitada 2a. ou 3a. Contagem. Favor verificar Ficha ou Contagem.")
         	lResp := .F.
			ELSEIF ( ZPCONTAG=="2".AND.SZP->ZP_CONTAG $ " ,3" )
         	lResp := .F.
				IF ( SZP->ZP_Contag==" ")
					MsgStop("1a. Contagem ainda não foi Digitada. Favor verificar Ficha ou Contagem.")
				ELSE
			   	MsgStop("Já Digitada 3a.Contagem. Favor verificar Ficha ou Contagem.")
				ENDIF
			ELSEIF ( ZPCONTAG=="3".AND.( SZP->ZP_CONTAG $ " ,1" .OR. SZP->ZP_CONT1==SZP->ZP_CONT2 ) )
         	lResp := .F.
				IF ( SZP->ZP_Contag == " " )
					MsgStop("1a. e 2a. Contagem ainda não foi Digitada. Favor verificar Ficha ou Contagem.")
				ELSEIF ( SZP->ZP_Contag == "1" )
					MsgStop("2a. Contagem ainda não foi Digitada. Favor verificar Ficha ou Contagem.")
				ELSEIF ( SZP->ZP_CONT3 == SZP->ZP_CONT2 )
					MsgStop("2a.Contagem iqual a essa 3a. Contagem. Portanto, não necessita da 3a. Contagem. Favor verificar Ficha ou Contagem.")
         	ENDIF
         ENDIF
      ENDIF
      IF ( lResp )
	   	IF ( lPrivez )
   	   	lPrivez := .F.
	   	   aCols   := {}
	   	ENDIF
		   dbSelectArea("SZP")
   		RecLock("SZP",.F.)
		   IF ( ZPCONTAG == "1" )
   		   SZP->ZP_CONT1 := ZPQUANT
	   	ELSEIF ( ZPCONTAG == "2" )
	   	   SZP->ZP_CONT2 := ZPQUANT
		   ELSE
   		   SZP->ZP_CONT3 := ZPQUANT
		   ENDIF
			SZP->ZP_RESULT  := ZPQUANT   ///IIF(Z1_CONT1==Z1_CONT2,Z1_CONT1, ;
			                             ///IIF(Z1_CONT1==Z1_CONT3,Z1_CONT1, ;
		   	                          ///IIF(Z1_CONT2==Z1_CONT3,Z1_CONT2,SZ1->Z1_RESULT)))
	      SZP->ZP_CONTAG  := ZPCONTAG
   		SZP->ZP_LOCALIZ := ZPLOCALIZ
	   	SZP->ZP_COD     := ZPCOD
		   SZP->ZP_LOCAL   := ZPLOCAL
   		SZP->ZP_DESC    := ZPDESC
			SZP->ZP_UM      := ZPUM
		   MsUnlock()
   		dbCommit()
      	*
		   cContag := ZPCONTAG
   		nx      := ( LEN(aCols) + 1 )
	   	n       := 1
	   	AADD(aCols , { STRZERO(ZPFICHA,6) , ;
		                  ZPCOD              , ;
      		            ZPLOCAL            , ;
         		         ZPCONTAG           , ;    ///+CHR(170)  , ;
            		      ZPQUANT            , ;
   		               ZPLOCALIZ          , ;
                  		STRZERO(nx,5)        ;
		                } )
		   aSort(aCols,,, {|x,y| x[7] > y[7] } )
   		fLimpa()
      ENDIF
   ENDIF
ENDIF
ObjectMethod(oFicha,"SETFOCUS()")
oDlg:Refresh()
Return

************************
Static Function fLimpa()
************************
ZPFICHA   := 0
ZPCOD     := SPACE(30)
ZPDESC    := SPACE(30)
ZPLOCAL   := SPACE(2)
ZPLOCALIZ := SPACE(15)
ZPQUANT   := 0.00
ZPUM      := SPACE(2)
ZPCONTAG  := cContag
lFicha    := .T.
Return