#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
+-----------------------------------------------------------------------------------+
|  Programa   |  AAPCPC04  |  Autor  | Ulysses Ribeiro        |  Data  |  24/02/14  |
|-----------------------------------------------------------------------------------|
|  Descricao  | Retorna Número da OP Calculado		 				                |
|-----------------------------------------------------------------------------------|
|  Uso        | Especifico para Amazon Aço			                                |
+-----------------------------------------------------------------------------------+
/*/

User Function AAPCPC04()

Local aMes   := {'A','B','C','D','E','F','G','H','I','J','L','M'}
Local aLetra := {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
Local cMes   := aMes[Month(dDataBase)]
Local cAno   := Subs(Str(Year(dDAtaBase),4), 3, 2)
Local cRet   := ""
Local aArea  := GetArea()

/*
BeginSql Alias "TMP"

Select Max(C2_NUM) As Num
From %Table:SC2% SC2
Where %NotDel%
And C2_FILIAL = %xFilial:SC2%
And Substring(C2_NUM, 1, 2) = %Exp:cAno%
And Substring(C2_NUM, 3, 1) = %Exp:cMes%
EndSql 
*/

cQry := "Select Max(C2_NUM) As Num
cQry += " From "+RetSqlName("SC2")
cQry += " Where D_E_L_E_T_ = '' 
//cQry += " And C2_FILIAL = '" + xFilial("SC2")+ "' "
cQry += " And Substring(C2_NUM, 1, 2) = '" + cAno + "'
cQry += " And Substring(C2_NUM, 3, 1) = '" + cMes + "'

//dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
TCQUERY cQry NEW ALIAS 'TMP1'

If TMP1->(Eof())
	cRet := cAno + cMes + '001'
Else
	cRet := SubStr(TMP1->Num, 1,3) +  Soma1(SubStr(TMP1->Num, 4,3))
EndIf
                                                           
FreeUsedCode()		// Controle de numeração para caso haja mais de um usuário cadastrando produto simultaneamente

Help := .T.	// Nao apresentar Help MayUse

// O bloco abaixo foi comentado por Wladimir Vieira em 24/09/2018 - considerado redundante
/*&   
While !FreeForUse("SC2",cRet,.F.)
	cRet := SubStr(TMP1->Num, 1,3) +  Soma1(SubStr(TMP1->Num, 4,3),3) //Soma1(cRet, 6)
	Help := .T.  // Nao apresentar Help MayUse
Enddo
Help := .F.	// Habilito o help novamente   

*/

// Implementado por Wlad 24/09/2018 - Verifica se é leytra e se esta em posição 9 (ex: 18IB09)
//                  Wlad 26/09/2018 - Estava se perdendo quando da virada da Letra referente ao MES  
//IF SubStr(TMP1->Num, 4,1) > '9' .AND. SubStr(TMP1->Num, 6,1) == '9'
//   cRet := SubStr(TMP1->Num, 1,4)+STR(VAL(SubStr(TMP1->Num, 5,2))+1,2,0)
//       aPosletra:= aScan(aLetra,SubStr(TMP1->Num, 4,1)) // encontra a letra atual
//       aPosletra += 1  // Incrementa a letra com dados do novo vetor (aLetra que contem todas as letras do Alfabeto)
       // abaixo monta novo numero de OP, pegando 3 primeiros caracteres, incrementadondo o 4o caractere e reiniciando os dois ultimos
//       cRet := SubStr(TMP1->Num, 1,3)+aLetra[aPosletra]+"01" 
//Endif


M->C2_NUM := cRet

// Alterado por WLAD - Estava em linha acima fechando TMP e provovando erro
TMP1->(dbCloseArea())

RestArea(aArea)

Return cRet
