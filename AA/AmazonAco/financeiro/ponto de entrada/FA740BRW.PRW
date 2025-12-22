#include 'totvs.ch'

User Function FA740BRW()
 Local aRotina := {}//AClone(PARAMIXB)
  aAdd(aRotina, {"Acres/Decres", "u_AAFINE04", 0, 3})
  aAdd(aRotina, {"Alterar Vencimento", "u_AAAltVenc", 0, 3})

Return (aRotina) 

User Function AAAltVenc()
 Local aParamBox := {}
 Local dDataDe  := SE1->E1_VENCREA
 Local dDataAt  := SE1->E1_VENCREA
 
  aAdd(aParamBox,{1,"Vencimento Atual :",dDataDe ,""  ,".T.",""   ,".F.",80,.T.})
  aAdd(aParamBox,{1,"Novo Vencimento  :",dDataAt ,""  ,".T.",""   ,".T.",80,.T.})  

  If ParamBox(aParamBox,"Atualização de vencimento") 
	  Processa({|| fAtauliza() },"Imprimindo")
	EndIf
Return 

Static Function fAtauliza()

SE1->(dbSetorder(1))

    
  If SE1->(dbSeek( SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO))) .AND. (SE1->E1_SALDO > 0)                 
      Reclock("SE1", .F.)
        SE1->E1_VENCREA := MV_PAR02
      MsUnlock()
      Aviso("Concluido","Vencimento alterado com sucesso!",{"OK"}, 1) // "Armazem invelido","Informe um armazem existente." "OK"
    Else 
      Aviso("Problema","Não foi Possivel alterar o Vencimento!",{"OK"}, 1) // "Armazem invelido","Informe um armazem existente." "OK"
  EndIf 

Return Nil 


