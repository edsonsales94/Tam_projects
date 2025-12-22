#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณW04PStyle บ Autor ณ Diego Rafael       บ Data ณ  12/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo de formata็ao dos formulแrios                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function INCOMWST(lTipo)
   Local cEstilo
  cEstilo := '<style type="text/css" title="mystyles" media="all">
  cEstilo += '#table {
  cEstilo += '	VISIBILITY: visible; WIDTH: 100%; POSITION: relative
  cEstilo += '}
  cEstilo += '#table TABLE {
  cEstilo += '	FONT-SIZE: 12px; FONT-FAMILY: Verdana, Geneva, Arial, sans-serif; BACKGROUND-COLOR: transparent
  cEstilo += '}
  cEstilo += '#table TD {
  cEstilo += '	BORDER-RIGHT: #999 1px dotted; PADDING-RIGHT: 4px; BORDER-TOP: #999 1px; PADDING-LEFT: 4px; PADDING-BOTTOM: 0px; BORDER-LEFT: #999 1px; PADDING-TOP: 0px; BORDER-BOTTOM: #999 1px solid; BACKGROUND-COLOR: #f5faf5; TEXT-ALIGN: left
  cEstilo += '}
  cEstilo += '#table TH {
  cEstilo += '	BORDER-RIGHT: #999 1px dotted; PADDING-RIGHT: 4px; BORDER-TOP: #999 1px; PADDING-LEFT: 4px; PADDING-BOTTOM: 0px; BORDER-LEFT: #999 1px; PADDING-TOP: 0px; BORDER-BOTTOM: #999 1px solid; BACKGROUND-COLOR: #d5ddd5; TEXT-ALIGN: left
  cEstilo += '}
  cEstilo += '#typein { }
  cEstilo += '#typein input { 
  cEstilo += 'color: #633; 
  cEstilo += 'font-size: 12px; 
  If lTipo
    cEstilo += 'background-color: #ebebd9; 
  EndIf  
  cEstilo += 'padding: 3px; 
  cEstilo += '}     
  cEstilo += '#typein textarea { 
  cEstilo += 'color: #633;font-size: 12px; 
  If lTipo
    cEstilo += 'background-color: #ebebd9; 
  EndIf  
  cEstilo += 'padding: 3px; 
  cEstilo += '}

  cEstilo += 'body {
  cEstilo += '  color: #5d665b;
  cEstilo += '  font-size: small;
  cEstilo += '  font-family: Verdana, Geneva, Arial, sans-serif;
  cEstilo += '  background-color: #e8eae8;
  cEstilo += '   }
  cEstilo += '</style>
Return cEstilo                              
               
