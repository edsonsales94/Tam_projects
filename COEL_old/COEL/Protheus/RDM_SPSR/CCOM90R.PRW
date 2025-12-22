#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Ccom90r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,_NSOL")
SetPrvt("_NCOUNT,CABEC1,CABEC2,NPAG,_CARQIND,_CCHAVE")
SetPrvt("_CFILTRO,_NCONT,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM90R  ³ Autor ³Adilson M Takeshima    ³ Data ³05/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Solicitacoes de Compras                         ³±±
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
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CCOM90R"
cDesc1    := "Relacao de Solicitacoes de Compras"
cDesc2    := " "
cDesc3    := " "
cString   := "SC1"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "RELACAO DE SOLICITACOES DE COMPRAS"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CCOM90R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "COM90R"
nLin      := 7
m_pag     := 1
_nSol     := 0
_nCount   := 0          //----> Incrementador da regua de processamento

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> DA FILIAL      ?                                          *
* mv_par02  ----> ATE A FILIAL   ?                                          *
* mv_par03  ----> DA DATA        ?                                          *
* mv_par04  ----> ATE A DATA     ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*
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
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()

          //0         1         2         3         4         5         6         7         8         9        10         11       12    12
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456     
cabec1  := "FI EMISSAO  NR.SOL IT CD.PRODUTO DESCRICAO DO PRODUTO      QUANTIDADE DT.NECES OBSERVACOES                    SOLICITANT NUM PC"                          
          //99 99/99/99 999999 99 99.999.999 1234567890123456789012345 999.999,99 99/99/99 123456789012345678901234567890 1234567890 999999

cabec2  := ""
titulo  := "**** RELACAO DE SOLICITACOES DE COMPRAS ****" 

Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

nLin := 8
nPag := 1
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
DbSelectArea("SC1")         //----> Solicitacoes de Compras
_cArqInd :=  CriaTrab(Nil,.f.)
_cChave  := "C1_FILIAL + DTOS(C1_EMISSAO) + C1_NUM + C1_ITEM"
_cFiltro := "DTOS(C1_EMISSAO) >= DTOS(MV_PAR03) .AND. DTOS(C1_EMISSAO) <= DTOS(MV_PAR04)"
IndRegua("SC1",_cArqInd,_cChave,,_cFiltro,"Buscando Registros: "+Dtoc(mv_par03)+" "+Dtoc(mv_par04))

DbGoTop()

@ nLin, 000 PSAY AvalImp( Limite )

_nSol  := SC1->C1_NUM
_nCont := 0
Do While !Eof()
   Incregua()
   If  SC1->C1_FILIAL < mv_par01 .OR. SC1->C1_FILIAL > mv_par02
       DbSkip()
       Loop
   Endif

   @nLin,  00 PSAY SC1->C1_FILIAL
   @nLin,  03 PSAY DTOC(SC1->C1_EMISSAO)
   If  _nCont == 0
        @nLin,  12 PSAY SC1->C1_NUM
        _nCont := 1
   Endif
   If  SC1->C1_NUM <> _nSol
       _nSol := SC1->C1_NUM
        @nLin,  12 PSAY SC1->C1_NUM
   Endif
   @nLin,  19 PSAY SC1->C1_ITEM
   @nLin,  22 PSAY SC1->C1_PRODUTO
   @nLin,  33 PSAY SC1->C1_DESCRI
   @nLin,  59 PSAY SC1->C1_QUANT
   @nLin,  70 PSAY DTOC(SC1->C1_DATPRF)
   @nLin,  79 PSAY SC1->C1_OBS
   @nLin, 110 PSAY SC1->C1_SOLICIT
   @nLin, 121 PSAY SC1->C1_PEDIDO

   nLin := nLin + 1
   DbSkip() 

         If nLin > 59
            @ nLin, 000 Psay Replicate("-",87)+"Continua na Proxima Pagina----"
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            nLin := 8
         Endif

        DbSkip()
        Loop

EndDo

If nLin > 59
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   nLin := 7
Endif

nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

MS_FLUSH()

Return

*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da    Filial   ? ','mv_ch1','C',02, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate a Filial   ? ','mv_ch2','C',02, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Data Inicial   ? ','mv_ch3','D',08, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Data   Final   ? ','mv_ch4','D',08, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})

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
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
