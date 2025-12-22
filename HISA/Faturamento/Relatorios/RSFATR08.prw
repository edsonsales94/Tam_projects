#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦RSFATR08    ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 27/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatorio de Romaneio                                         ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


User Function RSFATR08()

Private oReport, oSection1
Private nTotQtd   := 0
Private nTotCust  := 0
Private ntotCusto := 0
Private _nPag     := 01

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
Local cPerg   := "RSFATR08"
Local cTitulo := 'Romaneio'

CriaSx1(cPerg)

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR08", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Romaneio")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Romaneio.",{""})
oSection1:SetTotalInLine(.F.)                                    
TRCell():New(oSection1, "C_FILIAL"   , "", "FILIAL"            ,,10)
TRCell():New(oSection1, "C_NF"       , "", "NOTA FISCAL"       ,,25)
TRCell():New(oSection1, "C_DTNF"     , "", "DATA DE EMISSÃO NF",,25)
TRCell():New(oSection1, "C_CLIENTE"	 , "", "CLIENTE"           ,,60)
TRCell():new(oSection1, "C_EST"      , "", "ESTADO/MUNICIPIO"  ,,30)
TRCell():new(oSection1, "C_PEDCLI"   , "", "PEDIDO CLIENTE"    ,,25)
TRCell():New(oSection1, "C_PEDHISA"	 , "", "PEDIDO HISAMITSU"  ,,25)
TRCell():New(oSection1, "C_TRANSP"	 , "", "TRANSPORTADORA"    ,,50)
TRCell():new(oSection1, "C_DTENT"    , "", "DATA DE ENTREGA"   ,,15)
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
   Local nTotNF   := 0 
   Local nTotgQtd := 0

   oSection1 := oReport:Section(1)

   oSection1:Init()
   oSection1:SetHeaderSection(.T.)
   cQuery := " SELECT DISTINCT F2_FILIAL,C5_NUM, C5_PEDCLI,F2_CLIENTE,F2_LOJA, A1_NOME, A1_MUN, A1_EST, F2_DOC,CONVERT(VARCHAR(10),(CONVERT(DATE,F2_EMISSAO)),103)AS RDTEMISSAO ,F2_SERIE,F2_TRANSP,A4_NOME,CONVERT(VARCHAR(10),(CONVERT(DATE,C6_ENTREG)),103)AS RDATA "
   cQuery += " FROM "+RetSQLName("SC5")+" SC5 (NOLOCK) , "+RetSQLName("SC6")+" SC6 (NOLOCK) , "+RetSQLName("SA1")+" SA1 (NOLOCK) , "+RetSQLName("SA4")+" SA4 (NOLOCK) , "+RetSQLName("SF2")+" SF2 (NOLOCK) ,"+RetSQLName("SD2")+" SD2 (NOLOCK) 
   cQuery += " WHERE SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SA4.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' "
   cQuery += " AND C5_FILIAL = C6_FILIAL "
   cQuery += " AND C5_NUM = C6_NUM "
   cQuery += " AND A1_FILIAL = '' AND A4_FILIAL = '' "
   cQuery += " AND F2_FILIAL = C5_FILIAL "
   cQuery += " AND F2_TRANSP = A4_COD "     
   cQuery += " AND F2_FILIAL = D2_FILIAL "
   cQuery += " AND F2_DOC = D2_DOC "
   cQuery += " AND F2_SERIE = D2_SERIE "
   cQuery += " AND F2_CLIENTE = A1_COD "
   cQuery += " AND F2_LOJA = A1_LOJA "
   cQuery += " AND D2_PEDIDO = C5_NUM " 
   cQuery += " AND F2_TRANSP BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"   
   cQuery += " AND C5_FECENT BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
   cQuery += " ORDER BY F2_TRANSP,F2_FILIAL,F2_DOC, F2_SERIE "
   
   

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TRP",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TRP->(DbGoTop())
   oReport:SetMeter(TRP->(RecCount()))
   While TRP->( ! Eof() )  
      If oReport:Cancel()
	      Exit
      EndIf	
	   cTransp := TRP->F2_TRANSP
	   /*
	   oReport:IncMeter()
	   oSection1:Cell("C_FILIAL" ):SetValue("")
	   oSection1:Cell("C_NF" ):SetValue("TRANSPORTADORA : ")
	   oSection1:Cell("C_CLIENTE"):SetValue(TRP->F2_TRANSP+" - "+TRP->A4_NOME)
	   oSection1:Cell("C_EST"):SetValue("")
	   oSection1:Cell("C_PEDCLI"):SetValue("")
	   oSection1:Cell("C_PEDHISA"):SetValue("")
	   oSection1:Cell("C_DTENT"):SetValue("") 
	   oReport:SkipLine()
	   oSection1:PrintLine() 
	   */
      While TRP->( ! Eof() ) .and. cTransp = TRP->F2_TRANSP
	      If oReport:Cancel()
		      Exit
 	      EndIf	
         oReport:IncMeter()
     	   oSection1:Cell("C_FILIAL" ):SetValue(TRP->F2_FILIAL)
         oSection1:Cell("C_NF"):SetValue(TRP->F2_DOC+"-"+TRP->F2_SERIE) 
         oSection1:Cell("C_DTNF"):SetValue(TRP->RDTEMISSAO)
         oSection1:Cell("C_CLIENTE"):SetValue(TRP->F2_CLIENTE+"-"+TRP->F2_LOJA+" "+TRP->A1_NOME)             
         oSection1:Cell("C_EST"):SetValue(ALLTRIM(TRP->A1_MUN)+"/"+TRP->A1_EST)
         oSection1:Cell("C_PEDCLI"):SetValue(TRP->C5_PEDCLI)
         oSection1:Cell("C_PEDHISA"):SetValue(TRP->C5_NUM)             
         oSection1:Cell("C_TRANSP"):SetValue(TRP->F2_TRANSP+" - "+TRP->A4_NOME)             
         oSection1:Cell("C_DTENT"):SetValue(TRP->RDATA)
     	   oReport:SkipLine()
         oSection1:PrintLine()     
         nTotNF++
         nTotgQtd++
	      TRP->(dbSkip())
      enddo
      oReport:IncMeter()
  	   oSection1:Cell("C_FILIAL" ):SetValue("")
	   oSection1:Cell("C_NF" ):SetValue("TOTAL NF TRANSPORTADORA : ")
	   oSection1:Cell("C_DTNF"):SetValue("")
	   oSection1:Cell("C_CLIENTE"):SetValue("")
	   oSection1:Cell("C_EST"):SetValue("")
	   oSection1:Cell("C_PEDCLI"):SetValue(nTotNF)
	   oSection1:Cell("C_PEDHISA"):SetValue("")
	   oSection1:Cell("C_TRANSP"):SetValue("")
	   oSection1:Cell("C_DTENT"):SetValue("") 
      oReport:SkipLine()
      oSection1:PrintLine()     
      nTotNF   := 0 
      *
      oReport:IncMeter()
  	   oSection1:Cell("C_FILIAL" ):SetValue("")
	   oSection1:Cell("C_NF" ):SetValue("")
 	   oSection1:Cell("C_DTNF"):SetValue("")
	   oSection1:Cell("C_CLIENTE"):SetValue("")
	   oSection1:Cell("C_EST"):SetValue("")
	   oSection1:Cell("C_PEDCLI"):SetValue("")
	   oSection1:Cell("C_PEDHISA"):SetValue("")
  	   oSection1:Cell("C_TRANSP"):SetValue("")
	   oSection1:Cell("C_DTENT"):SetValue("") 
      oReport:SkipLine()
      oSection1:PrintLine()
      *
   Enddo
   oReport:IncMeter()
   oSection1:Cell("C_FILIAL" ):SetValue("")
   oSection1:Cell("C_NF" ):SetValue("TOTAL GERAL DE NOTAS:")
   oSection1:Cell("C_DTNF"):SetValue("")
   oSection1:Cell("C_CLIENTE"):SetValue("")
   oSection1:Cell("C_EST"):SetValue("")
   oSection1:Cell("C_PEDCLI"):SetValue(nTotgQtd)
   oSection1:Cell("C_PEDHISA"):SetValue("")
   oSection1:Cell("C_TRANSP"):SetValue("")
   oSection1:Cell("C_DTENT"):SetValue("") 
   oReport:SkipLine()
   oSection1:PrintLine()

   TRP->(dbCloseArea())
   oSection1:Finish()      

Return

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Da Transportador ",29)+"?"     ,"","", "mv_ch1" , "C", 6 , 0, 0, "G", "","SA4", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Transportadora",29)+"?"    ,"","", "mv_ch2" , "C", 6 , 0, 0, "G", "","SA4", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Da Data Entrega",29)+"?"       ,"","", "mv_ch3" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate Data Entrega",29)+"?"      ,"","", "mv_ch4" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par04")	

Return Nil
