#include "Protheus.ch"

 
User Function AALOJR12(cdExigOs)
    
	Default cdExigOs   := ""
	Private _cdPerg := Padr('AALOJR12',Len(SX1->X1_GRUPO))

   
	CriaSx1(_cdPerg)
   If Pergunte(_cdPerg,.T.)
       _xdOrc := mv_par01
       _xdFil := mv_par02
		_cdPorta := 'LPT4'
				
		If Aviso('Atencao','Imprimindo Chapa Cortada',{'Sim','Nao'}) == 01
		   u_AALOJR11(.T.,_cdPorta,"",_xdOrc,_xdOrc,_xdFil,,"00;01;02",01)
		EndIF
   Else   
      cTbl := GeraTeste()
	   While !(cTbl)->(Eof())
			    _xdOrc := (cTbl)->L1_NUM
			    _xdFil := (cTbl)->L1_FILIAL
				_cdPorta := 'LPT4'
				
				If Aviso('Atencao','Imprimindo Chapa Cortada',{'Sim','Nao'}) == 01
				   u_AALOJR11(.T.,_cdPorta,"",_xdOrc,_xdOrc,_xdFil,,"00;01;02",01)
				EndIF
				
	//			If AViso('Atencao','Imprimindo Tudo Menos Chapa Cortada',{'Sim','Nao'}) == 01
	//			   u_AALOJR11(.T.,_cdPorta,"",_xdOrc,_xdOrc,_xdFil,,"00;01;02",02)
	//			EndIF
	     (cTbl)->(dbSkip())
	   EndDo
	   (cTbl)->(dbCloseArea())
	EndIf


	Return Nil
Static Function CriaSx1(cPerg)
*----------------------------------------------------------------------------------------------*

	PutSX1(cPerg,"01","Orcamento ?","","","mv_ch1","C",06,0,0,"G","","SL1","","","mv_par01")
	PutSX1(cPerg,"02","Filial ?","",""      ,"mv_ch3","C",02,0,0,"G","","   ","","","mv_par02")
	PutSX1(cPerg,"03","Ate Orcamento?","","","mv_ch4","C",06,0,0,"G","","SL1","","","mv_par03")
	Return Nil

Static Function GeraTeste()
Local _cdQry := ""       

_cdTbl := getNextAlias()

_cdQry += " select top 1 L1_FILIAL,L1_NUM from SL1010"
_cdQry += " WHERE L1_ENTREGA = 'S'       " 
_cdQry += " AND L1_FILIAL = '03'         " 
_cdQry += " aND D_E_L_E_T_ = ''"
_cdQry += " AND L1_EMISSAO >= '" + dtos(ddatabase) + "' " 

_cdQry += " ORDER BY L1_NUM "

dbUseArea(.T.,"TopConn",tcGenQry(,,ChangeQuery(_cdQry)),_cdTbl,.T.,.T.)

Return _cdTbl