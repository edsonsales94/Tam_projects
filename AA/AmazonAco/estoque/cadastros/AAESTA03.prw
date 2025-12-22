#INCLUDE "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AAESTA03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tabela de preços puxadas                                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTA03()
	Local aCores      := Nil
	
	Private cCadastro := "Tabela de preços das puxadas"
	Private cAlias1   := "SZV"
	Private aPos      := { 15, 02, 065, 375}
	Private aRotina   := { 	{"Pesquisar" ,"AxPesqui"     ,0,1} ,;
									{"Visualizar","u_EST03CadTab",0,2} ,;
									{"Incluir"   ,"u_EST03CadTab",0,3} ,;
									{"Alterar"   ,"u_EST03CadTab",0,4} ,;
									{"Excluir"   ,"u_EST03CadTab",0,5} }
	
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EST03CadTab¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Visualiza / Exclui tabela de preços                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EST03CadTab(cAlias, nRecNo, nOpc )
Local nX
Local nOpcA     := 0
Local oMainWnd  := Nil
Local oFolder   := Nil
Local aAltera   := {}

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

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+---------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)

If Inclui
	M->ZV_CODMOT := CriaVar("ZV_CODMOT")
	M->ZV_NOMMOT := CriaVar("ZF_NOME")
	
	//+----------------
	//| Monta os aCols
	//+----------------
	MontaaCols(,nOpc==3)
Else
	M->ZV_CODMOT := SZV->ZV_CODMOT
	M->ZV_NOMMOT := Posicione("SZF",1,XFILIAL("SZF")+SZV->ZV_CODMOT,"ZF_NOME")
	
	//+----------------
	//| Monta os aCols
	//+----------------
	MontaaCols(@aAltera,.F.)
Endif

DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 TO 40,97 OF oMainWnd

@ 10,010 SAY "Motorista"  SIZE 050,7  PIXEL OF oDlg COLOR CLR_HBLUE
@ 10,035 MSGET oCodMot VAR M->ZV_CODMOT WHEN Inclui F3 CpoRetF3("ZV_CODMOT") VALID ExistCpo("SZF").And.ExistChav("SZV") PICTURE "@!" SIZE 50,10 PIXEL OF oDlg COLOR CLR_HBLUE
oCodMot:bLostFocus := {|| M->ZV_NOMMOT := Posicione("SZF",1,XFILIAL("SZF")+M->ZV_CODMOT,"ZF_NOME"), oNome:Refresh() }

@ 10,140 SAY "Nome"  SIZE 050,7 OF oDlg PIXEL
@ 10,180 MSGET oNome VAR M->ZV_NOMMOT WHEN .F. PICTURE "@!" SIZE 150,8 PIXEL OF oDlg 

oGet := MSGetDados():New(25,2,220,380,nOpc,"u_EST03LinOk()",,,.T.,/*aAlter*/,,,999,,,,If(nOpc==3.Or.nOpc==4,"u_EST03DelIt()","AllWaysFalse"),oDlg)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := If( nOpc == 2 .Or. Obrigatorio(aGets,aTela).And.;
													u_EST03TudOk(),1,0),;
													If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} )

If nOpc <> 2 .And. nOpcA == 1
	Begin Transaction
	EST03Grava(nOpc,nRecNo,aAltera)
	End Transaction
Endif
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EST03DelIt ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EST03DelIt()
	Local x
	Local cVar  := __ReadVar
	Local nDel  := Len(aCols[1])
	Local nPTpo := AScan( aHeader , {|x| Trim(x[2]) == "ZV_TIPOV"  })
	Local nPLoc := AScan( aHeader , {|x| Trim(x[2]) == "ZV_LOCENT" })
	Local lRet  := .T.
	
	If nPD == 2 .And. aCols[n,nDel] // Na delecao da linha - 2a. passagem
	ElseIf nPD == 1
		If aCols[n,nDel] // Na recuperacao da linha - 1a. passagem
			// Ajusta variáveis para uso do validador
			__ReadVar   := "M->ZV_TIPOV"
			M->ZV_TIPOV := aCols[n,nPTpo]
			
			If lRet := u_EST03Valid(.T.)  // Valida o campo tipo do veículo
				__ReadVar    := "M->ZV_LOCENT"
				M->ZV_LOCENT := aCols[n,nPLoc]
				
				lRet := u_EST03Valid(.T.)  // Valida o campo local de entrega
			Endif
		Endif
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)
	
	__ReadVar := cVar  // Restaura a variável padrão
	
Return lRet
	
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EST03Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar os campos das Vendas Especiais                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EST03Valid(lDel)
	Local x, nX
	Local nDel  := Len(aCols[1])
	Local cVar  := Trim(Upper(ReadVar()))
	Local nPTpo := AScan( aHeader , {|x| Trim(x[2]) == "ZV_TIPOV"  })
	Local nPLoc := AScan( aHeader , {|x| Trim(x[2]) == "ZV_LOCENT" })
	Local lRet  := .T.
	
	lDel := If( lDel == Nil , .F., lDel)
	
	If cVar == "M->ZV_TIPOV"
		If lRet := lDel .Or. ExistCpo("SX5","ZX"+M->ZV_TIPOV) .And. ExistChav("SZV",M->ZV_CODMOT+M->ZV_TIPOV+aCols[n,nPLoc])
			// Verifica se já existe a chave em outro item
			For nX:=1 To Len(aCols)
				If nX <> n .And. !aCols[nX,nDel] .And. M->ZV_CODMOT+M->ZV_TIPOV+aCols[n,nPLoc] == M->ZV_CODMOT+aCols[nX,nPTpo]+aCols[nX,nPLoc]
					lRet := ExistChav("SX5","01")
				Endif
			Next
			
			If lRet
				nPos := AScan( aHeader , {|x| Trim(x[2]) == "ZV_DESCV" })
				aCols[n,nPos] := PADR(Posicione("SX5",1,XFILIAL("SX5")+"ZX"+M->ZV_TIPOV,"X5_DESCRI"),TamSX3("ZV_DESCV")[1])
			Endif
		Endif
	ElseIf cVar == "M->ZV_LOCENT"
		If lRet := lDel .Or. ExistCpo("SX5","ZY"+M->ZV_LOCENT) .And. ExistChav("SZV",M->ZV_CODMOT+aCols[n,nPTpo]+M->ZV_LOCENT)
			// Verifica se já existe a chave em outro item
			For nX:=1 To Len(aCols)
				If nX <> n .And. !aCols[nX,nDel] .And. M->ZV_CODMOT+aCols[n,nPTpo]+M->ZV_LOCENT == M->ZV_CODMOT+aCols[nX,nPTpo]+aCols[nX,nPLoc]
					lRet := ExistChav("SX5","01")
				Endif
			Next
			
			If lRet
				nPos := AScan( aHeader , {|x| Trim(x[2]) == "ZV_DESCL" })
				aCols[n,nPos] := PADR(Posicione("SX5",1,XFILIAL("SX5")+"ZY"+M->ZV_LOCENT,"X5_DESCRI"),TamSX3("ZV_DESCL")[1])
			Endif
		Endif
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EST03LinOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EST03LinOk(nPos)
Return MaCheckCols(aHeader,aCols,If( nPos == Nil , n, nPos))

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EST03TudOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EST03TudOk()
	Local nX   := 1
	Local nDel := Len(aCols[1])
	Local lRet := .T.
	
	For nX:=1 To Len(aCols)
		If !aCols[nX,nDel]  // Se não estiver deletado
			If !(lRet := u_EST03LinOk(nX))   // Valida o item
				Exit
			Endif
		Endif
	Next
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EST03Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da tabela de preços                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
|¦¦           ¦ nRecNo   -> Numero do registro a ser gravado                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EST03Grava(nOpc,nRecNo,aAltera)
	Local nX, nY
	Local nPDel := Len(aCols[1])
	
	//+-----------------
	//| Se for inclusão
	//+-----------------
	If nOpc == 3
		For nX:=1 To Len(aCols)
			If !aCols[nX,nPDel]   // Se não estiver deletado
				RecLock("SZV",.T.)
				For nY:=1 To Len(aHeader)
					FieldPut( FieldPos(Trim(aHeader[nY,2])) , aCols[nX,nY] )
				Next
				SZV->ZV_FILIAL := XFILIAL("SZV")
				SZV->ZV_CODMOT := M->ZV_CODMOT
				MsUnLock()
			Endif
		Next
	Endif
	
	//+-----------------
	//| Se for alteração
	//+-----------------
	If nOpc == 4
		For nX:=1 To Len(aCols)
			// Caso o item já exista na base
			If nX <= Len(aAltera)
				SZV->(dbGoTo(aAltera[nX]))  // Posiciona no item
				
				// Atualiza os registros com os novos dados
				RecLock("SZV",.F.)
				If !aCols[nX,nPDel]   // Se não estiver deletado
					For nY:=1 To Len(aHeader)
						FieldPut( FieldPos(Trim(aHeader[nY,2])) , aCols[nX,nY] )
					Next
				Else
					dbDelete()   // Exclui o registro da base
				Endif
				MsUnLock()
			ElseIf !aCols[nX,nPDel]   // Se for novo item e não estiver deletado
				RecLock("SZV",.T.)
				For nY:=1 To Len(aHeader)
					FieldPut( FieldPos(Trim(aHeader[nY,2])) , aCols[nX,nY] )
				Next
				SZV->ZV_FILIAL := XFILIAL("SZV")
				SZV->ZV_CODMOT := M->ZV_CODMOT
				MsUnLock()
			Endif
		Next
	Endif
	
	//+-----------------
	//| Se for exclusão
	//+-----------------
	If nOpc == 5
		For nX:=1 To Len(aCols)
			SZV->(dbGoTo(aAltera[nX]))   // Posiciona no item
			
			RecLock("SZV",.F.)
			dbDelete()
			MsUnLock()
		Next
	Endif
	
Return
	
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaaCols ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aCols                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaaCols(aAltera,lNovo)
	Local nCols, nUsado, nX
	Local cFilSZV := SZV->(XFILIAL("SZV"))
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader()
	
	//+--------------
	//| Monta o aCols com os dados referentes a tabela de preços
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader)
	
	If !lNovo
		dbSelectArea(cAlias1)
		dbSetOrder(1)
		dbSeek(cFilSZV+M->ZV_CODMOT,.T.)
		While !Eof() .And. cFilSZV+M->ZV_CODMOT == ZV_FILIAL+ZV_CODMOT
			
			aAdd(aCols,Array(nUsado+1))
			nCols ++
			
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Else
					aCols[nCols][nX] := &(Trim(Posicione("SX3",2,Trim(aHeader[nX][2]),"X3_INIBRW")))
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.
			
			AAdd( aAltera , Recno() )  // Adiciona o registro do item do pedido
			
			dbSkip()
		Enddo
	Endif
	
	If Empty(aCols)  // Caso nao tenha itens na promoção
		//+--------------
		//| Monta o aCols com uma linha em branco
		//+--------------
		aColsBlank(cAlias1,@aCols,nUsado)
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	Local cCampos := "ZV_CODMOT"
		
	// Cria aHeader com os dados das VENDAS ESPECIAIS
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias1,.T.))
	While !SX3->(Eof()) .And. cAlias1 == SX3->X3_ARQUIVO
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(Trim(SX3->X3_CAMPO) $ cCampos)
		
			aAdd(aHeader,{ Trim(X3Titulo()), ;
			SX3->X3_CAMPO   , ;
			SX3->X3_PICTURE , ;
			SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL , ;
			SX3->X3_VALID   , ;
			SX3->X3_USADO   , ;
			SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO , ;
			SX3->X3_CONTEXT } )
			
		Endif
		SX3->(dbSkip())
	Enddo
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(cAlias,aArray,nUsado)
	Local cCampos := "ZV_CODMOT"
	
	aArray := {}
	aAdd(aArray,Array(nUsado+1))
	nUsado := 0
	
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias,.T.))
	While !SX3->(Eof()) .And. cAlias == SX3->X3_ARQUIVO
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(Trim(SX3->X3_CAMPO) $ cCampos)
			nUsado++
			aArray[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
		Endif
		aArray[1][nUsado+1] := .F.
		SX3->(dbSkip())
	Enddo
	
Return