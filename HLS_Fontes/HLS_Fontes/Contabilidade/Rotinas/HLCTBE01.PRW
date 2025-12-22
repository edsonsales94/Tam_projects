//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#Include 'Protheus.ch'
/*/{protheus.doc}HLCTBE01
Rotina principal para a importação de um arquivo de extensao  CSV para o orçamento do SIGAPCO.   
@author Wermeson Gadelha
@since 01/03/2014
/*/
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PLPCOP01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina principal para a importação de um arquivo de extensao  +¦¦
¦¦¦  (Cont)   ¦ CSV para o orçamento do SIGAPCO.                              +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLCTBE01()     
 //-------------------------------------------------------. 
 // Declaração das variaveis locais do prorama             |
 //-------------------------------------------------------' 
Local nwValor :=  U_UZNFCONT("ITEM","FOB")+;
                          U_UZNFCONT("ITEM","FRETE")+;
                          U_UZNFCONT("ITEM","SEGURO")+;
                          U_UZNFCONT("ITEM","II")+;
                          U_UZNFCONT("ITEM","IPI")+;
                          U_UZNFCONT("ITEM","MARPIS")+;
                          U_UZNFCONT("ITEM","PIS-MAR")+;
                          U_UZNFCONT("ITEM","MARCOF")+;
                          U_UZNFCONT("ITEM","COF-MAR")+;
                          U_UZNFCONT("ITEM","ICMS")+;
                          U_UZNFCONT("ITEM","TXSISC")+;
                          U_UZNFCONT("ITEM","ACRESCIMO")+;
                          U_UZNFCONT("ITEM","DESPESA")+;
                          U_UZNFCONT("ITEM","DESP_ICMS") 

Return nwValor
                                           
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
************************************************************************************/ 