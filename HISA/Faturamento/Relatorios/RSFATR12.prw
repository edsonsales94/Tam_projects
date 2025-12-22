#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR12  | Autor | Orismar Silva         | Data | 01/02/2014
//=================================================================================
// Descricao | Relatorio de comisssão de vendedor
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR12()

Private oReport, oSection1
Private cTitulo := "Relatório de comisssão de vendedor "

oReport := ReportDef()                         
If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf
oReport:PrintDialog()

Return

//=================================================================================
// relatorio de producao - formato personalizavel
//=================================================================================
Static Function ReportDef()
Local cPerg   := "RSFATARL"

CriaSx1(cPerg)

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATARL", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de comisssão de vendedor")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Relatório de comisssão de vendedor",{""})
oSection1:SetTotalInLine(.F.)
TRCell():New(oSection1, "C_LUGAR"	, "", "LUGAR"                  ,,05) 
TRCell():new(oSection1, "C_COD"     , "", "CÓDIGO"                 ,,10)
TRCell():new(oSection1, "C_NOME"    , "", "NOME DO REPRESENTANTE"  ,,35)
TRCell():new(oSection1, "C_TOTAL"   , "", "TOTAL"                  ,,15)
TRCell():New(oSection1, "C_PERC"	   , "", "%"                      ,,15)
TRCell():new(oSection1, "C_QTDPED"  , "", "QT PED"                 ,,15)
TRCell():new(oSection1, "C_MDPED"   , "", "MD PED"                 ,,15)
TRCell():new(oSection1, "C_TOTCOI"  , "", "VALOR COMISSÃO INDIVUAL",,15)
TRCell():new(oSection1, "C_TOTCOG"  , "", "VALOR COMISSÃO GLOBAL"  ,,15)
TRCell():new(oSection1, "C_TOTCOM"  , "", "VALOR TOTAL COMISSÃO"   ,,15)
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
   Local nCampo, ix
   //Local nTotQdt   := 0
	//Local nTotTotal := 0
	//Local nTotIcms  := 0           
	Local nMeta		 := 0
	Local nPerc		 := 0
   Local nVendedor := Fa440CntVen()
   Local cVendedor := "" 
   Local cCampo	 := ""
   Local cFilterQry:= ""
   Local cAddField := ""   
   Local aVendedor := {}
   

   
   oSection1 := oReport:Section(1)

   oSection1:Init()
   oSection1:SetHeaderSection(.T.)

   *
   
   cVendedor := "1"
	For nCampo := 1 To nVendedor
		 cCampo := "F2_VEND"+cVendedor
		 If SF2->(FieldPos(cCampo)) > 0
			 cFilterQry += "(" + cCampo + " between '" + mv_par05 + "' and '" + mv_par06 + "') or "
			 cAddField += ", " + cCampo
		 EndIf
		 cVendedor := Soma1(cVendedor,1)
	Next nCampo
	*   
   _cQuery :=" SELECT F2_VEND1,SUM(TOTAL) TOTAL,D2_PEDIDO "
   _cQuery +=" FROM ( "
   _cQuery +=" SELECT SUM(D2_TOTAL) TOTAL,F2_VEND1,D2_PEDIDO "
   _cQuery +=" FROM "+ RetSqlName("SD2")+" SD2, "+ RetSqlName("SF4")+" SF4, "+ RetSqlName("SF2")+" SF2 "
   _cQuery +=" WHERE SD2.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' '  "
   _cQuery +=" AND MONTH(D2_EMISSAO)='"+MV_PAR01+"'"
   _cQuery +=" AND YEAR(D2_EMISSAO)='"+MV_PAR02+"'"
   _cQuery +=" AND D2_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
   _cQuery +=" AND D2_TIPO NOT IN ('D', 'B') "
   _cQuery +=" AND D2_FILIAL = F2_FILIAL "
   _cQuery +=" AND D2_FILIAL = F4_FILIAL "
   _cQuery +=" AND (" + Left(cFilterQry,Len(cFilterQry)-4) + ")"
   _cQuery +=" AND D2_DOC = F2_DOC "
   _cQuery +=" AND D2_SERIE = F2_SERIE "
   _cQuery +=" AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
   _cQuery +=" AND NOT (SD2.D2_TIPODOC >= '50' ) "
   _cQuery +=" AND F4_CODIGO = D2_TES "
   _cQuery +=" GROUP BY F2_VEND1,D2_PEDIDO "
   if mv_par08 == 1
      _cQuery +=" UNION
      _cQuery +=" SELECT -SUM(D1_TOTAL-D1_VALDESC) TOTAL,F2_VEND1,D1_PEDIDO D2_PEDIDO"
      _cQuery +=" FROM "+ RetSqlName("SD1")+" SD1, "+ RetSqlName("SF4")+" SF4, "+ RetSqlName("SF2")+" SF2, "+ RetSqlName("SF1")+" SF1 "
      _cQuery +=" WHERE  D1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
      _cQuery +=" AND MONTH(D1_DTDIGIT)='"+MV_PAR01+"'"
		_cQuery +=" AND YEAR(D1_DTDIGIT)='"+MV_PAR02+"'"
      _cQuery +=" AND D1_TIPO = 'D' AND NOT (SD1.D1_TIPODOC >= '50' ) "
      _cQuery +=" AND F4_CODIGO = D1_TES "
      _cQuery +=" AND F2_FILIAL = D1_FILIAL "
      _cQuery +=" AND F4_FILIAL = D1_FILIAL "
      _cQuery +=" AND D1_FILIAL = F1_FILIAL "
      _cQuery +=" AND F2_DOC = D1_NFORI "
      _cQuery +=" AND F2_SERIE = D1_SERIORI "
      _cQuery +=" AND F2_LOJA = D1_LOJA AND F1_FILIAL = '01' AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "
      _cQuery +=" AND SD1.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_ = ' ' AND SF1.D_E_L_E_T_ = ' ' "
      _cQuery +=" AND (" + Left(cFilterQry,Len(cFilterQry)-4) + ")"
      _cQuery +=" GROUP BY F2_VEND1,D1_PEDIDO "
   endif
   _cQuery +=" ) A "
   _cQuery +=" GROUP BY F2_VEND1,D2_PEDIDO "
   _cQuery +=" ORDER BY F2_VEND1 "
   *

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TKK",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TKK->(DbGoTop())
   oReport:SetMeter(TKK->(RecCount()))
   *
   nTotal := 0
   While TKK->( ! Eof() )
      
         If oReport:Cancel()
	         Exit
         EndIf	
	      oReport:IncMeter()
	      
	      nPos := Ascan(aVendedor,{ |x| x[1] = TKK->F2_VEND1 })
	      
	      If nPos == 0
	         nPedido := iif(EMPTY(TKK->D2_PEDIDO),0,1)
		      Aadd(aVendedor,{TKK->F2_VEND1,TKK->TOTAL,nPedido})
	      Else
		      aVendedor[nPos,2] += TKK->TOTAL
		      aVendedor[nPos,3] += iif(EMPTY(TKK->D2_PEDIDO),0,1)
	      Endif
         
         nTotal += TKK->TOTAL
		   TKK->(dbSkip())
   Enddo  
   TKK->(dbCloseArea())
   
   if mv_par07 == 1
      ASort(aVendedor,,,{ |x, y| x[1] < y[1] })//ordenar por Vendedor
   else 
      ASort(aVendedor,,,{ |x, y| x[2] > y[2] })//ordenar por Ranking   
   endif
   
   if Len(aVendedor) > 0
      nTotPed := 0
      For ix:=1 to Len(aVendedor)
      	 nMeta:= FCarregaMeta(aVendedor[ix,1],mv_par01,mv_par02)	
      	 nPerc := (aVendedor[ix,2]*100/nMeta)    
	       oReport:IncMeter()
	       oSection1:Cell("C_LUGAR"):SetValue(TRANSFORM(ix,"@E 999"))
	       oSection1:Cell("C_COD" ):SetValue(aVendedor[ix,1])
	       oSection1:Cell("C_NOME"):SetValue(Posicione("SA3",1,XFILIAL("SA3")+aVendedor[ix,1],"A3_NREDUZ"))
	       oSection1:Cell("C_TOTAL"):SetValue(aVendedor[ix,2])
//  	       oSection1:Cell("C_PERC"):SetValue(TRANSFORM((aVendedor[ix,2]*100)/nTotal,"@E 999,999,999,999.999"))
  	       oSection1:Cell("C_PERC"):SetValue(TRANSFORM(nPerc,"@E 999,999,999,999.999"))
 	       oSection1:Cell("C_QTDPED"):SetValue(TRANSFORM(aVendedor[ix,3],"@E 99999"))
  	       oSection1:Cell("C_MDPED"):SetValue(Round(aVendedor[ix,2]/aVendedor[ix,3],2))  	       
  	       oSection1:Cell("C_TOTCOI"):SetValue(VLRCOMISSAO(mv_par09,nPerc,'I'))
  	       oSection1:Cell("C_TOTCOG"):SetValue(VLRCOMISSAO(mv_par09,nTotal,'G'))
  	       oSection1:Cell("C_TOTCOM"):SetValue(VLRCOMISSAO(mv_par09,nPerc,'I')+VLRCOMISSAO(mv_par09,nTotal,'G'))  	       

	       oReport:SkipLine()
	       oSection1:PrintLine() 
          nTotPed   += aVendedor[ix,3]
       
      Next
   endif
   oReport:IncMeter()
   oSection1:Cell("C_LUGAR"):SetValue("")
   oSection1:Cell("C_COD" ):SetValue("")
   oSection1:Cell("C_NOME"):SetValue("Base de Cálculo dos Percentuais")
   oSection1:Cell("C_TOTAL"):SetValue(nTotal)
   oSection1:Cell("C_PERC"):SetValue("")
   oSection1:Cell("C_QTDPED"):SetValue(nTotPed)
   oSection1:Cell("C_MDPED"):SetValue("")
   oSection1:Cell("C_TOTCOI"):SetValue("")  	          
   oSection1:Cell("C_TOTCOG"):SetValue("")  	          
   oSection1:Cell("C_TOTCOM"):SetValue("")  	          
   oReport:SkipLine()
   oSection1:PrintLine() 
   oSection1:Finish()      

Return


//=================================================================================
// Totalizador dos pesos bruto e liquido e volumeo
//=================================================================================
Static Function VLRCOMISSAO(cTabela,nValor,Tipo)
    Local  _cQuery := ''
    Local nComis   := 0
    
   _cQuery :=" SELECT PC1_COMIS "
   _cQuery +=" FROM "+ RetSqlName("PC0")+" PC0,"+ RetSqlName("PC1")+" PC1 "
   _cQuery +=" WHERE PC0.D_E_L_E_T_ = '' AND PC1.D_E_L_E_T_ = ''"
   _cQuery +=" AND PC0_FILIAL = PC1_FILIAL AND PC0_CODTAB = PC1_CODTAB AND PC0_ATIVO = '1' "
   _cQuery +=" AND PC1_CODTAB = '"+cTabela+"'"
   _cQuery +=" AND PC1_TIPO = '"+Tipo+"'"           
   _cQuery +=" AND PC1_INI <= "+ALLTRIM(Transform(nValor, "@R 999999999999.99"))
   _cQuery +=" AND PC1_FIM >= "+ALLTRIM(Transform(nValor, "@R 999999999999.99"))
   

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TMA",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf


   if TMA->( ! Eof() )
      nComis := TMA->PC1_COMIS
   Endif
   TMA->(dbCloseArea())
   
Return nComis

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Mês 				    ",29)+"?"             ,"","", "mv_ch1" , "C", 2 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ano	          		 ",29)+"?"             ,"","", "mv_ch2" , "C", 4 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Da Filial           ",29)+"?"             ,"","", "mv_ch3" , "C", 2 , 0, 0, "G", "","SM0", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate a Filial        ",29)+"?"             ,"","", "mv_ch4" , "C", 2 , 0, 0, "G", "","SM0", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Do Vendedor         ",29)+"?"             ,"","", "mv_ch5" , "C", 6 , 0, 0, "G", "","SA3", "", "", "mv_par05")
	u_HMPutSX1(cPerg, "06", PADR("Ate o Vendedor      ",29)+"?"             ,"","", "mv_ch6" , "C", 6 , 0, 0, "G", "","SA3", "", "", "mv_par06")
	u_HMPutSX1(cPerg, "07", PADR("Ordem               ",29)+"?"             ,"","", "mv_ch7" , "N", 1 , 0, 1, "C", "",   "", "", "", "mv_par07","Vendedor","","","","Ranking")
	u_HMPutSX1(cPerg, "08", PADR("Inclui Devolução    ",29)+"?"             ,"","", "mv_ch8" , "N", 1 , 0, 1, "C", "",   "", "", "", "mv_par08","Sim","","","","Nao")   
	u_HMPutSX1(cPerg, "09", PADR("Tabela de Comissão  ",29)+"?"             ,"","", "mv_ch9" , "C", 3 , 0, 0, "G", "","PC0", "", "", "mv_par09")   	
   
Return Nil


Static Function FCarregaMeta(cVendedor,cMes,cAno)
Local cQry := ""
Local nComis := 0

cQry += " SELECT * FROM "+RetSQLName("SCT")+" "
cQry += " WHERE D_E_L_E_T_=''					"
cQry += " AND CT_VEND='"+cVendedor+"'						"
cQry += " AND SUBSTRING(CT_XDTVIG,1,2)='"+cMes+"' "
cQry += " AND SUBSTRING(CT_XDTVIG,3,4)='"+cAno+"' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TKK",.T.,.F.)

if TKK->( ! Eof() )
	nComis := TKK->CT_VALOR
Endif

TKK->(dbCloseArea())
   
Return nComis
