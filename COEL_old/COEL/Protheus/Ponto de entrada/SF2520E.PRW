#include "rwmake.ch"

User Function SF2520E()

//*************************************************************************
//³* Guarda Ambiente Original
//*************************************************************************
_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()

if SM0->M0_CODIGO == "03"    // Manaus

   Proc_AM()

endif

//************************************************************************************
//*³ Retorna Ambiente Inicial
//************************************************************************************

dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

Static Function Proc_AM()

dbSelectArea("SD2")
dbSetOrder(3)
_chave:= xFilial() + SF2->F2_DOC + SF2->F2_SERIE
if dbSeek(xFilial() + SF2->F2_DOC + SF2->F2_SERIE )
   While !Eof() .and. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == _chave

       if SD2->D2_TES != "703"
	  dbskip()
	  loop
       endif

       _cTm    := "600"   // requisicao
       _cProd  := SD2->D2_COD
       _cLocal := "03"
       _nQuant := SD2->D2_QUANT
       _cTxt   := "ESTORNO TRANSF.ALM.02"
       _cUM    := SD2->D2_UM
       _dData  := SD2->D2_EMISSAO
       lMsErroAuto := .F.
       aVetor:={ {"D3_FILIAL"  , "01"    , NIL},;
       aVetor:=  {"D3_TM"      , _cTm    , NIL},;
		 {"D3_COD"     , _cProd  , NIL},;
		 {"D3_UM"      , _cUM    , NIL},;
		 {"D3_LOCAL"   , _cLocal , NIL},;
		 {"D3_EMISSAO" , _dData  , NIL},;
		 {"D3_QUANT"   , _nQuant , NIL},;
		 {"D3_X_OBS"   , _cTxt   , NIL}}
       ///
       MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao
       ///
       If lMsErroAuto
	  Alert("Problemas na gravacao da movimentacao de estoque. Notifique o departamento de informatica.")
       endif

       dbSelectArea("SD2")
       dbSkip()

   EndDo
EndIf

RETURN
