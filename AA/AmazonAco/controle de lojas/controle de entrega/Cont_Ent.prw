#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"

User Function Cont_Ent()

DbSelectArea("SZE")

Private aCores := {}
Private cCadastro	:= "Controle de Entrega" 		           	// Cabecalho da tela

Aadd(aCores, {'Empty(ZE_STATUS)',"BR_VERDE"	})					// EM ABERTO 
Aadd(aCores, {'ZE_STATUS = "P" ',"BR_PINK"	})					// PRÉ-ROMANEIO
Aadd(aCores, {'ZE_STATUS = "R" ',"BR_AMARELO"})					// EM ROMANEIO  
Aadd(aCores, {'ZE_STATUS = "B" ',"BR_CINZA"	})					// VEM BUSCAR NA LOJA
Aadd(aCores, {'ZE_STATUS = "E" ',"BR_VERMELHO"})				// ENTREGUE 
Aadd(aCores, {'ZE_STATUS = "V" ',"BR_LARANJA"})					// NOVA ENTREGUE
Aadd(aCores, {'ZE_STATUS = "N" ',"BR_AZUL"})					// ENDERECO NAO ENCONTRADO
Aadd(aCores, {'ZE_STATUS = "F" ',"BR_BRANCO"})					// LOCAL FECHADO
Aadd(aCores, {'ZE_STATUS = "D" ',"BR_PRETO"})					// DEVOLUCAO  
Aadd(aCores, {'ZE_STATUS = "S" ',"BR_MARROM"})					// ESTORNO DE VENDA

aRotina := {{ "Pesquisar "  , "AxPesqui" 		, 0 , 1 , , .F.},;      // Pesquisar
{ "Visualizar"   			, "AxVisual"   		, 0 , 2 , , .T. },;		// "Visualizar"
{ "Novo Pré-Romaneio "		, "u_Tela_CEN('')" 	, 0 , 3 , , .T. },;		// "Pré-Romaneio"
{ "Alt. Pré-Romaneio "		, "u_Tela_CEN('P')" , 0 , 3 , , .T. },;		// "Pré-Romaneio"
{ "Romaneio  "     			, "u_Romaneio" 		, 0 , 3 , , .T. },;		// "Romaneio"
{ "Retorno   "   			, "u_RetEnt"   		, 0 , 2 , , .T. },;		// "Retorno da Entrega"
{ "iMprimir  "  			, 'u_IMPROMA(.T.)'  , 0 , 2 , , .T. },; 	// Imprimir Romaneio
{ "Hist.Romaneio  "  		, 'u_HISTROM()'     , 0 , 2 , , .T. },;		// Hist. Romaneio 
{ "Motorista "   			, "u_Motor"    		, 0 , 3 , , .T. },;		// "Motorista"
{ "Legenda   "   			, "u_Leg_Roma"		, 0 , 8 , , .T. } }		//"Legenda"

mBrowse( ,,,, "SZE",,,,,, aCores )

Return

User Function Leg_Roma()

Local aLegenda := { {"BR_VERDE",	"Venda sem Romaneio"},; 
					{"BR_PINK",		"Pré-Romaneio" },; 	
					{"BR_AMARELO",	"Venda com Romaneio"},;
					{"BR_VERMELHO",	"Venda Entregue    "},;
					{"BR_LARANJA",	"Nova Entrega"},;
					{"BR_CINZA",	"Vem Buscar na Loja"},; 	 	
					{"BR_AZUL",		"Endereço não econtrado"},;
					{"BR_PRETO",	"Venda com Devolução"},; 
					{"BR_MARROM",	"Venda Estornada do Romaneio"},; 	
					{"BR_BRANCO",	"Local Fechado"}}

BrwLegenda("Romaneio","Legenda",aLegenda) 			

Return .T.
