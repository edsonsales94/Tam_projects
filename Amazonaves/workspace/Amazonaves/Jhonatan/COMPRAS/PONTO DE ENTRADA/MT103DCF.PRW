#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT103DCF   ¦ Autor ¦ Jhonatan S. Lobato   ¦ Data ¦ 26/04/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Habilita botão Mais Inf. e acrescenta campos na aba DANFE     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function MT103DCF()

//Local lInclui    := PARAMIXB[1]
//Local lAltera    := PARAMIXB[2]
//Local lVisual    := PARAMIXB[3]
Local aCamposPar := PARAMIXB[4] // Traz o histórico dos campos e seus conteúdos.
Local aCamposRet := {} // Validações do usuário
Local cDi     := ""
Local cDtDi   := ""
Local cLocDes := ""
Local cUFDes  := ""
Local cDtDes  := ""
//Local cCodExp := ""
Local cNadic  := ""
Local cSqAdic := ""
//Local cCodFab := ""
Local cVtrans := ""
Local cInterm := ""
Local cPerg   := "MT103DCF"

If Len(aCamposPar) == 0 // Se estiver vazio, significa que é o primeiro clique do usuário.
  ValidPerg(cPerg)
  If !Pergunte(cPerg,.T.)
    Return
  Endif
  cDi     := MV_PAR01
  cDtDi   := MV_PAR02
  cLocDes := MV_PAR03
  cUFDes  := MV_PAR04
  cDtDes  := MV_PAR05
//cCodExp := MV_PAR06
  cNadic  := MV_PAR06
  cSqAdic := MV_PAR07  
//cCodFab := MV_PAR09
    If MV_PAR08 == 3
       MV_PAR08 := 7
    EndIf  
    If MV_PAR08 == 5
       MV_PAR08 := 9
    EndIf
  cVtrans := MV_PAR08
  cInterm := MV_PAR09

  AAdd(aCamposRet, {"F1_XNDI"  , AllTrim(Str(cDi,15))}) // Na primeira posição do array, informe o nome do campo, na segunda posição, informe o conteúdo a ser gravado.
  AAdd(aCamposRet, {"F1_XDTDI" , DtoS(cDtDi)}) 
  AAdd(aCamposRet, {"F1_XLOCDE", AllTrim(cLocDes)})
  AAdd(aCamposRet, {"F1_XUFDES", AllTrim(cUFDes)})
  AAdd(aCamposRet, {"F1_XDTDES", DtoS(cDtDes)}) 
//  AAdd(aCamposRet, {"F1_XCODEX", AllTrim(cCodExp)})
  AAdd(aCamposRet, {"F1_XNADIC", AllTrim(Str(cNadic,3))})
  AAdd(aCamposRet, {"F1_XSQADI", AllTrim(Str(cSqAdic,3))})
//  AAdd(aCamposRet, {"F1_XCODFA", AllTrim(cCodFab)})
  AAdd(aCamposRet, {"F1_XVTRAN", AllTrim(Str(cVtrans,2))})
  AAdd(aCamposRet, {"F1_XINTER", AllTrim(Str(cInterm,1))})

Else // Caso contrário, será um novo clique, assim o sistema traz o histórico do que foi definido anteriormente pelo usuário.

  If FWAlertYesNo("Informação de importação já digitada, deseja informar novamente?", "Dados Importacao")

  ValidPerg(cPerg)
  If !Pergunte(cPerg,.T.)
    Return
  Endif
  
    cDi     := MV_PAR01
    cDtDi   := MV_PAR02
    cLocDes := MV_PAR03
    cUFDes  := MV_PAR04
    cDtDes  := MV_PAR05
//    cCodExp := MV_PAR06
    cNadic  := MV_PAR06
    cSqAdic := MV_PAR07    
//    cCodFab := MV_PAR09
    If MV_PAR08 == 3
       MV_PAR08 := 7
    EndIf  
    If MV_PAR08 == 5
       MV_PAR08 := 9
    EndIf    
    cVtrans := MV_PAR08
    cInterm := MV_PAR09

//  cDtDi   := FWInputBox("Informe a Data de Registro da DI", "Digite aqui", aCamposPar[1][2])

  AAdd(aCamposRet, {"F1_XNDI"  , AllTrim(Str(cDi,15))}) // Na primeira posição do array, informe o nome do campo, na segunda posição, informe o conteúdo a ser gravado.
  AAdd(aCamposRet, {"F1_XDTDI" , DtoS(cDtDi)}) 
  AAdd(aCamposRet, {"F1_XLOCDE", AllTrim(cLocDes)})
  AAdd(aCamposRet, {"F1_XUFDES", AllTrim(cUFDes)})
  AAdd(aCamposRet, {"F1_XDTDES", DtoS(cDtDes)}) 
//  AAdd(aCamposRet, {"F1_XCODEX", AllTrim(cCodExp)})
  AAdd(aCamposRet, {"F1_XNADIC", AllTrim(Str(cNadic,3))})
  AAdd(aCamposRet, {"F1_XSQADI", AllTrim(Str(cSqAdic,3))})
//  AAdd(aCamposRet, {"F1_XCODFA", AllTrim(cCodFab)})
  AAdd(aCamposRet, {"F1_XVTRAN", AllTrim(Str(cVtrans,2))})
  AAdd(aCamposRet, {"F1_XINTER", AllTrim(Str(cInterm,1))})

  Else

    aCamposRet := aCamposPar
    
  EndIf

EndIf

Return aCamposRet

Static Function FormataData(cData)
Return SubStr(cData,7,2) + "-" + SubStr(cData,5,2) + "-" + SubStr(cData,1,4)

Static Function ValidPerg(cPerg)
	u_AMPutSx1(cPerg,"01",PADR("Numero da DI     ",29)+"?","","","mv_ch1","N",15,0,0,"C","","   ","","","mv_par01","","","","","","","","")
	u_AMPutSx1(cPerg,"02",PADR("Data Reg da DI   ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02","","","","","","","","")
	u_AMPutSx1(cPerg,"03",PADR("Local Desembaraco",29)+"?","","","mv_ch3","C",30,0,0,"C","","   ","","","mv_par03","","","","","","","","")
	u_AMPutSx1(cPerg,"04",PADR("Sigla UF Desembar",29)+"?","","","mv_ch4","C", 2,0,0,"C","","   ","","","mv_par04","","","","","","","","")
	u_AMPutSx1(cPerg,"05",PADR("Data Desembaraco ",29)+"?","","","mv_ch5","D", 8,0,0,"G","","   ","","","mv_par05","","","","","","","","")
//	u_AMPutSx1(cPerg,"06",PADR("Codigo Exportador",29)+"?","","","mv_ch6","C", 6,0,0,"G","","   ","SA2","","mv_par06","","","","","","","","")
	u_AMPutSx1(cPerg,"06",PADR("Numero da Adicao ",29)+"?","","","mv_ch6","N", 3,0,0,"C","","   ","","","mv_par06","","","","","","","","")
	u_AMPutSx1(cPerg,"07",PADR("Sequencial Adicao",29)+"?","","","mv_ch7","N", 3,0,0,"C","","   ","","","mv_par07","","","","","","","","")
//	u_AMPutSx1(cPerg,"09",PADR("Codigo Fabricante",29)+"?","","","mv_ch9","C", 6,0,0,"G","","   ","SA2","","mv_par09","","","","","","","","")
	u_AMPutSx1(cPerg,"08",PADR("Via de Transporte",29)+"?","","","mv_ch8","N", 2,0,0,"C","","   ","","","mv_par08","Maritima","Fluvial","Aerea","Rodoviaria","Meios Proprios","","","")
	u_AMPutSx1(cPerg,"09",PADR("Forma de Importac",29)+"?","","","mv_ch9","N", 1,0,0,"C","","   ","","","mv_par09","P/Conta Propria","","","","P/Conta e Ordem","","","Por Encomenda")

Return
