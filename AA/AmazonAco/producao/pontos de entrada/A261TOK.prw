//-------------------------------------------------------.  
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#include "rwmake.ch"
#include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ KTESTE04   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 23/06/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validacao das datas nas telas do D3_EMISSAO.                  ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A261TOK()
 //-------------------------------------------------------. 
 // Declaração das variaveis locais da função              |
 //-------------------------------------------------------' 
    Local _xdI 
	Private cCodOrig   := ''
	Private cCodDest   := ''
	Private cLocOrig   := ''
	Private cLocDest   := ''
	Private cLoclzOrig := ''
	Private cLoclzDest := ''

	For _xdI  := 1 to Len(aCols)

		cCodOrig   := aCols[_xdI ,1]
		cLocOrig   := aCols[_xdI ,4]
		cLoclzOrig := aCols[_xdI ,5]
		cCodDest   := aCols[_xdI ,6]		
		cLocDest   := aCols[_xdI ,9]
		cLoclzDest := aCols[_xdI ,10]

		lRet := U_MT260TOK()

		iF !lRet
			nI := Len(aCols) + 1
		EndIf

	Next

Return lRet 

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