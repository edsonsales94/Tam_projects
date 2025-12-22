#include 'RwMake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'TbiConn.ch'

/***********************************************************************************************************
**** Autor     **              *****************************************************************************
**** Rotina    ** AAFATE03     ******************* Data  	** 29/06/2010 **********************************
**** Descricao ** Rotina para Preencher os Dados de Observacao, Transportadora, Volume, Especie ************
***************** Peso Liquido e Peso Bruto ****************************************************************
***********************************************************************************************************/
/*
Atualmente esta rotina eh chamada no momento da transmissao da Nota, o Ideal eh que o mesmo seja feito na
finalizacao da venda.
*/
//11232
//3
User Function AAFATE03(cTipo,cdMens)

Default cdMens := ""
Default cTipo := ""                                                                                                                  

If Type("cAcesso")  == "U"
  prepare environment Empresa '01' Filial '01' Tables Modulo 'EST'
EndIf

Private oDlg := Nil

If cTipo = 'S'
	Private cObsNFE1   := iIf(SF2->(FieldPos("F2_OBS1CX")) > 0,Padr(iIf(Empty(SF2->F2_OBS1CX),'',SF2->F2_OBS1CX),TamSX3('F2_OBS1CX')[01]),160)
	Private cObsNFE2   := iIf(SF2->(FieldPos("F2_OBS2CX")) > 0,Padr(iIf(Empty(SF2->F2_OBS2CX),'',SF2->F2_OBS2CX),TamSX3('F2_OBS2CX')[01]),160)
	Private cCodTransp := Padr(iIf(Empty(SF2->F2_TRANSP),'',SF2->F2_TRANSP),TamSX3('A4_COD')[01])
	Private cDesTransp := PADR(iIf(Empty(SF2->F2_TRANSP),'',Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')),20)
	Private nVolumes   := iIf( SF2->F2_VOLUME1 == 0,1,SF2->F2_VOLUME1)
	Private cEspecie   := Padr(iIf(Empty(SF2->F2_ESPECI1),'FARDO',SF2->F2_ESPECI1),TamSX3('F2_ESPECI1')[01])
	Private aCampo     := {"SD2->D2_COD"	, "SD2->D2_QUANT", "SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE", "SD2->D2_UM"}
	Private nPesoL     := 0
	Private nPesoB     := 0
	Private cdMarca    := Space(20)
	Private cdNota     := SF2->F2_DOC + '/' + SF2->F2_SERIE
	Private _cdCli     := SF2->F2_CLIENTE
	Private _cdLoj     := SF2->F2_LOJA
	Private _cdNome    := Posicione('SA1',1,xFilial('SA1') + SF2->(F2_CLIENTE + F2_LOJA) , "A1_NOME" )
	Private _xdVeiculo := SF2->F2_VEICUL1
Elseif cTipo = 'E'
	Private cObsNFE1   := iIf(SF1->(FieldPos("F1_OBS1CX")) > 0,Padr(iIf(Empty(SF1->F1_OBS1CX),'',SF1->F1_OBS1CX),TamSX3('F1_OBS1CX')[01]),160)
	Private cObsNFE2   := iIf(SF1->(FieldPos("F1_OBS2CX")) > 0,Padr(iIf(Empty(SF1->F1_OBS2CX),'',SF1->F1_OBS2CX),TamSX3('F1_OBS2CX')[01]),160)
	Private cCodTransp := Padr(iIf(Empty(SF1->F1_TRANSP),'',SF1->F1_TRANSP),TamSX3('A4_COD')[01])
	Private cDesTransp := PADR(iIf(Empty(SF1->F1_TRANSP),'',Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')),20)
	Private nVolumes   := iIf( SF1->F1_VOLUME1 == 0,1,SF1->F1_VOLUME1)
	Private cEspecie   := Padr(iIf(Empty(SF1->F1_ESPECI1),'FARDO',SF1->F1_ESPECI1),TamSX3('F1_ESPECI1')[01])
	Private aCampo     := {"SD1->D1_COD"	, "SD1->D1_QUANT", "SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE", "SD1->D1_UM"}
	Private nPesoL     := 0
	Private nPesoB     := 0
	Private cDi        := SD1->D1_XDI //Space(15)
	Private dData      := STOD("  /  /  ")
	Private cdMarca    := Space(20)
	Private cdNota     := SF1->F1_DOC + '/' + SF1->F1_SERIE
	Private _cdCli     := SF1->F1_FORNECE
	Private _cdLoj     := SF1->F1_LOJA
	Private _cdNome    := Posicione('SA2',1,xFilial('SA2') + SF1->(F1_FORNECE + F1_LOJA)  ,"A2_NOME")
	Private _xdVeiculo := ""
else
   Private cObsNFE1   := ""//iIf(SF1->(FieldPos("F1_OBS1CX")) > 0,Padr(iIf(Empty(SF1->F1_OBS1CX),'',SF1->F1_OBS1CX),TamSX3('F1_OBS1CX')[01]),160)
	Private cObsNFE2   := ""//iIf(SF1->(FieldPos("F1_OBS2CX")) > 0,Padr(iIf(Empty(SF1->F1_OBS2CX),'',SF1->F1_OBS2CX),TamSX3('F1_OBS2CX')[01]),160)
	Private cCodTransp := ""//Padr(iIf(Empty(SF1->F1_TRANSP),'',SF1->F1_TRANSP),TamSX3('A4_COD')[01])
	Private cDesTransp := ""//PADR(iIf(Empty(SF1->F1_TRANSP),'',Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')),20)
	Private nVolumes   := ""//iIf( SF1->F1_VOLUME1 == 0,1,SF1->F1_VOLUME1)
	Private cEspecie   := ""//Padr(iIf(Empty(SF1->F1_ESPECI1),'FARDO',SF1->F1_ESPECI1),TamSX3('F1_ESPECI1')[01])
	Private aCampo     := ""//{"SD1->D1_COD"	, "SD1->D1_QUANT", "SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE", "SD1->D1_UM"}
	Private nPesoL     := 0
	Private nPesoB     := 0	
	Private cdNota     := ""
	Private _cdCli     := ""
	Private _cdLoj     := ""
	Private _cdNome    := ""
	Private _xdVeiculo := ""
EndIf

iF cTipo = "S"
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE)))
	
	nPesoL := u_CalcPeso(,,,,aCampo,"SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE","SD2")
	nPesoB := nPesoL
	
elseIf cTipo = "E"
	SD1->(dbSetOrder(3))
	SD1->(dbSeek(SF1->(F1_FILIAL + F1_DOC+F1_SERIE)))
	
	nPesoL := u_CalcPeso(,,,,aCampo,"SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE","SD1")
	nPesoB := nPesoL
EndIf

@ 000,000 TO 350,400 DIALOG oDlg TITLE "Observacao da Nota Fiscal"
@ 001     ,010 SAY "Documento : " + cdNota of oDlg Pixel
@ 011     ,010 SAY "Cliente : " + _cdCli + '/' + _cdLoj + ' - ' + _cdNome of oDlg Pixel

@ 040 - 10,010 SAY "Transportadora" of Odlg Pixel
@ 050 - 10,010 GET cCodTransp SIZE 30,07 F3 'SA4' valid cDesTransp := Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')// of oDlg Pixel
@ 050 - 10,040 GET cDesTransp SIZE 155,07 of Odlg Pixel

@ 065 - 10,010 SAY "Volumes" of Odlg Pixel
@ 075 - 10,010 GET nVolumes SIZE 80,07  Picture '@E 999,999.99' of Odlg Pixel

@ 065 - 10,115 SAY "Especie" of Odlg Pixel
@ 075 - 10,115 GET cEspecie SIZE 80,07 of Odlg Pixel

@ 090 - 10,010 SAY "Peso Liquido" of Odlg Pixel
@ 100 - 10,010 GET nPesoL SIZE 80,07  Picture '@E 999,999.99' of Odlg Pixel //@E 999,999,999.999999                        

@ 090 - 10,115 SAY "Peso Bruto" of Odlg Pixel
@ 100 - 10,115 GET nPesoB SIZE 80,07  Picture '@E 999,999.99' of Odlg Pixel //@E 999,999,999.999999                        

@ 115 - 10,010 SAY "Marca " of Odlg Pixel
@ 125 - 10,010 GET cdMarca SIZE 185,07   of Odlg Pixel

If cTipo = 'E'
	@ 140 - 10,010 SAY "Numero DI" of Odlg Pixel
	@ 150 - 10,010 GET cDi SIZE 80,07  of Odlg Pixel
	
	@ 140 - 10,115 SAY "Data Registro" of Odlg Pixel
	@ 150 - 10,115 GET dData SIZE 80,07 of Odlg Pixel
Else                  
	dData := Date()
	
	@ 140 - 10,010 SAY "Veiculo" of Odlg Pixel
	@ 150 - 10,010 GET _xdVeiculo SIZE 80,07 F3 "DA3" //of Odlg Pixel
    //@ 050 - 10,010 GET cCodTransp SIZE 30,07 F3 'SA4' valid cDesTransp := Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')// of oDlg Pixel
	
	@ 140 - 10,115 SAY "Data Saida" of Odlg Pixel
	@ 150 - 10,115 GET dData SIZE 80,07 of Odlg Pixel
EndIf

@ 150,170 BMPBUTTON TYPE 01 ACTION Confirma(cTipo)
/*
@ 160,170 BMPBUTTON TYPE 01 ACTION Confirma(cTipo)
@ 170,170 BMPBUTTON TYPE 01 ACTION Confirma(cTipo)
@ 180,170 BMPBUTTON TYPE 01 ACTION Confirma(cTipo)
*/
ACTIVATE DIALOG oDlg CENTER

Return Nil

Static Function Confirma(cTipo)
Close(oDlg)

If cTipo = "S"
	SF2->(RecLock('SF2',.F.))
	
	If SF2->(FieldPos("F2_OBS1CX")) >0
		SF2->F2_OBS1CX := cObsNFE1
	EndIf
	If SF2->(FieldPos("F2_OBS2CX")) >0
		SF2->F2_OBS2CX := cObsNFE2
	EndIf
	If SF2->(FieldPos("F2_TRANSP")) >0
		SF2->F2_TRANSP := cCodTransp
	Endif
	If SF2->(FieldPos("F2_VOLUME1")) >0
		SF2->F2_VOLUME1:= nVolumes
	EndIf
	If SF2->(FieldPos("F2_ESPECI1")) > 0
		SF2->F2_ESPECI1:= cEspecie
	EndIf
	If SF2->(FieldPos("F2_PLIQUI")) > 0
		SF2->F2_PLIQUI := round(nPesoL, 3)
	EndIf
	If SF2->(FieldPos("F2_PBRUTO")) >0
		SF2->F2_PBRUTO := nPesoB
	EndIf
	If SF2->(FieldPos("F2_XMARCA")) >0
		SF2->F2_XMARCA := cdMarca
	EndIf     
	If SF2->(FieldPos("F2_EMINFE")) >0
		SF2->F2_EMINFE := dData
	EndIf     
	
	If SF2->(FieldPos("F2_VEICUL1")) >0
	   If !Empty(_xdVeiculo)
		   SF2->F2_VEICUL1 := _xdVeiculo  
	   EndIf
	EndIf
	
	SF2->(MsUnlock())
else
	SF1->(RecLock('SF1',.F.))
	
	If SF1->(FieldPos("F1_OBS1CX")) >0
		SF1->F1_OBS1CX := cObsNFE1
	EndIf
	If SF1->(FieldPos("F1_OBS2CX")) >0
		SF1->F1_OBS2CX := cObsNFE2
	EndIf
	If SF1->(FieldPos("F1_TRANSP")) >0
		SF1->F1_TRANSP := cCodTransp
	Endif
	If SF1->(FieldPos("F1_VOLUME1")) >0
		SF1->F1_VOLUME1:= nVolumes
	EndIf
	If SF1->(FieldPos("F1_ESPECI1")) >0
		SF1->F1_ESPECI1:= cEspecie
	EndIf
	If SF1->(FieldPos("F1_PLIQUI")) >0
		SF1->F1_PLIQUI := round(nPesoL, 3)
	EndIf
	If SF1->(FieldPos("F1_PBRUTO")) >0
		SF1->F1_PBRUTO := nPesoB
	EndIf
	If SF1->(FieldPos("F1_XNUMDI")) >0
		SF1->F1_XNUMDI := cDi
	EndIf
	If SF1->(FieldPos("F1_XDTREG")) >0
		SF1->F1_XDTREG := dData
	EndIf
	If SF1->(FieldPos("F1_XMARCA")) >0
		SF1->F1_XMARCA := cdMarca
	EndIf
	SF1->(MsUnlock())
	
EndIf
Return

User Function AAFAT03A(cdMens,cdNota)

Default cdMens := ""
Default cdNota := ""

//cdMens:= NoAcento(cdMens)

@ 000,000 TO 230,400 DIALOG oDlg TITLE "Observacao da Nota Fiscal  " 

@ 001,010 SAY "Observacoes Impressas na Nota" of Odlg Pixel
oTMultiget := TMultiget():New(010,010,{|u|if(Pcount()>0,cdMens:=u,cdMens)},;
                           oDlg,185,86,,,,,,.T.)
oTMultiGet:EnableHScroll ( .T. ) 
oTMultiGet:EnableVScroll ( .T. )
oTMultiget:lWordWrap := .T.

SButton():New( 100,170,13,{||oDlg:End()},oDlg,.T.,"Confirmar Dados",)
ACTIVATE DIALOG oDlg CENTER
Return cdMens

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0          
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString 
	cString := strTran( cString, cMaior, "" ) 
EndIf
If cMenor$ cString 
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

Return cString


/*powered by DXRCOVRB*/