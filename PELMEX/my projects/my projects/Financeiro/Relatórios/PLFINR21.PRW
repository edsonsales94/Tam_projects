#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR18    บAutor  ณStan Lee Lopes     				บ Data ณ  16/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Vendas Matriz	           								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR21()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR21",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
	Pergunte(cPerg,.F.)	          

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Tํtulos sem registros de saida",cNome,{|oReport| ReportPrint(oReport)},"Tํtulos sem registros de saida")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Monstando a primeira se็ใo
	//Neste exemplo, a primeira se็ใo serแ composta por duas colunas, c๓digo da NCM e sua descri็ใo
	//Iremos disponibilizar para esta se็ใo apenas a tabela SYD, pois quando voc๊ for em personalizar
	//e entrar na primeira se็ใo, voc๊ terแ todos os outros campos disponํveis, com isso, serแ
	//permitido a inser็ใo dos outros campos
	//Neste exemplo, tamb้m, jแ deixarei definido o nome dos campos, mascara e tamanho, mas voc๊
	//terแ toda a liberdade de modificแ-los via relatorio. 




	oSection1:= TRSection():New(oReport, "Cliente", {"SC5"}, , .F., .T.)
	TRCell():New(oSection1,"D2_CLIENTE"		   ,"TRBNCM","Cod.Cliente","@!",8) 
	TRCell():New(oSection1,"A1_NOME"           ,"TRBNCM","Nome","@!",200)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Tํtulos", {"SC6"}, NIL, .F., .T.)
	TRCell():New(oSection2,"D2_FILIAL"  ,"TRBNCM","Filial"		,"@!",12)
	TRCell():New(oSection2,"D2_DOC"   	,"TRBNCM","Nota"		,"@!",12)
	TRCell():New(oSection2,"D2_SERIE"  	,"TRBNCM","S้rie"   	,"@!",7)
	TRCell():New(oSection2,"D2_ITEM"	,"TRBNCM","Item"    	,"@!",5)	
	TRCell():New(oSection2,"D2_COD"		,"TRBNCM","Produto"		,"@!",17)	
	TRCell():New(oSection2,"B1_DESC"	,"TRBNCM","Descri็ใo",,)	
	TRCell():New(oSection2,"D2_QUANT" 	,"TRBNCM","Quantidade","@E 9,999,999,999",20)
	TRCell():New(oSection2,"D2_EMISSAO"	,"TRBNCM","Emissao",,10)	
	//Quebra por Se็ใo

	oBreak := TRBreak():New(oSection2,oSection1:Cell("A1_NOME"),"Total por Cliente") 
	TRFunction():New(oSection2:Cell("D2_QUANT"),"Pendente de entrega: ","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("D2_QUANT"),"Pendente de entrega: ","SUM",,,"@E 9,999,999,999",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//quebra  por se็ใo (.T.) uma se็ใo por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cCodCli   := ""   
	Local cCliente  := "" 
	Local lPrim 	:= .T.	      

	//Monto minha consulta conforme parametros passado

	cQuery := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_EMISSAO,D2_CLIENTE,A1_NOME "
	cQuery += " FROM "+RETSQLNAME("SD2")+" SD2 (NOLOCK) "
	cQuery += " INNER JOIN "+RETSQLNAME("SA1")+" SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" SF4 (NOLOCK) ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SAI (NOLOCK) ON SAI_FILIAL = SD2.D2_FILIAL AND SAI_DOC = SD2.D2_DOC AND SAI_SERIE = SD2.D2_SERIE AND SAI_PRODUTO = SD2.D2_COD "
	cQuery += " LEFT JOIN "+RETSQLNAME("SD1")+" SD1 (NOLOCK) ON SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D2_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE SD2.D_E_L_E_T_ = '' "
	cQuery += " AND D2_FILIAL = '01' "
	cQuery += " AND F4_DUPLIC = 'S' "
	cQuery += " AND SAI_DOC IS NULL "
	cQuery += " AND SD1.D1_DOC IS NULL "
	cQuery += " AND D2_SERIE = '2' "
	cQuery += " AND D2_LOCAL IN ('20','30') "
	cQuery += " AND F4_ESTOQUE = 'S' "
	cQuery += " AND D2_EMISSAO BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "  
	cQuery += " ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_CLIENTE "

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

		//inicializo a primeira se็ใo
		oSection1:Init()

		oReport:IncMeter()

		cCodCli 	:= TRBNCM->D2_CLIENTE
		IncProc("Imprimindo Cliente: "+alltrim(TRBNCM->A1_NOME))


		//imprimo a primeira se็ใo				
		oSection1:Cell("D2_CLIENTE"):SetValue(TRBNCM->D2_CLIENTE)       				
		oSection1:Cell("A1_NOME"):SetValue(TRBNCM->A1_NOME)				
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While TRBNCM->D2_CLIENTE == cCodCli
			oReport:IncMeter()		

			IncProc("Imprimindo Notas: "+alltrim(TRBNCM->D2_DOC))
			oSection2:Cell("D2_FILIAL"):SetValue(TRBNCM->D2_FILIAL)
			oSection2:Cell("D2_DOC"):SetValue(TRBNCM->D2_DOC)
			oSection2:Cell("D2_SERIE"):SetValue(TRBNCM->D2_SERIE)
			oSection2:Cell("D2_ITEM"):SetValue(TRBNCM->D2_ITEM)			
			oSection2:Cell("D2_COD"):SetValue(TRBNCM->D2_COD)			
			oSection2:Cell("B1_DESC"):SetValue(TRBNCM->B1_DESC)			
			oSection2:Cell("D2_QUANT"):SetValue(TRBNCM->D2_QUANT)
			oSection2:Cell("D2_EMISSAO"):SetValue(STOD(TRBNCM->D2_EMISSAO))						

			oSection2:Printline()

			TRBNCM->(dbSkip())
		EndDo		
		//Aqui, farei uma quebra  por se็ใo

		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
		oSection2:Finish()
		//imprimo uma linha para separar os Tํtulos de outro
		oReport:ThinLine()
		//finalizo a primeira se็ใo
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissao De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissao At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")   

return