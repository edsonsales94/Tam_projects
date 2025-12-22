#Include "rwmake.ch"
#Include "topconn.ch"

//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP14
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Luciano Lamberti
//+-------------------------------------------------------------------------------------------------
//| Data......: 01/12/2020
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados 
//|             de saldo em estoque EM/DE TERCEIROS
//+-------------------------------------------------------------------------------------------------


User Function hlssaldo3()   

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
Local cDesc2  := OemToAnsi("de saldos em estoque")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de saldos")
Private lEnd      := .F.
Private NomeProg  := "hlssaldo3"
Private lCopia    := .F.
Private cPerg     := "HLB004"

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
	Processa({|| ArqHlb14() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb14()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Luciano Lamberti
//+-------------------------------------------------------------------------------------------------
//| Data......: 01/12/20
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de saldos em/de terceiros
//+-------------------------------------------------------------------------------------------------
*---------------------------*
Static Function ArqHlb14()
*---------------------------*
Local cArq,cPath,cUM
Local cTexto := Space(45)
Local aProd := {}, aProdAux := {}

Pergunte(cPerg,.F.)

dData := stod(If(month(mv_par03) = 1,strzero(year(mv_par03)-1,4)+"1201",strzero(year(mv_par03),4)+strzero(month(mv_par03)-1,2)+"01"))
dData := LastDay(dData)
dData := dtos(dData)

GeraArqTemp()
Wrk->(dbGoTop())

ProcRegua(Wrk->(LastRec()))
  
While !Wrk->(EOF())

  If dData < Wrk->B6_EMISSAO
     AADD(aProdAux,{Wrk->B6_PRODUTO,dData,0,0})
  EndIf
  
  cCod := Wrk->B6_PRODUTO
    
  While !Wrk->(EOF()) .and. Wrk->B6_PRODUTO = cCod   

      IncProc("Processando produto :"+Wrk->B6_PRODUTO)
 
      If (nPos := Ascan(aProdAux,{|x| x[1] = Wrk->B6_PRODUTO .and. x[2] = Wrk->B6_EMISSAO})) = 0 

         //AADD(aProdAux,{Wrk->B9_COD,Wrk->B9_DATA,Wrk->B9_QINI,Wrk->B9_VINI1})
         AADD(aProdAux,{Wrk->B6_PRODUTO,Wrk->B6_EMISSAO,Wrk->B6_QUANT,Wrk->B6_SALDO})


      Else
       
         aProdAux[nPos][3] += Wrk->B6_QUANT
         aProdAux[nPos][4] += Wrk->B6_SALDO
      
      EndIf
    
     lCopia := .T.

     Wrk->(dbSkip())


  End
  
  aSort(aProdAux,,,{|x,y| x[2] < y[2]})
  nTam := Len(aProdAux)
  AADD(aProd,{aProdAux[1][1],aProdAux[1][2],aProdAux[1][3],aProdAux[1][4]})
  AADD(aProd,{aProdAux[nTam][1],aProdAux[nTam][2],aProdAux[nTam][3],aProdAux[nTam][4]})
  aProdAux:={}
  
End                

Wrk->(dbCloseArea())

aSort(aProd,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

ProcRegua(Len(aProd))

SET CENTURY ON

For nX:=1 to Len(aProd)

  IncProc("Gerando arquivo do produto :"+aProd[nX][1])
  
   cUM := Posicione("SB1",1,xFilial("SB1")+aProd[nX][1],"B1_UM")
   
   cTexto := Space(45)
   cTexto := Stuff(cTexto,001,015,PadR(Alltrim(aProd[nX][1]),15))                               //Produto
   cTexto := Stuff(cTexto,016,025,PadR(sTod(aProd[nX][2]),10))                                  //Data do saldo
   cTexto := Stuff(cTexto,026,042,PadR(TiraPonto(aProd[nX][3],18,3),17))                        //Quantidade
   cTexto := Stuff(cTexto,043,059,PadR(TiraPonto(aProd[nX][4],18,2),17))                        //Valor
   cTexto := Stuff(cTexto,060,061,PadR(Posicione("SAH",1,xFilial("SAH")+cUM,"AH_COD_SIS"),02))  //Unidade de medida
   cTexto := Stuff(cTexto,062,075,PadR(Posicione("SM0",1,"01"+xFilial("SB6"),"M0_CGC"),14))       //CNPJ
   
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
//| Data......: 02/07/07
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
 PutSX1(cPerg,"05","   Produto de : ","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
 PutSX1(cPerg,"06","   Produto Ate: ","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
	
Return Nil
	
//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Luciano Lamberti
//+-------------------------------------------------------------------------------------------------
//| Data......: 01/12/20
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------

*----------------------------------*
Static Function Grava(cTxt,lFecha)
*----------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"Saldos3.txt"
cTmpFile  := cPath +"Saldos3.tmp"

	
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
       MsgInfo("Foi gerado arquivo de Saldos, arquivo: "+cFileName,"Informacao")
	   //MsgInfo("Processo finalizado com sucesso!","Final")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return

*------------------------------------------------*
Static Function TiraPonto( nValor,nTam,nDec )
*------------------------------------------------*

nValor := Str(nValor,nTam,nDec )
nValor := Replicate("0",18-len(Alltrim(nValor)))+Alltrim(nValor)

Return StrTran( nValor,'.','' )

*-------------------------------*
Static Function GeraArqTemp()
*-------------------------------*
Local cQry := ""

cQry := "SELECT * FROM "+RetSqlName("SB6")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "B6_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQry += "B6_EMISSAO BETWEEN '"+dData+"' AND '"+dtos(mv_par04)+"' AND "
cQry += "B6_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQry += "EXISTS( SELECT * FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ <> '*' AND "
cQry += "B1_FILIAL = B6_FILIAL AND B1_COD = B6_PRODUTO AND B1_TIPO NOT IN ('EX','ML') ) "
cQry += "ORDER BY B6_FILIAL,B6_PRODUTO,B6_LOCAL,B6_EMISSAO"
TCQuery cQry Alias Wrk New

Return
