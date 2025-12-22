#include "Protheus.ch"

User Function AACTBR07()

Local _aCab     := {}
Local _cdTitulo := "Diferença Entre Contabilidade e Financeiro"
Local _cdFile   := ""

If _GetTela() == 1
   _cdFile   := AllTrim(mv_par06) + "\" + AllTrim(mv_par07) + ".xls"
   Processa( {|| _Excel(_GetQry() , _aCab , _cdTitulo  , _cdFile ) }, "Processando..." )
EndIf

Return Nil


Static Function _Excel(_cTbl,_aCab,_cdTitulo ,_cdFile )

Local _aStru  :=  (_cTbl)->(dbStruct())
Local oExcel  := FWMSEXCEL():New()
Local _cWork  := _cdTitulo
Local _aCol   := {}
Local _cdTbl  := _cdTitulo

Default _aCab := {{"",""}}

oExcel:AddworkSheet( _cWork )
oExcel:AddTable( _cWork, _cdTbl)

For _ndI := 1 To Len(_aStru)
	
	_cdCp := _aStru[_ndI][01]
	_nPos := aScan(_aCab,{|y| y[01] == _cdCp })
	
	If _nPos > 0
	   _cAdd :=  _aCab[_nPos,02] 
	Elseif _ChkCpo(_aStru[_ndI][01])
		_cAdd := SX3->X3_TITULO
	Else
	   _cAdd := StrTran(_aStru[_ndI][01],"_"," ")
	EndIf
	
	_ndAlign  := iIf(_aStru[_ndI][02] $ 'N',3, iIf(_aStru[_ndI][02] $ 'D' ,2, 1) )
	_ndFormat := iIf(_aStru[_ndI][02] $ 'N',2, iIf(_aStru[_ndI][02] $ 'D' ,4, 1) )
	_ldTotal  := iIf(_aStru[_ndI][01] $ 'VALOR',.T.,.F. )
	oExcel:AddColumn(_cWork, _cdTbl, _cAdd , _ndAlign, _ndFormat, _ldTotal )
	aAdd(_aCol,_cAdd)
Next

ProcRegua(0)

While !(_cTbl)->(Eof())

   IncProc()
   _adLinha := {}
   For _ndI := 1 To Len(_aStru)
       If _aStru[_ndI][02] == "D"
          aAdd(_adLinha, DTOC( (_cTbl)->&(_aStru[_ndI][01]) ) )
       Else
          aAdd(_adLinha, (_cTbl)->&(_aStru[_ndI][01])  )   
       EndIf       
   Next
   oExcel:AddRow(_cWork, _cdTbl, _adLinha )
   (_cTbl)->(dbSkip())                                                      	
EndDo

oExcel:Activate()
oExcel:GetXmlFile(_cdFile)

RunExcel(_cdFile)
Return Nil


Static Function _ChkCpo(_cCpo)
Local _lRet := .F.

SX3->(dbgoTop())
SX3->(dbSetOrder(2))
_lRet := SX3->(dbSeek(Alltrim(_cCpo)))

Return _lRet

Static Function _GetTela()

Local cTitulo:= ''
Local cDesc1 := ' Esta Rotina tem Por Objetivo Efetuar a Impressão '
Local cDesc2 := ' dos Itens Divergentes Entre Contabilidade e Financeiro '
Local cDesc3 := '                       '
Local aSay   := {}
Local aButton:= {}
Local _cPerg := PADR('AACTBR02',Len(SX1->X1_GRUPO))

ValidPerg(_cPerg)
Pergunte(_cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

nOpc := 0

aAdd( aButton, { 5, .T., {|x| Pergunte(_cPerg)      }} )
aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )

FormBatch( cTitulo, aSay, aButton )

Return nOpc


Static Function _GetQry()

Local _cQry   := ""
Local _cTbl   := GetNextAlias()
Local _cdTipo := FormatIn(mv_par03,';')



_cQry := " Exec FV_DIF_CTB_FINANCEIRO_PAGAR" + cEmpAnt + " '" + dtos(mv_par01) + "','" + dtos(mv_par02) + "','" + mv_par05 + "','" + mv_par04  + "','" + mv_par03 + "','" + iIf(mv_par09==01,"D","C") + "','" + iIf(mv_par10==01,"NA","EX") + "' "

//_cQry += Chr(13) + Chr(10) + " compute sum(CT2_VALOR),Sum(CT2_VALOR-Case When isNull(E1_VLRREAL,0) = 0 Then isNull(E1_VALOR,0) Else isNull(E1_VLRREAL,0) End),Sum(E1_VALOR)



MEMOWRITE('AACTBR07.SQL',_cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,, _cQry ), _cTbl, .T., .F. )

Return _cTbl

Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Data De",29)+"?","","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par01")
PutSX1(cPerg,"02",PADR("Data Ate",29)+"?","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_Par02")

PutSX1(cPerg,"03",PADR("Considerar Tipo : ",29)+" ","","","mv_ch3","C",99,0,0,"G","","   ","","","mv_Par03")

PutSX1(cPerg,"04",PADR("Conta de Debito/Credito ",29)+"?","","","mv_ch4","C",12,0,0,"G","","CT1","","","mv_par04")
PutSX1(cPerg,"05",PADR("Lote Contabil"   ,29)+"?","","","mv_ch5","C",10,0,0,"G","","   ","","","mv_Par05")

PutSX1(cPerg,"06", Padr("Diretorio ",29) +"?", "", "" , "mv_ch6" , "C" ,99, 0, 0, "G","","","","","mv_par06")
PutSX1(cPerg,"07", Padr("Nome Arquivo",29) +"?", "", "" , "mv_ch7" , "C" ,99, 0, 0, "G","","","","","mv_par07")

PutSX1(cPerg,"08", Padr("Apenas Diferenças",29) +"?", "", "" , "mv_ch8" , "N" ,1, 0, 0, "C","","","","","mv_par08","Sim","Sim","SIm","","Nao","Nao","Nao")
PutSX1(cPerg,"09", Padr("Tipo Conta ",29) +"?", "", "" , "mv_ch9" , "N" ,1, 0, 0, "C","","","","","mv_par09","Debito","Debito","Debito","","Credito","Credito","Credito")
PutSX1(cPerg,"10", Padr("Tipo Fornecedor",29) +"?", "", "" , "mv_chA" , "N" ,1, 0, 0, "C","","","","","mv_par10","Nacionais","Nacionais","Nacionais","","Internacionais","Internacionais","Internacionais")

//PutSX1(cPerg,"13",PADR("Divergencia Saldo (Atual x Resultante) ",29)+"?","","","mv_che","N",1,0,0,"C",""," ","","","mv_Par13","Sim","Sim","SIm","","Nao","Nao")
Return Nil

Static Function RunExcel(cwArq)
Local oExcelApp
Local aNome := {}

If ! ApOleClient( 'MsExcel' ) //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf
oExcelApp := MsExcel():New()  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open(cwArq)
oExcelApp:SetVisible(.T.)     // Abre o Excel com o arquivo criado exibido na Primeira planilha.
oExcelApp:Destroy()

Return