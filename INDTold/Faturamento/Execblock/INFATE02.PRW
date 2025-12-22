#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFATE02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/12/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Calcula o próximo número da invoice                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INFATE02()
   Local cQry
   Local cAlias := Alias() 
   Local cNum   := CriaVar("C5_INVOICE")

   If SA1->A1_EST == "EX"
      cQry := "SELECT ISNULL(MAX(SUBSTRING(C5_INVOICE,1,4)),'0') NUMERO FROM "+RetSQLName("SC5")
      cQry += " WHERE D_E_L_E_T_ = ' ' AND SUBSTRING(C5_INVOICE,1,1) IN ('0','1','2','3','4','5','6','7','8','9')"

      dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"XXX",.F.,.T.)
      cNum := StrZero(Val(NUMERO)+1,4)
      DbCloseArea()
      DbselectArea(cAlias)

      Help := .T. // Nao apresentar Help MayUse
  
      While !FreeForUse("SA1",cNum,.F.)
         cNum := Soma1(cNum)
         Help := .T. // Nao apresentar Help MayUse
      Enddo

      Help := .F. // Habilito o help novamente
      cNum := PADR(cNum + PADR(SM0->M0_FILIAL,1),TamSX3("C5_INVOICE")[1])
   Endif

Return cNum
