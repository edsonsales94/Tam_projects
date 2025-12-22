/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CESTG115 º Autor ³ Carlos Nina        º Data ³  01/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Acerto Contabil de Fechamento de Estoque                   º±±
±±º          ³ -- Ate Estrutura estiver toda atualizada                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Custo/Contabil                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"

User Function CESTG115()

SetPrvt("CPRODUTO,CDESCRI,CUM,CLOCAL,NQFIM,NVFIM,NVFIM1,CSEQCALC,LRE0,LDE0,LSB2,LSB9,LPROC,ACOLS,AHEADER,N,NLBOX")
SetPrvt("OBROWSE,OLBOX,OMULTI,AVEST,DDATANT,DDATFECH,DDATINI,DDATFIN,NQTYI,NVLRI,LMOV")
SetPrvt("CCC,CTIPO,CGRP,CCTB,CLOCPAD,MVLOCPROC")

dDatFech := GETMV("MV_ULMES")
//IF ( LEFT(DTOS(ddatabase),6) > LEFT(DTOS(dDatFech),6) )
//   MsgAlert("**** Não existe Fechamento para a Data-Base informada. ****")
//   Return
//ENDIF
mvLocProc := GETMV("MV_LOCPROC")
dDatFech  := LastDay(ddatabase)
dDatIni   := FirstDay(dDatFech)
dDatFin   := dDatFech
dDatAnt   := ( dDatIni - 1 )
Tabmes    := 'JANFEVMARABRMAIJUNJULAGOSETOUTNOVDEZ'
nMes      := MONTH(dDatFech)
cAno      := LEFT(DTOS(dDatFech),4)
cExt      := ( "Acerto Contábil ref. a " + Rtrim(Subs(Tabmes,(nMes*3)-2,3))+'/'+cAno )
aHeader   := {}
AADD(aHeader,{"STR"             , "C7_ITEMSC " ,"                   " ,03,0 , "                             " , "€€€€€€€","C","SC7"})
AADD(aHeader,{"Emissão"         , "C7_ITEMSC " ,"                   " ,08,0 , "                             " , "€€€€€€€","D","SC7"})
AADD(aHeader,{"T.M."            , "C7_ITEMSC " ,"                   " ,03,0 , "                             " , "€€€€€€€","C","SC7"})
AADD(aHeader,{"CFOP"            , "C7_ITEMSC " ,"                   " ,05,0 , "                             " , "€€€€€€€","C","SC7"})
AADD(aHeader,{"Seq."            , "C7_ITEMSC " ,"                   " ,06,0 , "                             " , "€€€€€€€","C","SC7"})
AADD(aHeader,{"Documento"       , "C7_ITEMSC " ,"                   " ,06,0 , "                             " , "€€€€€€€","C","SC7"})
AADD(aHeader,{"Qty"             , "C7_ITEMSC " ,"@E 99999999.99     " ,07,2 , "                             " , "€€€€€€€","N","SC7"})
AADD(aHeader,{"Custo"           , "TB_CUSTO  " ,"@E 999999,999.9999 " ,10,4 , "ExecBlock('EG015CUS',.F.,.F.)" , "€€€€€€€","N","TRB"})
AADD(aHeader,{"Sdo(Qty)"        , "C7_ITEMSC " ,"@E 99999999.99     " ,07,2 , "                             " , "€€€€€€€","N","SC7"})
AADD(aHeader,{"Sdo(Custo)"      , "C7_ITEMSC " ,"@E 999999,999.9999 " ,10,4 , "                             " , "€€€€€€€","N","SC7"})
AADD(aHeader,{"Seq.Cálculo"     , "C7_ITEMSC " ,"                   " ,14,0 , "                             " , "€€€€€€€","C","SC7"})
AADD(aHeader,{"Proc?"           , "TB_PROC   " ,"@!                 " ,01,0 , "                             " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Record"          , "C7_ITEMSC " ,"@E 99999999        " ,08,0 , "                             " , "€€€€€€€","N","SC7"})

fLimpa1()
fLimpa2()

@ 065,000 To 639,970 Dialog oDlg Title cExt  //OemToAnsi("Acerto Contábil referente ao último período de fechamento")
@ 045,002 To 280,482 Title OemToAnsi("Movimento")  //402
@ 002,002 Say OemToAnsi("Código Produto")                              Size 38,7
@ 002,062 Say OemToAnsi("Descrição")                                   Size 25,7
@ 002,195 Say OemToAnsi("UM")                                          Size 10,7
@ 002,225 Say OemToAnsi("Local")                                       Size 15,7
@ 023,002 Say OemToAnsi("Qty. Final")                                  Size 27,7
@ 023,062 Say OemToAnsi("Vlr.Final (SB9)")                             Size 42,7
@ 023,127 Say OemToAnsi("Vlr.Final (SB2)")                             Size 42,7
@ 023,195 Say OemToAnsi("Seq.Cálculo")                                 Size 30,7
@ 002,260 To 046,326 Title OemToAnsi("Movimentação")                              //Size 37,8
@ 002,331 To 046,446 Title OemToAnsi("Saldos SB9")                              //Size 37,8
@ 010,002 Get cProduto                 Picture "@!"       F3 "SB1"     Size 60,10   Valid fProd()  WHEN !lProc Object oProduto
@ 010,062 Get cDescri                  Picture "@!"                    Size 120,10  WHEN .F.
@ 010,195 Get cUM                                                      Size 16,10   WHEN .F.
@ 010,225 Get cLocal                   Picture "@!"                    Size 16,10   Valid fLocal() WHEN !lProc
@ 032,002 Get nQFim                    Picture "@E 99999999.99"        Size 50,10   WHEN .F.
@ 032,062 Get nVFim                    Picture "@E 9999,999,999.9999"  Size 60,10   WHEN .F.
@ 032,127 Get nVFim1                   Picture "@E 9999,999,999.9999"  Size 60,10
@ 032,195 Get cSeqCalc                                                 Size 60,10
@ 010,262 CheckBox OemToAnsi("RE0  ") Var lRE0   //241
@ 022,262 CheckBox OemToAnsi("DE0  ") Var lDE0   //271
@ 034,262 CheckBox OemToAnsi("MOV  ") Var lMOV   //271
@ 010,296 CheckBox OemToAnsi("SB2  ") Var lSB2   //271
@ 022,296 CheckBox OemToAnsi("SB9  ") Var lSB9   //271
*
//@ 008,334 ListBox nLBox ITEMS aVEst                                  SIZE 108,36 Object oLBox
*
@ 051,005 TO 275,478 MULTILINE MODIFY FREEZE 8                                  Object oMulti
*
@ 003,450 Button OemToAnsi("Confirmar")                              Size 35,13 Action G15_CONF()
@ 017,450 Button OemToAnsi("Cancelar")                               Size 35,13 Action G15_Canc()
@ 031,450 Button OemToAnsi("Sair")                                   Size 35,13 Action oDlg:End()

Activate Dialog oDlg CENTER

Return

**************************
Static Function G15_Canc()
**************************
lResp := MsgBox("Cancela o Acerto?","Selecione a Opção","YESNO")
IF ( lResp )
   fLimpa2()
   ObjectMethod(oLBox,"Hide()")
	ObjectMethod(oProduto,"SETFOCUS()")
	oDlg:Refresh()
ENDIF
Return(lResp)

***********************
Static Function fProd()
***********************
lRsp := .T.
IF ( !EMPTY(cProduto) )
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProduto)
	IF ( EOF() )
	   dbSetOrder(8)
   	dbSeek(xFilial("SB1")+cProduto)
      IF ( EOF() )
   	   MsgAlert("** Produto não cadastrado. Verifique o Código digitado.")
	      lRsp := .F.
      ENDIF
   ENDIF
   cProduto := SB1->B1_COD
   cDescri  := SB1->B1_DESC
   cUM      := SB1->B1_UM
   cLocal   := SB1->B1_LOCPAD
   cCc      := SB1->B1_CC
   cGrp     := SB1->B1_GRUPO
   cCtb     := SB1->B1_CONTA
   cTipo    := SB1->B1_TIPO
   cLocPad  := cLocal
ENDIF
Return(lRsp)

************************
Static Function fLocal()
************************
Local nSqCalc := VAL(LEFT(DTOS(dDatIni),6)+"01000001")
Local dDataI

dbSelectArea("SB2")
dbSetOrder(1)
dbSeek(xFilial("SB2")+cProduto+cLocal)
nQFim  := B2_QFIM
nVFim1 := B2_VFIM1
*
dbSelectArea("SB9")
dbSetOrder(1)
dbSeek(xFilial("SB9")+cProduto+cLocal+dtos(dDatAnt))
nQtyI := SB9->B9_QINI
nVlrI := SB9->B9_VINI1
ix    := 1
DO WHILE !BOF().AND.B9_FILIAL==xFilial("SB9").AND.B9_COD==cProduto.AND.B9_LOCAL==cLocal.AND.ix<=4
   ix := ( ix + 1 )
   AADD( aVEst , DTOC(B9_DATA)+"  "+TRANSF(B9_QINI,"@E 99999999.99")+"   "+TRANSF(B9_VINI1,"@E 999999,999.9999") )
   dbSkip(-1)
ENDDO
*
aCols := {}
*
dbSelectArea("SD1")
dbSetOrder(7)
dbSeek(xFilial("SD1")+cProduto+cLocal+DTOS(dDatIni),.T.)
DO WHILE !EOF().AND.D1_FILIAL==xFilial("SD1").AND.D1_COD==cProduto.AND.D1_LOCAL==cLocal.AND.D1_DTDIGIT<=dDatFin
   //IF ( !EMPTY(D1_SEQCALC) )
      nRecNo := SD1->(RECNO())
      AADD( aCols , { "SD1"      , ;
                      D1_DTDIGIT , ;
                      D1_TES     , ;
                      D1_CF      , ;
                      D1_NUMSEQ  , ;
                      D1_DOC     , ;
                      D1_QUANT   , ;
                      D1_CUSTO   , ;
                      0.00       , ;
                      0.0000     , ;
                      D1_SEQCALC , ;
                      "N"        , ;
							 nRecNo     } )

      nSeq    := VAL(D1_SEQCALC)
      nSqCalc := MAX(nSeq,nSqCalc)
   //ENDIF
   dbSkip()
ENDDO
*
dbSelectArea("SD2")
dbSetOrder(6)
dbSeek(xFilial("SD6")+cProduto+cLocal+DTOS(dDatIni),.T.)
DO WHILE !EOF().AND.D2_FILIAL==xFilial("SD2").AND.D2_COD==cProduto.AND.D2_LOCAL==cLocal.AND.D2_EMISSAO<=dDatFin
   //IF ( !EMPTY(D2_SEQCALC) )
      nRecNo := SD2->(RECNO())
      AADD( aCols , { "SD2"      , ;
                      D2_EMISSAO , ;
                      D2_TES     , ;
                      D2_CF      , ;
                      D2_NUMSEQ  , ;
                      D2_DOC     , ;
                      D2_QUANT   , ;
                      D2_CUSTO1  , ;
                      0.00       , ;
                      0.0000     , ;
                      D2_SEQCALC , ;
                      "N"        , ;
							 nRecNo     } )

      nSeq    := VAL(D2_SEQCALC)
      nSqCalc := MAX(nSeq,nSqCalc)
   //ENDIF
   dbSkip()
ENDDO
*
dbSelectArea("SD3")
dbSetOrder(7)
dbSeek(xFilial("SD3")+cProduto+cLocal+DTOS(dDatIni),.T.)
DO WHILE !EOF().AND.D3_FILIAL==xFilial("SD3").AND.D3_COD==cProduto.AND.D3_LOCAL==cLocal.AND.D3_EMISSAO<=dDatFin
   IF ( EMPTY(D3_ESTORNO) )
      nRecNo := SD3->(RECNO())
      AADD( aCols , { "SD3"      , ;
                      D3_EMISSAO , ;
                      D3_TM      , ;
                      D3_CF      , ;
                      D3_NUMSEQ  , ;
                      D3_DOC     , ;
                      D3_QUANT   , ;
                      D3_CUSTO1  , ;
                      0.00       , ;
                      0.0000     , ;
                      D3_SEQCALC , ;
                      "N"        , ;
							 nRecNo     } )

      nSeq    := VAL(D3_SEQCALC)
      nSqCalc := MAX(nSeq,nSqCalc)
   ENDIF
   dbSkip()
ENDDO
*
IF ( cLocal == "99" )  //mvLocProc )
	dbSelectArea("SD3")
	dbSetOrder(7)
	dbSeek(xFilial("SD3")+cProduto+cLocPad+dDataI,.T.)
	DO WHILE !EOF().AND.D3_FILIAL==xFilial("SD3").AND.D3_COD==cProduto.AND.D3_LOCAL==cLocPad.AND.D3_EMISSAO<=dDatFin
	   IF ( EMPTY(D3_ESTORNO).AND.D3_CF$"RE3|DE3" )
	      nRecNo := SD3->(RECNO())
         cCF    := IIF(D3_CF=="RE3","DE3","RE3")
         cTM    := IIF(D3_CF=="RE3","499","999")
   	   AADD( aCols , { "SD3"      , ;
      	                D3_EMISSAO , ;
            	          cTM        , ;
         	             cCF        , ;
               	       D3_NUMSEQ  , ;
                  	    D3_DOC     , ;
                     	 D3_QUANT   , ;
	                      D3_CUSTO1  , ;
   	                   0.00       , ;
      	                0.0000     , ;
         	             D3_SEQCALC , ;
            	          "N"        , ;
								 nRecNo     } )

	      nSeq    := VAL(D3_SEQCALC)
   	   nSqCalc := MAX(nSeq,nSqCalc)
	   ENDIF
   	dbSkip()
	ENDDO
ENDIF
lProc    := .T.
n        := 1
cSeqCalc := STRZERO((nSqCalc+1),14,0)
IF ( LEN(aCols) > 0 )
   aSort(aCols,,, {|x,y| DTOS(x[2])+x[11] < DTOS(y[2])+y[11] } )
   FOR nx:=1 TO LEN(aCols)
       dData := aCols[nx,2]
       IF ( dData >= dDatIni )
			 cCF   := LEFT(aCols[nx,4],1)
			 cRE   := IIF(aCols[nx,1]=="SD1","D",IIF(aCols[nx,1]=="SD2","R",IIF(cCF=="P","D",cCF)))
	   	 nQtyI := IIF(cRE=="D" , ( nQtyI + aCols[nx,7] ) , ( nQtyI - aCols[nx,7] ) )
		    nVlrI := IIF(cRE=="D" , ( nVlrI + aCols[nx,8] ) , ( nVlrI - aCols[nx,8] ) )
       ENDIF
 	    aCols[nx,9]  := nQtyI
    	 aCols[nx,10] := nVlrI
   NEXT
ENDIF
@ 008,334 ListBox nLBox ITEMS aVEst                                  SIZE 108,36 Object oLBox
//ObjectMethod(oLBox,"REFRESH()")
ObjectMethod(oMulti,"REFRESH()")
Return

**************************
Static Function G15_Conf()
**************************
IF ( lProc )
	IF ( !EMPTY(cProduto).AND.!EMPTY(cLocal) )
		lResp := MsgBox("Confirma o Acerto Contábil?","Selecione a Opção","YESNO")
		IF ( lResp )
         IF ( lSB2 )
            RecLock("SB2",.F.)
            SB2->B2_VFIM1 := nVFim1
            MsUnlock()
         ENDIF
			/*
         IF ( lSB9 )
            RecLock("SB9",.F.)
            SB9->B9_VINI1 := nVFim1
            SB9->B9_CM1   := ROUND( SB9->B9_VINI1 / SB9->B9_QINI , 4)
            MsUnlock()
         ENDIF			
         IF ( lRE0 )
            cNumSeq := ProxNum()
            DbselectArea("SD3")
            RecLock("SD3",.T.)
            SD3->D3_FILIAL  := xFilial("SD3")
            SD3->D3_TM      := "601"
            SD3->D3_COD     := cProduto
            SD3->D3_QUANT   := nQtyI
            SD3->D3_CUSTO1  := nVlrI
            SD3->D3_LOCAL   := cLocal
            SD3->D3_DOC     := "ACERTO"
            SD3->D3_UM      := cUM
            SD3->D3_EMISSAO := dDatFech
            SD3->D3_NUMSEQ  := cNumSeq
            SD3->D3_SEQCALC := cSeqCalc
            SD3->D3_CF      := "RE0"
            SD3->D3_TIPO    := cTipo
            SD3->D3_CHAVE   := "E0"
            SD3->D3_GRUPO   := cGrp
            SD3->D3_CONTA   := cCtb
            SD3->D3_CC      := cCc
            SD3->D3_USUARIO := subs(cUsuario,7,15)
            SD3->D3_OBSV    := "ACERTO CONTABIL"
		  	   MsUnLock()
         ENDIF
         IF ( lDE0 )
            cSeqCalc := IIF(!lRE0 , cSeqCalc , STRZERO( ( VAL(cSeqCalc) + 1 ) , 14 , 0 ) )
            cNumSeq  := ProxNum()
            DbselectArea("SD3")
            RecLock("SD3",.T.)
            SD3->D3_FILIAL  := xFilial("SD3")
            SD3->D3_TM      := "003"
            SD3->D3_COD     := cProduto
            SD3->D3_QUANT   := nQtyI
            SD3->D3_CUSTO1  := nVFim1
            SD3->D3_LOCAL   := cLocal
            SD3->D3_DOC     := "ACERTO"
            SD3->D3_UM      := cUM
            SD3->D3_EMISSAO := dDatFech
            SD3->D3_NUMSEQ  := cNumSeq
            SD3->D3_SEQCALC := cSeqCalc
            SD3->D3_CF      := "DE0"
            SD3->D3_TIPO    := cTipo
            SD3->D3_CHAVE   := "E0"
            SD3->D3_GRUPO   := cGrp
            SD3->D3_CONTA   := cCtb
            SD3->D3_CC      := cCc
            SD3->D3_USUARIO := subs(cUsuario,7,15)
            SD3->D3_OBSV    := "ACERTO CONTABIL"
		  	   MsUnLock()
         ENDIF
			*/
         IF ( lMOV .AND. LEN(aCols) > 0 )
            FOR ix:=1 TO LEN(aCols)
                cProcs := aCols[ix,12]
                IF ( cProcs == "S" )
	                cStru := aCols[ix,1]
   	             nRecN := aCols[ix,13]
      	          dbSelectArea(cStru)
         	       dbGoTo(nRecN)
            	    RecLock(cStru,.F.)
               	 IF ( cStru == "SD1" )
                  	 SD1->D1_CUSTO := aCols[ix,8]
	                ELSEIF ( cStru == "SD2" )
   	                SD2->D2_CUSTO1 := aCols[ix,8]
      	          ELSEIF ( cStru == "SD3" )
         	          SD3->D3_CUSTO1 := aCols[ix,8]
            	    ENDIF
               	 MsUnlock()
                ENDIF
            NEXT
         ENDIF
         *
  			fLimpa1()
         fLimpa2()
         *
		   ObjectMethod(oLBox,"Hide()")
			ObjectMethod(oProduto,"SETFOCUS()")
			oDlg:Refresh()
	   ENDIF
   ENDIF
ENDIF
Return

*************************
Static Function fLimpa1()
*************************
cProduto := Space(30)
cDescri  := Space(30)
cUM      := Space(2)
cLocal   := Space(2)
cGrp     := Space(4)
cCc      := Space(9)
cCtb     := Space(20)
cTipo    := Space(2)
cLocPad  := Space(2)
Return

*************************
Static Function fLimpa2()
*************************
nQFim    := 0
nVFim    := 0
nVFim1   := 0
nQtyI    := 0.000
nVlrI    := 0.00
n        := 1
nLbox    := 1
cSeqCalc := Space(14)
lRE0     := .F.
lDE0     := .F.
lSB2     := .F.
lSB9     := .F.
lMOV     := .F.
lProc    := .F.
aCols    := {}
aVEst    := {}
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function EG015CUS()
////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nVlCus := M->TB_CUSTO

nx := n
ny := 0
DO WHILE nx <= LEN(aCols)
	cCF := LEFT(aCols[nx,4],1)
	cRE := IIF(aCols[nx,1]=="SD1","D",IIF(aCols[nx,1]=="SD2","R",IIF(cCF=="P","D",cCF)))
   IF ( nx == n )
      aCols[nx,12] := "S"
		nSdo := IIF(cRE=="D" , ( aCols[nx,10] - aCols[nx,8] ) , ( aCols[nx,10] + aCols[nx,8] ) )
	   nSdo := IIF(cRE=="D" , ( nSdo + nVlCus ) , ( nSdo - nVlCus ) )
   ELSE
	   nSdo := IIF(cRE=="D" , ( nSdo + aCols[nx,8] ) , ( nSdo - aCols[nx,8] ) )
   ENDIF
   aCols[nx,10] := nSdo
   nx           := ( nx + 1 )
ENDDO
Return(.T.)
