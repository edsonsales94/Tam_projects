#include "rwmake.ch"

User Function CINVG004()

Private nFicha,aMod10
Private cPerg := "CINVG004  "

ValidPerg()

Pergunte(cPerg,.F.)

aMod10 := {1,2,1,2,1}

@000,000 To 180,450 Dialog oDlg Title "GERACAO DE FICHA DE INVENTARIO"
@008,010 To 070,220
@072,050 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
@072,080 BMPBUTTON TYPE 1 ACTION OkProc()
@072,110 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@015, 14 SAY "Esta rotina gera fichas de inventario na data desejada para os produtos,"
@025, 14 SAY "locais e localizacoes informadas na tela de parametros."
@035, 14 SAY "Pressione o botao de Parametros para ajusta-los antes de processar."

Activate Dialog oDlg Centered

Return(nil)


Static Function OkProc()
	Processa({||RunProc()})
	Close(oDlg)
Return

//////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
//////////////////////////////////////////////////////////////////////////////////
Local cQry
Local nW := 0

cQry := "SELECT B1_COD,B1_DESC,B1_LOCPAD,B1_TIPO,B1_UM,B2_LOCAL,B2_QFIM,B2_VFIM1,B2_CMFIM1 FROM "+RetSqlName("SB1")+" B1 "
cQry += "LEFT JOIN "+RetSqlName("SB2")+" B2 ON (B2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL   = B1_LOCPAD AND B2_COD = B1_COD) "
cQry += "WHERE B1.D_E_L_E_T_ = ' ' "
cQry += "AND B1_FILIAL  = '"+xFilial("SB1")+"' "
cQry += "AND B1_COD    BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' "
cQry += "AND B1_LOCPAD BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
IF ( mv_par06 == 1 )
 cQry += "AND B1_TIPO = 'PA' "
 cQry += "AND LEN(B1_COD) > 5 "
 cQry += "AND LEFT(B1_COD,1) <> '2' "
ELSEIF ( mv_par06 == 2 )
 cQry += "AND B1_TIPO = 'PI' "
ELSE
 cQry += "AND B1_TIPO = 'MP' "
ENDIF
cQry += "ORDER BY B1_LOCPAD,B1_COD "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB2', .T., .T.)


DbSelectArea("SZP")		//Arquivo Customizado de Ficha de Inventario
DbSetOrder(1)			   //1.Filial+Data+Ficha				             (Indice Novo)
						      //2.Filial+Data+Localizacao+Local+Produto     (Indice Novo)
						      //3.Filial+Data+Produto+Local+Localizacao     (Indice Novo)
						      //4.Filial+Data+Local+Localizacao+Produto     (Indice Novo)
DbSeek(xFilial("SZP")+DToS(mv_par01))
If Eof()
   nFicha := 0
Else
   DbSeek(xFilial("SZP")+DToS(mv_par01+1),.T.)
   DbSkip(-1)
   nFicha := Val(SUBS(SZP->ZP_ficha,1,5))
EndIf

dbSetOrder(3)     ////Para verificar se já foi gerado ficha para o produto/local/data informado

dDatAnt := ( FirstDay(mv_par01) - 1 )

DbSelectArea("SB2")		//Arquivo de Saldo de Estoque por Local
DbSetOrder(1)			   //1.Filial+Codigo+Local (Stand)
					         //2.Filial+Local+Codigo (Indice Novo)
ProcRegua(SB2->(RecCount()))
*
cFicha := " "
dbSelectArea("TB2")
dbGoTop()
Do While !Eof()
	IncProc()
	lGera := ( mv_par07 == 3 )
	lGera := IIF(!lGera , ( mv_par07 == 2 .AND. TB2->B2_QATU <> 0 ) , lGera )
	lGera := IIF(!lGera , ( mv_par07 == 1 .AND. TB2->B2_QATU = 0 ) , lGera )
	IF ( lGera )
		/*
		aSalAtu := CalcEst(TB2->B1_COD,TB2->B1_LOCPAD,mv_par01)
		B2QATU  := aSalAtu[1]
		B2VATU  := aSalAtu[2]
		nCm1 := aSalAtu[8]
		*/
		B2QATU := TB2->B2_QFIM
		B2VATU := TB2->B2_VFIM1
		nCm1   := TB2->B2_CMFIM1
		mFicha := nFicha
		
		////
		////Gera a partir de endereçamento (apenas controle interno da coelmatic - dez/2015)
		////
		dbSelectArea("SBF")
		dbSetOrder(2)
		dbSeek(xFilial("SBF")+TB2->B1_COD+TB2->B1_LOCPAD,.T.)
		DO WHILE SBF->(!EOF()).AND.SBF->BF_FILIAL==xFilial("SBF").AND.SBF->BF_PRODUTO==TB2->B1_COD.AND.SBF->BF_LOCAL==TB2->B1_LOCPAD
			///
			///Verifica se jah foi gerada etiqueta para o produto/local/data
			///
			SZP->(dbSeek(xFilial("SZP")+DTOS(mv_par01)+TB2->B1_COD+TB2->B1_LOCPAD+SBF->BF_LOCALIZ))
			IF ( SZP->(!EOF()) )
				dbSelectArea("SZP")
				RecLock("SZP",.F.)
				SZP->ZP_ESTOQ := B2QATU
				SZP->ZP_CUSTO := B2VATU
				SZP->ZP_CM1   := nCm1
				MsUnlock()
			ELSE
				///
				///Gera Digito Verificador
				///
				nFicha += 1 
				cFicha := Dig_Ver(nFicha)
				
				DbSelectArea("SZP")
				RecLock("SZP",.T.)
				SZP->ZP_Filial  := xFilial("SZP")
				SZP->ZP_Data    := mv_par01
				SZP->ZP_Ficha   := cFicha           //StrZero(nFicha,6)
				SZP->ZP_Cod     := TB2->B1_Cod
				SZP->ZP_Desc    := TB2->B1_Desc
				SZP->ZP_Local   := TB2->B1_Locpad
				SZP->ZP_UM      := TB2->B1_UM       
				SZP->ZP_STATUS  := IIF(TB2->B1_TIPO=="PA","1",IIF(TB2->B1_TIPO=="PI","2",IIF(TB2->B1_TIPO=="MP","3","")))
				SZP->ZP_LOCALIZ := SBF->BF_LOCALIZ
				SZP->ZP_ESTOQ   := B2QATU
				SZP->ZP_CUSTO   := B2VATU
				SZP->ZP_CM1     := nCm1
				//SZP->ZP_ESTEND  := SBF->BF_QUANT
				MsUnLock()
			ENDIF
			dbSelectArea("SBF")
			dbSkip()
		ENDDO	
		IF ( mFicha == nFicha )
			///
			///Verifica se jah foi gerada etiqueta para o produto/local/data
			///
			SZP->(dbSeek(xFilial("SZP")+DTOS(mv_par01)+TB2->B1_COD+TB2->B1_LOCPAD+mv_par08))
			IF ( SZP->(!EOF()) )
				dbSelectArea("SZP")
				RecLock("SZP",.F.)
				SZP->ZP_ESTOQ := B2QATU
				SZP->ZP_CUSTO := B2VATU
				SZP->ZP_CM1   := nCm1
				MsUnlock()
			ELSE
				///
				///Gera Digito Verificador
				///
				nFicha += 1 
				cFicha := Dig_Ver(nFicha)
				
				DbSelectArea("SZP")
				RecLock("SZP",.T.)
				SZP->ZP_Filial  := xFilial("SZP")
				SZP->ZP_Data    := mv_par01
				SZP->ZP_Ficha   := cFicha     
				SZP->ZP_Cod     := TB2->B1_Cod
				SZP->ZP_Desc    := TB2->B1_Desc
				SZP->ZP_Local   := TB2->B1_Locpad
				SZP->ZP_UM      := TB2->B1_UM
				SZP->ZP_STATUS  := IIF(TB2->B1_TIPO=="PA","1",IIF(TB2->B1_TIPO=="PI","2",IIF(TB2->B1_TIPO=="MP","3","")))
				SZP->ZP_LOCALIZ := mv_par08
				SZP->ZP_ESTOQ   := B2QATU
				SZP->ZP_CUSTO   := B2VATU
				SZP->ZP_CM1     := nCm1
				//SZP->ZP_ESTEND  := SBF->BF_QUANT
				MsUnLock()
			ENDIF
		ENDIF
		DbSelectArea("TB2")
	ENDIF
	DbSkip()
EndDo

TB2->(dbCloseArea())

IF ( !EMPTY(cFicha) )
   MsgInfo("Ficha(s) gerada(s) com sucesso!!!","Atenção")
ENDIF

Return

/////////////////////////////////////////////////////////////////////////////
Static Function Dig_Ver(xCpo)
/////////////////////////////////////////////////////////////////////////////
Local nX,nDig,nResult,nResto
Local cDigito
Local xCampo := STRZERO(xCpo,5)
Local nValor := 0

FOR nX:=1 TO LEN(aMod10)
    nDig    := VAL(SUBS(xCampo,nX,1))
    nResult := ( aMod10[nX] * nDig )
    IF ( nResult > 9 )
       nResult := STRZERO(nResult,2)
       nDig1   := VAL(SUBS(nResult,1,1))
       nDig2   := VAL(SUBS(nResult,2,1))
       nResult := ( nDig1 + nDig2 )
    ENDIF
    nValor := ( nValor + nResult )
NEXT
nResto  := ( nValor % 10 )
cDigito := IIF( nResto == 0 , "0" , STR( ( 10 - nResto ) , 1 ) )

Return((xCampo+cDigito))

///////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////////////////////////////////////////
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={} //Grupo|Ordem| Pegunt                          | perspa                          | pereng                           | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01     			  | DefSPA1 | DefEng1 | CNT01 | var02 | Def02       		 | DefSPA2 | DefEng2 | CNT02 | var03 | Def03            | DefSPA3 | DefEng3 | CNT03 | var04 | Def04    | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | PYME | GRPSX5 | HELP | PICTURE
aAdd(aRegs,{ cPerg,"01" , "Data Inventario              ?","Data Inventario              ?" , "Data Inventario              ?" , "mv_ch1" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_par01", "         			" , "     " , "     " , "   " , "   " , "         		  " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"02" , "Do Produto                   ?","Do Produto                   ?" , "Do Produto                   ?" , "mv_ch2" , "C" ,   30   ,   0   ,   0   , "G" , "          "  , "mv_par02", "         			" , "     " , "     " , "   " , "   " , "         		  " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"03" , "Até o Produto                ?","Até o Produto                ?" , "Até o Produto                ?" , "mv_ch3" , "C" ,   30   ,   0   ,   0   , "G" , "          "  , "mv_par03", "         			" , "     " , "     " , "   " , "   " , "         		  " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"04" , "Do Local                     ?","Do Local                     ?" , "Do Local                     ?" , "mv_ch4" , "C" ,   02   ,   0   ,   0   , "G" , "          "  , "mv_par04", "         			" , "     " , "     " , "   " , "   " , "         		  " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"05" , "Até o Local                  ?","Até o Local                  ?" , "Até o Local                  ?" , "mv_ch5" , "C" ,   02   ,   0   ,   0   , "G" , "          "  , "mv_par05", "         			" , "     " , "     " , "   " , "   " , "         		  " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"06" , "Tipo Produto                 ?","Tipo Produto                 ?" , "Tipo Produto                 ?" , "mv_ch6" , "C" ,   06   ,   0   ,   0   , "G" , "          "  , "mv_par06", "         			" , "     " , "     " , "   " , "   " , "         		  " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"07" , "Gera Saldo Zerado            ?","Gera Saldo Zerado            ?" , "Gera Saldo Zerado            ?" , "mv_ch7" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par07", "Produto-Acabado " , "     " , "     " , "   " , "   " , "Produto-Interm " , "     " , "     " , "   " , "   " , "Materia-Prima " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , " "  , "    " , "  " , "          " })
aAdd(aRegs,{ cPerg,"08" , "Localizacao                  ?","Localizacao                  ?" , "Localizacao                  ?" , "mv_ch8" , "C" ,   15   ,   0   ,   0   , "G" , "          "  , "mv_par08", "                " , "     " , "     " , "   " , "   " , "               " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SBE" , " "  , "    " , "  " , "          " })
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
	  RecLock("SX1",.T.)
		For j:=1 to FCount()
		  If j <= Len(aRegs[i])
			 FieldPut(j,aRegs[i,j])
		  Endif
		Next
	  MsUnlock()
	Endif
Next
	
Return
