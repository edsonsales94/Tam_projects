/*---------------------------------------------------------------------------*
 | Data       : 30/10/2023                                                   |
 | Rotina     : ANESTA01                                                     |
 | Responsável: ENER FREDES                                                  |
 | Descrição  : Rotina de Cadastro de Ordem de Serviço Amazonaves            |
 *---------------------------------------------------------------------------*/



#Include "Protheus.ch"
 

 
User Function ANESTA01()
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T." //Pode ser colocado como "u_zVldTst()"
 
    //Chamando a tela de cadastros
    AxCadastro('SZ4', 'Cadastro de Ordem de Serviços Amazonaves', cDelOk, cFunTOk)
 
Return
 