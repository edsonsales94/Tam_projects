#Include "Rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINV03   ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 02/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Geração das etiquetas do inventário conforme parâmetros.      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  
User Function HLBINV03()

Private oObjDlg
Private cPerg   := "INV001"

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Geração da Etiquetas dO Inventário"
@ 02,005 TO 090,190
@ 10,010 Say "Este programa irá gerar o arquivo de controle de etiquetas para o     "
@ 18,010 Say "inventário conforme os parametros."
@ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
@ 65,128 BMPBUTTON TYPE 01 ACTION HLBINV03a()
@ 65,158 BMPBUTTON TYPE 02 ACTION Close(oObjDlg)
Activate Dialog oObjDlg Centered
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINV03a  ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 12/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ 0 - VERIFCA QUE SE NA DATA SELECIONADA TEM ALGUM INVENTÁRIO   ¦¦¦
¦¦¦ Descriçäo ¦ 1 - SELECIONA OS PRODUTOS CONFORME OS PARÂMENTROS             ¦¦¦
¦¦¦ Descriçäo ¦ 2 - GRAVA A TABELA DE ETIQUETAS                               ¦¦¦
¦¦¦ Descriçäo ¦ 3 - SETA O PARÂMETRO MV_DATAINV COM A DATA DO INVENTÁRIO      ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINV03a  ¦ Autor ¦ ADRIANO JORGE        ¦ Data ¦ 14/06/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Mudança da leitura do arquivo SB2 para o SBF, para contemplar ¦¦¦
¦¦¦ Descriçäo ¦ Controle de Endereçamento                                     ¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  
Static Function HLBINV03a()

Local cQry := ""

Close(oObjDlg)  

dbSelectArea("SZ3")

	If Alltrim(GetMv("MV_DATAINV"))==Dtos(MV_PAR08)
	   MsgBox("Já existe inventário nesta data!A rotina não pode continuar!","Atencao","ALERT")
	Else
	   
	   cQry :="SELECT B1_COD,B1_DESC,B1_TIPO,ISNULL(B2_LOCAL,'  ') AS B2_LOCAL, SUM(ISNULL(B2_QATU,0)) AS B2_QUANT " 
	   cQry +="  FROM SB1010 SB1  "
	   cQry +="  LEFT OUTER JOIN SB2010 SB2 ON B1_COD = B2_COD AND SB2.D_E_L_E_T_=''  "
	   cQry +=" WHERE SB1.D_E_L_E_T_='' AND B2_LOCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND B1_TIPO IN ('BN','EM','ME','MP','PA','PP','OI') AND B1_MSBLQL = 2 " //linha luciano
	   //cQry +=" WHERE SB1.D_E_L_E_T_='' AND B2_LOCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
 	   //cQry +=" AND BF_LOCALIZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " //AND BF_LOCAL <>'30'"
 	   
	   If MV_PAR07 == 1  
 	         cQry +=" AND B2_QATU > 0 "
 	   ElseIf MV_PAR07 == 2
 	   		cQry +=" AND B2_QATU < 0 "
 	   Else
 	    		cQry +=""
 	   EndIf
	   
  	   cQry +=" GROUP BY B1_COD,B1_DESC,B1_TIPO,ISNULL(B2_LOCAL,'  ') "
 	   cQry +=" ORDER BY B2_LOCAL,B1_TIPO,B1_COD "

 	   // CRIAÇÃO DO ARQUIVO TEMPORÁRIO
 	   MPSysOpenQuery( cQry, "TRB" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. ) 
 	   
		DbSelectArea("TRB")
	   dbGoTop()
		While TRB->(!EOF())
             Reclock("SZ3",.T.)
             	SZ3->Z3_FILIAL  := XFILIAL("SZ3")
					SZ3->Z3_DOCINV  := Substr(Alltrim(DTOS(MV_PAR08)),3,6)
					SZ3->Z3_ETIQUET := GetNroEtq()
					SZ3->Z3_PRODUTO := TRB->B1_COD
					SZ3->Z3_LOCAL   := TRB->B2_LOCAL
					SZ3->Z3_TIPO    := TRB->B1_TIPO
					SZ3->Z3_DATA    := MV_PAR08
					SZ3->Z3_SALDO   := TRB->B2_QUANT
					//SZ3->Z3_ENDEREC := TRB->BF_LOCALIZ
					
					/*If TRB->BF_LOCAL =='01' .And. Alltrim(TRB->BF_LOCALIZ) == "01_ALMOXPAD" 
					   SZ3->Z3_CC	 := "4020"
					ElseIf TRB->BF_LOCAL =='01' .And. Alltrim(TRB->BF_LOCALIZ) == "02_BENEFICIAMEN" 
					   SZ3->Z3_CC	 := " "
					ElseIf TRB->BF_LOCAL =='01' .And. Alltrim(TRB->BF_LOCALIZ) == "05_PRODUCAO" 
					   SZ3->Z3_CC	 := " "
					ElseIf TRB->BF_LOCAL =='01' .And. Alltrim(TRB->BF_LOCALIZ) == "90_CQANALISE" 
					   SZ3->Z3_CC	 := "5600"                                                    
					ElseIf TRB->BF_LOCAL =='01' .And. Alltrim(TRB->BF_LOCALIZ) == "98_DEVOLUCAO" 
					   SZ3->Z3_CC	 := "5600"
					ElseIf TRB->BF_LOCAL =='20'        
					   SZ3->Z3_CC	 := "3000"   //"5050"
					ElseIf TRB->BF_LOCAL =='99'
					   SZ3->Z3_CC	 := "4020" 
					ElseIf TRB->BF_LOCAL =='10'
						If Substr(SZ3->Z3_PRODUTO,1,2)=="03"
							SZ3->Z3_CC := "5700"
						EndIf 
					Else
						SZ3->Z3_CC := "" 
					EndIf */
				 SZ3->(MsUnLock())
         TRB->(dbSkip())
		EndDo	
		TRB->(dbCloseArea())
		PutMv ("MV_DATAINV",Dtos(MV_PAR08))
		MsgBox("FIM!!!","Atencao","ALERT")
	EndIf
Return
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetNroEtq  ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 15/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Gera o nro da etiqueta com o digito verifcador         .      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  
Static Function GetNroEtq()
Local cRet  :="000000"
Local cQry  :=""

cQry :="SELECT IsNull(MAX(Z3_ETIQUET),0)+1 AS Z3_ETIQUET FROM SZ3010  "
cQry +=" WHERE Z3_DOCINV = '"+ Substr(Alltrim(DTOS(MV_PAR08)),3,6) +"' AND D_E_L_E_T_='' "

MPSysOpenQuery( cQry, "TRT" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRT", .T., .F. )
DbSelectArea("TRT")
dbGoTop()
If !Eof()
	cRet := PADL(TRT->Z3_ETIQUET,6,"0")
EndIf    

TRT->(dbCloseArea())

Return(cRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 12/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Parâmetros da geração de Etiquetas do inventário       .      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  
Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01","Do Armazem  ",				      "","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
	PutSX1(cPerg,"02","Ate Armazem ",			 	      "","","mv_ch2","C",02,0,0,"G","","","","","Mv_Par02")
	PutSX1(cPerg,"03","Do Produto  ",			         "","","mv_ch3","C",14,0,0,"G","","SB1","","","mv_par03")
	PutSX1(cPerg,"04","Ate Produto ",				      "","","mv_ch4","C",14,0,0,"G","","SB1","","","Mv_Par04")
	PutSX1(cPerg,"05","Do Endereço  ",			         "","","mv_ch5","C",15,0,0,"G","","SBE","","","mv_par05")
	PutSX1(cPerg,"06","Ate o Endereço ",				   "","","mv_ch6","C",15,0,0,"G","","SBE","","","Mv_Par06")
	PutSx1(cPerg,"07","Gera etiqueta de produtos ?","","","mv_ch7","N",01,0,3,"C","","","","","mv_par07","Com Saldo","","","","Sem Saldo","","","Ambos","","","","","","","","","","","","")
	PutSX1(cPerg,"08","Seta Data Inventário ",			"","","mv_ch8","D",08,0,0,"G","","","","","Mv_Par08")

Return Nil
