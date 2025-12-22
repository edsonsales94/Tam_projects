#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ RAMR010  ณ Autor ณ Microsiga             ณ Data ณ 27/12/16 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO ITAU alienado ao Banco SAFRA           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/**/

User Function AAFINR04(cPrefixo,cNumero)

LOCAL	aPergs     := {} 

Default cPrefixo   := ""
Default cNumero    := ""

PRIVATE lExec      := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

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

If Empty(cNumero)
    Pergunte(cPerg,.T.)
EndIf

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)

cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO) "
cFilter		+= "E1_FILIAL=='"+SE1->(xFilial())+"'.And.E1_SALDO>0.And. "
cFilter		+= "E1_CLIENTE>='" + MV_PAR01 + "'.And.E1_CLIENTE<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR03 + "'.And.E1_PREFIXO<='" + MV_PAR04 + "'.And. "
cFilter		+= "E1_NUM>='" + MV_PAR05 + "'.And.E1_NUM<='" + MV_PAR06 + "'  .And. "
cFilter		+= "E1_PARCELA>='" + MV_PAR07 + "'.And.E1_PARCELA<='" + MV_PAR08 + "'.And. "
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par09)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par10)+"' .And. "
cFilter		+= "Alltrim(E1_TIPO)$ 'BOL,BO,NF'  .And." 
cFilter		+= "(ALLTRIM(E1_XCONTA) = '422' .OR. E1_XCONTA = '          ')" 

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

cMarca	:= GetMark()

DbSelectArea("SE1")
dbGoTop()
DEFINE MSDIALOG oDlg TITLE "Sele็ใo de Titulos" FROM 00,00 TO 400,700 PIXEL

oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

oMark:oBrowse:Refresh()
oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .F.

DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTERED
	
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
      Alert("Municํpio invแlido ("+AllTrim(SA1->A1_MUN)+") para impressใo desse boleto !")
   Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  MontaRelณ Autor ณ Microsiga             ณ Data ณ 06/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS			     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaRel()
LOCAL oPrint, cMaxPar, cQuery, cDocumen, dDataIni
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     ,; //[2]Endere็o
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
oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova pแgina

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

      cBanco 	:= "422"

      cAgencia := Substr(GetMv("MV_XSAFAG1"),01,05)
      cConta   := Substr(GetMv("MV_XSAFCC1"),01,10)
      cSbConta := Substr(GetMv("MV_XSAFSC1"),01,03)  
          
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
      aAdd(aDadosBanco,SUBSTR(SA6->A6_AGENCIA, 1, 5) )// [3]Ag๊ncia
      
      If SEE->EE_DC == 'S'
         aAdd(aDadosBanco, SEE->EE_CONTA )  // [4]Conta Corrente      
         aAdd(aDadosBanco, SEE->EE_DVCTA )  // [5]Dํgito da conta corrente
      Else
         aAdd(aDadosBanco,StrTran(SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),"-","") ) // [4]Conta Corrente      
         aAdd(aDadosBanco,SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1) )                   // [5]Dํgito da conta corrente
      EndIf
      
      aAdd(aDadosBanco,SEE->EE_CODCART)// [6]Codigo da Carteira
      aAdd(aDadosBanco,SA6->A6_NUMBCO )// [7]Numero do Banco
      
      /*
      aDadosBanco := {SA6->A6_COD,;                                                   // [1]Codigo do Banco
                      SA6->A6_NREDUZ,;                                                          // [2]Nome do Banco
                      SUBSTR(SA6->A6_AGENCIA, 1, 5),;                                           // [3]Ag๊ncia
                      StrTran(SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),"-",""),; // [4]Conta Corrente
                      SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;                   // [5]Dํgito da conta corrente
                      "001",;                                                                   // [6]Codigo da Carteira
                      SA6->A6_NUMBCO}                                                           // [7]Numero do Banco
      */
      If Empty(SA1->A1_ENDCOB) .Or. "MESMO" $ SA1->A1_ENDCOB
         aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;        // [1]Razใo Social
         AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;        // [2]C๓digo
         AllTrim(SA1->A1_END )                            ,;        // [3]Endere็o
         AllTrim(SA1->A1_MUN )                            ,;        // [4]Cidade
         SA1->A1_EST                                      ,;        // [5]Estado
         SA1->A1_CEP                                      ,;        // [6]CEP
         SA1->A1_CGC									  ,;        // [7]CGC
         " "           									  ,;      	// [8]PESSOA
         AllTrim(SA1->A1_BAIRRO)                           }        // [9]Bairro   
      Else
         aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;    	// [1]Razใo Social
         AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;    	// [2]C๓digo
         AllTrim(SA1->A1_ENDCOB)                          ,;    	// [3]Endere็o
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
      
      _xdIdCnab := _GetIdCnab()
      xdDocument := SE1->E1_PREFIXO+SE1->E1_NUM+If(Empty(SE1->E1_PARCELA),"","-"+SE1->E1_PARCELA)
      aDadosTit := {xdDocument                              ,;  // [1] N๚mero do tํtulo
                    SE1->E1_EMISSAO                         ,;  // [2] Data da emissใo do tํtulo
                    dDataBase                               ,;  // [3] Data da emissใo do boleto
                    SE1->E1_VENCTO                          ,;  // [4] Data do vencimento
                    (SE1->E1_SALDO - nVlrAbat)              ,;  // [5] Valor do tํtulo
                    aCB_RN_NN[3]                            ,;  // [6] Nosso n๚mero (Ver f๓rmula para calculo)
                    SE1->E1_PREFIXO                         ,;  // [7] Prefixo da NF
                    "DM"                                    ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
                    SE1->E1_DECRESC							}  // [9] Decrescimo
                 
      /*
      aDadosTit := {E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
                    If(Empty(cMaxPar),"","/"+cMaxPar)  ,;  // [1] N๚mero do tํtulo
                    E1_EMISSAO                         ,;  // [2] Data da emissใo do tํtulo
                    dDataBase                          ,;  // [3] Data da emissใo do boleto
                    E1_VENCTO                         ,;  // [4] Data do vencimento
                    (E1_SALDO - nVlrAbat)              ,;  // [5] Valor do tํtulo
                    aCB_RN_NN[3]                       ,;  // [6] Nosso n๚mero (Ver f๓rmula para calculo)
                    E1_PREFIXO                         ,;  // [7] Prefixo da NF
                    "DM"                               ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
                    E1_DECRESC							}  // [9] Decrescimo
      */
      
      SE1->(RecLock("SE1",.F.))       
      SE1->E1_PORCJUR := GETMV("MV_XJURIT")      
      SE1->E1_VALJUR := IIf(Empty(SE1->E1_VALJUR),aDadosTit[5]*SE1->E1_PORCJUR / 100, SE1->E1_VALJUR)
      //SE1->E1_IDCNAB := _xdIdCnab
      SE1->(MsUnlock())
      
      aBolText    := {"","","","",""}
      aBolText[1] := "APำS VENCIMENTO MORA DIA DE R$ " + Alltrim(Transform( SE1->E1_VALJUR ,"@E 99,999,999.99"))
      aBolText[2] := "MULTA DE "+Alltrim(str(GETMV("MV_XMULBOL")))+"% APำS O VENCIMENTO"
      aBolText[3] := "SUJEITO A PROTESTO SE NรO FOR PAGO NO VENCIMENTO"
      aBolText[4] := "FAVOR EFETUAR O PAGAMENTO SOMENTE ATRAVษS DESTA COBRANวA BANCมRIA"
      aBolText[5] := ""//"  VEDADO O PAGAMENTO DE QUALQUER OUTRA FORMA QUE NรO ATRAVษS DO PRESENTE BOLETO"

      Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)

      dbSkip()
   Enddo
EndDo

oPrint:EndPage()     // Finaliza a pแgina
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  Impress ณ Autor ณ Microsiga             ณ Data ณ 06/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
cLogo := cStartPath + "LogoAA.BMP" //Logo da Amazon A็o   


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

oPrint:StartPage()   // Inicia uma nova pแgina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := -50
 
oPrint:Line (nRow1+0150, 100,nRow1+0150,2300)
oPrint:Line (nRow1+0080,1060,nRow1+0150,1060)
oPrint:Line (nRow1+0080,1250,nRow1+0150,1250)

If File(cBmp)
   //oPrint:SayBitmap(nRow1+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow1+0080, 180,"Banco Safra S.A."  ,oFont14 )  // [2]Nome do Banco
oPrint:Say  (nRow1+0075,1073,""/*aDadosBanco[1]+"-7"*/,oFont18 )  // [1]Numero do Banco
oPrint:Say  (nRow1+0080,1820,"Recibo do Pagador" ,oFont11 )

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
oPrint:Say  (nRow1+0190,100 ,"ATษ O VENCIMENTO PAGAVEL EM QUALQUER BANCO.",oFont9)
           
oPrint:Say  (nRow1+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0250,100 ,"Beneficiแrio",oFont8n)
oPrint:Say  (nRow1+0290,100 ,aDadosEmp[1],oFont10) //Nome + CNPJ

oPrint:Say  (nRow1+0250,1305,"CNPJ"                                     ,oFont8n)
//oPrint:Say  (nRow1+0290,1305,"058.160.789/0001-28"/*aDadosEmp[6]*/    ,oFont10) //CNPJ
oPrint:Say  (nRow1+0290,1305,aDadosEmp[6]    ,oFont10) //CNPJ

oPrint:Say  (nRow1+0250,1810,"Ag๊ncia / C๓digo Beneficiแrio",oFont8n)
cString := Alltrim(Trim(aDadosBanco[3])+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0290,nCol,PADL(cString,17) ,oFont11c)

oPrint:Say  (nRow1+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow1+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow1+0350,505 ,"Nบ do Documento"                              ,oFont8n)
oPrint:Say  (nRow1+0380,605 ,aDadosTit[1]                                   ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0350,1005,"Esp้cie Doc."                                 ,oFont8n)
oPrint:Say  (nRow1+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow1+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow1+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow1+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow1+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow1+0350,1810,"Nosso N๚mero"                                 ,oFont8n)
//cString := Transform(aDadosTit[6],"@R 999/99999999-9")
cString := Transform( SubStr(aDadosTit[6],4) ,"@R 99999999-9")
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow1+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow1+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow1+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow1+0420,755 ,"Esp้cie"                                      ,oFont8n)
oPrint:Say  (nRow1+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow1+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow1+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow1+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830 //1810+(374-(len(cString)*20))
oPrint:Say  (nRow1+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow1+0490,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio.)",oFont8n)
oPrint:Say  (nRow1+0590,100 ,aBolText[1]  ,oFont8n)
oPrint:Say  (nRow1+0640,100 ,aBolText[2]  ,oFont8n)
oPrint:Say  (nRow1+0690,100 ,aBolText[3]  ,oFont8n)
oPrint:Say  (nRow1+0740,100 ,aBolText[4]  ,oFont8n)
oPrint:Say  (nRow1+0790,100 ,aBolText[5]  ,oFont8n)

oPrint:Say  (nRow1+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830 //1810+(374-(len(cString)*22))
oPrint:Say  (nRow1+0520,nCol,PADL(cString,17) ,oFont11c)

//oPrint:Say  (nRow1+0560,1810,"(-)Outras Dedu็๕es"                          ,oFont8n)
oPrint:Say  (nRow1+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow1+0700,1810,"(+)Outros Acr้scimos"                        ,oFont8n)
oPrint:Say  (nRow1+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)
/*
oPrint:Say  (nRow1+0840,100 ,"Pagador"                                      ,oFont8n)
oPrint:Say  (nRow1+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow1+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow1+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow1+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow1+0985, 100,"Sacador/Avalista"                            ,oFont8n)
oPrint:Say  (nRow1+1030,1620,"Autentica็ใo Mecโnica"                       ,oFont8n)
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
vMens[1] := "Recebimento atrav้s do cheque n.                                             do banco"
vMens[2] := "Esta quita็ใo s๓ terแ validade ap๓s o pagamento do cheque pelo banco Pagador."

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
oPrint:Say  (nRow2+0080, 180,"Banco Ita๚ S.A."  ,oFont14 )   // [2]Nome do Banco

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
oPrint:Say  (nRow2+0190,100 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAฺ. APำS O VENCIMENTO, SOMENTE NO ITAฺ",oFont9)
           
oPrint:Say  (nRow2+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0250,100 ,"Cedente",oFont8n)
oPrint:Say  (nRow2+0290,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0250,1305,"CNPJ"                                     ,oFont8n)
oPrint:Say  (nRow2+0290,1305,aDadosEmp[6]                               ,oFont10) //CNPJ

oPrint:Say  (nRow2+0250,1810,"Ag๊ncia / C๓digo Beneficiแrio",oFont8n)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow2+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow2+0350,505 ,"Nบ do Documento"                              ,oFont8n)
oPrint:Say  (nRow2+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0350,1005,"Esp้cie Doc."                                 ,oFont8n)
oPrint:Say  (nRow2+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow2+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow2+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow2+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow2+0350,1810,"Nosso N๚mero"                                 ,oFont8n)
cString  := Transform(aDadosTit[6],"@R 999/99999999-9")
nCol 	 := 1830  //1880+(374-(len(cString)*22))
oPrint:Say  (nRow2+0380,nCol,PADL(cString,17),oFont11c)


oPrint:Say  (nRow2+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow2+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow2+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow2+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow2+0420,755 ,"Esp้cie"                                      ,oFont8n)
oPrint:Say  (nRow2+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow2+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow2+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow2+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow2+0490,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente.)",oFont8n)
oPrint:Say  (nRow2+0590,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow2+0640,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow2+0690,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow2+0740,100 ,aBolText[4]  ,oFont10)

oPrint:Say  (nRow2+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0520,nCol,PADL(cString,17),oFont11c)

//oPrint:Say  (nRow2+0560,1810,"(-)Outras Dedu็๕es"                          ,oFont8n)
oPrint:Say  (nRow2+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow2+0700,1810,"(+)Outros Acr้scimos"                        ,oFont8n)
oPrint:Say  (nRow2+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)
*/
oPrint:Say  (nRow2+0840,100 ,"Pagador"                                      ,oFont8n)
oPrint:Say  (nRow2+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow2+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow2+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow2+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow2+0985, 100,"Sacador / Avalista"                            ,oFont8n)
//oPrint:Say  (nRow2+0985, 400, aDadosEmp[1] + "   " + aDadosEmp[6]          ,oFont8n)
oPrint:Say  (nRow2+1030,1620,"Autentica็ใo Mecโnica"                       ,oFont8n)
  
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
//oPrint:Say  (nRow3+0080,180,"Banco Ita๚ S.A." ,oFont14 )  // [2]Nome do Banco
oPrint:Say  (nRow3+0080,180,"Banco Safra S.A." ,oFont14 )  // [2]Nome do Banco

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
oPrint:Say  (nRow3+0190,100 ,"ATษ O VENCIMENTO PAGAVEL EM QUALQUER BANCO.",oFont9)
           
oPrint:Say  (nRow3+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0190,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0250,100 ,"Beneficiแrio",oFont8n)
oPrint:Say  (nRow3+0290,100 ,aDadosEmp[1] ,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1305,"CNPJ"                        ,oFont8n)
oPrint:Say  (nRow3+0290,1305,aDadosEmp[6]                  ,oFont10) //CNPJ

oPrint:Say  (nRow3+0250,1810,"Ag๊ncia / C๓digo Beneficiแrio",oFont8n)
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
cString := Alltrim(Trim(aDadosBanco[3])+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0290,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,505 ,"Nบ do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,605 ,aDadosTit[1]                                   ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Esp้cie Doc."                                 ,oFont8n)
oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso N๚mero"                                 ,oFont8n)
//cString := Transform(aDadosTit[6],"@R 999/99999999-9")
cString := Transform( SubStr(aDadosTit[6],4) ,"@R 99999999-9")
nCol    := 1830  //1880+(374-(len(cString)*22))
oPrint:Say  (nRow3+0380,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow3+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow3+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow3+0420,755 ,"Esp้cie"                                      ,oFont8n)
oPrint:Say  (nRow3+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"(=)Valor do Documento"                     	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol    := 1830   //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0450,nCol,PADL(cString,17),oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio.)",oFont8n)
oPrint:Say  (nRow3+0590,100 ,aBolText[1]  ,oFont8n)
oPrint:Say  (nRow3+0640,100 ,aBolText[2]  ,oFont8n)
oPrint:Say  (nRow3+0690,100 ,aBolText[3]  ,oFont8n)
oPrint:Say  (nRow3+0740,100 ,aBolText[4]  ,oFont8n)
oPrint:Say  (nRow1+0790,100 ,aBolText[5]  ,oFont8n)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol    := 1830  //1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0520,nCol,PADL(cString,17),oFont11c)

//oPrint:Say  (nRow3+0560,1810,"(-)Outras Dedu็๕es"                          ,oFont8n)
oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
//oPrint:Say  (nRow3+0700,1810,"(+)Outros Acr้scimos"                        ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Pagador"                                      ,oFont8n)
oPrint:Say  (nRow3+0840,230 ,aDatSacado[1]                                 ,oFont9 )
oPrint:Say  (nRow3+0840,1770,"CNPJ/CPF - "+aDatSacado[7]                   ,oFont9 ) //CNPJ

oPrint:Say  (nRow3+0880,230 ,aDatSacado[3]+" - "+aDatSacado[9]             ,oFont9 )
oPrint:Say  (nRow3+0920,230 ,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

oPrint:Say  (nRow3+0985,1850,"C๓digo de Baixa:"  ,oFont9)

oPrint:Say  (nRow3+0985, 100,"Sacador / Avalista"                            ,oFont8n)
//Solicitado pelo Safra para ficar em branco
//oPrint:Say  (nRow3+0985, 400, aDadosEmp[1] + "   " + aDadosEmp[6]          ,oFont8n)
oPrint:Say  (nRow3+1030,1620,"Autentica็ใo Mecโnica "  ,oFont8n)
oPrint:Say  (nRow3+1030,1900,"Ficha de Compensa็ใo "  ,oFont8)

oPrint:Line (nRow3+0150,1800,nRow3+0840,1800 )
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,1800,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1025,100 ,nRow3+1025,2300 )

MSBAR2("INT25",26.1,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.7,Nil,Nil,"A",.F.,100,100)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a pแgina

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRetDados  บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera SE1                        					          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,;
                            cDacCC,cNumBco,cNroDoc,nValor,cCart,cMoeda)
Local cNosso	  := ""
Local cDigNosso   := ""
Local cCampoL	  := ""
Local cFatorValor := ""
Local cLivre	  := ""
Local cDigBarra   := ""
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
cCampoL  := "7"+cAgencia + Right("000000"+AllTrim(cConta) + AllTrim(cDacCC),10) + SubStr(cNosso,4) + "2"

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
// descobrir se o 7 ้ 7!
//Parte e composta por
// Banco: 001 - 003
// MOeda: 004
// xxx  : 005
// Agencia: 006 - 009
//DV Parte1:010
/*

*/
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
SE1->E1_NUMBCO := cNosso   // Nosso n๚mero  
SE1->E1_PORCJUR := GETMV("MV_XJURIT")
SE1->E1_XCONTA := "422"

MsUnlock()

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณDIGIT001  บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPara calculo da linha digitavel do Unibanco                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณFATOR		บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do FATOR  de vencimento para linha digitavel.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Fator(dVencto)
   Local cData  := DTOS(dVencto)
   Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return(cFator)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCALC_5p   บAutor  ณMicrosiga           บ Data ณ  06/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do digito do nosso numero do                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Modulo10 บAutor  ณMicrosiga           บ Data ณ  36/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do digito do nosso numero do pelo Modulo 10        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjustaSx1    ณ Autor ณ Microsiga            	ณ Data ณ 06/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica/cria SX1 a partir de matriz para verificacao          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                    	  		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static function AjustaSx1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Do Cliente'          , '', '', 'mv_ch1', 'C', 6, 0, 0, 'G', '',   'SA1',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'At้ Cliente'         , '', '', 'mv_ch2', 'C', 6, 0, 0, 'G', '',   'SA1',  '', '', 'mv_par02')
	U_PIPutSx1(cPerg, '03', 'De Prefixo'          , '', '', 'mv_ch3', 'C', 3, 0, 0, 'G', '',      '',  '', '', 'mv_par03')
	U_PIPutSx1(cPerg, '04', 'Ate Prefixo'         , '', '', 'mv_ch4', 'C', 3, 0, 0, 'G', '',      '',  '', '', 'mv_par04')
	U_PIPutSx1(cPerg, '05', 'Do Numero'           , '', '', 'mv_ch5', 'C', 9, 0, 0, 'G', '',      '',  '', '', 'mv_par05')
	U_PIPutSx1(cPerg, '06', 'At้ Numero'          , '', '', 'mv_ch6', 'C', 9, 0, 0, 'G', '',      '',  '', '', 'mv_par06')
	U_PIPutSx1(cPerg, '07', 'Da Parcela'          , '', '', 'mv_ch7', 'C', 1, 0, 0, 'G', '',      '',  '', '', 'mv_par07')
	U_PIPutSx1(cPerg, '08', 'At้ Parcela'         , '', '', 'mv_ch8', 'C', 1, 0, 0, 'G', '',      '',  '', '', 'mv_par08')
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


// Adicionado para gerar o IDCNAB na Impressใo do Boleto
// Pois ele serแ o N do documento impresso no Boleto

Static Function _GetIdCnab()
 Local lNewIndice := FaVerInd() 
 
 aOrdSE1 := SE1->(GetArea())
 if Empty(SE1->E1_IDCNAB) 
	 //cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,Iif(lNewIndice,19,16))
    cIdCnab := Left(SE1->E1_PREFIXO,2)+Right(SE1->E1_NUM,6)+Left(SE1->E1_PARCELA,1) //cIdCnab := Left(SE1->E1_PREFIXO)+Right(SE1->E1_NUM)+Left(SE1->E1_PARCELA)
	 //dbSelectArea("SE1") 
   /*
	 SE1->(dbSetOrder(16))
	 While SE1->(MsSeek(xFilial("SE1")+cIdCnab))
		If ( __lSx8 )
			ConfirmSX8()
	    EndIf
		cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,Iif(lNewIndice,19,16))
	 EndDo
   
	 
	 SE1->(RestArea(aOrdSE1))
	 */
	 SE1->(Reclock("SE1",.F.))
	 	SE1->E1_IDCNAB := cIdCnab
	 SE1->(MsUnlock())
	 ConfirmSx8()
 Else
    cIdCnab := SE1->E1_IDCNAB
 Endif
Return cIdCnab

