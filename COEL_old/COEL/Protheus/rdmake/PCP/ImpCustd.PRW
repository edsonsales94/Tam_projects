#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "TbiCode.ch"
#Include "TopConn.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ 			บAutor:Jose Roberto - Oliminet			20/03/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de dados para o SA1                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

User Function ImpVen()

Processa( {|lEnd| ImpVen(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

return


//-----------------------------
Static Function ImpVen()
//-----------------------------
Local cFile 	:= "VD.csv"
Local cNome		:= ""
Local nLi		:= 0
Local nCnt		:= 0
Local cMens		:= "LOG DE ATUALIZACAO SB1 " + CHR(13)+CHR(10)
Local aStr 		:= {{"LINHA"   , "C", 150, 0}}
Local nPosP1 	:= 0
Local nPosP2 	:= 0
Private lRetorno   	:= .T.

cArqLog    := CriaTrab(aStr, .T.)
DbUseArea(.T., , cArqLog, "LOG", .F.)

FT_FUSE(cFile) //Carrega parametros do ini

ProcRegua(3300)

do While !FT_FEOF()
	cLine := FT_FREADLN()
	nPosP1 	:= at(";",cLine)
	
	nLi++
	//pega o nome, o arquivo esta tabulado de forma irregular
	cNome 	:= Upper(alltrim(substr(cLine,1,nPosP1-1) ) )
	cTipCli	:= Upper(alltrim(substr(cLine,NposP1+1,2) ) )
	if alltrim(cTipCli) = "A;"
		cTipCli := "FA"
	endif
	
	IncProc("Linha: "+StrZero(nLi,4)+ "   Cliente: " +cNome)
	If lEnd
		MsgInfo(cCancela,"Fim")
		Exit
	Endif
	
	//pesquisa o cliente
	if !empty(cNome)
		cQry := "SELECT COUNT(*) AS QT  "
		cQry += " FROM " + RetSQLName("SA1")
		cQry += " WHERE A1_NREDUZ LIKE '" + alltrim(cNome) + "%'"
		If Select("TCLI") > 0
			TCLI->(DbCloseArea())
		EndIf
		TCQUERY cQry NEW ALIAS "TCLI"
		
		if TCLI->QT = 0
			RecLock("LOG", .T.)
			LOG->LINHA :=  "Plan.: " +cNome + "  -  NAO ENCONTRADO "
			LOG->(MsUnlock())
		endif
		
		cQry := "SELECT A1_COD, A1_LOJA, A1_NOME "
		cQry += " FROM " + RetSQLName("SA1")
		cQry += " WHERE A1_NREDUZ LIKE '" + alltrim(cNome) + "%'"
		If Select("TCLI") > 0
			TCLI->(DbCloseArea())
		EndIf
		TCQUERY cQry NEW ALIAS "TCLI"
		
		do while TCLI->(!eof())
			SA1->(dbSetOrder(1))
			if SA1->(dbseek(xFilial("SA1")+TCLI->A1_COD + TCLI->A1_LOJA ))
				RecLock("SA1", .F.)
				SA1->A1_X_ATIV3 := 	cTipCLI
				SA1->(MsUnlock())
				//log
				RecLock("LOG", .T.)
				LOG->LINHA :=  "Plan.: " +cNome + "  -  Cliente/Nome/Loja : "+TCLI->A1_COD +"/" + TCLI->A1_NOME + TCLI->A1_LOJA + "  -  ATUALIZADO "
				LOG->(MsUnlock())
			endif
			TCLI->(dbSkip())
		enddo
	endif
	
	FT_FSKIP()
	
Enddo

//fecha arquivo Ini
FT_FUSE()

dbSelectarea("LOG")
COPY TO &cArqLog SDF
cDestino := "vd.log"
frename(cArqLog,cDestino)
LOG->(E_EraseArq(cArqLog))
//WinExec( 'Notepad.exe '+cDestino )


return
