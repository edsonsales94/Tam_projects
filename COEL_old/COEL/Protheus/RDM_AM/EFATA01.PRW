#include "rwmake.ch"

User Function EFATA01()

Local _nQtd01 , _nQtd02 , _nQtd03 , _nQtd04, _nQtd05, _nQtd06, _nTotal , _nPos , _cProduto

_cAlias    := alias()
_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "C6_PRODUTO"})
_cProduto  := aCols[n,_nPos]
_cRot  := AllTrim(FunName())

dbselectarea("SB1")
dbseek(xFilial() + _cProduto)
dbselectarea("SB2")
aSaldos:= CalcEst(_cPRODUTO,"01",dDataBase)
_nQtd01:= aSaldos[1]

DBUSEAREA(.T.,"TOPCONN","SB2030","SB2030",.T.)
TcCanOpen("SB2030","SB20301")
ORDLISTADD("SB20301")

DbSeek(xFilial("SB2")+_cPRODUTO+"02")
_nQtd02:= B2_QATU

DbSeek(xFilial("SB2")+_cPRODUTO+"03")
_nQtd03:= B2_QATU

DbSeek(xFilial("SB2")+_cPRODUTO+"04")
_nQtd04:= B2_QATU

DbSeek(xFilial("SB2")+_cPRODUTO+"05")
_nQtd05:= B2_QATU

DbSeek(xFilial("SB2")+_cPRODUTO+"06")
_nQtd06:= B2_QATU

_nTotal:= _nQtd01 + _nQtd02 + _nQtd03 + _nQtd04 + _nQtd05 + _nQtd06

//aSaldos:= CalcEst(_cPRODUTO,"02",dDataBase)
//_nQtd02:= aSaldos[1]
//aSaldos:= CalcEst(_cPRODUTO,"03",dDataBase)
//_nQtd03:= aSaldos[1]
//_nTotal:= _nQtd01 + _nQtd02 + _nQtd03

If _cRot <> "RFATM01"
	@ 106,42 TO 353,515 DIALOG oDlg TITLE "Saldos em Estoque"
	@ 8,10 TO 104,222
	@ 111,014 BMPBUTTON TYPE 1 ACTION close(oDlg)
	@ 13,14 SAY alltrim(_cProduto) + " " + SB1->B1_DESC
	@ 23,14 SAY "Local 01 = " + str(_nQtd01,10,2) + "  Sao Paulo"
	@ 33,14 SAY "Local 02 = " + str(_nQtd02,10,2) + "  Manaus   "
	@ 43,14 SAY "Local 03 = " + str(_nQtd03,10,2) + "  Logistica"
	@ 53,14 SAY "Local 04 = " + str(_nQtd04,10,2) + "  Revenda"
	@ 63,14 SAY "Local 05 = " + str(_nQtd05,10,2) + "  Assist. Tecnica"
	@ 73,14 SAY "Local 06 = " + str(_nQtd06,10,2) + "  Lei Hanan"
	@ 83,14 SAY "------------------------"
	@ 93,14 SAY "Total     = " + str(_nTotal,10,2)
	ACTIVATE DIALOG oDlg
EndIf          

DbCloseArea("SB2030")
dbselectarea(_cAlias)

Return(.t.)


