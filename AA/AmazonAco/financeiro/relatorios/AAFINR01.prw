#INCLUDE "PROTHEUS.CH"
#include "FWPrintSetup.ch"
#include 'totvs.ch'
#INCLUDE "RPTDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RAMR010  ³ Autor ³ Microsiga             ³ Data ³ 26/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO ITAU                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//
User Function AAFINR1A()
    MsApp():New('SIGATST') 
    oApp:CreateEnv()
    PtSetTheme("SUNSET")
    //u_AAFINR01("1","000046348",,.T.)
    //u_AAFINR01()
    //Define o programa de inicialização 
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",;
        {|| RpcSetEnv("06","01"), }),;        
        u_AAFINR01(),;
        Final("TERMINO NORMAL")}
     
    //Seta Atributos 
    __lInternet := .T.
    lMsFinalAuto := .F.
    oApp:lMessageBar:= .T. 
    oApp:cModDesc:= 'SIGATST'
     
    //Inicia a Janela 
    oApp:Activate()
Return 

User Function AAFINR01(xdPrefixo ,xdNumero,xdParcela,xEmail)

//LOCAL	aPergs     := {} 
 
Default xdPrefixo   := "" 
Default xdNumero    := ""
Default xdParcela   := ""
Default xEmail := .F.

PRIVATE lExec      := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
Private ldTela     := Empty(xdNumero)
Private lEmail := xEmail
Private xDirectory := If(ExistDir("C:\TEMP\"),"C:\TEMP\",GetTempPath(.T.) )

Tamanho  := "M"
titulo   := "Boleto do Itau"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "RMR010"
lEnd     := .F.
cPerg    := PADR("AAFINR01",Len(SX1->X1_GRUPO))
nTam     := TamSX3("E1_NUM")[1]
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0


AjustaSx1(cPerg)

If ldTela
   Pergunte(cPerg,.T.)
Else
   Pergunte(cPerg,.F.)
   xdPrefixo := Padr(xdPrefixo,TamSX3('E1_PREFIXO')[01])
   xdNumero := Padr(xdNumero,TamSX3('E1_NUM')[01])
   xdParcela := Padr(xdParcela,TamSX3('E1_PARCELA')[01])
   
   If Empty(xdParcela)
      xKey := xFilial('SE1') + xdPrefixo + xdNumero
   Else
      xKey := xFilial('SE1') + xdPrefixo + xdNumero + xdParcela
   EndIf
   SE1->(dbSetOrder(1))
   SE1->(dbSeek(xKey))

   mv_par01 := mv_par02 := SE1->E1_CLIENTE
   mv_par03 := mv_par04 := SE1->E1_PREFIXO
   mv_par05 := mv_par06 := SE1->E1_NUM
   if !Empty(xdParcela)
      mv_par07 := mv_par08 := SE1->E1_PARCELA
   Else
      mv_par07 := "  "
      mv_par08 := "zz"
   EndIf
   mv_par09 := mv_par10 := SE1->E1_EMISSAO
EndIf

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)                                                                          

cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+SE1->(xFilial())+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR01 + "'.And.E1_CLIENTE<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR03 + "'.And.E1_PREFIXO<='" + MV_PAR04 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR05 + "'.And.E1_NUM<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR07 + "'.And.E1_PARCELA<='" + MV_PAR08 + "'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par09)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par10)+"'.And."
cFilter		+= "E1_TIPO $ 'BOL,BO , NF '  .And." 
If ldTela
   cFilter		+= "(ALLTRIM(E1_XCONTA) = '341' .OR. E1_XCONTA = '          ')" 
Else
   cFilter		+= "( E1_XENVIO <> 'S')" 
EndIf
IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

cMarca	:= GetMark()

DbSelectArea("SE1")
dbGoTop()

if ldTela
   DEFINE MSDIALOG oDlg TITLE "Seleção de Titulos" FROM 00,00 TO 400,700 PIXEL

   oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

   oMark:oBrowse:Refresh()
   oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
   oMark:oBrowse:lHasMark    := .T.
   oMark:oBrowse:lCanAllMark := .F.

   oBtn0 := TButton():New( 180 , 245, "Email",oDlg,{||lEmail := lExec := .T.,oDlg:End() }, 30,11,,,.F.,.T.,.F.,,.F.,,,.F. )
   DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
   DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

   ACTIVATE MSDIALOG oDlg CENTERED
Else
   //SE1->(dbGoTop)
   lExec := .T.
   While !SE1->(Eof()) .And. SE1->E1_NUM == xdNumero .And. SE1->E1_PREFIXO == xdPrefixo .And. SE1->E1_PARCELA <= mv_par08
       SE1->(RecLock('SE1',.F.))
         SE1->E1_OK := cMarca
       SE1->(MsUnlock())
       SE1->(dbSkip())
   EndDo
EndIf
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif

DbSelectArea("SE1")
Set Filter to

RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

Static Function Marcar(cMarca,oSom)
   Local lOk := .T.

   If lOk
      RecLock("SE1",.F.)
      SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
      MsUnLock()
   Else
      Alert("Município inválido ("+AllTrim(SA1->A1_MUN)+") para impressão desse boleto !")
   Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 06/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS			     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL oPrint, cMaxPar, cQuery, cDocumen, dDataIni
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")                            ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText := {"", "", ""}

LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat     := 0

Private cNroDoc :=  " "
Private aDadosTit
Private lNew := .F.
Private aBoletos := {}
//lAdjustToLegacy := .T.
//lDisableSetup  := .T.
//lNew := FwAlertYesNo( 'Utiliza Nova Classe?' )
lNew := .T.
if lNew
   If lEmail
       oPrint:=GetPrintObj(.T.,.T.,"Boleto_"+StrTran(Time(),":",""))
   Else
      oPrint:=GetPrintObj(.T.,.T.,"Boleto_"+StrTran(Time(),":",""))
      oPrint:Setup()
   EndIf   
Else
oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
EndIf
//oPrint:StartPage()   // Inicia uma nova página

dbGoTop()
ProcRegua(RecCount())
While !EOF()
   dDataIni := mv_par11
   cDocumen := E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA
   While !EOF() .And. cDocumen == E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA

      IncProc()
      If E1_OK <> cMarca //Marked("E1_OK")
         dbSkip()
         Loop
      Endif

      If lEmail
         xDirectory := "\Boletos\"
         xPos := aScan(aBoletos,{|x| x[01]==E1_CLIENTE+E1_LOJA})
         
         if xPos == 0
            aAdd(aBoletos, {E1_CLIENTE+E1_LOJA,{}})
            xPos := Len(aBoletos)
         EndIf

         xFileName := E1_PREFIXO+E1_NUM+E1_PARCELA
         aAdd(aBoletos[xPos][02],"\Boletos\"+xFileName+".pdf")

         oPrint:= GetPrintObj(.T.,.T.,xFileName)
      EndIf      

      //Posiciona o SA1 (Cliente)
      SA1->(DbSetOrder(1))
      SA1->(DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))
     
      // Calcula o total de parcelas geradas para o titulo
      cQuery := "SELECT MAX(E1_PARCELA)E1_PARCELA FROM "+RetSQLName("SE1")+" WHERE D_E_L_E_T_=' ' AND E1_FILIAL='"
      cQuery += SE1->(XFILIAL())+"' AND E1_NUM='"+E1_NUM+"' AND E1_PREFIXO='"+E1_PREFIXO+"' AND E1_CLIENTE='"
      cQuery += E1_CLIENTE+"' AND E1_LOJA='"+E1_LOJA+"'"
      dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
      cMaxPar := E1_PARCELA
      dbCloseArea()
      dbSelectArea("SE1")

      cBanco 	:= "341"             
      

      cAgencia := Substr(GetMv("MV_XAGITA1"),01,05)
      cConta   := Substr(GetMv("MV_XCCITA1"),01,10)
      cSbConta := Substr(GetMv("MV_XSBITA1"),01,03)  
          
      //Posiciona o SA6 (Bancos)
      SA6->(DbSetOrder(1))
      SA6->(DbSeek(xFilial("SA6")+cBanco+PadR(cAgencia,05)+PadR(cConta,10),.T.))

      //Posiciona na Arq de Parametros CNAB
      SEE->(DbSetOrder(1))
      SEE->(DbSeek(xFilial("SEE")+cBanco+PadR(cAgencia,05)+PadR(cConta,10)+PadR(cSbConta,03),.T.))	
    
      DbSelectArea("SE1")
      
      aDadosBanco := {}
      aAdd(aDadosBanco,SA6->A6_COD   )                // [1]Codigo do Banco
      aAdd(aDadosBanco,SA6->A6_NREDUZ)                // [2]Nome do Banco
      aAdd(aDadosBanco,SUBSTR(SA6->A6_AGENCIA, 1, 5) )// [3]Agência
      
      If SEE->EE_DC == 'S'
         aAdd(aDadosBanco, SEE->EE_CONTA )  // [4]Conta Corrente      
         aAdd(aDadosBanco, SEE->EE_DVCTA )  // [5]Dígito da conta corrente
      Else
         aAdd(aDadosBanco,StrTran(SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),"-","") ) // [4]Conta Corrente      
         aAdd(aDadosBanco,SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1) )                   // [5]Dígito da conta corrente
      EndIf
      
      aAdd(aDadosBanco,SEE->EE_CODCART)// [6]Codigo da Carteira
      aAdd(aDadosBanco,SA6->A6_NUMBCO )// [7]Numero do Banco
      /*
      {"341",;                                                   // [1]Codigo do Banco
                      SA6->A6_NREDUZ,;                                                          // [2]Nome do Banco
                      SUBSTR(SA6->A6_AGENCIA, 1, 5),;                                           // [3]Agência
                      StrTran(SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),"-",""),; // [4]Conta Corrente
                      SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;                   // [5]Dígito da conta corrente
                      "109",;                                                                   // [6]Codigo da Carteira
                      SA6->A6_NUMBCO}                                                           // [7]Numero do Banco
      */
      If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
         aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razão Social
         AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]Código
         AllTrim(SA1->A1_END )                            ,;        // [3]Endereço
         AllTrim(SA1->A1_MUN )                            ,;        // [4]Cidade
         SA1->A1_EST                                      ,;        // [5]Estado
         SA1->A1_CEP                                      ,;        // [6]CEP
         SA1->A1_CGC									  ,;        // [7]CGC
         " "           									  ,;      	// [8]PESSOA
         AllTrim(SA1->A1_BAIRRO)                           }        // [9]Bairro   
      Else
         aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;    	// [1]Razão Social
         AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;    	// [2]Código
         AllTrim(SA1->A1_ENDCOB)                          ,;    	// [3]Endereço
         AllTrim(SA1->A1_MUNC)	                          ,;    	// [4]Cidade
         SA1->A1_ESTC	                                  ,;    	// [5]Estado
         SA1->A1_CEPC                                     ,;    	// [6]CEP
         SA1->A1_CGC								      ,;		// [7]CGC
         " "           								      ,;    	// [8]PESSOA
         AllTrim(SA1->A1_BAIRROC)                          }        // [9]Bairro   
      Endif

      nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

      //Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
      //Abaixo apenas uma sugestao
      cNroDoc := Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
      cNroDoc := STRZERO(Val(cNroDoc),11)

      aCB_RN_NN := Ret_cBarra( SE1->E1_PREFIXO , SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO,;
                   Subs(aDadosBanco[1],1,3), aDadosBanco[3], aDadosBanco[4], aDadosBanco[5],;
                   aDadosBanco[7], cNroDoc , (SE1->E1_VALOR-(nVlrAbat+SE1->E1_DECRESC)), aDadosBanco[6], "9")

      aDadosTit := {E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
                    If(Empty(cMaxPar),"","/"+cMaxPar)  ,;  // [1] Número do título
                    E1_EMISSAO                         ,;  // [2] Data da emissão do título
                    dDataBase                          ,;  // [3] Data da emissão do boleto
                    E1_VENCTO                         ,;  // [4] Data do vencimento
                    (E1_SALDO - nVlrAbat)              ,;  // [5] Valor do título
                    aCB_RN_NN[3]                       ,;  // [6] Nosso número (Ver fórmula para calculo)
                    E1_PREFIXO                         ,;  // [7] Prefixo da NF
                    "DM"                               ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
                    E1_DECRESC							}  // [9] Decrescimo

      aBolText    := {"","","",""}
      aBolText[1] := "APÓS VENCIMENTO MORA DIA DE R$ " + Alltrim(Transform((GETMV("MV_XJURIT") * (E1_SALDO - nVlrAbat)/100),"@E 99,999,999.99"))
      aBolText[2] := "MULTA DE "+Alltrim(str(GETMV("MV_XMULBOL")))+"% APÓS O VENCIMENTO"
      aBolText[3] := "SUJEITO A PROTESTO SE NÃO FOR PAGO NO VENCIMENTO"
      aBolText[4] := "FAVOR EFETUAR O PAGAMENTO SOMENTE ATRAVÉS DESTA COBRANÇA BANCÁRIA"
      //"Multa de "+str(GETMV("MV_XMULBOL"))+"% Após o Vencimento"
      If lNEw
         NImpress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
         //oPrint:EndPage()         
      else
         Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
      EndIf      
      if lEmail// Finaliza a página
         oPrint:Print()
         FreeObj(oPrint)
         oPrint:= Nil
      EndIf

      dbSkip()
   Enddo
EndDo
if lEmail
   For xI := 01 To Len(aBoletos)
      SA1->(dbSetOrder(1))
      if SA1->(dbSeek(xFilial('SA1') + aBoletos[xI][01]))
         //WERMESON
         xEmail := Alltrim(SA1->A1_EMAIL)+','+ALLTRIM(Posicione("SA3",1,XFILIAL("SA3")+SA1->A1_VEND,"A3_EMAIL"))
         COnOut("AAFINR01-CHECK")
         COnOut("Enviando Email dos Titulos para o e-mail " + xEmail)
         if EMpty(xEmail)
            FwAlertError('Error',"Cliente -> " + SA1->A1_COD+'-'+SA1->A1_LOJA + ' - ' + SA1->A1_NOME + ' e-mail em branco')
         else
            u_AAFSEMAIL(xEmail,"Boletos de Cobrança","<b>Segue seus Boletos de Cobrança<b>",aBoletos[xI][02])
         EndIf
      EndIf
   Next
Else
   //soPrint:EndPage()   // Finaliza a página
   oPrint:Print()
   FreeObj(oPrint)
   oPrint:= Nil
EndIf
     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 06/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont7
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp := 030
Local cLogo:= 030

cBmp := cStartPath + "ITAU.BMP" //Logo do Banco Itau   
cLogo := cStartPath + "LogoAA.BMP" //Logo da Amazon Aço   


//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7   := TFont():New("Arial"      ,9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial"      ,9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial"      ,9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont23  := TFont():New("Arial"      ,9,23,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

if lNEw
  nRow1 := 10
Else
  nRow1 := -50
EndIf
oPrint:Line (nRow1+0150, 100,nRow1+0150,2300)
oPrint:Line (nRow1+0080,1060,nRow1+0150,1060)
oPrint:Line (nRow1+0080,1250,nRow1+0150,1250)

If File(cBmp)
   //oPrint:SayBitmap(nRow1+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow1+0080, 180,"Banco Itaú S.A."  ,oFont14 )  // [2]Nome do Banco
oPrint:Say  (nRow1+0075,1073,aDadosBanco[1]+"-7",oFont18 )  // [1]Numero do Banco
oPrint:Say  (nRow1+0080,1820,"Recibo do Sacado" ,oFont11 )

oPrint:Line (nRow1+0250,100,nRow1+0250,2300 )
oPrint:Line (nRow1+0350,100,nRow1+0350,2300 )
oPrint:Line (nRow1+0420,100,nRow1+0420,2300 )
oPrint:Line (nRow1+0490,100,nRow1+0490,2300 )

oPrint:Line (nRow1+0350,500 ,nRow1+0490,500 )
oPrint:Line (nRow1+0420,750 ,nRow1+0490,750 )
oPrint:Line (nRow1+0350,1000,nRow1+0490,1000)
oPrint:Line (nRow1+0350,1300,nRow1+0420,1300)
oPrint:Line (nRow1+0350,1480,nRow1+0490,1480)

oPrint:Say  (nRow1+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow1+0190,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ",oFont9)
           
oPrint:Say  (nRow1+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0250,100 ,"Cedente",oFont8n)
oPrint:Say  (nRow1+0290,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow1+0250,1305,"CNPJ"                                   ,oFont8n)
oPrint:Say  (nRow1+0290,1305,aDadosEmp[6]                             ,oFont10) //CNPJ

oPrint:Say  (nRow1+0250,1810,"Agência / Código Cedente",oFont8n)
cString := Alltrim(Trim(aDadosBanco[3])+"/"+ Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0290,nCol,PADL(cString,17) ,oFont11c)

oPrint:Say  (nRow1+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow1+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow1+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow1+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow1+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow1+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow1+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow1+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow1+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow1+0350,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow1+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow1+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow1+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow1+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow1+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow1+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow1+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow1+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow1+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow1+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow1+0690,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow1+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow1+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830 //1810+(374-(len(cString)*22))
oPrint:Say  (nRow1+0520,nCol,PADL(cString,17) ,oFont11c)

//oPrint:Say  (nRow1+0560,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Say  (nRow1+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow1+0700,1810,"(+)Outros Acréscimos"                        ,oFont8n)
oPrint:Say  (nRow1+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)
/*
oPrint:Say  (nRow1+0840,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say  (nRow1+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow1+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow1+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow1+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow1+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow1+1030,1620,"Autenticação Mecânica"                       ,oFont8n)
*/
oPrint:Line (nRow1+0150,1800,nRow1+1790,1800 )//LINHA LATERAL
oPrint:Line (nRow1+0560,1800,nRow1+0560,2300 )
oPrint:Line (nRow1+0630,1800,nRow1+0630,2300 )
oPrint:Line (nRow1+0700,1800,nRow1+0700,2300 )
oPrint:Line (nRow1+0770,1800,nRow1+0770,2300 )
oPrint:Line (nRow1+0840,100 ,nRow1+0840,2300 )


If File(cLogo)
  //              altT   largT      largI  altI
  oPrint:SayBitmap(1000,  350, cLogo, 1000, 600)
Endif

/*
oPrint:Line (nRow1+1025,100 ,nRow1+1025,2300 )
  
vMens    := Array(4)
vMens[1] := "Recebimento através do cheque n.                                             do banco"
vMens[2] := "Esta quitação só terá validade após o pagamento do cheque pelo banco sacado."

oPrint:Say  (nRow1+1030,100 , vMens[1]                                     ,oFont8n)
oPrint:Say  (nRow1+1060,100 , vMens[2]                                     ,oFont8n)
  */
/*****************/
/* SEGUNDA PARTE */
/*****************/
nRow2 := nRow1 + 0950
/*  LINHA PONTILHADA
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0030, nI, nRow2+0030, nI+30)
Next nI
*/
/*
oPrint:Line (nRow2+0150, 100,nRow2+0150,2300)
oPrint:Line (nRow2+0080,1060,nRow2+0150,1060)
oPrint:Line (nRow2+0080,1250,nRow2+0150,1250)

If File(cBmp)
  // oPrint:SayBitmap(nRow2+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow2+0080, 180,"Banco Itaú S.A."  ,oFont14 )   // [2]Nome do Banco

oPrint:Say  (nRow2+0075,1073,aDadosBanco[1]+"-7",oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow2+0080,1820,"Ficha de Caixa"   ,oFont11 )

oPrint:Line (nRow2+0250,100,nRow2+0250,2300 )
oPrint:Line (nRow2+0350,100,nRow2+0350,2300 )
oPrint:Line (nRow2+0420,100,nRow2+0420,2300 )
oPrint:Line (nRow2+0490,100,nRow2+0490,2300 )

oPrint:Line (nRow2+0350,500 ,nRow2+0490,500 )
oPrint:Line (nRow2+0420,750 ,nRow2+0490,750 )
oPrint:Line (nRow2+0350,1000,nRow2+0490,1000)
oPrint:Line (nRow2+0350,1300,nRow2+0420,1300)
oPrint:Line (nRow2+0350,1480,nRow2+0490,1480)

oPrint:Say  (nRow2+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow2+0190,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ",oFont9)
           
oPrint:Say  (nRow2+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0250,100 ,"Cedente",oFont8n)
oPrint:Say  (nRow2+0290,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0250,1305,"CNPJ"                                     ,oFont8n)
oPrint:Say  (nRow2+0290,1305,aDadosEmp[6]                               ,oFont10) //CNPJ

oPrint:Say  (nRow2+0250,1810,"Agência / Código Cedente",oFont8n)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow2+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow2+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow2+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow2+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow2+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow2+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow2+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow2+0350,1810,"Nosso Número"                                 ,oFont8n)
cString  := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol 	 := 1830  //1880+(374-(len(cString)*22))
oPrint:Say  (nRow2+0380,nCol,PADL(cString,17),oFont11c)


oPrint:Say  (nRow2+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow2+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow2+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow2+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow2+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow2+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow2+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow2+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow2+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow2+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow2+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow2+0690,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow2+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow2+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0520,nCol,PADL(cString,17),oFont11c)

//oPrint:Say  (nRow2+0560,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Say  (nRow2+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow2+0700,1810,"(+)Outros Acréscimos"                        ,oFont8n)
oPrint:Say  (nRow2+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)
*/
oPrint:Say  (nRow2+0840,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say  (nRow2+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow2+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow2+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow2+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow2+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow2+1030,1620,"Autenticação Mecânica"                       ,oFont8n)
  
//oPrint:Line (nRow2+0150,1800,nRow2+0840,1800 )
//oPrint:Line (nRow2+0560,1800,nRow2+0560,2300 )
//oPrint:Line (nRow2+0630,1800,nRow2+0630,2300 )
//oPrint:Line (nRow2+0700,1800,nRow2+0700,2300 )
//oPrint:Line (nRow2+0770,1800,nRow2+0770,2300 )
oPrint:Line (nRow2+0840,100 ,nRow2+0840,2300 )

oPrint:Line (nRow2+1025,100 ,nRow2+1025,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow2 + 1125

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0030, nI, nRow3+0030, nI+30)
Next nI

oPrint:Line (nRow3+0150, 100,nRow3+0150,2300)
oPrint:Line (nRow3+0080, 660,nRow3+0150, 660)
oPrint:Line (nRow3+0080, 850,nRow3+0150, 850)

If File(cBmp)
   // oPrint:SayBitmap(nRow3+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow3+0080,180,"Banco Itaú S.A." ,oFont14 )  // [2]Nome do Banco

oPrint:Say  (nRow3+0075, 673,aDadosBanco[1]+"-7",oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow3+0084, 890,aCB_RN_NN[2]       ,oFont14)    // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)

oPrint:Say  (nRow3+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow3+0190,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ",oFont9)
           
oPrint:Say  (nRow3+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0250,100 ,"Cedente",oFont8n)
oPrint:Say  (nRow3+0290,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1305,"CNPJ"                                    ,oFont8n)
oPrint:Say  (nRow3+0290,1305,aDadosEmp[6]                              ,oFont10) //CNPJ

oPrint:Say  (nRow3+0250,1810,"Agência / Código Cedente",oFont8n)
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
cString := Alltrim(Trim(aDadosBanco[3])+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830  //1880+(374-(len(cString)*22))
oPrint:Say  (nRow3+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow3+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow3+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow3+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow3+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830   //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow3+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow3+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow3+0690,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow3+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0520,nCol,PADL(cString,17),oFont11c)

//oPrint:Say  (nRow3+0560,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow3+0700,1810,"(+)Outros Acréscimos"                        ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say  (nRow3+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow3+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow3+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow3+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow3+0985,1850,"Código de Baixa:"  ,oFont9)

oPrint:Say  (nRow3+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow3+1030,1620,"Autenticação Mecânica "  ,oFont8n)
oPrint:Say  (nRow3+1030,1900,"Ficha de Compensação "  ,oFont8)

oPrint:Line (nRow3+0150,1800,nRow3+0840,1800 )
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1025,100 ,nRow3+1025,2300 )

MSBAR2("INT25",26.1,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.7,Nil,Nil,"A",.F.,100,100)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a página

Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NImpress ³ Autor ³ Microsiga             ³ Data ³ 06/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NImpress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont7
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp := 030
Local cLogo:= 030
Local nLinSt := 00
Local nLine

cBmp := cStartPath + "ITAU.BMP" //Logo do Banco Itau   
cLogo := cStartPath + "LogoAA.BMP" //Logo da Amazon Aço   


//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7   := TFont():New("Arial"      ,9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial"      ,9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial"      ,9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont23  := TFont():New("Arial"      ,9,23,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := -10
nLine := 010
oPrint:Line(nRow1+0110, 100,nRow1+0110,2300)
oPrint:Line(nRow1+0040,1060,nRow1+0110,1060)
oPrint:Line(nRow1+0040,1250,nRow1+0110,1250)

If File(cBmp)
   //oPrint:SayBitmap(nRow1+0080,100,cBmp,75,65)
Endif
nLine += 80
oPrint:Say(nLine, 180,"Banco Itaú S.A."  ,oFont14 )  // [2]Nome do Banco
oPrint:Say(nLine - 5,1073,aDadosBanco[1]+"-7",oFont18 )  // [1]Numero do Banco
oPrint:Say(nLine,1820,"Recibo do Sacado" ,oFont11 )

oPrint:Line(nRow1+0190,100,nRow1+0190,2300 )//Linha Abaixo Local Pagamento
oPrint:Line(nRow1+0270,100,nRow1+0270,2300 )//Linha Abaixo Cedente
oPrint:Line(nRow1+0340,100,nRow1+0340,2300 )//Linha Abaixo Data do Documento
oPrint:Line(nRow1+0410,100,nRow1+0410,2300 )//Linha Uso banco
/*
oPrint:Line(nRow1+0420,100,nRow1+0420,2300 )
oPrint:Line(nRow1+0490,100,nRow1+0490,2300 )
*/
// Linhas Verticais Uso Banco | Carteira | Especie | Quantidade | Valor 
oPrint:Line(nRow1+0270,500 ,nRow1+0410,500 )
oPrint:Line(nRow1+0340,750 ,nRow1+0410,750 )
oPrint:Line(nRow1+0270,1000,nRow1+0410,1000)
oPrint:Line(nRow1+0270,1300,nRow1+0340,1300)
oPrint:Line(nRow1+0270,1480,nRow1+0410,1480)

/*
oPrint:Line(nRow1+0350,500 ,nRow1+0490,500 )
oPrint:Line(nRow1+0420,750 ,nRow1+0490,750 )
oPrint:Line(nRow1+0350,1000,nRow1+0490,1000)
oPrint:Line(nRow1+0350,1300,nRow1+0420,1300)
oPrint:Line(nRow1+0350,1480,nRow1+0490,1480)
*/
nLine += 030
oPrint:Say(nLIne,100 ,"Local de Pagamento",oFont8n)
oPrint:Say(nLine+040,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ",oFont9)
           
oPrint:Say(nLine,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine + 040,nCol,PADL(cString,17),oFont11c)

nLine += 80
oPrint:Say(nLIne,100 ,"Cedente",oFont8n)
oPrint:Say(nLine + 040,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say(nLine,1305,"CNPJ"                                   ,oFont8n)
oPrint:Say(nLine + 040,1305,aDadosEmp[6]                             ,oFont10) //CNPJ

oPrint:Say(nLine,1810,"Agência / Código Cedente",oFont8n)
cString := Alltrim(Trim(aDadosBanco[3])+"/"+ Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine + 040,nCol,PADL(cString,17) ,oFont11c)
nLine += 80
oPrint:Say(nLine,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say(nLine + 30,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say(nLine,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say(nLine + 30,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say(nLine,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say(nLine + 30,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say(nLine,1305,"Aceite"                                       ,oFont8n)
oPrint:Say(nLine + 30,1400,"N"                                            ,oFont10)

oPrint:Say(nLine,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say(nLine + 30,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say(nLine,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine+30,nCol,PADL(cString,17),oFont11c)

nLine += 70
oPrint:Say(nLine,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say(nLine + 30,150 ,"           "                                  ,oFont10)

oPrint:Say(nLine,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say(nLine + 30,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say(nLine,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say(nLine+30,805 ,"R$"                                           ,oFont10)

oPrint:Say(nLine,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say(nLine + 30,1485,"Valor"                                        ,oFont8n)

oPrint:Say(nLine,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine + 30,nCol,PADL(cString,17),oFont11c)

nLine += 70
oPrint:Say(nLine,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say(nLine+080,100 ,aBolText[1]  ,oFont10)
oPrint:Say(nLine+120,100 ,aBolText[2]  ,oFont10)
oPrint:Say(nLine+160,100 ,aBolText[3]  ,oFont10)
oPrint:Say(nLine+200,100 ,aBolText[4]  ,oFont10)

oPrint:Say(nLine,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830 //1810+(374-(len(cString)*22))
oPrint:Say(nLine+30,nCol,PADL(cString,17) ,oFont11c)
nLine+= 70
//oPrint:Say(nLine,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Line(nLine,1800,nLine,2300 )
nLine+= 70
oPrint:Line(nLine,1800,nLine,2300 )
//oPrint:Line(nLine+15,1800,nLine,2300 )
oPrint:Say(nLine+20,1810,"(+)Mora / Multa"                             ,oFont8n)
nLine+= 70
oPrint:Line(nLine,1800,nLine,2300 )
//oPrint:Say(nLine+15,1810,"(+)Outros Acréscimos"                        ,oFont8n)
nLine+= 70
oPrint:Line(nLine,1800,nLine,2300 )
oPrint:Say(nLine+20,1810,"(=)Valor Cobrado"                            ,oFont8n)
nLine+= 70
oPrint:Line(nLine,0100,nLine,2300 )

//oPrint:Line(nRow1+0110,1800,nRow1+1600,1800 )//LINHA LATERAL
/*
oPrint:Line(nRow1+0110,1800,nRow1+1790,1800 )//LINHA LATERAL
oPrint:Line(nRow1+0560,1800,nRow1+0560,2300 )
oPrint:Line(nRow1+0630,1800,nRow1+0630,2300 )
oPrint:Line(nRow1+0700,1800,nRow1+0700,2300 )
oPrint:Line(nRow1+0770,1800,nRow1+0770,2300 )
oPrint:Line(nRow1+0840,100 ,nRow1+0840,2300 )
*/

If File(cLogo)
  //              altT   largT      largI  altI
  oPrint:SayBitmap(1000,  350, cLogo, 1000, 600)
Endif

/*****************/
/* SEGUNDA PARTE */
/*****************/
nRow2 := nRow1 + 0700
oPrint:Line(nRow1+0110,1800,nRow2+840,1800 )//LINHA LATERAL
nLine += nRow2 + 860
oPrint:Say(nRow2+0860,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say(nRow2+0860,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say(nRow2+0860,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say(nRow2+0900,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say(nRow2+0940,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say(nRow2+1005, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say(nRow2+1050,1620,"Autenticação Mecânica"                       ,oFont8n)
  
oPrint:Line (nRow2+0840,100 ,nRow2+0840,2300 )
oPrint:Line (nRow2+1025,100 ,nRow2+1025,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow2 + 1125

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0030, nI, nRow3+0030, nI+30)
Next nI
nLine := nRow3 + 140

//oPrint:Line(nRow3+0150, 100,nRow3+0150,2300)
//oPrint:Line(nRow3+0080, 660,nRow3+0150, 660)
//oPrint:Line(nRow3+0080, 850,nRow3+0150, 850)

If File(cBmp)
   // oPrint:SayBitmap(nRow3+0080,100,cBmp,75,65)
Endif
oPrint:Say(nLine, 180,"Banco Itaú S.A."  ,oFont14 )  // [2]Nome do Banco
oPrint:Say(nLine - 5,673,aDadosBanco[1]+"-7",oFont18 )  // [1]Numero do Banco
oPrint:Say(nLine,0890,aCB_RN_NN[2] ,oFont11 )

nLine += 15
nLinSt := nLine

oPrint:Line(nLine,100,nLine,2300 )
oPrint:Line(nLine, 660,nLine-070, 660)
oPrint:Line(nLine, 850,nLine-070, 850)

//oPrint:Line(nRow3+0190,100,nRow1+0190,2300 )//Linha Abaixo Local Pagamento
//oPrint:Line(nRow3+0270,100,nRow1+0270,2300 )//Linha Abaixo Cedente
//oPrint:Line(nRow3+0340,100,nRow1+0340,2300 )//Linha Abaixo Data do Documento
//oPrint:Line(nRow3+0410,100,nRow1+0410,2300 )//Linha Uso banco
/*
oPrint:Line(nRow1+0420,100,nRow1+0420,2300 )
oPrint:Line(nRow1+0490,100,nRow1+0490,2300 )
*/
// Linhas Verticais Uso Banco | Carteira | Especie | Quantidade | Valor 
/*
oPrint:Line(nRow3+0270,500 ,nRow3+0410,500 )
oPrint:Line(nRow3+0340,750 ,nRow3+0410,750 )
oPrint:Line(nRow3+0270,1000,nRow3+0410,1000)
oPrint:Line(nRow3+0270,1300,nRow3+0340,1300)
oPrint:Line(nRow3+0270,1480,nRow3+0410,1480)
*/
/*
oPrint:Say  (nRow3+0080,180,"Banco Itaú S.A." ,oFont14 )  // [2]Nome do Banco
oPrint:Say  (nRow3+0075, 673,aDadosBanco[1]+"-7",oFont18 )   // [1]Numero do Banco
oPrint:Say  (nRow3+0084, 890,aCB_RN_NN[2]       ,oFont14)    // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)
*/
nLine += 015
oPrint:Say(nLIne,100 ,"Local de Pagamento",oFont8n)
oPrint:Say(nLine+040,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ",oFont9)
//nLine += 80
//oPrint:Say  (nRow3+0150,100 ,"Local de Pagamento",oFont8n)
//oPrint:Say  (nRow3+0190,100 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ",oFont9)
           
oPrint:Say(nLine,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say(nLine + 40,nCol,PADL(cString,17),oFont11c)
/*
nLine += 80
oPrint:Say(nLine,100 ,"Cedente",oFont8n)
oPrint:Say(nLine,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1305,"CNPJ"                                    ,oFont8n)
oPrint:Say  (nRow3+0290,1305,aDadosEmp[6]                              ,oFont10) //CNPJ

oPrint:Say  (nRow3+0250,1810,"Agência / Código Cedente",oFont8n)
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
cString := Alltrim(Trim(aDadosBanco[3])+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830  //1880+(374-(len(cString)*22))
oPrint:Say  (nRow3+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow3+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow3+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow3+0420,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say  (nRow3+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830   //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow3+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow3+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow3+0690,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow3+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0520,nCol,PADL(cString,17),oFont11c)

//oPrint:Say  (nRow3+0560,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow3+0700,1810,"(+)Outros Acréscimos"                        ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say  (nRow3+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow3+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow3+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow3+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado
*/
//oPrint:Line(nLine + 0,100,nLine+50,2300 )
nLine += 80
oPrint:Line(nLine - 20,100,nLine - 20,2300 )

oPrint:Say(nLIne,100 ,"Cedente",oFont8n)
oPrint:Say(nLine + 040,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say(nLine,1305,"CNPJ"                                   ,oFont8n)
oPrint:Say(nLine + 040,1305,aDadosEmp[6]                             ,oFont10) //CNPJ

oPrint:Say(nLine,1810,"Agência / Código Cedente",oFont8n)
cString := Alltrim(Trim(aDadosBanco[3])+"/"+ Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine + 040,nCol,PADL(cString,17) ,oFont11c)
nLine += 80
oPrint:Line(nLine - 20,100,nLine - 20,2300 )
oPrint:Say(nLine,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say(nLine + 30,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

//oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line(nLine-20,500 ,nLine+120,500 )
oPrint:Line(nLine-20,1000,nLine+120,1000)
oPrint:Line(nLine-20,1300,nLine+050,1300)
oPrint:Line(nLine-20,1480,nLine+120,1480)
//oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
//oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
//oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)
oPrint:Say(nLine,505 ,"Nº do Documento"                              ,oFont8n)
oPrint:Say(nLine + 30,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say(nLine,1005,"Espécie Doc."                                 ,oFont8n)
oPrint:Say(nLine + 30,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say(nLine,1305,"Aceite"                                       ,oFont8n)
oPrint:Say(nLine + 30,1400,"N"                                            ,oFont10)

oPrint:Say(nLine,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say(nLine + 30,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say(nLine,1810,"Nosso Número"                                 ,oFont8n)
cString := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine+30,nCol,PADL(cString,17),oFont11c)

nLine += 70
oPrint:Line (nLine-20,750,nLine+050,750)
oPrint:Line(nLine - 20,100,nLine - 20,2300 )
oPrint:Say(nLine,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say(nLine + 30,150 ,"           "                                  ,oFont10)

/*
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)
*/
oPrint:Say(nLine,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say(nLine + 30,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say(nLine,755 ,"Espécie"                                      ,oFont8n)
oPrint:Say(nLine+30,805 ,"R$"                                           ,oFont10)

oPrint:Say(nLine,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say(nLine + 30,1485,"Valor"                                        ,oFont8n)

oPrint:Say(nLine,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say(nLine + 30,nCol,PADL(cString,17),oFont11c)

nLine += 70

oPrint:Line(nLine - 20,100,nLine - 20,2300 )
oPrint:Say(nLine,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say(nLine+080,100 ,aBolText[1]  ,oFont10)
oPrint:Say(nLine+120,100 ,aBolText[2]  ,oFont10)
oPrint:Say(nLine+160,100 ,aBolText[3]  ,oFont10)
oPrint:Say(nLine+200,100 ,aBolText[4]  ,oFont10)

oPrint:Say(nLine,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830 //1810+(374-(len(cString)*22))
oPrint:Say(nLine+30,nCol,PADL(cString,17) ,oFont11c)
nLine+= 70
//oPrint:Say(nLine,1810,"(-)Outras Deduções"                          ,oFont8n)
oPrint:Line(nLine,1800,nLine,2300 )
nLine+= 70
oPrint:Line(nLine,1800,nLine,2300 )
//oPrint:Line(nLine+15,1800,nLine,2300 )
oPrint:Say(nLine+20,1810,"(+)Mora / Multa"                             ,oFont8n)
nLine+= 70
oPrint:Line(nLine,1800,nLine,2300 )
//oPrint:Say(nLine+15,1810,"(+)Outros Acréscimos"                        ,oFont8n)
nLine+= 70
oPrint:Line(nLine,1800,nLine,2300 )
oPrint:Say(nLine+20,1810,"(=)Valor Cobrado"                            ,oFont8n)
nLine+= 70
oPrint:Line(nLine,0100,nLine,2300 )
oPrint:Line(nLine,1800,nLinSt,1800 )//Linha Vertical 

nLine += 25
oPrint:Say(nLine,100 ,"Sacado"                                      ,oFont8n)
oPrint:Say(nLine,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say(nLine,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ
nLine += 40
oPrint:Say(nLine,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
nLine += 40
oPrint:Say(nLine,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

nLine += 40
oPrint:Say(nLine,1850,"Código de Baixa:"  ,oFont9)
oPrint:Say(nLine, 100,"Sacador/Avalista"                            ,oFont8n)

oPrint:Line(nLine+20,0100,nLine+20,2300 )
nLine += 40
oPrint:Say(nLine,1620,"Autenticação Mecânica "  ,oFont8n)
oPrint:Say(nLine,1900,"Ficha de Compensação "  ,oFont8)
nLIne += 40

/*
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )
*/
//soPrint:Line (nRow3+1025,100 ,nRow3+1025,2300 )
//oPrinter:FWMSBAR("INT25" /*cTypeBar*/,nLine/*nRow*/ ,1/*nCol*/ ,cCodEAN  /*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/, /*nWidth*/,/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
oPrint:Int25(nLine,100,aCB_RN_NN[1],1,28,.F.,.F.,)
//oPrinter:MSBAR2("INT25",26.1,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.7,Nil,Nil,"A",.F.,100,100)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a página

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetDados  ºAutor  ³Microsiga           º Data ³  06/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera SE1                        					          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,;
                            cDacCC,cNumBco,cNroDoc,nValor,cCart,cMoeda)
Local cNosso	  := ""
Local cDigNosso  := ""
Local cCampoL	  := ""
Local cFatorValor:= ""
Local cLivre	  := ""
Local cDigBarra  := ""
Local cBarra	  := ""
Local cParte1	  := ""
Local cDig1		  := ""
Local cParte2	  := ""
Local cDig2		  := ""
Local cParte3	  := ""
Local cDig3		  := ""
Local cParte4	  := ""
Local cParte5	  := ""
Local cDigital	  := ""
Local aRet		  := {}

cAgencia := Left(Alltrim(cAgencia),4)

// Nosso Numero
If Empty(SE1->E1_NUMBCO)
   cNosso := cCart + strzero(val(AllTrim(Str(Val(_NossoNum()),8))),8)
   cNosso += Modulo10( cAgencia+Left(cConta,5)+cNosso )
Else
   cNosso := AllTrim(SE1->E1_NUMBCO)
Endif

//Campo Livre
cCampoL  := cNosso + cAgencia + AllTrim(cConta) + AllTrim(cDacCC) + "000"

// Campo livre do codigo de barra                   // verificar a conta
If nValor <= 0
   nValor := SE1->E1_VALOR
Endif
cFatorValor := Fator(SE1->E1_VENCTO) + StrZero(nValor * 100,10)

cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
cDigBarra := CALC_5p( cLivre )
cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,39)

// composicao da linha digitavel
cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
cDig1    := DIGIT001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := DIGIT001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := DIGIT001( cParte3 )
cParte4  := cDigBarra
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cParte1,6,4)+cDig1+" "+;
			substr(cParte2,1,5)+"."+substr(cParte2,6,5)+cDig2+" "+;
			substr(cParte3,1,5)+"."+substr(cParte3,6,5)+cDig3+" "+;
			cParte4+" "+;
			cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)

DbSelectArea("SE1")
RecLock("SE1",.F.)
SE1->E1_NUMBCO := cNosso   // Nosso número  
SE1->E1_PORCJUR := GETMV("MV_XJURIT")
SE1->E1_XCONTA := "341"
If !ldTela
   SE1->E1_XENVIO := "S"
EndIf


MsUnlock()

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DIGIT001  ºAutor  ³Microsiga           º Data ³  06/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo da linha digitavel do Unibanco                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DIGIT001(cVariavel)
   Local cBase, nUmDois, nSumDig, nDig, nAux, cValor, nDezena

   cBase   := cVariavel
   nUmDois := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nUmDois
      nSumDig += (nAux - If( nAux < 10 , 0, 9))
      nUmDois := 3 - nUmDois
   Next
   cValor := AllTrim(Str(nSumDig,12))
   nAux   := 10 - Val(SubStr(cValor,Len(cValor),1))
   //nDezena := Val(AllTrim(Str(Val(SubStr(cValor,1,1))+1,12))+"0")
   //nAux    := nDezena - nSumDig

   If nAux == 10
      nAux := 0
   EndIf

Return(Str(nAux,1))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FATOR		ºAutor  ³Microsiga           º Data ³  06/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do FATOR  de vencimento para linha digitavel.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Fator(dVencto)
   Local cData  := DTOS(dVencto)
   Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return(cFator)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_5p   ºAutor  ³Microsiga           º Data ³  06/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito do nosso numero do                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CALC_5p(cVariavel,lNosso)
   Local cBase, nBase, nAux, nSumDig, nDig

   cBase   := cVariavel
   nBase   := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
      nSumDig += nAux
      nBase   += If( nBase == 9 , -7, 1)
   Next

   nAux := Mod(nSumDig * 10,11)
   If nAux == 0 .Or. nAux == 10
      If lNosso
         nAux := 0
      Else
         nAux := 1
      Endif
   Endif

Return(Str(nAux,1))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Modulo10 ºAutor  ³Microsiga           º Data ³  36/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito do nosso numero do pelo Modulo 10        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Modulo10(cVariavel)
   Local cBase, nBase, nAux, nSumDig, nDig

   cBase   := cVariavel
   nBase   := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
      nAux    -= If( nAux > 9 , 9, 0)
      nSumDig += nAux
      nBase   := If( nBase == 2 , 1, 2)
   Next

   nAux := 10 - Mod(nSumDig,10)
   If nAux == 10
      nAux := 0
   Endif

Return(Str(nAux,1))

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 06/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function AjustaSx1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Do Cliente'          , '', '', 'mv_ch1', 'C', 6, 0, 0, 'G', '',   'SA1',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Cliente'         , '', '', 'mv_ch2', 'C', 6, 0, 0, 'G', '',   'SA1',  '', '', 'mv_par02')
	U_PIPutSx1(cPerg, '03', 'De Prefixo'          , '', '', 'mv_ch3', 'C', 3, 0, 0, 'G', '',      '',  '', '', 'mv_par03')
	U_PIPutSx1(cPerg, '04', 'Ate Prefixo'         , '', '', 'mv_ch4', 'C', 3, 0, 0, 'G', '',      '',  '', '', 'mv_par04')
	U_PIPutSx1(cPerg, '05', 'Do Numero'           , '', '', 'mv_ch5', 'C', 9, 0, 0, 'G', '',      '',  '', '', 'mv_par05')
	U_PIPutSx1(cPerg, '06', 'Até Numero'          , '', '', 'mv_ch6', 'C', 9, 0, 0, 'G', '',      '',  '', '', 'mv_par06')
	U_PIPutSx1(cPerg, '07', 'Da Parcela'          , '', '', 'mv_ch7', 'C', 1, 0, 0, 'G', '',      '',  '', '', 'mv_par07')
	U_PIPutSx1(cPerg, '08', 'Até Parcela'         , '', '', 'mv_ch8', 'C', 1, 0, 0, 'G', '',      '',  '', '', 'mv_par08')
	U_PIPutSx1(cPerg, '09', 'Da Emissao'          , '', '', 'mv_ch8', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par09')
	U_PIPutSx1(cPerg, '10', 'Ate Emissao'         , '', '', 'mv_ch9', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par10')
	    
Return


Static Function _NossoNum()

Local cNumero := ""
Local nTam := TamSx3("EE_FAXATU")[1]

// Enquanto nao conseguir criar o semaforo, indica que outro usuario
// esta tentando gerar o nosso numero.
cNumero := StrZero(Val(SEE->EE_FAXATU),nTam)

//While !MayIUseCode( SEE->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA))  //verifica se esta na memoria, sendo usado
While !MayIUseCode( cNumero )  //verifica se esta na memoria, sendo usado
	cNumero := Soma1(cNumero)										// busca o proximo numero disponivel 
EndDo

If Empty(SE1->E1_NUMBCO)
	
	RecLock("SE1",.F.)
	Replace SE1->E1_NUMBCO With cNumero
	SE1->( MsUnlock( ) )
	
	RecLock("SEE",.F.)
	Replace SEE->EE_FAXATU With Soma1(cNumero, nTam)
	SEE->( MsUnlock() )
	
EndIf	

Leave1Code(SEE->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA))
DbSelectArea("SE1")

Return(SE1->E1_NUMBCO)

Static Function GetPrintObj(lAdjustToLegacy,lDisableSetup,xName)
  //Local lAdjustToLegacy := .T.
  //Local lDisableSetup := .T.
  Local oPrint := Nil

  oPrint := FWMSPrinter():New(xName+".rel", IMP_PDF, lAdjustToLegacy, xDirectory, lDisableSetup, , , , , , .F., )// Ordem obrigátoria de configuração do relatório
  oPrint:SetResolution(72)
  oPrint:SetPortrait()
  oPrint:SetPaperSize(DMPAPER_A4)
//oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
  oPrint:cPathPDF := xDirectory//"\"//"C:\boletos\" // Caso seja utilizada impressão em IMP_PDF
  oPrint:cPathPrint := xDirectory
  oPrint:lServer := .T.
  oPrint:SetViewPDF(!lEmail)
  //oPrint:SetViewPDF(.T.)
Return oPrint

User Function AAFSEMAIL(xEmail,xAssunto,xBody,xFiles)
  Local _odEmail := odEmail():New("")

  _odEmail:setTo( xEmail )
  _odEmail:setAssunto(xAssunto)
  _odEmail:SetBOdy(xBody)
  _odEmail:SetAttach(xFiles)

  _xdRet := _odEmail:ConectServer()
  If !Empty(_xdRet)
	    If !isBlind()
	    	 FwALertError('Atencao',_xdRet)
	    Else
	       Conout(_xdRet)
	    EndIf
  Endif

	If Empty(_xdRet)
		_xdRet := _odEmail:SendMail()
		If !Empty(_xdRet)
			If isBlind()
			 	//FwALertError('',_xdRet)
				Conout(_xdRet)
			EndIf
		EndIf
	EndIf

Return NIl
