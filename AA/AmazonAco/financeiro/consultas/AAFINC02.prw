//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "PROTHEUS.CH"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFINC02   ¦ Autor ¦ Diego Rafel          ¦ Data ¦ 16/01/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta com dados financeiros considerando intervalo de dais ¦¦¦
¦¦¦  (Cont)   ¦ pre-definidos.                                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINC02()

	//-------------------------------------------------------. 
	// Declaração das bibliotecas utilizadas no programa      |
	//-------------------------------------------------------'
	Local oButton1
	Local oButton2
	Local oSay
	Local oSay1
	Local oSay10
	Local oSay11
	Local oSay12
	Local oSay13
	Local oSay15
	Local oSay16
	Local oSay17
	Local oSay18
	Local oSay2
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSay20              
	Local oSay21

	If type("cAcesso") = "U"
		Prepare Environment Empresa "01" Filial "01" Tables "SE1,SE2" Modulo "FIN"
	EndIf                     

	Private _dDataInicial :=  Date()
	Private _dDataFinal   :=  Date()
	Private _cPer1de      := 01
	Private _cPer1ate     := 30  
	Private _cPer2de      := 31
	Private _cPer2ate     := 60  
	Private _cPer3de      := 61
	Private _cPer3ate     := 90
	Private _cPer4de      := 91 
	Private _cPer5de      := 01
	Private _cPer5ate     := 30
	Private _cPer6de      := 31
	Private _cPer6ate     := 60
	Private _cPer7de      := 61
	Private _cPer7ate     := 90  
	Private _cPer8de      := 91 
	Private aDatas := GetDatas()

	Private _odTpRoman  := Nil
	Private _adTpRoman  := {}
	Private _cdTpRoman  := "Não Considera"

	cTblSE2 := GetFin("SE2")
	cTblSE1 := GetFin("SE1")

	Private oSay3
	Private oSay4

	Private oGet1 := Nil
	Private cGet1 := ""//(cTblSE2)->C_V_30
	Private oGet2 := Nil
	Private cGet2 := ""//(cTblSE2)->VENC_30
	Private oGet3 := Nil
	Private cGet3 := ""//(cTblSE2)->C_V_31_60
	Private oGet4 := Nil
	Private cGet4 := ""//(cTblSE2)->VENC_31_60
	Private oGet5 := Nil
	Private cGet5 := ""//(cTblSE2)->C_V_61_90
	Private oGet6 := Nil
	Private cGet6 := ""//(cTblSE2)->VENC_61_90
	Private oGet7 := Nil
	Private cGet7 := ""//(cTblSE2)->C_V_90
	Private oGet8 := Nil
	Private cGet8 := ""//(cTblSE2)->VENC_90
	Private oGet9 := Nil
	Private cGet9 := ""//(cTblSE1)->C_V_30
	Private oGet10 := Nil
	Private cGet10 := ""//(cTblSE1)->VENC_30
	Private oGet11 := Nil
	Private cGet11 := ""//(cTblSE1)->C_V_31_60
	Private oGet12 := Nil
	Private cGet12 := ""//(cTblSE1)->VENC_31_60
	Private oGet13 := Nil
	Private cGet13 := ""//(cTblSE1)->C_V_61_90
	Private oGet14 := Nil
	Private cGet14 := ""//(cTblSE1)->VENC_61_90
	Private oGet15 := Nil
	Private cGet15 := ""//(cTblSE1)->C_V_90
	Private oGet16 := Nil
	Private cGet16 := ""//(cTblSE1)->VENC_90
	Private oGet17 := Nil
	Private cGet17 := ""//(cTblSE2)->C_V_TODAY
	Private oGet18 := Nil
	Private cGet18 := ""//(cTblSE2)->VENC_TODAY
	Private oGet19 := Nil
	Private cGet19 := ""//(cTblSE1)->C_V_TODAY
	Private oGet20 := Nil
	Private cGet20 := ""//(cTblSE1)->VENC_TODAY
	Private oGet21 := Nil
	Private cGet21 := ""//(cTblSE2)->C_A_30
	Private oGet22 := Nil
	Private cGet22 := ""//(cTblSE2)->AVENC_30
	Private oGet23 := Nil
	Private cGet23 := ""//(cTblSE2)->C_A_31_60
	Private oGet24 := Nil
	Private cGet24 := ""//(cTblSE2)->AVENC_31_60
	Private oGet25 := Nil
	Private cGet25 := ""//(cTblSE2)->C_A_61_90
	Private oGet26 := Nil
	Private cGet26 := ""//(cTblSE2)->AVENC_61_90
	Private oGet27 := Nil
	Private cGet27 := ""//(cTblSE2)->C_A_90
	Private oGet28 := Nil
	Private cGet28 := ""//(cTblSE2)->AVENC_90
	Private oGet29 := Nil
	Private cGet29 := ""//(cTblSE1)->C_A_30
	Private oGet30 := Nil 
	Private cGet30 := ""//(cTblSE1)->AVENC_30
	Private oGet31 := Nil
	Private cGet31 := ""//(cTblSE1)->C_A_31_60
	Private oGet32 := Nil
	Private cGet32 := ""//(cTblSE1)->AVENC_31_60
	Private oGet33 := Nil
	Private cGet33 := ""//(cTblSE1)->C_A_61_90
	Private oGet34 := Nil
	Private cGet34 := ""//(cTblSE1)->AVENC_61_90
	Private oGet35 := Nil
	Private cGet35 := ""//(cTblSE1)->C_A_90
	Private oGet36 := Nil
	Private cGet36 := ""//(cTblSE1)->AVENC_90
	Private oGet37 := Nil
	Private cGet37 := ""//(cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
	Private oGet38 := Nil
	Private cGet38 := ""//(cTblSE2)->( AVENC_30 + VENC_30 + AVENC_31_60 + VENC_31_60 + AVENC_61_90 + VENC_61_90 + AVENC_90 + VENC_90 + VENC_TODAY)
	Private oGet39 := Nil
	Private cGet39 := ""//(cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
	Private oGet40 := Nil
	Private cGet40 := ""//(cTblSE1)->( AVENC_30 + VENC_30 + AVENC_31_60 + VENC_31_60 + AVENC_61_90 + VENC_61_90 + AVENC_90 + VENC_90 + VENC_TODAY)

	//Terceira Coluna
	Private oGetA  := Nil
	Private oGetB  := Nil
	Private oGetC  := Nil
	Private oGetD  := Nil
	Private oGetE  := Nil
	Private oGetF  := Nil
	Private oGetG  := Nil
	Private oGetH  := Nil
	Private oGetI  := Nil
	Private oGetJ  := Nil

	Private CGetA  := ""
	Private CGetB  := ""
	Private CGetC  := ""
	Private CGetD  := ""
	Private CGetE  := ""
	Private cGetF  := ""
	Private cGetG  := ""
	Private cGetH  := ""
	Private cGetI  := ""
	Private cGetJ  := ""


	//Sexta Coluna
	Private oGetK  := Nil
	Private oGetL  := Nil
	Private oGetM  := Nil
	Private oGetN  := Nil
	Private oGetO  := Nil
	Private oGetP  := Nil
	Private oGetQ  := Nil
	Private oGetR  := Nil
	Private oGetS  := Nil
	Private oGetT  := Nil
	Private oGetCot:= Nil     

	Private CGetK          := ""
	Private CGetL          := ""
	Private CGetM          := ""
	Private CGetN          := ""
	Private CGetO          := ""
	Private cGetP          := ""
	Private cGetQ          := ""
	Private cGetR          := ""
	Private cGetS          := ""
	Private cGetT          := ""    

	Private oGetDias1     := 0    
	Private oGetDias2     := 0
	Private oGetDias3     := 0
	Private oGetDias4     := 0   
	Private oGetDias5     := 0
	Private oGetDias6     := 0 
	Private oGetDias7     := 0
	Private oGetDias8     := 0
	Private oGetDias9     := 0 
	Private oGetDiasa     := 0
	Private oGetDiasb     := 0
	Private oGetDiasc     := 0
	Private oGetDiasd     := 0
	Private oGetDiase     := 0
	Private cGetCot       := 0     
	
	
	aAdd(_adTpRoman,"Não Considera")
	aAdd(_adTpRoman,"Considera")
	aAdd(_adTpRoman,"Somente")
	
	Atualiza2()

	DEFINE FONT oFont1 NAME "Arial" SIZE 0, -12 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 0, -10 BOLD

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Posicao Financeira" FROM 000, 000  TO 580, 1100 COLORS 0, 16777215 PIXEL


	@ 012, 150 SAY oSay20 PROMPT "Cotacao Dolar" SIZE 041, 009 OF oDlg COLORS 0, 16777215 PIXEL Font oFont2
	@ 012, 189 MSGET oGetCot VAR cGetCot SIZE 050, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999.99999999" when .T. // Segunda Coluna(VALOR R$)

	@ 012, 078 SAY oSay PROMPT "CONTAS A PAGAR" SIZE 071, 009 OF oDlg COLORS 0, 16777215 PIXEL Font oFont1

	@ 026, 102 SAY oSay2 PROMPT "Qtde"      SIZE 021, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 027, 130 SAY oSay3 PROMPT "Valor R$"  SIZE 059, 008 OF oDlg COLORS 0, 16777215 PIXEL		
	@ 027, 195 SAY oSay3 PROMPT "Valor Outras Moedas(U$$,EU$)" SIZE 059, 008 OF oDlg COLORS 0, 16777215 PIXEL

	//		@ 027, 179 SAY oSay4 PROMPT "Valor U$$" SIZE 059, 008 OF oDlg COLORS 0, 16777215 PIXEL


	//-------------------------------------------------------. 
	// Quadrante que mostra os Titulos a pagar Vencidos       |
	//-------------------------------------------------------'
	//@ 030, 045 TO 100,270 label "" OF oDlg PIXEL 
	//@ 030, 006 TO 100,046 label "" OF oDlg PIXEL 
	@ 060, 013 SAY oSay1 PROMPT "Vencidos"  SIZE 029, 010 OF oDlg COLORS 0, 16777215 PIXEL  Font oFont1

	//-------------------------------------------------------. 
	// Analise a pagar de 01 a 30 dias                        |
	//-------------------------------------------------------'
	@ 036, 045 MSGET oGetDias1 VAR _cPEr1de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 036, 070 MSGET oGetDias2 VAR _cPEr1ate SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 038, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 038, 060 SAY    oSay21  PROMPT "a"     SIZE 004, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 036, 102 MSGET  oGet1  VAR    cGet1              SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         when .F. // Primeira Coluna ( QTDE )
	@ 036, 130 MSGET  oGet2  VAR    cGet2              SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" when .F. // Segunda Coluna(VALOR R$)		
	@ 036, 195 MSGET  oGetA  VAR    cGetA              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 036, 258 BUTTON oBtn  PROMPT "Print"             SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",6)    

	//-------------------------------------------------------. 
	// Analise a pagar de 31 a 60 dias                        |
	//-------------------------------------------------------'		
	@ 052, 045 MSGET oGetDias3 VAR _cPEr2de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 052, 070 MSGET oGetDias4 VAR _cPEr2ate SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 054, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 054, 060 SAY    oSay21  PROMPT "a"     SIZE 004, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	//			@ 052, 060 SAY    oSay5  PROMPT "31 a 60 dias"     SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL                                      // Label de 31 a 60 dias
	@ 052, 102 MSGET  oGet3  VAR    cGet3              SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F. // Primeira Coluna ( QTDE )
	@ 052, 130 MSGET  oGet4  VAR    cGet4              SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F. // Segunda Coluna(VALOR R$)		
	@ 052, 195 MSGET  oGetB  VAR    cGetB              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)		
	@ 052, 258 BUTTON oBtn   PROMPT "Print"            SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",7)    

	//-------------------------------------------------------. 
	// Analise a pagar de 61 a 90 dias                        |
	//-------------------------------------------------------'		
	//@ 067, 060 SAY    oSay6  PROMPT "61 a 90 dias"     SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 067, 045 MSGET oGetDias5 VAR _cPEr3de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 067, 070 MSGET oGetDias6 VAR _cPEr3ate SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 069, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 069, 060 SAY    oSay21  PROMPT "a"     SIZE 004, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 067, 102 MSGET  oGet5  VAR    cGet5              SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 067, 130 MSGET  oGet6  VAR    cGet6              SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.
	@ 067, 195 MSGET  oGetC  VAR    cGetC              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)		
	@ 067, 258 BUTTON oBtn   PROMPT "Print"            SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",8)      

	//-------------------------------------------------------. 
	// Analise a pagar acima de 90 dias                       |
	//-------------------------------------------------------'		
	//@ 067, 045 MSGET oGetDias3 VAR _cPEr3de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 082, 070 MSGET oGetDias7 VAR _cPEr4de SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 084, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 084, 045 SAY    oSay21  PROMPT "Acima de "     SIZE 025, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	//@ 082, 048 SAY    oSay7  PROMPT "Acima de 90 dias" SIZE 043, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 082, 102 MSGET  oGet7  VAR    cGet7              SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 082, 130 MSGET  oGet8  VAR    cGet8              SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.
	@ 082, 195 MSGET  oGetD  VAR    cGetD              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)		
	@ 082, 258 BUTTON oBtn   PROMPT "Print"            SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",9)

	//-------------------------------------------------------. 
	// Quadrante que mostra os Titulos a pagar na data atual  |
	//-------------------------------------------------------'		
	@ 110, 006 SAY oSay11 PROMPT "DATA ATUAL" SIZE 036, 011 OF oDlg COLORS 0, 16777215 PIXEL Font oFont1

	//-------------------------------------------------------. 
	// Analise a pagar na data atual                          |
	//-------------------------------------------------------'		
	@ 110, 102 MSGET  oGet17 VAR    cGet17             SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 110, 130 MSGET  oGet18 VAR    cGet18             SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.		
	@ 110, 195 MSGET  oGetE  VAR    cGetE              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 110, 258 BUTTON oBtn   PROMPT "Print"            SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",5)

	//-------------------------------------------------------. 
	// Quadrante que mostra os Titulos a pagar a Vencer       |
	//-------------------------------------------------------'		
	@ 140, 005 SAY oSay12 PROMPT "A VENCER" SIZE 029, 010 OF oDlg COLORS 0, 16777215 PIXEL Font oFont1

	//-------------------------------------------------------. 
	// Analise a pagar de 01 a 30 dias                        |
	//-------------------------------------------------------'		
	//@ 138, 059 SAY    oSay15 PROMPT "1 a 30 dias"      SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 138, 045 MSGET oGetDias8 VAR _cPEr5de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 138, 070 MSGET oGetDias9 VAR _cPEr5ate SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 140, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 140, 060 SAY    oSay21  PROMPT "a"     SIZE 004, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 138, 102 MSGET  oGet21 VAR    cGet21             SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 138, 130 MSGET  oGet22 VAR    cGet22             SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.			
	@ 138, 195 MSGET  oGetF  VAR    cGetF              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 138, 258 BUTTON oBtn   PROMPT "Print"            SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",1) 

	//-------------------------------------------------------. 
	// Analise a pagar de 31 a 60 dias                        |
	//-------------------------------------------------------'		
	//@ 154, 059 SAY    oSay16 PROMPT "31 a 60 dias"     SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL			
	@ 154, 045 MSGET oGetDiasa VAR _cPEr6de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 154, 070 MSGET oGetDiasb VAR _cPEr6ate SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 156, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 156, 060 SAY    oSay21  PROMPT "a"     SIZE 004, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 154, 102 MSGET  oGet23 VAR    cGet23         		SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 154, 130 MSGET  oGet24 VAR    cGet24 				SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.			
	@ 154, 195 MSGET  oGetG  VAR    cGetG 					SIZE 061, 010 OF oDlg COLORS CLR_RED 	  PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 154, 258 BUTTON oBtn   PROMPT "Print" 				SIZE 017, 012 Of oDlg 						  PIXEL ACTION Imprime("SE2",2) 

	//-------------------------------------------------------. 
	// Analise a pagar de 61 a 90 dias                        |
	//-------------------------------------------------------'					
	//@ 169, 059 SAY    oSay17 PROMPT "61 a 90 dias"     SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 169, 045 MSGET oGetDiasc VAR _cPEr7de  SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 169, 070 MSGET oGetDiasd VAR _cPEr7ate SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 171, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 171, 060 SAY    oSay21  PROMPT "a"     SIZE 004, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 169, 102 MSGET  oGet25 VAR    cGet25             SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 169, 130 MSGET  oGet26 VAR    cGet26             SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.			
	@ 169, 195 MSGET  oGetH  VAR    cGetH              SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 169, 258 BUTTON oBtn   PROMPT "Print"            SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",3) 

	//-------------------------------------------------------. 
	// Analise a pagar acima de 90 dias                       |
	//-------------------------------------------------------'					
	//@ 184, 048 SAY    oSay18 PROMPT "Acima de 90 dias" SIZE 043, 010 OF oDlg COLORS 0, 16777215 PIXEL						
	@ 182, 070 MSGET oGetDiase VAR _cPEr8de SIZE 008, 008 OF oDlg COLORS 0, 16777215 PIXEL Picture "@99" when .T. 
	@ 186, 088 SAY    oSay4   PROMPT "dias"     SIZE 010, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 186, 045 SAY    oSay21  PROMPT "Acima de "     SIZE 025, 008 OF oDlg COLORS 0, 16777215 PIXEL	                                   // Label de 01 a 30 dias
	@ 184, 102 MSGET  oGet27 VAR    cGet27             SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"         When .F.
	@ 184, 130 MSGET  oGet28 VAR    cGet28 				SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99" When .F.			
	@ 184, 195 MSGET  oGetI  VAR    cGetI 					SIZE 061, 010 OF oDlg COLORS CLR_RED     PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 184, 258 BUTTON oBtn   PROMPT "Print" 				SIZE 017, 012 Of oDlg                    PIXEL ACTION Imprime("SE2",4) 






	@ 012, 200 +100 SAY oSay8 PROMPT "CONTAS A RECEBER" SIZE 071, 009 OF oDlg COLORS 0, 16777215 PIXEL Font oFont1

	@ 026, 199 +100 SAY oSay9 PROMPT "Qtde"       SIZE 021, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 027, 227 +100 SAY oSay10 PROMPT "Valor R$"  SIZE 059, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 027, 227 +170 SAY oSay55 PROMPT "Valor Outras Moedas(U$$,EU$)" SIZE 059, 008 OF oDlg COLORS 0, 16777215 PIXEL

	//		@ 027, 179 SAY oSay4 PROMPT "Valor U$$" SIZE 059, 008 OF oDlg COLORS 0, 16777215 PIXEL



	@ 036, 199 + 100 MSGET oGet9 VAR cGet9 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 036, 228 + 100 MSGET oGet10 VAR cGet10 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 036, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",6) Of oDlg

	@ 052, 199 + 100 MSGET oGet11 VAR cGet11 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"   When .F.
	@ 052, 228 + 100 MSGET oGet12 VAR cGet12 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 052, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",7) Of oDlg

	@ 067, 199 + 100 MSGET oGet13 VAR cGet13 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 067, 228 + 100 MSGET oGet14 VAR cGet14 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 067, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",8) Of oDlg

	@ 082, 199 + 100 MSGET oGet15 VAR cGet15 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 082, 228 + 100 MSGET oGet16 VAR cGet16 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 082, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",9) Of oDlg

	/*		@ 110, 006 SAY oSay11 PROMPT "DATA ATUAL" SIZE 036, 011 OF oDlg COLORS 0, 16777215 PIXEL Font oFont1
	@ 110, 082 MSGET oGet17 VAR cGet17 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 110, 110 MSGET oGet18 VAR cGet18 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 110, 238 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE2",5) Of oDlg
	*/
	@ 110, 199 + 100 MSGET oGet19 VAR cGet19 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 110, 228 + 100 MSGET oGet20 VAR cGet20 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 110, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",5) Of oDlg


	@ 138, 198 + 100 MSGET oGet29 VAR cGet29 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 138, 228 + 100 MSGET oGet30 VAR cGet30 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 138, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",1) Of oDlg

	@ 154, 198 + 100 MSGET oGet31 VAR cGet31 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 154, 228 + 100 MSGET oGet32 VAR cGet32 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 154, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",2) Of oDlg

	@ 169, 198 + 100 MSGET oGet33 VAR cGet33 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 169, 228 + 100 MSGET oGet34 VAR cGet34 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 169, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",3) Of oDlg

	@ 184, 198 + 100 MSGET oGet35 VAR cGet35 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 184, 228 + 100 MSGET oGet36 VAR cGet36 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999.99"  When .F.

	@ 184, 228 + 100 + 128 BUTTON oBtn PROMPT "Print" SIZE 17,12 PIXEL ACTION Imprime("SE1",4) Of oDlg

	@ 208, 005 SAY oSay13 PROMPT "TOTAL GERAL" SIZE 046, 011 OF oDlg COLORS 0, 16777215 PIXEL Font oFont1
	@ 208, 102 MSGET oGet37 VAR cGet37 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 208, 130 MSGET oGet38 VAR cGet38 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999,999,999.99"  When .F.
	@ 208, 198 + 100 MSGET oGet39 VAR cGet39 SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999999"  When .F.
	@ 208, 228 + 100 MSGET oGet40 VAR cGet40 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture "@E 999,999,999,999,999.99"  When .F.


	@ 208, 195 MSGET oGetJ VAR cGetJ SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)


	@ 036, 228 + 165 MSGET oGetK VAR cGetK SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 052, 228 + 165 MSGET oGetL VAR cGetL SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 067, 228 + 165 MSGET oGetM VAR cGetM SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 082, 228 + 166 MSGET oGetN VAR cGetN SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 110, 228 + 166 MSGET oGetO VAR cGetO SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 138, 228 + 166 MSGET oGetP VAR cGetP SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 154, 228 + 166 MSGET oGetQ VAR cGetQ SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 169, 228 + 166 MSGET oGetR VAR cGetR SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 184, 228 + 166 MSGET oGetS VAR cGetS SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)
	@ 208, 228 + 166 MSGET oGetT VAR cGetT SIZE 061,010 OF oDlg COLORS CLR_RED PIXEL Picture "@E 999,999,999.99" when .F. // TErceira Coluna(VALOR U$$)

	@ 033, 315 + 170 BUTTON oButton1 PROMPT "Atualizar" SIZE 065, 015 OF oDlg PIXEL action Atualiza2()
	@ 056, 315 + 170 BUTTON oButton2 PROMPT "Sair" SIZE 065, 015 OF oDlg ACTION oDlg:End() PIXEL
	
	@ 090,315 + 170  Say "Recebimento Duvidoso" Size 100,10 Pixel Of oDlg 
	@ 100,315 + 170  MSCOMBOBOX _odTpRoman VAR _cdTpRoman ITEMS _adTpRoman SIZE 060,50 OF oDlg PIXEL



	ACTIVATE MSDIALOG oDlg CENTERED

Return Nil


Static Function GetDatas()
	Local aRet := {}   

	AAdd( aRet , { .T.,  _cPEr5de,   _cPEr5ate, "AVENC_30"   , "C_A_30"   , Alltrim(Str(_cPEr5de)) + " a " + Alltrim(Str(_cPEr5ate)) + " dias"   } )
	AAdd( aRet , { .T.,  _cPEr6de,   _cPEr6ate, "AVENC_31_60", "C_A_31_60", Alltrim(Str(_cPEr6de)) + " a " + Alltrim(Str(_cPEr6ate)) + " dias"   } )
	AAdd( aRet , { .T.,  _cPEr7de,   _cPEr7ate, "AVENC_61_90", "C_A_61_90", Alltrim(Str(_cPEr7de)) + " a " + Alltrim(Str(_cPEr7ate)) + " dias"  } )
	AAdd( aRet , { .T.,  _cPEr8de,10000, "AVENC_90"   , "C_A_90"   , "Acima de " + Alltrim(Str(_cPEr8de)) + " dias" } )
	AAdd( aRet , { .T.,  0,    0, "VENC_TODAY" , "C_V_TODAY", "Hoje"} )   
	AAdd( aRet , { .F.,  _cPEr1de,   _cPEr1ate, "VENC_30"    , "C_V_30"   , Alltrim(Str(_cPEr1de)) + " a " + Alltrim(Str(_cPEr1ate)) + "  dias"} ) 
	AAdd( aRet , { .F.,  _cPEr2de,   _cPEr2ate, "VENC_31_60" , "C_V_31_60", Alltrim(Str(_cPEr2de)) + " a " + Alltrim(Str(_cPEr2ate)) + "  dias"} )
	AAdd( aRet , { .F.,  _cPEr3de,   _cPEr3ate, "VENC_61_90" , "C_V_61_90", Alltrim(Str(_cPEr3de)) + " a " + Alltrim(Str(_cPEr3ate)) + "  dias"} )
	AAdd( aRet , { .F.,  _cPEr4de ,10000, "VENC_90"    , "C_V_90"   , "Acima de " + Alltrim(Str(_cPEr4de)) + " dias"} )

Return aRet

Static Function GetFin(cAlias)
	Local cQry
	Local cTab   := If( cAlias = "S" , SubStr(cAlias,2,2), cAlias)
	Local cTable := GetNextAlias()

	cQry := "SELECT "+cTab+"_MOEDA,"
	aEval( aDatas , {|x| cQry += TimeQuery(cTab,x[1],x[2],x[3],x[4],x[5])+"," })
	cQry := SubStr(cQry,1,Len(cQry)-1)
	cQry += MainQuery(cAlias)
	//aviso('atencao',cQry,{'ok'},3)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQry),cTable,.T.,.T.)

Return cTable

Static Function TimeQuery(cTab,lVencido,nIni,nFim,cMenVal,cMenQtd)
	Local cQry
	Local cDifData := If( lVencido , "GETDATE(),CAST("+cTab+"_VENCREA AS DATETIME)", "CAST("+cTab+"_VENCREA AS DATETIME),GETDATE()")

	cQry := " ISNULL( SUM(CASE WHEN DATEDIFF(DAY,"+cDifData+") BETWEEN "+LTrim(Str(nIni,9))+" AND "+LTrim(Str(nFim,9))
	cQry += " THEN "+cTab+"_SALDO END),0) "+cMenVal+","
	cQry += " COUNT( case when DATEDIFF(DAY,"+cDifData+") BetWeen "+LTrim(Str(nIni,9))+" AND "+LTrim(Str(nFim,9))
	cQry += " THEN "+cTab+"_SALDO END) "+cMenQtd

Return cQry

Static Function MainQuery(cAlias,cFiltro)
	Local cQry := " FROM " + RetSqlName(cAlias) + " WHERE D_E_L_E_T_ = ' '"

	If cAlias == "SE1"
		cQry += " AND E1_SALDO > 0"
		cQry += " And E1_TIPO NOT IN ('NCC','RA','CR')" 
		If ALltrim(_cdTpRoman) == "Não Considera"
			cQry += " AND E1_FLUXO IN ( '', 'S') "
		ElseIf  ALltrim(_cdTpRoman) == "Somente"
			cQry += " AND E1_FLUXO NOT IN ( '', 'S') "
		EndIf 	
		//		cQry += " ANd E1_EMISSAO >= '20130101'
	Else
		cQry += " AND E2_SALDO > 0"
		cQry += " AND E2_TIPO NOT IN ('NDF','PA','NCP')"
		//cQry += " ANd E2_EMISSAO >= '20030101'
	Endif

	If cFiltro == Nil
		cQry += " GROUP BY "+SubStr(cAlias,2,2)+"_MOEDA"
	Else
		cQry += cFiltro
	Endif

Return cQry

Static Function Imprime(cTabela,nPer)
	Local cFiltro, cQry, nX
	Local cAlias   := Alias()
	Local aStruct  := (cTabela)->(dbStruct())
	Local cTab     := If( cTabela = "S" , SubStr(cTabela,2,2), cTabela)
	Local cDifData := If( aDatas[nPer,1] , "GETDATE(),CAST("+cTab+"_VENCREA AS DATETIME)", "CAST("+cTab+"_VENCREA AS DATETIME),GETDATE()")

	cFiltro := " AND DATEDIFF(DAY,"+cDifData+") BETWEEN "+LTrim(Str(aDatas[nPer,2],9))+" AND "+LTrim(Str(aDatas[nPer,3],9))
	cFiltro += " ORDER BY "+cTab+"_VENCREA, "+cTab+"_PREFIXO, "+cTab+"_NUM, "+cTab+"_PARCELA"

	cQry := "SELECT *"
	cQry += MainQuery(cTabela,cFiltro)

	if Select("TMP") > 0
		TMP->(dbCloseArea("TMP"))
	EndIF
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQry),"TMP",.T.,.T.)
	MEMOWRIT('AAFINC02.SQL',cQry)
	For nX:=1 To Len(aStruct)
		If aStruct[nX,2] == "D"
			TCSetField("TMP",aStruct[nX,1],"D",8,0)
		Endif
	Next

	PrintConsulta(cTabela,If(aDatas[nPer,1],"A vencer","Vencidos")+" - "+aDatas[nPer,6])

	dbSelectArea(cAlias)
Return

Static Function Atualiza2()

	aDatas := GetDatas()
	cTblSE2 := GetFin("SE2")
	cTblSE1 := GetFin("SE1")
	cGetA := 0
	cGetB := 0
	cGetC := 0
	cGetD := 0

	cGetE := 0
	cGetF := 0
	cGetG := 0
	cGetH := 0
	cGetI := 0
	cGetJ := 0

	cGetK := 0
	cGetL := 0
	cGetM := 0
	cGetN := 0
	cGetO := 0
	cGetP := 0
	cGetQ := 0
	cGetR := 0
	cGetS := 0
	cGetT := 0
    
    _nValDolar := iIf(cGetCot = 0,1,cGetCot)
    _nColor    := iIF(cGetCot = 0 .Or. cGetCot = 1,CLR_RED,CLR_BLUE)
    
	While !(cTblSE2)->(EOF())
		If (cTblSE2)->E2_MOEDA == 1
			cGet1 := (cTblSE2)->C_V_30
			cGet3 := (cTblSE2)->C_V_31_60
			cGet5 := (cTblSE2)->C_V_61_90
			cGet7 := (cTblSE2)->C_V_90
			cGet21 := (cTblSE2)->C_A_30
			cGet17 := (cTblSE2)->C_V_TODAY
			cGet23 := (cTblSE2)->C_A_31_60
			cGet25 := (cTblSE2)->C_A_61_90
			cGet27 := (cTblSE2)->C_A_90
			cGet37 := (cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)

			cGet2 := (cTblSE2)->VENC_30
			cGet4 := (cTblSE2)->VENC_31_60
			cGet6 := (cTblSE2)->VENC_61_90
			cGet8 := (cTblSE2)->VENC_90
			cGet18 := (cTblSE2)->VENC_TODAY
			cGet22 := (cTblSE2)->AVENC_30
			cGet24 := (cTblSE2)->AVENC_31_60
			cGet26 := (cTblSE2)->AVENC_61_90
			cGet28 := (cTblSE2)->AVENC_90
			cGet38 := (cTblSE2)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +   VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)
		ElseIf (cTblSE2)->E2_MOEDA <> 1
		
			cGetA += (cTblSE2)->VENC_30 * _nValDolar
			cGetB += (cTblSE2)->VENC_31_60 * _nValDolar
			cGetC += (cTblSE2)->VENC_61_90 * _nValDolar
			cGetD += (cTblSE2)->VENC_90 * _nValDolar
			cGetE += (cTblSE2)->VENC_TODAY * _nValDolar
			cGetF += (cTblSE2)->AVENC_30 * _nValDolar
			cGetG += (cTblSE2)->AVENC_31_60 * _nValDolar
			cGetH += (cTblSE2)->AVENC_61_90 * _nValDolar
			cGetI += (cTblSE2)->AVENC_90 * _nValDolar

			cGetJ += (cTblSE2)->( AVENC_30 + VENC_30 + AVENC_31_60 + VENC_31_60 + AVENC_61_90 + VENC_61_90 + AVENC_90 + VENC_90 + VENC_TODAY) * _nValDolar

			cGet1 += (cTblSE2)->C_V_30
			cGet3 += (cTblSE2)->C_V_31_60
			cGet5 += (cTblSE2)->C_V_61_90
			cGet7 += (cTblSE2)->C_V_90
			cGet21 += (cTblSE2)->C_A_30
			cGet17 += (cTblSE2)->C_V_TODAY
			cGet23 += (cTblSE2)->C_A_31_60
			cGet25 += (cTblSE2)->C_A_61_90
			cGet27 += (cTblSE2)->C_A_90
			cGet37 += (cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
		//Else

		EndIf
		(cTblSE2)->(dbSkip())
	EndDo 

	While !(cTblSE1)->(Eof())
		If (cTblSE1)->E1_MOEDA == 1
			cGet9 := (cTblSE1)->C_V_30
			cGet11 := (cTblSE1)->C_V_31_60
			cGet13 := (cTblSE1)->C_V_61_90
			cGet15 := (cTblSE1)->C_V_90
			cGet19 := (cTblSE1)->C_V_TODAY
			cGet29 := (cTblSE1)->C_A_30
			cGet31 := (cTblSE1)->C_A_31_60
			cGet33 := (cTblSE1)->C_A_61_90
			cGet35 := (cTblSE1)->C_A_90
			cGet39 := (cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)

			cGet10 := (cTblSE1)->VENC_30
			cGet12 := (cTblSE1)->VENC_31_60
			cGet14 := (cTblSE1)->VENC_61_90
			cGet16 := (cTblSE1)->VENC_90
			cGet20 := (cTblSE1)->VENC_TODAY
			cGet30 := (cTblSE1)->AVENC_30
			cGet32 := (cTblSE1)->AVENC_31_60
			cGet34 := (cTblSE1)->AVENC_61_90
			cGet36 := (cTblSE1)->AVENC_90

			cGet40 := (cTblSE1)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +  VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)
		Else//If (cTblSE1)->E1_MOEDA == 2
			cGetK += (cTblSE1)->VENC_30 * _nValDolar
			cGetL += (cTblSE1)->VENC_31_60 * _nValDolar
			cGetM += (cTblSE1)->VENC_61_90 * _nValDolar
			cGetN += (cTblSE1)->VENC_90 * _nValDolar
			cGetO += (cTblSE1)->VENC_TODAY * _nValDolar
			cGetP += (cTblSE1)->AVENC_30 * _nValDolar
			cGetQ += (cTblSE1)->AVENC_31_60 * _nValDolar
			cGetR += (cTblSE1)->AVENC_61_90 * _nValDolar
			cGetS += (cTblSE1)->AVENC_90 * _nValDolar
			cGetT += (cTblSE1)->( AVENC_30 + VENC_30 + AVENC_31_60 + VENC_31_60 + AVENC_61_90 + VENC_61_90 + AVENC_90 + VENC_90 + VENC_TODAY) * _nValDolar

			cGet9 += (cTblSE1)->C_V_30
			cGet11 += (cTblSE1)->C_V_31_60
			cGet13 += (cTblSE1)->C_V_61_90
			cGet15 += (cTblSE1)->C_V_90
			cGet19 += (cTblSE1)->C_V_TODAY
			cGet29 += (cTblSE1)->C_A_30
			cGet31 += (cTblSE1)->C_A_31_60
			cGet33 += (cTblSE1)->C_A_61_90
			cGet35 += (cTblSE1)->C_A_90
			cGet39 += (cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
		EndIf
		(cTblSE1)->(dbSKip()) 
	EndDo

	If valType(oGetA) = "O"

		oGetA:nClrText := _nColor
		oGetB:nClrText := _nColor
		oGetC:nClrText := _nColor
		oGetD:nClrText := _nColor
		oGetE:nClrText := _nColor
		oGetF:nClrText := _nColor
		oGetG:nClrText := _nColor
		oGetH:nClrText := _nColor
		oGetI:nClrText := _nColor
		oGetJ:nClrText := _nColor
		oGetK:nClrText := _nColor
		oGetL:nClrText := _nColor
		oGetM:nClrText := _nColor
		oGetN:nClrText := _nColor
		oGetO:nClrText := _nColor
		oGetP:nClrText := _nColor
		oGetQ:nClrText := _nColor
		oGetR:nClrText := _nColor
		oGetS:nClrText := _nColor
		oGetT:nClrText := _nColor

		oGetA:Refresh()
		oGetB:Refresh()
		oGetC:Refresh()
		oGetD:Refresh()
		oGetE:Refresh()
		oGetF:Refresh()
		oGetG:Refresh()
		oGetH:Refresh()
		oGetI:Refresh()
		oGetJ:Refresh()

		oGetK:Refresh()
		oGetL:Refresh()
		oGetM:Refresh()
		oGetN:Refresh()
		oGetO:Refresh()
		oGetP:Refresh()
		oGetQ:Refresh()
		oGetR:Refresh()
		oGetS:Refresh()
		oGetT:Refresh()

	EndIf

	lShowMsg := .F.
	For nI := 1 To 40
		IF ValType( &("oGet"+Alltrim(Str(NI))) )="O"
			&("oGet"+Alltrim(Str(NI))):Refresh()
			lShowMsg := .T.
		EndIf
	Next

	If lShowMsg
		//ApMsgInfo("Atualizado")
	EndIf
Return

Static Function Atualiza()    
	aDatas := GetDatas()
	cTblSE2 := GetFin("SE2")
	cTblSE1 := GetFin("SE1")

	cGet1 := (cTblSE2)->C_V_30
	cGet3 := (cTblSE2)->C_V_31_60
	cGet5 := (cTblSE2)->C_V_61_90
	cGet7 := (cTblSE2)->C_V_90
	cGet21 := (cTblSE2)->C_A_30
	cGet17 := (cTblSE2)->C_V_TODAY
	cGet23 := (cTblSE2)->C_A_31_60
	cGet25 := (cTblSE2)->C_A_61_90
	cGet27 := (cTblSE2)->C_A_90
	cGet37 := (cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)

	cGet2 := (cTblSE2)->VENC_30
	cGet4 := (cTblSE2)->VENC_31_60
	cGet6 := (cTblSE2)->VENC_61_90
	cGet8 := (cTblSE2)->VENC_90
	cGet18 := (cTblSE2)->VENC_TODAY
	cGet22 := (cTblSE2)->AVENC_30
	cGet24 := (cTblSE2)->AVENC_31_60
	cGet26 := (cTblSE2)->AVENC_61_90
	cGet28 := (cTblSE2)->AVENC_90
	cGet38 := (cTblSE2)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +   VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)

	cGet9 := (cTblSE1)->C_V_30
	cGet11 := (cTblSE1)->C_V_31_60
	cGet13 := (cTblSE1)->C_V_61_90
	cGet15 := (cTblSE1)->C_V_90
	cGet19 := (cTblSE1)->C_V_TODAY
	cGet29 := (cTblSE1)->C_A_30
	cGet31 := (cTblSE1)->C_A_31_60
	cGet33 := (cTblSE1)->C_A_61_90
	cGet35 := (cTblSE1)->C_A_90
	cGet39 := (cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)

	cGet10 := (cTblSE1)->VENC_30
	cGet12 := (cTblSE1)->VENC_31_60
	cGet14 := (cTblSE1)->VENC_61_90
	cGet16 := (cTblSE1)->VENC_90
	cGet20 := (cTblSE1)->VENC_TODAY
	cGet30 := (cTblSE1)->AVENC_30
	cGet32 := (cTblSE1)->AVENC_31_60
	cGet34 := (cTblSE1)->AVENC_61_90
	cGet36 := (cTblSE1)->AVENC_90

	cGet40 := (cTblSE1)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +  VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)

	(cTblSE2)->(dbSkip())

	_nValDolar := iIf(cGetCot = 0,1,cGetCot)
	_nColor    := iIF(cGetCot = 0 .Or. cGetCot = 1,CLR_RED,CLR_BLUE) 
	If !(cTblSE2)->(EOF())

		cGetA := (cTblSE2)->VENC_30 * _nValDolar
		cGetB := (cTblSE2)->VENC_31_60 * _nValDolar
		cGetC := (cTblSE2)->VENC_61_90 * _nValDolar
		cGetD := (cTblSE2)->VENC_90 * _nValDolar
		cGetE := (cTblSE2)->VENC_TODAY * _nValDolar
		cGetF := (cTblSE2)->AVENC_30 * _nValDolar
		cGetG := (cTblSE2)->AVENC_31_60 * _nValDolar
		cGetH := (cTblSE2)->AVENC_61_90 * _nValDolar
		cGetI := (cTblSE2)->AVENC_90 * _nValDolar

		cGetJ := (cTblSE2)->( AVENC_30 + VENC_30 + AVENC_31_60 + VENC_31_60 + AVENC_61_90 + VENC_61_90 + AVENC_90 + VENC_90 + VENC_TODAY) * _nValDolar

		cGet1 += (cTblSE2)->C_V_30
		cGet3 += (cTblSE2)->C_V_31_60
		cGet5 += (cTblSE2)->C_V_61_90
		cGet7 += (cTblSE2)->C_V_90
		cGet21 += (cTblSE2)->C_A_30
		cGet17 += (cTblSE2)->C_V_TODAY
		cGet23 += (cTblSE2)->C_A_31_60
		cGet25 += (cTblSE2)->C_A_61_90
		cGet27 += (cTblSE2)->C_A_90
		cGet37 += (cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
	else
		cGetA := 0
		cGetB := 0
		cGetC := 0
		cGetD := 0

		cGetE := 0
		cGetF := 0
		cGetG := 0
		cGetH := 0
		cGetI := 0
		cGetJ := 0
	EndIf

	(cTblSE1)->(dbSkip())
	If !(cTblSE1)->(EOF())

		cGetK := (cTblSE1)->VENC_30 * _nValDolar
		cGetL := (cTblSE1)->VENC_31_60 * _nValDolar
		cGetM := (cTblSE1)->VENC_61_90 * _nValDolar
		cGetN := (cTblSE1)->VENC_90 * _nValDolar
		cGetO := (cTblSE1)->VENC_TODAY * _nValDolar
		cGetP := (cTblSE1)->AVENC_30 * _nValDolar
		cGetQ := (cTblSE1)->AVENC_31_60 * _nValDolar
		cGetR := (cTblSE1)->AVENC_61_90 * _nValDolar
		cGetS := (cTblSE1)->AVENC_90 * _nValDolar
		cGetT := (cTblSE1)->( AVENC_30 + VENC_30 + AVENC_31_60 + VENC_31_60 + AVENC_61_90 + VENC_61_90 + AVENC_90 + VENC_90 + VENC_TODAY) * _nValDolar

		cGet9 += (cTblSE1)->C_V_30
		cGet11 += (cTblSE1)->C_V_31_60
		cGet13 += (cTblSE1)->C_V_61_90
		cGet15 += (cTblSE1)->C_V_90
		cGet19 += (cTblSE1)->C_V_TODAY
		cGet29 += (cTblSE1)->C_A_30
		cGet31 += (cTblSE1)->C_A_31_60
		cGet33 += (cTblSE1)->C_A_61_90
		cGet35 += (cTblSE1)->C_A_90
		cGet39 += (cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)

	else
		cGetK := 0
		cGetL := 0
		cGetM := 0
		cGetN := 0
		cGetO := 0
		cGetP := 0
		cGetQ := 0
		cGetR := 0
		cGetS := 0
		cGetT := 0
	EndIf

	If valType(oGetA) = "O"

		oGetA:nClrText := _nColor
		oGetB:nClrText := _nColor
		oGetC:nClrText := _nColor
		oGetD:nClrText := _nColor
		oGetE:nClrText := _nColor
		oGetF:nClrText := _nColor
		oGetG:nClrText := _nColor
		oGetH:nClrText := _nColor
		oGetI:nClrText := _nColor
		oGetJ:nClrText := _nColor
		oGetK:nClrText := _nColor
		oGetL:nClrText := _nColor
		oGetM:nClrText := _nColor
		oGetN:nClrText := _nColor
		oGetO:nClrText := _nColor
		oGetP:nClrText := _nColor
		oGetQ:nClrText := _nColor
		oGetR:nClrText := _nColor
		oGetS:nClrText := _nColor
		oGetT:nClrText := _nColor

		oGetA:Refresh()
		oGetB:Refresh()
		oGetC:Refresh()
		oGetD:Refresh()
		oGetE:Refresh()
		oGetF:Refresh()
		oGetG:Refresh()
		oGetH:Refresh()
		oGetI:Refresh()
		oGetJ:Refresh()

		oGetK:Refresh()
		oGetL:Refresh()
		oGetM:Refresh()
		oGetN:Refresh()
		oGetO:Refresh()
		oGetP:Refresh()
		oGetQ:Refresh()
		oGetR:Refresh()
		oGetS:Refresh()
		oGetT:Refresh()
	EndIf

	lShowMsg := .F.
	For nI := 1 To 40
		IF ValType( &("oGet"+Alltrim(Str(NI))) )="O"
			&("oGet"+Alltrim(Str(NI))):Refresh()
			lShowMsg := .T.
		EndIf
	Next

	If lShowMsg
		//ApMsgInfo("Atualizado")
	EndIf
Return

Static Function PrintConsulta(cTab,cSubTitulo)
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Posicao Financeira - "+If( cTab == "SE1" , "Contas a Receber", "Contas a Pagar")
	Local titulo        := cDesc3
	Local nLin          := 80
	Local Cabec1        := "."
	Local Cabec2        := "."
	Local aOrd          := {}
	Local cCliFor       := If( cTab == "SE1" , "Cliente   ", "Fornecedor")

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "AAFINC02" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private m_pag       := 01
	Private wnrel       := "AAFINC02" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString     := cTab

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Cabec1 := PADC(Upper(cSubTitulo),Limite)
	Cabec2 := "Prf  Titulo     Tp   Pc  "+cCliFor+"                       Emissao     Vencimento        Valor R$       Valor US$      Valor EU$"
	//         xxx  xxxxxxxxx  xxx  xx  xxxxxx xx  xxxxxxxxxxxxxxxxxxxx  99/99/9999  99/99/9999  999,999,999.99  999,999,999.99  999,999,999.99
	//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
	//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,cTab) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  13/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,cTab)
	Local vTotal := { 0, 0, 0}
	Local nConta := 0

	dbSelectArea("TMP")
	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		If cTab == "SE1"
			@nLin,00       PSAY E1_PREFIXO
			@nLin,PCol()+2 PSAY E1_NUM
			@nLin,PCol()+2 PSAY E1_TIPO
			@nLin,PCol()+2 PSAY E1_PARCELA
			@nLin,PCol()+2 PSAY E1_CLIENTE
			@nLin,PCol()+1 PSAY E1_LOJA
			@nLin,PCol()+2 PSAY E1_NOMCLI
			@nLin,PCol()+2 PSAY E1_EMISSAO
			@nLin,PCol()+2 PSAY E1_VENCREA
			If E1_MOEDA == 1
				vTotal[1] += E1_SALDO
			ElseIf E1_MOEDA == 2
				@nLin,PCol()+2 PSAY 0 Picture "@E 999,999,999.99"
				vTotal[2] += E1_SALDO
			Else
				@nLin,PCol()+2 PSAY 0 Picture "@E 999,999,999.99"
				@nLin,PCol()+3 PSAY 0 Picture "@E 999,999,999.99"
				vTotal[3] += E1_SALDO
			Endif
			@nLin,PCol()+2 PSAY E1_SALDO  Picture "@E 999,999,999.99"
		Else
			@nLin,00       PSAY E2_PREFIXO
			@nLin,PCol()+2 PSAY E2_NUM
			@nLin,PCol()+2 PSAY E2_TIPO
			@nLin,PCol()+2 PSAY E2_PARCELA
			@nLin,PCol()+2 PSAY E2_FORNECE
			@nLin,PCol()+1 PSAY E2_LOJA
			@nLin,PCol()+2 PSAY E2_NOMFOR
			@nLin,PCol()+2 PSAY E2_EMISSAO
			@nLin,PCol()+2 PSAY E2_VENCREA
			If E2_MOEDA == 1
				vTotal[1] += E2_SALDO
			ElseIf E2_MOEDA == 2
				@nLin,PCol()+2 PSAY 0 Picture "@E 999,999,999.99"
				vTotal[2] += E2_SALDO
			ElseIf E2_MOEDA == 4
				@nLin,PCol()+2 PSAY 0 Picture "@E 999,999,999.99"
				@nLin,PCol()+3 PSAY 0 Picture "@E 999,999,999.99"
				vTotal[3] += E2_SALDO
			Endif
			@nLin,PCol()+2 PSAY E2_SALDO  Picture "@E 999,999,999.99"
		Endif
		nLin++
		nConta++

		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo
	dbCloseArea()

	If nConta > 0
		nLin++
		@nLin,070      PSAY "Total Geral"
		@nLin,PCol()+1 PSAY vTotal[1]  Picture "@EZ 999,999,999.99"
		@nLin,PCol()+2 PSAY vTotal[2]  Picture "@EZ 999,999,999.99"
		@nLin,PCol()+3 PSAY vTotal[3]  Picture "@EZ 999,999,999.99"
		nLin++
		@nLin,070      PSAY "Titulos    "
		@nLin,PCol()+1 PSAY nConta  Picture "@EZ 99999999999999"
		nLin++
		@nLin,000      PSAY __PrtFatLine()
	Endif

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return
/*powered by DXRCOVRB*/

/*_______________________________________________________________________________
|¦¦ Função    ¦ENFATC99    ¦ Autor ¦ ADSON CARLOS         ¦ Data ¦ 10/04/2013 ¦¦|
|¦+-----------+------------+-------+----------------------+------+------------+¦|
|¦¦ Descriçäo ¦Chamada direto do Programa Inicial lembrar de setar infos fixas no vetor _Itens (inutil agora :) )¦|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function XAAFIC02()
Return( EvalPrw( { || U_AAFINC02()  } , "01" , "01" , "SIGAATF" , "SE1" ) )


/*_______________________________________________________________________________
|¦¦ Função    ¦EvalPrw    ¦ Autor ¦ ADSON CARLOS         ¦ Data ¦ 10/04/2013 ¦¦|
|¦+-----------+------------+-------+----------------------+------+------------+¦|
|¦¦ Descriçäo ¦Avalia a chamada via RPC									       ¦|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function EvalPrw( bExec , cEmp , cFil , cModulo , cTables )

	Local bWindowInit	:= { || Eval( bExec ) }
	Local lPrepEnv		:= ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )

	Local uRet

	BEGIN SEQUENCE

		IF ( lPrepEnv )
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cModulo ) TABLES ( cTables )
			InitPublic()
			SetsDefault()
		EndIF

		IF ( Type(  "oMainWnd" ) == "O" )
			uRet := Eval( bExec )
			BREAK
		EndIF

		bWindowInit	:= { || uRet := Eval( bExec ) }
		DEFINE WINDOW oMainWnd FROM 0,0 TO 0,0 TITLE OemToAnsi( FunName() )
		ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() )

		IF ( lPrepEnv )
			RESET ENVIRONMENT
		EndIF	

	END SEQUENCE

Return( uRet )

