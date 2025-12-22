/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CFATR542 ³ Autor ³ Carlos Nina           ³ Data ³ 23/05/32 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera arquivo texto p/alimentar planilha para DCI           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Via VBA/Excell - Elizabete                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "rwmake.ch"        
#Include "protheus.ch"
#Include "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include "TOPCONN.CH"

User Function CFATR542()        // incluido pelo assistente de conversao do AP5 IDE em 11/10/01

Private oDlg,oButton1,oButton2,oButton3,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11
Private nOpcA := 0
Private cPerg := "FATR542   "

ValidPerg(cPerg)

Pergunte(cPerg,.F.)

  DEFINE MSDIALOG oDlg TITLE "Planilha para montagem de DCI" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 005, 004 SAY oSay1       PROMPT "Gera uma planilha pré-formatada para montagem do DCI."                 SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 012, 005 SAY oSay2       PROMPT "TES Padrão: 706,707,728,739,717                      "                 SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 020, 005 SAY oSay3       PROMPT "                                                     "                 SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 027, 005 SAY oSay4       PROMPT "** Nota: Havendo outras TES, acrescentar ao parametro"                 SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 035, 005 SAY oSay5       PROMPT "    1 - Tipo do Produto: Selecione Produto-Acabado ou"                     SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 042, 005 SAY oSay6       PROMPT "         Produto Intermediario (sub-conjunto)."                            SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 050, 005 SAY oSay7       PROMPT "    2 - Data-Base: Movimentação do inicio ao final do mes da"              SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 057, 005 SAY oSay8       PROMPT "         data informada."                                                  SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 065, 005 SAY oSay9       PROMPT "    3 - Recalculo efetuado: Quando o recalculo do custo medio"             SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 072, 005 SAY oSay10      PROMPT "         for   efetuado  para   acerto   de  custo  atual  ou  para  o "   SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 080, 005 SAY oSay11      PROMPT "         Fechamento do Mes."                                               SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
	 
    @ 005, 203 BUTTON oButton1 PROMPT "Parametros"          SIZE 037, 015 OF oDlg PIXEL Action Pergunte(cPerg,.T.)
    @ 025, 203 BUTTON oButton2 PROMPT "Gera Planilha"       SIZE 037, 015 OF oDlg PIXEL Action (nOpcA := 1 , oDlg:End())
    @ 045, 203 BUTTON oButton3 PROMPT "Sair"                SIZE 037, 015 OF oDlg PIXEL Action (nOpcA := 2 , oDlg:End())

	 ACTIVATE MSDIALOG oDlg CENTERED Valid nOpcA > 0

IF ( nOpcA == 1 )

	MsAguarde( { || f_geratxt()   } , "Extraindo movimentação do Período." ,"" , .T. )
	MsAguarde( { || f_loadExcel() } , "Carregando o Excel."                )

ENDIF
	
Return

////////////////////////////////////////////
Static Function f_LoadExcel()
////////////////////////////////////////////
Local oExcelApp

   ///
   ///Abre o Excel
   ///

	If ! ApOleClient( 'MsExcel' )                         // Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' )
		Return
	EndIf

	
	oExcelApp := MsExcel():New()                          // Cria um objeto para o uso do Excel
  	oExcelApp:WorkBooks:Open("C:\Relato\DCI\DCI.xls")     // Atribui à propriedade WorkBooks do Excel
	oExcelApp:SetVisible(.T.)                             // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	oExcelApp:Destroy()

Return

//////////////////////////////////////////////////////
Static Function f_GeraTxt()
//////////////////////////////////////////////////////
Local fArq,mLinDet
Local cGrp,cCond,cQuery,cQry
Local aPlacas := {}
Local aEletro := {}
Local mvpar03 := ALLTRIM(mv_par03)

mvpar03 := STRTRAN(mvpar03,",",";")
mvpar03 := FormatIn (mvpar03 , ";")
SET(1,"OFF")

///cGrp   := " GROUP BY D2_EMISSAO,D2_CLIENTE,D2_LOJA,A1_NOME,D2_CF,D2_DOC,F2_VOLUME1,F2_PBRUTO,F2_VALBRUT,F2_EST,A1_REGTRIB"
cOrde  := " ORDER BY D2_DOC,D2_ITEM " 
cCond  := " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND"
cCond  := cCond + " D2_FILIAL = '"+xFilial("SD2")+"' AND"
cCond  := cCond + " D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND"
cCond  := cCond + " D2_TES IN "+mvpar03+" AND"
cCond  := cCond + " B1_FILIAL = '"+xFilial("SB1")+"' AND"
cCond  := cCond + " B1_COD = D2_COD AND B1_TIPO = 'PA'"
		
cQuery := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SD2")+" A,"+RetSqlName("SB1")+" B" + cCond
cQry   := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'SOM', .T., .T.)
nRegistro := SOMA
SOM->(DbCloseArea())
		
cQuery := "SELECT D2_DOC,D2_COD,D2_QUANT,D2_TOTAL,D2_CF,D2_EST,D2_EMISSAO,B1_DESCOMP,B1_CLCFAM,B1_POSIPI,B1_X_DCR" 
cQuery += " FROM "+RetSqlName("SD2")+" A,"+RetSqlName("SB1")+" B" + cCond + cOrde  ///+ cGrp 
		
cQry := ChangeQuery(cQuery)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

dbSelectArea("TMP")
ProcRegua(nRegistro)
dbGoTop()
DO WHILE !EOF()
   IF LastKey()==286
      TMP->(dbCloseArea())
      Return
   ENDIF
   IncProc()
   IF (  TMP->B1_CLCFAM $ "22  ,23  ,0115" )
		AADD(aPlacas , { TMP->D2_DOC     , ;
							  TMP->D2_COD     , ; 
							  TMP->D2_QUANT   , ;
							  TMP->D2_TOTAL   , ;
							  TMP->D2_CF      , ;
							  TMP->D2_EST     , ;
							  TMP->D2_EMISSAO , ;
							  TMP->B1_X_DCR   , ;
							  TMP->B1_POSIPI  , ;
							  TMP->B1_DESCOMP } )
	ELSE						 
		AADD(aEletro , { TMP->D2_DOC     , ;
						     TMP->D2_COD     , ; 
							  TMP->D2_QUANT   , ;
							  TMP->D2_TOTAL   , ;
							  TMP->D2_CF      , ;
							  TMP->D2_EST     , ;
							  TMP->D2_EMISSAO , ;
							  TMP->B1_X_DCR   , ;
							  TMP->B1_POSIPI  , ;
							  TMP->B1_DESCOMP } )
   ENDIF
   dbSkip()
ENDDO
TMP->(dbCloseArea())
*
fArq := fCreate("C:\RELATO\Placas.txt")     
IF ( LEN(aPlacas) > 0 )
	nQty    := 0
	nTtl    := 0
	mLinDet := "|CB|RELACAO DE PLACAS - PERIODO DE "+DTOC(mv_par01)+" A "+DTOC(mv_par02)
	nx      := LEN(RTRIM(mLinDet))
	mLinDet += SPACE(177-nx)
	mLinDet += "|"+Chr(13)+Chr(10)
	FWrite(fArq,mLinDet)
	*
	mLinDet := "|CB|NFS       |COD_PROD                       |DESCRICAO................................................................................. |QUANT     |TOTAL         |NCM         |"   
	mLinDet += Chr(13)+Chr(10)
	mLinDet += "|CB|==========|===============================|===========================================================================================|==========|==============|============|"                        
	mLinDet += Chr(13)+Chr(10)                          ///                                                                                                999999.99  9999999999.99  9999.99.99                           
	FWrite(fArq,mLinDet)
	*
	FOR nx:=1 TO LEN(aPlacas)
			nQty += aPlacas[nx,3]
			nTtl += aPlacas[nx,4]
			///
			///Grava linha Detalhe
			///
			mLinDet := "|DT|"+aPlacas[nx,1]+" "                                              
			mLinDet += "|"+aPlacas[nx,2]+" "                                                 
			mLinDet += "|"+LEFT(aPlacas[nx,10],90)+" "                                                 
			mLinDet += "|"+STRTRAN(TRANSFORM(aPlacas[nx,3],"@E 999999.99"),",",".")+" "               
			mLinDet += "|"+STRTRAN(TRANSFORM(aPlacas[nx,4],"@E 9999999999.99"),",",".")+" "
			mLinDet += "|"+TRANSFORM(aPlacas[nx,9],"@R 9999.99.9999")      
			mLinDet += "|"+Chr(13)+Chr(10)
			FWrite(fArq,mLinDet)
			
	NEXT
	mLinDet := "|TT|          |** TOTAL DO PERIODO            "
	mLinDet += "|"+SPACE(91) 
	mLinDet += "|"+STRTRAN(TRANSFORM(nQty,"@E 999999.99"),",",".")+" "            
	mLinDet += "|"+STRTRAN(TRANSFORM(nTtl,"@E 9999999999.99"),",",".")+" "
	mLinDet += "|"+SPACE(12)                                              			 
	mLinDet += "|"+Chr(13)+Chr(10)
	FWrite(fArq,mLinDet)
	*
	mLinDet := "|FIM|"
	mLinDet += Chr(13)+Chr(10)
	FWrite(fArq,mLinDet)
ENDIF
fClose(fArq)
*
fArq := fCreate("C:\RELATO\Eletro.txt")     

IF ( LEN(aEletro) > 0 )
	nQty    := 0
	nTtl    := 0
	mLinDet := "|CB|RELACAO DE ELETRO-ELETRONICO - PERIODO DE "+DTOC(mv_par01)+" A "+DTOC(mv_par02)
	nx      := LEN(RTRIM(mLinDet))
	mLinDet += SPACE(162-nx)
	mLinDet += "|"+Chr(13)+Chr(10)
	FWrite(fArq,mLinDet)
	*
	mLinDet := "|CB|NFS       |DCR         |COD_PROD                       |DESCRICAO................................................................................. |QUANT     |"   
	mLinDet += Chr(13)+Chr(10)
	mLinDet += "|CB|==========|============|===============================|===========================================================================================|==========|"                        
	mLinDet += Chr(13)+Chr(10)                          ///                 ** total do periodo                                                                         999999.99  
	FWrite(fArq,mLinDet)
	*
	FOR nx:=1 TO LEN(aEletro)
			nQty += aEletro[nx,3]
			///
			///Grava linha Detalhe
			///
			mLinDet := "|DT|"+aEletro[nx,1]+" "                                              
			mLinDet += "|"+aEletro[nx,8]+" "                                                 
			mLinDet += "|"+aEletro[nx,2]+" "                                                 
			mLinDet += "|"+LEFT(aEletro[nx,10],90)+" "                                                 
			mLinDet += "|"+STRTRAN(TRANSFORM(aEletro[nx,3],"@E 999999.99"),",",".")+" "               
			mLinDet += "|"+Chr(13)+Chr(10)
			FWrite(fArq,mLinDet)
	NEXT
	mLinDet := "|TT|                                                       |** TOTAL DO PERIODO"+SPACE(72)
	mLinDet += "|"+STRTRAN(TRANSFORM(nQty,"@E 999999.99"),",",".")+" "            
	mLinDet += "|"+Chr(13)+Chr(10)
	FWrite(fArq,mLinDet)
	*
	mLinDet := "|FIM|"
	mLinDet += Chr(13)+Chr(10)
	FWrite(fArq,mLinDet)
ENDIF
fClose(fArq)

Return

//////////////////////////////////////////////////////
Static Function ValidPerg()
//////////////////////////////////////////////////////
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01          | DefSPA1 | DefEng1 | CNT01                  | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03    | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Do Periodo                  ?",   ""   ,  ""    , "mv_ch1" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_par01", "            " , "     " , "     " , "                    " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Até o Periodo               ?",   ""   ,  ""    , "mv_ch2" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_par02", "            " , "     " , "     " , "                    " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"03" , "TES utilizadas              ?",   ""   ,  ""    , "mv_ch3" , "C" ,   31   ,   0   ,   0   , "G" , "          "  , "mv_par03", "            " , "     " , "     " , "706,707,728,739,717 " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
		
Return