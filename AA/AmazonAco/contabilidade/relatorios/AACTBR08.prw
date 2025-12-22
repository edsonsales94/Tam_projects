#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AACTBR08   ¶ Autor ¶ WILLIAMS MESSA W     ¶ Data ¶ 26/02/2021 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Geração do Razão Personalizado para Controle de Gestão        ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AACTBR08()

	Local cPerg := Padr("AACTBR08",9)
	ValidPerg(cPerg)
	
	If Pergunte(cPerg) 
		Processa({|| fMontaDados() },"Coletando os dados")    
		Processa({|| fImpExcel() },"Imprimindo Excel")    
		DbCloseArea("TBASE")
	EndIf
Return
       
Static Function fMontaDados()
	Local cQuery
	
			cQuery := " SELECT CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC, 
	   		cQuery += " CT2_LINHA,CT2_DC,CT2_CONTA,CT1_DESC01,CT2_CCD,CTT_DESC01,CT2_VALORD,CT2_VALORC,CT2_HIST,R_E_C_N_O_
	   		cQuery += " FROM VW_CT2010 "
		    cQuery += " WHERE CT2_FILIAL = '"+Alltrim(MV_PAR01)+"' AND 
		    cQuery += " CT2_DATA BETWEEN '"+Dtos(MV_PAR02)+"' AND  '"+Dtos(MV_PAR03)+"'
		    cQuery += " AND  CT2_CONTA BETWEEN '"+(MV_PAR04)+"' AND  '"+(MV_PAR05)+"'
		    //cQuery += " AND  CT2_CT2_CCC BETWEEN '"+(MV_PAR07)+"' AND  '"+(MV_PAR08)+"' 
			//cQuery += " AND  CT2_CT2_CCD BETWEEN '"+(MV_PAR07)+"' AND  '"+(MV_PAR08)+"'
			//Filtra os 2 campos(CT2_CCC E CT2_CCD) com as mesmas variáveis de parametros para Centro de Custos
			
			Memowrit("SCTBR001.SQL",cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TBASE",.T.,.T.)   
Return                                 



Static Function fImpExcel()
	Local oExcelApp                           
	Local nPos                  
	Local cArqTxt   := "C:\Spool\SCTBR0"+"_"+Alltrim(MV_PAR01)+".xls"
	Local nLin := 0
	Local nTempoPad 
	Local nTempoTot
    Local aRet :={}
    
	Private nHdl       := fCreate(cArqTxt)
	Private cLinha     := ""



	cLinha := "Razão Personalizado para Controle de Gestão"+Chr(9)+chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))

	cLinha := Chr(9)+Chr(9)+chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))

	cLinha := "FILIAL"+Chr(9)
	cLinha += "ANO_MES"+Chr(9)
	cLinha += "DATA"+Chr(9)
	cLinha += "LOTE"+Chr(9)
	cLinha += "SUBLOTE"+Chr(9)
	cLinha += "DOCUMENTO"+Chr(9)
	cLinha += "LINHA"+Chr(9) 
	cLinha += "DC"+Chr(9)
	cLinha += "GRUPO"+Chr(9)
	cLinha += "TIPO"+Chr(9)
	cLinha += "CONTA"+Chr(9)
	//cLinha += "DESC01"+Chr(9)
	cLinha += "CENTRO_CUSTO"+Chr(9)
	//cLinha += "CTT_DESC01"+Chr(9)
	cLinha += "VALOR_DEBITO"+Chr(9)
	cLinha += "VALOR_CREDITO"+Chr(9)
	cLinha += "VALOR_MOVIMENTO"+Chr(9)
	cLinha += "HISTORICO"+Chr(9)
	cLinha += "DOC_ORIGINAL"+Chr(9)
	cLinha += "NOME_CLIFOR"+Chr(9)
	cLinha += chr(13)+chr(10)  
  fWrite(nHdl,cLinha,Len(cLinha))

	While !TBASE->(Eof())
		
		cLinha :="'"+ TBASE->CT2_FILIAL+Chr(9)
		cLinha +="'" + Substr(TBASE->CT2_DATA,1,4)+ Substr(TBASE->CT2_DATA,5,2)+Chr(9)
		cLinha += "'"+ Substr(TBASE->CT2_DATA,7,2)+"/"+Substr(TBASE->CT2_DATA,5,2)+"/"+Substr(TBASE->CT2_DATA,1,4)+Chr(9) 
		cLinha += "'"+ TBASE->CT2_LOTE+Chr(9)
		cLinha += "'"+ TBASE->CT2_SBLOTE+Chr(9) 
		cLinha += "'"+ Alltrim(TBASE->CT2_DOC)+Chr(9)
		cLinha += "'"+ Alltrim(TBASE->CT2_LINHA)+Chr(9)
		cLinha += "'"+ Alltrim(TBASE->CT2_DC)+Chr(9)
		//GRUPO 
		cLinha += "'"+ Alltrim(Substr(TBASE->CT2_CONTA,1,4))+"-"+Posicione("CT1",1,xFilial("CT1")+Substr(TBASE->CT2_CONTA,1,4),"CT1_DESC01")+Chr(9)
		//TIPO
		If substr(Alltrim(TBASE->CT2_CONTA),1,1)=="1"
			cLinha += "'"+ Alltrim("1 - ATIVO")+Chr(9)
		ElseIf substr(Alltrim(TBASE->CT2_CONTA),1,1)=="2"
			cLinha += "'"+ Alltrim("2 - PASSIVO")+Chr(9)
		ElseIf substr(Alltrim(TBASE->CT2_CONTA),1,1)=="3"
			cLinha += "'"+ Alltrim("3 - RECEITA")+Chr(9)
		ElseIf substr(Alltrim(TBASE->CT2_CONTA),1,1)=="4"
			cLinha +="'"+ Alltrim("4 - CUSTO")+Chr(9)
		ElseIf substr(Alltrim(TBASE->CT2_CONTA),1,1)=="5"
			cLinha += "'"+ Alltrim("5 - DESPESA")+Chr(9)
		EndIf
		cLinha += "'"+ Alltrim(TBASE->CT2_CONTA)+"-"+Alltrim(TBASE->CT1_DESC01)+Chr(9)
		//cLinha += "'"+ Alltrim(TBASE->CT1_DESC01)+Chr(9)
		cLinha += "'"+ Alltrim(TBASE->CT2_CCD)+"-"+Alltrim(TBASE->CTT_DESC01)+Chr(9)
		//cLinha += "'"+ Alltrim(TBASE->CTT_DESC01)+Chr(9)
		cLinha += Transform(TBASE->CT2_VALORD,"@E 999,999,999.99")+Chr(9)
		cLinha += Transform(TBASE->CT2_VALORC,"@E 999,999,999.99")+Chr(9)
		//VALOR DO MOVIMENTO
		cLinha += Transform((TBASE->CT2_VALORD+TBASE->CT2_VALORC),"@E 999,999,999.99")+Chr(9)
		cLinha += "'"+ Alltrim(TBASE->CT2_HIST)+Chr(9)
		//RASTREAR
		aRet := STCTBRAST(ALLTRIM(STR(INT(TBASE->(R_E_C_N_O_)))))
		
		If Len(aRet) > 0
			cLinha += "'"+ Alltrim(aRet[1][1])+Chr(9)
			cLinha += "'"+ Alltrim(aRet[1][2])+Chr(9)
		Else
			cLinha += Alltrim("")+Chr(9)
			cLinha += Alltrim("")+Chr(9)
		EndIf 
		cLinha += chr(13)+chr(10)	
		fWrite(nHdl,cLinha,Len(cLinha))
	
		TBASE->(DbSkip())
	End 
    TBASE->(dbCloseArea())          
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
	U_PIPutSx1(cPerg,"01",PADR("Da Filial"           ,29),PADR("Da Filial "          ,29),PADR("Da Filial "          ,29),"mv_ch1","C",04,0,0,"G","","SM0","","","mv_par01")
	U_PIPutSx1(cPerg,"02",PADR("Da Data"             ,29),PADR("Da Data"             ,29),PADR("Da Data"             ,29),"mv_ch2","D",08,0,0,"G","",""	  ,"","","mv_par02")
	U_PIPutSx1(cPerg,"03",PADR("Ate a Data"          ,29),PADR("Ate a Data"          ,29),PADR("Ate a Data"          ,29),"mv_ch3","D",08,0,0,"G","",""	  ,"","","mv_par03")
	U_PIPutSx1(cPerg,"04",PADR("Da Conta"            ,29),PADR("Da Conta "           ,29),PADR("Da Conta "           ,29),"mv_ch4","C",20,0,0,"G","","CT1","","","mv_par04")
	U_PIPutSx1(cPerg,"05",PADR("Até a Conta "        ,29),PADR("Até a Conta "        ,29),PADR("Até a Conta "        ,29),"mv_ch5","C",20,0,0,"G","","CT1","","","mv_par05")
	//PutSX1(cPerg,"05",PADR("Do Centro Custo"     ,29),PADR("Do Centro Custo"     ,29),PADR("Da Conta "           ,29),"mv_ch7","C",20,0,0,"G","","CTT","","","mv_par07")
	//PutSX1(cPerg,"06",PADR("Até o Centro Custo " ,29),PADR("Até o Centro Custo " ,29),PADR("Até o Centro Custo " ,29),"mv_ch8","C",20,0,0,"G","","CTT","","","mv_par08")
Return

/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ STCTBRAST  ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 26/02/2021 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Rastrear as ultimas 2 colunas do Relatorios                   ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/
Static Function STCTBRAST(cRecCT2)

Local aDados   := {}
Local lAchou   := .F.
Local cNomeCli := ""
Local cNomeFor := ""

dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)		
		
dbSelectArea("CV3")
dbSetOrder(2)
If dbSeek(xFilial("CV3")+cRecCT2,.F.)
	lAchou := .T.
EndIf			
	
If lAchou
	dbSelectArea(CV3->CV3_TABORI)          /// SELECIONA A TABELA DE ORIGEM
	nRecOri := int(val(CV3->CV3_RECORI))   /// CONVERTE RECNO ORIGEM PARA NUMERICO
	dbGoTo(nRecOri)						   /// POSICIONA NO REGISTRO DE ORIGEM
		If (CV3->CV3_TABORI)->(!Eof()) .and. (CV3->CV3_TABORI)->(Recno()) == nRecOri	/// SE LOCALIZOU										
			If AllTrim(CV3->CV3_TABORI)=="SE5"
			   AADD(aDados,{(CV3->CV3_TABORI)->E5_DOCUMENT,(CV3->CV3_TABORI)->E5_BENEF})
			ElseIf AllTrim(CV3->CV3_TABORI)=="SF2"
					
					If SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(F2_CLIENTE+F2_LOJA)))
						cNomeCli:=	SA1->A1_COD +"/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME
					ElseIf SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(F2_CLIENTE+F2_LOJA)))
						cNomeCli:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME	
					EndIf
			   		AADD(aDados,{(CV3->CV3_TABORI)->F2_DOC,cNomeCli})
			
			ElseIf AllTrim(CV3->CV3_TABORI)=="SD2"
					
					If SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(D2_CLIENTE+D2_LOJA)))
						cNomeCli:=	SA1->A1_COD +"/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME
					ElseIf SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(D2_CLIENTE+D2_LOJA)))
						cNomeCli:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME	
					EndIf
			   		AADD(aDados,{(CV3->CV3_TABORI)->D2_DOC,cNomeCli})
			
			ElseIf AllTrim(CV3->CV3_TABORI)=="SF1"
					
					If SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(F1_FORNECE+F1_LOJA)))
						cNomeFor:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME
					ElseIf SA1->(xFilial("SA1")+(CV3->CV3_TABORI)->(F1_FORNECE+F1_LOJA))
						cNomeFor:=	SA1->A1_COD + "/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME	
					EndIf	
			
			  	   AADD(aDados,{(CV3->CV3_TABORI)->F1_DOC,cNomeFor})
		    
		    ElseIf AllTrim(CV3->CV3_TABORI)=="SE1"
					If SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(E1_CLIENTE+E1_LOJA)))
						cNomeCli:=	SA1->A1_COD + "/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME
					ElseIf SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(F2_CLIENTE+F2_LOJA)))
						cNomeCli:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME	
					EndIf		
			   		AADD(aDados,{(CV3->CV3_TABORI)->E1_NUM,cNomeCli})
			
			ElseIf AllTrim(CV3->CV3_TABORI)=="SE2"
					
					If SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(E2_FORNECE+E2_LOJA)))
						cNomeFor:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME
					ElseIf SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(E2_FORNECE+E2_LOJA)))
						cNomeFor:=	SA1->A1_COD + "/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME	
					EndIf
					AADD(aDados,{(CV3->CV3_TABORI)->E2_NUM,cNomeFor})
					
			ElseIf AllTrim(CV3->CV3_TABORI)=="SEZ"
					
					If SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(EZ_CLIFOR+EZ_LOJA)))
						cNomeFor:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME
					ElseIf SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(EZ_CLIFOR+EZ_LOJA)))
						cNomeFor:=	SA1->A1_COD + "/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME	
					EndIf
					AADD(aDados,{(CV3->CV3_TABORI)->EZ_NUM,cNomeFor})
					
			ElseIf AllTrim(CV3->CV3_TABORI)=="SD1"
					
					If SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(D1_FORNECE+D1_LOJA)))
						cNomeFor:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME
					ElseIf SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(D1_FORNECE+D1_LOJA)))
						cNomeFor:=	SA1->A1_COD + "/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME	
					EndIf
					AADD(aDados,{(CV3->CV3_TABORI)->D1_DOC,cNomeFor}) 
			/*		
			ElseIf AllTrim(CV3->CV3_TABORI)=="SE5"
					
					If 
					
					If SA2->(dbSeek(xFilial("SA2")+(CV3->CV3_TABORI)->(E2_FORNECE+E2_LOJA)))
						cNomeFor:=	SA2->A2_COD + "/"+ SA2->A2_LOJA +"-"+ SA2->A2_NOME
					ElseIf SA1->(dbSeek(xFilial("SA1")+(CV3->CV3_TABORI)->(E2_FORNECE+E2_LOJA)))
						cNomeFor:=	SA1->A1_COD + "/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME	
					EndIf
					AADD(aDados,{(CV3->CV3_TABORI)->E2_NUM,cNomeFor})   		
			*/
			EndIf			
		EndIf
EndIf	
	
	
Return(aDados)
