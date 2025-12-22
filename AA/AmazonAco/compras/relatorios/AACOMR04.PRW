#include "Protheus.ch"
#include "Totvs.ch"



User Function AACOMR04()
     
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "Entradas"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 136
Private tamanho     := "G"
Private nomeprog    := "AACOMR04" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "AACOMR04"
Private cString     := " "
Private cPErg       := PADR("AACOMR04",Len(SX1->X1_GRUPO))

//_setPergunte(cPerg)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Pergunte(cPerg,.F.)

_cdFile := Alltrim(mv_par07)
_cdFile += If( Right(_cdFile,1) $ "\/" ,"","\") + Alltrim(mv_par08)
   
_cdTbl := _getTable()
//If mv_par06 == 01 .OR. mv_par06 == 03      
Processa( {|| _Excel( _cdTbl , _cdFile , {} ) } ," Gerando Dados no Excel, Aguarde...")
//EndIf

Return Nil

Static Function RunReport(Cabcec1,Cabec2,Titulo,nLin)
   
   
   
   _cdTbl := _getTable()
   
   Cabec1 := " Codigo     Documento           Movimento    QTD C.MEDIO QTD FIFO  DIFERENCA   "
    
   
   If Li > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Li := 8
   Endif
   
   SetRegua(nCont)
   
   While !(_cdTbl)->(EOf())
       
       
       
       (_cdTbl)->(dbSkip())
   EndDo
   
   SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return


Static Function _setPergunte(cPerg)
  //PutSX1(cPerg, "01", "Data Refência?" , "Data Refência?" , "Data Refência?"  , "mv_ch1", "D",08, 0, 0, "G", "", "", "", "", "mv_par01")
  //PutSX1(cPerg, "02", "Data Ate?", "Data Ate?", "Data Ate?" , "mv_ch2", "D",08, 0, 0, "G", "", "", "", "", "mv_par02")
  //PutSX1(cPerg, "01", "Diretorio", "Diretorio", "Diretorio" , "mv_ch2", "C",99, 0, 0, "G", "", "", "", "", "mv_par02")
  //PutSX1(cPerg, "02", "Arquivo"  , "Arquivo"  , "Arquivo"   , "mv_ch3", "C",99, 0, 0, "G", "", "", "", "", "mv_par03")
 
Return Nil

Static Function _Excel(_cTbl,_cFile,_aCab)

	Local _aStru  :=  (_cTbl)->(dbStruct())
	Local oExcel  := FWMSEXCEL():New()
	Local _cWork  := "Entradas"
	Local _aCol   := {}
	Local _cdTbl  := _cWork  + ':' //+ DTOC(MV_PAR01)       // + '-' +  DTOC(MV_PAR02)

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
		_ldTotal  := iIf(_aStru[_ndI][02] $ 'N',.T.,.F. )
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
	oExcel:GetXmlFile(_cFile)
	oExcel:DeActivate()
    RunExcel(_cFile)
Return Nil

Static Function _ChkCpo(_cCpo)
	Local _lRet := .F.
   
	SX3->(dbgoTop())
	SX3->(dbSetOrder(2))
	_lRet := SX3->(dbSeek(Alltrim(_cCpo)))
   
Return _lRet


Static Function _getTable() 
    
    Local cQry := ""
    Local _cTbl  := getNextAlias()
    
	//+-------------------------------------------------------------+
	//| Query para geracao do relatorio  							|
	//+-------------------------------------------------------------+
	_cdQry := ""
	_cdQry := " Exec AA_SUGESTCOMPRA12 " 
//    _cdQry += " '" + MV_PAR01  + "' , '" + MV_PAR02  + "',"
//    _cdQry += " '" + MV_PAR03 + "' , '" + MV_PAR04 + "'," 
//    _cdQry += " '" + MV_PAR05  + "' , '" + MV_PAR06  + "', "
//    _cdQry += " '  ', 'ZZZZ' "

     
	Memowrite('AACOMR04.SQL',_cdQry)

	//dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), _cTbl , .T., .T.)
	dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), _cTbl , .T., .T.)
	
	
	Return _cTbl
	
  
    
Return _cTab

                                                            
 
 **********************************************************************************************************************************

Static Function RunExcel(cwArq)
	Local oExcelApp
	Local aNome := {}
 
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cwArq)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.

Return

