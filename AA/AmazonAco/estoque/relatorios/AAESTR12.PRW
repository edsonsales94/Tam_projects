#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"


User Function AAESTR12()
Local oReport
Local cQuery
Local cAlias         := getNextAlias()
private cAlias2      := getNextAlias()
private cAlias3      := getNextAlias()
private cAlias4      := getNextAlias()
private cAlias5      := getNextAlias()
Private cPerg        := "AAESTR12"

//xwermeson
Pergunte(cPerg,.F.)

oReport := ReportDef(cAlias,cPerg)
oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
Local oReport
Local oSection
Local oBreak
Local aOrdem      := { }

oReport := TReport():New(cPerg,"Estoque Diário Representantes",cPerg,{|oReport| PrintReport(oReport,cAlias)},)
oReport:SetLandscape()

oSection := TRSection():New(oReport,"Acos Longos",{},aOrdem)      

TRCell():New(oSection,"B2_FILIAL"        ,"SB2","Filial")
TRCell():New(oSection,"B2_COD"           ,"SB2","Produto" )
TRCell():New(oSection,"B1_DESC"          ,"SB1","Descrição") 
TRCell():New(oSection,"B1_UM"            ,"SB1","UM")
TRCell():New(oSection,"ESTOQUEAA"        ,"SB2","Saldo")

oSection2 := TRSection():New(oReport,"Chapa",{},aOrdem)      

TRCell():New(oSection2,"B2_FILIAL"        ,"SB2","Filial")
TRCell():New(oSection2,"B2_COD"           ,"SB2","Produto" )
TRCell():New(oSection2,"B1_DESC"          ,"SB1","Descrição") 
TRCell():New(oSection2,"B1_UM"            ,"SB1","UM")
TRCell():New(oSection2,"ESTOQUEAA"        ,"SB2","Saldo")

oSection3 := TRSection():New(oReport,"Metalom",{},aOrdem)      

TRCell():New(oSection3,"B2_FILIAL"        ,"SB2","Filial")
TRCell():New(oSection3,"B2_COD"           ,"SB2","Produto" )
TRCell():New(oSection3,"B1_DESC"          ,"SB1","Descrição") 
TRCell():New(oSection3,"B1_UM"            ,"SB1","UM")
TRCell():New(oSection3,"ESTOQUEAA"        ,"SB2","Saldo")

oSection4 := TRSection():New(oReport,"Perfil",{},aOrdem)      

TRCell():New(oSection4,"B2_FILIAL"        ,"SB2","Filial")
TRCell():New(oSection4,"B2_COD"           ,"SB2","Produto" )
TRCell():New(oSection4,"B1_DESC"          ,"SB1","Descrição") 
TRCell():New(oSection4,"B1_UM"            ,"SB1","UM")
TRCell():New(oSection4,"ESTOQUEAA"        ,"SB2","Saldo")

oSection5 := TRSection():New(oReport,"Tubo",{},aOrdem)      

TRCell():New(oSection5,"B2_FILIAL"        ,"SB2","Filial")
TRCell():New(oSection5,"B2_COD"           ,"SB2","Produto" )
TRCell():New(oSection5,"B1_DESC"          ,"SB1","Descrição") 
TRCell():New(oSection5,"B1_UM"            ,"SB1","UM")
TRCell():New(oSection5,"ESTOQUEAA"        ,"SB2","Saldo")


Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
Local oSection     := oReport:Section(1)
Local oSection2    := oReport:Section(2)
Local oSection3    := oReport:Section(3)
Local oSection4    := oReport:Section(4)
Local oSection5    := oReport:Section(5)
lOCAL cLocProc     := '14' 
LOCAL cCusFil      := 'S'
Local dDataEstoque := dtos(mv_par01)
Local dxDatMes     := dtos(FirstDate(mv_par01))
Local dDataFim     := dtos(mv_par01)
Local dData01Ini   := dtos(FirstDate(MONTHSUB(mv_par01,1)))
Local dData01Fim   := dtos(LastDate (MONTHSUB(mv_par01,1)))
Local dData02Ini   := dtos(FirstDate(MONTHSUB(mv_par01,2)))
Local dData02Fim   := dtos(LastDate (MONTHSUB(mv_par01,2)))
Local dFechamento  := fGetData(dDataEstoque) 
Local cxAcosLongos := SubStr(alltrim(FormatIn( GetMv("MV_XGACOSL") , ',')),3,len(alltrim(FormatIn( GetMv("MV_XGACOSL") , ',')))-4)
Local cxChapas     := SubStr(alltrim(FormatIn( GetMv("MV_XGCHAPA") , ',')),3,len(alltrim(FormatIn( GetMv("MV_XGCHAPA") , ',')))-4)
Local cxMetalom    := SubStr(alltrim(FormatIn( GetMv("MV_XGMETAL") , ',')),3,len(alltrim(FormatIn( GetMv("MV_XGMETAL") , ',')))-4)
Local cxPerfil     := SubStr(alltrim(FormatIn( GetMv("MV_XGPERFI") , ',')),3,len(alltrim(FormatIn( GetMv("MV_XGPERFI") , ',')))-4)
Local cxTubo       := SubStr(alltrim(FormatIn( GetMv("MV_XGTUBOS") , ',')),3,len(alltrim(FormatIn( GetMv("MV_XGTUBOS") , ',')))-4)
Local nDecimais    := 2


oSection:BeginQuery()

BeginSQL Alias cAlias 
%noParser%


SELECT EST.B2_FILIAL,
       EST.B2_COD,
       B1_DESC,
	   B1_UM,
       EST.QUANT AS ESTOQUEAA
FROM
  (SELECT B2_FILIAL,
          B2_COD,
          ISNULL(B9_QINI, 0) + ISNULL(D1_QUANT, 0) + ISNULL(SD3.D3_QUANT, 0) - ISNULL(D2_QUANT, 0) - ISNULL(SD4.D3_QUANT, 0) - ISNULL(SC6.C6_QTDVEN, 0) AS QUANT,
          ISNULL(B9_VINI1, 0) + ISNULL(D1_CUSTO1, 0) + ISNULL(SD3.D3_CUSTO1, 0) - ISNULL(D2_CUSTO1, 0) - ISNULL(SD4.D3_CUSTO1, 0) AS CUSTO1,
          ISNULL(B9_VINI2, 0) + ISNULL(D1_CUSTO2, 0) + ISNULL(SD3.D3_CUSTO2, 0) - ISNULL(D2_CUSTO2, 0) - ISNULL(SD4.D3_CUSTO2, 0) AS CUSTO2
         
   FROM
     (SELECT B2_FILIAL,
             B2_COD
      FROM %Table:SB2% AS SB2(NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB2.B2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB2.%NotDel%
      GROUP BY B2_FILIAL,
               B2_COD) AS SB2
   INNER JOIN
     (SELECT B1_COD
      FROM %Table:SB1% SB1 (NOLOCK)
      WHERE D_E_L_E_T_ = ''
        AND B1_TIPO IN ('PA') ) AS SB1 ON SB1.B1_COD = SB2.B2_COD
   LEFT JOIN
     (SELECT B9_FILIAL,
             B9_COD,
             SUM(B9_QINI) AS B9_QINI,
             SUM(B9_VINI1) AS B9_VINI1,
             SUM(B9_VINI2) AS B9_VINI2
      FROM %Table:SB9% AS SB9 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB9.B9_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB9.%NotDel%
        AND B9_DATA = %Exp:dFechamento%
      GROUP BY B9_FILIAL,
               B9_COD) AS SB9 ON B9_FILIAL = B2_FILIAL
   AND B2_COD = B9_COD
   LEFT JOIN
     (SELECT D1_FILIAL,
             D1_COD,
             SUM(D1_QUANT) AS D1_QUANT,
             SUM(D1_CUSTO) AS D1_CUSTO1,
             SUM(D1_CUSTO2) AS D1_CUSTO2
      FROM %Table:SD1% AS SD1 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD1.D1_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = D1_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD1.%NotDel%
        AND D1_DTDIGIT > %Exp:dFechamento%
        AND D1_DTDIGIT <= %Exp:dDataEstoque%
      GROUP BY D1_FILIAL,
               D1_COD) AS SD1 ON D1_FILIAL = B2_FILIAL
   AND D1_COD = B2_COD
   LEFT JOIN
     (SELECT D2_FILIAL,
             D2_COD,
             SUM(D2_QUANT) AS D2_QUANT,
             SUM(D2_CUSTO1) AS D2_CUSTO1,
             SUM(D2_CUSTO2) AS D2_CUSTO2
      FROM %Table:SD2% AS SD2 (NOLOCK)
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD2.D2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      AND F4_CODIGO = D2_TES
      AND F4_ESTOQUE = 'S'  
      WHERE SD2.%NotDel%
        AND D2_EMISSAO > %Exp:dFechamento%
        AND D2_EMISSAO <= %Exp:dDataEstoque%
      GROUP BY D2_FILIAL,
               D2_COD) AS SD2 ON D2_FILIAL = B2_FILIAL
   AND D2_COD = B2_COD
    LEFT JOIN
     (SELECT C6_FILIAL,
             C6_PRODUTO,
             SUM(C6_QTDVEN-C6_QTDENT) AS C6_QTDVEN
      FROM %Table:SC6% AS SC6 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SC6.C6_PRODUTO AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = C6_TES
      AND F4_ESTOQUE = 'S'
      WHERE SC6.%NotDel%
		AND C6_BLQ = ''
		AND C6_QTDVEN - C6_QTDENT > 0
		AND C6_LOCAL = '14'
      GROUP BY C6_FILIAL,
               C6_PRODUTO) AS SC6 ON C6_FILIAL = B2_FILIAL
   AND C6_PRODUTO = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                CASE
                    WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                    ELSE D3_LOCAL
                END D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND (LEFT(D3_CF, 1) IN ('P',
                                   'D')
                OR D3_CF = 'RE3')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  CASE
                      WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                      ELSE D3_LOCAL
                  END) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD3 ON SD3.D3_FILIAL = B2_FILIAL
   AND SD3.D3_COD = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND LEFT(D3_CF, 1) IN ('R',
                                  'E')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  D3_LOCAL) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD4 ON SD4.D3_FILIAL = B2_FILIAL
   AND SD4.D3_COD = B2_COD
  
   ) AS EST
INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.%NotDel%
AND SB1.B1_COD = EST.B2_COD 

WHERE EST.QUANT > 0
AND B1_GRUPO IN ( %Exp:cxAcosLongos% )
and B2_FILIAL = %Exp:MV_PAR02%
             
ORDER BY 2

      
EndSQL                                     

                                               
oSection:EndQuery() 
oSection:SetParentQuery()


oReport:SetMeter((cAlias)->(RecCount())) 

oSection:Print()


oSection2:BeginQuery()

BeginSQL Alias cAlias2 
%noParser%


SELECT EST.B2_FILIAL,
       EST.B2_COD,
       B1_DESC,
	   B1_UM,
       EST.QUANT AS ESTOQUEAA
FROM
  (SELECT B2_FILIAL,
          B2_COD,
          ISNULL(B9_QINI, 0) + ISNULL(D1_QUANT, 0) + ISNULL(SD3.D3_QUANT, 0) - ISNULL(D2_QUANT, 0) - ISNULL(SD4.D3_QUANT, 0) - ISNULL(SC6.C6_QTDVEN, 0) AS QUANT,
          ISNULL(B9_VINI1, 0) + ISNULL(D1_CUSTO1, 0) + ISNULL(SD3.D3_CUSTO1, 0) - ISNULL(D2_CUSTO1, 0) - ISNULL(SD4.D3_CUSTO1, 0) AS CUSTO1,
          ISNULL(B9_VINI2, 0) + ISNULL(D1_CUSTO2, 0) + ISNULL(SD3.D3_CUSTO2, 0) - ISNULL(D2_CUSTO2, 0) - ISNULL(SD4.D3_CUSTO2, 0) AS CUSTO2
         
   FROM
     (SELECT B2_FILIAL,
             B2_COD
      FROM %Table:SB2% AS SB2(NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB2.B2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB2.%NotDel%
      GROUP BY B2_FILIAL,
               B2_COD) AS SB2
   INNER JOIN
     (SELECT B1_COD
      FROM %Table:SB1% SB1 (NOLOCK)
      WHERE D_E_L_E_T_ = ''
        AND B1_TIPO IN ('PA') ) AS SB1 ON SB1.B1_COD = SB2.B2_COD
   LEFT JOIN
     (SELECT B9_FILIAL,
             B9_COD,
             SUM(B9_QINI) AS B9_QINI,
             SUM(B9_VINI1) AS B9_VINI1,
             SUM(B9_VINI2) AS B9_VINI2
      FROM %Table:SB9% AS SB9 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB9.B9_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB9.%NotDel%
        AND B9_DATA = %Exp:dFechamento%
      GROUP BY B9_FILIAL,
               B9_COD) AS SB9 ON B9_FILIAL = B2_FILIAL
   AND B2_COD = B9_COD
   LEFT JOIN
     (SELECT D1_FILIAL,
             D1_COD,
             SUM(D1_QUANT) AS D1_QUANT,
             SUM(D1_CUSTO) AS D1_CUSTO1,
             SUM(D1_CUSTO2) AS D1_CUSTO2
      FROM %Table:SD1% AS SD1 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD1.D1_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = D1_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD1.%NotDel%
        AND D1_DTDIGIT > %Exp:dFechamento%
        AND D1_DTDIGIT <= %Exp:dDataEstoque%
      GROUP BY D1_FILIAL,
               D1_COD) AS SD1 ON D1_FILIAL = B2_FILIAL
   AND D1_COD = B2_COD
   LEFT JOIN
     (SELECT D2_FILIAL,
             D2_COD,
             SUM(D2_QUANT) AS D2_QUANT,
             SUM(D2_CUSTO1) AS D2_CUSTO1,
             SUM(D2_CUSTO2) AS D2_CUSTO2
      FROM %Table:SD2% AS SD2 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD2.D2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = D2_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD2.%NotDel%
        AND D2_EMISSAO > %Exp:dFechamento%
        AND D2_EMISSAO <= %Exp:dDataEstoque%
      GROUP BY D2_FILIAL,
               D2_COD) AS SD2 ON D2_FILIAL = B2_FILIAL
   AND D2_COD = B2_COD
    LEFT JOIN
     (SELECT C6_FILIAL,
             C6_PRODUTO,
             SUM(C6_QTDVEN-C6_QTDENT) AS C6_QTDVEN
      FROM %Table:SC6% AS SC6 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SC6.C6_PRODUTO AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = C6_TES
      AND F4_ESTOQUE = 'S'
      WHERE SC6.%NotDel%
		AND C6_BLQ = ''
		AND C6_QTDVEN - C6_QTDENT > 0
		AND C6_LOCAL = '14'
      GROUP BY C6_FILIAL,
               C6_PRODUTO) AS SC6 ON C6_FILIAL = B2_FILIAL
   AND C6_PRODUTO = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                CASE
                    WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                    ELSE D3_LOCAL
                END D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND (LEFT(D3_CF, 1) IN ('P',
                                   'D')
                OR D3_CF = 'RE3')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  CASE
                      WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                      ELSE D3_LOCAL
                  END) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD3 ON SD3.D3_FILIAL = B2_FILIAL
   AND SD3.D3_COD = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND LEFT(D3_CF, 1) IN ('R',
                                  'E')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  D3_LOCAL) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD4 ON SD4.D3_FILIAL = B2_FILIAL
   AND SD4.D3_COD = B2_COD
  
   ) AS EST
INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.%NotDel%
AND SB1.B1_COD = EST.B2_COD 

WHERE EST.QUANT > 0
AND B1_GRUPO IN (%Exp:cxChapas%)
and B2_FILIAL = %Exp:MV_PAR02%
ORDER BY 2

      
EndSQL                                     

                                               
oSection2:EndQuery() 
oSection2:SetParentQuery()


oReport:SetMeter((cAlias2)->(RecCount())) 

oSection2:Print()


oSection3:BeginQuery()

BeginSQL Alias cAlias3 
%noParser%


SELECT EST.B2_FILIAL,
       EST.B2_COD,
       B1_DESC,
	   B1_UM,
       EST.QUANT AS ESTOQUEAA
FROM
  (SELECT B2_FILIAL,
          B2_COD,
          ISNULL(B9_QINI, 0) + ISNULL(D1_QUANT, 0) + ISNULL(SD3.D3_QUANT, 0) - ISNULL(D2_QUANT, 0) - ISNULL(SD4.D3_QUANT, 0) - ISNULL(SC6.C6_QTDVEN, 0) AS QUANT,
          ISNULL(B9_VINI1, 0) + ISNULL(D1_CUSTO1, 0) + ISNULL(SD3.D3_CUSTO1, 0) - ISNULL(D2_CUSTO1, 0) - ISNULL(SD4.D3_CUSTO1, 0) AS CUSTO1,
          ISNULL(B9_VINI2, 0) + ISNULL(D1_CUSTO2, 0) + ISNULL(SD3.D3_CUSTO2, 0) - ISNULL(D2_CUSTO2, 0) - ISNULL(SD4.D3_CUSTO2, 0) AS CUSTO2
         
   FROM
     (SELECT B2_FILIAL,
             B2_COD
      FROM %Table:SB2% AS SB2(NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB2.B2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB2.%NotDel%
      GROUP BY B2_FILIAL,
               B2_COD) AS SB2
   INNER JOIN
     (SELECT B1_COD
      FROM %Table:SB1% SB1 (NOLOCK)
      WHERE D_E_L_E_T_ = ''
        AND B1_TIPO IN ('PA') ) AS SB1 ON SB1.B1_COD = SB2.B2_COD
   LEFT JOIN
     (SELECT B9_FILIAL,
             B9_COD,
             SUM(B9_QINI) AS B9_QINI,
             SUM(B9_VINI1) AS B9_VINI1,
             SUM(B9_VINI2) AS B9_VINI2
      FROM %Table:SB9% AS SB9 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB9.B9_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB9.%NotDel%
        AND B9_DATA = %Exp:dFechamento%
      GROUP BY B9_FILIAL,
               B9_COD) AS SB9 ON B9_FILIAL = B2_FILIAL
   AND B2_COD = B9_COD
   LEFT JOIN
     (SELECT D1_FILIAL,
             D1_COD,
             SUM(D1_QUANT) AS D1_QUANT,
             SUM(D1_CUSTO) AS D1_CUSTO1,
             SUM(D1_CUSTO2) AS D1_CUSTO2
      FROM %Table:SD1% AS SD1 (NOLOCK)
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD1.D1_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      AND F4_CODIGO = D1_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD1.%NotDel%
        AND D1_DTDIGIT > %Exp:dFechamento%
        AND D1_DTDIGIT <= %Exp:dDataEstoque%
      GROUP BY D1_FILIAL,
               D1_COD) AS SD1 ON D1_FILIAL = B2_FILIAL
   AND D1_COD = B2_COD
   LEFT JOIN
     (SELECT D2_FILIAL,
             D2_COD,
             SUM(D2_QUANT) AS D2_QUANT,
             SUM(D2_CUSTO1) AS D2_CUSTO1,
             SUM(D2_CUSTO2) AS D2_CUSTO2
      FROM %Table:SD2% AS SD2 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD2.D2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = D2_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD2.%NotDel%
        AND D2_EMISSAO > %Exp:dFechamento%
        AND D2_EMISSAO <= %Exp:dDataEstoque%
      GROUP BY D2_FILIAL,
               D2_COD) AS SD2 ON D2_FILIAL = B2_FILIAL
   AND D2_COD = B2_COD
    LEFT JOIN
     (SELECT C6_FILIAL,
             C6_PRODUTO,
             SUM(C6_QTDVEN-C6_QTDENT) AS C6_QTDVEN
      FROM %Table:SC6% AS SC6 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SC6.C6_PRODUTO AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = C6_TES
      AND F4_ESTOQUE = 'S'
      WHERE SC6.%NotDel%
		AND C6_BLQ = ''
		AND C6_QTDVEN - C6_QTDENT > 0
		AND C6_LOCAL = '14'
      GROUP BY C6_FILIAL,
               C6_PRODUTO) AS SC6 ON C6_FILIAL = B2_FILIAL
   AND C6_PRODUTO = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                CASE
                    WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                    ELSE D3_LOCAL
                END D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND (LEFT(D3_CF, 1) IN ('P',
                                   'D')
                OR D3_CF = 'RE3')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  CASE
                      WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                      ELSE D3_LOCAL
                  END) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD3 ON SD3.D3_FILIAL = B2_FILIAL
   AND SD3.D3_COD = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND LEFT(D3_CF, 1) IN ('R',
                                  'E')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  D3_LOCAL) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD4 ON SD4.D3_FILIAL = B2_FILIAL
   AND SD4.D3_COD = B2_COD
  
   ) AS EST
INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.%NotDel%
AND SB1.B1_COD = EST.B2_COD 

WHERE EST.QUANT > 0
AND B1_GRUPO IN (%Exp:cxMetalom%)
and B2_FILIAL = %Exp:MV_PAR02%
ORDER BY 2


      
EndSQL                                     

                                               
oSection3:EndQuery() 
oSection3:SetParentQuery()


oReport:SetMeter((cAlias3)->(RecCount())) 

oSection3:Print()

	

oSection4:BeginQuery()

BeginSQL Alias cAlias4 
%noParser%


SELECT EST.B2_FILIAL,
       EST.B2_COD,
       B1_DESC,
	   B1_UM,
       EST.QUANT AS ESTOQUEAA
FROM
  (SELECT B2_FILIAL,
          B2_COD,
          ISNULL(B9_QINI, 0) + ISNULL(D1_QUANT, 0) + ISNULL(SD3.D3_QUANT, 0) - ISNULL(D2_QUANT, 0) - ISNULL(SD4.D3_QUANT, 0) - ISNULL(SC6.C6_QTDVEN, 0) AS QUANT,
          ISNULL(B9_VINI1, 0) + ISNULL(D1_CUSTO1, 0) + ISNULL(SD3.D3_CUSTO1, 0) - ISNULL(D2_CUSTO1, 0) - ISNULL(SD4.D3_CUSTO1, 0) AS CUSTO1,
          ISNULL(B9_VINI2, 0) + ISNULL(D1_CUSTO2, 0) + ISNULL(SD3.D3_CUSTO2, 0) - ISNULL(D2_CUSTO2, 0) - ISNULL(SD4.D3_CUSTO2, 0) AS CUSTO2
         
   FROM
     (SELECT B2_FILIAL,
             B2_COD
      FROM %Table:SB2% AS SB2(NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB2.B2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB2.%NotDel%
      GROUP BY B2_FILIAL,
               B2_COD) AS SB2
   INNER JOIN
     (SELECT B1_COD
      FROM %Table:SB1% SB1 (NOLOCK)
      WHERE D_E_L_E_T_ = ''
        AND B1_TIPO IN ('PA') ) AS SB1 ON SB1.B1_COD = SB2.B2_COD
   LEFT JOIN
     (SELECT B9_FILIAL,
             B9_COD,
             SUM(B9_QINI) AS B9_QINI,
             SUM(B9_VINI1) AS B9_VINI1,
             SUM(B9_VINI2) AS B9_VINI2
      FROM %Table:SB9% AS SB9 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB9.B9_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB9.%NotDel%
        AND B9_DATA = %Exp:dFechamento%
      GROUP BY B9_FILIAL,
               B9_COD) AS SB9 ON B9_FILIAL = B2_FILIAL
   AND B2_COD = B9_COD
   LEFT JOIN
     (SELECT D1_FILIAL,
             D1_COD,
             SUM(D1_QUANT) AS D1_QUANT,
             SUM(D1_CUSTO) AS D1_CUSTO1,
             SUM(D1_CUSTO2) AS D1_CUSTO2
      FROM %Table:SD1% AS SD1 (NOLOCK)
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD1.D1_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      AND F4_CODIGO = D1_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD1.%NotDel%
        AND D1_DTDIGIT > %Exp:dFechamento%
        AND D1_DTDIGIT <= %Exp:dDataEstoque%
      GROUP BY D1_FILIAL,
               D1_COD) AS SD1 ON D1_FILIAL = B2_FILIAL
   AND D1_COD = B2_COD
   LEFT JOIN
     (SELECT D2_FILIAL,
             D2_COD,
             SUM(D2_QUANT) AS D2_QUANT,
             SUM(D2_CUSTO1) AS D2_CUSTO1,
             SUM(D2_CUSTO2) AS D2_CUSTO2
      FROM %Table:SD2% AS SD2 (NOLOCK)
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD2.D2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      AND F4_CODIGO = D2_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD2.%NotDel%
        AND D2_EMISSAO > %Exp:dFechamento%
        AND D2_EMISSAO <= %Exp:dDataEstoque%
      GROUP BY D2_FILIAL,
               D2_COD) AS SD2 ON D2_FILIAL = B2_FILIAL
   AND D2_COD = B2_COD
    LEFT JOIN
     (SELECT C6_FILIAL,
             C6_PRODUTO,
             SUM(C6_QTDVEN-C6_QTDENT) AS C6_QTDVEN
      FROM %Table:SC6% AS SC6 (NOLOCK)
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SC6.C6_PRODUTO AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      AND F4_CODIGO = C6_TES
      AND F4_ESTOQUE = 'S'
      WHERE SC6.%NotDel%
		AND C6_BLQ = ''
		AND C6_QTDVEN - C6_QTDENT > 0
		AND C6_LOCAL = '14'
      GROUP BY C6_FILIAL,
               C6_PRODUTO) AS SC6 ON C6_FILIAL = B2_FILIAL
   AND C6_PRODUTO = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                CASE
                    WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                    ELSE D3_LOCAL
                END D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND (LEFT(D3_CF, 1) IN ('P',
                                   'D')
                OR D3_CF = 'RE3')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  CASE
                      WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                      ELSE D3_LOCAL
                  END) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD3 ON SD3.D3_FILIAL = B2_FILIAL
   AND SD3.D3_COD = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND LEFT(D3_CF, 1) IN ('R',
                                  'E')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  D3_LOCAL) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD4 ON SD4.D3_FILIAL = B2_FILIAL
   AND SD4.D3_COD = B2_COD
  
   ) AS EST
INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.%NotDel%
AND SB1.B1_COD = EST.B2_COD 

WHERE EST.QUANT > 0
AND B1_GRUPO IN (%Exp:cxPerfil%)
and B2_FILIAL = %Exp:MV_PAR02%
ORDER BY 2
      
EndSQL                                     

                                               
oSection4:EndQuery() 
oSection4:SetParentQuery()


oReport:SetMeter((cAlias4)->(RecCount())) 

oSection4:Print()

			

oSection5:BeginQuery()

BeginSQL Alias cAlias5 
%noParser%


SELECT EST.B2_FILIAL,
       EST.B2_COD,
       B1_DESC,
	   B1_UM,
       EST.QUANT AS ESTOQUEAA
FROM
  (SELECT B2_FILIAL,
          B2_COD,
          ISNULL(B9_QINI, 0) + ISNULL(D1_QUANT, 0) + ISNULL(SD3.D3_QUANT, 0) - ISNULL(D2_QUANT, 0) - ISNULL(SD4.D3_QUANT, 0) - ISNULL(SC6.C6_QTDVEN, 0) AS QUANT,
          ISNULL(B9_VINI1, 0) + ISNULL(D1_CUSTO1, 0) + ISNULL(SD3.D3_CUSTO1, 0) - ISNULL(D2_CUSTO1, 0) - ISNULL(SD4.D3_CUSTO1, 0) AS CUSTO1,
          ISNULL(B9_VINI2, 0) + ISNULL(D1_CUSTO2, 0) + ISNULL(SD3.D3_CUSTO2, 0) - ISNULL(D2_CUSTO2, 0) - ISNULL(SD4.D3_CUSTO2, 0) AS CUSTO2
         
   FROM
     (SELECT B2_FILIAL,
             B2_COD
      FROM %Table:SB2% AS SB2(NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB2.B2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB2.%NotDel%
      GROUP BY B2_FILIAL,
               B2_COD) AS SB2
   INNER JOIN
     (SELECT B1_COD
      FROM %Table:SB1% SB1 (NOLOCK)
      WHERE D_E_L_E_T_ = ''
        AND B1_TIPO IN ('PA') ) AS SB1 ON SB1.B1_COD = SB2.B2_COD
   LEFT JOIN
     (SELECT B9_FILIAL,
             B9_COD,
             SUM(B9_QINI) AS B9_QINI,
             SUM(B9_VINI1) AS B9_VINI1,
             SUM(B9_VINI2) AS B9_VINI2
      FROM %Table:SB9% AS SB9 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SB9.B9_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      WHERE SB9.%NotDel%
        AND B9_DATA = %Exp:dFechamento%
      GROUP BY B9_FILIAL,
               B9_COD) AS SB9 ON B9_FILIAL = B2_FILIAL
   AND B2_COD = B9_COD
   LEFT JOIN
     (SELECT D1_FILIAL,
             D1_COD,
             SUM(D1_QUANT) AS D1_QUANT,
             SUM(D1_CUSTO) AS D1_CUSTO1,
             SUM(D1_CUSTO2) AS D1_CUSTO2
      FROM %Table:SD1% AS SD1 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD1.D1_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = D1_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD1.%NotDel%
        AND D1_DTDIGIT > %Exp:dFechamento%
        AND D1_DTDIGIT <= %Exp:dDataEstoque%
      GROUP BY D1_FILIAL,
               D1_COD) AS SD1 ON D1_FILIAL = B2_FILIAL
   AND D1_COD = B2_COD
   LEFT JOIN
     (SELECT D2_FILIAL,
             D2_COD,
             SUM(D2_QUANT) AS D2_QUANT,
             SUM(D2_CUSTO1) AS D2_CUSTO1,
             SUM(D2_CUSTO2) AS D2_CUSTO2
      FROM %Table:SD2% AS SD2 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD2.D2_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = D2_TES
      AND F4_ESTOQUE = 'S'
      WHERE SD2.%NotDel%
        AND D2_EMISSAO > %Exp:dFechamento%
        AND D2_EMISSAO <= %Exp:dDataEstoque%
      GROUP BY D2_FILIAL,
               D2_COD) AS SD2 ON D2_FILIAL = B2_FILIAL
   AND D2_COD = B2_COD
    LEFT JOIN
     (SELECT C6_FILIAL,
             C6_PRODUTO,
             SUM(C6_QTDVEN-C6_QTDENT) AS C6_QTDVEN
      FROM %Table:SC6% AS SC6 (NOLOCK)
      INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SC6.C6_PRODUTO AND B1_TIPO IN ('PA') AND SB1.%NotDel%
      INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.%NotDel%
      AND F4_CODIGO = C6_TES
      AND F4_ESTOQUE = 'S'
      WHERE SC6.%NotDel%
		AND C6_BLQ = ''
		AND C6_QTDVEN - C6_QTDENT > 0
		AND C6_LOCAL = '14'
      GROUP BY C6_FILIAL,
               C6_PRODUTO) AS SC6 ON C6_FILIAL = B2_FILIAL
   AND C6_PRODUTO = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                CASE
                    WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                    ELSE D3_LOCAL
                END D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND (LEFT(D3_CF, 1) IN ('P',
                                   'D')
                OR D3_CF = 'RE3')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  CASE
                      WHEN D3_CF = 'RE3' THEN %Exp:cLocProc%
                      ELSE D3_LOCAL
                  END) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD3 ON SD3.D3_FILIAL = B2_FILIAL
   AND SD3.D3_COD = B2_COD
   LEFT JOIN
     (SELECT D3_FILIAL,
             D3_COD,
             SUM(D3_QUANT) AS D3_QUANT,
             SUM(D3_CUSTO1) AS D3_CUSTO1,
             SUM(D3_CUSTO2) AS D3_CUSTO2
      FROM
        (SELECT D3_FILIAL,
                D3_COD,
                D3_LOCAL,
                SUM(D3_QUANT) AS D3_QUANT,
                SUM(D3_CUSTO1) AS D3_CUSTO1,
                SUM(D3_CUSTO2) AS D3_CUSTO2
         FROM %Table:SD3% AS SD3 (NOLOCK)
         INNER JOIN %Table:SB1% SB1 (NOLOCK) ON  SB1.B1_COD = SD3.D3_COD AND B1_TIPO IN ('PA') AND SB1.%NotDel%
         WHERE SD3.%NotDel%
           AND D3_ESTORNO = ''
           AND LEFT(D3_CF, 1) IN ('R',
                                  'E')
           AND D3_EMISSAO > %Exp:dFechamento%
           AND D3_EMISSAO <= %Exp:dDataEstoque%
         GROUP BY D3_FILIAL,
                  D3_COD,
                  D3_LOCAL) AS AUX
      GROUP BY D3_FILIAL,
               D3_COD) AS SD4 ON SD4.D3_FILIAL = B2_FILIAL
   AND SD4.D3_COD = B2_COD
  
   ) AS EST
INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.%NotDel%
AND SB1.B1_COD = EST.B2_COD 

WHERE EST.QUANT > 0
AND B1_GRUPO IN (%Exp:cxTubo%)
and B2_FILIAL = %Exp:MV_PAR02%
ORDER BY 2

      
EndSQL                                     

                                               
oSection5:EndQuery() 
oSection5:SetParentQuery()


oReport:SetMeter((cAlias5)->(RecCount())) 

oSection5:Print()

				
	
Return


Static function fGetData(xData)
Local dxRet    := ""
Local cQry     := ""
Local cxTablet := ""
Local aArea    := GetArea()

cQry     += "SELECT MAX(B9_DATA) AS DATA_INI FROM  " + RetSqlName("SB9") +"  AS SB9 (NOLOCK) WHERE SB9.D_E_L_E_T_ = '' AND B9_FILIAL = '01' AND B9_DATA < '"+xData+"' "
cxTablet := MpSysOpenQuery(cQry)
dxRet    := (cxTablet)->DATA_INI

RestArea(aArea)

Return dxRet

Return 

  