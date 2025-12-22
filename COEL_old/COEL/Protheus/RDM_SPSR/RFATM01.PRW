#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function RFATM01()

/*
+---------------------------------------------------------------------------+
|  Funcao    |RFATM01   | Autor | Rogerio B. Oliveira   | Data |26/04/04    |
+---------------------------------------------------------------------------+
|  Descricao |Importacao de arquivo texto para geracao de pedidos de venda, |
|            |a partir de pedidos digitados no site                         |
+---------------------------------------------------------------------------+
|   Uso      |Especifico site COEL                                          |
+---------------------------------------------------------------------------+
| Alteracao  |Gravar no pedido o preco da tabela do Protheus e nao mais     |
| por Rejane |o preco do arquivo texto, pois houveram divergencias.         |
| 30/07/2002 |Gravar a observacao em um campo novo, para aumentar o tamanho.|
+---------------------------------------------------------------------------+
*/

SetPrvt("_ACABEARQ,_AITEMARQ,_ACABECALHO,_AITENS,_CCLIENTE")
SetPrvt("_CLOJA,_CTIPOCLI,_CCONDPAG,_NITEM,_CFILE,_CTEXTO")
SetPrvt("_C,_CLINE,_CFILEIT,_CTEXTOIT,_NCONT,_D")
SetPrvt("_CLINEIT,_CPEDIDO,I,NX,_ACABEC,_CALIAS")
SetPrvt("_NINDEX,_NRECNO,_AAUTOSC5,_AAUTOSC6,_ALINHA")
SetPrvt("_CCODIGO,_CERRO,_ARETORNO,")



_cPerg := "RFAT01"
_Passei:= .f.
pergunte(_cPerg,.F.)  //chama duas vezes a funcao pergunte. A outra esta no botao _Pergunta()
/*
@0,0 TO 380,520 DIALOG oDlg TITLE "Importacao pedidos do site COEL"
@20,5 TO 165,255
@035,010 Say "Este programa ira gerar pedidos de venda a partir de dados gerados"
@045,010 Say "pelo site da COEL. Ao final, pode-se emitir relatorio de status.  "
@172,170 BMPBUTTON TYPE 2 ACTION Fim()       //190
@172,198 BMPBUTTON TYPE 1 ACTION Processa({|| GeraPed() },"Processando...") //GeraPed()   //218
@172,226 BMPBUTTON TYPE 5 ACTION _Pergunta()
ACTIVATE DIALOG oDlg CENTERED
*/
@0,0 TO 250,520 DIALOG oDlg TITLE "Importacao pedidos do site COEL"
@20,5 TO 065,255
@035,010 Say "Este programa ira gerar pedidos de venda a partir de dados gerados"
@045,010 Say "pelo site da COEL. Ao final, pode-se emitir relatorio de status.  "
@090,170 BMPBUTTON TYPE 2 ACTION Fim()       //190
@090,198 BMPBUTTON TYPE 1 ACTION Processa({|| GeraPed() },"Processando...") //GeraPed()   //218
@090,226 BMPBUTTON TYPE 5 ACTION _Pergunta()
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function fim()
Close(oDlg)
If _passei
	DBSELECTAREA("WTEMP")
	DBCLOSEAREA()
	
	DBSELECTAREA("TEMP")
	DBCLOSEAREA()
EndIf
return


/*
+---------------------------------------------------------------------------+
|  Funcao    |_Pergunta | Autor | Rejane Ap. Ribeiro    | Data |  15/04/02  |
+---------------------------------------------------------------------------+
|  Descricao |Chama os parametros.                                          |
+---------------------------------------------------------------------------+
*/
Static Function _Pergunta()
pergunte(_cPerg,.T.)
return
/*
+---------------------------------------------------------------------------+
|  Funcao    |GeraPed   | Autor | Rejane Ap. Ribeiro    | Data |  21/12/01  |
+---------------------------------------------------------------------------+
|  Descricao |Rotina para geracao do pedido de vendas, usando arquivos TXT. |
+---------------------------------------------------------------------------+
*/

Static Function GeraPed()

Local _aVetor     := {}
Local lMsErroAuto := .F.
Local nReg        := 0
Local cQuery      := ""
Local _nReg       := 0
Local _cQuery     := ""

_aCabearq   := {}  //array para guardar os dados extraidos do arquivo texto do cliente (cabecalho)
_aItemarq   := {}  //array para guardar os dados extraidos do arquivo texto do cliente (itens)
_aCabecalho := {}  //array para gerar o pedido de venda (cabecalho)
_aItens     := {}  //array para gerar o pedido de venda (itens)
_cPedCli    := ""
_cPedido    := ""
_cCliente   := ""
_cLoja      := ""
_cCondPag   := ""
_lPre       := .F.
_cTESImp    := ""
_nItem      := 1
_cLetra     := ""

_aRetorno		:= {}   // Array de retorno da funcao.  Possui duas posicoes, sendo:
// 1a.) Codigo da Pedido:  Caso seja brancos, verificar codigo de erro.
// 2.a) Codigo de Erro: 00- Sucesso; 02-Pedido nao Inserido; 03 - Array Vazio

titulo := "Status Importacao dos pedidos de venda SITE - Sequencia: "

cQuery := "Select * from COEL.dbo.SC5010"
cQuery := cQuery + " WHERE C5_FILIAL = '  ' AND"
cQuery := cQuery + " C5_EMISSAO >= '"+Dtos(mv_par01)+"' AND C5_EMISSAO <= '"+Dtos(mv_par02)+"' "
cQuery := cQuery + " ORDER BY C5_NUM"
cQuery := ChangeQuery(cQuery)
TCQuery cQuery New Alias "WTEMP"

_cQuery := "Select * from COEL.dbo.SC6010"
_cQuery := _cQuery + " WHERE C6_FILIAL = '  '"
//_cQuery := _cQuery + " EMISSAO >= '"+Dtos(mv_par01)+"' AND EMISSAO <= '"+Dtos(mv_par02)+"' "
//_cQuery := _cQuery + " WHERE EXPORTA <> '*'"
_cQuery := _cQuery + " ORDER BY C6_NUM"
_cQuery := ChangeQuery(_cQuery)
TCQuery _cQuery New Alias "TEMP"

dbSelectArea( "WTEMP" )
dbGoBottom()
nReg := Recno()
dbGoTop()

ProcRegua( nReg ) // Numero de registros a processar

While !Eof()
	
	IncProc()
	
	_cPediCanc := ""  //se o pedido nao passar pelas validacoes, o codigo fica guardado nesta var.
	
	_aCabearq := {"01",;             //Filial 01
	WTEMP->C5_NUM,;       //Numero do pedido 02
	WTEMP->C5_EMISSAO,;   //Data de emissao 03
	WTEMP->C5_CLIENTE,;   //Codigo do cliente 04
	WTEMP->C5_LOJACLI,;   //Loja Cliente 05
	WTEMP->C5_LOJAENT,;   //Loja Entrega 06
	"N",;              //Tipo do pedido 07
	WTEMP->C5_NUM,;       //Numero do Pedido do Cliente 08
	WTEMP->C5_CLPARC,;    //Se aceita Pedido Parcial 09
	WTEMP->C5_CLANTE,;    //Se aceita antecipacao do pedido 10
	"SITE",;           //Atendente 11
	WTEMP->C5_TIPOCLI,;   //Tipo do Cliente (R=Representante,C=Consumidor Final)12
	WTEMP->C5_CONDPAG,;   //Condicao de pagamento 13
	"1  ",;            //Tabela de Precos 14
	WTEMP->C5_VEND1,;     //Vendedor 15
	WTEMP->C5_DESC1,;     //Desconto 16
	WTEMP->C5_TPFRETE,;     //Frete Cif/Fob 17
	WTEMP->C5_TRANSP}      //Transportadora 18
	
	dbSelectArea("SA1")
	dbSetOrder(1) //Filial + Cod.Cliente
	if !( dbSeek(xFilial("SA1")+_aCabearq[04]) )
		aadd(_aRetorno,{_aCabearq[04],"  ","Codigo do cliente na Web nao encontrado."})
		ft_fskip()
		_cPediCanc := _aCabearq[02]
		loop
	endif
	
	_cCliente := SA1->A1_COD
	_cLoja    := SA1->A1_LOJA
	
	dbSelectArea("SA3")  //Procura pelo codigo do representante no cad. de vendedor.
	dbSetOrder(1) //codigo
	if !dbSeek(xFilial("SA3")+_aCabearq[15])
		aadd(_aRetorno,{_aCabearq[15],"  ","Codigo do Representante nao encontrado."})
		ft_fskip()
		_cPediCanc := _aCabearq[02]
	endif
	
	//_cPedCli  := _aCabearq[02] //Numero do pedido do cliente
	_cPedido := substr(_aCabearq[02],1,6)  //numero do pedido
	
	_cCaract := " ./,;-"                //caracteres que podem estar antes do parametro.
	_cTESImp := "501"                   //filial 02
	
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[01]  := "N"             //_aCabearq[07]   //C5_TIPO
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[02]  := _cCliente       //C5_CLIENTE
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[03]  := _cLoja          //C5_LOJACLI
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[04]  := SA1->A1_TIPO    //C5_TIPOCLI
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[05]  := _aCabearq[13] //iif(empty(SA1->A1_COND),"998",SA1->A1_COND)    //C5_CONDPAG
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[06]  := "1  "           //C5_TABELA
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[07]  := _aCabearq[18]  //C5_TRANSP
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[08]  := Iif(SA1->A1_TIPO$"R",_aCabearq[15],SA1->A1_VEND)     //Se o Cliente for Representante, pega o vendedor do Site, senao pega do cadastro de clientes
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[09]  := iif(empty(SA1->A1_NATUREZ),"1101      ",SA1->A1_NATUREZ) //C5_NATUREZ
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[10]  := _aCabearq[8]    //C5_PEDCLI
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[11]  := .T.             //C5_PFXAUT - Gerado automaticamente (S/N)?
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[12]  := _aCabearq[17] //iif(empty(SA1->A1_TPFRET),"F",SA1->A1_TPFRET)  //C5_TPFRETE
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[13]  := "W_"+_cPedido        //C5_NUM
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[14]  := dDataBase       //iif( empty(_aCabearq[03]),dDatabase,CTOD( substr(_aCabearq[03],1,2)+"/"+substr(_aCabearq[03],4,2)+"/"+substr(_aCabearq[03],7,2))  ) //C5_EMISSAO
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[15]  := _aCabearq[16]   //C5_DESC1
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[16]  := _cLoja          //Loja de Entrega
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[17]  := "W_"+_aCabearq[08]   //Numero do pedido do cliente
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[18]  := _aCabearq[09]   //Se o cliente aceita pedido parcial
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[19]  := _aCabearq[10]   //Se o cliente aceita antecipacao do pedido
	AADD(_aCabecalho,ARRAY(1))
	_aCabecalho[20]  := _aCabearq[11]   //Atendente
	
	//-----------------------------
	// Arquivo TXT de ITENS
	//		_cTextoIT := _nRegad(_cFileIT)
	
	
	dbSelectArea("TEMP")
	dbGoBottom()
	_nReg := Recno()
	dbGoTop()
	
	_nCont  := 1  //contador para a array que sera sempre zerada para cada novo pedido.
	_aItens := {}
	
	While !Eof()
		//	For _d:=_nItem To _nReg
		//		_cLineIT:=MemoLine(_cTextoIT,117,_d)
		_lForca := .F.  //usado no controle do loop abaixo.
		
		If TEMP->C6_NUM <> _aCabearq[02]
			dbSkip()
			Loop
		EndIf
		
		while (_cPedido # TEMP->C6_NUM) .and. !_lForca
			if !empty(_cPediCanc)
				_d := _d + 1
				_nItem := _nItem + 1
				//			   _cLineIT:=MemoLine(_cTextoIT,117,_d)
			else
				_d := _nReg + 1
				_lForca := .T.
			endif
		enddo
		if _lForca //forca a saida do laco FOR/NEXT para a gravacao do pedido.
			loop
		endif
		_cPediCanc := "" //zera para o proximo pedido.
		_aItemarq := {TEMP->C6_ITEM,;     //Item do pedido WEB 01
		TEMP->C6_PRODUTO,; //Produto 02
		TEMP->C6_QTDVEN,;  //Quantidade 03
		TEMP->C6_PRCVEN,;  //Preco liquido (Produto) 04
		TEMP->C6_ENTREG,;  //Data de emissao 05
		TEMP->C6_CLI,;     //Codigo do cliente 06
		TEMP->C6_LOJA,;    //Loja do cliente 07
		TEMP->C6_NUM}      //Numero do Pedido 08
		
		dbSelectArea("SB1")
		dbSetOrder(1) //Produto
		if !dbSeek( xFilial("SB1")+_aItemarq[02] )
			aadd(_aRetorno,{_aItemarq[02],"  ","Produto " + _aItemarq[02] + " nao encontrado no cadastro."})
			_d := _nReg + 1
			LOOP
		endif
		
		AADD(_aItens,ARRAY(17))
		_aItens[_nCont][01]  := xFilial("SC6")  //iif( _lPre,"02","01" )   //C6_FILIAL
		_aItens[_nCont][02]  := _aItemarq[01]           				   //C6_ITEM
		_aItens[_nCont][03]  := _aItemarq[02]                              //C6_PRODUTO
		_aItens[_nCont][04]  := SB1->B1_UM                                 //C6_UM
		_aItens[_nCont][05]  := _aItemarq[03]                              //C6_QTDVEN
		_aItens[_nCont][06]  := SB1->B1_PESO                               //C6_PESOBRU
		_aItens[_nCont][07]  := _aItemarq[04]                              //preco vira da tabela do Protheus.
		//_aItens[_nCont][08]  := _aItens[_nCont][05] * _aItens[_nCont][07]//C6_VALOR
		_aItens[_nCont][09]  := _cTESImp                                   //C6_TES
		_aItens[_nCont][11]  := "01"                                       //C6_LOCAL
		_aItens[_nCont][12]  := dDatabase+7 //iif( empty(CTOD(_aCabearq[03])),dDatabase,CTOD( substr(_aCabearq[03],1,2)+"/"+substr(_aCabearq[03],4,2)+"/"+substr(_aCabearq[03],7,2))  ) //C6_ENTREG
		_aItens[_nCont][13]  := _aItens[_nCont][07]                        //C6_PRUNIT //preco vira da tabela do Protheus.
		//_aItens[_nCont][14]  := "000"                                      //C6_CLASFIS
		//_aItens[_nCont][15]  := GETADVFVAL("SB1","B1_DESCPAD",XFILIAL("SB1")+_aItens[_nCont][03],1)  //C6_DESCONT
		_aItens[_nCont][16]  := SB1->B1_PRV1                               //Sera gravado pelo MTA410
		_aItens[_nCont][17]  := SB1->B1_CLGOP                              //Gera OP (N=Manaus, S=Sao Roque)
		
		
		//compara o preco das tabelas do site e do Protheus.
		//        if val(_aItemarq[10]) <> _aItens[_nCont,7]
		//  		   aadd(_aRetorno,{_cPedido,"  ","Preco produto:"+_aItens[_nCont][03]+"-SITE: "+ALLTRIM(_aItemarq[10])+" /PROTHEUS: "+alltrim(str(_aItens[_nCont,7]))+" estao divergentes."})
		//		endif
		
		_nCont := _nCont + 1
		_nItem := _nItem + 1
		//	Next _d
		
		dbSelectArea( "TEMP" )
		dbSkip()
		
	EndDo
	//-----------------------------
	// Geracao do pedido de venda
	
	IncluiPedidoVenda( _aCabecalho, _aItens)
	//-----------------------------
	// Zera variaveis e matrizes para o proximo pedido.
	//	@095,010 Say "Geracao do pedido:" + _cCodigo
	_aCabearq   := {}  //array para guardar os dados extraidos do arquivo texto do cliente (cabecalho)
	_aItemarq   := {}  //array para guardar os dados extraidos do arquivo texto do cliente (itens)
	_aCabecalho := {}  //array para gerar o pedido de venda (cabecalho)
	_aItens     := {}  //array para gerar o pedido de venda (itens)
	_cPedCli    := ""
	_cCliente   := ""
	_cLoja      := ""
	_cCondPag   := ""
	_cTESImp    := ""
	_nCont      := 1
	//------------------------------
	
	//ft_fskip()  //proximo cabecalho de pedido.
	
	dbSelectArea( "WTEMP" )
	dbSkip()
	_Passei := .t.
Enddo
//nReg := nReg+1
//EndIf
//Close(oDlg)
//--------------------------------------------------------------
// Impressao de _aRetorno (matriz contendo o log das gravacoes.

@1,0 TO 250,520 DIALOG oDlg1 TITLE "Status Geracao de Pedidos"
@20,5 TO 065,255
for _r := 1 to len(_aRetorno)
	@ 035,010 SAY "Geracao de Pedidos Finalizada."
	@ 045,010 SAY "Voce pode imprimir relatorio de status ou cancelar a impressao e voltar."
next _r
@090,190 BMPBUTTON TYPE 6 ACTION RStatus()
@090,218 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
//--------------------------------------------------------------
@0,0 TO 250,520 DIALOG oDlg TITLE "Importacao pedidos do site COEL"
@20,5 TO 065,255
@035,010 Say "Este programa ira gerar pedidos de venda a partir de dados gerados"
@045,010 Say "pelo site da COEL. Ao final, pode-se emitir relatorio de status.  "
@090,170 BMPBUTTON TYPE 2 ACTION Fim()       //190
@090,198 BMPBUTTON TYPE 1 ACTION Processa({|| GeraPed() },"Processando...") //GeraPed()   //218
@090,226 BMPBUTTON TYPE 5 ACTION _Pergunta()
ACTIVATE DIALOG oDlg CENTERED
//fClose(_nHdlIT) //fecha arquivo TXT de itens

Return(nil)


//*******************************************************************************************
Static Function IncluiPedidoVenda(_aCabecalho,_aItens)
//*******************************************************************************************

//*******************************************
// Salva tabela, indice e registro originais
//*******************************************

Local _cAlias       := Alias()
Local _nIndex       := IndexOrd()
Local _nRecno       := Recno()
Local _aAutoSC5 	:= {}
Local _aAutoSC6 	:= {}
Local _aLinha		:= {}
Local i 			:= 0
Local _cErro    	:= "00"
Local _cMensa       := "Pedido gerado com sucesso"

//_cCodigo  	        := _cPedido
_cCodigo := GetSX8Num("P10") //----> buscando a numeracao do pedido
ConfirmSX8()

If Len(_aCabecalho) > 0 .and. Len(_aItens) > 0
	
	//	_cCodigo := "W"+ substr(_cPedido,2,5) //Letra + numero do arq.
	
	Incproc("Geracao do pedido no: "+_cCodigo)
	// Verifica se ja existe pedido com mesmo codigo
	dbSelectArea("SC5")
	dbSetOrder(6)//C5_CLPEDCL
	while dbSeek( xFilial("SC5")+"W_"+_cPedido )  //so entra se o no. do pedido ja existir.
		_cErro := "02"   //Erro na Inclusao do Pedido, verificar AUTOERROR.LOG no Sigaadv
		_cMensa       := "Pedido ja existe."
		aadd(_aRetorno,{"W_"+_cPedido,_cErro,_cMensa})
		_cCodigo      := Space(06)
		return
	Enddo
	
	//	MSGBOX("Geracao do pedido no: " +_cCodigo,"ALERT")
	
	_aAutoSC5	:= 	{;
	{"C5_FILIAL"	 , xFilial("SC5")   ,      },;
	{"C5_NUM"        , _cCodigo         ,"NaoVazio().And.ExistChav('SC5')" },;
	{"C5_TIPO"	     , _aCabecalho[01]	,      },;
	{"C5_CLIENTE"	 , _aCabecalho[02]	,      },;
	{"C5_LOJACLI"	 , _aCabecalho[03]	,      },;
	{"C5_TIPOCLI"	 , _aCabecalho[04]	,      },;
	{"C5_CONDPAG"	 , _aCabecalho[05]	,      },;
	{"C5_TABELA"	 , _aCabecalho[06]	,      },;
	{"C5_TRANSP"	 , _aCabecalho[07]	,      },;
	{"C5_VEND1"	     , _aCabecalho[08]	,      },;
	{"C5_TPFRETE"    , _aCabecalho[12]	,      },;
	{"C5_EMISSAO"    , _aCabecalho[14]	,      },;
	{"C5_DESC1"      , _aCabecalho[15]	,      },; //sera gravado pelo MTA410.
	{"C5_LOJAENT"    , _aCabecalho[16]	,      },; //sera gravado pelo MTA410.
	{"C5_CLPEDCL"    , _aCabecalho[17]	,      },; //sera gravado pelo MTA410.
	{"C5_CLPARC"     , _aCabecalho[18]	,      },; //sera gravado pelo MTA410.
	{"C5_CLANTE"     , _aCabecalho[19]	,      },; //sera gravado pelo MTA410.
	{"C5_CLATEND"    , _aCabecalho[20]	,      }} //sera gravado pelo MTA410.
	
	//	{"C5_PEDCLI"     , _aCabecalho[10]	,      },;
	//	{"C5_NATUREZ"    , _aCabecalho[09]	,      },;
	For i := 1 to Len(_aItens)
		
		_aLinha := {}
		
		_aLinha := {;
		{"C6_FILIAL"    , _aItens[i,1],  			},;
		{"C6_ITEM"      , _aItens[i,2],  			},;
		{"C6_PRODUTO"   , _aItens[i,3],  			},;
		{"C6_UM"	 	, _aItens[i,4],  			},;
		{"C6_QTDVEN"    , _aItens[i,5],  			},;
		{"C6_PESOBRU"   , _aItens[i,6],  			},;
		{"C6_PRCVEN"    , _aItens[i,7],  			},;
		{"C6_PRUNIT"    , _aItens[i,13],  			},;
		{"C6_TES"	    , _aItens[i,9],  			},;
		{"C6_LOCAL"	    , _aItens[i,11],  			},;
		{"C6_ENTREG"    , _aItens[i,12],  			},;
		{"C6_CLGOP"     , _aItens[i,17],  			},;
		{"C6_NUM"       , _cCodigo     ,  			}}
		
		AAdd( _aAutoSC6, AClone( _aLinha ) )
	Next
	
	lMSHelpAuto := .f.
	lMsErroAuto := .f.
	msExecAuto({|x,y,z|Mata410(x,y,z)},_aAutoSC5,_aAutoSC6,3)
	
	If lMsErroAuto
		mostraerro()
		lErro := .T.
		//		DBSELECTAREA("WTEMP")
		//		DBCLOSEAREA()
		
		//		DBSELECTAREA("TEMP")
		//		DBCLOSEAREA()
		DisarmTransaction()
		Return
	EndIf
	// ser utilizada 3-Inclusao, 4- Alteracao e 5- Exclusao
	
	//*********************************************
	// Verica se o Pedido foi Inserido
	//*********************************************
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+_cCodigo)
	If !Found()
		_cErro := "02"   //Erro na Inclusao do Pedido, verificar AUTOERROR.LOG no Sigaadv
		_cMensa       := "Erro na inclusao do pedido."
	Else
		//---------------------------------- INICIO ------------------------------------------
		//Tratamento da filial apos gravacao do pedido
		if SM0->M0_CODFIL == "01" .and. _lPre //se a filial ativa for 01, mas o pedidos da PRE (filial 02).
			DbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek( xFilial("SC6")+_cCodigo+"01" )  //procura pelo primeiro item p/iniciar o loop
			while SC6->C6_NUM == _cCodigo
				RecLock("SC6",.F.)
				SC6->C6_MSFIL := "02"
				MsUnlock()
				dbSkip()
			enddo
			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_MSFIL := "02"
			MsUnlock()
		endif
		if SM0->M0_CODFIL == "02" .and. !_lPre //se a filial ativa for 02, mas o pedidos NAO (filial 01).
			DbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek( xFilial("SC6"+_cCodigo+"01") )  //procura pelo primeiro item p/iniciar o loop
			while SC6->C6_NUM == _cCodigo
				RecLock("SC6",.F.)
				SC6->C6_MSFIL := "01"
				MsUnlock()
				dbSkip()
			enddo
			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_MSFIL := "01"
			MsUnlock()
		endif
	EndIf
	
Else
	_cErro 		:= "03"	 // Array vazio
	_cMensa     := "Faltaram dados para gerar o pedido."
EndIf

aadd(_aRetorno,{_cCodigo,_cErro,_cMensa})


//*********************************************
// Retorna tabela, indice e registro originais
//*********************************************
DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbGoTo(_nRecno)

//Close(oDlg)
Return(_aRetorno)


/*
+---------------------------------------------------------------------------+
|  Funcao    |RStatus   | Autor | Rejane Ap.Ribeiro     | Data |30/01/02    |
+---------------------------------------------------------------------------+
|  Descricao |Relatorio com as ocorrencias da geracao do pedido de venda.   |
+---------------------------------------------------------------------------+
|   Uso      |Especifico Coel                                           |
+---------------------------------------------------------------------------+
*/
Static Function RStatus()

Private cString

Private CbTxt        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "RStatus"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1,"Faturamento", 2, 2, 1, "", 1 }
Private nLastKey     := 0
Private cbtxt      	 :=	Space(10)
Private cbcont     	 := 00
Private CONTFL     	 :=	01
Private m_pag      	 := 01
Private wnrel      	 := "RSTATUS"
Private cString 	 := "SC5"
//Local titulo         := "Status Importacao dos pedidos de venda MAKIRA - Sequencia: "+MV_PAR01 //+ substr(MV_PAR01,1,2)+"/"+substr(MV_PAR01,3,2)
aOrd := {}
nLin        := 80
cDesc1      := "Este programa tem como objetivo imprimir o relatorio 	"
cDesc2      := "de Status referente a importacao de pedidos de venda  	"
cDesc3      := "gerados automaticamente com base nos arquivos MAKIRA   "
cPict       := ""
Cabec1     	:= 	"Pedido Web       Cod.Erro     Mensagem                                                               "
Cabec2		:= 	""
imprime  	:= 	.T.

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return



//	+---------------------------------------------------------------------------+
//	|  Funcao    |RUNREPORT | Autor | Rogerio Batista   | Data |  20/09/04      |
//	+---------------------------------------------------------------------------+
//	|  Descricao | Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS   |
//	|            | monta a janela com a regua de processamento.                 |
//	+---------------------------------------------------------------------------+
//	|  Uso       | Relatorio RStatus                                            |
//	+---------------------------------------------------------------------------+


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Local nOrdem

SetRegua(RecCount())

For _nR := 1 to Len(_aRetorno)
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	@nLin,000 PSAY _aRetorno[_nR][1]                          //Codigo
	@nLin,017 PSAY _aRetorno[_nR][2]                          //Cod.erro
	@nLin,030 PSAY _aRetorno[_nR][3]                          //Mensagem
	
	nLin := nLin + 1
Next

DBSELECTAREA("WTEMP")
DBCLOSEAREA()

DBSELECTAREA("TEMP")
DBCLOSEAREA()

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return


