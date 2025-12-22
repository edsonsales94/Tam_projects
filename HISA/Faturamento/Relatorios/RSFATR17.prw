#INCLUDE "PROTHEUS.CH"       
#include "rwmake.ch" 

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSFATR17   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 21/06/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELPERC   ¦ Relatório de auditoria de notas fiscais.                      ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
User Function RSFATR17()      

	Private oReport, oSection1
	Private cPerg    := "RSFATR17"
	Private nQtd     := 0
	Private nTotQtd  := 0

	oReport := ReportDef()
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()


Return

//=================================================================================
// relatorio de produtividade - formato personalizavel
//=================================================================================
Static Function ReportDef()
	Local cTitulo := 'Relatório de auditoria de notas fiscais'

	// Cria as perguntas no SX1                                            
	CriaSx1()
	Pergunte(cPerg,.F.)

	oReport := TReport():New("RSFATR17", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de auditoria de notas fiscais")

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Relatório de auditoria de notas fiscais",{""})
	oSection1:SetTotalInLine(.F.)

	TRCell():new(oSection1, "C_FIL"      , "", "FILIAL"  	    ,,10)
	TRCell():new(oSection1, "C_TP"       , "", "TP"             ,,10)
	TRCell():new(oSection1, "C_NF"       , "", "NOTA" 	        ,,10)
	TRCell():new(oSection1, "C_SERIE"  	 , "", "SERIE" 	        ,,10)
	TRCell():new(oSection1, "C_ESPECIE"  , "", "ESPECIE" 	    ,,10)
	TRCell():new(oSection1, "C_MODELO"   , "", "MODELO"	        ,,10)		
	TRCell():new(oSection1, "C_EMISSAO"  , "", "EMISSÃO"	    ,,10)			
	TRCell():new(oSection1, "C_CODCLI"   , "", "CODIGO CLIENTE"	,,15)			
	TRCell():new(oSection1, "C_LOJCLI"   , "", "LOJA CLIENTE"	,,15)			
	TRCell():new(oSection1, "C_TPCLI"    , "", "TP. CLI/FOR"	,,15)			
	TRCell():new(oSection1, "C_NOMECLI"  , "", "NOME CLIENTE"	,,35)			
	TRCell():new(oSection1, "C_UFCLI"    , "", "UF"             ,,10)	
	TRCell():new(oSection1, "C_CNPJ"     , "", "CNPJ"           ,,15)
	TRCell():new(oSection1, "C_IE"       , "", "INSC. ESTADUAL" ,,15)	
	TRCell():new(oSection1, "C_CHAVE"    , "", "CHAVE NF"       ,,30)	
	*
	TRCell():new(oSection1, "C_ITEM"     , "", "ITEM"           ,,10)	
	TRCell():new(oSection1, "C_PROD"     , "", "PRODUTO"        ,,15)	
	TRCell():new(oSection1, "C_DESC"     , "", "DESCRIÇÃO"      ,,40)	
	TRCell():new(oSection1, "C_CODFCI"   , "", "CODIGO FCI"     ,,15)	
	TRCell():new(oSection1, "C_TIPO"     , "", "TIPO"           ,,15)	
	TRCell():new(oSection1, "C_UM"       , "", "UNIDADE"        ,,10)	
	TRCell():new(oSection1, "C_NCM"      , "", "NCM"            ,,15)	
	TRCell():new(oSection1, "C_NATUREZA" , "", "NATUREZA FINACEIRA"    ,,25)	
	TRCell():new(oSection1, "C_TES"      , "", "TES"           ,,15)	
	TRCell():new(oSection1, "C_CFOP"     , "", "CFOP"          ,,15)	
	TRCell():new(oSection1, "C_STRIB"    , "", "SIT. TRIBUTARIA"      ,,15)		
	TRCell():new(oSection1, "C_ORIGEM"   , "", "ORIGEM"        ,,15)		
	TRCell():new(oSection1, "C_QTD"      , "", "QUANTIDADE"    ,,15)		
	TRCell():new(oSection1, "C_PRECO"    , "", "PREÇO"         ,,15)		
	TRCell():new(oSection1, "C_VLRM"     , "", "VALOR MERCADORIA"     ,,15)		
	TRCell():new(oSection1, "C_VLRD"     , "", "VALOR DESCONTO",,15)		
	TRCell():new(oSection1, "C_VLRC"     , "", "VALOR CONTABIL",,15)		
	TRCell():new(oSection1, "C_VLRS"     , "", "VALOR SEGURO"  ,,15)		
	TRCell():new(oSection1, "C_VLRF"     , "", "VALOR FRETE"   ,,15)			
	TRCell():new(oSection1, "C_VLRP"     , "", "VALOR DESPESA" ,,15)			
	TRCell():new(oSection1, "C_INDFRETE" , "", "IND. FRETE"    ,,15)			
	TRCell():new(oSection1, "C_NFORIG"   , "", "NF DE ORIGEM"  ,,15)			
	TRCell():new(oSection1, "C_SRORIG"   , "", "SÉRIE DE ORIGEM"      ,,15)		
	*
	TRCell():new(oSection1, "C_BISS"     , "", "BASE ISS"      ,,15)					
	TRCell():new(oSection1, "C_AISS"     , "", "ALIQ. ISS"     ,,15)				
	TRCell():new(oSection1, "C_VISS"     , "", "VALOR ISS"     ,,15)				
	TRCell():new(oSection1, "C_SCISS"     , "", "CODIGO ISS"    ,,15)				
	*
	TRCell():new(oSection1, "C_BINSS"    , "", "BASE INSS"     ,,15)					
	TRCell():new(oSection1, "C_AINSS"    , "", "ALIQ. INSS"    ,,15)				
	TRCell():new(oSection1, "C_VINSS"    , "", "VALOR INSS"    ,,15)					
	*
	TRCell():new(oSection1, "C_BIRR"     , "", "BASE IRR"      ,,15)						
	TRCell():new(oSection1, "C_AIRR"     , "", "ALIQ. IRR"     ,,15)				
	TRCell():new(oSection1, "C_VIRR"     , "", "VALOR IRR"     ,,15)				
	*
	TRCell():new(oSection1, "C_BICMS"    , "", "BASE ICMS"      ,,15)					
	TRCell():new(oSection1, "C_AICMS"    , "", "ALIQ. ICMS"     ,,15)				
	TRCell():new(oSection1, "C_VICMS"    , "", "VALOR ICMS"     ,,15)				
	TRCell():new(oSection1, "C_CST"      , "", "CST"            ,,15)					
	TRCell():new(oSection1, "C_DIFTOT"   , "", "DIFAL TOTAL"    ,,15)					
	TRCell():new(oSection1, "C_DIFORI"   , "", "% DIFAL ORIGEM"     ,,15)					
	TRCell():new(oSection1, "C_DIFDES"   , "", "% DIFAL DESTINO"    ,,15)						
	TRCell():new(oSection1, "C_IDIFORI"  , "", "ICMS DIFAL ORIGEM"  ,,15)						
	TRCell():new(oSection1, "C_IDIFDES"  , "", "ICMS DIFAL DESTINO" ,,15)							
	TRCell():new(oSection1, "C_FECP"     , "", "VALOR FECP"     ,,15)
	TRCell():new(oSection1, "C_DIFECP"   , "", "ICMS DIFAL DESTINO + FECP"     ,,15)	            
	TRCell():new(oSection1, "C_BICMSR"   , "", "BASE ICMS RETIDO"   ,,15)
	TRCell():new(oSection1, "C_AICMSR"   , "", "ALIQ. ICMS RETIDO"  ,,15)	
	TRCell():new(oSection1, "C_VICMSR"   , "", "VALOR ICMS RETIDO"  ,,15)	
	TRCell():new(oSection1, "C_VISENTO"  , "", "VALOR ISENTO"       ,,15)	
	TRCell():new(oSection1, "C_VOUTRO"   , "", "VALOR OUTROS"       ,,15)	
	TRCell():new(oSection1, "C_MVA"      , "", "MVA"            ,,15)	
	
	TRCell():new(oSection1, "C_BIPI"     , "", "BASE IPI"      ,,15)					
	TRCell():new(oSection1, "C_AIPI"     , "", "ALIQ. IPI"     ,,15)				
	TRCell():new(oSection1, "C_VIPI"     , "", "VALOR IPI"     ,,15)				
	TRCell():new(oSection1, "C_VIIPI"    , "", "VALOR ISENTO IPI"      ,,15)					
	TRCell():new(oSection1, "C_VOIPI"    , "", "VALOR OUTROS IPI"     ,,15)				
	TRCell():new(oSection1, "C_CSTIPI"   , "", "CST IPI"       ,,15)				
	

	TRCell():new(oSection1, "C_BCOFINS" , "", "BASE APURAÇÃO COFINS"      ,,15)					
	TRCell():new(oSection1, "C_ACOFINS" , "", "ALIQ. APURAÇÃO COFINS"     ,,15)				
	TRCell():new(oSection1, "C_VCOFINS" , "", "VALOR APURAÇÃO COFINS"     ,,15)				
	TRCell():new(oSection1, "C_BRCOFINS" , "", "BASE RETENÇÃO COFINS"      ,,15)					
	TRCell():new(oSection1, "C_ARCOFINS" , "", "ALIQ. RETENÇÃO COFINS"     ,,15)				
	TRCell():new(oSection1, "C_VRCOFINS" , "", "VALOR RETENÇÃO COFINS"     ,,15)	
	TRCell():new(oSection1, "C_CSTCOFINS", "", "CST COFINS"       ,,15)								


	TRCell():new(oSection1, "C_BPIS" , "", "BASE APURAÇÃO PIS"      ,,15)					
	TRCell():new(oSection1, "C_APIS" , "", "ALIQ. APURAÇÃO PIS"     ,,15)				
	TRCell():new(oSection1, "C_VPIS" , "", "VALOR APURAÇÃO PIS"     ,,15)				
	TRCell():new(oSection1, "C_BRPIS" , "", "BASE RETENÇÃO PIS"      ,,15)					
	TRCell():new(oSection1, "C_ARPIS" , "", "ALIQ. RETENÇÃO PIS"     ,,15)				
	TRCell():new(oSection1, "C_VRPIS" , "", "VALOR RETENÇÃO PIS"     ,,15)	
	TRCell():new(oSection1, "C_CSTPIS", "", "CST PIS"       ,,15)								

	
	TRCell():new(oSection1, "C_BCSLL"     , "", "BASE CSLL"      ,,15)					
	TRCell():new(oSection1, "C_ACSLL"     , "", "ALIQ. CSLL"     ,,15)				
	TRCell():new(oSection1, "C_VCSLL"     , "", "VALOR CSLL"     ,,15)				
	
	TRCell():new(oSection1, "C_CODBCC"    , "", "COD. BCC"       ,,15)					
	
	
	TRCell():new(oSection1, "C_CTACONT"   , "", "CONTA CONTABIL" ,,15)				
	TRCell():new(oSection1, "C_CTADESC"   , "", "DESCRIÇÃO"      ,,15)				
	TRCell():new(oSection1, "C_ITEMCON"   , "", "ITEM CONTA"     ,,15)				
	TRCell():new(oSection1, "C_ITEMDESC"  , "", "DESCRIÇÃO"      ,,15)							
	TRCell():new(oSection1, "C_CC"        , "", "CENTRO CUSTO"   ,,15)					
	TRCell():new(oSection1, "C_CCDESC"    , "", "DESCRIÇÃO"      ,,15)					
	*		
	TRCell():new(oSection1, "C_CFOP"      , "", "CFOP"           ,,15)					
	TRCell():new(oSection1, "C_CFDESC"    , "", "DESCRIÇÃO"      ,,15)					
	TRCell():new(oSection1, "C_DUPLICATA" , "", "DUPLICATA"      ,,15)					
	TRCell():new(oSection1, "C_ESTOQUE"   , "", "ESTOQUE"        ,,15)					
	TRCell():new(oSection1, "C_PODER3"    , "", "PODER 3º"       ,,15)					
	*
	TRCell():new(oSection1, "C_CALICMS"   , "", "CALCULA ICMS"   ,,15)					
	TRCell():new(oSection1, "C_CREICMS"   , "", "CREDITA ICMS"   ,,15)					
	TRCell():new(oSection1, "C_LFICMS"    , "", "LF ICMS"        ,,15)					
	TRCell():new(oSection1, "C_LFIST"     , "", "LF ICMS ST"     ,,15)					
	TRCell():new(oSection1, "C_CSTICMS"   , "", "CST ICMS"       ,,15)					
    *
	TRCell():new(oSection1, "C_CALIPI"   , "", "CALCULA IPI"     ,,15)					
	TRCell():new(oSection1, "C_CREIPI"   , "", "CREDITA IPI"     ,,15)					
	TRCell():new(oSection1, "C_LFIPI"    , "", "LF IPI"          ,,15)					
	TRCell():new(oSection1, "C_DESTIPI"  , "", "DESTACA IPI"     ,,15)					
	TRCell():new(oSection1, "C_CSTIPI"   , "", "CST IPI"         ,,15)					

	TRCell():new(oSection1, "C_AGRPIS"   , "", "AGREGA PIS"     ,,15)					
	TRCell():new(oSection1, "C_AGRCOFINS", "", "AGREGA COFINS"  ,,15)					
	TRCell():new(oSection1, "C_CREPIS"   , "", "CREDITA/DEBITA PIS/COFINS"     ,,15)					
	TRCell():new(oSection1, "C_CSTPIS"   , "", "CST PIS"        ,,15)					
    TRCell():new(oSection1, "C_CSTCOFINS", "", "CST COFINS"     ,,15)					

	
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
	Local nReg

	oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)   
	
	if mv_par05 = 2
	   cQuery :=" SELECT F2_FILIAL,F2_TIPO,F2_DOC,F2_SERIE,F2_ESPECIE,'' MODELO,F2_EMISSAO,F2_CLIENTE,F2_LOJA,
	   cQuery +=" CASE WHEN F2_TIPOCLI = 'L' THEN 'Produtor Rural' ELSE CASE WHEN F2_TIPOCLI = 'F' THEN 'Cons.Final'     ELSE CASE WHEN F2_TIPOCLI = 'R' THEN 'Revendedor'     ELSE CASE WHEN F2_TIPOCLI = 'S' THEN 'ICMS Solidário sem IPI na base' ELSE 'Exportação' END END END END F2_TIPOCLI, "
	   cQuery +=" CASE WHEN F2_TIPO = 'D' THEN A2_NOME ELSE A1_NOME END NOME,
	   cQuery +=" CASE WHEN F2_TIPO = 'D' THEN A2_EST ELSE A1_EST END ESTADO,
	   cQuery +=" CASE WHEN F2_TIPO = 'D' THEN A2_CGC ELSE A1_CGC END CGC,
	   cQuery +=" CASE WHEN F2_TIPO = 'D' THEN A2_INSCR ELSE A1_INSCR END INSCR,
	   cQuery +=" F2_CHVNFE,D2_ITEM,D2_COD,B1_DESC,B1_PICMRET,B1_TIPO,B1_UM,B1_POSIPI,ISNULL(E1_NATUREZ,'') E1_NATUREZ,D2_TES,D2_CF,D2_CLASFIS,B1_ORIGEM,
	   cQuery +=" D2_QUANT,D2_PRCVEN,D2_TOTAL+D2_DESCON VLRMERCADORI,D2_DESCON,D2_TOTAL,D2_SEGURO,D2_VALFRE,D2_DESPESA,F2_TPFRETE,
	   cQuery +=" D2_NFORI,D2_SERIORI,D2_BASEISS,D2_ALIQISS,D2_VALISS,D2_CODISS,D2_BASEINS,D2_ALIQINS,D2_VALINS,
	   cQuery +=" D2_BASEIRR,D2_ALQIRRF,D2_VALIRRF,
	   cQuery +=" D2_BASEICM, D2_PICM, D2_VALICM, D2_CLASFIS, D2_DIFAL, D2_PDORI, D2_PDDES, D2_ICMSCOM, D2_DIFAL, D2_VALFECP, D2_DIFAL+D2_VALFECP ICMSDIFAL, D2_BRICMS, D2_ALIQSOL, D2_ICMSRET,
	   cQuery +=" D2_BASEIPI,D2_IPI,D2_VALIPI,F4_CF, F4_FINALID,
	   cQuery +=" CASE WHEN F4_DUPLIC = 'S' THEN 'SIM' ELSE 'NÃO' END F4_DUPLIC,
	   cQuery +=" CASE WHEN F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END F4_ESTOQUE, 
	   cQuery +=" CASE WHEN F4_PODER3 = 'S' THEN 'SIM' ELSE 'NÃO' END F4_PODER3, 
	   cQuery +=" CASE WHEN F4_ICM = 'S' THEN 'SIM' ELSE 'NÃO' END F4_ICM, 
	   cQuery +=" CASE WHEN F4_CREDICM = 'S' THEN 'SIM' ELSE 'NÃO' END F4_CREDICM, 
	   cQuery +=" CASE WHEN F4_CREDICM = 'S' THEN 'SIM' ELSE 'NÃO' END F4_CREDICM, 
	   cQuery +=" CASE WHEN F4_LFICM = 'T' THEN 'ICMS Tributado' ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'I' THEN 'ICMS Isento'    ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'O' THEN 'ICMS Outros'    ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'N' THEN 'não tributado'  ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'Z' THEN 'Livro Fiscal com colunas de ICMS zeradas' 
	   cQuery +=" ELSE 'Livro Fiscal com valor contábil como desconto na coluna observações' END END END END END F4_LFICM,
	   cQuery +=" CASE WHEN F4_LFICMST = 'S' THEN 'SIM' ELSE 'NÃO' END F4_LFICMST,
	   cQuery +=" F4_SITTRIB,
	   cQuery +=" CASE WHEN F4_IPI = 'S' THEN 'SIM' ELSE 'NÃO' END F4_IPI,
	   cQuery +=" CASE WHEN F4_CREDIPI = 'S' THEN 'SIM' ELSE 'NÃO' END F4_CREDIPI,
	   cQuery +=" CASE WHEN F4_LFICM = 'T' THEN 'IPI Tributado' ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'I' THEN 'IPI Isento'    ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'O' THEN 'IPI Outros'    ELSE
	   cQuery +=" CASE WHEN F4_LFICM = 'N' THEN 'não tributado' 
	   cQuery +=" ELSE 'IPI nos livros fiscais zeradas' END END END END F4_LFIPI,
	   cQuery +=" CASE WHEN F4_DESTACA = 'S' THEN 'SIM' ELSE 'NÃO' END F4_DESTACA,
	   cQuery +=" F4_CTIPI,
	   cQuery +=" CASE WHEN F4_AGRCOF = '1' THEN 'SIM' ELSE 'NÃO' END F4_AGRCOF,
	   cQuery +=" CASE WHEN F4_AGRPIS = '1' THEN 'SIM' ELSE 'NÃO' END F4_AGRPIS,
	   cQuery +=" CASE WHEN F4_PISCRED = '1' THEN 'SIM' ELSE 'NÃO' END F4_PISCRED,
	   cQuery +=" F4_CSTPIS,
	   cQuery +=" F4_CSTCOF,
	   cQuery +=" CD2C.CD2_BC CD2_BCC,CD2C.CD2_ALIQ CD2_ALIQC,CD2C.CD2_VLTRIB CD2_VLTRIBC,CD2C.CD2_CST CD2_CSTC,
	   cQuery +=" CD2P.CD2_BC CD2_BCP,CD2P.CD2_ALIQ CD2_ALIQP,CD2P.CD2_VLTRIB CD2_VLTRIBP,CD2P.CD2_CST CD2_CSTP

	   cQuery +=" FROM "+ RetSqlName("SF2")+ " SF2 "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SA1")+ " SA1 ON SA1.D_E_L_E_T_ = '' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND A1_FILIAL = '' "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SA2")+ " SA2 ON SA2.D_E_L_E_T_ = '' AND A2_COD = F2_CLIENTE AND A2_LOJA = F2_LOJA AND A2_FILIAL = ''  "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SD2")+ " SD2 ON SD2.D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SB1")+ " SB1 ON SB1.D_E_L_E_T_ = '' AND B1_COD = D2_COD "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SE1")+ " SE1 ON SE1.D_E_L_E_T_ = '' AND E1_NUM = F2_DOC AND E1_PREFIXO = F2_SERIE "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SF4")+ " SF4 ON SF4.D_E_L_E_T_ = '' AND F4_FILIAL = F2_FILIAL AND F4_CODIGO = D2_TES "
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CD2")+ " CD2C ON CD2C.D_E_L_E_T_ = '' AND CD2C.CD2_FILIAL = D2_FILIAL AND CD2C.CD2_DOC = D2_DOC AND CD2C.CD2_SERIE = D2_SERIE AND CD2C.CD2_CODPRO = D2_COD AND CD2C.CD2_IMP = 'CF2'
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CD2")+ " CD2P ON CD2P.D_E_L_E_T_ = '' AND CD2P.CD2_FILIAL = D2_FILIAL AND CD2P.CD2_DOC = D2_DOC AND CD2P.CD2_SERIE = D2_SERIE AND CD2P.CD2_CODPRO = D2_COD AND CD2P.CD2_IMP = 'PS2'

   	   cQuery +=" WHERE SF2.D_E_L_E_T_ = '' "
	   cQuery +=" AND F2_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	   cQuery +=" AND F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
       cQuery +=" ORDER BY F2_FILIAL,F2_DOC,F2_SERIE "
       
	   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TRQ",.T.,.F.)    
	
	   TCSETFIELD("TRQ","F2_EMISSAO","D",8,0)
    
    else 
    
	   cQuery :=" SELECT F1_FILIAL,F1_TIPO,F1_DOC,F1_SERIE,F1_ESPECIE,'' MODELO,F1_DTDIGIT,F1_FORNECE,F1_LOJA,'' F1_TIPOCLI,
	   cQuery +=" CASE WHEN F1_TIPO = 'N' THEN A2_NOME ELSE A1_NOME END NOME,
	   cQuery +=" CASE WHEN F1_TIPO = 'N' THEN A2_EST ELSE A1_EST END ESTADO,
	   cQuery +=" CASE WHEN F1_TIPO = 'N' THEN A2_CGC ELSE A1_CGC END CGC,
	   cQuery +=" CASE WHEN F1_TIPO = 'N' THEN A2_INSCR ELSE A1_INSCR END INSCR,
	   cQuery +=" F1_CHVNFE,D1_ITEM,D1_COD,B1_DESC,B1_PICMRET,B1_TIPO,B1_UM,B1_POSIPI,ISNULL(E2_NATUREZ,'') E2_NATUREZ,D1_TES,D1_CF,D1_CLASFIS,B1_ORIGEM,
	   cQuery +=" D1_QUANT,D1_VUNIT,D1_TOTAL+D1_VALDESC VLRMERCADORI,D1_VALDESC,D1_TOTAL,D1_SEGURO,D1_VALFRE,D1_DESPESA,F1_TPFRETE,
	   cQuery +=" D1_NFORI,D1_SERIORI,D1_BASEISS,D1_ALIQISS,D1_VALISS,D1_CODISS,D1_BASEINS,D1_ALIQINS,D1_VALINS,
	   cQuery +=" D1_BASEIRR,D1_ALIQIRR,D1_VALIRR,
	   cQuery +=" D1_BASEICM, D1_PICM, D1_VALICM, D1_CLASFIS, D1_DIFAL, D1_PDORI, D1_PDDES, D1_ICMSCOM, D1_DIFAL, D1_VALFECP, D1_DIFAL+D1_VALFECP ICMSDIFAL, D1_BRICMS, D1_ALIQSOL, D1_ICMSRET,
	   cQuery +=" D1_BASEIPI,D1_IPI,D1_VALIPI,D1_BASEPIS,D1_ALQPIS,D1_VALPIS, D1_BASECOF, D1_ALQCOF, D1_VALCOF, D1_BASECSL, D1_ALQCSL, D1_VALCSL,
	   cQuery +=" F4_CF, F4_FINALID,D1_CONTA,D1_ITEMCTA,D1_CC,CT1_DESC01,CTT_DESC01,CTD_DESC01,
	   cQuery +=" CASE WHEN F4_DUPLIC = 'S' THEN 'SIM' ELSE 'NÃO' END F4_DUPLIC,
	   cQuery +=" CASE WHEN F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END F4_ESTOQUE, 
	   cQuery +=" CASE WHEN F4_PODER3 = 'S' THEN 'SIM' ELSE 'NÃO' END F4_PODER3, 
	   cQuery +=" CASE WHEN F4_ICM = 'S' THEN 'SIM' ELSE 'NÃO' END F4_ICM, 
	   cQuery +=" CASE WHEN F4_CREDICM = 'S' THEN 'SIM' ELSE 'NÃO' END F4_CREDICM, 
	   cQuery +=" CASE WHEN F4_CREDICM = 'S' THEN 'SIM' ELSE 'NÃO' END F4_CREDICM,
	   cQuery +=" CASE WHEN F4_LFICM = 'T' THEN 'ICMS Tributado' ELSE CASE WHEN F4_LFICM = 'I' THEN 'ICMS Isento'    ELSE CASE WHEN F4_LFICM = 'O' THEN 'ICMS Outros'    ELSE CASE WHEN F4_LFICM = 'N' THEN 'não tributado'  ELSE CASE WHEN F4_LFICM = 'Z' THEN 'Livro Fiscal com colunas de ICMS zeradas'  ELSE 'Livro Fiscal com valor contábil como desconto na coluna observações' END END END END END F4_LFICM,
	   cQuery +=" CASE WHEN F4_LFICMST = 'S' THEN 'SIM' ELSE 'NÃO' END F4_LFICMST,
	   cQuery +=" F4_SITTRIB,
	   cQuery +=" CASE WHEN F4_IPI = 'S' THEN 'SIM' ELSE 'NÃO' END F4_IPI,
	   cQuery +=" CASE WHEN F4_CREDIPI = 'S' THEN 'SIM' ELSE 'NÃO' END F4_CREDIPI, CASE WHEN F4_LFICM = 'T' THEN 'IPI Tributado' ELSE CASE WHEN F4_LFICM = 'I' THEN 'IPI Isento'    ELSE CASE WHEN F4_LFICM = 'O' THEN 'IPI Outros'    ELSE  CASE WHEN F4_LFICM = 'N' THEN 'não tributado'  ELSE 'IPI nos livros fiscais zeradas' END END END END F4_LFIPI,
	   cQuery +=" CASE WHEN F4_DESTACA = 'S' THEN 'SIM' ELSE 'NÃO' END F4_DESTACA,
	   cQuery +=" F4_CTIPI, 
	   cQuery +=" CASE WHEN F4_AGRCOF = '1' THEN 'SIM' ELSE 'NÃO' END F4_AGRCOF,
	   cQuery +=" CASE WHEN F4_AGRPIS = '1' THEN 'SIM' ELSE 'NÃO' END F4_AGRPIS,
	   cQuery +=" CASE WHEN F4_PISCRED = '1' THEN 'SIM' ELSE 'NÃO' END F4_PISCRED,
	   cQuery +=" F4_CSTPIS, F4_CSTCOF,
	   cQuery +=" ISNULL(CD2C.CD2_BC,0) CD2_BCC,ISNULL(CD2C.CD2_ALIQ,0) CD2_ALIQC,ISNULL(CD2C.CD2_VLTRIB,0) CD2_VLTRIBC,ISNULL(CD2C.CD2_CST,0) CD2_CSTC,
	   cQuery +=" ISNULL(CD2P.CD2_BC,0) CD2_BCP,ISNULL(CD2P.CD2_ALIQ,0) CD2_ALIQP,ISNULL(CD2P.CD2_VLTRIB,0) CD2_VLTRIBP,ISNULL(CD2P.CD2_CST,0) CD2_CSTP
	   cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SA1")+ " SA1 ON SA1.D_E_L_E_T_ = '' AND A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA AND A1_FILIAL = ''
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SA2")+ " SA2 ON SA2.D_E_L_E_T_ = '' AND A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND A2_FILIAL = ''
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SD1")+ " SD1 ON SD1.D_E_L_E_T_ = '' AND D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SB1")+ " SB1 ON SB1.D_E_L_E_T_ = '' AND B1_COD = D1_COD
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SE2")+ " SE2 ON SE2.D_E_L_E_T_ = '' AND E2_NUM = F1_DOC AND E2_PREFIXO = F1_SERIE AND E2_TIPO = 'NF'
	   cQuery +=" LEFT JOIN  "+ RetSqlName("SF4")+ " SF4 ON SF4.D_E_L_E_T_ = '' AND F4_FILIAL = F1_FILIAL AND F4_CODIGO = D1_TES
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CT1")+ " CT1 ON CT1.D_E_L_E_T_ = '' AND CT1_CONTA = D1_CONTA
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CTT")+ " CTT ON CTT.D_E_L_E_T_ = '' AND CTT_CUSTO = D1_CC	   
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CTD")+ " CTD ON CTD.D_E_L_E_T_ = '' AND CTD_ITEM = D1_ITEMCTA
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CD2")+ " CD2C ON CD2C.D_E_L_E_T_ = '' AND CD2C.CD2_FILIAL = D1_FILIAL AND CD2C.CD2_DOC = D1_DOC AND CD2C.CD2_SERIE = D1_SERIE AND CD2C.CD2_CODPRO = D1_COD AND CD2C.CD2_IMP = 'CF2'
	   cQuery +=" LEFT JOIN  "+ RetSqlName("CD2")+ " CD2P ON CD2P.D_E_L_E_T_ = '' AND CD2P.CD2_FILIAL = D1_FILIAL AND CD2P.CD2_DOC = D1_DOC AND CD2P.CD2_SERIE = D1_SERIE AND CD2P.CD2_CODPRO = D1_COD AND CD2P.CD2_IMP = 'PS2'
	   cQuery +=" WHERE SF1.D_E_L_E_T_ = ''
	   cQuery +=" AND F1_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	   cQuery +=" AND F1_DTDIGIT BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"	   
	   cQuery +=" ORDER BY F1_FILIAL,F1_DOC,F1_SERIE    "
	   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TRQ",.T.,.F.)    
	
	   TCSETFIELD("TRQ","F1_DTDIGIT","D",8,0)
	   
    endif
	
	If	!USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf

	count to nReg

	dbSelectArea("TRQ")
	dbGoTop()

	oReport:SetMeter(nReg)

	While ! Eof()
	
		If oReport:Cancel()
			Exit
		EndIf
        
	    if mv_par05 = 2
		   oSection1:Cell("C_FIL"):SetValue(TRQ->F2_FILIAL)
		   oSection1:Cell("C_TP"):SetValue(TRQ->F2_TIPO)
           oSection1:Cell("C_NF"):SetValue(TRQ->F2_DOC)
      	   oSection1:Cell("C_SERIE"):SetValue(TRQ->F2_SERIE)
      	   oSection1:Cell("C_ESPECIE"):SetValue(TRQ->F2_ESPECIE)
      	   oSection1:Cell("C_MODELO"):SetValue("")
      	   oSection1:Cell("C_EMISSAO"):SetValue(TRQ->F2_EMISSAO)      	
      	   oSection1:Cell("C_CODCLI"):SetValue(TRQ->F2_CLIENTE)      	
      	   oSection1:Cell("C_LOJCLI"):SetValue(TRQ->F2_LOJA)      	
      	   oSection1:Cell("C_TPCLI"):SetValue(TRQ->F2_TIPOCLI)      	
      	   oSection1:Cell("C_NOMECLI"):SetValue(TRQ->NOME)      	
      	   oSection1:Cell("C_UFCLI"):SetValue(TRQ->ESTADO)      	
      	   oSection1:Cell("C_CNPJ"):SetValue(TRQ->CGC)      	
      	   oSection1:Cell("C_IE"):SetValue(TRQ->INSCR)      	
      	   oSection1:Cell("C_CHAVE"):SetValue(TRQ->F2_CHVNFE)      	
           *
      	   oSection1:Cell("C_ITEM"):SetValue(TRQ->D2_ITEM)      	        
      	   oSection1:Cell("C_PROD"):SetValue(TRQ->D2_COD)
      	   oSection1:Cell("C_DESC"):SetValue(TRQ->B1_DESC)
      	   oSection1:Cell("C_CODFCI"):SetValue("")      	      	
      	   oSection1:Cell("C_TIPO"):SetValue(TRQ->B1_TIPO)      	      	
      	   oSection1:Cell("C_UM"):SetValue(TRQ->B1_UM)      	      	
           oSection1:Cell("C_NCM"):SetValue(TRQ->B1_POSIPI)      	      	
      	   *
      	   oSection1:Cell("C_NATUREZA"):SetValue(TRQ->E1_NATUREZ)      	      	
      	   oSection1:Cell("C_TES"):SetValue(TRQ->D2_TES)      	      	
      	   oSection1:Cell("C_CFOP"):SetValue(TRQ->D2_CF)      	      	
      	   oSection1:Cell("C_STRIB"):SetValue(TRQ->D2_CLASFIS)      	      	
      	   oSection1:Cell("C_ORIGEM"):SetValue(TRQ->B1_ORIGEM)      	      	
      	   oSection1:Cell("C_QTD"):SetValue(TRQ->D2_QUANT)      	      	
      	   oSection1:Cell("C_PRECO"):SetValue(TRQ->D2_PRCVEN)      	      	
      	   oSection1:Cell("C_VLRM"):SetValue(TRQ->VLRMERCADORI)      	      	
           oSection1:Cell("C_VLRD"):SetValue(TRQ->D2_DESCON)      	      	
      	   oSection1:Cell("C_VLRC"):SetValue(TRQ->D2_TOTAL)      	      	      	
      	   oSection1:Cell("C_VLRS"):SetValue(TRQ->D2_SEGURO)      	      	      	
      	   oSection1:Cell("C_VLRF"):SetValue(TRQ->D2_VALFRE)      	      	      	
      	   oSection1:Cell("C_VLRP"):SetValue(TRQ->D2_DESPESA)
           oSection1:Cell("C_INDFRETE"):SetValue(TRQ->F2_TPFRETE)
      	   oSection1:Cell("C_NFORIG"):SetValue(TRQ->D2_NFORI)
      	   oSection1:Cell("C_SRORIG"):SetValue(TRQ->D2_SERIORI)
 	       *
      	   oSection1:Cell("C_BISS"):SetValue(TRQ->D2_BASEISS)      	      	      	
     	   oSection1:Cell("C_AISS"):SetValue(TRQ->D2_ALIQISS)      	      	      	
      	   oSection1:Cell("C_VISS"):SetValue(TRQ->D2_VALISS)      	      	      	
      	   oSection1:Cell("C_SCISS"):SetValue(TRQ->D2_CODISS)
	       *
      	   oSection1:Cell("C_BINSS"):SetValue(TRQ->D2_BASEINS)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_AINSS"):SetValue(TRQ->D2_ALIQINS)
      	   oSection1:Cell("C_VINSS"):SetValue(TRQ->D2_VALINS)      	      	      	      	      	      	 	    
	       *
      	   oSection1:Cell("C_BIRR"):SetValue(TRQ->D2_BASEIRR)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_AIRR"):SetValue(TRQ->D2_ALQIRRF)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_VIRR"):SetValue(TRQ->D2_VALIRRF)      	      	      	      	      	      	 	    
	       *
      	   oSection1:Cell("C_BICMS"):SetValue(TRQ->D2_BASEICM)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_AICMS"):SetValue(TRQ->D2_PICM)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_VICMS"):SetValue(TRQ->D2_VALICM)
      	   oSection1:Cell("C_CST"):SetValue(TRQ->D2_CLASFIS)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFTOT"):SetValue(TRQ->D2_DIFAL)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFORI"):SetValue(TRQ->D2_PDORI)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFDES"):SetValue(TRQ->D2_PDDES)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_IDIFORI"):SetValue(TRQ->D2_ICMSCOM)      	      	      	      	      	      	 	          	      	
      	   oSection1:Cell("C_IDIFDES"):SetValue(TRQ->D2_DIFAL)      	      	      	      	      	      	 	          	
      	   oSection1:Cell("C_FECP"):SetValue(TRQ->D2_VALFECP)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFECP"):SetValue(TRQ->ICMSDIFAL)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_BICMSR"):SetValue(TRQ->D2_BRICMS)      	      	      	      	      	      	 	          	      	      	
      	   oSection1:Cell("C_AICMSR"):SetValue(TRQ->D2_ALIQSOL)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_VICMSR"):SetValue(TRQ->D2_ICMSRET)      	      	      	      	      	      	 	          	      	
      	   oSection1:Cell("C_VISENTO"):SetValue("")      	      	      	      	      	      	 	          	      	      	
      	   oSection1:Cell("C_VOUTRO"):SetValue("")      	      	      	      	      	      	 	          	      	      	
      	   oSection1:Cell("C_MVA"):SetValue(TRQ->B1_PICMRET)      	      	      	      	      	      	 	          	      	      	
           *
      	   oSection1:Cell("C_BIPI"):SetValue(TRQ->D2_BASEIPI)      	      	      	      	      	      	 	          	      	        
      	   oSection1:Cell("C_AIPI"):SetValue(TRQ->D2_IPI)      	      	      	      	      	      	 	          	      	        
      	   oSection1:Cell("C_VIPI"):SetValue(TRQ->D2_VALIPI)      	      	      	      	      	      	 	          	      	        
      	   *
      	   oSection1:Cell("C_VIIPI"):SetValue(0)      	      	      	      	      	      	 	          	      	              	      	      	
      	   oSection1:Cell("C_VOIPI"):SetValue(0)      	      	      	      	      	      	 	          	      	              	
      	   oSection1:Cell("C_CSTIPI"):SetValue("")      	      	      	      	      	      	 	          	      	              	
           *	                                                                                                                        
      	   oSection1:Cell("C_BCOFINS"):SetValue(TRQ->CD2_BCC)      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_ACOFINS"):SetValue(TRQ->CD2_ALIQC)      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_VCOFINS"):SetValue(TRQ->CD2_VLTRIBC)      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_BRCOFINS"):SetValue("")      	      	      	      	      	      	 	          	      	              	        
           oSection1:Cell("C_ARCOFINS"):SetValue("")      	      	      	      	      	      	 	          	      	              	              	
      	   oSection1:Cell("C_VRCOFINS"):SetValue("")      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_CSTCOFINS"):SetValue(TRQ->CD2_CSTC)
           *
      	   oSection1:Cell("C_BPIS"):SetValue(TRQ->CD2_BCP)
      	   oSection1:Cell("C_APIS"):SetValue(TRQ->CD2_ALIQP)
      	   oSection1:Cell("C_VPIS"):SetValue(TRQ->CD2_VLTRIBP)
      	   oSection1:Cell("C_BRPIS"):SetValue("")
      	   oSection1:Cell("C_ARPIS"):SetValue("")
      	   oSection1:Cell("C_VRPIS"):SetValue("")
      	   oSection1:Cell("C_CSTPIS"):SetValue(TRQ->CD2_CSTP)      	      	      	      	      	      	
           *      	      	      	      	      	        
      	   oSection1:Cell("C_BCSLL"):SetValue("")
      	   oSection1:Cell("C_ACSLL"):SetValue("")
      	   oSection1:Cell("C_VCSLL"):SetValue("")      	      	
      	   oSection1:Cell("C_CODBCC"):SetValue("")
	       *
      	   oSection1:Cell("C_CTACONT"):SetValue("")	
      	   oSection1:Cell("C_CTADESC"):SetValue("")	
      	   oSection1:Cell("C_ITEMCON"):SetValue("")	
      	   oSection1:Cell("C_ITEMDESC"):SetValue("")	
      	   oSection1:Cell("C_CC"):SetValue("")	
      	   oSection1:Cell("C_CCDESC"):SetValue("")	
           *
      	   oSection1:Cell("C_CFOP"):SetValue(TRQ->F4_CF)	        
      	   oSection1:Cell("C_CFDESC"):SetValue(TRQ->F4_FINALID)	      	
      	   oSection1:Cell("C_DUPLICATA"):SetValue(TRQ->F4_DUPLIC)	      	
      	   oSection1:Cell("C_ESTOQUE"):SetValue(TRQ->F4_ESTOQUE)	      	
      	   oSection1:Cell("C_PODER3"):SetValue(TRQ->F4_PODER3)	      	
  	       *
      	   oSection1:Cell("C_CALICMS"):SetValue(TRQ->F4_ICM)	
      	   oSection1:Cell("C_CREICMS"):SetValue(TRQ->F4_CREDICM)	
      	   oSection1:Cell("C_LFICMS"):SetValue(TRQ->F4_LFICM)	      	
      	   oSection1:Cell("C_LFIST"):SetValue(TRQ->F4_LFICMST)	      	
      	   oSection1:Cell("C_CSTICMS"):SetValue(TRQ->F4_SITTRIB)	      	
           *
      	   oSection1:Cell("C_CALIPI"):SetValue(TRQ->F4_IPI)	
      	   oSection1:Cell("C_CREIPI"):SetValue(TRQ->F4_CREDIPI)	      	
      	   oSection1:Cell("C_LFIPI"):SetValue(TRQ->F4_LFIPI)	      	
      	   oSection1:Cell("C_DESTIPI"):SetValue(TRQ->F4_DESTACA)	      	
      	   oSection1:Cell("C_CSTIPI"):SetValue(TRQ->F4_CTIPI)	      	
      	   *
      	   oSection1:Cell("C_AGRPIS"):SetValue(TRQ->F4_AGRPIS)
      	   oSection1:Cell("C_AGRCOFINS"):SetValue(TRQ->F4_AGRCOF)      	
      	   oSection1:Cell("C_CREPIS"):SetValue(TRQ->F4_PISCRED)      	
      	   oSection1:Cell("C_CSTPIS"):SetValue(TRQ->F4_CSTPIS)      	
      	   oSection1:Cell("C_CSTCOFINS"):SetValue(TRQ->F4_CSTCOF)      	
 	       *
        else 
		   oSection1:Cell("C_FIL"):SetValue(TRQ->F1_FILIAL)
		   oSection1:Cell("C_TP"):SetValue(TRQ->F1_TIPO)
           oSection1:Cell("C_NF"):SetValue(TRQ->F1_DOC)
      	   oSection1:Cell("C_SERIE"):SetValue(TRQ->F1_SERIE)
      	   oSection1:Cell("C_ESPECIE"):SetValue(TRQ->F1_ESPECIE)
      	   oSection1:Cell("C_MODELO"):SetValue("")
      	   oSection1:Cell("C_EMISSAO"):SetValue(TRQ->F1_DTDIGIT)      	
      	   oSection1:Cell("C_CODCLI"):SetValue(TRQ->F1_FORNECE)      	
      	   oSection1:Cell("C_LOJCLI"):SetValue(TRQ->F1_LOJA)      	
      	   oSection1:Cell("C_TPCLI"):SetValue(TRQ->F1_TIPOCLI)      	
      	   oSection1:Cell("C_NOMECLI"):SetValue(TRQ->NOME)      	
      	   oSection1:Cell("C_UFCLI"):SetValue(TRQ->ESTADO)      	
      	   oSection1:Cell("C_CNPJ"):SetValue(TRQ->CGC)      	
      	   oSection1:Cell("C_IE"):SetValue(TRQ->INSCR)      	
      	   oSection1:Cell("C_CHAVE"):SetValue(TRQ->F1_CHVNFE)      	
           *
      	   oSection1:Cell("C_ITEM"):SetValue(TRQ->D1_ITEM)      	        
      	   oSection1:Cell("C_PROD"):SetValue(TRQ->D1_COD)
      	   oSection1:Cell("C_DESC"):SetValue(TRQ->B1_DESC)
      	   oSection1:Cell("C_CODFCI"):SetValue("")      	      	
      	   oSection1:Cell("C_TIPO"):SetValue(TRQ->B1_TIPO)      	      	
      	   oSection1:Cell("C_UM"):SetValue(TRQ->B1_UM)      	      	
           oSection1:Cell("C_NCM"):SetValue(TRQ->B1_POSIPI)      	      	
      	   *
      	   oSection1:Cell("C_NATUREZA"):SetValue(TRQ->E2_NATUREZ)      	      	
      	   oSection1:Cell("C_TES"):SetValue(TRQ->D1_TES)      	      	
      	   oSection1:Cell("C_CFOP"):SetValue(TRQ->D1_CF)      	      	
      	   oSection1:Cell("C_STRIB"):SetValue(TRQ->D1_CLASFIS)      	      	
      	   oSection1:Cell("C_ORIGEM"):SetValue(TRQ->B1_ORIGEM)      	      	
      	   oSection1:Cell("C_QTD"):SetValue(TRQ->D1_QUANT)      	      	
      	   oSection1:Cell("C_PRECO"):SetValue(TRQ->D1_VUNIT)      	      	
      	   oSection1:Cell("C_VLRM"):SetValue(TRQ->VLRMERCADORI)      	      	
           oSection1:Cell("C_VLRD"):SetValue(TRQ->D1_VALDESC)      	      	
      	   oSection1:Cell("C_VLRC"):SetValue(TRQ->D1_TOTAL)      	      	      	
      	   oSection1:Cell("C_VLRS"):SetValue(TRQ->D1_SEGURO)      	      	      	
      	   oSection1:Cell("C_VLRF"):SetValue(TRQ->D1_VALFRE)      	      	      	
      	   oSection1:Cell("C_VLRP"):SetValue(TRQ->D1_DESPESA)
           oSection1:Cell("C_INDFRETE"):SetValue(TRQ->F1_TPFRETE)
      	   oSection1:Cell("C_NFORIG"):SetValue(TRQ->D1_NFORI)
      	   oSection1:Cell("C_SRORIG"):SetValue(TRQ->D1_SERIORI)
 	       *
      	   oSection1:Cell("C_BISS"):SetValue(TRQ->D1_BASEISS)      	      	      	
     	   oSection1:Cell("C_AISS"):SetValue(TRQ->D1_ALIQISS)      	      	      	
      	   oSection1:Cell("C_VISS"):SetValue(TRQ->D1_VALISS)      	      	      	
      	   oSection1:Cell("C_SCISS"):SetValue(TRQ->D1_CODISS)
	       *
      	   oSection1:Cell("C_BINSS"):SetValue(TRQ->D1_BASEINS)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_AINSS"):SetValue(TRQ->D1_ALIQINS)
      	   oSection1:Cell("C_VINSS"):SetValue(TRQ->D1_VALINS)      	      	      	      	      	      	 	    
	       *
      	   oSection1:Cell("C_BIRR"):SetValue(TRQ->D1_BASEIRR)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_AIRR"):SetValue(TRQ->D1_ALIQIRR)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_VIRR"):SetValue(TRQ->D1_VALIRR)      	      	      	      	      	      	 	    
	       *
      	   oSection1:Cell("C_BICMS"):SetValue(TRQ->D1_BASEICM)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_AICMS"):SetValue(TRQ->D1_PICM)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_VICMS"):SetValue(TRQ->D1_VALICM)
      	   oSection1:Cell("C_CST"):SetValue(TRQ->D1_CLASFIS)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFTOT"):SetValue(TRQ->D1_DIFAL)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFORI"):SetValue(TRQ->D1_PDORI)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFDES"):SetValue(TRQ->D1_PDDES)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_IDIFORI"):SetValue(TRQ->D1_ICMSCOM)      	      	      	      	      	      	 	          	      	
      	   oSection1:Cell("C_IDIFDES"):SetValue(TRQ->D1_DIFAL)      	      	      	      	      	      	 	          	
      	   oSection1:Cell("C_FECP"):SetValue(TRQ->D1_VALFECP)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_DIFECP"):SetValue(TRQ->ICMSDIFAL)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_BICMSR"):SetValue(TRQ->D1_BRICMS)      	      	      	      	      	      	 	          	      	      	
      	   oSection1:Cell("C_AICMSR"):SetValue(TRQ->D1_ALIQSOL)      	      	      	      	      	      	 	    
      	   oSection1:Cell("C_VICMSR"):SetValue(TRQ->D1_ICMSRET)      	      	      	      	      	      	 	          	      	
      	   oSection1:Cell("C_VISENTO"):SetValue("")      	      	      	      	      	      	 	          	      	      	
      	   oSection1:Cell("C_VOUTRO"):SetValue("")      	      	      	      	      	      	 	          	      	      	
      	   oSection1:Cell("C_MVA"):SetValue(TRQ->B1_PICMRET)      	      	      	      	      	      	 	          	      	      	
           *
      	   oSection1:Cell("C_BIPI"):SetValue(TRQ->D1_BASEIPI)      	      	      	      	      	      	 	          	      	        
      	   oSection1:Cell("C_AIPI"):SetValue(TRQ->D1_IPI)      	      	      	      	      	      	 	          	      	        
      	   oSection1:Cell("C_VIPI"):SetValue(TRQ->D1_VALIPI)      	      	      	      	      	      	 	          	      	        
      	   *
      	   oSection1:Cell("C_VIIPI"):SetValue(0)      	      	      	      	      	      	 	          	      	              	      	      	
      	   oSection1:Cell("C_VOIPI"):SetValue(0)      	      	      	      	      	      	 	          	      	              	
      	   oSection1:Cell("C_CSTIPI"):SetValue("")      	      	      	      	      	      	 	          	      	              	
           *	                                                                                                                        
      	   oSection1:Cell("C_BCOFINS"):SetValue("")      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_ACOFINS"):SetValue("")      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_VCOFINS"):SetValue("")      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_BRCOFINS"):SetValue(TRQ->D1_BASECOF)      	      	      	      	      	      	 	          	      	              	        
           oSection1:Cell("C_ARCOFINS"):SetValue(TRQ->D1_ALQCOF)      	      	      	      	      	      	 	          	      	              	              	
      	   oSection1:Cell("C_VRCOFINS"):SetValue(TRQ->D1_VALCOF)      	      	      	      	      	      	 	          	      	              	        
      	   oSection1:Cell("C_CSTCOFINS"):SetValue("")
           *
      	   oSection1:Cell("C_BPIS"):SetValue("")
      	   oSection1:Cell("C_APIS"):SetValue("")
      	   oSection1:Cell("C_VPIS"):SetValue("")
      	   oSection1:Cell("C_BRPIS"):SetValue(TRQ->D1_BASEPIS)
      	   oSection1:Cell("C_ARPIS"):SetValue(TRQ->D1_ALQPIS)
      	   oSection1:Cell("C_VRPIS"):SetValue(TRQ->D1_VALPIS)
      	   oSection1:Cell("C_CSTPIS"):SetValue("")      	      	      	      	      	      	
           *      	      	      	      	      	        
      	   oSection1:Cell("C_BCSLL"):SetValue(TRQ->D1_BASECSL)
      	   oSection1:Cell("C_ACSLL"):SetValue(TRQ->D1_ALQCSL)
      	   oSection1:Cell("C_VCSLL"):SetValue(TRQ->D1_VALCSL)      	      	
      	   oSection1:Cell("C_CODBCC"):SetValue("")
	       *
      	   oSection1:Cell("C_CTACONT"):SetValue(TRQ->D1_CONTA)	
      	   oSection1:Cell("C_CTADESC"):SetValue(TRQ->CT1_DESC01)	
      	   oSection1:Cell("C_ITEMCON"):SetValue(TRQ->D1_ITEMCTA)	
      	   oSection1:Cell("C_ITEMDESC"):SetValue(TRQ->CTD_DESC01)	
      	   oSection1:Cell("C_CC"):SetValue(TRQ->D1_CC)	
      	   oSection1:Cell("C_CCDESC"):SetValue(TRQ->CTT_DESC01)	
           *
      	   oSection1:Cell("C_CFOP"):SetValue(TRQ->F4_CF)	        
      	   oSection1:Cell("C_CFDESC"):SetValue(TRQ->F4_FINALID)	      	
      	   oSection1:Cell("C_DUPLICATA"):SetValue(TRQ->F4_DUPLIC)	      	
      	   oSection1:Cell("C_ESTOQUE"):SetValue(TRQ->F4_ESTOQUE)	      	
      	   oSection1:Cell("C_PODER3"):SetValue(TRQ->F4_PODER3)	      	
  	       *
      	   oSection1:Cell("C_CALICMS"):SetValue(TRQ->F4_ICM)	
      	   oSection1:Cell("C_CREICMS"):SetValue(TRQ->F4_CREDICM)	
      	   oSection1:Cell("C_LFICMS"):SetValue(TRQ->F4_LFICM)	      	
      	   oSection1:Cell("C_LFIST"):SetValue(TRQ->F4_LFICMST)	      	
      	   oSection1:Cell("C_CSTICMS"):SetValue(TRQ->F4_SITTRIB)	      	
           *
      	   oSection1:Cell("C_CALIPI"):SetValue(TRQ->F4_IPI)	
      	   oSection1:Cell("C_CREIPI"):SetValue(TRQ->F4_CREDIPI)	      	
      	   oSection1:Cell("C_LFIPI"):SetValue(TRQ->F4_LFIPI)	      	
      	   oSection1:Cell("C_DESTIPI"):SetValue(TRQ->F4_DESTACA)	      	
      	   oSection1:Cell("C_CSTIPI"):SetValue(TRQ->F4_CTIPI)	      	
      	   *
      	   oSection1:Cell("C_AGRPIS"):SetValue(TRQ->F4_AGRPIS)
      	   oSection1:Cell("C_AGRCOFINS"):SetValue(TRQ->F4_AGRCOF)      	
      	   oSection1:Cell("C_CREPIS"):SetValue(TRQ->F4_PISCRED)      	
      	   oSection1:Cell("C_CSTPIS"):SetValue(TRQ->F4_CSTPIS)      	
      	   oSection1:Cell("C_CSTCOFINS"):SetValue(TRQ->F4_CSTCOF)      	        
        endif
	    oReport:SkipLine()
   		oSection1:PrintLine() 
        oReport:IncMeter()
        
        dbSkip()
        
	Enddo
	dbSelectArea("TRQ")
	dbCloseArea()
	oSection1:Finish()

Return


//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1()

	u_HMPutSX1(cPerg, "01", PADR("Da Nota Niscal    ",29)+"?" ,"","", "mv_ch1" , "C", 9  , 0, 0, "G", "","  ", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Nota Fiscal   ",29)+"?" ,"","", "mv_ch2" , "C", 9  , 0, 0, "G", "","  ", "", "", "mv_par02")  
  	u_HMPutSX1(cPerg, "03", PADR("Da Data Emissao   ",29)+"?" ,"","", "mv_ch3" , "D", 8  , 0, 0, "G", "",  "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate Data Emissao  ",29)+"?" ,"","", "mv_ch4" , "D", 8  , 0, 0, "G", "",  "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Tipo Nota Fiscal  ",29)+"?" ,"","", "mv_ch5" , "N", 1  , 0, 1, "C", "",  "", "", "", "mv_par05","Entrada","","","","Saída")   	

Return Nil
