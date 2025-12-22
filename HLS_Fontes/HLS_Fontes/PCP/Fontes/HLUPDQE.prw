#include "rwmake.ch"
#include "TOPCONN.CH"

/*/{Protheus.doc} HLUPDQE

Atualiza Quantidade por Embalagem = B1_QE - Exclusivo para os Produtos do P.O. = ALMOXARIFADO = 05		

@type function
@author Renato Marinheiro
@since 05/03/04

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HLUPDQE  ³ Autor ³ Renato Marinheiro     ³ Data ³ 05/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza Quantidade por Embalagem = B1_QE - Exclusivo para ³±±
±±           ³ os Produtos do P.O. = ALMOXARIFADO = 05			         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HLUPDQE()

Private _LRet:=.T. 
Private _lValid:=.F.
Private _cMostra := ""
Private _lAlmox:=.T. 
Private _cAlmox:=""  
Private _nQtdEmb:=0
Private nOpca:=0
Private _nQEAntes:=0
                                                
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemtoAnsi("Programa que Atualiza a Quantidade por Embalagem - P.O.") PIXEL
//pergunte("HLUPDQ",.F.) 

_lPerg:=pergunte("HLUPDQ",.T.)

If !_lPerg
	oDlg:End()
	Return .T.
Endif

@ 18, 6 TO 76, 287                  
@ 29, 15 SAY OemToAnsi("Finalidade:=Altera a Quantidade por Embalagem para os Produtos do P.O. (** Almoxarifado = 05 **)")
//@ 38, 15 SAY OemToAnsi("selecionadas. E utilizado o campo do cadastro de produto   <Preco ")
//@ 48, 15 SAY OemToAnsi("Igual> para determinar qual sera o valor de venda do produto para")
//@ 58, 15 SAY OemToAnsi("atualizacao na tabela DA1 - Composicao da Tabela de Preco.       ")

DEFINE SBUTTON FROM 80, 170 TYPE 5 ACTION Pergunte("HLUPDQ",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 210 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
//DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg 
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION (oDlg:End(),nOpca:=2) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg          

//MV_PAR01 = Código do Produto
//MV_PAR02 = Quantidade por Embalagem 

_nQtdEmb:=MV_PAR02

If nOpca == 1      
	                                        
	//TESTE ALMOXARIFADO <> 05	
	//B1_COD			B1_DESCHL	B1_QE	B1_LOCPAD
	//T5A-51343-300		BASE A      240		10   
		
	If Empty(MV_PAR01) .Or. Empty(_nQtdEmb) 
		ApMsgAlert("Produto não  informado ou Quantidade Informada é Zero - Favor Verificar os Parâmetros Inseridos.")		
		Return(.T.)
	Else	    
	   _lValid:=U_LVALPROD(MV_PAR01) 	   	   
	Endif
	
	If _lValid	.And. _lAlmox .And. _lRet
		If !Empty( _cMostra ) 
		   If !ApMsgYesno(_cMostra + " # Confirma Alteração Qtde Embalagem DE => " + Alltrim(Str(_nQEAntes)) + " deste Produto PARA => " + Alltrim(Str(_nQtdEmb)) +  " (S/N)? ","Confirma")                     		   
		   	  Return(.T.)
		   Endif
	    Endif	    
		Processa({|lEnd| HLUPDQProc()},"Atualizando Quantidade por Embalagem",OemToAnsi("#ATUQTDEMB"),.F.)	                      		
	Else           
	    //Almoxarifado Difere de 05 ou Produto Não Encontrado - ABORTA
	    If !_lAlmox
	       ApMsgAlert("Almoxarifado desse Produto não é 05 - Favor Verificar o Cadastro de Produtos.")
	    Else
			If !_lRet
			   ApMsgAlert("Produto não Encontrado - Favor Verificar o Cadastro de Produtos.")					 
			Endif	    
	    Endif
	Endif
Endif


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HLUPDQProc  ³ Autor ³ Ricardo Borges ³ Data ³15/07/14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa A Utilização                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HLUPDQE                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function HLUPDQProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Produto  ?                           ³
//³ mv_par02             // Quant. Embalagem ?                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ProcRegua(0)           

	//IncProc()          
	//UPDATE SB1010 SET B1_QE =  50 WHERE B1_COD =   'TM0-E0100-000'    AND  D_E_L_E_T_ = ''
			
	cUpdate := " UPDATE "+RetSqlName("SB1") + " " 
	cUpdate += " SET    B1_QE = " +  Alltrim(Str(_nQtdEmb))
	cUpdate += " WHERE 	B1_COD = '" + Alltrim(MV_PAR01) + "'
	cUpdate += " AND 	B1_LOCPAD = '05' "	 
	//cUpdate += " AND 	B1_LOCPAD = '10' "	
	cUpdate += " AND 	D_E_L_E_T_ = '' "
	
	TCSQLEXEC(cUpdate)

Return
                            
User Function LVALPROD(xCod)
      
        cTabelaSQL:="TRB"
        
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea("TRB")
		Endif

		cQuery	:= "SELECT B1_COD, B1_DESCHL, B1_QE, B1_LOCPAD "
		cQuery	+= "FROM "
		cQuery	+=		RETSQLNAME("SB1") + " B1 "
		cQuery	+= "WHERE  "
		cQuery	+= "	B1_COD = '" + xCOD + "' "		
		cQuery	+= "	AND D_E_L_E_T_ = ''"
		
		TcQuery cQuery Alias (cTabelaSQL) New

		(cTabelaSQL)->(DbGoTop())
		
		If !(cTabelaSQL)->(Eof()) //Found
		   
			_nQEAntes := (cTabelaSQL)->B1_QE   
			
			_cAlmox  := (cTabelaSQL)->B1_LOCPAD
			
			_cMostra := "Produto: " + Alltrim(xCod) + " - " + Alltrim((cTabelaSQL)->B1_DESCHL) + " - Almoxarifado: " + (cTabelaSQL)->B1_LOCPAD
			
			If (cTabelaSQL)->B1_LOCPAD <> "05"
			   _lRet:=.F.
			   _lAlmox:=.F.
			Endif
			
		Else  //Produto Não Encontrado
		
		   _lRet:=.F. 						
		
		Endif
	
		dbCloseArea("TRB")				

Return _lRet

/*

SELECT F1_ZZINVO,F1_DOC,F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, D1_ZZFABRI, D1_COD, B1_DESCNF, B1_DESC , D1_QUANT, D1_UM, D1_PEDIDO,F1_DTDIGIT  FROM SF1010
INNER JOIN SD1010
ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA
INNER JOIN SB1010
ON B1_COD = D1_COD
INNER JOIN SA2010
ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA
WHERE F1_ZZINVO <> ''
AND F1_ZZINVO = 'USA-22876191'
ORDER BY F1_ZZINVO DESC
 

*/