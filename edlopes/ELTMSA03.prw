#INCLUDE "Protheus.ch"

Static __cViagem := Space(40)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ ELTMSA03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Carregamento / Descarregamento de Balsa / Tanque              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function ELTMSA03()
	Local aCores      := {	{"ZA_STATUS == '1'","ENABLE" },;    // CARREGAMENTO PARCIAL
							{"ZA_STATUS == '2'","BR_AZUL"},;    // CARREGAMENTO TOTAL
							{"ZA_STATUS == '3'","BR_AMARELO"},; // DESCARREGAMENTO PARCIAL
							{"ZA_STATUS == '4'","BR_PINK"},;    // DESCARREGAMENTO TOTAL
							{"ZA_STATUS == '5'","DISABLE"}}     // ENCERRADO
	
	Private cCadastro := "Carregamento e Descarregamento"
	Private cAlias1   := "SZA"
	Private cAlias2   := "SZB"
	Private cFilSZA   := (cAlias1)->(xFilial(cAlias1))
	Private cFilSZB   := (cAlias2)->(xFilial(cAlias2))
	Private aRotina   := {	{"Pesquisar"  ,"AxPesqui"      ,0,1} ,;
							{"Visualizar" ,"u_ELTMS03Carga",0,2} ,;
							{"Carregar"   ,"u_ELTMS03Carga",0,3} ,;
							{"Alterar"    ,"u_ELTMS03Carga",0,4} ,;
							{"Excluir"    ,"u_ELTMS03Carga",0,5} ,;
							{"Descarregar","u_ELTMS03Carga",0,6} ,;
							{"Encerrar"   ,"u_ELTMS03Carga",0,7} ,;
							{"Canc.Encerram.","u_ELTMS03Carga",0,8} ,;
							{"Legenda"    ,"u_ELTMS03Legen",0,9} }
	
	dbSelectArea("SZ8")
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
	Set Filter To
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ELTMS03Carga¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inclui o Carregamento / Descarregamento                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ELTMS03Carga(cAlias, nRecNo, nOpc )
Local aSize, aPosObj, aPosGet, nCnt, nCol, nLargura, nFt, nPL, nFator, oFontP
Local aAltera   := {}
Local nX        := 0
Local nOpcA     := 0
Local oFontG    := TFont():New("Arial",,-14,.T.,.T.)
Local oFontD    := TFont():New("Arial",,-08,.T.,.T.)
Local nLin      := 0
Local nSalta    := 13

If nOpc == 6
	If SZA->ZA_STATUS < "2"
		Mensagem(1,"É necessário concluir o carregamento antes de iniciar um descarregamento !")
		Return
	ElseIf SZA->ZA_STATUS > "2"
		Mensagem(1,If(SZA->ZA_STATUS$"34","Esse carregamento já possui um descarregamento !","Esse carregamento está encerrado !"))
		Return
	Endif
ElseIf nOpc == 7
	If SZA->ZA_STATUS == "5"
		Mensagem(1,"Essa Operação já esTá encerrada !")
		Return
	ElseIf SZA->ZA_STATUS < "4"
		Mensagem(1,"É necessário concluir o descarregamento antes de encerrar !")
		Return
	Endif
ElseIf nOpc == 8
	If SZA->ZA_STATUS <> "5"
		Mensagem(1,"Não é possível cancelar encerramento de uma operação não encerrada !")
		Return
	Endif
ElseIf nOpc > 3 .And. nOpc <> 8
	If SZA->ZA_STATUS == "5"
		Mensagem(1,"Essa Operação já está ancerrada !")
		Return
	Endif
Endif

Private cComboT
Private oDlg       := Nil
Private aTela      := {}
Private aGets      := {}
Private bCampo     := { |nField| Field(nField) }
Private Inclui     := (nOpc == 3)
Private Altera     := (nOpc == 4)
Private nPD        := 1

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := If( nOpc == 3 , CriaVar(FieldName(nX),.T.), FieldGet(nX))
Next nX

Private cB1_DESC   := ""
Private cDA3_EDESC := ""
Private cDA3_BDESC := ""
Private cZ1_PEDESC := ""
Private cZ1_PDDESC := ""
Private cOrigem    := PADR("ORIGEM",30)
Private cDestino   := PADR("DESTINO",30)         // D2_EMISSAO
Private nDifDens   := 0
Private nTotAmb    := 0

Private aCmpCb1 := {}
Private aCmpCb2 := {}
Private aCmpDta := {}
Private aCmpTot := {}

Private aHCarga := {}
Private aCCarga := {}
Private aCDesca := {}

Private aHApura := {}
Private aCApCar := {}
Private aCApDes := {}

Private aHDifer := {}
Private aCDfAlt := {}
Private aCDfRef := {}

Private aHDfAmb := {}
Private aCDfAmb := {}

Private aVlrAnt := {}

Private nPCDTqe := 1
Private nPCDRef := 2
Private nPCDMed := 3
Private nPCDTmp := 4
Private nPCDVol := 5

Private nPApTqe := 1
Private nPApVol := 2
Private nPApPes := 3
Private nPApDsA := 4
Private nPApTmA := 5
Private nPApDen := 6
Private nPApFat := 7

Private nPDfTqB := 1
Private nPDfVoB := 2
Private nPDfTqE := 3
Private nPDfVoE := 4

Private nPAmTqB := 1
Private nPAmVoB := 2
Private nPAmTqE := 3
Private nPAmVoE := 4

Private nTxTran := 0.85
Private nTxSobr := 0.87

//+----------------------------------
//| Inicia as posições dos objetos
//+----------------------------------
PosObjetos(@aSize,@aPosObj,@aPosGet)

If (nFator:=(aSize[5] / 1905)) < 1   // Caso seja uma dimensão menor
	oFontP := TFont():New("Arial",,-11,.T.,.T.)
Else	
	oFontP := oFontG
Endif

M->DA3_VOLMAX := CriaVar("DA3_VOLMAX",.F.)
M->DA3_XFATEX := CriaVar("DA3_XFATEX",.F.)

AAdd( aCmpCb1 , {,"ZA_DTOPER" , "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb1 , {,"ZA_TPPROD" , "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb1 , {,"DA3_VOLMAX", "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb1 , {,"ZA_VOLPROG", "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb1 , {,"ZA_TIPO"   , "",,,,{20,10},,,CLR_HBLUE})
AAdd( aCmpCb1 , {,"DA3_XFATEX", "",,,,{60,10},,,CLR_BLACK})
AAdd( aCmpCb1 , {,"ZA_VIAGEM" , "",,,,{40,10},,,CLR_HBLUE})
AtribuiCabec(aCmpCb1,aSize[5]/2,nOpc)

AAdd( aCmpCb2 , {,"ZA_EMPURRA", "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb2 , {,"ZA_BALSA"  , "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb2 , {,"ZA_PTEMB"  , "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb2 , {,"ZA_PTDES"  , "",,,,{60,10},,,CLR_HBLUE})
AAdd( aCmpCb2 , {,"ZA_FATCARG", "",,,,{60,10},,,CLR_BLACK})
AAdd( aCmpCb2 , {,"ZA_FATDESC", "",,,,{60,10},,,CLR_BLACK})
AAdd( aCmpCb2 , {,"ZA_TPERSOB", "",,,,{60,10},,,CLR_BLACK})
AtribuiCabec(aCmpCb2,aSize[5]/2,nOpc)

AAdd( aCmpDta , {,"ZA_DTSAICA", "",,,,{55,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_HRSAICA", "",,,,{15,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_DTCHDES", "",,,,{55,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_HRCHDES", "",,,,{15,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_DTINIDE", "",,,,{55,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_HRINIDE", "",,,,{15,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_DTFIMDE", "",,,,{55,10},,,CLR_HBLUE})
AAdd( aCmpDta , {,"ZA_HRFIMDE", "",,,,{15,10},,,CLR_HBLUE})
AtribuiCabec(aCmpDta,aSize[5]/2,nOpc)

AAdd( aCmpTot , {,"ZA_VALTRAN", "",,,,{70,10},,,CLR_BLACK})
AAdd( aCmpTot , {,"ZA_VPERSOB", "",,,,{70,10},,,CLR_BLACK})
AAdd( aCmpTot , {,"ZA_VALNF"  , "",,,,{70,10},,,CLR_BLACK})
AAdd( aCmpTot , {,"ZA_VALSOB" , "",,,,{70,10},,,CLR_BLACK})
AAdd( aCmpTot , {,"ZA_VALLIQ" , "",,,,{70,10},,,CLR_BLACK})
AtribuiCabec(aCmpTot,aSize[5]/2,nOpc)

CriaHeader()   // Monta os campos da tela do carregamento / descarregamento

If nOpc <> 3
	nRecNo := SZA->(Recno())
	
	// Carrega os dados de Carregamento dos Tanques
	SZB->(dbSetOrder(1))
	SZB->(dbSeek(SZA->ZA_FILIAL+SZA->ZA_COD+"C",.T.))
	While !SZB->(Eof()) .And. SZB->ZB_FILIAL+SZB->ZB_COD+SZB->ZB_TIPO == SZA->ZA_FILIAL+SZA->ZA_COD+"C"
		
		// Preenche os dados do Carregamento
		AAdd( aCCarga , {} )
		nCnt := Len(aCCarga)
		For nX:=1 To Len(aHCarga)
			AAdd( aCCarga[nCnt] , SZB->&( aHCarga[nX,2] ) )
		Next
		AAdd( aCCarga[nCnt] , .F. )
		
		// Preenche os dados da Apuração do Carregamento
		AAdd( aCApCar , {} )
		nCnt := Len(aCApCar)
		For nX:=1 To Len(aHApura)
			AAdd( aCApCar[nCnt] , SZB->&( aHApura[nX,2] ) )
		Next
		AAdd( aCApCar[nCnt] , .F. )
		
		SZB->(dbSkip())
	Enddo
	
	// Carrega os dados de Descarregamento dos Tanques
	SZB->(dbSetOrder(1))
	SZB->(dbSeek(SZA->ZA_FILIAL+SZA->ZA_COD+"D",.T.))
	While !SZB->(Eof()) .And. SZB->ZB_FILIAL+SZB->ZB_COD+SZB->ZB_TIPO == SZA->ZA_FILIAL+SZA->ZA_COD+"D"
		
		// Preenche os dados do Descarregamento
		AAdd( aCDesca , {} )
		nCnt := Len(aCDesca)
		For nX:=1 To Len(aHCarga)
			AAdd( aCDesca[nCnt] , SZB->&( aHCarga[nX,2] ) )
		Next
		AAdd( aCDesca[nCnt] , .F. )
		
		// Preenche os dados da Apuração do Descarregamento
		AAdd( aCApDes , {} )
		nCnt := Len(aCApDes)
		For nX:=1 To Len(aHApura)
			AAdd( aCApDes[nCnt] , SZB->&( aHApura[nX,2] ) )
		Next
		AAdd( aCApDes[nCnt] , .F. )
		
		SZB->(dbSkip())
	Enddo
	
	SZA->(dbGoTo(nRecNo))    // Restaura posição do registro
Endif

If Empty(aCDesca)
	aColsBlank(aCDesca,aHCarga)
Endif

If Empty(aCCarga)
	aColsBlank(aCCarga,aHCarga)
	aColsBlank(aCApCar,aHApura)
	aColsBlank(aCApDes,aHApura)
	
	aColsBlank(aCDfAlt,aHDifer)
	aColsBlank(aCDfRef,aHDifer)
	aColsBlank(aCDfAmb,aHDfAmb)
Else
	MontaCarga()
Endif

M->ZA_TIPO := If( nOpc == 3 , "C", If( nOpc == 6 , "D", If( nOpc == 7 , "E", If( SZA->ZA_STATUS $ "12" , "C", If( SZA->ZA_STATUS $ "34" , "D", SZA->ZA_TIPO)))))

aCmpCb1[AScan(aCmpCb1,{|x|x[2]=="ZA_VIAGEM" }),10] := If(M->ZA_TIPO=="C",CLR_BLACK,CLR_HBLUE)

aCmpDta[AScan(aCmpDta,{|x|x[2]=="ZA_DTCHDES"}),10] := If(M->ZA_TIPO>="D",CLR_HBLUE,CLR_BLACK)
aCmpDta[AScan(aCmpDta,{|x|x[2]=="ZA_HRCHDES"}),10] := If(M->ZA_TIPO>="D",CLR_HBLUE,CLR_BLACK)
aCmpDta[AScan(aCmpDta,{|x|x[2]=="ZA_DTINIDE"}),10] := If(M->ZA_TIPO>="D",CLR_HBLUE,CLR_BLACK)
aCmpDta[AScan(aCmpDta,{|x|x[2]=="ZA_HRINIDE"}),10] := If(M->ZA_TIPO>="D",CLR_HBLUE,CLR_BLACK)
aCmpDta[AScan(aCmpDta,{|x|x[2]=="ZA_DTFIMDE"}),10] := If(M->ZA_TIPO=="E",CLR_HBLUE,CLR_BLACK)
aCmpDta[AScan(aCmpDta,{|x|x[2]=="ZA_HRFIMDE"}),10] := If(M->ZA_TIPO=="E",CLR_HBLUE,CLR_BLACK)

aCmpTot[AScan(aCmpTot,{|x|x[2]=="ZA_VALNF"  }),10] := If(M->ZA_TIPO=="E",CLR_HBLUE,CLR_BLACK)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

@ 035, 001 SCROLLBOX oScroll VERTICAL HORIZONTAL SIZE aSize[6] / 2 - 50, aSize[5] / 2 -1 OF oDlg

@ nLin,aCmpCb1[1,1] SAY aCmpCb1[1,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[1,10]
@ nLin,aCmpCb1[2,1] SAY aCmpCb1[2,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[2,10]
@ nLin,aCmpCb1[3,1] SAY aCmpCb1[3,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[3,10]
@ nLin,aCmpCb1[4,1] SAY aCmpCb1[4,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[4,10]
@ nLin,aCmpCb1[5,1] SAY aCmpCb1[5,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[5,10]
@ nLin,aCmpCb1[6,1] SAY aCmpCb1[6,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[6,10]
@ nLin,aCmpCb1[7,1] SAY aCmpCb1[7,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb1[7,10]

nLin += 9
@ nLin,aCmpCb1[1,1] MSGET aCmpCb1[1,5] VAR M->ZA_DTOPER  SIZE aCmpCb1[1,7][1] ,aCmpCb1[1,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb1[1,10] WHEN nOpc==3
@ nLin,aCmpCb1[2,1] MSGET aCmpCb1[2,5] VAR M->ZA_TPPROD  SIZE aCmpCb1[2,7][1] ,aCmpCb1[2,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb1[2,10] WHEN nOpc==3
@ nLin,aCmpCb1[3,1] MSGET aCmpCb1[3,5] VAR M->DA3_VOLMAX SIZE aCmpCb1[3,7][1] ,aCmpCb1[3,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb1[3,10] WHEN .F.
@ nLin,aCmpCb1[4,1] MSGET aCmpCb1[4,5] VAR M->ZA_VOLPROG SIZE aCmpCb1[4,7][1] ,aCmpCb1[4,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb1[4,10] WHEN nOpc==3
@ nLin,aCmpCb1[5,1] MSCOMBOBOX aCmpCb1[5,5] VAR cComboT ITEMS aCmpCb1[5,9] SIZE 80,15 PIXEL OF oScroll FONT oFont ON CHANGE (M->ZA_TIPO:=PADR(cComboT,1)) WHEN .F.
@ nLin,aCmpCb1[6,1] MSGET aCmpCb1[6,5] VAR M->DA3_XFATEX SIZE aCmpCb1[6,7][1] ,aCmpCb1[6,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb1[6,10] WHEN .F.
@ nLin,aCmpCb1[7,1] MSGET aCmpCb1[7,5] VAR M->ZA_VIAGEM  SIZE aCmpCb1[7,7][1] ,aCmpCb1[7,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb1[7,10] WHEN !Empty(M->ZA_EMPURRA).And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)

@ nLin+14,aCmpCb1[2,1] SAY oB1_DESC VAR cB1_DESC SIZE 75,10 PIXEL OF oScroll FONT oFontD COLOR CLR_HRED

aEval( aCmpCb1 , {|x| If(!Empty(x[8]).And.Len(x[9])<2,x[5]:cF3:=x[8],), If(!Empty(x[6]).And.Len(x[9])<2,x[5]:Picture:=x[6],) } )

nLin += 21
@ nLin,aCmpCb2[1,1] SAY aCmpCb2[1,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[1,10]
@ nLin,aCmpCb2[2,1] SAY aCmpCb2[2,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[2,10]
@ nLin,aCmpCb2[3,1] SAY aCmpCb2[3,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[3,10]
@ nLin,aCmpCb2[4,1] SAY aCmpCb2[4,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[4,10]
@ nLin,aCmpCb2[5,1] SAY aCmpCb2[5,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[5,10]
@ nLin,aCmpCb2[6,1] SAY aCmpCb2[6,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[6,10]
@ nLin,aCmpCb2[7,1] SAY aCmpCb2[7,3]  PIXEL OF oScroll FONT oFontG COLOR aCmpCb2[7,10]

nLin += 9
@ nLin,aCmpCb2[1,1] MSGET aCmpCb2[1,5] VAR M->ZA_EMPURRA SIZE aCmpCb2[1,7][1] ,aCmpCb2[1,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[1,10] WHEN nOpc==3
@ nLin,aCmpCb2[2,1] MSGET aCmpCb2[2,5] VAR M->ZA_BALSA   SIZE aCmpCb2[2,7][1] ,aCmpCb2[2,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[2,10] WHEN nOpc==3
@ nLin,aCmpCb2[3,1] MSGET aCmpCb2[3,5] VAR M->ZA_PTEMB   SIZE aCmpCb2[3,7][1] ,aCmpCb2[3,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[3,10] WHEN nOpc==3
@ nLin,aCmpCb2[4,1] MSGET aCmpCb2[4,5] VAR M->ZA_PTDES   SIZE aCmpCb2[4,7][1] ,aCmpCb2[4,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[4,10] WHEN nOpc==3
@ nLin,aCmpCb2[5,1] MSGET aCmpCb2[5,5] VAR M->ZA_FATCARG SIZE aCmpCb2[5,7][1] ,aCmpCb2[5,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[5,10] WHEN .F.
@ nLin,aCmpCb2[6,1] MSGET aCmpCb2[6,5] VAR M->ZA_FATDESC SIZE aCmpCb2[6,7][1] ,aCmpCb2[6,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[6,10] WHEN .F.
@ nLin,aCmpCb2[7,1] MSGET aCmpCb2[7,5] VAR M->ZA_TPERSOB SIZE aCmpCb2[7,7][1] ,aCmpCb2[7,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpCb2[7,10] WHEN .F.

@ nLin+14,aCmpCb2[1,1] SAY oDA3_EDESC VAR cDA3_EDESC SIZE 75,10 PIXEL OF oScroll FONT oFontD COLOR CLR_HRED
@ nLin+14,aCmpCb2[2,1] SAY oDA3_BDESC VAR cDA3_BDESC SIZE 75,10 PIXEL OF oScroll FONT oFontD COLOR CLR_HRED
@ nLin+14,aCmpCb2[3,1] SAY oZ1_PEDESC VAR cZ1_PEDESC SIZE 75,10 PIXEL OF oScroll FONT oFontD COLOR CLR_HRED
@ nLin+14,aCmpCb2[4,1] SAY oZ1_PDDESC VAR cZ1_PDDESC SIZE 75,10 PIXEL OF oScroll FONT oFontD COLOR CLR_HRED

aEval( aCmpCb2 , {|x| If(!Empty(x[8]).And.Len(x[9])<2,x[5]:cF3:=x[8],), If(!Empty(x[6]).And.Len(x[9])<2,x[5]:Picture:=x[6],) } )

nLin += 21
nCol := 1

nLargura := ((aSize[5] - 44) / 2) / 4

@ nLin,02*nCol+nLargura*(nCol-1)+000 SAY "Data Saída"    PIXEL OF oScroll FONT oFontG COLOR aCmpDta[1,10]
@ nLin,02*nCol+nLargura*(nCol-1)+055 MSGET aCmpDta[1,5] VAR M->ZA_DTSAICA SIZE aCmpDta[1,7][1] ,aCmpDta[1,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[1,10] WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin,02*nCol+nLargura*(nCol-1)+115 MSGET aCmpDta[2,5] VAR M->ZA_HRSAICA SIZE aCmpDta[2,7][1] ,aCmpDta[2,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[2,10] WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nCol++
@ nLin,02*nCol+nLargura*(nCol-1)+000 SAY "Data Chegada"  PIXEL OF oScroll FONT oFontG COLOR aCmpDta[3,10]
@ nLin,02*nCol+nLargura*(nCol-1)+055 MSGET aCmpDta[3,5] VAR M->ZA_DTCHDES SIZE aCmpDta[3,7][1] ,aCmpDta[3,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[3,10] WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin,02*nCol+nLargura*(nCol-1)+115 MSGET aCmpDta[4,5] VAR M->ZA_HRCHDES SIZE aCmpDta[4,7][1] ,aCmpDta[4,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[4,10] WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nCol++
@ nLin,02*nCol+nLargura*(nCol-1)+000 SAY "Data Início"   PIXEL OF oScroll FONT oFontG COLOR aCmpDta[5,10]
@ nLin,02*nCol+nLargura*(nCol-1)+055 MSGET aCmpDta[5,5] VAR M->ZA_DTINIDE SIZE aCmpDta[5,7][1] ,aCmpDta[5,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[5,10] WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin,02*nCol+nLargura*(nCol-1)+115 MSGET aCmpDta[6,5] VAR M->ZA_HRINIDE SIZE aCmpDta[6,7][1] ,aCmpDta[6,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[6,10] WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nCol++
@ nLin,02*nCol+nLargura*(nCol-1)+000 SAY "Data Término"  PIXEL OF oScroll FONT oFontG COLOR aCmpDta[7,10]
@ nLin,02*nCol+nLargura*(nCol-1)+055 MSGET aCmpDta[7,5] VAR M->ZA_DTFIMDE SIZE aCmpDta[7,7][1] ,aCmpDta[7,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[7,10] WHEN nOpc==7
@ nLin,02*nCol+nLargura*(nCol-1)+115 MSGET aCmpDta[8,5] VAR M->ZA_HRFIMDE SIZE aCmpDta[8,7][1] ,aCmpDta[8,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpDta[8,10] WHEN nOpc==7 ; nCol++

aEval( aCmpDta , {|x| If(!Empty(x[8]).And.Len(x[9])<2,x[5]:cF3:=x[8],), If(!Empty(x[6]).And.Len(x[9])<2,x[5]:Picture:=x[6],) } )

nLin += 15
nCol := 1

oDigCar := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130,(02+nLargura)*nCol,"Carregamento (Origem)"    ,,,.T.) ; nCol++
oDigDes := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130,(02+nLargura)*nCol,"Descarregamento (Destino)",,,.T.) ; nCol++
oDigApC := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130,(02+nLargura)*nCol,"Apuração Carregamento"    ,,,.T.) ; nCol++
oDigApD := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130,(02+nLargura)*nCol,"Apuração Descarregamento" ,,,.T.) ; nCol:=1

oGetCar := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124,(02+nLargura)*nCol-2,If(M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6),GD_UPDATE,),"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHCarga,aCCarga) ; nCol++
oGetDes := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124,(02+nLargura)*nCol-2,If(M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6),GD_UPDATE,),"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHCarga,aCDesca) ; nCol++
oGetApC := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124,(02+nLargura)*nCol-2,If(M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6),GD_UPDATE,),"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHApura,aCApCar) ; nCol++
oGetApD := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124,(02+nLargura)*nCol-2,If(M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6),GD_UPDATE,),"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHApura,aCApDes)

nFt := 0.6

nLin += 130
nCol := 1
nPL  := 5
oTotCar := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.2),(02+nLargura)*nCol,/*"Carregamento (Origem)"*/,,,.T.)

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Bordo Ambiente (Origem)"    PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oBorAmbO VAR M->ZA_BDAMBC  Picture X3Picture("ZA_BDAMBC" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Bordo A 20° (Origem)"       PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oBor20gO VAR M->ZA_BD20C   Picture X3Picture("ZA_BD20C"  ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY oOrigem VAR cOrigem          PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oVol20gO VAR M->ZA_VOL20TC Picture X3Picture("ZA_VOL20TC") SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO$"C".And.!(nOpc==2.Or.nOpc==5) ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Percentual (%)"             PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oPercenO VAR M->ZA_PERCC   Picture X3Picture("ZA_PERCC"  ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Quantidade a absorver"      PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oQtdAbso VAR M->ZA_QTDABS  Picture X3Picture("ZA_QTDABS" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta

nPL += 5
nSize := 50 * nFator
nColS := 50 - nSize + If( nFator < 1 , 20, 0)
nCol1 := 68 - If( nFator < 1 , 25, 0)
nCol2 := 50 - nSize
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "B"+If(nFator<1,".","anda")+" Bombordo" PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+nCol1 MSGET oBanBomO VAR M->ZA_BANBOMC         Picture X3Picture("ZA_BANBOMC") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F.
@ nLin+nPL-0,(02+nLargura)*nCol-107+nColS SAY "B"+If(nFator<1,".","anda")+" Borest"   PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-055+nCol2 MSGET oBanBorO VAR M->ZA_BANBORC            Picture X3Picture("ZA_BANBORC") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Trim Proa"                             PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+nCol1 MSGET oTriProO VAR M->ZA_TRIPROC         Picture X3Picture("ZA_TRIPROC") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F.
@ nLin+nPL-0,(02+nLargura)*nCol-107+nColS SAY "Trim Popa"                             PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-055+nCol2 MSGET oTriPopO VAR M->ZA_TRIPOPC            Picture X3Picture("ZA_TRIPOPC") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
nCol++

nPL := 5
oTotDes := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.2),(02+nLargura)*nCol,/*"Carregamento (Origem)"*/,,,.T.)

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Bordo Ambiente (Destino)"   PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oBorAmbD VAR M->ZA_BDAMBD  Picture X3Picture("ZA_BDAMBD" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Bordo A 20° (Destino)"      PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oBor20gD VAR M->ZA_BD20D   Picture X3Picture("ZA_BD20D"  ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY oDestino VAR cDestino        PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oVol20gD VAR M->ZA_VOL20TD Picture X3Picture("ZA_VOL20TD") SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO$"D".And.!(nOpc==2.Or.nOpc==5) ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Percentual (%)"             PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oPercenD VAR M->ZA_PERCD   Picture X3Picture("ZA_PERCD"  ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Quantidade a Cobrar 20°"    PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-75        MSGET oQtdCobr VAR M->ZA_QTDCOB  Picture X3Picture("ZA_QTDCOB" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta

nPL += 5
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "B"+If(nFator<1,".","anda")+" Bombordo" PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+nCol1 MSGET oBanBomD VAR M->ZA_BANBOMD         Picture X3Picture("ZA_BANBOMD") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F.
@ nLin+nPL-0,(02+nLargura)*nCol-107+nColS SAY "B"+If(nFator<1,".","anda")+" Borest"   PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-55+nCol2  MSGET oBanBorD VAR M->ZA_BANBORD            Picture X3Picture("ZA_BANBORD") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Trim Proa"                             PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+nCol1 MSGET oTriProD VAR M->ZA_TRIPROD         Picture X3Picture("ZA_TRIPROD") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F.
@ nLin+nPL-0,(02+nLargura)*nCol-107+nColS SAY "Trim Popa"                             PIXEL OF oScroll FONT oFontP /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-55+nCol2  MSGET oTriPopD VAR M->ZA_TRIPOPD            Picture X3Picture("ZA_TRIPOPD") SIZE nSize,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontP COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
nCol++

nPL := 5
oDifAlt := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.2),(02+nLargura)*nCol,"Diferença das Alturas",,,.T.)
oGetAlt := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124*nFt,(02+nLargura)*nCol-2,2/*GD_UPDATE*/,"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHDifer,aCDfAlt)
@ nLin+124*nFt+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Dif. Dens. a 20°" PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+124*nFt+nPL-2,(02+nLargura)*nCol-75        MSGET oDifDens VAR nDifDens Picture X3Picture("ZB_DENS20" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F.
nCol++

nPL := 5
oDifRef := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.2),(02+nLargura)*nCol,"Diferença de Referências",,,.T.)
oGetRef := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124*nFt,(02+nLargura)*nCol-2,2/*GD_UPDATE*/,"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHDifer,aCDfRef)
@ nLin+124*nFt+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Trânsito Excedido (dias)"  PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+124*nFt+nPL-2,(02+nLargura)*nCol-75        MSGET oDiasExc VAR M->ZA_TXTRAN Picture X3Picture("ZA_TXTRAN") SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta
@ nLin+124*nFt+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Sobreestadia (dias)"       PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+124*nFt+nPL-2,(02+nLargura)*nCol-75        MSGET oSobrest VAR M->ZA_TXSOB  Picture X3Picture("ZA_TXSOB" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta

nLin += 130*(nFt+0.2)
nCol := 1
nPL  := 5
nColS-= If( nFator < 1 , 15, 0)
oComplO := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.1),(02+nLargura)*nCol,/*"Diferença de Referências"*/,,,.T.)

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Atracação"    PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+50 MSGET oAtracO      VAR M->ZA_ATRACAC  Picture X3Picture("ZA_ATRACAC") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,(02+nLargura)*nCol-100+nColS SAY "Medição"      PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-45        MSGET oMedicO      VAR M->ZA_HORMEDC  Picture X3Picture("ZA_HORMEDC") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nPL += nSalta

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Início Oper." PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+50 MSGET oIniOpO      VAR M->ZA_INIOPEC  Picture X3Picture("ZA_INIOPEC") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,(02+nLargura)*nCol-100+nColS SAY "Liberação"    PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-45        MSGET oLiberO      VAR M->ZA_LIBERAC  Picture X3Picture("ZA_LIBERAC") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nPL += nSalta

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Final Oper."  PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+50 MSGET oFimOpO      VAR M->ZA_FIMOPEC  Picture X3Picture("ZA_FIMOPEC") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,(02+nLargura)*nCol-100+nColS SAY "Tempo Oper."  PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-45        MSGET oTempoO      VAR M->ZA_TEMOPEC  Picture X3Picture("ZA_TEMOPEC") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*0 SAY "Cal. Ré"      PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*0 MSGET oCalReO  VAR M->ZA_CALREC  Picture X3Picture("ZA_CALREC" ) SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*1 SAY "Cal. M. Nau"  PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*1 MSGET oCalMNO  VAR M->ZA_CALMNAC Picture X3Picture("ZA_CALMNAC") SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*2 SAY "Cal. Vante"   PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*2 MSGET oCalVaO  VAR M->ZA_CALVANC Picture X3Picture("ZA_CALVANC") SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="C".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*3 SAY "Cal. Médio"   PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*3 MSGET oCalMeO  VAR M->ZA_CALMEDC Picture X3Picture("ZA_CALMEDC") SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F.
nCol++

nPL  := 5
oComplD := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.1),(02+nLargura)*nCol,/*"Diferença de Referências"*/,,,.T.)

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Atracação"    PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+50 MSGET oAtracD      VAR M->ZA_ATRACAD  Picture X3Picture("ZA_ATRACAD") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,(02+nLargura)*nCol-100+nColS SAY "Medição"      PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-45        MSGET oMedicD      VAR M->ZA_HORMEDD  Picture X3Picture("ZA_HORMEDD") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nPL += nSalta

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Início Oper." PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+50 MSGET oIniOpD      VAR M->ZA_INIOPED  Picture X3Picture("ZA_INIOPED") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,(02+nLargura)*nCol-100+nColS SAY "Liberação"    PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-45        MSGET oLiberD      VAR M->ZA_LIBERAD  Picture X3Picture("ZA_LIBERAD") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6) ; nPL += nSalta

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Final Oper."  PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,02*nCol+nLargura*(nCol-1)+50 MSGET oFimOpD      VAR M->ZA_FIMOPED  Picture X3Picture("ZA_FIMOPED") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,(02+nLargura)*nCol-100+nColS SAY "Tempo Oper."  PIXEL OF oScroll   FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL-2,(02+nLargura)*nCol-45        MSGET oTempoD      VAR M->ZA_TEMOPED  Picture X3Picture("ZA_TEMOPED") SIZE 15*nFator,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F. ; nPL += nSalta

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*0 SAY "Cal. Ré"      PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*0 MSGET oCalReD  VAR M->ZA_CALRED  Picture X3Picture("ZA_CALRED" ) SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*1 SAY "Cal. M. Nau"  PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*1 MSGET oCalMND  VAR M->ZA_CALMNAD Picture X3Picture("ZA_CALMNAD") SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*2 SAY "Cal. Vante"   PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*2 MSGET oCalVaD  VAR M->ZA_CALVAND Picture X3Picture("ZA_CALVAND") SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN M->ZA_TIPO=="D".And.(nOpc==3.Or.nOpc==4.Or.nOpc==6)
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*3 SAY "Cal. Médio"   PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+nPL+9,02*nCol+nLargura*(nCol-1)+05 + (nLargura/4)*3 MSGET oCalMeD  VAR M->ZA_CALMEDD Picture X3Picture("ZA_CALMEDD") SIZE 40,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F.
nCol++

nPL  := 5
oDifAmb := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.1),(02+nLargura)*nCol,"Diferenças no Vol. Ambiente" ,,,.T.)
oGetAmb := MsNewGetDados():New(nLin+7,02*nCol+nLargura*(nCol-1)+2,nLin+124*nFt,(02+nLargura)*nCol-2, 2/*GD_UPDATE*/,"AllwaysTrue()",,,/*aAltera*/,,,,,"AllwaysTrue()",oScroll,aHDfAmb,aCDfAmb)
@ nLin+124*nFt+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Total Ambiente" PIXEL OF oScroll FONT oFontG /*COLOR CLR_HBLUE*/
@ nLin+124*nFt+nPL-2,(02+nLargura)*nCol-75 MSGET oTotAmb  VAR nTotAmb  Picture X3Picture("ZB_VOL" ) SIZE 70,10 VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR CLR_HBLUE WHEN .F.
nCol++

nPL  := 5
oResumo := TGROUP():Create(oScroll,nLin,02*nCol+nLargura*(nCol-1),nLin+130*(nFt+0.1),(02+nLargura)*nCol,/*"Diferença de Referências"*/,,,.T.)

@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Valor Trânsito Excedido" PIXEL OF oScroll FONT oFontG COLOR aCmpTot[1,10]
@ nLin+nPL-2,(02+nLargura)*nCol-75 MSGET aCmpTot[1,5] VAR M->ZA_VALTRAN SIZE aCmpTot[1,7][1] ,aCmpTot[1,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpTot[1,10] READONLY ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Perda a Cobrar ou Sobra" PIXEL OF oScroll FONT oFontG COLOR aCmpTot[2,10]
@ nLin+nPL-2,(02+nLargura)*nCol-75 MSGET aCmpTot[2,5] VAR M->ZA_VPERSOB SIZE aCmpTot[2,7][1] ,aCmpTot[2,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpTot[2,10] READONLY ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Valor Unitário da NF"    PIXEL OF oScroll FONT oFontG COLOR aCmpTot[3,10]
@ nLin+nPL-2,(02+nLargura)*nCol-75 MSGET aCmpTot[3,5] VAR M->ZA_VALNF   SIZE aCmpTot[3,7][1] ,aCmpTot[3,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpTot[3,10] WHEN nOpc==7 ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Valor Sobreestadia"      PIXEL OF oScroll FONT oFontG COLOR aCmpTot[4,10]
@ nLin+nPL-2,(02+nLargura)*nCol-75 MSGET aCmpTot[4,5] VAR M->ZA_VALSOB  SIZE aCmpTot[4,7][1] ,aCmpTot[4,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpTot[4,10] READONLY ; nPL += nSalta
@ nLin+nPL-0,02*nCol+nLargura*(nCol-1)+05 SAY "Valor a Cobrar ou Desc." PIXEL OF oScroll FONT oFontG COLOR aCmpTot[5,10]
@ nLin+nPL-2,(02+nLargura)*nCol-75 MSGET aCmpTot[5,5] VAR M->ZA_VALLIQ  SIZE aCmpTot[5,7][1] ,aCmpTot[5,7][2] VALID u_TMS03Valid() OF oScroll PIXEL FONT oFontG COLOR aCmpTot[5,10] READONLY ; nPL += nSalta

aEval( aCmpTot , {|x| If(!Empty(x[8]).And.Len(x[9])<2,x[5]:cF3:=x[8],), If(!Empty(x[6]).And.Len(x[9])<2,x[5]:Picture:=x[6],) } )

ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg, {|| nOpcA := If( nOpc==2.Or.nOpc==5.Or.Obrigatorio(aGets,aTela).And.TMS03TudOk(nOpc) ,1,0),;
													If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} ), LoadCampos(nOpc), Recalcula())
	
If nOpc > 2   // Se não for visualizar
	If nOpca == 1
		If nOpc == 3
			ConfirmSX8()
		Endif
		Begin Transaction
		TMS03Grava(nOpc,nRecNo,aAltera)
		End Transaction
		
		If nOpc >= 7
			FWMsgRun(Nil, {|oSay| MontaEmail() }, "Aguarde...",  "Enviando e-mail de " + If( nOpc == 7 , "encerramento", "cancelamento") )
		Endif
		
		If nOpc == 5
			Mensagem(2,"Exclusão da Operação <strong>"+SZA->ZA_COD+"</strong> concluída com sucesso !")
		ElseIf nOpc == 8
			Mensagem(2,"Cancelamento do Encerramento gravado com sucesso !")
		ElseIf nOpc == 3 .Or. nOpc > 5
			If M->ZA_TIPO == "C"
				Mensagem(2,"Carregamento da Operação <strong>"+SZA->ZA_COD+"</strong> gravado com sucesso !")
			ElseIf M->ZA_TIPO == "D"
				Mensagem(2,"Descarregamento da Operação <strong>"+SZA->ZA_COD+"</strong> gravado com sucesso !")
			ElseIf M->ZA_TIPO == "E"
				Mensagem(2,"Operação <strong>"+SZA->ZA_COD+"</strong> encerrada com sucesso !")
			Endif
		Endif
	ElseIf nOpc == 3
		RollBackSX8()
	Endif
Endif

Return

Static Function AtribuiCabec(aCampos,nLargura,nOpc)
	Local nCnt := 0
	
	aEval( aCampos , {|x|;
						x[1] := nCnt + 5,;
						nCnt += nLargura / Len(aCampos),;
						x[4] := If( nOpc == 3 , CriaVar(x[2],.F.), M->&(x[2])),;
						x[3] := GetSx3Cache(x[2], 'X3_TITULO'),;
						x[6] := Trim(GetSx3Cache(x[2], 'X3_PICTURE')),;
						M->&(x[2]) := x[4],;
						x[8] := Trim(GetSx3Cache(x[2], 'X3_F3')),;
						x[9] := Separa(GetSX3Cache(x[2], "X3_CBOX"),";") } )
Return

Static Function LoadCampos(nOpc)
	Local nX, nPos
	
	LoadTpoCar()
	
	// Define os campos obrigatórios a serem validados
	InitGetTela(aCmpCb1)
	InitGetTela(aCmpCb2)
	InitGetTela(aCmpDta)
	InitGetTela(aCmpTot)
	
	If nOpc == 3      // Inclusão Carregamento
		Return
	ElseIf nOpc == 6  // Inclusão Descarregamento
		// Caso esteja vazio o array de Descarregamento
		If Len(oGetDes:aCols) < 2 .And. Empty(oGetDes:aCols[oGetDes:nAt,nPCDTqe])
			LoadTanques(@oGetDes)
			oGetDes:Refresh()
			aCDesca := aClone(oGetDes:aCols)
		Endif
		
		// Inicaliza o array da apuração do descarregamento
		aSize( oGetApD:aCols , 0 )
		For nX:=1 To Len(oGetDes:aCols)
			nPos := aColsBlank(oGetApD:aCols,aHApura)
			oGetApD:aCols[nPos,nPApTqe] := oGetDes:aCols[nX,nPCDTqe]
		Next
		oGetApD:Refresh()
		aCApDes := aClone(oGetApD:aCols)
	Endif
	
	// Carrega as diferenças entre o carregamento e o descarregamento
	For nX:=1 To Len(aCCarga)
		M->ZB_REF := If( M->ZA_TIPO == "C" , aCCarga[nX,nPCDRef], aCDesca[nX,nPCDRef])
		M->ZB_MED := If( M->ZA_TIPO == "C" , aCCarga[nX,nPCDMed], aCDesca[nX,nPCDMed])
		M->ZB_VOL := If( M->ZA_TIPO == "C" , aCCarga[nX,nPCDVol], aCDesca[nX,nPCDVol])
		CalcDiferencas(oGetRef:aCols,"M->ZB_REF",aCCarga[nX,nPCDTqe])
		CalcDiferencas(oGetAlt:aCols,"M->ZB_MED",aCCarga[nX,nPCDTqe])
		CalcDiferencas(oGetAmb:aCols,"M->ZB_VOL",aCCarga[nX,nPCDTqe])
	Next
	
	cB1_DESC := Trim(Posicione("SB1",1,XFILIAL("SB1")+M->ZA_TPPROD,"B1_DESC"))
	oB1_DESC:Refresh()
	
	DA3->(dbSetOrder(1))
	DA3->(dbSeek(XFILIAL("DA3")+M->ZA_EMPURRA))
	
	cDA3_EDESC := Trim(DA3->DA3_DESC)
	oDA3_EDESC:Refresh()
	
	DA3->(dbSetOrder(1))
	DA3->(dbSeek(XFILIAL("DA3")+M->ZA_BALSA))
	
	M->DA3_VOLMAX := DA3->DA3_VOLMAX
	M->DA3_XFATEX := DA3->DA3_XFATEX
	
	cDA3_BDESC := Trim(DA3->DA3_DESC)
	oDA3_BDESC:Refresh()
	
	SZ1->(dbSetOrder(1))
	SZ1->(dbSeek(XFILIAL("SZ1")+M->ZA_PTEMB))
	
	cZ1_PEDESC := Trim(SZ1->Z1_PORTO)
	oZ1_PEDESC:Refresh()
	
	cOrigem := Trim(SZ1->Z1_MUN)
	oOrigem:Refresh()
	
	SZ1->(dbSetOrder(1))
	SZ1->(dbSeek(XFILIAL("SZ1")+M->ZA_PTDES))
	
	cZ1_PDDESC := Trim(SZ1->Z1_PORTO)
	oZ1_PDDESC:Refresh()
	
	cDestino := Trim(SZ1->Z1_MUN)
	oDestino:Refresh()

Return

Static Function LoadTpoCar()
	Local nPos := AScan( aCmpCb1[5,9] , {|x| PADR(x,1) == M->ZA_TIPO } )
	
	If nPos > 0
		cComboT := NomeCombo(aCmpCb1[5,9],M->ZA_TIPO,.F.)
		aCmpCb1[5,5]:nAt := nPos
		aCmpCb1[5,5]:Refresh()
	Endif

Return

Static Function InitGetTela(aCampos)
	Local nX, lObrigat, cLinPos, lBitMap, LVar03
	Local cC       := ""
	Local lMemoria := .F.
	Local nLinha   := 0
	Local cNewFold := " "
	
	For nX:=1 To Len(aCampos)
		SX3->(dbSetOrder(2))
		If SX3->(dbSeek(aCampos[nX,2]))
			lObrigat := (aCampos[nX,10] == CLR_HBLUE) //VerByte(SX3->X3_RESERV,7) .or. (SubStr(Bin2Str(SX3->X3_OBRIGAT),1,1) == "x")
			
			If ("BITMAP" $ SX3->X3_CAMPO)
				lBitMap := .T.
			Else
				lBitMap := .F.
			EndIf
			
			cC := "M->"+Trim(SX3->X3_CAMPO)
			
			If lBitMap
				LVar03 := OemToAnsi("Imagem")
			Else
				LVar03 := If(SX3->X3_TIPO == "M","Memo",If(SX3->X3_CONTEXT == "V" .and. !lMemoria,CriaVar(SX3->X3_CAMPO),&cC))
			EndIf
			
			nLinha++
			cLinPos := RetAsc(StrZero(nLinha),2,.T.)
			
			Aadd(aTELA,{X3Titulo(),Transform(LVar03,Trim(SX3->X3_PICTURE))," "," ",cNewFold+cLinPos})
			Aadd(aGETS,cLinPos+"1"+SX3->X3_ARQUIVO+SX3->X3_ORDEM+SX3->X3_CAMPO+SX3->X3_F3+Iif(lObrigat,"T","F")+SX3->X3_TIPO+cNewFold)
		Endif
	Next
	
Return

Static Function NomeCombo(aCombo,cConteudo,lLimpa)
	Local nPos := AScan( aCombo , {|x| PADR(x,1) == cConteudo } )
Return If( nPos > 0 , If( lLimpa , StrTran(aCombo[nPos],cConteudo+"=",""), aCombo[nPos]), " ")

Static Function MontaCarga(lLimpa)
	Local nX
	
	Default lLimpa := .F.
	
	If lLimpa
		aSize( aCApCar , 0 )
		aSize( aCDfAlt , 0 )
		aSize( aCDfRef , 0 )
		aSize( aCDfAmb , 0 )
	Endif
	
	If Len(aCApCar) < 1 .Or. Len(aCApCar) == 1 .And. Empty(aCApCar[1,nPApTqe])
		For nX:=1 To Len(aCCarga)
			// Inicaliza o array da apuração do carregamento
			nPos := aColsBlank(aCApCar,aHApura)
			aCApCar[nPos,nPApTqe] := aCCarga[nX,nPCDTqe]
		Next
	Endif
	
	If Len(aCApDes) < 1 .Or. Len(aCApDes) == 1 .And. Empty(aCApDes[1,nPApTqe])
		For nX:=1 To Len(aCDesca)
			// Inicaliza o array da apuração do descarregamento
			nPos := aColsBlank(aCApDes,aHApura)
			aCApDes[nPos,nPApTqe] := aCDesca[nX,nPCDTqe]
		Next
	Endif
	
	For nX:=1 To Len(aCCarga) Step 2
		// Monta o cálculo da Diferença das alturas
		nPos := aColsBlank(aCDfAlt,aHDifer)
		aCDfAlt[nPos,nPDfTqB] := aCCarga[nX,nPCDTqe]
		aCDfAlt[nPos,nPDfVoB] := If( nX <= Len(aCDesca) , aCDesca[nX,nPCDMed] - aCCarga[nX,nPCDMed], 0)
		aCDfAlt[nPos,nPDfTqE] := aCCarga[nX+1,nPCDTqe]
		aCDfAlt[nPos,nPDfVoE] := If( (nX+1) <= Len(aCDesca) , aCDesca[nX+1,nPCDMed] - aCCarga[nX+1,nPCDMed], 0)
		
		// Monta o cálculo da Diferença das Referências
		nPos := aColsBlank(aCDfRef,aHDifer)
		aCDfRef[nPos,nPDfTqB] := aCCarga[nX,nPCDTqe]
		aCDfRef[nPos,nPDfVoB] := If( nX <= Len(aCDesca) , aCDesca[nX,nPCDRef] - aCCarga[nX,nPCDRef], 0)
		aCDfRef[nPos,nPDfTqE] := aCCarga[nX+1,nPCDTqe]
		aCDfRef[nPos,nPDfVoE] := If( (nX+1) <= Len(aCDesca) , aCDesca[nX+1,nPCDRef] - aCCarga[nX+1,nPCDRef], 0)
		
		// Monta o cálculo da Diferença dos Volumes
		nPos := aColsBlank(aCDfAmb,aHDfAmb)
		aCDfAmb[nPos,nPAmTqB] := aCCarga[nX,nPCDTqe]
		aCDfAmb[nPos,nPAmVoB] := If( nX <= Len(aCDesca) , aCDesca[nX,nPCDVol] - aCCarga[nX,nPCDVol], 0)
		aCDfAmb[nPos,nPAmTqE] := aCCarga[nX+1,nPCDTqe]
		aCDfAmb[nPos,nPAmVoE] := If( (nX+1) <= Len(aCDesca) , aCDesca[nX+1,nPCDVol] - aCCarga[nX+1,nPCDVol], 0)
	Next
	
	If lLimpa
		oGetApC:aCols := aClone(aCApCar)
		oGetApD:aCols := aClone(aCApDes)
		oGetAlt:aCols := aClone(aCDfAlt)
		oGetRef:aCols := aClone(aCDfRef)
		oGetAmb:aCols := aClone(aCDfAmb)
		
		oGetApC:Refresh()
		oGetApD:Refresh()
		oGetAlt:Refresh()
		oGetRef:Refresh()
		oGetAmb:Refresh()
	Endif

Return
Static Function Recalcula(nLinha,lFinal)
	
	Default nLinha := 0
	Default lFinal := .F.
	
	If !lFinal   // Caso não seja totalizador final
		If nLinha == 0
			aEval( oGetApC:aCols , {|x| nLinha++, CalcApura(@oGetCar,@oGetApC,nLinha) } )
			nLinha := 0
			aEval( oGetApD:aCols , {|x| nLinha++, CalcApura(@oGetDes,@oGetApD,nLinha) } )
		Endif
		
		M->ZA_BDAMBC := 0
		aEval( oGetCar:aCols , {|x| M->ZA_BDAMBC += x[nPCDVol] } )
		
		M->ZA_BDAMBD := 0
		aEval( oGetDes:aCols , {|x| M->ZA_BDAMBD += x[nPCDVol] } )
		
		M->ZA_BANBOMC := 0
		M->ZA_BANBORC := 0
		M->ZA_TRIPROC := 0
		M->ZA_TRIPOPC := 0
		M->ZA_BD20C   := 0
		aEval( oGetApC:aCols , {|x| M->ZA_BD20C += x[nPApVol],;
									If( "BB" $ x[nPApTqe] , M->ZA_BANBOMC += x[nPApPes], M->ZA_BANBORC += x[nPApPes]),;
									If( PADR(x[nPApTqe],1) < "3" , M->ZA_TRIPROC += x[nPApPes], M->ZA_TRIPOPC += x[nPApPes]) } )
		
		M->ZA_BANBOMD := 0
		M->ZA_BANBORD := 0
		M->ZA_TRIPROD := 0
		M->ZA_TRIPOPD := 0
		M->ZA_BD20D   := 0
		aEval( oGetApD:aCols , {|x| M->ZA_BD20D += x[nPApVol],;
									If( "BB" $ x[nPApTqe] , M->ZA_BANBOMD += x[nPApPes], M->ZA_BANBORD += x[nPApPes]),;
									If( PADR(x[nPApTqe],1) < "3" , M->ZA_TRIPROD += x[nPApPes], M->ZA_TRIPOPD += x[nPApPes]) } )
		
		nDifDens := 0
		aEval( oGetApD:aCols , {|x| nDifDens += x[nPApDen] } )
		aEval( oGetApC:aCols , {|x| nDifDens -= x[nPApDen] } )
		
		nTotAmb  := 0
		aEval( oGetAmb:aCols , {|x| nTotAmb  += x[nPAmVoB] + x[nPAmVoE] } )
	Endif
	
	M->ZA_QTDABS  := M->ZA_VOL20TC * Posicione("SZ1",1,XFILIAL("SZ1")+M->ZA_PTDES,"Z1_TXABS")
	
	M->ZA_FATCARG := If( M->ZA_VOL20TC <> 0 , M->ZA_BD20C - M->ZA_VOL20TC, 0)
	M->ZA_FATDESC := If( M->ZA_VOL20TC <> 0 , M->ZA_BD20D - M->ZA_VOL20TD, 0)
	
	M->ZA_PERCC := M->ZA_FATCARG / M->ZA_VOL20TC
	M->ZA_PERCD := M->ZA_FATDESC / M->ZA_VOL20TD
	
	M->ZA_TPERSOB := M->ZA_VOL20TD - M->ZA_VOL20TC
	M->ZA_QTDCOB  := M->ZA_TPERSOB + M->ZA_QTDABS
	
	M->ZA_CALMEDC := (M->ZA_CALREC + M->ZA_CALMNAC + M->ZA_CALVANC) / 3
	M->ZA_CALMEDD := (M->ZA_CALRED + M->ZA_CALMNAD + M->ZA_CALVAND) / 3
	
	M->ZA_TXTRAN := M->ZA_DTCHDES - M->ZA_DTSAICA + (HorToNum(M->ZA_HRCHDES) - HorToNum(M->ZA_HRSAICA)) / 24
	M->ZA_TXSOB  := M->ZA_DTFIMDE - M->ZA_DTINIDE + (HorToNum(M->ZA_HRFIMDE) - HorToNum(M->ZA_HRINIDE)) / 24
	M->ZA_TXTRAN := Max(M->ZA_TXTRAN,0)
	M->ZA_TXSOB  := Max(M->ZA_TXSOB ,0)
	
	M->ZA_VALTRAN := M->DA3_VOLMAX * M->ZA_TXTRAN * nTxTran
	M->ZA_VPERSOB := -M->ZA_VALNF  * M->ZA_QTDCOB
	M->ZA_VALSOB  := M->DA3_VOLMAX * M->ZA_TXSOB  * nTxSobr
	M->ZA_VALLIQ  := M->ZA_VALSOB  - M->ZA_VALTRAN - M->ZA_VPERSOB
	
	If !lFinal
		RefreshAll()
	Endif

Return

Static Function HorToNum(cHora)
	Local nHora := Val(StrTran(cHora,":","")) / 100
	Local nMinu := nHora - Int(nHora)
	
	nHora -= nMinu
	nMinu := nMinu * 100 / 60

Return nHora + nMinu

Static Function RefreshAll()
	aCmpCb1[1,5]:Refresh()
	aCmpCb1[2,5]:Refresh()
	aCmpCb1[3,5]:Refresh()
	aCmpCb1[4,5]:Refresh()
	aCmpCb1[5,5]:Refresh()
	aCmpCb1[6,5]:Refresh()
	aCmpCb1[7,5]:Refresh()
	
	aCmpCb2[1,5]:Refresh()
	aCmpCb2[2,5]:Refresh()
	aCmpCb2[3,5]:Refresh()
	aCmpCb2[4,5]:Refresh()
	aCmpCb2[5,5]:Refresh()
	aCmpCb2[6,5]:Refresh()
	aCmpCb2[7,5]:Refresh()
	
	aCmpDta[1,5]:Refresh()
	aCmpDta[2,5]:Refresh()
	aCmpDta[3,5]:Refresh()
	aCmpDta[4,5]:Refresh()
	aCmpDta[5,5]:Refresh()
	aCmpDta[6,5]:Refresh()
	aCmpDta[7,5]:Refresh()
	aCmpDta[8,5]:Refresh()
	
	aCmpTot[1,5]:Refresh()
	aCmpTot[2,5]:Refresh()
	aCmpTot[3,5]:Refresh()
	aCmpTot[4,5]:Refresh()
	aCmpTot[5,5]:Refresh()
	
	oGetCar:Refresh()
	oGetDes:Refresh()
	oGetApC:Refresh()
	oGetApD:Refresh()
	
	oBorAmbO:Refresh()
	oBor20gO:Refresh()
	oVol20gO:Refresh()
	oPercenO:Refresh()
	oQtdAbso:Refresh()

	oBanBomO:Refresh()
	oBanBorO:Refresh()
	oTriProO:Refresh()
	oTriPopO:Refresh()
	
	oBorAmbD:Refresh()
	oBor20gD:Refresh()
	oVol20gD:Refresh()
	oPercenD:Refresh()
	oQtdCobr:Refresh()
	
	oBanBomD:Refresh()
	oBanBorD:Refresh()
	oTriProD:Refresh()
	oTriPopD:Refresh()
	
	oGetAlt:Refresh()
	oDifDens:Refresh()
	
	oGetRef:Refresh()
	oDiasExc:Refresh()
	oSobrest:Refresh()
	
	oAtracO:Refresh()
	oMedicO:Refresh()
	oIniOpO:Refresh()
	oLiberO:Refresh()
	oFimOpO:Refresh()
	oTempoO:Refresh()
	oCalReO:Refresh()
	oCalMNO:Refresh()
	oCalVaO:Refresh()
	oCalMeO:Refresh()
	
	oAtracD:Refresh()
	oMedicD:Refresh()
	oIniOpD:Refresh()
	oLiberD:Refresh()
	oFimOpD:Refresh()
	oTempoD:Refresh()
	oCalReD:Refresh()
	oCalMND:Refresh()
	oCalVaD:Refresh()
	oCalMeD:Refresh()
	
	oGetAmb:Refresh()
	oTotAmb:Refresh()
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ELTMS03Leg ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Legenda da lista                                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ELTMS03Legen( cAlias, nRecNo, nOpc )
	BRWLEGENDA(cCadastro,"Legenda - Carregamento / Descarregamento",;
							{{"ENABLE"   ,"Carregamento Parcial"  },;
							{"BR_AZUL"   ,"Carregamento Total" },;
							{"BR_AMARELO","Descarregamento Parcial"},;
							{"BR_PINK"   ,"Descarregamento Total" },;
							{"DISABLE"   ,"Encerrado"}})
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TMS03DelIt ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TMS03DelIt()
	Local x
	Local lRet := .T.
	Local nDel := Len(aCols[1])
	
	If nPD == 2 //.And. aCols[n,nDel] // Na delecao da linha - 2a. passagem
	ElseIf nPD == 1
		If aCols[n,nDel] // Na recuperacao da linha - 1a. passagem
			For x:=1 To Len(aCols)
				If aCols[x,1] == aCols[n,1] .And. x <> n .And. !aCols[x,nDel]
					If lRet := ExistChav("SX5","01")
						Exit
					Endif
				Endif
			Next
		Endif
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TMS03Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida os campos do Carregamento / Descarregamento            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TMS03Valid(nObj)
	Local nX
	Local cVar := Trim(Upper(ReadVar()))
	Local nInd := If( "ZB_" $ cVar , If( M->ZA_TIPO == "C" , If( nObj == 1 , oGetCar:nAt, oGetApC:nAt), If( nObj == 1 , oGetDes:nAt, oGetApD:nAt)), 0)
	Local nPos := AScan( aVlrAnt , {|x| x[1] == cVar .And. x[2] == nInd } )
	Local xVlr := &( cVar )
	Local lRet := .T.
	
	If nPos == 0 .Or. aVlrAnt[nPos,3] <> xVlr   // Caso tenha sido digitado um conteúdo diferente
		If Vazio() .And. nPos == 0
			Return lRet
		Endif
		
		If ValType( xVlr ) == "N"
			If !Positivo()
				Return .F.
			Endif
		Endif
	Else
		Return lRet
	Endif
		
	If cVar == "M->ZA_TPPROD"
		If lRet := ExistCpo("SB1")
			cB1_DESC := Trim(Posicione("SB1",1,XFILIAL("SB1")+M->ZA_TPPROD,"B1_DESC"))
			oB1_DESC:Refresh()
		Endif
	ElseIf cVar == "M->ZA_VIAGEM"
		If lRet := ExistCpo("DTR",cFilAnt+M->ZA_VIAGEM+M->ZA_EMPURRA,3) .And. ExistChav("SZA",M->ZA_VIAGEM,2)    // DTR_FILIAL+DTR_FILORI+DTR_VIAGEM+DTR_CODVEI
			DTQ->(dbSetOrder(1))    // DTQ_FILIAL+DTQ_VIAGEM
			If lRet := DTQ->(dbSeek(XFILIAL("DTQ")+M->ZA_VIAGEM)) .And. DTQ->DTQ_STATUS == "1"
			Else
				Mensagem(1,"Viagem não existe ou já está encerrada !")
			Endif
		Endif
	ElseIf cVar == "M->ZA_BALSA"
		If lRet := ExistCpo("DA3")
			DA3->(dbSetOrder(1))
			If lRet := DA3->(dbSeek(XFILIAL("DA3")+M->ZA_BALSA)) .And. DA3->DA3_TIPVEI == "02"
				If lRet := (DA3->DA3_VOLMAX > 0)
					M->DA3_VOLMAX := DA3->DA3_VOLMAX
					M->DA3_XFATEX := DA3->DA3_XFATEX
					
					cDA3_BDESC := Trim(DA3->DA3_DESC)
					oDA3_BDESC:Refresh()
					
					LoadTanques(@oGetCar)
					
					oGetCar:Refresh()
					aCCarga := aClone(oGetCar:aCols)
					
					MontaCarga(.T.)
				Else
					Mensagem(1,"É necessário informar o <strong>VOLUME MÁXIMO</strong> para essa Balsa !")
				Endif
			Else
				Mensagem(1,"Codigo de Balsa informado não é válido !")
			Endif
		Endif
	ElseIf cVar == "M->ZA_EMPURRA"
		If lRet := ExistCpo("DA3")
			DA3->(dbSetOrder(1))
			If lRet := DA3->(dbSeek(XFILIAL("DA3")+M->ZA_EMPURRA)) .And. DA3->DA3_TIPVEI == "01"
				cDA3_EDESC := Trim(DA3->DA3_DESC)
				oDA3_EDESC:Refresh()
			Else
				Mensagem(1,"Codigo de Empurrador informado não é válido !")
			Endif
		Endif
	ElseIf cVar == "M->ZA_PTEMB"
		If lRet := ExistCpo("SZ1")
			SZ1->(dbSetOrder(1))
			SZ1->(dbSeek(XFILIAL("SZ1")+M->ZA_PTEMB))
			
			cZ1_PEDESC := Trim(SZ1->Z1_PORTO)
			oZ1_PEDESC:Refresh()
			
			cOrigem := Trim(SZ1->Z1_MUN)
			oOrigem:Refresh()
		Endif
	ElseIf cVar == "M->ZA_PTDES"
		If lRet := ExistCpo("SZ1")
			SZ1->(dbSetOrder(1))
			SZ1->(dbSeek(XFILIAL("SZ1")+M->ZA_PTDES))
			
			cZ1_PDDESC := Trim(SZ1->Z1_PORTO)
			oZ1_PDDESC:Refresh()
			
			cDestino := Trim(SZ1->Z1_MUN)
			oDestino:Refresh()
		Endif
	ElseIf cVar $ "M->ZA_DTSAICA,M->ZA_HRSAICA"
		If lRet := (cVar == "M->ZA_DTSAICA" .Or. HoraOk(M->ZA_HRSAICA))
			M->ZA_DTCHDES := CriaVar("ZA_DTCHDES",.F.)
			M->ZA_HRCHDES := CriaVar("ZA_HRCHDES",.F.)
			M->ZA_DTINIDE := CriaVar("ZA_DTINIDE",.F.)
			M->ZA_HRINIDE := CriaVar("ZA_HRINIDE",.F.)
			M->ZA_DTFIMDE := CriaVar("ZA_DTFIMDE",.F.)
			M->ZA_HRFIMDE := CriaVar("ZA_HRFIMDE",.F.)
		Endif
	ElseIf cVar $ "M->ZA_DTCHDES,M->ZA_HRCHDES"
		If lRet := (cVar == "M->ZA_DTCHDES" .Or. HoraOk(M->ZA_HRCHDES))
			If lRet := ( DtoS(M->ZA_DTCHDES)+RetHora(M->ZA_HRCHDES) > DtoS(M->ZA_DTSAICA)+RetHora(M->ZA_HRSAICA) )
			Else
				Mensagem(1,"Dados da Chegada não pode ser menor ou igual aos dados da Saída !")
			Endif
		Endif
	ElseIf cVar $ "M->ZA_DTINIDE,M->ZA_HRINIDE"
		If lRet := (cVar == "M->ZA_DTINIDE" .Or. HoraOk(M->ZA_HRINIDE))
			If lRet := ( DtoS(M->ZA_DTINIDE)+RetHora(M->ZA_HRINIDE) > DtoS(M->ZA_DTCHDES)+RetHora(M->ZA_HRCHDES) )
			Else
				Mensagem(1,"Dados do Início da viagem não pode ser menor ou igual aos dados do fim do carregamento !")
			Endif
		Endif
	ElseIf cVar $ "M->ZA_DTFIMDE,M->ZA_HRFIMDE"
		If lRet := (cVar == "M->ZA_DTFIMDE" .Or. HoraOk(M->ZA_HRFIMDE))
			If lRet := ( DtoS(M->ZA_DTFIMDE)+RetHora(M->ZA_HRFIMDE) > DtoS(M->ZA_DTINIDE)+RetHora(M->ZA_HRINIDE) )
			Else
				Mensagem(1,"Dados do Fim da viagem não pode ser menor ou igual aos dados do início da viagem !")
			Endif
		Endif
	ElseIf cVar == "M->ZB_REF"
		CalcDiferencas(oGetRef:aCols,cVar)
	ElseIf cVar == "M->ZB_MED"
		If lRet := AlturaOK(M->ZB_MED)
			If M->ZA_TIPO == "C"
				oGetCar:aCols[oGetCar:nAt,nPCDVol] := M->ZB_VOL := If( PADR(oGetCar:aCols[oGetCar:nAt,nPCDTqe],1) $ "14" , SZ9->Z9_VOLUME1, SZ9->Z9_VOLUME2)
				CalcDiferencas(oGetAmb:aCols,"M->ZB_VOL",oGetCar:aCols[oGetCar:nAt,nPCDTqe])
				CalcApura(@oGetCar,@oGetApC,oGetCar:nAt)
			Else
				oGetDes:aCols[oGetDes:nAt,nPCDVol] := M->ZB_VOL := If( PADR(oGetDes:aCols[oGetDes:nAt,nPCDTqe],1) $ "14" , SZ9->Z9_VOLUME1, SZ9->Z9_VOLUME2)
				CalcDiferencas(oGetAmb:aCols,"M->ZB_VOL",oGetDes:aCols[oGetDes:nAt,nPCDTqe])
				CalcApura(@oGetDes,@oGetApD,oGetDes:nAt)
			Endif
			CalcDiferencas(oGetAlt:aCols,cVar)
		Endif
	ElseIf cVar == "M->ZB_VOL"
		CalcDiferencas(oGetAmb:aCols,cVar)
	ElseIf cVar == "M->ZB_DENSAMO"
		If M->ZA_TIPO == "C"       // Carga
			oGetApC:aCols[oGetApC:nAt,nPApDsA] := M->ZB_DENSAMO
			CalcApura(@oGetCar,@oGetApC,oGetApC:nAt)
		Else
			oGetApD:aCols[oGetApD:nAt,nPApDsA] := M->ZB_DENSAMO
			CalcApura(@oGetDes,@oGetApD,oGetApD:nAt)
		Endif
	ElseIf cVar == "M->ZB_TEMPAMO"
		If M->ZA_TIPO == "C"       // Carga
			oGetApC:aCols[oGetApC:nAt,nPApTmA] := M->ZB_TEMPAMO
			CalcApura(@oGetCar,@oGetApC,oGetApC:nAt)
		Else
			oGetApD:aCols[oGetApD:nAt,nPApTmA] := M->ZB_TEMPAMO
			CalcApura(@oGetDes,@oGetApD,oGetApD:nAt)
		Endif
	ElseIf cVar $ "M->ZA_ATRACAC,M->ZA_HORMEDC,M->ZA_INIOPEC,M->ZA_LIBERAC,M->ZA_FIMOPEC,M->ZA_TEMOPEC,M->ZA_ATRACAD,M->ZA_HORMEDD,M->ZA_INIOPED,M->ZA_LIBERAD,M->ZA_FIMOPED,M->ZA_TEMOPED"
		If lRet := HoraOk(xVlr)
			If cVar $ "M->ZA_INIOPEC,M->ZA_FIMOPEC" .And. Val(M->ZA_INIOPEC) > 0 .And. Val(M->ZA_FIMOPEC) > 0
				M->ZA_TEMOPEC := PADL(LTrim(cValToChar(SubHoras(Val(M->ZA_FIMOPEC)/100,Val(M->ZA_INIOPEC)/100) * 100)),Len(M->ZA_INIOPEC),"0")
			ElseIf cVar $ "M->ZA_INIOPED,M->ZA_FIMOPED" .And. Val(M->ZA_INIOPED) > 0 .And. Val(M->ZA_FIMOPED) > 0
				M->ZA_TEMOPED := PADL(LTrim(cValToChar(SubHoras(Val(M->ZA_FIMOPED)/100,Val(M->ZA_INIOPED)/100) * 100)),Len(M->ZA_INIOPED),"0")
			Endif
		Endif
	Endif
	
	If lRet
		nX := AScan( aHCarga , {|x| Trim(x[2]) == StrTran(cVar,"M->","") } )
		If nX > 0
			If M->ZA_TIPO == "C"       // Carga
				oGetCar:aCols[oGetCar:nAt,nX] := xVlr
			ElseIf M->ZA_TIPO == "D"   // Descarga
				oGetDes:aCols[oGetDes:nAt,nX] := xVlr
			Endif
		Endif
		
		Recalcula(1)
		
		If nPos == 0
			AAdd( aVlrAnt , { cVar, nInd, Nil})
			nPos := Len(aVlrAnt)
		Endif
		aVlrAnt[nPos,3] := xVlr
	Endif
	
Return lRet

Static Function CalcApura(oDados,oApura,nLApu)
	Local aCalc := Conv20graus(oDados:aCols[nLApu,nPCDVol],oApura:aCols[nLApu,nPApDsA],oApura:aCols[nLApu,nPApTmA],oDados:aCols[nLApu,nPCDTmp])
	oApura:aCols[nLApu,nPApDen] := aCalc[1]
	oApura:aCols[nLApu,nPApFat] := aCalc[2]
	oApura:aCols[nLApu,nPApVol] := aCalc[3]
	oApura:aCols[nLApu,nPApPes] := aCalc[3] * aCalc[1]
Return

Static Function RetHora(cHora)
Return If( Empty(cHora) , "9999", Trim(cHora))

Static Function HoraOk(cHora)
	Local lRet := !( Val(Left(cHora,2)) > 23 .Or. Val(Right(cHora,2)) > 59 )
	If !lRet
		Mensagem(1,"Hora informada não é válida !")
	Endif
Return lRet

Static Function LoadTanques(oTanque)
	Local nX
	Local nTanques := If( DA3->(FieldPos("DA3_XQTDTQ")) == 0 .Or. DA3->DA3_XQTDTQ < 4 , 4, DA3->DA3_XQTDTQ)
	
	aSize( oTanque:aCols , 0 )
	For nX:=1 To nTanques
		aColsBlank(oTanque:aCols,aHCarga)
		oTanque:aCols[nX*2-1,nPCDTqe] := Str(nX,1) + "BB"
		aColsBlank(oTanque:aCols,aHCarga)
		oTanque:aCols[nX*2-0,nPCDTqe] := Str(nX,1) + "BE"
	Next

Return

Static Function AlturaOK(nAltura)
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	Local cFld  := If( M->ZA_TIPO == "C" , "%SZ9.Z9_ALTURA1%", "%SZ9.Z9_ALTURA2%")
	Local lRet  := .T.
	
	BeginSQL Alias cTmp
		
		SELECT ISNULL(SZ9.R_E_C_N_O_,0) AS Z9_RECNO
		FROM %Table:SZ9% SZ9
		WHERE SZ9.%NotDel%
		AND SZ9.Z9_FILIAL = %xFilial:SZ9% 
		AND SZ9.Z9_BALSA = %Exp:M->ZA_BALSA%
		AND %Exp:cFld% = %Exp:nAltura%

	EndSQL
	
	If lRet := ((cTmp)->Z9_RECNO > 0)
		SZ9->(dbGoTo((cTmp)->Z9_RECNO))   // Posiciona no registro
	Else
		Mensagem(1,"Arqueamento não localizado para essa medição !")
	Endif
	
	(cTmp)->(dbCloseArea())
	RestArea(aArea)

Return lRet

Static Function CalcDiferencas(aCols,cVar,cTanque)
	Local nPos
	Local nCol := nPDfVoB
	
	Default cTanque := If( M->ZA_TIPO == "C" , oGetCar:aCols[oGetCar:nAt,nPCDTqe], oGetDes:aCols[oGetDes:nAt,nPCDTqe])
	
	// Pesquisa o tanque no array de Diferença de Referências na coluna de bombordo
	nPos := AScan( aCols , {|x| x[nPDfTqB] == cTanque } )   // Pesquisa o tanque
	
	If nPos == 0   // Caso não tenha encontrado
		// Pesquisa o tanque no array de Diferença de Referências na coluna de estibordo
		nPos := AScan( aCols , {|x| x[nPDfTqE] == cTanque } )
		nCol := nPDfVoE
	Endif
	
	If nPos > 0
		If M->ZA_TIPO == "C"    // Carregamento
			aCols[nPos,nCol] := PesqDescarrega(oGetDes,cTanque,cVar) - &( cVar )
		Else
			aCols[nPos,nCol] := &( cVar ) - PesqDescarrega(oGetCar,cTanque,cVar)
		Endif
	Endif

Return

Static Function PesqDescarrega(oObj,cTanque,cVar)
	Local nCol := AScan( oObj:aHeader , {|x| Trim(x[2]) == StrTran(cVar,"M->","") } )
	Local nPos := AScan( oObj:aCols , {|x| x[nPCDTqe] == cTanque } )
	Local nRet := 0
	
	If nPos > 0 .And. nCol > 0
		nRet := oObj:aCols[nPos,nCol]
	Endif

Return nRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TMS03LinOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TMS03LinOk(nPos)
	Local lRet := .T.
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TMS03TudOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TMS03TudOk(nOpc)
	Local lRet := .T.
	
	aCCarga := oGetCar:aCols
	aCDesca := oGetDes:aCols
	aCApCar := oGetApC:aCols
	aCApDes := oGetApD:aCols
	aCDfAlt := oGetAlt:aCols
	aCDfRef := oGetRef:aCols
	aCDfAmb := oGetAmb:aCols
	
	If nOpc == 7
		lRet := Mensagem(3,"Confirma o <strong>Encerramento</strong> da Operação <strong>" + M->ZA_COD + "</strong> ?")
	ElseIf nOpc == 8
		lRet := Mensagem(3,"Confirma o <strong>Cancelamento do Encerramento</strong> da Operação <strong>" + M->ZA_COD + "</strong> ?")
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TMS03Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados do Carregamento / Descarregamento              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
|¦¦           ¦ nRecNo   -> Numero do registro a ser gravado                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TMS03Grava(nOpc,nRecNo,aAltera)
	Local nX, nDel, aCols, aApur
	
	If M->ZA_TIPO == "C"
		// Caso na carga tenha algum valor não informado, então é carregamento parcial
		If AScan( aCCarga , {|x| Empty(x[nPCDRef]) .Or. Empty(x[nPCDMed]) .Or. Empty(x[nPCDTmp]) .Or. Empty(x[nPCDVol]) } ) > 0
			M->ZA_STATUS := "1"    // Carregamento Parcial
		ElseIf AScan( aCApCar , {|x| Empty(x[nPApDsA]) .Or. Empty(x[nPApTmA]) } ) > 0
			M->ZA_STATUS := "1"    // Carregamento Parcial
		Else
			M->ZA_STATUS := "2"    // Carregamento Total
		Endif
	ElseIf M->ZA_TIPO == "D"
		// Caso na carga tenha algum valor não informado, então é carregamento parcial
		If AScan( aCDesca , {|x| Empty(x[nPCDRef]) .Or. Empty(x[nPCDMed]) .Or. Empty(x[nPCDTmp]) .Or. Empty(x[nPCDVol]) } ) > 0
			M->ZA_STATUS := "3"    // Descarregamento Parcial
		ElseIf AScan( aCApDes , {|x| Empty(x[nPApDsA]) .Or. Empty(x[nPApTmA]) } ) > 0
			M->ZA_STATUS := "3"    // Descarregamento Parcial
		Else
			M->ZA_STATUS := "4"    // Descarregamento Total
		Endif
	ElseIf M->ZA_TIPO == "E"
		
		If nOpc == 8               // Caso seja um cancelamento
			M->ZA_TIPO := "D"      // Ajusta o status para Descarregamento Total
			
			// Limpa os dados da entrega final
			M->ZA_DTFIMDE := CriaVar("ZA_DTFIMDE",.F.)
			M->ZA_HRFIMDE := CriaVar("ZA_HRFIMDE",.F.)
			M->ZA_VALNF   := 0
			
			Recalcula(,.T.)   // Recalcula só os totais
		Endif
		
		M->ZA_STATUS := If( nOpc == 7 , "5", "4")    // Encerramento ou Descarregamento Total
	Endif
	
	//+-----------------
	//| Se for inclusão, alteracao ou Descarregamento
	//+-----------------
	If nOpc <> 5
		//+--------------------------------------
		//| Grava os dados referente ao CARREGAMENTO
		//+--------------------------------------
		dbSelectArea(cAlias1)
		If nRecNo > 0
			dbGoTo(nRecNo)
		Endif
		RecLock(cAlias1,nOpc==3)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,cFilSZA)
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		(cAlias1)->ZA_STATUS := M->ZA_STATUS
		MsUnLock()
		
		//+--------------------------------------
		//| Grava os dados referente aos ITENS DO CARREGAMENTO
		//+--------------------------------------
		nDel := Len(aHCarga) + 1
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		
		If nOpc < 7   // Nas opções relacionadas ao Encerramento não precisa regravar os dados dos Tanques
			aCols := If( (cAlias1)->ZA_TIPO == "C" , aCCarga, aCDesca)
			aApur := If( (cAlias1)->ZA_TIPO == "C" , aCApCar, aCApDes)
			
			For nX := 1 To Len(aCols)
				If !aCols[nX][nDel] .And. !Empty(aCols[nX][nPCDTqe])
					// Pesquisa o registro do Tanque
					(cAlias2)->(dbSetOrder(1))   // ZB_FILIAL+ZB_COD+ZB_TIPO+ZB_BALSA+ZB_TANQUE
					If nOpc == 3 .Or. nOpc == 6 .Or. (cAlias2)->(dbSeek((cAlias1)->ZA_FILIAL+(cAlias1)->ZA_COD+(cAlias1)->ZA_TIPO+(cAlias1)->ZA_BALSA+aCols[nX][nPCDTqe]))
						GravaTanque(aCols[nX],aApur[nX],nOpc == 3 .Or. nOpc == 6)
					Endif
				Endif
			Next nX
		Endif
	Else
		//+--------------------------------------
		//| Exclui os dados referente ao CARREGAMENTO
		//+--------------------------------------
		dbSelectArea(cAlias1)
		dbGoTo(nRecNo)
		RecLock(cAlias1,.F.)
		dbDelete()
		MsUnLock()
		
		//+--------------------------------------
		//| Exclui os dados referente aos ITENS DO CARREGAMENTO
		//+--------------------------------------
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		For nX := 1 To Len(aCols)
			// Pesquisa o registro do Tanque
			(cAlias2)->(dbSetOrder(1))
			If (cAlias2)->(dbSeek((cAlias1)->ZA_FILIAL+(cAlias1)->ZA_COD+(cAlias1)->ZA_TIPO+aCols[nX][nPCDTqe]))
				RecLock(cAlias2,.F.)
				dbDelete()
				MsUnLock()
			Endif
		Next nX
		
	Endif
	
Return

Static Function GravaTanque(aTanque,aApura,lNovo)
	Local nY
	
	RecLock(cAlias2,lNovo)
	// Grava Carregamento / Descarregamento
	For nY := 1 To Len(aHCarga)
		FieldPut(FieldPos(Trim(aHCarga[nY,2])),aTanque[nY])
	Next nY
	
	(cAlias2)->ZB_FILIAL := (cAlias1)->ZA_FILIAL
	(cAlias2)->ZB_COD    := (cAlias1)->ZA_COD
	(cAlias2)->ZB_TIPO   := (cAlias1)->ZA_TIPO
	(cAlias2)->ZB_BALSA  := (cAlias1)->ZA_BALSA
	
	// Grava os dados da Apuração
	For nY := 1 To Len(aHApura)
		FieldPut(FieldPos(Trim(aHApura[nY,2])),aApura[nY])
	Next nY
	
	(cAlias2)->ZB_DIFAL  := RetDiferenca(aCDfAlt,(cAlias2)->ZB_TANQUE)   // Grava a diferença de altura do tanque
	(cAlias2)->ZB_DIFRE  := RetDiferenca(aCDfRef,(cAlias2)->ZB_TANQUE)   // Grava a diferença de referência do tanque
	(cAlias2)->ZB_DIFVOL := RetDiferenca(aCDfAmb,(cAlias2)->ZB_TANQUE)   // Grava a diferença do volume ambiente do tanque
	(cAlias2)->ZB_DIF    := (cAlias2)->ZB_DIFAL + (cAlias2)->ZB_DIFRE
	
	MsUnLock()

Return

Static Function RetDiferenca(aDifer,cTanque)
	Local nRet := 0
	Local nPos := AScan( aDifer , {|x| x[nPDfTqB] == cTanque } )
	
	If nPos > 0
		nRet := aDifer[nPos,nPDfVoB]
	Else
		nPos := AScan( aDifer , {|x| x[nPDfTqE] == cTanque } )
		If nPos > 0
			nRet := aDifer[nPos,nPDfVoE]
		Endif
	Endif

Return nRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	Local nPos
	
	nPCDTqe := u_ELAdicionaCampo("ZB_TANQUE",aHCarga)
	nPCDRef := u_ELAdicionaCampo("ZB_REF"   ,aHCarga)
	nPCDMed := u_ELAdicionaCampo("ZB_MED"   ,aHCarga)
	nPCDTmp := u_ELAdicionaCampo("ZB_TEMP"  ,aHCarga)
	nPCDVol := u_ELAdicionaCampo("ZB_VOL"   ,aHCarga)
	
	// Cria aHeader com os dados dos ITENS DO CARREGAMENTO / DESCARREGAMENTO
	aEval( aHCarga , {|x| x[6] := "u_TMS03Valid(1)" } )
	
	nPApTqe := u_ELAdicionaCampo("ZB_TANQUE" ,aHApura)
	nPApVol := u_ELAdicionaCampo("ZB_VOL20"  ,aHApura)
	nPApPes := u_ELAdicionaCampo("ZB_PESO"   ,aHApura)
	nPApDsA := u_ELAdicionaCampo("ZB_DENSAMO",aHApura)
	nPApTmA := u_ELAdicionaCampo("ZB_TEMPAMO",aHApura)
	nPApDen := u_ELAdicionaCampo("ZB_DENS20" ,aHApura)
	nPApFat := u_ELAdicionaCampo("ZB_FATOR"  ,aHApura)
	
	// Cria aHeader com os dados da APURAÇÃO dos ITENS DO CARREGAMENTO / DESCARREGAMENTO
	aEval( aHApura , {|x| x[6] := "u_TMS03Valid(2)" } )
	
	// Cria aHeader para as Diferenças entre CARREGAMENTO e DESCARREGAMENTO
	nPDfTqB := u_ELAdicionaCampo("ZB_TANQUE",aHDifer)
	aHDifer[nPDfTqB,1] := "Tq.Bombordo "
	nPDfVoB := u_ELAdicionaCampo("ZB_DIFAL" ,aHDifer)
	aHDifer[nPDfVoB,1] := "Dif.Bombordo"
	nPDfTqE := u_ELAdicionaCampo("ZB_TANQUE",aHDifer)
	aHDifer[nPDfTqE,1] := "Tq.Borest   "
	nPDfVoE := u_ELAdicionaCampo("ZB_DIFAL" ,aHDifer)
	aHDifer[nPDfVoE,1] := "Dif.Borest  "
	
	// Cria aHeader com os dados do Volume Ambiente DO CARREGAMENTO / DESCARREGAMENTO
	nPos := u_ELAdicionaCampo("ZB_TANQUE",aHDfAmb)
	aHDfAmb[nPos,1] := "Tq.Bombordo "
	nPos := u_ELAdicionaCampo("ZB_DIFVOL",aHDfAmb)
	aHDfAmb[nPos,1] := "Dif.Bombordo"
	nPos := u_ELAdicionaCampo("ZB_TANQUE",aHDfAmb)
	aHDfAmb[nPos,1] := "Tq.Borest   "
	nPos := u_ELAdicionaCampo("ZB_DIFVOL",aHDfAmb)
	aHDfAmb[nPos,1] := "Dif.Borest  "
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 20/02/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaEmail()
	Local cMsg
	Local cPara := GetMV("MV_XUSROPE",.F.,"")
	Local cMens := If( SZA->ZA_STATUS == "5" , "Operação Encerrada: ", "Encerramento cancelado: ") + SZA->ZA_COD
	Local cErro := ""
	Local lRet  := .F.
	
	// Posiciona na Viagem
	DTQ->(dbSetOrder(1))    // DTQ_FILIAL+DTQ_VIAGEM
	DTQ->(dbSeek(XFILIAL("DTQ")+SZA->ZA_VIAGEM))
	// Posiciona no Motoristas da Viagem
	DUP->(dbSetOrder(1))    // DUP_FILIAL+DUP_FILORI+DUP_VIAGEM+DUP_ITEDTR+DUP_CODMOT
	DUP->(dbSeek(XFILIAL("DUP")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
	// Posiciona no Cadastro de Motoristas
	DA4->(dbSetOrder(1))    // DA4_FILIAL+DA4_COD
	DA4->(dbSeek(XFILIAL("DA4")+DUP->DUP_CODMOT))
	// Posiciona no Movimento de Viagem
	DUD->(dbSetOrder(2))    // DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_SEQUEN+DUD_FILDOC+DUD_DOC+DUD_SERIE
	DUD->(dbSeek(XFILIAL("DUD")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
	// Posiciona nos Documentos de Transporte
	DT6->(dbSetOrder(1))    // DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	DT6->(dbSeek(XFILIAL("DT6")+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))
	// Posiciona no Cadastro do Cliente
	SA1->(dbSetOrder(1))    // A1_FILIAL+A1_COD+A1_LOJA
	SA1->(dbSeek(XFILIAL("SA1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV))
	// Posiciona no Cadastro de Rotas
	DA8->(dbSetOrder(1))    // DA8_FILIAL+DA8_COD
	DA8->(dbSeek(XFILIAL("DA8")+DTQ->DTQ_ROTA))
	
	cMsg := '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +cMens+ '</title>'
	cMsg += '</head>'
	cMsg += '<body> '
	cMsg += '<b>Data: </b>' +DtoC(SZA->ZA_DTOPER)+ '<br>'
	cMsg += '<b>Número da Viagem: </b>' +SZA->ZA_VIAGEM+ '<br>'
	cMsg += '<b>Rota: </b>' +Trim(DA8->DA8_DESC)+ '<br>'
	cMsg += '<b>Porto Carregamento: </b>' +Trim(Posicione("SZ1",1,XFILIAL("SZ1")+SZA->ZA_PTEMB,"Z1_PORTO"))+ '<br>'
	cMsg += '<b>Porto Descarregamento: </b>' +Trim(Posicione("SZ1",1,XFILIAL("SZ1")+SZA->ZA_PTDES,"Z1_PORTO"))+ '<br>'
	cMsg += '<b>Empurrador: </b>' +Trim(Posicione("DA3",1,XFILIAL("DA3")+SZA->ZA_EMPURRA,"DA3_DESC"))+ '<br>'
	cMsg += '<b>Balsa: </b>' +Trim(Posicione("DA3",1,XFILIAL("DA3")+SZA->ZA_BALSA,"DA3_DESC"))+ '<br>'
	cMsg += '<b>Capitão: </b>' +Trim(DA4->DA4_NOME)+ '<br>'
	cMsg += '<b>Cliente: </b>' +Trim(SA1->A1_NREDUZ)+ '<br>'
	cMsg += '<b>Produto: </b>'+ Trim(Posicione("SB1",1,XFILIAL("SB1")+SZA->ZA_TPPROD,"B1_DESC")) +'<br>'
	//cMsg += '<b>Operador: </b>'+cNFiscal+' / '+cSerie +'<br>'
	cMsg += '<b>Status: </b>Descarregamento finalizado<br>'
	
	cMsg += '<br>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	cPara := "roniltonob@gmail.com"   //UsrRetMail(cPara)
	
	lRet := u_ELSendMail(cPara,cMens,cMsg,/*aAnexos*/,@cErro,!IsBlind(),/*cCCo*/,,,/*cContaEma*/,/*cSenhaEma*/)
	
	If !Empty(cErro)
		Mensagem(1,"Ocorreu um erro no envio do e-mail: <br /><br /><strong>"+cErro+"</strong>")
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(aArray,aHeader)
	Local nX
	Local nUsado := Len(aHeader)
	Local nTam   := Len(aArray ) + 1
	
	AAdd( aArray , Array(nUsado+1) )
	
	For nX:=1 To nUsado
		aArray[nTam][nX] := CriaVar(aHeader[nX,2],.T.)
	Next
	
	aArray[nTam][nUsado+1] := .F.
	
Return nTam

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Conv20graus¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/02/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Conversão de combustível a 20 graus                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Conv20graus(nVolume,nDenCol,nTmpAmb,nTmpTnq)
	Local nTAB1A, nTAB1B, nTAB2A, nTAB2B, nP1, nP2, nP3,nP4, nP5, nP6, nP7
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	Local cQry  := ""
	Local nDens := 0
	Local nFat  := 0
	Local nVol  := 0
	
	If nDenCol > 0 .And. nTmpAmb > 0
		/*Consulta para trazer a linha na tabela padrão de conversão a 20° de acordo com a densidade da amostra coletada*/
		cQry := "SELECT *"
		cQry += " FROM " + RetSQLTab("SZ8")
		cQry += " WHERE D_E_L_E_T_ = ' '"
		cQry += " AND Z8_DENSDE <= " + cValToChar(nDenCol)
		cQry += " AND Z8_DENSATE > " + cValToChar(nDenCol)
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTmp,.T.,.T.)
		
		If !((cTmp)->(Bof()) .And. (cTmp)->(Eof()))
			nTAB1A := (cTmp)->Z8_TAB1A
			nTAB1B := (cTmp)->Z8_TAB1B
			nTAB2A := (cTmp)->Z8_TAB2A
			nTAB2B := (cTmp)->Z8_TAB2B
			
			nP1    := CalcP1(nTAB1A, nTAB1B, nTAB2A, nTAB2B)	
			nP2    := CalcP2(nTAB1A, nTAB1B, nTAB2A, nTAB2B)
			nP3    := CalcP3(nTAB1A, nTAB1B, nTAB2A, nTAB2B)
			nP4    := CalcP4(nTAB1A, nTAB1B, nTAB2A, nTAB2B)
			nP5    := CalcP5(nTmpAmb)
			nP6    := CalcP6(nDenCol,nTmpAmb,nP1,nP3)
			nP7    := CalcP7(nTmpAmb,nDenCol,nP2,nP4)
			nDens  := CalcDens(nP5,nP6,nP7)
			nFat   := CalcFat(nP1,nP2,nP3,nP4,nDens,nTmpTnq)
			nVol   := CalcVol(nFat,nVolume)
		Endif
		
		(cTmp)->(dbCloseArea())
		RestArea(aArea)
	Endif

Return {nDens, nFat, nVol}

Static Function CalcP1(nTAB1A,nTAB1B,nTAB2A,nTAB2B)
	Local nRet := (9 / 5) * 0.999042 * (nTAB1A + 16 * nTAB1B - (((8 * nTAB1A + 64 * nTAB1B) * (nTAB2A + 16 * nTAB2B)) / (1 + 8 * nTAB2A + 64 * nTAB2B)))
Return Round(nRet,20)

Static Function CalcP2(nTAB1A,nTAB1B, nTAB2A, nTAB2B)
	Local nRet := ( 9 / 5) * (nTAB2A + 16 * nTAB2B) / (1 + 8 * nTAB2A + 64 * nTAB2B)
Return Round(nRet,20)

Static Function CalcP3(nTAB1A,nTAB1B, nTAB2A, nTAB2B)
	Local nRet := 81 / 25 * 0.999042 * (nTAB1B - ((8 * nTAB1A + 64 * nTAB1B) * nTAB2B) / (1 + 8 * nTAB2A + 64 * nTAB2B))
Return Round(nRet,20)

Static Function CalcP4(nTAB1A,nTAB1B, nTAB2A, nTAB2B)
	Local nRet := 81 / 25 * (nTAB2B / ( 1 + 8 * nTAB2A + 64 * nTAB2B))
Return Round(nRet,20)

Static Function CalcP5(nTmpAmb)
	Local nRet := 1 - 0.000023 * (nTmpAmb - 20) - 0.00000002 * (nTmpAmb - 20)^2
Return Round(nRet,20)

Static Function CalcP6(nDensAmb,nTmpAmb,nP1,nP3)
	Local nRet := nDensAmb - (nP1 * (nTmpAmb - 20)) - (nP3 * (nTmpAmb - 20) * (nTmpAmb - 20))
Return Round(nRet,20)

Static Function CalcP7(nTmpAmb,nDensAmb,nP2,nP4)
	Local nRet := 1 + (nP2 * (nTmpAmb - 20)) + (nP4 * (nTmpAmb - 20) * (nTmpAmb - 20))
Return Round(nRet,20)

Static Function CalcDens(nP5,nP6,nP7)
Return Round(nP5 * nP6 / nP7,20)

Static Function CalcFat(nP1,nP2,nP3,nP4,nDens,nTmpTnq)
	Local nRet := 1 + (nP2 * (nTmptnq - 20)) + (nP4 * ((nTmpTnq - 20)^2)) + (nP1 * (nTmpTnq - 20) + (nP3 * ((nTmpTnq - 20)^2))) / nDens
Return Round(nRet,20)

Static Function CalcVol(nFT,nVolAmb)
Return Round(nVolAmb * nFT,0)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EL03DTQF3  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 27/02/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta padrão para seleção da Viagem                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EL03DTQF3()
	Local oDlgACE
	Local aArea   := GetArea()
	Local cTmp    := GetNextAlias()
	Local nPosLbx := 0                                                        // Posicao do List
	Local aItems  := {}                                                       // Array com os itens
	Local nPos    := 0                                                        // Posicao no array
	Local lRet    := .F.                                                      // Retorno da funcao
	Local cVar    := ReadVar()
	Local cBusca  := PADR(If( Type(cVar) <> "U" , &( cVar ) , ""),100)
	
	Private oBusca, oLbx1
	
	CursorWait()
	
	BeginSQL Alias cTmp
		
		COLUMN DTQ_DATGER AS DATE
		
		SELECT DTQ.DTQ_FILORI, DTQ.DTQ_VIAGEM, DTQ.DTQ_DATGER, DTQ.DTQ_HORGER, DTQ.DTQ_ROTA, DA8.DA8_DESC
		FROM %Table:DTQ% DTQ
		INNER JOIN %Table:DTR% DTR ON DTR.%NotDel%
		AND DTR.DTR_FILIAL = DTQ.DTQ_FILIAL
		AND DTR.DTR_FILORI = DTQ.DTQ_FILORI
		AND DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
		AND DTR.DTR_CODVEI = %Exp:M->ZA_EMPURRA%
		INNER JOIN %Table:DA8% DA8 ON DA8.%NotDel%
		AND DA8.DA8_FILIAL = %xFilial:DA8% 
		AND DA8.DA8_COD = DTQ.DTQ_ROTA
		WHERE DTQ.%NotDel%
		AND DTQ.DTQ_FILIAL = %xFilial:DTQ% 
		AND DTQ.DTQ_STATUS = '1'
		ORDER BY DTQ.DTQ_FILORI, DTQ.DTQ_VIAGEM

	EndSQL
	
	While !(cTmp)->(Eof())
		Aadd( aItems , { (cTmp)->DTQ_FILORI, (cTmp)->DTQ_VIAGEM, (cTmp)->DTQ_DATGER, (cTmp)->DTQ_HORGER, (cTmp)->DTQ_ROTA, (cTmp)->DA8_DESC} )
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	RestArea(aArea)
	
	If Empty(aItems)
		Aadd(aItems,{ CriaVar("DTQ_FILORI",.F.), CriaVar("DTQ_VIAGEM",.F.), CriaVar("DTQ_DATGER",.F.), CriaVar("DTQ_HORGER",.F.), CriaVar("DTQ_ROTA",.F.), CriaVar("DA8_DESC",.F.)})
	Endif
	
	CursorArrow()
	
	DEFINE MSDIALOG oDlgACE FROM  30,003 TO 260,600 TITLE "Cadastro de Viagens" PIXEL
	
	@ 03,10 SAY "Pesquisa" PIXEL OF oDlgACE
	@ 03,45 MSGET oBusca VAR cBusca Picture "@!S30" VALID BuscaViagem(@cBusca,aItems) SIZE 130,10 PIXEL OF oDlgACE
	
	@ 18,10 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER "Filial", "Viagem", "Data", "Hora", "Rota", "Descrição Rota" SIZE 283,82 OF oDlgACE PIXEL NOSCROLL
	
	oLbx1:SetArray(aItems)
	oLbx1:bLine:={|| { aItems[oLbx1:nAt,1], aItems[oLbx1:nAt,2], aItems[oLbx1:nAt,3], aItems[oLbx1:nAt,4], aItems[oLbx1:nAt,5], aItems[oLbx1:nAt,6] }}
	
	oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlgACE:End())}
	oLbx1:Refresh()
	
	DEFINE SBUTTON FROM 102,230 TYPE 1 ENABLE OF oDlgACE ACTION (lRet:= .T.,nPos := oLbx1:nAt,oDlgACE:End())
	DEFINE SBUTTON FROM 102,265 TYPE 2 ENABLE OF oDlgACE ACTION (lRet:= .F.,oDlgACE:End())
	
	ACTIVATE MSDIALOG oDlgACE CENTERED ON INIT BuscaViagem(@cBusca,aItems,.T.)
	
	If lRet .And. nPos > 0 .And. nPos <= Len(aItems)
		__cViagem := aItems[nPos,2]
	Endif
	
Return lRet

Static Function BuscaViagem(cBusca,aItems,lLoad)
	Local cSeek := AllTrim(cBusca)
	Local nPos  := AScan( aItems , {|x| AllTrim(x[2]) = cSeek } )
	
	Default lLoad := .F.
	
	If nPos > 0
		oLbx1:nAt := nPos
		oLbx1:Refresh()
		cBusca := Space(Len(cBusca))
		oBusca:Refresh()
	ElseIf !lLoad .And. !Empty(cBusca)
		Mensagem(1,"Conteúdo não foi localizado na pesquisa !")
		oBusca:SetFocus()
	Endif
	
Return .T.

User Function EL03RetVal()
Return __cViagem

Static Function Mensagem(nOpc,cTexto,cTitulo)
	Local lRet := .T.
	
	If nOpc == 1
		FWAlertError("<h3>"+cTexto+"</h3>",cTitulo)
	ElseIf nOpc == 2
		FWAlertSuccess("<h3>"+cTexto+"</h3>",cTitulo)
	ElseIf nOpc == 3
		lRet := FWAlertYesNo("<h3>"+cTexto+"</h3>",cTitulo)
	ElseIf nOpc == 4
		FWAlertWarning("<h3>"+cTexto+"</h3>",cTitulo)
	Endif

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa as dimensões da tela para posicionar os objetos    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PosObjetos(aSize,aPosObj,aPosGet)
	Local aInfo
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 080, .t., .f. } )
	AAdd( aObjects, { 100, 170, .t., .f. } )
	AAdd( aObjects, { 100, 020, .t., .t. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	
Return
