#include 'totvs.ch'
#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function confneop

@000,000 TO 180,520 DIALOG oDlg1 TITLE "Geraçâo Automatica de OP"
		@010,5 TO 065,255
		@ 020,010 say "Gerar OP a partir da NFE."
		@ 035,010 say "Voce pode gerar uma OP para esta nota de benificiamento agora."
		@073,190 BMPBUTTON TYPE 4 ACTION GeraOp()
		@073,222 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTERED
		
Return(.T.)


/*
-----------------------------------------------------------------------------------------------------------------------------------------
*/
Static Function GeraOp
//User Function GravaOP(PQtd,i) 
_aVetor  := {} 
_cNum    := GETMV("MV_X_OPBEN")//GetSxENum("SC2","C2_NUM")    
_COD     := SPACE(15) 

 @ 0,0 TO 160,400 DIALOG oDlg2 TITLE "Pesquisa Produto"
      @ 12,010 SAY "CODIGO DO PRODUTO"
      @ 12,070 GET _COD  PICTURE "@!" F3("SB1") SIZE 40,15
      @ 57,015 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
      //@ 57,060 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
      ACTIVATE DIALOG oDlg2 CENTERED

_UM		:=POSICIONE("SB1",1,XFILIAL("SB1")+_COD,"B1_UM")
_LOCAL  :=POSICIONE("SB1",1,XFILIAL("SB1")+_COD,"B1_LOCPAD") 
dbSelectArea("SC2")
dbSetOrder(1)
while dbSeek( xFilial("SC2")+_cNum )  //so entra se o no. do pedido ja existir.
	_cLetra := substr(_cNum,1,1) //letra utiliza na numeracao atual do pedido.
	if substr(_cNum,2,5) == "99999"
		_cLetra := CHR( ASC(substr(_cNum,1,1))+1 )  //proxima letra para incrementar numeracao
		_cCodigo := " 00000" //para iniciar nova numeracao.
	endif
	_cNum := _cLetra + strzero(val(substr(_cNum,2,5))+1,5)
	dbSelectArea("SX6")
	dbSetOrder(1)
	dbSeek( xFilial("SX6") + "MV_X_OPBEN" )
	RECLOCK("SX6")
	SX6->X6_CONTEUD := _cNum
	MSUNLOCK()
Enddo

lMsErroAuto := .f. 
_aVetor:={{"C2_FILIAL"     , xFilial("SC2") 	  , NiL},;      
          {"C2_NUM"        , _cNum          	  , NIL},; 
          {"C2_ITEM"       , "01"		    	  , NIL},; 
          {"C2_SEQUEN"     , "001"				  , NIL},; 
          {"C2_PRODUTO"    , _COD  				  , NIL},; 
          {"C2_LOCAL"      , _LOCAL           	  , NIL},; 
          {"C2_CC"         , ""             	  , Nil},;                
          {"C2_QUANT"      , aCols[len(aCols)][7] , NIL},;    
          {"C2_UM"         , _UM				  , NIL},; //aCols[len(aCols)][3]
          {"C2_DATPRI"     , Ddatabase			  , NIL},; 
          {"C2_DATPRF"     , Ddatabase			  , NIL},; 
          {"C2_OBS"        , ""			    	  , NIL},; 
          {"C2_EMISSAO"    , Ddatabase	    	  , NIL},;                 
          {"C2_PRIOR"      , "500"          	  , Nil},; 
          {"C2_STATUS"     , "N"            	  , NIL},; 
          {"C2_TPOP"       , "F"            	  , NIL},;
          {'AUTEXPLODE'    ,'S'			          , NIL}} 
                
MSExecAuto({|x,y| mata650(x,y)},_aVetor,3) //Inclusao 
If lMsErroAuto 
   RollBackSX8() 
   MostraErro() 
   MsgAlert("Erro")                                                               
Else                                    
   ConfirmSX8()
	//*********************************************
	// Verica se a Ordem de Produçao foi inserida
	//*********************************************
	_cLetra := substr(GETMV("MV_X_OPBEN"),1,1) //letra utiliza na numeracao atual do pedido.
	DbSelectArea("SC2")
	DbSetOrder(1)
	DbSeek(xFilial("SC2")+_cNum)
		If Found()
			if substr(_cNum,2,5) == "99999"
				_cLetra := CHR( ASC(substr(_cNum,1,1))+1 )  //proxima letra para incrementar numeracao
				_cNum := " 00000" //para iniciar nova numeracao.
			endif
			dbSelectArea("SX6")
			dbSetOrder(1)
			dbSeek( xFilial("SX6")+"MV_X_OPBEN" )
			RECLOCK("SX6")
			SX6->X6_CONTEUD := _cLetra + strzero(val(substr(GETMV("MV_X_OPBEN"),2,5))+1,5)
			MSUNLOCK()
		EndIf
   MsgAlert("O numero da ordem de Produção gerada é "+SC2->C2_NUM)
   
   //aCols[len(aCols)][29] :=SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN //_cNum
   aCols[n][29] :=SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN //_cNum
   GetDRefresh()
   Close(oDlg1)
Endif 
Return 
