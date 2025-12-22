#include 'totvs.ch'


User Function AAMNTR2X()
    MsApp():New('SIGAEST') 
    oApp:CreateEnv()
    PtSetTheme("SUNSET")
    //u_AAFINR01("1","000046348",,.T.) 
    //u_AAFINR01()
    //Define o programa de inicialização 
    oApp:cStartProg    := 'U_AAMNTR1X'
    //oApp:cStartProg    := 'U_IPFATP4D'
 
    //Seta Atributos 
    __lInternet := .T.
    /*
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",{|| RpcSetEnv("01","01") }),;
        u_LjKeyF8(),;
        Final("TERMINO NORMAL")}
        */
     //u_AAFATE14("500","000000016"),;
    //Seta Atributos 
    //__lInternet := .T.
    //lMsFinalAuto := .F.
    //oApp:lMessageBar:= .T. 
    //oApp:cModDesc:= 'SIGATST'
     
    //Inicia a Janela 
    oApp:Activate()
Return 

User Function AAMNTR1X()
 //RpcSetEnv('01','01',,,,,{"STJ"})
 STJ->(dbSetOrder(1))
 STJ->(dbSeek(xFilial('STJ') + '000066'))
 U_AAMNTR01()
Return 

User Function AAMNTR01()
Local xOS  := ''
Local xChamado := ''
Local xEntrega := ''
Local xAtendimento := ''
LOcal xLinha := ''
Local xEqp := ''
Local xdata := ''
Local cJson := ''
Local xBase64 := ''
Local xJson := JsonObject():New()

//Local xUrl := "http://192.168.1.8:8088/z/#/os/os?da=xDATA&os=XOS&hchamado=XHC&hentrega=XHE&hatendimento=XHA&linha=XL&equipamento=XE&data=XD"
//Local xUrl := "http://192.168.1.8:8088/z/#/os/os?da=xDATA"
//Local xUrl := "http://10.1.108.226:8080/#/os/os?da=xDATA"
Local xUrl := "http://192.168.1.8:8088/z/#/os/raf?da="+xData

xOS  := STJ->TJ_ORDEM
xEqp := STJ->TJ_CODBEM + Posicione('ST9',1,xFilial('ST9') + STJ->TJ_CODBEM,'T9_NOME')
xData := DTOC(STJ->TJ_DTORIGI)
xLinha := STJ->TJ_CODAREA + '-' + Alltrim(Posicione('STD',1,xFilial('STD') + STJ->TJ_CODAREA, 'TD_NOME')) //tj_codarea + tj_nomarea
xChamado := STJ->TJ_HOMPINI
xAtendimento := STJ->TJ_HOPRINI
xEntrega := STJ->TJ_HOPRFIM
xServico := STJ->TJ_SERVICO + '-' + Alltrim(Posicione('ST4',1,xFilial('ST4') + STJ->TJ_SERVICO,'T4_NOME'))
xDescAt  := STJ->TJ_OBSERVA// T4// tj_observa
xAnalise := iIF( STJ->(FieldPos("TJ_XANALI"))>0 ,STJ->TJ_XANALI,"Demo"+Chr(13)+Chr(10)+"Demo2")

xFWTemporaryTableJson["OS"] := xOS
xJson["CHAMADO"] := xChamado
xJson["ENTREGA"] := xEntrega
xJson["HATENDIMENTO"] := xAtendimento
xJson["EQUIPAMENTO"] := xEqp
xJson["XDATA"] := xData
xJson["LINHA"] := xLinha
xJson["SERVICO"] := xServico
xJson["ATENDIMENTO"] := xDescAt
xJson["ANALISE"] := xAnalise
xJson["MOD"] := {}
xJson["PECAS"] := {}

STL->(dbSetOrder(1))
STL->(dbSeek(xFilial('STL') + STJ->TJ_ORDEM))
while xFilial('STL') + STJ->TJ_ORDEM == STL->TL_FILIAL + STL->TL_ORDEM
   If STL->TL_TIPOREG == 'M'
      aAdd( xJson["MOD"], JsonObject():New() )
      nP := Len(xJson["MOD"])
      xJson["MOD"][nP]["NOME"] := STL->TL_CODIGO + '-' + Alltrim(Posicione('ST1',1,xFilial('ST1') + STL->TL_CODIGO,'T1_NOME') )
      xJson["MOD"][nP]["DINICIO"] := STL->TL_HOINICI
      xJson["MOD"][nP]["DFIM"] := STL->TL_HOFIM
   ElseIf STL->TL_TIPOREG == 'P'
      aAdd( xJson["PECAS"], JsonObject():New() )
      nT := Len(xJson["PECAS"])
      xJson["PECAS"][nT]["PRODUTO"] := STL->TL_CODIGO+'-'+Posicione('SB1',1,xFilial('SB1') + STL->TL_CODIGO ,'B1_DESC')
      xJson["PECAS"][nT]["QUANT"] := STL->TL_QUANTID
   EndIf
   STL->(dbSkip())
EndDo

cJson := xJson:ToJson()
xBase64 := Encode64(cJson)

xUrl := StrTran(xUrl,'XOS',xOS)
xUrl := StrTran(xUrl,'XHC',xChamado)
xUrl := StrTran(xUrl,'XHE',xEntrega)
xUrl := StrTran(xUrl,'XHA',xAtendimento)
xUrl := StrTran(xUrl,'XL',xLinha)
xUrl := StrTran(xUrl,'XE',xEqp)
xUrl := StrTran(xUrl,'XD',xdata)
xUrl := StrTran(xUrl,'xDATA',xBase64)

ShellExecute("open",xUrl,"","",5)

Return Nil
