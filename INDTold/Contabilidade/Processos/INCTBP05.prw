#Include "rwmake.ch"

//
// C.Custo       : 500210027 -> 10% 500210027
// Item Contabil : 00007    
//

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INDA140  ³ Autor ³ Reinaldo Magalhaes    ³ Data ³ 17.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajusta Centro de Custos no Financeiro                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico INDT                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INCTBP05() //INDA140()
   
   Local cPerg, cCadastro, aSays, aButtons, nOpca

   cPerg := padr("IND140",Len(SX1->X1_GRUPO))
   ValidPerg(cPerg)
   Pergunte(cPerg,.F.)

   cCadastro := OemtoAnsi("Ajuste os lancamentos no financeiro por centro de custos")
   aSays     := {}
   aButtons  := {}
   nOpca     := 0

   AADD(aSays,OemToAnsi("Esta rotina ira acertar os valores dos lancamentos no financeiro             ") )
   AADD(aSays,OemToAnsi("de acordo com o percentual informado no parametro pelo usuario. Transferindo ") )
   AADD(aSays,OemToAnsi("este valor para o centro de custos de destino.                              ") )

   AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
   AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
   AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

   FormBatch( cCadastro, aSays, aButtons )

   If nOpca == 1
      Processa({|| AcertarFIN() },"Acertando valores...")
   EndIf

Return

///////////////////////////
Static Function AcertarFIN
   
   Local aDbf, cArq, cQuery, nRegis, n_ValDif, n_ValNew, vTit, vItem, n_Recno, vSE5, vSD1, vSEZ
   Local n_ImpDif1, n_ImpDif2, n_ImpDif3, n_ImpNew1, n_ImpNew2, n_ImpNew3, x, y, i

   // mv_par01 - Da Data               
   // mv_par02 - Ate a Data            
   // mv_par03 - Do Colaborador        
   // mv_par04 - Centro Custo Origem   
   // mv_par05 - Centro Custo Destino  
   // mv_par06 - Tipo de Saldo         
   // mv_par07 - Informe o percentual  

   //- Cria DBF temporario para guardar os registros do CT2 gerados pela rotina antes de colocar na base oficial
   aDbf := SE5->( dbStruct() )
   cArq := CriaTrab( aDbf , .T. )
   Use &cArq Alias TMP New Exclusive
   
   cQuery := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQuery += "E5_DTDISPO >= '"+dtos(mv_par01)+"' AND E5_DTDISPO <= '"+dtos(mv_par02)+"' AND  "
   cQuery += "E5_RECPAG = 'P' AND E5_FILIAL = + '" + xFilial("SE5") + "' AND "
   cQuery += u_CondPadRel()

   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
   nRegis := SOMA
   dbCloseArea()

   cQuery:= StrTran(cQuery,"COUNT(*) SOMA","*, R_E_C_N_O_ SE5_RECNO")

   dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
   ProcRegua(nRegis)
   
   While !Eof()

      IncProc("Acertando valores...")

      vTit:= {}
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Lancamentos incluido via movimentacao bancaria - E5_MOTBX = ''  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If Empty(QRY->E5_MOTBX)
         
         If QRY->E5_ITEMD == mv_par03 .And. QRY->E5_CCD == mv_par04 
         
            //- Salva dados atuais
            DbSelectArea("SE5")
            DbGoto(QRY->SE5_RECNO)
               
            vSE5:= {}
            For x:=1 To FCount()
               AAdd( vSE5 , FieldGet(x) )
            Next  

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Ajustando valores na tabela SE5 ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            n_ValDif := INT(QRY->E5_VALOR * ( mv_par07 / 100))
            n_ValNew := QRY->E5_VALOR - n_ValDif

            RecLock("SE5",.F.)
            SE5->E5_VALOR := n_ValNew
            MsUnlock()
                        
            //- Gerando nova ocorrencia
            RecLock("SE5",.T.)
            MsUnlock()
            
            RecLock("SE5",.F.)
            For y:=1 To FCount()
               FieldPut( y , vSE5[y] )
            Next
            SE5->E5_VALOR := n_ValDif                  
            SE5->E5_CCD   := mv_par05
            MsUnLock()
            DbSelectArea("QRY")
         Endif      
      Endif
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Ajustando valores nas tabelas                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      cFilSE5 := E5_FILIAL
      cBusca  := E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA

      //- Pega o valor baixado
      nTotal := QRY->E5_VALOR
            
      //- Contas a pagar
      dbSelectArea("SE2")
      dbSetOrder(1)
      If Empty(QRY->E5_MOTBX) .Or. !dbSeek(cFilSE5+cBusca)
         dbSelectArea("QRY")
         dbSkip()
         Loop
      Endif
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Verificando se o lancamento é um PA           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If Alltrim(QRY->E5_TIPO) == "PA" .and. QRY->E5_RECPAG = "P" .and. QRY->E5_MOTBX == "NOR"
         vTit:= QRY->(TrataPA(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO,E5_CLIFOR,E5_LOJA)) //- Retorna Recno() do SE2
      Endif
      AAdd( vTit , { Recno() , nTotal, "TBS", 0})  // Guarda o titulo atual no SE2

      dbSelectArea("SE2")

      For y:=1 To Len(vTit)

         dbGoTo(vTit[y,1])      // Posiciona no titulo do contas a pagar (SE2)
         
         cBusca:= E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

         If Trim(E2_ORIGEM) == "MATA100"  //- Caso a origem seja o modulo de compras
         
            cBusca:= E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
         
            //- Itens da nota fiscal de entrada
            dbSelectArea("SD1")
            dbSetOrder(1)
            dbSeek(cFilSE5+cBusca,.T.)

            vSD1:= {}
            
            While !Eof() .and. cFilSE5+cBusca == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
               If D1_TOTAL = 0 .Or. D1_ITEMCTA != mv_par03 .Or. D1_CC != mv_par04
                  dbSkip()
                  Loop                                                 
               EndIf
               AAdd( vSD1 , { Recno() } ) //- Guarda o registro atual no SD1
               dbSkip()                                                      
            Enddo   

            dbSelectArea("SD1")
            
            For i:= 1 to Len(vSD1)   
               
               //- Posiciona registro no SD1
               DbGoto(vSD1[i,1])
               
               //- Guarda os conteudos do campos do SD1
               vItem:= {}
               For x:=1 To FCount()
                  AAdd( vItem , FieldGet(x) )
               Next  
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Ajustando valores nas tabelas                 ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               n_ValDif  := INT(SD1->D1_TOTAL   * ( mv_par07 / 100))
               n_ImpDif1 := INT(SD1->D1_VALIMP1 * ( mv_par07 / 100))
               n_ImpDif2 := INT(SD1->D1_VALIMP2 * ( mv_par07 / 100))
               n_ImpDif3 := INT(SD1->D1_VALIMP3 * ( mv_par07 / 100))
               
               n_ValNew  := SD1->D1_TOTAL   - n_ValDif
               n_ImpNew1 := SD1->D1_VALIMP1 - n_ImpDif1 
               n_ImpNew2 := SD1->D1_VALIMP2 - n_ImpDif2 
               n_ImpNew3 := SD1->D1_VALIMP3 - n_ImpDif3 
               
               RecLock("SD1",.F.)
               SD1->D1_VUNIT   := ( n_ValNew / SD1->D1_QUANT )
               SD1->D1_TOTAL   := n_ValNew      
               SD1->D1_VALIMP1 := n_ImpNew1 
               SD1->D1_VALIMP2 := n_ImpNew2 
               SD1->D1_VALIMP3 := n_ImpNew3 
               MsUnlock()
                        
               //- Gerando nova ocorrencia no SD1
               RecLock("SD1",.T.)
               For y:=1 To FCount()
                  FieldPut( y , vItem[y] )
               Next
               SD1->D1_ITEM    := "9" + Substr(vItem[2],2,3)
               SD1->D1_VUNIT   := ( n_ValDif / vItem[7] )
               SD1->D1_TOTAL   := n_ValDif            
               SD1->D1_CC      := mv_par05            
               SD1->D1_VALIMP1 := n_ImpDif1           
               SD1->D1_VALIMP2 := n_ImpDif2           
               SD1->D1_VALIMP3 := n_ImpDif3           
               MsUnlock()
            Next   

         ElseIf Trim(E2_ORIGEM) == "FINA050"  //- Caso a origem seja do financeiro (contas a pagar)

            lMultCC:= .F.
            
            If E2_MULTNAT == "1"   //- Caso seja multiplas naturezas
               
               //- Rateio por multiplas naturezas
               dbSelectArea("SEV")
               dbSetOrder(1)
               dbSeek(cFilSE5+SubStr(cBusca,1,21),.t.)
               
               While !Eof() .and. cFilSE5+SubStr(cBusca,1,21) == EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA
                  If EV_RECPAG <> "P"  //- Somente titulos a pagar
                     dbSkip()
                     Loop
                  Endif
                  
                  If EV_RATEICC == "1"  //- Multi-centro de custo
                     
                     cBusca:= SubStr(cBusca,1,21) + EV_NATUREZ
                     
                     //- Rateio por multiplos centros de custos
                     dbSelectArea("SEZ")
                     dbSetOrder(1)
                     dbSeek(cFilSE5+cBusca,.T.)
                     
                     vSEZ:= {}
                     
                     While !Eof() .and. cFilSE5+cBusca == EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ
                        
                        If EZ_RECPAG != "P" .Or. EZ_ITEMCTA != mv_par03 .Or. EZ_CCUSTO != mv_par04
                           dbskip()
                           Loop
                        Endif
                        AAdd( vSEZ , { Recno() } ) //- Guarda o registro atual no SEZ
                        lMultCC:= .T.
                        dbSkip()                                                      
                     Enddo   

                     dbSelectArea("SEZ")

                     For i:= 1 to Len(vSEZ)

                        //- Posiciona registro no SEZ
                        DbGoto(vSEZ[i,1])

                        //- Guarda os conteudos do campos do SD1
                        vItem:= {}
                        For x:=1 To FCount()
                           AAdd( vItem , FieldGet(x) )
                        Next  
            
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Ajustando valores nas tabelas                 ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        n_ValDif := SEZ->EZ_VALOR * ( mv_par07 / 100)
                        n_ValNew := SEZ->EZ_VALOR - n_ValDif

                        n_PercDif := SEZ->EZ_PERC * ( mv_par07 / 100)   
                        n_PercNew := SEZ->EZ_PERC - n_PercDif
                        
                        RecLock("SEZ",.F.)
                        SEZ->EZ_VALOR := n_ValNew
                        SEZ->EZ_PERC  := n_PercNew
                        MsUnlock()
                        
                        //- Gerando nova ocorrencia
                        RecLock("SEZ",.T.)
                        MsUnlock()
            
                        RecLock("SEZ",.F.)
                        For y:=1 To FCount()
                           FieldPut( y , vItem[y] )
                        Next                      
                        SEZ->EZ_CCUSTO := mv_par05
                        SEZ->EZ_VALOR  := n_ValDif
                        SEZ->EZ_PERC   := n_PercDif
                        MsUnLock()                          
                     Next   
                  Endif   
                  dbSelectArea("SEV")
                  dbSkip()
               Enddo
            Endif   
            If !lMultCC
               If SE2->E2_ITEMCTA == mv_par03 .And. SE2->E2_CC == mv_par04
                  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                  //³ Gerando rateio para o titulo por multi-naturezas   ³
                  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  dbSelectArea("SEV")
                  dbSetOrder(1)
                  If SEV->(dbSeek(cFilSE5+SubStr(cBusca,1,21),.t.))
                      Reclock("SEV", .F.)
                      dbDelete()
                      MsUnLock()
                  Endif   
                  Reclock("SEV", .T.)
                  SEV->EV_FILIAL  := SE2->E2_FILIAL
                  SEV->EV_PREFIXO := SE2->E2_PREFIXO
                  SEV->EV_NUM     := SE2->E2_NUM
                  SEV->EV_PARCELA := SE2->E2_PARCELA
                  SEV->EV_CLIFOR  := SE2->E2_FORNECE
                  SEV->EV_LOJA    := SE2->E2_LOJA
                  SEV->EV_TIPO    := SE2->E2_TIPO  
                  SEV->EV_VALOR   := SE2->E2_VALOR
                  SEV->EV_NATUREZ := SE2->E2_NATUREZ 
                  SEV->EV_RECPAG  := "P"
                  SEV->EV_PERC    := 1.0000000
                  SEV->EV_LA      := SE2->E2_LA
                  SEV->EV_RATEICC := "1"
                  SEV->EV_IDENT   := "1"
                  MsUnlock()         
                  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                  //³ Gerando rateio para o titulo por multi-centro de custos  ³
                  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  cBusca:= SubStr(cBusca,1,21) + SE2->E2_NATUREZ
                     
                  //- Rateio por multiplos centro de custos 
                  dbSelectArea("SEZ")
                  dbSetOrder(1)

                  If SEZ->(dbSeek(cFilSE5+cBusca,.t.))
                     While !Eof() .and. cFilSE5+cBusca == EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ
                         Reclock("SEZ",.F.)
                         dbDelete()
                         MsUnlock()
                        dbSkip()                                                      
                     Enddo   
                  Endif   
                  
                  n_ValDif := INT(SE2->E2_VALOR * ( mv_par07 / 100))
                  n_ValNew := SE2->E2_VALOR - n_ValDif
                  
                  //- Gravando rateio para C.C origem
                  Reclock("SEZ", .T.)
                  SEZ->EZ_FILIAL  := SE2->E2_FILIAL
                  SEZ->EZ_PREFIXO := SE2->E2_PREFIXO
                  SEZ->EZ_NUM     := SE2->E2_NUM
                  SEZ->EZ_PARCELA := SE2->E2_PARCELA
                  SEZ->EZ_CLIFOR  := SE2->E2_FORNECE
                  SEZ->EZ_LOJA    := SE2->E2_LOJA
                  SEZ->EZ_TIPO    := SE2->E2_TIPO  
                  SEZ->EZ_VALOR   := n_ValNew
                  SEZ->EZ_NATUREZ := SE2->E2_NATUREZ 
                  SEZ->EZ_CCUSTO  := SE2->E2_CC
                  SEZ->EZ_RECPAG  := "P"
                  SEZ->EZ_PERC    := 1 - (mv_par07/100)
                  SEZ->EZ_LA      := SE2->E2_LA
                  SEZ->EZ_ITEMCTA := SE2->E2_ITEMCTA
                  SEZ->EZ_CLVL    := SE2->E2_CLVL
                  SEZ->EZ_IDENT   := "1"
                  MsUnlock()         
                     
                  //- Gravando rateio para C.C destino
                  Reclock("SEZ", .T.)
                  SEZ->EZ_FILIAL  := SE2->E2_FILIAL
                  SEZ->EZ_PREFIXO := SE2->E2_PREFIXO
                  SEZ->EZ_NUM     := SE2->E2_NUM
                  SEZ->EZ_PARCELA := SE2->E2_PARCELA
                  SEZ->EZ_CLIFOR  := SE2->E2_FORNECE
                  SEZ->EZ_LOJA    := SE2->E2_LOJA
                  SEZ->EZ_TIPO    := SE2->E2_TIPO  
                  SEZ->EZ_VALOR   := n_ValDif
                  SEZ->EZ_NATUREZ := SE2->E2_NATUREZ 
                  SEZ->EZ_CCUSTO  := mv_par05
                  SEZ->EZ_RECPAG  := "P"
                  SEZ->EZ_PERC    := (mv_par07 / 100)
                  SEZ->EZ_LA      := SE2->E2_LA
                  SEZ->EZ_ITEMCTA := SE2->E2_ITEMCTA
                  SEZ->EZ_CLVL    := SE2->E2_CLVL
                  SEZ->EZ_IDENT   := "1"
                  MsUnlock()
                  //- Atualizando Multi-naturezas
                  RecLock("SE2",.F.)
                  SE2->E2_MULTNAT := "1"
                  MsUnlock()
               Endif 
            Endif
         Endif
         dbSelectArea("SE2")
      Next   
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

///////////////////////////////////////////////////
Static Function TrataPA(c_Doc,c_FornAdt,c_LojaAdt)
  Local c_Alias := Alias()
  Local n_RegSE2:= SE2->(Recno())
  Local n_IndSE2:= SE2->(IndexOrd())
  Local n_RegSE5:= SE5->(Recno())
  Local n_IndSE5:= SE5->(IndexOrd())
  Local vRet    := {}

  //- Verificando a existencia de documentos compensados pelo P.A
  DbSelectArea("SE5")
  DbSetOrder(10) //- E5_FILIAL+E5_DOCUMEN
  dbSeek(cFilSE5+c_Doc,.t.)
  While !Eof() .And. SE5->E5_FILIAL+Substr(SE5->E5_DOCUMEN,1,13) == cFilSE5+c_Doc
     If E5_RECPAG <> "P" .or. E5_TIPODOC <> "CP"
        DbSkip()
        Loop
     Endif
     // c_FornAdt+c_LojaAdt - Fornecedor e loja do PA   
     If SE5->(E5_FORNADT+E5_LOJAADT) == c_FornAdt+c_LojaAdt //.or. Trim(E2_ORIGEM) == "GPEM670" .or. 
        //- Verificando contas a pagar
        dbSelectArea("SE2")
        dbSetOrder(1)
        If DbSeek(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
           nPos:= AScan( vRet, {|x| x[1] == Recno() } )
           If nPos == 0
              AAdd( vRet, { Recno(), SE5->E5_VALOR, "SE5", SE5->(Recno())})
           Else
              vRet[nPos,2]:= SE5->E5_VALOR
           Endif
        Endif
     Endif
     DbSelectArea("SE5")
     dbSkip()
  Enddo
  SE2->(DbSetOrder(n_IndSE2))
  SE2->(Dbgoto(n_RegSE2))
  SE5->(DbSetOrder(n_IndSE5))
  SE5->(Dbgoto(n_RegSE5))
  DbSelectArea(c_Alias)
return(vRet)

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
