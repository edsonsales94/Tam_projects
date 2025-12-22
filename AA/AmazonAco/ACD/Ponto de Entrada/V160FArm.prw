#include 'protheus.ch'
#include 'parmtype.ch'

user function ACD060CF()
   cJson := "{"
   
   //aDist := {}
   //aadd(aDist,{"teste11","teste12","teste13","teste14",{{ "teste1511", "teste1512"},{ "teste1521", "teste1522"}},"teste16","teste17","teste18"})
   //aadd(aDist,{"teste21","teste22","teste23","teste24",{{ "teste2511", "teste2512"},{ "teste2521", "teste2522"}},"teste26","teste27","teste28"})
   //aadd(aDist,{"teste31","teste32","teste33","teste34",{{ "teste3511", "teste3512"},{ "teste3521", "teste3522"}},"teste36","teste37","teste38"})
   cId := "["+cUserName + "][" + DTOS(ddatabase) + "][" + Time() + "]"
   
   cSql  := " INSERT INTO ADIST(CID,LINHA,POS01,POS02,POS03,POS04,POS05,POS06,POS07,POS08) "
   cSql5 := " INSERT INTO ADISTX5(CID,CLINHA,LINHA,POS01,POS02) "
             
   For _nX := 01 To Len(aDist)
       
       cExec := cSql + " Values( "
       cExec += '"' + cId + '",'
       cExec += '"' + StrZero(_nX,3) + '",'
       cExec += '"' + ConvType(aDist[_nX][01],30) + '",'
       cExec += '"' + ConvType(aDist[_nX][02],30) + '",'
       cExec += '"' + ConvType(aDist[_nX][03],30) + '",'
       cExec += '"' + ConvType(aDist[_nX][04],30) + '",'
       cExec += '"5",'
       cExec += '"' + ConvType(aDist[_nX][06],30) + '",'
       cExec += '"' + ConvType(aDist[_nX][07],30) + '",'
       cExec += '"' + ConvType(aDist[_nX][08],30) + '" ) '
       
       For _nY := 01 To Len(aDist[_nX][05])
           
           cExec05 := cSql5 + " Values ( "
           cExec05 += '"' + cId + '",'
           cExec05 += '"' + StrZero(_nX,3) + '",'
           cExec05 += '"' + StrZero(_nY,3) + '",'
           cExec05 += '"' + ConvType(aDist[_nX][05][_nY][01],30) + '",'
           cExec05 += '"' + ConvType(aDist[_nX][05][_nY][02],30) + '")'
                               
           tcSqlExec(cExec05)
       Next
       
       tcSqlExec(cExec)
   Next
      
return Nil

Static Function ConvType(xValor,nTam,nDec)

Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)