#include 'totvs.ch'

/*/{Protheus.doc} AAFINP05

    Efetua a Conciliação bancária automaticamente via rest
    @type  Diego
    @author user
    @since 20/01/2023
    @version version
    @param xdRecno, N, Recno do registro noo SE5 para efetuar a conciliação
           lConcilia, L, Define se é para conciliar ou desconciliar
           XE5_DTDISPO,D, Data Disponibilidade do valor 
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function AAFINP05(xdRecno, lConcilia, XE5_DTDISPO)
   
   Local cFilAtu   := cFilAnt
   Local dOldDispo := CTOD('')
   Local lAtuSaldo := .F.
   Local cReconAnt := ""
   ConOUt("[AAFINP05] Inicio")
   SE5->(dbGoTo(xdRecno))
   Default XE5_DTDISPO := IiF(Empty(SE5->E5_DTDISPO),SE5->E5_DATA,SE5->E5_DTDISPO)
   //Caso a filial não seja totalmente compartilhada ajusto cFilAnt
	If FWModeAccess("SE5",3)== "C"
		//Se filial de origem preenchida
	    If !Empty(SE5->E5_FILORIG)
			cFilAnt := SE5->E5_FILORIG
		Else
		//Se filial de origem vazia (inconsistência de base)
			SM0->(dbSetOrder(1))
			SM0->(MsSeek(cEmpAnt+Alltrim(xFilial("SE5",SE5->E5_FILIAL))))
			cFilAnt := SM0->M0_CODFIL
		Endif
	Else // Se a Filial é totalmente exclusiva, deve usar o _FILIAL
		cFilAnt := SE5->E5_FILIAL				
	Endif
/*
    lConcMov := lConcilia .And. Empty(SE5->E5_RECONC)
    lDesconciliaMov := !lConcilia .And. !Empty(SE5->E5_RECONC)
*/
    cReconAnt := SE5->E5_RECONC
    //lConc := lConcilia .And. Empty(SE5->E5_RECONC)

	FKA->(dbSetOrder(3))
			
	//Posiciona a FKA com base no IDORIG da SE5 posicionada
	If SE5->E5_TABORI == "FK1"
		FKA->(dbseek(SE5->E5_FILIAL+"FK1"+SE5->E5_IDORIG))	
	ElseIf SE5->E5_TABORI == "FK2" 
		FKA->(dbseek(SE5->E5_FILIAL+"FK2"+SE5->E5_IDORIG))	
	Else
		FKA->(dbseek(SE5->E5_FILIAL+"FK5"+SE5->E5_IDORIG))	
	Endif	
    
    cIdProc := FKA->FKA_IDPROC
			
	FKA->(dbSetOrder(2))
	FKA->(dbseek(FKA->FKA_FILIAL+cIdProc))
			
	While FKA->(!EOF()) .AND. FKA->FKA_IDPROC == cIdProc
			
		If FKA->FKA_TABORI == "FK5"
		    cIdOrig := FKA->FKA_IDORIG
			cFilFKA := FKA->FKA_FILIAL
		Endif
		FKA->(dbskip())
	Enddo

    FK5->(dbSetOrder(1))
	FK5->(dbseek(cFilFKA+cIdOrig))
    ConOUt("[AAFINP05] Concilia?" + iIF(lCOncilia,"SIm","Nao"))
    Reclock("FK5", .F.)
	If lConcilia
	    FK5->FK5_DTCONC :=  dDataBase
	EndIf
    If !lConcilia
	    FK5->FK5_DTCONC :=  CTOD("") 
	Endif

    If SE5->E5_DTDISPO # XE5_DTDISPO
	    dOldDispo := SE5->E5_DTDISPO
		lAtuSaldo := .T.
		FK5->FK5_DTDISP :=  XE5_DTDISPO
	Endif
    FK5->(MsUnlock())

    
    If SE5->E5_TIPODOC <> "DB"
		AltDtFilho( XE5_DTDISPO )
	EndIf
    
    ConOUt("[AAFINP05] Atualizando Reconc")
    Reclock("SE5", .F.)
	SE5->E5_RECONC := IIf(lConcilia,"x"," ")
	If SE5->E5_DTDISPO <> XE5_DTDISPO
		SE5->E5_DTDISPO := XE5_DTDISPO
	EndIf
	SE5->(MsUnlock())	

    AtChqFil(lAtuSaldo, XE5_DTDISPO)
    //Verifico atualizacao do saldo conciliado
    DO CASE
        CASE Empty(cReconAnt) .and. !Empty(SE5->E5_RECONC)
            nReconc := 1 	//Se foi reconciliado agora 			
        CASE !Empty(cReconAnt) .and. Empty(SE5->E5_RECONC)
            nReconc := 2 	//Se foi desconciliado agora
        CASE !Empty(cReconAnt) .and. !Empty(SE5->E5_RECONC)
        nReconc := 3	//Nao foi alterada a situacao anterior, mas ja estava conciliado
    CASE Empty(cReconAnt) .and. Empty(SE5->E5_RECONC)		
        nReconc := 3	//Nao foi alterada a situacao anterior, mas nao estava conciliado
    END CASE
    ConOUt("[AAFINP05] Atualizando Saldo Bancario")
    lAtuSaldo := AtSaldoBCO(lAtuSaldo, nReconc, dOldDispo)	
    
    cFilAnt := cFilAtu
    ConOUt("[AAFINP05] Concluido")
Return .t.

Static Function AtSaldoBCO(lAtuSaldo, nReconc, dOldDispo)

If lAtuSaldo  // atualiza saldo bancario se alterou o E5_DTDISPO
    lAtuSaldo := .F.

    //Atualiza saldo conciliado na data antiga
    lAtSalRec1 := IIF( !Empty(SE5->E5_RECONC) .AND. (nReconc == 2 .or. nReconc == 3), .T., .F.)
    //Atualiza saldo conciliado na data nova
    lAtSalRec2 := IIF( !Empty(SE5->E5_RECONC) .AND. nReconc != 4, .T., .F.)

    If SE5->E5_RECPAG == "P"
        AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dOldDispo,SE5->E5_VALOR,"+",lAtSalRec1)
        AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"-",lAtSalRec2)
    Else
        AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dOldDispo,SE5->E5_VALOR,"-",lAtSalRec1)
        AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"+",lAtSalRec2)
    Endif
Else
    //Atualiza apenas o saldo reconciliado
    If nReconc == 2	//Desconciliou
        If Alltrim(SE5->E5_TIPODOC) $ "TR;BD"
            nValTit := SE5->E5_VALOR
            aAreaSE5	:= SE5->( GetArea() )
            dbSelectArea("SE5")
            SE5->(dbsetorder(2))
            if SE5->(dbseek(SE5->E5_FILIAL+"I2"+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+DTOS(E5_DATA)+ SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ))
                nValTit += SE5->E5_VALOR 
            EndIf
            RestArea( aAreaSE5 )
            AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,nValTit,IIF(SE5->E5_RECPAG == "P","+","-"),.T.,.F.)
        Else
            AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,IIF(SE5->E5_RECPAG == "P","+","-"),.T.,.F.)
        EndIf			
    Endif
    If nReconc == 1	//Conciliou
        If Alltrim(SE5->E5_TIPODOC) $ "TR;BD"
            nValTit := SE5->E5_VALOR
            aAreaSE5	:= SE5->( GetArea() )
            dbSelectArea("SE5")
            SE5->(dbsetorder(2))
            if SE5->(dbseek(SE5->E5_FILIAL+"I2"+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+DTOS(E5_DATA)+ SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ))
                nValTit += SE5->E5_VALOR 
            EndIf
            RestArea( aAreaSE5 )
            AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,nValTit,IIF(SE5->E5_RECPAG == "P","-","+"),.T.,.F.)
        Else
            AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,IIF(SE5->E5_RECPAG == "P","-","+"),.T.,.F.)
        EndIf			
    Endif
Endif

return lAtuSaldo

Static Function AtChqFil(lAtuSaldo,XE5_DTDISPO)
    //Acerto E5_DTDISPO dos titulos baixados com cheque para melhor apresentacao no
    //relatorio de fluxo de caixa realizado
    Local XE5_RECNO := SE5->(Recno())

    If lAtuSaldo .AND. !EMPTY(SE5->E5_NUMCHEQ)
        dbSelectArea("SE5")							
        dbSetOrder(11)
        If MsSeek(xFilial("SE5")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ))
            cKeyCheque := SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
            While SE5->(!Eof()) .and. cKeyCheque == SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
                If lF380AlDt	
                    lAltDt:=ExecBlock("F380AlDt",.F.,.F.)
                EndIf	
                If lAltDt
                    If SE5->( Recno() ) == XE5_RECNO .Or. lF380AlDt
                        //Posiciona a FK5 com base no IDORIG da SE5 posicionada
                        dbSelectArea("FK5")							
                        dbSetOrder(1)
                        FK5->(dbseek(xFilial("SE5")+SE5->E5_IDORIG))
                        
                        Reclock("FK5", .F.)
                        FK5->FK5_DTDISP :=  XE5_DTDISPO
                        FK5->(MsUnlock())
                    EndIf
                EndIf	
                
                SE5->(dbSkip())
            Enddo
        Endif
        SE5->(dbGoTo( XE5_RECNO ))
    Endif
return 



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AltDtFilho ³ Autor ³ Daniel Mendes      . ³ Data ³ 06/08/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza a data E5_DTDISPO dos títulos filhos do principal ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fina380                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AltDtFilho( dDataConc )
Local cChaveSE5 := ""
Local cFilSE5   := ""
Local aTipos    := { "VL","CM","CX","DC","MT","JR","V2","C2","D2","M2","J2","BA","TL","LJ","RA" }
Local aArea     := {}
Local aAreaSE5  := {}
Local nFor      := 0
Local cLote		:= ""
Local cRecPag	:= "" 

aArea     := GetArea()
aAreaSE5  := SE5->( GetArea() )
cFilSE5   := SE5->E5_FILIAL
cLote	  := SE5->E5_LOTE
cRecpag	  := SE5->E5_RECPAG

IF !SE5->E5_TIPODOC == "CH"
	cChaveSE5 := SE5->( E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + DtoS(E5_DATA) + E5_CLIFOR + E5_LOJA + E5_SEQ )
	If !Empty(SE5->( E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO))
	
		SE5->( MsUnLock() )
		SE5->( dbSetOrder( 2 ) )//E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
	
		For nFor := 1 To Len( aTipos ) 
			If SE5->( MsSeek( cFilSE5 + aTipos[ nFor ] + cChaveSE5 ) )
				RecLock( "SE5" , .F. )
				SE5->E5_DTDISPO := dDataConc
				SE5->( MsUnLock() )
			EndIf
		Next nFor
	Else
		If !Empty(cLote)
			SE5->( MsUnLock() )
			SE5->( dbSetOrder( 5 ) )//E5_FILIAL+E5_LOTE+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)                                                                                         
			If SE5->( MsSeek( cFilSE5 + cLote ) )
				While SE5->(!Eof()) .And. SE5->E5_LOTE == cLote
				  
					If ( SE5->E5_DTDISPO < dIniDt380 .Or. SE5->E5_DTDISPO > dFimDt380)
						SE5->(dbSkip())
						Loop
					EndIf
						 
					If SE5->E5_RECPAG <> cRecPag
						SE5->(dbSkip())
						Loop
					EndIf
					RecLock( "SE5" , .F. )
					SE5->E5_DTDISPO := dDataConc
					SE5->( MsUnLock() )
			
					SE5->(dbSkip())
					Loop	
				End
			EndIf
		EndIf
	EndIf
Else
	If !Empty(SE5->E5_NUMCHEQ)
		cChaveSE5 := SE5->( E5_FILIAL + E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ + DtoS(E5_DATA) )
	
		SE5->( MsUnLock() )
		SE5->( dbSetOrder( 11 ) ) 
		SE5->(dbSeek(cFilSE5 + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ + DtoS(SE5->E5_DATA)))
	
		While SE5->(!Eof()) .and. cFilSE5 + SE5->( E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ + DtoS(E5_DATA) ) == cChaveSE5
			  If SE5->E5_TIPODOC $ "VL/CM/CX/DC/MT/JR/V2/C2/D2/M2/J2/BA/TL/LJ/RA"
					RecLock( "SE5" , .F. )
					SE5->E5_DTDISPO := dDataConc
					SE5->( MsUnLock() )
			  Endif	
			SE5->(dbSkip())
		Enddo
	Else
		If !Empty(cLote)
			SE5->( MsUnLock() )
			SE5->( dbSetOrder( 5 ) )//E5_FILIAL+E5_LOTE+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)                                                                                         
			If SE5->( MsSeek( cFilSE5 + cLote ) )
				While SE5->(!Eof()) .And. SE5->E5_LOTE == cLote
				
					If ( SE5->E5_DTDISPO < dIniDt380 .Or. SE5->E5_DTDISPO > dFimDt380)
						SE5->(dbSkip())
						Loop
					EndIf
					
					RecLock( "SE5" , .F. )
					SE5->E5_DTDISPO := dDataConc
					SE5->( MsUnLock() )
					SE5->(dbSkip())
					Loop	
				End
			EndIf
		EndIf	
	EndIf
Endif	

RestArea( aAreaSE5 )
RestArea( aArea    )
RecLock( "SE5" ) //Devolvo no mesmo estado que a função foi chamada

Return Nil
