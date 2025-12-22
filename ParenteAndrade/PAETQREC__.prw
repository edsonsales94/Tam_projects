#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"

// NOME DO PC PA-ALMOX01
// NOME IMPRESSORA COMPARTILHADA ZD220-203
// CONFIGURAÇÃO LPT1 : net use LPT1: \\PA-ALMOX01\ZD220-203 senha /USER:usuario /PERSISTENT:YES


User Function PAETQREC()
	Local cPerg := "PAETIQUET"
	//Prepare Environment Empresa '01' Filial '01'  MODULO "EST"
	If Pergunte(cPerg , .T.)
		if FWAlertYesNo("<h3>Tem certeza que deseza imprimir " +cvaltochar(MV_PAR07) + " etiquetas com quantidades de "+transform(MV_PAR08, "@E 999,999")+ " em cada ? <\h3>", "Atencao !!!")
			Processa({|| xfImpPA()}, "Imprimindo...")
 
		endif
	EndIf
Return

Static Function xfImpPA()
	// Local aRet    := {}
	Local nX := 0
	Local nOpc := 0
	Local cQry0   := ""
	Local cDir    := "\etiquetas\" //pasta criada no protheus_data
	Local cFile   :=""
	Local cLabel  := ""
	Local cPrinterPath:= "" //compartilhamento da impressora na rede


	Local cBalsa := space(20)
	// Cria Fonte para visualização
	Local oFont := TFont():New('Courier new',,-18,.T.)

	Private ENTER:= char(13) + char(10)
	Private cCadastro := "Etiqueta Produto"

	cQry0 += "  select D1_DOC, D1_COD, D1_CC,D1_QUANT,D1_FORNECE,A2_NREDUZ, D1_UM, D1_EMISSAO, D1_PEDIDO, D1_QUANT, B1_POSIPI,B1_GRUPO,B1_DESC "
	cQry0 += "      from SD1010 D1 "
	cQry0 += "          INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_='' AND D1_COD=B1_COD "
	cQry0 += "          INNER JOIN SA2010 A2 ON A2.D_E_L_E_T_='' AND D1_FORNECE=A2_COD AND D1_LOJA=A2_LOJA "
	cQry0 += "      WHERE D1.D_E_L_E_T_='' AND D1_FILIAL='" +cFilAnt+"' and D1_DOC = '" +MV_PAR01 +"'"
	cQry0 += "          and D1_SERIE= '" +MV_PAR02 +"'"
	cQry0 += "          and D1_FORNECE= '" +MV_PAR03 +"'"
	cQry0 += "          and D1_LOJA= '" +MV_PAR04 +"'"
	if !Empty(MV_PAR02)
		cQry0 += "          AND D1_PEDIDO='" +MV_PAR05 +"'"
	endif
	cQry0 += "      AND D1_COD='" +MV_PAR06+"'"

	// MpSysOpenQUery(cQry0,"TMX")
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry0), "TMX", .T., .T. )

	Count TO nTotal

	TMX->(dbGoTop())
	if nTotal == 0 .or. Empty(TMX->D1_DOC)
		FWAlertWarning('Nota fiscal não encontrada', 'Aviso...')
		Return
	endif

	// caso o CC seja 1205, abre tela para informar a balsa.
	if AllTRim(TMX->D1_CC) == '1205' // 1205 cc das balsas
		oDlg := MSDialog():New(180,180,300,450,'Informe a balsa',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		oSay1:= TSay():New(01,01,{||'Balsa: '},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		oTGet1 := TGet():New( 01,40,{|u|if(PCount()==0,cBalsa,cBalsa:=u)},oDlg,070,009,"@!",{|| iif(Empty(cBalsa),.F.,.T.)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cBalsa,,,, )
		oTButton := TButton():New( 040, 50, "Cancelar",oDlg,{|| nOpc := 0,oDlg:end()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton := TButton():New( 040, 90, "Confirmar",oDlg,{||nOpc := 1,oDlg:end()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		oDlg:Activate()

		if nOpc == 0
			Return
		endif
	endif
	ProcRegua(MV_PAR07)
	for nX := 1 to MV_PAR07
		//Incrementa a mensagem na régua
        IncProc("Imprindo etiquetas " + cValToChar(nX) + " de " + cValToChar(MV_PAR07) + "...")
    
		cLabel:= ""
		cLabel+= ("CT~~CD,~CC^~CT~ ") +ENTER
		cLabel+= (" ^XA ") +ENTER
		cLabel+= (" ^MD10 ") +ENTER
		cLabel+= (" ~TA000 ") +ENTER
		cLabel+= (" ~JSN ") +ENTER
		cLabel+= (" ^LT0 ") +ENTER
		cLabel+= (" ^MNW ") +ENTER
		cLabel+= (" ^MTT ") +ENTER
		cLabel+= (" ^PON ") +ENTER
		cLabel+= (" ^PMN ") +ENTER
		cLabel+= (" ^LH0,0 ") +ENTER
		cLabel+= (" ^JMA ") +ENTER
		cLabel+= (" ^PR4,4 ") +ENTER
		cLabel+= (" ~SD17 ") +ENTER  // densidade
		cLabel+= (" ^JUS ") +ENTER
		cLabel+= (" ^LRN ") +ENTER
		cLabel+= (" ^CI27 ") +ENTER
		cLabel+= (" ^PA0,1,1,0 ") +ENTER
		cLabel+= (" ^XZ ") +ENTER
		cLabel+= (" ^XA ") +ENTER
		cLabel+= (" ^MMT ") +ENTER
		cLabel+= (" ^PW759 ") +ENTER
		cLabel+= (" ^LL559 ") +ENTER
		cLabel+= (" ^LS0 ") +ENTER
		cLabel+= (" ^FO7,20^GB746,526,4^FS ") +ENTER
		cLabel+= (" ^FO415,363^GB0,82,4^FS ") +ENTER
		cLabel+= (" ^FO8,197^GB743,0,3^FS ") +ENTER
		cLabel+= (" ^FO291,23^GB0,173,4^FS ") +ENTER
		cLabel+= (" ^FT677,175^A0N,25,25^FH\^CI28^FDPA^FS^CI27 ") +ENTER
		cLabel+= (" ^FO8,363^GB744,0,3^FS ") +ENTER
		cLabel+= (" ^FO8,443^GB743,0,4^FS ") +ENTER
		cLabel+= (" ^FT361,174^A0N,25,25^FH\^CI28^FD"+TMX->D1_UM+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT76,343^A0N,20,20^FH\^CI28^FD "+transform(MV_PAR08, "@E 999,999")+"  ^FS^CI27 ") +ENTER
		cLabel+= (" ^FT26,308^A0N,25,25^FH\^CI28^FDPC:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT614,174^A0N,25,25^FH\^CI28^FDTipo:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT428,175^A0N,25,25^FH\^CI28^FDGrupo:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT304,176^A0N,25,25^FH\^CI28^FDUM:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT509,349^A0N,25,25^FH\^CI28^FDUsuario:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT26,347^A0N,25,25^FH\^CI28^FDQtd:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT506,176^A0N,25,25^FH\^CI28^FD"+TMX->B1_GRUPO+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT529,412^A0N,45,46^FH\^CI28^FD"+Left(MesExtenso(Month(stod(TMX->D1_EMISSAO))),3) +"/"+ right(cvaltochar(year(stod(TMX->D1_EMISSAO))),2)+"^FS^CI27 ") +ENTER
		cLabel+= (" ^^FT159,398^A0N,20,20^FH\^CI28^FD"+alltrim(TMX->D1_CC)+ space(5)+iiF(Empty(AllTRim(cBalsa)),'','Balsa: '+AllTRim(cBalsa))+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT74,306^A0N,20,20^FH\^CI28^FD"+TMX->D1_PEDIDO+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT292,270^A0N,25,25^FH\^CI28^FDNota Fiscal:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT293,347^A0N,25,25^FH\^CI28^FDHora:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT26,270^A0N,25,25^FH\^CI28^FDData:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT293,309^A0N,25,25^FH\^CI28^FDNCM:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT22,400^A0N,25,25^FH\^CI28^FDC. Custo:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT26,231^A0N,25,25^FH\^CI28^FDFornecedor:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT405,97^A0N,20,20^FH\^CI28^FD"+SUBSTR(ALLTRIM(TMX->B1_DESC),1,34)+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT353,345^A0N,20,20^FH\^CI28^FD"+TIME()+"^FS^CI27 ") +ENTER
		if LEN(ALLTRIM(TMX->B1_DESC)) > 34
			cLabel+= (" ^FT305,134^A0N,20,20^FH\^CI28^FD"+SUBSTR(TMX->B1_DESC,35,LEN(TMX->B1_DESC))+"^FS^CI27 ") +ENTER
		endif
		cLabel+= (" ^FT355,306^A0N,20,20^FH\^CI28^FD"+TMX->B1_POSIPI+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT430,267^A0N,20,20^FH\^CI28^FD"+TMX->D1_DOC+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT95,268^A0N,20,20^FH\^CI28^FD"+DTOC(STOD(TMX->D1_EMISSAO))+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT303,56^A0N,25,25^FH\^CI28^FDCodigo:^FS^CI27 ") +ENTER
		cLabel+= (" ^FT303,100^A0N,25,25^FH\^CI28^FDProduto: ^FS^CI27 ") +ENTER
		cLabel+= (" ^FT606,347^A0N,20,20^FH\^CI28^FD"+UsrRetName(__cUserID)+"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT162,229^A0N,20,20^FH\^CI28^FD"+TMX->D1_FORNECE+" - "+ Alltrim(TMX->A2_NREDUZ) +"^FS^CI27 ") +ENTER
		cLabel+= (" ^FT392,55^A0N,20,20^FH\^CI28^FD"+TMX->D1_COD+"^FS^CI27 ") +ENTER
		cLabel+= (" ^BY4,3,47^FT213,517^BCN,,N,N ") +ENTER
		cLabel+= (" ^FH\^FD>;"+TMX->D1_DOC+"^FS ") +ENTER
		// cLabel+= (" ^FO24,43^GFA,1325,4256,32,:Z64:eJztVz1r40AQHW3s41ARvIV6k0roF1y5B3Zvg9PfTxFXBXM/QqhaNqA62M39lJRBHKqvim9mv1eSc5AyZLBlrPXbN2/e7K4M8HGC3VV3d+9GPygX9ey42Gw29ybEDLeKo5mdgVv4fr8fD+WE6jo/gRyNLzCW9yEOb7HrmLBnFloUvCiK1ZS9H3qM2Qw2QftcBtWUflLFIsLuKUIGhn7oIv1JAmPxNt6mH5kQ06P8gvMioe+HwcjvwwTuB+j8dkrvE/C/fzyfTif8PE0TKEZQ1M/3sXqMQYMGhVXo4gqQ/NB2S6q8qcZmpF7zMcqbjXpgGbUt4TPsAc65T78bSP6z+S5rh9cTCuG8N/ji4HrpIMBSadlWb/7ka+ItTPA7vFADcL5y8pEdC/CCixDgVoaapuYLyEi78BNuUvMbuDlj7k24a+kzj8e3xhv93DFp+aifDc/w5XfA19j6QojtCC+cn8JVyupn9K7hh1HlO2CZ4AF2wDn6T/zMlp/an/hruAX4G+FJfxHwYPB6xq3jf3S/ZmssKMBTYiCEbHU7QbaDjOtYubXn/EfBvwBeHF5S84t021uRC7aiO2d/5P83YHLUAAk/Jn/QDYD8u8Bv/MeCvMBtF/AL3/2u/4XG6xvbXbLzET87NzinM3DKv7RZTPX36P3N5bWvo1Uljf+eP/Orvoj1e/9vTuoxxk/9d/hs6j/y47fOjOex/zH+EKbcboUpVPDf9zxz/Tvqf4c3DRD3P/nP+v4PwOXyEuHR/+8JPiPdesqDE3ry/a+eIDudnuy8dv1BhN+ZC/B4/XfWf8TjpcMLePvCAtB4QdJtAwgn9DHod0WoVLQBL61bFk9bGI/3P1OAy2Xo1eXSYz6X11A+3ABnt39bytz7fz6rsPmr5AgtYtx+T5d0/9cFSM4/n/6V48+fP5W6EgBzCRSFOf+4O4BdC6bnf1S9zfwB6Oe+kgDAfALm+N/vwpixYCS/DuNzFYifP/IZ9gZGYScoTAGS5x+bQPL4U6foUQlGz1+TEkzY4xIk2m0ctQmuAvUUDKEGY3IdLKQwN2wjy/jVMYt+eAP+GR8u1M9aHaVUeAGppDqqI91gCl95TY/+9McH90B86hEL+iewEPha4LMXfgC0bdO2oNZlied+VbZtnjftEWBdsryqNcXqLf72iJxIXOYS8bJRivASmpIdy4baXi9/AfSJv0dqeoYBMF9B5RLp7mT5FTeyUjZtWTl+VjX/199UiFeS+HPEYx0qSgjvt3oZC732hSDiBZ4FxLpB9VgBuot5Vphzsy4rmbN1qRiTJeYE66ptmvK9rnyGjX/xSrGJ:5B97") +ENTER
		cLabel+= (" ^FO2,39^GFA,1005,5680,40,:Z64:eJztls1q20AUhccawxgvOi9gJKNlnkE03nXZV8nS0IDG1SLCGz9CTFdCz1CIjAte5gUKHaFFoJuMcSEONbq9I8lUP47jUi9K0bEHZPxxOLpz54eQVq1atWr1zyoMBSH9qXgF6+LnFPXDMJwTwx7+Zay9LtAvFL0g0D980sPhC9Hz/Z5fBUeo4pECuaYwgSQaQOpuD/jZWT4GYkdhAYl0GlxZDCLkYkjUC37z/lSnYZ5MabxWVDksGtdMSgVkkzilC+S2gwaX+QW2befcI5WaO+BXzjdJ3md+uwEbNfyIEYYXQZjlS+69OAYvRT9XVjhdvH0BmbdceSvkvg0aHPphyxT5YHXjYZ29+88NrpIPbpDrKLr6euB99eh/1A3IUg7Lx4miy12D63bzkfkJ5FYLRRdNLvczDLvgkiRWNGpylXzC7CTLw1zu1xPBvODiNfYVcrU+yGo32vu9JZuF5q4bXJGP6AZkwiEb+Yycw8SR/jumon5k6r8Cdotxgh/OLznXAr7A7QU7moSBOMqV+++4H36DIcka8AzK15uPO+Bxrqt1qt+nITH+JJ9JJGO7DhA2shSFqO4n5qSn63dJFJsBAkxaaZUblfY/5LbMwo1NcmmB1/AL7CLfpdgxzpNEcWnyZRmrykXOorFUXJmsymk/gYvX0Av4g0j5rLOR6o0yaVL1KxdvEwGzyFoq8wpXVM2PZNmyEwS5G45LRJnjOlcW/vX0Dv3iKwe5DdT9+rp2eIJ0Yrl5nJGfIB1Hc6LElXuvs5DrB/QDMUYuafjt55Yi94T5Cu7FfBSUAvR7iNz00Pvue4/CVrlYv0RCWq9fufnYl7G6xPmI5Q+rOR8E14Zh6xOOCeT4He5sipt3y+/l9y2Li2tlWTDBo4Zbbr3/stIFKMKJo/gMPPks+W2j/34/W8gxS3WkG7Fb7GdR87OHeb5zSPtNfWM6fW0DPO36kp2XZ82HFxc8O4Iwv8G8qFP2vlatWrVq1ep/1C/rxKkA:BAD8") +ENTER
		cLabel+= (" ^PQ1,0,1,Y ") +ENTER
		cLabel+= (" ^XZ ") +ENTER

		cPrinterPath:= "\\PA-ALMOX01\ZD220-203"

		cFile:= "etq_"+strtran(ALLTRIM(TMX->D1_DOC)+"-"+cvaltochar(nx),"/","-")+".txt"
		MemoWrite(cDir+cFile,cLabel )
		CpyS2T(cDir+cFile, "C:\TEMP", .T. )
		cExec:= 'cmd /c "COPY C:\TEMP\'+cFile +' '+ cPrinterPath+'" '
		nWait:= WaitRun(cExec,1)
	next nX
	TMX->(dbCloseArea())

Return
