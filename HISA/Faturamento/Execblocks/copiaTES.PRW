#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"

/*
_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦COPIATES    ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 25/02/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para realizar copia de TES selecionada.                ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function copiaTES(calias,cCampo) 

local _area:=getarea(),_a,cCpo 

if Msgyesno("Deseja realizar a copia da TES: " + SF4->F4_CODIGO+"-"+ALLTRIM(SF4->F4_TEXTO)+" ?")
   __INTERNET = "AUTOMATICO" 
   DbSelectar(cAlias) 
   FOR _A:=1 TO FCOUNT() 
       cCpo:=Trim(FieldName(_a)) 
       //IF !"GETSX"$X3_RELACAO(cCpo) //nao atualizar campos que saõ calculados pelo sistema 
          M->&cCpo:=fieldget(_a) 
       //Endif           
   Next _a 
   Restarea(_area) 
   __INTERNET := nil 
Endif
Return cCampo