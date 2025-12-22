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

User Function AALOJR04()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de N.F. de Saída"
Local cPict          := ""
Local titulo       := "Relatorio de Vendas com Reserva"
Local nLin         := 80
//                                1         1         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
//                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       :=  "Orcamento       Cliente                                                                 Cupom     Serie       Valor Liquido       Caixa                    Vendedor                    Filial 00     Filial 01     Filial 04"
Local Cabec2       := ""
   
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private Limite     := 220
Private tamanho    := "G"
Private nomeprog   := "AALOJR04" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := Padr("AALOJR01",Len(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "AALOJR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SL1"

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
Local aResult := ProcRegs()

cString := aResult[01]
dbSelectArea(cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(aResult[02])


(cString)->(dbGoTop())
aTotais := {0,0,0,0,0,0,0,0}
aCaixa  := {}
_nRegTot:= 0
While !(cString)->(EOF())

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
   Endif
   
  //                                1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
  //                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//Local Cabec1       :=  "Orcamento    Cliente                                                                 Cupom     Serie       Valor Liquido       Caixa                    Vendedor                 Filial 00       Filial 01      Filial 04"
   
     @nLin,000 + 00 PSAY (cString)->L1_NUM
     @nLin,014 + 00 PSAY (cString)->( L1_CLIENTE + '-' + L1_LOJA + ' / ' + L1_NOMCLI)
     @nLin,088 + 00 PSAY (cString)->L1_DOCPED
     @nLin,098 + 00 PSAY (cString)->L1_SERPED
     @nLin,106 + 00 PSAY Transform((cString)->L1_VLRLIQ,"@E 999,999,999.99")
     @nLin,130 + 00 PSAY PadR( (cString)->A6_NOME,30)
     @nLin,152 + 00 PSAY PadR( (cString)->A3_NOME,30)
     @nLin,186 + 00 PSAY (cString)->LOJA00
     @nLin,199 + 00 PSAY (cString)->LOJA01
     @nLin,212 + 00 PSAY (cString)->LOJA04

     _nRegTot++
     nLin++
     nPos := aScan(aCaixa,{|x|  Alltrim(x[01]) == Alltrim((cString)->A6_NOME)  })
    If nPos != 0
       acaixa[nPos][02]++ 
    else
       aAdd(aCaixa,{(cString)->A6_NOME,1})
    EndIf
         (cString)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  //nLin := nLin + 1 // Avanca a linha de impressao

EndDo

  nLin++
@ nLin,000 PSAY __PrtThinLine()
  nLin++
     
 If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
 Endif
 
 For _nK := 1 to Len(aCaixa)
    @nLin,170 + 00 PSAY "Total Vendas (" + Alltrim(aCaixa[_nK][01]) + "): " + Transform(aCaixa[_nK][02],"@E 999,999,999")
    nLin++
 Next
 @nLin,170 + 00 PSAY "Total Vendas : " + Transform(_nRegTot,"@E 999,999,999")
   
   
   nLin += 5
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
   Endif

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
  
  aAdd(aTam,{TAMSX3('L1_EMISSAO')[01],TAMSX3('L1_EMISSAO')[02]})
  aAdd(aTam,{TAMSX3('L1_NUM')[01],TAMSX3('L1_NUM')[02]})
  
  PutSX1(cPerg,"01",PADR("Data de    ?",16),"","","mv_ch1","D",aTam[01][01],aTam[01][02],0,"G","","   ","","","mv_par01")
  PutSX1(cPerg,"02",PADR("Data Ate   ?",16),"","","mv_ch2","D",aTam[01][01],aTam[01][02],0,"G","","   ","","","mv_par02")
  
  PutSX1(cPerg,"03",PADR("Orcamento de ?",16) ,"","","mv_ch3","C",aTam[02][01],aTam[02][02],0,"G","","SF3","","","mv_par03")
  PutSX1(cPerg,"04",PADR("Orcamento Ate ?",16),"","","mv_ch4","C",aTam[02][01],aTam[02][02],0,"G","","SF3","","","mv_par04")
  
/*  
  PutSX1(cPerg,"05",PADR("Cliente de ?",16),"","","mv_ch5","C",aTam[03][01],aTam[03][02],0,"G","","SA1","","","mv_par05")
  PutSX1(cPerg,"06",PADR("Cliente Ate?",16),"","","mv_ch6","C",aTam[03][01],aTam[03][02],0,"G","","SA1","","","mv_par06")
  
  PutSX1(cPerg,"07",PADR("CFOP's     ?",16),"","","mv_ch7","C",aTam[04][01],aTam[04][02],0,"G","","   ","","","mv_par07")
  
  PutSX1(cPerg,"08",PADR("Aliquota   ?",16),"","","mv_ch8","C",aTam[05][01],aTam[05][02],0,"G","","   ","","","mv_par08")
  
  PutSX1(cPerg,"09",PADR("Per. Rest. ?",16),"","","mv_ch9","C",aTam[06][01],aTam[06][02],0,"G","","   ","","","mv_par09")
*/
Return Nil

Static Function ProcRegs()
   Local cTable := GetNextAlias()
   Local nRegs  := 0
   
   Local cQry   := ""
   Local cCampos:= "L1_NUM,L1_CLIENTE,L1_LOJA,L1_NOMCLI,L1_SERPED,L1_DOCPED,L1_VLRLIQ,A3_NOME,A6_NOME,isNull([00],'N/A') LOJA00,isNull([01],'N/A') LOJA01 ,isNull([04],'N/A') LOJA04 "
   
  cQry += " Select Count(*) IT_CONT  from (
  cQry += " Select distinct A.*,C5_NUM,C5_FILIAL,A3_NOME,A6_NOME From SL1010 A
  cQry += "   LEft Outer Join SC5010 B on B.D_E_L_E_T_ = '' ANd L1_NUM = C5_XORCRES ANd L1_FILIAL = C5_XFILRES
  cQry += "   Left Outer Join SA3010 C ON C.D_E_L_E_T_ = '' And L1_VEND = A3_COD 
  cQry += "   Left Outer Join SA6010 D on D.D_E_L_E_T_ = '' And L1_OPERADO = A6_COD
  cQry += " Where A.D_E_L_E_T_ = ''
  cQry += " And L1_ENTREGA = 'S'  
  cQry += " And L1_EMISSAO BetWeen '" + DTOS(mv_par01) + "' And '" + DTOS(mv_par02) + "'"
  cQry += " And L1_NUM  BetWeen '" + mv_par03 + "' And '" + mv_par04 + "'"
  cQry += " And C5_NUM is not Null

  cQry += " )P
  cQry += " Pivot  ( MAX(C5_NUM) for C5_FILIAL in ([00],[01],[04]) )  AS pvt   
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cTable, .T., .F. )
     nRegs := (cTable)->IT_CONT
  (cTable)->(dbCloseArea(cTable))
   
  cQry := StrTran(cQry,"Count(*) IT_CONT",cCampos)
  cQry += " order by L1_NUM 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cTable, .T., .F. )
   
Return {cTable,nRegs}





/*powered by DXRCOVRB*/