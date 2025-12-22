/*/{protheus.doc}SB5DESO
Rotina para cadastrar ou atualizar o complemento do produto
@author Vinicius Vendemiattiº
@since 03/02/2015
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SB5DESO   ºAutor  |Vinicius Vendemiattiº Data ³  03/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   Rotina para cadastrar ou atualizar o complemento de produto    º±±
±±ºcopiando o NCM para o campo                                            º±±
±±ºB5_CODATIV,B5_INSPAT = SIM E B5_VERIND = SIM   					      º±±
±±ºEXECUTA LOOP A CADA PRODUTO VERIFICA SE EXISTE OU NAO O COMPLEMENTO    º±±
±±ºDO PROD.														          º±±
±±ºNA FALTA DO COMPLEMENTO IRA CRIAR, SE JA EXISTIR VAI ATUALIZAR OS      º±±
±±ºCAMPOS B5_CODATIV,B5_INSPAT = SIM E B5_VERIND = SIM                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Honda Lock SP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE 'PROTHEUS.CH'
#define CRLF Chr(13)+Chr(10)

User Function SB5DESO() 

Private cIpi       	 := ""
Private cNcm      := space(8)
Private cCodigo 	  := ""

DbSelectArea("SB5")
DbGoTop()


DbSelectArea("SB1")
DbGoTop()
    
DEFINE MSDIALOG oDlg FROM  50, 100 TO 350,500 TITLE OemToAnsi(' CADASTRAR COMPLEMENTO DE PRODUTOS PARA DESONERACAO') PIXEL

@ 005, 004 SAY oSay1 PROMPT oemtoansi("Rotina para criar/atualizar o complemento do produto para a desoneração da folha." + CRLF + ;
"- Copia o NCM para o campo B5_CODATIV." + CRLF + ;
"- Marca o campo B5_INSPAT == SIM" + CRLF +;
"- Marca o campo B5_VERIND == SIM" + CRLF+ ;
" Digite o NCM do produto:")  SIZE 170, 050 OF oDlg COLORS 0, 16777215 PIXEL

@ 070, 070 MSGET oIPI   VAR cNcm    SIZE 50,010 OF oDlg COLORS 0, 16777215 PIXEL

@ 100, 080 BUTTON oExec PROMPT "Executar" SIZE 037, 012 OF oDlg ACTION(Btn1()) PIXEL

Activate Dialog oDlg CENTERED
 
Return

//BOTAO EXECUTA

Static Function Btn1()

oDlg:End()

cIpi := cNcm

Processa({||SB5D()},"Desoneracao - Complemento de produtos","Processando aguarde...", .F.)

Return

//ROTINA 
 
Static Function SB5D()

Private aProd := {}
Private nReg := 0

DbSelectArea("SB5")
DbGoTop()


DbSelectArea("SB1")
DbGoTop()
DbSetFilter({|| AllTrim(B1_FILIAL) == xFilial('SB1') .AND. AllTrim(B1_POSIPI) == cIpi },;
" AllTrim(B1_FILIAL) == xFilial('SB1') .AND. AllTrim(B1_POSIPI) == cIpi ")

nReg := ContaSB1()

SB1->(DbGoTop())

ProcRegua(nReg)

While!SB1->(EOF())   
   		
   	   //IncProc("Verificando cadastro de produto...")
   		
   		If AllTrim(SB1->B1_POSIPI) == cIpi
   		
   			cCodigo := AllTrim(SB1->B1_COD)
   				
   	   		DbSelectArea("SB5")
			DbGoTop()
			DbSeek(xFilial("SB5")+cCodigo)
		
			If FOUND() //se existir, altera os dados do complemento deixando o campo B5_CODATIV com o mesmo valor do B1_POSIPI e tambem ativa os campos da desoneração.
			    
			 	IncProc("Alterando o complemento do codigo: " + cCodigo)
				
				CONOUT("ALTERADO - "  + CVALTOCHAR(cCodigo))
			    
			  	AADD(aProd,cCodigo + " - Alterado")
			  	
				RecLock("SB5",.F.)
			
				SB5->B5_CODATIV := SB1->B1_POSIPI
				SB5->B5_INSPAT   := "1"
				SB5->B5_VERIND   := "2" 
			
				MsUnlock()
			
			Else
			 
				IncProc("Incluindo o complemento do codigo: " + cCodigo)
				
				CONOUT("INCLUIDO - "  + CVALTOCHAR(cCodigo))
			    
				AADD(aProd,cCodigo + " - Incluido")
			
				RecLock("SB5",.T.)
			
				SB5->B5_FILIAL 		:= xFilial('SB5')
				SB5->B5_COD   		:= cCodigo 
				SB5->B5_CEME		:= AllTrim(SB1->B1_DESC)
				SB5->B5_CODATIV 	:= SB1->B1_POSIPI
				SB5->B5_INSPAT   	:= "1"
				SB5->B5_VERIND   	:= "2" 
		
				MsUnlock()
				
			EndIf
		Else
			SB1->(DbSkip()) 	
		EndiF
	SB1->(DbSkip())   			    
End 

DbClearFilter()
    
Conout("Termino da rotina:")
MsgInfo("Rotina terminada!")

Return


//CONTA OS REGISTROS DA TABELA SB1

Static Function ContaSB1()

Local nCont := 0

While!SB1->(EOF())   
	nCont += 1
	SB1->(DbSkip())
End

Return(nCont)