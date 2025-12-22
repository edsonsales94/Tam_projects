#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Ctec02r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NORDEM,ALFA,Z,M,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,LCONTINUA,WNREL,CSTRING")
SetPrvt("NAJUSTE,LI,CI,A_ET,ANOME,AOM")
SetPrvt("ANF,ATOTAL,ADATA,NETIQ,NAUX,NCABEC")
SetPrvt("NATUAL,_NETQATU,NCONT,NOPC,CCOR,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CTEC02R  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³10.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EMISSAO DE ETIQUETAS ORDEM DE MANUTENCAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA COEL CONTROLES ELETRICOS LTDA              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Parametros Utilizados pelo Programa

mv_par01 - Da OM
mv_par02 - Ate a OM

/*/
nOrdem          := 0
Alfa            := 0
Z               := 0
M               := 0
tamanho := "G"
limite  := 220
titulo  := PADC("Etiquetas OM's",74)
cDesc1  := PADC("Este programa ira emitir as etiquetas",74)
cDesc2  := PADC("das Ordens de Manutencao",74)
cDesc3  := PADC("Coel Controles Eletricos Ltda",74)
cNatureza       := ""
aReturn         := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog        := "CTEC02R"
cPerg   := "ATETIQ"
nLastKey        := 0
lContinua := .T.
wnrel   := "CTEC02R"
cString   := "AB2"
nAjuste   :=0   // para o deslocamento nas etiquetas da mesma linha
li        :=0.5 // para a contagem das linhas a serem impressas
ci        :=2   // coluna inicial

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  matrizes com os dados para impressao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

a_Et  := {}
aNOME :={} // contem os nomes dos clientes
aOM   :={} // contem os numeros das om's 
aNF   :={} // contem os nueros das nfe's
aTOTAL:={} // contem os totais de produtos
aDATA :={} // contem as datas


// indice para as matrizes (Numero da etiqueta atual)

nETIQ  := 0


Pergunte(cPerg,.F.)               // Pergunta no SX1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerImp()

#IFDEF WINDOWS
	RptStatus({|| Etiqueta()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> 	RptStatus({|| Execute(Etiqueta)})
	Return
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> 	Function Etiqueta
Static Function Etiqueta()
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtencao dos dados para impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("AB2") // arquivo de CHAMADOS TECNICOS
dbSetOrder(1)
dbSeek(xFilial()+mv_par01,.T.)
SetRegua(Val(mv_par02)-Val(mv_par01))
nAux  := 1
nCabec := 8

While !Eof() .And. xFilial("AB2") == AB2->AB2_FILIAL .And.;
                            AB2->AB2_NRCHAM <= MV_PAR02

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Posiciona Registros                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SA1") //  Cadastro de Clientes
    dbSetOrder(1)
    dbSeek(xFilial("SA1")+AB2->AB2_CODCLI+AB2->AB2_LOJA)

    dbSelectArea("AB1") // Cabecalho Chamado Tecnico
    dbSetOrder(1)
    dbSeek(xFilial("AB1")+AB2->AB2_NRCHAM)

    AADD(aNOME,subs(SA1->A1_NREDUZ,1,10))
    AADD(aNF,AB1->AB1_CLNFE)
    AADD(aOM,AB1->AB1_NRCHAM+"/"+AB2->AB2_ITEM)
    AADD(aTOTAL,AB2->AB2_CLQTDE)
    AADD(aDATA,AB1->AB1_EMISSA)
    nETIQ:=nETIQ+1

    incregua()
    
    DbSelectArea("AB2")
    dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das matrizes com os dados ja obtidos               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(a_Et,aNOME)
aAdd(a_Et,aNF)
aAdd(a_Et,aOM)
aAdd(a_Et,aTOTAL)
aAdd(a_Et,aDATA)

nAtual  := 0 // numero da etiqueta atual
nAjuste := 0
_nEtqAtu:= 1
SetRegua(nEtiq-nAtual)
@000,000 PSAY Chr(15)
While .T.
    
    for nCont:=1 to nCabec  // Imprime o nome
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY aNOME[nAtual+nCont]
            nAjuste:=nAjuste+26
        endif

	next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // imprime o numero da nota
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "NF: "+aNF[nAtual+nCont]
            nAjuste:=nAjuste+26
        endif
    next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // imprime o numero da om
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "OM: "+aOM[nAtual+nCont]
            nAjuste:=nAjuste+26
		endif
	next nCont
	nAjuste := 0
    li:=li+1
    incregua()
    for nCont:=1 to nCabec  // imprime o total de produtos
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "TOTAL: "+Str(aTOTAL[nAtual+nCont],5)
            nAjuste:=nAjuste+26
        endif
    next nCont
    nAjuste := 0
    li:=li+1
    incregua()
    for nCont:=1 to nCabec  // imprime a data emissao da om
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "DATA "+DTOC(aDATA[nAtual+nCont])
            nAjuste:=nAjuste+26
		endif
	next nCont
	nAjuste := 0
    nAtual  := nAtual+8
    li:=li+2

    // Bloco desabilitado em 09/06/2000 por Ricardo - Microsiga
    /*
    if li>=72
		setprc(0,0)
	endif
    */

    if nAtual>nEtiq
		exit
	endif
end 
@000,000 PSAY Chr(18)
Set Device To Screen

dbcommitAll()

If aReturn[5] == 1
	Set Printer TO
	ourspool(wnrel)
Endif

MS_FLUSH()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 10/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ VERIFICA POSICIONAMENTO DE PAPEL NA IMPRESSORA             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA COEL CONTROLES ELETRICOS LTDA              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function VerImp
Static Function VerImp()

If aReturn[5]==2
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		SetPrc(0,0)
		dbCommitAll()
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 PSAY "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
				Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif

Set Device to Print

Return

