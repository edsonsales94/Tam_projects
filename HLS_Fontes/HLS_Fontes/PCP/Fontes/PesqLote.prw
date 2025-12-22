# INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} PesqLote

Funçao responsavel por retornar o proximo lote.

@type function
@author Marcos Martins
@since 11/09/08

@return Caracter, Proximo Lote.
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PesqLote  ºAutor  ³Marcos Martins      º Data ³  11/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o numero do Lote (data+sequencia)                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////
User Function PesqLote()
////////////////////////
//
Local _xAlias := Alias()               // Salvar Contextos
Local _xOrder := IndexOrd()
Local _xRecno := Recno()
//
Local _nRegSX6 := SX6->(Recno())
Local _nOrdSX6 := SX6->(IndexOrd())
//
Local _cX6_VAR     := "MV_PRXLOTE"     // Parametro p/ o Proximo Lote
Local _cX6_CONTEUD := ""               // Conteudo do Parametro
Local _cProxLote   := GetMv(_cX6_VAR)  // Proximo Lote Atual
//

//Local _cData       := AllTrim(SubStr(DtoS(ddatabase),9,2)+SubStr(DtoS(ddatabase),4,2)+SubStr(DtoS(ddatabase),1,2)) 
Local _cData       := AllTrim(SubStr(DtoS(ddatabase),3,2)+SubStr(DtoS(ddatabase),5,2)+SubStr(DtoS(ddatabase),7,2))

If _cProxLote=="009999"
   _cProxLote:="000000"
EndIf
//
SX6->(DbSetOrder(1))                   // Parametros do Sistema
//
SX6->(DbSeek(xFilial("SX6") + _cX6_VAR, .F.))
//
If SX6->(Found())
   //
   _cX6_CONTEUD := Soma1(_cProxLote)   // Proximo Numero Sequencial
   //
   DbSelectArea("SX6")                 // Atualizar o Novo Numero de Lote
   If SX6->(RecLock("SX6", .F.))
      //
      SX6->X6_CONTEUD := _cX6_CONTEUD
      SX6->X6_CONTSPA := _cX6_CONTEUD
      SX6->X6_CONTENG := _cX6_CONTEUD
      //
      SX6->(MsUnlock())
      //
   Endif
   //
Endif
//
SX6->(DbSetOrder(_nOrdSX6))            // Restaurar Contextos
SX6->(DbGoTo(_nRegSX6))
//
DbSelectArea(_xAlias)
DbSetOrder(_xOrder)
DbGoTo(_xRecno)
//
Return (_cData+Substr(_cProxLote,3,4))
