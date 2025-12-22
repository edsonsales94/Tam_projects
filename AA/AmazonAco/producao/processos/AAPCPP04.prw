#include 'protheus.ch'
#include 'parmtype.ch'

User Function AAPCPP04()

   	 //_xdVar := ReadVar() 
   	 _xdStatus  := M->C2_STATUS
   	 _xdRecurso := M->C2_RECURSO
   	 //UNIM2201001
   	 
   	 _xQry := ""
   	 _xQry += " Select * From " + RetSqlName("SC2") + " C2 "
   	 _xQry += "  Where C2.D_E_L_E_T_ = ' ' "
   	 _xQry += "  C2_RECURSO = '" + _xdRecurso + "'" 
   	 _xQry += "  C2_STATUS != 'U' "
   	 _xQry += "  C2_FILIAL = '" + xFilial('SC2') + "'"
   	 
   	 _xsTbl := GetNextAlias()
	 MPSysOpenQuery(_xdSD3,_xsTbl)
	 
	 _cdOPs := ""
	 ndOps := 0
   	 While !(_xsTbl)->(Eof())
   	     _cdOPs += If(Empty(_cdOPs),"","/")
   	     _cdOPs += (_xsTbl)->C2_NUM + (_xsTbl)->C2_ITEM + (_xsTbl)->C2_SEQUEN
   	     ndOps++   	     
   	     (_xsTbl)->(dbSkip())
   	 EndDo
   	  
   	 (_xsTbl)->(dbCloseArea(_xsTbl))
   	 
   	 iF ndOps > 0
   	    _ldRet := .F.
   	    Aviso('Atenção',' A Maquina Já está Alocado para a seguinte OP: ' + _cdOps + ;
   	     				 Chr(13)+ Chr(10) + " Suspender a OP em questão ou escolher outra Maquina! ",{'OK'} )
   	 EndIf
Return _ldRet
