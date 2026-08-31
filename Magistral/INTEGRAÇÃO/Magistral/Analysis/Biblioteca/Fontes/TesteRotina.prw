#Include "Protheus.ch"
#Include "Tbiconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGFATJ01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 14/11/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Serviço de importação das vendas do sistema Magistral         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TesteRotina(aEmpFil)
	
	Default aEmpFil := { "01", "0101"}
	
	PREPARE ENVIRONMENT EMPRESA aEmpFil[1] FILIAL aEmpFil[2] MODULO "FAT" TABLES "SC5", "SC6", "SA1", "SB1", "F2Q"
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1"),.T.))
	While !SB1->(Eof()) .And. SB1->B1_FILIAL == XFILIAL("SB1")
		
		If SB1->B1_TIPO $ "PA,PI"
			F2Q->(dbSetOrder(1))
			If F2Q->(dbSeek(XFILIAL("F2Q")+SB1->B1_COD))
				RecLock("F2Q",.F.)
			Else
				RecLock("F2Q",.T.)
				F2Q->F2Q_FILIAL := XFILIAL("F2Q")
				F2Q->F2Q_PRODUT := SB1->B1_COD
			Endif
			F2Q->F2Q_PRDINC := "S"
			MsUnLock()
		Endif
		
		SB1->(dbSkip())
	Enddo

	RESET ENVIRONMENT
	
Return

