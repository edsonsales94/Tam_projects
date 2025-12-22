#INCLUDE "rwmake.ch"
#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCOME04  บAutor  ณEner Fredes         บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para a coloca็ใo de anexos e grava็ใo dos anexos no   บฑฑ 
ฑฑบ          ณ sistema na tabela SZF. Sใo passados como parametros:       บฑฑ
ฑฑบ          ณ   * cTipo - Tipo do couemnto que estแ vinculado o anexo:   บฑฑ
ฑฑบ          ณ                   1 - Solicita็ใo de Compra                บฑฑ
ฑฑบ          ณ                   2 - Pedido de Compra                     บฑฑ
ฑฑบ          ณ                   3 - Viagem                               บฑฑ
ฑฑบ          ณ   * cNum - N๚mero da Solicita็ใo de Compra ou Pedido de    บฑฑ
ฑฑบ          ณ            Compra ou Viagem                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRAS - PE MT160WF - ANALISE DE COTAวรO                  บฑฑ
ฑฑบ          ณ COMPRAS - PE MT110CON - SOLICITACAO DE COMPRA              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function INCOME04(cTipo,cNum,lGrava,lMostra,cVarGbl,lObriga,aReg_SZF)
	Local aOps,lExec,nLin:= 0
  	Local nAnexo := Getmv("MV_ANEXO")
	Private __aHeader := aHeader                                                               
	Private __aCols := aCols                                                               
	Private oDlg,oBtn,oGet
	Private aOps:= Array(nAnexo,2)      
   Private lClose := lObriga
  

	If !Empty(cVarGbl)
		GetGlbVars(cVarGbl,@aCols)
	Else
		aCols := {}
	EndIf

	If lMostra
//		While lClose .or. !lObriga
			lObriga := .T.
			Private aRotina := {{"Pesquisar" , "AxPesqui", 0, 1},;
										{"Visualizar", "AxVisual", 0, 2},;
										{"Incluir"   ,	"AxInclui", 0, 3},;
										{"Alterar"   , "AxAltera", 0, 4},;
										{"Excluir"   , "AxDeleta", 0, 5}}
		
			CriaHeader()                                   
		
			@ 00,00 To 270,700 Dialog oDlg Title "Anexar Arquivos "
			oGet := MSGetDados():New(01,01,85,354,3, "",,"",.F.,{},,,nAnexo,,,,"")
			oGet:oBrowse:Refresh()                                                                                                       
		
			oBtn  := TButton():New( 104,005, '&Anexar' , oDlg,{|| fAnexar()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
			oBtn  := TButton():New( 104,045, '&Confirmar' , oDlg,{||(IIf(lGrava,fAtuSZF(cTipo,cNum,aCols,lMostra),fConfirmar(cTipo,cNum,aCols,lMostra,cVarGbl)))}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
			oBtn  := TButton():New( 104,085, '&Limpar' , oDlg,{|| fLimpar(cNum,cTipo)}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
			oBtn  := TButton():New( 104,125, '&Sair' , oDlg,{|| fSair(cTipo)}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
			ACTIVATE DIALOG oDlg CENTERED
  //		End
	Else 
		If lGrava
			fAtuSZF(cTipo,cNum,aReg_SZF,lMostra)
		EndIf
	EndIf
return .T.                                                      

Static Function fSair(cTipo)              
	If !Empty(aCols)
		If cTipo <> "2" 
			aHeader := __aHeader
			aCols := __aCols
			Close(oDlg)
		EndIf 	
		lClose := .T.
	EndIf
Return .T.     

                          
Static Function CriaHeader()
	Local cAlias 	:= "SZF" 
	Local cCAcols  := "ZF_CAMINHO"  
	
	aHeader := {}
	 
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias) 
		
	While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias )
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ cCAcols)
			aAdd(aHeader,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
								SX3->X3_CAMPO   , ;  //2  Nome do Campo
								SX3->X3_PICTURE , ;  //3  Picture Campo 
								SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
								SX3->X3_DECIMAL , ;  //5  Casas decimais 
								""              , ;  //6  Validacao do campo
								SX3->X3_USADO   , ;  //7  Usado ou naum
								SX3->X3_TIPO    , ;  //8  Tipo do campo
								SX3->X3_ARQUIVO , ;  //9  Arquivo 
								SX3->X3_CONTEXT } )  //10 Visualizar ou alterar
		Endif
		dbSkip()
	End                                               
	
Return .T.     
  




Static function fAnexar()
	Local cArq
	Local cCaminho:= cGetFile( "*.*" , "Anexar Cota็๕es",1,'C:\',.F.,GETF_NETWORKDRIVE + GETF_LOCALHARD )   //---anexo 
	If !Empty(cCaminho)
		If Len(aCols) > 0
	  		If !(Empty(aCols[Len(aCols)][1]))
				fCriaVar()
			EndIf
		Else
			fCriaVar()
		EndIf
		aCols[Len(aCols)][1] := cCaminho
	Endif
Return .T.     
  

Static function fConfirmar(cTipo,cNum,aCols,lMostra,cVar)
	PutGlbVars(cVar,aCols)
	aHeader := __aHeader
	aCols := __aCols
	Close(oDlg)
	lClose := .T.
Return .T.     



Static Function fAtuSZF(cTipo,cNum,aReg_SZF,lMostra)
	Local cQuery :=  ""
	Local cAlias := ALIAS()                             
	Local nPosExtens // Posicao da exten็ใo
	Local cPathWeb := GetPvProfString("HTTP","uploadpath","\web\followup",GetAdv97()) + "\"
    Local i 
   /*Iniciando Diego devido ao erro que se da quando altera-se a SC*/
   
   /*
	cQuery += " DELETE "+RetSQLName("SZF")
	cQuery += " WHERE ZF_NUM = '"+cNum+"'
	cQuery += " AND  ZF_TIPO = '"+cTipo+"' AND ZF_FILIAL = '"+xFilial("SZF")+"'"
	TcSqlExec(cQuery)
  */
	For i:= 1 to Len(aReg_SZF)            
		cCaminho := Alltrim(aReg_SZF[i][1]) 
		cArquivo := cCaminho   
		lOne := .F.
		While (at("\",cArquivo)) <> 0
			cArquivo:= SubStr(cArquivo,at("\",cArquivo)+1,Len(cArquivo)-at("\",cArquivo))
			lOne := .T.
		Enddo
      If lOne
			If !Empty(cCaminho)
				lCpyOk := CPYT2S(cCaminho,cPathWeb)
				If lCpyOk                  
					nPosExtens := 1
					While At('.',SubStr(cArquivo,nPosExtens,Len(cArquivo))) > 0
						nPosExtens := nPosExtens+At('.',SubStr(cArquivo,nPosExtens,Len(cArquivo)))
					End
					cArqSrv := cNum+cTipo+StrZero(i,3)+"."+SubStr(cArquivo,nPosExtens,Len(cArquivo))
					DbSelectArea("SZF")
					RecLock("SZF",.T.)
					SZF->ZF_FILIAL := xFilial("SZF")
					SZF->ZF_NUM    := cNum
					SZF->ZF_TIPO   := cTipo
					SZF->ZF_ITEM   := StrZero(i,3)
					SZF->ZF_ARQ    := cArquivo
					SZF->ZF_ARQSRV := cArqSrv
					SZF->ZF_CAMINHO:= cCaminho
					MsUnLock()
					FErase(cPathWeb+cArqSrv)
					FRename(cPathWeb+cArquivo,cPathWeb+cArqSrv) 
				Else
					Alert("Error na Gravacao do anexo. Arquivo nao pode ficar na Unidade principal !")  
					Return .T.     
				EndIf
			EndIf  
		EndIf
	Next   

	DbSelectArea(cAlias)
	If lMostra
		Close(oDlg)
	EndIf
	aHeader := __aHeader
	aCols := __aCols 
	
Return .T.     


                      
Static function fLimpar(cNum,cTipo)
	Local cPathWeb := GetPvProfString("HTTP","uploadpath","\web\followup",GetAdv97()) + "\"
   
   SZF->(dbSetOrder(1))
   SZF->(dbSeek(xFilial('SZF')+cTipo+cNum))
   
   While(SZF->(ZF_FILIAL+ZF_TIPO+ZF_NUM) = xFilial('SZF')+cTipo+cNum)
     FErase(cPathWeb+SZF->ZF_ARQSRV)
     SZF->(dbSkip())
   EndDo
   
	cQuery := " DELETE "+RetSQLName("SZF")
	cQuery += " WHERE ZF_NUM = '"+cNum+"'
	cQuery += " AND  ZF_TIPO = '"+cTipo+"' AND ZF_FILIAL = '"+xFilial("SZF")+"'"
	TcSqlExec(cQuery)      
	
	aCols := {}            
	oGet:Refresh()
Return .T.     

                           

              
Static Function fCriaVar()
	Local i
	aAdd(aCols,Array(Len(aHeader)+1))                	
	For i:= 1 to Len(aHeader)		  
		aCols[Len(aCols)][i] := CriaVar(Trim(aHeader[i][2]),.T.)
	Next    
	aCols[Len(aCols)][len(aHeader)+1] := .F.
Return .T.     

