#include "Protheus.Ch"
#include "TopConn.Ch"

/*/{protheus.doc}NSAEDI01
Geração de Arquivo EDI 
@author Andre Lopes 
@since 03/02/08
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NSAEDI01  ºAutor  ³Andre Lopes         º Data ³  03/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³EDI - Transmissao de dados.                                 º±±
±±º          ³ NS -> Honda                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8.11                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NSAEDI01
	Local aArea		:= GetArea()
	Local cPerg		:= 'NSEDI1'
	Local oDlg, oSay1
	Local cLocArq	:= ""
	Local cLocNm	:= "Local/Nome do Arquivo: "
	Local oLibF		:= LibFunctions():MaLoc()
                   
	ValidPerg(cPerg)
	Pergunte(cPerg,.f.)
	
	Define MsDialog oDlg Title "Geração de Arquivo EDI" From oLibF:Sz(189),oLibF:Sz(200) To oLibF:Sz(325),oLibF:Sz(680) Pixel

		@ oLibF:Sz(004),oLibF:Sz(004) To oLibF:Sz(045),oLibF:Sz(240) Label "" Pixel Of oDlg
		@ oLibF:Sz(014),oLibF:Sz(009) Say "Este programa tem o objetivo de gerar arquivo em formato TXT com base nas Notas Fiscais de Saida. " Size oLibF:Sz(300),oLibF:Sz(018) Color CLR_BLACK Pixel Of oDlg
		@ oLibF:Sz(024),oLibF:Sz(009) Say "Para gerar o arquivo, selecione os documentos de saida, série e o caminho aonde o  arquivo será gravado." Size oLibF:Sz(300),oLibF:Sz(021) Color CLR_BLACK Pixel Of oDlg
		@ oLibF:Sz(034),oLibF:Sz(009) Say oSay1 Var (cLocNm+cLocArq) Size oLibF:Sz(300),oLibF:Sz(021) Color CLR_BLACK Pixel Of oDlg		

		@ oLibF:Sz(050),oLibF:Sz(004) Button "Parâmetros" 	Size oLibF:Sz(052),oLibF:Sz(013) Action (Pergunte(cPerg, .T.)) Pixel Of oDlg
		@ oLibF:Sz(050),oLibF:Sz(074) Button "Processar"   Size oLibF:Sz(052),oLibF:Sz(013) Action ( fSetLocF(@cLocArq,oSay1,oLibF) ) Pixel Of oDlg
		@ oLibF:Sz(050),oLibF:Sz(144) Button "Sair"       	Size oLibF:Sz(052),oLibF:Sz(013) Action (oDlg:End()) Pixel Of oDlg
	
	Activate MsDialog oDlg Centered 

	RestArea(aArea)                                                                                                        
Return                                                                                                                     

Static Procedure fSetLocF(cLocArq,oSay,oLibF)
	Local cDrivers 	:= "Todos (*.TXT)|*.TXT|"

	cLocArq := cGetFile(cDrivers,"Selecione o nome e local onde será salvo o arquivo",1,,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

	If !(".TXT" $ UPPER(cLocArq))
		cLocArq += '.txt'
	Endif
	             
	oSay:Refresh()

	If MsgYesNo("Confirma a Geração do EDI?")
		Processa({|| fCrtFEdi(cLocArq,oLibF)},"Aguarde! Processando dados...")	
	Endif
	
Return

Static Procedure fCrtFEdi(cLocArq,oLibF)
	Local oFileTxt	:= MnArqTxt():New()

	If !oFileTxt:CreateFile(cLocArq)
		Aviso("ATENÇÃO","O Arquivo não pode ser criado. Verifique o caminho e nome escolhido!",{'Ok'})
		Return
	Endif
        
	fCrtaArq(oFileTxt,oLibF)

Return

Static Procedure fCrtaArq(oFileTxt,oLibF)
	Local oSt1		:= QryProc():Create()
	Local cLine		:= ""
	Local nSeq		:= StrZero(GetMv("NS_SEQEDI"),5)
	//Local cHondaSum := GetMv("NS_HNDSUM")
	Local nControl	:= ""
	Local nQtdReg	:= 0
	Local nSValBrut	:= 0
                           
	oSt1:cQry := fConsSQL()
	oSt1:Open('TXArq')  
	
	TcSetField('TXArq','F2_EMISSAO','D',8,0)
	TcSetField('TXArq','F2_ZZDTSAI','D',8,0)
	TcSetField('TXArq','F1_EMISSAO','D',8,0)
	TcSetField('TXArq','E1_VENCTO' ,'D',8,0) 
    
    If TXArq->(Eof())
    	Aviso("ATENÇÃO","Não existem informações a serem geradas.",{'Ok'})
    	Return 
    Endif
        
 	&& HEADER DO PROCESSO.
    cLine := "ITP"
  	cLine += "004"
  	cLine += "19"                 
  	cLine += nSeq
    cLine += Right(DTOS(dDataBase),6) + Left(Time(),2)+SubStr(Time(),4,2)+Right(Time(),2) 
    cLine += SM0->M0_CGC   
    cLine += TXArq->CGCRECP
    cLine += " 6378302"
    cLine += "00000000"
    cLine += Left(SM0->M0_NOMECOM,25)
    cLine += "HONDA AUTOMOVEIS BRASIL"
    cLine := fCplPos(cLine)
	oFileTxt:IncLine(cLine)     
		     
	While TXArq->(!Eof()) 
	
		nControl := TxArq->F2_DOC+TXArq->F2_SERIE              

		cLine := "AE1"
		cLine += Right(StrZero(Val(TXArq->F2_DOC),6),6)
		cLine += Left(TXArq->F2_SERIE+Space(4),4)
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
		cLine += Right(StrZero(Val(TXArq->NITEM),3),3)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_VALBRUT,18,2),0),18)
		cLine += '2'
		cLine += Left(TXArq->D2_CF+Space(5),5)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_VALICM,18,2),0),18)
		cLine += Right(DTOS(TXArq->E1_VENCTO),6) //StrZero(0,6) 
		cLine += Iif(TXArq->F4_DUPLIC == 'S','02','01')
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_VALIPI,18,2),0),18)  
		cLine += 'AB1'
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
		cLine += StrZero(0,4)
		cLine += Left(TXArq->CFOP+Space(15),15)
		cLine += Right(DTOS(TXArq->F2_ZZDTSAI),6)
		cLine += Left(Alltrim(TXArq->F2_ZZHRSAI),2)+Right(Alltrim(TXArq->F2_ZZHRSAI),2)
		cLine := fCplPos(cLine)
		oFileTxt:IncLine(cLine)
		
					
		cLine := "NF2"
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_DESPESA,13,2),0),13)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_FRETE,13,2),0),13)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_SEGURO,13,2),0),13)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_DESCONT,13,2),0),13)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->F2_BASEICM,13,2),0),13)
		cLine += Right(oLibF:RmPntVig(StrZero(TXArq->VLDESCICMS,13,2),0),13)
		cLine += Right(StrZero(Val(TXArq->D2_NFORI),6),6)
		cLine += Right(DTOS(TXArq->F1_EMISSAO),6)
		cLine += Left(TXArq->D2_SERIORI+Space(4),4)
		cLine += 'AB1'
		cLine += Left((TXArq->D2_CF+Space(5)),5)
		cLine += StrZero(0,12) //Iif(Empty(TXArq->D2_CODISS),Right(oLibF:RmPntVig(StrZero(TXArq->D2_TOTAL,13,2),0),13), StrZero(0,13))
		cLine := fCplPos(cLine)
		oFileTxt:IncLine(cLine)
                   
		nSValBrut += TXArq->F2_VALBRUT
		While TXArq->(!Eof()) .And. nControl == TxArq->F2_DOC+TXArq->F2_SERIE

			cLine := "AE2"
			cLine += Right(StrZero(Val(TXArq->D2_ITEM),3),3)
			cLine += Left(Alltrim(TXArq->C6_PEDCLI)+Space(12),12) //			cLine += "            "
			cLine += Left(Alltrim(TXArq->A7_CODCLI)+Space(30),30)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_QUANT,10,2),0),10)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += Left(TXArq->B1_POSIPI+Space(10),10)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_IPI,5,2),0),5)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_PRCVEN,13,2),0),13)
			cLine += Space(9)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_QUANT,10,2),0),10)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += Left(TXArq->F4_ZZTPVEN+Space(1),1)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_DESC,5,2),0),5)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_DESCON,12,2),0),12)
			cLine += Space(4)  
			cLine := fCplPos(cLine)
            oFileTxt:IncLine(cLine)
  
			
			cLine := "AE4"
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_PICM,5,2),0),5)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_BASEICM,18,2),0),18)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_VALICM,17,2),0),17)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_VALIPI,19,2),0),19)
			cLine += Left(TXArq->D2_CLASFIS+Space(2),2)
			cLine += Space(30)
			cLine += StrZero(0,6)
			cLine += Space(13)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_PESO,6,2),0),6)
			cline += Space(1)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_TOTAL,13,2),0),13)
			cLine += Left(TXArq->F4_SITTRIB,1)
			cLine := fCplPos(cLine)
			oFileTxt:IncLine(cLine)


			cLine := "AE7"
			cLine += Space(12)
			cLine += Left(TXArq->D2_CF+Space(5),5)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_BRICMS,18,2),0),18)
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_ICMSRET,18,2),0),18)
			cLine += StrZero(0,13) // Verificar...
			cLine += Right(oLibF:RmPntVig(StrZero(TXArq->D2_PESO,7,2),0),7)
			cLine += StrZero(0,12) //Iif(Empty(TXArq->D2_CODISS),Right(oLibF:RmPntVig(StrZero(TXArq->D2_TOTAL,13,2),0),13), Space(13))
			cLine += Left(TXArq->C6_PEDCLI+Space(14),14) // verificar com o Cliente o conteudo do campo
			cLine += Space(2) //Left(TXArq->C6_TPEDIDO+Space(2),2) // verificar com o Cliente o conteudo do campo
			cLine += Space(10) // Left(TXArq->C6_NUMSERIE+Space(10),10) // verificar com o Cliente o conteudo do campo
			cLine += Left(TXArq->D2_LOTECTL+Space(12),12)
			cLine += "CPI"
			cLine += Space(2)      
			cLine := fCplPos(cLine)
			oFileTxt:IncLine(cLine)

			cLine := "AE8"
			cLine += Right(StrZero(Val(TXArq->D2_NFORI),6),6)
			cLine += Left(TXArq->D2_SERIORI+Space(4),4)
			cLine += Right(DTOS(TXArq->F1_EMISSAO),6)
			cLine += Right(StrZero(Val(TXArq->D1_ITEM),3),3)
			cLine += Space(16)
			cLine += Space(17)
			cLine += Space(10)
			cLine += Space(63)     
			cLine := fCplPos(cLine)
			oFileTxt:IncLine(cLine) 
             
                             
			TXArq->(DbSkip())
        Enddo
			
	Enddo
	oSt1:Close()
	
	cLine := "FTP"
	cLine += nSeq
	cLine += StrZero(oFileTxt:nQtLines+1,9)
	cLine += Right(oLibF:RmPntVig(StrZero(nSValBrut,18,2),0),18)
	cLine += '0'                   
	cLine := fCplPos(cLine)
	oFileTxt:IncLine(cLine)		

	oFileTxt:CloseArq()
	PutMv("NS_SEQEDI", (Val(nSeq)+1))
	Aviso('ATENÇÃO','Arquivo gerado com sucesso!',{'Ok'})
	
Return
            
Static Function fCplPos(cLine)
	Local cRet 	:= AllTrim(cLine)
	Local nI	:= 0
	
	If Len(cRet) < 128
		For nI := Len(cRet) to 127
			cRet += ' '		
	    Next nI
	Endif
	
Return(cRet)

Static Function ValidPerg(cPerg)
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	Local lRet := .t.
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,6)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/	Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Da Nota Fiscal"     			,"" ,"" ,"mv_ch1", "C", 09, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ZZSF2"})
	aAdd(aRegs, {cPerg, "02", "Da Serie"        			,"" ,"" ,"mv_ch2", "C", 03, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "03", "Ate Nota Fiscal"      		,"" ,"" ,"mv_ch3", "C", 09, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ZZSF2"})
	aAdd(aRegs, {cPerg, "04", "Ate Serie"	        		,"" ,"" ,"mv_ch4", "C", 03, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	dbSelectArea(_sAlias)
	  
Return(lRet)

Static Procedure fConsSQL()
	Local cQry := ""
	
		cQry := "SELECT	'ITP' AS ITP, "
		cQry += "		ISNULL((SELECT A1_CGC FROM "+RetSqlName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = SF2.F2_CLIENTE AND A1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ),'') AS CGCRECP, "
		cQry += "		'AE1' AS AE1, "
		cQry += "		SF2.F2_DOC, "
		cQry += "		SF2.F2_SERIE, "
		cQry += "		SF2.F2_EMISSAO, "
		cQry += "		(SELECT MAX(D2_ITEM) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS NITEM, "
		cQry += "		SF2.F2_VALBRUT, "
		cQry += "		SD2.D2_CF, "
		cQry += "		SF2.F2_VALICM, "
		cQry += "		(SELECT MAX(E1_VENCTO) FROM "+RetSqlName('SE1')+" WHERE E1_FILIAL = '"+xFilial('SE1')+"' AND E1_NUM = SF2.F2_DOC AND E1_PREFIXO = SF2.F2_SERIE AND E1_CLIENTE = SF2.F2_CLIENTE AND E1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ) AS E1_VENCTO, "
		cQry += "		(SELECT F4_DUPLIC FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_DUPLIC, "
//		cQry += "		SD2.D2_VALIPI, " -- comentado para gerar a soma de IPI neste bloco LL 24/05
		cQry += "		SF2.F2_VALIPI, " //AJUSTADO LUCIANO LAMBERTI - 24/05/2019
		cQry += "		(SELECT X5_DESCRI FROM "+RetSqlName('SX5')+" WHERE X5_FILIAL = '"+xFilial('SX5')+"' AND X5_TABELA = '13' AND X5_CHAVE = SD2.D2_CF AND D_E_L_E_T_ = ' ') AS CFOP, "
		cQry += "		(SELECT MAX(C6_ENTREG) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZDTSAI, "
		cQry += "		(SELECT MAX(C6_HORA) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZHRSAI, "
//		cQry += "		SF2.F2_ZZDTSAI, "
//		cQry += "		SF2.F2_ZZHRSAI, "
		cQry += "		'NF2' AS NF2, "
		cQry += "		SF2.F2_DESPESA, "
		cQry += "		SF2.F2_FRETE, "
		cQry += "		SF2.F2_SEGURO, "
		cQry += "		SF2.F2_DESCONT, "
		cQry += "		SF2.F2_BASEICM, "
		cQry += "		(SELECT SUM(D2_DESCZFR) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS VLDESCICMS, "
		cQry += "		SD2.D2_NFORI, "
		cQry += "		ISNULL((SELECT F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, "
		cQry += "		SD2.D2_SERIORI, "
		cQry += "		SD2.D2_CF, "   
		cQry += "		SD2.D2_CODISS, "
		cQry += "		SD2.D2_TOTAL, "
		cQry += "		'AE2' AS AE2, "
		cQry += "		SD2.D2_ITEM, "  
		cQry += "		(SELECT C6_PEDCLI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_PEDCLI, "
		cQry += "		ISNULL((SELECT A7_CODCLI FROM "+RetSqlName('SA7')+" WHERE A7_FILIAL = '"+xFilial('SA7')+"' AND A7_CLIENTE = SF2.F2_CLIENTE AND A7_LOJA = SF2.F2_LOJA AND A7_PRODUTO = SD2.D2_COD AND D_E_L_E_T_ = ' '),'') AS A7_CODCLI, "
		cQry += "		SD2.D2_QUANT, "
		cQry += "		SD2.D2_UM, "
		cQry += "		ISNULL((SELECT B1_POSIPI FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND B1_LOCPAD = SD2.D2_LOCAL AND D_E_L_E_T_ = ' ' ),'') AS B1_POSIPI, "
		cQry += "		SD2.D2_IPI, "
		cQry += "		SD2.D2_PRCVEN, "
		cQry += "		(SELECT F4_ZZTPVEN FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_ZZTPVEN, "
		cQry += "		SD2.D2_DESC, "
		cQry += "		SD2.D2_DESCON, "
		cQry += "		'AE4' AS AE4, "
		cQry += "		SD2.D2_PICM, "
		cQry += "		SD2.D2_BASEICM, "
		cQry += "		SD2.D2_VALICM, "
		cQry += "		SD2.D2_VALIPI, "
		cQry += "		SD2.D2_CLASFIS, "
		cQry += "		SD2.D2_PESO, "
		cQry += "		SD2.D2_TOTAL, "
 		cQry += "		(SELECT F4_SITTRIB FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_SITTRIB, "
		cQry += "		'AE7' AS AE7, "
		cQry += "		SD2.D2_CF, "
		cQry += "		SD2.D2_BRICMS, "
		cQry += "		SD2.D2_ICMSRET, "
		cQry += "		'VERIFICAR' AS VERIF, "
		cQry += "		SD2.D2_PESO, "
		cQry += "		SD2.D2_TOTAL, "
		cQry += "		(SELECT C6_PEDCLI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_PEDCLI, "
		cQry += "		(SELECT C6_TPEDIDO FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_TPEDIDO, "
		cQry += "		(SELECT C6_NUMSERI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_NUMSERIE, "
		cQry += "		SD2.D2_LOTECTL, "
		cQry += "		'AE8' AS AE8, "
		cQry += "		SD2.D2_NFORI, "
		cQry += "		SD2.D2_SERIORI, "
		cQry += "		ISNULL((SELECT F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, "
		cQry += "		ISNULL((SELECT D1_ITEM FROM "+RetSqlName('SD1')+" WHERE D1_FILIAL = '"+xFilial('SD1')+"' AND D1_DOC = SD2.D2_NFORI AND D1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS D1_ITEM "
		cQry += "FROM "+RetSqlName('SF2')+" SF2 INNER JOIN "+RetSqlName('SD2')+" SD2 "
		cQry += "		ON SF2.F2_FILIAL 	=	SD2.D2_FILIAL	AND "
		cQry += "		SF2.F2_DOC			=	SD2.D2_DOC 		AND "
		cQry += "		SF2.F2_SERIE		=	SD2.D2_SERIE	AND "
		cQry += "		SF2.D_E_L_E_T_		=	' '				AND "
		cQry += "		SD2.D_E_L_E_T_		=	' '				AND "
		cQry += "		SF2.F2_FILIAL		=	'"+xFilial('SF2')+"' AND "
		cQry += "		SF2.F2_DOC 			BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par03+"' AND "
		cQry += "		SF2.F2_SERIE		BETWEEN '"+Mv_Par02+"' AND '"+Mv_Par04+"' " 
		cQry += "GROUP BY "
		cQry += "		SF2.F2_DOC, "
		cQry += "		SF2.F2_SERIE, "
		cQry += "		SF2.F2_CLIENTE, "
		cQry += "		SF2.F2_LOJA, "
		cQry += "		SF2.F2_EMISSAO, "
		cQry += "		SF2.F2_VALBRUT, "
		cQry += "		SD2.D2_CF, "
		cQry += "		SF2.F2_VALICM, "
		cQry += "		SD2.D2_VALIPI, "
  //	cQry += "		SF2.F2_ZZDTSAI, "
//		cQry += "		SF2.F2_ZZHRSAI, "
		cQry += "		SF2.F2_DESPESA, "
		cQry += "		SF2.F2_FRETE, "
		cQry += "		SF2.F2_SEGURO, "
		cQry += "		SF2.F2_DESCONT, "
		cQry += "		SF2.F2_BASEICM, "
		cQry += "		SD2.D2_NFORI, "
		cQry += "		SD2.D2_SERIORI, "
		cQry += "		SD2.D2_TOTAL, "
		cQry += "		SD2.D2_ITEM, "
		cQry += "		SD2.D2_COD, "
		cQry += "		SD2.D2_QUANT, "
		cQry += "		SD2.D2_UM, "
		cQry += "		SD2.D2_LOCAL, "
		cQry += "		SD2.D2_IPI, "
		cQry += "		SD2.D2_PRCVEN, "
		cQry += "		SD2.D2_DESC, "
		cQry += "		SD2.D2_DESCON, "
		cQry += "		SD2.D2_PICM, "
		cQry += "		SD2.D2_BASEICM, "
		cQry += "		SD2.D2_VALICM, "
		cQry += "		SD2.D2_CLASFIS, "
		cQry += "		SD2.D2_PESO, "
		cQry += "		SD2.D2_TES, "
		cQry += "		SD2.D2_BRICMS, "
		cQry += "		SD2.D2_ICMSRET, "
		cQry += "		SD2.D2_PEDIDO, "
		cQry += "		SD2.D2_ITEMPV, "
		cQry += "		SD2.D2_LOTECTL, "
		cQry += "		SD2.D2_CODISS "
		cQry += "ORDER BY  "
		cQry += "		SF2.F2_DOC, "
		cQry += "		SF2.F2_SERIE, "
		cQry += "		SD2.D2_ITEM "
	
Return(cQry)