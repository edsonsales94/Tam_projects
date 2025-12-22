#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFINP03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 02/03/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua o vínculo entre o CT2 x SE2 através do CT2_KEY.        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


User Function INFINP03()
   Local cPerg := PADR("INFINP03",Len(SX1->X1_GRUPO))

   ValidPerg(cPerg)

   While Pergunte(cPerg,.T.)
      ProcVinculo()
   Enddo

Return

Static Function ProcVinculo()
   Local cQry, x, cKey, oDlg, oItem, cItem, cLP, lAchou, oMark, nPos, cChave
   Local aItem   := {}
   Local cContas := "110901,110902,110903,110904,110905,110906,110907,110908,110909,"+;
                    "130201,320101,320119,320120,320121,320122,320123,320124,320199"
   Local oOk     := LoadBitmap( GetResources(), "LBOK")
   Local oNo     := LoadBitmap( GetResources(), "LBNO")
   Local cTitulo := "Lançamentos para Fil: "+mv_par01+" - Titulo: "+mv_par02+"/"+mv_par03
   Local nOpcA   := 0
   Local lMark   := .T.
   Local vTam    := {}
   Local nTamA   := 0
   Local nTamN   := 0

   SE2->(dbSetOrder(1))
   If !SE2->(dbSeek(mv_par01+mv_par02+mv_par03))
      Alert("Título informado não existe !")
      Return
   Endif

   // Cria vetor com campos e tamanhos antigos
   AAdd( vTam , { "E2_FILIAL" , 2})
   AAdd( vTam , { "E2_PREFIXO", 3})
   AAdd( vTam , { "E2_NUM"    , 6})
   AAdd( vTam , { "E2_PARCELA", 1})
   AAdd( vTam , { "E2_TIPO"   , 3})
   AAdd( vTam , { "E2_FORNECE", 6})
   AAdd( vTam , { "E2_LOJA"   , 2})

   // Calcula os o total de tamanhos antigos e novos
   aEval( vTam , {|x| nTamA += x[2], nTamN += TamSX3(x[1])[1] })

   CTL->(dbSetOrder(1))

   cQry := "SELECT R_E_C_N_O_ AS CT2_RECNO FROM "+RetSQLName("CT2")+" CT2 WHERE CT2.D_E_L_E_T_ = ' '"
   cQry += " AND CT2_FILIAL = '"+mv_par01+"' AND CT2_ROTINA IN ('FINA050','FINA370','       ')"
   cQry += " AND CT2_HIST LIKE '%"+AllTrim(mv_par02)+"%"+AllTrim(mv_par03)+"%'"
   cQry += " AND (CT2_KEY <> 'XX' OR SUBSTRING(CT2_ROTINA,1,3) = 'GPE')"
   cQry += " AND CT2_VALOR <> 0 AND (CT2_CCD <> ' ' OR CT2_CCC <> ' ')"

   // Adicionar lançamentos padrões que não serão processados. Ex: Baixas pois não se referem
   // a COMPETÊNCIA
   cQry += " AND CT2_LP NOT IN ('530','532','597','801','805','820',"

   // Adicionar lançamentos padrões que não serão processados. Ex: Estornos diversos
   //If !lEstorno   // Se não considera estorno
      cQry += "'509','512','514','515','531','564','565','581','589','591','656',"
   //Endif
   cQry += "'806','807','814','815','816')"

   cQry += " AND (SUBSTRING(CT2_DEBITO,1,6) IN "+FormatIn(cContas,",")
   cQry += " OR SUBSTRING(CT2_CREDIT,1,6) IN "+FormatIn(cContas,",")+")"
   cQry += " AND CT2_TPSALD = '1' AND CT2_CANC <> 'S'"
   cQry += " AND CT2_ROTINA <> 'CTBA211'"  // Desconsidera lançamentos de fechamento
   cQry += " AND CT2_KEY = ' '"
   cQry += " ORDER BY CT2_DATA, CT2_LOTE, CT2_LINHA"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TBS", .T., .F. )

   If CT2_RECNO == 0
      dbCloseArea()
      cQry := StrTran(cQry,"LIKE '%"+AllTrim(mv_par02),"LIKE '%NF")
      dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TBS", .T., .F. )
   Endif

   While !Eof()

      CT2->(dbGoTo(TBS->CT2_RECNO))

      CV3->(dbSetOrder(2))
      If lAchou := CV3->(dbSeek(CT2->CT2_FILIAL+AllTrim(Str(TBS->CT2_RECNO,10))))
         lAChou := (CV3->CV3_DTSEQ == CT2->CT2_DATA .And. CV3->CV3_SEQUEN == CT2->CT2_SEQUEN)
      Endif

      If !lAchou
         CV3->(dbSetOrder(1))
         CV3->(dbSeek(CT2->(CT2_FILIAL+Dtos(CT2_DATA)+CT2_SEQUEN)))
      Endif

      If !Empty(CV3->CV3_KEY) .And. CV3->CV3_TABORI $ "SE2,SEV,SEZ"
         lAchou := .F.
         cChave := AllTrim(CV3->CV3_KEY)
         If Len(cChave) == nTamA   // Se o tamanho for igual ao antigo
            nPos   := 0
            cChave := ""
            aEval( vTam , {|x| cChave += PADR(SubStr(CV3->CV3_KEY,nPos+1,x[2]),TamSX3(x[1])[1]), nPos += x[2] })
         Endif
         lAchou := SE2->(dbSeek(cChave))
      ElseIf CV3->CV3_TABORI == "SEV"
         SEV->(dbGoTo(Val(CV3->CV3_RECORI)))
         lAchou := SE2->(dbSeek(SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)))
      ElseIf CV3->CV3_TABORI == "SEZ"
         SEZ->(dbGoTo(Val(CV3->CV3_RECORI)))
         lAchou := SE2->(dbSeek(SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA)))
      ElseIf CV3->CV3_TABORI == "SE2"
         SE2->(dbGoTo(Val(CV3->CV3_RECORI)))
         lAchou := .T.
      Else
         lAchou := .T.
      Endif

      // Caso esteja vazio para o Financeiro, atribui lançamento padrão 510
      cLP := If( mv_par02 == "FIN" .And. Empty(CT2->CT2_LP) , "510", CT2->CT2_LP)

      CTL->(dbSeek(XFILIAL("CTL")+cLP))

      cKey := &(CTL->(CTL_ALIAS+"->("+Trim(CTL_KEY)+")"))

      If !lAchou
         cQry := "SELECT DISTINCT CT2_KEY FROM "+RetSQLName("CT2")+" CT2"
         cQry += " WHERE D_E_L_E_T_ = ' ' AND CT2_FILIAL = '"+CT2->CT2_FILIAL+"' AND CT2_DATA = '"+Dtos(CT2->CT2_DATA)+"'"
         cQry += " AND CT2_LOTE = '"+CT2->CT2_LOTE+"' AND CT2_DOC = '"+CT2->CT2_DOC+"' AND CT2_HIST = '"+CT2->CT2_HIST+"'"
         cQry += " AND CT2_SEQUEN = '"+CT2->CT2_SEQUEN+"' AND CT2_ORIGEM = '"+CT2->CT2_ORIGEM+"' AND CT2_KEY <> ' '"
         cQry += " AND CT2_ROTINA = '"+CT2->CT2_ROTINA+"' AND CT2_DTCV3 = '"+Dtos(CT2->CT2_DTCV3)+"' AND CT2_LP = '"+CT2->CT2_LP+"'"

         dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP", .T., .F. )
         If lAchou := !Empty(CT2_KEY)
            cKey := CT2_KEY
         Endif
         dbCloseArea()
         dbSelectArea("TBS")
      Endif

      CT2->(AAdd( aItem , { lAchou, CT2_DATA,;
                            Transform(CT2_VALOR,"@E 999,999,999.99"),;
                            If( Empty(CT2_CCD) , CT2_CCC, CT2_CCD),;
                            If( Empty(CT2_DEBITO) , CT2_CREDIT, CT2_DEBITO),;
                            CT2_HIST, If( lAchou , cKey, "TITULO NAO ENCONTRADO"), Recno(), cLP, lAchou}))

      dbSkip()
   Enddo
   dbCloseArea()

   If Empty(aItem)
      Alert("Não foram encontrados lançamentos para esse título !")
      Return
   Endif

   DEFINE MSDIALOG oDlg FROM 0,0 TO 310,920 TITLE OemToAnsi(cTitulo) PIXEL

   @ 05,05 LISTBOX oItem VAR cItem Fields HEADER "","Data","Valor","Projeto","Conta","Histórico","Chave",;
           SIZE 450,130 ON DBLCLICK (If(aItem[oItem:nAt,10],(aItem[oItem:nAt,1]:=!aItem[oItem:nAt,1],oItem:Refresh()),)) ;
           OF oDlg PIXEL

   oItem:SetArray(aItem)
   oItem:bLine := { || {If(aItem[oItem:nAt,1],oOk,oNo),aItem[oItem:nAt,2],;
                        aItem[oItem:nAt,3],aItem[oItem:nAt,4],aItem[oItem:nAt,5],;
                        aItem[oItem:nAt,6],aItem[oItem:nAt,7]}}

   @ 138,006 CHECKBOX oMark VAR lMark PROMPT "Marcar / Desmarcar" ON CLICK Marcacao(lMark,@aItem,@oItem) OF oDlg SIZE 100,08 PIXEL

   DEFINE SBUTTON FROM 140, 360 TYPE 1 ACTION (oDlg:End(),nOpcA:=1) ENABLE OF oDlg
   DEFINE SBUTTON FROM 140, 395 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED

   DeleteObject(oOk)
   DeleteObject(oNo)

   If nOpcA == 1
      For x:=1 To Len(aItem)
         If aItem[x,1] .And. aItem[x,10]
            CT2->(dbGoTo(aItem[x,8]))

            RecLock("CT2",.F.)
            CT2->CT2_KEY := aItem[x,7]
            CT2->CT2_LP  := aItem[x,9]
            MsUnLock()
         Endif
      Next
   Endif

Return

Static Function Marcacao(lMark,aItem,oItem)
   aEval( aItem , {|x| If( x[10] , x[1] := lMark, ) })
   oItem:Refresh()
Return .T.

Static Function ValidPerg(cPerg)
   Local nTam := TamSX3("E2_NUM")[1]

   u_INPutSX1(cPerg,"01",PADR("Filial ",29)+"?","","","mv_ch1","C",   2,0,0,"G","","",   "","","mv_par01")
   u_INPutSX1(cPerg,"02",PADR("Prefixo",29)+"?","","","mv_ch2","C",   3,0,0,"G","","",   "","","mv_par02")
   u_INPutSX1(cPerg,"03",PADR("Titulo ",29)+"?","","","mv_ch3","C",nTam,0,0,"G","","",   "","","mv_par03")
Return
