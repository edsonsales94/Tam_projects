#include "Protheus.ch"

#include "TBICONN.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 02
#define TAM_LINE  80
#Define DIM_BORD  08
#Define ITEM_PAGE 30

/*
*/

User Function AAESTR01(aParam)
  Local oPrint := Nil
  Local aCab   := {}
  Local lAuto  := .F.
  Local cPerg  := Padr("AAESTR01",Len(SX1->X1_GRUPO))
  
  Default aParam := {}
  
  lAuto := !Empty(aParam) .And. Len(aParam) = 06
  setPerg(cPerg)
  
  //oPrint 	:= FWMSPrinter():New("DANFE", IMP_SPOOL)
  oPrint 	:= TMSPrinter():New("DANFE")
  
  oPrint:SetPortrait()
  oPrint:Setup()
  
  If lAuto
     Pergunte(cPerg,.F.)
     
     For nI := 1 To Len(aParam)
        If Type( "MV_PAR0"+Alltrim(STR(nI)) ) != ValType( aParam[nI] )
           Pergunte(cPerg,.T.)
           nI := Len(aParam) + 1
        EndIf
     Next
     
  else
     If !Pergunte(cPerg,.T.)
       Return
     EndIf
  EndIf
  
  aDados := {  {{},{},{}}  }
  
  aAdd(aDados[01][01],{'0001','00002','00003'})
  
  aAdd(aDados[01][02],{"Bitola","Numero","","Largura","Peso" ,"Nro. Barra"})
  aAdd(aDados[01][02],{"Tubo"  ,"Tiras" ,"","Total"  ,"Total","Com 6M"    })
  
  aAdd(aDados[01][02],{"PERFIL C 100 X 40 X 15" , "5" , "193.0" , "965" , "28.711" , "1.600"})
  aAdd(aDados[01][02],{"PERFIL U 75 X 38 " , "1" , "142.0"  , "142" , "28.711" , "1.600"})
  aAdd(aDados[01][02],{"                 " , " " , "TOTAL" , "142" , "28.711" , ""})
  
  
  aAdd(aDados[01][03],{"Sobra da bobina  " , "Largura " , "11.00" , "Peso"    , "327.273" })
  aAdd(aDados[01][03],{"                 " , "        " , "     " , "%refilo" , "0.91" }  )
  
  ImpInf( getInf() , oPrint)
  
  oPrint:Preview()
  
RETURN

Static Function ImpInf(aDados,oPrint)
  Local aSize  := {}
  Local nLine  := 060
  Local nCol   := 040
  

  aFontes := SetFonts(oPrint)
  aSize := {oPrint:nHorzRes() * 300/ oPrint:nLogPixelX() , oPrint:nVertRes() * 300/ oPrint:nLogPixelY() }  
  
  
  For nAtual := 1 To Len (aDados)
	  nLine    += 10
	  nCol     += 10
	  
	  nLineBak := nLine
	  nColBak  := nCol
	  
	  oPrint:StartPage() // Inicia uma Nova Pagina de IMperssao
	  //DrawBox(oPrint ,{nLine, nCol, aSize[02], aSize[01]  } , TBrush():New( , CLR_WHITE ) , DIM_BORD) //Desenha o Box Externo
	  
	  nLine += 30
	  //oPrint:Say(nLine + 007                ,nCol + 030,"PLANILHA DE CÁLCULO TIRA SLITTADA", aFontes[13]:oFont )
	  nLine += (aFontes[13]:GetTextWidht("X") *(300/oPrint:nLogPixelX()) * 2)
	  
	  nLine += 30
	  nCol += 30
	  nTamLine := (aFontes[12]:GetTextWidht("X") *(300/oPrint:nLogPixelX()) * 2) - 2
	  DrawBox(oPrint ,{nLine, nCol, nLine + nTamLine * 5, aSize[01] - 100 } , TBrush():New( , CLR_WHITE ) , DIM_BORD)
	  
	  //Desenha o Box Cinza do Cabecalho
	  DrawBox(oPrint ,{nLine, nCol, nLine + nTamLine * 3, aSize[01] / 2 - 100 } , TBrush():New( , CLR_GRAY ) , DIM_BORD)
	  
	  // Imprime as Descrições
	  oPrint:Say(nLine + 007                ,nCol + 030,"Largura da Bobina", aFontes[12]:oFont )
	  oPrint:Say(nLine + 007 + nTamLine     ,nCol + 030,"Espessura"        , aFontes[12]:oFont )
	  oPrint:Say(nLine + 007 + nTamLine * 2 ,nCol + 030,"Peso Total"       , aFontes[12]:oFont )
	  	  
	  //Desenha o Box Branco do Cabecalho
	  DrawBox(oPrint ,{nLine, aSize[01] / 2 - 300, nLine + nTamLine * 3, aSize[01] / 2 } , TBrush():New( , CLR_WHITE ) , DIM_BORD)
	  
	  //Desenha as linhas que esta no Cabecalho
	  DrawBox(oPrint ,{nLine + nTamLine, nCol, nLine + nTamLine , aSize[01] / 2 } , TBrush():New( , CLR_BLACK ),3 )
	  DrawBox(oPrint ,{nLine + nTamLine * 2, nCol, nLine + nTamLine * 2 , aSize[01] / 2 } , TBrush():New( , CLR_BLACK ),3 )
	  
//	  DrawBox(oPrint ,{nLine + TAM_LINE, aSize[01] / 2 - 300, nLine + TAM_LINE , aSize[01] / 2 } , TBrush():New( , CLR_BLACK ),2 )
//	  DrawBox(oPrint ,{nLine + TAM_LINE * 2, aSize[01] / 2 - 300, nLine + TAM_LINE * 2 , aSize[01] / 2} , TBrush():New( , CLR_BLACK ),2 )
	 
	  // Imprime as Informacoes Relativas as Descrições 
	  oPrint:Say(nLine + 007                , aSize[01] / 2 - 350 , aDados[nAtual][01][01], aFontes[14]:oFont )
	  oPrint:Say(nLine + 007 + nTamLine     , aSize[01] / 2 - 350 , aDados[nAtual][01][02], aFontes[14]:oFont )
	  oPrint:Say(nLine + 007 + nTamLine * 2 , aSize[01] / 2 - 350 , aDados[nAtual][01][03], aFontes[14]:oFont )
	  
	  cDate := Alltrim(Str(Day(dDataBase))) +'-'+ SubStr(cMonth(dDataBase),1,3)
	  
	  oPrint:Say(nLine + 007                , aSize[01] / 2  + 010, "mm"            , aFontes[12]:oFont )
	  oPrint:Say(nLine + 007                , aSize[01] / 2  + 600, "DATA: " + cDate, aFontes[10]:oFont )
	  oPrint:Say(nLine + 007 + nTamLine     , aSize[01] / 2  + 010, "mm"            , aFontes[12]:oFont )
	  oPrint:Say(nLine + 007 + nTamLine * 2 , aSize[01] / 2  + 010, "ton"           , aFontes[12]:oFont )
	  
	  nLine += nTamLine * 4	  
  	  nTamLine := (aFontes[10]:GetTextWidht("X") *(300/oPrint:nLogPixelX()) * 2) - 2
  	  
	  DrawBox(oPrint ,{nLine           , nCol, nLine + nTamLine * 2, aSize[01] - 100 } , TBrush():New( , CLR_GRAY ) , DIM_BORD)
	  
	  For nJ2 := 1 To Len(aDados[nAtual][02])
	      
	      if nJ2 <= 2
	         IF nJ2 = 1
	            DrawBox(oPrint ,{nLine           , nCol, nLine + nTamLine * 2, aSize[01] - 100 } , TBrush():New( , CLR_GRAY ) , DIM_BORD)	      
	         EndIf
	         aFont := {10,10,10,10,10,10}
	      elseif nJ2 != Len(aDados[nAtual][02])
	          nLine += 20
	          DrawBox(oPrint ,{nLine           , nCol, nLine + nTamLine , aSize[01] - 100 } , TBrush():New( , CLR_WHITE ) , DIM_BORD)	          
	          aFont := {03,08,08,08,08,08}
	      else
	          nLine += 20
	          DrawBox(oPrint ,{nLine           , nCol, nLine + nTamLine , aSize[01] - 100 } , TBrush():New( , CLR_WHITE ) , DIM_BORD)
	          aFont := {08,08,06,08,08,08}
	      EndIF
	      
	      DrawBox(oPrint ,{nLine , nCol + 0500, nLine + nTamLine    , nCol + 0500} , TBrush():New( , CLR_BLACK ), 2 )
	      DrawBox(oPrint ,{nLine , nCol + 0800, nLine + nTamLine    , nCol + 0800} , TBrush():New( , CLR_BLACK ), 2 )
	      DrawBox(oPrint ,{nLine , nCol + 1200, nLine + nTamLine    , nCol + 1200} , TBrush():New( , CLR_BLACK ), 2 )
	      DrawBox(oPrint ,{nLine , nCol + 1500, nLine + nTamLine    , nCol + 1500} , TBrush():New( , CLR_BLACK ), 2 )
	      DrawBox(oPrint ,{nLine , nCol + 1800, nLine + nTamLine    , nCol + 1800} , TBrush():New( , CLR_BLACK ), 2 )
	      
        oPrint:Say(nLine + 007 , nCol + 0010, aDados[nAtual][02][nJ2][01], aFontes[aFont[01]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 0510, aDados[nAtual][02][nJ2][02], aFontes[aFont[02]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 0810, aDados[nAtual][02][nJ2][03], aFontes[aFont[03]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 1210, aDados[nAtual][02][nJ2][04], aFontes[aFont[04]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 1510, aDados[nAtual][02][nJ2][05], aFontes[aFont[05]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 1810, aDados[nAtual][02][nJ2][06], aFontes[aFont[06]]:oFont )
	 	  
	 	  nLine += nTamLine
	  Next	  
	  nLine += DIM_BORD * 4
	  DrawBox(oPrint ,{nLine           , nCol, nLine + nTamLine * 2, aSize[01] - 100 } , TBrush():New( , CLR_WHITE ) , DIM_BORD)
	  
	  //nLine += nTamLine
	  DrawBox(oPrint ,{nLine , nCol       , nLine + nTamLine * 2, nCol + 0500} , TBrush():New( , CLR_YELLOW), DIM_BORD)
	  DrawBox(oPrint ,{nLine , nCol + 0500, nLine + nTamLine * 2, nCol + 1800} , TBrush():New( , CLR_WHITE), DIM_BORD)
	  
	  DrawBox(oPrint ,{nLine , nCol + 0800, nLine + nTamLine * 2, nCol + 0800} , TBrush():New( , CLR_BLACK ), DIM_BORD / 2)
	  DrawBox(oPrint ,{nLine , nCol + 1200, nLine + nTamLine * 2, nCol + 1200} , TBrush():New( , CLR_BLACK ), DIM_BORD / 2)
	  DrawBox(oPrint ,{nLine , nCol + 1500, nLine + nTamLine * 2, nCol + 1500} , TBrush():New( , CLR_BLACK ), DIM_BORD / 2)
	  DrawBox(oPrint ,{nLine , nCol + 1800, nLine + nTamLine * 2, nCol + 1800} , TBrush():New( , CLR_BLACK ), DIM_BORD / 2)
	  
	  DrawBox(oPrint ,{nLine + nTamLine, nCol + 1200, nLine + nTamLine    , nCol + 1800} , TBrush():New( , CLR_BLACK ), 4 )
	  
	  aFont:={06,06,07,06,06}
	  For nJ2 := 1 To Len(aDados[nAtual][03])
	      
	      oPrint:Say(nLine + 007 , nCol + 0010, aDados[nAtual][03][nJ2][01], aFontes[aFont[01]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 0510, aDados[nAtual][03][nJ2][02], aFontes[aFont[02]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 0810, aDados[nAtual][03][nJ2][03], aFontes[aFont[03]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 1210, aDados[nAtual][03][nJ2][04], aFontes[aFont[04]]:oFont )
	 	  oPrint:Say(nLine + 007 , nCol + 1510, aDados[nAtual][03][nJ2][05], aFontes[aFont[05]]:oFont )
	 	  nLine += nTamLine
	  Next
	  
    //oPrint:Say(nLine + 007 , nCol + 1210, aDados[nAtual][04][nJ2][04], aFontes[aFont[04]]:oFont )
    
	  DrawBox(oPrint ,{nLineBak, nColBak, nLine + nTamLine , aSize[01] - 30  } , , DIM_BORD," PLANILHA DE CÁLCULO TIRA SLITTADA ") //Desenha o Box Externo
	  
	  oPrint:EndPage()
  Next
  
Return nLine
 
Static Function DrawBox(oPrint,aDim,oBrush,nLarg,cText)
  
  If oBrush != Nil
     oPrint:FillRect( { aDim[01] + nLarg, aDim[02] + nLarg, aDim[03] - nLarg, aDim[04] - nLarg }, oBrush )
  EndIf
  
  oPrint:FillRect( { aDim[01], aDim[02], aDim[01] + nLarg, aDim[04] }, TBrush():New( , CLR_BLACK) )
  
  oPrint:FillRect( { aDim[01], aDim[02], aDim[03], aDim[02] + nLarg }, TBrush():New( , CLR_BLACK) )
  
  oPrint:FillRect( { aDim[03], aDim[02], aDim[03] - nLarg, aDim[04] }, TBrush():New( , CLR_BLACK) )
  
  oPrint:FillRect( { aDim[01], aDim[04], aDim[03], aDim[04] - nLarg }, TBrush():New( , CLR_BLACK) )
  
  If !Empty(cText)
  
     nTam := ( aFontes[13]:GetTextWidht("X") * (300/oPrint:nLogPixelY()) * Len(cText) ) -  200
     oPrint:FillRect( { aDim[01] - 20, aDim[02] + 25, aDim[01] + 20, aDim[02] + nTam }, TBrush():New( , CLR_WHITE) )
     oPrint:Say(aDim[01] - 25, aDim[02] + 030,cText, aFontes[13]:oFont )
     
  EndIf
 
Return Nil


Static Function DrawLine(oPrint,aDim,oBrush)
  
  Default oBrush := TBrush():New( , CLR_BLACK)
  
  oPrint:FillRect( {aDim[01], aDim[02], aDim} )  

Return nLin

Static Function SetFonts(oPrint)
   
   Local aFontes := {}
   
   aAdd(aFontes, TFontEx():New(oPrint,"Times New Roman",09,09,.T.,.T.,.F.) )// 1
   aAdd(aFontes, TFontEx():New(oPrint,"Times New Roman",06,06,.T.,.T.,.F.) )// 2
   aAdd(aFontes, TFontEx():New(oPrint,"Arial"          ,08,08,.F.,.T.,.F.) )// 3
   aAdd(aFontes, TFontEx():New(oPrint,"Times New Roman",07,07,.F.,.T.,.F.) )// 4
   aAdd(aFontes, TFontEx():New(oPrint,"Arial"          ,11,11,.F.,.T.,.F.,.F.,.F.,.F.,.T.) )// 5
   aAdd(aFontes, TFontEx():New(oPrint,"Arial"          ,10,10,.T.,.T.,.F.,.F.,.F.,.F.,.T.) )// 6
   aAdd(aFontes, TFontEx():New(oPrint,"Arial "         ,10,10,.F.,.T.,.F.) )// 7
   aAdd(aFontes, TFontEx():New(oPrint,"Courrier New"   ,12,12,.F.,.T.,.F.,.F.,.F.,.F.,.T.) )// 8
   aAdd(aFontes, TFontEx():New(oPrint,"Arial "         ,12,12,.F.,.T.,.F.) )// 9
   aAdd(aFontes, TFontEx():New(oPrint,"Arial "         ,14,14,.T.,.T.,.F.) )// 10
   aAdd(aFontes, TFontEx():New(oPrint,"Times New Roman",10,10,.T.,.T.,.F.) )// 11
   aAdd(aFontes, TFontEx():New(oPrint,"Arial "         ,17,17,.T.,.T.,.F.) )// 12 
   aAdd(aFontes, TFontEx():New(oPrint,"Times New Roman",16,16,.T.,.T.,.F.,.F.,.F.,.F.,.T.) )// 13 
   aAdd(aFontes, TFontEx():New(oPrint,"Courrier New"   ,16,16,.T.,.T.,.F.,.F.,.F.,.F.,.T.) )// 14


Return aFontes
Static Function setPerg(cPerg)
   
   PutSx1(cPerg, "01","Tira de?"     ,"¿De Tira?"	,"From Tira ?"	,"mv_ch1","C" , TamSx3('Z0_NUM')[01] ,TAmSx3('Z0_NUM')[02] ,0,"G","","SZ0","","","mv_par01")
   PutSx1(cPerg, "02","Tira Até ?"   ,"¿A Tira?"	,"To Tira ?"	,"mv_ch2","C" , TamSx3('Z0_NUM')[01] ,TAmSx3('Z0_NUM')[02] ,0,"G","","SZ0","","","mv_par02")
   PutSx1(cPerg, "03","Data de?"     ,"¿De Data?"	,"From Date ?"	,"mv_ch3","D" , TamSx3('Z0_DATA')[01],TAmSx3('Z0_DATA')[02],0,"G","","   ","","","mv_par03")
   PutSx1(cPerg, "04","Data Até ?"   ,"¿A Data?"	,"To Date ?"	,"mv_ch4","D" , TamSx3('Z0_DATA')[01],TAmSx3('Z0_DATA')[02],0,"G","","   ","","","mv_par04")
   PutSx1(cPerg, "05","Bobina de?"   ,"¿De Bobina?" ,"From Bobina ?","mv_ch5","C" , TamSx3('Z0_COD')[01] ,TAmSx3('Z0_COD')[02] ,0,"G","","SB1","","","mv_par05")
   PutSx1(cPerg, "06","Bobina Até ?" ,"¿A Bobina?"  ,"To Bobina ?"	,"mv_ch6","C" , TamSx3('Z0_COD')[01] ,TAmSx3('Z0_COD')[02] ,0,"G","","SB1","","","mv_par06")
   
Return Nil

Static Function getInf()
    Local cFile  := '\System\AAESTR01.ini'
    Local cQry   := ""
    Local cTable := GetNextAlias()
    
    cQry :=                     " Select * From  + RetSqlName('SZ0') + SZ0 "
    cQry += Chr(13) + Chr(10) + " Left Outer Join (Select * From + RetSqlName('SZ1') Where D_E_L_E_T_ = '') SZ1 on Z1_NUM = Z0_NUM And Z0_FILIAL = Z1_FILIAL"
    cQry += Chr(13) + Chr(10) + " Where SZ0.D_E_L_E_T_ = '' "
    cQry += Chr(13) + Chr(10) + " And Z0_NUM BetWeen  'mv_par01' And 'mv_par02'
    cQry += Chr(13) + Chr(10) + " And Z0_DATA BetWeen 'mv_par03' And 'mv_par04'
    cQry += Chr(13) + Chr(10) + " And Z0_COD BetWeen  'mv_par05' And 'mv_par06'
    cQry += Chr(13) + Chr(10) + " And Z1_COD is Null
   
    if File(cFile)
       FT_FUSE(cFile)
       FT_FGOTOP()
       cQry := ""
       While !FT_FEOF()
          cBuffer := AllTrim(FT_FREADLN())
          cQry += cBuffer + CHr(13) + Chr(10)
          FT_FSKIP()
       EndDo
       FT_FUSE()
    else    
      nHdl := FCREATE(cFile)
      FWrite ( nHdl, cQry , Len(cQry) )
      FT_FUSE()
    EndIF
    
    cQry := StrTran(cQry,"mv_par01",mv_par01)
    cQry := StrTran(cQry,"mv_par02",mv_par02)
    cQry := StrTran(cQry,"mv_par03",DTOS(mv_par03))
    cQry := StrTran(cQry,"mv_par04",DTOS(mv_par04))
    cQry := StrTran(cQry,"mv_par05",mv_par05)
    cQry := StrTran(cQry,"mv_par06",mv_par06)
    
    While ("RetSqlName" $ cQry)
      nPos := At("RetSqlName",cQry)
      cTbl := SubStr(cQry,nPos,14 + Len(SX2->X2_CHAVE) )
      cQry := StrTran(cQry,cTbl,&cTbl)
      cQry := StrTran(cQry,"+","")
    EndDo
    
    //aviso('as',cQry,{'OK'},3)
    
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),cTable,.F.,.T.)
    
    aDados := {}
    aGeral := {}
    While !(cTable)->(Eof())
      aCabec := {}
      aAdd(aCabec,Transform( (cTable)->Z0_LARG,"@E 999,999,999.99"))
      aAdd(aCabec,Transform( (cTable)->Z0_ESPESS,"@E 999,999,999.99"))
      aAdd(aCabec,Transform( (cTable)->Z0_PESO,"@E 999,999,999.99"))
      
      aTotal   := {"","","TOTAL","","",""}
      
      cChave := (cTable)->(Z0_FILIAL+Z0_NUM+Z0_DATA)
      nPesoT := 0
      nLargT := 0
      nItem := 1
      adet := {}
      aDados := {}
      aAdd(aDet,{"Bitola","Numero","","Largura","Peso" ,"Nro. Barra"})
      aAdd(aDet,{"Tubo"  ,"Tiras" ,"","Total"  ,"Total","Com 6M"    })
      
      While cChave == (cTable)->(Z0_FILIAL+Z0_NUM+Z0_DATA) .And. !(cTable)->(Eof())
      
          SB1->(dbSetORder(1))
          if SB1->(dbSeek(xFIlial('SB1')+(cTable)->Z1_CODSLIT))
             cBitola := SB1->B1_DESC
          else
             cBitola := (cTable)->Z1_CODSLIT
          EndIf
          aInf := {}
          aAdd(aInf,SubSTr( cBitola,1,28 ) )
          aAdd(aInf,TransForm( (cTable)->Z1_QUANT ,"@E 999,999,999.99") ) 
          aAdd(aInf,Transform( (cTable)->Z1_LARG  ,"@E 999,999,999.99") ) 
          aAdd(aInf,Transform( (cTable)->Z1_TLARG ,"@E 999,999,999.99") ) 
          aAdd(aInf,Transform( (cTable)->Z1_TPESO ,"@E 999,999,999.99") ) 
          aAdd(aInf,Transform( (cTable)->Z1_NROBAR,"@R 999,999,999.99") ) 
          
          nPesoT += (cTable)->Z1_TPESO
          nLargT += (cTable)->Z1_TLARG
          
          aAdd( aDet , aClone(aInf) )
          
         (cTable)->(dbSkip())
         
      EndDo
      
         aTotal[04] := Transform(nPesoT,"@E 999,999,999.99")
         aTotal[05] := Transform(nLargT,"@E 999,999,999.99")
         
         aAdd(aDet, aClone(aTotal) )
         cLarg := Transform( (cTable)->Z0_LARG - nLargT,"@E 999,999,999.99" )
         cPeso := Transform( (cTable)->Z0_PESO - nPesoT,"@E 999,999,999.999")
         
         if nPesoT != 0
            cPerc := Transform( (cTable)->Z0_PESO - nPesoT / nPesoT * 100,"@E 999,999,999.99")
         else
            cPerc := '0.00'
         EndIf
         
         aRodape := {}
         aAdd(aRodape,{"Sobra da bobina","Largura",cLarg,"Peso",cPeso})
         aAdd(aRodape,{"               ","       ","   ","% refilo",cPerc})
         
         aAdd(aDados,aCLone(aCabec) )
         aAdd(aDados,aCLone(aDet) )
         aAdd(aDados,aCLone(aRodape) )
         aAdd(aGeral,aClone(aDados)) 
    EndDo
    
Return aGeral




/*powered by DXRCOVRB*/