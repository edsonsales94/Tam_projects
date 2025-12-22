#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*_______________________________________________________________________________
¦ Função    ¦ HLCTBP11   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 18/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Geração do arquivo de relação de produção baseado nas notas de    ¦
¦           ¦ saída e estruturas.                                               ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLCTBP11()
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
Private NomeProg  := "HlCtbP11"
Private lCopia    := .F.
Private cPerg     := "HLB011"

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
	Processa({|| ArqHlb11() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return NIL
/*_______________________________________________________________________________
¦ Função    ¦ ArqHlb11   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 18/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Geração arquivo temporátio base para montagem do arquivo final    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ArqHlb11()
Private aProd := {},aAux := {}

Pergunte(cPerg,.F.)

SG1->(dbSetOrder(1))
GeraArqTemp()
Wrk->(dbGoTop())

ProcRegua(Wrk->(Reccount()))

While !Wrk->(Eof())

	IncProc("Processando Produto :"+Wrk->D2_COD)

	If Ascan(aAux,{|x| x[1] == Wrk->D2_COD}) == 0
		aProd := {}
		
		SG1->(dbSeek(xFilial("SG1")+Wrk->D2_COD))
		ExpEstr(Wrk->D2_COD,Wrk->D2_COD)

		For nX := 1 to Len(aProd)
			If Ascan(aAux,{|x| x[1] == aProd[nX][1] .and. x[2] == aProd[nX][2]}) == 0
				cUmProd := Posicione("SB1",1,xFilial("SB1")+aProd[nX][1],"B1_UM")
				cUmReq  := Posicione("SB1",1,xFilial("SB1")+aProd[nX][2],"B1_UM")

				cTexto := Space(083)                  
				cTexto := Stuff(cTexto,001,015,PadR(aProd[nX][1],15))						//Código do PA
				cTexto := Stuff(cTexto,016,030,PadR(aProd[nX][2],15))						//Código da MP
				cTexto := Stuff(cTexto,031,047,PadR(TiraPonto(1,18,4),17))				//Quantidade PA produzida
				cTexto := Stuff(cTexto,048,064,PadR(TiraPonto(aProd[nX][3],18,4),17))//Quantidade MP requisitada
				cTexto := Stuff(cTexto,065,081,PadR(TiraPonto(aProd[nX][3],18,6),17))//Relação
				cTexto := Stuff(cTexto,082,083,PadR("IS",02))								//Tipo relação

				Grava(cTexto)
   			lCopia := .T.
   		
   			aadd(aAux,{aProd[nX][1],aProd[nX][2]})
	   	EndIf
		Next
	EndIF
	Wrk->(dbSkip())
End

Wrk->(dbCloseArea())
Grava("",.T.)

Return

/*_______________________________________________________________________________
¦ Função    ¦ ArqHlb11   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 18/06/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Geração arquivo temporátio base para montagem do arquivo final    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ExpEstr(cProduto1,cProduto2)
Local nReg, nReg2

While !SG1->(Eof()) .and. SG1->G1_COD = cProduto2
        
	If ddatabase >= SG1->G1_INI .and. ddatabase <= SG1->G1_FIM
		nReg := SG1->(Recno())
		
		SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
		If SG1->(Found())
			ExpEstr(cProduto1,SG1->G1_COD)
		EndIf
		SG1->(dbGoto(nReg))

  		Alert("Prod : "+cProduto1+" Ins : "+SG1->G1_COMP+" Passou2!!!!!!!")
  		Alert("Inic : "+dtoc(SG1->G1_INI)+" Fim : "+dtoc(SG1->G1_FIM))

  		If (nPos := Ascan(aProd,{|x| x[1] == cProduto1 .and. x[2] == SG1->G1_COMP})) == 0
  			aadd(aProd,{cProduto1,SG1->G1_COMP,SG1->G1_QUANT})
  		Else 
  			aProd[nPos][3] += SG1->G1_QUANT
  		EndIf
	EndIf	

	SG1->(dbSkip())
End

If cProduto1 == cProduto2
	SG1->(dbSeek(xFilial("SG1")+cProduto1))
	While !SG1->(Eof()) .and. SG1->G1_COD = cProduto1
		nReg2 := SG1->(Recno())
  		Alert("Prod : "+cProduto1+" Ins : "+SG1->G1_COMP)
  		Alert("Inic : "+dtoc(SG1->G1_INI)+" Fim : "+dtoc(SG1->G1_FIM))
		If ddatabase >= SG1->G1_INI .and. ddatabase <= SG1->G1_FIM
			cProduto1 := cProduto2 := SG1->G1_COMP
	  		Alert("Prod : "+cProduto1+" Ins : "+SG1->G1_COMP)
 	 		Alert("Inic : "+dtoc(SG1->G1_INI)+" Fim : "+dtoc(SG1->G1_FIM))
 			If SG1->(dbSeek(xFilial("SG1")+cProduto1))
 		  		Alert("Prod : "+cProduto1+" Ins : "+SG1->G1_COMP+" Passou!!!!!!!")
		  		Alert("Inic : "+dtoc(SG1->G1_INI)+" Fim : "+dtoc(SG1->G1_FIM))
				ExpEstr(cProduto1,cProduto2)
			EndIf
		EndIf
		SG1->(dbGoTo(nReg2))
		SG1->(dbSkip())
	End
EndIf

Return

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
	
Return Nil

/*________________________________________________________________________________
¦ Função    ¦ Grava      ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 18/06/2009   ¦
+-----------+------------+-------+--------------------------+------+--------------+
¦ Descriçäo ¦ Grava as informações coletadas em arquivo texto na pasta epecificada¦
¦           ¦ saída e estruturas.                                                 ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
*----------------------------------*
Static Function Grava(cTxt,lFecha)
*----------------------------------*
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "\Transfer price\"
cFileName := cPath +"RelProdV3.txt"
cTmpFile  := cPath +"RelProdV3.tmp"

	
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

TCQuery cQry Alias Wrk New
Return
