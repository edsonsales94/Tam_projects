#include "rwmake.ch" 

User Function Ccom03i()
Local _cAlias, _aMoeda

SetPrvt("_NFATOR,_NPOS,_NMOED,_NVALRET,NX,QUANT")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CCOM03I  ³ Autor ³ Heitor/Rosimeire Goes ³ Data ³ 02.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ C lculo do valor Total em Reais                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Pedido de Compras em Outras Moedas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

_cAlias:= alias()

_aMoeda:= { MV_MOEDA1 , MV_MOEDA2 , MV_MOEDA3 , MV_MOEDA4 , MV_MOEDA5 }
_nMoed := 0
if !empty(NMOEDAPED)
//   _nMoed:= ascan( _aMoeda , NMOEDAPED )
  _nMoed:= NMOEDAPED    //Rogerio
endif
if empty(_nMoed)
   _nMoed:= 1
endif

Dbselectarea("SM2")
Dbsetorder(1)
_nfator:=1	 // para os casos onde a moeda e' 1 - Real

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
                
      Dbselectarea("SC7")
      _nValret := Round( M->C7_PRECO2 * _nfator,2)
      
      _npos := ascan(aHeader,{|x| upper(alltrim(x[2]))="C7_QUANT"})
      if !empty(_npos)
	 QUANT:= Acols[N,_npos]
      else
	 QUANT:= 0
      endif

      _nValret := NoRound(_nValret * QUANT,2)

Endif

Dbselectarea(_cAlias)
Return(_nValret)
