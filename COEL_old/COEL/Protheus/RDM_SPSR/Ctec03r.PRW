#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

User Function Ctec03r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,LDIC")
SetPrvt("LCOMP,LFILTRO,WNREL,NOMEPROG,TAMANHO,LIMITE")
SetPrvt("AORDEM,CPERG,ARETURN,LEND,M_PAG,NLASTKEY")
SetPrvt("LI,NFOLHA,NITEM,CBCONT,CBTEXT,CMEMO")
SetPrvt("_M,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> #DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CTEC03R  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Chamado Tecnico (Ordem de Manutencao)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Coel Controles Eletricos Ltda                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Titulo  := "Impressao do Chamado Tecnico"
cDesc1  := "Este programa ira emitir os chamados tecnicos conforme os"  
cDesc2  := "parametros solicitados."  
cDesc3  := ""  
cString := "AB1"  // Alias utilizado na Filtragem
lDic    := .F.    // Habilita/Desabilita Dicionario
lComp   := .T.    // Habilita/Desabilita o Formato Comprimido/Expandido
lFiltro := .T.    // Habilita/Desabilita o Filtro
wnrel   := "CTEC03R"      // Nome do Arquivo utilizado no Spool
nomeprog:= "CTEC03R"      // nome do programa
Tamanho := "M" // P/M/G
Limite  := 132 // 80/132/220
aOrdem  := {}  // Ordem do Relatorio
cPerg   := "ATR300"  // Pergunta do Relatorio
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } 
                        //[1] Reservado para o Formulario
                        //[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)
lEnd    := .F.// Controle de cancelamento do relatorio
m_pag   := 1  // Contador de Paginas
nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

#IFDEF WINDOWS
    RptStatus({|| ImpDet()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(ImpDet)})
#ELSE
    ImpDet()
#ENDIF
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ IMPDET   ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRESSAO DOS ITENS DO CHAMADO TECNICO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TECRCHA                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpDet
Static Function ImpDet()

li      := 100 // Contador de Linhas
nFolha  := 01  // Contador de Paginas
nItem   := 01  // Contador de Itens p/ Chamado Tecnico
cbCont  := 0   // Numero de Registros Processados
cbText  := ""  // Mensagem do Rodape
cMemo   := ""
_m      :=0    // Contador de Observacoes 
dbSelectArea(cString)
SetRegua(LastRec())
dbSetOrder(1)
dbSeek(xFilial("AB1")+MV_PAR01,.T.)

While ( !Eof() .And. xFilial("AB1")	== AB1->AB1_FILIAL .And.;
							MV_PAR02       >= AB1->AB1_NRCHAM )
    nFolha := 1
    nItem  := 1
    #IFNDEF WINDOWS
        If LastKey() == 286
			lEnd := .T.
		EndIf
	#ENDIF
	If lEnd
        @ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
    Li := 14
    dbSelectArea("AB2")
	dbSetOrder(1)
	dbSeek(xFilial("AB2")+AB1->AB1_NRCHAM)
	While ( !Eof() .And. xFilial("AB2")	==AB2->AB2_FILIAL .And.;
								AB1->AB1_NRCHAM==AB2->AB2_NRCHAM )
		If ( Li > 54 )
            nFolha := nFolha + 1
            nItem  := nItem  + 1
            Li := 14
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Registros                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AAG")
		dbSetOrder(1)
		dbSeek(xFilial("AAG")+AB2->AB2_CODPRB)
		dbSelectArea("AA3")
		dbSetOrder(1)
		dbSeek(xFilial("AA3")+AB1->AB1_CODCLI+AB1->AB1_LOJA+AB2->AB2_CODPRO+AB2->AB2_NUMSER)

        dbSelectArea("SA1")
        dbSetOrder(1)
        dbSeek(xFilial("SA1")+AB1->AB1_CODCLI+AB1->AB1_LOJA)

        dbSelectArea("SB1")
        dbSetOrder(1)
        dbSeek(xFilial("SB1")+AB2->AB2_CODPRO)

        //Regua                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
        //             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        
        @ 00,000 PSAY AvalImp(Limite)
        @ 03,000 PSAY "+==================================================================================================================================+"
        @ 04,000 PSAY "|              O  R  D  E  M     D  E     M  A  N  U  T  E  N  C  A  O              "
        @ 04,000 PSAY "               O  R  D  E  M     D  E     M  A  N  U  T  E  N  C  A  O              "
        @ 04,000 PSAY "               O  R  D  E  M     D  E     M  A  N  U  T  E  N  C  A  O              "
        @ 04,085 PSAY "|Nr. OM: "+AB1->AB1_NRCHAM+"/"+StrZero(nItem,2) 
        @ 04,114 PSAY "|Folha: "
        @ 04,125 PSAY StrZero(nFolha,3)
        @ 04,131 PSAY "|"
        @ 05,000 PSAY "+==================================================================================================================================+"
        @ 06,000 PSAY "|                                                                                                                                  |"
        @ 07,000 PSAY "|Cliente   : "+AB1->AB1_CODCLI+"/"+AB1->AB1_LOJA+" "+SA1->A1_NOME
        @ 07,095 PSAY "Telefone  : "+SA1->A1_TEL
        @ 07,131 PSAY "|"
        @ 08,000 PSAY "|Emissao   : "
        @ 08,013 PSAY AB1->AB1_EMISSA
        @ 08,095 PSAY "Contato   : "+AB1->AB1_CONTAT
        @ 08,131 PSAY "|"
        @ 09,000 PSAY "|Atendente : "+AB1->AB1_ATEND
        @ 09,095 PSAY "Hora      : "+AB1->AB1_HORA
        @ 09,131 PSAY "|"
        @ 10,000 PSAY "|Nf Entrada: "+AB1->AB1_CLNFE
        @ 10,026 PSAY "Data Emissao Nf: "
        @ 10,044 PSAY AB1->AB1_CLDATA                                                                                                                     
        @ 10,131 PSAY "|"
        @ 11,000 PSAY "+--+----------+---------+-----------------------------+------------+--------------------------------------+----------+-------------+"
        @ 12,000 PSAY "|It|   Tipo   | Produto |           Descricao         |  Nr.Serie  |              Problema                | Garantia | Quantidade  |"
        @ 13,000 PSAY "+--+----------+---------+-----------------------------+------------+--------------------------------------+----------+-------------+"
        @ Li,000 PSAY "|"+AB2->AB2_ITEM
        @ Li,003 PSAY "|"+X3Combo("AB2_TIPO",AB2->AB2_TIPO)
        @ Li,014 PSAY "|"+AB2->AB2_CODPRO
        @ Li,025 PSAY "|"+SubStr(SB1->B1_DESC,1,29)   
        @ Li,055 PSAY "|"+AB2->AB2_NUMSER
        @ Li,068 PSAY "|"+SubStr(AB2->AB2_CODPRB,1,3)+" - "+AAG->AAG_DESCRI
        @ Li,107 PSAY "|"
        @ Li,109 PSAY AA3->AA3_DTGAR
        @ Li,118 PSAY "|" 
        @ Li,120 PSAY AB2->AB2_CLQTDE 
        @ Li,132 PSAY "|"
        Li:=Li+1
        @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
        Li:=Li+1
        @ Li,000 PSAY "|Observacoes: "
        @ Li,014 PSAY AB2->AB2_CLOBS
        @ Li,131 PSAY "|"
        Li:=Li+1
        @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"

        While Li < 51
            If _m ==0
                Li:=Li+1
                @ Li,000 PSAY "|                                        |                               M A T E R I A L    A P L I C A D O                        |"
                Li:=Li+1
                @ Li,000 PSAY "|                DEFEITOS                +----------------+-----------+----------------------------------------------+-------------+"
                Li:=Li+1
                @ Li,000 PSAY "|                                        |     CODIGO     |    QTD    |                   DESCRICAO                  |    PRECO    |"
                Li:=Li+1
                @ Li,000 PSAY "+----------------------------------------+----------------+-----------+----------------------------------------------+-------------+"
                _m:=1
            EndIf
                Li:=Li+1
                @ Li,000 PSAY "|                                        |                |           |                                              |             |"
                Li:=Li+1
                @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
        EndDo

		dbSelectArea("AB2")
		dbSkip()
        Li:=Li+1
        _m:=0

            @ Li,000 PSAY "|                                        |                |           |                         |  MAO-DE-OBRA ----> |             |"
            Li:=Li+1
            @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
            Li:=Li+1
            @ Li,000 PSAY "|                                        |                |           |                         |         TAXA ----> |             |"
            Li:=Li+1
            @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
            Li:=Li+1
            @ Li,000 PSAY "|                                        |                |           |                         |        TOTAL ----> |             |"
            Li:=Li+1
            @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
            Li:=Li+1
            @ Li,000 PSAY "| Coel Controles Eletricos Ltda                                                                                Assistencia Tecnica |"
            Li:=Li+1
            @ Li,000 PSAY "+==================================================================================================================================+"
    EndDo

    dbSelectArea("AB1")
	dbSkip()
    cbCont:=cbCont+1
	IncRegua()
EndDo
dbSelectArea(cString)
dbClearFilter()
Set Device To Screen
Set Printer To
If ( aReturn[5] == 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


