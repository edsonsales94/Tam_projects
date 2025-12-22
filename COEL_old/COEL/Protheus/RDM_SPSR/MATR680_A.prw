#INCLUDE "MATR680.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*


Programa   MATR680   Autor  Marco Bianchi          Data  04/07/06 

Descrio  Relacao de Pedidos nao entregues                           

Uso        SIGAFAT - R4                                               


*/
User Function MATR680_A()

Local oReport
PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR680R3()
EndIf

Return

/*

Programa  ReportDef  Autor  Marco Bianchi          Data  04/07/06 

Descrio A funcao estatica ReportDef devera ser criada para todos os 
          relatorios que poderao ser agendados pelo usuario.          
                                                                      

Retorno   ExpO1: Objeto do relatrio                                  

ParametrosNenhum                                                      
                                                                      

   DATA    Programador   Manutencao efetuada                         

*/ 

Static Function ReportDef()

Local oReport
Local oPedNEnt
Local oProduto
Local oCliente
Local oData
Local oVendedor

Local nSaldo	:= 0
Local nValor	:= 0
Local nTotVen	:= 0
Local nTotEnt	:= 0
Local cPerg		:=	IIf(cPaisLoc == "BRA","MTR680","MR680A")
Local nTamData	:= Len(DTOC(MsDate()))


#IFNDEF TOP
	Local cCondicao := ""
	Local cAliasQry := "SC6"
#ELSE
	Local cWhere	:= ""	
	Local cQueryAdd := ""
	Local cAliasQry := GetNextAlias()
#ENDIF

//
//Criacao do componente de impressao                                      
//                                                                        
//TReport():New                                                           
//ExpC1 : Nome do relatorio                                               
//ExpC2 : Titulo                                                          
//ExpC3 : Pergunte                                                        
//ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  
//ExpC5 : Descricao                                                       
//                                                                        
//
oReport := TReport():New("MATR680",STR0027,cPerg, {|oReport| ReportPrint(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData,oVendedor)},STR0028 + " " + STR0029 + " " + STR0030)	// "Relacao de Pedidos nao entregues"###"Este programa ira emitir a relacao dos Pedidos Pendentes,"###"imprimindo o numero do Pedido, Cliente, Data da Entrega, "###"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

//
//Criacao da secao utilizada pelo relatorio                               
//                                                                        
//TRSection():New                                                         
//ExpO1 : Objeto TReport que a secao pertence                             
//ExpC2 : Descricao da seao                                              
//ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   
//        sera considerada como principal para a seo.                   
//ExpA4 : Array com as Ordens do relatrio                                
//ExpL5 : Carrega campos do SX3 como celulas                              
//        Default : False                                                 
//ExpL6 : Carrega ordens do Sindex                                        
//        Default : False                                                 
//                                                                        
//

//
// Por Pedido                                                         	   
//
oPedNEnt := TRSection():New(oReport,STR0041,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oPedNEnt:SetTotalInLine(.F.)
TRCell():New(oPedNEnt,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM						})
TRCell():New(oPedNEnt,"EMISSAO"		,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO					})
TRCell():New(oPedNEnt,"OBSERVACAO"  ,"TRB",RetTitle("C5_CLMSPED"	),PesqPict("SC5","C5_CLMSPED"	),TamSx3("C5_CLMSPED"	)[1],/*lPixel*/,{|| TRB->OBSERVACAO					})
TRCell():New(oPedNEnt,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE					})
TRCell():New(oPedNEnt,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 						})
TRCell():New(oPedNEnt,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI					})
TRCell():New(oPedNEnt,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 						})
TRCell():New(oPedNEnt,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oPedNEnt,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO					})
TRCell():New(oPedNEnt,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO					})

// Quando nome da celular nao e do SX3 e o campo for do tipo Data, o tamanho deve ser preenchido com
// Len(DTOC(MsDate())), para que nao haja problema na utilizacao de ano com 4 digitos.
TRCell():New(oPedNEnt,"DATENTR"	,"TRB"	,RetTitle("C6_ENTREG")	,PesqPict("SC6","C6_ENTREG"	),nTamData				      ,/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oPedNEnt,"NTOTVEN"	,   	,RetTitle("C6_QTDVEN")	,PesqPict("SF2","F2_VALBRUT"),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oPedNEnt,"NTOTENT"	,   	,RetTitle("C6_QTDENT")	,PesqPict("SF2","F2_VALBRUT"),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oPedNEnt,"NSALDO"	,	 	,STR0036				,PesqPict("SF2","F2_VALBRUT"),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oPedNEnt,"NVALOR"	,	  	,STR0037				,PesqPict("SF2","F2_VALBRUT"),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"

	
//
// Por Produto                                                       	   
//
oProduto := TRSection():New(oReport,STR0042,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oProduto,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oProduto,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oProduto,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oProduto,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oProduto,"EMISSAO"		,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oPedNEnt,"OBSERVACAO"  ,"TRB",RetTitle("C5_CLMSPED"	),PesqPict("SC5","C5_CLMSPED"	),TamSx3("C5_CLMSPED"	)[1],/*lPixel*/,{|| TRB->OBSERVACAO					})
TRCell():New(oProduto,"DATENTR"		,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oProduto,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oProduto,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oProduto,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oProduto,"NTOTVEN"		,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oProduto,"NTOTENT"		,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oProduto,"NSALDO"		,	  ,STR0036					 ,PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oProduto,"NVALOR"		,	  ,STR0037					 ,PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"
	
//
// Por Cliente                                                       	   
//
oCliente := TRSection():New(oReport,STR0043,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oCliente:SetTotalInLine(.F.)

TRCell():New(oCliente,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oCliente,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oCliente,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oCliente,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oCliente,"ITEM"	  	,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																			})
TRCell():New(oCliente,"EMISSAO"		,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oPedNEnt,"OBSERVACAO"  ,"TRB",RetTitle("C5_CLMSPED"	),PesqPict("SC5","C5_CLMSPED"	),TamSx3("C5_CLMSPED"	)[1],/*lPixel*/,{|| TRB->OBSERVACAO					})
TRCell():New(oCliente,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oCliente,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oCliente,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oCliente,"DATENTR"		,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oCliente,"NTOTVEN"		,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SF2","F2_VALBRUT"   ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oCliente,"NTOTENT"		,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SF2","F2_VALBRUT"   ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oCliente,"NSALDO"		,	  ,STR0036					 ,PesqPict("SF2","F2_VALBRUT"   ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oCliente,"NVALOR"		,	  ,STR0037					 ,PesqPict("SF2","F2_VALBRUT"   ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"

//
// Por Data de Entrega                                                	   
//
oData := TRSection():New(oReport,STR0044,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oData:SetTotalInLine(.F.)

TRCell():New(oData,"DATENTR"	    ,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oData,"NUM"		    ,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oData,"EMISSAO"	    ,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oPedNEnt,"OBSERVACAO"  ,"TRB",RetTitle("C5_CLMSPED"	),PesqPict("SC5","C5_CLMSPED"	),TamSx3("C5_CLMSPED"	)[1],/*lPixel*/,{|| TRB->OBSERVACAO					})
TRCell():New(oData,"CLIENTE"	    ,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oData,"LOJA"		    ,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oData,"NOMECLI"    	,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oData,"ITEM"		    ,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oData,"PRODUTO1"	    ,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(odata,"PRODUTO2"   	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oData,"DESCRICAO"	    ,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oData,"NTOTVEN"	    ,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(odata,"NTOTENT"	    ,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oData,"NSALDO"		    ,	  ,STR0036					 ,PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oData,"NVALOR"		    ,	  ,STR0037					 ,PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"
	
//
// Por Vendedor                                                       	   
//
oVendedor := TRSection():New(oReport,STR0045,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oVendedor:SetTotalInLine(.F.)

TRCell():New(oVendedor,"VENDEDOR"	,"TRB",RetTitle("C5_VEND1"		),PesqPict("SC5","C5_VEND1"	),TamSx3("C5_VEND1"	)[1],/*lPixel*/,{|| TRB->VENDEDOR																					})
TRCell():New(oVendedor,"NOMEVEN"	,"TRB",RetTitle("A3_NOME"		),PesqPict("SA3","A3_NOME"	),TamSx3("A3_NOME"	)[1],/*lPixel*/,{|| TRB->NOMEVEN																					})
TRCell():New(oVendedor,"NUM"		,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oVendedor,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oVendedor,"EMISSAO"	,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oPedNEnt,"OBSERVACAO"  ,"TRB",RetTitle("C5_CLMSPED"	),PesqPict("SC5","C5_CLMSPED"	),TamSx3("C5_CLMSPED"	)[1],/*lPixel*/,{|| TRB->OBSERVACAO					})
TRCell():New(oVendedor,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oVendedor,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oVendedor,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oVendedor,"DATENTR"	,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oVendedor,"NTOTVEN"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oVendedor,"NTOTENT"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oVendedor,"NSALDO"		,	  ,STR0036					 ,PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oVendedor,"NVALOR"		,	  ,STR0037					 ,PesqPict("SF2","F2_VALBRUT"  ),TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"

oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(4):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(5):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

//
// Verifica as perguntas selecionadas 				    	               
//
AjustaSX1()
Pergunte(oReport:uParam,.F.)

oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(4):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(5):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

Return(oReport)

/*/



Programa  ReportPrin Autor  Marco Bianchi          Data  04/07/06 

Descrio A funcao estatica ReportDef devera ser criada para todos os 
          relatorios que poderao ser agendados pelo usuario.          
                                                                      

Retorno   Nenhum                                                      

ParametrosExpO1: Objeto Report do Relatrio                           
                                                                      

   DATA    Programador   Manutencao efetuada                         

                                                                     



/*/

Static Function ReportPrint(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData,oVendedor)

//
// Define Variaveis   										     
//
Local dData     := CtoD("  /  /  ")
Local cNumPed   := ""
Local cNumCli   := ""
Local nTotVen   := 0
Local nTotEnt   := 0
Local nFirst    := 0
Local nSaldo    := 0
Local nValor    := 0
Local cQuebra	:= ""
Local nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
Local nSection  := oReport:Section(1):GetOrder()
Local oSecao    := oReport:Section(nSection)

Private cNum		:= ""
Private cProduto	:= ""
Private cCli		:= ""
Private dEntreg 	:= CtoD("  /  /  ")
Private cVde    	:= ""    

oSecao:Cell("NSALDO" ):SetBlock({|| nSaldo})
oSecao:Cell("NVALOR" ):SetBlock({|| nValor})
oSecao:Cell("NTOTVEN" ):SetBlock({|| nTotVen})
oSecao:Cell("NTOTENT" ):SetBlock({|| nTotEnt})
nSaldo  := 0
nValor  := 0
nTotVen := 0
nTotEnt := 0

//
// Por Pedido                                                         	   
//
If nSection == 1			// Por Pedido
	cQuebra := "NUM = cNum"
	TRFunction():New(oPedNEnt:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//
// Por Produto                                                       	   
//
ElseIf nSection == 2		// Por Produto
	cQuebra := "PRODUTO = cProduto"
	TRFunction():New(oProduto:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//
// Por Cliente                                                       	   
//
ElseIf nSection == 3		// Por Cliente
	cQuebra := "CLIENTE+LOJA = cCli"
	TRFunction():New(oCliente:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//
// Por Data de Entrega                                                	   
//
ElseIf nSection == 4		// Por Data de Entrega
	cQuebra := "DATENTR = dEntreg"
	TRFunction():New(oData:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NSALDO"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NVALOR"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//
// Por Vendedor                                                       	   
//
Else 
	cQuebra := "VENDEDOR = cVde"
	TRFunction():New(oVendedor:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NSALDO"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NVALOR"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

EndIf

//
// Altera o Titulo do Relatorio de acordo com parametros	 	           
//
oReport:SetTitle(oReport:Title() + " - " + IIF(nSection == 1,STR0031,	;		// "Relacao de Pedidos nao entregues"###"Por Pedido"
								IIF(nSection==2,STR0032,;				// "Por Produto"
								IIF(nSection==3,STR0033,;				// "Por Cliente"
								IIF(nSection==4,STR0034,STR0035))));	// "Por Dt.Entrega"###"Por Vendedor"
								 + " - " + GetMv("MV_MOEDA"+STR(nMoeda,1)))	

//
// Impressao do Cabecalho no top da pagina                                
//
oSecao:SetHeaderPage()

//
// Transforma parametros Range em expressao SQL                           
//
MakeSqlExpr(oReport:uParam)


//
//Metodo TrPosition()                                                     
//                                                                        
//Posiciona em um registro de uma outra tabela. O posicionamento ser     
//realizado antes da impressao de cada linha do relatrio.                
//                                                                        
//                                                                        
//ExpO1 : Objeto Report da Secao                                          
//ExpC2 : Alias da Tabela                                                 
//ExpX3 : Ordem ou NickName de pesquisa                                   
//ExpX4 : String ou Bloco de cdigo para pesquisa. A string ser macroexe-
//        cutada.                                                         
//                                                                        
//
TRPosition():New(oSecao,"SA1",1,{|| xFilial("SA1")+TRB->CLIENTE+TRB->LOJA })
TRPosition():New(oSecao,"SA3",1,{|| xFilial("SA3")+TRB->VENDEDOR })
TRPosition():New(oSecao,"SF4",1,{|| xFilial("SF4")+TRB->TES })
TRPosition():New(oSecao,"SC6",1,{|| xFilial("SC6")+TRB->NUM+TRB->ITEM+TRB->PRODUTO })


//
// Gera Tabela Temporaria para impressao                                  
//
Processa({|| TR680Trab(oReport,cAliasQry,nSection,oSecao)},STR0038)			// "Gerando Tabela de Trabalho. Aguarde..."

//
// Impressao do Relatorio                                                 
//
dbSelectArea("TRB")
dbGoTop()
oReport:SetMeter(RecCount())		// Total de elementos da regua

nFirst := 0
oSecao:Init()
While !oReport:Cancel() .And. !Eof()
	
	//
	// Verifica campo para quebra									 
	//
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//
	// Variaveis Totalizadoras     		    					 
	//
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotVen := QUANTIDADE
	nTotEnt := ENTREGUE
    nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
    
    
	//
	// Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nSection = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
        nValor  := 0
		nReg    := 0
		
		While !Eof() .And. xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	:= Recno()
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
    	    nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			dbSkip()
			oReport:IncMeter()
			
		End
		
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	
	If (nFirst = 0 .And. nSection != 4) .Or. nSection == 4
		
		//
		// Seleicona celulas do cabecalho da linha                      
		//
		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
				
			Case nSection = 2					// Pro Produto
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
 
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
				
			Case nSection = 4					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Hide()
					oSecao:Cell("NUM"		):Hide()
					oSecao:Cell("EMISSAO"	):Hide()
					oSecao:Cell("CLIENTE"	):Hide()
					oSecao:Cell("LOJA"		):Hide()
					oSecao:Cell("NOMECLI"	):Hide()
				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("NUM"		):Show()
					oSecao:Cell("EMISSAO"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NOMECLI"	):Show()
				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR

				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()

			OtherWise	  											// Por Vendedor
				oSecao:Cell("VENDEDOR"	):Show()				
				oSecao:Cell("NOMEVEN"	):Show()				
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
				
		EndCase
		
		IF nFirst = 0 .And. nSection != 4
			nFirst := 1
		Endif
		
	Else

		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("NUM"		):Hide()
				oSecao:Cell("EMISSAO"	):Hide()
				oSecao:Cell("CLIENTE"	):Hide()
				oSecao:Cell("LOJA"		):Hide()
				oSecao:Cell("NOMECLI"	):Hide()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
				
			Case nSection = 2					// Pro Produto
				oSecao:Cell("PRODUTO1"	):Hide()
				oSecao:Cell("PRODUTO2"	):Hide()
				oSecao:Cell("DESCRICAO"	):Hide()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
				
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Hide()
				oSecao:Cell("LOJA"		):Hide()
				oSecao:Cell("NOMECLI"	):Hide()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()
				
			Case nSection = 4					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Hide()
					oSecao:Cell("NUM"		):Hide()
					oSecao:Cell("EMISSAO"	):Hide()
					oSecao:Cell("CLIENTE"	):Hide()
					oSecao:Cell("LOJA"		):Hide()
					oSecao:Cell("NOMECLI"	):Hide()
    				oSecao:Cell("OBSERVACAO"):Show()

				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("NUM"		):Show()
					oSecao:Cell("EMISSAO"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NOMECLI"	):Show()
			    	oSecao:Cell("OBSERVACAO"):Show()

				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR
				
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
			OtherWise												// Por Vendedor
				oSecao:Cell("VENDEDOR"	):Hide()
				oSecao:Cell("NOMEVEN"	):Hide()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("OBSERVACAO"):Show()

		EndCase
	
	EndIf

	If TRB->GRADE=="S" .And. MV_PAR12 == 1
		oSecao:Cell("PRODUTO2"):Disable()
		oSecao:Cell("PRODUTO1"):Enable()
	Else 
		oSecao:Cell("PRODUTO1"):Disable()
		oSecao:Cell("PRODUTO2"):Enable()
	EndIf	

	oSecao:PrintLine()

	dbSelectArea("TRB")
	dbSkip()
	oReport:IncMeter()
	
	//
	// Imprime o Total do Pedido                                    
	//
    If NUM <> cNum
       If   nSection = 3 .Or.	nSection = 4 .Or.	nSection = 1
			oSecao:SetTotalText(STR0031 + " " + cNum)
			oSecao:Finish()
			oSecao:Init()
       EndIf
    EndIf
    
	//
	// Imprime o Total ou linha divisora conforme a quebra		     
	//
	If !&cQuebra
			
		nTotVen := 0
		nTotEnt := 0
		nFirst  := 0   

		oSecao:SetTotalText(IIF(nSection == 1,STR0031 + " " + cNum,	;	// "Total do Pedido"
								IIF(nSection==2,STR0032 + " " + cProduto,;					// "Total do Produto"
								IIF(nSection==3,STR0033 + " " + cCli,;					// "Total do Cliente"
								IIF(nSection==4,STR0034 + " " + DTOC(dEntreg),STR0035  + " " + cVde)))))		// "Total da Dt.Entrega"###"Total do Vendedor"
		
		// Finaliza Secao
		If nSection <> 3 .And. nSection <> 4 .And. nSection <> 1
			oSecao:Finish()
			oSecao:Init()
		EndIf
			
		If mv_par15 == 1 .And. !Eof()
			// Forca salto de pagina no fim da secao
			oReport:nrow := 5000			
			oReport:skipLine()
		EndIf
		
		
	Endif
	
	dbSelectArea("TRB")
	
End

//
// Finaliza Relatorio                                           
//
oSecao:SetPageBreak()

//
// Fecha tabela de trabalho                                     
//
dbSelectArea("TRB")
dbCloseArea()

//
// Restaura Tabelas                                             
//
#IFDEF TOP
	dbSelectArea(cAliasQry)
	dbClosearea()
	dbSelectArea("SC6")
	dbSetOrder(1)
#ELSE
	dbSelectArea("SC6")
	RetIndex("SC6")
	dbSetOrder(1)	
#ENDIF


Return



/*/



Funo	 TR680Trab  Autor  Marco Bianchi          Data  05/07/06 

Descrio  Cria Arquivo de Trabalho                             	  

 Uso		  MATR680													  



/*/

Static Function TR680Trab(oReport,cAliasQry,nSection,oSecao)

//
// Define Variaveis                                             
//
Local aCampos   := {}
Local aTam      := ""
Local cVend     := ""
Local cVendedor := ""
Local nTipVal   := IIF(cPaisLoc == "BRA",MV_PAR19,MV_PAR20)
Local nSaldo    := 0
Local nX        := 0
Local nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
Local nValor	:= 0 
#IFNDEF TOP
	Local cFilTrab  := ""
#ENDIF
cFilSA1        := ""
cFilSA3        := ""
cFilSF4        := ""


//
// Define array para arquivo de trabalho                        
//
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_CLMSPED")
AADD(aCampos,{ "OBSERVACAO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )

//
// Cria arquivo de Trabalho                                     
//
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

dbSelectArea("TRB")
Do Case
	Case nSection = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0040)       //"Selecionando Registros..."
	Case nSection = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0040)       //"Selecionando Registros..."
	Case nSection = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0040)  //"Selecionando Registros..."
	Case nSection = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,STR0040) //"Selecionando Registros..."
	Case nSection = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0040)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//
// Verifica o Filtro                                            
//
dbSelectArea("SC6")
dbSetOrder(1)

#IFDEF TOP
	
	
	aStruSC6  := SC6->(dbStruct())
	cWhere := "%" 
	If mv_par13 == 3
		cWhere += "AND C6_BLQ = 'R '"
	Endif	
	cWhere += "%" 

	//
	//Ponto de entrada para tratamento do filtro do usuario.
	//
	If ExistBlock("F680QRY")
		cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
		If ValType(cQueryAdd) == "C"
			cWhere += " AND ( " + cQueryAdd + ")"
		EndIf
	EndIf

	oSecao:BeginQuery()
	BeginSql Alias cAliasQry
	SELECT SC6.* 
	FROM %Table:SC6% SC6
	WHERE C6_FILIAL = %xFilial:SC6%
		AND C6_NUM >= %Exp:mv_par01% AND C6_NUM <= %Exp:mv_par02%
		AND C6_PRODUTO >= %Exp:mv_par03% AND C6_PRODUTO <= %Exp:mv_par04%
		AND C6_CLI >= %Exp:mv_par05% AND C6_CLI <= %Exp:mv_par06%
		AND C6_ENTREG >= %Exp:DtoS(mv_par07)% AND C6_ENTREG <= %Exp:DtoS(mv_par08)%
        AND SC6.%notdel%
        %Exp:cWhere%
	ORDER BY C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO
	EndSql
	oSecao:EndQuery()
	
#ELSE
	
	cFilTrab   := CriaTrab("",.F.)
	cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
	cCondicao  += "C6_NUM>='"+MV_PAR01+"'.And.C6_NUM<='"+MV_PAR02+"'.And."
	cCondicao  += "C6_PRODUTO>='"+MV_PAR03+"'.And.C6_PRODUTO<='"+MV_PAR04+"'.And."
	cCondicao  += "C6_CLI>='"+MV_PAR05+"'.And.C6_CLI<='"+MV_PAR06+"'.And."
	cCondicao  += "Dtos(C6_ENTREG)>='"+Dtos(MV_PAR07)+"'.And.Dtos(C6_ENTREG)<='"+Dtos(MV_PAR08)+"'"
	If mv_par13 == 3
		cCondicao += " .And. C6_BLQ == 'R ' "
	Endif	
	
	dbSelectArea(cAliasQry)
	dbSetOrder(1)
	IndRegua("SC6",cFilTrab,IndexKey(),,cCondicao)
	dbGoTop()
	
#ENDIF
       

If len(oSecao:GetAdvplExp("SA1")) > 0
	cFilSA1 := oSecao:GetAdvplExp("SA1")
EndIf
If len(oSecao:GetAdvplExp("SA3")) > 0
	cFilSA3 := oSecao:GetAdvplExp("SA3")
EndIf
If len(oSecao:GetAdvplExp("SF4")) > 0
	cFilSF4 := oSecao:GetAdvplExp("SF4")
EndIf

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter(RecCount())     // Total de Elementos da Regua
While !oReport:Cancel() .And. !Eof() .And. (cAliasQry)->C6_FILIAL == xFilial("SC6")
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial()+ (cAliasQry)->C6_CLI + (cAliasQry)->C6_LOJA )
   
	// Verifica filtro do usuario
	If !Empty(cFilSA1) .And. !(&cFilSA1)
		dbSelectArea(cAliasQry)	
   	dbSkip()
	   Loop
	EndIf	

	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek( xFilial(("SF4"))+(cAliasQry)->C6_TES )

	// Verifica filtro do usuario	
	If !Empty(cFilSF4) .And. !(&cFilSF4)
		dbSelectArea(cAliasQry)	
   	dbSkip()
	   Loop
	EndIf	
	
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek( xFilial(("SC5"))+(cAliasQry)->C6_NUM )
	
	dbSelectArea(cAliasQry)
	If cPaisLoc <> "BRA"
		If ( SF4->F4_ESTOQUE == "S" .And. mv_par18 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par18 == 1 )
			dbSkip()
			Loop
		Endif
		If mv_par19 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
			If (mv_par19 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;		// Gera nota
				(mv_par19 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;		// Gera REMITO
				(mv_par19 == 3 .And. SC5->C5_DOCGER <> '3' ) 			// Entrega futura
				dbSkip()
				Loop
			Endif
		Endif
	Endif
	//
	// Verifica se esta dentro dos parametros						 
	//
	lRet:=ValidMasc((cAliasQry)->C6_PRODUTO,MV_PAR11)
	If Alltrim((cAliasQry)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
		nSaldo  := 0
	Else
		nSaldo  := C6_QTDVEN-C6_QTDENT
	Endif
	
	If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR09 == 1) .Or. (MV_PAR09 == 2)).And.;
		((nSaldo == 0 .And. MV_PAR14 == 1.And.Alltrim((cAliasQry)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
		((SF4->F4_DUPLIC == "S" .And. MV_PAR10 == 1) .Or. (SF4->F4_DUPLIC == "N";
		.And. MV_PAR10 == 2).Or.(MV_PAR10 == 3));
		.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
		
		If nSection = 5		// Por Vendedor
			
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				If !EMPTY(cVendedor) .And. (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial()+cVendedor)

					// Verifica filtro do usuario					
					If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
					
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
					
						Replace VENDEDOR   With cVendedor
						Replace NOMEVEN    With SA3->A3_NOME
						Replace FILIAL     With (cAliasQry)->C6_FILIAL
						Replace NUM        With (cAliasQry)->C6_NUM
						Replace EMISSAO    With SC5->C5_EMISSAO
						Replace CLIENTE    With (cAliasQry)->C6_CLI
						Replace NOMECLI    With SA1->A1_NOME
						Replace LOJA       With (cAliasQry)->C6_LOJA
						Replace DATENTR    With (cAliasQry)->C6_ENTREG
						Replace ITEM       With (cAliasQry)->C6_ITEM
						Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
						Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
						Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
						Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
						Replace GRADE      With (cAliasQry)->C6_GRADE
						Replace ITEMGRD    With (cAliasQry)->C6_ITEMGRD
						Replace TES        With (cAliasQry)->C6_TES
						Replace BLQ        With (cAliasQry)->C6_BLQ
						Replace BLOQUEI    With (cAliasQry)->C6_BLOQUEI
						Replace OBSERVACAO With SC5->C5_CLMSPED
											
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasQry)->C6_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasQry)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						Replace VALOR      With nValor
						Replace MOEDA      With SC5->C5_MOEDA
					
						MsUnLock()
					
					EndIf
					
				Endif
				
				cVend := Soma1(cVend,1)
				dbSelectArea("SC5")
				dbSetOrder(1)
			Next nX
			
		Else
			
			lVend := .F.
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				
				dbSelectArea("SA3")
				dbSetOrder(1)
				dbSeek( xFilial()+cVendedor)
				
				// Verifica filtro do usuario					
				If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
					If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						lVend :=.T.
						Exit
					Endif
				Endif
				cVend := Soma1(cVend,1)
			Next nX


			If lVend
				
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				
				Replace FILIAL     With (cAliasQry)->C6_FILIAL
				Replace NUM        With (cAliasQry)->C6_NUM
				Replace EMISSAO    With SC5->C5_EMISSAO
				Replace CLIENTE    With (cAliasQry)->C6_CLI
				Replace NOMECLI    With SA1->A1_NOME
				Replace LOJA       With (cAliasQry)->C6_LOJA
				Replace DATENTR    With (cAliasQry)->C6_ENTREG
				Replace ITEM       With (cAliasQry)->C6_ITEM
				Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
				Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
				Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
				Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
				Replace GRADE      With (cAliasQry)->C6_GRADE
				Replace ITEMGRD    With (cAliasQry)->C6_ITEMGRD
				Replace TES        With (cAliasQry)->C6_TES
				Replace BLQ        With (cAliasQry)->C6_BLQ
				Replace BLOQUEI    With (cAliasQry)->C6_BLOQUEI      
				Replace OBSERVACAO With SC5->C5_CLMSPED
				
				If nTipVal == 1 //--  Imprime Valor Total do Item
					nValor:=(cAliasQry)->C6_VALOR
				Else
					//--  Imprime Saldo
					If TRB->QUANTIDADE==0
						nValor:=(cAliasQry)->C6_VALOR
					Else
						nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->C6_PRCVEN
						nValor := If(nValor<0,0,nValor)
					EndIf
				EndIf
				Replace VALOR      With nValor
				Replace MOEDA      With SC5->C5_MOEDA
				
				lVend := .F.
				MsUnLock()
			Endif
		Endif
	Endif
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
	
EndDo
#IFNDEF TOP
	dbSelectArea(cAliasQry)
	RetIndex(cAliasQry)
	FErase(cFilTrab+OrdBagExt())
#ENDIF


Return



/*/



Funo	  MATR680R3 Autor  Alexandre Inacio Lemes Data  15.03.01 

Descrio  Relacao de Pedidos nao entregues							  

 Uso		  Generico 												  

 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					  

 PROGRAMADOR   DATA    BOPS 	MOTIVO DA ALTERACAO					  



/*/
Static Function Matr680R3()

LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL cDesc1    := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2    := OemToAnsi(STR0003)	//"imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3    := OemToAnsi(STR0004)	//"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString   := "SC6"
LOCAL tamanho   := "G"
LOCAL wnrel     := "MATR680"

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE nomeprog:= "MATR680"
PRIVATE cPerg	 :=	IIf(cPaisLoc == "BRA","MTR680","MR680A")
PRIVATE cArqTrab:= ""
PRIVATE cFilTrab:= ""
PRIVATE nLastKey:= 0

//
// Verifica as perguntas selecionadas 				    	     
//
AjustaSX1()
pergunte(cPerg,.F.)
//
// Variaveis utilizadas para parametros		    			 
// mv_par01				// Do Pedido	                     
// mv_par02				// Ate o Pedido	                     
// mv_par03				// Do Produto				         
// mv_par04				// Ate o Produto					 
// mv_par05				// Do Cliente						 
// mv_par06				// Ate o cliente					 
// mv_par07				// Da data de entrega	    		 
// mv_par08				// Ate a data de entrega			 
// mv_par09				// Em Aberto , Todos 				 
// mv_par10				// C/Fatur.,S/Fatur.,Todos 			 
// mv_par11				// Mascara							 
// mv_par12				// Aglutina itens grade 			 
// mv_par13				// Considera Residuos (Sim/Nao)		 
// mv_par14				// Lista Tot.Faturados(Sim/Nao)		 
// mv_par15				// Salta pagina na Quebra(Sim/Nao)	     
// mv_par16				// Do vendedor                 		 
// mv_par17				// Ate o vendedor                    |
// mv_par18				// Qual a moeda                      |
// As proximas pertencem ao grupo MR680A que eh so para         |
// Localizacoes...                                     	     
// mv_par18				// Movimenta stock    (Sim/Nao)	     
// mv_par19		 // Gen. Doc (Factura/Remito/Ent. Fut/Todos) 
//
//
// Envia controle para a funcao SETPRINT 					     
//| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
//
aOrd :={STR0007,STR0008,STR0009,STR0010,STR0022}
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/



Funo	  C680IMP	 Autor  Alexandre Incaio Lemes Data  15.03.01 

Descrio  Chamada do Relatorio 									  

 Uso		  MATR680													  



/*/
Static Function C680Imp(lEnd,WnRel,cString)

//
// Define Variaveis   										     
//
LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL dData     := CtoD("  /  /  ")
LOCAL cTotPed   := "NUM = cNum"
LOCAL CbTxt     := ""
LOCAL cabec1    := ""
LOCAL cabec2    := ""
LOCAL tamanho   := "G"
LOCAL cNumPed   := ""
LOCAL cNumCli   := ""
LOCAL limite    := 220
LOCAL CbCont    := 0
LOCAL nOrdem    := 0
LOCAL nTotVen   := 0
LOCAL nTotEnt   := 0
LOCAL nTotSal   := 0
LOCAL nTotItem  := 0
LOCAL nFirst    := 0
LOCAL nSaldo    := 0
LOCAL nValor    := 0
LOCAL nCont     := 0
LOCAL lImpTot   := .F.
LOCAL lContinua := .T.
LOCAL nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTIGeral  := 0

//
// Variaveis utilizadas para Impressao do Cabecalho e Rodape	 
//
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

Do Case
	Case nOrdem = 1
		cQuebra := "NUM = cNum"
		titulo  := titulo +" - "+ STR0007 //"Por Pedido"
		cabec1  := "NUMERO  DATA DE   CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                    DATA DE        QUANTIDADE   QUANTIDADE      VALOR TOTAL   OBSERVACAO"
		cabec2  := "PEDIDO  EMISSAO                                                         PRODUTO         MATERIAL                        ENTREGA        PEDIDA       PENDENTE        DO ITEM.                "    
	Case nOrdem = 2
		cQuebra := "PRODUTO = cProduto"
		titulo  := titulo + " - "+STR0008 //"Por Produto"
		cabec1  := STR0013 //"CODIGO DO       DESCRICAO DO                   NUMERO IT DATA DE      DATA DE      CODIGO LOJA /NOME DO CLIENTE                        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0014 //"PRODUTO         MATERIAL                       PEDIDO    EMISSAO      ENTREGA                                                          PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
	Case nOrdem = 3
		cQuebra := "CLIENTE+LOJA = cCli"
		titulo  := titulo + " - "+STR0009 //"Por Cliente"
		cabec1  := STR0016 //"CODIGO-LOJA/NOME DO CLIENTE                        NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE      QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0017 //"                                                   PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA      PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
	Case nOrdem = 4
		cQuebra := "DATENTR = dEntreg"
		titulo  := titulo + STR0018 //" - Por Data de Entrega"
		cabec1  := STR0019 //" DATA DE      NUMERO DATA DE      CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0020 //" ENTREGA      PEDIDO EMISSAO                                                            PRODUTO         MATERIAL                       PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
		
	Case nOrdem = 5
		cQuebra := "VENDEDOR = cVde"
		titulo  := titulo + STR0022 //" - Por Vendedor"
		cabec1  := STR0023 //"CODIGO VENDEDOR                                 NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0024 //"                                                PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
EndCase

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "
dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst := 0

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58 .Or.( MV_PAR15 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	//
	// Verifica campo para quebra									 
	//
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//
	// Variaveis Totalizadoras     		    					 
	//
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotSal += nSaldo
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE
    nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
    
	If !(TRB->GRADE == "S" .And. MV_PAR12 == 1)
       nTotItem+= nValor
       nTIGeral+= nValor
    EndIf	
    
	If nTotVen > QUANTIDADE .Or. nTotEnt > ENTREGUE
		lImpTot := .T.
	Else
		lImpTot := .F.
	EndIf
	
	IF (nFirst = 0 .And. nOrdem != 4).Or. nOrdem == 4
		
		li++
		
		//
		// Imprime o cabecalho da linha		    					 
		//
		Do Case
			Case nOrdem = 1
				@li,  0 Psay NUM
				@li,  7 Psay TRB->EMISSAO
				@li, 19 Psay Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 50)   
				@li, 177 PSAY TRB->OBSERVACAO
			Case nOrdem = 2
				@li,  0 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
				@li, 16 Psay Left(TRB->DESCRICAO, 30)  
				@li, 177 PSAY TRB->OBSERVACAO
			Case nOrdem = 3
				@li,  0 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)
				@li, 177 PSAY TRB->OBSERVACAO
			Case nOrdem = 4
				If cNumPed+cNumCli+DtoS(dData) != NUM+CLIENTE+DtoS(DATENTR)
					@li,  1 Psay DATENTR
					@li, 14 Psay NUM
					@li, 21 Psay EMISSAO
					@li, 34 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)
					cNumPed := NUM
					cNumCli := CLIENTE       
			 	    @li, 177 PSAY TRB->OBSERVACAO					
				Else
					li--
				EndIf
				dData := DATENTR
			Case nOrdem = 5
				@li,  0 Psay Left(TRB->VENDEDOR+" "+NOMEVEN, 47)
		EndCase
		
		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	//
	// Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nOrdem = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
        nValor  := 0
		nReg    := 0
		
		While !Eof() .And.xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	 := Recno()
			
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
    	    nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			IncRegua()
			dbSkip()
			
			lImpTot := .T.
			
		End
		
		nTotSal += nSaldo
        nTotItem+= nValor
		nTIGeral+= nValor
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	//
	// Imprime a linha Conforme a ordem selecionada na setprint	 
	//
	Do Case
		Case nOrdem = 1
			@li, 69 Psay ITEM
			@li, 72 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 88 Psay Left(TRB->DESCRICAO, 30)
			@li,119 Psay DATENTR
		Case nOrdem = 2
			@li, 47 Psay NUM
			@li, 54 Psay ITEM
			@li, 57 Psay EMISSAO
			@li, 70 Psay DATENTR
			@li, 83 Psay Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,50)
		Case nOrdem = 3
			@li, 51 Psay NUM
			@li, 58 Psay ITEM
			@li, 61 Psay EMISSAO
			@li, 74 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 91 Psay Left(TRB->DESCRICAO,30)
			@li,122 Psay DATENTR
		Case nOrdem = 4
			@li, 85 Psay ITEM
			@li, 88 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamRef),PRODUTO)
			@li,104 Psay Left(TRB->DESCRICAO, 30)
		OtherWise
			@li, 48 Psay NUM
			@li, 55 Psay ITEM
			@li, 59 Psay EMISSAO
			@li, 72 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 88 Psay Left(TRB->DESCRICAO,30)
			@li,119 Psay DATENTR
	EndCase
	
	@li,136 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE)	PICTURE PesqPictQt("C6_QTDVEN",12)
//	@li,149 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE)	PICTURE PesqPictQt("C6_QTDENT",12)
	@li,149 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li,162 Psay nValor	PICTURE PesqPict("SC6","C6_VALOR",12)
	
	nCont++
	li++
	
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()
	
	//
	// Imprime o Total do Pedido                                    
	//
    If !&cTotPed
       If nOrdem = 1 .Or. nOrdem = 3 .Or.  nOrdem = 4 .Or. (nOrdem == 5 .And. !&cQuebra)
           @Li,000 Psay STR0025
           @Li,158 Psay nTotItem PICTURE PesqPict("SF2","F2_VALBRUT",16)
           If nOrdem = 3 
              li+=2
           Else
              li++
           ENdif
	       nTotitem:= 0	
       EndIf
    EndIf
	//
	// Imprime o Total ou linha divisora conforme a quebra		     
	//
	If !&cQuebra
		
		If (MV_PAR15 = 1 .And. nOrdem = 2) .Or. MV_PAR15 = 2
			
			If nOrdem = 2
				@Li,000 Psay STR0025
				@Li,130 Psay nTotVen PICTURE PesqPict("SF2","F2_VALBRUT")
				@Li,146 Psay nTotEnt PICTURE PesqPict("SF2","F2_VALBRUT")
				@Li,162 Psay nTotSal PICTURE PesqPict("SF2","F2_VALBRUT")
				li++
			Endif
			
			If nTotVen > 0 .And. nOrdem != 1
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif

		nTVGeral += nTotVen
		nTEGeral += nTotEnt
		nTSGeral += nTotSal
				
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nCont   := 0
		nFirst  := 0
		
	Endif
	
End

If nTIGeral > 0        
	If li >= 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	li++
	@Li,000 Psay STR0026
	@Li,130 Psay nTVGeral PICTURE PesqPict("SF2","F2_VALBRUT")
	@Li,145 Psay nTEGeral PICTURE PesqPict("SF2","F2_VALBRUT")
//	@Li,149 Psay nTSGeral PICTURE PesqPict("SF2","F2_VALBRUT")
	@Li,160 Psay nTIGeral PICTURE PesqPict("SF2","F2_VALBRUT",16)
EndIf

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("TRB")
dbCloseArea()

//
// Deleta arquivos de trabalho.                      
//
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/



Funo	  C680TRB	 Autor  Alexandre Inacio Lemes Data  15.03.01 

Descrio  Cria Arquivo de Trabalho                             	  

 Uso		  MATR660													  



/*/

Static Function C680TRB(nOrdem)

//
// Define Variaveis                                             
//
LOCAL aCampos   := {}
LOCAL aTam      := ""
LOCAL cKey      := ""
LOCAL cCondicao := ""
LOCAL cVend     := ""
LOCAL cVendedor := ""
LOCAL cAliasSC6 := "SC6"
LOCAL cPedIni   := MV_PAR01
LOCAL cPedFim   := MV_PAR02
LOCAL cProIni   := MV_PAR03
LOCAL cProFim   := MV_PAR04
LOCAL cCliIni   := MV_PAR05
LOCAL cCliFim   := MV_PAR06
LOCAL cDatIni   := MV_PAR07
LOCAL cDatFim   := MV_PAR08
LOCAL nTipVal   := IIF(cPaisLoc == "BRA",MV_PAR19,MV_PAR20)
LOCAL nSaldo    := 0
LOCAL nX        := 0
LOCAL nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
LOCAL nValor	:= 0
LOCAL cQueryAdd := ""

//
// Define array para arquivo de trabalho                        
//
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )          
aTam:=TamSX3("C5_CLMSPED")
AADD(aCampos,{ "OBSERVACAO"   ,"C",aTam[1],aTam[2] } )

//
// Cria arquivo de Trabalho                                     
//
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]

dbSelectArea("TRB")
Do Case
	Case nOrdem = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0015)  //"Selecionando Registros..."
	Case nOrdem = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,STR0015) //"Selecionando Registros..."
	Case nOrdem = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0015)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//
// Verifica o Filtro                                            
//
dbSelectArea("SC6")
dbSetOrder(1)

#IFDEF TOP
	
	cAliasSC6 := "MR680Trab"
	aStruSC6  := SC6->(dbStruct())
	cQuery    := "SELECT * "
	cQuery += "FROM "+RetSqlName("SC6")+" "
	cQuery += "WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cQuery += "C6_NUM >= '"+cPedIni+"' AND "
	cQuery += "C6_NUM <= '"+cPedFim+"' AND "
	cQuery += "C6_PRODUTO >= '"+cProIni+"' AND "
	cQuery += "C6_PRODUTO <= '"+cProFim+"' AND "
	cQuery += "C6_CLI >= '"+cCliIni+"' AND "
	cQuery += "C6_CLI <= '"+cCliFim+"' AND "
	cQuery += "C6_ENTREG >= '"+Dtos(cDatIni)+"' AND "
	cQuery += "C6_ENTREG <= '"+Dtos(cDatFim)+"' AND  "
	
	If mv_par13 == 3
		cQuery += "C6_BLQ = 'R ' AND "
	Endif	
	
	cQuery += "D_E_L_E_T_ = ' ' "

	//
	//Ponto de entrada para tratamento do filtro do usuario.
	//
	If ExistBlock("F680QRY")
		cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
		If ValType(cQueryAdd) == "C"
			cQuery += " AND ( " + cQueryAdd + ")"
		EndIf
	EndIf
	
	cQuery += "ORDER BY "+SqlOrder(IndexKey())
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)
	
	For nX := 1 To Len(aStruSC6)
		If ( aStruSC6[nX][2] <> "C" )
			TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
		EndIf
	Next nX
	
	dbSelectArea(cAliasSC6)
	
#ELSE
	
	cFilTrab   := CriaTrab("",.F.)
	cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
	cCondicao  += "C6_NUM>='"+MV_PAR01+"'.And.C6_NUM<='"+MV_PAR02+"'.And."
	cCondicao  += "C6_PRODUTO>='"+MV_PAR03+"'.And.C6_PRODUTO<='"+MV_PAR04+"'.And."
	cCondicao  += "C6_CLI>='"+MV_PAR05+"'.And.C6_CLI<='"+MV_PAR06+"'.And."
	cCondicao  += "Dtos(C6_ENTREG)>='"+Dtos(MV_PAR07)+"'.And.Dtos(C6_ENTREG)<='"+Dtos(MV_PAR08)+"'"
	If mv_par13 == 3
		cCondicao += " .And. C6_BLQ == 'R ' "
	Endif	
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	IndRegua("SC6",cFilTrab,IndexKey(),,cCondicao,STR0015)    // "Selecionando Registros..."
	dbGoTop()
	
#ENDIF

ProcRegua(RecCount())                                         // Total de Elementos da Regua

While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6")
	
	If ( Empty(aReturn[7]) .Or. &(aReturn[7]) )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial()+ (cAliasSC6)->C6_CLI + (cAliasSC6)->C6_LOJA )
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek( xFilial(("SF4"))+(cAliasSC6)->C6_TES )
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial(("SC5"))+(cAliasSC6)->C6_NUM )
		
		dbSelectArea(cAliasSC6)
		
		If cPaisLoc <> "BRA"
			If ( SF4->F4_ESTOQUE == "S" .And. mv_par18 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par18 == 1 )
				dbSkip()
				Loop
			Endif
			If mv_par19 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
				If (mv_par19 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;//Gera nota
					(mv_par19 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;//Gera REMITO
					(mv_par19 == 3 .And. SC5->C5_DOCGER <> '3' ) //Entrega futura
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		//
		// Verifica se esta dentro dos parametros						 
		//
		lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,MV_PAR11)
		
		If Alltrim((cAliasSC6)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := C6_QTDVEN-C6_QTDENT
		Endif
		
		If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR09 == 1) .Or. (MV_PAR09 == 2)).And.;
			((nSaldo == 0 .And. MV_PAR14 == 1.And.Alltrim((cAliasSC6)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
			((SF4->F4_DUPLIC == "S" .And. MV_PAR10 == 1) .Or. (SF4->F4_DUPLIC == "N";
			.And. MV_PAR10 == 2).Or.(MV_PAR10 == 3));
			.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
			
			If nOrdem = 5
				
				cVend := "1"
				
				For nX := 1 to nQtdVend
					
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					
					If !EMPTY(cVendedor) .And. (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						
						dbSelectArea("SA3")
						dbSetOrder(1)
						dbSeek( xFilial()+cVendedor)
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						REPLACE VENDEDOR   WITH cVendedor
						REPLACE NOMEVEN    WITH SA3->A3_NOME
						REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
						REPLACE NUM        WITH (cAliasSC6)->C6_NUM
						REPLACE EMISSAO    WITH SC5->C5_EMISSAO
						REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
						REPLACE NOMECLI    WITH SA1->A1_NOME
						REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
						REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
						REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
						REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
						REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
						REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
						REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
						REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
						REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
						REPLACE TES        WITH (cAliasSC6)->C6_TES
						REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
						REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI        
						REPLACE OBSERVACAO WITH SC5->C5_CLMSPED
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasSC6)->C6_VALOR						
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasSC6)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf							
						REPLACE VALOR      WITH nValor
						REPLACE MOEDA      WITH SC5->C5_MOEDA
						
						MsUnLock()
						
					Endif
					
					cVend := Soma1(cVend,1)
					
					dbSelectArea("SC5")
					dbSetOrder(1)
					
				Next nX
				
			Else
				
				lVend := .F.
				cVend := "1"
				
				For nX := 1 to nQtdVend
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						lVend :=.T.
						Exit
					Endif
					cVend := Soma1(cVend,1)
				Next nX
				
				If lVend
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
					REPLACE NUM        WITH (cAliasSC6)->C6_NUM
					REPLACE EMISSAO    WITH SC5->C5_EMISSAO
					REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
					REPLACE NOMECLI    WITH SA1->A1_NOME
					REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
					REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
					REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
					REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
					REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
					REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
					REPLACE TES        WITH (cAliasSC6)->C6_TES
					REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
					REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
					REPLACE OBSERVACAO WITH SC5->C5_CLMSPED
					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->C6_VALOR						
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf						
					REPLACE VALOR      WITH nValor
					REPLACE MOEDA      WITH SC5->C5_MOEDA
					
					lVend := .F.
					
					MsUnLock()
					
				Endif
				
			Endif
			
		Endif
		
	Endif
	
	dbSelectArea(cAliasSC6)
	IncProc()
	dbSkip()
	
End

#IFDEF TOP
	dbSelectArea(cAliasSC6)
	dbClosearea()
	dbSelectArea("SC6")
#ELSE
	dbSelectArea("SC6")
	RetIndex("SC6")
#ENDIF

/*



Funo     AjustaSX1    Autor   Paulo Eduardo       Data 17.03.03 

Descrio  Ajusta perguntas do SX1                                    



*/
Static Function AjustaSX1()
LOCAL cKey     := ""
LOCAL aHelpPor := {}
LOCAL aHelpEng := {}
LOCAL aHelpSpa := {}

If cPaisLoc <> "BRA"

	If SX1->(DbSeek("MTR68007"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PERSPA With "De Fecha Entrega ?"
		Replace SX1->X1_PERENG With "From Delivery Date ?"
		SX1->(MsUnLock())
		SX1->(DbCommit())
	Endif

	If SX1->(DbSeek("MR680A07"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PERSPA With "De Fecha Entrega ?"
		Replace SX1->X1_PERENG With "From Delivery Date ?"
		SX1->(MsUnLock())
		SX1->(DbCommit())
	Endif

	dbSelectArea("SX1")
	If MsSeek("MR680A13")
		If Empty(SX1->X1_DEF03) .Or. Empty(SX1->X1_DEFSPA3) .Or. Empty(SX1->X1_DEFENG3)
			RecLock("SX1",.F.)
			SX1->X1_DEF03   := "Somente"
			SX1->X1_DEFSPA3 := "Solamente"
			SX1->X1_DEFENG3 := "Only"
			MsUnlock()
		Endif
	Endif

	PutSx1("MR680A","20","Imprime             ","Imprime             ","Print               ","mv_chl","N",1,0,1,"C","","","","","mv_par20",;
	"Valor Total","Valor Total","Total Value","",;
	"Saldo","Saldo","Balance")	
	
	If MsSeek("MR680A")
		While !(EOF()) .and. SX1->X1_GRUPO == "MR680A"
			cKey := "P." + SX1->X1_GRUPO + SX1->X1_ORDEM + "."
			If SX1->X1_ORDEM < "18"
				If Empty(SX1->X1_HELP)
					RecLock("SX1",.F.)
					SX1->X1_HELP := ".MTR680" + SX1->X1_ORDEM + "."
					MsUnlock()
				EndIf
			Else
				If SX1->X1_ORDEM == "18"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe se o TES gera movimentacao")
					aAdd(aHelpPor,"no estoque")
					aAdd(aHelpSpa,"Informe si el TES genera movimiento")
					aAdd(aHelpSpa,"en el stock.")
					aAdd(aHelpEng,"Inform whether TIO generates stock")
					aAdd(aHelpEng,"movement.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				ElseIf SX1->X1_ORDEM == "19"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe o tipo de documento a ser")
					aAdd(aHelpPor,"gerado.")
					aAdd(aHelpSpa,"Informe el tipo de documento que se")
					aAdd(aHelpSpa,"generara.")
					aAdd(aHelpEng,"Inform the document type to be")
					aAdd(aHelpEng,"generated.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				ElseIf SX1->X1_ORDEM == "20"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe qual valor sera impresso")
					aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
					aAdd(aHelpSpa,"Informe que valor se imprimira")
					aAdd(aHelpSpa,"en el campo 'VALOR TOTAL'")
					aAdd(aHelpEng,"Enter the value to be printed")
					aAdd(aHelpEng,"in 'TOTAL VALUE' field.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)										
				EndIf
			EndIf
			DbSkip()
		EndDo
	EndIf	
Else
	dbSelectArea("SX1")
	If MsSeek("MTR68009")
		If Empty(SX1->X1_DEF02) .Or. Empty(SX1->X1_DEFSPA2) .Or. Empty(SX1->X1_DEFENG2)
			RecLock("SX1",.F.)
			SX1->X1_DEF02   := "Todos"
			SX1->X1_DEFSPA2 := "Todos"
			SX1->X1_DEFENG2 := "All"
			MsUnlock()
		Endif
	Endif

	dbSelectArea("SX1")
	If MsSeek("MTR68013")
		If Empty(SX1->X1_DEF03) .Or. Empty(SX1->X1_DEFSPA3) .Or. Empty(SX1->X1_DEFENG3)
			RecLock("SX1",.F.)
			SX1->X1_DEF03   := "Somente"
			SX1->X1_DEFSPA3 := "Solamente"
			SX1->X1_DEFENG3 := "Only"
			MsUnlock()
		Endif
	Endif

	dbSelectArea("SX1")
	If MsSeek("MTR68019")
		If Empty(SX1->X1_DEF01) .Or. Empty(SX1->X1_DEFSPA1) .Or. Empty(SX1->X1_DEFENG1) .Or.;
			Empty(SX1->X1_DEF02) .Or. Empty(SX1->X1_DEFSPA2) .Or. Empty(SX1->X1_DEFENG2)
			RecLock("SX1",.F.)
			SX1->X1_DEF01   := "Valor Total"
			SX1->X1_DEFSPA1 := "Valor Total"
			SX1->X1_DEFENG1 := "Total Value"
			SX1->X1_DEF02   := "Saldo"
			SX1->X1_DEFSPA2 := "Saldo"
			SX1->X1_DEFENG2 := "Balance"
			MsUnlock()
		Endif
	Else
		PutSx1("MTR680","19","Imprime             ","Imprime             ","Print               ","mv_chj","N",1,0,1,"C","","","","","mv_par19",;
		"Valor Total","Valor Total","Total Value","",;
		"Saldo","Saldo","Balance")	
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe qual valor sera impresso")
		aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
		aAdd(aHelpSpa,"Informe que valor se imprimira")
		aAdd(aHelpSpa,"en el campo 'VALOR TOTAL'")
		aAdd(aHelpEng,"Enter the value to be printed")
		aAdd(aHelpEng,"in 'TOTAL VALUE' field.")
		PutSX1Help("P.MTR68019.",aHelpPor,aHelpEng,aHelpSpa)						
	Endif
EndIf

Return
