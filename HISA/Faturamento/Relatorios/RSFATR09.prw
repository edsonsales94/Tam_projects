#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR09  | Autor | Orismar Silva         | Data | 26/11/2014 
//=================================================================================
// Descricao | Relatorio de Custo por CFOP
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR09()

Private oReport, oSection1
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
Local cPerg   := "RSFATR09"
Local cTitulo := 'Relatório de Custo por CFOP'

CriaSx1(cPerg)

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR09", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Custo por CFOP")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Custo por CFOP.",{""})
oSection1:SetTotalInLine(.F.)
if mv_par03 = 2 //Sintetico
   TRCell():New(oSection1, "C_TIPO"	   , "", "TIPO"          ,,60)
   TRCell():new(oSection1, "C_PESO"    , "", "PESO(Kg)"      ,,15)
   TRCell():new(oSection1, "C_CUBAGEM" , "", "CUBAGEM (M³)"  ,,15)
   TRCell():new(oSection1, "C_VALOR"   , "", "VALOR"         ,,15)
else 
   TRCell():New(oSection1, "C_DOC"	     , "", "NOTA"          ,,60)
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
      _cQuery :=" SELECT DISTINCT '' F1_YMODAL,SUM(F1_PBRUTO) F1_PBRUTO, SUM(F1_YCUBAG) F1_YCUBAG,SUBSTRING(F1_DTDIGIT,5,2) MES,SUM(F1_VALBRUT) F1_VALBRUT "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1, "+ RetSqlName("SD1")+ " SD1 "
      _cQuery +=" WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''"
      _cQuery +=" AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE "      
      _cQuery +=" AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      /*
      if SM0->M0_CODFIL = "01"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par04, ",")
      elseif SM0->M0_CODFIL = "02"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par05, ",")
      else
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par06, ",")         
      endif
      */
      _cQuery +=" AND F1_FILIAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' " 
      cCFOP := ALLTRIM(mv_par04)+","+ALLTRIM(mv_par05)+","+ALLTRIM(mv_par06)
      _cQuery +=" AND D1_CF IN " + FormatIn(  cCFOP, ",")      
      //_cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" GROUP BY SUBSTRING(F1_DTDIGIT,5,2)  "
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2) "
   else //Analitico
      _cQuery :=" SELECT DISTINCT F1_DOC,F1_SERIE,F1_YMODAL,F1_PBRUTO, F1_YCUBAG,F1_DTDIGIT,F1_VALBRUT,SUBSTRING(F1_DTDIGIT,5,2) MES "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1, "+ RetSqlName("SD1")+ " SD1 "
      _cQuery +=" WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''"
      _cQuery +=" AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE "      
      _cQuery +=" AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      /*
      if SM0->M0_CODFIL = "01"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par04, ",")
      elseif SM0->M0_CODFIL = "02"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par05, ",")
      else
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par06, ",")         
      endif
      */
      _cQuery +=" AND F1_FILIAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' " 
      cCFOP := ALLTRIM(mv_par04)+","+ALLTRIM(mv_par05)+","+ALLTRIM(mv_par06)
      _cQuery +=" AND D1_CF IN " + FormatIn(  cCFOP, ",")      
      
//      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2),F1_DOC,F1_SERIE,F1_DTDIGIT "
   endif
   

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TWQ",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TWQ->(DbGoTop())
   oReport:SetMeter(TWQ->(RecCount()))
   While TWQ->( ! Eof() )
      nMes := TWQ->MES
      nTotCusto := 0
      If oReport:Cancel()
	      Exit
      EndIf	
	   oReport:IncMeter()
	   oSection1:Cell("C_TIPO"):SetValue("Mês: "+aMeses[VAL(TWQ->MES)])
	   oSection1:Cell("C_PESO" ):SetValue("")
	   oSection1:Cell("C_CUBAGEM"):SetValue("")
	   oSection1:Cell("C_VALOR"):SetValue("")
	   oReport:SkipLine()
	   oSection1:PrintLine() 
      While TWQ->( ! Eof() ) .and. nMes = TWQ->MES	
	      If oReport:Cancel()
		      Exit
 	      EndIf	
 	      if mv_par03 = 2 //Sintetico
	         oReport:IncMeter()
            oSection1:Cell("C_TIPO"):SetValue(SUBSTR(TWQ->F1_YMODAL,4,20))
	         oSection1:Cell("C_PESO"):SetValue(Transform(TWQ->F1_PBRUTO, "@E 999,999.9999"))             
	         oSection1:Cell("C_CUBAGEM"):SetValue(Transform(TWQ->F1_YCUBAG, "@E 999,999.9999"))
	         oSection1:Cell("C_VALOR"):SetValue(Transform(TWQ->F1_VALBRUT, "@E 99,999,999.99"))
      	   oReport:SkipLine()
	         oSection1:PrintLine()
	      else 
	         oReport:IncMeter()
            oSection1:Cell("C_DOC"):SetValue(TWQ->F1_DOC)
	         oSection1:Cell("C_SERIE"):SetValue(TWQ->F1_SERIE)             
	         oSection1:Cell("C_DTENTRADA"):SetValue(SUBSTR(F1_DTDIGIT,7,2)+"/"+SUBSTR(F1_DTDIGIT,5,2)+"/"+SUBSTR(F1_DTDIGIT,1,4))
            oSection1:Cell("C_TIPO"):SetValue(SUBSTR(TWQ->F1_YMODAL,4,20))
	         oSection1:Cell("C_PESO"):SetValue(Transform(TWQ->F1_PBRUTO, "@E 999,999.9999"))             
	         oSection1:Cell("C_CUBAGEM"):SetValue(Transform(TWQ->F1_YCUBAG, "@E 999,999.9999"))
	         oSection1:Cell("C_VALOR"):SetValue(Transform(TWQ->F1_VALBRUT, "@E 99,999,999.99"))
      	   oReport:SkipLine()
	         oSection1:PrintLine()     
            nTotBruto += TWQ->F1_PBRUTO
            nTotCubag += TWQ->F1_YCUBAG
            nTotValor += TWQ->F1_VALBRUT
	      endif
	      TWQ->(dbSkip())
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
   TWQ->(dbCloseArea())
   oSection1:Finish()      

Return


//=================================================================================
// relatorio de producao - formato padrao
//=================================================================================
Static Function ApRelRN()
Local cPerg   := "RSFATR09"

Private Tamanho  := "M"  // P- pequeno M- médio G- grande
Private titulo   := "Custo com Transporte"
Private cDesc1   := "Emitirá Relatorio de Custo por CFOP " 
Private cDesc2   := ""
Private cDesc3   := ""
Private cString  := "SD1"    // itens faturamento
Private aOrd     := {}
Private wnrel    := "RSFATR09"

Private nFator   := 0

PRIVATE aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nNivel    := 0       
Private nLin		:= 80                

// Cria as perguntas no SX1                                            
CriaSx1(cPerg)
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
   
      _cQuery :=" SELECT DISTINCT '' F1_YMODAL,SUM(F1_PBRUTO) F1_PBRUTO, SUM(F1_YCUBAG) F1_YCUBAG,SUBSTRING(F1_DTDIGIT,5,2) MES,SUM(F1_VALBRUT) F1_VALBRUT "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1, "+ RetSqlName("SD1")+ " SD1 "
      _cQuery +=" WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''"
      _cQuery +=" AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE "      
      _cQuery +=" AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      if SM0->M0_CODFIL = "01"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par04, ",")
      elseif SM0->M0_CODFIL = "02"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par05, ",")
      else 
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par06, ",")         
      endif
      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" GROUP BY SUBSTRING(F1_DTDIGIT,5,2)  "
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2) "
   else //Analitico
      Cabec1   := "Nota      Serie       Data       Tipo                  Peso(Kg)   Cubagem (m³)           Valor"
      Cabec2   := ""                                     
     	   		 // 999999999   999 99/99/9999 AAAAAAAAAAAAAAAAAAA     999,999.9999   999,999.9999   99,999,999.99
	      		 // 0         1         2         3         4         5         6         7         8         9         10        11        120
                // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890  

      _cQuery :=" SELECT DISTINCT F1_DOC,F1_SERIE, F1_YMODAL,F1_PBRUTO, F1_YCUBAG,F1_DTDIGIT,F1_VALBRUT,SUBSTRING(F1_DTDIGIT,5,2) MES "
      _cQuery +=" FROM "+ RetSqlName("SF1")+ " SF1, "+ RetSqlName("SD1")+ " SD1 "
      _cQuery +=" WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''"
      _cQuery +=" AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE "      
      _cQuery +=" AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "
      _cQuery +=" AND F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
      if SM0->M0_CODFIL = "01"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par04, ",")
      elseif SM0->M0_CODFIL = "02"
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par05, ",")
      else 
         _cQuery +=" AND D1_CF IN "+ FormatIn(  mv_par06, ",")                  
      endif
      _cQuery +=" AND F1_FILIAL = '"+SM0->M0_CODFIL+"'"
      _cQuery +=" ORDER BY SUBSTRING(F1_DTDIGIT,5,2),F1_DOC,F1_SERIE,F1_DTDIGIT "
   endif
   
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TWQ",.T.,.F.)

   If ! USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   Count to _nQtdReg
   ProcRegua(_nQtdReg) 
   SetRegua(_nQtdReg)

   TWQ->(DbGoTop())
   While TWQ->( ! Eof() )
      *
      nMes := TWQ->MES
      nTotCusto  := 0
      *
      If nLin > 60                                        
         nLin := Cabec(titulo,cabec1,cabec2,wnrel,Tamanho)+1
      Endif     
      *
      @ nLin,000 PSAY "Mês: "+aMeses[VAL(TWQ->MES)]
      nLin++
      While TWQ->( ! Eof() ) .and. nMes = TWQ->MES
	
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
	            @ nLin,000 PSAY SUBSTR(TWQ->F1_YMODAL,4,20)
	            @ nLin,024 PSAY Transform(TWQ->F1_PBRUTO,  "@E 999,999.9999")
	            @ nLin,039 PSAY Transform(TWQ->F1_YCUBAG,  "@E 999,999.9999")
	            @ nLin,054 PSAY Transform(TWQ->F1_VALBRUT, "@E 99,999,999.99")
	         else
	            @ nLin,000 PSAY TWQ->F1_DOC
               @ nLin,012 PSAY TWQ->F1_SERIE	            
               @ nLin,016 PSAY SUBSTR(F1_DTDIGIT,7,2)+"/"+SUBSTR(F1_DTDIGIT,5,2)+"/"+SUBSTR(F1_DTDIGIT,1,4)
  	            @ nLin,027 PSAY SUBSTR(TWQ->F1_YMODAL,4,20)
	            @ nLin,051 PSAY Transform(TWQ->F1_PBRUTO,  "@E 999,999.9999")
	            @ nLin,066 PSAY Transform(TWQ->F1_YCUBAG,  "@E 999,999.9999")
	            @ nLin,081 PSAY Transform(TWQ->F1_VALBRUT, "@E 99,999,999.99")
	            nTotBruto += TWQ->F1_PBRUTO
	            nTotCubag += TWQ->F1_YCUBAG
	            nTotValor += TWQ->F1_VALBRUT
            endif
	         
	         nLin++
            TWQ->(dbSkip())
      enddo                  
      if mv_par03 = 1
         @ nLin,027 PSAY "TOTAL.: " 
         @ nLin,051 PSAY Transform(nTotBruto,  "@E 999,999.9999")
         @ nLin,066 PSAY Transform(nTotCubag,  "@E 999,999.9999")
         @ nLin,081 PSAY Transform(nTotValor,  "@E 99,999,999.99")
         nTotBruto := 0
	      nTotCubag := 0
	      nTotValor := 0
	   endif
      nLin++                                                 
      nLin++
  EndDo
  TWQ->(dbCloseArea())
  
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
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Da Data ",29)+"?"              ,"","", "mv_ch1" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Data ",29)+"?"             ,"","", "mv_ch2" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Analitico/Sintetico ",29)+"?"  ,"","", "mv_ch3" , "N", 1 , 0, 1, "C", "", ""  , "", "", "mv_par03","Analitico","","","","Sintetico")   
	u_HMPutSX1(cPerg, "04", PADR("Cfop Fil 01",29)+"?"           ,"","", "mv_ch4" , "C", 20, 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Cfop Fil 02",29)+"?"           ,"","", "mv_ch5" , "C", 20, 0, 0, "G", "",   "", "", "", "mv_par05")
	u_HMPutSX1(cPerg, "06", PADR("Cfop Fil 04",29)+"?"           ,"","", "mv_ch6" , "C", 20, 0, 0, "G", "",   "", "", "", "mv_par06")
	u_HMPutSX1(cPerg, "07", PADR("Da Filial  ",29)+"?"           ,"","", "mv_ch7" , "C",  2, 0, 0, "G", "","SM0", "", "", "mv_par07")
   u_HMPutSX1(cPerg, "08", PADR("Ate Filial ",29)+"?"           ,"","", "mv_ch8" , "C",  2, 0, 0, "G", "","SM0", "", "", "mv_par08")

Return Nil
