#Include "PROTHEUS.CH"
#include "TBICONN.ch" 
//--------------------------------------------------------------
                                                              
//--------------------------------------------------------------

User Function AAFINC0T()
Local oButton1
Local oButton2
Local oSay
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay15
Local oSay16
Local oSay17
Local oSay18
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9

If type("cAcesso") = "U"
  Prepare Environment Empresa "01" Filial "01" Tables "SE1,SE2" Modulo "EST"
EndIf
cTblSE2 := GetSE2()
cTblSE1 := GetSE1()     

Private oGet1 := Nil
Private cGet1 := ""//(cTblSE2)->C_V_30
Private oGet2 := Nil
Private cGet2 := ""//(cTblSE2)->VENC_30
Private oGet3 := Nil
Private cGet3 := ""//(cTblSE2)->C_V_31_60
Private oGet4 := Nil
Private cGet4 := ""//(cTblSE2)->VENC_31_60
Private oGet5 := Nil
Private cGet5 := ""//(cTblSE2)->C_V_61_90
Private oGet6 := Nil
Private cGet6 := ""//(cTblSE2)->VENC_61_90
Private oGet7 := Nil
Private cGet7 := ""//(cTblSE2)->C_V_90
Private oGet8 := Nil
Private cGet8 := ""//(cTblSE2)->VENC_90
Private oGet9 := Nil
Private cGet9 := ""//(cTblSE1)->C_V_30
Private oGet10 := Nil
Private cGet10 := ""//(cTblSE1)->VENC_30
Private oGet11 := Nil
Private cGet11 := ""//(cTblSE1)->C_V_31_60
Private oGet12 := Nil
Private cGet12 := ""//(cTblSE1)->VENC_31_60
Private oGet13 := Nil
Private cGet13 := ""//(cTblSE1)->C_V_61_90
Private oGet14 := Nil
Private cGet14 := ""//(cTblSE1)->VENC_61_90
Private oGet15 := Nil
Private cGet15 := ""//(cTblSE1)->C_V_90
Private oGet16 := Nil
Private cGet16 := ""//(cTblSE1)->VENC_90
Private oGet17 := Nil
Private cGet17 := ""//(cTblSE2)->C_V_TODAY
Private oGet18 := Nil
Private cGet18 := ""//(cTblSE2)->VENC_TODAY
Private oGet19 := Nil
Private cGet19 := ""//(cTblSE1)->C_V_TODAY
Private oGet20 := Nil
Private cGet20 := ""//(cTblSE1)->VENC_TODAY
Private oGet21 := Nil
Private cGet21 := ""//(cTblSE2)->C_A_30
Private oGet22 := Nil
Private cGet22 := ""//(cTblSE2)->AVENC_30
Private oGet23 := Nil
Private cGet23 := ""//(cTblSE2)->C_A_31_60
Private oGet24 := Nil
Private cGet24 := ""//(cTblSE2)->AVENC_31_60
Private oGet25 := Nil
Private cGet25 := ""//(cTblSE2)->C_A_61_90
Private oGet26 := Nil
Private cGet26 := ""//(cTblSE2)->AVENC_61_90
Private oGet27 := Nil
Private cGet27 := ""//(cTblSE2)->C_A_90
Private oGet28 := Nil
Private cGet28 := ""//(cTblSE2)->AVENC_90
Private oGet29 := Nil
Private cGet29 := ""//(cTblSE1)->C_A_30
Private oGet30 := Nil
Private cGet30 := ""//(cTblSE1)->AVENC_30
Private oGet31 := Nil
Private cGet31 := ""//(cTblSE1)->C_A_31_60
Private oGet32 := Nil
Private cGet32 := ""//(cTblSE1)->AVENC_31_60
Private oGet33 := Nil
Private cGet33 := ""//(cTblSE1)->C_A_61_90
Private oGet34 := Nil
Private cGet34 := ""//(cTblSE1)->AVENC_61_90
Private oGet35 := Nil
Private cGet35 := ""//(cTblSE1)->C_A_90
Private oGet36 := Nil
Private cGet36 := ""//(cTblSE1)->AVENC_90
Private oGet37 := Nil
Private cGet37 := ""//(cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
Private oGet38 := Nil
Private cGet38 := ""//(cTblSE2)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +   VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)
Private oGet39 := Nil
Private cGet39 := ""//(cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
Private oGet40 := Nil
Private cGet40 := ""//(cTblSE1)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +   VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)

//Atualiza()

DEFINE FONT oFont1 NAME "Arial" SIZE 0, -12 BOLD

Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Posicao Financeira" FROM 000, 000  TO 580, 800 COLORS 0, 16777215 PIXEL
   
   


  ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function getSE2()
Local cQry := ""
Local cTable := GetNextAlias()

cQry += " SELECT 
cQry += "    SUM( case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) BetWeen 1 And 30 THEN E2_SALDO
cQry += "    END) AVENC_30,
cQry += "    COUNT( case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) BetWeen 1 And 30 THEN E2_SALDO
cQry += "    END) C_A_30,
cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) BETWEEN 31  AND 60 THEN E2_SALDO

cQry += "    END) AVENC_31_60,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) BETWEEN 31  AND 60 THEN E2_SALDO
cQry += "    END) C_A_31_60,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) BETWEEN 61  AND 90 THEN E2_SALDO   
cQry += "    END) AVENC_61_90,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) BETWEEN 61  AND 90 THEN E2_SALDO   
cQry += "    END) C_A_61_90,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) > 90 THEN E2_SALDO
cQry += "    END) AVENC_90,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) > 90 THEN E2_SALDO
cQry += "    END) C_A_90,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) = 0 THEN E2_SALDO
cQry += "    END) VENC_TODAY,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E2_VENCTO AS DATETIME )) = 0 THEN E2_SALDO
cQry += "    END) C_V_TODAY,        

cQry += "    SUM( case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) BetWeen 1 And 30 THEN E2_SALDO
cQry += "    END) VENC_30,
cQry += "    COUNT( case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) BetWeen 1 And 30 THEN E2_SALDO
cQry += "    END) C_V_30,

cQry += "    SUM(case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) BETWEEN 31  AND 60 THEN E2_SALDO
cQry += "    END) VENC_31_60,
cQry += "    COUNT(case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) BETWEEN 31  AND 60 THEN E2_SALDO
cQry += "    END) C_V_31_60,

cQry += "    SUM(case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) BETWEEN 61  AND 90 THEN E2_SALDO   
cQry += "    END) VENC_61_90,
cQry += "    COUNT(case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) BETWEEN 61  AND 90 THEN E2_SALDO   
cQry += "    END) C_V_61_90,

cQry += "    SUM(case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) > 90 THEN E2_SALDO
cQry += "    END) VENC_90,
cQry += "    COUNT(case when DATEDIFF(DAY,CAST(E2_VENCTO AS DATETIME ),GETDATE()) > 90 THEN E2_SALDO
cQry += "    END) C_V_90

cQry += "  FROM " + RetSqlName("SE2")
cQry += "  WHERE D_E_L_E_T_ = ''
cQry += "  And E2_SALDO > 0
cQry += "  And E2_TIPO Not In('NDF','PA')
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQry),cTable,.T.,.T.)

Return cTable


Static Function getSE1()
Local cQry := ""
Local cTable := GetNextAlias()

cQry += " SELECT 
cQry += "    SUM( case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) BetWeen 1 And  30 THEN E1_SALDO
cQry += "    END) AVENC_30,
cQry += "    COUNT( case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) BetWeen 1 And  30 THEN E1_SALDO
cQry += "    END) C_A_30,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) BETWEEN 31  AND 60 THEN E1_SALDO
cQry += "    END) AVENC_31_60,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) BETWEEN 31  AND 60 THEN E1_SALDO
cQry += "    END) C_A_31_60,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) BETWEEN 61  AND 90 THEN E1_SALDO   
cQry += "    END) AVENC_61_90,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) BETWEEN 61  AND 90 THEN E1_SALDO   
cQry += "    END) C_A_61_90,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) > 90 THEN E1_SALDO
cQry += "    END) AVENC_90,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) > 90 THEN E1_SALDO
cQry += "    END) C_A_90,

cQry += "    SUM(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) = 0 THEN E1_SALDO
cQry += "    END) VENC_TODAY,
cQry += "    COUNT(case when DATEDIFF(DAY,GETDATE(),CAST(E1_VENCTO AS DATETIME )) = 0 THEN E1_SALDO
cQry += "    END) C_V_TODAY,      

cQry += "    SUM( case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) BetWeen 1 And 30 THEN E1_SALDO
cQry += "    END) VENC_30,
cQry += "    COUNT( case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) BetWeen 1 And  30 THEN E1_SALDO
cQry += "    END) C_V_30,   

cQry += "    SUM(case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) BETWEEN 31  AND 60 THEN E1_SALDO
cQry += "    END) VENC_31_60,
cQry += "    COUNT(case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) BETWEEN 31  AND 60 THEN E1_SALDO
cQry += "    END) C_V_31_60,   

cQry += "    SUM(case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) BETWEEN 61  AND 90 THEN E1_SALDO   
cQry += "    END) VENC_61_90,
cQry += "    COUNT(case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) BETWEEN 61  AND 90 THEN E1_SALDO   
cQry += "    END) C_V_61_90,   

cQry += "    SUM(case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) > 90 THEN E1_SALDO
cQry += "    END) VENC_90,
cQry += "    COUNT(case when DATEDIFF(DAY,CAST(E1_VENCTO AS DATETIME ),GETDATE()) > 90 THEN E1_SALDO
cQry += "    END) C_V_90

cQry += "  FROM " + RetSqlName("SE1")
cQry += "  WHERE D_E_L_E_T_ = ''
cQry += "  And E1_SALDO > 0
cQry += "  And E1_TIPO Not In('NCC','RA','CR')
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQry),cTable,.T.,.T.)

Return cTable

Static Function Atualiza()
cTblSE2 := GetSE2()
cTblSE1 := GetSE1()
     
cGet1 := (cTblSE2)->C_V_30
cGet2 := (cTblSE2)->VENC_30
cGet3 := (cTblSE2)->C_V_31_60
cGet4 := (cTblSE2)->VENC_31_60
cGet5 := (cTblSE2)->C_V_61_90
cGet6 := (cTblSE2)->VENC_61_90
cGet7 := (cTblSE2)->C_V_90
cGet8 := (cTblSE2)->VENC_90
cGet9 := (cTblSE1)->C_V_30
cGet10 := (cTblSE1)->VENC_30
cGet11 := (cTblSE1)->C_V_31_60
cGet12 := (cTblSE1)->VENC_31_60
cGet13 := (cTblSE1)->C_V_61_90
cGet14 := (cTblSE1)->VENC_61_90
cGet15 := (cTblSE1)->C_V_90
cGet16 := (cTblSE1)->VENC_90
cGet17 := (cTblSE2)->C_V_TODAY
cGet18 := (cTblSE2)->VENC_TODAY
cGet19 := (cTblSE1)->C_V_TODAY
cGet20 := (cTblSE1)->VENC_TODAY
cGet21 := (cTblSE2)->C_A_30
cGet22 := (cTblSE2)->AVENC_30
cGet23 := (cTblSE2)->C_A_31_60
cGet24 := (cTblSE2)->AVENC_31_60
cGet25 := (cTblSE2)->C_A_61_90
cGet26 := (cTblSE2)->AVENC_61_90
cGet27 := (cTblSE2)->C_A_90
cGet28 := (cTblSE2)->AVENC_90
cGet29 := (cTblSE1)->C_A_30
cGet30 := (cTblSE1)->AVENC_30
cGet31 := (cTblSE1)->C_A_31_60
cGet32 := (cTblSE1)->AVENC_31_60
cGet33 := (cTblSE1)->C_A_61_90
cGet34 := (cTblSE1)->AVENC_61_90
cGet35 := (cTblSE1)->C_A_90
cGet36 := (cTblSE1)->AVENC_90
cGet37 := (cTblSE2)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
cGet38 := (cTblSE2)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +   VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)
cGet39 := (cTblSE1)->(C_A_30 + C_V_30 + C_A_31_60 +  C_V_31_60 + C_A_61_90 + C_V_61_90 + C_A_90 + C_V_90 + C_V_TODAY)
cGet40 := (cTblSE1)->( AVENC_30 +  VENC_30 +  AVENC_31_60 +   VENC_31_60 +  AVENC_61_90 +  VENC_61_90 +  AVENC_90 +  VENC_90 +  VENC_TODAY)

lShowMsg := .F.
For nI := 1 To 40
  IF ValType( &("oGet"+Alltrim(Str(NI))) )="O"
    &("oGet"+Alltrim(Str(NI))):Refresh()
    lShowMsg := .T.
  EndIf
Next

If lShowMsg
  alert('Atualizado')
EndIf
Return 




/*powered by DXRCOVRB*/