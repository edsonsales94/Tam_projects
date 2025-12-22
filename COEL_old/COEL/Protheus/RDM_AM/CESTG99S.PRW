/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CESTG99S ³ Autor ³ Carlos Nina           ³ Data ³ 27/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera arquivo de fechamento de estoque - Matl. produtivo +  ³±±
±±³          ³ Produto-Acabado (sem mao-de-obra).                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A partir de NOV/2006, o campo ZT_OUTENT que armazenava vlrs³±±
±±³          ³ da producao de PI+outros vlrs.MP, passa p/o campo ZT_VPRD. ³±±
±±³          ³ Esse campo, ZT_OUTENT, fica apenas c/vlrs de outros tipos  ³±±
±±³          ³ de entrada (exceto P3) p/MP+PI (Resumo Geral).             ³±±
±±³          ³ Criado os campos ZT_VOUTENT,ZT_VOUTSAI p/outras entradas e ³±±
±±³          ³ saidas p/PI+PA (relatorio de custo de Producao), inclusive ³±±
±±³          ³ P3.                                                        ³±±
±±³          ³ Criado os campos: ZT_P3... p/armazenar vlrs. de P3.        ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/10/01
#include "topconn.ch"

User Function CESTG99S()        // incluido pelo assistente de conversao do AP5 IDE em 11/10/01

Local aStru := {}
Local nOpcA := 0
Local cArqTrab,cIndex,cKey

Private nTamprod := TamSX3("B1_COD")[1]          ///Tamanho do campo

AADD(aStru,{"TB_COD"     , "C" , 30,0})
AADD(aStru,{"TB_GRUPO"   , "C" , 4,0})
AADD(aStru,{"TB_TIPO"    , "C" , 1,0})
AADD(aStru,{"TB_TPR"     , "C" , 2,0})
AADD(aStru,{"TB_QINI"    , "N" , 17,2})
AADD(aStru,{"TB_VINI"    , "N" , 15,4})
AADD(aStru,{"TB_ENTR"    , "N" , 15,4})  //COMPRA
AADD(aStru,{"TB_QENTR"   , "N" , 17,2})  //Q.COMPRAS
AADD(aStru,{"TB_OUTENT"  , "N" , 15,4})  //OUTRAS ENTRADAS <> DE P3
AADD(aStru,{"TB_QOUTRAS" , "N" , 17,2})  //Q.OUTRAS ENTRADAS <> DE P3
AADD(aStru,{"TB_REQ"     , "N" , 15,4})  //REQUISICAO
AADD(aStru,{"TB_QREQ"    , "N" , 17,2})  //Q.REQUISICAO
AADD(aStru,{"TB_QSUC"    , "N" , 17,2})
AADD(aStru,{"TB_SUC"     , "N" , 15,4})  //SUCATA
AADD(aStru,{"TB_QCONS"   , "N" , 17,2})
AADD(aStru,{"TB_OP"      , "N" , 15,4})  //CONSUMO/FATURAMENTO
AADD(aStru,{"TB_QAI"     , "N" , 17,2})
AADD(aStru,{"TB_INV"     , "N" , 15,4})  //AJUSTE INVENT.
AADD(aStru,{"TB_DEV"     , "N" , 15,4})  //DEVOLUCAO COMPRA
AADD(aStru,{"TB_QDEV"    , "N" , 17,2})
AADD(aStru,{"TB_DEVVDA"  , "N" , 15,4})  //DEVOLUCAO VENDA
AADD(aStru,{"TB_QDEVVDA" , "N" , 17,2})
AADD(aStru,{"TB_INS"     , "N" , 15,4})  //VENDA INSUMO
AADD(aStru,{"TB_QINS"    , "N" , 17,2})
AADD(aStru,{"TB_QPRD"    , "N" , 17,2})
AADD(aStru,{"TB_VPRD"    , "N" , 15,4})  //PRODUCAO PA/PI
AADD(aStru,{"TB_QOUTENT" , "N" , 17,2})
AADD(aStru,{"TB_VOUTENT" , "N" , 15,4})  //OUTRAS ENTRADAS + P3
AADD(aStru,{"TB_QOUTSAI" , "N" , 17,2})
AADD(aStru,{"TB_VOUTSAI" , "N" , 15,4})  //OUTRAS SAIDAS + P3
AADD(aStru,{"TB_AJUSTE"  , "N" , 15,4})  //DEV/REQ VALORIZADA+TRANSF.TIPO MTL.
AADD(aStru,{"TB_VAJENT"  , "N" , 15,4})  //DEV/REQ VALORIZADA+TRANSF.TIPO MTL.
AADD(aStru,{"TB_VAJSAI"  , "N" , 15,4})  //DEV/REQ VALORIZADA+TRANSF.TIPO MTL.
AADD(aStru,{"TB_QAJENT"  , "N" , 17,2})
AADD(aStru,{"TB_QAJSAI"  , "N" , 17,2})
AADD(aStru,{"TB_QFIM"    , "N" , 17,2})
AADD(aStru,{"TB_VATU"    , "N" , 15,4})
AADD(aStru,{"TB_P3DEC"   , "N" , 15,4})  //DE TERC. ENTRADA C/ESTOQ.
AADD(aStru,{"TB_P3EEC"   , "N" , 15,4})  //EM TERC. ENTRADA C/ESTOQ.
AADD(aStru,{"TB_QP3EEC"  , "N" , 17,2})  //Q.EM TERC. ENTRADA C/ESTOQ.
AADD(aStru,{"TB_P3DES"   , "N" , 15,4})  //DE TERC. ENTRADA S/ESTOQ.
AADD(aStru,{"TB_P3EES"   , "N" , 15,4})  //EM TERC. ENTRADA S/ESTOQ.
AADD(aStru,{"TB_P3DSC"   , "N" , 15,4})  //DE TERC. SAIDA   C/ESTOQ.
AADD(aStru,{"TB_P3ESC"   , "N" , 15,4})  //EM TERC. SAIDA   C/ESTOQ.
AADD(aStru,{"TB_QP3ESC"  , "N" , 17,2})  //Q.EM TERC. SAIDA   C/ESTOQ.
AADD(aStru,{"TB_P3DSS"   , "N" , 15,4})  //DE TERC. SAIDA   S/ESTOQ.
AADD(aStru,{"TB_P3ESS"   , "N" , 15,4})  //EM TERC. SAIDA   S/ESTOQ.
AADD(aStru,{"TB_P3DSF"   , "N" , 15,4})  //DE TERC. SALDO FINAL
AADD(aStru,{"TB_P3ESF"   , "N" , 15,4})  //EM TERC. SALDO FINAL
AADD(aStru,{"TB_QP3ESF"  , "N" , 17,2})  //Q.EM TERC. SALDO FINAL
AADD(aStru,{"TB_P3DSI"   , "N" , 15,4})  //DE TERC. SALDO INICIAL
AADD(aStru,{"TB_P3ESI"   , "N" , 15,4})  //EM TERC. SALDO INICIAL
AADD(aStru,{"TB_QP3ESI"  , "N" , 17,2})  //EM TERC. SALDO INICIAL
AADD(aStru,{"TB_VINII"   , "N" , 15,4})
AADD(aStru,{"TB_VININ"   , "N" , 15,4})
AADD(aStru,{"TB_SDOI"    , "N" , 15,4})
AADD(aStru,{"TB_SDON"    , "N" , 15,4})
AADD(aStru,{"TB_CMPI"    , "N" , 15,4})
AADD(aStru,{"TB_CMPN"    , "N" , 15,4})
AADD(aStru,{"TB_CC"      , "C" ,  4,0})
AADD(aStru,{"TB_OBS"     , "C" , 50,0})
cArqTrab := CriaTrab(aStru,.T.)
Use &cArqTrab ALIAS TRB NEW
cIndex := CriaTrab(NIL,.F.)
cKey   := 'TB_COD+TB_GRUPO+TB_TIPO+TB_TPR'
IndRegua("TRB",cIndex,cKey,,," Criando Indice ...   ")

dDatProc := ddatabase

@ 313,303 To 485,720 Dialog oDlg Title OemToAnsi("Fechamento de Estoque")
@ 24,11   To 75,193 Title OemToAnsi("Parametro")
@ 34,16   Say OemToAnsi("Data de Fechamento") Size 57,11
@ 6,11    Say OemToAnsi("Gera Estrutura de fechamento de estoque p/posterior impressao do relatorio.") Size 185,11
@ 34,76   Get dDatProc Picture "@k" Size 57,10
@ 33,147  BmpButton Type 1 Action (nOpcA := 1 , oDlg:End())
@ 52,147  BmpButton Type 2 Action (nOpcA := 2 , oDlg:End())

Activate Dialog oDlg CENTER Valid nOpcA > 0

IF ( nOpcA == 1 )

	MsgRun( "Resumo - Extraindo e gravando movimentação do período", "Aguarde...", {|| f_geraresumo() } )

	///Processa( {|| ProcEst() } )                                   ///Processa Resumo
	///Processa( {|| ProcDet() } )                                   ///Processa Detalhes
ELSE
	MsgInfo("Processamento cancelado!!!","Atenção")
ENDIF

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_geraresumo()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
X1      := 0
X6DATA  := GETMV('MV_ULMES')
dDatAnt := X6DATA
X6DATA  := ( X6DATA + 1 )
X6DATA  := LEFT(DTOS(X6DATA),6)
cDatPro := LEFT(dtos(dDatProc),6)
dDatIni := FirstDay(dDatProc)
cDatAnt := LEFT(DTOS( ( dDatIni - 1 ) ),6)
dDatFin := LastDay(dDatIni)
mvLocal := IIF(M->cNumEmp=="0301" , "02,60,62" , "01" )    ///"01,02,03,60,62" ) 
V4      := {}
ASIZE(V4,29)
V4[01] := {"0115","PLACA DE CIRCUITO IM     ","0115"}
V4[02] := {"0207","INTERRUPTOR HORARIO      ","0207"}
V4[03] := {"11  ","CONT TEMPO               ","411 "}
V4[04] := {"12  ","PROTECAO                 ","412 "}
V4[05] := {"13  ","NIVEL                    ","413 "}
V4[06] := {"14  ","CONT DIG TEMP QUENTE     ","414 "}
V4[07] := {"1401","CONTROLADOR DIGITAL      ","1401"}
V4[08] := {"1402","INDICADOR DIGITAL DE     ","1402"}
V4[09] := {"1405","CONTADOR DIGITAL         ","1405"}
V4[10] := {"1406","RELE DE TEMPO PROGRA     ","1406"}
V4[11] := {"15  ","SENSORES                 ","415 "}
V4[12] := {"16  ","DIVERSOS                 ","416 "}
V4[13] := {"17  ","INDICADOR                ","417 "}
V4[14] := {"18  ","CONTADOR DIGITAL         ","418 "}
V4[15] := {"192 ","CONT DIG TEMP REFRIG     ","4192"}
V4[16] := {"1934","CONTADOR DE TEMPO        ","1934"}
V4[17] := {"1969","CONTROLADOR ELETRONI     ","1969"}
V4[18] := {"20  ","RELE DE TEMPO            ","420 "}
V4[19] := {"2008","RELE ELETRONICO DIGI     ","2008"}
V4[20] := {"21  ","INTERRUPTOR DIGITAL      ","421 "}
V4[21] := {"211 ","INTERRUPTOR MECANICO     ","4211"}
V4[22] := {"22  ","PLACAS EXCETO USO INFO   ","422 "}
V4[23] := {"23  ","PLACAS USO INFO          ","423 "}
V4[24] := {"24  ","RELE ELETR.DIGITAL       ","424 "}
V4[25] := {"35  ","ACESSORIOS               ","435 "}           ///SAO PAULO
V4[26] := {"MODU","MODULO                   ","4MOD"}           ///SAO PAULO
V4[27] := {"ZZ0 ","SUB-CONJUNTO             ","497 "}           ///18
V4[28] := {"ZZ1 ","MATERIAL COMUM           ","498 "}
V4[29] := {"ZZ2 ","NAO ESPECIFICADO         ","499 "}
*
V4A := {}
ASIZE(V4A,20)
V4A[01] := {"411 ","11  ","CONT TEMPO               "}
V4A[02] := {"412 ","12  ","PROTECAO                 "}
V4A[03] := {"413 ","13  ","NIVEL                    "}
V4A[04] := {"414 ","14  ","CONT DIG TEMPERATURA     "}
V4A[05] := {"415 ","15  ","SENSORES                 "}
V4A[06] := {"416 ","16  ","DIVERSOS                 "}
V4A[07] := {"417 ","17  ","INDICADOR                "}
V4A[08] := {"418 ","18  ","CONTADOR DIGITAL         "}
V4A[09] := {"4192","192 ","CONT DIG TEMP REFRIG     "}
V4A[10] := {"420 ","20  ","RELE DE TEMPO            "}
V4A[11] := {"421 ","21  ","INTERRUPTOR DIGITAL      "}
V4A[12] := {"4211","211 ","INTERRUPTOR MECANICO     "}
V4A[13] := {"422 ","22  ","PLACAS EXCETO INFO       "}
V4A[14] := {"423 ","23  ","PLACAS USO INFO          "}
V4A[15] := {"424 ","24  ","RELE ELETR.DIGITAL       "}
V4A[16] := {"435 ","35  ","ACESSORIOS               "}
V4A[17] := {"4MOD","MODU","MODULO                   "}
V4A[18] := {"497 ","ZZ0 ","SUB-CONJUNTO             "}
V4A[19] := {"498 ","ZZ1 ","MATERIAL COMUM           "}
V4A[20] := {"499 ","ZZ2 ","NAO ESPECIFICADO         "}
*
V1 := {{},{},{},{},{},{},{},{}}     /// MAT-PRIMA,MAT-EMB,MAT-AUX,MAT-INT DE P3
FOR NX:=1 TO 8
    ASIZE(V1[NX],12)
    FOR IX:=1 TO 12
        V1[NX,IX]:=0
    NEXT
NEXT
SET(1,"OFF")
aNSeq   := {}
aNSeqPA := {}   ////Vetor das baixa de producao (RE1/RE2) para compor os valores de PA, nessas baixas, 
aPA     := {}
////
////
////
cQry  := "SELECT * FROM "+RetSqlName("SB1")
cQry  += " WHERE D_E_L_E_T_ = ' '"
cQry  += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
IF ( M->cNumEmp == "0301" )
	cQry  += " AND ( B1_COD = '00000005' OR B1_TIPO IN ('PA','MP','PI') AND B1_COD NOT IN ('00000001','00000002','00000003','00000004') )"
ELSE
	cQry  += " AND ( B1_COD = '00000005' OR B1_TIPO IN ('PA','PP','MP','PI') AND B1_COD NOT IN ('00000001','00000002','00000003','00000004') )"
ENDIF	
cQry  += " ORDER BY B1_TIPO,B1_COD "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

dbSelectArea("SF4")
dbSetOrder(1)
*
dbSelectArea("SC2")
dbSetOrder(1)
*
dbSelectArea("SB7")
dbSetOrder(1)
*
dbSelectArea("SB1")
dbSetOrder(1)
ProcRegua(Lastrec())
*
dbSelectArea("TB3")
dbGoTop()
DO WHILE !EOF()
   IF ( LastKey() == 286 )
      lContinua := .F.
      EXIT
   ENDIF
   IncProc()
   IF ( TB3->B1_TIPO $ "PA,PP" )
      AADD(aPA , TB3->B1_GRUPO + TB3->B1_COD + TB3->B1_CLCFAM )   //B1_CC )
      dbSkip()
      LOOP
   ENDIF
   B1CC     := "498 "               ////LEFT(B1_CC,4)
   B1CFAM   := TB3->B1_CLCFAM
   B1LOCPAD := TB3->B1_LOCPAD
   B1COD    := TB3->B1_COD
   B1TIPO   := TB3->B1_TIPO
	B1DESC   := TB3->B1_DESC
   IJ       := IIF(B1COD=="00000005       ", 5 , Tipo_Matl(B1COD,B1TIPO,B1LOCPAD,B1CFAM) )
	*
   dbSelectArea("SZT")
   dbSetOrder(3)
   dbSeek(xFilial("SZT")+TB3->B1_COD+cDatAnt,.T.)
   DO WHILE !EOF().AND.ZT_FILIAL==xFilial("SZT").AND.ZT_COD==TB3->B1_COD.AND.ZT_DATA==cDatAnt
	
      IF ( ZT_TPR=="EN".AND.ZT_TIPO<"5" )        ///.AND.ZT_VATU > 0.00 )
         B1CC := SZT->ZT_CC
         RecLock("TRB",.T.)                       ///1=M.PRIMA
         TRB->TB_TIPO   := SZT->ZT_TIPO           ///2=M.EMBALAGEM
         TRB->TB_TPR    := SZT->ZT_TPR            ///3=M.AUXILIAR
         TRB->TB_GRUPO  := SZT->ZT_GRUPO          ///4=P.INTERMEDIARIO
         TRB->TB_COD    := SZT->ZT_COD            ///5=M.DIVERSOS
         TRB->TB_VINI   := SZT->ZT_VATU           ///6=M.PRIMA EM P.I.
         TRB->TB_CC     := SZT->ZT_CC             ///7=P.ACABADO
         TRB->TB_QINI   := SZT->ZT_QFIM
         TRB->TB_P3DSI  := SZT->ZT_P3DSF
         TRB->TB_P3ESI  := SZT->ZT_P3ESF
         TRB->TB_QP3ESI := SZT->ZT_QP3ESF
         TRB->TB_VINII  := SZT->ZT_SDOI
         TRB->TB_VININ  := SZT->ZT_SDON
			IF ( SZT->ZT_TIPO <> STR(IJ,1) )
				TRB->TB_OBS := "1-ALT.TIPO P/"+STR(IJ,1)
			ENDIF
         MsUnlock()
         dbSelectArea("SZT")
      ENDIF
      dbSkip()
		
   ENDDO
	*
   B6QINID   := 0.00      ///VLR.INICIAL
	B6QINIDQ  := 0
   B6ENTRDN  := 0.00      ///VLR.ENTRADA DE TERCEIROS (N/ATUAL.ESTOQ)
	B6QENTRDN := 0
   B6SAIDN   := 0.00      ///VLR.SAIDA   DE TERCEIROS (N/ATUAL.ESTOQ)
	B6QSAIDN  := 0
   B6ENTRDS  := 0.00      ///VLR.ENTRADA DE TERCEIROS (ATUAL.ESTOQ)
	B6QENTRDS := 0
   B6SAIDS   := 0.00      ///VLR.SAIDA   DE TERCEIROS (ATUAL.ESTOQ)
	B6QSAIDS  := 0
   B6QINIE   := 0.00
	B6QINIEQ  := 0
   B6ENTREN  := 0.00      ///VLR.ENTRADA EM TERCEIROS (N/ATUAL.ESTOQ)
	B6QENTREN := 0
   B6SAIEN   := 0.00      ///VLR.SAIDA   EM TERCEIROS (N/ATUAL.ESTOQ)
	B6QSAIEN  := 0
   B6ENTRES  := 0.00      ///VLR.ENTRADA EM TERCEIROS (ATUAL.ESTOQ)
	B6QENTRES := 0
   B6SAIES   := 0.00      ///VLR.SAIDA   EM TERCEIROS (ATUAL.ESTOQ)
	B6QSAIES  := 0
   IF ( IJ < 5 )
      aVR := {}
      aVD := {}
      X1  := IJ
      X2  := ( X1 + 4 )

      Ext_P3(B1COD)

      V1[X1,1]  := V1[X1,1]  + B6QINID
      V1[X1,2]  := V1[X1,2]  + B6ENTRDS
      V1[X1,3]  := V1[X1,3]  + B6ENTRDN
      V1[X1,4]  := V1[X1,4]  + B6SAIDS
      V1[X1,5]  := V1[X1,5]  + B6SAIDN
      ///V1[X1,11] := V1[X1,11] + ( B6QINID + B6ENTRDS + B6ENTRDN - B6SAIDS - B6SAIDN )
      V1[X1,11] := V1[X1,11] + ( B6QINID + B6ENTRDS - B6SAIDS )                                     ///03/07/15
		*
		V1[X2,1]  := V1[X2,1]  + B6QINIE
      V1[X2,2]  := V1[X2,2]  + B6ENTRES
      V1[X2,3]  := V1[X2,3]  + B6ENTREN
      V1[X2,4]  := V1[X2,4]  + B6SAIES
      V1[X2,5]  := V1[X2,5]  + B6SAIEN
      ///V1[X2,11] := V1[X2,11] + ( B6QINIE - B6ENTRES - B6ENTREN + B6SAIES + B6SAIEN )
      V1[X2,11] := V1[X2,11] + ( B6QINIE - B6ENTRES + B6SAIES )                                    ///03/07/15
   ENDIF
   *
   //I1       := ASCAN(V4A,B1CC)
   //I3       := IIF(I1==0,12,I1)
   //B1GRUPO  := IIF(I1==0,"ZZ1 ",SUBS(V4A[I1],5,4))
   //I1       := ASCAN(V4,B1GRUPO)
   //B1GRUPO  := IIF(I1==0,"ZZ1 ",SUBS(V4[I1],1,4))
   I1       := ASCAN(V4 , { |xx| xx[3]==B1CC } )
   I3       := IIF(I1==0,29,I1)
   B1GRUPO  := IIF(I1==0 , "ZZ1 " , V4[I1,1] )
   //I1       := ASCAN(V4,B1GRUPO)
   //B1GRUPO  := IIF(I1==0,"ZZ1 ",SUBS(V4[I1],1,4))
	
   B1GRP     := B1GRUPO
   B1CC2     := B1CC
   D1ENTRDN  := 0.00      ///VLR.ENTRADA DE TERCEIROS (N/ATUAL.ESTOQ)
	D1QENTRDN := 0
   D1SAIDN   := 0.00      ///VLR.SAIDA   DE TERCEIROS (N/ATUAL.ESTOQ)
	D1QSAIDN  := 0
   D1ENTRDS  := 0.00      ///VLR.ENTRADA DE TERCEIROS (ATUAL.ESTOQ)
	D1QENTRDS := 0
   D1SAIDS   := 0.00      ///VLR.SAIDA   DE TERCEIROS (ATUAL.ESTOQ)
	D1QSAIDS  := 0
   D1ENTREN  := 0.00      ///VLR.ENTRADA EM TERCEIROS (N/ATUAL.ESTOQ)
	D1QENTREN := 0
   D1SAIEN   := 0.00      ///VLR.SAIDA   EM TERCEIROS (N/ATUAL.ESTOQ)
	D1QSAIEN  := 0
   D1ENTRES  := 0.00      ///VLR.ENTRADA EM TERCEIROS (ATUAL.ESTOQ)
	D1QENTRES := 0
   D1SAIES   := 0.00      ///VLR.SAIDA   EM TERCEIROS (ATUAL.ESTOQ)
	D1QSAIES  := 0
   *
   dbSelectArea("SB9")
   dbSetOrder(1)
   dbSeek(xFilial("SB9")+B1COD,.T.)
   DO WHILE !EOF().AND.B9_FILIAL==xFilial("SB9").AND.B9_COD==B1COD
      IF ( B9_LOCAL $ mvLocal )              
	      cData := LEFT(DTOS(B9_DATA),6)
	      IF ( cData == cDatPro )             /// Saldo do final do mes em processamento
   	      GravaTrab(B1COD,B1GRUPO,IJ,B1CC,"EN")
				IF ( SB9->B9_QINI > 0 )
					TRB->TB_VATU := ( TRB->TB_VATU + SB9->B9_VINI1 )  //VINIFF5 )
					TRB->TB_QFIM := ( TRB->TB_QFIM + SB9->B9_QINI )
				ENDIF	
         	MsUnlock()
	         dbSelectArea("SB9")
         ELSEIF ( M->cNumEmp=="0302".AND.cDatPro=="201306".AND.cData == "201305" )    ////Saldo inicial que montara' o primeiro periodo desse arquivo - SZT (Coelmatic/Mao)
   	      GravaTrab(B1COD,B1GRUPO,IJ,B1CC,"EN")
				IF ( SB9->B9_QINI > 0 )
					TRB->TB_QINI  := ( TRB->TB_QINI + SB9->B9_QINI )  //VINIFF5 )
					TRB->TB_VINI  := ( TRB->TB_VINI + SB9->B9_VINI1 )  //VINIFF5 )
					MsUnlock()
				ENDIF	
	         dbSelectArea("SB9")
         ELSEIF ( M->cNumEmp=="0302".AND.SB9->B9_LOCAL <> "01".AND.cDatPro=="201502".AND.cData=="201501" )                         ////Adicionando outros almoxs nao definidos anteriormente. Somente para este mes.
   	      GravaTrab(B1COD,B1GRUPO,IJ,B1CC,"EN")
				IF ( SB9->B9_QINI > 0 )
					TRB->TB_QOUTRAS := ( TRB->TB_QOUTRAS + SB9->B9_QINI )  //VINIFF5 )
					TRB->TB_OUTENT  := ( TRB->TB_OUTENT + SB9->B9_VINI1 )  //VINIFF5 )
					MsUnlock()
				ENDIF	
	         dbSelectArea("SB9")
   	   ENDIF
      ENDIF
      dbSkip()
   ENDDO
   *
   ///SELECT D3_COD,D3_OP,C2_PRODUTO,SUM(D3_QUANT) QUANT,B1_CLCFAM FROM SD3030 D3,SC2030 C2,SB1030 B1 WHERE D3.D_E_L_E_T_ = ' ' AND C2.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' '
   ///AND D3_ESTORNO = ' ' AND D3_CF = 'RE1' AND (C2_NUM+C2_ITEM+C2_SEQUEN) = LEFT(D3_OP,11) AND LEFT(D3_EMISSAO,6) = '201109' AND B1_COD = C2_PRODUTO
   ///GROUP BY D3_COD,D3_OP,C2_PRODUTO,B1_CLCFAM ORDER BY D3_COD
   dbSelectArea("SB2")
   dbSetOrder(1)
   dbSeek(xFilial("SB2")+B1COD,.T.)
   DO WHILE !EOF().AND.B2_FILIAL==xFilial("SB2").AND.B2_COD==B1COD
      IF ( !SB2->B2_LOCAL $ mvLocal )              
         dbSkip()
         Loop
      ENDIF
      B1GRUPO := B1GRP       //ZZ1
      B1CC    := B1CC2       //498

      IF ( cDatPro == x6data )

         GravaTrab(B1COD,B1GRUPO,IJ,B1CC,"EN")

			IF ( SB2->B2_QFIM > 0 )
				TRB->TB_VATU := ( TRB->TB_VATU + SB2->B2_VFIM1 )  //VFIMFF5 )
				TRB->TB_QFIM := ( TRB->TB_QFIM + SB2->B2_QFIM )
				MsUnlock()
			ENDIF	

      ENDIF
      *
      dbSelectArea("SD1")
      dbSetOrder(7)
      dbSeek(xFilial("SD1")+B1COD+SB2->B2_LOCAL+dtos(dDatIni),.T.)
      DO WHILE !EOF().AND.D1_FILIAL==xFilial("SD1").AND.D1_COD==B1COD.AND.D1_LOCAL==SB2->B2_LOCAL.AND.D1_DTDIGIT<=dDatFin.AND.IJ<6
         SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
         IF ( SF4->F4_ESTOQUE=="S" )
            IF ( !SF4->F4_PODER3 $ "RD".AND.SD1->D1_TIPO $ "NCD" )
               TBCC    := B1CC
               //B1CC    := LEFT(SD1->D1_CC,4)
               //I1      := ASCAN(V4A,B1CC)
               //B1GRUPO := IIF(I1==0,"ZZ1 ",SUBS(V4A[I1],5,4))
               //I1      := ASCAN(V4,B1GRUPO)
               //B1GRUPO := IIF(I1==0,"ZZ1 ",SUBS(V4[I1],1,4))
				   I1       := ASCAN(V4 , { |xx| xx[3]==B1CC } )
				   B1GRUPO  := IIF(I1==0 , "ZZ1 " , V4[I1,1] )

               GravaTrab(B1COD,B1GRUPO,IJ,TBCC,"EN")

               IF ( SD1->D1_TIPO $ "NCD" )
						///VIDE NF.000019255 DA COELMATIC/SP - JAN16 (REM.CONSERTO) - NAO SAI NA PLANILHA EM 'DE TERCEIROS'
                  IF ( SD1->D1_TIPO $ "NC" .AND. SD1->D1_CF $ "1101 ,1102 ,1124 ,2101 ,2102 ,2107 ,2124 ,2352 ,3101 ,3102 ,3107 " )
                     TRB->TB_ENTR  := TRB->TB_ENTR + SD1->D1_CUSTO   
                     TRB->TB_QENTR := TRB->TB_QENTR + SD1->D1_QUANT   
                     IF ( SD1->D1_CF $ "3101 ,3102 ,3107 " )
                        TRB->TB_CMPI := ( TRB->TB_CMPI + SD1->D1_CUSTO )
                     ELSEIF ( SD1->D1_CF $ "1101 ,1102 ,1124 ,2101 ,2102 ,2107 ,2124 ,2352 " )
                        TRB->TB_CMPN := ( TRB->TB_CMPN + SD1->D1_CUSTO )
                     ENDIF
                  ELSEIF ( SD1->D1_TIPO == "D" )
                     TRB->TB_DEVVDA  := TRB->TB_DEVVDA + SD1->D1_CUSTO   
                     TRB->TB_QDEVVDA := TRB->TB_QDEVVDA + SD1->D1_QUANT
                  ELSE
                     TRB->TB_OUTENT  := TRB->TB_OUTENT + SD1->D1_CUSTO   
                     TRB->TB_QOUTRAS := TRB->TB_QOUTRAS + SD1->D1_QUANT
                  ENDIF
                  MsUnlock()
                  B1CC := TBCC
               ENDIF
            ENDIF
         ENDIF
         IF ( SF4->F4_PODER3 $ "RD" )
            dbSelectArea("SB6")
            dbSetOrder(1)
            dbSeek(xFilial("SB6")+SD1->D1_COD+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_IDENTB6)
            IF ( !EOF() )
	            IF ( SB6->B6_TIPO == "D" )
   	            IF ( SF4->F4_ESTOQUE=="S" )
      	            D1ENTRDS := ( D1ENTRDS + SD1->D1_CUSTO )  
      	            D1QENTRDS := ( D1QENTRDS + SD1->D1_QUANT )  
         	      ELSE
            	      D1ENTRDN := ( D1ENTRDN + SD1->D1_CUSTO )  
            	      D1QENTRDN := ( D1QENTRDN + SD1->D1_QUANT ) 
               	ENDIF
	            ELSE
   	            IF ( SF4->F4_ESTOQUE=="S" )
      	            D1ENTRES := ( D1ENTRES + SD1->D1_CUSTO )   
      	            D1QENTRES := ( D1QENTRES + SD1->D1_QUANT )   
         	      ELSE
            	      D1ENTREN := ( D1ENTREN + SD1->D1_CUSTO )   
            	      D1QENTREN := ( D1QENTREN + SD1->D1_QUANT )   
               	ENDIF
               ENDIF
            ENDIF
         ENDIF
         dbSelectArea("SD1")
         dbSkip()
      ENDDO
      *
      dbSelectArea("SD2")
      dbSetOrder(6)
      dbSeek(xFilial("SD2")+B1COD+SB2->B2_LOCAL+dtos(dDatIni),.T.)
      DO WHILE !EOF().AND.D2_FILIAL==xFilial("SD2").AND.D2_COD==B1COD.AND.D2_LOCAL==SB2->B2_LOCAL.AND.D2_EMISSAO<=dDatFin.AND.IJ<6
         dbSelectArea("SF4")
         dbSetOrder(1)
         dbSeek(xFilial("SF4")+SD2->D2_TES)
         IF ( SF4->F4_ESTOQUE == "S".AND.!SF4->F4_PODER3 $ "RD".AND. SD2->D2_TIPO $ "NBCD" )
            TBCC    := B1CC
            //B1CC    := LEFT(SD2->D2_CC0,4)
            //I1      := ASCAN(V4A,B1CC)
            //B1GRUPO := IIF(I1==0,"ZZ1 ",SUBS(V4A[I1],5,4))
            //I1      := ASCAN(V4,B1GRUPO)
            //B1GRUPO := IIF(I1==0,"ZZ1 ",SUBS(V4[I1],1,4))
			   I1       := ASCAN(V4 , { |xx| xx[3]==B1CC } )
			   B1GRUPO  := IIF(I1==0 , "ZZ1 " , V4[I1,1] )

            GravaTrab(B1COD,B1GRUPO,IJ,TBCC,"EN")

            IF ( SD2->D2_TIPO $ "NC" )
     	         IF ( SD2->D2_CF $ "5101 /5102 /5107 /5401 /6101 /6102 /6107 /6401 /7101 /7102 /7107 " )
						TRB->TB_INS  := TRB->TB_INS + SD2->D2_CUSTO1   
						TRB->TB_QINS := TRB->TB_QINS + SD2->D2_QUANT
					ELSE
   	            TRB->TB_VOUTSAI := ( TRB->TB_VOUTSAI + SD2->D2_CUSTO1 )       
   	            TRB->TB_QOUTSAI := ( TRB->TB_QOUTSAI + SD2->D2_QUANT )       
					ENDIF
            ELSEIF ( SD2->D2_TIPO == "D" )
               TRB->TB_DEV  := TRB->TB_DEV + SD2->D2_CUSTO1   
					TRB->TB_QDEV := TRB->TB_QDEV + SD2->D2_QUANT
            ELSEIF ( SD2->D2_TIPO == "B" )
               TRB->TB_REQ  := TRB->TB_REQ + SD2->D2_CUSTO1                             ///MATERIAL ENVIADO P/FORNECEDOR NO EXTERIOR
					TRB->TB_QREQ := TRB->TB_QREQ + SD2->D2_QUANT
            ENDIF
            MsUnlock()
            B1CC := TBCC
         ENDIF
         IF ( SF4->F4_PODER3 $ "RD" )
            dbSelectArea("SB6")
            dbSetOrder(1)
            dbSeek(xFilial("SB6")+SD2->D2_COD+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_IDENTB6)
            IF ( !EOF() )
	            IF ( SB6->B6_TIPO == "D" )
   	            IF ( SF4->F4_ESTOQUE=="S" )
      	            D1SAIDS := ( D1SAIDS + SD2->D2_CUSTO1 )    
      	            D1QSAIDS := ( D1QSAIDS + SD2->D2_QUANT )    
         	      ELSE
            	      D1SAIDN := ( D1SAIDN + SD2->D2_CUSTO1 )    
            	      D1QSAIDN := ( D1QSAIDN + SD2->D2_QUANT )    
               	ENDIF
	            ELSE
   	            IF ( SF4->F4_ESTOQUE=="S" )
      	            D1SAIES := ( D1SAIES + SD2->D2_CUSTO1 )    
      	            D1QSAIES := ( D1QSAIES + SD2->D2_QUANT )    
         	      ELSE
            	      D1SAIEN := ( D1SAIEN + SD2->D2_CUSTO1 )    
            	      D1QSAIEN := ( D1QSAIEN + SD2->D2_QUANT )    
               	ENDIF
               ENDIF
            ENDIF
         ENDIF
         dbSelectArea("SD2")
         dbSkip()
      ENDDO
      *
		dbSelectArea("SD3")
      dbSetOrder(7)
      dbSeek(xFilial("SD3")+B1COD+SB2->B2_LOCAL+dtos(dDatIni),.T.)
      DO WHILE !EOF().AND.D3_FILIAL==xFilial("SD3").AND.D3_COD==B1COD.AND.D3_LOCAL==SB2->B2_LOCAL.AND.D3_EMISSAO<=dDatFin
         IF ( EMPTY(D3_ESTORNO) .AND. D3_CUSTO1 > 0.00 )
            IF ( SD3->D3_CF $ "DE4|RE4" )
					///
					///Nova definicao de outros almoxarifados (local padrao), a partir de Mar/15
					///
					nRecSD3  := SD3->(RECNO())
					D3NUMSEQ := SD3->D3_NUMSEQ
					D3CHAVE  := IIF(SD3->D3_CF == "RE4" , "E9" , "E0" )
					dbSetOrder(4)
					dbSeek(xFilial("SD3")+D3NUMSEQ+D3CHAVE)
					xLocal   := SD3->D3_LOCAL
					xProduto := SD3->D3_COD
					SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD))
					dbSelectArea("SD3")
					dbSetOrder(7)
					dbGoTo(nRecSD3)
               lGrava := ( SB1->B1_TIPO <> B1TIPO .OR. !xLocal $ mvLocal .OR. SD3->D3_COD <> xProduto )       ///Se for o mesmo tipo de produto ou se o local for diferente de local de processamento definido no inicio dessa rotina (mvLocal), nao processa.
            ELSE
               lGrava  := .T.
               lFlagPA := .F.
               IF ( !EMPTY(D3_OP) )
					   ///
						///As variaveis logicas "lFlagPA" e "lFlagPI" eh para determinar o consumo de MP no PA e PI no relatorio.
						///
                  dbSelectArea("SC2")
                  dbSetOrder(1)
                  dbSeek(xFilial("SC2")+LEFT(SD3->D3_OP,11))
                  SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
                  lFlagPA := ( SB1->B1_TIPO $ "PA/PP" )  
               ENDIF
            ENDIF
            IF ( lGrava )
               TBCC    := B1CC
               //B1CC    := LEFT(SD3->D3_CC,4)
               //I1      := ASCAN(V4A,B1CC)
               //B1GRUPO := IIF(I1==0,"ZZ1 ",SUBS(V4A[I1],5,4))
               //I1      := ASCAN(V4,B1GRUPO)
               //B1GRUPO := IIF(I1==0,"ZZ1 ",SUBS(V4[I1],1,4))
				   I1       := ASCAN(V4 , { |xx| xx[3]==B1CC } )
				   B1GRUPO  := IIF(I1==0 , "ZZ1 " , V4[I1,1] )

               GravaTrab(B1COD,B1GRUPO,IJ,TBCC,"EN")

               IF ( SD3->D3_DOC == "INVENT   " )
					
						SB7->(dbSeek(xFilial("SB7")+DTOS(SD3->D3_EMISSAO)+SD3->D3_COD+SD3->D3_LOCAL))
						
                  D3CUSTO1 := SD3->D3_CUSTO1        
                  D3QUANT  := SD3->D3_QUANT
                  IF SD3->D3_CF == 'RE0'
                     D3CUSTO1 := ( D3CUSTO1 * (-1) )
                     D3QUANT  := ( D3QUANT  * (-1) )
                  ENDIF
                  TRB->TB_INV := ( TRB->TB_INV + D3CUSTO1 )
                  TRB->TB_QAI := ( TRB->TB_QAI + D3QUANT  )
               ELSEIF SD3->D3_CF == "RE4"
   	            TRB->TB_VOUTSAI := ( TRB->TB_VOUTSAI + SD3->D3_CUSTO1 )       
   	            TRB->TB_QOUTSAI := ( TRB->TB_QOUTSAI + SD3->D3_QUANT )       
               ELSEIF SD3->D3_CF == "DE4"
						TRB->TB_OUTENT  := TRB->TB_OUTENT + SD3->D3_CUSTO1   
						TRB->TB_QOUTRAS := TRB->TB_QOUTRAS + SD3->D3_QUANT
      	         IF ( IJ == 4 )
         	         TRB->TB_VOUTENT := ( TRB->TB_VOUTENT + SD3->D3_CUSTO1 )  
            	      TRB->TB_QOUTENT := ( TRB->TB_QOUTENT + SD3->D3_QUANT  )
                  ENDIF
               ELSEIF SD3->D3_CF == "PR0"
                  TRB->TB_VPRD := ( TRB->TB_VPRD + SD3->D3_CUSTO1 )           
                  TRB->TB_QPRD := ( TRB->TB_QPRD + SD3->D3_QUANT  )
               ELSEIF SD3->D3_CF == "DE7"                                                        ///DESMANCHE
                  TRB->TB_OUTENT  := ( TRB->TB_OUTENT + SD3->D3_CUSTO1 )      
                  TRB->TB_QOUTRAS := ( TRB->TB_QOUTRAS + SD3->D3_QUANT )      
                  IF ( IJ == 4 )
                     TRB->TB_VOUTENT := ( TRB->TB_VOUTENT + SD3->D3_CUSTO1 )  
                     TRB->TB_QOUTENT := ( TRB->TB_QOUTENT + SD3->D3_QUANT  )
                  ENDIF
               ELSEIF SD3->D3_CF == "RE7"                                                        ///DESMANCHE
                  TRB->TB_VOUTSAI := ( TRB->TB_VOUTSAI + SD3->D3_CUSTO1 )  
                  TRB->TB_QOUTSAI := ( TRB->TB_QOUTSAI + SD3->D3_QUANT  )
               ELSEIF SD3->D3_TM $ "003,030,100,101"                                            
                  TRB->TB_OUTENT  := ( TRB->TB_OUTENT + SD3->D3_CUSTO1 )           
                  TRB->TB_QOUTRAS := ( TRB->TB_QOUTRAS + SD3->D3_QUANT )           
                 	IF ( IJ == 4 )
                    	TRB->TB_VOUTENT := ( TRB->TB_VOUTENT + SD3->D3_CUSTO1 )         
                     TRB->TB_QOUTENT := ( TRB->TB_QOUTENT + SD3->D3_QUANT  )
                  ENDIF
               ELSEIF SD3->D3_CF == "DE6"                                                        ///ENTRADA VALORIZADA
                  TRB->TB_OUTENT  := ( TRB->TB_OUTENT + SD3->D3_CUSTO1 )    
						TRB->TB_QOUTRAS := ( TRB->TB_QOUTRAS + SD3->D3_CUSTO1 )      
                  IF ( IJ == 4 )
                     TRB->TB_VOUTENT := ( TRB->TB_VOUTENT + SD3->D3_CUSTO1 )
                     TRB->TB_QOUTENT := ( TRB->TB_QOUTENT + SD3->D3_QUANT )
                  ENDIF
               ELSEIF SD3->D3_CF $ 'RE1|RE2|RE5'
                  TRB->TB_OP    := ( TRB->TB_OP    + SD3->D3_CUSTO1 )         
                  TRB->TB_QCONS := ( TRB->TB_QCONS + SD3->D3_QUANT )
						MsUnlock()
						*
						nRecTRB := TRB->(RECNO())
						D3OP    := SD3->D3_OP
						D3EMISS := SD3->D3_EMISSAO
						
						////
						////Grava itens de consumo em OP por tipo de familia
						////
						dbSelectArea("SD3")
						c_Qry := "SELECT TOP 1 D3_COD,D3_TIPO FROM "+RetSqlName("SD3")
						c_Qry += " WHERE D_E_L_E_T_ = ' ' AND D3_FILIAL = '"+xFilial("SD3")+"'"
						c_Qry += " AND D3_ESTORNO = ' ' AND D3_EMISSAO = '"+DTOS(D3EMISS)+"'"
						c_Qry += " AND D3_OP = '"+D3OP+"' AND D3_CF = 'PR0'"
						
						c_Qry := ChangeQuery(c_Qry)

						dbUseArea( .T., 'TOPCONN', TCGENQRY(,,c_Qry), 'TMPSD3', .T., .T.)
						
						SB1->(dbSeek(xFilial("SB1")+TMPSD3->D3_COD))
												
						IF ( TMPSD3->D3_TIPO $ "PA/PP" )                         ///Tem que considerar D3_TIPO em vez de B1_TIPO, pois qq alteracao do tipo do produto no decorrer do periodo, se ajusta no SD3.
							I1  := ASCAN(V4 , { |xx| xx[1]==SB1->B1_CLCFAM } )
							I1  := IIF(I1==0 , 29 , I1 )                        ///Consumo em PA ou grupo nao-especificado
						ELSEIF ( TMPSD3->D3_TIPO == "PI" )
							I1  := 27                                           ///Consumo em PI
						ELSE	
							I1  := 29                                           ///Consumo em grupo nao-especificado
						ENDIF
						xGRUPO := V4[I1,1] 
						
						TMPSD3->(dbCloseArea())

						////22/04/15   GravaTrab("99999999       " , V4[I1,1] , IJ , V4[I1,3] , "OP" )
						GravaTrab(PADR(V4[I1,3],nTamProd) , V4[I1,1] , IJ , V4[I1,3] , "OP" )
						
                  TRB->TB_OP    := ( TRB->TB_OP    + SD3->D3_CUSTO1 )         
                  TRB->TB_QCONS := ( TRB->TB_QCONS + SD3->D3_QUANT )						
						MsUnlock()

						/*
						IF SB1->B1_CLCFAM == "14  "
						GravaTrab(left(SD3->D3_COD,16)+" "+SD3->D3_NUMSEQ+" "+LEFT(SD3->D3_OP,6) , V4[I1,1] , IJ , V4[I1,3] , "PP" )

                  TRB->TB_OP    := ( TRB->TB_OP    + SD3->D3_CUSTO1 )         
                  TRB->TB_QCONS := ( TRB->TB_QCONS + SD3->D3_QUANT )						
						MsUnlock()
						
						ENDIF
						*/

						IF ( !lFlagPA )
							x1 := ij
							ij := 6

							GravaTrab(B1COD,B1GRUPO,IJ,TBCC,"EN")

							TRB->TB_OP    := ( TRB->TB_OP - SD3->D3_CUSTO1 )    
							TRB->TB_QCONS := ( TRB->TB_QCONS - SD3->D3_QUANT )						
							ij := x1
							MsUnlock()
						ENDIF

						dbSelectArea("TRB")
						dbGoTo(nRecTRB)
						RecLock("TRB",.F.)
						
               ELSEIF SD3->D3_TM == "507"
                  TRB->TB_SUC  := ( TRB->TB_SUC + SD3->D3_CUSTO1 )            
                  TRB->TB_QSUC := ( TRB->TB_QSUC + SD3->D3_QUANT )
               ELSEIF SD3->D3_CF $ 'RE0,RE6'
                  lSaida := .F.
                  IF ( !SD3->D3_TM $ "800/505/506/600/601/602" )
							IF ( !EMPTY(SD3->D3_OP) ) 
								TRB->TB_OP    := ( TRB->TB_OP   + SD3->D3_CUSTO1 )  //_CUSFF5 )
								TRB->TB_QCONS := ( TRB->TB_QCONS + SD3->D3_QUANT )
								//lSaida        := .F.
							ELSE
								TRB->TB_REQ  := ( TRB->TB_REQ + SD3->D3_CUSTO1 )     
								TRB->TB_QREQ := ( TRB->TB_QREQ + SD3->D3_QUANT )      
							ENDIF
                  ELSEIF ( SD3->D3_TM $ "506/800" )                                  ////( SD3->D3_TM == "506" ) ATE 29/02/16
                     TRB->TB_AJUSTE := ( TRB->TB_AJUSTE - SD3->D3_CUSTO1 )
							TRB->TB_VAJSAI := ( TRB->TB_VAJSAI + SD3->D3_CUSTO1 )      
							TRB->TB_QAJSAI := ( TRB->TB_QAJSAI + SD3->D3_QUANT )      
						ELSE	
							TRB->TB_VOUTSAI := ( TRB->TB_VOUTSAI + SD3->D3_CUSTO1 )
							TRB->TB_QOUTSAI := ( TRB->TB_QOUTSAI + SD3->D3_QUANT  )
                  ENDIF
                  IF ( lSaida )
                     IF ( IJ == 4 )
                        TRB->TB_VOUTSAI := ( TRB->TB_VOUTSAI + SD3->D3_CUSTO1 )
                        TRB->TB_QOUTSAI := ( TRB->TB_QOUTSAI + SD3->D3_QUANT  )
                     ENDIF
                  ENDIF
               ENDIF
               MsUnlock()
               B1CC := TBCC
					
               dbSelectArea("SD3")
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      dbSelectArea("SB2")
      dbSkip()
   ENDDO
   *
   B1GRUPO := B1GRP
   B1CC    := B1CC2

	///
	///Grava Poder de Terceiro - Temporario
	///
   GravaTrab(B1COD,B1GRUPO,IJ,B1CC,"EN")

   TRB->TB_P3DSI   := B6QINID
   TRB->TB_P3ESI   := B6QINIE
	TRB->TB_QP3ESI  := B6QINIEQ
   TRB->TB_P3DEC   := D1ENTRDS
   TRB->TB_P3DES   := D1ENTRDN
   TRB->TB_P3EEC   := D1ENTRES
	TRB->TB_QP3EEC  := D1QENTRES
   TRB->TB_P3EES   := D1ENTREN
   TRB->TB_P3DSC   := D1SAIDS
   TRB->TB_P3DSS   := D1SAIDN
   TRB->TB_P3ESC   := D1SAIES
	TRB->TB_QP3ESC  := D1QSAIES
   TRB->TB_P3ESS   := D1SAIEN
   TRB->TB_P3DSF   := ( TRB->TB_P3DSI + D1ENTRDS + D1ENTRDN - D1SAIDS - D1SAIDN )
   TRB->TB_P3ESF   := ( TRB->TB_P3ESI - D1ENTRES - D1ENTREN + D1SAIES + D1SAIEN )
   TRB->TB_QP3ESF  := ( TRB->TB_QP3ESI - D1QENTRES - D1QENTREN + D1QSAIES + D1QSAIEN )
   MsUnlock()
   dbSelectArea("TB3")
   dbSkip()
ENDDO

TB3->(dbCloseArea())

Inkey(2)

////
//// Verifica se no apontamento de producao houve baixa (RE1/RE2) de PA
////
cQry := "SELECT D3_QUANT,D3_CUSTO1,B1_CLCFAM FROM "+RetSqlName("SD3")+" D3,"+RetSqlName("SB1")+" B1,"+RetSqlName("SC2")+" C2"
cQry += " WHERE D3.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' AND C2.D_E_L_E_T_ = ' '"
cQry += " AND D3_FILIAL = '"+xFilial("SD3")+"' AND D3_LOCAL = '"+LEFT(mvLocal,2)+"'"
cQry += " AND D3_ESTORNO = ' '  AND LEFT(D3_EMISSAO,6) = '"+cDatPro+"' AND D3_CF IN ('RE1','RE2') AND D3_TIPO = 'PA'"
cQry += " AND C2_FILIAL = D3_FILIAL AND (C2_NUM+C2_ITEM+C2_SEQUEN) = D3_OP"
cQry += " AND B1_FILIAL = D3_FILIAL AND B1_COD = C2_PRODUTO AND B1_TIPO IN ('PA','PP')"
cQry += " ORDER BY D3_NUMSEQ "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

TcSetField("TB3","D3_QUANT","N",13,2)
TcSetField("TB3","D3_CUSTO1","N",14,4)

dbSelectArea("TB3")
dbGoTop()
DO WHILE !EOF()
	I1      := ASCAN(V4 , { |xx| xx[1]==TB3->B1_CLCFAM } )
	I1      := IIF(I1==0 , 29 , I1 )
	xGRUPO  := V4[I1,1] 
					
	GravaTrab("99999999       " , V4[I1,1] , 5 , V4[I1,3] , "OP" )

   TRB->TB_OP    := ( TRB->TB_OP    + TB3->D3_CUSTO1 )         
   TRB->TB_QCONS := ( TRB->TB_QCONS + TB3->D3_QUANT )						
	MsUnlock()
	
	dbSelectArea("TB3")
	dbSkip()
ENDDO

TB3->(dbCloseArea())

////
////Grava o movimento de Poder de Terceiros - Base de Dados
////
FOR NX:=1 TO 8
    IF ( NX == 1 )
       N2 := "DE3 "
       N1 := 0
    ELSEIF ( NX == 5 )
       N2 := "EM3 "
       N1 := 0
    ENDIF
    N1 := ( N1 + 1 )
    dbSelectArea("SZT")
    dbSetOrder(2)
    dbSeek(xFilial("SZT")+cDatPro+"P3"+N2+STR(N1,1)+"999999                        ")
    RecLock("SZT",EOF())
    SZT->ZT_FILIAL := xFilial("SZT")
    SZT->ZT_DATA   := cDatPro
    SZT->ZT_TIPO   := STR(N1,1)
    SZT->ZT_TPR    := "P3"
    SZT->ZT_GRUPO  := N2
    SZT->ZT_COD    := "999999"
    SZT->ZT_VINI   := V1[NX,1]    ///Saldo Inicial
    SZT->ZT_ENTR   := V1[NX,2]    ///Entrada c/estoque
    SZT->ZT_OUTENT := V1[NX,3]    ///Entrada s/estoque
    SZT->ZT_REQ    := V1[NX,4]    ///Saida   c/estoque
    SZT->ZT_SUC    := V1[NX,5]    ///Saida   s/estoque
    SZT->ZT_VATU   := V1[NX,11]   ///Saldo Final
    MsUnlock()
NEXT
////
////Grava o movimento de Estoque - MP/PI
////
dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
   nTempo := 0.0000
   IF ( TB_TIPO=="4" )
      nTempo := TempoP(TRB->TB_COD)
   ENDIF
   nTotal := ( ABS(TB_AJUSTE)+ABS(TB_VINI)+ABS(TB_VINII)+ABS(TB_VININ)+ABS(TB_SDOI)+ABS(TB_SDON)+ABS(TB_ENTR)+ABS(TB_OUTENT)+ABS(TB_REQ)+ABS(TB_DEVVDA) )
   nTotal += ( ABS(TB_SUC)+ABS(TB_OP)+ABS(TB_INV)+ABS(TB_INS)+ABS(TB_VATU)+ABS(TB_VOUTENT)+ABS(TB_VOUTSAI)+ABS(TB_VPRD)+ABS(TB_P3EEC)+ABS(TB_P3ESC) )
   IF ( nTotal > 0 )
	   dbSelectArea("SZT")
   	dbSetOrder(2)
   	dbSeek(xFilial("SZT")+cDatPro+"EN"+TRB->TB_GRUPO+TRB->TB_TIPO+TRB->TB_COD)
		IF ( SZT->(EOF()) )
			RecLock("SZT",.T.)
			SZT->ZT_FILIAL := xFilial("SZT")
			SZT->ZT_DATA   := cDatPro
			SZT->ZT_TPR    := TRB->TB_TPR
			SZT->ZT_COD    := TRB->TB_COD
			SZT->ZT_GRUPO  := TRB->TB_GRUPO
			SZT->ZT_TIPO   := TRB->TB_TIPO
		ELSE
			RecLock("SZT",.F.)
		ENDIF
   	SZT->ZT_TEMPO    := nTempo
	   SZT->ZT_AJUSTE   := TRB->TB_AJUSTE
	   SZT->ZT_VAJENT   := TRB->TB_VAJENT
	   SZT->ZT_QAJENT   := TRB->TB_QAJENT
	   SZT->ZT_VAJSAI   := TRB->TB_VAJSAI
	   SZT->ZT_QAJSAI   := TRB->TB_QAJSAI
   	SZT->ZT_VINI     := TRB->TB_VINI
	   SZT->ZT_VINII    := TRB->TB_VINII
   	SZT->ZT_VININ    := TRB->TB_VININ
      SZT->ZT_DEVVDA   := TRB->TB_DEVVDA
      SZT->ZT_QDEVVDA  := TRB->TB_QDEVVDA
      SZT->ZT_CMPI     := TRB->TB_CMPI
      SZT->ZT_CMPN     := TRB->TB_CMPN
	   SZT->ZT_ENTR     := TRB->TB_ENTR
	   SZT->ZT_QENTR    := TRB->TB_QENTR
   	SZT->ZT_OUTENT   := TRB->TB_OUTENT
	   SZT->ZT_QOUTRAS  := TRB->TB_QOUTRAS
	   SZT->ZT_REQ      := TRB->TB_REQ
	   SZT->ZT_QREQ     := TRB->TB_QREQ
   	SZT->ZT_SUC      := TRB->TB_SUC
	   SZT->ZT_OP       := TRB->TB_OP
   	SZT->ZT_INV      := TRB->TB_INV
	   SZT->ZT_DEV      := TRB->TB_DEV
	   SZT->ZT_QDEV     := TRB->TB_QDEV
   	SZT->ZT_INS      := TRB->TB_INS
	   SZT->ZT_QINS     := TRB->TB_QINS
	   SZT->ZT_VATU     := TRB->TB_VATU
   	SZT->ZT_VOUTENT  := TRB->TB_VOUTENT
	   SZT->ZT_VOUTSAI  := TRB->TB_VOUTSAI
   	SZT->ZT_QINI     := TRB->TB_QINI
	   SZT->ZT_QFIM     := TRB->TB_QFIM
   	SZT->ZT_QPRD     := TRB->TB_QPRD
	   SZT->ZT_QCONS    := TRB->TB_QCONS
   	SZT->ZT_QOUTENT  := TRB->TB_QOUTENT
	   SZT->ZT_QOUTSAI  := TRB->TB_QOUTSAI
   	SZT->ZT_QAI      := TRB->TB_QAI
	   SZT->ZT_QSUC     := TRB->TB_QSUC
   	SZT->ZT_VPRD     := TRB->TB_VPRD
	   SZT->ZT_P3DEC    := TRB->TB_P3DEC
   	SZT->ZT_P3EEC    := TRB->TB_P3EEC
	   SZT->ZT_P3DES    := TRB->TB_P3DES
   	SZT->ZT_P3EES    := TRB->TB_P3EES
	   SZT->ZT_P3DSC    := TRB->TB_P3DSC
   	SZT->ZT_P3ESC    := TRB->TB_P3ESC
	   SZT->ZT_P3DSS    := TRB->TB_P3DSS
   	SZT->ZT_P3ESS    := TRB->TB_P3ESS
	   SZT->ZT_P3DSF    := TRB->TB_P3DSF
   	SZT->ZT_P3ESF    := TRB->TB_P3ESF
	   SZT->ZT_QP3EEC   := TRB->TB_QP3EEC
	   SZT->ZT_QP3ESC   := TRB->TB_QP3ESC
	   SZT->ZT_QP3ESF   := TRB->TB_QP3ESF
	   SZT->ZT_CC       := TRB->TB_CC
		SZT->ZT_OBS      := TRB->TB_OBS
   	MsUnlock()
		*
	   dbSelectArea("TRB")
   ENDIF
   dbSkip()
ENDDO

TRB->(dbCloseArea())

////
//// Verifica se existe alteracao do tipo de produto, atual em relacao ao mes passado, para fazer a transferencia de estoque.
////
cQry := "SELECT * FROM "+RetSqlName("SZT")
cQry += " WHERE D_E_L_E_T_ = ' '"
cQry += " AND ZT_FILIAL = '"+xFilial("SZT")+"'"
cQry += " AND ZT_DATA   = '"+cDatPro+"'"
cQry += " AND ZT_TPR    = 'EN'"
cQry += " AND ZT_TIPO   < '5'"
cQry += " AND LEFT(ZT_OBS,1) = '1' "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	dbSelectArea("SZT")
	dbSetOrder(2)
	dbSeek(xFilial("SZT")+cDatPro+"EN"+TMP->ZT_GRUPO+TMP->ZT_TIPO+TMP->ZT_COD)
	IF ( !EOF() )
	   RecLock("SZT",.F.)
		SZT->ZT_AJUSTE   := ( SZT->ZT_AJUSTE + ( TMP->ZT_VINI * (-1) ) )
		///SZT->ZT_VOUTSAI  := TMP->ZT_VINI
		///SZT->ZT_QOUTSAI  := TMP->ZT_QINI
	ENDIF
	*
	cTipAlt := SUBS(TMP->ZT_OBS,14,1)

	dbSeek(xFilial("SZT")+cDatPro+"EN"+TMP->ZT_GRUPO+cTipAlt+TMP->ZT_COD)
	IF ( !EOF() )
	   RecLock("SZT",.F.)
		SZT->ZT_AJUSTE   := ( SZT->ZT_AJUSTE + TMP->ZT_VINI )
		///SZT->ZT_VOUTENT  := TMP->ZT_VINI
		///SZT->ZT_QOUTENT  := TMP->ZT_QINI
	ENDIF
	*
	dbSelectArea("TMP")
	dbSkip()
ENDDO

TMP->(dbCloseArea())

Return

//////////////////////////////////////////////////////////////////////////////////
Static Function GravaTrab(xCod,xGrp,xTp,xCC,xTpr)
//////////////////////////////////////////////////////////////////////////////////
Local lEof
Local X2 := STR(xTp,1)

dbSelectArea("TRB")
dbSeek(xCod+xGrp+X2+xTpr)
lEof := EOF()
IF ( lEof )
   RecLock("TRB",.T.)
   TRB->TB_COD   := xCod
   TRB->TB_GRUPO := xGrp
   TRB->TB_TIPO  := X2
   TRB->TB_TPR   := xTpr
   TRB->TB_CC    := xCC
   MsUnlock()
ENDIF
RecLock("TRB",.F.)
Return(lEof)

***************************************************
Static Function Tipo_Matl(fCod,fTipo,fLocPad,fCfam)
***************************************************
IF ( fTipo == "PI" )
   IZ := 4
ELSEIF ( fTipo == "SS" )
   IZ := 5	
ELSEIF ( fTipo == "MO" )     ///ALTERADO EM 26/05/06
   IZ := 8
ELSE
   IZ := IIF(fCfam $ "EMB ,EMBA,ACES" , 2 ,IIF(fCfam = "MAUX" , 3 , 1 ) )
ENDIF
Return(iz)

*****************************
Static Function TempoP(cxPrd)
*****************************
Local xAlias := Alias()

VS     := {}
cMod   := SPACE(30)
nMinut := 0
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cxPrd,.T.)
DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COD==cxPrd.AND.EMPTY(cMod)
   IF ( G1_INI <= ddatabase .AND. G1_FIM >= ddatabase )
      nxRecNo := RECNO()
      cxComp  := G1_COMP
      dbSeek(xFilial("SG1")+cxComp,.T.)
      IF ( G1_COD == cxComp )
         AADD(VS,cxComp)
      ENDIF
      dbGoTo(nxRecNo)
      IF ( LEFT(G1_COMP,3) == "MOD" )
         cMod   := G1_COMP
         nMinut := G1_QUANT   ///IIF(G1_FIM >= ddatabase,G1_QUANT,0)
      ENDIF
   ENDIF
   dbSkip()
ENDDO
kx := 1
DO WHILE kx <= LEN(VS)
   cComponente := VS[kx]
   dbSeek(xFilial("SG1")+cComponente,.T.)
   DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COD==cComponente
      IF ( G1_INI <= ddatabase .AND. G1_FIM >= ddatabase )
         nxRecNo := RECNO()
         cxComp  := G1_COMP
         dbSeek(xFilial("SG1")+cxComp)
         IF ( G1_COD == cxComp )
            AADD(VS,cxComp)
         ENDIF
         dbGoTo(nxRecNo)
         IF ( LEFT(G1_COMP,3) == "MOD" )   //( G1_COMP==cMod .AND. !LEFT(G1_COD,6) $ "426691|426782" )
            nMinut := ( nMinut + G1_QUANT )
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   kx := kx +1
ENDDO
nMinut := ROUND(nMinut*60,4)
dbSelectArea(xAlias)

Return(nMinut)

*****************************
Static Function Ext_P3(cxPrd)
*****************************
Local dDataIni := IIF(M->cNumEmp=="0301",CTOD("01/01/2011"),CTOD("01/04/2013") )
Local lAchou   

dbSelectarea("SD1")
dbSetOrder(7)
*
dbSelectarea("SD2")
dbSetOrder(6)
*
dbSelectArea("SB6")
dbSetOrder(1)
dbSeek(xFilial("SB6")+cxPrd,.T.)
DO WHILE !EOF().AND.B6_FILIAL==xFilial("SB6").AND.B6_PRODUTO==cxPrd
   IF ( B6_DTDIGIT >= dDataIni .AND. B6_DTDIGIT <= dDatFin .AND. SB6->B6_LOCAL $ mvLocal )
      IF ( SB6->B6_PODER3=="R" )
			SF4->(dbSeek(xFilial("SF4")+SB6->B6_TES))
		   IF ( SB6->B6_TIPO == "D" )
				SD1->(dbSeek(xFilial("SD1")+SB6->B6_PRODUTO+SB6->B6_LOCAL+DTOS(SB6->B6_DTDIGIT)+SB6->B6_IDENT))
			   lAchou := ( SD1->(!EOF()) .AND. SD1->D1_CF $ "1901 ,1905 ,1908 ,1912 ,1915 ,1916 ,1917 ,1920 ,2901 ,2905 ,2908 ,2912 ,2915 ,2916 ,2917 ,2920 " )
			ELSE
				SD2->(dbSeek(xFilial("SD2")+SB6->B6_PRODUTO+SB6->B6_LOCAL+DTOS(SB6->B6_EMISSAO)+SB6->B6_IDENT))
				lAchou := ( SD2->(!EOF()) .AND. SD2->D2_CF $ "5901 ,5905 ,5908 ,5912 ,5914 ,5915 ,5917 ,5920 ,6901 ,6905 ,6908 ,6912 ,6914 ,6915 ,6917 ,6920 " )
			ENDIF
			IF ( lAchou )
				AADD(aVR , { SB6->B6_TIPO          , ;
								 DTOS(SB6->B6_DTDIGIT) , ;
								 SB6->B6_IDENT         , ;
								 SB6->B6_CUSTO1        , ;
								 SB6->B6_ESTOQUE       , ;
								 SB6->B6_PRODUTO       , ;
								 SB6->B6_QUANT         } )     //SB6->B6_CC0)
			ENDIF					 
		ELSE
			I1 := ASCAN( aVD , { |xx| xx[1]==SB6->B6_IDENT } )
			IF ( I1 == 0 )
				AADD(aVD , { SB6->B6_IDENT   , ;
								 SB6->B6_PRODUTO , ;
								 SF4->F4_ESTOQUE } )
			ENDIF					
      ENDIF
   ENDIF
   dbSkip()
ENDDO
aSort(aVR,,,{|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )
aSort(aVD,,,{|x,y| x[1]+x[2] < y[1]+y[2] } )
////
////Verifica se a Remessa das entradas (devolucao/retorno) ocorridas a partir da data inicial estah antes do periodo inicial.
////
dbSelectArea("SB6")
dbSetOrder(3)
FOR nx:=1 TO LEN(aVD)
    I1 := ASCAN( aVR , { |xx| xx[3]==aVD[nx,1] } )
	 IF ( I1 = 0 )
		 SB6->(dbSeek(xFilial("SB6")+aVD[nx,1]+aVD[nx,2]+"R"))
		 IF ( SB6->(!EOF()) )
		   IF ( SB6->B6_TIPO == "D" )
				SD1->(dbSeek(xFilial("SD1")+SB6->B6_PRODUTO+SB6->B6_LOCAL+DTOS(SB6->B6_DTDIGIT)+SB6->B6_IDENT))
			   lAchou := ( SD1->(!EOF()) .AND. SD1->D1_CF $ "1901 ,1905 ,1908 ,1912 ,1915 ,1916 ,1917 ,1920 ,2901 ,2905 ,2908 ,2912 ,2915 ,2916 ,2917 ,2920 " )
			ELSE
				SD2->(dbSeek(xFilial("SD2")+SB6->B6_PRODUTO+SB6->B6_LOCAL+DTOS(SB6->B6_EMISSAO)+SB6->B6_IDENT))
				lAchou := ( SD2->(!EOF()) .AND. SD2->D2_CF $ "5901 ,5905 ,5908 ,5912 ,5914 ,5915 ,5917 ,5920 ,6901 ,6905 ,6908 ,6912 ,6914 ,6915 ,6917 ,6920 " )
			ENDIF
			IF ( lAchou )
				AADD(aVR , { SB6->B6_TIPO          , ;
								 DTOS(SB6->B6_DTDIGIT) , ;
								 SB6->B6_IDENT         , ;
								 SB6->B6_CUSTO1        , ;
								 SB6->B6_ESTOQUE       , ;
								 SB6->B6_PRODUTO       , ;
								 SB6->B6_QUANT         } )     //SB6->B6_CC0)
			 ENDIF
		 ENDIF
    ENDIF
NEXT
NX := 1
DO WHILE NX <= LEN(aVR)
   B6DATA  := LEFT(aVR[NX,2],6)
   B6TIPO  := aVR[NX,1]
   B6IDENT := aVR[NX,3]
   B6CUSTO := aVR[NX,4]
   B6ESTOQ := aVR[NX,5]
	B6QUANT := aVR[NX,7]
   IF ( VAL(B6DATA) < VAL(cDatPro) )
      B6QINID  := B6QINID  + IIF(B6TIPO=="D",B6CUSTO,0)
      B6QINIE  := B6QINIE  + IIF(B6TIPO=="E",B6CUSTO,0)
      B6QINIDQ := B6QINIDQ + IIF(B6TIPO=="D",B6QUANT,0)
      B6QINIEQ := B6QINIEQ + IIF(B6TIPO=="E",B6QUANT,0)
   ELSEIF ( B6DATA == cDatPro )
      IF B6ESTOQ == "S"
         B6ENTRDS  := B6ENTRDS  + IIF(B6TIPO=="D",B6CUSTO,0)
         B6SAIES   := B6SAIES   + IIF(B6TIPO=="E",B6CUSTO,0)
         B6QENTRDS := B6QENTRDS + IIF(B6TIPO=="D",B6QUANT,0)
         B6QSAIES  := B6QSAIES  + IIF(B6TIPO=="E",B6QUANT,0)
      ELSE
         B6ENTRDN  := B6ENTRDN  + IIF(B6TIPO=="D",B6CUSTO,0)
         B6SAIEN   := B6SAIEN   + IIF(B6TIPO=="E",B6CUSTO,0)
         B6QENTRDN := B6QENTRDN + IIF(B6TIPO=="D",B6QUANT,0)
         B6QSAIEN  := B6QSAIEN  + IIF(B6TIPO=="E",B6QUANT,0)
      ENDIF
   ENDIF
	SB6->(dbSeek(xFilial("SB6")+B6IDENT,.T.))
	DO WHILE ( SB6->(!EOF()).AND.SB6->B6_FILIAL==xFilial("SB6").AND.SB6->B6_IDENT==B6IDENT )
	   IF ( SB6->B6_PODER3 <> "R" )
			SF4->(dbSeek(xFilial("SF4")+SB6->B6_TES))
			B6DATA := LEFT(DTOS(SB6->B6_DTDIGIT),6)
         IF ( VAL(B6DATA) < VAL(cDatPro) )
            B6QINID  := B6QINID  - IIF(B6TIPO=="D",SB6->B6_CUSTO1,0)
            B6QINIE  := B6QINIE  - IIF(B6TIPO=="E",SB6->B6_CUSTO1,0)
            B6QINIDQ := B6QINIDQ - IIF(B6TIPO=="D",SB6->B6_QUANT,0)
            B6QINIEQ := B6QINIEQ - IIF(B6TIPO=="E",SB6->B6_QUANT,0)
         ELSEIF ( B6DATA == cDatPro )
            IF SF4->F4_ESTOQUE == "S"                                              /////Carlos: 02/10/2013 --- SB6->B6_ESTOQUE == "S"
               B6SAIDS   := B6SAIDS   + IIF(B6TIPO=="D",SB6->B6_CUSTO1,0)
               B6ENTRES  := B6ENTRES  + IIF(B6TIPO=="E",SB6->B6_CUSTO1,0)
               B6QSAIDS  := B6QSAIDS  + IIF(B6TIPO=="D",SB6->B6_QUANT,0)
               B6QENTRES := B6QENTRES + IIF(B6TIPO=="E",SB6->B6_QUANT,0)
            ELSE
               B6SAIDN   := B6SAIDN   + IIF(B6TIPO=="D",SB6->B6_CUSTO1,0)
               B6ENTREN  := B6ENTREN  + IIF(B6TIPO=="E",SB6->B6_CUSTO1,0)
               B6QSAIDN  := B6QSAIDN  + IIF(B6TIPO=="D",SB6->B6_QUANT,0)
               B6QENTREN := B6QENTREN + IIF(B6TIPO=="E",SB6->B6_QUANT,0)
            ENDIF
         ENDIF
      ENDIF
		SB6->(dbSkip())
   ENDDO
   NX := ( NX + 1 )
ENDDO

Return