#INCLUDE "rwmake.ch"

User Function AACOMR02()

 Local _nLin         := 60   
 Private cFornecedor := ""
 Private cLoja       := ""
 Private cCotacao    := ""
 Private aLinha      := {}
 Private aExport     := {}     
 PRIVATE cPerg       := PADR("AACOMR02",Len(SX1->X1_GRUPO)) 
 
 CriaSx1(cPerg)
 Pergunte(cPerg,.T.)
 
 fTabTmp()         
  
  cCotacao := WWW->C8_NUM	 	 	 
  
  While !Eof() .And. cCotacao == WWW->C8_NUM 
    aExport := {} 
  	SA2->(DbSetOrder(1))
 	SA2->(DbSeek(xFilial("SA2") + ALLTRIM(WWW->C8_FORNECE) + ALLTRIM(WWW->C8_LOJA)))
 	
	cFornecedor := SA2->A2_NOME
	cFornece := WWW->C8_FORNECE
 	cLoja := WWW->C8_LOJA
 	
  	While !Eof() .And. cCotacao == WWW->C8_NUM .And. cFornece == WWW->C8_FORNECE .And. cLoja == WWW->C8_LOJA 
	
 		aAdd(aLinha,Transform(WWW->C8_ITEM, "@! 999999"))
		aAdd(aLinha,AllTrim(WWW->C8_PRODUTO))        	
		aAdd(aLinha,Posicione('SB1',1,xFilial('SB1')+WWW->C8_PRODUTO,"B1_DESC"))        	
		aAdd(aLinha,Transform(WWW->C8_QUANT, "@E 9,999,999,999"))
		aAdd(aLinha,AllTrim(WWW->C8_PRECO))
		aAdd(aLinha,AllTrim(WWW->C8_COND))                                       			  
	    aAdd(aLinha,AllTrim(WWW->C8_PRAZO))
						 
		aAdd(aExport,Array(Len(aLinha)))
		aExport[Len(aExport)] := aClone(aLinha)
		aLinha := {} 

    	WWW->(dbSkip())		 	
  	End  	
	MsgRun("Exportando Dados, Aguarde...",,{|| Exporta()})	 	 	
  End

  WWW->(DbCloseArea())
  MS_FLUSH()
Return

//
//  .--------------------------------------.
// |     Cria grupo de perguntas no SX1     |
//  '--------------------------------------'
//
Static Function CriaSx1()   
  PutSX1(cPerg, "01", "Da Cotacao       :", "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "SC8", "", "", "mv_par01")
//  PutSX1(cPerg, "02", "Ate Cotação      :", "", "", "mv_ch4", "C", 15, 0, 0, "G", "", "SC8", "", "", "mv_par04")    
//  PutSX1(cPerg, "03", "Exportar Excel :", "", "", "mv_ch5", "N", 01, 0, 0, "C", "", ""   , "", "", "mv_par03",;
//                      "Sim","","","","Nao","","","","","","","","","","","","","","","")
  PutSX1(cPerg, "04", "Diretorio      :", "", "", "mv_ch7", "C", 25, 0, 0, "G", "", ""   , "", "", "mv_par04")
  PutSX1(cPerg, "05", "Nome Arquivo   :", "", "", "mv_ch8", "C", 15, 0, 0, "G", "", ""   , "", "", "mv_par05")

Return Nil
           
//
//  .--------------------------------------.
// |     Cria tabela temporária            |
//  '--------------------------------------'
//
Static Function fTabTmp()
  	Local cQry     := "" 
 	 	        
	cQry := "SELECT A.C8_NUM, A.C8_FORNECE,A.C8_LOJA,A.C8_ITEM,A.C8_PRODUTO, A.C8_QUANT, A.C8_PRECO, A.C8_COND, A.C8_PRAZO " 
    cQry += " FROM " + RetSqlName("SC8") + " A "			
	cQry += " WHERE A.D_E_L_E_T_ <> '*' "
 	cQry += " AND A.C8_NUM = " + mv_par01   
	cQry += " ORDER BY A.C8_NUM, A.C8_FORNECE, A.C8_LOJA, A.C8_ITEM "
 
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "WWW", .T., .F. )
  dbSelectArea("WWW")
Return nil    

//--------------------------------------------------------------------------------------------
//*******************ROTINAS DE EXPORTAÇÃO PARA EXC*****************************************

Static Function Exporta()
   Local cArqTxt    := AllTrim(Mv_Par02)+AllTrim(Mv_Par03)+" - "+ALLTRIM(cFornecedor)+".xls"
   Local nHdl       := fCreate(cArqTxt)
   Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)
   
   If nHdl = -1
      MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado! ERRO:" + FError())  
      WWW->(DbCloseArea())
	  Return nil
	EndIf
	
   cLinha += "AMAZON AÇO INDUSTRIA E COMÉRCIO LTDA"  +chr(13)+chr(10)
   cLinha += "COTAÇÃO: "     + ALLTRIM(cCotacao) +chr(13)+chr(10)
   cLinha += "FORNECEDOR: "  + ALLTRIM(cFornecedor) +chr(13)+chr(10)
   cLinha += " "  + chr(13)+chr(10)     
   cLinha += "Item"	    + Chr(9) + "Produto"   + Chr(9) + "Descrição" + Chr(9)+"Quantidade"+Chr(9) 
   cLinha += "Preco"    + Chr(9) + "Pagamento" + Chr(9) + "Prazo"	+chr(13)+chr(10) 

   
    If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    EndIf            
   
    For i:=1 to Len(aExport)
       cLinha := ""

       If ValType(aExport[i])<>"A"
          cLinha += aExport[i]
       Else
          For j := 1 to Len(aExport[i])
              cLinha += aExport[i][j]+Chr(9)
          Next                          
       Endif                  
       
       cLinha += chr(13)+chr(10)
       
       If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
       EndIf          
    Next
  fClose(nHdl)     
  RunExcel(cArqTxt)  
Return Nil                                                                                  

*****************************************************************************************************************************      

Static Function RunExcel(cwArq)
  Local oExcelApp                           
  Local aNome := {}                                    

  If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
    MsgStop( 'Arquivo Gerado no Diretorio Informado' )
    //MsExcel nao instalado 
    Return
  EndIf  
  oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
  oExcelApp:WorkBooks:Open(cwArq) 
  oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
  
Return