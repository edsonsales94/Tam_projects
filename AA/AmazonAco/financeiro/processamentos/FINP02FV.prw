#Include 'Protheus.ch'

User Function FINP02FV()
   Local cPerg := Padr('FINP02FV',Len(SX1->X1_GRUPO) )
   
   ValidPerg(cPerg)
      
   If SX1->(dbSeek(cPerg + '01'))
      SX1->(RecLock('SX1',.F.))
       //SX1->X1_CNT01 := DTOS( GETMV('MV_DBLQMOV') )
      SX1->(MsUnlock())
   EndIf
      
   If Pergunte(cPerg,.T.)
      _cdFilial := cFilAnt
      cFilAnt := mv_par02
      PutMv('MV_DBLQMOV',mv_par01)
      cFilAnt := _cdFilial
   EndIf
   
Return

Static Function ValidPerg(cPerg)    
    PutSX1(cPerg,"01","Nova Data do 'MV_DBLQMOV' ","Nova Data!","Print Cost?","mv_ch1","D",8,0,0,"G","", "" ,"","","mv_par01")//,"Formadas","","","","Nao Formadas","","","Todas")
    PutSX1(cPerg,"02","Filial ? ","Filial ? ","Print Cost?","mv_ch1","C",2,0,0,"G","", "" ,"","","mv_par02")//,"Formadas","","","","Nao Formadas","","","Todas")
Return Nil

