#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#Define PSAY SAY
#ENDIF

User Function REPR010()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
//Ё Incluido pelo assistente de conversao do AP6 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("ARETURN,CDESC1,CDESC2,CDESC3,TITULO,CCANCEL")
SetPrvt("CSTRING,NOMEPROG,CPERG,WNREL,CBTXT,TAMANHO")
SetPrvt("CBCONT,LIMITE,NLASTKEY,LI,M_PAG,LEND")
SetPrvt("NTIPO,NOPCA,CTYPE,CABEC1,CABEC2,AARQREL")
SetPrvt("ADIRET,NIND,CARQREL,NREL,CARQUIVO,XBUFFER")
SetPrvt("CALIAS,CCAMPO,NHDLARQ,NTOTAL,REGARQ,NI")
SetPrvt("NCAMPOS,ACAMPOS,ACPOIMP,CCHECK,NTAMLINHA,NLINTOT")
SetPrvt("LPASSA,NREGARQ,CTPIND,CNUMIND,NPOSINICIAL,CCHAVE")
SetPrvt("ACPOSIX,NTAMSIX,CTITULO,NCOL,CTIPO,NY")
SetPrvt("NELEM,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#Define PSAY SAY
#ENDIF

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё REPR010  Ё AutoraЁ Elizabeth A.E.Tamaoki Ё Data Ё 04/05/99 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Relatorio de Conferencia da replica.                       Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Espec║fico do Sistema Integrado Off-Line.                  Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis.                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cDesc1   := "Este programa ir═ imprimir os arquivos de exportacao/importacao."
cDesc2   := ""
cDesc3   := ""
Titulo   := "Conferencia do arq. - "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cString  := "OZ1"
nomeprog := "REPR010"
cPerg    := "RPR010"
wnRel    := "REPR010"
cbtxt    := Space(10)
Tamanho  := "M"
cbcont   := 0
limite   := 132
nLastKey := 0
li       := 80
m_pag    := 1
lEnd     := .F.

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as Perguntas Selecionadas                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis Utilizadas p/ Parametros :                         Ё
//Ё                                                              Ё
//Ё mv_par01  // Diretorio onde se encontra os arquivos          Ё
//Ё mv_par02  // Nome do arquivo a imprimir                      Ё
//Ё              Se estiver em branco imprime todos os arquivos  Ё
//Ё              diferente da extensao .ALL e .MAT               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Pergunte("RPR010", .F.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.)

If nLastKey == 27 
	Set Filter To
   Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
   Return
EndIf

nTipo := Iif(aReturn[4] == 1, 15, 18)

nOpca    := 0
cType    := ""

#IFDEF WINDOWS
	RptStatus({|lEnd| RR010Imp()}, "Conferencia de arquivo(s) de sistema integrado off-line")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> 	RptStatus({|lEnd| Execute(RR010Imp)}, "Conferencia de arquivo(s) de sistema integrado off-line")
#ELSE
	RR010Imp()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё RR010Imp Ё AutoraЁ Elizabeth A.E.Tamaoki Ё Data Ё 04/05/99 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Impressao do Relatorio.                                    Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё RR010Imp(void)                                             Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё REPR010                                                    Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RR010Imp
Static Function RR010Imp()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Definicao do Cabecalho.                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cabec1 := ""
cabec2 := ""
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13

aArqRel := {}
If Empty(mv_par02)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monta array com os arquivos do diretorio informado, com excecao  Ё
	//Ё dos arquivos .ALL e .MAT, que deverao ser informados manualmente.Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aDiret := DIRECTORY(AllTrim(mv_par01)+"*.*")
	For nInd := 1 To Len(aDiret)
		cArqRel := AllTrim(aDiret[nInd,1])

		If cArqRel != "." .And. cArqRel != ".." .And. Right(AllTrim(cArqRel),4) != ".MAT" .And. ;
			Right(AllTrim(cArqRel),4) != ".ALL"
			Aadd( aArqRel, cArqRel )
		Endif
	Next
Else
	Aadd( aArqRel, mv_par02 )
Endif

SetRegua(Len(aArqRel))

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Imprime o arquivo solicitado ou todos os arquivos do diretorio in- Ё
//Ё formados, com excecao do .ALL e .MAT                               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nRel := 1 To Len(aArqRel)
	cArquivo := AllTrim(mv_par01) + aArqRel[nRel]
	nOpca    := 0
	cType    := ""
	
	If !Empty(cArquivo)
		If File(cArquivo)
			nOpca := 1
		Else 
			MsgAlert("Arquivo nao encontrado")
		EndIf
	Else
		MsgAlert("Arquivo nao informado")
	EndIf

	IncRegua()

	xBuffer   := Space(19)
	cAlias    := ""
	cCampo    := ""
	nHdlArq   := 0
	nTotal    := 0
	RegArq    := 0
	ni        := 0
	nCampos   := 0
	aCampos   := {}
	aCpoImp   := {}
	cCheck    := ""


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAbre o arquivo a ser Importado                                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nHdlArq := FOpen(cArquivo)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁVerifica o tamanho total do arquivo                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nTotal  := FSeek(nHdlArq,0,2)
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁPosiciona o arquivo no inicio                                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	FSeek(nHdlArq,0,0)				

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Determina o tamanho de cada linha                            Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	FRead(nHdlArq,@xBuffer,19)
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se o arquivo e' de exportacao da replica.           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Substr(xBuffer,1,1) == "H" .And. nOpca == 1

		nTamLinha := Val(Subs(xBuffer,5,4))
		cAlias    := Subs(xBuffer,2,3)
		nLinTot   := nTamLinha+19
		lPassa    := .F.
		nCampos   := Subs(xBuffer,13,3)
		nRegArq   := Subs(xBuffer,9,4)
		cTpInd    := Subs(xBuffer,16,1)
		cNumInd   := Subs(xBuffer,17,1)

		While nLinTot < nTotal

			#IFNDEF WINDOWS
				Inkey()

				If Lastkey() == K_ALT_A
					lEnd := .T.
				EndIf
			#ENDIF

			If lEnd
				li := li + 2
				@ li,000 PSAY cCancel

				Exit
			EndIf

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Le o proximo arquivo a ser importado                         Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lPassa
				FRead(nHdlArq,@xBuffer,19)

				nTamLinha := Val(Subs(xBuffer,5,4))
				cAlias    := Subs(xBuffer,2,3)
				nCampos   := Subs(xBuffer,13,3)
				nRegArq   := Subs(xBuffer,9,4)
				cTpInd    := Subs(xBuffer,16,1)
				cNumInd   := Subs(xBuffer,17,1)
	
				nLinTot := nLinTot + 19
			EndIf

			xBuffer := Space(nTamLinha)
			lPassa  := .T.

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Le as linhas que indicam quais campos foram importados e a   Ё
			//Ё ordem para importacao                                        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			For ni:= 1 to Val(nCampos)
				FRead(nHdlArq,@xBuffer,22)	
				Aadd(aCpoImp,{Subs(xBuffer,2,10),Val(Subs(xBuffer,12,3)),Val(Subs(xBuffer,15,6))})
			Next nI

			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek(cAlias)
			nPosInicial := 2
			While !Eof() .And. cAlias == X3_ARQUIVO
				Aadd(aCampos,{x3_campo,x3_tipo,x3_tamanho,nPosInicial})
				nPosInicial := nPosInicial + x3_tamanho
				nLinTot     := nLinTot + 22

				dbSkip()
			End
		
			dbSelectArea("SX3")
			dbSetOrder(2)

			dbSelectArea("SIX")
			dbSeek(cAlias+"1")  // 1a. ordem do indice
			cChave := AllTrim(SIX->CHAVE)
			aCpoSIX := {}
			nTamSIX := Len(cChave)
			nInd := 1
			While nInd <= nTamSIX
				cCampo := AllTrim(Substr(cChave,1,AT("+",cChave)-1))
				If Empty(cCampo)
					Exit
				Endif

				If "(" $ cCampo 
					cCampo := AllTrim(Substr(cCampo,AT("(",cCampo)+1,AT(")",cCampo)-1))
					If "," $ cCampo
						cCampo := AllTrim(Substr(cCampo,1,AT(",",cCampo)-1))
					Endif
				Endif
				dbSelectArea("SX3")
				dbSeek( cCampo )
				dbSelectArea("SIX")
				Aadd( aCpoSIX,{ cCampo, SX3->X3_TITULO, SX3->X3_TAMANHO, SX3->X3_PICTURE } )
				nInd := nInd + Len(cCampo)
				cChave := AllTrim(Substr(cChave,At("+",cChave)+1))
			End
			cCampo := cChave
			If "(" $ cCampo 
				cCampo := AllTrim(Substr(cCampo,AT("(",cCampo)+1,AT(")",cCampo)-1))
				If "," $ cCampo
					cCampo := AllTrim(Substr(cCampo,1,AT(",",cCampo)-1))
				Endif
			Endif
			dbSelectArea("SX3")
			dbSeek( cCampo )
			dbSelectArea("SIX")
			Aadd( aCpoSIX,{ cCampo, SX3->X3_TITULO, SX3->X3_TAMANHO, SX3->X3_PICTURE } )
			nInd := nInd + Len(cCampo)

			dbSelectArea("SX3")
			dbSetOrder(1)

			dbSelectArea("SX2")
			dbSeek( cAlias )
	
			dbSelectArea(cAlias)
		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Imprime o nome do arquivo que esta sendo listado (no arq. da Ё
			//Ё replica).                                                    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			Cabec1 := "Arquivo: " + cAlias + " - " + SX2->X2_NOME
			Cabec2 := "Tip.Reg "
			For nInd := 1 To Len(aCpoSIX)
				Cabec2 := Cabec2 + Substr(aCpoSIX[nInd][2],1,aCpoSIX[nInd][3]) + " "
			Next
		
			cTitulo := Titulo + cArquivo
			Cabec(cTitulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)

			nCol := 0
			dbSelectArea(cAlias)

			For ni := nTamLinha To nTotal Step nTamLinha

				#IFNDEF WINDOWS
					Inkey()

					If Lastkey() == K_ALT_A
						lEnd := .T.
					EndIf
				#ENDIF

				If lEnd
					li := li + 2
					@ li,000 PSAY cCancel

					Exit
				EndIf
			
				IncRegua(nTamLinha)
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Le o arquivo,joga no xBuffer, de quanto em quanto esta lendo Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				FRead(nHdlArq,@xBuffer,nTamLinha)

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Le o arquivo,joga no xBuffer, de quanto em quanto esta lendo Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Subs(xBuffer,1,1) == "F"
					nLinTot := nLinTot + nTamLinha
					Exit
				EndIf

				dbSelectArea(cAlias)

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica se o registro que esta sendo importado esta deletadoЁ
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Subs(xBuffer,1,1) == "D"
					cTipo := "Deletar"
				Else
					cTipo := "Alterar"
				EndIf
				@ li,00 PSAY cTipo
				nCol := 8
			
				For ny:=1 to Len(aCpoSIX)
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Procura no array dos campos o campo a ser impresso.          Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					nElem := Ascan(aCpoImp,{|x| AllTrim(x[1]) == AllTrim(aCpoSIX[ny][1])})
					If nElem == 0
						Loop
					EndIf
				
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Imprime o registro, somente os campos da primeira chave  Ё
					//Ё de indice do arquivo.                                    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cCheck := Subs(xBuffer,aCpoImp[nElem][3],aCpoImp[nElem][2])
					@ li,nCol PSAY cCheck  
					nCol := nCol + aCpoImp[nElem][2] + 1
				
				Next
				li := li + 1
			
				nLinTot := nLinTot + nTamLinha
			Next
		End
	EndIf

	FClose(nHdlArq)

Next

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Impressao do Rodape.                                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If li #80
	Roda(cbcont,cbtxt,Tamanho)
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Mostra o Spool.                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Set Device To Screen

If aReturn[5] == 1
	Set Printer To 
	Commit
	OurSpool(wnrel)
EndIf


Return(.T.)
