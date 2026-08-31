#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGAR237  ºAutor  ³Microsiga           º Data ³  22/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as informacoes para o cnab a pagar o banco do REAL  . º±±
±±º                                                                       º±±
±±ºParametros:                                                            º±±
±±º                                                                       º±±
±±º  01 - Retorna o nome do contribuinte (segmento N)                     º±±
±±º  02 - Retorna os detalhes do segmento N (depende do tipo do tributo)  º±±
±±º                                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Pagar237(_cOpcao)


Local _cReturn := ""

	
If _cOpcao == "01"   // Nome do Contribuinte
   
   If !Empty(SE2->E2_XCNPJC)
      _cReturn := Subs(SE2->E2_XCONTR,1,30)
      If Empty(_cReturn)
         MsgAlert('Nome do Contribuinte não informado para o segmento N - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
      EndIf
  Else
      _cReturn := Subs(SM0->M0_NOMECOM,1,30)
  EndIf   
   
ElseIf _cOpcao == "02"   // Detalhes Segmento N 
   
  //--- Codigo Receita do Tributo - Posicao 111 a 116                                                                      
  If SEA->EA_MODELO == "18"   //--- Para DARF Simples - fixar código 6106
     _cReturn := "6106"+SPACE(2)
  Else
     _cReturn := If(!Empty(SE2->E2_CODREC),SE2->E2_CODREC,SE2->E2_CODRET)+SPACE(2)
  
  EndIf 

  //--- Tipo de Identificacao do Contribuinte - Posicao 117 a 118
  //--- CNPJ (1) /  CPF (2)             
  If !Empty(SE2->E2_XCNPJC)
     _cReturn += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"01","02")
  Else               
     _cReturn += "01"           
  EndIf
             
  //--- Identificacao do Contribuinte - Posicao 119 a 132
  //--- CNPJ/CPF do Contribuinte    
  If SEA->EA_MODELO == "22"  //--- Para GARE ICMS - Retornar o CNPJ da Filial do SE2->E2_FILIAL
 
      _cReturn +=  Strzero(Val(dadosSM0("02",SE2->E2_FILIAL)),14)                               
  
  Else
  
      If !Empty(SE2->E2_XCNPJC)
         _cReturn += Strzero(Val(SE2->E2_XCNPJC),14)
      Else
        _cReturn += Subs(SM0->M0_CGC,1,14)
      EndIf
 
  EndIf
                                              
  //--- Identificacao do Tributo - Posicao 133 a 134  
  //--- 16 - DARF Normal   
  //--- 17 - GPS                 
  //--- 18 - DARF Simples
  //--- 19 - IPTU
  //--- 22 - GARE-SP ICMS
  //--- 23 - GARE-SP DR
  //--- 24 - GARE-SP ITCMD
  //--- 25 - IPVA
  //--- 26 - Licenciamento
  //--- 27 - DPVAT
  //--- 35 - FGTS   
  _cReturn += SEA->EA_MODELO 


  //--- GPS                  
  If SEA->EA_MODELO == "17" //--- GPS
     
     //--- Competencia (Mes/Ano) - Posicao 135 a 140  Formato MMAAAA
     _cReturn += Strzero(Month(SE2->E2_XCOMPET),2)+Strzero(Year(SE2->E2_XCOMPET),4)  

     //--- Valor do Tributo - Posicao 141 a 155
     _cReturn += Strzero((SE2->E2_SALDO-SE2->E2_XOUTENT)*100,15)
     
     //--- Valor Outras Entidades - Posicao 156 a 170             
     _cReturn += Strzero(SE2->E2_XOUTENT*100,15)     
     
     //--- Atualizacao Monetaria - Posicao 171 a 185                        
     _cReturn += Strzero((SE2->E2_XMULTA+SE2->E2_XJUROS)*100,15)                              

     //--- Mensagem ALERTA que está sem Codigo da Receita
     If Empty(SE2->E2_CODREC)                              
     
        MsgAlert('Tributo sem Codigo Receita. Informe o campo Cod.Receita no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

     EndIf
     
     //--- Mensagem ALERTA que está sem periodo de apuração
     If Empty(se2->E2_XCOMPET)                              
     
        MsgAlert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

     EndIf
     
  //--- DARF Normal                  
  ElseIf SEA->EA_MODELO == "16" //--- DARF Normal
  
     //--- Periodo de Apuracao - Posicao 135 a 142  Formato DDMMAAAA
     _cReturn += Gravadata(SE2->E2_XCOMPET,.F.,5)                               

     //--- Referencia - Posicao 143 a 159                     
     _cReturn += Strzero(Val(SE2->E2_XREF),17)

     //--- Valor Principal - Posicao 160 a 174
     _cReturn += Strzero(SE2->E2_SALDO*100,15)
     
     //--- Valor da Multa - Posicao 175 a 189             
     _cReturn += Strzero(SE2->E2_XMULTA*100,15)     
     
     //--- Valor Juros/Encargos - Posicao 190 a 204                        
     _cReturn += Strzero(SE2->E2_XJUROS*100,15)                              
   
     //--- Data de Vencimento - Posicao 205 a 212  Formato DDMMAAAA
     _cReturn += Gravadata(SE2->E2_VENCTO,.F.,5)                               

     //--- Mensagem ALERTA que está sem Codigo da Receita para DARF de Retenção
     //If Empty(SE2->E2_CODRET)                              
     
     //   MsgAlert('Tributo sem Codigo Receita. Informe o campo Cd.Retenção no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

     //EndIf
     
     //--- Mensagem ALERTA que está sem periodo de apuração
     If Empty(se2->E2_XCOMPET)                              
     
        MsgAlert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

     EndIf
     
 
  //--- DARF Simples                  
  ElseIf SEA->EA_MODELO == "18" //--- DARF Simples
  
     //--- Periodo de Apuração  (Dia/Mes/Ano) - Posicao 135 a 142  Formato DDMMAAAA
     _cReturn += Gravadata(SE2->E2_XCOMPET,.F.,5)                               

     //--- Receita Bruta - Posicao 143 a 157                     
     _cReturn += Repl("0",15)

     //--- Percentual - Posicao 158 a 164
     _cReturn += Repl("0",7)
     
     //--- Valor Principal - Posicao 165 a 179
     _cReturn += Strzero(SE2->E2_SALDO*100,15)
     
     //--- Valor da Multa - Posicao 180 a 194             
     _cReturn += Strzero(SE2->E2_XMULTA*100,15)     
     
     //--- Valor Juros/Encargos - Posicao 195 a 209                        
     _cReturn += Strzero(SE2->E2_XJUROS*100,15)                              

     //--- Mensagem ALERTA que está sem periodo de apuração
     If Empty(se2->E2_XCOMPET)                              
     
        MsgAlert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

     EndIf
     
   
  //--- GARE ICMS SP                  
  ElseIf SEA->EA_MODELO == "22" //--- GARE ICMS - SP
 
     //--- Data de Vencimento - Posicao 135 a 142  Formato DDMMAAAA
     _cReturn += Gravadata(SE2->E2_VENCREA,.F.,5)                               

     //--- Inscricao Estadual - Posicao 143 a 154 
      _cReturn +=  Strzero(Val(dadosSM0("01",SE2->E2_FILIAL)),12)                               
                                                                           
     //--- Divida Ativa / Etiqueta - Posicao 155 a 167 
      _cReturn +=  Strzero(Val(SE2->E2_XDIVID),13)                               

     //--- Periodo de Referencia (Mes/Ano) - Posicao 168 a 173  Formato MMAAAA
     _cReturn += Strzero(Month(SE2->E2_XCOMPET),2)+Strzero(Year(SE2->E2_XCOMPET),4)  

     //--- N. Parcela / Notificação - Posicao 174 a 186 
      _cReturn +=  Strzero(Val(SE2->E2_XPARCE),13)                               

     //--- Valor da Receita (Principal) - Posicao 187 a 201
     _cReturn += Strzero(SE2->E2_SALDO*100,15)
     
     //--- Valor Juros/Encargos - Posicao 202 a 215                        
     _cReturn += Strzero(SE2->E2_XJUROS*100,14)                              

     //--- Valor da Multa - Posicao 216 a 229             
     _cReturn += Strzero(SE2->E2_XMULTA*100,14)     
     
  //--- 25 - IPVA SP   
  //--- 26 - Licenciamento
  //--- 27 - DPVAT              
  ElseIf SEA->EA_MODELO == "25"  .or. SEA->EA_MODELO == "26" .or. SEA->EA_MODELO == "27" 
   
     //--- Exercicio Ano Base - Posicao 135 a 138
     _cReturn += Strzero(SE2->E2_ANOBAS,4)                               

     //--- Renavam - Posicao 139 a 147 
      _cReturn +=  Strzero(Val(SE2->E2_RENAV),9)                               
                                                                           
     //--- Unidade Federação - Posicao 148 a 149 
      _cReturn +=  Upper(SE2->E2_IPVUF)                               

     //--- Codigo do Municipio - Posicao 150 a 154
     _cReturn += Strzero(Val(SE2->E2_CODMUN),5)    

     //--- Placa - Posicao 155 a 161 
      _cReturn +=  SE2->E2_PLACA                              

     //--- Opção de Pagamento - Posicao 162 a 162 - Para DPVAT sempre opção 5
     If SEA->EA_MODELO == "25"
        _cReturn += Alltrim(SE2->E2_OPCAO)
     Else
        _cReturn += "5"   //--- Para 27-DPVAT e 26-Licenciamento é obrigatório utilizar o código 5.
     EndIf
     
    //--- Opção de Retirada do CRVL - Posicao 163 a 163 - Somente para LICENCIAMENTO    
    //---- 1 = Correio
    //---  2 = Detran / Ciretran
     If SEA->EA_MODELO == "26"
        _cReturn += "1"    //--- Definido por Giovana sempre 1 = Correio
     EndIf
  EndIf           

EndIf       

Return(_cReturn)       

//--- Retornar Inscrição Estadual e CNPJ da Filial do Título do SE2
STATIC Function DadosSM0(_cOpc,_cFilSE2)
                                                            
Local _cVolta := ""
Local _nRecnoSM0 :=SM0->(Recno())


  SM0->(dbSetOrder(1))
  SM0->(dbSeek(cEmpAnt+_cFilSE2))
		
  If _cOpc == "01"
     _cVolta := SM0->M0_INSC 
  Else
    _cVolta := SM0->M0_CGC
  EndIf
		
SM0->(dbGoto(_nRecnoSM0))


Return(_cVolta)

