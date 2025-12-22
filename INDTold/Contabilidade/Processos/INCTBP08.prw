#Include "Rwmake.ch"
#Include "Topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INDA020  ³ Autor ³ Ronilton O. Barros    ³ Data ³ 03.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de rateio dos lancamentos contabeis por projeto     ³±±
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
//³ mv_par01         Mes     ?                    ³
//³ mv_par02         Ano     ?                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function INCTBP08() //INDA020()
   Local cPerg, cCadastro, aSays, aButtons, nOpca, nPar

   cPerg := Padr("IND020",Len(SX1->X1_GRUPO))
   nPar  := ValidPerg(cPerg)
   Pergunte(cPerg,.F.)

   cCadastro := OemtoAnsi("Rateio por Projetos")
   aSays     := {}
   aButtons  := {}
   nOpca     := 0

   AADD(aSays,OemToAnsi("Esta rotina ira efetuar o rateio dos lancamentos efetuados na contabilidade") )
   AADD(aSays,OemToAnsi("de acordo com o numero de projetos em que o  funcionario  foi  alocado.  Os") )
   AADD(aSays,OemToAnsi("lancamentos a serem rateados serao os que estiverem relacionados ao funcio-") )
   AADD(aSays,OemToAnsi("nario atraves do item contabil.                                            ") )

   AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
   AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
   AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

   FormBatch( cCadastro, aSays, aButtons )

   If nOpca == 1
      Processa({|| Importar(nPar) },"Rateio por Projeto")
   EndIf

Return

Static Function Importar(nPar)
   Local aDbf, cArq, cArq1, cInd1, cArq2, cInd2, cFunc, c, p, nSoma, dDtFin, nPerc, cBusca, vItem, nPgto, nDif, nPV, cAlias
   Local cFilDe, cFilAte, cCCDe, cCCAte, cMatDe, cMatAte, nPos, vProv, lBaixa, cMens, nValAnt, nFerias, cCodBai, vRescis
   Local vINSS, nINSS, nMulta, lMens

   cAlias := "QTB"
   aDbf   := CT2->( dbStruct() )
   cArq   := CriaTrab( aDbf , .T. )
   Use &cArq Alias QTB New Exclusive

   /* Cria arquivo temporario com os valores a serem rateados */
   aDbf := {}
   AAdd( aDbf , { "CONTAC" , "C", 20, 0})
   AAdd( aDbf , { "ITEMCTA", "C",  9, 0})
   AAdd( aDbf , { "DOC"    , "C",  6, 0})
   AAdd( aDbf , { "SERIE"  , "C",  3, 0})
   AAdd( aDbf , { "BENEF"  , "C", 25, 0})
   AAdd( aDbf , { "BANCO"  , "C",  3, 0})
   AAdd( aDbf , { "AGENCIA", "C",  5, 0})
   AAdd( aDbf , { "CONTAB" , "C", 10, 0})
   AAdd( aDbf , { "VALOR"  , "N", 14, 2})
   AAdd( aDbf , { "LOTE"   , "C",  6, 0})
   AAdd( aDbf , { "ORIGEM" , "C",  7, 0})
   AAdd( aDbf , { "CLASSE" , "C",  9, 0})

   cArq1 := CriaTrab( aDbf , .T. )
   Use &cArq1 Alias TMP New Exclusive
   cInd1 := CriaTrab( NIL  , .F. )
   IndRegua("TMP",cInd1,"LOTE+ITEMCTA+DOC+SERIE+CONTAC",,, "Selecionando Registros...")

   /* Cria arquivo temporario para contabilizacao no banco */
   aDbf := {}
   AAdd( aDbf , { "BANCO"  , "C",  3, 0})
   AAdd( aDbf , { "AGENCIA", "C",  5, 0})
   AAdd( aDbf , { "CONTA"  , "C", 10, 0})
   AAdd( aDbf , { "VALOR"  , "N", 14, 2})
   AAdd( aDbf , { "LOTE"   , "C",  6, 0})

   cArq2 := CriaTrab( aDbf , .T. )
   Use &cArq2 Alias TRB New Exclusive
   cInd2 := CriaTrab( NIL  , .F. )
   IndRegua("TRB",cInd2,"LOTE+BANCO+AGENCIA+CONTA",,, "Selecionando Registros...")

   /* Calcula a data final do periodo (ultima data do mes) */
   dDtFin := LastDay(Ctod("01/"+mv_par01+"/"+mv_par02))

   /* Percorre o movimento bancario filtrando os pagamentos efetuados no periodo */
   dbSelectArea("SE5")
   dbSetOrder(1)
   dbSeek(XFILIAL("SE5")+mv_par02+mv_par01,.T.)
   ProcRegua(RecCount())
   While !Eof() .And. XFILIAL("SE5") == E5_FILIAL .And. E5_DATA <= dDtFin

      IncProc("Filtrando pagamentos...")

      /* Desconsidera os registros conforme situacao abaixo */
      If E5_RECPAG <> "P" .Or. E5_SITUACA == "C" .Or. E5_TIPODOC $ "JR,DC" //.Or. Empty(SE5->E5_MOEDA)  //,BA
         dbSkip()
         Loop
      Endif

      /* Pesquisa no contas a pagar o titulo movimentado */
      cBusca := E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA
      dbSelectArea("SE2")
      dbSetOrder(1)
      If dbSeek(XFILIAL("SE2")+cBusca)
         dbSelectArea("SED")
         dbSetOrder(1)
         dbSeek(XFILIAL("SED")+SE2->E2_NATUREZ)
         dbSelectArea("SE2")
         nSoma := 0
         vItem := {}
         If Trim(E2_ORIGEM) == "MATA100"  // Caso a origem seja por n.f. de entrada
            cBusca := SE5->(E5_NUMERO+E5_PREFIXO+E5_CLIFOR+E5_LOJA)
            dbSelectArea("SF1")
            dbSetOrder(1)
            dbSeek(XFILIAL("SF1")+cBusca)
            dbSelectArea("SD1")
            dbSetOrder(1)
            dbSeek(XFILIAL("SD1")+cBusca,.T.)
            While !Eof() .And. XFILIAL("SD1")+cBusca == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
               nPerc := D1_TOTAL / SF1->F1_VALMERC
               AAdd( vItem , { D1_CONTA, D1_ITEMCTA, D1_DOC, D1_SERIE, SE5->E5_BENEF, SE5->E5_BANCO, SE5->E5_AGENCIA, SE5->E5_CONTA,;
                               Round(SE5->E5_VALOR * nPerc,2), "008810", Trim(SE2->E2_ORIGEM), D1_CLVL})

               nSoma += vItem[Len(vItem),9]
               dbSkip()
            Enddo
         ElseIf Trim(E2_ORIGEM) == "FINA050"  // Caso a origem seja do financeiro (contas a pagar)
            If E2_MULTNAT == "1"   // Caso seja multi-natureza
               dbSelectArea("SEV")
               dbSetOrder(1)
               dbSeek(XFILIAL("SEV")+cBusca,.T.)
               While !Eof() .And. XFILIAL("SEV")+cBusca == EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA
                  If EV_RECPAG == "P"   // Somente titulos a pagar
                     dbSelectArea("SED")
                     dbSetOrder(1)
                     dbSeek(XFILIAL("SED")+SEV->EV_NATUREZ)
                     dbSelectArea("SEV")
                     AAdd( vItem , { SED->ED_CONTAB, SE2->E2_ITEMCTA, EV_NUM, EV_PREFIXO, SE5->E5_BENEF, SE5->E5_BANCO, SE5->E5_AGENCIA,;
                                     SE5->E5_CONTA, EV_VALOR, "008810", Trim(SE2->E2_ORIGEM), SE2->E2_CLVL} )
                     nSoma += vItem[Len(vItem),9]
                  Endif
                  dbSkip()
               Enddo
            Else
               AAdd( vItem , { SED->ED_CONTAB, E2_ITEMCTA, E2_NUM, E2_PREFIXO, SE5->E5_BENEF, SE5->E5_BANCO, SE5->E5_AGENCIA, SE5->E5_CONTA,;
                               SE5->E5_VALOR, "008810", Trim(SE2->E2_ORIGEM), E2_CLVL} )
               nSoma += vItem[Len(vItem),9]
            Endif
         ElseIf Trim(E2_ORIGEM) == "GPEM670"  // Caso a origem seja da folha de pagamento
            cFilDe  := SubStr(E2_PARFOL, 1,2)
            cFilAte := SubStr(E2_PARFOL, 3,2)
            cCCDe   := SubStr(E2_PARFOL, 5,9)
            cCCAte  := SubStr(E2_PARFOL,14,9)
            cMatDe  := SubStr(E2_PARFOL,23,6)
            cMatAte := SubStr(E2_PARFOL,29,6)
            dbSelectArea("RC0")
            dbSetOrder(1)
            dbSeek(XFILIAL("RC0")+SE2->E2_CODTIT)
            dbSelectArea("SE2")
            If E2_AGRUPA $ "14"   // Agrupamento por Filial ou Funcionario
               cBusca := If( E2_AGRUPA == "1" , "", SubStr(SE2->E2_ITEMCTA,1,6))
               dbSelectArea("SRD")
               dbSetOrder(1)
               dbSeek(XFILIAL("SRD")+cBusca,.T.)
               While !Eof() .And. XFILIAL("SRD") == RD_FILIAL .And. If( Empty(cBusca) , .T., cBusca == RD_MAT )
                  dbSelectArea("SRA")
                  dbSetOrder(1)
                  dbSeek(XFILIAL("SRA")+SRD->RD_MAT)
                  dbSelectArea("SRD")
                  cFunc := RD_MAT
                  nPgto := 0
                  While !Eof() .And. cFunc == RD_MAT .And. XFILIAL("SRD") == RD_FILIAL

                     If RD_FILIAL >= cFilDe .And. RD_FILIAL <= cFilAte .And.;
                        RD_MAT    >= cMatDe .And. RD_MAT    <= cMatAte .And.;
                        RD_CC     >= cCCDe  .And. RD_CC     <= cCCAte  .And. &("SRA->"+Trim(RC0->RC0_FILTRF))
                        nPV := At(RD_PD,SE2->E2_VERBAS)
                        If nPV > 0 .And. RD_DATARQ == SE2->E2_DATARQ
                           nPgto += RD_VALOR * If( SubStr(SE2->E2_VERBAS,nPV+3,1) == "P" , 1, -1)
                        Endif
                     Endif

                     dbSkip()
                  Enddo
                  If nPgto <> 0
                     AAdd( vItem , { SED->ED_CONTAB, cFunc, SE2->E2_NUM, SE2->E2_PREFIXO, SE5->E5_BENEF, SE5->E5_BANCO, SE5->E5_AGENCIA,;
                                     SE5->E5_CONTA, nPgto, "008890", Trim(SE2->E2_ORIGEM), SE2->E2_CLVL} )
                     nSoma += vItem[Len(vItem),9]
                  Endif
               Enddo
            Else   // Agrupamento por Centro de Custo
               dbSelectArea("SRD")
               dbSetOrder(2)
               dbSeek(XFILIAL("SRD")+SE2->E2_CC,.T.)
               While !Eof() .And. XFILIAL("SRD")+SE2->E2_CC == RD_FILIAL+RD_CC
                  dbSelectArea("SRA")
                  dbSetOrder(1)
                  dbSeek(XFILIAL("SRA")+SRD->RD_MAT)
                  dbSelectArea("SRD")
                  cFunc := RD_MAT
                  nPgto := 0
                  While !Eof() .And. cFunc == RD_MAT .And. XFILIAL("SRD")+SE2->E2_CC == RD_FILIAL+RD_CC

                     If RD_FILIAL >= cFilDe .And. RD_FILIAL <= cFilAte .And.;
                        RD_MAT    >= cMatDe .And. RD_MAT    <= cMatAte .And.;
                        RD_CC     >= cCCDe  .And. RD_CC     <= cCCAte  .And. &("SRA->"+Trim(RC0->RC0_FILTRF))
                        nPV := At(RD_PD,SE2->E2_VERBAS)
                        If nPV > 0 .And. RD_DATARQ == SE2->E2_DATARQ
                           nPgto += RD_VALOR * If( SubStr(SE2->E2_VERBAS,nPV+3,1) == "P" , 1, -1)
                        Endif
                     Endif

                     dbSkip()
                  Enddo
                  If nPgto <> 0
                     AAdd( vItem , { SED->ED_CONTAB, cFunc, SE2->E2_NUM, SE2->E2_PREFIXO, SE5->E5_BENEF, SE5->E5_BANCO, SE5->E5_AGENCIA,;
                                     SE5->E5_CONTA, nPgto, "008890", Trim(SE2->E2_ORIGEM), SE2->E2_CLVL} )
                     nSoma += vItem[Len(vItem),9]
                  Endif
               Enddo
             Endif
         Endif

         /* Grava valores acumulados no arquivo temporario a ser utilizado para gravacao na contabilidade */
         GravaTemp(vItem,SE5->E5_VALOR - nSoma)

      Endif
      dbSelectArea("SE5")

      dbSkip()
   Enddo

   /* Armazena os identificadores de calculo informados nos parametros */
   cCodBai := ""
   vProv   := {}
   For p:=1 To nPar
      AAdd( vProv , { &( "mv_par"+StrZero(p,2) ), "", "", 0})
      If p > 8  // Armazena os identificadores de calculo de baixas
         cCodBai += RTrim(vProv[Len(vProv),1])+","
      Endif
   Next

   /* Contabilizacao da Provisao da Folha */
   dbSelectArea("SRT")
   dbSetOrder(1)
   dbSeek(XFILIAL("SRT"),.T.)
   ProcRegua(RecCOunt())
   While !Eof() .And. XFILIAL("SRT") == RT_FILIAL

      /* Zera as contas contabeis e valor dos identificadores de calculo informados nos parametros */
      For p:=1 To Len(vProv)
         vProv[p,2] := ""
         vProv[p,3] := ""
         vProv[p,4] := 0
      Next

      /* Busca o sindicato para verificar se existe multa referente ao discidio */
      nMulta := 0
      dbSelectArea("SRA")
      dbSetOrder(1)
      dbSeek(XFILIAL("SRA")+SRT->RT_MAT)
      dbSelectArea("RCE")
      dbSetOrder(1)
      If dbSeek(XFILIAL("RCE")+SRA->RA_SINDICA)
         nMulta := If( (Val(RCE_MESDIS) - Val(mv_par01)) == 1 , SRA->RA_SALARIO, 0)
      Endif
      dbSelectArea("SRT")

      /* Cria a variavel para armazenar os valores referentes a provisao de rescisao  */
      vRescis := {}
      AAdd( vRescis , { "RESC. SALDO SAL. "+mv_par01+"/"+mv_par02, SRA->RA_SALARIO , "048"} )  // Rescisao Saldo de Salario
      AAdd( vRescis , { "RESC. MULTA DIS. "+mv_par01+"/"+mv_par02, nMulta, "178" } )           // Rescisao Multa Discidio
      AAdd( vRescis , { "RESC. FER. + 1/3 "+mv_par01+"/"+mv_par02, 0, "   " } )                // Rescisao de Ferias
      AAdd( vRescis , { "RESC. FER. INSS. "+mv_par01+"/"+mv_par02, 0, "   " } )                // Rescisao de Ferias - INSS

      nFerias := 0
      lMens   := .T.
      cFunc   := RT_MAT
      While !Eof() .And. cFunc == RT_MAT .And. XFILIAL("SRT") == RT_FILIAL
      
         IncProc("Rateando provisoes...")

         If SubStr(Dtos(RT_DATACAL),1,6) <> mv_par02+mv_par01  // Ignora os valores diferentes do periodo informado no parametro
            dbSkip()
            Loop
         Endif
         
         dbSelectArea("SRV")
         dbSetOrder(1)
         dbSeek(XFILIAL("SRV")+SRT->RT_VERBA)   // Pesquisa o Identificador de Calculo no Cadastro de Verbas
         dbSelectArea("SRT")

         /* Acumula valores referente a rescisao */
         nPos := Ascan( vProv , {|x| SRV->RV_CODFOL $ x[1] })
         If nPos == 3
            vRescis[3,2] += RT_VALOR  // Rescisao de Ferias
            vRescis[3,3] := If( Empty(vRescis[3,3]) , SRV->RV_CTBRD, vRescis[3,3])
         ElseIf nPos == 4
            vRescis[4,2] += RT_VALOR  // Rescisao de Ferias - INSS
            vRescis[4,3] := If( Empty(vRescis[4,3]) , SRV->RV_CTBRD, vRescis[4,3])
         Endif


         // Se RT_DTFERVEN igual a zero
         //    Pego Tipo 2 e subtrai de Tipo 2 do mes anterior
         //    nFerias = 1
         // Senao
         //    Se RT_DTFERPRO igual a zero
         //       Pego Tipo 1 e subtrai de Tipo 2 do mes anterior
         //       nFerias = 2
         //    Senao
         //       Se RT_DTFERPRO igual a 2.5
         //          Pego Tipo 2 somente
         //          nFerias = 3
         //       Senao
         //          Pego Tipo 2 e subtrai de Tipo 2 do mes anterior
         //          nFerias = 4
         //       Fim se
         //    Fim se
         // Fim se
         // 0 - Sem calculo
         // 1 - Procura por Tipo igual a 2 no mes anterior
         // 2 - Ignora o mes anterior

         nFerias := If( nFerias <> 0 , nFerias, If( RT_DFERVEN == 0 , 1,;
                    If( RT_DFERPRO == 0 , 2, If( RT_DFERPRO == 2.5 , 3, 4))))

         // Ignora o Tipo da provisao igual a Ferias vencidas
         If RT_TIPPROV == "1" .And. !(RT_DFERVEN <> 0 .And. RT_DFERPRO == 0) .And. nFerias <> 2 .And.;
            !(SRV->RV_CODFOL $ cCodBai)
            dbSkip()
            Loop
         Endif

         nPos := Ascan( vProv , {|x| SRV->RV_CODFOL $ x[1] })
         If nPos > 2 // Se encontrou o identificador de calculo da provisao
            lBaixa := .F.
            If nPos > 8  // Encontrou uma verba de baixa da provisao
               lBaixa := .T.
               //If nPos > 10 // Encontrou uma verba de baixa da provisao do INSS ou FGTS
               //   If RT_TIPPROV $ "12"  // Se baixa das Ferias
               //      nPos := nPos - 7
               //   Else                  // Se baixa de 13o
               //       nPos := nPos - 4
               //   Endif
               //ElseIf nPos == 9         // Se Provisao de Ferias
               //   nPos := 3
               //Else                     // Se Provisao de 13o
               //   nPos := 6
               //Endif
            Else    // Nao pega contas contabeis das baixas das provisoes
               vProv[nPos,2] := If( Empty(vProv[nPos,2]) , SRV->RV_CTADEB , vProv[nPos,2])
               vProv[nPos,3] := If( Empty(vProv[nPos,3]) , SRV->RV_CTACRED, vProv[nPos,3])
            Endif

            // Atribui as contas contabeis da provisao cadastradas nas verbas
            vProv[nPos,2] := If( Empty(vProv[nPos,2]) , SRV->RV_CTADEB , vProv[nPos,2])
            vProv[nPos,3] := If( Empty(vProv[nPos,3]) , SRV->RV_CTACRED, vProv[nPos,3])

            // Se for o 1o mes apos as ferias e o lancamento for de baixa, nao pesquisa o mes anterior
            nValAnt := If( nFerias <> 3 .And. !(SRV->RV_CODFOL $ cCodBai) , ProvMesAnt(@lMens), 0)
            vProv[nPos,4] += (RT_VALOR - nValAnt) * If( lBaixa , -1, 1)
         Endif

         dbSkip()
      Enddo

      /* Contabiliza provisoes acumuladas */
      vItem := {}
      For p:=3 To Len(vProv)
         If vProv[p,4] <> 0
            Do Case
               Case p == 3  ;  cMens := "PROV. FER. + 1/3 "+mv_par01+"/"+mv_par02
                  //AAdd( vRescis , { "RESC. FER. + 1/3 "    +mv_par01+"/"+mv_par02, vProv[p,4] } )  // Rescisao de Ferias
               Case p == 4  ;  cMens := "PROV. FER. INSS. "+mv_par01+"/"+mv_par02
                  //AAdd( vRescis , { "RESC. FER. INSS. "    +mv_par01+"/"+mv_par02, vProv[p,4] } )  // Rescisao de Ferias - INSS
               Case p == 5  ;  cMens := "PROV. FER. FGTS. "+mv_par01+"/"+mv_par02
               Case p == 6  ;  cMens := "PROV. 13S. "      +mv_par01+"/"+mv_par02
               Case p == 7  ;  cMens := "PROV. 13S. INSS. "+mv_par01+"/"+mv_par02
               Case p == 8  ;  cMens := "PROV. 13S. FGTS. "+mv_par01+"/"+mv_par02
               Case p == 9  ;  cMens := "BAIXA FER. + 1/3 "+mv_par01+"/"+mv_par02
               Case p == 10 ;  cMens := "BAIXA 13S. FGTS. "+mv_par01+"/"+mv_par02
               Case p == 11 ;  cMens := "BAIXA PROV. INSS "+mv_par01+"/"+mv_par02
               Case p == 12 ;  cMens := "BAIXA PROV. FGTS "+mv_par01+"/"+mv_par02
               Case p == 13 ;  cMens := "BAIXA RECIS. FER "+mv_par01+"/"+mv_par02
               Case p == 14 ;  cMens := "BAIXA RECIS. 13S "+mv_par01+"/"+mv_par02
               Case p == 15 ;  cMens := "BAIXA RECIS.INSS "+mv_par01+"/"+mv_par02
               Case p == 16 ;  cMens := "BAIXA RECIS.FGTS "+mv_par01+"/"+mv_par02
            EndCase

            AAdd( vItem , { vProv[p,2], cFunc, "PPPPPP", "PPP", cMens, "PPP", "PPPPP", Space(10), vProv[p,4], "008890", "PROVISA", SRA->RA_CLVL} )
         Endif
      Next

      /* Busca a base de calculo do FGTS para calculo da rescisao */
      dbSelectArea("SRS")
      dbSetOrder(1)
      If dbSeek(XFILIAL("SRS")+cFunc+mv_par02+mv_par01)
         // ----> Colocar os identificadores de calculo para rescisao do FGTS <----
         AAdd( vRescis , { "RESC. FGTS. 40 % "+mv_par01+"/"+mv_par02, RS_SALATU * 0.4, "   " } )  // Rescisao de FGTS 40% Multa
         AAdd( vRescis , { "RESC. FGTS. 10 % "+mv_par01+"/"+mv_par02, RS_SALATU * 0.1, "   " } )  // Rescisao de FGTS 10% Empresa
      Endif

      /* Busca os valores referente ao INSS Folha Rescisao */
      vINSS := { "148", "149", "150"}  // Verbas referente ao calculo do INSS referente a rescisao
      AAdd( vRescis , { "RESC. INSS FOLHA "+mv_par01+"/"+mv_par02, 0, "148" } )  // Rescisao INSS Folha
      For p:=1 To Len(vINSS)
         dbSelectArea("SRV")
         dbSetOrder(2)
         dbSeek(XFILIAL("SRV")+vINSS[p])
         dbSelectArea("SRD")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SRD")+cFunc+mv_par02+mv_par01+SRV->RV_COD)
            vRescis[Len(vRescis),2] += RD_VALOR
            vRescis[Len(vRescis),3] := If( Empty(vRescis[Len(vRescis),3]) , SRV->RV_CTBRD, vRescis[Len(vRescis),3])
         Endif
      Next

      For p:=1 To Len(vRescis)
         If vRescis[p,2] <> 0
            If Len(vRescis[p,3]) <= 3  // Caso nao tenha achado conta contabil para os identificadores definidos
               dbSelectArea("SRV")
               dbSetOrder(2)
               dbSeek(XFILIAL("SRV")+vRescis[p,3])
               vRescis[p,3] := SRV->RV_CTBRD
            Endif
            AAdd( vItem , { vRescis[p,3], cFunc, "PPPPPP", "PPP", vRescis[p,1], "PPP", "PPPPP", Space(10), vRescis[p,2], "008890", "PROVRES", SRA->RA_CLVL} )
         Endif
      Next

      /* Grava valores acumulados no arquivo temporario a ser utilizado para gravacao na contabilidade */
      GravaTemp(vItem,0)

      dbSelectArea("SRT")
   Enddo

   GravaContab("008810",dDtFin,cAlias)
   GravaContab("008890",dDtFin,cAlias)

   dbSelectArea("TMP")
   dbCloseArea()
   FErase(cArq1+".DBF")
   FErase(cInd1+".IDX")
   dbSelectArea("TRB")
   dbCloseArea()
   FErase(cArq2+".DBF")
   FErase(cInd2+".IDX")

   dbSelectArea("QTB")
   dbCloseArea()
   If File("\CONTAB.DBF")
      FErase("\CONTAB.DBF")
   Endif
   FRename(cArq+".DBF","\CONTAB.DBF")
Return
   
Static Function GravaTemp(vItem,nDif)
   Local p, c

   For p:=1 To Len(vItem)
      dbSelectArea("TMP")
      RecLock("TMP",.T.)
      For c:=1 To Len(vItem[p])
         FieldPut( c , vItem[p,c] )
      Next
      If p == Len(vItem) .And. nDif <> 0 // Acerta a diferenca dos centavos no ultimo item
         TMP->VALOR += nDif
         vItem[p,9] += nDif
      Endif
      MsUnLock()

      If !Empty(vItem[p,1]) .And. !Empty(vItem[p,2])   // Seleciona somente os registros com item contabil e conta
         /* Acumula os valores do banco para contabilizacao a credito */
         dbSelectArea("TRB")
         If !dbSeek(vItem[p,10]+vItem[p,6]+vItem[p,7]+vItem[p,8])
            RecLock("TRB",.T.)
            TRB->BANCO   := vItem[p, 6]
            TRB->AGENCIA := vItem[p, 7]
            TRB->CONTA   := vItem[p, 8]
            TRB->LOTE    := vItem[p,10]
         Else
            RecLock("TRB",.F.)
         Endif
         TRB->VALOR += vItem[p,9]
         MsUnLock()
      Endif
   Next
Return

Static Function GravaContab(cLote,dDtFin,cAlias)
   Local aDbf, cArq, cInd, cQuery, cDocLote, cLinLote, cItem, cFunc, cData, aProj, p, nSoma, cMens

   /* Calcula o proximo documento a ser gerado para o lote e a data de referencia */
   #IFDEF TOP
   cQuery := "SELECT MAX(CT2_DOC)CT2_DOC FROM "+RetSQLName("CT2")+" WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"' AND CT2_LOTE = '"+cLote+"' AND "
   cQuery += "CT2_SBLOTE = '001' AND CT2_DATA = '"+Dtos(dDtFin)+"' AND D_E_L_E_T_ = ' '"

   TCQUERY cQuery NEW ALIAS TST
   cDocLote := StrZero(Val(CT2_DOC)+1,6)
   dbCloseArea()
   #ELSE
   dbSelectArea("CT2")
   dbSetOrder(1)
   dbSeek(XFILIAL("CT2")+Dtos(dDtFin)+cLote+"001"+"Z",.T.)
   dbSkip(-1)
   If XFILIAL("CT2")+Dtos(dDtFin)+cLote+"001" == CT2_FILIAL+Dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE
      cDocLote := StrZero(Val(CT2_DOC)+1,6)
   Else
      cDocLote := StrZero(1,6)
   Endif
   #ENDIF
   cLinLote := "001"

   /* Cria arquivo temporario de LOG para gravacao de algum funcionario nao contabilizado */
   aDbf := {}
   AAdd( aDbf , { "LOTE"    , "C",  6, 0})
   AAdd( aDbf , { "ITEMCTA" , "C",  9, 0})
   AAdd( aDbf , { "HIST"    , "C", 30, 0})
   AAdd( aDbf , { "DTLANC"  , "D",  8, 0})
   AAdd( aDbf , { "VALOR"   , "N", 14, 2})
   AAdd( aDbf , { "ORIGEM"  , "C",  7, 0})

   cArq := CriaTrab( aDbf , .T. )
   Use &cArq Alias LOG New Exclusive
   cInd := CriaTrab( NIL  , .F. )
   IndRegua("LOG",cInd,"LOTE+ITEMCTA+ORIGEM",,, "Selecionando Registros...")

   dbSelectArea("TMP")
   dbSeek(cLote,.T.)
   ProcRegua(RecCount())
   While !Eof() .And. LOTE == cLote
      cItem := ITEMCTA
      cFunc := Modela(cItem,6)
      cData := Modela(Dtos(dDtFin),6)
      aProj := {}

      /* Seleciona os projetos cujo funcionario foi alocado */
      dbSelectArea("SZ1")
      dbSetOrder(2)
      dbSeek(XFILIAL("SZ1")+cFunc+cData,.T.)
      While !Eof() .And. XFILIAL("SZ1")+cFunc+cData == Z1_FILIAL+Z1_MAT+SubStr(Dtos(Z1_DATA),1,6)
         AAdd( aProj , { Z1_CC, Z1_HORAS, Z1_PERC} )
         dbSkip()
      Enddo
      dbSelectArea("TMP")

      While !Eof() .And. cItem == ITEMCTA .And. LOTE == cLote

         IncProc("Rateando pagamentos...")

         /* Efetua o rateio conforme projetos */
         nSoma := 0
         If Empty(aProj) .Or. Empty(cItem) .Or. Empty(CONTAC)  // Caso nao tenha projeto, nao tenha Item Ctb ou nao tenha conta contabil
            dbSelectArea("LOG")
            //If dbSeek(cLote+cItem+TMP->ORIGEM)
            //   RecLock("LOG",.F.)
            //Else
               RecLock("LOG",.T.)
               LOG->LOTE    := cLote
               LOG->ITEMCTA := cItem
               LOG->HIST    := If( TMP->SERIE=="PPP" , TMP->BENEF, "VLR. RATEADO NF. "+TMP->DOC+"-"+TMP->SERIE+" "+TMP->BENEF)
               LOG->DTLANC  := dDtFin
               LOG->ORIGEM  := TMP->ORIGEM
            //Endif
            LOG->VALOR += TMP->VALOR
            MsUnLock()
         Else
            dbSelectArea(cAlias)
            For p:=1 To Len(aProj)
               GravaCT2(dDtFin,cLote,@cDocLote,@cLinLote,"D",TMP->CONTAC,Round(TMP->VALOR * aProj[p,3], 2),;
                        If( TMP->SERIE=="PPP" , TMP->BENEF, "VLR. RATEADO NF. "+TMP->DOC+"-"+TMP->SERIE+" "+TMP->BENEF),aProj[p,1],;
                        cItem,TMP->CLASSE,TMP->ORIGEM,cAlias)

               nSoma += (cAlias)->CT2_VALOR

               /* Se a somatoria do valor rateado ficar diferente do valor original, acerta a diferenca no ultimo */
               /* item */
               If p == Len(aProj) .And. nSoma <> TMP->VALOR
                  RecLock(cAlias,.F.)
                  (cAlias)->CT2_VALOR -= (nSoma - TMP->VALOR)
                  MsUnLock()
               Endif
            Next
         Endif
         dbSelectArea("TMP")

         dbSkip()
      Enddo
   Enddo

   /* Efetua contabilizacao a credito (contra partida) no banco */
   dbSelectArea("TRB")
   dbSeek(cLote,.T.)
   ProcRegua(RecCount())
   While !Eof() .And. LOTE == cLote

      IncProc("Contabilizando bancos...")

      dbSelectArea("SA6")
      dbSetOrder(1)
      dbSeek(XFILIAL("SA6")+TRB->(BANCO+AGENCIA+CONTA))

      GravaCT2(dDtFin,cLote,@cDocLote,@cLinLote,"C",SA6->A6_CONTA,TRB->VALOR,"PAGO BANCO "+SA6->A6_NOME,"","","","",cAlias)

      dbSelectArea("TRB")
      dbSkip()
   Enddo

   If LOG->(RecCount()) > 0  // Se existe algo no LOG, imprime
      ImprimeLog()
   Endif
   dbSelectArea("LOG")
   dbCloseArea()
   FErase(cArq+".DBF")
   FErase(cInd+".IDX")
Return

Static Function GravaCT2(dDtFin,cLote,cDocLote,cLinLote,cDC,cConta,nValor,cHist,cCC,cItem,cClasse,cOrigem,cAlias)
   RecLock(cAlias,.T.)
   (cAlias)->CT2_FILIAL := XFILIAL("CT2")
   (cAlias)->CT2_DATA   := dDtFin
   (cAlias)->CT2_LOTE   := cLote
   (cAlias)->CT2_SBLOTE := "001"
   (cAlias)->CT2_DOC    := cDocLote
   (cAlias)->CT2_LINHA  := cLinLote
   (cAlias)->CT2_MOEDLC := "01"
   (cAlias)->CT2_DC     := If( cDC == "D" ,     "1", "2")
   (cAlias)->CT2_DEBITO := If( cDC == "D" , cConta ,  "")
   (cAlias)->CT2_CREDIT := If( cDC == "C" , cConta ,  "")
   (cAlias)->CT2_CLVLDB := If( cDC == "D" , cClasse,  "")
   (cAlias)->CT2_CLVLCR := If( cDC == "C" , cClasse,  "")
   (cAlias)->CT2_DCD    := ""
   (cAlias)->CT2_DCC    := ""
   (cAlias)->CT2_VALOR  := nValor
   (cAlias)->CT2_MOEDAS := ""
   (cAlias)->CT2_HP     := ""
   (cAlias)->CT2_HIST   := cHist
   (cAlias)->CT2_CCD    := If( cDC == "D" ,   cCC, "")
   (cAlias)->CT2_CCC    := If( cDC == "C" ,   cCC, "")
   (cAlias)->CT2_ITEMD  := If( cDC == "D" , cItem, "")
   (cAlias)->CT2_ITEMC  := If( cDC == "C" , cItem, "")
   (cAlias)->CT2_EMPORI := SM0->M0_CODIGO
   (cAlias)->CT2_FILORI := SM0->M0_CODFIL
   (cAlias)->CT2_TPSALD := "3"
   (cAlias)->CT2_SEQUEN := ""      // Sequencia de digital Manual, Se CT2_MANUAL="1" nao precisa gravar
   (cAlias)->CT2_MANUAL := "1"
   (cAlias)->CT2_ORIGEM := cOrigem
   (cAlias)->CT2_ROTINA := "INDA020"
   (cAlias)->CT2_AGLUT  := "2"    // ??
   (cAlias)->CT2_LP     := ""
   (cAlias)->CT2_SEQHIS := "001"  // ??
   (cAlias)->CT2_SEQLAN := (cAlias)->CT2_LINHA
   (cAlias)->CT2_SLBASE := "N"    // ??
   (cAlias)->CT2_CRCONV := "1"
   (cAlias)->CT2_CRITER := ""
   MsUnLock()

   cLinLote := StrZero(Val(cLinLote)+1,3)
   If Val(cLinLote) > 999
      cDocLote := StrZero(Val(cDocLote)+1,6)
      cLinLote := "001"
   Endif
Return

Static Function Modela(cVar,nTam)
   Local cRet

   cRet := AllTrim(cVar)
   cRet := SubStr(cVar,1,nTam)
   cRet += Space(nTam-Len(cRet))

Return(cRet)

Static Function ProvMesAnt(lMens)
   Local nRet, nReg, nInd, cAlias, vAnt, dLastDay, cQuery, dDtAdm

   cAlias := Alias()
   nReg   := SRT->( Recno() )
   nInd   := SRT->( IndexOrd() )
   nRet   := 0

   dbSelectArea("SRT")
   dLastDay := Ctod("01"+SubStr(Dtoc(RT_DATACAL),3,8)) - 1  // Data da provisao do mes anterior
   vAnt := { RT_MAT, RT_CC, dLastDay, If( RT_TIPPROV $ "12" , "2", RT_TIPPROV), RT_VERBA}

   dbSetOrder(1)
   If dbSeek(XFILIAL("SRT")+vAnt[1]+vAnt[2]+Dtos(vAnt[3])+vAnt[4]+vAnt[5])
      nRet := RT_VALOR
   Else
      dbSelectArea("SRE")
      dbSetOrder(4)
      If dbSeek(SM0->M0_CODIGO+SM0->M0_CODFIL+vAnt[1]+Dtos(dLastDay+1)+vAnt[2])
         vAnt := { RE_MATD, RE_CCD, dLastDay, vAnt[4], vAnt[5]}
         If RE_EMPD == SM0->M0_CODIGO    // Se a empresa anterior for a mesma
            dbSelectArea("SRT")
            dbSetOrder(1)
            If dbSeek(XFILIAL("SRT")+vAnt[1]+vAnt[2]+Dtos(vAnt[3])+vAnt[4]+vAnt[5])
               nRet := RT_VALOR
            ElseIf lMens
               Alert("Funcionario "+vAnt[1]+" sem calculo da provisao do mes anterior !")
               lMens := .F.
            Endif
         Else
            cQuery := "SELECT RT_VALOR FROM SRT"+RE_EMPD+"0 WHERE RT_FILIAL = '"+RE_FILIALD+"' AND RT_MAT = '"+RE_MATD+"' AND "
            cQuery += "RT_CC = '"+RE_CCD+"' AND D_E_L_E_T_ = ' '"

            dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQRY)), "QRY", .F., .T.)
            nRet := If( ValType(RT_VALOR) == "U" , 0, RT_VALOR)
            dbCloseArea()
            If nRet == 0 .And. lMens
               Alert("Funcionario "+vAnt[1]+" sem calculo da provisao do mes anterior !")
               lMens := .F.
            Endif
         Endif
      Else
         dDtAdm := Posicione("SRA",1,XFILIAL("SRA")+vAnt[1],"RA_ADMISSA")   // Pega data de admissao
         If SubStr(Dtos(dDtAdm),1,6) <= SubStr(Dtos(dLastDay),1,6) .And. lMens
            Alert("Funcionario "+vAnt[1]+" sem calculo da provisao do mes anterior !")
            lMens := .F.
         Endif
      Endif
      dbSelectArea("SRT")
   Endif

   dbSetOrder(nInd)
   dbGoTo(nReg)
   dbSelectArea(cAlias)

Return(nRet)

Static Function ImprimeLog()
Local cString       := "SRA"
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Rateio de Projeto - LOG"
Local cPict         := ""
Local titulo        := "Rateio de Projeto - LOG"
Local nLin          := 80
//Local Cabec1      := "Lote    Matr    Nome                             Data       Origem         Valor"
 //                     xxxxxx  xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99/99/9999  xxxxxxx  9999.999.99
 //                               1         2         3         4         5         6         7
 //                     01234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1        := "Matr   Nome                           Hist                                 Valor"
 //                     xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9999.999.99
 //                               1         2         3         4         5         6         7
 //                     01234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec2        := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "INDRLOG" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "INDRLOG" // Coloque aqui o nome do arquivo usado para impressao em disco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,{},.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Set Century On

dbSelectArea("LOG")
SetRegua(RecCount())
dbGoTop()
While !EOF()

   IncRegua()

   If nLin > 55
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
      @ nLin,005 PSAY LOG->DTLANC
      nLin := nLin + 2
   Endif
   //@ nLin,000 PSAY LOG->LOTE
   //@ nLin,Pcol()+2 PSAY SubStr(LOG->ITEMCTA,1,6)
   //@ nLin,Pcol()+2 PSAY SubStr(Posicione("SRA",1,XFILIAL("SRA")+SubStr(LOG->ITEMCTA,1,6),"RA_NOME"),1,30)
   //@ nLin,Pcol()+2 PSAY LOG->DTLANC
   //@ nLin,Pcol()+2 PSAY LOG->ORIGEM
   //@ nLin,Pcol()+2 PSAY LOG->VALOR Picture "@E 9999,999.99"

   @ nLin,000      PSAY SubStr(LOG->ITEMCTA,1,6)
   @ nLin,Pcol()+1 PSAY SubStr(Posicione("SRA",1,XFILIAL("SRA")+SubStr(LOG->ITEMCTA,1,6),"RA_NOME"),1,30)
   @ nLin,Pcol()+1 PSAY LOG->HIST
   @ nLin,Pcol()+1 PSAY LOG->VALOR Picture "@E 9999,999.99"
   nLin := nLin + 1

   dbSkip()
EndDo

Set Century Off

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()
Return

Static Function ValidPerg(cPerg)
   Local i, j, aRegs, _sAlias := Alias()

   aRegs := {}
   dbSelectArea("SX1")
   dbSetOrder(1)

   AADD(aRegs,{cPerg,"01","Mes Referencia     ?","","","mv_ch1","C",02,0,0,"G","","mv_par01"})
   AADD(aRegs,{cPerg,"02","Ano Referencia     ?","","","mv_ch2","C",04,0,0,"G","","mv_par02"})
   AADD(aRegs,{cPerg,"03","Prov. AD.+ Ferias  ?","","","mv_ch3","C",30,0,0,"G","","mv_par03","","","","130,133,254,255,256,257"})
   AADD(aRegs,{cPerg,"04","Prov. INSS Ferias  ?","","","mv_ch4","C",30,0,0,"G","","mv_par04","","","","131,134"})
   AADD(aRegs,{cPerg,"05","Prov. FGTS Ferias  ?","","","mv_ch5","C",30,0,0,"G","","mv_par05","","","","132,135"})
   AADD(aRegs,{cPerg,"06","Prov. 13o Salario  ?","","","mv_ch6","C",30,0,0,"G","","mv_par06","","","","136,139,267,269"})
   AADD(aRegs,{cPerg,"07","Prov. 13o INSS     ?","","","mv_ch7","C",30,0,0,"G","","mv_par07","","","","137,140"})
   AADD(aRegs,{cPerg,"08","Prov. 13o FGTS     ?","","","mv_ch8","C",30,0,0,"G","","mv_par08","","","","138,141"})
   AADD(aRegs,{cPerg,"09","Baixa Prov. Ferias ?","","","mv_ch9","C",30,0,0,"G","","mv_par09","","","","233,258,259"})
   AADD(aRegs,{cPerg,"10","Baixa Prov. 13o Sal?","","","mv_cha","C",30,0,0,"G","","mv_par10","","","","268"})
   AADD(aRegs,{cPerg,"11","Baixa Prov. INSS   ?","","","mv_chb","C",30,0,0,"G","","mv_par11","","","","234"})
   AADD(aRegs,{cPerg,"12","Baixa Prov. FGTS   ?","","","mv_chc","C",30,0,0,"G","","mv_par12","","","","235"})
   AADD(aRegs,{cPerg,"13","Baixa Recis. Ferias?","","","mv_chd","C",30,0,0,"G","","mv_par13","","","","262,263,264"})
   AADD(aRegs,{cPerg,"14","Baixa Recis.13o Sal?","","","mv_che","C",30,0,0,"G","","mv_par14","","","","XXX"})
   AADD(aRegs,{cPerg,"15","Baixa Recis. INSS  ?","","","mv_chf","C",30,0,0,"G","","mv_par15","","","","265"})
   AADD(aRegs,{cPerg,"16","Baixa Recis. FGTS  ?","","","mv_chg","C",30,0,0,"G","","mv_par16","","","","266"})

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
Return(Len(aRegs))
