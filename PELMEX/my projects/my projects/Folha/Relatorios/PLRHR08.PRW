#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR23    บAutor  ณWILSON GUEDES	    				บ Data ณ  23/06/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Produto X Componente								        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLRHR08()
	Local oReport := nil
	Local cPerg:= Padr("PLRHR08",10)

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


	oReport := TReport():New(cNOME,"Analise de Dependentes",cNOME,{|oReport| ReportPrint(oReport)},"Analise de Dependentes")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo




	oSection1:= TRSection():New(oReport, "Funcionario", {"SRA"}, , .F., .T.)

	TRCell():New(oSection1,"RA_FILIAL"	   	   	    ,"cAlias","Filial",,)
	TRCell():New(oSection1,"RA_MAT"	   	   			,"cAlias","Matricula",,16)
	TRCell():New(oSection1,"RA_NOME"	   	   		,"cAlias","Nome",,60)
	TRCell():New(oSection1,"RA_NASC"	   	   	   	,"cAlias","Dt.Nascimento",,14)
	TRCell():New(oSection1,"RA_RG"	   	   			,"cAlias","RG",,17)
	TRCell():New(oSection1,"RA_CIC"	   	   			,"cAlias","CPF",,20)  
	TRCell():New(oSection1,"RJ_DESC"	   	   		,"cAlias","Fun็ใo",,30)
	TRCell():New(oSection1,"RA_SALARIO"	   	   		,"cAlias","Salario",,20)  
	TRCell():New(oSection1,"R8_CID"		   	   		,"cAlias","CID",,20)     

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Dependente", {"SRB"}, NIL, .F., .T.)


	TRCell():New(oSection2,"RB_COD"	   	  		 	,"cAlias","Cod",,)
	TRCell():New(oSection2,"RB_NOME"	   	   	   	,"cAlias","Nome do dependente",,60) 
	TRCell():New(oSection2,"RB_DTNASC"	   	   	   	,"cAlias","Dt.Nascimento ",,13)  	 
	TRCell():New(oSection2,"RB_SEXO"	   	   	   	,"cAlias","Sexo ",,14)  
	TRCell():New(oSection2,"RB_CIC"	   	   			,"cAlias","Cpf",,15)  
	TRCell():New(oSection2,"RB_GRAUPAR"	   	     	,"cAlias","Parentesco",,20)  





	oBreak := TRBreak():New(oSection2,oSection1:Cell("RA_MAT"),"Total")
	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

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




	cQuery += "	SELECT TB.*,CASE WHEN R8_DATAFIM = '' THEN R8_CID ELSE '' END R8_CID " 
	cQuery += "				FROM ( "
	cQuery += "				SELECT ISNULL(MAX(SR8.R_E_C_N_O_),'') MAXIMO,RA_FILIAL,RA_MAT,RA_NOME, "
	cQuery += "							CASE WHEN RA_SEXO = 'M' THEN 'MASCULINO'  ELSE 'FEMININO' END RA_SEXO, "
	cQuery += "							RA_NASC,RA_RG,RA_CIC,RA_CODFUNC,RJ_DESC,RA_SALARIO, "
	cQuery += "							RB_COD,RB_NOME,RB_DTNASC, "
	cQuery += "							CASE WHEN RB_SEXO = 'M' THEN 'MASCULINO'  ELSE CASE WHEN RB_SEXO = 'F' THEN 'FEMININO' END END RB_SEXO, "
	cQuery += "							CASE WHEN RB_GRAUPAR = 'C' THEN 'CONJUDE' ELSE "
	cQuery += "							CASE WHEN RB_GRAUPAR = 'F' THEN 'FILHO'   ELSE " 
	cQuery += "							CASE WHEN RB_GRAUPAR = 'E' THEN 'ENTEADO' ELSE "
	cQuery += "							CASE WHEN RB_GRAUPAR = 'P' THEN 'PAI/MรE' ELSE  CASE WHEN RB_GRAUPAR = 'O' THEN 'AGREGADOR/OUTROS' END END END END END RB_GRAUPAR, "
	cQuery += "							RB_CIC " 
	cQuery += "							FROM "+RETSQLNAME("SRA")+" SRA "
	cQuery += "							INNER JOIN "+RETSQLNAME("SRJ")+" SRJ ON RJ_FUNCAO = RA_CODFUNC AND RA_FILIAL = RJ_FILIAL AND SRJ.D_E_L_E_T_ = '' "
	cQuery += "							LEFT JOIN "+RETSQLNAME("SRB")+" SRB ON RB_MAT = RA_MAT AND RA_FILIAL = RB_FILIAL AND SRB.D_E_L_E_T_ = '' "
	cQuery += "							LEFT JOIN "+RETSQLNAME("SR8")+" SR8 ON R8_MAT = RA_MAT AND R8_FILIAL = RA_FILIAL "
	cQuery += "							WHERE RA_MAT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "							AND RA_FILIAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "							AND RA_SITFOLH NOT IN ('D') "
	cQuery += "							AND RA_PROCES = '00001' "
	cQuery += "							AND SRA.D_E_L_E_T_ = '' "
	cQuery += "							GROUP BY RA_FILIAL,RA_MAT,RA_NOME,RA_SEXO,RA_NASC,RB_DTNASC,RA_RG,RA_CIC,RA_CODFUNC,RJ_DESC,RA_SALARIO,RB_COD,RB_NOME,RB_SEXO,RB_GRAUPAR,RB_CIC "
	cQuery += "							)TB "
	cQuery += "				LEFT JOIN "+RETSQLNAME("SR8")+" SR8 ON SR8.R_E_C_N_O_ = MAXIMO "
	cQuery += "				ORDER BY RA_FILIAL,RA_MAT,RB_COD "





	G



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


		cCodproduto 	:= cAlias->RA_MAT

		IncProc("Imprimindo Funcionario"+alltrim(cAlias->RA_MAT))

		//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

		//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,		
		//imprimo a primeira se็ใo				
		oSection1:Cell("RA_FILIAL"):SetValue(cAlias->RA_FILIAL)
		oSection1:Cell("RA_MAT"):SetValue(cAlias->RA_MAT) 
		oSection1:Cell("RA_NOME"):SetValue(cAlias->RA_NOME) 
		oSection1:Cell("RA_NASC"):SetValue(STOD(cAlias->RA_NASC))
		oSection1:Cell("RA_RG"):SetValue(cAlias->RA_RG) 
		oSection1:Cell("RA_CIC"):SetValue(cAlias->RA_CIC) 
		oSection1:Cell("RJ_DESC"):SetValue(cAlias->RJ_DESC)
		oSection1:Cell("RA_SALARIO"):SetValue(cAlias->RA_SALARIO)
		oSection1:Cell("R8_CID"):SetValue(cAlias->R8_CID)

		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->RA_MAT == cCodproduto
			oReport:IncMeter()		                                

			//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,    



			IncProc("Imprimindo Dependente"+alltrim(cAlias->RB_NOME))
			oSection2:Cell("RB_COD"):SetValue(cAlias->RB_COD)			
			oSection2:Cell("RB_NOME"):SetValue(cAlias->RB_NOME)
			oSection2:Cell("RB_SEXO"):SetValue(cAlias->RB_SEXO)

			oSection2:Cell("RB_DTNASC"):SetValue(STOD(cAlias->RB_DTNASC))
			oSection2:Cell("RB_GRAUPAR"):SetValue(cAlias->RB_GRAUPAR)
			oSection2:Cell("RB_CIC"):SetValue(cAlias->RB_CIC)
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

	u_InPutSX1(cPerg,"01",PADR("Matricula De ? ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Matricula Ate? ",30)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Filial De ? ",20)+"","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Filial Ate? ",30)+"","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")
Return