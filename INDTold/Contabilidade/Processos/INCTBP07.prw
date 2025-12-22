#Include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INDA010  ³ Autor ³ Ronilton O. Barros    ³ Data ³ 03.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de importacao da tabela de locacao de funcionarios  ³±±
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
//³ mv_par01         Arquivo ?                    ³
//³ mv_par02         Sobrepoe?  Sim Nao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function INCTBP07() //INDA010()
   Local cPerg, cCadastro, aSays, aButtons, nOpca
   Local c 
   cPerg := Padr("IND010",Len(SX1->X1_GRUPO))
   ValidPerg(cPerg)
   Pergunte(cPerg,.F.)

   cCadastro := OemtoAnsi("Importacao Horas x Projeto x Funcionario")
   aSays     := {}
   aButtons  := {}
   nOpca     := 0

   AADD(aSays,OemToAnsi("Esta rotina ira importar os registros referente a alocacao do funcionario") )
   AADD(aSays,OemToAnsi("num determinado projeto, essas informacoes serao armazenadas  no  sistema") )
   AADD(aSays,OemToAnsi("para efeito de consulta.                                                 ") )

   AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
   AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
   AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

   FormBatch( cCadastro, aSays, aButtons )

   If nOpca == 1
      Processa({|| Importar() },"Importacao de tabela")
   EndIf

Return

Static Function Importar()
   Local dDtPer, cCC, cItem, lFica, aFile, x, cTpCampo, cIdx, cKey, cArq, cMat, nTotal, cInd
   Local c 
   mv_par01 := AllTrim(mv_par01)+".DBF"
   If !File(mv_par01)
      Alert("Arquivo de importacao nao existe !")
      Return
   Endif

   /* Cria estrutura da tabela SZ1 para gravar nessa tabela temporaria antes de gravar na oficial */
   aFile := SZ1->(dbStruct())
   cArq  := CriaTrab(aFile,.T.)
   Use &cArq Alias TRB New Exclusive
   cIdx  := CriaTrab( Nil ,.F.)
   cKey  := SZ1->( Indexkey(1) )

   IndRegua("TRB",cIdx,cKey,,, "Selecionando Registros...")

   /* Cria estrutura padrao do arquivo de importacao */
   aFile := {}
   AAdd( aFile , { "MATRICULA" , "N", 20, 5} )
   AAdd( aFile , { "CCUSTO"    , "C", 50, 0} )
   AAdd( aFile , { "MES"       , "D", 08, 0} )
   AAdd( aFile , { "HORAS"     , "N", 20, 5} )
   AAdd( aFile , { "ALOCACAOPL", "N", 20, 5} )

   /* Analisa se o arquivo informado eh igual ao padrao */
   Use &mv_par01 Alias IMP New Exclusive
   For x:=1 To Len(aFile)
      If FieldPos(aFile[x,1]) > 0
         cTpCampo := ValType(IMP->(FieldGet(FieldPos(aFile[x,1]))))
         If cTpCampo <> aFile[x,2]
            Alert("O campo "+aFile[x,1]+" contem tipo invalido ! ("+cTpCampo+"->"+aFile[x,2]+")")
            dbCloseArea()
            Return
         Endif
      Else
         Alert("O campo "+aFile[x,1]+" nao existe no arquivo de importacao !")
         dbCloseArea()
         Return
      Endif
   Next

   cInd := CriaTrab( NIL , .F. )
   IndRegua("IMP",cInd,"Dtos(MES)+CCUSTO+Str(MATRICULA,20,5)",,, "Selecionando Registros...")

   dbSelectArea("IMP")
   dbGoBottom()
   dDtPer := MES
   dbGoTop()
   If dDtPer <> MES
      Alert("Existe mais de um periodo informado no arquivo de importacao !")
      Fechar()
      Return
   Endif

   /* Grava arquivo temporario para verificar integridade de alocacao */
   dbSelectArea("IMP")
   ProcRegua(RecCount())
   While !Eof()

      IncProc("Copiando Importacao...")

      cCC := Modela(IMP->CCUSTO,9)
      dbSelectArea("CTT")
      dbSetOrder(1)
      If dbSeek(XFILIAL("CTT")+cCC)
         cItem := Modela(StrZero(IMP->MATRICULA,5),6)
         dbSelectArea("CTD")
         dbSetOrder(1)
         If dbSeek(XFILIAL("CTD")+cItem)
            dbSelectArea("SZ1")
            dbSetOrder(1)
            If ! dbSeek(XFILIAL("SZ1")+Dtos(IMP->MES)+cCC+cItem)  // Verifica se nao existe na tabela oficial
               dbSelectArea("TRB")
               If ! dbSeek(XFILIAL("SZ1")+Dtos(IMP->MES)+cCC+cItem)  // Verifica se nao existe na tabela tempor.
                  RecLock("TRB",.T.)
                  TRB->Z1_FILIAL := XFILIAL("SZ1")
                  TRB->Z1_DATA   := IMP->MES
                  TRB->Z1_CC     := cCC
                  TRB->Z1_MAT    := cItem
                  TRB->Z1_HORAS  := IMP->HORAS
                  TRB->Z1_PERC   := IMP->ALOCACAOPL
                  TRB->Z1_FUNCAO := If( SubStr(cItem,1,1) == "8" , "2", "1")
                  MsUnLock()
               Endif
            Endif
         Endif
      Endif
      dbSelectArea("IMP")

      dbSkip()
   Enddo
   dbCloseArea()
   FErase(cInd+".IDX")

   /* Cria novo indice para verificar se o total de percentuais do colaborador eh igual a 100% */
   lFica  := .T.
   dbSelectArea("TRB")
   dbClearIndex()
   FErase(cIdx+".IDX")
   cIdx := CriaTrab( NIL , .F. )
   IndRegua("TRB",cIdx,"Z1_MAT+DTOS(Z1_DATA)",,, "Selecionando Registros...")
   dbGoTop()
   ProcRegua(RecCount())
   While !Eof()
      nTotal := 0
      cMat   := Z1_MAT
      While !Eof() .And. cMat == Z1_MAT .And. nTotal <= 1

         IncProc("Verificando Integridade...")

         nTotal += Z1_PERC

         dbSkip()
      Enddo

      If nTotal <> 1
         Alert("O Colaborador "+cMat+If(nTotal<1," nao tem"," ultrapassou")+" 100% de alocacao !")
         Fechar(cIdx)
         Return
      Endif

   Enddo

   dbSelectArea("SZ1")
   dbSetOrder(1)
   If dbSeek(XFILIAL("SZ1")+SubStr(Dtos(dDtPer),1,6))
      If lFica := (mv_par02 == 1)  // Se optou por sobrepor
         //If lFica := Empty(Z1_STATUS)
            //If lFica := (MsgYesNo("O sistema ira sobrepor as informacoes, Confirma ?",OemToAnsi("ATENCAO")))
               While !Eof() .And. XFILIAL("SZ1")+SubStr(Dtos(dDtPer),1,6) == Z1_FILIAL+SubStr(Dtos(Z1_DATA),1,6)
                  IncProc("Filtrando registros...")
                  RecLock("SZ1",.F.)
                  dbDelete()
                  MsUnLock()
                  dbSkip()
               Enddo
            //Endif
         ////Else
         //   Alert("Esse periodo ja foi atualizado, nao pode sobrepor !")
         //Endif
      Else
         Alert("Ja existe importacao efetuada para esse periodo !")
      Endif
   Endif

   If !lFica
      Fechar(cIdx)
      Return
   Endif

   Begin Transaction
   dbSelectArea("TRB")
   dbGoTop()
   ProcRegua(RecCount())
   While !Eof()

      IncProc("Gravando Importacao...")

      dbSelectArea("SZ1")
      dbSetOrder(1)
      If ! dbSeek(TRB->(Z1_FILIAL+Dtos(Z1_DATA)+Z1_CC+Z1_MAT))
         RecLock("SZ1",.T.)
         For c:=1 To FCount()
            FieldPut( c , TRB->(FieldGet(c)) )
         Next
         MsUnLock()
      Endif
      dbSelectArea("TRB")

      dbSkip()
   Enddo
   End Transaction

   Fechar(cIdx)
Return

Static Function Fechar(cIdx)
   dbSelectArea("TRB")
   dbCloseArea()
   FErase(cIdx+".IDX")
Return

Static Function Modela(cVar,nTam)
   Local cRet

   cRet := AllTrim(cVar)
   cRet := SubStr(cVar,1,nTam)
   cRet += Space(nTam-Len(cRet))

Return(cRet)

Static Function ValidPerg(cPerg)
   Local i, j, aRegs, _sAlias := Alias()
   
   aRegs := {}
   dbSelectArea("SX1")
   dbSetOrder(1)

   //AADD(aRegs,{cPerg,"01","Produto Antigo     ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","",;
   //            "","","","","","","","","","","","","","","","","","","","","SB1"})
   //AADD(aRegs,{cPerg,"02","Produto Novo       ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","",;
   //            "","","","","","","","","","","","","","","","","","","","","SB1"})
   AADD(aRegs,{cPerg,"01","Arquivo de Importac?","","Import File        ?","mv_ch1","C",30,0,0,"G","","mv_par01"})
   AADD(aRegs,{cPerg,"02","Subescrever Import.?","","Rewrite File       ?","mv_ch2","N",01,0,0,"C","","mv_par02",;
   "Sim","","Yes","","","Nao","","No","","","","","","","","","","","","","","","","",""})
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
