#include 'parmtype.ch'
#include "rwmake.ch"
#Include 'Protheus.ch'
#Include 'TOPCONN.ch'
#include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±csgi
±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AAFATR18  ºAutor  ³Wladimir Vieira     º Data ³  19/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Certificado de Qualidade AA                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function AAFATR18()
	Local oReport := nil
	//+-----------------------------------------------------+
	//| Ajustar grupo de pergunta                           |
	//+-----------------------------------------------------+

	Private cNome:= Padr("AAFATR18  ",10)    // Nome do Relatório / perguntas
	Private oReport
	Private cPerg		:= "AAFATR18"
	Private cMark   	:= GetMark() 
	Private nLinha		:= 0
	Private cTitAlias	:= GetNextAlias()	
	Private cTabFil		:= GetNextAlias()

	// Criação e parametrização do TReport
	oReport := TReport():New("FATR18","QUALIDADE",, {|oReport| RPTDEF() } ,"Este relatório imprimirá o boleto para o banco escolhido.")
	oReport:lParamPage 	   := .F. // Não imprime pagina de parametros por sugestão
	oReport:lHeaderVisible  := .F. // Desabilita a impressao do Cabeçalho
	oReport:lFooterVisible  := .F. // Desabilita a impressao do Rodapé
	//	AjustaSX1(cPerg)
	//	Pergunte(cNome,.T.)

	oReport := RptDef()
	oReport:PrintDialog()
Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RptDef   ³ Autor ³ Wladimir Vieira       ³ Data ³ 19/02/19 ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao das secoes do relatorio    		  	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AA                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oTotaisForn := Nil
	Local oBreak
	Local oFunction

	cNome := "AAFATR18  "

	buscadados()

	//+-----------------------------------------------------+
	//| Definir cabecalho do relatorio                      |
	//+-----------------------------------------------------+


	//cbitmap :=

	// fontes utilizados
	Private oFont08  := TFont():New("ARIAL",08,08,,.F.,,,,.T.,.F.)
	Private oFont10  := TFont():New("ARIAL",10,10,,.F.,,,,.T.,.F.)
	Private oFont10N := TFont():New("ARIAL",10,10,,.T.,,,,.T.,.F.)
	Private oFont10C := TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
	Private oFont12  := TFont():New("ARIAL",12,12,,.F.,,,,.T.,.F.)
	Private oFont12N := TFont():New("ARIAL",12,12,,.T.,,,,.T.,.F.)
	Private oFont12NC := TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)
	Private oFont14  := TFont():New("ARIAL",14,14,,.F.,,,,.T.,.F.)
	Private oFont14N := TFont():New("ARIAL",14,14,,.T.,,,,.T.,.F.) 


	oReport := TReport():New(cNome,"CERTIFICADO DE QUALIDADE ",cNome,{|oReport| ReportPrint(oReport)},"Teste teste")
	oReport:setlandscape()          //Orientação da impreesão
	

	//+-------------------------------------------------------------+
	//| Definir primeira secao do relatorio = Codigo + Nome + Loja  |
	//+-------------------------------------------------------------+

	//nAltura  := oReport:PageHeight()       // Altura da Pagina
	//nLargura := oReport:PageWidth() - 140 // Largura da Pagina  
	nLinha	  := 0
	nSaltLin := 35

	//oReport:Box(050,050, 3400 ,nLargura )
	//	oReport:Box(050,050, 200 ,2000 )
	//	oReport:Box(050,050, 100 ,0300 )
	//	oReport:Box(050,1800,100 ,2000 )


	// Imprime dados do cliente ---------------------------------------
//	oReport:say(220,100, "CLIENTE.: " + TRBVEN->TAB_CLI	 ,oFont12N)   //<========== erro aki

//	oReport:say(070, 800 , 	"WLADIMIR VIEIRA"		,oFont12N)				
	//+-------------------------------------------------------------+
	//| Definir Quebra de secao do relatorio = Total Por Fornecedor |
	//+-------------------------------------------------------------+


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportPrint³ Autor ³ Wladimir Vieira       ³ Data ³19/02/19  ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das secoes do relatorio    	        	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AA                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

	//
	//	Local oSection1 := oReport:Section(1)
	//	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cFor      := ""
	Local lPrim 	:= .T.
	Local FilAtual  := cFilAnt //-- Guardar filial logada 
	Local EmpAtual  := cEmpAnt //-- Gaurdar empresa logada
	Local nLinhaAux := 4000

/*	
	oReport:SetLineHeight(40)     //Define a altura da linha na impressão.         
	oReport:SetColSpace(15,.T.)   //Define o espaçamento entre as colunas. 
	oReport:SetLeftMargin(5)      //Define a margem à esquerda do relatório
	oReport:oPage:SetPageNumber(1) 
	oReport:cFontBody := "Arial" 
	oReport:nFontBody := 12 
	oReport:lBold := .F.            //Aponta que as Informações serão impressas em negrito   
	oReport:lUnderLine := .F.
		oReport:Setborder(5)               //Borda 5 - todas
	 */
	oReport:lHeaderVisible := .F.   //Habilita a impressão do cabeçalho                      
	oReport:lFooterVisible := .F.   //Habilita a impressão do Rodape
	oReport:lParamPage := .F.       //Existe parâmetros para impressão 
	oReport:setlandscape()          //Orientação da impreesão
//	oReport:SetpaperSize(9)
//	oReport:SetResolution(72)
 
	//    oReport:SayBitmap(5,15,cBitmap,10,10)
	
	
	Private cFileSelo       := GetSrvProfString('Startpath','') + 'SeloZFra' + '.PNG'
	Private cFileLogo       := GetSrvProfString('Startpath','') + 'danfe0101' + '.bmp'
	Private cFileAss1       := GetSrvProfString('Startpath','') + 'assina01' + '.bmp'
	Private cFileAss2       := GetSrvProfString('Startpath','') + 'assina02' + '.bmp'

	Private oFont08  := TFont():New("ARIAL",08,08,,.F.,,,,.T.,.F.)
	Private oFont10  := TFont():New("ARIAL",10,10,,.F.,,,,.T.,.F.)
	Private oFont10N := TFont():New("ARIAL",10,10,,.T.,,,,.T.,.F.)
	Private oFont28N := TFont():New("ARIAL",28,28,,.T.,,,,.T.,.F.)
	Private oFont12  := TFont():New("ARIAL",12,12,,.F.,,,,.T.,.F.)
	Private oFont12N := TFont():New("ARIAL",12,12,,.T.,,,,.T.,.F.)
	Private oFont12NC := TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)
	Private oFont14  := TFont():New("ARIAL",14,14,,.F.,,,,.T.,.F.)
	Private oFont14N := TFont():New("ARIAL",14,14,,.T.,,,,.T.,.F.) 



	//-- Regua do Relatorio
	oReport:SetMeter(TRBVEN->(LastRec()))
	(TRBVEN->(dbGoTop()))

	//Percorre os registros para impressão
	
	dbSelectArea("SD2")
	_cRecSD2 := Recno()
	_cIndex  := Indexord()
	
	_mNota  := SD2->D2_DOC
	_mSerie := SD2->D2_SERIE
	
	dbSetOrder(3)
	dbGotop()
	dbSeek(xFilial("SD2")+_mNota+_mSerie)

	While !(SD2->(EOF())) .AND. SD2->D2_DOC == _mNota .AND. SD2->D2_SERIE == _mSerie 
		// tomei porrada
		// Imprime um cabeçalho por cliente.
		If empty(SD2->D2_XNOCQ)
		   SD2->(dbSkip())
		   loop
		Endif
		   
		
		If nLinhaaux > 3400

			// Finaliza Impressão
			oReport:EndPage()

			// Definicao dos Box
			oReport:StartPage()

			// Cabeçalho do certificado
			cVarAux00 := "CERTIFICADO DE QUALIDADE"
			
			cVarAux1A := "CLIENTE :" +  POSICIONE("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE,"A1_NOME") 
			cVarAux1B := "PRODUTO : " + POSICIONE("SBM",1,xFilial("SBM")+SD2->D2_GRUPO,"BM_DESC")
			cVarAux1C := "CERTIFICADO No : " + SD2->D2_XNOCQ
			
			cVarAux2A := "NOTA FISCAL :  " + SD2->D2_DOC+"/"+SD2->D2_SERIE
			cVarAux2B := "DATA : "  + dtoc(SD2->D2_EMISSAO)
			
			cVarAux3A := "PEDIDO CLIENTE : " + SD2->D2_PEDIDO              
			cVarAux3B := "NORMA/GRADE : NORMA ABNT NBR 7480"
			
			cVarAux4A := "BITOLA / SIZE"
			cVarAux4B := "LOTE /CORRIDA "      
			cVarAux4C := "QUANTIDADE KG "
			cVarAux4D := "M. Lin KG/m "
			cVarAux4E := "LE (Mpa)"
			cVarAux4F := "LR (Mpa)"
			cVarAux4G := "LR / LE"
			cVarAux4H := "ALOG (%)"
			cVarAux4I := "DOBR."
			
			cVarAux5A := "                      PROPRIEDADES MECANICAS"
			cVarAux5B := "Along - Alongamento "
			cVarAux5C := "Desdobr - Desdobramento "
			cVarAux5D := "LE - Limite de Escoamento Mpa" 
			cVarAux5E := "LR - Limite de Resistencia Mpa"
			cVarAux5F := "LR/LE - Relação Entre Limite de Resistência e Limite de Escoamento"
			cVarAux5G := "Mlin - Massa Linear"
			
			cVarAux6A := "                           OBSERVAÇÕES"
			cVarAux6B := "As propriedades Físicas, químicas e mecânicas descritas neste Certificado"
			cVarAux6C := "de Qualidade são garantidos conforme especificações da NORMA ABNT "
			cVarAux6D := "NBR7480, e  salientamos  também  que  quaisquer alterações realizadas por"
			cVarAux6E := "terceiros podem alterar consideravelmente suas propriedades "

			
			//Cargos
			cVarAux7A := "COORDENAÇÃO DE SGQ "				
			cVarAux7B := "ENGENHEIRO RESPONSÁVEL "                                         				
			cVarAux7C := "CARIMBO CQ "
			
			cVarAux8A := "AMAZON AÇO INDUSTRIA E COMÉRCIO LTDA - Avenida Puraquequara 5328 - Puraquequara -Manaus - Am CNPJ 05.477.207/0001-75"
			
			cVarAux9A := GETMV("MV_XCSGI")  
			cVarAux9B := GETMV("MV_XENGRES")
			
			
/*
			Local cVar // quando existe o parametro criado
			cVar := GetMv( "MV_SIGALOG" , .F. ,  )        	// retorna o conteudo do parametro
			cVar := GetMv( "MV_SIGALOG" , .F. , "Teste" ) 	// retorna o conteudo do parametro
			cVar := GetMv( "MV_SIGALOG" , .T. ,  )   	   	// retorna .T.
			cVar := GetMv( "MV_SIGALOG" , .T. , "Teste" ) 	// retorna o conteudo do parametro//nao existe o parametro e for executado pela rotina auto  
			cVar := GetMv( "MV_SIGALOG" , .F. ,  )      	// retorna .F. e gera log na system
			cVar := GetMv( "MV_SIGALOG" , .F. , "Teste" ) 	// retorna Teste cVar := GetMv( "MV_SIGALOG" , .T. ,  ) 		// retorna .F.   
			cVar := GetMv( "MV_SIGALOG" , .T. , "Teste" ) 	// retorna Teste     // nao existe o parametro e acessa pelo remote
			cVar := GetMv( "MV_SIGALOG" , .F. ,  )        	// retorna .F. e exibe msg de help
			cVar := GetMv( "MV_SIGALOG" , .F. , "Teste" ) 	// retorna Teste
			cVar := GetMv( "MV_SIGALOG" , .T. ,  )        	// retorna .F.  
			cVar := GetMv( "MV_SIGALOG" , .T. , "Teste" ) 	// retorna Teste
*/			

			
			
			oReport:say(270, 900 , 	cVarAux00		,oFont28N)
			
			oReport:say(550, 0100 , 	cVarAux1A		,oFont14N)
			oReport:say(550, 1300 , 	cVarAux1B		,oFont14N)
			oReport:say(550, 2400 , 	cVarAux1C		,oFont14N)
				
			oReport:say(650, 0100 , 	cVarAux2A		,oFont14N)
			oReport:say(650, 1300 , 	cVarAux2B		,oFont14N)
			
			oReport:say(750, 0100 , 	cVarAux3A		,oFont14N)
			oReport:say(750, 1300 , 	cVarAux3B		,oFont14N)
			
			oReport:say(900, 0080 , 	cVarAux4A		,oFont14N)  //campo bitola
			oReport:say(900, 0450 , 	cVarAux4B		,oFont14N)  //campo lote
			oReport:say(900, 0850 , 	cVarAux4C		,oFont14N)  //campo quantidade
			oReport:say(900, 1300 , 	cVarAux4D		,oFont14N)  //campo M. LinKg/m
			oReport:say(900, 1610 , 	cVarAux4E		,oFont14N)  //campo LE
			oReport:say(900, 1900 , 	cVarAux4F		,oFont14N)  //campo LR 
			oReport:say(900, 2200 , 	cVarAux4G		,oFont14N)  //campo LR/LE
			oReport:say(900, 2450 , 	cVarAux4H		,oFont14N)  //campo Alog
			oReport:say(900, 2800 , 	cVarAux4I		,oFont14N)  //campo Dobr
			
			oReport:Box(850,050, 975 ,3000 )   //Box cabçalho
			
			oReport:Box(850,050, 1700 ,390 )   //Box campo bitola
			oReport:Box(850,390, 1700 ,800 )   //Box campo lote
			oReport:Box(850,800, 1700 ,1250 )   //Box campo Quant 
			oReport:Box(850,1250, 1700 ,1600 )   //Box campo m lin q
			oReport:Box(850,1600, 1700 ,1800 )   //Box campo  le 
			oReport:Box(850,1800, 1700 ,2150 )   //Box campo  lr      
			oReport:Box(850,2150, 1700 ,2390 )   //Box campo  lr / le
			oReport:Box(850,2390, 1700 ,2700 )   //Box campo  alog
			oReport:Box(850,2700, 1700 ,3000 )   //Box campo  dobr
			
			oReport:Box(050,050, 500  ,600 )    // Box Logo Amazon
			oReport:Box(050,2400,500 ,3000 )    // Bpx Logo Suframa
			oReport:Box(050,050 ,500 ,3000 )    // Bpx cabecalho
			
//			oReport:SayBitmap(100,100,cFileLogo,398,295)
			oReport:SayBitmap(100,100,cFileLogo,398,350)
			oReport:SayBitmap(065,2465,cFileSelo,450,405)
			
			oReport:Box(1700,0050,2100 ,1500 )    // Quadro rodape
			oReport:Box(1700,1500,2100 ,3000 )    // Quadro rodape
			
			oReport:Box(2100,050,2350 ,3000 )    // Quadro assinaturas
			oReport:Box(2100,990,2350 ,2090 )    // Quadro assinaturas
			
			//oReport:say(1800, 0060 , 	cVarAux5A		,oFont14N)  //campo bitola
			oReport:say(1700, 0060 , 	cVarAux5A		,oFont14N)  //campo bitola
			oReport:say(1800, 0060 , 	cVarAux5B		,oFont12N)  //campo bitola
			oReport:say(1850, 0060 , 	cVarAux5C		,oFont12N)  //campo bitola
			oReport:say(1900, 0060 , 	cVarAux5D		,oFont12N)  //campo bitola
			oReport:say(1950, 0060 , 	cVarAux5E		,oFont12N)  //campo bitola
			oReport:say(2000, 0060 , 	cVarAux5F		,oFont12N)  //campo bitola
			oReport:say(2050, 0060 , 	cVarAux5G		,oFont12N)  //campo bitola
			
			//oReport:say(1800, 1560 , 	cVarAux6A		,oFont14N)  //campo bitola
			oReport:say(1700, 1555 , 	cVarAux6A		,oFont14N)  //campo bitola
			oReport:say(1800, 1555 , 	cVarAux6B		,oFont12N)  //campo bitola
			oReport:say(1850, 1555 , 	cVarAux6C		,oFont12N)  //campo bitola
			oReport:say(1900, 1555 , 	cVarAux6D		,oFont12N)  //campo bitola
			oReport:say(1950, 1555 , 	cVarAux6E		,oFont12N)  //campo bitola
			//oReport:say(2150, 1560 , 	cVarAux6F		,oFont12N)  //campo bitola
			//oReport:say(2200, 1560 , 	cVarAux6G		,oFont12N)  //campo bitola
			
			oReport:say(2120, 0270 , 	cVarAux7A		,oFont12N)  //campo bitola
			oReport:say(2120, 1290 , 	cVarAux7B		,oFont12N)  //campo bitola
		//	oReport:say(2120, 2310 , 	cVarAux7C		,oFont12N)  //campo bitola
			
			oReport:SayBitmap(2160,0260,cFileass1,400,160)          //Arquivo BMP da assinatura 01
			oReport:SayBitmap(2160,1260,cFileass2,400,160)          //Arquivo BMP da assinatura 02
			
			oReport:say(2290, 0260 , 	cVarAux9A		,oFont12N)  //campo RESPONSAVEL CGI
			oReport:say(2290, 1260 , 	cVarAux9B		,oFont12N)  //campo ENGENHEIRO RESPONSAVEL
			
		//	oReport:say(2395, 0200 , 	cVarAux8A		,oFont12N)  //campo bitola
			
			// Coloca primeira posição da linha
			nLinhaAux := 1000 

			// Definicao da pagina
			oReport:StartPage()
		Endif		

		// cria caixa do cabeçalho
		
		//			nLinhaAux += 60
		//			oReport:Box(nLinhaAux ,0100, nLinhaAux + 60 ,nLargura - 150 )
		//			nLinhaAux += 5
		oReport:say(nLinhaAux,0100, Alltrim( transform(val( STRTRAN(SD2->D2_XBITOLA, ",", ".") ), "@E 99.99"))	,oFont12N)// 
		oReport:say(nLinhaAux,0450, SD2->D2_XLOTEC	    ,oFont12N)// 
		oReport:say(nLinhaAux,0900, transform(SD2->D2_xQTDCOR,"@E 9,999,999.99")	 	,oFont12N)	//
		oReport:say(nLinhaAux,1300, transform(SD2->D2_XMLK  ,"@E 9,999.999") 	,oFont12N)	//
		oReport:say(nLinhaAux,1610, transform(SD2->D2_XLE   ,"@E 9,999.999")	 	,oFont12N)	//
		oReport:say(nLinhaAux,1900, transform(SD2->D2_XLR   ,"@E 9,999.999")	 	,oFont12N)	//
		oReport:say(nLinhaAux,2170, transform(SD2->D2_XLRLE ,"@E 9,999.999")	,oFont12N)	//
		oReport:say(nLinhaAux,2450, transform(SD2->D2_XALONG,"@E 9,999.999")	,oFont12N)	//
		oReport:say(nLinhaAux,2800, "OK"	,oFont12N)	//
		
		nLinhaAux+= 50

	nLinhaAux+= 50

	SD2->(dbSkip())

	EndDo
	// Finaliza Impressão
	oReport:EndPage()
dbSelectArea("SD2")
dbSetOrder(_cIndex)
go _cRecSD2


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ajustaSx1  ³ Autor ³ Breno Nogueira        ³ Data ³ 06/2016  ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criacao das perguntas relacionadas ao relatorio     	       ³±±
±±³          ³ Caso nao encontre cria as perguntas                 	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIEAM                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function ajustaSx1(cPerg)

static function ValidaPerguntas()
	private _sAlias:= Alias()
	private aRegs  := {}
	private i,j

	dbselectarea('SX1')
	dbsetorder(1)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aadd(aRegs,{cPerg,'01','Data inicial ?'  ,'Data inicial ?'  ,'Data inicial ?'  ,'MV_CH1','D',8,00,0,'G','','MV_PAR01',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'02','Data final ?'    ,'Data final ?'    ,'Data final ?'    ,'MV_CH2','D',8,00,0,'G','','MV_PAR02',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'03','Cód. Oper. de ?' ,'Cód. Oper. de ?' ,'Cód. Oper. de ?' ,'MV_CH3','C',6,00,0,'G','','MV_PAR03',"","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aadd(aRegs,{cPerg,'04','Cód. Oper. até ?','Cód. Oper. até ?','Cód. Oper. até ?','MV_CH4','C',6,00,0,'G','','MV_PAR04',"","","","","","","","","","","","","","","","","","","","","","","","","SA3"})

	for i:=1 to len(aRegs)
		if !dbseek(cPerg+aRegs[i,2])
			recLock('SX1',.T.)

			for j:=1 to fcount()
				if j <= len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				endif
			next

			msunlock()
		endif
	next

	dbselectarea(_sAlias)
	return

	aHelpPor := {}
	aAdd(aHelpPor, "Data inicio Emissao. (faixa inicial)       " )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "01", "Data De ?"	  , "", "", "mv_ch1", "D", tamSx3("E1_EMISSAO")[1], 0, 0, "G", "", "", "", "", "mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Data final Emissao.(faixa Final)        " )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "02", "Data Até ?"	  , "", "", "mv_ch2", "D", tamSx3("E1_EMISSAO")[1], 0, 0, "G", "", "", "", "", "mv_par02","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Filial Inicial para relatório(faixa Inicial" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "03", "Filial De ?"	  , "", "", "mv_ch3", "C", tamSx3("E1_FILIAL")[1], 0, 0,"G", "", "SM0", "", "", "mv_par03","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Filial Final para relatório(faixa Final" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "04", "Filial Até ?"	  , "", "", "mv_ch4", "C", tamSx3("E1_FILIAL")[1], 0, 0, "G", "", "SM0", "", "", "mv_par04","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Prefixo Inicial para relatório(faixa Inicial" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "05", "Prefixo De ?"	  , "", "", "mv_ch5", "C", tamSx3("E1_PREFIXO")[1], 0, 0, "G", "", "", "", "", "mv_par05","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Prefixo Final para relatório(faixa Final" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "06", "Prefixo Ate ?"	  , "", "", "mv_ch6", "C", tamSx3("E1_PREFIXO")[1], 0, 0, "G", "", "", "", "", "mv_par06","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Tipo de Título Inicial (faixa Inicial" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "07", "Tipo De ?"	  , "", "", "mv_ch7", "C", tamSx3("E1_TIPO")[1], 0, 0,      "G", "", "05", "", "", "mv_par07","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Tipo de Título Final (faixa Final" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "08", "Tipo Ate ?"	  , "", "", "mv_ch8", "C", tamSx3("E1_TIPO")[1], 0, 0, "G", "", "05", "", "", "mv_par08","","","","","","","","","","","","","","","","",aHelpPor,{},{})

	//	aHelpPor := {}
	//	aAdd(aHelpPor, "Lista usuário INTEGRACAO ?" )
	//	aAdd(aHelpPor, "                                         " )
	//	aAdd(aHelpPor, "                                         " )
	//	putSx1(cPerg, "09", "Lista INTEGRACAO?"	  , "", "", "mv_ch9", "N",01,00,00, "C", "", "05", "", "", "mv_par09","Sim","","","","Nao","","","","","","","","","","","",aHelpPor,{},{})

	aHelpPor := {}
	aAdd(aHelpPor, "Ordem do Relatório" )
	aAdd(aHelpPor, "                                         " )
	aAdd(aHelpPor, "                                         " )
	putSx1(cPerg, "09", "Ordem?"	  , "", "", "mv_ch9", "N",01,00,00, "C", "", "05", "", "", "mv_par09","Emissao","","","","DT.Altera","","","","","","","","","","","",aHelpPor,{},{})

return


static function buscadados()
	// Esta função foi criada para captar os dados para o relatório de acordo com os parâmetros informados
	/*
	Private _cdProdDe   := MV_PAR01
	PRivate _cdProdAte  := MV_PAR02
	PRivate _cdGrupoDe  := MV_PAR03
	PRivate _cdGrupoAte := MV_PAR04
	PRivate _cdTipoDe   := MV_PAR05
	PRivate _cdTipoAte  := MV_PAR06
	//	PRivate _cdLocalDe  := ''
	//	PRivate _cdLocalAte := 'ZZ'
	PRivate _cdFerraDe  := ''
	PRivate _cdFerraAte := 'ZZ'
	*/


	// VERIFICA SE A PROCEDURE ESTA ABERTA
	IF Select("TRBVEN") <> 0
		DbSelectArea("TRBVEN")
		DbCloseArea()
	ENDIF

	//+-------------------------------------------------------------+
	//| Query para geracao do relatorio  							|
	//+-------------------------------------------------------------+
	/*_cdQry := ""
	_cdQry := " Exec AA_SUGESTCOMPRA12 " 
	_cdQry += " '" + _cdProdDe  + "' , '" + _cdProdAte  + "',"
	_cdQry += " '" + _cdGrupoDe + "' , '" + _cdGrupoAte + "'," 
	_cdQry += " '" + _cdTipoDe  + "' , '" + _cdTipoAte  + "',"
	_cdQry += " '" + _cdLocalde + "' , '" + _cdLocalAte + "',"
	_cdQry += " ' ' , 'ZZZZ'"

	Memowrite('AACOMR04.SQL',_cdQry)

	//dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), _cdTbl , .T., .T.)
	dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), "TRBPRO" , .T., .T.)

	//-- Alias referente a Query
	//	TCQUERY cQuery NEW ALIAS "TRBPRO"
	*/

	// Define ARRAY com dados temporário para listar relatorio
	aFields := {}
	AADD(aFields,{"TAB_CLI"  ,"C",30,0})
	AADD(aFields,{"TAB_NFISC"  ,"C",09,0})
	AADD(aFields,{"TAB_PEDCLI"  ,"C",06,0})
	AADD(aFields,{"TAB_PRODUT"  ,"C",25,0})
	AADD(aFields,{"TAB_DATA"  ,"C",10,0})
	AADD(aFields,{"TAB_NORMA"  ,"C",20,0})
	AADD(aFields,{"TAB_CERTIF"  ,"C",10,0})
	AADD(aFields,{"TAB_BITOLA"  ,"C",08,0})
	AADD(aFields,{"TAB_LOTE"  	,"C",10,0})
	AADD(aFields,{"TAB_QTD" 	,"N",12,2})
	AADD(aFields,{"TAB_MLINKG" 	,"C",10,0})
	AADD(aFields,{"TAB_LE"  	,"C",10,0})
	AADD(aFields,{"TAB_LR"   	,"C",10,0})
	AADD(aFields,{"TAB_LE_LR"   ,"C",10,0})
	AADD(aFields,{"TAB_ALOG"    ,"C",10,0})
	AADD(aFields,{"TAB_DOBR" 	,"C",10,0})

	cArq1   := CriaTrab(NIL,.F.)
	DbCreate(cArq1,aFields)
	dbUseArea(.T.,,cArq1,"TRBVEN",.T.)

	///cIndex := CriaTrab(NIL,.F.)
	//cKey   := "B1_FILIAL+B1_GRUPO+B1_DESC"       // CRIA INDICE POR GRUPO
	//IndRegua("SB1",cIndex,cKey,,," Criando Indice ...    ")

	//nIndex := RetIndex("SB1")
	//dbSetOrder(nIndex+1)


	// Aliment para efeito de testes
	Reclock("TRBVEN",.T.)
	TAB_CLI    := "AMAZON AÇO INDUSTRIA E COMERCIO LTDA"
	TAB_NFISC  := "000002154"
	TAB_PEDCLI := "002212"
	TAB_PRODUT := " "
	TAB_DATA   := "22/02/2019" 
	TAB_NORMA  := "ABNT NBR 7480"
	TAB_CERTIF := "0000/19"

	TAB_BITOLA := '1.9/16"' 
	TAB_LOTE   := "201902/001"
	TAB_QTD    := 32
	TAB_MLINKG := "ABCDEFGH"
	TAB_LE     := "IJKLMNOZ"
	TAB_LR     := "PQRSTUVZ"
	TAB_LE_LR  := "WXYZ012Z"
	TAB_ALOG   := "AIPW3345"
	TAB_DOBR   := "345WPIAZ"

	MsUnlock("TRBVEN") 

return

///////////////////////////////  Formato de seções

static function porsecao
	//-- Selecao da Area
	
	dbSelectArea("SD2")
	_cRecSD2 := RECNO()
	_cIndex  := indexord() 
	 

	//-- Impressao da primeira secao
	//-- Inicia a primeira seção

	oSection1:Init()
	oSection1:Cell("TAB_CLI"	 ):SetValue(TRBVEN->TAB_CLI, "@!")
	oSection1:Cell("TAB_NFISC"	 ):SetValue(TRBVEN->TAB_NFISC, "@!")
	oSection1:Cell("TAB_PEDCLI"	 ):SetValue(TRBVEN->TAB_PEDCLI, "@!")
	oSection1:Cell("TAB_PRODUT"	 ):SetValue(TRBVEN->TAB_PRODUT, "@!")
	oSection1:Cell("TAB_DATA"	 ):SetValue(TRBVEN->TAB_DATA, "@!")
	oSection1:Cell("TAB_NORMA"	 ):SetValue(TRBVEN->TAB_NORMA, "@!")
	oSection1:Cell("TAB_CERTIF"	 ):SetValue(TRBVEN->TAB_CERTIF, "@!")

	oSection1:Printline()

	oSection1:Finish()

	oSection2:Init()
	// Percorre toda a tabela
	While !eof()

		//-- Regua da primeira secao
		oReport:IncMeter()
		oSection2:Cell("TAB_BITOLA"	 ):SetValue(TRBVEN->TAB_BITOLA, "@!")		
		oSection2:Cell("TAB_LOTE"	 ):SetValue(TRBVEN->TAB_LOTE, "@!")
		oSection2:Cell("TAB_QTD"	 ):SetValue(TRBVEN->TAB_QTD, "@E 9,999,999.99")
		oSection2:Cell("TAB_MLINKG"	 ):SetValue(TRANSFORM(TRBVEN->TAB_MLINKG, "@!"))		
		oSection2:Cell("TAB_LE"	     ):SetValue(TRANSFORM(TRBVEN->TAB_LE, "@!"))		
		oSection2:Cell("TAB_LR"	     ):SetValue(TRANSFORM(TRBVEN->TAB_LR, "@!"))		
		oSection2:Cell("TAB_LE_LR"	 ):SetValue(TRANSFORM(TRBVEN->TAB_LE_LR, "@!"))		
		oSection2:Cell("TAB_ALOG"	 ):SetValue(TRANSFORM(TRBVEN->TAB_ALOG, "@!"))		
		oSection2:Cell("TAB_DOBR"	 ):SetValue(TRANSFORM(TRBVEN->TAB_DOBR, "@!"))		

		oSection2:Printline()

		//dbSelectArea("TRBVEN")
		TRBVEN->(dbSkip())

	Enddo

	oSection2:Finish()
	oReport:ThinLine()


