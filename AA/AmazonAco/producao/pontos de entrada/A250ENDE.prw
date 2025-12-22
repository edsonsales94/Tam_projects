//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A250ENDE   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 13/05/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrdada para ajuste do endereco de consumo          ¦¦¦
¦¦¦           ¦ para correto funcionamento compilar o PE A250CHEN             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A250ENDE()     
 //-------------------------------------------------------. 
 // Declaração das variaveis Locais da rotina principal    |
 //-------------------------------------------------------'
 //Local aSD4   := ParamIXB[1]   //-- Informações do Empenho SD4
 Local cEnd   := 'XX'//-- Customizações do Cliente
 	
 	SC2->(dbSetOrder(1))
 	If SC2->(dbSeek (xFilial("SC2") + M->D3_OP ) ) .And. !Empty(SC2->C2_RECURSO)
 		dbSelectArea("SH1")
		SH1->(dbSetOrder(1))
 		If SH1->(dbSeek (xFilial("SH1") + SC2->C2_RECURSO ) )	
 			cEnd := SC2->C2_RECURSO //SH1->H1_XENDE
		EndIf 
 	EndIf  
 	
Return cEnd 

/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
***********************************************************************************/
