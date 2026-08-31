#INCLUDE "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PLESTP03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 20/08/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a leitura física das mercadorias de entrada          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PCESTP03()
	Local oDlg, oDoc, oSer
	Local oFont1   := TFont():New("Courier New", 8.5,15,.T.,.T.,,,15)
	Local oFont2   := TFont():New("Courier New", 7.5,15,.T.,.T.,,,15)
		
	Private cCadastro := "Entrada Física de Mercadorias"
	Private cNumNota  := Space(TamSX3("F1_DOC"  )[1])
	Private cSerNota  := Space(TamSX3("F1_SERIE")[1])
	Private nQtdBarra := 0
	
		DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 TO 45,118 OF oMainWnd
		
		@ 020,005 SAY "Nota Fiscal"          SIZE 40,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		@ 016,055 MSGET oDoc   VAR cNumNota  Picture "@!" F3 "SF1" /*VALID BuscaDocLer(.F.)*/ SIZE 60,10 PIXEL OF oDlg FONT oFont2
		@ 035,125 SAY "Serie"                SIZE 60,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		@ 031,175 MSGET oSer   VAR cSerNota Picture "@!" /*VALID CodigoBarras()*/ SIZE 60,10 PIXEL OF oDlg FONT oFont2 WHEN lFalta
		
		//@ 050,002 LISTBOX oLbx VAR cVar FIELDS HEADER "Item","Produto","Descrição","Quantidade","Qtd.Fisica" SIZE 460,110 OF oDlg PIXEL FONT oFont1
		
		//@ 190,002 LISTBOX oLbx2 VAR cVar2 FIELDS HEADER "Volumes","Item","Numero" SIZE 260,60 OF oDlg PIXEL FONT oFont1
		
		//@ 016,415 SAY "Volume"                       SIZE 40,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		//@ 016,445 SAY oVol VAR cVolume  Picture "@!" SIZE 30,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
		
		@ 016,360 BUTTON oBotao PROMPT "&Fechar" SIZE 40,12 OF oDlg PIXEL Action oDlg:End()
		
		//AtualizaItens()
		
		//@ 170,005 SAY "Itens Restantes"    SIZE 070,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		//@ 170,065 SAY oIte VAR nTotItem Picture "@E 999999" SIZE 90,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
		
		//@ 170,175 SAY "Quant. Restante"    SIZE 080,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		//@ 170,235 SAY oQtd VAR nTotQtd  Picture "@E 99999999" SIZE 100,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
		
		//@ 170,345 SAY "Quant. Lidas"       SIZE 080,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		//@ 170,405 SAY oLid VAR nQtdLido Picture "@E 999,999,999.99" SIZE 120,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
		
		@ 035,005 SAY "Quantidade"         SIZE 60,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
		@ 033,055 MSGET oQBa   VAR nQtdBarra Picture "@E 999999" /*VALID ValidaQtd()*/ SIZE 60,10 PIXEL OF oDlg FONT oFont2
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
					EnchoiceBar(oDlg,{|| nOpcA:=If(lFalta,0,1),If(lModFat.And.nOpcA==1,oDlg:End(),) },{|| oDlg:End() })
Return