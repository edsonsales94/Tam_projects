#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INDA040  ³ Autor ³ Ronilton O. Barros    ³ Data ³ 09.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de Rateio dos lancamentos da folha                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
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

User function INDA040()//INDA040()
   
   Local cPerg, cCadastro, aSays, aButtons, nOpca

   cPerg := "IND040"
   ValidPerg(cPerg)
   Pergunte(cPerg,.F.)

   cCadastro := OemtoAnsi("Rateio dos Pre-Lancamentos da Folha")
   aSays     := {}
   aButtons  := {}
   nOpca     := 0

   AADD(aSays,OemToAnsi("Esta rotina ira ratear os pre-lancamentos com origem da folha  de  acordo") )
   AADD(aSays,OemToAnsi("com a tabela de rateio do SIATA, e  conforme  o  periodo  informado  pelo") )
   AADD(aSays,OemToAnsi("usuario.                                                                 ") )

   AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
   AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
   AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

   FormBatch( cCadastro, aSays, aButtons )

   If nOpca == 1
      Processa({|| Ratear() },"Rateio de Pre-Lancamento")
   EndIf

Return

Static Function Ratear()
   
   Local aDbf, cArq, cQuery, nRegis, cNumLin, cDocLote

   //- Cria DBF temporario para guardar os registros do CT2 gerados pela rotina 
   aDbf   := CT2->( dbStruct() )
   cArq   := CriaTrab( aDbf , .T. )
   Use &cArq Alias TMP New Exclusive

   //- Verificando o numero do ultimo documento do lote = "008890" sublote = "001"
   cQuery := "SELECT MAX(CT2_DOC) CT2_DOC FROM "+RetSQLName("CT2")+" WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"' AND  "
   cQuery += "D_E_L_E_T_ = ' ' AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"' AND "
   cQuery += "CT2_LOTE = '008890' AND CT2_TPSALD = '9' AND "
   cQuery += "CT2_SIATA = '  ' AND (CT2_ITEMD <> '"
   cQuery += Space(TamSX3("CT2_ITEMD")[1])+"' OR CT2_ITEMC <> '"+Space(TamSX3("CT2_ITEMD")[1])+"')"

   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)

   cDocLote:= StrZero(Val(CT2_DOC)+1,6)
   dbCloseArea()
   
   // Monta query filtrando os registros validos a serem reateados */
   // 008890 -> Lote da folha
   // 9 -> Pre-lancamento
   //
   cQuery := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"' AND "
   cQuery += "D_E_L_E_T_ = ' ' AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"' AND "
   cQuery += "CT2_LOTE = '008890' AND CT2_TPSALD = '9' AND "
   cQuery += "CT2_SIATA = '  ' AND (CT2_ITEMD <> '"
   cQuery += Space(TamSX3("CT2_ITEMD")[1])+"' OR CT2_ITEMC <> '"+Space(TamSX3("CT2_ITEMD")[1])+"')"
   
   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
   nRegis := SOMA
   dbCloseArea()

   cQuery := StrTran(cQuery,"COUNT(*) SOMA","*, R_E_C_N_O_ CT2_RECNO")
   cQuery += " ORDER BY CT2_DATA, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
   ProcRegua(nRegis)
   
   While !Eof()

      IncProc("Rateando...")
      
      If !Empty(mv_par03)    
         If !Empty(CT2_ITEMD) .and. CT2_ITEMD <> mv_par03
            dbSkip()
            Loop
         Endif
         If !Empty(CT2_ITEMC) .and. CT2_ITEMC <> mv_par03
            dbSkip()
            Loop
         Endif
      Endif   
      dbSelectArea("CT2")
      dbGoTo(QRY->CT2_RECNO)
      dbSelectArea("QRY")
      Rateia(CT2_ITEMD, "D", @cNumLin, @cDocLote )  // Rateia o item contabil a debito
      If Empty(CT2_ITEMD)
         Rateia(CT2_ITEMC, "C", @cNumLin, @cDocLote )  // Rateia o item contabil a credito
      Endif
      dbSkip()
   Enddo
   dbCloseArea()
   dbSelectArea("TMP")
   dbCloseArea()
   If File("\CT2TMP.DBF")
      FErase("\CT2TMP.DBF")
   Endif
   FRename(cArq+".DBF","\CT2TMP.DBF")
Return

Static Function Rateia(cItemCta, cDC, cNumLin, cDocLote)
   Local cMatric, cDatarq, vProj, nSoma, x, y, nTam, vCT2
   Local cTmp    := "CT2" // "TMP"  <-- Quando for executar oficialmente, mudar o alias para CT2
   Local cFilSZ1 := XFILIAL("SZ1")

   //- Verificando se o item ja foi rateado se esta informada a matricula
   If Empty(CT2->CT2_SIATA) .And. !Empty(cItemCta)
      
      nTam:= TamSX3("CT2_LINHA")[1]

      CT2->(dbGoTo(QRY->CT2_RECNO))  // Devolve a posicao original do registro do CT2

      cMatric := Padr(SubStr(cItemCta,1,6),9)
      cDatarq := SubStr(CT2_DATA,1,6)
      vProj   := {}
      nSoma   := 0
      
      //- Rateia lancamentos a partir dos percentuais encontrados no SIATA
      dbSelectArea("SZ1")
      dbSetOrder(2)
      dbSeek(cFilSZ1+cMatric+cDatarq,.T.)
      While !Eof() .And. cFilSZ1+cMatric+cDatarq == Z1_FILIAL+Z1_MAT+SubStr(Dtos(Z1_DATA),1,6)
         AAdd( vProj , { Z1_CC, Round(QRY->CT2_VALOR * Z1_PERC,2) })
         nSoma += vProj[Len(vProj),2]
         dbSkip()
      Enddo

      If Len(vProj) > 1  // Caso o pre-lancamento gere dois ou mais registros
         
         vProj[Len(vProj),2] += (QRY->CT2_VALOR - nSoma)  // Acerta a diferenca de centavos

         // Guarda os conteudos do campos do CT2
         dbSelectArea("CT2")
         vCT2 := {}
         For x:=1 To FCount()
            AAdd( vCT2 , FieldGet(x) )
         Next  
         vCT2[5]:= cDocLote
         
         //- Apaga o registro do CT2 pois ira ser rateado
         dbSelectArea("CT2") 
         RecLock("CT2",.F.)
         dbDelete()
         MsUnLock()
         
         //- Regrava os dados já rateados
         For x:=1 To Len(vProj)
            dbSelectArea(cTmp)
            RecLock(cTmp,.T.)
            For y:=1 To FCount()
               FieldPut( y , vCT2[y] )
            Next
            // Regrava os campos para acerto do rateio
            If cDC == "D"
               (cTmp)->CT2_CCD := vProj[x,1]
            Else
               (cTmp)->CT2_CCC := vProj[x,1]
            Endif
            
            If cNumLin == nil
               cNumLin:= StrZero(1,nTam)
            Else
               cNumLin:= StrZero(Val(cNumLin)+1,nTam)
            Endif   
            
            If Val(cNumLin) > 998
               cDocLote:= StrZero(Val(cDocLote)+1,6)            
               cNumLin:= StrZero(1,nTam)
            Endif
         
            (cTmp)->CT2_DOC   := cDocLote
            (cTmp)->CT2_LINHA := cNumLin
            (cTmp)->CT2_VALOR := vProj[x,2]
            (cTmp)->CT2_SIATA := "Rt"
            MsUnLock()
         Next
      ElseIf Len(vProj) == 1
         dbSelectArea("CT2")   // Apenas atualiza o centro de custos de acordo com o SIATA.
         RecLock("CT2",.F.)
         If cDC == "D"
            (cTmp)->CT2_CCD := vProj[1,1]
         Else
            (cTmp)->CT2_CCC := vProj[1,1]
         Endif
         CT2->CT2_SIATA := "Rt"
         MsUnLock()
      Endif
      dbSelectArea("QRY")
   Endif
Return(cNumLin)

Static Function ValidPerg(cPerg)
   Local i, j, aRegs, _sAlias := Alias()
   
   cPerg := PADR(cPerg,6)
   aRegs := {}
   dbSelectArea("SX1")
   dbSetOrder(1)

   AADD(aRegs,{cPerg,"01","Da Data            ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","",;
               "","","","","","","","","","","","","","","","","","","","","   "})
   AADD(aRegs,{cPerg,"02","Ate a Data         ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","",;
               "","","","","","","","","","","","","","","","","","","","","   "})
   AADD(aRegs,{cPerg,"03","Do Colaborador               ?","","","mv_ch3","C",09,0,0,"G","","mv_par03",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CTD"})

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
