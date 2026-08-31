#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Vendas									        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLRHR05()
	Local oReport := nil
	Local cPerg:= Padr("PLRHR05",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
	Pergunte(cPerg,.F.)	          

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return


Static Function RptDef(cNOME)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction


	oReport := TReport():New(cNOME,"Gerencial Sintetico",cNOME,{|oReport| ReportPrint(oReport)},"Gerencial Sintetico")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo

	//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

	//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,



	oSection1:= TRSection():New(oReport, "Centro de custo", {"CTT"}, , .F., .T.)
	TRCell():New(oSection1,"RA_CC"	   	   ,"cAlias","Centro de custo",,15)
	TRCell():New(oSection1,"CTT_DESC01"	   ,"cAlias","Descri็ใo",,50)    
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Verbas", {"SRA"}, NIL, .F., .T.)
	TRCell():New(oSection2,"RD_PD"	   	   ,"cAlias","Cod.Verba",,10)
	TRCell():New(oSection2,"RV_DESC"	   	   ,"cAlias","Descri็ใo",,30)  
	TRCell():New(oSection2,"RV_TIPOCOD"	   ,"cAlias","Tipo",,15)
	TRCell():New(oSection2,"RD_HORAS"	   	   ,"cAlias","Horas","@E 9,999,999,999.99",20)
	TRCell():New(oSection2,"RD_VALOR"	  	   ,"cAlias","Valor","@E 9,999,999,999.99",20)

	oBreak := TRBreak():New(oSection2,oSection1:Cell("RA_CC"),"Total") 
	TRFunction():New(oSection2:Cell("RD_PD"),"","COUNT",oBreak,,"@E 9,999,999,999",,.F.,.F.)
	TRFunction():New(oSection2:Cell("RD_HORAS"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("RD_VALOR"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   

	//Fim Quebra por Se็ใo

	//Totalizador final
	//  	TRFunction():New(oSection1:Cell("RD_HORAS"),"Total de Horas","SUM",,,"@E 9,999,999,99",,.F.,.T.) 
	//  	TRFunction():New(oSection1:Cell("RD_VALOR"),"Total Pago","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

	//TRFunction():New(oSection2:Cell("SAI_DOC")	,"Total de Notas","COUNT",,,"@E 9,999,999,999",,.F.,.T.)


	oReport:SetTotalInLine(.F.)

	//quebra  por se็ใo (.T.) uma se็ใo por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)



/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cCodCli   := ""   
	Local cCliente  := ""   
	Local cMascara  := "@E 9,999,999,999,999,999,999"
	Local lPrim 	:= .T.



	cQuery := "			SELECT RA_CC,CTT_DESC01,RV_TIPOCOD,RD_PD,RV_DESC,SUM(TB.RD_HORAS) RD_HORAS, SUM(TB.RD_VALOR) RD_VALOR "
	cQuery += "			FROM (SELECT RA_CC,CTT.CTT_DESC01, " 
	cQuery += "					CASE WHEN RV_TIPOCOD = 1 THEN 'PROVENTO' ELSE " 
	cQuery += "					CASE WHEN RV_TIPOCOD = 2 THEN 'DESCONTO' ELSE "
	cQuery += "					CASE WHEN RV_TIPOCOD = 3 THEN '(BASE) PROVENTO' ELSE " 
	cQuery += "					CASE WHEN RV_TIPOCOD = 4 THEN '(BASE) DESCONTO' ELSE " 
	cQuery += "					'NAO CADASTRADO' END END END END RV_TIPOCOD, " 
	cQuery += "					RD_PD,RV_DESC,RD_HORAS, " 
	cQuery += "					CASE WHEN RV_TIPOCOD = 2 THEN RD_VALOR*-1 ELSE " 
	cQuery += "					CASE WHEN RV_TIPOCOD = 4 THEN RD_VALOR*-1 ELSE " 
	cQuery += "					RD_VALOR END END  RD_VALOR  "
	cQuery += "						FROM "+RETSQLNAME("SRA")+" AS SRA (NOLOCK) "
	cQuery += "						INNER JOIN "+RETSQLNAME("SRJ")+" AS SRJ (NOLOCK) ON RJ_FUNCAO = RA_CODFUNC AND RA_FILIAL = RJ_FILIAL AND SRJ.D_E_L_E_T_ = '' "
	cQuery += "						INNER JOIN "+RETSQLNAME("SX5")+" AS SX5 (NOLOCK) ON X5_CHAVE = RA_GRINRAI AND X5_TABELA = '26' AND X5_FILIAL = '' AND SX5.D_E_L_E_T_ = '' "
	cQuery += "						INNER JOIN "+RETSQLNAME("CTT")+" AS CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
	cQuery += "						INNER JOIN "+RETSQLNAME("SRD")+" AS SRD (NOLOCK) ON RD_MAT = RA_MAT AND RD_FILIAL = RA_FILIAL AND SRD.D_E_L_E_T_ = '' "
	cQuery += "						INNER JOIN "+RETSQLNAME("SRV")+" AS SRV (NOLOCK) ON RV_COD = RD_PD AND SRV.D_E_L_E_T_ ='' "
	cQuery += "						WHERE " 
	cQuery += "						RD_PERIODO = '"+mv_par01+"' "
	cQuery += "						AND RD_ROTEIR = '"+mv_par02+"' "
	cQuery += "						AND RA_FILIAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "						AND RA_CC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += "						AND RA_MAT BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	cQuery += "						AND SRA.D_E_L_E_T_ = '')TB "
	cQuery += "			GROUP BY TB.RA_CC,TB.CTT_DESC01,TB.RV_TIPOCOD,TB.RD_PD,TB.RV_DESC "
	cQuery += "			ORDER BY TB.RA_CC,RD_PD "


	IF Select("cAlias") <> 0
		DbSelectArea("cAlias")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "cAlias"	

	dbSelectArea("cAlias")
	cAlias->(dbGoTop())

	oReport:SetMeter(cAlias->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se็ใo
		oSection1:Init()

		oReport:IncMeter() 




		cCodproduto 	:= cAlias->RA_CC

		IncProc("Imprimindo SETOR"+alltrim(cAlias->CTT_DESC01))

		//imprimo a primeira se็ใo				
		oSection1:Cell("RA_CC"):SetValue(cAlias->RA_CC)
		oSection1:Cell("CTT_DESC01"):SetValue(cAlias->CTT_DESC01) 
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->RA_CC == cCodproduto
			oReport:IncMeter()		                                

			//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,    

			IncProc("Imprimindo Verbas"+alltrim(cAlias->RV_DESC))
			oSection2:Cell("RV_TIPOCOD"):SetValue(cAlias->RV_TIPOCOD)			
			oSection2:Cell("RD_PD"):SetValue(cAlias->RD_PD)
			oSection2:Cell("RV_DESC"):SetValue(cAlias->RV_DESC)
			oSection2:Cell("RD_HORAS"):SetValue(cAlias->RD_HORAS)
			oSection2:Cell("RD_VALOR"):SetValue(cAlias->RD_VALOR)
			oSection2:Printline()
			cAlias->(dbSkip())
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

Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Periodo   ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Roteiro   ",20)+"?","","","mv_ch2","C",3,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Filial De ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Filial At้",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")  
	u_InPutSX1(cPerg,"05",PADR("Centro de custo de   ",20)+"?","","","mv_ch5","C",9,0,0,"G","","CTT","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Centro de custo At้  ",20)+"?","","","mv_ch6","C",9,0,0,"G","","CTT","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Matricula De",20)+"?","","","mv_ch7","C",6,0,0,"G","","SRA","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Matricula At้",20)+"?","","","mv_ch8","C",6,0,0,"G","","SRA","","","mv_par08") 
Return