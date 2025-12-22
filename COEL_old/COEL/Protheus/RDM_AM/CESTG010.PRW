/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CESTG010 º Autor ³ Carlos Nina        º Data ³  22/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Gera Pre-Nota de Importacao                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Recebimento (CUSTOMIZACAO DO COMPLEMENTO - TABELA CD5)     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "protheus.ch"
#include "rwmake.ch"
#Include "totvs.ch"
#INCLUDE "TOPCONN.CH"
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

User Function CESTG010()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oMulti,oWBrowse,oGetDb,aHeader,aCols,oTotProd,oTotNota
Private cItemSq  := "0000"    ///Sq. dos itens no aCols na funcao de usuario CESTG10A.PRX (CESTEXG010())
Private lRefresh := .T.
Private aCampos  := {}

/*Private aRotina  := {{"Pesquisar", "AxPesqui", 0, 1},;
{"Visualizar", "AxVisual", 0, 2},;
{"Incluir", "AxInclui", 0, 3},;
{"Alterar", "AxAltera", 0, 4},;
{"Excluir", "AxDeleta", 0, 5}}*/

dDatFech  := GETMV("MV_ULMES")
cEspecie  := GETMV("MV_ESPECIE")
cNroDI    := Space(10)
dDtReg    := CTOD("")
cLocDes   := Space(30)
dDtDes    := CTOD("")
nMoeda    := 1
nTxDolar  := 0
dEmissao  := CTOD("")
cFornece  := Space(6)
cLoja1    := Space(2)
cDesFor   := Space(40)
cFabric   := Space(6)
cLoja2    := Space(2)
cDesFab   := Space(40)
cObserv   := Space(50)
nVlrFrete := 0
nVlrSeg   := 0
nDespesa  := 0
nVlrFob   := 0
nSuframa  := 0
nSiscomex := 0
nArmazem  := 0
nFrete    := 0
nDespacha := 0
nTotProd  := 0
nTotNota  := 0
lSair     := .F.
cVTrans   := SPACE(30)       ///Carlos - 20/03/2015 - Versao 3.0 NF-e
cTpImpor  := SPACE(30)       ///Carlos - 20/03/2015 - Versao 3.0 NF-e
aVTrans   := {cVTrans, "1=Maritima","2=Fluvial","3=Lacustre","4=Aerea","5=Postal","6=Ferroviaria","7=Rodoviaria","8=Conduto","9=Meios proprios","10=Entrada/Saida ficta"}   
aTpImpor  := {cTpImpor,"1=Importacao por conta propria","2=Importacao por conta e ordem","3=Importacao por encomenda"}
cSerie    := IIF(M->cNumEmp=="0301" , "3  " , "4  " )                    //Serie atual das Notas de Saida
//cSerie    := "TST"       //Serie atual das Notas de Saida Acerto para pode fazer testes da NFE 3.10 feito por Andre.
/*
aCpoAlter := {"C7_PRODUTO","C7_SALDO","C7_PRECO","C7_TOTAL","C7_PEDIDO","C7_ITEMPC","C7_FABRIC","C7_VLRII","C7_VLRDSP","C7_VLRDSC","C7_VLRIOF"}
*
aStru := {}
AADD(aStru,{"C7_ITEM"    , "C" , 04 , 0 } )
AADD(aStru,{"C7_PRODUTO" , "C" , 30 , 0 } )
AADD(aStru,{"C7_DESCRI"  , "C" , 30 , 0 } )
AADD(aStru,{"C7_TIPO"    , "C" , 02 , 0 } )
AADD(aStru,{"C7_UM"      , "C" , 02 , 0 } )
AADD(aStru,{"C7_SALDO"   , "N" , 14 , 2 } )
AADD(aStru,{"C7_PRECO"   , "N" , 12 , 4 } )
AADD(aStru,{"C7_TOTAL"   , "N" , 12 , 2 } )
AADD(aStru,{"C7_PEDIDO"  , "C" , 06 , 0 } )
AADD(aStru,{"C7_ITEMPC"  , "C" , 04 , 0 } )
AADD(aStru,{"C7_FABRIC"  , "C" , 06 , 0 } )
AADD(aStru,{"C7_VLRBC"   , "N" , 14 , 2 } )
AADD(aStru,{"C7_VLRII"   , "N" , 14 , 2 } )
AADD(aStru,{"C7_VLRDSP"  , "N" , 14 , 2 } )
AADD(aStru,{"C7_VLRDSC"  , "N" , 14 , 2 } )
AADD(aStru,{"C7_VLRIOF"  , "N" , 14 , 2 } )
AADD(aStru,{"FLAG"       , "L" , 01 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
cArqInd  := cArqTrab+".NTX"
DbUseArea(.T.,,cArqTrab,"TPR",.F.,.F.)
INDEX ON C7_ITEM TO (cArqInd)
*/
aStru := {}
AADD(aStru,{"C7_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"C7_SEQ"     , "C" , 04 , 0 } )
AADD(aStru,{"C7_NUM"     , "C" , 06 , 0 } )
AADD(aStru,{"C7_ITEM"    , "C" , 04 , 0 } )
AADD(aStru,{"C7_CDTPLJT" , "D" , 08 , 0 } )
AADD(aStru,{"C7_PRODUTO" , "C" , 30 , 0 } )
AADD(aStru,{"C7_DESCRI"  , "C" , 30 , 0 } )
AADD(aStru,{"C7_UM"      , "C" , 02 , 0 } )
AADD(aStru,{"C7_TIPO"    , "C" , 02 , 0 } )
AADD(aStru,{"C7_SALDO"   , "N" , 14 , 2 } )
AADD(aStru,{"C7_PRECO"   , "N" , 12 , 4 } )
AADD(aStru,{"C7_PRECO2"  , "N" , 12 , 4 } )
AADD(aStru,{"C7_TOTAL"   , "N" , 15 , 2 } )
AADD(aStru,{"C7_TOTAL2"  , "N" , 15 , 2 } )
AADD(aStru,{"C7_MOEDA"   , "N" , 01 , 0 } )
AADD(aStru,{"C7_TXMOEDA" , "N" , 12 , 4 } )
AADD(aStru,{"C7_X_FABRI" , "C" , 15 , 0 } )
AADD(aStru,{"TB_PEDIDO"  , "C" , 06 , 0 } )
AADD(aStru,{"TB_ITEMPC"  , "C" , 04 , 0 } )
cCriaTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cCriaTrab,"TRB",.F.,.F.)
*
AADD(aCampos , { "C7_OK"      ,                     , "Ok"           } )
AADD(aCampos , { "C7_SEQ"     ,                     , "Seq."         } )
AADD(aCampos , { "C7_NUM"     ,                     , "Pedido"       } )
AADD(aCampos , { "C7_ITEM"    ,                     , "Item"         } )
AADD(aCampos , { "C7_CDTPLJT" ,                     , "Dt.Entrega"   } )
AADD(aCampos , { "C7_PRODUTO" ,                     , "Cód.Produto"  } )
AADD(aCampos , { "C7_DESCRI"  ,                     , "Descrição"    } )
AADD(aCampos , { "C7_UM"      ,                     , "UM"           } )
AADD(aCampos , { "C7_SALDO"   , "@E 9999999,99"     , "Saldo"        } )
AADD(aCampos , { "C7_PRECO"   , "@E 99999.9999"     , "Prc.Unit.Estr"} )
AADD(aCampos , { "C7_X_FABRI" ,                     , "Fabricante"   } )
*
///aCols   := {{"0001",SPACE(15),SPACE(30),SPACE(2),SPACE(2),0,0,0,SPACE(6),SPACE(4),SPACE(6),0,0,0,0,0,.F.}}
n       := 1
aCols   := {{"0001",SPACE(30),SPACE(30),SPACE(2),SPACE(2),0,0,0,0,SPACE(6),SPACE(4),SPACE(6),0,0,0,0,0,"",.F.}}

aHeader := {}   
/*
AADD(aHeader,{"Item"                             , "C7_ITEM   " ,"                   " ,04,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})             
AADD(aHeader,{"Produto"                          , "C7_PRODUTO" ,"@!                 " ,30,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Descrição"                        , "C7_DESCRI " ,"@!                 " ,30,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Tipo"                             , "C7_TIPO   " ,"@!                 " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"U.M."                             , "C7_UM     " ,"@!                 " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Quantidade"                       , "C7_SALDO  " ,"@E 99999999.99     " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Prc.Unit.(ME)"                    , "C7_PRECO2 " ,"@E 99999,999.999999" ,13,4, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Prc.Unit.(R$)"                    , "C7_PRECO  " ,"@E 99999,999.9999  " ,13,4, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Total"                            , "C7_TOTAL  " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Pedido"                           , "C7_PEDIDO " ,"@!                 " ,06,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Itm.Ped"                          , "C7_ITEMPC " ,"@!                 " ,04,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Fabric."                          , "C7_FORNECE" ,"@!                 " ,06,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Vlr.BC Import"                    , "C7_VLRBC  " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Vlr.Imp.Import"                   , "C7_VLRII  " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Vlr.Desp.Aduan"                   , "C7_VLRDSP " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Vlr.Desconto"                     , "C7_VLRDSC " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Vlr.IOF"                          , "C7_VLRIOF " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
*/
AADD(aHeader,{"Item"                             , "TB_ITEM   " ,"                   " ,04,0, "                               ","€€€€€€€€€€€€€€ ","C","TRB"," "," "," "})             
AADD(aHeader,{"Produto"                          , "D1_COD    " ,"@!                 " ,30,0, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","C","SD1"," "," "," "})
AADD(aHeader,{"Descrição"                        , "B1_NARRA  " ,"@!                 " ,30,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Tipo"                             , "B1_GRPNATR" ,"@!                 " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"U.M."                             , "B1_CNATREC" ,"@!                 " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C","SB1","V"," "," "})
AADD(aHeader,{"Quantidade"                       , "TB_QUANT  " ,"@E 99999999.99     " ,12,2, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","TRB"," "," "," "})
AADD(aHeader,{"Prc.Unit.(ME)"                    , "TB_VUNIT2 " ,"@E 99999,999.9999  " ,13,4, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","TRB"," "," "," "})
AADD(aHeader,{"Prc.Unit.(R$)"                    , "TB_VUNIT  " ,"@E 99999,999.9999  " ,13,4, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","TRB"," "," "," "})
AADD(aHeader,{"Total (R$)"                       , "TB_TOTAL  " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","TRB"," "," "," "})
AADD(aHeader,{"Pedido"                           , "TB_PEDIDO " ,"@!                 " ,06,0, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","C","TRB"," "," "," "})
AADD(aHeader,{"Itm.Ped"                          , "TB_ITEMPC " ,"@!                 " ,04,0, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","C","TRB"," "," "," "})
AADD(aHeader,{"Fabric."                          , "CD5_CODFAB" ,"@!                 " ,06,0, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","C","CD2"," "," "," "})
AADD(aHeader,{"Vlr.BC Import"                    , "C7_NUMSC  " ,"@E 999999,999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N","SC7"," "," "," "})
AADD(aHeader,{"Vlr.Imp.Import"                   , "CD5_VLRII " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"," "," "," "})
AADD(aHeader,{"Vlr.Desp.Aduan"                   , "CD5_DSPAD " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"," "," "," "})
AADD(aHeader,{"Vlr.Desconto"                     , "CD5_VDESDI" ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"," "," "," "})
AADD(aHeader,{"Vlr.IOF"                          , "CD5_VLRIOF" ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTEXG010',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"," "," "," "})
AADD(aHeader,{"ERROS"                            , "C7_NUMSC  " ,"@!                 " ,35,0, "                               ","€€€€€€€€€€€€€€ ","C","SC7","V"," "," "})
/*
AADD(aHeader,{"Base PIS"                         , "CD5_BSPIS " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"})
AADD(aHeader,{"Aliq.PIS"                         , "CD5_ALPIS " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"})
AADD(aHeader,{"Vlr. PIS"                         , "CD5_VLPIS " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"})
AADD(aHeader,{"Dt.Pag.PIS"                       , "CD5_DTPPIS" ,"                   " ,08,0, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","D","CD5"})
AADD(aHeader,{"Base Cofins"                      , "CD5_BSCOF " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"})
AADD(aHeader,{"Aliq.Cofins"                      , "CD5_ALCOF " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"})
AADD(aHeader,{"Vlr. Cofins"                      , "CD5_VLCOF " ,"@E 999999,999.99   " ,12,2, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","N","CD5"})
AADD(aHeader,{"Dt.Pag.Cofins"                    , "CD5_DTPCOF" ,"                   " ,08,0, "ExecBlock('CESTG010EX',.F.,.F.)","€€€€€€€€€€€€€€ ","D","CD5"})
*/
dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"01"+cSerie)
cDoc := RTRIM(SX5->X5_DESCRI)
*
dbSelectArea("SB1")
dbSetOrder(1)
*
dbSelectArea("SD1")
dbSetOrder(1)
*
dbSelectArea("CD5")
dbSetOrder(4)
*
dbSelectArea("CDT")
dbSetOrder(1)
*
dbSelectArea("SC7")
dbSetOrder(1)
*
///dbSelectArea("TPR")
///dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 065,000 To 636,1157 Dialog oDlg Title OemToAnsi("Pré-Nota de Importação")
@ 001,003 To 093,300 Title OemToAnsi("Dados da Declaração")   //76
@ 001,306 To 093,506 Title OemToAnsi("Dados da Nota Fiscal")
@ 096,003 To 264,567 Title OemToAnsi("Itens da Nota Fiscal")  //79
@ 008,005 Say OemToAnsi("Nro. D.I.")                                       Size 21,7
@ 008,064 Say OemToAnsi("Data do Registro")                                Size 41,7
@ 008,119 Say OemToAnsi("Local do Desembaraço")                            Size 57,7
@ 008,240 Say OemToAnsi("Data do Desembaraço")                             Size 55,7
@ 029,005 Say OemToAnsi("Taxa Moeda Estrang")                              Size 50,7
@ 008,310 Say OemToAnsi("Série")                                           Size 15,7
@ 008,334 Say OemToAnsi("Numero")                                          Size 20,7
@ 008,380 Say OemToAnsi("Data de Emissão")                                 Size 42,7
@ 029,310 Say OemToAnsi("Fornecedor/Exportador")                           Size 57,7
@ 050,310 Say OemToAnsi("Fabricante/Produtor")                             Size 50,7
@ 071,310 Say OemToAnsi("Via Transporte")                                  Size 57,7                     COLOR CLR_HBLUE
@ 071,400 Say OemToAnsi("Tipo Importação")                                 Size 50,7                     COLOR CLR_HBLUE

@ 029,064 Say OemToAnsi("Valor Frete (R$)")                                Size 40,7
@ 029,119 Say OemToAnsi("Valor Seguro (R$)")                               Size 46,7
@ 029,174 Say OemToAnsi("Vlr.Outras Desp. (R$)")                           Size 61,7
@ 029,240 Say OemToAnsi("Valor FOB (R$)")                                  Size 40,7
@ 050,005 Say OemToAnsi("Taxa Suframa")                                    Size 35,7
@ 050,064 Say OemToAnsi("Taxa Siscomex")                                   Size 37,7
@ 050,119 Say OemToAnsi("Taxa Infraereo/Eadi")                             Size 50,7
@ 050,174 Say OemToAnsi("Taxa Frete Local")                                Size 43,7
@ 050,240 Say OemToAnsi("Taxa Despachante")                                Size 47,7
@ 071,005 Say OemToAnsi("Observação" )                                     Size 35,7
@ 266,005 Say OemToAnsi("Total dos Produtos")                              Size 50,7
@ 266,075 Say OemToAnsi("Total da Pré-Nota")                               Size 50,7

@ 016,005 Get cNroDI          Picture "@R 99/9999999-9"                    Size 50,10  Valid fl_DI()
@ 016,064 Get dDtReg                                                       Size 45,10  
@ 016,119 Get cLocDes         Picture "@!"                                 Size 110,10 
@ 016,240 Get dDtDes                                                       Size 45,10  
@ 037,005 Get nTxDolar        Picture "@E 999.9999"                        Size 40,10  Valid nTxDolar >= 0
@ 037,064 Get nVlrFrete       Picture "@E 9999,999.99"                     Size 50,10
@ 037,119 Get nVlrSeg         Picture "@E 9999,999.99"                     Size 50,10
@ 037,174 Get nDespesa        Picture "@E 9999,999.99"                     Size 50,10
@ 037,240 Get nVlrFob         Picture "@E 99999,999.99"                    Size 53,10  
@ 058,005 Get nSuframa        Picture "@E 9999,999.99"                     Size 50,10
@ 058,064 Get nSiscomex       Picture "@E 9999,999.99"                     Size 50,10
@ 058,119 Get nArmazem        Picture "@E 9999,999.99"                     Size 50,10
@ 058,174 Get nFrete          Picture "@E 9999,999.99"                     Size 50,10
@ 058,240 Get nDespacha       Picture "@E 9999,999.99"                     Size 55,10
@ 079,005 Get cObserv         Picture "@!"                                 Size 286,10

@ 016,310 Get cSerie                                                       Size 12,10  Valid fl_Serie()
@ 016,334 Get cDoc            Picture "@R 999999999"                       Size 40,10  Valid fl_Doc()
@ 016,380 Get dEmissao                                                     Size 45,10  Valid IIF(EMPTY(dEmissao) , .T. , dEmissao > dDatFech )
@ 037,310 Get cFornece                                  F3 "SA2"           Size 30,10  Valid fl_Fornece(1)
@ 037,350 Get cLoja1                                                       Size 12,10  Valid fl_Fornece(2)
@ 037,370 Get cDesFor                                                      Size 130,10 WHEN .F.              Object oDesFor
@ 058,310 Get cFabric                                   F3 "SA2"           Size 30,10  Valid fl_Fabric(1)
@ 058,350 Get cLoja2                                                       Size 12,10  Valid fl_Fabric(2)
@ 058,370 Get cDesFab                                                      Size 130,10 WHEN .F.              Object oDesFab

@ 079,310 COMBOBOX cVTrans  ITEMS aVTrans                                  SIZE 70,20                 
@ 079,400 COMBOBOX cTpImpor ITEMS aTpImpor                                 SIZE 90,20              

@ 273,005 Get nTotProd       Picture "@E 9999,999.99"                      Size 50,10  WHEN .F.              Object oTotProd
@ 273,075 Get nTotNota       Picture "@E 9999,999.99"                      Size 55,10  WHEN .F.              Object oTotNota

@ 104,008 TO 258,564 MULTILINE MODIFY DELETE FREEZE 3  Object oMulti      ///087

@ 005,512 Button OemToAnsi("_Pedido Protheus")                             Size 55,12 Action fl_PedImp()
@ 020,512 Button OemToAnsi("Pedido Planil_ha")                             Size 55,12 Action MsAguarde({||fl_PedXls()},'Extraindo itens do Pedido de Importação','Aguarde...') 
@ 035,512 Button OemToAnsi("Imprime _Erros")                               Size 55,12 Action MsAguarde({||fl_prterrors()},'Imprimindo os erros encontrados.','Aguarde...') 
@ 050,512 Button OemToAnsi("Confirma _Nota")                               Size 55,12 Action fl_ProcDI()
@ 065,512 Button OemToAnsi("Cance_la Nota")                                Size 55,12 Action fl_Cancela()                  

Activate Dialog oDlg CENTER Valid lSair

TRB->(dbCloseArea())
///TPR->(dbCloseArea())

Return

//////////////////////////////////////////////////////
Static Function LineG010()
//////////////////////////////////////////////////////

IF ( TPR->FLAG )
	nTotProd := ( nTotProd + TPR->C7_TOTAL )
	nTotNota := ( nTotNota + TPR->C7_TOTAL )
ELSE
   nTotProd := ( nTotProd - TPR->C7_TOTAL )
   nTotNota := ( nTotNota - TPR->C7_TOTAL )
ENDIF

oTotProd:Refresh()
oTotNota:Refresh()

n := nBrLin

Return(.T.)

//////////////////////////////////////////////
Static Function fl_Cancela()
//////////////////////////////////////////////
Local lRsp 

lRsp := MsgBox("Deseja realmente cancelar a Pre-Nota?","Escolha a opção","YESNO")

IF ( lRsp )
	lSair := .T.
	oDlg:End()
ENDIF

Return(lRsp)

////////////////////////////////////	
Static Function fl_DI()
////////////////////////////////////
Local cQry
Local lRsp := .T.
Local xDI := TRANSF(cNroDI,"@R 99/9999999-9")

IF ( !EMPTY(cNroDI) )
	cQry  := "SELECT COUNT(*) CTD FROM "+RetSqlName("SF1")
	cQry  += " WHERE D_E_L_E_T_ = ' '"
	cQry  += " AND F1_FILIAL = '"+xFilial("SF1")+"'"
	cQry  += " AND F1_EST = 'EX'"
	cQry  += " AND F1_OBSNFE4 LIKE '%"+xDI+"%' "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

	IF ( TB3->CTD > 0 )
		MsgInfo("Existe NF amarrada a esta D.I. Favor verificar o numero correto.")
	ENDIF
	
	IF ( EMPTY(cObserv) )
		cObserv := "DI: " + TRANSF(cNroDI,"@R 99/9999999-9") + SPACE(40)
		cObserv := LEFT(cObserv,50)
	ELSE
		cObserv := STUFF(cObserv,5,12,TRANSF(cNroDI,"@R 99/9999999-9"))
	ENDIF

	TB3->(dbCloseArea())
	
ENDIF	

Return(lRsp)

//////////////////////////////////////////////////
Static Function fl_Serie()
//////////////////////////////////////////////////
Local lRsp  := .T.
Local xSped := cSerie + "=SPED"
Local ix    := AT(xSPed , cEspecie)

IF ( !EMPTY(cSerie).AND.ix = 0 )
   lRsp := .F.
	MsgInfo("Série inválida!","NF-e")
ELSE
	SX5->(dbSeek(xFilial("SX5")+"01"+cSerie))
	cDoc := RTRIM(SX5->X5_DESCRI)	
ENDIF

Return(lRsp)

//////////////////////////////////////////////////
Static Function fl_Doc()
//////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(cDoc) )
	dbSelectArea("SF3")
	dbSetOrder(6)
	dbSeek(xFilial("SF3")+cDoc+cSerie,.T.)
	DO WHILE !EOF().AND.F3_FILIAL==xFilial("SF3").AND.F3_NFISCAL==cDoc.AND.F3_SERIE==cSerie.AND.lRsp
		IF ( LEFT(F3_CFO,1) $ "3567".AND.F3_ENTRADA > dDatFech )
			lRsp := .F.
			MsgInfo("Nota Fiscal/Série já foi usada. Favor verificar!","NF.: "+cSerie+" "+cDoc)
		ENDIF
		dbSkip()
	ENDDO
ENDIF	

Return(lRsp)

/////////////////////////////////////////////////////////////////
Static Function fl_Fornece(nOpc)
/////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(cFornece) )

	dbSelectArea("SA2")
	dbSetOrder(1)
	IF ( nOpc == 1 )
		dbSeek(xFilial("SA2")+cFornece)
	ELSE
		dbSeek(xFilial("SA2")+cFornece+cLoja1)
	ENDIF
	IF ( EOF() )
		lRsp := .F.
		MsgInfo("** Fornecedor/Loja não cadastrado. Favor verificar!")
	ELSEIF ( SA2->A2_EST <> "EX" )
		lRsp := .F.
		MsgInfo("** Favor informar um Fornecedor estrangeiro.")
	ELSE
		cLoja1  := SA2->A2_LOJA
		cDesFor := SA2->A2_NOME
	ENDIF
	
ENDIF	

Return(lRsp)

/////////////////////////////////////////////////////////////////
Static Function fl_Fabric(nOpc)
/////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(cFabric) )

	dbSelectArea("SA2")
	dbSetOrder(1)
	IF ( nOpc == 1 )
		dbSeek(xFilial("SA2")+cFabric)
	ELSE
		dbSeek(xFilial("SA2")+cFabric+cLoja2)
	ENDIF
	IF ( EOF() )
		lRsp := .F.
		MsgInfo("** Fabricante/Loja não cadastrado. Favor verificar!")
	ELSE
		cLoja2  := SA2->A2_LOJA
		cDesFab := SA2->A2_NOME
	ENDIF
	
ENDIF	

Return(lRsp)

///////////////////////////////////////////////////////////////////
Static Function fl_PedXls()
///////////////////////////////////////////////////////////////////
Local cxLinha,cxPedido,cxItem,cxCodigo,cxDescri,cxObs
Local nxQuant,nxPrcME,nxPrcBR,nxTotal
Local aQtde     := {}
Local nxSeq     := 0
Local cQuebra   := Chr(13) + Chr(10)
Local nMaskDef	 := 1 								// Mascara .TXT
Local cTipo     := "Marcação (*.CSV)        | *.CSV | "
Local cTipo     := cTipo + "Todos os Arquivos (*.*)   | *.*     "
Local cxPath    := "C:\"
Local cArq      := cGetFile( cTipo,"Selecione arquivo...",@nMaskDef    , cxPath , .T. , CGETFILE_TYPE )

IF ( !EMPTY(cArq) )

	aArqTemp := U_CCONVCSV("1" , RTRIM(cArq) , "D_I.txt" , "TempDI.txt" )                                 ///Pasta: \SYSTEM\CONVCSV\D_I.TXT

	IF ( !EMPTY(aArqTemp[1]) )
      ///PEDIDO;ITEM;CODIGO                        ;QUANTIDADE;PRECO_ME;PRECO_BR;TOTAL;DESCRI
		dbSelectArea("SB1")
		dbSetOrder(1)
		
		aCols := {}
		Ft_fuse(aArqTemp[1])
		ft_fgotop()
		ProcRegua(500)
		DO WHILE !ft_feof()
			cxLinha  := StrTran(ft_freadln(), cQuebra, "")
			cxPedido := SUBS(cxLinha,1,6)
			cxItem   := SUBS(cxLinha,7,4)
			cxCodigo := SUBS(cxLinha,11,30)
			nxQuant  := VAL( SUBS(cxLinha,41,10) )
			nxPrcME  := ( VAL(SUBS(cxLinha,51,12)) / 10000 )
			nxPrcBR  := ( VAL(SUBS(cxLinha,63,12)) / 10000 )
			nxTotal  := ( VAL(SUBS(cxLinha,75,12)) / 100 )
			cxDescri := SUBS(cxLinha,87,200)
			
			SB1->(dbSeek(xFilial("SB1")+cxCodigo))
			
			IF ( !EMPTY(cxCodigo) )
				nxSeq++
				cxObs    := ""
				nTotProd := ( nTotProd + nxTotal )
				xFabric  := IIF(EMPTY(cFabric) , cFornece , cFabric )
				cxDescri := IIF(EMPTY(cxDescri) , SB1->B1_DESC , cxDescri )
				IF ( SB1->(EOF()) )
					MsgInfo("Codigo "+RTRIM(cxCodigo)+" NÃO Cadastrado. Favor verificar o codigo correto.","Atenção")
					cxDescri := "CODIGO NAO CADASTRADO"
				ENDIF
				
				SC7->(dbSeek(xFilial("SC7")+cxPedido+cxItem))
				
				nX := ASCAN(aQtde , { |x| x[1]+x[2]+x[3]==SC7->(C7_NUM+C7_ITEM+C7_PRODUTO) } )
				
				IF ( nX == 0 )
					AADD(aQtde , { SC7->C7_NUM , SC7->C7_ITEM , SC7->C7_PRODUTO , ( SC7->C7_QUANT - SC7->C7_QUJE ) } )
					nX := LEN(aQtde)
				ENDIF
				aQtde[nX,4] -= nxQuant
				
				IF ( SC7->(EOF()) )
					cxObs := "Pedido/Item NÃO cadastrado."
				ELSEIF ( SC7->C7_ENCER == "E" .OR. SC7->C7_RESIDUO == "S" )
					cxObs := "Pedido/Item Encerrado."
				ELSEIF ( SC7->C7_CONAPRO == "B" )
					cxObs := "Pedido/Item Bloqueado."
				ELSEIF ( SC7->C7_PRODUTO <> cxCodigo )
					cxObs := "Codigo do Produto divergente."
				///ELSEIF ( ( SC7->C7_QUANT - SC7->C7_QUJE ) < nxQuant )
				ELSEIF ( aQtde[nX,4] < 0 )
					cxObs := "Pedido/Item com saldo insuficiente."
				ENDIF
				
				AADD(aCols , { STRZERO(nxSeq,4)  , ;
									cxCodigo          , ;
									SB1->B1_DESC      , ;
									SB1->B1_TIPO      , ;
									SB1->B1_UM        , ;
									nxQuant           , ;
									nxPrcME           , ;
									nxPrcBR           , ;
									nxTotal           , ;
									cxPedido          , ;
									cxItem            , ;
									xFabric           , ;
									nxTotal           , ;
									0                 , ;
									0                 , ;
									0                 , ;
									0                 , ;
									cxObs             , ;
									.F. } )

			ENDIF
			ft_fskip()
		ENDDO	
		ft_fuse()
	
		cItemSq  := STRZERO(LEN(aCols),4)
		aCols    := aSort(aCols,,, { |x, y| x[1] < y[1] })		
		nTotNota := ( nTotNota + nTotProd + nVlrFrete + nVlrSeg + nDespesa )
		
		oMulti:oBrowse:Refresh()
		
	ENDIF
	
ENDIF	

Return

///////////////////////////////////////////////////////////////////
Static Function fl_PedImp()
///////////////////////////////////////////////////////////////////
Local   cQuery, cQry , nx , nPreco , nTotal , xFabric
Local   nSaida   := 0
Local   lInverte := .F.
Local   aOpcoes  := {"Adicionar","Sobrepor","Cancelar"}
Local   cTitl    := "Atenção!"
Local   cMsg     := "Já existe pedidos em edição. Voce está selecionando pedidos para: Adicionar, Sobrepor ou Cancela a seleção?"
Local   nOpcA    := 2
Private nSeqPed  := 0
Private cMarca   := GetMark()
Private oSelDlg,oMark,oBrowse

IF ( EMPTY(cFornece) )
	MsgStop("Falta informar o Fornecedor.")
	Return(.F.)
ENDIF
IF ( nTxDolar = 0 )
	MsgStop("Falta informar a Taxa da Moeda Estrangeira p/conversão dos valores.")
	Return(.F.)
ENDIF

IF ( LEN(aCols) > 0 .AND. !EMPTY(aCols[1,2])  )
	nOpcA := Aviso(cTitl,cMsg,aOpcoes)
	IF ( nOpcA = 0 .OR. nOpca = 3 )
		Return
	ENDIF
ENDIF

cQuery := "SELECT C7_OK,C7_NUM,C7_ITEM,C7_CDTPLJT,C7_PRODUTO,C7_DESCRI,C7_UM,B1_TIPO,( C7_QUANT - C7_QUJE ) C7_SALDO,C7_PRECO,C7_PRECO2,C7_TOTAL2,C7_MOEDA,C7_TXMOEDA,C7_X_FABRI"
cQuery += " FROM "+RetSqlName("SC7")+" C7,"+RetSqlName("SB1")+" B1"
cQuery += " WHERE C7.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' '"
cQuery += " AND C7_FILIAL = '"+xFilial("SC7")+"'"
cQuery += " AND C7_FORNECE = '"+cFornece+"'"
cQuery += " AND C7_LOJA = '"+cLoja1+"'"
cQuery += " AND C7_MOEDA > 1"
cQuery += " AND C7_ENCER = ' ' AND C7_RESIDUO = ' '"
cQuery += " AND B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO"
cQuery += " ORDER BY C7_PRODUTO,C7_NUM,C7_ITEM "

cQry := ChangeQuery(cQuery)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
			
TcSetField("TMP","C7_SALDO","N",12,2)
TcSetField("TMP","C7_PRECO","N",11,4)
TcSetField("TMP","C7_PRECO2","N",11,4)
TcSetField("TMP","C7_TXMOEDA","N",11,4)
TcSetField("TMP","C7_CDTPLJT","D",08,0)

dbSelectArea("TRB")
dbGoTop()
IF ( !EOF() )
	__dbZap()
ENDIF
*
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	RecLock("TRB",.T.)
	TRB->C7_OK       := SPACE(2)
	TRB->C7_SEQ      := SPACE(4)
	TRB->C7_NUM      := TMP->C7_NUM
	TRB->C7_ITEM     := TMP->C7_ITEM
	TRB->C7_CDTPLJT  := TMP->C7_CDTPLJT
	TRB->C7_PRODUTO  := TMP->C7_PRODUTO
	TRB->C7_DESCRI   := TMP->C7_DESCRI
	TRB->C7_UM       := TMP->C7_UM
	TRB->C7_TIPO     := TMP->B1_TIPO
	TRB->C7_SALDO    := TMP->C7_SALDO
	TRB->C7_PRECO    := TMP->C7_PRECO
	TRB->C7_PRECO2   := TMP->C7_PRECO2
	TRB->C7_TOTAL2   := TMP->C7_TOTAL2
	TRB->C7_MOEDA    := TMP->C7_MOEDA
	TRB->C7_TXMOEDA  := TMP->C7_TXMOEDA
	TRB->C7_X_FABRI  := TMP->C7_X_FABRI
	MsUnlock()
	dbSelectArea("TMP")
	dbSkip()
ENDDO

TMP->(dbCloseArea())

dbSelectArea("TRB")
dbGoTop()

@ 000,000 TO 430,990 DIALOG oSelDlg TITLE "Pedidos em aberto" 

@ 000, 002 TO 212, 436 TITLE "Seleção"                    

oMark := MsSelect():New("TRB","C7_OK",,aCampos,@lInverte,@cMarca,{008,006,204,430})
oMark:oBrowse:bldblclick := { || f_markbrw() }                                         

@ 005,440 Button OemToAnsi("Confirma")                               Size 50,13 Action ( nSaida := 1 , oSelDlg:End() )
@ 020,440 Button OemToAnsi("Marca Ped.Sel.")                         Size 50,13 Action fl_MarkPed()                      
@ 035,440 Button OemToAnsi("Desm. Ped.Sel.")                         Size 50,13 Action fl_DesmPed()                      
@ 050,440 Button OemToAnsi("Marca Todos")                            Size 50,13 Action fl_MarkAll()                     
@ 065,440 Button OemToAnsi("Desmarca Todos")                         Size 50,13 Action fl_DesmAll()                      
@ 080,440 Button OemToAnsi("Cancela")                                Size 50,13 Action ( nSaida := 2 , oSelDlg:End() )

ACTIVATE DIALOG oSelDlg CENTERED Valid ( nSaida > 0 )

IF ( nSaida == 1 )
	IF ( nOpca = 2 )
		aCols    := {}
		nx       := 0
		n        := 1
		nTotProd := 0
	ENDIF
	nTotNota := 0
	
	dbSelectArea("TRB")
	dbGoTop()
	DO WHILE !EOF()
		IF ( !EMPTY(TRB->C7_OK) )
		
			nx := IIF(nOpcA==2 , 0 , aScan(aCols,{|x| x[10]+x[11] == TRB->C7_NUM+TRB->C7_ITEM}) )
			
			IF ( nx = 0 )
				nMoeda   := TRB->C7_MOEDA
				nPreco   := NoRound(TRB->C7_PRECO * nTxDolar , 4 )
				nTotal   := NoRound(nPreco * TRB->C7_SALDO , 2 )
				nTotProd := ( nTotProd + nTotal )
				xFabric  := IIF(EMPTY(cFabric) , cFornece , cFabric )
			
				AADD(aCols , { TRB->C7_SEQ       , ;
									TRB->C7_PRODUTO   , ;
									TRB->C7_DESCRI    , ;
									TRB->C7_TIPO      , ;
									TRB->C7_UM        , ;
									TRB->C7_SALDO     , ;
									TRB->C7_PRECO     , ;
									nPreco            , ;
									nTotal            , ;
									TRB->C7_NUM       , ;
									TRB->C7_ITEM      , ;
									xFabric           , ;
									nTotal            , ;
									0                 , ;
									0                 , ;
									0                 , ;
									0                 , ;
									""                , ;
									.F. } )
			ENDIF
			/*					
			RecLock("TPR",.T.)
			TPR->C7_ITEM    := STRZERO(nx,4)
			TPR->C7_PRODUTO := TRB->C7_PRODUTO   
			TPR->C7_DESCRI  := TRB->C7_DESCRI    
			TPR->C7_TIPO    := TRB->C7_TIPO     
			TPR->C7_UM      := TRB->C7_UM        
			TPR->C7_SALDO   := TRB->C7_SALDO     
			TPR->C7_PRECO   := nPreco            
			TPR->C7_TOTAL   := nTotal          
			TPR->C7_PEDIDO  := TRB->C7_NUM      
			TPR->C7_ITEMPC  := TRB->C7_ITEM      
			TPR->C7_FABRIC  := xFabric           
			TPR->C7_VLRBC   := nTotal            
			TPR->FLAG       := .F.
			MsUnlock()
			*/
			dbSelectArea("TRB")
			
		ENDIF
		dbSkip()
	ENDDO
	///dbSelectArea("TPR")
	///dbGoTop()
	
	///aCols    := aSort(aCols,,, { |x, y| x[2]+x[10]+x[11] < y[2]+y[10]+y[11] })		
	cItemSq  := STRZERO(LEN(aCols),4)
	aCols    := aSort(aCols,,, { |x, y| x[1] < y[1] })		
	nTotNota := ( nTotNota + nTotProd + nVlrFrete + nVlrSeg + nDespesa )
	
	oMulti:oBrowse:Refresh()
	
ENDIF	

Return

////////////////////////////////////////////////////////////////
Static Function f_markbrw() 
////////////////////////////////////////////////////////////////
Local nRecNo
Local nSequen := VAL(TRB->C7_SEQ)

RecLock("TRB",.F.)
IF ( EMPTY(TRB->C7_OK) )
	nSeqPed++
	TRB->C7_OK  := cMarca 
	TRB->C7_SEQ := STRZERO(nSeqPed,4)
	MsUnlock()
ELSE	
	TRB->C7_OK  := "  " 
	TRB->C7_SEQ := " "
	MsUnlock()
	IF ( nSeqPed > nSequen )
		nRecNo := TRB->(RECNO())
		TRB->(dbGoTop())
		DO WHILE !EOF()
			IF ( !EMPTY(TRB->C7_SEQ) .AND. VAL(TRB->C7_SEQ) > nSequen )
				RecLock("TRB",.F.)
				TRB->C7_SEQ := STRZERO( ( VAL(TRB->C7_SEQ) - 1 ) , 4 )
				MsUnlock()
			ENDIF
			dbSkip()
		ENDDO
		TRB->(dbGoTo(nRecNo))
		oMark:oBrowse:Refresh()
	ENDIF
	nSeqPed--
ENDIF

Return

/////////////////////////////////////////////////////////
Static Function fl_DesmAll()
/////////////////////////////////////////////////////////
dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
   IF ( !EMPTY(C7_OK) )
      RecLock("TRB",.F.)
      TRB->C7_OK  := "  "
		TRB->C7_SEQ := " "
      MsUnlock()
   ENDIF
   dbSkip()
ENDDO
dbGoTop()
lInverte := .T.
oMark:oBrowse:Refresh()
oMark:oBrowse:GoTop()
Return

////////////////////////////////////////////////////////
Static Function fl_MarkAll()
////////////////////////////////////////////////////////

nSeqPed := 0
dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
	nSeqPed++
   RecLock("TRB",.F.)
   TRB->C7_OK  := cMarca
	TRB->C7_SEQ := STRZERO(nSeqPed,4)
   MsUnlock()
   dbSkip()
ENDDO
dbGoTop()
lInverte := .F.
oMark:oBrowse:Refresh()
oMark:oBrowse:GoTop()
Return

/////////////////////////////////////////////////////////
Static Function fl_DesmPed()
/////////////////////////////////////////////////////////
Local xPed := TRB->C7_NUM
Local xReg := TRB->(RECNO())

dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
   IF ( !EMPTY(C7_OK).AND.TRB->C7_NUM==xPed )
      RecLock("TRB",.F.)
      TRB->C7_OK  := "  "
		TRB->C7_SEQ := " "
      MsUnlock()
   ENDIF
   dbSkip()
ENDDO
dbGoTo(xReg)
lInverte := .T.
nSeqPed  := 0
oMark:oBrowse:Refresh()
Return

/////////////////////////////////////////////////////////
Static Function fl_MarkPed()
/////////////////////////////////////////////////////////
Local nSeq := 0
Local xPed := TRB->C7_NUM
Local xReg := TRB->(RECNO())

lInverte := .F.
dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
   IF ( TRB->C7_NUM==xPed )
		nSeq++
      RecLock("TRB",.F.)
      TRB->C7_OK  := cMarca
		TRB->C7_SEQ := STRZERO(nSeq,4)
      MsUnlock()
	ELSEIF ( !lInverte )
		lInverte := .T.
   ENDIF
   dbSkip()
ENDDO
dbGoTo(xReg)
oMark:oBrowse:Refresh()
Return

/////////////////////////////////////////////////
Static Function fl_ProcDI()
////////////////////////////////////////////////
Local   nUsado   := Len(aHeader)
Local   nSaveSX8 := GetSX8Len()
Local   lGrava   := .F.
Local   cNadic   := "100"
Local   cSqItem  := cNadic
Local   cItem    := StrZero(0,Len(SD1->D1_ITEM))
Local   nMaxFor  := LEN(aCols)
Local   cEstDes     := SM0->M0_ESTCOB                    ////Carlos - 20/03/2015    IIF(M->cNumEmp=="0301" , "AM" , "SP" )
Private lMsErroAuto := .F.


lRsp := MsgBox("Confirma a geração da Pré-Nota?","Escolha a opção","YESNO")

IF ( !lRsp )
	MsgInfo("Pré-Nota não confirmada...","Atenção")
	Return
ENDIF
IF ( EMPTY(cFornece).OR.EMPTY(cLoja1) )
	MsgStop("Falta o preenchimento do campo Fornecedor/Loja.","Atenção")
	Return
ENDIF
IF ( EMPTY(cNroDI).OR.EMPTY(dDtReg).OR.EMPTY(cLocDes).OR.EMPTY(dDtDes) )
	MsgStop("Falta o preenchimento de informações da D.I.","Atenção")
	Return
ENDIF

IF ( EMPTY(cSerie).OR.EMPTY(cDoc).OR.EMPTY(dEmissao) )
	MsgStop("Favor verificar o preenchimento dos campos: Série, N.Fiscal e Data Emissão.","Atenção")
	Return
ENDIF

IF ( EMPTY(cVTrans) )
	MsgStop("Falta informar a via de transporte.","Atenção")
	Return
ENDIF

IF ( EMPTY(cTpImpor) )
	MsgStop("Falta informa o tipo de importação.","Atenção")
	Return
ENDIF

IF ( ( nSuframa + nSiscomex + nArmazem + nFrete + nDespacha ) <> nDespesa )
	MsgStop("Valores das Taxas não bate com o Vlr. Outras Desp.","Atenção")
	Return
ENDIF

nx := 1	
DO WHILE nx <= nMaxFor.AND.lRsp
	lRsp := IIf( EMPTY(aCols[nx,12]) , .F. , lRsp )
	nx++
ENDDO
IF ( !lRsp )
	MsgStop("Falta informar Código de Fabricante no item "+aCols[nx-1,1]+".","Atenção")
	Return
ENDIF	
IF ( !fl_doc() )
	Return
ENDIF

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+cFornece+cLoja1)
*
dbSelectArea("SB1")
dbSetOrder(1)

Begin Transaction

	aCols := aSort(aCols,,, { |x, y| x[1] < y[1] })

	For nX := 1 To nMaxFor
		 ///If ( !aCols[nX,(nUsado+1)]	.AND. !EMPTY(aCols[nx,2]) .AND. aCols[nx,6] > 0 )
		 If ( !EMPTY(aCols[nx,2]) .AND. aCols[nx,6] > 0 )
			 cItem := Soma1(cItem,Len(cItem))
			 SB1->(dbSeek(xFilial("SB1")+aCols[nx,2]))
			 dbSelectArea("SD1")
			 RecLock("SD1",.T.)
			 SD1->D1_FILIAL  := xFilial("SD1")
			 SD1->D1_FORNECE := cFornece
			 SD1->D1_LOJA	  := cLoja1
			 SD1->D1_DOC	  := cDoc
			 SD1->D1_SERIE	  := cSerie
			 SD1->D1_EMISSAO := dEmissao
			 SD1->D1_DTDIGIT := dEmissao
			 SD1->D1_DATACUS := dEmissao
			 SD1->D1_TIPO	  := "N"
			 SD1->D1_ITEM    := cItem
			 SD1->D1_COD     := aCols[nx,2]
			 SD1->D1_UM      := aCols[nx,5]
			 SD1->D1_QUANT   := aCols[nx,6]
			 SD1->D1_VUNIT   := aCols[nx,8]
			 SD1->D1_TOTAL   := aCols[nx,9]
			 SD1->D1_PEDIDO  := aCols[nx,10]
			 SD1->D1_ITEMPC  := aCols[nx,11]
			 SD1->D1_TP		  := SB1->B1_TIPO
			 SD1->D1_FORMUL  := "S"
			 SD1->D1_GRUPO	  := SB1->B1_GRUPO
			 SD1->D1_CONTA   := SB1->B1_CONTA
			 SD1->D1_LOCAL   := SB1->B1_LOCPAD	
			 SD1->D1_STSERV  := "1"
			 SD1->D1_GARANTI := "N"
			 MsUnlock()
			 *
			 IF ( !EMPTY(aCols[nx,10]) )
				 dbSelectArea("SC7")
				 dbSetOrder(1)
				 dbSeek(xFilial("SC7")+aCols[nx,10]+aCols[nx,11])
				 IF ( !EOF() )
					 RecLock("SC7",.F.)
					 SC7->C7_QTDACLA := ( SC7->C7_QTDACLA + aCols[nx,6] )
					 MsUnlock()
				 ENDIF
			 ENDIF
			 *
			 IF ( !EMPTY(cNroDI) )
				 IF ( cItem $ "100,200,300,400" )
					 cNadic  := ( VAL(cItem) + 100 )
					 cNadic  := STR(cNadic,3)
					 cSqItem := LEFT(cNadic,1)+"00"
				 ENDIF
				 cSqItem := Soma1(cSqItem,3)
				 dbSelectArea("CD5")
				 RecLock("CD5",.T.)
				 CD5->CD5_FILIAL  := xFilial("CD5")
				 CD5->CD5_DOC     := cDoc
				 CD5->CD5_SERIE   := cSerie
				 CD5->CD5_ESPEC   := "SPED"
				 CD5->CD5_FORNEC  := cFornece
				 CD5->CD5_LOJA    := cLoja1
				 CD5->CD5_TPIMP   := "0"
				 CD5->CD5_DOCIMP  := cNroDI
				 CD5->CD5_ACDRAW  := "."
				 CD5->CD5_LOCAL   := "0"
				 CD5->CD5_NDI     := cNroDI
				 CD5->CD5_DTDI    := dDtReg
				 CD5->CD5_LOCDES  := cLocDes
				 CD5->CD5_UFDES   := cEstDes
				 CD5->CD5_DTDES   := dDtDes
				 CD5->CD5_CODEXP  := cFornece
				 CD5->CD5_NADIC   := cNadic
				 CD5->CD5_SQADIC  := cSqItem
				 CD5->CD5_CODFAB  := aCols[nx,12]
				 CD5->CD5_BCIMP   := aCols[nx,13]
				 CD5->CD5_ITEM    := cItem
				 CD5->CD5_VTRANSF := LEFT(cVTrans,1)                          ///Versao 3.0 da NF-e - 20/03/2015
				 CD5->CD5_INTERM  := LEFT(cTpImpor,1)                         ///Versao 3.0 da NF-e - 20-03/2015
				 CD5->CD5_CNPJAE  := SM0->M0_CGC                              ///Versao 3.0 da NF-e - 20-03/2015
				 CD5->CD5_UFTERC  := SM0->M0_ESTCOB                           ///Versao 3.0 da NF-e - 20-03/2015
				 MsUnlock()
			 ENDIF	
		 EndIf
	Next nX
	If ( cItem <> "0000" )
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1")+cDoc+cSerie+cFornece+cLoja1+"N")
		If ( EOF() )
			RecLock("SF1",.T.)
			SF1->F1_FILIAL  := xFilial("SF1")
			SF1->F1_DOC     := cDoc
			SF1->F1_SERIE   := cSerie
			SF1->F1_FORNECE := cFornece
			SF1->F1_LOJA    := cLoja1
			SF1->F1_EMISSAO := dEmissao
			SF1->F1_EST     := SA2->A2_EST
			SF1->F1_TIPO    := "N"
			SF1->F1_DTDIGIT := dEmissao
			SF1->F1_FORMUL  := "S"
			SF1->F1_ESPECIE := "SPED"
			SF1->F1_DESPESA := nDespesa
			SF1->F1_FRETE   := nVlrFrete
			SF1->F1_SEGURO  := nVlrSeg
			SF1->F1_FOB_R   := nVlrFob
			SF1->F1_TAXAIMP := nTxDolar
			SF1->F1_OBSNFE4 := cObserv
			SF1->F1_CVLSUFR := nSuframa
			SF1->F1_CVLSISC := nSiscomex
			SF1->F1_CVLARMZ := nArmazem
			SF1->F1_CVLFRET := nFrete
			SF1->F1_CVLDSPC := nDespacha
			SF1->F1_CMOEDA  := nMoeda
			SF1->F1_MOEDA   := 1
			SF1->F1_TXMOEDA := nTxDolar
			SF1->F1_RECISS  := "2"
			SF1->F1_HORA    := TIME()
			MsUnlock() 
		EndIf
		*
		IF ( !EMPTY(cNroDI) )
			dbSelectArea("CDT")
			RecLock("CDT",.T.)
			CDT->CDT_FILIAL  := xFilial("CDT")
			CDT->CDT_TPMOV   := "E"
			CDT->CDT_DOC   := cDoc
			CDT->CDT_SERIE   := cSerie
			CDT->CDT_CLIFOR  := cFornece
			CDT->CDT_LOJA    := cLoja1
			CDT->CDT_INDFRT  := "1"
			MsUnlock()
		ENDIF
		*
		EvalTrigger()
		Do While ( GetSX8Len() > nSaveSX8 )
			ConfirmSx8()
		EndDo
		
	EndIf
		
End Transaction

lSair := .T.

IF ( lMsErroAuto )
	MsgStop("** ERRO NO PROCESSO DE GERAÇÃO DA PRE-NOTA DE IMPORTAÇÃO.","Atenção")
ELSE
	MsgInfo("**** Pré-Nota Fiscal "+cDoc+" gerada com sucesso!")
ENDIF

oDlg:End()

Return

///////////////////////////////////////////////////////////////////////////////////////////
Static Function fl_prterrors()
///////////////////////////////////////////////////////////////////////////////////////////
nOrdem    := 0
tamanho   := "M"
limite    := 132
cString   := "SD1"
titulo    := OemToAnsi("DIVERGENCIA DE PC x D.I")
cDesc1    := OemToAnsi("Emite uma listagem de divergencia dos Pedidos de Compra amarrados na")
cDesc2    := OemToAnsi("Nota Fiscal de Importação - D.I.")
cDesc3    := OemToAnsi("")
lContinua := .T.
lImprime1 := .T.
lImprime2 := .T.
aOrd      := {}
aReturn   := { "Especial", 1,"Fiscal", 1, 2, 1, "",1 }
nomeprog  := "CESTG010"
nLastKey  := 0
cPerg     := ""
wnrel     := "CESTG010"
Tabmes    :='JANEIRO  FEVEREIROMARCO    ABRIL    MAIO     JUNHO    JULHO    AGOSTO   SETEMBRO OUTUBRO  NOVEMBRO DEZEMBRO '

wnrel   := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,tamanho)
aDriver := ReadDriver()
If LastKey() == 27 .or. nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)

RptStatus({||Imprimir()})
Return

///////////////////////////////////////////////////////////////////////////////////
Static Function Imprimir()
///////////////////////////////////////////////////////////////////////////////////
Local nX   := 1
Local LIN5 := "PEDIDO/ITEM   CODIGO DO PRODUTO           DESCRICAO...............................    QTDE. D.I  OBSERVACAO                         "
******         xxxxxx/xxxx   x-------------------------x x--------------------------------------x  xxxxxxxx.xx  x---------------------------------x
******                   1         2         3         4         5         6         7         8         9         100       110       120       130       140       150       160       170       180       190       200       210       220       23
******         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*
dbSelectArea("SB1")
dbSetOrder(1)
*
nLin := 99
SetPrc(0,0)
@ 00,000 PSay &(aDriver[3])

SetRegua(Len(aCols))

DO WHILE nX <= Len(aCols)
   IncRegua()
	IF ( !aCols[nX,(Len(aHeader)+1)] .AND. !EMPTY(aCols[nX,18]) )
		IF ( nLin > 61 )
			m_pag := 1
			@ 01,000 PSAY LIN5
			@ 02,000 PSAY repl("=",limite)
			nLin := 2
		ENDIF
		nLin++
		
		@ nLin,000 PSAY aCols[nX,10]+"/"+aCols[nX,11]
		@ nLin,014 PSAY LEFT(aCols[nX,2],27)
		@ nLin,042 PSAY LEFT(aCols[nX,3],40)
		@ nLin,084 PSAY TRANSF(aCols[nX,6],"@E 99999999.99")
		@ nLin,097 PSAY aCols[nX,18]
	ENDIF
   nX++
ENDDO

If aReturn[5] == 1
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return
