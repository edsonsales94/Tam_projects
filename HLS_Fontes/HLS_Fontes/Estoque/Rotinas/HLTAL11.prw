#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"

/*/{protheus.doc}HLTAL11
Efetua a Transferência dos Materiais Importados do Almox=11 para o Almox=10.Uso Exclusivo de Suprimentos/Almoxarifado
@author Ricardo Borges
@since 23/07/14
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HLTAL11  ³ Autor ³ Ricardo Borges        ³ Data ³ 23/07/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a Transferência dos Materiais Importados do Almox=11³±±
±±           ³ para o Almox=10 # Uso Exclusivo de Suprimentos/Almoxarifado³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HLTAL11()

	Private cCadastro := "Transferência de Materiais p/Armazém 10 # ALMOXARIFADO"
	PRIVATE cMark       := GetMark()
	Private aCampos := {}
	Private cArqTrb := "TRB"
	Private cInd01 := "INVOICE+PRODUTO"

	Private aRotina	:= {{"Transferência"	,"u_xTransf10()" ,0,1},;
		{"Legenda"	    	,"u_Legenda()"   ,0,2}}

	Private cDelFunc := ".F." // Validacao para a exclusao

	Private nOpca:=0

	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemtoAnsi("Transferência dos Materiais Importados do Armazém=11 para o Armazém=10") PIXEL

	_lPerg:=pergunte("HLTAL11",.T.)

	If !_lPerg
		oDlg:End()
		Return .T.
	Endif

	@ 18, 6 TO 76, 287
	@ 29, 15 SAY OemToAnsi("Transferência de Materiais Importados (** Armazem =11 para Armazém = 10 ** )")

	DEFINE SBUTTON FROM 80, 170 TYPE 5 ACTION Pergunte("HLTAL11",.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 210 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION (oDlg:End(),nOpca:=2) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg

	//MV_PAR01 = Número da Invoice

	aCores := {{"Empty(QUANT10)","BR_AZUL"},;
		{"!Empty(QUANT10)","BR_VERMELHO"}}

	If nOpca == 1

		cTabelaSQL:="QRI"

		If Select(cTabelaSQL) > 0
			dbSelectArea(cTabelaSQL)
			dbCloseArea(cTabelaSQL)
		Endif

		//cQuery	:= " SELECT F1_FILIAL, F1_ZZINVO,F1_DOC,F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, D1_ZZFABRI, D1_COD, B1_DESCNF, B1_DESC , D1_QUANT, D1_UM, D1_PEDIDO,F1_DTDIGIT "

		cQuery	:= " SELECT F1_FILIAL, F1_ZZINVO,F1_DOC,F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, B1_COD, B1_DESCNF, B1_DESC , D1_QUANT,D1_LOTECTL, D1_UM, D1_PEDIDO,F1_DTDIGIT, D1_XQAL10 "
		cQuery	+= " FROM "
		cQuery	+= RetSQLname("SF1") + " F1 "

		cQuery	+= " INNER JOIN " + RetSQLName("SD1") + " D1 "
		cQuery	+= " ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "

		cQuery	+= " INNER JOIN " + RetSQLName("SB1") + " B1 "
		cQuery	+= " ON D1_COD = B1_COD "

		cQuery	+= " INNER JOIN " + RetSQLName("SA2") + " A2 "
		cQuery	+= " ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA "

		cQuery	+= "WHERE  "
		cQuery	+=	"       F1_FILIAL   = '"		+ xFilial("SF1") 	 + "' AND  "
		cQuery	+=	"		D1_FILIAL   = F1_FILIAL  AND  "
		cQuery	+=	"		B1_FILIAL   = '"		+ xFilial("SB1")	 + "' AND  "
		cQuery	+=	"		A2_FILIAL   = '"		+ xFilial("SA2")	 + "' AND  "

		//	cQuery	+= "	F1_ZZINVO = '" + MV_PAR01 + "' "
		cQuery	+= "	F1_DOC = '" + MV_PAR01 + "' "		//VFV 27/07/15

		cQuery	+= "	AND F1.D_E_L_E_T_ = '' "
		cQuery	+= "	AND D1.D_E_L_E_T_ = '' "
		cQuery	+= "	AND B1.D_E_L_E_T_ = '' "
		cQuery	+= "	AND A2.D_E_L_E_T_ = '' "
		cQuery	+= "	ORDER BY F1_ZZINVO, D1_COD "

		TcQuery cQuery Alias (cTabelaSQL) New

		(cTabelaSQL)->(DbGoTop())

		If (cTabelaSQL)->(Eof()) //Not Found

			If Select(cTabelaSQL) > 0
				dbSelectArea(cTabelaSQL)
				dbCloseArea(cTabelaSQL)
			Endif

			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea("TRB")
			Endif

			//			ApMsgAlert("Sem dados para a Invoice digitada.Verifique o Parâmetro.")
			ApMsgAlert("Sem dados para a nota fiscal digitada.Verifique o Parâmetro.")	   //vfv

			Return

		Else

			PROCESSA( {|| _fCriArq() },"Criando Arq. Trabalho...")

			dbSelectArea(cTabelaSQL)

			While !(cTabelaSQL)->(Eof())

				dbSelectArea("TRB")
				RecLock ("TRB", .T.)

				//TRB -> FILIAL 	:= (cTabelaSQL)-> F1_FILIAL
				TRB -> XOK      := Space(02)
				TRB -> INVOICE	:= (cTabelaSQL)-> F1_ZZINVO
				TRB -> FORNECE	:= (cTabelaSQL)-> A2_NOME
				TRB -> NOTA		:= (cTabelaSQL)-> F1_DOC
				TRB -> DATAENT	:= STOD((cTabelaSQL)-> F1_DTDIGIT)
				TRB -> PRODUTO	:= (cTabelaSQL)-> B1_COD
				TRB -> QUANTID  := (cTabelaSQL)-> D1_QUANT
				TRB -> LOTE		:= (cTabelaSQL)-> D1_LOTECTL  // inclusao 22/08 - tratar lote na entrada de importação vfv
				TRB -> DESCNF	:= (cTabelaSQL)-> B1_DESC
				TRB -> QUANT10  := (cTabelaSQL)-> D1_XQAL10

				MsUnlock ()

				dbSelectArea(cTabelaSQL)
				Dbskip()
			End

			aTela:={}

			AADD(aTela,{"XOK         ","","OK"})
			AADD(aTela,{"INVOICE     ","","Invoice",})
			AADD(aTela,{"FORNECE     ","","Fornecedor",})
			AADD(aTela,{"NOTA	     ","09","Nota",})
			AADD(aTela,{"DATAENT	 ","08","Dt Entrada",})
			AADD(aTela,{"PRODUTO     ","15","Produto",})
			AADD(aTela,{"DESCNF      ","50","Descição Prod",})
			AADD(aTela,{"QUANTID     ","17","Quantidade",})
			AADD(aTela,{"LOTE	     ","10","Lote",}) // inclusao 22/08 - tratar lote na entrada de importação vfv
			AADD(aTela,{"QUANT10     ","17","Qtd Transf Armaz 10",})


			dbSelectArea("TRB")
			Dbgotop()

			MarkBrowse( "TRB","XOK" ,,aTela,,@cMark,'u_MarkAll()',,,,'u_Mark()',,,,aCores )
			//MarkBrowse( "TRB","XOK" ,,aTela,,@cMark,,,,,,,,,aCores )
			//MARKBROW  ( 'SCB', 'CB_OK','!CB_USERLIB',aCampos,, cMarca,'MarkAll()',,,,'Mark()' )

		Endif

		dbSelectArea(cTabelaSQL)
		dbCloseArea(cTabelaSQL)

		dbSelectArea("TRB")
		dbCloseArea("TRB")

	Endif

Return

User Function Legenda()

	BrwLegenda(cCadastro,"Valores", {	{"BR_VERMELHO","JÁ TRANSFERIDO"},;
		{"BR_AZUL","NÃO TRANSFERIDO" }} )
Return .T.

Static Function _fCriArq()
	aCampos := {}
	cArqTrb := "TRB"
	cInd01 := "INVOICE+PRODUTO"

	AADD(aCAMPOS,{"XOK"        ,"C",02,0})  //Ok = Mark
	AADD(aCAMPOS,{"INVOICE"	   ,"C",20,0})  //Invoice
	AADD(aCAMPOS,{"FORNECE"    ,"C",30,0})  //Nome Fornecedor
	AADD(aCAMPOS,{"NOTA"       ,"C",09,0})  //Nota
	AADD(aCAMPOS,{"DATAENT"    ,"D",08,0})  //Data da Entrada Nota Fiscal
	AADD(aCAMPOS,{"PRODUTO"    ,"C",15,0})  //Código do Produto
	AADD(aCAMPOS,{"DESCNF" 	   ,"C",50,2})  //Descrição do Produto na Nota
	AADD(aCAMPOS,{"QUANTID"    ,"N",11,2})  //Quantidade Nota
	AADD(aCAMPOS,{"LOTE"    	,"C",10,0})  //LOTE  // inclusao 22/08 - tratar lote na entrada de importação vfv
	AADD(aCAMPOS,{"QUANT10"    ,"N",11,2})  //Quantidade Transferida para o Armazém=10

	// DbCreate(cArqTrb,aCampos)
	// dbUseArea(.T.,, cArqTrb, "TRB", .F. )
	// Index on &cInd01 To &cArqTrb

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "TRB" )
	// Adiciono os campos na tabela
	oTable:SetFields( aCampos )
	// Adiciono os índices da tabela
	oTable:AddIndex( '01' , { cInd01 })
	// Crio a tabela no banco de dados
	oTable:Create()
	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqTrb := oTable:GetAlias()

	nTempo := 3 // Tenta realizar o loop por 10 segundos

	lErase := .T.
	lREt:=.T.
	While  nTempo > 0
		If File(cArqTrb+OrdBagExt())
			If NetErr() .Or. !(FErase(cArqTrb+OrdBagExt()) == 0)
				lErase := .F.
			EndIf
		EndIf
		If File(cArqTrb+".DBF") .And. lErase
			If NetErr() .Or. !(FErase(cArqTrb+".DBF") == 0)
				lErase := .F.
			EndIf
		EndIf
		If !NetErr() .And. lErase
			DbCreate(cArqTrb,aStru)
			If !NetErr() .And. FError() == 0
				dbUseArea(.T.,, cArqTrb, "TRB", EXCLUSIVO )
				dbSelectArea("TRB")
				If !NetErr() .And. FError() == 0
					lRet := .T.
					Exit
				EndIf
			EndIf
		EndIf
		InKey(.5)
		nTempo := nTempo - .5
	EndDo
Return

User Function xTransf10()

	IF !ApMsgYesno("Confirma Transferência dos Itens Selecionados para o Almoxarifado 10" , " Confirma (S/N)? ","TRANSFER")
		Return .T.
	Endif

	//Checa se Existem Itens a serem Processados

	DbSelectArea("TRB")
	DbSetOrder(1)
	DbGotop()

	_ncont:=0

	Do While TRB->(!Eof())

		DbSelectArea("TRB")

		If !Empty(TRB->XOK) //se usuario marcou o registro

			If TRB->QUANT10 = 0 //se o Item não foi Transferido para o Armazém = 10

				_ncont++

			Endif

		EndIf

		DbSelectArea("TRB")
		TRB->(DbSkip())

	EndDo

	//Fim Checa

	If _ncont > 0
		u_TrfMata261()
	Endif

	If _ncont = 0
		ApMsgAlert("Nenhum Item Selecionado para fazer a Transferência.Verifique")
	Else
		ApMsgInfo("Total de Itens Transferidos:" + Str(_ncont) )
	Endif

Return .T.


User Function Mark()

	dbSelectArea("TRB")

	If IsMark( "XOK", cMark )

		RecLock( "TRB", .F. )

		Replace XOK With Space(2)

		MsUnLock()

	Else

		RecLock( "TRB", .F. )

		Replace XOK With cMark

		MsUnLock()

	EndIf

Return


//Grava marca em todos os registros válidos

User Function MarkAll()

	Local nRecno

	dbSelectArea("TRB")
	nRecno := Recno()

	dbGotop()

	While !Eof()

		u_Mark()

		dbSkip()

	End

	dbGoto( nRecno )

Return


User Function TrfMata261()

	Local lOk	:= .T.
	Local aItem	:= {}
	Local aAuto := {}
	Local nOpcAuto:= 3 // Indica qual tipo de ação será tomada (Inclusão=3/Estorno=6)

	Local cNumDoc := Space(09)
	Local cProduto := Space(15) // Cod Produto
	Local cDescProd := Space(30) // Descrição do produto
	Local cUM := Space(02) // Unidade de medida

	Local cArmOri := "11" // Armazem origem
	Local cEndOri := Space(15) // Endereço de origem
	Local cArmDest := "10"	// Armazem destino
	Local cEndDest := Space(15) // Endereço destino

	Local cNumSer := Space(20) // Numero de série
	Local cLote :=  Space(10) // Lote
	Local cSLote	:= Space(06) // Sub-Lote
	Local cValidade := criavar('D3_DTVALID') // Validade Origem

	Local nPoten := 0 // Potencia
	Local nQuant // Quantidade
	Local cQtSegUm := criavar("D3_QTSEGUM") // Quantidade 2ª UM

	Local cEstorno := criavar("D3_ESTORNO") // Estornado
	Local cNumSeq := criavar("D3_NUMSEQ") // Numero sequencia

	Local cLoteDest := Space(10) // Lote destino
	Local cValDest := criavar("D3_DTVALID") // Validade Destino

	Local cItemGrd := Space(03) //criavar("D3_ITEMGRD") // Item da Grade
	Local nPerImp := 0 // Percentual de Importação

	PRIVATE lMsHelpAuto := .T.
	PRIVATE lMsErroAuto := .F.

	cFilant := "01"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Abertura do ambiente                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST"

	cNumDoc :=nextnumero("SD3",2,"D3_DOC",.t.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Inclusao                                                     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Begin Transaction   		//Cabecalho a Incluir

		aAuto := {}
		aadd(aAuto,{cNumDoc,dDataBase})  //Cabecalho

		DbSelectArea("TRB")
		DbSetOrder(1)
		DbGotop()

		_ncont:=0

		Do While TRB->(!Eof())

			cProduto:= TRB -> PRODUTO //Substr(Alltrim(TRB -> PRODUTO),1,15)
			nQuant	:= TRB -> QUANTID
			cLote   := TRB -> LOTE    // inclusao 22/08 - tratar lote na entrada de importação vfv

			DbSelectArea("SB1")
			DbSetOrder(1)

			If  SB1->(MsSeek(xFilial("SB1")+cProduto))
				cDescProd := Substr(B1_DESCNF,1,30) //Substr(Alltrim(B1_DESC),1,30)
				cUM 	 := SB1->B1_UM

			EndIf

			DbSelectArea("TRB")

			If !Empty(TRB->XOK) //se usuario marcou o registro

				If TRB->QUANT10 = 0 //se o Item não foi Transferido para o Armazém = 10

					aItem := {}


					//Origem
					aadd(aItem,cProduto)   //D3_COD	  //1
					aadd(aItem,cDescProd)  //D3_DESCRI  //2
					aadd(aItem,cUM)  	   //D3_UM	  //3
					aadd(aItem,cArmOri)    //D3_LOCAL   //4  //11 = Origem - Armazém Trânsito
					aadd(aItem,cEndOri)	   //D3_LOCALIZ //5
					//Fim Destino

					//Destino
					aadd(aItem,cProduto) //D3_COD	  //6
					aadd(aItem,cDescProd)//D3_DESCRI  //7
					aadd(aItem,cUM)  	 //D3_UM	  //8
					aadd(aItem,cArmDest) //D3_LOCAL	  //9  //10 = Destino - Armazém Real
					aadd(aItem,cEndDest) //D3_LOCALIZ //10
					//Fim Destino

					aadd(aItem,cNumSer)  //D3_NUMSERI //11
					aadd(aItem,cLote)	 //D3_LOTECTL //12
					aadd(aItem,cSLote)   //D3_NUMLOTE //13

					aadd(aItem,cValidade)//D3_DTVALID //14
					aadd(aItem,nPoten)	 //D3_POTENCI //15

					aadd(aItem,nQuant) 	 //D3_QUANT	 //16
					aadd(aItem,cQtSegUm) //D3_QTSEGUM //17

					//aadd(aItem,cEstorno) //D3_ESTORNO //18
					aadd(aItem,"N")        //D3_ESTORNO //18
					aadd(aItem,cNumSeq)    //D3_NUMSEQ  //19

					//check
					aadd(aItem,cLoteDest)  //D3_LOTECTL //20
					aadd(aItem,cValDest)   //D3_DTVALID //21

					aadd(aItem,cItemGrd)   //D3_ITEMGRD //22
					//				aadd(aItem,nPerImp)	   //D3_PERIMP  //23    //ALTERADO VINICIUS - 11/11/14

					aadd(aAuto,aItem)

					DbSelectArea("TRB")

				Endif

			EndIf

			TRB->(DbSkip())

		EndDo

		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

		If !lMsErroAuto //Sem Erro

			DbSelectArea("TRB")
			DbSetOrder(1)
			DbGotop()

			_ncont:=0

			Do While TRB->(!Eof())

				DbSelectArea("TRB")

				If !Empty(TRB->XOK) //se usuario marcou o registro

					If TRB->QUANT10 = 0 //se o Item não foi Transferido para o Armazém = 10

						DbSelectArea("TRB")

						RecLock( "TRB", .F. )
						Replace TRB->QUANT10 With TRB->QUANTID
						MsUnLock()

						//Gravar na Tabela de Entrada de Notas Importação-SD1 o D1_XQAL10 COM A QUANTID TRANSFERÊNCIA
						cUpdate := " UPDATE " + RetSqlName("SD1") + " SET D1_XQAL10 = D1_QUANT FROM "
						cUpdate += " " + RetSqlName("SD1") + " SD1, "
						cUpdate += " " + RetSqlName("SF1") + " SF1  "

						cUpdate	+= " WHERE  "
						cUpdate	+= " SF1.F1_FILIAL   = '" + xFilial("SF1") + "' AND "
						cUpdate	+= " SD1.D1_FILIAL   = SF1.F1_FILIAL AND "

						cUpdate	+= " F1_ZZINVO =       '" + TRB -> INVOICE + "' AND "

						cUpdate	+= " SD1.D1_DOC =      '" + TRB -> NOTA    + "' AND "

						cUpdate	+= " SD1.D1_COD =      '" + TRB -> PRODUTO + "' AND "

						cUpdate	+= " SD1.D1_DTDIGIT =  '" + DTOS(TRB -> DATAENT) + "' AND "

						cUpdate += " SD1.D1_XQAL10 = 0 AND "

						cUpdate += " SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA  AND "

						cUpdate += " SD1.D_E_L_E_T_ ='' AND "

						cUpdate += " SF1.D_E_L_E_T_ ='' "

						TCSQLEXEC(cUpdate)

						//Gravar na Tabela de Entrada de Notas Importação-SD1 o D1_XQAL10 COM A QUANTID TRANSFERÊNCIA
						_ncont++

					Endif

				EndIf

				DbSelectArea("TRB")
				TRB->(DbSkip())

			EndDo
			//End Begin
			If _ncont > 0
				ApMsgInfo("Processo Realizado com Sucesso # Na próxima Mensagem Anote o Número do Documento/Transação" )
				ApMsgInfo("Anote o Número do Documento/Transação = " + cNumDoc + " e Confira/Consulte o Kardex p/Dia desses Itens no Armazém = 10")

			Endif
		Else
			ApMsgAlert("Erro na inclusao dos Itens Selecionados.De um Print na Próxima Tela e envie para a área de Sistemas")
			MostraErro()
		EndIf

	End Transaction


Return Nil
