#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

/*/{Protheus.doc} User Function AMFINR01
   Impressão do Boleto do Brasil	
   @type  Function
   @author Marcel R. Grosselli 
   @since 08/08/2023
/*/
User Function AMFINR01()  
   Local oFont1       := TFont():New("Courier New",,-12,.T.,.T.)

   Private lExec      := .F.
   Private cIndexName := ''
   Private cIndexKey  := ''
   Private cFilter    := ''
   Private cBOrdero   := ''
   Private nQtdMark   := 0
   Private nVlrMark   := 0  

   Tamanho  := "M"
   titulo   := "Boleto do Banco do Brasil"
   cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
   cDesc2   := ""
   cDesc3   := ""
   cString  := "SE1"
   wnrel    := "AMFINR01"
   lEnd     := .F.
   cPerg    := ""
   nTam     := TamSX3("E1_NUM")[1]   
   nTam2    := TamSX3("E1_PARCELA")[1]
   aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
   nLastKey := 0

   oFWSX1 := FWSX1Util():New()
   oFWSX1:AddGroup("AMFINR01")
   oFWSX1:SearchGroup()
   aPergunte := oFWSX1:GetGroup("AMFINR01")

   cPerg   := PADR("AMFINR01",LEN(aPergunte[1])," ")
   Pergunte(cPerg,.T.)

   If nLastKey == 27
      Set Filter to
      Return
   Endif

   cIndexName	:= Criatrab(Nil,.F.)                                                                          

   cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO)"
   cFilter    += "E1_FILIAL=='"+SE1->(xFilial())+"'.And.E1_SALDO>0.And."
   cFilter    += "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
   cFilter    += "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
   cFilter    += "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
   cFilter    += "DTOS(E1_EMISSAO)>='"+DTOS(mv_par07)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par08)+"' .And."
   cFilter		+= "DTOS(E1_VENCTO)>='"+DTOS(mv_par09)+"'.and.DTOS(E1_VENCTO)<='"+DTOS(mv_par10)+"'.And. "
   cFilter		+= "E1_CLIENTE>='" + MV_PAR11 + "'.And.E1_CLIENTE<='" + MV_PAR12 + "'.And."
   cFilter		+= "E1_TIPO $ 'BO ,BOL,FT ,FI ,DP ,NF ' .AND. " 
   cFilter     += "E1_XBANCO $ '   ,001'"           

   IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

   cMarca	:= GetMark()

   DbSelectArea("SE1")
   dbGoTop()

   DEFINE MSDIALOG oDlg TITLE "Seleção de Titulos" FROM 00,00 TO 400,700 PIXEL

      oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

      oMark:oBrowse:Refresh()
      oMark:bAval               := { || Marcar( cMarca , .F. ) }
      oMark:oBrowse:lHasMark    := .T.
      oMark:oBrowse:lCanAllMark := .T.
      oMark:oBrowse:bAllMark    := { || MarcaTodos( cMarca ) }     

      @ 180,005 SAY "Quantidade" FONT oFont1 PIXEL OF oDlg COLOR CLR_HBLUE
      @ 180,030 SAY oQT  VAR nQtdMark Picture "@E 999,999,999" FONT oFont1 PIXEL OF oDlg COLOR CLR_HRED
      @ 180,075 SAY "Valor total" FONT oFont1 PIXEL OF oDlg COLOR CLR_HBLUE
      @ 180,120 SAY oTit VAR nVlrMark Picture "@E 999,999,999.99" FONT oFont1 PIXEL OF oDlg COLOR CLR_HRED

      DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
      DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

   ACTIVATE MSDIALOG oDlg CENTERED
	
   dbGoTop()
   If lExec
      Processa({|lEnd|ProcSelecao()})
   Endif

   DbSelectArea("SE1")
   Set Filter to

   RetIndex("SE1")
   Ferase(cIndexName+OrdBagExt())

Return Nil

/*/{Protheus.doc} Marcar
   Executada ao selecionar um registro
   @type  Static Function
   @author Marcel R. Grosselli
   @since 23/05/2019
/*/
Static Function Marcar(cMarca,lTodos)
	RecLock("SE1",.F.)
	   SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
	MsUnLock()
	
	If E1_OK == cMarca
		nQtdMark++
		nVlrMark += E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	ElseIf !lTodos
		nQtdMark--
		nVlrMark -= E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	Endif
	
	If !lTodos
		oMark:oBrowse:Refresh()
		oQT:Refresh()
		oTit:Refresh()
	Endif
	
Return

/*/{Protheus.doc} MarcaTodos
   Seleciona todos os registros
   @type  Static Function
   @author Marcel R. Grosselli
   @since 23/05/2019
/*/
Static Function MarcaTodos(cMarca)
	
	nQtdMark := 0
	nVlrMark := 0
	
	SE1->(dbGoTop())
	While !SE1->(Eof())
		Marcar(cMarca,.T.)
		dbskip()
	Enddo
	SE1->(dbGoTop())
	
	oMark:oBrowse:Refresh()
	oQT:Refresh()
	oTit:Refresh()
	
Return

/*/{Protheus.doc} ProcSelecao
   Verifica os itens selecionados e realiza a impressao dos boletos
   @type  Static Function
   @author Marcel R. Grosselli
   @since 23/05/2019
/*/
Static Function ProcSelecao()
   dbGoTop()
   ProcRegua(RecCount())
   While !EOF()
      IncProc()

      If E1_OK <> cMarca //Marked("E1_OK")
         dbSkip()
         Loop
      Endif

      PIFINR2B()
      
      dbSkip()
   Enddo
Return

/*/{Protheus.doc} PIFINR2B
   Impressao do boleto laser com codigo de barras para o registro posicionado na SE1
   @type  User Function
   @author Marcel R. Grosselli
   @since 23/05/2019 
   @param oPrint -objeto fwmsprinter
/*/
static Function PIFINR2B(oPrint,lDanfe,nPaginas)
   Default oPrint   := SetTMSPrt()
   Default lDanfe   := .F.  //se foi chamado atraves da impressao da danfe
   Default nPaginas := 0    //armazena a quantidade de paginas impressas, utilizado na funcao de envio da danfe pelo tss
   
   Local nVlrAbat    := 0
   Local cMaxPar     := ""
   Local cQuery      := ""
   Local aDadosBanco := {}
   Local aDatSacado  := {}
   Local aCB_RN_NN   := {}
   Local aBolText    := {"", "", "", "", ""}
   Local aDadosEmp   := {}  
   Local aSm0        := FWSM0Util():GetSM0Data( cEmpAnt, '0101' ,;
                         { "M0_CGC","M0_NOMECOM","M0_ENDCOB","M0_BAIRCOB","M0_CIDCOB","M0_ESTCOB","M0_CEPCOB","M0_TEL","M0_INSC" } )

   Private cNroDoc   :=  " "
   Private cBanco 	:= "001" //banco Bradesco
   Private cDBanco   := "Banco do Brasil S.A."
   Private cAgencia  := substr(GetMv("MV_XAGBB"),01,05)   
   Private cConta    := substr(GetMv("MV_XCCBB"),01,10)      
   Private cSbConta  := substr(GetMv("MV_XSBBB"),01,03)

   Private aDadosTit := {}
   Private lSafra    := .T.
   Private nJurBol   := GetMv("MV_XJURBOL",.F.,0) 
   Private nMulBol   := GetMv("MV_XMULBOL",.F.,0) 



   aDadosEmp   := {	aSm0[2,2]                                                  ,; //[1]Nome da Empresa
                     aSm0[3,2]                                                  ,; //[2]Endereço
                     AllTrim(aSm0[4,2])+", "+AllTrim(aSm0[5,2])+", "+aSm0[6,2]  ,; //[3]Complemento
                     Subs(aSm0[7,2],1,5)+"-"+Subs(aSm0[1,2],6,3)                ,; //[4]CEP
                     "PABX/FAX: "+aSm0[8,2]                                     ,; //[5]Telefones
                     Transform(aSm0[1,2],"@R 99.999.999/9999-99")               ,;
                     ""} //[6]CGC
                   //  "I.E.: "+Subs(aSm0[9,2],1,3)+"."+Subs(aSm0[9,2],4,3)+"."+  ;  //[7]
                    // Subs(aSm0[9,2],7,3)+"."+Subs(aSm0[9,2],10,3)               }  //[7]I.E
   
   //Posiciona o SA1 (Cliente)
   SA1->(DbSetOrder(1))
   SA1->(DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))  
                  
   // Calcula o total de parcelas geradas para o titulo
   cQuery := "SELECT MAX(E1_PARCELA)E1_PARCELA FROM "+RetSQLName("SE1")+" WHERE D_E_L_E_T_=' ' AND E1_FILIAL='"
   cQuery += SE1->(XFILIAL())+"' AND E1_NUM='"+SE1->E1_NUM+"' AND E1_PREFIXO='"+SE1->E1_PREFIXO+"' AND E1_CLIENTE='"
   cQuery += SE1->E1_CLIENTE+"' AND E1_LOJA='"+SE1->E1_LOJA+"'"
   
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
   cMaxPar := YYY->E1_PARCELA
   YYY->(dbCloseArea())
   
   dbSelectArea("SE1")

   //Posiciona o SA6 (Bancos)
   SA6->(DbSetOrder(1))
   SA6->(DbSeek(xFilial("SA6")+cBanco+PadR(cAgencia,05)+PadR(cConta,10),.T.))

   //Posiciona na Arq de Parametros CNAB
   SEE->(DbSetOrder(1))
   SEE->(DbSeek(xFilial("SEE")+"001"+PADR(cAgencia,5)+PADR(cConta,10)+PADR(cSbConta,3),.T.))         
   
   DbSelectArea("SE1")
   aDadosBanco := {SA6->A6_COD,; 	     						           // [1]Numero do Banco
                  SA6->A6_NOME,;                        	           // [2]Nome do Banco
		            SA6->A6_AGENCIA,;				               		  // [3]Agência   						      
                  SA6->A6_NUMCON,;                                  // [4]Conta Corrente
                  SA6->A6_DVCTA ,;                                  // [5]Dígito da conta corrente
                  SUBSTR(SEE->EE_CODCART,1,2),;    	              // [6]Codigo da Carteira
                  SA6->A6_NUMBCO,;                	                 // [7]Nosso Numero            
                  SA6->A6_DVAGE }                                   // [8]Dígito da Agencia           

      
   If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
      aDatSacado   := {AllTrim(SA1->A1_NOME)             ,;        // [1]Razão Social
      AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA             ,;        // [2]Código
      AllTrim(SA1->A1_END )                              ,;        // [3]Endereço
      AllTrim(SA1->A1_MUN )                              ,;        // [4]Cidade
      SA1->A1_EST                                        ,;        // [5]Estado
      SA1->A1_CEP                                        ,;        // [6]CEP
      SA1->A1_CGC									               ,;        // [7]CGC
      " "           									            ,;      	 // [8]PESSOA
      AllTrim(SA1->A1_BAIRRO)                             }        // [9]Bairro   
   Else
      aDatSacado   := {AllTrim(SA1->A1_NOME)             ,;    	// [1]Razão Social
      AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA             ,;    	// [2]Código
      AllTrim(SA1->A1_ENDCOB)                            ,;    	// [3]Endereço
      AllTrim(SA1->A1_MUNC)	                           ,;    	// [4]Cidade
      SA1->A1_ESTC	                                    ,;    	// [5]Estado
      SA1->A1_CEPC                                       ,;    	// [6]CEP
      SA1->A1_CGC								                  ,;		   // [7]CGC
      " "           								               ,;    	// [8]PESSOA
      AllTrim(SA1->A1_BAIRROC)                          }         // [9]Bairro   
   Endif

   nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

   //Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
   //Abaixo apenas uma sugestao
   cNroDoc := Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
   cNroDoc := STRZERO(Val(cNroDoc),11)

   aCB_RN_NN := Ret_cBarra( SE1->E1_PREFIXO , SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO,;
               Subs(aDadosBanco[1],1,3), aDadosBanco[3], aDadosBanco[4], aDadosBanco[5],;
               aDadosBanco[7], cNroDoc , (SE1->E1_SALDO-(nVlrAbat+SE1->E1_DECRESC)), aDadosBanco[6], "9")
   
   aDadosTit := {E1_NUM+ E1_PARCELA,; // [1] Número do título
               E1_EMISSAO                         ,;  // [2] Data da emissão do título
               dDataBase                          ,;  // [3] Data da emissão do boleto
               E1_VENCTO                          ,;  // [4] Data do vencimento
               (E1_SALDO - nVlrAbat)              ,;  // [5] Valor do título
               aCB_RN_NN[3]                       ,;  // [6] Nosso número (Ver fórmula para calculo)
               E1_PREFIXO                         ,;  // [7] Prefixo da NF
               "DM"                               ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
               E1_DECRESC							}  // [9] Decrescimo

   aBolText[1] := "JUROS DIARIO DE: R$ "+SUBSTR(AllTrim(Transform(E1_SALDO * nJurBol/100,"@E 9,999,999.99")),1,13)+" A PARTIR DO DIA: "+SUBSTR(DTOC(E1_VENCTO+1),1,10)
   aBolText[2] := "MULTA DE: R$ "+SUBSTR(AllTrim(Transform(E1_SALDO * nMulBol/100,"@E 9,999,999.99")),1,13)+" A PARTIR DO DIA: "+SUBSTR(DTOC(E1_VENCTO+1),1,10)
   aBolText[3] := ""
   aBolText[4] := ""
   aBolText[5] := "" 
   
   IF lDanfe
      nPaginas++
      oPrint:StartPage()
   EndIf

   Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)

   oPrint:EndPage() 
   
   IF !lDanfe    // Finaliza a página
      oPrint:Preview()
   EndIf  
      // Visualiza antes de imprimir
Return nil

/*/{Protheus.doc} SetTMSPrt
   Cria o objeto tmsprinter caso nao tenha sido passado por parametro
   @type  Static Function
   @author Marcel R. Grosselli
   @since 23/05/2019
/*/
Static Function SetTMSPrt(oPrint)
   Local cPasta    := "C:\temp\" //:= GetTempPath()
   Local cArquivo  := SE1->E1_PREFIXO + SE1->E1_NUM + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
   Private PixelX
   Private PixelY
   Private nConsNeg
   Private nConsTex
   Private oRetNF
   Private nColAux
   Private nMaxItem 

   //Cria a Danfe
   oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., , .T.)

   //Propriedades da DANFE
   oPrint:SetResolution(78)
   oPrint:SetPortrait()
   oPrint:SetPaperSize(DMPAPER_A4)
   oPrint:SetMargin(60, 60, 60, 60)

   //Força a impressão em PDF
   oPrint:nDevice  := 6
   oPrint:cPathPDF := cPasta                
   oPrint:lServer  := .F.
   oPrint:lViewPDF := .T.

Return oPrint

/*/{Protheus.doc} Impress
   Impressao do boleto laser com codigo de barras
   @type  Static Function
   @author Marcel R. Grosselli
   @since 06/10/06
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
   Local oFont6n  := TFont():New("Arial"      ,9, 6,.T.,.F.,5,.T.,5,.T.,.F.)
   Local oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
   Local oFont9   := TFont():New("Arial"      ,9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
   Local oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
   Local oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
   Local oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
   Local oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
   Local oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
   // Local cStartPath := GetSrvProfString("StartPath","") 
   // Local cBmp       := cStartPath + "SAFRA.BMP" //Logo do Banco 

      /***********************/
      /*  CABEÇALHO BOLETO   */
      /***********************/
         nRow1 := 10
         nEspaco := 20
            
         nRow1 += nEspaco
         oPrint:Say  (nRow1,010,cDBanco  ,oFont14 )  // [2]Nome do Banco
         oPrint:Say  (nRow1,500,"Recibo do Pagador" ,oFont11 )
         
         oPrint:Line(nRow1+5 , 010 , nRow1+5, 590)

         nLinInic1 := nRow1+5

         // PRIMEIRA LINHA 
            nRow1 += nEspaco

            oPrint:Say  (nRow1,010 ,"Beneficiário",oFont8n)
            
            oPrint:Say  (nRow1+10,010 ,aDadosEmp[1]+' - '+aDadosEmp[6],oFont10) 

            oPrint:Say  (nRow1,350,"Nosso Número"                                 ,oFont8n)
           
            If Len(AllTrim(aDadosTit[6])) < 13
               cString  := Transform(aDadosTit[6],"@R 99999999999-A")
            Else
               cString  := Transform(aDadosTit[6],"@R 99999999999999999")
            Endif
 
            oPrint:Say  (nRow1+10,350,PADL(cString,17),oFont11c)
                     
            oPrint:Say  (nRow1,500,"Vencimento",oFont8n)
            
            cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
            oPrint:Say  (nRow1+10,500,PADL(cString,17),oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

            nLinInic2 := nRow1+15

         // SEGUNDA LINHA 
            nRow1 += nEspaco*1.5

            oPrint:Say  (nRow1   ,010 ,"Data do Documento"                            ,oFont8n)
            oPrint:Say  (nRow1+10,010 , StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont11c)

            oPrint:Say  (nRow1,100 ,"Nº do Documento"                              ,oFont8n)
            oPrint:Say  (nRow1+10,100 ,alltrim(aDadosTit[7])+alltrim(aDadosTit[1])                      ,oFont11c) //Prefixo +Numero+Parcela

            oPrint:Say  (nRow1,250,"Carteira"    		                            ,oFont8n)
            oPrint:Say  (nRow1+10,250,aDadosBanco[6]     	                         ,oFont11c) //Tipo do Titulo

            oPrint:Say  (nRow1,350,"Agência / Código Beneficiário",oFont8n)  
            cString := Alltrim(substr(aDadosBanco[3],1,4)+"-"+aDadosBanco[8]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5])
            oPrint:Say  (nRow1+10,350,PADL(cString,17) ,oFont11c)
                              
            oPrint:Say  (nRow1,500,"(=)Valor do Documento"                     	,oFont8n)
            cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
            oPrint:Say  (nRow1+10,500,PADL(cString,17),oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

            //linhas horizontais
            oPrint:Line(nLinInic2 , 090 , nRow1+15, 090)
            oPrint:Line(nLinInic2 , 240 , nRow1+15, 240)
            oPrint:Line(nLinInic1 , 340 , nRow1+15, 340)
            oPrint:Line(nLinInic1 , 490 , nRow1+15, 490)
                  
         // TERCEIRA LINHA   
            nRow1 += nEspaco*1.5       
            oPrint:Say  (nRow1   ,010 ,"Pagador"                                      ,oFont8n)
            oPrint:Say  (nRow1+10,010 ,aDatSacado[1]                                 ,oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

         nRow1 += nEspaco*1.5   
         oPrint:Line(nRow1, 010 , nRow1, 590)
         nLinInicB := nRow1
         oPrint:Say  (nRow1+10, 020 ,"Instruções: Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário.",oFont8n)
         
         nRow1 += nEspaco*13
         oPrint:Line(nRow1, 010 , nRow1, 590)

         //cria linhas horizontais
         oPrint:Line(nLinInicB , 010 , nRow1, 010)
         oPrint:Line(nLinInicB , 590 , nRow1, 590)
            
         nRow1 += nEspaco*1.5 
         //colocar linha tracejada
         
         // QUARTA LINHA
            nRow1 += nEspaco
            oPrint:Say  (nRow1, 010,cDBanco ,oFont14 )  // [2]Nome do Banco
            oPrint:Say  (nRow1, 150,aDadosBanco[1]+"-7" ,oFont18 )   // [1]Numero do Banco
            oPrint:Say  (nRow1, 200,aCB_RN_NN[2]       ,oFont14)    // Linha Digitavel do Codigo de Barras

            oPrint:Line(nRow1+5 , 010 , nRow1+5, 590)
            nLinInic1 := nRow1+5

         //QUINTA LINHA
            nRow1 += nEspaco
            oPrint:Say  (nRow1,010 ,"Local de Pagamento",oFont8n)
            oPrint:Say  (nRow1+10,010 ,"Pagável em qualquer banco do sistema de compensação.",oFont9)
                     
            oPrint:Say  (nRow1,500,"Vencimento",oFont8n)
            cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
            nCol    := 1830  
            oPrint:Say  (nRow1+10,500,PADL(cString,17),oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

         //SEXTA LINHA
            nRow1 += nEspaco*1.5 
            oPrint:Say  (nRow1,010 ,"Beneficiário",oFont8n)
            oPrint:Say  (nRow1+010,010 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

            oPrint:Say  (nRow1,300,"CNPJ"                                    ,oFont8n)
            oPrint:Say  (nRow1+010,300,aDadosEmp[6]                              ,oFont10) //CNPJ

            oPrint:Say  (nRow1,500,"Agência / Código Beneficiário",oFont8n)
            cString := Alltrim(substr(aDadosBanco[3],1,4)+"-"+aDadosBanco[8]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5])

            oPrint:Say  (nRow1+10,500,PADL(cString,17),oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

            nLinInic2 := nRow1+15

         //SETIMA LINHA
            nRow1 += nEspaco*1.5 

            oPrint:Say  (nRow1,010 ,"Data do Documento"                            ,oFont8n)
            oPrint:Say  (nRow1+010,010, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

            oPrint:Say  (nRow1,150 ,"Nº do Documento"                              ,oFont8n)
            oPrint:Say  (nRow1+10,150 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

            oPrint:Say  (nRow1,250,"Esp. Doc."                                 ,oFont8n)
            oPrint:Say  (nRow1+010,250,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

            oPrint:Say  (nRow1,300,"Aceite"                                       ,oFont8n)
            oPrint:Say  (nRow1+010,300,"N"                                            ,oFont10)

            oPrint:Say  (nRow1,350,"Data do Processamento"                        ,oFont8n)
            oPrint:Say  (nRow1+010,350,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)  ,oFont10) // Data impressao

            oPrint:Say  (nRow1,500,"Nosso Número"                                 ,oFont8n)

            If Len(AllTrim(aDadosTit[6])) < 13
               cString  := Transform(aDadosTit[6],"@R 99999999999-A")
            Else
               cString  := Transform(aDadosTit[6],"@R 99999999999999999")
            Endif

            oPrint:Say  (nRow1+010,500,PADL(cString,17),oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

            oPrint:Line(nLinInic2 , 290 , nRow1+15, 290)
            oPrint:Line(nLinInic2 , 340 , nRow1+15, 340)

            nLinInic3 := nRow1+15

         //OITAVA LINHA 
            nRow1 += nEspaco*1.5 

            if lSafra
               oPrint:Say  (nRow1,010 ,"Data de Operação:"                            ,oFont8n)
               oPrint:Say  (nRow1+010,010 ,"           "                                  ,oFont10)
            else
               oPrint:Say  (nRow1,010 ,"CIP:"                            ,oFont8n)
               oPrint:Say  (nRow1+010,010 ,"000 "                                  ,oFont10)
            endif

            oPrint:Say  (nRow1,150 ,"Carteira"                                     ,oFont8n)
            oPrint:Say  (nRow1+010,150 ,aDadosBanco[6]                                 ,oFont10)

            oPrint:Say  (nRow1,200 ,"Espécie"                                      ,oFont8n)
            oPrint:Say  (nRow1+010,200 ,"R$"                                           ,oFont10)

            oPrint:Say  (nRow1,250,"Quantidade"                                   ,oFont8n)
            oPrint:Say  (nRow1,350,"Valor"                                        ,oFont8n)

            oPrint:Say  (nRow1,500,"(=)Valor do Documento"                     	,oFont8n)
            cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
            nCol    := 1830  
            oPrint:Say  (nRow1+010,500,PADL(cString,17),oFont11c)

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

            //linhas horizontais
            oPrint:Line(nLinInic2 , 140 , nRow1+15, 140)
            oPrint:Line(nLinInic2 , 490 , nRow1+15, 490)

            oPrint:Line(nLinInic3 , 190 , nRow1+15, 190)
            oPrint:Line(nLinInic3 , 240 , nRow1+15, 240)
            oPrint:Line(nLinInic3 , 340 , nRow1+15, 340)

         //NONA LINHA
            nRow1 += nEspaco*1.5 
            oPrint:Say  (nRow1,010 ,"Instruções: Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário.",oFont8n)
            oPrint:Say  (nRow1+020,010 ,aBolText[1]          ,oFont10)
            oPrint:Say  (nRow1+030,010 ,aBolText[2]          ,oFont10)
            oPrint:Say  (nRow1+040,010 ,aBolText[3]          ,oFont10)
            oPrint:Say  (nRow1+050,010 ,aBolText[4]          ,oFont10)

            oPrint:Say  (nRow1,500,"(-)Desconto / Abatimento"                    ,oFont8n)
            cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
            oPrint:Say  (nRow1,500,PADL(cString,17),oFont11c)
            oPrint:Line(nRow1+10 , 490 , nRow1+10, 590)

            nRow1 += nEspaco
            oPrint:Say  (nRow1,500,"(-)Outras Deduções"                          ,oFont8n)
            oPrint:Line(nRow1+10 , 490 , nRow1+10, 590)
            nRow1 += nEspaco
            oPrint:Say  (nRow1,500,"(+)Mora / Multa"                             ,oFont8n)
            oPrint:Line(nRow1+10 , 490 , nRow1+10, 590)
            nRow1 += nEspaco
            oPrint:Say  (nRow1,500,"(+)Outros Acréscimos"                        ,oFont8n)
            oPrint:Line(nRow1+10 , 490 , nRow1+10, 590)
            nRow1 += nEspaco
            oPrint:Say  (nRow1,500,"(=)Valor Cobrado"                            ,oFont8n)

           // cPix := GeraQRCODE(aDadosEmp[1],aDadosBanco)
           // oPrint:QRCode( nRow1+10,375,cPix,100 )

            oPrint:Line(nRow1+15 , 010 , nRow1+15, 590)

            oPrint:Line(nLinInic1 , 490 , nRow1+15, 490)

         //DECIMA LINHA
            nRow1 += 10
           // oPrint:Say  (nRow1,010 ,'Pix Copia e Cola:'  ,oFont10)
            
            nRow1 += 15
           // oPrint:Say  (nRow1,010 ,cPix                 ,oFont6n)
            oPrint:Line(nRow1+5 , 010 , nRow1+5, 590)
            
            nRow1 += 15
            oPrint:Say  (nRow1,010 ,"Pagador"                                    ,oFont8n)
            oPrint:Say  (nRow1,050 ,aDatSacado[1]                                ,oFont9 )
            oPrint:Say  (nRow1,480 ,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

            nRow1 += 10
            oPrint:Say  (nRow1,050 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )

            nRow1 += 10
            oPrint:Say  (nRow1,050 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

         //DECIMA PRIMEIRA LINHA
            nRow1 += 10
            oPrint:Say  (nRow1,010,"Sacador/Avalista "+ iif(lSafra," ",aDadosEmp[1])             ,oFont8n)
            oPrint:Line(nRow1+5 , 010 , nRow1+5, 590)

            nRow1 += 15
            oPrint:Say  (nRow1,430,"Autenticação Mecânica/Ficha de Compensação"  ,oFont8n)

         //CODIGO DE BARRAS
            oPrint:FWMsBar("INT25",65.05,0.9,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.027,1.5,Nil,Nil,"A",.F.,100,100)

         DbSelectArea("SE1")

   oPrint:EndPage() // Finaliza a página

Return Nil

/*/{Protheus.doc} Ret_cBarra
   Retorna o codigo de barras do boleto
   @type  Static Function
   @author Marcel R. Grosselli
   @since 06/10/06
/*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,;
                            cDacCC,cNumBco,cNroDoc,nValor,cCart,cMoeda)
Local cNosso		:= SE1->E1_NUMBCO
Local cDigNosso		:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra		:= ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}
Local cCodCli       := SubStr(cNumBco,1,7) 
Local cNumTmp       := ""
Local lConv6Dig     := (Len(AllTrim(SEE->EE_CODEMP)) == 6)   // Convênio 6 dígitos

cAgencia := Left(Alltrim(cAgencia),4)

If Empty(cNosso)   // Se ainda não foi calculado   
   
   cNumTmp := NossoNum()

   If lConv6Dig   // Convênio 6 dígitos 
      cNumTmp := Str(Val(cNumTmp),5) 
      cNosso := PADR(StrTran(StrTran(StrTran(SEE->EE_CODEMP,"/",""),"-",""),".",""),6) + strzero(Val(cNumTmp),5)
      cNosso += CALC_5p( cNosso ,.T.) 
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
SE1->E1_NUMBCO  := cNosso   
SE1->E1_XBANCO := "001"
SE1->E1_PORCJUR := GETMV("MV_XJURBOL") 

MsUnlock()

Return aRet

/*/{Protheus.doc} DIGIT001
   Calculo da linha digitavel
   @type  Static Function
   @author Marcel R. Grosselli
   @since 06/10/06
/*/
Static Function DIGIT001(cVariavel)
   Local cBase, nUmDois, nSumDig, nDig, nAux, cValor, nDezena

   cBase   := cVariavel
   nUmDois := 2
   nSumDig := 0
   nAux    := 0
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

Return(Str(nAux,1))


/*/{Protheus.doc} Fator
   Calculo do FATOR  de vencimento para linha digitavel.
   @type  Static Function
   @author Marcel R. Grosselli
   @since 06/10/06
/*/
Static function Fator(dVencto)
   Local cData  := DTOS(dVencto)
   Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return(cFator)

/*/{Protheus.doc} CALC_5p
   Calculo do digito do nosso numero do  
   @type  Static Function
   @author Marcel R. Grosselli
   @since 06/10/06
/*/
Static Function CALC_5p(cVariavel,lNosso)
   Local cBase, nBase, nAux, nSumDig, nDig
   Local nCli := If( Upper(TCGetDB()) == "MSSQL" , 1, 2)   // 1=Unisol, 2=Muraki

   cBase   := cVariavel
   nBase   := 2
   nSumDig := 0
   nAux    := 0
   cDvcb   := "" 
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
      nSumDig += nAux
      nBase   += If( nBase == 9 , -7, 1)
   Next

   
      nAux := Mod(nSumDig * 10,11)
	  cDvcb := (Str(nAux,1))
	  
      If nAux == 0  
         If lNosso
            cDvcb := "0"
		 Else
            cDvcb := "1"
         Endif
	   elseif nAux == 10
	        cDvcb := "1"
       endif
	   	   
Return cDvcb


/*/{Protheus.doc} Modulo10
   Calculo do digito do nosso numero   
   @type  Static Function
   @author Marcel R. Grosselli
   @since 36/11/06 
/*/
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

/*/{Protheus.doc} Modulo11
   Calculo do digito verificador   
   @type  Static Function
   @author Marcel R. Grosselli
   @since 36/11/06 
/*/
Static Function Modulo11(cVariavel,lNosso)
   Local cBase, nBase, nAux, nSumDig, nDig

   cBase   := cVariavel
   nBase   := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
      nSumDig += nAux
      nBase   += If( nBase == 7 , -5, 1)
   Next

  nAux := Mod(nSumDig,11) 

   IF nAux == 0
      return "0"
   else
       nAux := 11 - nAux
       If nAux == 10 
          return "P"
       Endif
   ENDIF
Return(Str(nAux,1))    

/*/{Protheus.doc} GeraQRCODE
   Gera qrcode pix copia/cola padrao Safra   
   @type  Static Function
   @author matheus.vinicius@integratvs.com
   @since 01/03/2023
/*/
Static Function GeraQRCODE(cRazSoc,aDadosBanco)
   Local cRet    := ""
   Local cRetHex := ""

   cRet += "000201010212"                    //textofixo
   cRet += "26750014br.gov.bcb.pix"          //textofixo
   cRet += "2553pix.bradesco.com.br/qr/c/cobv/" //textofixo
   cRet += "07"+Padl(aDadosBanco[3],5,"0")+strzero(val(aDadosBanco[4]),8)+aDadosBanco[5]
   cRet += aDadosTit[6]
   cRet += "252040000"                     //textofixo
   cRet += "5303986"                       //textofixo
   cRet += "5802BR"                        //textofixo
   cRet += "59"                            //textofixo
   cRet += "25"                            //tamanho razao social
   cRet += if(len(cRazSoc)>=25,left(cRazSoc,25),Padr(cRazSoc,25)) //razaosocial
   cRet += "6006MANAUS"                    //textofixo
   cRet += "62070503***"                   //textofixo
   cRet += "6304"                          //textofixo

   CRCCalc(6,cRet,@cRetHex)

   cRet += cRetHex

Return cRet
