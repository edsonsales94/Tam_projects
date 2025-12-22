#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "TbiCode.ch"
#Include "TopConn.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ 			บAutor:Jose Roberto - Oliminet			20/03/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Duplica dados do SZ0 modificando o codigo                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/
//------------------------
User Function DupReg()
//------------------------
Private cProDe 		:= space(LEN(SZ0->Z0_CODIGO))
Private cProAte 	:= space(LEN(SZ0->Z0_CODIGO))
Private cProDeOr 	:= space(LEN(SZ0->Z0_ORDEM))
Private cProAteOr 	:= space(LEN(SZ0->Z0_ORDEM))


//Tela para solicitar o intervalo 

DEFINE MSDIALOG oDlg TITLE "Informe o intervalo dos produtos" FROM 0,0 TO 200, 500 OF oMainWnd PIXEL

@ 020,005 SAY "Produto de:  "  PIXEL OF oDlg
@ 035,005 SAY "Produto at้: "  PIXEL OF oDlg

@ 020,180 SAY "Ordem:  "  PIXEL OF oDlg
@ 035,180 SAY "Ordem:  "  PIXEL OF oDlg


@ 020,050 GET  cProDe	  F3 "SZ0"	SIZE 100,021 OBJECT oGet 
@ 020,200 GET  cProDeOr	  			SIZE 040,021 OBJECT oGet 

@ 035,050 GET  cProAte	  F3 "SZ0"	SIZE 100,021 OBJECT oGet 
@ 035,200 GET  cProAteOr  			SIZE 040,021 OBJECT oGet 



DEFINE SBUTTON FROM 050, 020 TYPE 1 ACTION (oDlg:End(), nOpcao := 1) ENABLE OF oDlg
DEFINE SBUTTON FROM 050, 050 TYPE 2 ACTION (oDlg:End(), nOpcao := 2) ENABLE OF oDlg
oGet:SetFocus(.T.)

ACTIVATE MSDIALOG oDlg CENTERED

if ! MsgYesNo(" Este processamento irแ duplicar os registros do SZ0, modificando o codigo para (???novo)  ","Processa") 
	return
endif 


Processa( {|lEnd| DupRegA(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

return


//-----------------------------
Static Function DupRegA()
//-----------------------------

dbselectarea("SZ0")
//Filtrar
Set Filter to SZ0->Z0_CODIGO+SZ0->Z0_ORDEM  >= cProDe+cProdeOr .And. SZ0->Z0_CODIGO+SZ0->Z0_ORDEM <= cProAte+cProAteOr

COPY TO "SZ0___.DBF"
DbUseArea(.T., , "SZ0___.DBF", "TRB", .F.)

dbSelectArea("TRB")
ProcRegua(RecCount())

do While TRB->(!EOF() )
	IncProc("Processando codigo   : "+TRB->Z0_CODIGO)
	If lEnd
		MsgInfo(cCancela,"Fim")
		Exit
	Endif
	
	RecLock("TRB", .F.)
	TRB->Z0_CODIGO   :=  alltrim(TRB->Z0_CODIGO)+"NOVO"
	TRB->(MsUnlock())
	
	TRB->(DBSKIP())
Enddo

TRB->(dbCloseArea())

dbSelectArea("SZ0")
APPEND FROM "SZ0___.DBF"
FErase("SZ0___.DBF")

return
