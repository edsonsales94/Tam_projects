#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"

// NOME DO PC PA-ALMOX01
// NOME IMPRESSORA COMPARTILHADA ZD220-203
// CONFIGURAÇÃO LPT1 : net use LPT1: \\PA-ALMOX01\ZD220-203 senha /USER:usuario /PERSISTENT:YES


User Function MCETIQ01()
	// Local aArea := FwGetArea()
	Local aRet := {}
	Local aPergs := {}
	Local cProd := ''
	Local cPrinter := ''

	// RpcSetEnv('01','01')

	cProd := space(tamsx3("B1_COD")[1])
	Aadd(aPergs,{1,"Produto: ",cProd,"@!","u_tValProd()",'SB1',".T.",120,.T.})
	aAdd(aPergs,{1,"Qtd etiqueta: " ,Space(4),"","","","",0 ,.F.})
	// aAdd(aPergs,{1,"Ano: " ,space(1),"","","","",0 ,.F.})
	aAdd(aPergs,{1,"Densidade: " ,'12',"","","","",0 ,.F.})
	// aAdd(aPergs,{1,"Impressora: " ,space(10),"","","","",0 ,.F.})
	aAdd(aPergs, {2, "Impressora",cPrinter, {"ZT410","ZM400"},     122, ".T.", .F.})
	// aAdd(aPergs, {2, "Modelo",cModelo,  {"2 QR CODE","1 QR CODE"},     122, ".T.", .F.})

	If !ParamBox(aPergs ,"Etiquetas ...",@aRet,,,,,,,,.F.,.T.)
		Return
	Else
		Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	Endif


	// FwRestArea(aArea)

Return

Static Function xfImpPA()
	// Local aRet    := {}
	Local nX := 0
	// Local nOpc := 0
	// Local cPorta := "LPT1"   //"COM1:9600,e,7,1"
	// Local n1
	Local cDir    := "\etiquetas\" //pasta criada no protheus_data
	Local cFile   :=""
	Local cLabel  := ""
	Local cPrinterPath:= "" //compartilhamento da impressora na rede
	Local cSeq := SB1->B1_SEQ 
	Local cNomePC := ComputerName()
	Local cDirLocal := "C:\TEMP\"
	Local cAno := GETMV('MV_ANOETQ')
	Local cPrinter := ALLTRIM(MV_PAR04)

	// RETORNA O DIA EM ALFANUMERICO 1 ~ C.
	Local nMes := IIF(month(ddatabase)==10,'A',IIF(month(ddatabase)==11,'B',IIF(month(ddatabase)==12,'C',month(ddatabase))))

	// RETORNA O DIA EM ALFANUMERICO 1 ~ X  -- SEM A LETRA K.
	Local nDia :=;
		IIF(day(ddatabase)==10,'A',;
		IIF(day(ddatabase)==11,'B',;
		IIF(day(ddatabase)==12,'C',;
		IIF(day(ddatabase)==13,'D',;
		IIF(day(ddatabase)==14,'E',;
		IIF(day(ddatabase)==15,'F',;
		IIF(day(ddatabase)==16,'G',;
		IIF(day(ddatabase)==17,'H',;
		IIF(day(ddatabase)==18,'I',;
		IIF(day(ddatabase)==19,'J',;
		IIF(day(ddatabase)==20,'L',;
		IIF(day(ddatabase)==21,'M',;
		IIF(day(ddatabase)==22,'N',;
		IIF(day(ddatabase)==23,'O',;
		IIF(day(ddatabase)==24,'P',;
		IIF(day(ddatabase)==25,'Q',;
		IIF(day(ddatabase)==26,'R',;
		IIF(day(ddatabase)==27,'M',;
		IIF(day(ddatabase)==28,'N',;
		IIF(day(ddatabase)==29,'O',;
		IIF(day(ddatabase)==30,'V',;
		IIF(day(ddatabase)==31,'X',day(ddatabase)))))))))))))))))))))))

	// sempre que mudar o Ano precisa ajusta o parametro MV_ANOETQ
	// infomando o ano;letra que representa o ano. Ex : 2025;T
	if SUBSTR(cAno,1,4) != cValToChar(year(dDataBase))
		Alert('O Ano precisa ser configurado no parametro - MV_ANOETQ, contate o time de TI', 'Atenção')
		return
	else
		cAno := UPPER(SUBSTR(cAno,-1,1))
	endif

	if Empty(SB1->B1_XHALB)
		Alert('Codigo do cliente está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
		Return
	endif

	if Empty(SB1->B1_XNATCOD)
		Alert('Codigo do país está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
		Return
	endif

	if Empty(SB1->B1_XIDCLIE)
		Alert('ID do cliente está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
		Return
	endif

	ProcRegua(val(MV_PAR02))
	for nX := 1 to val(MV_PAR02)
		// SEMMPRE QUE ALCANÇAR 9999 REINICIA A SEQUENCIA.
		if cSeq == '9999'
			cSeq := '0000'
		endif

		cSeq := SOMA1(cSeq)

		// BR30BN6108855AMASAC9D0301
		cQR := 	ALLTRIM(SB1->B1_XNATCOD)+;  // CODIGO PAIS
		AllTRim(SB1->B1_XIDCLIE)+;  // ID CLIENTE
		AllTRim(SB1->B1_XHALB)+;	// CODIGO CLIENTE
		'E1L4' +;					// CLIENTE
		cAno+;						// ANO
		UPPER(cValToChar(nMes))+;	// MES
		UPPER(cValToChar(nDia))+;	// DIA
		cSeq						// SEQUENCIAL

		//Incrementa a mensagem na régua
		IncProc("Imprindo etiquetas " + cValToChar(nX) + " de " + cValToChar(MV_PAR02) + "...")

		cLabel:= ""

		if cPrinter =='ZT410'
			// if MV_PAR05 ==
			cLabel+= (" CT~~CD,~CC^~CT~ ")
			cLabel+= (" ^XA ")
			cLabel+= (" ~TA000 ")
			cLabel+= (" ~JSN ")
			cLabel+= (" ^LT47 ")
			cLabel+= (" ^MNW ")
			cLabel+= (" ^MTT ")
			cLabel+= (" ^PON ")
			cLabel+= (" ^PMN ")
			cLabel+= (" ^LH0,0 ")
			cLabel+= (" ^JMA ")
			cLabel+= (" ^PR10,10 ")
			cLabel+= (" ~SD"+alltrim(MV_PAR03)) // desidade de impressão
			cLabel+= (" ^JUS ")
			cLabel+= (" ^LRN ")
			cLabel+= (" ^CI27 ")
			cLabel+= (" ^PA0,1,1,0 ")
			cLabel+= (" ^XZ ")
			cLabel+= (" ^XA ")
			cLabel+= (" ^MMT ")
			cLabel+= (" ^PW591 ")
			cLabel+= (" ^LL177 ")
			cLabel+= (" ^LS-24 ")
			cLabel+= (" ^FT11,152^BQN,2,5 ")
			cLabel+= (" ^FH\^FDMA,"+cQR+"^FS ") // qr code
			cLabel+= (" ^FT377,130^A0N,25,25^FH\^CI28^FD"+cSeq+"^FS^CI27 ")
			cLabel+= (" ^FT436,149^BQN,2,5 ")
			cLabel+= (" ^FH\^FDMA,"+cQR+"^FS ") // qr code
			cLabel+= (" ^FT371,98^A0N,25,25^FH\^CI28^FD"+AllTRim(SB1->B1_XNATCOD+SB1->B1_XIDCLIE)+"^FS^CI27 ")
			cLabel+= (" ^FT150,85^A0N,33,33^FH\^CI28^FDMASA^FS^CI27 ")
			cLabel+= (" ^FT149,130^A0N,25,25^FH\^CI28^FD"+dtos(dDataBase)+"^FS^CI27 ")
			cLabel+= (" ^FT150,45^A0N,42,43^FH\^CI28^FD"+AllTRim(SB1->B1_XHALB)+"^FS^CI27 ")
			cLabel+= (" ^PQ1,0,1,Y ")
			cLabel+= (" ^XZ ")
			// endif
		elseif cPrinter == 'ZM400'
			cLabel+= (" CT~~CD,~CC^~CT~  ")
			cLabel+= (" ^XA  	")
			cLabel+= (" ~TA000  ")
			cLabel+= (" ~JSN  	")
			cLabel+= (" ^LT0  	")
			cLabel+= (" ^MNW  	")
			cLabel+= (" ^MTT  	")
			cLabel+= (" ^PON  	")
			cLabel+= (" ^PMN  	")
			cLabel+= (" ^LH0,0  ")
			cLabel+= (" ^JMA  	")
			cLabel+= (" ^PR10,10 ")
			cLabel+= (" ~SD	"+alltrim(MV_PAR03))
			cLabel+= (" ^JUS  	")
			cLabel+= (" ^LRN  	")
			cLabel+= (" ^CI0  	")
			cLabel+= (" ^XZ  ")
			cLabel+= (" ^XA  ")
			cLabel+= (" ^MMT  ")
			cLabel+= (" ^PW591  ")
			cLabel+= (" ^LL0177  ")
			cLabel+= (" ^LS0  ")
			cLabel+= (" ^FT48,138^BQN,2,4  ")
			cLabel+= (" ^FDMA,"+cQR+"^FS  ")
			cLabel+= (" ^FT495,160^A0N,29,26^FH\^FD"+cSeq+"^FS  ")
			cLabel+= (" ^FT429,160^A0N,29,26^FH\^FD"+AllTRim(SB1->B1_XNATCOD+SB1->B1_XIDCLIE)+"^FS  ")
			cLabel+= (" ^FT444,138^BQN,2,4  ")
			cLabel+= (" ^FDMA,"+cQR+"^FS  ")
			cLabel+= (" ^FT165,108^A0N,29,26^FH\^FDMASA^FS  ")
			cLabel+= (" ^FT162,161^A0N,29,26^FH\^FD"+dtos(dDataBase)+"^FS  ")
			cLabel+= (" ^FT165,64^A0N,37,36^FH\^FD"+AllTRim(SB1->B1_XHALB)+"^FS  ")
			cLabel+= (" ^PQ1,0,1,Y^XZ  ")
		endif

		impriRaw(cLabel,cPrinter,cSeq)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ÿÿ    

		// cPrinterPath:= "\\"+cNomePC+"\ZEBRA"

		// cFile:= "etq_"+strtran('etiqueta_masa'+"-"+cvaltochar(nx),"/","-")+".txt"
		// MemoWrite(cDir+cFile,cLabel )

		// // se não existir o diretorio cria
		// if !file(cDirLocal)
		// 	MakeDir(cDirLocal)
		// endif

		// // se não existir o diretorio cria
		// if !ExistDIr(cDir)
		// 	MakeDir(cDir)
		// endif

		// CpyS2T(cDir+cFile, cDirLocal, .T. )
		// cExec:= 'cmd /c "COPY '+cDirLocal+cFile +' '+ cPrinterPath+'" '
		// nWait:= WaitRun(cExec,1)
		// if nWait == 0
		// PUTMV("MV_SEQETQ",cSeq)
		RECLOCK('SB1',.F.)
		SB1->B1_SEQ := cSeq
		SB1->(MSUNLOCK())

		// fErase(cDirLocal+cFile)
		// fErase(cDir+cFile)
		// endif
	Next
	// Encerra local de impressao
	// MSCBCLOSEPRINTER()

Return


User function tValProd()
	local lret:= .F.
	dbselectarea('SB1')
	dbsetorder(1)

	if MSSEEK(xFilial('SB1')+MV_PAR01)
		lRet := .T.
	Else
		Alert('Produto não localizado !!!')
	EndIf

return lret

// Exemplo de impressão RAW usando FWMSPrinter
Static Function impriRaw(cZPL,cPrinter,cSeq)

	Local oPrinter   := Nil
	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
	Local oPrintSetupParam := Nil
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	// Local oPrinter
	Local cLocal            := "c:\temp"
	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
	Local aDevice           := {}
	Local cSession          := GetPrinterSession()

	// Criar objeto FWMSPrinter em modo RAW
	oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,.F. ,.T., .T. /*LRAW*/)

	// Aqui é só usar SAY, que em RAW escreve direto
	oPrinter:Say(0, 0, cZPL)

	oPrinter:Print()

	PUTMV("MV_SEQETQ",cSeq)
Return
