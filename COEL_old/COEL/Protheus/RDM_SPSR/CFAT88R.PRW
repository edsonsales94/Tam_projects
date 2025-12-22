#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat88r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,_CINDSC61,_CCHASC61,CABEC1")
SetPrvt("CABEC2,NLIN,M_PAG,NFLAG,NNUMPED,AREGS")
SetPrvt("I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT88R  ³ Autor ³Adilson M Takeshima    ³ Data ³25/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Itens Faturados em S.Paulo para os Pedidos      ³±±
±±³          ³ de S.Paulo                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*

DbSelectArea("SC6")         //----> Itens dos Pedidos de Vendas
DbSetOrder(1)               //----> Filial + Numero 
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
wnrel     := "CFAT88R"
cDesc1    := "Pedidos Faturados em S.Paulo" 
cDesc2    := " "
cDesc3    := " "
cString   := "SC6"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "RELACAO PEDIDOS FATURADOS POR S.PAULO"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT88R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT88R"

*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da  Dt.Emissao ?                                          *
* mv_par02  ----> Ate Dt.Emissao ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

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

*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")

_cIndSC61 := CriaTrab(Nil,.f.)
_cChaSC61 := "SC6->C6_FILIAL+DTOS(SC6->C6_DATFAT)+SC6->C6_NUM+SC6->C6_ITEM"
IndRegua("SC6",_cIndSC61,_cChaSC61,,,"Selecionando Registros SC6 (Indice Temp) ...")

ProcRegua(RecCount())
DbSeek("01"+Dtos(mv_par01),.t.)

cabec1  := "*     REFERENTE AO PERIODO DE: "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02)
cabec2  := ""
                                                  
nLin := 7

@ 00,00 Psay AvalImp(limite)
m_pag     := 1

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
@ nLin, 000 PSAY "PEDIDO  COD.CLIENTE  NOME CLIENTE"
nLin := nLin + 1
nFlag   := 0
nNumped := 0
Do While !Eof() .And. SC6->C6_DATFAT <= mv_par02
    IncProc("Selecionando Dados do PEDIDO: "+SC6->C6_NUM)

    If  EMPTY(C6_NOTA)
        DbSkip()
        Loop
    Endif

    If  nFlag == 0
        ImpCab()
        nFlag := 1
        DbSkip()
    Endif

    If  nNumPed == C6_NUM
         @ nLin, 003 PSAY C6_ITEM
         @ nLin, 007 PSAY C6_PRODUTO             Picture"@R 99.999.999"
         @ nLin, 018 PSAY C6_DESCRI
         @ nLin, 050 PSAY C6_QTDENT              Picture "@E999,999.99"
         @ nLin, 058 PSAY C6_QTDVEN - C6_QTDENT  Picture "@E999,999.99"
         @ nLin, 073 PSAY C6_NOTA 
         nLin := nLin + 1
         If    nLin > 60                            
               @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
               cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
               DbSkip()
               nLin := 07
               @ nLin, 000 PSAY "PEDIDO  COD.CLIENTE  NOME CLIENTE"
               nLin := nLin + 1
               ImpCab()
         Endif
       Else
         @ nLin, 000 PSAY Replicate("*",limite)
         nLin := nLin + 1
         ImpCab()
    Endif

  DbSkip()

Enddo

Roda(cbCont,"Adilson",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

//DbCloseArea(_cIndSC61)
//Ferase(_cIndSC61+".idx")

MS_FLUSH()


Return

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da  Dt.Emissao ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Dt.Emissao ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})

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

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpCab
Static Function ImpCab()
   If    nLin > 56                            
         @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
         cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
         nLin := 07
         @ nLin, 000 PSAY "PEDIDO  COD.CLIENTE  NOME CLIENTE"
         nLin := nLin + 1
    Endif
    @ nLin, 000 PSAY C6_NUM
    @ nLin, 008 PSAY C6_CLI
    @ nLin, 014 PSAY "/"
    @ nLin, 015 PSAY C6_LOJA
    @ nLin, 021 PSAY Posicione("SA1",1,xFilial("SA1")+C6_CLI+C6_LOJA,"A1_NOME")
    nNumPed := C6_NUM
    nLin := nLin + 1
    @nLin, 00 PSAY "  ITEM PRODUTO    DESCRICAO DO PRODUTO           QUANTIDADE       SALDO  N.FISC"
    nLin := nLin + 1
    @ nLin, 003 PSAY C6_ITEM
    @ nLin, 007 PSAY C6_PRODUTO             Picture"@R 99.999.999"
    @ nLin, 018 PSAY C6_DESCRI
    @ nLin, 050 PSAY C6_QTDENT              Picture "@E999,999.99"
    @ nLin, 058 PSAY C6_QTDVEN - C6_QTDENT  Picture "@E999,999.99"
    @ nLin, 073 PSAY C6_NOTA 
    nLin := nLin + 1

Return
