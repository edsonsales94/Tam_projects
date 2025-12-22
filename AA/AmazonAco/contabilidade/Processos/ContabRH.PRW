/*_________________________________________________________________
¦ Função    ¦ ContabRH   ¦ Leirene Araujo    ¦ Data ¦ 10/03/2016   ¦
+-----------+------------+-------------------+------+--------------+
¦ Descriçäo ¦ Contabilização da Folha de Pagamento                 ¦
¦           ¦                                                      ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'

User Function ContabRH()
  _cArea  := GetArea()
  _cConta := Space(20)

  dbSelectArea("CTT")
  dbSetOrder(1)
  dbSeek(xFilial()+SRZ->RZ_CC)

  dbSelectArea("SRA")
  dbSetOrder(1)
  dbSeek(xFilial()+SRZ->RZ_MAT)  

  Do Case
     Case CTT->CTT_XTPOCC = "0"     /* CUSTO DIRETO    */    
          _cConta := SRV->RV_XDIRETO
     Case CTT->CTT_XTPOCC = "1"     /* CUSTO INDIRETO  */
          _cConta := SRV->RV_XINDIRE
     Case CTT->CTT_XTPOCC = "2"     /* ADMINISTRAÇÃO   */
          If SRZ->RZ_FILIAL ="01"   /* MATRIZ          */
             _cConta := SRV->RV_XADMMAT
          Else                      /* FILIAL          */
             _cConta := SRV->RV_XADMFIL
          EndIf                
          If SRZ->RZ_PD = "999" .AND. SRA->RA_CATFUNC = "P"
             _cConta := "215010002"
          EndIf          
     Case CTT->CTT_XTPOCC = "3"     /* VENDAS          */                                            
          IF SRZ->RZ_FILIAL=="01"   /* MATRIZ          */
             _cConta := SRV->RV_XVENMAT
          Else                      /* FILIAL          */
             _cConta := SRV->RV_XVENFIL
          EndIf
  EndCase
  RestArea(_cArea)
Return _cConta
