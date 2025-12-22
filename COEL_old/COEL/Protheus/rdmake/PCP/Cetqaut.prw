#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EtqCB002 ºAutor  ³ Eduardo Alberti    º Data ³ 10/Aug/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Zebra Com Identificacao De Material e Proxima     º±±
±±º          ³ Etapa Da Producao.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico TecnoCurva.                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CETQAUT(_nTipo)

u_EtqCB002(_nTipo)

Return()

User Function EtqCB002(_nTipo)

Local	_aArea			:= GetArea()
Local	_aArSB1			:= SB1->(GetArea())
Local	_aArSC2			:= SC2->(GetArea())
Local	_aArSA7			:= SA7->(GetArea())
Local	_aArSG2			:= SG2->(GetArea())

Private _cPorta			:= "LPT1:"
Private _cOp			:= SD3->D3_OP
Private _cSequen		:= Substr(SD3->D3_OP,9,3)
Private _nQuantidade	:= SD3->D3_QUANT
Private _cEmissao		:= DtoC(SD3->D3_EMISSAO)
Private _cProd			:= SD3->D3_COD
Private _cFornecedor	:= Space(20)
Private aFornecedores	:= {}
Private _cCodBar		:= ""

If _nTipo == 2 .and. !Alltrim(Upper(cUserName)) $ Upper(GetMv("TC_REIMPET"))
	MsgStop('Voce Nao Tem Acesso a Reimprimir !!! Procure o PCP !!!')
	Return
Endif

// Determina OP Pai
DbSelectArea("SC2")
DbSetOrder(1) // C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
MsSeek(xFilial("SC2") + Substr(SD3->D3_OP,1,8) + StrZero(1,TamSX3("C2_SEQUEN")[1]))

// Monta a Estrutura Do Prod. Principal
aStru  := {}
nEstru := 0
cProd  := SC2->C2_PRODUTO
aStru  := Estrut(cProd)	// Estrutura { {Nivel , Codigo , Comp. , Qtd. , TRT }, ... , ... }

// Determina Nivel Do Produto Apontado Na Estrutura
_cNiv := _fEstPrd(aStru,SD3->D3_COD,"NIV")

DbSelectArea("SA7")
DbSetOrder(2) // A7_FILIAL, A7_PRODUTO, A7_CLIENTE, A7_LOJA
MsSeek(xFilial("SA7") + SC2->C2_PRODUTO)

_cCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+SA7->A7_CLIENTE+SA7->A7_LOJA,"A1_NREDUZ"))

Dbselectarea("SB1")
DbSetOrder(1)
MsSeek(xFilial("SB1") + SD3->D3_COD)

Private _cDescr		:= Substr(Alltrim(SB1->B1_DESC),1,36)
Private _cUM		:= SB1->B1_UM
Private _cTipo		:= SB1->B1_TIPO

// Posiciona No Proximo Nivel da Estrutura
_aArSB1 	:= SB1->(GetArea())
_aArSC2 	:= SC2->(GetArea())
_cPrdAntCod	:= ""
_cPrdAntDesc:= ""
_cRecursos	:= ""

// Determina Proximo Nivel Para Impressao da Etiqueta
_cSequen2 := _cSequen

While .t.
	
	_cSequen2 := StrZero((Val(_cSequen2)-1),TamSX3("C2_SEQUEN")[1])
	
	DbSelectArea("SC2")
	DbSetOrder(1) // C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
	If MsSeek(xFilial("SC2") + Substr(SD3->D3_OP,1,8) + _cSequen2 )
		
		_cNiv2 := _fEstPrd(aStru,SC2->C2_PRODUTO,"NIV")
		
		If _cNiv2 < _cNiv
			
			_cPrdAntCod	:= SC2->C2_PRODUTO
			_cCodBar	:= SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + Alltrim(Transform(_nQuantidade * 100,"@E 99999999"))
			
			DbSelectArea("SG2")
			DbSetOrder(1)	//
			MsSeek(xfilial("SG2") + _cPrdAntCod)
			
			While !Eof() .And. (Alltrim(SG2->G2_PRODUTO) == Alltrim(_cPrdAntCod))
				
				_cRecursos += Iif(!Empty(_cRecursos),"/","") + Alltrim(SG2->G2_RECURSO)
				
				DbSelectArea("SG2")
				SG2->(DbSkip())
			EndDo
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			MsSeek(xFilial("SB1") + _cPrdAntCod)
			
			_cPrdAntDesc:= Alltrim(SB1->B1_DESC)
			
			Exit
			
		EndIf
	Endif
EndDo

//Return() // Remover!!!

RestArea(_aArSB1)
RestArea(_aArSC2)

DbSelectArea("SA7")
DbSetOrder(1)

// Verifica Primeiro Contrato De Parceria
DbSelectArea("SC3")
DbSetOrder(3) // C3_FILIAL, C3_PRODUTO, C3_NUM, C3_ITEM
If MsSeek(xFilial("SC3") + SD3->D3_COD )
	
	While !Eof() .And. SC3->C3_PRODUTO == SD3->D3_COD
		
		// Elimina Contratos Jah Entregues
		If SC3->C3_QUANT > SC3->C3_QUJE
			
			// Elimina Contratos Eliminados Por Residuo
			If Empty(SC3->C3_RESIDUO)
				
				// Elimina Contratos Fora Da Data e Vencidos
				If (dDataBase >= SC3->C3_DATPRI) .And. (dDataBase <= SC3->C3_DATPRF)
					
					//Transform(SC3->C3_PRECO,"@E 999,999.99")
					DbSelectArea("SA2")
					DbsetOrder(1)
					MsSeek(xFilial("SA2") + SC3->C3_FORNECE + SC3->C3_LOJA)
					
					AADD(aFornecedores,{SC3->C3_PRECO,SA2->A2_NREDUZ + Transform(SC3->C3_PRECO,"@E 999,999.99")})
					
				EndIf
			EndIf
		EndIf
		
		DbSelectArea("SC3")
		SC3->(DbSkip())
	EndDo
EndIf

// Executa Somente Se Nao Houver Contrato De Parceria
If Len(aFornecedores) == 0
	
	DbSelectArea("SA5")
	DbSetOrder(2)
	If MsSeek(xFilial("SA5") + SD3->D3_COD)
		
		While !eof() .and. SA5->A5_PRODUTO == SD3->D3_COD
			
			DbSelectArea("SA2")
			DbsetOrder(1)
			MsSeek(xFilial("SA2") + SA5->A5_FORNECE + SA5->A5_LOJA)
			
			AADD(aFornecedores,{SA5->A5_PRECO01,SA2->A2_NREDUZ + Transform(SA5->A5_PRECO01,"@E 999,999.99")})
			
			DbSelectArea("SA5")
			SA5->(DbSkip())
		EndDo
	EndIf
EndIf

// Ordena Array
aFornecedores	:=	aSort(aFornecedores,,, {|x,y|x[1]<y[1]} )

// Converte Array MultiDimensional Para Array Com Somente Uma Dimensao
_aForn := {}
If Len(aFornecedores) > 0
	For i := 1 To Len(aFornecedores)
		
		Aadd(_aForn,aFornecedores[i,2])
		
	Next i
Endif

//Pergunta se o operador deseja incluir manualmente a quantidade por embalagem, caso o
//campo SB1->B1_QE esteja preenchido.
_bQtdManual := .F.
If SB1->B1_QE <> 0
	_cMsg := "O produto " + alltrim(SB1->B1_COD) + "ja possui quantidade por embalagem cadastrada. Deseja alterar?"
	If MsgYesNo(_cMsg, "Etiqueta Interna de Producao")
		_bQtdManual = .T.
	EndIf
EndIf

IF SB1->B1_QE == 0 .or. _bQtdManual == .T.
	_nquant := 0
	
	@ 96,42 TO 280,505 DIALOG oDlg5 TITLE "Quantidade por embalagem"
	
	@ 020,014 SAY "Ordem de Producao " + sd3->d3_op
	@ 035,014 SAY "Produto       " + _cProd + " " + _cDescr
	@ 050,014 SAY "Qtde Embalagem"
	@ 050,075 GET _nquant  PICTURE "@e 999,999"    Size 40,15
	
	// Inclui combo box de selecao de fornecedores para produtos intermediarios
	If _cTipo == 'PI'
		@ 065,014 SAY "Fornecedor:"
		@ 065,075 COMBOBOX _cFornecedor ITEMS _aForn SIZE 80, 130 object oCombo
	EndIf
	
	@ 075,196 BMPBUTTON TYPE 1 ACTION Close(oDlg5)
	
	ACTIVATE DIALOG oDlg5
	// Grava a quantidade por embalagem no cadastro do produto
	//RecLock("SB1",.F.)
	//SB1->B1_QE := _nquant
	//MsUnlock()
ELSE
	_nquant := SB1->B1_QE
ENDIF


_ATAB := {}
IF _NQUANT = 0
	AADD(_ATAB,{_nQuantidade})
ELSE
	FOR A:=1 TO INT(_nQuantidade/_NQUANT)
		AADD(_ATAB,{_NQUANT} )
	NEXT A
	if _nQuantidade - (INT(_nQuantidade/_NQUANT)*_NQUANT) > 0
		AADD(_ATAB,{_nQuantidade - (INT(_nQuantidade/_NQUANT)*_NQUANT) } )
	endif
endif

MSCBPRINTER("S600",_cPorta,Nil,110)
MSCBCHKStatus(.f.)
MSCBLOADGRF("SYSTEM\LOGO.GRF")

For _ncount := 1 to len(_ATAB)
	DbSelectArea("SX1")
	If ! DbSeek("ETQPRD    01")
		RecLock("SX1",.T.)
		SX1->X1_GRUPO     := "ETQPRD    "
		SX1->X1_ORDEM     := "01"
		SX1->X1_PERGUNT   := "Sequencial Producao  "
		SX1->X1_VARIAVL   := "mv_ch1"
		SX1->X1_TIPO      := "C"
		SX1->X1_TAMANHO   := 6
		SX1->X1_GSC       := "G"
		SX1->X1_VAR01     := "mv_par01"
		MsUnLock()
	EndIf
	
	V_NUMSEQ := Val(Alltrim(X1_CNT01))+1
	
	If RecLock("SX1",.F.)
		Replace X1_CNT01 With StrZero(V_NUMSEQ,6)
		DbUnLock()
	EndIf
	_cEtq := alltrim(str(_ncount,6)) +"/"+alltrim(str(len(_atab),6))
	PRT_ETQ( _atab[_ncount,1] , _cEtq , StrZero(V_NUMSEQ,6))
	
next _ncount

DBSELECTAREA("SD3")

RestArea(_aArSG2)
RestArea(_aArSA7)
RestArea(_aArSC2)
RestArea(_aArSB1)
RestArea(_aArea)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PRT_ETQ  ºAutor  ³ Eduardo Alberti    º Data ³ 31/Aug/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime Dados Da Etiqueta Termica Zebra.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PRT_ETQ(_nquant , _cetiqueta , _csequencial )

_cCod := substr(_cOp,1,8)+_csequencial+strzero(_nquant,5)

MSCBBEGIN(1,6,151) //Inic$io da Imagem da Etiqueta
MSCBBOX(002,005,78,110,005)  //Monta BOX

MSCBGRAFIC(3,6,"LOGO")

MSCBLINEH(002,024,078,05)
MSCBLINEH(002,034,078,05)
MSCBLINEH(002,044,078,05)
MSCBLINEH(002,054,078,05)
MSCBLINEH(002,064,078,05)
MSCBLINEH(002,074,078,05)
MSCBLINEH(002,084,078,05)

MSCBLINEV(023,005,024,05)
MSCBLINEV(040,024,034,05)
MSCBLINEV(050,074,084,05)

MSCBSAY(25,09,"Sequencia Operacional"    		,"N","0","045,040") //"N","C","020,015")
MSCBSAY(25,21,"Apontamento: " + substr(UsrFullName(RetCodUsr()), 1, 30)	,"N","0","020,020") //"N","A","020,015")
MSCBSAY(03,25,"Ordem de Producao"				,"N","0","020,020")
MSCBSAY(41,25,"Data/Hora de Apont."	    		,"N","0","020,020")
MSCBSAY(03,35,"Peca / Descr. (Nivel Atual)"		,"N","0","020,020")
MSCBSAY(03,45,"Peca / Descr. (Proximo Nivel)"	,"N","0","020,020")
MSCBSAY(03,55,"Cliente"          				,"N","0","020,020")

MSCBSAY(03,65,"Recurso (Proximo Nivel)"			,"N","0","020,020")
//MSCBSAY(51,65,"Etq"              				,"N","0","020,020")
MSCBSAY(03,75,"Quantidade"        				,"N","0","020,020")
MSCBSAY(51,75,"UM"               				,"N","0","020,020")


_cfonte_dados := "048,040"

MSCBSAY(06,29,Substr(_cOp,1,8) + _cSequen      								,"N","0",_cfonte_dados)
MSCBSAY(42,29,_cEmissao + "-" + substr(time(),1,5)								,"N","0",_cfonte_dados)
//MSCBSAY(06,39,_cProd             												,"N","C","020,015")
MSCBSAY(06,39,Substr(Alltrim(_cProd) + " " + Alltrim(_cDescr),01,35)			,"N","0","032,030") //,"N","0",_cfonte_dados)
MSCBSAY(06,49,Substr(Alltrim(_cPrdAntCod) + " " + Alltrim(_cPrdAntDesc),01,35)	,"N","0","032,030")
MSCBSAY(06,59,_cCli             												,"N","0",_cfonte_dados)

MSCBSAY(06,69,_cRecursos 					,"N","0",_cfonte_dados)
//MSCBSAY(60,69,_cetiqueta           		,"N","0",_cfonte_dados)
MSCBSAY(06,79,transform(_nquant,"99999999")	,"N","0",_cfonte_dados)
MSCBSAY(55,79,_cUm		         			,"N","0",_cfonte_dados)

MSCBSAY(03,107,"FORM 061  REV 04"			,"N","A","018,010")
MSCBSAYBAR(010,087,_cCodBar					,"N","C",13,,,,,2)
MSCBSAY(20,102,_cCodBar        				,"N","A","020,015")

MSCBEND() //Fim da Imagem da Etiqueta

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ _fEstPrd ³ Autor ³ Eduardo Alberti       ³ Data ³ 08/Sep/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Determina Caracteristicas Do Produto Dentro Da Estrutura   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fEstPrd(aStru,_cProd,xTPRET) // _fEstPrd(aStru,SD3->D3_COD,"NIV")

Local _aArea 	:= GetArea()
Local _xRet

// Estrutura { {Nivel , Codigo , Comp. , Qtd. , TRT }, ... , ... }

// Executa Laco Na Estrutura do Produto
For i := 1 To Len(aStru)
	
	// Encontra Produto Na Estrutura
	If Upper(Alltrim(_cProd)) == Upper(Alltrim(aStru[i,2]))
		
		If Upper(Alltrim(xTPRET)) == "NIV"
			
			_xRet := aStru[i,1] // Numerico
			
			Exit
			
		EndIf
	Endif
Next i

RestArea(_aArea)

Return(_xRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³ Fernando Alves        ³ Data ³ 05/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> Function ValidPerg
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}  // 1   2        3                         4      5   6  7 8  9  10    11       12     13 14    15   16 17 18 19  20 21 22
aAdd(aRegs,{cPerg,"01","Codigo cliente          ?","mv_ch1","C",06,0,0,"G","","mv_par01",""    ," ","",""    ,"","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"02","Codigo produto          ?","mv_ch2","C",15,0,0,"G","","mv_par02",""    ," ","",""    ,"","","","","","","SB1","","","",""})
aAdd(aRegs,{cPerg,"03","Lote                    ?","mv_ch3","C",06,0,0,"G","","mv_par03",""    ," ","",""    ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Quantidade              ?","mv_ch4","N",06,0,0,"G","","mv_par04",""    ," ","",""    ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Data fabricacao         ?","mv_ch5","D",08,0,0,"G","","mv_par05",""    ," ","",""    ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Chapa                   ?","mv_ch6","N",06,0,0,"G","","mv_par06",""    ," ","",""    ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Quantidade de etiquetas ?","mv_ch7","N",03,0,0,"G","","mv_par07",""    ," ","",""    ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Qual a Porta            ?","mv_ch8","N", 1,0,0,"C","","mv_par08","LPT1"," ","","COM1","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(aRegs[i,1]+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,1]
		SX1->X1_ORDEM   := aRegs[i,2]
		SX1->X1_PERGUNT := aRegs[i,3]
		SX1->X1_VARIAVL := aRegs[i,4]
		SX1->X1_TIPO    := aRegs[i,5]
		SX1->X1_TAMANHO := aRegs[i,6]
		SX1->X1_DECIMAL := aRegs[i,7]
		SX1->X1_PRESEL  := aRegs[i,8]
		SX1->X1_GSC     := aRegs[i,9]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_F3      := 	aRegs[i,22]
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return()
