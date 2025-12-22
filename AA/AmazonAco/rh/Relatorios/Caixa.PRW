#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#include 'avprint.ch'

User Function Rcaixa()

Private oLeTxt
Private cPerg := Padr("Rcaixa",lEN(SX1->X1_GRUPO))
ajustaSX1()
Pergunte(cPerg,.F.)
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Indicador Suframa")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira reimprimir a Os selecionada nos parametros "
@ 18,018 Say "                                                              "
@ 26,018 Say "                                                              "

@ 70,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,128 BMPBUTTON TYPE 01 ACTION (MExecute(),Close(oLeTxt))
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

//***************************************************************************************************************//

Static Function MExecute()

  Processa({|lEnd|Caixa()})

Return Nil
//***************************************************************************************************************//

Static Function Caixa()
Local oPrint
Local cQry
Local nLin := 0
Local nC := 0
Local nL := 0
Local nVaLor := {}
Local nQuant := {0,0,0,0,0,0,0,0,0} 
Local cMes := substr(MV_PAR01,1,2) 
Local cAno := substr(MV_PAR01,3,4) 
Local cSemana := {"domingo","segunda-feira","terça-feira","quarta-feira","quinta-feira","sexta-feira","sábado"}
Local cLogo := "lgrl01.bmp"
Private oPrint:= TMSPrinter():New( " Indicador para Suframa" )
//ProcRegua(nRecs)
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
Private oFont8  := TFont():New("Courier New",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10 := TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10n:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12 := TFont():New("Courier New",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont12n:= TFont():New("Courier New",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont14 := TFont():New("Courier New",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14n:= TFont():New("Courier New",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16 := TFont():New("Courier New",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont16n:= TFont():New("Courier New",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont18 := TFont():New("Courier New",9,18,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont20 := TFont():New("Courier New",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24 := TFont():New("Courier New",9,24,.T.,.F.,5,.T.,5,.T.,.F.)
Private oBrush := TBrush():New("",4)

if !oPrint:Setup()
   Return
EndIF
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
oPrint:SayBitmap(100,60,cLogo)
oPrint:Say(380,700,"Manaus-Am,",oFont14n)
oPrint:Say(380,1050,ALLTRIM(STR(DAY(DDATABASE)))+", "+ALLTRIM(MESEXTENSO(MONTH(DDATABASE)))+" de "+cAno,oFont14n)
oPrint:Say(680,50,"De: Deptº Pessoal",oFont14)
oPrint:Say(680,1550,"Salario Minimo:",oFont14) 
oPrint:Say(680,2000,TRANSFORM(MV_PAR02,"@E 999,999.99"),oFont14n) 
oPrint:Say(800,50,"Para: Deptº Fiscal",oFont14)
oPrint:Say(980,50,"Ref: Informações para SUFRAMA",oFont14)
oPrint:Say(1130,50,"DEMONSTRATIVO DA QUANTIDADE/VALORES DA MÃO-DE-OBRA",oFont14)

oPrint:Box(1230,50,1290,2300)
oPrint:Say(1235,500,"MÊS:",oFont14)
oPrint:Say(1235,1500,MESEXTENSO(cMes)+"/"+cAno,oFont12n)  
oPrint:Box(1340,50,1940,2300)
//Hz         
nL := 1340     
nC := 1940
nL1:= 60 

oPrint:Line(nL+nL1*2,050,nL+nL1*2,2300 )
oPrint:Line(nL+nL1*3,050,nL+nL1*3,2300 )
oPrint:Line(nL+nL1*4,050,nL+nL1*4,2300 )
oPrint:Line(nL+nL1*5,050,nL+nL1*5,2300 )
oPrint:Line(nL+nL1*6,050,nL+nL1*6,2300 )
oPrint:Line(nL+nL1*7,050,nL+nL1*7,2300 )
oPrint:Line(nL+nL1*8,050,nL+nL1*8,2300 )
oPrint:Line(nL+nL1*9,050,nL+nL1*9,2300 )

nP := 60
oPrint:Say(nL+nL1,nP,"DESCRIMINAÇÃO",oFont16)
oPrint:Say(nL+nL1*2+5,nP,"Até 1,5 S.M",oFont12)
oPrint:Say(nL+nL1*3+5,nP,"De 1,5 S.M até 2,0 S.M",oFont12)
oPrint:Say(nL+nL1*4+5,nP,"De 2,0 S.M até 4,0 S.M",oFont12)
oPrint:Say(nL+nL1*5+5,nP,"De 4,0 S.M até 6,0 S.M",oFont12)
oPrint:Say(nL+nL1*6+5,nP,"De 6,0 S.M até 10,0 S.M",oFont12)
oPrint:Say(nL+nL1*7+5,nP,"De 10,0 S.M até 15,0 S.M",oFont12)
oPrint:Say(nL+nL1*8+5,nP,"Acima de 15,0 S.M",oFont12)
oPrint:Say(nL+nL1*9+5,nP+230,"TOTAL",oFont12)

/*
nP := 810

oPrint:Say(nL+nL1,nP,"",oFont16)
oPrint:Say(nL+nL1*2+5,nP,TRANSFORM(1.5 ,"@E 99.99"),oFont14)
oPrint:Say(nL+nL1*3+5,nP,TRANSFORM(2.0 ,"@E 99.99"),oFont14)
oPrint:Say(nL+nL1*4+5,nP,TRANSFORM(4.0 ,"@E 99.99"),oFont14)
oPrint:Say(nL+nL1*5+5,nP,TRANSFORM(6.0 ,"@E 99.99"),oFont14)
oPrint:Say(nL+nL1*6+5,nP,TRANSFORM(10.0,"@E 99.99"),oFont14)
oPrint:Say(nL+nL1*7+5,nP,TRANSFORM(15.0,"@E 99.99"),oFont14)
oPrint:Say(nL+nL1*8+5,nP,"99,99",oFont14)
oPrint:Say(nL+nL1*9+5,nP,"",oFont14)

*/
nP := 800
oPrint:Say(nL+nL1,nP+120,"FAIXA",oFont16)
oPrint:Say(nL+nL1*2+5,nP,TRANSFORM(MV_PAR02 * 1.5   ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*3+5,nP,TRANSFORM(MV_PAR02 * 2.0   ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*4+5,nP,TRANSFORM(MV_PAR02 * 4.0   ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*5+5,nP,TRANSFORM(MV_PAR02 * 6.0   ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*6+5,nP,TRANSFORM(MV_PAR02 *10.0   ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*7+5,nP,TRANSFORM(MV_PAR02 *15.0   ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*8+5,nP,TRANSFORM(999999.99        ,"@E 999,999,999.99"),oFont12)
oPrint:Say(nL+nL1*9+5,nP,"",oFont12)


nP := 1400
oPrint:Say(nL+nL1,nP+200,"VALOR",oFont16)
nValor := TabTmp(0,MV_PAR02 * 1.5)
nQuant[1] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*2+5,nP,TRANSFORM(nValor[1]   ,"@E 999,999,999.99"),oFont14n)
nValor := TabTmp(MV_PAR02 * 1.5+0.1,MV_PAR02 * 2.0)
nQuant[2] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*3+5,nP,TRANSFORM(nValor[1]   ,"@E 999,999,999.99"),oFont14n)
nValor := TabTmp(MV_PAR02 * 2.0+0.1,MV_PAR02 * 4.0)
nQuant[3] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*4+5,nP,TRANSFORM(nValor[1]  ,"@E 999,999,999.99"),oFont14n)
nValor := TabTmp(MV_PAR02 * 4.0+0.1,MV_PAR02 * 6.0)
nQuant[4] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*5+5,nP,TRANSFORM(nValor[1]  ,"@E 999,999,999.99"),oFont14n)
nValor := TabTmp(MV_PAR02 * 6.0+0.1,MV_PAR02 * 10.0)
nQuant[5] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*6+5,nP,TRANSFORM(nValor[1]  ,"@E 999,999,999.99"),oFont14n)
nValor := TabTmp(MV_PAR02 * 10.0+0.1,MV_PAR02 * 15.0)
nQuant[6] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*7+5,nP,TRANSFORM(nValor[1]  ,"@E 999,999,999.99"),oFont14n)
nValor := TabTmp(MV_PAR02 * 15.0+0.1,999999999)
nQuant[7] := nValor[2]
nQuant[8] += nValor[1] // Valor Total
nQuant[9] += nValor[2] // Quantidade Total
oPrint:Say(nL+nL1*8+5,nP,TRANSFORM(nValor[1],"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*9+5,nP,TRANSFORM(nQuant[8],"@E 999,999,999.99"),oFont14n)  // VALOR TOTAL

nP := 1800
oPrint:Say(nL+nL1,nP+240,"QTDE",oFont16)
oPrint:Say(nL+nL1*2+5,nP,TRANSFORM(nQuant[1]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*3+5,nP,TRANSFORM(nQuant[2]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*4+5,nP,TRANSFORM(nQuant[3]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*5+5,nP,TRANSFORM(nQuant[4]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*6+5,nP,TRANSFORM(nQuant[5]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*7+5,nP,TRANSFORM(nQuant[6]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*8+5,nP,TRANSFORM(nQuant[7]  ,"@E 9,999,999,999"),oFont14n)
oPrint:Say(nL+nL1*9+5,nP,TRANSFORM(nQuant[9]  ,"@E 9,999,999,999"),oFont14n)  // QUANTIDADE TOTAL

//VERT         
oPrint:Line(nL,800,nC,800)
oPrint:Line(nL,1300,nC,1300)
//oPrint:Line(nL,1800,nC,1800)
oPrint:Line(nL,1900,nC,1900)

//******** PROXIMO QUADRO ***************//

oPrint:Box(2000,50,2660,1500)   ///2000,50,2600,1500
//Hz           
nL := 2000     
nC := 2660   //2600
nL1:= 60                                 

oPrint:Line(nL+nL1*1,050,nL+nL1*1,1500 )
oPrint:Line(nL+nL1*2,050,nL+nL1*2,1500 )
oPrint:Line(nL+nL1*3,050,nL+nL1*3,1500 )
oPrint:Line(nL+nL1*4,050,nL+nL1*4,1500 )
oPrint:Line(nL+nL1*5,050,nL+nL1*5,1500 )
oPrint:Line(nL+nL1*6,050,nL+nL1*6,1500 )
oPrint:Line(nL+nL1*7,050,nL+nL1*7,1500 )
oPrint:Line(nL+nL1*8,050,nL+nL1*8,1500 )
oPrint:Line(nL+nL1*9,050,nL+nL1*9,1500 )
oPrint:Line(nL+nL1*10,050,nL+nL1*10,1500 )

nP := 60                                          

oPrint:Say(nL+nL1*0+5,nP,"RESUMO DO MES",oFont16)
oPrint:Say(nL+nL1*1+5,nP,"Empregados no 1º dia do mês",oFont12)
oPrint:Say(nL+nL1*2+5,nP,"Empregados admitidos no mês",oFont12)
oPrint:Say(nL+nL1*3+5,nP,"Empregados demitidos no mes",oFont12)
oPrint:Say(nL+nL1*4+5,nP,"Empregados no último dia mes",oFont12)
oPrint:Say(nL+nL1*5+5,nP,"Total de M.O Temporária",oFont12)
oPrint:Say(nL+nL1*6+5,nP,"Total de M.O Tercerizada",oFont12)
oPrint:Say(nL+nL1*7+5,nP,"Total de M.O Feminina",oFont12)
oPrint:Say(nL+nL1*8+5,nP,"Total de M.O PNE's",oFont12)
oPrint:Say(nL+nL1*9+5,nP,"Total de M.O Direta",oFont12)
oPrint:Say(nL+nL1*10+5,nP,"Total de M.O Indireta",oFont12)

nP := 820

nResumo := TabTmp2()

oPrint:Say(nL+nL1*0+5,nP+10,"QTDE",oFont16)
oPrint:Say(nL+nL1*1+5,nP,TRANSFORM(nResumo[1,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*2+5,nP,TRANSFORM(nResumo[2,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*3+5,nP,TRANSFORM(nResumo[3,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*4+5,nP,TRANSFORM(nResumo[4,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*5+5,nP,TRANSFORM(0             ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*6+5,nP,TRANSFORM(MV_PAR03      ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*7+5,nP,TRANSFORM(nResumo[5,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*8+5,nP,TRANSFORM(nResumo[6,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*9+5,nP,TRANSFORM(nResumo[7,1]  ,"@E 9,999"),oFont14n)
oPrint:Say(nL+nL1*10+5,nP,TRANSFORM(nResumo[8,1] ,"@E 9,999"),oFont14n)

nP := 1020

oPrint:Say(nL+nL1*0+5,nP+160,"VALOR",oFont16)
oPrint:Say(nL+nL1*1+5,nP,TRANSFORM(nResumo[1,2]   ,"@E 999,999,999.99"),oFont14n)                                                                          
oPrint:Say(nL+nL1*2+5,nP,TRANSFORM(nResumo[2,2]   ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*3+5,nP,TRANSFORM(nResumo[3,2]   ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*4+5,nP,TRANSFORM(nResumo[4,2]   ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*5+5,nP,TRANSFORM(0              ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*6+5,nP,TRANSFORM(MV_PAR04       ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*7+5,nP,TRANSFORM(nResumo[5,2]   ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*8+5,nP,TRANSFORM(nResumo[6,2]   ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*9+5,nP,TRANSFORM(nResumo[7,2]   ,"@E 999,999,999.99"),oFont14n)
oPrint:Say(nL+nL1*10+5,nP,TRANSFORM(nResumo[8,2]  ,"@E 999,999,999.99"),oFont14n)

//VERT         
oPrint:Line(nL,800,nC,800)
oPrint:Line(nL,1000,nC,1000)                                             

// *********  Ultima tabela*************//

//oPrint:Say(2780,50,"    DESPESAS COM ENCARGOS",oFont14)   //2720,50

//oPrint:Box(2860,50,2920,1500)     ///2800,50,2860,1500
//Hz           
//nL := 2860     //2800
//nC := 2920     //2860
//nL1:= 60         
//nP := 60  
//nValor := TabTmp3()
//oPrint:Say(nL+nL1*0+5,nP,"Encargos Sociais(INSS, FGTS)",oFont12n)
//oPrint:Say(nL+nL1*0+5,nP+960,TRANSFORM(nValor[1]  ,"@E 999,999,999.99"),oFont14n)                                                                          

//oPrint:Line(nL,1000,nC,1000)                                             


oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
//oPrinter:Print()   // Imprime direto na impressora default do AP5
Return nil
          

//****************************************************************************************************************//

Static Function TabTmp(nV1,nV2)
Local cQry := ""
//Local _SRA := RetSqlName("SRA")
Local nRet := {0,0} 
Local cMes := substr(MV_PAR01,1,2) 
Local cAno := substr(MV_PAR01,3,4) 
Local dDataIni := FirstDay(CTOD("01/"+cMes+"/"+cAno))
Local dDataFim := LastDay(CTOD("01/"+cMes+"/"+cAno))

// FUNCIONARIOS MENSALISTA 
cQry := " SELECT COUNT(*) AS QTDE,SUM(RA_SALARIO) AS VALOR " 
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) " // APOS A DATA  
cQry += " AND (RA_ADMISSA <= '"+DTOS(dDataFim)+"' ) " // ANTES DA DATA 1º DIA DO MES 
cQry += " AND RA_CATFUNC = 'M' " // MENSALISTA 
cQry += " AND RA_SALARIO BETWEEN "+STR(nV1)+" AND "+STR(nV2)+" "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[1] := TRAB->VALOR
nRet[2] := TRAB->QTDE
dbCloseArea("TRAB")    

// FUNCIONARIOS HORISTA
cQry := " SELECT COUNT(*) AS QTDE,SUM(RA_SALARIO * RA_HRSMES) AS VALOR " 
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) " // APOS A DATA  
cQry += " AND (RA_ADMISSA <= '"+DTOS(dDataFim)+"' ) " // ANTES DA DATA 1º DIA DO MES 
cQry += " AND RA_CATFUNC = 'H' " // HORISTA
cQry += " AND RA_SALARIO BETWEEN "+STR(nV1)+" AND "+STR(nV2)+" "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[1] += TRAB->VALOR
nRet[2] += TRAB->QTDE
dbCloseArea("TRAB")  

Return nRet

//****************************************************************************************************************//

Static Function TabTmp2(nV1,nV2)
Local cQry := ""
Local nRet := {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}} 
Local cMes := substr(MV_PAR01,1,2) 
Local cAno := substr(MV_PAR01,3,4) 
Local dDataIni := FirstDay(CTOD("01/"+cMes+"/"+cAno))
Local dDataFim := LastDay(CTOD("01/"+cMes+"/"+cAno))

// EMPREGADOS NO 1º DIA DO MES - MENSALISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR"                                                                                ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA >= '"+DTOS(dDataIni)+"' ) "// APOS A DATA 
cQry += " AND (RA_ADMISSA < '"+DTOS(dDataIni)+"' ) "// ATE O ULTIMO DIA DO MES  
cQry += " AND RA_CATFUNC = 'M' " //MENSALISTA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[1,1] := TRAB->QTDE
nRet[1,2] := TRAB->VALOR                                                                                                              //30/05/2017 - ENRIQUE
dbCloseArea("TRAB")  

// EMPREGADOS NO 1º DIA DO MES - HORISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR "                                                                                                 ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA >= '"+DTOS(dDataIni)+"' ) "// APOS A DATA 
cQry += " AND (RA_ADMISSA < '"+DTOS(dDataIni)+"' ) "// ATE O ULTIMO DIA DO MES  
cQry += " AND RA_CATFUNC = 'H' "    //HORISTA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[1,1] += TRAB->QTDE
nRet[1,2] += TRAB->VALOR                                                                                                              ///30/05/2017 - ENRIQUE
dbCloseArea("TRAB")  

// EMPREGADOS ADMITIDOS NO MES - MENSALISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR"                                                                                  ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_ADMISSA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"') "// ATE O ULTIMO DIA DO MES 
cQry += " AND RA_CATFUNC = 'M' " //MENSALISTA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[2,1] := TRAB->QTDE
nRet[2,2] := TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB")  

// EMPREGADOS ADMITIDOS NO MES - HORISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR"                                                                                              ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_ADMISSA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"') "// ATE O ULTIMO DIA DO MES 
cQry += " AND RA_CATFUNC = 'H' " //HORISTA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[2,1] += TRAB->QTDE
nRet[2,2] += TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB")

// EMPREGADOS DEMITIDOS NO MES - MENSALISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR"                                                                              ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"') "// ATE O ULTIMO DIA DO MES 
cQry += " AND RA_CATFUNC = 'M' " //MENSALISTA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  

nRet[3,1] := TRAB->QTDE
nRet[3,2] := TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// EMPREGADOS DEMITIDOS NO MES - HORISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR"                                                                                             ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"') "// ATE O ULTIMO DIA DO MES 
cQry += " AND RA_CATFUNC = 'H' " //HORISTA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  

nRet[3,1] += TRAB->QTDE
nRet[3,2] += TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

 // EMPREGADOS NO ULTIMO DIA DO MES
nRet[4,1] := nRet[1,1]+nRet[2,1]-nRet[3,1]   ///QTDE
nRet[4,2] := nRet[1,2]+nRet[2,2]-nRet[3,2]   ///VALOR                                                                             //30/05/2017 - ENRIQUE 

// EMPREGADOS FEMININA - MENSALISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR"                                                                              ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA 
cQry += " AND RA_CATFUNC = 'M' " //MENSALISTA
cQry += " AND RA_SEXO = 'F'  "// FUNCIONARIO FEMININA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[5,1] := TRAB->QTDE
nRet[5,2] := TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// EMPREGADOS FEMININA - HORISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR"                                                                                             ///30/05/2017 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA 
cQry += " AND RA_CATFUNC = 'H' " //HORISTA
cQry += " AND RA_SEXO = 'F'  "// FUNCIONARIO FEMININA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[5,1] += TRAB->QTDE
nRet[5,2] += TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// EMPREGADOS PNE - MENSALISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR "                                                                             //30/05/17 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA 
cQry += " AND RA_CATFUNC = 'M' " //MENSALISTA
cQry += " AND RA_DEFIFIS = '1'  "// FUNCIONARIO DEFICIENTE PNE

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[6,1] := TRAB->QTDE
nRet[6,2] := TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// EMPREGADOS PNE's - HORISTA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR "                                                                                             //30/05/17 - ENRIQUE
cQry += " FROM "+RetSqlName("SRA")+" "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA 
cQry += " AND RA_CATFUNC = 'H' " //HORISTA
cQry += " AND RA_DEFIFIS = '1'  "// FUNCIONARIO DEFICIENTE PNE

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[6,1] += TRAB->QTDE
nRet[6,2] += TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// MAO-DE-OBRA DIRETA - MENSALISTA - 25/02/2021 CLEVESON LIMA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR "
cQry += " FROM "+RetSqlName("SRA")+","+RetSqlName("CTT")+" "
cQry += " WHERE "+RetSqlName("SRA")+".D_E_L_E_T_ = '' "
cQry += " AND "+RetSqlName("CTT")+".D_E_L_E_T_ = '' "
cQry += " AND RA_CC = CTT_CUSTO "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA
cQry += " AND (RA_ADMISSA <= '"+DTOS(dDataFim)+"' ) "// ATE A DATA
cQry += " AND RA_CATFUNC = 'M' "
cQry += " AND CTT_XTPOCC = '0' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[7,1] := TRAB->QTDE
nRet[7,2] := TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// MAO-DE-OBRA DIRETA - HORISTA - 25/02/2021 CLEVESON LIMA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR "
cQry += " FROM "+RetSqlName("SRA")+","+RetSqlName("CTT")+" "
cQry += " WHERE "+RetSqlName("SRA")+".D_E_L_E_T_ = '' "
cQry += " AND "+RetSqlName("CTT")+".D_E_L_E_T_ = '' "
cQry += " AND RA_CC = CTT_CUSTO "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA
cQry += " AND (RA_ADMISSA <= '"+DTOS(dDataFim)+"' ) "// ATE A DATA
cQry += " AND RA_CATFUNC = 'H' "
cQry += " AND CTT_XTPOCC = '0' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[7,1] += TRAB->QTDE
nRet[7,2] += TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// MAO-DE-OBRA INDIRETA - MENSALISTA - 25/02/2021 CLEVESON LIMA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO) AS VALOR "
cQry += " FROM "+RetSqlName("SRA")+","+RetSqlName("CTT")+" "
cQry += " WHERE "+RetSqlName("SRA")+".D_E_L_E_T_ = '' "
cQry += " AND "+RetSqlName("CTT")+".D_E_L_E_T_ = '' "
cQry += " AND RA_CC = CTT_CUSTO "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA
cQry += " AND (RA_ADMISSA <= '"+DTOS(dDataFim)+"' ) "// ATE A DATA
cQry += " AND RA_CATFUNC = 'M' "
cQry += " AND CTT_XTPOCC <> '0' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[8,1] := TRAB->QTDE
nRet[8,2] := TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

// MAO-DE-OBRA INDIRETA - HORISTA - 25/02/2021 CLEVESON LIMA
cQry := " SELECT COUNT(*) AS QTDE,"
cQry += " SUM(RA_SALARIO*RA_HRSMES) AS VALOR "
cQry += " FROM "+RetSqlName("SRA")+","+RetSqlName("CTT")+" "
cQry += " WHERE "+RetSqlName("SRA")+".D_E_L_E_T_ = '' "
cQry += " AND "+RetSqlName("CTT")+".D_E_L_E_T_ = '' "
cQry += " AND RA_CC = CTT_CUSTO "
cQry += " AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+DTOS(dDataFim)+"' ) "// APOS A DATA
cQry += " AND (RA_ADMISSA <= '"+DTOS(dDataFim)+"' ) "// ATE A DATA
cQry += " AND RA_CATFUNC = 'H' "
cQry += " AND CTT_XTPOCC <> '0' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  
nRet[8,1] += TRAB->QTDE
nRet[8,2] += TRAB->VALOR                                                                                                          //30/05/2017 - ENRIQUE
dbCloseArea("TRAB") 

Return nRet
            
//****************************************************************************************************************//

Static Function TabTmp3()
Local cQry := ""
Local _SRC := RetSqlName("SRC")
Local nRet := {0,0} 
Local cMes := substr(MV_PAR01,1,2) // MM
Local cAno := substr(MV_PAR01,3,4) // AAAA
Local dDataIni := FirstDay(CTOD("01/"+cMes+"/"+cAno))
Local dDataFim := LastDay(CTOD("01/"+cMes+"/"+cAno))
Local nQt := 0
Local SRC_MES := Alltrim(GETMV("MV_FOLMES"))  //  AAAAMM
Local cVerbas := ALLTRIM(MV_PAR05)+ALLTRIM(MV_PAR06)
          
if SRC_MES != cAno+cMes
  _SRC :=SUBSTR(_SRC,2,4)+SUBSTR(cAno,3,2)+cMes
Endif

/*
cQry := " SELECT COUNT(*) QTDE, SUM(SRC.RC_VALOR) VALOR "
cQry += " FROM "+_SRC+" SRC "
cQry += " WHERE SRC.D_E_L_E_T_<>'*' "

If !Empty(ALLTRIM(cVerbas))
  cQry += "       AND SRC.RC_PD IN ("
  cQry += SUBSTR(cVerbas,1,3)
  nQt  := 3
  While(nQt < Len(ALLTRIM(cVerbas)) )    
    cQry += ","+SUBSTR(cVerbas,nQt+1,3)
    nQt += 3
  Enddo
  cQry += " ) "
Endif 

*/

cQry := " SELECT COUNT(*) AS QTDE, SUM(SRC.RD_VALOR) AS VALOR "
cQry += " FROM "+RetSqlName("SRD") +" SRC "
cQry += " WHERE SRC.D_E_L_E_T_<>'*' "

If !Empty(ALLTRIM(cVerbas)) .AND.  ALLTRIM(cVerbas) <> "*"
  cQry += "       AND SRC.RD_PD IN ("
  cQry += SUBSTR(cVerbas,1,3)
  nQt  := 3
  While(nQt < Len(ALLTRIM(cVerbas)) )    
    cQry += ","+SUBSTR(cVerbas,nQt+1,3)
    nQt += 3
  Enddo
  cQry += " ) "
Endif 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")  

nRet[1] := TRAB->VALOR + MV_PAR07  // + VALOR ADICIONAL
dbCloseArea("TRAB")    

Return nRet 

//****************************************************************************************************************//

Static Function ajustaSX1

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

aAdd(aRegs,{cPerg,"01","Periodo (MMAAAA)    ","Periodo (MMAAAA)    ","Periodo (MMAAAA)    ","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","", ""})
aAdd(aRegs,{cPerg,"02","Valor Sal. Min.:    ","Valor Sal. Min.:    ","Valor Sal. Min.:    ","mv_ch2","N",10,2,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","", ""})
aAdd(aRegs,{cPerg,"03","Qtde Tercerizada:   ","Qtde Tercerizada:   ","Qtde Tercerizada:   ","mv_ch3","N",03,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","", ""})
aAdd(aRegs,{cPerg,"04","Valor Tercerizada:  ","Valor Tercerizada:  ","Valor Tercerizada:  ","mv_ch4","N",10,2,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","", ""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
	RecLock("SX1",.T.)
	For j:=1 to FCount()
	    If j <= Len(aRegs[i])
		FieldPut(j,aRegs[i,j])
	    Endif
	Next
	MsUnlock()
    Endif
Next

MS_FLUSH()

Return
