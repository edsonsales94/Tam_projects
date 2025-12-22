#include "rwmake.ch"        

User Function Ccom02i()     
Local _aMoeda , _nMoed , _nFator , _nPos , _nValRet , _cAlias
Local _cMoeda1,_cMoeda2,_cMoeda3,_cMoeda4,_cMoeda5,_cMoeda6,_cMoeda7,_cMoeda8,_cMoeda9

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CCOM02I  ³ Autor ³ Heitor/Rosimeire Goes ³ Data ³ 02.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ C lculo do valor unit rio em Reais                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Pedido de Compras em Outras Moedas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
_cAlias:= alias()
_cMoeda1:= getmv("MV_MOEDA1")
_cMoeda2:= getmv("MV_MOEDA2")
_cMoeda3:= getmv("MV_MOEDA3")
_cMoeda4:= getmv("MV_MOEDA4")
_cMoeda5:= getmv("MV_MOEDA5")
_cMoeda6:= getmv("MV_MOEDA6")
_cMoeda7:= getmv("MV_MOEDA7")
_cMoeda8:= getmv("MV_MOEDA8")
_cMoeda9:= getmv("MV_MOEDA9")

//_aMoeda:= { MV_MOEDA1 , MV_MOEDA2 , MV_MOEDA3 , MV_MOEDA4 , MV_MOEDA5 , MV_MOEDA6 , MV_MOEDA7 , MV_MOEDA8 , MV_MOEDA9 }
_aMoeda:= { _cMoeda1,_cMoeda2,_cMoeda3,_cMoeda4,_cMoeda5,_cMoeda6,_cMoeda7,_cMoeda8,_cMoeda9 }
_nMoed := 0
if !empty(NMOEDAPED)
 //  _nMoed:= ascan( _aMoeda , NMOEDAPED )
   _nMoed:= NMOEDAPED //Rogerio
endif
if empty(_nMoed)
   _nMoed:= 1
endif

Dbselectarea("SM2")
Dbsetorder(1)

_nFator:= 1     // para os casos onde a moeda e' 1 - Real

IF Dbseek(DdataBase)
      do Case
         case _nMoed==2
              _nfator:= SM2->M2_MOEDA2
         case _nMoed==3
              _nfator:= SM2->M2_MOEDA3
         case _nMoed==4
              _nfator:= SM2->M2_MOEDA4
         case _nMoed==5
              _nfator:= SM2->M2_MOEDA5
         case _nMoed==6
              _nfator:= SM2->M2_MOEDA6
         case _nMoed==7
              _nfator:= SM2->M2_MOEDA7
         case _nMoed==8
              _nfator:= SM2->M2_MOEDA8
         case _nMoed==9
              _nfator:= SM2->M2_MOEDA9
      endcase
      
      _nValret := Round(M->C7_PRECO2 * _nfator,4)

Endif

Dbselectarea(_cAlias)
Return(_nValret)
