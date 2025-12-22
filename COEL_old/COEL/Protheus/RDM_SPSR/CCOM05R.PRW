#include "rwmake.ch"       

User Function ccom05r()    

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,NBASEIPI,CSTRING")
SetPrvt("LEND,COBS,TAMANHO,TITULO,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,NBEGIN,ALINHA,ADRIVER,CPERG,ASENHAS")
SetPrvt("AUSUARIOS,NCOUNT,NTAMFORM,NHDLALCA,NTAMALCA,NLIDOS")
SetPrvt("CREGISTRO,NREEM,NSAVREC,ASAVREC,LIMITE,LI")
SetPrvt("NTOTGER,NTOTIPI,NDESCPROD,NTOTAL,NIPI,NUMPED")
SetPrvt("NORDEM,COBS01,COBS02,COBS03,COBS04,LLIBERADOR")
SetPrvt("NCW,NTOTNOTA,I,CDESCRI,MV_PAR06,NLINHA")
SetPrvt("NALIQ,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM05R  ³ Autor ³Ricardo Correa de Souza³ Data ³16.10.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao de Pedidos de Compras em Formulario Proprio        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CCOM05R"
cDesc1    := "Emissao dos pedidos de compras cadastrados e que" 
cDesc2    := " ainda nao foram emitidos - formulario proprio. "
cDesc3    := " "
nBaseIPI  := 0
cString   := "SC7"
lEnd      := .F.
cObs      := " "
tamanho   := "G"
titulo    := "Emissao dos Pedidos de Compras em Formulario Proprio"
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
nomeprog  := "CCOM05R"
nLastKey  := 0
nBegin    := 0
aLinha    := { }
aDriver   := ReadDriver()
cPerg     := "MTR110"
aSenhas   := {}
aUsuarios := {}
nCount    := 0
nTamForm  := 19

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto            ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTR110",.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

If mv_par08 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le o Arquivo de Alcadas.                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	If File(cArqAlca) .And. GetMV("MV_ALCADA") == "S"
	If GetMV("MV_ALCADA") == "S"
		aUsuarios := {}
        aSenhas   := {}
        nHdlAlca  := FOPEN(cArqAlca,2)
        nTamAlca  := FSEEK(nHdlAlca,0,2)
		FSEEK(nHdlAlca,0,0)
		nLidos := 0
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			AADD(aUsuarios,{ cRegistro } )
			AADD(aSenhas,{ SubStr(cRegistro,2,6) } )
            nLidos := nLidos + 82
		End
		FCLOSE(nHdlAlca)
	EndIf

    RptStatus({|| C110PC()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>         RptStatus({|| Execute(C110PC)},titulo)
EndIf

Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function C110PC()
nReem    := 0
nSavRec  := 0
aSavRec  := {}

limite   := 220
li       := 46
nTotGer  := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
nIpi     := 0
NumPed   := Space(6)

dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+mv_par01,.T.)

SetRegua(RecCount())

aReturn[4]:= 1	   // para forcar compressao

If aReturn[4] == 1                  // Comprimido
    @ 000,000 PSAY &(aDriver[3])
ElseIf aReturn[4] == 2              // Normal
    @ 000,000 PSAY &(aDriver[4])
EndIf

While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
		C7_NUM <= mv_par02
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	
	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	
	If C7_TIPO != 1
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Usuario definiu usar o Controle de Alcadas.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lLiberador := .F.
	If GetMV("MV_ALCADA") == "S"
		If !File(cArqAlca)
			lLiberador := .F.
		Else
			lLiberador := .T.
			If Empty(C7_CODLIB)
				dbSkip()
				Loop
			EndIf
		EndIf
	EndIf
	
    For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
	
		ImpCabec()
		
		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
        nTotNota := nTotNota + SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		
		numPed   := SC7->C7_NUM
        While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM == NumPed
		
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                dbGoBottom()
				Exit
			Endif
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se havera salto de formulario                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If li > 45
	       ImpCabec()
	    Endif

            li := li + 1

            If nCount == nTamForm

//                @ 036,086 PSAY "** Pedido Continua na Proxima Pagina **"

//                @ 049, 000 PSAY ""

                @ li,086 PSAY "** Pedido Continua na Proxima Pagina **"
		//  li := li + 15
		@ 51, 000 PSAY ""

                SetPrc(0,0)

                ImpCabec()

                li := li + 1

                nCount  := 0

                ImpProd()
            Else
                ImpProd()
            EndIf

            nCount := nCount + 1

            DbSkip()

        	End
		
		dbGoto(nSavRec)

        If li>45
			ImpCabec()
		End

		FinalPed()		// Imprime os dados complementares do PC

    Next

    SetPrc(0,0)

    nTotGer := 0

	For i:=1 to Len(aSavRec)
		dbGoto(aSavRec[i])
		RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
        SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
        SC7->C7_EMITIDO := "S"
		MsUnLock()
	Next

	dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	aSavRec := {}
	
	dbSkip()

End

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPgEject(.F.)
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
    dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpProd()
cDescri := ""

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B1_DESC"
    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
    DbSelectArea("SC7")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
    DbSelectArea("SB5")
    DbSetOrder(1)
    If DbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
    DbSelectArea("SC7")
EndIf

DbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

DbSelectArea("SA5")
DbSetOrder(1)
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)
If Found() .And. !Empty(A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
DbSelectArea("SC7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime da descricao selecionada                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinha:= MLCount(cDescri,66)
@ li,012 PSAY SC7->C7_ITEM
@ li,017 PSAY SC7->C7_QUANT Picture PesqPict("SC7","C7_QUANT")
@ li,036 PSAY SC7->C7_UM
@ li,045 PSAY SC7->C7_PRODUTO
@ li,074 PSAY MemoLine(cDescri,66,1)+" ENTREGA: "+Dtoc(SC7->C7_DATPRF)
@ li,157 PSAY SC7->C7_PRECO Picture PesqPict("SC7","C7_PRECO")
@ li,183 PSAY SC7->C7_TOTAL Picture PesqPict("SC7","C7_TOTAL")
@ li,202 PSAY SC7->C7_IPI Picture PesqPict("SC7","C7_IPI")
For nBegin := 2 To nLinha
    li := li + 1
    @ li,074 PSAY Memoline(cDescri,66,nBegin)
Next nBegin

If SubStr(SC7->C7_OBS,1,1) $ "Xx"
    li := li + 1
    @ li,074 PSAY "OBS.: "+Subs(SC7->C7_OBS,2,29)
Endif

nTotal := nTotal + SC7->C7_TOTAL
nAliq  := SC7->C7_IPI/100+1
nIpi   := SC7->C7_PRECO*nAliq*SC7->C7_QUANT
nTotGer:= nTotGer+nIpi

Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function FinalPed()

li := 38
@ li,082 PSAY "** Sistema de Qualidade Aplicavel - ISO 9002 **"
li := li + 5
@ li,185 PSAY nTotal Picture tm(nTotal,14)
li := li + 1
@ li,020 PSAY SC7->C7_NUM
li := li + 2
@ li,185 PSAY nTotGer Picture tm(nTotGer,14)
li := li + 5
@ li,219 PSAY ""

Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function ImpCabec()

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)

li := 03
If MsgBox("Sr(a) "+Alltrim(Subs(cUsuario,7,15))+", onde sera entregue o pedido "+SC7->C7_NUM+"? Caso seja Sao Paulo clique << SIM >>, caso seja Sao Roque << NAO >>.","Validacao Local de Entrega","YesNo")
    @ li,065 PSAY "X"
    @ li,168 PSAY "X"
Else
    li := li + 2
    @ li,065 PSAY "X"
    @ li,168 PSAY "X"
EndIf
              

li := 07

@ li,030 PSAY Alltrim(SA2->A2_NOME)+"  -  "+SA2->A2_COD
li := li + 1
@ li,030 PSAY Alltrim(SA2->A2_END)+"  -  "+SA2->A2_BAIRRO
li := li + 1
@ li,030 PSAY SA2->A2_CEP Picture PesqPict("SA2","A2_CEP")

If !Empty(SC7->C7_OBS)
    If ! SubStr(SC7->C7_OBS,1,1) $ "Xx"
        @ li,130 PSAY "OBS. PEDIDO: "+SC7->C7_OBS
    EndIf
EndIf

@ li,062 PSAY SA2->A2_TEL Picture PesqPict("SA2","A2_TEL")
@ li,099 PSAY SC7->C7_CONTATO Picture PesqPict("SC7","C7_CONTATO")
@ li+1,062 PSAY SA2->A2_FAX Picture PesqPict("SA2","A2_FAX")

DbSelectArea("SE4")
DbSetOrder(1)
DbSeek(xFilial()+SC7->C7_COND)

li := li + 3
@ li,042 PSAY SubStr(SE4->E4_DESCRI,1,15)
li := li + 1
@ li,095 PSAY SC7->C7_NUM
li := li + 1
@ li,095 PSAY DTOC(SC7->C7_EMISSAO)
li := li + 2
DbSelectArea("SC7")
Return
