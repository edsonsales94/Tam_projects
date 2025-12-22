//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//---------------------------------------------------------------------------------------------------------//
// AAPONA01.PRW - Programa para realizar o Rateio das Horas Extras X Banco de Horas...                     //
//---------------------------------------------------------------------------------------------------------//
// Autor: Jorge S. da Silva     data: 07/03/2024                                                           //
//---------------------------------------------------------------------------------------------------------//

User Function AAPONA01() 

    Local _cPerg    := Padr("AAPONA01",Len(SX1->X1_GRUPO))
    ValidPerg(_cPerg)
    If Pergunte(_cPerg,.T.)
       Processa({|x| _doExecute() }, "Executando...")
    EndIf
Return Nil

*********************************
Static function _doExecute()
*********************************

Private xGrv := .T.
cTable := getNextAlias()

cQry := ""
cQry += " SELECT "
cQry += " PC_MAT, PC_DATA, PC_PD, PC_PERCENT, PC_QUANTC, PC_PDI, PC_QUANTI, PC_CC, PC_DATAALT, "
cQry += " PC_TIPOHE, PC_HORAALT, PC_TURNO, PC_SEMANA, PC_PERCENT, PC_USUARIO, R_E_C_N_O_ RECS "
cQry += " FROM " + RetSqlName("SPC") + " SPC"
cQry += " WHERE D_E_L_E_T_ = ''"
cQry += " AND PC_FILIAL = '"+xFilial("SPC")+"'"
cQry += " AND PC_DATA BETWEEN '"+Dtos(MV_par01)+"' AND '"+Dtos(MV_par02)+"'"
cQry += " AND PC_MAT  BETWEEN '"+MV_par03+"' AND '"+MV_par04+"'"
cQry += " AND PC_CC   BETWEEN '"+MV_par08+"' AND '"+MV_par09+"'"
cQry += " AND PC_PD   IN ('211','212','213','214','215') "
cQry += " ORDER BY PC_DATA, PC_MAT, PC_PD"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable, .T., .F. )
TCSETFIELD(cTable,"PC_DATA","D",8,0)
dbSelectArea(cTable)

//qout(cQry)

ProcRegua(RecCount())
dbGoTop()

while !(cTable)->(EOF())

    IncProc()

    xGrv := .T.
    xInc := .F.   
    xPDI := ""

    // Dados do Apontamento Original
    xMAT     := (cTable)->PC_MAT
    xDATA    := (cTable)->PC_DATA
    xPD      := (cTable)->PC_PD
    xQUANTC  := (cTable)->PC_QUANTC
    xCC      := (cTable)->PC_CC
    xTURNO   := (cTable)->PC_TURNO
    xSEMANA  := (cTable)->PC_SEMANA
    xPERCENT := (cTable)->PC_PERCENT
    xTIPOHE  := (cTable)->PC_TIPOHE
    xDATAALT := (cTable)->PC_DATAALT
    xUSUARIO := (cTable)->PC_USUARIO
    
    // transforma os minutos de centesimal em sexagesimal
    xHora   := Int(xQUANTC)
    xMinuto := (xQUANTC - xHora)
    xHr50   := (xHora / 2)
    xIntHr  := Int(xHr50)
    xMnHr   := (xHr50 - xIntHr)
    xEx     := (xMnHr * 60 / 100)
    xQtdHr  := (xIntHr + xEx)
    xMn50   := (xMinuto / 2 )
    xQuantI := (xQtdHr + xMn50)


    // Define a Verba de Hr.Ext, conforme Verba de Bc.Hrs
    If (cTable)->PC_PD = '214' // '201'
        xPDI := '201' //214'
    ElseIf (cTable)->PC_PD = '211' // '203'
        xPDI := '203' //211'
    ElseIf (cTable)->PC_PD = '215' // '204'
        xPDI := '204' //'215'
    ElseIf (cTable)->PC_PD = '212' // '205'
        xPDI := '205' // '212'
    ElseIf (cTable)->PC_PD = '213' // '206'
        xPDI := '206' // '213'
    EndIf


    // 100% Horas Extras
    If (cTable)->(DTOC(PC_DATA) $ mv_par05)
        xQuantI := (cTable)->PC_QUANTC
    Else
        xInc := .T.    
    EndiF

    // 100% Banco de Horas
    If (cTable)->(DTOC(PC_DATA) $ mv_par06)
        xGrv := .F.
    EndiF

    // Matriculas com 100% das Hr.Extras
    If (cTable)->PC_MAT $ mv_par07
        xGrv := .F.
        xInc := .F.
    EndiF

    // C.de Custos com 100% das Hr.Extras
    //If (cTable)->PC_CC $ mv_par10
    If Alltrim(xCC) $ mv_par10
        xGrv  := .F.
        xInc := .F.
    EndiF

    If xGrv .And. AllTrim(xUSUARIO) <> 'AAPONA01'
	    dbSelectArea("SPC")
        SPC->(DbGoTo((cTable)->RECS))
	    (cTable)->(RecLock('SPC',.F.))  
	    SPC->PC_PDI     := xPDI
	    SPC->PC_QUANTI  := xQuantI
	    SPC->PC_DATAALT := ddatabase
        SPC->PC_HORAALT := time()
	    (cTable)->(MSUNLOCK())
        dbSelectArea(cTable)
    EndIf

    // Inclui novo registro com a diferença do Rateio
    If xInc .And. AllTrim(xUSUARIO) <> 'AAPONA01' //.And. Empty(xDATAALT)
	    dbSelectArea("SPC")
        dbSetOrder(1) //PC_FILIAL+PC_MAT+PC_PD+DTOS(PC_DATA)+PC_TPMARCA+PC_CC+PC_DEPTO+PC_POSTO+PC_CODFUNC
            (cTable)->(RecLock('SPC',.T.))  
             SPC->PC_FILIAL  := xFilial('SPC')
             SPC->PC_MAT     := xMAT
             SPC->PC_DATA    := xDATA
             SPC->PC_PD      := xPD
	         SPC->PC_QUANTC  := xQuantI
             SPC->PC_CC      := xCC
             SPC->PC_TURNO   := xTURNO
             SPC->PC_SEMANA  := xSEMANA
             SPC->PC_PERCENT := xPERCENT
             SPC->PC_TIPOHE  := xTIPOHE
             SPC->PC_USUARIO := "AAPONA01" // RetCodUsr()
	        (cTable)->(MSUNLOCK())
       // EndIf    
        
    EndIf
    
    dbSelectArea(cTable)
    (cTable)->(dbSKip())

EndDo

If xGrv
   MsgInfo( 'Geracao do Rateio Banco de Horas/Hora Extra, Finalizada com Sucesso!')
Else
   MsgInfo( 'Nao ha informacoes a serem processadas. Revise seus parametros!', 'A T E N C A O!')
EndIf

return

Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01","Data de ?"            ,"Data de ?"               ,"Data de ?"             ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","Data Ate ?"           ,"Data Ate ?"              ,"Data Ate ?"            ,"mv_ch2","D",8,0,0,"G","","","","","mv_par02")
PutSX1(cPerg,"03","Matricula de ?"       ,"Matricula de ?"          ,"Matricula de ?"        ,"mv_ch3","C",6,0,0,"G","","","","","mv_par03")
PutSX1(cPerg,"04","Matricula Ate ?"      ,"Matricula Ate ?"         ,"Matricula Ate ?"       ,"mv_ch4","C",6,0,0,"G","","","","","mv_par04")
PutSX1(cPerg,"05","Dt. p/ Hr.Ext 100% ?" , "Dt. p/ Hr.Ext 100% ?"   ,"Dt. p/ Hr.Ext 100% ?"  ,"mv_ch5","C",99,0,0,"G","","","","","mv_par05")
PutSX1(cPerg,"06","Dt. p/ Bc.Hrs 100% ?" , "Dt. p/ Bc.Hrs 100% ?"   ,"Dt. p/ Bc.Hrs 100% ?"  ,"mv_ch6","C",99,0,0,"G","","","","","mv_par06")
PutSX1(cPerg,"07","Matr. para Isentas ?" , "Matr. para Isentas ?"   ,"Matr. para Isentas ?"  ,"mv_ch7","C",99,0,0,"G","","","","","mv_par07")
PutSX1(cPerg,"08","C.de Custos de ?"     , "C.de Custos de ?"       ,"C.de Custos de ?"      ,"mv_ch8","C",9,0,0,"G","","","","","mv_par08")
PutSX1(cPerg,"09","C.de Custos Ate ?"    , "C.de Custos Ate ?"      ,"C.de Custos Ate ?"     ,"mv_ch9","C",9,0,0,"G","","","","","mv_par09")
PutSX1(cPerg,"10","C.de Custos Isentos ?", "C.de Custos Isentos ?"  ,"C.de Custos Isentos ?" ,"mv_ch10","C",99,0,0,"G","","","","","mv_par10")

Return
