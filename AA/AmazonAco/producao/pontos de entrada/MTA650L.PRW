#include "Rwmake.ch"
#include "TbiConn.ch"
#include "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MTA650L    ¦ Autor ¦ Williams Messa       ¦ Data ¦ 17/02/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrdada validação de  do acols do Empenho.          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MTA650L()

Local lRet     := .T.
Local nQuant   := 0
Local lOk      := FWISINCALLSTACK("A650AETdOk")
Local nPosQ    := GDFieldPos("D4_QUANT")
Local nDif     := 0
local x
Local cxgrps   := POSICIONE('SB1',1,XFILIAL("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")

If (!AllTrim(SC2->C2_PRODUTO) $ Alltrim(GetMV("MV_XPRODEM")) .or. !ALLTRIM(cxgrps) $ Alltrim(GetMV("MV_XGRUDEM") ) ) .AND. fwCodFil() <> "00" 
    If lOk
        For x = 1 to Len(Acols)
            If !(aCols[x,Len(aHeader)+1])
                nQuant += Round(acols[x][nPosQ],2)
            EndIF
        Next x
        If nQuant <> SC2->C2_QUANT
        lRet :=.F.
        nDif := nQuant - SC2->C2_QUANT
        If nDif <= 0.01
            lRet:=.T.
            Else
            Msgbox("A quantidade de empenho é diferente "+ Transform(nDif,"@E 999,999,999.99")  + " que a quantidade da OP: "+ SC2->C2_NUM ,"Validação Empenho","STOP") 
            EndIf
        EndIf
    EndIf
EndIf

Return(lRet)
