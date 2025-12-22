#include "rwmake.ch"

User Function mt010INC

/*/
@---------------------------------------------------------------------------@
| Programa  | MT010INC  | Autor|Rogerio Batista         | Data |24.03.2003  |
@---------------------------------------------------------------------------@
| Descricao | Ponto de entrada para criar registro no B5 (Complemento de    |
|           | produtos) B5_COD e B5_CEME                                    |
@---------------------------------------------------------------------------@
| Uso       | Utilizado em Manaus                                           |
@---------------------------------------------------------------------------@
/*/

Local _cAlias

_cAlias:= alias()                            

    DbSelectArea("SB2")     // Cadastro de Produtos          
    DbSetOrder(1)           // Filial + Produto                         
    If !DbSeek(xFilial()+SB1->B1_COD)
      RecLock("SB2",.t.)   
        SB2->B2_FILIAL:= xFilial() 
        SB2->B2_COD   := SB1->B1_COD
        SB2->B2_LOCAL := Iif(xfilial()=="01","02","01")
      MsUnLock()
    EndIf
    
    DbSelectArea("SB3")     // Cadastro de Produtos          
    DbSetOrder(1)           // Filial + Produto                         
    If !DbSeek(xFilial()+SB1->B1_COD)
      RecLock("SB3",.t.)
        SB3->B3_FILIAL:= xFilial() 
        SB3->B3_COD   := SB1->B1_COD
      MsUnLock()
    EndIf

dbselectarea("SB5")
dbsetorder(1)
dbseek(xFilial() + SB1->B1_COD)
if !Found()
   reclock("SB5",.T.)
   SB5->B5_COD := SB1->B1_COD
   SB5->B5_CEME:= SB1->B1_DESCOMP
   msunlock()
endif

reclock("SB1",.F.)
SB1->B1_MSEXP:= ""
msunlock()

dbselectarea(_cAlias)

Return( .T. )
