#INCLUDE "rwmake.ch"
#include "Protheus.ch"

/*______________________________________________________________________________
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ GP010VALPE ¦ Autor ¦ Rage                 ¦ Data ¦ 20/11/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada antes da gravação do funcionario		        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
USER FUNCTION GP010VALPE

	Local aArea    := GetArea()
	Local aAreaSRA := SRA->( GetArea() ) 
	Local cSvFilAnt := cFilAnt //Salva a Filial Anterior 
	Local cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior 
	Local cSvArqTab := cArqTab //Salva os arquivos de //trabalho 
	Local cModo     := "C" 
	Local lAberto   := .F.
	
	If cSvEmpAnt = "02"
		lAberto   :=  EmpOpenFile("SA2","SA2",3,.T.,"01",@cModo)  
	Else
		dbSelectArea("SA2")
		dbSetOrder(3)
		lAberto   := .T.
	endif

	If 	!SA2->(dbSeek(xFilial("SA2")+M->RA_CIC)) .and. lAberto
	
		RecLock("SA2",.T.)
				
		SA2->A2_FILIAL  := XFILIAL("SA2")
		SA2->A2_COD     := Buscacodigo()
		SA2->A2_LOJA    := "01"
		SA2->A2_NOME    := M->RA_NOME
		SA2->A2_NREDUZ  := M->RA_NOME
		SA2->A2_END     := M->RA_ENDEREC
		SA2->A2_TIPO    := "F"
		SA2->A2_BAIRRO  := M->RA_BAIRRO
		SA2->A2_MUN     := M->RA_MUNICIP
		SA2->A2_EST     := M->RA_ESTADO
		SA2->A2_CEP     := M->RA_CEP
		SA2->A2_CGC     := M->RA_CIC
		SA2->A2_TEL     := M->RA_TELEFON
		SA2->A2_INSCR   := M->RA_RG
		SA2->A2_CONTA   := ""
		SA2->A2_PAIS    := "105"
		SA2->A2_COD_MUN := Posicione("CC2",2,xFilial("CC2")+M->RA_MUNICIP,"CC2_CODMUN")
		SA2->A2_CODPAIS := "01058"
		SA2->A2_VINCULA := "1"
		SA2->A2_ID_REPR := "2"
		SA2->A2_B2B     := "2"
		SA2->A2_PLCRRES := "N"
		SA2->A2_PLFIL   := "N"
				      
		MsunLock()
			
   //Grava o codigo do fornecedor no Funcionário
		 	
//	RecLock("SRA",.F.)		 	
		M->RA_CF := SA2->A2_COD
//	MsunLock()  		 	
			
	Else
			 	
		M->RA_CF := SA2->A2_COD
  	
		RecLock("SA2",.F.)
		SA2->A2_MSBLQL := " "
		MsunLock()
			
	EndIf
	
	SA2->(DbCloseArea())
	
	If cSvEmpAnt = "02"
		lAberto   :=  EmpOpenFile("SA1","SA1",3,.T.,"01",@cModo)  
	Else
		dbSelectArea("SA1")
		dbSetOrder(3)
		lAberto   := .T.
	endif

	If 	!SA1->(dbSeek(xFilial("SA1")+M->RA_CIC)) .and. lAberto
	
		RecLock("SA1",.T.)
				
		SA1->A1_FILIAL  := XFILIAL("SA1")
		SA1->A1_COD     := GetCodCli()
		SA1->A1_LOJA    := "01"
		SA1->A1_NOME    := M->RA_NOME
		SA1->A1_NREDUZ  := M->RA_NOME
		SA1->A1_END     := M->RA_ENDEREC
		SA1->A1_TIPO    := "F"
		SA1->A1_BAIRRO  := M->RA_BAIRRO
		SA1->A1_MUN     := M->RA_MUNICIP
		SA1->A1_EST     := M->RA_ESTADO
		SA1->A1_CEP     := iIF(Empty(M->RA_CEP),'69000000',M->RA_CEP)
		SA1->A1_CGC     := M->RA_CIC
		SA1->A1_TEL     := iIF( empty(M->RA_TELEFON),'xxxx-xxxx',M->RA_TELEFON)
		SA1->A1_INSCR   := M->RA_RG
		SA1->A1_CONTA   := '11206006'
		SA1->A1_PAIS    := "105"
		SA1->A1_COD_MUN := Posicione("CC2",2,xFilial("CC2")+M->RA_MUNICIP,"CC2_CODMUN")
		SA1->A1_CODPAIS := "01058"
		SA1->A1_RISCO   := "E"
		SA1->A1_DDD     := iIF( empty(M->RA_DDDFONE),'xx',M->RA_DDDFONE)
		SA1->A1_B2B     := "2"
				      
		MsunLock()
			
	EndIf
	
	SA1->(DbCloseArea())
	
	//Restaura os Dados de Entrada ( Ambiente ) 
	cFilAnt := cSvFilAnt 
	cEmpAnt := cSvEmpAnt 
	cArqTab := cSvArqTab //Restaura os ponteiros das Tabelas 
	RestArea( aAreaSRA ) 


	RestArea(aArea)

RETURN .T.


Static Function Buscacodigo()

	Local cArea  := GetArea()
	Local cQry   := ""
	Local cRet   := ""
 
	cQry += "SELECT ISNULL(MAX( SUBSTRING(A2_COD, 1, 6) ),0) AS C2_NUM"
	cQry += " FROM SA2010 WHERE D_E_L_E_T_ = ' ' "
	//cQry += "  AND A2_FILIAL = '  ' "
	cQry += "  AND SUBSTRING(A2_COD, 1, 1) BETWEEN '0' AND '8'  "
  
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

	cRet := STRZERO(val(Soma1(alltrim(str(TMP->C2_NUM)))),6)
  
	TMP->(dbCloseArea())

	Help := .T.	// Nao apresentar Help MayUse
  
	While !FreeForUse("SA2",cRet)
		cRet := Soma1(cRet)
		Help := .T.	// Nao apresentar Help MayUse
	End
  
	Help := .F.	// Habilito o help novamente
  
	RestArea(cArea)
Return cRet
 
 

 
Static Function GetCodCli()
     
	_cdTb := GetNextAlias()
     
	_cdQry := " Select MAX(A1_COD)  CODIGO from SA1010 "
	_cdQry += " WHERE A1_COD <= '999999' "
	_cdQry += " AND LEN(A1_COD) > 3 "
     
	dbUseArea(.T.,'TOPCONN',tcGenQry(,,_cdQry),_cdTb,.T.,.T.)
	_ndCod := Soma1( (_cdTb)->CODIGO )
	(_cdTb)->(dbCloseArea(_cdTb))
      
Return _ndCod

