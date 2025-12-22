#include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function MT100AGR()

Local aArea			:= GetArea()
Local cQuery 		:= ""
Private _cLocaliz   := "" //Substr(Alltrim(GETMV("MV_DISTAUT")),3)
Private cArmRes 	:= Alltrim(GETMV("MV_XARMRES"))
Private aEnderec	:= {}
Private cArmPux 	:= Substr(Alltrim(GETMV("MV_DISTAUT")),3)

//Query para verificar os itens a endereçar da nota que esta sendo dada entrada 

If GetMv("MV_LOCALIZ") == 'S'
	aEnderec := StrTokArr(Alltrim(GetMv("MV_XARMAUT")), "/" )
	cQuery += "SELECT DA_FILIAL,DA_PRODUTO,DA_QTDORI,DA_SALDO,DA_LOCAL,DA_DOC,DA_NUMSEQ,DA_DATA,D1_QUANT,D1_ITEM "
	cQuery += "FROM "+RetSqlName("SDA")+" A "
	cQuery += "INNER JOIN "+RetSQLName("SD1")+" D1 ON D1.D_E_L_E_T_='' "
	cQuery += "AND D1.D1_DOC=A.DA_DOC "
	cQuery += "AND D1.D1_SERIE=A.DA_SERIE "
	cQuery += "AND D1.D1_FORNECE=A.DA_CLIFOR "
	cQuery += "AND D1.D1_COD=A.DA_PRODUTO "
	cQuery += "AND D1.D1_LOCAL=A.DA_LOCAL "
	cQuery += "AND D1.D1_LOTECTL=A.DA_LOTECTL "
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
	//cQuery += "DA_LOCAL IN ('10','02') AND "   
	//cQuery += "DA_LOCAL IN ('TR') AND "   
	cQuery += "DA_QTDORI = DA_SALDO AND "
	cQuery += "A.D_E_L_E_T_ = '' "          
	
	
	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	Endif
	
	TcQuery cQuery Alias "TRB" New
	
	
	If TRB->(Eof())
		RestArea(aArea)
		Return()
	Else
		TRB->(dbGoTop())
		While !TRB->(Eof())
			/*SB2->(DbSetOrder(1))                                   
			//B2_FILIAL + B2_COD + B2_LOCAL
			If ! SB2->(dbSeek(xFilial("SB2")+TRB->DA_PRODUTO+TRB->DA_LOCAL))
				RecLock("SB2",.t.)
				SB2->B2_FILIAL := xFilial("SB2")
				SB2->B2_COD    := TRB->D1_COD
				SB2->B2_LOCAL  := TRB->DA_LOCAL
				MsUnlock()
			EndIf*/
			If Alltrim(TRB->DA_LOCAL)=="03"
				_cLocaliz:=aEnderec[1]
			ElseIf Alltrim(TRB->DA_LOCAL)=="14"
				_cLocaliz:=aEnderec[2]
			ElseIf Alltrim(TRB->DA_LOCAL)=="16"
				_cLocaliz:=aEnderec[3]
			ElseIf Alltrim(TRB->DA_LOCAL)=="60"
				_cLocaliz:=aEnderec[4]
			ElseIf Alltrim(TRB->DA_LOCAL)$"10,02,22,23,24,25,04,28,27,29,41,42,43,44,47,48" .And. xFilial("SD4")$"00,05,01,04,06,07,09,10"
				_cLocaliz:=cArmRes
			ElseIf Alltrim(TRB->DA_LOCAL)=="TR"
				_cLocaliz:=cArmPux
			EndIf			
			
			
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
			{"DB_ESTORNO"	,"  "		,NIL},;
			{"DB_LOCALIZ"	,_cLocaliz		,NIL},;
			{"DB_QUANT"		,TRB->D1_QUANT	,NIL},;
			{"DB_DATA"		,STOD(TRB->DA_DATA),NIL}})
			
			MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,3) //Distribui
			
			If lMsErroAuto
				Alert("Erro_Distr_Distrib: "+TRB->DA_DOC)
				MostraErro()
			EndIf
			TRB->(dbSkip())
		EndDo
		
	EndIf
	RestArea(aArea)
EndIf
Return
