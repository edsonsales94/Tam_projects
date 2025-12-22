#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP2
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados 
//|             da tabela de cadastro de Clientes
//+-------------------------------------------------------------------------------------------------

*---------------------------*
User Function HlbCtbP2()  
*---------------------------*
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("da tabela de cadastro de Clientes")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de clientes")
Private lEnd      := .F.
Private NomeProg  := "HlbCtbP2"
Private lCopia    := .F.
Private cPerg     := "HLB002"

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
	Processa({|| ArqHlb02() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb02()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 28/06/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de cliente - SA1 - que realizaram
//|             compras na empresa no período especificado
//+-------------------------------------------------------------------------------------------------
*---------------------------*
Static Function ArqHlb02()
*---------------------------*
Local cTexto := Space(110)
Local aCli := {}

Pergunte(cPerg,.F.)

GeraArqTemp()
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))

While !Wrk->(EOF())

   IncProc("Processando cliente :"+Wrk->D2_CLIENTE)

   If (nPos := Ascan(aCli,{|x| x[1]+x[2] = Wrk->D2_CLIENTE+Wrk->D2_LOJA})) = 0 

      AADD(aCli,{Wrk->D2_CLIENTE,Wrk->D2_LOJA,Wrk->D2_EMISSAO,Wrk->D2_EMISSAO})
      lCopia := .T.

   Else
      If Wrk->D2_EMISSAO < aCli[nPos][3]
         aCli[nPos][3] := Wrk->D2_EMISSAO
      EndIf

      If Wrk->D2_EMISSAO > aCli[nPos][4]
         aCli[nPos][4] := Wrk->D2_EMISSAO
      EndIf
   EndIf

   Wrk->(dbSkip())

End

Wrk->(dbCloseArea())
SA1->(dbSetOrder(1))

SET CENTURY ON

For nX:=1 to Len(aCli)

   If SA1->(dbSeek(xFilial("SA1")+aCli[nX][1]+aCli[nX][2]))
      cTexto := Space(110)
      cTexto := Stuff(cTexto,001,014,PadR(Alltrim(SA1->A1_COD),14))     // Código Cliente
      cTexto := Stuff(cTexto,015,084,PadR(Alltrim(SA1->A1_NOME),70))    // Nome Cliente
      cTexto := Stuff(cTexto,085,087,PadR(Alltrim(SA1->A1_PAIS),03))    // País Cliente
      cTexto := Stuff(cTexto,088,088,PadR(Alltrim(SA1->A1_VINCULO),01))  // Cliente Vinculado ?
    //cTexto := Stuff(cTexto,089,098,PadR(Space(10),10))                // Inicio do vínculo
    //cTexto := Stuff(cTexto,099,108,PadR(Space(10),10))                // Fim do vínculo
      cTexto := Stuff(cTexto,109,122,PadR(Alltrim(SA1->A1_CGC),14))     // CNPJ
   
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
	
 PutSX1(cPerg,"01","   Filial de  : ","","","mv_ch1","C",02,0,0,"G","","","","","	")
 PutSX1(cPerg,"02","   Filial Ate : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
 PutSX1(cPerg,"03","   Data de    : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
 PutSX1(cPerg,"04","   Data Ate   : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
 PutSX1(cPerg,"05","   Cliente de : ","","","mv_ch5","C",06,0,0,"G","","","","","mv_par05")
 PutSX1(cPerg,"06","   Cliente Ate: ","","","mv_ch6","C",06,0,0,"G","","","","","mv_par06")
 	
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

*------------------------------------*
Static Function Grava(cTxt,lFecha)
*------------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"Clientes.txt"
cTmpFile  := cPath +"Clientes.tmp"

	
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
       MsgInfo("Foi gerado arquivo de Clientes, arquivo: "+cFileName,"Informacao")
	   //MsgInfo("Processo finalizado com sucesso!","Final")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return

*-------------------------------*
Static Function GeraArqTemp()
*-------------------------------*
Local cQry := ""

cQry := "SELECT DISTINCT D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_EMISSAO "
cQry += "FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQry += "D2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' AND "
cQry += "D2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND D2_TIPO = 'N' AND "
cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "B1_FILIAL = D2_FILIAL AND B1_COD = D2_COD AND B1_TIPO NOT IN ('EX','ML') ) "
cQry += "ORDER BY D2_FILIAL,D2_CLIENTE,D2_LOJA,D2_EMISSAO"
TCQuery cQry Alias Wrk New

Return