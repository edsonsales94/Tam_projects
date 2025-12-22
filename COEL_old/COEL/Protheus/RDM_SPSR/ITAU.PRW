#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLITAU ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SLZ00002
LOCAL   aCampos := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
					{"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCREA","Vencimento"}}
LOCAL   nOpc := 0
LOCAL   aMarked := {}
LOCAL   aDesc := {"Este programa imprime os boletos de","cobranca bancaria de acordo com","os parametros informados"}
PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
PRIVATE cPerg		:= "BOLLSR"

dbSelectArea("SE1")
ValidPerg()
Pergunte (cPerg,.F.)
nOpc := FSTelaProc("Impressao do Boleto Laser",aDesc,cPerg)

If nOpc == 1

	cIndexName := Criatrab(Nil,.F.)
    cIndexKey  := 	"E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cFilter    := 	"E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ;
					"E1_NUM     >= '" + MV_PAR03 + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. " + ;
					"E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. " + ;
					"E1_PORTADO >= '" + MV_PAR07 + "' .And. E1_PORTADO <= '" + MV_PAR08 + "' .And. " + ;
					"E1_CLIENTE >= '" + MV_PAR09 + "' .And. E1_CLIENTE <= '" + MV_PAR10 + "' .And. " + ;
					"E1_EMISSAO >= CTOD('" + DTOC(MV_PAR15) + "') .And. E1_EMISSAO <= CTOD('" + DTOC(MV_PAR16) + "') .And. " + ;
					"E1_VENCREA  >= CTOD('" + DTOC(MV_PAR13) + "') .And. E1_VENCREA <= CTOD('" + DTOC(MV_PAR14) + "') .And. "+ ;
					"E1_LOJA    >= '"+MV_PAR11+"' .And. E1_LOJA <= '"+MV_PAR12+"' .And. "+;
					"E1_FILIAL   = '"+xFilial()+"' .And. E1_SALDO > 0 .And. " + ;
					"SubsTring(E1_TIPO,3,1) != '-' .And. "+;
					"E1_PORTADO != '   '"
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SE1")
	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop() 
	If mv_par17 = 1
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
		@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
		@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
		//@ 180,220 CHECKBOX "Confirma Marcacoes" Var Exec
		//@ 180,300 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED
	EndIf
	
	dbGoTop()
	Do While !Eof()
		If Marked("E1_OK")
			AADD(aMarked,.T.)
		Else
			AADD(aMarked,.F.)
		EndIf
		dbSkip()
	EndDo
	dbGoTop()
	If Exec
		Processa({|lEnd|MontaRel(aMarked)})
		//MsgRun("Gerando relatório, aguarde...","",{|| CursorWait(), MontaRel(aMarked) ,CursorArrow()})
	Endif
	RetIndex("SE1")
	fErase(cIndexName+OrdBagExt())
	
EndIf
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aMarked)
LOCAL oPrint
LOCAL n := 0
LOCAL aBitmap      := {MV_PAR19,; 	//Banner publicitário
"LGRL.bmp"                    }  	//Logo da empresa

LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                                            ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Após o vencimento cobrar multa de R$ "                ,;
					   "Mora Diaria de R$ "                                   ,;
					   "Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

LOCAL aBMP         := aBitMap
LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
dbGoTop()
Do While !EOF()
	nRec := nRec + 1
	dbSkip()
EndDo
dbGoTop()
ProcRegua(nRec)
Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)

    //Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")                                                                          
	//	{SA6->A6_NUMBC        		                     ,; // [1]Numero do Banco
	aDadosBanco  := 	{'341-7'               		                     ,; // [1]Numero do Banco
					 SA6->A6_NOME      	            	                 ,; // [2]Nome do Banco
					 SUBSTR(SA6->A6_AGENCIA, 1, 4)                        ,; // [3]Agência
  					 Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; // [4]Conta Corrente
  					 Subs(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; // [5]Dígito da conta corrente
					 ' '                                              		}// [6]Codigo da Carteira


					 
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                           ,;      // [1]Razão Social
						AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      // [2]Código
						AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      // [3]Endereço
						AllTrim(SA1->A1_MUN )                            ,;      // [4]Cidade
						SA1->A1_EST                                      ,;      // [5]Estado
						SA1->A1_CEP                                      ,;      // [6]CEP
						SA1->A1_CGC										 }       // [7]CGC
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                           	 ,;   // [1]Razão Social
						 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
						 AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
						 AllTrim(SA1->A1_MUNC)	                             ,;   // [4]Cidade
						 SA1->A1_ESTC	                                     ,;   // [5]Estado
						 SA1->A1_CEPC                                        ,;   // [6]CEP
    					 SA1->A1_CGC										 }    // [7]CGC
	Endif                
	
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat),E1_VENCREA)

	aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)						,;  // [1] Número do título
					E1_EMISSAO                              					,;  // [2] Data da emissão do título
					Date()                                  					,;  // [3] Data da emissão do boleto
					E1_VENCREA                               					,;  // [4] Data do vencimento
					(E1_SALDO - _nVlrAbat)                  					,;  // [5] Valor do título
					CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
					E1_PREFIXO                               					,;  // [7] Prefixo da NF
					E1_TIPO	                               						}  // [8] Tipo do Titulo	

	If n > mv_par20 - 1
		n := 0
	EndIf
	If MV_PAR18 == 1
		aBMP[1] := "\Bitmaps\Banner"+str(n,1,0)+".bmp"
	EndIf
	If aMarked[i]
		Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1
	EndIf
	dbSkip()
	IncProc()
	i := i + 1
EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
//oPrinter:Print()   // Imprime direto na impressora default do AP5
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL oFont8
LOCAL oFont10
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2000,1900,2100,2300}
LOCAL aCoords7 := {2270,1900,2340,2300}
LOCAL aCoords8 := {2620,1900,2690,2300}
LOCAL oBrush

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)

// Inicia aqui a alteracao para novo layout - RAI
oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)              
oPrint:Say  (0084,100,aDadosBanco[2],oFont16 )	// [2]Nome do Banco
oPrint:Say  (0062,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]                                    ,oFont10)	//Nome         
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1060,DTOC(aDadosTit[4])                               ,oFont10)
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))   ,oFont10)
oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)

oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 ) //---
oPrint:Line (0550, 100,0550,2300 )

oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 ) //--
oPrint:Line (0550,1900,0150,1900 )

oPrint:Say  (0150,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (0190,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (0230,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0270,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (0310,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (0350,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0390,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (0430,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (0470,1910,"(  )Outros(anotar no verso)"                  	,oFont8)


//Gambiarra, descobrir como mudar tipo da linha.
For i := 100 to 2300 step 50
	oPrint:Line( 0600, i, 0600, i+30)
Next i

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)              
oPrint:Say  (0644,100,aDadosBanco[2],oFont16 )	// [2]Nome do Banco
oPrint:Say  (0622,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (0644,1900,"Recibo do Sacado",oFont10)

oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0750,100 ,"QUALQUER BANCO ATÉ A DATA DO VENCIMENTO"        ,oFont10)

oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2010,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)

oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)

oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (1150,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       ,oFont10)
oPrint:Say  (1200,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.05)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (1250,100 ,aBolText[3]                                        ,oFont10)

//oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (1589,400 ,"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
oPrint:Say  (1589,1850,Substr(aDadosTit[6],1,3)+"/00"+Substr(aDadosTit[6],4,8)  ,oFont10)

oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )
//Gambiarra, descobrir como mudar tipo da linha.
For i := 100 to 2300 step 50
	oPrint:Line( 1850, i, 1850, i+30)
Next i

// Encerra aqui a alteracao para o novo layout - RAI

oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1900, 550)
oPrint:Line (2000,800,1900, 800)              
oPrint:Say  (1934,100,aDadosBanco[2],oFont16 )	// [2]Nome do Banco
oPrint:Say  (1912,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (1934,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2040,100 ,"QUALQUER BANCO ATÉ A DATA DO VENCIMENTO"        ,oFont10)

oPrint:Say  (2000,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2040,2010,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (2100,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (2100,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (2140,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2230,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (2200,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (2230,1455,"N"                                             ,oFont10)

oPrint:Say  (2200,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (2230,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (2200,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (2230,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (2300,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (2270,1555,"Valor"                                          ,oFont8)

oPrint:Say  (2270,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (2440,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))      ,oFont10)
oPrint:Say  (2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.05)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (2540,100 ,aBolText[3]                                        ,oFont10)

oPrint:Say  (2340,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (2410,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (2480,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (2550,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (2620,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (2690,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2773,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (2826,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (2879,400 ,"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
oPrint:Say  (2879,1850,Substr(aDadosTit[6],1,3)+"/00"+Substr(aDadosTit[6],4,8)  ,oFont10)

oPrint:Say  (2895,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (2935,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (2935,1850,"Ficha de Compensação"                           ,oFont10)

oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )

oPrint:Line (2930,100,2930,2300  )
MSBAR("INT25"  ,26,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.2,,,,.F.)

DbSelectArea("SE1")
RecLock("SE1",.f.)
     SE1->E1_NUMBCO :=	CB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
MsUnlock()

oPrint:EndPage() // Finaliza a página
//oPrint:Preview()  	// Visualiza antes de imprimir
//oPrinter:Print() 	// Imprime direto na impressora default do AP5

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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


//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela

//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart		:= "175"

//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))

//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
                
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))

Return({CB,RN,NN})

********************************************************
Static Function ValidPerg()
********************************************************
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}
//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Prefixo "		,"Do Prefixo "			,"Do Prefixo "			,"mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate o Prefixo"		,"Ate o Prefixo"		,"Ate o Prefixo"		,"mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Titulo "			,"Do Titulo "   		,"Do Titulo "			,"mv_ch2","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate o Titulo"		,"Ate o Titulo"			,"Ate o Titulo"			,"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Parcela"			,"Da Parcela"			,"Da Parcela"			,"mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate a Parcela"		,"Ate a Parcela"		,"Ate a Parcela"		,"mv_ch6","C",01,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Do Banco "			,"Do Banco "			,"Do Banco "			,"mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
aAdd(aRegs,{cPerg,"08","Ate o Banco"		,"Ate o Banco"			,"Ate o Banco"			,"mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
aAdd(aRegs,{cPerg,"09","Do Cliente"			,"Do Cliente"			,"Do Cliente"			,"mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"10","Ate o Cliente"		,"Ate o Cliente"		,"Ate o Cliente"		,"mv_chA","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"11","Da Loja"			,"Da Loja"				,"Da Loja"				,"mv_chB","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Ate a Loja"			,"Ate a Loja"			,"Ate a Loja"			,"mv_chC","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Do Vencimento"		,"Do Vencimento"		,"Do Vencimento"		,"mv_chD","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Ate o Vencimento"	,"Ate o Vencimento"		,"Ate o Vencimento"		,"mv_chE","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Da Emissao"			,"Da Emissao"			,"Da Emissao"			,"mv_chF","D",08,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Ate a Emissao"		,"Ate a Emissao"		,"Ate a Emissao"		,"mv_chG","D",08,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Selecionar Titulos"	,"Selecionar Titulos"	,"Selecionar Titulos"	,"mv_chH","C",01,0,1,"C","","mv_par17","1=Sim","1=Sim","1=Sim","","","2=Nao","2=Nao","2=Nao","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Rotacionar Banner"	,"Rotacionar Banner"	,"Rotacionar Banner"	,"mv_chI","C",01,0,1,"C","","mv_par18","1=Sim","1=Sim","1=Sim","","","2=Nao","2=Nao","2=Nao","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Arquivo do Banner"	,"Arquivo do Banner"	,"Arquivo do Banner"	,"mv_chJ","C",50,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Numero de Banner"	,"Numero de Banner"		,"Numero de Banner"		,"mv_chJ","N",02,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FSTelaProc  ºAutor  ³Peter I Volf      º Data ³  08/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela inicial de processamento genérico  com opções   º±±
±±º          ³ Padrão: Cancela, Confirma e Parametros                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FSTelaProc(cTitulo,aDesc,cPerg)
Local nOpc := 2
Local i := 0
@ 200,1 TO 380,380 DIALOG oDlg TITLE cTitulo
For i := 1 to Len(aDesc)
   @2+(i*8),018 Say aDesc[i]
Next i            
@ 02,10 TO 080,190
@ 10,155 BMPBUTTON TYPE 01 ACTION Continua(@nOpc,oDlg)
@ 25,155 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 40,155 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
ACTIVATE DIALOG oDlg CENTERED  
Return nOpc

Static Function Continua(nOpc,oDlg)
   nOpc := 1
   Close(oDlg)
Return
