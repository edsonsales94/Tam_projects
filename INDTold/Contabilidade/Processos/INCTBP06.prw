#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ INCTBP06  ¦       ¦                        ¦ Data ¦ 22/02/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Rotina para geracao de rateios externos                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦   
¦¦¦ Parâmetro ¦ Nenhum                                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦+ Alteracoes+ 08/03/05 - Desmarcar itens selecionados no ultimo rateio      +¦¦
¦¦+           + 30/03/05 - Incluido o filtro de rateio por departamento       +¦¦
¦¦+           +            1=Administraca;2=Projeto;3=Ambos                   +¦¦
¦¦+           + 19/04/05   1=Colaborador ;2=Estagiario                        +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function INCTBP06()
  Local cPerg     := PADR("INCTBP06",Len(SX1->X1_GRUPO))
  Local cCadastro := OemtoAnsi("Gerador de Rateios Externos")
  Local aSays     := {}
  Local aButtons  := {}
  Local nOpca     := 0

  ValidPerg(cPerg)
  Pergunte(cPerg,.F.)

  AADD(aSays,OemToAnsi("Esta rotina ira gerar percentuais para o rateio externos da contabilidade,") )
  AADD(aSays,OemToAnsi("que sera  utilizado  pelos modulos de compras e financeiro, estes  rateios") )
  AADD(aSays,OemToAnsi("levarao em consideracao os percentuais informados no SIATA.               ") )

  AADD(aButtons, { 5,.t.,{|| Pergunte(cPerg,.T. ) }})
  AADD(aButtons, { 1,.t.,{|o| nOpca := 1,FechaBatch() }})
  AADD(aButtons, { 2,.t.,{|o| FechaBatch() }} )

  FormBatch( cCadastro, aSays, aButtons )

  If nOpca == 1
     CT1->(dbSetOrder(1))
     If CT1->(dbSeek(XFILIAL("CT1")+mv_par08))
        CTH->(dbSetOrder(1))
        If CTH->(dbSeek(XFILIAL("CTH")+mv_par05))
           //- Indices de rateio do SIATA
           SZ1->(DbSetOrder(1))
           If SZ1->(DbSeek(xFilial("SZ1")+Dtos(mv_par02)))
              Processa({|| RunProc() } , "Geracao de Rateios Externos")
           Else
              Alert("Não foi encontrado rateio do SIATA nesta data !")
           Endif
        Else
           Alert("Classe de valor informada não existe !")
        Endif
     Else
        Alert("Conta contábil informada não existe !")
     Endif
  Endif

Return

//////////////////////////
Static procedure Runproc
  Local cQry
  Local aStruct := CTD->(dbStruct())
  Local cArq    := CriaTrab(aStruct,.T.)
  Local cInd    := Criatrab(Nil,.F.)
  Local cFilSZ1 := SZ1->(XFILIAL("SZ1"))
  Local y,x 
  Private nTotPer := 0
  
  Use &cArq Alias TMP New Exclusive

  // Limpa os campos de marcação
  cQry := "UPDATE "+RetSQLName("CTD")+" SET CTD_SIATA = ' ', CTD_OK = ' '"
  TCSQLExec(cQry)

  //- Itens contabeis
  CTD->(dbSetOrder(1))

  ProcRegua(SZ1->(Reccount()))
  
  While !SZ1->(Eof()) .And. cFilSZ1 == SZ1->Z1_FILIAL .And. SZ1->Z1_DATA == mv_par02
     
     IncProc()
     
     //- Implementando filtro para selecao de 1=Colaborador/ 2=Estagiario/ 3=Todos
     If mv_par07 == 3 .Or. SZ1->Z1_FUNCAO == Str(mv_par07,1)
        //- Verificando se o colaborador esta no SIATA e o filtro por departamento
        If CTD->(DbSeek(xFilial("CTD")+SZ1->Z1_MAT)) .And. Empty(CTD->CTD_SIATA)
           If mv_par06 == 3 .Or. CTD->CTD_DEPTO == "3" .Or. (mv_par06 == 1 .And. CTD->CTD_DEPTO == "1") .Or. (mv_par06 == 2 .And. CTD->CTD_DEPTO == "2")
              RecLock("CTD",.F.)
              CTD->CTD_SIATA := "S"
              CTD->CTD_OK    := " "
              MsUnLock()

              Reclock("TMP",.T.)
              For x:=1 To TMP->(FCount())
                 FieldPut( x , CTD->(FieldGet(x)) )
              Next
              //TMP->CTD_SIATA := "S"
              //TMP->CTD_OK    := " "
              Msunlock()
           Endif
        Endif   
     Endif   

     SZ1->(DbSkip())
  Enddo    

  DbSelectArea("TMP")
  IndRegua("TMP", cInd, "CTD_DESC01",, /*"CTD_SIATA = 'S'"*/, "Aguarde selecionando registros....")
  dbGoTop()

  If mv_par03 == 1 
     RatIgual() //- Rateio igual
  Else
     RatDiff()  //- Rateio diferente
  Endif                

  TMP->(DbCloseArea())
  FErase(cArq+GetDBExtension())

return

/////////////////////////
Static procedure RatIgual()                
  Local oMark, oDlg, lExec, oBtn1, oBtn2
  Local nValRat := mv_par01
  Local cRateio := mv_par04
  Local cMarca  := "x" //GetMark()
  Local nMarca  := 0
  Local cAlias  := "CTD"

  CTD->(dbSetOrder(4))
  CTD->(dbSetFilter({|| CTD->CTD_SIATA == 'S' },"CTD->CTD_SIATA = 'S'"))

  DEFINE MSDIALOG oDlg TITLE "Seleção de Colaboradores" FROM 00,00 TO 400,700 PIXEL

     oMark:= MsSelect():New( cAlias, "CTD_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

     oMark:oBrowse:Refresh()
     oMark:bAval               := { || ( Marcar(cAlias,cMarca,@nMarca ), oMark:oBrowse:Refresh() ) }
     oMark:oBrowse:lHasMark    := .T.
     oMark:oBrowse:lCanAllMark := .F.
     
     @ 175,001 SAY "Rateio:"
     @ 175,040 GET cRateio SIZE 140,20 PICTURE "@!" OBJECT oRateio WHEN .F.

     @ 190,001 SAY "Valor Despesa: "
     @ 190,040 GET nValRat SIZE 40,20 PICTURE "@E 999,999,999.99" OBJECT oValRat WHEN .F.
  
     @ 190,090 SAY "Marcados: "
     @ 190,120 GET nMarca SIZE 30,20 PICTURE "@E 999999" OBJECT oMarca WHEN .F.

     DEFINE SBUTTON oBtn1 FROM 180,280 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
     DEFINE SBUTTON oBtn2 FROM 180,310 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED
  
  dbGoTop()
  
  If lExec
     If nMarca > 0
        Processa({|lEnd| RatMarcados(cAlias,cMarca,nMarca)})
     Else
        Alert("Não foi selecionado nenhum registro !")
     Endif
  Endif

Return

////////////////////////////////////
Static function RatMarcados(cAlias,cMarca,nMarca)
  Local cMaxRat := UltimoRateio() //- Retorna o ultimo registro gravado no CTJ
  Local nCC     := 0
  Local nReg    := 0

  Begin Transaction
  
  ProcRegua((cAlias)->(RecCount()))
  (cAlias)->(Dbgotop())

  While !(cAlias)->(Eof())

     IncProc()

     If (cAlias)->CTD_OK == cMarca
        nReg := GrvCTJ((cAlias)->CTD_ITEM,1,nMarca,cMaxRat,@nCC)
     Endif
        
     (cAlias)->(dbSkip())
  Enddo               

  AcertaTotal(nReg,100,nTotPer)

  End Transaction

Return

/////////////////////////
Static Function RatDiff()
  Local oDlg, nLin, i, cMaxRat
  Local nValRat := mv_par01
  Local cRateio := mv_par04
  Local nTotal  := 0
  Local nOpcA   := 0
  Local nCC     := 0
  Local nReg    := 0
  
  Private aCols    := {}
  Private aHeader  := {}
  Private nValRest := 0

  //- Monta o aHeader
  aAdd(aHeader,{"Matric.", "E2_ITEMCTA", "@!"               ,09,0, ".F.","","C","SE2"} )
  aAdd(aHeader,{"Nome"   , "E2_NOMFOR" , "@!"               ,40,0, ".F.","","C","SE2"} )
  aAdd(aHeader,{"Valor"  , "E2_VALOR"  , "@E 999,999,999.99",14,2, ".T.","","N","SE2"} )  

  //- Monta o aCols

  TMP->(dbGotop())
  While !TMP->(Eof())
     aAdd(aCols,Array(Len(aHeader)+1))
     nLin := Len(aCols)
     aCols[nLin,1] := TMP->CTD_ITEM
     aCols[nLin,2] := TMP->CTD_DESC01
     aCols[nLin,3] := 0.00
     aCols[nLin,4] := .F.
     TMP->(dbSkip())
  Enddo

  aSort(aCols,,,{|x,y| x[2] < y[2] })

  @ 00,00 TO 470,550 DIALOG oDlg TITLE "Relação de Colaboradores"

  @ 01,01 TO 170,270 MULTILINE MODIFY DELETE VALID CheckAcols(@nTotal) OBJECT oMulti
  
  @ 175,001 SAY "Rateio:"
  @ 175,020 GET cRateio SIZE 140,20 PICTURE "@!" OBJECT oRateio WHEN .F.

  @ 190,001 SAY "Valor Despesa: "
  @ 190,040 GET nValRat SIZE 40,20 PICTURE "@E 999,999,999.99" OBJECT oValRat WHEN .F.

  @ 205,001 SAY "Valor Total: "
  @ 205,040 GET nTotal SIZE 40,20 PICTURE "@E 999,999,999.99" OBJECT oTotal WHEN .F.
  
  @ 220,001 SAY "Valor restante: "
  @ 222,040 GET nValRest SIZE 40,20 PICTURE "@E 999,999,999.99" OBJECT oValRest WHEN .F.
  
  @ 205,190 BMPBUTTON TYPE 1 ACTION If( nTotal == mv_par01 , (nOpcA:=1,Close(oDlg)), MsgStop("O valor distribuído não corresponde ao valor da despesa !"))
  @ 205,220 BMPBUTTON TYPE 2 ACTION (nOpcA:=0,Close(oDlg))     //125

  ACTIVATE DIALOG oDlg CENTERED

  If nOpcA == 1
     cMaxRat := UltimoRateio() //- Buscando utimo rateio gravadado na CTJ

     Begin Transaction

     //- Processa os Nao deletados e informado valor
     aEval( aCols , {|i| If( !i[4] .And. i[3] > 0 , nReg := GrvCTJ(i[1],i[3],mv_par01,cMaxRat,@nCC), ) } )

     AcertaTotal(nReg,100,nTotPer)

     End Transaction
  Endif

Return

/////////////////////////////////////////////////
Static function GrvCTJ(cMat,nUM,nTotal,cMaxRat,nCC)
  Local nReg1    := 0
  Local nSoma    := 0
  Local cFilSZ1  := xFilial("SZ1")
  Local nPercRat := nUM / nTotal
     
  //- Indices de rateio do SIATA
  SZ1->(DbSetOrder(2))
  SZ1->(DbSeek(cFilSZ1+cMat+Dtos(mv_par02),.T.))

  While !SZ1->(Eof()) .And. SZ1->(Z1_FILIAL+Z1_MAT+DTOS(Z1_DATA)) == cFilSZ1+cMat+Dtos(mv_par02)

     nCC++
     Reclock("CTJ",.T.)
     CTJ->CTJ_FILIAL := xFilial("CTJ") 
     CTJ->CTJ_RATEIO := cMaxRat  
     CTJ->CTJ_SEQUEN := StrZero(nCC,3)
     CTJ->CTJ_DESC   := mv_par04
     CTJ->CTJ_MOEDLC := "01"
     CTJ->CTJ_TPSALD := "1"
     CTJ->CTJ_CCD    := SZ1->Z1_CC
     CTJ->CTJ_PERCEN := Round(SZ1->Z1_PERC * nPercRat * 100,5)
     CTJ->CTJ_ITEMD  := cMat
     CTJ->CTJ_CLVLDB := mv_par05
     CTJ->CTJ_DEBITO := mv_par08
     MsUnlock()
     nSoma += CTJ->CTJ_PERCEN
     nReg1 := CTJ->(Recno())

     nTotPer += Round(CTJ->CTJ_PERCEN,5)

     SZ1->(dbSkip())
  Enddo      

  If nReg1 > 0
     AcertaTotal(nReg1,nPercRat * 100,nSoma)
  Endif

Return nReg1

///////////////////////////
Static function CheckAcols(nTotal)
  Local lret:= .t.
  Local i
  nTotal:= 0	 
  For i:=1 To Len(aCols)
     If !aCols[i,4] //- Verificando se esta deletado
        nTotal += aCols[i,3]
	 Endif
  Next     
  If nTotal > mv_par01                                   
     MsgStop("O valor distribuido é superior ao valor da despesa!!!")
     lret:= .f.
  Else   
     nValRest:= mv_par01 - nTotal
  Endif   
  oTotal:Refresh()
  oValRest:Refresh()

Return(lret)

//////////////////////////////
Static function Marcar(cAlias,cMarca,nMarca)
  RecLock(cAlias,.F.)
  (cAlias)->CTD_OK := If( Empty(CTD_OK), cMarca, Space(Len(CTD_OK)))
  MsUnLock()
  If Empty((cAlias)->CTD_OK)
     nMarca--
  Else
     nMarca++
  Endif      
  nMarca = If( nMarca < 0, 0, nMarca)
  oMarca:Refresh()  
Return

/////////////////////////////
Static Function UltimoRateio
  Local cQry, cMaxRat
  Local cAlias := Alias()

  //- Verificando a ultima sequencia do rateio gravada
  cQry := "SELECT MAX(CTJ_RATEIO) CTJ_RATEIO FROM "+RetSQLName("CTJ")+" WHERE D_E_L_E_T_<>'*' AND "
  cQry += "CTJ_FILIAL='" + XFILIAL("CTJ") + "'"
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "YYY", .T., .F. )
  
  cMaxRat := PADR(StrZero(Val(CTJ_RATEIO)+1,4),Len(CTJ->CTJ_RATEIO))
  
  dbCloseArea()
  dbSelectArea(cAlias)

Return cMaxRat 

Static Function AcertaTotal(nReg,nTotal,nSoma)

  If nReg > 0
     DbSelectArea("CTJ")
     dbGoTo(nReg)
     nTotPer -= CTJ->CTJ_PERCEN
     RecLock("CTJ",.F.)
     CTJ->CTJ_PERCEN += nTotal - nSoma
     MsUnLock()
     nTotPer += CTJ->CTJ_PERCEN
  Endif

Return

/////////////////////////////////
Static function ValidPerg(cPerg)
   Local i, j, aRegs, _sAlias := Alias()

   aRegs := {}
   
   dbSelectArea("SX1")
   dbSetOrder(1)

   AADD(aRegs,{cPerg,"01","Valor a ratear     ?","","","mv_ch1","N",14,2,0,"G","","mv_par01","","","","",;
               "","","","","","","","","","","","","","","","","","","","","   "})
   AADD(aRegs,{cPerg,"02","Data SIATA         ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","",;
               "","","","","","","","","","","","","","","","","","","","","   "})                        
   AADD(aRegs,{cPerg,"03","Rateio igual       ?","","","mv_ch3","N",01,0,0,"C","","mv_par03",;
               "Sim","","Yes","","","Nao","","No","","","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"04","Descricao do rateio?","","","mv_ch4","C",40,0,0,"G","","mv_par04"})
   AADD(aRegs,{cPerg,"05","Classe MCT         ?","","","mv_ch5","C",09,0,0,"G","","mv_par05",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CTH"})

   AADD(aRegs,{cPerg,"06","Departamento       ?","","","mv_ch6","C",01,0,0,"C","","mv_par06",;
               "Administracao","","Administration","","","Projeto","","Project","","","Todos","","All","","","","","","","","","","","",""})

   AADD(aRegs,{cPerg,"07","Funcao             ?","","","mv_ch7","C",01,0,0,"C","","mv_par07",;
               "Colaborador","","Colaborador","","","Estagiario","","Estagiario","","","Todos","","All","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"08","Conta Contabil     ?","","","mv_ch8","C",20,0,0,"G","","mv_par08",;
               "","","","","","","","","","","","","","","","","","","","","","","","","CT1"})

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
