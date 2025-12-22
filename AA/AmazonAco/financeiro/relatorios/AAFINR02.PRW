#INCLUDE "PROTHEUS.CH"  
#INCLUDE "RWMAKE.CH" 

 /*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  FINR004   ¦ Autor ¦        ¦ Data ¦ 21/08/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS - SANTANDER                              ¦¦¦
¦¦¦ Versão    ¦ IMPRESSAO DOS BOLETOS BANCÁRIOS -  Para o faturamento         ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINR02()

LOCAL	aPergs := {} 
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

Tamanho  := "M"
titulo   := "Boleto do Banco Real"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "FINR04"
lEnd     := .F.
cPerg     :="FINR02"
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

AjustaSx1(cPerg)//(cPerg,aPergs)

Pergunte (cPerg,.T.)

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
cFilter		+= "(ALLTRIM(E1_XCONTA) = '033' .OR. E1_XCONTA = '          ')" 

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

RecLock("SE1",.F.)
SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
MsUnLock()

Return
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  FNFINR04  ¦ Autor ¦        ¦ Data ¦ 08/01/2003 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaRel()
LOCAL oPrint, cMaxPar, cQuery, cDocumen, dDataIni
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")                            ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText := {"", "", ""}

LOCAL aCB_RN_NN    := {}
LOCAL aCB_RN_NM    := {}
LOCAL nVlrAbat     := 0
Local cBanco :=Padr(GetMv("MV_XBANCO"),03) //033
Local cAgenc :=Padr(GetMv("MV_XAGENC"),05) //4411  sem o traço
Local cConta :=Padr(GetMv("MV_XCONTA"),11) //13000221-7 sem o zero

Private cNroDoc :=  " "
Private aDadosTit
oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

dbGoTop()
ProcRegua(RecCount())
While !EOF()
	dDataIni := mv_par11
	cDocumen := E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA
	While !EOF() .And. cDocumen == E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA

		IncProc()

		If E1_OK <> cMarca //Marked("E1_OK")
			dbSkip()
			Loop
		Endif

		cMaxPar := ""
      
		//Posiciona o SA6 (Bancos)
		dbSelectArea("SA6")
		SA6->(DbSetOrder(1))
		SA6->(DbSeek(xFilial("SA6")+cBanco+cAgenc+SUBSTRING(cConta,1,8),.T.))  
		//SA6->(DbSeek(xFilial("SA6")+cBanco+cAgenc+cConta,.T.))
      
		//Posiciona na Arq de Parametros CNAB
        //Posiciona o SA1 (Cliente)
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.))
	
		DbSelectArea("SE1")
		aDadosBanco := {    SA6->A6_COD,;											// [1]Codigo do Banco
							SA6->A6_NREDUZ,;										// [2]Nome do Banco
							Strzero(Val(SUBSTR(SA6->A6_AGENCIA, 1, 5)), 4),;		// [3]Agência
							Strzero(Val(SUBSTR(SA6->A6_NUMCON,2,9)), 7),;			// [4]Conta Corrente
							SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;	// [5]Dígito da conta corrente
							"101 - RÁPIDA COM REGISTRO",;				            // [6]Codigo da Carteira
							SA6->A6_NUMBCO}											// [7]Numero do Banco
                      
		If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]Código
			AllTrim(SA1->A1_END )                            ,;        // [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;        // [4]Cidade
			SA1->A1_EST                                      ,;        // [5]Estado
			SA1->A1_CEP                                      ,;        // [6]CEP
			SA1->A1_CGC									  	 ,;        // [7]CGC
			" "           									 ,;        // [8]PESSOA
			AllTrim(SA1->A1_BAIRRO)                          ,;        // [9]Bairro
			Alltrim(SA1->A1_EMAIL)                            }        // [10]EMAIL   
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;    	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;    	// [2]Código
			AllTrim(SA1->A1_ENDCOB)                          ,;    	// [3]Endereço
			AllTrim(SA1->A1_MUNC)	                         ,;    	// [4]Cidade
			SA1->A1_ESTC	                                 ,;    	// [5]Estado
			SA1->A1_CEPC                                     ,;    	// [6]CEP
			SA1->A1_CGC								         ,;		// [7]CGC
			" "           								     ,;    	// [8]PESSOA
			AllTrim(SA1->A1_BAIRROC)                         ,;     // [9]Bairro 
			Alltrim(SA1->A1_EMAIL)                           }      // [10]EMAIL  
		Endif

		nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

      	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
      	//Abaixo apenas uma sugestao
		cNroDoc := Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
		cNroDoc := STRZERO(Val(cNroDoc),11)

		aCB_RN_NN := FNGERCDBAR(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cBanco,SUBSTR(SA6->A6_AGENCIA,1,5),;
										SUBSTR(SA6->A6_NUMCON,2,9),SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;
										cBanco,cNroDoc,(SE1->E1_VALOR-(nVlrAbat+SE1->E1_DECRESC)),;
										"101", "9")

		aCB_RN_NM := Ret_cBarra(aCB_RN_NN[1],aCB_RN_NN[2],aCB_RN_NN[3])

      
		aDadosTit := {E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
							If(Empty(cMaxPar),"","/"+cMaxPar)  ,;  // [1] Número do título
							E1_EMISSAO                         ,;  // [2] Data da emissão do título
							dDataBase                          ,;  // [3] Data da emissão do boleto
							E1_VENCREA                         ,;  // [4] Data do vencimento
							(E1_VALOR-nVlrAbat) 			   ,;  // [5] Valor do título
							aCB_RN_NM[3]                       ,;  // [6] Nosso número (Ver fórmula para calculo)
							E1_PREFIXO                         ,;  // [7] Prefixo da NF
							E1_TIPO                            ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
							E1_DECRESC									}  // [9] Decrescimo
                    									
		
	  nMora := (aDadosTit[5]*0.10)
	  nMora := Round(nMora,2)

      aBolText    := {" " ,"","","",""}
       
      
      aBolText[1] := "APÓS VENCIMENTO MORA DIA DE R$ " + Alltrim(Transform((GETMV("MV_XJURST") * (E1_SALDO - nVlrAbat)/100),"@E 99,999,999.99"))
      aBolText[2] := "SUJEITO A PROTESTO SE NÃO FOR PAGO NO VENCIMENTO"
      aBolText[3] := "FAVOR EFETUAR O PAGAMENTO SOMENTE ATRAVÉS DESTA COBRANÇA BANCÁRIA"
      aBolText[4] := ""
      
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NM,aCB_RN_NN[4])
      
		dbSkip()
      
	Enddo
EndDo

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  FNFINR04  ¦ Autor ¦        ¦ Data ¦ 08/01/2003 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NM,cDigitao)
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
Local cBmp := "030"

cBmp := cStartPath + "santander.bmp" //Logo do Santander

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
oFont13  := TFont():New("Arial"      ,9,13,.T.,.T.,5,.T.,5,.T.,.F.)
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

nRow1 := -30
 
oPrint:Line (nRow1+0150, 100,nRow1+0150,2300)
oPrint:Line (nRow1+0080,1060,nRow1+0150,1060)
oPrint:Line (nRow1+0080,1250,nRow1+0150,1250)

If File(cBmp)
	oPrint:SayBitmap(nRow1+50,100,cBmp,300,100) 
EndIf

oPrint:Say(nRow1+0075,1073,aDadosBanco[1]+"-7",oFont18 )  // [1]Numero do Banco
oPrint:Say(nRow1+0080,1820,"Recibo do Sacado" ,oFont11 )

oPrint:Line (nRow1+0250,100,nRow1+0250,2300 )
oPrint:Line (nRow1+0350,100,nRow1+0350,2300 )
oPrint:Line (nRow1+0450,100,nRow1+0450,2300 )

oPrint:Line (nRow1+0350,960 ,nRow1+0450,960 )//COLUNA AO LADO DO "Nº do Documento"
oPrint:Line (nRow1+0350,1415,nRow1+0450,1415 )//COLUNA AO LADO DO "Nosso Número"

oPrint:Say  (nRow1+0250,100 ,"Cedente",oFont8n)
oPrint:Say  (nRow1+0290,100 ,aDadosEmp[1] + " - " + aDadosEmp[6],oFont10) //Nome + CNPJ

oPrint:Say  (nRow1+0250,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830
oPrint:Say  (nRow1+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0350,100 ,"Sacado", oFont8n)
oPrint:Say  (nRow1+0410,100 ,aDatSacado[1]  								,oFont9 )

oPrint:Say  (nRow1+0350,975 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow1+0410,1075 ,aDadosTit[7]+aDadosTit[1]                     ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0350,1430,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 999999999999999")
nCol    := 1460
oPrint:Say  (nRow1+0410,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+350,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830 
oPrint:Say  (nRow1+0410,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0460,100 ,"Instruções (termo de responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow1+0560,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow1+0610,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow1+0660,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow1+0710,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow1+1030,1620,"Autenticação Mecânica"                       ,oFont8n)

oPrint:Line (nRow1+0250,1800,nRow1+450,1800 )//COLUNA DO VENCIMENTO / VALOR DO DOCUMENTO

oPrint:Line (nRow1+1025,100 ,nRow1+1025,2300 )//PRIMEIRA LINHA DO RODAPÉ
oPrint:Line (nRow1+1190,100 ,nRow1+1190,2300 )//SEGUNDO LINHA DO RODAPÉ

vMens    := Array(4)
vMens[1] := "Recebimento através do cheque n.                                             do banco"
vMens[2] := "Esta quitação só terá validade após o pagamento do cheque"
vMens[3] := "pelo banco sacado:"

oPrint:Say  (nRow1+1030,100 , vMens[1]                                     ,oFont8n)
oPrint:Say  (nRow1+1060,100 , vMens[2]                                     ,oFont8n)
oPrint:Say  (nRow1+1090,100 , vMens[3]                                     ,oFont8n)

oPrint:Say  (nRow1+1140, 100,"Sacador/Avalista:"                           ,oFont10)
oPrint:Say  (nRow1+1140, 1500,"CNPJ:"          			                   ,oFont10)

/*****************/
/* SEGUNDA PARTE */
/*****************/
  /*Removido para atender o layout do boleto do banco*/

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow1 + 1300
For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0010, nI, nRow3+0010, nI+30)
Next nI

oPrint:Line(nRow3+0140, 100,nRow3+0140,2300)// LINHA 1
oPrint:Line(nRow3+0080, 660,nRow3+0140, 660)//COLUNA 1
oPrint:Line(nRow3+0080, 850,nRow3+0140, 850)//COLUNA 2

nRow3 -= 25
If File(cBmp)
	oPrint:SayBitmap(nRow3+65,100,cBmp,300,100) 
Endif

oPrint:Say(nRow3+100, 690,aDadosBanco[1]+"-7",oFont18 )   // [1]Numero do Banco
oPrint:Say(nRow3+109, 890,aCB_RN_NM[2]       ,oFont14)    // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0420,500 )
//oPrint:Line (nRow3+0350,750 ,nRow3+0490,750 )// BARRA DO NUMERO DO DOCUMENTO
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)

oPrint:Say  (nRow3+0170,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow3+0210,100 ,"Pagar preferencialmente no Grupo Santander - GC",oFont9)
           
oPrint:Say  (nRow3+0170,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830
oPrint:Say  (nRow3+0210,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0250,100 ,"Cedente",oFont8n)
oPrint:Say  (nRow3+0290,100 ,aDadosEmp[1] +" - " + aDadosEmp[6]  ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1810,"Agência / Código Cedente",oFont8n)
cString := Alltrim(aDadosBanco[3]+"/"+"4876725")//codigo de identificacao do banco
nCol    := 1830
oPrint:Say  (nRow3+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,530 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow3+0380,1050,"DM"                                            ,oFont10) //Tipo do Titulo
//oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R  999999999999-9")
nCol    := 1830
oPrint:Say  (nRow3+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,100 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow3+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow3+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830   //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instruções (termo de responsabilidade do cedente)",oFont8n)
oPrint:Say  (nRow3+0560,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow3+0610,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow3+0660,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow3+0710,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830 
oPrint:Say  (nRow3+0520,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say  (nRow3+0840,230 ,aDatSacado[1]								   ,oFont9 )
oPrint:Say  (nRow3+0840,1770,""							                   ,oFont9 )

oPrint:Say  (nRow3+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow3+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow3+0985,1800,"CNPJ/CPF - "+aDatSacado[7]  ,oFont9)

oPrint:Say  (nRow3+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow3+1030,1800,"Autenticação Mecânica/Ficha de Compensação"  ,oFont8n)   
oPrint:Say  (nRow3+1240,1890,"Recibo do Sacado" ,oFont11 )

oPrint:Line (nRow3+0170,1800,nRow3+0840,1800 )
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1025,100 ,nRow3+1025,2300 )
              
MSBAR2("INT25",19.7,1,aCB_RN_NM[1],oPrint,.F.,Nil,Nil,0.030,1.6,Nil,Nil,"A",.F.,100,100)
DbSelectArea("SE1")
RecLock("SE1",.F.)
//JEAN SE1->E1_IMPBLT  := "S"			//CARACTER DE 1                              
//SE1->E1_CODBAR  :=aCB_RN_NM[1]  //CARACTER DE 44
//SE1->E1_CODDIG  :=aCB_RN_NM[2]  //CARACTER DE 48
SE1->E1_NUMBCO  :=aCB_RN_NM[3]  //CARACTER DE 15   
SE1->E1_XCONTA := "033"
//JEAN SE1->E1_VALJUR := IIf (Empty(SE1->E1_VALJUR),aDadosTit[5]*GetMv("MV_BLTJUR")/30,0)
MsUnlock()

oPrint:EndPage() // Finaliza a página

Return Nil
//===========================================================================================================
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RetDados  ¦ Autor ¦                      ¦ Data ¦ 08/01/2003 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS - Retorno      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Ret_cBarra(cBarra,cDigital,cNosso)

Local cParte1     := cDigital
Local cLdigital	  := ""
Local aRet		  := {}
//FORMATA A LINHA DIGITÁVEL
cLdigital := substr(cParte1,1,5)+"."+substr(cParte1,6,5)+" "+;
			substr(cParte1,11,5)+"."+substr(cParte1,16,6)+" "+;
			substr(cParte1,22,5)+"."+substr(cParte1,27,6)+" "+;
			substr(cParte1,33,1)+" "+substr(cParte1,34,14)						
			//cParte5

Aadd(aRet,cBarra)                                       	
Aadd(aRet,cLdigital)
Aadd(aRet,cNosso)

Return aRet
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ FNGERCDBAR ¦ Autor ¦                      ¦ Data ¦ 08/05/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Função para Montar o Codigo de Barras que será gravado no Titu-¦¦
¦¦¦           ¦ lo no Contas a Receber.                                        ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 
//Informações do Titulo -Prefixo ,Numero ,Parcela ,Tipo ,Banco ,Agencia ,Conta, Dig.Conta,Banco,Nro.Doc,Valor ,Carteira,Moeda
Static Function FNGERCDBAR(cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,cDacCC,cNumBco,cNroDoc,nValor,cCart,cMoeda)

Local cNosso	  := ""
Local cNossoDigito:= ""
Local cDigitao    := ""
Local cCampoL	  := ""
Local cFatorValor := ""
Local cLivre	  := ""
Local cDigBarra	  := ""
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo do digitao de cobranca  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Nosso Numero
If Empty(SE1->E1_NUMBCO)
   dbSelectarea("SEE")
   cNosso := strzero(Val(_NossoNum()),12)   //strzero(AllTrim(Str(Val(NossoNum()),11)),11)
   cNossoDigito += Modulo11(cNosso,"NN")     
   cNosso += AllTrim(cNossoDigito)
Else
   cNosso := AllTrim(SE1->E1_NUMBCO)
Endif


cAgencia := Substr(AllTrim(cAgencia),2,4)       // 4 Posicoes
cConta   := Right(AllTrim(cConta),7)            // 7 posicoes
cDigitao := Alltrim(Modulo11(cNosso+cAgencia+cConta, "CODBAR"))
cIdentificacao := "4876725"

If nValor <= 0
	nValor := SE1->E1_VALOR
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo do digitao do codigo de barras  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         

cFatorValor := Fator(SE1->E1_VENCREA) + StrZero(nValor * 100,10)
cLivre      := cBanco+cMoeda+cFatorValor+"9"+cIdentificacao+cNosso+"0"+cCart
cDigBarra   := Modulo11(Alltrim(cLivre),"CODBAR")                                             
cBarra      := SubStr(cLivre,1,4)+AllTrim(cDigBarra)+SubStr(cLivre,5,39)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Linha digitavel                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cParte1  := cBanco + cMoeda + "9" + Substr(AllTrim(cIdentificacao),1,4)//- 09 posicoes
cDig1    := Modulo10(cParte1)

cParte2  := Substr(AllTrim(cIdentificacao),5,3)+SubStr(cNosso,1,7) //- 10 posicoes
cDig2    := Modulo10(cParte2)

cParte3  := SubStr(cNosso,8,6)+"0"+cCart //- 10 posicoes
cDig3    := Modulo10(cParte3)

cParte4  := Alltrim(cDigBarra) //- 01 posicao

cParte5  := cFatorValor //- 10 posicoes

cDigital := cParte1+cDig1+cParte2+cDig2+cParte3+cDig3+cParte4+cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)
Aadd(aRet,cDigitao)

Return aRet
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ Módulo10   ¦ Autor ¦                      ¦ Data ¦ 08/05/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Calculo do Digito verficador do Nosso Numero                   ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 
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
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ Fator      ¦ Autor ¦                      ¦ Data ¦ 08/05/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Função para calculo do fator de vencimento.                    ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 
Static function Fator(dVencto)
Local cData  := DTOS(dVencto)
Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)

Return(cFator)
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ DIGIT001   ¦ Autor ¦        ¦ Data ¦ 08/05/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Para calculo da linha digitavel do Itaú.                       ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 
Static Function DIGIT001(cVariavel)
Local cBase, nUmDois, nSumDig, nDig, nAux, cValor

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
//nDezena := Val(AllTrim(Str(Val(SubStr(cValor,1,1))+1,12))+"0")
//nAux    := nDezena - nSumDig

If nAux == 10
	nAux := 0
EndIf

Return(Str(nAux,1))
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ Modulo11   ¦ Autor ¦        ¦ Data ¦ 08/05/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Para calculo do código de barras                               ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  
Static Function Modulo11(nTemp11, _cTp)

Local cResult := ""
Local nValor := 0
Local nFator := 2
Local nPos    := Len(nTemp11)
Local nCont   := 0   


For nCont:=1 to nPos
nValor += val(substr(nTemp11,nPos,1))*nFator
nPos   := nPos -1
nFator := nFator + 1
If nFator > 9
     nFator := 2
Else
    // nFator
Endif
Next nCont

nValor := nValor%11

If     _cTp == "NN"
     If nValor == 0 .OR. nValor == 1
          cResult = "0"
     ElseIf nValor == 10
          cResult = "1"          
     Else
          cResult = ALLTRIM(STR(11 - nValor))
     Endif
ElseIf _cTp == "CODBAR"
     If nValor == 0 .OR. nValor == 1 .OR. nValor == 10
          cResult = "1"
     Else
          cResult = ALLTRIM(STR(11 - nValor))
     Endif
Endif

Return(cResult)  
  
//============================================================================================================
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 06/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                  	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)//(cPerg, aPergs)

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

Static Function _NossoNum()

Local cNumero := ""
Local nTam := TamSx3("EE_FAXATU")[1]

// Enquanto nao conseguir criar o semaforo, indica que outro usuario
// esta tentando gerar o nosso numero.
cNumero := StrZero(Val(SEE->EE_FAXATU),nTam)

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