#include "rwmake.ch"

User Function MT200CSI()
Local _nRec , _cProduto

_nRec	 := recno()
_cProduto:= paramixb[1]
dbsetorder(1)
dbseek(xFilial() + _cProduto)
while G1_COD == _cProduto .and. G1_FILIAL == xFilial()

  reclock("SG1",.F.)
  SG1->G1_MSEXP:= ""
  msunlock()
  dbskip()

enddo

dbgoto( _nRec )

return(.t.)
