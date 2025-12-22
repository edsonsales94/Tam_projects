#include "rwmake.ch"
#include "protheus.ch"
#Include "TopConn.ch"

#DEFINE PICVAL  "@E 999,999,999.999999"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Oliminet
//|Funcao....: Mrex
//|Autor.....: JOSE ROBERTO DE SOUZA - Oliminet
//|Data......: 15 de abrilde 2013
//|Versao....: Protheus - 11
//|Descricao.: Relatorio posição de estoque materia prima
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MRex()
*-----------------------------------------*
Private cTitulo  	:= "RELATORIO DE ESTOQUE - MATERIA PRIMA (M.P.)"
Private aArea    	:= GetArea()
Private aConteud 	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cPerg  		:= Padr("RELEST",10)
Private cResp 		:= ""
Private aConteud	:= {}
Private aEE1		:= {}

Private cMpDe		:= Space(len(SB1->B1_COD))
Private cMpAte		:= Space(len(SB1->B1_COD))
Private dDtRefer	:= dDatabase
Private nDiasRef	:= 0
Private cHora 		:= time()
If !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
EndIf

DEFINE MSDIALOG oDlg TITLE "Informe os endereços de email destino" FROM 0,0 TO 200, 500 OF oMainWnd PIXEL

@ 010,005 SAY "Materia Prima de : "  PIXEL OF oDlg
@ 025,005 SAY "Materia Prima até: "  PIXEL OF oDlg
@ 040,005 SAY "Data Referência  : "  PIXEL OF oDlg
@ 055,005 SAY "Refer.+ n Dias   : "  PIXEL OF oDlg

@ 010,050 GET  cMpDe							F3 "SB1" 		SIZE 050,021 OBJECT oGet
@ 025,050 GET  cMpAte	VALID (cMpAte >= cMpDe) F3 "SB1"  		SIZE 050,021 OBJECT oGet
@ 040,050 GET  dDtRefer			  								SIZE 050,021 OBJECT oGet
@ 055,050 GET  nDiasRef	Picture "999" 							SIZE 050,021 OBJECT oGet

DEFINE SBUTTON FROM 065, 005 TYPE 1 ACTION (oDlg:End(), nOpcao := 1) ENABLE OF oDlg
DEFINE SBUTTON FROM 080, 005 TYPE 2 ACTION (oDlg:End(), nOpcao := 2) ENABLE OF oDlg
oGet:SetFocus(.T.)

ACTIVATE MSDIALOG oDlg CENTERED

If nOpcao = 2
	Return
endif 
	

Processa({|| RelEst()},'Analisando Dados...')

Return .T.

*-----------------------------------------*
Static Function RelEst()
*-----------------------------------------*
Private aAreaNF		:= GetArea()
Private cCab		:= ""
Private aSdc        := {}
Private cQuery      := ""
Private cNFil		:= ""
Private lProd		:= .f.
Private cTexto		:= ""
Private	cSeparacao	:= ","
Private	_cEnter		:= "CHR(13)+CHR(10)"
Private nAcum 		:= 0
Private nQtdVen		:= 0
Private nQtComp		:= 0
Private nQtdCompT	:= 0
Private lPa			:= .f.
Private dDtRef		:= ddatabase
//+--------------------------------------------------------------//
//| Faz Select principal para preenchimento do array de impressao
//+--------------------------------------------------------------//

//Cabeçalho
//aAdd(aConteud,{"","","SITUAZIONE FABBISOGNO M.P. "+MV_PAR03,"","","",""}) //6 COLUNAS
aAdd(aConteud,{"DATA DE ELABORAÇÃO",dtoc(dDatabase),"","","","","","","","","","",""}) //13 COLUNAS

aAdd(aConteud,{"SITUAZIONE FABBISOGNO M.P. ","","","","","","","","","","",""}) //13 COLUNAS

aAdd(aConteud,{"","","","","","","","","","","","",""}) //13 COLUNAS

//              1             2           3               4         5              6                7                 8                                         9           10          11                   12                                 13
aAdd(aConteud,{"CODIGO M.P.","DESCRICAO","ESTOQUE ATUAL","EMPENHO","CONS.MED 3 M","CONS.MED. 12 M","PV PROX 15 DIAS","PV PROX. "+strzero(nDiasRef,2)+ "  DIAS","LEAD TIME","P.C.TOTAL","PEDIDO/ITEM/DT.PREF/       QUANT","TOTAL PC.LEAD TIME","CRITICIDADE"}) //13 COLUNAS
aAdd(aConteud,{"===========","=========","=============","=======","============","==============","===============","================="                      ,"=========","=========","================================","==================","==========="}) //13 COLUNAS


aAdd(aConteud,{"","","","","","","","","","","","",""}) //13 COLUNAS


//Variaveis utilizadas para parametros
//mv_par01        	// Produto de
//mv_par02        	// Produto ate
//mv_par03        	// Data Referencia
//mv_par04			// Dias para pedidos em aberto.

//pergunte(cPerg,.F.)

cQuery := ""
cQuery += " SELECT *  "
cQuery += " FROM " + RETSQLNAME("SB1")
cQuery += " WHERE "
cQuery += " B1_COD BETWEEN '" + cMPDe + "' AND '" + cMPAte + "'"
cQuery += " AND D_E_L_E_T_ <> '*' "
If Select("Q_B1") > 0
	Q_B1->(DbCloseArea())
EndIf
TcQuery cQuery New Alias "Q_B1"
COPY TO "QB1.DBF"
If Select("Q_B1") > 0
	Q_B1->(DbCloseArea())
EndIf
TcQuery cQuery New Alias "Q_B1"

ProcRegua(Q_B1->(RecCount()))
cHora := time()

//intervalos
do While Q_B1->(!eof())
	IncProc("Estq/Compras: "+alltrim(Q_B1->B1_COD) )
	if Q_B1->B1_TIPO <> 'MP'
		Q_B1->(dbSkip())
		loop
	endif
	
	aAdd(aConteud,{"","","","","","","","","","","",""}) //12 COLUNAS
	//	aConteud [len(aConteud),1]  := dtoc(stod(Q_T2->CT2_DATA))
	aConteud [len(aConteud),1]  := Q_B1->B1_COD
	aConteud [len(aConteud),2]  := Q_B1->B1_DESC
	
	//--------------------------------------------------------------------------
	//Saldo atual
	if SB2->(dbSeek(xFilial("SB2")+Q_B1->B1_COD))
		//		aConteud [len(aConteud),3]  := SB2->B2_QATU
		aConteud [len(aConteud),3]  := SB2->B2_QATU -(SB2->B2_QEMP + SB2->B2_RESERVA)
	else
		aConteud [len(aConteud),3]  := 0.00
	endif
	
	//--------------------------------------------------------------------------
	
	//Empenho + reserva
	aConteud [len(aConteud),4]  := SB2->B2_QEMP + SB2->B2_RESERVA
	
	//--------------------------------------------------------------------------
	
	//consumo dos ultimos 3 meses
	SB3->(dbSetOrder(1))
	if SB3->(dbSeek(xFilial("SB3")+Q_B1->B1_COD))
		nAcum := 0
		For nII = 1 to 3
			nAcum := nAcum + &("SB3->B3_Q"+strzero(Month(dDtRefer)-nII,2))
		Next
		nAcum :=  nAcum / 3
		aConteud [len(aConteud),5]  := int(nAcum)
	else
		aConteud [len(aConteud),5]  := 0
	endif
	
	//--------------------------------------------------------------------------
	
	//consumo nos ultimos 12 meses
	
	SB3->(dbSetOrder(1))
	if SB3->(dbSeek(xFilial("SB3")+Q_B1->B1_COD))
		nAcum := 0
		For nII = 1 to 12
			nAcum :=  nAcum + &("SB3->B3_Q"+strzero(nII,2))
		Next
		nAcum :=  nAcum / 12
		aConteud [len(aConteud),6]  := int(nAcum)
	else
		aConteud [len(aConteud),6]  := 0
	endif
	

	aConteud [len(aConteud),7]  := Round(0,  0 ) //Pedidos em aberto 15 dias 
	
	
	aConteud [len(aConteud),8]  := Round(0,  0 ) //Pedidos em aberto (n) dias
	
	
	//--------------------------------------------------------------------------
	//lead time do cadastro de produto
	
	aConteud [len(aConteud),09]  := Q_B1->B1_PE
	
	//--------------------------------------------------------------------------
	//Quantidade de pedidos de compras em aberto
	
	cQry := "SELECT *   "
	cQry += " FROM " + RetSQLName("SC7")
	cQry += " WHERE C7_FILIAL = '" + xFilial("SC7")+ "'"
	cQry += " AND   C7_PRODUTO  = '" + Q_B1->B1_COD + "'"
	cQry += " AND C7_QUJE <> C7_QUANT "
	cQry += " AND C7_RESIDUO = ' ' "
	cQry += " AND   D_E_L_E_T_ <> '*'"
	If Select("TC7") > 0
		TC7->(DbCloseArea())
	EndIf
	TCQUERY cQry NEW ALIAS "TC7"
	nAcumQt := 0
	do while TC7->(!eof())
		nAcumQt := nAcumQt + TC7->C7_QUANT
		TC7->(dbSkip())
	enddo
	
	aConteud [len(aConteud),10]  := SB2->B2_SALPEDI
	
	//--------------------------------------------------------------------------
	// Pedidos de compras em aberto dentro do lead time
	// Data do pedido MV_PAR?? + leadtime
	dDtRef := dDtRefer + Q_B1->B1_PE
	
	cQry := "SELECT *   "
	cQry += " FROM " + RetSQLName("SC7")
	cQry += " WHERE C7_FILIAL = '" + xFilial("SC7")+ "'"
	cQry += " AND C7_PRODUTO  = '" + Q_B1->B1_COD + "'"
	cQry += " AND C7_QUJE <> C7_QUANT "
	cQry += " AND C7_DATPRF <= '" + dtos(dDtRef) +"' "
	cQry += " AND C7_RESIDUO = ' ' "
	cQry += " AND   D_E_L_E_T_ <> '*'"
	If Select("TC7") > 0
		TC7->(DbCloseArea())
	EndIf
	TCQUERY cQry NEW ALIAS "TC7"
	nAcumQt := 0
	nCt := 0
	nLinTotPed := len(aConteud)
	do while TC7->(!eof())
		nCt++
		nAcumQt := nAcumQt + TC7->C7_QUANT
		cPedido := ""
		cPedido := TC7->C7_NUM + "-" + TC7->C7_ITEM + "-" + dtoc(stod(TC7->C7_DATPRF)) + "-"    + transform((TC7->C7_QUANT - TC7->C7_QUJE),"@E 999,999.99")
		if nCt > 1
			aAdd(aConteud,{"","","","","","","","","","",cPedido,"",""}) //13 COLUNAS
		else
			aConteud [len(aConteud),11]  := cPedido
		endif
		TC7->(dbSkip())
	enddo
	
	if nAcumQt > 0
		aAdd(aConteud,{"","","","","","","","","","","=================================","",""}) //13 COLUNAS
		aAdd(aConteud,{"","","","","","","","","","","","",""}) //13 COLUNAS
		
		//		aConteud [len(aConteud),12]  := nAcumQt
	else
		aAdd(aConteud,{"","","","","","","","","","","","",""}) //13 COLUNAS
	endif
	
	aConteud [nLinTotPed,12]  := nAcumQt //Total dos pedidos
	
	
	//--------------------------------------------------------------------
	//Criticidade de produto.
	lContinua := .t.
	if empty(aConteud[len(aConteud),3])
		lContinua := .f.
	elseif empty(aConteud[len(aConteud),5])
		lContinua := .f.
	elseif empty(aConteud[len(aConteud),7])
		lContinua := .f.
	elseif empty(aConteud[len(aConteud),10])
		lContinua := .f.
	endif
	
	if lContinua
		if aConteud[len(aConteud),3] <= 0   //Se saldo menor ou igual a 0
			aConteud [len(aConteud),13]  := "N"
		elseif aConteud[len(aConteud),10] <= aConteud[len(aConteud),5] //se a quantidade de pedidos de compras for menor que a media 3 meses
			aConteud [len(aConteud),13]  := "L"
		elseif aConteud[len(aConteud),10] < aConteud[len(aConteud),7] //se a quantidade de pedidos de compras for menor que os pedidos de vendas a 30 dias
			aConteud [len(aConteud),13]  := "B"
		elseif aConteud[len(aConteud),10] < aConteud[len(aConteud),5] //se a quantidade de pedidos de compras for MAIOR que os pedidos de vendas a 30 dias
			aConteud [len(aConteud),13]  := "S"
		else
			aConteud [len(aConteud),13]  := "?"
		endif
	else
		aConteud [len(aConteud),13]  := "?"
	endif
	
	//-------------------------------------------------------------------
	
	Q_B1->(dbSkip())
enddo

//--------------------------------------------------------------------------
//Montagem das colunas de pedidos de vendas coluna 7
//--------------------------------------------------------------------------
//Pedidos nos proximos 15 dias
nQtdCompT 	:= 0
nQtdVen 	:= 0
//verifica se tem pedido de vendas em aberto do PA

cQry := " SELECT DISTINCT C6_NUM,C6_PRODUTO, C6_QTDVEN, C6_ENTREG, B1_TIPO  "
cQry += " FROM " + RetSQLName("SC6")
cQry += " INNER JOIN " + RetSQLName("SB1") + " ON B1_COD = C6_PRODUTO "
cQry += " INNER JOIN " + RetSQLName("SG1") + " ON G1_COD = C6_PRODUTO "
cQry += " WHERE C6_FILIAL = '" + xFilial("SC6")+ "'"
cQry += " AND   C6_ENTREG <= '" + dtos((dDtRefer + 15)) + "'"
cQry += " AND C6_NOTA = ' ' "
cQry += " AND " + RetSQLName("SC6")+".D_E_L_E_T_ <> '*'"
//	cQry += " ORDER BY B1_COD "
If Select("TC6") > 0
	TC6->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TC6"
nTamCod		:= len(SB1->B1_COD)
aStr := {  {"PA"		, "C", nTamCod, 0},;
{"COMP"    	, "C", nTamCod, 0},;
{"QUANT"  	, "N", 14, 2}}
cArqLog    := CriaTrab(aStr, .T.)
DbUseArea(.T., , cArqLog, "TRB", .F.)
COPY TO "EST.DBF"
TRB->(dbCloseArea() )

DbUseArea(.T., , "EST.DBF", "EST", .F.)
//	Index On COMP + PA To EST1
Index On PA + COMP To EST2

//Verifica estrutura dos pedidos selecionados
do while TC6->(!eof())
	aEE1 := U_FNA002(TC6->C6_PRODUTO,TC6->C6_PRODUTO)
	FOR nJJ = 1 TO LEN(aEE1)
		IF !empty(aEE1[nJJ,2])
			RecLock("EST",.t.)
			EST->PA		:= TC6->C6_PRODUTO
			EST->COMP   := aEE1[nJJ,2]
			EST->QUANT  := aEE1[nJJ,7]
			EST->(msUnlock())
		endif
	next
	IncProc("Estruturas  "+ alltrim(TC6->C6_PRODUTO)  )
	
	TC6->(dbSkip())
enddo

//reselecionando pedidos na quantidade correta sem distinct
cQry := " SELECT C6_NUM,C6_PRODUTO, C6_QTDVEN, C6_ENTREG, B1_TIPO  "
cQry += " FROM " + RetSQLName("SC6")
cQry += " INNER JOIN " + RetSQLName("SB1") + " ON B1_COD = C6_PRODUTO "
cQry += " INNER JOIN " + RetSQLName("SG1") + " ON G1_COD = C6_PRODUTO "
cQry += " WHERE C6_FILIAL = '" + xFilial("SC6")+ "'"
cQry += " AND   C6_ENTREG <= '" + dtos((dDtRefer + 15)) + "'"
cQry += " AND C6_NOTA = ' ' "
cQry += " AND " + RetSQLName("SC6")+".D_E_L_E_T_ <> '*'"
cQry += " ORDER BY B1_COD "
If Select("TC6") > 0
	TC6->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TC6"

If Select("QB1") > 0
	QB1->(DbCloseArea())
EndIf
DbUseArea(.T., , "QB1.DBF", "QB1", .F.)

do While QB1->(!eof())
	do While TC6->(!eof())
		if EST->(dbseek(TC6->C6_PRODUTO ))
			do while EST->PA = TC6->C6_PRODUTO
				if alltrim(EST->COMP) = alltrim(QB1->B1_COD)
					//apura quantidade de produtos acabados vendidos
					nQtdVen := nQtdVen + TC6->C6_QTDVEN
					nQtdCompT := nQtdCompT + EST->QUANT  //* nQtdVen
				endif
				EST->(dbSkip())
			enddo
		endif
		TC6->(dbSkip())
	enddo
	for nLL = 1 to len(aConteud)
		if alltrim(aConteud[nLL,1]) = alltrim(QB1->B1_COD)
			aConteud [nLL,7]  := Round(nQtdCompT,  0 )   //quantidade de venda levantada no c6
		endif
	next
	nQtdCompT := 0

	QB1->(dbSkip())
enddo

dbSelectArea("EST")
dbCloseArea("EST")
FErase("EST.DBF")
//--------------------------------------------------


//--------------------------------------------------------------------------
//Montagem das colunas de pedidos de vendas coluna 8
//--------------------------------------------------------------------------
//Pedidos nos proximos (n) dias
nQtdCompT 	:= 0
nQtdVen 	:= 0

//verifica se tem pedido de vendas em aberto do PA
cQry := " SELECT DISTINCT C6_NUM,C6_PRODUTO, C6_QTDVEN, C6_ENTREG, B1_TIPO  "
cQry += " FROM " + RetSQLName("SC6")
cQry += " INNER JOIN " + RetSQLName("SB1") + " ON B1_COD = C6_PRODUTO "
cQry += " INNER JOIN " + RetSQLName("SG1") + " ON G1_COD = C6_PRODUTO "
cQry += " WHERE C6_FILIAL = '" + xFilial("SC6")+ "'"
cQry += " AND   C6_ENTREG <= '" + dtos((dDtRefer + nDiasRef)) + "'"
cQry += " AND C6_NOTA = ' ' "
cQry += " AND " + RetSQLName("SC6")+".D_E_L_E_T_ <> '*'"
If Select("TC6") > 0
	TC6->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TC6"

nTamCod		:= len(SB1->B1_COD)
aStr := {  {"PA"		, "C", nTamCod, 0},;
{"COMP"    	, "C", nTamCod, 0},;
{"QUANT"  	, "N", 14, 2}}
cArqLog    := CriaTrab(aStr, .T.)
DbUseArea(.T., , cArqLog, "TRB", .F.)
COPY TO "EST.DBF"
TRB->(dbCloseArea() )
DbUseArea(.T., , "EST.DBF", "EST", .F.)
Index On PA + COMP To EST2

//Verifica estrutura dos pedidos selecionados
do while TC6->(!eof())
	aEE1 := U_FNA002(TC6->C6_PRODUTO,TC6->C6_PRODUTO)
	FOR nJJ = 1 TO LEN(aEE1)
		IF !empty(aEE1[nJJ,2])
			RecLock("EST",.t.)
			EST->PA		:= TC6->C6_PRODUTO
			EST->COMP   := aEE1[nJJ,2]
			EST->QUANT  := aEE1[nJJ,7]
			EST->(msUnlock())
		endif
	next
	IncProc("Estruturas  "+ alltrim(TC6->C6_PRODUTO)  )
	TC6->(dbSkip())
enddo

//reselecionando pedidos na quantidade correta sem distinct
cQry := " SELECT C6_NUM,C6_PRODUTO, C6_QTDVEN, C6_ENTREG, B1_TIPO  "
cQry += " FROM " + RetSQLName("SC6")
cQry += " INNER JOIN " + RetSQLName("SB1") + " ON B1_COD = C6_PRODUTO "
cQry += " INNER JOIN " + RetSQLName("SG1") + " ON G1_COD = C6_PRODUTO "
cQry += " WHERE C6_FILIAL = '" + xFilial("SC6")+ "'"
cQry += " AND   C6_ENTREG <= '" + dtos((dDtRefer + nDiasRef )) + "'"
cQry += " AND C6_NOTA = ' ' "
cQry += " AND " + RetSQLName("SC6")+".D_E_L_E_T_ <> '*'"
cQry += " ORDER BY B1_COD "
If Select("TC6") > 0
	TC6->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TC6"

If Select("QB1") > 0
	QB1->(DbCloseArea())
EndIf
DbUseArea(.T., , "QB1.DBF", "QB1", .F.)

do While QB1->(!eof())
	do While TC6->(!eof())
		if EST->(dbseek(TC6->C6_PRODUTO ))
			do while EST->PA = TC6->C6_PRODUTO
				if alltrim(EST->COMP) = alltrim(QB1->B1_COD)
					//apura quantidade de produtos acabados vendidos
					nQtdVen := nQtdVen + TC6->C6_QTDVEN
					nQtdCompT := nQtdCompT + EST->QUANT  //* nQtdVen
				endif
				EST->(dbSkip())
			enddo
		endif
		TC6->(dbSkip())
	enddo
	for nLL = 1 to len(aConteud)
		if alltrim(aConteud[nLL,1]) = alltrim(QB1->B1_COD)
			aConteud [nLL,8]  := Round(nQtdCompT,  0 )   //quantidade de venda levantada no c6
		endif
	next
	nQtdCompT := 0

	QB1->(dbSkip())
enddo

dbSelectArea("QB1")
dbCloseArea("QB1")
FErase("QB1.DBF")

dbSelectArea("EST")
dbCloseArea("EST")
FErase("EST.DBF")

MsgAlert( "Tempo de processamento:  " + ELAPTIME(cHora, TIME()) )




//---------------------------------------------------
//Montagem da planilha
//---------------------------------------------------
nCab := 1
aDir := MDirArq()
If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else
	Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
	If lOk
		MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
	EndIf
EndIf
RestArea(aAreaNF)

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := "RELEST"
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.
cDir := "F:\"
//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)

*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)

//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*
Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//
*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValidPerg
//|Descricao.: Valida perguntas utilizadas no SX1
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ValidPerg(cPerg)
*-----------------------------------------*

Local aRegs := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","Produto De" 			,"","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"02","Produto Ate"			,"","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"03","Dt.Referencia"			,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Dias "					,"","","mv_ch4","N",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()









//------------------------------------------------
User Function FNA002(cProDe,cProAte)
//------------------------------------------------
LOCAL Tamanho  		:= "G"
LOCAL titulo   		:= ""
LOCAL cDesc1   		:= ""
LOCAL cDesc2   		:= ""
LOCAL cDesc3   		:= ""
LOCAL cString  		:= "SG1"
LOCAL wnrel	   		:= "FNA002"
PRIVATE lNegEstr	:= GETMV("MV_NEGESTR")
PRIVATE aReturn		:= {OemToAnsi("ZEBRADO"), 1,OemToAnsi("ADM"), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey	:= 0
PRIVATE cPerg		:= "MTR225"

PRIVATE nCntImpr 		:= 0
PRIVATE nTipo    		:= 0
PRIVATE cProduto
PRIVATE nNivel
PRIVATE cPictQuant	:= ""
PRIVATE cPictPerda	:= ""
PRIVATE nX
PRIVATE nPosCnt		:= 0
PRIVATE nPosOld		:= 0
PRIVATE li			:= 80
PRIVATE m_pag		:= 1

Private aEE := {}

pergunte(cPerg,.f.)
MV_PAR01 := cProDe
MV_PAR02 := cProDe   //para rodar somente uma vez, o controle de loop fica com a funcao mrex.

nTipo  := IIF(aReturn[4]==1,15,18)

cabec1   := "  "
cabec2   := "  "

dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("G1_QUANT")
/*
If X3_TAMANHO >= 14
For nX := 1 To 14
If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
cPictQuant := cPictQuant+"."
Else
cPictQuant := cPictQuant+"9"
EndIf
Next nX
Else
For nX := 1 To 14
If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
cPictQuant := "."+cPictQuant
Else
cPictQuant := "9"+cPictQuant
EndIf
Next nX
EndIf

dbSeek("G1_PERDA")
If X3_TAMANHO >= 10
For nX := 1 To 10
If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
cPictPerda := cPictPerda+"."
Else
cPictPerda := cPictPerda+"9"
EndIf
Next nX
Else
For nX := 1 To 10
If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
cPictPerda := "."+cPictPerda
Else
cPictPerda := "9"+cPictPerda
EndIf
Next nX
EndIf
*/
dbSetOrder(1)
dbSelectArea("SG1")

//SetRegua(LastRec())
Set SoftSeek On

dbSeek(xFilial()+mv_par01)
Set SoftSeek Off
While !Eof() .And. G1_FILIAL+G1_COD <= xFilial()+mv_par02
	cProduto := G1_COD
	nNivel   := 2
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	If EOF() .Or. B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04 .Or. B1_GRUPO < mv_par05 .Or. B1_GRUPO > mv_par06
		aadd(aEE,{"","","","","","","","","","","","","","","",""})
		dbSelectArea("SG1")
		While !EOF() .And. xFilial()+cProduto == G1_FILIAL+G1_COD
			dbSkip()
		EndDo
	Else
		nCntImpr++
		dbSelectArea("SB1")
		
		//		@ li,004 PSAY cProduto
		//		@ li,024 PSAY SB1->B1_TIPO
		//		@ li,027 PSAY SB1->B1_GRUPO
		//		@ li,032 PSAY SB1->B1_DESC
		//		@ li,134 PSAY SB1->B1_UM
		//		@ li,137 PSAY If(SB1->B1_QB==0,'      1',SB1->B1_QB) Picture PesqPict("SB1","B1_QB",7)
		
		Li += 2
		nPosOld:=nPosCnt
		nPosCnt+=MR225Expl(cProduto,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,cPictQuant,cPictPerda,B1_OPC,IF(SB1->B1_QB==0,1,SB1->B1_QB),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(Empty(mv_par08),SB1->B1_REVATU,mv_par08))
		For i:=nPosOld to nPosCnt
		Next I
		
		//-- Verifica se salta ou nao pagina
		If mv_par07 == 1
			Li:= 90
		Else
			@ li,000 PSAY __PrtThinLine()
			Li +=2
		EndIf
	EndIf
	dbSelectArea("SG1")
EndDo

return(aEE)

//------------------------------------------------------------------------------------------------------------------------------------------------
STATIC Function MR225Expl(cProduto,nQuantPai,nNivel,cPictQuant,cPictPerda,cOpcionais,nQtdBase,Titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,cRevisao)
//------------------------------------------------------------------------------------------------------------------------------------------------
LOCAL nReg,nQuantItem,nCntItens := 0
LOCAL nPrintNivel
Local nX        := 0
Local aObserv   := {}
Local aAreaSB1:={}

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+cProduto
	aadd(aEE,{"","","","","","","","","","","","","","","",""})
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea("SG1")
	If lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )
		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			dbSelectArea("SB1")
			aAreaSB1:=GetArea()
			dbSeek(xFilial()+cProduto)
			
			RestArea(aAreaSB1)
			Li += 2
			dbSelectArea("SG1")
		EndIf
		
		//-- Divide a Observa‡„o em Sub-Arrays com 45 posi‡”es
		aObserv := {}
		For nX := 1 to MlCount(AllTrim(G1_OBSERV),45)
			aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV),45,nX))
		Next nX
		
		nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
		aEE[len(aEE),1] :=   StrZero(nNivel,3)
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
		aEE[len(aEE),2] :=   G1_COMP
		aEE[len(aEE),3] :=   G1_TRT
		aEE[len(aEE),4] :=   SB1->B1_TIPO
		aEE[len(aEE),5] :=   SB1->B1_GRUPO
		aEE[len(aEE),6] :=   SubStr(SB1->B1_DESC,1,75)
		aEE[len(aEE),7] :=   nQuantItem
		aEE[len(aEE),8] :=   SB1->B1_UM
		aEE[len(aEE),9] :=   G1_PERDA
		aEE[len(aEE),10] :=   G1_QUANT
		aEE[len(aEE),11] :=   SB1->B1_QB
		aEE[len(aEE),12] :=   If(G1_FIXVAR $' úV',"VARIAVEL","FIXA")
		aEE[len(aEE),13] :=   G1_INI
		aEE[len(aEE),14] :=   G1_FIM
		aEE[len(aEE),15] :=   G1_GROPC
		aEE[len(aEE),16] :=   G1_OPC
		
		
		//-- Caso existam, Imprime as outras linhas da Observa‡„o
		If Len(aObserv) > 1
			For nX := 2 to Len(aObserv)
				Li ++
				@ li,84 PSAY aObserv[nX]
			Next nX
		EndIf
		
		Li++
		
		dbSelectArea("SG1")
		dbSeek(xFilial()+G1_COMP)
		IF Found()
			MR225Expl(G1_COD,nQuantItem,nNivel+1,cPictQuant,cPictPerda,cOpcionais,IF(SB1->B1_QB==0,1,SB1->B1_QB),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(!Empty(SB1->B1_REVATU),SB1->B1_REVATU,mv_par08))
		EndIf
		dbGoto(nReg)
	EndIf
	dbSkip()
	nCntItens++
EndDo

nCntItens--

Return nCntItens
