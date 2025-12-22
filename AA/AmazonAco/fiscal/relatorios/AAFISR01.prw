#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  27/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AAFISR01()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de N.F. de Saída"
Local cPict          := ""
Local titulo       := "Relatorio de N.F. de Saída"
Local nLin         := 80
//                                1         1         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
//                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       :=  "Codigo/Cliente                                        Nota Fiscal     Serie     CFOP      Emissao      Valor Contabil    Base Calculo   Aliq.      Valor Icms          Isento          Outros      Rest. Icms      Sub. Trib."
Local Cabec2       := ""
   
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "AAFISR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := Padr("AAFISR01",Len(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "AAFIR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF3"

dbSelectArea("SF3")
dbSetOrder(1)

CreatePerg(cPerg)
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  25/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aresult := ProcRegs()

cString := aresult[01]
dbSelectArea(cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(aresult[02])


(cString)->(dbGoTop())
aTotais := {0,0,0,0,0,0,0,0}
aRest   := {}
While !(cString)->(EOF())

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
   
  //                                1         1         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
  //                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//Local Cabec1       := " Codigo/Cliente                                    Nota Fiscal       Serie      CFOP   Emissao         Valor Contabil       Base Calculo        Aliq.     Valor Icms       Isento     Outros       Rest. Icms      Sub. Trib."

   @nLin,000 + 00 PSAY (cString)->(F3_CLIEFOR + '/' + F3_LOJA) +' '+Posicione("SA1",1,xFilial('SA1')+(cString)->(F3_CLIEFOR + F3_LOJA),"A1_NOME")   
   @nLin,054 + 00 PSAY (cString)->F3_NFISCAL
   @nLin,070 + 00 PSAY (cString)->F3_SERIE
   @nLin,080 + 00 PSAY (cString)->F3_CFO
   @nLin,090 + 00 PSAY DTOC((cString)->F3_ENTRADA)
   @nLin,102 + 00 PSAY Transform( (cString)->F3_VALCONT,"@E 999,999,999.99")
   @nLin,118 + 00 PSAY Transform( (cString)->F3_BASEICM,"@E 999,999,999.99")
   @nLin,134 + 00 PSAY Transform( (cString)->F3_ALIQICM,"@E 999.99") 
   @nLin,142 + 00 PSAY Transform( (cString)->F3_VALICM ,"@E 999,999,999.99")
   @nLin,158 + 00 PSAY Transform( (cString)->F3_ISENICM,"@E 999,999,999.99")
   @nLin,174 + 00 PSAY Transform( (cString)->F3_OUTRICM,"@E 999,999,999.99")
   @nLin,190 + 00 PSAY Transform( (cString)->F3_XPERRES,"@E 999,999,999.99")   
   @nLin,206 + 00 PSAY Transform( (cString)->F3_ICMSRET,"@E 999,999,999.99")
   
   /*
   @nLin,pCol() + 02 PSAY (cString)->F3_NFISCAL
   @nLin,pCol() + 08 PSAY (cString)->F3_SERIE
   @nLin,pCol() + 08 PSAY (cString)->F3_CFO
   @nLin,pCol() + 01 PSAY DTOC((cString)->F3_ENTRADA)
   @nLin,pCol() + 01 PSAY Transform( (cString)->F3_VALCONT,PesqPict("SF3","F3_VALCONT",18,2))
   @nLin,pCol() + 02 PSAY Transform( (cString)->F3_BASEICM,"@E 999,999.99") 
   @nLin,pCol() - 01 PSAY Transform( (cString)->F3_ALIQICM,"@E 999.99") 
   @nLin,pCol() - 02 PSAY Transform( (cString)->F3_VALICM ,"@E 999,999,999.99")
   @nLin,pCol() - 03 PSAY Transform( (cString)->F3_ISENICM,"@E 999,999,999.99")
   @nLin,pCol() + 00 PSAY Transform( (cString)->F3_OUTRICM,"@E 999,999,999.99")
   @nLin,pCol() + 00 PSAY Transform( (cString)->F3_XPERRES,"@E 999,999,999.99")
   
   @nLin,pCol() + 05 PSAY Transform( (cString)->F3_ICMSRET,PesqPict("SF3","F3_ICMSRET",18,2))
   */
   nLin := nLin + 1 // Avanca a linha de impressao
   
   aTotais[01] += (cString)->F3_VALCONT
   aTotais[02] += (cString)->F3_BASEICM
   aTotais[03] += (cString)->F3_ALIQICM
   aTotais[04] += (cString)->F3_VALICM 
   aTotais[05] += (cString)->F3_OUTRICM
   aTotais[06] += (cString)->F3_XPERRES
   aTotais[07] += (cString)->F3_ICMSRET
   aTotais[08] += (cString)->F3_ISENICM
   
   If Len(aRest) != 0
       nPos := aScan(aRest,{|x| x[01] == Alltrim(Str((cString)->F3_XPERRES))})
	   if nPos > 0
	      aRest[nPos][02] += (cString)->F3_VALICM
	   else
	      aAdd(aRest,{Alltrim(Str((cString)->F3_XPERRES)),(cString)->F3_VALICM})
	   EndIf
   else
      aAdd(aRest,{Alltrim(Str((cString)->F3_XPERRES)),(cString)->F3_VALICM})
   EndIf
   (cString)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//   @nLin,000 PSAY (cString)->(F3_CLIEFOR + '/' + F3_LOJA) +' '+Posicione("SA1",1,xFilial('SA1')+(cString)->(F3_CLIEFOR + F3_LOJA),"A1_NOME")
//   @nLin,032 + 20 PSAY (cString)->F3_NFISCAL
//   @nLin,050 + 20 PSAY (cString)->F3_SERIE
   @ nLin,000 PSAY __PrtThinLine()
     nLin++
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
   Endif
   
   @nLin,060 + 20 PSAY "Totais --->>"

   @nLin,102 + 00 PSAY Transform( aTotais[1],"@E 999,999,999.99")
   @nLin,118 + 00 PSAY Transform( aTotais[2],"@E 999,999,999.99")
   @nLin,142 + 00 PSAY Transform( aTotais[4],"@E 999,999,999.99")
   @nLin,158 + 00 PSAY Transform( aTotais[8],"@E 999,999,999.99")
   @nLin,174 + 00 PSAY Transform( aTotais[5],"@E 999,999,999.99")
   @nLin,206 + 00 PSAY Transform( aTotais[7],"@E 999,999,999.99")


/*   @nLin,071 + 17 PSAY DTOC((cString)->F3_ENTRADA)
   @nLin,085 + 12 PSAY Transform( aTotais[01],PesqPict("SF3","F3_VALCONT",18,2))
   @nLin,106 + 11 PSAY Transform( aTotais[02],PesqPict("SF3","F3_BASEICM",18,2))
   @nLin,153 + 06 PSAY Transform( aTotais[08],PesqPict("SF3","F3_ISENICM",18,2))
//   @nLin,125 + 07 PSAY Transform( aTotais[03],PesqPict("SF3","F3_ALIQICM",18,2))
   @nLin,138 + 09 PSAY Transform( aTotais[04],PesqPict("SF3","F3_VALICM ",18,2))
   @nLin,170 + 00 PSAY Transform( aTotais[05],PesqPict("SF3","F3_OUTRICM",18,2))
//   @nLin,165 + 10 PSAY Transform( aTotais[06],PesqPict("SF3","F3_XPERRES",18,2))
   @nLin,200 + 00 PSAY Transform( aTotais[07],PesqPict("SF3","F3_ICMSRET",18,2))
  */
    nLin++
   @ nLin,000 PSAY __PrtThinLine()
   nLin += 5
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
   Endif
   
   For nI := 1 To Len(aRest)
    If nI == 1
       @ nLin,000 PSAY __PrtThinLine()
         nLin++
       @nLin,080  PSAY "Resumo Restituição ICMS:"
         nLin++
       
       If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
       Endif
       
       
    EndIf
       @nLin,080 PSAY aRest[nI,01]
       @nLin,148 PSAY Transform(aRest[nI,02],"@E 999,999,999.999")
        nLin++
   Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
Static Function CreatePerg(cPerg)
  Local aTam := {}
  
  aAdd(aTam,{TAMSX3('F3_ENTRADA')[01],TAMSX3('F3_ENTRADA')[02]})
  aAdd(aTam,{TAMSX3('F3_NFISCAL')[01],TAMSX3('F3_NFISCAL')[02]})
  aAdd(aTam,{TAMSX3('F3_CLIEFOR')[01],TAMSX3('F3_CLIEFOR')[02]})
  aAdd(aTam,{99,00})
  aAdd(aTam,{99,00})
  aAdd(aTam,{99,00})
  
  PutSX1(cPerg,"01",PADR("Data de    ?",16),"","","mv_ch1","D",aTam[01][01],aTam[01][02],0,"G","","   ","","","mv_par01")
  PutSX1(cPerg,"02",PADR("Data Ate   ?",16),"","","mv_ch2","D",aTam[01][01],aTam[01][02],0,"G","","   ","","","mv_par02")
  
  PutSX1(cPerg,"03",PADR("Nota de    ?",16),"","","mv_ch3","C",aTam[02][01],aTam[02][02],0,"G","","SF3","","","mv_par03")
  PutSX1(cPerg,"04",PADR("Nota Ate   ?",16),"","","mv_ch4","C",aTam[02][01],aTam[02][02],0,"G","","SF3","","","mv_par04")
  
  PutSX1(cPerg,"05",PADR("Cliente de ?",16),"","","mv_ch5","C",aTam[03][01],aTam[03][02],0,"G","","SA1","","","mv_par05")
  PutSX1(cPerg,"06",PADR("Cliente Ate?",16),"","","mv_ch6","C",aTam[03][01],aTam[03][02],0,"G","","SA1","","","mv_par06")
  
  PutSX1(cPerg,"07",PADR("CFOP's     ?",16),"","","mv_ch7","C",aTam[04][01],aTam[04][02],0,"G","","   ","","","mv_par07")
  
  PutSX1(cPerg,"08",PADR("Aliquota   ?",16),"","","mv_ch8","C",aTam[05][01],aTam[05][02],0,"G","","   ","","","mv_par08")
  
  PutSX1(cPerg,"09",PADR("Per. Rest. ?",16),"","","mv_ch9","C",aTam[06][01],aTam[06][02],0,"G","","   ","","","mv_par09")
  
Return Nil

Static Function ProcRegs()
   Local cTable := GetNextAlias()
   Local nRegs  := 0
   
   Local cQry   := ""
   
   cQry += " Select Count(*) CONT From " + RetSQlName("SF3") + " SF3 "   
   cQry += " Where D_E_L_E_T_ = ''
   cQry += " And F3_FILIAL = '" + SF3->(xFilial('SF3')) + "'
   //cQry += " And F3_XPERRES != 0
   cQry += " And F3_DTCANC  = ''
   cQry += " And F3_CFO >= '5000'
   cQry += " And F3_NFISCAL BetWeen '" + mv_par03 + "' And '" + mv_par04 + "' "
   cQry += " And F3_ENTRADA BetWeen '" + DTOS(mv_par01) + "' And '" + DTOS(mv_par02) + "' "
   cQry += " And F3_CLIEFOR BetWeen '" + mv_par05 + "' And '" + mv_par06 + "' "
   if !Empty(mv_par07)
      cQry += " And F3_CFO     in ('" + StrTran(mv_par07,",","','") + "')"
   EndIf
   if !Empty(mv_par08)
      cQry += " And F3_ALIQICM in (" + mv_par08 + ") "
   EndIf
   if !Empty(mv_par09)
      cQry += " And F3_XPERRES in (" + mv_par09 + ") "
   EndIf 
   
   dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cTable, .T., .F. )
       nRegs := (cTable)->CONT
   (cTable)->(dbCloseArea(cTable))
   
   cQry := StrTran(cQry,"Count(*) CONT"," * ")
   
   dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cTable, .T., .F. )
   
   TcSetField(cTable,"F3_ENTRADA","D",8,0)
   
Return {cTable,nRegs}

/*powered by DXRCOVRB*/