#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SAFINR01 ³ Autor ³ Microsiga             ³ Data ³ 19/08/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO DO BRASIL COM CODIGO DE BARRAS   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SAFINR01(cPathFile, cFilePrint)
LOCAL aPergs   := {} 
LOCAL aArea    := GetArea()
LOCAL lRet     := .F.
Local cPerg    := PADR("SAFINR01",Len(SX1->X1_GRUPO))
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
						SM0->M0_ENDCOB                                                            ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
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
cFilter    += "E1_TIPO $ 'BO ,BOL,FT ,FI ,DP ,NF ' .AND. "
cFilter    += "E1_XBANCO $ '001,   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

DbSelectArea("SE1")
dbGoTop()

DEFINE MSDIALOG oDlg TITLE "Seleção de Titulos" FROM 00,00 TO 400,700 PIXEL

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	LOCAL cBanco    := "001"
	LOCAL cAgencia  := substr(GetMv("MV_XAGBB"),01,05)
	LOCAL cConta    := substr(GetMv("MV_XCCBB"),01,10)
	LOCAL cSbConta  := substr(GetMv("MV_XSBBB"),01,03)
	
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
	SA6->(DbSeek(xFilial("SA6")+cBanco+PadR(cAgencia,05)+PadR(cConta,10),.T.))
	
	//Posiciona na Arq de Parametros CNAB
	SEE->(DbSetOrder(1))
	SEE->(DbSeek(xFilial("SEE")+cBanco+PadR(cAgencia,05)+PadR(cConta,10)+PadR(cSbConta,03),.T.))
	
	//Posiciona o SA1 (Cliente)
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
	
	DbSelectArea("SE1")
	aDadosBanco := {SA6->A6_COD,;                                  // [1]Codigo do Banco
					SA6->A6_NREDUZ,;                               // [2]Nome do Banco
					SA6->A6_AGENCIA,;                              // [3]Agência
					SA6->A6_NUMCON,;                               // [4]Conta Corrente
					SA6->A6_DVCTA,;                                // [5]Dígito da conta corrente
					"017",;                                        // [6]Codigo da Carteira
					SA6->A6_NUMBCO,;                               // [7]Numero do Banco
					SA6->A6_DVAGE}                                 // [8]Digito da Agencia
	
	If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]Código
		AllTrim(SA1->A1_END )                            ,;        // [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;        // [4]Cidade
		SA1->A1_EST                                      ,;        // [5]Estado
		SA1->A1_CEP                                      ,;        // [6]CEP
		SA1->A1_CGC                                      ,;        // [7]CGC
		SA1->A1_PESSOA                                   ,;        // [8]PESSOA
		AllTrim(SA1->A1_BAIRRO)                           }        // [9]Bairro
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]Código
		AllTrim(SA1->A1_ENDCOB)                          ,;        // [3]Endereço
		AllTrim(SA1->A1_MUNC)                            ,;        // [4]Cidade
		SA1->A1_ESTC                                     ,;        // [5]Estado
		SA1->A1_CEPC                                     ,;        // [6]CEP
		SA1->A1_CGC                                      ,;        // [7]CGC
		SA1->A1_PESSOA                                   ,;        // [8]PESSOA
		AllTrim(SA1->A1_BAIRROC)                          }        // [9]Bairro
	Endif
	
	nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	nDescFin := Round(SE1->E1_VALOR * SE1->E1_DESCFIN / 100,2)
	
	aCB_RN_NN := Ret_cBarra( SE1->E1_PREFIXO , SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO,;
					Subs(aDadosBanco[1],1,3), aDadosBanco[3], aDadosBanco[4], aDadosBanco[5],;
					aDadosBanco[7], (SE1->E1_SALDO-(nVlrAbat+SE1->E1_DECRESC)+SE1->E1_ACRESC), "17", "9")
	
	aDadosTit := {	E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
					If(Empty(cMaxPar),"","/"+cMaxPar)  ,;  // [1] Número do título
					E1_EMISSAO                         ,;  // [2] Data da emissão do título
					dDataBase                          ,;  // [3] Data da emissão do boleto
					E1_VENCTO                          ,;  // [4] Data do vencimento
					E1_SALDO - nVlrAbat - E1_DECRESC + E1_ACRESC,;  // [5] Valor do título
					aCB_RN_NN[3]                       ,;  // [6] Nosso número (Ver fórmula para calculo)
					E1_PREFIXO                         ,;  // [7] Prefixo da NF
					"DM"                               ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
					nDescFin                            }  // [9] Decrescimo
	
	//aBolText[1] := "MORA DIA/ COM. PERMANENCIA DE: R$ "+SUBSTR(AllTrim(Transform(E1_SALDO * GETMV("MV_XJURBOL")/100,"@E 9,999,999.99")),1,13)
	//aBolText[2] := "APÓS "+SUBSTR(DTOC(E1_VENCTO),1,10)+" MULTA DE: R$ "+SUBSTR(AllTrim(Transform(E1_SALDO * GETMV("MV_XMULBOL")/100,"@E 9,999,999.99")),1,13)
	
      aBolText[1] := "Após o vencimento " + DTOC(E1_VENCTO) + ;
               " Juros diários de 0,0333% ao dia, máximo 1% ao mês: R$ " + ;
               SUBSTR(AllTrim(Transform((E1_SALDO * GETMV("MV_XJURBOL")) / 100, "@E 9,999,999.99")), 1, 13) + ;
               " Multa de 2%: R$ " + ;
               SUBSTR(AllTrim(Transform((E1_SALDO * GETMV("MV_XMULBOL")) / 100, "@E 9,999,999.99")), 1, 13)
      aBolText[2] := "Após a Data:" + DTOC(E1_VENCTO + 10) + " Será Enviado para Protesto "
      aBolText[3]:= "Sujeito ao Serasa e SPC após 15 dias do vencimento"
    

Return SetupPrint(oPrint,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN, @cPathFile, @cFilePrint)

/*______________________________________________________________________________
¦ Função    ¦ SetupPrint ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 23/05/2017    ¦
+-----------+------------+-------+----------------------+------+---------------+
¦ Descrição ¦ Configura a impressão do boleto bancário                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont7, oFont8, oFont11c, oFont10, oFont14, oFont16n, oFont15, oFont14n, oFont24, cString
LOCAL nI := 0
Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp := cStartPath + "BBRASIL.bmp" //Logo do Banco 

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

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := -50

oPrint:Line (nRow1+0150,550,nRow1+0070, 550)
oPrint:Line (nRow1+0150,760,nRow1+0070, 760) 

oPrint:SayBitmap(nRow1+0060,100,cBmp,75,65)
oPrint:Say  (nRow1+0100,180 ,"BANCO DO BRASIL" ,oFont10 )     // [2]Nome do Banco

oPrint:Say  (nRow1+0120,562,aDadosBanco[1]+"-9",oFont21)		// [1]Numero do Banco

oPrint:Say  (nRow1+0105,1900,"Comprovante de Entrega",oFont10 )
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0175,100 ,"Beneficiário",oFont8)
oPrint:Say  (nRow1+0225,100 ,aDadosEmp[1],oFont10 )				//Nome + CNPJ

oPrint:Say  (nRow1+0175,1060,"Agência/Código Beneficiário",oFont8)
oPrint:Say  (nRow1+0225,1060, Alltrim(substr(aDadosBanco[3],1,4)+"-"+aDadosBanco[8]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5]),oFont10)

oPrint:Say  (nRow1+0175,1510,"Nro.Documento",oFont8 )
oPrint:Say  (nRow1+0225,1510,aDadosTit[7]+aDadosTit[1],oFont10 ) //Prefixo +Numero+Parcela  

oPrint:Say  (nRow1+0275,100 ,"Pagador",oFont8 )
oPrint:Say  (nRow1+0325,100 ,substr(aDatSacado[1],1,40),oFont10 )				//Nome

oPrint:Say  (nRow1+0275,1060,"Vencimento / Nosso Número",oFont8 )
oPrint:Say  (nRow1+0325,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont8 )

If Len(AllTrim(aDadosTit[6])) < 13
   cString  := Transform(aDadosTit[6],"@R 99999999999-A")
Else
   cString  := Transform(aDadosTit[6],"@R 99999999999999999")
Endif

oPrint:Say  (nRow1+0325,1220,cString,oFont8 ) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0275,1510,"Valor do Documento",oFont8 )
oPrint:Say  (nRow1+0325,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10 )

oPrint:Say  (nRow1+0425,0100,"Recebi(emos) o bloqueto/título",oFont10 )
oPrint:Say  (nRow1+0475,0100,"com as características acima.",oFont10 )
oPrint:Say  (nRow1+0375,1060,"Data",oFont8 )
oPrint:Say  (nRow1+0375,1410,"Assinatura",oFont8 )
oPrint:Say  (nRow1+0475,1060,"Data",oFont8 )
oPrint:Say  (nRow1+0475,1410,"Entregador",oFont8 )

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0190,1910,"(  )Mudou-se"                                	,oFont8 )
oPrint:Say  (nRow1+0230,1910,"(  )Ausente"                                  ,oFont8 )
oPrint:Say  (nRow1+0270,1910,"(  )Não existe nº indicado"                  	,oFont8 )
oPrint:Say  (nRow1+0310,1910,"(  )Recusado"                                	,oFont8 )
oPrint:Say  (nRow1+0350,1910,"(  )Não procurado"                            ,oFont8 )
oPrint:Say  (nRow1+0390,1910,"(  )Endereço insuficiente"                  	,oFont8 )
oPrint:Say  (nRow1+0430,1910,"(  )Desconhecido"                            	,oFont8 )
oPrint:Say  (nRow1+0470,1910,"(  )Falecido"                                 ,oFont8 )
oPrint:Say  (nRow1+0510,1910,"(  )Outros(anotar no verso)"                  ,oFont8 )

// Aceite do Cliente

nRow2 := nRow1 + 570

For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0030, nI, nRow2+0030, nI+30)
Next nI        

nRow2 += -10

oPrint:Line (nRow2+0150, 100,nRow2+0150,2300)
oPrint:Line (nRow2+0080,1060,nRow2+0150,1060)
oPrint:Line (nRow2+0080,1250,nRow2+0150,1250)

oPrint:SayBitmap(nRow2+0060,100,cBmp,75,65)
oPrint:Say  (nRow2+0100,180 ,"BANCO DO BRASIL" ,oFont14 )     // [2]Nome do Banco

nRow2 += 20
oPrint:Say  (nRow2+0100,1072,aDadosBanco[1]+"-9",oFont18 )         // [1]Numero do Banco
oPrint:Say  (nRow2+0100,1750,"Cobrança Integrada BB" ,oFont14 )    // Legenda do Cabecalho

oPrint:Line (nRow2+0250,100,nRow2+0250,2300 )
oPrint:Line (nRow2+0350,100,nRow2+0350,2300 )
oPrint:Line (nRow2+0450,100,nRow2+0450,2300 )

oPrint:Line (nRow2+0250, 620,nRow2+0450, 620)
oPrint:Line (nRow2+0250,1060,nRow2+0350,1060)
oPrint:Line (nRow2+0150,1500,nRow2+0450,1500)
oPrint:Line (nRow2+0150,1900,nRow2+0350,1900)
                    
oPrint:Line (nRow2+0150,100,nRow2+0150,2300 )
oPrint:Say  (nRow2+0175,100 ,"Beneficiário: "+alltrim(aDadosEmp[1])+" "+substr(aDadosEmp[6],6,20),oFont10 )
oPrint:Say  (nRow2+0220,100 ,"Endereço: "+alltrim(aDadosEmp[2])+" "+aDadosEmp[3],oFont10 )

oPrint:Say  (nRow2+0175,1510,"Vencimento",oFont8n )
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1510 + Int((380-(len(cString)*22))/2)
oPrint:Say  (nRow2+0220,nCol,cString,oFont11c )

oPrint:Say  (nRow2+0175,1910,"Valor do Documento",oFont8n )
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0220,nCol,cString,oFont11c )

oPrint:Say  (nRow2+0285,100,"(-)Desconto"                                  ,oFont8n )
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 250+(374-(len(cString)*22))
oPrint:Say  (nRow2+0285,nCol,cString ,oFont11c )

oPrint:Say  (nRow2+0285, 630,"(-)Outras Deduções"                          ,oFont8n )
oPrint:Say  (nRow2+0285,1070,"(+)Juros / Multa"                             ,oFont8n )
oPrint:Say  (nRow2+0285,1510,"(+)Outros Acréscimos"                        ,oFont8n )
oPrint:Say  (nRow2+0285,1910,"(=)Valor Cobrado"                            ,oFont8n )

oPrint:Say  (nRow2+0385,100 ,"Data de Emissão"                             ,oFont8n )
cString  := StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4)
nCol 	 := 100 + Int((430-(len(cString)*22))/2)
oPrint:Say  (nRow2+0425,nCol, cString , oFont10 )

oPrint:Say  (nRow2+0385, 630,"Agência / Código Beneficiário",oFont8n )
cString  := Alltrim(substr(aDadosBanco[3],1,4)+"-"+aDadosBanco[8]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol 	 := 630+(374-(len(cString)*22))
oPrint:Say  (nRow2+0425,nCol,cString ,oFont10 )

oPrint:Say  (nRow2+0385,1510,"Nosso Número"                                ,oFont8n )
If Len(AllTrim(aDadosTit[6])) < 13
   cString  := Transform(aDadosTit[6],"@R 99999999999-A")
Else
   cString  := Transform(aDadosTit[6],"@R 99999999999999999")
Endif
nCol 	 := 2300 - (len(cString)*26)
oPrint:Say  (nRow2+0425,nCol,cString,oFont10 )

oPrint:Say  (nRow2+0525,100,"Dados do Pagador" ,oFont10 )

oPrint:Line (nRow2+0640,100,nRow2+0640,2300 )
oPrint:Line (nRow2+0740,100,nRow2+0740,2300 )
oPrint:Line (nRow2+0840,100,nRow2+0840,2300 )

oPrint:Line (nRow2+0540,1900,nRow2+0640,1900 )
oPrint:Line (nRow2+0640,1700,nRow2+0840,1700)
oPrint:Line (nRow2+0740,1900,nRow2+0840,1900 )

oPrint:Say  (nRow2+0565,100 ,"Nome do Pagador"  ,oFont8n )
oPrint:Say  (nRow2+0610,145 ,aDatSacado[1]     ,oFont10 )

oPrint:Say  (nRow2+0565,1910,"Número.Documento"                             ,oFont8n )
oPrint:Say  (nRow2+0610,1910,aDadosTit[7]+aDadosTit[1]                      ,oFont10 ) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0675,100 ,"Endereço"                                     ,oFont8n )
oPrint:Say  (nRow2+0720,145 ,aDatSacado[3]                                  ,oFont10 )

oPrint:Say  (nRow2+0675,1710,"Bairro / Distrito"                            ,oFont8n )
oPrint:Say  (nRow2+0720,1750,aDatSacado[9]                                  ,oFont10 )

oPrint:Say  (nRow2+0775,100 ,"Município"                                    ,oFont8n )
oPrint:Say  (nRow2+0820,145 ,aDatSacado[4]                                  ,oFont10 )

oPrint:Say  (nRow2+0775,1710,"UF"                                           ,oFont8n )
oPrint:Say  (nRow2+0820,1750,aDatSacado[5]                                  ,oFont10 )

oPrint:Say  (nRow2+0775,1910,"CEP"                                          ,oFont8n )
oPrint:Say  (nRow2+0820,1950,Transform(aDatSacado[6],"@R 99999-999")        ,oFont10 )

oPrint:Say  (nRow2+0895,100 ,"Mensagem"                                     ,oFont8n )

nRow2 -=200

oPrint:Line (nRow2+1270,100,nRow2+1270,2300 )

oPrint:Say  (nRow2+1305,1480,"Autenticação Mecânica"                        ,oFont8n )
oPrint:Say  (nRow2+1305,1810,"Recibo do Pagador" ,oFont10 )

oPrint:Line (nRow2+1290,1280,nRow2+1290,1380 )
oPrint:Line (nRow2+1290,2200,nRow2+1290,2300 )
oPrint:Line (nRow2+1290,1280,nRow2+1350,1280 )
oPrint:Line (nRow2+1290,2300,nRow2+1350,2300 )

vMens    := Array(4)
vMens[1] := "Este recibo somente terá validade com a autenticação mecânica ou acompanhado do"
vMens[2] := "recibo de pagamento emitido pelo Banco."
vMens[3] := "Recebimento através do cheque n.                                             do banco"
vMens[4] := "Esta quitação só terá validade após o pagamento do cheque pelo banco sacado."

oPrint:Say  (nRow2+1300,100 , vMens[1]                                     ,oFont8n )
oPrint:Say  (nRow2+1330,100 , vMens[2]                                     ,oFont8n )
oPrint:Say  (nRow2+1360,100 , vMens[3]                                     ,oFont8n )
oPrint:Say  (nRow2+1390,100 , vMens[4]                                     ,oFont8n )

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := nRow2 + 325 //1025 - alterei para 525

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow2 + 1085

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0030, nI, nRow3+0030, nI+30)
Next nI

oPrint:Line (nRow3+0150,100,nRow3+0150,2300)
oPrint:Line (nRow3+0080,670,nRow3+0150, 670)
oPrint:Line (nRow3+0080,860,nRow3+0150, 860)

oPrint:SayBitmap(nRow3+0060,100,cBmp,75,65)
oPrint:Say  (nRow3+0100,180,"BANCO DO BRASIL" ,oFont14 )  // [2]Nome do Banco

oPrint:Say  (nRow3+0120,682,aDadosBanco[1]+"-9",oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow3+0105,890,aCB_RN_NN[2],oFont14 )          // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)

oPrint:Say  (nRow3+0175,100 ,"Local de Pagamento",oFont8n )
oPrint:Say  (nRow3+0215,100 ,"Pagável em qualquer banco até o vencimento. Após, atualize o boleto no site bb.com.br",oFont9 )
           
oPrint:Say  (nRow3+0175,1810,"Vencimento",oFont8n )
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0215,nCol,cString,oFont11c )

oPrint:Say  (nRow3+0275,100 ,"Beneficiário: "+alltrim(aDadosEmp[1])+" "+aDadosEmp[6],oFont10 )
oPrint:Say  (nRow3+0315,100 ,"Endereço: "+alltrim(aDadosEmp[2])+" "+aDadosEmp[3] ,oFont10 ) //Nome + CNPJ

oPrint:Say  (nRow3+0275,1810,"Agência / Código Beneficiário",oFont8n )
cString  := Alltrim(substr(aDadosBanco[3],1,4)+"-"+aDadosBanco[8]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0315,nCol,cString ,oFont11c )

oPrint:Say  (nRow3+0375,100 ,"Data do Documento"                              ,oFont8n )
oPrint:Say  (nRow3+0405,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10 )

oPrint:Say  (nRow3+0375,505 ,"Número.Documento"                             ,oFont8n )
oPrint:Say  (nRow3+0405,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10 ) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0375,1005,"Espécie Documento"                            ,oFont8n )
oPrint:Say  (nRow3+0405,1050,aDadosTit[8]                                   ,oFont10 ) //Tipo do Titulo

oPrint:Say  (nRow3+0375,1305,"Aceite"                                       ,oFont8n )
oPrint:Say  (nRow3+0405,1400,"N"                                            ,oFont10 )

oPrint:Say  (nRow3+0375,1485,"Data do Processamento"                        ,oFont8n )
oPrint:Say  (nRow3+0405,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10 ) // Data impressao

oPrint:Say  (nRow3+0375,1810,"Nosso Número"                                 ,oFont8n )
If Len(AllTrim(aDadosTit[6])) < 13
   cString  := Transform(aDadosTit[6],"@R 99999999999-A")
Else
   cString  := Transform(aDadosTit[6],"@R 99999999999999999")
Endif
nCol 	 := 1880+(374-(len(cString)*22))
oPrint:Say  (nRow3+0405,nCol,cString,oFont11c )

oPrint:Say  (nRow3+0445,100 ,"Uso do Banco"                                 ,oFont8n )
oPrint:Say  (nRow3+0475,150 ,"           "                                  ,oFont10 )

oPrint:Say  (nRow3+0445,505 ,"Carteira"                                     ,oFont8n )
oPrint:Say  (nRow3+0475,555 ,SUBSTR(aDadosBanco[6],2,2)+"/019"                          ,oFont10 )

oPrint:Say  (nRow3+0445,755 ,"Moeda"                                        ,oFont8n )
oPrint:Say  (nRow3+0475,805 ,"R$"                                           ,oFont10 )

oPrint:Say  (nRow3+0445,1005,"Quantidade"                                   ,oFont8n )
oPrint:Say  (nRow3+0445,1485,"Valor"                                        ,oFont8n )

oPrint:Say  (nRow3+0445,1810,"Valor do Documento"                          	,oFont8n )
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0475,nCol,cString,oFont11c )

oPrint:Say  (nRow3+0515,100 ,"Instruções de responsabilidade do cedente",oFont8n )
oPrint:Say  (nRow3+0555,100 ,aBolText[5]  ,oFont10 )
oPrint:Say  (nRow3+0595,100 ,aBolText[6]  ,oFont10 )
oPrint:Say  (nRow3+0635,100 ,aBolText[1]  ,oFont10 )
oPrint:Say  (nRow3+0695,100 ,aBolText[2]  ,oFont10 )
oPrint:Say  (nRow3+0735,100 ,aBolText[3]  ,oFont10 )
oPrint:Say  (nRow3+0795,100 ,aBolText[4]  ,oFont10 )

oPrint:Say  (nRow3+0515,1810,"(-)Desconto / Abatimento"                    ,oFont8n )
cString :=  ""
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0545,nCol,cString ,oFont11c )

oPrint:Say  (nRow3+0585,1810,"(-)Outras Deduções"                          ,oFont8n )
oPrint:Say  (nRow3+0655,1810,"(+)Mora / Multa"                             ,oFont8n )
oPrint:Say  (nRow3+0725,1810,"(+)Outros Acréscimos"                        ,oFont8n )
oPrint:Say  (nRow3+0795,1810,"(=)Valor Cobrado"                            ,oFont8n )

oPrint:Say  (nRow3+0865,100 ,"Pagador"                                      ,oFont8n )
oPrint:Say  (nRow3+0895,200 ,alltrim(aDatSacado[1])+space(10)+" CNPJ/CPF - "+alltrim(aDatSacado[7]),oFont9 )

oPrint:Say  (nRow3+0865,1810,"Ficha de Compensação"                        ,oFont11 )

oPrint:Say  (nRow3+0948,200 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont10 )
oPrint:Say  (nRow3+1001,200 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10 ) // CEP+Cidade+Estado

oPrint:Say  (nRow3+1001,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10 )

oPrint:Say  (nRow3+1050,1700,"Autenticação Mecânica"                       ,oFont8n )

oPrint:Line (nRow3+0150,1800,nRow3+0840,1800 )
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1020,100 ,nRow3+1020,2300 )

oPrint:FWMSBAR("INT25" , 63 , 1, aCB_RN_NN[1],oPrint,.F.,,.T./*lHorz*/,0.025/*nWidth*/,1.7/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL,.F.,100,100,.F.)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a página

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetDados  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera SE1                        					          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,cDacCC,cNumBco,nValor,cCart,cMoeda)
Local cNosso      := SE1->E1_NUMBCO
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
Local cNumTmp     := ""
Local lConv6Dig   := (Len(AllTrim(SEE->EE_CODEMP)) == 6)   // Convênio 6 dígitos

cAgencia := Left(Alltrim(cAgencia),4)

If Empty(cNosso)   // Se ainda não foi calculado
	cNumTmp := NossoNum()
	
	If lConv6Dig   // Convênio 6 dígitos 
		cNumTmp := Str(Val(cNumTmp),5) 
		cNosso := PADR(StrTran(StrTran(StrTran(SEE->EE_CODEMP,"/",""),"-",""),".",""),6) + strzero(Val(cNumTmp),5)
		cNosso += u_CALC_5p( cNosso ,.T.)
	Else
		cNumTmp := Str(Val(cNumTmp),10)
		cNosso := PADR(StrTran(StrTran(StrTran(SEE->EE_CODEMP,"/",""),"-",""),".",""),7) + strzero(Val(cNumTmp),10) //strzero(Val(cNumTmp),10
	Endif
Endif

If lConv6Dig   // Convênio 6 dígitos
	cCampoL := PADR(cNosso,11) + cAgencia + StrZero(Val(Left(cConta,5)),8)  + "17"
Else
	//Campo Livre
	cCampoL := StrZero(0,6)+SubStr(cNosso,1,17) + "17"
Endif

// Campo livre do codigo de barra                   // verificar a conta
If nValor <= 0
	nValor := SE1->E1_SALDO-(nVlrAbat+SE1->E1_DECRESC)+SE1->E1_ACRESC
Endif

cFatorValor := u_Fator(SE1->E1_VENCTO) + StrZero(nValor * 100,10)

cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
cDigBarra := u_CALC_5p( cLivre )
cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,39)

// composicao da linha digitavel
cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
cDig1    := u_DIGIT001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := u_DIGIT001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := u_DIGIT001( cParte3 )
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
SE1->E1_XBANCO  := "001"
SE1->E1_NUMBCO  := cNosso
SE1->E1_PORCJUR := GETMV("MV_XJURBOL")
MsUnlock()

Return aRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_5p   ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito do nosso numero do                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CALC_5p(cVariavel,lNosso)
	Local nDig
	Local cBase   := cVariavel
	Local nBase   := 2
	Local nSumDig := 0
	Local nAux    := 0
	Local cDvcb   := ""
	
	For nDig:=Len(cBase) To 1 Step -1
		nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
		nSumDig += nAux
		nBase   += If( nBase == 9 , -7, 1)
	Next
	
	nAux  := Mod(nSumDig * 10,11)
	cDvcb := (Str(nAux,1))
	
	If nAux == 0
		If lNosso
			cDvcb := "0"
		Else
			cDvcb := "1"
		Endif
	ElseIf nAux == 10
		cDvcb := "1"
	Endif
	
Return cDvcb

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FATOR		ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do FATOR  de vencimento para linha digitavel.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User function Fator(dVencto)
	Local cData  := DTOS(dVencto)
	Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return cFator

*/
user Function Fator(dVencto)
   //Local cData  := DTOS(dVencto)
   //Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
   Local cFator := STRZERO(dVencto - Iif(dVencto >= Ctod('22/02/25'),CtoD('29/05/22'),CtoD("07/10/97")),4)
Return(cFator)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DIGIT001  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo da linha digitavel do Unibanco                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DIGIT001(cVariavel)
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
	cString := StrTran(cString,"¨","")
	
	nPos1 := At(" ",cString)
	If nPos1 > 0
		nPos2 := At(" ",SubStr(cString,nPos1+1,Len(cString))) + nPos1
		If nPos2 > 0
			nPos3 := At(" ",SubStr(cString,nPos2+1,Len(cString))) + nPos2
		Endif
	Endif
	
Return Trim(If( nPos3 > 0 , SubStr(cString,1,nPos3), cString))
