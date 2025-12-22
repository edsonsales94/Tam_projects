/*/
###############################################################################
###############################################################################
###Programa  ³ INDADSE5 º Autor ³ Ronilton O. Barros º Data ³  28/12/04   #####
###############################################################################
###Descricao ³ Rotina de Busca dos dados referente a rateio por C.C. e    #####
###############################################################################
###19/01/05  ³ Incluida rotina para tratamento diferenciado do P.A        #####
###15/03/05  ³ Inclusao dos parametros cFilUsr,lFin,lMat,lGPE para definir#####
###          ³ o filtro do usuario e quais origens serao consideradas     #####
###23/03/05  ³ Incluida a gravacao do numero do processo de forma que seja#####
###          ³ possivel calcular o custo total de um pedido               #####
###############################################################################
###Uso       ³ Especifico INDT                                            #####
###############################################################################
###############################################################################
###############################################################################
/*/

User Function INDADSE5(cTab,cQuery,aStru,cFilUsr,lFin,lMat,lGPE,nTrataPA,cOrig,lNewFile,cMCT,lJunRP,lComp)
   Local aDbf, cArq, cQuery, ni, cBusca, nPos, nValor, nSom1, nSom2, vRat1, vRat2, nRegis, vFunc, x, y, nT
   Local cConta, cCusto, nPerc, nValRat, vImp, cPrint, nTotal, vNota, cViagem, nValImp
   Local cFilDe, cFilAte, cCCDe, cCCAte, cMatDe, cMatAte, vFunc, cFunc, nPgto, nRcto, nPV, lGravou, nPrc
   Local c_CCusto, c_Clvl, c_ItemCta, cTreina, cHora, lTrataPA, c_FilTrf, c_FilTrv, c_Filtro, cQry
   Local cEstado, cChave, cTmpFol, lErro, dBuscai, dBuscaf, cFilTit
   Local vVarFil := {}

   Private cFilSE5, vTit, nT, cFiltroU, cSE5
   //Private cQrySE5 := cQuery
   Private lMostra := .T.

   If Type("cOrigFlx") == "U"   // Se variavel nao existir declara, senao atribui somente valor
      Private cOrigFlx
   Endif
   If Type("cClsMCT")  == "U"   // Se variavel nao existir declara, senao atribui somente valor
      Private cClsMCT
   Endif

   nPrc     := 0.01                                  // Precisao do arredondamento
   cFilUsr  := If( cFilUsr  == nil ,  "", cFilUsr)   // Define o filtro do usuario
   cFiltroU := If( cFilUsr  == nil , " ", cFilUsr)   // Filtro do Usuario
   lFin     := If( lFin     == nil , .T., lFin   )   // Define se ira processar os titulos do Financeiro
   lMat     := If( lMat     == nil , .T., lMat   )   // Define se ira processar os titulos do Compras/Estoque
   lGPE     := If( lGPE     == nil , .T., lGPE   )   // Define se ira processar os titulos da Folha de Pagamento
   lTrataPA := If( nTrataPA == nil .or. nTrataPA == 1, .T., .F.   ) // Define tratamento de PA's
   cOrigFlx := If( cOrig    == nil , " ", cOrig)     // Define origem de busca
   lNewFile := If( lNewFile == nil , .T., lNewFile ) // Define se ira gerar novo arquivo temporario
   cClsMCT  := If( cMCT     == nil , " ", cMCT)      // Classe MCT (Valor)
   lJunRP   := If( lJunRP   == nil , .T., lJunRP)    // Define se junta recebimento e pagamento de um mesmo item
   lComp    := If( lComp    == nil , .F., lComp)     // Define se está processando dados da competência

   // Define as variaveis que serao trocadas no filtro do usuario
   AAdd( vVarFil , { "E5_DEBITO", "E5_CONTAB"  })  //"cConta"
   AAdd( vVarFil , { "E5_CLVLDB", "E5_CLVL"    })  //"cClasVal"
   AAdd( vVarFil , { "E5_CCD"   , "E5_CC"      })  //"cCC"
   AAdd( vVarFil , { "E5_ITEMD" , "E5_ITEMCTA" })  //"cItemCta"
   For ni:=1 To Len(vVarFil)
      If vVarFil[ni,1] $ cFiltroU  // Caso ache a variavel
         cFiltroU := StrTran(cFiltroU,vVarFil[ni,1],vVarFil[ni,2])   // Troca para a outra variavel
         cFilUsr  := AcertaFiltro(cFilUsr,vVarFil[ni,1])             // Acerta filtro do usuario
      Endif
   Next

   cEstado  := GetMv("MV_ESTADO") //Estado de origem para verificar transferencia entre sites

   If lNewFile
      aDbf := u_CpoPadSE5()
      cArq := CriaTrab(aDbf,.t.)
      Use &cArq Alias &(cTab) New Exclusive
   Endif

   //- Conta o numero de registros filtrados pela query
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "SOM", .T., .F. )
   nRegis:= SOMA
   dbCloseArea()
                                                           
   //- Troca a expressao COUNT(*) por * na clausula SELECT
   cQuery:= StrTran(cQuery,"COUNT(*) SOMA","*")
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TBS", .T., .F. )

   For ni := 1 to Len(aStru)
      If aStru[ni,2] != "C"
         TCSetField("TBS", aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
      Endif
   Next

   /* Impressao dos Dados */
   dbSelectArea("TBS")
   dbGoTop()
   ProcRegua(nRegis)

   Do while !EOF()

      IncProc()

      If !Empty(cFilUsr) .and. !(&cFilUsr)
         dbSkip()
         Loop
      EndIf

     //###############################################################################
     //#### Lancamentos incluido via movimentacao bancaria - E5_MOTBX = ''  ##########
     //###############################################################################
      vTit := {}
      cSE5 := "TBS"
      If Alltrim(("TBS")->E5_HISTOR) == 'Est.Resg.Aplicacao CDI'
         dbSkip()
         Loop
      EndIf
      
      If lFin .and. lMat .and. (Empty(E5_MOTBX) .Or. lComp .And. E5_MOTBX == "DEB")
         nValor := (cSE5)->E5_VALOR
         cConta := Posicione("SED",1,XFILIAL("SED")+(cSE5)->E5_NATUREZ,"ED_CONTAB")
         cViagem:= BscViagem((cSE5)->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))

         If E5_RATEIO == "N" //  (cOrigFlx $ " DF" .and. E5_RATEIO == "N")
            //- Tratamento especial para Estorno de CPMF (para o relatorio de despesas de projetos
            If Empty(cOrigFlx)
               If E5_RECPAG == "R"
                  nValor:= (cSE5)->E5_VALOR * (-1)
               Else
                  nValor:= (cSE5)->E5_VALOR
               Endif
            Endif
            //#######################
            //³ Aporte Nokia ³
            //#######################
            If Trim((cSE5)->E5_CLVLDB) = '010'
               cOrigFlx:= '4'
            Endif
         ElseIf Empty(E5_RATEIO)
            //##############################################
            //## Transferencia, Aplicacao e Resgate ##
            //##############################################
            If Trim((cSE5)->E5_TIPODOC) = 'TR' //- Transferencias
               If (cSE5)->E5_RECPAG = 'P'
                  DbSelectArea("SE5")
                  DbSetOrder(10) //- E5_FILIAL+E5_DOCUMEN
                  dbSeek((cSE5)->E5_FILIAL+(cSE5)->E5_NUMCHEQ)
                  cChave:= SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
               Else
                  cChave:= (cSE5)->E5_BANCO+(cSE5)->E5_AGENCIA+(cSE5)->E5_CONTA
               Endif
               SA6->(dbSetOrder(1))
               SA6->(dbSeek(XFILIAL("SA6")+cChave))
               If SA6->A6_EST != cEstado
                  cOrigFlx:= '3' //- Transferencia entre sites
               Else
                  cOrigFlx:= '9' //- Transferencia no local
               Endif
               dbSelectArea("TBS")
            Endif
            If Trim((cSE5)->E5_TIPODOC) = 'AP' //- Aplicacacoes
               cOrigFlx:= '7'
            Endif
            If Trim((cSE5)->E5_TIPODOC) = 'RF' //- Resgates
               cOrigFlx:= '8'
            Endif
         Endif
         //-        1     2            3           4            5                 6           7      8      9   10   11   12   13   14        15            16   17   18   19
         GrvTmpE5(cTab, nValor, (cSE5)->E5_CCD, cConta, (cSE5)->E5_CLVLDB, (cSE5)->E5_ITEMD, "S", cViagem, nil, nil, nil, nil, nil, nil, (cSE5)->E5_HISTOR, nil, nil, nil, lComp)
         cOrigFlx:= If(cOrig == nil , " ", cOrig)
      Endif

      // Se tiver processando dados da competência, para aqui e passa para o próximo registro
      If lComp
         dbSkip()
         Loop
      Endif

      cFilSE5 := E5_FILIAL
      cBusca  := E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA
      cPrint  := "S"
      vImp    := FindSE5(@cBusca) //- Busca o titulo principal ref. a titulos de impostos

      If !Empty(E5_CLIENTE)
         BuscaCtaRec(cTab,cSE5,cBusca,lFin,lMat)
         dbSkip()
         Loop
      Endif

      //- Verificando se esta baixado e existe no SE2 - contas a pagar
      dbSelectArea("SE2")
      dbSetOrder(1)
      If Empty((cSE5)->E5_MOTBX) .or. !dbSeek(cFilSE5+cBusca)
         dbSelectArea("TBS")
         dbSkip()
         Loop
      Endif
      dDtDigit:= E2_EMISSAO //funciona !!! (Modificado em 13/05/05)

      // Ignora os titulos que o usuario nao deseja processar dependendo da sua origem
      If (!lFin .And. Trim(E2_ORIGEM) == "FINA050") .Or.;
         (!lMat .And. Trim(E2_ORIGEM) == "MATA100") .Or.;
         (!lGPE .And. Trim(E2_ORIGEM) == "GPEM670")
         dbSelectArea("TBS")
         dbSkip()
         Loop
      Endif

      //- Pega o valor baixado
      nTotal := (cSE5)->E5_VALOR

      //- Verificando se o documento baixado é um PA
      If lTrataPA .and. (cSE5)->E5_TIPO $ MVPAGANT .and. (cSE5)->E5_RECPAG = "P" .and. (cSE5)->E5_MOTBX == "NOR"
         vTit := (cSE5)->(TrataPA(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO,E5_CLIFOR,E5_LOJA))
         If !Empty(vTit)          // Se encontrou algum título
            nTotal := E2_VLCRUZ   //- Retorna o saldo restante do PA
            For x:=1 To Len(vTit)  ;  nTotal -= vTit[x,2]  ;  Next  // Subtrai o valor das compensacoes
         Endif
      Endif
      AAdd( vTit , { Recno() , nTotal, "TBS", 0})  // Guarda o titulo atual

      For nT:=1 To Len(vTit)

         If vTit[nT,2] <= 0      // Ignora os valores negativos ou zerados
            Loop
         Endif

         dbGoTo(vTit[nT,1])      // Posiciona no titulo do contas a pagar
         cBusca := E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
         cSE5   := "TBS"

         If vTit[nT,4] > 0            // Caso tenha numero do registro
            SE5->(dbGoTo(vTit[nT,4])) // Posiciona na baixa do SE5
            cSE5 := vTit[nT,3]        // Pega a tabela do SE5
         Endif
         nTotal := vTit[nT,2]         // Pega o valor baixado do titulo

         If Trim(E2_ORIGEM) == "MATA100"  // Caso a origem seja o modulo de compras
            nSom1  := 0
            vRat1  := {}
            cBusca := E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
            vNota  := {}
            cConta := Posicione("SED",1,XFILIAL("SED")+E2_NATUREZ,"ED_CONTAB") // Pega conta do titulo principal

            //- Pesquisa nas tabelas de Nota fiscal de entrada
            SF1->(dbSetOrder(1))
            SF1->(dbSeek(cFilSE5+cBusca))
            SD1->(dbSetOrder(1))
            SD1->(dbSeek(cFilSE5+cBusca,.T.))

            //- Totalizar o valor dos impostos
            nValImp:= 0.00

            While !SD1->(Eof()) .And. cFilSE5+cBusca == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

               If SD1->D1_TOTAL = 0
                  SD1->(dbSkip())
                  Loop
               EndIf

               nValor  := SD1->(D1_TOTAL - (D1_VALIMP1 + D1_VALIMP2 + D1_VALIMP3))
               nValImp += SD1->(D1_VALIMP1 + D1_VALIMP2 + D1_VALIMP3)

               If !((cSE5)->E5_TIPO $ "TX ,INS,ISS")  // Se nao for titulo de imposto, pega conta do item
                  cConta := SD1->D1_CONTA
               Endif

               vRat2 := {{ nValor, SD1->D1_CC}}

               // Caso haja rateio para o item, busca os centros de custos que entraram no rateio e já calcula o valor rateado
               If SD1->D1_RATEIO == "1"
                  SDE->(dbSetOrder(1))
                  If SDE->(dbSeek(SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM,.T.))
                     vRat2 := {}
                     While !SDE->(Eof()) .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM == SDE->DE_FILIAL+SDE->DE_DOC+SDE->DE_SERIE+SDE->DE_FORNECE+SDE->DE_LOJA+SDE->DE_ITEMNF
                        AAdd( vRat2 , { Round(nValor * SDE->DE_PERC / 100,2), SDE->DE_CC})
                        SDE->(dbSkip())
                     Enddo

                     nSom2 := 0
                     AEval( vRat2 , {|x| nSom2 += x[1] })   // Soma os valores rateados

                     AcertaDif(nValor-nSom2,@vRat2,@nSom2,nPrc)
                  Endif
               Endif

               //- Acumula por D1_CC + D1_CONTA + D1_CLVL + D1_ITEMCTA + D1_PRCOMP */
               For y:=1 To Len(vRat2)

                  nPos:= AScan( vNota , {|x| x[1]+x[2]+x[3]+x[4]+x[10] == vRat2[y,2]+cConta+SD1->(D1_CLVL+D1_ITEMCTA+D1_PRCOMP) } )
                  If nPos == 0
                     //              1           2       3             4                5  6               7                8               9             10              11             12            13            14
                     AAdd( vNota , { vRat2[y,2], cConta, SD1->D1_CLVL, SD1->D1_ITEMCTA, 0, SD1->D1_VIAGEM, SD1->D1_TREINAM, SD1->D1_DESCRI, SD1->D1_HORA, SD1->D1_PRCOMP, SD1->D1_QUANT, SD1->D1_NODI, SD1->D1_ITEM, SD1->D1_CBASEAF  } )
                     nPos:= Len(vNota)
                  Endif
                  vNota[nPos,5] += vRat2[y,1]

               Next

               SD1->(dbSkip())
            Enddo

            /* Grava os valores acumulados da nota fiscal */
            For x:=1 To Len(vNota)
               nPerc := vNota[x,5] / (SF1->F1_VALMERC - nValImp )
               AAdd( vRat1 , { Round(nTotal*nPerc,2), vNota[x,1], vNota[x,2], vNota[x,3], vNota[x,4], vNota[x,6], vNota[x,8], vNota[x,7], vNota[x,9], vNota[x,10], vNota[x,11], vNota[x,12], vNota[x,13], vNota[x,14]} )
               nSom1 += Round(nTotal * nPerc,2)
            Next

            //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
            AcertaDif(nTotal-nSom1,@vRat1,@nSom1,nPrc)
            For x:=1 To Len(vRat1)
               //-       1            2           3           4           5           6    7            8           9           10          11           12           13           14  15   16        17           18      19
               GrvTmpE5(cTab, vRat1[x,1], vRat1[x,2], vRat1[x,3], vRat1[x,4], vRat1[x,5],cPrint,vRat1[x,6], vRat1[x,7], vRat1[x,8], vRat1[x,9], vRat1[x,10], vRat1[x,11], vRat1[x,12], nil, nil, vRat1[x,13], vRat1[x,14], nil)
            Next
         ElseIf Trim(E2_ORIGEM) == "FINA050"  //- Caso a origem seja do financeiro (contas a pagar)

            If E2_MULTNAT == "1"   //- Caso seja multiplas naturezas
               cConta := Posicione("SED",1,XFILIAL("SED")+E2_NATUREZ,"ED_CONTAB") // Pega conta do titulo principal
               nSom1  := 0
               vRat1  := {}

               //- Rateio por multiplas naturezas
               dbSelectArea("SEV")
               dbSetOrder(1)
               dbSeek(cFilSE5+SubStr(cBusca,1,21),.t.)
               Do while !Eof() .and. cFilSE5+SubStr(cBusca,1,21) == EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA

                  If EV_RECPAG <> "P"  //- Somente titulos a pagar
                     dbSkip()
                     Loop
                  Endif

                  nValor:= Round(nTotal * SEV->EV_PERC,2)

                  If EV_RATEICC == "1"  // Caso seja multi-centro de custo
                     nSom2  := 0
                     vRat2  := {}
                     cBusca := SubStr(cBusca,1,21) + EV_NATUREZ

                     //- Rateio por multiplos centros de custos
                     dbSelectArea("SEZ")
                     dbSetOrder(1)
                     dbSeek(cFilSE5+cBusca,.T.)
                     Do while !Eof() .and. cFilSE5+cBusca == EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ

                        If EZ_RECPAG <> "P" //- Somente titulos a pagar
                           dbskip()
                           Loop
                        Endif

                        c_CCusto  := If(Empty(SEZ->EZ_CCUSTO) , SE2->E2_CC     , SEZ->EZ_CCUSTO)
                        c_Clvl    := If(Empty(SEZ->EZ_CLVL)   , SE2->E2_CLVL   , SEZ->EZ_CLVL)
                        c_ItemCta := If(Empty(SEZ->EZ_ITEMCTA), SE2->E2_ITEMCTA, SEZ->EZ_ITEMCTA)

                        If !((cSE5)->E5_TIPO $ "TX ,INS,ISS")  // Se nao for titulo de imposto, pega conta do rateio
                           cConta := Posicione("SED",1,XFILIAL("SED")+EZ_NATUREZ,"ED_CONTAB")
                        Endif
                        nValRat := Round(nValor * EZ_PERC,2)
                        nSom2   += nValRat

                        AAdd( vRat2 , { nValRat, c_CCusto, cConta, c_Clvl, c_ItemCta} )

                        dbSkip()
                     Enddo

                     //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
                     AcertaDif(nValor-nSom2,@vRat2,@nSom2,nPrc)
                     For x:=1 To Len(vRat2)
                        AAdd( vRat1 , { vRat2[x,1], vRat2[x,2], vRat2[x,3], vRat2[x,4], vRat2[x,5]} )
                     Next
                     nSom1 += nSom2
                     dbSelectArea("SEV")
                  Else
                     cConta := Posicione("SED",1,XFILIAL("SED")+SEV->EV_NATUREZ,"ED_CONTAB")
                     AAdd( vRat1 , { nValor, SE2->E2_CC, cConta, SE2->E2_CLVL, SE2->E2_ITEMCTA} )
                     nSom1 += nValor
                  Endif
                  dbSkip()
               Enddo

               //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
               AcertaDif(nTotal-nSom1,@vRat1,@nSom1,nPrc)
               For x:=1 To Len(vRat1)
                  //-        1       2           3            4          5          6          7           8          9         10          11   12   13   14   15   16  17   18   19
                  GrvTmpE5(cTab, vRat1[x,1], vRat1[x,2], vRat1[x,3], vRat1[x,4], vRat1[x,5], cPrint, SE2->E2_VIAGEM, nil, SE2->E2_TREINAM, nil, nil, nil, nil, nil, nil, nil, nil, nil)
               Next
            ElseIf Empty(cClsMCT) .Or. cClsMCT == SE2->E2_CLVL
               cConta:= Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_CONTAB")
               //-       1        2          3        4            5             6         7            8         9      10           11         12         13   14   15   16   17   18   19
               GrvTmpE5(cTab, nTotal, SE2->E2_CC, cConta, SE2->E2_CLVL, SE2->E2_ITEMCTA, cPrint, SE2->E2_VIAGEM, nil, SE2->E2_TREINAM, nil, SE2->E2_PEDIDO, nil, nil, nil, nil, nil, nil, nil)
            Endif

            // Caso a origem seja da folha de pagamento 
         ElseIf Trim(E2_ORIGEM) == "GPEM670" .And. (Empty(cClsMCT) .Or. cClsMCT == SE2->E2_CLVL)
            cFilDe  := SubStr(E2_PARFOL, 1,2)
            cFilAte := SubStr(E2_PARFOL, 3,2)
            cCCDe   := SubStr(E2_PARFOL, 5,9)
            cCCAte  := SubStr(E2_PARFOL,14,9)
            cMatDe  := SubStr(E2_PARFOL,23,6)
            cMatAte := SubStr(E2_PARFOL,29,6)
            dBuscai := E2_BUSCAI
            dBuscaf := E2_BUSCAF
            cMesFol := E2_DATARQ //- Adelson Considerar somente movimentações do mês
            cFilTit := SE2->(If( Empty(E2_FILORIG) , E2_FILIAL, E2_FILORIG))
            lGravou := .f.
            lErro   := .f.
            cConta  := Posicione("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTAB")

            If Empty(dBuscai) .or. Empty(dBuscaf)
               RC1->(dbSetOrder(2))
               If RC1->(dbSeek(SE2->(E2_FILIAL+E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO)))
                  dBuscai := RC1->RC1_DTBUSI
                  dBuscaf := RC1->RC1_DTBUSF
               Else
                  lErro:= .t.
               Endif
            Endif

            If !lErro

               // Armazena as verbas utilizadas para auxiliar no filtro da query
               cVerbas := StrTran(StrTran(AllTrim(E2_VERBAS),"D","','"),"P","','")
               If !Empty(cVerbas)
                  cVerbas := "('"+SubStr(cVerbas,1,Len(cVerbas)-2)+") "
                 If at("')",cVerbas) = 0
                   cVerbas := SubStr(cVerbas,1,Len(cVerbas)-2)+"') "
                 EndIf
               Else
                  cVerbas := "('XXX') "
               Endif

               // Verifica se o titulo se refere ao periodo atual
               If cMesFol >= Trim(GetMV("MV_FOLMES"))
                  cTmpFol := RetSQLName("SRC")
               Else
                  If SubStr(cMesFol,5,2) == "13"  // Se for um titulo de 13o
                     cTmpFol := "RI"+SM0->M0_CODIGO+SubStr(cMesFol,3,4)
                  Else
                     cTmpFol := "RC"+SM0->M0_CODIGO+SubStr(cMesFol,3,4)
                  Endif
               Endif

               // Inicializa variavel de filtro
               c_FilTrv := StrTran(AllTrim(E2_FILTRV),".T.","")

               // Caso exista filtro pela tabela SRR, limpa pois essa tabela nao eh usada no filtro
               If "RR_" $ c_FilTrv
                  c_FilTrv := ""
               Endif

               //- Acerta o filtro do campo E2_FILFOL para pegar do SRD
               c_FilTrf := StrTran(AllTrim(E2_FILFOL),".T.","")

               //- Modificado em 09/09/05 para pegar o filtro pelo financeiro
               c_Filtro := c_FilTrv
               If !Empty(c_FilTrf)
                  If Empty(c_Filtro)
                     c_Filtro := c_FilTrf
                  ElseIf !(c_Filtro $ c_FilTrf)
                     c_Filtro += ".AND." + c_FilTrf
                  Endif            
               Endif

               // Agrupamento por 1-Filial, 2-Centro Custo, 3-Nivel Centro Custo ou 4-Funcionario
               cQry := "SELECT RC_MAT TMP_MAT, RC_PD TMP_PD, RC_VALOR TMP_VALOR "
               cQry += "FROM "+RetSQLName("SRC")+" A, "+RetSQLName("SRA")+" B "
               cQry += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND RC_FILIAL = '"+cFilTit+"' AND "
               cQry += "RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND "
               cQry += If( Empty(c_Filtro) , "", u_ConvFilUsu(c_Filtro)+" AND ")
               cQry += "RC_FILIAL >= '"+cFilDe+"' AND RC_FILIAL <= '"+cFilAte+"' AND "
               cQry += "RC_MAT >= '"+cMatDe+"' AND RC_MAT <= '"+cMatAte+"' AND "
               cQry += "RC_CC >= '"+cCCDe+"' AND RC_CC <= '"+cCCAte+"' AND RA_FILIAL = RC_FILIAL AND "
               cQry += "RC_PD IN "+cVerbas

               If E2_AGRUPA == "4"   // Se agrupamento for por funcionario, filtra tambem pela matricula
                  cQry += "AND RC_MAT = '"+SubStr(E2_ITEMCTA,1,6)+"' "
               ElseIf E2_AGRUPA == "2"
                  cQry += "AND RC_CC = '"+E2_CC+"' "
               Endif
               
               cQry += " UNION ALL "

               cQry += "SELECT RD_MAT TMP_MAT, RD_PD TMP_PD, RD_VALOR TMP_VALOR "
               cQry += "FROM "+RetSQLName("SRD")+" A, "+RetSQLName("SRA")+" B "
               cQry += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND RD_FILIAL = '"+cFilTit+"' AND "
               cQry += "RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND "
               cQry += If( Empty(c_Filtro) , "", u_ConvFilUsu(c_Filtro)+" AND ")
               cQry += "RD_DATARQ >= left('"+Dtos(dBuscai)+"',6) AND "
               cQry += "RD_FILIAL >= '"+cFilDe+"' AND RD_FILIAL <= '"+cFilAte+"' AND "
               cQry += "RD_MAT >= '"+cMatDe+"' AND RD_MAT <= '"+cMatAte+"' AND "
               cQry += "RD_CC >= '"+cCCDe+"' AND RD_CC <= '"+cCCAte+"' AND RA_FILIAL = RD_FILIAL AND "
               cQry += "RD_PD IN "+cVerbas

               If E2_AGRUPA == "4"   // Se agrupamento for por funcionario, filtra tambem pela matricula
                  cQry += "AND RD_MAT = '"+SubStr(E2_ITEMCTA,1,6)+"' "
               ElseIf E2_AGRUPA == "2"
                  cQry += "AND RD_CC = '"+E2_CC+"' "
               Endif
               
               cQry += "ORDER BY TMP_MAT"

               // Acerto para o filtro de funcinarios demitidos. Esse filtro deve ser ignorado
               If "RA_SITFOLH <> 'D'" $ cQry
                  cQry := StrTran(cQry,"RA_SITFOLH <> 'D'","RA_SITFOLH <> '^'")
               Endif

               //- Se for um título de 13o acerta para pegar do RI
               /*If SubStr(cMesFol,5,2) == "13"
                  cQry := StrTran(cQry,"RC_","RI_")
                  cQry := StrTran(cQry,"SRC","SRI")
               Endif
               */


               dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TMPGPE", .T., .F. )

               //- Acumulados da folha
               vFunc := {}
               nTFol := 0
               dbSelectArea("TMPGPE")
               While !Eof()
                  cFunc := TMP_MAT
                  nPgto := 0
                  nRcto := 0
                  While !Eof() .And. cFunc == TMP_MAT
                     nPV := At(TMP_PD,SE2->E2_VERBAS)
                     If nPV > 0 //.and. TMP_DATARQ == SE2->E2_DATARQ
                        // Separa PROVENTOS de DESCONTOS para imprimir separado nos relatorios
                        If SubStr(SE2->E2_VERBAS,nPV+3,1) == "P"
                           nPgto += TMP_VALOR
                        Else
                           nRcto += TMP_VALOR
                        Endif
                     Endif
                     dbSkip()
                  Enddo
                  If nPgto <> 0 .Or. nRcto <> 0
                     If lJunRP  // Caso junte recebimento e pagamento
                        AAdd( vFunc , { cFunc, nPgto-nRcto, 0, 0, 0} )
                     Else
                        AAdd( vFunc , { cFunc, nPgto, nRcto  , 0, 0} )
                     Endif
                     nTFol += (nPgto - nRcto)
                  Endif
               Enddo
               dbCloseArea()
               dbSelectArea("SE2")

               nSom1 := 0
               nPerc := nTotal / nTFol
               nPJ   := If( lJunRP , 2, 3)  // Posicao final caso junte ou nao o recebimento e pagamento

               // Efetua o rateio ainda no array para gravar ja com o acerto de arredondamento. Acerto efetuado para
               // melhorar a performance da rotina uma vez que a mesma demora muito nesse processo quando existem
               // grandes diferenças de centavos.
               For y:=2 To nPJ  // Processa duas vezes o vetor vFunc para ratear os PROVENTOS e DESCONTOS
                  // Calcula o valor do item em relação ao total
                  For x:=1 To Len(vFunc)
                     If vFunc[x,y] <> 0
                        vFunc[x,y+2] := Round(nPerc * vFunc[x,y],2) // Calcula o novo valor do item
                        nSom1        += vFunc[x,y+2] * If( y == 2 , 1, -1)
                     Endif
                  Next
               Next
               // Calcula o rateio da diferença para cada funcionario encontrado
               If (nDif:=(nTotal-nSom1)) <> 0 .And. Len(vFunc) > 0
                  While nDif <> 0  // Caso haja diferenca de arredondamento
                     For y:=2 To nPJ
                        For x:=Len(vFunc) To 1 Step -1
                           If vFunc[x,y+2] <> 0
                              vFunc[x,y+2] += (nPrc * If( nDif > 0 , 1, -1))
                              nDif  += (nPrc * If( nDif > 0 , -1, 1))
                              If nDif == 0
                                 Exit
                              Endif
                           Endif
                        Next
                        If nDif == 0
                           Exit
                        Endif
                     Next
                  Enddo
               ElseIf Len(vFunc) == 0 // Se vazio entao houve erro
                  lErro := .T.
               Endif
               // Efetua gravacao dos valores ja acertados
               For x:=Len(vFunc) To 1 Step -1
                  For y:=2 To nPJ
                     If vFunc[x,y+2] <> 0
                        SE2->(u_RatSIATA(cTab,,vFunc[x,y+2],cConta,vFunc[x,1],E2_CLVL,E2_DATARQ,cPrint,"SE5",If(y==3,"R","P")))
                        lGravou := .T.
                     Endif
                  Next
               Next
            Endif

            If !lGravou .or. lErro // Se nao achou na folha (SRD)
               //-        1        2           3       4       5          6            7      8             9            10   11    12   13   14   15  16   17   18   19
               GrvTmpE5(cTab, (cSE5)->E5_VALOR, E2_CC, cConta, E2_CLVL, E2_ITEMCTA, cPrint, E2_VIAGEM, "** SEM FOLHA !", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
            Endif
         Endif

         dbSelectArea("SE2")
      Next

      dbSelectArea("TBS")
      dbSkip()
   Enddo
   dbSelectArea("TBS")
   dbCloseArea()
   dbSelectArea(cTab)
Return(cArq)

//          Parametros->   1     2      3      4       5         6        7       8       9      10      11      12       13     14     15    16    17      18      19
Static function GrvTmpE5(cTab, nValor, cCC, cConta, cClasVal, cItemCta, cPrint, cViagem, cObs, cTreina, cHora, cPrComp, nQuant, cNoDI, cHist, cRP, cItem, cBaseAtf, lComp)
   Local cAlias := Alias()

   // Ignora lançamentos onde o usuário não tem acesso liberado
   If !u_UserCCusto(cCC)
      Return(Round(nValor,2))
   Endif

   dbSelectArea(cSE5)
   If !Empty(cFiltroU)
      // Atribui valores para variaveis de memoria
      M->E5_CONTAB  := cConta
      M->E5_CLVL    := cClasVal
      M->E5_CC      := cCC
      M->E5_ITEMCTA := cItemCta

      If !&(cFiltroU)   // Verifica novamente filtro do usuario
         dbSelectArea(cAlias)
         Return(Round(nValor,2))
      Endif
   EndIf

   dbSelectArea(cTab)
   If nValor != 0
      RecLock(cTab,.T.)
      (cTab)->E5_FILIAL  := (cSE5)->E5_FILIAL
      (cTab)->E5_DTDISPO := (cSE5)->E5_DTDISPO
      (cTab)->E5_NUMERO  := If(Empty((cSE5)->E5_NUMERO), (cSE5)->E5_DOCUMEN, (cSE5)->E5_NUMERO )
      (cTab)->E5_PREFIXO := (cSE5)->E5_PREFIXO
      (cTab)->E5_TIPO    := (cSE5)->E5_TIPO
      (cTab)->E5_PARCELA := (cSE5)->E5_PARCELA
      (cTab)->E5_RECPAG  := If( cRP == Nil , (cSE5)->E5_RECPAG, cRP)
      (cTab)->E5_VALOR   := Round(nValor,2)
      (cTab)->E5_CONTAB  := cConta
      (cTab)->E5_DESCT1  := Posicione("CT1",1,xFilial("CT1")+cConta  ,"CT1_DESC01")
      (cTab)->E5_CLVL    := cClasVal
      (cTab)->E5_DESCTH  := Posicione("CTH",1,XFILIAL("CTH")+cClasVal,"CTH_DESC01")
      (cTab)->E5_CC      := cCC
      (cTab)->E5_DESCCC  := Posicione("CTT",1,XFILIAL("CTT")+cCC     ,"CTT_DESC01")
      (cTab)->E5_ITEMCTA := cItemCta
      (cTab)->E5_BANCO   := (cSE5)->E5_BANCO
      (cTab)->E5_AGENCIA := (cSE5)->E5_AGENCIA
      (cTab)->E5_CONTA   := (cSE5)->E5_CONTA
      (cTab)->E5_BENEF   := If(cHist == nil, AllTrim((cSE5)->E5_BENEF)+If(cObs==Nil,""," "+cObs),cHist) 
      (cTab)->E5_CLIFOR  := (cSE5)->E5_CLIFOR
      (cTab)->E5_LOJA    := (cSE5)->E5_LOJA
      (cTab)->E5_STATUS  := cPrint
      (cTab)->E5_VIAGEM  := IIf(Empty((cSE5)->E5_VIAGEM),cViagem,(cSE5)->E5_VIAGEM)
      (cTab)->E5_TREINAM := IIf(Empty((cSE5)->E5_TREINAM),IIf( cTreina  == Nil , "", cTreina),(cSE5)->E5_TREINAM)
      (cTab)->E5_HORA    := If( cHora    == Nil , "", cHora)
      (cTab)->E5_PRODUTO := If( cObs     == Nil , "", cObs)
      (cTab)->E5_QUANT   := If( nQuant   == Nil ,  1, nQuant)
      (cTab)->E5_PRCOMP  := If( cPrComp  == Nil , "", cPrComp)
      (cTab)->E5_NODI    := If( cNoDI    == Nil , "", cNoDI)
      (cTab)->E5_ITEM    := If( cItem    == Nil , "", cItem)
      (cTab)->E5_ORIGEM  := If( cOrigFlx == Nil , "", cOrigFlx)
      (cTab)->E5_ROTINA  := If( Empty(TBS->E5_MOTBX) , "FINA100", SE2->E2_ORIGEM)
      (cTab)->E5_BAICOMP := If( lComp == Nil .Or. !lComp , "B", "C")  // B = Caixa, C = Competência
      (cTab)->E5_BASEATF := cBaseAtf
      (cTab)->E5_SEQ     := (cSE5)->E5_SEQ
      (cTab)->E5_TIPODOC := (cSE5)->E5_TIPODOC

      // Define se o registro tem origem no movimento bancario. Onde 1=Sim e 2=Nao.
      // Em qualquer alteracao de alias, favor nao mudar o alias do comando abaixo TBS->E5_MOTBX.
      (cTab)->E5_MOVBCO  := If( Empty(TBS->E5_MOTBX) , "1", "2")

      If (cSE5)->E5_TIPO == "ISS"
         (cTab)->E5_TPIMP := "ISS"
      ElseIf (cSE5)->E5_TIPO == "INS"
         (cTab)->E5_TPIMP := "INSS"
      ElseIf (cSE5)->E5_TIPO == "TX "
         If (SE2->E2_PARCIR  == (cSE5)->E5_PARCELA)
            (cTab)->E5_TPIMP := "IRRF"
         ElseIf (SE2->E2_PARCSLL == (cSE5)->E5_PARCELA)
            (cTab)->E5_TPIMP := "CSLL"
         ElseIf (SE2->E2_PARCCOF == (cSE5)->E5_PARCELA)
            (cTab)->E5_TPIMP := "COFINS"
         ElseIf (SE2->E2_PARCPIS == (cSE5)->E5_PARCELA)
            (cTab)->E5_TPIMP := "PIS"
         Endif
      Endif

      MsUnLock()
   Endif
   dbSelectArea(cAlias)
Return((cTab)->E5_VALOR)

Static function FindSE5(cBusca)
   Local vRet := {}

   //- Buscando titulo gerador do pagamento
   //- cBusca:= E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA 

   If E5_TIPO $ "TX ,INS,ISS" .And. Empty(E5_CLIENTE)
      SE2->(dbSetOrder(1))
      SE2->(dbSeek(cFilSE5+cBusca))

      If !(Trim(SE2->E2_ORIGEM) $ "GPEM670") //- Origem diferente do GPE ou do FIN
         SE2->(dbSetOrder(1))
         SE2->(dbSeek(cFilSE5+TBS->(E5_PREFIXO+E5_NUMERO),.T.))
         While !SE2->(Eof()) .And. cFilSE5+TBS->(E5_PREFIXO+E5_NUMERO) == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM)
            If !(SE2->E2_TIPO $ "TX ,INS,ISS")
               If (TBS->E5_TIPO == "ISS" .And. SE2->E2_PARCISS == TBS->E5_PARCELA) .Or.;
                  (TBS->E5_TIPO == "INS" .And. SE2->E2_PARCINS == TBS->E5_PARCELA) .Or.;
                  (TBS->E5_TIPO == "TX " .And. SE2->E2_PARCIR  == TBS->E5_PARCELA) .Or.;
                  (TBS->E5_TIPO == "TX " .And. SE2->E2_PARCSLL == TBS->E5_PARCELA) .Or.;
                  (TBS->E5_TIPO == "TX " .And. SE2->E2_PARCCOF == TBS->E5_PARCELA) .Or.;
                  (TBS->E5_TIPO == "TX " .And. SE2->E2_PARCPIS == TBS->E5_PARCELA)
                  cBusca := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
                  AAdd( vRet , { TBS->E5_TIPO, TBS->E5_PARCELA, 0, 0, ""} )
                  vRet[1,5] := Posicione("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTAB")
                  Exit
               Endif
            Endif
            SE2->(dbSkip())
         Enddo
      Endif
   Endif

Return(vRet)

/*/
###############################################################################
###############################################################################
###############################################################################
###Programa  ³ INDADSE2 º Autor ³ Ronilton O. Barros º Data ³  28/12/04   #####
###############################################################################
###Descricao ³ Rotina de Busca dos dados referente a rateio por C.C. e    #####
###          ³ Natureza da tabela SE2                                     #####
###############################################################################
###Uso       ³ Especifico INDT                                            #####
###############################################################################
###############################################################################
###############################################################################
/*/
User Function INDADSE2(cTab,cQuery,aStru,cFilUsr,lFin,lMat,lGPE,nTrataPA,cOrig,lNewFile,cMCT,lJunRP,cSalVal,lProc13)
   Local aDbf, cArq, cQuery, ni, cBusca, nPos, nValor, nSom1, nSom2, nRegis, lErro
   Local cConta, cCusto, nValRat, nPerc, vImp, vRat1, vRat2, vNota, nPos, x, y, nTotal, nMoeda, cPrint
   Local cFilDe, cFilAte, cCCDe, cCCAte, cMatDe, cMatAte, cFunc, nPgto, nPV, lGravou, c_Filtro, cQry
   Local c_CCusto, c_Clvl, c_ItemCta, vRegs, nPrc, nDif, cTmp, nValImp, cMesFol, cFilTit, lExcec
   Local cVerbas, c_FilTrv, c_FilTrf, vFunc, nTFol, nRcto, nPJ, cTmpFol, lErro, dBuscai, dBuscaf
   Local vVarFil := {}

   Private cFilSE2, cFiltroU, lMostra := .T.

   If Type("cOrigFlx") == "U"   // Se variavel nao existir declara, senao atribui somente valor
      Private cOrigFlx
   Endif
   If Type("cClsMCT")  == "U"   // Se variavel nao existir declara, senao atribui somente valor
      Private cClsMCT
   Endif

   nPrc     := 0.01                                  // Precisao do arredondamento
   lJunRP   := If( lJunRP   == NIL , .T., lJunRP)    // Define se junta recebimento e pagamento de um mesmo item
   cClsMCT  := If( cMCT     == NIL , " ", cMCT)      // Classe MCT (Valor)
   cSalVal  := If( cSalVal  == NIL , "S", cSalVal)   // Define se considera (S)aldo ou (V)alor do Titulo
   cOrigFlx := If( cOrig    == NIL , " ", cOrig)     // Define origem de busca
   cFilUsr  := If( cFilUsr  == NIL ,  "", cFilUsr)   // Define o filtro do usuario
   cFilUsr  := StrTran(cFilUsr,"E5_","E2_")          // Converte filtro para a tabela SE2
   lFin     := If( lFin     == NIL , .T., lFin   )   // Define se ira processar os titulos do Financeiro
   lMat     := If( lMat     == NIL , .T., lMat   )   // Define se ira processar os titulos do Compras/Estoque
   lGPE     := If( lGPE     == NIL , .T., lGPE   )   // Define se ira processar os titulos da Folha de Pagamento
   lNewFile := If( lNewFile == NIL , .T., lNewFile ) // Define se ira gerar novo arquivo temporario
   lTrataPA := If( nTrataPA == NIL .or. nTrataPA == 1, .T., .F.   ) // Define tratamento de PA's
   cFiltroU := If( cFilUsr  == NIL , " ", cFilUsr)   // Filtro do Usuario
   lProc13  := If( lProc13  == NIL , .T., lProc13)   // Define se processa os títulos de 13o Salário

   // Define as variaveis que serao trocadas no filtro do usuario
   AAdd( vVarFil , { "E2_DEBITO", "E2_CONTAB"  })  //"cConta"
   AAdd( vVarFil , { "E2_CLVLDB", "E2_CLVL"    })  //"cClasVal"
   AAdd( vVarFil , { "E2_CCD"   , "E2_CC"      })  //"cCC"
   AAdd( vVarFil , { "E2_ITEMD" , "E2_ITEMCTA" })  //"cItemCta"
   AAdd( vVarFil , { "E2_BANCO" , "E2_PORTADO" })  //"Banco"
   For ni:=1 To Len(vVarFil)
      If vVarFil[ni,1] $ cFiltroU  // Caso ache a variavel
         cFiltroU := StrTran(cFiltroU,vVarFil[ni,1],vVarFil[ni,2])   // Troca para a outra variavel
         cFilUsr  := AcertaFiltro(cFilUsr,vVarFil[ni,1])             // Acerta filtro do usuario
      Endif
   Next

   aDbf := {}
   AAdd( aDbf , { "E2_FILIAL" , "C",  2, 0})
   AAdd( aDbf , { "E2_VENCREA", "D",  8, 0})
   AAdd( aDbf , { "E2_EMISSAO", "D",  8, 0})
   AAdd( aDbf , { "E2_EMIS1"  , "D",  8, 0})
   AAdd( aDbf , { "E2_NUM"    , "C",  9, 0})
   AAdd( aDbf , { "E2_PREFIXO", "C",  3, 0})
   AAdd( aDbf , { "E2_TIPO"   , "C",  3, 0})
   AAdd( aDbf , { "E2_PARCELA", "C",  2, 0})
   AAdd( aDbf , { "E2_FORNECE", "C",  6, 0})
   AAdd( aDbf , { "E2_LOJA"   , "C",  2, 0})
   AAdd( aDbf , { "E2_SALDO"  , "N", 14, 2})
   AAdd( aDbf , { "E2_CONTAB" , "C", 20, 0})
   AAdd( aDbf , { "E2_DESCT1" , "C", 40, 0})
   AAdd( aDbf , { "E2_CLVL"   , "C",  9, 0})
   AAdd( aDbf , { "E2_DESCTH" , "C", 40, 0})
   AAdd( aDbf , { "E2_CC"     , "C",  9, 0})
   AAdd( aDbf , { "E2_DESCCC" , "C", 40, 0})
   AAdd( aDbf , { "E2_ITEMCTA", "C",  9, 0})
   AAdd( aDbf , { "E2_PORTADO", "C",  3, 0})
   AAdd( aDbf , { "E2_AGENCIA", "C",  5, 0})
   AAdd( aDbf , { "E2_HIST"   , "C", 30, 0})
   AAdd( aDbf , { "E2_STATUS" , "C",  1, 0})
   AAdd( aDbf , { "E2_VIAGEM" , "C",  6, 0})
   AAdd( aDbf , { "E2_TREINAM", "C",  6, 0})
   AAdd( aDbf , { "E2_ORIGEM" , "C",  1, 0})
   AAdd( aDbf , { "E2_ROTINA" , "C",  8, 0})
   AAdd( aDbf , { "E2_TPIMP"  , "C", 06, 0})
   AAdd( aDbf , { "E2_PRCOMP" , "C",  6, 0})
   AAdd( aDbf , { "E2_NODI"   , "C", 12, 0})
   AAdd( aDbf , { "E2_HORA"   , "C",  6, 0})
   AAdd( aDbf , { "E2_ITEM"   , "C",  4, 0})
   AAdd( aDbf , { "E2_BASEATF", "C", 14, 0})
   AAdd( aDbf , { "E2_PRODUTO", "C", 30, 0})

   cArq := CriaTrab(aDbf,.T.)
   Use &cArq Alias &(cTab) New Exclusive

   //- Conta o numero de registros filtrados pela query
   //- cQuery -> SELECT COUNT(*) SOMA ...
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "SOM", .T., .F. )
   nRegis:= SOMA
   dbCloseArea()

   //- Ler todos os registros filtrados pela query
   cQuery := StrTran(cQuery,"COUNT(*) SOMA","*")+" ORDER BY E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO"
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TBS", .T., .F. )

   For ni := 1 to Len(aStru)
      If aStru[ni,2] != "C"
         TCSetField("TBS", aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
      Endif
   Next

   dbSelectArea("TBS")
   dbGoTop()
   ProcRegua(nRegis)

   While !EOF()

      IncProc()

      // Ignora os titulos que o usuario nao deseja processar dependendo da sua origem
      If (!lFin .And. Trim(TBS->E2_ORIGEM) == "FINA050") .Or.;
         (!lMat .And. Trim(TBS->E2_ORIGEM) == "MATA100") .Or.;
         (!lGPE .And. Trim(TBS->E2_ORIGEM) == "GPEM670")
         dbSkip()
         Loop
      Endif

      //###############################################################################
      //³ Avalia filtro do usuario                         ############################
      //###############################################################################
      If !Empty(cFilUsr).and.!(&cFilUsr)
         dbSkip()
         Loop
      EndIf

      //###############################################################################
      //## Se for provisório ou não considerar PA's         ###########################
      //###############################################################################
      If TBS->E2_TIPO $ MVPROVIS .Or. (!lTrataPA .And. TBS->E2_TIPO $ MVPAGANT)
         dbSkip()
         Loop
      Endif

      SM2->(dbSetOrder(1))
      SM2->(dbSeek(TBS->E2_VENCREA))

      nMoeda := If( TBS->E2_MOEDA == 1 , 1, &("SM2->M2_MOEDA"+Str(TBS->E2_MOEDA,1)) )
      nMoeda := If( nMoeda == 0 , TBS->E2_TXMOEDA, nMoeda)
      
      // Calcula o valor do título a ser considerado na rotina
      If cSalVal == "C"      // Se pegar valor Contábil
         // Soma ao valor do título os valores retidos dos impostos
         nTotal := TBS->E2_VALOR + TBS->E2_INSS + TBS->E2_ISS + TBS->E2_IRRF + ;
                   If( TBS->E2_VRETPIS == 0 , TBS->E2_PIS   , TBS->E2_VRETPIS) + ;
                   If( TBS->E2_VRETCOF == 0 , TBS->E2_COFINS, TBS->E2_VRETCOF) + ;
                   If( TBS->E2_VRETCSL == 0 , TBS->E2_CSLL  , TBS->E2_VRETCSL)
      ElseIf cSalVal == "V" .Or. TBS->E2_SALDO == 0   // Se valor do título ou o saldo zerado
         nTotal := TBS->E2_VALOR - TBS->E2_DECRESC + TBS->E2_ACRESC
      Else   // Saldo do título
         nTotal := TBS->E2_SALDO - TBS->E2_DECRESC + TBS->E2_ACRESC
      Endif

      // Se for moeda estrangeira e ainda não taxa de conversão
      If TBS->E2_MOEDA <> 1 .And. nMoeda == 0
         nTotal := E2_VLCRUZ    // Pega valor já convertido
         nMoeda := 1            // Coloca como moeda 1 para não converter novamente
      Endif

      nTotal *= nMoeda // Converte pela moeda usada no título

      If nTotal == 0
         TBS->(dbSkip())
         Loop
      EndIf

      cFilSE2 := TBS->E2_FILIAL
      cTmp    := "TBS"
      cPrint  := "S"
      vImp    := FindSE2(@cTmp,@nMoeda,@nTotal)

      cBusca  := (cTmp)->E2_PREFIXO+(cTmp)->E2_NUM+(cTmp)->E2_PARCELA+(cTmp)->E2_TIPO+(cTmp)->E2_FORNECE+(cTmp)->E2_LOJA

      If Trim((cTmp)->E2_ORIGEM) == "MATA100"  // Caso a origem seja por n.f. de entrada
         nSom1  := 0
         vRat1  := {}
         cBusca := (cTmp)->E2_NUM+(cTmp)->E2_PREFIXO+(cTmp)->E2_FORNECE+(cTmp)->E2_LOJA
         vNota  := {}
         cConta := Posicione("SED",1,XFILIAL("SED")+(cTmp)->E2_NATUREZ,"ED_CONTAB") // Pega conta do titulo principal

         SF1->(dbSetOrder(1))
         SF1->(dbSeek(cFilSE2+cBusca))
         SD1->(dbSetOrder(1))
         SD1->(dbSeek(cFilSE2+cBusca,.T.))

         If cSalVal == "C"      // Se pegar valor Contábil
            nTotal := SF1->F1_VALBRUT + SF1->F1_DESCONT  // Acerta para o valor bruto da nota + descontos
         Endif

         //- Totalizar o valor dos impostos
         nValImp:= 0.00

         While !SD1->(Eof()) .And. cFilSE2+cBusca == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

            If SD1->(D1_TOTAL) = 0
               SD1->(dbSkip())
               Loop
            EndIf

            nValor  := SD1->D1_TOTAL - (SD1->D1_VALIMP1 + SD1->D1_VALIMP2 + SD1->D1_VALIMP3)
            nValImp += SD1->D1_VALIMP1 + SD1->D1_VALIMP2 + SD1->D1_VALIMP3

            If !((cTmp)->E2_TIPO $ "TX ,INS,ISS")  // Se nao for titulo de imposto, pega conta do item
               cConta := SD1->D1_CONTA
            Endif

            vRat2 := {{ nValor, SD1->D1_CC}}

            // Caso haja rateio para o item, busca os centros de custos que entraram no rateio e já calcula o valor rateado
            If SD1->D1_RATEIO == "1"
               SDE->(dbSetOrder(1))
               If SDE->(dbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM),.T.))
                  vRat2 := {}
                  While !SDE->(Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM) == SDE->(DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF)
                     AAdd( vRat2 , { Round(nValor * SDE->DE_PERC / 100,2), SDE->DE_CC})
                     SDE->(dbSkip())
                  Enddo

                  nSom2 := 0
                  AEval( vRat2 , {|x| nSom2 += x[1] })   // Soma os valores rateados

                  AcertaDif(nValor-nSom2,@vRat2,@nSom2,nPrc)
               Endif
            Endif

            //- Acumula por D1_CC + D1_CONTA + D1_CLVL + D1_ITEMCTA + D1_PRCOMP */
            For y:=1 To Len(vRat2)
               nPos:= AScan( vNota , {|x| x[1]+x[2]+x[3]+x[4]+x[6] == vRat2[y,2]+cConta+SD1->(D1_CLVL+D1_ITEMCTA+D1_PRCOMP) } )
               If nPos == 0
                  //                           1       2         3         4     5     6         7         8             9       10      11       12          13
                  AAdd( vNota , SD1->({ vRat2[y,2], cConta, D1_CLVL, D1_ITEMCTA, 0, D1_PRCOMP, D1_NODI, D1_VIAGEM, D1_TREINAM, D1_HORA, D1_ITEM, D1_CBASEAF, D1_DESCRI}) )
                  nPos:= Len(vNota)
               Endif
               vNota[nPos,5] += vRat2[y,1]
            Next

            SD1->(dbSkip())
         Enddo

         /* Grava os valores acumulados da nota fiscal */
         For x:=1 To Len(vNota)
            nPerc := vNota[x,5] / (SF1->F1_VALMERC - nValImp )
            AAdd( vRat1 , { Round(nTotal*nPerc,2),vNota[x,1],vNota[x,2],vNota[x,3],vNota[x,4],vNota[x,6],vNota[x,7],vNota[x,8],vNota[x,9],vNota[x,10],vNota[x,11],vNota[x,12],vNota[x,13]} )
            nSom1 += Round(nTotal * nPerc,2)
         Next

         //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
         AcertaDif(nTotal-nSom1,@vRat1,@nSom1,nPrc)
         For x:=1 To Len(vRat1)
            //-       1      2       3           4           5           6         7         8     9    10          11          12          13          14           15           16           17
            GrvTmpE2(cTab,cTmp,vRat1[x,1], vRat1[x,2], vRat1[x,3], vRat1[x,4], vRat1[x,5], cPrint,nil, vRat1[x,6], vRat1[x,7], vRat1[x,8], vRat1[x,9], vRat1[x,10], vRat1[x,11], vRat1[x,12], vRat1[x,13])
         Next
      ElseIf Trim((cTmp)->E2_ORIGEM) == "FINA050"  // Caso a origem seja do financeiro (contas a pagar)
         cConta := Posicione("SED",1,XFILIAL("SED")+(cTmp)->E2_NATUREZ,"ED_CONTAB") // Pega conta do titulo principal
         If (cTmp)->E2_MULTNAT == "1"   // Caso seja multi-natureza
            nSom1 := 0
            vRat1 := {}
            SEV->(dbSetOrder(1))
            SEV->(dbSeek(cFilSE2+SubStr(cBusca,1,21),.T.))
            While !SEV->(Eof()) .And. cFilSE2+SubStr(cBusca,1,21) == SEV->EV_FILIAL+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA

               If SEV->EV_RECPAG <> "P"   // Somente titulos a pagar
                  SEV->(dbSkip())
                  Loop
               Endif

               nValor := Round(If( (cTmp)->E2_VLCRUZ == nTotal , SEV->EV_VALOR * nMoeda, nTotal * SEV->EV_PERC),2)

               If SEV->EV_RATEICC == "1"  // Caso seja multi-centro de custo
                  nSom2  := 0
                  vRat2  := {}
                  cBusca := SubStr(cBusca,1,21)+SEV->EV_NATUREZ

                  SEZ->(dbSetOrder(1))
                  SEZ->(dbSeek(cFilSE2+cBusca,.T.))
                  While !SEZ->(Eof()) .And. cFilSE2+cBusca == SEZ->EZ_FILIAL+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA+SEZ->EZ_NATUREZ

                     If SEZ->EZ_RECPAG <> "P"
                        SEZ->(dbSkip())
                        Loop
                     Endif

                     c_CCusto  := If(Empty(SEZ->EZ_CCUSTO) , (cTmp)->E2_CC     , SEZ->EZ_CCUSTO)
                     c_Clvl    := If(Empty(SEZ->EZ_CLVL)   , (cTmp)->E2_CLVL   , SEZ->EZ_CLVL)
                     c_ItemCta := If(Empty(SEZ->EZ_ITEMCTA), (cTmp)->E2_ITEMCTA, SEZ->EZ_ITEMCTA)

                     If !((cTmp)->E2_TIPO $ "TX ,INS,ISS")  // Se nao for titulo de imposto, pega conta do rateio
                        cConta := Posicione("SED",1,XFILIAL("SED")+SEZ->EZ_NATUREZ,"ED_CONTAB")
                     Endif
                     nValRat := Round(nValor * SEZ->EZ_PERC,2)
                     nSom2   += nValRat

                     AAdd( vRat2 , { nValRat, c_CCusto, cConta, c_Clvl, c_ItemCta} )

                     SEZ->(dbSkip())
                  Enddo
                  //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
                  AcertaDif(nValor-nSom2,@vRat2,@nSom2,nPrc)
                  For x:=1 To Len(vRat2)
                     AAdd( vRat1 , { vRat2[x,1], vRat2[x,2], vRat2[x,3], vRat2[x,4], vRat2[x,5]} )
                  Next
                  nSom1 += nSom2
               Else
                  cConta := Posicione("SED",1,XFILIAL("SED")+SEV->EV_NATUREZ,"ED_CONTAB")
                  AAdd( vRat1 , { nValor, (cTmp)->E2_CC, cConta, (cTmp)->E2_CLVL, (cTmp)->E2_ITEMCTA} )
                  nSom1 += nValor
               Endif

               SEV->(dbSkip())
            Enddo
            //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
            AcertaDif(nTotal-nSom1,@vRat1,@nSom1,nPrc)
            For x:=1 To Len(vRat1)
               //-       1      2       3           4           5           6         7          8     9     10                11      12                 13             14  15  16  17
               GrvTmpE2(cTab,cTmp,vRat1[x,1], vRat1[x,2], vRat1[x,3], vRat1[x,4], vRat1[x,5], cPrint, nil, (cTmp)->E2_PEDIDO, nil, (cTmp)->E2_VIAGEM, (cTmp)->E2_TREINAM,nil,nil,nil,(cTmp)->E2_HIST)
            Next
         ElseIf Empty(cClsMCT) .Or. cClsMCT == (cTmp)->E2_CLVL
            //         1    2     3         4          5         6                  7            8      9        10            11       12                 13             14  15  16  17
            GrvTmpE2(cTab,cTmp,nTotal,(cTmp)->E2_CC,cConta,(cTmp)->E2_CLVL,(cTmp)->E2_ITEMCTA, cPrint, nil ,(cTmp)->E2_PEDIDO, nil, (cTmp)->E2_VIAGEM, (cTmp)->E2_TREINAM,nil,nil,nil,(cTmp)->E2_HIST)
         Endif
      ElseIf Trim(E2_ORIGEM) == "GPEM670"  // Caso a origem seja da folha de pagamento

         If !lProc13  // Se não processa o 13o
            // Caso o codigo do título não se refira a 13o (pelo alias), então analisa a verba
            If !(lErro := (Posicione("RC0",1,XFILIAL("RC0")+E2_CODTIT,"RC0_ALIAS") == "SRI"))
               cVerbas := SubStr(AllTrim(E2_VERBAS),1,3)
               lErro   := (!Empty(cVerbas) .And. Posicione("SRV",1,XFILIAL("SRV")+cVerbas,"RV_REF13") == "S")
            Endif
            If lErro
               // Caso o parâmetro de datas seja menor que Novembro/2006, então desconsidera somente os títulos com competência de
               // Dezembro em diante. Caso contrário, ignora qualquer título de 13o Salário
               If Dtos(mv_par02) > "20061101" .Or. SubStr(E2_DATARQ,5,2) $ "12,13,14"
                  dbSelectArea("TBS")
                  dbSkip()
                  Loop
               Endif
            Endif
         Endif

         cFilDe  := SubStr(E2_PARFOL, 1,2)
         cFilAte := SubStr(E2_PARFOL, 3,2)
         cCCDe   := SubStr(E2_PARFOL, 5,9)
         cCCAte  := SubStr(E2_PARFOL,14,9)
         cMatDe  := SubStr(E2_PARFOL,23,6)
         cMatAte := SubStr(E2_PARFOL,29,6)
         dBuscai := E2_BUSCAI
         dBuscaf := E2_BUSCAF
         cMesFol := E2_DATARQ //- Adelson Considerar somente movimentações do mês
         cFilTit := (cTmp)->(If( Empty(E2_FILORIG) , E2_FILIAL, E2_FILORIG))
         lGravou := .F.
         lErro   := .f.
         cConta  := Posicione("SED",1,XFILIAL("SED")+(cTmp)->E2_NATUREZ,"ED_CONTAB")
         lExcec  := !Empty(E2_INDICE)   // Campo para títulos exceção

         If Empty(dBuscai) .or. Empty(dBuscaf)
            RC1->(dbSetOrder(2))
            If RC1->(dbSeek((cTmp)->(E2_FILIAL+E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO)))
               dBuscai := RC1->RC1_DTBUSI
               dBuscaf := RC1->RC1_DTBUSF
            Else
               lErro:= .t.
            Endif
         Endif

         If !lErro

            // Armazena as verbas utilizadas para auxiliar no filtro da query
            cVerbas := StrTran(StrTran(AllTrim(E2_VERBAS),"D","','"),"P","','")

            If !Empty(cVerbas)
               cVerbas := "('"+SubStr(cVerbas,1,Len(cVerbas)-2)+") "
               If at("')",cVerbas) = 0
                 cVerbas := SubStr(cVerbas,1,Len(cVerbas)-2)+"') "
               EndIf
            Else
               cVerbas := "('XXX') "
            Endif

            // Verifica se o titulo se refere ao periodo atual
            If cMesFol >= Trim(GetMV("MV_FOLMES"))
               cTmpFol := RetSQLName("SRC")
            Else
               If SubStr(cMesFol,5,2) == "13"  // Se for um titulo de 13o
                  cTmpFol := "RI"+SM0->M0_CODIGO+SubStr(cMesFol,3,4)
               Else
                  cTmpFol := "RC"+SM0->M0_CODIGO+SubStr(cMesFol,3,4)
               Endif
            Endif

            // Inicializa variavel de filtro
            c_FilTrv := StrTran(AllTrim(E2_FILTRV),".T.","")

            // Caso exista filtro pela tabela SRR, limpa pois essa tabela nao eh usada no filtro
            If "RR_" $ c_FilTrv
               c_FilTrv := ""
            Endif

            //- Acerta o filtro do campo E2_FILFOL para pegar do SRD
            c_FilTrf := StrTran(AllTrim(E2_FILFOL),".T.","")

            //- Modificado em 09/09/05 para pegar o filtro pelo financeiro
            c_Filtro := c_FilTrv
            If !Empty(c_FilTrf)
               If Empty(c_Filtro)
                  c_Filtro := c_FilTrf
               ElseIf !(c_Filtro $ c_FilTrf)
                  c_Filtro += ".AND." + c_FilTrf
               Endif
            Endif

            // Agrupamento por 1-Filial, 2-Centro Custo, 3-Nivel Centro Custo ou 4-Funcionario
            /*
            cQry := "SELECT RC_MAT TMP_MAT, RC_PD TMP_PD, RC_VALOR TMP_VALOR "
            cQry += "FROM "+cTmpFol+" A, "+RetSQLName("SRA")+" B "
            cQry += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND RC_FILIAL = '"+cFilTit+"' AND "
            cQry += "RC_MAT = RA_MAT AND "+If( Empty(c_Filtro) , "", u_ConvFilUsu(c_Filtro)+" AND ")
            cQry += "RC_DATA >= '"+Dtos(dBuscai)+"' AND "
            cQry += "RC_FILIAL >= '"+cFilDe+"' AND RC_FILIAL <= '"+cFilAte+"' AND "
            cQry += "RC_MAT >= '"+cMatDe+"' AND RC_MAT <= '"+cMatAte+"' AND "
            cQry += "RC_CC >= '"+cCCDe+"' AND RC_CC <= '"+cCCAte+"' AND RA_FILIAL = RC_FILIAL AND "
            cQry += "RC_PD IN "+cVerbas

            If E2_AGRUPA == "4"   // Se agrupamento for por funcionario, filtra tambem pela matricula
               cQry += "AND RA_MAT = '"+SubStr(E2_ITEMCTA,1,6)+"' "
            ElseIf E2_AGRUPA == "2"
               cQry += "AND RA_CC = '"+E2_CC+"' "
            Endif
            cQry += "ORDER BY RA_MAT"
            */


            // Agrupamento por 1-Filial, 2-Centro Custo, 3-Nivel Centro Custo ou 4-Funcionario
               cQry := "SELECT RC_MAT TMP_MAT, RC_PD TMP_PD, RC_VALOR TMP_VALOR "
               cQry += "FROM "+RetSQLName("SRC")+" A, "+RetSQLName("SRA")+" B "
               cQry += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND RC_FILIAL = '"+cFilTit+"' AND "
               cQry += "RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND "
               cQry += If( Empty(c_Filtro) , "", u_ConvFilUsu(c_Filtro)+" AND ")
               cQry += "RC_FILIAL >= '"+cFilDe+"' AND RC_FILIAL <= '"+cFilAte+"' AND "
               cQry += "RC_MAT >= '"+cMatDe+"' AND RC_MAT <= '"+cMatAte+"' AND "
               cQry += "RC_CC >= '"+cCCDe+"' AND RC_CC <= '"+cCCAte+"' AND RA_FILIAL = RC_FILIAL AND "
               cQry += "RC_PD IN "+cVerbas

               If E2_AGRUPA == "4"   // Se agrupamento for por funcionario, filtra tambem pela matricula
                  cQry += "AND RC_MAT = '"+SubStr(E2_ITEMCTA,1,6)+"' "
               ElseIf E2_AGRUPA == "2"
                  cQry += "AND RC_CC = '"+E2_CC+"' "
               Endif
               
               cQry += " UNION ALL "

               cQry += "SELECT RD_MAT TMP_MAT, RD_PD TMP_PD, RD_VALOR TMP_VALOR "
               cQry += "FROM "+RetSQLName("SRD")+" A, "+RetSQLName("SRA")+" B "
               cQry += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND RD_FILIAL = '"+cFilTit+"' AND "
               cQry += "RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND "
               cQry += If( Empty(c_Filtro) , "", u_ConvFilUsu(c_Filtro)+" AND ")
               cQry += "RD_DATA >= '"+LEFT(Dtos(dBuscai),6)+"' AND "
               cQry += "RC_FILIAL >= '"+cFilDe+"' AND RC_FILIAL <= '"+cFilAte+"' AND "
               cQry += "RC_MAT >= '"+cMatDe+"' AND RC_MAT <= '"+cMatAte+"' AND "
               cQry += "RC_CC >= '"+cCCDe+"' AND RC_CC <= '"+cCCAte+"' AND RA_FILIAL = RC_FILIAL AND "
               cQry += "RC_PD IN "+cVerbas

               If E2_AGRUPA == "4"   // Se agrupamento for por funcionario, filtra tambem pela matricula
                  cQry += "AND RD_MAT = '"+SubStr(E2_ITEMCTA,1,6)+"' "
               ElseIf E2_AGRUPA == "2"
                  cQry += "AND RD_CC = '"+E2_CC+"' "
               Endif
               
               cQry += "ORDER BY TMP_MAT"


               
            // Acerto para o filtro de funcinarios demitidos. Esse filtro deve ser ignorado
            If "RA_SITFOLH <> 'D'" $ cQry
               cQry := StrTran(cQry,"RA_SITFOLH <> 'D'","RA_SITFOLH <> '^'")
            Endif

            //- Se for um título de 13o acerta para pegar do RI
           // If SubStr(cMesFol,5,2) == "13"
           //    cQry := StrTran(cQry,"RC_","RI_")
           // Endif

            dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TMPGPE", .T., .F. )

            //- Acumulados da folha
            vFunc := {}
            nTFol := 0
            dbSelectArea("TMPGPE")
            While !Eof()
               cFunc := TMP_MAT
               nPgto := 0
               nRcto := 0
               nExce := 0
               While !Eof() .And. cFunc == TMP_MAT
                  nPV := At(TMP_PD,(cTmp)->E2_VERBAS)
                  If nPV > 0 //.and. TMP_DATARQ == (cTmp)->E2_DATARQ
                     // Separa PROVENTOS de DESCONTOS para imprimir separado nos relatorios
                     If SubStr((cTmp)->E2_VERBAS,nPV+3,1) == "P"
                        If lExcec .And. TMP_PD == "022"
                           nExce += (TMP_VALOR*(1/Val((cTmp)->E2_INDICE)))
                        Else
                           nPgto += TMP_VALOR
                        Endif
                     Else
                        nRcto += TMP_VALOR
                     Endif
                  Endif
                  dbSkip()
               Enddo
               If nPgto <> 0 .Or. nRcto <> 0
                  If lJunRP  // Caso junte recebimento e pagamento
                     AAdd( vFunc , { cFunc, nPgto-nRcto, 0, 0, 0, nExce} )
                  Else
                     AAdd( vFunc , { cFunc, nPgto, nRcto  , 0, 0, nExce} )
                  Endif
                  nTFol += (nPgto - nRcto)
               Endif
            Enddo
            dbCloseArea()
            dbSelectArea("SE2")

            nSom1 := 0
            nPerc := nTotal / nTFol
            nPJ   := If( lJunRP , 2, 3)  // Posicao final caso junte ou nao o recebimento e pagamento

            // Efetua o rateio ainda no array para gravar ja com o acerto de arredondamento. Acerto efetuado para
            // melhorar a performance da rotina uma vez que a mesma demora muito nesse processo quando existem
            // grandes diferenças de centavos.
            For y:=2 To nPJ  // Processa duas vezes o vetor vFunc para ratear os PROVENTOS e DESCONTOS
               // Calcula o valor do item em relação ao total
               For x:=1 To Len(vFunc)
                  If vFunc[x,y] <> 0
                     vFunc[x,y+2] := Round(nPerc * vFunc[x,y],2) // Calcula o novo valor do item
                     nSom1        += vFunc[x,y+2] * If( y == 2 , 1, -1)
                  Endif
               Next
            Next
            // Calcula o rateio da diferença para cada funcionario encontrado
            If (nDif:=(nTotal-nSom1)) <> 0 .And. Len(vFunc) > 0
               While nDif <> 0  // Caso haja diferenca de arredondamento
                  For y:=2 To nPJ
                     For x:=Len(vFunc) To 1 Step -1
                        If vFunc[x,y+2] <> 0
                           vFunc[x,y+2] += (nPrc * If( nDif > 0 , 1, -1))
                           nDif  += (nPrc * If( nDif > 0 , -1, 1))
                           If nDif == 0
                              Exit
                           Endif
                        Endif
                     Next
                     If nDif == 0
                        Exit
                     Endif
                  Next
               Enddo
            ElseIf Len(vFunc) == 0 // Se vazio entao houve erro
               lErro := .T.
            Endif
            AEval( vFunc , {|x| x[4] -= x[6] })
            // Efetua gravacao dos valores ja acertados
            For x:=Len(vFunc) To 1 Step -1
               For y:=2 To nPJ
                  If vFunc[x,y+2] <> 0
                     (cTmp)->(U_RatSIATA(cTab,cTmp,vFunc[x,y+2],cConta,vFunc[x,1],E2_CLVL,E2_DATARQ,cPrint,"SE2"))
                     lGravou := .T.
                  Endif
               Next
            Next
         Endif

         If !lGravou .or. lErro // Se nao achou na folha (SRD)
            //         1    2             3             4          5         6         7   8           9              10            11       12                 13             14  15  16  17
            GrvTmpE2(cTab,cTmp,(cTmp)->E2_VLCRUZ,(cTmp)->E2_CC,cConta,(cTmp)->E2_CLVL,"",cPrint,"** SEM FOLHA !", (cTmp)->E2_PEDIDO,nil, (cTmp)->E2_VIAGEM, (cTmp)->E2_TREINAM,nil,nil,nil,nil)
         Endif
      Endif
      dbSelectArea("TBS")

      dbSkip()
   Enddo
   dbCloseArea()
   dbSelectArea(cTab)
Return(cArq)

//          Parametros->  1    2    3      4    5       6        7        8     9    10     11     12     13      14    15    16      17
Static Function GrvTmpE2(cTab,cTmp,nValor,cCC,cConta,cClasVal,cItemCta,cPrint,cObs,cPrComp,cNoDI,cViagem,cTreina,cHora,cItem,cBaseAtf,cProd)
   Local cSE2   := "TBS"
   Local cAlias := Alias()

   // Ignora lançamentos onde o usuário não tem acesso liberado
   If !u_UserCCusto(cCC)
      Return(Round(nValor,2))
   Endif

   cPrint := If( cPrint == Nil , "S", cPrint)

   dbSelectArea(cSE2)
   If !Empty(cFiltroU)
      // Atribui valores para variaveis de memoria
      M->E2_CONTAB  := cConta
      M->E2_CLVL    := cClasVal
      M->E2_CC      := cCC
      M->E2_ITEMCTA := cItemCta
      M->E2_PORTADO := If( cPrint == "N" , SE2->E2_PORTADO, (cTmp)->E2_PORTADO)

      If !&(cFiltroU)   // Verifica novamente filtro do usuario
         dbSelectArea(cAlias)
         Return(Round(nValor,2))
      Endif
   EndIf

   RecLock(cTab,.T.)
   (cTab)->E2_FILIAL  := If( cPrint == "N" , SE2->E2_FILIAL, (cTmp)->E2_FILIAL)
   (cTab)->E2_EMISSAO := If( cPrint == "N" , SE2->E2_EMISSAO, TBS->E2_EMISSAO)
   (cTab)->E2_EMIS1   := If( cPrint == "N" , SE2->E2_EMIS1  , TBS->E2_EMIS1  )
   (cTab)->E2_VENCREA := If( cPrint == "N" , SE2->E2_VENCREA, TBS->E2_VENCREA)
   (cTab)->E2_NUM     := If( cPrint == "N" , SE2->E2_NUM    , TBS->E2_NUM    )
   (cTab)->E2_PREFIXO := If( cPrint == "N" , SE2->E2_PREFIXO, TBS->E2_PREFIXO)
   (cTab)->E2_TIPO    := If( cPrint == "N" , SE2->E2_TIPO   , TBS->E2_TIPO   )
   (cTab)->E2_PARCELA := If( cPrint == "N" , SE2->E2_PARCELA, TBS->E2_PARCELA)
   (cTab)->E2_FORNECE := If( cPrint == "N" , SE2->E2_FORNECE, TBS->E2_FORNECE)
   (cTab)->E2_LOJA    := If( cPrint == "N" , SE2->E2_LOJA   , TBS->E2_LOJA   )
   (cTab)->E2_SALDO   := Round(nValor,2)
   (cTab)->E2_CONTAB  := cConta
   (cTab)->E2_DESCT1  := Posicione("CT1",1,XFILIAL("CT1")+cConta  ,"CT1_DESC01")
   (cTab)->E2_CLVL    := cClasVal
   (cTab)->E2_ITEMCTA := cItemCta
   (cTab)->E2_DESCTH  := Posicione("CTH",1,XFILIAL("CTH")+cClasVal,"CTH_DESC01")
   (cTab)->E2_CC      := cCC
   (cTab)->E2_DESCCC  := Posicione("CTT",1,XFILIAL("CTT")+cCC,"CTT_DESC01")
   (cTab)->E2_PORTADO := If( cPrint == "N" , SE2->E2_BCOPAG , (cTmp)->E2_BCOPAG )
   (cTab)->E2_AGENCIA := If( cPrint == "N" , SE2->E2_AGENCIA, (cTmp)->E2_AGENCIA)
   (cTab)->E2_HIST    := AllTrim(Posicione("SA2",1,XFILIAL("SA2")+(cTmp)->(E2_FORNECE+E2_LOJA),"A2_NOME"))+;
                         If( cObs==Nil , "", " "+cObs)
   (cTab)->E2_STATUS  := cPrint
   (cTab)->E2_VIAGEM  := If( cViagem  == Nil , "", cViagem)
   (cTab)->E2_TREINAM := If( cTreina  == Nil , "", cTreina)
   (cTab)->E2_ORIGEM  := cOrigFlx
   (cTab)->E2_ROTINA  := If( cPrint == "N" , SE2->E2_ORIGEM, TBS->E2_ORIGEM)
   (cTab)->E2_TPIMP   := cOrigFlx
   (cTab)->E2_PRCOMP  := If( cPrComp  == Nil , "", cPrComp)
   (cTab)->E2_NODI    := If( cNoDI    == Nil , "", cNoDI)
   (cTab)->E2_HORA    := If( cHora    == Nil , "", cHora)
   (cTab)->E2_ITEM    := If( cItem    == Nil , "", cItem)
   (cTab)->E2_BASEATF := If( cBaseAtf == Nil , "", cBaseAtf)
   (cTab)->E2_PRODUTO := If( cProd    == Nil , "", cProd)

   If (cTab)->E2_TIPO == "ISS"
      (cTab)->E2_TPIMP := "ISS"
   ElseIf (cTab)->E2_TIPO == "INS"
      (cTab)->E2_TPIMP := "INSS"
   ElseIf (cTab)->E2_TIPO == "TX "
      If (SE2->E2_PARCIR  == (cTmp)->E2_PARCELA)
         (cTab)->E2_TPIMP := "IRRF"
      ElseIf (SE2->E2_PARCSLL == (cTmp)->E2_PARCELA)
         (cTab)->E2_TPIMP := "CSLL"
      ElseIf (SE2->E2_PARCCOF == (cTmp)->E2_PARCELA)
         (cTab)->E2_TPIMP := "COFINS"
      ElseIf (SE2->E2_PARCPIS == (cTmp)->E2_PARCELA)
         (cTab)->E2_TPIMP := "PIS"
      Endif
   Endif

   MsUnLock()
   dbSelectArea(cAlias)
Return((cTab)->E2_SALDO)

Static Function FindSE2(cTmp,nMoeda,nTotal)
   Local vRet := {}
   If !(Trim(E2_ORIGEM) $ "GPEM670") .And. E2_TIPO $ "TX ,INS,ISS"
      SE2->(dbSetOrder(1))
      SE2->(dbSeek(cFilSE2+TBS->(E2_PREFIXO+E2_NUM),.T.))
      While !SE2->(Eof()) .And. cFilSE2+TBS->(E2_PREFIXO+E2_NUM) == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM)
         If !SE2->(E2_TIPO $ "TX ,INS,ISS")
            If (TBS->E2_TIPO == "ISS" .And. SE2->E2_PARCISS == TBS->E2_PARCELA) .Or.;
               (TBS->E2_TIPO == "INS" .And. SE2->E2_PARCINS == TBS->E2_PARCELA) .Or.;
               (TBS->E2_TIPO == "TX " .And. SE2->E2_PARCIR  == TBS->E2_PARCELA) .Or.;
               (TBS->E2_TIPO == "TX " .And. SE2->E2_PARCSLL == TBS->E2_PARCELA) .Or.;
               (TBS->E2_TIPO == "TX " .And. SE2->E2_PARCCOF == TBS->E2_PARCELA) .Or.;
               (TBS->E2_TIPO == "TX " .And. SE2->E2_PARCPIS == TBS->E2_PARCELA)

               AAdd( vRet , { TBS->E2_TIPO, TBS->E2_PARCELA, 0, 0, 0, "", Ctod("")} )

               SM2->(dbSetOrder(1))
               SM2->(dbSeek(TBS->E2_VENCREA))
               nMoeda    := SE2->(If( E2_MOEDA == 1 , 1, &("SM2->M2_MOEDA"+Str(E2_MOEDA,1)) ))
               nMoeda    := SE2->(If( nMoeda == 0 , E2_TXMOEDA, nMoeda))
               nTotal    := TBS->E2_VALOR * nMoeda

               // Se for moeda estrangeira e ainda não taxa de conversão
               If SE2->E2_MOEDA <> 1 .And. nMoeda == 0
                  nTotal := SE2->E2_VLCRUZ    // Pega valor já convertido
                  nMoeda := 1                 // Coloca como moeda 1 para não converter novamente
               Endif

               vRet[1,3] := TBS->E2_SALDO - TBS->E2_DECRESC + TBS->E2_ACRESC
               vRet[1,6] := Posicione("SED",1,XFILIAL("SED")+TBS->E2_NATUREZ,"ED_CONTAB")
               Exit
            Endif
         Endif
         SE2->(dbSkip())
      Enddo
   Else
      SE2->(dbSetOrder(1))
      SE2->(dbSeek(cFilSE2+(cTmp)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
   Endif
Return(vRet)

/*/______________________________________________________________________________
#################################################################################
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ BuscaCtaRec¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 22/04/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca dados do contas a receber                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
#################################################################################
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function BuscaCtaRec(cTab,cSE5,cBusca,lFin,lMat)
   Local nTotal, nValor

   cBusca := PADR(cBusca,Len(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))

   SD2->(dbSetOrder(3))
   SE1->(dbSetOrder(1))
   SF2->(dbSetOrder(1))
   SF2->(dbSeek(SE1->(E1_FILIAL+E1_NUM+E1_PREFIXO)))

   SE1->(dbSeek(cFilSE5+cBusca,.T.))
   While !SE1->(Eof()) .And. cFilSE5+cBusca == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
      nTotal := 0
      SD2->(dbSeek(SE1->(E1_FILIAL+E1_NUM+E1_PREFIXO),.T.))
      While !SD2->(Eof()) .And. SE1->(E1_FILIAL+E1_NUM+E1_PREFIXO) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)

         nValor := Round((cSE5)->E5_VALOR * (SD2->D2_TOTAL / SF2->F2_VALMERC),2)
         nTotal += nValor

         SD2->(dbSkip())     // Avança registro
         // Se for fim da nota e houver diferença de centavos
         If (SD2->(Eof()) .Or. SE1->(E1_FILIAL+E1_NUM+E1_PREFIXO) <> SD2->(D2_FILIAL+D2_DOC+D2_SERIE)) .And.;
            (nDif:=((cSE5)->E5_VALOR - nTotal)) <> 0   // Acerta a diferença no último item
            nValor += nDif
         Endif
         SD2->(dbSkip(-1))   // Volta registro

         If SD2->D2_VERBPED == "2"  // Se reembolso for igual a NÃO
            SD2->(dbSkip())
            Loop
         Endif

         RecLock(cTab,.T.)
         (cTab)->E5_FILIAL  := (cSE5)->E5_FILIAL
         (cTab)->E5_DTDISPO := (cSE5)->E5_DTDISPO
         (cTab)->E5_NUMERO  := If(Empty((cSE5)->E5_NUMERO), (cSE5)->E5_DOCUMEN, (cSE5)->E5_NUMERO )
         (cTab)->E5_PREFIXO := (cSE5)->E5_PREFIXO
         (cTab)->E5_TIPO    := (cSE5)->E5_TIPO
         (cTab)->E5_PARCELA := (cSE5)->E5_PARCELA
         (cTab)->E5_RECPAG  := "R"
         (cTab)->E5_VALOR   := nValor
         (cTab)->E5_CONTAB  := SD2->D2_CONTA
         (cTab)->E5_DESCT1  := Posicione("CT1",1,xFilial("CT1")+SD2->D2_CONTA,"CT1_DESC01")
         (cTab)->E5_CLVL    := SD2->D2_CLVL
         (cTab)->E5_DESCTH  := Posicione("CTH",1,XFILIAL("CTH")+SD2->D2_CLVL ,"CTH_DESC01")
         (cTab)->E5_CC      := SD2->D2_CC
         (cTab)->E5_DESCCC  := Posicione("CTT",1,XFILIAL("CTT")+SD2->D2_CC   ,"CTT_DESC01")
         (cTab)->E5_ITEMCTA := SD2->D2_ITEMCTA
         (cTab)->E5_BANCO   := (cSE5)->E5_BANCO
         (cTab)->E5_AGENCIA := (cSE5)->E5_AGENCIA
         (cTab)->E5_CONTA   := (cSE5)->E5_CONTA
         (cTab)->E5_BENEF   := AllTrim((cSE5)->E5_BENEF)
         (cTab)->E5_CLIFOR  := (cSE5)->E5_CLIFOR
         (cTab)->E5_LOJA    := (cSE5)->E5_LOJA
         (cTab)->E5_STATUS  := "S"
         (cTab)->E5_ROTINA  := SE1->E1_ORIGEM
         (cTab)->E5_BAICOMP := "B"   // Grava como regime de caixa
         (cTab)->E5_SEQ     := (cSE5)->E5_SEQ
         (cTab)->E5_TIPODOC := (cSE5)->E5_TIPODOC
         // Alterado por Marcio Macedo 30/04/08 p/ ajuste do relatorio de Viagem...
         (cTab)->E5_VIAGEM  := IIf(Empty((cSE5)->E5_VIAGEM),SD2->D2_VIAGEM,(cSE5)->E5_VIAGEM)
         (cTab)->E5_TREINAM := IIf(Empty((cSE5)->E5_TREINAM),"",(cSE5)->E5_TREINAM)

         // Define se o registro tem origem no movimento bancario. Onde 1=Sim e 2=Nao.
         // Em qualquer alteracao de alias, favor nao mudar o alias do comando abaixo TBS->E5_MOTBX.
         (cTab)->E5_MOVBCO  := If( Empty((cSE5)->E5_MOTBX) , "1", "2")

         MsUnLock()

         SD2->(dbSkip())
      Enddo
      SE1->(dbSkip())
   Enddo
   dbSelectArea(cSE5)

Return

/*/______________________________________________________________________________
#################################################################################
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TrataPA    ¦ Autor ¦ Reinaldo Magalhaes   ¦ Data ¦ 19/01/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tratamento especifico para PA (INDT)                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ c_Doc -> PREFIXO+NUMERO+PARCELA+TIPO = 3+6+1+3=13             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
#################################################################################
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function TrataPA(c_Doc,c_FornAdt,c_LojaAdt)
  Local n_RegSE2 := SE2->(Recno())
  Local n_IndSE2 := SE2->(IndexOrd())
  Local n_RegSE5 := SE5->(Recno())
  Local n_IndSE5 := SE5->(IndexOrd())
  Local nTam     := Len(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))
  Local vRet     := {}

  //- Verificando a existencia de documentos compensados pelo P.A
  SE5->(DbSetOrder(10)) //- E5_FILIAL+E5_DOCUMEN
  SE5->(dbSeek(cFilSE5+c_Doc,.T.))
  While !SE5->(Eof()) .And. SE5->(E5_FILIAL+Substr(E5_DOCUMEN,1,nTam)) == cFilSE5+c_Doc
     If SE5->E5_RECPAG <> "P" .or. SE5->E5_TIPODOC <> "CP"
        SE5->(DbSkip())
        Loop
     Endif
     // c_FornAdt+c_LojaAdt - Fornecedor e loja do PA   
     If SE5->E5_FORNADT+SE5->E5_LOJAADT == c_FornAdt+c_LojaAdt .And. SE5->E5_DTDISPO <= dDataBase
        //- Verificando contas a pagar
        SE2->(dbSetOrder(1))
        If SE2->(DbSeek(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
           nPos:= AScan( vRet, {|x| x[1] == SE2->(Recno()) } )
           If nPos == 0
              AAdd( vRet, { SE2->(Recno()), SE5->E5_VALOR, "SE5", SE5->(Recno())})
           Else
              vRet[nPos,2]:= SE5->E5_VALOR
           Endif
        Endif
     Endif
     SE5->(dbSkip())
  Enddo
  SE2->(DbSetOrder(n_IndSE2))
  SE2->(Dbgoto(n_RegSE2))
  SE5->(DbSetOrder(n_IndSE5))
  SE5->(Dbgoto(n_RegSE5))

Return(vRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ BscViagem ¦ Autor ¦ Reinaldo Magalhaes     ¦ Data ¦ 04/02/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Retorna o codigo da viagem de um documento                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ cDoc -> PREFIXO+NUMERO+PARCELA+TIPO+CLIFOR+LOJA               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function BscViagem(cDoc)
  Local c_Alias := Alias()
  Local n_RegSE2:= SE2->(Recno())
  Local n_IndSE2:= SE2->(IndexOrd())
  Local cViagem:= ""

  //- Contas a pagar
  dbSelectArea("SE2")
  dbSetOrder(1)
  If dbSeek(cDoc)
     cViagem:= SE2->E2_VIAGEM
  Endif

  SE2->(DbSetOrder(n_IndSE2))
  SE2->(Dbgoto(n_RegSE2))
  
  DbSelectArea(c_Alias)

Return cViagem

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ RatSIATA  ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 07/02/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Rateia os valores provenientes da folha pelo SIATA            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//                        1    2    3      4     5      6      7       8    9  10
User function RatSIATA(cTab,cTmp,nPgto,cConta,cFunc,cClVl,cDatarq,cPrint,cOri,cRP)
   Local nValor := 0
   Local nSoma  := 0
   Local nReg   := 0
   Local cAlias := Alias()

   //- Tratamento criado para a situacao de 13o. Salario (Reinaldo/Adelson) em 18-01-06
   If Substr(cDatarq,5,2) == "13"
      cDatarq:= StrTran(cDatarq,"13","12")
   Endif

   nReg  := 0
   cFunc := PADR(cFunc,9)
   If Empty(cClsMCT) .Or. cClsMCT == cClVl
      //- Alocacao de projetos para rateio SIATA
      dbSelectArea("SZ1")
      dbSetOrder(2)
      dbSeek(XFILIAL("SZ1")+cFunc+cDatarq,.T.)
      While !Eof() .And. XFILIAL("SZ1")+cFunc+cDatarq == Z1_FILIAL+Z1_MAT+SubStr(Dtos(Z1_DATA),1,6)
         nValor := Round(nPgto*Z1_PERC,2)
         If cOri == "SE5"  // 1     2     3      4     5      6     7     8   9   10  11 12   13  14  15  16  17  18 19
            nSoma += GrvTmpE5(cTab,nValor,Z1_CC,cConta,cClVl,cFunc,cPrint,"",nil,nil,nil,nil,nil,nil,nil,cRP,nil,nil,nil)
         Else
            nSoma += GrvTmpE2(cTab,cTmp,nValor,Z1_CC,cConta,cClVl,cFunc,cPrint,nil,nil,nil,nil,nil,nil,nil,nil)
         Endif
         nReg:= (cTab)->( Recno() )
         dbSkip()
      Enddo
   Endif
   If nReg <= (cTab)->( RecCount() )  // Se o registro for menor que total de registros
      If nReg > 0  // Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
         dbSelectArea(cTab)
         dbGoTo(nReg)
         RecLock(cTab,.F.)
         If cOri == "SE5"
            (cTab)->E5_VALOR += nPgto - nSoma
         Else
            (cTab)->E2_SALDO += nPgto - nSoma
         Endif
         MsUnLock()
      Else
         If cOri == "SE5"
            cConta:= Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_CONTAB")
            //->      1     2        3        4         5        6     7    8          9          10   11 12   13  14  15  16 17  18  19
            GrvTmpE5(cTab,nPgto,SE2->E2_CC,cConta,SE2->E2_CLVL,cFunc,cPrint,"","** NAO RATEADO !",nil,nil,nil,nil,nil,nil,cRP,nil,nil,nil)
            //- Arredondando valores nao rateados
            RecLock(cTab,.F.)
            (cTab)->E5_VALOR:= nPgto
            MsUnLock()
         Else
            cConta:= Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_CONTAB")
            GrvTmpE2(cTab,cTmp,nPgto,SE2->E2_CC,cConta,cClVl,cFunc,cPrint,"** NAO RATEADO !",nil,nil,nil,nil,nil,nil,nil)
         Endif
      Endif
   Endif
   dbSelectArea(cAlias)

Return(nPgto)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ CpoPadSE5 ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 28/03/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Monta tabela padrão para a tabela SE5 a ser utilizada nos PRGs¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CpoPadSE5()
   Local aDbf:= {}

   AAdd( aDbf , { "E5_FILIAL" , "C",  2, 0})
   AAdd( aDbf , { "E5_DTDISPO", "D",  8, 0})
   AAdd( aDbf , { "E5_NUMERO" , "C",  9, 0})
   AAdd( aDbf , { "E5_PREFIXO", "C",  3, 0})
   AAdd( aDbf , { "E5_TIPO"   , "C",  3, 0})
   AAdd( aDbf , { "E5_PARCELA", "C",  2, 0})
   AAdd( aDbf , { "E5_RECPAG" , "C",  1, 0})
   AAdd( aDbf , { "E5_VALOR"  , "N", 14, 2})
   AAdd( aDbf , { "E5_CONTAB" , "C", 20, 0})
   AAdd( aDbf , { "E5_DESCT1" , "C", 40, 0})
   AAdd( aDbf , { "E5_CLVL"   , "C",  9, 0})
   AAdd( aDbf , { "E5_DESCTH" , "C", 40, 0})
   AAdd( aDbf , { "E5_CC"     , "C",  9, 0})
   AAdd( aDbf , { "E5_DESCCC" , "C", 40, 0})
   AAdd( aDbf , { "E5_ITEMCTA", "C",  9, 0})
   AAdd( aDbf , { "E5_BANCO"  , "C",  3, 0})
   AAdd( aDbf , { "E5_AGENCIA", "C",  5, 0})
   AAdd( aDbf , { "E5_CONTA"  , "C", 10, 0})
   AAdd( aDbf , { "E5_BENEF"  , "C", 60, 0})
   AAdd( aDbf , { "E5_CLIFOR" , "C",  6, 0})
   AAdd( aDbf , { "E5_LOJA"   , "C",  2, 0})
   AAdd( aDbf , { "E5_STATUS" , "C",  1, 0})
   AAdd( aDbf , { "E5_VIAGEM" , "C",  6, 0})
   AAdd( aDbf , { "E5_TREINAM", "C",  6, 0})
   AAdd( aDbf , { "E5_HORA"   , "C",  6, 0})
   AAdd( aDbf , { "E5_PRODUTO", "C", 40, 0})
   AAdd( aDbf , { "E5_QUANT"  , "N",  6, 0})
   AAdd( aDbf , { "E5_TPIMP"  , "C", 06, 0})
   AAdd( aDbf , { "E5_PRCOMP" , "C",  6, 0})
   AAdd( aDbf , { "E5_NODI"   , "C", 12, 0})
   AAdd( aDbf , { "E5_ITEM"   , "C",  4, 0})
   AAdd( aDbf , { "E5_CMP"    , "C",  1, 0})
   AAdd( aDbf , { "E5_ORIGEM" , "C",  1, 0})
   AAdd( aDbf , { "E5_MOVBCO" , "C",  1, 0})
   AAdd( aDbf , { "E5_ITEMNFE", "C",  4, 0})
   AAdd( aDbf , { "E5_ROTINA" , "C",  8, 0})
   AAdd( aDbf , { "E5_BAICOMP", "C",  1, 0})
   AAdd( aDbf , { "E5_BASEATF", "C", 14, 0})
   AAdd( aDbf , { "E5_SEQ"    , "C",  2, 0})
   AAdd( aDbf , { "E5_TIPODOC", "C",  2, 0})
   AAdd( aDbf , { "E5_TPCTB"  , "C",  1, 0})
   AAdd( aDbf , { "E5_GERFIN" , "C",  1, 0})
   AAdd( aDbf , { "E5_MANUAL" , "C",  1, 0})
   AAdd( aDbf , { "E5_FILORIG", "C",  2, 0})
   AAdd( aDbf , { "E5_XTPORH" , "C",  1, 0})

Return(aDbf)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ NomeFilial¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 28/12/2004¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Retorna o nome da filial especifico INSTITUTO NOKIA           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function NomeFilial(xFilial)
   Local cNomFil := Space(3)

   SX5->(dbSetOrder(1))
   If SX5->(dbSeek(XFILIAL()+"Z2"+xFilial))
      cNomFil := Trim(SX5->X5_DESCRI)
   Endif

Return(cNomFil)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦QuebraLinha¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 28/12/2004¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Quebra em linhas a descricao do objetivo e justificativa      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function QuebraLinha(cObj,cJus,nCarac)
   Local nLi1, nLi2, nMax, x, cLJus, cLObj
   Local nTam := If( nCarac == Nil , 64, nCarac)
   Local vRet := {}

   cObj := AllTrim(cObj)      // Retira os espacos em branco
   cJus := AllTrim(cJus)      // Retira os espacos em branco

   nLi1 := MLCount(cObj,nTam) // Calcula o numero de linhas
   nLi2 := MLCount(cJus,nTam) // Calcula o numero de linhas
   nMax := Max(nLi1,nLi2)     // Calcula o maior numero de linhas

   For x:=1 To nMax

      cLObj := MemoLine(cObj,nTam,x) // Pega a linha do objetivo
      cLJus := MemoLine(cJus,nTam,x) // Pega a linha da justificativa
      
      cLObj := If( cLObj $ "!@#$%¨&*()_+/<>.,;:?\|" , "", cLObj)
      cLJus := If( cLJus $ "!@#$%¨&*()_+/<>.,;:?\|" , "", cLJus)
      
      If Empty(cLObj+cLJus)          // Caso os dois conteudos estejam vazios
         Loop
      Endif

      AAdd( vRet , AFill(Array(2),Space(nTam)) )  // Adiciona uma linha no vetor

      If x <= nLi1
         vRet[Len(vRet),1] := PADR(cLObj,nTam)
      Endif

      If x <= nLi2
         vRet[Len(vRet),2] := PADR(cLJus,nTam)
      Endif
   Next
   
Return vRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ AcertaDif ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 13/07/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Acerta diferenca de centavos redistribuindo a diferenca       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AcertaDif(nDif,vRegs,nSoma,nPrc,cVar,cTab)
   Local x                    
   nDif:= Round(nDif,2) //- Colocado pelo Reinaldo em 04-12-06 para evitar decimais maior que 03 casas.
   
   If cTab <> Nil
      dbSelectArea(cTab)
      While nDif <> 0  // Caso haja diferenca de arredondamento
         For x:=Len(vRegs) To 1 Step -1
            dbGoTo(vRegs[x])
            nSoma -= FieldGet(FieldPos(cVar))  // Subtrai o valor anterior
            RecLock(cTab,.F.)
            FieldPut( FieldPos(cVar) , FieldGet(FieldPos(cVar)) + (nPrc * If( nDif > 0 , 1, -1)) )
            MsunLock()
            nSoma += FieldGet(FieldPos(cVar))  // Soma o novo valor
            nDif  += (nPrc * If( nDif > 0 , -1, 1))
            If nDif == 0
               Exit
            Endif
         Next
      Enddo
   ElseIf Len(vRegs) > 0
      //- Acerta o valor rateado, caso haja diferenca de centavos no arredondamento
      //nVez:= 0
      If lMostra .And. Abs(nDif) > 2
         lMostra := MsgYesNo("Deu diferença no título "+SE2->(E2_PREFIXO+" - "+E2_NUM+" - "+E2_FORNECE)+;
                    ", de arredondamento de R$ "+RTrim(Str(nDif,14,2))+". Mostra próximas diferenças ?","DIFERENÇA")
      Endif  
      If Abs(nDif) < 2
         While nDif <> 0  // Caso haja diferenca de arredondamento
            For x:=Len(vRegs) To 1 Step -1
               If vRegs[x,1] <> 0
                  vRegs[x,1] += (nPrc * If( nDif > 0 , 1, -1))
                  nSoma      += (nPrc * If( nDif > 0 , 1, -1))
                  nDif       += (nPrc * If( nDif > 0 , -1, 1))
                  If nDif == 0
                     Exit
                  Endif
               Endif
            Next
         Enddo
      EndIf  
   Endif
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ Arredonda ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 20/07/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Rotina para acerto da diferenca de centavo                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Arredonda(nTot,vVet,nPV)
   Local x, y, nDec, nDif, nDifAnt
   Local nVezes := 0
   Local nSub   := 0
   Local nTotal := 0
   Local vRet   := Array(Len(vVet),4)

   // Soma o total do vetor
   For x:=1 To Len(vVet)  ;  nTotal += vVet[x,nPV]  ;  Next
   For x:=1 To Len(vRet)
      // Calcula o valor de cada item em relacao ao total real
      vRet[x,2] := Round((vVet[x,nPV]/nTotal)*nTot,3)
      // Conforme terceira casa decimal, identifica se arredondou para cima, para baixo ou nao arredondou
      nDec      := Val(Right(Str(vRet[x,2],14,3),1))
      If nDec == 0
         vRet[x,3] := " "
      ElseIf nDec > 4
         vRet[x,3] := "+"
      Else
         vRet[x,3] := "-"
      Endif
      // Calcula o valor final de cada item ja arredondando em duas casas decimais
      vRet[x,1] := Round(vRet[x,2],2)
      nSub      += vRet[x,1]
      vRet[x,4] := "#"   // Flag de nao processado
   Next

   nDif := nSub - nTot
   If nDif <> 0  // Caso haja diferenca
      // Define prioridades para acerto do arredondamento, ou seja, quais itens serao acertados
      While nDif <> 0 .And. nVezes < 10000 //<-- Forca saida caso entre em LOOP
         nVezes++
         nDifAnt := nDif
         For x:=1 To Len(vRet)
            // Caso tenha tenha valores a arredondar e nao tenha sido processado
            If vRet[x,3] <> " " .And. vRet[x,4] == "#"
               For y:=1 To Len(vRet)
                  If vRet[x,3] == vRet[y,3] .And. x <> y .And. vRet[y,4] == "#" .And. vRet[x,1] == vRet[y,1]
                     If nDif > 0 .And. vRet[x,3] == "+"
                        vRet[x,1] -= 0.01
                        nDif      -= 0.01
                        vRet[x,4] := "x"     // Marca como ja processado
                        vRet[y,4] := "x"     // Marca como ja processado
                     ElseIf nDif < 0 .And. vRet[x,3] == "-"
                        vRet[x,1] += 0.01
                        nDif      += 0.01
                        vRet[x,4] := "x"     // Marca como ja processado
                        vRet[y,4] := "x"     // Marca como ja processado
                     Endif
                  Endif
                  If nDif == 0  // Caso nao haja mais diferenca, entao sai
                     Exit
                  Endif
               Next
            Endif
            If nDif == 0  // Caso nao haja mais diferenca, entao sai
               Exit
            Endif
         Next
         // Caso nao tenha conseguido encontrar nenhum item pra acertar, pega o primeiro que encontrar e acerta
         If nDifAnt == nDif
            While nDif <> 0 .And. nVezes < 10000 //<-- Forca saida caso entre em LOOP
               nVezes++
               For x:=1 To Len(vRet)
                  If vRet[x,3] <> " " .And. vRet[x,4] == "#"
                     If nDif > 0 .And. vRet[x,3] == "+"
                        vRet[x,1] -= 0.01
                        nDif      -= 0.01
                        vRet[x,4] := "x"     // Marca como ja processado
                     ElseIf nDif < 0 .And. vRet[x,3] == "-"
                        vRet[x,1] += 0.01
                        nDif      += 0.01
                        vRet[x,4] := "x"     // Marca como ja processado
                     Endif
                  Endif
               Next
            Enddo
         Endif
      Enddo
   Endif
Return(vRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ ConvFilUsu¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 05/08/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Rotina para conversao do filtro do usuario para query         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ConvFilUsu(cFiltro1)
   Local x, nPos, nChr
   Local vStr := {}      
   Local cFiltro := cFiltro1

   AAdd( vStr , { "SUBSTR(" , "SUBSTRING(" } )
   AAdd( vStr , { ".AND."   , " AND " })
   AAdd( vStr , { ".OR."    , " OR "  })
   AAdd( vStr , { "->"      , ""      })

   // Altera os operadores em xBase para os operados em SQL
   cFiltro := Upper(cFiltro)  // Converte os caracteres para maiusculo
   cFiltro := StrTran(cFiltro,"=="   ," = "  )
   cFiltro := StrTran(cFiltro,"#"    ," <> " )
   cFiltro := StrTran(cFiltro,"!="   ," <> " )
   cFiltro := StrTran(cFiltro,"!"    ," NOT ")
   cFiltro := StrTran(cFiltro,'"'    ,"'"    )
   cFiltro := StrTran(cFiltro,'ALLTRIM', ""  )
   cFiltro := StrTran(cFiltro,'LTRIM'  , ""  )
   cFiltro := StrTran(cFiltro,'RTRIM'  , ""  )
   cFiltro := StrTran(cFiltro,'TRIM'   , ""  )
   
   cFiltro := StrTran(cFiltro,"RC_"   ,"RA_"  )

   // Altera funcoes e operadores logicos em xBase para os equivalentes em SQL
   For x:=1 To Len(vStr)
      nPos := 1
      While nPos > 0
         nPos := At(vStr[x,1],Upper(SubStr(cFiltro,1,Len(cFiltro))))
         If nPos > 0
            If vStr[x,1] <> "->"
               cFiltro := Stuff(cFiltro,nPos,Len(vStr[x,1]),vStr[x,2])
            Else
               nPos -= 3
               cFiltro := Stuff(cFiltro,nPos,5,vStr[x,2])
            Endif
         Endif
      Enddo
   Next

   // Altera a condicao do Está Contido do xBase para o equivalente em SQL
   While (nPos := At("$",cFiltro)) > 0
      If "$''" $ cFiltro
         cFiltro := StrTran(cFiltro,"$''"," IN ('')")
      Else
         nChr := 1
         While SubStr(cFiltro,nPos+nChr-1,1) <> "'" .Or. nChr < 4
            nChr++
         Enddo
         cParte := SubStr(cFiltro,nPos,nChr)
         cParte := StrTran(cParte,"$"," IN (")+")"
         cParte := StrTran(cParte,",","','")
         cParte := StrTran(cParte,";","','")

         cFiltro := Stuff(cFiltro,nPos,nChr,cParte)
      Endif
   Enddo

   // Retira espacos em branco antes e depois dos operadores
   cFiltro := StrTran(cFiltro,"  ="   ," ="   )
   cFiltro := StrTran(cFiltro,"=  "   ,"= "   )
   cFiltro := StrTran(cFiltro,"  AND" ," AND" )
   cFiltro := StrTran(cFiltro,"AND  " ,"AND " )
   cFiltro := StrTran(cFiltro,"  OR"  ," OR"  )
   cFiltro := StrTran(cFiltro,"OR  "  ,"OR "  )
   cFiltro := StrTran(cFiltro,"  IN"  ," IN"  )
   cFiltro := StrTran(cFiltro,"  <>"  ," <>"  )
   cFiltro := StrTran(cFiltro,"<>  "  ,"<> "  )
   cFiltro := StrTran(cFiltro,"  NOT" ," NOT" )

Return("("+cFiltro+")")

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦AcertaFiltr| Autor ¦ Ronilton O. Barros     ¦ Data ¦ 05/10/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Acerta filtro do usuario para ignorar alguns filtros.         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AcertaFiltro(cFiltro,cVar)
   Local nPos, x, cCar, nPI, nPF, cParFil, lAberto
   Local nIni := 1

   While nIni <= Len(cFiltro)
      nPI     := Nil
      nPF     := Nil
      lAberto := .F.
      cParFil := SubStr(cFiltro,nIni,Len(cFiltro))
      nPos    := At(cVar,cParFil)

      If nPos == 0   // Se nao achou ocorrencia, entao sai
         Exit
      Endif

      nPos += Len(cVar) + nIni - 1   // Pega posicao apos variavel
      For x:=nPos To Len(cFiltro)

         cCar := SubStr(cFiltro,x,1)
         If cCar $ "!<>="
            nPI := If( nPI == Nil , x, nPI)  // Pega posicao inicial do comeco do operador
            nPF := x                         // Pega posicao final   do fim    do operador
         ElseIf cCar == '"'
            If !lAberto    // Se ainda nao abriu as ASPAS, entao é comeco de string
               lAberto := .T.
               Loop
            Else           // Se ja estiver aberto, entao sai da string
               x++
               Exit
            Endif
         Endif

         If lAberto        // Se a string estiver aberta
            cFiltro := Stuff(cFiltro,x,1,"^")   // Substitui o caractere por um caractere nao valido
         Endif
      Next
      nIni := x  // Pega posicao apos acerto

      If nPF <> Nil        // Caso posicao final nao seja nula, substitui o operador
         cFiltro := Stuff(cFiltro,nPI,nPF-nPI+1,"<>")
      Endif
   Enddo

Return(cFiltro)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ UserCCusto| Autor ¦ Ronilton O. Barros     ¦ Data ¦ 26/10/2009¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Verifica se o centro de custo pode ser visualizado pelo usuari¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function UserCCusto(cCCusto,cOpc)
   Local cFilAKX := AKX->(XFILIAL("AKX"))
   Local lRet    := Empty(cCCusto)

   cOpc := If( cOpc == Nil , "1", cOpc)  // Define o padrão como 1 = Visualizar

   // Pesquisa na tabela de Usuários x Centro de custo se o mesmo está liberado para visualização
   AKX->(dbSetOrder(1))
   AKX->(dbSeek(cFilAKX+__CUSERID,.T.))
   While !AKX->(Eof()) .And. AKX->AKX_FILIAL+AKX->AKX_USER == cFilAKX+__CUSERID
      If cCCusto >= AKX->AKX_CC_INI .And. cCCusto <= AKX->AKX_CC_FIN
         lRet := (cOpc <= AKX->AKX_DIREIT)
         Exit
      Endif
      AKX->(dbSkip())
   Enddo

Return lRet

/* ----------------------------------------------------------------------------- */
//          ROTINAS REFERENTE A BUSCA DA COMPETENCIA E PROVISÕES
/* ----------------------------------------------------------------------------- */

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ INDADCOMP | Autor ¦ Ronilton O. Barros     ¦ Data ¦ 09/05/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Gera dados conforme competencia para os titulos da folha      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INDADCOMP(cQry,dDtI,dDtF,cMatI,cMatF,cCCI,cCCF,nOpcFil,cFilI,cFilF,cCLVL,nTrataPA,cSalVal)
   Local aDbf, cArq, aStru, cDtFinal, cArq1

   Private dDatIni := dDtI
   Private dDatFim := dDtF
   Private cMatIni := If( cMatI == Nil , Repli(" ",6), cMatI)
   Private cMatFim := If( cMatF == Nil , Repli("Z",6), cMatF)
   Private cCCuIni := If( cCCF  == Nil , Repli(" ",9), cCCI)
   Private cCCuFim := If( cCCF  == Nil , Repli("Z",9), cCCF)
   Private nConsid := nOpcFil
   Private cFilIni := If( cFilI == Nil , "  ", cFilI)
   Private cFilFim := If( cFilI == Nil , "ZZ", cFilF)
   Private cClsCvl := PADR(If( cCLVL <> Nil , cCLVL, " "),9)  // Classe de valor padrão da Folha

   If Select("TMP") == 0        // Caso nao tenha sido criado ainda o arquivo temporario TMP, entao cria
      aDbf := u_CpoPadSE5()     // Recebe estrutura padrão para temporários do SE5
      cArq := CriaTrab(aDbf,.t.)
      Use &cArq Alias TMP New Exclusive
   Endif

   aStru := SE2->(dbStruct())

   // Busca o contas a pagar para pegar a data da competencia
   If cQry == Nil
      cQry := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")
      cQry += " WHERE D_E_L_E_T_ <> '*' AND E2_ORIGEM = 'GPEM670' AND E2_CLVL = '"+cClsCvl+"' AND "

      // Ignora títulos de férias. Os mesmos serão pegos em uma rotina específica
      cQry += "E2_VERBAS NOT LIKE '%452%' AND E2_VERBAS NOT LIKE '%444%' AND "

      // Acerta filtro da data final para os titulos de 13o e 14o salario
      cDtFinal := Dtos(dDatFim)
      If SubStr(cDtFinal,5,2) == "12"
         cDtFinal := Stuff(cDtFinal,5,2,"14")
      Endif
      // Busca a data de competencia do titulo de RH
      cQry += "E2_DATARQ BETWEEN '"+SubStr(DTOS(dDatIni),1,6)+"' AND '"+SubStr(cDtFinal,1,6)+"' AND  "

      If nConsid == 1    // Considera Filial ==  1-Sim  2-Nao
         cQry += "E2_FILIAL >= '"+cFilIni+"' AND E2_FILIAL <= '"+cFilFim+"' "
      Else
         cQry += "E2_FILIAL = '"+xFilial("SE2")+"' "
      Endif
   Endif

   cArq1:= u_INDADSE2("TMP2",cQry,aStru,aReturn[7],,,,nTrataPA,,,,,cSalVal,.F.) // Rotina de Busca de Dados --> Programa: INDACFG.PRW

   // Grava os dados do SE2 no arquivo temporario do SE5 criado para manter o padrao apartir do SE5
   dbSelectArea("TMP2")
   dbGoTop()
   ProcRegua(RecCount())
   While !Eof()

      IncProc("Filtrando titulos...")

      If Empty(cClsCvl) .Or. E2_CLVL == cClsCvl .Or. cSalVal <> Nil .And. cSalVal == "C"
         RecLock("TMP",.T.)
         TMP->E5_FILIAL  := TMP2->E2_FILIAL
         TMP->E5_NUMERO  := TMP2->E2_NUM         
         TMP->E5_PREFIXO := TMP2->E2_PREFIXO
         TMP->E5_TIPO    := TMP2->E2_TIPO
         TMP->E5_PARCELA := TMP2->E2_PARCELA
         TMP->E5_CLIFOR  := TMP2->E2_FORNECE
         TMP->E5_LOJA    := TMP2->E2_LOJA
         TMP->E5_DTDISPO := TMP2->E2_EMIS1
         TMP->E5_VALOR   := TMP2->E2_SALDO
         TMP->E5_CONTAB  := TMP2->E2_CONTAB
         TMP->E5_DESCT1  := Trim(TMP2->E2_DESCT1)  //+TMP2->(E2_NUM+"/"+E2_PREFIXO)
         TMP->E5_CLVL    := TMP2->E2_CLVL
         TMP->E5_DESCTH  := TMP2->E2_DESCTH
         TMP->E5_CC      := TMP2->E2_CC
         TMP->E5_DESCCC  := TMP2->E2_DESCCC
         TMP->E5_ITEMCTA := TMP2->E2_ITEMCTA
         TMP->E5_BANCO   := TMP2->E2_PORTADO
         TMP->E5_AGENCIA := TMP2->E2_AGENCIA
         TMP->E5_BENEF   := TMP2->E2_HIST
         TMP->E5_STATUS  := TMP2->E2_STATUS
         TMP->E5_VIAGEM  := TMP2->E2_VIAGEM
         TMP->E5_TREINAM := TMP2->E2_TREINAM
         TMP->E5_RECPAG  := "P"
         TMP->E5_ORIGEM  := TMP2->E2_ORIGEM
         TMP->E5_ROTINA  := TMP2->E2_ROTINA
         TMP->E5_BAICOMP := "C"
         TMP->E5_TPIMP   := TMP2->E2_TPIMP
         TMP->E5_PRCOMP  := TMP2->E2_PRCOMP
         TMP->E5_NODI    := TMP2->E2_NODI
         TMP->E5_MOVBCO  := "2"
         TMP->E5_HORA    := TMP2->E2_HORA
         TMP->E5_ITEM    := TMP2->E2_ITEM
         TMP->E5_BASEATF := TMP2->E2_BASEATF
         TMP->E5_PRODUTO := TMP2->E2_PRODUTO
         MsUnLock()
         dbSelectArea("TMP2")
      Endif

      dbSkip()
   Enddo
   dbCloseArea()
   FErase(cArq1+".DBF")
   dbSelectArea("TMP")

   If Select("TMP") == 0        // Caso nao tenha sido criado ainda o arquivo temporario TMP, entao cria
      aDbf := u_CpoPadSE5()     // Recebe estrutura padrão para temporários do SE5
      cArq := CriaTrab(aDbf,.t.)
      Use &cArq Alias TMP New Exclusive
   Endif

   If Trim(cClsCvl) == "001"            // Se for Classe de RH
      BuscaFolha("TMP","'072','XXX'")   // Busca as Férias
      BuscaProv ("TMP")                 // Busca as provisões de férias
      BuscaFolha("TMP","'870','871'")   // Busca as provisões de multa de FGTS. Verbas de Multa FGTS e INSS (Rescisão)
   Endif

Return cArq

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ BuscaProv | Autor ¦ Ronilton O. Barros     ¦ Data ¦ 21/03/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Efetua a busca das provisões de Férias e 13o Salário          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function BuscaProv(cTab)
   Local cQry, vProp, vVenc, cFunc, x, nPos, nValMes, vAFer, nFerPro, cDatarq
   Local cBaixa  := "233,234,235,239,240,241,258,259,260,261,262,263,264,265,266,270,271,272,273,274,"+;
                    "275,276,277,280,281,282,283,284,285,286,287,332,333,334,335,336,   "
   Local cAlias  := Alias()

   cQry := "SELECT RA_MAT, B.* FROM "+RetSQLName("SRA")+" A "
   cQry += "LEFT OUTER JOIN "
   cQry += "(SELECT A.*, A.R_E_C_N_O_ RT_RECNO, RV_CODFOL FROM "+RetSQLName("SRT")+" A, "+RetSQLName("SRV")+" B "
   cQry += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND " //RT_TIPPROV IN('1','2') AND "
   cQry += "RV_FILIAL = '"+SRV->(XFILIAL())+"' AND "

   If nConsid == 1    // Considera Filial ==  1-Sim  2-Nao
      cQry += "RT_FILIAL >= '"+cFilIni+"' AND RT_FILIAL <= '"+cFilFim+"' AND "
   Else
      cQry += "RT_FILIAL = '"+xFilial("SRT")+"' AND "
   Endif

   cQry += "RT_VERBA = RV_COD AND RV_CODFOL NOT IN ('"+StrTran(cBaixa,",","','")+"') AND "
   cQry += "SUBSTRING(RT_DATACAL,1,6) >= '"+SubStr(Dtos(dDatIni),1,6)+"' AND "
   cQry += "SUBSTRING(RT_DATACAL,1,6) <= '"+SubStr(Dtos(dDatFim),1,6)+"') B ON "
   cQry += "RA_FILIAL = RT_FILIAL AND RA_MAT = RT_MAT "
   cQry += "WHERE A.D_E_L_E_T_ = ' ' AND RA_MAT >= '"+cMatIni+"' AND RA_MAT <= '"+cMatFim+"' "

   If nConsid == 1    // Considera Filial ==  1-Sim  2-Nao
      cQry += "AND RA_FILIAL >= '"+cFilIni+"' AND RA_FILIAL <= '"+cFilFim+"' "
   Else
      cQry += "AND RA_FILIAL = '"+xFilial("SRA")+"' "
   Endif

   cQry += "ORDER BY RT_FILIAL, RA_MAT, RT_CC, RT_DATACAL, RT_TIPPROV, RT_VERBA"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )

   TCSetField("QRY", "RT_DATACAL", "D", 8, 0)

   ProcRegua(RecCOunt())
   While !Eof()
      vProp   := {}
      vVenc   := {}
      vAFer   := { 0, 0}
      nFerPro := 0
      cFunc   := QRY->RT_FILIAL+QRY->RA_MAT
      While !QRY->(Eof()) .And. cFunc == QRY->RT_FILIAL+QRY->RA_MAT
      
         IncProc("Rateando provisões...")

         If Empty(QRY->RT_MAT) .Or. QRY->RT_TIPPROV == "1"
            // Caso seja o tipo Ferias vencidas, guarda dados pois pode ser usado posteriormente
            If QRY->RT_TIPPROV == "1"
               AAdd( vVenc , { QRY->RT_VERBA, QRY->RT_DATACAL, QRY->RT_RECNO, .T.})
            Endif

            QRY->(dbSkip())
            Loop
         Endif

         // Pesquisa a ocorrencia das Ferias proporcionais no mes anterior, e subtrai
         AAdd( vProp , { QRY->RT_FILIAL, QRY->RT_DATACAL, QRY->RT_VERBA, QRY->RT_VALOR - ProvMesAnt("QRY",QRY->RT_VALOR,@nFerPro)} )

         // Pesquisa a verba no vetor de ferias vencidas para desabilitar seu uso posterior.
         // Isso é necessário pois a féria proporcional foi encontrada
         If (nPos := Ascan( vVenc , {|x| x[1]+Dtos(x[2]) == QRY->RT_VERBA+Dtos(QRY->RT_DATACAL) } )) > 0
            vVenc[nPos,4] := .F.
         Endif

         QRY->(dbSkip())
      Enddo

      // Processa as ferias vencidas
      nFerPro := 0
      For x:=1 To Len(vVenc)
         If vVenc[x,4]  // Verifica se só existe férias vencidas no mês
            SRT->(dbGoTo(vVenc[x,3]))
            // Calcula Ferias proporcionais caso ja tenha valores recebidos
            vAFer   := If( vAFer[1] == 0 , { SRT->RT_DFERVEN, SRT->RT_DFERANT}, vAFer)
            nValMes := If( vAFer[1] <> 0 , (SRT->RT_VALOR * 30) / (vAFer[1] - vAFer[2]), SRT->RT_VALOR)
            AAdd( vProp , { SRT->RT_FILIAL, SRT->RT_DATACAL, SRT->RT_VERBA, nValMes - ProvMesAnt("SRT",nValMes,@nFerPro)} )
         Endif
      Next

      // Efetua gravacao das ferias proporcionais
      For x:=1 To Len(vProp)
         If vProp[x,4] <> 0
            cDatarq := SubStr(Dtos(vProp[x,2]),1,6)
            RateiaFunc(vProp[x,1],SubStr(cFunc,3,6),vProp[x,4],vProp[x,2],vProp[x,3],cDatarq,cTab)
         Endif
      Next
   Enddo
   QRY->(dbCloseArea())
   dbSelectArea(cAlias)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ ProvMesAnt| Autor ¦ Ronilton O. Barros     ¦ Data ¦ 23/03/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa as provisões de Férias e 13o Salário do mês anterior ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ProvMesAnt(cTab,nValAtu,nFerPro)
   Local vAnt, dLastDay, cQry
   Local nInd   := SRT->(IndexOrd())
   Local nReg   := SRT->( Recno()  )
   Local cAlias := Alias()
   Local nRet   := 0

   // Se o tipo for 13o Salario, e for o Mês de Janeiro, retorna valor 0.00 como mês anterior
   If (cTab)->RT_TIPPROV == "3" .And. Month((cTab)->RT_DATACAL) == 1
      Return 0.00
   Endif

   dLastDay := FirstDay((cTab)->RT_DATACAL) - 1  // Data da provisao do mes anterior
   vAnt := { (cTab)->RT_FILIAL, (cTab)->RT_MAT, (cTab)->RT_CC, dLastDay, If( (cTab)->RT_TIPPROV $ "12" , "2", (cTab)->RT_TIPPROV), (cTab)->RT_VERBA}

   dbSelectArea("SRT")
   dbSetOrder(1)
   If dbSeek(vAnt[1]+vAnt[2]+vAnt[3]+Dtos(vAnt[4])+vAnt[5]+vAnt[6])
      nRet    := SRT->RT_VALOR
      nFerPro := If( nFerPro == 0 , SRT->RT_DFERPRO, nFerPro)
   Else
      // Pesquisa se houve transferencia para o funcionario
      vAnt[4] := Nil
      SRE->(dbSetOrder(4))
      SRE->(dbSeek(SM0->M0_CODIGO+SM0->M0_CODFIL+vAnt[2]+SubStr(Dtos(dLastDay+1),1,6),.T.))
      While !SRE->(Eof()) .And. SM0->M0_CODIGO+SM0->M0_CODFIL+vAnt[2] == SRE->RE_EMPP+SRE->RE_FILIALP+SRE->RE_MATP
         // Caso o periodo da transferencia seja igual a data do mes e o centro de custo destino
         // for igual ao centro de custo atual, entao achou as informacoes de origem
         If SubStr(Dtos(dLastDay+1),1,6) == SubStr(Dtos(SRE->RE_DATA),1,6) .And. SRE->RE_CCP == vAnt[3]
            vAnt := { SRE->RE_FILIALD, SRE->RE_MATD, SRE->RE_CCD, dLastDay, vAnt[5], vAnt[6]}
            Exit
         Endif
         SRE->(dbSkip())
      Enddo

      // Se nao achou o mes anterior, o campo 3 (Data) vai estar com o valor nulo
      If vAnt[4] <> Nil
         If SRE->RE_EMPD == SM0->M0_CODIGO    // Se a empresa anterior for a mesma
            SRT->(dbSetOrder(1))
            If SRT->(dbSeek(vAnt[1]+vAnt[2]+vAnt[3]+Dtos(vAnt[4])+vAnt[5]+vAnt[6]))
               nRet    := SRT->RT_VALOR
               nFerPro := If( nFerPro == 0 , SRT->RT_DFERPRO, nFerPro)
            Endif
         Else
            cQry := "SELECT ISNULL(RT_VALOR,0)RT_VALOR FROM SRT"+SRE->RE_EMPD+"0 "
            cQry += "WHERE RT_FILIAL = '"+SRE->RE_FILIALD+"' AND RT_MAT = '"+SRE->RE_MATD+"' AND "
            cQry += "RT_CC = '"+SRE->RE_CCD+"' AND D_E_L_E_T_ = ' '"

            dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQry)), "QRY", .F., .T.)
            nRet    := QRY->RT_VALOR
            nFerPro := If( nFerPro == 0 , QRY->RT_DFERPRO, nFerPro)
            dbCloseArea()
         Endif
      Endif
   Endif
   SRT->(dbSetOrder(nInd))
   SRT->(dbGoTo(nReg))
   dbSelectArea(cAlias)

   // Calcula o valor anterior ao proporcional do mes, caso o valor do mes anterior seja maior que o atual
   If nFerPro <> 0 .And. nRet > nValAtu
      nRet := nValAtu - (nRet / (nFerPro / 2.5))
   Endif

Return(nRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦BuscaFolha | Autor ¦ Ronilton O. Barros     ¦ Data ¦ 23/03/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Conforme lançamentos na folha, busca provisões de multa e resc¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function BuscaFolha(cTab,cVerbas)
   Local cQry
   Local cVerRes := cVerbas
   Local cDatIni := SubStr(Dtos(dDatIni),1,6)
   Local cDatFim := SubStr(Dtos(dDatFim),1,6)
   Local cAlias  := Alias()

   // Monta query buscando as multas de fgts geradas na tabela de acumulados mensais (SRD)
   cQry := "SELECT RD_FILIAL, RD_MAT, RD_DATARQ, RD_PD, MAX(RD_DATPGT)RD_DATPGT, "
   cQry += "SUM(RD_VALOR)RD_VALOR FROM "+RetSQLName("SRD")+" WHERE D_E_L_E_T_ = ' ' AND "
   cQry += "RD_MAT >= '"+cMatIni+"' AND RD_MAT <= '"+cMatFim+"' AND RD_PD IN ("+cVerRes+") AND "
   cQry += "RD_DATARQ >= '"+cDatIni+"' AND RD_DATARQ <= '"+cDatFim+"' AND "

   If nConsid == 1    // Considera Filial ==  1-Sim  2-Nao
      cQry += "RD_FILIAL >= '"+cFilIni+"' AND RD_FILIAL <= '"+cFilFim
   Else
      cQry += "RD_FILIAL = '"+xFilial("SRD")
   Endif

   cQry += "' GROUP BY RD_FILIAL, RD_MAT, RD_DATARQ, RD_PD ORDER BY RD_FILIAL, RD_MAT, RD_DATARQ, RD_PD"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )

   TCSetField("QRY", "RD_DATPGT", "D", 8, 0)

   ProcRegua(RecCount())
   While !Eof()

      IncProc("Rateando multas...")
      RateiaFunc(QRY->RD_FILIAL,QRY->RD_MAT,QRY->RD_VALOR,QRY->RD_DATPGT,QRY->RD_PD,QRY->RD_DATARQ,cTab)

      dbSkip()
   Enddo
   dbCloseArea()
   dbSelectArea(cAlias)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ RateiaFunc| Autor ¦ Ronilton O. Barros     ¦ Data ¦ 23/03/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Rateia valores encontrados conforme lançamento no SIATA       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RateiaFunc(cFil,cMat,nValor,dDtPgt,cVerba,cDatarq,cTab)
   Local vCusto, nTotal, nDif, x, vOk
   Local cFilSZ1 := XFILIAL("SZ1")
   Local cAlias  := Alias()

   //- Alocacao de projetos para rateio SIATA
   vCusto := {}
   nTotal := 0
   cMat   := PADR(cMat,9)
   dbSelectArea("SZ1")
   dbSetOrder(2)
   dbSeek(cFilSZ1+cMat+cDatarq,.T.)
   While !Eof() .And. cFilSZ1+cMat+cDatarq == Z1_FILIAL+Z1_MAT+SubStr(Dtos(Z1_DATA),1,6)
      AAdd( vCusto , { Z1_CC, Round(nValor*Z1_PERC,2) })
      nTotal += Round(nValor*Z1_PERC,2)
      dbSkip()
   Enddo

   // Caso haja diferenca de centavos. Distribui a diferenca entre os itens
   If nTotal <> 0 .And. (nValor - nTotal) <> 0
      vOk  := u_Arredonda(nValor,vCusto,2)
   Endif

   // Grava os centros de custos em que o funcionario foi alocado
   For x:=1 To Len(vCusto)
      If vCusto[x,1] >= cCCuIni .And. vCusto[x,1] <= cCCuFim
         // Pesquisa a conta contábil a ser gravada
         SRV->(dbSetOrder(1))
         SRV->(dbSeek(XFILIAL("SRV")+cVerba))
         CT1->(dbSetOrder(1))
         CT1->(dbSeek(XFILIAL("CT1")+SRV->RV_CTADEB))

         RecLock(cTab,.T.)
         (cTab)->E5_FILIAL  := cFil
         (cTab)->E5_DTDISPO := dDtPgt
         (cTab)->E5_VALOR   := If( vOk <> Nil , vOk[x,1], vCusto[x,2])
         (cTab)->E5_CONTAB  := SRV->RV_CTADEB
         (cTab)->E5_DESCT1  := Trim(SRV->RV_DESC)+" ("+cVerba+")"   //CT1->CT1_DESC01
         (cTab)->E5_CLVL    := cClsCvl        // Classe de Valor: Recursos Humanos
         (cTab)->E5_CC      := vCusto[x,1]
         (cTab)->E5_ITEMCTA := cMat
         (cTab)->E5_STATUS  := "S"
         (cTab)->E5_RECPAG  := "P"
         (cTab)->E5_ROTINA  := "GPEM670"
         (cTab)->E5_BAICOMP := "C"
         MsUnLock()
      Endif
   Next
   dbSelectArea(cAlias)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ CondPadRel| Autor ¦ Ronilton O. Barros     ¦ Data ¦ 05/07/2006¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Condição padrão de todos relatórios do MCT                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CondPadRel()
   Local cRet := "E5_SITUACA NOT IN ('C','E','X') AND "
   cRet += "E5_TIPODOC NOT IN ('JR','J2','MT','M2','CP','DC','D2','CM','C2','AP','TR','TE','BA','ES') AND "
   cRet += "E5_BANCO NOT IN ('   ')"
Return(cRet)
