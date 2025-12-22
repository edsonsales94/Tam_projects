#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de conferencia de rateios externos               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINR21

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Conferencia de Rateios Externos"
Local titulo     := "Conferencia de Rateios Externos"
Local nLin       := 80
Local Cabec1     := "Colaborador                           Centro de Custo                                   Classe MCT                   Percent.  Filial"
Local Cabec2     := ""
Local aOrd       := {}
Local cPerg      := PADR("INFINR21",Len(SX1->X1_GRUPO))

Private limite   := 132
Private tamanho  := "M"
Private nomeprog := "INFINR21"
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private m_pag    := 01
Private wnrel    := "INFINR21"
Private cString  := "CTJ"

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

   // mv_par01 - Do Rateio           
   // mv_par02 - Ate o Rateio        
   // mv_par03 - Do Centro Custo     
   // mv_par04 - Ate o Centro Custo  
   // mv_par05 - Da Classe MCT       
   // mv_par06 - Ate a Classe MCT    
   // mv_par07 - Do Colaborador
   // mv_par08 - Ate o Colaborador
   // mv_par09 - Cons. Filiais abaix 
   // mv_par10 - Da Filial           
   // mv_par11 - Ate a Filial        

   cQuery := "SELECT COUNT(*) SOMA FROM "+RetSqlName("CTJ")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQuery += "CTJ_RATEIO >= '"+mv_par01+"' AND CTJ_RATEIO <= '"+mv_par02+"' AND  "
   cQuery += "CTJ_CCD >= '"+mv_par03+"' AND CTJ_CCD <= '"+mv_par04+"' AND "
   cQuery += "CTJ_CLVLDB >= '"+mv_par05+"' AND CTJ_CLVLDB <= '"+mv_par06+"' AND "
   cQuery += "CTJ_ITEMD >= '"+mv_par07+"' AND CTJ_ITEMD <= '"+mv_par08+"' AND "   

   If mv_par09 == 1    // Considera Filial ==  1-Sim  2-Nao
      cQuery += "CTJ_FILIAL >= '"+mv_par10+"' AND CTJ_FILIAL <= '"+mv_par11+"'"
   Else
      cQuery += "CTJ_FILIAL = '"+xFilial("CTJ")+"'"
   Endif
   
   //- Conta o numero de registros filtrados pela query 
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "SOM", .T., .F. )
   nRegis:= SOMA
   dbCloseArea()

   //- Troca a expressao COUNT(*) por * na clausula SELECT
   cQuery:= StrTran(cQuery,"COUNT(*) SOMA","*")
   
   cQuery += "ORDER BY CTJ_DESC"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )

   cInd := CriaTrab(NIL ,.F.)
   cKey := "CTJ_DESC"
   
   IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
   
   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nRegis) },Titulo)

Return

Static function RunReport(Cabec1,Cabec2,Titulo,nLin,nRegis)
   Local cFiltro,cMatFunc,cNomeFunc,cCCusto,cDescCC,cClVl,cDescClVl
   Local cCodRat,cNomeRat,nValRat

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
   
   While !Eof()
         
      If nLin > 60
         nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
      Endif

      cCodRat := CTJ_RATEIO
      cNomeRat:= CTJ_DESC
      
      @ nLin, 000 PSAY cCodRat + " - " + cNomeRat
      nLin+=2
      
      nValRat:= 0
      
      While !Eof() .and. cCodRat == CTJ_RATEIO
      
         If nLin > 60
            nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
            @ nLin, 000 PSAY cCodRat + " - " + cNomeRat
            nLin+=2
         Endif
         cMatFunc:= Trim(CTJ_ITEMD)
         cCCusto := Trim(CTJ_CCD)
         cClVl   := Trim(CTJ_CLVLDB)         
         
         //- Nome do colaborador
         CTD->(dbSetOrder(1))
         CTD->(dbSeek(xFilial("CTD")+TMP->CTJ_ITEMD))
         cNomeFunc := Padr(CTD->CTD_DESC01,30)

         //- Centro de custo
         CTT->(dbSetOrder(1))
         CTT->(dbSeek(xFilial("CTT")+TMP->CTJ_CCD))
         cDescCC := Padr(CTT->CTT_DESC01,36)

         //- Classe de valores
         CTH->(dbSetOrder(1))
         CTH->(dbSeek(xFilial("CTH")+TMP->CTJ_CLVLDB))
         cDescClVl := Padr(CTH->CTH_DESC01,25)

         //COLABORADOR                           CENTRO DE CUSTO                                 CLASSE MCT                     PERCENT.   FIL
         //99999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999-XXXXXXXXXXXXXXXXXXXXXXXXX  999.99999  XXX
         //01234567890123456789012345678901234567890123456789012345678901234567812345678901234567890123456789012345678901234567890123456789012  
         //0         1         2         3         4         5         6         7         8         9        10        11        12        13                                 

         @ nLin, 000 PSAY cMatFunc+"-"
         @ nLin, 006 PSAY cNomeFunc                      
         @ nLin, 038 PSAY cCCusto+"-"
         @ nLin, 048 PSAY cDescCC
         @ nLin, 088 PSAY cClVl+"-"   
         @ nLin, 092 PSAY cDescClVl
         @ nLin, 119 PSAY CTJ_PERCEN Picture "999.99999"
         @ nLin, 130 PSAY U_NomeFilial(CTJ_FILIAL)
         nLin++
         nValRat += CTJ_PERCEN

         dbSkip()
      Enddo   
      @ nLin, 119 PSAY "---------"      
      nLin++
      @ nLin, 119 PSAY nValRat Picture "999.99999"
      nLin +=1                  
   Enddo
   dbCloseArea()

   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
      OurSpool(wnrel)
   Endif
   MS_FLUSH()
Return

Static Function ValidPerg(cPerg)
   u_INPutSX1(cPerg,"01",PADR("Do Rateio                ",29)+"?","","","mv_ch1","C", 6,0,0,"G","","CTJ","","","mv_par01")
   u_INPutSX1(cPerg,"02",PADR("Ate o Rateio             ",29)+"?","","","mv_ch2","C", 6,0,0,"G","","CTJ","","","mv_par02")
   u_INPutSX1(cPerg,"03",PADR("Do Projeto               ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
   u_INPutSX1(cPerg,"04",PADR("Ate o Projeto            ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
   u_INPutSX1(cPerg,"05",PADR("Da Classe MCT            ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTH","","","mv_par05")
   u_INPutSX1(cPerg,"06",PADR("Ate a Classe MCT         ",29)+"?","","","mv_ch6","C", 9,0,0,"G","","CTH","","","mv_par06")
   u_INPutSX1(cPerg,"07",PADR("Do Colaborador           ",29)+"?","","","mv_ch7","C", 9,0,0,"G","","CTD","","","mv_par07")
   u_INPutSX1(cPerg,"08",PADR("Ate o Colaborador        ",29)+"?","","","mv_ch8","C", 9,0,0,"G","","CTD","","","mv_par08")
   u_INPutSX1(cPerg,"09",PADR("Considera Filiais a baixo",29)+"?","","","mv_ch9","N", 1,0,0,"C","","   ","","","mv_par09","Sim","","","","Nao")
   u_INPutSX1(cPerg,"10",PADR("Da Filial                ",29)+"?","","","mv_cha","C", 2,0,0,"G","","   ","","","mv_par10")
   u_INPutSX1(cPerg,"11",PADR("Ate a Filial             ",29)+"?","","","mv_chb","C", 2,0,0,"G","","   ","","","mv_par11")
Return
