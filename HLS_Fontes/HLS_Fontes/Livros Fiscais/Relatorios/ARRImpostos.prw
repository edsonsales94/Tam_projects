#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function ARRImpostos()
Local oReport := nil
Local cPerg:= Padr("ARRIMPOSTO",10)

//Incluo/Altero as perguntas na tabela SX1
AjustaSX1(cPerg)
//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
Pergunte(cPerg,.F.)

oReport := RptDef(cPerg)
oReport:PrintDialog()
Return

Static Function RptDef(cNome)
Local oReport := Nil
Local oSection1:= Nil
Local oSection2:= Nil
Local oSection3:= Nil
Local oBreak
Local oFunction

/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
oReport := TReport():New('ARRImpostos',"Relatório Nota Fiscal x Impostos",cNome,{|oReport| ReportPrint(oReport)},"Relatório Nota Fiscal x Impostos - ")
//	oReport:SetPortrait()    //IsLandscape()
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)


oSection3:= TRSection():New(oReport, "Notas Fiscais", {"SFT","SB1","SA1"}, NIL , .F., .T.)

//TRCell():New(oSecCTB  ,"N3_DTBAIXA"  ,"SN3"    ,                   ,                            ,  8)
//TRCell():New(oSection1,"E1_EMISSAO","SE1"    ,STR0061            ,                           ,nTamDte,.F.,,,,,,,.F.)  //"Data de" + "Emissao"
TRCell():New(oSection3,"FT_ENTRADA"  ,"TRBNCM" ,"Data Entrada"     ,PesqPict('SFT','FT_ENTRADA'),Nil)
TRCell():New(oSection3,"FT_EMISSAO"  ,"TRBNCM" ,"Data Emissao"     ,PesqPict('SFT','FT_EMISSAO'),Nil)
TRCell():New(oSection3,"FT_NFISCAL"  ,"TRBNCM" ,"Doc. Fiscal "     ,PesqPict('SFT','FT_NFISCAL'),Nil)
TRCell():New(oSection3,"FT_SERIE  "  ,"TRBNCM" ,"Serie NF    "     ,PesqPict('SFT','FT_SERIE  '),Nil)
TRCell():New(oSection3,"FT_CLIEFOR"  ,"TRBNCM" ,"Cli/Forn.   "     ,PesqPict('SFT','FT_CLIEFOR'),Nil)
TRCell():New(oSection3,"FT_LOJA   "  ,"TRBNCM" ,"Codigo loja "     ,PesqPict('SFT','FT_LOJA   '),Nil)
TRCell():New(oSection3,"CLIFORN"  	 ,"TRBNCM" ,"Nome" 			   ,PesqPict('SA1','A1_NOME'),Nil)
TRCell():New(oSection3,"FT_ESTADO "  ,"TRBNCM" ,"Estado Ref  "     ,PesqPict('SFT','FT_ESTADO '),Nil)
TRCell():New(oSection3,"FT_CFOP   "  ,"TRBNCM" ,"Cod. Fiscal "     ,PesqPict('SFT','FT_CFOP   '),Nil)
TRCell():New(oSection3,"FT_ALIQICM"  ,"TRBNCM" ,"Aliq. ICMS  "     ,PesqPict('SFT','FT_ALIQICM'),Nil)
TRCell():New(oSection3,"FT_VALCONT"  ,"TRBNCM" ,"Vlr Contabil"     ,PesqPict('SFT','FT_VALCONT'),Nil)
TRCell():New(oSection3,"FT_BASEICM"  ,"TRBNCM" ,"Base ICMS   "     ,PesqPict('SFT','FT_BASEICM'),Nil)
TRCell():New(oSection3,"FT_VALICM "  ,"TRBNCM" ,"Valor ICMS  "     ,PesqPict('SFT','FT_VALICM '),Nil)
TRCell():New(oSection3,"FT_ISENICM"  ,"TRBNCM" ,"Vlr Isen ICM"     ,PesqPict('SFT','FT_ISENICM'),Nil)
TRCell():New(oSection3,"FT_OUTRICM"  ,"TRBNCM" ,"Vlr Out ICMS"     ,PesqPict('SFT','FT_OUTRICM'),Nil)
TRCell():New(oSection3,"FT_ALIQIPI"  ,"TRBNCM" ,"Aliq IPI    "     ,PesqPict('SFT','FT_ALIQIPI'),Nil)
TRCell():New(oSection3,"FT_BASEIPI"  ,"TRBNCM" ,"Vlr Base IPI"     ,PesqPict('SFT','FT_BASEIPI'),Nil)
TRCell():New(oSection3,"FT_VALIPI "  ,"TRBNCM" ,"Valor IPI   "     ,PesqPict('SFT','FT_VALIPI '),Nil)
TRCell():New(oSection3,"FT_ISENIPI"  ,"TRBNCM" ,"Vlr Isen IPI"     ,PesqPict('SFT','FT_ISENIPI'),Nil)
TRCell():New(oSection3,"FT_OUTRIPI"  ,"TRBNCM" ,"Vlr Outr IPI"     ,PesqPict('SFT','FT_OUTRIPI'),Nil)
TRCell():New(oSection3,"FT_ALIQSOL"  ,"TRBNCM" ,"Aliq ICMS So"     ,PesqPict('SFT','FT_ALIQSOL'),Nil)
TRCell():New(oSection3,"FT_BASERET"  ,"TRBNCM" ,"Vlr Base Ret"     ,PesqPict('SFT','FT_BASERET'),Nil)
TRCell():New(oSection3,"FT_ICMSRET"  ,"TRBNCM" ,"Vlr ICMS Ret"     ,PesqPict('SFT','FT_ICMSRET'),Nil)
TRCell():New(oSection3,"FT_OBSERV "  ,"TRBNCM" ,"Obs Liv. Fis"     ,PesqPict('SFT','FT_OBSERV '),Nil)
TRCell():New(oSection3,"FT_TIPO   "  ,"TRBNCM" ,"Tipo Lanc   "     ,PesqPict('SFT','FT_TIPO   '),Nil)
TRCell():New(oSection3,"FT_IPIOBS "  ,"TRBNCM" ,"Vlr IPI Obs "     ,PesqPict('SFT','FT_IPIOBS '),Nil)
TRCell():New(oSection3,"FT_OBSICM "  ,"TRBNCM" ,"Vlr ICM Obs "     ,PesqPict('SFT','FT_OBSICM '),Nil)
TRCell():New(oSection3,"FT_OBSSOL "  ,"TRBNCM" ,"Vlr Sol Obs "     ,PesqPict('SFT','FT_OBSSOL '),Nil)
TRCell():New(oSection3,"FT_SOLTRIB"  ,"TRBNCM" ,"ICMS Sol Tri"     ,PesqPict('SFT','FT_SOLTRIB'),Nil)
TRCell():New(oSection3,"FT_DTCANC "  ,"TRBNCM" ,"Data Cancel "     ,PesqPict('SFT','FT_DTCANC '),Nil)
TRCell():New(oSection3,"FT_ESPECIE"  ,"TRBNCM" ,"Especie NF  "     ,PesqPict('SFT','FT_ESPECIE'),Nil)
TRCell():New(oSection3,"FT_PRODUTO"  ,"TRBNCM" ,"Cod. Produto"     ,PesqPict('SFT','FT_PRODUTO'),Nil)
TRCell():New(oSection3,"B1_DESC"  	 ,"TRBNCM" ,"Descrição"        ,PesqPict('SFT','B1_DESC'),Nil)
TRCell():New(oSection3,"FT_QUANT  "  ,"TRBNCM" ,"Quantidade  "     ,PesqPict('SFT','FT_QUANT  '),Nil)
TRCell():New(oSection3,"FT_PRCUNIT"  ,"TRBNCM" ,"Preco Unit. "     ,PesqPict('SFT','FT_PRCUNIT'),Nil)
TRCell():New(oSection3,"FT_TOTAL  "  ,"TRBNCM" ,"Vlr Total   "     ,PesqPict('SFT','FT_TOTAL  '),Nil)
TRCell():New(oSection3,"FT_DESCONT"  ,"TRBNCM" ,"Vlr Desconto"     ,PesqPict('SFT','FT_DESCONT'),Nil)
TRCell():New(oSection3,"FT_TIPOMOV"  ,"TRBNCM" ,"Tipo Mov.   "     ,PesqPict('SFT','FT_TIPOMOV'),Nil)
TRCell():New(oSection3,"FT_ITEM   "  ,"TRBNCM" ,"Codigo Item "     ,PesqPict('SFT','FT_ITEM   '),Nil)
TRCell():New(oSection3,"FT_CLASFIS"  ,"TRBNCM" ,"Sit.Tribut. "     ,PesqPict('SFT','FT_CLASFIS'),Nil)
TRCell():New(oSection3,"FT_POSIPI "  ,"TRBNCM" ,"Cod. NCM    "     ,PesqPict('SFT','FT_POSIPI '),Nil)
TRCell():New(oSection3,"FT_NFORI  "  ,"TRBNCM" ,"NF Original "     ,PesqPict('SFT','FT_NFORI  '),Nil)
TRCell():New(oSection3,"FT_SERORI "  ,"TRBNCM" ,"Serie NF Ori"     ,PesqPict('SFT','FT_SERORI '),Nil)
TRCell():New(oSection3,"FT_ITEMORI"  ,"TRBNCM" ,"Item NF Orig"     ,PesqPict('SFT','FT_ITEMORI'),Nil)
TRCell():New(oSection3,"FT_CSTPIS "  ,"TRBNCM" ,"Sit.Trib.PIS"     ,PesqPict('SFT','FT_CSTPIS '),Nil)
TRCell():New(oSection3,"FT_BASEPIS"  ,"TRBNCM" ,"Base PIS    "     ,PesqPict('SFT','FT_BASEPIS'),Nil)
TRCell():New(oSection3,"FT_ALIQPIS"  ,"TRBNCM" ,"Aliq. PIS   "     ,PesqPict('SFT','FT_ALIQPIS'),Nil)
TRCell():New(oSection3,"FT_VALPIS "  ,"TRBNCM" ,"Valor PIS   "     ,PesqPict('SFT','FT_VALPIS '),Nil)
TRCell():New(oSection3,"FT_CSTCOF "  ,"TRBNCM" ,"Sit.Trib.COF"     ,PesqPict('SFT','FT_CSTCOF '),Nil)
TRCell():New(oSection3,"FT_BASECOF"  ,"TRBNCM" ,"Base COFINS "     ,PesqPict('SFT','FT_BASECOF'),Nil)
TRCell():New(oSection3,"FT_ALIQCOF"  ,"TRBNCM" ,"Aliq. COFINS"     ,PesqPict('SFT','FT_ALIQCOF'),Nil)
TRCell():New(oSection3,"FT_VALCOF "  ,"TRBNCM" ,"Valor COFINS"     ,PesqPict('SFT','FT_VALCOF '),Nil)
TRCell():New(oSection3,"FT_NFELETR"  ,"TRBNCM" ,"NF Eletr.   "     ,PesqPict('SFT','FT_NFELETR'),Nil)
TRCell():New(oSection3,"FT_EMINFE "  ,"TRBNCM" ,"Emissao NF-e"     ,PesqPict('SFT','FT_EMINFE '),Nil)
TRCell():New(oSection3,"FT_HORNFE "  ,"TRBNCM" ,"Hora NF-e   "     ,PesqPict('SFT','FT_HORNFE '),Nil)
TRCell():New(oSection3,"FT_CODNFE "  ,"TRBNCM" ,"Cd.Ver. NF-e"     ,PesqPict('SFT','FT_CODNFE '),Nil)
TRCell():New(oSection3,"FT_CHVNFE "  ,"TRBNCM" ,"Chave NFe   "     ,PesqPict('SFT','FT_CHVNFE '),Nil)
TRCell():New(oSection3,"FT_CONTA "   ,"TRBNCM" ,"Conta Contabil"   ,PesqPict('SFT','FT_CONTA '),Nil)

/*
oBreak1 := TrBreak():New(oSection3,oSection3:Cell("GRUPO"),"Total ")


TrFunction():New( oNF:Cell("FSC_01")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("CFL_01")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("NC_01")		, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("ABRIL") 	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("MAIO")		, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("JUNHO")		, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("JULHO")		, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("AGOSTO")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("SETEMBRO")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("OUTUBRO")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("NOVEMBRO")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("DEZEMBRO")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("JANEIRO2")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("FEVEREIRO2"), Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
TrFunction():New( oNF:Cell("MARCO2")	, Nil	, "SUM"		, oBreak1	, Nil	, "@e 99,999,999.99"	,Nil			,.f.,.f.)
*/

//oReport:SetTotalInLine(.T.)

//Aqui, farei uma quebra  por seção
//oSection3:SetPageBreak(.F.)  // .T.
//oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
Local oSection3 := oReport:Section(1)
Local cQuery    := ""
Local cNcm      := ""
Local lPrim 	:= .T.
Local aImp		:= {}
Local nPos		:= 0

//Monto minha consulta conforme parametros passado
cQuery := "	SELECT * "
cQuery += "	FROM "+RETSQLNAME("SFT")+" SFT "
cQuery += "	LEFT JOIN "+RETSQLNAME("SB1")+" SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=FT_PRODUTO "
cQuery += "	WHERE SFT.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' " //AND SB1.B1_MSBLQL <> '1'  " //AND SB1.B1_COD <= '000099' "
cQuery += " AND FT_NFISCAL >= '"+mv_par01+"' AND FT_NFISCAL <= '"+mv_par02+"'"
cQuery += " AND FT_SERIE   >= '"+mv_par03+"' AND FT_SERIE   <= '"+mv_par04+"'"
cQuery += " AND FT_ENTRADA >= '"+Dtos(mv_par05)+"' AND FT_ENTRADA <= '"+Dtos(mv_par06)+"'"
cQuery += " ORDER BY FT_FILIAL, FT_NFISCAL, FT_SERIE, FT_ITEM "

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TRBNCM") <> 0
	DbSelectArea("TRBNCM")
	DbCloseArea()
ENDIF

//crio o novo alias
TCQUERY cQuery NEW ALIAS "TRBNCM"

dbSelectArea("TRBNCM")
TRBNCM->(dbGoTop())

oReport:SetMeter(TRBNCM->(LastRec()))

//Irei percorrer todos os meus registros
While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection3:Init()
	
	oReport:IncMeter()
	IncProc("Imprimindo Nota "+alltrim(TRBNCM->FT_NFISCAL))
	
	oSection3:Cell("FT_ENTRADA"):SetValue(Substr(TRBNCM->FT_ENTRADA,7,2)+"/"+Substr(TRBNCM->FT_ENTRADA,5,2)+"/"+Substr(TRBNCM->FT_ENTRADA,1,4))
	oSection3:Cell("FT_EMISSAO"):SetValue(Substr(TRBNCM->FT_EMISSAO,7,2)+"/"+Substr(TRBNCM->FT_EMISSAO,5,2)+"/"+Substr(TRBNCM->FT_EMISSAO,1,4)) //TRBNCM->FT_EMISSAO)
	oSection3:Cell("FT_NFISCAL"):SetValue(TRBNCM->FT_NFISCAL)
	oSection3:Cell("FT_SERIE  "):SetValue(TRBNCM->FT_SERIE  )
	oSection3:Cell("FT_CLIEFOR"):SetValue(TRBNCM->FT_CLIEFOR)
	oSection3:Cell("FT_LOJA   "):SetValue(TRBNCM->FT_LOJA   )
	oSection3:Cell("CLIFORN")	:SetValue( Iif(TRBNCM->FT_CFOP < "5000",Alltrim(Posicione("SA2",1,xFilial("SA2")+TRBNCM->FT_CLIEFOR+TRBNCM->FT_LOJA	 ,"A2_NOME")),;
	 					                                                Alltrim(Posicione("SA1",1,xFilial("SA1")+TRBNCM->FT_CLIEFOR+TRBNCM->FT_LOJA  ,"A1_NOME"))  ))                  //TRBNCM->CLIFORN)
	oSection3:Cell("FT_ESTADO "):SetValue(TRBNCM->FT_ESTADO )
	oSection3:Cell("FT_CFOP   "):SetValue(TRBNCM->FT_CFOP   )
	oSection3:Cell("FT_ALIQICM"):SetValue(TRBNCM->FT_ALIQICM)
	oSection3:Cell("FT_VALCONT"):SetValue(TRBNCM->FT_VALCONT)
	oSection3:Cell("FT_BASEICM"):SetValue(TRBNCM->FT_BASEICM)
	oSection3:Cell("FT_VALICM "):SetValue(TRBNCM->FT_VALICM )
	oSection3:Cell("FT_ISENICM"):SetValue(TRBNCM->FT_ISENICM)
	oSection3:Cell("FT_OUTRICM"):SetValue(TRBNCM->FT_OUTRICM)
	oSection3:Cell("FT_ALIQIPI"):SetValue(TRBNCM->FT_ALIQIPI)
	oSection3:Cell("FT_BASEIPI"):SetValue(TRBNCM->FT_BASEIPI)
	oSection3:Cell("FT_VALIPI "):SetValue(TRBNCM->FT_VALIPI )
	oSection3:Cell("FT_ISENIPI"):SetValue(TRBNCM->FT_ISENIPI)
	oSection3:Cell("FT_OUTRIPI"):SetValue(TRBNCM->FT_OUTRIPI)
	oSection3:Cell("FT_ALIQSOL"):SetValue(TRBNCM->FT_ALIQSOL)
	oSection3:Cell("FT_BASERET"):SetValue(TRBNCM->FT_BASERET)
	oSection3:Cell("FT_ICMSRET"):SetValue(TRBNCM->FT_ICMSRET)
	oSection3:Cell("FT_OBSERV "):SetValue(TRBNCM->FT_OBSERV )
	oSection3:Cell("FT_TIPO   "):SetValue(TRBNCM->FT_TIPO   )
	oSection3:Cell("FT_IPIOBS "):SetValue(TRBNCM->FT_IPIOBS )
	oSection3:Cell("FT_OBSICM "):SetValue(TRBNCM->FT_OBSICM )
	oSection3:Cell("FT_OBSSOL "):SetValue(TRBNCM->FT_OBSSOL )
	oSection3:Cell("FT_SOLTRIB"):SetValue(TRBNCM->FT_SOLTRIB)
	oSection3:Cell("FT_DTCANC "):SetValue(Substr(TRBNCM->FT_DTCANC,7,2)+"/"+Substr(TRBNCM->FT_DTCANC,5,2)+"/"+Substr(TRBNCM->FT_DTCANC,1,4)) //TRBNCM->FT_DTCANC )
	oSection3:Cell("FT_ESPECIE"):SetValue(TRBNCM->FT_ESPECIE)
	oSection3:Cell("FT_PRODUTO"):SetValue(TRBNCM->FT_PRODUTO)
	oSection3:Cell("B1_DESC")	:SetValue(TRBNCM->B1_DESC)
	oSection3:Cell("FT_QUANT  "):SetValue(TRBNCM->FT_QUANT  )
	oSection3:Cell("FT_PRCUNIT"):SetValue(TRBNCM->FT_PRCUNIT)
	oSection3:Cell("FT_TOTAL  "):SetValue(TRBNCM->FT_TOTAL  )
	oSection3:Cell("FT_DESCONT"):SetValue(TRBNCM->FT_DESCONT)
	oSection3:Cell("FT_TIPOMOV"):SetValue(TRBNCM->FT_TIPOMOV)
	oSection3:Cell("FT_ITEM   "):SetValue(TRBNCM->FT_ITEM   )
	oSection3:Cell("FT_CLASFIS"):SetValue(TRBNCM->FT_CLASFIS)
	oSection3:Cell("FT_POSIPI "):SetValue(TRBNCM->FT_POSIPI )
	oSection3:Cell("FT_NFORI  "):SetValue(TRBNCM->FT_NFORI  )
	oSection3:Cell("FT_SERORI "):SetValue(TRBNCM->FT_SERORI )
	oSection3:Cell("FT_ITEMORI"):SetValue(TRBNCM->FT_ITEMORI)
	oSection3:Cell("FT_CSTPIS "):SetValue(TRBNCM->FT_CSTPIS )
	oSection3:Cell("FT_BASEPIS"):SetValue(TRBNCM->FT_BASEPIS)
	oSection3:Cell("FT_ALIQPIS"):SetValue(TRBNCM->FT_ALIQPIS)
	oSection3:Cell("FT_VALPIS "):SetValue(TRBNCM->FT_VALPIS )
	oSection3:Cell("FT_CSTCOF "):SetValue(TRBNCM->FT_CSTCOF )
	oSection3:Cell("FT_BASECOF"):SetValue(TRBNCM->FT_BASECOF)
	oSection3:Cell("FT_ALIQCOF"):SetValue(TRBNCM->FT_ALIQCOF)
	oSection3:Cell("FT_VALCOF "):SetValue(TRBNCM->FT_VALCOF )
	oSection3:Cell("FT_NFELETR"):SetValue(TRBNCM->FT_NFELETR)
	oSection3:Cell("FT_EMINFE "):SetValue(Substr(TRBNCM->FT_EMINFE,7,2)+"/"+Substr(TRBNCM->FT_EMINFE,5,2)+"/"+Substr(TRBNCM->FT_EMINFE,1,4))  //TRBNCM->FT_EMINFE )
	oSection3:Cell("FT_HORNFE "):SetValue(TRBNCM->FT_HORNFE )
	oSection3:Cell("FT_CODNFE "):SetValue(TRBNCM->FT_CODNFE )
	oSection3:Cell("FT_CHVNFE "):SetValue(TRBNCM->FT_CHVNFE )
	//oSection3:Cell("FT_CONTA  "):SetValue(TRBNCM->FT_CONTA  )
	oSection3:Printline()
			
	TRBNCM->(dbSkip())
Enddo


//finalizo a segunda seção para que seja reiniciada para o proximo registro
oSection3:Finish()
//imprimo uma linha para separar uma NCM de outra
//	oReport:ThinLine()
//finalizo a primeira seção

Return

static function ajustaSx1(cPerg)
//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
putSx1(cPerg, "01", "Da Nota		 ?"	  , "", "", "mv_ch1", "C", tamSx3("F2_DOC")[1]	, 0, 0, "G", "", "", "", "", "mv_par01")
putSx1(cPerg, "02", "Ate Nota		 ?"	  , "", "", "mv_ch2", "C", tamSx3("F2_DOC")[1]	, 0, 0, "G", "", "", "", "", "mv_par02")

putSx1(cPerg, "03", "Da Serie		 ?"	  , "", "", "mv_ch3", "C", tamSx3("F2_SERIE")[1]	, 0, 0, "G", "", "", "", "", "mv_par03")
putSx1(cPerg, "04", "Ate Serie		 ?"	  , "", "", "mv_ch4", "C", tamSx3("F2_SERIE")[1]	, 0, 0, "G", "", "", "", "", "mv_par04")

putSx1(cPerg, "05", "Da Data Digitacao de:		 ?"	  , "", "", "mv_ch5", "D", tamSx3("FT_ENTRADA")[1]	, 0, 0, "G", "", "", "", "", "mv_par05")
putSx1(cPerg, "06", "Ate Data Digitacao: 	 ?"	  , "", "", "mv_ch6", "D", tamSx3("FT_ENTRADA")[1]	, 0, 0, "G", "", "", "", "", "mv_par06")

//putSx1(cPerg, "03", "Armazém	?"	  , "", "", "mv_ch3", "C", tamSx3("B2_LOCAL")[1], 0, 0, "G", "", "74", "", "", "mv_par03")
return
