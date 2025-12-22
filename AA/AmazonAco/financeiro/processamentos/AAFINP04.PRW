#Include 'Protheus.ch'

User Function AAFINP04()
   Local cPerg := Padr('AAFINP04',Len(SX1->X1_GRUPO) )
   
   SX1->(dbSetORder(1))
   If SX1->(dbSeek(cPerg + '01'))
      SX1->(RecLock('SX1',.F.))
         SX1->X1_CNT01 := DTOS( GETMV('MV_DATAFIN') )
      SX1->(MsUnlock())
   EndIf
   ValidPerg(cPerg)
   IF Pergunte(cPerg,.T.)
      PutMv('MV_DATAFIN',mv_par01)
   EndIF
   
Return

Static Function ValidPerg(cPerg)
    PutSX1(cPerg,"01","Nova Data do 'MV_DATAFIN' ","Nova Data!","Print Cost?","mv_ch1","D",8,0,0,"G","", "" ,"","","mv_par01")//,"Formadas","","","","Nao Formadas","","","Todas")
Return Nil

