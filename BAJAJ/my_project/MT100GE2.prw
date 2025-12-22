#INCLUDE "RwMake.ch"
#DEFINE ALIASCNAB "SE2"

/*/{Protheus.doc}MT100GE2
@description
Este ponto de entrada tem o objetivo de Complementar a Gravação dos Títulos Financeiros a Pagar
@author	Marcel Robinson Grosselli	
@version	1.0
@since		25/04/2018
@return		aRet,Array,Obrigatório,Vetor contendo os campos que deverão ser incluídos ao aHeader de títulos financeiros,
deverão ser criados na mesma estrutura dos campso padrões.
@param 		PARAMIXB[1],Vetor,ACols dos títulos financeiro a pagar.
@param 		PARAMIXB[2],Numerico,1=inclusão de títulos 2=exclusão de títulos.
@param 		PARAMIXB[3],Vetor,AHeader dos titulos financeiros a pagar
/*/


User Function MT100GE2()
Local aCols   := PARAMIXB[1]
Local nOpc    := PARAMIXB[2]
Local aHeadSE2:= PARAMIXB[3]
Local nPosLd:=0
Local nPosCb:=0
Local nPosFp:=0
Local nPosHi:=0
Local nPosDa:=0
Local nPosAc:=0
Local nPosFp:=0
Local aArea     := GetArea()

If nOpc == 1                                   

	SXA->( DbSetOrder(1) ) // XA_ALIAS+XA_ORDEM
	SXA->( DbSeek(ALIASCNAB) )
	While ( SXA->(!Eof()) .And. SXA->XA_ALIAS==ALIASCNAB )
		If Alltrim(SXA->XA_DESCRIC)=="Dados Gerais"  
			DbSelectArea('SX3')
			DbSetOrder(4) // X3_ARQUIVO+X3_FOLDER+X3_ORDEM
			DbSeek(ALIASCNAB+SXA->XA_ORDEM)
			while ( SX3->(!Eof()) .And. X3_ARQUIVO+X3_FOLDER==ALIASCNAB+SXA->XA_ORDEM  )
					nPosHi:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_HIST"  })
					nPosCart:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_XCARTAO"  })
					nPosFp :=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_XFILPAG"  })
					
				If Alltrim(SX3->X3_CAMPO)=="E2_HIST"
					If EMPTY(aCols[nPosHi])
        				SE2->E2_HIST:= substr(GetHist(),1,100)
					Else
						SE2->E2_HIST:=aCols[nPosHi]
					Endif
				ElseIf Alltrim(SX3->X3_CAMPO)=="E2_XCARTAO"
					SE2->E2_XCARTAO:=aCols[nPosCart]
				
				ElseIf Alltrim(SX3->X3_CAMPO)=="E2_XFILPAG"
					If EMPTY(aCols[nPosFp])
        				SE2->E2_XFILPAG := cFilAnt
					Else
						SE2->E2_XFILPAG := aCols[nPosFp]			
					Endif
				EndIf                     
				
				SX3->(dbSkip())
			End
		EndIf
		SXA->(dbSkip())
	EndDo               
   
	SXA->(dbgotop())
	SX3->(dbgotop())

	SXA->( DbSetOrder(1) ) // XA_ALIAS+XA_ORDEM
	SXA->( DbSeek(ALIASCNAB) )
	While ( SXA->(!Eof()) .And. SXA->XA_ALIAS==ALIASCNAB )
		If Alltrim(SXA->XA_DESCRIC)=="Banco"  
			DbSelectArea('SX3')
			DbSetOrder(4) // X3_ARQUIVO+X3_FOLDER+X3_ORDEM
			DbSeek(ALIASCNAB+SXA->XA_ORDEM)
			while ( SX3->(!Eof()) .And. X3_ARQUIVO+X3_FOLDER==ALIASCNAB+SXA->XA_ORDEM  )
					nPosLd:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_LINDIG"  })
					nPosCb:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_CODBAR"  })
					nPosDa:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_DATAAGE"  })					
				  	nPosFopag :=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_FORMPAG"  })
		
				If Alltrim(SX3->X3_CAMPO)=="E2_LINDIG"
					SE2->E2_LINDIG:=aCols[nPosLd]
				elseif	ALLTRIM(SX3->X3_CAMPO)=="E2_CODBAR" 
					SE2->E2_CODBAR:=aCols[nPosCb]
				elseif	ALLTRIM(SX3->X3_CAMPO)=="E2_DATAAGE"                            
					SE2->E2_DATAAGE:=SE2->E2_VENCREA
				Elseif Alltrim(SX3->X3_CAMPO)=="E2_FORMPAG"
					SE2->E2_FORMPAG:=(GETMV("MV_XBANPAD"))
					//SE2->E2_FORMPAG:=IIF(!EMPTY(aCols[nPosCb]),IIF(SUBSTR(aCols[nPosCb],1,3)==ALLTRIM(GETMV("MV_XBANPAD")),"30","31"),U_MPFINE01())
				EndIf                     
				
				SX3->(dbSkip())
			End
		EndIf
		SXA->(dbSkip())
	EndDo           
	
		SXA->(dbgotop())
	SX3->(dbgotop())
	
	SXA->( DbSetOrder(1) ) // XA_ALIAS+XA_ORDEM
	SXA->( DbSeek(ALIASCNAB) )
	While ( SXA->(!Eof()) .And. SXA->XA_ALIAS==ALIASCNAB )
		If Alltrim(SXA->XA_DESCRIC)=="Contábil"  
			DbSelectArea('SX3')
			DbSetOrder(4) // X3_ARQUIVO+X3_FOLDER+X3_ORDEM
			DbSeek(ALIASCNAB+SXA->XA_ORDEM)
			while ( SX3->(!Eof()) .And. X3_ARQUIVO+X3_FOLDER==ALIASCNAB+SXA->XA_ORDEM  )
					nPosAc:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == "E2_CCUSTO"  })
		
				If Alltrim(SX3->X3_CAMPO)=="E2_CCUSTO"
						SE2->E2_CCUSTO:=aCols[nPosAc]
				EndIf                     
				
				SX3->(dbSkip())
			End
		EndIf
		SXA->(dbSkip())
	EndDo           
	
EndIf

RestArea(aArea)

Return Nil

Static Function GetHist()
    Local cHist := ""

    BeginSql Alias "QRY"
        SELECT
            TOP 1 A.HIST
        FROM
        (SELECT 
            D1_FILIAL
            ,D1_DOC
            ,D1_SERIE
            ,D1_FORNECE
            ,D1_LOJA
            ,D1_PEDIDO
            ,ISNULL((SELECT TOP 1 RTRIM(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),CR_OBS ))) FROM SCR010 WHERE D_E_L_E_T_ = '' AND CR_NUM = D1_PEDIDO AND CR_FILIAL = D1_FILIAL),'') AS 'HIST'
			//,ISNULL((SELECT TOP 1 RTRIM(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),CR_XOBS1))) FROM SCR010 WHERE D_E_L_E_T_ = '' AND CR_NUM = D1_PEDIDO AND CR_FILIAL = D1_FILIAL),'') AS 'HIST'
        FROM SD1010 SD1
        WHERE
            SD1.D_E_L_E_T_ = ''
            AND D1_FILIAL  = %Exp:SE2->E2_FILORIG%
            AND D1_SERIE   = %Exp:SE2->E2_PREFIXO%
            AND D1_DOC     = %Exp:SE2->E2_NUM%) AS A
    EndSql

    cHist := QRY->HIST 
    QRY->(DbCloseArea())
Return cHist

