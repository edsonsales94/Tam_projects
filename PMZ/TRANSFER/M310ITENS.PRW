#INCLUDE 'PROTHEUS.CH'

User Function M310ITENS()
 
Local cProg  := PARAMIXB[1]
Local aItens := PARAMIXB[2]
Local nx
 
If Alltrim(cProg) == 'MATA410'
    For nx:=1 to Len(aItens)
        aadd(aItens[nx],{'C6_CONTA','1110210',Nil})
    Next nx
EndIf
Return(aItens)
