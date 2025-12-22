//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#Include 'Protheus.ch'

/*/{protheus.doc}HLINVP04
Rotina principal para a importação de um arquivo de extensao CSV para o orçamento do SIGAPCO.  
@author Wermeson Gadelha
@since 01/03/2014
/*/

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PLPCOP01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina principal para a importação de um arquivo de extensao  +¦¦
¦¦¦  (Cont)   ¦ CSV para o orçamento do SIGAPCO.                              +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLINVP04()                                                  
 //-------------------------------------------------------. 
 // Declaração das variaveis locais do prorama             |
 //-------------------------------------------------------' 
 Local cCaminho := Space(100)
 Local cOrcame  := dDataBase
 Local lRet     := .F.
 Local aImport  := {}
 Local nOpc     := 0                                        

//axcadastro("SZ4")
//axcadastro("SZ5")
 
 //-------------------------------------------------------. 
 // Declaração das variaveis privadas do prorama           |
 //-------------------------------------------------------' 
 Private nTotReg := 0 //Total de registros lidos

	//-------------------------------------------------------. 
	// Estrutura de repetição para excolha do arquivo         |
	//-------------------------------------------------------' 
	While !lRet
		//-------------------------------------------------------. 
		// Inicializaçaõ dos valores das variaveis auxiliares     |
		//-------------------------------------------------------' 	
		nOpc := 0
		lRet := .F.  
		
		//-------------------------------------------------------. 
		// Inicialização objeto de apresentação da tela principal |
		//-------------------------------------------------------' 	
		DEFINE MSDIALOG oDlg TITLE "Importação de Listagem" From 0,0 To 14,50 
		
			//-------------------------------------------------------. 
			// Objetos para definição do arquivo de importação        |
			//-------------------------------------------------------' 			

			oSayOrcame := tSay():New(10,07,{||  "Data:"},oDlg,,,,,,.T.,,,200,80)                 
			oGetOrcame := TGet():New(10,40,{|u| If(PCount()>0,cOrcame:=u,cOrcame)},oDlg,50,10,'',,,,,,,.T.,,,,,,,,,,'cOrcame') 
		   //	oGetOrcame:cF3 := "AK1" 
						
//			oSayVersao := tSay():New(10,105,{||  "Versao:"},oDlg,,,,,,.T.,,,200,80)
//			oGetVersao := TGet():New(10,130,{|u| If(PCount()>0,cVersao:=u,cVersao)},oDlg,50,10,'@!',,,,,,,.T.,,,,,,,,,,'cVersao') 
			
			oSayArq := tSay():New(35,07,{||  "Informe o local onde se encontra o arquivo para importação:"},oDlg,,,,,,.T.,,,200,80)
			oGetArq := TGet():New(45,05,{|u| If(PCount()>0,cCaminho:=u,cCaminho)},oDlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'cCaminho') 
			oBtnArq := tButton():New(45,160,"&Abrir...",oDlg,{|| cCaminho := fwDlgArq(cCaminho)},30,12,,,,.T.) //&Abrir...								

			
			//-------------------------------------------------------. 
			// Objetos que definem os botoes Cancelar e Confirmar     |
			//-------------------------------------------------------' 			
			oBtnImp := tButton():New(70,050,"Importar", oDlg,{|| nOpc:=1,oDlg:End()},40,12,,,,.T.) //Importar
			oBtnCan := tButton():New(70,110,"Cancelar", oDlg,{|| nOpc:=0,oDlg:End()},40,12,,,,.T.) //Cancelar
			
		ACTIVATE MSDIALOG oDlg CENTERED
	
		//-------------------------------------------------------. 
		// Verifica se a opção escolhida foi Importar (botao)     |
		//-------------------------------------------------------' 			
		If nOpc == 1
				//-------------------------------------------------------. 
				// Validaçoes referentes ao arquivo de importação         |
				//-------------------------------------------------------' 				
				If Empty(cCaminho) // verifica se o arquivo foi escolhido
						MsgInfo("Favor informar o arquivo para a importação!","Atenção")
						lRet := .F.
					ElseIf !File(cCaminho) // verifica se o caminho/arquivo escolhido existe 
						MsgInfo("Arquivo informado não encontrado!","Atenção")
						lRet := .F.
					Else // Valida
						lRet := .T.
				EndIf	
			Else
				lRet := .T.
		EndIf
	
		//-------------------------------------------------------. 
		// Se arquivo valiado e opçaõ escolhida é Importar        |
		//-------------------------------------------------------' 			
		If lRet .And. nOpc == 1
			//-------------------------------------------------------. 
			// Processa leitura do arquivo para importação            |
			//-------------------------------------------------------' 			
			Processa({|| aImport := fwLerArq(cCaminho)},"Processando...","Aguarde Processando a leitura do arquivo...") //Aguarde Processando a leitura do arquivo...
			                    
			//-------------------------------------------------------. 
			// Verifica se encotrou algum registro a ser importado    |
			//-------------------------------------------------------' 			
			If Len(aImport) == 0
					//-------------------------------------------------------. 
					// Informa ao usuário problemas encontrados               |
					//-------------------------------------------------------' 				
					MsgInfo("Não foram encontrados registros aptos para importação!","Atenção")
				ElseIf MsgYesNo("Serão importados " +AllTrim(Str(Len(aImport))) +" registro(s) de " +AllTrim(Str(nTotReg)) +"registro(s) lido(s). Confirma?") //Serão importados registro(s) de registro(s) lido(s). Confirma?
					//-------------------------------------------------------. 
					// Processa a importação do Orçamento - SIGAPCO           |
					//-------------------------------------------------------' 				
					Processa({|| aImport := fwGravar(aImport,cOrcame,cVersao)},"Processando...","Gravando previsões de vendas...")
			EndIf
			
		EndIf
			
	End   

//-------------------------------------------------------. 
// Retorno da funcao PLPCOP01                             |
//-------------------------------------------------------'	
Return lRet                                                                           

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwDlgArq   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta janela de escolha dos arquivos.                         +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwDlgArq(cArquivo)
 //-------------------------------------------------------. 
 // Declaração das variaveis locais do prorama             |
 //-------------------------------------------------------' 
 Local cType 	 := "Arquivo" +" (*.csv) |*.csv|"
 Local cArquivo := cGetFile(cType, "Selecione o arquivo para a Importação")

	If !Empty(cArquivo)
			cArquivo += Space(100-Len(cArquivo))
		Else                                                                   
			cArquivo := Space(100)
	EndIf
	
Return cArquivo

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwLerArq   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para leitura do arquivo escolhido pelo usuário e monta-+¦¦
¦¦¦  (Cont)   ¦ gem do array com os dados para serem trabalhados;             +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwLerArq(cArquivo)
 Local cLinha   := ""
 Local cTrecho  := ""
 Local nHdl     := 0
 Local cProd    := ""
 Local nQtde    := 0
 Local aImport  := {}
 Local aColunas := {}
 Local nX       := 0
 Local cDoc     := ""
 
 
	nHdl    := FT_FUSE(cArquivo)
	nTotReg := FT_FLASTREC()
	
	FT_FGOTOP()
	ProcRegua(nTotReg)
	
	While !FT_FEOF()
		//-- Reinicia variaveis
		cCusto   := ""
		cConta   := ""
		nX       := 0
		cLinha   := FT_FREADLN()    
		aColunas := {}
		
		While !Empty(cLinha)
			nX++
			cTrecho := If(At(";",cLinha)>0,Substr(cLinha,1,At(";",cLinha)-1),cLinha)
			cLinha  := If(At(";",cLinha)>0,Substr(cLinha,  At(";",cLinha)+1),"")			 
			aAdd( aColunas, cTrecho)
			
		End          
		
		aAdd(aImport,Array(Len(aColunas)))
		aImport[Len(aImport)] := aClone(aColunas)

		IncProc()
	
		FT_FSKIP()
	End
	FT_FUSE()
	
Return aImport

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwGravar   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para para grvar as informações das cartelas de inventa-+¦¦
¦¦¦  (Cont)   ¦ rio nas tabelas SZ4 (cabecalho) e SZ5 (Itens)                 +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwGravar(aImport,cwOrcamen,cwVersao)
 Local nX := 0         
 
 	Begin Transaction               	
 	
   			cwCart := "."
   			
		    For nwInd := 2 to Len(aImport)
		    
		    	If cwCart <> aImport[nwInd][8]              
			    	dbSelectARea("SZ4")
					RecLock("SZ4",.T.)
						SZ4->Z4_NUM     :=aImport[nwInd][8]
						SZ4->Z4_FILIAL  := xFilial("SZ4") 
						SZ4->Z4_DATA    := dDataBase
						SZ4->Z4_STATUS  := "1"
						SZ4->Z4_OBS       := aImport[nwInd][9]         
						SZ4->Z4_AREA     := aImport[nwInd][10]         
					SZ4->(MsunLock())       
					cwCart :=  aImport[nwInd][8]   
		    	EndIf      ]
		    	
		    	dbSelectARea("SZ5")
				RecLock("SZ5",.T.)
					SZ5->Z5_NUM     := aImport[nwInd][8]
					SZ5->Z5_FILIAL  := xFilial("SZ5") 
					SZ5->Z5_COD     := aImport[nwInd][1]
					SZ5->Z5_QATU    := 0
					SZ5->Z5_DESC    := aImport[nwInd][2]
					SZ5->Z5_LOCAL   := aImport[nwInd][6]
					SZ5->Z5_GRUPO   := aImport[nwInd][4]     
					SZ5->Z5_DESCGRP := aImport[nwInd][5]     
					SZ5->Z5_UM      := aImport[nwInd][7]     
					SZ5->Z5_TIPO    := aImport[nwInd][3]     	  
					SZ5->Z5_OBS     := aImport[nwInd][9] 									
					SZ5->Z5_QTDE1   := val(aImport[nwInd][11])
					SZ5->Z5_QTDE2   := val(aImport[nwInd][11])
					SZ5->Z5_QTDE3   := val(aImport[nwInd][11])
				SZ5->(MsunLock())
		
								
			Next nInd
		
 	End Transaction               
	
	MsgInfo("Importação concluída!","Listagem Inventario")
	
Return Nil
                                           
/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
************************************************************************************/ 