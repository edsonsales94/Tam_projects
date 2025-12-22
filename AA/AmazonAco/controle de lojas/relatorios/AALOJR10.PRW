#include "rwmake.ch"
#include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄquÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³    ³ Autor ³ Adson Carlos      i ³ Data ³ 03/09/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±

±±³Descri‡…o ³ Lista de Separação do Faturamento                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function AALOJR10(cOrcamento)
 Default cOrcamento = ''
 Private cPerg     :=  PADR("AALOJR10",Len(SX1->X1_GRUPO))

  //ValidPerg(cPerg)
  If Empty(cOrcamento)
     Pergunte(cPerg,.T.)
  else 
     Pergunte(cPerg,.F.)
     mv_par01 := cOrcamento
  EndIf
  AALISTA2(cOrcamento)
   
Return(.T.)  

Static Function AALISTA2(cOrcamento)

SetPrvt("CBTXT,CBCONT,NORDEM,TAMANHO,LIMITE,CIMPRI")
SetPrvt("NTOTAL,TITULO,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NQTD,ADRIVER")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbTxt  := ""
cbCont := ""
nOrdem := 0
Tamanho:= "M" 
Limite := 132
cImpri := ""
nTotal := 0                                                         
Titulo := PadC(OemToAnsi("Lista de Separação"),74)
cDesc1 := PadC(OemToAnsi("Este programa ira emitir a lista de Separação conforme"),74)
cDesc2 := PadC(OemToAnsi("os parametros solicitados"),74)
cDesc3 := PadC(OemToAnsi(""),74)

aReturn   := { "Especial", 1,"Administracao", 1, 3, 8, "",1 }
NomeProg  := "AALISTA2" 
nLastKey  := 0 
lContinua := .T.
nLin      := 99
wnrel     := "AALISTA2"

cString:="SL2"    

SL1->(dbSetOrder(1))
SL1->(dbSeek(XFILIAL("SL1")+Mv_par01))   

SL2->(dbSetOrder(1))
SL2->(dbSeek(XFILIAL("SL2")+Mv_par01))   

SB1->(dbSetOrder(1))
SB1->(dbSeek(XFILIAL("SB1")+SL2->L2_PRODUTO))   
	    
SBM->(dbSetOrder(1))
SBM->(dbSeek(XFILIAL("SBM")+SB1->B1_GRUPO))   

cPorta := "LPT1"//(Posicione("SX5",1,xfilial("SX5")+"ZZ","X5_DESCRI"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

aDriver := ReadDriver()
If Empty(cOrcamento)
   wnrel := SetPrint(cString,wnrel,""   ,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
else
   wnrel := SetPrint(cString,wnrel,""   ,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,"M",,,,"EPSON.DRV",.T.,.F.,cPorta)
EndIf

If ( nLastKey == 27 .Or. LastKey() == 27 )
   Return(.F.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³          
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)
If ( nLastKey == 27 .Or. LastKey() == 27 )
   Return(.F.)
Endif

RptDetail()

Static Function RptDetail()
Private nwDesconto := 0
dbSelectArea("SL1")
dbSetOrder(1)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial()+SL1->L1_CLIENTE+SL1->L1_LOJA)

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SL1->L1_CONDPG)  

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial()+SL1->L1_VEND)

SLJ->(dbSetOrder(3))
SLJ->(dbSeek(XFILIAL("SLJ")+SM0->(M0_CODIGO+M0_CODFIL)))

nLin := 0  
@ 00,000 PSAY &(aDriver[aReturn[4]+2])
@ nLin,000 PSAY " " + Repl("_",Limite-2)
nLin := nLin + 1
//@ nLin,000 PSAY "|"+PadC(Trim(SLJ->LJ_NOME)+" - TEL: "+Trim(SM0->M0_TEL),Limite-1)+"|"                                              
@ nLin,000 PSAY "|"+ SPace(50) +Trim(SLJ->LJ_NOME)+" - TEL: "+Trim(SM0->M0_TEL)+ Space(29) + " Impresso as: " + Time() + " |"
nLin := nLin + 1
@ nLin,000 PSAY "|"+space(45)+OemToAnsi("Lista de Separacao do Orcamento: ")+SL1->L1_NUM + Space(28) + "Venda em:"+Dtoc(SL1->L1_EMISNF) + " |"
@ nLin,000 PSAY " "+space(45)+OemToAnsi("Lista de Separacao do Orcamento: ")+SL1->L1_NUM + Space(28) + "Venda em:"+Dtoc(SL1->L1_EMISNF) + " |"

//nLin := nLin + 1
//@ nLin,000 PSAY "|"+PadC("",Limite-2)+"|"
nLin := nLin + 1
@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
nLin := nLin + 1
cImpri := OemToAnsi("Cliente: ")+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME
@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)+"|"
nLin := nLin + 1
cImpri := OemToAnsi("ENDERECO: ")+SA1->A1_END+" Bairro:	"+Alltrim(SA1->A1_BAIRRO)
@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)
@ nLin,Limite - 1 PSAY "|"
nLin := nLin + 1
cImpri := OemToAnsi("Telefones: ")+SA1->A1_TEL+"  "+SA1->A1_TEL
@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)+"|"
nLin := nLin + 1 
cImpri := OemToAnsi("Observacao:")+SL1->L1_OBSERV
@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)+"|"
nLin := nLin + 1
cImpri := OemToAnsi("Cond. Pag.:")+SL1->L1_CONDPG+" - "+SE4->E4_DESCRI
cImpri += Space(10) + iIf(SL1->L1_ENTREGA='S','Mercadoria para Entrega','Mercadoria a Retirar pelo Cliente')
@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)+"|"
nLin := nLin + 1

cImpri := OemToAnsi("Vendedor")+SA3->A3_COD+" - "+SA3->A3_NOME	
nwDesconto := 0 //SL1->L1_DESCONT // VERIFICAR ESSA LINHA

@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)+"|" 
nLin := nLin + 1						
cImpri := OemToAnsi("E-mail: ")+" "+SA3->A3_EMAIL
@ nLin,000 PSAY "|"+PadR(cImpri,Limite-2)+"|"
nLin := nLin + 1
              
@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
nLin := nLin + 1 
                          //  	    1         2         3         4         5         6         7         8         9         0         1         2         3    
                         //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
@ nLin,000 PSAY OemToAnsi("| Produto      Quantidade  UM  Descricao                                                                       Marca     Prc Venda |")
nLin := nLin + 1
@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"

dbSelectArea("SL2")
dbSetOrder(1)
dbSeek(xFilial("SL2")+SL1->L1_NUM,.T.)

While ( !Eof() .And. SL2->L2_FILIAL == xFilial("SL2") .And. ;
			SL2->L2_NUM == SL1->L1_NUM )
	If ( nLin > 60 )
		nLin := 0
		@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
		nLin := nLin + 1
		@ nLin,000 PSAY "|"+PadC(OemToAnsi("Continuacao..."),Limite-2)+"|"
		nLin := nLin + 1
		@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
		nLin := nLin + 1 
	                             //		    1         2         3         4         5         6         7         8         9         0         1         2         3    
                                 //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
		@ nLin,000 PSAY OemToAnsi("| Produto      Quantidade  UM  Descricao                                                                       Marca     Prc Venda |")
		nLin := nLin + 1         //                   999,999.99//ACEX ANC801 CITTA ANCORAGEM INTERMEDIARIA COLUNA VL0001/VL0025aaaaaaaaaaaaaaaaa ADCSASCFG 999,999.99
		@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
		nLin := nLin + 1                                                                                                                               
		
  	EndIf                    
  	
  	    //Criar controle para orienta;áo da 	lista se ela for do tipo A!!!!  ->>>>>>
		 
		nLin := nLin + 1
	 	@ nLin,000 PSAY "| "+alltrim(SL2->L2_PRODUTO)
	 	@ nLin,015 PSAY Transform(SL2->L2_QUANT, "@E 999,999.99")  
	 	@ nLin,027 PSAY SL2->L2_UM 
		@ nLin,031 PSAY Posicione("SB1",1,xfilial("SB1")+L2_PRODUTO,"B1_ESPECIF")
		@ nLin,111 PSAY	ALLTRIM(SUBSTR(Posicione("SB1",1,xfilial("SB1")+L2_PRODUTO,"SB1->B1_FABRIC"),1,08))
		@ nLin,121 PSAY ALLTRIM(Transform(SL2->L2_VRUNIT, PesqPict("SL2","L2_VRUNIT",18,2) ))
	//	@ nLin,118 PSAY Transform(SL2->L2_VLRITEM, "@E 999,999.99")
		@ nLin,131 PSAY "|"
//		    1         2         3         4         5         6         7         8         9         0         1         2         3    
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
//| Produto         Descricao                                             Marca           Quantidade        Prc Venda        Total   |
//	             1234567890123456789012345678901234567890123456789                        999,999.99       999,999.99   999,999.99
	dbSelectArea("SL2")
	dbSkip()	
EndDo			     

nLin := nLin + 1	
@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
nLin := nLin + 1
nBruto := 0
nTotal := SL1->L1_VLRTOT
nBruto := SL1->L1_VALMERC
nwDesconto := nBruto - nTotal

@ nLin,000 PSAY "| " + OemToAnsi("Total dos Itens ---->")
@ nLin,112 PSAY nBruto PICTURE TM(nBruto,18,2)          //TRANSFORM(SL1->L1_VALMERC,"@E 999,999.99")//nTotal PICTURE TM(nTotal,18,2)
@ nLin,131 PSAY "|"
nLin := nLin + 1
//@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
//nLin := nLin + 1 
 
@ nLin,000 PSAY "| " + OemToAnsi("Desconto ---->")
@ nLin,112 PSAY nwDesconto PICTURE TM(nwDesconto,18,2)
@ nLin,131 PSAY "|"
//nLin := nLin + 1
//@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
nLin := nLin + 1 

@ nLin,000 PSAY "| " + OemToAnsi("Total do Orcamento ---->")
@ nLin,112 PSAY nTotal PICTURE TM(nTotal,18,2)
@ nLin,131 PSAY "|"
nLin := nLin + 1
//@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"
//nLin := nLin + 1 

@ nLin,000 PSAY "|"+Repl(" ",Limite-2)+"|"
nLin := nLin + 1 

If !Empty(SL1->L1_DOC)
	@ nLin,000 PSAY "| " + Padr("DOCUMENTO FISCAL:  " + SL1->L1_DOC + " SERIE: " + SL1->L1_SERIE,Limite - 3) + "|"
Else	
	@ nLin,000  PSAY "| " + Padr("DOCUMENTO FISCAL " + SL1->L1_NUMCFIS + " SERIE: " + SL1->L1_SERIE,Limite - 3) + "|"
Endif

nLin := nLin + 1
@ nLin,000 PSAY "|"+Repl("_",Limite-2)+"|"                                             


Set Device to Screen
Set Printer To
dbCommitAll()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	ourspool(wnrel)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_FLUSH()
Return(.T.)