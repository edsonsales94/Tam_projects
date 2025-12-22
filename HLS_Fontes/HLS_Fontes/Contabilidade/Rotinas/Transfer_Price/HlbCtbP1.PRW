#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP1
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados 
//|             da tabela de cadastro de fornecedores
//+-------------------------------------------------------------------------------------------------

*---------------------------*
User Function HlbCtbP1()  
*---------------------------*
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("da tabela de cadastro de fornecedores")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de fornecedores")
Private lEnd      := .F.
Private NomeProg  := "HlbCtbP1"
Private lCopia    := .F.
Private cPerg     := "HLB001"

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
	Processa({|| ArqHlb01() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb01()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de fornecedores - SA2 - que realizaram
//|             fornecimento para a empresa no período especificado
//+-------------------------------------------------------------------------------------------------
*---------------------------*
Static Function ArqHlb01()
*---------------------------*
Local cTexto := Space(110)
Local aForn := {}

Pergunte(cPerg,.F.)

GeraArqTemp()
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))

While !Wrk->(EOF())

   IncProc("Processando fornecedor :"+Wrk->D1_FORNECE)

   
   If (nPos := Ascan(aForn,{|x| x[1]+x[2] = Wrk->D1_FORNECE+Wrk->D1_LOJA})) = 0 

      AADD(aForn,{Wrk->D1_FORNECE,Wrk->D1_LOJA,Wrk->D1_EMISSAO,Wrk->D1_EMISSAO})
      lCopia := .T.

   Else   
      If Wrk->D1_EMISSAO < aForn[nPos][3]
         aForn[nPos][3] := Wrk->D1_EMISSAO
      EndIf

      If Wrk->D1_EMISSAO > aForn[nPos][4]
         aForn[nPos][4] := Wrk->D1_EMISSAO
      EndIf
   EndIf

   Wrk->(dbSkip())

End

Wrk->(dbCloseArea())
SA2->(dbSetOrder(1))

SET CENTURY ON

For nX:=1 to Len(aForn)

   If SA2->(dbSeek(xFilial("SA2")+aForn[nX][1]+aForn[nX][2]))
     cTexto := Space(110)
     cTexto := Stuff(cTexto,001,014,PadR(Alltrim(SA2->A2_COD),14))     // Cóodigo Fornecedor
     cTexto := Stuff(cTexto,015,084,PadR(Alltrim(SA2->A2_NOME),70))    // Decrição Fornecedor
     cTexto := Stuff(cTexto,085,087,PadR(Alltrim(SA2->A2_PAIS),03))    // País Fornecedor
     cTexto := Stuff(cTexto,088,088,PadR(Alltrim(SA2->A2_VINCULO),01))  // Vinculado ?
   //cTexto := Stuff(cTexto,089,098,PadR(Space(10),10))                // Inicio Vincluto
   //cTexto := Stuff(cTexto,099,108,PadR(Space(10),10))                // Fim Vinculo
     cTexto := Stuff(cTexto,109,122,PadR(Alltrim(SA2->A2_CGC),14))     // CNPJ

     Grava(cTexto)
   EndIf
   
Next nX   

Grava("",.T.)

SET CENTURY OFF

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
	
 PutSX1(cPerg,"01","   Filial de     : ","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
 PutSX1(cPerg,"02","   Filial Ate    : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
 PutSX1(cPerg,"03","   Data de       : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
 PutSX1(cPerg,"04","   Data Ate      : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
 PutSX1(cPerg,"05","   Fornecedor de : ","","","mv_ch5","C",06,0,0,"G","","","","","mv_par05")
 PutSX1(cPerg,"06","   Fornecedor Ate: ","","","mv_ch6","C",06,0,0,"G","","","","","mv_par06")

	
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

*-------------------------------------*
Static Function Grava(cTxt,lFecha)
*-------------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"Fornecedores.txt"
cTmpFile  := cPath +"Fornecedores.tmp"

	
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
       MsgInfo("Foi gerado arquivo de Fornecedores, arquivo: "+cFileName,"Informacao")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return

*-------------------------------*
Static Function GeraArqTemp()
*-------------------------------*
Local cQry := ""

cQry := "SELECT DISTINCT D1_FILIAL, D1_FORNECE, D1_LOJA, D1_EMISSAO "
cQry += "FROM "+RetSqlName("SD1")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "D1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQry += "D1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "
cQry += "D1_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND D1_TIPO = 'N' AND "
cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "B1_FILIAL = D1_FILIAL AND B1_COD = D1_COD AND B1_TIPO NOT IN ('EX','ML') ) "
cQry += "ORDER BY D1_FILIAL,D1_FORNECE,D1_LOJA,D1_EMISSAO"
TCQuery cQry Alias Wrk New

Return