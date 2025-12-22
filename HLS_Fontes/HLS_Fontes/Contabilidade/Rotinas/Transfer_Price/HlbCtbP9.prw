#Include "rwmake.ch"
#Include "topconn.ch"
/*_______________________________________________________________________________
¦ Função    ¦ HLBCTBP9   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 09/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Geração do arquivo de relação de produção baseado nas notas de    ¦
¦           ¦ saída e estruturas.                                               ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
*---------------------------*
User Function HlbCtbP9()   
*---------------------------*
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
Private NomeProg  := "HlbCtbP9"
Private lCopia    := .F.
Private cPerg     := "HLB009"

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
	Processa({|| ArqHlb09() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

/*_______________________________________________________________________________
¦ Função    ¦ ArqHlb09   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 09/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Coleta dos dados para arquivo.                                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
*---------------------------*
Static Function ArqHlb09()   
*---------------------------*
Local cTexto := Space(083)
Local cUm, vProd := {}
Private vSoma := {}

Pergunte(cPerg,.F.)

GeraArqTemp()
Wrk->(dbGoTop())
nReg := Wrk->(RecCount())

ProcRegua(nReg)

SET CENTURY ON

While !Wrk->(EOF())
	
	IncProc("Processando Produto :"+Wrk->D2_COD)
	
   If Ascan(vProd,{|x| x[1] == Wrk->D2_COD}) == 0
   	vSoma := {}
		ExpEstr(Wrk->D2_COD,1)
  
		For nX := 1 to Len(vSoma)
	
			If Ascan(vProd,{|x| x[1] == vSoma[nX][1] .and. x[2] == vSoma[nX][2]}) == 0
			
				cUmProd := Posicione("SB1",1,xFilial("SB1")+vSoma[nX][1],"B1_UM")
				cUmReq  := Posicione("SB1",1,xFilial("SB1")+vSoma[nX][2],"B1_UM")

				cTexto := Space(083)                  
				cTexto := Stuff(cTexto,001,015,PadR(vSoma[nX][1],15))						//Código do PA
				cTexto := Stuff(cTexto,016,030,PadR(vSoma[nX][2],15))						//Código da MP
				cTexto := Stuff(cTexto,031,047,PadR(TiraPonto(1,18,4),17))				//Quantidade PA produzida
				cTexto := Stuff(cTexto,048,064,PadR(TiraPonto(vSoma[nX][3],18,4),17))//Quantidade MP requisitada
				cTexto := Stuff(cTexto,065,081,PadR(TiraPonto(vSoma[nX][3],18,6),17))//Relação
				cTexto := Stuff(cTexto,082,083,PadR("IS",02))								//Tipo relação

				Grava(cTexto)
   			lCopia := .T.
   		
   			aadd(vProd,{vSoma[nX][1],vSoma[nX][2]})
   		EndIf
		Next
	EndIf
	Wrk->(dbSkip())
End

Wrk->(dbCloseArea())

Grava("",.T.)

Return
 
/*_______________________________________________________________________________
¦ Função    ¦ ExpEstr    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 09/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Explosão da estrutura para retorno das MP's                       ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ExpEstr(cProduto,nQuant)
Local nPos, x, y, vMP
Local nReg := SG1->(Recno()), vRet := {}

If SG1->(dbSeek(xFilial("SG1")+cProduto))
	While !SG1->(Eof()) .And. xFilial("SG1")+cProduto == SG1->(G1_FILIAL+G1_COD)

	   //If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM
	   	If Posicione("SB1",1,XFILIAL("SB1")+SG1->G1_COMP,"B1_TIPO") $ "MN#MI"
	   		nPos := AScan( vRet , {|y| y[1]+y[2] == cProduto+SG1->G1_COMP })
				If nPos == 0
			   	AAdd( vRet , { cProduto, SG1->G1_COMP, 0})
			   	nPos := Len(vRet)
				Endif
				vRet[nPos,3] += SG1->G1_QUANT * nQuant
	   	Else
				vMP := ExpEstr(SG1->G1_COMP,SG1->G1_QUANT)
				For x:=1 To Len(vMP)
					nPos := AScan( vRet , {|y| y[1]+y[2] == cProduto+vMP[x,2] })
					If nPos == 0
				   	AAdd( vRet , { cProduto, vMP[x,2], 0})
				   	nPos := Len(vRet)
					Endif
					vRet[nPos,3] += vMP[x,3]
				Next
			Endif
		//Endif
		SG1->(dbSkip())
	End

	// Soma ao vetor de niveis os totais das materias-primas abaixo deles
	For x:=1 To Len(vRet)
		nPos := AScan( vSoma , {|y| y[1]+y[2] == cProduto+vRet[x,2] })
		If nPos == 0
		   AAdd( vSoma , { cProduto, vRet[x,2], 0})
		   nPos := Len(vSoma)
		Endif
		vSoma[nPos,3] += vRet[x,3]
	Next

Endif

SG1->(dbGoTo(nReg))

Return vRet

/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 09/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Grupo de perguntas para consulta.                                 ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
*---------------------------------*
Static Function ValidPerg(cPerg)
*---------------------------------*
	
 PutSX1(cPerg,"01","  Filial de   : ","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
 PutSX1(cPerg,"02","  Filial Ate  : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
 PutSX1(cPerg,"03","  Data de     : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
 PutSX1(cPerg,"04","  Data Ate    : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
 PutSX1(cPerg,"05","  Produto de  : ","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
 PutSX1(cPerg,"06","  Produto Ate : ","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
// PutSX1(cPerg,"07","  Gera Arquivo: ","","","mv_ch7","N",01,0,0,"C","","","","","mv_par07","Ordem de Producao","","","","Relacao de Producao")
	
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
cFileName := cPath +"RelProducao.txt"
cTmpFile  := cPath +"RelProducao.tmp"

	
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

nValor := Str(NoRound(nValor,4),nTam,nDec )
nValor := Replicate("0",nTam-len(Alltrim(nValor)))+Alltrim(nValor)

Return StrTran( nValor,'.','' )

*--------------------------------------*
Static Function GeraArqTemp()
*--------------------------------------*
Local cQry := ""

/*
cQry += " SELECT D2_COD "
cQry += " FROM "+RetSqlName("SD2") 
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQry += " AND D2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "
cQry += " AND D2_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQry += " AND D2_TIPO = 'N' "
cQry += " AND D2_LOCAL <> '99' "
cQry += " AND EXISTS( SELECT * FROM "+RetSqlName("SB1") 
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND B1_FILIAL = D2_FILIAL "
cQry += " AND B1_COD = D2_COD "
cQry += " AND B1_TIPO NOT IN ('EX','ML') ) "
cQry += " AND EXISTS (SELECT * FROM "+RetSqlName("SF4")
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND F4_CODIGO = D2_TES "
cQry += " AND F4_DUPLIC = 'S' "
cQry += " AND F4_ESTOQUE = 'S') "
cQry += " GROUP BY D2_COD "
  */
cQry += " SELECT B1_COD AS D2_COD "
cQry += " FROM "+RetSqlName("SB1")
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND B1_TIPO = 'PA' "

TCQuery cQry Alias Wrk New
Return
