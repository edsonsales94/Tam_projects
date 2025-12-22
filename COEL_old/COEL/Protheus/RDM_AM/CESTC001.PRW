/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CESTC100 ³ Autor ³ Carlos Nina           ³ Data ³ 17/06/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Consulta Balanco de Produto                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico (Uso Cometais)                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "protheus.ch"        
#include "rwmake.ch"        
#include "TOTVS.CH"
#include "TOPCONN.CH"
#include "font.ch"
#include "colors.ch"

User Function CESTC001()        

Local   nx,nDow,nSkip,nStop

Private lSair       := .F.
Private nRotinas    := 0                                     ////Identificacao das sub-rotinas pra efeito dos refresh's dos objetos (hide() e show())
Private nItemP      := 1
Private dDatIni     := ( GETMV('MV_ULMES') + 1 )
Private dDatFin     := LastDay(dDatIni)
Private nTamProd    := TamSX3("B1_COD")[1]
Private nQtdDec     := TamSX3("B9_QINI")[2]
Private nCusDec     := TamSX3("B9_VINI1")[2]
Private mvLocPad    := IIF(M->cNumEmp=="0301","02","01")    
Private mvLocal     := IIF(M->cNumEmp=="0301","02,60,62","01,02,03,60,62")    
Private mvLocNCtb   := IIF(M->cNumEmp=="0301","60,62","02,03,60,62")
Private cPictQtd    := X3Picture("B9_QINI")
Private cPictCus    := X3Picture("B9_VINI1")
Private B1COD       := SPACE(nTamProd)
Private mB1COD      := B1COD
Private B1DESC      := SPACE(90)
Private B1UM        := SPACE(02)
Private B1TIPO      := SPACE(02)
Private B1CLDFAM    := SPACE(20)
Private dDataDe     := CTOD("")
Private dDesde      := CTOD("")
Private dAte        := CTOD("")
Private cAlmoxarife := ""
Private cAptOP      := "O.P.: "
Private cCTrab      := "Centro de Trabalho: "
Private Tabmes      := 'JANEIRO  FEVEREIROMARCO    ABRIL    MAIO     JUNHO    JULHO    AGOSTO   SETEMBRO OUTUBRO  NOVEMBRO DEZEMBRO '
Private aOrdPrd     := aCartVen := aRotOper := aCartCom := {}
Private aAlmox      := {{"","",""}}
Private aEmpenho    := {}
Private aReserva    := {{" "," "," "," "}}
Private aPV         := {{"","","","","","","",""}}
Private aOC         := {{"","","","","","","",""}}
Private aOP1        := {{"","","","","",SPACE(30),"","","","",""}}
Private aOP2        := {{"","","","","","",SPACE(30),"","","",""}}
Private aAptOP      := {{"","","","","","",SPACE(10),""}}
Private aKardex     := {{"","","","","","","","","","","","","","","","","","","","",""}}
Private aP3De       := {{"","","","","","","","","","","",""}}
Private aP3Em       := {{"","","","","","","","","","","",""}}
Private aUsado      := {{SPACE(60),SPACE(30),"","","","","","","","",SPACE(30)}}
Private aDSem       := {}
Private cDatPri1    := cDatPri2 := cDatPri3 := cAno0 := cAno1 := cAno2 := cAno3 := " "
Private nEstoque    := nEmpenho := nOP := nSC := nOC := nPV := nDeTerceiro := nEmTerceiro := nBalanco := 0
Private cMRP        := SPACE(20)
Private aMRP
Private oDlg,oGroup01,oGroup02,oGroup03,oGroup04,oGroup05,oGroup06,oGroup07,oGroup7a,oGroup08,oGroup8a,oGroup09,oGroup10,oGroup11,oGroup12,oGroup13,oGroup14,oGroup15
Private oLst0,oLst1,oList2,oLst3,oLst4,oLst5,oLst6,oLst7,oLst8,oLst9,oLst10,oLst11,oLst12,oLst13,oLst14,oLst15,oMulti,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oBtn6,oBtn7,oBtn8,oBtn9
Private oProduto,oDesc,oLocal,oUM,oTipo,oEstoque,oEmpenho,oOP,oSC,oOC,oPV,oTerceiro,oBalanco,oMRP,oAptOP,oCTrab,oSayDesde,oGetDesde,oSayAte,oGetAte,oBtn10,oBtn11,oBtn12
Private oTBmp1,oTBmp2,oTBmp3,oTBmpAp1,oTBmpAp2,oTBmpAp3,oLegAp1,oLegAp2,oLegAp3,oAlmoxarife

Private oVd := LoadBitmap( GetResources(), 'br_verde')
Private oVm := LoadBitmap( GetResources(), 'br_vermelho')
Private oAz := LoadBitmap( GetResources(), 'br_azul')
Private oLr := LoadBitmap( GetResources(), 'br_laranja')
Private oPt := LoadBitmap( GetResources(), 'br_preto')

SET(1,"OFF")

cDatPri2  := "01/01/"+SUBS(DTOC(ddatabase),7,2)  //DATA BASE DO SISTEMA
cDatPri2  := CTOD(cDatPri2)
cAno2     := SUBS(DTOS(cDatPri2),1,4)
nDOW      := DOW(cDatPri2)
nSkip     := IIF(nDOW < 6,-1,1)
nStop     := IIF(nDOW < 6,(nDOW+(nDOW-2)),7)
FOR NX:=nDOW TO nStop
    cDatPri2:=cDatPri2 +nSkip
NEXT
*
cDatPri1 := cDatPri2 -7
cDatPri1 := "01/01/"+SUBS(DTOC(cDatPri1),7,2)   // ANO ANTERIOR A DATA BASE
cDatPri1 := CTOD(cDatPri1)
cAno1    := SUBS(DTOS(cDatPri1),1,4)
nDOW     := DOW(cDatPri1)
nSkip    := IIF(nDOW < 6,-1,1)
nStop    := IIF(nDOW < 6,(nDOW+(nDOW-2)),7)
FOR NX:=nDOW TO nStop
    cDatPri1:=cDatPri1 +nSkip
NEXT
*
cDatPri3 := cDatPri2+380
cDatPri3 := "01/01/"+SUBS(DTOC(cDatPri3),7,2)  // ANO POSTERIOR A DATA BASE
cDatPri3 := CTOD(cDatPri3)
cAno3    := SUBS(DTOS(cDatPri3),1,4)
nDOW     := DOW(cDatPri3)
nSkip    := IIF(nDOW < 6,-1,1)
nStop    := IIF(nDOW < 6,(nDOW+(nDOW-2)),7)
FOR NX:=nDOW TO nStop
    cDatPri3:=cDatPri3 +nSkip
NEXT
*
cAno0 := ( VAL(cAno1) - 1 )
cAno0 := STR(cAno0,4)
*
AADD(aDSem , "Domingo" )
AADD(aDSem , "Segunda" )
AADD(aDSem , "Terca  " )
AADD(aDSem , "Quarta " )
AADD(aDSem , "Quinta " )
AADD(aDSem , "Sexta  " )
AADD(aDSem , "Sabado " )
*
dbSelectArea("SX3")
dbSetOrder(2)
lPljto := SX3->(dbSeek("C7_CDTPLJT"))
lC1Via := SX3->(dbSeek("C1_CVIA"))
lC7Via := SX3->(dbSeek("C7_CVIA"))

/*
B1_PE     = Prazo
B1_TIPE   = Tipo do Prazo (H/D/M/A)
B1_QE     = Qty. p/embalagem
B1_EMIN   = Ponto de Pedido
B1_ESTSEG = Estoque de Seguranca
B1_LE     = Lote Economico
B1_LM     = Lote Minimo
*/
dbSelectArea("SA1")   ///Clientes
dbSetOrder(1)
*
dbSelectArea("SA2")   ///Fornecedores
dbSetOrder(1)
*
dbSelectArea("SB1")   ///Produtos
dbSetOrder(1)
*
dbSelectArea("SB2")   ///Saldo Fisico/Financeiro
dbSetOrder(1)
*
dbSelectArea("SBM")   ///Grupo
dbSetOrder(1)
*
dbSelectArea("SC5")   ///Pedido de Venda
dbSetOrder(1)
*
dbSelectArea("SD3")   ///Movimento Interno
dbSetOrder(4)
*
dbSelectArea("SZE")   ///Familia
dbSetOrder(1)
*
dbSelectArea("SH1")   ///Recursos
dbSetOrder(1)
*
dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
DEFINE FONT oFnt   NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2  NAME "Arial" Size 10,11
DEFINE FONT oFnt3  NAME "Arial" Size 10,12
DEFINE FONT oFnt3a NAME "Arial" Size 7,28     ///8,16
DEFINE FONT oFnt3b NAME "Arial" Size 7.2,26     ///8,16
DEFINE FONT oFnt3c NAME "Arial" Size 7,28     ///8,16
DEFINE FONT oFnt4  NAME "Arial" Size 10,34
DEFINE FONT oFnt5  NAME "Arial" Size 14,72
DEFINE FONT oFnt6  NAME "Arial" Size 9,12
DEFINE FONT oFnt7  NAME "Arial" Size 16,74
DEFINE FONT oFnt8  NAME "Arial" Size 12,14
DEFINE FONT oFnt9  NAME "Arial" Size 16,48
DEFINE FONT oFnt9a NAME "Arial" Size 11,40   
DEFINE FONT oFnt9b NAME "Arial" Size 12,54  

oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )

DEFINE MSDIALOG oDlg TITLE ":::... Consulta Balanço de Produto ...:::" FROM 000, 000  TO 570, 1296 COLORS 0, 16777215 OF oMainWnd PIXEL
///@ 000,000  To 570,1296 Dialog oDlg1 Title "Consulta Balanço de Produto"
@ 003,003 GROUP oGroup01 TO 026,118  PROMPT "CÓDIGO"                                    OF oDlg COLOR 0, 16777215 PIXEL
@ 003,120 GROUP oGroup02 TO 024,422  PROMPT "DESCRIÇÃO"                                 OF oDlg COLOR 0, 16777215 PIXEL  
@ 003,424 GROUP oGroup03 TO 024,440  PROMPT "UM"                                        OF oDlg COLOR 0, 16777215 PIXEL
@ 003,442 GROUP oGroup04 TO 024,462  PROMPT "TIPO"                                      OF oDlg COLOR 0, 16777215 PIXEL
@ 003,464 GROUP oGroup05 TO 024,558  PROMPT "FAMILIA/GRUPO"                             OF oDlg COLOR 0, 16777215 PIXEL
@ 003,560 GROUP oGroup06 TO 069,650  PROMPT "SALDO POR ALMOXARIFADO"                    OF oDlg COLOR 0, 16777215 PIXEL

oTBmp1 := TBitmap():Create(oDlg,060,562,14,14,,'br_verde',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	  
oTBmp1:lAutoSize := .T.
@ 060,571 Say OemToAnsi("Contábil")                                               Size 040,009  Color CLR_BLACK  PIXEL OF oDlg   
oTBmp2 := TBitmap():Create(oDlg,060,606,14,14,,'br_vermelho',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	  
oTBmp2:lAutoSize := .T.
@ 060,615 Say OemToAnsi("Não-Contábil")                                           Size 040,009  Color CLR_BLACK  PIXEL OF oDlg   

@ 010,004 MsGet oProduto            VAR B1COD       PICTURE "@!" F3 "SB1" SIZE 113,012 OF oDlg COLOR 0, 16777215 FONT oFnt3b PIXEL VALID f_Produto()
@ 010,123 Say   oDesc               VAR B1DESC                            SIZE 300,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 010,427 Say   oUM                 VAR B1UM                              SIZE 015,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 010,445 Say   oTipo               VAR B1TIPO                            SIZE 015,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 010,467 Say   oFamilia            VAR B1CLDFAM                          SIZE 090,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL

@ 028,003 To 051,063  Title OemToAnsi("(+)Sdo. Estoque")
@ 028,065 To 051,124  Title OemToAnsi("(+)Reserva(O.P.)")
@ 028,126 To 051,184  Title OemToAnsi("(+)Sol. de Compra")
@ 028,186 To 051,244  Title OemToAnsi("(+)Cart. de Compra")
@ 028,246 To 051,304  Title OemToAnsi("(-)Sdo. Empenho")
@ 028,306 To 051,364  Title OemToAnsi("(-)Cart. de Venda")
@ 028,366 To 051,424  Title OemToAnsi("(=)Sdo. Balanço")
@ 028,440 To 051,498  Title OemToAnsi("Saldo De Terceiro")
@ 028,500 To 051,558  Title OemToAnsi("Saldo Em Terceiro")

@ 035,005 MsGet oEstoque    VAR nEstoque    Picture "@E 99999999.9"   Size 56,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,067 MsGet oOP         VAR nOP         Picture "@E 99999999.9"   Size 55,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,128 MsGet oSC         VAR nSC         Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,188 MsGet oOC         VAR nOC         Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,248 MsGet oEmpenho    VAR nEmpenho    Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,308 MsGet oPV         VAR nPV         Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,368 MsGet oBalanco    VAR nBalanco    Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,442 MsGet oDeTerceiro VAR nDeTerceiro Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.
@ 035,502 MsGet oEmTerceiro VAR nEmTerceiro Picture "@E 99999999.9"   Size 54,12 OF oDlg COLOR CLR_HBLUE   FONT oFnt3c PIXEL  WHEN .F.

@ 011,561 LISTBOX oLst0 Fields HEADER "","Local","Saldo" SIZE 88, 47 OF oDlg PIXEL 

oLst0:SetArray(aAlmox)
oLst0:bChange := { || nItemP := oLst0:nAt }  
oLst0:bLine := {|| { IIF(aAlmox[oLst0:nAt,3]=="0",oVm,oVd) , ;
								 aAlmox[oLst0:nAt,1] , ;
								 aAlmox[oLst0:nAt,2] } }
								
oLst0:lAdjustColsize := .F.
////===============================================================================================================================================================
@ 054,003 GROUP oGroup11 To 284,650  PROMPT "KARDEX"                                    OF oDlg PIXEL
@ 061,008 Say   oSayDesde            PROMPT "Desde:"                      SIZE 040,007  OF oDlg PIXEL
@ 061,030 MsGet oGetDesde            VAR    dDesde                        SIZE 050,007  OF oDlg PIXEL
@ 061,085 Say   oSayAte              PROMPT "Até:"                        SIZE 040,007  OF oDlg PIXEL
@ 061,100 MsGet oGetAte              VAR    dAte                          SIZE 050,007  OF oDlg PIXEL
@ 059,170 Say   oAlmoxarife          VAR    cAlmoxarife                   SIZE 050,012  OF oDlg PIXEL COLOR CLR_HBLUE   FONT oFnt3a 

@ 060,336 BUTTON oBtn7   PROMPT "Confirma Data"  			   SIZE 070, 011 PIXEL OF oDlg Action Eval( { || f_movinterno()	} )    ///180
@ 060,408 BUTTON oBtn8   PROMPT "Sair do Kardex" 			   SIZE 070, 011 PIXEL OF oDlg Action Eval( { || f_sairkardex()	} )    ///252
@ 060,480 BUTTON oBtn9   PROMPT "Sair da Rotina" 			   SIZE 070, 011 PIXEL OF oDlg Action Eval( { || lSair := .T. , oDlg:End()	} )   ///324

@ 072,004 LISTBOX oLst5  Fields HEADER "Emissão","TES","C.F","Documento","Ordem de Produção","Entrada (Qty)","Entrada (Custo)","Custo Unit.","Saída (Qty)","Saída (Custo)","Saldo (Qty)","Saldo (Custo)","Sequencia","Fornecedor/Cliente","Pedido/Item","N.Fiscal Origem","Serie Origem","Item Origem","Ident.Poder3","Observação","Sequencia de Calculo" SIZE 646, 204 OF oDlg PIXEL   

oLst5:SetArray(aKardex)
oLst5:bLine   := {|| { aKardex[oLst5:nAt,1] , ;
							  aKardex[oLst5:nAt,2] , ;
							  aKardex[oLst5:nAt,3] , ;
							  aKardex[oLst5:nAt,4] , ;
							  aKardex[oLst5:nAt,5] , ;
							  aKardex[oLst5:nAt,6] , ;
							  aKardex[oLst5:nAt,7] , ;
							  aKardex[oLst5:nAt,8] , ;
							  aKardex[oLst5:nAt,9] , ;
							  aKardex[oLst5:nAt,10] , ;
							  aKardex[oLst5:nAt,11] , ;
							  aKardex[oLst5:nAt,12] , ;
							  aKardex[oLst5:nAt,13] , ;
							  aKardex[oLst5:nAt,14] , ;
							  aKardex[oLst5:nAt,15] , ;
							  aKardex[oLst5:nAt,16] , ;
							  aKardex[oLst5:nAt,17] , ;
							  aKardex[oLst5:nAt,18] , ;
							  aKardex[oLst5:nAt,19] , ;
							  aKardex[oLst5:nAt,20] , ;
							  aKardex[oLst5:nAt,21] } }								
oLst5:lAdjustColsize := .F.
////==============================================================================================================================================
@ 054,003 GROUP oGroup12 To 284,650  PROMPT "MOVIMENTO DE/EM TERCEIRO"                  OF oDlg PIXEL
@ 069,004 GROUP oGroup13 To 282,322  PROMPT "DE TERCEIRO"                               OF oDlg PIXEL
@ 069,324 GROUP oGroup14 To 282,648  PROMPT "EM TERCEIRO"                               OF oDlg PIXEL

@ 060,408 BUTTON oBtn10  PROMPT "Sair do Movimento"         SIZE 070, 011 PIXEL OF oDlg Action Eval( { || f_sairmovp3()	} )
///@ 060,480 BUTTON oBtn11  PROMPT "Sair da Rotina" 			   SIZE 070, 011 PIXEL OF oDlg Action Eval( { || lSair := .T. , oDlg:End()	} )

@ 076,006 LISTBOX oLst6  Fields HEADER "Almox","C.F","N.Fiscal","Dt.Digitação","R/D","Quant.","Custo","Cliente/Fornecedor","Prc.Unitário","Dt.Emissão","Est?","Ident." SIZE 314, 204 OF oDlg PIXEL   
@ 076,326 LISTBOX oLst7  Fields HEADER "Almox","C.F","N.Fiscal","Dt.Digitação","R/D","Quant.","Custo","Cliente/Fornecedor","Prc.Unitário","Dt.Emissão","Est?","Ident." SIZE 320, 204 OF oDlg PIXEL   

oLst6:SetArray(aP3De)
oLst6:bLine   := {|| { aP3De[oLst6:nAt,1] , ;
							  aP3De[oLst6:nAt,2] , ;
							  aP3De[oLst6:nAt,3] , ;
							  aP3De[oLst6:nAt,4] , ;
							  aP3De[oLst6:nAt,5] , ;
							  aP3De[oLst6:nAt,6] , ;
							  aP3De[oLst6:nAt,7] , ;
							  aP3De[oLst6:nAt,8] , ;
							  aP3De[oLst6:nAt,9] , ;
							  aP3De[oLst6:nAt,10] , ;
							  aP3De[oLst6:nAt,11] , ;
							  aP3De[oLst6:nAt,12] } }								

oLst7:SetArray(aP3Em)
oLst7:bLine   := {|| { aP3Em[oLst7:nAt,1] , ;
							  aP3Em[oLst7:nAt,2] , ;
							  aP3Em[oLst7:nAt,3] , ;
							  aP3Em[oLst7:nAt,4] , ;
							  aP3Em[oLst7:nAt,5] , ;
							  aP3Em[oLst7:nAt,6] , ;
							  aP3Em[oLst7:nAt,7] , ;
							  aP3Em[oLst7:nAt,8] , ;
							  aP3Em[oLst7:nAt,9] , ;
							  aP3Em[oLst7:nAt,10] , ;
							  aP3Em[oLst7:nAt,11] , ;
							  aP3Em[oLst7:nAt,12] } }								

////==============================================================================================================================================
@ 054,003 GROUP oGroup15 To 284,650  PROMPT "ONDE É USADO"                  OF oDlg PIXEL

@ 060,408 BUTTON oBtn11  PROMPT "Sair da Estrutura"         SIZE 070, 011 PIXEL OF oDlg Action Eval( { || f_sairusado()	} )

@ 072,004 LISTBOX oLst8  Fields HEADER "Componente/Produto","Descrição","Tipo","UM","Quantidade","(%)Perda","Dt.Ini.Prod.","Dt.Fin.Prod.","Opcional?","Fantasma?","Observação" SIZE 646, 204 OF oDlg PIXEL   

oLst8:SetArray(aUsado)
oLst8:bLine  := {|| { aUsado[oLst8:nAt,1] , ;
							 aUsado[oLst8:nAt,2] , ;
							 aUsado[oLst8:nAt,3] , ;
							 aUsado[oLst8:nAt,4] , ;
							 aUsado[oLst8:nAt,5] , ;
							 aUsado[oLst8:nAt,6] , ;
							 aUsado[oLst8:nAt,7] , ;
							 aUsado[oLst8:nAt,8] , ;
							 aUsado[oLst8:nAt,9] , ;
							 aUsado[oLst8:nAt,10] , ;
							 aUsado[oLst8:nAt,11] } }								
oLst8:lAdjustColsize := .F.
////==============================================================================================================================================
@ 054,003 GROUP oGroup07 To 167,184  PROMPT "RESERVA (OP)"                              OF oDlg PIXEL  
@ 054,003 GROUP oGroup7a To 167,184  PROMPT "EMPENHO"                                   OF oDlg PIXEL  

@ 062,004 LISTBOX oLst1 Fields HEADER "Ano/Semana","Saldo","St","Balanço" SIZE 179, 104 OF oDlg PIXEL   

oLst1:SetArray(aReserva)
oLst1:bChange := { || f_Lst1(oLst1:nAt) }  
oLst1:bLine := {|| { aReserva[oLst1:nAt,1] , ;
							aReserva[oLst1:nAt,2] , ;
							aReserva[oLst1:nAt,3] , ;
							aReserva[oLst1:nAt,4] } }
								
oLst1:lAdjustColsize := .F.

@ 054,186 GROUP oGroup08 To 167,558  PROMPT "CARTEIRA DE VENDA"                  OF oDlg PIXEL  
@ 054,186 GROUP oGroup8a To 167,558  PROMPT "RESERVA (OP/OC/SC)"                 OF oDlg PIXEL  

@ 062,187 LISTBOX oLst2  Fields HEADER "Pedido","Item","Saldo","Dt.Entrega","Parcial?","Atendente","Ped.Cliente","C L I E N T E" SIZE 370, 104 OF oDlg PIXEL   
@ 062,187 LISTBOX oLst2a Fields HEADER "Tipo","Número","Item","Saldo","Via Transp","Dt. ETD","Dt. ETA","F O R N E C E D O R" SIZE 370, 104 OF oDlg PIXEL   

oLst2:SetArray(aPV)
///oLst2:bChange := { || f_Lst1(oLst2:nAT) }  
oLst2:bLine := {|| { aPV[oLst2:nAt,1] , ;
							aPV[oLst2:nAt,2] , ;
							aPV[oLst2:nAt,3] , ;
							aPV[oLst2:nAt,4] , ;
							aPV[oLst2:nAt,5] , ;
							aPV[oLst2:nAt,6] , ;
							aPV[oLst2:nAt,7] , ;
							aPV[oLst2:nAt,8] } }								
oLst2:lAdjustColsize := .F.
*
oLst2a:SetArray(aOC)
oLst2a:bChange    := { || f_Lst2a(oLst2a:nAt) }  
oLst2a:brClicked := { || f_Lst2a(oLst2a:nAt) }
oLst2a:bldblclick := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:blostfocus:= { || msginfo("sai de foco") }
//oLst2a:blClicked := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:bgotfocus := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:bhelp     := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:bkeydown  := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:blostfocus:= { || f_Lst2a(oLst2a:nAt) }
///oLst2a:bmoved    := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:bvalid    := { || f_Lst2a(oLst2a:nAt) }
///oLst2a:bwhen     := { || f_Lst2a(oLst2a:nAt) }
oLst2a:bLine := {|| { aOC[oLst2a:nAt,1] , ;
							 aOC[oLst2a:nAt,2] , ;
							 aOC[oLst2a:nAt,3] , ;
							 aOC[oLst2a:nAt,4] , ;
							 aOC[oLst2a:nAt,5] , ;
							 aOC[oLst2a:nAt,6] , ;
							 aOC[oLst2a:nAt,7] , ;
							 aOC[oLst2a:nAt,8] } }								
oLst2a:lAdjustColsize := .F.
*
@ 170,003 GROUP oGroup09 To 284,315  PROMPT "Ordem de Produção"                  OF oDlg PIXEL     ///161,003 to 284,365

@ 177,004 LISTBOX oLst3  Fields HEADER "Número","Dt.Final Prod","Qtd.Pedida","Qtd.Produzida","Pedido de Venda","Observação"           SIZE 310, 106 OF oDlg PIXEL   ///310,115
@ 177,004 LISTBOX oLst3a Fields HEADER "Número","Produto","Dt.Final Prod","Qtd.Pedida","Qtd.Produzida","Pedido de Venda","Observação" SIZE 310, 106 OF oDlg PIXEL   ///310,115

oLst3:SetArray(aOP1)
oLst3:bChange := { || f_aptproducao(B1COD,oLst3:nAt,aOP1,"1") }  
oLst3:bLine   := {|| { aOP1[oLst3:nAt,1] , ;
							  aOP1[oLst3:nAt,2] , ;
							  aOP1[oLst3:nAt,3] , ;
							  aOP1[oLst3:nAt,4] , ;
							  aOP1[oLst3:nAt,5] , ;
							  aOP1[oLst3:nAt,6] } }								
oLst3:lAdjustColsize := .F.
*
oLst3a:SetArray(aOP2)
oLst3a:bChange := { || f_aptproducao(aOP2[oLst3a:nAt,2],oLst3a:nAt,aOP2,"2") }  
oLst3a:bLine   := {|| { aOP2[oLst3a:nAt,1] , ;
							   aOP2[oLst3a:nAt,2] , ;
							   aOP2[oLst3a:nAt,3] , ;
							   aOP2[oLst3a:nAt,4] , ;
							   aOP2[oLst3a:nAt,5] , ;
							   aOP2[oLst3a:nAt,6] , ;
							   aOP2[oLst3a:nAt,7] } }								
oLst3a:lAdjustColsize := .F.

@ 170,317 GROUP oGroup10 To 284,650  PROMPT "Acompanhamento de Apontamento de Produção"         OF oDlg PIXEL    
@ 178,319 SAY oCTrab           VAR cCTrab                                         SIZE 150, 012 OF oDlg COLOR CLR_HRED   FONT oFnt3a PIXEL 
@ 178,490 SAY oAptOP           VAR cAptOP                                         SIZE 100, 012 OF oDlg COLOR CLR_HRED   FONT oFnt3a PIXEL 
@ 175,560 SAY oLegApt          PROMPT "Legenda:"                                  Size 040,009  OF oDlg Color CLR_BLACK  PIXEL 
@ 182,560 GROUP oGrpApt  TO 183,582  PROMPT ""                                                  OF oDlg PIXEL        
  
oTBmpAp1:= TBitmap():Create(oDlg,175,585,14,14,,'br_vermelho',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	   ///175,564
oTBmpAp1:lAutoSize := .T.
@ 175,594 Say oLegAp1          PROMPT "Aguardando"                                  Size 040,009  Color CLR_BLACK  PIXEL OF oDlg   ///175,573
oTBmpAp2 := TBitmap():Create(oDlg,184,585,14,14,,'br_laranja',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	  ///184,564
oTBmpAp2:lAutoSize := .T.
@ 184,594 Say oLegAp2          PROMPT "Parcial"                                     Size 040,009  Color CLR_BLACK  PIXEL OF oDlg   ///184,573
oTBmpAp3 := TBitmap():Create(oDlg,184,626,14,14,,'br_verde',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	  ///180,616
oTBmpAp3:lAutoSize := .T.
@ 184,635 Say oLegAp3          PROMPT "OK"                                          Size 040,009  Color CLR_BLACK  PIXEL OF oDlg   ///180,625

@ 192,318 LISTBOX oLst4 Fields HEADER "","Operação","Qtd.(Entrada)","Qtd.(Saída)","Dt.Inicial","Dt.Final","Operador"  SIZE 331, 091 OF oDlg PIXEL  

oLst4:SetArray(aAptOP)
oLst4:bLine := { || { IIF(aAptOP[oLst4:nAt,8]=="0",oVm,IIF(aAptOP[oLst4:nAt,8]=="1",oLr,oVd)) , ;
								  aAptOP[oLst4:nAt,2] , ;
								  aAptOP[oLst4:nAt,3] , ;
								  aAptOP[oLst4:nAt,4] , ;
								  aAptOP[oLst4:nAt,5] , ;
								  aAptOP[oLst4:nAt,6] , ;
								  aAptOP[oLst4:nAt,7] } }
oLst4:lAdjustColsize := .F.

@ 073,560 BUTTON oBtn1   PROMPT "Kardex"                    SIZE 090, 011 PIXEL OF oDlg Action Eval( { || IIF(EMPTY(B1TIPO) , nil , f_kardex() ) } )
@ 085,560 BUTTON oBtn2   PROMPT "Movimento Poder Terceiro"  SIZE 090, 011 PIXEL OF oDlg Action Eval( { || IIF(EMPTY(B1TIPO) , nil , f_poder3() ) } )
@ 097,560 BUTTON oBtn3   PROMPT "Ultimas Compra" 			   SIZE 090, 011 PIXEL OF oDlg //Action Eval( { || _xOpc := 1, oDlg:End()	} )
@ 109,560 BUTTON oBtn4   PROMPT "Ultimas Venda"             SIZE 090, 011 PIXEL OF oDlg //Action Eval( { || _xOpc := 1, oDlg:End()	} )
@ 121,560 BUTTON oBtn5   PROMPT "Onde é Usado"   			   SIZE 090, 011 PIXEL OF oDlg Action Eval( { || IIF(EMPTY(B1TIPO) , nil , f_ondeusa() ) } )
@ 133,560 BUTTON oBtn6   PROMPT "Dados MRP"      			   SIZE 090, 011 PIXEL OF oDlg //Action Eval( { || _xOpc := 1, oDlg:End()	} )
@ 145,560 BUTTON oBtn6a  PROMPT "Sair"           			   SIZE 090, 011 PIXEL OF oDlg Action Eval( { || lSair := .T. , oDlg:End()	} )
///@ 145,560 BUTTON "Consumo Médio"  			                  SIZE 090, 011 PIXEL OF oDlg //Action Eval( { || _xOpc := 1, oDlg:End()	} )
//DEFINE BUTTON FROM 006,618 TYPE 1 ENABLE OF oDlg Action 
//DEFINE BUTTON FROM 020,618 TYPE 2 ENABLE OF oDlg Action Eval( { || _xOpc := 2, oDlg:End()	} )
	
oGroup07:Hide()
oGroup7a:Hide()
oGroup08:Hide()
oGroup8a:Hide()
oGroup09:Hide()
oGroup10:Hide()
oGroup11:Hide()
oGroup12:Hide()
oGroup13:Hide()
oGroup14:Hide()
oGroup15:Hide()
oLst1:Hide()
oLst2:Hide()	
oLst2a:Hide()
oLst3:Hide()
oLst3a:Hide()
oLst4:Hide()
oLst5:Hide()
oLst6:Hide()
oLst7:Hide()
oLst8:Hide()
oAptOP:Hide()
oCTrab:Hide()
oSayDesde:Hide()
oGetDesde:Hide()
oSayAte:Hide()
oGetAte:Hide()
oBtn7:Hide()
oBtn8:Hide()
oBtn9:Hide()
oBtn10:Hide()
oBtn11:Hide()
oTBmpAp1:Hide()
oTBmpAp2:Hide()
oTBmpAp3:Hide()
oLegAp1:Hide()
oLegAp2:Hide()
oLegAp3:Hide()
oLegApt:Hide()
oGrpApt:Hide()
oAlmoxarife:Hide()
	
ACTIVATE MSDIALOG oDlg CENTER VALID lSair

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_Produto()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cLista
Local nx
Local lRsp := .T.

IF ( !EMPTY(B1COD) .AND. B1COD <> mB1COD )
	
	SB1->(dbSeek(xFilial("SB1")+B1COD))
	IF SB1->(EOF())
		MsgAlert("Código do produto não cadastrado.","Código inválido")
		B1COD := mB1COD
		lRsp  := .F.
		oProduto:Refresh()
	ELSE
		mB1COD := B1COD
		IF ( SB1->B1_TIPO == "PA" )
			SZE->(dbSeek(xFilial("SZE")+SB1->B1_CLCFAM))
			B1CLDFAM := RTRIM(SZE->ZE_DESCRIC)
			cReserva := "Reserva (O.P)"
		ELSE
			SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
			B1CLDFAM := RTRIM(SBM->BM_DESC)
			cReserva := "Empenho"
		ENDIF
		oGroup07:Refresh()
		B1DESC      := LEFT(SB1->B1_NARRA,90)
		B1UM        := SB1->B1_UM
		B1TIPO      := SB1->B1_TIPO
		nEstoque    := 0
		nEmpenho    := 0
		nPV         := 0
		nOP         := 0
		nOC         := 0
		nSC         := 0
		nDeTerceiro := 0
		nEmTerceiro := 0
		aAlmox      := {{mvLocPad,0,"1"}}                                                           /////{{STRTRAN(B1LOCAL,"'",""),0,"1"}}

		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+B1COD,.T.)
		DO WHILE !EOF().AND.B2_FILIAL==xFilial("SB2").AND.B2_COD==B1COD
			IF ( SB2->B2_LOCAL $ mvLocal )
				IF ( SB2->B2_LOCAL == mvLocPad )                                                      /////$ &(B1LOCAL) )
					nEmpenho += SB2->B2_QEMP 
					nEstoque += SB2->B2_QATU 
				ENDIF
				IF ( SB2->B2_QATU <> 0 )
					cLista := IIF(SB2->B2_LOCAL == mvLocPad , "1" , "0" )                              /////IIF(M->cNumEmp=="0301",IIF(SB2->B2_LOCAL == "02" , "1", "0" ),IIF(SB2->B2_LOCAL=="01","1","0") )    
					///AADD(aAlmox , { SB2->B2_LOCAL , TRANSF(SB2->B2_QATU,cPictQtd) , cLista } )
					nx := ASCAN(aAlmox , { |x| x[1]==SB2->B2_LOCAL } )
					IF ( nx == 0 )
						AADD(aAlmox , { SB2->B2_LOCAL , SB2->B2_QATU , cLista } )
					ELSE
						aAlmox[nx,2] := SB2->B2_QATU
						aAlmox[nx,3] := cLista
					ENDIF
				ENDIF
			ENDIF
			dbSkip()
		ENDDO

		oLst0:SetArray(aAlmox)
		oLst0:bLine := {|| { IIF(aAlmox[oLst0:nAt,3]=="0",oVm,oVd) , ;
										 aAlmox[oLst0:nAt,1] , ;
										 aAlmox[oLst0:nAt,2] } }
      oLst0:Refresh()

		nBalanco := nEstoque
		aAptOP   := {}
		
		IF ( B1TIPO $ "PA/PI" )
			dbSelectArea("SG2")
			dbSetOrder(3)
			dbSeek(xFilial("SG2")+B1COD,.T.)
			DO WHILE !EOF().AND.G2_FILIAL==xFilial("SG2").AND.G2_PRODUTO==B1COD
				IF ( SG2->G2_CODIGO == "01" )
					AADD(aAptOP , { SG2->G2_OPERAC  , ;
										 SG2->G2_OPERAC+" - "+SG2->G2_DESCRI  , ;
										 0               , ;
										 0               , ;
										 SPACE(8)        , ;
										 SPACE(8)        , ;
										 SPACE(10)       , ;
										 "0"             , ;
										 SG2->G2_RECURSO } )                  
				ENDIF
				dbSkip()
			ENDDO
			IF ( EMPTY(aAptOP) )
				aAptOP := {{"","","","","","",SPACE(10),"",""}}
			ENDIF
		ENDIF
		
		IF ( B1TIPO == 'PA' )
			f_pacabado()
		ELSE
			f_matprima()
		ENDIF

		f_movpoder3()
		
		f_usado()
		
		oLst1:SetArray(aReserva)
		oLst1:bChange := { || f_Lst1(oLst1:nAT) }  
		oLst1:bLine   := {|| { aReserva[oLst1:nAt,5] , ;
									  aReserva[oLst1:nAt,2] , ;
									  aReserva[oLst1:nAt,3] , ;
									  aReserva[oLst1:nAt,4] } }										
		oLst1:lAdjustColsize := .F.
		oLst1:GoTop()

		oLst1:Refresh()
		
	ENDIF
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_Lst1(xnItem)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx

DO CASE
	CASE B1TIPO == "PA"
			aOP1 := {}
			aPV  := {}

			nx := ASCAN(aOrdPrd , { |x| x[7]+x[8] == aReserva[xnItem,1] } )
			DO WHILE nx > 0 .AND. nx <= LEN(aOrdPrd) .AND. aOrdPrd[nx,7]+aOrdPrd[nx,8]==aReserva[xnItem,1]
				AADD(aOP1 , aOrdPrd[nx] )
				nx++
			ENDDO
			IF ( LEN(aOP1) == 0 )
				aOP1 := {{"","","","","",SPACE(30),"","","","",""}}
			ENDIF

			nx := ASCAN(aCartVen , { |x| x[9]+x[10] == aReserva[xnItem,1] } )
			DO WHILE nx > 0 .AND. nx <= LEN(aCartVen).AND. aCartVen[nx,9]+aCartVen[nx,10]==aReserva[xnItem,1]
				AADD(aPV , aCartVen[nx] )
				nx++
			ENDDO
			IF ( LEN(aPV) = 0 )
				aPV  := {{"","","","","","","","",""}}
			ENDIF

			oLst2:SetArray(aPV)
			oLst2:bLine := {|| { aPV[oLst2:nAt,1] , ;
										aPV[oLst2:nAt,2] , ;
										aPV[oLst2:nAt,3] , ;
										aPV[oLst2:nAt,4] , ;
										aPV[oLst2:nAt,5] , ;
										aPV[oLst2:nAt,6] , ;
										aPV[oLst2:nAt,7] , ;
										aPV[oLst2:nAt,8] } }
											
			oLst2:GoTop()

			oLst3:SetArray(aOP1)
			oLst3:bLine := {|| { aOP1[oLst3:nAt,1] , ;
										aOP1[oLst3:nAt,2] , ;
										aOP1[oLst3:nAt,3] , ;
										aOP1[oLst3:nAt,4] , ;
										aOP1[oLst3:nAt,5] , ;
										aOP1[oLst3:nAt,6] } }
											
			oLst3:GoTop()

			oLst2:Refresh()
			oLst3:Refresh()
			
	OTHERWISE

			aOP2 := {}
			aOC  := {}

			nx := ASCAN(aOrdPrd , { |x| x[8]+x[9] == aReserva[xnItem,1] } )
			DO WHILE nx > 0 .AND. nx <= LEN(aOrdPrd) .AND. aOrdPrd[nx,8]+aOrdPrd[nx,9]==aReserva[xnItem,1]
				AADD(aOP2 , aOrdPrd[nx] )
				nx++
			ENDDO
			IF ( LEN(aOP2) == 0 )
				aOP2 := {{"","","","","","",SPACE(30),"","","",""}}
			ENDIF

			nx := ASCAN(aCartCom , { |x| x[9]+x[10] == aReserva[xnItem,1] } )
			DO WHILE nx > 0 .AND. nx <= LEN(aCartCom) .AND. aCartCom[nx,9]+aCartCom[nx,10]==aReserva[xnItem,1]
				AADD(aOC , aCartCom[nx] )
				nx++
			ENDDO
			IF ( LEN(aOC) = 0 )
				aOC := {{"","","","","","","","","","","","",""}}
			ENDIF

			aAptOP := {}
			dbSelectArea("SG2")
			dbSetOrder(3)
			dbSeek(xFilial("SG2")+aOP2[1,2],.T.)
			DO WHILE !EOF().AND.G2_FILIAL==xFilial("SG2").AND.G2_PRODUTO==aOP2[1,2]
			   IF ( SG2->G2_CODIGO == "01" )
					AADD(aAptOP , { SG2->G2_OPERAC  , ;
										 SG2->G2_OPERAC+" - "+SG2->G2_DESCRI  , ;
										 0               , ;
										 0               , ;
										 SPACE(8)        , ;
										 SPACE(8)        , ;
										 SPACE(10)       , ;
										 "0"             , ;
										 SG2->G2_RECURSO } )
				ENDIF
				dbSkip()
			ENDDO
			IF ( EMPTY(aAptOP) )
				aAptOP := {{"","","","","","",SPACE(10),"",""}}
			ENDIF
			
			oLst2a:SetArray(aOC)
			oLst2a:bLine := {|| { aOC[oLst2a:nAt,1] , ;
										 aOC[oLst2a:nAt,2] , ;
										 aOC[oLst2a:nAt,3] , ;
										 aOC[oLst2a:nAt,4] , ;
										 aOC[oLst2a:nAt,5] , ;
										 aOC[oLst2a:nAt,6] , ;
										 aOC[oLst2a:nAt,7] , ;
										 aOC[oLst2a:nAt,8] } }
											
			oLst2a:GoTop()

			oLst3a:SetArray(aOP2)
			oLst3a:bLine := {|| { aOP2[oLst3a:nAt,1] , ;
										 aOP2[oLst3a:nAt,2] , ;
										 aOP2[oLst3a:nAt,3] , ;
										 aOP2[oLst3a:nAt,4] , ;
										 aOP2[oLst3a:nAt,5] , ;
										 aOP2[oLst3a:nAt,6] , ;
										 aOP2[oLst3a:nAt,7] } }
											
			oLst3a:GoTop()
	
			oLst2a:Refresh()
			oLst3a:Refresh()

			f_aptproducao(aOP2[1,2],1,aOP2,"2")
			
ENDCASE	


Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_Lst2a(xnItem)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx
Local xcTipo := aOC[xnItem,1]

DO CASE
	CASE xcTipo == "OP"

			aAptOP := {}
			dbSelectArea("SG2")
			dbSetOrder(3)
			dbSeek(xFilial("SG2")+B1COD,.T.)
			DO WHILE !EOF().AND.G2_FILIAL==xFilial("SG2").AND.G2_PRODUTO==B1COD
			   IF ( SG2->G2_CODIGO == "01" )
					AADD(aAptOP , { SG2->G2_OPERAC  , ;
										 SG2->G2_OPERAC+" - "+SG2->G2_DESCRI  , ;
										 0               , ;
										 0               , ;
										 SPACE(8)        , ;
										 SPACE(8)        , ;
										 SPACE(10)       , ;
										 "0"             , ;
										 SG2->G2_RECURSO } )
				ENDIF
				dbSkip()
			ENDDO
			IF ( EMPTY(aAptOP) )
				aAptOP := {{"","","","","","",SPACE(10),"",""}}
			ENDIF
	
			f_aptproducao(B1COD,xnItem,aOC,"3")

			
	OTHERWISE

	
ENDCASE	

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_pacabado()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry,cAno,cPeriodo,cSemana
Local dxData,dData1,dData2
Local ix,nx,nz,nSaldo,nSemana

////
////Ordem de Producao
////
cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SC2")+" "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND   C2_FILIAL = '"+xFilial("SC2")+"' "
cQry += "AND   C2_PRODUTO = '"+B1COD+"' "
cQry += "AND   C2_DATRF  = ' ' "
cQry += "AND   C2_TPOP   = 'F' " 
cQry += "AND   C2_LOCAL  = '"+mvLocPad+"' "
cQry += "ORDER BY C2_NUM,C2_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","C2_DATPRF","D",08,0)

aReserva := {}
aOrdPrd  := {}
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
   dxData := TMP->C2_DATPRF                 ////Data final de producao = data de entrega do pedido
	nSaldo := TMP->(C2_QUANT - C2_QUJE)
	nOP    += nSaldo
   IF ( dxData >= cDatPri3 )
	   IX   := ( dxData - cDatPri3 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno3
   ELSEIF ( dxData >= cDatPri2 )
	   IX   := ( dxData - cDatPri2 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno2
   ELSEIF ( dxData < cDatPri1 )
	   IX   := 0   //1
	   cAno := cAno0   //LEFT(DTOS(dxData),4)
   ELSE
	   IX   := ( dxData - cDatPri1 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno1
   ENDIF
   nx := ASCAN(aReserva , { |x| x[1]== (cAno + STRZERO(ix,2)) } )
   IF ( nx == 0 )
	   AADD( aReserva , { cAno + STRZERO(ix,2) , nSaldo , " " , 0 , " " } )
   ELSE
	   aReserva[nx,2] += nSaldo
   ENDIF
	AADD(aOrdPrd , { TRANSF(TMP->(C2_NUM+C2_ITEM+C2_SEQUEN),"@R XXXXXX.99.999") , ;
						  DTOC(TMP->C2_DATPRF) , ;
					     TMP->C2_QUANT        , ;
					     TMP->C2_QUJE         , ;
					     IIF(!EMPTY(TMP->C2_PEDIDO) , TMP->C2_PEDIDO+"/"+TMP->C2_ITEMPV , " " ) , ;
					     TMP->C2_OBS          , ;
					     cAno                 , ;
					     STRZERO(ix,2)        , ;
					     TMP->(C2_NUM+C2_ITEM+C2_SEQUEN) , ;
						  ""   , ;
						  ""   } )   
	dbSkip()
ENDDO
TMP->(dbCloseArea())

////
////Extrai as operacoes de apontamento
////
aRotOper := {}
FOR nx:=1 TO LEN(aOrdPrd)
	dbSelectArea("SH6")
	dbSetOrder(1)
	dbSeek(xFilial("SH6")+aOrdPrd[nx,9],.T.)
	DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(aOrdPrd[nx,9])
		xcOper := SH6->H6_OPERAC
		AADD(aRotOper , { SH6->H6_OP , SH6->H6_OPERAC , 0 , 0 , "" , "" , "" } )
		nz := LEN(aRotOper)
		DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(aOrdPrd[nx,9]).AND.H6_OPERAC==xcOper
			aRotOper[nz,5] := DTOC(SH6->H6_DATAINI)   
			aRotOper[nz,6] := IIF(SH6->H6_X_QTS > 0 , SH6->H6_DATAFIN , aAptOP[nx,6] )
			aRotOper[nz,7] := SH6->H6_OPERADO
			aRotOper[nz,3] += SH6->H6_X_QTE
			aRotOper[nz,4] += SH6->H6_X_QTS
			dbSkip()
		ENDDO
	ENDDO
NEXT
IF ( LEN(aRotOper) == 0 )
	aRotOper := {{"","",0,0,"","",""}}
ENDIF

////
////Pedido de Venda
////
cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SC5")+" C5,"+RetSqlName("SC6")+" C6,"+RetSqlName("SA1")+" A1,"+RetSqlName("SF4")+" F4 "
cQry += "WHERE C5.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' "
cQry += "AND   C5_FILIAL = '"+xFilial("SC5")+"' AND C6_FILIAL = '"+xFilial("SC6")+"' AND A1_FILIAL = '"+xFilial("SA1")+"' AND F4_FILIAL = '"+xFilial("SF4")+"' "
cQry += "AND   C6_PRODUTO = '"+B1COD+"' AND C6_QTDVEN > C6_QTDENT "
cQry += "AND   C6_LOCAL  = '"+mvLocPad+"' "
cQry += "AND   C6_CF IN ('5101','5102','5107','5911','6101','6102','6107','6401','6911','7101','7102','7107','7911','5122','6122') "     ///6151???
cQry += "AND   F4_CODIGO = C6_TES AND F4_ESTOQUE = 'S' "
cQry += "AND   C5_NUM = C6_NUM "
cQry += "AND   C5_BLQ = ' ' "
cQry += "AND   A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
cQry += "ORDER BY C6_NUM,C6_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","C6_ENTREG","D",08,0)

aCartVen := {}
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	nSaldo := TMP->(C6_QTDVEN - C6_QTDENT)
	nPV    += nSaldo
	dxData := TMP->C6_ENTREG
   IF ( dxData >= cDatPri3 )
	   IX   := ( dxData - cDatPri3 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno3
   ELSEIF ( dxData >= cDatPri2 )
	   IX   := ( dxData - cDatPri2 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno2
   ELSEIF ( dxData < cDatPri1 )
	   IX   := 0   //1
	   cAno := cAno0   //LEFT(DTOS(dxData),4)
   ELSE
	   IX   := ( dxData - cDatPri1 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno1
   ENDIF
   nx := ASCAN(aReserva , { |x| x[1]==(cAno + STRZERO(ix,2)) } )
   IF ( nx == 0 )
	   AADD( aReserva , { cAno + STRZERO(ix,2) , 0 , " " , 0 , " " } )
   ENDIF
	cParcial := IIF(TMP->C5_CLPARC=="S", "SIM" , "NÃO" )
	AADD(aCartVen , { TMP->C6_NUM           , ;
							TMP->C6_ITEM          , ;
							TMP->(C6_QTDVEN-C6_QTDENT) , ;
							DTOC(TMP->C6_ENTREG)  , ;
							cParcial              , ;
							TMP->C5_CLATEND       , ;
							TMP->C5_CLPEDCL       , ;
							TMP->A1_NOME          , ;
							cAno                  , ;
							STRZERO(ix,2) } )
	dbSkip()
ENDDO
TMP->(dbCloseArea())

IF ( LEN(aReserva) == 0 )
	aReserva := {{"","","","",""}}
ENDIF

aSort(aReserva ,,,{|x,y| x[1] < y[1] } )
aSort(aCartVen ,,,{|x,y| x[9]+x[10]+x[1]+x[2] < y[9]+y[10]+y[1]+y[2] } )
aSort(aOrdPrd  ,,,{|x,y| x[7]+x[8]+x[1]+x[2] < y[7]+y[8]+y[1]+y[2] } )

nBalanco := ( nBalanco + nOP - nPV )
nCritico := nEstoque

FOR ix:=1 TO LEN(aReserva)
	 cSemana := SUBS(aReserva[ix,1],5,2)
	 IF ( !EMPTY(cSemana).AND.cSemana <> "00" )
		 nSaldo  := 0
		 nx      := ASCAN(aCartVen , { |x| x[9]+x[10] == aReserva[ix,1] } )
		 DO WHILE nx > 0.AND.nx<=LEN(aCartVen).AND.aCartVen[nx,9]+aCartVen[nx,10]==aReserva[ix,1]
			 nSaldo += aCartVen[nx,3]
			 nx++
		 ENDDO
       nCritico := ( nCritico + aReserva[ix,2] - nSaldo )
       nPerPV   := ROUND(nSaldo * 0.2 , 0)
       xStatus  := IIF(nCritico < 0 , " *" , IIF(ABS(nSaldo) > 0 .AND. ABS(nCritico) > nPerPv , " !" ,"  " ) )
		 
		 cAno           := SUBS(aReserva[ix,1],1,4)
		 nSemana        := VAL(SUBS(aReserva[ix,1],5,2))
		 dData1         := IIF(cAno==cAno1,cDatPri1,IIF(cAno==cAno2,cDatPri2,cDatPri3))
		 dData2         := ( dData1 + ( ( nSemana * 7 ) -1 ) )
		 dData1         := ( dData2 - 6 )
		 cPeriodo       := cAno+"/"+SUBS(aReserva[ix,1],5,2)+"    " + STRZERO(DAY(dData1),2) + "/" + STRZERO(MONTH(dData1),2)
		 cPeriodo       := cPeriodo + " - " + STRZERO(DAY(dData2),2) + "/" + STRZERO(MONTH(dData2),2)
		 aReserva[ix,3] := xStatus
		 aReserva[ix,4] := nCritico
		 aReserva[ix,5] := cPeriodo
	 ENDIF
NEXT

oGroup7a:Hide()
oGroup07:Show()
oGroup8a:Hide()
oGroup08:Show()
oGroup09:Show()
oGroup10:Show()
oLst1:Show()
oLst2:Show()	
oLst2a:Hide()
oLst3:Show()
oLst3a:Hide()
oLst4:Show()
oAptOP:Show()
oCTrab:Show()
oTBmpAp1:Show()
oTBmpAp2:Show()
oTBmpAp3:Show()
oLegAp1:Show()
oLegAp2:Show()
oLegAp3:Show()
oLegApt:Show()
oGrpApt:Show()
///oGroup07:Refresh()
///oGroup08:Refresh()
///oGroup09:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_matprima()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry,cAno,cPeriodo,cSemana
Local dxData,dData1,dData2
Local ix,nx,nz,nSaldo,nSemana,nPercent

////
////Empenho
////
cQry := "SELECT D4_OP,D4_DATA,D4_COD,D4_LOCAL,SUM(D4_QTDEORI) D4_QTDEORI,SUM(D4_QUANT) D4_QUANT,C2_PRODUTO,C2_LOCAL,C2_EMISSAO,C2_DATPRI,C2_DATPRF,C2_QUANT,C2_QUJE,C2_DATRF,C2_PEDIDO,C2_ITEMPV,C2_TPOP,C2_OBS "
cQry += "FROM "+RetSqlName("SD4")+" D4,"+RetSqlName("SC2")+" C2 "
cQry += "WHERE D4.D_E_L_E_T_ = ' ' AND C2.D_E_L_E_T_ = ' ' "
cQry += "AND   D4_FILIAL = '"+xFilial("SD4")+"' AND C2_FILIAL = '"+xFilial("SC2")+"' "
cQry += "AND   D4_COD    = '"+B1COD+"' AND D4_QUANT > 0 AND D4_LOCAL = '"+mvLocPad+"' "
cQry += "AND   D4_OP     = C2_NUM+C2_ITEM+C2_SEQUEN "
cQry += "AND   C2_TPOP   = 'F' " 
cQry += "AND   C2_LOCAL  = '"+mvLocPad+"' "
cQry += "GROUP BY D4_OP,D4_DATA,D4_COD,D4_LOCAL,C2_PRODUTO,C2_LOCAL,C2_EMISSAO,C2_DATPRI,C2_DATPRF,C2_QUANT,C2_QUJE,C2_DATRF,C2_PEDIDO,C2_ITEMPV,C2_TPOP,C2_OBS "
cQry += "ORDER BY D4_OP,D4_DATA "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","C2_DATPRI" ,"D",08,0)
TcSetField("TMP","C2_DATPRF" ,"D",08,0)
TcSetField("TMP","C2_EMISSAO","D",08,0)
TcSetField("TMP","D4_DATA"   ,"D",08,0)

nEmpenho := 0
aReserva := {}
aOrdPrd  := {}
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
   dxData   := TMP->D4_DATA             
	nEmpenho += TMP->D4_QUANT
   IF ( dxData >= cDatPri3 )
	   IX   := ( dxData - cDatPri3 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno3
   ELSEIF ( dxData >= cDatPri2 )
	   IX   := ( dxData - cDatPri2 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno2
   ELSEIF ( dxData < cDatPri1 )
	   IX   := 0   //1
	   cAno := cAno0   //LEFT(DTOS(dxData),4)
   ELSE
	   IX   := ( dxData - cDatPri1 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno1
   ENDIF
   nx := ASCAN(aReserva , { |x| x[1]== (cAno + STRZERO(ix,2)) } )
   IF ( nx == 0 )
	   AADD( aReserva , { cAno + STRZERO(ix,2) , TMP->D4_QUANT , " " , 0 , " " } )
   ELSE
	   aReserva[nx,2] += TMP->D4_QUANT
   ENDIF
	
	AADD(aOrdPrd , { TRANSF(RTRIM(TMP->D4_OP),"@R XXXXXX.99.999") , ;
					     TMP->C2_PRODUTO      , ;
					     DTOC(TMP->D4_DATA)   , ;
					     TMP->C2_QUANT        , ;
					     TMP->C2_QUJE         , ;
					     IIF(!EMPTY(TMP->C2_PEDIDO) , TMP->C2_PEDIDO+"/"+TMP->C2_ITEMPV , " " ) , ;
					     TMP->C2_OBS          , ;
					     cAno                 , ;
					     STRZERO(ix,2)        , ;
					     TMP->D4_OP           , ;
						  "" } )
	dbSkip()
ENDDO
TMP->(dbCloseArea())

////
////Extrai as operacoes de apontamento
////
aRotOper := {}
FOR nx:=1 TO LEN(aOrdPrd)
	 dbSelectArea("SH6")
	 dbSetOrder(1)
	 dbSeek(xFilial("SH6")+aOrdPrd[nx,10],.T.)
	 DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(aOrdPrd[nx,10])
		 xcOper := SH6->H6_OPERAC
		 AADD(aRotOper , { SH6->H6_OP , SH6->H6_OPERAC , 0 , 0 , "" , "" , "" } )
		 nz := LEN(aRotOper)
		 DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(aOrdPrd[nx,10]).AND.H6_OPERAC==xcOper
			 aRotOper[nz,5] := DTOC(SH6->H6_DATAINI)   
			 aRotOper[nz,6] := IIF(SH6->H6_X_QTS > 0 , SH6->H6_DATAFIN , SPACE(8) )
			 aRotOper[nz,7] := SH6->H6_OPERADO
			 aRotOper[nz,3] += SH6->H6_X_QTE
			 aRotOper[nz,4] += SH6->H6_X_QTS
			 dbSkip()
		 ENDDO
	 ENDDO
NEXT

////
////Ordem de Producao
////
cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SC2")+" "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND   C2_FILIAL = '"+xFilial("SC2")+"' "
cQry += "AND   C2_PRODUTO = '"+B1COD+"' "
cQry += "AND   C2_DATRF  = ' ' "
cQry += "AND   C2_TPOP   = 'F' " 
cQry += "AND   C2_LOCAL  = '"+mvLocPad+"' "
cQry += "ORDER BY C2_NUM,C2_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","C2_DATPRI","D",08,0)
TcSetField("TMP","C2_DATPRF","D",08,0)

aCartCom := {}
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
   dxData := TMP->C2_DATPRF                 ////Data final de producao = data de entrega do pedido
	nSaldo := TMP->(C2_QUANT - C2_QUJE)
	nOP    += nSaldo
   IF ( dxData >= cDatPri3 )
	   IX   := ( dxData - cDatPri3 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno3
   ELSEIF ( dxData >= cDatPri2 )
	   IX   := ( dxData - cDatPri2 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno2
   ELSEIF ( dxData < cDatPri1 )
	   IX   := 0   //1
	   cAno := cAno0   //LEFT(DTOS(dxData),4)
   ELSE
	   IX   := ( dxData - cDatPri1 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno1
   ENDIF

   nx := ASCAN(aReserva , { |x| x[1]==(cAno + STRZERO(ix,2)) } )
   IF ( nx == 0 )
	   AADD( aReserva , { cAno + STRZERO(ix,2) , 0 , " " , 0 , " " } )
   ENDIF

	dbSelectArea("SH6")
	dbSetOrder(1)
	dbSeek(xFilial("SH6")+TMP->(C2_NUM+C2_ITEM+C2_SEQUEN),.T.)
	DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(TMP->(C2_NUM+C2_ITEM+C2_SEQUEN))
		xcOper := SH6->H6_OPERAC
		AADD(aRotOper , { SH6->H6_OP , SH6->H6_OPERAC , 0 , 0 , "" , "" , "" } )
		nz := LEN(aRotOper)
		DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(TMP->(C2_NUM+C2_ITEM+C2_SEQUEN)).AND.H6_OPERAC==xcOper
			aRotOper[nz,5] := DTOC(SH6->H6_DATAINI)   
			aRotOper[nz,6] := IIF(SH6->H6_X_QTS > 0 , SH6->H6_DATAFIN , SPACE(8) )
			aRotOper[nz,7] := SH6->H6_OPERADO
			aRotOper[nz,3] += SH6->H6_X_QTE
			aRotOper[nz,4] += SH6->H6_X_QTS
			dbSkip()
		ENDDO
	ENDDO
	
	AADD(aCartCom , { "OP"                 , ;
					      TMP->C2_NUM          , ;
					      TMP->C2_ITEM         , ;
					      nSaldo               , ;
					      SPACE(15)            , ;
							TMP->C2_DATPRI       , ;
							TMP->C2_DATPRF       , ;
					      PADR("PRODUCAO",40)  , ;
					      cAno                 , ;
					      STRZERO(ix,2)        , ;
					      TMP->C2_SEQUEN       , ;
							SPACE(2)       } )   
	
	dbSelectArea("TMP")						
	dbSkip()
ENDDO
TMP->(dbCloseArea())

IF ( LEN(aRotOper) == 0 )
	aRotOper := {{"","",0,0,"","",""}}
ENDIF

////
////Pedido de Compra
////
cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SC7")+" C7,"+RetSqlName("SA2")+" A2 "
cQry += "WHERE C7.D_E_L_E_T_ = ' ' AND A2.D_E_L_E_T_ = ' ' "
cQry += "AND   C7_FILIAL  = '"+xFilial("SC7")+"' AND A2_FILIAL = '"+xFilial("SA2")+"' "
cQry += "AND   C7_PRODUTO = '"+B1COD+"' AND C7_QUANT > C7_QUJE "
cQry += "AND   C7_LOCAL   = '"+mvLocPad+"' "
cQry += "AND   C7_ENCER   = ' ' AND C7_RESIDUO = ' ' "
cQry += "AND   C7_TIPO    = 1 "
cQry += "AND   A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA "
cQry += "ORDER BY C7_NUM,C7_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","C7_DATPRF","D",08,0)
TcSetField("TMP","C7_CDTPLJT","D",08,0)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	SX5->(dbSeek(xFilial("SX5")+"ZV"+TMP->C7_CVIA))	
	cViaTransp := RTRIM(SX5->X5_DESCRI)
	nSaldo := TMP->(C7_QUANT - C7_QUJE)
	nOC    += nSaldo
	dxData := TMP->C7_CDTPLJT
   IF ( dxData >= cDatPri3 )
	   IX   := ( dxData - cDatPri3 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno3
   ELSEIF ( dxData >= cDatPri2 )
	   IX   := ( dxData - cDatPri2 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno2
   ELSEIF ( dxData < cDatPri1 )
	   IX   := 0   //1
	   cAno := cAno0   //LEFT(DTOS(dxData),4)
   ELSE
	   IX   := ( dxData - cDatPri1 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno1
   ENDIF
   nx := ASCAN(aReserva , { |x| x[1]==(cAno + STRZERO(ix,2)) } )
   IF ( nx == 0 )
	   AADD( aReserva , { cAno + STRZERO(ix,2) , 0 , " " , 0 , " " } )
   ENDIF

	AADD(aCartCom , { "OC"            , ;
							TMP->C7_NUM     , ;
							TMP->C7_ITEM    , ;
							nSaldo          , ;
							cViaTransp      , ;
							TMP->C7_DATPRF  , ;
							dxData          , ;
							TMP->A2_NOME    , ;
							cAno            , ;
							STRZERO(ix,2)   , ;
							TMP->C7_FORNECE , ;
							TMP->C7_LOJA    } )
	dbSkip()
ENDDO
TMP->(dbCloseArea())

////
////Solicitacao de Compra
////
cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SC1")+" C1 "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND   C1_FILIAL  = '"+xFilial("SC1")+"' "
cQry += "AND   C1_PRODUTO = '"+B1COD+"' AND C1_QUANT > C1_QUJE "
cQry += "AND   C1_LOCAL   = '"+mvLocPad+"' "
cQry += "ORDER BY C1_NUM,C1_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","C1_DATPRF","D",08,0)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	nSaldo := TMP->(C1_QUANT - C1_QUJE)
	nSC    += nSaldo
	SX5->(dbSeek(xFilial("SX5")+"ZV"+TMP->C1_CVIA))	
	dxData := TMP->C1_DATPRF 
	dDtPljto := ( dxData + VAL(RTRIM(SX5->X5_CHAVE)) )
   IF ( dxData >= cDatPri3 )
	   IX   := ( dxData - cDatPri3 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno3
   ELSEIF ( dxData >= cDatPri2 )
	   IX   := ( dxData - cDatPri2 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno2
   ELSEIF ( dxData < cDatPri1 )
	   IX   := 0   //1
	   cAno := cAno0   //LEFT(DTOS(dxData),4)
   ELSE
	   IX   := ( dxData - cDatPri1 )
	   IX   := ( INT((IX/7)) + 1 )
	   cAno := cAno1
   ENDIF
   nx := ASCAN(aReserva , { |x| x[1]==(cAno + STRZERO(ix,2)) } )
   IF ( nx == 0 )
	   AADD( aReserva , { cAno + STRZERO(ix,2) , 0 , " " , 0 , " " } )
   ENDIF

	AADD(aCartCom , { "SC"            , ;
							TMP->C1_NUM     , ;
							TMP->C1_ITEM    , ;
							nSaldo          , ;
							cViaTransp      , ;
							TMP->C1_DATPRF  , ;
							dDtPljto        , ;
							SPACE(40)       , ;
							cAno            , ;
							STRZERO(ix,2)   , ;
							SPACE(6)        , ;
							SPACE(2)        } )
	dbSkip()
ENDDO
TMP->(dbCloseArea())

IF ( LEN(aReserva) == 0 )
	aReserva := {{"","","","",""}}
ENDIF

aSort(aReserva ,,,{|x,y| x[1] < y[1] } )
aSort(aCartCom ,,,{|x,y| x[9]+x[10]+x[1]+x[2]+x[3] < y[9]+y[10]+y[1]+y[2]+y[3] } )
aSort(aOrdPrd  ,,,{|x,y| x[8]+x[9]+x[1]+x[2] < y[8]+y[9]+y[1]+y[2] } )

nBalanco := ( nBalanco + nOC + nSC + nOP - nEmpenho )
nCritico := nEstoque

FOR ix:=1 TO LEN(aReserva)
	 cSemana := SUBS(aReserva[ix,1],5,2)
	 IF ( !EMPTY(cSemana).AND.cSemana <> "00" )
		 nSaldo  := 0
		 nx      := ASCAN(aCartCom , { |x| x[9]+x[10] == aReserva[ix,1] } )
		 DO WHILE nx > 0 .AND. nx<=LEN(aCartCom).AND.aCartCom[nx,9]+aCartCom[nx,10]==aReserva[ix,1]
			 nSaldo += aCartCom[nx,4]
			 nx++
		 ENDDO
       nCritico := ( nCritico - aReserva[ix,2] + nSaldo )
       nPercent := ROUND(nSaldo * 0.2 , 0)
       xStatus  := IIF(nCritico < 0 , " *" , IIF(ABS(nSaldo) > 0 .AND. ABS(nCritico) > nPercent , " !" ,"  " ) )
		 
		 cAno           := SUBS(aReserva[ix,1],1,4)
		 nSemana        := VAL(SUBS(aReserva[ix,1],5,2))
		 dData1         := IIF(cAno==cAno1,cDatPri1,IIF(cAno==cAno2,cDatPri2,cDatPri3))
		 dData2         := ( dData1 + ( ( nSemana * 7 ) -1 ) )
		 dData1         := ( dData2 - 6 )
		 cPeriodo       := cAno+"/"+SUBS(aReserva[ix,1],5,2)+"    " + STRZERO(DAY(dData1),2) + "/" + STRZERO(MONTH(dData1),2)
		 cPeriodo       := cPeriodo + " - " + STRZERO(DAY(dData2),2) + "/" + STRZERO(MONTH(dData2),2)
		 aReserva[ix,3] := xStatus
		 aReserva[ix,4] := nCritico
		 aReserva[ix,5] := cPeriodo
	 ENDIF
NEXT

oGroup07:Hide()
oGroup7a:Show()
oGroup08:Hide()
oGroup8a:Show()
oGroup09:Show()
oGroup10:Show()
oLst1:Show()
oLst2:Hide()
oLst2a:Show()
oLst3:Hide()	
oLst3a:Show()
oLst4:Show()
oAptOP:Show()
oCTrab:Show()
oTBmpAp1:Show()
oTBmpAp2:Show()
oTBmpAp3:Show()
oLegAp1:Show()
oLegAp2:Show()
oLegAp3:Show()
oLegApt:Show()
oGrpApt:Show()
///oGroup07:Refresh()
///oGroup08:Refresh()
///oGroup09:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_aptproducao(xcProduto,xnItem,amOP,xcTipo)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx,nz,nxSaldo

////
////Zera vetor das operacoes
////
FOR nx:=1 TO LEN(aAptOP)
	 aAptOP[nx,3] := 0              ///Qty. Entrada
	 aAptOP[nx,4] := 0              ///Qty. Saida
	 aAptOP[nx,5] := SPACE(8)       ///Data de Entrada
	 aAptOP[nx,6] := SPACE(8)       ///Data de Saida
	 aAptOP[nx,7] := SPACE(10)      ///Operador
	 aAptOP[nx,8] := "0"            ///Status: 0=Aguardando; 1=Parcial; 2=OK
NEXT

cAptOP := ""
cCTrab := ""
IF ( !EMPTY(aAptOP[1,9]) )
	SH1->(dbSeek(xFilial("SH1")+aAptOP[1,9]))
	cCTrab := "Centro de Trabalho: "+RTRIM(SH1->H1_DESCRI)
ENDIF
IF ( !EMPTY(amOP[xnItem,1]) )
	IF ( xcTipo == "3" )
		xcOP   := amOP[xnItem,2]+amOP[xnItem,3]+amOP[xnItem,11]
		xnQtd  := amOP[xnItem,4]		
		cAptOP := "O.P.: "+TRANSF(xcOP,"@R XXXXXX.XX.999")
	ELSE	
		IF ( xcTipo == "1" )
			xcOP   := amOP[xnItem,9]
			xnQtd  := amOP[xnItem,3]		
		ELSE
			xcOP   := amOP[xnItem,10]
			xnQtd  := amOP[xnItem,4]		
		ENDIF
		cAptOP := "O.P.: "+amOP[xnItem,1]
	ENDIF
	
	nx := ASCAN(aRotOper , { |x| RTRIM(x[1]) == RTRIM(xcOP) } )
	DO WHILE nx > 0 .AND. nx <= LEN(aRotOper).AND.RTRIM(aRotOper[nx,1])==RTRIM(xcOP)
		nz := ASCAN(aAptOP , { |xy| xy[1] == aRotOper[nx,2] } )
		IF ( nz > 0 )
			aAptOP[nz,5] := aRotOper[nx,5]   
			aAptOP[nz,6] := aRotOper[nx,6]
			aAptOP[nz,7] := aRotOper[nx,7]
			aAptOP[nz,3] := aRotOper[nx,3]
			aAptOP[nz,4] := aRotOper[nx,4]
			nxSaldo      := ( xnQtd - aRotOper[nx,3] )
			IF ( ( aAptOP[nz,3] + aAptOP[nz,4] ) > 0 )
				aAptOP[nz,8] := IIF(nxSaldo > 0 , "1" , IIF(aAptOP[nz,3]==aAptOP[nz,4] , "2" , "1" ) )
			ENDIF	
		ENDIF
		nx++
	ENDDO
ENDIF

oLst4:SetArray(aAptOP)
oLst4:bLine := {|| { IIF(aAptOP[oLst4:nAt,8]=="0",oVm,IIF(aAptOP[oLst4:nAt,8]=="1",oLr,oVd)) , ;
								 aAptOP[oLst4:nAt,2] , ;
								 aAptOP[oLst4:nAt,3] , ;
								 aAptOP[oLst4:nAt,4] , ;
								 aAptOP[oLst4:nAt,5] , ;
								 aAptOP[oLst4:nAt,6] , ;
								 aAptOP[oLst4:nAt,7] } }
								
oLst4:GoTop()
oLst4:Refresh()
oAptOP:Refresh()
oCTrab:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_kardex()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local xLocPad  := aAlmox[nItemP,1]

nRotinas := 1

IF ( oGroup07:lVisibleControl )
	oGroup07:Hide()
	oGroup08:Hide()
	oLst2:Hide()
	oLst3:Hide()
ENDIF
IF ( oGroup7a:lVisibleControl )
	oGroup7a:Hide()
	oGroup8a:Hide()
	oLst2a:Hide()
	oLst3a:Hide()
ENDIF
oProduto:Disable()
oGroup09:Hide()
oGroup10:Hide()
oLst1:Hide()
oLst4:Hide()
oBtn1:Hide()
oBtn2:Hide()
oBtn3:Hide()
oBtn4:Hide()
oBtn5:Hide()
oBtn6:Hide()
oBtn6a:Hide()
oBtn7:Show()
oBtn8:Show()
oBtn9:Show()
oGroup11:Show()
oLst5:Show()
oSayDesde:Show()
oGetDesde:Show()
oSayAte:Show()
oGetAte:Show()
oAlmoxarife:Show()

dDesde := dDatIni
dAte   := dDatFin

f_movinterno()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_sairkardex()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
nRotinas := 0

IF ( B1TIPO == "PA" )
	oGroup07:Show()
	oGroup08:Show()
	oLst2:Show()
	oLst3:Show()
ELSE
	oGroup7a:Show()
	oGroup8a:Show()
	oLst2a:Show()
	oLst3a:Show()
ENDIF
oProduto:Enable()
oGroup09:Show()
oGroup10:Show()
oLst1:Show()
oLst4:Show()
oBtn1:Show()
oBtn2:Show()
oBtn3:Show()
oBtn4:Show()
oBtn5:Show()
oBtn6:Show()
oBtn6a:Show()
oBtn7:Hide()
oBtn8:Hide()
oBtn9:Hide()
oGroup11:Hide()
oLst5:Hide()
oSayDesde:Hide()
oGetDesde:Hide()
oSayAte:Hide()
oGetAte:Hide()
oAlmoxarife:Hide()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_movinterno()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry,cRazSoc,cxNfOri,cxData,cSequen
Local nCM1,nxCm1
Local xLocPad := aAlmox[nItemP,1]
Local dIni    := dDesde
Local aSaldo  := CalcEst(B1COD,xLocPad,dIni)
Local nQtyIni := aSaldo[1]
Local nCusIni := aSaldo[2] 
Local nCm2    := IIF(nQtyIni > 0 , ROUND(nCusIni / nQtyIni , 4 ) , 0 )
Local cxOP    := " "

SB2->(dbSeek(xFilial("SB2")+B1COD+xLocPad))
nCM1        := SB2->B2_CM1
cAlmoxarife := "LOCAL: "+xLocPad

aKardex := {}
AADD( aKardex , { SPACE(8)        , ;
						SPACE(3)        , ;
						SPACE(5)        , ;
						SPACE(12)       , ;
						"SALDO ANTERIOR", ;
						""              , ;
						""              , ;
						nCm2            , ;
						""              , ;
						""              , ;
						nQtyIni         , ;
						nCusIni         , ;
						SPACE(6)        , ;
						SPACE(40)       , ;
						SPACE(10)       , ;
						SPACE(8)        , ;
						SPACE(3)        , ;
						SPACE(4)        , ;
						SPACE(6)        , ;
						SPACE(30)       , ;
						SPACE(14)       , ;
						"0"             , ;
						SPACE(8)        , ;
						0            } )

cQry := "SELECT D1_COD,D1_DTDIGIT,D1_CF,D1_TES,D1_NUMSEQ,D1_FORNECE,D1_LOJA,D1_PEDIDO,D1_ITEMPC,D1_SERIE,D1_DOC,D1_OP,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_CUSTO,D1_TIPO,D1_SEQCALC,D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_IDENTB6,D1.R_E_C_N_O_ D1_RECNO "
cQry += "FROM "+RetSqlName("SD1")+" D1,"+RetSqlName("SF4")+" F4 "
cQry += "WHERE D1.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' "
cQry += "AND D1_FILIAL  = '" + xFilial("SD1") + "' "
cQry += "AND D1_COD     = '" + B1COD+"' "
cQry += "AND D1_DTDIGIT BETWEEN '" + DTOS(dDesde) + "' AND '"+DTOS(dAte)+"' "
cQry += "AND D1_LOCAL = '"+xLocPad+"' "
cQry += "AND F4_CODIGO = D1_TES "
cQry += "AND F4_ESTOQUE = 'S' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

TcSetField("TMP","D1_QUANT","N",15,2)
TcSetField("TMP","D1_TOTAL","N",15,2)
TcSetField("TMP","D1_CUSTO","N",15,4)
TcSetField("TMP","D1_VUNIT","N",15,6)
TcSetField("TMP","D1_DTDIGIT","D",08,0)
TcSetField("TMP","D1_RECNO","N",08,0)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
   nCm2    := IIF(TMP->D1_QUANT > 0 , ROUND(TMP->D1_CUSTO / TMP->D1_QUANT , 4) , nCM1 )
   cxNfOri := IIF(EMPTY(TMP->D1_NFORI)," ",RTRIM(TMP->D1_SERIORI)+"/"+RTRIM(TMP->D1_ITEMORI))
	cxData  := " "
	nxCm1   := 0
	cxOP    := " "
	IF ( TMP->D1_TIPO $ "DB" )
		IF ( TMP->D1_TIPO=="D" )
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(xFilial("SD2")+TMP->D1_NFORI+TMP->D1_SERIORI+TMP->D1_FORNECE+TMP->D1_LOJA+TMP->D1_COD+LEFT(TMP->D1_ITEMORI,2))
			cxData := DTOC(SD2->D2_EMISSAO)
			nxCm1  := ROUND(SD2->D2_CUSTO1 / SD2->D2_QUANT , 4 )
		ELSE
			dbSelectArea("SB6")
			dbSetOrder(3)
			dbSeek(xFilial("SB6")+TMP->D1_IDENTB6+TMP->D1_COD+"R")
			cxData := DTOC(SB6->B6_DTDIGIT)
			nxCm1  := ROUND(SB6->B6_CUSTO1 / SB6->B6_QUANT , 4 )
		ENDIF
		SA1->(dbSeek(xFilial("SA1")+TMP->D1_FORNECE+TMP->D1_LOJA))
		cxRazSoc := "C-"+SA1->A1_NOME
	ELSE	
		SA2->(dbSeek(xFilial("SA2")+TMP->D1_FORNECE+TMP->D1_LOJA))
		cxRazSoc := "F-"+SA2->A2_NOME
		IF ( !EMPTY(TMP->D1_OP) )
			SC2->(dbSeek(xFilial("SC2")+RTRIM(TMP->D1_OP)))
			cxOP := TRANSF(RTRIM(TMP->D1_OP),"@R XXXXXX.XX.999")+" - "+RTRIM(SC2->C2_PRODUTO)
		ENDIF
	ENDIF
	
	dbSelectArea("TMP")

   AADD( aKardex , { DTOS(TMP->D1_DTDIGIT) , ;
                     TMP->D1_TES     , ;
                     TMP->D1_CF      , ;
                     RTRIM(TMP->D1_SERIE)+" "+TMP->D1_DOC     , ;
                     cxOP            , ;
                     TMP->D1_QUANT   , ;
                     TMP->D1_CUSTO   , ;
							nCm2            , ;
							""              , ;
							""              , ;
							""              , ;
							""              , ;
                     TMP->D1_NUMSEQ  , ;
                     cxRazSoc        , ;
                     TMP->D1_PEDIDO+"/"+TMP->D1_ITEMPC , ;
                     TMP->D1_NFORI   , ;
							TMP->D1_SERIORI , ;
							TMP->D1_ITEMORI , ;
							TMP->D1_IDENTB6 , ;
							SPACE(30)       , ;
							TMP->D1_SEQCALC , ;
							"1"             , ;
							DTOC(TMP->D1_DTDIGIT) , ;
							TMP->D1_RECNO   } )

   dbSkip()
ENDDO
TMP->(dbCloseArea())

cQry := "SELECT D2_COD,D2_EMISSAO,D2_CF,D2_TES,D2_NUMSEQ,D2_CLIENTE,D2_LOJA,D2_PEDIDO,D2_ITEMPV,D2_SERIE,D2_DOC,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_CUSTO1,D2_TIPO,D2_SEQCALC,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_IDENTB6,D2.R_E_C_N_O_ D2_RECNO "
cQry += "FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF4")+" F4 "
cQry += "WHERE D2.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' "
cQry += "AND D2_FILIAL  = '" + xFilial("SD2") + "' "
cQry += "AND D2_COD     = '" + B1COD+"' "
cQry += "AND D2_EMISSAO BETWEEN '" + DTOS(dDesde) + "' AND '"+DTOS(dAte)+"' "
cQry += "AND D2_LOCAL = '"+xLocPad+"' "
cQry += "AND F4_CODIGO = D2_TES "
cQry += "AND F4_ESTOQUE = 'S' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

TcSetField("TMP","D2_QUANT","N",15,2)
TcSetField("TMP","D2_TOTAL","N",15,2)
TcSetField("TMP","D2_CUSTO1","N",15,4)
TcSetField("TMP","D2_PRCVEN","N",15,6)
TcSetField("TMP","D2_EMISSAO","D",08,0)
TcSetField("TMP","D2_RECNO","N",08,0)

cxOP := " "
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
   nCm2    := IIF(TMP->D2_QUANT > 0 , ROUND(TMP->D2_CUSTO1 / TMP->D2_QUANT , 4) , nCM1 )
   cxNfOri := IIF(EMPTY(TMP->D2_NFORI)," ",RTRIM(TMP->D2_SERIORI)+"/"+RTRIM(TMP->D2_SERIORI))
	cxData  := " "
	IF ( TMP->D2_TIPO <> "N" )
		IF ( TMP->D2_TIPO=="D" )
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(xFilial("SD1")+TMP->D2_NFORI+TMP->D2_SERIORI+TMP->D2_CLIENTE+TMP->D2_LOJA+TMP->D2_COD+TMP->D2_ITEMORI)
			cxData := DTOC(SD1->D1_DTDIGIT)
		ELSE
			dbSelectArea("SB6")
			dbSetOrder(3)
			dbSeek(xFilial("SB6")+TMP->D2_IDENTB6+TMP->D2_COD+"R")
			cxData := DTOC(SB6->B6_DTDIGIT)
		ENDIF
		SA2->(dbSeek(xFilial("SA2")+TMP->D2_CLIENTE+TMP->D2_LOJA))
		cxRazSoc := "F-"+SA2->A2_NOME
	ELSE	
		SA1->(dbSeek(xFilial("SA1")+TMP->D2_CLIENTE+TMP->D2_LOJA))
		cxRazSoc := "C-"+SA1->A1_NOME
	ENDIF

	dbSelectArea("TMP")

   AADD( aKardex , { DTOS(TMP->D2_EMISSAO) , ;
                     TMP->D2_TES     , ;
                     TMP->D2_CF      , ;
                     RTRIM(TMP->D2_SERIE)+" "+TMP->D2_DOC     , ;
                     cxOP            , ;
							""              , ;
							""              , ;
							nCm2            , ;
                     TMP->D2_QUANT   , ;
                     TMP->D2_CUSTO1  , ;
							""              , ;
							""              , ;
                     TMP->D2_NUMSEQ  , ;
                     cxRazSoc        , ;
                     TMP->D2_PEDIDO+"/"+TMP->D2_ITEMPV , ;
                     TMP->D2_NFORI   , ;
							TMP->D2_SERIORI , ;
							TMP->D2_ITEMORI , ;
							TMP->D2_IDENTB6 , ;
							SPACE(30)       , ;
							TMP->D2_SEQCALC , ;
							"5"             , ;
							DTOC(TMP->D2_EMISSAO) , ;
							TMP->D2_RECNO   } )
		
   dbSkip()
ENDDO
TMP->(dbCloseArea())

cQry := "SELECT D3_COD,D3_EMISSAO,D3_CF,D3_TM,D3_NUMSEQ,D3_DOC,D3_OP,D3_QUANT,D3_CUSTO1,D3_SEQCALC,D3_X_OBS,R_E_C_N_O_ D3_RECNO "
cQry += "FROM "+RetSqlName("SD3")+" "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND D3_FILIAL  = '" + xFilial("SD3") + "' "
cQry += "AND D3_COD     = '" + B1COD+"' "
cQry += "AND D3_EMISSAO BETWEEN '" + DTOS(dDesde) + "' AND '"+DTOS(dAte)+"' "
cQry += "AND D3_ESTORNO = ' ' "
cQry += "AND D3_LOCAL = '"+xLocPad+"' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

TcSetField("TMP","D3_QUANT","N",15,2)
TcSetField("TMP","D3_CUSTO1","N",15,4)
TcSetField("TMP","D3_EMISSAO","D",08,0)
TcSetField("TMP","D3_RECNO","N",08,0)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
   nCm2     := IIF(TMP->D3_QUANT > 0 , ROUND(TMP->D3_CUSTO1 / TMP->D3_QUANT , 4) , nCM1 )
	cxOP     := ""
	cxRazSoc := ""
	cxPedido := ""
	cxObserv := TMP->D3_X_OBS
	IF ( !EMPTY(TMP->D3_OP) )
		SC2->(dbSeek(xFilial("SC2")+RTRIM(TMP->D3_OP)))
		cxOP := TRANSF(RTRIM(TMP->D3_OP),"@R XXXXXX.XX.999")+IIF(SC2->C2_PRODUTO<>B1COD , " - "+RTRIM(SC2->C2_PRODUTO) , "" )
		IF ( !EMPTY(SC2->C2_PEDIDO) )
			SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			cxRazSoc := "C-"+SA1->A1_NOME
			cxPedido := SC2->C2_PEDIDO+"/"+SC2->C2_ITEMPV
		ENDIF
	ENDIF
	IF ( TMP->D3_CF $ "RE4/DE4" )
		IF ( TMP->D3_CF == "DE4" )
			SD3->(dbSeek(xFilial("SD3")+TMP->D3_NUMSEQ+"E0"+B1COD))         ////E0 = RE4   ;  E9 = DE4
		ELSE
			SD3->(dbSeek(xFilial("SD3")+TMP->D3_NUMSEQ+"E9"+B1COD))         ////E0 = RE4   ;  E9 = DE4
		ENDIF
		cxObserv := "ALMOX: "+SD3->D3_LOCAL + IIF(SD3->D3_COD <> B1COD , " - " + SD3->D3_COD , "" )
	ENDIF
	
	nQtyE   := ""
	nQtyS   := ""
	nCusE   := ""
	nCusS   := ""
	cSequen := IIF(LEFT(TMP->D3_CF,1) == "R" , "4" , IIF(LEFT(TMP->D3_CF,1) == "P" , "2" , "3" ) )
	IF ( cSequen == "4" )
		nQtyS := TMP->D3_QUANT
		nCusS := TMP->D3_CUSTO1
	ELSE
		nQtyE   := TMP->D3_QUANT 
		nCusE   := TMP->D3_CUSTO1
	ENDIF	

///"Emissão","TES","C.F","Documento","Ordem de Produção","Entrada (Qty)","Entrada (Custo)","Custo Unit.","Saída (Qty)","Saída (Custo)","Saldo (Qty)","Saldo (Custo)",
///"Sequencia","Fornecedor/Cliente","Pedido/Item","N.Fiscal Origem","Serie Origem","Item Origem","Ident.Poder3","Observação","Sequencia de Calculo"
	
   AADD( aKardex , { DTOS(TMP->D3_EMISSAO) , ;
                     TMP->D3_TM      , ;
                     TMP->D3_CF      , ;
                     TMP->D3_DOC     , ;
                     cxOP            , ;
							nQtyE           , ;
							nCusE           , ;
							nCm2            , ;
                     nQtyS           , ;
                     nCusS           , ;
							""              , ;
							""              , ;
                     TMP->D3_NUMSEQ  , ;
                     cxRazSoc        , ;
                     cxPedido        , ;
                     SPACE(9)        , ;
							SPACE(3)        , ;
							SPACE(4)        , ;
							SPACE(6)        , ;
							cxObserv        , ;
							TMP->D3_SEQCALC , ;
							cSequen         , ;
							DTOC(TMP->D3_EMISSAO) , ;
							TMP->D3_RECNO   } )
	
   dbSkip()
ENDDO
TMP->(dbCloseArea())

aSort(aKardex ,,,{|x,y| x[1]+x[22] < y[1]+y[22] } )

FOR nx:=2 TO LEN(aKardex)
	 nQtyE := aKardex[nx,6]
	 nCusE := aKardex[nx,7]
	 nQtyS := aKardex[nx,9]
	 nCusS := aKardex[nx,10]
	 nQtyE := IIF(Type("nQtyE") == "C" , 0 , nQtyE )
	 nCusE := IIF(Type("nCusE") == "C" , 0 , nCusE )
	 nQtyS := IIF(Type("nQtyS") == "C" , 0 , nQtyS )
	 nCusS := IIF(Type("nCusS") == "C" , 0 , nCusS )
	 nQtyIni := ( nQtyIni + nQtyE - nQtyS )
	 nCusIni := ( nCusIni + nCusE - nCusS )
	 aKardex[nx,11] := nQtyIni
	 aKardex[nx,12] := nCusIni
NEXT

oLst5:SetArray(aKardex)
oLst5:bLine   := {|| { aKardex[oLst5:nAt,23] , ;
							  aKardex[oLst5:nAt,2] , ;
							  aKardex[oLst5:nAt,3] , ;
							  aKardex[oLst5:nAt,4] , ;
							  aKardex[oLst5:nAt,5] , ;
							  aKardex[oLst5:nAt,6] , ;
							  aKardex[oLst5:nAt,7] , ;
							  aKardex[oLst5:nAt,8] , ;
							  aKardex[oLst5:nAt,9] , ;
							  aKardex[oLst5:nAt,10] , ;
							  aKardex[oLst5:nAt,11] , ;
							  aKardex[oLst5:nAt,12] , ;
							  aKardex[oLst5:nAt,13] , ;
							  aKardex[oLst5:nAt,14] , ;
							  aKardex[oLst5:nAt,15] , ;
							  aKardex[oLst5:nAt,16] , ;
							  aKardex[oLst5:nAt,17] , ;
							  aKardex[oLst5:nAt,18] , ;
							  aKardex[oLst5:nAt,19] , ;
							  aKardex[oLst5:nAt,20] , ;
							  aKardex[oLst5:nAt,21] } }								
oLst5:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_poder3()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

nRotinas := 2

IF ( oGroup07:lVisibleControl )
	oGroup07:Hide()
	oGroup08:Hide()
	oLst2:Hide()
	oLst3:Hide()
ENDIF
IF ( oGroup7a:lVisibleControl )
	oGroup7a:Hide()
	oGroup8a:Hide()
	oLst2a:Hide()
	oLst3a:Hide()
ENDIF
oProduto:Disable()
oGroup09:Hide()
oGroup10:Hide()
oLst1:Hide()
oLst4:Hide()
oBtn1:Hide()
oBtn2:Hide()
oBtn3:Hide()
oBtn4:Hide()
oBtn5:Hide()
oBtn6:Hide()
oBtn6a:Hide()
oTBmpAp1:Hide()
oTBmpAp2:Hide()
oTBmpAp3:Hide()
oAptOP:Hide()
oCTrab:Hide()
oLegApt:Hide()
oGrpApt:Hide()
oLegAp1:Hide()
oLegAp2:Hide()
oLegAp3:Hide()
oBtn9:Show()
oBtn10:Show()
oGroup12:Show()
oGroup13:Show()
oGroup14:Show()
oLst6:Show()
oLst7:Show()

oLst6:Refresh()
oLst7:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_sairmovp3()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
nRotinas := 0

IF ( B1TIPO == "PA" )
	oGroup07:Show()
	oGroup08:Show()
	oLst2:Show()
	oLst3:Show()
ELSE
	oGroup7a:Show()
	oGroup8a:Show()
	oLst2a:Show()
	oLst3a:Show()
ENDIF
oProduto:Enable()
oGroup09:Show()
oGroup10:Show()
oLst1:Show()
oLst4:Show()
oBtn1:Show()
oBtn2:Show()
oBtn3:Show()
oBtn4:Show()
oBtn5:Show()
oBtn6:Show()
oBtn6a:Show()
oTBmpAp1:Show()
oTBmpAp2:Show()
oTBmpAp3:Show()
oAptOP:Show()
oCTrab:Show()
oLegApt:Show()
oGrpApt:Show()
oLegAp1:Show()
oLegAp2:Show()
oLegAp3:Show()
oBtn9:Hide()
oBtn10:Hide()
oGroup12:Hide()
oGroup13:Hide()
oGroup14:Hide()
oLst6:Hide()
oLst7:Hide()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_movpoder3()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry,cCliFor,cIdent,cNF
Local nSaldoQ,nSaldoC,nCtd

/////
/////Movimento De Terceiros
/////
aP3De       := {}
nDeTerceiro := 0

cQry := "SELECT C.B6_TIPO,C.B6_PODER3,C.B6_IDENT,C.B6_PRODUTO,C.B6_LOCAL,C.B6_QUANT,C.B6_PRUNIT,C.B6_CUSTO1,C.B6_DOC,C.B6_SERIE,C.B6_DTDIGIT,C.B6_EMISSAO,C.B6_UENT,C.B6_TPCF,C.B6_CLIFOR,C.B6_LOJA,C.B6_TES,F4_ESTOQUE,F4_CF "
cQry += "FROM (SELECT * FROM "+RetSqlName("SB6")+" B WHERE B.D_E_L_E_T_ = ' ' AND B.B6_FILIAL = '"+xFilial("SB6")+"' "
cQry += "AND B.B6_PRODUTO = '"+B1COD+"' AND B.B6_LOCAL = '"+mvLocPad+"' AND B.B6_TIPO = 'D' AND B.B6_PODER3 = 'R' AND B.B6_SALDO > 0 ) A,"
cQry += RetSqlName("SB6")+" C,"+RetSqlName("SF4")+" F4 "
cQry += "WHERE C.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' "
cQry += "AND C.B6_FILIAL  = A.B6_FILIAL "
cQry += "AND C.B6_PRODUTO = A.B6_PRODUTO "
cQry += "AND C.B6_TIPO    = A.B6_TIPO "
cQry += "AND C.B6_IDENT   = A.B6_IDENT "
cQry += "AND F4_CODIGO    = C.B6_TES "
cQry += "ORDER BY C.B6_IDENT,C.B6_PODER3 DESC,C.B6_DTDIGIT "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

TcSetField("TMP","B6_QUANT","N",15,2)
TcSetField("TMP","B6_CUSTO1","N",15,4)
TcSetField("TMP","B6_PRUNIT","N",15,4)
TcSetField("TMP","B6_DTDIGIT","D",08,0)
TcSetField("TMP","B6_EMISSAO","D",08,0)
TcSetField("TMP","B6_UENT","D",08,0)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	IF ( TMP->B6_TPCF == "F" )
		SA2->(dbSeek(xFilial("SA2")+TMP->B6_CLIFOR+TMP->B6_LOJA))
		cCliFor := "F-"+SA2->A2_NREDUZ
	ELSE
		SA1->(dbSeek(xFilial("SA1")+TMP->B6_CLIFOR+TMP->B6_LOJA))
		cCliFor := "C-"+SA1->A1_NREDUZ
	ENDIF
	nCtd    := 0
	cNF     := TMP->B6_DOC
	nSaldoQ := TMP->B6_QUANT
	nSaldoC := TMP->B6_CUSTO1
	cIdent  := TMP->B6_IDENT
	DO WHILE !EOF().AND.B6_IDENT==cIdent
		nCtd++
		nSaldoQ := IIF(TMP->B6_PODER3=="R" , nSaldoQ , ( nSaldoQ - TMP->B6_QUANT ) )
		nSaldoC := IIF(TMP->B6_PODER3=="R" , nSaldoC , ( nSaldoQ - TMP->B6_CUSTO1 ) )

		AADD( aP3De   , { TMP->B6_LOCAL   , ;
								TRANSF(TMP->F4_CF,"@R 9.999") , ;
								RTRIM(TMP->B6_DOC)+"/"+TMP->B6_SERIE , ;
								DTOC(TMP->B6_DTDIGIT)     , ;
								TMP->B6_PODER3  , ;
								TMP->B6_QUANT   , ;
								TMP->B6_CUSTO1  , ;
								cCliFor         , ;
								TMP->B6_PRUNIT  , ;
								DTOC(TMP->B6_EMISSAO)     , ;
								TMP->F4_ESTOQUE , ;
								TMP->B6_IDENT   } )

		dbSkip()
	ENDDO
	nDeTerceiro += nSaldoQ
	IF ( nCtd > 1 )
		AADD( aP3De   , { ""              , ;
								""              , ;
								""              , ;
								"**Saldo NF."+cNF , ;
								""              , ;
								nSaldoQ         , ;
								nSaldoC         , ;
								""              , ;
								""              , ;
								""              , ;
								""              , ;
								""              } ) 
	ENDIF
ENDDO
TMP->(dbCloseArea())

oLst6:SetArray(aP3De)
oLst6:bLine   := {|| { aP3De[oLst6:nAt,1] , ;
							  aP3De[oLst6:nAt,2] , ;
							  aP3De[oLst6:nAt,3] , ;
							  aP3De[oLst6:nAt,4] , ;
							  aP3De[oLst6:nAt,5] , ;
							  aP3De[oLst6:nAt,6] , ;
							  aP3De[oLst6:nAt,7] , ;
							  aP3De[oLst6:nAt,8] , ;
							  aP3De[oLst6:nAt,9] , ;
							  aP3De[oLst6:nAt,10] , ;
							  aP3De[oLst6:nAt,11] , ;
							  aP3De[oLst6:nAt,12] } }								

/////
/////Movimento Em Terceiros
/////
aP3Em       := {}
nEmTerceiro := 0

cQry := "SELECT C.B6_TIPO,C.B6_PODER3,C.B6_IDENT,C.B6_PRODUTO,C.B6_LOCAL,C.B6_QUANT,C.B6_PRUNIT,C.B6_CUSTO1,C.B6_DOC,C.B6_SERIE,C.B6_DTDIGIT,C.B6_EMISSAO,C.B6_UENT,C.B6_TPCF,C.B6_CLIFOR,C.B6_LOJA,C.B6_TES,F4_ESTOQUE,F4_CF "
cQry += "FROM (SELECT * FROM "+RetSqlName("SB6")+" B WHERE B.D_E_L_E_T_ = ' ' AND B.B6_FILIAL = '"+xFilial("SB6")+"' "
cQry += "AND B.B6_PRODUTO = '"+B1COD+"' AND B.B6_LOCAL = '"+mvLocPad+"' AND B.B6_TIPO = 'E' AND B.B6_PODER3 = 'R' AND B.B6_SALDO > 0 ) A,"
cQry += RetSqlName("SB6")+" C,"+RetSqlName("SF4")+" F4 "
cQry += "WHERE C.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' "
cQry += "AND C.B6_FILIAL  = A.B6_FILIAL "
cQry += "AND C.B6_PRODUTO = A.B6_PRODUTO "
cQry += "AND C.B6_TIPO    = A.B6_TIPO "
cQry += "AND C.B6_IDENT   = A.B6_IDENT "
cQry += "AND F4_CODIGO    = C.B6_TES "
cQry += "ORDER BY C.B6_IDENT,C.B6_PODER3 DESC,C.B6_DTDIGIT "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

TcSetField("TMP","B6_QUANT","N",15,2)
TcSetField("TMP","B6_CUSTO1","N",15,4)
TcSetField("TMP","B6_PRUNIT","N",15,4)
TcSetField("TMP","B6_DTDIGIT","D",08,0)
TcSetField("TMP","B6_EMISSAO","D",08,0)
TcSetField("TMP","B6_UENT","D",08,0)

dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	IF ( TMP->B6_TPCF == "F" )
		SA2->(dbSeek(xFilial("SA2")+TMP->B6_CLIFOR+TMP->B6_LOJA))
		cCliFor := "F-"+SA2->A2_NREDUZ
	ELSE
		SA1->(dbSeek(xFilial("SA1")+TMP->B6_CLIFOR+TMP->B6_LOJA))
		cCliFor := "C-"+SA1->A1_NREDUZ
	ENDIF
	nCtd    := 0
	cNF     := TMP->B6_DOC
	nSaldoQ := TMP->B6_QUANT
	nSaldoC := TMP->B6_CUSTO1
	cIdent  := TMP->B6_IDENT
	DO WHILE !EOF().AND.B6_IDENT==cIdent
		nCtd++
		nSaldoQ := IIF(TMP->B6_PODER3=="R" , nSaldoQ , ( nSaldoQ - TMP->B6_QUANT ) )
		nSaldoC := IIF(TMP->B6_PODER3=="R" , nSaldoC , ( nSaldoQ - TMP->B6_CUSTO1 ) )
		AADD( aP3Em   , { TMP->B6_LOCAL   , ;
								TRANSF(TMP->F4_CF,"@R 9.999") , ;
								RTRIM(TMP->B6_DOC)+"/"+TMP->B6_SERIE , ;
								DTOC(TMP->B6_DTDIGIT)     , ;
								TMP->B6_PODER3  , ;
								TMP->B6_QUANT   , ;
								TMP->B6_CUSTO1  , ;
								cCliFor         , ;
								TMP->B6_PRUNIT  , ;
								DTOC(TMP->B6_EMISSAO) , ;
								TMP->F4_ESTOQUE , ;
								TMP->B6_IDENT   } )

		dbSkip()
	ENDDO
	nEmTerceiro += nSaldoQ
	IF ( nCtd > 1 )
		AADD( aP3Em   , { ""              , ;
								""              , ;
								""              , ;
								"**Saldo NF."+cNF, ;
								""              , ;
								nSaldoQ         , ;
								nSaldoC         , ;
								""              , ;
								""              , ;
								""              , ;
								""              , ;
								""              } ) 
	ENDIF
ENDDO
TMP->(dbCloseArea())

oLst7:SetArray(aP3Em)
oLst7:bLine   := {|| { aP3Em[oLst7:nAt,1] , ;
							  aP3Em[oLst7:nAt,2] , ;
							  aP3Em[oLst7:nAt,3] , ;
							  aP3Em[oLst7:nAt,4] , ;
							  aP3Em[oLst7:nAt,5] , ;
							  aP3Em[oLst7:nAt,6] , ;
							  aP3Em[oLst7:nAt,7] , ;
							  aP3Em[oLst7:nAt,8] , ;
							  aP3Em[oLst7:nAt,9] , ;
							  aP3Em[oLst7:nAt,10] , ;
							  aP3Em[oLst7:nAt,11] , ;
							  aP3Em[oLst7:nAt,12] } }								

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static FUNCTION f_ondeusa()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
"      |-------------- XXXXXXXXXXXXXXXXXXXX"
"      |                     |-------------- XXXXXXXXXXXXXXXXXXXX
"      |                     |                     |-------------- XXXXXXXXXXXXXXXXXXXX
"      |                     |                     |                     |-------------- XXXXXXXXXXXXXXXXXXXX
"      |                     |                     |                     |                     |-------------- XXXXXXXXXXXXXXXXXXXX
*/

nRotinas := 3

IF ( oGroup07:lVisibleControl )
	oGroup07:Hide()
	oGroup08:Hide()
	oLst2:Hide()
	oLst3:Hide()
ENDIF
IF ( oGroup7a:lVisibleControl )
	oGroup7a:Hide()
	oGroup8a:Hide()
	oLst2a:Hide()
	oLst3a:Hide()
ENDIF
oProduto:Disable()
oGroup09:Hide()
oGroup10:Hide()
oLst1:Hide()
oLst4:Hide()
oBtn1:Hide()
oBtn2:Hide()
oBtn3:Hide()
oBtn4:Hide()
oBtn5:Hide()
oBtn6:Hide()
oBtn6a:Hide()
oTBmpAp1:Hide()
oTBmpAp2:Hide()
oTBmpAp3:Hide()
oAptOP:Hide()
oCTrab:Hide()
oLegApt:Hide()
oGrpApt:Hide()
oLegAp1:Hide()
oLegAp2:Hide()
oLegAp3:Hide()
oBtn9:Show()
oBtn11:Show()
oGroup15:Show()
oLst8:Show()

oLst8:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static FUNCTION f_usado()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local   nReg2,nReg3,nReg4,nReg5,nRecSB1
Local   mComp2,mComp3,mComp4,mComp5
Local   nFlagN1,nFlagN2,nFlagN3,nFlagN4
Private cNiv

dbSelectArea("SB1")
nRecSB1 := SB1->(RECNO())

aUsado := {{ B1COD+SPACE(30),SPACE(30),"","","","","","","","",SPACE(30) }}
dbSelectArea("SG1")
dbSetOrder(2)
dbSeek(xFilial("SG1")+B1COD,.T.)
DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP==B1COD
   nReg2 := RECNO()
   cNiv  := "      |-------------- "
   GRPR09()      
   dbSkip()
   lFlagN1 := IIF(!EOF().AND.SG1->G1_COMP==B1COD,.T.,.F.)
   dbSkip(-1)
   cComp2 := SG1->G1_COD
   dbSeek(xFilial("SG1")+cComp2,.T.)
   DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1") .AND. G1_COMP == cComp2
      nReg3 := RECNO()
      cNiv  := "      |                           |-------------- "
      GRPR09()
      dbSkip()
      lFlagN2 := IIF(!EOF().AND.SG1->G1_COMP==B1COD,.T.,.F.)
      dbSkip(-1)
      mComp3 := SG1->G1_COD
      dbSeek(xFilial("SG1")+mComp3,.T.)
      DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP == mComp3
         nReg4 := RECNO()
         cNiv  := "      |                           |                           |-------------- "
         GRPR09()
         dbSkip()
         lFlagN3 := IIF(!EOF().AND.SG1->G1_COMP==B1COD,.T.,.F.)
         dbSkip(-1)
         mComp4 := SG1->G1_COD
         dbSeek(xFilial("SG1")+mComp4,.T.)
         DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP == mComp4
            nReg5 := RECNO()
            cNiv  := "      |                           |                           |                           |-------------- "
            GRPR09()
            dbSkip()
            lFlagN4 := IIF(!EOF().AND.SG1->G1_COMP==B1COD,.T.,.F.)
            dbSkip(-1)
            mComp5 := SG1->G1_COD
            dbSeek(xFilial("SG1")+mComp5,.T.)
            DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP == mComp5
               cNiv := "      |                           |                           |                           |                           |-------------- "
               GRPR09()     
               dbSkip()
            ENDDO
            GO nReg5
            dbSkip()
         ENDDO
         GO nReg4
         dbSkip()
      ENDDO
      GO nReg3
      dbSkip()
   ENDDO
   GO nReg2
   dbSkip()
ENDDO
IF ( LEN(aUsado) > 1 )
	AADD(aUsado , { REPL("*",60),REPL("*",50),"**","**","************","******","**********","**********","***","***",REPL("*",50) } )
ENDIF

oLst8:SetArray(aUsado)
oLst8:bLine  := {|| { aUsado[oLst8:nAt,1] , ;
							 aUsado[oLst8:nAt,2] , ;
							 aUsado[oLst8:nAt,3] , ;
							 aUsado[oLst8:nAt,4] , ;
							 aUsado[oLst8:nAt,5] , ;
							 aUsado[oLst8:nAt,6] , ;
							 aUsado[oLst8:nAt,7] , ;
							 aUsado[oLst8:nAt,8] , ;
							 aUsado[oLst8:nAt,9] , ;
							 aUsado[oLst8:nAt,10] , ;
							 aUsado[oLst8:nAt,11] } }								
oLst8:lAdjustColsize := .F.

dbSelectArea("SB1")
dbGoTo(nRecSB1)

Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GRPR09()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///"Componente/Produto","Descrição","Tipo","UM","Quantidade","Perda","Dt.Ini.Prod.","Dt.Fin.Prod.","Opcional?","Fantasma?","Observação" 
Local cOpcional,cFantasma

SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))

cOpcional := IIF(ddatabase < SG1->G1_INI.OR.ddatabase > SG1->G1_FIM , "SIM" , "" )
cOpcional := IIF(SB1->B1_FANTASM=="S", "SIM" , "" )
cNiv      := cNiv + RTRIM(SG1->G1_COD)

AADD(aUsado , { cNiv                  , ;
					 LEFT(SB1->B1_DESC,50) , ;
					 SB1->B1_TIPO          , ;
					 SB1->B1_UM            , ;
					 SG1->G1_QUANT         , ;
					 SG1->G1_PERDA         , ;
					 DTOC(SG1->G1_INI)     , ;
					 DTOC(SG1->G1_FIM)     , ;
					 cOpcional             , ;
					 cFantasma             , ;
					 SG1->G1_OBSERV  } )

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_sairusado()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
nRotinas := 0

IF ( B1TIPO == "PA" )
	oGroup07:Show()
	oGroup08:Show()
	oLst2:Show()
	oLst3:Show()
ELSE
	oGroup7a:Show()
	oGroup8a:Show()
	oLst2a:Show()
	oLst3a:Show()
ENDIF
oProduto:Enable()
oGroup09:Show()
oGroup10:Show()
oLst1:Show()
oLst4:Show()
oBtn1:Show()
oBtn2:Show()
oBtn3:Show()
oBtn4:Show()
oBtn5:Show()
oBtn6:Show()
oBtn6a:Show()
oTBmpAp1:Show()
oTBmpAp2:Show()
oTBmpAp3:Show()
oAptOP:Show()
oCTrab:Show()
oLegApt:Show()
oGrpApt:Show()
oLegAp1:Show()
oLegAp2:Show()
oLegAp3:Show()
oBtn9:Hide()
oBtn11:Hide()
oGroup15:Hide()
oLst8:Hide()

Return

*************************
Static Function ForHom()
*************************
inx      := n
aHeader  := {}
aCols    := {}
AADD(aHeader,{"Fornecedor"         , "TB_FORNEC " , "@!                " , 46,0 , SPACE(10),"€€€€€€€","C","TRB"})
AADD(aHeader,{"Origem"             , "TB_LOCAL  " , "@!                " , 08,0 , SPACE(10),"€€€€€€€","C","TRB"})
AADD(aHeader,{"O.C."               , "TB_PEDIDO " , "@!                " , 11,0 , SPACE(10),"€€€€€€€","C","TRB"})
AADD(aHeader,{"Emissao"            , "TB_EMISSAO" , "@!                " , 08,0 , SPACE(10),"€€€€€€€","C","TRB"})
AADD(aHeader,{"Quantidade"         , "TB_QUANT  " , "@E 999999999.999  " , 13,3 , SPACE(10),"€€€€€€€","N","TRB"})
AADD(aHeader,{"Vlr.Unitario"       , "TB_PRECO  " , "@E 99999,999.99999" , 15,5 , SPACE(10),"€€€€€€€","N","TRB"})
AADD(aHeader,{"Vlr.Total"          , "TB_TOTAL  " , "@E 9999,999,999.99" , 15,2 , SPACE(10),"€€€€€€€","N","TRB"})
dbSelectArea("SA5")
dbSetOrder(2)
dbSeek(xFilial("SA5")+B1COD,.T.)
DO WHILE !EOF().AND.A5_FILIAL==xFilial("SA5").AND.A5_PRODUTO==B1COD
   nmCounter := 0
   aPedF     := {}
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA)
   dbSelectArea("SC7")
   dbSetOrder(2)
   dbSeek(xFilial("SC7")+SA5->A5_PRODUTO+SA5->A5_FORNECE+SA5->A5_LOJA+"ZZZZ",.T.)
   dbSkip(-1)
   DO WHILE !BOF().AND.C7_FILIAL==xFilial("SC7").AND.C7_PRODUTO==SA5->A5_PRODUTO.AND.C7_FORNECE==SA5->A5_FORNECE.AND.C7_LOJA==SA5->A5_LOJA.AND.nmCounter < 3
      AADD(aPedF , C7_NUM+C7_ITEM+DTOC(C7_EMISSAO)+STRZERO(C7_QUANT*1000,18)+STRZERO(C7_PRECO*100000,18)+STRZERO(C7_TOTAL*100,18))
      dbSkip(-1)
      nmCounter := ( nmCounter + 1 )
   ENDDO
   A2EST := IIF(SA2->A2_EST=="EX" , "EXTERIOR" , IIF(SA2->A2_EST == "AM" , "LOCAL   " , "NACIONAL" ) )
   IF ( LEN(aPedF) == 0 )
      AADD(aCols , { SA5->A5_FORNECE+SA2->A2_NOME , ;
                     A2EST                        , ;
                     SPACE(11)                    , ;
                     SPACE(08)                    , ;
                     0.000                        , ;
                     0.00000                      , ;
                     0.00                         } )
   ELSE
      FOR n:=1 TO LEN(aPedF)
          cmPedido  := SUBS(aPedF[n],1,6)+"/"+SUBS(aPedF[n],7,4)
          cmEmissao := SUBS(aPedf[n],11,8)
          nmQuant   := VAL( SUBS(aPedF[n],19,18) ) / 1000
          nmPreco   := VAL( SUBS(aPedF[n],37,18) ) / 100000
          nmTotal   := VAL( SUBS(aPedF[n],55,18) ) / 100
          cmFornece := IIF(n==1 , SA5->A5_FORNECE+SA2->A2_NOME , SPACE(46) )
          cmEst     := IIF(n==1 , A2EST , SPACE(08) )
          cmEmissao := IIF(n==1 , cmEmissao , SPACE(08) )
          AADD( aCols , { cmFornece   , ;
                          cmEst       , ;
                          cmPedido    , ;
                          cmEmissao   , ;
                          nmQuant     , ;
                          nmPreco     , ;
                          nmTotal     } )
      NEXT
   ENDIF
   dbSelectArea("SA5")
   dbSkip()
ENDDO
IF ( LEN(aCols) == 0 )
   AADD(aCols , { "*** PRODUTO N/HOMOLOGADO ***" , ;
                  SPACE(08)                      , ;
                  SPACE(11)                      , ;
                  SPACE(08)                      , ;
                  0.000                          , ;
                  0.00000                        , ;
                  0.00                           } )
ENDIF

n := 1

@ 000,000 TO 500,810   DIALOG oDlg7 TITLE "Fornecedores Homologados"
@ 005,010 TO 245,400                TITLE "Fornecedores"

@ 013,015 TO 240,395 MULTILINE

ACTIVATE DIALOG oDlg7 CENTER

aCols   := AClone(aCols7)
aHeader := AClone(aHeader7)
n       := inx

RETURN

/*
dbSelectArea("SG1")
dbSetOrder(2)
dbSeek(xFilial("SG1")+B1COD,.T.)
DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP==B1COD
   nReg2 := RECNO()
   cNiv  := "    |---------"
   GRPR09()      
   dbSkip()
   lFlagN1 := IIF(!EOF().AND.G1_COMP==B1COD,.T.,.F.)
   dbSkip(-1)
   cComp2 := G1_COD
   dbSeek(xFilial("SG1")+cComp2,.T.)
   DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1") .AND. G1_COMP == cComp2
      nReg3 := RECNO()
      cNiv  := "    |                   |---------"
      GRPR09()
      dbSkip()
      lFlagN2 := IIF(!EOF().AND.G1_COMP==B1COD,.T.,.F.)
      dbSkip(-1)
      mComp3 := G1_COD
      dbSeek(xFilial("SG1")+mComp3,.T.)
      DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP == mComp3
         nReg4 := RECNO()
         cNiv  := "    |                |                |---------"
         GRPR09()
         dbSkip()
         lFlagN3 := IIF(!EOF().AND.G1_COMP==B1COD,.T.,.F.)
         dbSkip(-1)
         mComp4 := G1_COD
         dbSeek(xFilial("SG1")+mComp4,.T.)
         DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP == mComp4
            nReg5 := RECNO()
            cNiv  := "    |                |                |                |---------"
            GRPR09()
            dbSkip()
            lFlagN4 := IIF(!EOF().AND.G1_COMP==B1COD,.T.,.F.)
            dbSkip(-1)
            mComp5 := G1_COD
            dbSeek(xFilial("SG1")+mComp5,.T.)
            DO WHILE !EOF().AND.G1_FILIAL==xFilial("SG1").AND.G1_COMP == mComp5
               cNiv := "    |                |                |                |                |---------"
               GRPR09()     
               dbSkip()
            ENDDO
            GO nReg5
            dbSkip()
         ENDDO
         GO nReg4
         dbSkip()
      ENDDO
      GO nReg3
      dbSkip()
   ENDDO
   GO nReg2
   dbSkip()
ENDDO
*/