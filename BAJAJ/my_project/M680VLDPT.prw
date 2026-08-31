#Include "Protheus.ch"
#Include "Prtopdef.ch"
#Include "Rwmake.Ch"
User Function M680VLDPT()

Local _cxQry     := ""                                                                          
Local _axArea    := FwGetArea()
Local _cxAlias   := ""
Private xcEnter  := CHR(13)+CHR(10)

If inclui

// PRIMEIRA CONSULTA PARA VALIDAR OS SALDOS DOS COMPONENTES EMPENHADOS
_cxQry     := "   SELECT * FROM ( " + xcEnter
_cxQry     += "   SELECT  " + xcEnter
_cxQry     += "   		B1_LOCALIZ, BF_QUANT QUANT, D4_QTDEORI/C2_QUANT USO,  D4_OP, D4_LOCAL, D4_COD, D4_FILIAL, D4_QTDEORI, D4_QUANT, D4_QTSEGUM, D4_PRODUTO, D4_ROTEIRO, SD4.R_E_C_N_O_ REC " + xcEnter
_cxQry     += "   FROM " + RetSqlName("SD4") + " SD4 (NOLOCK) " + xcEnter
_cxQry     += "   INNER JOIN " + RetSqlName("SC2") + " SC2 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND C2_FILIAL = D4_FILIAL AND SC2.D_E_L_E_T_ = '' " + xcEnter
_cxQry     += "   INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = '' AND B1_LOCALIZ  = 'S' AND B1_FILIAL = D4_FILIAL " + xcEnter
_cxQry     += "   		AND B1_TIPO <> 'PI' " + xcEnter
_cxQry     += "   INNER JOIN ( " + xcEnter
_cxQry     += "   		SELECT BF_FILIAL, BF_LOCAL, BF_PRODUTO , BF_LOCALIZ, SUM(BF_QUANT) BF_QUANT FROM SBF010 SBF (NOLOCK) " + xcEnter
_cxQry     += "   		WHERE SBF.D_E_L_E_T_ = '' " + xcEnter
_cxQry     += "   		AND BF_LOCAL = '30' " + xcEnter
_cxQry     += "   		GROUP BY BF_FILIAL, BF_LOCAL, BF_PRODUTO , BF_LOCALIZ " + xcEnter
_cxQry     += "   )  SBF " + xcEnter
_cxQry     += "   		ON BF_FILIAL = D4_FILIAL AND BF_PRODUTO = D4_COD AND BF_LOCAL = D4_LOCAL " + xcEnter
_cxQry     += "   WHERE D4_OP = '" + M->H6_OP + "' " + xcEnter
_cxQry     += "   		AND SD4.D_E_L_E_T_ = '' " + xcEnter
_cxQry     += "   		AND D4_LOCAL = '30' " + xcEnter
//_cxQry     += "   		AND D4_FILIAL = '" + M->H6_FILIAL + "' " + xcEnter

_cxQry     += "   UNION ALL " + xcEnter

_cxQry     += "   SELECT " + xcEnter
_cxQry     += "   		B1_LOCALIZ, B2_QATU QUANT, D4_QTDEORI/C2_QUANT USO,  D4_OP, D4_LOCAL, D4_COD, D4_FILIAL, D4_QTDEORI, D4_QUANT, D4_QTSEGUM, D4_PRODUTO, D4_ROTEIRO, SD4.R_E_C_N_O_ REC " + xcEnter
_cxQry     += "   FROM " + RetSqlName("SD4") + " SD4 (NOLOCK) " + xcEnter
_cxQry     += "   INNER JOIN " + RetSqlName("SC2") + " SC2 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND C2_FILIAL = D4_FILIAL AND SC2.D_E_L_E_T_ = '' " + xcEnter
_cxQry     += "   INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = '' AND B1_LOCALIZ  = 'N' AND B1_FILIAL = D4_FILIAL " + xcEnter
_cxQry     += "   		AND B1_TIPO <> 'PI' " + xcEnter
_cxQry     += "   INNER JOIN ( " + xcEnter
_cxQry     += "   		SELECT B2_FILIAL, B2_LOCAL, B2_COD , '' B2_LOCALI, SUM(B2_QATU) B2_QATU FROM SB2010 SB2 (NOLOCK) " + xcEnter
_cxQry     += "   		WHERE SB2.D_E_L_E_T_ = '' " + xcEnter
_cxQry     += "   		AND B2_LOCAL = '30' AND  B2_QATU > 0 " + xcEnter
_cxQry     += "   		GROUP BY B2_FILIAL, B2_LOCAL, B2_COD  " + xcEnter
_cxQry     += "   )  SBF " + xcEnter
_cxQry     += "   		ON  B2_FILIAL = D4_FILIAL AND B2_COD = D4_COD AND B2_LOCAL = D4_LOCAL " + xcEnter
_cxQry     += "   WHERE D4_OP = '" + M->H6_OP + "' " + xcEnter
_cxQry     += "   		AND SD4.D_E_L_E_T_ = '' " + xcEnter
_cxQry     += "   		AND D4_LOCAL = '30' " + xcEnter
//_cxQry     += "   		AND D4_FILIAL = '" + M->H6_FILIAL + "' " + xcEnter
_cxQry     += "   ) DADOS  " + xcEnter

//CHECA SE O USO MULTIPLICADO PELA QUANTIDADE APONTADA NÃO TEM COBERTURA DO SALDO ATUAL
_cxQry     += "   WHERE USO*" + ALLTRIM(STR(M->H6_QTDPROD)) + "  > QUANT " + xcEnter

QOUT(_cxQry)
_cxAlias := MpSysOpenQuery(_cxQry)
//seleciona os itens sem saldo
dbselectarea(_cxAlias)

While !(_cxAlias)->(EOF())
	
	//VERIFICA SE TEM ALTERNATIVOS COM SALDO PARA COBRIR A PRODUCAO
	fxValida( (_cxAlias)->D4_FILIAL , (_cxAlias)->D4_COD, (_cxAlias)->USO * M->H6_QTDPROD, (_cxAlias)->REC )
	
	(_cxAlias)->(DBSKIP()	)
End

endif 

FwRestArea(_axArea)

Return Nil



Static Function fxValida( _cxFilial, _cxProd, _nxQty , _nxrec)
Local _axArea    := FwGetArea()
Local _cxQry2    := ""                                                                          
Local _cxSAlias  := ""
Local _lxDel     := .f.
Local axVetor    := {}
Local axEmpen    := {}
Local nxOpc      := 3 //Inclusao
Private lMsErroAuto := .F.
Private xcEnter  := CHR(13)+CHR(10)


_cxQry2     := "   SELECT TOP 1 * FROM ( " + xcEnter
_cxQry2     += "   	SELECT B1_LOCALIZ, GI_PRODALT, GI_TIPOCON, GI_FATOR, IIF(B1_LOCALIZ='N', B2_QATU, BF_QUANT) QUANT FROM " + RetSqlName("SGI") + " SGI1 (NOLOCK) " + xcEnter
_cxQry2     += "		INNER JOIN " + RetSqlName("SB1") + " SB11 (NOLOCK) ON SB11.B1_COD = SGI1.GI_PRODALT AND SB11.B1_FILIAL = SGI1.GI_FILIAL AND SB11.D_E_L_E_T_ = '' " + xcEnter
_cxQry2     += "		INNER JOIN " + RetSqlName("SB2") + " SB21 (NOLOCK) ON SB21.B2_COD = SGI1.GI_PRODALT AND SB21.B2_FILIAL = SGI1.GI_FILIAL AND SB21.D_E_L_E_T_ = '' AND B2_LOCAL = '30' " + xcEnter
_cxQry2     += "		LEFT JOIN ( " + xcEnter
_cxQry2     += "		SELECT BF_FILIAL, BF_LOCAL, BF_PRODUTO , BF_LOCALIZ, SUM(BF_QUANT) BF_QUANT FROM " + RetSqlName("SBF") + " SBF (NOLOCK) " + xcEnter
_cxQry2     += "		WHERE SBF.D_E_L_E_T_ = '' " + xcEnter
_cxQry2     += "		AND BF_LOCAL = '30' " + xcEnter
_cxQry2     += "		GROUP BY BF_FILIAL, BF_LOCAL, BF_PRODUTO , BF_LOCALIZ " + xcEnter
_cxQry2     += "		)  SBF  " + xcEnter
_cxQry2     += "		ON BF_FILIAL = GI_FILIAL AND BF_PRODUTO = GI_PRODALT  " + xcEnter
_cxQry2     += "		WHERE GI_PRODORI = '" +_cxProd+ "' " + xcEnter
_cxQry2     += "		AND SGI1.D_E_L_E_T_ = '' " + xcEnter
_cxQry2     += "		AND SGI1.GI_FILIAL = '" + _cxFilial + "' " + xcEnter

_cxQry2     += "		UNION  " + xcEnter

_cxQry2     += "	select B1_LOCALIZ, GI_PRODORI, GI_TIPOCON, GI_FATOR, IIF(B1_LOCALIZ='N', B2_QATU, BF_QUANT) QUANT from " + RetSqlName("SGI") + " SGI2 (NOLOCK) " + xcEnter
_cxQry2     += "		INNER JOIN " + RetSqlName("SB1") + " SB11 (NOLOCK) ON SB11.B1_COD = SGI2.GI_PRODORI AND SB11.B1_FILIAL = SGI2.GI_FILIAL AND SB11.D_E_L_E_T_ = '' " + xcEnter
_cxQry2     += "		INNER JOIN " + RetSqlName("SB2") + " SB21 (NOLOCK) ON SB21.B2_COD = SGI2.GI_PRODORI AND SB21.B2_FILIAL = SGI2.GI_FILIAL AND SB21.D_E_L_E_T_ = '' AND B2_LOCAL = '30' " + xcEnter
_cxQry2     += "		LEFT JOIN ( " + xcEnter
_cxQry2     += "		SELECT BF_FILIAL, BF_LOCAL, BF_PRODUTO , BF_LOCALIZ, SUM(BF_QUANT) BF_QUANT FROM " + RetSqlName("SBF") + " SBF (NOLOCK) " + xcEnter
_cxQry2     += "		WHERE SBF.D_E_L_E_T_ = '' " + xcEnter
_cxQry2     += "		AND BF_LOCAL = '30' " + xcEnter
_cxQry2     += "		GROUP BY BF_FILIAL, BF_LOCAL, BF_PRODUTO , BF_LOCALIZ " + xcEnter
_cxQry2     += "		)  SBF  " + xcEnter
_cxQry2     += "		ON BF_FILIAL = GI_FILIAL AND BF_PRODUTO = GI_PRODORI " + xcEnter
_cxQry2     += "		WHERE GI_PRODALT = '" +_cxProd+ "'" + xcEnter
_cxQry2     += "		AND SGI2.D_E_L_E_T_ = '' " + xcEnter
_cxQry2     += "		AND SGI2.GI_FILIAL = '" + _cxFilial + "' " + xcEnter
_cxQry2     += "		) DADOS " + xcEnter

_cxQry2     += "		WHERE QUANT > IIF(GI_TIPOCON = 'M',1*GI_FATOR,1/GI_FATOR) * "+ ALLTRIM(STR(_nxQty)) +" " + xcEnter
_cxQry2     += "		ORDER BY QUANT DESC "



_cxSAlias := MpSysOpenQuery(_cxQry2)
dbselectarea(_cxSAlias)

While !(_cxSAlias)->(EOF())
	
	SD4->(dbGoTo(_nxrec))
	
	axVetor:={   {"D4_COD"     , (_cxSAlias)->GI_PRODALT ,Nil},; 
            {"D4_LOCAL"   , SD4->D4_LOCAL         ,Nil},;
            {"D4_OP"      , SD4->D4_OP            ,Nil},;
            {"D4_DATA"    , SD4->D4_DATA          ,Nil},;
            {"D4_QTDEORI" , SD4->D4_QTDEORI       ,Nil},;
            {"D4_QUANT"   , SD4->D4_QUANT         ,Nil},;
            {"D4_TRT"     , SD4->D4_TRT           ,Nil},;
			{"D4_PRODUTO" , SD4->D4_PRODUTO       ,Nil},;
            {"D4_ROTEIRO" , SD4->D4_ROTEIRO       ,Nil}}
             
	AADD(aXEmpen,{   SD4->D4_QUANT                 ,;   // SD4->D4_QUANT
					 IIF((_cxSAlias)->B1_LOCALIZ == 'S','WIP',''),;  // DC_LOCALIZ
					  ""                 ,;  // DC_NUMSERI
					  0                  ,;  // D4_QTSEGUM
					 .F.}) 
	
							
	If RecLock("SD4",.F.)
		dbDelete()
		_lxDel := .T.
	EndIf
	
	MsUnLock()
	
	If _lxDel
	
		If RecLock("SD4",.t.)
		SD4->D4_COD     := axVetor[1][1][2]
        SD4->D4_LOCAL   := axVetor[1][2][2]
        SD4->D4_OP   	:= axVetor[1][3][2]     
        SD4->D4_DATA   	:= axVetor[1][4][2]   
    	SD4->D4_QTDEORI := axVetor[1][5][2]
        SD4->D4_QUANT   := axVetor[1][6][2]  
    	SD4->D4_TRT     := axVetor[1][7][2]
		SD4->D4_PRODUTO := axVetor[1][8][2]
        SD4->D4_ROTEIRO := axVetor[1][9][2]
		SD4->D4_FILIAL  := XFILIAL("SD4")
		EndIf

		MSUNLOCK()

		/*
		MSExecAuto({|x,y,z| mata380(x,y,z)},axVetor,nXOpc,aXEmpen) 

		if lMsErroAuto 
			MostraErro()
		EndIf
		*/
 	
	Endif 
	
	(_cxSAlias)->(DBSKIP()	)
End


FwRestArea(_axArea)

Return
