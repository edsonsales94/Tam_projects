#include 'Protheus.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MT097FIL   ¦ Autor ¦                      ¦ Data ¦ 12/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para Executar Filtros na Tela de Apresentação¦¦¦
¦¦¦           ¦ dos Dados de Liberacao de Documentos, mas Esta sendo Utilizado¦¦¦
¦¦¦           ¦ Para Manipular a Variavel aRotina e Modificar a POsicao 2     ¦¦¦
¦¦¦           ¦ Para Mostrar a Tela de Consulta de Documento e Mostrar a Tela ¦¦¦
¦¦¦           ¦ Da Requisição de Viagens                                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/


User Function MT097FIL()
  //Modificado a Rotina A097VISUAL para a Customizada u_IN097VIS para poder Visualizar as Requisicoes de Viagem
  aRotina[02][02] := 'u_IN097VIS'
  aRotina[04][02] := 'u_IN097LIB'
  //--
  aRotina[05][02] := 'u_IN097EST'
  aRotina[06][02] := 'u_IN097SUP'
  aRotina[07][02] := 'u_IN097TRA'
  aRotina[06][02] := 'u_IN097SUP'
//  aAdd(aRotina,{})
  //--
  //Retorna .T. para nao Gerar Erro na Rotina Padrao pois o retorno deveria ser uma String com Uma Expressao de Filtro
Return '.T.'


User Function IN097VIS(cAlias,nOpc,nRecNo)
   Local cdFuncao := FunName()
   If SCR->CR_TIPO = 'RV'
      SZ7->(dbSetORder(1))
      SZ7->(dbSeek(xFilial('SZ7')+SCR->CR_NUM))
      u_INVIAC2V(cAlias,nOpc,nRecNo)
      else
        if SCR->CR_TIPO = 'MD'
          setFunName('CNTA120')
        EndIf
        A097VISUAL(cAlias,nOpc,nRecNo)
   EndIf
   setFunName(cdFuncao)
Return

User Function IN097LIB(cAlias,nOpc,nRecNo)
   If SCR->CR_TIPO = 'RV'
      SZ7->(dbSetORder(1))
      SZ7->(dbSeek(xFilial('SZ7')+SCR->CR_NUM))
      u_INVIAP4L(cAlias,nRecNo,nOpc)
      else
        A097LIBERA(cAlias,nOpc,nRecNo)
   EndIf
Return


User Function IN097TRA(cAlias,nOpc,nRecNo)  
	Local cAlias := ALIAS()
   If SCR->CR_TIPO = 'RV'
      SZ7->(dbSetORder(1))
      SZ7->(dbSeek(xFilial('SZ7')+SCR->CR_NUM))
      u_INVIAP4T(cAlias,,nOpc,nRecNo)
   else
   	DbSelectArea(cAlias)
   	A097TRANSF(cAlias,nOpc,nRecNo)
   EndIf
Return

User Function IN097est(cAlias,nOpc,nRecNo)
   If SCR->CR_TIPO = 'RV'
      SZ7->(dbSetORder(1))
      SZ7->(dbSeek(xFilial('SZ7')+SCR->CR_NUM))
      u_INVIAP4E(cAlias,nOpc,nRecNo)
      else
        A097ESTORNA(cAlias,nOpc,nRecNo)
   EndIf
Return          

User Function IN097SUP(cAlias,nOpc,nRecNo)
	Local cAlias := ALIAS()
   If SCR->CR_TIPO = 'RV'
      SZ7->(dbSetORder(1))
      SZ7->(dbSeek(xFilial('SZ7')+SCR->CR_NUM))
      u_INVIAP4S(cAlias,nOpc,nRecNo)
   else
	  	DbSelectArea(cAlias)
   	A097SUPERI(cAlias,nOpc,nRecNo)
   EndIf
Return



/*Powered By DXRCOVRB*/
