#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


#Include "Protheus.ch"

/*------------------------------------------------------------------------------------------------------*
| P.E.:  MA030TOK                                                                                      |
| Desc:  Função chamada na validação do cadastro de clientes                                           |
| Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784252                                  |
*------------------------------------------------------------------------------------------------------*/

//User Function MA030TOK()
//Local lRet := .T.
//Local _cGrupTrib := ""
//Local _cContrib  := "" 
//lRet := MsgYesNo("Deseja continuar?", "Atenção")

//Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma      ºAutor  ³Stan Lee Lopes     				º Data ³  04/03/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Complemento de Cadastro de Clientes        								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMLOJE05()                           


	//MANAUS
	if (M->A1_PESSOA == "F") .AND. (M->A1_EST == "AM") 
		M->A1_GRPTRIB := "013"                          
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. (M->A1_COD_MUN == "02603")
		M->A1_GRPTRIB := "012"

		//FORA DE MANAUS

	elseif (M->A1_PESSOA == "F") .AND. !(M->A1_EST == "AM")
		M->A1_GRPTRIB = "003"
	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (AllTrim(M->A1_INSCR) == "ISENTO")
		M->A1_GRPTRIB = "003"

	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND. (M->A1_TPTRIBU = "1") .AND. (AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "004"				                                                                                                                             
		M->A1_CONTRIB = "1" 
	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND.( M->A1_TPTRIBU = "2") .AND. (AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "005"				                                                                                                                             
		M->A1_CONTRIB = "1"  
	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND.( M->A1_TPTRIBU = "3") .AND. (AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "005"				                    •                                                                                                         
		M->A1_CONTRIB = "1"
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. !(M->A1_COD_MUN == "04062") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND. (M->A1_TPTRIBU = "1")
		M->A1_GRPTRIB = "001"				                                                                                                                             
		M->A1_CONTRIB = "1"
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. !(M->A1_COD_MUN == "04062") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND. (M->A1_TPTRIBU = "2") 
		M->A1_GRPTRIB = "002"				                                                                                                                             
		M->A1_CONTRIB = "1"
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. !(M->A1_COD_MUN == "04062") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND. (M->A1_TPTRIBU = "3") 
		M->A1_GRPTRIB = "002"				                                                                                                                             
		M->A1_CONTRIB = "1"
		//AREA DE LIVRE COMERCIO
	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))) .AND. (M->A1_TPTRIBU = "1") .AND. !(AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "007"				                                                                                                                             
		M->A1_CONTRIB = "1"                                                    
	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))).AND. (M->A1_TPTRIBU = "2") .AND. !(AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "006"				                                                                                                                             
		M->A1_CONTRIB = "1" 
	elseif (M->A1_PESSOA == "J") .AND. !(M->A1_EST == "AM") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))).AND. (M->A1_TPTRIBU = "3") .AND. !(AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "006"				                                                                                                                             
		M->A1_CONTRIB = "1"

		//TABATINGA COD 04062
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. (M->A1_COD_MUN == "04062") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))).AND. (M->A1_TPTRIBU = "2") .AND. !(AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "008"				                                                                                                                             
		M->A1_CONTRIB = "1"   
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. (M->A1_COD_MUN == "04062") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))).AND. (M->A1_TPTRIBU = "3") .AND. !(AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "008"				                                                                                                                             
		M->A1_CONTRIB = "1" 
	elseif (M->A1_PESSOA == "J") .AND. (M->A1_EST == "AM") .AND. (M->A1_COD_MUN == "04062") .AND. (!(AllTrim(M->A1_INSCR) == "ISENTO") .OR. !(AllTrim(M->A1_INSCR == ""))).AND. (M->A1_TPTRIBU = "1") .AND. !(AllTrim(M->A1_SUFRAMA) == "")
		M->A1_GRPTRIB = "009"				                                                                                                                             
		M->A1_CONTRIB = "1"
		//else
		//Alert("O Cadastro não poede ser realizado. Procure o setor Fiscal.")

	EndIf
	M->A1_CARGO1 := " "                                       
Return ("")
