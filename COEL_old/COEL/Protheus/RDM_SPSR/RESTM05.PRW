#include "rwmake.ch"     

User Function RESTM05()   

SetPrvt("_cCod,_cLoja,_cDivisao,_cPerfil,_cCodseg,_cVendedor")
SetPrvt("_cCod_seg,_CKEY_TOT,_CIND_TOT,")

 
/*/
@---------------------------------------------------------------------------@
| Programa  | RESTM05  | Autor|Rogerio Batista         | Data |15.03.2010   |
@---------------------------------------------------------------------------@
| Descricao | Programa para importar o Segmento de clientes         |
@---------------------------------------------------------------------------@
| Uso       | Especifico                                                    |
@---------------------------------------------------------------------------@
/*/

        If !MsgBox("Esta  rotina  ira' importar um arquivo gerado pelo Paulo  "+Chr(13);
                  +"com os segmentos dos clientes","Importacao de Segmentos","YesNo")
           Return 
        EndIf


_cPath       := "\ARQUIVOS\"
_cArqEst     := _cPath+"SEG.DBF"
_nCustoUnit  := 0   //----> custo unitario do componente
_nCustoItem  := 0   //----> 
_nCustoTotal := 0
                                           
DbSelectArea("SA1")     // Produtos       
DbSetOrder(1)           // Filial + Codigo                           


Processa({||RunProc()},"Atualiza Segmento dos Clientes")
Return

Static Function RunProc()

DbUseArea(.T.,,_cArqEst,"EST", NIL, .F. )

_cIndEst := CriaTrab(Nil,.f.)
_cChaEst := "EST->CODIGO+EST->LOJA"

IndRegua("EST",_cIndEst,_cChaEst,,,"Selecionando Clientes")

DbSelectArea("EST")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof() 

    IncProc("Processando Cliente "+EST->CODIGO)

    DbSelectArea("SA1")
    If DbSeek(xFilial("SA1")+EST->CODIGO+EST->LOJA)
        RecLock("SA1",.f.)
               SA1->A1_X_ATIV1 := EST->DIVISAO
               SA1->A1_X_ATIV2 := EST->PERFIL
               SA1->A1_X_ATIV3 := EST->CODSEG
               SA1->A1_X_ATIV4 := EST->VENDEDOR
               
        MsUnLock()
    Else
    alert("CLIENTE NAO ENCONTRADO "+EST->CODIGO+EST->LOJA)
    EndIf

    DbSelectArea("EST")
    DbSkip()
EndDo

DbSelectArea("EST")
DbCloseArea("EST")

Return(nil)   





