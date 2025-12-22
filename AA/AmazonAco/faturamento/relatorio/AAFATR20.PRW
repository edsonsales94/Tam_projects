#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#include "AP5MAIL.ch"
#include "tbiconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR20   ¦ Autor ¦ Adson Carlos           ¦ Data ¦ 01/02/20 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de Lista de Separação V2.0                       	  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function AAFATR20(_cdPedido,_cdFilial)

SetPrvt("ARETURN,NPAG,LI,TOTPAGINA,DESCPAGINA,TOTGERAL")
SetPrvt("DESCITEM,DESCTOTAL,FORMA,NLASTKEY")

Default _cdPedido := ""
Default _cdFilial := ""
Private _cdPed := _cdPedido
Private _cdFil := _cdFilial
Private lContinuo := .F.

nQtdLin := 1

Processa({|lEnd|MontaRel()})

Return Nil


/*----------------------------------------------------------------------------------------------*

*----------------------------------------------------------------------------------------------*/
Static Function MontaRel()
Local    oPrint  := Nil
Local    _cxNum  := ""
Private cPerg    := Padr("AA_FATR01", Len(SX1->X1_GRUPO) )
Private nTotal 	 := 0
Private  nTotReg := 0

Pergunte(cPerg,.T.)

fTabTmp()
If TRB->(EOF())
	MsgStop("Não há dados a serem  exibidos!")
	TRB->(dbCloseArea("TRB"))
	Return Nil
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(SC5->(Xfilial("SC5"))+TRB->C5_NUM)

_cxNum  := xfilial("SC5")+Alltrim(SC5->C5_NUM)
_cxMail := ALLTRIM(POSICIONE('SA3',1,XFILIAL("SA3")+SC5->C5_VEND1,'A3_EMAIL') )
cArq:=Alltrim("lista"+xfilial("SC5")+Alltrim(TRB->C5_NUM))
oPrint := FWMSPrinter():New(cArq,, .T.,"\listas\" , .T., , , , , , .F., )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()
oPrint:SetDevice(IMP_PDF)
oPrint:SetResolution(72)
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(0,0,0,0)
oPrint:cPathPDF := "\listas\"
oPrint:lServer := .F.
oPrint:SetViewPDF(.T.)

Impress(oPrint)

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

sleep(1200)


u_AAFSEMAIL(_cxMail,"Lista de Separação"+_cxNum,"<b>Segue lista de Separacao <b>","\listas\"+cArq+".pdf")

Return nil


Static Function Impress(oPrint)
Private oFont7   := TFont():New("Arial"      ,9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont8   := TFont():New("Arial"      ,9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont9   := TFont():New("Arial"      ,9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12c := TFont():New("Courier New",9,11,.T.,.F.,5,.T.,5,.T.,.F.)

Private oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12  := TFont():New("Arial"      ,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont23  := TFont():New("Arial"      ,9,23,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont13n := TFont():New("Arial"      ,9,13,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont11n := TFont():New("Arial"      ,9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)
Private nwFim    := 2300
Private nwIni    := 100
Private nCol_1   := 250
Private nDif1    := 050
Private nDif2    := 010
Private lwFim    := .F.
Private nTotPage := 0 
Private nLin_Itens := 0
Private TotPagina  := 0
Private DescPagina := 0
Private nTotal1    := 0
Private nTotal2    := 0
Private nTotal3    := 0
Private nTotal4    := 0
Private TotGeral   := 0
Private DescTotal  := 0
Private _ndTotDesc := 0
Private _ndTotIcms := 0

If (nDif1*(nQtdLin+1)) + (25*nQtdLin)   > 2800
	MsgBox("Limite de Linhas Excedido!")
	Return Nil
EndIf

ProcRegua(nTotReg)


_cPedBlock := ""
nLin_Itens := 890//560// + nDif1
_ndNec := nTotReg*nDif1*(nQtdLin+1) + nDif2 * nTotReg
nTotPage := Int( ( (Int( _ndNec / (3000 - 600) ) + 1) * 600 + _ndNec + 1250 ) / 3000) + 1
//nTotPage   := Int((( 1250 + nTotReg*nDif1*(nQtdLin+1) + nDif2 * nTotReg  ) / 3000) + 1 )

_nPage  := 01
_xOPage := 00

//nEspaco := 100
nEspaco := 600
For _xd01 := 01 To nTotReg  
   
   if nEspaco + nDif1*(nQtdLin + 1) + nDif2 > 3000      
      nEspaco := 600
      _nPage++
   Else
      nEspaco += nDif1*(nQtdLin + 1) + nDif2 
   EndIf
Next

if nEspaco + 650 > 3000
   _nPage++
EndIf

nPag       := 1

DbSelectArea("SC5")
DbSetOrder(1)
lSkip := .F.
DbSeek(SC5->(Xfilial())+TRB->C5_NUM)

If SC5->C5_TIPO <> "N"
    Return
Endif


fwCabec(oPrint, nPag)

While !TRB->(EOF())
    lSkip := .F.
    If DbSeek(SC5->(Xfilial())+TRB->C5_NUM)
    
	IncProc("Pedido: " + SC5->C5_TIPO)
	
	fwItens(oPrint, nLin_Itens)
    endif
	
	TRB->(dbSkip())
EndDo

fwRodape(oPrint, nLin_Itens)
oPrint:EndPage()     // Finaliza a página

TRB->(dbCloseArea())

Return Nil

*----------------------------------------------------------------------------------------------*
Static Function fwCabec(oPrint, nPag)
*----------------------------------------------------------------------------------------------*
Local cLogo  := GetSrvProfString("StartPath","") + "LGMID1.PNG" //Logo da Amazon Aço
Local nTam1  := 400
Local aText1 := {"Código", "Revisão", "Data", "Pag."}
Local aText2 := {"SGQ-FOR-LOG-06", "00", "02/03/2017", AllTrim(Str(nPag))+"/"+AllTrim(Str(nTotPage)) }
Local nRow1  := 100

oPrint:Box(nRow1, nwIni      , nRow1+0680 , nWfim)  //Imprime o Box Superior
oPrint:Box(nRow1, nwIni      , nRow1+0200 , nWfim)  //Imprime o Box Superior
If File(cLogo)
	oPrint:SayBitmap(110, 110 , cLogo, 470, 160)
Endif

oPrint:Say  (nRow1+0080,700 ,ALLTRIM(SM0->M0_NOMECOM),oFont20,,,,2 )
oPrint:Say  (nRow1+0140,700 ,"LISTA DE SEPARACAO DO PEDIDO " + SC5->C5_FILIAL + "/" + SC5->C5_NUM + " ",oFont20,,,,2 )
oPrint:Say  (nRow1+0080,1800 ,"Data Emissao :" +DTOC(SC5->C5_EMISSAO)+"-"+Time(),oFont12,,,,2 ) 

SA1->(dbSetOrder(1))
SA1->(dbSeek( xFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJACLI ))
SA3->(dbSetOrder(1))
SA3->(dbSeek( XFILIAL("SA3")+SC5->C5_VEND1 ))
SE4->(dbSetOrder(1))
SE4->(dbSeek( XFILIAL("SE4")+SC5->C5_CONDPAG ))

oPrint:Say (nRow1+0250,0120,"Cliente  : "+AllTrim(SA1->A1_NOME) + "  ( " + AllTrim(SA1->A1_NREDUZ) + " )" ,oFont12 )
oPrint:Say  (nRow1+0250,1500,"Codigo   : "+AllTrim(SA1->A1_COD) + Space(1) + SA1->A1_LOJA, oFont12 )

oPrint:Say  (nRow1+0300,0120,"Endereco : "+Alltrim(Left(SA1->A1_END,50)),oFont12 )
oPrint:Say  (nRow1+0300,1500,"Bairro   : "+AllTrim(SA1->A1_BAIRRO),oFont12 )

oPrint:Say  (nRow1+0350,0120,"End. Ent.: "+Alltrim(Left(SC5->C5_ENDENT,50)),oFont12 )
oPrint:Say  (nRow1+0350,1500,"Bairro Ent.: "+AllTrim(SC5->C5_BAIRROE),oFont12 )

oPrint:Say  (nRow1+0400,0120,AllTrim ( "Munic./UF: "+ If( Empty(SC5->C5_MUNE), AllTrim(SA1->A1_MUN), SC5->C5_MUNE)  + " - " +If( Empty(SC5->C5_ESTE), AllTrim(SA1->A1_EST), SC5->C5_ESTE)  ),oFont12 )
oPrint:Say  (nRow1+0400,1500,AllTrim("Receptor: " + AllTrim(SC5->C5_RECENT) ),oFont12 )

oPrint:Say  (nRow1+0450,0120,"I.E. : " + SA1->A1_INSCR,oFont12 )
oPrint:Say  (nRow1+0450,0600,AllTrim("Referência: " + AllTrim(SC5->C5_REFEREN) ),oFont12 )

oPrint:Say  (nRow1+0500,0120,AllTrim("Telefone : "+If ( EmPty(SC5->C5_FONEENT), AllTrim(SA1->A1_TEL), AllTrim(SC5->C5_FONEENT) ) ),oFont12 )
oPrint:Say  (nRow1+0500,0600,AllTrim("Fax : "+SA1->A1_FAX ),oFont12 )
oPrint:Say  (nRow1+0500,1000,AllTrim("CNPF/CPF : "+AllTrim(SA1->A1_CGC)),oFont12 )
oPrint:Say  (nRow1+0500,1600,AllTrim("Entrega: " + If( SC5->C5_ENTREGA == "S", "SIM", "NÃO" )),oFont12 )

oPrint:Say  (nRow1+0550,0120,"C. Pagto :  " + If(ALLTRIM(SC5->C5_CONDPAG) == "CN","COND. NEGOCIADA",SC5->C5_CONDPAG + " - " + AllTrim(SE4->E4_DESCRI)),oFont12 )
oPrint:Say  (nRow1+0550,1000,"Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ),oFont12 )
oPrint:Say  (nRow1+0550,1600,"Receb. Local:" + If( SC5->C5_RECLOC == "S", "SIM", "NÃO" ),oFont12 )

oPrint:Say  (nRow1+0600,0120,"Observacoes: ",oFont12 )
oPrint:Say  (nRow1+0600,0400,SC5->C5_OBSENT1,oFont12 )
oPrint:Say  (nRow1+0650,0400,SC5->C5_OBSENT2,oFont12 )  
                            
oPrint:Box(nRow1+680, nwIni      , nRow1+740 , nWfim)  //Imprime o Box Superior
oPrint:Say  (nRow1+0720,120,"PRODUTO",oFont11N )
oPrint:Say  (nRow1+0720,350,"DESCRICAO",oFont11N )
oPrint:Say  (nRow1+0720,1350,"1.UM ",oFont11N )
oPrint:Say  (nRow1+0720,1450,"QTD 1.UM  ",oFont11N )
oPrint:Say  (nRow1+0720,1650," 2.UM  ",oFont11N )
oPrint:Say  (nRow1+0720,1750,"QTD 2.UM ",oFont11N )
oPrint:Say  (nRow1+0720,1950,"PRC UNI",oFont11N )
oPrint:Say  (nRow1+0720,2150,"TOTAL ",oFont11N )

Return 740

*----------------------------------------------------------------------------------------------*
Static Function fwItens(oPrint,nwRow )
*----------------------------------------------------------------------------------------------*
Local _nX := 0

aProd := aClone(U_AAGETFIS())

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(Xfilial()+TRB->C5_NUM)

SC9->(dbSetOrder(1))
_ndTotDesc := 0
While SC6->(!Eof()) .And. SC6->C6_NUM == TRB->C5_NUM

    
	If nwRow + nDif1*(nQtdLin + 1) + nDif2 > 3000
	    oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()
		nwRow := 800
		nPag++
		fwCabec(oPrint, nPag)
	EndIf
                            
    If SC6->C6_QTDVEN <= SC6->C6_QTDENT
        SC6->(dbSkip())
        Loop
    EndIf

    DbSelectArea("SB1")
    DbSetOrder(1)

    If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
        _ndQtdLib1 := SC6->C6_QTDVEN - SC6->C6_QTDENT //SC9->C9_QTDLIB
        _ndQtdLib2 := SC6->C6_UNSVEN - SC6->C6_QTDENT2 //SC9->C9_QTDLIB2
    
        nPrcUnit := If( SC6->C6_DESCONT == 0 , SC6->C6_PRCVEN, iIf(SC6->C6_PRUNIT==0, (SC6->C6_VALOR + SC6->C6_VALDESC) / SC6->C6_QTDVEN,SC6->C6_PRUNIT) )
        nTotal := nPrcUnit * _ndQtdLib1
    
        SC9->(dbSeek(xFilial('SC9') + SC6->(C6_NUM + C6_ITEM)))
    
        oPrint:Say  (nwRow + 00,120 ,SubStr(SB1->B1_COD,1,15),oFont11N )
        oPrint:Say  (nwRow + 00,350 ,SubStr(SB1->B1_ESPECIF,1,50),oFont11N )
        oPrint:Say  (nwRow + 00,1350 ,SC6->C6_UM,oFont11N )
        oPrint:Say  (nwRow + 00,1470 ,Transform(_ndQtdLib1,"@E   999,999.99"),oFont11N )
        oPrint:Say  (nwRow + 00,1650 ,SC6->C6_SEGUM,oFont11N )
        oPrint:Say  (nwRow + 00,1750 ,Alltrim( Transform(_ndQtdLib2,"@E   999,999.99") ),oFont11N )
    //	oPrint:Say  (nwRow + 00,800,,oFont11N )
        oPrint:Say  (nwRow + 00,1920,Alltrim( Transform(nPrcUnit      ,PesqPict("SL2","L2_VRUNIT",18,2)) ),oFont11N )
        oPrint:Say  (nwRow + 00,2150,Alltrim( Transform(nTotal        ,PesqPict("SL2","L2_VLRITEM",18,2)) ),oFont11N )
    //	oPrint:Say  (nwRow + 00,nWfim-170,"Total",oFont11N )
        
        nwRow += nDif1
        nLin_Itens := nwRow
   
        nTotal1    += _ndQtdLib1 * SB1->B1_PESO//SC6->C6_QTDLIB
        nTotal2    += _ndQtdLib2//SC6->C6_QTDLIB2
        nTotal3    += nPrcUnit
        nTotal4    += nTotal - SC6->C6_VALDESC
        _ndTotDesc += SC6->C6_VALDESC
        For nI := 1 to Len(aProd)
            If SC6->C6_PRODUTO == aProd[nI]
                _nX := nI
            EndIf
        Next
    
        If _nX > 0
            _ndTotIcms += MaFisRet(_nX,"IT_VALSOL")
        EndIf
    Endif

    SC6->(DbSkip())
EndDo

For nI := 1 to Len(aProd)
    MaFisDel(nI,.T.)
Next
MaFisWrite(1)
MaFisEnd()


Return Nil

*----------------------------------------------------------------------------------------------*
Static Function fwRodape(oPrint, nwRow )
*----------------------------------------------------------------------------------------------*

nwRow += 50
oPrint:Say  (nwRow,120,"Peso Total : "+AllTrim(Transform(nTotal1,"@E 999,999,999.99")),oFont11N )
oPrint:Say  (nwRow,550,"Total Valor Unit : "+AllTrim(Transform(nTotal3,"@E 999,999.99")),oFont11N )
oPrint:Say  (nwRow,1050,"Desconto : "        + AllTrim(Transform(_ndTotDesc,"@E 999,999.99")),oFont11N )
oPrint:Say  (nwRow,1450,"ICMS Retido : " +  AllTrim(Transform(_ndTotIcms,"@E 999,999.99")),oFont11N )
oPrint:Say  (nwRow,1850,"Total Pedido : "	 +AllTrim(Transform(nTotal4 + _ndTotIcms ,"@E 999,999,999,999.99")),oFont11N )

nwRow += 50
oPrint:Say  (nwRow,550,"CONFIRA O MATERIAL NO ATO DE ENTREGA, NAO ACEITAMOS RECLAMACOES POSTERIORES ",oFont11N )


Return Nil



*----------------------------------------------------------------------------------------------*
Static Function fTabTmp()
*----------------------------------------------------------------------------------------------*
// Função que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos

	Local cArea := GetArea()

	cQry2 := " SELECT DISTINCT C5_NUM" 
	cQry2 +=   " FROM "+RetSQLName("SC5") + " A "
	cQry2 +=  " INNER JOIN " + RetSQLName("SC6")+" B "
	cQry2 +=     " ON C5_NUM     = C6_NUM "
	cQry2 +=    " AND C5_FILIAL  = C6_FILIAL "
	cQry2 +=    " AND B.D_E_L_E_T_ = ' ' "
	cQry2 +=     "AND B.C6_BLQ <> 'R' "

	cQry2 +=  " INNER JOIN " + RetSQLName("SB1")+" C "
	cQry2 +=     " ON B1_COD     = C6_PRODUTO "
	cQry2 +=    " AND B1_FILIAL  = '" + xFilial("SB1") + "'"
	cQry2 +=    " AND C.D_E_L_E_T_ = ' ' "

	cQry2 +=  " INNER JOIN " + RetSQLName("SA1")+" D "
	cQry2 +=     " ON A1_COD     = C5_CLIENTE "
	cQry2 +=    " AND A1_FILIAL  = '" + xFilial("SA1") + "'"
	cQry2 +=    " AND D.D_E_L_E_T_ = ' ' "

	cQry2 +=  " WHERE A.D_E_L_E_T_ = ' ' "
	cQry2 +=    " AND C5_FILIAL  = '" + xFilial("SC5") + "' "
	cQry2 +=    " AND C5_NUM BETWEEN '" + mv_par01 + "' AND '" +mv_par02+ "'"

	If mv_par03 = 1
		cQry2 +=    " AND C6_QTDENT < C6_QTDVEN"
	elseif mv_par03 = 2
		cQry2 +=    " AND C5_NOTA = ''"
		cQry2 +=    " AND C6_QTDENT <> C6_QTDVEN"
	EndIf
	If !empty(_cdFIl)
		cQry2 +=    " And C5_FILIAL = '" + _cdFil + "'
	EndIf

	MemoWrite("AAFATR20.sql",cQry2)

    MPSysOpenQuery(cQry2,"TRB")

Return Nil



StaTIC Function fEnvia()
Local cHtml       := ""
Local cAccount    := ""
Local cServer     := ""
Local cPass       := ""
Local cAssunto    := "Ordem de Carregamento - " + cwNomeCli
Local nSaldo      := 0
Local cCliLj      := ""
Local nSalPto     := 0
Local nYPTOTAL    := 0
Local aArea       := GetArea()
Private cHoraEnvio := Time()
Private lHoraLimit  := cHoraEnvio > cHoraLimit

cHtml += Xcabec(cPedido, cCondPgto, cCodCli, cwNomeCli, cFilial_, cNomeFil)

cAccount   := GetMv('MV_RELACNT')// Conta de Envio de Relatorios por e-mail do acr//
cServer    := GetMv('MV_RELSERV')// IP do Servidor de e-mails //'smtp.microsiga.com.br'//
cPass      := GetMv('MV_RELPSW') // Senha da Conta de e-mail


LjMsgRun('* Conectando com o servidor SMTP: ' + cServer)
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If lResult
ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')	//ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')
SEND MAIL FROM cAccount  TO cEmail SUBJECT cAssunto BODY cHtml

//avisar horario limite de atendimento
If lHoraLimit
Alert("A Ordem se Carregamento será atendida no próximo dia útil. A hora limite para atendimento é " + cHoraLimit + ".")
EndIf

DISCONNECT SMTP SERVER
ELSE
GET MAIL ERROR CERROR
EndIf

RestArea(aArea)

Return .T.

Static Function Xcabec(cPedido, cCodCli, cwNomeCli, cFilial_, cNomeFil)

Local cHtml       := ""
Local cLimitad    := CHR(13) + CHR(10)

cHtml :=  '<table style="width:680px; font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:13px; text-align:justify;"  width="100%" border="0" cellspacing="6" cellpadding="6">'
cHtml +=  '  <tr >'
cHtml +=  '    	<td width="407"  valign="middle">'
cHtml +=  '   Senhores(as), <u> </u></td>'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2" height="30">&nbsp;'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2">'
cHtml +=  '<p> Foi gerada a Ordem de Carregamento: <br />'
cHtml +=  '<p> Pedido: ('+cPedido+'). <br />'
cHtml +=  '<p> Cód-Cliente: '+cCodCli+'-'+cwNomeCli+' <br />'
cHtml +=  '<p> Filial de Origem: '+cFilial_+'-'+cNomeFil+' <br />'

cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<br/>'

cHtml +=  '<table cellpadding="2" style="font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:12px; text-align:justify;" width="100%">'

Return cHtml




