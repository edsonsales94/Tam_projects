#include 'totvs.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A250CHEN   ¦ Autor ¦ Diego Rafael         ¦ Data ¦ 20/09/2020 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrdada para ajuste do endereco de consumo          ¦¦¦
¦¦¦           ¦ para correto funcionamento compilar o PE A250ENDE             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function A250CHEN()
   Local aSD4 := ParamIXB[1]    //-- Informações do Empenho SD4
   Local nItem := ParamIXB[2]   //-- Posição do Registro processado
   Local nCampo := ParamIXB[3]  //-- Posição do Item Processado
   Local cEnd := Nil//'Endereço a ser forçado para verificação de saldos' //-- Customizações do Cliente
   
   if !Empty(aSD4[nItem][nCampo][11])
      SC2->(dbSetOrder(1))
      If SC2->(dbSeek (xFilial("SC2") + aSD4[nItem][nCampo][11] ) ) .And. !Empty(SC2->C2_RECURSO)
          //dbSelectArea("SH1")
          SH1->(dbSetOrder(1))
          If SH1->(dbSeek (xFilial("SH1") + SC2->C2_RECURSO ) )	
              cEnd := SC2->C2_RECURSO //SH1->H1_XENDE
          EndIf
      EndIf
   EndIf

Return cEnd  //-- Retorna um endereço valida para verificação de saldo
