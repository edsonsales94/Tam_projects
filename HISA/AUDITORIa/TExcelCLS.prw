#INCLUDE "protheus.ch" 
#INCLUDE "ap5mail.ch"
#INCLUDE "fileio.ch"
#INCLUDE "ExcelCLS.ch"

#DEFINE NEW_LINE Chr(13)+Chr(10)
#DEFINE COL_WIDTH_DEFAULT 48

#DEFINE EXCEL_PROP_SUBJECT "Relatórios Gerenciais"
#DEFINE EXCEL_PROP_COMPANY "Unicoba"
#DEFINE EXCEL_PROP_AUTHOR  "ERP - Protheus 8"

//User Function TExcelCLS
//Return TExcelCLS():New()  

User Function XLSFmtDef(cTipo,nDecimais)
	Local cRet := "@"
	 
	Do Case 
		Case cTipo=="N"         
			cRet :="_(* #,##0"+IIF(nDecimais>0,"."+Replicate("0",nDecimais),"")+;
				   "_);[Red]_(* \(#,##0"+IIF(nDecimais>0,"."+Replicate("0",nDecimais),"")+;
				   '\);_(* "-"??_);_(@_)'
		Case cTipo=="P"                                               
			cRet := "_(* 0"+IIf(nDecimais > 0,"."+Replicate("0",nDecimais),"")+"%_)"+;
					";[Red]_(* (0"+IIf(nDecimais > 0,"."+Replicate("0",nDecimais),"")+'%);_(* "-"??_)'
		Case cTipo=="D"                 
			cRet := "dd/mm/yy"
		OtherWise //cTipo=="L"
			cRet := ""
	End Case
Return cRet  

User Function XLSCStyle(oXLSCol,nStyle)
	Local oStyle
	
	Default nStyle := 0
	
	Do Case
		Case nStyle == 0
			oStyle := oXLSCol:oStyleCol
		Case nStyle == -1
			oStyle := oXLSCol:oStyleHdr
		Case nStyle == -2
			oStyle := oXLSCol:oStyleCol
		Case nStyle == -3
			oStyle := oXLSCol:oStyleTot
	    Otherwise
			oStyle := oXLSCol:aStyles[nStyle]
	End Case
	
Return oStyle

Static Function DescTipo(cTipo)
	Local cRet

	cTipo := Upper(AllTrim(cTipo))

	Do Case
		Case cTipo=="C"
			cRet := "String"
		Case cTipo=="D"
			cRet := "DateTime"
		Case cTipo=="N"
			cRet := "Number"
		Case cTipo=="P"
			cRet := "Number"
		Case cTipo=="L"			
			cRet := "Boolean"
		Otherwise
			cRet := "String"
	EndCase

return cRet

Static Function NameWrkSht(cHeader)
	Local cRet := ""
	Local cCh
	Local nCt
	
	For nCt:=1 To Len(cHeader)
		cCh := SubStr(cHeader,nCt,1)
		
		If !(cCh $ "'/?*[]")
			cRet += cCh
		EndIf
	Next
	
return cRet

Static Function DescCond(nCond)
	Local cRet := ""
	         
	Do Case
		Case nCond == XLS_CONDITION_BETWEEN
			cRet := "Between"
		Case nCond == XLS_CONDITION_NOTBETWEEN
			cRet := "NotBetween"		
		Case nCond == XLS_CONDITION_EQUAL
			cRet := "Equal"		
		Case nCond == XLS_CONDITION_NOTEQUAL
			cRet := "NotEqual"	
		Case nCond == XLS_CONDITION_GREATER
			cRet := "Greater"		
		Case nCond == XLS_CONDITION_LESS
			cRet := "Less"		
		Case nCond == XLS_CONDITION_GREATER_OR_EQUAL
			cRet := "GreaterOrEqual"		
		Case nCond == XLS_CONDITION_LESS_OR_EQUAL
			cRet := "LessOrEqual"		
	EndCase
	
return cRet

Static Function FormCond(oFormCond)
	Local cRet := ""
	Local nCt
	
	cRet += '  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">'+NEW_LINE
	cRet += '   <Range>'+AllTrim(oFormCond:cRange)+'</Range>'+NEW_LINE
	
	For nCt:=1 To oFormCond:GetCount()
		cRet += '   <Condition>'+NEW_LINE
		Do Case
			Case ValType(oFormCond:GetCond(nCt):xCondition)=="C"
				cRet += '    <Value1>'+U_OemToUTF8(AllTrim(oFormCond:GetCond(nCt):xCondition))+'</Value1>'+NEW_LINE
			Case ValType(oFormCond:GetCond(nCt):xCondition)=="N"
				cRet += '    <Qualifier>'+DescCond(oFormCond:GetCond(nCt):xCondition)+'</Qualifier>'+NEW_LINE
				cRet += '    <Value1>'+U_XLSValue(oFormCond:GetCond(nCt):xVal1)+'</Value1>'+NEW_LINE
				If oFormCond:GetCond(nCt):xCondition == XLS_CONDITION_BETWEEN .Or.;
				   oFormCond:GetCond(nCt):xCondition == XLS_CONDITION_NOTBETWEEN

					cRet += '    <Value2>'+U_XLSValue(oFormCond:GetCond(nCt):xVal2)+'</Value2>'+NEW_LINE
				EndIf 
		EndCase

		cRet += "    <Format Style='"+oFormCond:GetCond(nCt):cFormat+"'/>"+NEW_LINE
		cRet += '   </Condition>'+NEW_LINE
	Next

	cRet += '  </ConditionalFormatting>'+NEW_LINE
return cRet

Static Function DescAlignH(nAlign)
	Local cRet := ""
	
	Do Case
		Case nAlign==XLS_ALIGNH_LEFT
			cRet := "Left"
		Case nAlign==XLS_ALIGNH_CENTER
			cRet := "Center"
		Case nAlign==XLS_ALIGNH_RIGHT
			cRet := "Right"
		Case nAlign==XLS_ALIGNH_FILL
			cRet := "Fill"
		Case nAlign==XLS_ALIGNH_JUSTIFY
			cRet := "Justify"
		Case nAlign==XLS_ALIGNH_CENTERSEL
			cRet := "CenterAcrossSelection"
	End Case		
	
	If !Empty(cRet)
		cRet := ' ss:Horizontal="'+cRet+'"'
	EndIf
Return cRet

Static Function DescAlignV(nAlign)
	Local cRet := ""
	
	Do Case
		Case nAlign==XLS_ALIGNV_TOP
			cRet := "Top"
		Case nAlign==XLS_ALIGNV_CENTER
			cRet := "Center"
		Case nAlign==XLS_ALIGNV_BOTTOM
			cRet := "Bottom"
		Case nAlign==XLS_ALIGNV_JUSTFY
			cRet := "Justify"
		Case nAlign==XLS_ALIGNV_DISTRIB
			cRet := "Distributed"
	End Case		
	
	If !Empty(cRet)
		cRet := ' ss:Vertical="'+cRet+'"'
	EndIf
Return cRet               

Static Function StyleAlign(nAlignH,nAlignV,lWrapText)
	Local cRet
	
	cRet := DescAlignH(nAlignH)+DescAlignV(nAlignV)
	
	If lWrapText
		cRet += ' ss:WrapText="1"'
	EndIf
	
	If !Empty(cRet)
		cRet:='   <Alignment'+cRet+'/>'+NEW_LINE
	EndIf
Return cRet	

Static Function LineStyle(nStyle)
	Local cRet := "Continuous"
	
	Do Case
		Case nStyle == XLS_LINE_CONTINUOUS
			cRet := "Continuous"
		Case nStyle == XLS_LINE_DOT
			cRet := "Dot"
		Case nStyle == XLS_LINE_DASHDOTDOT
			cRet := "DashDotDot"
		Case nStyle == XLS_LINE_DASHDOT
			cRet := "DashDot"
		Case nStyle == XLS_LINE_DASH
			cRet := "Dash"
		Case nStyle == XLS_LINE_DOUBLE
			cRet := "Double"
	End Case
	
Return cRet

Static Function LineBorder(nTipo,nStyle,nWeight)
	Local cRet := ""
	
	Do Case 
		Case nTipo==XLS_BORDER_LEFT      
			cRet := "Left"
		Case nTipo==XLS_BORDER_RIGHT
			cRet := "Right"
		Case nTipo==XLS_BORDER_TOP
			cRet := "Top"
		Case nTipo==XLS_BORDER_BOTTOM
			cRet := "Bottom"
	End Case
	
	If !Empty(cRet)
	    cRet := '    <Border ss:Position="'+cRet+'" ss:LineStyle="'+LineStyle(nStyle)+'" ss:Weight="'+AllTrim(Str(nWeight))+'"/>'+NEW_LINE
	EndIf
Return cRet        

Static Function StyleBorder(oXLSStyle)
	Local cRet := ""
	Local nCt
	Local oXLSLine
	
	For nCt=1 to 4
		oXLSLine := oXLSStyle:GetBorder(nCt)

		If oXLSLine:lVisible
			cRet += LineBorder(oXLSLine:nTipo,oXLSLine:nStyle,oXLSLine:nWeight)
		EndIf
	Next
	
	If !Empty(cRet)
		cRet := '   <Borders>'+NEW_LINE+cRet+'   </Borders>'+NEW_LINE
	EndIf

Return cRet

Static Function FontAlignV(nAlignV)
	Local cRet := ""
	
	Do Case
		Case nAlignV==XLS_FONTALIGNV_SUBSCRIPT
			cRet := 'Subscript'
		Case nAlignV==XLS_FONTALIGNV_SUPERSCRIPT
			cRet := 'Superscript'
	End Case                     
	
	If !Empty(cRet)
		cRet := ' ss:VerticalAlign="'+cRet+'"'
	EndIf

Return cRet

Static Function StyleFont(oXLSFont)
	Local cRet := ""         

	cRet :=' x:FontName="'+oXLSFont:cFontName+'"'
	If !Empty(oXLSFont:xColor)
		Do Case
			Case ValType(oXLSFont:xColor)=="C"
				cRet +=' ss:Color="'+oXLSFont:xColor+'"'
			Case ValType(oXLSFont:xColor)=="N"
				cRet +=' ss:Color="'+AllTrim(Str(oXLSFont:xColor))+'"'
		EndCase
	EndIf
	If oXLSFont:nSize > 0
		cRet +=' ss:Size="'+AllTrim(Str(oXLSFont:nSize))+'"'	
	EndIf
	If oXLSFont:nHeight > 0
		cRet +=' ss:Height="'+AllTrim(Str(oXLSFont:nHeight))+'"'	
	EndIf                 
	If BitAtivo(oXLSFont:nAttrib,XLS_FONT_BOLD-1)
		cRet += ' ss:Bold="1"'
	EndIf
	If BitAtivo(oXLSFont:nAttrib,XLS_FONT_ITALIC-1)
		cRet += ' ss:Italic="1"'
	EndIf                       
	If BitAtivo(oXLSFont:nAttrib,XLS_FONT_UNDERLINE-1)
		cRet += ' ss:Underline="Single"'
	EndIf
	If BitAtivo(oXLSFont:nAttrib,XLS_FONT_STRIKEOUT-1)
		cRet += ' ss:StrikeThrough="1"'
	EndIf
	cRet += FontAlignV(oXLSFont:nAlignV)
	
	If !Empty(cRet)
		cRet := '   <Font'+cRet+'/>'+NEW_LINE
	Endif
Return cRet

Static Function StyleColor(xColor)	
	Local cRet := ""
	
	If !Empty(xColor)
		Do Case
			Case ValType(xColor)=="C"
				cRet :=AllTrim(xColor)
			Case ValType(xColor)=="N"
				cRet :=AllTrim(Str(xColor))
		EndCase
		
		If !Empty(cRet)
			cRet := '   <Interior ss:Color="'+cRet+'" ss:Pattern="Solid"/>'+NEW_LINE
		EndIf
	EndIf
Return cRet

Static Function	StyleFmt(cFormat)	
	Local cRet := ""
	
	If !Empty(cFormat)
		cRet := '   <NumberFormat ss:Format="'+U_OemToUTF8(cFormat)+'"/>'+NEW_LINE
	EndIf

Return cRet

Static Function StyleProt(lHidden,lLocked)
	Local cRet := ""
	
	If lHidden                      
	   cRet +=' x:HideFormula="1"'
	EndIf
	
	If !lLocked
		cRet += ' ss:Protected="0"'
	EndIf
	
	If !Empty(cRet)
		cRet := '   <Protection'+cRet+'/>'+NEW_LINE
	EndIf

Return cRet

Static Function ColCBlock(oXLSCol,lBlank)
	Local cBlock
	Local cFormula
	
	Default lBlank := .F.       
	
	cFormula := AllTrim(oXLSCol:cFormula)
	
/*
	If !Empty(cFormula)
		lBlank := .F.	
	EndIf
*/
	
	cBlock := "oStyle:=U_XLSCStyle(oXLSCol,nStyle),"
	cBlock += "'"+'     <Cell ss:StyleID="'+"'+oStyle:GetCodInt()+'"+'"'
	
	If !Empty(cFormula)     
		If Upper(cFormula) $ "SUM|"
			cFormula += '(RC[-'+AllTrim(Str(oXLSCol:GetIndex()-1))+']:RC[-1])'
		EndIf
		If Left(cFormula,1)<>"="
			cFormula := "="+cFormula
		EndIf                 
		cFormula := Replace(cFormula,"'","'+Chr(39)+'")
		If lBlank
			cBlock += "'+IIF(lFormula,'"
		EndIf
		cBlock += ' ss:Formula="'+cFormula+'"'                   

		If lBlank
			cBlock += "','/')+"+"'"
		EndIf
	ElseIF lBlank
		cBlock += '/'
	Endif     
	
	cBlock += '>'

	If !lBlank .Or. !Empty(cFormula)
		If lBlank
			cBlock += "'+IIF(lFormula,'"
		EndIf

		If Empty(oXLSCol:cFormula)
			cBlock += "'+U_XLSRowData(xValor,oStyle:lTrimSpc)+'" // "+IIF(oXLSCol:oStyleCol:lTrimSpc,',.T.','')+"
		Else
			cBlock += '<Data ss:Type="'+DescTipo(oXLSCol:cTipo)+'"></Data>'
		Endif

		cBlock += "'+IIF(Empty(oComment),'',oComment:RetComment())+'"

/*			
			Do Case
				Case oXLSCol:cTipo=="C"
					cBlock += 'U_OemToUTF8(xValor'+IIF(oXLSCol:oStyleCol:lTrimSpc,',.T.','')+')'
					cBlock += "+'"
				Case oXLSCol:cTipo=="D"
					cBlock := 'xValor:=DtoS(xValor),'+cBlock
					cBlock += 'Left(xValor,4)+"-"+SubStr(xValor,5,2)+"-"+SubStr(xValor,7,2)'
					cBlock += "+'T00:00:00.000" 
				Case oXLSCol:cTipo=="N"			
					cBlock += 'AllTrim(Str(xValor))
					cBlock += "+'"
				Case oXLSCol:cTipo=="P"			
					cBlock += 'AllTrim(Str(xValor))
					cBlock += "+'"
				Case oXLSCol:cTipo=="L"			
					cBlock += 'IIF(xValor,"1","0")'
					cBlock += "+'"
			End Case
*/
		cBlock +='</Cell>'        
		
		If lBlank
			cBlock += "','')+"+"'"
		EndIf
	EndIf
	
	cBlock += "'+Chr(13)+Chr(10)"

	cBlock := "{ |"+IIF(lBlank,"","xValor,")+"nStyle,oXLSCol,oStyle,oComment"+IIF(lBlank,",lFormula| IIF(lFormula==NIL,lFormula:=.T.,),","|")+cBlock+' }'
	
Return MontaBlock(cBlock)

Static Function ValToCell(nColIndex,xValor,cFormula,oXLSStyle,nColsMerge,nRowsMerge,cTipo,oComment)
	Local cBuffer
	Local cFormula   

	Default nColsMerge	:= 0
	Default nRowsMerge  := 0
	Default cTipo		:= ValType(xValor)
	
	cBuffer := '     <Cell ss:Index="'+AllTrim(Str(nColIndex))+'"'

	If nRowsMerge > 0
		cBuffer += ' ss:MergeDown="'+AllTrim(Str(nRowsMerge))+'"'
	Endif
	If nColsMerge > 0
		cBuffer += ' ss:MergeAcross="'+AllTrim(Str(nColsMerge))+'"'
	Endif

	cBuffer += ' ss:StyleID="'+oXLSStyle:GetCodInt()+'"'
	
	If !Empty(cFormula)	
		cBuffer += ' ss:Formula="'+cFormula+'"'
	EndIf

	cBuffer += '>'
	
	If xValor <> NIL
		cBuffer += '<Data ss:Type="'+DescTipo(cTipo)+'">'+U_OemToUTF8(xValor,oXLSStyle:lTrimSpc)+'</Data>'
	EndIf
	
	If !Empty(oComment)
		cBuffer += oComment:RetComment()
	EndIf
	
	cBuffer += '</Cell>'+NEW_LINE
	
Return cBuffer

Static Function ColTotForm(oXLSCol,nHeaders,cFormula,nStyle,oComment)
	Local cRet                                            
	Local oStyle                                            

	Default nStyle := 0
	
	Do Case
		Case nStyle == 0
			oStyle := oXLSCol:oStyleTot
		Case nStyle == -1
			oStyle := oXLSCol:oStyleHdr
		Case nStyle == -2
			oStyle := oXLSCol:oStyleCol
		Case nStyle == -3
			oStyle := oXLSCol:oStyleTot
	    Otherwise
			oStyle := oXLSCol:aStyles[nStyle]
	End Case
	
	cRet := '     <Cell  ss:Index="'+AllTrim(Str(oXLSCol:GetIndex()))+'" ss:StyleID="'+oStyle:GetCodInt()+'"'
	
	Default cFormula := AllTrim(oXLSCol:cRowFormul)
	
	If !Empty(cFormula)
		If Upper(cFormula) $ "SUM|"
			cFormula += '(R['+AllTrim(Str(nHeaders+1))+']C:R[-1]C)' 
		EndIf
		If Left(cFormula,1)<>"="
			cFormula := "="+cFormula
		EndIf

		cRet += ' ss:Formula="'+cFormula+'"'
		cRet += '><Data ss:Type="'+DescTipo(oXLSCol:cTipo)+'"></Data>'
	Else
		cRet += '>'
	Endif            
	
	If !Empty(oComment)
		cRet += oComment:RetComment()
	EndIf
	
	cRet += '</Cell>'
	
	cRet += NEW_LINE
Return cRet          

Static Function ColTotDados(oXLSCol,xDados,cTipo,nStyle,oComment)
	Local cRet
	Local oStyle                                            

	Default cTipo  := ValType(xDados)	
	Default cTipo  := oXLSCol:cTipo
	Default nStyle := 0
	
	Do Case
		Case nStyle == 0
			oStyle := oXLSCol:oStyleTot
		Case nStyle == -1
			oStyle := oXLSCol:oStyleHdr
		Case nStyle == -2
			oStyle := oXLSCol:oStyleCol
		Case nStyle == -3
			oStyle := oXLSCol:oStyleTot
	    Otherwise
			oStyle := oXLSCol:aStyles[nStyle]
	End Case

	cRet := '     <Cell  ss:Index="'+AllTrim(Str(oXLSCol:GetIndex()))+'" ss:StyleID="'+oStyle:GetCodInt()+'"'
	
	If xDados != NIL
		cRet += '>'+U_XLSRowData(xDados,oStyle:lTrimSpc) //<Data ss:Type="'+DescTipo(cTipo)+'">'+U_XLSValue(xDados)+'</Data>
	Else
		cRet += '>'
	Endif         
	
	If !Empty(oComment)
		cRet += oComment:RetComment()
	EndIf
	
	cRet += '</Cell>'

	cRet += NEW_LINE
Return cRet

Static Function GetStyleSt(oXLSStyle,lComCodigo)
	Local cRet                                                         
	
	Default lComCodigo := .T.
	
	cRet := '  <Style ss:ID="'+IIF(lComCodigo,oXLSStyle:GetCodInt(),'')+'">'+NEW_LINE
	cRet += StyleAlign(oXLSStyle:nAlignH, oXLSStyle:nAlignV, oXLSStyle:lWrapText)
	cRet += StyleBorder(oXLSStyle)
	cRet += StyleFont(oXLSStyle:GetFont())	
	cRet += StyleColor(oXLSStyle:xColor)	
	cRet += StyleFmt(oXLSStyle:cFormat)	
	cRet += StyleProt(oXLSStyle:lHidden,oXLSStyle:lLocked)
	cRet += '  </Style>'+NEW_LINE
return cRet

Static Function BitAtivo(nMask,nBit)
	Local lRet := .F.
	Local nCt
	Local nExp           
	
	nBit++

	If nBit > 0 .And. nBit <= 15 .And. nMask > 0	
		nCt := 1
		Do While nBit <= 15
			nRest:=nMask % 2

			If nCt == nBit 
				lRet  := (nRest > 0)
				Exit
			EndIf   
			nMask := (nMask-nRest)/2
			nCt++
		End Do
    EndIf
Return lRet

Static Function	ConvWidth(nWidth,nTamanho)
	Local nNewWitdh
	
	Default nTamanho := Round((COL_WIDTH_DEFAULT-3.75)/5.25,2)
	Default nWidth	 := COL_WIDTH_DEFAULT

	If nWidth <= 0      
		nNewWitdh := (nTamanho*5.25)+3.75

		nWidth	:= Max(Abs(nWidth),nNewWitdh)
	EndIf
	
Return nWidth

/*================================================================================+
| Classe TXLSFont																  |
+================================================================================*/

class TXLSFont
  LOCAL:
	data cCodigo
	
  PUBLIC:
	data cFontName 
	data xColor
	data nSize     
	data nHeight        
	data nAttrib
	data nAlignV
 	
 	method New(cCodigo,cFontName,nSize,nHeight,nAttrib,nAlignV,xColor) CONSTRUCTOR
 	method GetCodigo()
endclass

method New(cCodigo,cFontName,nSize,nHeight,nAttrib,nAlignV,xColor) class TXLSFont 
	Default cFontName  := "Arial"
	Default nSize      := 0
	Default nHeight    := 0              
	Default nAttrib    := 0
	Default nAlignV	   := 0
	Default xColor	   := ""
	
	::cCodigo    := AllTrim(cCodigo)
	::cFontName  := cFontName
	::nSize   	 := nSize
	::nHeight 	 := nHeight
	::nAttrib 	 := nAttrib 
	::nAlignV	 := nAlignV
	::xColor     := xColor
return Self

method GetCodigo() class TXLSFont 
return ::cCodigo

/*================================================================================+
| Classe TXLSLine																  |
+================================================================================*/

class TXLSLine
  LOCAL:
	data nTipo

  PUBLIC:   
  	data lVisible
	data nStyle
	data nWeight
	
 	method New(nTipo,nStyle,nWeight) CONSTRUCTOR
 	method GetTipo()
endclass

method New(nTipo,lVisible,nWeight,nStyle) class TXLSLine
	Default lVisible := .F.
	Default nWeight  := 1
	Default nStyle   := XLS_LINE_CONTINUOUS

	::nTipo    := nTipo	
	::lVisible := lVisible
	::nWeight  := nWeight
	::nStyle   := nStyle
return Self

method GetTipo() class TXLSLine
return ::nTipo

/*================================================================================+
| Classe TXLSStyle																  |
+================================================================================*/

class TXLSStyle
  LOCAL:
	data cCodigo           
	data cCodInt
  	data aBorder
	data oFont
	data bGetNumSeq 
	data lWrite
	
	method GetCodInt()
	method SetCodInt()

  PUBLIC:
	data cFormat
	data nAlignV
	data nAlignH
	data lHidden
	data lLocked
	data lWrapText
	data xColor
	data lTrimSpc

	method New(cCodigo, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,bGetNumSeq,lTrimSpc) CONSTRUCTOR
	method GetCodigo()
	method GetBorder(nBorder)
	method SetBorders(nMskBorder)
	method GetFont()
endclass

method New(cCodigo, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,bGetNumSeq,lTrimSpc) class TXLSStyle
	Local nBorder         
	Local lVisible
	Local oXLSline
	
	cCodigo := Upper(AllTrim(cCodigo))

	Default cFormat	   := "@"
	Default nAlignV	   := XLS_ALIGNV_BOTTOM
	Default nAlignH	   := XLS_ALIGNH_GENERAL	
	Default lLocked    := .T.
	Default lHidden    := .F.    
	Default lWrapText  := .F.
	Default nMskBorder := 0   
	Default oFont	   := TXLSFont():New(Eval(bGetNumSeq))
	Default xColor 	   := ""
	Default lTrimSpc   := .F.
	
	::cCodigo    := cCodigo
	::cCodInt	 := cCodigo
	::oFont	     := oFont
	::cFormat    := cFormat
	::nAlignV    := nAlignV
	::nAlignH    := nAlignH
	::lLocked    := lLocked
	::lHidden    := lHidden     
	::lWrapText  := lWrapText
	::xColor 	 := xColor  
	::bGetNumSeq := bGetNumSeq
	::lTrimSpc   := lTrimSpc
	
	::aBorder	 := {}
	
	::lWrite	 := .T.

	//Adicina todas as linhas de bordas habilitando-as pela mascara	
	For nBorder := XLS_BORDER_LEFT TO XLS_BORDER_BOTTOM
	    lVisible := BitAtivo(nMskBorder,nBorder-1)
	    
	    oXLSline := TXLSLine():New(nBorder,lVisible)
	    
		AAdd(::aBorder,oXLSline)
	Next
return Self

method GetCodInt(cCodigo) class TXLSStyle
return ::cCodInt

method SetCodInt(cCodigo) class TXLSStyle
	cCodigo := AllTrim(cCodigo)

	::cCodInt := cCodigo                 
return

method GetCodigo() class TXLSStyle
return ::cCodigo

method GetBorder(nBorder) class TXLSStyle
return ::aBorder[nBorder]

method SetBorders(nMskBorder) class TXLSStyle
	Local nBorder
	Local lVisible

	Default nMskBorder := XLS_BORDER_MSK_ALL 
		
	For nBorder := XLS_BORDER_LEFT TO XLS_BORDER_BOTTOM
	    lVisible := BitAtivo(nMskBorder,nBorder-1)
	    
	    ::aBorder[nBorder]:lVisible := lVisible
	Next
return

method GetFont() class TXLSStyle
return ::oFont

/*================================================================================+
| Classe TXLSCommen
+================================================================================*/

class TXLSCommen  
  LOCAL:
 	method RetComment()
  
  PUBLIC:   
	data cAuthor
	data cComment
	data cHTML
	data xColor                          
	data nSize
	
 	method New(cComment,cAuthor,cHTML,xColor,nSize) CONSTRUCTOR
endclass             

method New(cComment,cAuthor,cHTML,xColor,nSize) class TXLSCommen
	Default cComment 	:= ""
	Default cAuthor		:= EXCEL_PROP_AUTHOR
	Default cHTML		:= ""               
	Default xColor		:= "#000000"
	Default nSize		:= 8
	
	cComment := AllTrim(cComment)
	cAuthor  := AllTrim(cAuthor)   
	cHTML	 := AllTrim(cHTML)
	
	::cAuthor		:= cAuthor
	::cComment		:= cComment
	::cHTML			:= cHTML        
	::xColor		:= xColor
	::nSize			:= nSize
return Self            

method RetComment() class TXLSCommen
	Local cBuffer := ""
	Local cHTML   := ::cHTML
	
	If Empty(cHTML) .And. !Empty(::cComment)
		cHTML := '<B>'
		cHTML += '<Font html:Face="Tahoma"'
		cHTML += ' html:Size="'+AllTrim(Str(::nSize))+'"'

		If !Empty(::xColor)
			Do Case
				Case ValType(::xColor)=="C"
					cHTML +=' html:Color="'+::xColor+'"'
				Case ValType(oXLSFont:xColor)=="N"
					cHTML +=' html:Color="'+AllTrim(Str(::xColor))+'"'
			EndCase               
		Else
			cHTML += ' html:Color="#000000"'
		EndIf
		
		cHTML += '>'
		cHTML += U_OemToUTF8(::cComment,.T.)
		cHTML += '&#10;'
		cHTML += '</Font>'
		cHTML += '</B>'
	Endif
	
	If !Empty(cHTML)
		cBuffer += '<Comment'
		
		If !Empty(::cAuthor)
			cBuffer += ' ss:Author="'+U_OemToUTF8(::cAuthor,.T.)+'"'
		EndIf
		
		cBuffer += '><ss:Data xmlns="http://www.w3.org/TR/REC-html40">'
		cBuffer += cHTML
		cBuffer += '</ss:Data>'
		cBuffer += '</Comment>'
	EndIf
	
return cBuffer

/*================================================================================+
| Classe TXLSHeader
+================================================================================*/

class TXLSHeader
  LOCAL:    
  	data nIndex

  PUBLIC:   
	data cHeader
	data nColsMerge
	data nRowsMerge    
	data oComment                   
	
 	method New(nIndex,cHeader,nColsMerge,nRowsMerge) CONSTRUCTOR
 	method GetIndex()
endclass             

method New(nIndex,cHeader,nColsMerge,nRowsMerge,cComment) class TXLSHeader
	Default cHeader 	:= ""
	Default nColsMerge  := 0     
	Default nRowsMerge  := 0
	
	cHeader := AllTrim(cHeader)
	
	::nIndex		:= nIndex   
	::cHeader		:= cHeader
	::nColsMerge    := nColsMerge              
	::nRowsMerge	:= nRowsMerge
return Self  

method GetIndex() class TXLSHeader
return ::nIndex

/*================================================================================+
| Classe TXLSCol																  |
+================================================================================*/

class TXLSCol        
  LOCAL:
  	data nIndex 
  	data bGetNumSeq
	data aHeader
	data aComment
  
  PUBLIC:
	data cTipo
	data oStyleHdr
	data oStyleCol
	data oStyleTot
	data aStyles
  	data bWrtCol   
  	data bWrtBlank          
  	data bGetData
  	data cFormula
  	data cRowFormul
  	data nWidth 
  	data lHidden

	method New(nIndex,cHeader,cTipo,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,bGetNumSeq,cFormula,cRowFormul,nWidth,bGetData,nHeaders,lHidden,nStyles,cComment) CONSTRUCTOR
	method GetIndex()
	method GetHeader(nIndex)
	method SetHeader(nIndex,cHeader,nColsMerge,nRowsMerge,cComment)
	method GetComment(nIndex)
	method GetStyle(nIndex)
	method QtdStyles()
endclass

method New(nIndex,cHeader,cTipo,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,bGetNumSeq,cFormula,cRowFormul,nWidth,bGetData,nHeaders,lHidden,nStyles,cComment) class TXLSCol
    Local oFont                    
    Local nCt
    
	cHeader := AllTrim(cHeader)
	
	Default cTipo := "C"                
	
	cTipo:=Upper(AllTrim(cTipo))
	
	If !(cTipo $ "CNPDL")
		cTipo := "C"
	EndIf
	
	Default nDecimais := IIF(cTipo $ "NP",2,0)
	
	If ValType(oStyleHdr)!="O"    
		oFont := TXLSFont():New(Eval(bGetNumSeq),,,,XLS_FONT_BOLD)
		oStyleHdr := TXLSStyle():New(Eval(bGetNumSeq),oFont, "@", , , , , , XLS_BORDER_MSK_ALL,"#C0C0C0",bGetNumSeq)
	EndIf
	If ValType(oStyleCol)!="O"
		oStyleCol := TXLSStyle():New(Eval(bGetNumSeq), , U_XLSFmtDef(cTipo,nDecimais), , , , , , XLS_BORDER_MSK_ALL,,bGetNumSeq,.T.)
	EndIf                                        

	If ValType(oStyleTot)!="O"
		oFont := TXLSFont():New(Eval(bGetNumSeq),,,,XLS_FONT_BOLD)
		oStyleTot := TXLSStyle():New(Eval(bGetNumSeq),oFont, U_XLSFmtDef(cTipo,nDecimais), , , , , , XLS_BORDER_MSK_ALL,,bGetNumSeq)
	EndIf
	
	Default cFormula   	:= ""    
	Default cRowFormul 	:= ""          
	Default nWidth	   	:= 0
	Default lHidden		:= .F.
	Default nStyles		:= 0
	
	::aHeader  := {}
	::aComment := {}
	
	For nCt:=1 To nHeaders
		AAdd(::aHeader, TXLSHeader():New(nCt) )
		AAdd(::aComment, TXLSCommen():New() )
	Next
	        
	::nIndex	   				:= nIndex	
	
	Atail(::aHeader):cHeader 	:= cHeader              
	
	If !Empty(cComment)
		Atail(::aComment):cComment 	:= AllTrim(cComment)
	EndIf
	
	::cTipo	    		   		:= cTipo
	::oStyleHdr  				:= oStyleHdr
	::oStyleCol  				:= oStyleCol     
	::oStyleTot  				:= oStyleTot
	::bGetNumSeq 				:= bGetNumSeq
	::cFormula   				:= cFormula
	::bGetData	 				:= bGetData
	::cRowFormul 				:= cRowFormul
	::nWidth	 				:= nWidth
	::lHidden					:= lHidden
	::aStyles					:= {}

	For nCt:=1 To nStyles
		AAdd(::aStyles, TXLSStyle():New(Eval(bGetNumSeq), , U_XLSFmtDef(cTipo,nDecimais), , , , , , XLS_BORDER_MSK_ALL,,bGetNumSeq,.T.) )
	Next
	
return Self

method GetIndex() class TXLSCol
return ::nIndex

method GetHeader(nIndex) class TXLSCol
return IIF(nIndex>=1 .And. nIndex<=Len(::aHeader),::aHeader[nIndex],NIL)

method SetHeader(nIndex,cHeader,nColsMerge,nRowsMerge,cComment) class TXLSCol
	If nIndex>=1 .And. nIndex<=Len(::aHeader)
		If cHeader != NIL
			::aHeader[nIndex]:cHeader := cHeader
		EndIf
		If nColsMerge != NIL
			::aHeader[nIndex]:nColsMerge := nColsMerge
		EndIf
		If nRowsMerge != NIL
			::aHeader[nIndex]:nRowsMerge := nRowsMerge
		EndIf
		If cComment != NIL
			::aComment[nIndex]:cComment := cComment
		EndIf
	EndIf
return          

method GetComment(nIndex) class TXLSCol
return IIF(nIndex>=1 .And. nIndex<=Len(::aComment),::aComment[nIndex],NIL)

method GetStyle(nIndex) class TXLSCol
	Local oStyle
	
	If nIndex >= 1 .And. nIndex <= Len(::aStyles)
		oStyle := ::aStyles[nIndex]
	EndIf                        
	
return oStyle  

method QtdStyles(nIndex) class TXLSCol   
return Len(::aStyles)  

/*================================================================================+
| Classe TXLSCond
+================================================================================*/

class TXLSCond
  LOCAL:
  	data nIndex       
  
  PUBLIC:
	data xCondition
	data xVal1
	data xVal2                                  
	data cFormat

	method New(nIndex,xCondition,xVal1,xVal2,cFormat) CONSTRUCTOR
	method GetIndex()    
endclass

method New(nIndex,xCondition,xVal1,xVal2,cFormat) class TXLSCond   

	Default cFormat := ''

	::nIndex  	 := nIndex
	::xCondition := xCondition
	::xVal1		 := xVal1
	::xVal2		 := xVal2
	::cFormat	 := cFormat
return Self

method GetIndex() class TXLSCond
return ::nIndex

/*================================================================================+
| Classe TXLSFmtCnd
+================================================================================*/

class TXLSFmtCnd
  LOCAL:
  	data nIndex       
  	data aCondition
  
  PUBLIC:
  	data cRange

	method New(nIndex,cRange) CONSTRUCTOR
	method GetIndex()    
	method AddCond(xCondition,xVal1,xVal2)
	method GetCond(nCond)
	method GetCount()
endclass

method New(nIndex,cRange) class TXLSFmtCnd

	::nIndex  	 := nIndex
	::cRange  	 := cRange
	::aCondition := {}
return Self

method GetIndex() class TXLSFmtCnd
return ::nIndex

method AddCond(xCondition,xVal1,xVal2,cFormat) class TXLSFmtCnd
	Local oRet
	
	If Len(::aCondition) < 3
	    oRet := TXLSCond():New(Len(::aCondition)+1,xCondition,xVal1,xVal2,cFormat)

		AAdd(::aCondition,oRet)
	EndIf
return oRet       

method GetCond(nCond) class TXLSFmtCnd
return IIF(nCond>0 .And. nCond<=3,::aCondition[nCond],NIL)

method GetCount() class TXLSFmtCnd
return Len(::aCondition)

/*================================================================================+
| Classe TXLSWrkSht																  |
+================================================================================*/

class TXLSWrkSht
      LOCAL:                 
      	data nIndex
		data aColumns      
		data bWrite
		data lHdrWrited
		data nRowsWrt
		data nHandle    
		data nPosRows
		data bGetNumSeq
		data lComTotais
		data nHeaders
		data aHeightHdr
		data lHidden
		data aFormCond 
		data bGetStyle
		
		data cNewRow                            
		data nColIndex
		
		data nTotWidth
		
		data nStyles

		method GetPrScale()
		method WriteHdr()         
		method WriteFim() 
		method WrtFmtCnd()
		method WrtTotRow()
		method WrtDefCols()
		method WriteRow(aDados,nHeight,xStyle,aComments,lFormula)
		method WrtRowForm(aDados,nHeight,xStyle,aComments,xFormula)
	
	  PUBLIC:
		data cHeader
		data cPgHeader
		data cPgFooter
		data nPgOrienta
		data nPrtScale
		data nRowFreeze
		data nColFreeze
		data nHeightHdr
		data nHeightRow
		data nMgrHeader
		data nMgrFooter
		data nPgTop
		data nPgBottom
		data nPgLeft
		data nPgRight
		data cLinRepSup
		data cColRepEsq
		
		data cDefStyle 
		
		method New(nIndex,cHeader,nRowFreeze,nHandle,bWrite,bGetNumSeq,nHeightHdr,nHeightRow,nHeaders,cPgHeader,cPgFooter,nPgOrienta,nPrtScale,nMgrHeader,nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,lHidden,cLinRepSup,cColRepEsq,bGetStyle,nStyles,nColFreeze) CONSTRUCTOR
		method GetIndex()
		method GetWidth()
		method WrtHdrCols()
		method AddColumn(cHeader,cTipo,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,cRowFormul,nWidth,bGetData,lHidden,cComment)
		method AddFormula(cHeader,cTipo,cFormula,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,cRowFormul,nWidth,lHidden,cComment)
		method AddRowData(aDados,nHeight,xStyle,aComments,xFormula)
		method AddRowForm(aDados,nHeight,xStyle,aComments,xFormula)
		method NewRow(nIndex,nHeight)
		method EndRow()
		method AddRowsBlk(nRows)
		method NewCell(xValor,cFormula,cCodStyle,nColIndex,nColsMerge,nRowsMerge,cTipo,oComment)
		method SetWrtCols(nCol)
		
		method MaxCols()
		method GetColumn(nIndex)
		method GetWrited() 
		method AddFmtCnd(cRange)
		method GetFmtCnd(nIndex)
		method MaxFmtCnd()
		method Free()      
		method GetRHeight(nIndex)
		method SetRHeight(nIndex,nHeight)
		method GetFirstRow()
		method GetRowAtu()
		method GetRowsWrt()
endclass

method New(nIndex,cHeader,nRowFreeze,nHandle,bWrite,bGetNumSeq,nHeightHdr,nHeightRow,nHeaders,cPgHeader,cPgFooter,nPgOrienta,nPrtScale,nMgrHeader,nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,lHidden,cLinRepSup,cColRepEsq,bGetStyle,nStyles,nColFreeze) class TXLSWrkSht
	Local nHdr

	cHeader:=AllTrim(cHeader)                                 
	
	Default nRowFreeze := nHeaders
	Default nColFreeze := 0
		
	If ValType(bWrite) != "B"
		bWrite := {|| .T.}
	EndIf              
	
	Default nHeightHdr 	:= 0
	Default nHeightRow 	:= 0        
	Default nHeaders   	:= 1

	Default cPgHeader	:= ""
	Default cPgFooter	:= ""
	
	Default nPgOrienta  := XLS_PAGE_PORTRAIT
	
	Default nPrtScale	:= 100

	Default nMgrHeader 	:= 0.492125985
	Default nMgrFooter 	:= 0.492125985
	Default nPgTop	   	:= 0.984251969
	Default nPgBottom  	:= 0.984251969
	Default nPgLeft		:= 0.787401575
	Default nPgRight	:= 0.787401575
	
	Default lHidden		:= .F.
	
	Default cLinRepSup	:= "R1:R"+AllTrim(Str(nHeaders))
	Default cColRepEsq	:= ""
	Default nStyles		:= 0

	::nIndex	 := nIndex	
	::cHeader	 := cHeader
	::nRowFreeze := nRowFreeze
	::nColFreeze := nColFreeze
	::bWrite	 := bWrite
	::aColumns	 := {}        
	::lHdrWrited := .F.
	::nHandle	 := nHandle
	::nRowsWrt	 := 0
	::nPosRows   := 0
	::bGetNumSeq := bGetNumSeq
	::lComTotais := .F.    
	::nHeightHdr := nHeightHdr  
	::nHeightRow := nHeightRow
	::nHeaders	 := nHeaders
	::aHeightHdr := {}
	::cPgHeader	 := cPgHeader
	::cPgFooter	 := cPgFooter
	::nPgOrienta := nPgOrienta
	::nPrtScale  := nPrtScale

	::nMgrHeader := nMgrHeader
	::nMgrFooter := nMgrFooter
	::nPgTop   	 := nPgTop
	::nPgBottom  := nPgBottom
	::nPgLeft	 := nPgLeft
	::nPgRight	 := nPgRight 
	
	::lHidden	 := lHidden
	
	::aFormCond	 := {}
	
	::cLinRepSup := cLinRepSup 
	::cColRepEsq := cColRepEsq
	
	For nHdr:=1 To nHeaders
		AAdd(::aHeightHdr, nHeightHdr)
	Next     
	
	::cNewRow	 := ""
	::nColIndex	 := 0

	::cDefStyle  := "" 
	::bGetStyle  := bGetStyle
	
	::nTotWidth	 := 0
	
	::nStyles    := nStyles
return Self              

method GetIndex() class TXLSWrkSht
return ::nIndex

method GetWidth() class TXLSWrkSht
return ::nTotWidth

method GetPrScale() class TXLSWrkSht          
	Local _nPgWCm
	Local _nPgWPtos
	Local _nCt
	Local _nTotWidth := 0
	Local _nRet
	
	_nRet := ::nPrtScale
	
	If _nRet==0
		For nCt:=1 To Len(::aColumns)
			If !::aColumns[nCt]:lHidden
				_nTotWidth += ::aColumns[nCt]:nWidth
			EndIf
		Next
	
		Do Case
		  Case ::nPgOrienta  == XLS_PAGE_PORTRAIT
		  	_nPgWCm := 21
		  Case ::nPgOrienta  == XLS_PAGE_LANDSCAPE
		  	_nPgWCm := 29.7
		EndCase

		_nPgWCm -= 2.4
		_nPgWCm -= ::nPgLeft
		_nPgWCm -= ::nPgRight
		
		_nPgWPtos := Round(_nPgWCm/2.54*72,0)   
		
		_nRet := IIF(_nTotWidth==0,100,NoRound(_nPgWPtos/_nTotWidth*100,0))
	EndIf
	
Return _nRet

method AddColumn(cHeader,cTipo,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,cRowFormul,nWidth,bGetData,lHidden,cComment) class TXLSWrkSht
	Local nIndex                  
	
	cHeader := AllTrim(cHeader)
	nIndex  := Len(::aColumns)+1
	
	Default nWidth	:= ConvWidth(nWidth,nTamanho)
	Default lHidden := .F.
	
	AAdd(::aColumns,TXLSCol():New(nIndex,cHeader,cTipo,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,::bGetNumSeq,,cRowFormul,nWidth,bGetData,::nHeaders,lHidden,::nStyles,cComment))

	If !lHidden
		::nTotWidth += nWidth
	EndIf

	If !Empty(cRowFormul)
		::lComTotais := .T.
	EndIf
return aTail(::aColumns)

method AddFormula(cHeader,cTipo,cFormula,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,cRowFormul,nWidth,lHidden,cComment) class TXLSWrkSht
	Local nIndex                  
	
	cHeader := AllTrim(cHeader)
	nIndex  := Len(::aColumns)+1

	Default nWidth	:= ConvWidth(nWidth,nTamanho)
	Default lHidden := .F.
		
	AAdd(::aColumns,TXLSCol():New(nIndex,cHeader,cTipo,nTamanho,nDecimais,oStyleHdr,oStyleCol,oStyleTot,::bGetNumSeq,cFormula,cRowFormul,nWidth,,::nHeaders,lHidden,::nStyles,cComment))

	If !lHidden
		::nTotWidth += nWidth
	EndIf

	If !Empty(cRowFormul)
		::lComTotais := .T.
	EndIf
return aTail(::aColumns)

method AddRowData(aDados,nHeight,xStyle,aComments,xFormula) class TXLSWrkSht
	Local lRet := .T.
	
	If ! ::lHdrWrited
		lRet := ::WriteHdr()
	EndIf           

	If lRet .And. !Empty(::cNewRow)
		lRet := ::EndRow()
	EndIf

	If lRet        
		lRet := ::WriteRow(aDados,nHeight,xStyle,aComments,xFormula)
	EndIf

	If lRet
		::nRowsWrt++
	EndIf
return lRet

method AddRowForm(aDados,nHeight,xStyle,aComments,xFormula)  class TXLSWrkSht
	Local lRet := .T.
	
	If ! ::lHdrWrited
		lRet := ::WriteHdr()
	EndIf           

	If lRet .And. !Empty(::cNewRow)
		lRet := ::EndRow()
	EndIf

	If lRet        
		lRet := ::WrtRowForm(aDados,nHeight,xStyle,aComments,xFormula)
	EndIf

	If lRet
		::nRowsWrt++
	EndIf
return lRet

method NewRow(nIndex,nHeight)  class TXLSWrkSht
	Local lRet := .T.

	Default nIndex	:= ::nRowsWrt+1
	Default nHeight := ::nHeightRow
	
	If ! ::lHdrWrited
		lRet := ::WriteHdr()
	EndIf
	
	If lRet .And. !Empty(::cNewRow)
		lRet := ::EndRow()
	EndIf
	
	If lRet        
		::cNewRow := '   <Row'

		If nIndex > ( ::nRowsWrt + 1 )
			::cNewRow += ' ss:Index="'+AllTrim(Str(nIndex))+'"'
		EndIf
		
		IF nHeight>0
			::cNewRow += ' ss:AutoFitHeight="0" ss:Height="'+AllTrim(Str(nHeight))+'"'
		EndIF

		::cNewRow += '>'+NEW_LINE

		::nRowsWrt  := nIndex
		::nColIndex	:= 0
	EndIf  
	
return lRet

method EndRow()  class TXLSWrkSht
	Local lRet := .T.
	
	If !Empty(::cNewRow)
		::cNewRow += '   </Row>'+NEW_LINE

		lRet := (FWrite(::nHandle,::cNewRow,Len(::cNewRow))==Len(::cNewRow))			
		
		::cNewRow   := ""
		::nColIndex	:= 0
	Endif
	
return lRet             

method AddRowsBlk(nRows,nHeight) class TXLSWrkSht
	Local nCt
	Local lRet
	
	Default nRows := 1

	If nHeight==NIL
		lRet := ::NewRow(::GetRowAtu()+nRows-1)
		If lRet 
			lRet := ::EndRow()
		EndIf
	Else	
		For nCt:=1 To nRows
			lRet := ::NewRow(,nHeight)
			If lRet 
				lRet := ::EndRow()
			EndIf
			If !lRet
				Exit			
			EndIf
		Next
	EndIf
return lRet

method NewCell(xValor,cFormula,cCodStyle,nColIndex,nColsMerge,nRowsMerge,cTipo,oComment)  class TXLSWrkSht
	Local lRet := .T.
	Local oXLSStyle

	Default cCodStyle	:= ::cDefStyle
	Default nColIndex 	:= ::nColIndex+1
	Default nColsMerge	:= 0
	Default nRowsMerge	:= 0              
	
	If Empty(::cNewRow)
		lRet := ::NewRow()
	EndIf 

	oXLSStyle := Eval(::bGetStyle,cCodStyle)

	::cNewRow += ValToCell(nColIndex,xValor,cFormula,oXLSStyle,nColsMerge,nRowsMerge,cTipo,oComment)

	::nColIndex	:= nColIndex + nColsMerge + 1
return lRet

method GetColumn(nIndex) class TXLSWrkSht
	Default nIndex := Len(::aColumns)
return IIF(nIndex>=0 .And. nIndex<=Len(::aColumns),::aColumns[nIndex],NIL)

method GetWrited() class TXLSWrkSht
return ::lHdrWrited

method MaxCols() class TXLSWrkSht
return Len(::aColumns)

method WriteHdr() class TXLSWrkSht
	Local lRet := .T.
	Local cBuffer
	Local cWorkSheet

	lRet := Eval(::bWrite)
	
	::SetWrtCols()

	If lRet  
		cWorkSheet := U_OemToUTF8(NameWrkSht(::cHeader))

		cBuffer := '<Worksheet ss:Name="'+cWorkSheet+'">'+NEW_LINE

		If !Empty(::cLinRepSup) .Or. !Empty(::cColRepEsq)
			cBuffer += '  <Names>'+NEW_LINE
			cBuffer += '   <NamedRange ss:Name="Print_Titles"'+NEW_LINE
			cBuffer += '    ss:RefersTo="'
			If !Empty(::cColRepEsq)                   
				cBuffer += '='
				If At('!',::cColRepEsq) == 0
					cBuffer += "'"+cWorkSheet+"'!"
				EndIf
				cBuffer += AllTrim(::cColRepEsq)
				If !Empty(::cLinRepSup)
					cBuffer += ','
				EndIf
			EndIf
			If !Empty(::cLinRepSup)                   
				If Empty(::cColRepEsq)                   
					cBuffer += '='
				EndIf
				If At('!',::cLinRepSup) == 0
					cBuffer += "'"+cWorkSheet+"'!"
				EndIf
				cBuffer += AllTrim(::cLinRepSup)
			EndIf
			cBuffer += '"/>'+NEW_LINE
			cBuffer += '  </Names>'+NEW_LINE
		EndIf
		
		cBuffer += '  <Table ss:ExpandedColumnCount="'+AllTrim(Str(Len(::aColumns)))+'"'
		cBuffer += ' ss:ExpandedRowCount="'

		lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))
		
		If lRet 
			::nPosRows := FSeek(::nHandle,0,FS_RELATIVE)
			
			cBuffer := Replicate('0',5)+'"'
			cBuffer += ' x:FullColumns="1" x:FullRows="1">'+NEW_LINE     

			lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))		
		EndIf
	
		If lRet             
			lRet := ::WrtDefCols() 
		EndIf   

//		If lRet
//			lRet := ::WrtHdrCols()
//		EndIf
	EndIf    

	::lHdrWrited := .T.
return lRet

method WrtDefCols() class TXLSWrkSht
	Local lRet := .T.      
	Local nCt
	Local cBuffer := ""

	For nCt:=1 To Len(::aColumns)
		If ::aColumns[nCt]:nWidth > 0
			cBuffer += '   <Column ss:AutoFitWidth="0" ss:Index="'+AllTrim(Str(::aColumns[nCt]:GetIndex()))+'"'
			If ::aColumns[nCt]:lHidden
				cBuffer += ' ss:Hidden="1"'
			EndIf
			cBuffer += ' ss:Width="'+AllTrim(Str(::aColumns[nCt]:nWidth))+'"/>'+NEW_LINE
		EndIf
	Next
	
	If !Empty(cBuffer)
		lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))			
	EndIf
	
return lRet

method WrtHdrCols() class TXLSWrkSht
	Local lRet := .T.      
	Local nCt
	Local nHdr
	Local cBuffer
	Local cHeader                               
	Local aRowsMerge 
	Local nIdxA          
	Local nIdxB

	If ! ::lHdrWrited
		lRet := ::WriteHdr()
	EndIf           
	
	If lRet .And. !Empty(::cNewRow)
		lRet := ::EndRow()
	EndIf

	If lRet	                                

		//Define tabela para controlar a geração dos cabeçalhos marcando inicialmentetodas as Linhas X Colunas para gerar cabecalhos
		aRowsMerge := Array(Len(::aColumns))
	
		For nCt:=1 To Len(aRowsMerge)       
			aRowsMerge[nCt] := Array(::nHeaders)

			For nIdxA:=1 To ::nHeaders
				aRowsMerge[nCt][nIdxA] := .T.
			Next
		Next

		//Gera os cabeçalhos percorrendo as Linhas		
		For nHdr:=1 To ::nHeaders

	   		cBuffer := '   <Row'+IIF(::GetRHeight(nHdr)>0,' ss:AutoFitHeight="0" ss:Height="'+AllTrim(Str(::GetRHeight(nHdr)))+'"','')+'>'+NEW_LINE
	
			//Gera os cabeçalhos percorrendo as Colunas dentro das linhas
			For nCt:=1 To Len(::aColumns)       

				//Verifica se deve gerar o cabeçalho para Linha X Coluna atual
				If aRowsMerge[nCt][nHdr]
					cHeader := AllTrim(::aColumns[nCt]:GetHeader(nHdr):cHeader)
				
					cBuffer += '     <Cell ss:Index="'+AllTrim(Str(nCt))+'"'
	
					If ::aColumns[nCt]:GetHeader(nHdr):nRowsMerge > 0
						cBuffer += ' ss:MergeDown="'+AllTrim(Str(::aColumns[nCt]:GetHeader(nHdr):nRowsMerge))+'"'
					Endif
	
					If ::aColumns[nCt]:GetHeader(nHdr):nColsMerge > 0
						cBuffer += ' ss:MergeAcross="'+AllTrim(Str(::aColumns[nCt]:GetHeader(nHdr):nColsMerge))+'"'
					Endif                                                                                                  
					
					//Marca Linha X Coluna para não gerar cabecalhos baseando-se na quantidade de linhas e colunas em merge					
					//Mantem a Linha X Coluna atual liberada para gerar o cabecalho base
	  				For nIdxA:=nHdr To Min(::nHeaders,nHdr+::aColumns[nCt]:GetHeader(nHdr):nRowsMerge)
		  				For nIdxB:=nCt To Min(Len(::aColumns),nCt+::aColumns[nCt]:GetHeader(nHdr):nColsMerge)

							//Somente atualiza se não for a Linha X Coluna atual
		  					If nIdxA<>nHdr .Or. nIdxB<>nCt
								aRowsMerge[nIdxB][nIdxA] := .F.
		  					EndIf

		  				Next
	  				Next
	
					cBuffer += ' ss:StyleID="'+::aColumns[nCt]:oStyleHdr:GetCodInt()+'">'
		
					If !Empty(cHeader)
						cBuffer += '<Data ss:Type="String">'+U_OemToUTF8(cHeader,::aColumns[nCt]:oStyleHdr:lTrimSpc)+'</Data>'
					EndIf                                                                                                                       
					
					cBuffer += ::aColumns[nCt]:GetComment(nHdr):RetComment()

					cBuffer += '</Cell>'+NEW_LINE
				EndIf
			Next           
			
			cBuffer += '   </Row>'+NEW_LINE
	
			lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))			
				
			If lRet
				::nRowsWrt++
			Else
				Exit
			EndIf
		Next
	EndIf
	
return lRet

method WriteFim() class TXLSWrkSht
	Local cBuffer
	Local lRet := .T.
	Local cBuffer

	If ::lHdrWrited
		If ::lComTotais	
			lRet :=	::WrtTotRow()
		EndIf
		
		If lRet                          
			cBuffer := '  </Table>'+NEW_LINE
			cBuffer += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+NEW_LINE
			cBuffer += '   <PageSetup>'+NEW_LINE                    
			
			cBuffer += '    <Layout x:Orientation="'+IIF(::nPgOrienta==XLS_PAGE_LANDSCAPE,'Landscape','Portrait')+'"/>'+NEW_LINE

			cBuffer += '    <Header x:Margin="'+AllTrim(Str(::nMgrHeader/2.54))+'"'
			If !Empty(::cPgHeader)
				cBuffer += ' x:Data="'+::cPgHeader+'"'
			EndIf
			cBuffer +='/>'+NEW_LINE

			cBuffer += '    <Footer x:Margin="'+AllTrim(Str(::nMgrFooter/2.54))+'"'
			If !Empty(::cPgFooter)
				cBuffer += ' x:Data="'+::cPgFooter+'"'
			EndIf
			cBuffer +='/>'+NEW_LINE

			cBuffer += '    <PageMargins x:Bottom="'+AllTrim(Str(::nPgBottom/2.54))+'"'
			cBuffer += ' x:Left="'+AllTrim(Str(::nPgLeft/2.54))+'"'+NEW_LINE
			cBuffer += '     x:Right="'+AllTrim(Str(::nPgRight/2.54))+'"'
			cBuffer += ' x:Top="'+AllTrim(Str(::nPgTop/2.54))+'"/>'+NEW_LINE
			cBuffer += '   </PageSetup>'+NEW_LINE
			If ::lHidden
				cBuffer += '   <Visible>SheetHidden</Visible>'
			EndIf
			cBuffer += '   <Print>'+NEW_LINE
			cBuffer += '    <ValidPrinterInfo/>'+NEW_LINE
			cBuffer += '    <PaperSizeIndex>9</PaperSizeIndex>'+NEW_LINE
			cBuffer += '    <Scale>'+AllTrim(Str(::GetPrScale()))+'</Scale>'
			cBuffer += '    <HorizontalResolution>600</HorizontalResolution>'+NEW_LINE
			cBuffer += '    <VerticalResolution>600</VerticalResolution>'+NEW_LINE
			cBuffer += '   </Print>'+NEW_LINE
	
			If ::nIndex == 1
				cBuffer += '   <Selected/>'+NEW_LINE
			EndIf
			
			If ::nRowFreeze > 0 .Or. ::nColFreeze > 0
				cBuffer += '   <FreezePanes/>'+NEW_LINE
				cBuffer += '   <FrozenNoSplit/>'+NEW_LINE
				If ::nRowFreeze > 0
					cBuffer += '   <SplitHorizontal>'+AllTrim(Str(::nRowFreeze))+'</SplitHorizontal>'+NEW_LINE
					cBuffer += '   <TopRowBottomPane>'+AllTrim(Str(::nRowFreeze))+'</TopRowBottomPane>'+NEW_LINE
				EndIf
				If ::nColFreeze > 0
					cBuffer += '   <SplitVertical>'+AllTrim(Str(::nColFreeze))+'</SplitVertical>'+NEW_LINE
					cBuffer += '   <LeftColumnRightPane>'+AllTrim(Str(::nColFreeze))+'</LeftColumnRightPane>'+NEW_LINE
				EndIf					
				cBuffer += '   <ActivePane>'+IIF(::nColFreeze==0,'2',IIF(::nRowFreeze==0,'1','0'))+'</ActivePane>'+NEW_LINE  
				
				cBuffer += '   <Panes>'+NEW_LINE  
				cBuffer += '     <Pane>'+NEW_LINE  
				cBuffer += '       <Number>3</Number>'+NEW_LINE  
				cBuffer += '     </Pane>'+NEW_LINE  
				If ::nRowFreeze ==0 .And. ::nColFreeze > 0
				  cBuffer += '     <Pane>'+NEW_LINE  
  				  cBuffer += '       <Number>1</Number>'+NEW_LINE  
				  cBuffer += '     </Pane>'+NEW_LINE  
				EndIf
				If ::nRowFreeze > 0
				  cBuffer += '     <Pane>'+NEW_LINE  
  				  cBuffer += '       <Number>2</Number>'+NEW_LINE  
				  cBuffer += '     </Pane>'+NEW_LINE  
				EndIf
				If ::nRowFreeze >0 .And. ::nColFreeze > 0
				  cBuffer += '     <Pane>'+NEW_LINE  
  				  cBuffer += '       <Number>0</Number>'+NEW_LINE  
				  cBuffer += '     </Pane>'+NEW_LINE  
				EndIf
				cBuffer += '   </Panes>'+NEW_LINE  
/*
			Else
				cBuffer += '   <Panes>'+NEW_LINE  
				cBuffer += '     <Pane>'+NEW_LINE  
				cBuffer += '       <Number>3</Number>'+NEW_LINE  
				cBuffer += '       <ActiveRow>1</ActiveRow>'+NEW_LINE  
				cBuffer += '     </Pane>'+NEW_LINE  
				cBuffer += '   </Panes>'+NEW_LINE  
*/				
			EndIf
	
			cBuffer += '   <ProtectObjects>False</ProtectObjects>'+NEW_LINE
			cBuffer += '   <ProtectScenarios>False</ProtectScenarios>'+NEW_LINE
			cBuffer += '  </WorksheetOptions>'+NEW_LINE
			
			lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))		
			
			lRet := ::WrtFmtCnd()
			
			If lRet
				cBuffer := '</Worksheet>'+NEW_LINE
				lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))		
			EndIf
		EndIf
			
		If lRet .And. ::nPosRows > 0
			FSeek(::nHandle,::nPosRows,FS_SET)
			
			cBuffer := Right(Replicate('0',5)+AllTrim(Str(::nRowsWrt)),5)
			
			lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))		
			
			FSeek(::nHandle,0,FS_END)
		Endif      
		
		::lHdrWrited :=.F. 
	EndIf    

return lRet       

method WrtFmtCnd() class TXLSWrkSht
	Local lRet := .T.     
	Local nCt   
	Local cBuffer := ""
	
	If Len(::aFormCond) > 0
		For nCt:=1 To Len(::aFormCond)
			cBuffer += FormCond(::aFormCond[nCt])
		Next
		
		If !Empty(cBuffer)
			lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))		
		EndIf
	EndIf
return lRet

method WrtTotRow() class TXLSWrkSht
	Local lRet := .T.
	Local nCt
	Local cBuffer := ""
	
	For nCt:=1 To Len(::aColumns)
		cBuffer += ColTotForm(::aColumns[nCt],::nHeaders)
	Next
	
	If !Empty(cBuffer)  
   		cBuffer := '   <Row'+IIF(::nHeightRow>0,' ss:AutoFitHeight="0" ss:Height="'+AllTrim(Str(::nHeightRow))+'"','')+'>'+NEW_LINE+cBuffer+'   </Row>'+NEW_LINE
	         
		lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))			
		
		If lRet
			::nRowsWrt++
		EndIf
	EndIf
return lRet

method WriteRow(aDados,nHeight,xStyle,aComments,xFormula) class TXLSWrkSht
	Local lRet := .T.
	Local nCt
	Local nMaxCols
	Local cBuffer := ""
	Local nStyle
	Local xValor
	Local lFormula
   
	Default aDados 		:= {}
	Default nHeight 	:= ::nHeightRow
	Default xStyle  	:= 0
	Default aComments   := {}
	Default xFormula	:= .T.
	
	nMaxCols:=Min(Len(::aColumns),Len(aDados))

	For nCt:=1 To nMaxCols    
		If ValType(xStyle)=="B"
			nStyle := Eval(xStyle,nCt,aDados)
		Else 
			nStyle := xStyle
		EndIf
		
		If ValType(xFormula)=="B"
			lFormula := Eval(xFormula,nCt,aDados)
		Else
			lFormula := xFormula
		EndIf		
		
		If aDados[nCt]==NIL
//			If ValType(::aColumns[nCt]:bGetData)=="B"
//				cBuffer += Eval(::aColumns[nCt]:bWrtCol,Eval(::aColumns[nCt]:bGetData))
//			Else
				cBuffer += Eval(::aColumns[nCt]:bWrtBlank,nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL),lFormula)
//			EndIf
		Else	    
			If ValType(aDados[nCt])=="B"
				xValor := Eval(aDados[nCt],nCt,::aColumns[nCt])
			Else
				xValor := aDados[nCt]
			EndIf
							
			cBuffer += Eval(::aColumns[nCt]:bWrtCol,xValor,nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
		EndIf
	Next      
	
	If nCt <= Len(::aColumns)
		For nCt:=Len(aDados)+1 To Len(::aColumns)    
			If ValType(xStyle)=="B"
				nStyle := Eval(xStyle,nCt,aDados)
			Else 
				nStyle := xStyle
			EndIf

			If ValType(xFormula)=="B"
				lFormula := Eval(xFormula,nCt,aDados)
			Else
				lFormula := xFormula
			EndIf		

			If ValType(::aColumns[nCt]:bGetData)=="U"
				If Empty(::aColumns[nCt]:cFormula)
					cBuffer += Eval(::aColumns[nCt]:bWrtBlank,nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL),lFormula)
				Else
					cBuffer += Eval(::aColumns[nCt]:bWrtCol,NIL,nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
				Endif
			Else
				cBuffer += Eval(::aColumns[nCt]:bWrtCol,Eval(::aColumns[nCt]:bGetData),nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
			EndIf
		Next
	EndIf    
	 
	If !Empty(cBuffer)
   		cBuffer := '   <Row'+IIF(nHeight>0,' ss:AutoFitHeight="0" ss:Height="'+AllTrim(Str(nHeight))+'"','')+'>'+NEW_LINE+;
   		           cBuffer+'   </Row>'+NEW_LINE

		lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))			
	EndIf
return lRet

method WrtRowForm(aDados,nHeight,xStyle,aComments,xFormula) class TXLSWrkSht
	Local lRet := .T.
	Local nCt
	Local nMaxCols
	Local cBuffer := ""
	Local nStyle
	Local lFormula
   
	Default aDados  	:= {}
	Default nHeight 	:= ::nHeightRow    
	Default xStyle  	:= 0
	Default aComments   := {}
	Default xFormula	:= .T.                     
	
	nMaxCols:=Min(Len(::aColumns),Len(aDados))

	For nCt:=1 To nMaxCols    
		If ValType(xStyle)=="B"
			nStyle := Eval(xStyle,aDados)
		Else 
			nStyle := xStyle
		EndIf	
    
		If ValType(xFormula)=="B"
			lFormula := Eval(xFormula,nCt,aDados)
		Else
			lFormula := xFormula
		EndIf		

		If aDados[nCt]==NIL
			cBuffer += Eval(::aColumns[nCt]:bWrtBlank,nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL),lFormula)
		ElseIf ValType(aDados[nCt])=="C" .And. Left(AllTrim(aDados[nCt]),2)=="@="
			cBuffer += ColTotForm(::aColumns[nCt],::nHeaders,SubStr(AllTrim(aDados[nCt]),2),nStyle,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
		Else          
			If ValType(aDados[nCt])=="B"
				cBuffer += ColTotDados(::aColumns[nCt],Eval(aDados[nCt]),,nStyle,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
			Else				
				cBuffer += ColTotDados(::aColumns[nCt],aDados[nCt],,nStyle,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
			EndIf
//			cBuffer += Eval(::aColumns[nCt]:bWrtCol,aDados[nCt])
		EndIf
	Next      
	
	If nCt <= Len(::aColumns)
		For nCt:=Len(aDados)+1 To Len(::aColumns)    
			If ValType(xStyle)=="B"
				nStyle := Eval(xStyle,aDados)
			Else 
				nStyle := xStyle
			EndIf	

			If ValType(xFormula)=="B"
				lFormula := Eval(xFormula,nCt,aDados)
			Else
				lFormula := xFormula
			EndIf		
			
			If ValType(::aColumns[nCt]:bGetData)=="B"
				cBuffer += Eval(::aColumns[nCt]:bWrtCol,Eval(::aColumns[nCt]:bGetData),nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL))
			Else
				cBuffer += Eval(::aColumns[nCt]:bWrtBlank,nStyle,::aColumns[nCt],,IIF(nCt<=Len(aComments),aComments[nCt],NIL),lFormula)
			EndIf
		Next
	EndIf    
	 
	If !Empty(cBuffer)
   		cBuffer := '   <Row'+IIF(nHeight>0,' ss:AutoFitHeight="0" ss:Height="'+AllTrim(Str(nHeight))+'"','')+'>'+NEW_LINE+;
   		           cBuffer+'   </Row>'+NEW_LINE

		lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))			
	EndIf
return lRet

method SetWrtCols(nCol) class TXLSWrkSht
	Local nCt   
	Local nMinCol := 1
	Local nMaxCol := Len(::aColumns)                            
	Local cBlock  
	
	If !Empty(nCol)
		nMinCol := nCol
		nMaxCol := nCol
	EndIf

	For nCt:=nMinCol To nMaxCol
		::aColumns[nCt]:bWrtCol   := ColCBlock(::aColumns[nCt])
		::aColumns[nCt]:bWrtBlank := ColCBlock(::aColumns[nCt],.T.)
	Next
return 

method AddFmtCnd(cRange) class TXLSWrkSht
	Local oRet        
	
	oRet := TXLSFmtCnd():New(Len(::aFormCond)+1,cRange)
	
	AAdd(::aFormCond,oRet)
return oRet

method GetFmtCnd(nIndex) class TXLSWrkSht
return IIF(nIndex>0 .And. nIndex<=Len(::aFormCond),::aFormCond[nIndex],NIL)

method MaxFmtCnd() class TXLSWrkSht  
return Len(::aFormCond)

method Free() class TXLSWrkSht
	If !::lHdrWrited
		::WriteHdr()
	EndIf
	If ::lHdrWrited
		::WriteFim()
	EndIf
return 

method GetRHeight(nIndex) class TXLSWrkSht        
return IIF(nIndex>=1 .And. nIndex<=Len(::aHeightHdr),::aHeightHdr[nIndex],0)

method SetRHeight(nIndex,nHeight) class TXLSWrkSht
	If nIndex>=1 .And. nIndex<=Len(::aHeightHdr)
		::aHeightHdr[nIndex] := nHeight
	EndIf
return           

method GetFirstRow() class TXLSWrkSht
return ::nHeaders+1

method GetRowAtu() class TXLSWrkSht
return ::nRowsWrt+1

method GetRowsWrt() class TXLSWrkSht
return ::nRowsWrt

/*================================================================================+
| Classe TXLSProp																  |
+================================================================================*/

class TXLSProp
	  PUBLIC:
		data cTitulo
		data cSubject
		data cAuthor
		data cKeyWords
		data cDesc
		data cCategory
		data cManager
		data cCompany
		data cHyperLink
		
		method New() CONSTRUCTOR

endclass

method New() class TXLSProp
	::cTitulo	 := ""
	::cSubject	 := EXCEL_PROP_SUBJECT
	::cAuthor	 := EXCEL_PROP_AUTHOR
	::cKeyWords	 := ""
	::cDesc	 	 := ""
	::cCategory	 := ""
	::cManager	 := ""
	::cCompany	 := EXCEL_PROP_COMPANY
	::cHyperLink := ""               

return Self              

/*================================================================================+
| Classe TExcelCLS																  |
+================================================================================*/

class TExcelCLS             
      LOCAL:
		data nHandle
		data cFileName             
		data aWrkSht
		data lHdrWrited   
		data nWrkShtIdx
		data nNumSeq    
		data aStyles
		data oProp

		method WriteHdr()
		method JoinStyles()
		method WrtStyles()

	  PUBLIC:
		method New() CONSTRUCTOR
		method IsOpen()
		method Create(cFileName)
		method Close()
		method AddWrkSheet(cHeader,nRowFreeze,nHeightHdr,nHeightRow,nHeaders,cPgHeader,cPgFooter,nPgOrienta,nPrtScale,nMgrHeader,nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,lHidden,cLinRepSup,cColRepEsq,nStyles,nColFreeze)
		method AddStyle(cCodigo, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,bGetNumSeq,lTrimSpc,cTipo,nDecimais)
		method AddStyleFrom(cCodigo,xStyle)
		method GetStyle(cCodigo)
		method SetWrkSht(nIndex)
		method NextWrkSht()
		method GetWrkSheet()
		method IsWrkSheet()
		method IdxWrkSheet()
		method MaxWrkSheet()
		method GetProp()
		method Free()
		method GetNumSeq()
endclass

method New() class TExcelCLS
	::cFileName	 := ""              
	::nHandle	 := 0
	::aWrkSht	 := {}
	::lHdrWrited := .F.
	::nWrkShtIdx := 0
	::nNumSeq	 := 0
	
	::aStyles	 := {}
	
	::oProp		 := TXLSProp():New()
return Self

method IsOpen() class TExcelCLS
return (::nHandle > 0)

method Create(cFileName) class TExcelCLS
	::nHandle := MSFCreate(cFilename)
return (::nHandle > 0)

method Close() class TExcelCLS
	Local lRet := .F.
	Local cBuffer

	If ::IsOpen()
		If ::IsWrkSheet()
			::GetWrkSheet():Free()	
		EndIf        

		cBuffer := '</Workbook>'+NEW_LINE

		lRet := (FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))

		lRet := ( FClose(::nHandle) .And. lRet )

		::nHandle := 0
	EndIf	
return lRet                     

method GetProp() class TExcelCLS
return ::oProp

method Free() class TExcelCLS
	::Close()
return

method AddWrkSheet(cHeader,nRowFreeze,nHeightHdr,nHeightRow,nHeaders,cPgHeader,cPgFooter,nPgOrienta,nPrtScale,nMgrHeader,nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,lHidden,cLinRepSup,cColRepEsq,nStyles,nColFreeze) class TExcelCLS
	If !::lHdrWrited
		cHeader   := AllTrim(cHeader)
	
		AAdd(::aWrkSht,TXLSWrkSht():New(Len(::aWrkSht)+1,cHeader,nRowFreeze,::nHandle,{|| Self:WriteHdr() },{|| Self:GetNumSeq() },nHeightHdr,nHeightRow,nHeaders,cPgHeader,cPgFooter,nPgOrienta,nPrtScale,nMgrHeader,nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,lHidden,cLinRepSup,cColRepEsq,{|cCodStyle| Self:GetStyle(cCodStyle) },nStyles,nColFreeze) )
		::nWrkShtIdx := Len(::aWrkSht)
	EndIf
return IIf(::lHdrWrited,Atail(::aWrkSht),NIL)
                  
method AddStyle(cCodigo, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,lTrimSpc,cTipo,nDecimais) class TExcelCLS
	Default cCodigo := ::GetNumSeq()

	cCodigo:=Upper(AllTrim(cCodigo))       
	
	Default cFormat := U_XLSFmtDef(cTipo,nDecimais)
	
	AAdd(::aStyles, TXLSStyle():New(cCodigo, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,{|| Self:GetNumSeq() },lTrimSpc))
return ATail(::aStyles)

method AddStyleFrom(cCodigo, xStyle, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,lTrimSpc,cTipo,nDecimais) class TExcelCLS
	Local oStyle 
	Local nBorder
	
	If ValType(xStyle) == "O"
		oStyle := xStyle
	Else	
		oStyle := ::GetStyle(xStyle)
	Endif
	
	Default nAlignV		:= oStyle:nAlignV
	Default nAlignH     := oStyle:nAlignH
	Default lLocked     := oStyle:lLocked
	Default lHidden     := oStyle:lHidden
	Default lWrapText   := oStyle:lWrapText
	Default xColor      := oStyle:xColor
	Default lTrimSpc    := oStyle:lTrimSpc
	
	::AddStyle(cCodigo, oFont, cFormat, nAlignV, nAlignH, lLocked, lHidden, lWrapText, nMskBorder,xColor,lTrimSpc,cTipo,nDecimais)
	
	If oFont==NIL
		oFont := ATail(::aStyles):GetFont()
	
		oFont:cFontName := oStyle:GetFont():cFontName
		oFont:xColor 	:= oStyle:GetFont():xColor
		oFont:nSize     := oStyle:GetFont():nSize
		oFont:nHeight   := oStyle:GetFont():nHeight
		oFont:nAttrib   := oStyle:GetFont():nAttrib
		oFont:nAlignV   := oStyle:GetFont():nAlignV
	EndIf
	
	If cFormat==NIL .And. cTipo==NIL .And. nDecimais==NIL
	     ATail(::aStyles):cFormat := oStyle:cFormat
	EndIf

	If nMskBorder == NIL
		For nBorder := XLS_BORDER_LEFT TO XLS_BORDER_BOTTOM
		     ATail(::aStyles):aBorder[nBorder]:lVisible := oStyle:aBorder[nBorder]:lVisible
		Next
	EndIf
	
return ATail(::aStyles)

method GetStyle(xCodigo) class TExcelCLS
	Local nPos
	Local oRet
	
	If !Empty(xCodigo)            
		If ValType(xCodigo)=='C'
			xCodigo:=Upper(AllTrim(xCodigo))

			nPos:=aScan(::aStyles,{|oObj| oObj:cCodigo==xCodigo } )
		Else
			nPos := xCodigo
		EndIf			
		
		If nPos > 0          
			oRet := ::aStyles[nPos]
		EndIf
	EndIf
return oRet

method SetWrkSht(nIndex) class TExcelCLS   
	Local lRet := .F.   
	If nIndex > 0 .And. nIndex <= Len(::aWrkSht) .And. !::lHdrWrited
		::nWrkShtIdx := nIndex	
		lRet := .T.
	EndIf
return lRet

method NextWrkSht() class TExcelCLS      
	If ::nWrkShtIdx > 0 .And. ::lHdrWrited
		::GetWrkSheet():Free()
	EndIf
	
	If ::nWrkShtIdx <= Len(::aWrkSht)
		::nWrkShtIdx++
	EndIf
return ::GetWrkSheet()

method GetWrkSheet() class TExcelCLS
return IIf(::nWrkShtIdx == 0 .Or. ::nWrkShtIdx > Len(::aWrkSht),NIL,::aWrkSht[::nWrkShtIdx])

method IsWrkSheet() class TExcelCLS
return (::nWrkShtIdx > 0 .And. ::nWrkShtIdx <= Len(::aWrkSht))

method IdxWrkSheet() class TExcelCLS
return Len(::nWrkShtIdx)

method MaxWrkSheet() class TExcelCLS
return Len(::aWrkSht)

method WriteHdr() class TExcelCLS
	Local lRet := .T.
	Local cBuffer

	If ! ::lHdrWrited	
		cBuffer := '<?xml version="1.0"?>'+NEW_LINE
		cBuffer += '<?mso-application progid="Excel.Sheet"?>'+NEW_LINE
		cBuffer += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+NEW_LINE
		cBuffer += ' xmlns:o="urn:schemas-microsoft-com:office:office"'+NEW_LINE
		cBuffer += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+NEW_LINE
		cBuffer += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+NEW_LINE
		cBuffer += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+NEW_LINE

		cBuffer += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+NEW_LINE

		If !Empty(::oProp:cTitulo)
			cBuffer += '<Title>'+U_OemToUTF8(::oProp:cTitulo,.T.)+'</Title>'+NEW_LINE
		EndIf
		
		If !Empty(::oProp:cSubject)
			cBuffer += '<Subject>'+U_OemToUTF8(::oProp:cSubject,.T.)+'</Subject>'+NEW_LINE
		EndIf       
		
		If !Empty(::oProp:cAuthor)
			cBuffer += '<Author>'+U_OemToUTF8(::oProp:cAuthor,.T.)+'</Author>'+NEW_LINE
		EndIf
		
		If !Empty(::oProp:cKeyWords)
			cBuffer += '<Keywords>'+U_OemToUTF8(::oProp:cKeyWords,.T.)+'</Keywords>'+NEW_LINE
		EndIf
		
		If !Empty(::oProp:cDesc)
			cBuffer += '<Description>'+U_OemToUTF8(::oProp:cDesc,.T.)+'</Description>'+NEW_LINE
		EndIf
		
		cBuffer += '<LastSaved>'+U_XLSDTime()+'</LastSaved>'+NEW_LINE
//		cBuffer += '<LastPrinted>2007-12-14T18:20:33Z</LastPrinted>'+NEW_LINE

		If !Empty(::oProp:cCategory)
			cBuffer += '<Category>'+U_OemToUTF8(::oProp:cCategory,.T.)+'</Category>'+NEW_LINE
		EndIf
		
		If !Empty(::oProp:cManager)
			cBuffer += '<Manager>'+U_OemToUTF8(::oProp:cManager,.T.)+'</Manager>'+NEW_LINE
		EndIf
		
		If !Empty(::oProp:cCompany)
			cBuffer += '<Company>'+U_OemToUTF8(::oProp:cCompany,.T.)+'</Company>'+NEW_LINE
		EndIf
		
		If !Empty(::oProp:cHyperLink)
			cBuffer += '<HyperlinkBase>'+U_OemToUTF8(::oProp:cHyperLink,.T.)+'</HyperlinkBase>'+NEW_LINE
		EndIf
		
		cBuffer += ' <Version>11.8107</Version>'+NEW_LINE
		cBuffer += '</DocumentProperties>'+NEW_LINE

		cBuffer += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+NEW_LINE
		cBuffer += '  <WindowHeight>10005</WindowHeight>'+NEW_LINE
		cBuffer += '  <WindowWidth>10005</WindowWidth>'+NEW_LINE
		cBuffer += '  <WindowTopX>120</WindowTopX>'+NEW_LINE
		cBuffer += '  <WindowTopY>135</WindowTopY>'+NEW_LINE
		cBuffer += '  <ProtectStructure>False</ProtectStructure>'+NEW_LINE
		cBuffer += '  <ProtectWindows>False</ProtectWindows>'+NEW_LINE
		cBuffer += '</ExcelWorkbook>'+NEW_LINE

		cBuffer += '<Styles>'+NEW_LINE
		cBuffer += '  <Style ss:ID="Default" ss:Name="Normal">'+NEW_LINE
		cBuffer += '   <Alignment ss:Vertical="Bottom"/>'+NEW_LINE
		cBuffer += '   <Borders/>'+NEW_LINE
		cBuffer += '   <Font/>'+NEW_LINE
		cBuffer += '   <Interior/>'+NEW_LINE
		cBuffer += '   <NumberFormat/>'+NEW_LINE
		cBuffer += '   <Protection/>'+NEW_LINE
		cBuffer += '  </Style>'+NEW_LINE
		
		lRet:=(FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))
		
		If lRet
			lRet := ::WrtStyles()
		EndIf

		If lRet
			cBuffer := '</Styles>'+NEW_LINE
			lRet:=(FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer))
		EndIf
		
 		::lHdrWrited := .T.
	EndIf

return lRet    

method JoinStyles() class TExcelCLS
	Local nWrkSheet      
	Local nCol         
	Local nCt       
	Local cBuffer
	Local aStyles := {}
	Local nIndex

	For nCol :=	1 To Len(::aStyles)
		cBuffer := GetStyleSt(::aStyles[nCol],.F.) 

		nIndex := AScan( aStyles,{|aItem| aItem[2]==cBuffer } )
		If nIndex == 0
			AAdd( aStyles, { ::aStyles[nCol]:GetCodInt(), cBuffer } )
		Else
			::aStyles[nCol]:SetCodInt(aStyles[nIndex][1])		
			::aStyles[nCol]:lWrite := .F.
		EndIf
	Next

	For nWrkSheet:=1 To Len(::aWrkSht)  
		For nCol :=	1 To ::aWrkSht[nWrkSheet]:MaxCols()
			cBuffer := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleHdr,.F.) 

			nIndex := AScan( aStyles,{|aItem| aItem[2]==cBuffer } )
			If nIndex == 0
				AAdd( aStyles, { ::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleHdr:GetCodInt(), cBuffer } )
			Else
				::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleHdr:SetCodInt(aStyles[nIndex][1])		
				::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleHdr:lWrite := .F.
			EndIf
		
			cBuffer := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleCol,.F.) 
			nIndex := AScan( aStyles,{|aItem| aItem[2]==cBuffer } )
			If nIndex == 0
				AAdd( aStyles, { ::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleCol:GetCodInt(), cBuffer } )
			Else
				::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleCol:SetCodInt(aStyles[nIndex][1])		
				::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleCol:lWrite := .F.
			EndIf

			cBuffer := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleTot,.F.) 
			nIndex := AScan( aStyles,{|aItem| aItem[2]==cBuffer } )
			If nIndex == 0
				AAdd( aStyles, { ::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleTot:GetCodInt(), cBuffer } )
			Else
				::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleTot:SetCodInt(aStyles[nIndex][1])		
				::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleTot:lWrite := .F.
			EndIf

			For nCt :=	1 To ::aWrkSht[nWrkSheet]:GetColumn(nCol):QtdStyles()
				cBuffer := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):GetStyle(nCt),.F.) 
   	
				nIndex := AScan( aStyles,{|aItem| aItem[2]==cBuffer } )
				If nIndex == 0
					AAdd( aStyles, { ::aWrkSht[nWrkSheet]:GetColumn(nCol):GetStyle(nCt):GetCodInt(), cBuffer } )
				Else
					::aWrkSht[nWrkSheet]:GetColumn(nCol):GetStyle(nCt):SetCodInt(aStyles[nIndex][1])		
					::aWrkSht[nWrkSheet]:GetColumn(nCol):GetStyle(nCt):lWrite := .F.
				EndIf
			Next
		Next
	Next
return

method WrtStyles() class TExcelCLS
	Local nWrkSheet      
	Local nCol                
	Local nCt
	Local cBuffer := ""    
	Local cStyle 
	Local aStyles := {}

	::JoinStyles()

	For nCol :=	1 To Len(::aStyles)         
		If ::aStyles[nCol]:lWrite
			cStyle := GetStyleSt(::aStyles[nCol]) 

			cBuffer += cStyle 
		EndIf
	Next

	For nWrkSheet:=1 To Len(::aWrkSht)  
		For nCol :=	1 To ::aWrkSht[nWrkSheet]:MaxCols()
			If ::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleHdr:lWrite
				cStyle := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleHdr) 

				If AScan( aStyles,{|cItem| cItem==cStyle } ) == 0                         
					cBuffer += cStyle 
					AAdd( aStyles, cStyle )
				EndIf
			Endif
		
			If ::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleCol:lWrite
				cStyle := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleCol) 

				If AScan( aStyles,{|cItem| cItem==cStyle } ) == 0                         
					cBuffer += cStyle 
					AAdd( aStyles, cStyle )
				EndIf
			EndIf

			If ::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleTot:lWrite
				cStyle := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):oStyleTot) 

				If AScan( aStyles,{|cItem| cItem==cStyle } ) == 0                         
					cBuffer += cStyle 
					AAdd( aStyles, cStyle )
				EndIf
			Endif

			For nCt :=	1 To ::aWrkSht[nWrkSheet]:GetColumn(nCol):QtdStyles()
				If ::aWrkSht[nWrkSheet]:GetColumn(nCol):GetStyle(nCt):lWrite
					cStyle := GetStyleSt(::aWrkSht[nWrkSheet]:GetColumn(nCol):GetStyle(nCt)) 
					
					If AScan( aStyles,{|cItem| cItem==cStyle } ) == 0                         
						cBuffer += cStyle 
						AAdd( aStyles, cStyle )
					EndIf
				EndIf
			Next
		Next
	Next
return (IIF(Empty(cBuffer),.T.,FWrite(::nHandle,cBuffer,Len(cBuffer))==Len(cBuffer)))

method GetNumSeq() class TExcelCLS
	::nNumSeq++
return "@S"+AllTrim(Str(::nNumSeq))
