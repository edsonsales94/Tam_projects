#include 'rwmake.ch'
#include 'protheus.ch'
#include 'totvs.ch'
#include 'colors.ch'
#include 'topconn.ch'
#Include "vkey.ch"
#include "font.ch"

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFAT01RBGRAF บAutor ณAndre Rodrigues  บ Data ณ  25/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PEDIDO DE VENDAS  (Emissao em formato Grafico)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATURAMENTO                                                บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO: Exclusivo para a COEL                   บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Impv_graf()

Private	lEnd		:= .f.,;
aAreaSC5	:= SC5->(GetArea()),;
aAreaSC6	:= SC6->(GetArea()),;
aAreaSA1	:= SA1->(GetArea()),;
aAreaSF4	:= SF4->(GetArea()),;
aAreaSA4	:= SA4->(GetArea()),;
cPerg		:= 'FAT01R    '

aDadosUser  := {}
aADD(aDadosUser,{"","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta os parametros.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AjustaSX1(cPerg)

If	( ! Pergunte(cPerg,.T.) )
	Return
Else
	Private	cNumPed1	:= mv_par01			// Numero do Pedido de Vendas
	Private	cNumPed2	:= mv_par02			// Numero do Pedido de Vendas
	Private	cNumPed 	:= ""			    // Numero do Pedido de Vendas
EndIf

DbSelectArea('SC5')
SC5->(DbSetOrder(1))
If	( ! SC5->(DbSeek(xFilial('SC5') + cNumPed)) )
	Help('',1,'FAT01R    ',,OemToAnsi('Pedido nใo encontrado.'),1)
	Return .f.
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a area anterior ao processamento. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aAreaSA4)
RestArea(aAreaSF4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณ                     บ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Duplicata...                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()
Private cFileIso:=	cFileLogo	:= GetSrvProfString('Startpath','') + 'LogoIso9001.BMP'//
Private	oPrint	:= TMSPrinter():New(OemToAnsi('Pedido de Vendas')),;
oBrush		    := TBrush():New(,4),;
oPen		    := TPen():New(0,5,CLR_BLACK),;
cFileLogo	    := GetSrvProfString('Startpath','') + 'LGRL' + cNUMEMP + '.BMP',;
cAssinatura     := GetSrvProfString('Startpath','') + ALLTRIM(cUserName) + '.BMP',;
oFont07		    := TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
oFont08		    := TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
oFont09		    := TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
oFont10		    := TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
oFont10n	    := TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
oFont11		    := TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
oFont12		    := TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
oFont12n	    := TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
oFont13		    := TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
oFont14		    := TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
oFont15		    := TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
oFont18		    := TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
oFont16		    := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
oFont20		    := TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
oFont22		    := TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)
Private	lFlag	:= .t.,;	// Controla a impressao do Cliente
lFlag1			:= .t.,;
nLinha			:= 3000,;	// Controla a linha por extenso
nLinFim			:= 0,;		// Linha final para montar a caixa dos itens
lPrintDesTab	:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
cRepres			:= Space(80)

Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
_nValMerc 			:= 0,;		// Valor das mercadorias
_nValIPI			:= 0,;		// Valor do I.P.I.
_nQtdpc				:= 0,;		// Qtde de pe็as 
_nValDesc			:= 0,;		// Valor de Desconto
_nTotAcr			:= 0,;		// Valor total de acrescimo
_nTotSeg			:= 0,;		// Valor de Seguro
_nTotFre			:= 0,;		// Valor de Frete
_nTotIcmsRet		:= 0		// Valor do ICMS Retido
_nTotIcmsDed		:= 0		// Valor da Deducao ICMS
_nItens     		:= 0		// Valor da Deducao ICMS
_dEmissao   		:= ""
_cTpFrete   		:= ""
_cSituacaoPed 		:= ""
_cEncer       		:= ""
_cResiduo     		:= ""
aMes        		:= {}
SetPrvt("NSEM,")

aADD(aMes,{"Jan","Jan"})
aADD(aMes,{"Fev","Feb"})
aADD(aMes,{"Mar","Mar"})
aADD(aMes,{"Abr","Apr"})
aADD(aMes,{"Mai","May"})
aADD(aMes,{"Jun","Jun"})
aADD(aMes,{"Jul","Jul"})
aADD(aMes,{"Ago","Aug"})
aADD(aMes,{"Set","Sep"})
aADD(aMes,{"Out","Oct"})
aADD(aMes,{"Nov","Nov"})
aADD(aMes,{"Dez","Dec"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona nos arquivos necessarios. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SA4->(dbSetOrder(1))
SA5->(DbSetOrder(1))
SB1->(DbSetOrder(1))
SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))
SE4->(DbSetOrder(1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser PAISAGEMณ
//ณSETPORTRAIT()serแ RETRATO               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:setlandscape()  //SetPortrait() //

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Imcrementa quatidade de reemissใo      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//cUpDate := "UPDATE " + RetSqlName('SC7') + " SET C7_QTDREEM = (C7_QTDREEM + 1) WHERE " + RetSqlName('SC7') + ".D_E_L_E_T_<>'*' AND C7_FILIAL = '" + xFilial('SC7') + "' AND C7_NUM >= '"+cNumPed1+"' AND C7_NUM <= '"+cNumPed2+"'"
//TCSQLExec(cUpDate)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู   
		  

cSELECT := 	' SC5.C5_NUM, SC5.C5_EMISSAO,SC5.C5_CLIENTE,SC5.C5_CODUSR,SA1.A1_COD,SA1.A1_NOME,SA1.A1_LOJA,SA1.A1_CGC,SA1.A1_INSCR,SA1.A1_END,SA1.A1_BAIRRO,SA1.A1_MUN, '+;
			'SA1.A1_EST, SA1.A1_CONTATO, SA1.A1_CEP,SA1.A1_TEL,SA1.A1_FAX, SA1.A1_ENDENT, SA1.A1_MUNE, SA1.A1_BAIRROE, SA1.A1_CLCGCEN, SA1.A1_CLIEENT, SA1.A1_VEND,SA1.A1_CLCLASI, '+;
	   		'SC5.C5_VEND1, SC5.C5_CLPEDCL, SA3.A3_NREDUZ, SF4.F4_TEXTO, SC5.C5_CONDPAG,SE4.E4_CODIGO,SE4.E4_DESCRI, SE4.E4_ACRSFIN, SC5.C5_TPFRETE, '+;
	   		'SC5.C5_TRANSP,SC5.C5_CLANTE, SC5.C5_CLPARC, SA1.A1_CLCLASI, SC5.C5_CLATEND, SC5.C5_CLMSPED, SC6.C6_ITEM, '+;
	   		'SC6.C6_PRODUTO,SC6.C6_CLGOP, SB1.B1_X_DESCC, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_UM,SC6.C6_PRUNIT, SC6.C6_PRCVEN,SC6.C6_ENTREG, '+;
	   		'SC6.C6_PRCDOL, SC6.C6_VALOR, SF4.F4_TEXTO, SF4.F4_IPI, SF4.F4_BASEIPI, SB1.B1_IPI, SC6.C6_PRUNIT,SC5.C5_MOEDA,SC5.C5_TXMOEDA , SZ2.Z2_CLDESC '

cFROM  :=	RetSqlName('SC5') + ' SC5'
 
cINNER := 'INNER JOIN '+ RetSqlName('SA1')+' SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI '+; 
		  'INNER JOIN '+ RetSqlName('SC6')+' SC6 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM= SC6.C6_NUM '+;
		  'INNER JOIN '+ RetSqlName('SA3')+' SA3 ON SC5.C5_VEND1 = SA3.A3_COD '+;
		  'INNER JOIN '+ RetSqlName('SF4')+' SF4 ON SC6.C6_TES = SF4.F4_CODIGO '+;
		  'INNER JOIN '+ RetSqlName('SE4')+' SE4 ON SC5.C5_CONDPAG = SE4.E4_CODIGO '+;
		  'INNER JOIN '+ RetSqlName('SB1')+' SB1 ON SC6.C6_FILIAL = SB1.B1_FILIAL AND SC6.C6_PRODUTO = SB1.B1_COD '+;
          'INNER JOIN '+ RetSqlName('SZ2')+' SZ2 ON SA1.A1_CLCLASI = SZ2.Z2_CLCOD '
cWHERE :=	'SC5.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SA1.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SC6.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SA3.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SF4.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SE4.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SB1.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SC5.C5_FILIAL  =     '+CHR(39) + xFilial('SC5') +CHR(39) + ' AND '+;
			'SC5.C5_CODUSR  =     '+CHR(39) +  __CUSERID     +CHR(39) + ' AND '+;
			'SC5.C5_NUM     >=    '+CHR(39) + cNumPed1       +CHR(39) + ' AND '+;
			'SC5.C5_NUM     <=    '+CHR(39) + cNumPed2       +CHR(39)

cORDER  :=	'SC6.C6_NUM, SC6.C6_ITEM '

cQuery  :=	' SELECT '   + cSELECT + ;
' FROM '     + cFROM   +" "+ cINNER +" "+ ;
' WHERE '    + cWHERE  + ;
' ORDER BY ' + cORDER

TCQUERY cQuery NEW ALIAS 'TRA'

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

DbSelectArea('TRA')
Count to _nQtdReg
ProcRegua(_nQtdReg)
TRA->(DbGoTop())

While 	TRA->( ! Eof() )
	
	_nQtdReg	:= 0		// Numero de registros para intruir a regua
	 nVipi		:= 0		// Aliquota do IPI
	_nValMerc 	:= 0		// Valor das mercadorias
	_nValIPI	:= 0		// Valor do I.P.I.
	_nValDesc	:= 0		// Valor de Desconto
	_nTotAcr	:= 0		// Valor total de acrescimo
	_nTotSeg	:= 0		// Valor de Seguro
	_nTotFre	:= 0		// Valor de Frete
	_nTotIcmsRet:= 0		// Valor do ICMS Retido
	_nTotIcmsDed:= 0		// Valor da Deducao ICMS
	cObs1       := ""
	cObs2       := ""
	cObs3       := ""
	cObs4       := ""
	cObs5       := ""
	cTransp		:= ""
	cNumped   	:= TRA->C5_NUM
	_dEmissao 	:= STOD(TRA->C5_emissao)
	nLinha    	:= 3000
	_nItens   	:= 0
	_nLinDet  	:= 0
	_nCol     	:= 44
	_nPag     	:= 0
	_nPagImp  	:= 0
	
	SC5->(DbSeek(Xfilial('SC5') + TRA->C5_NUM))
	
	While SC5->( ! Eof() ) .AND. cNumped == SC5->C5_NUM
		
		_nLinDet++
		
		If ++_nItens == 1
			cObs1       := SC5->C5_CLMSPED
		ElseIf _nItens == 2
			cObs2       := SC5->C5_CLMSPED
		ElseIf _nItens == 3
			cObs3       := SC5->C5_CLMSPED
		ElseIf _nItens == 4
			cObs4       := SC5->C5_CLMSPED
		ElseIf _nItens == 5
			cObs5       := SC5->C5_CLMSPED
		Endif
		
		SC5->(DbSkip())
		_nCol := 44
		
	endDo
	
	While .T.
		
		_nPag++
		
		If _nLinDet <= 26
			Exit
		Else
			_nLinDet -= 26
		EndIf
		
	EndDo
	
	If _nLinDet >= 15
		_nPag++
	EndIf

   If SA4->(DBSETORDER(1), DBSEEK(XFILIAL()+ TRA->C5_TRANSP))
   		cTransp := TRA->C5_TRANSP+" - "+Alltrim(SA4->A4_NREDUZ)
   Endif
	
	_nItens := 0
	_nMoeda := TRA->C5_MOEDA
	cTerms  := TRA->E4_CODIGO +" - "+TRA->E4_DESCRI
	cLocEnt := TRA->A1_ENDENT
	cMunEnt := TRA->A1_MUNE
	cCgcEnt := TRA->A1_CLCGCEN
	cInsEnt := TRA->A1_CLIEENT
	cVend   := TRA->C5_VEND1+" "+ TRA->A3_NREDUZ
	cNatur  := TRA->F4_TEXTO
	nTaxfin := TRA->E4_ACRSFIN
	cActant := Iif( TRA->C5_CLANTE=="S", "SIM", Iif( TRA->C5_CLANTE=="N", "NAO", " " ) )
	cEntpar := if( SC5->C5_CLPARC=="S", "SIM", Iif( SC5->C5_CLPARC=="N", "NAO", " " ) )
	cDestino:= TRA->Z2_CLDESC
	cUser	:= TRA->C5_CLATEND
	cCliente:= AllTrim(TRA->A1_NOME) + '  ('+AllTrim(TRA->A1_COD)+'/'+AllTrim(TRA->A1_LOJA)+')'
	cEnd	:= AllTrim(TRA->A1_END)
	cBairro := AllTrim(TRA->A1_BAIRRO)     
	cMun	:= AllTrim(TRA->A1_MUN)+'/'+AllTrim(TRA->A1_EST)
	cCep	:= Alltrim(TRA->A1_CEP)
	cCNPJ	:= AllTrim(TRA->A1_CGC)
	cIE		:= AllTrim(TRA->A1_INSCR)
	cTel	:= LEFT(TRA->A1_TEL,15)
	cFax 	:= LEFT(TRA->A1_FAX,15)
	cCont 	:= AllTrim(TRA->A1_CONTATO)
	xITENS := {}
   	xDTENT := {}
   	xQUANT := {}
   	xSEMAN := {}
   	xPEDCLI:= {}
	
	Do While 	TRA->( ! Eof() ) .AND. cNumped == TRA->C5_NUM
		
		mv_par06 := IIF(SA2->A2_EST<>"EX" , 1 , 2 )
		
		xVerPag()
		
		Cabec1()
		
		oPrint:Line(nLinha,080,nLinha+50,080)   //ITEM
		oPrint:Line(nLinha,180,nLinha+50,180)   //CODIGO
		oPrint:Line(nLinha,580,nLinha+50,580)   //DESCRICAO
		oPrint:Line(nLinha,660,nLinha+50,660)   //OS AQUI 560
		oPrint:Line(nLinha,1960,nLinha+50,1960) //UM  1460
		oPrint:Line(nLinha,2060,nLinha+50,2060) //QTDE 1560
		oPrint:Line(nLinha,2260,nLinha+50,2260) //VLR.UNIT.  1760
		oPrint:Line(nLinha,2500,nLinha+50,2500) //IPI 2000
		oPrint:Line(nLinha,2740,nLinha+50,2740) //IPI 2240
		oPrint:Line(nLinha,2840,nLinha+50,2840) //IPI 2340
		oPrint:Line(nLinha,3290,nLinha+50,3290) //   3290
			
		nLinha += 10
		
		oPrint:Say(nLinha,0100,TRA->C6_ITEM,oFont08)
		
		_cTpFrete := TRA->C5_TPFRETE
		lIpiBruto := IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)
		
		IF SF4->F4_IPI == "S"
	         nBaseIPI    := IIF(TRA->F4_BASEIPI > 0,TRA->F4_BASEIPI,100)
	         nIPI        := TRA->B1_IPI
	         nValBase    := If(lIPIBruto .And. TRA->C6_PRUNIT > 0,TRA->C6_PRUNIT,TRA->C6_PRCVEN)*TRA->C6_QTDVEN
	         nVipi       := nValBase * (nIPI/100)*(nBaseIPI/100)
      	Endif
		
		oPrint:Say(nLinha,0200,TRA->C6_PRODUTO,oFont08)
		oPrint:Say(nLinha,0500,TRA->C6_CLGOP,oFont08)
		oPrint:Say(nLinha,0700,iif(!Empty(TRA->B1_X_DESCC),SUBS(TRA->B1_X_DESCC,1,55),SUBS(TRA->C6_DESCRI,1,55)),oFont10) //aqui
		oPrint:Say(nLinha,1980,TRA->C6_UM,oFont08)  // 1480
		oPrint:Say(nLinha,2250,AllTrim(TransForm(TRA->C6_QTDVEN,'@E 9999999.99')),oFont08,,,,1)  //1750
		oPrint:Say(nLinha,2486,AllTrim(TransForm(TRA->C6_PRCVEN,'@E 9999,999.9999')),oFont08,,,,1) //1986
		oPrint:Say(nLinha,2820,AllTrim(TransForm(TRA->B1_IPI,'@E 99')+"%"),oFont08,,,,1) //2320
		oPrint:Say(nLinha,3020,AllTrim(TransForm(NoRound(TRA->C6_VALOR+nVipi),'@E 9999,999.99')),oFont08,,,,1) //2520
		
		nLinha += 40
		
		_nValMerc 	+= NoRound(TRA->C6_VALOR+nVipi)
		_nQtdpc		+= TRA->C6_QTDVEN
		_nItens++
		
		If _nItens == 26
		
			oPrint:Line(nLinha,080,nLinha,3290)
			nLinha := 3000
			//AQUI
			xVerPag()
			Cabec1()
		EndIf
		
		_nCol := 44
		
		AADD( xITENS, TRA->C6_ITEM   )
      	AADD( xDTENT, TRA->C6_ENTREG )
      	AADD( xQUANT, Iif( mv_par04==1, TRA->C6_QTDVEN - TRA->C6_QTDENT, TRA->C6_QTDVEN ) )
      	AADD( xPEDCLI,TRA->C5_CLPEDCL )
      	_NumSemana()
      	AADD( xSEMAN, nSem )
		
		IncProc()
		TRA->(DbSkip())
		
	End
	
	If _nItens >= 15 .AND. _nItens <= 25   
		oPrint:Line(nLinha,080,nLinha,3290)
		_nItens := 0
	Endif
	
	
			
	If _nItens >0 		//DEBUGAR
				
				xVerPag()
				
				If nLinha <= 820
					// CONTROLA LINHA VERTICAIS QDO NAO TEM ITENS...
					While _nItens <= 06//15
						
						oPrint:Line(nLinha,080,nLinha+60,080)
						oPrint:Line(nLinha,180,nLinha+60,180)
						oPrint:Line(nLinha,580,nLinha+60,580)
						oPrint:Line(nLinha,660,nLinha+60,660)
						oPrint:Line(nLinha,1960,nLinha+60,1960)
						oPrint:Line(nLinha,2060,nLinha+60,2060)
						oPrint:Line(nLinha,2260,nLinha+60,2260)
						oPrint:Line(nLinha,2500,nLinha+60,2500) //TOTAL
						oPrint:Line(nLinha,2740,nLinha+60,2740) //IPI
						oPrint:Line(nLinha,2840,nLinha+60,2840) //ENTREGA
						oPrint:Line(nLinha,3290,nLinha+60,3290)
						nLinha += 60
						_nItens++
		
					EndDo
				Else
					// CONTROLA LINHA VERTICAIS QDO NAO TEM ITENS... ARRUMAR
					While _nItens <= 15
					
						oPrint:Line(nLinha,080,nLinha+60,080)
						oPrint:Line(nLinha,180,nLinha+60,180)
						oPrint:Line(nLinha,580,nLinha+60,580)
						oPrint:Line(nLinha,660,nLinha+60,660)
						oPrint:Line(nLinha,1960,nLinha+60,1960)
						oPrint:Line(nLinha,2060,nLinha+60,2060)
						oPrint:Line(nLinha,2260,nLinha+60,2260)
						oPrint:Line(nLinha,2500,nLinha+60,2500) //TOTAL
						oPrint:Line(nLinha,2740,nLinha+60,2740) //IPI
						oPrint:Line(nLinha,2840,nLinha+60,2840) //ENTREGA
						oPrint:Line(nLinha,3290,nLinha+60,3290)
						nLinha += 60
						_nItens++
					
					EndDo
				Endif
			oPrint:Line(nLinha,080,nLinha,3290) //2300
			
			nLinha += 20
			
			xVerPag()
	Endif
	
	nLinha += 20 		
	x_Moeda := iif(_nMoeda==1,"(R$)",if(_nMoeda==2,"(US$)",if(_nMoeda==5,"(Eu)","")))
			
			
	if mv_par06==1
		oPrint:Say(nLinha,1350,'Qtde. Itens ',oFont12)
		oPrint:Say(nLinha,1550,TransForm(_nQtdpc,'@E 99,999,999.99'),oFont12)
		oPrint:Say(nLinha,2700,'Valor Total '+x_Moeda,oFont12)
		oPrint:Say(nLinha,3005,TransForm(_nValMerc,'@E 99,999,999.99'),oFont12)
	else
		oPrint:Say(nLinha,1880,'Total Amount '+x_Moeda,oFont12)
		oPrint:Say(nLinha,3005,TransForm(_nValMerc,'@E 99,999,999.99'),oFont12)
	endif
			
	nLinha +=80
	oPrint:Line(nLinha,080,nLinha,3290)
	nLinha += 20
	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณImprime dados de pagamento/entrega!        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	If _cTpFrete=="C"
		_DescFrete:="A PAGAR"
	ElseIf _cTpFrete=="F"
		_DescFrete:="PAGO"
	ElseIf _cTpFrete=="T"
		_DescFrete:="POR CONTA DE TERCEIROS"
	ElseIf _cTpFrete=="S"
		_DescFrete:="SEM FRETE"
	EndIf
	
	
	oPrint:Say(nLinha,0080,OemToAnsi(if(mv_par06==1,'Vendedor : ','Seller: ')),oFont10)
	oPrint:Say(nLinha,0280,cVend,oFont10)
	oPrint:Say(nLinha,0690,OemToAnsi(if(mv_par06==1,'Condi็ใo de Pagamento: ','Payment Terms: ')),oFont10)
	oPrint:Say(nLinha,1100,cTerms,oFont10)
	oPrint:Say(nLinha,1580,OemToAnsi(if(mv_par06==1,'Tipo de Frete :','Incoterms :')),oFont10)
	oPrint:Say(nLinha,1830,_DescFrete,oFont10)
	oPrint:Say(nLinha,2200,OemToAnsi('Natureza :'),oFont10)
	oPrint:Say(nLinha,2400,cNatur,oFont10)
	
	nLinha += 50
	
	oPrint:Say(nLinha,0080,OemToAnsi('Taxa Financ. :'),oFont10)
	oPrint:Say(nLinha,0270,Transform(nTaxfin,"@E 999,999.9999"),oFont10)
	oPrint:Say(nLinha,0540,OemToAnsi('Aceita Antec :'),oFont10)
	oPrint:Say(nLinha,0770,cActant,oFont10)
	oPrint:Say(nLinha,0885,OemToAnsi('Entrega Parc.:'),oFont10)
	oPrint:Say(nLinha,1135,cEntpar,oFont10)
	oPrint:Say(nLinha,1265,OemToAnsi('Transportadora :'),oFont10)
	oPrint:Say(nLinha,1525,cTransp,oFont10)
	oPrint:Say(nLinha,2200,OemToAnsi('Destino   :'),oFont10)
	oPrint:Say(nLinha,2400,cDestino,oFont10)
	
	nLinha += 50
	oPrint:Say(nLinha,0080,OemToAnsi('Pedido Efetuao por :'),oFont10)
	oPrint:Say(nLinha,0420,cUser,oFont10)
	nLinha += 50
	oPrint:Say(nLinha,0080,OemToAnsi(if(mv_par06==1,'Local de Entrega : ','Billing and Ship to: ')+;
	ALLTRIM(cLocEnt)+'          Municipio: '+ALLTRIM(cMunEnt)+'  -  CGC Entrega: '+;
	TransForm(cCgcEnt,'@R 99.999.999/9999-99')+'    -  I.E. Entrega: '+TransForm(cInsEnt,'@R 999.999.999.999')+' / '+ALLTRIM(SM0->M0_ESTENT)),oFont10)
	
	nLinha += 140 //50
	If nLinha >= 1960
	
		nLinha := 3000
		lFlag1	:= .f.
		xVerPag()
		Cabec1()
		oPrint:Say(nLinha,0080,OemToAnsi('CRONOGRAMA DE ENTREGA'),oFont10)
		nLinha += 40
	Endif	
	If SM0->M0_CODFIL == "02"
		oPrint:Say(nLinha,0080,Dtoc(dDataBase),oFont10)
    EndIf
	nLinha += 80
	oPrint:Line(nLinha,080,nLinha,3290)
	nLinha += 80
	oPrint:Say(nLinha,0080,OemToAnsi('IT   DATA ENTREGA       SEMANA        QTDE       SUA OC'),oFont10)
	oPrint:Line(nLinha,1580,nLinha+60,1580)
	oPrint:Say(nLinha,1610,OemToAnsi('IT   DATA ENTREGA       SEMANA        QTDE       SUA OC'),oFont10)
	nLinha += 80
	oPrint:Line(nLinha,080,nLinha,3290)
	
	lComplete := .T.
  	nLinha := nLinha + 80
  	i := 1
	
	Do While i <= Len( xITENS )
		If nLinha >= 1960
			lComplete := .F.
			oPrint:Line(nLinha,080,nLinha,3290)
			oPrint:Say(nLinha,1550,OemToAnsi('Continua.....'),oFont10)
			nLinha  = 3000
			lFlag1	:= .f.
			xVerPag()
			Cabec1()
			oPrint:Say(nLinha,0080,OemToAnsi('IT   DATA ENTREGA       SEMANA        QTDE       SUA OC'),oFont10)
			oPrint:Line(nLinha,1580,nLinha+60,1580)
			oPrint:Say(nLinha,1610,OemToAnsi('IT   DATA ENTREGA       SEMANA        QTDE       SUA OC'),oFont10)
			nLinha += 80
			oPrint:Line(nLinha,080,nLinha,3290)
		Endif
		
		oPrint:Line(nLinha,1580,nLinha+60,1580)
		
		oPrint:Say(nLinha,0080,xITENS[i],oFont09)
		oPrint:Say(nLinha,0330,Dtoc(Stod(xDTENT[i])),oFont09,,,,1)
		oPrint:Say(nLinha,0550,TransForm(xSEMAN[i],'9999'),oFont09,,,,1)
		oPrint:Say(nLinha,0790,TransForm(xQUANT[i],'@E 99,999.99'),oFont09,,,,1)
		oPrint:Say(nLinha,1030,xPEDCLI[i],oFont09,,,,1)
		i := i + 1
		If i <= Len( xITENS )
			oPrint:Say(nLinha,1640,Alltrim(xITENS[i]),oFont09,,,,1)
			oPrint:Say(nLinha,1870,Dtoc(Stod(xDTENT[i])),oFont09,,,,1)
			oPrint:Say(nLinha,2070,Alltrim(TransForm(xSEMAN[i],'9999')),oFont09,,,,1)
			oPrint:Say(nLinha,2320,Alltrim(TransForm(xQUANT[i],'@E 99,999.99')),oFont09,,,,1)
			oPrint:Say(nLinha,2520,Alltrim(xPEDCLI[i]),oFont09,,,,1)
			i := i + 1
		Endif
		nLinha += 80
		
	EndDo
ENDDO

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrint:Preview()

TRA->(DbCloseArea())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณ                     บ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia a montagem da impressao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	( nLinha >= 2300 )
	
	If	( ! lFlag )
		oPrint:Line(nLinha,080,nLinha,3290)
		oPrint:EndPage()
		nLinha:= 700
	Else
		nLinha:= 700
	EndIf
	
	oPrint:StartPage()
	
	xCabec()
	
	lFlag		 := .t.
	_nItens   := 0
	
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณ                     บ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

Local xTel   := IIF(M->cNumEmp=="0302" , "551120663211" , SM0->M0_TEL )
Local xFax   := IIF(M->cNumEmp=="0302" , "551120663201" , SM0->M0_FAX )
Local xMoeda := iif(TRA->C5_MOEDA==1,"R$ ",if(TRA->C5_MOEDA==2,"US$ ",if(TRA->C5_MOEDA==5,"Eur ","")))
Local xPhone := iif(mv_par06==1,TRANSF(SUBS(xTel,3,10),"@R (99)9999-9999"),TRANSF(xTel,"@R 99-99-9999-9999"))
Local xFaxx  := iif(mv_par06==1,TRANSF(SUBS(xFax,3,10),"@R (99)9999-9999"),TRANSF(xFax,"@R 99-99-9999-9999"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Observacoes !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrint:SayBitmap(050,0080,cFileIso,0380,0360)

oPrint:Box(0420,0080,0690,0880)
oPrint:Line(0470,0080,0470,0880)


IF MV_PAR06 == 1
	oPrint:Say(0430,0400,OemToAnsi('Observa็oes'),oFont10)
	oPrint:Say(0475,0090,SUBSTR(TRA->C5_CLMSPED,1,52),oFont07)
	oPrint:Say(0500,0090,SUBS(TRA->C5_CLMSPED,53,105),oFont07)
	oPrint:Say(0525,0090,SUBS(TRA->C5_CLMSPED,105,156),oFont07)
	oPrint:Line(0555,0080,0555,0880)
			
	IF ( TRA->C5_MOEDA > 1 )
		oPrint:Say(0590,0090,'- Taxa da Moeda: '+xMoeda+LTRIM(TRANSF(TRA->C5_TXMOEDA,"@E 9999.9999")),oFont07)
	ENDIF

ELSE
	oPrint:Say(0430,0400,OemToAnsi('Observation'),oFont10)
	oPrint:Say(0475,0090,'- We will accept the merchandise  if  your  invoice ',oFont07)
	oPrint:Say(0500,0090,'  included in our Purchase Order Number, Part Number',oFont07)
	oPrint:Say(0525,0090,'  and Supply Part Number.                           ',oFont07)
	oPrint:Line(0555,0080,0555,0880)
	oPrint:Say(0590,0090,'- Currency Rate: '+xMoeda+LTRIM(TRANSF(TRA->C5_TXMOEDA,"@E 9999.9999")),oFont07)

ENDIF 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrint:SayBitmap(050,900,cFileLogo,750,0260)
oPrint:Say(050,1700,AllTrim(Upper(SM0->M0_NOMECOM)),oFont12)
oPrint:Say(130,1700,AllTrim(SM0->M0_ENDENT)+ '  -  ' +AllTrim(SM0->M0_BAIRENT)+'  -  Cep: '+AllTrim(TransForm(SM0->M0_CEPENT,'@R 99999-999')),oFont09)

oPrint:Say(080,2780,OemToAnsi(if(mv_par06==1,'Pedido de','Purchase')),oFont13)
oPrint:Say(150,2780,OemToAnsi(if(mv_par06==1,'Vendas   ','Order ')),oFont13)
oPrint:Say(220,2780,OemToAnsi('Pag.: [ '+alltrim(Transform(++_nPagImp,'99'))+' ]'),oFont09)
//oPrint:Say(220,2780,OemToAnsi('Pag.: [ '+alltrim(Transform(++_nPagImp,'99'))+' / '+alltrim(Transform(_nPag,'99'))+' ]'),oFont09)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNumero/Emissaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Box(050,2760,0285,3290)
oPrint:Say(0080,3070,cNUMPED,oFont16)
oPrint:Say(0150,3070,Dtoc(_dEMISSAO),oFont12)
oPrint:Say(180,1700,Capital(AllTrim(SM0->M0_CIDENT))+'/'+AllTrim(SM0->M0_ESTENT)+ '      Fone/Fax: ' +xPhone + '  -  ' + xFaxx ,oFont09)
oPrint:Say(225,1700,AllTrim('Website: www.coel.com.br'),oFont09)
oPrint:Line(285,1700,285,2880)
oPrint:Say(300,1700,"CNPJ: "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont09)
oPrint:Say(300,2230,"I.E.: "+SM0->M0_INSC,oFont09)
oPrint:Say(300,2580,"Suframa: "+SM0->M0_INS_SUF,oFont09)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Cabec1() บAutor ณ                     บ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Segundo cabe็ario do Relatorio....                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec1()
Local cVlrUnit := if(mv_par06==1,'Vlr.Unit.','Unit Price') + if(TRA->C5_MOEDA==1,"(R$)",if(TRA->C5_MOEDA==2,"(US$)",if(TRA->C5_MOEDA==5,"(Eu)","")))

If	( lFlag )
	//ฺฤฤฤฤฤฤฤฤฤฤฟ
	//ณCliente   ณ
	//ภฤฤฤฤฤฤฤฤฤฤู
	
	oPrint:Box(0410,0900,0690,3290)
	oPrint:Say(0430,0920,OemToAnsi(if(mv_par06==1,'Cliente   :','Customer:')),oFont10)
	oPrint:Say(0420,1120,cCliente ,oFont13)
	oPrint:Say(0480,0920,OemToAnsi(if(mv_par06==1,'Endere็o: ','Address: ')),oFont10)
	oPrint:Say(0480,1120,cEnd,oFont10)
	oPrint:Say(0480,1850,OemToAnsi(if(mv_par06==1,'Bairro: ','Neighborhood: ')),oFont10)
	oPrint:Say(0480,1960,cBairro,oFont10)     
	oPrint:Say(0530,0920,OemToAnsi(if(mv_par06==1,'Municํpio: ','City: ')),oFont10)
	oPrint:Say(0530,1120,cMun+'/'+AllTrim(TRA->A1_EST),oFont10)
	oPrint:Say(0530,1650,OemToAnsi(if(mv_par06==1,'Cep:','Zipcode:')+' '+TransForm(cCep,'@R 99999-999')),oFont10)
	oPrint:Say(0530,2100,OemToAnsi('CNPJ: '+TransForm(cCNPJ,'@R 99.999.999/9999-99')),oFont10)
	oPrint:Say(0530,2580,OemToAnsi('Inscr. Estadual:  '+cIE),oFont10)
	oPrint:Say(0580,0920,OemToAnsi(if(mv_par06==1,'Telefone: ','Phone: ')),oFont10)
	oPrint:Say(0580,1120,cTel+'                        Fax: '+cFax,oFont10)
	oPrint:Say(0630,0920,OemToAnsi(if(mv_par06==1,'Contato: ',"Contact: ")),oFont10)
	oPrint:Say(0630,1120,cCont,oFont10)
	
	lFlag := .f.
	
	iF (lFlag1)
		
		//CABEC ITENS
		oPrint:Line(nLinha,080,nLinha,3290)
		oPrint:Line(nLinha,080,nLinha+70,080)
		oPrint:Line(nLinha,180,nLinha+70,180)
		oPrint:Line(nLinha,580,nLinha+70,580)
		oPrint:Line(nLinha,660,nLinha+70,660) //AQUI560
		oPrint:Line(nLinha,1960,nLinha+70,1960) // 1460
		oPrint:Line(nLinha,2060,nLinha+70,2060) //1560
		oPrint:Line(nLinha,2260,nLinha+70,2260) //1760
		oPrint:Line(nLinha,2500,nLinha+70,2500) //TOTAL 2000
		oPrint:Line(nLinha,2740,nLinha+70,2740) //IPI 2240
		oPrint:Line(nLinha,2840,nLinha+70,2840) //ENTREGA 2340
		oPrint:Line(nLinha,3290,nLinha+70,3290) //
		
		IF ( mv_par06 == 1 )
			oPrint:Say(nLinha+10,0100,OemToAnsi('Item'),oFont10)
			oPrint:Say(nLinha+10,0200,OemToAnsi('C๓digo'),oFont10)
		    oPrint:Say(nLinha+10,0600,OemToAnsi('OS'),oFont10) //aqui
			oPrint:Say(nLinha+10,0700,OemToAnsi('Descri็ใo'),oFont10) //aqui
			oPrint:Say(nLinha+10,1980,OemToAnsi('UM'),oFont10) // 1480
			oPrint:Say(nLinha+10,2160,OemToAnsi('Qtde'),oFont10) //1660
			oPrint:Say(nLinha+10,2280,OemToAnsi(cVlrUnit),oFont10) // 1780
			oPrint:Say(nLinha+10,2520,OemToAnsi('Vlr.Unit.(US$)'),oFont10) //2020
			oPrint:Say(nLinha+10,2760,OemToAnsi('IPI'),oFont10) // 2260
			oPrint:Say(nLinha+10,2855,OemToAnsi('Valor Total'),oFont10) // 2355
			
		ELSE
			oPrint:Say(nLinha+10,0100,OemToAnsi('Item'),oFont10)
			oPrint:Say(nLinha+10,0194,OemToAnsi('Part Number'),oFont10)
			oPrint:Say(nLinha+10,0600,OemToAnsi('Description'),oFont10)
			oPrint:Say(nLinha+10,1130,OemToAnsi("Supply Part Number"),oFont10)
			oPrint:Say(nLinha+10,1480,OemToAnsi('UM'),oFont10)
			oPrint:Say(nLinha+10,1670,OemToAnsi('Qty'),oFont10)
			oPrint:Say(nLinha+10,1780,OemToAnsi(cVlrUnit),oFont10)
			oPrint:Say(nLinha+10,2020,OemToAnsi('Unit Price (R$)'),oFont10)
			oPrint:Say(nLinha+10,2340,OemToAnsi('Amount'),oFont10)
			oPrint:Say(nLinha+10,2510,OemToAnsi('IPI'),oFont10)
			oPrint:Say(nLinha+10,2610,OemToAnsi('Ship Date'),oFont10)
			oPrint:Say(nLinha+10,2804,OemToAnsi('Observation'),oFont10)
		ENDIF
		nLinha += 70
		oPrint:Line(nLinha,080,nLinha,3290)
	Endif
	lFlag1 := .t.
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณ                     บ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()
/*
oPrint:Box(nLinha,0100,nLinha+220,2960)

//oPrint:SayBitmap(nLinha,0100,cAssinatura,nLinha-700,230) // Imprime assinatura

oPrint:Say(nLinha,0110,if(MV_PAR06 == 1,'Comprador','Buyer'),oFont08) //aDadosUser[2]
oPrint:Say(nLinha,0750,if(MV_PAR06 == 1,'Gerencia' ,'Manager'),oFont08)
oPrint:Say(nLinha,1400,if(MV_PAR06 == 1,'Diretoria','Director'),oFont08)
oPrint:Say(nLinha,2050,if(MV_PAR06 == 1,'Situacao Pedido','Status Purchase'),oFont08)
*
oPrint:Line(nLinha,740,nLinha+220,740)
oPrint:Line(nLinha,1390,nLinha+220,1390)
oPrint:Line(nLinha,2040,nLinha+220,2040)
nLinha += 150
oPrint:Line(nLinha,0130,nLinha,0700)
oPrint:Line(nLinha,0800,nLinha,1300)
oPrint:Line(nLinha,1500,nLinha,2000)
oPrint:Line(nLinha,2200,nLinha,2850)

nLinha += 20

oPrint:Say((nLinha-10),0130,ALLTRIM(Posicione("SY1",3,xFilial("SY1")+cComprador,"Y1_NOME" )),oFont07) //aDadosUser[2]
oPrint:Say(nLinha,2200,if(MV_PAR06 == 1,'Liberacao do Pedido  -  Data:    /    /    ','Authorization Purchase  -  Date:    /    /    '),oFont08)

nLinha += 20
oPrint:Say(nLinha,0150,ALLTRIM(SY1->Y1_EMAIL),oFont07) // Email
//	oPrint:Say(nLinha,0150,aDadosUser[3],oFont08) // Email
*/

oPrint:Box(nLinha,0080,nLinha+220,2840)
oPrint:Line(nLinha,631,nLinha+220,631)
oPrint:Say(nLinha,0090,if(MV_PAR06 == 1,'Aprova็ใo','Approval'),oFont08)
///oPrint:Say(nLinha,0650,if(MV_PAR06 == 1,'Situa็ใo do Pedido','Status Purchase'),oFont08)
nLinha += 150
oPrint:Line(nLinha,0110,nLinha,0580)
///oPrint:Line(nLinha,0650,nLinha,1420)
nLinha += 20
///oPrint:Say(nLinha,0650,if(MV_PAR06 == 1,'Libera็ใo do Pedido  -  Data:    /    /    ','Authorization Purchase  -  Date:    /    /    '),oFont08)
nLinha += 50
If SM0->M0_CODIGO == "03"
	_cMens:="SISTEMA DE GESTรO DE QUALIDADE: ISO 9001:2015"
	Else
	_cMens:="-"
	EndIf
	oPrint:Say(nLinha,1680,OemToAnsi(_cMens),oFont12)

nLinha += 10

Return

********************************************************************************************************************************************************
Static Function _Email(pLogin)//Fun็ใo de localiza็ใo de Nome e email pelo login do microsiga
********************************************************************************************************************************************************
Local aUser	:= {}
Local cNome:=Space(60),cEmail:=Space(60)
PswOrder(2)
If PswSeek(pLogin)
	aUser := Aclone(PswRet(1))
	If Len(aUser) > 0
		cNome	:= AllTrim(aUser[1][4])	// Nome
		cEmail	:= AllTrim(aUser[1][14])	// e-mail
	Endif
Endif
Return({pLogin,cNome,cEmail})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_NumSemanaบAutor ณ                     บ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o numero da semana                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _NumSemana()

cRefer := "01/01/" + AllTrim( Str( Year(Stod( TRA->C6_ENTREG) ), 4 ) )
dRefer := CToD( cRefer )
nAcres := Dow( dRefer ) - 1
nSem   := ( Stod(TRA->C6_ENTREG) - dRefer ) + nAcres
nSem   := nSem / 7
nSem   := Iif( Subst( Str( nSem, 12, 2 ), 11, 2 )=="00", Int(nSem), Int(nSem)+1 )

Return( nSem )        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor ณ                     บ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o SX1 - Arquivo de Perguntas..                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
_sAlias := Alias(),;
nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampos a serem grav. no SX1ณ
//ณaRegs[nx][01] - X1_GRUPO   ณ
//ณaRegs[nx][02] - X1_ORDEM   ณ
//ณaRegs[nx][03] - X1_PERGUNTEณ
//ณaRegs[nx][04] - X1_PERSPA  ณ
//ณaRegs[nx][05] - X1_PERENG  ณ
//ณaRegs[nx][06] - X1_VARIAVL ณ
//ณaRegs[nx][07] - X1_TIPO    ณ
//ณaRegs[nx][08] - X1_TAMANHO ณ
//ณaRegs[nx][09] - X1_DECIMAL ณ
//ณaRegs[nx][10] - X1_PRESEL  ณ
//ณaRegs[nx][11] - X1_GSC     ณ
//ณaRegs[nx][12] - X1_VALID   ณ
//ณaRegs[nx][13] - X1_VAR01   ณ
//ณaRegs[nx][14] - X1_DEF01   ณ
//ณaRegs[nx][15] - X1_DEF02   ณ
//ณaRegs[nx][16] - X1_DEF03   ณ
//ณaRegs[nx][17] - X1_F3      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria uma array, contendo todos os valores...ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aRegs,{cPerg,'01','Pedido  De  ?       ','Pedido  De  ?       ','Pedido  De  ?       ','mv_ch1','C', 6,0,0,'G','','mv_par01','','','',''})
aAdd(aRegs,{cPerg,'02',"Pedido  Ate'?       ","Pedido  Ate'?       ","Pedido  Ate'?       ",'mv_ch2','C', 6,0,0,'G','','mv_par02','','','',''})

DbSelectArea('SX1')
SX1->(DbSetOrder(1))

For nX:=1 to Len(aRegs)
	If	RecLock('SX1',Iif(!SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])),.t.,.f.))
		Replace SX1->X1_GRUPO		With aRegs[nx][01]
		Replace SX1->X1_ORDEM   	With aRegs[nx][02]
		Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
		Replace SX1->X1_PERSPA		With aRegs[nx][04]
		Replace SX1->X1_PERENG		With aRegs[nx][05]
		Replace SX1->X1_VARIAVL		With aRegs[nx][06]
		Replace SX1->X1_TIPO		With aRegs[nx][07]
		Replace SX1->X1_TAMANHO		With aRegs[nx][08]
		Replace SX1->X1_DECIMAL		With aRegs[nx][09]
		Replace SX1->X1_PRESEL		With aRegs[nx][10]
		Replace SX1->X1_GSC			With aRegs[nx][11]
		Replace SX1->X1_VALID		With aRegs[nx][12]
		Replace SX1->X1_VAR01		With aRegs[nx][13]
		Replace SX1->X1_DEF01		With aRegs[nx][14]
		Replace SX1->X1_DEF02		With aRegs[nx][15]
		Replace SX1->X1_DEF03		With aRegs[nx][16]
		Replace SX1->X1_F3   		With aRegs[nx][17]
		MsUnlock('SX1')
	Else
		Help('',1,'REGNOIS')
	Endif
Next nX

Return

