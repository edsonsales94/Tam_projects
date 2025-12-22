#include "Protheus.ch"

User Function AACTBR01()

Local _aCab     := {}
Local _cdTitulo := "Diferença Entre Financeiro e Venda"
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

RunExcel(alltrim(mv_par03) + "\" +Alltrim(mv_par04) + ".xls")
Return Nil


Static Function _ChkCpo(_cCpo)
Local _lRet := .F.

SX3->(dbgoTop())
SX3->(dbSetOrder(2))
_lRet := SX3->(dbSeek(Alltrim(_cCpo)))

Return _lRet

Static Function _GetTela()

Local cTitulo:= ''
Local cDesc1 := ' Esta Rotina tem Por Objetivo Efetuar a Impressão'
Local cDesc2 := ' do Relatorio nos Parametros Informados'
Local cDesc3 := '                       '
Local aSay   := {}
Local aButton:= {}
Local _cPerg := PADR('AACTBR01',Len(SX1->X1_GRUPO))

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


_cQry += " Select 

_cQry += Chr(13) + Chr(10) + " E1_FILORIG,
_cQry += Chr(13) + Chr(10) + " E1_NUM,
_cQry += Chr(13) + Chr(10) + " E1_PREFIXO,
_cQry += Chr(13) + Chr(10) + " L1_CLIENTE,
_cQry += Chr(13) + Chr(10) + " L1_LOJA,
_cQry += Chr(13) + Chr(10) + " L4_VALOR,
_cQry += Chr(13) + Chr(10) + " E1_VALOR,
_cQry += Chr(13) + Chr(10) + " E1_VLRREAL,
_cQry += Chr(13) + Chr(10) + " Case When E1_VLRREAL = 0 And E1_VALOR = E1_VLRREAL then E1_VALOR Else E1_VLRREAL End - L4_VALOR DIFERENCA

_cQry += Chr(13) + Chr(10) + " from (

_cQry += Chr(13) + Chr(10) + " select 
_cQry += Chr(13) + Chr(10) + "    E1_FILORIG,E1_NUM,E1_PREFIXO,L1_CLIENTE,L1_LOJA,L4_VALOR,Sum(E1_VALOR) E1_VALOR , Sum(E1_VLRREAL) E1_VLRREAL
_cQry += Chr(13) + Chr(10) + " from " + RetSqlName("SE1") + " E1 with(nolock) "
_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName('SF2') + " SF2 WITH (NOLOCK) ON F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_FILIAL = E1_FILORIG AND SF2.D_E_L_E_T_ = '' 
_cQry += Chr(13) + Chr(10) + "   Left Outer Join(  
_cQry += Chr(13) + Chr(10) + "       Select L1_DOC,L1_FILIAL,L1_DOCPED,L1_SERIE,L1_SERPED,L1_CLIENTE,L1_LOJA,L4_FORMA,L1_EMISNF ,Sum(L4_VALOR) L4_VALOR from SL1010 L1 With(nolock)
_cQry += Chr(13) + Chr(10) + "         LEFT OUter Join " + RetSqlName('SL4') + " L4 With(nolock) on L4_NUM = L1_NUM And L4_FILIAL=L1_FILIAL And L4.D_E_L_E_T_ = ''
_cQry += Chr(13) + Chr(10) + "       Where L1.D_E_L_E_T_ = ''
_cQry += Chr(13) + Chr(10) + "         And Len(Rtrim(L1_DOC)) > 0 Or Len(Rtrim(L1_DOCPED)) > 0 
_cQry += Chr(13) + Chr(10) + " 	  group by L1_DOC,L1_FILIAL,L1_DOCPED,L1_SERIE,L1_SERPED,L1_CLIENTE,L1_LOJA,L4_FORMA,L1_EMISNF 

_cQry += Chr(13) + Chr(10) + "      )L1 On L1_DOC = F2_DOC And L1_SERIE = F2_SERIE ANd F2_FILIAL = L1_FILIAL AND L4_FORMA = E1_TIPO

_cQry += Chr(13) + Chr(10) + " Where E1_EMISSAO BetWeen '" + DTOS(mv_par01) + "' and '" + DTOS(mv_par02) + "'"
_cQry += Chr(13) + Chr(10) + " and E1_FILORIG Between '00' and '05'
_cQry += Chr(13) + Chr(10) + " and E1.D_E_L_E_T_ = ''
_cQry += Chr(13) + Chr(10) + " And Rtrim(E1_TIPO) in " + _cdTipo
_cQry += Chr(13) + Chr(10) + " And E1_ORIGEM NOT IN ('MATA100 ','FINA040 ')

_cQry += Chr(13) + Chr(10) + " group by E1_FILORIG,E1_NUM,E1_PREFIXO,L1_CLIENTE,L1_LOJA,E1_LOJA ,L4_VALOR

_cQry += Chr(13) + Chr(10) + " )A

_cQry += Chr(13) + Chr(10) + " Where L4_VALOR != E1_VLRREAL



MEMOWRITE('AACTBR01.SQL',_cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,, _cQry ), _cTbl, .T., .F. )

Return _cTbl

Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Data De",29)+"?","","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par01")
PutSX1(cPerg,"02",PADR("Data Ate",29)+"?","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_Par02")

PutSX1(cPerg,"03",PADR("Considerar Tipo : ",29)+"?","","","mv_ch3","C",99,0,0,"G","","   ","","","mv_Par03")

PutSX1(cPerg,"04",PADR("Filial De",29)+"?","","","mv_ch4","C",02,0,0,"G","","   ","","","mv_par04")
PutSX1(cPerg,"05",PADR("Filial Ate",29)+"?","","","mv_ch5","C",02,0,0,"G","","   ","","","mv_Par05")

PutSX1(cPerg,"06", Padr("Diretorio ",29) +"?", "", "" , "mv_ch7" , "C" ,99, 0, 0, "G","","","","","mv_par06")
PutSX1(cPerg,"07", Padr("Nome Arquivo",29) +"?", "", "" , "mv_ch8" , "C" ,99, 0, 0, "G","","","","","mv_par07")

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