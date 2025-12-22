#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/{protheus.doc}HLINVP00
mBrouse utilizado na customização da da rotina de Inventário. 
@author WERMESON GADELHA DO CANTO
@since 16/12/2009
/*/


/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ PLESTP00   ¦ WERMESON GADELHA DO CANTO    ¦ Data ¦ 16/12/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ mBrouse utilizado na customização da da rotina de Inventário.             ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function HLINVP00()
 Local cQry   := "" 
 Local nQuant := 1 
 Local cEnde  := ""

  fTela()
Return nil

//*****************************************************************************************

Static Function fTela()
 Private cCadastro := "Cadastro de Cartelas de Inventario"
/* Private aRotina   := { {"Pesquisar"    , "AxPesqui"  , 0, 1} ,;                     
                        {"Contagem"     , "U_PLESTP01", 0, 3} ,;
                        {"Cart.Brancas" , "U_PLESTP03", 0, 4} ,;
   		               {"Legendas"     , "U_fLegSZ4" , 0, 2} }
  */
  
  Private aRotina   := { {"Pesquisar"    , "AxPesqui"  , 0, 1} ,;                     
                        {"Contagem"     , "U_HLINVP01", 0,2} ,;                       
   		               {"Legendas"     , "U_fLegSZ4" , 0, 2} }


  Private aCores   := { {"Z4_STATUS<>'0' .And.  Z4_STATUS<>'7' ",'ENABLE' },;
        					   {"Z4_STATUS=='0' .Or. Z4_STATUS=='7' ",'DISABLE'}} 
             
 Private cDelFunc := ".T."
 Private cString  := "SZ4"

  dbSelectArea(cString)
  dbSetOrder(1)

  SZ4->(dbSetFilter({|| ( SubStr(dTos(Z4_DATA),1,6) == SubStr(dTos(dDataBase),1, 6))},'( SubStr(dTos(Z4_DATA),1, 6) == SubStr(dTos(dDataBase),1, 6))'))
 
  dbSelectArea(cString)

  mBrowse( 6, 1, 22, 75, cString,,,,,,aCores)

  cCadastro := "Digitação de Cartelas"
  Set Filter to

Return

//*****************************************************************************************

User Function fProxSZ4()
 Local cRet   := "" 
 Local cAlias := Alias()
 Local cQry   := "" 
 
  cQry += "SELECT ISNULL(MAX(Z4_NUM),'0000') AS Z4_NUM"
  cQry += " FROM "+RetSQLName("SZ4")+" WHERE D_E_L_E_T_ = ' ' "
  cQry += "  AND SUBSTRING(Z4_NUM, 1, 1) <> 'B'  "
  cQry += "  and Z4_FILIAL = '" + xFilial("SZ4") + "' "  

  MPSysOpenQuery( cQry, "TMP" ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

  cRet := Soma1(Z4_NUM)
  dbCloseArea()
  dbSelectArea(cAlias)

  FreeUsedCode()
  Help := .T.	// Nao apresentar Help MayUse
  
  While !FreeForUse("SZ4",cRet,.F.)
    cRet := Soma1(cRet)
	 Help := .T.	// Nao apresentar Help MayUse
  End
  
  Help := .F.	// Habilito o help novamente
Return cRet 	        

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦                          
¦¦¦ Função    ¦ fLegSZ4    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/06/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ legendas do histórico do protocolo onde será informado se será¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function fLegSZ4()
   BrwLegenda(cCadastro,"Legendas",{{"ENABLE"     ,"Pendente"},;
                                    {"DISABLE"    ,"Fechado" }})

// 1=Associado; 2=Em Andamento; 3=Baixado Manual; 4=Baixado Automatico                                                             
                                 
Return  
