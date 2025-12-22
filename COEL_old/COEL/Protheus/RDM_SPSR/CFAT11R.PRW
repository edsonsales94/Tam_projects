#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat11r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("M_PAG,CABEC1,CABEC2,CBTXT,CBCONT,CSTRING")
SetPrvt("WNREL,LIMPRIME,CGRTXT,ARETURN,NORDEM,NTIPO")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,LI")
SetPrvt("NTOTVISTA,NTOTPRAZO,NTOTGERAL,NTOTISS1,NTOTISS2,NTOTISSG")
SetPrvt("NDEVMERC,NDEVBRUT,NDEVGERAL,NDEVISS1,NDEVISS2,NDEVISSG")
SetPrvt("CNOTA,CNOTAORI,NFLAG,NFLAG1,NCOUNT,_CCHAVE")
SetPrvt("_CFILTRO,_CINDICE,CCONDPAG,CABEC3,AREGS,I")
SetPrvt("J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT11R  ³ Autor ³Ricardo Correa de Souza³ Data ³19.10.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faturamento da Assistencia Tecnica (A Vista/A Prazo)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³   Data   ³             Motivo da Alteracao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³06.10.2000³Incluso parametro para escolha dos tes       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Definicao das Variaveis                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

titulo   := "RELATORIO ANALITICO FATURAMENTO ASSISTENCIA TECNICA"
cDesc1   := "Este relatorio mostrara os valores faturados para Assistencia"
cDesc2   := "Tecnica, separado por total a vista e total a prazo."
cDesc3   := ""
tamanho  := "M"
limite   := 132
m_pag    := 01
cabec1   := "NF's/SERIE TIPO SERVICO DATA EMISSAO COD.CLI   RAZAO SOCIAL CLIENTE       A VISTA       FATURADO    COND.PAGTO.                ISS"
cabec2   := ""
CbTxt    := ""
CbCont   := 00
cString  := "SD2"
wnrel    := "CFAT11R"            
titulo   := "Relatorio Analitico de Faturamento - Assistencia Tecnica"
lImprime := .T.
cGrtxt   := SPACE(11)
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1}
nOrdem   := aReturn[8]
nTipo    := Iif(aReturn[4]==1,15,18)
nomeprog := "CFAT11R"
aLinha   := { }
nLastKey := 0
cPerg    := "FAT11R"
lEnd     := .F.
li       := 0
nTotVista:= 0
nTotPrazo:= 0
nTotGeral:= 0
nTotIss1 := 0
nTotIss2 := 0
nTotIssG := 0
nDevMerc := 0
nDevBrut := 0
nDevGeral:= 0
nDevIss1 := 0
nDevIss2 := 0
nDevIssG := 0
cNota    := " " 
cNotaOri := " "
nFlag    := 0
nFlag1   := 0    // CONTROLA O CABECALHO
nCount   := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SD2") // Itens das Notas Fiscais de Saida
DbSetOrder(1)       // Produto + Nota Fiscal

DbSelectArea("SF2") // Cabecalho das Notas Fiscais
DbSetOrder(1)       // Nota Fiscal

DbSelectArea("SE4") // Condicoes de Pagamentos
DbSetOrder(1)       // Codigo

DbSelectArea("SE1") // Contas a Receber
DbSetOrder(1)       // Numero do Titulo

DbSelectArea("SF4") // Tipos de Entrada/Saida
DbSetOrder(1)       // Codigo

DbSelectArea("SA1") // Cadastro de Clientes
DbSetOrder(1)       // Codigo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados                                                     *
*                                                                           *
* MV_PAR01      //----> Da Emissao                                          *
* MV_PAR02      //----> Ate a Emissao                                       *
* MV_PAR03      //----> TES Faturamento                                     *
* MV_PAR04      //----> TES Devolucao                                       *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.f.)

wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento e Impressao do Relatorio                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({|| RunProc()},"Faturamento Assistencia Tecnica")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({|| Execute(RunProc)},"Faturamento Assistencia Tecnica")

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

_cChave  := "Dtos(D2_EMISSAO) + D2_DOC + D2_SERIE + D2_TES"
_cFiltro := "D2_FILIAL == xFilial('SD2') .And. Dtos(D2_EMISSAO) >= Dtos(MV_PAR01) .And. Dtos(D2_EMISSAO) <= Dtos(MV_PAR02) .And.D2_TES $ MV_PAR03+MV_PAR04"
_cIndice := CriaTrab(Nil,.f.) 

DbSelectArea("SD2")
IndRegua("SD2",_cIndice,_cChave,,_cFiltro,"Criando Indice...")
DbGoTop()
ProcRegua(RecCount() - Recno())

@ li,000 PSAY Avalimp(limite)
Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

Do While Eof() == .f.
    IncProc("Processando dados NF: "+SD2->D2_DOC+"/"+SD2->D2_SERIE)

    cNota := SD2->D2_DOC

    If li > 58
        Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
    Endif

    If SD2->D2_EMISSAO < mv_par01 .or. SD2->D2_EMISSAO > mv_par02
        DbSkip()
        Loop
    EndIf

    While SD2->D2_DOC == cNota
        If !SD2->D2_TES $ mv_par03
            DbSkip()
            Loop
        Else
            If li == 0
                Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
            EndIf

            If nFlag == 0
                @ li,000 PSAY SD2->D2_DOC+"-"+SD2->D2_SERIE
                @ li,012 PSAY Iif(SD2->D2_TES == "549", "ASSIS TECNICA", "PREST SERVICO")
                @ li,026 PSAY SD2->D2_EMISSAO
                @ li,037 PSAY SD2->D2_CLIENTE+"/"+SD2->D2_LOJA
                nFlag := 1

                DbSelectArea("SA1")
                DbSeek(xFilial()+SD2->D2_CLIENTE+SD2->D2_LOJA)
                @ li,047 PSAY SubStr(SA1->A1_NOME,1,20)

                DbSelectArea("SF2")
                DbSeek(xFilial()+SD2->D2_DOC+SD2->D2_SERIE)

                DbSelectArea("SE4")
                DbSeek(xFilial()+SF2->F2_COND)
                cCondPag:= SE4->E4_COND
                If Val(cCondPag) == 0
                    @ li,067 PSAY SF2->F2_VALFAT Picture "@E 999,999,999.99"
                    @ li,100 PSAY SUBS(SE4->E4_DESCRI,1,16)
                    @ li,118 PSAY SF2->F2_VALISS Picture "@E 999,999,999.99"
                    nTotVista := nTotVista + SF2->F2_VALFAT
                    nTotIss1  := nTotIss1  + SF2->F2_VALISS
                Else
                    @ li,082 PSAY SF2->F2_VALFAT Picture "@E 999,999,999.99"
                    @ li,100 PSAY SUBS(SE4->E4_DESCRI,1,16)
                    @ li,118 PSAY SF2->F2_VALISS Picture "@E 999,999,999.99"
                    nTotPrazo := nTotPrazo + SF2->F2_VALFAT
                    nTotIss2  := nTotIss2  + SF2->F2_VALISS
                EndIf
                li:=li+1
            EndIf
        EndIf
        cNota:= SD2->D2_DOC
        DbSelectArea("SD2")
        DbSkip()
    End
    nFlag:= 0
    cNota:= SD2->D2_DOC
End

li:=li+1
nTotGeral := nTotVista + nTotPrazo
nTotIssG  := nTotIss1  + nTotIss2
@ li,000 PSAY "TOTAIS POR COND.PAGTO."
@ li,067 PSAY nTotVista Picture "@e 999,999,999.99"
@ li,082 PSAY nTotPrazo Picture "@e 999,999,999.99"
li:=li+1
@ li,000 PSAY Replicate("-",Limite)
li:=li+1
@ li,000 PSAY "TOTAL GERAL (FATURAMENTO / ISS)"
@ li,082 PSAY nTotGeral Picture "@e 999,999,999.99"
@ li,117 PSAY nTotIssG  Picture "@e 999,999,999.99"
li:=li+3

DbSelectArea("SD2")
DbGoTop()

cabec3   := "NF's/SERIE NF'S CLIENTE DATA EMISSAO COD.CLI   RAZAO SOCIAL CLIENTE    TOTAL MERC  TOTAL DA NOTA          "

If  li < 58
    @ li,000 PSAY Repl("*",Limite)
    li := li + 1
    @ li,000 PSAY cabec3
    li := li + 1
    @ li,000 PSAY Repl("*",Limite)
    li := li + 2
Endif

Do While Eof() == .f.
    IncProc("Processando dados NF: "+SD2->D2_DOC+"/"+SD2->D2_SERIE)

    cNota := SD2->D2_DOC

    If li > 58
        Cabec(titulo,cabec3,cabec2,nomeprog,tamanho,nTipo)
    Endif

    If SD2->D2_EMISSAO < mv_par01 .or. SD2->D2_EMISSAO > mv_par02
        DbSkip()
        Loop
    EndIf

    While SD2->D2_DOC == cNota
        If !SD2->D2_TES $ mv_par04
            DbSkip()
            Loop
        Else
            If SD2->D2_NFORI #cNotaOri .And. nCount < 1
                @ li,000 PSAY SD2->D2_DOC+"-"+SD2->D2_SERIE
                @ li,012 PSAY SD2->D2_NFORI+"-"+SD2->D2_SERIORI
                @ li,026 PSAY SD2->D2_EMISSAO
                @ li,037 PSAY SD2->D2_CLIENTE+"/"+SD2->D2_LOJA

                DbSelectArea("SA1")
                DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
                @ li,047 PSAY SubStr(SA1->A1_NOME,1,20)

                DbSelectArea("SF2")
                DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE)

                @ li,067 PSAY (SF2->F2_VALBRUT - SF2->F2_VALFAT) Picture "@E 999,999,999.99"
                @ li,082 PSAY SF2->F2_VALBRUT Picture "@E 999,999,999.99"

                nDevMerc := nDevMerc + (SF2->F2_VALBRUT - SF2->F2_VALFAT)
                nDevBrut := nDevBrut + SF2->F2_VALBRUT
                li:=li+1
                nCount := nCount + 1
            ElseIf SD2->D2_NFORI #cNotaOri .And. nCount >= 1
                @ li,012 PSAY SD2->D2_NFORI+"-"+SD2->D2_SERIORI
                li:=li+1
            EndIf
        EndIf
        cNota    := SD2->D2_DOC
        cNotaOri := SD2->D2_NFORI
        DbSelectArea("SD2")
        DbSkip()
    End
    cNota  := SD2->D2_DOC
    nCount := 0
End

li:=li+1
@ li,000 PSAY Replicate("-",Limite)
li:=li+1
@ li,000 PSAY "TOTAL GERAL (DEVOLUCOES)"        
@ li,067 PSAY nDevMerc Picture "@e 999,999,999.99"
@ li,082 PSAY nDevBrut Picture "@e 999,999,999.99"

Roda(cbCont,"ASTEC","M")

DbSelectArea("SD2")
Set Filter To
DbSetOrder(1)
Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

DbSelectArea("SD2")
RetIndex("SD2")

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Da Emissao     ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','TES Faturamento','mv_ch3','C',20, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','TES Devolucao  ','mv_ch4','C',20, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})

    For i:=1 to len(aRegs)
        Dbseek(cPerg+strzero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (CFAT11R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
