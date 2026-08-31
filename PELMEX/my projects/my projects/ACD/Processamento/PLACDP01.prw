#include "protheus.ch"
#include "apvt100.ch"


//----------------------------------------------------------
/*/{Protheus.doc} PLACDP01
Função PLACDP01
Rotina responsável por fazer a identificação dos produtos e seus codigos de barra.
@param nao possui
@return Nil
@author Arlindo Neto
@owner Pelmex
@project Implantacao ACD
14/11/2015 - Criação
/*/
//----------------------------------------------------------

User Function PLACDP01()
	Local    cTitulo := "Identificacao estoque"
	Private  cProd , cCodBar, cLocImp

	If IsTelNet()
		While .t.
			cCodBar := Space(23) //TamSX3("Z4_CEXPEDI")[1]) //COMENTADO POR ELTON - EMPRESA AMAZON NAO POSSUI A TABELA SZ4
			cLocImp := Space(6)
			nQtde   := 1
			@ 1,0 VTSay "Qtd de etiquetas"
			@ 2,0 VtGet nQtde pict "99999" VALID nQtde>0 .and. if(nQtde>100,VTYesNo("Quantidade maior que 100,00. Confirma emissáo?","Atencao!",.t.),.t.)
			@ 3,0 VTSay "Codigo de Barras"
			@ 4,0 VTGet cCodBar pict '@!' VALID !Empty(cCodBar) .and. VldCodBar(cCodBar)

			VTRead              

			IF VTLastKey() == 27
				Exit
			EndIf
		Enddo
	EndIf

Return

Static Function VldCodBar(cCodBar)
	Local lErro  := .F.
	Local lMP 	 := .F.
	Local cAlias := ""
	Local aDados :={}
	Local cPref  := ""
	Local aSave := VTSAVE()


	cCodBar:=Alltrim(cCodBar)
	If Len(cCodBar)<13  
		If IsTelNet()
			VTAlert("Codigo de Barras Inválido!","Atencao",.T.,3000)
			VTClearGet("cCodBar")
			VTGetSetFocus("cCodBar")
			Return(.F.)
		EndIf
	Else
		lMP := (Len(cCodBar)==13)

		//Verifica se é etiqueta de matéria-prima ou produto acabado
		If lMP
			cAlias:="SZ6"
		Else
			cAlias:="SZ4"
		EndIf
		cPref:=Substr(cAlias,2,2)+"_"

		(cAlias)->(dbSetOrder(2))
		//Z6_FILIAL + Z6_LOTECTL
		If !(cAlias)->(DbSeek(xFilial(cAlias)+cCodBar))
			If IsTelNet()
				VTAlert("Nao foi encontrada etiqueta com o codigo lido!","Atencao",.T.,3000)   
				VTClearGet("cCodBar")
				VTGetSetFocus("cCodBar")
				Return(.F.)
			EndIf
		Else
			If IsTelNet()
				VTMSG("Imprimindo...")
			EndIf

			If lMP
				aDados:={(cAlias)->&(cPref+"QUANT"),"","",(cAlias)->&(cPref+"DOC"),(cAlias)->&(cPref+"SERIE"),(cAlias)->&(cPref+"FORNECE"),;
				(cAlias)->&(cPref+"LOJA"),"","","",(cAlias)->&(cPref+"LOTECTL"),"",CtoD("  /  /  "),"","","","","","","",0,(cAlias)->&(cPref+"ITEM")}
				cProduto:=(cAlias)->&(cPref+"PRODUTO")
			Else
				aDados:= {1,"","","","","","","",Substr((cAlias)->&(cPref+"CPRODUC"),1,11),"","","",CtoD("  /  /  "),;
				"","","","","","","",0,""}
				cProduto:=Substr((cAlias)->&(cPref+"CEXPEDI"),1,14)
			EndIf
			//Verifica se a etiqueta foi impressa com sucesso
			lErro:= ! PLACD1Imp(aDados,cProduto)

			If lErro
				If IsTelNet()
					VTAlert("Problema na impressao","Atencao",.T.,3000)		 //"Problema na impressao"###"Atencao"
					VTClearGet("cCodBar")
					VTGetSetFocus("cCodBar")
				EndIf
			Else
				VTClearGet("cCodBar")
				VTGetSetFocus("cCodBar")
			Endif
		EndIf
	EndIf
	VtRestore(,,,,aSave)

Return ! lErro


//----------------------------------------------------------
/*/{Protheus.doc} PLACD1Imp
Função PLACD1Imp
Rotina responsável por fazer a impressão no local do recebimento e gerar etiqueta na tabela CB0
@param nao possui
@return Nil
@author Arlindo Neto
@owner Pelmex
@project Implantacao ACD
14/11/2015 - Criação
/*/
//----------------------------------------------------------

Static Function PLACD1Imp(aDados,cProduto)
	Local cImp	:= Alltrim(GetMv("MV_IACD02"))
	Local nQtNota	:=aDados[1]
	Local cCodSep	:=aDados[2]
	Local cCodID
	Local cNFEnt	:=aDados[4]
	Local cSeriee 	:=aDados[5]
	Local cFornec	:=aDados[6]
	Local cLojafo   :=aDados[7]
	Local cArmazem  :=aDados[8]
	Local cOP       :=aDados[9]
	Local cNumSeq	:=aDados[10]
	Local cLote     :=aDados[11]
	Local cSLote	:=aDados[12]
	Local dValid	:=aDados[13]
	Local cCC		:=aDados[14]
	Local cLocOri	:=aDados[15]
	Local cOPREQ	:=aDados[16]
	Local cNumSerie	:=aDados[17]
	Local cOrigem	:=aDados[18]
	Local cEndereco	:=aDados[19]
	Local cPedido	:=aDados[20]
	Local nResto   	:=aDados[21]
	Local cItNFE  	:=aDados[22]



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
	//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
	//| cliente, assim verificando a necessidade de uma atualizacao     |
	//| nestes fontes. NAO REMOVER !!!							        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
		Final("Atualizar SIGACUS.PRW !!!")
	Endif
	IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
		Final("Atualizar SIGACUSA.PRX !!!")
	Endif
	IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
		Final("Atualizar SIGACUSB.PRX !!!")
	Endif

	//CBChkTemplate()

	If ! CB5SetImp(cImp,IsTelNet())
		CBAlert("Codigo do local de impressao invalido!")   //'Codigo do tipo de impressao invalido'
		Return .f.
	EndIF
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	If ExistBlock('IMG01')
		//ExecBlock('IMG01',,,{nQE,,nID,nQtde,,,,,If(Empty(MV_PAR03)," ",MV_PAR03),,,,,,,If(Empty(MV_PAR05)," ",MV_PAR05)})
		ExecBlock('IMG01',,,{nQtNota,cCodSep,cCodID,nQtde,cNFEnt,cSeriee,cFornec,cLojafo,cArmazem,cOP,cNumSeq,cLote,cSLote,dValid,cCC,cLocOri,cOPREQ,;
		cNumSerie,cOrigem,cEndereco,cPedido,0,cItNFE})	
	EndIf

	MSCBCLOSEPRINTER()                                

Return .T.
