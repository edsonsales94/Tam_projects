#include "rwmake.ch"


User Function CRIAMENU()
   Local aSay    := {}
   Local aButton := {}
   Local cPerg   := "CRIAMN0001"
   Local nOpc    := 0
   Local cTitulo := "Rotina de Criacao de Menu"
   Local cDesc1  := "Este programa fara a geração automatica dos menus por gru-"
   Local cDesc2  := "pos de acessos pré-definidos para os usuarios."

   ValidPerg(cPerg)
   Pergunte(cPerg,.F.)

   aAdd( aSay, cDesc1 )
   aAdd( aSay, cDesc2 )
   aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )}})
   aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
   aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )
   
   FormBatch( cTitulo, aSay, aButton )

   If nOpc == 1
      Processa( {|| RunProc() }, "Criacao de Menus",, .T. )
   Endif

Return Nil

Static Function RunProc()
   Local cArq, cMenu, lMod, cMod, vGrupo, m, x, vSub, cSubMnu, cLinha, lTem, nRecno, cOpc, nHdl
   Local cLeg, cAcess, cProg, cItem, vColum, nCini, nCfin, nGrup, nPos, cMens, cDir, lPSub, cSta
   Local lMnu, lSub
   Local cStartPath := GetSrvProfString("Startpath","")
   Local cTab := CHR(09)

   /* Verifica se o arquivo de menus existe */
   cArq := AllTrim(mv_par01)+If( ".DBF" $ Upper(mv_par01) , "", ".DBF")
   If !File(cArq)
      Alert("Arquivo de menus nao existe !")
      Return
   Endif    
   cDir := SubStr(cArq,1,At("\",SubStr(cArq,2,Len(cArq)))+1)

   /* Verifica se o arquivo de menus com os alias existe */
   cMnu := cDir+"MENUZAO.DBF"
   //If !File(cMnu)
   //   Alert("Arquivo de menus com os Alias nao existe !")
   //   Return
   //Endif    

   /* Abre o arquivo de menus */
   Use &cArq Alias MNU New Exclusive

   /* Cria uma matriz com os campos padroes do arquivo de menus. O arquivo de menus tera que ter */
   /* obrigatoriamente os campos abaixo, sendo que os 4 primeiros terao que estar nessa ordem.   */
   vColum := {}
   AAdd( vColum , { "MODULO"  , "C"})
   AAdd( vColum , { "MENU"    , "C"})
   AAdd( vColum , { "SUBMENU" , "C"})
   AAdd( vColum , { "TRANS"   , "C"})
   AAdd( vColum , { "PROGRAMA", "C"})
   AAdd( vColum , { "CODMOD"  , "C"})
   AAdd( vColum , { "STATUS"  , "C"})

   cMens := "Existem divergencias de campos no arquivo de Menu !"
   nCini := 0  // Primeiro campo do grupo de usuario
   nCfin := 0  // Ultimo   campo do grupo de usuario
   nGrup := 0  // Quantidade de grupo de usuarios
   For m:=1 To FCount()
      If m < 5 .Or. nCfin > 0
         If nCfin == 0 .And. !(Trim(FieldName(m)) == vColum[m,1] .And.;
            ValType(FieldGet(m)) == vColum[m,2])  // Se o campo ou o tipo forem divergentes
            Alert(cMens)
            dbCloseArea()
            Return
         ElseIf nCfin > 0 // Caso tenha encontrado o ultimo grupo, valida os 3 campos restantes
            For m:= 5 To Len(vColum)
               nPos := FieldPos(vColum[m,1])
               If nPos == 0 .Or. ValType(FieldGet(nPos)) <> vColum[m,2]
                  Alert(cMens)
                  dbCloseArea()
                  Return
               Endif
            Next
            Exit
         Endif
      Else
         nCini := If( nCini == 0 , m, nCini)
         If Trim(FieldName(m+1)) == "PROGRAMA"  // Se o proximo campo for PROGRAMA, o campo atual e
            nCfin := m  // Ultimo grupo de usuario
         ElseIf ValType(FieldGet(m)) <> "C" // Se o tipo de algum dos grupos for diferente de Caract
            Alert(cMens)
            dbCloseArea()
            Return
         Endif
         nGrup++  // Calcula a quantidade de grupo de usuarios
      Endif
   Next

   If nGrup < 2 .Or. nCfin == 0  // Se nao achou nenhum grupo o nao achou o ultimo grupo
      Alert(cMens)
      dbCloseArea()
      Return
   Endif

   /* Abre o arquivo de menus com os alias */
   If File(cMnu)
      Use &cMnu Alias TMP New Exclusive
      cInd := CriaTrab( NIL , .F. )
      IndRegua("TMP",cInd,"SUBSTR(LINHA,21,10)",,,OemToAnsi("Selecionando Registros..."))   
   Endif

   /* Processa o arquivo de menus para criacao dos menus dos usuarios */
   dbSelectArea("MNU")

   vGrupo := Grupos(nCini,nCfin) // Cria matriz com os grupos de usuarios

   dbGoTop()
   ProcRegua(RecCount()*Len(vGrupo))
   While !Eof()
      nRecno := Recno()

      For m:=1 To Len(vGrupo)
         dbGoTo(nRecno)
         cMenu := CriaTrab( Nil , .F. )+".TXT"
         nHdl  := MSFCreate(cMenu,0)
         vSub  := {}
         lCab  := .T.
         lPSub := .T.
         cOpc  := "  "
         lTem1 := .F.
         lMod  := .F.
         cMod  := MODULO
         vAux1 := {}

         AAdd( vAux1 , '<ApMenu>' )
         AAdd( vAux1 , cTab+'<DocumentProperties>' )
         AAdd( vAux1 , cTab+cTab+'<Module>'+AllTrim(cMod)+vGrupo[m]+'</Module>' )
         AAdd( vAux1 , cTab+cTab+'<Version>8.11</Version>' )
         AAdd( vAux1 , cTab+'</DocumentProperties>' )

         While !Eof() .And. If( lMod , Empty(MODULO) , cMod == MODULO ) // Quebra por modulo

            lTem2 := .F.
            lMnu  := .F.
            cMnu  := MENU
            vAux2 := {}

            AAdd( vAux2 , cTab+'<Menu Status="Enable">')
            AAdd( vAux2 , cTab+cTab+'<Title lang="pt">&'+Trim(cMnu)+'</Title>')
            AAdd( vAux2 , cTab+cTab+'<Title lang="es">&'+Trim(cMnu)+'</Title>')
            AAdd( vAux2 , cTab+cTab+'<Title lang="en">&'+Trim(cMnu)+'</Title>')

            While !Eof() .And. If( lMod , Empty(MODULO) , cMod == MODULO ) .And.;
                               If( lMnu , Empty(MENU)   , cMnu == MENU   )
               lTem3 := .F.
               lSub  := .F.
               cSub  := SUBMENU
               vAux3 := {}

               AAdd( vAux3 , cTab+cTab+'<Menu Status="Enable">')
               AAdd( vAux3 , cTab+cTab+cTab+'<Title lang="pt">'+Trim(cSub)+'</Title>')
               AAdd( vAux3 , cTab+cTab+cTab+'<Title lang="es">'+Trim(cSub)+'</Title>')
               AAdd( vAux3 , cTab+cTab+cTab+'<Title lang="en">'+Trim(cSub)+'</Title>')

               While !Eof() .And. If( lMod , Empty(MODULO)  , cMod == MODULO  ) .And.;
                                  If( lMnu , Empty(MENU)    , cMnu == MENU    ) .And.;
                                  If( lSub , Empty(SUBMENU) , cSub == SUBMENU )

                  IncProc()

                  If !Empty(SUBMENU)
                     lMod := .T.
                     lMnu := .T.
                     lSub := .T.
                     dbSkip()
                     Loop
                  Endif

                  /* Calcula a Legenda, Programa e acessos do grupo de usuarios */
                  cLeg  := SubStr(AllTrim(TRANS),1,18)
                  cProg := SubStr(Upper(AllTrim(PROGRAMA)),1,10)
                  cItem := Upper(AllTrim(FieldGet(FieldPos(vGrupo[m]))))
                  Do Case
                     Case cItem $ "C"      ;  cAcess := "xx   xxxxx"
                     Case cItem $ "I"      ;  cAcess := "xxx  xxxxx"
                     Case cItem $ "A"      ;  cAcess := "xx x xxxxx"
                     Case cItem $ "E"      ;  cAcess := "xx  xxxxxx"
                     Case cItem $ "IE,EI"  ;  cAcess := "xxx xxxxxx"
                     Case cItem $ "IA,AI"  ;  cAcess := "xxxx xxxxx"
                     Case cItem $ "AE,EA"  ;  cAcess := "xx xxxxxxx"
                     OtherWise             ;  cAcess := "xxxxxxxxxx"
                  EndCase

                  /* Monta a linha de opcao do menu */
                  If !Empty(cItem)
                     // Descarrega para gravacao os cabecalhos
                     For x:=1 To Len(vAux1)
                        FWrite(nHdl,vAux1[x]+CHR(13)+CHR(10))
                     Next
                     vAux1 := {}
                     For x:=1 To Len(vAux2)
                        FWrite(nHdl,vAux2[x]+CHR(13)+CHR(10))
                     Next
                     vAux2 := {}
                     For x:=1 To Len(vAux3)
                        FWrite(nHdl,vAux3[x]+CHR(13)+CHR(10))
                     Next
                     vAux3 := {}

                     cAlias := " "
                     If Select("TMP") > 0  // Se o alias existir
                        dbSelectArea("TMP")
                        If dbSeek(cProg) // Pesquisa os alias relacionados a rotina
                           cAlias := StrTran(SubStr(LINHA,32,90),".","")
                        Endif
                        dbSelectArea("MNU")
                     Endif
                     lTem1 := .T.
                     lTem2 := .T.
                     lTem3 := .T.
                     cLeg  := cLeg+Space(30-Len(cLeg))
                     cProg := cProg+Space(10-Len(cProg))
                     cType := If( SubStr(cProg,1,1) == "#" , "3", "1")

                     vDet  := {}
                     cSta  := If( AllTrim(STATUS) == "D" , "Hidden" ,;
                              If( AllTrim(STATUS) == "F" , "Disable", "Enable"))
                     AAdd( vDet , cTab+cTab+cTab+'<MenuItem Status="'+cSta+'">')
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Title lang="pt">'+Trim(cLeg)+'</Title>')
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Title lang="es">'+Trim(cLeg)+'</Title>')
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Title lang="en">'+Trim(cLeg)+'</Title>')
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Function>'+Trim(StrTran(cProg,'#',''))+'</Function>')
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Type>'+cType+'</Type>')
                     For x:=1 To Len(cAlias) Step 3
                        If !Empty(SubStr(cAlias,x,3))
                           AAdd( vDet , cTab+cTab+cTab+cTab+'<Tables>'+SubStr(cAlias,x,3)+'</Tables>')
                        Endif
                     Next
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Access>'+cAcess+'</Access>')
                     AAdd( vDet , cTab+cTab+cTab+cTab+'<Module>'+SubStr(AllTrim(CODMOD),1,2)+'</Module>')
                     AAdd( vDet , cTab+cTab+cTab+'</MenuItem>')

                     For x:=1 To Len(vDet)
                        FWrite(nHdl,vDet[x]+CHR(13)+CHR(10))
                     Next
                  Endif

                  dbSkip()
               Enddo
               If lTem3
                  FWrite(nHdl,cTab+cTab+'</Menu>'+CHR(13)+CHR(10))
               Endif
            Enddo
            If lTem2
               FWrite(nHdl,cTab+'</Menu>'+CHR(13)+CHR(10))
            Endif
         Enddo
         If lTem1
            FWrite(nHdl,'</ApMenu>'+CHR(13)+CHR(10))
         Endif
         FClose(nHdl)

         If lTem1
            cMod := AllTrim(cMod)+vGrupo[m]
            If File(cDir+cMod+".XNU")
               FErase(cDir+cMod+".XNU")
            Endif
            FRename(cStartPath+cMenu,cDir+Upper(cMod)+".XNU")
         Else
            FErase(cStartPath+cMenu)
         Endif
      Next
   Enddo
   dbCloseArea()
   If Select("TMP") > 0  // Se o alias existir
      dbSelectArea("TMP")
      dbCloseArea()
      FErase(cInd+".IDX")
   Endif
Return

Static Function Grupos(nIni,nFin)
   Local x, vRet := {}

   For x:=nIni To nFin
      AAdd( vRet , AllTrim(FieldName(x)) )
   Next

Return(vRet)

Static Function ValidPerg(cPerg)
   Local _sAlias, aRegs
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)

   aRegs :={}
   aAdd(aRegs ,{cPerg,"01","Arquivo de Menus  ?","","","mv_ch1","C",30,0,0,"G","","MV_PAR01"})
   For i:=1 to Len(aRegs)
      If !DbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j:=1 To Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
         Next
         MsUnlock()
      Endif
   Next
   dbSelectArea(_sAlias)
Return