#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ CADSZ3     ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 23/05/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Informações para o Shipper.                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CADSZ3()

	Private cCadastro := "Informações para Shipper"
	Private cAlias1   := "SZ3"
	Private aRotina   := {{"Pesquisar"   ,"AxPesqui",0,1} ,;
						  {"Visualizar"  ,"AxVisual",0,2} ,;
						  {"Incluir"     ,"AxInclui",0,3} ,;
						  {"Alterar"     ,"AxAltera",0,4} ,;
						  {"Excluir"     ,"AxDeleta",0,5}}

	
	dbSelectArea(cAlias1)
  	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1)

Return
