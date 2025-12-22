//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
User Function AAAJUS01

Local adados:={}
Local cQry  :=""

cQry := " SELECT TOP 1 PRD_ANT, C.B1_DESC AS B1_DESCC,C.B1_UM AS B1_UMC, PROD_NEW,D.B1_DESC AS B1_DESCD,D.B1_UM AS B1_UMD, BF_QUANT,BF_LOCAL,BF_LOCALIZ,BF_LOTECTL,B8_DTVALID  FROM PRODJUST A "
cQry += " INNER JOIN SBF010 B ON BF_PRODUTO = A.PRD_ANT AND B.D_E_L_E_T_='' "
cQry += " INNER JOIN SB1010 C ON C.B1_COD = A.PRD_ANT AND C.D_E_L_E_T_=''  "
cQry += " INNER JOIN SB1010 D ON D.B1_COD = A.PROD_NEW AND D.D_E_L_E_T_='' "
cQry += " INNER JOIN SB8010 E ON E.B8_PRODUTO = A.PRD_ANT AND B8_LOCAL = BF_LOCAL AND B8_LOTECTL = BF_LOTECTL "
cQry += " WHERE BF_FILIAL='01' AND BF_QUANT <> 0 AND PRD_ANT IN ('21000122') "
cQry += " ORDER BY PRD_ANT  "

dbUseArea(.T.,"TopConn",TcGenQry(,,ChangeQuery(cQry)),"TRB",.T.,.T.)

While !TRB->(EOF())
    AADD(aDados,{ AllTrim(TRB->PRD_ANT),;
                  TRB->B1_DESCC,;
                  TRB->B1_UMC,;
                  TRB->PROD_NEW,;
                  TRB->B1_DESCD,;
                  TRB->B1_UMD,;
                  TRB->BF_LOCAL,;
                  TRB->BF_LOCALIZ,;
                  TRB->BF_LOTECTL,;
                  TRB->BF_QUANT,;
                  CTOD(TRB->B8_DTVALID) })
     dbSkip()	
EndDo
dbCloseArea("TRB")
GravaTransf(aDados)

Return


Static Function GravaTransf(aLista)


Local nOpcAuto   := 3
Local aAuto      := {}
Local aItem      := {}
Local aLinha     := {}
Local dValid     
Private nModulo  := 4


Begin Transaction

	lMsErroAuto := .F.
	lMsHelpAuto := .T.

    //Cabecalho a Incluir
    aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho
    //B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_DTVALID, R_E_C_N_O_, D_E_L_E_T_
    For nX := 1 to len(alista) 
        
        aLinha := {}
        //Origem 
        //SB1->(DbSeek(xFilial("SB1")+PadR(alista[nX], tamsx3('D3_COD') [1])))
        aadd(aLinha,{"ITEM",'00'+cvaltochar(nX),Nil})
        aadd(aLinha,{"D3_COD", aLista[nX][1], Nil}) //Cod Produto origem 
        aadd(aLinha,{"D3_DESCRI", aLista[nX][2], Nil}) //descr produto origem 
        aadd(aLinha,{"D3_UM", aLista[nX][3], Nil}) //unidade medida origem 
        aadd(aLinha,{"D3_LOCAL", aLista[nX][7], Nil}) //armazem origem 
        aadd(aLinha,{"D3_LOCALIZ", PadR(aLista[nX][8], tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem

        //Destino 
        //SB1->(DbSeek(xFilial("SB1")+PadR(alista[nX+1], tamsx3('D3_COD') [1])))
        aadd(aLinha,{"D3_COD", aLista[nX][4], Nil}) //cod produto destino 
        aadd(aLinha,{"D3_DESCRI", aLista[nX][5], Nil}) //descr produto destino 
        aadd(aLinha,{"D3_UM", aLista[nX][6], Nil}) //unidade medida destino 
        aadd(aLinha,{"D3_LOCAL", aLista[nX][7], Nil}) //armazem destino 
        aadd(aLinha,{"D3_LOCALIZ", PadR(aLista[nX][8], tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino

        aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
        aadd(aLinha,{"D3_LOTECTL", aLista[nX][8], Nil}) //Lote Origem
        aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
        aadd(aLinha,{"D3_DTVALID", aLista[nX][11], Nil}) //data validade 
        aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
        aadd(aLinha,{"D3_QUANT"  , aLista[nX][10], Nil}) //Quantidade
        aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
        aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno 
        aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

        aadd(aLinha,{"D3_LOTECTL", aLista[nX][8], Nil}) //Lote destino
        aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino 
        aadd(aLinha,{"D3_DTVALID", aLista[nX][11], Nil}) //validade lote destino
        aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

        aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
        aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino 

        aAdd(aAuto,aLinha)

    Next nX

    MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

    if lMsErroAuto 
        MostraErro()
        DisarmTransaction()
    EndIf

 End Transaction

Return 
