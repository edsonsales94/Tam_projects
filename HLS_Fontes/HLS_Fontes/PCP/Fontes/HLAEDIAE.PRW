#include "Protheus.Ch"
#include "TopConn.Ch"

/*/{Protheus.doc} HLEDIAE

Gera o EDI.

@type function
@author Honda Lock
@since 01/10/2017

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HLEDIAE   ºAutor  ³Marcos Martins      º Data ³  24/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³EDI - Transmissao de dados.                                 º±±
±±º          ³Honda Lock                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HLEDIAE
  Local aArea			:= GetArea()
  Local cTexto			:= ""
  
  Private cPerg     	:= "EDIAEN"										// GRUPO NO SX1
  Private lEnd      	:= .F.											// ABORTA ROTINA
  Private _lAbort   	:= .F.											// HABILITA BOTAO CANCELA
  Private cQry			:= ""
  Private _NomeArq		:= ""											// Handle do arquivo a ser gerado
  Private _NomeArqBkp	:= ""											// Handle do arquivo Backup a ser gerado
  
  ValidPerg()

  If !Pergunte(cPerg)
	  Return
  Endif

//  _NomeArq	:= FCreate("C:\EDI-HAB\REMESSA\"+AllTrim(MV_PAR05)+".TXT",0)
	cTexto		:= DToS(dDataBase) + SubStr(Time(), 1, 2) + "H" + SubStr(Time(), 4, 2) + "M" + SubStr(Time(), 7, 2) + "S"
	_NomeArq	:= FCreate(Alltrim(MV_PAR06)+AllTrim(MV_PAR05)+".TXT",0)    
	_NomeArqBkp	:= FCreate(Alltrim(MV_PAR07)+AllTrim(MV_PAR05)+cTexto+".TXT",0)    

  If MsgYesNo("Confirma a Geração do EDI?")
     MSAguarde({|| GeraEDI()}, "Processando Exportacao dos Dados...",, _lAbort)
  Endif

  fClose(_NomeArq)
  fClose(_NomeArqBkp)

  RestArea(aArea)                                                                                                        
Return

Static Function GeraEDI()
	Local cLine		:= ""
	Local nSeq		:= StrZero(GetMv("MV_SEQEDI"),5)
	Local nControl	:= ""
	Local nQtdReg	:= 0
	Local nSValBrut	:= 0
    
    fConsSQL()
                           
    If Select("TXArq") > 0
	   DbSelectArea("TXArq")               
	   DbCloseArea()
    Endif
    TCQUERY cQry NEW ALIAS "TXArq"
	TcSetField('TXArq','F2_EMISSAO','D',8,0)
	TcSetField('TXArq','F2_ZZDTSAI','D',8,0)
	TcSetField('TXArq','F1_EMISSAO','D',8,0)
	TcSetField('TXArq','E1_VENCTO' ,'D',8,0) 
    
    If TXArq->(Eof())
    	Aviso("ATENÇÃO","Não existem informações a serem geradas.",{'Ok'})
    	Return 
    Endif
        
 	&& HEADER DO PROCESSO.    
    nQtLines:=1
    cLine := "ITP"
  	cLine += "004"
  	cLine += "19"                 
  	cLine += nSeq
    cLine += Right(DTOS(dDataBase),6) + Left(Time(),2)+SubStr(Time(),4,2)+Right(Time(),2) 
    cLine += SM0->M0_CGC   
    cLine += TXArq->CGCRECP
    cLine += " 6380987"
    cLine += "00000000"
    cLine += Left(SM0->M0_NOMECOM,25)
    cLine += Left("HONDA AUTOMOVEIS BRASIL",25)
    FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  
    FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  
        		     
	While TXArq->(!Eof()) 
	
		nControl := SubStr(TxArq->F2_DOC,1,6)+TXArq->F2_SERIE              
                              
        nQtLines++            
		cLine := "AE1"
		cLine += Right(StrZero(Val(SubStr(TXArq->F2_DOC,1,6)),6),6)
		cLine += Left(TXArq->F2_SERIE+Space(4),4)
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
		cLine += Right(StrZero(Val(TXArq->NITEM),3),3)
		cLine += SubStr(StrZero(TXArq->F2_VALBRUT,18,2),1,15)+SubStr(StrZero(TXArq->F2_VALBRUT,18,2),17,2)
		cLine += '2'
		cLine += Left(TXArq->D2_CF+Space(5),5)
		cLine += SubStr(StrZero(TXArq->F2_VALICM,18,2),1,15)+SubStr(StrZero(TXArq->F2_VALICM,18,2),17,2)
		If Empty(TXArq->E1_VENCTO)
			cLine += StrZero(0,6)
		Else
			cLine += Right(DTOS(TXArq->E1_VENCTO),6) //StrZero(0,6) 
		EndIf
		cLine += Iif(TXArq->F4_DUPLIC == 'S','02','01')
		//cLine += SubStr(StrZero(TXArq->D2_VALIPI,18,2),1,15)+SubStr(StrZero(TXArq->D2_VALIPI,18,2),17,2) -- comentado para gerar a soma de IPI neste bloco LL 24/05
		cLine += SubStr(StrZero(TXArq->F2_VALIPI,18,2),1,15)+SubStr(StrZero(TXArq->F2_VALIPI,18,2),17,2) // AJUSTADO LUCIANO LAMBERTI - 24/05/19
		cLine += Substr(TXArq->C6_ZZIDEXP,1,3) //'AB1'
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
		cLine += StrZero(0,4)
		cLine += Left(TXArq->CFOP+Space(15),15)
		cLine += Right(DTOS(TXArq->F2_ZZDTSAI),6)
		cLine += Left(Alltrim(TXArq->F2_ZZHRSAI),2)+Right(Alltrim(TXArq->F2_ZZHRSAI),2)
        FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	
        FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	
					              
        nQtLines++            
		cLine := "NF2"
		cLine += SubStr(StrZero(TXArq->F2_DESPESA,13,2),1,10)+SubStr(StrZero(TXArq->F2_DESPESA,13,2),12,2)
		cLine += SubStr(StrZero(TXArq->F2_FRETE,13,2),1,10)+SubStr(StrZero(TXArq->F2_FRETE,13,2),12,2)
		cLine += SubStr(StrZero(TXArq->F2_SEGURO,13,2),1,10)+SubStr(StrZero(TXArq->F2_SEGURO,13,2),12,2)
		cLine += SubStr(StrZero(TXArq->F2_DESCONT,13,2),1,10)+SubStr(StrZero(TXArq->F2_DESCONT,13,2),12,2)
		cLine += SubStr(StrZero(TXArq->F2_BASEICM,13,2),1,10)+SubStr(StrZero(TXArq->F2_BASEICM,13,2),12,2)
		cLine += SubStr(StrZero(TXArq->VLDESCICMS,13,2),1,10)+SubStr(StrZero(TXArq->VLDESCICMS,13,2),12,2)
		cLine += Right(StrZero(Val(TXArq->D2_NFORI),6),6)
		cLine += Right(DTOS(TXArq->F1_EMISSAO),6)
		cLine += Left(TXArq->D2_SERIORI+Space(4),4)
		cLine += Substr(TXArq->C6_ZZIDEXP,1,3)//'AB1'
		cLine += Left((TXArq->D2_CF+Space(5)),5)
		cLine += StrZero(0,12) //Iif(Empty(TXArq->D2_CODISS),Right(oLibF:RmPntVig(StrZero(TXArq->D2_TOTAL,13,2),0),13), StrZero(0,13))
        FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	
        FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	
                           
		nSValBrut += TXArq->F2_VALBRUT
		While TXArq->(!Eof()) .And. nControl == SubStr(TxArq->F2_DOC,1,6)+TXArq->F2_SERIE
                                  
	        nQtLines++            
			cLine := "AE2"
			cLine += Right(StrZero(Val(TXArq->D2_ITEM),3),3)
			cLine += Left(Alltrim(TXArq->C6_PEDCLI)+Space(12),12) //			cLine += "            "
			cLine += Left(Alltrim(TXArq->B1_CODMATR)+Space(30),30)
			cLine += SubStr(StrZero(TXArq->D2_QUANT,10,2),1,7)+SubStr(StrZero(TXArq->D2_QUANT,10,2),9,2)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += Left(TXArq->B1_POSIPI+Space(10),10)
			cLine += SubStr(StrZero(TXArq->D2_IPI,5,2),1,2)+SubStr(StrZero(TXArq->D2_IPI,5,2),4,2)
			cLine += SubStr(StrZero(TXArq->D2_PRCVEN,13,2),1,10)+SubStr(StrZero(TXArq->D2_PRCVEN,13,2),12,2)
			cLine += Space(9)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += SubStr(StrZero(TXArq->D2_QUANT,10,2),1,7)+SubStr(StrZero(TXArq->D2_QUANT,10,2),9,2)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += "N"//Left(TXArq->F4_ZZTPVEN+Space(1),1)
			cLine += SubStr(StrZero(TXArq->D2_DESC,5,2),1,2)+SubStr(StrZero(TXArq->D2_DESC,5,2),4,2)
			cLine += SubStr(StrZero(TXArq->D2_DESCON,12,2),1,9)+SubStr(StrZero(TXArq->D2_DESCON,12,2),11,2)
			cLine += Space(4)  
            FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	  
            FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	  

	        nQtLines++            			
			cLine := "AE4"
			cLine += SubStr(StrZero(TXArq->D2_PICM,5,2),1,2)+SubStr(StrZero(TXArq->D2_PICM,5,2),4,2)
			cLine += SubStr(StrZero(TXArq->D2_BASEICM,18,2),1,15)+SubStr(StrZero(TXArq->D2_BASEICM,18,2),17,2)
			cLine += SubStr(StrZero(TXArq->D2_VALICM,18,2),1,15)+SubStr(StrZero(TXArq->D2_VALICM,18,2),17,2)
			cLine += SubStr(StrZero(TXArq->D2_VALIPI,18,2),1,15)+SubStr(StrZero(TXArq->D2_VALIPI,18,2),17,2)
			cLine += Left(TXArq->D2_CLASFIS+Space(2),2)
			cLine += Space(36)
//			cLine += StrZero(0,6)
			cLine += Right(StrZero(Val(TXArq->C6_NFFATUR),6),6)
			cLine += Left(TXArq->C6_NFSERIE+Space(2),2)			
			cLine += Right(StrZero((Val(TXArq->C6_ITEMFAT)*100),5),5)		
//			cLine += Space(1)
			cLine += SubStr(StrZero(TXArq->D2_PESO,6,2),1,3)+SubStr(StrZero(TXArq->D2_PESO,6,2),5,2)
			cline += Space(1)
			cLine += SubStr(StrZero(TXArq->D2_TOTAL,13,2),1,10)+SubStr(StrZero(TXArq->D2_TOTAL,13,2),12,2)
			cLine += Left(TXArq->F4_SITTRIB,1)
            FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	  
            FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	  

	        nQtLines++            
			cLine := "AE7"
			cLine += Space(12)
			cLine += Left(TXArq->D2_CF+Space(5),5)
			cLine += SubStr(StrZero(TXArq->D2_BRICMS,18,2),1,15)+SubStr(StrZero(TXArq->D2_BRICMS,18,2),17,2)
			cLine += SubStr(StrZero(TXArq->D2_ICMSRET,18,2),1,15)+SubStr(StrZero(TXArq->D2_ICMSRET,18,2),17,2)
			cLine += StrZero(0,13) // Verificar...
			cLine += SubStr(StrZero(TXArq->D2_PESO,7,2),1,4)+SubStr(StrZero(TXArq->D2_PESO,7,2),6,2)
			cLine += StrZero(0,12) //Iif(Empty(TXArq->D2_CODISS),Right(oLibF:RmPntVig(StrZero(TXArq->D2_TOTAL,13,2),0),13), Space(13))
			cLine += Left(TXArq->C6_SLIPNUM+Space(14),14) //Left(TXArq->C6_PEDCLI+Space(14),14) // verificar com o Cliente o conteudo do campo
			cLine += Left(TXArq->C6_TIPOP,02) //Space(2) //Left(TXArq->C6_TPEDIDO+Space(2),2) // verificar com o Cliente o conteudo do campo
			cLine += Left(TXArq->C6_SEPEN+Space(10),10) //Space(10) // Left(TXArq->C6_NUMSERIE+Space(10),10) // verificar com o Cliente o conteudo do campo
//			cLine += Left(TXArq->D2_LOTECTL+Space(12),12) // COMENTADO POR RODRIGO BREDA 23/05/2013 POIS LOTE ESTAVA BUSCANDO HLS SENDO QUE LOTE CORRETO EH HAB
			cLine += Left(TXArq->C6_LOTEHAB+Space(12),12)

			cLine += "CPI"
			cLine += Space(2)      
            FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	  
            FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	  
	        
	        nQtLines++            
			cLine := "AE8"
			cLine += Right(StrZero(Val(TXArq->D2_NFORI),6),6)
			cLine += Left(TXArq->D2_SERIORI+Space(4),4)
			cLine += Space(6)
			cLine += Space(3)
//			cLine += Right(DTOS(TXArq->F1_EMISSAO),6)
//			cLine += Right(StrZero(Val(TXArq->D1_ITEM),3),3)
			cLine += Space(16)
			cLine += Space(17)
			cLine += Space(10)
			cLine += Space(63)     
            FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	               
            FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	               
                             
			TXArq->(DbSkip())
        Enddo
			
	Enddo
	
	nQtLines++
	cLine := "FTP"
	cLine += nSeq
	cLine += StrZero(nQtLines+1,9)
	cLine += SubStr(StrZero(nSValBrut,18,2),1,15)+SubStr(StrZero(nSValBrut,18,2),17,2)
	cLine += '0'                   
    FWrite(_NomeArq,	cLine + CRLF)		// ****** GRAVA REGISTRO ******  	  
    FWrite(_NomeArqBkp,	cLine + CRLF)		// ****** GRAVA REGISTRO DE BACKUP ******  	  
            
	PutMv("MV_SEQEDI", (Val(nSeq)+1))
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

Static Function ValidPerg()
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	Local lRet := .t.
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/	Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Da Nota Fiscal"     			,"" ,"" ,"mv_ch1", "C", 09, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"})
	aAdd(aRegs, {cPerg, "02", "Da Serie"        			,"" ,"" ,"mv_ch2", "C", 03, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "03", "Ate Nota Fiscal"      		,"" ,"" ,"mv_ch3", "C", 09, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"})
	aAdd(aRegs, {cPerg, "04", "Ate Serie"	        		,"" ,"" ,"mv_ch4", "C", 03, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "05", "Nome do Arquivo"        		,"" ,"" ,"mv_ch5", "C", 10, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "06", "Arquivo de Saida"       		,"" ,"" ,"mv_ch6", "C", 60, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "DIR"})
	aAdd(aRegs, {cPerg, "07", "Arquivo de Backup"      		,"" ,"" ,"mv_ch7", "C", 60, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "DIR"})
		
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

Static Function fConsSQL()
	
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
		cQry += "		SF2.F2_VALIPI, " //AJUSTADO LUCIANO LAMBERTI - 24/05/19
		cQry += "		(SELECT X5_DESCRI FROM "+RetSqlName('SX5')+" WHERE X5_FILIAL = '"+xFilial('SX5')+"' AND X5_TABELA = '13' AND X5_CHAVE = SD2.D2_CF AND D_E_L_E_T_ = ' ') AS CFOP, "
		cQry += "		(SELECT MAX(C6_ENTREG) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZDTSAI, "
		cQry += "		(SELECT MAX(C6_HORA) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZHRSAI, "
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
//		cQry += "		ISNULL((SELECT B1_CODMATR FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND B1_LOCPAD = SD2.D2_LOCAL AND D_E_L_E_T_ = ' ' ),'') AS B1_CODMATR, "
		cQry += "		ISNULL((SELECT B1_CODMATR FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND D_E_L_E_T_ = ' ' ),'') AS B1_CODMATR, "
		cQry += "		SD2.D2_QUANT, "
		cQry += "		SD2.D2_UM, "
		cQry += "		ISNULL((SELECT B1_POSIPI FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND D_E_L_E_T_ = ' ' ),'') AS B1_POSIPI, "
		cQry += "		(SELECT C6_NFFATUR FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_NFFATUR, "
		cQry += "		(SELECT C6_NFSERIE FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_NFSERIE, "
		cQry += "		(SELECT C6_ITEMFAT C6 FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_ITEMFAT, "
	cQry += "		(SELECT C6_ZZIDEXP C6 FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_ZZIDEXP, " //vfv
//		cQry += "		ISNULL((SELECT B1_POSIPI FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND B1_LOCPAD = SD2.D2_LOCAL AND D_E_L_E_T_ = ' ' ),'') AS B1_POSIPI, "
		cQry += "		SD2.D2_IPI, "
		cQry += "		SD2.D2_PRCVEN, "
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
		cQry += "		(SELECT C6_NUMSERI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_NUMSERIE, "
		cQry += "		(SELECT C6_SLIPNUM FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_SLIPNUM, "
		cQry += "		(SELECT C6_SEPEN FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_SEPEN, "
		cQry += "		(SELECT C6_TIPOP FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_TIPOP, "		
		cQry += "		(SELECT C6_LOTEHAB FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_LOTEHAB, "		//ACRESCENTADO POR RODRIGO BREDA 22/05/2013 PARA TRAZER LOTE CORRETO
		cQry += "		SD2.D2_LOTECTL "
/*
		cQry += "		SD2.D2_LOTECTL, "		
		cQry += "		'AE8' AS AE8, "
		cQry += "		SD2.D2_NFORI, "
		cQry += "		SD2.D2_SERIORI, "		
		cQry += "		ISNULL((SELECT F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, "
		cQry += "		ISNULL((SELECT D1_ITEM FROM "+RetSqlName('SD1')+" WHERE D1_FILIAL = '"+xFilial('SD1')+"' AND D1_DOC = SD2.D2_NFORI AND D1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS D1_ITEM "
*/				
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
		cQry += "		SF2.F2_VALIPI, " // AJUSTADO LUCIANO LAMBERTI - 24/05/2019
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