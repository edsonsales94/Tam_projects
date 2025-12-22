#include 'Protheus.ch'

/*
Descricao  : Após a confirmação da liberação do documento, 
             deve ser utilizado para executar uma validação do usuario na liberação a fim de interromper o processo ou não
             Utilizado para Envio de email da medicao e retornar o Tipo para RV de requisicao de Viagem
*/

User Function MTA097()
  Local lRet := .T.
  Local cVar  := Alltrim(SCR->CR_NUM) +'RV'  

   // wermeson 
   If SCR->CR_TIPO == "MD"
       CND->(dbSetOrder(4))
       CND->(dbSeek(xFilial("CND") + SCR->CR_NUM))
       u_CN130PGRV("01")
   elseif SCR->CR_TIPO == "PC"
//       SC7->(dbSetOrder(1))
//       SC7->(dbSeek(xFilial('SC7')+SCR->CR_NUM))
//       u_INEnviaEmail(SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_NUMSC,1,"")
   Endif

  /*
  If GetGlbValue ( cVar ) = 'S'
	  SCR->(RecLock('SCR',.F.))
	     SCR->CR_TIPO := 'RV'
	  SCR->(MsUnlock())
	  lRet := .T.
	  Remove(Alltrim(SCR->CR_NUM))
  EndIf
  */              

Return lRet

Static Function Remove(cNUmero)
	  cQry := " Delete  "  + RetSqlName('SC7')
	  cQry += " Where C7_NUM  = '" + SubStr(cNumero,1,TamSX3('C7_NUM')[01]) + "' And C7_OBS = 'REQDRO                        '"
	  tcSqlExec(cQry)
	  
Return Nil



/*Powered By DXRCOVRB*/
