#include 'totvs.ch'

User Function AAMNTR02()
  Local x := 0
  Local xJson := JsonObject():New()
  Local xDd := "eyJYREFUQSI6IjE0LzA2LzIwMjEiLCJMSU5IQSI6IjAwMDAwNC1CTE9DTyBEIiwiT1MiOiIwMDAwNjYiLCJQRUNBUyI6W3siUVVBTlQiOjIsIlBST0RVVE8iOiI3MDAwNDUxNyAgICAgICAtUk9MQU1FTlRPIE5KIDIwNyBTS0YgRElNMzUvNzJYMTcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAifSx7IlFVQU5UIjoyLCJQUk9EVVRPIjoiNzAwMDQ1MTcgICAgICAgLVJPTEFNRU5UTyBOSiAyMDcgU0tGIERJTTM1LzcyWDE3ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIn0seyJRVUFOVCI6MiwiUFJPRFVUTyI6IjcwMDA2MTA3ICAgICAgIC1NQU5DQUwgRkwtMjA3IFAvIFJPTEFNRU5UTyAyIEZVUk9TICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJ9LHsiUVVBTlQiOjIsIlBST0RVVE8iOiI3MDAwNjEwNyAgICAgICAtTUFOQ0FMIEZMLTIwNyBQLyBST0xBTUVOVE8gMiBGVVJPUyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAifV0sIkNIQU1BRE8iOiIxMToxMSIsIkhBVEVORElNRU5UTyI6IjEyOjIwIiwiRU5UUkVHQSI6IjEzOjIwIiwiRVFVSVBBTUVOVE8iOiJGVEIwMDUwMDMgICAgICAgIiwiTU9EIjpbeyJOT01FIjoiMDAyNTQ0ICAgICAgICAgLVZBTkRFUk5JTFNPTiBBUkFHQU8gREUgQVJBVUpPIiwiREZJTSI6IjEyOjExIiwiRElOSUNJTyI6IjExOjExIn0seyJOT01FIjoiMDAyNTQ0ICAgICAgICAgLVZBTkRFUk5JTFNPTiBBUkFHQU8gREUgQVJBVUpPIiwiREZJTSI6IjEzOjIwIiwiRElOSUNJTyI6IjEyOjIwIn0seyJOT01FIjoiMDAyNjUxICAgICAgICAgLUdVSUxIRVJNRSBNQVJDT05JIEZFUlJFSVJBIENPUiIsIkRGSU0iOiIxMjoxMSIsIkRJTklDSU8iOiIxMToxMSJ9LHsiTk9NRSI6IjAwMjY1MSAgICAgICAgIC1HVUlMSEVSTUUgTUFSQ09OSSBGRVJSRUlSQSBDT1IiLCJERklNIjoiMTM6MjAiLCJESU5JQ0lPIjoiMTI6MDAifV0sIlNFUlZJQ08iOiIwMDAxNjItTUFOVVRFTkNBTyBNRUNBTklDQSBGTE9PUCIsIkFOQUxJU0UiOiJEZW1vXHJcbkRlbW8yIiwiQVRFTkRJTUVOVE8iOiJSRVBPU0nDh8ODTyBETyBST0xPIFZFUlRJQ0FMIEUgVFJPQ0EgREUgTUFOQ0FJUyBFIFJPTEFNRU5UT1MuXHJcblxyXG5UUkFCQUxITyBSRUFMSVpBRE8gTkEgSE9SQSBETyBBTE1Pw4dPLiJ9"
  RpcSetEnv('01','01')
  //SendMail("000071",xDd)

  xTbl := MpSysOpenQUery('exec KODIGOS_OSRAF')
  While !(xTbl)->(Eof())
     xVlr :=  (xTbl)->TJ_ORDEM

     STJ->(dbSetOrder(1))     
     If STJ->(dbSeek(xFilial('STJ') + (xTbl)->TJ_ORDEM ))

        xJson := JsonObject():New()
        xOS  := STJ->TJ_ORDEM
        xEqp := Alltrim(STJ->TJ_CODBEM) + ' - ' + Alltrim(Posicione('ST9',1,xFilial('ST9') + STJ->TJ_CODBEM,'T9_NOME'))
        xData := DTOC(STJ->TJ_DTORIGI)
        xLinha := Alltrim(STJ->TJ_CODAREA) + ' - ' + Alltrim(Posicione('STD',1,xFilial('STD') + STJ->TJ_CODAREA, 'TD_NOME')) //tj_codarea + tj_nomarea
        xChamado := STJ->TJ_HOMPINI
        xAtendimento := STJ->TJ_HOPRINI
        xEntrega := STJ->TJ_HOPRFIM
        xServico := Alltrim(STJ->TJ_SERVICO) + ' - ' + Alltrim(Posicione('ST4',1,xFilial('ST4') + STJ->TJ_SERVICO,'T4_NOME'))
        xDescAt  := Alltrim(STJ->TJ_OBSERVA)// T4// tj_observa
        //xAnalise := iIF( STJ->(FieldPos("TJ_XANALI"))>0 ,STJ->TJ_XANALI,"Demo"+Chr(13)+Chr(10)+"Demo2")
        
        xJson["OS"] := xOS
        xJson["CHAMADO"] := xChamado
        xJson["ENTREGA"] := xEntrega
        xJson["HATENDIMENTO"] := xAtendimento
        xJson["EQUIPAMENTO"] := xEqp
        xJson["XDATA"] := xData
        xJson["LINHA"] := xLinha
        xJson["SERVICO"] := xServico
        xJson["ATENDIMENTO"] := xDescAt
        
        cJson := xJson:ToJson()
        xBase64 := Encode64(cJson)
        if SendMail(xOS,xBase64) //xJson["ANALISE"] := xAnalise
           STJ->(RecLock('STJ',.F.))
             STJ->TJ_VALATF = 'S'
           STJ->(MsUnlock())
        EndIf

     Endif

     (xTbl)->(dbSkip())
  EndDo

Return Nil
Static Function SendMail( xNUmOs,xData)

  //Local xLink := "http://10.1.108.226:8080/#/os/raf?raf="+xData
  Local xLink := "http://192.168.1.8:8088/z/#/os/raf?raf="+xData
  Local lSucesso := .F.
  Local xEmail := GetMv("MV_XRELRAF",.F.,"")+";raphael.rage@kodigos.com.br;diego.fael@gmail.com"
  
  /*
  [15:10, 03/08/2021] Raphael: geimes.lima@amazonaco.com.br
  [15:10, 03/08/2021] Raphael: alpair.lima@amazonaco.com.br
  [15:11, 03/08/2021] Raphael: gabriel.bastos@amazonaco.com.br
  */

  cModelo  := "\web\Modelos\raf-link.html"
  _odEmail := odEmail():New(cModelo)

  _odEmail:SetAssunto("RAF - OS: " + xNumOs)
	_odEmail:setTo(xEmail)
  _odEmail:ValByName('xdORDEM',xNUmOs)
  _odEmail:ValByName('xdLINK',xLink)
  _xdRet := _odEmail:ConectServer()

  If !Empty(_xdRet)
		If !isBlind()
			Aviso('',_xdRet,{'OK'})
		Else
			Conout(_xdRet)
		EndIf
	Endif

	If Empty(_xdRet)
		_xdRet := _odEmail:SendMail()
		If !Empty(_xdRet)
      lSucesso = _xdRet == "[SEND] Sucess to send message"
			If !isBlind()
				Aviso('',_xdRet,{'OK'})
			Else
				Conout(_xdRet)
			EndIf
    else
      lSucesso = .T.
		EndIf
	EndIf
  
Return lSucesso
