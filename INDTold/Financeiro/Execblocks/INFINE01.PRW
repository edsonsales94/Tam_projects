#Include "Rwmake.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ INFINE01   ¦                              ¦ Data ¦ 21/03/05               ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Função para validacao da classe MCT na inclusão das depesas pelo compras, ¦¦¦
¦¦¦           ¦ financeiro e multi-naturezas                                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ .T. ou .F.                                                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function INFINE01(cCLVL,cAlias)
   Local nPCLVL, nPItem, nPTrei, nPViag, nPDCLV
   Local cVar := Upper(Trim(ReadVar()))
   Local lRet := .T.

   If cVar $ "M->C1_CLVL,M->C7_CLVL,M->D1_CLVL"  //- Validando compras

      If cAlias == "SC1" //- Solicitacao de compras
         nPCLVL := Ascan( aHeader, {|y| Trim(y[2]) == "C1_CLVL"    })
         nPItem := Ascan( aHeader, {|y| Trim(y[2]) == "C1_ITEMCTA" })
         nPTrei := Ascan( aHeader, {|y| Trim(y[2]) == "C1_TREINAM" })
         nPViag := Ascan( aHeader, {|y| Trim(y[2]) == "C1_VIAGEM"  })
         nPDCLV := Ascan( aHeader, {|y| Trim(y[2]) == "C1_DESCCLV" })
      ElseIf cAlias == "SC7" //- Requisicao de compras
         nPCLVL := Ascan( aHeader, {|y| Trim(y[2]) == "C7_CLVL"    })
         nPItem := Ascan( aHeader, {|y| Trim(y[2]) == "C7_ITEMCTA" })
         nPTrei := Ascan( aHeader, {|y| Trim(y[2]) == "C7_TREINAM" })
         nPViag := Ascan( aHeader, {|y| Trim(y[2]) == "C7_VIAGEM"  })
         nPDCLV := Ascan( aHeader, {|y| Trim(y[2]) == "C7_DESCCLV" })
      Else                  //- Itens da NF de entrada por compras
         nPCLVL := Ascan( aHeader, {|y| Trim(y[2]) == "D1_CLVL"    })
         nPItem := Ascan( aHeader, {|y| Trim(y[2]) == "D1_ITEMCTA" })
         nPTrei := Ascan( aHeader, {|y| Trim(y[2]) == "D1_TREINAM" })
         nPViag := Ascan( aHeader, {|y| Trim(y[2]) == "D1_VIAGEM"  })
         nPDCLV := Ascan( aHeader, {|y| Trim(y[2]) == "D1_DESCCLV" })
      Endif

      cMCT := AllTrim(&(cVar))

      If lRet := (cMCT $ cCLVL)
         If cMCT == "006" // Viagem
            lRet := ValidCampo(aCols[n,nPItem],aCols[n][nPViag],cMCT)
         ElseIf cMCT == "007" // Treinamento
            lRet := ValidCampo(aCols[n,nPItem],aCols[n][nPTrei],cMCT)
         Endif
      Else
         Alert("Nao é possivel incluir despesas com essa classe MCT por este módulo !")
      Endif
  ElseIf cVar == "M->E2_CLVL" //- Validando financeiro  
    
	     cMCT := AllTrim(M->E2_CLVL)
	
	     If lRet := (cMCT $ cCLVL)
	        If M->E2_MULTNAT == "2"
	           If cMCT == "006"  // Viagem
	              If lRet := ValidCampo(M->E2_ITEMCTA,M->E2_VIAGEM,cMCT)
	                 M->E2_TREINAM := Space(Len(M->E2_TREINAM))
	              Endif
	           ElseIf cMCT == "007"  // Treinamento
	              If lRet := ValidCampo(M->E2_ITEMCTA,M->E2_TREINAM,cMCT)
	                 M->E2_VIAGEM := Space(Len(M->E2_VIAGEM))
	              Endif
	           Endif
	        Endif
	     ElseIf lRet := (Trim(M->E2_TIPO) == "PA")
	  
	     Else
	        Alert("Nao é possível incluir despesa com essa classe MCT por este módulo !")
	     Endif
  ElseIf cVar $ "M->EZ_CLVL,M->EZ_ITEMCTA" //- Reteio por multiplos centro de custos
     If lRet := !(Alltrim(M->EZ_CLVL) $ cCLVL .And. Empty(aCols[n][4]))
     Else
        Alert("Favor informar o colaborador para esta classe MCT !")
     Endif
  Endif

Return lRet

Static Function ValidCampo(cItem,cCampo,cMCT)
   Local lRet := .T.

   If lRet := !Empty(cItem)
      If lRet := !Empty(cCampo)
      Else
         Alert("Favor informar o codigo d"+If(cMCT=="006","a viagem","o treinamento")+" para esta classe MCT !")
      Endif
   Else
      Alert("Favor informar o colaborador para esta classe MCT !")
   Endif

Return lRet
