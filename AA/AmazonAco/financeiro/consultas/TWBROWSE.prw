#include "TOTVS.CH"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
L¦¦¦ Função    ¦ AAFINC01   ¦ Autor ¦                      ¦ Data ¦ 02/04/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta dos Titulos para Renegociacao                     	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINC01()


/*BEGINDOC
__________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+-------------+¦¦
¦¦¦Chama a Rotina para Criacao de um Ambiente Caso nao seja eberto pelo Sistema¦¦¦ 
¦¦+-----------+------------+-------+----------------------+------+-------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ENDDOC
*/

If Type("cAcesso") = "U"
  Prepare environment empresa "01" Filial "01" Tables "SA1,SE1"
EndIf


Private cCadastro := "Cliente"
Private aRotina   := { {"Pesquisar" ,"AxPesqui"   ,0,1} ,;
                       {"Processar"  ,"U_AAFINC1A",0,2} }

Private cAlias0 := "SA1"


///__cUserId := "000000"
dbSelectArea(cAlias0)
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias0)


Return Nil

User Function AAFINC1A()
   u_AAFINC1B(SA1->A1_COD,SA1->A1_LOJA)
Return Nil

User Function AAFINC1B(_cdCliente,_cdLoja)

/*BEGINDOC
_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           |Define As Variaveis Que Serão Utilizadas na Rotina|            ¦¦¦ 
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ENDDOC
*/


Local oOK         := Nil
Local oNO         := Nil
Local cMarca      := ""
Local _cSE1Filter := ""
//Local oLayer      := FWLayer():new()

//Local C1_Win01    := TPanel():New(0,0,'', ,, .T., .T.,, ,20,20)
//Local C1_Win02    := TPanel():New(0,0,'', ,, .T., .T.,, ,20,20)



Default _cdCliente := "006260"
Default _cdLoja    := "01"

PRivate oMark       := Nil
Private _nJuros     := 0
Private _nJurMe     := 0
Private _nTotJuros  := 0
Private _nTotTitulos:= 0
Private _ddDat      := STOD('')
Private _oGetTotJur := Nil
Private _oGetValTit := Nil
Private _oGetTotGer := Nil
Private _oGetNewJur := Nil
Private _oGetNewPar := Nil
Private _oTotCred   := Nil
Private _nTotGeral  := 0
Private _nTotCred   := 0
Private _cCond      := ""//Space(TamSx3("E4_CODIGO")[01])
Private _nTotNewJur := 0
Private _nTotNewPar := 0
Private _dDatBack   := STOD('')
Private _nVencidos  := 0
Private _nCreditos  := 0 
Private _nVencer    := 0
Private _nTotReg := 0

If Type("cAcesso") = "U"
  Prepare environment empresa "01" Filial "01" Tables "SA1,SE1" MODULO '09'
EndIf

_cCond      := Space(TamSx3("E4_CODIGO")[01])

/*BEGINDOC
__________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+-------------+¦¦
¦¦¦        Atribui os Valores as Variaveis Declaradas Anteriormente            ¦¦¦ 
¦¦+-----------+------------+-------+----------------------+------+-------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ENDDOC
*/

oOK         := LoadBitmap(GetResources(),'LBOK')
oNO         := LoadBitmap(GetResources(),'LBOK')
cMarca      := getMark()
_cSE1Filter := SE1->(dbFilter())

dbSelectArea('SE1')
//SETMBTOPFILTER
//F3MONTAFILTRO
//GETBRWFILS
//MSPADL

// Aplicando o Filtro Necessario para trabalhar 

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial('SA1') + _cdCliente + _cdLoja))
SE1->(dbSetOrder(7))
SE1->(dbSetFilter({|| SE1->E1_SALDO > 0 .and. SE1->E1_CLIENTE == SA1->A1_COD .And. SE1->E1_LOJA == SA1->A1_LOJA}," SE1->E1_SALDO > 0 .and. SE1->E1_CLIENTE == SA1->A1_COD .And. SE1->E1_LOJA == SA1->A1_LOJA"))

_cCond   := Space(TamSx3("E4_CODIGO")[01])
_ddDat   := dDataBase
_dDatBack:= _ddDat
_nJuros  := 0
_lProDia := .T.

SE1->(dbEval({|| SE1->(RecLock('SE1',.F.) , _nTotReg += iIf(_lProDia,1,0) ,;
      SE1->E1_XDIA := iIf( _ddDat - SE1->E1_VENCTO > 0,_ddDat - SE1->E1_VENCTO,0) , SE1->(MsUnlock() ) ) ,;
      _nVencidos += iIF(SE1->E1_XDIA != 0 .AND. !(SE1->E1_TIPO $ "NCC|RA "),SE1->E1_SALDO,0) ,;
      _nCreditos += iIF(                         (SE1->E1_TIPO $ "NCC|RA "),SE1->E1_SALDO,0) ,;
      _nVencer   += iIF(SE1->E1_XDIA  = 0 .AND. !(SE1->E1_TIPO $ "NCC|RA "),SE1->E1_SALDO,0) }))

SE1->(dbGoTop() )
// Definindo a Janela padrao da Rotina
Private _lMark := .T.
Private _lMarkV:= .T.
Private _lMarkA:= .T.
Private _lMarkT:= .T.
Private oTHButton1 := Nil
Private oTHButton2 := Nil
Private oTHButton3 := Nil
Private oDlg       := Nil

DEFINE DIALOG oDlg TITLE "Exemplo TWBrowse" FROM 001,001 TO 550,1000 PIXEL
   
   //oDlg := TPanel():New(0,0,'', ,, .T., .T.,, ,20,20)   
   @ 003,005 TO 55,500 label "Cabecalho" OF oDlg PIXEL
   
   @010, 010 Say "Código  "   Size 30,10 Of oDlg Pixel   //Font oFnt3     
   @010, 080 Say "Loja    "   Size 30,10 Of oDlg Pixel   //Font oFnt3
   @010, 100 Say "Nome    "   Size 30,10 Of oDlg Pixel   //Font oFnt3
   @010, 230 Say "CNPJ    "   Size 30,10 Of oDlg Pixel   //Font oFnt3   
     
   @020, 010 Say SA1->A1_COD  Size 30,10 Of oDlg Pixel   //Font oFnt3     
   @020, 080 Say SA1->A1_LOJA Size 30,10 Of oDlg Pixel   //Font oFnt3
   @020, 100 Say SA1->A1_NOME Size 160,10 Of oDlg Pixel  //Font oFnt3
   @020, 230 Say Transform( SA1->A1_CGC, IIF(SA1->A1_PESSOA = "J","@R 99.999.999/9999-99","@R 999.999.999-99" ))   Size 160,10 Of oDlg Pixel  //Font oFnt3
   
   @030, 010 Say "Percentual de Juros(DIA)"   Size 70,80 Of oDlg Pixel   //Font oFnt3
   @030, 080 Say "Percentual de Juros(MES)" Size 70,80 Of oDlg Pixel //Font oFnt3
   @030, 170 Say "Data Pgto" Size 30,80 Of oDlg Pixel   //Font oFnt3
   @030, 230 Say "Cond Pgto" Size 30,80 Of oDlg Pixel   //Font oFnt3
   
   @040, 010 MsGet _nJuros  Size 30,08  Picture "@E 999.99999" of oDlg Pixel  valid (_nJurMe := _nJuros * 30, ValidPerc(cMarca)  )
   @040, 080 MsGet _nJurMe  Size 50,08  Picture "@E 999.99999" of oDlg Pixel valid (_nJuros := _nJurMe / 30, ValidPerc(cMarca) ) 
   @040, 170 MsGet _ddDat  Size 50,08 of oDlg Pixel valid ValidData(cMarca)
   @040, 230 MsGet _cCond  F3 "SE4" Size 50,08 of oDlg Pixel valid ValidCond(cMarca)
  
   @015, 320 Button "&Filtro" Size 40,10 Of oDlg Pixel   ACtion CLICOU(cMarca)  //Font oFnt3
   @025, 320 Button "Imprimir" Size 40,10 Action Processa({||AAFINCR1(cMarca)},"Imprimindo Relatorio, Aguarde...") Pixel Of oDlg
   
  oTHButton1 := THButton():New(020,370,"Total Vencidos:" + Transform(_nVencidos,"@E 999,999,999.9999"),oDlg,;
                 {|| Action1(cMarca) },90,08,,"Total Vencidos")

  oTHButton2 := THButton():New(030,370,"Total a Vencer:" + Transform(_nVencer,"@E 999,999,999.9999"),oDlg,;
                 {|| Action2(cMarca) },90,08,,"Total a Vencer")

  oTHButton3 := THButton():New(040,370,"Total Creditos:" + Transform(_nCreditos,"@E 999,999,999.9999"),oDlg,;
                 {|| Action3(cMarca) },90,08,,"Total a Vencer")

//   @020, 350 Say "Total Vencidos:" + Transform(_nVencidos,"@E 999,999,999.9999") Size 80,10 Of oDlg Pixel   //Font oFnt3
//   @030, 350 Say "Total a Vencer:" + Transform(_nVencer,"@E 999,999,999.9999") Size 80,10 Of oDlg Pixel   //Font oFnt3 
  
   @058, 005 TO 205,500 label "Seleção dos Dados" OF oDlg PIXEL
     
   oMark := MsSelect():New("SE1", "E1_OK",, ,, cMarca, { 070, 010, 200, 495 } ,,, oDlg)
   oMark:bAval            := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
   oMark:oBrowse:bAllMark := {|| _nRec:= SE1->(Recno()) , SE1->(dbGoTop()), SE1->(dbEval({|| Marcar( cMarca, _lMark )  }  ) ) , _lMark := !_lMark , _lMarkA := _lMarkV := _lMark ,ProcRegs(cMarca) , SE1->(dbGoTo(_nRec) )}
   oMark:oBrowse:lAllMark := .T.
  
  
   @208, 005 TO 260,245 label "Totais" OF oDlg PIXEL
   @208, 255 TO 260,500 label "Valores Negociados" OF oDlg PIXEL
   
   @215, 010 Say "Total Titulos Marcados"   Size 70,10 Of oDlg Pixel   //Font oFnt3
   @215, 080 Say "Total de Juros" Size 50,10 Of oDlg Pixel   //Font oFnt3
   @215, 150 Say "Total (Juros + Valor)" Size 50,10 Of oDlg Pixel   //Font oFnt3
   
   @215, 260 Say "Valor Total Titulos"   Size 70,10 Of oDlg Pixel   //Font oFnt3
   @215, 330 Say "Valor de Cada Parcela" Size 70,10 Of oDlg Pixel   //Font oFnt3
   @215, 400 Say "Valor de Creditos"     Size 70,10 Of oDlg Pixel   //Font oFnt3
   
   @240, 010 MsGet _oGetValTit Var _nTotTitulos Size 65,08    Picture "@E 999,999,999,999.99" of oDlg Pixel when .F.
   @240, 080 MsGet _oGetTotJur Var _nTotJuros   Size 65,08    Picture "@E 999,999,999,999.99" of oDlg Pixel when .F.
   @240, 150 MsGet _oGetTotGer Var _nTotGeral   Size 65,08    Picture "@E 999,999,999,999.99" of oDlg Pixel when .F.
   
   @240, 260 MsGet _oGetNewJur Var _nTotNewJur  Size 65,08    Picture "@E 999,999,999,999.99" of oDlg Pixel when .F.
   @240, 330 MsGet _oGetNewPar Var _nTotNewPar  Size 65,08    Picture "@E 999,999,999,999.99" of oDlg Pixel when .F.
   @240, 400 MsGet _oTotCred   Var _nTotCred    Size 65,08    Picture "@E 999,999,999,999.99" of oDlg Pixel when .F.
   
//   @240, 080 MsGet _ddDat  Size 50,08 of oDlg Pixel
   
  ACTIVATE DIALOG oDlg CENTERED 
  
  SE1->(dbSetFilter( {||&(_cSE1Filter)} , _cSE1Filter ))
Return

Static Function Marcar(cMarca,lMarca)
   Local lOk := .T.
   Default lMarca := .F.
   
   SE1->(RecLock("SE1",.F.))
      SE1->E1_OK := If( SE1->E1_OK <> cMarca .Or. (lMarca .And. cMarca == SE1->E1_OK) , cMarca, Space(Len(SE1->E1_OK)))
   SE1->(MsUnLock())

   // modificado por wermeson em 12/03/2012
   // conforme solicitação do analista marcel 
    
   /*nDias := _ddDat - E1_VENCTO //SE1->E1_VENCREA
//   alert(nDias)
   nDias := iIf( nDias < 0,0,nDias)
     */
   // modificado por wermeson em 12/03/2012
   // conforme solicitação do analista marcel 
   nDias := _ddDat - SE1->E1_VENCREA
   nDias := iIf( nDias > 0,_ddDat - SE1->E1_VENCTO, 0)
     
   If SE1->E1_OK == cMarca
      If  nDias >= 0  .AND. !(SE1->E1_TIPO $ "NCC|RA ")          
          _nTotJuros += (nDias * _nJuros)*SE1->E1_SALDO / 100
          _nTotTitulos += SE1->E1_SALDO 
        ElseIf (SE1->E1_TIPO $ "NCC|RA ")          
          _nTotCred += SE1->E1_SALDO         
      EndIf
   else
      If nDias >= 0 .AND. !(SE1->E1_TIPO $ "NCC|RA ")
          _nTotJuros -= (nDias * _nJuros)*SE1->E1_SALDO / 100
          _nTotTitulos -= SE1->E1_SALDO          
        ElseIf (SE1->E1_TIPO $ "NCC|RA ")          
          _nTotCred -= SE1->E1_SALDO         
      EndIf
   EndIf
   
_nTotGeral := _nTotTitulos + _nTotJuros
 validcond(cMarca)

_oGetTotJur:Refresh()
_oGetValTit:Refresh()
_oGetTotGer:Refresh()
_oTotCred:Refresh()
Return

Static Function ValidPerc(cMarca)
  Local _lRet := .T.
  
  If _lRet 
     If _nJuros >= 0 .And. _nJuros <= 100
        ProcRegs(cMarca)
     else
       Aviso('Atencao','Percentual de Juros tem que estar entre 0 e 100',{'OK'},1)
       _lRet := .F.
     EndIf
  EndIf
  
Return _lRet

Static Function ProcRegs(cMarca)
   Local _aArea := SE1->(GetArea())
   Local _nRec  := SE1->(recno())
   _nTotJuros   := 0
   _nTotTitulos := 0
   _nTotCred    := 0 
   
   _oGetTotJur:Refresh()
   _oGetValTit:Refresh()
   _oTotCred:Refresh()
   //_oGetTotGer:Refresh()
   
   //alert(STR(_nTotJuros))
  // alert(STR(_nTotTitulos))   
   
   SE1->(DbGoTop())
   While !SE1->(EOF())
      If SE1->E1_OK = cMarca

		   // modificado por wermeson em 12/03/2012
		   // conforme solicitação do analista marcel 
		   nDias := _ddDat - SE1->E1_VENCREA
		   nDias := iIf( nDias > 0,_ddDat - SE1->E1_VENCTO, 0)
		
         //nDias := _ddDat - E1_VENCTO //SE1->E1_VENCREA
         //nDias := iIf( nDias < 0,0,nDias)

         If nDias >= 0 .AND. !(SE1->E1_TIPO $ "NCC|RA ")
             _nTotJuros += NoRound( (nDias * _nJuros)*SE1->E1_SALDO / 100, 2 )  //(nDias * _nJuros)*SE1->E1_SALDO / 100
             _nTotTitulos += SE1->E1_SALDO
           ElseIf (SE1->E1_TIPO $ "NCC|RA ")  
             _nTotCred    += SE1->E1_SALDO
         EndIf
      EndIf      
      SE1->(dbSkip())
   EndDo   
   _nTotGeral := _nTotTitulos + _nTotJuros

   _oGetTotJur:Refresh()
   _oGetValTit:Refresh()
   _oTotCred:Refresh()
   _oGetTotGer:Refresh()
   
   ValidCond()
   
   _aArea := SE1->(RestArea(_aArea))
   SE1->(dbGoTop())
   oMark:oBrowse:Refresh()
Return

Static Function ValidCond(cMarca)
    Local _lRet := .T.
    Local aCond := {}
    SE4->(dbSetOrder(1))
    If _lRet := SE4->(dbSeek(xFilial('SE4') + _cCond))
    
       aCond       := ToArray(Alltrim(SE4->E4_COND))
       nValParc    := _nTotGeral / Len(aCond)
       _nTotNewJur := 0
       
       For nI := 1 to Len(aCond)
         _nTotNewJur += (aCond[nI] * _nJuros * nValParc) / 100 + nValParc
       Next
       
    elseif Len(Alltrim(_cCond)) > 0
      Aviso('Atencao','Nao Existe registro Relacionado a Este Codigo',{'Ok'},2)
    Endif

If Len(aCond) > 0
  _nTotNewPar := _nTotNewJur / Len(aCond)
EndIf

_oGetNewJur:Refresh()
_oGetNewPar:Refresh()

Return _lRet

Static Function ToArray(cTexto)
   Local aText := {}
   Local cText := ''
   
   For nI:=1 To Len(cTexto)
      If SubStr(cTexto,nI,1) = ',' .and. Len(cText) > 0 
         aAdd(aText,Val(cText))
         cText := ''
      else
        cText += SubStr(cTexto,nI,1)
      EndIf
   Next
   If Len(cText) > 0 
      aAdd(aText,Val(cText))
   EndIf
Return aText

Static Function AAFINCR1(cMarca)

   Local IMP_SPOOL := 2
   Local _nLinha := 10
   Local _nColuna:= 04
   Private _nExpLin := 50
   //oPrinter	:= TMSPrinter():New("PRINT", IMP_SPOOL)
   oPrinter	:= TMSPrinter():New("PRINTER")
   oPrinter:Setup()   
   //ProcRegua(SCK->(LastRec()))
   ProcRegua(_nTotReg)
   
   Private _nMaxVert:= oPrinter:nVertRes() - 40
   Private _nMaxHorz:= oPrinter:nHorzRes() - 40
   
  //	oPrinter:SetPortrait()
//	oPrinter:Setup()
	
	
	PRIVATE oFont10N   := TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)// 1
   PRIVATE oFont07N   := TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)// 2
   PRIVATE oFont07    := TFontEx():New(oPrinter,"Times New Roman",06,06,.F.,.T.,.F.)// 3
   PRIVATE oFont08    := TFontEx():New(oPrinter,"Times New Roman",07,07,.F.,.T.,.F.)// 4
   PRIVATE oFont08N   := TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)// 5
   PRIVATE oFont09N   := TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)// 6
   PRIVATE oFont09    := TFontEx():New(oPrinter,"Times New Roman",08,08,.F.,.T.,.F.)// 7
   PRIVATE oFont10    := TFontEx():New(oPrinter,"Times New Roman",09,09,.F.,.T.,.F.)// 8
   PRIVATE oFont11    := TFontEx():New(oPrinter,"Courier New"    ,10,10,.F.,.T.,.F.)// 9
   PRIVATE oFont12    := TFontEx():New(oPrinter,"Times New Roman",11,11,.F.,.T.,.F.)// 10
   PRIVATE oFont11N   := TFontEx():New(oPrinter,"Times New Roman",10,10,.T.,.T.,.F.)// 11
   PRIVATE oFont18N   := TFontEx():New(oPrinter,"Times New Roman",17,17,.T.,.T.,.F.)// 12
   PRIVATE OFONT12N   := TFontEx():New(oPrinter,"Times New Roman",11,11,.T.,.T.,.F.)// 12
	PRIVATE oFontnN    := TFontEx():New(oPrinter,"Courier New"    ,08,08,.T.,.T.,.F.)// 9
	
	_nPag := 1	
	_nLinha := Cabec(oPrinter,_nLinha,_nColuna,_nPag)
	
	_nLinBak := _nLinha
	_nLinha += 15
	lImprime := .T.
	
	SE1->(DBGOTOP())
	_ntVenc := 0
	_naVenc := 0
	While !SE1->(EOF())
	   IncProc()
	   If SE1->E1_OK = cMarca
         
         If lImprime
	         
	         oPrinter:Say(_nLinha, _nColuna + 0005 , "Prefixo"     ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 0095 , "Num. Titulo" ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 0255 , "Parcela"     ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 0355 , "Tipo"        ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 0420 , "Vendedor"    ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 0650 , "Banco"       ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 0805 , "Dt. Emissao" ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 1005 , "Vencimento"  ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 1205 , "Venc. Real"  ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 1450 , "Valor"       ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 1635 , "Recebido"    ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 1845 , "Saldo"       ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 2005 , "Atraso"      ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 2205 , "Juros"       ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 2405 , "Jrs Parcela" ,oFont10N:oFont)
	         oPrinter:Say(_nLinha, _nColuna + 2605 , "Historico"   ,oFont10N:oFont)
	         	         
	         lImprime := .F.
	         _nLinha += _nExpLin
         EndIf                                    
         
         cNomeVendedor := SubStr( Posicione("SA3",1, xFilial("SA3") + SE1->E1_VEND1, "A3_NOME"),1,12 ) 
         
         _xdValor := 0
         SE5->(dbSetOrder(7))
         If SE5->(dbSeek(xFilial('SE5') + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA ))

            _xdSeq := '000'
            While !SE5->(Eof()) .And. xFilial('SE5') + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA == SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
               If !Alltrim(SE5->E5_TIPODOC)$"JR"
	               If _xdSeq == SE5->E5_SEQ                   
	                  _xdValor -= SE5->E5_VALOR
	               Else
	                  _xdValor += SE5->E5_VALOR                  
	               EndIf
	               _xdSeq :=  SE5->E5_SEQ
               Endif
               
               SE5->(dbSkip()) 
            EndDo
         EndIf
         
         oPrinter:Say(_nLinha, _nColuna + 0005 , SE1->E1_PREFIXO ,oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 0085 , SE1->E1_NUM     ,oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 0255 , SE1->E1_PARCELA ,oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 0355 , SE1->E1_TIPO    ,oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 0450 , cNomeVendedor   ,oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 0650 , SE1->E1_PORTADO ,oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 0805 , DTOC(SE1->E1_EMISSAO),oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 1005 , DTOC(SE1->E1_VENCTO),oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 1205 , DTOC(SE1->E1_VENCREA),oFont10:oFont)
         oPrinter:Say(_nLinha, _nColuna + 1305 , Transform(SE1->E1_VALOR,'@E 999,999,999.99'),oFontnN:oFont)
	     //oPrinter:Say(_nLinha, _nColuna + 1505 , Transform(SE1->(E1_VALOR - E1_SALDO),'@E 999,999,999.99'),oFontnN:oFont)
	     oPrinter:Say(_nLinha, _nColuna + 1505 , Transform(_xdValor ,'@E 999,999,999.99'),oFontnN:oFont)
	     	     
	     oPrinter:Say(_nLinha, _nColuna + 1705 , Transform(SE1->E1_SALDO,'@E 999,999,999.99'),oFontnN:oFont)
	     oPrinter:Say(_nLinha, _nColuna + 1965 , Transform(SE1->E1_XDIA,'@E 99,999'),oFontnN:oFont)
         
         If !(SE1->E1_TIPO $ "NCC|RA ")
	         oPrinter:Say(_nLinha, _nColuna + 2055 , Transform(NoRound(SE1->(E1_XDIA * E1_SALDO*_nJuros/100),2),'@E 999,999,999.99')  ,oFontnN:oFont)
             oPrinter:Say(_nLinha, _nColuna + 2305 , Transform(NoRound(SE1->(E1_XDIA * E1_SALDO*_nJuros/100),2) + NoRound( ((SE1->E1_SALDO*(_nTotNewJur - _nTotGeral))/_nTotTitulos),2),'@E 999,999,999.99')  ,oFontnN:oFont)         
           Else 
	         oPrinter:Say(_nLinha, _nColuna + 2055 , Transform(0 ,'@E 999,999,999.99')  ,oFontnN:oFont)
             oPrinter:Say(_nLinha, _nColuna + 2305 , Transform(0 ,'@E 999,999,999.99')  ,oFontnN:oFont)                    
         EndIf 
         
         oPrinter:Say(_nLinha, _nColuna + 2605 , SE1->E1_HIST ,oFont10:oFont)                   
         
                 
         _ntVenc += iIF( SE1->E1_XDIA!= 0 , SE1->E1_SALDO,0)
         _naVenc += iIF( SE1->E1_XDIA = 0 , SE1->E1_SALDO,0)
         
         _nLinha += _nExpLin
                  
      EndIf      
      
      SE1->(dbSkip())
      If _nLinha >= _nMaxVert .Or. (_nLinha + 70 >= _nMaxVert .And. SE1->(EOF()) )
      
         oPrinter:Box(_nLinBak,_nColuna,_nLinha, _nMaxHorz)
         oPrinter:EndPage()
         oPrinter:StartPage()
         _nLinha := Cabec(oPrinter,04,_nColuna, ++_nPag )         
         lImprime := .T.
         _nLinBak := _nLinha
      EndIf
	EndDo
	
	oPrinter:Box(_nLinBak,_nColuna,_nLinha, _nMaxHorz)
	_nLinha += 15
	
	oPrinter:Box(_nLinha,_nColuna,_nLinha + 2*_nExpLin + 20, (_nMaxHorz / 2) - 10)
	oPrinter:Box(_nLinha,(_nMaxHorz / 2) + 10,_nLinha + 2*_nExpLin + 20, _nMaxHorz)
	
	oPrinter:Say(_nLinha,_nColuna + 0005, "Total Titulos Marcados",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) - 650, "Total de Juros",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) - 400, "Total (Juros + Valor)",oFont10N:oFont)
	
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) + 010, "Valor Total Titulos",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) + 295, "Valor de Cada Parcela",oFont10N:oFont)
   oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) + 650, "Total Vencidos: " + Transform(_ntVenc,"@E 999,999,999.9999") ,oFont10N:oFont)
   oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) +1100, "Total Credito" ,oFont10N:oFont)

	_nLinha += _nExpLin
	
	oPrinter:Say(_nLinha,_nColuna + 0005, Transform(_nTotTitulos,"@E 999,999,999.99") ,oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) - 650, Transform(_nTotJuros,"@E 999,999,999.99") ,oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) - 400, Transform(_nTotGeral,"@E 999,999,999.99") ,oFont10:oFont)
	
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) + 010, Transform(_nTotNewJur,"@E 999,999,999.99") ,oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) + 295, Transform(_nTotNewPar,"@E 999,999,999.99") ,oFont10:oFont)	
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) + 650, "Total a Vencer: " + Transform(_naVenc,"@E 999,999,999.9999"),oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + (_nMaxHorz / 2) +1100, Transform(_nTotCred,"@E 999,999,999.9999"),oFont10N:oFont)
	
	oPrinter:EndPage()
	oPrinter:Preview()
	
Return Nil

Static Function Cabec(oPrinter,_nLinha,_nColuna,_nPag)
  oPrinter:FillRect( {_nLinha,_nColuna,_nLinha + 2,_nMaxHorz}, TBrush():New(,CLR_BLACK) )
  
  _nLinha += 10
  oPrinter:Say(_nLinha,_nColuna , "Emissao: " + DTOC(dDataBase) , oFont10n:oFont)
  oPrinter:Say(_nLinha,_nColuna + _nMaxHorz / 2 - 300, PADC(SM0->M0_NOMECOM,	60) ,oFont10N:oFont)
  oPrinter:Say(_nLinha,_nColuna + _nMaxHorz - 70 - oPrinter:GetTextHeight("Pagina: " + StrZero(_nPag,3) , oFont10n:oFont )    , "Pagina: " + StrZero(_nPag,3) ,oFont10n:oFont)

  _nLinha += _nExpLin
  oPrinter:Say(_nLinha,_nColuna , " Hora"    + Left(Time(),5)  ,oFont10n:oFont)
  oPrinter:Say(_nLinha,_nColuna + _nMaxHorz - 200 - oPrinter:GetTextHeight("Usuario: " + cUserName , oFont10n:oFont ) , "Usuario: " + cUserName  ,oFont10n:oFont)
  
  _nLinha += _nExpLin * 2
  oPrinter:FillRect( {_nLinha,_nColuna,_nLinha + 2,_nMaxHorz}, TBrush():New(,CLR_BLACK) )
  _nLinha += 5
  
  oPrinter:Box(_nLinha,_nColuna,_nLinha + 3*_nExpLin + 50, _nMaxHorz)	  
  //_nLinha + 15
	oPrinter:Say(_nLinha,_nColuna + 005,"Código",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + 150,"Loja  ",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + 250,"Nome  ",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + 950,"CNPJ  ",oFont10N:oFont)

	_nLinha += _nExpLin 
	
	oPrinter:Say(_nLinha,_nColuna + 005,SA1->A1_COD,oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + 150,SA1->A1_LOJA,oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + 250,SA1->A1_NOME,oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + 950,Transform( SA1->A1_CGC, IIF(SA1->A1_PESSOA = "J","@R 99.999.999/9999-99","@R 999.999.999-99" )),oFont10:oFont)

	
	_nLinha += _nExpLin + 10
	
	oPrinter:Say(_nLinha,_nColuna + 005,"Percentual Juros",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + 255,"Data Pagamento",oFont10N:oFont)
	oPrinter:Say(_nLinha,_nColuna + 505,"Cond. Pagto",oFont10N:oFont)
	
	_nLinha += _nExpLin 
	
	//oPrinter:Say(_nLinha,_nColuna + 005,Transform(_nJuros,"@E 999,999,999.99"),oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + 005,Transform(_nJurMe,"@E 999,999,999.99"),oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + 255,DTOC(_ddDat),oFont10:oFont)
	oPrinter:Say(_nLinha,_nColuna + 505,_cCond + ' - ' + Posicione('SE4',1,xFilial('SE4') + _cCond,'E4_DESCRI') ,oFont10:oFont)	
	
	_nLinha += _nExpLin + 10
  
Return _nLinha


Static Function CLICOU(cMarca,_cFiltro)
  Local _cSE1Filter := " SE1->E1_SALDO > 0 .and. SE1->E1_CLIENTE == SA1->A1_COD .And. SE1->E1_LOJA == SA1->A1_LOJA"
  Local _cFilter    := ''
  Default _cFiltro  := ''
  SE1->(DBClearFilter())
  If Len(_cFiltro) == 0
    _cFilter := BuildExpr('SE1',,'') // - Construtor de expressões de filtro ( cAlias [ oWnd ] [ cFilter ] [ lTopFilter ] [ bOk ] [ oDlg ] [ aUsado ] [ cDesc ] ) --> cRet "
    _cFilter := _cSE1Filter  + Iif(!Empty(_cFilter),'.And.' + _cFilter,'')
  else
    _cFilter := _cFiltro
    _cFilter := _cSE1Filter  + Iif(!Empty(_cFilter),'.And.' + _cFilter,'')
  EndIf
  
  SE1->(dbSetFilter({|| &_cFilter },_cFilter ))
  SE1->(dbGoTop())
  _lMark := .T.
  Eval(oMark:oBrowse:bAllMark)
RETURN NIL

Static Function ValidData(cMarca)
  ValidPerc(cMarca)
  If _dDatBack != _ddDat
     _dDatBack := _ddDat
     
     _nRec := SE1->(Recno())
     SE1->(dbGoTop())
       _nVencer   := 0
       _nVencidos := 0  
       _nCreditos := 0
       
       SE1->(dbEval({|| SE1->(RecLock('SE1',.F.) ,;
             SE1->E1_XDIA := iIf( _ddDat - SE1->E1_VENCTO > 0,_ddDat - SE1->E1_VENCTO,0) , SE1->(MsUnlock() ) ) ,;
             _nVencidos += iIF(SE1->E1_XDIA > 0 .AND. !(SE1->E1_TIPO $ "NCC|RA ") ,SE1->E1_SALDO,0) ,;
             _nCreditos += iIF(                        (SE1->E1_TIPO $ "NCC|RA ") ,SE1->E1_SALDO,0) ,;
             _nVencer   += iIF(SE1->E1_XDIA = 0 .AND. !(SE1->E1_TIPO $ "NCC|RA ") ,SE1->E1_SALDO,0) }))
     
       // SE1->(dbEval({|| SE1->(RecLock('SE1',.F.) , SE1->E1_XDIA := iIf( _ddDat - SE1->E1_VENCTO > 0,_ddDat - SE1->E1_VENCTO,0) , SE1->(MsUnlock() ) )  }))
     SE1->(dbGoTop())
     SE1->(dbGoTo(_nRec))
     
  EndIf
oTHButton1:cCaption := "Total Vencidos:" + Transform(_nVencidos,"@E 999,999,999.9999")
oTHButton2:cCaption := "Total a Vencer:" + Transform(_nVencer  ,"@E 999,999,999.9999")      
oTHButton3:cCaption := "Total Creditos:" + Transform(_nCreditos,"@E 999,999,999.9999")      
Return

Static Function MarkAll(_0o,_cColuna)  
  _cColuna := _cColuna
Return Nil

Static Function Action1(cMarca)
 Local _nRec := SE1->(RecNo())
   
   SE1->(dbGoTop())
       SE1->(dbEval( {|| iIF( SE1->E1_XDIA!=0 .AND. !(SE1->E1_TIPO $ "NCC|RA ") ,Marcar(cMarca,_lMarkV),  ) } )  ) 
      _lMarkV := !_lMarkV
      _lMark := (_lMarkV .Or. _lMarkA) .Or. !(_lMarkV .And. _lMarkA)
   ProcRegs(cMarca) 
  SE1->(dbGoTo(_nRec)) 
  
Return Nil

Static Function Action2(cMarca)
 Local _nRec := SE1->(RecNo())
   
  SE1->(dbGoTop())
       SE1->(dbEval( {|| iIF( SE1->E1_XDIA =0 .AND. !(SE1->E1_TIPO $ "NCC|RA ") ,Marcar(cMarca,_lMarkA),  ) } )  ) 
       _lMarkA := !_lMarkA
       _lMark := (_lMarkV .Or. _lMarkA) .Or. !(_lMarkV .And. _lMarkA)
       ProcRegs(cMarca) 
  SE1->(dbGoTo(_nRec))
  
Return Nil             

Static Function Action3(cMarca)
 Local _nRec := SE1->(RecNo())
   
  SE1->(dbGoTop())
       SE1->(dbEval( {|| iIF( (SE1->E1_TIPO $ "NCC|RA ") ,Marcar(cMarca,_lMarkA),  ) } )  ) 
       _lMarkA := !_lMarkA
       _lMark := (_lMarkV .Or. _lMarkA) .Or. !(_lMarkV .And. _lMarkA)
       ProcRegs(cMarca) 
  SE1->(dbGoTo(_nRec))
  
Return Nil
