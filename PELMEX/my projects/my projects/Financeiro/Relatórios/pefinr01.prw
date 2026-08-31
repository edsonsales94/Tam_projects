#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ PEFINR01ณ Autor ณ Marcel R. Grosselli    ณ Data ณ 24/01/23 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO BRADESCO                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PEFINR01(cPathFile, cFilePrint)
LOCAL aPergs   := {} 
LOCAL aArea    := GetArea()
LOCAL lRet     := .F.
Local cPerg    := PADR("PEFINR01",Len(SX1->X1_GRUPO))
Local nTam1    := TamSX3("E1_NUM")[1]
Local nTam2    := TamSX3("E1_PARCELA")[1]
Local nLastKey := 0
Local cMarca   := ""

DEFAULT cPathFile  := ""
DEFAULT cFilePrint := ""

PRIVATE lExec      := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
PRIVATE aDadosEmp  := {	SM0->M0_NOMECOM                                                           ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                                            ,; //[2]Endere็o
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")                            ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         } //[7]I.E

Aadd(aPergs,{"De Prefixo"  ,"","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo" ,"","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero"   ,"","","mv_ch3","C",nTam1,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero"  ,"","","mv_ch4","C",nTam1,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela"  ,"","","mv_ch5","C",nTam2,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela" ,"","","mv_ch6","C",nTam2,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao"  ,"","","mv_ch7","D",8,0,0,"G","","MV_PAR07","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao" ,"","","mv_ch8","D",8,0,0,"G","","MV_PAR08","","","","31/12/06","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Cliente"  ,"","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","       ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Cliente" ,"","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

If !Empty(cFilePrint)
	Return SE1->(ImprimeBoleto(cPathFile, @cFilePrint))
Else
	Pergunte(cPerg,.T.)
Endif

If nLastKey == 27
	Set Filter to
	Return lRet
Endif

cMarca := GetMark()

cIndexName := Criatrab(Nil,.F.)
cIndexKey  := "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO)"
cFilter    += "E1_FILIAL=='"+SE1->(xFilial())+"'.And.E1_SALDO>0.And."
cFilter    += "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
cFilter    += "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter    += "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter    += "DTOS(E1_EMISSAO)>='"+DTOS(mv_par07)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par08)+"' .And."
cFilter    += "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
cFilter    += "E1_TIPO $ 'BO ,BOL,FT ,DP ,NF ' .AND. "
cFilter    += "E1_XBANCO $ '237,   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

DbSelectArea("SE1")
dbGoTop()

DEFINE MSDIALOG oDlg TITLE "Sele็ใo de Titulos" FROM 00,00 TO 400,700 PIXEL
	
oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

oMark:oBrowse:Refresh()
oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .T.
oMark:oBrowse:bAllMark    := { || ( MarcaTudo( cMarca ), oMark:oBrowse:Refresh(.T.) ) }

DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTERED
	
dbGoTop()

If lExec
	Processa({|lEnd| lRet := MontaRel(cMarca) } )
Endif

DbSelectArea("SE1")
Set Filter to

RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

RestArea(aArea)

Return lRet

Static Function MarcaTudo(cMarca)
	Local nReg := SE1->(Recno())
	
	dbSelectArea("SE1")
	dbGoTop()
	While !Eof()
		Marcar(cMarca)
		dbSkip()
	Enddo
	dbGoTo(nReg)

Return .T.

Static Function Marcar(cMarca,oSom)
	RecLock("SE1",.F.)
	SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
	MsUnLock()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  MontaRelณ Autor ณ Microsiga             ณ Data ณ 06/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaRel(cMarca)
	Local cPath := ""
	Local lRet  := .F.
	
	dbGoTop()
	ProcRegua(RecCount())
	While !EOF()
		
		IncProc()
		
		If E1_OK == cMarca
			lRet := ImprimeBoleto(@cPath)
		Endif
		
		dbSkip()
	Enddo

Return lRet

Static Function ImprimeBoleto(cPathFile, cFilePrint)
	LOCAL oPrint, cMaxPar, cQuery, aDadosBanco, aDatSacado, nDescFin
	LOCAL aBolText  := {"","","","","",""}
	LOCAL aCB_RN_NN := {}
	LOCAL nVlrAbat  := 0
	LOCAL cBanco    := "237" //banco Bradesco
	LOCAL cAgencia  := Substr(GetMv("MV_XAGBDS"),01,05)//2164
	LOCAL cConta    := Substr(GetMv("MV_XCCBDS"),01,10)//18820-4
	LOCAL cSbConta  := Substr(GetMv("MV_XSBBDS"),01,03)//001
	
	Private aDadosTit
	
	// Calcula o total de parcelas geradas para o titulo
	cQuery := "SELECT MAX(E1_PARCELA)E1_PARCELA FROM "+RetSQLName("SE1")+" WHERE D_E_L_E_T_=' ' AND E1_FILIAL='"
	cQuery += SE1->(XFILIAL())+"' AND E1_NUM='"+E1_NUM+"' AND E1_PREFIXO='"+E1_PREFIXO+"' AND E1_CLIENTE='"
	cQuery += E1_CLIENTE+"' AND E1_LOJA='"+E1_LOJA+"'"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
	cMaxPar := E1_PARCELA
	dbCloseArea()
	dbSelectArea("SE1")
	
	//Posiciona o SA6 (Bancos)
	SA6->(DbSetOrder(1))
	SA6->(DbSeek(xFilial("SA6")+cBanco+PadR(cAgencia,05)+PadR(cConta,11),.T.))
	
	//Posiciona na Arq de Parametros CNAB
	SEE->(DbSetOrder(1))
	SEE->(DbSeek(xFilial("SEE")+cBanco+PadR(cAgencia,05)+PadR(cConta,11)+PadR(cSbConta,03),.T.))
	
	//Posiciona o SA1 (Cliente)
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
	
	DbSelectArea("SE1")
	aDadosBanco := {SA6->A6_COD,;                                  // [1]Codigo do Banco
					SA6->A6_NOME,;                                 // [2]Nome do Banco
					SUBSTR(SA6->A6_AGENCIA,2,4),;                              // [3]Ag๊ncia
					SA6->A6_NUMCON,;                               // [4]Conta Corrente
					SA6->A6_DVCTA,;                                // [5]Dํgito da conta corrente
					SUBSTR(SEE->EE_CODCART,1,2),;                  // [6]Codigo da Carteira
					SA6->A6_NUMBCO,;                               // [7]Numero do Banco
					SA6->A6_DVAGE}                                 // [8]Digito da Agencia
	
	If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razใo Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]C๓digo
		AllTrim(SA1->A1_END )                            ,;        // [3]Endere็o
		AllTrim(SA1->A1_MUN )                            ,;        // [4]Cidade
		SA1->A1_EST                                      ,;        // [5]Estado
		SA1->A1_CEP                                      ,;        // [6]CEP
		SA1->A1_CGC                                      ,;        // [7]CGC
		SA1->A1_PESSOA                                   ,;        // [8]PESSOA
		AllTrim(SA1->A1_BAIRRO)                           }        // [9]Bairro
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razใo Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]C๓digo
		AllTrim(SA1->A1_ENDCOB)                          ,;        // [3]Endere็o
		AllTrim(SA1->A1_MUNC)                            ,;        // [4]Cidade
		SA1->A1_ESTC                                     ,;        // [5]Estado
		SA1->A1_CEPC                                     ,;        // [6]CEP
		SA1->A1_CGC                                      ,;        // [7]CGC
		SA1->A1_PESSOA                                   ,;        // [8]PESSOA
		AllTrim(SA1->A1_BAIRROC)                          }        // [9]Bairro
	Endif
	
	nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	nDescFin := SE1->E1_DECRESC
	
	aCB_RN_NN := Ret_cBarra( SE1->E1_PREFIXO , SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO,;
					Subs(aDadosBanco[1],1,3), aDadosBanco[3], aDadosBanco[4], aDadosBanco[5],;
					aDadosBanco[7], (SE1->E1_VALOR-(nVlrAbat+SE1->E1_DECRESC)), aDadosBanco[6], "9")

	aDadosTit := {	E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
					If(Empty(cMaxPar),"","/"+cMaxPar)  ,;  // [1] N๚mero do tํtulo
					E1_EMISSAO                         ,;  // [2] Data da emissใo do tํtulo
					dDataBase                          ,;  // [3] Data da emissใo do boleto
					E1_VENCTO                          ,;  // [4] Data do vencimento
					E1_SALDO - nVlrAbat - E1_DECRESC   ,;  // [5] Valor do tํtulo
					aCB_RN_NN[3]                       ,;  // [6] Nosso n๚mero (Ver f๓rmula para calculo)
					E1_PREFIXO                         ,;  // [7] Prefixo da NF
					"DM"                               ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
					nDescFin                            }  // [9] Decrescimo

     aBolText[1]:=IIF(SA1->A1_XJURBOL<>"N","JUROS DIARIO DE: R$ "+SUBSTR(AllTrim(Transform(E1_SALDO * GETMV("MV_XJURBOL")/100,"@E 9,999,999.99")),1,13)+" A PARTIR DO DIA: "+SUBSTR(DTOC(E1_VENCTO),1,10),"")
     aBolText[2]:= IIF(SA1->A1_XJURBOL<>"N","MULTA DE: R$ "+SUBSTR(AllTrim(Transform(E1_SALDO * GETMV("MV_XMULBOL")/100,"@E 9,999,999.99")),1,13)+" A PARTIR DO DIA: "+SUBSTR(DTOC(E1_VENCTO+1),1,10),"")
     aBolText[3]:= IIF(SA1->A1_XPROTES<>"N","Sujeito ao Protesto apos 5 dias do vencimento","")
     aBolText[4] := "ษ TERMINANTEMENTE PROIBIDO FAZER O PAGAMENTO DESTE BOLETO VIA DEPำSITO, PIX OU TRANSFERENCIAS"
     aBolText[5]:= ""
     
Return SetupPrint(oPrint,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN, @cPathFile, @cFilePrint)

/*______________________________________________________________________________
ฆ Fun็ใo    ฆ SetupPrint ฆ Autor ฆ Ronilton O. Barros   ฆ Data ฆ 23/05/2017    ฆ
+-----------+------------+-------+----------------------+------+---------------+
ฆ Descri็ใo ฆ Configura a impressใo do boleto bancแrio                         ฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ*/
Static Function SetupPrint(oPrint,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN, cPathFile, cFilePrint)
	Local nUsaPDF    := 6 //IMP_PDF
	Local lVisualPDF := (cFilePrint == NIL)
	//Referente ao objeto de impressao
	Local lAdjustToLegacy := .T.  //Habilita a compatibilidade com a classe TMSPrinter
	Local lDisableSetup   := .T.  //Desabilita o setup de impressao
	
	DEFAULT cFilePrint    := LTrim(Str(Val(If(Empty(SE1->E1_NFELETR),SE1->E1_NUM,SE1->E1_NFELETR)),9))+;
								If(Empty(SE1->E1_PARCELA),"","_"+SE1->E1_PARCELA)+"_"+;
								Tira(Trim(Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_NOME"))) + ".pdf"
	DEFAULT cPathFile     := ""
	
	If Empty(cPathFile)
		cPathFile := cGetFile( '*.pdf' , 'Arquivos PDF', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY, GETF_NETWORKDRIVE ),.T., .T. )
	Endif
	
	If File(cPathFile+cFilePrint)
		FErase(cPathFile+cFilePrint)
	Endif
	
	oPrint := FWMSPrinter():New(@cFilePrint, nUsaPDF, lAdjustToLegacy, cPathFile, lDisableSetup, , , ,.T. , , , lVisualPDF, )
	oPrint:SetResolution(78)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(50,50,50,50)
	oPrint:cPathPDF := cPathFile
	
	Impress(oPrint,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
	
	oPrint:Preview()
	FreeObj(oPrint)
	oPrint := Nil
	
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  Impress ณ Autor ณ Microsiga             ณ Data ณ 06/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO LASERDO BRADESCO COM CODIGO DE BARRAS  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Impress(oPrint,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont7, oFont8, oFont11c, oFont10, oFont14, oFont16n, oFont15, oFont14n, oFont24, cString
LOCAL nI := 0
Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp := 030
Local cLogo := 030

cBmp  := cStartPath + "bradesco.bmp" //Logo do Banco 
cLogo := cStartPath + "LOGO_emp.bmp" //Logo da Empresa

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7   := TFont():New("Arial"      ,9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial"      ,9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial"      ,9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial"      ,9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont23  := TFont():New("Arial"      ,9,23,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova pแgina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := -50
 
//Linhas
oPrint:Line (nRow1+0125, 100,nRow1+0125,2300)
oPrint:Line (nRow1+0225, 100,nRow1+0225,1900 )
oPrint:Line (nRow1+0325, 100,nRow1+0325,1900 )
oPrint:Line (nRow1+0425,1050,nRow1+0425,1900 ) //---
oPrint:Line (nRow1+0525, 100,nRow1+0525,2300 )

//Colunas
oPrint:Line (nRow1+0525,1050,nRow1+0125,1050 )
oPrint:Line (nRow1+0525,1400,nRow1+0325,1400 )
oPrint:Line (nRow1+0325,1500,nRow1+0125,1500 ) //--
oPrint:Line (nRow1+0525,1900,nRow1+0125,1900 )
// Coluna do N๚mero do Banco 
oPrint:Line (nRow1+0125,500,nRow1+0070, 500)
oPrint:Line (nRow1+0125,710,nRow1+0070, 710)

//oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont14 )	// [2]Nome do Banco

If File(cBmp)
   oPrint:SayBitmap(nRow1+0060,100,cBmp,194,59)
Endif

oPrint:Say  (nRow1+0120,513,aDadosBanco[1],oFont21 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)

oPrint:Say  (nRow1+0150,100 ,"Beneficiario",oFont8)
oPrint:Say  (nRow1+0200,100 ,Substr(aDadosEmp[1],1,30),oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Ag๊ncia/C๓digo Beneficiแrio",oFont8)
oPrint:Say  (nRow1+0200,1060,alltrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4]),oFont10)

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/tํtulo",oFont10)
oPrint:Say  (nRow1+0450,0100,"com as caracterํsticas acima.",oFont10)
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )Nใo existe nบ indicado"                  	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )Nใo procurado"                            ,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Endere็o insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  ,oFont8)

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := nRow1 + 625

For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+05, nI, nRow2+05, nI+30)
Next nI

//Colunas do codigo do Banco 
oPrint:Line (nRow2+0080,1060,nRow2+0125,1060)
oPrint:Line (nRow2+0080,1250,nRow2+0125,1250)
//Linhas
oPrint:Line (nRow2+0125, 100,nRow2+0125,2300)
oPrint:Line (nRow2+0225,100,nRow2+0225,2300 )
oPrint:Line (nRow2+0325,100,nRow2+0325,2300 )
oPrint:Line (nRow2+0395,100,nRow2+0395,2300 )
oPrint:Line (nRow2+0465,100,nRow2+0465,2300 )
oPrint:Line (nRow2+0535,1800,nRow2+0535,2300)
oPrint:Line (nRow2+0605,1800,nRow2+0605,2300 )
oPrint:Line (nRow2+0675,1800,nRow2+0675,2300 )
oPrint:Line (nRow2+0745,1800,nRow2+0745,2300 )
oPrint:Line (nRow2+0815,100 ,nRow2+0815,2300 )
oPrint:Line (nRow2+1000,100 ,nRow2+1000,2300 )

//Colunas 
oPrint:Line (nRow2+0325,550 ,nRow2+0465,550 )
oPrint:Line (nRow2+0395,765 ,nRow2+0465,765 )
oPrint:Line (nRow2+0325,1000,nRow2+0465,1000)
oPrint:Line (nRow2+0325,1300,nRow2+0395,1300)
oPrint:Line (nRow2+0325,1480,nRow2+0465,1480)
oPrint:Line (nRow2+0125,1800,nRow2+0815,1800 )

If File(cBmp)
   oPrint:SayBitmap(nRow2+0060,100,cBmp,194,59)
Endif

oPrint:Say  (nRow2+0120,1073,aDadosBanco[1],oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow2+0080,1820,"Recibo do Pagador"   ,oFont11 )

oPrint:Say  (nRow2+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow2+0190,100 ,"PAGAVEL PREFERENCIALMENTE NA REDE BRADESCO OU BRADESCO EXPRESSO",oFont9)
           
oPrint:Say  (nRow2+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830
oPrint:Say  (nRow2+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0250,100 ,"Beneficiario",oFont8n)
oPrint:Say  (nRow2+0250,230 ,ALLTRIM(aDadosEmp[1])+" "+ALLTRIM(aDadosEmp[6]) ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0290,100 ,"Endere็o: ",oFont8n)
oPrint:Say  (nRow2+0290,230 ,alltrim(aDadosEmp[2])+" - "+alltrim(aDadosEmp[3]) ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0250,1810,"Ag๊ncia / C๓digo Beneficiario",oFont8n)
cString := Alltrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4])+"-"+alltrim(aDadosBanco[5])
nCol    := 1830
oPrint:Say  (nRow2+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow2+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow2+0350,555 ,"Nบ do Documento"                              ,oFont8n)
oPrint:Say  (nRow2+0380,645 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0350,1005,"Esp้cie Doc."                                 ,oFont8n)
oPrint:Say  (nRow2+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo
                                          	
oPrint:Say  (nRow2+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow2+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow2+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow2+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow2+0350,1810,"Nosso N๚mero"                                 ,oFont8n)
cString  := Transform(aDadosTit[6],"@R 99/99999999999-!")
nCol 	 := 1830
oPrint:Say  (nRow2+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow2+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow2+0420,555 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow2+0450,605 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow2+0420,780 ,"Esp้cie"                                      ,oFont8n)
oPrint:Say  (nRow2+0450,830 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow2+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow2+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow2+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1830
oPrint:Say  (nRow2+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0490,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:SayBitmap(nRow2+0500,1460,cLogo,0340,0386)
oPrint:Say  (nRow2+0540,100 ,aBolText[1]  ,oFont8)
oPrint:Say  (nRow2+0590,100 ,aBolText[2]  ,oFont8)
oPrint:Say  (nRow2+0640,100 ,aBolText[3]  ,oFont8)
oPrint:Say  (nRow2+0690,100 ,aBolText[4]  ,oFont8)
oPrint:Say  (nRow2+0740,100 ,aBolText[5]  ,oFont8)
oPrint:Say  (nRow2+0790,100 ,aBolText[6]  ,oFont8)

oPrint:Say  (nRow2+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830
oPrint:Say  (nRow2+0520,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0560,1810,"(-)Outras Dedu็๕es"                          ,oFont8n)
oPrint:Say  (nRow2+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
oPrint:Say  (nRow2+0700,1810,"(+)Outros Acr้scimos"                        ,oFont8n)
oPrint:Say  (nRow2+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow2+0840,100 ,"Pagador"                                      ,oFont8n)
oPrint:Say  (nRow2+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow2+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow2+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow2+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow2+0985, 100,"Pagador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow2+1030,1620,"Autentica็ใo Mecโnica"                       ,oFont8n)

/******************/
/* TERCEIRA PARTE */
/******************/
nRow3 := nRow2 + 1225

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0005, nI, nRow3+0005, nI+30)
Next nI

oPrint:Line (nRow3+0125, 100,nRow3+0125,2300)
oPrint:Line (nRow3+0080, 660,nRow3+0125, 660)
oPrint:Line (nRow3+0080, 850,nRow3+0125, 850)
//Linhas
oPrint:Line (nRow3+0225,100,nRow3+0225,2300 )
oPrint:Line (nRow3+0325,100,nRow3+0325,2300 )
oPrint:Line (nRow3+0395,100,nRow3+0395,2300 )
oPrint:Line (nRow3+0465,100,nRow3+0465,2300 )
oPrint:Line (nRow3+0535,1800,nRow3+0535,2300 )
oPrint:Line (nRow3+0605,1800,nRow3+0605,2300 )
oPrint:Line (nRow3+0675,1800,nRow3+0675,2300 )
oPrint:Line (nRow3+0745,1800,nRow3+0745,2300 )
oPrint:Line (nRow3+0815,100 ,nRow3+0815,2300 )
oPrint:Line (nRow3+1000,100 ,nRow3+1000,2300 )

//Colunas
oPrint:Line (nRow3+0325,550 ,nRow3+0465,550 )
oPrint:Line (nRow3+0395,750 ,nRow3+0465,750 )
oPrint:Line (nRow3+0325,1000,nRow3+0465,1000)
oPrint:Line (nRow3+0325,1300,nRow3+0395,1300)
oPrint:Line (nRow3+0325,1480,nRow3+0465,1480)
oPrint:Line (nRow3+0125,1800,nRow3+0815,1800 )

If File(cBmp)
    oPrint:SayBitmap(nRow3+0060,100,cBmp,194,59)
Endif

oPrint:Say  (nRow3+0120, 673,aDadosBanco[1],oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow3+0110, 890,aCB_RN_NN[2]       ,oFont14)    // Linha Digitavel do Codigo de Barras

oPrint:Say  (nRow3+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow3+0190,100 ,"PAGAVEL PREFERENCIALMENTE NA REDE BRADESCO OU BRADESCO EXPRESSO",oFont9)
           
oPrint:Say  (nRow3+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830
oPrint:Say  (nRow3+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0250,100 ,"Beneficiario",oFont8n)
oPrint:Say  (nRow3+0250,230 ,ALLTRIM(aDadosEmp[1])+" "+ALLTRIM(aDadosEmp[6]) ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+0290,100 ,"Endere็o: ",oFont8n)
oPrint:Say  (nRow3+0290,230 ,alltrim(aDadosEmp[2])+" - "+alltrim(aDadosEmp[3]) ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1810,"Ag๊ncia / C๓digo Beneficiario",oFont8n)
cString := Alltrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4])+"-"+alltrim(aDadosBanco[5])
nCol    := 1830
oPrint:Say  (nRow3+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,555 ,"Nบ do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,645 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Esp้cie Doc."                                 ,oFont8n)
oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso N๚mero"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 99/99999999999-!")
nCol    := 1830
oPrint:Say  (nRow3+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow3+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow3+0420,555 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,605 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow3+0420,780 ,"Esp้cie"                                      ,oFont8n)
oPrint:Say  (nRow3+0450,830 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830
oPrint:Say  (nRow3+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow3+0540,100 ,aBolText[1]  ,oFont8)
oPrint:Say  (nRow3+0590,100 ,aBolText[2]  ,oFont8)
oPrint:Say  (nRow3+0640,100 ,aBolText[3]  ,oFont8)
oPrint:Say  (nRow3+0690,100 ,aBolText[4]  ,oFont8)
oPrint:Say  (nRow3+0740,100 ,aBolText[5]  ,oFont8)
oPrint:Say  (nRow3+0790,100 ,aBolText[6]  ,oFont8)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830
oPrint:Say  (nRow3+0520,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0560,1810,"(-)Outras Dedu็๕es"                          ,oFont8n)
oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
oPrint:Say  (nRow3+0700,1810,"(+)Outros Acr้scimos"                        ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Pagador"                                      ,oFont8n)
oPrint:Say  (nRow3+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow3+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow3+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow3+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow3+0985,1850,"C๓digo de Baixa:"  ,oFont9)

oPrint:Say  (nRow3+0985, 100,"Pagador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow3+1030,1810,"Autentica็ใo Mecโnica/Ficha de Compensa็ใo"  ,oFont8n)

oPrint:FWMSBAR("INT25" , 64 , 1.2, aCB_RN_NN[1],oPrint,.F.,,.T./*lHorz*/,0.020/*nWidth*/,1.2/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL,.F.,100,100,.F.)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a pแgina

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRetDados  บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera SE1                        					          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,cDacCC,cNumBco,nValor,cCart,cMoeda)
Local cNosso      := ""
Local cCampoL     := ""
Local cFatorValor := ""
Local cLivre      := ""
Local cDigBarra   := ""
Local cBarra      := ""
Local cParte1     := ""
Local cDig1       := ""
Local cParte2     := ""
Local cDig2       := ""
Local cParte3     := ""
Local cDig3       := ""
Local cParte4     := ""
Local cParte5     := ""
Local cDigital    := ""
Local aRet        := {}

cAgencia := Left(Alltrim(cAgencia),4)

// Nosso Numero
If Empty(SE1->E1_NUMBCO)
	cNosso := cCart + AllTrim(Strzero(Val(NossoNum()),11))
	cNosso += Modulo11(cNosso)
Else
	cNosso := AllTrim(SE1->E1_NUMBCO)
Endif

//Campo Livre      4    13                               2                5       1      1
cCampoL  := cAgencia + substr(cNosso,1,LEN(cNosso)-1) + strzero(val(alltrim(cConta)),7)+"0"

// Campo livre do codigo de barra                   // verificar a conta
If nValor <= 0
	nValor := SE1->E1_VALOR
Endif

cFatorValor := Fator(SE1->E1_VENCTO) + StrZero(nValor * 100,10)

cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
cDigBarra := CALC_5p( cLivre )
cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,39)

// composicao da linha digitavel
cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
cDig1    := DIGIT001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := DIGIT001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := DIGIT001( cParte3 )
cParte4  := cDigBarra
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cParte1,6,4)+cDig1+" "+;
			substr(cParte2,1,5)+"."+substr(cParte2,6,5)+cDig2+" "+;
			substr(cParte3,1,5)+"."+substr(cParte3,6,5)+cDig3+" "+;
			cParte4+" "+;
			cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)

DbSelectArea("SE1")
RecLock("SE1",.F.)
SE1->E1_XBANCO  :="237"
SE1->E1_NUMBCO  := cNosso
SE1->E1_PORCJUR := GETMV("MV_XJURBOL")
MsUnlock()

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณModulo11   บAutor  ณMarcel Grosselli   บ Data ณ  23/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do digito do nosso numero pelo Modulo 11 com base 7 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Modulo11(cVariavel,lNosso)
	Local nDig
	Local cBase   := cVariavel
	Local nBase   := 2
	Local nSumDig := 0
	Local nAux    := 0
	
	For nDig:=Len(cBase) To 1 Step -1
		nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
		nSumDig += nAux
		nBase   += If( nBase == 7 , -5, 1)
	Next
	
	nAux := Mod(nSumDig,11) 
	
	If nAux > 0
		nAux := 11 - nAux
		If nAux == 10
			Return "P"
		Endif
	Endif

Return Str(nAux,1)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjustaSx1    ณ Autor ณ Microsiga            	ณ Data ณ 06/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica/cria SX1 a partir de matriz para verificacao          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1(cPerg, aPergs)
Local aCposSX1 := {}
Local nX       := 0
Local lAltera  := .F.
Local cKey     := ""
Local nJ       := 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCALC_5p   บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do digito do nosso numero do                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CALC_5p(cVariavel,lNosso)
	Local nDig
	Local cBase   := cVariavel
	Local nBase   := 2
	Local nSumDig := 0
	Local nAux    := 0
	
	For nDig:=Len(cBase) To 1 Step -1
		nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
		nSumDig += nAux
		nBase   += If( nBase == 9 , -7, 1)
	Next
	
	nAux := Mod(nSumDig * 10,11)
	
	If nAux == 0 .Or. nAux == 10
		If lNosso
			nAux := 0
		Else
			nAux := 1
		Endif
	Endif

Return Str(nAux,1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณFATOR		บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do FATOR  de vencimento para linha digitavel.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Fator(dVencto)
	Local cData  := DTOS(dVencto)
	Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return cFator

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณDIGIT001  บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPara calculo da linha digitavel do Unibanco                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DIGIT001(cVariavel)
	Local nDig, cValor
	Local cBase   := cVariavel
	Local nUmDois := 2
	Local nSumDig := 0
	Local nAux    := 0
	
	For nDig:=Len(cBase) To 1 Step -1
		nAux    := Val(SubStr(cBase, nDig, 1)) * nUmDois
		nSumDig += (nAux - If( nAux < 10 , 0, 9))
		nUmDois := 3 - nUmDois
	Next
	
	cValor := AllTrim(Str(nSumDig,12))
	nAux   := 10 - Val(SubStr(cValor,Len(cValor),1))
	
	If nAux == 10
		nAux := 0
	EndIf

Return Str(nAux,1)

Static Function Tira(cString)
	Local nPos1 := 0
	Local nPos2 := 0
	Local nPos3 := 0
	
	cString := StrTran(cString,".","")
	cString := StrTran(cString,"@","")
	cString := StrTran(cString,"&","")
	cString := StrTran(cString,"*","")
	cString := StrTran(cString,"(","")
	cString := StrTran(cString,")","")
	cString := StrTran(cString,"-","")
	cString := StrTran(cString,"+","")
	cString := StrTran(cString,"=","")
	cString := StrTran(cString,"/","")
	cString := StrTran(cString,"\","")
	cString := StrTran(cString,"$","")
	cString := StrTran(cString,"#","")
	cString := StrTran(cString,"!","")
	cString := StrTran(cString,"%","")
	cString := StrTran(cString,"จ","")
	
	nPos1 := At(" ",cString)
	If nPos1 > 0
		nPos2 := At(" ",SubStr(cString,nPos1+1,Len(cString))) + nPos1
		If nPos2 > 0
			nPos3 := At(" ",SubStr(cString,nPos2+1,Len(cString))) + nPos2
		Endif
	Endif
	
Return Trim(If( nPos3 > 0 , SubStr(cString,1,nPos3), cString))
