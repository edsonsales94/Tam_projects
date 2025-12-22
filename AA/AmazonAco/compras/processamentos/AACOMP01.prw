#Include 'Protheus.ch'
#include "rwmake.ch"

/*
Autor: RAMON MACHADO DO CARMO
Data:29/10/2015
Função: Rotina para importação de arquivo .csv de PACK LIST
Empresa: AMAZON AçO
*/
User Function AACOMP01()

	Local aSize, aPosObj
	Local oTela := nil
	Local cTitulo := "Importação de PACK LIST"
	Local nBusca := nOk := nil
	Local oMainWnd := nil

	Private cArquivo
	Private cDirArq 	:= "C:\LogPacklist\"	//GetMV("MV_YRAIZ", .T.,"C:\TOTVS")
	Private cAlias1		:= "SZZ" 			//Tabela customizada
	Private cExten		:= "*.csv"  		//extensão de arquivo a ser lido
	Private cNomeArq	:= "PACK LIST" 		//Nome do arquivo
	Private cDelimit 	:= ";"				//caracter delimitador de arquivo
	Private cDelimitL 	:= " - " 			//caracter divisor de campos do log
	Private aTab 		:= {"ZZ_FILIAL","ZZ_COD","ZZ_DOC","ZZ_SERIE","ZZ_LOTFORN",;
	"ZZ_XESPESS","ZZ_XLARG","ZZ_XPLIQ","ZZ_XPBRUTO"} //campos da tabela a ser gravada
	Private aCabec 	:= {"CODIGO","NOTA FISCAL","SERIE","LOTE","ESPESSURA","LARGURA",;
		"PESO LIQUIDO","PESO BRUTO"} 			//cabeçalho padrão
	Private aVetPD := {}					//array para validar total de item
	
	MakeDir(Trim(Upper(cDirArq)))

	
	PosObjetos(@aSize, @aPosObj)

	DEFINE MSDIALOG oTela TITLE cTitulo From 0,0 To 8,50 OF oMainWnd

	@ 05,07 SAY "Arquivo" PIXEL
	@ 15,05 MSGET cArquivo PICTURE "@!" SIZE 150, 10 OF oTela ;
		PIXEL

	nBusca := SBUTTON():New(15,160,14,{||u_AABusArq()},oTela,;
		.t.,,)

	nOk := SBUTTON():New(35,050,1,{||u_AATOK(),oTela:End()},;
		oTela,.t.,,)
	nCanc := SBUTTON():New(35,110,2,{||oTela:End()},oTela,.t.,,)

	ACTIVATE MSDIALOG oTela CENTERED 
	

Return

User Function AATOK()

	Local lRet := .t.

	If Empty(cArquivo)
		Aviso("Aviso","Arquivo a ser importado obrigatorio",{"OK"})
		lRet := .f.
	Else
		Processa({||u_AALeArq()},"Importando arquivo")
	EndIf

Return lRet

User Function AALeArq()

	Local hFile
	Local cLinha
	Local nRegua
	Local hLog
	Local cEscreve 	:= ""
	Local cBuffer 	:= ""
	Local aLinha 	:= {}
	Local aLayout 	:= {}
	Local nAt 		:= 0 // campo para delimitar primeira coluna do arquivo
	Local cString 	:= "" // string para verificar totalizador
	Local x 		:= 0 //vari‡vel para contar linhas
	Local lVld 		:= .f.
	Local lHouveErro := .F.
	Local cPatchLog := cDirArq + DtoS(dDatabase) + StrTran(Time(),":","") + ".log"

	hFile  := FT_FUSE(cArquivo)
	if hFile = -1
		Aviso("ERRO!","Erro ao abrir PACK LIST!",{"OK"})
		Return .f.
  	endif
	FT_FGOTOP()
	cLinha := FT_FREADLN()
	nRegua := FT_FLASTREC()

	ProcRegua(nRegua)
	qout(cArquivo)
	
	//cria arquivo de log na paste /log/
	hLog := FCREATE(cPatchLog)

	If hLog == -1
		MsgStop("Erro ao criar log. " + Str(FERROR(),4),'ERRO')
	EndIf

	cBuffer := FT_FREADLN()

	//aAdd(aLayout,SEPARA(cBuffer,cDelimit))
	aLayout := SEPARA(cBuffer,cDelimit)

	For y := 1 to Len(aCabec)
		If AllTrim(aLayout[y]) == aCabec[y]
			lVld := .t.
		Else
			lVld := .f.
			Aviso("ERRO!","Arquivo nao confere com o layout necessario.",{"FECHAR"})
			EXIT
		EndIf
	Next y

	FT_FSKIP() //Pula linha do cabeçalho
	
	While !(FT_FEOF()) .AND. lVld
		
		IncProc()
		
		cEscreve := DtoC(Date()) + cDelimitL + Time() + " = "

		cBuffer  := FT_FREADLN()

		nAt 	:= AT(cDelimit,cBuffer)
		cString := substr(cBuffer,1,nAt)

		x++

		//adiciona linha a um array para gravar na tabela
			AADD(aLinha,SEPARA(cBuffer,cDelimit))

			If !(Empty(aLinha[x,4]))

			cEscreve += StrTran(cBuffer,cDelimit,cDelimitL)

			If execVld(aLinha,x)
				If (itemVld(aLinha, x))
					If vldQntd(aLinha, x)
						//se ok, salva linha na tabela
						dbSelectArea(cAlias1)
						Reclock(cAlias1,.t.)
						SZZ->ZZ_FILIAL := xFilial(cAlias1)

						For w := 2 to Len(aTab)
							If ValType(CriaVar(aTab[w])) == "N"
								If Trim(aTab[w]) = "ZZ_XPLIQ"
									FieldPut(FieldPos(Trim(aTab[w])),Val(strtran(aLinha[x,w - 1],",",".")) * 1000)
								Else
									FieldPut(FieldPos(Trim(aTab[w])),Val(strtran(aLinha[x,w - 1],",",".")))
								EndIf	
							Else
								FieldPut(FieldPos(Trim(aTab[w])),aLinha[x,w - 1])
							EndIf
						Next w

						cEscreve +=  " Cadastrado com sucesso."
						
						FWRITE(hLog,cEscreve + CHR(13) + CHR(10))
						MsUnlock()
					Else
						cEscreve += " Erro! - Este Item já atingiu a quantidade referente a nota fiscal."
						
						//Escreve erros no Log
						FWRITE(hLog,cEscreve + CHR(13) + CHR(10))
						
						lHouveErro := .T.
							
					EndIf

				Else
					cEscreve += " ERRO! - Item ja cadastrado no sistema."

					//Escreve erros no Log
					FWRITE(hLog,cEscreve + CHR(13) + CHR(10))
					lHouveErro := .T.
				EndIf
			Else
				cEscreve += " ERRO! - Houve algum erro nesta linha, verificar se o item existe na base de dados, verificar se a nota foi dada entrada."

				//Escreve erros no Log
				FWRITE(hLog,cEscreve + CHR(13) + CHR(10))
				lHouveErro := .T.
			EndIf

			//Escreve dados no Log
			//FWRITE(hLog,cEscreve + CHR(13) + CHR(10))

			EndIf

			FT_FSKIP()

	EndDo

	FT_FUSE(cArquivo) 	//fecha arquivo
	FCLOSE(hLog)        //fecha log
	
	If lHouveErro
		If MsgBox("Houve erro na importação, deseja visualizar o arquivo de log?","Atenção","YESNO")
			WinExec("Explorer.exe" + Space(1) + cPatchLog )
		EndIf	
	Else
		Aviso("Finalizado","Importação finalizada",{"Ok"})
	EndIf
	


Return

//Validação para pesquisar se o item está dentro das validações
Static Function execVld(aLinha,x)

	Local lRet := .f.
	Local cQuery := "SELECT * FROM " + RetSQLTab("SF1") + " INNER JOIN " + RetSQLTab("SD1")
	cQuery += " 	ON SD1.D_E_L_E_T_='' AND SD1.D1_FILIAL=SF1.F1_FILIAL"
	cQuery += " AND SD1.D1_DOC=SF1.F1_DOC AND SD1.D1_SERIE=SF1.F1_SERIE"
	cQuery += " AND SD1.D1_EMISSAO=SF1.F1_EMISSAO "
	cQuery += " INNER JOIN " + RetSQLTab("SB1") + " ON "
	cQuery += " SB1.D_E_L_E_T_='' AND SB1.B1_COD=SD1.D1_COD"
	cQuery += " WHERE SF1.F1_DOC='" + aLinha[x,2] + "' "
	cQuery += " AND SF1.F1_SERIE='" + aLinha[x,3] + "' "
	cQuery += " AND SB1.B1_COD='" + aLinha[x,1] + "' "


	If Select("TMPQRY") != 0
		dbSelectArea("TMPQRY")
		dbclosearea()
	EndIf

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPQRY",.T.,.T.)

	If TMPQRY->(BOF())
		Return .F.
	EndIf 

	If TMPQRY->(!(eof()))
		lRet := .t.
	EndIf

Return lRet

//Validação para verificar se o item já foi cadastrado
Static Function itemVld(aLinha,x)

	Local lRet := .t.
	(cAlias1)->(dbsetorder(1))
	If (cAlias1)->(Dbseek(xFilial(cAlias1) + PADR(aLinha[x,1],TamSx3("ZZ_COD") [1])+ PADR(aLinha[x,2],TamSx3("ZZ_DOC") [1]) + PADR(aLinha[x,3],TamSx3("ZZ_SERIE") [1]) + PADR(aLinha[x,4],TamSx3("ZZ_LOTFORN") [1])))
		lRet := .f.
	EndIf

Return lRet

Static Function vldQntd(aLinha,x)
	
	Local lRet 		:= .t.
	Local cSelect 	:= ""
	Local nPeso		:= 0
	Local nPos		:= 0
	Local z			:= 0
	
	cSelect := "SELECT sum(SD1.D1_QUANT) D1_QUANT FROM " + RetSQLTab("SD1") + " WHERE "
	cSelect += " SD1.D_E_L_E_T_='' "
	cSelect += " AND SD1.D1_DOC='" + aLinha[x,2] + "' "
	cSelect += " AND SD1.D1_SERIE='" + aLinha[x,3] + "' "
	cSelect += " AND SD1.D1_COD='" + aLinha[x,1] + "'"
	
	If Select("QNTDTOT") != 0
		dbSelectArea("QNTDTOT")
		dbclosearea()
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cSelect)),"QNTDTOT",.T.,.T.)

	If x == 1 .OR. EMPTY(aVetPD)   
		Peso := Val(strtran(aLinha[x,7],",",".")) * 1000
			
		If nPeso > QNTDTOT->D1_QUANT
			lRet := .f.
		EndIf
		aAdd(aVetPD,{aLinha[x,1],aLinha[x,7]})
		z := x
	ElseIf x > 1
		
		If aVetPD[Len(aVetPD),1] == aLinha[x,1]
			//z++
			aAdd(aVetPD,{aLinha[x,1],aLinha[x,7]})
			For y := 1 To Len(aVetPD)
				nPeso += Val(strtran(aVetPD[y,2],",",".")) * 1000
			Next y
			If nPeso > QNTDTOT->D1_QUANT
				lRet := .f.
			EndIf
		Else
			nPeso := Val(strtran(aLinha[x,7],",",".")) * 1000
			
			If nPeso > QNTDTOT->D1_QUANT
				lRet := .f.
			EndIf
			aVetPD := {}	
			aAdd(aVetPD,{aLinha[x,1],aLinha[x,7]})
			//z := 1
		EndIf
		
	EndIf

	/*nPos := AScan(aVetPD,{|y| y[1] == aLinha[x,1]})

	If nPos > 0
			If Val(strtran(aVetPD[nPos,2],",",".")) > QNTDTOT->D1_QUANT
				lRet := .f.
				Return lRet
			EndIf
		aVetPD[AScan(aVetPD,{|y| y[1] == aLinha[x,1]}),2] += aLinha[x,8]
	Else
		AaDD(aVetPD,{aLinha[x,1],aLinha[x,8]})
	EndIf*/

Return lRet

//busca o arquivo
User Function AABusArq()
	Local nOpcoes:= nOr(GETF_LOCALHARD, GETF_LOCALFLOPPY,GETF_NETWORKDRIVE )

	//oDir := AllTrim(cGetFile( cExten,cNomeArq, 0, cDirArq, .F., /*nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY )*/,.F.))
	oDir:= cGetFile(cExten,cNomeArq,0, cDirArq, .F., nOpcoes, .F.)
	cArquivo := oDir

Return

Static Function PosObjetos(aSize,aPosObj)

	Local aInfo
	Local aObjects := {}

	aSize := MsAdvSize()
	aAdd(aObjects,{100,060,.t.,.f.})
	aAdd(aObjects,{100,100,.t.,.t.})

	aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo,aObjects)

Return
