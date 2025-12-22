#include "totvs.ch"
 /*/{Protheus.doc} SD3250R()
    (long_description)
    @type  Function
    @author Diego Rafael
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SD3250R()
    Local aSC2 := SC2->(GetArea())
    SC2->(dbSetOrder(1))
    SC2->(dbSeek(xFilial("SC2")+SD3->D3_OP))
    if !Empty(SC2->C2_RECURSO)
        _ChangeOP(SC2->C2_FILIAL,SC2->C2_RECURSO)
    EndIf
    SC2->(RestArea())

Return Nil

Static Function _ChangeOP(xdFilial,xRecurso)
   Local xSql := ''
   Local xTbl := ''
   xSql := " Select TOP 1 * From " + RetSqlName("SC2")
   xSql += "   Where C2_FILIAL = '" + xdFilial + "' And  C2_RECURSO = '" + xRecurso + "'"
   xSql += "   And C2_XSEQUEN > 0"
   xSql += "   And C2_DATRF = ' '"
   //xSql += "   And C2_STATUS = 'S'
   xSql += " Order By C2_XSEQUEN

   xTbl := MpSysOpenQuery(xSql)
   if !(xTbl)->(Eof())
      SC2->(dbSetOrder(1))
      If SC2->(dbSeek(xFilial("SC2") + (xTbl)->C2_NUM + (xTbl)->C2_ITEM + (xTbl)->C2_SEQUEN ) )
         SC2->(ReclOck('SC2',.F.))
         SC2->C2_STATUS = 'N'
         SC2->(MsUnlock())
      EndIf
   EndIf

Return Nil
