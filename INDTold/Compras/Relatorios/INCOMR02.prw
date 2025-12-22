#INCLUDE "rwmake.ch"
#include "Protheus.ch"
#include 'MSGRAPHI.CH'

/*/
#############################################################################
±±ºPrograma  ³INCOMR02  º Autor ³ ENER FREDES        º Data ³  09/04/09   º±±
#############################################################################
±±ºDescricao ³ Relatorio Order Follow Up                                  º±±
#############################################################################
/*/

User Function INCOMR02

  Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2       := "de acordo com os parametros informados pelo usuario."
  Local cDesc3       := "Order Follow Up - PM&T"
  Local cPict        := ""
  Local titulo       := "Order Follow Up"
  Local nLin         := 80
  Local Cabec1       := ""
  Local Cabec2       := ""
  Local imprime      := .T.
  Local aOrd := {}
  Private lEnd        := .F.
  Private lAbortPrint := .F.
  Private CbTxt       := ""
  Private limite      := 220
  Private tamanho     := "G"
  Private nomeprog    := "INCOMR03" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo       := 18
  Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey   := 0
  Private cbtxt      := Space(10)
  Private cbcont     := 00
  Private CONTFL     := 01
  Private m_pag      := 01
  Private wnrel      := "INCOMR03" // Coloque aqui o nome do arquivo usado para impressao em disco
  Private cPerg      := "COMR03"
  Private cString    := "SC7"
  Private nOrdem 
  Private aTotal     := {{0,0},{0,0}} 

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

  If MV_PAR10 == 1
	Cabec1  := "| ST | SC # |   RC #   | PO # | Description              | TTL Amount      | Supplier             | Estimate   | Project Name         | Status     | Delivery   | Delivery   | Buyer              |"
	Cabec2  := "|    |      |          |      |                          |                 |                      | Delivery   |                      |            | Date       |            |                    |"
    limite  := 220
    tamanho := "G"

  Else
    Cabec1  := "| ST | PO #   | Description              | TTL Amount      | Estimate   | Project Name         | Status     | Delivery   |"
    Cabec2  := "|    |        |                          |                 | Delivery   |                      |            |            |"
    limite  := 132
    tamanho := "M"
  EndIf  

  Processa({|| ExecProc() }, "Filtrando dados")
  If MV_PAR05 == 1
    RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
  ElseIf MV_PAR05 == 2
    Processa({|| RunExcel() },"Gerando em Excel...")
  EndIf  
Return


Static Function ExecProc()
  Local cQuery := ""
  cQuery += " SELECT C7_FILIAL,C7_NUMSC,C7_NROREQ,C7_NUM,C7_DESCRI,C7_TOTAL,A2_NOME,C7_DATPRF,C7_DESCCC,C7_NOME,(C7_QUANT-C7_QUJE) PENDENTE ,ZD_DATAEC,Y1_NOME
  cQuery += " FROM SC7010 SC7 
  cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON C7_FILIAL = A2_FILIAL AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ <> '*'
  cQuery += " LEFT OUTER JOIN "+RetSqlName("SZD")+" SZD ON C7_FILIAL = ZD_FILIAL AND C7_NUM = ZD_PEDIDO AND SZD.D_E_L_E_T_ <> '*' AND ZD_ITEM = '001'
  cQuery += " LEFT OUTER JOIN "+RetSqlName("SY1")+" SY1 ON ZD_COMP = Y1_COD AND SY1.D_E_L_E_T_ <> '*'
  cQuery += " WHERE SC7.D_E_L_E_T_ <> '*'
  cQuery += " AND C7_FILIAL >= '"+MV_PAR01+"' AND C7_FILIAL <= '"+MV_PAR02+"'
  cQuery += " AND C7_EMISSAO >= '"+Dtos(MV_PAR03)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR04)+"'
  cQuery += " AND C7_CC >= '"+MV_PAR06+"' AND C7_CC <= '"+MV_PAR07+"'
  cQuery += " AND LEFT(C7_CC,2) >= '"+MV_PAR08+"' AND LEFT(C7_CC,2) <= '"+MV_PAR09+"'
  cQuery += " AND C7_CONTRA = ''
  cQuery += " AND C7_RESIDUO = ''
  cQuery += " ORDER BY C7_FILIAL,C7_DESCCC,C7_NUM,C7_ITEM

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP",.T.,.T.)
  TcSetField("TMP","ZD_DATAEC","D")  
  TcSetField("TMP","C7_DATPRF","D")  
  

  cQuery := " SELECT C7_FILIAL,C7_NUM,ZD_DATAEC,SUM(C7_TOTAL) TOTAL
  cQuery += " FROM SC7010 SC7 
  cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON C7_FILIAL = A2_FILIAL AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ <> '*'
  cQuery += " LEFT OUTER JOIN "+RetSqlName("SZD")+" SZD ON C7_FILIAL = ZD_FILIAL AND C7_NUM = ZD_PEDIDO AND SZD.D_E_L_E_T_ <> '*' AND ZD_ITEM = '001'
  cQuery += " LEFT OUTER JOIN "+RetSqlName("SY1")+" SY1 ON ZD_COMP = Y1_COD AND SY1.D_E_L_E_T_ <> '*'
  cQuery += " WHERE SC7.D_E_L_E_T_ <> '*'
  cQuery += " AND C7_FILIAL >= '"+MV_PAR01+"' AND C7_FILIAL <= '"+MV_PAR02+"'
  cQuery += " AND C7_EMISSAO >= '"+Dtos(MV_PAR03)+"' AND C7_EMISSAO <= '"+Dtos(MV_PAR04)+"'
  cQuery += " AND C7_CC >= '"+MV_PAR06+"' AND C7_CC <= '"+MV_PAR07+"'
  cQuery += " AND LEFT(C7_CC,2) >= '"+MV_PAR08+"' AND LEFT(C7_CC,2) <= '"+MV_PAR09+"'
  cQuery += " AND C7_CONTRA = ''
  cQuery += " AND C7_RESIDUO = ''
  cQuery += " GROUP BY C7_FILIAL,C7_NUM,ZD_DATAEC
  cQuery += " ORDER BY C7_FILIAL,C7_NUM,ZD_DATAEC

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"RES",.T.,.T.)
  TcSetField("TMP","ZD_DATAEC","D")  
                                                         
  RES->(DbGotop())                                                            
  While !RES->(Eof())
    If Empty(RES->ZD_DATAEC)
      aTotal[1][1]+= 1
      aTotal[2][1]+= RES->TOTAL
    Else
      aTotal[1][2]+= 1
      aTotal[2][2]+= RES->TOTAL
    EndIf
    RES->(DbSkip())
  End      
  DbSelectArea("RES")
  DbCloseArea("RES")

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
  Local aTotal     := {{0,0},{0,0}} 
  Local nPos                  
  Local nCol1,nCol2,nCol3,nCol4,nCol5,nCol6,nCol7,nCol8,nCol9,nCol10,nCol11
  Local cFil,cStream
  Local cStatus           
  Local cDelivery   

  If MV_PAR10 == 1
    nCol1  := 0   //Site               - 05
	nCol2  := 5   //SC#                - 07
	nCol3  := 12  //RC#                - 11
	nCol4  := 23  //PO#                - 07
	nCol5  := 30  //Requirer           - 22
	nCol6  := 52  //Description        - 27
	nCol7  := 79  //TTL Amount         - 18
	nCol8  := 97  //Supplier           - 23
	nCol9  := 120 //Estimate Delivery  - 13
	nCol10 := 133 //Project Name       - 23
	nCol11 := 156 //Status             - 13
	nCol12 := 169 //Delivery Date      - 13
	nCol13 := 182 //Delivery           - 13
	nCol14 := 195 //Buyer              - 23
  Else
    nCol1  := 0   //Site               - 05
    nCol2  := 5   //PO#                - 09
    nCol3  := 14  //Description        - 27
    nCol4  := 41  //TTL Amount         - 18
    nCol5  := 59  //Estimate Delivery  - 13
    nCol6  := 72  //Project Name       - 23
    nCol7  := 95  //Status             - 13
    nCol8  := 108 //Delivery           - 13
  EndIf

  DbSelectArea("TMP")
  DbGotop()
  While !TMP->(Eof())
    If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
    Endif
    If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
    Endif            
    If !Empty(TMP->ZD_DATAEC)
      cStatus := Padc("CLOSED",12)
    Else
      cStatus := Padc("ON GOING",12)
    EndIf
     
    If !Empty(TMP->ZD_DATAEC)
      If TMP->ZD_DATAEC <= TMP->C7_DATPRF
        cDelivery := Padc("ON TIME",12)
      Else
        cDelivery := Padc("DELAYED",12)
      EndIf
    Else
      If !Empty(TMP->C7_DATPRF)
        If Date() <= TMP->C7_DATPRF
          cDelivery := Padc("ON TIME",12)
        Else
          cDelivery := Padc("DELAYED",12)
        EndIf
      Else
        cDelivery := Padc("ON TIME",12)
      EndIf  
    EndIf

    If MV_PAR10 == 1
      @nLin,nCol1  PSAY "| "+TMP->C7_FILIAL                               //Site
      @nLin,nCol2  PSAY "|"+TMP->C7_NUMSC                                 //SC#
      @nLin,nCol3  PSAY "|"+TMP->C7_NROREQ                                //RC#
      @nLin,nCol4  PSAY "|"+TMP->C7_NUM                                   //PO#
      @nLin,nCol6  PSAY "| "+Left(TMP->C7_DESCRI,25)                      //Description
      @nLin,nCol7  PSAY "| "+Transform(TMP->C7_TOTAL,"@E 999,999,999.99") //TTL Amount
      @nLin,nCol8  PSAY "| "+Left(TMP->A2_NOME,20)                        //Supplier
      @nLin,nCol9  PSAY "| "+Dtoc(TMP->C7_DATPRF)                         //Estimate Delivery
      @nLin,nCol10 PSAY "| "+Left(TMP->C7_DESCCC,20)                      //Project Name
      @nLin,nCol11 PSAY "|"+cStatus                                       //Status
      @nLin,nCol12 PSAY "| "+Dtoc(TMP->ZD_DATAEC)                         //Delivery Date
      @nLin,nCol13 PSAY "|"+cDelivery                                     //Delivery 
      @nLin,nCol14 PSAY "| "+Left(TMP->Y1_NOME,19)+"|"                    //Buyer
    Else
	  @nLin,nCol1  PSAY "| "+TMP->C7_FILIAL                               //Site
      @nLin,nCol2  PSAY "|"+TMP->C7_NUM                                   //PO#
      @nLin,nCol3  PSAY "| "+Left(TMP->C7_DESCRI,25)                      //Description
      @nLin,nCol4  PSAY "| "+Transform(TMP->C7_TOTAL,"@E 999,999,999.99") //TTL Amount
      @nLin,nCol5  PSAY "| "+Dtoc(TMP->C7_DATPRF)                         //Estimate Delivery
      @nLin,nCol6  PSAY "| "+Left(TMP->C7_DESCCC,20)                      //Project Name
      @nLin,nCol7  PSAY "|"+cStatus                                       //Status
      @nLin,nCol8  PSAY "|"+cDelivery+"|"                                 //Delivery 
    EndIf  
    nLin++
    TMP->(DbSkip())
  End
  @nLin,00 PSAY Replicate("-",220)
  nLin+= 2

  @nLin,nCol1  PSAY " TTL Pending PO's --> "+Transform(aTotal[1][1],"@E 99,999,999") //TTL Amount
  nLin++
  @nLin,nCol1  PSAY " TTL Closed PO's ---> "+Transform(nTotEnc[1][2],"@E 99,999,999") //TTL Amount

  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif
  MS_FLUSH()
  DbSelectArea("TMP")
  DbCloseArea("TMP")
Return
    

Static Function RunExcel()
  Local oExcelApp                           
  Local nPos                  
  Local cFil,cStream
  Local cArqTxt   := "\\10.60.100.190\Protheus10\Protheus_data\Excel\incomr03_base.xls"
  Local cXLS_Macro:= "\\10.60.100.190\Protheus10\Protheus_data\Excel\INCOMR03.xls"
  Local nHdl       := fCreate(cArqTxt)
  Local cLinha     := ""
  Local cMensagem  := ""
  Local cDtprf     := ""
  Local cDtec      := ""


  If MV_PAR10 == 1
    cLinha := "Site"+Chr(9)
    cLinha += "SC#"+Chr(9)
    cLinha += "PO#"+Chr(9)
    cLinha += "Requirer"+Chr(9) 
    cLinha += "Description"+Chr(9)
    cLinha += "TTL Amount"+Chr(9)
    cLinha += "Supplier"+Chr(9)
    cLinha += "Estimate Delivery"+Chr(9)
    cLinha += "Project Name"+Chr(9)
    cLinha += "Status"+Chr(9)
    cLinha += "Delivery date"+Chr(9)
    cLinha += "Delivery"+Chr(9)
    cLinha += "Buyer"+Chr(9)
    cLinha += "Follow UP Comments"+Chr(9)
    cLinha += chr(13)+chr(10)
  Else
    cLinha := "Site"+Chr(9)
    cLinha += "PO#"+Chr(9)
    cLinha += "Description"+Chr(9)
    cLinha += "TTL Amount"+Chr(9)
    cLinha += "Estimate Delivery"+Chr(9)
    cLinha += "Project Name"+Chr(9)
    cLinha += "Status"+Chr(9)
    cLinha += "Delivery"+Chr(9)
    cLinha += chr(13)+chr(10)
  EndIf  
  fWrite(nHdl,cLinha,Len(cLinha))

  DbSelectArea("TMP")
  DbGotop()
  SZD->(DbSetOrder(1))
  While !TMP->(Eof())   
    cMensagem  := ""
    If SZD->(DbSeek(TMP->C7_FILIAL+TMP->C7_NUM))
      cMensagem := Alltrim(SZD->ZD_DESC)
	  cMensagem := STRTRAN(cMensagem,Chr(9)," ")
	  cMensagem := STRTRAN(cMensagem,chr(13)+chr(10)," ")
    EndIf  
    If !Empty(TMP->ZD_DATAEC)
      cStatus := "CLOSED"
    Else
      cStatus := "ON GOING"
    EndIf

    If !Empty(TMP->ZD_DATAEC)
      If TMP->ZD_DATAEC <= TMP->C7_DATPRF
        cDelivery := Padc("ON TIME",12)
      Else
        cDelivery := Padc("DELAYED",12)
      EndIf
    Else
      If !Empty(TMP->C7_DATPRF)
        If Date() <= TMP->C7_DATPRF
          cDelivery := Padc("ON TIME",12)
        Else
          cDelivery := Padc("DELAYED",12)
        EndIf
      Else
        cDelivery := Padc("ON TIME",12)
      EndIf  
    EndIf

    cDtprf := Dtos(TMP->C7_DATPRF)
    cDtprf := SubStr(cDtprf,1,4)+"/"+SubStr(cDtprf,5,2)+"/"+SubStr(cDtprf,7,2)
    cDtec  := Dtos(TMP->ZD_DATAEC)
    cDtec  := SubStr(cDtec,1,4)+"/"+SubStr(cDtec,5,2)+"/"+SubStr(cDtec,7,2)

    If MV_PAR10 == 1
      cLinha := TMP->C7_FILIAL+Chr(9)								//Site
      cLinha += TMP->C7_NUMSC+Chr(9)								//SC#
      cLinha += TMP->C7_NROREQ+Chr(9)								//RC#
      cLinha += TMP->C7_NUM+Chr(9)									//PO#
      cLinha += TMP->C7_DESCRI+Chr(9)								//Description
      cLinha += Alltrim(Str(TMP->C7_TOTAL))+Chr(9)	//TTL Amount
      cLinha += TMP->A2_NOME+Chr(9)									//Supplier
      cLinha += cDtprf+Chr(9)										//Estimate Delivery
      cLinha += TMP->C7_DESCCC+Chr(9)								//Project Name
      cLinha += cStatus+Chr(9)										//Status
      cLinha += cDtec+Chr(9)										//Delivery Date
      cLinha += cDelivery+Chr(9)									//Delivery 
      cLinha += TMP->Y1_NOME+Chr(9)									//Buyer
      cLinha += cMensagem+Chr(9)									//Comment
      cLinha += chr(13)+chr(10)
    Else
      cLinha := TMP->C7_FILIAL+Chr(9)								//Site
      cLinha += TMP->C7_NUM+Chr(9)									//PO#
      cLinha += TMP->C7_DESCRI+Chr(9)								//Description
      cLinha += Alltrim(Str(TMP->C7_TOTAL))+Chr(9)	//TTL Amount
      cLinha += cDtprf+Chr(9)										//Estimate Delivery
      cLinha += TMP->C7_DESCCC+Chr(9)								//Project Name
      cLinha += cStatus+Chr(9)										//Status
      cLinha += cDelivery+Chr(9)									//Delivery 
      cLinha += chr(13)+chr(10)
    EndIf  

    fWrite(nHdl,cLinha,Len(cLinha))

    TMP->(DbSkip())
  End

  cLinha := chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha))

  If MV_PAR10 == 1
    cLinha := Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += " TTL PO's"+Chr(9)							
    cLinha += " Qty "+Chr(9)							
    cLinha += " AMOUNT "+Chr(9)							
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha))

    cLinha := Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += " TTL Pending PO's"+Chr(9)							
    cLinha += Alltrim(Str(aTotal[1][1]))+Chr(9)			
    cLinha += Alltrim(Str(aTotal[2][1]))+Chr(9)			
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha))

    cLinha := Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += Chr(9)							
    cLinha += " TTL Closed PO's"+Chr(9)							
    cLinha += Alltrim(Str(aTotal[1][2]))+Chr(9)			
    cLinha += Alltrim(Str(aTotal[2][2]))+Chr(9)			
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha))
  Else  
    cLinha := Chr(9)							
    cLinha += Chr(9)							
    cLinha += " TTL PO's"+Chr(9)							
    cLinha += " AMOUNT "+Chr(9)							
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha))

    cLinha := Chr(9)							
    cLinha += Chr(9)							
    cLinha += " TTL Pending PO's"+Chr(9)							
    cLinha += Alltrim(Str(aTotal[2][1]))+Chr(9)			
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha))
    cLinha := Chr(9)							
    cLinha += Chr(9)							
    cLinha += " TTL Closed PO's"+Chr(9)							
    cLinha += Alltrim(Str(aTotal[2][2]))+Chr(9)			
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha))
  EndIf  

  fClose(nHdl)     

  If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
    MsgStop( 'MsExcel nao instalado' ) 
    //Close(oDlg)
    Return
  EndIf  
  oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	If MV_PAR10 = 1
	  oExcelApp:WorkBooks:Open(cArqTxt) 
  Else
	  oExcelApp:WorkBooks:Open(cXLS_Macro) 
  EndIf	  
  oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
  DbSelectArea("TMP")
  DbCloseArea("TMP")
  
Return             

Static Function ValidPerg(cPerg)
//               01   02                              03 04 05       06  07  08 09 10  11 12 13 14 14         16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
   u_INPutSX1(cPerg,"01","Da Filial                    ?","","","mv_ch1","C",02 ,0 ,0 ,"G","","","","","mv_par01","","","","","","","","","","","","","","","")
   u_INPutSX1(cPerg,"02","Ate Filial                   ?","","","mv_ch2","C",02 ,0 ,0 ,"G","","","","","mv_par02","","","","","","","","","","","","","","","")
   u_INPutSX1(cPerg,"03","Da Emissão                   ?","","","mv_ch3","D",08 ,0 ,0 ,"G","","","","","mv_par03","","","","","","","","","","","","","","","")
   u_INPutSX1(cPerg,"04","Ate Emissão                  ?","","","mv_ch4","D",08 ,0 ,0 ,"G","","","","","mv_par04","","","","","","","","","","","","","","","")
   u_INPutSx1(cPerg,"05","Tipo Impressão               ?","","","mv_ch5","N",01 ,0 ,0 ,"C","","","","","mv_par05","Normal","","","","Excel","","","")
   u_INPutSX1(cPerg,"06","Do Centro de Custo           ?","","","mv_ch6","C",09 ,0 ,0 ,"G","","","","","mv_par06","","","","","","","","","","","","","","","CTT")
   u_INPutSX1(cPerg,"07","Ate Centro de Custo          ?","","","mv_ch7","C",09 ,0 ,0 ,"G","","","","","mv_par07","","","","","","","","","","","","","","","CTT")
   u_INPutSX1(cPerg,"08","Do Stream                    ?","","","mv_ch8","C",02 ,0 ,0 ,"G","","","","","mv_par08","","","","","","","","","","","","","","","PB1")
   u_INPutSX1(cPerg,"09","Ate Stream                   ?","","","mv_ch9","C",02 ,0 ,0 ,"G","","","","","mv_par09","","","","","","","","","","","","","","","PB1")
   u_INPutSx1(cPerg,"10","Tipo Relatório               ?","","","mv_chA","N",01 ,0 ,0 ,"C","","","","","mv_par10","Analitico","","","","Sintético","","","")
Return
