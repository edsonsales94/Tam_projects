#include "rwmake.ch" 
#INCLUDE "PROTHEUS.CH"
      
 /*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  MTA416PV  ¦ Autor ¦ORISMAR SILVA         ¦ Data ¦ 12/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para preenchimento dos campos do cabeçalho   ¦¦¦
¦¦¦           ¦ do pedido de vendas, pelo orçamento de venda.                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/   
User function MTA416PV()
                                                    
Local nAux      := PARAMIXB //Quantidade de linhas no acols.  
Local lLote     := Posicione("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XQUEBRA") //Permite usar vários lotes .T. (Sim) ou .F. (Não)
Local TpCli     := Posicione("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_PESSOA") //Tipo de Cliente F = Fisico e J = Juridico
Local lLoteProd := .F.
Local dDatDia   := DDATABASE
Local cEmp      := SM0->M0_CODFIL //Código da Filial
Local nQtdLote  := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_QTDLOTE"  })
Private aProduto := {}
*
M->C5_VEND1   := SCJ->CJ_XVEND
M->C5_PEDCLI  := ALLTRIM(StrTran(StrTran(StrTran(SCJ->CJ_COTCLI,"/",""),"-",""),".",""))
M->C5_PDESCAB := SCJ->CJ_PDESCAB
M->C5_MENNOTA := ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_XOBS"))                                     
M->C5_XCGC    := ALLTRIM(POSICIONE("SA1",1,"  "+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_CGC"))
*
cMsgHtml := '<h3>Não existe lote para o produto '+_aCols[nAux][2]+'<h3>'

*
if !U_RMTA416B(aProduto)
   if MsgBox("Deseja gerar o relatório ?","A T E N Ç Ã O","YESNO")  
      U_RSMTA416()
   endif
endif
*

_cQry := " SELECT B8_FILIAL,B8_PRODUTO,B8_LOCAL,B8_DTVALID,B8_SALDO-B8_EMPENHO SALDO,B8_LOTECTL,B8_DFABRIC,R_E_C_N_O_,B8_DOC
_cQry += " FROM " + RetSqlName("SB8")
_cQry += " WHERE D_E_L_E_T_ = '' "
_cQry += " AND B8_FILIAL = '"+XFILIAL("SB8")+"' 
_cQry += " AND B8_PRODUTO = '"+_aCols[nAux][2]+"'"
_cQry += " AND B8_SALDO > 0                   
_cQry += " AND (B8_SALDO-B8_EMPENHO) > 0 "
_cQry += " AND B8_DTVALID > '"+DTOS(dDatDia)+"'"
_cQry += " AND B8_LOCAL = '"+_aCols[nAux][20]+"'"
_cQry += " ORDER BY B8_DTVALID,B8_LOTECTL
*      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.F.)   

TcSetField('TMP','B8_DTVALID','D')
TcSetField('TMP','B8_DFABRIC','D')
*
if !USED()
   MsgBox(_cQry+'. Query errada','Erro!!!','STOP')
endif

count to nReg

dbSelectArea("TMP")
dbGoTop()

if lLote .or. TpCli = "F"
   aPedido := AClone(_aCols)
endif       
*
nPosicao     := nAux  //Quantidade de linhas no acols.
nQuantidade  := 0
nPreco       := 0
*
if !TMP->(Eof())
   
   While !TMP->(Eof())

	  if TpCli = "J" //Cliente tipo juridico
	     if lLote //Permite usar vários lotes .T. (Sim) ou .F. (Não)  aPedido[nPosicao][6]ADEL( _aCols)
	        //Permite vários lotes por produto, campo no cliente A1_XQUEBRA = .T.	     
	        *
	        if Len(_aCols) > nPosicao
               nPosicao := Len(_aCols)
            endif              
	        *
	        nPesoB      := 0
	        nPesoL      := 0
	        nTPesoB     := 0
	        nTPesoL     := 0	           
	        nVolume     := 0
            *	        
	        if TMP->SALDO < _aCols[nPosicao][5]//Saldo do Lote menor que a Quantidade solicitada para o produto no orçamento.
	           *                                
	           nDisplay    := 0
	           nCaixa      := 0	           
	           nQtdLote    := 0
	           nSldProduto := 0
	           *
	           //Pesquisar o quantidade caixa padrão, peso bruto e peso liquido
	           nDisplay := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XDISPLA")   // Qtd Caixa Padrão
	           nCaixa   := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XCAIXA")   // Qtd Caixa Padrão
	           nPesoB   := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSBTCX")  // Peso Bruto Caixa Padrão
	           nPesoL   := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSLICX")  // Peso Liquido Caixa Padrão
	           nMesVd   := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XMSVALD")  // Mês de Validade do produto
	           *
	           if nCaixa <= TMP->SALDO //Será verificado o lote minimo (Qtd Cx Padrão) de acordo com o produto
	              
	              nSldProduto := TMP->SALDO
	              
	              while nSldProduto >= nCaixa	                    
	                    nSldProduto -= nCaixa
	                    nQtdLote    += nCaixa
	                    nTPesoB     += nPesoB
	                    nTPesoL     += nPesoL
	                    nVolume     += 1
	              end
	              
	              M->C5_PESOL   += ROUND(nTPesoL,1)
                  M->C5_PBRUTO  += ROUND(nTPesoB,1)
                  M->C5_VOLUME1 += nVolume            
                  
	              nQuantidade   := _aCols[nPosicao][5]-nQtdLote
	              nPreco        := _aCols[nPosicao][6] 
	              
	              if val(_aCols[nPosicao][1]) <> nPosicao
	                 _aCols[nPosicao][1] := STRZERO(Len(_aCols),2)
	              endif	           
	              
	              _aCols[nPosicao][5]  := nQtdLote            
	              _aCols[nPosicao][7]  := A410Arred((nQtdLote*_aCols[nPosicao][6]),"C6_VALOR") 
	              _aCols[nPosicao][14] := TMP->B8_LOTECTL
                  _aCols[nPosicao][16] := nQtdLote 
                  
                  if cEmp <> '01'                  
                     nMes := SUBS(DTOC(TMP->B8_DFABRIC),4,2)                   
                     nAno := SUBS(DTOC(TMP->B8_DFABRIC),7)                  
                     *
                     _aCols[nPosicao][19] := TMP->B8_DFABRIC
                     _aCols[nPosicao][18] := TMP->B8_DTVALID
                     _aCols[nPosicao][15] := TMP->B8_DTVALID
                  else
                     _aCols[nPosicao][19] := TMP->B8_DFABRIC                  
                     _aCols[nPosicao][18] := TMP->B8_DTVALID   
                     _aCols[nPosicao][15] := TMP->B8_DTVALID
                  endif
                  
                  _aCols[nPosicao][17] := TMP->B8_LOTECTL
                  
                  RunTrigger(2,nPosicao,nil,,'C6_PRCVEN')
                  nPosicao     += 1  
                  lLoteProd := .T.
                  
                  if nPosicao > 1   
                     //SERÁ CRIADO UM NOVO PEDIDO DE VENDA 
                     AADD(_aCols,AClone(_aCols[nAux]))                     
                     AFILL(_aCols[nPosicao], STRZERO(Len(_aCols),2), 1, 1)
                     AFILL(_aCols[nPosicao], nQuantidade, 5, 1)
                     AFILL(_aCols[nPosicao], A410Arred((nQuantidade*nPreco),"C6_VALOR"), 7, 1)        
                     AFILL(_aCols[nPosicao], CriaVar("C6_LOTECTL") , 14, 1)
                     AFILL(_aCols[nPosicao], CriaVar("C6_QTDLOTE") , 15, 1)                                                                    
                     AFILL(_aCols[nPosicao], CriaVar("C6_QTDLOTE") , 16, 1)  
                     AFILL(_aCols[nPosicao], CriaVar("C6_LOTE1")   , 17, 1)  
                     AFILL(_aCols[nPosicao], CriaVar("C6_LTVALID") , 18, 1)  
					 AFILL(_aCols[nPosicao], CriaVar("C6_FABRIC")  , 19, 1)  
                     //AFILL(_aCols[nPosicao], CriaVar("C6_LOCAL")   , 20, 1)  
                     RunTrigger(2,nPosicao,nil,,'C6_PRCVEN')
                  endif 
                       
               else //TMP-SALDO > nCaixa (Cx Padrão)
                  //RETIRADO A IMPLEMENTAÇÃO.
               endif
            
            else //Saldo do Lote maior que a quantidade solicitada.
               
	           nCaixa      := 0
	           nQtdLote    := 0
	           nSldProduto := 0

               if Len(_aCols) > nPosicao
                  nPosicao := Len(_aCols)
               endif
               
               //---verificando o peso bruto, peso liquido e quantidade cx padrão--------------//
	           nCaixa := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XCAIXA")   // Qtd Caixa Padrão
	           nPesoB := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSBTCX")  // Peso Bruto
	           nPesoL := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSLICX")  // Peso Liquido
	           nMesVd := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XMSVALD")      // Mês de Validade do produto               
               
               _aCols[nPosicao][14] := TMP->B8_LOTECTL
               _aCols[nPosicao][16] := _aCols[nPosicao][5]               
               *
               if cEmp <> '01'                  
                  nMes := SUBS(DTOC(TMP->B8_DFABRIC),4,2)                   
                  nAno := SUBS(DTOC(TMP->B8_DFABRIC),7)                  
                  *
                  _aCols[nPosicao][19] := TMP->B8_DFABRIC 
                  _aCols[nPosicao][18] := TMP->B8_DTVALID
                  _aCols[nPosicao][15] := TMP->B8_DTVALID
               else
                  _aCols[nPosicao][19] := TMP->B8_DFABRIC                  
                  _aCols[nPosicao][18] := TMP->B8_DTVALID   
                  _aCols[nPosicao][15] := TMP->B8_DTVALID
               endif
               *
               _aCols[nPosicao][17] := TMP->B8_LOTECTL
               lLoteProd            := .T.	           
	           nSldProduto          := _aCols[nPosicao][5]
	           *
	           while nSldProduto >= nCaixa	                    
	                 nSldProduto -= nCaixa
	                 nTPesoB     += nPesoB
	                 nTPesoL     += nPesoL
	                 nVolume     += 1
	           end               
	           
	           if nSldProduto > 0
                  //---verificando o peso bruto, peso liquido e quantidade display--------------//
	              nCaixa  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XDISPLA")  // Qtd Display
	              nPesoB  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSBTDP")  // Peso Bruto Display
	              nPesoL  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSLIDP")  // Peso Liquido Display
	              nVolume += 1  
	              *              
	           	                         
	              while nSldProduto >= nCaixa	                    
	                    nSldProduto -= nCaixa
	                    nTPesoB     += nPesoB
	                    nTPesoL     += nPesoL
	              end
	              
	           endif
                              
               M->C5_PESOL   += ROUND(nTPesoL,1)
               M->C5_PBRUTO  += ROUND(nTPesoB,1)
               M->C5_VOLUME1 += nVolume            
               *
               if TMP->SALDO > _aCols[nPosicao][5]//Sai do laço quantidade já atendida.
                  exit
               endif            
               
            endif
            *
         else //Não permite usar vários lotes
            *
	        if Len(_aCols) > nPosicao
               nPosicao := Len(_aCols)
            endif              
	        *
	        nPesoB      := 0
	        nPesoL      := 0
	        nTPesoB     := 0
	        nTPesoL     := 0	           
	        nVolume     := 0
            *	        
	        if TMP->SALDO >= _aCols[nPosicao][5]//Saldo do Lote menor que a Quantidade solicitada para o produto no orçamento.
	         
	           nCaixa      := 0
	           nQtdLote    := 0
	           nSldProduto := 0

               if Len(_aCols) > nPosicao
                  nPosicao := Len(_aCols)
               endif
               
               //---verificando o peso bruto, peso liquido e quantidade cx padrão--------------//
	           nCaixa := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XCAIXA")   // Qtd Caixa Padrão
	           nPesoB := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSBTCX")  // Peso Bruto
	           nPesoL := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSLICX")  // Peso Liquido
	           nMesVd := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XMSVALD")      // Mês de Validade do produto               
               
               _aCols[nPosicao][14] := TMP->B8_LOTECTL
               _aCols[nPosicao][16] := _aCols[nPosicao][5]    
               _aCols[nPosicao][19] := TMP->B8_DFABRIC
               _aCols[nPosicao][18] := TMP->B8_DTVALID
               _aCols[nPosicao][15] := TMP->B8_DTVALID               
               _aCols[nPosicao][17] := TMP->B8_LOTECTL
               lLoteProd            := .T.	           
	           nSldProduto          := _aCols[nPosicao][5]
	           *
	           while nSldProduto >= nCaixa	                    
	                 nSldProduto -= nCaixa
	                 nTPesoB     += nPesoB
	                 nTPesoL     += nPesoL
	                 nVolume     += 1
	           end               
	           
	           if nSldProduto > 0
                  //---verificando o peso bruto, peso liquido e quantidade display--------------//
	              nCaixa  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XDISPLA")  // Qtd Display
	              nPesoB  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSBTDP")  // Peso Bruto Display
	              nPesoL  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nPosicao][2],"B1_XPSLIDP")  // Peso Liquido Display
	              nVolume += 1  
	              *              
	           	                         
	              while nSldProduto >= nCaixa	                    
	                    nSldProduto -= nCaixa
	                    nTPesoB     += nPesoB
	                    nTPesoL     += nPesoL
	              end
	              
	           endif
                              
               M->C5_PESOL   += ROUND(nTPesoL,1)
               M->C5_PBRUTO  += ROUND(nTPesoB,1)
               M->C5_VOLUME1 += nVolume            
               *
               if TMP->SALDO > _aCols[nPosicao][5]//Sai do laço quantidade já atendida.
                  exit
               endif            
               
            endif
         endif
      else //Cliente Pessoa Fisica

	     nPesoB      := 0
	     nPesoL      := 0
	     nTPesoB     := 0
	     nTPesoL     := 0	           
	     nVolume     := 0     
      
         if TMP->SALDO >= _aCols[nAux][5]
         
         
            //---verificando o peso bruto, peso liquido ,quantidade cx padrão e meses de validade do produto--------------//
            nCaixa := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XCAIXA")   // Qtd Caixa Padrão
            nPesoB := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSBTCX")  // Peso Bruto
	         nPesoL := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSLICX")  // Peso Liquido         
            nMesVd := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XMSVALD")  // Meses de validade do produto 
          
            _aCols[nAux][14] := TMP->B8_LOTECTL
            _aCols[nAux][16] := _aCols[nAux][5]
           
            
            _aCols[nAux][19] := TMP->B8_DFABRIC                  
            _aCols[nAux][18] := TMP->B8_DTVALID   
            _aCols[nAux][15] := TMP->B8_DTVALID            
            _aCols[nAux][17] := TMP->B8_LOTECTL
            
            lLoteProd := .T.

	        *	           
	        nSldProduto := _aCols[nAux][5]
	        *
	        while nSldProduto >= nCaixa	                    
	              nSldProduto -= nCaixa
	              nTPesoB     += nPesoB
	              nTPesoL     += nPesoL
	              nVolume     += 1
	        end               
	           
	        if nSldProduto > 0
                  
               //---verificando o peso bruto, peso liquido e quantidade display--------------//
	           nCaixa  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XDISPLA")  // Qtd Display
	           nPesoB  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSBTDP")  // Peso Bruto Display
	           nPesoL  := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSLIDP")  // Peso Liquido Display
	           nVolume += 1  
	           *
               nTPesoB     := (nSldProduto*nPesoB)/nCaixa
               nTPesoL     := (nSldProduto*nPesoL)/nCaixa
	        endif
                              
            M->C5_PESOL   += ROUND(nTPesoL,1)
            M->C5_PBRUTO  += ROUND(nTPesoB,1)
            M->C5_VOLUME1 += nVolume            
            exit           
         
         else

	        if Len(_aCols) > nPosicao
               nPosicao := Len(_aCols)
            endif              
	        *
	        nPesoB      := 0
	        nPesoL      := 0
	        nTPesoB     := 0
	        nTPesoL     := 0	           
	        nVolume     := 0
            *	        
	        if TMP->SALDO <= _aCols[nAux][5]//Saldo do Lote menor que a Quantidade solicitada para o produto no orçamento.
	           *                                
	           nCaixa       := 0
	           nQtdLote    := 0
	           nSldProduto := 0	           
	           *
	           //Pesquisar o quantidade caixa padrão, peso bruto e peso liquido
               nCaixa := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XCAIXA")   // Qtd Caixa Padrão
               nPesoB := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSBTCX")  // Peso Bruto Caixa Padrão
	           nPesoL := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XPSLICX")  // Peso Liquido Caixa Padrão 
               nMesVd := POSICIONE("SB1",1,xFilial("SB1")+_aCols[nAux][2],"B1_XMSVALD")  // Meses de validade do produto 	           
	           *
	           
	           if nCaixa >= TMP->SALDO //Será verificado o lote minimo (Qtd Cx Padrão) de acordo com o produto
	              
	              nSldProduto := TMP->SALDO
	              
	              while nSldProduto >= TMP->SALDO //nCaixa	                    
	                    nSldProduto -= TMP->SALDO //nCaixa
	                    nQtdLote    += TMP->SALDO //nCaixa
	                    nTPesoB     += nPesoB
	                    nTPesoL     += nPesoL
	                    nVolume     += 1
	              end
	              
	              M->C5_PESOL   += ROUND(nTPesoL,1)
                  M->C5_PBRUTO  += ROUND(nTPesoB,1)
                  M->C5_VOLUME1 += nVolume            
                  
	              nQuantidade      := _aCols[nAux][5]-nQtdLote
	              nPreco           := _aCols[nAux][6] 
	              
	              if val(_aCols[nPosicao][1]) <> nAux
	                 _aCols[nAux][1] := STRZERO(Len(_aCols),2)
	              endif	           
	              *
	              _aCols[nAux][5]  := nQtdLote            
	              _aCols[nAux][7]  := A410Arred((nQtdLote*_aCols[nPosicao][6]),"C6_VALOR") 
	              _aCols[nAux][14] := TMP->B8_LOTECTL
                 _aCols[nAux][16] := nQtdLote //15
                 _aCols[nAux][17] := TMP->B8_LOTECTL //20                    
                 _aCols[nAux][19] := TMP->B8_DFABRIC //16                 
                 _aCols[nAux][15] := TMP->B8_DTVALID //17
                 _aCols[nAux][18] := TMP->B8_DTVALID //21
                  *                  
                  RunTrigger(2,nPosicao,nil,,'C6_PRCVEN')
                  nPosicao  += 1  
                  lLoteProd := .T.
                  *
                  if nPosicao > 1
                     AADD(_aCols,AClone(_aCols[nAux]))                     
                     AFILL(_aCols[nAux], STRZERO(Len(_aCols),2), 1, 1)
                     AFILL(_aCols[nAux], nQuantidade, 5, 1)
                     AFILL(_aCols[nAux], A410Arred((nQuantidade*nPreco),"C6_VALOR"), 7, 1)        
                     RunTrigger(2,nAux,nil,,'C6_PRCVEN')
                  endif 
               endif
            endif
         endif      
      endif
      
      TMP->(DBSKIP())
   end 
   if !lLoteProd
      Alert(cMsgHtml)
   endif
else
   Alert(cMsgHtml)
endif
dbSelectArea("TMP")
dbCloseArea()
*

Return Nil



User function RMTA416B(aProduto)
                                                    
Local nAux      := PARAMIXB //Quantidade de linhas no acols.  
Local dDatDia   := DDATABASE
Local aDados    := {}
Local cTitulo   := "Pedidos de vendas gerados"
Local lRet      := .T.
*
cMsgHtml := '<h3>Não existe pedido gerado para o orçamento! '+_aCols[nAux][2]+'<h3>'
//Alert("RMTA416B")
*
_cQry := " SELECT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_NOTA,C5_PEDCLI,C5_SERIE,C6_PRODUTO,SUM(C6_QTDVEN) C6_QTDVEN "
_cQry += " FROM " + RetSqlName("SC5") +" SC5, "+ RetSqlName("SC6")+ " SC6 "
_cQry += " WHERE SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "
_cQry += " AND C5_FILIAL = C6_FILIAL AND C5_NUM  = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA "
_cQry += " AND C5_CLIENTE = '"+SCJ->CJ_CLIENTE+"' AND C5_LOJACLI = '"+SCJ->CJ_LOJA+"'"
_cQry += " AND C6_PRODUTO = '"+_aCols[nAux][2]+"'"
_cQry += " AND C5_PEDCLI = '"+ALLTRIM(StrTran(StrTran(StrTran(SCJ->CJ_COTCLI,"/",""),"-",""),".",""))+"'"
_cQry += " AND C5_EMISSAO BETWEEN '20221001' AND '"+DTOS(dDatDia)+"'"
_cQry += " GROUP BY C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_NOTA,C5_SERIE,C6_PRODUTO,C5_PEDCLI "
*      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.F.)   

*
if !USED()
   MsgBox(_cQry+'. Query errada','Erro!!!','STOP')
endif

count to nReg

dbSelectArea("TMP")
dbGoTop()

*
if !TMP->(Eof())
   While !TMP->(Eof())
         cCliente   := TMP->C5_CLIENTE+"-"+TMP->C5_LOJACLI+" "+LTRIM(Posicione("SA1",1,XFILIAL("SA1")+TMP->C5_CLIENTE+TMP->C5_LOJACLI,"A1_NOME"))
         cOrcamento := SCJ->CJ_NUM
         AaDD(aDados, {TMP->C5_NUM,iif(EMPTY(TMP->C5_NOTA),"",TMP->C5_NOTA+" - "+TMP->C5_SERIE),TMP->C6_PRODUTO,LTRIM(Posicione("SB1",1,XFILIAL("SB1")+TMP->C6_PRODUTO,"B1_DESC")),TMP->C6_QTDVEN,TMP->C5_PEDCLI})
         AaDD(aProduto, {TMP->C5_FILIAL,cOrcamento,cCliente,TMP->C5_NUM,iif(EMPTY(TMP->C5_NOTA),"",TMP->C5_NOTA+" - "+TMP->C5_SERIE),TMP->C6_PRODUTO,LTRIM(Posicione("SB1",1,XFILIAL("SB1")+TMP->C6_PRODUTO,"B1_DESC")),TMP->C6_QTDVEN,TMP->C5_PEDCLI})
         lRet      := .F.
		 TMP->(DBSKIP())
   end 
endif
dbSelectArea("TMP")
dbCloseArea()

if Len(aDados) > 0

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	DEFINE MSDIALOG oDlgACE TITLE cTitulo  FROM  1,0 TO 330,850 OF oMainWnd PIXEL
	
	@ 30,1.0 LISTBOX oLbx1 VAR cVarQ  FIELDS HEADER "Pedido de venda",;
	                                                "Pedido do Cliente",;
													"Nota Fiscal/serie",;
													"Produto",;
                                                    "Descrição",;
													"Quantidade",;
										                    SIZE  420,130 OF oDlgACE  PIXEL ON dblClick()
		
	oLbx1:SetArray(aDados)
	oLbx1:bLine:={|| {aDados[oLbx1:nAt,1],aDados[oLbx1:nAt,6],aDados[oLbx1:nAt,2],aDados[oLbx1:nAt,3],aDados[oLbx1:nAt,4],Transform(aDados[oLbx1:nAt,5],PesqPict("SC6","C6_QTDVEN"))}}                                     
	
   @ 04,001 Say "Cliente:"  Size 100,10 Pixel of oDlgACE
	@ 04,030 Say oCliente Var cCliente Font oBold Color(CLR_RED) Size 250,10 Pixel of oDlgACE
   @ 12,001 Say "Orçamento:"  Size 100,10 Pixel of oDlgACE
	@ 12,030 Say oOrcamento Var cOrcamento  Font oBold Color(CLR_RED) Size 100,10 Pixel of oDlgACE

	@ 010,360 Button oBtnFecha Prompt "Fechar" Size 35,13 Of oDlgACE Pixel Action (Close(oDlgACE))        
	
	ACTIVATE MSDIALOG oDlgACE CENTERED
   
endif

*

Return lRet







User Function RSMTA416()      

	Private oReport, oSection1
	Private nQtd     := 0
	Private nTotQtd  := 0

	oReport := ReportDef()
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()


Return

//=================================================================================
// relatorio de produtividade - formato personalizavel
//=================================================================================
Static Function ReportDef()

	Local cTitulo := 'Relatório de Faturamento por Cliente x Produto Global'

	// Cria as perguntas no SX1                                            
	//?CriaSx1()
	//Pergunte(cPerg,.F.)

	oReport := TReport():New("RRSMTA416", cTitulo, , {|oReport| PrintReport(oReport)},"Emitirá Relatório de pedido já gerados")

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Relatório de pedido já gerados",{""})
	oSection1:SetTotalInLine(.F.)

	
	TRCell():new(oSection1, "C_FIL"  , "", "FILIAL"           ,,10)
	TRCell():new(oSection1, "C_NUM"  , "", "ORÇAMENTO"         ,,10)
	TRCell():new(oSection1, "C_PCLI" , "", "PEDIDO DO CLIENTE" ,,20)
	TRCell():new(oSection1, "C_CLI"  , "", "CLIENTE"           ,,35)
	TRCell():new(oSection1, "C_PED"  , "", "PEDIDO VENDA"      ,,10)
	TRCell():new(oSection1, "C_NF"   , "", "NOTA FISCAL/SERIE" ,,15)
	TRCell():new(oSection1, "C_PRD"  , "", "PRODUTO"           ,,10)
	TRCell():new(oSection1, "C_DESC" , "", "DESCRIÇÃO"         ,,20)
    TRCell():new(oSection1, "C_QTD"  , "", "QUANTIDADE"        ,,10)			
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)

	Local nX := 0

	oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)   
    
 
	For nX:=1 to Len(aProduto)
	
		If oReport:Cancel()
			Exit
		EndIf		

	    oSection1:Cell("C_FIL"):SetValue(aProduto[Nx,1]) 
		oSection1:Cell("C_NUM"):SetValue(aProduto[Nx,2]) 
		oSection1:Cell("C_PCLI"):SetValue(aProduto[Nx,9])  		
        oSection1:Cell("C_CLI"):SetValue(aProduto[Nx,3])	    
        oSection1:Cell("C_PED"):SetValue(aProduto[Nx,4])
        oSection1:Cell("C_NF"):SetValue(aProduto[Nx,5]) 
        oSection1:Cell("C_PRD"):SetValue(aProduto[Nx,6])
      	oSection1:Cell("C_DESC"):SetValue(aProduto[Nx,7])
      	oSection1:Cell("C_QTD"):SetValue(aProduto[Nx,8])		

      	oReport:SkipLine()
      	oSection1:PrintLine() 
		oReport:IncMeter()
	
	next
	oSection1:Finish()

Return
