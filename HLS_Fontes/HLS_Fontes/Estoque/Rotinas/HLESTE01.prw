//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#INCLUDE "RWMAKE.CH"

/*/{protheus.doc}HLESTE01
Execbloc para montar os LP´s de Custo.
@author Wermeson Gadelha
@since 13/05/2015
/*/

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLESTE01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 13/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execbloc para montar os LP´s de Custo                         ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLESTE01()
 //-------------------------------------------------------. 
 // Declaração das variaveis locais da função              |
 //-------------------------------------------------------' 
 Local cConta := "" 
 cArea:=  GetArea() 

	//-------------------------------------------------------. 
	// Verifica o tipo de produto para a contabilizacao       |
	//-------------------------------------------------------'

	If (SB1->B1_TIPO == "MP") // Materia prima importado 
			cConta := "1103010002"
		ElseIf (SB1->B1_TIPO == "MN") // Materia prima Nacional
			cConta := "1103010001"
		ElseIf (SB1->B1_TIPO == "EM") // Embalagem 
			cConta := "1103010031"
		ElseIf (SB1->B1_TIPO == "RV") // Revenda Nacional
			cConta := "1103020002"
		ElseIf (SB1->B1_TIPO == "MC") // Material de Consumo
			cConta := "1103010064"
		ElseIf (SB1->B1_TIPO == "MS") // Material secundario 
			cConta := "1103010063"
		ElseIf (SB1->B1_TIPO == "PI") // Produto Intermediario 
			cConta := "1103010062" 
		ElseIf (SB1->B1_TIPO == "PA") // Produto Acabado 
			cConta := "1103010011"
		Else  // Moldes e Maquinas
			cConta := "1103020003" 
	EndIf 
                                         

	//-------------------------------------------------------. 
	// Restauração da area anterior a execução do execblock   |
	//-------------------------------------------------------' 	  	
	RestArea(cArea)  	
	
//-------------------------------------------------------. 
// Retorno da função -  Operação orçamentária             |
//-------------------------------------------------------' 
Return(cConta)

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