#INCLUDE "rwmake.ch"
#include "Protheus.ch"

User Function M261BCHOI()
  Local _aButton := {}       

  SetKey( VK_F9 , {|| U_PLESTP13() })  // Habilita a tecla de atalho da consulta de estoque
  aAdd(_aButton, {"BPMSRECI", {||U_PLESTP13() }, "Transf Codigo.", "Transf Codigo."} )
  
Return _aButton

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PLESTP13   ¦ Autor ¦ Wagner Correa        ¦ Data ¦ 13/07/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca saldo de produtos por endereço                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTP13
             
Local cPerg  := PADR("PLESTP13", Len(SX1->X1_GRUPO))
Local cArea  := GetArea()

ValidPerg(cPerg)

If Pergunte(cPerg,.T.)
	//  .--------------------------------
	// |     mv_par01 - Produto Origem
	// |     mv_par02 - Armazem Origem
	// |     mv_par01 - Produto Destino
	//  '--------------------------------
	_fDados( mv_par01, mv_par02, mv_par03)
EndIf

Pergunte("MTA260", .F.)	

RestArea(cArea)
Return nil

//  .-----------------------------------------------------
// |     _fDados - Busca dados para carregar no aCols
//  '-----------------------------------------------------

Static Function _fDados( _cProdOrig, _cLocOri, _cEndDes)

Local _cArea := GetArea()
Local _cQry := ""

_cQry += "SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, BF_QUANT, BF_EMPENHO "
_cQry +=    "FROM " + RetSqlName("SBF") + " A "
_cQry += "WHERE A.D_E_L_E_T_ = '' "
_cQry +=    "AND BF_QUANT <> 0 "
_cQry +=    "AND BF_PRODUTO = '" + _cProdOrig + "' "
_cQry +=    "AND BF_LOCAL = '" + _cLocOri + "' "
_cQry +=    "AND BF_FILIAL = '" + xFilial("SBF") + "' "   
_cQry += "ORDER BY BF_PRODUTO"

dbUseArea(.T.,"TOPCONN", TcGenQry(,,ChangeQuery(_cQry)),"WBF",.T.,.T.)

dbSelectArea("WBF")

Memowrit("PLESTP13_1.SQL", _cQry)

dbSelectArea("WBF")
dbGoTop()

If WBF->(EOF())
	Aviso("Saldo","O endereço selecionado não possui produtos com saldo, no armazém especificado",{"Ok"})
	lRet := .F.
EndIf

//  .-------------------------------------------------------------
// |     Posição fixa para a tranferência entre almoxarifados
//  '-------------------------------------------------------------
_nProOri := 1
_nDesOri := 2
_nUMOri  := 3
_nLocOri := 4
_nEndOri := 5
_nProDes := 6
_nDesDes := 7
_nUMDes  := 8
_nLocDes := 9
_nEndDes := 10
_nLotOri := 12
_nValOri := 14
_nQuant  := 16
_nLotDes := 20
_nValDes := 21

While !WBF->(Eof())
	// Se a primeira linha esta em branco remove a mesma do acols
	If Empty(aCols[1,1])
		aDel( aCols, 1)
		aSize(aCols, Len(aCols)-1)
	EndIf
	// Adiciona item no acols
	aAdd(aCols,Array(Len(aHeader)+1))
	
	// Preenche conteudo do acols
	
	For nx:=1 to Len(aHeader)
		cCampo := Alltrim(aHeader[nx, 2])
		If IsHeadRec(cCampo)
			aCols[Len(aCols)][nx] := 0
		ElseIf IsHeadAlias(cCampo)
			aCols[Len(aCols)][nx] := "SD3"
		Else
			aCols[Len(aCols)][nx] := CriaVar(cCampo,.F.)
		EndIf
	Next nx
	
	aCols[Len(aCols)][Len(aHeader) + 1] := .F.
	
	// Preenche campos especificos
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + PadR(AllTrim(_cEndDes), tamsx3('D3_COD') [1])) )

    
 	SB2->(dbSetOrder(1))
	If !SB2->(dbSeek(xFilial('SB2') + PadR(AllTrim(_cEndDes), tamsx3('D3_COD') [1]) + PadR(WBF->BF_LOCALIZ, tamsx3('D3_LOCALIZ') [1])))
		CriaSB2( PadR(AllTrim(_cEndDes), tamsx3('D3_COD') [1]), PadR(WBF->BF_LOCALIZ, tamsx3('D3_LOCALIZ') [1]) )
	EndIf
	  
	If SB2->(dbSeek(xFilial('SB2') + PadR(AllTrim(_cEndDes), tamsx3('D3_COD') [1]) + PadR(WBF->BF_LOCALIZ, tamsx3('D3_LOCALIZ') [1])))
		If Empty(AllTrim(SB2->B2_TIPO))
	 		SB2->(RecLock('SB2',.F.))
	        	SB2->B2_TIPO := '1'
	    	SB2->(MsUnlock())
	    EndIf
	EndIf
	
	aCols[ Len(aCols), _nProOri] := PadR(AllTrim(WBF->BF_PRODUTO), tamsx3('D3_COD') [1])
	aCols[ Len(aCols), _nDesOri] := SB1->B1_DESC
	aCols[ Len(aCols), _nUMOri ] := SB1->B1_UM
	aCols[ Len(aCols), _nLocOri] := WBF->BF_LOCAL
	aCols[ Len(aCols), _nEndOri] := PadR(WBF->BF_LOCALIZ, tamsx3('D3_LOCALIZ') [1])
	aCols[ Len(aCols), _nProDes] := PadR(AllTrim(_cEndDes), tamsx3('D3_COD') [1]) 
	aCols[ Len(aCols), _nDesDes] := SB1->B1_DESC
	aCols[ Len(aCols), _nUMDes ] := SB1->B1_UM
	aCols[ Len(aCols), _nLocDes] := WBF->BF_LOCAL
	aCols[ Len(aCols), _nEndDes] := PadR(WBF->BF_LOCALIZ, tamsx3('D3_LOCALIZ') [1])
	aCols[ Len(aCols), _nQuant ] := WBF->BF_QUANT 

	//  .----------------------------------
	// |   Executa gatilhos e validacoes
	//  '----------------------------------
	If ExistTrigger("D3_COD")
		RunTrigger(2, Len(aCols),,"D3_COD")
	EndIf
	If ExistTrigger("D3_QUANT")
		RunTrigger(2, Len(aCols),,"D3_QUANT")
	EndIf
	If ExistTrigger("D3_LOCAL")
		RunTrigger(2, Len(aCols),,"D3_LOCAL")
	EndIf
	If ExistTrigger("D3_OP")
		RunTrigger(2, Len(aCols),,"D3_OP")
	EndIf

	If Rastro(PadR(AllTrim(WBF->BF_PRODUTO), tamsx3('D3_COD') [1]))
		aCols[ Len(aCols), _nLotOri] := WBF->BF_LOTECTL
		aCols[ Len(aCols), _nLotDes] := WBF->BF_LOTECTL

		If ExistTrigger("D3_LOTECTL")
			RunTrigger(2,Len(aCols),,"D3_LOTECTL")
		EndIf
		SB8->(dbSetOrder(3))
		If SB8->(dbSeek(xFilial("SB8")+PadR(WBF->BF_LOCALIZ, tamsx3('D3_LOCALIZ') [1])+WBF->BF_LOCAL+WBF->BF_LOTECTL))
			If SB8->B8_DTVALID > dDataBase
				aCols[ Len(aCols), _nValOri] := SB8->B8_DTVALID
				aCols[ Len(aCols), _nValDes] := SB8->B8_DTVALID
			EndIf
		EndIf
	EndIf

	WBF->(dbSkip())
End

WBF->(dbCloseArea())

RestArea(_cArea)
Return Nil

//  .-------------------------------------------------------------
// |     ValidPerg - Insere grupo de perguntas no arquivo SX1
//  '-------------------------------------------------------------
Static Function ValidPerg(cPerg)

U_PIPutSx1(cPerg, "01","Produto Orig.?", "", "" , "mv_ch1", "C", 15, 0, 0, "G","","SB1", "", "", "mv_par01")
U_PIPutSx1(cPerg, "02","Armazem Orig.?",  "", "", "mv_ch2", "C", 02, 0, 0, "G","","AL",  "", "", "mv_par02")
U_PIPutSx1(cPerg, "03","Produto Dest.?", "", "" , "mv_ch3", "C", 15, 0, 0, "G","","SB1", "", "", "mv_par03")

Return Nil
