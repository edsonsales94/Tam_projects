#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CT2811P10³ Autor ³ Reinaldo Magalhaes    ³ Data ³ 20.11.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Geracao do arquivo texto com despesas de P&D p/ FPF        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CT2811P10()
   Local cCadastro := OemtoAnsi("Conversão do CT2 de 8.11 para P10")
   Local aSays     := {}
   Local aButtons  := {}
   Local nOpca     := 0

   AADD(aSays,OemToAnsi("Esta rotina irá converter os registros da tabela CT2 da versão 8.11 para ") )
   AADD(aSays,OemToAnsi("a versão P10.                                                            ") )

   AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
   AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

   FormBatch( cCadastro, aSays, aButtons )

   If nOpca == 1
      Processa({|| RunProc() },"Convertendo CT2")
   EndIf

Return

Static Function RunProc()
   Local cQry, x, nTotReg
   Local vCampo := {}

   If .T.
      AAdd( vCampo , { "D1_DOC"    , 6} )
      AAdd( vCampo , { "D2_DOC"    , 6} )
      AAdd( vCampo , { "E2_NUM"    , 6} )
      AAdd( vCampo , { "E5_NUMERO" , 6} )
      AAdd( vCampo , { "F1_DOC"    , 6} )
      AAdd( vCampo , { "F2_DOC"    , 6} )
   Else
      AAdd( vCampo , { "E2_PARCELA", 1} )
      AAdd( vCampo , { "E5_PARCELA", 1} )
   Endif

   cQry := "SELECT ISNULL(COUNT(*),0) TOTAL FROM "+RetSQLName("CT2")+" CT2, "+RetSQLName("CTL")+" CTL"
   cQry += " WHERE CT2.D_E_L_E_T_ = ' ' AND CTL.D_E_L_E_T_ = ' '"
   cQry += " AND CT2_LP = CTL_LP AND CTL_ALIAS NOT IN ('SE2','SE5')"
   cQry += " AND CT2_KEY <> ' '"

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"CT2TMP",.T.,.T.)
   nTotReg := TOTAL
   dbCloseArea()

   cQry := StrTran(cQry,"ISNULL(COUNT(*),0) TOTAL","CTL_ALIAS, CTL_KEY, CT2_KEY, CT2.R_E_C_N_O_ AS CT2_RECNO")
   cQry += " ORDER BY CTL_LP, CT2_DATA"

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"CT2TMP",.T.,.T.)

   ProcRegua(nTotReg)
   dbGoTop()
   While !Eof()

      IncProc()

      For x:=1 To Len(vCampo)
         If vCampo[x,1] $ CTL_KEY
            AcertaKey(vCampo[x,1],vCampo[x,2])
         Endif
      Next

      dbSkip()
   Enddo
   dbCloseArea()

Return

Static Function AcertaKey(cCampo,nTC)
   Local cAlias := Alias()
   Local cChave := PADR(CTL_KEY,At(cCampo,CTL_KEY)-2)
   Local nTam   := Len(&(CTL_ALIAS+"->("+cChave+")"))
   Local nTAtu  := TamSX3(cCampo)[1]
   Local cAux   := SubStr(CT2_KEY,nTam+1,nTC)

   cChave := Stuff(CT2_KEY,nTam+1,nTC,PADR(cAux,nTAtu))

   CT2->(dbGoTo(CT2TMP->CT2_RECNO))  // Posiciona no registro do CT2
   RecLock("CT2",.F.)
   CT2->CT2_KEY := cChave
   MsUnLock()
   dbSelectArea(cAlias)
Return
