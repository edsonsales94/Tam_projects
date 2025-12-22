/*
®---------------------------------------------------------------------------®
| Programa  | SD1100I  | Autor |Rogerio Batista        | Data |25/07/2002   |
®---------------------------------------------------------------------------®
| Descricao | Ajusta o Custo das Transferencias por Entrada                 |
®---------------------------------------------------------------------------®
| Uso       | Coel Controles Eletricos Ltda                                 |
®---------------------------------------------------------------------------®
| ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                          |
®---------------------------------------------------------------------------®
*/

#include "rwmake.ch"
#include "font.ch"
#include "colors.ch"

User Function Sd1100i()                                       

Local	aAreaSD2 := SD2->(GetArea())
Local	aAreaSC6 := SC6->(GetArea())

Private _AAREA,_LRETURN,_DDATA,_CINDSB1,_NRECSB1,_CINDSB2
Private _NRECSB2,_CINDSB,_NRECSB

_aArea    := {alias(),IndexOrd(),Recno()}
_lReturn  := .t.
_dData    := GetMv("MV_ULMES")

//IF SM0-> MO_CODFIL =="01" aqui mudou
DbSelectArea("SD1")

If SD1->D1_TES $ "010#012#028#031#045#100"  //Tes de Transferencia
	
	DbSelectArea("SB2")
	_cIndSB2 := IndexOrd()
	_nRecSB2 := Recno()
	
	DbSetOrder(1)
	If DbSeek("02"+SD1->D1_COD+SD1->D1_LOCAL)
		Reclock("SD1",.F.)
		SD1->D1_CUSTO := SD1->D1_QUANT * SB2->B2_CM1
		SD1->D1_CUSTO2:= 0
		SD1->D1_CUSTO3:= 0
		SD1->D1_CUSTO4:= 0
		SD1->D1_CUSTO5:= 0
		MsUnlock()
		
		DbSelectArea("SB2")
		_cIndSB2A := IndexOrd()
		_nRecSB2A := Recno()
		
		DbSetOrder(1)
		DbSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL)
		Reclock("SB2",.F.)
		SB2->B2_CM1   := ( SD1->D1_CUSTO / SD1->D1_QUANT)
		SB2->B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
		MsUnlock()
		
		DbSelectArea("SB2")
		DbSetOrder(_cIndSB2)
		DbGoTo(_nRecSB2)
		
		DbSelectArea("SB2")
		DbSetOrder(_cIndSB2A)
		DbGoTo(_nRecSB2A)
		
	EndIf
ElseIf SD1->D1_TIPO=="D".AND.SD1->D1_TES=="311".AND. CEMPANT=="03"     ///Carlos: 22/05/13 --> Devolucao. Facilitar planilha do Brandao.
	IF ( !EMPTY(SD1->D1_NFORI) )
		IF ( SX3->(dbSeek("D2_X_DDOC")) )
			D1TOTAL := ( SD1->D1_TOTAL - SD1->D1_VALDESC )
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(SD1->D1_FILIAL+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI)
			IF ( !EOF() )
				RecLock("SD2",.F.)
				SD2->D2_X_DDOC  := SD1->D1_DOC+SD1->D1_SERIE
				SD2->D2_X_DDTA  := SD1->D1_DTDIGIT
				SD2->D2_X_DQTY  += SD1->D1_QUANT
				SD2->D2_X_DVLR  += D1TOTAL
				MsUnlock()
				*
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(SD1->D1_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD1->D1_COD)
				IF ( !EOF() )
					RecLock("SC6",.F.)
					IF ( EMPTY(SC6->C6_X_DDTA1) )
						SC6->C6_X_DDTA1 := SD1->D1_DTDIGIT
						SC6->C6_X_DQTY1 := SD1->D1_QUANT
						SC6->C6_X_DVLR1 := D1TOTAL        
					ELSEIF ( EMPTY(SC6->C6_X_DDTA2) )
						SC6->C6_X_DDTA2 := SD1->D1_DTDIGIT
						SC6->C6_X_DQTY2 := SD1->D1_QUANT
						SC6->C6_X_DVLR2 := D1TOTAL          
					ELSEIF ( EMPTY(SC6->C6_X_DDTA3) )
						SC6->C6_X_DDTA3 := SD1->D1_DTDIGIT
						SC6->C6_X_DQTY3 := SD1->D1_QUANT
						SC6->C6_X_DVLR3 := D1TOTAL       
					ENDIF
					MsUnlock()
				ENDIF
			ENDIF
			RestArea(aAreaSD2)
			RestArea(aAreaSC6)
		ENDIF
	ENDIF
	dbSelectArea("SD1")
EndIf
//Endif
//Implementado pelo Rogério Batista

If CFILANT == "02"
	DbSelectArea("SB1")
	_cIndSB := IndexOrd()
	_nRecSB := Recno()
	
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+SD1->D1_COD)
	
	//	If SB1->B1_CLTPCQ == "Q"
	//		MsgBox("O produto "+Alltrim(SD1->D1_COD)+" devera ser inspecionado atraves do Modulo Inspecao de Entregas, portanto a quantidade deste produto ficara armazenada no almoxarifado 98 ate a liberacao pelo Controle de Qualidade.","Produto Inspecionado - Quality","Alert")
	//		Reclock("SD1",.F.)
	//	SD1->D1_LOCAL := "98"
	//	MsUnlock()
	//	EndIf
	
	DbSelectArea("SB2")
	_cIndSB2 := IndexOrd()
	_nRecSB2 := Recno()
	
	DbSetOrder(1)
	DbSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL)
	
	If SD1->D1_LOCAL == "98"
		Reclock("SB2",.F.)
		SB2->B2_QATU := SB2->B2_QATU + SD1->D1_QUANT
		SB2->B2_CM1  := ( SD1->D1_CUSTO / SD1->D1_QUANT)
		SB2->B2_VATU1:= SB2->B2_QATU * SB2->B2_CM1
		MsUnlock()
	EndIf
	
	DbSelectArea("SB1")
	DbSetOrder(_cIndSB)
	DbGoTo(_nRecSB)
	
	DbSelectArea("SB2")
	DbSetOrder(_cIndSB2)
	DbGoTo(_nRecSB2)
	
EndIf

if CEMPANT == "03" //Modificado por Andre 20/10/14  SM0->M0_CODIGO
	///
	///30/04/2012: Baixa o pedido de compra do produto beneficiado fora.
	///            Se faz necessario porque a entrada da nota fiscal (cfop=1124/2124) ao inves de entrar com o codigo do pedido 
	///            entra com o codigo 00000005 amarrado a ordem de producao do codigo do pedido.
	///            Somente, até o momento, para a base coelmatic/manaus.
	///
	IF ( CFILANT $ "01/02" )   //Alterado por Andre 19/01/14 a pedido do Alcir Junior.
		IF ( SD1->D1_CF $ '1124 /2124 ' .AND. LEFT(SD1->D1_COD,8) == "00000005" )
			
			f_BxPedido()
			
		ENDIF
	ENDIF
	
	if SD1->D1_TIPO == "D" 
		///
		///16/04/2012: Nao eh mais necessario. Eh soh alterar o local para 60 no momento da digitacao da nota de devolucao
		///
		///reclock("SD1",.F.)
		///SD1->D1_LOCAL:= "60"
		///msunlock()
	endif
	
	if SD1->D1_TES == "304"
		_cTm    := "600"   // requisicao
		_cProd  := SD1->D1_COD
		_cLocal := "03"
		_nQuant := SD1->D1_QUANT
		_cTxt   := "DEVOLUCAO ALM.02"
		_cUM    := SD1->D1_UM
		_dData  := SD1->D1_EMISSAO
		lMsErroAuto := .F.
		aVetor:={ {"D3_FILIAL"  , "01"    , NIL},;
		aVetor:=	{"D3_TM"      , _cTm    , NIL},;
		{"D3_COD"     , _cProd  , NIL},;
		{"D3_UM"      , _cUM    , NIL},;
		{"D3_LOCAL"   , _cLocal , NIL},;
		{"D3_EMISSAO" , _dData  , NIL},;
		{"D3_QUANT"   , _nQuant , NIL},;
		{"D3_X_OBS"   , _cTxt   , NIL}}
		///
		MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao
		///
		If lMsErroAuto
			Alert("Problemas na gravacao da movimentacao de estoque. Notifique o departamento de informatica.")
		endif
	endif
endif

DbSelectArea(_aArea[1])
DbSetOrder(_aArea[2])
DbGoTo(_aArea[3])



//------------------------DAQUI PARA BAIXO NFE DE IMPORTAÇÃO ------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SDI100I ³ Autor ³FERNANDO AMORIM         ³ Data ³ 17/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³±±³PONTO DE ENTRADA PROCESSO DE NF DE ENTRADA DE IMPORTAÇÃO            ³±±
±±³ENTRADA DE DADOS AUXILIARES ITENS DA NFE ENTRADA                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ COEL                                                        ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±³                                                                       ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//If CEMPANT !$("03","09").OR.CEMPANT+CFILANT=="0302"

If CEMPANT ==  "03"
	_nBaseIPI   := 0
	_naliqIPI   := 0
	_nvalIPI    := 0
	_nbII       := 0
	_nII        := 0
	_nAlqII     := 0
	_nIof       := 0
	_ntaxa      := 0
	_cnunadi    := 0
	_nvdesdi    := 0
	cQuery      := ''
	_regnum     := 0
	
	
	//VERIFICA FORNECEDOR EXTRANGEIRO
	dbSelectArea("SA2")  //POSICIONA FORNECEDOR
	dbSetOrder(1) // codigo + loja
	dbSeek(xFilial("SA2")+SF1->F1_FORNECE + SF1->F1_LOJA)
	
	dbSelectArea("SB1") //POSICIONA PRODUTO
	dbSetOrder(1) // codigo
	dbSeek(xFilial("SB1")+SD1->D1_COD)
	
	dbSelectArea("CD2") //POSICIONA LIVROS DIGITAL DE IMPOSTOS SPED
	DBORDERNICKNAME("NFENTIMP") // TIPO MOV + SERIE + NOTA + ITEM + PRODUTO + IMP
	dbSeek(xFilial("CD2")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_COD )
	
	dbSelectArea("SD1")
	
	if  sf1->f1_formul == "S" .and. SA2->A2_EST == "EX"       //se nota de importação
		
		@ 000,000 TO 350,450 DIALOG oDlg1 TITLE "Digite dados do item do produto: " +  sd1->d1_cod
		
		@ 020,010 SAY "Base I.I.:"
		@ 020,060 Get _nbII PICTURE "@e 999,999,999.99" SIZE 50,02
		@ 030,010 SAY "I.I.:"
		@ 030,060 Get _nII PICTURE "@e 999,999,999.99" SIZE 50,02
		@ 040,10  Say "Aliq. I.I.(%):"
		@ 040,60  Get _nAlqII PICTURE "@e 999
		@ 050,010 SAY "IOF.:"
		@ 050,060 Get _nIof PICTURE "@e 999,999,999.99" SIZE 50,02
		
		@ 060,010 SAY "Taxa sicomex:"
		@ 060,060 Get _ntaxa PICTURE "@e 999,999,999.99" SIZE 50,02
		@ 070,010 SAY "Numero adição:"
		@ 070,060 Get _cnunadi  PICTURE "@E 999" SIZE 34,02
		@ 080,010 SAY "Vlr Adic desc DI:"
		@ 080,060 Get _nvdesdi PICTURE "@e 999,999,999.99" SIZE 50,02
		
		
		//     if  sb1->b1_ipi > 0  //se o produto possui ipi
		//
		//        @ 090,010 SAY "Base IPI:  "
		//        @ 090,060 Get _nBaseIPI PICTURE "@e 999,999,999.99" SIZE 50,02
		//        @ 100,010 SAY "Aliq. IPI: "
		//        @ 100,060 Get _naliqIPI PICTURE "@e 99.99" SIZE 50,02
		//        @ 110,010 SAY "Valor IPI: "
		//        @ 110,060 Get _nvalIPI PICTURE "@e 999,999,999.99" SIZE 50,02
		
		//     endif
		
		@ 130,090 BUTTON "_OK " SIZE 35,15 ACTION GravDAT() //chama função secundária
		//@ 240,138 BUTTON "Sai_r"  SIZE 35,15 ACTION Fim()
		ACTIVATE DIALOG oDlg1 CENTERED
		
		
	endif
	
	Return(_lReturn)
	
EndIf

//---------------------------------------------funçoes secundárias-------------------------------------------------//

Static function GravDAT()   //Grava dados

RecLock("SD1",.F.)   //GRAVA NO ITEM
REPLACE SD1->D1_BASEII  WITH _nbII
REPLACE SD1->D1_II      WITH _nII  //campo padrão do sistema
REPLACE SD1->D1_IOFIMP  WITH _nIof
REPLACE SD1->D1_TAXAIMP WITH _ntaxa
REPLACE SD1->D1_NADICAO WITH _cnunadi
REPLACE SD1->D1_VDESCDI WITH _nvdesdi
REPLACE SD1->D1_ALIQII WITH  _nAlqII

//   if  sb1->b1_ipi > 0  //se o produto possui ipi
//      REPLACE SD1->D1_BASEIPI WITH _nBaseIPI//GRAVA NO ITEM
//      REPLACE SD1->D1_IPI     WITH _naliqIPI
//      REPLACE SD1->D1_VALIPI  WITH _nvalIPI
//   endif
MsUnlock()


RecLock("SF1",.F.)   //TOTALIZA NO CABEÇALHO
//   if  sb1->b1_ipi > 0  //se o produto possui ipi
//      REPLACE SF1->F1_BASEIPI WITH (SF1->F1_BASEIPI + _nBaseIPI) //campo padrão do sistema
//      REPLACE SF1->F1_VALIPI WITH (SF1->F1_VALIPI + _nvalIPI) //campo padrão do sistema
//   endif
REPLACE SF1->F1_II WITH (SF1->F1_II + _nII) //campo padrão do sistema
REPLACE SF1->F1_TAXAIMP WITH (SF1->F1_TAXAIMP + _ntaxa)
MsUnlock()

/*  daqui para baixo movido para o nfesefaz.prw
if  sb1->b1_ipi > 0  //se o produto possui ipi

dbSelectArea("SF4")  //POSICIONA TES
dbSetOrder(1) // TES
dbSeek(xFilial("SF4")+SD1->D1_TES)

/*
dbSelectArea("CD2")
RecLock("CD2",.T.)   //INCLUI IPI NA TABELA DE LIVROS DIGITAL DE IMPOSTOS SPED
REPLACE CD2->CD2_FILIAL  WITH xFilial("CD2"), CD2->CD2_TPMOV WITH "E", CD2->CD2_DOC WITH SD1->D1_DOC, CD2->CD2_SERIE WITH SD1->D1_SERIE,;
CD2->CD2_CODFORN WITH SD1->D1_FORNECE,CD2->CD2_LOJFOR WITH SD1->D1_LOJA, CD2->CD2_ITEM WITH SD1->D1_ITEM, CD2->CD2_CODPRO WITH SD1->D1_COD,;
CD2->CD2_IMP WITH "IPI", CD2->CD2_ORIGEM WITH "0",CD2->CD2_CST WITH SF4->F4_CTIPI, CD2->CD2_BC WITH _nBaseIPI, CD2->CD2_ALIQ WITH _naliqIPI,;
CD2->CD2_VLTRIB WITH _nvalIPI, CD2->CD2_QTRIB WITH SD1->D1_QUANT
*/
/*
dbSelectArea("CD2")
_regnum := alltrim(str(RECCOUNT() + 1))
cEstrutura := "CD2010"
_qFilial   := xFilial('CD2')
_qdocto    := alltrim(SD1->D1_DOC)
_qserie    := SD1->D1_SERIE
_qcodfor   := SD1->D1_FORNECE
_qljfor    := SD1->D1_LOJA
_qitem     := SD1->D1_ITEM
_qcodpro   := alltrim(SD1->D1_COD)
_qcst      := SF4->F4_CTIPI
_qbaseipi  := alltrim(str(_nBaseIPI))
_qaliqipi  := alltrim(str(_naliqIPI))
_qvalipi   := alltrim(str(_nvalIPI))
_qqtrib    := alltrim(str(SD1->D1_QUANT))

cQuery := "INSERT INTO " + cEstrutura + " "
cQuery += "VALUES "
cQuery += "("
cQuery += "'"+_qFilial+"'"   //CD2_FILIAL
cQuery += ",'E'"             //CD2_TPMOV
cQuery += ",'"+_qdocto+"'"   //CD2_DOC
cQuery += ",'"+_qserie+"'"   //CD2_SERIE
cQuery += ",''"              //CD2_CODCLI
cQuery += ",''"              //CD2_LOJCLI
cQuery += ",'"+_qcodfor+"'"  //CD2_CODFORN
cQuery += ",'"+_qljfor+"'"   //CD2_LOJFOR
cQuery += ",'"+_qitem+"'"    //CD2_ITEM
cQuery += ",'"+_qcodpro+"'"  //CD2_CODPRO
cQuery += ",'IPI'"           //CD2_IMP
cQuery += ",'0'"             //CD2_ORIGEM
cQuery += ",'"+_qcst+"'"     //CD2_CST
cQuery += ",''"              //CD2_MODBC
cQuery += ",0"               //CD2_MVA
cQuery += ",0"               //CD2_PREDBC
cQuery += ","+_qbaseipi+""   //CD2_BC
cQuery += ","+_qaliqipi+""   //CD2_ALIQ
cQuery += ","+_qvalipi+""    //CD2_VLTRIB
cQuery += ","+_qqtrib+""     //CD2_QTRIB
cQuery += ",0"               //CD2_PAUTA
cQuery += ",''"              //CD2_COD_MUN
cQuery += ",''"              //CD2_D_E_L_E_T_
cQuery += ","+_regnum+""     //CD2_R_E_C_N_O_
cQuery += ")"

If (TCSQLExec(cQuery) < 0)  //função que executa query
Return MsgStop("TCSQLError() " + TCSQLError())
EndIf


endif
*/

dbSelectArea("SD1")

Close(oDlg1)//fecha tela de entrada de dados

Return()



//-------------------------------------------------------------------------------------------------------------------//

Static Function Fim()

Close(oDlg1)//fecha tela de entrada de dados

Return()


//////////////////////////////////////////////////////////////////
Static Function f_BxPedido()
//////////////////////////////////////////////////////////////////
Local oFnt,oFnt2,oFnt3,oFnt4,oFnt5,oFnt6,oFnt7,oFnt8
Local aStru := {}
Private aCampos := {}
Private lInverte := .F.
Private cMarca   := GETMARK()
Private nVezes   := 0
Private nOpcA    := 0
Private nInd     := 0

DEFINE FONT oFnt  NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2 NAME "Arial" Size 10,11
DEFINE FONT oFnt3 NAME "Arial" Size 10,12
DEFINE FONT oFnt4 NAME "Arial" Size 10,34
DEFINE FONT oFnt5 NAME "Arial" Size 14,72
DEFINE FONT oFnt6 NAME "Arial" Size 9,12
DEFINE FONT oFnt7 NAME "Arial" Size 16,74
DEFINE FONT oFnt8 NAME "Arial" Size 12,14
// Cria os objetos com as configuracoes das fontes
//                                              Negrito  Subl  Italico
//oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f.,.f. )
//oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f.,.f. )


AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_PEDIDO"  , "C" , 06 , 0 } )
AADD(aStru,{"TB_ITEM"    , "C" , 04 , 0 } )
AADD(aStru,{"TB_ENTREG"  , "D" , 08 , 0 } )
AADD(aStru,{"TB_QTPED"   , "N" , 11 , 2 } )
AADD(aStru,{"TB_QTENT"   , "N" , 11 , 2 } )
AADD(aStru,{"TB_QTSDO"   , "N" , 11 , 2 } )
AADD(aStru,{"TB_PRODUTO" , "C" , 47 , 0 } )
AADD(aStru,{"TB_RECNO"   , "N" , 08 , 0 } )
cArqTrab2 := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab2,"TRB",.F.,.F.)
*
AADD(aCampos , { "TB_OK"      ,                     , "Ok"         } )
AADD(aCampos , { "TB_PEDIDO"  ,                     , "Pedido"     } )
AADD(aCampos , { "TB_ITEM"    ,                     , "Item"       } )
AADD(aCampos , { "TB_ENTREG"  ,                     , "Entrega"    } )
AADD(aCampos , { "TB_QTPED"   , "@E 9999999.99"     , "Qty.Ped."   } )
AADD(aCampos , { "TB_QTENT"   , "@E 9999999.99"     , "Qty.Entr."  } )
AADD(aCampos , { "TB_QTSDO"   , "@E 9999999.99"     , "    Saldo"  } )
AADD(aCampos , { "TB_PRODUTO" ,                     , "Produto"    } )

x_Item    := SD1->D1_ITEM
x_Fornece := SD1->D1_FORNECE
x_Loja    := SD1->D1_LOJA
x_DesFor  := RTRIM(SD1->D1_FORNECE)+"/"+RTRIM(SD1->D1_LOJA)+" - "+RTRIM(SA2->A2_NOME)
x_Produto := SPACE(15)
x_Quant   := SD1->D1_QUANT
x_Preco   := SD1->D1_VUNIT
x_Total   := SD1->D1_TOTAL
x_Pedido  := SD1->D1_PEDIDO
x_ItemPc  := SD1->D1_ITEMPC
x_OP      := "O.P.: "+IIF(EMPTY(SD1->D1_OP),"** FALTOU INFORMAR **", SD1->D1_OP)
x_Msg     := IIF(x_Total = 0 , "<-- FALTOU INFORMAR O TOTAL DA NOTA.","")

dbSelectArea("SC7")
dbSetOrder(3)
dbSeek(xFilial("SC7")+x_Fornece+x_Loja,.T.)
DO WHILE !EOF().AND.C7_FILIAL==xFilial("SC7").AND.C7_FORNECE==x_Fornece.AND.C7_LOJA==x_Loja
	IF ( EMPTY(SC7->C7_ENCER) .AND. EMPTY(SC7->C7_RESIDUO) .AND. SC7->C7_QUANT > SC7->C7_QUJE )
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->TB_PEDIDO  := SC7->C7_NUM
		TRB->TB_ITEM    := SC7->C7_ITEM
		TRB->TB_ENTREG  := SC7->C7_DATPRF
		TRB->TB_QTPED   := SC7->C7_QUANT
		TRB->TB_QTENT   := SC7->C7_QUJE
		TRB->TB_QTSDO   := ( SC7->C7_QUANT - SC7->C7_QUJE )
		TRB->TB_PRODUTO := RTRIM(SC7->C7_PRODUTO)+"  "+RTRIM(SC7->C7_DESCRI)
		TRB->TB_RECNO   := SC7->(RECNO())
		MsUnlock()
		dbSelectArea("SC7")
	ENDIF
	dbSkip()
ENDDO		

dbSelectArea("TRB")
dbGoTop()
			
@ 000,000 TO 370,770 DIALOG oDlg1 TITLE "Industrialização: Baixa do Pedido de Compra" 
		
@ 010,010 SAY "Fornecedor"                             
@ 010,050 Get x_DesFor                                      SIZE 200,07 WHEN .F.
@ 020,010 SAY "Item da Nota"
@ 020,050 Get x_Item                                        SIZE 20,07 WHEN .F.
@ 030,010 Say "Quantidade"
@ 030,050 Get x_Quant          PICTURE "@E 9999999.99"      SIZE 60,07 WHEN .F.
@ 040,010 SAY "Prc.Unitario"
@ 040,050 Get x_Preco          PICTURE "@E 9999,999.9999"   SIZE 60,07 WHEN .F.
@ 050,010 SAY "Total"
@ 050,050 Get x_Total          PICTURE "@E 999,999,999.99"  SIZE 70,07 WHEN .F.
@ 030,140 SAY x_OP                                          SIZE 80,15   ///Font oFnt5  COLOR 32768,0 
@ 050,140 SAY x_Msg                                         SIZE 180,15  ///Font oFnt3  COLOR 255,0
//@ 060,010 SAY "Numero Pedido"
//@ 060,060 Get x_Pedido         PICTURE "@!"                 SIZE 35,07  VALID f_CheckPC(1)
//@ 070,010 SAY "Item Pedido"
//@ 070,060 Get x_ItemPc         PICTURE "@R 9999"            SIZE 30,07  VALID f_CheckPC(2)
//@ 080,010 SAY "Produto"
//@ 080,060 Get x_Produto                                     SIZE 150,07  WHEN .F.
			
oMark := MsSelect():New("TRB","TB_OK","",aCampos,@lInverte,@cMarca,{062,010,178,376})
oMark:oBrowse:bldblclick := { || f_MarkPed() }

@ 010,340 BmpButton Type 1 Action (nOpcA := 1 , oDlg1:End())
@ 030,340 BmpButton Type 2 Action f_CloseCanc()
			
ACTIVATE DIALOG oDlg1 CENTERED VALID f_CloseEnd()
			
IF ( nOpcA == 1 )
	lTrue := .T.
	dbSelectArea("TRB")
	dbGoTop()
	DO WHILE !EOF().AND.lTrue
		IF ( !EMPTY(TRB->TB_OK) )
			lTrue := .F.
			dbSelectarea("SD1")
			RecLock("SD1",.F.)
			SD1->D1_PEDIDO := TRB->TB_PEDIDO
			SD1->D1_ITEMPC := TRB->TB_ITEM
			MsUnlock()
			*
			dbSelectArea("SC7")
			dbGoTo(TRB->TB_RECNO)	
			RecLock("SC7",.F.)
			x_Quant       := IIF( (x_Quant + SC7->C7_QUJE) > SC7->C7_QUANT , SC7->C7_QUANT , ( SC7->C7_QUJE + x_Quant ) )
			SC7->C7_QUJE  := x_Quant
			SC7->C7_ENCER := IIF(SC7->C7_QUJE >= SC7->C7_QUANT , "E" , " " )
			MsUnlock()
			*
			dbSelectArea("TRB")
		ENDIF
		dbSkip()
	ENDDO	
ENDIF

TRB->(dbCloseArea())
			
Return

////
////Check da tela da baixa do pedido de compra: Coelmatic/Manaus
////

///////////////////////////////////////////////////////////////////
Static Function f_CloseEnd()
///////////////////////////////////////////////////////////////////
Local lRsp := .F.

IF ( nOpcA == 1 )
	lRsp := .T.
ENDIF
Return(lRsp)

////////////////////////////////////////////
Static Function f_CloseCanc()
////////////////////////////////////////////
Local lRsp := ( nVezes < 2 )

If ( !lRsp )
	MsgInfo("Nenhum Pedido selecionado para baixa.")
	nOpcA := 2
   oDlg1:End()
Endif

nVezes++

Return

///////////////////////////////////////////////////////////////////
Static Function f_MarkPed()
///////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( EMPTY(TRB->TB_OK) )
	IF ( nInd > 0 )
		MsgInfo("-- Apenas um item pode ser selecionado. Para selecionar outro item, deve-se desmarcar o item marcado.")
		lRsp := .F.
	ELSE
		lRsp := f_CheckPC(2)
		RecLock("TRB",.F.)
		IF ( lRsp )
			TRB->TB_OK := cMarca
			nInd++
		ELSE
			TRB->TB_OK := "  "
		ENDIF	
		MsUnlock()
	ENDIF
ELSE
	RecLock("TRB",.F.)
	TRB->TB_OK := " "
	MsUnlock()
	nInd := 0
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////
Static Function f_CheckPC(xOpc)
///////////////////////////////////////////////////////////////////
Local lRsp := .T.
Local x_Pedido := TRB->TB_PEDIDO
Local x_ItemPc := TRB->TB_ITEM

dbSelectArea("SC7")
IF ( xOpc == 1 )
	dbSetOrder(3)
	dbSeek(xFilial("SC7")+x_Fornece+x_Loja+x_Pedido)
	IF ( EOF() )
		lRsp := .F.
		MsgStop("Pedido informado não existe para o Fornecedor da Nota Fiscal.")
	ELSEIF ( !EMPTY(x_ItemPc) )
		x_ItemPc  := Space(4)
		x_Produto := Space(15)
	ENDIF
	
ELSE
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+x_Pedido+x_ItemPc)
	IF ( EOF() )
		lRsp := .F.
		MsgStop("Pedido não cadastrado.")
	ELSEIF ( SC7->C7_ENCER == "E" .OR. SC7->C7_RESIDUO == "S" )
		lRsp := .F.
		MsgStop("Pedido/Item já encerrado ou eliminado por residuo.")
	ELSE
		IF ( x_Quant + SC7->C7_QUJE > SC7->C7_QUANT )
			MsgInfo("Atenção! Quantidade da nota fiscal, para este pedido, maior que o saldo do pedido. Não impede a baixa do pedido.")
		ENDIF
		x_Produto := RTRIM(SC7->C7_PRODUTO)+" "+RTRIM(SC7->C7_DESCRI)
	ENDIF
ENDIF	

dbSelectArea("TRB")

Return(lRsp)