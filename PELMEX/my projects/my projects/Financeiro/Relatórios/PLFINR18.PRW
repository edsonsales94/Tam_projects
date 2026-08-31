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


User Function PLFINR18()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR18",10)

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
	oReport := TReport():New(cNome,"Relat๓rio Vendas Matriz",cNome,{|oReport| ReportPrint(oReport)},"Vendas por Cliente")
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
	TRCell():New(oSection1,"C5_CLIENTE"		   ,"TRBNCM","Cod.Cliente","@!",8) 
	TRCell():New(oSection1,"C5_LOJACLI"		   ,"TRBNCM","Cod.Cliente","@!",4)
	TRCell():New(oSection1,"A1_NOME"           ,"TRBNCM","Cliente"	,"@!",200)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Tํtulos", {"SC6"}, NIL, .F., .T.)
	TRCell():New(oSection2,"C6_NOTA"   	,"TRBNCM","Nota"		,"@!",12)
	TRCell():New(oSection2,"C6_SERIE"  	,"TRBNCM","S้rie"   	,"@!",10)
	TRCell():New(oSection2,"E1_TIPO"	,"TRBNCM","Tipo"    	,"@!",5)	
	TRCell():New(oSection2,"E1_PARCELA"	,"TRBNCM","Parcela"		,"@!",15)	
	TRCell():New(oSection2,"E1_VALOR"	,"TRBNCM","Valor"		,"@E 9,999,999,999.99",)	
	TRCell():New(oSection2,"E1_EMISSAO" ,"TRBNCM","Emissใo"	    ,,20)
	TRCell():New(oSection2,"E1_VENCTO"	,"TRBNCM","Vencimento"	,,20)	
	TRCell():New(oSection2,"SITUACAO"	,"TRBNCM","Situa็ใo"	,"@!",40)
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("A1_NOME"),"Total por Cliente") 
	TRFunction():New(oSection2:Cell("E1_VALOR"),"Total por Cliente: ","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("E1_VALOR"),"TOTAL GERAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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
	cQuery := "	SELECT C6_NOTA,C6_SERIE,E1_TIPO,E1_PARCELA,E1_VALOR, "
	cQuery += " 	   CASE WHEN E1_SITUACA = 0 THEN 'CARTEIRA' "
	cQuery += "             WHEN E1_SITUACA = 1 THEN 'COB SIMPLES' "
	cQuery += "             WHEN E1_SITUACA = 2 THEN 'DESCONTADA' "
	cQuery += "        END SITUACAO,"
	cQuery += "        E1_EMISSAO,E1_VENCTO,C5_CLIENTE,C5_LOJACLI,A1_NOME "
	cQuery += "	FROM "+RETSQLNAME("SC5")+" SC5 "                                                                                   
	cQuery += "	INNER JOIN "+RETSQLNAME("SC6")+" SC6 ON SC6.D_E_L_E_T_='' AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM "
	cQuery += "	INNER JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA "
	cQuery += "	INNER JOIN "+RETSQLNAME("SE1")+" SE1 ON SE1.D_E_L_E_T_='' AND SC6.C6_FILIAL = SE1.E1_FILORIG AND SC6.C6_NOTA = SE1.E1_NUM AND SC6.C6_SERIE = SE1.E1_PREFIXO "
	cQuery += "	WHERE SC5.D_E_L_E_T_ =' ' "    
	cQuery += "	AND C5_XFILRES = '' "
	cQuery += "	AND C5_FILIAL = '01' "
	cQuery += "	AND C5_TIPOCLI != 'F' "
	cQuery += "	AND C6_TES NOT IN ('893') "                              
	cQuery += " AND E1_EMISSAO BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"'"
	cQuery += "	AND C5_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += "	GROUP BY C5_CLIENTE,C5_LOJACLI,C6_NOTA,C6_SERIE,E1_TIPO,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,A1_NOME,E1_SITUACA "
	cQuery += "	ORDER BY 9,1,2,4 "

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

		cCodCli 	:= TRBNCM->C5_CLIENTE
		cCliente 	:= TRBNCM->A1_NOME
		IncProc("Imprimindo Cliente "+alltrim(TRBNCM->A1_NOME))

		//imprimo a primeira se็ใo				
		oSection1:Cell("C5_CLIENTE"):SetValue(TRBNCM->C5_CLIENTE)       
		oSection1:Cell("C5_LOJACLI"):SetValue(TRBNCM->C5_LOJACLI)				
		oSection1:Cell("A1_NOME"):SetValue(TRBNCM->A1_NOME)				
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While TRBNCM->C5_CLIENTE+TRBNCM->A1_NOME == cCodCli+cCliente
			oReport:IncMeter()		

			IncProc("Imprimindo Tํtulos "+alltrim(TRBNCM->C6_NOTA))
			oSection2:Cell("C6_NOTA"):SetValue(TRBNCM->C6_NOTA)
			oSection2:Cell("C6_SERIE"):SetValue(TRBNCM->C6_SERIE)
			oSection2:Cell("E1_TIPO"):SetValue(TRBNCM->E1_TIPO)			
			oSection2:Cell("E1_PARCELA"):SetValue(TRBNCM->E1_PARCELA)			
			oSection2:Cell("E1_VALOR"):SetValue(TRBNCM->E1_VALOR)			
			oSection2:Cell("E1_EMISSAO"):SetValue(STOD(TRBNCM->E1_EMISSAO))
			oSection2:Cell("E1_VENCTO"):SetValue(STOD(TRBNCM->E1_VENCTO))			
			oSection2:Cell("SITUACAO"):SetValue(TRBNCM->SITUACAO)			

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
	//Aqui utilizo a fun็ใo putSx1, ela cria a pergunta na tabela de perguntas
	//putSx1(cPerg, "01", "NCM DE ?"	  , "", "", "mv_ch1", "C", tamSx3("B1_POSIPI")[1], 0, 0, "G", "", "SYD", "", "", "mv_par01")
	//putSx1(cPerg, "02", "NCM ATE?"	  , "", "", "mv_ch2", "C", tamSx3("B1_POSIPI")[1], 0, 0, "G", "", "SYD", "", "", "mv_par02")
	//PutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	//PutSX1(cPerg,"02",PADR("Filial At้   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	PutSX1(cPerg,"01",PADR("Emissao De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Emissao At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")   
	PutSX1(cPerg,"03",PADR("Cliente De    ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA1","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Cliente At้   ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA1","","","mv_par04") 
return