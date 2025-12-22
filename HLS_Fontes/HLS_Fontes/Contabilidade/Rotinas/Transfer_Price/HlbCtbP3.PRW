#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP3
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados 
//|             da tabela de cadastro de produtos
//+-------------------------------------------------------------------------------------------------

*----------------------------*
User Function HlbCtbP3()
*----------------------------*
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("da tabela de cadastro de produtos")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de produtos")
Private lEnd      := .F.
Private NomeProg  := "HlbCtbP3"
Private lCopia    := .F.
Private cPerg     := "HLB003"

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
	Processa({|| ArqHlb03() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb03()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de produtos - SB1 - que foram vendidos
//|             ou comprados pela empresa no período especificado
//+-------------------------------------------------------------------------------------------------
*---------------------------*
Static Function ArqHlb03()
*---------------------------*
Local cTexto := Space(70)
Local aProd := {}

Pergunte(cPerg,.F.)

// Verifica materiais vendidos
SA1->(dbSetOrder(1))
GeraArqTemp(1)
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))

While !Wrk->(EOF())

   IncProc("Processando produto :"+Wrk->D2_COD)

   
   If !SA1->(dbSeek(xFilial("SA1")+Wrk->D2_CLIENTE+Wrk->D2_LOJA))
      Wrk->(dbSkip())
      Loop
   EndIf
   
   If Ascan(aProd,Wrk->D2_COD) = 0 

      AADD(aProd,Wrk->D2_COD)
      lCopia := .T.
      
   EndIf

   Wrk->(dbSkip())

End

Wrk->(dbCloseArea())

// Verifica materiais comprados
SA2->(dbSetOrder(1))

GeraArqTemp(2)
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))

While !Wrk->(EOF())

   IncProc("Processando produto :"+Wrk->D1_COD)

   If !SA2->(dbSeek(xFilial("SA2")+Wrk->D1_FORNECE+Wrk->D1_LOJA))// .and. SA2->A2_YVINCUL <> "S" .and. SA2->A2_EST = "EX"
      Wrk->(dbSkip())
      Loop
   EndIf

   If Ascan(aProd,Wrk->D1_COD) = 0 

      AADD(aProd,Wrk->D1_COD)
      lCopia := .T.
      
   EndIf

   Wrk->(dbSkip())

End

Wrk->(dbCloseArea())
SB1->(dbSetOrder(1))

For nX:=1 to Len(aProd)

   SB1->(dbSeek(xFilial("SB1")+aProd[nX]))
   
	cTexto := Space(70)
	cTexto := Stuff(cTexto,001,015,PadR(Alltrim(SB1->B1_COD),15))
	cTexto := Stuff(cTexto,016,060,PadR(Alltrim(SB1->B1_DESC),45))
	cTexto := Stuff(cTexto,061,062,PadR(Alltrim(SB1->B1_UM),2))	//Inserido a unidade de medida padrão Protheus
//	cTexto := Stuff(cTexto,061,062,PadR(Alltrim(Posicione("SAH",1,xFilial("SAH")+SB1->B1_UM,"AH_COD_SIS")),2)) - alterado por Luciano Lamberti
	cTexto := Stuff(cTexto,063,070,PadR(If(!Empty(SB1->B1_POSIPI),Alltrim(SB1->B1_POSIPI),Repl("0",8)),8))

	Grava(cTexto)

Next nX   

Grava("",.T.)

Return
 
//+-------------------------------------------------------------------------------------------------
//| Programa..: ValidPerg()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grupo de perguntas para consulta
//+-------------------------------------------------------------------------------------------------

*---------------------------------*
Static Function ValidPerg(cPerg)
*---------------------------------*
	
 PutSX1(cPerg,"01","   Filial de  : ","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
 PutSX1(cPerg,"02","   Filial Ate : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
 PutSX1(cPerg,"03","   Data de    : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
 PutSX1(cPerg,"04","   Data Até   : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
 PutSX1(cPerg,"05","   Produto de : ","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
 PutSX1(cPerg,"06","   Produto Até: ","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
	
Return Nil
	
//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------

*-----------------------------------*
Static Function Grava(cTxt,lFecha)
*-----------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"Produtos.txt"
cTmpFile  := cPath +"Produtos.tmp"

	
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
       MsgInfo("Foi gerado arquivo de produtos, arquivo: "+cFileName,"Informacao")
	   //MsgInfo("Processo finalizado com sucesso!","Final")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return

*----------------------------------*
Static Function GeraArqTemp(nTipo)
*----------------------------------*
Local cQry := ""

If nTipo = 1
   cQry := "SELECT * FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
   cQry += "D2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "
   cQry += "D2_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND D2_TIPO = 'N' AND "
   cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "B1_FILIAL = D2_FILIAL AND B1_COD = D2_COD AND B1_TIPO NOT IN ('EX','ML') ) "
   cQry += "ORDER BY D2_FILIAL,D2_COD,D2_LOCAL,D2_NUMSEQ"
Else
   cQry := "SELECT * FROM "+RetSqlName("SD1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "D1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
   cQry += "D1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "
   cQry += "D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND D1_TIPO = 'N' AND "
   cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
   cQry += "B1_FILIAL = D1_FILIAL AND B1_COD = D1_COD AND B1_TIPO NOT IN ('EX','ML') ) "
   cQry += "ORDER BY D1_FILIAL,D1_COD,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA"
EndIf   

TCQuery cQry Alias Wrk New

Return