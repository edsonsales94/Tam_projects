#include "Protheus.ch"

/*
Data     : 13/03/23
Descricao: Relatorio de Impressao de PC por CC
Autor: Raphael Rage
*/
   

User Function INCOMR04()

	If _GetTela() == 1     
     
     _cFile := Alltrim(mv_par07) + iIf( SUBSTR(mv_par07,1)='/','','/'  )  + 'INCOMR04.CSV'
     
     _cTitulo := "Relatório de Pedido de Compra por Centro de Custo " + " Periodo de: "+ALLTRIM(DTOC(mv_par01)+" a "+DTOC(mv_par02))
     
     
     
     MsgRun('Processando Dados, Aguarde...',,{|| u_TblToExcel(_GetQry(),_cFile,,_cTitulo ) } )
  EndIf

Return

Static Function _GetTela()

Local cTitulo:= ''
Local cDesc1 := ' Esta Rotina tem Por Objetivo Efetuar a Impressão'
Local cDesc2 := ' dos Pedidos de Compras por Centro de Custo '
Local cDesc3 := ' '
Local aSay   := {}
Local aButton:= {}
Local _cPerg := PADR('INCOMR04',Len(SX1->X1_GRUPO))

ValidPerg(_cPerg)
Pergunte(_cPerg,.T.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

nOpc := 0

aAdd( aButton, { 5, .T., {|x| Pergunte(_cPerg)       }} )
aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )

FormBatch( cTitulo, aSay, aButton )

Return nOpc


Static Function ValidPerg(cPerg)
   PutSX1(cPerg,"01","Data De? "  , "Data De? "  , "Data De? "        , "mv_ch1" , "D" , 08, 0, 0, "G","",""   ,"","","mv_par01")
   PutSX1(cPerg,"02","Data Ate? " , "Data Ate? " , "Data Ate? "       , "mv_ch2" , "D" , 08, 0, 0, "G","",""   ,"","","mv_par02")
   PutSX1(cPerg,"03","CCusto De? "  , "CCusto De? "  , "CCusto De? "  , "mv_ch3" , "C" , 09, 0, 0, "G","",""   ,"","","mv_par03")
   PutSX1(cPerg,"04","CCusto Ate? " , "CCusto Ate? " , "CCusto Ate? " , "mv_ch4" , "C" , 09, 0, 0, "G","",""   ,"","","mv_par04")
   PutSX1(cPerg,"05","Num PC De? "  , "Num PC De? "  , "Num PC De? "  , "mv_ch5" , "C" , 06, 0, 0, "G","",""   ,"","","mv_par05")
   PutSX1(cPerg,"06","Num PC Ate? " , "Num PC Ate? " , "Num PC Ate? " , "mv_ch6" , "C" , 06, 0, 0, "G","",""   ,"","","mv_par06")
   PutSX1(cPerg,"07", Padr("Diretorio",29) + "?", "", ""              , "mv_ch7" , "C" , 99, 0, 0, "G","",""   ,"","","mv_par07")
   
Return Nil

Static Function _GetQry()
Local _cQry := ""
Local _cTbl := GetNextAlias()

_cQry += " SELECT C7_FILIAL, C7_NUM,CONVERT( VARCHAR , CONVERT( DATE, ISNULL(C7_EMISSAO,'') ) ,103) AS EMISSAO,C7_TIPO, C7_ITEM, C7_PRODUTO, C7_DESCCLV, C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL,C7_FORNECE, A2_NOME,C7_CC, C7_CONTA, CASE WHEN C7_QUJE = '' THEN 'PED ABERTO' WHEN C7_QUJE < C7_QUANT THEN 'PED PARCIAL' WHEN C7_QUJE = C7_QUANT THEN 'PED FECHADO' END STATUS_PED "
_cQry += " FROM " + RetSqlName('SC7') + " SC7 "
_cQry += "   Left Outer Join " + RetSqlName('SA2') + " SA2 on SA2.D_E_L_E_T_ = '' AND A2_COD = C7_FORNECE AND C7_LOJA = A2_LOJA AND C7_FILIAL = A2_FILIAL"
_cQry += " WHERE SC7.D_E_L_E_T_ = ''"
_cQry += " And C7_CC BetWeen '" + (mv_par03) + "' and '" +(mv_par04) + "'"
_cQry += " And C7_NUM BetWeen '" + (mv_par05) + "' and '" +(mv_par06) + "'"
_cQry += " And C7_EMISSAO BetWeen  '" + Dtos(mv_par01) + "' and '" + Dtos(mv_par02)+"'"


MEMOWRITE('INCOMR04',_cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(_cQry)), _cTbl, .T., .F. )

u_AtuStruct(_cTbl)

Return _cTbl

User Function AtuStruct(_cTbl)
   Local _aStru  :=  (_cTbl)->(dbStruct())
   
   For nI := 1 To Len(_aStru)
	   If _ChkCpo( _aStru[nI][01] )
	     IF _aStru[nI][02] != SX3->X3_TIPO
	        tcSetField(_cTbl, _aStru[nI][01] , SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL )
	     EndIf
	   EndIf
   Next
Return Nil

Static Function _Convert(_xRec,_xcpo)
  Local _xRet := ''
  Local _ctype := valtype(_xRec)
  
  if _cType == 'N'
     _xRet := Transform(_xRec,"@E 999,999,999.99")
  elseIf _cType == 'D'
    _xRet := DTOC(_xRec)
  Else
    _xRet := _xRec
  EndIF
  
Return _xRet

User Function TblToExcel(_cTbl, _cFile,_aCab,_cTitulo)
Local _aStru  :=  (_cTbl)->(dbStruct())
Local _aCabec := {}
Local _aDados := {} 
Local _aLin   := {}

Default _aCab := {}
Default _cTitulo := ''

IF !(_cTbl)->(Eof())
   For nI := 1 To Len(_aStru)
      IF _ChkCpo(_aStru[nI][01])
           _cAdd := SX3->X3_TITULO
      Else 
           _cdCp := _aStru[nI][01]
           _nPos := aScan(_aCab,{|y| y[01] == _cdCp })
           _cAdd :=  iIF(_nPos > 0, _aCab[_nPos,02], StrTran(_aStru[nI][01],"_"," ") ) 
      EndIf
      aAdd(_aCabec,_cAdd)
   Next
	
	While !(_cTbl)->(Eof())
	   aEval(_aStru,{|x| aAdd(_aLin, _Convert( (_cTbl)->&(x[01]) , x[01] )     )  })
	   
	   aAdd(_aDados,_aLin)
	   _aLin := {}
	   (_cTbl)->(dbSkip())
	EndDo
		
	ToExcel( _aCabec , _aDados , _cFile,_cTitulo)
	
Else
   Aviso('Atenção','Periodo Informado sem Dados para a Filial',{'Ok'})
EndIf 

Return Nil

Static Function _ChkCpo(_cCpo)
Local _lRet := .F.
   
   SX3->(dbgoTop())
   SX3->(dbSetOrder(2))
   _lRet := SX3->(dbSeek(Alltrim(_cCpo)))
   
Return _lRet

Static Function ToExcel( aCabec,aDados , _cFile,_cTit)

IF File(_cFile)
	fErase( _cFile )
EndIf
nHdl := fCreate(_cFile)

fWrite(nHdl, _cTit + Chr(13)+Chr(10) )
//For _nI := 1 to Len(aCabec)
    _cCabec := ""
	aEval(aCabec,{|c| _cCabec += c + ";" })
	_cCabec := SubStr(_cCabec,1,len(_cCabec) - 1) + Chr(13)+Chr(10)
	fWrite(nHdl, _cCabec )
//Next

For nI := 1 to Len(aDados)
	_cLine := ""
	aEval(aDados[nI], {|x|  _cLine += x + ";" })
	_cLine := SubStr(_cLine,1,len(_cLine) - 1) + Chr(13)+Chr(10)
	fWrite(nHdl, _cLine )
Next
fClose(nHdl) 
RunExcel(_cFile)
Return

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
