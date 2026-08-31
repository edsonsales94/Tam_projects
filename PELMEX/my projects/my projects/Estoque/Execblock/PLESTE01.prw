#Include "rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"

/*_____________________________________________________________________________
¦ Função    ¦ PlEstE01   ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 19/11/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Validação da Abertura da OP													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTE01()

	Local cFuncao := Upper(Alltrim(FunName()))
	Local lRet := .T.
	/*Local cAlias := Alias()
	Local cTexto :=""
	Local lValSaldo:= GetMv("PL_SLDPOP") //Verifica se deve validar ou não o saldo de estoque na inclusão da OP // By Ulisses Junior 08/02/18
	Private oFont, oMemo, oConf

	If cFuncao = "MATA650" .and. Inclui .and. lValSaldo

		cQuery := " SELECT G1_FILIAL,G1_COD, G1_COMP, B1_TIPO,G1_QUANT, G1_INI, G1_FIM,B2_QATU, B2_QEMP"
		cQuery += " FROM " + RetSQLName("SG1") + " As G1"
		cQuery += " LEFT JOIN (SELECT 	B2_FILIAL, B2_COD,SUM(B2_QATU) AS B2_QATU, SUM(B2_QEMP) AS B2_QEMP" 
		cQuery += " FROM " + RetSQLName("SB2") + " As B2"
		cQuery += " WHERE B2.D_E_L_E_T_ = ''"
		cQuery += " And B2_FILIAL = '" + SB2->(xFilial()) + "'"

		//LOCAIS DE ESTOQUE DE ONDE SERÃO CONSULTADOS OS SALDOS
		cQuery += " And B2_LOCAL IN ('01','10')"  

		cQuery += " GROUP BY B2_FILIAL, B2_COD) AS SB2"
		cQuery += " ON G1.G1_FILIAL = SB2.B2_FILIAL AND G1.G1_COMP = SB2.B2_COD"
		cQuery += " INNER JOIN " + RetSQLName("SB1") + " As B1"
		cQuery += " ON G1.G1_COD = B1.B1_COD And B1.D_E_L_E_T_ = '' "   
		cQuery += " And B1_FILIAL = '" + SB1->(xFilial()) + "'"
		cQuery += " Where G1.D_E_L_E_T_ = ''"
		cQuery += " And G1_FILIAL = '" + SG1->(xFilial()) + "'"
		cQuery += " And G1_COD = '" + M->C2_PRODUTO + "'"
		cQuery += " And '" + Dtos(dDataBase) + "' Between G1_INI And G1_FIM"
		cQuery += " And Left(G1_COMP, 3) <> 'MOD'"

		//CASO QUEIRA VALIDAR O TIPO DO PRODUTO PAI
		//cQuery += " And B1_TIPO = 'PA'"  

		cQuery += " And (B2_QATU - B2_QEMP) < G1_QUANT * " + AllTrim(Str(M->C2_QUANT))

		TCQUERY cQuery NEW ALIAS "TSG1"

		lRet := TSG1->(Eof())
		TSG1->(dbGoTop())

		//Trecho incluído por Ulisse Jr em 04/12/08 para gerar log de itens insuficientes
		While !TSG1->(Eof())

			cTexto += "Comp.: "+TSG1->G1_COMP+" Qtd. Necessaria : "+str(TSG1->G1_QUANT*M->C2_QUANT,15,4)+" Qtd. Disponível : "+str(TSG1->(B2_QATU - B2_QEMP),15,4)+chr(13)+chr(10)

			TSG1->(dbSkip())
		End
		//
		TSG1->(dbCloseArea())

		If !lRet
			Aviso("Atencao","Existe(m) componente(s) sem saldo suficiente para produção!",{"OK"})
			//Ulisses Jr em 09/12/08
			oFont:= TFont():New("ARIAL",07,15)

			@ 000,000 To 300,500 Dialog oDlgMemo Title "Log de Apontamento"
			@ 001,003 Get cTexto  Size 240,130  MEMO Object oMemo When .F.
			oMemo:oFont:=oFont

			@ 140,170 BmpButton Type 1 Action CLOSE(oDLGMEMO) Object oConf

			Activate Dialog oDlgMemo CENTERED On Init (oMemo:SetFocus())
			//
		EndIf

	EndIf

	dbSelectArea(cAlias)
*/
Return lRet                                                 
/*_____________________________________________________________________________
¦ Função    ¦ PlEstE02   ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 23/11/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Validação do Apontamento de Produção										¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


User Function PLESTE02()

	Local cFuncao := Upper(Alltrim(FunName()))
	Local lRet := .T.
	/*Local cAlias := Alias()         
	Local cPodPa := GetMv("MV_XAPONOP") 
	Local cXVALEMP := GETMV("MV_XVALEMP")

	SC2->(dbSetOrder(1))   

	If cFuncao = "MATA250" .and. Inclui

		SC2->(dbSeek(xFilial()+M->D3_Op))
		SB1->(dbSeek(xFilial()+SC2->C2_PRODUTO))

		IF cXVALEMP !="S" .AND. POSICIONE("SD4",2,XFILIAL("SD4")+M->D3_OP,"D4_QUANT") <=0   
			Alert("OP " + M->D3_OP + "Não possui Empenho. Verifique o Ajuste de Empenhos ou Estrutura do Produto.", "ATENÇÃO!!!")
			lRet := .f.
		ENDIF

		//Incluído Jean Vicente 07/02/2011
		If SB1->B1_TIPO = "PA" .And. cPodPa == "N"
			Aviso("Atencao","Produto não pode ser do tipo PA!",{"OK"})
			lRet := .f.                  // wermeson em 19/10 devido problema com a pistolagem pepois voltar 
		ElseIF	!Empty(M->D3_Op);
		.And.	!Empty(M->D3_Cod);
		.And.	SB1->B1_xGanho <> "S";
		.And.	(M->D3_Quant + M->D3_Perda) > (SC2->C2_Quant - SC2->C2_QuJE)

			Aviso("Atencao","Produção maior que Saldo da OP!",{"OK"})
			lRet := .f.

		End If

	End If

	dbSelectArea(cAlias)
*/	
Return lRet                                                 

