#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE CHRCOMP If(aReturn[4] == 1,15,18)

User Function Ctec04r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,LDIC")
SetPrvt("LCOMP,LFILTRO,WNREL,NOMEPROG,TAMANHO,LIMITE")
SetPrvt("AORDEM,CPERG,ARETURN,LEND,M_PAG,NLASTKEY")
SetPrvt("LI,NFOLHA,CBCONT,CBTEXT,_NSUBTOT,_NTOTAL")
SetPrvt("_NITENS,NHANDLE,TAMDOBUFFER,BUFFER,")



#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> #DEFINE CHRCOMP If(aReturn[4] == 1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  CTEC04R ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³03.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Orcamento.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
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
Titulo  := "Impressao do Orcamento"
cDesc1  := "Este programa ira emitir os Orcamentos conforme os parametros"
cDesc2  := "solicitados."
cDesc3  := " "
cString := "AB3"  // Alias utilizado na Filtragem
lDic    := .F.    // Habilita/Desabilita Dicionario
lComp   := .T.    // Habilita/Desabilita o Formato Comprimido/Expandido
lFiltro := .T.    // Habilita/Desabilita o Filtro
wnrel   := "CTEC04R"    // Nome do Arquivo utilizado no Spool
nomeprog:= "CTEC04R"    // nome do programa
Tamanho := "M" // P/M/G
Limite  := 132 // 80/132/220
aOrdem  := {}  // Ordem do Relatorio
cPerg   := "ATR400"  // Pergunta do Relatorio
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } 
						//[1] Reservado para Formulario
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
±±³Programa  ³  IMPDET  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³03.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRESSAO DOS DETALHES DO ORCAMENTO                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³TECRORC()                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpDet
Static Function ImpDet()

Li      := 0 // Contador de Linhas
nFolha  := 01
cbCont  := 0   // Numero de Registros Processados
cbText  := ""  // Mensagem do Rodape
_nSubTot:= 0
_nTotal := 0
_nItens := 1
dbSelectArea(cString)
SetRegua(LastRec())
dbSetOrder(1)
dbSeek(xFilial("AB3")+MV_PAR01,.T.)
Do While ( !Eof() .And. xFilial("AB3") == AB3->AB3_FILIAL .And.;
							MV_PAR02       >= AB3->AB3_NUMORC )
   nFolha := 01
	#IFNDEF WINDOWS
        If LastKey() == 286
			lEnd := .T.
		EndIf
	#ENDIF
	If lEnd
        @ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Posiciona Registros                                                     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dbSelectArea("SA1")
   dbSetOrder(1)
   dbSeek(xFilial("SA1")+AB3->AB3_CODCLI+AB3->AB3_LOJA)
   dbSelectArea("SE4")
   dbSetOrder(1)
   dbSeek(xFilial("SE4")+AB3->AB3_CONPAG)

   // Logotipo()

   @ Li,000 PSAY AvalImp(Limite)
	
   Cabec()
	
   Li:=25
   dbSelectArea("AB4")
	dbSetOrder(1)
	dbSeek(xFilial("AB4")+AB3->AB3_NUMORC)
   Do While ( !Eof() .And. xFilial("AB4") ==AB4->AB4_FILIAL .And.;
								AB3->AB3_NUMORC==AB4->AB4_NUMORC )
        If ( _nItens > 5 )
            nFolha:=nFolha+1
            Li := 25
            _nItens:=0
            @ 50,120 PSAY " << CONTINUA >>"
            Cabec()
        EndIf

      dbSelectArea("AAG")
		dbSetOrder(1)
		dbSeek(xFilial("AAG")+AB4->AB4_CODPRB)

      dbSelectArea("AA3")
		dbSetOrder(1)
		dbSeek(xFilial("AA3")+AB3->AB3_CODCLI+AB3->AB3_LOJA+AB4->AB4_CODPRO+AB4->AB4_NUMSER)

      dbSelectArea("SB1")
		dbSetOrder(1)
      dbSeek(xFilial("SB1")+AB4->AB4_CODPRO)

        @ Li,000 PSAY "|"+AB4->AB4_ITEM
        @ Li,003 PSAY "|"
        @ Li,004 PSAY AB4->AB4_CLQTDE Picture "@E 9,999"
        @ Li,014 PSAY "|"+Subs(AB4->AB4_CODPRO,1,9)
        @ Li,024 PSAY "|"+Subs(SB1->B1_DESC,1,25)
        @ Li,054 PSAY "|"+Subs(AB4->AB4_NUMSER,1,12)
        @ Li,067 PSAY "|   "+AB3->AB3_CLNFE
       // @ Li,070 PSAY "|"
        @ Li,083 PSAY AB3->AB3_CLDATA
       // @ Li,081 PSAY "|"

      dbSelectArea("AB5")
      dbSetOrder(1)
      dbSeek(xFilial("AB5")+AB4->AB4_NUMORC+AB4->AB4_ITEM)
      If Alltrim(AB5->AB5_CODPRO) >= "SERV00"
            DbSelectArea("AA5")
            DbSetOrder(1)
            DbSeek(xFilial()+AB5->AB5_CODSER)
            If AA5->AA5_PRCCLI == 0 .AND. AA5->AA5_PRCFAB == 0
                @ Li,097 PSAY "   --   "
                //_nSubTot:= 0
            ElseIf AA5->AA5_PRCCLI == 0 .AND. AA5->AA5_PRCFAB > 0
                @ Li,097 PSAY "GARANTIA"
                //_nSubTot:= 0
            Else
                @ Li,093 PSAY AB5->AB5_VUNIT Picture "@E 999,999.99"
                //_nSubTot:= Round(AB5->AB5_VUNIT*AB5->AB5_QUANT,2)
            EndIf
            If !EMPTY(AB4->AB4_CLPROD)
                @ Li,108 PSAY "|     FORA DE LINHA "
              //  @ Li,132 PSAY "|"
            Else
//                @ Li,108 PSAY "|"
               // @ Li,109 PSAY (SB1->B1_PRV1+(SB1->B1_PRV1*(SB1->B1_IPI/100))) Picture "@E 999,999,999.99"
  //              @ Li,124 PSAY "|"
               // @ Li,126 PSAY SB1->B1_IPI Picture "@E 99.99"
                @ Li,131 PSAY "|"
            EndIf
          //  Li:=Li+1
          //  @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"

            dbSelectArea("SB1")
            dbSetOrder(1)
            dbSeek(xFilial("SB1")+AB4->AB4_CLPROD)

            Li:=Li+1
            If !EMPTY(AB4->AB4_CLPROD)
                @ Li,000 PSAY "| Produto Substituto : "
                @ Li,024 PSAY "|        "+SUBSTR(SB1->B1_DESC,1,30)
                @ Li,055 PSAY "| $ Unit. c/IPI: "
                //@ Li,072 PSAY (SB1->B1_PRV1+(SB1->B1_PRV1 * (SB1->B1_IPI/100))) Picture "@E 999,999.99"
                @ Li,084 PSAY "| %IPI |"
                //@ Li,093 PSAY SB1->B1_IPI Picture "@E 99.99"
                @ Li,100 PSAY "|"
        //        @ Li,132 PSAY "|"
        //        Li:=Li+1
        //        @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
                Li:=Li+1
            EndIf
            @ Li,000 PSAY "|"
            @ Li,131 PSAY "|"            
       //     @ Li,100 PSAY "| Sub-Total --> |"
       //     @ Li,116 PSAY _nSubTot Picture "@E 999,999,999.99"
      //      @ Li,131 PSAY "|"
      //      Li:=Li+1
      //      @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
      EndIf
                            
		_nTotal:=_NTotal + Round(AB5->AB5_VUNIT*AB5->AB5_QUANT,2)
      //_nTotal:=_nTotal+_nSubTot
      dbSelectArea("AB4")
		dbSkip()
      Li:=Li+1
      _nItens:=_nItens+1
   EndDo
   @ Li,000 PSAY "|"
   @ Li,100 PSAY "| Total ------> |"
   @ Li,116 PSAY _nTotal Picture "@E 999,999,999.99"
   @ Li,130 PSAY "|"
   Li:=Li+1
   @ Li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
   Li:=Li+1
   _nTotal:=0
	m_Observ := ALLTRIM(AB3->AB3_CLOBS)
   If _nItens == 1
      @ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      Li:=Li+1
      @ Li,000 PSAY "|"+LEFT(m_Observ,130)
      @ Li,131 PSAY "|"
      Li:=Li+1
		IF ( !EMPTY(SUBS(m_Observ,131,10)) )
			@ Li,000 PSAY "|"+SUBS(m_Observ,131,70)
			@ Li,131 PSAY "|"
		ELSE	
			@ Li,000 PSAY "|                                                                                                                                  |"
		ENDIF	
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
   ElseIf _nItens == 2
      //@ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      //Li:=Li+1
      //@ Li,000 PSAY "|"+AB3->AB3_CLOBS
      //@ Li,131 PSAY "|"
      //Li:=Li+1
      //@ Li,000 PSAY "|                                                                                                                                  |"
      @ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      Li:=Li+1
      @ Li,000 PSAY "|"+LEFT(m_Observ,130)
      @ Li,131 PSAY "|"
      Li:=Li+1
		IF ( !EMPTY(SUBS(m_Observ,131,10)) )
			@ Li,000 PSAY "|"+SUBS(m_Observ,131,70)
			@ Li,131 PSAY "|"
		ELSE	
			@ Li,000 PSAY "|                                                                                                                                  |"
		ENDIF	
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
   ElseIf _nItens == 3
      //@ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      //Li:=Li+1
      //@ Li,000 PSAY "|"+AB3->AB3_CLOBS
      //@ Li,131 PSAY "|"
      //Li:=Li+1
      //@ Li,000 PSAY "|                                                                                                                                  |"
      @ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      Li:=Li+1
      @ Li,000 PSAY "|"+LEFT(m_Observ,130)
      @ Li,131 PSAY "|"
      Li:=Li+1
		IF ( !EMPTY(SUBS(m_Observ,131,10)) )
			@ Li,000 PSAY "|"+SUBS(m_Observ,131,70)
			@ Li,131 PSAY "|"
		ELSE	
			@ Li,000 PSAY "|                                                                                                                                  |"
		ENDIF	
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
   ElseIf _nItens == 4
      //@ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      //Li:=Li+1
      //@ Li,000 PSAY "|"+AB3->AB3_CLOBS
      //@ Li,131 PSAY "|"
      //Li:=Li+1
      //@ Li,000 PSAY "|                                                                                                                                  |"
      @ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      Li:=Li+1
      @ Li,000 PSAY "|"+LEFT(m_Observ,130)
      @ Li,131 PSAY "|"
      Li:=Li+1
		IF ( !EMPTY(SUBS(m_Observ,131,10)) )
			@ Li,000 PSAY "|"+SUBS(m_Observ,131,70)
			@ Li,131 PSAY "|"
		ELSE	
			@ Li,000 PSAY "|                                                                                                                                  |"
		ENDIF	
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
      @ Li,000 PSAY "|                                                                                                                                  |"
      Li:=Li+1
   ElseIf _nItens == 5
      //@ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      //Li:=Li+1
      //@ Li,000 PSAY "|"+AB3->AB3_CLOBS
      //@ Li,131 PSAY "|"
      //Li:=Li+1
      //@ Li,000 PSAY "|                                                                                                                                  |"
      @ Li,000 PSAY "|Observacoes:                                                                                                                      |"
      Li:=Li+1
      @ Li,000 PSAY "|"+LEFT(m_Observ,130)
      @ Li,131 PSAY "|"
      Li:=Li+1
		IF ( !EMPTY(SUBS(m_Observ,131,10)) )
			@ Li,000 PSAY "|"+SUBS(m_Observ,131,70)
			@ Li,131 PSAY "|"
		ELSE	
			@ Li,000 PSAY "|                                                                                                                                  |"
		ENDIF	
      Li:=Li+1
   EndIf
   @ Li,000 PSAY "| GARANTIA DO CONSERTO: 90 Dias                                                                                                    |"
   Li:=Li+1
   @ Li,000 PSAY "| RETIRADA DE MATERIAS: de Segunda a Sexta, das 8:00 as 12:00 e das 13:00 as 17:00 horas                                           |"
   Li:=Li+1
   @ Li,000 PSAY "| APOS APROVACAO DO MESMO, INFORMAR A TRANSPORTADORA.                                                                              |"
   Li:=Li+1
   @ Li,000 PSAY "|                                                                                                                                  |"
   Li:=Li+1
   @ Li,000 PSAY "| ATENCIOSAMENTE                                                                                                                   |"
   Li:=Li+1
   @ Li,000 PSAY "|                                                                                                                                  |"
   Li:=Li+1
   @ Li,000 PSAY "|                                                                                                                                  |"
   Li:=Li+1
   @ Li,000 PSAY "|                                                                                                                                  |"
   Li:=Li+1
   @ Li,000 PSAY "| "+Alltrim(AB3->AB3_ATEND)+" / ASSISTENCIA TECNICA"
   @ Li,131 PSAY "|"
   Li:=Li+1
   @ Li,000 PSAY "|                                                                                                                                  |"
   Li:=Li+1                                                                                                                         
   @ Li,000 PSAY "+==================================================================================================================================+"
    //////        0---------1---------2---------3---------4---------5---------6---------7---------8---------9---------100-------110-------120-------130      
    //////        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012     
   Li:=Li+1
   ///@ Li,000 PSAY "COEL CONTROLES ELETRICOS LTDA.  -  CNPJ: 51.755.304/0001-08                                                      ASSISTENCIA TECNICA"
	@ Li,000 PSAY RTRIM(SM0->M0_NOMECOM) + "  -  CNPJ: "+TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
	@ Li,113 PSAY "ASSISTENCIA TECNICA"
   Li:=Li+1
   ///@ Li,000 PSAY "RUA CASA DO ATOR, 685 - VILA OLÍMPIA                                                                 CEP: 04546-002 - SAO PAULO - SP"
	@ Li,000 PSAY RTRIM(SM0->M0_ENDENT) + " - "+RTRIM(SM0->M0_BAIRENT)
	@ Li,101 PSAY "CEP: "+TRANSF(SM0->M0_CEPENT,"@R 99999-999")+" - "+RTRIM(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
   Li:=Li+1
   ///@ Li,000 PSAY "TELEFONE (0XX11) 3848-3311  -  e-mail: astec@coel.com.br                                                       FAX (0XX11) 3848-3301"
	@ Li,000 PSAY "TELEFONE "+TRANSF(SUBS(SM0->M0_TEL,3,10),"@R (99)9999-9999")+"  -  e-mail: astec@coel.com.br"
	@ Li,115 PSAY "FAX "+TRANSF(SUBS(SM0->M0_FAX,3,10),"@R (99)9999-9999")
   Li:=Li+3
   @ Li,000 PSAY '"A Satisfação do Cliente é o Principal Propósito da Coel"                                                                   ISO-9002'         

   dbSelectArea("AB3")
	dbSkip()
   cbCont:=cbCont+1
	IncRegua()

   _nItens := 0
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  CABEC   ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³03.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRESSAO DO CABECALHO DO ORCAMENTO                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³IMPDET()                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Cabec
Static Function Cabec()
    //                       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
    //             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //@ 01,000 PSAY LogoTipo(nHandle,0)
    @ 01,000 PSAY " COEL CONTROLES ELETRICOS LTDA " + CHR(15)
//    @ 01,000 PSAY " COEL CONTROLES ELETRICOS LTDA " + CHR(15)
//    @ 01,000 PSAY " COEL CONTROLES ELETRICOS LTDA " + CHR(15)
//    @ 01,000 PSAY " COEL CONTROLES ELETRICOS LTDA " + CHR(15)
    @ 06,000 PSAY "+==================================================================================================================================+"
    @ 07,000 PSAY "|                 O  R  C  A  M  E  N  T  O     T  E  C  N  I  C  O                          "
//    @ 07,000 PSAY "|                 O  R  C  A  M  E  N  T  O     T  E  C  N  I  C  O                          "
//    @ 07,000 PSAY "|                 O  R  C  A  M  E  N  T  O     T  E  C  N  I  C  O                          "
//    @ 07,000 PSAY "|                 O  R  C  A  M  E  N  T  O     T  E  C  N  I  C  O                          "
    @ 07,093 PSAY "| Nr.Orcamento: "+AB3->AB3_NUMORC
    @ 07,116 PSAY "| Folha: "
    @ 07,125 PSAY StrZero(nFolha,3)
    @ 07,131 PSAY "|"
    @ 08,000 PSAY "+==================================================================================================================================+"
    @ 09,000 PSAY "|                                                                                                                                  |"
    @ 10,000 PSAY "| Cliente : "+AB3->AB3_CODCLI+"/"+AB3->AB3_LOJA+" - "+SA1->A1_NOME
    @ 10,131 PSAY "|"
    @ 11,000 PSAY "| Endereco: "+SA1->A1_END+" "+SA1->A1_MUN+" "+SA1->A1_EST
    @ 11,131 PSAY "|"
    @ 12,000 PSAY "| Cep     : "+SA1->A1_CEP 
    @ 12,131 PSAY "|" 
    @ 13,000 PSAY "|                                                                                                                                  |"
    @ 14,000 PSAY "| Tel     : "+SA1->A1_TEL+"          Fax     : "+SA1->A1_FAX
    @ 14,131 PSAY "|"
    @ 15,000 PSAY "| A/C     : Depto. Compras                                                                                                         |"
    @ 16,000 PSAY "|                                                                                                                                  |"
    @ 17,000 PSAY "|Emissao  :"
    @ 17,012 PSAY AB3->AB3_EMISSA
    @ 17,131 PSAY "|"
    @ 18,000 PSAY "|Atendente: "+AB3->AB3_ATEND
    @ 18,131 PSAY "|" 
    @ 19,000 PSAY "|Cond.Pag.: "+AB3->AB3_CONPAG+" - "+SE4->E4_DESCRI
    @ 19,131 PSAY "|" 
    @ 20,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
    @ 21,000 PSAY "|R  E  L  A  C  A  O     D  E     A  P  A  R  E  L  H  O  S     E  N  T  R  E  G  U  E  S     P  A  R  A     C  O  N  S  E  R  T  O|"
    @ 22,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"
    @ 23,000 PSAY "|It|   Qtde   | Produto |          Descricao          | Nr. Serie | Nr.NF Entrada |Data NF |$ Unit.Conserto|                       |"
    @ 24,000 PSAY "+--+----------+---------+-----------------------------+-----------+------------------------+---------------+-----------------------+"
    //                       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
    //             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function LogoTipo
Static Function LogoTipo()

     // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     // ³ Impressao do Logotipo da empresa                       ³
     // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     nHandle     := FOpen("LOGO.PRN",0)
     TamDoBuffer := FSeek(nHandle,0,2)
     FSeek(nHandle,0)
     Buffer  := Space(TamDoBuffer)
     IF FRead(nHandle,@Buffer,TamDoBuffer)!=TamDoBuffer
        ALERT('Erro na leitura do header... (Li '+ALLTRIM(STR(TamDoBuffer))+' bytes)')
     Else
      @00,00 PSAY Buffer
     Endif
     FClose(nHandle)

Return .t.

