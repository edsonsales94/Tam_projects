#include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"         

/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+------+-------------------+¦¦
¦¦¦ Função    ¦ M460FIM    ¦ Autor ¦ Orismar Silva                 ¦ Data ¦ 13/07/2017 ¦¦¦
¦¦+-----------+------------+-------+------------------------+------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada executado após a gravação da NF Saida, e fora da       ¦¦
¦¦¦           ¦ transação.                                                              ¦¦
¦¦+-----------+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


USER FUNCTION M460FIM() 
Local cPais  := CriaVar("A1_EST")

if SC5->C5_TIPO = "N" 
   cPais  :=Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
else
   cPais  :=Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_EST")
endif
  

if cPais = "EX"
   QCATUALCDL()
endif

Return .T. 

/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+------+-------------------+¦¦
¦¦¦ Função    ¦ QCATUALCDL ¦ Autor ¦ Orismar Silva                 ¦ Data ¦ 13/07/2017 ¦¦¦
¦¦+-----------+------------+-------+------------------------+------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Rotina utilizado p/ Gravação de dados NFe Exportacao.   		        ¦¦
¦¦+-----------+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function QCATUALCDL()

Local _cCodEmb   := GetNewPar("MV_XLOCEMB",.F.)
Local _cLocEmb   := Posicione("CC2",3,xFilial("CC2")+_cCodEmb,"CC2_MUN")
Local _cUFemb    := Posicione("CC2",3,xFilial("CC2")+_cCodEmb,"CC2_EST")


dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA) 
While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)
      RecLock("CDL",.T.)
      Replace CDL_FILIAL      With xFilial("CDL")
      Replace CDL_DOC         With SF2->F2_DOC
      Replace CDL_SERIE       With SF2->F2_SERIE
      Replace CDL_ESPEC       With "SPED"
      Replace CDL_CLIENT      With SF2->F2_CLIENTE
      Replace CDL_LOJA        With SF2->F2_LOJA
      Replace CDL_UFEMB       With _cUFemb
      Replace CDL_LOCEMB      With _cLocEmb     
      Replace CDL_ITEMNF      With SD2->D2_ITEM
      Replace CDL_PRODNF      With SD2->D2_COD
      Replace CDL_QTDEXP      With SD2->D2_QUANT      
      MsUnlock()
      DbSelectArea("SD2") 
      DbSkip()
End   
     
Return