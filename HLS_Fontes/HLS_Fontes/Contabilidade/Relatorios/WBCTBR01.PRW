#INCLUDE "PROTHEUS.CH"
/*/{protheus.doc}WBCTBR01
Relatorio do plano de contas
@author Claudio Ferreira
@since 17/03/2009
/*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WBCTBR01 ³ Autor ³ Claudio Ferreira      ³ Data ³ 17/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Plano de Contas x Conta Referencial           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function WBCTBR01()

	local wnrel
	local cString :="CT1"
	
	local aOrd	  := {}
	local cDesc1  := OemToAnsi("Este programa ir  imprimir o Plano de Contas.")
	local cDesc2  := OemToAnsi("Ser  impresso de acordo com os parƒmetros solicitados pelo")
	local cDesc3  := OemToAnsi("usu rio.")
	local Tamanho := "G"
	
	private areturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
	private nomeprog := "WBCTBR01"
	private aLinha   := { }
	private nLastKey := 0
	private cPerg    := "RCTB01"
	private titulo   := OemToAnsi("Listagem do Plano de Contas")
	private cabec1   := OemToAnsi("CONTA                          D E N O M I N A C A O                      CLASSE      TIPO CTA.  CTA REF.")
	private cabec2   := " "
	private cCancel  := OemToAnsi("***** CANCELADO PELO OPERADOR *****")
	private aDados   := {}

	li       := 80
	m_pag    := 1
	
	aAdd(aDados,{"CONTA;DENOMINACAO;CLASSE;CTA REF.;DESCRIÇÃO;DT.VIG.INIC.;DT.VIG.FIM"+CHR(13)+CHR(10)})
	
	
	ValidPerg()
	pergunte(cPerg,.f.)
	
	wnrel := "WBCTBR01"
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
	
	If nLastKey == 27
		Set Filter To
		return
	Endif
	
	SetDefault(areturn,cString)
	
	If nLastKey == 27
		Set Filter To
		return
	Endif
	
	RptStatus({|lEnd| HCTB007Imp(@lEnd,wnRel,cString)})

return

Static Function HCTB007Imp(lEnd,WnRel,cString)

	local tamanho    := "M"
	local limite     := 132
	local cClasse    := nil
	local cMascara   := nil
	local cSeparador := ""
	Local __cPars    := Iif(areturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))
	
	cMascara  := GetMv("MV_MASCARA")	
	cEntidade := if(empty(mv_par02),"10",mv_par02)
	
	dbSelectArea("CT1")
	dbGoTop()
	dbSetOrder(1)
	
	SetRegua(RecCount())   						// Total de elementos da regua
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	dbSeek(xFilial("CT1"))
	&& cCondicao:=	" !Eof() " -- Retirado por Dellano em 13/04/10
	
	m_pag := 1
	
	While CT1->(!Eof()) .and. CT1->CT1_FILIAL == xFilial("CT1") && &cCondicao
		If lEnd
			@Prow()+1,001 PSAY cCancel
			Exit
		EndIF
		
		IncRegua()
		
		IF li > 50
			li := 0
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,__cPars)
			/*
			If len(Alltrim(CT1->CT1_CONTA)) < 9
				li -= 2
			Else
				li--
			EndIF
			*/
		EndIF
		
		cCodigo:=	Alltrim(CT1_CONTA)
		cDesc := &('CT1->CT1_DESC01')
		
		/*
		If len(Alltrim(CT1->CT1_CONTA)) < 9
			li += 2
		Else
			li++
		EndIF
		*/
		
		li += 1
		
		//    0           1        2          3        4         5         6         7         8         9        10        11        12
		//0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.12
		//CONTA                          D E N O M I N A C A O                      CLASSE      TIPO CTA.  CTA REF.
		EntidadeCTB(CT1->CT1_CONTA,li,000,030,.F.,cMascara,cSeparador)

		@li, 031 PSAY cDesc
		@li, 074 PSAY IF(CT1->CT1_CLASSE == "1", "Sintética", "Analitica")
		@li, 086 PSAY IF(CT1->CT1_NORMAL == "1", "Debito", "Credito")
		cCtaRef := Posicione('CVD',1,xFilial('CVD')+CT1->CT1_CONTA+cEntidade,"CVD_CTAREF")
		cCodPla := Posicione('CVD',1,xFilial('CVD')+CT1->CT1_CONTA+cEntidade,"CVD_CODPLA")
		dCtaRef := Posicione('CVN',2,xFilial('CVN')+cCodPla+cCtaRef,"CVN_DSCCTA")
		@li, 097 PSAY Substr(cCtaRef,1,13)+' '+Substr(dCtaRef,1,100)
		
		cConta := allTrim(MascaraCTB(CT1->CT1_CONTA,cMascara,030,cSeparador,"CT1"))
		
		aAdd(aDados,{cConta+";"+allTrim(cDesc)+";"+;
		             IF(CT1->CT1_CLASSE == "1", "Sintética", "Analitica")+";"+;
		             allTrim(cCtaRef)+";"+allTrim(dCtaRef)+";"+;
		             strTran(dtoc(CVN->CVN_DTVIGI),"  /  /  ","")+";"+;
		             strTran(dtoc(CVN->CVN_DTVIGF),"  /  /  ","")+";"+;
		             CHR(13)+CHR(10)})

		dbSkip()
	EndDo

	dbSelectarea("CT1")
	dbSetOrder(1)
	
	Set Filter To
	If areturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
	
	grvExcel()

return

Static Function ValidPerg()

	_sAlias	:=	Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg 	:=	PADR(cPerg,Len(SX1->X1_GRUPO))
	//                                                                                     -SA1-
	putSx1(cPerg,"01","Salvar na pasta",".",".","mv_ch1","C",35,0,0,"G","u_CtbgDir()","mv_par01","","","","","","","","","","","","","","")
	putSx1(cPerg,"02","Entidade?      ",".",".","mv_ch2","C",02,0,0,"G","","GP","","","mv_par02","","","","","","","","","","","","","","","","")
	
	dbSelectArea(_sAlias)

return

static function grvExcel()

	local cArquivo  := ""
	local cCaminho  := "\"
	local cDestino  := ""
	local nAux      := 0

	mv_par01 := If(Empty(AllTrim(mv_par01)),"C:",AllTrim(mv_par01))
	cArquivo := cCaminho+nomeprog+".csv"
	cDestino := mv_par01+nomeprog+".csv"
	cDestino := StrTran(cDestino,"\\"+nomeprog,"\"+nomeprog)

	lFCreate := FCreate(cArquivo)
	
	If lFCreate == -1
		Aviso(FunDesc(),"O arquivo "+cArquivo+" não pode ser criado.",{"OK"})
		return
	EndIf

	for nAux := 1 to len(aDados)
		FWrite(lFCreate,aDados[nAux][1])
	next
	
	FClose(lFCreate)
	_CopyFile(cArquivo,cDestino)
	
	Aviso(FunDesc(),"A planilha foi salva em: " + cDestino,{"OK"})

return

user function CtbgDir()

	Local lRet := .T.

	mv_par01 := cGetFile("Planilha excel (*.csv) |*.csv|","Salvar arquivo de em:",0,"",.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_NETWORKDRIVE)

Return lRet
