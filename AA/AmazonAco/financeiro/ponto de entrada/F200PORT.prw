#include "Protheus.ch"

******************************************************************************************************
******************************************************************************************************
****** Data        *** Autor   *** Descricao *********************************************************
******************************************************************************************************
****** 09/08/2017  ***         *** Adicionado a regra para ignorar a empresa 06 para utilizar a    ***
******             *** Diego   *** Conta informada no parametro e não a conta informada no arquivo ***
****** 09/08/2017  ***         *** pois estava gerando problema na conciliacao devido a conta esta ***
******             *** Rafael  *** cadastrada no sistema sem o digito verificador e no arquivo vem ***
****** 09/08/2017  ***         *** com o digito informado,pois apesar de o P.E. retornar .F. as    ***
******             ***         *** variavel cconta e private                                       ***
******************************************************************************************************
******************************************************************************************************

User Function F200PORT()
  Local lRet  := .F.
  
  If mv_par12 == 1   // Modelo 1
		If File(mv_par04)
			
			FT_FUSE(mv_par04)
			FT_FGOTOP()
			
			cLinha := FT_FReadLN()
			
			if SubStr(cLinha,77,3) == "341" .And. !Alltrim(FwCodEmp())$'06'
				cBanco      := SubStr(cLinha,77,3)
				cAgencia    := SubStr(cLinha,27,4) + Space(1)
				cConta      := SubStr(cLinha,33,5) + "-" + SubStr(cLinha,38,1) + Space(3)
			EndIf
		EndIf
		
		FT_FUSE()
	Else
	Endif
  
Return .F.   // Define para não alterar pois isso será feito pelo ponto de entrada F200VAR 