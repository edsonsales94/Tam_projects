/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ JOB_PEDIDO  ³ AUTOR ³JONATHAN VIEIRA ALMEIDA DATA 14-08-2017±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ IMPORTACAO DE DIGITACAO DE PEDIDOS VIA ARQUIVO TEXTO       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±± ALTERAçãO:                                          DATA : 			   ±±
±± 																	       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO       ³ ESPECIFICO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
//#INCLUDE "INKEY.CH"

USER FUNCTION JOB_MAX2()

PRIVATE VTIPOIMP := {}

//rotina verifica se esta em execução nao tenho certeza se faz isso.
//FWGetRunSchedule()
CONOUT("JOB_MAX2:VERIFICANDO JOB_MAX2...")

// Neste exemplo, será demonstrado como criar, utilizar e limpar variáveis globais
cGlbName  := "TPL_JOB_MAX2"
cGlbValue := ""// Alimenta variável

cGlbValue := GetGlbValue(cGlbName)

CONOUT("JOB_MAX2:VERIFICANDO VARIAVEL... VALOR VARIAVEL:"+cGlbValue)
CONOUT(TIME())
If EMPTY(cGlbValue)  
	PutGlbValue(cGlbName,"JOB_MAX2")
	cGlbValue := GetGlbValue(cGlbName)	
	CONOUT("JOB_MAX2:VALOR VARIAVEL DEPOIS DE GRAVADA:"+cGlbValue)	
ELSE
	CONOUT("JOB_MAX2:PROCESSO EM USO! SAINDO DA ROTINA...")
	RETURN	
Endif

CONOUT(TIME()+" JOB_MAX2:IMPORTANDO VIA API!")
U_ROTINA(,"3")
CONOUT(TIME()+" JOB_MAX2:IMPORTADO COM SUCESSO!")			

ClearGlbValue(cGlbName)
cGlbValue := GetGlbValue(cGlbName)	
CONOUT("JOB_MAX2:LIMPOU. VALOR VARIAVEL:"+cGlbValue)
CONOUT(TIME())

RETURN         

Static Function Scheddef()
Local aParam
Local aOrd     := {OemToAnsi(" Por Codigo         "),OemToAnsi(" Alfabetica         ")}
aParam := { "P",;                      //Tipo R para relatorio P para processo   
"ACA070",;// Pergunte do relatorio, caso nao use passar ParamDef            
"SA1",;  // Alias            
aOrd,;   //Array de ordens   
"Teste SchedDef"}    
Return aParam