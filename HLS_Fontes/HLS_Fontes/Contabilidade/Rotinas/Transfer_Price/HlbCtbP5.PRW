#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP5
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 12/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados 
//|             para análise de relação de produção
//+-------------------------------------------------------------------------------------------------

*---------------------------*
User Function HlbCtbP5()   
*---------------------------*
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("para analise de relação de produção")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de relação de produção")
Private lEnd      := .F.
Private NomeProg  := "HlbCtbP5"
Private lCopia    := .F.
Private cPerg     := "HLB005"

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
	Processa({|| ArqHlb05() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb05()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 12/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de NFS - SD2 e SF2 - no período especificado
//+-------------------------------------------------------------------------------------------------
*---------------------------*
Static Function ArqHlb05()   
*---------------------------*
Local cTexto := Space(110)
Local aPR := {},aRE := {}, cUm
Local cUmProd := ""
Local cUmReq := ""

Pergunte(cPerg,.F.)

SB1->(dbSetOrder(1))
SD2->(dbSetOrder(1))
SF4->(dbSetOrder(1))

GeraArqTemp()
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))

SET CENTURY ON

While !Wrk->(EOF())
  IncProc("Processando OP -> "+Wrk->OP_PROD)

   IncProc("Processando periodo :"+dtoc(Stod(Wrk->EMI_INI)))
	cUmProd := Posicione("SB1",1,xFilial("SB1")+Wrk->COD_PROD,"B1_UM")
	cUmReq  := Posicione("SB1",1,xFilial("SB1")+Wrk->COD_REQ,"B1_UM")

//Daniel Tornisielo em 20/11/2019
	cUmProd := Posicione("SAH",1,xFilial("SAH")+cUmProd,"AH_CODERP")
	cUmReq 	:= Posicione("SAH",1,xFilial("SAH")+cUmReq,"AH_CODERP")
//Fim

	cTexto := Space(118)                  
	cTexto := Stuff(cTexto,001,015,PadR(Wrk->COD_PROD,15))                									//Código do PA
	cTexto := Stuff(cTexto,016,032,PadR(TiraPonto(Wrk->QTD_PROD,18,4),17))									//Quantidade PA produzida
//	cTexto := Stuff(cTexto,033,034,PadR(Posicione("SAH",1,xFilial("SAH")+cUmProd,"AH_COD_SIS"),02)) //Unidade de medida PA - Luciano

//Daniel Tornisielo em 20/11/2019
	//cTexto := Stuff(cTexto,033,034,PadR(Posicione("SB1",1,xFilial("SB1")+Wrk->COD_REQ,"B1_UM"),02)) //Luciano
	cTexto := Stuff(cTexto,033,034,PadR(cUmProd,02))
//Fim

	cTexto := Stuff(cTexto,035,049,PadR(Wrk->COD_REQ,15))															//Código da MP
	cTexto := Stuff(cTexto,050,066,PadR(TiraPonto(Wrk->QTD_REQ,18,4),17))									//Quantidade MP requisitada
//	cTexto := Stuff(cTexto,067,068,PadR(Posicione("SAH",1,xFilial("SAH")+cUmReq,"AH_COD_SIS"),02))	//Unidade de medida MP - Luciano

//Daniel Tornisielo em 20/11/2019
	//cTexto := Stuff(cTexto,067,068,PadR(Posicione("SB1",1,xFilial("SB1")+Wrk->COD_REQ,"B1_UM"),02)) //Luciano
	cTexto := Stuff(cTexto,067,068,PadR(cUmReq,02)) 
//Fim

	cTexto := Stuff(cTexto,069,082,PadR(Wrk->OP_PROD,14))															//Numero OP
	cTexto := Stuff(cTexto,083,092,PadR(sTod(Wrk->EMI_INI),10))													//Data inicio
	cTexto := Stuff(cTexto,093,102,PadR(sTod(Wrk->EMI_FIM),10))													//Data fim
	cTexto := Stuff(cTexto,103,104,PadR("IS",02))																	//Tipo relação
	cTexto := Stuff(cTexto,105,118,PadR(Posicione("SM0",1,"01"+xFilial("SD3"),"M0_CGC"),14))			//CNPJ
         
	Grava(cTexto)
   lCopia := .T.
   Wrk->(dbSkip())
   
End

Wrk->(dbCloseArea())

Grava("",.T.)

SET CENTURY OFF

Return
 
//+-------------------------------------------------------------------------------------------------
//| Programa..: ValidPerg()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 09/03/06
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grupo de perguntas para consulta
//+-------------------------------------------------------------------------------------------------

*---------------------------------*
Static Function ValidPerg(cPerg)
*---------------------------------*
	
 PutSX1(cPerg,"01","  Filial de   : ","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
 PutSX1(cPerg,"02","  Filial Ate  : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
 PutSX1(cPerg,"03","  Data de     : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
 PutSX1(cPerg,"04","  Data Ate    : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
 PutSX1(cPerg,"05","  Produto de  : ","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
 PutSX1(cPerg,"06","  Produto Ate : ","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
 //PutSX1(cPerg,"07","  Gera Arquivo: ","","","mv_ch7","N",01,0,0,"C","","","","","mv_par07","Ordem de Producao","","","","Relacao de Producao")
	
Return Nil
	
//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 09/03/06
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------

*----------------------------------*
Static Function Grava(cTxt,lFecha)
*----------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"OrdProducao.txt"
cTmpFile  := cPath +"OrdProducao.tmp"

	
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
       MsgInfo("Foi gerado arquivo de Producao, arquivo: "+cFileName,"Informacao")
	   //MsgInfo("Processo finalizado com sucesso!","Final")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return
*-----------------------------------------------*
Static Function TiraPonto( nValor,nTam,nDec )
*-----------------------------------------------*

nValor := Str(nValor,nTam,nDec )
nValor := Replicate("0",nTam-len(Alltrim(nValor)))+Alltrim(nValor)

Return StrTran( nValor,'.','' )

*--------------------------------------*
Static Function GeraArqTemp()
*--------------------------------------*
Local cQry := ""
/*
cQry := " SELECT A.D3_COD COD_PROD, B.D3_COD COD_REQ, A.D3_OP OP_PROD, B.D3_OP OP_REQ, "
cQry += " A.D3_EMISSAO EMI_INI, B.D3_EMISSAO EMI_FIM, 
//cQry += " A.D3_QUANT QTD_PROD, 
cQry += " (SELECT SUM(D3_QUANT) FROM "+RetSqlName("SD3")+" C WHERE C.D_E_L_E_T_ <> '*' AND A.D3_OP = C.D3_OP AND A.D3_COD = C.D3_COD) QTD_PROD,"
cQry += " B.D3_QUANT QTD_REQ "
cQry += " FROM "+RetSqlName("SD3")+" A, "+RetSqlName("SD3")+" B "
cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
cQry += " AND A.D3_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQry += " AND A.D3_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "
cQry += " AND A.D3_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQry += " AND A.D3_TIPO IN ('PA','PP','ME','PI','RV') "
cQry += " AND A.D3_ESTORNO = '' "
cQry += " AND LEFT(A.D3_CF,2) = 'PR' "
cQry += " AND B.D3_TIPO IN ('MP','MI','MN','PA','PP','OI','EM','PI','RV','MS') "
cQry += " AND (B.D3_CF = 'RE1' OR B.D3_CF = 'RE2') "
cQry += " AND A.D3_FILIAL = B.D3_FILIAL "
cQry += " AND A.D3_OP = B.D3_OP "
cQry += " AND A.D3_IDENT = B.D3_IDENT "
cQry += " AND A.D3_NUMSEQ = B.D3_NUMSEQ "
cQry += " AND EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' "
cQry += " AND B1_FILIAL = A.D3_FILIAL AND B1_COD = A.D3_COD AND B1_TIPO NOT IN ('EX','ML') ) "
cQry += " ORDER BY A.D3_FILIAL,A.D3_EMISSAO,A.D3_OP,A.D3_COD,B.D3_COD "
*/


//cQry := " SELECT SD3PRD.D3_FILIAL,SD3PRD.D3_COD COD_PROD,SD3COMP.D3_COD COD_REQ, SD3PRD.D3_OP OP_PROD, SD3PRD.D3_EMISSAO EMI_INI, SD3COMP.D3_EMISSAO EMI_FIM, SUM(SD3PRD.D3_QUANT) AS QTD_PROD, SUM(SD3COMP.D3_QUANT) AS QTD_REQ "+CHR(10)+CHR(13) 
cQry := " SELECT SD3PRD.D3_FILIAL,SD3PRD.D3_COD COD_PROD,SD3COMP.D3_COD COD_REQ, SD3PRD.D3_OP OP_PROD, SC2.C2_EMISSAO EMI_INI, SC2.C2_DATPRF EMI_FIM, SUM(SD3PRD.D3_QUANT) AS QTD_PROD, SUM(SD3COMP.D3_QUANT) AS QTD_REQ "+CHR(10)+CHR(13) 
cQry += "FROM "+RetSqlName("SD3")+" SD3PRD "+CHR(10)+CHR(13) 
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.B1_FILIAL=SD3PRD.D3_FILIAL AND SB1.B1_COD=SD3PRD.D3_COD AND SB1.B1_TIPO NOT IN ('EX','ML') AND SB1.D_E_L_E_T_= ' ') "+CHR(10)+CHR(13)
cQry += " INNER JOIN "+RetSqlName("SD3")+" SD3COMP ON (SD3COMP.D3_FILIAL=SD3PRD.D3_FILIAL AND SD3COMP.D3_OP=SD3PRD.D3_OP AND "+CHR(10)+CHR(13)
cQry += " SD3COMP.D3_TIPO IN ('MP','MI','MN','PA','PP','OI','EM','PI','RV','MS') AND (SD3COMP.D3_CF = 'RE1' OR SD3COMP.D3_CF = 'RE2') AND "+CHR(10)+CHR(13)
cQry += " SD3PRD.D3_IDENT = SD3COMP.D3_IDENT AND SD3PRD.D3_NUMSEQ = SD3COMP.D3_NUMSEQ AND SD3COMP.D_E_L_E_T_=' ') "+CHR(10)+CHR(13)
cQry += " INNER JOIN "+RetSqlName("SC2")+" SC2 ON (SC2.C2_FILIAL=SD3PRD.D3_FILIAL AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN=SD3PRD.D3_OP AND SC2.D_E_L_E_T_=' ') "+CHR(10)+CHR(13)
cQry += " WHERE SD3PRD.D3_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "+CHR(10)+CHR(13)
cQry += " SD3PRD.D3_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "+CHR(10)+CHR(13)
cQry += " SD3PRD.D3_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "+CHR(10)+CHR(13)
cQry += " SD3PRD.D3_ESTORNO = '' AND "+CHR(10)+CHR(13)
cQry += " SD3PRD.D3_TIPO IN ('PA','PP','ME','PI','RV') AND "+CHR(10)+CHR(13)
cQry += " LEFT(SD3PRD.D3_CF,2) = 'PR' AND "+CHR(10)+CHR(13)
cQry += " SD3PRD.D_E_L_E_T_=' ' "+CHR(10)+CHR(13)
//cQry += " GROUP BY SD3PRD.D3_FILIAL,SD3PRD.D3_COD,SD3COMP.D3_COD, SD3PRD.D3_OP, SD3PRD.D3_EMISSAO, SD3COMP.D3_EMISSAO "+CHR(10)+CHR(13)
cQry += " GROUP BY SD3PRD.D3_FILIAL,SD3PRD.D3_COD,SD3COMP.D3_COD, SD3PRD.D3_OP, SC2.C2_EMISSAO, SC2.C2_DATPRF "+CHR(10)+CHR(13)
//cQry += " ORDER BY SD3PRD.D3_FILIAL,SD3PRD.D3_EMISSAO,SD3PRD.D3_OP,SD3PRD.D3_COD,SD3COMP.D3_COD "+CHR(10)+CHR(13)
cQry += " ORDER BY SD3PRD.D3_FILIAL,SC2.C2_EMISSAO,SD3PRD.D3_OP,SD3PRD.D3_COD,SD3COMP.D3_COD "+CHR(10)+CHR(13)
TCQuery cQry Alias Wrk New

Return
