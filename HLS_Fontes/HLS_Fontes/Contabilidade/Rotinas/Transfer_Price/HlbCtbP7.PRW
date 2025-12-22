#Include "rwmake.ch"
#Include "topconn.ch"

//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP7
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 10/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados
//|             para análise de vendas
//+-------------------------------------------------------------------------------------------------

*--------------------------*
User Function HlbCtbP7() 
*--------------------------*
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("para analise de vendas")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de vendas")
Private lEnd      := .F.
Private NomeProg  := "HlbCtbP7"
Private lCopia    := .F.
Private cPerg     := "HLB007"

ValidPerg(cPerg)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, cDesc3 )


aAdd(aButton, { 5,.T.,{|| Pergunte(cPerg,.T.) } } )
aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( Titulo, aSay, aButton )
	
If nOpcao == 1
	Processa({|| ArqHlb07() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return
	
//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb07()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 10/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de NFS - SD2 e SF2 - no período especificado
//+-------------------------------------------------------------------------------------------------
*---------------------------*	
Static Function ArqHlb07()  
*---------------------------*
Local cTexto := Space(110)
Local aVend := {}
	
Pergunte(cPerg,.F.)
	
SE1->(dbSetOrder(2))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
SF4->(dbSetOrder(1))
//SB9->(dbSetOrder(1))//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
	
GeraArqTemp(1)
WrkSf2->(dbGoTop())

ProcRegua(WrkSf2->(LastRec()))
	
While !WrkSf2->(EOF())
		
	IncProc("Processando cliente :"+WrkSf2->F2_CLIENTE)
		
	SE1->(dbSeek(xFilial("SE1")+WrkSf2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)))

    GeraArqTemp(2,WrkSf2->F2_FILIAL,WrkSf2->F2_DOC,WrkSf2->F2_SERIE,WrkSf2->F2_CLIENTE,WrkSf2->F2_LOJA)

	While !WrkSd2->(EOF())
		
		SF4->(dbSeek(WrkSd2->D2_FILIAL+WrkSd2->D2_TES))
		// Alterado por Williams Messa a pedido da Deloitte                         
		//If SF4->F4_ESTOQUE # "S" //.or. WrkSd2->D2_LOCAL == '99' //SF4->F4_DUPLIC # "S" .or. -->Retirada condição de verificação da geração do
		//	WrkSd2->(dbSkip())                                                            //financeiro por Ulisses Jr a pedido do Sr. Williams em 01/12/09
		//	Loop                                                                          //considerando todas as saídas que movimentaram estoque
		//EndIf			
						
		nComis := WrkSd2->(D2_COMIS1+D2_COMIS2+D2_COMIS3+D2_COMIS4+D2_COMIS5)
		/*
		If SB9->(dbSeek(WrkSf2->F2_FILIAL+WrkSd2->D2_COD+WrkSd2->D2_LOCAL+WrkSf2->F2_EMISSAO))
			nCusto := SB9->B9_VINI1
		Else
			nCusto := 0
		EndIf
		  */			       
		AADD(aVend,{Alltrim(WrkSf2->F2_CLIENTE)					         ,; // Código do Cliente
		            WrkSf2->F2_DOC                                     ,; // Nota fiscal de saída
		            WrkSf2->F2_SERIE                                   ,; // Séria da nota fiscal
		            Space(14)                                          ,; // Código da divisão		            
		            WrkSd2->D2_CF                                      ,; // CFOP
		            Stod(WrkSf2->F2_EMISSAO)                           ,; // Data de Emissão
						SE1->E1_VENCREA                                    ,; // Data de Vencimento
						StrZero(If(Empty(SE1->E1_VENCREA) .or. Empty(WrkSf2->F2_EMISSAO),0,SE1->E1_VENCREA-Stod(WrkSf2->F2_EMISSAO)),4),; // Prazo de Vencimento
						StrZero(Val(WrkSd2->D2_ITEM),14)                   ,; // Item da nota fiscal
						WrkSd2->D2_COD                                     ,; // Código do Produto
						TiraPonto(WrkSd2->D2_QUANT,18,3)                   ,; // Quantidade
						TiraPonto(WrkSd2->D2_TOTAL,18,2)                   ,; // Valor Venda
						TiraPonto(WrkSd2->D2_DESCON,18,2)                  ,; // Descontos
						TiraPonto(WrkSd2->D2_VALICM,18,2)                  ,; // Icms
						TiraPonto(WrkSd2->D2_VALIMP6,18,2)                 ,; // Pis
						TiraPonto(WrkSd2->D2_VALIMP5,18,2)                 ,; // Cofins
						TiraPonto(WrkSd2->D2_VALISS,18,2)                  ,; // ISS
						TiraPonto(nComis,18,2)                             ,; // Comissão
						Tiraponto(WrkSd2->D2_VALFRE,18,2)                  ,; // Frete
						TiraPonto(WrkSd2->D2_SEGURO,18,2)                  ,; // Seguro
						Stod(WrkSf2->F2_EMISSAO)                           ,; // Data de Embarque
						"790"		                                          ,; // Moeda Estrangeira
						TiraPonto(WrkSd2->D2_TOTAL,18,2)                   ,; // Valor em moeda estrangeira - A pedido da Deloitte
						TiraPonto(WrkSd2->D2_CUSTO1,18,2)                  ,; // Custo da Venda //
						Space(14)                                          ,; // Registro de expostação
						Posicione("SM0",1,"01"+WrkSd2->D2_FILIAL,"M0_CGC")})  // CNPJ
						
		lCopia := .T.
		WrkSd2->(dbSkip())
						
	End

WrkSd2->(dbCloseArea())

WrkSf2->(dbSkip())
			
End

WrkSf2->(dbCloseArea())
		
ProcRegua(Len(aVend))
		
SET CENTURY ON

For nX:=1 to Len(aVend)
			
	IncProc("Gravando cliente : "+aVend[nX][1]+" no arquivo")
			
	cTexto := Space(345)
	cTexto := Stuff(cTexto,001,014,PadR(aVend[nX][01],14))//Código do Cliente
	cTexto := Stuff(cTexto,015,028,PadR(aVend[nX][02],14))//Número da NF
	cTexto := Stuff(cTexto,029,042,PadR(aVend[nX][03],14))//Série da NF
	cTexto := Stuff(cTexto,043,056,PadR(aVend[nX][04],14))//Nome da Divisão
	cTexto := Stuff(cTexto,057,061,PadR(aVend[nX][05],05))//CFOP
	cTexto := Stuff(cTexto,062,071,PadR(aVend[nX][06],10))//Data da Emissão
	cTexto := Stuff(cTexto,072,081,PadR(aVend[nX][07],10))//Data Vencimento
	cTexto := Stuff(cTexto,082,085,PadR(aVend[nX][08],04))//Prazo de vencimento
	cTexto := Stuff(cTexto,086,099,PadR(aVend[nX][09],14))//Item da nota fiscal
	cTexto := Stuff(cTexto,100,114,PadR(aVend[nX][10],15))//Código do Produto
	cTexto := Stuff(cTexto,115,131,PadR(aVend[nX][11],17))//Quantidade
	cTexto := Stuff(cTexto,132,148,PadR(aVend[nX][12],17))//Valor da venda
	cTexto := Stuff(cTexto,149,165,PadR(aVend[nX][13],17))//Descontos
	cTexto := Stuff(cTexto,166,182,PadR(aVend[nX][14],17))//ICMS
	cTexto := Stuff(cTexto,183,199,PadR(aVend[nX][15],17))//PIS
	cTexto := Stuff(cTexto,200,216,PadR(aVend[nX][16],17))//COFINS
	cTexto := Stuff(cTexto,217,233,PadR(aVend[nX][17],17))//ISS
	cTexto := Stuff(cTexto,234,250,PadR(aVend[nX][18],17))//Comissão
	cTexto := Stuff(cTexto,251,267,PadR(aVend[nX][19],17))//Frete
	cTexto := Stuff(cTexto,268,284,PadR(aVend[nX][20],17))//Seguro
	cTexto := Stuff(cTexto,285,294,PadR(aVend[nX][21],10))//Data de Embarque
	cTexto := Stuff(cTexto,295,297,PadR(aVend[nX][22],03))//Código da moeda estrangeira
	cTexto := Stuff(cTexto,298,314,PadR(aVend[nX][23],17))//Valor em moeda estrangeira
	cTexto := Stuff(cTexto,315,331,PadR(aVend[nX][24],17))//Custo da Venda (CPV)
	cTexto := Stuff(cTexto,332,345,PadR(aVend[nX][25],14))//Número da RE
	cTexto := Stuff(cTexto,346,359,PadR(aVend[nX][26],14))//CNPJ
			
	Grava(cTexto)
			
Next nX
		
Grava("",.T.)
		
SET CENTURY OFF

Return
	
//+-------------------------------------------------------------------------------------------------
//| Programa..: ValidPerg()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 10/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grupo de perguntas para consulta
//+-------------------------------------------------------------------------------------------------
		
*---------------------------------*
Static Function ValidPerg(cPerg)
*---------------------------------*
		
PutSX1(cPerg,"01","   Filial de  : ","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","   Filial Ate : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
PutSX1(cPerg,"03","   Data de    : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
PutSX1(cPerg,"04","   Data Ate   : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
PutSX1(cPerg,"05","   Cliente de : ","","","mv_ch5","C",06,0,0,"G","","","","","mv_par05")
PutSX1(cPerg,"06","   Cliente Ate: ","","","mv_ch6","C",06,0,0,"G","","","","","mv_par06")
PutSX1(cPerg,"07","   Produto de : ","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07")
PutSX1(cPerg,"08","   Produto Ate: ","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08")
		
Return Nil
		
//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 10/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------
		
*----------------------------------*
STATIC FUNCTION Grava(cTxt,lFecha)
*----------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
		
cPath := "\Transfer price\"
cFileName := cPath +"Vendas.txt"
cTmpFile  := cPath +"Vendas.tmp"
		
		
If lFecha == NIL .Or. lFecha == .F.
	If !File(cTmpFile)
		fHandle:=FCREATE(cTmpFile)
	Else
		fHandle := FOPEN(cTmpFile,2)
	Endif
	cString := cTxt+CHR(13)+CHR(10)
	FSEEK(fHandle,0,2)
	FWRITE(fHandle,cString)
	FCLOSE(fHandle)
Else
	If File(cFileName)
		FErase(cFileName)
	Endif
	FRename(cTmpFile, cFileName)
	If lCopia
		MsgInfo("Foi gerado arquivo de Vendas, arquivo: "+cFileName,"Informacao")
		//MsgInfo("Processo finalizado com sucesso!","Final")
	Else
		MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf
		
Endif
		
Return

*---------------------------------------------*
Static Function TiraPonto( nValor,nTam,nDec )
*---------------------------------------------*
nValor := Str(nValor,nTam,nDec )
nValor := Replicate("0",nTam-len(Alltrim(nValor)))+Alltrim(nValor)
Return StrTran( nValor,'.','' )

*------------------------------------------------------------*
Static Function GeraArqTemp(nTipo,xcFilial,cDoc,cSerie,cCliente,cLoja)
*------------------------------------------------------------*
Local cQry := ""

If nTipo = 1
   cQry := "SELECT F2_FILIAL F2_FILIAL,F2_DOC F2_DOC,F2_SERIE F2_SERIE, "
   cQry += "F2_CLIENTE F2_CLIENTE, F2_LOJA F2_LOJA,F2_EMISSAO F2_EMISSAO "
   cQry += "FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
   cQry += "F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "
   cQry += "F2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND F2_TIPO = 'N' " 
   //cQry += "F2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "// AND F2_TIPO = 'N' " --alteração
   cQry += "UNION "
   cQry += "SELECT F1_FILIAL F2_FILIAL,F1_DOC F2_DOC,F1_SERIE F2_SERIE, "
   cQry += "F1_FORNECE F2_CLIENTE, F1_LOJA F2_LOJA,F1_EMISSAO F2_EMISSAO "
   cQry += "FROM "+RetSqlName("SF1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "F1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
   cQry += "F1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "
   cQry += "F1_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND F1_TIPO = 'D' " 
   //cQry += "F1_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " //AND F1_TIPO = 'D' " --alteração
   cQry += "ORDER BY F2_FILIAL,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE"
   TCQuery cQry Alias WrkSf2 New
Else
   cQry := "SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, "
   cQry += "D2_LOCAL, D2_CF, D2_TES, D2_QUANT, D2_TOTAL, D2_VALFRE, D2_SEGURO, D2_COMIS1, "
   cQry += "D2_COMIS2, D2_COMIS3, D2_COMIS4, D2_COMIS5, D2_DESCON, D2_VALICM, D2_VALIMP6, "
   cQry += "D2_VALIMP5, D2_VALISS, D2_CUSTO1 "
   cQry += "FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "D2_FILIAL = '"+xcFilial+"' AND "                         
   cQry += "D2_DOC = '"+cDoc+"' AND D2_SERIE = '"+cSerie+"' AND D2_CLIENTE = '"+cCliente+"' AND "
   cQry += "D2_LOJA = '"+cLoja+"' AND D2_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "//AND D2_TP = 'PA' "
   cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "B1_FILIAL = D2_FILIAL AND B1_COD = D2_COD AND B1_TIPO NOT IN ('EX','ML') )
   cQry += "UNION "
   cQry += "SELECT D1_FILIAL D2_FILIAL, D1_DOC D2_DOC, D1_SERIE D2_SERIE, "
   cQry += "D1_FORNECE D2_CLIENTE, D1_LOJA D2_LOJA, D1_COD D2_COD, D1_ITEM D2_ITEM, "
   cQry += "D1_LOCAL D2_LOCAL, D1_CF D2_CF, D1_TES D2_TES, D1_QUANT D2_QUANT, D1_TOTAL D2_TOTAL, D1_VALFRE D2_VALFRE, "
   cQry += "D1_SEGURO D2_SEGURO, 0 D2_COMIS1, 0 D2_COMIS2, 0 D2_COMIS3, 0 D2_COMIS4, 0 D2_COMIS5, "
   cQry += "D1_VALDESC D2_DESCON, D1_VALICM D2_VALICM, D1_VALIMP6 D2_VALIMP6, "
   cQry += "D1_VALIMP5 D2_VALIMP5, D1_VALISS D2_VALISS, D1_CUSTO D2_CUSTO1 "
   cQry += "FROM "+RetSqlName("SD1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "D1_FILIAL = '"+xcFilial+"' AND "                         
   cQry += "D1_DOC = '"+cDoc+"' AND D1_SERIE = '"+cSerie+"' AND D1_FORNECE = '"+cCliente+"' AND "
   cQry += "D1_LOJA = '"+cLoja+"' AND D1_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "//AND D1_TP = 'PA' "
   cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "B1_FILIAL = D1_FILIAL AND B1_COD = D1_COD AND B1_TIPO NOT IN ('EX','ML') ) "
   cQry += "ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_ITEM"
   TCQuery cQry Alias WrkSd2 New
EndIf

Return
