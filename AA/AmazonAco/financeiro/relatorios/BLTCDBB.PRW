#INCLUDE "PROTHEUS.CH"
 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BLTCDBB()

LOCAL	aPergs     := {} 

PRIVATE cPrefixo   := ""
PRIVATE cNumero    := ""

PRIVATE lExec      := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

Tamanho  := "M"
titulo   := "BANCO DO BRASIL"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BLTCDBB"
lEnd     := .F.
cPerg    := PADR("BLTCDBB",Len(SX1->X1_GRUPO))
nTam     := TamSX3("E1_NUM")[1]
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

AjustaSx1(cPerg)

If Empty(cNumero)
    Pergunte(cPerg,.T.)
EndIf

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)                                                                          

cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+SE1->(xFilial())+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR01 + "'.And.E1_CLIENTE<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR03 + "'.And.E1_PREFIXO<='" + MV_PAR04 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR05 + "'.And.E1_NUM<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR07 + "'.And.E1_PARCELA<='" + MV_PAR08 + "'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par09)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par10)+"'.And."
cFilter		+= "E1_TIPO $ 'BOL,BO , NF '  .And." 
cFilter		+= "(ALLTRIM(E1_XCONTA) = '001' .OR. E1_XCONTA = '          ')" 

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

cMarca	:= GetMark()

DbSelectArea("SE1")
dbGoTop()

DEFINE MSDIALOG oDlg TITLE "Seleção de Titulos" FROM 00,00 TO 400,700 PIXEL

oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

oMark:oBrowse:Refresh()
oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .F.

DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif

DbSelectArea("SE1")
Set Filter to

RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

Static Function Marcar(cMarca,oSom)
   Local lOk := .T.

   If lOk
      RecLock("SE1",.F.)
      SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
      MsUnLock()
   Else
      Alert("Município inválido ("+AllTrim(SA1->A1_MUN)+") para impressão desse boleto !")
   Endif

Return

/*/
 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado

Local aBolText := { MV_PAR19,MV_PAR20,MV_PAR21 }					   

LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:Setup()
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

DbSelectArea("SE1")
dbGotop()

ProcRegua(RecCount())

While SE1->(!EOF()) 

	IncProc()
	
    //Quando nao estiver selecionado despreza o registro
    If !Marked("E1_OK")
       DbSkip()
       Loop
    EndIf  

    IF  ALLTRIM(SE1->E1_PORTADO) <> ""
       If ALLTRIM(SE1->E1_PORTADO) # "001" .And. ALLTRIM(SE1->E1_PORTADO) # "000"
          DbSkip()
          Loop
       EndIf 
	EndIf
	
	//Informaç?es de Agencia e Conta para posicionar corretamente no SA6
	cBanco 	:= "001"
    cAgencia := "18562"
    cConta   := "19454-9"
          
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))
	SA6->(DbSeek(xFilial("SA6")+cBanco+PadR(cAgencia,05)+PadR(cConta,10),.T.))
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

	// Calcula o total de parcelas geradas para o titulo
	cQuery := "SELECT MAX(E1_PARCELA)E1_PARCELA FROM "+RetSQLName("SE1")+" WHERE D_E_L_E_T_=' ' AND E1_FILIAL='"
	cQuery += SE1->(XFILIAL())+"' AND E1_NUM='"+SE1->E1_NUM+"' AND E1_PREFIXO='"+SE1->E1_PREFIXO+"' AND E1_CLIENTE='"
	cQuery += SE1->E1_CLIENTE+"' AND E1_LOJA='"+SE1->E1_LOJA+"'"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
	cMaxPar := E1_PARCELA
	dbCloseArea()
	dbSelectArea("SE1")

	
	DbSelectArea("SE1")
	aDadosBanco  := {SA6->A6_COD,; 													   // [1]Numero do Banco
				     SA6->A6_NREDUZ,;  												   // [2]Nome do Banco
	                 SUBSTR(SA6->A6_AGENCIA, 1, 4)+"-"+SUBSTR(SA6->A6_AGENCIA, 5, 5),; // [3]Agência
                     SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-2),; 	       // [4]Conta Corrente
                     SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,;    	   // [5]Dígito da conta corrente
					"1194966",;                                                       // [6]Codigo do Convênio
					 SA6->A6_NUMBCO,;                                                  // [7] 
					 "17"}												               // [8]Codigo da Carteira



				If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
					aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;     // [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
					AllTrim(SA1->A1_END )                            ,;     // [3]Endereço
					AllTrim(SA1->A1_MUN )                            ,;     // [4]Cidade
					SA1->A1_EST                                      ,;     // [5]Estado
					SA1->A1_CEP                                      ,;     // [6]CEP
					SA1->A1_CGC									     ,;     // [7]CGC
					" "           									 ,;     // [8]PESSOA
					AllTrim(SA1->A1_BAIRRO)                           }     // [9]Bairro   
				 Else
					aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;    	// [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;    	// [2]Código
					AllTrim(SA1->A1_ENDCOB)                          ,;    	// [3]Endereço
					AllTrim(SA1->A1_MUNC)	                         ,;    	// [4]Cidade
					SA1->A1_ESTC	                                 ,;    	// [5]Estado
					SA1->A1_CEPC                                     ,;    	// [6]CEP
					SA1->A1_CGC								         ,;		// [7]CGC
					" "           								     ,;    	// [8]PESSOA
					AllTrim(SA1->A1_BAIRROC)                         }      // [9]Bairro   
				 Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
	//Abaixo apenas uma sugestao
	cNroDoc := Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
	cNroDoc := STRZERO(Val(cNroDoc),11)

	//Monta codigo de barras
	aCB_RN_NN := Ret_cBarra( SE1->E1_PREFIXO ,;  //cPrefixo 
							 SE1->E1_NUM     ,;  //cNumero
							 SE1->E1_PARCELA ,;  //cParcela
							 SE1->E1_TIPO    ,;  //cTipo
							 Subs(aDadosBanco[1],1,3),;//cBanco
							 aDadosBanco[3],;    //cAgencia
							 aDadosBanco[4],;    //cConta
							 aDadosBanco[5],;    //cDacCC
							 aDadosBanco[7],;	 //cNumBco
							 cNroDoc       ,;    //cNroDoc 
							(SE1->E1_VALOR-(nVlrAbat+SE1->E1_DECRESC)),; //nValor
							 aDadosBanco[6],;    //cCart
							  "9")               //cMoeda
	
	DbSelectArea("SE1")
	aDadosTit := {E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
						If(Empty(cMaxPar),"","/"+cMaxPar)  		,;  // [1] Número do título
						E1_EMISSAO                         		,;  // [2] Data da emissão do título
						dDataBase                          		,;  // [3] Data da emissão do boleto
						E1_VENCTO                          		,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)              		,;  // [5] Valor do título
						aCB_RN_NN[3]                       		,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                         		,;  // [7] Prefixo da NF
						"DM"                               		,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
						E1_DECRESC								}  // [9] Decrescimo

	  aBolText    := {"","","",""}
      aBolText[1] := "APÓS VENCIMENTO MORA DIA DE R$ " + Alltrim(Transform((GETMV("MV_XJURIT") * (E1_SALDO - nVlrAbat)/100),"@E 99,999,999.99"))
      aBolText[2] := "MULTA DE "+Alltrim(str(GETMV("MV_XMULBOL")))+"% APÓS O VENCIMENTO"
      aBolText[3] := "SUJEITO A PROTESTO SE NÃO FOR PAGO NO VENCIMENTO"
      aBolText[4] := "FAVOR EFETUAR O PAGAMENTO SOMENTE ATRAVÉS DESTA COBRANÇA BANCÁRIA"

	DbSelectArea("SE1")
	If Marked("E1_OK")
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1
	EndIf
	dbSkip()

	nI++
	
EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil
 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont7
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp := 030
Local cLogo:= 030

cBmp := cStartPath + "ITAU.BMP" //Logo do Banco Itau   
cLogo := cStartPath + "LogoAA.BMP" //Logo da Amazon Aço   


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
 
oPrint:Line (nRow1+0150, 100,nRow1+0150,2300)
oPrint:Line (nRow1+0080,1060,nRow1+0150,1060)
oPrint:Line (nRow1+0080,1250,nRow1+0150,1250)

If File(cBmp)
   //oPrint:SayBitmap(nRow1+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow1+0080, 180,"Banco do Brasil "  ,oFont14 )  // [2]Nome do Banco
oPrint:Say  (nRow1+0075,1073,aDadosBanco[1]+"-9",oFont18 )  // [1]Numero do Banco
oPrint:Say  (nRow1+0080,1820,"Recibo do Pagador" ,oFont11 )

oPrint:Line (nRow1+0250,100,nRow1+0250,2300 )
oPrint:Line (nRow1+0350,100,nRow1+0350,2300 )
oPrint:Line (nRow1+0420,100,nRow1+0420,2300 )
oPrint:Line (nRow1+0490,100,nRow1+0490,2300 )

oPrint:Line (nRow1+0350,500 ,nRow1+0490,500 )
oPrint:Line (nRow1+0420,750 ,nRow1+0490,750 )
oPrint:Line (nRow1+0350,1000,nRow1+0490,1000)
oPrint:Line (nRow1+0350,1300,nRow1+0420,1300)
oPrint:Line (nRow1+0350,1480,nRow1+0490,1480)

oPrint:Say  (nRow1+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow1+0190,100 ,"Pagável em qualquer Banco.",oFont9)
           
oPrint:Say  (nRow1+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0250,100 ,"Beneficiário",oFont8n)
oPrint:Say  (nRow1+0290,100 ,Alltrim(aDadosEmp[1]) +",  "+ Alltrim(aDadosEmp[2]) +" - "+ aDadosEmp[4] ,oFont8) //Nome + CNPJ

oPrint:Say  (nRow1+0250,1305,"CNPJ"                                   ,oFont8n)
oPrint:Say  (nRow1+0290,1305,aDadosEmp[6]                             ,oFont9) //CNPJ

oPrint:Say  (nRow1+0250,1810,"Agencia / Código Cedente",oFont8n)
cString := Alltrim(Trim(aDadosBanco[3])+"/"+ Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0290,nCol,PADL(cString,17) ,oFont11c)

oPrint:Say  (nRow1+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow1+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow1+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow1+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow1+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow1+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow1+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow1+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow1+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow1+0350,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 99999999999999999")
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0380,nCol,PADL(cString,19),oFont11c)

oPrint:Say  (nRow1+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow1+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow1+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow1+0450,555 ,aDadosBanco[8]                                 ,oFont10)

oPrint:Say  (nRow1+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow1+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow1+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow1+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow1+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow1+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow1+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow1+0690,100 ,aBolText[3]  ,oFont10)
//oPrint:Say  (nRow1+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow1+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830 //1810+(374-(len(cString)*22))
oPrint:Say  (nRow1+0520,nCol,PADL(cString,17) ,oFont11c)

//oPrint:Say  (nRow1+0560,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Say  (nRow1+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow1+0700,1810,"(+)Outros Acréscimos"                        ,oFont8n)
oPrint:Say  (nRow1+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Line (nRow1+0150,1800,nRow1+1790,1800 )//LINHA LATERAL
oPrint:Line (nRow1+0560,1800,nRow1+0560,2300 )
oPrint:Line (nRow1+0630,1800,nRow1+0630,2300 )
oPrint:Line (nRow1+0700,1800,nRow1+0700,2300 )
oPrint:Line (nRow1+0770,1800,nRow1+0770,2300 )
oPrint:Line (nRow1+0840,100 ,nRow1+0840,2300 )


If File(cLogo)
  //              altT   largT      largI  altI
  oPrint:SayBitmap(1000,  350, cLogo, 1000, 600)
Endif

nRow2 := nRow1 + 0950
oPrint:Say  (nRow2+0840,100 ,"Pagador"                                     ,oFont8n)
oPrint:Say  (nRow2+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow2+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow2+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow2+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow2+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow2+1030,1620,"Autenticação Mecânica"                       ,oFont8n)
  
//oPrint:Line (nRow2+0150,1800,nRow2+0840,1800 )
//oPrint:Line (nRow2+0560,1800,nRow2+0560,2300 )
//oPrint:Line (nRow2+0630,1800,nRow2+0630,2300 )
//oPrint:Line (nRow2+0700,1800,nRow2+0700,2300 )
//oPrint:Line (nRow2+0770,1800,nRow2+0770,2300 )
oPrint:Line (nRow2+0840,100 ,nRow2+0840,2300 )

oPrint:Line (nRow2+1025,100 ,nRow2+1025,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow2 + 1125

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0030, nI, nRow3+0030, nI+30)
Next nI

oPrint:Line (nRow3+0150, 100,nRow3+0150,2300)
oPrint:Line (nRow3+0080, 660,nRow3+0150, 660)
oPrint:Line (nRow3+0080, 850,nRow3+0150, 850)

If File(cBmp)
   // oPrint:SayBitmap(nRow3+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow3+0080,180,"Banco do Brasil" ,oFont14 )  // [2]Nome do Banco

oPrint:Say  (nRow3+0075, 673,aDadosBanco[1]+"-9",oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow3+0084, 890,aCB_RN_NN[2]       ,oFont14)    // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)

oPrint:Say  (nRow3+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow3+0190,100 ,"Pagável em qualquer Banco.",oFont9)
           
oPrint:Say  (nRow3+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0250,100 ,"Beneficiário",oFont8n)
//oPrint:Say  (nRow3+0290,100 ,Alltrim(aDadosEmp[1]) +"  -  "+ aDadosEmp[4] ,oFont10) //Nome + CNPJ
oPrint:Say  (nRow3+0290,100 ,Alltrim(aDadosEmp[1]) +",  "+ Alltrim(aDadosEmp[2]) +" - "+ aDadosEmp[4] ,oFont8) //Nome + CNPJ

//oPrint:Say  (nRow1+0290,100 ,Alltrim(aDadosEmp[1]) +","+ Alltrim(aDadosEmp[2]) +" - "+ aDadosEmp[4] ,oFont8) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1305,"CNPJ"                                    ,oFont8n)
oPrint:Say  (nRow3+0290,1305,aDadosEmp[6]                              ,oFont9) //CNPJ

oPrint:Say  (nRow3+0250,1810,"Agência / Código Cedente",oFont8n)
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
cString := Alltrim(Trim(aDadosBanco[3])+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 99999999999999999")
nCol    := 1830  //1880+(374-(len(cString)*22))
oPrint:Say  (nRow3+0380,nCol,PADL(cString,19),oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow3+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow3+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,555 ,aDadosBanco[8]                                 ,oFont10)

oPrint:Say  (nRow3+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow3+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830   //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow3+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow3+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow3+0690,100 ,aBolText[3]  ,oFont10)
//oPrint:Say  (nRow3+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0520,nCol,PADL(cString,17),oFont11c)

//oPrint:Say  (nRow3+0560,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow3+0700,1810,"(+)Outros Acréscimos"                        ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say  (nRow3+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow3+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow3+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow3+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow3+0985,1850,"Código de Baixa:"  ,oFont9)

oPrint:Say  (nRow3+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow3+1030,1620,"Autenticação Mecânica "  ,oFont8n)
oPrint:Say  (nRow3+1030,1900,"Ficha de Compensação "  ,oFont8)

oPrint:Line (nRow3+0150,1800,nRow3+0840,1800 )
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1025,100 ,nRow3+1025,2300 )

MSBAR2("INT25",26.1,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.7,Nil,Nil,"A",.F.,100,100)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a página

Return Nil

 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)
 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)
 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,cDacCC,cNumBco,cNroDoc,nValor,cCart,cMoeda)

Local cNosso	  := ""
Local cDigNosso   := ""
Local cCampoL	  := ""
Local cFatorValor := ""
Local cLivre	  := ""
Local cDigBarra   := ""
Local cBarra	  := ""
Local cParte1	  := ""
Local cDig1		  := ""
Local cParte2	  := ""
Local cDig2		  := ""
Local cParte3	  := ""
Local cDig3		  := ""
Local cParte4	  := ""
Local cParte5	  := ""
Local cDigital	  := ""
Local aRet		  := {}
Local nDvNs       := 0

cAgencia := Left(Alltrim(cAgencia),4)
// Nosso Numero
If Empty(SE1->E1_NUMBCO)
   cNosso := cCart +Alltrim(_NossoNum())
   nDvNs  := Modulo10(cAgencia + cConta +cNosso)
   cNosso += Alltrim(Str(nDvNs))
Else
   cNosso := AllTrim(SE1->E1_NUMBCO)
Endif

// Campo livre do codigo de barra    // verificar a conta
If nValor <= 0
   nValor := SE1->E1_VALOR
Endif
cFatorValor := Fator(SE1->E1_VENCTO) + StrZero(nValor * 100,10)
//        //1 até a 4//Fator e Valor// 
cLivre := cBanco+cMoeda+cFatorValor+"000000"+cNosso+"17"

// campo do codigo de barra
cDigBarra := Modulo11(cLivre)//CALC_5p( cLivre )
cBarra    := SubStr(cLivre,1,4)+Alltrim(Str(cDigBarra))+SubStr(cLivre,5,39)

// composicao da linha digitavel
cParte1  := SubStr(cBarra,1,4) + SubStr(cBarra,20,5)  //cBanco + cMoeda + SubStr(cCampoL,1,5)
cDig1    := Modulo10( cParte1 )
cParte2  := SubStr(cBarra,25,10) //SUBSTR(cCampoL,6,10)
cDig2    := Modulo10( cParte2 )
cParte3  := SubStr(cBarra,35,10)//SUBSTR(cCampoL,16,10)
cDig3    := Modulo10( cParte3 )
cParte4  := Alltrim(Str(cDigBarra))
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cParte1,6,4)+Alltrim(Str(cDig1))+" "+;
			substr(cParte2,1,5)+"."+substr(cParte2,6,5)+Alltrim(str(cDig2))+" "+;
			substr(cParte3,1,5)+"."+substr(cParte3,6,5)+Alltrim(str(cDig3))+" "+;
			cParte4+" "+;
			cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)

DbSelectArea("SE1")
RecLock("SE1",.F.)
SE1->E1_NUMBCO := cNosso   // Nosso número  
SE1->E1_PORCJUR := GETMV("MV_XJURIT")
SE1->E1_XCONTA := "001"
MsUnlock()

Return aRet
 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function AjustaSx1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Do Cliente'          , '', '', 'mv_ch1', 'C', 6, 0, 0, 'G', '',   'SA1',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Cliente'         , '', '', 'mv_ch2', 'C', 6, 0, 0, 'G', '',   'SA1',  '', '', 'mv_par02')
	U_PIPutSx1(cPerg, '03', 'De Prefixo'          , '', '', 'mv_ch3', 'C', 3, 0, 0, 'G', '',      '',  '', '', 'mv_par03')
	U_PIPutSx1(cPerg, '04', 'Ate Prefixo'         , '', '', 'mv_ch4', 'C', 3, 0, 0, 'G', '',      '',  '', '', 'mv_par04')
	U_PIPutSx1(cPerg, '05', 'Do Numero'           , '', '', 'mv_ch5', 'C', 9, 0, 0, 'G', '',      '',  '', '', 'mv_par05')
	U_PIPutSx1(cPerg, '06', 'Até Numero'          , '', '', 'mv_ch6', 'C', 9, 0, 0, 'G', '',      '',  '', '', 'mv_par06')
	U_PIPutSx1(cPerg, '07', 'Da Parcela'          , '', '', 'mv_ch7', 'C', 1, 0, 0, 'G', '',      '',  '', '', 'mv_par07')
	U_PIPutSx1(cPerg, '08', 'Até Parcela'         , '', '', 'mv_ch8', 'C', 1, 0, 0, 'G', '',      '',  '', '', 'mv_par08')
	U_PIPutSx1(cPerg, '09', 'Da Emissao'          , '', '', 'mv_ch8', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par09')
	U_PIPutSx1(cPerg, '10', 'Ate Emissao'         , '', '', 'mv_ch9', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par10')
	    
Return

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function _NossoNum()

Local cNumero := ""
Local nTam := TamSx3("EE_FAXATU")[1]

// Enquanto nao conseguir criar o semaforo, indica que outro usuario
// esta tentando gerar o nosso numero.
cNumero := StrZero(Val(SEE->EE_FAXATU),9)

//While !MayIUseCode( SEE->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA))  //verifica se esta na memoria, sendo usado
While !MayIUseCode( cNumero )  //verifica se esta na memoria, sendo usado
	cNumero := Soma1(cNumero)										// busca o proximo numero disponivel 
EndDo

If Empty(SE1->E1_NUMBCO)
	
	RecLock("SE1",.F.)
	Replace SE1->E1_NUMBCO With cNumero
	SE1->( MsUnlock( ) )
	
	RecLock("SEE",.F.)
	Replace SEE->EE_FAXATU With Soma1(cNumero, nTam)
	SEE->( MsUnlock() )
	
EndIf	

Leave1Code(SEE->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA))
DbSelectArea("SE1")

Return(SE1->E1_NUMBCO)
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  BLTCDBB   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/10/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS                               ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function Fator(dVencto)
	Local cData  := DTOS(dVencto)
	Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
 Return(cFator)
