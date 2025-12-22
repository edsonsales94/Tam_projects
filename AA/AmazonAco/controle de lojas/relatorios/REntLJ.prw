#include "rwmake.ch"
/*
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressao de Comprovanete de Entrega na Loja                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
*/
User Function REntLJ()

SetPrvt("ARETURN,NPAG,LI,TOTPAGINA,DESCPAGINA,TOTGERAL")
SetPrvt("DESCITEM,DESCTOTAL,FORMA,NLASTKEY")

Lj010InitPrint("C")


titulo   := PADC("IMPRESSAO DE COMPROVANTE DE ENTREGA NA LOJA",120)
cDesc1   := PADC("Este programa ir  emitir um orcamento",120)
cDesc2   := ""
cDesc3   := ""
cString  := "SL1"
aReturn  := { 	"Zebrado" ,;											// [1] Reservado para Formulario	"Zebrado,Especial"
				1,;														// [2] Reservado para N§ de Vias	
				"Administracao",;										// [3] Destinatario					"Administracao"
				1,;														// [4] Formato => 1-Comprimido 2-Normal	
				2,;														// [5] Midia   => 1-Disco 2-Impressora
				2,;														// [6] Porta ou Arquivo 1-LPT1... 4-COM1...	
				"",;													// [7] Expressao do Filtro
				1 }														// [8] Ordem a ser selecionada
																		// [9]..[10]..[n] Campos a Processar (se houver)
wnrel    := "REntLJ"
Li       := 01
nLastKey := 0
xPorta   := 'LPT2'
p_negrit_l := "E"
p_reset    := "@"
p_negrit_d := "F"

wnrel := SetPrint(cString,wnrel,""   ,Titulo ,cDesc1,cDesc2,cDesc3,.T.,,.F.,"P",,,,"EPSON.DRV",.T.,.F.,xPorta)

If nLastKey == 27
	Return       
	
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RunReport() }, Titulo)

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

Lj010EndPrint("C")

Return

Static Function RunReport()

nPag       := 1
Cabec1() //Imprime o cabecalho do Orcamento
Cabec2() //Cabecalho de Venda
TotPagina  := 0
DescPagina := 0
TotGeral   := 0
DescTotal  := 0

DbSelectArea("SG1")
DbSetOrder(1)

DbSelectArea("SL1")

DbSelectArea("SL2")
DbSetOrder(1)
DbGotop()

If SL2->(DbSeek(Xfilial()+SL1->L1_Num))
	
	Do While SL1->L1_Num == SL2->L2_Num .And. SL2->(!Eof())
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			If SB1->(DbSeek(xFilial("SB1")+SL2->L2_PRODUTO))
				
				@ li,01  PSay SubStr(SB1->B1_COD,1,6)
				@ li,pCol()+1  Psay SL2->L2_DESCRI
				@ li,pCol()+1  PSay SL2->L2_UM
				@ li,pCol()+1  PSay SB1->B1_REFEREN
				@ li,pCol()+1  Psay Left(SB1->B1_NOMFAB,10)
				@ li,pCol()+1  PSay Transform(SL2->L2_QUANT,"@E 99,999.999")
				@ li,pCol()+5  PSay SL2->L2_ENTBRAS
				@ li,pCol()+5  PSay SL2->L2_LOCAL
				li := li + 1
				
			Endif
			
			SL2->(DbSkip())
			
		EndDo
		
	Geral()
	RodapeForm()
	
EndIf

Return
***************************************************************************************
Static Function Cabec1()

li:=01
@ li,000 PSay Chr(15)+" "

@ li,001 PSay PADC(SM0->M0_NOMECOM+" -  Data Emissao :" +DTOC(SL1->L1_EMISSAO)+" - "+Time(),120); li := li + 1
@ li,001 PSay Chr(18)+Chr(14)+ p_negrit_l + PADC("S E P A R A",40) + p_negrit_d+p_reset+Chr(15)+Chr(15)
@ li,001 PSay Replicate("-",130)

Return
***************************************************************************************

Static Function Cabec2()

li := 06
DbSelectArea("SL1")
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial()+SL1->L1_CLIENTE+SL1->L1_LOJA,.T.)
@ li,001 PSay "NUM. ORC.: "+Sl1->L1_NUM
@ li,060 PSay "DOCUMENTO FISCAL: "+SL1->L1_DOC+"/"+SL1->L1_SERIE; li := li + 1

@ li,001 PSay "Cliente  : "+AllTrim(SA1->A1_NOME) + "  ( " + AllTrim(SA1->A1_NREDUZ) + " )"
@ li,080 PSay "Codigo   : "+AllTrim(SA1->A1_COD) ; li := li + 1

DbSelectArea("SL1")

DbSelectArea("SA3")
DbSetOrder(1)
SA3->(DbSeek(XFilial()+SL1->L1_VEND,.T.))
@ li,01 PSay "Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ)
li := li + 1
@ li,01 PSay Chr(18)+Chr(14)+ p_negrit_l + PADC("NAO E DOCUMENTO FISCAL",40) + p_negrit_d+p_reset+Chr(15)+Chr(15)
li := li + 1
@ li,01 PSay Replicate("-",130); li := li + 1
@ li,01 PSay "COD.      PRODUTO                                         UM  REFERENCIA                    FABRICANTE      QTD     LOJA   LOCAL    "
//                        1         2         3         4         5         6         7         8         9        10        11        12
//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//               99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX 99,999  999,999.99  9,999.99  99.9 999,999.99  X
li := li + 1
@ li,01 Psay Replicate("-",130)
li := li + 1

Return
***************************************************************************************

Static Function RodapeForm()

If SL1->L1_ENTREGA == "S" // Caso seja para Entrega de Mercadoria
	li++
	
	If GETMV("MV_IMPCENT") == "N"  // Se não imprimir o Comprovante de Entrega no ECF, imprime o dados da Entrega no Orçamento
		@ li,01 PSay Chr(18)+Chr(14)+ p_negrit_l + PADC("ENTREGA RESIDENCIAL: S I M",40) + p_negrit_d+p_reset+Chr(15)+Chr(15)
	EndIf
	
EndIf

li := li + 17
@ li,01 PSay ""

Return
***************************************************************************************

Static Function Geral()

@ li,01 PSay Replicate("-",130) ; li := li + 1
@ li,01 PSay Chr(18)+Chr(14)+ p_negrit_l + PADC("EXIJA O CUPOM FISCAL",40) + p_negrit_d+p_reset+Chr(15)+Chr(15)
li++
@ li,01 PSay Replicate("-",130) ; li := li + 1


Return
