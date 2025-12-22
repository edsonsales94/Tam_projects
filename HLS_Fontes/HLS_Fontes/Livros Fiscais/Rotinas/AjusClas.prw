#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} FCIINFVI

Ajusta D1_CLASFIS, D2_CLASFIS, FT_CLASFIS, FT_CTIPI, FT_CSTPIS, FT_CSTCOF`, SFT->FT_CODBCC 

@type function
@author Marcos da Mata 
@since 04/12/11

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjusClas  ºAutor  ³Marcos da Mata      º Data ³  04/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta D1_CLASFIS, D2_CLASFIS, FT_CLASFIS, FT_CTIPI,       º±±
±±º          ³ FT_CSTPIS, FT_CSTCOF`, SFT->FT_CODBCC                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SPED FISCAL e SPED PIS COFINS                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AjusClas()
fAviso()
Processa({|| fProcessa() },"Processando...")
Return Nil

Static Function fProcessa()

Local cClasFiscal 	:= ""
Local nAlqPis		:= GetMv("MV_TXPIS")
Local nAlqCof		:= GetMv("MV_TXCOFIN")
Local cQuery      	:= ""
Local cItemNF     	:= ""
Local cPerg 		:= "AJUST"

// Criacao do grupo de perguntas SX1
ValidPerg(cPerg)
If !Pergunte(cPerg, .T.)
	Return Nil
EndIf

SB1->(dbSetOrder(1))
SF4->(dbSetOrder(1))
SFT->(dbSetOrder(1))	&& FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
SD1->(dbSetOrder(1))
SD2->(dbSetOrder(3))

&& NOTAS DE SAIDA:
cQuery := " SELECT *"
cQuery += " FROM "+RetSqlName("SD2")
cQuery += " WHERE"
cQuery += " D2_FILIAL = '"+xFilial("SD2")+"' AND"
cQuery += " D2_EMISSAO >= '"+dtos(MV_PAR01)+"' AND D2_EMISSAO <= '"+dtos(MV_PAR02)+"' AND"
cQuery += " D_E_L_E_T_ = ' '"
cQuery += " ORDER BY D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM"

If Select("TSD2") <> 0
	TSD2->(dbCloseArea())
Endif

TcQuery cQuery Alias "TSD2" New

TSD2->(dbGoTop())
ProcRegua(TSD2->(RecCount()))
Do While TSD2->(!Eof())
	
	IncProc()
	
	If SB1->(dbSeek( xFilial("SB1") + TSD2->D2_COD ))
		If SF4->(dbSeek( xFilial("SF4") + TSD2->D2_TES ))
			
			cItemNF := Substr(Alltrim(TSD2->D2_ITEM) + Space(Len(SFT->FT_ITEM)),1,Len(SFT->FT_ITEM))
			
			&& FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
			If SFT->(dbSeek( xFilial("SFT") + "S" + TSD2->D2_SERIE + TSD2->D2_DOC + TSD2->D2_CLIENTE + TSD2->D2_LOJA + cItemNF + TSD2->D2_COD ))
				If SD2->(dbSeek( xFilial("SD2") + TSD2->D2_DOC + TSD2->D2_SERIE + TSD2->D2_CLIENTE + TSD2->D2_LOJA + TSD2->D2_COD + TSD2->D2_ITEM ))
					
					cClasFiscal := SubStr(SB1->B1_ORIGEM,1,1) + SF4->F4_SITTRIB
					
					RecLock("SD2",.F.)
					SD2->D2_CLASFIS := cClasFiscal
					SD2->(MsUnLock())
					
					RecLock("SFT",.F.)
					SFT->FT_CLASFIS := cClasFiscal    	&& Classificacao Fiscal ICMS (B1_ORIGEM + F4_SITTRIB)
					SFT->FT_CTIPI	:= SF4->F4_CTIPI	&& Classificacao Fiscal IPI
					SFT->FT_CSTPIS 	:= SF4->F4_CSTPIS	&& Classificacao Fiscal PIS
					SFT->FT_CSTCOF	:= SF4->F4_CSTCOF	&& Classificacao Fiscal COFINS
					SFT->FT_CODBCC	:= SF4->F4_CODBCC	&& Codigo da Base de Calculo de Pis e Cofins
					
					SFT->FT_PDV := If(!Empty(SFT->FT_PDV),SFT->FT_PDV,"AJUSTPISCO")
					
					If SF4->F4_PISCOF == "3" .And. SF4->F4_PISCRED = "2" && Verifica se a TES esta com PIS/COFINS = AMBOS e DEBITA
						
						&& MV_PAR03 == 2 -> Altera Vlr Branco = Irá alterar os valores de base, alíquota e Vlr Pis / Vlr Cofins, quando NÃO houver Vlr Pis / Vlr Cofins... para os já preenchidos não serão alterados
						If MV_PAR03 == 2 && Verifica se foi configurado para alterar Valores de PIS e COFINS
							
							If SFT->FT_VALPIS == 0 && Verifica se o Valor do PIS esta zerado
								SFT->FT_BASEPIS := SFT->FT_VALCONT  	&& Valor Base PIS
								SFT->FT_ALIQPIS := nAlqPis				&& Aliquota parametro MV_TXPIS
								SFT->FT_VALPIS  := NoRound((SFT->FT_VALCONT * nAlqPis / 100),2)	&& Valor PIS
							EndIf
							
							If SFT->FT_VALCOF == 0 && Verifica se o Valor do COFINS esta zerado
								SFT->FT_BASECOF := SFT->FT_VALCONT		&& Valor Base COFINS
								SFT->FT_ALIQCOF := nAlqCof				&& Aliquota parametro MV_TXCOFIN
								SFT->FT_VALCOF  := NoRound((SFT->FT_VALCONT * nAlqCof / 100),2)	&& Valor Cofins
							EndIf
							
							&& MV_PAR03 == 3 -> Altera Todos Vlr  = Irá alterar todos valores de base, alíquota e Vlr Pis / Vlr Cofins, conforme Valor Contábil e Alíquotas Configuradas no MV_TXPIS e MV_TXCOFIN
						ElseIf MV_PAR03 == 3
							SFT->FT_BASEPIS := SFT->FT_VALCONT  	&& Valor Base PIS
							SFT->FT_ALIQPIS := nAlqPis				&& Aliquota parametro MV_TXPIS
							SFT->FT_VALPIS  := NoRound((SFT->FT_VALCONT * nAlqPis / 100),2)	&& Valor PIS
							
							SFT->FT_BASECOF := SFT->FT_VALCONT		&& Valor Base COFINS
							SFT->FT_ALIQCOF := nAlqCof				&& Aliquota parametro MV_TXCOFIN
							SFT->FT_VALCOF  := NoRound((SFT->FT_VALCONT * nAlqCof / 100),2)	&& Valor Cofins
						EndIf
					EndIf
					SFT->(MsUnLock())
				Endif
			Endif
		Endif
	Endif
	TSD2->(dbSkip())
Enddo
TSD2->(dbCloseArea())

&& NOTAS DE ENTRADA:
cQuery := " SELECT *"
cQuery += " FROM "+RetSqlName("SD1")
cQuery += " WHERE"
cQuery += " D1_FILIAL = '"+xFilial("SD1")+"' AND"
cQuery += " D1_DTDIGIT >= '"+dtos(MV_PAR01)+"' AND D1_DTDIGIT <= '"+dtos(MV_PAR02)+"' AND"
cQuery += " D_E_L_E_T_ = ' '"
cQuery += " ORDER BY D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM"

If Select("TSD1") <> 0
	TSD1->(dbCloseArea())
Endif

TcQuery cQuery Alias "TSD1" New

TSD1->(dbGoTop())
ProcRegua(TSD1->(RecCount()))
Do While TSD1->(!Eof())
	
	IncProc()
	
	If SB1->(dbSeek( xFilial("SB1") + TSD1->D1_COD ))
		If SF4->(dbSeek( xFilial("SF4") + TSD1->D1_TES ))
			
			cItemNF := Substr(Alltrim(TSD1->D1_ITEM) + Space(Len(SFT->FT_ITEM)),1,Len(SFT->FT_ITEM))
			
			&& FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
			If SFT->(dbSeek( xFilial("SFT") + "E" + TSD1->D1_SERIE + TSD1->D1_DOC + TSD1->D1_FORNECE + TSD1->D1_LOJA + cItemNF + TSD1->D1_COD ))
				If SD1->(dbSeek( xFilial("SD1") + TSD1->D1_DOC + TSD1->D1_SERIE + TSD1->D1_FORNECE + TSD1->D1_LOJA + TSD1->D1_COD + TSD1->D1_ITEM ))
					
					cClasFiscal := SubStr(SB1->B1_ORIGEM,1,1) + SF4->F4_SITTRIB
					
					RecLock("SD1",.F.)
					SD1->D1_CLASFIS := cClasFiscal
					SD1->(MsUnLock())
					
					RecLock("SFT",.F.)
					SFT->FT_CLASFIS := cClasFiscal    	&& Classificacao Fiscal ICMS (B1_ORIGEM + F4_SITTRIB)
					SFT->FT_CTIPI	:= SF4->F4_CTIPI	&& Classificacao Fiscal IPI
					SFT->FT_CSTPIS 	:= SF4->F4_CSTPIS	&& Classificacao Fiscal PIS
					SFT->FT_CSTCOF	:= SF4->F4_CSTCOF	&& Classificacao Fiscal COFINS
					SFT->FT_CODBCC	:= SF4->F4_CODBCC	&& Codigo da Base de Calculo de Pis e Cofins
					
					SFT->FT_PDV := If(!Empty(SFT->FT_PDV),SFT->FT_PDV,"AJUSTPISCO")
					
					If SF4->F4_PISCOF == "3" .And. SF4->F4_PISCRED = "1" && Verifica se a TES esta com PIS/COFINS = AMBOS e CREDITA
						
						&& MV_PAR03 == 2 -> Altera Vlr Branco = Irá alterar os valores de base, alíquota e Vlr Pis / Vlr Cofins, quando NÃO houver Vlr Pis / Vlr Cofins... para os já preenchidos não serão alterados
						If MV_PAR03 == 2 && Verifica se foi configurado para alterar Valores de PIS e COFINS
							
							If SFT->FT_VALPIS == 0 && Verifica se o Valor do PIS esta zerado
								SFT->FT_BASEPIS := SFT->FT_VALCONT  	&& Valor Base PIS
								SFT->FT_ALIQPIS := nAlqPis				&& Aliquota parametro MV_TXPIS
								SFT->FT_VALPIS  := NoRound((SFT->FT_VALCONT * nAlqPis / 100),2)	&& Valor PIS
							EndIf
							
							If SFT->FT_VALCOF == 0 && Verifica se o Valor do COFINS esta zerado
								SFT->FT_BASECOF := SFT->FT_VALCONT		&& Valor Base COFINS
								SFT->FT_ALIQCOF := nAlqCof				&& Aliquota parametro MV_TXCOFIN
								SFT->FT_VALCOF  := NoRound((SFT->FT_VALCONT * nAlqCof / 100),2)	&& Valor Cofins
							EndIf
							
							&& MV_PAR03 == 3 -> Altera Todos Vlr  = Irá alterar todos valores de base, alíquota e Vlr Pis / Vlr Cofins, conforme Valor Contábil e Alíquotas Configuradas no MV_TXPIS e MV_TXCOFIN
						ElseIf MV_PAR03 == 3
							SFT->FT_BASEPIS := SFT->FT_VALCONT  	&& Valor Base PIS
							SFT->FT_ALIQPIS := nAlqPis				&& Aliquota parametro MV_TXPIS
							SFT->FT_VALPIS  := NoRound((SFT->FT_VALCONT * nAlqPis / 100),2)	&& Valor PIS
							
							SFT->FT_BASECOF := SFT->FT_VALCONT		&& Valor Base COFINS
							SFT->FT_ALIQCOF := nAlqCof				&& Aliquota parametro MV_TXCOFIN
							SFT->FT_VALCOF  := NoRound((SFT->FT_VALCONT * nAlqCof / 100),2)	&& Valor Cofins
						EndIf
					EndIf
					SFT->(MsUnLock())
				Endif
			Endif
		Endif
	Endif
	TSD1->(dbSkip())
Enddo
TSD1->(dbCloseArea())

Alert("(AJUSTA CLASSIFICACAO) Rotina executada com sucesso!")

Return Nil


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Function fAviso()          ³
//³                           ³
//³Informacoes ao usuário     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Static Function fAviso()

DEFINE MSDIALOG oDlg TITLE "AJUSTA CLASSIFICACAO" FROM 000,000 TO 400,600 PIXEL

// Cria font para uso
oFont:= TFont():New('Courier New',,-14,.T.)

@ 010,018 SAY "Caro analista, esta rotina foi desenvolvida para ajustar as classificações fiscais" SIZE 300, 07 OF oDlg PIXEL
@ 030,018 SAY "Campos alterados: D1_CLASFIS, D2_CLASFIS, FT_CLASFIS, FT_CTIPI, FT_CSTPIS, FT_CSTCOF, FT_CODBCC, FT_BASEPIS, " SIZE 300, 07 OF oDlg PIXEL
@ 040,018 SAY "FT_ALIQPIS, FT_VALPIS, FT_BASECOF, FT_ALIQCOF, FT_VALPIS " SIZE 300, 07 OF oDlg PIXEL 
oSay := TSay():New( 060,018, {|| 'ATENCAO a terceira pergunta: Altera Vlr Pis/Cof'},oDlg,, oFont,,,, .T.,CLR_BLUE )
oSay := TSay():New( 070,018, {|| '1 Não Altera Vlr'},oDlg,, oFont,,,, .T.,CLR_RED )
@ 080,018 SAY "Não Altera Vlr = Não irá alterar qualquer valor de base, alíquota e Vlr Pis / Vlr Cofins" SIZE 300, 07 OF oDlg PIXEL 
oSay := TSay():New( 090,018, {|| '2 Altera Vlr Branco'},oDlg,, oFont,,,, .T.,CLR_RED )
@ 100,018 SAY "Altera Vlr Branco = Irá alterar os valores de base, alíquota e Vlr Pis / Vlr Cofins, quando NÃO houver Vlr Pis / Vlr Cofins... " SIZE 300, 07 OF oDlg PIXEL 
@ 110,018 SAY "Para os já preenchidos não serão alterados" SIZE 300, 07 OF oDlg PIXEL 
oSay := TSay():New( 120,018, {|| '3 Altera Todos Vlr'},oDlg,, oFont,,,, .T.,CLR_RED )
@ 130,018 SAY "Altera Todos Vlr = Irá alterar todos valores de base, alíquota e Vlr Pis / Vlr Cofins, conforme Valor Contábil e Alíquotas Configuradas no MV_TXPIS e MV_TXCOFIN" SIZE 300, 07 OF oDlg PIXEL 
@ 150,018 SAY "Caso queiram voltar a base para o original, execute o reprocessamento Fiscal." SIZE 300, 07 OF oDlg PIXEL 
@ 170,018 SAY "Espero que ajude - Marcos da Mata (DAMATA)." SIZE 300, 07 OF oDlg PIXEL 

DEFINE SBUTTON FROM 180, 250 TYPE 1 ACTION (nOpca := 1,oDlg:End());
ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Function ValidPerg(cPerg)                         ³
//³                                                  ³
//³Para inclusao automatica no grupo de perguntas SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function ValidPerg(cPerg)

Local sAlias 	:= Alias()
Local aRegs 	:= {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data de:","Data de:","Data de:" ,"MV_CH1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Até:","Data Até:","Data Até:","MV_CH2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Altera Vlr Pis/Cof:","Altera Vlr Pis/Cof:","Altera Vlr Pis/Cof:","MV_CH3","C",1,0,1,"C","","MV_PAR02","Não Altera Vlr","Não Altera Vlr","Não Altera Vlr","","","Altera Vlr Branco","Altera Vlr Branco","Altera Vlr Branco","","","Altera Todos Vlr","Altera Todos Vlr","Altera Todos Vlr","","","","","","","","","","","",""})


For i := 1 to Len(aRegs)
	If !dbSeek (cPerg + aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(sAlias)
Return()