#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "font.CH"

//  .----------------------------------------------------------------------------------------------------------------------.
// |     Ponto Entrada executado após a gravação da Venda da NF de Saída pelo Faturamento                                   |
// |     OBJETIVO 1: Gerar a NFE referente a Loja Solicitante (Transferência entre Lojas)                                   |
// |     OBJETIVO 2: Gerar NFE a Classificar quando for um Transferência entre Lojas e que NÃO foi realizado pelo Venda     |
//  '--------------------------------------------------------------------------------------------------------------------=='

User Function SF2460I()
Local cFunRes := SuperGetMv("MV_FUNRES",.F.,"MATA460A")
Local cArea   := GetArea()
Local aDados  := {}
Local lwRoman := .T.

//xwermeson 
//fGeraNFArm() ;;

//chamada da funcao para verificacao do valor da entrada pelo RA
//WERMESON EM 19/05/11 - SOLICTADO POR ALEXSANDRO (TOTVS)
//dbSelectArea("SA1")
//SA1->(dbSetOrder(1))
//SA1->(dbSeek( xFilial("SF2") + SF2->F2_CLIENTE + SF2->F2_LOJA ))

//Checa se o Titulo Gerado e do TIPO BOLETO para enviar via email
//Alert(SA1->A1_NOME)
//Alert(SA1->A1_COD_MUN)
If FindFunction("u_AAFATE14") 
	If Alltrim(SA1->A1_COD_MUN) <> "02603" //Para boletos itau somente clientes para fora de Manaus.
   		u_AAFATE14(SF2->F2_SERIE,SF2->F2_DOC)
	EndIf
EndIf 

dbSelectArea("SF2")
RecLock("SF2", .F.)
	SF2->F2_XCLIENT := SA1->A1_NOME
MsUnLock()


fGeraEntra()

SD2->(dbSetOrder(3))
SC5->(dbSetOrder(1))
SL4->(dbSetORder(1))
SL1->(dbSetORder(1))

SD2->(dBSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE) ))
While SF2->(F2_FILIAL + F2_SERIE + F2_DOC) == SD2->(D2_FILIAL + D2_SERIE + D2_DOC) .And. !SD2->(EOF())
	
	// incluido por Wermeson em 31/01/2014, conforme solicitacao do Sr. Franiscos e do Sr. Marcio Andre.
	// Retirado por Diego em 03/03/2016, Conforme Solicitado pelo Sr. Francisco
	
	/*
	SF4->(dbSetOrder(1))
	If !lwRoman .And. (SF4->( dbSeek( xFilial("SF4") + SD2->D2_TES ) ))
		If SF4->F4_ESTOQUE = 'S' .or. !subs(SD2->D2_CF,2,3) $ "118,119,122,922,924,949"
			lwRoman := .T.
		EndIf
		
	EndIf
	*/
	// Fim alteracao
	
	If SC5->(dbSeek( SD2->D2_FILIAL + SD2->D2_PEDIDO ))
		
		//Historico
		//Comentado para compilar na AMAZONACO SEM PROBLEMA
		
		aAdd(aDados,{'Z5_PEDIDO' ,SD2->D2_PEDIDO})
		aAdd(aDados,{'Z5_PRODUTO', SD2->D2_COD })
		aAdd(aDados,{'Z5_DATA'   ,dDataBase})
		aAdd(aDados,{'Z5_HORA'   ,Time()})
		aAdd(aDados,{'Z5_USER'   ,cUserName})
		aAdd(aDados,{'Z5_OP'     ,''})
		aAdd(aDados,{'Z5_OBS'    ,"Faturamento de Pedido"})
		aAdd(aDados,{'Z5_STATUS' , "4"})
		//aAdd(aDados,{'Z5_ENTREGA',AAGETDATA("Data Prevista Entrega")})
		//If ExistBlock("AALOGE02") Alterado Williams Messa 04/01/2021
		//	u_AALOGE02(aDados)
		//EndIf
		
		//Fim Historico
		iF SL1->(dbSeek( SC5->C5_FILIAL + SC5->C5_ORCRES )) .ANd. !Empty(SC5->C5_ORCRES)
			
			_cFormDel := SuperGetMv("MV_XFORMLJ",.F.,"BO")
			lDeleta := .F.
			If SL4->(dbSeek(SL1->L1_FILRES + SL1->L1_ORCRES) ) .AND. !EMPTY(SL1->L1_ORCRES)
				_cForma := SL4->L4_FORMA
				SL4->( DBEVAL({|| lDeleta := iIf( !(Alltrim(SL4->L4_FORMA) $ _cFormDel),.T.,lDeleta) },  {||SL4->(L4_FILIAL + L4_NUM) = SL1->L1_FILRES + SL1->L1_ORCRES}, {||SL4->(L4_FILIAL + L4_NUM) = SL1->L1_FILRES + SL1->L1_ORCRES}, , , ))
				
				If lDeleta .And. ExistBlock('AADELFIN')
					u_AADELFIN(xFilial('SE1'),SF2->F2_SERIE,SF2->F2_DOC)
				ElseIf !lDeleta
					SE1->(dbOrderNickName("SE1_NUM"))
					//Filial + Numero + Prefixo
					_cTipo := Padr("NF",Len(SE1->E1_TIPO))
					If SE1->(dBSeek(xFilial('SE1') + SF2->F2_DOC + SF2->F2_SERIE ))
						_cChave := SE1->(E1_FILIAL + E1_NUM + E1_PREFIXO)
						While ( _cChave == SE1->(E1_FILIAL + E1_NUM + E1_PREFIXO) )							
							SE1->(RecLock('SE1',.F.))
							SE1->E1_TIPO := _cForma
							SE1->(MsUnlock())								
							SE1->(dbSkip())
						EndDo
					EndIf
				EndIf
			EndIF
		EndIF
	EndIf
	SD2->(dbSkip())
EndDo



//
u_AAFATE03("S") //Observações da Nota Fiscal

If lwRoman .AND. SF2->F2_SERIE <> '6' //!(Alltrim(SF2->F2_CLIENTE) $ "001184|001188|001189")
	PreRomaneio()
EndIf

If ExistBlock("AAFATE04") .And. FunName() $ cFunRes
	u_AAFATE04("SF2",SF2->(Recno()),2)
EndIf

RestArea(cArea)
Return

//*******************************************************************************************************************************
Static Function PreRomaneio()
Local aPOs     := {}

_cArea := GetArea()
_lUsado := GetMv("MV_XENTFAT")

//If _lUsado
SD2->(DbSetOrder(3))
SD2->(DbSeek( SF2->(F2_FILIAL + F2_DOC  + F2_SERIE+ F2_CLIENTE + F2_LOJA) ) )

SC5->(DbSetOrder(1))
SC5->(DbSeek( xFilial("SC5") + SD2->D2_PEDIDO ))

dbSelectArea("SZE")
RecLock("SZE", .T.)
SZE->ZE_FILIAL  := xFilial("SZE")
SZE->ZE_CLIENTE := SF2->F2_CLIENTE
SZE->ZE_LOJACLI := SF2->F2_LOJA
If SF2->F2_TIPO $ "N,C,P,I"
	SZE->ZE_NOMCLI  := Posicione("SA1", 1, xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA, "A1_NOME")
else
	SZE->ZE_NOMCLI  := Posicione("SA2", 1, xFilial("SA2")+SF2->F2_CLIENTE + SF2->F2_LOJA, "A2_NOME")
end if
SZE->ZE_ORCAMEN := SC5->C5_NUM
SZE->ZE_SEQ     := "01"
SZE->ZE_VALOR   := SF2->F2_VALBRUT
SZE->ZE_DTVENDA := SF2->F2_EMISSAO
SZE->ZE_BAIRRO  := SC5->C5_BAIRROE
SZE->ZE_ORIGEM  := "MATA410"
SZE->ZE_VEND    := SC5->C5_VEND1
SZE->ZE_FILORIG := SC5->C5_FILIAL
SZE->ZE_DOC     := SF2->F2_DOC
SZE->ZE_SERIE   := SF2->F2_SERIE
SZE->ZE_STATUS  := ""
SZE->ZE_PLIQUI  := SF2->F2_PLIQUI
SZE->ZE_PBRUTO  := SF2->F2_PBRUTO

If SZE->(FieldPos("ZE_XORCRES")) > 0 .And. SC5->(FieldPos("C5_XORCRES")) > 0
	SZE->ZE_XORCRES := SC5->C5_XORCRES
EndIf

If SZE->(FieldPos("ZE_XFILRES")) > 0 .And. SC5->(FieldPos("C5_XFILRES")) > 0
	SZE->ZE_XFILRES := SC5->C5_XFILRES
EndIf

//DIEGO RAFAEL
If SZE->(FieldPos("ZE_PEDIDO")) > 0 .And. SC5->(FieldPos("C5_XORCRES")) > 0
	SZE->ZE_PEDIDO := SC5->C5_XORCRES
EndIf

If SZE->(FieldPos("ZE_FILLOJ")) > 0 .And. SC5->(FieldPos("C5_XFILRES")) > 0
	SZE->ZE_FILLOJ := SC5->C5_XFILRES
EndIf

If SZE->(FieldPos('ZE_EMPORIG')) > 0
   SZE->ZE_EMPORIG := FwCodEmp()
EndIf

MsUnLock()

u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Inclusao dos Registros")

dbSelectArea("SC6")
dbSkip()
//EndIf

RestArea( _cArea )
Return


Static Function AAGETDATA(_cMensagem)

Local _dData  := STOD("  /  /  ")

Define Font oFnt3 Name "Ms Sans Serif" Bold

while EMPTY(_dData)
	
	DEFINE MSDIALOG oDialog TITLE _cMensagem FROM 190,110 TO 300,370 PIXEL //STYLE nOR(WS_VISIBLE,WS_POPUP)
	@ 005,004 SAY Alltrim(_cMensagem)+" :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
	@ 025,004 GET _dData         SIZE 50,10  Pixel of oDialog
	
	@ 045,042 BMPBUTTON TYPE 1 ACTION(  IIF(_fdValid(_dData),oDialog:End(), NIL) )
	
	ACTIVATE DIALOG oDialog CENTERED
Enddo

Return _dData

Static Function _fdValid(_dData)

Local _lRet := .T.

If _dData < dDataBase
	AVISO("DATA INVALIDA","Data não pode ser inferior a DATA ATUAL" ,{"OK"})
	_lRet := .F.
EndIf

Return _lRet 



Static Function fGeraNFArm()
Local _cArea := GetArea()

if SF2->F2_CLIENTE $ '001189' 

	_FilialZ   :=  '01'
	_xdFornece := IIF ( fwCodFil() == "05",  "001723", iif(fwCodFil() == "06", "003058", "" ))
	_xdLoja    := "01"
	// Cabecalho da nota fiscal de entrada
	aCabec   := {}
	aadd(aCabec,{"F1_TIPO"   ,"N"})
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_DOC"    ,SF2->F2_DOC})
	aadd(aCabec,{"F1_SERIE"  ,SF2->F2_SERIE})
	aadd(aCabec,{"F1_EMISSAO",dDataBase})
	aadd(aCabec,{"F1_FORNECE",_xdFornece})
	aadd(aCabec,{"F1_LOJA"   ,_xdLoja})
	aadd(aCabec,{"F1_ESPECIE","SPED"})
	aadd(aCabec,{"F1_COND"    ,"449"})   
	aadd(aCabec,{"F1_MOEDA"   ,1})	
	aadd(aCabec,{"F1_FIMP"    ,"X"})	
	aAdd(aCabec,{"F1_STATUS" ,''})	
	
	// Itens da nota fiscal de entrada
	aItens   := {}
	dbSelectArea("SD2")
	dbSetOrder(3)
	SD2->(dbGoTop())
	dbSeek(xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)
	While !Eof() .And. xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
		// Incrementa regua de processamento
		IncProc()
		cGrade:="N"
		aLinha := {}
		cProdRef:=SD2->D2_COD
		nItem++
		aadd(aLinha,{"D1_ITEM" ,Strzero(nItem,4),Nil})
		aadd(aLinha,{"D1_COD"  ,SD2->D2_COD   ,Nil})
		aadd(aLinha,{"D1_QUANT",SD2->D2_QUANT ,Nil})
		aadd(aLinha,{"D1_VUNIT",SD2->D2_PRCVEN,Nil})
		aadd(aLinha,{"D1_TOTAL",SD2->D2_TOTAL ,Nil})
		aadd(aLinha,{"D1_LOCAL","01" ,Nil})
		aadd(aLinha,{"D1_GRADE",cGrade        ,Nil})
        //aadd(aLinha,{"D1_CC"   ,"100"         ,Nil})     
		//aadd(aLinha,{"D1_TES"  ,"027"         ,Nil})
		If Rastro(SD2->D2_COD,"L")
			aadd(aLinha,{"D1_LOTECTL",SD2->D2_LOTECTL,Nil})
			aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
		EndIf
		If Rastro(SD2->D2_COD,"S")
			aadd(aLinha,{"D1_NUMLOTE",SD2->D2_NUMLOTE,Nil})
			aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
		EndIf
		SD2->(DbSkip())
		
		aadd(aItens,aLinha)
	Enddo
	
	lRets :=  U_GERANFV( aCabec, aItens, _FilialZ  )   	
	If lRets
	   SF2->(RecLock('SF2',.F.))
	      SF2->F2_FILDEST := _FilialZ
	      SF2->F2_FORDES  := _xdFornece
	      SF2->F2_LOJADES := _xdLoja
	      SF2->F2_FORMDES := "N"
	   SF2->(MsUnlock())
	EndIf
ENDIF


RestArea(_cArea)

Return



User Function  GERANFV(AvET1,AVET3 ,avet6 )
Local aCabec := AVET1
Local aItens := AVET3 
Local cxFilial := AVET6
Local xdRestore := Nil
pRiVATE lMsErroAuto:=.f.
pRiVATE lMsHelpAuto:=.T.

QOUT(LEN(aCabec))
QOUT(LEN(aItens))

//Prepare Environment Empresa "01" FILIAL cxFilial Tables "SA1,SD1" MODULO "FAT"
 
// Reinicializa ambiente para o fiscal
If MaFisFound()
    xdRestore := MaFisSave()
	MaFisEnd()
EndIf

cFilBkp     := cFilAnt
cFilant     := cxFilial
nAux        := nModulo
nModulo     := 4
lMsErroAuto := .T.								
							
MATA140(aCabec,aItens,3) 
If lMsErroAuto
	Mostraerro()
EndIf
cFilAnt := cFilBkp
If (xdRestore != Nil)
    MsFisRestore(xdRestore)
EndIf


Return !lMsErroAuto


Static function fGeraEntra()
 Local aArea := GetArea()

 	SD2->(dbSetOrder(3))
 	SD2->(dBSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE) ))	

	SC5->(dbSetOrder(1))
	SC5->(dbSeek(SD2->(D2_FILIAL + D2_PEDIDO ) ))

	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(xFilial("SE1") + SC5->(C5_XRAPREF + C5_XRANUM + C5_XRAPARC + "RA"))) .AND. SE1->E1_SALDO > 0
		Alert("RA encontrado no PEDIDO " + SD2->D2_PEDIDO +"! O Sistema irá refazer o finaceiro!")
		fGeraPar(SE1->E1_SALDO, SE1->(RECNO()))
	EndIf
	
	RestArea(aArea)
Return Nil 


Static function fGeraPar(nwValSE1, nwRecRA)
 Local nwSaldo := 0
 Local cxParcs := fRetParcs(@nwSaldo) 
 Local lwDel   := .F.
	
	If nwValSE1 >= nwSaldo
		//Alert("O VAlor do RA é maior que o valor da Nota e será ajustado o financeiro!")

		nwValSE1 := nwSaldo
		lwDel    := 0 
		
		SE1->(dbSetOrder(1))
		If SE1->(dbSeek(xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC ))
			cxChave := xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC 
			While !SE1->(Eof()) .And. cxChave == xFilial('SE1') + SE1->E1_PREFIXO + SE1->E1_NUM 			
				Reclock("SE1", .F.)
					SE1->(dbDelete())
				MsUnlock()
			
				SE1->(dbSkip())
			End 
		EndIF 
	EndIf  

SE1->(dbSetOrder(1))
If !SE1->(dbSeek(xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC + "0R$" ))

	aTitulo := {}
	aAdd(aTitulo,{"E1_PREFIXO  ", SF2->F2_SERIE           ,nil})
	aAdd(aTitulo,{"E1_NUM      ", SF2->F2_DOC	          ,nil})
	aAdd(aTitulo,{"E1_PARCELA  ", "0"     		  	      ,nil})
	aAdd(aTitulo,{"E1_TIPO     ", "NF"              	  ,nil})

	aAdd(aTitulo,{"E1_EMISSAO  ", SF2->F2_EMISSAO         ,nil})
	aAdd(aTitulo,{"E1_VENCTO   ", SF2->F2_EMISSAO         ,nil})
	aAdd(aTitulo,{"E1_VENCREA  ", SF2->F2_EMISSAO         ,nil})
	aAdd(aTitulo,{"E1_CLIENTE  ", SF2->F2_CLIENTE     	  ,nil}) //cCliente
	aAdd(aTitulo,{"E1_LOJA     ", SF2->F2_LOJA        	  ,nil})
	aAdd(aTitulo,{"E1_NATUREZ  ", "DINHEIRO"              ,nil})         
	aAdd(aTitulo,{"E1_NOMCLI   ", SA1->A1_NREDUZ          ,nil})
	aAdd(aTitulo,{"E1_VALOR    ", nwValSE1           	  ,nil})
	aAdd(aTitulo,{"E1_VLCRUZ   ", nwValSE1      	      ,nil})
	aAdd(aTitulo,{"E1_MOEDA"    , 1             		  ,nil})
	aAdd(aTitulo,{"E1_MOVIMEN"  , SF2->F2_EMISSAO         ,nil})
	aAdd(aTitulo,{"E1_ORIGEM"   , "MATA460" 		   	  ,nil})
	aAdd(aTitulo,{"E1_VEND1"    , SF2->F2_VEND1 		  ,nil})
	aAdd(aTitulo,{"E1_SALDO"    , SC5->C5_XENTRAD 	      ,nil})
	aAdd(aTitulo,{"E1_VENCORI"  , SF2->F2_EMISSAO         ,nil})
	aAdd(aTitulo,{"E1_EMIS1"    , SF2->F2_EMISSAO         ,nil})
	aAdd(aTitulo,{"E1_FILIAL"   , xFilial("SE1")  	      ,nil})
 
	Private lMsHelpAuto := .T. // Variavel de controle interno do ExecAuto
	Private lMsErroAuto := .F. // Variavel que informa a ocorrência de erros no ExecAuto

	MsExecAuto({|x,y| FINA040(x,y) } , aTitulo, 3)

	If lMsErroAuto
		Mostraerro()
		DisarmTransaction()
		RollBackSx8()
	Else
		fwCompCR(nwRecRA, SE1->(Recno()))
		fRateiaE(nwValSE1)	
	EndIf
EndIf
Return 


Static Function fRateiaE(cxValor)
 Local cxParcs := fRetParcs() 
 Local nwSaldo := cxValor
 Local nwItem  := 0
 Local cQry    := ""

	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC ))
		cxChave := xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC
		
		While !SE1->(Eof()) .And. cxChave == xFilial('SE1') + SE1->E1_PREFIXO + SE1->E1_NUM 
			IF SE1->E1_PARCELA <> "0"
				nwItem := nwItem+1 
				
				Reclock("SE1", .F.)
					If nwItem == cxParcs
							SE1->E1_VALOR  := SE1->E1_VALOR  - nwSaldo
							SE1->E1_SALDO  := SE1->E1_SALDO  - nwSaldo
							SE1->E1_VLCRUZ := SE1->E1_VLCRUZ - nwSaldo				
						Else 
							SE1->E1_VALOR  := SE1->E1_VALOR  - ROUND(cxValor/cxParcs,2)
							SE1->E1_SALDO  := SE1->E1_SALDO  - ROUND(cxValor/cxParcs,2)
							SE1->E1_VLCRUZ := SE1->E1_VLCRUZ - ROUND(cxValor/cxParcs,2)
							
							nwSaldo := nwSaldo - ROUND(cxValor/cxParcs,2)
					EndIf 
				MsUnlock()
			EndIf 

			SE1->(dbSkip())
		End 
		
	EndIf  
	
Return


Static Function fRetParcs(nwValor) 
Local cxNum := 0

_xQry := ""
_xQry += " Select count(*) SOMAS, SUM(E1_SALDO) AS SALDO From " + RetSqlName("SE1") + " E1 "
_xQry += "  Where E1.D_E_L_E_T_ = ' ' "
_xQry += "  And E1_NUM     = '" + SF2->F2_DOC   + "'"
_xQry += "  And E1_PREFIXO = '" + SF2->F2_SERIE + "'"
_xQry += "  And E1_PARCELA <> '0' AND E1_TIPO = 'NF'  "
_xQry += "  And E1_CLIENTE    = '" + SF2->F2_CLIENTE   + "'"
_xQry += "  And E1_LOJA       = '" + SF2->F2_LOJA     + "'"
_xQry += "  And E1_PARCELA   <> '0' " 

_xdTbl := MpSysOpenQuery(_xQry)
dBselectarea(_xdTbl)

If !(_xdTbl)->(Eof())
	cxNum    := (_xdTbl)->SOMAS
	nwValor  := (_xdTbl)->SALDO
EndIf

Return cxNum


Static FUNCTION fwCompCR(nwRecRA, nwRecSE1)
Local lRetOK := .T.
Local aArea  := GetArea()
Local nTaxaCM := 0
Local aTxMoeda := {}
Private nRecnoNDF
Private nRecnoE1

	nRecnoRA := nwRecRA
    nRecnoE1 := nwRecSE1
    
	PERGUNTE("AFI340",.F.)
    
	lContabiliza  := MV_PAR11 == 1
    lAglutina   := MV_PAR08 == 1
    lDigita   := MV_PAR09 == 1
    nTaxaCM := RecMoeda(dDataBase,SE1->E1_MOEDA)
    aAdd(aTxMoeda, {1, 1} )	
	aAdd(aTxMoeda, {2, nTaxaCM} )

    SE1->(dbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_FORNECE+E1_LOJA
  
    aRecRA := { nRecnoRA }
    aRecSE1 := { nRecnoE1 }
   
    If !MaIntBxCR(3,aRecSE1,,aRecRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase )
    	Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)
        lRet := .F.
		Else 
			AVISO("ENTRADA+PARCELA","Compensacao realizada!" ,{"OK"})
    ENDIF
          
	RestArea(aArea)
Return lRetOK
