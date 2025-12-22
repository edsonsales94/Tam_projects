#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"
#include "tbiconn.ch"

/*---------------------------------------------------------------------------------------------------------------------------------------------------
OBJETIVO 1: Montagem da Tela de Pesquisa de Produto por DESCRIÇÃO, FABRICANTE, REFERENCIA e GERAL na Venda Assistida
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
//
//
//
User Function TelaPesq(aParam)

	Local cVar     := Nil
	Local cwVar2   := Nil 
	Local oGet     := Nil

	Private _laRep := __cUserId $ SuperGetMv("MV_XUSRREP",," ")
	Private lExec  := FunName()$"LOJA701#FATA701#MATA410#MATA415"

	//  .------------------------------
	// |     aParam
	// |     [01] -> Codigo do Cliente
	// |     [02] -> Loja   do Cliente
	// |     [03] -> Codigo do Produto
	//  '------------------------------

	Default aParam := {'','',''}

	Private cAlias     := Alias()
	Private nOpc       := 0
	Private lMark      := .F.
	Private oOk        := LoadBitmap( GetResources(), "LBOK" )
	Private oNo        := LoadBitmap( GetResources(), "LBNO" )
	Private _cPesquisa := Space(40)
	Private oDlg       := Nil
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oLbx, owLbx
	Private aVetor      := {}
	Private cModApl1
	Private cModApl2
	Private cModApl3
	Private cFilEst     := {}
	Private aItems      := {}
	Private oTipo       := NIL
	Private _cTipo      := Space(30)
	Private oPesquisa   := NIL
	Private lPA         := .F.
	Private nQtItem     := 0
	Private nTotMarc    := 0
	Private vCodFil 	  := {}
	Private vCodFil2 	  := {}

	Private adColsAux   := {}
	Private adParam     := aClone(aParam)

	SetKey( 9, {||} )
	SetKey(11, {||} )
	SetKey(13, {||} )

	//  .---------------------------------------------------------------------------
	// |     Verifica as Filiais que irão trabalhar com a Transferência entre Lojas
	//  '---------------------------------------------------------------------------
	//VFilial()

	aAdd( aVetor  , { lMark, "", "", PADR("",60), "", 0, "", 0, 0, "", "", "", "", "", .F.,""} )
	aAdd( cFilEst , {  "", "", "" } )

	DEFINE FONT oFnt3 NAME "Ms Sans Serif" BOLD
	DEFINE FONT oFnt3 NAME "MS Sans Serif" SIZE 0, -9 BOLD
	DEFINE FONT oFnt4 NAME "Lucida Console" SIZE 0, -9 BOLD

	DEFINE MSDIALOG oDlg TITLE "Consulta de Produtos"  From 5,15 To 42,160 OF oMainWnd

	oPanelAll:= tPanel():New(0,0,"",oDlg,,,,,,00,030)
	oPanelAll:align:= CONTROL_ALIGN_ALLCLIENT

	oScr:= TScrollBox():New(oPanelAll,60,405,110,150,.T.,.T.,.T.)
	aAdd(aItems,"Descricao")
	aAdd(aItems,"Referencia")
	aAdd(aItems,"Fabricante")
	aAdd(aItems,"Geral")

	@ 015,15 SAY "Tipo : " SIZE 35,8 OF oPanelAll PIXEL FONT oFnt3
	@ 015,50 MSCOMBOBOX oTipo VAR _cTipo ITEMS aItems SIZE 100,50 OF oPanelAll PIXEL

	@ 030,15 SAY "Pesquisar : " SIZE 35,8 OF oPanelAll PIXEL Font oFnt3

	@ 030,50 MSGET oPesquisa  VAR _cPesquisa PICTURE "@!" Size 220,10 Pixel of oPanelAll VALID Pesquisa(_cTipo)

	@ 045,05 LISTBOX oLbx     VAR cVar ;
	FIELDS HEADER " ","Ref", "Código","Descrição","UM","Pr. Venda 1a.UM", "2a.UM","Pr.Venda 2a.UM","Estoque Disp.","Saldo Orc.", "Pr. Venda","Fabrica","Mod/Apl 1","Mod/Apl 2","Mod/Apl 3","PA";
	SIZE 390,180 OF oPanelAll PIXEL ON CHANGE Apertou() ON dblClick( Inverter(oLbx:nAt,@aVetor,@oLbx),oLbx:Refresh(.F.))

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {IIF(aVetor[oLbx:nAt,01],oOk,oNo),;
	aVetor[oLbx:nAt,02],;
	aVetor[oLbx:nAt,03],;
	aVetor[oLbx:nAt,16],;
	aVetor[oLbx:nAt,05],;
	Transform(aVetor[oLbx:nAt,06],PesqPict("SB1","B1_PRV1",18,2)),;
	aVetor[oLbx:nAt,07],;
	Transform(aVetor[oLbx:nAt,08],PesqPict("SB1","B1_PRV1",18,2)),;
	Transform(aVetor[oLbx:nAt,09],PesqPict("SB2","B2_QATU",18,2)),;
	Transform(aVetor[oLbx:nAt,10],PesqPict("SB2","B2_QATU",18,2)),;
	Transform(aVetor[oLbx:nAt,11],PesqPict("SB0","B0_PRV1",18,2)),;
	aVetor[oLbx:nAt,12],;
	aVetor[oLbx:nAt,13],;
	aVetor[oLbx:nAt,14]}}
	oLbx:Refresh()
	oLbx:nAt := 1

	oPesquisa:SetFocus()

	@180, 415 Say oSay6 PROMPT " M O D E L O  / A P L I C A C A O "  SIZE 110,7 OF oPanelAll PIXEL RIGHT COLOR CLR_RED FONT oFnt3
	@030, 410 SAY oSAY4 PROMPT "ESTOQUE NAS FILIAIS  " SIZE 130,7 OF oPanelAll PIXEL RIGHT COLOR CLR_RED FONT oFnt3

	@188, 405 GET oSay1 VAR cModApl1 SIZE 150,10 PIXEL OF oPanelAll FONT oFnt3 When .f. Picture "@E 999,999,999,999.99"
	//@005, 005 SAY oSAY5 PROMPT cFilEst SIZE 150,300 OF oScr PIXEL COLOR CLR_RED FONT oFnt4

	@045, 405 LISTBOX owLbx VAR cwVar2 FIELDS HEADER "Filial", "Armazem", "Saldo" SIZE 160,125 OF oPanelAll PIXEL	
	owLbx:SetArray( cFilEst )		
	owLbx:bLine := {|| { cFilEst[owLbx:nAt,1], cFilEst[owLbx:nAt,2], cFilEst[owLbx:nAt,3]}}                         
	owLbx:Refresh()
	owLbx:nAt := 1

	@205, 405 GET oSay2 VAR cModApl2 SIZE 150,10 PIXEL OF oPanelAll FONT oFnt3 When .f.
	@220, 405 GET oSay3 VAR cModApl3 SIZE 150,10 OF oPanelAll PIXEL FONT oFnt3 When .f.

	ACTIVATE MSDIALOG oDlg ON INIT;
	EnchoiceBar(oDlg,{|| IIf(ValidMarK(adColsAux),(nOpc:=1,oDlg:End()), ) },{||oDlg:End()}) CENTERED

	SetKey( 9 ,  {||U_TelaPesq("F")} )
	SetKey(11 ,  {||U_TelaEnt ("P")} )
	SetKey(13 ,  {||U_TelaEst(aCols[n][2]) } )

Return(nOpc==1)
//
//
//
Static Function Pesquisa(cTipo)
    Local _xdPrc
	Local cQry    
	Local _naSald  := 0    


	If !Empty(_cPesquisa)

		cQry := "SELECT B1_COD, B1_DESC, B1_UM, B1_SEGUM, B1_CONV,B1_REFEREN, B1_ESPECIF, B1_NOMFAB, B1_REFEREN, B1_MODAPL1, B1_MODAPL2,B1_MODAPL3, B1_TIPCONV "
		cQry += "FROM "+RetSQLName("SB1")+" B1 (NOLOCK) "

		cQry += "WHERE B1.D_E_L_E_T_=' ' "
		cQry +=       "AND B1.B1_FILIAL = '" + xFilial("SB1") + "' "
		cQry +=       "AND B1.B1_MSBLQL <> '1' "

		Do Case
			Case cTipo == "Referencia";   cQry += "AND B1.B1_REFEREN LIKE '%" + Alltrim(_cPesquisa) + "%' ORDER BY B1.B1_REFEREN, B1.B1_ESPECIF "
			Case cTipo == "Descricao";    cQry += "AND B1.B1_ESPECIF LIKE '%" + Alltrim(_cPesquisa) + "%' ORDER BY B1.B1_ESPECIF, B1.B1_NOMFAB "
			Case cTipo == "Fabricante";   cQry += "AND B1.B1_NOMFAB LIKE  '%" + Alltrim(_cPesquisa) + "%' ORDER BY B1.B1_NOMFAB, B1.B1_ESPECIF "
			Case cTipo == "Geral";        cQry += "AND (B1.B1_ESPECIF LIKE '%"+Alltrim(_cPesquisa)+"%' OR "
			cQry += "B1.B1_NOMFAB LIKE  '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_MODAPL1 LIKE '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_MODAPL2 LIKE '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_MODAPL3 LIKE '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_REFEREN LIKE '%" + Alltrim(_cPesquisa) + "%') "
			cQry += "ORDER BY B1.B1_ESPECIF,B1.B1_NOMFAB, B1.B1_REFEREN "			
		EndCase

		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )

		dbSelectArea("SB0")
		dbSetOrder(1)

		dbSelectArea("SB2")
		dbSetOrder(1)

		dbSelectArea("QRY")
		dbGoTop()

		aDel(aVetor,Len(aVetor))
		aSize(aVetor,0)
		lValido := .F.
		If Alltrim(FunName()) $ 'MATA410|'

			_xdOrd := StrTokArr( SuperGetMv("MV_XORDTAB",.F.,"PE;CL;PR") ,';')
			_xdTab := ""

			For _xdPrc := 01 To Len(_xdOrd)
				_xdOpc := _xdOrd[_xdPrc]//SubStr(_xdOrd,_xdPRc,2)

				If Empty(_xdTab)
					_xdFunc := SuperGetMv("MV_XTBL"+_xdOpc,.F.,"M->C5_TABELA")
					_xdTab := &( _xdFunc ) //M->C5_TABELA
				Else
					_xdPrc := Len(_xdOrd)
				EndIf

			Next

			DA0->(dbSetOrder(1))
			DA1->(dbSetOrder(1))
			//lValido := .T.
			If DA0->(dbSeek(xFilial('DA0') + _xdTab ))
				lValido := DA0->DA0_DATDE < dDataBase .Or. (DA0->DA0_DATDE < dDataBase .And. DA0->DA0_HORADE <= Left(Time(),5) )
				lValido := lValido .And. (DA0->DA0_DATATE > dDataBase .Or. (DA0->DA0_DATATE = dDataBase .And. DA0->DA0_HORATE >= Left(Time(),5) ))
				lValido := lValido .And. DA0->DA0_ATIVO == "1"
			EndIf
			If !lValido .And. !Empty(_xdTab)
				Aviso('Atencao','Tabela de Preço Selecionada Configurada Invalida, Contate o T.I., Será Considerado o preço da LOJA',{'OK'})
			EndIf
		EndIf

		While !QRY->(Eof())
			lTemSB0 := SB0->(DbSeek(xFilial("SB0")+QRY->B1_COD))
			nPreco 	:= 0
			nWPreco2 := 0

			If lTemSB0
				nPreco := SB0->B0_PRV1
			EndIf

			If lValido .And. Alltrim(FunName()) $ 'MATA410|'
				lContinua := .T.
				DA1->(dbSetOrder(1))
				If DA1->(dbSeek(xFilial('DA1') + _xdTab + QRY->B1_COD ))
					While xFilial('DA1') + QRY->B1_COD + _xdTab == DA1->DA1_FILIAL+DA1->DA1_CODPRO+DA1->DA1_CODTAB .And. lContinua
						If DA1->DA1_ATIVO == "1" //.And. DA1->DA1_DATVIG <= dDataBase
							nPreco := DA1->DA1_PRCVEN
							lContinua := .F.
						EndIf
						DA1->(dbSkip())
					EndDo
				EndIf
			EndIf

			If QRY->B1_TIPCONV == "D"    // Divisor
				nWPreco2 := Round(nPreco * QRY->B1_CONV,2) 
			Else
				nWPreco2 := Round(nPreco / QRY->B1_CONV,2)
			EndIf

			_naSald  := 0 		
			SB2->(DbSeek(xFilial("SB2")+QRY->B1_COD ))   

			Do While !SB2->(Eof()) .And. xFilial("SB2") == SB2->B2_FILIAL .And. QRY->B1_COD == SB2->B2_COD

				If _laRep   

					If SB2->B2_QATU > 0	.and. SB2->B2_LOCAL = "14"			
						_naSald += Round( SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP),2)
					EndIf 

				Else
					If SB2->B2_QATU > 0				
						_naSald += Round( SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP),2)
					EndIf 
				EndIf 			

				SB2->(DbSkip())

			EndDo



			//If Alltrim(QRY->B1_TIPO) == "PA"
			//	lPA 	:= u_VerPA(QRY->B1_COD,lTemSB0,QRY->B1_LOCPAD) // Função para verificação de Produto de KIT baseado na Estrutura de Produto (SG1) - FUNÇÕES ESPECIFICAS
			//EndIf

			If GETMV("MV_USARESE") == "S"         // Controle de Reserva CUSTOMIZADA
				nQtdOrc := u_SaldoOrc(QRY->B1_COD) // Funcao que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos
			Else
				nQtdOrc := 0 // Verificar
			Endif

			lMark := aScan(adColsAux,{|x| x[03] = QRY->B1_COD }) != 0
			//aAdd( aVetor, { lMark, padr(QRY->B1_REFEREN,4), QRY->B1_COD, QRY->B1_ESPECIF, QRY->B1_UM, nPreco, QRY->B1_SEGUM, nWPreco2,  _naSald  , nQtdOrc, QRY->B1_NOMFAB, QRY->B1_MODAPL1, QRY->B1_MODAPL2, QRY->B1_MODAPL3, lPA} )
			aAdd( aVetor, { lMark, padr(QRY->B1_REFEREN,4), QRY->B1_COD, QRY->B1_ESPECIF, QRY->B1_UM, nPreco, QRY->B1_SEGUM, nWPreco2,  _naSald  , nQtdOrc, QRY->B1_NOMFAB, QRY->B1_MODAPL1, QRY->B1_MODAPL2, QRY->B1_MODAPL3, lPA, QRY->B1_DESC} )
			lMark := .F.
			QRY->(DbSkip())

		Enddo

		QRY->(DbCloseArea())

		If Len(aVetor) = 0
			aAdd( aVetor , { lMark, "", "", "", "", 0, "", 0, 0, "", "", "", "", "", .F.,""} )
			MsgAlert("Não existe dados para seleção!!!",OemToAnsi("ATENCAO")  )
		EndIf
		aVetor := aSort(aVetor,,,{|x,y| x[04] < y[04]})	

		oLbx:nAt := 01
		owLbx:nAt := 01

		oLbx:Refresh()
		owLbx:Refresh()
		Apertou()

	EndIf

Return
//
//
//
Static Function Inverter(nPos,aVetor,oLbx)
	Local nD := 0

	aVetor[nPos][1] := !aVetor[nPos][1]

	If lExec
		If FWCodEmp() <> '06' .And. aVetor[nPos][1] .and. aVetor[nPos][8] == 0
			MsgAlert("Produto sem Preço de Venda !!!","ATENCAO")
			aVetor[nPos][1]:=.F.
		EndIf

		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aVetor[nPos][03]))
		If aVetor[nPos][1]
			nPosd := aScan(adColsAux,{|x| x[03] = aVetor[nPos,03] })
			If nPosd = 0
				nQuant := AAGETQTD()				
				If nQuant > 0
					aAdd(adColsAux, aClone(aVetor[nPos]) )
					aAdd(adColsAux[Len(adColsAux)],nQuant)

					xdLocPad := Posicione('SB1',1,xFilial('SB1') + aVetor[nPos][03] ,'B1_LOCPAD')					
					//xdArm    := AAGETLOCAL(xdLocPad)
					aAdd(adColsAux[Len(adColsAux)], xdLocPad)					
				Else
					aVetor[nPos][1]:=.F.
				EndIf
			EndIf
		Else
			nPosd := aScan(adColsAux,{|x| x[03] = aVetor[nPos,03] })
			if nPosd != 0
				adAux := aClone(adColsAux)
				adColsAux := {}
				For nD := 1 To Len(adAux)
					If nPosd != nD
						aAdd(adColsAux,adAux[nD])
					EndIf
				Next

				If Len(adColsAux) = 0
					adColsAux := {}
				EndIf
			EndIf
		EndIf

		oLbx:Refresh()
	EndIf

Return
//
//
//
Static Function ValidMarK(aVetor)

	Local lRet := .T.
	If lExec
		If Ascan(aVetor,{|x| x[1] }) == 0
			Help("",1,"","FORMACAO","Nao foi marcado nenhuma nota !",1,0)
			lRet := .F.
		Else
			GravaMark(aVetor)
		Endif
		if lRet
			If Alltrim(FunName()) $ 'LOJA701#FATA701'
				oBrlNewLine := .F.
				oGetVA:Refresh()
			else
				oGetDad:lNewLine := .F.
				oGetDad:Refresh()
			EndIf
		EndIf
	EndIf
Return(lRet)
//
//
//
Static Function GravaMark(aVetor)

	Local i

	nQtItem := Len(aVetor)

	aStru  := { {"WK_MARCA",   "L", 01, 0},;
	{"WK_UM",      "C", 02, 0},;
	{"WK_SEGUM",   "C", 02, 0},;
	{"WK_FABRICA", "C", 40, 0},;
	{"WK_COD",     "C", 15, 0},;
	{"WK_DESC",    "C", 50, 0},;
	{"WK_REFEREN", "C", 15, 0},;
	{"WK_PRV1",    "N", 18, 2},;
	{"WK_PRV2",    "N", 18, 2},;
	{"WK_QVEN",    "N", 18, 2},;
	{"WK_QATU",    "N", 14, 2},;
	{"WK_SALORC",  "N", 14, 2},;
	{"WK_MODAPL1", "C", 80, 0},;
	{"WK_MODAPL2", "C", 80, 0},;
	{"WK_MODAPL3", "C", 80, 0},;
	{"WK_LOCAL"  , "C", 02, 0},;
	{"WK_PA",      "L", 01, 0}}

	cFile:= CriaTrab(aStru,.T.)
	Use &cFile Alias wMark New Exclusive

	dbSelectArea("wMark")

	For i := 1 to nQtItem
		If aVetor[i][1]
			RecLock("wMark",.T.)
			wMark->WK_MARCA   := aVetor[i][1]
			wMark->WK_REFEREN := aVetor[i][2]                                                                                  
			wMark->WK_COD     := aVetor[i][3]
			wMark->WK_DESC    := aVetor[i][4]
			wMark->WK_UM      := aVetor[i][5]
			wMark->WK_PRV1    := aVetor[i][6]
			wMark->WK_SEGUM   := aVetor[i][7]
			wMark->WK_PRV2    := aVetor[i][8]
			wMark->WK_QATU    := aVetor[i][9]
			wMark->WK_FABRICA := aVetor[i][12]
			wMark->WK_PA      := .F.

			wMark->WK_QVEN    := aVetor[i][len(aVetor[i])-01]
			wMark->WK_LOCAL   := aVetor[i][len(aVetor[i])]
			MsUnLock()
			nTotMarc++
		EndIf

	Next

	Grava_Item()

Return
//
//
//
Static Function Grava_Item()

	Local nUsado   := 0
	Local cdFuncao := FunName()
	Local aColsAux := {}
	Local c := 0 
	Local ndPOs := 0 

	Private nTam   := 0
	Private n_ColProduto,n_ColDescri,n_ColQuant,n_ColVrunit,n_ColVlritem, n_ColEspecif
	Private n_ColLocal,n_ColUm,n_ColDesc,n_ColValdesc,n_ColTes, n_ColCFOP
	Private n_ColCF,n_ColDescpro,n_ColTabela,n_ColPctab
	Private n_ColBaseIcm,n_ColValIPI,n_ColValIcm,n_ColValIss
	Private nd_Peso := 0

	aStru:= {{"WK_COD",     "C", 15, 0},; // Arquivo temporario de consulta
	{"WK_DESC",    "C", 50, 0},;
	{"WK_QATU",    "N", 14, 2},;
	{"WK_FABRICA", "C", 40, 0},;
	{"WK_UM",      "C", 02, 0},;
	{"WK_REFEREN", "C", 15, 0},;
	{"WK_PRV1",    "N", 18, 2},;
	{"WK_QVEN",    "N", 18, 2},;
	{"WK_MODAPL1", "C", 80, 0},;
	{"WK_MODAPL2", "C", 80, 0},;
	{"WK_MODAPL3", "C", 80, 0},;
	{"WK_LOCAL"  , "C", 02, 0},;
	{"WK_PA",      "L", 01, 0}}
	cFile := CriaTrab(aStru,.T.)
	Use &cFile Alias wItem New Exclusive

	dbSelectArea("SF4")
	dbSetOrder(1)

	dbSelectArea("SB0")
	dbSetOrder(1)

	dbSelectArea("SB1")
	dbSetOrder(1)

	dbSelectArea("wMark")

	If Eof()
		wMark->(dbCloseArea())
		wItem->(dbCloseArea())
		Return
	Endif

	If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
		n_ColItem    := aScan(aHeader, {|x| Trim(x[2]) == "LR_ITEM"    })	
		n_ColProduto := aScan(aHeader, {|x| Trim(x[2]) == "LR_PRODUTO" })
		n_ColDescri  := aScan(aHeader, {|x| Trim(x[2]) == "LR_DESCRI"  })
		n_ColQuant   := aScan(aHeader, {|x| Trim(x[2]) == "LR_QUANT"   })
		n_ColSegQt   := aScan( aHeader , {|x| Trim(x[2]) == "LR_QTSEGUM" })
		n_ColVrunit  := aScan(aHeader, {|x| Trim(x[2]) == "LR_VRUNIT"  })
		n_ColVlritem := aScan(aHeader, {|x| Trim(x[2]) == "LR_VLRITEM" })
		n_ColLocal   := aScan(aHeader, {|x| Trim(x[2]) == "LR_LOCAL"   })
		n_ColUm      := aScan(aHeader, {|x| Trim(x[2]) == "LR_UM"      })
		n_ColDesc    := aScan(aHeader, {|x| Trim(x[2]) == "LR_DESC"    })
		n_ColValdesc := aScan(aHeader, {|x| Trim(x[2]) == "LR_VALDESC" })
		n_ColComis	 := aScan(aHeader, {|x| Trim(x[2]) == "LR_COMIS"   })
		n_ColCF      := aScan(aHeader, {|x| Trim(x[2]) == "LR_CF"      })
		n_ColDescpro := aScan(aHeader, {|x| Trim(x[2]) == "LR_DESCPRO" })
		n_ColTabela  := aScan(aHeader, {|x| Trim(x[2]) == "LR_TABELA"  })
		n_ColPctab   := aScan(aHeader, {|x| Trim(x[2]) == "LR_PRCTAB"  })
		n_ColBaseIcm := aScan(aHeader, {|x| Trim(x[2]) == "LR_BASEICM" })
		n_ColValIPI  := aScan(aHeader, {|x| Trim(x[2]) == "LR_VALIPI"  })
		n_ColValIcm  := aScan(aHeader, {|x| Trim(x[2]) == "LR_VALICM"  })
		n_ColValIss  := aScan(aHeader, {|x| Trim(x[2]) == "LR_VALISS"  })
		n_ColBarras  := aScan(aHeader, {|x| Trim(x[2]) == "LR_QTBARRA" })
		n_ColMetros  := aScan(aHeader, {|x| Trim(x[2]) == "LR_METROS"  })
		n_EntBRAS    := 0
		nPosBasIcm	 := aScan(aPosCpoDet, {|x| AllTrim(Upper(x[1])) == "LR_BASEICM"}) // Posicao da Base ICMS
		nPosValIcm	 := aScan(aPosCpoDet, {|x| AllTrim(Upper(x[1])) == "LR_VALICM" }) // Posicao do Valor de ICMS
		nPosLocal	 := aScan(aPosCpoDet, {|x| AllTrim(Upper(x[1])) == "LR_LOCAL"  }) // Posicao do Local
		nPosPrTab	 := aScan(aPosCpoDet, {|x| AllTrim(Upper(x[1])) == "LR_PRCTAB" }) // Posicao do Preco da Tabela
		n_ColTes     := aScan(aPosCpoDet, {|x| AllTrim(Upper(x[1])) == "LR_TES"    }) // Posicao do TES
		n_ColEspecif := 0
	ElseIf Alltrim(cdFuncao) $ 'MATA410|'
		n_ColItem    := aScan(aHeader, {|x| Trim(x[2]) == "C6_ITEM"    })
		n_ColProduto := aScan(aHeader, {|x| Trim(x[2]) == "C6_PRODUTO" })
		n_ColDescri  := aScan(aHeader, {|x| Trim(x[2]) == "C6_DESCRI"  })
		n_ColQuant   := aScan(aHeader, {|x| Trim(x[2]) == "C6_QTDVEN"  })
		n_ColVrunit  := aScan(aHeader, {|x| Trim(x[2]) == "C6_PRCVEN"  })
		n_ColVlritem := aScan(aHeader, {|x| Trim(x[2]) == "C6_VALOR"   })
		n_ColLocal   := aScan(aHeader, {|x| Trim(x[2]) == "C6_LOCAL"   })
		n_ColUm      := aScan(aHeader, {|x| Trim(x[2]) == "C6_UM"      })
		n_ColDesc    := aScan(aHeader, {|x| Trim(x[2]) == "C6_DESCONT" })
		n_ColValdesc := aScan(aHeader, {|x| Trim(x[2]) == "C6_VALDESC" })
		n_ColComis	 := aScan(aHeader, {|x| Trim(x[2]) == "C6_COMIS1"  }) 
		n_ColEspecif := aScan(aHeader, {|x| Trim(x[2]) == "C6_XESPECI"  })
		n_ColCF      := 0
		n_ColDescpro := 0
		n_ColTabela  := 0
		n_ColPctab   := 0
		n_ColBaseIcm := 0
		n_ColValIPI  := 0
		n_ColValIcm  := 0
		n_ColValIss  := 0
		n_ColBarras  := 0
		n_ColMetros  := 0
		n_EntBRAS    := 0
		nPosBasIcm	 := 0
		nPosValIcm	 := 0
		nPosLocal	 := aScan(aHeader , {|x| AllTrim(Upper(x[2])) == "C6_LOCAL"}) // Posicao do Local
		nPosPrTab	 := 0
		n_ColTes     := aScan(aHeader , {|x| AllTrim(Upper(x[2])) == "C6_TES"  }) // Posicao do TES
		n_ColCFOP    := aScan(aHeader , {|x| AllTrim(Upper(x[2])) == "C6_CF"  }) // Posicao do TES
	Else                    

		nReg := TMP1->(RecCount()) //TMP1->(Recno())
		n := nReg

		n_ColItem    := aScan(aHeader, {|x| Trim(x[2]) == "CK_ITEM"    })
		n_ColProduto := aScan(aHeader, {|x| Trim(x[2]) == "CK_PRODUTO" })
		n_ColDescri  := aScan(aHeader, {|x| Trim(x[2]) == "CK_DESCRI"  })
		n_ColQuant   := aScan(aHeader, {|x| Trim(x[2]) == "CK_QTDVEN"  })
		n_ColVrunit  := aScan(aHeader, {|x| Trim(x[2]) == "CK_PRCVEN"  })
		n_ColVlritem := aScan(aHeader, {|x| Trim(x[2]) == "CK_VALOR"   })
		n_ColLocal   := aScan(aHeader, {|x| Trim(x[2]) == "CK_LOCAL"   })
		n_ColUm      := aScan(aHeader, {|x| Trim(x[2]) == "CK_UM"      })
		n_ColDesc    := aScan(aHeader, {|x| Trim(x[2]) == "CK_DESCONT" })
		n_ColValdesc := aScan(aHeader, {|x| Trim(x[2]) == "CK_VALDESC" })
		n_ColComis	 := aScan(aHeader, {|x| Trim(x[2]) == "CK_COMIS1"  })
		n_ColTes     := aScan(aHeader , {|x| AllTrim(Upper(x[2])) == "CK_TES"  }) // Posicao do TES     
		nPosLocal	 := aScan(aHeader , {|x| AllTrim(Upper(x[2])) == "CK_LOCAL"}) // Posicao do Local
		n_ColCF      := 0
		n_ColDescpro := 0
		n_ColTabela  := 0
		n_ColPctab   := 0
		n_ColBaseIcm := 0
		n_ColValIPI  := 0
		n_ColValIcm  := 0
		n_ColValIss  := 0
		n_ColBarras  := 0
		n_ColMetros  := 0
		n_EntBRAS    := 0
		nPosBasIcm	 := 0
		nPosValIcm	 := 0
		nPosPrTab	 := 0
		n_ColEspecif := 0
		// ALTERADO POR WERMESON EM 09/02/2012	

		aCols := {}
		fCriaVar("SCK", @aCols)    

		TMP1->(dbGotop())
		nwInd := 1

		While !TMP1->(Eof())

			aCols[nwInd][n_ColItem   ] := TMP1->CK_ITEM  
			aCols[nwInd][n_ColProduto] := TMP1->CK_PRODUTO
			aCols[nwInd][n_ColDescri ] := TMP1->CK_DESCRI  
			aCols[nwInd][n_ColQuant  ] := TMP1->CK_QTDVEN
			aCols[nwInd][n_ColVrunit ] := TMP1->CK_PRCVEN  
			aCols[nwInd][n_ColVlritem] := TMP1->CK_VALOR
			aCols[nwInd][n_ColLocal  ] := TMP1->CK_LOCAL
			aCols[nwInd][n_ColUm     ] := TMP1->CK_UM
			aCols[nwInd][n_ColDesc   ] := TMP1->CK_DESCONT
			aCols[nwInd][n_ColValdesc] := TMP1->CK_VALDESC
			aCols[nwInd][n_ColComis  ] := TMP1->CK_COMIS1
			aCols[nwInd][n_ColTes    ] := SuperGetMv("MV_XTESCK",.F.,"533") //TMP1->CK_TES
			aCols[nwInd][nPosLocal	] := TMP1->CK_LOCAL                    

			TMP1->(dbSkip())
			If !TMP1->(Eof())
				fCriaVar("SCK", @aCols)      
				nwInd++
			EndIf 
		End

		TMP1->(dbGoto(nReg))   	
	EndIf

	nUsado:= Len(aCols[1])-1

	//  .--------------------------------------------------------------
	// |     Se o último item for vazio ou deletado, elimina esse ítem
	//  '--------------------------------------------------------------
	If Len(aCols) > 1 .and. (Empty(aCols[Len(aCols),n_ColProduto]) .Or. aCols[Len(aCols),nUsado+1])
		aColsAux := aClone(aCols[Len(aCols)])
	Endif

	dbGoTop()
	nBack := n
	While !Eof()

		If SB1->(dbSeek(xFilial("SB1")+wMark->WK_COD))
			If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
				If !Empty(SB1->B1_SEGUM) .And. !(FwCodEmp() == "05" .Or. FwCodEmp() == "06")
					n_ColQuant := aScan( aHeader , {|x| Trim(x[2]) == "LR_QTSEGUM" })
				Else
					n_ColQuant := aScan( aHeader , {|x| Trim(x[2]) == "LR_QUANT"   })
				EndIf
			EndIf


			SF4->(dbSeek(xFilial("SF4")+SB1->B1_TS))  // TES

			SB0->(dbSeek(xFilial("SB0")+SB1->B1_COD)) // Tabela de preços  

			// wermeson em 15/030/2012               
			If Alltrim(cdFuncao) $ 'MATA415|' 
				n := Len(aCols)
			EndIf 

			//  .--------------------------------------------------------------------------------.
			// |     Preenche o aCols utilizando os registros em brancos, incluido mais itens     |
			//  '--------------------------------------------------------------------------------'
			If n = 1 .and. Empty(aCols[n, n_ColProduto]) // Primeria linha do Acols e sem produtos
				nTam 	:= n
			Else
				If Empty(aCols[n, n_ColProduto]) // Já existe uma linha em branco no Acols sem produto, será aproveitada
					nTam 	:= Len(aCols)
					lAADD := .F.
				Else                             // Será criada uma nova linha no Acols para o produto escolhido
					nTam 	:= Len(aCols)+1
					lAADD := .T.
				EndIf
				n := nTam
			EndIf

			If n > 1

				If lAADD // Adiciona uma nova linha no Acols
					aAdd(aCols, Array(nUsado+1) ) // Cria uma nova linha no Acols
				EndIf

				For c:=1 To nUsado
					If aHeader[c,8] ==     "C"; aCols[nTam,c]:= Space( aHeader[c,4] )
					Elseif aHeader[c,8] == "N"; aCols[nTam,c]:= 0
					Elseif aHeader[c,8] == "D"; aCols[nTam,c]:= Ctod("  /  /  ")
					Elseif aHeader[c,8] == "M"; aCols[nTam,c]:= ""
						Else;                       aCols[nTam,c]:= .F.
					Endif
				Next

				aCols[nTam,nUsado+1] := .F.

			EndIf
			//  .-----------------------
			// |     Gravando no Browse
			//  '-----------------------  
			nwAux := SB1->B1_ESPECIF
			aCols[nTam,n_ColItem] 		:= StrZero(nTam,2)
			aCols[nTam,n_ColProduto] 	:= SB1->B1_COD

			If wMark->WK_PA .And. SB1->B1_USAMTS == "S"    // Verifica se é um Produto Acabado e Usa Metros na Venda
				u_TelaQuant(nTam,aCols[nTam][n_ColProduto]) // Função que demonstra na tela a quantidade de metros e peças - FUNCOES GENERICAS.PRW
			EndIf

			n := nTam

			If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
				oGetVA:oBrowse:nAt := n := nTam
				LJ7Detalhe()                                 // Itens que atualiza o Rodapé do Orçamento
				aColsDet[nTam][nPosLocal] := wMark->WK_LOCAL
				LJ7Prod(.T.)                                 // Função que executa os gatilhos no SX7 no Produto

			else
				aCols[nTam,n_ColProduto] := ''

				If Alltrim(cdFuncao) $ 'MATA410|' 
					A410Produto(SB1->B1_COD)					                                       
					
					/*If ExistTrigger("C6_PRODUTO") //.And. n_ColQuant == AScan( aHeader , {|x| Trim(x[2]) == "LR_ENTBRAS" })
						RunTrigger(1,,,"C6_PRODUTO")
					EndIf*/

				Else          

					nReg := TMP1->(Recno())

					// Pesquisa uma posição que esteja deletada ou vazia
					TMP1->(dbGoTo(nTam))
					lNovo := .T.//TMP1->(Eof()) .Or. Empty(TMP1->CK_PRODUTO)

					RecLock("TMP1",lNovo)
					For c:=1 To Len(aHeader)
						If !(SubStr(aHeader[c,2],3,7) $ "_ALI_WT,_REC_WT")
							FieldPut(c,CriaVar(aHeader[c,2],.T.))
						Endif
					Next
					TMP1->CK_ITEM    := StrZero(nTam,2)        
					TMP1->CK_PRODUTO := SB1->B1_COD   


					MsUnLock()

					A415Prod(SB1->B1_COD)
					TMP1->CK_TES  := SuperGetMv("MV_XTESCK",.F.,"533")
				EndIf   

				aCols[nTam,n_ColProduto] := SB1->B1_COD
			Endif

			//  .--------------------------.
			// |     Gravando no Browse     |
			//  '--------------------------'		

			If !wMark->WK_PA .Or. (wMark->WK_PA .And. SB1->B1_USAMTS <> "S")
				aCols[nTam][n_ColQuant]   := wMark->WK_QVEN //1 // Caso não seja Produto Acabado ou Seja PA e não utilize a rotina de metros a quantidade deverá ser zerada
				aCols[nTam][n_ColVrUnit]  := wMark->WK_PRV1 // Caso não seja Produto Acabado ou Seja PA e não utilize a rotina de metros a quantidade deverá ser zerada
				aCols[nTam][n_ColVlritem] := wMark->WK_PRV1 * wMark->WK_QVEN

				If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
					If ExistTrigger("LR_QTSEGUM") .And. n_ColQuant == AScan( aHeader , {|x| Trim(x[2]) == "LR_QTSEGUM" })
						RunTrigger(2,Len(aCols),,"LR_QTSEGUM")
					Else
						aCols[nTam][n_ColSegQt] := ConvUm(SB1->B1_COD, wMark->WK_QVEN,0,2 )								   
					EndIf

					u_GetSZG(n,1)
					u_AALOJE7A()

					oGetVA:oBrowse:nAt := n := nTam
					LJ7Prod(.T.) 											// Função que executa os gatilhos no SX7 no Produto
					aCols[nTam,n_ColDescri]  := nwAux

				else                           

					If Alltrim(cdFuncao) $ 'MATA410|'
						A410Produto(SB1->B1_COD)
						acols[n][aScan(aHeader, {|x| Trim(x[2]) == "C6_QTDLIB" })] := aCols[n][n_ColQuant]    
						acols[n][n_ColEspecif] := SB1->B1_ESPECIF			       
					Else    

						RecLock("TMP1",.F.)								      
						TMP1->CK_QTDVEN := wMark->WK_QVEN //1 // Caso não seja Produto Acabado ou Seja PA e não utilize a rotina de metros a quantidade deverá ser zerada
						TMP1->CK_PRCVEN := wMark->WK_PRV1     // Caso não seja Produto Acabado ou Seja PA e não utilize a rotina de metros a quantidade deverá ser zerada
						TMP1->CK_VALOR  := wMark->WK_PRV1 * wMark->WK_QVEN							      
						MsUnLock()

						A415Prod(SB1->B1_COD)
						RecLock("TMP1",.F.)	
						TMP1->CK_TES  := SuperGetMv("MV_XTESCK",.F.,"533")
						MsUnLock()
					EndIf   

				EndIf
			Else
				//
				// Para que o vendedor defina as quantidades de cada produto
				//                                     
				aCols[nTam][n_ColDescri]:= Left(aCols[nTam][n_ColDescri],27) + " " + aCols[nTam][n_ColUm]
			EndIf


			If (Alltrim(cdFuncao) $ 'MATA410|')
				// Add por wermeson em 17/10/2022
				aCols[nTam][n_ColTes] := iif(FindFunction("u_AA410TES") ,U_AA410TES() , "   ")    
		//		aCols[nTam][n_ColTes]

				if M->C5_XTIPO == "08"
					aCols[nTam][n_ColQuant  ] := aScan(aHeader, {|x| Trim(x[2]) == "C6_QTDVEN"  })
					aCols[nTam][n_ColVrunit ] := POSICIONE("SB2", 1, XFILIAL("SB2") + aCols[nTam,n_ColProduto] , "B2_CMFIM1")
					aCols[nTam][n_ColVlritem] := aCols[nTam][n_ColQuant  ] * aCols[nTam][n_ColVrunit ]
					aCols[nTam][n_ColTes    ] := GetMv("MV_XTESUSO")
				EndIf 

				RunTrigger(2,nTam,,"C6_TES")

			eNDiF 


			For ndPOs := 1 To Len(aHeader)

				If aHeader[ndPOs,02] $ "C6_PRODUTO"
					RunTrigger(2,n,,aHeader[ndPOs,02])
				EndIf   

				If aHeader[ndPOs,02] $ "C6_TES"
					A410MultT(aHeader[ndPOs,02], aCols[n][aScan(aHeader,{|x| Alltrim( x[02]) == Alltrim(aHeader[ndPOs,02]) } )] ,.T.)
				EndIf   

				If ExistTrigger(aHeader[ndPOs,02]) .And. ! Alltrim(aHeader[ndPOs,02]) $ "C6_OPER"
					RunTrigger(2,n,,aHeader[ndPOs,02])
				EndIf
			Next

			//If Alltrim(cdFuncao) $ 'MATA410|' .And. ExistTrigger("C6_QTDVEN")
			//RunTrigger(2,n,,"C6_QTDVEN")
			//EndIf

			If Alltrim(cdFuncao) $ 'LOJA701#FATA701'						
				u_GetSZG(n,1)
			EndIf

			If SB1->B1_UM = 'KG'
				nd_Peso += SB1->B1_PESO * aCols[n][n_ColQuant]
			elseif SB1->B1_UM = 'KG'
			EndIf

			oLbx:Refresh()

			If !(Alltrim(cdFuncao) $ 'MATA415|')
				u_VServico(nTam) // Verifica se o item escolhido é um SERVIÇO
			Else 
				oGetDad:nCount := TMP1->(RecCount())
				TMP1->(dbGoTop()) 
				oGetDad:oBrowse:GoTop()
				//      		ALERT("TESTE")
			EndIf

			
			dbSelectArea("wMark")

		Endif

		dbSkip()
	Enddo

	nd_peso := u_Calcpeso(aCols)

	/*
	If Alltrim(cdFuncao) $ 'LOJA701#FATA701'   
	LJ7Prod(.T.) 											// Função que executa os gatilhos no SX7 no Produto
	else
	A410Produto(SB1->B1_COD)
	EndIf
	*/
	n := nBack

	oLbx:Refresh()

	wItem->(DbCloseArea())
	wMark->(DbCloseArea())

	dbSelectArea(cAlias)

Return
//
//
//
Static Function Apertou()
	Local lAux := .T.
	Local I
	cModApl1 := aVetor[oLbx:nAt,9]
	cModApl2 := aVetor[oLbx:nAt,10]
	cModApl3 := aVetor[oLbx:nAt,11]


	oSay1:Refresh()
	oSay2:Refresh()
	oSay3:Refresh()  

	/*cFilEst  := {}
	aAdd( cFilEst , {  "", "", "" } )
	*/

	_xdEstTotal := 0
	_xdUserHab  := SuperGetMv("MV_XUSRCUF",.F.,"000025;000000")
	_xdEmp := Alltrim(FwCodEmp())

	cFilEst  := {} //""//Space(02)
	aAdd( cFilEst , {  "", "", "" } )

	If _xdEmp$"05,06"

		_xdNEmp := If(_xdEmp=='05','06','06') 
		_xQry := " Select B2_COD,B2_FILIAL,B2_LOCAL,Sum(B2_QATU) B2_QATU  From SB2" + _xdNEmp + "0 "
		_xQry += " Where D_E_L_E_T_ = ' ' "
		_xQry += "  And B2_QATU > 0 "
		_xQry += "  And B2_COD = '" + aVetor[oLbx:nAt,3] + "' "
		_xQry += "  Group By B2_COD,B2_FILIAL,B2_LOCAL "

		_xTbl := MpSysOpenQry(_xQRy)
		While !(_xTbl)->(Eof())		
			_xdEstTotal += (_xTbl)->B2_QATU//If(SB2->B2_QATU > 0,SB2->B2_QATU,0)
			aadd(cFilEst, {if(_xdEmp=='06',if((_xTbl)->B2_FILIAL == "01", 'COM. ALVORADA/', 'CD CRESPO/'),'COM.  SILVES/') + (_xTbl)->B2_FILIAL, (_xTbl)->B2_LOCAL + '-' + GetArmDesc(_xdNEmp,(_xTbl)->B2_LOCAL) , Transform((_xTbl)->B2_QATU,"@E 999,999,999.99")})

			(_xTbl)->(dbSkip())

			lAux := .F.
		EndDo
	EndIf

	For I:=1 to Len(vCodFil)

		SB2->(dbSetOrder(1))

		If SB2->(MsSeek(vCodFil[I] + padr(aVetor[oLbx:nAt,3],TamSx3('B1_COD')[01])))

			Do While !SB2->(Eof()) .And. vCodFil[I] == SB2->B2_FILIAL .And. padr(aVetor[oLbx:nAt,3],TamSx3('B1_COD')[01]) == SB2->B2_COD

				//If vCodFil[I] <> xFilial("SB2") .Or. Alltrim(__cUserID)$_xdUserHab //SubStr(cNumEmp,3,2)  // Somente o Estoque das demais Lojas, a Loja que o usuário está logado não será demonstrada
				//cFilEst += PadC(vCodFil2[i]+" Local "+SB2->B2_LOCAL+" --> "+Transform(SB2->B2_QATU,"@E 999,999,999.99") ,49)                 
				//	cFilEst += PADR( Padr(alltrim(vCodFil2[i]),25) +" Local: "+SB2->B2_LOCAL+" --> "+Transform(SB2->B2_QATU,"@E 999,999,999.99") , 150) + CHR(10)+CHR(13)
				//cFilEst += Padr(Alltrim(PADR( alltrim(vCodFil2[i]), 25)+" Local: "+SB2->B2_LOCAL+" --> "+Transform(SB2->B2_QATU,"@E 999,999.99")),150) + CHR(10)+CHR(13)
				If lAux
					cFilEst  := {} //""//Space(02)
					aAdd( cFilEst , {  "", "", "" } )
					lAux := .F.
				EndIf
				_xdEstTotal += If(SB2->B2_QATU > 0,SB2->B2_QATU,0)

				If _laRep    			
					If SB2->B2_QATU > 0	.And. SB2->B2_LOCAL = "14"
						//_naSald += Round( SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP),2)
						aadd(cFilEst, {vCodFil2[i], SB2->B2_LOCAL, Transform(SB2->B2_QATU,"@E 999,999,999.99")})
					EndIf
				Else
					If SB2->B2_QATU > 0
						aadd(cFilEst, {vCodFil2[i], SB2->B2_LOCAL, Transform(SB2->B2_QATU,"@E 999,999,999.99")})
					EndIf
				EndIf
				/*
				If SB2->B2_QATU > 0
				aadd(cFilEst, {vCodFil2[i], SB2->B2_LOCAL, Transform(SB2->B2_QATU,"@E 999,999,999.99")})
				EndIf 
				*/
				//EndIf
				SB2->(DbSkip())

			EndDo

		EndIf


	Next

	If Len(cFilEst) == 0
		cFilEst := {} 
		aAdd( cFilEst , {  "", "", "" } )
	EndIf
	owLbx:AArray := ACLONE(cFilEst)
	owLbx:nAt := 1
	oSay4:Refresh()
	owLbx:Refresh()
	oLbx:Refresh()

Return(.T.)
/*
//  .---------------------------------------------------------------------------
// |     Verifica as Filiais que irão trabalhar com a Transferência entre Lojas
//  '---------------------------------------------------------------------------
Static Function VFilial()

	Local _xdUserHab  := SuperGetMv("MV_XUSRCUF",.F.,"000025;000000")

	cQry := "SELECT * "
	cQry += "FROM "+RetSqlName("SLJ")+" "
	cQry += "WHERE LJ_RPCEMP = '"+SM0->M0_CODIGO+"' AND "
	//cQry += "LJ_RPCFIL <> '"+SubStr(cNumEmp,3,2)+"' AND "
	/*
	If !Alltrim(__cUserID)$_xdUserHab
	cQry += "LJ_RPCFIL <> '"+xFilial("SB2")+"' AND "
	EndIf
	
	cQry += "D_E_L_E_T_ <> '*' "
	cQry += "ORDER BY LJ_RPCEMP, LJ_RPCFIL  "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"FIL",.T.,.T.)
	dbSelectArea("FIL")

	While !Eof()
		aAdd(vCodFil,  LJ_RPCFIL)
		aAdd(vCodFil2, PadC(ALLTRIM(LJ_NOME),20))
		dbSkip()
	End

	dbCloseArea("FIL")
Return()

*/
//
//
//
User Function AAGETLOCAL()
	Prepare Environment Empresa '01' Filial  '01'
Return Alert(AAGETLOCAL())

Static Function AAGETLOCAL(_xdPadrao)

	Local oDlg := TDialog():New(010,250,300,' ',,,,nOr(WS_VISIBLE,WS_POPUP),CLR_BLACK,CLR_WHITE,,,.T.)
	Local oLayer := FWLAYER():New()
	Local xdLocal := "  "
	Local xdDescri := "  "

	Local nOpc := 0

	Default _xdPadrao := "01"

	xdLocal := _xdPadrao
	xdDescri := Posicione('NNR',1,xFilial('NNR') + xdLocal,'NNR_DESCRI')
	oLayer:Init(oDlg,.F.)

	oLayer:AddCollumn('FULL',100,.T.,)
	oLayer:AddWindow('FULL','WFULL','Armazen',100,.T.,,,)

	wWindow := oLayer:getWinPanel('FULL','WFULL')
	oGet1 := TGet():New( 005, 009, { | u | If( PCount() == 0, xdLocal, xdLocal := u ) },wWindow, 040, 010, "!@",{|| xdDescri := Posicione('NNR',1,xFilial('NNR') + xdLocal,'NNR_DESCRI')}, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"xdLocal",,,,.T. ,,,"Armazen",1 )
	oGet1:cF3 := "NNR"
	oGet1 := TGet():New( 005, 050, { | u | If( PCount() == 0, xdDescri, xdDescri := u ) },wWindow, 080, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"xdDesc",,,,.T. ,,,Chr(13),1 )	 
	oGet1:BWhen := {|| .F. }
	oTButton1 := TButton():New( 030, 009, "Confirmar",wWindow,{|| nOpc := 01,oDlg:End() }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( 030, 045, "Cancelar",wWindow,{|| nOpc := 02,oDlg:End() }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )   	 

	oDlg:Activate(,,,.T.,)//{||msgstop('validou!'),.T.},,{||msgstop('iniciando')} )
	If nOpc == 01 .And. !Empty(xdLocal)
		xReturn := xdLocal
	Else
		xReturn := _xdPadrao
	EndIf

Return xReturn
Static Function AAGETQTD()

	Private nQuant  := -1

	Define Font oFnt3 Name "Ms Sans Serif" Bold

	while nQuant < 0
		nQuant := 0
		DEFINE MSDIALOG oDialog TITLE "Quantidade" FROM 190,110 TO 300,370 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
		@ 005,004 SAY "Quantidade :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
		@ 005,050 GET nQuant         SIZE 50,10  PICTURE "@E 999,999.99" VALID GetQtd()//Pixel of oSenhas

		@ 035,042 BMPBUTTON TYPE 1 ACTION( nRet := IIF(nQuant >= 0,oDialog:End(), NIL) )

		ACTIVATE DIALOG oDialog CENTERED
	Enddo

Return nQuant


Static Function GetQtd()

	If FunName()$"MATA410#MATA415"
		If SB1->B1_XMPEMB==0
			Aviso("Atencao","Este produto não esta com o campo Qtd. Embalagem (B1_XMPEMB) preenchido, verificar com o setor de PCP!",{"OK"})
		Else
			If nQuant<SB1->B1_XMPEMB
				nQuant := SB1->B1_XMPEMB
			Else
				nQuant := Abs(Round((nQuant/SB1->B1_XMPEMB),0) * SB1->B1_XMPEMB)-nQuant+nQuant 
			EndIf
		EndIf
	EndIf
Return .T.

//***************************************************************************************

Static Function fCriaVar(cAlias, aCols)
Local nx
	aAdd(aCols,Array(Len(aHeader)+1))                	

	For nx:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[nx,2])
		If IsHeadRec(cCampo)
			aCols[Len(aCols)][nx] := 0
		ElseIf IsHeadAliasa(cCampo)
			aCols[Len(aCols)][nx] := cAlias			
		Else
			aCols[Len(aCols)][nx] := CriaVar(cCampo,.T.)
		EndIf
	Next nx                         

	aCols[Len(aCols)][len(aHeader)+1] := .F.
Return nil

Static Function GetArmDesc(_xdEmp,_xdLocal)

	Local _xdQry := ""
	Local _xdDsc := ""

	_xdQry += " Select * From NNR" + _xdEmp + "0"
	_xdQry += "  Where D_E_L_E_T_ = ''"
	_xdQry += "  And NNR_CODIGO = '" + _xdLocal + "'" 

	_xdTbl := MpSysOpenQuery(_xdQry)

	If !(_xdTbl)->(Eof())
		_xdDsc := (_xdTbl)->NNR_DESCRI 
	EndIf

Return _xdDsc
