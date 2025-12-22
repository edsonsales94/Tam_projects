#include "Rwmake.ch"
#include "TbiConn.ch"
#include "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT241LOK   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 29/02/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar armazéns 11,31                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT241LOK()
Local n         := ParamIxb[1]
Local lRet      := .T.
Local nPosLocal := AScan( aHeader,{|x| Trim(x[2]) == "D3_LOCAL" })
Local nPosProd  := AScan( aHeader,{|x| Trim(x[2]) == "D3_COD" })
Local x

For x:=1 to Len(Acols)
    If (aCols[x,Len(aHeader)+1]) == .F.
        If !(Acols[x][nPosLocal] $ "11/31") 
            Msgbox("Esse tipo de movimentação só é permitida para os amazéns 11 e 31 " ,"MT241LOK","STOP") 
            lRet := .F.
        EndIf
    EndIf
Next

Return lRet
