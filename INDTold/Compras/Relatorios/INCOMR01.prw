#INCLUDE "rwmake.ch"
#include "Protheus.ch"

/*/
#############################################################################
±±ºPrograma  ³INCOMR01  º Autor ³ ENER FREDES        º Data ³  09/04/09   º±±
#############################################################################
±±ºDescricao ³ Relatorio de controle de Posionamento de Compras           º±±
±±º          ³                                                            º±±
#############################################################################
±±ºUso       ³ COMPRAS - Relatório                                        º±±
#############################################################################
/*/

User Function INCOMR01
	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Posicionamento das Compras"
	Local cPict        := ""
	Local titulo       := "Posicionamento das Compras"
	Local nLin         := 80
	Local Cabec1       := "        Posição                             Pedidos     Pedidos    Pedidos    Despesas    Pedidos                      Pedidos     Pedidos    Pedidos    Despesas    Pedidos"
	Local Cabec2       := "Filial/Stream/Classe MCT                   Emitidos   Pendentes  Entregues  Acessorias      Pagos                     Emitidos   Pendentes  Entregues  Acessorias      Pagos"
	Local Cabec3       := "                                                                          P E R I O D O                                                              A C U M U L A D O "
	Local Cabec4       := "Filial/Stream/Classe MCT                                     Ped.Emit       Ped.Pend      Pend.Entr     Desp.Assec       Ped.Pag                  Ped.Emit       Ped.Pend      Pend.Entr     Desp.Assec        Ped.Pag"
	Local imprime      := .T.
	Local aOrd := {"Por Filial+Stream+Classe MCT","Por Filial+Stream+Classe MCT+Pedido","Por Filial","Por Stream","Por Classe MCT"}

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 220
	Private tamanho     := "G"
	Private nomeprog    := "INCOMR01" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "INCOMR01" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg      := PADR("INCOMR01",Len(SX1->X1_GRUPO))
	Private cString    := "SC7"
	Private aFilial    := {}
	Private aStream    := {}         
	Private aPlanilha  := {}         
	Private nOrdem 
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	titulo := Alltrim(titulo)
	nOrdem := aReturn[8] 
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	Processa({|| ExecProc() }, "Filtrando dados")
	If MV_PAR04 == 1
		RptStatus({|| RunReport(Cabec3,Cabec4,Titulo,nLin) },Titulo)
	ElseIf MV_PAR04 == 2
		Processa({|| RunExcel() },"Gerando em Excel...")
	EndIf  
Return

Static Function ExecProc()
	Local cQuery := ""      
	Local aTemp := {}
	
	fGeraTmp(1,.F.)
	fMontaDados(1)                                
	fGeraTmp(2,.F.)
	fMontaDados(2)                                
	fGeraTmp(3,.F.)
	fMontaDados(3)                                
	fGeraTmp(4,.F.)
	fMontaDados(4)                                
	fGeraTmp(5,.F.)
	fMontaDados(5)    
	
	fGeraTmp(1,.T.)
	fMontaDados(6)                                
	fGeraTmp(2,.T.)
	fMontaDados(7)                                
	fGeraTmp(3,.T.)
	fMontaDados(8)                                
	fGeraTmp(4,.T.)
	fMontaDados(9)                                
	fGeraTmp(5,.T.)
	fMontaDados(10)    
	
	If nOrdem == 5
		For it := 1 to Len(aPlanilha)
			nPos := Ascan( aTemp , {|x| x[2] == aPlanilha[it,3]})
			If nPos == 0
				AAdd(aTemp,{"","",aPlanilha[it,3],aPlanilha[it,4],0,0,0,0,0,0,0,0,0,0})
				nPos := Len(aTemp)
			EndIf              
			aTemp[nPos,5] += aPlanilha[it,5]                               
			aTemp[nPos,6] += aPlanilha[it,6]                               
			aTemp[nPos,7] += aPlanilha[it,7]                               
			aTemp[nPos,8] += aPlanilha[it,8]                               
			aTemp[nPos,9] += aPlanilha[it,9]                               
			
			aTemp[nPos,10] += aPlanilha[it,10]                               
			aTemp[nPos,11] += aPlanilha[it,11]                               
			aTemp[nPos,12] += aPlanilha[it,12]                               
			aTemp[nPos,13] += aPlanilha[it,13]                               
			aTemp[nPos,14] += aPlanilha[it,14]                               
		Next
		aTemp :=	aSort(aTemp , , , { |x,y| x[3] < y[3]} )
		aPlanilha := aTemp
	Else
		aPlanilha :=	aSort(aPlanilha , , , { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3]} )
	EndIf  
	If nOrdem == 4
		For it := 1 to Len(aStream)
			nPos := Ascan( aTemp , {|x| x[2] == aStream[it,2]})
			If nPos == 0
				AAdd(aTemp,{"",aStream[it,2],aStream[it,3],0,0,0,0,0,0,0,0,0,0})
				nPos := Len(aTemp)
			EndIf              
			aTemp[nPos,4] += aStream[it,4]                               
			aTemp[nPos,5] += aStream[it,5]                               
			aTemp[nPos,6] += aStream[it,6]                               
			aTemp[nPos,7] += aStream[it,7]                               
			aTemp[nPos,8] += aStream[it,8]                               
			
			aTemp[nPos,9]  += aStream[it,9]                               
			aTemp[nPos,10] += aStream[it,10]                               
			aTemp[nPos,11] += aStream[it,11]                               
			aTemp[nPos,12] += aStream[it,12]                               
			aTemp[nPos,13] += aStream[it,13]                               
			
		Next
		aTemp :=	aSort(aTemp , , , { |x,y| x[2] < y[2]} )
		aStream := aTemp
	EndIf
Return 

Static Function fMontaDados(nIt)
	Local nPos
	Local cDescFil
	
	TMP->(DbGotop())
	While !TMP->(Eof())
		nPos := Ascan( aFilial , {|x| x[1] == TMP->FILIAL})
		If nPos == 0
			cDescFil := posicione("SM0",1,"01"+TMP->FILIAL,"M0_FILIAL")
			AAdd(aFilial,{TMP->FILIAL,cDescFil,0,0,0,0,0,0,0,0,0,0})
			nPos := Len(aFilial)
		EndIf  
		aFilial[nPos,2+nIt]+= TMP->VALOR
		
		nPos := Ascan( aStream , {|x| x[1] == TMP->FILIAL .AND. x[2] == TMP->STREAM})
		If nPos == 0
			AAdd(aStream,{TMP->FILIAL,TMP->STREAM,TMP->DESCSTREAM,0,0,0,0,0,0,0,0,0,0})
			nPos := Len(aStream)
		EndIf                                             
		aStream[nPos,3+nIt]+= TMP->VALOR
		
		nPos := Ascan( aPlanilha , {|x| x[1] == TMP->FILIAL .AND. x[2] == TMP->STREAM .AND. x[3] == TMP->MCT})
		If nPos == 0
			AAdd(aPlanilha,{TMP->FILIAL,TMP->STREAM,TMP->MCT,TMP->DESCMCT,0,0,0,0,0,0,0,0,0,0})
			nPos := Len(aPlanilha)
		EndIf                                             
		aPlanilha[nPos,4+nIt]+= TMP->VALOR
		
		TMP->(DbSkip())
	End
	DbSelectArea("TMP")
	dbCloseArea()
	
Return





Static Function fGeraTmp(nTipo,lAculmulado)
	Local cQuery := ""
	Do Case
	Case nTipo == 1
		cQuery += " SELECT C7_FILIAL FILIAL,PB1_CODIGO STREAM,PB1_DESC DESCSTREAM,C7_CLVL MCT,CTH_DESC01 DESCMCT
		cQuery += "        ,CAST(SUM(C7_TOTAL*C7_TXMOEDA) AS DECIMAL(12,2)) VALOR
		cQuery += " FROM SC7010 SC7 
		cQuery += " INNER JOIN "+RetSqlName("PB1")+" PB1 ON PB1_CODIGO = LEFT(C7_CC,2) AND PB1.D_E_L_E_T_ <> '*'
		cQuery += " INNER JOIN "+RetSqlName("CTH")+" CTH ON CTH_CLVL = C7_CLVL AND CTH.D_E_L_E_T_ <> '*'
		If lAculmulado
			cQuery += " WHERE C7_EMISSAO >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
		Else
			cQuery += " WHERE C7_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
		EndIf  
		cQuery += " AND SC7.D_E_L_E_T_ <> '*'
		cQuery += " GROUP BY C7_FILIAL,PB1_CODIGO,PB1_DESC,C7_CLVL,CTH_DESC01
		cQuery += " ORDER BY C7_FILIAL,PB1_CODIGO,SUM(C7_TOTAL*C7_TXMOEDA)
	Case nTipo == 2
		cQuery += " SELECT C7_FILIAL FILIAL,PB1_CODIGO STREAM,PB1_DESC DESCSTREAM,C7_CLVL MCT,CTH_DESC01 DESCMCT
		cQuery += "        ,CAST(SUM((C7_QUANT-C7_QUJE)*C7_PRECO*C7_TXMOEDA) AS DECIMAL(12,2)) VALOR
		cQuery += " FROM SC7010 SC7 
		cQuery += " INNER JOIN "+RetSqlName("PB1")+" PB1 ON PB1_CODIGO = LEFT(C7_CC,2) AND PB1.D_E_L_E_T_ <> '*'
		cQuery += " INNER JOIN "+RetSqlName("CTH")+" CTH ON CTH_CLVL = C7_CLVL AND CTH.D_E_L_E_T_ <> '*'
		If lAculmulado
			cQuery += " WHERE C7_EMISSAO >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
		Else
			cQuery += " WHERE C7_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
		EndIf  
		cQuery += " AND SC7.D_E_L_E_T_ <> '*'
		cQuery += " GROUP BY C7_FILIAL,PB1_CODIGO,PB1_DESC,C7_CLVL,CTH_DESC01
		cQuery += " ORDER BY C7_FILIAL,PB1_CODIGO,SUM(C7_TOTAL*C7_TXMOEDA)
	Case nTipo == 3
		cQuery += " SELECT D1_FILIAL FILIAL,PB1_CODIGO STREAM,PB1_DESC DESCSTREAM,D1_CLVL MCT,CTH_DESC01 DESCMCT
		cQuery += "        ,SUM(D1_TOTAL) VALOR
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 
		cQuery += " INNER JOIN "+RetSqlName("PB1")+" PB1 ON PB1_CODIGO = LEFT(D1_CC,2) AND PB1.D_E_L_E_T_ <> '*'
		cQuery += " INNER JOIN "+RetSqlName("CTH")+" CTH ON CTH_CLVL = D1_CLVL AND CTH.D_E_L_E_T_ <> '*'
		If MV_PAR03 == 1
			cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC AND SD1.D_E_L_E_T_ <> '*'
		EndIf  
		cQuery += " WHERE 
		If MV_PAR03 == 1
			If lAculmulado
				cQuery += " C7_EMISSAO >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
			Else
				cQuery += " C7_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
			EndIf  
		Else
			If lAculmulado
				cQuery += " D1_DTDIGIT >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND D1_DTDIGIT <= '"+Dtos(MV_PAR02)+"'
			Else
				cQuery += " D1_DTDIGIT >= '"+Dtos(MV_PAR01)+"' AND D1_DTDIGIT <= '"+Dtos(MV_PAR02)+"'
			EndIf  
		EndIf
		cQuery += " AND D1_TIPO = 'N' AND D1_PEDIDO <> ''
		cQuery += " GROUP BY D1_FILIAL,PB1_CODIGO,PB1_DESC,D1_CLVL,CTH_DESC01
		cQuery += " ORDER BY D1_FILIAL,PB1_CODIGO
	Case nTipo == 4            
		cQuery += " SELECT D1_FILIAL FILIAL,PB1_CODIGO STREAM,PB1_DESC DESCSTREAM,D1_CLVL MCT,CTH_DESC01 DESCMCT
		cQuery += "        ,SUM(D1_TOTAL) VALOR
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 
		cQuery += " INNER JOIN "+RetSqlName("PB1")+" PB1 ON PB1_CODIGO = LEFT(D1_CC,2) AND PB1.D_E_L_E_T_ <> '*'
		cQuery += " INNER JOIN "+RetSqlName("CTH")+" CTH ON CTH_CLVL = D1_CLVL AND CTH.D_E_L_E_T_ <> '*'
		If MV_PAR03 == 1
			cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC AND SD1.D_E_L_E_T_ <> '*'
		EndIf  
		cQuery += " WHERE 
		If MV_PAR03 == 1
			If lAculmulado
				cQuery += " C7_EMISSAO >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
			Else
				cQuery += " C7_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
			EndIf  
		Else
			If lAculmulado
				cQuery += " D1_DTDIGIT >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND D1_DTDIGIT <= '"+Dtos(MV_PAR02)+"'
			Else
				cQuery += " D1_DTDIGIT >= '"+Dtos(MV_PAR01)+"' AND D1_DTDIGIT <= '"+Dtos(MV_PAR02)+"'
			EndIf  
		EndIf
		cQuery += " AND D1_TIPO <> 'N' AND D1_TIPO <> 'D'
		cQuery += " GROUP BY D1_FILIAL,PB1_CODIGO,PB1_DESC,D1_CLVL,CTH_DESC01
		cQuery += " ORDER BY D1_FILIAL,PB1_CODIGO
	Case nTipo == 5
		cQuery += " SELECT D1_FILIAL FILIAL,PB1_CODIGO STREAM,PB1_DESC DESCSTREAM,D1_CLVL MCT,CTH_DESC01 DESCMCT
		cQuery += "        ,SUM(D1_TOTAL) VALOR
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 
		cQuery += "           INNER JOIN "+RetSqlName("SE2")+" SE2 ON E2_FILIAL = D1_FILIAL AND E2_NUM = D1_DOC AND E2_PREFIXO = D1_SERIE AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA  AND E2_SALDO = 0  AND SE2.D_E_L_E_T_ <> '*'
		cQuery += " INNER JOIN "+RetSqlName("PB1")+" PB1 ON PB1_CODIGO = LEFT(D1_CC,2) AND PB1.D_E_L_E_T_ <> '*'
		cQuery += " INNER JOIN "+RetSqlName("CTH")+" CTH ON CTH_CLVL = D1_CLVL AND CTH.D_E_L_E_T_ <> '*'
		If MV_PAR03 == 1
			cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC AND SD1.D_E_L_E_T_ <> '*'
		EndIf  
		cQuery += " WHERE 
		If MV_PAR03 == 1
			If lAculmulado
				cQuery += " C7_EMISSAO >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
			Else
				cQuery += " C7_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR02)+"'
			EndIf  
		Else
			If lAculmulado
				cQuery += " D1_DTDIGIT >= '"+StrZero(Year(MV_PAR02),4)+"0101' AND D1_DTDIGIT <= '"+Dtos(MV_PAR02)+"'
			Else
				cQuery += " D1_DTDIGIT >= '"+Dtos(MV_PAR01)+"' AND D1_DTDIGIT <= '"+Dtos(MV_PAR02)+"'
			EndIf  
		EndIf
		cQuery += " AND D1_PEDIDO <> ''
		cQuery += " GROUP BY D1_FILIAL,PB1_CODIGO,PB1_DESC,D1_CLVL,CTH_DESC01
		cQuery += " ORDER BY D1_FILIAL,PB1_CODIGO
	EndCase  
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP",.T.,.T.)
Return 



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local aTotal  := {0,0,0,0,0,0,0,0,0,0}
	Local nPos                  
	Local nCol1,nCol2,nCol3,nCol4,nCol5
	Local cFil,cStream

	nCol1  := 0
	nCol2  := 55
	nCol3  := 70
	nCol4  := 85
	nCol5  := 100
	nCol6  := 115
	
	nCol7  := 140
	nCol8  := 155
	nCol9  := 170
	nCol10 := 185
	nCol11 := 200
	
	SetRegua(Len(aPlanilha))  
	
	For i := 1 to Len(aPlanilha)
		IncRegua()
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif   
		If nOrdem <=3
			If cFil <> aPlanilha[i,1]
				nPos := Ascan( aFilial , {|x| x[1] == aPlanilha[i,1]})
				@nLin,nCol1  PSAY aFilial[nPos,1]+' - '+aFilial[nPos,2]
				@nLin,nCol2  PSAY Transform(aFilial[nPos,3],"@E 999,999,999.99")
				@nLin,nCol3  PSAY Transform(aFilial[nPos,4],"@E 999,999,999.99")
				@nLin,nCol4  PSAY Transform(aFilial[nPos,5],"@E 999,999,999.99")
				@nLin,nCol5  PSAY Transform(aFilial[nPos,6],"@E 999,999,999.99")
				@nLin,nCol6  PSAY Transform(aFilial[nPos,7],"@E 999,999,999.99")
				
				@nLin,nCol7  PSAY Transform(aFilial[nPos,8],"@E 999,999,999.99")
				@nLin,nCol8  PSAY Transform(aFilial[nPos,9],"@E 999,999,999.99")
				@nLin,nCol9  PSAY Transform(aFilial[nPos,10],"@E 999,999,999.99")
				@nLin,nCol10 PSAY Transform(aFilial[nPos,11],"@E 999,999,999.99")
				@nLin,nCol11 PSAY Transform(aFilial[nPos,12],"@E 999,999,999.99")
				
				cFil := aPlanilha[i,1]
				nLin++                  
			EndIf
		EndIf
		
		If nOrdem <> 3 .And. nOrdem <> 5
			If cStream <> aPlanilha[i,2]      
				If nOrdem == 4
					nPos := Ascan( aStream , {|x| x[2] == aPlanilha[i,2]})
				Else
					nPos := Ascan( aStream , {|x| x[1] == aPlanilha[i,1] .AND. x[2] == aPlanilha[i,2]})
				EndIf
				@nLin,nCol1+2 PSAY Left(Alltrim(aStream[nPos,2])+' - '+aStream[nPos,3],50)
				@nLin,nCol2   PSAY Transform(aStream[nPos,4],"@E 999,999,999.99")
				@nLin,nCol3   PSAY Transform(aStream[nPos,5],"@E 999,999,999.99")
				@nLin,nCol4   PSAY Transform(aStream[nPos,6],"@E 999,999,999.99")
				@nLin,nCol5   PSAY Transform(aStream[nPos,7],"@E 999,999,999.99")
				@nLin,nCol6   PSAY Transform(aStream[nPos,8],"@E 999,999,999.99")
				
				@nLin,nCol7   PSAY Transform(aStream[nPos,9],"@E 999,999,999.99")
				@nLin,nCol8   PSAY Transform(aStream[nPos,10],"@E 999,999,999.99")
				@nLin,nCol9   PSAY Transform(aStream[nPos,11],"@E 999,999,999.99")
				@nLin,nCol10  PSAY Transform(aStream[nPos,12],"@E 999,999,999.99")
				@nLin,nCol11  PSAY Transform(aStream[nPos,13],"@E 999,999,999.99")
				cStream := aPlanilha[i,2]
				nLin++                  
			EndIf
		EndIf
		     
		
		If nOrdem <> 3 .And. nOrdem <> 4
			@nLin,nCol1+4 PSAY Left(Alltrim(aPlanilha[i,3])+" - "+Alltrim(aPlanilha[i,4]),50)
			@nLin,nCol2   PSAY Transform(aPlanilha[i,5],"@E 999,999,999.99")
			@nLin,nCol3   PSAY Transform(aPlanilha[i,6],"@E 999,999,999.99")
			@nLin,nCol4   PSAY Transform(aPlanilha[i,7],"@E 999,999,999.99")
			@nLin,nCol5   PSAY Transform(aPlanilha[i,8],"@E 999,999,999.99")
			@nLin,nCol6   PSAY Transform(aPlanilha[i,9],"@E 999,999,999.99")
			
			@nLin,nCol7   PSAY Transform(aPlanilha[i,10],"@E 999,999,999.99")
			@nLin,nCol8   PSAY Transform(aPlanilha[i,11],"@E 999,999,999.99")
			@nLin,nCol9   PSAY Transform(aPlanilha[i,12],"@E 999,999,999.99")
			@nLin,nCol10  PSAY Transform(aPlanilha[i,13],"@E 999,999,999.99")
			@nLin,nCol11  PSAY Transform(aPlanilha[i,14],"@E 999,999,999.99")
			
			nLin++                  
		EndIf
		aTotal[1]+= aPlanilha[i,5]
		aTotal[2]+= aPlanilha[i,6]
		aTotal[3]+= aPlanilha[i,7]
		aTotal[4]+= aPlanilha[i,8]
		aTotal[5]+= aPlanilha[i,9]
		
		aTotal[6] += aPlanilha[i,10]
		aTotal[7] += aPlanilha[i,11]
		aTotal[8] += aPlanilha[i,12]
		aTotal[9] += aPlanilha[i,13]
		aTotal[10]+= aPlanilha[i,14]
	Next
	@nLin,00 PSAY Replicate("-",132)
	nLin++                 
	@nLin,nCol1  PSAY "Total INDT --->"
	@nLin,nCol2  PSAY Transform(aTotal[1],"@E 999,999,999.99")
	@nLin,nCol3  PSAY Transform(aTotal[2],"@E 999,999,999.99")
	@nLin,nCol4  PSAY Transform(aTotal[3],"@E 999,999,999.99")
	@nLin,nCol5  PSAY Transform(aTotal[4],"@E 999,999,999.99")
	@nLin,nCol6  PSAY Transform(aTotal[5],"@E 999,999,999.99")
	
	@nLin,nCol7  PSAY Transform(aTotal[6],"@E 999,999,999.99")
	@nLin,nCol8  PSAY Transform(aTotal[7],"@E 999,999,999.99")
	@nLin,nCol9  PSAY Transform(aTotal[8],"@E 999,999,999.99")
	@nLin,nCol10 PSAY Transform(aTotal[9],"@E 999,999,999.99")
	@nLin,nCol11 PSAY Transform(aTotal[10],"@E 999,999,999.99")
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return
    

Static Function RunExcel()
	Local oExcelApp                           
	Local aNome := {}
	Local aTotal  := {0,0,0,0,0,0,0,0,0,0}
	Local nPos                  
	Local cFil,cStream
	Local cArqTxt    := "C:\Temp\incomr01.xls"
	Local nHdl       := fCreate(cArqTxt)
	Local cLinha     := ""
	ProcRegua(Len(aPlanilha))  
	cFil    := ""        
	cStream := ""      
	fWrite(nHdl,cLinha,Len(cLinha))
	
	cLinha := "Filial/Area/Classe MCT"+Chr(9)
	cLinha += "Per - Ped.Emit"+Chr(9)
	cLinha += "Per - Ped.Pend"+Chr(9)
	cLinha += "Per - Pend.Entr"+Chr(9)
	cLinha += "Per - Desp.Assec"+Chr(9)
	cLinha += "Per - Ped.Pago"+Chr(9)
	
	cLinha += "Acu - Ped.Emit"+Chr(9)
	cLinha += "Acu - Ped.Pend"+Chr(9)
	cLinha += "Acu - Pend.Entr"+Chr(9)
	cLinha += "Acu - Desp.Assec"+Chr(9)
	cLinha += "Acu - Ped.Pago"+Chr(9)
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))
	
	For i := 1 to Len(aPlanilha)
		IncProc()
		If nOrdem <=3
			If cFil <> aPlanilha[i,1]
				nPos := Ascan( aFilial , {|x| x[1] == aPlanilha[i,1]})
				cFil := aPlanilha[i,1]
				cLinha := ""
				cLinha += aFilial[nPos,1]+' - '+aFilial[nPos,2]+Chr(9)
				cLinha += Transform(aFilial[nPos,3],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,4],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,5],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,6],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,7],"@E 999,999,999.99")+Chr(9)
				
				cLinha += Transform(aFilial[nPos,8],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,9],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,10],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,11],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aFilial[nPos,12],"@E 999,999,999.99")+Chr(9)
				cLinha += chr(13)+chr(10)
				fWrite(nHdl,cLinha,Len(cLinha))
			EndIf
		EndIf
		
		If nOrdem <> 3 .And. nOrdem <> 5
			If cStream <> aPlanilha[i,2]      
				If nOrdem == 4
					nPos := Ascan( aStream , {|x| x[2] == aPlanilha[i,2]})
				Else
					nPos := Ascan( aStream , {|x| x[1] == aPlanilha[i,1] .AND. x[2] == aPlanilha[i,2]})
				EndIf
				cStream := aPlanilha[i,2]
				cLinha := ""
				cLinha += Left(Alltrim(aStream[nPos,2])+' - '+aStream[nPos,3],50)+Chr(9)
				cLinha += Transform(aStream[nPos,4],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,5],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,6],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,7],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,8],"@E 999,999,999.99")+Chr(9)
				
				cLinha += Transform(aStream[nPos,9],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,10],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,11],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,12],"@E 999,999,999.99")+Chr(9)
				cLinha += Transform(aStream[nPos,13],"@E 999,999,999.99")+Chr(9)
				cLinha += chr(13)+chr(10)
				fWrite(nHdl,cLinha,Len(cLinha))
			EndIf
		EndIf
		
		If nOrdem <> 3 .And. nOrdem <> 4
			cLinha := ""
			cLinha += Left(Alltrim(aPlanilha[i,3])+" - "+Alltrim(aPlanilha[i,4]),50)+Chr(9)
			cLinha += Transform(aPlanilha[i,5],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,6],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,7],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,8],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,9],"@E 999,999,999.99")+Chr(9)
			
			cLinha += Transform(aPlanilha[i,10],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,11],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,12],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,13],"@E 999,999,999.99")+Chr(9)
			cLinha += Transform(aPlanilha[i,14],"@E 999,999,999.99")+Chr(9)
			cLinha += chr(13)+chr(10)
			fWrite(nHdl,cLinha,Len(cLinha))
		EndIf
		aTotal[1] += aPlanilha[i,5]
		aTotal[2] += aPlanilha[i,6]
		aTotal[3] += aPlanilha[i,7]
		aTotal[4] += aPlanilha[i,8]
		aTotal[5] += aPlanilha[i,9]
		
		aTotal[6] += aPlanilha[i,5]
		aTotal[7] += aPlanilha[i,6]
		aTotal[8] += aPlanilha[i,7]
		aTotal[9] += aPlanilha[i,8]
		aTotal[10]+= aPlanilha[i,9]
		
	Next
	cLinha := ""
	cLinha += "Total INDT --->"+Chr(9)
	cLinha += Transform(aTotal[1] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[2] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[3] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[4] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[5] ,"@E 999,999,999.99")+Chr(9)
	
	cLinha += Transform(aTotal[6] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[7] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[8] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[9] ,"@E 999,999,999.99")+Chr(9)
	cLinha += Transform(aTotal[10],"@E 999,999,999.99")+Chr(9)
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))
	fClose(nHdl)     
	
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' ) 
		Return
	EndIf  
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cArqTxt) 
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
Return             

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01","Da Emissão                   ?","Da Emissão                   ?","Da Emissão                   ?","mv_ch1","D",08,0,0,"G","","","","","mv_par01")
	u_INPutSX1(cPerg,"02","Ate Emissão                  ?","Ate Emissão                  ?","Ate Emissão                  ?","mv_ch2","D",08,0,0,"G","","","","","mv_par02")
	u_INPutSx1(cPerg,"03","Cons. NFE na Dt.Emissão do PC?","Cons. NFE na Dt.Emissão do PC?","Cons. NFE na Dt.Emissão do PC?","mv_ch3","N",01,0,0,"C","","","","","mv_par03","Sim","Sim","Sim","","Não","Não","Não")
	u_INPutSx1(cPerg,"04","Tipo Relatório               ?","Tipo Relatório               ?","Tipo Relatório               ?","mv_ch4","N",01,0,0,"C","","","","","mv_par04","Normal","Normal","Normal","","Excel","Excel","Excel")
Return
