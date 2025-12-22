#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
                            

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HISLOTE    ¦ Autor ¦Orismar Silva         ¦ Data ¦ 08/11/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Rotina para permitir transferir lote(s) bloqueados.          ¦¦¦
¦¦¦           ¦ (SDD, SB8 e SBF)                                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/    


User Function HISLOTE()

Local cDoc           := SC6->C6_NUM
//Local cQuebra        := Chr(13) + Chr(10)	

Private lPrdSaldo    := .F.       //Flag para informar se M.P. não tem saldo 
Private aCampos      := {}
Private oMSNewGe1
Private n            := 1
Private aHeader      := {}
Private lQuant       := .T.
Private aProduto     := {}
Private aDados       := {}
Private aProdPlaca   := {}
Private lSit         := .T. 
Private lAplic       := .T.               
Private cFilAtu      := SM0->M0_CODFIL        
PRIVATE l241         :=.T.
PRIVATE l242         :=.T.
Private lPyme        := If(Type("__lPyme") <> "U",__lPyme,.F.)
Private cod          := AScan(aHeader,{|x|AllTrim(x[2])=="C6_PRODUTO"})
Private Descri       := AScan(aHeader,{|x|AllTrim(x[2])=="C6_DESCRI"})
Private cLote        := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LOTECTL"})
Private cNfori       := AScan(aHeader,{|x|AllTrim(x[2])=="C6_NFORI"})
Private cSerie       := AScan(aHeader,{|x|AllTrim(x[2])=="C6_SERIORI"}) 
Private dA261Data    := dDataBase
Private lAutoma261   := .T.

DEFINE FONT oFnt  NAME "Arial" Size 10,17
DEFINE FONT oFnt2 NAME "Arial" Size 10,11
DEFINE FONT oFnt3 NAME "Arial" Size 10,12
DEFINE FONT oFnt4 NAME "Arial" Size 10,34


                              	
@ 192,291 To 589,1300 Dialog odlg1 Title OemToAnsi("Incluir o Lote")

@ 05,13  Say OemToAnsi("Pedido:") Size 80,8
//@ 15,13  Say OemToAnsi("Produto:") Size 80,8
//@ 25,13  Say OemToAnsi("Quantidade:") Size 80,8
   
@ 05,70  Say oDoc    Var cDoc   Size 190,8 COLOR CLR_BLUE PIXEL OF oDlg1 FONT oFnt3
      
YMSNEWGET()    

@ 170,13  Say OemToAnsi("Total de Itens:")       Size 80,8 COLOR CLR_BLUE PIXEL OF oDlg1 FONT oFnt3
@ 170,80  Say TRANSFORM(Len(aDados),"@R 99999")  Size 80,8 COLOR CLR_RED PIXEL OF oDlg1 FONT oFnt3
@ 170,310 Button OemToAnsi("Gravar") Size 66,16 PIXEL ACTION FPROSC2()
@ 170,410 Button OemToAnsi("Fechar") Size 66,16 PIXEL ACTION oDlg1:End()

Activate Dialog odlg1 CENTER

*
Return            

//------------------------------------------------
Static Function YMSNEWGET()
//------------------------------------------------
Local aEdit 		:= {"C6_LOTECTL"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do AHeader (Inclus„o)       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}

aTam := TamSX3('C6_PRODUTO'); Aadd(aHeader, {"Produto"        , 'C6_PRODUTO'	, PesqPict('SC6', 'C6_PRODUTO', aTam[1]         ), aTam[1], aTam[2], '' , USADO, 'C', 'SC6', ''}) 
aTam := TamSX3('C6_DESCRI' ); Aadd(aHeader, {"Descrição"      , 'C6_DESCRI' 	, PesqPict('SC6', 'C6_DESCRI' , aTam[1]         ), aTam[1], aTam[2], '' , USADO, 'C', 'SC6', ''}) 
aTam := TamSX3('C6_LOTECTL'); Aadd(aHeader, {"Lote"           , 'C6_LOTECTL'  	, PesqPict('SC6', 'C6_LOTECTL', aTam[1]         ), aTam[1], aTam[2], '' , USADO, 'C', 'SC6', ''}) 
aTam := TamSX3('C6_NFORI'  ); Aadd(aHeader, {"Nota Origem"    , 'C6_NFORI'  	, PesqPict('SC6', 'C6_NFORI'  , aTam[1]         ), aTam[1], aTam[2], '' , USADO, 'C', 'SC6', ''}) 
aTam := TamSX3('C6_SERIORI'); Aadd(aHeader, {"Serie"          , 'C6_SERIOR'	    , PesqPict('SC6', 'C6_SERIORI', aTam[1]         ), aTam[1], aTam[2], '' , USADO, 'C', 'SC6', ''}) 

Processa( {||PROCPROD() } , "Analisando os produtos...")

oMSNewGe1 := MSGetDados():New(036    , 008     , 144     , 490,3,'AllwaysTrue','AllwaysTrue','',,aEdit)
oMSNewGe1:ForceRefresh()
Return



/*
________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PROCPROD  ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 07/10/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para verificar o saldo das materias primas (MP).       ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function PROCPROD(CodMP,nQtdEst) 

    alert(Str(LEN(aCols)))

Return         

**************************
Static Function FPROSC2()
**************************
//Local  aMATA650  := {}
Local  cProduto  := ""
Local  cLocal    := ""
Local  nQuant    := 0
//Local  cOpPI     := ""
Local  aVetor    := {}
//Local  aSldPrd   := {}
//Local  dData     := dDataBase
//Local  nDecimal  := TamSX3("B2_CM1")[2]
//Local aVetor := {}          
Local ix
Private lMsErroAuto := .F.     
Private lGrvPrc  := .T.   


If MsgYesNo("Deseja realizar a transferência?" )
   For ix:=1 to Len(aCols)
       if !EMPTY(aCols[ix,8]) .AND. !EMPTY(aCols[ix,9]) .AND.  !EMPTY(aCols[ix,10]) .AND. !EMPTY(aCols[ix,11]) .AND. !EMPTY(aCols[ix,12])
          
          aVetor      := {}          
          lMsErroAuto := .F.
          //Faz a liberação do Lote para permitir a transferencia Mod. II
          *
          Begin Transaction 
          /*
          aVetor := {;
                    {"DD_DOC"    ,cDoc        ,NIL},;
                    {"DD_PRODUTO",aCols[ix,1] ,NIL},;
                    {"DD_QUANT"  ,aCols[ix,12],NIL}}

          MSExecAuto({|x, y| mata275(x, y)},aVetor, 4)  

          If lMsErroAuto                 
             Mostraerro()             
          Endif
          */
                dbSelectArea("SDD") 
                dbSetOrder(1)
                if dbSeek(xFilial("SDD")+cDoc+aCols[ix,1],.T.)
                   RecLock("SDD",.F.)
                   SDD->DD_QUANT   -= aCols[ix,12]
                   SDD->DD_SALDO   -= aCols[ix,12]
                   MsUnlock()                
                endif
                //BLOQUEAR O SALDOS DO LOTE
                dbSelectArea("SB8")  
                dbSetOrder(3)
                if dbSeek(xFilial("SB8")+aCols[ix,1]+aCols[ix,3]+aCols[ix,6],.T.)
                   RecLock("SB8",.F.)
                   SB8->B8_EMPENHO -= aCols[ix,12]
                   MsUnlock()
                endif       
                *
                //BLOQUEA O ENDEREÇO DO LOTE
                dbSelectArea("SBF") 
                dbSetOrder(1)//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
                if dbSeek(xFilial("SBF")+aCols[ix,3]+aCols[ix,5]+aCols[ix,1]+SPACE(20)+aCols[ix,6],.T.)
                   RecLock("SBF",.F.)
                   SBF->BF_EMPENHO -= aCols[ix,12]
                   MsUnlock()
                endif               
          
          *
          End Transaction
          *
          //Transferencia Mod. II
          cProduto    := aCols[ix,1]
          cLocal      := aCols[ix,3]
          nQuant      := aCols[ix,4]
          cLocaliz    := aDados[ix,5]
          cLocalNovo  := aCols[ix,5]
          cLoteNovo   := aCols[ix,6]      
          cLote       := aDados[ix,6]      
          lMsErroAuto := .F.

          //Begin Transaction
          //  .--------------------------
          // |     Cabecalho a Incluir
          //  '--------------------------
          aAuto := {}
          aAdd( aAuto , { NextNumero("SD3", 2, "D3_DOC", .T.), dDataBase}) // Cabecalho

          //  .----------------------
          // |     Itens a Incluir
          //  '----------------------
          dbSelectArea("SB1")
          dbSetOrder(1)
          SB1->(dbSeek(xFilial("SB1")+aCols[ix,1]))      

	      aItem := {}
	      aAdd( aItem, aCols[ix,1]                                 ) // D3_COD
	      aAdd( aItem, aCols[ix,2]                                 ) // D3_DESCRI
	      aAdd( aItem, SB1->B1_UM                                  ) // D3_UM
	      aAdd( aItem, aCols[ix,3]                                 ) // D3_LOCAL
	      aAdd( aItem, aCols[ix,5]                                 ) // D3_LOCALIZ
	      aAdd( aItem, aCols[ix,8]                                 ) // D3_COD
	      aAdd( aItem, aCols[ix,2]                                 ) // D3_DESCRI
	      aAdd( aItem, SB1->B1_UM                                  ) // D3_UM
	      aAdd( aItem, aCols[ix,9]                                 ) // D3_LOCAL
	      aAdd( aItem, aCols[ix,10]                                ) // D3_LOCALIZ
	      aAdd( aItem, ""                                          ) // D3_NUMSERI
	      aAdd( aItem, aCols[ix,6]                                 ) // D3_LOTECTL
	      aAdd( aItem, ""                                          ) // D3_NUMLOTE
	      aAdd( aItem, aCols[ix,7]                                 ) // D3_DTVALID (Lote)
	      aAdd( aItem, 0                                           ) // D3_POTENCI
	      aAdd( aItem, aCols[ix,12]                                ) // D3_QUANT
	      aAdd( aItem, 0                                           ) // D3_QTSEGUM
	      aAdd( aItem, ""                                          ) // D3_ESTORNO
	      aAdd( aItem, ""                                          ) // D3_NUMSEQ
	      aAdd( aItem, aCols[ix,11]                                ) // D3_LOTECTL DESTINO
	      aAdd( aItem, aCols[ix,13]                                ) // D3_DTVALID DESTINO
	      aAdd( aItem, ""                                          ) // D3_SERVIC
	      aAdd( aItem, ""                                          ) // D3_ITEMGRD
     
	      aAdd(aAuto,aItem)
          MSExecAuto({|x,y| MATA261(x,y)}, aAuto, 3)

          If lMsErroAuto
	         Mostraerro()
          endif          
          
          //End Transaction
          
          If MsgYesNo("Deseja realizar o bloqueio do lote?" )
                Begin Transaction
                //Faz o bloqueio do novo
                /*
                aVetor := {;                
                          {"DD_DOC" ,GETSXENUM("SDD","DD_DOC") ,NIL},;
                          {"DD_PRODUTO",aCols[ix,8] ,NIL},;
                          {"DD_LOCAL"  ,aCols[ix,9] ,NIL},;    
                          {"DD_LOTECTL",aCols[ix,11],NIL},;                        
                          {"DD_LOCALIZ",aCols[ix,10],NIL},;           
                          {"DD_QUANT"  ,aCols[ix,12],NIL},;
                          {"DD_MOTIVO" ,cMOTIVO     ,NIL},;
                          {"DD_OBSERVA",cOBSERVA    ,NIL}}                                               	       
       
                MSExecAuto({|x, y| mata275(x, y)},aVetor, 3)       

                If lMsErroAuto    
                   Mostraerro()
                endif
                */
                RecLock("SDD",.T.)
                SDD->DD_FILIAL  := XFILIAL("SDD")
                SDD->DD_DOC     := GETSXENUM("SDD","DD_DOC")
                SDD->DD_PRODUTO := aCols[ix,8]
                SDD->DD_LOCAL   := aCols[ix,9]
                SDD->DD_LOTECTL := aCols[ix,11]
                SDD->DD_DTVALID := aCols[ix,13]
                SDD->DD_LOCALIZ := aCols[ix,10]
                SDD->DD_QUANT   := aCols[ix,12]
                SDD->DD_SALDO   := aCols[ix,12]
                SDD->DD_QTDORIG := aCols[ix,12]
                SDD->DD_MOTIVO  := cMOTIVO
                SDD->DD_OBSERVA := cOBSERVA
                SDD->DD_XDTINCL := DDATABASE
                MsUnlock()                
                //BLOQUEAR O SALDOS DO LOTE
                dbSelectArea("SB8")  
                dbSetOrder(3)
                if dbSeek(xFilial("SB8")+aCols[ix,8]+aCols[ix,9]+aCols[ix,11],.T.)
                   RecLock("SB8",.F.)
                   SB8->B8_EMPENHO += aCols[ix,12]
                   MsUnlock()
                endif       
                *
                //BLOQUEA O ENDEREÇO DO LOTE
                dbSelectArea("SBF") 
                dbSetOrder(1)//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE                                                                                       
                if dbSeek(xFilial("SBF")+aCols[ix,9]+aCols[ix,10]+aCols[ix,8]+SPACE(20)+aCols[ix,11],.T.)
                   RecLock("SBF",.F.)
                   SBF->BF_EMPENHO += aCols[ix,12]
                   MsUnlock()
                endif               
                *    
                End Transaction                         	
          endif
       endif
   Next   
endif
oDlg1:End()            

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A261Locali³ Autor ³ Marcelo Pimentel      ³ Data ³ 30/01/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida as Localizacoes da transferencia                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A261Locali(ExpN1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Indica se e Origem / Destino                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA261                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function AYALocali(nOrigDest)

Local aArea      := { Alias()	, IndexOrd() , Recno() }
Local aSBEArea   := { 'SBE'	, SBE->(IndexOrd()) , SBE->(Recno()) }
Local lRet       := .T.
Local lContinua	 := .T.
Local cLocaliz   := &(ReadVar())

nOrigDest := If(nOrigDest==NIL,1,nOrigDest)

If ReadVar() # 'M->D3_LOCALIZ'
	lContinua := .F.
EndIf     

If lContinua
	If nOrigDest == 1
		If Empty(aCols[n,1]) .Or. Empty(aCols[n,3])//Produto .or. Armazém
			Help(' ',1,'MA260OBR')
			lRet:=.F.
		EndIf
		If lRet .And. !Localiza(aCols[n,1])
			&(ReadVar()) := Space(Len(&(ReadVar())))
		EndIf
	Else
		If Empty(aCols[n,8]) .Or. Empty(aCols[n,9])// Produto Destino .or. Armazém Destino
			Help(' ',1,'MA260OBR')
			lRet:=.F.
		EndIf                                                    
				
		If lRet .And. Localiza(aCols[n,8])// Produto Destino
			lRet:=ExistCpo('SBE',aCols[n,9]+cLocaliz) // Armazém Destino
			If lRet
				lRet:=ProdLocali(aCols[n,8],aCols[n,9],cLocaliz) // Produto Destino .or. Armazém Destino
			EndIf
		Else
			&(ReadVar()) := Space(Len(&(ReadVar())))
		EndIf
	EndIf
EndIf
//-- Retorna Integridade do Sistema
dbSelectArea(aSBEArea[1]); dbSetOrder(aSBEArea[2]); dbGoto(aSBEArea[3])
dbSelectArea(aArea[1]); dbSetOrder(aArea[2]); dbGoto(aArea[3])
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A261DtPot   ³Autor³Rodrigo de A. Sartorio³ Data ³ 19/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao para digitar a validade e potencia do Lote       ³±±
±±³          ³ corretamente                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A261DtPot(ExpN1)				                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Indica se valida 1 - Data de Validade 2 - Potencia ³±±
±±³          ³         3 - Data de Validade de Destino                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata240                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AYAMDtPot(nTipo)
LOCAL lRet      := .T.
LOCAL cCod		:= aCols[n,1]
LOCAL cLocal    := aCols[n,3]
LOCAL cLoteCtl  := aCols[n,6]
LOCAL cLote     := SPACE(6) //aCols[n,13]
LOCAL dDtValid  := If(nTipo==1,&(ReadVar()),aCols[n,7])
LOCAL nPotencia := 0 //If(nTipo==2,&(ReadVar()),aCols[n,15])
LOCAL cCodDest	:= aCols[n,8]
LOCAL cLoteDest	:= aCols[n,9]
LOCAL cLoteCtlD	:= aCols[n,11]
LOCAL dDtVldDest:= If(nTipo==3,&(ReadVar()),aCols[n,13])
LOCAL aAreaSB8  := SB8->(GetArea())
LOCAL cAlias    := Alias()

If nTipo == 3
	If !Rastro(cCodDest)
		Help(" ",1,"NAORASTRO")
		lRet:=.F.
	ElseIf !lAutoma261
		If !Rastro(cCod)
			If !Empty(cLoteCtlD)
				// Verifica se a data de validade pode ser utilizada
				dbSelectArea("SB8")
				dbSetOrder(3)
				If dbSeek(xFilial("SB8")+cCodDest+cLoteDest+cLoteCtlD) .And. SB8->B8_DTVALID # dDtVldDest
					HelpAutoma(" ",1,"A240DTVALI",,,,,,,,,.F.)
					&(ReadVar()):=SB8->B8_DTVALID
				EndIf
				RestArea(aAreaSB8)
			EndIf
		Else
			If (!Empty(cLoteCtl) .Or. !Empty(cLote)) .And.  dDtVldDest < dDtValid
				HelpAutoma(" ",1,"A240DTVALI")
				&(ReadVar()):= dDtValid
			EndIf
		EndIf
	EndIf
Else
	If !Rastro(cCod)
		Help(" ",1,"NAORASTRO")
		lRet:=.F.
	Else
		If !Empty(cLoteCtl) .Or. !Empty(cLote)
			// Verifica se a data de validade pode ser utilizada
			dbSelectArea("SB8")
			dbSetOrder(3)
			dbSeek(xFilial()+cCod+cLocal+cLoteCtl+If(Rastro(cCod,"S"),+cLote,""))
		EndIf
		If nTipo == 1
			If !lAutoma261 .And. !(SB8->(Eof())) .And. (!Empty(cLoteCtl) .Or. !Empty(cLote)) .And. dDtValid # SB8->B8_DTVALID
				HelpAutoma(" ",1,"A240DTVALI")
				&(ReadVar()):=SB8->B8_DTVALID
			EndIf
			If &(ReadVar())# dDtVldDest
				aCols[n,Len(aHeader)] := &(ReadVar())
			EndIf
		ElseIf nTipo == 2
			If !PotencLote(cCod)
				Help(" ",1,"NAOCPOTENC")
				lRet:=.F.
			EndIf
			If !(SB8->(Eof())) .And. (!Empty(cLoteCtl) .Or. !Empty(cLote)) .And. nPotencia # SB8->B8_POTENCI
				Help(" ",1,"POTENCORI")
				&(ReadVar()):=SB8->B8_POTENCI
			EndIf
		ElseIf nTipo == 3 .And. !lAutoma261
			If  (!Empty(cLoteCtl) .Or. !Empty(cLote)) .And.  dDtVldDest < dDtValid
				HelpAutoma(" ",1,"A240DTVALI")
				&(ReadVar()):= dDtValid
			EndIf
		EndIf
		RestArea(aAreaSB8)
	EndIf
EndIf
dbSelectArea(cAlias)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A240Lote  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 20.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz verifica‡„o se o Lote Proprio coincide com o lote do   ³±±
±±³          ³ sistema.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A240Lote(ExpL1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Se verdadeiro, podera' exibir msg de help          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USer Function AYAMLote(lHelp)

Local cVar:=ReadVar(),cConteudo:=&(ReadVar())
Local cAlias:=Alias(),nRecno:=Recno(),nOrdem:=IndexOrd()
Local lRet:=.T.
Local cCod,cLocal,cLote,cLoteDigi
Local dDtValid
Default lHelp := .T.
If l241.Or.l242
	cCod      := aCols[n,8]//If(!Empty(nPosCod),aCols[n,nPosCod],UserException('D3_COD'+OemToAnsi(" deve estar em uso!!!")))
	cLocal    := aCols[n,9]//If(!Empty(nPosLocal),aCols[n,nPosLocal],UserException('D3_LOCAL'+OemToAnsi(" deve estar em uso!!!")))
	cLote     := aCols[n,11]//If(!Empty(nPosLote),aCols[n,nPosLote],CriaVar('D3_LOTECTL'))
	cLoteDigi := aCols[n,11]//If(!Empty(nPosLotCTL),aCols[n,nPosLotCTL],CriaVar('D3_LOTECTL'))
	dDtValid  := aCols[n,13]//If(!Empty(nPosDValid),aCols[n,nPosDValid],CriaVar('D3_DTVALID'))
Else
	cTM       := M->D3_TM
	cCod      := M->C7_PRODUTO
	cLocal    := M->D3_LOCAL
	cLote     := SPACE(6) //M->D3_NUMLOTE
	cLoteDigi := M->D3_LOTECTL
	dDtValid  := M->D3_DTVALID
EndIf	

If !Rastro(cCod)
	Help(" ",1,"NAORASTRO")
	lRet:=.F.
EndIf

If lRet
	If cVar == "M->D3_LOTECTL"
		If Rastro(cCod,"S")
			If !Empty(cLote)
				dbSelectArea("SB8")
				dbSetOrder(2)
				If dbSeek(xFilial()+cLote) .And. cCod+cLocal == SB8->B8_PRODUTO+SB8->B8_LOCAL
					If cConteudo != SB8->B8_LOTECTL
						Help(" ",1,"A240LOTCTL")
						lRet:=.F.
					Else
						If !Empty(dDtValid) .And. dDtValid # SB8->B8_DTVALID
							If	lHelp
								HelpAutoma(" ",1,"A240DTVALI",,,,,,,,,.F.)
							EndIf
							M->D3_DTVALID:=SB8->B8_DTVALID
							If l240
								nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_DTVALID" } )
								If nEndereco > 0
									aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := DTOC(M->D3_DTVALID)
								EndIf
							ElseIf l241 .Or. l242
								If !Empty(nPosDValid)
									aCols[n,nPosDValid]:=M->D3_DTVALID
								EndIf	
							EndIf
							If l240
								nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOTECTL" } )
								If nEndereco > 0
									aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := M->D3_LOTECTL
								EndIf
							ElseIf l241 .Or. l242
								If !Empty(nPosLotCTL)
									aCols[n,nPosLotCTL]:=M->D3_LOTECTL
								EndIf	
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If	cTm > "500"
				lRet:=NaoVazio(cConteudo)
				If lRet
					dbSelectArea("SB8")
					dbSetOrder(3)
					If !(dbSeek(xFilial()+cCod+cLocal+cConteudo))
						Help(" ",1,"A240LOTERR")
						lRet := .F.
					EndIf
				EndIf
			Else
				dbSelectArea("SB8")
				dbSetOrder(3)
				If dbSeek(xFilial()+cCod+cLocal+cConteudo) .And. (!Empty(dDtValid) .And. dDtValid # SB8->B8_DTVALID)
					If	lHelp
						HelpAutoma(" ",1,"A240DTVALI",,,,,,,,,.F.)
					EndIf
					M->D3_DTVALID:=SB8->B8_DTVALID
					If l240
						nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_DTVALID" } )
						If nEndereco > 0
							aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := DTOC(M->D3_DTVALID)
						EndIf
					ElseIf l241 .Or. l242
						If !Empty(nPosDValid)
							aCols[n,nPosDValid]:=M->D3_DTVALID
						EndIf	
					EndIf
					If l240
						nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOTECTL" } )
						If nEndereco > 0
							aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := M->D3_LOTECTL
						EndIf
					ElseIf l241 .Or. l242
						If !Empty(nPosLotCTL)	
							aCols[n,nPosLotCTL]:=M->D3_LOTECTL
						EndIf	
					EndIf
				EndIf
			EndIf
		EndIf
	ElseIf cVar == "M->D3_NUMLOTE"
		If Rastro(cCod,"S")
			If cTm > "500"
				lRet:=NaoVazio(cConteudo)
			EndIf
			If lRet
				dbSelectArea("SB8")
				dbSetOrder(2)
				If dbSeek(xFilial()+cConteudo) .And. cCod+cLocal == SB8->B8_PRODUTO+SB8->B8_LOCAL
					If l240
						nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_NUMLOTE" } )
						If nEndereco > 0
							aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := M->D3_NUMLOTE
						EndIf
					ElseIf l241 .Or. l242
						If !Empty(nPosLote)
							aCols[n,nPosLote]:=M->D3_NUMLOTE
						EndIf	
					EndIf
					M->D3_LOTECTL:=SB8->B8_LOTECTL
					If l240
						nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOTECTL" } )
						If nEndereco > 0
							aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := M->D3_LOTECTL
						EndIf
					ElseIf l241 .Or. l242
						If !Empty(nPosLotCTL)
							aCols[n,nPosLotCTL]:=M->D3_LOTECTL
						EndIf	
					EndIf
					M->D3_DTVALID:=SB8->B8_DTVALID
					If l240
						nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_DTVALID" } )
						If nEndereco > 0
							aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := DTOC(M->D3_DTVALID)
						EndIf
					ElseIf l241 .Or. l242
						If !Empty(nPosDValid)
							aCols[n,nPosDValid]:=M->D3_DTVALID
						EndIf	
					EndIf
				Else
					If cTm > "500"
						Help(" ",1,"A240LOTERR")
						lRet := .F.
					Else
						M->D3_NUMLOTE:=CriaVar("D3_NUMLOTE")
						M->D3_LOTECTL:=CriaVar("D3_LOTECTL")
						If l240
							nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_NUMLOTE" } )
							If nEndereco > 0
								aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := CriaVar("D3_NUMLOTE")
							EndIf
							nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOTECTL" } )
							If nEndereco > 0
								aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := CriaVar("D3_LOTECTL")
							EndIf
						ElseIf l241
							If !Empty(nPosLote) .And. !Empty(nPosLotCTL)
								aCols[n,nPosLote]		:=CriaVar("D3_NUMLOTE")
								aCols[n,nPosLotCTL]	:=CriaVar("D3_LOTECTL")
							EndIf	
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			M->D3_NUMLOTE:=CriaVar("D3_NUMLOTE")
			If l240
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_NUMLOTE" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := M->D3_NUMLOTE
				EndIf
			ElseIf l241 .Or. l242
				If !Empty(nPosLote)
					aCols[n,nPosLote]:=M->D3_NUMLOTE
				EndIf	
			EndIf
		EndIf
	EndIf
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbGoTo(nRecno)
Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A261Quant ³ Autor ³ Marcelo Pimentel      ³ Data ³ 29/01/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina p/ iniciar campos a partir da Quantidade Informada. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A260Quant(ExpN1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Flag indicando se valida pela digitacao ou nao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA261                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function AYAMQuant(lDigita)

Local aArea      := { Alias(),IndexOrd(),Recno() }
Local aSB2Area   := { 'SB2', SB2->(IndexOrd()),SB2->(Recno()) }
Local aSB8Area   := { 'SB8', SB8->(IndexOrd()),SB8->(Recno()) }
Local aSBEArea   := { 'SBE', SBE->(IndexOrd()),SBE->(Recno()) }
//Local nRecSB8    := 0
//Local nOrdSB8    := 0
Local lRet       := .T.
Local lContinua	 := .T.
Local cReadVar   := AllTrim(Upper(ReadVar()))
Local nQuant     := 0
//Local nQuant2UM  := 0
Local nSaldo     := 0
Local lPermNegat := GetMV('MV_ESTNEG') == 'S'
Local lRastroL   := .F.
Local lRastroS   := .F.
Local lLocalizO  := .F.
Local lLocalizD  := .F.
Local nX		 := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis de Posicao utilizado no Siga Pyme   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosCODOri:= 1 					//Codigo do Produto Origem
Local nPosLOCOri:= 3					//Armazem Origem
Local nPosLcZOri:= 5					//Localizacao Origem
Local nPosCODDes:= 8//Iif(!lPyme,6,5)	S//Codigo do Produto Destino
Local nPosLOCDes:= 9//Iif(!lPyme,9,8)	//Armazem Destino
//Local nPosLcZDes:= 10					//Localizacao Destino
Local nPosNSer	:= 11					//Numero de Serie
Local nPosLoTCTL:= 6					//Lote de Controle
Local nPosQUANT	:= 12//Iif(!lPyme,16,9)	//Quantidade
//Local cHelp     := ""

SB2->(dbSetOrder(1))

If lDigita .And. cReadVar # 'M->C6_QTDVEN'
   lContinua := .F.
EndIf

If lContinua .And. lDigita .And. Empty(&(ReadVar()))
	Help(' ',1,'NVAZIO')
	lRet		:= .F.
	lContinua	:= .F.
EndIf

If lContinua .And. lDigita .And. QtdComp(&(ReadVar())) < QtdComp(0)
	Help(' ',1,'POSIT')
	lRet		:= .F.
	lContinua	:= .F.
EndIf

If lContinua
   If lDigita
	  If cReadVar == 'M->C6_QTDVEN'
		 nQuant    := &(ReadVar())
	  Else
		 nQuant    := ConvUm(aCols[n,nPosCODOri],aCols[n,nPosQUANT],&(ReadVar()),1)
	  EndIf
   Else
	  nQuant    := aCols[n,12]                           
   EndIf
   If Empty(aCols[n,nPosCODOri]) .Or. Empty(aCols[n,nPosCODDes])
	  Help(' ',1,'MA260OBR')
	  lRet		:= .F.
	  lContinua	:= .F.
   EndIf
EndIf

If lContinua
	lRastroL  := Rastro(aCols[n,1],'L')
	lRastroS  := Rastro(aCols[n,1],'S')
	lLocalizO := Localiza(aCols[n,1])
	lLocalizD := Localiza(aCols[n,8])

	//-- Produtos sem Rastro ou Localizacao mas com Controle de Estoque
	//-- Negativo - Impede Movimentacoes que causem Saldo Negativo no SB2
	If !lPyme .And. !lPermNegat .And. ;
			!(lRastroL .Or. lRastroS) .And. (!lLocalizO .And. !lLocalizD)
		SB2->(DbSetOrder(1))
		If !SB2->(dbSeek(xFilial('SB2')+aCols[n,nPosCODOri]+aCols[n,nPosLOCOri], .F.))
			Help(' ',1,'A260Local')
			lRet		:= .F.
			lContinua	:= .F.
		EndIf
		If lContinua
			nSaldo := SaldoMov(Nil,Nil,Nil,If(mv_par03 ==1,.F.,Nil),Nil,Nil,Nil,If(Type('dA261Data') == "D",dA261Data,dDataBase))
			For nX := If(!lDigita,n+1,1) to Len(aCols)
				If nX # n
					If !aCols[nX,Len(aCols[nX])].And.(If(lRastroL,aCols[n,nPosLoTCTL]==aCols[nX,nPosLoTCTL],.T.))
						If aCols[n,nPosCODOri] + aCols[n,nPosLOCOri] == aCols[nX,nPosCODOri] + aCols[nX,nPosLOCOri]
							nSaldo -= aCols[nX,nPosQUANT]
						ElseIf aCols[n,nPosCODOri] + aCols[n,nPosLOCOri] == aCols[nX,nPosCODDes] + aCols[nX,nPosLOCDes]
							nSaldo += aCols[nX,nPosQUANT]
						EndIf
					EndIf
				EndIf
			Next nX
			If QtdComp(nSaldo) < QtdComp(nQuant)
				Help(' ',1,'MA240NEGAT')
				lRet		:= .F.
				lContinua	:= .F.
			EndIf
		EndIf
	EndIf
EndIf

//-- Produto Origem com Localizacao - Impede Movimentacoes com
//-- Quantidades maiores que o Saldo no SBF
If lContinua .And. !lPyme .And. lLocalizO        
    
	If Empty(aCols[n,nPosLcZOri]+aCols[n,nPosNSer]) .Or. ;
			(!Empty(aCols[n,nPosLcZOri]) .And. !SBE->(dbSeek(xFilial('SBE')+aCols[n,nPosLOCOri]+aCols[n,nPosLcZOri],.F.)))
		Help(' ',1,'MA260OBR')
		lRet		:= .F.
		lContinua	:= .F.
	EndIf
	If lContinua
	   nSaldo := aCols[n,4]
		If QtdComp(nSaldo) < QtdComp(nQuant)
			alert("Help(' ',1,'SALDOLOCLZ')")
			Help(' ',1,'SALDOLOCLZ')
			lRet		:= .F.
			lContinua	:= .F.
		EndIf
	EndIf
EndIf
If lContinua
	aCols[n,12] := nQuant
EndIf
//-- Retorna Integridade do Sistema
dbSelectArea(aSB2Area[1]); dbSetOrder(aSB2Area[2]); dbGoto(aSB2Area[3])
dbSelectArea(aSB8Area[1]); dbSetOrder(aSB8Area[2]); dbGoto(aSB8Area[3])
dbSelectArea(aSBEArea[1]); dbSetOrder(aSBEArea[2]); dbGoto(aSBEArea[3])
dbSelectArea(aArea[1]); dbSetOrder(aArea[2]); dbGoto(aArea[3])

Return lRet
                           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Rastro    ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 10/05/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pesquisa no SB1 se produto corrente usa rastreabilidade     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rastro(cProd,cTipo)  	                                  ³±±
±±³          ³ cProd := C¢digo do produto a ser pesquisado no SB1.        ³±±
±±³          ³ cTipo := Tipo de Rastreabilidade a ser verificada.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EST/PCP/FAT/COM	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Yastro(cProd,cTipo)
Local lPyme    := If(Type("__lPyme") <> "U",__lPyme,.F.)
Local lUsaLote := !lPyme .And. (SuperGetMV("MV_RASTRO") == "S")
Local lRet     := .F.
Local cAlias   :="",nRecno := 0,nOrder := 0

cTipo:=If(cTipo == NIL,"",cTipo)

If !lPyme .And. lUsaLote
	If (SB1->(B1_FILIAL+B1_COD) == xFilial("SB1")+cProd)
		lRet := If( Empty(cTipo),(SB1->B1_RASTRO $ "SL" ),(SB1->B1_RASTRO $ cTipo) )
	Else
		cAlias := Alias()
		If cAlias # "SB1"
			dbSelectArea("SB1")
		EndIf
		nRecno := Recno()
		nOrder := IndexOrd()
		If nOrder # 1
			dbSetOrder(1)
		EndIf
		If dbSeek(xFilial("SB1")+cProd,.F.)
			lRet := If( Empty(cTipo),(SB1->B1_RASTRO $ "SL" ),(SB1->B1_RASTRO $ cTipo) )
		EndIf
		If nRecno # Recno()
			dbGoto(nRecno)
		EndIf
		If nOrder # IndexOrd()
			dbSetOrder(nOrder)
		EndIf
		If cAlias # "SB1"
			dbSelectArea(cAlias)
		EndIf
	EndIf
EndIf
Return(lRet)
