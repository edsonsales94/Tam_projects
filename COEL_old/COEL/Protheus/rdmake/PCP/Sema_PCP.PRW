#include "Protheus.ch"            
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#DEFINE  ENTER CHR(13)+CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa      ณ MGFATA16                                       บ Data ณ 10/05/2010  บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao     ณ Rotina de Programa็ao de PCP                                        บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออหอออออออออัออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Desenvolvedor ณ Andre Rodrigues        บ Empresa ณ Oliminet/COEL                    บฑฑ
ฑฑฬอออออออออออออออุออออออออออออหออออออออัสออออออหออฯออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Linguagem     ณ eAdvpl     บ Versao ณ 8     บ Sistema ณ Microsiga                   บฑฑ
ฑฑฬอออออออออออออออุออออออออออออสออออออออฯอออออออสอออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Modulo(s)     ณ                                                                     บฑฑ
ฑฑฬอออออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Tabela(s)     ณ SC6                                                                 บฑฑ
ฑฑศอออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
User Function Sema_PCP()
Local cNotas := ""          
Local cQuery := ""
Local aAreaAtu := GetArea()
Local aButtons	:= {}
Local nX			:= 0                                                                                                              
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsNewGetDados()      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Vetor responsavel pela montagem da aHeader
Local aCpoGDa       	:= {"C6_NUM","C6_ITEM","C6_PRODUTO","C6_DESCRI","C6_QTDVEN","C6_X_EMIS","C6_ENTREG","C6_X_ENTRE","A1_NREDUZ","C5_OS"}
// Vetor com os campos que poderao ser alterados                                                                                
Local aAlter       	:= {}         
Local nSuperior    	:= 030 //C(015)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= 002 //C(027)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= 290 //250       )      // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= 650 //C(632)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= 2 //GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinOk       	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                         // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                         // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cFieldOk     	:= "u_mgf16vlc()"    // Funcao executada na validacao do campo                                           
Local cSuperDel     := ""              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cDelOk        := "AllwaysTrue"   // Funcao executada para validar a exclusao de uma linha do aCols                   
// Objeto no qual a MsNewGetDados sera criada                                      
Local oWnd          := NIL                                                                                                  
Local aSize     	:= MsAdvSize( .F. )
Private aHead       := {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Private aCol        := {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
Private aCols
Private oDlg				// Dialog Principal
Private _cFilOri  	:= ""       
Private _cFilHan  	:= ""
Private oGetDados1
Private cPerg     	:= "MFAT16"           
Private lVai		:= .f.
Private aEstoque	:= {}
Private aCores 		:= {}
Private aLegenda 	:= {}


aLegenda:= {	{ "BR_VERDE"	,'Acima de 15 dias'		},;                     
                { "BR_VERMELHO"	,'Critico (Ate 7 dias)'	},;
                { "BR_AMARELO"	,'Atencao (de 8 a 15 dias)'	}}
                
                
xQuery	:= "select c6_filial,c6_num,c6_item,c6_produto,c6_descri,c6_qtdven,c6_qtdent,c6_x_emis,c6_entreg,c6_x_entre,c6_x_lipcp,sc6.r_e_c_n_o_ as controle,a1_nreduz"
xQuery	+= " from "+retSqlName("SC6")+" sc6 "
xQuery  += " inner join " + RetSQLName("SA1") + " ON a1_cod = c6_cli AND a1_loja = c6_loja"
xQuery	+= " where c6_x_entre='  ' and sc6.d_e_l_e_t_=' ' and c6_nota =' ' and c6_filial = '"+xFilial("SC6")+"'"       //and c6_qtdven > c6_qtdent -- eliminar faturados
xQuery	+= " order by c6_num,c6_item"
                                                      
IF Select("QRYSD2") > 0
	QRYSD2->( DbCloseArea() )
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,xQuery), 'QRYSD2', .F., .T.)         

AADD(aAlter,"C6_X_ENTRE")


// LEGENDA
Aadd(aHead,  {" ","LEGENDA", "@BMP",10,0,"","","C","","V","","","","V"})

// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                 
		Aadd(aHead,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		If alltrim(SX3->X3_CAMPO)=="C5_OS"
			aHead[len(aHead)][1] := "controle"
		Endif		
		If alltrim(SX3->X3_CAMPO)=="C6_X_ENTRE"
			aHead[len(aHead)][1] := "Data PCP"
		Endif
	Endif                                                                                                                         
Next nX                                                                                                                         

DbSelectArea("QRYSD2")
DbGoTop()
While ! Eof() 
	aAux := {}       
	
		cLegenda := ''

	If StoD(QRYSD2->C6_ENTREG)-ddatabase <= 7
		cLegenda := "BR_VERMELHO"

	ElseIf StoD(QRYSD2->C6_ENTREG)-ddatabase >= 8 .And.  StoD(QRYSD2->C6_ENTREG)-ddatabase <= 15
		cLegenda := "BR_AMARELO"

	ElseIf StoD(QRYSD2->C6_ENTREG)-ddatabase >= 16
		cLegenda := "BR_VERDE"

	EndIf        
	
	Aadd(aAux, cLegenda ) 
	                   
	Aadd(aAux,QRYSD2->C6_NUM)
	Aadd(aAux,QRYSD2->C6_ITEM)
	Aadd(aAux,QRYSD2->C6_PRODUTO)
	Aadd(aAux,QRYSD2->C6_DESCRI)
	Aadd(aAux,QRYSD2->C6_QTDVEN)	
	Aadd(aAux,stod(QRYSD2->C6_X_EMIS))
	Aadd(aAux,stod(QRYSD2->C6_ENTREG))
	Aadd(aAux,stod(QRYSD2->C6_X_ENTRE))        
	Aadd(aAux,QRYSD2->A1_NREDUZ)
	Aadd(aAux,QRYSD2->controle)
	Aadd(aAux,.F.)                      
	Aadd(aCol,aAux)

	DbSkip(+1)
END

IF Select("QRYSD2") > 0
	QRYSD2->( DbCloseArea() )         
Endif


//aadd(aButtons,{"DBG06"		,{ || Processa({ || VerNota(oGetDados1:aCols)}) 	},"Recalculo"			,"Recalculo"})
//aadd(aButtons,{"RELATORIO"	,{ || Processa({ || Emite()}) 	},"Gera Planilha","Planilha"})

Aadd(aButtons,{ "Legenda"	,'BrwLegenda("Legenda Status","Status ",aLegenda)', 'Legenda', 'Legenda' })

DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] TITLE "Programacao de PCP" OF oMainWnd PIXEL

oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||lvai:=.t.,Vai(),oDlg:End()},{||oDlg:End()},,aButtons)

RestArea( aAreaAtu )
Return Nil   
             

/*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษอออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
//ฑฑบ Funo    ณ Finalizacao                                               บฑฑ
//ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ Descrio ณ Processamento de gravacao da data fabrica                 บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Vai()
Processa({ || ProcPedidos() },"Programacao PCP..." ) 
Return

Static Function ProcPedidos()
Local xY, x   

Local nPosDatFab    := aScan( aHead ,{ |x| alltrim(x[2]) == "C6_X_ENTRE"})
//Local nPosLipcp     := aScan( aHead ,{ |x| alltrim(x[2]) == "C6_X_LIPCP"})
Local nPosContro	:= aScan( aHead ,{ |x| alltrim(x[2]) == "C5_OS"})

ProcRegua(len(aCol)+1)

For x:=1 to len(aCol)
	IncProc("Liberando pedidos para programacao...")
	
	xxRecno	:= aCol[x,nPosContro]
	xxDatEntreg  := "" 
	xxDatFabrica := oGetDados1:aCols[x,nPosDatFab]  
 	
	IF !Empty(xxDatFabrica)
		DbSelectArea("SC6")
		DbGoTo(xxRecno)
			// -- Guarda data de entrega anterior
			xxDatEntreg  := SC6->C6_ENTREG
			// -- Grava data da Fabrica
			RecLock("SC6",.f.)
		    	SC6->C6_X_ENTRE := xxDatEntreg  // Data original colocada por vendas
		    	SC6->C6_ENTREG  := xxDatFabrica // Data indicada pelo PCP
		    	SC6->C6_X_DT1   := xxDatFabrica // Primeira alteracao da data do PCP    
		    	SC6->C6_X_DTDIG := dDatabase    // Data da digitacao
			MsUnLock()                
			
			_NumPed := SC6->C6_NUM
			_NumItem:= SC6->C6_ITEM
			           
				DbSelectArea("ZX1")
				 RecLock("ZX1",.T.)  
		        	ZX1->ZX1_FILIAL := xFilial()				 
		        	ZX1->ZX1_PEDIDO := SC6->C6_NUM  // Data original colocada por vendas
		        	ZX1->ZX1_ITEM   := SC6->C6_ITEM // Data indicada pelo PCP
		         	ZX1->ZX1_PRODUT := SC6->C6_PRODUTO // Primeira alteracao da data do PCP    
		        	ZX1->ZX1_DTNEW  := xxDatFabrica // Data indicada pelo PCP
		        	ZX1->ZX1_DTOLD  := xxDatEntreg  // Data original colocada por vendas
		        	ZX1->ZX1_HORA   := Time()       // Data da digitacao
		        	ZX1->ZX1_DTBASE := dDatabase    // Data da digitacao
		        	ZX1->ZX1_USUARI := UsrFullName(__cUserID)        // Data da digitacao		
		        	ZX1->ZX1_ORIGEM := "SEMAFORO"   // Data da digitacao
		        	ZX1->ZX1_EMISSA := SC6->C6_X_EMIS    // Data da digitacao 
		        	ZX1->ZX1_CLIENT := SC6->C6_CLI    // Data da digitacao		
		        	ZX1->ZX1_LOJA   := SC6->C6_LOJA   // Data da digitacao        	        			        			        			        	
			     MsUnLock()    
	 		WF_Pedidos()
	Endif   
	
Next 

Return

Static Function WF_Pedidos()

Local  c_Alias := ALIAS()
Local  aItens  := {}
Local  xOrdProd :=""
Local cCodUser  :=retcodusr()


	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+_NumPed+_NumItem)       

        	
 //		DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==_NumPed
		
			xProduto := LEFT(SC6->C6_PRODUTO,21)
			xProduto := STRTRAN(xProduto," ","_")
			xDescri  := RTRIM(LEFT(SC6->C6_DESCRI,30))
			nLenDsc  := Len(xDescri)
			xDescri  := xDescri+Replicate("_",30-nLenDsc)
			xQuant   := TRANSF(SC6->C6_QTDVEN,"@E 99999")
			xQuant   := STRTRAN(xQuant," ","_")
			xVUnit   := TRANSF(SC6->C6_PRCVEN,"@E 99,999.9999")
			xVUnit   := STRTRAN(xVUnit," ","_")
			iF !EMPTY(SC6->C6_OP)  
				xOrdProd := xOrdProd +SC6->C6_NUMOP+SC6->C6_ITEM+"\"
				AADD(aItens , SC6->C6_ITEM+"___"+xProduto+xDescri+"__"+xQuant+"__"+xVUnit+"__"+DTOC(SC6->C6_ENTREG)+"__"+SC6->C6_NUMOP+SC6->C6_ITEM )
			Elseif DateDiffDay( dDataBase, SC6->C6_ENTREG ) > 8
				AADD(aItens , SC6->C6_ITEM+"___"+xProduto+xDescri+"__"+xQuant+"__"+xVUnit+"__"+DTOC(SC6->C6_ENTREG))
			Endif	
 //			dbSkip()
		
 //		ENDDO
	Endif	
	////
	////Envia e-mail p/o responsavel da liberacao da regra
	////
	
	IF ( Len(aItens) > 0 )
//		If !cCodUser $("000227/000272") 
			IF ( f_email(aItens,xOrdProd) )
				//MsgInfo("Pedido de Venda Alterado por .")
			ELSE
				MsgInfo("Pedido de Venda Alterado mas com problema no envio do e-mail. Favor verificar o link de internet.")
			ENDIF
 //		Endif
	ENDIF
		
dbSelectArea(c_Alias)

Return

////////////////////////////////////////////////////
Static Function f_email(aItens,xOrdProd)
////////////////////////////////////////////////////   

Local cmServer  := GETMV("MV_RELSERV") //"SMTP.OLIMINET.COM.BR" 
Local cmAccount := GETMV("MV_RELACNT") //"ANDRE@OLIMINET.COM.BR"
Local cmPassw   := GETMV("MV_RELAPSW") //"perkadre0985"
//Local cMail01	:= SUPERGETMV("MV_ALTPD01",,"teddy.pereira@coel.com.br;francisco.silva@coel.com.br;dora@coel.com.br;guilherme.borcato@coel.com.br;brandao@coel.com.br")
//Local cMail02	:= SUPERGETMV("MV_ALTPD02",,"evaldo.marques@coel.com.br;marineide.franca@coel.com.br;guilherme.borcato@coel.com.br;brandao@coel.com.br")               
Local cMail01	:= "" //"rogerio@oliminet.com.br"
Local cMail02	:= "" //"rogerio@oliminet.com.br"
Local cmSubject := "Atualizacao do Semaforo - PV No.: "+_NumPed+"-"+_NumItem
Local cLista    := ""
Local cEmpresa  := SM0->M0_CODIGO+SM0->M0_CODFIL
Local lConectou
Local lEnviado
Local lDesConect
Local cUser		:=UsrFullName(__cUserID)

_aClAtend   := GetAdvFVal("SC5","C5_CLATEND",xFilial("SC5")+_NumPed,1)   
_aClNome    := GetAdvFVal("SC5","C5_CLNOMCL",xFilial("SC5")+_NumPed,1)  
                                                
DbSelectArea("SZK")
DbSetOrder(1)
If DbSeek(xFilial("SZK")+_aClAtend)
   cMail01:= SZK->ZK_EMAIL
Else
   cMail01:= "cleia.nogueira@coel.com.br"
EndIf



//cxPara :=IIF(cEmpresa=="0301",cMail01,cMail02)
cxPara := cMail01
cxCC   := "rbosp@terra.com.br;cleia.nogueira@coel.com.br;brandao@coel.com.br;luciano.piraino@coel.com.br;alexandra.araujo@coel.com.br"
cmBody := "<html>"+chr(13)+chr(10)
cmBody += "<body>"+chr(13)+chr(10)
cmBody += "Pedido Alterado por :"+"<b>"+cUser+"</b>"+chr(13)+chr(10)
cmBody += "Empresa: "+IIF(cEmpresa=="0301","Coelmatic/Manaus",IIF(cEmpresa=="0302","Coelmatic/Sใo Paulo",RTRIM(SM0->M0_NOME)))+" ===> PV No.: "+_NumPed+"-"+_NumItem+"  ===> CLIENTE: "+RTRIM(_aClNome)+chr(13)+chr(10)
cmBody += "========================================================================================="+chr(13)+chr(10)
cmBody += "Itm__Produto..............................................................................................___Quant.____Prc.Unit.__Entrega____OP"+chr(13)+chr(10)
cmBody += "========================================================================================="+chr(13)+chr(10)
***                 1         2         3         4         5         6         7         8 
***        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
***        xx   x------------------x x----------------------------x    99999  99,999.9999  99/99/99

For ix:=1 To Len(aItens)
	 cmBody += aItens[ix]+chr(13)+chr(10)
Next
cmBody += chr(13)+chr(10)
If len(xOrdProd)>0
	cmBody += " <b>Ja existem ordens de produ็ใo para esse pedido, favor verificar as OPดs : </b>"+"<b>"+xOrdProd+"</b>"
//Else
//	cmBody += "<b>Pedido com data de emissใo superior a 8 dias foi alterado. </b>"
Endif
cmBody += "<p>"
cmBody += "</body>"
cmBody += "</html>"

CONNECT SMTP SERVER cmServer ;
		  ACCOUNT  cmAccount   ;
		  PASSWORD cmPassw     ;
		  Result lConectou

IF ( lConectou )

	lConectou := MailAuth(cmAccount, cmPassw)
	
	If !lConectou
		MsgAlert("[Error] Falha de conexใo.")
		Return .F.
	Endif	

	SEND MAIL FROM cmAccount TO cxPara  ;
				 CC cxCC                   ;
				 SUBJECT cmSubject         ;
				 BODY cmBody               ;
				 ATTACHMENT cLista         ;
				 RESULT lEnviado

	IF ( !lEnviado )
		MsgAlert("** Falha ao enviar. Favor verificar se houve falha de conexใo com a Internet. Se houve e normalizou, favor re-enviar a lista.")
		Return .F.
	ENDIF

ELSE
	///
	///Extrai o resultado envio
	///
	GET MAIL ERROR cmMsgErr
	///
	///Informa a mensagem de envio para o usuario
	///
	MsgAlert( "** Erro ao enviar o e-mail. Motivo: "+cmMsgErr )
	Return .F.
ENDIF
///
///Disconecta o servidor de SMTP
///
DISCONNECT SMTP SERVER Result lDesConect

Return .T.