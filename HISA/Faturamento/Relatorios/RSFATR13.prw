#INCLUDE "PROTHEUS.CH"       
#include "rwmake.ch" 
#include "font.ch"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RSFATR13   ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 05/10/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de Pedido de Vendas.                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function RSFATR13()
//Local nLinhaItem
//Local cObs      := ""
//Local nTotalz   := 0
Local aAreaSC6  := SC6->(GetArea())     
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSA5	:= SA5->(GetArea())   
Local aAreaSA4	:= SA4->(GetArea())   
Local aAreaSF4	:= SF4->(GetArea())
//Local aTipo	    :={'T','P'}

Private cPedido := SC5->C5_NUM
Private nTipo   := 1

DEFINE MSDIALOG oJanela FROM  96, 041 TO 297,442 TITLE OemToAnsi('Gerar o relatório') PIXEL
@ 2,6 To 71,184 Title OemToAnsi("Considerar:")
@ 021,020 RADIO oTipo VAR nTipo ITEMS "Todos os itens","Somente os itens pendentes" SIZE 90,10 OF oJanela
@ 076,065 Button OemToAnsi("Ok")  Size 53,16 Action (oJanela:End())
@ 076,131 Button OemToAnsi("Sair")  Size 53,16 Action (oJanela:End())

Activate Dialog oJanela CENTERED	


Processa({ |lEnd| xPrintRl(),OemToAnsi('Gerando o relatório.')}, OemToAnsi('Aguarde...'))

RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aAreaSA4)
RestArea(aAreaSA5)
RestArea(aAreaSF4)

Return


Static Function xPrintRl()
Local _nT

Private oPrn  := TMSPrinter():New( 'Pedido de Vendas'),;
		oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP',;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma' ,09,09,,.F.,,,,.T.,.F.),;
		oFont09n	:= TFont():New('Courier New',09,09,,.T.,,,,.T.,.F.),;		
		oFont10		:= TFont():New('Calibri',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Calibri',11,11,,.F.,,,,.T.,.F.),;
		oFont11N	:= TFont():New('Calibri',11,11,,.T.,,,,.T.,.F.),;				
		oFont101N	:= TFont():New('Calibri',10,10,,.T.,,,,.T.,.F.),;				
		oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),; 
		oFont12a	:= TFont():New('Tahoma',10,10,,.T.,,,,.T.,.F.),; 
		oFont12n	:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;		
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Tahoma',18,18,,.T.,,,,.T.,.F.),;
		oFont16		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
    	oFont16N	:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
		oFont20		:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)




Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
		_nValMerc 	:= 0,;		// Valor das mercadorias
		_nValTotal 	:= 0,;		// Valor Total sem desconto
		_nValIPI	:= 0,;		// Valor do I.P.I.
		_nValDesc	:= 0,;		// Valor de Desconto
		_nValISS    := 0,;      // Valor do ISS 
		_nTotAcr	:= 0,;		// Valor total de acrescimo
		_nTotSeg	:= 0,;		// Valor de Seguro
		_nTotFre	:= 0,;		// Valor de Frete
		_nTotIcmsRet:= 0,;		// Valor do ICMS Retido    
		_nValImposto:= 0,;		// Valor do Imposto
		lPrintDesTab:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)		
		_nPerDesc   := 0,;      // Percentual de Desconto
		lFlag		:= .t.,;	// Controla a impressao do fornecedor
		nLinVer     := 0,;
		nLinBak     := 0,;
        nLinhaItem  := 0,;
        nIndeniza   := 0,;
        cUsuario    := "",;
        aAprovador  := {},;
        lLiber      := .F.,;
		nLinha		:= 2500  	// Controla a linha por extenso

DEFINE FONT oFont102 NAME "Courier New" SIZE 0,09 Bold     OF oPrn

oPrn:SetPortrait() // Estilo retrato      
oPrn:SetPaperSize(9)                                 // Tamanho A4

_cQuery :=" SELECT C5_FILIAL, C5_NUM,C5_EMISSAO, C5_CLIENTE,C5_LOJACLI,C5_CONDPAG,C5_TABELA, C5_PDESCAB,C5_VEND1,C6_ITEM,C6_PRODUTO,C6_UM,C6_DESCRI,C6_PRUNIT, "
if nTipo = 2 //Pendentes
   _cQuery +=" C6_QTDVEN-C6_QTDENT C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_PRUNIT,C6_ENTREG,C5_TRANSP,C5_TIPO "
else                                                                                                   
   _cQuery +=" C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_PRUNIT,C6_ENTREG,C5_TRANSP,C5_TIPO "
endif
_cQuery +=" FROM "+ RetSqlName("SC5")+" SC5, "+ RetSqlName("SC6")+" SC6 "
_cQuery +=" WHERE SC5.D_E_L_E_T_ = ''  AND SC6.D_E_L_E_T_ = '' "
_cQuery +=" AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
_cQuery +=" AND C5_FILIAL   = '"+XFILIAL("SC5")+"'"
if nTipo = 2 //Pendentes
   _cQuery +=" AND C6_QTDVEN <> C6_QTDENT "
endif
_cQuery +=" AND C5_NUM = '"+cPedido+"' "
_cQuery +=" ORDER BY C5_FILIAL,C5_NUM,C6_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TRA",.T.,.F.)

TcSetField('TRA','C5_EMISSAO','D')
TcSetField('TRA','C6_ENTREG','D')

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

DbSelectArea('TRA')
Count to _nQtdReg
ProcRegua(_nQtdReg)
TRA->(DbGoTop())

While TRA->( ! Eof() )
   	  _nValMerc   := 0
	  _nValDesc	  := 0
	  _nValTotal 	:= 0
	  nIndeniza   := 0
	  _nPerDesc   := 0
	  nLinha	  := 2900
      nItem       := 1
      ndItem      := 1
      cNum        := TRA->C5_NUM
      cObserv     := ""      
      aObs        := {} 
      *
      While TRA->C5_NUM == cNum	
	
	        cVerPag()     
	        
            IF ( lFlag )

	          nLinVer1 := 0
	          oPrn:Box(200,50,1000,2350)// Caixa Pricipal do cabeçalho
	          oPrn:Say(60,1000,"PEDIDO DE VENDAS",OFONT16N,,,,3)           
	          //             L     C                 L    C
	          oPrn:SayBitmap(210, 160, "lgrl01.bmp",430, 440)

	          oPrn:Say(210,805,SM0->M0_NOME,OFONT11N,,,,3)
		       oPrn:Say(250,805,ALLTRIM(SM0->M0_ENDCOB) + " - " +ALLTRIM(SM0->M0_BAIRCOB) +"- CEP "+TRANSFORM(ALLTRIM(SM0->M0_CEPCOB),"@R 99999-999"),OFONT10,,,,3)
		       oPrn:Say(290,805,"CNPJ: "+SubStr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+SubStr(SM0->M0_CGC,6,7)+"-"+SubStr(SM0->M0_CGC,13,2)+" - Insc. Estadual: "+SM0->M0_INSC,OFONT10,,,,3)
		       oPrn:Say(330,805,"Telefone:("+StrZero(Val(SubStr(SM0->M0_TEL,1,4)),2)+") "+SubStr(SM0->M0_TEL,5,Len(SM0->M0_TEL))+" Fax:("+StrZero(Val(SubStr(SM0->M0_FAX,1,4)),2)+") "+SubStr(SM0->M0_FAX,5,Len(SM0->M0_FAX)),OFONT10,,,,3)
  		       oPrn:Say(370,805,"Inscrição Municipal: n. "+ ALLTRIM(SM0->M0_INSCM) + Space(2) + ALLTRIM(SM0->M0_CIDCOB) + "-" + ALLTRIM(SM0->M0_ESTCOB),OFONT10,,,,3)             
   

	          oPrn:Line(nLinVer1 += 200,1920,650,1920)
	          oPrn:Line(nLinVer1, 720,650, 720)
	          oPrn:Say(nLinVer1 += 20,2070,"PEDIDO",OFONT13,,,,3)
	          oPrn:Say(nLinVer1 += 80,2070,TRA->C5_NUM,OFONT16,,,,3)
	          oPrn:Line(nLinVer1 += 80,1920,nLinVer1,2350)//LINHA
	          oPrn:Say(nLinVer1 += 50,2070,"DATA",OFONT13,,,,3)
	          oPrn:Say(nLinVer1 += 80,2020,cValToChar(TRA->C5_EMISSAO),OFONT16,,,,3)
	          oPrn:Line(nLinVer1 += 140,50,nLinVer1,2350)
	          *
	          if TRA->C5_TIPO $ 'D|B'
	             DbSelectArea('SA2')
	             SA2->(DbSetOrder(1))
	             SA2->(DbSeek(xFilial('SA2')+TRA->(C5_CLIENTE+C5_LOJACLI)))
	             cCodCli   := ALLTRIM(SA2->A2_COD)
	             cCodLoja  := SA2->A2_LOJA
	             cCliNome  := ALLTRIM(SA2->A2_NOME) 
	             cTelefone := SA2->A2_TEL
	             cCGC      := SA2->A2_CGC   
	             cEndereco := ALLTRIM(SA2->A2_END)
	             cCidade   := ALLTRIM(SA2->A2_MUN)
	             cEst      := ALLTRIM(SA2->A2_EST)
              else
	             DbSelectArea('SA1')
	             SA1->(DbSetOrder(1))
	             SA1->(DbSeek(xFilial('SA1')+TRA->(C5_CLIENTE+C5_LOJACLI)))
	             cCodCli   := ALLTRIM(SA1->A1_COD)
	             cCodLoja  := SA1->A1_LOJA
	             cCliNome  := ALLTRIM(SA1->A1_NOME) 
	             cTelefone := SA1->A1_TEL
	             cCGC      := SA1->A1_CGC
	             cEndereco := ALLTRIM(SA1->A1_END)
	             cCidade   := ALLTRIM(SA1->A1_MUN)
	             cEst      := ALLTRIM(SA1->A1_EST)	             
	          EndIf
              *
              oPrn:Line(nLinVer1,400 ,nLinVer1+350 ,400)                        //COLUNA APÓS COD/CLIENTE
              *
	          oPrn:Say(nLinVer1 += 20,70,"CLIENTE ",OFONT11N,,,,3)
	          oPrn:Say(nLinVer1,430,cCodCli+"-"+cCodLoja+"   "+cCliNome,OFONT11,,,,3)
	          oPrn:Line(nLinVer1 += 50,50,nLinVer1,2350)
              oPrn:Line(nLinVer1,1600,nLinVer1+280 ,1600)              //COLUNA APÓS DADOS DO CLIENTE
              oPrn:Line(nLinVer1,1850,nLinVer1+280 ,1850)              //COLUNA APÓS CNPJ	          
	          *
	          oPrn:Say(nLinVer1 += 20,70,"ENDERECO",OFONT11N,,,,3)
	          oPrn:Say(nLinVer1,430,cEndereco,OFONT11,,,,3)
	          if SA1->A1_PESSOA = 'J'
	             oPrn:Say(nLinVer1 ,1630,"CNPJ"    ,OFONT11N,,,,3)                           
                 oPrn:Say(nLinVer1,1900,Transform(cCGC,"@r 99.999.999/9999-99"),OFONT10,,,,3)	          
              else
	             oPrn:Say(nLinVer1 ,1630,"CPF"    ,OFONT11N,,,,3)                           
                 oPrn:Say(nLinVer1,1900,Transform(cCGC,"@r 999.999.999-99"),OFONT10,,,,3)	                        
              endif
	          oPrn:Line(nLinVer1 += 50,50,nLinVer1,2350)
	          *
	          oPrn:Say(nLinVer1 += 20,70,"PAGAMENTO",OFONT11N,,,,3)
	          SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+TRA->C5_CONDPAG))
	          oPrn:Say(nLinVer1,430,ALLTRIM(SE4->E4_DESCRI),OFONT11,,,,3)	          
   	          oPrn:Say(nLinVer1 ,1630,"CIDADE"    ,OFONT11N,,,,3)                           
              oPrn:Say(nLinVer1,1900,cCidade+"-"+cEst,OFONT10,,,,3)
	          oPrn:Line(nLinVer1 += 50,50,nLinVer1,2350)
	          *
	          oPrn:Say(nLinVer1 += 20,70,"TELEFONE",OFONT11N,,,,3)
	          oPrn:Say(nLinVer1,430,cTelefone,OFONT11,,,,3)
   	          oPrn:Say(nLinVer1,1630,"VENDEDOR",OFONT11N,,,,3)
	          oPrn:Say(nLinVer1,1900,ALLTRIM(TRA->C5_VEND1)+"-"+Posicione("SA3",1,XFILIAL("SA3")+TRA->C5_VEND1,"A3_NOME"),OFONT11,,,,3)
	          oPrn:Line(nLinVer1 += 50,50,nLinVer1,2350)
	          *	          
  	          oPrn:Say(nLinVer1 += 20,70,"TRANSPORTE",OFONT11N,,,,3)
	          SA4->(dbSetOrder(1), dbSeek(xFilial("SA4")+TRA->C5_TRANSP))
	          oPrn:Say(nLinVer1,430,ALLTRIM(SA4->A4_NOME),OFONT11,,,,3)	          
	          oPrn:Line(nLinVer1 += 50,50,nLinVer1,2350)
	          lFlag := .f.
           endif
	        
	        If	( lPrintDesTab )
				*
				nLinha := nLinVer1+70
				oPrn:Line(nLinha,50,nLinha,2350)	
				oPrn:Line(nLinha,50,nLinha + 60,50)
			   oPrn:Line(nLinha,150,nLinha + 60,150)
			   oPrn:Line(nLinha,370,nLinha + 60,370)
			   oPrn:Line(nLinha,1145,nLinha + 60,1145)
        		oPrn:Line(nLinha,1270,nLinha + 60,1270)
        		oPrn:Line(nLinha,1550,nLinha + 60,1550)
        		oPrn:Line(nLinha,1900,nLinha + 60,1900)
        		oPrn:Line(nLinha,2160,nLinha + 60,2160)
        		oPrn:Line(nLinha,2350,nLinha + 60,2350)
     			*
            //Quadro de Itens
            oPrn:Say(nLinha,60   ,"Item"     ,OFONT101N,,,,3)
            oPrn:Say(nLinha,220  ,"Codigo"   ,OFONT101N,,,,3)
            oPrn:Say(nLinha,659  ,"Descrição",OFONT101N,,,,3)
            oPrn:Say(nLinha,1165 ,"Unid."    ,OFONT101N,,,,3)
            oPrn:Say(nLinha,1290 ,"Qtde."    ,OFONT101N,,,,3)
            oPrn:Say(nLinha,1670 ,"Pr. Unit" ,OFONT101N,,,,3)
            oPrn:Say(nLinha,1980 ,"Pr. Total",OFONT101N,,,,3)					
            oPrn:Say(nLinha,2170 ,"Dt. Entrega",OFONT101N,,,,3)
            lPrintDesTab := .f.
				nLinha += 70
				oPrn:Line(nLinha,50,nLinha,2350)	
			EndIf 
         oPrn:Line(nLinha,50,nLinha,2350)	
			oPrn:Line(nLinha,50,nLinha + 60,50)
			oPrn:Line(nLinha,150,nLinha + 60,150)
			oPrn:Line(nLinha,370,nLinha + 60,370)
			oPrn:Line(nLinha,1145,nLinha + 60,1145)
        	oPrn:Line(nLinha,1270,nLinha + 60,1270)
        	oPrn:Line(nLinha,1550,nLinha + 60,1550)
        	oPrn:Line(nLinha,1900,nLinha + 60,1900)
        	oPrn:Line(nLinha,2160,nLinha + 60,2160)
        	oPrn:Line(nLinha,2350,nLinha + 60,2350)
         *	        
	      oPrn:Say(nLinha,60  ,ALLTRIM(STR(nItem)),OFONT12,,,,3)
	      oPrn:Say(nLinha,160 ,ALLTRIM(TRA->C6_PRODUTO),OFONT10,,,,3)
        	oPrn:Say(nLinha,1165 ,ALLTRIM(TRA->C6_UM),OFONT10,,,,3)
        	oPrn:Say(nLinha,1320 ,Transform(TRA->C6_QTDVEN,"@E 999999.99"),OFONT102,,,,3)
        	oPrn:Say(nLinha,1440,Transform(TRA->C6_PRCVEN, "@E 9,999,999,999.99999"),OFONT102,,,,3)
        	oPrn:Say(nLinha,1870,Transform(TRA->C6_VALOR, "@E 999,999,999.99"),OFONT102,,,,3)
         oPrn:Say(nLinha,2170,cValToChar(TRA->C6_ENTREG),OFONT10,,,,3)					
	      *
	      dbSelectArea("SB1")
	      dbSetOrder(1)
	      dbSeek(xFilial("SB1")+TRA->C6_PRODUTO)

	        cDesc := ALLTRIM(TRA->C6_DESCRI)
            *
     		if Len(cDesc) > 39
     		   _nLinhas := MlCount(cDesc,39)
			   For _nT := 1 To _nLinhas
			       oPrn:Line(nLinha,50,nLinha + 60,50)
			       oPrn:Line(nLinha,150,nLinha + 60,150)
			       oPrn:Line(nLinha,370,nLinha + 60,370)
			       oPrn:Line(nLinha,1145,nLinha + 60,1145)
        	       oPrn:Line(nLinha,1270,nLinha + 60,1270)
        	       oPrn:Line(nLinha,1550,nLinha + 60,1550)
        	       oPrn:Line(nLinha,1900,nLinha + 60,1900)
        	       oPrn:Line(nLinha,2160,nLinha + 60,2160)
        	       oPrn:Line(nLinha,2350,nLinha + 60,2350)
           	    oPrn:Say(nLinha, 380,MemoLine(cDesc,39,_nT),OFONT10,,,,3)
		          nLinha+=60
			   Next _nT      
            else 
               oPrn:Say(nLinha, 380,cDesc,OFONT10,,,,3)
               nLinha      += 60
            endif
            *        	
        	oPrn:Line(nLinha,50,nLinha,2350)	
        	nItem           += 1
        	ndItem          += 1        	
        	_nValMerc 		 += TRA->C6_VALOR   
			_nValTotal		 += ROUND(TRA->C6_QTDVEN*TRA->C6_PRUNIT,2)
			nIndeniza       := TRA->C5_PDESCAB
         IncProc()	
        	TRA->(DbSkip())
      EndDo
      nQtdItem := 1

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Imprime TOTAL DE MERCADORIAS³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      /*
   	  oPrn:Line(nLinha,790,nLinha+60,790)
	  oPrn:Say(nLinha+10,800,'Valor de Mercadorias ',oFont12)
	  oPrn:Say(nLinha+10,2080,"R$ "+TransForm(_nValMerc,'@E 9,999,999.99'),oFont13)   
	  oPrn:Line(nLinha,2430,nLinha + 60,2430)

	  nLinha += 60
	
	  cVerPag()
      */

	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Imprime TOTAL DE DESCONTO³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
     IF _nValTotal > 0 .and. _nValMerc <> _nValTotal
	      if nIndeniza > 0
	         _nValDesc := round(_nValMerc*nIndeniza/100,2)+(_nValTotal-_nValMerc)
	      endif 
	      if _nValDesc > 0 
			   oPrn:Line(nLinha,710,nLinha+60,710)
			   oPrn:Say(nLinha+10,720,'Valor de Desconto (-)',oFont12)
			   oPrn:Say(nLinha+10,1970,"R$ "+TransForm(_nValDesc,'@E 9,999,999.99'),oFont13)
			   oPrn:Line(nLinha,2350,nLinha + 60,2350)
			   nLinha += 60
			endif
	  EndIf

	  cVerPag()


	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Imprime o VALOR TOTAL !³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      oPrn:Line(nLinha,710,nLinha,2350)
      oPrn:Line(nLinha,710,nLinha+60,710)
	  oPrn:Say(nLinha+10,720,'VALOR TOTAL ',oFont12)
	  oPrn:Say(nLinha+10,1970,"R$ "+TransForm(_nValMerc - _nValDesc ,'@E 9,999,999.99'),oFont13)
	  oPrn:Line(nLinha,2350,nLinha+60,2350)
	  nLinha += 60
	  oPrn:Line(nLinha,710,nLinha,2350)
	  nLinha += 60


	  cVerPag()
     
ENDDO
TRA->(DbCloseArea()) 
oPrn:EndPage()     // Finaliza a página
oPrn:Preview()     // Visualiza antes de imprimir
Return

Static Function cVerPag()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia a montagem da impressao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	( nLinha >= 2900 )

		If	( ! lFlag )
			oPrn:EndPage()
			nLinha:= 800
		Else
			nLinha:= 800
		EndIf

		oPrn:StartPage()
		lFlag        := .T.
		lPrintDesTab := .T.

	EndIf
	

Return
