#include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
/*_______________________________________________________________________________
∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂
∂∂+-----------+------------+-------+----------------------+------+------------+∂∂
∂∂∂ Programa  ∂  AAPCPP06  ∂ Autor ∂ M·rcio Macedo        ∂ Data ∂ 29/08/2019 ∂∂∂
∂∂+-----------+------------+-------+----------------------+------+------------+∂∂
∂∂∂ Descri¡?o ∂ Este programa ir· gerar as MODs para Calculo do Custo          ∂∂
∂∂+-----------+---------------------------------------------------------------+∂∂
∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂∂
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ*/
User function AAPCPP06()
    Private oProcess
    Private cDTFECHMOD := GETMV("MV_DTFEMOD")
    Private cDTPROCMOD := GETMV("MV_DTPRMOD") 
    Private cUlmes     := SUBSTR(DTOS(GETMV("MV_ULMES")),1,6)

   @ 000,000 To 180,350 Dialog _WndMain TITLE "Processamento de MOD - AA"
   @ 005,005 To 85,175 OF _WndMain PIXEL
   @ 010,030 Say OemToAnsi("Este programa ir agerar as MOD conforme ")  OF _WndMain PIXEL
   @ 016,030 say OemToAnsi("paramametros expecificados pela Usuario." ) OF _WndMain PIXEL
   
   @ 030,045 Say OemToAnsi("Ult.Fech.MOD")  OF _WndMain PIXEL
   @ 030,100 say OemToAnsi("Dt.Ult.Proc" ) OF _WndMain PIXEL

   @ 040,040 MSGET  oCaminho VAR cDTFECHMOD 	Picture "@!"  SIZE 50,10 PIXEL OF _WndMain WHEN .T. VALID cUlmes < cDTFECHMOD
   @ 040,090 MSGET  oCaminho VAR cDTPROCMOD 	Picture "@!"  SIZE 50,10 PIXEL OF _WndMain WHEN .F.
   
   @ 065,020 BUTTON oBtnLoa PROMPT "Processar" SIZE 40,11  OF _WndMain PIXEL ACTION (Close(_WndMain), fProcMOD() ) 
   //@ 065,070 BUTTON oBtnLoa PROMPT "Estornar"  SIZE 40,11  OF _WndMain PIXEL ACTION (Close(_WndMain), fProcEXT() )
   @ 065,120 BUTTON oBtnLoa PROMPT "Sair"      SIZE 40,11  OF _WndMain PIXEL ACTION Close(_WndMain)
    
  	Activate Dialog _WndMain Centered

Return

/***********************************************************************************************************************/

Static Function fProcMOD
    oProcess := MsNewProcess():New( { || fProcessa() } , "Gerando movimentaÁ„o de MOD" , "Aguarde..." , .F. )
    oProcess:Activate()
Return

/***********************************************************************************************************************/

Static Function fProcEXT
    oProcess := MsNewProcess():New( { || fExtornar() } , "Estornando movimentaÁ„o de MOD" , "Aguarde..." , .F. )
    oProcess:Activate()
Return

/***********************************************************************************************************************/

Static function fProcessa()

    //valida parametros de fechamento.
    /*
    If (cUlmes != cDTFECHMOD) .AND. (cUlmes > cDTFECHMOD) 
        MessageBox("Fechamento foi realizado antes do calculo da MOD!","Proc.MOD",16)
        return 
    EndIf

    If (cUlmes != cDTFECHMOD) .AND. (cUlmes < cDTFECHMOD)
        MessageBox("Calculo da MOD, ja processada !","Proc.MOD",16)
        return
    EndIf
     */   
    PsqQry1(.T.)
    oProcess:SetRegua1( cAlias1->NCOUNT )
    PsqQry1(.F.)

    While cAlias1->(!Eof())
        oProcess:IncRegua1("Processando MOD"+cAlias1->B1_CC)
        oProcess:SetRegua2( cAlias1->NCOUNT)
        PsqQry2( cAlias1->B1_CC )
        While cAlias2->(!Eof())
            oProcess:IncRegua2("Processando DOC:"+cAlias2->D3_DOC)
            
            RecLock("SD3",.T.)
                SD3->D3_FILIAL   = cAlias2->D3_FILIAL  
                SD3->D3_COD      = cAlias2->D3_COD   
                SD3->D3_LOCAL    = cAlias2->D3_LOCAL
                SD3->D3_TM       = cAlias2->D3_TM
                SD3->D3_CF       = cAlias2->D3_CF
                SD3->D3_DOC      = cAlias2->D3_DOC
                SD3->D3_EMISSAO  = STOD(cAlias2->D3_EMISSAO)
                SD3->D3_OP       = cAlias2->D3_OP   
                SD3->D3_CHAVE    = cAlias2->D3_CHAVE
                SD3->D3_NUMSEQ   = cAlias2->D3_NUMSEQ
                SD3->D3_IDENT    = cAlias2->D3_IDENT
                SD3->D3_UM       = cAlias2->D3_UM
                SD3->D3_QUANT    = cAlias2->D3_QUANT
                SD3->D3_CUSTO1   = cAlias2->D3_CUSTO1
            MsUnLock()

            cAlias2->(dbSkip())
        EndDo
        cAlias1->(dbSkip())
    EndDo

    cAlias1->(dbCloseArea())
    cAlias2->(dbCloseArea())
    
    PUTMV("MV_DTFEMOD", CalcFech(cDTFECHMOD, "P"))
    PUTMV("MV_DTPRMOD",DTOC(DDATABASE)) 

    MessageBox("Processamento Realizado com Sucesso!","Proc.MOD",64)


Return

/***********************************************************************************************************************/

Static Function PsqQry1(COUNT)
Local cQry :=""
Local cAlias1

IF COUNT 
    cQry :="SELECT COUNT(*) NCOUNT, '' B1_CC "
    cQry +=" FROM( "
ENDif

cQry +="SELECT COUNT(*) NCOUNT, B1_CC "
cQry +=" FROM SD3010 SD3 (NOLOCK) "
cQry +=" LEFT OUTER JOIN SB1010 SB1 (NOLOCK) ON B1_COD = D3_COD AND SB1.D_E_L_E_T_='' "
cQry +=" LEFT OUTER JOIN SBM010 SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_='' "
cQry +=" LEFT OUTER JOIN CTT010 CTT (NOLOCK) ON B1_CC = CTT_CUSTO AND CTT.D_E_L_E_T_='' "
cQry +=" WHERE B1_CONV <> 0  "
cQry +=" AND SD3.D_E_L_E_T_ = '' "
cQry +=" And D3_FILIAL IN ('01', '00') "
cQry +=" And D3_ESTORNO = '' "
cQry +=" And Left(D3_EMISSAO, 6) LIKE '"+cDTFECHMOD+"%'  "
cQry +=" And D3_CF = 'PR0' "
cQry +=" GROUP BY B1_CC "

IF COUNT 
    cQry +=" ) A "
END

cQry +=" ORDER BY B1_CC "

If Select("cAlias1") <> 0
    cAlias1->(dbCloseArea())
Endif
	
TcQuery cQry Alias "cAlias1" New

Return


/***********************************************************************************************************************/

Static Function PsqQry2(cCusto)
Local cQry :=""
Local cAlias2

cQry :="SELECT  D3_FILIAL, " 
cQry +="       'MOD'+B1_CC As D3_COD, " 
cQry +="       '03'  As D3_LOCAL,  "
cQry +="	   '999' AS D3_TM,  "
cQry +="	   'RE5' AS D3_CF, "
cQry +="	   D3_DOC,  "
cQry +="	   D3_EMISSAO, " 
cQry +="	   D3_OP,  "
cQry +="	   'E0' AS D3_CHAVE,  "
cQry +="	   D3_NUMSEQ,  "
cQry +="	   D3_IDENT,  "
cQry +="	   'KG' As D3_UM, " 
cQry +="	   (D3_QUANT)/1000 As D3_QUANT,  "
cQry +="       ROUND((D3_QUANT/ISNULL(AUX.TOTAL,1))*ISNULL(CT2.Saldo, 0), 2) AS D3_CUSTO1, 
cQry +="	   SD3.D_E_L_E_T_, "
cQry +="       SD3.R_E_C_N_O_ SD3RECNO"
cQry +=" FROM SD3010 SD3 (NOLOCK) "
cQry +="INNER JOIN SB1010 (NOLOCK) SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_='' and B1_TIPO IN ('PA', 'PI') And B1_CC = '"+cCusto+"' "
cQry +=" LEFT JOIN ( SELECT  B1_CC AS CC, SUM(D3_QUANT) As TOTAL 
cQry +="	           FROM SD3010 SD3 (NOLOCK) 
cQry +="              INNER JOIN (SELECT B1_COD, B1_CC FROM SB1010 (NOLOCK) WHERE D_E_L_E_T_='' and B1_TIPO IN ('PA', 'PI') AND B1_CC = '"+cCusto+"' ) AS SB1 ON B1_COD = D3_COD "
cQry +="			  WHERE SD3.D_E_L_E_T_ = ''  And D3_FILIAL IN ('01', '00') And D3_CF = 'PR0'  AND D3_ESTORNO = ''
cQry +="			    And Left(D3_EMISSAO, 6) = '"+cDTFECHMOD+"' "
cQry +="			  GROUP BY B1_CC
cQry +="			) AS AUX ON AUX.CC = B1_CC
cQry +="  LEFT JOIN ( SELECT CT2_CC, sum(Deb - Cre) as Saldo
cQry +="			    FROM ( Select CT2_CCD AS CT2_CC, SUM(CT2_VALOR) Deb, 0 AS Cre
cQry +="					     From CT2010 as CT2 (NOLOCK)
cQry +="					    Where D_E_L_E_T_ = '' And CT2_TPSALD = '1' And CT2_CCD = '"+cCusto+"' "
cQry +="						  And Left(CT2_DEBITO, 3) In ('411','412','413')
cQry +="						  And Left(CT2_DATA, 6) = '"+cDTFECHMOD+"' "
cQry +="					    Group by CT2_CCD
cQry +="					    Union All
cQry +="					   Select CT2_CCC as CT2_CC, 0 AS Deb, SUM(CT2_VALOR) Cre
cQry +="					     From CT2010 as CT2 (NOLOCK)
cQry +="					    Where D_E_L_E_T_ = '' And CT2_TPSALD = '1' And CT2_CCC = '"+cCusto+"' " 
cQry +="					   	  And Left(CT2_CREDIT, 3) In ('411','412','413')
cQry +="						  And Left(CT2_DATA, 6) = '"+cDTFECHMOD+"' "
cQry +="					    Group by CT2_CCC
cQry +="				     ) AS CT2
cQry +="			   Group by CT2_CC
cQry +="			 ) AS CT2 ON CT2.CT2_CC = SB1.B1_CC
cQry +=" WHERE SD3.D_E_L_E_T_ = '' "
cQry +=" And D3_FILIAL IN ('01', '00') "
cQry +=" And D3_ESTORNO = '' "
cQry +=" And Left(D3_EMISSAO, 6) LIKE '"+cDTFECHMOD+"%' "
cQry +=" And D3_CF = 'PR0' "
cQry +=" ORDER BY B1_CC "

If Select("cAlias2") <> 0
    cAlias2->(dbCloseArea())
Endif
	
TcQuery cQry Alias "cAlias2" New

Return

/***********************************************************************************************************************/

Static Function fExtornar()

    //valida parametros de fechamento.
    If (cUlmes != cDTPROCMOD) .AND. (cUlmes > cDTPROCMOD) 
        MessageBox("Fechamento foi realizado antes do calculo da MOD!","Proc.MOD",16)
        return 
    EndIf

    If (cUlmes == cDTPROCMOD) .AND. (cUlmes < cDTPROCMOD)
        MessageBox("Mes se encontra Fechado para movimentaÁ„o!","Proc.MOD",16)
        return
    EndIf

    PsqQry1(.T.)
    oProcess:SetRegua1( cAlias1->NCOUNT )
    PsqQry1(.F.)

    While cAlias1->(!Eof())
        oProcess:IncRegua1("Processando MOD"+cAlias1->B1_CC)
        oProcess:SetRegua2( cAlias1->NCOUNT)
        PsqQry2( cAlias1->B1_CC )
        While cAlias2->(!Eof())
            oProcess:IncRegua2("Processando DOC:"+cAlias2->D3_DOC)
            
            SD3->(DbGoto(cAlias2->SD3RECNO))

            RecLock("SD3",.f.)
	            SD3->(DbDelete())
	        SD3->(MsUnLock())

            cAlias2->(dbSkip())
        EndDo
        cAlias1->(dbSkip())
    EndDo

    cAlias1->(dbCloseArea())
    cAlias2->(dbCloseArea())
    
    PUTMV("MV_DTFEMOD", CalcFech(cDTFECHMOD, "E"))
    PUTMV("MV_DTPRMOD",DTOC(DDATABASE)) 

    MessageBox("Extorno Realizado com Sucesso!","Proc.MOD",64)

Return 

/***********************************************************************************************************************/

Static Function CalcFech(ANOMES, cTp)

Local cDt := stod(ANOMES+"01")
Local cRet := ""

    if cTp == "P"
        cDt += 40
    else
        cDt += 10
    endif

    cRet := substr(dtos(cDt),1,6)

Return cRet
