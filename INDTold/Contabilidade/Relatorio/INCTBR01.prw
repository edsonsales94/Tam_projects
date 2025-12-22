#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de conferencia do SIATA                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INCTBR01()//INDR070()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Conferencia de Importacao do SIATA"
Local titulo     := "Conferencia de Importacao do SIATA"
Local nLin       := 80
Local Cabec1     := "Data     C. Custo  Projeto                                  Percentual
Local Cabec2     := ""
Local aOrd       := {}
Private limite   := 80
Private tamanho  := "M"
Private nomeprog := "INCTBR01"
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private cPerg    := Padr("INCTBR01",Len(SX1->X1_GRUPO))
Private m_pag    := 01
Private wnrel    := "INCTBR01"
Private cString  := "SZ1"

ValidPerg(cPerg)
pergunte(cPerg,.F.)
      
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo:= If(aReturn[4]==1,15,18)

Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin) }, "Filtrando dados")
Return

Static function ExecProc(Cabec1,Cabec2,Titulo,nLin)
   
   Local cInd, cKey, cQuery, nRegis

   cQuery := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SZ1")+" WHERE D_E_L_E_T_ <> '*'"
   cQuery += " AND Z1_DATA = '"+dtos(mv_par01)+"'"
   cQuery += " AND Z1_CC >= '"+mv_par03+"' AND Z1_CC <= '"+mv_par04+"'
   cQuery += " AND Z1_MAT >= '"+mv_par05+"' AND Z1_MAT <= '"+mv_par06+"'

   If mv_par02 < 3
      cQuery += " AND Z1_FUNCAO = '"+str(mv_par02,1)+"'"
   Endif   
   
   //- Conta o numero de registros filtrados pela query 
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "SOM", .T., .F. )
   nRegis:= SOMA
   dbCloseArea()

   //- Troca a expressao COUNT(*) por * na clausula SELECT
   //cQuery:= StrTran(cQuery,"COUNT(*) SOMA","*")
   cQuery := "SELECT * FROM "+RetSqlName("SZ1")+" WHERE D_E_L_E_T_ <> '*'"
   cQuery += " AND Z1_DATA = '"+dtos(mv_par01)+"'"
   cQuery += " AND Z1_CC >= '"+mv_par03+"' AND Z1_CC <= '"+mv_par04+"'
   cQuery += " AND Z1_MAT >= '"+mv_par05+"' AND Z1_MAT <= '"+mv_par06+"'
   
   If mv_par02 < 3
      cQuery += " AND Z1_FUNCAO = '"+str(mv_par02,1)+"' "
   Endif   
   
   cQuery += " ORDER BY Z1_MAT"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )

   cInd := CriaTrab(NIL ,.F.)
   cKey := "Z1_MAT"
   
   IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
   
   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nRegis) },Titulo)

Return

Static function RunReport(Cabec1,Cabec2,Titulo,nLin,nRegis)
   Local nPerc, nTotal, cFiltro, cProjeto, cNome, nConta, cData
   
   dbSelectArea("TMP")
   dbgotop()
   
   //- Ativando a rotina de filtro
   If !Empty(aReturn[7])
      cFiltro:= Alltrim(aReturn[7])
      dbGoTop()
      SetRegua(RecCount())              
      While !Eof()
         IncRegua()
         If &(cFiltro)
         Else
            Reclock("TMP",.f.)
            dbDelete()
            dbUnLock()
         Endif 
         dbskip()  
      Enddo   
   Endif   
   dbGoTop()
   
   SetRegua(nRegis)

   dbGoTop()

   nConta:= 0
   
   While !Eof()
         
      If nLin > 60
         nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
      Endif
                         
      cNome:= ""
   /*   
      //- Cadastro de funcionarios
      dbSelectArea("SRA")
      dbSetOrder(13)
      If !dbSeek(TMP->Z1_MAT)*/
         //- Cadastro de item contabil
         dbSelectArea("CTD")
         dbSetOrder(1)
         dbSeek(xFilial("CTD")+TMP->Z1_MAT)
         cNome:= CTD->CTD_DESC01
     /* Else
         cNome:= SRA->RA_NOME 
      Endif   */
                      
      dbSelectArea("TMP")

      cMat  := Z1_MAT
      nTotal:= 0.00
      nConta++
      
      @ nLin, 000 PSAY cMat + " - "
      @ nLin, 015 PSAY cNome
      nLin+=2

      While !Eof() .and. Z1_MAT == cMat
      
         IncRegua()
      
         //- Centro de custo
         dbSelectArea("CTT")
         dbSetOrder(1)
         dbSeek(XFILIAL("CTT")+TMP->Z1_CC)
         cProjeto:= Padr(CTT->CTT_DESC01,40)
         
         dbSelectArea("TMP")

         nPerc:= Round(Z1_PERC*100,2)                  
         nTotal += nPerc
         cData:= Substr(Z1_DATA,7,2)+"/"+Substr(Z1_DATA,5,2)+"/"+Substr(Z1_DATA,3,2)
         
         @ nLin, 000 PSAY cData
         @ nLin, 009 PSAY Z1_CC
         @ nLin, 019 PSAY cProjeto
         @ nLin, 062 PSAY nPerc Picture "999.99"
         nLin++                  
         DbSkip()
      Enddo                               
      @ nLin, 062 PSAY "------"      
      nLin++
      @ nLin, 062 PSAY nTotal Picture "999.99"
      nLin +=1                  
   Enddo
   @ nLin, 000 PSAY "TOTAL DE COLABORADORES "
   @ nLin, 025 PSAY nConta Picture "999999"
  
   dbCloseArea()

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

   AADD(aRegs,{cPerg,"01","Data de referencia do SIATA  ?","Data de referencia do SIATA  ?","Data de referencia do SIATA  ?","mv_ch1","D",08,0,0,"G","","mv_par01"})

   AADD(aRegs,{cPerg,"02","Funcao             ?","Funcao             ?","Funcao             ?","mv_ch2","C",01,0,0,"C","","mv_par02",;
               "Colaborador","","Colaborador","","","Estagiario","","Estagiario","","","Todos","","All","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"03","Do Centro de Custo","Do Centro de Custo","Do Centro de Custo","mv_ch3","C",09,0,0,"G","","mv_par03"})
   AADD(aRegs,{cPerg,"04","Ate o Centro de Custo","Ate o Centro de Custo","Ate o Centro de Custo","mv_ch4","C",09,0,0,"G","","mv_par04"})

   AADD(aRegs,{cPerg,"05","Do Funcionario","Do Funcionario","Do Funcionario","mv_ch5","C",06,0,0,"G","","mv_par05"})
   AADD(aRegs,{cPerg,"06","Ate o Funcionario","Ate o Funcionario","Ate o Funcionario","mv_ch6","C",06,0,0,"G","","mv_par06"})

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