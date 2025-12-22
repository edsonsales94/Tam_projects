#include "protheus.ch"                                                                                     
#include "rwmake.ch"      
#include "Font.ch"
#include "Colors.ch"  
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³GERPOFOL   º Autor ³ Arnaldo C. Pontes º Data ³ 14/05/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Rotina para geração do espelho de ponto e da folha de      º±±
±±º          ³ pagamento em um único relatório.                           º±±                
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Seiren Produtos Automotivos Ltda                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Descrição                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  /  /    ³                                                            º±±
±±º  /  /    ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function GERPOFOL


Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0 
Local cCadastro := OemToAnsi("Impressão de espelho de ponto e recibo de pgto.")
Private cPerg   := "GERPOFOLHA"

AADD(aSays,OemToAnsi( "Programa para unificação da folha de pagamento e espelho de ponto."))
AADD(aSays,OemToAnsi( " Para que o programa funcione é necessário gerar ANTES:"))
AADD(aSays,OemToAnsi( "Gerar o espelho de ponto PONR010 na pasta Spool."))
AADD(aSays,OemToAnsi( "Gerar o recibo de pagamento Gper030 na pasta Spool.")) 
AADD(aSays,OemToAnsi( "O receibo de pagamento deve ser ajustado (ZEBRADO OU PRE-IMPRESSO)."))
AADD(aSays,OemToAnsi( "A mesma faixa de colaboradores deve ser utilizada nos relatórios."))
AADD(aSays,OemToAnsi( "Somente serão listados colaboradores que tiverem espelho de ponto."))
AADD(aSays,OemToAnsi( "Exceto para o 13o, que não necessite de espelho de ponto."))

//ValidPerg(cPerg)
pergunte(cPerg,.F.)                                                                         
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa( { |lEnd| GeraFLPO() })
EndIf

Return .T.


Static Function GeraFLPO

//Local cPonr010 := Iif(Upper(Substr(cUsuario,7,6)) == "SOLANG","\Spool\solange_jesus\Ponr010.##R","\Spool\camila_castro\Ponr010.##R") 
// "\Spool\Ponr010.##R"
//Local cGper030 := Iif(Upper(Substr(cUsuario,7,6)) == "SOLANG","\Spool\solange_jesus\Gper030.##R","\Spool\camila_castro\Gper030.##R")
// "\Spool\Gper030.##R"

Local cLinha   := ""
Local cResult  := ""
Local cChapa   := ""
Local aChapa   := {}
Local nHdl     := 0   
Local nIni     := 0
Local nFim     := 0
Local nLin     := 0
Local nMax     := 0   

Private _aPonto:= {}
Private _aFolha:= {}
Private cPonr010:=""
Private cGper030:=""


cPonr010 := Iif(Upper(Substr(cUsuario,7,6)) == "ARNALD","\Spool\arnaldo_pontes\Ponr010.##R", cPonr010)
cGper030 := Iif(Upper(Substr(cUsuario,7,6)) == "ARNALD","\Spool\arnaldo_pontes\Gper030.##R", cGper030)
cPonr010 := Iif(Upper(Substr(cUsuario,7,6)) == "RODINE","\Spool\rodinei_sturaro\Ponr010.##R", cPonr010)
cGper030 := Iif(Upper(Substr(cUsuario,7,6)) == "RODINE","\Spool\rodinei_sturaro\Gper030.##R", cGper030)


//**************************************************************************************
// Código para leitura do arquivo Ponr010.##R
//**************************************************************************************
If Mv_Par02 == 1
	nHdl := FT_FUse(cPonr010)
	If nHdl > 0 
   		FT_FGoTop()
   		While !FT_FEof()    
       		cLinha := FT_FReadLn()
       
	   		If (AT('EMP...:',Upper(cLinha)) <> 0)
            	If nIni == 0 
                	cChapa := Substr(cLinha,73,6)
                	//cChapa := Substr(cLinha,92,6)
                	nIni := 1
                	nMax := 0
             	Else
                	nFim := 1
             	EndIf
       		EndIf
       
       		If (nIni <> 0) .and. (nFim == 0)
          		If (AT('-----',Upper(cLinha)) <> 0)
             		cResult := cResult + Replicate("-",140) + Chr(13) + Chr(10)
          		Else   
          	 		cResult := cResult + cLinha + Space(140-Len(cLinha)) + Chr(13) + Chr(10)
          		EndIf	 
          		cResult := cResult + Space(140) + Chr(13) + Chr(10)
          		nMax++
          		nMax++
       		EndIf
       		If nFim = 1
          		For x := 1 to 120-nMax
          			cResult := cResult + Space(140) + Chr(13) + Chr(10)
          		Next
          		If !File('\Spool\GERPOFOL\PO'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'.txt')
          			nHandle := FCreate('\Spool\GERPOFOL\PO'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'.txt') 
          		Else
          			nHandle := FCreate('\Spool\GERPOFOL\PO'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'1.txt')
          		EndIf		 
          		FWrite(nHandle, cResult, Len(cResult))       
		  		FClose(nHandle)
          		cResult := ''
          		cChapa := Substr(cLinha,73,6)
          		//cChapa := Substr(cLinha,92,6)
          		cResult := cResult + cLinha + Space(140-Len(cLinha)) + Chr(13) + Chr(10)
          		cResult := cResult + Space(140) + Chr(13) + Chr(10)
          		nFim := 0
          		nMax := 0
       		EndIf            
       		FT_FSkip()
   		End 
		//**************************************************************************************
   		// Bloco para a última matrícula que deve ser lida mesmo com o fim do arquivo
   		//**************************************************************************************   
   		If FT_FEof()
     		cLinha := FT_FReadLn()
   	 		For x := 1 to 120-nMax
       			cResult := cResult + Space(140) + Chr(13) + Chr(10)
     		Next
     		If !File('\Spool\GERPOFOL\PO'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'.txt')
          		nHandle := FCreate('\Spool\GERPOFOL\PO'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'.txt') 
     		Else 
       	  		nHandle := FCreate('\Spool\GERPOFOL\PO'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'1.txt')
     		Endif
     		FWrite(nHandle, cResult, Len(cResult))       
	 		FClose(nHandle)
     		cResult := ''
     		cChapa := Substr(cLinha,73,6)
     		//cChapa := Substr(cLinha,92,6)
     		cResult := cResult + cLinha + Space(140-Len(cLinha)) + Chr(13) + Chr(10)
     		cResult := cResult + Space(140) + Chr(13) + Chr(10)
     		nFim := 0
     		nMax := 0		   
   		EndIf
	Else
   		MsgBox("O arquivo de ponto (Ponr010) não foi encontrado", "Processo interrompido", "INFO")
   		return  
	EndIf
	FT_FUSE()
EndIf




//**************************************************************************************
// Código para leitura do arquivo Gper030.##R
//**************************************************************************************
cResult := ""
nIni    := 0
nFim    := 0
lCont   := .F.

nHdl := FT_FUse(cGper030)
If nHdl > 0 
   FT_FGoTop()
   While !FT_FEof()    
       cLinha := FT_FReadLn()
       
       If Mv_Par01 == 1
       
		   If (AT('EMPRESA',Upper(cLinha)) <> 0)
   	         nIni := 1
	   	   EndIf
	   	   If (AT('MATRICULA',Upper(cLinha)) <> 0)
             cChapa := Substr(cLinha,15,6)
           EndIf
	       If (AT('RECEBI O VALOR',Upper(cLinha)) <> 0)
             nFim := 1
           EndIf
       
           If (nIni <> 0) .and. (nFim == 0)
              If (AT('-----',Upper(cLinha)) <> 0)
                 cResult := cResult + Replicate("-",132) + Chr(13) + Chr(10)
              Else   
                 If Substr(cLinha,1,1) <> ""
                   cResult := cResult + cLinha + Space(132-Len(cLinha)) + Chr(13) + Chr(10)
                 EndIf
              EndIf   
              If (AT('|',Upper(cLinha)) <> 0)
                cResult := cResult + Space(132) + Chr(13) + Chr(10)
              EndIf
           EndIf
       EndIf
       
       If Mv_Par01 == 2
       
		   If (AT('SEIREN',Upper(cLinha)) <> 0)
   	         nIni := 1
   	         lCont:= .F.                       
   	         For x := 1 to 32
   	            
   	            If (AT('CONTINUA !!!',Upper(cLinha)) <> 0)
   	               lCont := .T.  
   	            EndIf
   	            
   	            If lCont
   	            	cResult := cResult + cLinha + Space(132-Len(cLinha)) + Chr(13) + Chr(10)
   	            	cLinha := Space(132)
   	            EndIf
   	               
   	            If !lCont
	   	            cLinha := FT_FReadLn()
   		            cLinha := StrTran (cLinha, Chr(12), Space(1))
   		            cLinha := StrTran (cLinha, Chr(08), Space(1))
   		         	If x == 31
   	   		      		cResult := cResult + Substr(cLinha,1,35) + Substr(cLinha,45,96) + Space(132-Len(cLinha)) + Chr(13) + Chr(10)
   	       		  	else
   	         			cResult := cResult + cLinha + Space(132-Len(cLinha)) + Chr(13) + Chr(10)
   	        	 	EndIf
   	        	 	cResult := cResult + Space(132) + Chr(13) + Chr(10)

   	         		If x == 4 
   	        	 	    cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         			cResult := cResult + " MATR:  NOME:                        CBO:   EMP:            C.CUSTO:"  + Chr(13) + Chr(10)
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         		EndIf
   	         		If x == 5
   	         			cChapa := Substr(cLinha,2,6)
   	         		EndIf
   	         		If x == 8
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         			cResult := cResult + " CÓD:            DESCRIÇÃO:            REF:      VENCIMENTO:   DESCONTO:"   + Chr(13) + Chr(10)
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         		EndIf
   	       	  		If x == 25
   	          			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         			cResult := cResult + "                                                TOTAL VENC:   TOTAL DESC:" + Chr(13) + Chr(10)
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	        	 	EndIf
   	         		If x == 27
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         			cResult := cResult + "                                                           VALOR LÍQUIDO:"  + Chr(13) + Chr(10)
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         		EndIf
   	         		If x == 29
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         			cResult := cResult + "           SALAR.BASE:       SAL.CONTR.INSS:        BASE.CALC.FGTS        FGTS DO MES:       BASE.CALC.IRRF:"  + Chr(13) + Chr(10)
   	         			cResult := cResult + Replicate("-",132)  + Chr(13) + Chr(10)
   	         		EndIf
  	         		FT_FSkip()
  	         	EndIf	
   	         Next   
   	         cLinha := FT_FReadLn()
   	         nFim := 1	
	   	   	
	   	   EndIf
       EndIf
       
       If nFim = 1
          aadd(aChapa,cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase))))
          cResult := cResult + cLinha + Space(132-Len(cLinha)) + Chr(13) + Chr(10)
          If !file('\Spool\GERPOFOL\Fl'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'.txt')
          		nHandle := FCreate('\Spool\GERPOFOL\Fl'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'.txt') 
          Else
          		nHandle := FCreate('\Spool\GERPOFOL\Fl'+cChapa+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+'1.txt') 
          EndIf
          FWrite(nHandle, cResult, Len(cResult))       
		  FClose(nHandle)
          cResult := ''
          nIni := 0
          nFim := 0
       EndIf             
       FT_FSkip()
   End
Else
   MsgBox("O arquivo da folha (Gper030) não foi encontrado", "Processo interrompido", "INFO")
   return  
EndIf
FT_FUSE()

nHandle := FCreate('\Spool\GERPOFOL\GERAL'+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+".txt")
lPrimeira:= .T.
cNChapa := aChapa[1]
For i := 1 to Len(aChapa)
   cResult := ""
   _aPonto := {}
   _aFolha := {}
   //**************************************************************************************
   // Abre o arquivo do ponto e carrega o arrray aPonto
   //**************************************************************************************

   nHdl := FT_FUse("\Spool\GERPOFOL\PO"+aChapa[i]+".txt")
		
   If nHdl > 0 
     FT_FGoTop()
     While !FT_FEof()    
         aadd(_aPonto,FT_FReadLn())
         FT_FSkip()
     End
     FT_FUSE()
   Else
   	   If MsgBox("O arquivo do Ponto PO"+aChapa[i]+".txt não foi encontrado. Gerar ponto em branco?" , "Atenção!", "YESNO")
   	      For x := 1 to 122                                   
//   	         If x == 60
//   	         	aadd(_aPonto,Space(54)+"E  M    B  R  A  N  C  O"+Space(60))
//   	         Else 
   	            aadd(_aPonto,Space(140))	                                             
//   	         EndIf
   	      Next 
   	   Else
   	      Alert("Processo abortado!")
   	      Return()
   	   EndIf
   EndIf
   //**************************************************************************************
   // Abre o arquivo da folha e carrega o array aFolha
   //**************************************************************************************
   If cNChapa == aChapa[i] .AND. i > 1
   		nHdl := FT_FUse("\Spool\GERPOFOL\Fl"+aChapa[i]+"1.txt")
   Else
   		nHdl := FT_FUse("\Spool\GERPOFOL\Fl"+aChapa[i]+".txt")
   EndIf		
   If nHdl > 0
     FT_FGoTop()
     While !FT_FEof()    
         aadd(_aFolha,FT_FReadLn())
         FT_FSkip()
     End
     FT_FUSE()
   Else
   	  MsgBox("Erro no arquivo de folha Fl"+aChapa[i]+".txt" , "Processo interrompido", "INFO")
   EndIf    
   //**************************************************************************************
   // Une os arquivos linha por linha
   //**************************************************************************************
   nLin := 0
   For x := 1 to Len(_aPonto)
       If x <= Len(_aFolha)
          cResult := cResult + _aPonto[x] +'|            |'+ _aFolha[x] + Chr(13) + Chr(10)
       Else                         
          cResult := cResult + _aPonto[x] + Chr(13) + Chr(10)
       EndIf
       nLin++   
   Next
   //**************************************************************************************
   // Garante que o novo arquivo conterá 120 linhas
   //**************************************************************************************
   For x := 1 to 120-nLin
   		cResult := cResult + space(10) + Chr(13) + Chr(10)
   Next                                                   
   If lPrimeira
      lPrimeira = .F.
      cResult := cResult + space(10) + Chr(13) + Chr(10)
      cResult := cResult + space(10) + Chr(13) + Chr(10)
   EndIf
   FWrite(nHandle, cResult, Len(cResult))

   If cNChapa <> aChapa[i] 
   	  cNChapa := aChapa[i]
   EndIf	  

next      
FClose(nHandle) 

//For x := 1 to Len(aChapa)
//    FErase("\Spool\GERPOFOL\PO"+aChapa[x]+".txt") 
//    FErase("\Spool\GERPOFOL\Fl"+aChapa[x]+".txt")
//Next        
Relatorio()
Return

//---------------------------------------------------------------------------------------
Static Function Relatorio()
//---------------------------------------------------------------------------------------

Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .F.
Local cNomeArq := "FOLPON" 
Local Matricula:= ""
Local Colabora := ""
Local CCusto   := ""
Local nLin     := 0
Local nMat     := 0

PRIVATE oPrint     := FWMSPrinter():New(cNomeArq, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
PRIVATE oFont05    := TFont():New('Courier New',,-05,.F.) 
PRIVATE oFont06    := TFont():New('Courier New',,-06,.F.)
PRIVATE oFont14    := TFont():New('Courier New',,-14,.F.)
PRIVATE nTamLin := 50
PRIVATE cLg     := GetSrvProfString("Startpath","")
Private lPrimVez:= .T.
//**************************************************************************************
// Abre o arquivo já devidamente formatado para a impressão
//**************************************************************************************
nHdl := FT_FUse("\Spool\GERPOFOL\GERAL"+AllTrim(Str(Year(DDatabase)))+AllTrim(Str(Month(DDataBase)))+".txt")
//**************************************************************************************
// Configurações da impressão
//**************************************************************************************
oPrint:SetResolution(72)
oPrint:SetLandscape() 
oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin( 40, 40, 40, 40) 
oPrint:SetFont(oFont05)

oPrint:StartPage()   

If nHdl > 0 
   FT_FGoTop()
   While !FT_FEof()    
       cLinha := FT_FReadLn()
       //**************************************************************************************
       // Busca na linha pelos textos Matricula, centro de custo e Nome
       //**************************************************************************************
       If Mv_Par01 == 1
       		If At("MATRICULA", Upper(cLinha)) > 0
	   			Matricula := Substr(cLinha, 169, 6)
	   		EndIf
       		If At("NOME", Upper(cLinha)) > 0
	   			Colabora := Substr(cLinha, 187, 30)
		    EndIf
	   EndIf
       If Mv_Par01 == 2
       		If At("MATR..:", Upper(cLinha)) > 0
	   			Matricula := Substr(cLinha, 73, 6)
	   		EndIf		
       		If At("NOME..:", Upper(cLinha)) > 0
	   			Colabora := Substr(cLinha, 70, 30)
		    EndIf
		    If At("MATR:  NOME:", Upper(cLinha)) > 0
		       nMat := 1
		    endIf   
		    If Empty(Matricula) .and. nMat == 3
		       Matricula := Substr(cLinha,156,6)
		       Colabora := Substr(cLinha,163,29)
		    EndIf   		        
	   EndIf
	              
       If At("C.C...:", Upper(cLinha)) > 0
	   		CCusto := Substr(cLinha, 9, 45)
	   EndIf 
	   //**************************************************************************************
       // Imprime o conteúdo de cada linha
       //**************************************************************************************
       If lPrimVez
       		nTamLin := nTamLin + 5
       		nLin++
       		nMat++ 
       		oPrint:Say(nTamLin, 002, Replicate(" ",286) , oFont05,,CLR_BLACK)
       		nTamLin := nTamLin + 5
       		nLin++
       		nMat++ 
       		oPrint:Say(nTamLin, 002, Replicate(" ",286) , oFont05,,CLR_BLACK)
       		lPrimVez := .F.
       endif

       If Mv_Par01 == 2
       		oPrint:Say(nTamLin, 002, Substr(cLinha,1,145) , oFont05,,CLR_BLACK)
       		oPrint:Say(nTamLin, 400, Substr(cLinha,146,120) , oFont06,,CLR_BLACK)
       Else
      		oPrint:Say(nTamLin, 002, cLinha , oFont05,,CLR_BLACK)
       EndIf	
       
       nTamLin := nTamLin + 5
       nLin++
       nMat++        
       
       //**************************************************************************************
	   // Após as informações do funcionário deve-se gerar nova pagina com a "capa"
	   //**************************************************************************************
       If nLin == 122
			oPrint:StartPage()
			nTamLin := 50 
			For x := 1 to 47
				oPrint:Say(nTamlin, 002, Replicate("#",125) , oFont14,,CLR_GRAY)
				nTamLin := nTamLin + 5
			Next
			oPrint:Say(297, 002, "Matrícula...: "+Matricula+Space(50-Len(Matricula))+"Matrícula...: "+Matricula , oFont14,,CLR_BLACK)
			oPrint:Say(312, 002, "Colaborador.: "+Colabora+Space(50-Len(Colabora))+"Colaborador.: "+Colabora  , oFont14,,CLR_BLACK)
			oPrint:Say(327, 002, "Centro Custo: "+CCusto+Space(50-Len(CCusto))+"Centro Custo: "+CCusto  , oFont14,,CLR_BLACK)
			nTamLin := 215
			For x := 1 to 54
				oPrint:Say(nTamlin+125, 002, Replicate("#",125) , oFont14,,CLR_GRAY)
				nTamLin := nTamLin + 5
			Next
			oPrint:StartPage()
			nLin := 0
			nTamLin := 50
			Matricula := ""
			Colabora := ""
			CCusto := ""
		EndIf	
		FT_FSkip()
   end			
   FT_FUSE()
EndIf
//**************************************************************************************
// Código para finalizar o relatório com a "capa" do último funcionário.
//**************************************************************************************
oPrint:StartPage()
nTamLin := 50 
For x := 1 to 47
	oPrint:Say(nTamlin, 002, Replicate("#",125) , oFont14,,CLR_GRAY)
	nTamLin := nTamLin + 5
Next
oPrint:Say(297, 002, "Matrícula...: "+Matricula+Space(50-Len(Matricula))+"Matrícula...: "+Matricula , oFont14,,CLR_BLACK)
oPrint:Say(312, 002, "Colaborador.: "+Colabora+Space(50-Len(Colabora))+"Colaborador.: "+Colabora  , oFont14,,CLR_BLACK)
oPrint:Say(327, 002, "Centro Custo: "+CCusto+Space(50-Len(CCusto))+"Centro Custo: "+CCusto  , oFont14,,CLR_BLACK)
nTamLin := 215
For x := 1 to 54
	oPrint:Say(nTamlin+125, 002, Replicate("#",125) , oFont14,,CLR_GRAY)
	nTamLin := nTamLin + 5
Next
//**************************************************************************************
// Finaliza o relatório
//**************************************************************************************
oPrint:EndPage()
oPrint:Preview()
FreeObj(oPrint)

Return



