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

User Function ImpProd()

Processa( {|lEnd| ImpPr(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

return


//-----------------------------
Static Function ImpPr()
//-----------------------------
Local cFile 	:= "Pr.csv"
Local cNome		:= ""
Local nLi		:= 0

Local nCnt		:= 0
Local cMens		:= "LOG DE ATUALIZACAO SB1 " + CHR(13)+CHR(10)
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
	cQuery += " FROM " + RETSQLNAME("SB1")
	cQuery += " WHERE "
	cQuery += " D_E_L_E_T_ <> '*' "
	If Select("Q_B1") > 0
		Q_B1->(DbCloseArea())
	EndIf
	TcQuery cQuery New Alias "Q_B1"
	nQRegs := Q_B1->RECS
	Q_B1->(DbCloseArea())
	
	ProcRegua(nQRegs)
	
	do While !FT_FEOF()
		cLine := FT_FREADLN()
		nPosP1 	:= at(";",cLine)
		
		nLi++
		//pega o nome, o arquivo esta tabulado de forma irregular
		cProd	:= Upper(alltrim(substr(cLine,1,nPosP1-1) ) )
		cLine 	:= substr(cLine ,nPosP1+1 ,len(cLine)-nPosP1)
		//campo de valor
		nPosP1 	:= at(";",cLine)
		nVCus 	:= Upper(alltrim(substr(cLine,1,nPosP1-1) ) )
		nVCus1 	:= ""
		For nYY = 1 to len(nVCus)
			if substr(nVCus,nYY,1) <> ","
				nVCus1 := nVCus1 + substr(nVCus,nYY,1)
			else
				nVCus1 := nVCus1 + "."
			endif
		Next
		nVCus := nVCus1
		
		//Campo moeda
		cMoeda	:= Upper(alltrim(substr(cLine,NposP1+1,len(cline)-nPosP1+1) ) )
		/*
		if alltrim(cMoeda) = "#N/D"
			cMoeda := "1"
		endif
		if alltrim(cMoeda) = "REAL"
			cMoeda := "1"
		endif
		if alltrim(cMoeda) = "DOLAR"
			cMoeda := "2"
		endif
		if alltrim(cMoeda) = "EURO"
			cMoeda := "5"
		endif
		*/
		IncProc("PRODUTO : " + cProd)
		
		If lEnd
			MsgInfo(cCancela,"Fim")
			Exit
		Endif
		
		SB1->(dbSetOrder(1))
		cProd := alltrim(cProd) + space(len(SB1->B1_COD)-len(alltrim(cProd)))
		if SB1->(dbseek(xFilial("SB1")+cProd ))
			RecLock("SB1", .F.)
			SB1->B1_CUSTD 	:= Val(nVCus)
			SB1->B1_MCUSTD 	:= cMoeda
			SB1->(MsUnlock())
			//log
			RecLock("LOG", .T.)
			LOG->LINHA :=  "PRODUTO..: " +cProd + "  -  Custo...." + alltrim(nVCus) +" Moeda...: " + cMoeda
			LOG->(MsUnlock())
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
	WinExec( 'Notepad.exe '+GetSrvProfString("RootPath","")+GetSrvProfString("StartPath","")+cDestino )
	
	return
	
Else
	Return
Endif
