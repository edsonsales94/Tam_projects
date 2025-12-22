#Include 'Protheus.ch'
#include "RWMAKE.ch"
#include "TbiConn.ch" 

User Function AAFATX95()

    cPerg := Padr("AAFATX95",Len(SX1->X1_GRUPO))
    ValidPerg(cPerg)
    If Pergunte(cPerg,.T.)
       _xdRecno := aClone( getData() )
       Processa({|x| _doExecute(_xdRecno) }, "Executando...")
    EndIf
Return Nil

Static function _doExecute(_xdRec)
     
     ProcRegua(Len(_xdRec))
     For nI := 01 To Len(_xdRec)
         SF2->(dbGoTo(_xdRec[nI]))
         If !SF2->(Eof())
            SZE->(dBSetORder(4)) 
            if !SZE->(dBSeek(xFilial('SZE') + SF2->F2_DOC + SF2->F2_SERIE))
                _PreRomaneio()
            EndIf
         EndIf
     Next
     
Return Nil

Static Function getData()
    _xdRecnos := {}
    _xdTab    := getNextAlias()
       
    _cQry := " "
    _cQry += " SELECT DISTINCT F2.R_E_C_N_O_ RECNO "
    _cQry += " From " + RetSqlName("SD2") + " D2 "
    _cQry += "    inner join " + RetSqlName("SF2") + " F2 ON F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL AND F2_CLIENTE = D2_CLIENTE AND F2.D_E_L_E_T_ = ''
    _cQry += " WHERE D2_FILIAL = '" + mv_par01 + "'"
    _cQry += " AND D2.D_E_L_E_T_ = ''
    _cQry += " AND D2_LOCAL BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
    _cQry += " AND D2_EMISSAO BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "'"
    _cQry += " AND D2_DOC     BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"
    _cQry += " AND D2_SERIE   BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
   
    dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQry),_xdTab,.T.,.T.)    
    While !(_xdTab)->(Eof())
        aAdd( _xdRecnos , (_xdTab)->RECNO )
        (_xdTab)->(dbSkip())
    EndDo
Return _xdRecnos


Static Function ValidPerg()
    PutSX1(cPerg,"01",PADR("Filial ",29)+"?","","","mv_ch4","C",02,0,0,"G","","XX8FIL","","","mv_par01")
    PutSX1(cPerg,"02",PADR("Armazen De",29)+"?","","","mv_ch4","C",02,0,0,"G","","   ","","","mv_par02")
    PutSX1(cPerg,"03",PADR("Armazen Ate",29)+"?","","","mv_ch4","C",02,0,0,"G","","   ","","","mv_par03")
    
    PutSX1(cPerg,"04",PADR("Data De",29)+"?","","","mv_ch4","D",08,0,0,"G","","   ","","","mv_par04")
    PutSX1(cPerg,"05",PADR("Data Ate",29)+"?","","","mv_ch4","D",08,0,0,"G","","   ","","","mv_par05")
    
    PutSX1(cPerg,"06",PADR("Doc De",29)+"?","","","mv_ch4","C",09,0,0,"G","","   ","","","mv_par06")
    PutSX1(cPerg,"07",PADR("Doc Ate",29)+"?","","","mv_ch4","C",09,0,0,"G","","   ","","","mv_par07")
    
    PutSX1(cPerg,"08",PADR("Serie De",29)+"?","","","mv_ch4","C",03,0,0,"G","","   ","","","mv_par08")
    PutSX1(cPerg,"09",PADR("Serie Ate",29)+"?","","","mv_ch4","C",03,0,0,"G","","   ","","","mv_par09")
    
Return


Static Function _PreRomaneio()
Local aPOs     := {}

_cArea := GetArea()
_lUsado := GetMv("MV_XENTFAT")

//If _lUsado
SD2->(DbSetOrder(3))
SD2->(DbSeek( SF2->(F2_FILIAL + F2_DOC  + F2_SERIE+ F2_CLIENTE + F2_LOJA) ) )

SC5->(DbSetOrder(1))
SC5->(DbSeek( xFilial("SC5") + SD2->D2_PEDIDO ))

dbSelectArea("SZE")
RecLock("SZE", .T.)
SZE->ZE_FILIAL  := xFilial("SZE")
SZE->ZE_CLIENTE := SF2->F2_CLIENTE
SZE->ZE_LOJACLI := SF2->F2_LOJA
If SF2->F2_TIPO $ "N,C,P,I"
	SZE->ZE_NOMCLI  := Posicione("SA1", 1, xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA, "A1_NOME")
else
	SZE->ZE_NOMCLI  := Posicione("SA2", 1, xFilial("SA2")+SF2->F2_CLIENTE + SF2->F2_LOJA, "A2_NOME")
end if
SZE->ZE_ORCAMEN := SC5->C5_NUM
SZE->ZE_SEQ     := "01"
SZE->ZE_VALOR   := SF2->F2_VALBRUT
SZE->ZE_DTVENDA := SF2->F2_EMISSAO
SZE->ZE_BAIRRO  := SC5->C5_BAIRROE
SZE->ZE_ORIGEM  := "MATA410"
SZE->ZE_VEND    := SC5->C5_VEND1
SZE->ZE_FILORIG := SC5->C5_FILIAL
SZE->ZE_DOC     := SF2->F2_DOC
SZE->ZE_SERIE   := SF2->F2_SERIE
SZE->ZE_STATUS  := ""
SZE->ZE_PLIQUI  := SF2->F2_PLIQUI
SZE->ZE_PBRUTO  := SF2->F2_PBRUTO

If SZE->(FieldPos("ZE_XORCRES")) > 0 .And. SC5->(FieldPos("C5_XORCRES")) > 0
	SZE->ZE_XORCRES := SC5->C5_XORCRES
EndIf

If SZE->(FieldPos("ZE_XFILRES")) > 0 .And. SC5->(FieldPos("C5_XFILRES")) > 0
	SZE->ZE_XFILRES := SC5->C5_XFILRES
EndIf

//DIEGO RAFAEL
If SZE->(FieldPos("ZE_PEDIDO")) > 0 .And. SC5->(FieldPos("C5_XORCRES")) > 0
	SZE->ZE_PEDIDO := SC5->C5_XORCRES
EndIf

If SZE->(FieldPos("ZE_FILLOJ")) > 0 .And. SC5->(FieldPos("C5_XFILRES")) > 0
	SZE->ZE_FILLOJ := SC5->C5_XFILRES
EndIf

MsUnLock()

u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Inclusao dos Registros")

dbSelectArea("SC6")
dbSkip()
//EndIf

RestArea( _cArea )
Return


