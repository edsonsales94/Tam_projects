#Include "Protheus.ch"
#Include "Topconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AALOJC01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 28/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta de produtos e detalhes                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AALOJC01()
   Local cQuery, z, a, b, c, d, nCln, nLnh, bEstoque
   Local nOpcA   := 0
   Local bOk     := {|| nOpc:=1 , oDlgH:End() }
   Local bCancel := {|| nOpc:=0 , oDlgH:End() }
   Local cTitulo := "Consulta Produtos"
   Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
   Local oFont2  := TFont():New("Courier New", 7.5,15,.T.,.T.,,,15)
   Local oFont3  := TFont():New("Courier New",10,22,.T.,.T.)
   Local nLinF   := 225 //251
   Local vOrdem  := { "Descrição", "Codigo"}
//   Local cUsuGer := GetMV("MV_XUSRGER")

   Private cOrdem := vOrdem[1]
   Private oObj, oDlgH, oFld, oLbx1, oLbx2, oLbx3, oLbx4
   Private oSayD1, oSayD2, oSayD3, oSayC1, oTot, oTrf, oAst, oTecAst
   Private oFor, oDtN, oDtV, oDtM, oDoc, oVal, oQtN, oPer, oICM, oFre, oEnc, oDes, oIni, oQtd, oAtu, oVen
   Private oPco, oPvj, oPat, oIpi
   Private lAtual, vArq := Array(4)
   Private vTec   := {}
   Private nOpAnt := 1
   Private _nRamTot, _nRamTrf, _nRamRes, _nRamPed, _cAsteri, vSaldo := {}   
   Private cDescri, cCondPag, cPrdBusca := Space(30)
   Private _cFornec, _dDtNot, _dDtVt, _dDtMCh, _cDocto, _nValNot, _nQtdNot, _nPerc, _nValICM, _nFrete, _nEncF
   Private _nDesp, _nInici, _nQtdAt, _nAtual, _nVenda, _nPComp, _nPVare, _nPAtac, _nVIpi, _nTecLoj, _nTecAtc

   Private nPrcVenA := 0
   Private nPrcCusA := 0
   Private nPrcSimA := 0
   Private nPrcVenS := 0
   Private nPrcSimS := 0
   
   SB0->(dbSetOrder(1))
   DA1->(dbSetOrder(1))
   //SZR->(dbSetOrder(1))

   // Inicializa vetor que contem dados sobre a Assistencia Tecnica
   AAdd( vTec , { " "  , "01", Nil, 0})
   AAdd( vTec , { " "  , "02", Nil, 0})

   // Inicializa vetor que contem dados sobre as filiais                   
   
   AAdd( vSaldo , { "06200" , "00", Nil, 0, Nil, 0, Nil, " ", Nil, 0, 0})
   AAdd( vSaldo , { "06300" , "01", Nil, 0, Nil, 0, Nil, " ", Nil, 0, 0})
   AAdd( vSaldo , { "04208" , "02", Nil, 0, Nil, 0, Nil, " ", Nil, 0, 0})
   AAdd( vSaldo , { "DEPOSI", "03", Nil, 0, Nil, 0, Nil, " ", Nil, 0, 0})
   AAdd( vSaldo , { "SILVES", "04", Nil, 0, Nil, 0, Nil, " ", Nil, 0, 0})

   nLinF  += If( Len(vSaldo) > 14 , 30, 0)
   lAtual := .F.  // Variavel que identifica se a tela esta atualizada com as informacoes do produto
   IniciaVar() // Incializa variaveis do estoque

   cQuery := "SELECT TOP 100 B1_DESC, B1_COD, B1_ESPECIF FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL = '"+XFILIAL("SB1")
   cQuery += "' AND D_E_L_E_T_ = ' ' "
   cQuery += "ORDER BY B1_ESPECIF"

   LjMsgRun("     Filtrando Produtos     ","Aguarde...",{|| MontaProd(cQuery) })

   DEFINE MSDIALOG oDlgH TITLE cTitulo From 8,0 To 44,128 OF oMainWnd


   @ 015,005 COMBOBOX oOrd VAR cOrdem ITEMS vOrdem SIZE 80,30 PIXEL OF oDlgH FONT oFont1
   //@ 15,005 SAY "Produto" PIXEL OF oDlgH FONT oFont1 COLOR CLR_HBLUE

   @ 15,090 SAY "Pesquisa" PIXEL OF oDlgH FONT oFont1 COLOR CLR_HBLUE
   @ 15,125 GET cPrdBusca Picture "@!" Valid BuscaPrd() SIZE 100,10 PIXEL OF oDlgH FONT oFont1

   oLbx1 := TWBrowse():New(30,05,220,170, {|| { XXX->B1_COD,XXX->B1_ESPECIF }}, {"Codigo", "Descricao"},,oDlgH,;
            "XXX->B1_ESPECIF",,,{||Apertou()},{|| ProdSelec()}, ,oFont2,,,,,,"XXX", .T.,,,,,)

   /* Monta a tela com as Pastas (Folders) */
   @ 20,230 FOLDER oFld PIXEL OF oDlgH PROMPT "&Preços", "&Fornecedores", "&Custos", "&Vendas"  SIZE 270,178
   oFld:bSetOption := {|nOpAtu| VldFolder(nOpAtu,oFont1) }

   /* Pasta Precos */
   @ 001,005 SAY oSayD1 VAR cDescri  PIXEL OF oFld:aDialogs[1] FONT oFont3 COLOR CLR_HRED
   @ 150,025 SAY oSayC1 VAR cCondPag PIXEL OF oFld:aDialogs[1] FONT oFont2 COLOR CLR_HRED

   @ 015,005 TO 060,265 LABEL "Preço Atual" PIXEL OF oFld:aDialogs[1]

   @ 030,020 SAY "Preço Venda" PIXEL OF oFld:aDialogs[1] FONT oFont1 COLOR CLR_HBLUE
   @ 030,090 SAY "Preço Custo" PIXEL OF oFld:aDialogs[1] FONT oFont1 COLOR CLR_HBLUE
   @ 030,155 SAY "Margem %"    PIXEL OF oFld:aDialogs[1] FONT oFont1 COLOR CLR_HBLUE

   @ 045,015 MSGET oPrcA VAR nPrcVenA Picture "@E 999,999.99" SIZE 50,10 VALID .T. PIXEL OF oFld:aDialogs[1] READONLY
   @ 045,085 MSGET oCusA VAR nPrcCusA Picture "@E 999,999.99" SIZE 50,10 VALID .T. PIXEL OF oFld:aDialogs[1] READONLY
   @ 045,155 MSGET oMarA VAR nPrcSimA Picture "@E 999.99"     SIZE 30,10 VALID .T. PIXEL OF oFld:aDialogs[1] READONLY

   @ 065,005 TO 110,265 LABEL "Simulação" PIXEL OF oFld:aDialogs[1]

   @ 080,015 SAY "Preço Venda" PIXEL OF oFld:aDialogs[1] FONT oFont1 COLOR CLR_GREEN
   @ 080,085 SAY "Preço Custo" PIXEL OF oFld:aDialogs[1] FONT oFont1 COLOR CLR_GREEN
   @ 080,155 SAY "Margem %"    PIXEL OF oFld:aDialogs[1] FONT oFont1 COLOR CLR_GREEN

   @ 095,015 MSGET oPrcS VAR nPrcVenS Picture "@E 999,999.99" SIZE 50,10 VALID NovoPreco() PIXEL OF oFld:aDialogs[1]
   @ 095,085 MSGET oCusS VAR nPrcCusA Picture "@E 999,999.99" SIZE 50,10 VALID .T.         PIXEL OF oFld:aDialogs[1] READONLY
   @ 095,155 MSGET oMarS VAR nPrcSimS Picture "@E 999.99"     SIZE 30,10 VALID NovoPreco() PIXEL OF oFld:aDialogs[1]

   @ 115,005 TO 160,265 LABEL "Atualizar Produtos"  PIXEL OF oFld:aDialogs[1]

   @ 130,010 BUTTON "Visualizar" SIZE 50,15 ACTION Atualiza(2) PIXEL OF oFld:aDialogs[1]
   @ 130,075 BUTTON "Incluir"    SIZE 50,15 ACTION Atualiza(3) PIXEL OF oFld:aDialogs[1] //WHEN __cUserID $ cUsuGer
   @ 130,140 BUTTON "Alterar"    SIZE 50,15 ACTION Atualiza(4) PIXEL OF oFld:aDialogs[1] //WHEN __cUserID $ cUsuGer

   //oLbx2 := TWBrowse():New(15,05,255,110, {|| { PPP->DTFAT, PPP->VAREJO, PPP->ATACAD }},;
   //         {"Fatura", "Preco Varejo", "Preco Atacado"}, , oFld:aDialogs[1],;
   //         "DESCEND(PPP->DTFAT)",,,,,,oFont1,,,,,,"PPP", .T.,,,,,)

   /* Pasta Detalhes */
   @ 001,005 SAY oSayD2 VAR cDescri  PIXEL OF oFld:aDialogs[2] FONT oFont3 COLOR CLR_HRED
   @ 150,025 SAY oSayC2 VAR cCondPag PIXEL OF oFld:aDialogs[2] FONT oFont2 COLOR CLR_HRED

   oLbx3 := TWBrowse():New(15,05,255,110,;
            {|| { FFF->FORNEC, FFF->VALFOB, FFF->VALOUT , FFF->FOBDOL, FFF->QUANT, FFF->EMISSAO }},;
            {"Fornecedor", "FOB", "FOB+EF", "FOB US$", "Quantidade", "Emissao"},, oFld:aDialogs[2];
            , ,,,,,,oFont1,,,,,,"FFF", .T.,,,,,)

   /* Pasta Custos */
   @ 001,005 SAY oSayD3 VAR cDescri  PIXEL OF oFld:aDialogs[3] FONT oFont3 COLOR CLR_HRED
   @ 150,025 SAY oSayC3 VAR cCondPag PIXEL OF oFld:aDialogs[3] FONT oFont2 COLOR CLR_HRED

   @ 015,005 TO 055,265 LABEL "Última Entrada" PIXEL OF oFld:aDialogs[3]
   @ 022,010 SAY "Fornecedor:"     PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 022,055 SAY oFor VAR _cFornec PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 70,10 
   @ 032,010 SAY "Data:"           PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 032,030 SAY oDtN VAR _dDtNot  PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10 
   @ 032,080 SAY "DtVt:"           PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 032,100 SAY oDtV VAR _dDtVt   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10 
   @ 032,150 SAY "DtDig:"          PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 032,174 SAY oDtM VAR _dDtMCh  PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10 
   @ 042,010 SAY "Docto:"          PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 042,034 SAY oDoc VAR _cDocto  PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 30,10 
   @ 042,080 SAY "Valor R$:"       PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 042,116 SAY oVal VAR Ltrim(Transform(_nValNot,"@E 999,999,999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10
   @ 042,165 SAY "Quant:"          PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 042,190 SAY oQtN VAR Ltrim(Transform(_nQtdNot,"@E 999,999,999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10

   @ 060,005 TO 090,265 LABEL "Impostos / Despesas" PIXEL OF oFld:aDialogs[3]
   @ 067,010 SAY oPer VAR "ICMS ("+Ltrim(Transform(_nPerc,"@E 99.99"))+"%):";
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 067,065 SAY oICM VAR Ltrim(Transform(_nValICM,"@E 999,999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10
   @ 067,125 SAY "FRETE:" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 067,150 SAY oFre VAR Ltrim(Transform(_nFrete,"@E 999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10
   @ 077,010 SAY "ENCF:"  PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 077,030 SAY oEnc VAR Ltrim(Transform(_nEncF,"@E 999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10
   @ 077,125 SAY "DESP.:" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 077,150 SAY oDes VAR Ltrim(Transform(_nDesp,"@E 999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10
   @ 067,200 SAY "IPI:" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 067,225 SAY oIpi VAR Ltrim(Transform(_nVIpi,"@E 999.99"));
                                   PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 45,10

  /* @ 095,005 TO 115,265 LABEL "Saldos da Loja"  PIXEL OF oFld:aDialogs[3]
   @ 102,010 SAY "INIC:"  PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 102,032 SAY oIni VAR Ltrim(Transform(_nInici,"@E 9,999,999")) PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10
   @ 102,070 SAY "QUANT:" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 102,095 SAY oQtd VAR Ltrim(Transform(_nQtdAt,"@E 9,999,999")) PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10
   @ 102,136 SAY "ATUAL:" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 102,162 SAY oAtu VAR Ltrim(Transform(_nAtual,"@E 9,999,999")) PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10
   @ 102,199 SAY "VENDA:" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 102,225 SAY oVen VAR Ltrim(Transform(_nVenda,"@E 9,999,999")) PIXEL OF oFld:aDialogs[3] FONT oFont1 SIZE 40,10
    */
   @ 120,005 TO 145,265 LABEL "Preços do Produto"  PIXEL OF oFld:aDialogs[3]
   @ 127,010 SAY "COMPRA"  PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 127,040 SAY oPco VAR Ltrim(Transform(_nPComp,"@E 99,999.99")) PIXEL OF oFld:aDialogs[3] FONT oFont1
   @ 127,090 SAY "VAREJO"  PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 127,120 SAY oPvj VAR Ltrim(Transform(_nPVare,"@E 99,999.99")) PIXEL OF oFld:aDialogs[3] FONT oFont1
   @ 127,170 SAY "ATACADO" PIXEL OF oFld:aDialogs[3] FONT oFont1 COLOR CLR_BLUE
   @ 127,205 SAY oPat VAR Ltrim(Transform(_nPAtac,"@E 99,999.99")) PIXEL OF oFld:aDialogs[3] FONT oFont1


   /* Pasta Vendas   */
   @ 001,005 SAY oSayD2 VAR cDescri  PIXEL OF oFld:aDialogs[4] FONT oFont3 COLOR CLR_HRED
   //@ 150,025 SAY oSayC2 VAR cCondPag PIXEL OF oFld:aDialogs[2] FONT oFont2 COLOR CLR_HRED

   oLbx4 := TWBrowse():New(15,05,255,110,;
            {|| { WWW->CLIENTE, WWW->NOTAFIS, WWW->SERIE, WWW->QUANT,WWW->PRCVEN, WWW->VALOR, WWW->EMISSAO, WWW->FILIAL }},;
            {"Cliente", "Documento", "Serie", "Quantidade", "Prc Unitario", "Total","Emissao", "Filial"},, oFld:aDialogs[4];
            , ,,,,,,oFont1,,,,,,"WWW", .T.,,,,,)
 
   /* Estoque das Lojas */
   //@ 208,008 TO nLinF+10,487 LABEL "Estoque das Lojas" OF oDlgH PIXEL

//   @ 208,008 SAY "Estoque das Lojas" OF oDlgH PIXEL

   @ 200,005 TO 260,500 LABEL "Saldos Produto"  OF oDlgH PIXEL
                          
  
   bEstoque := {|a,b,c,d| StokDraw(a,b,c,d) }
   nLnh     := 170 //185
   nCln     := 445

   @ nLnh+40+00,14 SAY "Filiais"  SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_HBLUE   
   @ nLnh+40+08,14 SAY "Estoque"  SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_GREEN
   @ nLnh+40+16,14 SAY "Transito" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_BLACK 
   @ nLnh+40+24,14 SAY "Vendas"   SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_HRED 
   @ nLnh+40+32,14 SAY "Reserva"  SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_MAGENTA 

   
   For z:=1 To Len(vSaldo)

      If nCln > 444
         nLnh += 40
         nCln := 50
      Endif

      Eval(bEstoque,z,nLnh,nCln,oFont1)
      nCln += 43
   Next

   @ nLnh+00,444 SAY "TOTAL"    PIXEL OF oDlgH FONT oFont1 COLOR CLR_HBLUE
   @ nLnh+08,444 SAY oTot VAR _nRamTot Picture "@E  9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_GREEN
   @ nLnh+16,444 SAY oTrf VAR _nRamTrf Picture "@E  9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_BLACK   
   @ nLnh+24,444 SAY oPed VAR _nRamPed Picture "@E  9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_HRED
   @ nLnh+32,444 SAY oRes VAR _nRamRes Picture "@E  9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_MAGENTA   
   
  // @ nLnh+23,474 SAY oAst VAR _cAsteri PIXEL OF oDlgH FONT oFont1 COLOR CLR_BLACK

   @ 265,005 SAY "ENTER ou DUPLO CLIQUE - Atualiza informações" PIXEL OF oDlgH COLOR CLR_RED
   //@ 323,140 SAY "* Quantidade em Trânsito" PIXEL OF oDlgH COLOR CLR_BLACK  
   //@ 323,220 SAY "Quantidade reservada" PIXEL OF oDlgH COLOR CLR_MAGENTA

   @ 323,280 SAY vTec[1,3] VAR vTec[1,1] SIZE 70,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_BROWN
   @ 323,345 SAY vTec[2,3] VAR vTec[2,1] SIZE 70,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_BROWN

   ACTIVATE MSDIALOG oDlgH CENTERED ON INIT EnchoiceBar(oDlgH,bOk,bCancel)

Return

/* Mostra os estoques das filiais */
Static Function StokDraw(z,nLnh,nCln,oFont1)

   @ nLnh+00,nCln SAY vSaldo[z,1]  PIXEL OF oDlgH FONT oFont1 COLOR CLR_HBLUE

   @ nLnh+08,nCln SAY vSaldo[z,3]  VAR vSaldo[z,4]  Picture "@E 9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_GREEN

   @ nLnh+16,nCln SAY vSaldo[z,5]  VAR vSaldo[z,6]  Picture "@E 9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_BLACK

   @ nLnh+24,nCln SAY vSaldo[z,7]  VAR vSaldo[z,8]  Picture "@E 9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_HRED

   @ nLnh+32,nCln SAY vSaldo[z,9]  VAR vSaldo[z,10] Picture "@E 9999999" SIZE 30,10 PIXEL OF oDlgH FONT oFont1 COLOR CLR_MAGENTA 
      
   // Se for Assistencia tecnica e existir saldo, entao exibe asterisco
//   If vSaldo[z,2] == "15"
 //     @ nLnh+08,nCln+30 SAY oTecAst VAR If( vSaldo[z,4] <> 0 , "*", " ") PIXEL OF oDlgH FONT oFont1 COLOR CLR_BROWN
 //  Endif

Return

/* Inicializa as variaveis do estoque */
Static Function IniciaVar()
   Local z

   For z:=1 To Len(vSaldo)
      vSaldo[z,4]   := 0
      vSaldo[z,6]   := 0
      vSaldo[z,8]   := 0
      vsaldo[z,10]  := 0
   Next
   _nRamTot  := 0
   _nRamTrf  := 0             
   _nRamPed  := 0
   _nRamRes  := 0             
   
   _cAsteri  := " "
   vTec[1,1] := " "
   vTec[2,1] := " "
   vTec[1,4] := 0
   vTec[2,4] := 0

   _cFornec := Space(20)
   _dDtNot  := Ctod("")
   _dDtVt   := Ctod("")
   _dDtMCh  := Ctod("")
   _cDocto  := Space(06)
   _nValNot := 0
   _nQtdNot := 0
   _nPerc   := 0
   _nValICM := 0
   _nFrete  := 0
   _nEncF   := 0
   _nDesp   := 0
   _nVIpi   := 0
   _nInici  := 0
   _nQtdAt  := 0
   _nAtual  := 0
   _nVenda  := 0
   _nPComp  := 0
   _nPVare  := 0
   _nPAtac  := 0
Return

/* Efetua a atualizacao das variaveis do estoque */
Static Function RefreshDados()
   Local z

   For z:=1 To Len(vSaldo)
      vSaldo[z,3]:Refresh()
      vSaldo[z,5]:Refresh()
      vSaldo[z,7]:Refresh() 
      vSaldo[z,9]:Refresh()
   Next
   oTot:Refresh()
   oTrf:Refresh()
   oRes:Refresh()
   oPed:Refresh()

//   oAst:Refresh()

   oFor:Refresh()
   oDtN:Refresh()
   oDtV:Refresh()
   oDtM:Refresh()
   oDoc:Refresh()
   oVal:Refresh()
   oQtN:Refresh()
   oPer:Refresh()
   oICM:Refresh()
   oFre:Refresh()
   oEnc:Refresh()
   oDes:Refresh()
   oIpi:Refresh()
   //oIni:Refresh()
   //oQtd:Refresh()
   //oAtu:Refresh()
   //oVen:Refresh()
   oPco:Refresh()
   oPvj:Refresh()
   oPat:Refresh()

   //oTecAst:Refresh()
   //vTec[1,3]:Refresh()
   //vTec[2,3]:Refresh()
Return

/* Valida a entrada no Folder 3, que sao informacoes confidenciais */
Static Function VldFolder(nOpAtu,oFont1)
   Local oPsw, nOpc := 0, cPswFol := Space(06), lRet := .T.

   If nOpAnt == 1 .And. nOpAtu > 1 // nOpAtu == 3 // ALTERADO EM 04/01/07 SOLICITADO RISHI
      DEFINE MSDIALOG oPsw TITLE "Senha" From 8,70 To 13,90 OF oMainWnd

      @ 05,005 SAY "Senha" PIXEL OF oPsw
      @ 05,035 GET cPswFol PASSWORD SIZE 30,10 PIXEL OF oPsw FONT oFont1
      
      @ 20,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oPsw PIXEL;
                      Action IIF(VldSenha(cPswFol),(nOpc:=1,oPsw:End()),nOpc:=0)
      @ 20,040 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL;
                      Action (nOpc:=0,oPsw:End())

      ACTIVATE MSDIALOG oPsw

      lRet := (nOpc == 1)
   Endif

   If lRet
      nOpAnt := nOpAtu  // Salva a última posição
   Endif

Return(lRet)

/* Valida a senha informada pelo usuario */
Static Function VldSenha(cPsw)
   Local lRet    := .T.
   Local cUser   := Upper(Trim(SubStr(cUsuario,7,15)))
   Local cCodUsr := RetCodUsr(SubStr(cUsuario,7,15))

   PswOrder(1)
   PswSeek(cCodUsr)
   If lRet := PswName(cPsw)
      // Se Usuários não for liberados e for Produto Importado
      If !(cCodUsr $ GetMv("MV_USUTELA"))
         Alert("Produto restrito, não é possível visualização !")
         lRet := .F.
      Endif
   Else
      Alert("Senha Inválida, verifique a senha digitada !")
   Endif

Return (lRet)

/* Pesquisa no cadastro de usuario do sistema o codigo do mesmo */
Static Function RetCodUsr(cUser)
   Local aUser, cUserAnt
   PswOrder(2)//Nome
   PswSeek(Alltrim(cUser)) //Pesquisa usuario  
   aUser := PswRet(1) //Retorna Matriz com detalhes, acessos do Usuario
   cUserAnt := aUser[1][1]  //Retorna codigo do usuario
Return(cUserAnt)

/* Ao ser informado a descricao monta-se a selecao dos produtos e o preenchimento do mesmo no browse */
Static Function BuscaPrd()
   Local cQuery, lRet := .T.
   Local cCampo := If( cOrdem = "Desc" , "B1_ESPECIF", If( cOrdem = "Fabr" , "B1_ESPECIF", "B1_COD"))

   If Len(AllTrim(cPrdBusca)) < 3
      If !Empty(cPrdBusca)
         Alert("Favor digitar no minimo 3 caracteres para busca !")
         lRet := .F.
      Endif
   Else
      cQuery := "SELECT B1_DESC, B1_COD, B1_ESPECIF FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL = '"+XFILIAL("SB1")+"' AND "
      cQuery += "D_E_L_E_T_ = ' ' AND "+cCampo+" LIKE '%"+AllTrim(StrTran(cPrdBusca,"'",""))+"%'"

      LjMsgRun("     Filtrando Produtos     ","Aguarde...",{|| MontaProd(cQuery) })

      cPrdBusca := Space(30)
      oLbx1:Refresh()
      oDlgH:Refresh()
      
      Apertou()
   Endif
Return(lRet)

/* Busca os produtos de acordo com a descricao informada pelo usuario */
Static Function MontaProd(cQuery)
   Local aCampos := {}

   If Select("XXX") <> 0
      dbSelectArea("XXX")
      dbCloseArea()
      If vArq[1] <> Nil
         FErase(vArq[1]+OrdBagExt())
      Endif
   Endif

//   AAdd( aCampos , { "B1_DESC"   , "C", TamSX3("B1_DESC"   )[1], TamSX3("B1_DESC"   )[2]} )
   AAdd( aCampos , { "B1_ESPECIF", "C", TamSX3("B1_ESPECIF")[1], TamSX3("B1_ESPECIF")[2]} )
   AAdd( aCampos , { "B1_COD"    , "C", TamSX3("B1_COD"    )[1], TamSX3("B1_COD"    )[2]} )

   vArq[1] := CriaTrab(aCampos,.T.)
   Use &(vArq[1]) New Exclusive Alias XXX 

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
   dbGoTop()
   While !Eof()
      dbSelectArea("XXX")
      RecLock("XXX",.T.)
//      XXX->B1_DESC    := YYY->B1_DESC
      XXX->B1_ESPECIF := YYY->B1_ESPECIF
      XXX->B1_COD     := YYY->B1_COD
      MsUnLock()
      dbSelectArea("YYY")
      dbSkip()
   Enddo
   dbCloseArea()

   MontaBrw(.T.) // Zera os browses da fatura e do fornecedor

   dbSelectArea("XXX")
   dbGoTop()

   AtualPreco(XXX->B1_COD,.F.)

Return

/* Cria e/ou recria os browses da Fatura e do Fornecedor em branco */
Static Function MontaBrw(lBlank)
   Local aDBF

   If Select("PPP") <> 0
      dbSelectArea("PPP")
      dbCloseArea()
      If vArq[2] <> Nil
         FErase(vArq[2]+OrdBagExt())
      Endif
   Endif

   vArq[2] := CriaTrab({{"DTFAT","D",8,0},{"VAREJO","C",8,0},{"ATACAD","C",8,0}},.T.)
   Use &(vArq[2]) New Exclusive Alias PPP
   If lBlank
      dbSelectArea("PPP")
      RecLock("PPP",.T.)
      PPP->VAREJO := Transform(0,"@E 99,999.99")
      PPP->ATACAD := Transform(0,"@E 99,999.99")
      MsUnLock()
   Endif

   If Select("FFF") <> 0
      dbSelectArea("FFF")
      dbCloseArea()
      If vArq[3] <> Nil
         FErase(vArq[3]+OrdBagExt())
      Endif
   Endif

   aDBF := {}
   AAdd( aDBF , { "FORNEC" , "C", 20, 0} )
   AAdd( aDBF , { "VALFOB" , "C", 12, 0} )
   AAdd( aDBF , { "VALOUT" , "C", 12, 0} )
   AAdd( aDBF , { "FOBDOL" , "C", 12, 0} )
   AAdd( aDBF , { "QUANT"  , "C", 12, 0} )
   AAdd( aDBF , { "EMISSAO", "D", 08, 0} )

   vArq[3] := CriaTrab(aDBF,.T.)
   Use &(vArq[3]) New Exclusive Alias FFF
   If lBlank
      dbSelectArea("FFF")
      RecLock("FFF",.T.)
      FFF->VALFOB := Transform(0,"@E 999,999.99")
      FFF->VALOUT := Transform(0,"@E 999,999.99")
      FFF->FOBDOL := Transform(0,"@E 999,999.99")
      FFF->QUANT  := Transform(0,"@E 999,999.99")
      MsUnLock()
   Endif

   If Select("WWW") <> 0
      dbSelectArea("WWW")
      dbCloseArea()
      If vArq[4] <> Nil
         FErase(vArq[4]+OrdBagExt())
      Endif
   Endif

   aDBF := {}
   AAdd( aDBF , { "CLIENTE", "C", 20, 0} )
   AAdd( aDBF , { "NOTAFIS", "C", 09, 0} )
   AAdd( aDBF , { "SERIE"  , "C", 03, 0} )   
   AAdd( aDBF , { "QUANT"  , "C", 14, 0} )
   AAdd( aDBF , { "PRCVEN" , "C", 14, 0} )
   AAdd( aDBF , { "VALOR"  , "C", 14, 0} )   
   AAdd( aDBF , { "EMISSAO", "D", 08, 0} )
   AAdd( aDBF , { "FILIAL" , "C", 08, 0} )

   vArq[4] := CriaTrab(aDBF,.T.)
   Use &(vArq[4]) New Exclusive Alias WWW
   If lBlank
      dbSelectArea("WWW")
      RecLock("WWW",.T.)
        WWW->VALOR  := Transform(0,"@E 999,999,999.99")
        WWW->QUANT  := Transform(0,"@E 999,999,999.99")
        WWW->PRCVEN := Transform(0,"@E 999,999,999.99")      
      MsUnLock()
   Endif

   dbSelectArea("FFF")
   dbGoTop()
   dbSelectArea("PPP")
   dbGoTop()
   dbSelectArea("WWW")
   dbGoTop()

Return

/* Atualiza a tela com as informacoes do produto ao ser teclado duplo clique ou ENTER */
Static Function ProdSelec(nLin,nCam,nFlag)
   If !lAtual
      lAtual := .T.

      LjMsgRun("     Atualizando Estoques     ","Aguarde...",{|| AtuEstoque() })
      LjMsgRun("     Buscando Entradas      "  ,"Aguarde...",{|| AtuNotas()   })

      RefreshDados()

      //oLbx2:Refresh()
      oLbx3:Refresh()
      oLbx4:Refresh()

   Endif

   nOpAtu := 1  // Salva posição 1
Return

/* Efetua atualizacoes caso tenha-se selecionado outro produto no browse */
Static Function Apertou()
   If lAtual
      MontaBrw(.T.)    // Zera os browses da fatura e do fornecedor
      //oLbx2:Refresh()
      oLbx3:Refresh()
		oLbx4:Refresh()

      IniciaVar()     // Zera os valores de estoque das lojas
      RefreshDados()  // Atualiza os valores de estoque e dados na tela
   Endif

   AtualPreco(XXX->B1_COD,.T.)

   lAtual   := .F.

   oSayD1:Refresh()
   oSayD2:Refresh()
   oSayD3:Refresh()
   oSayC1:Refresh()
   oSayC2:Refresh()
   oSayC3:Refresh()

Return(.T.)

/* Busca o saldo em estoque do produto em todas as lojas */
Static Function AtuEstoque()
   Local z, cQry
   Local cAlias := Alias()


   _nRamTot  := 0
   _nRamTrf  := 0
   _nRamRes  := 0
   _nRamPed  := 0             
   
   vTec[1,4] := 0
   vTec[2,4] := 0
   
   For z:=1 To Len(vSaldo)
        
     // busca os saldos dos produdos
      vAux := fTabTemp(XXX->B1_COD)
      
        vSaldo[z,04] := vAux[z     ] // estoque 
        vSaldo[z,10] := vAux[z + 05] // reserva  
        vSaldo[z,08] := vAux[z + 10] // pedidos de vendas   
        vSaldo[z,06] := vAux[z + 15] // PRE NOTAS // TRANSITO 
      
      _nRamTot += vSaldo[z,04]            
      _nRamTrf += vSaldo[z,06]   
      _nRamRes += vSaldo[z,10]   
      _nRamPed += vSaldo[z,08]    
      
   Next
   _cAsteri := If( _nRamTrf <> 0 , "*", " ")

/*   If vTec[1,4] <> 0       // Se existir saldo para a Loja na Assistencia, entao habilita legenda
     vTec[1,1] := "* LOJA => "+LTrim(Transform(vTec[1,4],"@EZ 9999999"))
   Endif

   If vTec[2,4] <> 0       // Se existir saldo para o Atacado na Assistencia, entao habilita legenda
      vTec[2,1] := "* ATACADO => "+LTrim(Transform(vTec[2,4],"@EZ 9999999"))
   Endif */
   dbSelectArea(cAlias)
Return

/* Busca as ultimas entradas para o produto */
Static Function AtuNotas()
   Local cQry, x, cDtFech, nPrcDolar, nPrcReal
   Local vUlt   := {}
   Local lPrim  := .T.
   Local cAlias := Alias()

   MontaBrw(.F.) // Cria uma novo arquivo para o browse da fatura e do fornecedor

   SB0->(dbSetOrder(1))
   SB0->(dbSeek(XFILIAL("SB0")+XXX->B1_COD))
   
   DA1->(dbSetOrder(1))
   DA1->(dbSeek(XFILIAL("DA1")+"002"+XXX->B1_COD))
   
   /* Busca as 10 ultimas notas de entrada efetuadas no sistema */
   cQry := "SELECT TOP 10 D1_FILIAL, D1_FORNECE, D1_LOJA, D1_DOC, D1_SERIE, D1_DTDIGIT, D1_COD, D1_ITEM, D1_VUNIT, D1_IPI, D1_VALDESC, "
   cQry += "D1_QUANT, D1_PEDIDO, D1_ITEMPC, D1_PICM, D1_IPI, F1_VALICM, F1_TXMOEDA, F1_EMISSAO, F1_VALBRUT, A2_NOME "
   cQry += "FROM "+RetSQLName("SD1")+" SD1, "+RetSQLName("SF1")+" SF1, "+RetSQLName("SF4")+" SF4, "+RetSQLName("SA2")+" SA2 "
   cQry += "WHERE SD1.D_E_L_E_T_ = ' ' AND SF1.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' ' AND "
   cQry += "D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND "
   cQry += "D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND "
   cQry += "D1_TIPO = 'N' AND D1_COD = '"+XXX->B1_COD+"' AND " //D1_FILIAL = '01' AND "
   cQry += "D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' "
   //cQry += "GROUP BY D1_FILIAL, D1_DTDIGIT, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM "
   cQry += "ORDER BY D1_DTDIGIT, D1_DOC, D1_COD, D1_ITEM DESC"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "DDD", .T., .F. )
   TCSetField("DDD","D1_DTDIGIT","D",8,0)
   TCSetField("DDD","F1_EMISSAO","D",8,0)

   dbGoTop()
   While !Eof()

      SE2->(dbSetOrder(6))
      SE2->(dbSeek(DDD->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_SERIE+D1_DOC)))

      nPrcReal  := DDD->(D1_VUNIT * (1 + (D1_IPI / 100)) - (D1_VALDESC / D1_QUANT))
      nPrcDolar := nPrcReal / DDD->F1_TXMOEDA

      // Pesquisa no Pedido de Compras
      SC7->(dbSetOrder(1))
      If SC7->(dbSeek(XFILIAL("SC7")+DDD->(D1_PEDIDO+D1_ITEMPC)))
         nPrcReal  := SC7->C7_PRECO
         nPrcDolar := 0  //If( !Empty(SC7->C7_YPRCDOL) , SC7->C7_YPRCDOL, nPrcDolar)
      Endif

      If lPrim
         _cFornec := DDD->A2_NOME
         _dDtNot  := DDD->F1_EMISSAO
         _dDtVt   := SE2->E2_VENCTO
         _dDtMCh  := DDD->D1_DTDIGIT
         _cDocto  := DDD->D1_DOC
         _nValNot := DDD->F1_VALBRUT
         _nQtdNot := DDD->D1_QUANT
         _nPerc   := DDD->D1_PICM
         _nValICM := DDD->F1_VALICM
         _nFrete  := "" //If( Upper(Trim(SZ1->Z1_DESPE01)) == "FRETE CIF" , 0, SZ1->Z1_PERFT01)
         _nEncF   := 0
         _nDesp   := 0  //SZ1->Z1_TXCOR
         _nVIpi   := DDD->D1_IPI
         _nPComp  := nPrcReal
         lPrim    := .F.
      Endif
      dbSelectArea("FFF")
      RecLock("FFF",.T.)
        FFF->FORNEC  := DDD->A2_NOME
        FFF->VALFOB  := Transform(nPrcReal     ,"@E 99,999.99")
        FFF->VALOUT  := Transform(nPrcReal     ,"@E 99,999.99")
        FFF->FOBDOL  := Transform(nPrcDolar    ,"@E 99,999.99")
        FFF->QUANT   := Transform(DDD->D1_QUANT,"@E 99,999.99")
        FFF->EMISSAO := DDD->D1_DTDIGIT
      MsUnLock()

      dbSelectArea("DDD")
      dbSkip()
   Enddo
   dbCloseArea()



// NOTAFISCAL DE SAIDA 

   /* Busca as 10 ultimas notas de saida efetuadas no sistema */
   cQry := "SELECT TOP 10 D2_FILIAL, D2_TOTAL, D2_DOC, D2_SERIE, D2_COD, D2_PRCVEN, D2_QUANT, F2_EMISSAO, A1_NOME "
   cQry +=   "FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SF2")+" SF2, "+RetSQLName("SF4")+" SF4, "+RetSQLName("SA1")+" SA1 "
   cQry +=  "WHERE SD2.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND "
   cQry +=        "D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND "
   cQry +=        "D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND "
   cQry +=        "D2_TIPO = 'N' AND D2_COD = '"+XXX->B1_COD+"' AND "
   cQry +=        "D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' "
   cQry +=  "ORDER BY F2_EMISSAO, D2_DOC"

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "YYY", .T., .F. )
   TCSetField("YYY","D2_DTDIGIT","D",8,0)
   TCSetField("YYY","F2_EMISSAO","D",8,0)
                                        
   dbGoTop()
   While !Eof()
      dbSelectArea("WWW")
      RecLock("WWW",.T.)
        WWW->CLIENTE := YYY->A1_NOME
        WWW->NOTAFIS := YYY->D2_DOC
        WWW->SERIE   := YYY->D2_SERIE
        WWW->QUANT   := Transform(YYY->D2_QUANT  ,"@E 999,999,999.99")
        WWW->PRCVEN  := Transform(YYY->D2_PRCVEN ,"@E 999,999,999.99")
        WWW->VALOR   := Transform(YYY->D2_TOTAL  ,"@E 999,999,999.99")
        WWW->EMISSAO := YYY->F2_EMISSAO
        WWW->FILIAL  := YYY->D2_FILIAL 
      MsUnLock()

      dbSelectArea("YYY")
      dbSkip()
   Enddo
   dbCloseArea()

// -----------------------------------------------------
             

   // Pega o preco atual de varejo e atacado
   _nPVare := SB0->B0_PRV1
   _nPAtac := DA1->DA1_PRCVEN  //SB0->B0_PRV2

   cDtFech := Dtos(Ctod(""))
   SB9->(dbSetOrder(1))
   SB9->(dbSeek(XFILIAL("SB9")+XXX->B1_COD+"01Z",.T.))
   SB9->(dbSkip(-1))
   If SB9->(XFILIAL("SB9"))+XXX->B1_COD+"01" == SB9->(B9_FILIAL+B9_COD+B9_LOCAL)  // Pega o saldo inicial
      _nInici := SB9->B9_QINI
      cDtFech := Dtos(SB9->B9_DATA)
   Endif
   
   SB2->(dbSetOrder(1))
   If SB2->(dbSeek(XFILIAL("SB2")+XXX->B1_COD+"01")) // Pega o saldo atual
      _nAtual := SB2->B2_QATU
   Endif

//   If SM0->M0_CODIGO+SM0->M0_CODFIL <> "0100"
      cQry := "SELECT SUM(D1_QUANT) D1_QUANT FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SF4")+" B "
      cQry += "WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND D1_TES=F4_CODIGO AND F4_ESTOQUE = 'S' AND "
      cQry += "D1_COD = '"+XXX->B1_COD+"' AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND D1_DTDIGIT > '"+cDtFech+"'"
//   Else
//      cQry := "SELECT SUM(D1_QUANT) D1_QUANT FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SF4")+" B , "
//      cQry += RetSQLName("SF1")+" C WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND C.D_E_L_E_T_=' ' AND "
//      cQry += "D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND "
//      cQry += "D1_LOJA=F1_LOJA AND D1_TES=F4_CODIGO AND F4_ESTOQUE = 'S' AND F1_COND <> '035' AND "
//      cQry += "D1_COD = '"+XXX->B1_COD+"' AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND D1_DTDIGIT > '"+cDtFech+"'"
//   Endif

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TTT", .T., .F. )
   _nQtdAt := D1_QUANT
   dbCloseArea()

   _nVenda := _nInici + _nQtdAt - _nAtual

   If Empty(vUlt)
      RecLock("FFF",.T.)
      FFF->VALFOB := Transform(0,"@E 99,999.99")
      FFF->VALOUT := Transform(0,"@E 99,999.99")
      FFF->FOBDOL := Transform(0,"@E 99,999.99")
      FFF->QUANT  := Transform(0,"@E 99,999.99")
      MsUnLock()
      RecLock("PPP",.T.)
      PPP->VAREJO := Transform(_nPVare,"@E 99,999.99")
      PPP->ATACAD := Transform(_nPAtac,"@E 99,999.99")
      MsUnLock()
   Else
      For x:=1 To Len(vUlt)
         RecLock("PPP",.T.)
         PPP->DTFAT  := vUlt[x,1]
         PPP->VAREJO := Transform(vUlt[x,2],"@E 99,999.99")
         PPP->ATACAD := Transform(vUlt[x,3],"@E 99,999.99")
         MsUnLock()
      Next
   Endif

   dbSelectArea("PPP")
   dbGoTop()
   dbSelectArea("FFF")
   dbGoTop()        
   dbSelectArea("WWW")
   dbGoTop()        
   
   dbSelectArea(cAlias)
Return

Static Function NovoPreco()
   Local cVar := Upper(Trim(ReadVar()))
   Local lRet

   If lRet := Positivo()
      If cVar == "NPRCVENS"
         //nPrcSimS := Round(100 - (nPrcCusA / nPrcVenS) * 100,2)
         nPrcSimS := ((nPrcVenS - nPrcCusA) / nPrcCusA) * 100
      Else
         nPrcVenS := nPrcCusA+(nPrcCusA * (nPrcSimS/100))
      Endif
   Endif

Return lRet

Static Function Atualiza(nOpc)
   SB1->(dbSetOrder(1))
   If nOpc == 3 .Or. SB1->(dbSeek(XFILIAL("SB1")+XXX->B1_COD))
      Private aPos:= { 8, 4, 11, 74 }
      Private cCadastro := "Atualização de Produtos"
      Private aRotina   := {{ "Pesquisar" ,"AxPesqui"   , 0 , 1},;			//
                            { "Visualizar","LJ110Visual", 0 , 2},;		//
                            { "Incluir"   ,"LJ110Inclui", 0 , 3},;		//
                            { "Alterar"   ,"LJ110Altera", 0 , 4, 02 },;	//
                            { "Excluir"   ,"LJ110Deleta", 0 , 5, 01 },; //
                            { "Copia"     ,"LJ110Copia" , 0 , 3, 0, .F. }} //

      Private INCLUI    := (nOpc == 3)
      Private ALTERA    := (nOpc == 4)
      Private aMemos    := {}
      Private lConfSx8  := (ExistBlock("CONFSX8")) // Atualiza o SX8
      Private lAtuB0Fil := (ExistBlock("ATUB0FIL")) // Gera no SB0 registros para todas as filiais

      // Carrega no array os campos MEMO
      LJ110Memo()

      If nOpc == 2
         LJ110Visual("SB1",SB1->(Recno()),nOpc)
      ElseIf nOpc == 3
         If LJ110Inclui("SB1",SB1->(Recno()),nOpc) == 1
            AtualPreco(SB1->B1_COD,.T.)
         Endif
      Else
         If LJ110Altera("SB1",SB1->(Recno()),nOpc) == 1
            AtualPreco(SB1->B1_COD,.T.)
         Endif
      Endif
   Else
      Alert("Produto não encontrado !")
   Endif

Return

Static Function AtualPreco(cProduto,lRefresh)

   SB0->(dbSetOrder(1))
   SB0->(dbSeek(XFILIAL("SB0")+cProduto))
   SB1->(dbSetOrder(1))
   SB1->(dbSeek(XFILIAL("SB1")+cProduto))
   SB2->(dbSetOrder(1))
   SB2->(dbSeek(XFILIAL("SB2")+cProduto))

   cDescri  := SB1->B1_ESPECIF //DESC

   nPrcVenA := SB0->B0_PRV1
   nPrcCusA := SB2->B2_CM1
// nPrcSimA := 100 - (nPrcCusA / nPrcVenA) * 100
   nPrcSimA := ((nPrcVenA - nPrcCusA)/ nPrcCusA) * 100

   nPrcVenS := nPrcVenA                 
   
   nPrcSimS := nPrcSimA

   If lRefresh
      oPrcA:Refresh()
      oCusA:Refresh()
      oMarA:Refresh()
      oPrcS:Refresh()
      oCusS:Refresh()
      oMarS:Refresh()
   Endif

Return
                
//*******************************************************************************************************************************
// Conulta Sql com a finalidade de mostrar o
//*******************************************************************************************************************************
Static Function fTabTemp(cwProd)
 Local _cQry  := ""     
 Local vwAux  := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
                           
 _cQry := "SELECT "
 _cQry +=   "ISNULL(S_06200,0) S_06200,ISNULL(S_DEPOS,0) S_DEPOS,ISNULL(S_06300,0) S_06300,ISNULL(S_04208,0) S_04208,ISNULL(S_SILVES,0) S_SILVES,"
 _cQry +=   "ISNULL(R_06200,0) R_06200,ISNULL(R_DEPOS,0) R_DEPOS,ISNULL(R_06300,0) R_06300,ISNULL(R_04208,0) R_04208,ISNULL(R_SILVES,0) R_SILVES,"
 _cQry +=   "ISNULL(P_06200,0) P_06200,ISNULL(P_06300,0) P_06300,ISNULL(P_04208,0) P_04208,ISNULL(P_SILVES,0) P_SILVES, "
 _cQry +=   "ISNULL(C_06200,0) C_06200,ISNULL(C_06300,0) C_06300,ISNULL(C_04208,0) C_04208,ISNULL(C_SILVES,0) C_SILVES  "
 _cQry += "FROM " + RetSqlName("SB1") + " A "

 // RELACIONAMENTO PARA BUSCAR OS SALDOS EM ESTOQUE 
 _cQry += "LEFT OUTER JOIN
 _cQry +=               "( SELECT B2_COD, [00-MATRIZ-06200     ] S_06200, "
 _cQry +=                                "[00-MATRIZDEP        ] S_DEPOS, "
 _cQry +=                                "[01-MATRIZ 06300     ] S_06300, "
 _cQry +=                                "[02-MATRIZ 04208     ] S_04208, "
 _cQry +=                                "[03-FILIAL 04        ] S_SILVES "
 _cQry +=                    "FROM ( "
 _cQry +=                            "SELECT B2_COD, CASE "
 _cQry +=                                               "WHEN B2_LOCAL = '13' THEN '00-MATRIZDEP        ' "
 _cQry +=                                                                    "ELSE LJ_NOME "
 _cQry +=                                           "END LJ_NOME, B2_QATU "
 _cQry +=                               "FROM " + RetSqlName("SB2") + " A "
 _cQry +=                            "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
 _cQry +=                               "ON B2_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
 _cQry +=                            "WHERE A.D_E_L_E_T_ = '' " //B2_LOCAL IN ('01','13') 
 _cQry +=                          ") A "
 _cQry +=                 "PIVOT ( SUM ( B2_QATU ) FOR LJ_NOME IN ([00-MATRIZ-06200     ], "
 _cQry +=                                                      "[00-MATRIZDEP        ], [01-MATRIZ 06300     ], "
 _cQry +=                                                      "[02-MATRIZ 04208     ], [03-FILIAL 04        ]) ) PVT1 ) C "
 _cQry +=    "ON B1_COD=C.B2_COD "

 // RELACIONAMENTO PARA BUSCAR OS SALDOS RESERVADOS 
 _cQry += "LEFT OUTER JOIN
 _cQry +=               "( SELECT B2_COD, [00-MATRIZ-06200     ] R_06200, "
 _cQry +=                                "[00-MATRIZDEP        ] R_DEPOS, "
 _cQry +=                                "[01-MATRIZ 06300     ] R_06300, "
 _cQry +=                                "[02-MATRIZ 04208     ] R_04208, "
 _cQry +=                                "[03-FILIAL 04        ] R_SILVES "
 _cQry +=                    "FROM ( "
 _cQry +=                            "SELECT B2_COD, CASE "
 _cQry +=                                               "WHEN B2_LOCAL = '13' THEN '00-MATRIZDEP        ' "
 _cQry +=                                                                    "ELSE LJ_NOME "
 _cQry +=                                           "END LJ_NOME, B2_RESERVA "
 _cQry +=                               "FROM " + RetSqlName("SB2") + " A "
 _cQry +=                            "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
 _cQry +=                               "ON B2_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
 _cQry +=                            "WHERE A.D_E_L_E_T_ = '' " //B2_LOCAL IN ('01','13') "
 _cQry +=                          ") A "
 _cQry +=                 "PIVOT ( SUM ( B2_RESERVA ) FOR LJ_NOME IN ([00-MATRIZ-06200     ], "
 _cQry +=                                                      "[00-MATRIZDEP        ], [01-MATRIZ 06300     ], "
 _cQry +=                                                      "[02-MATRIZ 04208     ], [03-FILIAL 04        ]) ) PVT1 ) F "
 _cQry +=    "ON B1_COD=F.B2_COD "

 // RELACIONAMENTO PARA BUSCAR OS SALDOS REFERENTES A PEDIDO DE VENDAS EM ABERTO
 _cQry += "LEFT OUTER JOIN "
 _cQry +=               "( SELECT C6_PRODUTO, C6_LOCAL, [00-MATRIZ-06200     ] P_06200, "
 _cQry +=                                              "[01-MATRIZ 06300     ] P_06300, "
 _cQry +=                                              "[02-MATRIZ 04208     ] P_04208, "
 _cQry +=                                              "[03-FILIAL 04        ] P_SILVES "
 _cQry +=                    "FROM ( "
 _cQry +=                            "SELECT C6_PRODUTO, LJ_NOME, C6_LOCAL, (C6_QTDVEN-C6_QTDENT) SALDO "
 _cQry +=                               "FROM " + RetSqlName("SC6") + " A "
 _cQry +=                  "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
 _cQry +=                    "ON C6_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
 _cQry +=                 "WHERE A.D_E_L_E_T_='' "  
 _cQry +=                ") A "
 _cQry +=                "PIVOT ( SUM ( SALDO ) FOR LJ_NOME IN ([00-MATRIZ-06200     ],[01-MATRIZ 06300     ], "
 _cQry +=                                                   "[02-MATRIZ 04208     ],[03-FILIAL 04        ]) ) PVT2 ) D "
 _cQry +=    "ON B1_COD=C6_PRODUTO "

 // RELACIONAMENTO PARA BUSCAR OS SALDOS REFERENTES A PEDIDO DE VENDAS EM ABERTO
 _cQry += "LEFT OUTER JOIN "
 _cQry +=               "( SELECT D1_COD, D1_LOCAL, [00-MATRIZ-06200     ] C_06200, "
 _cQry +=                                          "[01-MATRIZ 06300     ] C_06300, "
 _cQry +=                                          "[02-MATRIZ 04208     ] C_04208, "
 _cQry +=                                          "[03-FILIAL 04        ] C_SILVES "
 _cQry +=                    "FROM ( "
 _cQry +=                            "SELECT D1_COD, LJ_NOME, D1_LOCAL, (D1_QUANT) SALDO "
 _cQry +=                               "FROM " + RetSqlName("SD1") + " A "
 _cQry +=                  "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
 _cQry +=                    "ON D1_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' " 
 _cQry +=                 "WHERE A.D_E_L_E_T_='' AND D1_TES = '' "  
 _cQry +=                ") A "
 _cQry +=                "PIVOT ( SUM ( SALDO ) FOR LJ_NOME IN ([00-MATRIZ-06200     ],[01-MATRIZ 06300     ], "
 _cQry +=                                                   "[02-MATRIZ 04208     ],[03-FILIAL 04        ]) ) PVT3 ) G "
 _cQry +=    "ON B1_COD=D1_COD "

 _cQry += "WHERE A.D_E_L_E_T_='' AND B1_COD = '" + cwProd + "' "   // BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "

 _cQry += "ORDER BY B1_ESPECIF "
                                                                                                         
  dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMP1", .T., .T. )
       
  If !TMP1->(Eof()) 
    vwAux := { TMP1->S_06200,TMP1->S_06300,TMP1->S_04208,TMP1->S_DEPOS,TMP1->S_SILVES,;
               TMP1->R_06200,TMP1->R_06300,TMP1->R_04208,TMP1->R_DEPOS,TMP1->R_SILVES,;
               TMP1->P_06200,TMP1->P_06300,TMP1->P_04208, 0           ,TMP1->P_SILVES,;
               TMP1->C_06200,TMP1->C_06300,TMP1->C_04208, 0           ,TMP1->C_SILVES }
  EndIf 
  
  TMP1->(dbCloseArea())

Return vwAux 