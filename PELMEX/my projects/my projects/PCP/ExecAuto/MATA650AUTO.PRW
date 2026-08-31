#Include "Protheus.ch"
#include "rwmake.ch"
#include "TbiConn.ch"
#INCLUDE 'TOPCONN.CH'
 
User Function Tmata650()
Local aMATA650 := {} //-Array com os campos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 3 - Inclusao ³
//³ 4 - Alteracao ³
//³ 5 - Exclusao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc      := 3
Local cQuery    := ""
Local cQueryAtu := ""
Local nPK2Recno := 0

Private lMsErroAuto := .F.
 
PREPARE ENVIRONMENT EMPRESA "10" FILIAL "01"

	cQuery := " SELECT PK2_OP,PK2_PRODUTO,PK2_DESCRI,CAST(PK2_QUANT AS INT)PK2_QUANT,CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112)PK2_DTPROPEL,PK2_SETOR,PK2_RECNO "
	cQuery += " FROM PK2 "
	cQuery += " WHERE PK2_OP = '' "
	cQuery += " ORDER BY CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112),PK2_SETOR "

	IF Select("cAlias") <> 0
		DbSelectArea("cAlias")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "cAlias"

	dbSelectArea("cAlias")
	cAlias->(dbGoTop())


	While !Eof()
		
		dDataBase := cAlias->PK2_DTPROPEL
		
		aMata650 := { {"C2_FILIAL" , xFilial("SC2") ,Nil},; 
		              {"C2_PRODUTO", cAlias->PK2_PRODUTO,NIL},; 
		              {"C2_QUANT" , cAlias->PK2_QUANT ,NIL},;
		              {"C2_EMISSAO" , dDatabase ,NIL},; 
		              {"C2_DATPRI" , dDatabase ,NIL},; 
		              {"C2_DATPRF" , dDatabase+3 ,NIL},;
		              {"C2_OBS" , cAlias->PK2_OBS ,Nil},; 
		              {"AUTEXPLODE" , "S" ,NIL}}
		
		ConOut("Inicio : "+Time())
		 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se alteracao ou exclusao, deve-se posicionar no registro ³
		//³ da SC2 antes de executar a rotina automatica ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc == 3 .Or. nOpc == 5
			SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
			SC2->(DbSeek(xFilial("SC2")+cAlias->PK2_OBS+"01"+"001"))
		EndIf
		 
		msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
		
		If !lMsErroAuto
		 	ConOut("OP incluida com Sucesso! ")
		 	PK2Recno := cAlias->PK2_RECNO
		Else
		 	ConOut("Produto sem estrutura. "+cAlias->PK2_PRODUTO+" - "+cAlias->PK2_DESCRI)
		 	MostraErro()
		EndIf
		
		cQueryAtu := " UPDATE PK2 SET PK2_OP = "+Aliase->PK2_OP
		cQueryAtu += " FROM PK2 "
		cQueryAtu += " WHERE PK2_OP = '' "
		cQueryAtu += " ORDER BY CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112),PK2_SETOR "
	
		IF Select("cAliasAtu") <> 0
			DbSelectArea("cAliasAtu")
			DbCloseArea()
		ENDIF
	
		TCQUERY cQuery NEW ALIAS "cAliasAtu"
	
		dbSelectArea("cAliasAtu")
		 
		ConOut("Fim : "+Time())
		cAlias->(dbSkip())
		
	EndDo
 
RESET ENVIRONMENT
 
Return Nil
