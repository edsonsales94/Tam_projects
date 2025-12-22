#include "rwmake.ch"
#include "protheus.ch"
//#include "tbiconn.ch"
//#include "TbiCode.ch"
#Include "TopConn.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ 			บAutor:Rogerio Oliveira - Oliminet  	25/11/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de dados para o SA1 - campo Estado A1_X_EST     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

User Function ImpVen2()

Processa( {|lEnd| ImpVen2(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

return


//-----------------------------
Static Function ImpVen2()
//-----------------------------
Local cFile 	:= "CLI.csv"
Local cNome		:= ""
Local nLi		:= 0
Local nCnt		:= 0
Local cMens		:= "LOG DE ATUALIZACAO SA1 " + CHR(13)+CHR(10)
Local aStr 		:= {{"LINHA"   , "C", 150, 0}}
Local nPosP1 	:= 0
Local nPosP2 	:= 0
Local nVCus1 	:= ""
Local cQuery 	:= ""
Local nQRegs	:= 0
Private lRetorno   	:= .T.

IF MsgYesNo("Confirma Processamento")
	
	
	cArqLog    := CriaTrab(aStr, .T.)
	DbUseArea(.T., , cArqLog, "LOG", .F.)
	
	FT_FUSE(cFile) //Carrega parametros do ini
	
	cQuery := ""
	cQuery += " SELECT COUNT(*) AS RECS   "
	cQuery += " FROM " + RETSQLNAME("SA1")
	cQuery += " WHERE "
	cQuery += " D_E_L_E_T_ <> '*' "
	If Select("Q_A1") > 0
		Q_A1->(DbCloseArea())
	EndIf
	TcQuery cQuery New Alias "Q_A1"
	nQRegs := Q_A1->RECS
	Q_A1->(DbCloseArea())
	
	ProcRegua(nQRegs)
	
	do While !FT_FEOF()
		cLine := FT_FREADLN()
		nPosP1 	:= at(";",cLine)
		
		nLi++
		//pega o nome, o arquivo esta tabulado de forma irregular
		cCliente:= Upper(alltrim(substr(cLine,1,nPosP1-1) ) )
	    cLoja	:= Upper(alltrim(substr(cLine,NposP1+1,2) ) )
	    cEst    := Upper(alltrim(substr(cLine,NposP1+4,3) ) )
		//campo de valor
	  //	nPosP1 	:= at(";",cLine)
	
		IncProc("Cliente : " + cCliente+" "+cLoja)
		
		If lEnd
			MsgInfo(cCancela,"Fim")
			Exit
		Endif
		
		SA1->(dbSetOrder(1))
		_cCliente := alltrim(cCliente) + alltrim(cLoja)
		if SA1->(dbseek(xFilial("SA1")+_cCliente ))
			RecLock("SA1", .F.)
			SA1->A1_X_EST 	:= cEst
			SA1->(MsUnlock())
			//log
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
	WinExec( 'Notepad.exe '+GetSrvProfString("RootPath", "")+GetSrvProfString("StartPath", "")+cDestino )
	
	return
	
Else
	Return
Endif
