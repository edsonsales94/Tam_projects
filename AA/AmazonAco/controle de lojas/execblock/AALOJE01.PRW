#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*/
+-----------------------------------------------------------------------------------+
|  Programa   |  AALOJE01  |  Autor  | Wagner da Gama Correa  |  Data  |  04/08/10  |
|-----------------------------------------------------------------------------------|
|  Descricao  |  Retorna Codigo Calculado a partir do grupo de produtos informado   |
|-----------------------------------------------------------------------------------|
|  Uso        | Especifico para Clientes Microsiga                                  |
+-----------------------------------------------------------------------------------+
/*/
User Function AALOJE01()
	Local cQry
	Local nTam  := TamSX3("B1_COD")[1]
	Local cBase := AllTrim(M->B1_GRUPO)
	Local cRet  := cBase
	Local nTamCod   := 3 
	Local nInicio:= 2
	Local nFim   := 6
	Local cMascara := '000000'
	
	If Len(cBase)==3
		nTamCod := 4
		nInicio := 3
		nFim := 5
		cMascara := '00000'
	EndIf 
	If Select("TMP")>0
		TMP->(DbCloseArea("TMP"))
	EndIf
	
	cQry := "SELECT ISNULL(MAX(SUBSTRING(B1_COD,"+alltrim(str((nTamCod)))+","+alltrim(str(nFim))+")),'"+cMascara+"') SEQUEN "
	cQry += "FROM " + RetSQLName("SB1") +" WHERE SUBSTRING(B1_COD,1,"+Alltrim(str(nInicio))+") = '"+ cRet +"' AND D_E_L_E_T_<>'*' AND B1_COD NOT IN('6000069','6000078')"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TMP",.F.,.T.)
	cRet := Proximo(SEQUEN)
	dbCloseArea()
	dbSelectArea("SB1")
	//  .---------------------------------------------------------------------------------------------------.
	// |     Controle de numeração para caso haja mais de um usuário cadastrando produto simultaneamente     |
	//  '---------------------------------------------------------------------------------------------------'
	FreeUsedCode()
	Help := .T.	// Nao apresentar Help MayUse
	While !FreeForUse("SB1",PADR(cBase+cRet,nTam),.F.)
		cRet := Proximo(cRet)
		Help := .T.  // Nao apresentar Help MayUse
	Enddo
	Help := .F.	// Habilito o help novamente
Return PADR(cBase+cRet,nTam)

Static Function Proximo(cNumero)
	Local nX
	Local nPos := 0
	Local cRet := Soma1(cNumero)
	
	// Verifica o caractere que não for número
	For nX:=1 To Len(cNumero)
		If IsDigit(SubStr(cNumero,nX,1))  // Se for um número
			nPos := nX
		Else
			Exit
		Endif
	Next
	
	If nPos > 0  // Se tiver letras no número
		cRet := Soma1(SubStr(cNumero,1,nPos)) + SubStr(cNumero,nPos+1,Len(cNumero))
	Endif
	
Return cRet