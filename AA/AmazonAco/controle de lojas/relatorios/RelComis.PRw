#Include "rwmake.ch"
#include "Protheus.CH"

User Function RelComis()


Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de Comissão de Vendas."
Private cDesc3         := ""
Private cPict          := ""
Private Li           	 := 70
Private Cabec1         := "Num/Pref/Parc    Tipo  Cliente                   Emissao    Baixa            Valor %Comissão  Vl Comissão "
Private Cabec2         := ""
Private imprime        := .T.
Private aOrd           := {}
Private titulo       := "COMISSAO DE VENDAS "
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "RELCOMIS"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(08)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELCOM"
Private cPerg        := Padr("RELCOMIS  ",Len(SX1->X1_GRUPO))
Private cString      := "SE1"
Private cVendedor    := Space(06)
Private nTotGeral 	 := 0
Private nComTipo 	 := 0
Private nTotVend 	 := 0
Private	nTotTipo 	 := 0
Private nGerTipo     := 0
Private nComVend     := 0
Private nValSE5      := 0
Private dDtSE5       := Space(08)
Private nContParc    := 0
Private nGeral       := 0

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Titulo := Titulo+"-"+Iif(MV_PAR05==1,"PELA BAIXA","PELA EMISSAO")
Titulo := Titulo+"-"+Iif(MV_PAR09==1,"Por VENDEDOR ","Por PRODUTO")
Titulo := Titulo+"-"+Iif(MV_PAR08==1,"DESP. DEV = SIM ","DESP. DEV = NAO")
If MV_PAR05 = 1 // Pela Baixa
	Cabec2 := "EMISSÃO: "+DTOC(MV_PAR10)+" até "+DTOC(MV_PAR11)+" ---> BAIXA: "+DTOC(MV_PAR03)+" até "+DTOC(MV_PAR04)
Else
	Cabec2 := "EMISSÃO: "+DTOC(MV_PAR10)+" até "+DTOC(MV_PAR11)
EndIf
If MV_PAR09 == 2 //Por PRODUTO
	Cabec1         := "Num/Pref/Parc    Tipo  Cliente                   Emissao    Baixa               Produto                                Valor  %Comissão     Comissão"
EndIf

RptStatus({|| RunReport(Cabec1,PADC(Cabec2,200),Titulo,Li) },Titulo)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return


Static Function RunReport(Cabec1,Cabec2,Titulo,Li)

DbSelectArea("SA1")
DbSetOrder(1)

DbSelectArea("SA3")
DbSetOrder(1)

DbSelectArea("SE5")
DbSetOrder(7)

DbSelectArea("SB1")
DbSetOrder(1)

Query("SIGA") // Comissão de Vendas
Imprime("SIGA")
COMIS->(dbCloseArea())

If MV_PAR09 == 2 .And. MV_PAR05 = 1 //Por PRODUTO e Pela Baixa
	Query("MIG") // Comissão de Vendas
	Imprime("MIG")
	COMIS->(dbCloseArea())
EndIf

Return()


Static Function Imprime(xNome)

DbSelectArea("COMIS")

Do While !Eof()
	
	cVendedor := COMIS->E1_VEND1
	nTotVend  := 0
	nGerTipo  := 0
	
	If li > 60
		Li := Cabec(Titulo,Cabec1,PADC(Cabec2,200),NomeProg,Tamanho,nTipo) + 1
	EndIf
	
	SA3->(DbSeek(xFilial("SA3")+cVendedor))
	
	@li,00 PSAY "Vendedor : "+COMIS->E1_VEND1+" - "+SA3->A3_NREDUZ+" "+xNome
	
	Do While !Eof() .And. cVendedor == COMIS->E1_VEND1  // Verifica o Vendedor
		
		cTipo 		:= COMIS->E1_TIPO
		nTotTipo 	:= 0
		nComTipo    := 0
		
		Do While !Eof() .And. cVendedor == COMIS->E1_VEND1 .And. cTipo == COMIS->E1_TIPO  // Totaliza a comissão por Vendedor e por Tipo de Venda
			
			If li > 60
				Li := Cabec(Titulo,Cabec1,PADC(Cabec2,200),NomeProg,Tamanho,nTipo) + 1
			EndIf
			
			If MV_PAR09 == 1 									// Por Vendedor
				
				If MV_PAR05 == 1 								// Pela Baixa
					
					If ! Alltrim(COMIS->E1_TIPO) $ "CC"  		// Se NÃO for Cartão de Crédito, verifica se o título foi baixado no SE5
						
						BaiXEmi("B")
						nComVend := Round(nValSE5*(COMIS->E1_COMIS1/100),4)		//Valor da Comissão do Vendedor
						
					Else
						nValSE5 := COMIS->E1_VALOR       							// Se for Cartão de Crédito paga a comissão para o vendedor independentemente do recebimento
						nComVend := Round(nValSE5*(COMIS->E1_COMIS1/100),4)			//Valor da Comissão do Vendedor
					EndIf
					
				Else 											// Pela Emissão
					
					nValProd   	:= COMIS->E1_VALOR       		// Pagamento de comissão pela Emissão do título
					nComVend 	:= Round(nValProd*(COMIS->E1_COMIS1/100),4)
					
				EndIf
				
			Else // Por Produto
				
				If COMIS->E1_PREFIXO <> "MIG"  								// Vendas do Microsiga
					
					BaiXEmi("E") 											// Para Calcular o Número de Parcelas e dividir pelo valor de venda do produto
					
					nValProd   	:= COMIS->D2_TOTAL/nContParc  				// Divide o valor da venda pelo número de parcelas da venda
					
					nComVend 	:= Round(nValProd*(COMIS->D2_COMIS1/100),4)
					
				Else  														// Vendas do SCE (Sistema Antigo)
					
					If COMIS->ZD_COMIS = 0  								// Considera somente as comissões zeradas
						
						nValProd   := COMIS->ZD_VLRPROD/COMIS->ZD_NUMPARC  	// Divide o valor da venda pelo número de parcelas da venda
						
						nComVend := Round(nValProd*(0.5/100),4)             // % FIXO da Comissão do sistema antigo
						
					Else 													// Ignora as comissões maiores que zero, devido a comissão já ter sido paga
						
						nComVend := 0
						nValProd := 0
						
					EndIf
					
				EndIf
				
			EndIf
			
			If nComVend > 0
				
				SA1->(DbSeek(xFilial("SA1")+COMIS->E1_CLIENTE+COMIS->E1_LOJA))
				
				If MV_PAR06 == 1 //Analitico
					
					li++
					@li,00 PSAY COMIS->E1_NUM+"/"+COMIS->E1_PREFIXO+"/"+COMIS->E1_PARCELA
					@li,pCol()+1 PSAY COMIS->E1_TIPO
					@li,pCol()+1 PSAY COMIS->E1_CLIENTE+" "+SA1->A1_NREDUZ
					@li,pCol()+1 PSAY DTOC(STOD(COMIS->E1_EMISSAO))
					@li,pCol()+2 PSAY IIf(MV_PAR05 == 1,dDtSE5,Space(08))
					
					If MV_PAR09 == 1 	// Por Vendedor
						@li,pCol()+4 PSAY Transform(IIf(MV_PAR05 == 1,nValSE5,nValProd),"@E 999,999,999.99")
						@li,pCol()+1 PSAY Transform(COMIS->E1_COMIS1,"@E 99.99")+"%"
						@li,pCol()+1 PSAY Transform(nComVend,"@E 999,999,999.9999")
					Else  				// Produto
						
						If COMIS->E1_PREFIXO <> "MIG"
							SB1->(DbSeek(xFilial("SB1")+COMIS->D2_COD))
							@li,pCol()+2 PSAY COMIS->D2_COD+" "+LEFT(SB1->B1_DESC,25)
							@li,pCol()+1 PSAY Transform(nValProd,"@E 999,999,999.99")
							@li,pCol()+1 PSAY Transform(COMIS->D2_COMIS1,"@E 99.99")+"%"
							@li,pCol()+4 PSAY Transform(nComVend,"@E 9,999,999.9999")
						Else
							SB1->(DbSeek(xFilial("SB1")+COMIS->ZD_PRODUTO))
							@li,pCol()+2 PSAY COMIS->ZD_PRODUTO+" "+LEFT(SB1->B1_DESC,25)
							@li,pCol()+1 PSAY Transform(nValProd,"@E 999,999,999.99")
							@li,pCol()+1 PSAY Transform(0.5,"@E 99.99")+"%"
							@li,pCol()+4 PSAY Transform(nComVend,"@E 9,999,999.9999")
						EndIf
						
					EndIf
					
				EndIf
				
			EndIf
			
			nComTipo += nComVend
			nTotVend += nComVend
			
			If MV_PAR09 == 1 	// Por Vendedor
				nTotTipo += IIf(MV_PAR05 == 1,nValSE5,COMIS->E1_VALOR)
			Else				// Produto
				nTotTipo += nValProd  // O Valor do Produto já divido pelas parcelas
			EndIf
			
			COMIS->(DbSkip())
			
		EndDo
		
		If MV_PAR06 == 1 // Analitico
			li++
		EndIf
		
		If MV_PAR09 == 1 	// Por Vendedor
			@ li, 51 PSAY "Total do Tipo : "+cTipo+" "+Transform(nTotTipo,"@E 999,999,999.99")
			@ li, 86 PSAY "Com. R$: "+Transform(nComTipo,"@E 9,999,999.9999")
		Else   				// Produto
			@ li, 091 PSAY "Total do Tipo : "+cTipo+" "+Transform(nTotTipo,"@E 999,999,999.99")
			@ li, 126 PSAY "Com.  R$: "+Transform(nComTipo,"@E 9,999,999.9999")
		EndIf
		
		nGerTipo += nTotTipo  // Total Geral do Tipo por Vendedor
		nGeral   += nGerTipo  // Total Geral do Tipo do relatório
		
		li ++
		
	EndDo
	
	nTotGeral += nTotVend   // Total Geral do Relatório
	
	If MV_PAR06 == 1 // Analitico
		li++
	EndIf
	
	If MV_PAR09 == 1 	// Por Vendedor
		@ li, 59  PSAY "Tot.Tipo    : "+Transform(nGerTipo,"@E 9,999,999.99")
		@ li, 86  PSAY "Vend R$ :"+Transform(nTotVend,"@E 9,999,999.9999")
	Else
		@ li, 99  PSAY "Tot.Tipo    : "+Transform(nGerTipo,"@E 9,999,999.99")
		@ li, 126 PSAY "Vend R$ : "+Transform(nTotVend,"@E 9,999,999.9999")
	EndIf
	
	li +=2
	
	If MV_PAR07 == 2 // SIM Salta Pagina por Vendedor
		Li := Cabec(Titulo,Cabec1,PADC(Cabec2,200),NomeProg,Tamanho,nTipo) + 1
	EndIf
	
EndDo

li += 2

If MV_PAR09 == 1 	// Por Vendedor
	@ li, 73  PSAY "Total do Geral R$ : "+Transform(nTotGeral,"@E 999,999,999.9999")
Else
	@ li, 114 PSAY "Total do Geral R$ : "+Transform(nTotGeral,"@E 999,999,999.9999")
EndIf
                                                    
li:=li+3

Return()


Static Function ValidPerg(cPerg)
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg :="RELCOMIS  "
aRegs :={}
aAdd(aRegs,{cPerg,"01","Do Vendedor             ?", "" , "", "mv_ch1","C" ,06, 0 , 0 ,"G", "" , "MV_PAR01", ""         , "", "", "","",""         ,"","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"02","Ate o Vendedor          ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", ""		   , "", "", "","",""		  ,"","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"03","Da Data Baixa           ?", "" , "", "mv_ch3","D" ,08, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data Baixa        ?", "" , "", "mv_ch4","D" ,08, 0 , 0 ,"G", "" , "MV_PAR04", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo Calculo            ?", "" , "", "mv_ch5","N" ,01, 0 , 0 ,"C", "" , "MV_PAR05", "Baixa    ", "", "", "","","Emissão  ","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"06","Imprime                 ?", "" , "", "mv_ch6","N" ,01, 0 , 0 ,"C", "" , "MV_PAR06", "Analitico", "", "", "","","Sintetico","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"07","Salta Pagina por Vend.  ?", "" , "", "mv_ch7","N" ,01, 0 , 0 ,"C", "" , "MV_PAR07", "Nao      ", "", "", "","","Sim      ","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"08","Despreza  Devoluções    ?", "" , "", "mv_ch8","N" ,01, 0 , 0 ,"C", "" , "MV_PAR08", "Sim      ", "", "", "","","Nao      ","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"09","Comissao por            ?", "" , "", "mv_ch9","N" ,01, 0 , 0 ,"C", "" , "MV_PAR09", "Vendedor ", "", "", "","","Produto  ","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"10","Da Data Emissao         ?", "" , "", "mv_chA","D" ,08, 0 , 0 ,"G", "" , "MV_PAR10", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Ate a Data Emissao      ?", "" , "", "mv_chB","D" ,08, 0 , 0 ,"G", "" , "MV_PAR11", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})

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
dbSelectArea(_sAlias)
Return




Static Function Query(xTpQry)

// Query que leva em consideração as comissões pela baixa ou pela emissão / Por PRODUTO OU VENDEDOR

If xTpQry <> "MIG"  // VENDAS MICROSIGA
	
	If MV_PAR05 == 1  // Baixa
		
		If MV_PAR09 == 1 // Por Vendedor
			cQry := "SELECT DISTINCT E1_NUM, E1_PREFIXO, E1_VEND1, E1_TIPO, E1_COMIS1, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_PARCELA, E1_VALOR, E1_FATPREF, E1_FATURA "
			cQry += "FROM "+RetSqlName("SE1")+" A, "+RetSqlName("SE5")+" B "
		Else   // Por Produto
			cQry := "SELECT DISTINCT E1_NUM, E1_PREFIXO, E1_VEND1, E1_TIPO, E1_COMIS1, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_PARCELA, E1_VALOR, E1_FATPREF, E1_FATURA, D2_DOC, D2_SERIE, D2_COD, D2_TOTAL, D2_COMIS1 "
			cQry += "FROM "+RetSqlName("SE1")+" A, "+RetSqlName("SE5")+" B, "+RetSqlName("SD2")+" C "
		EndIf
		
		// Verifica o CR
		cQry += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
		cQry += "E1_EMISSAO >= '"+DTOS(MV_PAR10)+"' AND E1_EMISSAO <= '"+DTOS(MV_PAR11)+"' AND "
		cQry += "E1_VEND1 >= '"+MV_PAR01+"' AND E1_VEND1 <= '"+MV_PAR02+"' AND "
		cQry += "E1_TIPO NOT IN ('RA','FT') AND "
		cQry += "E1_NUMLIQ = '' AND E1_FATURA <> 'NOTFAT' AND "
		cQry += "A.D_E_L_E_T_ <> '*' AND "
		cQry += "A.E1_PREFIXO <> 'MIG' AND "
		
		// Verifica se o título foi baixado, se for diferente de CC
		cQry += "( (A.E1_PREFIXO = B.E5_PREFIXO AND A.E1_NUM = B.E5_NUMERO AND "
		cQry += "A.E1_PARCELA = B.E5_PARCELA AND "
		cQry += "B.E5_DATA >= '"+DTOS(MV_PAR03)+"' AND B.E5_DATA <= '"+DTOS(MV_PAR04)+"' AND "
		cQry += "B.E5_MOTBX IN ('NOR','CMP') AND "
		cQry += "B.E5_SITUACA <> 'C' AND "
		cQry += "B.D_E_L_E_T_ <> '*' ) OR "
		
		// No caso de CC, verifica operiodo de emissão
		cQry += "(A.E1_TIPO = 'CC' AND A.E1_EMISSAO >= '"+DTOS(MV_PAR03)+"' AND A.E1_EMISSAO <= '"+DTOS(MV_PAR04)+"' ) ) "
		
		
		If MV_PAR09 == 2 // Por Produto
			cQry += "AND A.E1_NUM = C.D2_DOC AND "
			cQry += "A.E1_PREFIXO = C.D2_SERIE AND "
			cQry += "C.D_E_L_E_T_ <> '*' "
		EndIf
		
		If MV_PAR08 == 1 // Verifica se o título foi baixado por devolução e o despreza - Devolução = SIM
			cQry += "AND "
			cQry += "NOT EXISTS( "
			cQry += "SELECT DISTINCT D1_NFORI, D1_SERIORI, D1_ITEMORI, D1_DOC, D1_SERIE, D1_EMISSAO "
			cQry += "FROM  "+RetSqlName("SD1")+" D "
			cQry += "WHERE D.D1_FILIAL = '"+xFilial("SD1")+"' AND "
			cQry += "D1_TIPO = 'D' AND "
			cQry += "(A.E1_NUM = D1_NFORI AND A.E1_PREFIXO = D1_SERIORI) OR (A.E1_NUM = D1_DOC AND A.E1_PREFIXO = D1_SERIE)  AND "
			cQry += "D_E_L_E_T_ <> '*' )"
		EndIf
		
		cQry += "ORDER BY E1_VEND1, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA "
		
	Else  // Emissão
		
		If MV_PAR09 == 1 // Por Vendedor
			cQry := "SELECT DISTINCT E1_NUM, E1_PREFIXO, E1_VEND1, E1_TIPO, E1_COMIS1, E1_CLIENTE, E1_VALOR, E1_LOJA, E1_EMISSAO, E1_PARCELA, E1_FATPREF, E1_FATURA "
			cQry += "FROM "+RetSqlName("SE1")+" A "
		Else   // Por Produto
			cQry := "SELECT E1_NUM, E1_PREFIXO, E1_VEND1, E1_TIPO, E1_COMIS1, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_PARCELA, E1_FATPREF, E1_FATURA, D2_DOC, D2_SERIE, D2_COD, D2_TOTAL, D2_COMIS1 "
			cQry += "FROM "+RetSqlName("SE1")+" A, "+RetSqlName("SD2")+" C "
		EndIf
		
		// Verifica o CR
		cQry += "WHERE E1_VEND1 >= '"+MV_PAR01+"' AND E1_VEND1 <= '"+MV_PAR02+"'AND E1_EMISSAO >= '"+DTOS(MV_PAR10)+"' AND E1_EMISSAO <= '"+DTOS(MV_PAR11)+"' AND "
		cQry += "E1_TIPO NOT IN ('CR','RA','FT') AND "
		cQry += "E1_NUMLIQ = '' AND E1_FATURA <> 'NOTFAT' AND "
		cQry += "A.D_E_L_E_T_ <> '*' "
		
		If MV_PAR09 == 2 // Por Produto
			cQry += "AND A.E1_NUM = C.D2_DOC AND "
			cQry += "A.E1_PREFIXO = C.D2_SERIE AND "
			cQry += "C.D_E_L_E_T_ <> '*' "
		EndIf
		
		If MV_PAR08 == 1 // Verifica se o título foi baixado por devolução e o despreza - Devolução = SIM
			cQry += "AND "
			cQry += "NOT EXISTS( "
			cQry += "SELECT DISTINCT D1_NFORI, D1_SERIORI, D1_ITEMORI, D1_DOC, D1_SERIE, D1_EMISSAO "
			cQry += "FROM  "+RetSqlName("SD1")+" D "
			cQry += "WHERE D.D1_FILIAL = '"+xFilial("SD1")+"' AND "
			cQry += "D1_TIPO = 'D' AND "
			cQry += "(A.E1_NUM = D1_NFORI AND A.E1_PREFIXO = D1_SERIORI) OR (A.E1_NUM = D1_DOC AND A.E1_PREFIXO = D1_SERIE)  AND "
			cQry += "D_E_L_E_T_ <> '*' ) "
		EndIf
		
		cQry += "ORDER BY E1_VEND1, E1_TIPO, E1_EMISSAO, E1_PREFIXO, E1_NUM "
		
	EndIf
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'COMIS', .F., .T.)
	
Else // MIGRAÇÃO
	
	
	If MV_PAR09 == 1 // Por Vendedor
		cQry := "SELECT DISTINCT E1_NUM, E1_PREFIXO, E1_VEND1, E1_TIPO, E1_COMIS1, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_PARCELA, E1_VALOR, E1_FATPREF, E1_FATURA "
		cQry += "FROM "+RetSqlName("SE1")+" A, "+RetSqlName("SE5")+" B "
	Else   // Por Produto
		cQry := "SELECT DISTINCT E1_NUM, E1_PREFIXO, E1_VEND1, E1_TIPO, E1_COMIS1, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_PARCELA, E1_VALOR, E1_FATPREF, E1_FATURA, ZD_NOTA, ZD_COMIS, ZD_NUMPARC, ZD_PRODUTO, ZD_VLRPROD  "
		cQry += "FROM "+RetSqlName("SE1")+" A, "+RetSqlName("SE5")+" B, "+RetSqlName("SZD")+" C "
	EndIf
	
	cQry += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cQry += "E1_VEND1 >= '"+MV_PAR01+"' AND E1_VEND1 <= '"+MV_PAR02+"' AND "
	cQry += "E1_TIPO NOT IN ('DV ','RA ') AND "
	cQry += "E1_NUMLIQ = '' AND E1_FATURA = '' AND "
	cQry += "A.D_E_L_E_T_ <> '*' AND "
	
	cQry += "( (A.E1_PREFIXO = B.E5_PREFIXO AND A.E1_NUM = B.E5_NUMERO AND "
	cQry += "A.E1_PARCELA = B.E5_PARCELA AND "
	cQry += "B.E5_DATA >= '"+DTOS(MV_PAR03)+"' AND B.E5_DATA <= '"+DTOS(MV_PAR04)+"' AND "
	cQry += "B.E5_MOTBX IN ('NOR','CMP','FAT') AND "
	cQry += "B.E5_SITUACA <> 'C' AND "
	cQry += "B.D_E_L_E_T_ <> '*' ) OR "
	
	cQry += "(A.E1_TIPO = 'CC' AND A.E1_EMISSAO >= '"+DTOS(MV_PAR03)+"' AND A.E1_EMISSAO <= '"+DTOS(MV_PAR04)+"' ) ) "
	
	
	If MV_PAR09 == 2 // Por Produto
		cQry += "AND A.E1_NUM = C.ZD_NOTA AND "
		cQry += "C.D_E_L_E_T_ <> '*' "
	EndIf
	
	If MV_PAR08 == 1 // Despreza Devolução = SIM
		cQry += "AND "
		cQry += "NOT EXISTS( "
		cQry += "SELECT DISTINCT D1_NFORI, D1_SERIORI, D1_ITEMORI, D1_DOC, D1_SERIE, D1_EMISSAO "
		cQry += "FROM  "+RetSqlName("SD1")+" D "
		cQry += "WHERE D.D1_FILIAL = '"+xFilial("SD1")+"' AND "
		cQry += "D1_TIPO = 'D' AND "
		cQry += "(A.E1_NUM = D1_NFORI AND A.E1_PREFIXO = D1_SERIORI) OR (A.E1_NUM = D1_DOC AND A.E1_PREFIXO = D1_SERIE)  AND "
		cQry += "D_E_L_E_T_ <> '*' )"
	EndIf
	
	cQry += "ORDER BY E1_VEND1, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'COMIS', .F., .T.)
	
	Return()
	
EndIf

Static Function BaiXEmi(xTipo)
// Função que verifica o valor e data da Baixa, quando o tipo for diferente de Cartão de Crédito, no caso de Cartão de Crédito é pela emissão e
// dividir o número de parcelas

If xTipo == "B"
	
	If SE5->(DbSeek(xFilial("SE5")+COMIS->E1_PREFIXO+COMIS->E1_NUM+COMIS->E1_PARCELA))
		
		nValSE5 := 0
		
		Do While !SE5->(Eof()) .And. xFilial("SE5")+COMIS->(E1_PREFIXO+E1_NUM+E1_PARCELA) == ;  //Depende do DbselectArea atual (COMIS ou FAT)
			SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA)
			
			nValSE5 += SE5->E5_VALOR
			dDtSE5  := SE5->E5_DATA
			
			SE5->(DbSkip())
			
		EndDo
		
	EndIf
	
Else
	
	nContParc := 0
	
	lAchou := SE1->(DbSeek(xFilial("SE1")+COMIS->E1_PREFIXO+COMIS->E1_NUM))
	cPref  := COMIS->E1_PREFIXO
	cNum   := COMIS->E1_NUM
	
	If lAchou
		
		Do While !SE1->(Eof()) .And. xFilial("SE1")+cPref+cNum == ;  		//Depende do DbselectArea atual (COMIS ou FAT)
			SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)
			
			nContParc ++
			SE1->(DbSkip())
			
		EndDo
		
	EndIf
	
EndIf

Return

