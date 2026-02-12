/*---------------------------------------------------------------------------*
 | Data       : 11/02/2026                                                   |
 | Rotina     : PEAPONT                                                      |
 | Responsável: Edson Pedro                                                  |
 | Descrição  : Rotina apontamento de producao automatico                    |
 *---------------------------------------------------------------------------*/

//Bibliotecas
#Include 'Protheus.ch'
#Include 'Protheus.ch'
#include "tbiconn.ch"

User Function PEAPONT()

Local aVetor
Local dData
Local nOpc := 3 //-Opção de execução da rotina,
Local cOp := "OP021201001 "
Local cCod := "000000000000001"
Local cLocal:= "01"
Local cChave:= ""

// prepare environment empresa "99" filial "01" modulo "est"

lMsErroAuto := .F.

aVetor := {}

dData:=dDataBase

aVetor := { {"D3_OP" ,"OP021201001 " ,NIL},;
 {"D3_COD" ,"000000000000001" ,NIL},;
 {"D3_QUANT" ,20 ,NIL},; // {"D3_PARCTOT" , "P" ,NIL},;
 {"D3_TM" ,"010" ,NIL},;
 {"D3_QTMAIOR" , 5 ,NIL}}
 
MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

If lMsErroAuto
 CONOUT("Erro")
 mostraerro()
Else
 //CONOUT("Incluido com sucesso")
 CONOUT("Incluido com sucesso")
Endif

return nil

