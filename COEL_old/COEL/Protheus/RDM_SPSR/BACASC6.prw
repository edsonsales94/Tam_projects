#include "rwmake.ch"  

User function alt_c6des
Processa({||RunProc9()},"Acerta descricao do pedido")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Acerta Custo de Entradas")
Return




Static function RunProc9
troca:=""

dbselectarea("SC6") 
DbSetOrder(1)
DBGOTOP()

ProcRegua(LastRec())
While Eof() == .f. .And. SC6->C6_FILIAL == "01"        

	//ALERT("Descricao"+SC6->c6_descri)	
    IncProc('Acertando descricao do pedido '+ SC6->C6_NUM)
	TROCA:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")
    Reclock("SC6",.F.)
      SC6->c6_descri:= TROCA
    MsUnlock()
    //ALERT("Nova Descricao"+SC6->c6_descri)
    DbSkip()
End
Return
