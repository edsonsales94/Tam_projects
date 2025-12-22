#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Cfis01r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,CABEC1")
SetPrvt("CABEC2,NPAG,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFIS01R  ³ Autor ³Adilson M Takeshima    ³ Data ³11/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Tipos de Entradas e Saidas - TES                ³±±
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

wnrel     := "CFIS01R"
cDesc1    := "Relacao de TES"
cDesc2    := " "
cDesc3    := " "
cString   := "SF4"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "RELACAO DE TIPOS DE ENTRADAS E SAIDAS - TES"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFIS01R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FIS01R"
nLin      := 7
m_pag     := 1

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> DO TES         ?                                          *
* mv_par02  ----> ATE O TES      ?                                          *
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

//0         1         2         3         4         5         6         7         8         9        10         11  11
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
cabec1  := "TES TIPO    CFO  FINALIDADE                                         TEXTO NA NOTA        GRC TER ICM IPI DUP EST M1 M2"
//999 ENTRADA 9999 12345678901234567890123456789012345678901234567890 12345678901234567890 999 XXX SIM SIM SIM SIM 99 99

cabec2  := ""
titulo  := "**** RELACAO DE TIPOS DE ESTRADAS E SAIDAS - TES ****"

Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

nLin := 7
nPag := 1
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
dbSelectArea("SF4")         //----> Cadastro de Tes
dbSetOrder(1)               //----> Filial + Codigo
//dbGotop()
dbSeek(xFilial("SF4")+mv_par01,.F.)

Do While !Eof()
	
	Incregua()
	
/*	If  SF4->F4_CODIGO < mv_par01 .OR. SF4->F4_CODIGO > mv_par02
		DbSkip()
		Loop
	Endif*/
	
	@nLin,  00 PSAY SF4->F4_CODIGO
	If  SF4->F4_TIPO == "E"
		@nLin,  04 PSAY "Entrada"
	Else
		@nLin,  04 PSAY "Saida  "
	Endif
	@nLin,  12 PSAY SF4->F4_CF
	@nLin,  17 PSAY SF4->F4_CLFINA
	@nLin,  68 PSAY SF4->F4_TEXTO
	@nLin,  89 PSAY SF4->F4_CLGRUPO
	If  SF4->F4_PODER3 == "R"
		@nLin,  93 PSAY "REM"
	ElseIf  SF4->F4_PODER3 == "D"
		@nLin,  93 PSAY "DEV"
	Else
		@nLin,  93 PSAY "n/c"
	Endif
	If  SF4->F4_ICM == "S"
		@nLin,  97 PSAY "Sim"
	Else
		@nLin,  97 PSAY "Nao"
	Endif
	If  SF4->F4_IPI == "S"
		@nLin, 101 PSAY "Sim"
	Else
		@nLin, 101 PSAY "Nao"
	Endif
	If  SF4->F4_DUPLIC == "S"
		@nLin, 105 PSAY "Sim"
	Else
		@nLin, 105 PSAY "Nao"
	Endif
	If  SF4->F4_ESTOQUE == "S"
		@nLin, 109 PSAY "Sim"
	Else
		@nLin, 109 PSAY "Nao"
	Endif
	@nLin, 113 PSAY SF4->F4_CLMSG1
	@nLin, 116 PSAY SF4->F4_CLMSG2
	nLin := nLin + 1
	@ nLin, 000 PSAY REPLICATE ("-",131)
	nLin := nLin + 1
	
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

//DbCloseArea("SF4")

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
	aadd(aRegs,{cPerg,'01','Do TES         ? ','mv_ch1','C',03, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SF4'})
	aadd(aRegs,{cPerg,'02','Ate o TES      ? ','mv_ch2','C',03, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SF4'})
	
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

/*/
*---------------------------------------------------------------------------*
* Lay Out do Relatorio                                                      *
*---------------------------------------------------------------------------*
0         1         2         3         4         5         6         7         8         9        10         11  11
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
TES TIPO    CFO   FINALIDADE                                         TEXTO NA NOTA        GRC ICMS IPI DUP EST M1 M2
999 ENTRADA 9.999 12345678901234567890123456789012345678901234567890 12345678901234567890 999 SIM  SIM SIM SIM 99 99
T=TODOS
*/




