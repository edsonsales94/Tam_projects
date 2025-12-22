#INCLUDE 'MATA116.CH'
#INCLUDE 'INKEY.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'XMLXFUN.CH'
#INCLUDE 'AP5MAIL.CH'
#INCLUDE 'SHELL.CH'
#INCLUDE 'XMLXFUN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ROTINA 		01 // Define a Rotina : 1-Inclusao / 2-Exclusao
#DEFINE TIPONF		02 // Considerar Notas : 1 - Compra , 2 - Devolucao
#DEFINE DATAINI		03 // Data Inicial para Filtro das NF Originais
#DEFINE DATAATE		04 // Data Final para Filtro das NF originais
#DEFINE FORNORI		05 // Cod. Fornecedor para Filtro das NF Originais
#DEFINE LOJAORI		06 // Loja Fornecedor para Fltro das NF Originais
#DEFINE FORMUL		07 // Utiliza Formulario proprio ? 1-Sim,2-Nao
#DEFINE NUMNF		08 // Num. da NF de Conhecimento de Frete
#DEFINE SERNF		09 // Serie da NF de COnhecimento de Frete
#DEFINE FORNECE		10 // Codigo do Fornecedor da NF de FRETE
#DEFINE LOJA		11 // Loja do Fornecedor da NF de Frete
#DEFINE TES			12 // Tes utilizada na Classificacao da NF
#DEFINE VALOR		13 // Valor total do Frete sem Impostos
#DEFINE UFORIGEM	14 // Estado de Origem do Frete
#DEFINE AGLUTINA	15 // Aglutina Produtos : .T. , .F.
#DEFINE BSICMRET	16 // Base do Icms Retido
#DEFINE VLICMRET	17 // Valor do Icms Retido
#DEFINE FILTRONF   18 // Filtra nota com conhecimento frete .F. , .T.
#DEFINE ESPECIE    19 // 
#DEFINE  ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT116TEL       ºAutor ³Fabiano Pereiraº Data ³ 23/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Eh executado no início da função MATA116A                  º±±
±±º          ³ Programa de Digitacao de Conhecimento de Frete e substitui º±±
±±º          ³ a tela padrão de parâmetros. O ponto de entrada deve       º±±
±±º          ³ colocar todos os parâmetros no array “aParametros”, conf. oº±±
±±º          ³ quadro abaixo e poderá exibi-los, opcionalmente, numa tela º±±
±±º          ³ customizada pelo cliente.								  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±³Observacao³                                                            º±±
±±³          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
*********************************************************************
User Function MT116TEL()
*********************************************************************
Local lRet 			:= 	.T.
l116Auto			:=	.F.
L103VISUAL			:=	.F.

Private _cEspecie	:=	Space(TamSX3('F1_ESPECIE')[1])
Private dDHEmit		:=	dDataBase


Public lUsouLotepls



If Upper(AllTrim(FunName())) == 'IMPXMLCTE'
                                              
    
    cFilAnt := IIF(cFilAnt!=ZXC->ZXC_FILIAL, ZXC->ZXC_FILIAL, cFilAnt )
    
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ABRE ARQUIVO DE CONFIGURACAO    |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	********************************************
		ExecBlock('OpenArqCfg',.F., .F., {} )
	********************************************
	

	cTesCte := Space(TamSx3('D1_TES')[01])


   	
	DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
	If DbSeek(cEmpAnt+cFilAnt, .F.)			//ZXC->ZXC_FILIAL
	
	   If !Empty(TMPCTE->TESXCTE)
			cTesCte := TMPCTE->TESXCTE 
	   ElseIf !Empty(TMPCTE->PRODXCTE)
			cTesCte := Posicione('SB1',1,xFilial('SB1')+ TMPCTE->PRODXCTE ,'B1_TE')
	   EndIf
	
		// _cEspecie := IIF( TMPCTE->(FieldPos("ESP_CTRC")) <> 0 , TMPCTE->ESP_CTRC, 'SPED' )
		_cEspecie := IIF( TMPCTE->(FieldPos("ESPXCTE")) > 0, AllTrim(TMPCTE->ESPXCTE), Space(TamSX3('F1_ESPECIE')[1]) ) 



	EndIf
	
	cTesCte := IIF(Empty(cTesCte), Space(TamSx3('D1_TES')[01]), cTesCte)
                          
	DbSelectArea('ZXC')
	cXML	:=	AllTrim(ZXC->ZXC_XML)
	cXML	+=	ExecBlock("CTe_VerificaZXD",.F.,.F., {ZXC->ZXC_FILIAL, ZXC->ZXC_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXD
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  CabecCTeParser -   ABRE XML - CABEC     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	*******************************************************************
	   aRet	:=	ExecBlock("CabecCTeParser",.F.,.F., {cXML, .T.})
	*******************************************************************
	
	If aRet[01] == .T.
	

		cDestCnpj := IIF(Len(aRet)>=3, aRet[3], '')
		ForCliMsBlql('SA2', cDestCnpj, .F.)  // BUSCA POR CNPJ
		cCodRem		:=  IIF(Len(aRet)>=3, SA2->A2_COD,	 Space(TamSx3('A2_COD')[1])  )
       	cLojaRem	:=	IIF(Len(aRet)>=3, SA2->A2_LOJA, Space(TamSx3('A2_LOJA')[1]) )

		
		cEmitCnpj := IIF(Len(aRet)>=4, aRet[4], '')
		ForCliMsBlql('SA2', cEmitCnpj, .F.)  // BUSCA POR CNPJ
		cCodEmi		:=	IIF(Len(aRet)>=4, SA2->A2_COD,	 Space(TamSx3('A2_COD')[1])  )
       	cLojaEmi	:=	IIF(Len(aRet)>=4, SA2->A2_LOJA, Space(TamSx3('A2_LOJA')[1]) )
       	
		dDHEmit 	:= 	IIF(Len(aRet)>=5, aRet[05], dDatabase)

    
		Aadd( aParametros,	'2'						)	//	[01] Define a Rotina : 2-Inclusao / 1-Exclusao
		Aadd( aParametros,	'1' 					)	//	[02] Considerar Notas : 1 - Compra , 2 – Devolucao
		Aadd( aParametros,	(ZXC->ZXC_DTNFE - 30) 	)	//	[03] Data Inicial para Filtro das NFs Originais
		Aadd( aParametros,	dDHEmit		 			)	//	[04] Data Final para Filtro das NFs originais
		//Aadd( aParametros,	ZXC->ZXC_FORNEC		)	//	[05] Cod. Fornecedor para Filtro das NFs Originais
		//Aadd( aParametros,	ZXC->ZXC_LOJA		)	//	[06] Loja Fornecedor para Fltro das NFs Originais
		Aadd( aParametros,	cCodRem  				)	//	[05] Cod. Fornecedor para Filtro das NFs Originais
		Aadd( aParametros,	cLojaRem				)	//	[06] Loja Fornecedor para Fltro das NFs Originais
		Aadd( aParametros,	'2'						)	//	[07] Utiliza Formulario proprio ? 1-Sim,2-Nao
		Aadd( aParametros,	ZXC->ZXC_DOC			)	//	[08] Num. da NF de Conhecimento de Frete
		Aadd( aParametros,	ZXC->ZXC_SERIE 			)	//	[09] Serie da NF de COnhecimento de Frete
		Aadd( aParametros,	cCodEmi			   		)	//	[10] Codigo do Fornecedor da NF de FRETE
		Aadd( aParametros,	cLojaEmi				)	//	[11] Loja do Fornecedor da NF de Frete
		Aadd( aParametros,	cTesCte				   	)	//	[12] TES utilizada na Classificacao da NF
		Aadd( aParametros,	ZXC->ZXC_VLRFRE			)	//	[13] Valor total do Frete sem Impostos
		Aadd( aParametros,	ZXC->ZXC_UFFOR			)	//	[14] Estado de Origem do Frete
		Aadd( aParametros,	.F.						)	//	[15] Aglutina Produtos : .T. , .F.
		Aadd( aParametros,	ZXC->ZXC_BSICMS			)	//	[16] Base do Icms Retido
		Aadd( aParametros,	ZXC->ZXC_VLICMS			)	//	[17] Valor do Icms Retido
		Aadd( aParametros,	.F.						)	// 	[18] Filtra notas com conhecimento frete .F. = Não , .T. = Sim	
		Aadd( aParametros,	_cEspecie				)	// 	[19] Especie da Nota Fiscal
		
	EndIf


Else

	Aadd( aParametros,	'2'						)	//	[01] Define a Rotina : 2-Inclusao / 1-Exclusao
	Aadd( aParametros,	'1' 					)	//	[02] Considerar Notas : 1 - Compra , 2 – Devolucao
	Aadd( aParametros,	(dDatabase - 30)    	)	//	[03] Data Inicial para Filtro das NFs Originais
	Aadd( aParametros,	dDHEmit		 			)	//	[04] Data Final para Filtro das NFs originais
	Aadd( aParametros,	''						)	//	[05] Cod. Fornecedor para Filtro das NFs Originais
	Aadd( aParametros,	''						)	//	[06] Loja Fornecedor para Fltro das NFs Originais
	Aadd( aParametros,	'2'						)	//	[07] Utiliza Formulario proprio ? 1-Sim,2-Nao
	Aadd( aParametros,	''						)	//	[08] Num. da NF de Conhecimento de Frete
	Aadd( aParametros,	''			 			)	//	[09] Serie da NF de COnhecimento de Frete
	Aadd( aParametros,	''						)	//	[10] Codigo do Fornecedor da NF de FRETE
	Aadd( aParametros,	''						)	//	[11] Loja do Fornecedor da NF de Frete
	Aadd( aParametros,	''					   	)	//	[12] TES utilizada na Classificacao da NF
	Aadd( aParametros,	0						)	//	[13] Valor total do Frete sem Impostos
	Aadd( aParametros,	''						)	//	[14] Estado de Origem do Frete
	Aadd( aParametros,	.F.						)	//	[15] Aglutina Produtos : .T. , .F.
	Aadd( aParametros,	0						)	//	[16] Base do Icms Retido
	Aadd( aParametros,	0						)	//	[17] Valor do Icms Retido
	Aadd( aParametros,	.F.						)	// 	[18] Filtra notas com conhecimento frete .F. = Não , .T. = Sim	
	Aadd( aParametros,	_cEspecie				)	// 	[19] Especie da Nota Fiscal
	
EndIf	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama a tela de configuracao com os Dados da Nota Fiscal     ³    
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := MyA116Setup(@aParametros)


Return(lRet)
*********************************************************************
Static Function MyA116Setup(aParametros)
*********************************************************************
Local aCombo1	    := {STR0006,STR0007} //"Incluir NF de Conhec. Frete"###"Excluir NF de Conhec. Frete"
Local aCombo2	    := {STR0008,STR0009} //"NF Normal"###"NF Devol./Benef."
Local aCombo3	    := {STR0010,STR0011} //"NÃo"###"Sim"
Local aCombo4	    := {STR0011,STR0010} //"Sim"###"NÃo"
Local aCombo5	    := {STR0010,STR0011} //"NÃo"###"Sim"

Local aCliFor	    := {{STR0012,"FOR"},{STR0013,"SA1"}} //"Fornecedor"###"Cliente"
Local nCombo1	    := 1
Local nCombo2	    := 1
Local nCombo3	    := If(l116Auto,aAutoCab[10,2],1)
Local nCombo4	    := 1
Local nCombo5	    := 1


Local n116Valor	    := aParametros[13] //0
Local n116BsIcmret	:= aParametros[16] //0
Local n116VlrIcmRet	:= aParametros[17] //0
Local nOpcAuto      := aParametros[01] //If(l116Auto, If(aAutoCab[3,2]=1 ,2,1),1) //1= Exclusao - 2= Inclusao
Local d116DataDe    := aParametros[03] // dDataBase - 90
Local d116DataAte   := aParametros[04] //dDataBase

Local c116Combo1    := aCombo1[nCombo1]
Local c116Combo2    := aCombo2[1]
Local c116Combo3    := aCombo3[1]
Local c116Combo4	:= aCombo4[1]
Local c116Combo5    := aCombo5[1]
Local c116FornOri   := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[05], CriaVar("F1_FORNECE",.F.)) //If(l116Auto,aAutoCab[4,2],CriaVar("F1_FORNECE",.F.))
Local c116LojaOri   := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[06], CriaVar("F1_LOJA",.F.)) //If(l116Auto,aAutoCab[5,2],CriaVar("F1_LOJA",.F.))
Local c116NumNF	    := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[08], CriaVar("F1_DOC",.F.)) //If(l116Auto,aAutoCab[11,2],CriaVar("F1_DOC",.F.))
Local c116SerNF	    := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[09], CriaVar("F1_SERIE",.F.)) //If(l116Auto,aAutoCab[12,2],CriaVar("F1_SERIE",.F.))
Local c116Fornece   := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[10], CriaVar("F1_FORNECE",.F.)) //If(l116Auto,aAutoCab[13,2],CriaVar("F1_FORNECE",.F.))
Local c116Loja	    := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[11], CriaVar("F1_LOJA",.F.)) //If(l116Auto,aAutoCab[14,2],CriaVar("F1_LOJA",.F.))
Local c116Tes	    := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[12], CriaVar("D1_TES",.F.)) //If(l116Auto,aAutoCab[15,2],CriaVar("D1_TES",.F.))
Local _cEspecie     := IIF(Upper(AllTrim(FunName())) == 'IMPXMLCTE', aParametros[19], CriaVar("F1_ESPECIE",.F.)) 
Local lRet		    := .F.


Local oDlg
Local oCombo1
Local oCombo2
Local oCombo3
Local oCombo4
Local oCombo5
Local oCliFor
Local oFornOri

Private c116UFOri	:= IIF(!Empty(aParametros[14]), aParametros[14], CriaVar("A2_EST",.F.) )
Private aValidGet	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para manipular o valor do frete                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT116VAL"))
	n116Valor := ExecBlock("MT116VAL",.F.,.F.,{n116Valor})
	If ValType(n116Valor) <> "N"
		n116Valor := 0
	EndIf
EndIf    
              

If !( l116Auto )
	DEFINE MSDIALOG oDlg FROM 87 ,52  TO 485,609 TITLE STR0014+cCadastro Of oMainWnd PIXEL //"Parametros "

	@ 22 ,3   TO 68 ,274 LABEL STR0022 OF oDlg PIXEL //"Parametros do Filtro"
	@ 6 ,48  MSCOMBOBOX oCombo1 VAR c116Combo1 ITEMS aCombo1 SIZE 83 ,50 OF oDlg PIXEL VALID (nCombo1:=aScan(aCombo1,c116Combo1))
	@ 7  ,6   SAY STR0024 Of oDlg PIXEL SIZE 43,09 //"Quanto a Nota"
	@ 7  ,140 SAY STR0025 Of oDlg PIXEL SIZE 100 ,9 //"Filtrar notas com conhecimento de frete"
	@ 7  ,245 MSCOMBOBOX oCombo5 VAR c116Combo5 ITEMS aCombo5 SIZE 30 ,50 OF oDlg PIXEL When (nCombo1==1) VALID (nCombo5:=aScan(aCombo5,c116Combo5))
	@ 34 ,12  SAY STR0026 Of oDlg PIXEL SIZE 60 ,9 //"Data Inicial"
	@ 34 ,145 SAY STR0027 Of oDlg PIXEL SIZE 59 ,9 //"Data Final"
	@ 33 ,48  MSGET d116DataDe  Valid !Empty(d116DataDe) OF oDlg PIXEL SIZE 60 ,9
	@ 33 ,185 MSGET d116DataAte Valid !Empty(d116DataAte) OF oDlg PIXEL SIZE 60 ,9
	@ 52  ,12 SAY STR0028 Of oDlg PIXEL SIZE 54 ,9 //"Considerar"
	@ 51  ,48 MSCOMBOBOX oCombo2 VAR c116Combo2 ITEMS aCombo2 SIZE 60 ,50 OF oDlg PIXEL When (nCombo1==1) VALID ((nCombo2:=aScan(aCombo2,c116Combo2)),oCliFor:Refresh(),oFornOri:cF3:=aCliFor[nCombo2][2],c116FornOri:=SPACE(Len(c116FornOri)),c116LojaOri:=SPACE(Len(c116LojaOri)))
	@ 52 ,145  SAY oCliFor VAR aCliFor[nCombo2][1] Of oDlg PIXEL SIZE 28 ,9
	@ 51 ,185  MSGET oFornOri VAR c116FornOri Picture PesqPict("SA2","A2_COD") F3 aCliFor[nCombo2][2];
		OF oDlg PIXEL SIZE 40 ,9 VALID Empty(c116FornOri).Or.A116StpVld(nCombo2,c116FornOri,@c116LojaOri)
	@ 51 ,230  MSGET c116LojaOri Picture PesqPict("SA2","A2_LOJA") F3 CpoRetF3("A2_LOJA");
		OF oDlg PIXEL SIZE 17 ,9 VALID Empty(c116LojaOri).Or.A116StpVld(nCombo2,c116FornOri,c116LojaOri)


	@ 74 ,3   TO 175,274 LABEL STR0029 OF oDlg PIXEL //"Dados da NF de Frete"
	@ 86 ,10  SAY STR0030 Of oDlg PIXEL SIZE 32 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Form. Proprio"
	@ 85 ,47  MSCOMBOBOX oCombo3 VAR c116Combo3 ITEMS aCombo3 SIZE 35 ,50 OF oDlg PIXEL When (nCombo1==1) VALID ((nCombo3:=aScan(aCombo3,c116Combo3)),/*c116NumNF:=SPACE(Len(c116NumNF)),c116SerNF:=SPACE(Len(c116SerNF))*/)
	@ 86 ,145 SAY STR0031 Of oDlg PIXEL SIZE 39 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Num. Conhec."
	@ 85 ,185 MSGET c116NumNF Picture PesqPict("SF1","F1_DOC") OF oDlg PIXEL SIZE 31 ,9 When (nCombo1==1.And.nCombo3==1) VALID A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)
	@ 86 ,225 SAY STR0047 Of oDlg PIXEL SIZE 15 ,9  //"Serie"
	@ 85 ,242 MSGET c116SerNF Picture PesqPict("SF1","F1_SERIE") OF oDlg PIXEL SIZE 19 ,9  When (nCombo1==1.And.nCombo3==1) VALID A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)

	@ 105,10  SAY STR0012 Of oDlg PIXEL SIZE 47 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Fornecedor"
	@ 104,47  MSGET c116Fornece  Picture PesqPict("SF1","F1_FORNECE") F3 "FOR" ;
		OF oDlg PIXEL SIZE 40 ,9 When (nCombo1==1) VALID A116StpVld(1,c116Fornece,@c116Loja,@c116UfOri).And.A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)

	@ 104,88  MSGET c116Loja Picture PesqPict("SF1","F1_LOJA") F3 CpoRetF3("F1_LOJA");
		OF oDlg PIXEL SIZE 19 ,9 When (nCombo1==1) VALID A116StpVld(1,c116Fornece,c116Loja,@c116UfOri).And.A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF).And.A116ChkTra(c116Fornece,c116Loja,c116FornOri,c116LojaOri)

	@ 105,114 SAY STR0032 Of oDlg PIXEL SIZE 32 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Cod. TES"
	@ 104,140 MSGET c116TES Picture PesqPict("SD1","D1_TES") F3 CpoRetF3("D1_TES");
		OF oDlg PIXEL SIZE 25 ,9 When (nCombo1==1) VALID  (Empty(c116Tes) .Or. ExistCpo("SF4",c116Tes)) .And. A116ChkTES(c116TES)

	@ 105,175 SAY STR0046 Of oDlg PIXEL SIZE 33 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //" Valor"
	@ 104,203 MSGET n116Valor Picture PesqPict("SD1","D1_TOTAL") ;
		OF oDlg PIXEL SIZE 61 ,9 When (nCombo1==1)

	@ 125,10  SAY STR0033 Of oDlg PIXEL SIZE 36 ,9 //"UF Origem"
	@ 124,47  MSGET c116UfOri Picture PesqPict("SA2","A2_EST") F3 CpoRetF3("A2_EST");
		OF oDlg PIXEL SIZE 25 ,9 	When (nCombo1==1) VALID Vazio(c116UFOri) .Or. ExistCPO("SX5","12"+c116UFOri)
	@ 125,120 SAY STR0034 Of oDlg PIXEL SIZE 48 ,9 //"Aglutina Produtos ?"
	@ 125,180 MSCOMBOBOX oCombo4 VAR c116Combo4 ITEMS aCombo4 SIZE 30 ,50 OF oDlg PIXEL When (nCombo1==1) VALID (nCombo4:=aScan(aCombo4,c116Combo4))
	@ 146,10  SAY STR0035 Of oDlg PIXEL SIZE 49 ,9 //"Bs Icms Ret."
	@ 144,47  MSGET oGetBs VAR n116BsIcmRet  Picture PesqPict("SD1","D1_BRICMS") F3 CpoRetF3("D1_BRICMS");
		OF oDlg PIXEL SIZE 70 ,9 When (nCombo1==1) VALID Positivo(n116BsIcmRet)

	@ 144,140 SAY STR0036 Of oDlg PIXEL SIZE 41 ,9 //"Vlr. Icms Ret."
	@ 143,180 MSGET n116VlrIcmRet Picture PesqPict("SD1","D1_ICMSRET") F3 CpoRetF3("D1_ICMSRET");
		OF oDlg PIXEL SIZE 70 ,9 When (nCombo1==1) VALID Positivo(n116VlrIcmRet)


	@ 165,010 SAY 'Especie:' Of oDlg PIXEL SIZE 51 ,9 
	@ 162,047 MSGET _cEspecie Picture PesqPict("SF1","F1_ESPECIE") /*F3 CpoRetF3("D1_TES")*/ OF oDlg PIXEL SIZE 35 ,9 /*When (nCombo1==1) VALID  (Empty(c116Tes) .Or. ExistCpo("SF4",c116Tes)) .And. A116ChkTES(c116TES)*/


	@178,220 BUTTON STR0037 SIZE 35 ,10  FONT oDlg:oFont ACTION (lRet := .T., oDlg:End()) /*If(A116StpOk(c116NumNF,c116Fornece,c116Loja,c116Tes,c116FornOri,c116LojaOri,nCombo1,n116Valor,nCombo3),(lRet:=.T.,oDlg:End()),Nil)*/ OF oDlg PIXEL //"Confirma >>"
	@178,180 BUTTON STR0038 SIZE 35 ,10  FONT oDlg:oFont ACTION (lRet := .F., oDlg:End())  OF oDlg PIXEL //"<< Cancelar"

	ACTIVATE MSDIALOG oDlg CENTERED

Else

	If Type("aParametros") == "A" 
		If nCombo1 == 1

			// criacao da aValidGet
			aValidGet := {}
			Aadd(aValidGet,{"c116FornOri",aAutoCab[ 4,2],"Empty('"+c116FornOri+"') .Or. A116StpVld("+Str(nCombo2,1)+",'"+c116FornOri+"','"+c116LojaOri+"')",.F.})
			Aadd(aValidGet,{"c116LojaOri",aAutoCab[ 5,2],"Empty('"+c116LojaOri+"') .Or. A116StpVld("+Str(nCombo2,1)+",'"+c116FornOri+"','"+c116LojaOri+"')",.F.})
			Aadd(aValidGet,{"c116NumNF"  ,aAutoCab[11,2],"A116ChkNFE("+Str(nOpcAuto,1)+",'"+c116Fornece+"','"+c116Loja+"','"+c116NumNF+"','"+c116SerNF+"')",.F.})
			Aadd(aValidGet,{"c116SerNF"  ,aAutoCab[12,2],"A116ChkNFE("+Str(nOpcAuto,1)+",'"+c116Fornece+"','"+c116Loja+"','"+c116NumNF+"','"+c116SerNF+"')",.F.})
			Aadd(aValidGet,{"c116Fornece",aAutoCab[13,2],"A116StpVld(1,'"+c116Fornece+"','"+c116Loja+"',@c116UfOri) .And. A116ChkNFE("+Str(nOpcAuto,1)+",'"+c116Fornece+"','"+c116Loja+"','"+c116NumNF+"','"+c116SerNF+"')",.F.})
			Aadd(aValidGet,{"c116Loja"   ,aAutoCab[14,2],"A116StpVld(1,'"+c116Fornece+"','"+c116Loja+"',@c116UfOri) .And. A116ChkNFE("+Str(nOpcAuto,1)+",'"+c116Fornece+"','"+c116Loja+"','"+c116NumNF+"','"+c116SerNF+"')",.F.})

			lRet := SF1->(MsVldGAuto(aValidGet)) // consiste os gets

		Else
			lRet := .T.
		EndIf
	EndIf

EndIf	

If lRet

	nCombo1:= If(nCombo1==1,2,1)   // Aadd( aParametros,	'2'					)	//	[01] Define a Rotina : 2-Inclusao / 1-Exclusao
	
	aParametros:= {	nCombo1,; 		// 1 Define a Rotina : 1-Inclusao / 2-Exclusao
					nCombo2,; 		// 2 Considerar Notas : 1 - Compra , 2 - Devolucao
					d116DataDe,; 	// 3 Data Inicial para Filtro das NF Originais
					d116DataAte,;	// 4 Data Final para Filtro das NF originais
					c116FornOri,;	// 5 Cod. Fornecedor para Filtro das NF Originais
					c116LojaOri,;	// 6 Loja Fornecedor para Fltro das NF Originais
					nCombo3,; 		// 7 Utiliza Formulario proprio ? 1-Sim,2-Nao
					c116NumNF,;  	// 8 Num. da NF de Conhecimento de Frete
					c116SerNF,;  	// 9 Serie da NF de COnhecimento de Frete
					c116Fornece,;	// 10 Codigo do Fornecedor da NF de FRETE
					c116Loja,;   	// 11 Loja do Fornecedor da NF de Frete
					c116Tes,;    	// 12 Tes utilizada na Classificacao da NF
					n116Valor,;  	// 13 Valor total do Frete sem Impostos
					c116UFOri,;  	// 14 Estado de Origem do Frete
					(nCombo4==1),; // 15 Aglutina Produtos : .T. , .F.
					n116BsIcmRet,;	// 16 Base do Icms Retido
					n116VlrIcmRet,;	// 17 Valor do Icms Retido
					(nCombo5==3),;	// 18 Filtra nota com conhecimento frete .F. , .T.
					_cEspecie ; 		// 19 Especie do Documento
					}

EndIf

Return lRet                           
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116ChkTES³ Autor ³ Nereu Humberto Junior ³ Data ³05.11.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se o TES digitado e de entrada.                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do TES                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: Validacao do Tipo de Entrada/Saida (TES)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116ChkTES(cCodTES)

Local lRet := .T.
If SubStr(cCodTES,1,1) >= "5" .And. cCodTES <> "500"
	HELP("   ",1,"INV_TE")
	lRet := .F.
Endif	

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116ChkTra³ Autor ³ Mary C. Hergert       ³ Data ³25/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se o fornecedor da nota fiscal de frete (transpor- ³±±
±±³          ³tadora) e igual ao fornecedor de pesquisa e barra a         ³±±
±±³          ³inclusao atraves de parametro.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do Fornecedor - transportadora                ³±±
±±³          ³ExpC2: Loja do Fornecedor - transportadora                  ³±±
±±³          ³ExpC3: Codigo do Fornecedor - pesquisa                      ³±±
±±³          ³ExpC4: Loja do Fornecedor - pesquisa                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: Validacao do fornecedor                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116ChkTra(c116Fornece,c116Loja,c116FornOri,c116LojaOri)

Local lRet 		:= .T.
Local lCkTrans	:= GetNewPar("MV_CKTRANS",.F.) 

If lCkTrans
	If c116Fornece == c116FornOri .And. c116Loja == c116LojaOri
		lRet := .F.
		HELP("",1,"A116CKTR")
	Endif
Endif

Return (lRet)                  
***********************************************************************
Static Function ForCliMsBlql(cTabela, cCnpj, cCodFornece, cLojaFornece)
***********************************************************************
Local _lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA VERIFICAR SE CADASTRO DE CLIENTE OU FORNECEDOR ³
//³NAO ESTA BLOQUEADO                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTabela == 'SA2' 

	DbSelectArea('SA2');DbSetOrder(3);DbGoTop()
	If DbSeek(xFilial('SA2')+ cCnpj, .F.) 
		Do While !Eof() .And. AllTrim(SA2->A2_CGC) == AllTrim(cCnpj) .And. SA2->A2_MSBLQL == '1'  // 1=Sim;2=Näo
			DbSkip()
		EndDo
	Else
		_lRet := .F.
	EndIf
	
ElseIf cTabela == 'SA1' 

	DbSelectArea('SA1');DbSetOrder(3);DbGoTop()
	If DbSeek(xFilial('SA1')+ cCnpj, .F.) 
		Do While !Eof() .And. AllTrim(SA1->A1_CGC) == AllTrim(cCnpj) .And. SA1->A1_MSBLQL == '1'  // 1=Sim;2=Näo
			DbSkip()
		EndDo
	Else
		_lRet := .F.
	EndIf
	
	    
EndIf

Return(_lRet)