#include "TBICONN.ch"
#include "Protheus.ch"
#include 'tbiconn.ch'

User Function AAFATP12()
Local cxFilOri     := IIF(SC5->C5_XFILRES = '03','05',IIF(SC5->C5_XFILRES = '04','06',''))
Local cxCont      := 0
Local cxEnder     := ""
Local aParam310    := Array(30)
Local ADADOSTRANSF := {}
Local nwReg        := SC5->(Recno())
Local aSC6REg      := {}
Private _cdPed     := ""
Private _ldInclui  := .T.
Private _ldChange  := .F.
Private aFils      := {cxFilOri,SC5->C5_FILIAL} 
Private cwPed      := SC5->(C5_FILIAL + C5_NUM ) 


CarregaParam(aParam310)

SC6->(dbSetOrder(1))
SC6->(dBSeek(SC5->(C5_FILIAL + C5_NUM ) ))
While SC5->(C5_FILIAL + C5_NUM ) == SC6->(C6_FILIAL + C6_NUM) .And. !SC6->(EOF())
cxCont += 1
If Posicione("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_LOCALIZ") = "S"
    If SC6->C6_LOCAL=="75"
        cxEnder := PADR("SEPARA",TamSX3("BF_LOCALIZ")[1])
    Else
        cxEnder := Alltrim(GetMv("MV_XLOCALI"))
    EndIf
EndIf

If Posicione("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_RASTRO") = "L"
    If SB1->B1_LOCALIZ == "S" .And. GETMV("MV_LOCALIZ") == "S"
        _xdLote := _xdGetLote(cxFilOri,SC6->C6_PRODUTO,"01", cxEnder )
    Else
        _xdLote := _xdGetLote(cxFilOri,SC6->C6_PRODUTO,"01", "" )
    EndIf
EndIf

u_AAVldCliFor("SA1",SC6->C6_FILIAL,.F.)   // Posiciona no cliente
u_AAVldCliFor("SA2",cxFilOri)   // Posiciona no fornecedor

iF SaldoProduto(cxFilOri,SC6->C6_PRODUTO,"01") > SC6->C6_QTDVEN

AADD( aDadosTransf , {cxFilOri ,;
SC6->C6_PRODUTO ,;//02
"01"   ,;//03
SC6->C6_QTDVEN  ,;//04
0,;//05
SC6->C6_FILIAL ,;//06
SC6->C6_LOCAL  ,;//07
SA1->A1_COD,;//08
SA1->A1_LOJA,;//09
SA2->A2_COD,;//10
SA2->A2_LOJA,;//11
"",;//12
"" ,;//13
{ cxCont ,SC6->C6_PRODUTO , SC6->C6_PRCVEN, SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP , SC6->C6_ITEM,SC6->C6_QTDVEN,SC6->(Recno()) }  ,;
IIf(empty(_xdLote),"",_xdLote[1]),;//15
IIf(empty(_xdLote),"",_xdLote[2]),;//16
cxEnder}) //17
aAdd(aSC6REg,SC6->(Recno()) )
Else

Aviso("Retorno","Saldo Insuficiente no Armazem 01 da Empresa de Origem. Produto: " + SC6->C6_PRODUTO ,{"Ok"}) 
Return Nil

ENDIF

SC6->(dbSkip())
EndDo

FATP01Proc(aDadosTransf,aParam310)

SC5->(dbGoTo(nwReg))


SC5->(dbSetOrder(1))
SC5->(dBSeek(cwPed))

lLiber := .T.
lTransf := .F.
lLiberOk := .F.
                    //ConOut('Parada 002')
                    //u_AAFVNX01(cLogName,"Liberando Pedido" + cPedido)
MaAvLibPed( SC5->C5_NUM,lLiber,lTransf,@lLiberOk,aSC6REg)

SC9->(DbSetOrder(1))

//Aviso("Pedido " + SC5->C5_NUM  ,"Retorno",{"Ok"}) 

If SC9->(dbSeek(xFilial('SC9') + SC5->C5_NUM ))
    While !SC9->(Eof()) .And. SC9->C9_FILIAL + SC9->C9_PEDIDO == SC5->C5_FILIAL + SC5->C5_NUM
		//IF !Empty(SC9->C9_BLCRED)
            SC9->(RecLock('SC9',.F.))
			    SC9->C9_BLCRED := ""
                SC9->C9_BLEST  := ""
                If cxFilOri == '05'
                        SC9->C9_LOCAL := '10'
                    Else 
                        SC9->C9_LOCAL := '22'
                EndIf 
             //   Aviso("Pedido " + SC5->C5_NUM  ,"Retorno",{"Ok"}) 
			SC9->(MsUnlock())
        //EndIf 
        SC9->(dbSkip())
    End 
   /* Else 
        SC6->(dbSetOrder(1))
        If SC6->(dbSeek(xFilial("SC6")+ SC5->C5_NUM))
            While !SC6->(Eof()) .And. SC5->(C5_FILIAL + C5_NUM) == SC6->(C6_FILIAL + C6_NUM )
                SC9->(RecLock('SC9',.T.))
                    SC9->C9_FILIAL  := xFilial("SC6")
                    SC9->C9_PEDIDO  := SC6->C6_NUM 
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_CLIENTE := SC6->C6_ITEM
                    SC9->C9_LOJA    := SC6->C6_ITEM
                    SC9->C9_PRODUTO := SC6->C6_ITEM
                    SC9->C9_QTDLIB  := SC6->C6_ITEM
                    SC9->C9_DATALIB := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                    SC9->C9_ITEM    := SC6->C6_ITEM
                SC9->(MsUnlock())
                SC6->(dbSkip())
            End 
        End */
EndIf 
                            
Ma410PvNfs()

u_AAFATE04("SF2",SF2->(Recno()),2)

Return 

Static Function FATP01Proc(aDadosTransf,aParam310)
// Variavel com a filial origem
Local cFilOri   := cFilAnt
// Array com os parametros do programa
Local aParam460:=Array(30)
Local cPedido   := ""
Local cWhile    := ""
Local cSerie    := ""
Local cNotaFeita:= ""
Local aCabec    := {}
Local aItens    := {}
Local aPvlNfs   := {}
Local aBloqueio := {{"","","","","","","",""}}
Local aNotas    := {}
Local aDadosAux := {}
Local nItemNf   := 0
Local nSaveSX8  := 0
Local nAchoSerie:= 0
Local nPrcVen   := 0
Local nPosLocal := 0
Local ni        := 1
Local nx        := 1
Local nZ        := 1
Local aSeries   :={}

// Array com notas geradas
Local aNotaFeita:= {}

// Variaveis para rotina automatica
Local lMostraErro   := .F.
Local cGrade        := "N"
Local aColsAux      := { }
Local lReferencia   := .F.
Local nItGrd        := 0
// Verifica se existe ponto para manipulacao de itens
Local aBackItens:={}
Local aBackCabec:={}
Local lExecItens:=ExistBlock("M310ITENS")
Local lExecCabec:=ExistBlock("M310CABEC")

Private lMsErroAuto := .F.
Private cNumero     := ""
// Variavel utilizada para verificar se o numero da nota foi alterado pelo usuario (notas de saida e entrada
// com formulario proprio).
Private lMudouNum := .F.

For nx :=1 to Len(aDadosTransf)
    If nx == 1 .Or. (aDadosTransf[nx,1] # aDadosTransf[nx-1,1])
        // Atualiza para a filial origem
        cFilant:=aDadosTransf[nx,1]
        // Obtem serie para as notas desta filial
        cSerie  :=""
        cNumero := ""
        //u_AAFVNX01(cLogName,"Selecionando Serie / NF")
        Sx5NumNota(@cSerie,SuperGetMV("MV_TPNRNFS"),cFilAnt)
        // Caso tenha selecionado numero		    
        If !Empty(cNumero)
            AADD(aSeries,{cFilAnt,cSerie,cNumero})
            //u_AAFVNX01(cLogName,'{"Serie":"'+ cSerie +'" , "Numero":"' + cNumero + '" }')
        EndIf
    EndIf
Next nx

Pergunte("MT460A",.F.)
//If Pergunte("MT460A",.F.)
    //?????????????????????????????????
    //? Monta regua de processamento                                 ?
    //?????????????????????????????????
    ProcRegua(Len(aDadosTransf)*2)
    //?????????????????????????????????
    //? Processa geracao de documentos de saida                      ?
    //?????????????????????????????????
    //?????????????????????????????????
    //? Carrega parametros do programa                               ?
    //?????????????????????????????????
    For nx := 1 to 30
        aParam460[nx] := &("mv_par"+StrZero(nx,2))
    Next nx
    // Sorteia array para aglutinar por filial origem e destino
    ASORT(aDadosTransf,,,{|x,y| x[1]+x[6]+x[2]+x[3] < y[1]+y[6]+y[2]+y[3] })
    // Varre array para efetuar gravacoes
    While (ni <= Len(aDadosTransf))

        // Variavel para rotina automatica
        lMsErroAuto := .F.
        // Array auxiliar
        aDadosAux   := {}
        // Atualiza para a filial origem
        cFilant:=aDadosTransf[ni,1]
        // Array para geracao de notas
        aNotas   := {}
        // Arrays com itens e bloqueios
        aPvlNfs  := {}
        aBloqueio:= {}
        // Cabecalho do pedido
        aCabec   := {}
        // Itens do pedido
        aItens   := {}
        // Variavel que controla numeracao
        nSaveSX8 := GetSx8Len()
        // Variavel para processamento
        cWhile:=aDadosTransf[ni,1]+aDadosTransf[ni,6]
        // Obtem serie para as notas desta filial
        nAchoSerie:=ASCAN(aSeries,{|x| x[1] == cFilAnt})
        // Caso tenha selecionado serie para esta filial
        If nAchoSerie > 0
            // Atualiza para a filial destino
            cFilant:=aDadosTransf[ni,6]
            // Verifica se Numero e serie j? foram cadastrados
            dbSelectArea("SF1")
            dbSetOrder(1)
            If MsSeek(xFilial("SF1")+aSeries[nAchoSerie,3]+aSeries[nAchoSerie,2]+aDadosTransf[ni,10])
                Aviso("A numera?? informada para esta transferencia j? possui um documento registrado com a mesma numera??, favor informar uma nova numera??. ","BLA",{"Ok"}) //
                Exit
            EndIf
            // Atualiza para a filial origem
            cFilant:=aDadosTransf[ni,1]
            // Serie para geracao da nota
            cSerie:=aSeries[nAchoSerie,2]
            // Cabecalho do pedido
            //cPedido := GetSxeNum("SC5","C5_NUM")

            cPedido := iIF(_ldInclui,GetSxeNum("SC5","C5_NUM"),_cdPed)

            //u_AAFVNX01(cLogName,"Pega Numero do Pedido" + cPedido)

            RollBAckSx8()
            //u_AAFVNX01(cLogName,"Preenche Cabecalho do Pedido")
            If _ldInclui .Or. _ldChange
                //u_AAFVNX01(cLogName,"Incluindo Novo Pedido")
                aadd(aCabec,{"C5_NUM",cPedido,Nil})
                aadd(aCabec,{"C5_TIPO","N",Nil})
                aadd(aCabec,{"C5_CLIENTE",aDadosTransf[ni,8],Nil})
                aadd(aCabec,{"C5_LOJACLI",aDadosTransf[ni,9],Nil})
                aadd(aCabec,{"C5_LOJAENT",aDadosTransf[ni,9],Nil})
                aadd(aCabec,{"C5_CONDPAG",aParam310[16],Nil})
            Else
                //u_AAFVNX01(cLogName,"Alterando o Pedido Selecionado")
                IF SC5->(dbSeek(xFilial('SC5') + cPedido))
                    aadd(aCabec,{"C5_NUM"    ,cPedido,Nil})
                    aadd(aCabec,{"C5_TIPO"   ,SC5->C5_TIPO,Nil})
                    aadd(aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
                    aadd(aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
                    aadd(aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
                    aadd(aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})

                Else 
                    MsgStop("Pedido N? localizado! ")
                    Return Nil
                EndIf 

            EndIf
            //???????????????????????????????????????
            //? Ponto de entrada para ALTERAR os dados do cabecalho do pedido de vendas  ?
            //???????????????????????????????????????
            If lExecCabec
                aBackCabec:=ACLONE(aCabec)
                aCabec:=ExecBlock("M310CABEC",.F.,.F.,{"MATA410",aCabec})
                If ValType(aCabec) # "A"
                    aCabec:=ACLONE(aBackCabec)
                EndIf
            EndIf
            // Contador dos itens
            nx:=0
            cItemPed := StrZero(0,TamSX3("C6_ITEM")[1])
            nItGrd:=0
            // ATENCAO - VARIAVEL CRIADAS POR CAUSA DA QUEBRA NO FATURAMENTO
            aNotaFeita:={}
            _adReg := {}
            _adReg2:= {}
            If !_ldInclui
                SC6->(dbSetOrder(1))
                SC6->(dbSeek(xFilial('SC6') + cPedido))
                cItemPed := ""
                aItens := {}
                //u_AAFVNX01(cLogName,"Preenchendo os Itens")
                While xFilial('SC6') + cPedido == SC6->C6_FILIAL + SC6->C6_NUM
                    aLinha := {}
                    aadd(aLinha,{"C6_ITEM"   ,SC6->C6_ITEM    ,Nil})
                    aadd(aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO ,Nil})
                    aadd(aLinha,{"C6_LOCAL"  ,SC6->C6_LOCAL   ,Nil})
                    aadd(aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN  ,Nil})
                    aadd(aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN  ,Nil})
                    aadd(aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT  ,Nil})
                    aadd(aLinha,{"C6_VALOR"  ,SC6->C6_VALOR   ,Nil})
                    aadd(aLinha,{"C6_TES"    ,SC6->C6_TES     ,Nil})
                    aadd(aLinha,{"C6_GRADE"  ,SC6->C6_GRADE   ,Nil})
                    aadd(aLinha,{"C6_ITEMGRD",SC6->C6_ITEMGRD ,Nil})
                    aadd(aLinha,{"C6_QTDLIB" ,0               ,Nil})

                    If Rastro(SC6->C6_PRODUTO,"L")
                        aadd(aLinha,{"C6_LOTECTL",SC6->C6_LOTECTL  ,Nil})
                        aadd(aLinha,{"C6_DTVALID",SC6->C6_DTVALID  ,Nil})
                    EndIf
                    If Rastro(SC6->C6_PRODUTO,"S")
                        aadd(aLinha,{"C6_NUMLOTE",SC6->C6_NUMLOTE ,Nil})
                        aadd(aLinha,{"C6_DTVALID",SC6->C6_DTVALID,Nil})
                    EndIf

                    aadd(aItens,aLinha)
                    //aadd(aLinha,{"C6_QTDLIB" ,aDadosTransf[ni,4],Nil})
                    If cItemPed < SC6->C6_ITEM
                        cItemPed := SC6->C6_ITEM
                    EndIf
                    SC6->(dbSkip())
                EndDo
            EndIf

            While (ni <= Len(aDadosTransf)) .And. (aDadosTransf[ni,1]+aDadosTransf[ni,6] == cWhile)
                // Incrementa regua de processamento
                IncProc()
                aLinha := {}
                cGrade:="N"
                // Obtem preco de venda do produto
                If aParam310[17] == 1
                    SA1->(dbSetOrder(1))
                    SA1->(dbSeek(xFilial("SA1")+aDadosTransf[ni,8]+aDadosTransf[ni,9]))
                    nPrcVen := MaTabPrVen(SA1->A1_TABELA,aDadosTransf[ni,2],aDadosTransf[ni,4],aDadosTransf[ni,8],aDadosTransf[ni,9],1,dDataBase)
                    // Obtem preco - custo standard
                ElseIf aParam310[17] == 2
                    nPrcVen := Posicione("SB1",1,xFilial("SB1")+aDadosTransf[ni,2],"B1_CUSTD")
                    // Obtem preco - ultimo preco de compra
                ElseIf aParam310[17] == 3
                    nPrcVen := Posicione("SB1",1,xFilial("SB1")+aDadosTransf[ni,2],"B1_UPRC")
                    // Obtem preco - custo medio unitario do armazem
                ElseIf aParam310[17] == 4
                    SB2->(dbSetOrder(1))
                    If SB2->(dbSeek(xFilial("SB2")+aDadosTransf[ni,2]+aDadosTransf[ni,3]))
                        nPrcVen:=SB2->B2_CM1
                    EndIf
                EndIf
                // Senao encontrou nenhum valor assume 1				
                If !Empty(_cdPed)
                    _ndPos := aScan(_adPed, {| x | Alltrim(x[02]) == Alltrim(aDadosTransf[ni,2]) } )
                    If _ndPos != 0
                        //nPrcVen := _adPed[_ndPos][03]
                    EndIf
                EndIf

                If QtdComp(nPrcVen,.T.) == QtdComp(0,.T.)
                    nPrcVen := 1
                EndIf
                cProdRef:=aDadosTransf[ni,2]
                lReferencia:=MatGrdPrrf(@cProdRef,.T.)
                If lReferencia
                    nAchou:=AScan(aColsAux,{|x|x[1]==cProdRef.and. x[2]==aDadosTransf[ni,3]})
                    If nAchou >0
                        nx:=AcolsAux[nAchou,3]
                        nItGrd ++
                        cItemPed := StrZero(0,TamSX3("C6_ITEM")[1])
                    Else
                        nx++
                        nItGrd:=1
                        aadd(aColsAux,{cProdref,aDadosTransf[ni,3],nx,nItGrd})
                    Endif
                    cGrade:="S"
                Else
                    nx++
                Endif

                _xdPos := aScan(aItens,{|x| x[ aScan(x,{|y| Alltrim(y[01])=="C6_PRODUTO"}) ][02] == aDadosTransf[ni,2] .And.;
                x[ aScan(x,{|y| Alltrim(y[01])=="C6_ITEM"}) ][02] == aDadosTransf[ni,14][05] } )

                If !_ldInclui .And. _xdPos > 0
                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_LOCAL"} )
                    aItens[_xdPos][_ydPos][02] := aDadosTransf[ni,3]
                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_QTDVEN"} )
                    _ndQuant := aItens[_xdPos][_ydPos][02]

                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_VALOR"} )
                    aItens[_xdPos][_ydPos][02] := A410Arred((_ndQuant*nPrcVen),"C6_VALOR")

                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_PRCVEN"} )
                    aItens[_xdPos][_ydPos][02] := nPrcVen

                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_PRUNIT"} )
                    aItens[_xdPos][_ydPos][02] := nPrcVen

                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_TES"} )
                    aItens[_xdPos][_ydPos][02] := aParam310[13]

                    _ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_QTDLIB"} )
                    aItens[_xdPos][_ydPos][02] := aDadosTransf[ni,4]

                    SC6->(dbGoTo(aDadosTransf[ni,14][07]))
                    aAdd(_adReg , SC6->(Recno()) )
                    aAdd(_adReg2,{SC6->(Recno()), aDadosTransf[ni,4] } )

                Else
                    aadd(aLinha,{"C6_ITEM"   ,cItemPed:=Soma1(cItemPed),Nil})
                    aadd(aLinha,{"C6_PRODUTO",aDadosTransf[ni,2],Nil})
                    aadd(aLinha,{"C6_LOCAL"  ,aDadosTransf[ni,3],Nil})
                    aadd(aLinha,{"C6_QTDVEN" ,aDadosTransf[ni,4],Nil})
                    _ndTotal := A410Arred((aDadosTransf[ni,4]*nPrcVen),"C6_VALOR")
                    aadd(aLinha,{"C6_PRCVEN" ,nPrcVen  ,Nil})
                    aadd(aLinha,{"C6_PRUNIT" ,nPrcVen  ,Nil})
                    aadd(aLinha,{"C6_VALOR"  ,_ndTotal ,Nil})
                    aadd(aLinha,{"C6_TES"    ,aParam310[13],Nil})
                    aadd(aLinha,{"C6_GRADE"   ,cGrade,Nil})
                    aadd(aLinha,{"C6_ITEMGRD",If(cGrade=="S",Strzero(nItGrd,2)," "),Nil})
                    aadd(aLinha,{"C6_QTDLIB" ,Iif(_ldInclui .Or. aFils[1]=="01" ,0 ,aDadosTransf[ni,4]) ,Nil})

                    SB1->(dbSetOrder(1))
                    SB1->(dbSeek(xFilial('SB1') + aDadosTransf[ni,2] ))

                    //If Rastro(SB1->B1_COD,"L") .And. GetMv("MV_RASTRO")
                    //_xdLote := _xdGetLote(SB1->B1_COD,aDadosTransf[ni,3] )
                    If Rastro(SB1->B1_COD,"L")
                        aadd(aLinha,{"C6_LOTECTL",aDadosTransf[ni,15] ,Nil})
                        aadd(aLinha,{"C6_DTVALID",aDadosTransf[ni,16] ,Nil})
                    EndIF
                    If Rastro(SB1->B1_COD,"S")
                        aadd(aLinha,{"C6_NUMLOTE",aDadosTransf[ni,15] ,Nil})
                        aadd(aLinha,{"C6_DTVALID",aDadosTransf[ni,16] ,Nil})
                    EndIF
                    If GetMv("MV_LOCALIZ") == 'S'
                        aadd(aLinha,{"C6_LOCALIZ",aDadosTransf[ni,17] ,Nil})
                    EndIf
               
                    aadd(aItens,aLinha)
                    aadd(aDadosAux,{cPedido,StrZero(nx,2),aDadosTransf[ni,7]})
               
                EndIf
                // Incrementa contadores
                //nx++
                ni++
            End
            //?????????????????????????????????
            //? Ponto de entrada para ALTERAR os dados do pedido de vendas   ?
            //?????????????????????????????????
            If lExecItens
                aBackItens:=ACLONE(aItens)
                aItens:=ExecBlock("M310ITENS",.F.,.F.,{"MATA410",aItens})
                If ValType(aItens) # "A"
                    aItens:=ACLONE(aBackItens)
                EndIf
            EndIf

            //Exclui o Pedido antes de Inclui-lo Novamente
            If !_ldInclui

                //ConOut('Parada 001')
                //u_AAFVNX01(cLogName,"Alterando Pedido - " + cPedido)
                //Essa parte do Fonte estava comentada no dia 21/01/2020 - As transf?ncias da Matriz para as Filiais n? estavam funcionando.
                //Retirei o coment?rio para que a rotina efetuasse a altera?? do Pedido....e gerou normalmente a Nota Ap?s isso.
                //Williams Messa.
                MATA410(aCabec,aItens,4 ) 
                If !aFils[1]=="01"
                    //if ! lMsErroAuto
                    lLiber := .T.
                    lTransf := .F.
                    lLiberOk := .F.
                    //ConOut('Parada 002')
                    //u_AAFVNX01(cLogName,"Liberando Pedido" + cPedido)
                    MaAvLibPed( cPedido,lLiber,lTransf,@lLiberOk,_adReg)//,,lEstLib,lAvCred,Nil,@nVlrCred)
                    //if
                    If !lMsErroAuto
                        SC5->(dbSetOrder(1))
                        If SC5->(dbSeek(cFilAnt + cPedido))
                            SC5->(RecLock('SC5',.F.))
                            //SC5->C5_LIBEROK := 'S'
                            SC5->(MsUnlock())
                        EndIf
                        For _ndI := 01 to Len(_adReg2)
                            SC6->(dbGoTo(_adReg2[_ndI][01] ))
                            SC9->(dbSetOrder(2))
                            SC9->(dbSeek(xFilial('SC9') + SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_NUM + SC6->C6_ITEM))
                            While SC9->(Eof()) .And. xFilial('SC9') + SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_NUM + SC6->C6_ITEM ==;
                            SC9->C9_FILIAL + SC9->C9_CLIENTE + SC9->C9_LOJA + SC9->C9_PEDIDO + SC9->C9_ITEM
                                If SC9->C9_QTDLIB == _adReg2[_ndI][02] .And. SC9->C9_DATALIB = dDataBase .And. Len(Rtrim(C9_NFISCAL)) == 0
                                    lHelp := .T.
                                    //u_AAFVNX01(cLogName,"Liberando Item do Pedido para Faturamento ")
                                    a450Grava(1,.T.,.T.,@lHelp)
                                    SC9->(dbGoTo(SC9->( lastrec() )))
                                EndIf
                                SC9->(dbSkip())
                            EndDo
                        Next
                    Else
                        Aviso('Aten??','Libera?? de Pedido N? Efetuada',{'OK'})
                        lMsErroAuto := .T.
                    EndIf
                EndIf

            Else
                //u_AAFVNX01(cLogName,"Incluindo Pedido")
                MATA410(aCabec,aItens,3 )
            EndIf

            // Inclusao do pedido			
            // Checa erro de rotina automatica
            If lMsErroAuto
                lMostraErro	:=.T.
            Else
                // Confirma SX8
                While ( GetSx8Len() > nSaveSX8 )
                    ConfirmSX8()
                Enddo
                // Liberacao de pedido
                If _ldInclui
                    //u_AAFVNX01(cLogName,"Liberando Pedido para Faturamento")
                    Ma410LbNfs(2,@aPvlNfs,@aBloqueio)				
                EndIf
                // Checa itens liberados
                Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
                // Caso tenha itens liberados manda faturar
                If Empty(aBloqueio) .And. !Empty(aPvlNfs)
                    nItemNf  := a460NumIt(cSerie)
                    aadd(aNotas,{})
                    // Efetua as quebras de acordo com o numero de itens
                    For nX := 1 To Len(aPvlNfs)
                        If Len(aNotas[Len(aNotas)])>=nItemNf
                            aadd(aNotas,{})
                        EndIf
                        aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
                    Next nX
                    // Gera as notas de acordo com a quebra
                    For nX := 1 To Len(aNotas)
                        //u_AAFVNX01(cLogName,"Efetuando Faturamento")
                        cNotaFeita:=MaPvlNfs(aNotas[nX],cSerie,aParam460[01]==1,aParam460[02]==1,aParam460[03]==1,aParam460[04]==1,aParam460[05]==1,aParam460[07],aParam460[08],aParam460[16]==1,aParam460[16]==2)
                        AADD(aNotaFeita,cNotaFeita)
                        //u_AAFVNX01(cLogName,"Nota de Saida Gerada: " + cNotaFeita)
                        //TransNfe(cSerie,cNotaFeita)
                        //getAuthNFE(cSerie,cNotaFeita)
                    Next nX
                    // Varre notas fiscais de saida geradas para gerar notas fiscais de entrada
                    //u_AAFVNX01(cLogName,"Gerando Entrada dos  dados de Saida Gerado")
                    For nx:=1 to Len(aNotaFeita)
                        aColsAux:={}
                        nItem   :=0
                        nItGrd  :=0

                        //Diego em 21/06/2018 Atualizar os Campos referente a Transfer?ncia
                        //de Filiais padr?es do sistema
                        SF2->(dbSetOrder(1))
                        If SF2->(dbSeek(xFilial('SF2') + aNotaFeita[nx] + cSerie + aDadosTransf[ni-1,8] + aDadosTransf[ni-1,9] ))
                            SF2->(RecLock('SF2',.F.))							   
                            SF2->F2_FILDEST := aDadosTransf[ni-1,6]
                            SF2->F2_FORDES  := aDadosTransf[ni-1,10]
                            SF2->F2_LOJADES := aDadosTransf[ni-1,11]
                            SF2->F2_FORMDES := "N"
                            SF2->(MsUnlock())
                        EndIf

                        dbSelectArea("SD2")
                        dbSetOrder(3)							
                        If dbSeek(xFilial("SD2")+aNotaFeita[nx]+cSerie+aDadosTransf[ni-1,8]+aDadosTransf[ni-1,9])

                            // Cabecalho da nota fiscal de entrada
                            aCabec   := {}
                            aadd(aCabec,{"F1_TIPO"   ,"N"})
                            aadd(aCabec,{"F1_FORMUL" ,"N"})
                            aadd(aCabec,{"F1_DOC"    ,aNotaFeita[nx]})
                            aadd(aCabec,{"F1_SERIE"  ,cSerie})
                            aadd(aCabec,{"F1_EMISSAO",dDataBase})
                            aadd(aCabec,{"F1_FORNECE",aDadosTransf[ni-1,10]})
                            aadd(aCabec,{"F1_LOJA"   ,aDadosTransf[ni-1,11]})
                            aadd(aCabec,{"F1_ESPECIE","SPED"}) //aadd(aCabec,{"F1_ESPECIE","NFE"}) Alterado Por Hely para grava a ESPECIE correta (SPED)
                            aadd(aCabec,{"F1_COND",aParam310[16]})
                            //???????????????????????????????????????
                            //? Ponto de entrada para ALTERAR os dados do cabecalho do Documento Entrada ?
                            //???????????????????????????????????????
                            If lExecCabec
                                aBackCabec:=ACLONE(aCabec)
                                aCabec:=ExecBlock("M310CABEC",.F.,.F.,{If(aParam310[14] == 1,"MATA140","MATA103"),aCabec})
                                If ValType(aCabec) # "A"
                                    aCabec:=ACLONE(aBackCabec)
                                EndIf
                            EndIf
                            // Itens da nota fiscal de entrada
                            aItens   := {}
                            //u_AAFVNX01(cLogName,"Posicionando nos Itens de Saida")
                            While !Eof() .And. xFilial("SD2")+aNotaFeita[nx]+cSerie+aDadosTransf[ni-1,8]+aDadosTransf[ni-1,9] == D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
                                // Incrementa regua de processamento
                                IncProc()
                                cGrade:="N"
                                aLinha := {}
                                cProdRef:=SD2->D2_COD
                                lReferencia:=MatGrdPrrf(@cProdRef,.T.)
                                If lReferencia
                                    nAchou:=AScan(aColsAux,{|x|x[1]==cProdRef.and. x[2]==aDadosTransf[ni-1,7]})
                                    If nAchou >0
                                        nItem:=AcolsAux[nAchou,3]
                                        nItgrd ++
                                    Else
                                        nItem++
                                        nItgrd:=1
                                        aadd(aColsAux,{cProdRef,aDadosTransf[ni-1,7],nItem,nItGrd})
                                    Endif
                                    cGrade:="S"
                                Else
                                    nItem++
                                Endif
                                aadd(aLinha,{"D1_ITEM",Strzero(nItem,4),Nil})
                                aadd(aLinha,{"D1_COD",SD2->D2_COD,Nil})
                                aadd(aLinha,{"D1_QUANT",SD2->D2_QUANT,Nil})
                                aadd(aLinha,{"D1_VUNIT",SD2->D2_PRCVEN,Nil})
                                aadd(aLinha,{"D1_TOTAL",SD2->D2_TOTAL,Nil})
                                //-- Pesquisa armazem destino
                                nPosLsocal := Ascan(aDadosAux,{|x| x[1]+x[2] == SD2->D2_PEDIDO+SD2->D2_ITEMPV})
                                If nPosLocal > 0
                                    aadd(aLinha,{"D1_LOCAL"	,aDadosAux[nPosLocal,3]	,Nil})
                                    //u_AAFVNX01(cLogName,"Adicionando ao aLinha " + aDadosAux[nPosLocal,3] )
                                Else
                                    aadd(aLinha,{"D1_LOCAL"	,aDadosTransf[ni-1,7]	,Nil})
                                    //u_AAFVNX01(cLogName,"Adicionando ao aLinha " + aDadosTransf[ni-1,7] )
                                EndIf

                                aadd(aLinha,{"D1_GRADE",cGrade,Nil})
                                aadd(aLinha,{"D1_ITEMGRD",If(cGrade=="S",Strzero(nItGrd,2)," "),Nil})
                                // Checa geracao de documento
                                If aParam310[14] == 2
                                    aadd(aLinha,{"D1_TES",aParam310[15],Nil})
                                    // Checa se utiliza rastreabilidade
                                    cFilBkp := cFilAnt
                                    cFilant:=aDadosTransf[ni-1,6]
                                    If Rastro(SD2->D2_COD,"L")
                                        aadd(aLinha,{"D1_LOTECTL",SD2->D2_LOTECTL,Nil})
                                        aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
                                    EndIf
                                    If Rastro(SD2->D2_COD,"S")
                                        aadd(aLinha,{"D1_NUMLOTE",SD2->D2_NUMLOTE,Nil})
                                        aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
                                    EndIf
                                    cFilAnt := cFilBkp
                                EndIf
                                aadd(aItens,aLinha)

                                dbSelectArea("SD2")
                                dbSkip()
                            End
                            // Caso tenha itens e cabecalho definidos
                            If Len(aItens) > 0 .And. Len(aCabec) > 0
                                // Atualiza para a filial destino
                                cFilant:=aDadosTransf[ni-1,6]
                                // Reinicializa ambiente para o fiscal
                                If MaFisFound()
                                    MaFisEnd()
                                EndIf
                                //?????????????????????????????????
                                //? Ponto de entrada para ALTERAR os dados do pedido de vendas   ?
                                //?????????????????????????????????
                                If lExecItens
                                    aBackItens:=ACLONE(aItens)
                                    aItens:=ExecBlock("M310ITENS",.F.,.F.,{If(aParam310[14] == 1,"MATA140","MATA103"),aItens})
                                    If ValType(aItens) # "A"
                                        aItens:=ACLONE(aBackItens)
                                    EndIf
                                EndIf

                                // Atribui o m?dulo 4 (Estoque) para n? ocorrer erro nas rotinas abaixo
                                nAux := nModulo
                                nModulo := 4

                                // Checa geracao de documento

                                If aParam310[14] == 2
                                    //u_AAFVNX01(cLogName,"Incluindo NF de Entrada")
                                    // Inclui nota de entrada
                                    MATA103(aCabec,aItens,3)
                                Else
                                    //u_AAFVNX01(cLogName,"Incluindo Pre Nota de Entrada")
                                    // Inclui pre-nota
                                    MATA140(aCabec,aItens,3)
                                EndIf

                                // Volta o m?dulo 4 (Estoque) ap?s a grava?? da nota de entrada
                                nModulo := nAux

                                // Checa erro de rotina automatica
                                If lMsErroAuto
                                    lMostraErro	:=.T.
                                EndIf
                                // Atualiza para a filial origem
                                cFilant:=aDadosTransf[ni-1,1]
                            EndIf
                        EndIf
                    Next nx
                EndIf
            EndIf
        Else
            // A filial XX nao teve uma serie de nota fiscal de saida selecionada para geracao
            Help(" ",1,"A310SERERR",,cFilAnt,1,10)
            // Variavel para processamento
            cWhile:=aDadosTransf[ni,1]
            // Varre todos os itens com esta filial origem
            While (ni <= Len(aDadosTransf)) .And. aDadosTransf[ni,1] == cWhile
                // Incrementa regua de processamento
                IncProc()
                ni++
            End
        EndIf
    End
//EndIf
// Restaura filial original
cFilAnt:=cFilOri
// Mostra erro em rotina automatica
If lMostraErro
    Mostraerro()
EndIf

RETURN


Static Function CarregaParam(aParam310)
	aParam310[01] := Repli(" ",TamSX3("B1_COD"   )[1])
	aParam310[02] := Repli("Z",TamSX3("B1_COD"   )[1])
	aParam310[03] := Repli(" ",TamSX3("B1_FILIAL")[1])
	aParam310[04] := Repli("Z",TamSX3("B1_FILIAL")[1])
	aParam310[05] := Repli(" ",TamSX3("B1_LOCPAD")[1])
	aParam310[06] := Repli("Z",TamSX3("B1_LOCPAD")[1])
	aParam310[07] := Repli(" ",TamSX3("B1_TIPO"  )[1])
	aParam310[08] := Repli("Z",TamSX3("B1_TIPO"  )[1])
	aParam310[09] := Repli(" ",TamSX3("B1_GRUPO" )[1])
	aParam310[10] := Repli("Z",TamSX3("B1_GRUPO" )[1])
	aParam310[11] := 2  // N?
	aParam310[12] := 1  // Produto
	aParam310[13] := "536"
	aParam310[14] := 2
	aParam310[15] := "027"
	aParam310[16] := "449"
	aParam310[17] := 2
	aParam310[18] := 2
	aParam310[19] := 2
Return


Static Function _xdGetLote(_xdFilial,_xdProduto,_xdLocal,_xdLocaliz)

	_xdLote  := {}
	_xdOption:= ""
	_xdParm  := ""
	If SuperGetMv("MV_XLOTETR",.T.)
		_xdParm := Alltrim(GetMv("MV_XLOTETR"))
	EndIf

	If SuperGetMv("MV_XOPTLOT",.T.)
		_xdOption := Alltrim(GetMv("MV_XOPTLOT"))
		If !_xdOption$"MAX/MIN/PARM/PARAMETRO "
			Alert(" CONTEUDO DO PARAMETRO 'MV_XOPTLOT' INVALIDO ")
		EndIf
	EndIf

	If _xdOption$"MAX/MIN" .Or. Len(Alltrim(_xdParm)) == 0

		_xdQry   := "" 
		_xdQry   += " Select TOP 1 * From " + RetSqlName("SB8") + " B8 "
		If Len(Alltrim(_xdLocaliz)) > 0
			_xdQry   += "   Inner Join " + RetSqlName("SBF") + " BF ON BF.D_E_L_E_T_ =  ' ' 
			_xdQry   += "      										AND BF_LOTECTL = B8_LOTECTL 
			_xdQry   += " 											AND BF_FILIAL = B8_FILIAL 
			_xdQry   += " 											AND BF_LOCALIZ ='" + _xdLocaliz + "' 
			_xdQry   += " 											And BF_LOCAL = B8_LOCAL  
			_xdQry   += " 											AND BF_PRODUTO = B8_PRODUTO "
		EndIf
		_xdQry   += " Where B8.D_E_L_E_T_ = '' "
		_xdQry   += "  AND B8_DTVALID >= '" + DTOS(dDataBase) + "' "
		_xdQry   += "  And B8_PRODUTO = '" + _xdProduto + "'"
		_xdQry   += "  And B8_LOCAL = '" + _xdLocal + "'"
		_xdQry   += "  And B8_FILIAL = '" + _xdFilial + "'"
		_xdQry   += " Order By B8_DTVALID "  + iIf(_xdOption == "MAX"," DESC "," ASC ")    	    	
	Else    	
		_xdQry   := "" 
		_xdQry   += " Select TOP 1 * From " + RetSqlName("SB8") + " B8 "
		If Len(Alltrim(_xdLocaliz)) > 0
			_xdQry   += "   Inner Join " + RetSqlName("SBF") + " BF ON BF.D_E_L_E_T_ =  ' ' 
			_xdQry   += "      										AND BF_LOTECTL = B8_LOTECTL 
			_xdQry   += " 											AND BF_FILIAL = B8_FILIAL 
			_xdQry   += " 											AND BF_LOCALIZ ='" + _xdLocaliz + "' 
			_xdQry   += " 											And BF_LOCAL = B8_LOCAL  
			_xdQry   += " 											AND BF_PRODUTO = B8_PRODUTO "
		EndIf
		_xdQry   += " Where D_E_L_E_T_ = '' "
		_xdQry   += "  AND B8_DTVALID >= '" + DTOS(dDataBase) + "' "
		_xdQry   += "  And B8_PRODUTO = '" + _xdProduto + "' "
		_xdQry   += "  And B8_LOCAL = '" + _xdLocal + "' "
		_xdQry   += "  And B8_LOTECTL = '" + _xdParm + "'"
		_xdQry   += "  And B8_FILIAL = '" + _xdFilial + "'"
		_xdQry   += " Order By B8_DTVALID "  + iIf(_xdOption == "MAX"," DESC "," ASC ")	
	EndIf    

	_xdAls := MPSysOpenQuery(_xdQry)

	If !(_xdAls)->(EOF())
		aAdd(_xdLote , (_xdAls)->B8_LOTECTL )
		aAdd(_xdLote , STOD( (_xdAls)->B8_DTVALID) )
		If Len(Alltrim(_xdLocaliz)) > 0
			aAdd(_xdLote ,  (_xdAls)->BF_QUANT )
		Else
			aAdd(_xdLote ,  (_xdAls)->B8_SALDO )
		EndIf
	Else
		//Alert("Nenhum LOTE Valido Encontrado para esta transfer?ncia para o Produto:  " + _xdProduto + " No Armazen " + _xdLocal )
		_xdLote := {}
	EndIf

Return _xdLote

Static Function _xdGetLocaliz(_xdFilial,_xdProduto,_xdLocal,_xdLocaliz)

	_xdLocaliz := {}

	_xdQry := " Select * from " + RetSqlName("SBF") + " BF " 
	_xdQry += "   Where BF.D_E_L_E_T_ = ' ' "
	_xdQry += "     And BF_FILIAL = '" + _xdFilial + "'"
	_xdQry += "     And BF_PRODUTO = '" + _xdProduto + "'"
	_xdQry += "     And BF_LOCAL   = '" + _xdLocal   + "'"
	_xdQry += "     And BF_LOCALIZ = '" + _xdLocaliz + "'"

	_xdAls := MPSysOpenQuery(_xdQry)

	If !(_xdAls)->(EOF())
		_xdLocaliz := (_xdAls)->BF_QUANT 
	Else
		_xdLocaliz := 0
	EndIf
Return _xdLocaliz



Static Function SaldoProduto(cCodFil,cProduto,cLocal)
	Local nRet := 0

	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(cCodFil+cProduto+cLocal))
		// Pega o saldo atual em estoque
		nRet := SB2->(B2_QATU - If( B2_RESERVA > 0 , B2_RESERVA, 0))
		
	Endif

Return nRet
