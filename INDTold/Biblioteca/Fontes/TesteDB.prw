#Include "Rwmake.ch"
User Function TesteDB(cDrive)
   cDrive := If( cDrive == Nil , "DBFCDX", cDrive)
   dbSelectArea("SA1")
   If __LOCALDRIVER == "CTREECDX"
      __dbCopy("\COPIA",,,,,,,cDrive)
   Endif
   ALERT("COPIOU !")

Return