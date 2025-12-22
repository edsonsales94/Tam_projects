#INCLUDE "Protheus.ch" 
#INCLUDE "rwmake.ch"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦RSFATA01    ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 05/12/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consultar Numero de Lote.                                     ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function RSFATA01()
  // While LeLote()
  // Enddo
//Return
//***************************
//Static Function LeLote()  
//***************************
Local oFont1 := TFont():New("Courier New", 8.5,15,.T.,.T.,,,15)
Local oFont2 := TFont():New("Courier New", 7.5,15,.T.,.T.,,,15)
Local aSize
Local aPosObj
Local aPosGet
Private cCadastro := "Consultar Numero do Lote"

Private oLbx      := Nil
Private oDlg      := Nil
Private vItens    := {}
Private cLote     := CriaVar("C6_LOTE1")
Private cDoc      := CriaVar("D2_DOC")
Private cSerie    := CriaVar("D2_SERIE")
Private cDtEmis   := CriaVar("D2_EMISSAO")
Private cCli      := CriaVar("D2_CLIENTE")
Private cLoja     := CriaVar("D2_LOJA")
Private cNome     := CriaVar("A1_NOME")
Private ccodigo   := CriaVar("D2_COD")
Private nQtd      := CriaVar("D2_QUANT")
Private nTotItem  := 0     
Private nValBrut  := 0
Private cFilD2    := SD2->(XFILIAL("SD2"))

PosObjetos(@aSize,@aPosObj,@aPosGet)  
	
// Adiciona 1 item na tela
AAdd( vItens , { CriaVar("D2_CLIENTE"), CriaVar("D2_LOJA"), CriaVar("A1_NOME"),CriaVar("D2_DOC"), CriaVar("D2_SERIE"), CriaVar("D2_EMISSAO"),CriaVar("D2_COD"),CriaVar("B1_DESC"),CriaVar("D2_QUANT"), 0} )

//DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 TO 38,97 OF oMainWnd 
@ 273,300 To 800,1300 Dialog odlg Title OemToAnsi(cCadastro)
@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 300,250 OF oDlg CENTERED LOWERED //"Botoes"
oPanelT:Align := CONTROL_ALIGN_TOP
	
@ 005,005 SAY "Lote"                         SIZE 040,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HBLUE
@ 006,055 MSGET oLote   VAR cLote  Picture "@!" VALID BuscaLote() SIZE 050,10 PIXEL OF oPanelT WHEN Empty(cLote) FONT oFont2

//@ 005,170 SAY "Serie "                            SIZE 060,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HBLUE
//@ 006,200 MSGET oBar2   VAR cNFSerie Picture "@!" VALID BuscaNota() SIZE 030,10 PIXEL OF oPanelT FONT oFont2 WHEN Empty(cNFSerie) FONT oFont2

//@ 020,005 SAY "Num. Serie"                       SIZE 060,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HBLUE
//@ 020,055 MSGET oBar   VAR cCodBarra Picture "@!" VALID NumSerie() SIZE 060,10 PIXEL OF oPanelT FONT oFont2

@ 020,002 LISTBOX oLbx VAR cVar FIELDS HEADER "Cliente",;
                                              "Loja",;
                                              "Nome",;
                                              "Nota Fiscal",;
                                              "Serie",;
                                              "Data Emissão",;
                                              "Codigo Produto",;
                                              "Descrição",;
                                              "Quantidade"  SIZE 500,200 OF oPanelT PIXEL FONT oFont1
AtualizaItens()

@ 230,005 SAY "Quantidades de Notas:"    SIZE 080,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HBLUE
@ 230,085 SAY oIte VAR nTotItem Picture "@E 999999" SIZE 90,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HRED

@ 230,350 SAY "Total do Lote: " SIZE 080,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HBLUE
@ 230,400 SAY oTot VAR nValBrut Picture "@E 999,999,999.99" SIZE 120,10 PIXEL OF oPanelT FONT oFont2 COLOR CLR_HRED

//ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1, fGravaNum(), oDlg:End() },{||oDlg:End() })

//Return nOpcA == 1                                       
//@ 86,13 Button "&Alterar"   SIZE 36,16 PIXEL ACTION Processa({||fAltOrc()})
@ 245,450 Button "&Sair" SIZE 36,16 PIXEL ACTION oDlg:End()

Activate Dialog odlg CENTERED    

Return 


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function AtualizaItens()
   oLbx:SetArray( vItens )

   oLbx:bLine := {|| { vItens[oLbx:nAt,1],;
                       vItens[oLbx:nAt,2],;
                       vItens[oLbx:nAt,3],;
                       vItens[oLbx:nAt,4],;
                       vItens[oLbx:nAt,5],;
                       vItens[oLbx:nAt,6],;
                       vItens[oLbx:nAt,7],;
                       vItens[oLbx:nAt,8],;
                       Transform(vItens[oLbx:nAt,9],"@E 999,999,999.99")}}// "@E 99999999.99")}}
                                                                
Return

//----------------------------------------------------------------------------------------------------------------------------------------
// Busca os itens da NF de Saida
Static Function BuscaLote()
   Local cFilSB1 := SB1->(XFILIAL("SB1"))
   Local lRet    := .T. //ExistCpo("SF2",cNFCupom+AllTrim(cNFSerie),1)

   //If lRet .And. !Empty(cLote) //.And. !Empty(cNFSerie)
   If !Empty(cLote) //.And. !Empty(cNFSerie)

         vItens := {}
         MontaQuery()

         dbSelectArea("TMB")
         dbGoTop()
         //SetRegua(RecCount())

         While TMB->(!Eof()) .AND.  TMB->(Recno()) > 0 
            AAdd( vItens , { TMB->D2_CLIENTE, TMB->D2_LOJA, TMB->A1_NOME,TMB->D2_DOC,TMB->D2_SERIE, substr(TMB->D2_EMISSAO,7,2)+"/"+substr(TMB->D2_EMISSAO,5,2)+"/"+substr(TMB->D2_EMISSAO,1,4),TMB->D2_COD,Posicione("SB1",1,cFilSB1+TMB->D2_COD,"B1_DESC"),TMB->D2_QUANT, TMB->(Recno()) } )
            nTotItem++
            nValBrut += TMB->D2_QUANT
            TMB->(dbSkip())
         Enddo

         If lRet := !Empty(vItens)
		      AtualizaItens()
            oLbx:Refresh()
            oIte:Refresh()
            oTot:Refresh()
         Else
            AAdd( vItens , { CriaVar("D2_CLIENTE"), CriaVar("D2_LOJA"), CriaVar("A1_NOME"),CriaVar("D2_DOC"), CriaVar("D2_SERIE"), CriaVar("D2_EMISSAO"),CriaVar("D2_COD"),CriaVar("B1_DESC"),CriaVar("D2_QUANT"), 0} )
            Aviso( "Aviso", "Lote não encontrado !", {"Ok"} )
         Endif
   EndIf
   TMB->(dbCloseArea())

Return lRet                       

//----------------------------------------------------------------------------------------------------------------------------------------
Static Function fGravaNum()
   Local x
   
   PAP->(dbSetOrder(2))

   For x:=1 To Len(vItens)
	If !Empty(vItens[x,3])
      If PAP->(dbSeek(cFilPAP+vItens[x,1]+vItens[x,3])) .And. Empty(PAP->PAP_DOC)
         SD2->(dbGoTo(vItens[x,4]))   // Posiciona no registro da nota

         RecLock("PAP", .F. )
         PAP->PAP_SERIE  := SD2->D2_SERIE   // Serie
         PAP->PAP_DOC    := SD2->D2_DOC     // Numero da Nota
         PAP->PAP_EMISSA := SD2->D2_EMISSAO // Data
         PAP->PAP_ITEM   := SD2->D2_ITEM    // Numero do Item Produto
         PAP->PAP_FILORI := SD2->D2_FILIAL  // Filial Vendida
         PAP->PAP_SEQUEN := STRZERO(x,8)    // Sequencia (ira variar de acordo com a quantidade vendida)
         PAP->PAP_PRCVEN := SD2->D2_PRCVEN  // Valor liquido do produto na venda
         MSUnLock()
      Else
         Alert("Já foram gravados os Números de Serie para este Documento!")
         Return
      EndIf
     EndIf 
   Next

   MsgInfo("Número de Serie Gravado com Sucesso! ")

   If MsgNoYes("Deseja Imprimir Número de Serie?")
      u_RSFATR03(vItens)
   EndIf

Return 


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 05/12/2013 ¦¦¦
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
	AAdd( aObjects, { 100, 030, .t., .t. } )
	AAdd( aObjects, { 100, 060, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	
Return    



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaQuery ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 05/12/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta a Query para consulta do Lota informado.                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaQuery()

Local cQuery := ""

cQuery := " SELECT C6_LOTE1,D2_CLIENTE,D2_LOJA, A1_NOME, D2_DOC,D2_SERIE, D2_COD,D2_EMISSAO,D2_QUANT " 
cQuery += " FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1 " 
cQuery += " WHERE SD2.D_E_L_E_T_ = ''  AND SC6.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' " 
cQuery += " AND C6_FILIAL = D2_FILIAL " 
cQuery += " AND C6_NUM = D2_PEDIDO " 
cQuery += " AND A1_COD = D2_CLIENTE " 
cQuery += " AND A1_LOJA = D2_LOJA " 
cQuery += " AND A1_FILIAL = D2_FILIAL " 
cQuery += " AND C6_ITEM = D2_ITEMPV " 
cQuery += " AND C6_CLI = D2_CLIENTE " 
cQuery += " AND C6_LOJA = D2_LOJA "
cQuery += " AND C6_LOTE1 <> '' " 
cQuery += " AND C6_LOTE1 = '"+cLote+"'"
cQuery += " ORDER BY D2_CLIENTE, D2_LOJA " 
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMB", .T., .F. )
          		
Return	 
