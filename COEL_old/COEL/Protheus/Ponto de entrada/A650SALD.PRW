#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

User Function A650sald()        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

Local _nQtdStok 
Local cPerg, _recSX1
Local cQry
Local _nSdoPed
Local _lPedido := ( Type("aCols") <> "U" )                                   ///Carlos: Este P.E. fica em loop varrendo os empenhos da op em questao.
                       
SetPrvt("_CALIAS,_NINDEX,_NRECNO,_NINDSC2,_NRECSC2,_NINDSB2")
SetPrvt("_NRECSB2,_NINDSC6,_NRECSC6,_CCODIGO,_CALMOX,_NQTDVEN")
SetPrvt("_CNUMPED,_CITEMPED,_NQTDSC6,_NQTDSC2,_NQTDSB2,_NQTDSTOK")

IF ( M->cNumEmp == "0301" .AND. !_lPedido )                                  ///Carlos: Coelmatic/Manaus - a partir de 27/03/2014

	_nQtdStok := SB2->B2_QATU
	
	IF ( _nQtdStok <> 0 )   

		cQry := "SELECT SUM(C6_QTDVEN) C6_QTDVEN,SUM(C6_QTDENT) C6_QTDENT"
		cQry += " FROM "+RetSqlName("SC6")
		cQry += " WHERE D_E_L_E_T_ = ' '"
		cQry += " AND C6_FILIAL = '"+xFilial("SC6")+"'"
		cQry += " AND C6_NUMOP <> ' '"                                          ///<--- valido somente para pedidos amarrados a op.
		cQry += " AND C6_PRODUTO = '"+SC6->C6_PRODUTO+"'"
		cQry += " AND C6_NUM+C6_ITEM <> '"+(SC6->C6_NUM+SC6->C6_ITEM)+"'"
		cQry += " AND C6_QTDVEN > C6_QTDENT "

		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
	
		_nSdoPed  := ( TMP->C6_QTDVEN - TMP->C6_QTDENT ) 
		_nQtdStok := ( _nQtdStok - _nSdoPed )
		
		TMP->(dbCloseArea())
		
		IF ( _nQtdStok < 0 )                     ///Aqui, pode ser que, primeiro foi faturado os pedidos e, ainda nao houve apontamento pra gerar saldo em estoque.
			_nQtdStok := 0
		ELSEIF ( _nQtdStok <> 0 )                ///Aqui, o saldo em estoque é o saldo dos pedidos que ainda nao foram faturados.
			_nSdoPed := ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) 
			
			_nOpc := Aviso("Pedido/Item: "+SC6->C6_NUM+" / "+SC6->C6_ITEM,;
								"Existe saldo em estoque para este Produto: "+RTRIM(SC6->C6_PRODUTO)+CHR(13)+CHR(10)+;
								"Saldo em Estoque: "+TRANSF(_nQtdStok,"@E 999,999")+chr(13)+chr(10)+;
								"Saldo do Pedido : "+TRANSF(_nSdoPed,"@E 999,999")+chr(13)+chr(10)+;
								"Gera O.P. com saldo Total deste Pedido?",{"Sim","Não"},3)	

			IF ( _nOpc == 1 )
				_nQtdStok := 0                 ///Saldo total. Se selecionado "Não", assume a validacao do MATA650.
			ENDIF
		ENDIF	
	
	ENDIF
	
ELSE
	//****************************************************************************
	//*** Programa: A650SALDO                                                  ***
	//*** Autor: Claudio Luiz Alonso  				    	Data: 13/08/2002   ***
	//***        CRD Informatica Ltda                                          ***
	//*** Finalidade: Calculo da quantidade a ser aberta da Ordem de Producao  ***
	//*** Especifico Coel Controles Eletricos                                  ***
	//****************************************************************************

	//Alert("Estou no Ponto - A650SALDO - OP")
	//Alert("Alias: " + ALIAS())
	//Alert("SB2->B2_COD " + SB2->B2_COD)
	//Alert("SC6->C6_NUM " + SC6->C6_NUM)
	_cCodigo  := SB2->B2_COD

	// Salva Alias Aberto
	_cAlias := Alias()
	_nIndex := IndexOrd()
	_nRecno := Recno()

	cPerg:= "MTA651    08"
					  
	dbSelectArea("SX1")
	_recSX1:= recno()
	dbseek(cPerg)
	_DatEnt:= X1_CNT01
	_DatEnt:= Stod(_DatEnt)//ctod(&_DatEnt)
	dbgoto(_recSX1)

	//Pergunte(cPerg,.f.)

	dbSelectArea("SC2")
	_nIndSC2 := IndexOrd()
	_nRecSC2 := Recno()  
	dbSetOrder(2)


	// Salva Arquivo SB2 ...

	dbSelectArea("SB2")
	_nIndSB2 := IndexOrd()
	_nRecSB2 := Recno()
	dbSetOrder(1)

	// Salva Arquivo SC6 ...

	DBUSEAREA(.T.,"TOPCONN",RETSQLNAME("SC6"),"NEWSC6",.T.)
	ORDLISTADD( RETSQLNAME("SC6") + "2")
	_nRecSC6 := Recno()
	//_cCodigo  := SC6->C6_PRODUTO
	_cAlmox   := SC6->C6_LOCAL
	_nQtdVen  := SC6->C6_QTDVEN - SC6->C6_QTDENT
	_cNumPed  := SC6->C6_NUM
	_cItemPed := SC6->C6_ITEM
	_nQtdSC6  := 0
	_nQtdSC2  := 0
	_nQtdSB2  := 0
	_nQtdStok := 0

	//dbSetOrder(2)
					  
	If dbSeek(xFilial("SC6")+_cCodigo)
		While xFilial("SC6")+_cCodigo == C6_FILIAL + C6_PRODUTO .And. !Eof()
			
			If NEWSC6->C6_NUM + NEWSC6->C6_ITEM == _cNumPed + _cItemPed    //Desconsidero se for ele mesmo
				dbSkip()
				Loop
			Endif                   

			If (NEWSC6->C6_QTDVEN - NEWSC6->C6_QTDENT) <= 0      // Desconsidera quando o pedido ja foi totalmente entregue
				dbSkip()
				Loop
			Endif
			
			If NEWSC6->C6_ENTREG > _DatEnt	// Verifica se ja gerou OP para este pedido de venda
				dbSkip()
				Loop
			Endif

			If Empty(NEWSC6->C6_OP)  // Só filtra os PV´s que já tem Verifica se ja gerou OP para este pedido de venda
				dbSkip()
				Loop
			Endif
	  
			_nQtdSC6 := _nQtdSC6 + (NEWSC6->C6_QTDVEN - NEWSC6->C6_QTDENT)
			 
			dbSkip()
		Enddo
	Endif

	//Alert("Saldo SC6 :" + Alltrim(Str(_nQtdSC6)))
			
	dbSelectArea("SC2")
	If dbSeek(xFilial("SC2")+_cCodigo) 
		While xFilial("SC2")+_cCodigo == SC2->C2_FILIAL+SC2->C2_PRODUTO .And. !Eof()
			If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0 .or. !empty(SC2->C2_DATRF)
				dbSkip()
				Loop
			Endif
			_nQtdSC2 := _nQtdSC2 + (SC2->C2_QUANT - SC2->C2_QUJE)
			dbSkip()
		Enddo
	Endif
	//Alert("Saldo SC2 :" + Alltrim(Str(_nQtdSC2)))

	dbSelectArea("SB2")
	//If dbSeek(xFilial("SB2") + _cCodigo + _cAlmox)
	  _nQtdSB2 := SB2->B2_QATU
	//Endif

	//Alert("Saldo SB2 :" + Alltrim(Str(_nQtdSB2)))

	_nQtdStok := (_nQtdSB2 + _nQtdSC2) - _nQtdSC6 // Utilizado anteriormente 407

	// Volta Areas Originais !!!

	dbSelectArea("NEWSC6")
	dbclosearea()
	//dbSetOrder(_nIndSC6)
	//dbGoTo(_nRecSC6)

	dbSelectArea("SC2")
	dbSetOrder(_nIndSC2)
	dbGoTo(_nRecSC2)

	dbSelectArea("SB2")
	dbSetOrder(_nIndSB2)
	dbGoTo(_nRecSB2)

	//ALert("Qtde de Estoque " + _cCodigo + " ... " + Alltrim(Str(_nQtdStok)))
ENDIF

Return(_nQtdStok)     