#INCLUDE "Protheus.ch"
/*/{Protheus.doc}FXFATP01
@description
Gerar as Manutenções nas Movimentações de Lote SD5.
@author	Bruno Garcia
@version	1.0
@since		20/02/2016
@return	Nao possui,Nao possui,Nao possui,Nao possui
@param 	Nao possui,Nao possui,Nao possui,Nao possui
/*/ 
User Function PLESTP04()
Local cPerg		:= PADR("PLESTP04",Len(SX1->X1_GRUPO))   
Local lError := .F.
Local nProdProc := 0
Local cProd01 := ""
Local cProd02 := "" 

ValidPerg(cPerg)

If Pergunte(cPerg,.T.)
	cProd01 := mv_par01
	cProd02 := mv_par02 
	SB1->(dbSetOrder(1))
	SB2->(dbSetOrder(1))
	SB2->(dbSeek(xFilial("SB2") + cProd01,.T.))
	While SB2->(!EOF()) .And. SB2->B2_FILIAL == xFilial("SB2") .And. SB2->B2_COD <= cProd02
	    If SB2->B2_QATU > 0
			SB1->(dbSeek(xFilial("SB1") + SB2->B2_COD))
			
			/*If SB1->B1_MSBLQL = "1" //Nao processo produto bloqueado
				SB2->(dbSkip())
				Loop	
			EndIf*/
			
			//Verifica se o produto controla lote e endereco
			If SB1->B1_LOCALIZ == "S" .And. SB1->B1_RASTRO == "L"  
				aDados := {SB2->B2_COD,;
							SB2->B2_LOCAL,;
							dDataBase,;
							SB2->B2_QATU,;
							"INICIAL",;
							CToD("31/12/2049")}
				lError := FMata390(aDados) 
				
				If !lError
					lError := fMata265(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_NUMSEQ,SDA->DA_QTDORI)					
				EndIf
				
				If !lError
					nProdProc++
				EndIf				
			ElseIf SB1->B1_LOCALIZ == "N" .And. SB1->B1_RASTRO == "L"
				aDados := {SB2->B2_COD,;
							SB2->B2_LOCAL,;
							dDataBase,;
							SB2->B2_QATU,;
							"INICIAL",;
							CToD("31/12/2049")}
				lError := FMata390(aDados) 
				
				If !lError
					nProdProc++
				EndIf
			ElseIf SB1->B1_LOCALIZ == "S" .And. SB1->B1_RASTRO == "N"
					aDados:={{SB2->B2_COD,;
							SB2->B2_LOCAL,;
							IIf(SB2->B2_LOCAL == "10","PROC","INICIAL"),;
							SB2->B2_QATU,;
							CriaVar("DB_QTSEGUM"),;
							CriaVar("DA_LOTECTL"),;
							CriaVar("DA_NUMLOTE"),;
							CriaVar("DB_NUMSERI"),;
							dDataBase,.F.}}
								
					MA805Process(aDados)
					
					nProdProc++											
			EndIf
			
			                         
		EndIf
		SB2->(dbSkip())
	EndDo       

	If nProdProc > 0  
		MsgAlert(cValToChar(nProdProc) + " produto(s) com saldo(s) processado(s)!","Atenção")
	Else
		Alert("Não houve processamento para os parametros informados, verifique o(s) produto(s)!")	
	EndIf
EndIf
Return

Static Function FMata390(aDados)
Local aVetor := {}
Private lMsErroAuto := .F. 

aadd(aVetor,{"D5_PRODUTO" ,aDados[1]    ,})
aadd(aVetor,{"D5_LOCAL"	  ,aDados[2]    ,})
aadd(aVetor,{"D5_DATA"    ,aDados[3]    ,})
aadd(aVetor,{"D5_QUANT"   ,aDados[4]    ,})
aadd(aVetor,{"D5_LOTECTL" ,aDados[5]    ,})
aadd(aVetor,{"D5_DTVALID" ,aDados[6]	,})  

MSExecAuto({|x,y| Mata390(x,y)},aVetor,3)

If lMsErroAuto	
	//MostraErro()
	//DisarmTransaction() 	
EndIf

Return lMsErroAuto

Static Function fMata265(cProd,cLocal,cNumSeq,nQuant)   
Local aSDA := {}
Local aSDB := {} 
Local cEnd := "INICIAL"
Local aRet := {}

Private lMSErroAuto := .F.

SDA->(DbSetOrder(1))
SDA->(DbSeek(xFilial("SDA") + cProd + cLocal + cNumSeq))

aSDA := {	{"DA_FILIAL ", xFilial("SDA")   , Nil}, ; // Filial do sistema
			{"DA_PRODUTO", SDA->DA_PRODUTO  , Nil}, ; // Produto
			{"DA_LOCAL"  , SDA->DA_LOCAL    , Nil}, ; // Local Padrao
			{"DA_NUMSEQ" , SDA->DA_NUMSEQ   , Nil}, ; // Numero Sequencial
			{"DA_DOC"    , SDA->DA_DOC      , Nil}}   // Movimento de Producao

aSDB := {{	{"DB_FILIAL" , xFilial("SDB")  	, Nil}, ;  // Filial do sistema
			{"DB_ITEM"   , "001"           	, Nil}, ;  // Item
			{"DB_LOCALIZ", cEnd				, Nil}, ;  // Endereco
			{"DB_DATA"   , dDataBase       	, Nil}, ;  // Data
			{"DB_QUANT"  , nQuant      		, NIL}}}   // Quantidade
	
MSExecAuto({|x,y,z| Mata265(x,y,z)}, aSDA, aSDB, 3)  

If lMsErroAuto	
	//MostraErro()
	//DisarmTransaction() 	
EndIf

Return lMsErroAuto

Static Function MA805Process(aDados)

// Obtem numero sequencial do movimento
Local cNumSeq:=ProxNum(),i
// Numero do Item do Movimento
Local cCounter	:=	StrZero(0,TamSx3('DB_ITEM')[1])
Local cDoc805    := "INICIAL"
Local cSerie805  := "INI"


ProcRegua(Len(aDados))

// Varre o aDados gravando o SDB
For i:=1 to Len(aDados)
	IncProc()
	If !(aDados[i,Len(aDados[i])])
		cCounter := Soma1(cCounter)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria registro de movimentacao por Localizacao (SDB)           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CriaSDB(aDados[i,1],;	// Produto
				aDados[i,2],;	// Armazem
				aDados[i,4],;	// Quantidade
				aDados[i,3],;	// Localizacao
				aDados[i,8],;	// Numero de Serie
				cDoc805,;		// Doc
				cSerie805,;		// Serie
				"",;			// Cliente / Fornecedor
				"",;			// Loja
				"",;			// Tipo NF
				"ACE",;			// Origem do Movimento
				dDataBase,;		// Data
				aDados[i,6],;	// Lote
				If(Rastro(aDados[i,1],"S"),aDados[i,7],""),; // Sub-Lote
				cNumSeq,;		// Numero Sequencial
				"499",;			// Tipo do Movimento
				"M",;			// Tipo do Movimento (Distribuicao/Movimento)
				cCounter,;		// Item
				.F.,;			// Flag que indica se e' mov. estorno
				0,;				// Quantidade empenhado
				aDados[i,5])		// Quantidade segunda UM
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma saldo em estoque por localizacao fisica (SBF)            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GravaSBF("SDB")
	EndIf
Next i
Return(NIL)

/*/{Protheus.doc}ValidPerg 
	@description
	Grupo de perguntas da rotina
	@author	Bruno Garcia
	@version	1.0
	@since		29/02/2016
	@return	Nao possui,Nao possui,Nao possui,Nao possui
	@param 		cPerg,Caracter,Obrigatório,Nome do grupo de perguntas. 
/*/
Static Function ValidPerg(cPerg)
	PutSx1(cPerg,"01","Produto De?"						,"","","mv_ch1","C",TamSX3("B1_COD")[1],0,0,"G",""			 ,"SB1","","","mv_par01")
	PutSx1(cPerg,"02","Produto Até?"					,"","","mv_ch2","C",TamSX3("B1_COD")[1],0,0,"G","naovazio"	 ,"SB1","","","mv_par02")
Return

