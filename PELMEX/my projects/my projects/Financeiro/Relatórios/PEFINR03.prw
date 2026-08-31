#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ ALFINR01ณ Autor ณ Marcel R. Grosselli    ณ Data ณ 11/12/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO ITAU                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PEFINR03(cPathFile, cFilePrint) 
LOCAL aPergs   := {} 
LOCAL aArea    := GetArea()
LOCAL lRet     := .F.
LOCAL cPerg    := PADR("PEFINR03",Len(SX1->X1_GRUPO))
Local nTam1    := TamSX3("E1_NUM")[1]
Local nTam2    := TamSX3("E1_PARCELA")[1]
Local nLastKey := 0
Local cMarca   := ""
DEFAULT aDados     := {}
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
	Return SE1->(ImprimeBoleto(@cPathFile, @cFilePrint))
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
cFilter    += "(E1_XBANCO ='341' .Or. E1_XBANCO ='  ')"

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
	LOCAL cBanco    := "341"             
	LOCAL cAgencia  := Substr(GetMv("MV_XAGITA1"),01,05)
	LOCAL cConta    := Substr(GetMv("MV_XCCITA1"),01,10)
	LOCAL cSbConta  := Substr(GetMv("MV_XSBITA1"),01,03)  
	
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
	aDadosBanco := {"341" /*SA6->A6_COD*/,;                        // [1]Codigo do Banco
					SA6->A6_NREDUZ,;                               // [2]Nome do Banco
					SUBSTR(SA6->A6_AGENCIA, 1, 5),;                // [3]Ag๊ncia
					SUBSTR(SA6->A6_NUMCON,1,5) ,;                  // [4]Conta Corrente
					SA6->A6_DVCTA,;                                // [5]Dํgito da conta corrente
					SEE->EE_CODCART,;                              // [6]Codigo da Carteira
					SA6->A6_NUMBCO}                                // [7]Numero do Banco
	
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
					aDadosBanco[7], (SE1->E1_SALDO-(nVlrAbat+SE1->E1_DECRESC)), aDadosBanco[6], "9")
	
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
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ณฑฑ
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

cBmp    := cStartPath + "ITAU.BMP" //Logo do Banco Itau   
lImpPdf := .T.

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

nRow1 := IIF(lImpPdf, -50 , -50 )
                                                          
oPrint:Line (nRow1+0150,545,nRow1+0070, 545)
oPrint:Line (nRow1+0150,755,nRow1+0070, 755)

oPrint:SayBitmap(nRow1+0060,100,cBmp,240,90)

//oPrint:Say  (nRow1+IIF(lImpPdf, 0125, 0080 ), 180,"Banco Ita๚ S.A."  ,oFont14 )   // [2]Nome do Banco
oPrint:Say  (nRow1+IIF(lImpPdf, 0120, 0075 ),560,aDadosBanco[1]+"-7",oFont21) 		// [1]Numero do Banco     

oPrint:Say  (nRow1+IIF(lImpPdf, 0105, 0084 ),1900,"Comprovante de Entrega",oFont10 )
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+IIF(lImpPdf, 0175, 0150 ),100 ,"Beneficiแrio",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0225, 0200 ),100 ,substr(aDadosEmp[1],1,53),oFont10 )				//Nome + CNP

oPrint:Say  (nRow1+IIF(lImpPdf, 0175, 0150 ),1060,"Ag๊ncia / C๓digo Beneficiแrio",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0225, 0200 ),1060,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0175, 0150 ),1510,"Nro.Documento",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0225, 0200 ),1510,aDadosTit[7]+aDadosTit[1],oFont10 ) //Prefixo +Numero+Parcela  

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),100 ,"Pagador",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0325, 0300 ),100 ,aDatSacado[1],oFont10 )				//Nome

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),1060,"Vencimento",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0325, 0300 ),1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),1225,"Nosso N๚mero",oFont8 )
cString  := Transform(aDadosTit[6],"@R 999/99999999-9")
oPrint:Say  (nRow1+IIF(lImpPdf, 0325, 0300 ),1225,cString,oFont8 ) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),1510,"Valor do Documento",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0325, 0300 ),1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0425, 0400 ),0100,"Recebi(emos) o bloqueto/tํtulo",oFont10 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),0100,"com as caracterํsticas acima.",oFont10 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),1060,"Data",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),1410,"Assinatura",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),1060,"Data",oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),1410,"Entregador",oFont8 )

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 ) 
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )   
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0190, 0165 ),1910,"(  )Mudou-se"                                	,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0230, 0205 ),1910,"(  )Ausente"                                  ,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0270, 0245 ),1910,"(  )Nใo existe nบ indicado"                  	,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0310, 0285 ),1910,"(  )Recusado"                                	,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0350, 0325 ),1910,"(  )Nใo procurado"                            ,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0390, 0365 ),1910,"(  )Endere็o insuficiente"                  	,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0430, 0405 ),1910,"(  )Desconhecido"                            	,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0470, 0445 ),1910,"(  )Falecido"                                 ,oFont8 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0510, 0485 ),1910,"(  )Outros(anotar no verso)"                  ,oFont8 )

// Aceite do Cliente

nRow1 := nRow1 + IIF(lImpPdf, 560 , 625 )
 
oPrint:Line (nRow1+0150, 100,nRow1+0150,2300)
oPrint:Line (nRow1+0080,600,nRow1+0150,600)
oPrint:Line (nRow1+0080,780,nRow1+0150,780)

oPrint:SayBitmap(nRow1+0060,100,cBmp,240,90)

//oPrint:Say  (nRow1+IIF(lImpPdf, 0125, 0080 ), 180,"Banco Ita๚ S.A."  ,oFont14 )   // [2]Nome do Banco
oPrint:Say  (nRow1+IIF(lImpPdf, 0120, 0075 ), 613,aDadosBanco[1]+"-7",oFont18 )    // [1]Numero do Banco
oPrint:Say  (nRow1+IIF(lImpPdf, 0105, 0085 ), 810,aCB_RN_NN[2]       ,oFont10 )    // Linha Digitavel do Codigo de Barras
oPrint:Say  (nRow1+IIF(lImpPdf, 0105, 0085 ), 1940,"Recibo do Pagador" ,oFont10 ) 

oPrint:Line (nRow1+0250,100,nRow1+0250,2300 )
oPrint:Line (nRow1+0350,100,nRow1+0350,2300 )
oPrint:Line (nRow1+0420,100,nRow1+0420,2300 )
oPrint:Line (nRow1+0490,100,nRow1+0490,2300 )

oPrint:Line (nRow1+0350,500 ,nRow1+0490,500 )
oPrint:Line (nRow1+0420,750 ,nRow1+0490,750 )
oPrint:Line (nRow1+0350,1000,nRow1+0490,1000)
oPrint:Line (nRow1+0350,1300,nRow1+0420,1300)
oPrint:Line (nRow1+0350,1480,nRow1+0490,1480)

oPrint:Say  (nRow1+IIF(lImpPdf, 0175, 0150 ),100 ,"Local de Pagamento",oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0215, 0190 ),100 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAฺ. APำS O VENCIMENTO, SOMENTE NO ITAฺ",oFont9 )
           
oPrint:Say  (nRow1+IIF(lImpPdf, 0175, 0150 ),1810,"Vencimento",oFont8n )
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830
oPrint:Say  (nRow1+IIF(lImpPdf, 0215, 0190 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),100 ,"Beneficiแrio",oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),265 ,aDadosEmp[1] ,oFont10 ) //Nome + CNPJ
oPrint:Say  (nRow1+IIF(lImpPdf, 0315, 0290 ),100 ,"Endere็o ",oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0315, 0290 ),245 ,alltrim(aDadosEmp[2]) +" "+ alltrim(aDadosEmp[3])+" "+ alltrim(aDadosEmp[4]) ,oFont10 ) //Nome + CNPJ

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),1305,"CNPJ"                                   ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),1405,aDadosEmp[6]                             ,oFont10 ) //CNPJ

oPrint:Say  (nRow1+IIF(lImpPdf, 0275, 0250 ),1810,"Ag๊ncia / C๓digo do Beneficiแrio",oFont8n )
cString := Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5])
nCol    := 1830
oPrint:Say  (nRow1+IIF(lImpPdf, 0315, 0290 ),nCol,PADL(cString,17) ,oFont11c )

oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),100 ,"Data do Documento"                            ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0405, 0380 ),100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),505 ,"Nบ do Documento"                              ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0405, 0380 ),605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10 ) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),1005,"Esp้cie Doc."                                 ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0405, 0380 ),1050,aDadosTit[8]                                   ,oFont10 ) //Tipo do Titulo

oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),1305,"Aceite"                                       ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0405, 0380 ),1400,"N"                                            ,oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),1485,"Data Processamento"                        ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0405, 0380 ),1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10 ) // Data impressao

oPrint:Say  (nRow1+IIF(lImpPdf, 0375, 0350 ),1810,"Nosso N๚mero"                                 ,oFont8n )
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830
oPrint:Say  (nRow1+IIF(lImpPdf, 0405, 0380 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow1+IIF(lImpPdf, 0445, 0420 ),100 ,"Uso do Banco"                                 ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),150 ,"           "                                  ,oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0445, 0420 ),505 ,"Carteira"                                     ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),555 ,aDadosBanco[6]                                 ,oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0445, 0420 ),755 ,"Esp้cie"                                      ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),805 ,"R$"                                           ,oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0445, 0420 ),1005,"Quantidade"                                   ,oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0445, 0420 ),1485,"Valor"                                        ,oFont8n )

oPrint:Say  (nRow1+IIF(lImpPdf, 0445, 0420 ),1810,"(=)Valor do Documento"                     	,oFont8n )
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830
oPrint:Say  (nRow1+IIF(lImpPdf, 0475, 0450 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow1+IIF(lImpPdf, 0515, 0490 ),100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio.)",oFont8n )
oPrint:Say  (nRow1+IIF(lImpPdf, 0615, 0590 ),100 ,aBolText[1]  ,oFont10 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0665, 0640 ),100 ,aBolText[2]  ,oFont10 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0715, 0690 ),100 ,aBolText[3]  ,oFont10 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0765, 0740 ),100 ,aBolText[4]  ,oFont10 )
oPrint:Say  (nRow1+IIF(lImpPdf, 0815, 0790 ),100 ,aBolText[5]  ,oFont10 )

oPrint:Say  (nRow1+IIF(lImpPdf, 0515, 0490 ),1810,"(-)Desconto / Abatimento"                    ,oFont8n )
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830
oPrint:Say  (nRow1+IIF(lImpPdf, 0545, 0520 ),nCol,PADL(cString,17) ,oFont11c )

//oPrint:Say  (nRow1+IIF(lImpPdf, 0585, 0560 ),1810,"(-)Outras Dedu็๕es"                          ,IIF(lImpPdf,oFont11,oFont8n ))
oPrint:Say  (nRow1+IIF(lImpPdf, 0655, 0630 ),1810,"(+)Mora / Multa"                             ,oFont8n )
//oPrint:Say  (nRow1+IIF(lImpPdf, 0725, 0700 ),1810,"(+)Outros Acr้scimos"                        ,IIF(lImpPdf,oFont11,oFont8n ))
oPrint:Say  (nRow1+IIF(lImpPdf, 0795, 0770 ),1810,"(=)Valor Cobrado"                            ,oFont8n )

oPrint:Line (nRow1+0150,1800,nRow1+0840,1800 )//LINHA LATERAL 1765
oPrint:Line (nRow1+0560,1800,nRow1+0560,2300 )
oPrint:Line (nRow1+0630,1800,nRow1+0630,2300 )
oPrint:Line (nRow1+0700,1800,nRow1+0700,2300 )
oPrint:Line (nRow1+0770,1800,nRow1+0770,2300 )
oPrint:Line (nRow1+0840,100 ,nRow1+0840,2300 )

/*****************/
/* SEGUNDA PARTE */
/*****************/
nRow2 := nRow1 

oPrint:Say  (nRow2+IIF(lImpPdf, 0865, 0840 ),100 ,"Pagador"                                      ,oFont8n )
oPrint:Say  (nRow2+IIF(lImpPdf, 0865, 0840 ),230 ,aDatSacado[1]                                 ,oFont9 ) 
oPrint:Say  (nRow2+IIF(lImpPdf, 0865, 0840 ),1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 )  //CNPJ

oPrint:Say  (nRow2+IIF(lImpPdf, 0905, 0880 ),230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 ) 
oPrint:Say  (nRow2+IIF(lImpPdf, 0945, 0920 ),230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9 ) // CEP+Cidade+Estado

oPrint:Say  (nRow2+IIF(lImpPdf, 1000, 0985 ), 100,"Sacador/Avalista"                            ,oFont8n )
oPrint:Say  (nRow2+IIF(lImpPdf, 1000, 0985 ), 1200,"CNPJ" 			                           ,oFont8n )
oPrint:Say  (nRow2+IIF(lImpPdf, 1055, 1030 ),1620,"Autentica็ใo Mecโnica"                       ,oFont8n )
  
oPrint:Line (nRow2+1025,100 ,nRow2+1025,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow2 +  IIF(lImpPdf, 1145 , 1225 )

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0030, nI, nRow3+0030, nI+30)
Next nI

oPrint:Line (nRow3+0150, 100,nRow3+0150,2300)
oPrint:Line (nRow3+0080, 660,nRow3+0150, 660)
oPrint:Line (nRow3+0080, 850,nRow3+0150, 850)

oPrint:SayBitmap(nRow3+0060,100,cBmp,240,90)

//oPrint:Say  (nRow3+IIF(lImpPdf, 0125, 0080 ),180,"Banco Ita๚ S.A." ,oFont14 )  // [2]Nome do Banco

oPrint:Say  (nRow3+IIF(lImpPdf, 0120, 0075 ), 673,aDadosBanco[1]+"-7",oFont18 )    // [1]Numero do Banco
oPrint:Say  (nRow3+IIF(lImpPdf, 0105, 0085 ), 890,aCB_RN_NN[2]       ,oFont14 )    // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)

oPrint:Say  (nRow3+IIF(lImpPdf, 0175, 0150 ),100 ,"Local de Pagamento",oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0215, 0190 ),100 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAฺ. APำS O VENCIMENTO, SOMENTE NO ITAฺ",oFont9 )
           
oPrint:Say  (nRow3+IIF(lImpPdf, 0175, 0150 ),1810,"Vencimento",oFont8n )
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830
oPrint:Say  (nRow3+IIF(lImpPdf, 0215, 0190 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow3+IIF(lImpPdf, 0275, 0250 ),100 ,"Beneficiแrio",oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0315, 0290 ),100 ,aDadosEmp[1] ,oFont10 ) //Nome + CNPJ

oPrint:Say  (nRow3+IIF(lImpPdf, 0275, 0250 ),1305,"CNPJ"                                    ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0315, 0290 ),1305,aDadosEmp[6]                              ,oFont10 ) //CNPJ

oPrint:Say  (nRow3+IIF(lImpPdf, 0275, 0250 ),1810,"Ag๊ncia / C๓digo do Beneficiแrio",oFont8n )
cString := Alltrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4])+"-"+alltrim(+aDadosBanco[5])
nCol    := 1830
oPrint:Say  (nRow3+IIF(lImpPdf, 0315, 0290 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow3+IIF(lImpPdf, 0375, 0350 ),100 ,"Data do Documento"                            ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0405, 0380 ),100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10 )

oPrint:Say  (nRow3+IIF(lImpPdf, 0375, 0350 ),505 ,"Nบ do Documento"                              ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0405, 0380 ),605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10 ) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+IIF(lImpPdf, 0375, 0350 ),1005,"Esp้cie Doc."                                 ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0405, 0380 ),1050,aDadosTit[8]                                   ,oFont10 ) //Tipo do Titulo

oPrint:Say  (nRow3+IIF(lImpPdf, 0375, 0350 ),1305,"Aceite"                                       ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0405, 0380 ),1400,"N"                                            ,oFont10 )

oPrint:Say  (nRow3+IIF(lImpPdf, 0375, 0350 ),1485,"Data Processamento"                        ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0405, 0380 ),1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+IIF(lImpPdf, 0375, 0350 ),1810,"Nosso N๚mero"                                 ,oFont8n )
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830
oPrint:Say  (nRow3+IIF(lImpPdf, 0405, 0380 ),nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+IIF(lImpPdf, 0445, 0420 ),100 ,"Uso do Banco"                                 ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0475, 0450 ),150 ,"           "                                  ,oFont10 )

oPrint:Say  (nRow3+IIF(lImpPdf, 0445, 0420 ),505 ,"Carteira"                                     ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0475, 0450 ),555 ,aDadosBanco[6]                                 ,oFont10 )

oPrint:Say  (nRow3+IIF(lImpPdf, 0445, 0420 ),755 ,"Esp้cie"                                      ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0475, 0450 ),805 ,"R$"                                           ,oFont10 )

oPrint:Say  (nRow3+IIF(lImpPdf, 0445, 0420 ),1005,"Quantidade"                                   ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0445, 0420 ),1485,"Valor"                                        ,oFont8n )

oPrint:Say  (nRow3+IIF(lImpPdf, 0445, 0420 ),1810,"(=)Valor do Documento"                     	,oFont8n )
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830
oPrint:Say  (nRow3+IIF(lImpPdf, 0475, 0450 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow3+IIF(lImpPdf, 0515, 0490 ),100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio.)",oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0615, 0590 ),100 ,aBolText[1]  ,oFont10 )
oPrint:Say  (nRow3+IIF(lImpPdf, 0665, 0640 ),100 ,aBolText[2]  ,oFont10 )
oPrint:Say  (nRow3+IIF(lImpPdf, 0715, 0690 ),100 ,aBolText[3]  ,oFont10 )
oPrint:Say  (nRow3+IIF(lImpPdf, 0765, 0740 ),100 ,aBolText[4]  ,oFont10 )
oPrint:Say  (nRow3+IIF(lImpPdf, 0815, 0790 ),100 ,aBolText[5]  ,oFont10 )

oPrint:Say  (nRow3+IIF(lImpPdf, 0515, 0490 ),1810,"(-)Desconto / Abatimento"                    ,oFont8n )
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830
oPrint:Say  (nRow3+IIF(lImpPdf, 0545, 0520 ),nCol,PADL(cString,17),oFont11c )

oPrint:Say  (nRow3+IIF(lImpPdf, 0655, 0630 ),1810,"(+)Mora / Multa"                             ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0795, 0770 ),1810,"(=)Valor Cobrado"                            ,oFont8n )

oPrint:Say  (nRow3+IIF(lImpPdf, 0865, 0840 ),100 ,"Pagador"                                      ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 0865, 0840 ),230 ,aDatSacado[1]                                 ,oFont9 ) 
oPrint:Say  (nRow3+IIF(lImpPdf, 0865, 0840 ),1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 )  //CNPJ

oPrint:Say  (nRow3+IIF(lImpPdf, 0905, 0880 ),230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 ) 
oPrint:Say  (nRow3+IIF(lImpPdf, 0945, 0920 ),230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9 ) // CEP+Cidade+Estado

oPrint:Say  (nRow3+IIF(lImpPdf, 1000, 0985 ),1850,"C๓digo de Baixa:"  ,oFont9 )

oPrint:Say  (nRow3+IIF(lImpPdf, 1000, 0985 ), 100,"Sacador/Avalista"                            ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 1000, 0985 ), 1200,"CNPJ" 			                           ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 1055, 1030 ),1580,"Autentica็ใo Mecโnica "  ,oFont8n )
oPrint:Say  (nRow3+IIF(lImpPdf, 1055, 1030 ),1915,"Ficha de Compensa็ใo "  ,oFont8n )

oPrint:Line (nRow3+0150,1800,nRow3+0840,1800 ) 
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1025,100 ,nRow3+1025,2300 )

oPrint:FWMSBAR("INT25" , 63 , 2, aCB_RN_NN[1],oPrint,.F.,,.T./*lHorz*/,0.025/*nWidth*/,1.7/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL,.F.,100,100,.F.)

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
	cNosso := cCart + strzero(val(AllTrim(Str(Val(NossoNum()),8))),8)
	cNosso += Modulo10( cAgencia+Left(cConta,5)+cNosso )
Else
	cNosso := Alltrim(cCart) +AllTrim(SE1->E1_NUMBCO)
Endif

//Campo Livre
cCampoL  := cNosso + cAgencia + AllTrim(cConta) + AllTrim(cDacCC) + "000"

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
SE1->E1_XBANCO  := "341"
SE1->E1_NUMBCO  := substr(cNosso,4,9)
SE1->E1_VALJUR  := E1_SALDO * (GETMV("MV_XJURBOL")/30)/100
MsUnlock()

Return aRet

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
ฑฑบFuncao    ณ Modulo10 บAutor  ณMicrosiga           บ Data ณ  36/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do digito do nosso numero do pelo Modulo 10        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Modulo10(cVariavel)
   Local cBase, nBase, nAux, nSumDig, nDig

   cBase   := cVariavel
   nBase   := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
      nAux    -= If( nAux > 9 , 9, 0)
      nSumDig += nAux
      nBase   := If( nBase == 2 , 1, 2)
   Next

   nAux := 10 - Mod(nSumDig,10)
   If nAux == 10
      nAux := 0
   Endif

Return(Str(nAux,1))

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
