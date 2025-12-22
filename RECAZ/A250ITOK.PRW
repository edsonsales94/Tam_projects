#INCLUDE 'TOTVS.CH'
#include "Protheus.CH"
#INCLUDE "RWMAKE.CH"
#include "TopConn.ch"

User Function A250ITOK()
	Private lAtuEmp := .F.//ParamIXB

	DBSELECTAREA('SD4')
	DBSETORDER(2)

	iF SD4->(MSSEEK(XFILIAL('SD4')+M->D3_OP))
		while !SD4->(EOF()) .AND. M->D3_OP == SD4->D4_OP
			DBSELECTAREA('SB1')
			DBSETORDER(1)
			IF  SB1->(MSSEEK(XFILIAL('SB1')+SD4->D4_COD))
				if SB1->B1_TIPO == 'MO' .OR. ALLTRIM(SB1->B1_CCCUSTO) =='5090'
					cMod := IIF(LEFT(SB1->B1_COD,1)=='M', SB1->B1_COD, cMod)
					cDescMod := IIF(LEFT(SB1->B1_COD,1)=='M', SB1->B1_DESC, cDescMod)
					cGGF := IIF(LEFT(SB1->B1_COD,1)=='G', SB1->B1_COD, cGGF )
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
		FwAlertWarning('Valores de MOD e GGF não foram alterados, AO SALVAR um apontamento informe o valor da MOD e GGF.', 'Falha no apontamento!')
	endif
	lAtuEmp := .F.
Return lAtuEmp

Static function FTELAMOD()

	Local aArea         := GetArea()
	Private nMod := 0
	Private nGGF := 0
	Private oPed

	@ 275,235 To 496,880 Dialog oPed Title OemToAnsi("Informe o Valor TOTAL: MOD & GGF")
	@ 5,2  To 41,292  Title OemToAnsi("MOD: " + cMod + ' - ' + cDescMod)
	@ 45,2 To 41,292  Title OemToAnsi("GGF: " + cGGF + " - " + cDescGGF)
	// @ 45,100 To 74,160 Title OemToAnsi("LOJA:")
	// @ 45,180 To 74,240 Title OemToAnsi("COND PAGTO:")
	// @ 75,2 To 79,311
	@ 20,10   MSGET nMod Size 100,10   OF oPed PIXEL PICTURE '@E 999,999,999.99'  VALID(lValid(nMod,1))
	@ 57,7    MSGET nGGF Size 100,10   OF oPed PIXEL PICTURE '@E 999,999,999.99'  VALID(lValid(nMod,2))

	// @ 18,224 Button OemToAnsi("Carregar arquivo CSV") Size 60,16 Action HLAPROC()
	@ 85,175 Button OemToAnsi("Salvar")          Size 55,20 Action lProcess(.T.,cMod,cGGF,nMod,nGGF)
	@ 85,250 Button OemToAnsi("Fechar")          Size 55,20 Action lProcess(.F.,cMod,cGGF,nMod,nGGF)

	Activate Dialog oPed  CENTERED

	RestArea(aArea)
	*
Return

Static Function lvalid(nVal,nopc)
	if Empty(nval)
		FwAlertWarning('O Valor de '+iif(nopc==1, 'MOD','GGF')+' precisar ser informado.', 'Atenção')
		return .F.
	endif
Return .T.

/*  ROTINA QUE VAI GRAVAR O CUSTO DO MOD E GGF NA SB2*/
Static Function lProcess(lSlv,cMod,cGGF,nMod,nGGF)
	Local nx := 0
	Local aProds := {{cMod,nMod},{cGGF,nGGF}}

	if lSlv
		for nx:=1 to Len(aProds)
			dbSelectArea('SB2')
			dbSetOrder(1)

			SB2->(MSSEEK(xFilial('SB2')+APRODS[nx,1]))
			SB2->(RECLOCK('SB2',.F.))
			SB2->B2_CM1 := APRODS[nx,2] / M->D3_QUANT
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
