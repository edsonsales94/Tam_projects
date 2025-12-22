#include "rwmake.ch"


/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ MT103IPC   ¦                              ¦ Data ¦ 09/02/2005             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para retornar com o codigo da viagem informada no pedido ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nenhum                                                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function MT103IPC
  Local nPosViagem := Ascan( aHeader, {|y| "D1_VIAGEM" == Alltrim(y[2])})  
  Local nPosITEMCTA:= Ascan( aHeader, {|y| "D1_ITEMCTA" == Alltrim(y[2])})  
  Local nPosTREINAM:= Ascan( aHeader, {|y| "D1_TREINAM" == Alltrim(y[2])})  
  Local nPosHORA   := Ascan( aHeader, {|y| "D1_HORA" == Alltrim(y[2])})  
  
  Local nPosDESCRI := Ascan( aHeader, {|y| "D1_DESCRI" == Alltrim(y[2])})  
  Local nPosDESCCC := Ascan( aHeader, {|y| "D1_DESCCC" == Alltrim(y[2])})  
  Local nPosDESCCLV:= Ascan( aHeader, {|y| "D1_DESCCLV" == Alltrim(y[2])})  
  Local nPosDESCCTB:= Ascan( aHeader, {|y| "D1_DESCCTB" == Alltrim(y[2])})  
  Local nPosDETALH := Ascan( aHeader, {|y| "D1_DETALH" == Alltrim(y[2])})  

  Local nItem:= ParamIxb[1] 
    
  aCols[nItem][nPosViagem] := SC7->C7_VIAGEM   
  aCols[nItem][nPosITEMCTA]:= SC7->C7_ITEMCTA
  aCols[nItem][nPosTREINAM]:= SC7->C7_TREINAM
  aCols[nItem][nPosHORA   ]:= SC7->C7_HORA
  //-
  aCols[nItem][nPosDESCRI ]:= SC7->C7_DESCRI
  aCols[nItem][nPosDESCCC] := SC7->C7_DESCCC
  aCols[nItem][nPosDESCCLV]:= SC7->C7_DESCCLV
  aCols[nItem][nPosDESCCTB]:= SC7->C7_DESCCTB
  aCols[nItem][nPosDETALH] := SC7->C7_DETALH
  //- 
return
