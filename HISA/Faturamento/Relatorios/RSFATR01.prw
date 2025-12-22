#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR01  | Autor | Orismar Silva         | Data | 30/10/2013 
//=================================================================================
// Descricao | Relatorio de Aquisicao de Insumos
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR01()

Private oReport, oSection1
Private cPerg     := PadR("RSFATR01",10)
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

local cTitulo := 'Aquisição de Insumos'

CriaSx1()

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR01", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Aquisicao de Insumos")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Aquisição de Insumos.",{""})
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1, "C_PROD"	  , "", "DISCRIMINAÇÃO" ,,60)
TRCell():new(oSection1, "C_LOCAL"  , "", "LOCALIZAÇÃO"   ,,05)
TRCell():new(oSection1, "C_CUSTO"  , "", "CUSTO"         ,,15)
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
   Local x

    oSection1 := oReport:Section(1)

    oSection1:Init()
    oSection1:SetHeaderSection(.T.)


   _cQuery :=" SELECT CASE WHEN LEFT(D1_CF,1) = '1' THEN 'LOCAL' WHEN LEFT(D1_CF,1) = '2' THEN 'NACIONAL' ELSE 'IMPORTADO' END LOCALIZ,LEFT(D1_CF,1) D1_CF, SUM(D1_TOTAL-D1_VALDESC+D1_VALFRE+D1_DESPESA+D1_SEGURO) CUSTO, SUBSTRING(D1_DTDIGIT,5,2) MES,CASE WHEN B1_TIPO='MP'OR B1_TIPO='MI' THEN 'MATERIA PRIMA' ELSE 'MATERIAL DE EMBALAGEM' END DESCRI " 
   _cQuery +=" FROM "+ RetSqlName("SD1")+ " SD1, "+ RetSqlName("SB1")+ " SB1 " 
   _cQuery +=" WHERE SD1.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = ''
   _cQuery +=" AND D1_TIPO = 'N'
   _cQuery +=" AND D1_COD = B1_COD
   _cQuery +=" AND D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   _cQuery +=" AND B1_TIPO IN ('MP','MI', 'EM')
   _cQuery +=" GROUP BY B1_TIPO,SUBSTRING(D1_DTDIGIT,5,2),D1_CF
   _cQuery +=" ORDER BY LEFT(D1_CF,1),SUBSTRING(D1_DTDIGIT,5,2) " 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TMP",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TMP->(DbGoTop())
   oReport:SetMeter(TMP->(RecCount()))
   While TMP->( ! Eof() )
      nMes       := TMP->MES
      _aAquis    := {}      
      nTotCusto := 0
      If oReport:Cancel()
	      Exit
      EndIf	
	   oReport:IncMeter()
	   oSection1:Cell("C_PROD"):SetValue(aMeses[VAL(TMP->MES)])
	   oSection1:Cell("C_LOCAL" ):SetValue("")
	   oSection1:Cell("C_CUSTO"):SetValue("")
	   oReport:SkipLine()
	   oSection1:PrintLine() 
      While TMP->( ! Eof() ) .and. nMes = TMP->MES	
            _nCF := aScan( _aAquis, {|x| x[1] == TMP->D1_CF  .and. x[2] == TMP->DESCRI})
            If _nCF = 0
              aAdd(_aAquis,{TMP->D1_CF,TMP->DESCRI,TMP->LOCALIZ,TMP->CUSTO } )
            else
              _aAquis[_nCF][4] += TMP->CUSTO
            Endif	         
            TMP->(dbSkip())
      enddo 
      For x:=1 to Len(_aAquis)
	      If oReport:Cancel()
		      Exit
 	      EndIf	
	      oReport:IncMeter()
         oSection1:Cell("C_PROD"):SetValue(_aAquis[x][2])
	      oSection1:Cell("C_LOCAL"):SetValue(_aAquis[x][3])             
	      oSection1:Cell("C_CUSTO"):SetValue(_aAquis[x][4])
         nTotCusto  += _aAquis[x][4]
      	oReport:SkipLine()
	      oSection1:PrintLine()
      Next
	   oReport:IncMeter()
	   oSection1:Cell("C_PROD"):SetValue("")
      oSection1:Cell("C_LOCAL"):SetValue("")
	   oSection1:Cell("C_CUSTO"):SetValue(nTotCusto)
	   oReport:SkipLine()
	   oSection1:PrintLine()
   Enddo
   TMP->(dbCloseArea())
   oSection1:Finish()      

Return


//=================================================================================
// relatorio de producao - formato padrao
//=================================================================================
Static Function ApRelRN()

Private Tamanho  := "M"  // P- pequeno M- médio G- grande
Private titulo   := "Aquisicao de Insumos"
Private cDesc1   := "Emitirá Relatorio de Aquisicao de Insumos " 
Private cDesc2   := ""
Private cDesc3   := ""
Private cString  := "SD1"    // itens faturamento
Private aOrd     := {}
Private wnrel    := "RSFATR01"

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
   Local x
   //Local nTotPrd  := 0
   //Local nTotVend := 0
   //Local nTotFat  := 0
   Local _cQuery  := ""

 
   Cabec1   := "Discriminação         Localização          Custo"
   Cabec2   := ""
     			 // AAAAAAAAAAAAAAAAAAA     AAAAAAAAA  99,999,999.99
	    		 // 0         1         2         3         4         5         6         7         8         9         10        11        120
             // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   M_pag := ''                     
   titulo   := "Relatorio de Aquisicao de Insumos de - " +dtoc(mv_par01) +"  a  "+dtoc(mv_par02)


   _cQuery :=" SELECT CASE WHEN LEFT(D1_CF,1) = '1' THEN 'LOCAL' WHEN LEFT(D1_CF,1) = '2' THEN 'NACIONAL' ELSE 'IMPORTADO' END LOCALIZ,LEFT(D1_CF,1) D1_CF, SUM(D1_TOTAL-D1_VALDESC+D1_VALFRE+D1_DESPESA+D1_SEGURO) CUSTO, SUBSTRING(D1_DTDIGIT,5,2) MES,CASE WHEN B1_TIPO='MP'OR B1_TIPO='MI' THEN 'MATERIA PRIMA' ELSE 'MATERIAL DE EMBALAGEM' END DESCRI " 
   _cQuery +=" FROM "+ RetSqlName("SD1")+ " SD1, "+ RetSqlName("SB1")+ " SB1 " 
   _cQuery +=" WHERE SD1.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = ''
   _cQuery +=" AND D1_TIPO = 'N'
   _cQuery +=" AND D1_COD = B1_COD
   _cQuery +=" AND D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   _cQuery +=" AND B1_TIPO IN ('MP','MI', 'EM')
   _cQuery +=" GROUP BY B1_TIPO,SUBSTRING(D1_DTDIGIT,5,2),D1_CF
   _cQuery +=" ORDER BY LEFT(D1_CF,1),SUBSTRING(D1_DTDIGIT,5,2) " 
   
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
      nMes       := TMP->MES
      nTotCusto  := 0
      _aAquis    := {}      
      *
      If nLin > 60                                        
         nLin := Cabec(titulo,cabec1,cabec2,wnrel,Tamanho)+1
      Endif     
      *
      @ nLin,000 PSAY aMeses[VAL(TMP->MES)]
      nLin++
      *
      While TMP->( ! Eof() ) .and. nMes = TMP->MES
	         IncRegua()
	         *
	         If nLastKey == 27                                                   
		        Set Printer to
		        Return
	         Endif
	         *
            _nCF := aScan( _aAquis, {|x| x[1] == TMP->D1_CF .and. x[2] == TMP->DESCRI})
            If _nCF = 0
              aAdd(_aAquis,{TMP->D1_CF,TMP->DESCRI,TMP->LOCALIZ,TMP->CUSTO } )
            else
              _aAquis[_nCF][4] += TMP->CUSTO
            Endif	         
            TMP->(dbSkip())
      enddo 
      For x:=1 to Len(_aAquis)
          @ nLin,000 PSAY _aAquis[x][2]
          @ nLin,024 PSAY _aAquis[x][3]
          @ nLin,035 PSAY Transform(_aAquis[x][4], "@E 99,999,999.99")         
          nTotCusto  += _aAquis[x][4]
          If nLin > 60                                        
             nLin := Cabec(titulo,cabec1,cabec2,wnrel,Tamanho)+1
	       Endif            
	       nLin++
      Next                       
      nLin++                                                 
      @nLin,000 PSAY "Total Geral.:"                          
      @nLin,035 PSAY Transform( nTotCusto  , "@E 99,999,999.99") 
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

	u_HMPutSX1(cPerg, "01", PADR("Da Data ",29)+"?"     ,"","", "mv_ch1" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Data ",29)+"?"    ,"","", "mv_ch2" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par02")

Return Nil


