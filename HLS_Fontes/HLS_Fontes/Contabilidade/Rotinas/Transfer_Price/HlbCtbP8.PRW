#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP8
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados 
//|             da tabela de Filiais
//+-------------------------------------------------------------------------------------------------

*---------------------------*
User Function HlbCtbP8()  
*---------------------------*
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("da tabela de Filiais")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de fornecedores")
Private lEnd      := .F.
Private NomeProg  := "HlbCtbP8"
Private lCopia    := .F.
Private cPerg     := "HLB008"

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
	Processa({|| ArqHlb08() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb08()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de filiais - SM0 - que realizaram
//|             operações de compra ou venda no período especificado
//+-------------------------------------------------------------------------------------------------
*---------------------------*
Static Function ArqHlb08()
*---------------------------*
Local cTexto := Space(84)
Local aFil := {}, cCNPJ := ""

Pergunte(cPerg,.F.)

GeraArqTemp()
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))

While !Wrk->(EOF())

   IncProc("Processando fornecedor :"+Wrk->NFILIAL)

   If (nPos := Ascan(aFil,Wrk->NFILIAL)) = 0 

      AADD(aFil,Wrk->NFILIAL)
      lCopia := .T.

   EndIf

   Wrk->(dbSkip())

End

Wrk->(dbCloseArea())

ProcRegua(Len(aFil))

For nX:=1 to Len(aFil)

   If SM0->(dbSeek("01"+aFil[nX]))
   
	IncProc("Gravando filial : "+SM0->M0_CGC+" no arquivo")
    
     cTexto := Space(84)
     cTexto := Stuff(cTexto,001,014,PadR(Alltrim(SM0->M0_CGC),14))     // CNPJ
     cTexto := Stuff(cTexto,015,084,PadR(Alltrim(SM0->M0_NOMECOM),70)) // Decrição Filial

     Grava(cTexto)
   EndIf
   
Next nX   

Grava("",.T.)

Return
 
//+-------------------------------------------------------------------------------------------------
//| Programa..: ValidPerg()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
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

	
Return Nil
	
//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------

*-------------------------------------*
Static Function Grava(cTxt,lFecha)
*-------------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"Filiais.txt"
cTmpFile  := cPath +"Filiais.tmp"

	
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
       MsgInfo("Foi gerado arquivo de filiais, arquivo: "+cFileName,"Informacao")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return

*-------------------------------*
Static Function GeraArqTemp()
*-------------------------------*
Local cQry := ""

cQry := "SELECT DISTINCT T.NFILIAL FROM("
cQry += "SELECT DISTINCT F1_FILIAL NFILIAL FROM "+RetSqlName("SF1")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "F1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQry += "F1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "
cQry += "UNION "
cQry += "SELECT DISTINCT F2_FILIAL NFILIAL FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQry += "F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' ) T "
cQry += "GROUP BY T.NFILIAL "
cQry += "ORDER BY T.NFILIAL"
TCQuery cQry Alias Wrk New

Return