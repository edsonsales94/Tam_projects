#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  15/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function INDFOL


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Evolucao Salarial INDT -- "
Local nLin         := 80

Local Cabec1       := "FUNCIONARIO   "//+Str(Year(mv_par03))
Local Cabec2       := "JAN        |%    |FEV        |%    |MAR        |%    |ABR        |%    |MAI        |%    |JUN        |%    |JUL        |%    |AGO        |%    |SET        |%    |OUT        |%    |NOV        |%    |DEZ        |%   |"
                   //  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                   //            10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "INDFOL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("INDFOL",Len(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "INDFOL" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)



ValidPerg(cPerg)
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

/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local x 
Private nSalBase   // Salario Base 
Private nPerct     // Percentual de variacao  
private nSalJan   // Salario Janeiro  
private nJanGeral  :=0
private nDezGeral  :=0


dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

dbGoTop()
While !EOF()

   IncProc(RecCount())

   If SRA->RA_CATFUNC <> MV_PAR06
   
      SRA->(dbSkip())
      Loop
      
   Endif 
   
   
   IF SRA->RA_ADMISSA >= MV_PAR03+31   
      
      SRA->(DBSKIP())
      LOOP
      
   ENDIF
      

   If !ChkDemit(SRA->RA_MAT) 
      
      SRA->(dbSkip())
      lOOP
      
   Endif   

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
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
   
   @nLin,00 PSAY SRA->RA_MAT + ' - ' + SRA->RA_NOME + ' -  Filial ' +  SRA->RA_FILIAL 
   
   nLin := nLin + 1 // Avanca a linha de impressao
   
   nSalBase := u_chkBase(SRA->RA_MAT)
   
     For x:= 1 to 12  // 12 meses para impressao  
       
       ImpMes(x,nlin,SRA->RA_MAT,x) 
       
     Next 
     
      
  nLin := nLin + 2
  
  @nLin,00 PSAY "Salario Dez..:"
  @nLin,18 PSAY nSalBase  Picture '@E 99,999.99'
  
  nDezGeral := nDezGeral + nSalBase  
  
  nLin+= 1
  
  @nLin,00 PSAY "Salario Jan..:"
  @nLin,18 PSAY nSalJan  Picture '@E 99,999.99' 
  
  nJanGeral := nJanGeral + nSalJan 
  
  nLin+=1 
  
  @nLin,00 PSAY "Variacao em %..:"
  @nLin,18 PSAY Variacao(nSalJan,nSalBase)  Picture '@E 999.99'   
  
  nLin+= 1 
  
  @nLin,00 PSAY "Ano..: "+Str(Year(mv_par03))
  
     
       
  
  // @nLin,00 PSAY nSalBase Picture '@E 99,999.99' // Salario
  // @nLin,12 PSAY "00.00 - "
       
   nPerct   := 0   
   
   dbSkip() // Avanca o ponteiro do registro no arquivo

   nLin := nLin + 2

EndDo

nLin+= 3 

@nLin,00 PSAY "Total Geral Dez..:"
@nLin,18 PSAY  nDezGeral  Picture '@E 999,999,999.99'

nLin+= 2 
@nLin,00 PSAY "Total Geral Jan..:"
@nLin,18 PSAY   nJanGeral  Picture '@E 999,999,999.99'  

nLin+=2  

@nLin,00 PSAY "Variacao em %..:"
@nLin,18 PSAY Variacao(nJanGeral,nDezGeral)  Picture '@E 999.99' 
     


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

/*
Checar se o funcionario está ativo.

*/
Static Function ChkDemit(cMat) 
Local lRet := .F.
local aArea := {} 

aArea := GetArea() 

DbSelectArea("SRA") 
DbSetOrder(1)
DbSeek(xFilial("SRA")+cMat)

   If Empty(SRA->RA_DEMISSA) 

      lRet := .T. 
      
   Endif
   
 RestArea(aArea)   
   
Return(lRet)  



/*
chkHist
Checar se ouve variacao salarial
*/

Static Function chkhist(cMat,dData )  

Local nVar := 0
local aArea := {} 

aArea := GetArea() 

DbSelectArea("SRA") 
DbSetOrder(1)
DbSeek(xFilial("SRA")+cMat)

   If Empty(SRA->RA_DEMISSA) 

      lRet := .T. 
      
   Endif
   
 RestArea(aArea)   

Return 

/*
Checar o salario base 

*/
      
User Function chkBase(cMat) 
local aArea := GetArea()
local nSalar := 0 
dbSelectArea("SR3") 
dbSetOrder(1) 

   If DbSeek(xFilial("SR3")+cMat+dtos(mv_par03),.T.) .And. ;
      !Empty(SR3->R3_VALOR) .And.  Month(mv_par03) == Month(SR3->R3_DATA)      
      
      nSalar := SR3->R3_VALOR 
      
   ElseIf  Month(mv_par03) <> Month(SR3->R3_DATA) //.And. !Empty(SR3->R3_VALOR)
   
     dbSkip(-1)
      
      if !Empty(SR3->R3_VALOR) .and. cMat == (SR3->R3_MAT)
      
         nSalar := SR3->R3_VALOR 
         
      Else 
      
         dbSkip()
         
         nSalar := SR3->R3_VALOR
   
      EndIf   

   Else 
   
       dbSelectArea("SRA")
       dbSetOrder(1) 
       dbSeek(xFilial("SRA")+cMat) 
       
          nSalar := SRA->RA_SALARIO
       
   Endif 
      
 RestArea(aArea)

Return(nSalar)      

/*
Imprimir os meses a partir de fevereiro


*/

Static Function ImpMes(nCol,nlin,cMat,nMes)
local aArea := GetArea()
//local nSalBase
local nSAlar 


DbSelectArea("SR3") 
dbSetOrder(1) 
dbSeek(xFilial("SR3")+cMat)

      If DbSeek(xFilial("SR3")+cMat+Alltrim(Str(year(mv_par03))+AllTrim(strzero(nMes,2))+'01'),.T.);
       .And. SR3->R3_DATA >= MV_PAR03 .And. SR3->R3_DATA <= MV_PAR04 .And. iif(Mv_par05 == 'N',nMes <> Val(mv_par07),.T.)

          nSalar := SR3->R3_VALOR
      
          nPerct := Variacao(nSalBase,nSalar)
          
          @nLin,PegaColuna(nCol)   PSAY nSalar Picture '@E 999,999.99'
          @nLin,Pegacoluna(nCol)+12 PSAY nPerct Picture '@E 99.99'
          
          nSalBase := nSalar  // Para pegar sempre o anterior
      
          If nMes == 1  
          
            nSalJan := nSalar
      
          Endif
      
      Else
      
          // nSalBase := u_chkBase(SRA->RA_MAT)   
           @nLin,PegaColuna(nCol) PSAY nSalBase Picture '@E 999,999.99' // Salario
           @nLin,Pegacoluna(nCol)+12 PSAY "00,00"

          If nMes == 1  
          
            nSalJan := nSalBase
      
          Endif
      
      
      
      Endif


   RestArea(aArea)

Return

/*

PegaColuna

*/

Static Function PegaColuna(nMes)
local nCol 

    If nMes == 1 
    
       nCol := 00 
    ElseIf nMes == 2 
    
       nCol := 18
    ElseIf nMes == 3
    
       nCol := 36
       
    ElseIf nMes == 4
    
       nCol := 54
    
    ElseIf nMes == 5
    
       nCol :=  72
       
    ELseIf nMes == 6
    
       nCOl :=  90
       
    ElseIf nMes == 7
    
       nCOl :=  108
       
    ElseIf nMes == 8
    
       nCol :=  126
       
    ElseIf nMes == 9
    
       nCol  :=  144
       
    ElseIf nMes == 10
    
       nCol :=  162 
       
    ElseIf  nMes == 11
    
       nCol := 180
       
    ElseIf  nMes == 12
    
       nCol := 198
       
   EndIF     
    
Return nCOl  

/*
Variacao 

Pega variacao %
*/

Static Function Variacao(nSalBase,nSal) 
local nPercent := 0 
local nDif  := nSAl - nSalBase 
Local j
nPercent := nDif / nSAlBase*100  

Return(nPercent)
             

/*
  
ValidPerg()
*/ 

Static Function ValidPerg()
Local j, i 
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}
aAdd(aRegs,{cPerg,"01","Da Filial        ?", "","", "mv_ch1", "C", 2, 0,0 ,"G","", "MV_PAR01","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Filial     ?", "","", "mv_ch2", "C", 2, 0,0 ,"G","", "MV_PAR02","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Data          ?", "","", "mv_ch3", "D", 8, 0,0 ,"G","", "MV_PAR03","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data       ?", "","", "mv_ch4", "D", 8, 0,0 ,"G","", "MV_PAR04","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"05","Com Dissidio S/N ?", "","", "mv_ch5", "C", 1, 0,0 ,"G","", "MV_PAR05","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Categ. Funcional ?", "","", "mv_ch6", "C", 1, 0,0 ,"G","", "MV_PAR06","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Mes Dissidio     ?", "","", "mv_ch7", "C", 1, 0,0 ,"G","", "MV_PAR07","","","","",;
"","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return


