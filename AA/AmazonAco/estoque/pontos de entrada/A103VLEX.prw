#include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A103VLEX   ¦ Autor ¦ ADRIANO LIMA         ¦ Data ¦ 17/04/2012  ¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de validacao da exclusão da nota de entrada  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*/

User Function A103VLEX()

Local cBusca := SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
Local lRet := .T.

dbSelectArea("SZY")
dbSetOrder(4)
If dbSeek(cBusca)
	Alert("Antes de Excluir a Nota é necessário excluir a Puxada!")
	lRet := .F.
EndIf

FEstEnderec()

Return lRet

Static Function FEstEnderec()
Local cQuery 		:= ""
Local _cArmMat 		:= AllTrim( GetMv("MV_XARMMAT") )
Private _cLocaliz   := Substr(Alltrim(GETMV("MV_DISTAUT")),3)

/*Query para verificar os itens que estao endereçados para nota para efetuar o estorno
para possibilitar a exclusao da nota*/ 
 
If GetMv("MV_LOCALIZ") == 'S'
	cQuery += "SELECT DA_FILIAL,DA_PRODUTO,DA_QTDORI,DA_SALDO,DA_LOCAL,DA_DOC,DA_NUMSEQ,DA_DATA,D1_QUANT,D1_ITEM "
	cQuery += "FROM "+RetSqlName("SDA")+" A "
	cQuery += "INNER JOIN "+RetSQLName("SD1")+" D1 ON D1.D_E_L_E_T_='' "
	cQuery += "AND D1.D1_DOC=A.DA_DOC "
	cQuery += "AND D1.D1_SERIE=A.DA_SERIE "
	cQuery += "AND D1.D1_FORNECE=A.DA_CLIFOR "
	cQuery += "AND D1.D1_COD=A.DA_PRODUTO "
	cQuery += "INNER JOIN "+RetSQLName("SB1")+" B ON  "
	cQuery += "DA_PRODUTO =B1_COD AND "
	cQuery += "B.D_E_L_E_T_ = '' AND "
	cQuery += "B1_LOCALIZ = 'S' "       
	cQuery += "WHERE "
	cQuery += "DA_FILIAL = '"+xFilial("SDA")+"' AND "
	cQuery += "DA_CLIFOR = '"+SF1->F1_FORNECE+"' AND "
	cQuery += "DA_LOJA = '"+SF1->F1_LOJA+"' AND "
	cQuery += "DA_DOC = '"+SF1->F1_DOC+"' AND "
	cQuery += "DA_SERIE = '"+SF1->F1_SERIE+"' AND "
	cQuery += "DA_LOCAL='"+_cArmMat+"' AND "      
	cQuery += "DA_QTDORI = DA_SALDO AND "
	cQuery += "A.D_E_L_E_T_ = '' "          
	
	
	If Select("TRB") <> 0
		TRB->(dbCloseArea("TRB"))
	Endif
	
	TcQuery cQuery Alias "TRB" New
	
	
	If TRB->(Eof())
		//RestArea(aArea)
		Return()
	Else
		TRB->(dbGoTop())
		While !TRB->(Eof())
			lMsErroAuto := .F.
			aCab := {}
			aItem:= {}
			
			aCab:= {	{"DA_PRODUTO"	,TRB->DA_PRODUTO	,NIL},;
			{"DA_QTDORI"	,TRB->D1_QUANT	,NIL},;
			{"DA_SALDO"		,TRB->D1_QUANT	,NIL},;
			{"DA_LOCAL"		,TRB->DA_LOCAL ,NIL},;
			{"DA_DOC"		,TRB->DA_DOC	,NIL},;
			{"DA_NUMSEQ"	,TRB->DA_NUMSEQ	,NIL}}
			
			Aadd(aItem, {	{"DB_ITEM"		,TRB->D1_ITEM			,NIL},;
			{"DB_LOCALIZ"	,_cLocaliz		,NIL},;
			{"DB_QUANT"		,TRB->D1_QUANT	,NIL},;
			{"DB_ESTORNO"   ,"S"	        ,Nil},;
			{"DB_DATA"		,STOD(TRB->DA_DATA),NIL}})
			
			MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,3) //Distribui
			
			If lMsErroAuto
				Alert("Erro_Distr_Distrib: "+TRB->DA_DOC)
				MostraErro()
			EndIf
			TRB->(dbSkip())
		EndDo
		
	EndIf
	//RestArea(aArea)
EndIf
Return Nil
