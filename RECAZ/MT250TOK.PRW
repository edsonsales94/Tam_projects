#INCLUDE 'TOTVS.CH'
#include "Protheus.CH"
#INCLUDE "RWMAKE.CH"
#include "TopConn.ch"

User Function MT250TOK()
	Private lAtuEmp := .F.//ParamIXB

	DBSELECTAREA('SD4')
	DBSETORDER(2)

	iF SD4->(MSSEEK(XFILIAL('SD4')+M->D3_OP))
		while !SD4->(EOF()) .AND. M->D3_OP == SD4->D4_OP
			DBSELECTAREA('SB1')
			DBSETORDER(1)
			IF  SB1->(MSSEEK(XFILIAL('SB1')+SD4->D4_COD))
				if SB1->B1_TIPO == 'MO' .OR. ALLTRIM(SB1->B1_CCCUSTO) =='5090'
					cCodMod := IIF(LEFT(SB1->B1_COD,1)=='M', SB1->B1_COD, cCodMod)
					cDescMod := IIF(LEFT(SB1->B1_COD,1)=='M', SB1->B1_DESC, cDescMod)
					cCodGGF := IIF(LEFT(SB1->B1_COD,1)=='G', SB1->B1_COD, cCodGGF )
					cDescGGF := IIF(LEFT(SB1->B1_COD,1)=='M', SB1->B1_DESC, cDescGGF)
				endif
			ENDIF
			SD4->(DBSKIP())
		endDo
	ENDIF

	// tela para informar a MOD e GGF para atualizar o custo unitario na SB2
	FTELAMOD()

	if lAtuEmp
		FWAlertSuccess('Valores de MOD e GGF alterados com sucesso.', 'Sucesso!')
	Else
		FwAlertWarning('Valores de MOD e GGF não foram alterados, Informe o valor da MOD e GGF para calculo correto dos valores no apontamento.', 'Atenção!')
		FwAlertError('O apontamente foi recusado.', 'Falha no apontamento!')
	endif
	// lAtuEmp := .F.
Return lAtuEmp

Static function FTELAMOD()

	Local aArea         := GetArea()
	Private nVLRMod := 0
	Private nVLRGGF := 0
	Private oPed

	@ 275,235 TO 496,880 DIALOG oPed TITLE OemToAnsi("Informe o Valor: MOD & GGF")

	// Área MOD
	@ 5,2  TO 41,292  TITLE OemToAnsi("MOD: " + cCodMod + " - " + cDescMod)

	// Campo MOD
	@ 15,10 SAY OemToAnsi("Valor Unit:")
	@ 15,80 MSGET nVLRMod SIZE 80,12 OF oPed PIXEL ;
		PICTURE '@E 999,999,999.99' //VALID( lValid(nVLRMod,1) )

	// Área GGF
	@ 45,2 TO 81,292 TITLE OemToAnsi("GGF: " + cCodGGF + " - " + cDescGGF)

	// Campo GGF
	@ 55,10 SAY OemToAnsi("Valor Unit:")
	@ 55,80 MSGET nVLRGGF SIZE 80,12 OF oPed PIXEL ;
		PICTURE '@E 999,999,999.99' //VALID( lValid(nVLRGGF,2) )

	// Botões
	@ 90,175 BUTTON OemToAnsi("Salvar") SIZE 55,20 ;
		ACTION lProcess(.T., cCodMod, cCodGGF, nVLRMod, nVLRGGF)

	@ 90,250 BUTTON OemToAnsi("Fechar") SIZE 55,20 ;
		ACTION lProcess(.F., cCodMod, cCodGGF, nVLRMod, nVLRGGF)

	Activate Dialog oPed CENTERED

	RestArea(aArea)
	*
Return

// Static Function lvalid(nVal,nopc)
// 	if Empty(nval)
// 		FwAlertWarning('O Valor de '+iif(nopc==1, 'MOD','GGF')+' precisar ser informado.', 'Atenção')
// 		return .F.
// 	endif
// Return .T.

/*  ROTINA QUE VAI GRAVAR O CUSTO DO MOD E GGF NA SB2*/
Static Function lProcess(lSlv,cCodMod,cCodGGF,nVLRMod,nVLRGGF)
	Local nx := 0
	Local aProds := {{cCodMod,nVLRMod},{cCodGGF,nVLRGGF}}

	if lSlv
		if Empty(nVLRMod) .OR. Empty(nVLRGGF)
 			FwAlertWarning('O Custo unitario do '+iif(Empty(nVLRMod), 'MOD','GGF')+' precisar ser informado.', 'Atenção')
			return 
		endif

		for nx:=1 to Len(aProds)
			dbSelectArea('SB2')
			dbSetOrder(1)

			SB2->(MSSEEK(xFilial('SB2')+APRODS[nx,1]))
			SB2->(RECLOCK('SB2',.F.))
			// SB2->B2_CM1 := APRODS[nx,2] / M->D3_QUANT
			SB2->B2_CM1 := APRODS[nx,2]
			SB2->(MSUNLOCK())
		next nx

		// ALTERA VALIDAÇÃO PARA O PE
		lAtuEmp := .T.
		Close(oPed)
	else
		// ALTERA VALIDAÇÃO PARA O PE
		lAtuEmp := .F.
		Close(oPed)
	endif
Return
