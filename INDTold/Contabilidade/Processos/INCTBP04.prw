#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INDA130  ³ Autor ³ Reinaldo Magalhaes    ³ Data ³ 18.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Acerto de lancamentos contabeis por centro de custos       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico INDT                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros usados na rotina                   ³
//³ mv_par01         Data de ?                    ³
//³ mv_par02         Data Ate?                    ³
//³ mv_par03         Matr. de ?                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function INCTBP04()//INDA130()
   
   Local cPerg, cCadastro, aSays, aButtons, nOpca
   Local m_FILIAL,m_DATALC,m_LOTE,m_SBLOTE,m_DOC,m_LINHA,m_MOEDLC,m_DC,m_DEBITO,m_CREDIT,m_DCD,m_DCC,m_VALOR
   Local m_MOEDAS,m_HP,m_HIST,m_CCD,m_CCC,m_ITEMD,m_ITEMC,m_CLVLDB,m_CLVLCR,m_ATIVDE,m_ATIVCR,m_EMPORI
   Local m_FILORI,m_INTERC,m_TPSALD,m_SEQUEN,m_MANUAL,m_ORIGEM,m_LP,m_SEQLAN,m_DTVENC,m_SLBASE
   Local m_DTLP,m_DATATX,m_TAXA,m_VLR01,m_VLR02,m_VLR03,m_VLR04,m_VLR05,m_CRCONV,m_CRITER
   Local m_KEY,m_SEGOFI,m_DTCV3,m_SIATA

   cPerg := Padr("IND130",Len(SX1->X1_GRUPO))
   ValidPerg(cPerg)
   Pergunte(cPerg,.F.)

   cCadastro := OemtoAnsi("Ajuste nos lancamentos contabeis da folha por centro de custos")
   aSays     := {}
   aButtons  := {}
   nOpca     := 0

   AADD(aSays,OemToAnsi("Esta rotina ira acertar os valores dos lancamentos contabeis da folha-8890  ") )
   AADD(aSays,OemToAnsi("de acordo com o percentual informado no parametro pelo usuario. Transferindo ") )
   AADD(aSays,OemToAnsi("este valor para o centro de custos de destino.                              ") )

   AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
   AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
   AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

   FormBatch( cCadastro, aSays, aButtons )

   If nOpca == 1
      Processa({|| Acertar() },"Acertando valores...")
   EndIf

Return

////////////////////////
Static Function Acertar()
   Local cTmp:= "CT2" // "TMP" "CT2" <-- Quando for executar oficialmente
   Local aDbf, cArq, cQuery, nRegis, vCT2, n_ValDif, n_ValNew

   //- Cria DBF temporario para guardar os registros do CT2 gerados pela rotina antes de colocar na base oficial
   aDbf   := CT2->( dbStruct() )
   cArq   := CriaTrab( aDbf , .T. )
   Use &cArq Alias TMP New Exclusive
   
   cQuery := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"' AND "
   cQuery += "D_E_L_E_T_ = ' ' AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"' AND "
   cQuery += "CT2_LOTE = '008890' AND CT2_TPSALD = '"+mv_par06+"' AND "
   cQuery += "(CT2_ITEMD = '"+mv_par03+"' OR CT2_ITEMC = '"+mv_par03+"') AND "
   cQuery += "(CT2_CCD = '"+mv_par04+"' OR CT2_CCC = '"+mv_par04+"')"
   
   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
   nRegis := SOMA
   dbCloseArea()

   cQuery := StrTran(cQuery,"COUNT(*) SOMA","*, R_E_C_N_O_ CT2_RECNO")
   cQuery += " ORDER BY CT2_DATA, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
   ProcRegua(nRegis)
   
   While !Eof()

      IncProc("Acertando valores...")

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Ajustando valores nas tabelas                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      n_ValDif := INT(QRY->CT2_VALOR * ( mv_par07 / 100))
      n_ValNew := QRY->CT2_VALOR - n_ValDif
      
      //- Guarda os conteudos do campos do CT2
      dbSelectArea("CT2")
      dbGoTo(QRY->CT2_RECNO)
      
      m_FILIAL:=  CT2->CT2_FILIAL
	  m_DATALC:=  CT2->CT2_DATA
      m_LOTE  :=  CT2->CT2_LOTE 
      m_SBLOTE:=  CT2->CT2_SBLOTE
      m_DOC   :=  IF(mv_par07 = 0, CT2->CT2_DOC, "8"+Substr(CT2->CT2_DOC,2,5))
      m_LINHA :=  CT2->CT2_LINHA
      m_MOEDLC:=  CT2->CT2_MOEDLC
      m_DC    :=  CT2->CT2_DC
      m_DEBITO:=  CT2->CT2_DEBITO
      m_CREDIT:=  CT2->CT2_CREDIT
      m_DCD   :=  CT2->CT2_DCD    
      m_DCC   :=  CT2->CT2_DCC
      m_VALOR :=  CT2->CT2_VALOR
      m_MOEDAS:=  CT2->CT2_MOEDAS
      m_HP    :=  CT2->CT2_HP
      m_HIST  :=  CT2->CT2_HIST
      m_CCD   :=  CT2->CT2_CCD
      m_CCC   :=  CT2->CT2_CCC
      m_ITEMD :=  CT2->CT2_ITEMD
      m_ITEMC :=  CT2->CT2_ITEMC
      m_CLVLDB:=  CT2->CT2_CLVLDB
      m_CLVLCR:=  CT2->CT2_CLVLCR
      m_ATIVDE:=  CT2->CT2_ATIVDE
      m_ATIVCR:=  CT2->CT2_ATIVCR
      m_EMPORI:=  CT2->CT2_EMPORI
      m_FILORI:=  CT2->CT2_FILORI
      m_INTERC:=  CT2->CT2_INTERC
      m_TPSALD:=  CT2->CT2_TPSALD
      m_SEQUEN:=  CT2->CT2_SEQUEN
      m_MANUAL:=  CT2->CT2_MANUAL
      m_ORIGEM:=  CT2->CT2_ORIGEM
      m_LP    :=  CT2->CT2_LP 
      m_SEQLAN:=  CT2->CT2_SEQLAN
      m_DTVENC:=  CT2->CT2_DTVENC
      m_SLBASE:=  CT2->CT2_SLBASE
      m_DTLP  :=  CT2->CT2_DTLP
      m_DATATX:=  CT2->CT2_DATATX 
      m_TAXA  :=  CT2->CT2_TAXA
      m_VLR01 :=  CT2->CT2_VLR01
      m_VLR02 :=  CT2->CT2_VLR02
      m_VLR03 :=  CT2->CT2_VLR03
      m_VLR04 :=  CT2->CT2_VLR04
      m_VLR05 :=  CT2->CT2_VLR05
      m_CRCONV:=  CT2->CT2_CRCONV
      m_CRITER:=  CT2->CT2_CRITER
      m_KEY   :=  CT2->CT2_KEY
      m_SEGOFI:=  CT2->CT2_SEGOFI
      m_DTCV3 :=  CT2->CT2_DTCV3
      m_SIATA :=  CT2->CT2_SIATA
      m_ROTINA:=  CT2->CT2_ROTINA
      m_AGLUT :=  CT2->CT2_AGLUT
      m_SEQHIS:=  CT2->CT2_SEQHIS

      If mv_par07 = 0 //- Percentual de diferenca
         dbSelectArea("CT2") 
         RecLock("CT2",.F.)
         dbDelete()
         MsUnLock()
      Else   
         //- Ajusta valor no CT2
         dbSelectArea("CT2") 
         RecLock("CT2",.F.)
         CT2->CT2_VALOR:= n_ValNew
         MsUnLock()
      Endif   
      
      //- Gravando dados para o novo centro de custos
      dbSelectArea("CT2")
      RecLock("CT2",.T.)
      CT2->CT2_FILIAL:=  m_FILIAL
	  CT2->CT2_DATA  :=  m_DATALC
      CT2->CT2_LOTE  :=  m_LOTE 
      CT2->CT2_SBLOTE:=  m_SBLOTE
      CT2->CT2_DOC   :=  m_DOC
      CT2->CT2_LINHA :=  m_LINHA
      CT2->CT2_MOEDLC:=  m_MOEDLC
      CT2->CT2_DC    :=  m_DC
      CT2->CT2_DEBITO:=  m_DEBITO
      CT2->CT2_CREDIT:=  m_CREDIT
      CT2->CT2_DCD   :=  m_DCD    
      CT2->CT2_DCC   :=  m_DCC
      CT2->CT2_VALOR :=  IIF(mv_par07 = 0, n_ValNew, n_ValDif)
      CT2->CT2_MOEDAS:=  m_MOEDAS
      CT2->CT2_HP    :=  m_HP
      CT2->CT2_HIST  :=  m_HIST
      CT2->CT2_CCD   :=  IIF(EMPTY(m_CCD), m_CCD, mv_par05)
      CT2->CT2_CCC   :=  IIF(EMPTY(m_CCC), m_CCC, mv_par05)
      CT2->CT2_ITEMD :=  m_ITEMD
      CT2->CT2_ITEMC :=  m_ITEMC
      CT2->CT2_CLVLDB:=  m_CLVLDB
      CT2->CT2_CLVLCR:=  m_CLVLCR
      CT2->CT2_ATIVDE:=  m_ATIVDE
      CT2->CT2_ATIVCR:=  m_ATIVCR
      CT2->CT2_EMPORI:=  m_EMPORI
      CT2->CT2_FILORI:=  m_FILORI
      CT2->CT2_INTERC:=  m_INTERC
      CT2->CT2_TPSALD:=  m_TPSALD
      CT2->CT2_SEQUEN:=  m_SEQUEN
      CT2->CT2_MANUAL:=  m_MANUAL
      CT2->CT2_ORIGEM:=  m_ORIGEM
      CT2->CT2_LP    :=  m_LP 
      CT2->CT2_SEQLAN:=  m_SEQLAN
      CT2->CT2_DTVENC:=  m_DTVENC
      CT2->CT2_SLBASE:=  m_SLBASE
      CT2->CT2_DTLP  :=  m_DTLP
      CT2->CT2_DATATX:=  m_DATATX 
      CT2->CT2_TAXA  :=  m_TAXA
      CT2->CT2_VLR01 :=  m_VLR01
      CT2->CT2_VLR02 :=  m_VLR02
      CT2->CT2_VLR03 :=  m_VLR03
      CT2->CT2_VLR04 :=  m_VLR04
      CT2->CT2_VLR05 :=  m_VLR05
      CT2->CT2_CRCONV:=  m_CRCONV
      CT2->CT2_CRITER:=  m_CRITER
      CT2->CT2_KEY   :=  m_KEY
      CT2->CT2_SEGOFI:=  m_SEGOFI
      CT2->CT2_DTCV3 :=  m_DTCV3
      CT2->CT2_SIATA :=  m_SIATA
      CT2->CT2_ROTINA:=  m_ROTINA
      CT2->CT2_AGLUT :=  m_AGLUT 
      CT2->CT2_SEQHIS:=  m_SEQHIS
      MsUnLock()
      
      dbSelectArea("QRY")      
      dbSkip()
   Enddo
   dbCloseArea()
   dbSelectArea("TMP")
   dbCloseArea()
   If File("m_CT2TMP.DBF")
      FErase("m_CT2TMP.DBF")
   Endif
   FRename(cArq+".DBF","m_CT2TMP.DBF")
Return

////////////////////////////////
Static Function ValidPerg(cPerg)
   Local i, j, aRegs, _sAlias := Alias()
   
   aRegs := {}
   dbSelectArea("SX1")
   dbSetOrder(1)

   AADD(aRegs,{cPerg,"01","Da Data              ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","",;
               "","","","","","","","","","","","","","","","","","","","","   "})
   AADD(aRegs,{cPerg,"02","Ate a Data           ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","",;
               "","","","","","","","","","","","","","","","","","","","","   "})
   AADD(aRegs,{cPerg,"03","Do Colaborador       ?","","","mv_ch3","C",09,0,0,"G","","mv_par03",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CTD"})
   AADD(aRegs,{cPerg,"04","Centro Custo Origem  ?","","","mv_ch4","C",09,0,0,"G","","mv_par04",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
   AADD(aRegs,{cPerg,"05","Centro Custo Destino ?","","","mv_ch5","C",09,0,0,"G","","mv_par05",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
   AADD(aRegs,{cPerg,"06","Tipo de Saldo        ?","","","mv_ch6","C",01,0,0,"G","","mv_par06",;
               "","","","","","","","","","","","","","","","","","","","","","","","","SLW"})
   AADD(aRegs,{cPerg,"07","Informe o percentual ?","","","mv_ch7","N",05,2,0,"G","","mv_par07",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CTT"})

   For i:=1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j:=1 to Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
         Next
         MsUnlock()
         dbCommit()
      Endif
   Next
   dbSelectArea(_sAlias)
Return
