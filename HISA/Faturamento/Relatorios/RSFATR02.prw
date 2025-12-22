#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR02  | Autor | Orismar Silva         | Data | 30/10/2013 
//=================================================================================
// Descricao | Relatorio de Custo com Transporte
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR02()

Private oReport, oSection1
Private cPerg     := PadR("RSFATR02",10)
Private nTotQtd   := 0
Private nTotCust  := 0
Private ntotCusto := 0
Private aMeses    := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}

If FindFunction("TRepInUse") .And. TRepInUse()	// Interface de impressao   
	oReport := ReportDef()                         
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()
Else
    Return ApRelRN() // Executa versão nao personalizada
Endif

Return

//=================================================================================
// relatorio de producao - formato personalizavel
//=================================================================================
Static Function ReportDef()

local cTitulo := 'Custo com Transporte'

CriaSx1()

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR02", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório do Custo com Transporte")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Custo com Transporte.",{""})
oSection1:SetTotalInLine(.F.)
if mv_par03 = 2 //Sintetico
   TRCell():New(oSection1, "C_TIPO"	   , "", "TIPO"          ,,10)
   TRCell():new(oSection1, "C_PESO"    , "", "PESO(Kg)"      ,,15)
   TRCell():new(oSection1, "C_CUBAGEM" , "", "CUBAGEM (M³)"  ,,15)
   TRCell():new(oSection1, "C_VALOR"   , "", "VALOR"         ,,15)
else 
   TRCell():New(oSection1, "C_DOC"	     , "", "NOTA"          ,,10)
   TRCell():new(oSection1, "C_SERIE"     , "", "SERIE"         ,,15)
   TRCell():new(oSection1, "C_DTENTRADA" , "", "DATA"          ,,15)
   TRCell():New(oSection1, "C_TIPO"	     , "", "TIPO"          ,,60)
   TRCell():new(oSection1, "C_PESO"      , "", "PESO(Kg)"      ,,15)
   TRCell():new(oSection1, "C_CUBAGEM"   , "", "CUBAGEM (M³)"  ,,15)
   TRCell():new(oSection1, "C_VALOR"     , "", "VALOR"         ,,15)
endif
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
    Local nTotBruto := 0
	 Local nTotCubag := 0
	 Local nTotValor := 0

    oSection1 := oReport:Section(1)

    oSection1:Init()
    oSection1:SetHeaderSection(.T.)

   if mv_par03 = 2 // Sintentico
      _cQuery :=" SELECT F1_YMODAL,SUM(F1_PBRUTO) F1_PBRUTO, SUM(F1_YCUBAG) F1_YCUBAG,SUBSTRING(F1_DTDIGIT,5,2) MES,SUM(F1_VALBRUT) F1_VALBRUT "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1 "
      _cQuery +=" WHERE D_E_L_E_T_ = '' "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      _cQuery +=" AND F1_YMODAL <> '' "
      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" GROUP BY F1_YMODAL,SUBSTRING(F1_DTDIGIT,5,2)  "
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2) "
   else //Analitico
      _cQuery :=" SELECT F1_DOC,F1_SERIE,F1_YMODAL,F1_PBRUTO, F1_YCUBAG,F1_DTDIGIT,F1_VALBRUT,SUBSTRING(F1_DTDIGIT,5,2) MES "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1 "
      _cQuery +=" WHERE D_E_L_E_T_ = '' "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      _cQuery +=" AND F1_YMODAL <> '' "
      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2),F1_DOC,F1_SERIE,F1_DTDIGIT "
   endif
   

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TMP",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TMP->(DbGoTop())
   oReport:SetMeter(TMP->(RecCount()))
   While TMP->( ! Eof() )
      nMes := TMP->MES
      nTotCusto := 0
      If oReport:Cancel()
	      Exit
      EndIf	
	   oReport:IncMeter()
	   oSection1:Cell("C_TIPO"):SetValue(aMeses[VAL(TMP->MES)])
	   oSection1:Cell("C_PESO" ):SetValue("")
	   oSection1:Cell("C_CUBAGEM"):SetValue("")
	   oSection1:Cell("C_VALOR"):SetValue("")
	   oReport:SkipLine()
	   oSection1:PrintLine() 
      While TMP->( ! Eof() ) .and. nMes = TMP->MES	
	      If oReport:Cancel()
		      Exit
 	      EndIf	
 	      if mv_par03 = 2 //Sintetico
	         oReport:IncMeter()
            oSection1:Cell("C_TIPO"):SetValue(SUBSTR(TMP->F1_YMODAL,4,20))
	         oSection1:Cell("C_PESO"):SetValue(Transform(TMP->F1_PBRUTO, "@E 999,999.9999"))             
	         oSection1:Cell("C_CUBAGEM"):SetValue(Transform(TMP->F1_YCUBAG, "@E 999,999.9999"))
	         oSection1:Cell("C_VALOR"):SetValue(Transform(TMP->F1_VALBRUT, "@E 99,999,999.99"))
      	   oReport:SkipLine()
	         oSection1:PrintLine()
	      else 
	         oReport:IncMeter()
            oSection1:Cell("C_DOC"):SetValue(TMP->F1_DOC)
	         oSection1:Cell("C_SERIE"):SetValue(TMP->F1_SERIE)             
	         oSection1:Cell("C_DTENTRADA"):SetValue(SUBSTR(F1_DTDIGIT,7,2)+"/"+SUBSTR(F1_DTDIGIT,5,2)+"/"+SUBSTR(F1_DTDIGIT,1,4))
            oSection1:Cell("C_TIPO"):SetValue(SUBSTR(TMP->F1_YMODAL,4,20))
	         oSection1:Cell("C_PESO"):SetValue(Transform(TMP->F1_PBRUTO, "@E 999,999.9999"))             
	         oSection1:Cell("C_CUBAGEM"):SetValue(Transform(TMP->F1_YCUBAG, "@E 999,999.9999"))
	         oSection1:Cell("C_VALOR"):SetValue(Transform(TMP->F1_VALBRUT, "@E 99,999,999.99"))
      	   oReport:SkipLine()
	         oSection1:PrintLine()     
            nTotBruto += TMP->F1_PBRUTO
            nTotCubag += TMP->F1_YCUBAG
            nTotValor += TMP->F1_VALBRUT
	      endif
	      TMP->(dbSkip())
      enddo
 	   if mv_par03 = 1 //Analitico
	      oReport:IncMeter()
         oSection1:Cell("C_DOC"):SetValue("" )
	      oSection1:Cell("C_SERIE"):SetValue("")             
	      oSection1:Cell("C_DTENTRADA"):SetValue("")
         oSection1:Cell("C_TIPO"):SetValue("TOTAL.: ")
	      oSection1:Cell("C_PESO"):SetValue(Transform(nTotBruto, "@E 999,999.9999"))             
	      oSection1:Cell("C_CUBAGEM"):SetValue(Transform(nTotCubag, "@E 999,999.9999"))
	      oSection1:Cell("C_VALOR"):SetValue(Transform(nTotValor, "@E 99,999,999.99"))
         oReport:SkipLine()
	      oSection1:PrintLine()     
         nTotBruto := 0
         nTotCubag := 0
         nTotValor := 0
      endif
   Enddo
   TMP->(dbCloseArea())
   oSection1:Finish()      

Return


//=================================================================================
// relatorio de producao - formato padrao
//=================================================================================
Static Function ApRelRN()

Private Tamanho  := "M"  // P- pequeno M- médio G- grande
Private titulo   := "Custo com Transporte"
Private cDesc1   := "Emitirá Relatorio de Custo com Transporte " 
Private cDesc2   := ""
Private cDesc3   := ""
Private cString  := "SD1"    // itens faturamento
Private aOrd     := {}
Private wnrel    := "RSFATR02"

Private nFator   := 0

PRIVATE aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nNivel    := 0       
Private nLin		:= 80                

// Cria as perguntas no SX1                                            
CriaSx1()
Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Set Printer to
	Return
Endif

SetDefault(aReturn,cString)

RptStatus({|lEnd| ImpRelProd(@lEnd,wnRel,cString,tamanho,titulo)},titulo)

Return NIL

//=================================================================================
// IMPRIME O RELATORIO DA PRODUCAO NO FORMATO PADRAO
//=================================================================================
Static Function ImpRelProd(lEnd,WnRel,cString,tamanho,titulo)

   Local nTotBruto := 0
	Local nTotCubag := 0
	Local nTotValor := 0

   Local _cQuery  := ""

 
   M_pag := ''                     
   titulo   := "Relatorio de Custo com Transporte de - " +dtoc(mv_par01) +"  a  "+dtoc(mv_par02)

   if mv_par03 = 2 // Sintentico
      Cabec1   := "Tipo                      Peso(Kg)     Cubagem (m³)           Valor"
      Cabec2   := ""                                     
     	   		 // AAAAAAAAAAAAAAAAAAA     999,999.9999   999,999.9999   99,999,999.99
	      		 // 0         1         2         3         4         5         6         7         8         9         10        11        120
               // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890  
   
      _cQuery :=" SELECT F1_YMODAL,SUM(F1_PBRUTO) F1_PBRUTO, SUM(F1_YCUBAG) F1_YCUBAG,SUBSTRING(F1_DTDIGIT,5,2) MES,SUM(F1_VALBRUT) F1_VALBRUT "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1 "
      _cQuery +=" WHERE D_E_L_E_T_ = '' "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      _cQuery +=" AND F1_YMODAL <> '' "
      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" GROUP BY F1_YMODAL,SUBSTRING(F1_DTDIGIT,5,2)  "
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2) "
   else //Analitico
      Cabec1   := "Nota   Serie Data       Tipo                      Peso(Kg)     Cubagem (m³)           Valor"
      Cabec2   := ""                                     
     	   		 // 999999   999 99/99/9999 AAAAAAAAAAAAAAAAAAA     999,999.9999   999,999.9999   99,999,999.99
	      		 // 0         1         2         3         4         5         6         7         8         9         10        11        120
                // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890  

      _cQuery :=" SELECT F1_DOC,F1_SERIE,F1_YMODAL,F1_PBRUTO, F1_YCUBAG,F1_DTDIGIT,F1_VALBRUT,SUBSTRING(F1_DTDIGIT,5,2) MES "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1 "
      _cQuery +=" WHERE D_E_L_E_T_ = '' "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      _cQuery +=" AND F1_YMODAL <> '' "
      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2),F1_DOC,F1_SERIE,F1_DTDIGIT "
   endif
   
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TMP",.T.,.F.)

   If ! USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   Count to _nQtdReg
   ProcRegua(_nQtdReg) 
   SetRegua(_nQtdReg)

   TMP->(DbGoTop())
   While TMP->( ! Eof() )
      *
      nMes := TMP->MES
      nTotCusto  := 0
      *
      If nLin > 60                                        
         nLin := Cabec(titulo,cabec1,cabec2,wnrel,Tamanho)+1
      Endif     
      *
      @ nLin,000 PSAY aMeses[VAL(TMP->MES)]
      nLin++
      While TMP->( ! Eof() ) .and. nMes = TMP->MES
	
	         IncRegua()
	         *
	         If nLastKey == 27                                                   
		        Set Printer to
		        Return
	         Endif
	         *
	         If nLin > 60                                        
		         nLin := Cabec(titulo,cabec1,cabec2,wnrel,Tamanho)+1
	         Endif            
	         *
	         if mv_par03 = 2 // Sintetico
	            @ nLin,000 PSAY SUBSTR(TMP->F1_YMODAL,4,20)
	            @ nLin,024 PSAY Transform(TMP->F1_PBRUTO,  "@E 999,999.9999")
	            @ nLin,039 PSAY Transform(TMP->F1_YCUBAG,  "@E 999,999.9999")
	            @ nLin,054 PSAY Transform(TMP->F1_VALBRUT, "@E 99,999,999.99")
	         else
	            @ nLin,000 PSAY LEFT(TMP->F1_DOC,6)
               @ nLin,009 PSAY TMP->F1_SERIE	            
               @ nLin,013 PSAY SUBSTR(F1_DTDIGIT,7,2)+"/"+SUBSTR(F1_DTDIGIT,5,2)+"/"+SUBSTR(F1_DTDIGIT,1,4)
  	            @ nLin,024 PSAY SUBSTR(TMP->F1_YMODAL,4,20)
	            @ nLin,048 PSAY Transform(TMP->F1_PBRUTO,  "@E 999,999.9999")
	            @ nLin,063 PSAY Transform(TMP->F1_YCUBAG,  "@E 999,999.9999")
	            @ nLin,078 PSAY Transform(TMP->F1_VALBRUT, "@E 99,999,999.99")
	            nTotBruto += TMP->F1_PBRUTO
	            nTotCubag += TMP->F1_YCUBAG
	            nTotValor += TMP->F1_VALBRUT
            endif
	         
	         nLin++
            TMP->(dbSkip())
      enddo                  
      if mv_par03 = 1
         @ nLin,024 PSAY "TOTAL.: " 
         @ nLin,048 PSAY Transform(nTotBruto,  "@E 999,999.9999")
         @ nLin,063 PSAY Transform(nTotCubag,  "@E 999,999.9999")
         @ nLin,078 PSAY Transform(nTotValor, "@E 99,999,999.99")
         nTotBruto := 0
	      nTotCubag := 0
	      nTotValor := 0
	   endif
      nLin++                                                 
      nLin++
  EndDo
  TMP->(dbCloseArea())
  
   If aReturn[5] = 1                                                           
	   Set Printer TO
	   Commit
	   OurSpool(wnrel)
   Endif
   MS_FLUSH()
Return


//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1()

	u_HMPutSX1(cPerg, "01", PADR("Da Data ",29)+"?"              ,"","", "mv_ch1" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Data ",29)+"?"             ,"","", "mv_ch2" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Analitico/Sintetico ",29)+"?","","","mv_ch3" , "N", 1 , 0, 1, "C", "", ""  , "", "", "mv_par03","Analitico","","","","Sintetico")   

Return Nil


