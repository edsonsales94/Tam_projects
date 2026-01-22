//Bibliotecas615
#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Ap5Mail.ch"
#Include "fileio.ch"
#Include "TbiConn.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

/*
Criar parâmetros 
MV_X_EMAIL = Email da emitente da Invoice
MV_X_HPAGE = Home page do emitente da invoice 

MV_XBCOINV = Banco da invoice
MV_XAGEINV = Agencia da invoice
MV_XCCINV  = Conta da invoice

MV_XRESPIN = Responsável pela assinatura da invoice

MV_X1APINV = Percentual 1a parcela invoice
MV_X2APINV = Percentual 2a parcela invoice

ZZ_LOGO = Logotipo
*/

//Variáveis estáticas
Static nTamFundo  := 15
Static cEmpEmail  := Alltrim(SuperGetMV('MV_X_EMAIL', .F., ""))
Static cEmpSite   := Alltrim(SuperGetMV('MV_X_HPAGE', .F., ""))
//Static nCorAzul   := RGB(062,179,206)
Static nCorBranco   := RGB(255,255,255)
Static nCorAzul     := RGB(011,021,133)
Static nCorVermelho := RGB(231,028,043)

Static nPos0 := SuperGetMV('MV_XPOSIN0', .F., 001)
Static nPos1 := SuperGetMV('MV_XPOSIN1', .F., 110)
Static nPos2 := SuperGetMV('MV_XPOSIN2', .F., 210)
Static nPos3 := SuperGetMV('MV_XPOSIN3', .F., 310)
Static nPos4 := SuperGetMV('MV_XPOSIN4', .F., 400)
Static nPos5 := SuperGetMV('MV_XPOSIN5', .F., 563)

//-------------------------------------------------------------------
/*{Protheus.doc} EDTMSR01
Formulario de invoice - Modelo 1
Localizado BRA
@type user function - SIGATMS - módulo 43
@author Reinaldo Magalhães
@since 01/08/2024
@version 12.1.2310
@history 28/11/2024, Reinaldo Magalhães, Construção Inicial.
@links https://tdn.totvs.com/pages/releaseview.action?pageId=604534431
       https://htmlcolorcodes.com/
/*/

User Function EDTMSR01(lCallMe)
  Local aArea := GetArea()
  
  Local _cPref   := ""
  Local _cTit    := ""
  Local cEmails := ""
  
  Local _cCodFil:= Alltrim(SM0->M0_CODFIL)
  
  Private cEmpresa     := Iif(Empty(SM0->M0_NOMECOM), Alltrim(SM0->M0_NOME), Alltrim(SM0->M0_NOMECOM))
  Private cEmpEndereco := AllTrim(SM0->M0_ENDENT)+" - "+SM0->M0_BAIRENT
  Private cEmpCidade   := AllTrim(SM0->M0_CIDENT)+" / "+SM0->M0_ESTENT
  Private cEmpCnpj     := Alltrim(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
  Private cEmpInsc     := Alltrim(SM0->M0_INSCM)
  Private cEmpCep      := Alltrim(Transform(SM0->M0_CEPENT,"@R 99999-999"))
  Private cEmpTel      := Alltrim(SM0->M0_TEL)
  Private cEmpFax      := Alltrim(SM0->M0_FAX)

  Private nLinCab := 025 //- Linha inicial cabeçalho

  Private cLogoEmp := Alltrim(SuperGetMV("ZZ_LOGO",,FisxLogo("1") ))
  Private lAuto    := !Empty(cEmails)
  Private tpFrete  := ""
  
  Private cBcoInv:= Padr(Alltrim(SuperGetMV("MV_XBCOINV",.F.,"")),3)
  Private cAgeInv:= Padr(Alltrim(SuperGetMV("MV_XAGEINV",.F.,"")),5)
  Private cCtaInv:= Padr(Alltrim(SuperGetMV("MV_XCCINV",.F.,"")),10)

  Private cNomeResp := Alltrim(SuperGetMV("MV_XRESPIN",.F.,""))

  Private n1aParc := SuperGetMV("MV_X1APINV",.F.,0) //- Percentual 1a parcela invoice
  Private n2aParc := SuperGetMV("MV_X2APINV",.F.,0) //- Percentual 2a parcela invoice

  Private nLinAux0 := 0
  Private nLinAux1 := 0

  Private nLinAux2 := 0
  Private nLinAux3 := 0
  Private nNumDias := 0

  //Private aPergs := {;
  //{1,"Série",CRIAVAR("DT6_PREFIXO", .F.),"@!",'.T.',"",'.T.',80,.F.},;
  //{1,"Número" ,CRIAVAR("DT6_NUM"    , .F.),"@!",'.T.',"",'.T.',80,.F.},;
  //{2,"Enviar Email?","Não",{"Sim", "Não" },60,"",.F.}}
  
  Private aPergs := {;
  {1,"Série",CRIAVAR("DT6_PREFIXO", .F.),"@!",'.T.',"",'.T.',80,.F.},;
  {1,"Número" ,CRIAVAR("DT6_NUM"    , .F.),"@!",'.T.',"",'.T.',80,.F.},;
  {2,"Modelo?","1",{"1", "2","3"},60,"",.F.},;
  {1,"Dias Uteis p/ vencimento" ,nNumDias,  "@E 999",     "Positivo()", "", ".T.", 80,  .F.}};
//   {2,"Modelo?","1",{"1"},60,"",.F.},;
  
  lCallMe := IIF(lCallMe=NIL,.F.,lCallMe)
  If !lCallMe
     If Parambox(aPergs, "Parametros para filtro")
        _cPref    := MV_PAR01
	    _cTit     := MV_PAR02
	    _cModelo  := MV_PAR03
        nNumDias  := MV_PAR04
        Processa({|| fMontaRel(_cCodFil, _cPref, _cTit, _cModelo, lCallMe)}, "Processando...")
	 Endif
  Else	 
     _cPref    := DT6->DT6_PREFIXO
	 _cTit     := DT6->DT6_NUM
	 _cModelo := "1"
	 Processa({|| fMontaRel(_cCodFil, _cPref, _cTit, _cModelo, lCallMe)}, "Processando...")
  Endif
  RestArea(aArea)	
Return

/////////////////////////////////////////////////////////
Static Function fMontaRel(_cCodFil, _cPref, _cTit, _cModelo, lCallMe)
  Local nX      := 0
  Local	nVal1   := 0
  Local	nVal2   := 0
  Local nVolTot := 0
  Local nValAc1 := 0
  Local nValAc2 := 0
  Local nValAc3 := 0
  Local nValAc4 := 0
  Local aExtenso := {}
  Local cExtenso := ""
  Local lDT6 := .F.

  Private cHoraEx   := Time()
  Private nPagAtu   := 1
  Private cNomeRel  := "EDTMSR01"
  Private cQryIte   :=""

  //Linhas e colunas
  Private nLinAtu   := 0
  Private nLinFin   := 820
  Private nColIni   := 010
  Private nColFin   := 550
  Private nColMeio  := (nColFin-nColIni)/2
  Private oPrintPvt
  Private oBrushAzul     := TBRUSH():New(,nCorAzul)

  //- Declarando as fontes
  Private cNomeFont := "Arial"
  Private oFontDet  := TFont():New("Arial", 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
  Private oFontDetN := TFont():New("Arial", 9, -7,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFontRod  := TFont():New("Arial", 9, -6,  .T., .F., 5, .T., 5, .T., .F.)
  Private oFontTit  := TFont():New("Arial", 14, 14, .T., .T., 5, .T., 5, .T., .F.)
  Private oFontCab  := TFont():New("Arial", 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
  Private oFontCabN := TFont():New("Arial", 12, -7,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFontObs  := TFont():New("Arial", 10, -10,  .T., .F., 5, .T., 5, .T., .F.)
  Private oFontObsN := TFont():New("Arial", 10, -10,  .T., .T., 5, .T., 5, .T., .F.)
  
  Private oFont10Cab:= TFont():New("Arial", 10, 10,  .T., .F., 5, .T., 5, .T., .F.)
  Private oFont10N  := TFont():New("Arial", 10, 10,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFont11N  := TFont():New("Arial", 11, 11,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFont12N  := TFont():New("Arial", 12, 12,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFont14N  := TFont():New("Arial", 14, 14,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFont16N  := TFont():New("Arial", 16, 16,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFont18N  := TFont():New("Arial", 18, 18,  .T., .T., 5, .T., 5, .T., .F.)
  Private oFont24N  := TFont():New("Arial", 24, 24,  .T., .T., 5, .T., 5, .T., .F.)

  //- Cadastro de Produtos
  //DbSelectArea('SB1')
  //DbSetOrder(1) //B1_FILIAL+B1_COD

  //- Caso seja chamado pelo menu posiciona na DT6 
  If !lCallMe
     DbSelectArea('DT6')
     DbSetOrder(1) //DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	 lDT6 := MsSeek(xFilial("DT6")+_cCodFil+_cTit+_cPref+_cTit)
    if !lDT6
        alert('Erro - Doc ou Serie! Documento '+_cTit +' ou serie'+ _cPref + ', incorretos, verifique os parametros e tente novamente.','Não encontrado ')
        return
    endif
  Endif

  //- cadastro de Bancos
  DbSelectArea("SA6")
  DbSetOrder(1)
  MsSeek(xFilial("SA6")+cBcoInv+cAgeInv+cCtaInv)
   
  //- Cadastro de Clientes
  DbSelectArea('SA1')
  DbSetOrder(1) //A1_COD+A1_LOJA
  MsSeek(xFilial("SA1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV)

  //- Pais
  DbSelectArea('SYA')
  DbSetOrder(1) //YA_CODGI
  MsSeek(xFilial("SYA")+SA1->A1_PAIS)

  //- Faz busca na DTP
  DbSelectArea('DTP')
  DbSetOrder(1) //- DTP_FILIAL+DTP_LOTNFC
  MsSeek(xFilial("DTP")+DT6->DT6_LOTNFC)
  
  //- Faz busca na DTR para pegar o veiculo 
  DbSelectArea('DTR')
  DbSetOrder(1) //- DTR_FILIAL+DTR_FILORI+DTR_VIAGEM
  MsSeek(xFilial("DTR")+_cCodFil+DTP->DTP_VIAGEM)
 
  DbSelectArea('DTQ')
  DbSetOrder(1) //- DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM
  MsSeek(xFilial("DTQ")+DTP->DTP_VIAGEM)

  nVlrAbast := DTQ->DTQ_XVABAS
  //- Faz busca na DA3 para buscar o campo DA3_XVALTX (empurrador)
  DbSelectArea('DA3')
  DbSetOrder(1) //- DA3_FILIAL+DA3_COD
  MsSeek(xFilial("DA3")+DTR->DTR_CODVEI)

  if DA3->DA3_XTXDIF=='S'
    nValorTX := DA3->DA3_XVALTX
  else
    DT1->(MsSeek(xFilial("DT1")+DT6->(DT6_TABFRE+DT6_TIPTAB+DT6_CDRORI+DT6_CDRDES)))
    nValorTX := DT1->DT1_VALOR
  EndIf
  
  //- Se for automático por e-Mail
  If lAuto
     FErase(GetTempPath()+cNomeRel+".pdf")
  	 oPrintPvt := FWMsPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , , , , .F., , .F.)
  	 //Senão, gera normalmente
  Else
     oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , @oPrintPvt, , , , , .T.)
  EndIf
  
  //Setando os atributos necessários
  oPrintPvt:cPathPDF := GetTempPath()
  oPrintPvt:SetResolution(72)
  oPrintPvt:SetPortrait()
  oPrintPvt:SetPaperSize(DMPAPER_A4)
  oPrintPvt:SetMargin(60, 60, 60, 60)

  IF SELECT('QRY_DTC') > 0
    QRY_DTC->(DbCloseArea())
  EndIf
  //- Seleciona os itens da DTC
  cQryIte := " SELECT * "
  cQryIte += " FROM " + RetSQLName('DTC')+" DTC "
  cQryIte += " WHERE DTC_FILIAL = '"+FWxFilial('DTC')+"' "
  cQryIte += " AND DTC_DOC = '"+DT6->DT6_DOC+"' "
  cQryIte += " AND DTC_SERIE = '"+DT6->DT6_SERIE+"' "
  cQryIte += " AND DTC.D_E_L_E_T_ = ' ' "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQryIte)), "QRY_DTC", .T., .F. )
  DbGotop()	
  
  //- Imprime o cabeçalho
  nPagAtu := 1
  fImpCab()
  
  oPrintPvt:EndPage()
  nPagAtu++

  //cEmails := Rtrim(QRY_DAD->A1_EMAIL)
  //If !Empty (cEmails)
  //   If _cModelo == "Não"
  //      lAuto := .F.
  //   Else
  //      lAuto := .T.
  //   Endif
  //Endif
  //SA1->(DbSeek(FWxFilial('SA1') + QRY_DAD->CJ_CLIENTE + QRY_DAD->CJ_LOJA))

// se Modelo 1
nAuxPos:=75
    if _cModelo $ '1|3'
        oPrintPvt:SayAlign(nLinCab-7, nPos0, DA3->DA3_DESC, oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab-7, nPos2,  Str(n1aParc,2)+"% bbls"   , oFontCabN, 060, 05, , PAD_LEFT, )
        //   oPrintPvt:SayAlign(nLinCab-7, nPos3,  "x USD "+Alltrim(Transf(DA3->DA3_XVALTX,"@E 999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab-7, nPos3,  "x USD "+Alltrim(Transf(nValorTX,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab-7, nPos4,  Str(n2aParc,2)+"% bbls"   , oFontCabN, 060, 05, , PAD_LEFT, )
        //   oPrintPvt:SayAlign(nLinCab-7, nPos5-050,  "x USD "+Alltrim(Transf(DA3->DA3_XVALTX,"@E 999.99")) , oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab-7, nPos5-nAuxPos,  "x USD "+Alltrim(Transf(nValorTX,"@E 999,999,999,999.99")) , oFontCabN, 60, 05, , PAD_RIGHT, )
        nLinCab += 8
        oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) 
        nLinCab += 8

        //- Enquanto houver itens da invoice
        While !QRY_DTC->(EoF())
        
            DA3->(MsSeek(xFilial("DA3")+QRY_DTC->DTC_XBALSA))

            // SE FOR DEMURRAGE CANCELA.
            If QRY_DTC->DTC_XBALSA == '99999999' .OR. QRY_DTC->DTC_XBALSA == '99999998'
                alert('Essa invoice não é modelo '+AllTrim(cValToChar(_cModelo))+', trata-se de modelo 2 - '+DA3->DA3_DESC, 'Impressao cancelada')
                return .F.
            EndIf
            
            // nVal1 := QRY_DTC->DTC_VALOR * (n1aParc/100) //- 30% - FIRST PAYMENT
            // nVal2 := QRY_DTC->DTC_VALOR * (n2aParc/100) //- 70% - SECOND PAYMENT
            nVal1 := QRY_DTC->DTC_QTDVOL * (n1aParc/100) //- 30% - FIRST PAYMENT
            nVal2 := QRY_DTC->DTC_QTDVOL * (n2aParc/100) //- 70% - SECOND PAYMENT

            nVolTot += QRY_DTC->DTC_QTDVOL
            nValAc1 += nVal1 
            //  nValAc2 += nVal1 * DA3->DA3_XVALTX
            nValAc2 += nVal1 * nValorTX
            nValAc3 += nVal2 
            nValAc4 += nVal2 * nValorTX

            oPrintPvt:SayAlign(nLinCab-7, nPos0, DA3->DA3_DESC, oFontCabN, 060, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab-6, nPos1, AllTrim(Transform(QRY_DTC->DTC_QTDVOL,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab-5, nPos2, AllTrim(Transform(nVal1,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
            //  oPrintPvt:SayAlign(nLinCab-7, nPos3, Transform(nVal1*DA3->DA3_XVALTX,"@E 999,999,999,999.99"), oFontCabN, 060, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab-7, nPos3, AllTrim(Transform(nVal1*nValorTX,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab-7, nPos4, AllTrim(Transform(nVal2,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
            //  oPrintPvt:SayAlign(nLinCab-7, nPos5-nAuxPos, Transform(nVal2*DA3->DA3_XVALTX,"@E 999,999,999,999.99"), oFontCabN, 060, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab-7, nPos5-nAuxPos, AllTrim(Transform(nVal2*nValorTX,"@E 999,999,999,999.99")), oFontCabN, 60, 05, , PAD_RIGHT, )
            nLinCab += 8
            oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) 
            nLinCab += 8
            
            //Se por acaso atingiu o limite da página, finaliza, e começa uma nova página
            If nLinAtu >= nLinFin
                fImpRod()
                fImpCab()
            EndIf
            QRY_DTC->(DbSkip())
        Enddo
        QRY_DTC->(DbCloseArea())
  
        //nLinCab += 10
        //oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
        //nLinCab += 8
        oPrintPvt:SayAlign(nLinCab, nPos0,      "TOTAL", oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos1,      Alltrim(Transform(nVolTot,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos2,      Alltrim(Transform(nValAc1,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos3,      Alltrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos4,      Alltrim(Transform(nValAc3,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, Alltrim(Transform(nValAc4,"@E 999,999,999,999.99")), oFontCabN, 060, 05, , PAD_RIGHT, )
        nLinCab += 20
  
        oPrintPvt:Line( nLinAux2, nPos0+60, nLinCab, nPos0+60) //- 1a. Linha vertical 
        oPrintPvt:Line( nLinAux2, nPos1+60, nLinCab, nPos1+60) //- 2a. Linha vertical
        oPrintPvt:Line( nLinAux3, nPos2+60, nLinCab, nPos2+60) //- 3a. Linha vertical
        oPrintPvt:Line( nLinAux2, nPos3+60, nLinCab, nPos3+60) //- 4a. Linha vertical
        oPrintPvt:Line( nLinAux3, nPos4+60, nLinCab, nPos4+60) //- 5a. Linha vertical
        oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
        nLinAux0 := nLinCab
        nLinCab += 10
  
        if _cModelo $'1|3'
            
            if _cModelo == '1'
                oPrintPvt:SayAlign(nLinCab, nPos3-30, "TOTAL INVOICE $ ", oFont12N, 300, 05, , PAD_LEFT, )
                oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
                cExtenso := Extenso(nValAc2,.F.,2, ,"3",.T.)
            Else
                

                nValAc4 :=  (nValAc4-nVlrAbast)
                // oPrintPvt:SayAlign(nLinCab, nPos3-30, "COMBUSTIBLE DISCOUNT FAT 739-IP-> "+;
                // Alltrim(Transform(nVlrAbast,"@E 999,999,999,999.99")), oFont12N, 300, 05, , PAD_LEFT, )
                oPrintPvt:SayAlign(nLinCab, nPos3-30, "COMBUSTIBLE DISCOUNT FAT -> ", oFont12N, 300, 05, , PAD_LEFT, )
                oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nVlrAbast,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
                nLinCab += 14
                oPrintPvt:SayAlign(nLinCab, nPos3-30, "TOTAL INVOICE $ ", oFont12N, 300, 05, , PAD_LEFT, )
                oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nValAc4,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
                cExtenso := Extenso(nValAc4,.F.,2, ,"3",.T.)
            endif
        
            // oPrintPvt:SayAlign(nLinCab, nPos3+100, Alltrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont14N, 150, 05, , PAD_LEFT, )
            nLinCab += 20
    
            oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos3-40) //- Linha cabeçalho após o número da invoice
            nLinCab += 10
        endif

        //- Valor por extenso
        //Extenso(1999.78 ,.F.,1) = "ONE THOUNSAND NINE HUNDRED AND NINETY-NINE DOLLARS AND SEVENTY-EIGHT CENTS"
        aExtenso := u_zMemoToA(cExtenso, 50) //- Função para formatar campo memo

        nLinAux1 := nLinCab //- salva linha corrente
        For nX := 1 to Len(aExtenso)   // Imprime o objeto do contrato
            oPrintPvt:SayAlign(nLinCab-10, nPos3-30,  Alltrim(aExtenso[nX]), oFontCabN, 300, 05, , PAD_LEFT, )
            nLinCab += 10
        Next
        nLinCab := nLinAux1 //- Volta linha

        oPrintPvt:SayAlign(nLinCab, nPos0+8,  "FREIGHT BARGES AMOUNT $", oFont12N, 150, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos1+8,  AllTrim(Transform(DT6->DT6_VALTOT,"@E 999,999,999,999.99")), oFont12N, 100, 05, , PAD_RIGHT, )
        nLinCab += 20

        oPrintPvt:Line( nLinAux0, nPos3-40, nLinCab, nPos3-40) //- Linha vertical - Total invoice
        oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5)  //- Linha cabeçalho após o número da invoice
        nLinCab += 10
    // elseif _cModelo =='2'
    endif
    

    oPrintPvt:FillRect({nLinCab-5 , nPos0, nLinCab + 20, nPos5}, oBrushAzul)
    oPrintPvt:SayAlign(nLinCab, nPos0+8,  "DESCRIPTION", oFont12N, 130, 05,nCorBranco, PAD_LEFT, )
    oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos,  "AMOUNT" , oFont12N, 060, 05,nCorBranco, PAD_RIGHT, )
    nLinCab += 22
  
    if _cModelo $'1|3'
        if _cModelo == '1'
            oPrintPvt:SayAlign(nLinCab, nPos0+8, "FIRST PAYMENT ADVANCE", oFont11N, 150, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
        else
            oPrintPvt:SayAlign(nLinCab, nPos0+8, "FIRST PAYMENT ADVANCE", oFont11N, 150, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
            nLinCab += 12
            oPrintPvt:SayAlign(nLinCab, nPos0+8, "COMBUSTIBLE DISCOUNT FAT -> ", oFont11N, 300, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nVlrAbast,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
            nLinCab += 12
            oPrintPvt:SayAlign(nLinCab, nPos0+8, "SECUND PAYMENT ADVANCE ", oFont11N, 300, 05, , PAD_LEFT, )
            oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nValAc4,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
        endif
    elseif _cModelo =='2'
        _cDesc := Posicione("DA3",1,xFilial("DA3")+QRY_DTC->DTC_XBALSA,"DA3_DESC")
        //- Enquanto houver itens da invoice
        While !QRY_DTC->(EoF())
            If QRY_DTC->DTC_XBALSA != '99999999' .AND. QRY_DTC->DTC_XBALSA != '99999998'
                alert('Essa invoice não é modelo 2 - '+_cDesc)
                return .F.
            EndIf
        QRY_DTC->(DbSkip())
        Enddo
        QRY_DTC->(DbCloseArea())

        // FALTA PEGAR O VALOR
        nValAc2 :=DT6->DT6_VALTOT

        oPrintPvt:SayAlign(nLinCab, nPos0+8, _cDesc, oFont11N, 150, 05, , PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos5-nAuxPos, AllTrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
        
        nLinAux3 := nLinCab + 25

        oPrintPvt:SayAlign(nLinAux3, nPos4-35, "TOTAL INVOICE $ ", oFont12N, 150, 05, , PAD_LEFT, )
        // oPrintPvt:SayAlign(nLinAux3, nPos4+20, Alltrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont12N, 060, 05, , PAD_RIGHT, )
        oPrintPvt:SayAlign(nLinAux3, nPos5-nAuxPos, AllTrim(Transform(nValAc2,"@E 999,999,999,999.99")), oFont11N, 060, 05, , PAD_RIGHT, )
        nLinAux3 += 30
        cExtenso := Extenso(nValAc2,.F.,2, ,"3",.T.)
        aExtenso := u_zMemoToA(cExtenso, 50) //- Função para formatar campo memo

        For nX := 1 to Len(aExtenso)   // Imprime o objeto do contrato
            oPrintPvt:SayAlign(nLinAux3, nPos4-35,  Alltrim(aExtenso[nX]), oFontCabN, 300, 05, , PAD_LEFT, )
            nLinAux3 += 10
        Next
        nLinAux3 += 20
        oPrintPvt:Line( nLinAux3, nPos4-50, nLinAux3, nPos5)
    endif
    nLinCab += 20

  oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
  nLinCab += 10
//498
  oPrintPvt:FillRect({nLinCab-5 , nPos0, nLinCab + 20, nPos4-50}, oBrushAzul)
  oPrintPvt:Line( nLinCab+20, nPos0, nLinCab+20, nPos4-50) // horizontal
  oPrintPvt:Line( nLinCab+213, nPos0, nLinCab+213, nPos4-50) // horizontal
  oPrintPvt:Line( nLinCab+20, nPos0, nLinCab+213, nPos0) // vertical
  oPrintPvt:Line( nLinCab+20, nPos4-50, nLinCab+213, nPos4-50) // vertical

  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Remitance instructions:", oFont16N, 300, 05, nCorBranco , PAD_LEFT, )
  nLinCab += 20
  
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Intermediary Bank", oFont14N, 100, 05, nCorVermelho, PAD_LEFT, )
  oPrintPvt:SayAlign(nLinCab, nPos2-20,  "Beneficiary Bank", oFont14N, 200, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 20

  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Bank Name: "+Alltrim(SA1->A1_XINBCNO), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
  oPrintPvt:SayAlign(nLinCab, nPos2-20,  "Bank Name: "+Alltrim(SA1->A1_XBNBCNO), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10

  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Swift (BIC CODE): "+Alltrim(SA1->A1_XINBCSW), oFontCabN, 150, 05, nCorVermelho, PAD_LEFT, )
  oPrintPvt:SayAlign(nLinCab, nPos2-20,  "Swift: "+Alltrim(SA1->A1_XBNBCSW), oFontCabN, 150, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10

  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Bank Address: "+Alltrim(SA1->A1_XINBCEN), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
  oPrintPvt:SayAlign(nLinCab, nPos2-20,  "Account: "+Alltrim(SA1->A1_XBNBCAC), oFontCabN, 150, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10


  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Clearing Code (ABA): "+Alltrim(SA1->A1_XINBCAB), oFontCabN, 130, 05, nCorVermelho, PAD_LEFT, )
  oPrintPvt:SayAlign(nLinCab, nPos2-20,  SubStr("Bank Address: "+Alltrim(SA1->A1_XBNBCEN),1,40), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
  // Se o bank address for maior que 27 caracters imprime na outra linha
  if Len(SubStr(Alltrim(SA1->A1_XBNBCEN),27))>0
    nLinCab += 10
    oPrintPvt:SayAlign(nLinCab, nPos2-20,  SubStr(+Alltrim(SA1->A1_XBNBCEN),27), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
  endif
  nLinCab += 20
  
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Beneficiary Bank", oFont14N, 300, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 20
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Beneficiary Name: "+cEmpresa, oFontCabN, 300, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Account: "+Alltrim(SA6->A6_NUMCON)+"-"+AllTrim(SA6->A6_DVCTA), oFontCabN, 150, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Bank Name: "+Alltrim(SA6->A6_NOME), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
//   nLinCab += 10
//   oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Bank Address: "+Alltrim(SA6->A6_END), oFontCabN, 200, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "Beneficiary's Address: "+cEmpEndereco, oFontCabN, 300, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10
  oPrintPvt:SayAlign(nLinCab, nPos0+8,  "IBAN CODE: "+Alltrim(SA6->A6_XIBAN), oFontCabN, 300, 05, nCorVermelho, PAD_LEFT, )
  nLinCab += 10
  
  //- Assinatura
  oPrintPvt:SayAlign(nLinCab, nPos4,  Replicate("-",60), oFontCabN, 130, 05, , PAD_LEFT, )
  nLinCab += 10

  oPrintPvt:SayAlign(nLinCab, nPos4,  cNomeResp, oFontCabN, 130, 05, , PAD_CENTER, )
  nLinCab += 10

  oPrintPvt:SayAlign(nLinCab, nPos4,  Alltrim(cEmpresa), oFontCabN, 130, 05, , PAD_CENTER, )
  nLinCab += 10
    
  //Se for automático, gera o pdf e manda por email
  If lAuto
     oPrintPvt:Print()
	 CpyT2S( GetTempPath()+cNomeRel+".pdf", "\spool", .F. )
	 fEnvEmail(cEmails, "Invoice", "Segue a(s) em anexo a invoice", "\spool\"+cNomeRel+".pdf")
  Else
	 oPrintPvt:Preview()
	 CpyT2S( GetTempPath()+cNomeRel+".pdf", "\spool\", .F. )
  EndIf
Return()

//////////////////////////
Static Function fImpCab()
	If Len(cEmpTel) >=12 
		cEmpTel:= Alltrim(SM0->M0_TEL)
		cEmpFax:= Alltrim(SM0->M0_FAX)
		cEmpTel     := Alltrim(cEmpTel)
		cEmpFax     := Alltrim(cEmpFax)
	Else
		cEmpTel  := StrTran(SM0->M0_TEL, "(", "")
		cEmpTel  := StrTran(SM0->M0_TEL, ")", "")
		cEmpTel  := StrTran(SM0->M0_TEL, "-", "")
		cEmpFax  := StrTran(SM0->M0_FAX, "(", "")
		cEmpFax  := StrTran(SM0->M0_FAX, ")", "")
		cEmpFax  := StrTran(SM0->M0_FAX, "-", "")
		cEmpTel  := Alltrim(Transform(cEmpTel,"@R (99) 9999-99999"))
		cEmpFax  := Alltrim(Transform(cEmpFax,"@R (99) 9999-99999"))
	Endif
    
	//Iniciando Página
	oPrintPvt:StartPage()

	//Box Dados da Empresa
	nLinCab += nTamFundo - 5
    nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, 150, cEmpresa, oFontTit, 400, 05, nCorAzul, PAD_RIGHT,  )
	// oPrintPvt:SayAlign(nLinCab-10, nPos4, cEmpresa, oFontTit, 400, 05, nCorAzul, PAD_LEFT,  )
	oPrintPvt:SayBitmap(nLinCab, nPos0, cLogoEmp, 094, 094)
	nLinCab += 20
    
	//////////////////// RÉGUA ////////////////////
    //oPrintPvt:SayAlign(nLinCab, nPos0,  "0", oFontCabN, 060, 05, , PAD_LEFT, )
    //oPrintPvt:SayAlign(nLinCab, nPos1,  "1", oFontCabN, 060, 05, , PAD_LEFT, )
    //oPrintPvt:SayAlign(nLinCab, nPos2,  "2", oFontCabN, 060, 05, , PAD_LEFT, )
    //oPrintPvt:SayAlign(nLinCab, nPos3,  "3", oFontCabN, 060, 05, , PAD_LEFT, )
    //oPrintPvt:SayAlign(nLinCab, nPos4,  "4", oFontCabN, 060, 05, , PAD_LEFT, )
    //oPrintPvt:SayAlign(nLinCab, nPos5,  "5", oFontCabN, 060, 05, , PAD_LEFT, )

    //nLinCab += 5
    iF !Empty(cEmpCnpj)
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "CNPJ.:  " +space(3)+AllTrim(cEmpCnpj), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
	// oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpCnpj, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,  )
    EndIf
    iF !Empty(cEmpInsc)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "Insc. Mun.:  "+space(3)+AllTrim(cEmpInsc), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
    // oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpInsc, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,  )
    EndIf
    iF !Empty(cEmpEndereco)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "Endereço.: "+space(3)+AllTrim(cEmpEndereco), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
    // oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpEndereco, oFontCab, 180, 05, nCorAzul, PAD_RIGHT,)
    EndIf
    iF !Empty(cEmpCep)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "CEP.: "+space(3)+AllTrim(cEmpCep), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
    // oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpCep, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,  )
    EndIf
    iF !Empty(cEmpCidade)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "Cidade.: "+space(3)+AllTrim(cEmpCidade), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
	// oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpCidade, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,)
    EndIf
    iF !Empty(cEmpTel)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "Fone.: "+space(3)+AllTrim(cEmpTel), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
	// oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpTel, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,)
    EndIf
    iF !Empty(cEmpEmail)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "e-Mail.: "+space(3)+AllTrim(cEmpEmail), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
	// oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpEmail, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,)
    EndIf
    iF !Empty(cEmpSite)
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos3-10,  "Home Page.:  "+space(3)+AllTrim(cEmpSite), oFontCabN, 250, 05, nCorAzul, PAD_RIGHT,  )
    // oPrintPvt:SayAlign(nLinCab, nPos4+30,  cEmpSite, oFontCab, 130, 05, nCorAzul, PAD_RIGHT,  )
    EndIf
	nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos4-10,  "INVOICE ", oFont18N, 100, 05, nCorAzul, PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab+3, nPos4+60, 'NR.: ' + DT6->DT6_DOC+"-"+Str(Year(DT6->DT6_DATEMI),4), oFont12N, 150, 05, nCorAzul, PAD_LEFT, )
	nLinCab += 30

    oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
    oPrintPvt:FillRect({nLinCab , nPos0, nLinCab + 20, nPos5}, oBrushAzul)
	nLinCab += 2

	oPrintPvt:SayAlign(nLinCab, nPos2,      "BILL TO",  oFont14N, 060, 05, nCorBranco, PAD_LEFT, )
    oPrintPvt:SayAlign(nLinCab, nPos3,      "Date",     oFont14N, 060, 05, nCorBranco, PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab, nPos4+50,   "Due Date", oFont14N, 060, 05, nCorBranco, PAD_LEFT, )
    nLinCab += 20

    // função para calcular due date
    dDueDate:= fDataVenc(DT6->DT6_DATEMI, nNumDias)

    oPrintPvt:SayAlign(nLinCab, nPos3,DataIngles(Day(DT6->DT6_DATEMI),Month(DT6->DT6_DATEMI),Year(DT6->DT6_DATEMI)), oFont10N, 130, 05, nCorAzul, PAD_LEFT,  )
	oPrintPvt:SayAlign(nLinCab, nPos4+50,DataIngles(Day(dDueDate),Month(dDueDate),Year(dDueDate)), oFont10N, 130, 05, nCorAzul, PAD_LEFT,  )
	
    oPrintPvt:SayAlign(nLinCab, nPos0,  "Buyer:", oFont14N, 060, 05, nCorAzul, PAD_LEFT,  )
    nLinCab += 20

    oPrintPvt:SayAlign(nLinCab, nPos0, Alltrim(SA1->A1_NOME), oFontDetN, 250, 05, , PAD_LEFT, )
    nLinCab += 10
	
	oPrintPvt:SayAlign(nLinCab, nPos0, Alltrim(SA1->A1_END), oFontDetN, 250, 05, , PAD_LEFT, )
    nLinCab += 10

	oPrintPvt:SayAlign(nLinCab, nPos0, Alltrim(SYA->YA_DESCR), oFontDetN, 250, 05, , PAD_LEFT, )
    nLinCab -= 30
    
    oPrintPvt:Line( nLinCab, nPos3, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
    oPrintPvt:FillRect({nLinCab , nPos3, nLinCab + 18, nPos5}, oBrushAzul)

    // -------- Box REFECENCE
	oPrintPvt:SayAlign(nLinCab+2, nPos4+15,  "REFERENCE", oFont14N, 100, 05, nCorBranco, PAD_LEFT, )
    nLinCab += 20
    cDTCPorto := Posicione("DTC",3,DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE),"DTC_XPTEMB")
    cDecPorto  := Alltrim(Posicione("SZ1",1,XFILIAL('SZ1')+cDTCPorto,"Z1_PORTO"))
    cSiglaPorto := AllTrim(Posicione("SZ1",1,XFILIAL('SZ1')+cDTCPorto,"Z1_SIGLA"))
    oPrintPvt:SayAlign(nLinCab, nPos3,'MT '+cDecPorto+space(15)+cSiglaPorto,oFont10N,400,05,nCorAzul, PAD_LEFT,  )
    nLinCab += 10

    oPrintPvt:SayAlign(nLinCab, nPos3,'RM '+Posicione("DA3",1,DTR->(DTR_FILIAL+DTR_CODVEI),"DA3_DESC"), oFont10N, 130, 05, nCorAzul, PAD_LEFT,  )
    
    nLinCab += 20
    
    // DESCRIPTION
    cCodProduto := Posicione("DTC",3,DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE),"DTC_CODPRO")
    cDescProduto := AllTrim(Posicione("SB1",1,xFilial('SB1')+cCodProduto,"B1_DESC"))
     
    cDesc := 'River Barge Trasportation Services of BRETAÑA '+ cDescProduto 
    cDesc2 := 'from '+cDecPorto +' to BCE- MANAUS-AMAZONAS- BRAZIL.'
    oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
    oPrintPvt:FillRect({nLinCab , nPos0, nLinCab + 35, nPos5}, oBrushAzul)
    nLinCab += 10
	oPrintPvt:SayAlign(nLinCab, nPos0+30,  "DESCRIPTION", oFont12N, 100, 05, nCorBranco, PAD_LEFT, )

	oPrintPvt:SayAlign(nLinCab-5, nPos0+155,cDesc, oFont11N, 500, 05, nCorBranco, PAD_LEFT, )
    nLinCab += 5
	oPrintPvt:SayAlign(nLinCab, nPos0+155,cDesc2, oFont11N, 500, 05, nCorBranco, PAD_LEFT, )
    
    nLinCab += 25
    // oPrintPvt:SayAlign(nLinCab, nPos0,  "Buyer", oFont14N, 060, 05, nCorAzul, PAD_LEFT,  )

    // oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
    // nLinCab += 10

    oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
    nLinAux2 := nLinCab
    nLinCab += 10

    if _cModelo $ '1|3'
        oPrintPvt:SayAlign(nLinCab, nPos0   , "VESSEL"        , oFontDetN, 040, 05, nCorAzul, PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos1   , "VOLUME LOADED" , oFontDetN, 055, 05, nCorAzul, PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos3   , "FIRST PAYMENT" , oFontDetN, 060, 05, nCorAzul, PAD_LEFT, )
        oPrintPvt:SayAlign(nLinCab, nPos5-60, "SECOND PAYMENT", oFontDetN, 065, 05, nCorAzul, PAD_LEFT, )
        nLinCab += 10
    

        oPrintPvt:SayAlign(nLinCab, nPos1, "NET BBLS" , oFontDetN, 035, 05, nCorAzul, PAD_LEFT, )
        nLinCab += 10
        nLinAux3 := nLinCab 
        oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos5) //- Linha cabeçalho após o número da invoice
        nLinCab += 10
    endif

	//- Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 10
Return

// Função para adicionar dias úteis a uma data
// dtDate: data inicial no formato DD/MM/YYYY
// _nNumDias: número de dias úteis a serem adicionados

Static Function fDataVenc(dtDate, _nNumDias)

Local dNovaData := dtDate
Local nDiaAdicional := 0
Local nDiaDaSemana

do While nDiaAdicional < _nNumDias
    dNovaData := dNovaData + 1

    // Verifica se o dia é útil (segunda a sexta)
    nDiaDaSemana := DOW(dNovaData)
    iF nDiaDaSemana > 1 .AND. nDiaDaSemana < 7
        nDiaAdicional++
    Endif
EndDo

Return dNovaData


/*---------------------------------------------------------------------*
| Func:  fImpRod                                                      |
| Autor: Daniel Atilio                                                |
| Data:  19/06/2016                                                   |
| Desc:  Função que imprime o rodapé                                  |
*---------------------------------------------------------------------*/

Static Function fImpRod()
	Local nLinRod:= nLinFin + 10
	Local cTexto := ''

	//Linha Separatória
	oPrintPvt:Line(nLinRod,   nColIni, nLinRod,   nColFin)
	nLinRod += 3

	//Dados da Esquerda
	cTexto := "Orçamentos "+QRY_DAD->CJ_NUM+"    |    "+dToC(dDataBase)+"     "+cHoraEx+"     "+FunName()+"     "+cUserName
	oPrintPvt:SayAlign(nLinRod, nColIni, cTexto, oFontRod, 250, 05, , PAD_LEFT, )

	//Direita
	cTexto := "Página "+cValToChar(nPagAtu)
	oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 05, , PAD_RIGHT, )

	//Finalizando a página e somando mais um
	oPrintPvt:EndPage()
	nPagAtu++
Return

/*---------------------------------------------------------------------*
| Func:  fEnvEmail                                                    |
| Autor:                                                              |
| Data:  13/01/2020                                                   |
| Desc:  Função que envia email para o cliente                        |
*---------------------------------------------------------------------*/

Static Function fEnvEmail(_cPara, _cTitulo, _cMsg, _aAnexo)
	Local oMail
	Local oMessage
	Local nRet
	Local nTimeout := GetMV("MV_RELTIME")	//Timeout no Envio de E-Mail;
	Local cServer  := GetMV("MV_RELSERV")	//Nome do Servidor de Envio de E-Mail utilizado nos relatorios;
	Local cEmail   := GetMV("MV_RELACNT")	//Conta a ser utilizada no envio de E-Mail para os relatorios;
	Local cEmailA  := GetMV("MV_RELAUSR")	//Usuario para Autenticacao no Servidor de E-Mail;
	Local cEmailFr := GetMV("MV_RELFROM")	//E-Mail utilizado no campo FROM no envio de relatorios por E-Mail;
	Local cPass    := GetMV("MV_RELPSW")	//Senha da Conta de E-Mail para envio de relatorios;
	Local lAuth    := GetMv("MV_RELAUTH")	//Servidor de E-Mail necessita de Autenticacao? Determina se o Servidor necessita de Autenticacao;
	//Local cMailAud := GetMv("MV_MAILADT")	//Conta oculta de auditoria utilizada no envio de E-Mail para os relatorios;
	Local lUseSSL  := GetMv("MV_RELSSL")	//Define se o envio e recebimento de E-Mail na rotina SPED utilizara conexao segura (SSL);
	Local lUseTLS  := GetMv("MV_RELTLS")	//Informe se o servidor de SMTP possui conexao do tipo segura (SSL/TLS);
	Local _nPorta  := 465					//Porta Default;

	DEFAULT _cPara := ""
	DEFAULT _cMsg  := ""
	DEFAULT _aAnexo  := {}
	DEFAULT _cTitulo := ""

	ProcRegua(15)

	//---------------------------------------------------------------------------------------------------------------------
	//ENVIAR EMAIL PARA TI QUANDO FOR AMBIENTE TESTE
	//if cEmpAnt <> "01" .and. cEmpAnt <> "02"
	//	_cPara := cEmails
	//endif

	//---------------------------------------------------------------------------------------------------------------------
	//PREENCHENDO O EMAIL PARA RESPOSTA
	DbSelectArea("SX5")

	if SX5->(DbSeek(xFilial("SX5")+"WK"+AllTrim(PswID())))
		cEmailFr := AllTrim(SX5->X5_DESCSPA)
	endif

	//---------------------------------------------------------------------------------------------------------------------
	//VALIDANDO OS PARAMETROS INFORMADOS
	If Empty(cServer) .OR. Empty(cEmail) .OR. Empty(cEmailA) .OR. Empty(cPass)
		MsgBox("Verifique os parametros: MV_RELSERV, MV_RELACNT, MV_RELAUSR ou MV_RELPSW!!!","Funcao EnvMail","STOP") 
		Return(.F.)
	EndIf

	If Empty(_cPara)
		MsgBox("Parametro 'Para' tem preenchimento obrigatorio!!!","Funcao EnvMail","STOP") 
		Return(.F.)
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CASO O ENDERECO DO SERVER TENHA A PORTA INFORMADA, SEPARA OS CAMPOS
	If(At(":",cServer) > 0)
		_nPorta := Val(Substr(cServer,At(":",cServer)+1,Len(cServer)))
		cServer := Substr(cServer,0,At(":",cServer)-1)
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CRIA UMA INSTANCIA DA CLASSE TMAILMANAGER
	oMail := TMailManager():New()
	If(lUseSSL)
		oMail:SetUseSSL(lUseSSL)
	EndIf
	If(lUseTLS)
		oMail:SetUseTLS(lUseTLS)
	EndIf

    //cMsg := "server:"+cServer+"/ "+"mail:"+cEmail+"/ "+"pass:"+cPass+"/ "+"port:"+str(_nPorta,3)
	//alert(cMsg)

	//---------------------------------------------------------------------------------------------------------------------
	//DEFINE AS CONFIGURACOES, DA CLASSE TMAILMANAGER, PARA REALIZAR UMA CONEXAO COM O SERVIDOR DE E-MAIL
	oMail:Init("",cServer,cEmail,cPass,0,_nPorta)

	//---------------------------------------------------------------------------------------------------------------------
	//DEFINE O TEMPO DE ESPERA PARA UMA CONEXAO ESTABELECIDA COM O SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL)
	If (nTimeout <= 0)
		ConOut("[TIMEOUT] DISABLE")
	Else
		IncProc("[TIMEOUT] ENABLE()")
		ConOut("[TIMEOUT] ENABLE()")
		nRet := oMail:SetSmtpTimeOut(nTimeout)

		If nRet != 0
			ConOut("[TIMEOUT] Fail to set")
			ConOut("[TIMEOUT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			MsgBox("[TIMEOUT][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao EnvMail","STOP")
			oMail:SMTPDisconnect()
			Return(.F.)
		EndIf
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CONECTA COM O SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL)
	IncProc("[SMTPCONNECT] connecting ...")
	ConOut("[SMTPCONNECT] connecting ...")
	nRet := oMail:SmtpConnect()
	If nRet <> 0
		ConOut("[SMTPCONNECT] Falha ao conectar")
		ConOut("[SMTPCONNECT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		MsgBox("[SMTPCONNECT][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao EnvMail","STOP")
		oMail:SMTPDisconnect()
		Return(.F.)
	Else
		ConOut("[SMTPCONNECT] Sucesso ao conectar")
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//REALIZA A AUTENTICACAO NO SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL) PARA ENVIO DE MENSAGENS
	If lAuth
		IncProc("[AUTH] ENABLE")
		ConOut("[AUTH] ENABLE")
		ConOut("[AUTH] TRY with ACCOUNT() and PASS()")

		nRet := oMail:SMTPAuth(cEmailA,cPass)
		If nRet != 0
			IncProc("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			ConOut("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			ConOut("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			ConOut("[AUTH] TRY with USER() and PASS()")
			MsgBox("[AUTH][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao EnvMail","STOP")
			nRet := oMail:SMTPAuth(cEmailA,cPass)

			If nRet != 0
				ConOut("[AUTH] FAIL TRY with USER() and PASS()")
				ConOut("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
				MsgBox("[AUTH][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao EnvMail","STOP")
				oMail:SMTPDisconnect()
				Return(.F.)
			Else
				IncProc("[AUTH] SUCEEDED TRY with USER() and PASS()")
				ConOut("[AUTH] SUCEEDED TRY with USER() and PASS()")
			EndIf
		Else
			IncProc("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
			ConOut("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
		EndIf
	Else
		IncProc("[AUTH] DISABLE")
		ConOut("[AUTH] DISABLE")
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CRIA UMA INSTANCIA DA CLASSE TMAILMANAGER
	IncProc("[MESSAGE] Criando mail message")
	ConOut("[MESSAGE] Criando mail message")
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom    := cEmailFr
	oMessage:cTo      := _cPara
	oMessage:cSubject := _cTitulo
	oMessage:cBody    := _cMsg
	xRet := oMessage:AttachFile( _aAnexo )
	if xRet < 0
		cMsg := "O arquivo " + _aAnexo + " não foi anexado!"
		alert( cMsg )
		return
	endif


	oMessage:MsgBodyType("text/html")

	//---------------------------------------------------------------------------------------------------------------------
	//ENVIA E-MAIL ATRAVÉS DO PROTOCOLO SMTP
	IncProc("[SEND] Sending ...")
	ConOut("[SEND] Sending ...")
	nRet := oMessage:Send(oMail)
	If nRet <> 0
		ConOut("[SEND] Fail to send message")
		ConOut("[SEND][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		MsgBox("[SEND][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao EnvMail","STOP")
		oMail:SMTPDisconnect()
		Return(.F.)
	Else
		IncProc("[SEND] Success to send message")
		ConOut("[SEND] Success to send message")
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//FINALIZA A CONEXAO ENTRE A APLICACAO E O SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL)
	IncProc("[DISCONNECT] smtp disconnecting ... ")
	ConOut("[DISCONNECT] smtp disconnecting ... ")
	oMail:SMTPDisconnect()
	If nRet != 0
		IncProc("[DISCONNECT] Fail smtp disconnecting ... ")
		ConOut("[DISCONNECT] Fail smtp disconnecting ... ")
		ConOut("[DISCONNECT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		MsgBox("[DISCONNECT][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao EnvMail","STOP")
	Else
		IncProc("[DISCONNECT] Success smtp disconnecting ... ")
		ConOut("[DISCONNECT] Success smtp disconnecting ... ")
	EndIf

	Return(.T.)

Return .T.

/*/{Protheus.doc} zMemoToA
Função Memo To Array, que quebra um texto em um array conforme número de colunas
@author Atilio
@since 15/08/2014
@version 1.0
    @param cTexto, Caracter, Texto que será quebrado (campo MEMO)
    @param nMaxCol, Numérico, Coluna máxima permitida de caracteres por linha
    @param cQuebra, Caracter, Quebra adicional, forçando a quebra de linha além do enter (por exemplo '<br>')
    @param lTiraBra, Lógico, Define se em toda linha será retirado os espaços em branco (Alltrim)
    @return nMaxLin, Número de linhas do array
    @example
    cCampoMemo := SB1->B1_X_TST
    nCol        := 200
    aDados      := u_zMemoToA(cCampoMemo, nCol)
    @obs Difere da MemoLine(), pois já retorna um Array pronto para impressão
/*/
User Function zMemoToA(cTexto, nMaxCol, cQuebra, lTiraBra)
    Local aArea     := GetArea()
    Local aTexto    := {}
    Local aAux      := {}
    Local nAtu      := 0
    Default cTexto  := ''
    Default nMaxCol := 80
    Default cQuebra := ';'
    Default lTiraBra:= .T.
 
    //Quebrando o Array, conforme -Enter-
    aAux:= StrTokArr(cTexto,Chr(13))
     
    //Correndo o Array e retirando o tabulamento
    For nAtu:=1 TO Len(aAux)
        aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
    Next
     
    //Correndo as linhas quebradas
    For nAtu:=1 To Len(aAux)
     
        //Se o tamanho de Texto, for maior que o número de colunas
        If (Len(aAux[nAtu]) > nMaxCol)
         
            //Enquanto o Tamanho for Maior
            While (Len(aAux[nAtu]) > nMaxCol)
                //Pegando a quebra conforme texto por parâmetro
                nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))
                 
                //Caso não tenha, a última posição será o último espaço em branco encontrado
                If nUltPos == 0
                    nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
                EndIf
                 
                //Se não encontrar espaço em branco, a última posição será a coluna máxima
                If(nUltPos==0)
                    nUltPos:=nMaxCol
                EndIf
                 
                //Adicionando Parte da Sring (de 1 até a Úlima posição válida)
                aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
                 
                //Quebrando o resto da String
                aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
            EndDo
             
            //Adicionando o que sobrou
            aAdd(aTexto,aAux[nAtu])
        Else
            //Se for menor que o Máximo de colunas, adiciona o texto
            aAdd(aTexto,aAux[nAtu])
        EndIf
    Next
     
    //Se for para tirar os brancos
    If lTiraBra
        //Percorrendo as linhas do texto e aplica o AllTrim
        For nAtu:=1 To Len(aTexto)
            aTexto[nAtu] := Alltrim(aTexto[nAtu])
        Next
    EndIf
     
    RestArea(aArea)
Return(aTexto)

//////////////////////////////
Static Function DataIngles(nDia,nMes,nAno)
  Local cDataExt:= ""
  Local aMes := {'January','February','March','April','May','June','July','August','September','October','November','December'}
  Local aDias := {'1st.','2nd.','3rd.', '4th.','5th.','6th.','7th.','8th.','9th.','10th.','11th.','12th.','13th.','14th.','15th.',;
                  '16th.','17th.','18th.','19th.','20th.','21st.','22nd.','23rd.','24th.','25th.','26th.','27th.','28th.','29th.',;
				  '30th.','31st.'}
  cDataExt:= aMes[nMes]+","+aDias[nDia]+" "+Strzero(nAno,4)
Return(cDataExt)
