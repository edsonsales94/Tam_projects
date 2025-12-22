#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "Fileio.ch"

Static nPercMax := 5
Static aVldLin  := {}
Static cEndRec  := Alltrim(GETMV("MV_XENDREC"))   //Endereï¿½o automatico do Rrecebimento 
/*__________________________________________________________________
############################################################################################################
#######+-----------+----------------------+-------------+---------------+#######
#######½ Programa  |  AAESTA01   Autor ï¿½ ADRIANO LIMA | Data | 01/03/12 #######
#######+-----------+----------------------+-------------+---------------+#######
#######  Descriï¿½ï¿½o | Tela de Cadastro de Puxadas (Modelo 3)     	#######
#######-----------+----------------------+-------------+----------------+
Alterações
// Implementado por Wladimir 29/05/2019
// Verifica se tem controle de Corrida, caso sim envia para amazem de Qualidade / endereÃ§o CQ
############################################################################################################*/
User Function AAESTA01()
Local nLIni := If( GetRpoRelease("R5") , 5, 15)  // Indica se o release e 11.5

Private cCadastro := "Cadastro de Puxadas"
Private aRotina   := { 	{"Pesquisar"  ,"AxPesqui"   ,0,1} ,;
{"Visualizar" ,"U_fCadPux"  ,0,2} ,;
{"Incluir"    ,"U_fCadPux"  ,0,3} ,;
{"Alterar"    ,"U_fCadPux"  ,0,4} ,;
{"Excluir"    ,"U_fCadPux"  ,0,5} ,;
{"Residuo"    ,"U_fCadRes"  ,0,6} }

/*,;
{"Reprocessa"    ,"U_fReprD3"  ,0,7}*/

Private aPos    := { nLIni, 2, nLIni+75, 605}
Private cAlias1 := "SZX"
Private cAlias2 := "SZY"

dbSelectArea(cAlias1)
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias1)

Return

User Function fCadPux(cAlias,nRecno,nOpc)
Local nX
Local nOpcA     := 0
Local nUsado    := 0
Local aAltera   := {}
Local nMaxItens := 999
Local cFuncDel  := "AllwaysTrue"

Private oDlg    := Nil
Private oGet    := Nil
Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }
Private Inclui  := (nOpc == 3)
Private Altera  := (nOpc == 4)
Private nPD     := 1
Private aSize 	 := {}
Private aPosObj  := {}

Private _cArmTran := AllTrim( GetMv("MV_XARMTRA") )

nPercMax := GetMV("MV_XPERVAR",.F.,5)   // Percentual mï¿½ximo de variaï¿½ï¿½o de sobra e falta das puxadas

aVldLin := {}   // Inicializa validaï¿½ï¿½es

If nOpc <> 2
	SF5->(dbSetOrder(1))
	If !SF5->(dbSeek(XFILIAL("SF5")+GetMv("MV_XTMREQU")))  // Tipo de movimentaï¿½ï¿½o de saï¿½da
		Alert("O Tipo de movimentaï¿½ï¿½o de saï¿½da ("+GetMv("MV_XTMREQU")+") nï¿½o existe !")
		Return
	Endif
	SF5->(dbSetOrder(1))
	If !SF5->(dbSeek(XFILIAL("SF5")+GetMv("MV_XTMDEVO")))  // Tipo de movimentaï¿½ï¿½o de entrada
		Alert("O Tipo de movimentaï¿½ï¿½o de entrada ("+GetMv("MV_XTMDEVO")+") nï¿½o existe !")
		Return
	Endif
Endif

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	If nOpc == 3
		M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
	Else
		M->&(Eval(bCampo,nX)) := FieldGet(nX)
	Endif
Next nX

// Cria aHeader e aCols da GetDados 

SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias2,.T.))
While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias2
	If Alltrim(SX3->X3_CAMPO) <> "ZY_CODIGO" .And. X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		nUsado++
		AAdd( aHeader , { TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
		SX3->X3_TAMANHO, SX3->X3_DECIMAL, IIf(Alltrim(SX3->X3_CAMPO)=="ZY_LOTEFOR","u_Preenche()","AllwaysTrue()"), SX3->X3_USADO,;
		SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT} )
	Endif
	SX3->(dbSkip())
Enddo

If nOpc == 3 // Incluir
	AAdd( aCols , Array(nUsado+1) )
	aCols[1,nUsado+1]:=.F.
	For nX:=1 to nUsado
		aCols[1,nX] := CriaVar(aHeader[nX,2])
	Next
Else
	SZY->(dbSetOrder(1))
	SZY->(dbSeek(SZX->(ZX_FILIAL+ZX_CODIGO),.T.))
	While !SZY->(Eof()) .And. SZX->(ZX_FILIAL+ZX_CODIGO) == SZY->(ZY_FILIAL+ZY_CODIGO)
		
		AADD( aCols , Array(nUsado+1) )
		For nX:=1 to nUsado
			aCols[Len(aCols),nX] := SZY->(FieldGet(FieldPos(aHeader[nX,2])))
		Next
		aCols[Len(aCols),nUsado+1] := .F.
		
		AAdd( aAltera , SZY->(Recno()) )   // Armazena o registro a ser alterado
		
		SZY->(dbSkip())
	Enddo
	nMaxItens := Len(aCols)
	cFuncDel  := "AllwaysFalse"
Endif

PosObjetos(@aSize,@aPosObj)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oPanelAll:= tPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,,aPosObj[1,3],aPosObj[1,4])
	  oPanelAll:align:= CONTROL_ALIGN_ALLCLIENT
	  
EnChoice(cAlias, nRecNo, nOpc,,,,,aPosObj[1],, 3,,,,oDlg)

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_fConSaldo(.T.)",,,.T.,/*aAlter*/,,,nMaxItens,,,,cFuncDel,oDlg)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := If( Obrigatorio(aGets,aTela).And.u_fConSaldo(.F.),1,0),If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} )

If nOpcA == 1
	BeginTran() 
		If !fGravaPux(nOpc,aAltera)
			nOpcA := 0
		Endif                      
	EndTran()
	MsUnlockAll()		
Endif

If nOpc == 3  // Se for inclusï¿½o
	If nOpcA == 1
		ConfirmSX8()   // Confirma numeraï¿½ï¿½o automï¿½tica
	Else
		RollBAckSx8()  // Libera numeraï¿½ï¿½o automï¿½tica
	Endif
Endif
dbSelectArea(cAlias)

Return

Static Function fGravaPux(nOpc,aAltera)
Local nX, nY, x, nDel
Local vDel := {}
Local cAlias := Alias()
Local lCont := .T.

// .-----------------------------
//| Se for inclusï¿½o ou alteraï¿½ï¿½o
// '-----------------------------
If nOpc == 3 .Or. nOpc == 4
	
	// .----------------------------------------------------
	//|     Grava as movimentaï¿½ï¿½es internas de transferï¿½ncia (na inclusï¿½o)
	// '----------------------------------------------------
	If nOpc == 3 .And. pGeraD3(nOpc) //Realiza transferencia para o armazem (03-Materia Prima)  
		lCont := .F.
		DisarmTransaction()
		Return .F.
	Endif
	
	// Posiciona na tabela de preï¿½os do motorista
	SZV->(dbSetOrder(1))
	SZV->(dbSeek(XFILIAL("SZV")+M->ZX_CODMOT+M->ZX_TIPOV+M->ZX_LOCENT))
	
	// Grava os dados do cabeï¿½alho da puxada
	dbSelectArea(cAlias1)
	RecLock(cAlias1, Inclui)
	For nX := 1 To fCount()
		If "FILIAL" $ FieldName(nX)
			FieldPut(nX,SZX->(xFilial("SZX")))
		Else
			FieldPut(nX,M->&(Eval(bCampo,nX)))
		Endif
	Next nX
	
	SZX->ZX_VALOR := SZV->ZV_VALOR   // Grava o preï¿½o conforme tabela
	MsUnLock()
	
	nDel := Len(aHeader) + 1
	
	dbSelectArea(cAlias2)
	dbSetOrder(1)
Endif

//.-------------------
//|    Se for inclusï¿½o
// '-------------------
If lCont

	If nOpc == 3
		SB1->(DbSetOrder(1)) //Posiciona no produto pra gerar a etiqueta
		// .----------------------------------------------------
		//|     Grava os dados referente aos cabeï¿½alho de corte
		// '----------------------------------------------------
		For nX := 1 To Len(aCols)
			If !aCols[nX][nDel]  // Ignora os registros deletados
				RecLock(cAlias2,.T.)
				For nY := 1 To Len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[nY,2])),aCols[nX,nY])
				Next nY
				
				SZY->ZY_FILIAL	:= xFilial("SZY")
				SZY->ZY_CODIGO	:= M->ZX_CODIGO
				MsUnLock()
				// Atualiza quantidade em transito apos tranferencia.
				SZW->(dbSetOrder(1))
				If SZW->(dbSeek(xFilial("SZW")+SZY->(ZY_PACLIS+ZY_DOC+ZY_SERIE+ZY_FORNECE+ZY_LOJA+ZY_ITEM)))
					RecLock("SZW",.F.)
					SZW->ZW_SALDO -= SZY->ZY_QUANT
					MsUnLock()
				Endif
			Endif         
			//CBChkTemplate()
				
			If !CB5SetImp(Alltrim(GetMv("MV_IACD02")),IsTelNet()) //MV_IACD02
				Alert("Codigo do local de impressao invalido!")   //'Codigo do tipo de impressao invalido'
				Return .f.
			EndIF
	        SB1->(DbSeek(xFilial("SB1")+SZY->ZY_CODPRO))
			//Alteração Arlindo dia 21/06/2019
			iF SuperGetMv("MV_XCORRI",.F.,.F.) .and. SB1->B1_XCTLCOR=="S"
				cEndRec := "CQ"
			EndIf
			ExecBlock('IMG01',,,{SZY->ZY_QUANT,,,3,SZY->ZY_DOC,SZY->ZY_SERIE,SZY->ZY_FORNECE,SZY->ZY_LOJA,SZY->ZY_LOCAL,,,SZY->ZY_LOTEFOR,,,,,,,,cEndRec,})
		Next nX		
	EndIf       
EndIf

//  .--------------------
// Se For Exclusï¿½o
//  .--------------------
If nOpc == 5

	If pGeraD3(nOpc) //Realiza transferencia para o armazem (03-Materia Prima)
		lCont := .F.
		DisarmTransaction()
		Return .F.
	Endif
	If lCont	
		RecLock("SZX",.F.)
		dbDelete()
		MsUnLock()
		
		For nX := 1 To Len(aCols)
			
			SZY->(dbGoTo(aAltera[nX]))  // Posiciona no registro
			
			// Atualiza quantidade em transito apos tranferencia.
			SZW->(dbSetOrder(1))
			If SZW->(dbSeek(xFilial("SZW")+SZY->(ZY_PACLIS+ZY_DOC+ZY_SERIE+ZY_FORNECE+ZY_LOJA+ZY_ITEM)))
				RecLock("SZW",.F.)
				SZW->ZW_SALDO += SZY->ZY_QUANT
				MsUnLock()
			Endif
			
			RecLock("SZY",.F.)
			dbDelete()
			MsUnLock()
			
				 
			RecLock("SZZ",.T.)
			SZZ->ZZ_FILIAL		:= SZY->ZY_FILIAL
			SZZ->ZZ_COD			:= SZY->ZY_CODPRO
			SZZ->ZZ_DOC			:= SZY->ZY_DOC
			SZZ->ZZ_SERIE		:= SZY->ZY_SERIE
			SZZ->ZZ_LOTFORN		:= SZY->ZY_LOTEFOR
			SZZ->ZZ_XLARG		:= Posicione("SB1",1,xFilial("SB1")+SZY->ZY_CODPRO,"B1_XLARG")
			SZZ->ZZ_XESPESS		:= SB1->B1_XESPESS
			SZZ->ZZ_XPLIQ		:= SZY->ZY_QUANT
			SZZ->ZZ_XPBRUTO		:= SZY->ZY_QUANT
			MsUnlock()
	
		Next	
	EndIf
	dbSelectArea(cAlias)
EndIf

Return .T.

Static Function AddValid(lValor)

// Adiciona os itens nï¿½o adicionados
While Len(aVldLin) < n
	AAdd( aVldLin , .F. )
Enddo

If lValor <> Nil
	AFill( aVldLin , lValor )   // Atualiza o valor
Endif
Return

//Consulta Saldo em Transito.
User Function fConSaldo(lValidLin)
Local nX, nY, cChave, nSaldo, nTotPac
Local nPIni := 1
Local nPFim := Len(aCols)
Local nPPac := AScan( aHeader , {|x| Trim(x[2]) == "ZY_PACLIS"  })
Local nPDoc := AScan( aHeader , {|x| Trim(x[2]) == "ZY_DOC"     })
Local nPSer := AScan( aHeader , {|x| Trim(x[2]) == "ZY_SERIE"   })
Local nPFor := AScan( aHeader , {|x| Trim(x[2]) == "ZY_FORNECE" })
Local nPLoj := AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOJA"    })
Local nPIte := AScan( aHeader , {|x| Trim(x[2]) == "ZY_ITEM"    })
Local nPPrd := AScan( aHeader , {|x| Trim(x[2]) == "ZY_CODPRO"  })
Local nPQtd := AScan( aHeader , {|x| Trim(x[2]) == "ZY_QUANT"   })
Local nPDel := Len(aCols[1])
Local lRet  := .T.
Local _cArmMat := AllTrim( GetMv("MV_XARMMAT") )

AddValid()   // Adiciona a valida ï¿½ validaï¿½ï¿½o

If lValidLin   // Se tiver validando linha
	nPIni := n
	nPFim := n
	
	If aCols[n,nPDel]  // Se linha estiver deletada
		Return lRet
	Endif
ElseIf AScan( aVldLin , .T. ) > 0  // Se ja validou
	Return lRet
Endif

SB2->(dbSetOrder(1))
SZW->(dbSetOrder(1))

For nX:=nPIni To nPFim
	
	If aCols[nX,nPDel]  // Se linha estiver deletada
		Loop
	Endif
	
	// Verifica se tem saldo suficiente em estoque para o produto
	If lRet := SB2->(dbSeek(XFILIAL("SB2")+aCols[nX,nPPrd]+Iif(Inclui .Or. Altera,_cArmTran,_cArmMat)))
		cChave := aCols[nX,nPPac]+aCols[nX,nPDoc]+aCols[nX,nPSer]+aCols[nX,nPFor]+aCols[nX,nPLoj]+aCols[nX,nPIte]
		
		If lRet := SZW->(dbSeek(XFILIAL("SZW")+cChave))   // Posiciona no pack-list
			nSaldo := SB2->(B2_QATU - If( B2_RESERVA > 0 , B2_RESERVA,0))  // Cï¿½lculo do salto atual
			If lRet := (SZW->ZW_SALDO > 0 .Or. nSaldo > 0)
			   SZY->(DbSetOrder(1))
			   SZY->(DbSeek(xFilial("SZY")+SZW->ZW_PACLIS+SZW->ZW_DOC+SZW->ZW_SERIE+SZW->ZW_FORNECE+SZW->ZW_LOJA+SZW->ZW_ITEM))                  
				
				If lRet := (SZY->ZY_QUANT <= nSaldo)
					/*
					// Soma os itens jï¿½ informados para o pack-list
				  	nTotPac := 0
					aEval( aCols , {|nY| nTotPac += If( nY[nPDel] .Or. cChave <> nY[nPPac]+nY[nPDoc]+nY[nPSer]+nY[nPFor]+nY[nPLoj]+nY[nPIte] , 0, nY[nPQtd]) })
					
					If !aVldLin[n] .And. !(lRet := Iif(Inclui .Or. Altera,(nTotPac <= SZW->ZW_SALDO),.T.))
						// Caso a quantidade seja maior que o saldo
						If Round(((nTotPac - SZW->ZW_SALDO)/SZW->ZW_QTDORI)*100,0) <= nPercMax
							If lRet := MsgYesNo("Existem itens com puxadas maiores que o saldo, confirma ?")
								lRet := (AScan( aVldLin , .T. ) > 0) .Or. LiberaSenha()
								aVldLin[n] := lRet   // Atualiza a linha
							Endif
							Exit
  						Endif
					Endif */
					
					If !lRet
						Alert("O saldo em trï¿½nsito nï¿½o ï¿½ suficiente para a puxada do produto "+Trim(aCols[nX,nPPrd])+" !")
					EndIf
				Else
					Alert("Ocorreu uma inconsistï¿½ncia nos saldos: O saldo do Pack-List estï¿½ maior que o saldo em estoque do trï¿½nsito !")
				Endif
			Else
				Alert("O saldo em trï¿½nsito estï¿½ zerado ou negativo !")
			Endif
		Else
			Alert("O Pack-List informado nï¿½o foi encontrado !")
		Endif
	Else
		Alert("Nï¿½o existe referï¿½ncia para esse produto no saldo em estoque !")
	Endif
Next

Return lRet

//Realiza a inclusï¿½o de uma Requisicao(RE6) e uma Devolucao(DE6) - (Movimento Interno).
Static Function pGeraD3(nOpTran)
Local _cTM, aAuto, aItem,nCusto, nQuant, cChave
Local _cArea   := GetArea()
Local _cAlm    := ""
Local _cArmMat := AllTrim( GetMv("MV_XARMMAT") )
Local nPosPac  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_PACLIS" })  // Posiï¿½ï¿½o do Pack-List
Local nPosDoc  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_DOC"    })  // Posiï¿½ï¿½o do documento
Local nPosSer  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_SERIE"  })  // Posiï¿½ï¿½o da sï¿½rie
Local nPosFor  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_FORNECE"})  // Posiï¿½ï¿½o do fornecedor
Local nPosLoj  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOJA"   })  // Posiï¿½ï¿½o da loja
Local nPosPrd  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_CODPRO" })  // Posiï¿½ï¿½o do produto
Local nPosIte  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_ITEM"   })  // Posiï¿½ï¿½o do item
Local nPosQtd  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_QUANT"  })  // Posiï¿½ï¿½o da quantidade
Local nPosAlm  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOCAL"  })  // Posiï¿½ï¿½o do almoxarifado         
Local nPosLot  := AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOTEFOR"})  // Posiï¿½ï¿½o do lote do fornecedor
Local cFilSD1  := SD1->(XFILIAL("SD1"))
Local aDocSeq  := {}
Local nPDel    := Len(aCols[1])                 
Local _cLocEnd := Substr(Alltrim(GETMV("MV_DISTAUT")),3)   //Endereï¿½o automatico do armazï¿½m 'TR'
Local cCodPro
Local cCodSep
Local cCodID
Local cNFEnt
Local cSeriee
Local cFornec
Local cLojafo
Local cArmazem
Local cOP
Local cNumSeq
Local cLote
Local cSLote
Local dValid
Local cCC
Local cLocOri
Local nX

Local aAuto 		:= {}
Local aItem			:= {} 
Local cPuxada := PADL(M->ZX_CODIGO,TamSX3("D3_DOC")[1]-1,"0")+"T"

SB1->(DbSetOrder(1))
SD1->(dbSetOrder(1))

lMsErroAuto := .F.



For nX := 1 To Len(aCols)
    
    If nX > 1
    	cPuxada:=Soma1(cPuxada)
    EndIf

	If aCols[nX][nPDel]  // Ignora os registros deletados
		Loop
	Endif
	
	//Pesquisa a descricao do produto
	SB1->(DbSeek(xFilial("SB1") + aCols[nX,nPosPrd]))	
	
	If nOpTran == 3 // Se for inclusï¿½o
	
		aAuto 		:= {}
		AAdd(aAuto,{cPuxada,dDataBase}) //Adiciona o cabeï¿½alho da rotina automï¿½tica
		
		aItem	:= {}
		cNumSeq := ProxNum()

		// Posiciona no item da nota de entrada
		SD1->(dbSeek(cFilSD1+aCols[nX,nPosDoc]+aCols[nX,nPosSer]+aCols[nX,nPosFor]+aCols[nX,nPosLoj]+aCols[nX,nPosPrd]+aCols[nX,nPosIte]))	

		// Calcula a quantidade do movimento
		nQuant := aCols[nX,nPosQtd]

		cChave := aCols[nX,nPosPac]+aCols[nX,nPosDoc]+aCols[nX,nPosSer]+aCols[nX,nPosFor]+aCols[nX,nPosLoj]+aCols[nX,nPosIte]
	   /*	// Posiciona no pack-list
		If SZW->(dbSeek(XFILIAL("SZW")+cChave))
			// Se quantidade for maior que o saldo, entï¿½o estï¿½ sendo retirado resï¿½duos ï¿½ maior
			If nQuant > SZW->ZW_SALDO
				nQuant := SZW->ZW_SALDO
			Endif
		Endif*/	
		
		
		//Itens da rotina de transferencia MATA261			
		//Origem
		aadd(aItem,SB1->B1_COD)  	//D3_COD
		aadd(aItem,SB1->B1_DESC)    //D3_DESCRI
		aadd(aItem,SB1->B1_UM)  	//D3_UM
		aadd(aItem,_cArmTran)   	//D3_LOCAL
		aadd(aItem,_cLocEnd)		//D3_LOCALIZ

		//Destino
		aadd(aItem,SB1->B1_COD)  	//D3_COD
		aadd(aItem,SB1->B1_DESC)    //D3_DESCRI
		aadd(aItem,SB1->B1_UM)  	//D3_UM

		// Implementado por Wladimir 29/05/2019
		// Verifica se tem controle de Corrida, caso sim envia para amazem de Qualidade / endereÃ§o CQ
		iF SuperGetMv("MV_XCORRI",.F.,.F.) .and. SB1->B1_XCTLCOR == "S"
		   aadd(aItem,"06")   		//Arm 16
		   aadd(aItem,"CQ")		   //CQ
		Else
		   aadd(aItem,_cArmMat)   		//D3_LOCAL
		   aadd(aItem,_cLocEnd)		    //D3_LOCALIZ
		Endif
		
		aadd(aItem,"")         		//D3_NUMSERI
		aadd(aItem,SD1->D1_LOTECTL)	//D3_LOTECTL
		aadd(aItem,"")         		//D3_NUMLOTE
		aadd(aItem,SD1->D1_DTVALID)	//D3_DTVALID
		aadd(aItem,0)				//D3_POTENCI
		aadd(aItem,nQuant) 				//D3_QUANT
		aadd(aItem,ConvUm(SB1->B1_COD,nQuant,0,2))				//D3_QTSEGUM
		aadd(aItem,"")   			//D3_ESTORNO
		aadd(aItem,cNumSeq)     		//D3_NUMSEQ
		aadd(aItem,aCols[nX,nPosLot])//D3_LOTECTL
		aadd(aItem,SD1->D1_DTVALID)	//D3_DTVALID
		aadd(aItem,"")				//D3_ITEMGRD
		aadd(aItem,"")				//D3_OBSERVA

		aadd(aAuto,aItem)	
		
		MSExecAuto({|x,y| mata261(x,y)},aAuto,3)

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Exit
		else
			SZZ->(DbSetOrder(2))
			If SZZ->(DbSeek(xFilial("SZZ")+Alltrim(aCols[nX,nPosLot])))
				RecLock("SZZ",.F.)
					SZZ->(dbDelete())
				MsUnlock()
			EndIf 
		EndIf
	Else
		// Pesquisa a movimentaï¿½ï¿½o interna para estorno
		lFound := .F.
		SD3->(dbSetOrder(2))
		SD3->(dbSeek(XFILIAL("SD3")+cPuxada+SB1->B1_COD,.T.))
		While !SD3->(Eof()) .And. XFILIAL("SD3")+cPuxada+SB1->B1_COD == SD3->(D3_FILIAL+D3_DOC+D3_COD)
			// Valida campos adicionais se sï¿½o os mesmos da puxada
			If SD3->D3_EMISSAO == M->ZX_DATA .And. SD3->D3_LOCAL == _cArmMat
				lFound := .T.
				Exit
			Endif
			SD3->(dbSkip())
		Enddo	
		
		If lFound
			aAuto := {}	
			MSExecAuto({|x,y| mata261(x,y)},aAuto,6)

			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
				Exit
			Else
				cNota 	:= aCols[nX,nPosDoc]
				cSerie 	:= aCols[nX,nPosSer]
				cFornec	:= aCols[nX,nPosFor]
				cLoja	:= aCols[nX,nPosLoj]
				cLoteFor:= aCols[nX,nPosLot]
				
				//Exclui a etiqueta gerada
				EstorEtiq(cNota,cSerie,cFornec,cLoja,cLoteFor)
			EndIf	
		Else
			lMsErroAuto := .T.
			DisarmTransaction()
			Exit		
		EndIf	
		
	EndIf
Next nX

RestArea( _cArea)

Return lMsErroAuto


/*___________________________________________________________________________
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+--------------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Funï¿½ï¿½o    ï¿½ fCadRes    ï¿½ Ronilton O. Baros        ï¿½ Data ï¿½ 13/03/2012 ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+--------------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Descriï¿½ï¿½o ï¿½ Eliminaï¿½ï¿½o de resï¿½duo                                     ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+-----------------------------------------------------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function fCadRes()
Local cQry, oDlg, oLbx, lOk
Local cAlias := Alias()
Local aItems := {}
Local nPerc  := 5
Local oOk    := LoadBitmap(GetResources(), "LBOK" )
Local oNo    := LoadBitmap(GetResources(), "LBNO" )
Local lCheck := .T.
Local nOpcA  := 0
Private aSize 	 := {}
Private aPosObj  := {}

SZW->(dbSetOrder(1))

cQry := "SELECT SZW.R_E_C_N_O_ AS ZW_RECNO, SA2.A2_NOME, SF1.F1_DTDIGIT, SZW.*"
cQry += " FROM "+RetSQLName("SZW")+" SZW"
cQry += " INNER JOIN "+RetSQLName("SF1")+" SF1 ON SF1.D_E_L_E_T_ = ' '"
cQry += " AND SF1.F1_FILIAL = SZW.ZW_FILIAL"
cQry += " AND SF1.F1_DOC = SZW.ZW_DOC AND SF1.F1_SERIE = SZW.ZW_SERIE"
cQry += " AND SF1.F1_FORNECE = SZW.ZW_FORNECE AND SF1.F1_LOJA = SZW.ZW_LOJA"
cQry += " INNER JOIN "+RetSQLName("SA2")+" SA2 ON SA2.D_E_L_E_T_ = ' '"
cQry += " AND SA2.A2_COD = SZW.ZW_FORNECE AND SA2.A2_LOJA = SZW.ZW_LOJA"
cQry += " WHERE SZW.D_E_L_E_T_ = ' '"
cQry += " AND SZW.ZW_SALDO <> 0"
cQry += " AND SZW.ZW_SALDO <> SZW.ZW_QTDORI"
cQry += " ORDER BY " + SqlOrder(SZW->(IndexKey()))

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "TMPSZW", .F., .T.)
While !EOF()
	
	// Se foi ultrapassada a quantidade total ou o saldo for menor ou igual a 5%
	If ZW_SALDO < 0 .Or. Round((ZW_SALDO/ZW_QTDORI)*100,0) <= nPercMax
		aAdd( aItems , { lCheck, ZW_PACLIS, ZW_DOC, ZW_SERIE, ZW_QTDORI, ZW_SALDO, ZW_CODPRO, ZW_LOJA, A2_NOME, ZW_NUMDI, ZW_FILIAL,;
		ZW_RECNO, Stod(F1_DTDIGIT)})
	Endif
	
	dbSkip()
EndDo
dbCloseArea()
dbSelectArea(cAlias)

If Empty(aItems)
	Alert("Nï¿½o existem resï¿½duos a eliminar !")
	Return
Endif
PosObjetos(@aSize,@aPosObj)
DEFINE MSDIALOG oDlg TITLE "Eliminar resï¿½duos de puxadas"  From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd

oPanelAll:= tPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,,aPosObj[1,3],aPosObj[1,4])
oPanelAll:align:= CONTROL_ALIGN_ALLCLIENT
	
@ 010,010 LISTBOX oLbx VAR cVar ; //14,01
FIELDS HEADER " ","Filial","Num PacList","Num NF","Serie NF","Emissï¿½o","Quant NF", "Saldo Transito","Cod. Produto","Loja",;
"Fornecedor", "DI";
SIZE 475, 250 OF oDlg PIXEL ON dblClick( aItems[oLbx:nAt,01] := !aItems[oLbx:nAt,01] )

@ 263,010 CHECKBOX oCbx VAR lCheck PROMPT "Marcar / Desmarcar" SIZE 65,15 OF oDlg PIXEL ON CLICK Marcacao(lCheck,@aItems,@oLbx)

oLbx:SetArray(aItems)
oLbx:bLine := {||{IIF(aItems[oLbx:nAt,01],oOk,oNo),;
aItems[oLbx:nAt,11],;
aItems[oLbx:nAt,02],;
aItems[oLbx:nAt,03],;
aItems[oLbx:nAt,04],;
aItems[oLbx:nAt,13],;
Transform(aItems[oLbx:nAt,05],'@E 99,999,999,999'),;
Transform(aItems[oLbx:nAt,06],'@E 999,999,999'),;
aItems[oLbx:nAt,07],;
aItems[oLbx:nAt,08],;
aItems[oLbx:nAt,09],;
aItems[oLbx:nAt,10]}}

ACTIVATE MSDIALOG oDlg 	CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,oDlg:End()} , {|| oDlg:End() })

If nOpcA == 1
	MsgRun("Ajustando saldos..." ,,{|| Movimenta(aItems) })   // Processa os ajustes de saldos
Endif
Return

/*_______________________________________________________________________________
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+-------+----------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Funï¿½ï¿½o    ï¿½ Movimenta  ï¿½ Autor ï¿½ Ronilton O. Barros   ï¿½ Data ï¿½ 04/06/2012 ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+-------+----------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Descriï¿½ï¿½o ï¿½ Cria movimento interno para ajuste de saldo das puxadas       ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+---------------------------------------------------------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function Movimenta(aItems)
Local aVetor, cTMMov, nX, nCusto
Local cDocum  := ""
Local cFilAux := cFilAnt

Private lMsHelpAuto := .F. // se .t. direciona as mensagens de help para o arq. de log
Private lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros

For nX:=1 To Len(aItems)
	
	If !aItems[nX,1]   // Se o item nï¿½o foi marcado
		Loop
	Endif
	
	SZW->(dbGoTo(aItems[nX,12])) // Posiciona na puxada
	
	cFilAnt := aItems[nX,11]   // Atualiza a filial da movimentaï¿½ï¿½o
	
	If aItems[nX,06] > 0
		cTMMov := GetMv("MV_XTMREQU")  // Tipo de movimentaï¿½ï¿½o de saï¿½da
	Else
		cTMMov := GetMv("MV_XTMDEVO")  // Tipo de movimentaï¿½ï¿½o de entrada
	Endif
	
	// Posiciona no Cadastro de Produtos
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1")+aItems[nX,07]))
	
	// Se nï¿½o existir registro no saldo em estoque, entï¿½o cria
	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(XFILIAL("SB2")+aItems[nX,07]+"TR"))
		// Custo mï¿½dio atual
		nCusto := SB2->B2_CM1
	Else
		CriaSB2(aItems[nX,07],"TR")
	Endif
	
	// Caso seja um custo invï¿½lido
	If nCusto <= 0
		// Posiciona no item da nota de entrada
		SD1->(dbSeek(XFILIAL("SD1")+SZW->(ZW_DOC+ZW_SERIE+ZW_FORNECE+ZW_LOJA+ZW_CODPRO+ZW_ITEM)))
		
		// Custo unitï¿½rio pela entrada
		nCusto := SD1->D1_CUSTO / SD1->D1_QUANT
	Endif
	
	// Calcula o custo total da movimentaï¿½ï¿½o
	nCusto := Round(nCusto * Abs(aItems[nX,06]),TamSX3("D1_CUSTO")[2])
	
	cDocum := GetSxENum("SD3","D3_DOC",1)  // Calcula o prï¿½ximo nï¿½mero do documento
	
	aVetor := {	{ "D3_TM"      , cTMMov         , Nil}, ;
	{ "D3_CC"      , ""             , NIL}, ;
	{ "D3_EMISSAO" , dDataBase      , Nil}, ;
	{ "D3_COD"     , SB1->B1_COD    , Nil}, ;
	{ "D3_LOCAL"   , SB2->B2_LOCAL  , Nil}, ;
	{ "D3_UM"      , SB1->B1_UM     , Nil}, ;
	{ "D3_GRUPO"   , SB1->B1_GRUPO  , NIL}, ;
	{ "D3_TIPO"    , SB1->B1_TIPO   , NIL}, ;
	{ "D3_QUANT"   , Abs(aItems[nX,06]), Nil}, ;
	{ "D3_CUSTO1"  , nCusto         , Nil}, ;
	{ "D3_CONTA"   , Space(20)      , Nil}, ;
	{ "D3_DOC"     , cDocum         , Nil} }
	
	lMsHelpAuto := .F. // se .t. direciona as mensagens de help para o arq. de log
	lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
	
	MSExecAuto({|x,y| MATA240(x,y)}, aVetor, 3)
	
	If lMsErroAuto
		MostraErro()	
		RollBackSX8()
		DisarmTransaction()
	Else
		ConfirmSX8()
		
		// Atualiza o saldo da puxada
		RecLock("SZW",.F.)
		SZW->ZW_SALDO -= aItems[nX,06]
		MsUnLock()
	Endif
Next

cFilAnt := cFilAux   // Restaura a filial de origem

Return !lMsErroAuto

Static Function Marcacao(lCheck,aItems,oLbx)
aEval( aItems , {|x| x[1] := lCheck } )
oLbx:Refresh()
Return

/*_______________________________________________________________________________
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+-------+----------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Funï¿½ï¿½o    ï¿½ AAEST01Vld ï¿½ Autor ï¿½ Ronilton O. Barros   ï¿½ Data ï¿½ 18/10/2012 ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+-------+----------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Descriï¿½ï¿½o ï¿½ Atualiza a variavel de liberacao                              ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+---------------------------------------------------------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function AAEST01Vld()
Local cRet := ReadVar()
AddValid(.F.)   // Adiciona a valida ï¿½ validaï¿½ï¿½o
Return &(cRet)

/*_______________________________________________________________________________
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+-------+----------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Funï¿½ï¿½o    ï¿½ LiberaSenhaï¿½ Autor ï¿½ Ronilton O. Barros   ï¿½ Data ï¿½ 18/10/2012 ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+------------+-------+----------------------+------+------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ Descriï¿½ï¿½o ï¿½ Rotina de liberaï¿½ï¿½o de movimentos das puxadas                 ï¿½ï¿½ï¿½
ï¿½ï¿½+-----------+---------------------------------------------------------------+ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function LiberaSenha()
Local oPsw
Local lRet    := .F.
Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
Local cPswFol := Space(10)
Local cCodUsr := Space(06)
Local cNomUsr := Space(Len(cUserName))

DEFINE MSDIALOG oPsw TITLE "Liberaï¿½ï¿½o da Puxada" FROM 12,10 TO 24,38 OF oMainWnd

@ 10,005 SAY "Codigo..:" PIXEL OF oPsw
@ 10,035 MSGET cCodUsr   Size 40,10 PIXEL OF oPsw FONT oFont1 F3 "USR" VALID ChkUsuario(cCodUsr,@cNomUsr,.F.)

@ 30,005 SAY "Usuï¿½rio.:" PIXEL OF oPsw
@ 30,035 MSGET cNomUsr   SIZE 70,10 PIXEL OF oPsw FONT oFont1 WHEN .F.

@ 50,005 SAY "Senha...:" PIXEL OF oPsw
@ 50,035 GET cPswFol PassWord SIZE 30,10 PIXEL OF oPsw FONT oFont1

@ 70,20 BUTTON oBut1 PROMPT "&Ok"      SIZE 30,12 PIXEL OF oPsw ACTION (lRet := ChkUsuario(cCodUsr,@cNomUsr,.T.) .And.;
ChkSenha(cCodUsr,cPswFol),oPsw:End())
@ 70,60 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 PIXEL OF oPsw ACTION (oPsw:End())

ACTIVATE MSDIALOG oPsw CENTERED

Return lRet

Static Function ChkUsuario(cCodUsr,cNome,lValid)
Local lRet := .T.

If lValid .Or. !Empty(cCodUsr)
	If lRet := (cCodUsr $ GetMv("MV_XUSUPUX",.F.,"000119"))
		PswOrder(1)	//Ordena tabela de usuï¿½rios: (1)Cï¿½digo (2)Nome
		If lRet := PswSeek(cCodUsr)
			cNome:= RetCodUsr(cCodUsr)
		Else
			Alert("Usuï¿½rio informado nï¿½o estï¿½ cadastrado !")
		EndIf
	Else
		Alert("Usuï¿½rio nï¿½o tem permissï¿½o para liberaï¿½ï¿½o !")
	EndIf
Else
	cNome := Space(Len(cNome))
Endif

Return lRet

Static Function ChkSenha(cCodUsr,cPassWord)
Local lRet := .F.

PswOrder(1)
PswSeek(cCodUsr)
If !(lRet := PswName(cPassWord))
	Alert("Senha Invï¿½lida !")
EndIf

Return lRet

Static Function RetCodUsr(cCodUsr)
Local aUser, cUserAnt

PswOrder(1)               // (1) Codigo , (2) Nome
PswSeek(AllTrim(cCodUsr)) // Pesquisa usuï¿½rio
aUser := PswRet(1)        // Retorna Matriz com detalhes, acessos do Usuï¿½rio
cUserAnt := aUser[1][2]   // Retorna codigo do usuï¿½rio [1] ou o Nome [2]

Return cUserAnt

Static Function GravaMov(cTipoMov,cPuxada,cTM,cAlmox,nQuant,nCusto,cDocSeq,cEndAut,cLote,nOpTran)
Local aCusto    := { nCusto, 0, 0, 0, 0}
Local lConsVenc := .F.   // Se considera lote vencido
Local aVetor	:= {}      
Local lRet		:= .T.
    
lMsHelpAuto  := .T.  // se .t. direciona as mensagens de help para o arq. de log
lMsErroAuto  := .F.  // necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros

//-- Cria Movimentacao (E/S) (SD3) 


aVetor := {}                                           
aadd( aVetor, { "D3_FILIAL"  , xFilial("SD3")    , Nil } ) 
aadd( aVetor, { "D3_COD"  , SB1->B1_COD    , Nil } )            
aadd( aVetor, { "D3_QUANT"  , nQuant    , Nil } ) 
aadd( aVetor, { "D3_CF"  , If( cTipoMov == "D" , "DE6", "RE6")   , Nil } ) 
aadd( aVetor, { "D3_CHAVE"  , If( cTipoMov == "D" , "E9", "E0")    , Nil } ) 
aadd( aVetor, { "D3_LOCAL"    , If( cTipoMov == "D" , cAlmox, SD1->D1_LOCAL)    , Nil } ) 
aadd( aVetor, { "D3_DOC"    , cPuxada    , Nil } ) 
aadd( aVetor, { "D3_EMISSAO"    , dDataBase    , Nil } ) 
aadd( aVetor, { "D3_UM"    , SB1->B1_UM    , Nil } ) 
aadd( aVetor, { "D3_GRUPO"    , SB1->B1_GRUPO    , Nil } ) 
aadd( aVetor, { "D3_NUMSEQ"    , cDocSeq    , Nil } ) 
aadd( aVetor, { "D3_QTSEGUM"    , ConvUm(SB1->B1_COD,nQuant,0,2)    , Nil } ) 
aadd( aVetor, { "D3_SEGUM"  , SB1->B1_SEGUM , Nil } ) 
aadd( aVetor, { "D3_TM"  , cTM , Nil } ) 
aadd( aVetor, { "D3_TIPO"  ,SB1->B1_TIPO , Nil } ) 
aadd( aVetor, { "D3_CONTA"  ,SB1->B1_CONTA , Nil } ) 
aadd( aVetor, { "D3_USUARIO" , CUSERNAME , Nil } ) 
aadd( aVetor, { "D3_CUSTO1" , nCusto , Nil } ) 
If !Empty(cEndAut)
	aadd( aVetor, { "D3_LOCALIZ" , PADR(Alltrim(cEndAut),TamSX3("D3_LOCALIZ")[1]) , Nil } ) 
EndIf                  
aadd( aVetor, { "D3_LOTECTL", cLote, Nil } ) 
                
MSExecAuto( { |x,y| MATA240( x , y ) }, aVetor,nOpTran) 
                
If lMsErroAuto                  
	MostraErro()
	lRet:=.F.
	DisarmTransaction()			
Endif       
/*              
RecLock("SD3",.T.)
SD3->D3_FILIAL  := xFilial("SD3")
SD3->D3_COD     := SB1->B1_COD
SD3->D3_QUANT   := nQuant
SD3->D3_CF      := If( cTipoMov == "D" , "DE6", "RE6")
SD3->D3_CHAVE   := If( cTipoMov == "D" , "E9", "E0")
SD3->D3_LOCAL   := If( cTipoMov == "D" , cAlmox, SD1->D1_LOCAL)
SD3->D3_DOC     := cPuxada
SD3->D3_EMISSAO := dDataBase
SD3->D3_UM      := SB1->B1_UM
SD3->D3_GRUPO   := SB1->B1_GRUPO
SD3->D3_NUMSEQ  := cDocSeq
SD3->D3_QTSEGUM := ConvUm(SB1->B1_COD,nQuant,0,2)
SD3->D3_SEGUM   := SB1->B1_SEGUM
SD3->D3_TM      := cTM
SD3->D3_TIPO    := SB1->B1_TIPO
SD3->D3_CONTA   := SB1->B1_CONTA
SD3->D3_USUARIO := CUSERNAME
SD3->D3_CUSTO1  := nCusto
//Endereï¿½amento automatico do armazem TR
If !Empty(cEndAut)
	SD3->D3_LOCALIZ:=cEndAut
EndIf                    
If !Empty(cLote)  
 SD3->D3_LOTECTL:=cLote
EndIf
MsUnLock()       
  */
//-- Atualiza o saldo atual no Local Origem (VATU) com os dados do SD3
B2AtuComD3(aCusto,,,,,lConsVenc)

Return lRet

Static Function LeCoord()
Local cLinha, x
Local nPos := 1
Local nTam := 3
Local aRet := Array(6)

If File("\COORD.TXT")
	nHdl := FT_FUSE("\COORD.TXT")
	FT_FGOTOP()
	cLinha := StrTran(FT_FREADLN(),",","")
	For x:=1 To Len(aRet)
		aRet[x] := Val(SubStr(cLinha,nPos,nTam))
		nPos += 3
	Next
	FT_FUSE()
Endif

Return aRet


USER Function fReprD3()
Local _cTM, cPuxada, nCusto, nQuant, cChave
Local _cAlm    := ""
Local _cArmMat := AllTrim( GetMv("MV_XARMMAT") )
Local cFilSD1  := SD1->(XFILIAL("SD1"))
Local aDocSeq  := {}
Local nX       := 1
Local dDataAux
Local nV
Private _cArmTran := AllTrim( GetMv("MV_XARMTRA") )


fMontaTab()

SB1->(dbSetOrder(1))
SD1->(dbSetOrder(1))

If WWW->(EOF())
	Aviso("Reprocessamento"," Nï¿½o Foram Encontradas puxadas sem movimentos internos",{"OK"})
	WWW->(DbCloseArea())
Else
	dDataAux:=dDataBase
	While WWW->(!EOF())
		For nV:=1 To 2
			dDataBase :=WWW->ZX_DATA
			If nV == 1   // Processa a requisiï¿½ï¿½o (saï¿½da do almoxarifado de trï¿½nsito)
				_cTm  := GetMv("MV_XTMREQU")  // Tipo de movimentaï¿½ï¿½o de saï¿½da
				_cAlm := _cArmTran   // Almoxarifado de trï¿½nsito
				cPuxada := PADL(WWW->ZX_CODIGO,TamSX3("D3_DOC")[1]-1,"0")+"R"
			Else   // Processa a devoluï¿½ï¿½o (entrada no almoxarifado padrï¿½o)
				_cTm  := GetMv("MV_XTMDEVO")  // Tipo de movimentaï¿½ï¿½o de entrada
				_cAlm := _cArmMat    // Almoxarifado de padrï¿½o
				cPuxada := PADL(WWW->ZX_CODIGO,TamSX3("D3_DOC")[1]-1,"0")+"D"
			EndIf
			
			
			If nV == 1
				AAdd( aDocSeq , ProxNum() )
			Else
				// Se tiver processando a entrada no destino
				If Empty(WWW->ZY_LOCAL)   // Se o almoxarifado da puxada estiver vazio
					_cAlm := _cArmMat          // Pega o almoxarifado do parï¿½metro
				Else
					_cAlm := WWW->ZY_LOCAL
				Endif
			Endif
			
			
			// Posiciona no cadastro de produtos
			SB1->(dbSeek(xFilial()+WWW->ZY_CODPRO))
			
			// Caso nï¿½o exista o registro do saldo em estoque
			SB2->(dbSetOrder(1))
			If !SB2->(dbSeek(xFilial("SB2")+WWW->ZY_CODPRO+_cAlm))
				CriaSB2(SB1->B1_COD,_cAlm)   // Cria o saldo
			EndIf
			
			// Posiciona no item da nota de entrada
			SD1->(dbSeek(cFilSD1+WWW->ZY_DOC+WWW->ZY_SERIE+WWW->ZY_FORNECE+WWW->ZY_LOJA+WWW->ZY_CODPRO+WWW->ZY_ITEM))
			
			// Calcula a quantidade do movimento
			nQuant := WWW->ZY_QUANT
			
			If nV == 1   // Se tiver requisitando
				cChave := WWW->ZY_PACLIS+WWW->ZY_DOC+WWW->ZY_SERIE+WWW->ZY_FORNECE+WWW->ZY_LOJA+WWW->ZY_ITEM
				// Posiciona no pack-list
				If SZW->(dbSeek(XFILIAL("SZW")+cChave))
					// Se quantidade for maior que o saldo, entï¿½o estï¿½ sendo retirado resï¿½duos ï¿½ maior
					If nQuant > SZW->ZW_SALDO
						nQuant := SZW->ZW_SALDO
					Endif
				Endif
			Endif
			
			// Calcula o custo total da movimentaï¿½ï¿½o
			nCusto := Round((SD1->D1_CUSTO / SD1->D1_QUANT) * nQuant,TamSX3("D1_CUSTO")[2])
			
			GravaMov(If(nV==1,"R","D"),cPuxada,_cTM,_cAlm,nQuant,nCusto,aDocSeq[nX])
		Next nV
		nX++
		WWW->(DbSkip())
	EndDo
	dDataBase:=dDataAux
	WWW->(DbCloseArea())
EndIf
Return


Static Function fMontaTab()
Local cQry := ""


cQry +=" SELECT SZY.*,SZX.ZX_DATA,SZX.ZX_CODIGO FROM "+RetSQLName("SZY")+" SZY	"
cQry +=" LEFT OUTER JOIN (                          "
cQry +=" 	SELECT SUBSTRING(SD3.D3_DOC,3,6) AS DOC,D3_COD,D3_FILIAL,D3_EMISSAO FROM "+RetSQLName("SD3")+" SD3	"
cQry +=" 	WHERE SD3.D_E_L_E_T_=''	"
cQry +=" 	AND (SUBSTRING(D3_DOC,9,1)='D' OR SUBSTRING(D3_DOC,9,1)='R')	"
cQry +=" ) A ON A.DOC=SZY.ZY_CODIGO	"
cQry +=" AND A.D3_FILIAL=SZY.ZY_FILIAL	"
cQry +=" AND A.D3_COD=SZY.ZY_CODPRO 	"
cQry +=" INNER JOIN "+RetSQLName("SZX")+" SZX ON SZX.D_E_L_E_T_=''	"
cQry +=" AND SZX.ZX_CODIGO=SZY.ZY_CODIGO            "
cQry +=" WHERE SZY.D_E_L_E_T_=' ' AND A.D3_FILIAL IS NULL	"
cQry +=" ORDER BY SZY.ZY_CODIGO	                          	"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "WWW", .F., .T.)

TCSetField("WWW","ZX_DATA","D",8,0)

Return


User Function Preenche()
Local cArmMat :=GetMv("MV_XARMMAT")
Local nPLot := AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOTEFOR"  })
Local nPPac := AScan( aHeader , {|x| Trim(x[2]) == "ZY_PACLIS"  })
Local nPDoc := AScan( aHeader , {|x| Trim(x[2]) == "ZY_DOC"  })
Local nPSer := AScan( aHeader , {|x| Trim(x[2]) == "ZY_SERIE"  })
Local nPFor := AScan( aHeader , {|x| Trim(x[2]) == "ZY_FORNECE"  })
Local nPLoj := AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOJA"  })
Local nPIte := AScan( aHeader , {|x| Trim(x[2]) == "ZY_ITEM"  })
Local nPCod := AScan( aHeader , {|x| Trim(x[2]) == "ZY_CODPRO"  })
Local nPDesc:= AScan( aHeader , {|x| Trim(x[2]) == "ZY_DESCR"  })
Local nPUm	:= AScan( aHeader , {|x| Trim(x[2]) == "ZY_UM"  })
Local nPLoc	:= AScan( aHeader , {|x| Trim(x[2]) == "ZY_LOCAL"  })
Local nPQtd	:= AScan( aHeader , {|x| Trim(x[2]) == "ZY_QUANT"  })
Local lRet  := .T.

If !GdDeleted(n)
	SZZ->(DbSetOrder(2))
	If !SZZ->(DbSeek(xFilial("SZZ")+M->ZY_LOTEFOR))
		Aviso("Cadastro de puxada","Nï¿½o foi localizado nenhum packlist para o lote "+Alltrim(M->ZY_LOTEFOR),{"OK"})
		lRet:=.F.
	Else
		SD1->(DbSetOrder(2))
		If !SD1->(DbSeek(xFilial("SD1")+SZZ->ZZ_COD+SZZ->ZZ_DOC+SZZ->ZZ_SERIE))
			Aviso("Cadastro de puxada","Nï¿½o foi localizado o documento vinculado ao lote"+Alltrim(M->ZY_LOTEFOR),{"OK"})
			lRet:=.F.
		Else                               
			aCols[n,nPLot]:=M->ZY_LOTEFOR
			aCols[n,nPPac]:=SD1->D1_XPACLIS
			aCols[n,nPDoc]:=SD1->D1_DOC
			aCols[n,nPSer]:=SD1->D1_SERIE
			aCols[n,nPFor]:=SD1->D1_FORNECE
			aCols[n,nPLoj]:=SD1->D1_LOJA
			aCols[n,nPIte]:=SD1->D1_ITEM
			aCols[n,nPCod]:=SD1->D1_COD
			aCols[n,nPDesc]:=Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")
			aCols[n,nPum]:=SB1->B1_UM
			// rtetornar armazem de corridas quando for o caso by WLAD 21/06/2019
			iF SuperGetMv("MV_XCORRI",.F.,.F.) .and. SB1->B1_XCTLCOR == "S"
			   aCols[n,nPLoc]:= "06" 
		    Else
			   aCols[n,nPLoc]:=cArmMat
			Endif
			aCols[n,nPQtd]:=SZZ->ZZ_XPLIQ
			oGet:ForceRefresh()
		EndIf
	EndIf
EndIf

Return lRet

/*/{Protheus.doc}EstorEtiq
@description
Exclui a etiqueta gerada na inclusao da puxada.

@author	Bruno Garcia
@since		19/05/2016
@version	P11 R8

@param 	Nao possui,Nao possui,Nao possui,Nao possui
@return	Nao possui,Nao possui,Nao possui,Nao possui
/*/
Static Function EstorEtiq(cNota,cSerie,cFornec,cLoja,cLoteFor)
Local nQtdOk := 0
Local nQtdErr:= 0
Local aOKs   := {}
Local lErro  := .f.
Local nX
Local _cArmMat := AllTrim( GetMv("MV_XARMMAT") ) //Amazem da materia prima

CB0->(DbSetOrder(6)) //CB0_FILIAL+CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO+CB0_CODPRO
If ! CB0->(DbSeek(xFilial("CB0") + cNota + cSerie + cFornec + cLoja))
   Return
Endif
				
While ! CB0->(EOF()) .and. CB0->(CB0_FILIAL+CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO == xFilial("CB0") + cNota + cSerie + cFornec + cLoja)
 
	If CB0->CB0_LOTE # cLoteFor
		CB0->(DbSkip())
		Loop
	Endif

	If CB0->CB0_LOCAL # _cArmMat
		CB0->(DbSkip())
		Loop
    Endif
	
	If !lErro
	   aadd(aOKs,CB0->(RECNO()))	   
	Endif
	CB0->(DbSkip())
Enddo

If lErro
   MostraErro()			
   Return .f.
EndIf
		
If !Empty(aOKs)
   For nX:= 1 to Len(aOKs)
      CB0->(DbGoto(aOKs[nX]))
      Reclock("CB0",.F.)
 	   CB0->(DbDelete())
	   CB0->(MsUnlock())
	Next
Endif

Return Nil


Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
	//ï¿½ Faz o calculo automatico de dimensoes de objetos     ï¿½
	//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 070, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

Return
