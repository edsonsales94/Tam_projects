#include 'Protheus.ch'
#include 'RwMake.ch'


/*
#############################################################################
±±ºPrograma  ³INCOMP02  ºAutor  ³Ener Fredes         º Data ³  02/02/11   º±±
#############################################################################
±±ºDesc.     ³  Rotina que efetua a reprovacao de documentos              º±±
#############################################################################
±±ºUso       ³ AP                                                        º±±
#############################################################################
*/

User Function INCOMP02()

	Local aArea		:= GetArea()
	Local aRetSaldo := {}
	
	Local cObs 		:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
	Local ca097User := RetCodUsr()
	Local cTipoLim  := ""
	Local CRoeda    := ""
	Local cAprov    := ""
	Local cName     := ""
	Local cSavColor := ""
	Local cGrupo	:= ""
	Local cCodLiber := SCR->CR_APROV
	Local cDocto    := SCR->CR_NUM
	Local cTipo     := SCR->CR_TIPO
	Local dRefer 	:= dDataBase
	Local cPCLib	:= ""
	Local cPCUser	:= ""
	
	Local lContinua := .T.
	
	Local nSaldo    := 0
	Local nOpc      := 0
	Local nSalDif	:= 0
	Local nTotal    := 0
	Local nMoeda	:= 1
	Local nX        := 1
	
	Local oDlg
	Local oDataRef
	Local oSaldo
	Local oSalDif
	
	Local cjTit  := ""
 	Local cEmail := "" 	
	Local cMens  := ""

	
	If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
		Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
		lContinua := .F.
	ElseIf lContinua .And. SCR->CR_STATUS$"01"
		Aviso("A097BLQ","Documento Liberado",{"Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"}) //Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
		lContinua := .F.
	EndIf

	If lContinua
		dbSelectArea("SAL")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa as variaveis utilizadas no Display.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRetSaldo := MaSalAlc(cCodLiber,dRefer)
		nSaldo 	  := aRetSaldo[1]
		CRoeda 	  := A097Moeda(aRetSaldo[2])
		cName  	  := UsrRetName(ca097User)
		nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
		
		Do Case
		Case SAK->AK_TIPO == "D"
			cTipoLim :=OemToAnsi("Diario") // "Diario"
		Case  SAK->AK_TIPO == "S"
			cTipoLim := OemToAnsi("Semanal") //"Semanal"
		Case  SAK->AK_TIPO == "M"
			cTipoLim := OemToAnsi("Mensal") //"Mensal"
		Case  SAK->AK_TIPO == "A"
			cTipoLim := OemToAnsi("Anual") //"Anual"
		EndCase
		
		Do Case
		Case SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
		
			dbSelectArea("SC7")
			dbSetOrder(1)
			MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
			cGrupo := SC7->C7_APROV
		
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
		
			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_COD)
		
		Case SCR->CR_TIPO == "MD"
		
			dbSelectArea("CND")
			dbSetOrder(4)
			MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
			cGrupo := CND->CND_APROV
		
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)
		
			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
		
		EndCase
		
		If SAL->AL_LIBAPR != "A"
			cAprov := OemToAnsi("VISTO / LIVRE") // "VISTO / LIVRE"
		EndIf
		nSalDif := nSaldo 
		If (nSalDif) < 0
			Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
			lContinua := .F.
		EndIf
	EndIf
		
	If lContinua
	
			DEFINE MSDIALOG oDlg FROM 0,0 TO 310,410 TITLE OemToAnsi("Reprovação do Documento") PIXEL  //"Liberacao do PC"
			@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
			@ 45,01  TO 138,204 LABEL "" OF oDlg PIXEL
			@ 07,06  Say OemToAnsi("Numero") OF oDlg PIXEL //"Numero do Pedido "
			@ 07,120 Say OemToAnsi("Emissao") OF oDlg SIZE 50,9 PIXEL //"Emissao "
			@ 19,06  Say OemToAnsi("Fornecedor") OF oDlg PIXEL //"Fonecedor "
			@ 31,06  Say OemToAnsi("Aprovador") OF oDlg PIXEL SIZE 30,9 //"Aprovador "
			@ 31,120 Say OemToAnsi("Data de Ref") SIZE 60,9 OF oDlg PIXEL  //"Data de ref.  "
			@ 53,06  Say OemToAnsi("Limite Min.") +CRoeda OF oDlg PIXEL //"Limite min.  "
			@ 53,110 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL //"Limite max. "
			@ 65,06  Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL //"Limite  "
			@ 65,110 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL //"Tipo lim."
			@ 77,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL //"Saldo na data  "
			@ 89,06  Say OemToAnsi("Total do pedido  ")+CRoeda OF oDlg PIXEL //"Total do pedido  "
			@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL //"Saldo disponivel apos liberacao  "
			@ 113,06 Say OemToAnsi("Motivo ") SIZE 100,10 OF oDlg PIXEL //"Observa‡äes "
			@ 07,58  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF oDlg PIXEL
			@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
			@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
			@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
			@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL
			@ 53,50  MSGET SAK->AK_LIMMIN Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
			@ 53,155 MSGET SAK->AK_LIMMAX Picture "@E 999,999,999.99" When .F. SIZE 45,9 OF oDlg PIXEL RIGHT
			@ 65,50  MSGET SAK->AK_LIMITE Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
			@ 65,155 MSGET cTipoLim When .F. SIZE 45,9 OF oDlg PIXEL CENTERED
			@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
			@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
//			@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
   		@ 113,075 Get cObs Size 125,020 MEMO Object oMemo 
		
		
			@ 142,121 BUTTON OemToAnsi("Reprovar Dcto") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
			@ 142,162 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL
			ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpc == 1         
		   Begin Transaction
			Do Case
			Case SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				dbSelectArea("SCR")
				Reclock("SCR",.F.)
				SCR->CR_STATUS := "01"
				SCR->CR_OBS := "PEDIDO REPROVADO"
				MsUnlock()
				dbSelectArea("SC7")
				cPCLib := SC7->C7_NUM
				cPCUser:= SC7->C7_USER
/*				
				While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
					Reclock("SC7",.F.)
					SC7->C7_RESIDUO :=         
					SC7->C7_OBS := cObs
					
					MsUnlock()
					DbSkip()
				End
*/
				u_INEnviaEmail(xFilial("SC7"),Alltrim(cPCLib),"",3,cObs)   // Envia e-mail para os aprovadore
				
			Case SCR->CR_TIPO == "RV" 
				MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
				SZ7->(dbSetOrder(1))
				SZ7->(dbSeek(xFilial('SZ7')+PADR(SCR->CR_NUM,Len(SZ7->Z7_CODIGO))))
				
					DbSelectArea("SZH")	 
					SZH->(DbSetOrder(1))
					If DbSeek(xFilial("SZH")+SZ7->Z7_CODIGO)
						While SZH->(!Eof()) .And. xFilial("SZH") == SZH->ZH_FILIAL .And. SZH->ZH_NUM == SZ7->Z7_CODIGO		
		
							PcoIniLan("900500")
				
							PcoDetLan('900500','01','INVIAC01',.T.)
								
							PcoFinLan("900500")				
		
					     
							SZH->(DbSkip())
						EndDo		
					EndiF				
				
				SZ7->(RecLock('SZ7',.F.))
				SZ7->Z7_STATUS := '3'
				SZ7->(MsUnlock())
				Processa({|| u_INVIAP03(Alltrim(SZ7->Z7_CODIGO),'02',cObs) },'Enviando Email de Retorno')
  
			Case SCR->CR_TIPO == "MD"
				
				cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )
            cAprov := UsrRetName(SCR->CR_USER)

 				cMsg := '<html>
				cMsg += '<head>
				cMsg += u_INCOMWST(.F.)
				cMsg += '<meta http-equiv="Content-Language" content="en-us">
				cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
				cMsg += '<BODY>     
				cMsg += '<form method="POST" action="">
				cMsg += '<p> Medição '+CND->CND_NUMMED+' <b><font face="Arial" size=3 color=#FF0000> REPROVADO </font></b> Pelo(s) Aprovador(es) : ' + ALLTRIM(cAprov) + '</p>'
				cMsg += '  <p> <b>Motivo: '+ALLTRIM(cObs)+'</b></p>'
				cMsg += U_INGCTW01(xFilial("CND"),CND->CND_NUMMED, CND->CND_CONTRA)
				cMsg += '</form>
				cMsg += '</body>
				cMsg += '</html>
            			
				Reclock("SCR",.F.)
					SCR->CR_STATUS := "01"
					SCR->CR_OBS := "PEDIDO REPROVADO"
				MsUnlock()

				U_INMEMAIL(cjTit,cMsg,cEmail)         	

		   EndCase		   
		   
		   End Transaction
		EndIf	
	EndIf
	RestArea(aArea)

Return Nil
