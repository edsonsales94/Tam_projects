#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "FWMVCDEF.CH"

/*/{Protheus.doc} User Function kMCEnc_OP
    Função desenvolvida para encerramento múltiplo de Ops
    @type  Function
    @author Anizio Cunha / Rage
    @since 03/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function kMCEnc_OP()
    Local cArqTrb
    Local cIndice1, cIndice2, cIndice3,cIndice4 := ""
    Local i
    Local aPergs   := {}
    Local dDataDe  := Ctod(Space(8))
    Local dDataAt  := Ctod(Space(8))
    //Local lContinua:= .T.
    Private aCampos	:= {}, aSeek := {}, aValores := {}
    Private oBrowse 	:= Nil
    Private cCadastro 	:= "Encerramento Múltiplo de OP "//"Cadastro de OP Complementar"
    Private aRotina	 	:= Menudef() //Se for criar menus via MenuDef
    Private aRet := {}

    aAdd(aPergs, {9,"Parâmetros Filtrar OPs",200,40,.T.}) 
    aAdd(aPergs, {1,"Período De",dDataDe, "@D", ".T.", "", ".T.", 80,.F.})
    aAdd(aPergs, {1,"Período Até", dDataAt, "@D", ".T.", "", ".T.", 80, .F.})

    If !ParamBox(aPergs ,"Encerramento de Ops",aRet)
		Return
    Else


        //Criar a tabela temporária
        AAdd(aCampos,{"TR_OK"  		,"C",002,0}) //Este campo será usado para marcar/desmarcar
        AAdd(aCampos,{"TR_FILIAL"  	,"C",002,0})
        AAdd(aCampos,{"TR_NUM" 		,"C",006,0})
        AAdd(aCampos,{"TR_ITEM" 	,"C",002,0})
        AAdd(aCampos,{"TR_SEQUEN"	,"C",003,0})
        AAdd(aCampos,{"TR_PRODUTO"	,"C",030,0})
        AAdd(aCampos,{"TR_QUANT"	,"N",016,6})
        AAdd(aCampos,{"TR_QUJE"		,"N",016,6})
        AAdd(aCampos,{"TR_REC"		,"N",016,0})

        //Se o alias estiver aberto, fechar para evitar erros com alias aberto
        If (Select("TRB") <> 0)
            dbSelectArea("TRB")
            TRB->(dbCloseArea ())
        Endif

        cArqTrb   := CriaTrab(aCampos,.T.)
        cIndice1 := Alltrim(CriaTrab(,.F.))
        cIndice2 := cIndice1
        cIndice3 := cIndice1
        cIndice4 := cIndice1

        cIndice1 := Left(cIndice1,5) + Right(cIndice1,2) + "A"
        cIndice2 := Left(cIndice2,5) + Right(cIndice2,2) + "B"
        cIndice3 := Left(cIndice3,5) + Right(cIndice3,2) + "C"
        cIndice4 := Left(cIndice4,5) + Right(cIndice4,2) + "D"

        //Se indice existir excluir
        If File(cIndice1+OrdBagExt())
            FErase(cIndice1+OrdBagExt())
        EndIf

        dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)
        IndRegua("TRB", cIndice1, "TR_FILIAL+TR_NUM"	,,, "Indice Filial+NumOP...")
        IndRegua("TRB", cIndice2, "TR_NUM",,, "Indice Numero OP...")

        dbClearIndex()

        dbSetIndex(cIndice1+OrdBagExt())
        dbSetIndex(cIndice2+OrdBagExt())

        cQy:= " SELECT * "
        cQy+= " FROM "+ RetSqlName("SC2") +" AS SC2 (NOLOCK)"
        cQy+= " WHERE  SC2.D_E_L_E_T_ <> '*' "
        cQy+= " AND SC2.C2_QUJE < SC2.C2_QUANT "
        cQy+= " AND SC2.C2_DATRF = '' "
        cQy+= " AND SC2.C2_FILIAL = '"+cFilAnt+"' "
        cQy+= " AND SC2.C2_EMISSAO BETWEEN '" +ALLTRIM(Dtos(MV_PAR02))+"' AND '" +ALLTRIM(Dtos(MV_PAR03))+"'
        cQy+= " ORDER BY SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN,SC2.C2_EMISSAO "
       
        dbUseArea(.T., "TOPCONN", TCGenQry(,,cQy), "QRY", .F., .T.)

        Dbselectarea("QRY")
        Dbgotop()
        DO WHILE !QRY->(EOF())
            aadd(aValores,{QRY->C2_FILIAL,QRY->C2_NUM,QRY->C2_ITEM,QRY->C2_SEQUEN,QRY->C2_PRODUTO,QRY->C2_QUANT,QRY->C2_QUJE,QRY->R_E_C_N_O_})
            QRY->(DBSKIP())
        ENDDO

        For i:= 1 to len(aValores)
            If RecLock("TRB",.T.)
                TRB->TR_OK    		:= "  "
                TRB->TR_FILIAL    	:= aValores[i,1]
                TRB->TR_NUM 	  	:= aValores[i,2]
                TRB->TR_ITEM  		:= aValores[i,3]
                TRB->TR_SEQUEN 		:= aValores[i,4]
                TRB->TR_PRODUTO 	:= aValores[i,5]
                TRB->TR_QUANT	 	:= aValores[i,6]
                TRB->TR_QUJE	 	:= aValores[i,7]
                TRB->TR_REC         := aValores[i,8]
                
                MsUnLock()
            Endif
        Next

        dbSelectArea("TRB")
        TRB->(DbGoTop())

        If TRB->(!Eof())
            // criar a pesquisa que serï¿½ apresentada na tela
            aAdd(aSeek,{"Filial+Numero OP"	,{{"","C",002,0,"Filial+Numero OP"	,"@!"}} } )
            aAdd(aSeek,{"Numero OP"	,{{"","C",006,0,"Num. OP."	,"@!"}} } )
            
            
            //Agora iremos usar a classe FWMarkBrowse
            oBrowse:= FWMarkBrowse():New()
            oBrowse:SetDescription(cCadastro) //Titulo da Janela
            //oBrowse:SetParam(bKeyF12) // Seta tecla F12
            oBrowse:SetAlias("TRB") //Indica o alias da tabela que serï¿½ utilizada no Browse
            oBrowse:SetFieldMark("TR_OK") //Indica o campo que deverï¿½ ser atualizado com a marca no registro
            oBrowse:oBrowse:SetDBFFilter(.T.)
            oBrowse:oBrowse:SetUseFilter(.T.) //Habilita a utilizaï¿½ï¿½o do filtro no Browse
            //oBrowse:oBrowse:SetFixedBrowse(.T.)
            oBrowse:SetWalkThru(.F.) //Habilita a utilizaï¿½ï¿½o da funcionalidade Walk-Thru no Browse
            oBrowse:SetAmbiente(.T.) //Habilita a utilizaï¿½ï¿½o da funcionalidade Ambiente no Browse
            oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporï¿½ria
            oBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilizaï¿½ï¿½o da pesquisa de registros no Browse
            oBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrï¿½o do Browse
            
            /* //Permite adicionar legendas no Browse
            oBrowse:AddLegend("TR_ST=='N'","GREEN" 	,"Usuï¿½rios Liberados")
            oBrowse:AddLegend("TR_ST=='S'","RED"   	,"Usuï¿½rios Bloqueados")
            */
            
            //Adiciona uma coluna no Browse em tempo de execuï¿½ï¿½o
            oBrowse:SetColumns(MCFG006TIT("TR_FILIAL"	,"FILIAL"		,03,"@!",0,002,0))
            oBrowse:SetColumns(MCFG006TIT("TR_NUM"		,"NUM OP"		,04,"@!",1,006,0))
            oBrowse:SetColumns(MCFG006TIT("TR_ITEM"		,"ITEM"			,05,"@!",1,002,0))
            oBrowse:SetColumns(MCFG006TIT("TR_SEQUEN"	,"SEQUENCIA"	,05,"@!",1,003,0))
            oBrowse:SetColumns(MCFG006TIT("TR_PRODUTO"	,"PRODUTO"		,06,"@!",1,030,0))
            oBrowse:SetColumns(MCFG006TIT("TR_QUANT"	,"QUANTIDADE"	,07,"@E 999,999,999.999999",1,016,6))
            oBrowse:SetColumns(MCFG006TIT("TR_QUJE"		,"QUANT. PRODUZIDA"	,08,"@E 999,999,999.999999",1,016,6))
            oBrowse:SetColumns(MCFG006TIT("TR_REC"		,"ID SC2"	,09,"@E 9999,999,999",1,016,0))
            
            oBrowse:Activate()
            
        Else
            Return
        EndIf

        If !Empty(cArqTrb)
            Ferase(cArqTrb+GetDBExtension())
            Ferase(cArqTrb+OrdBagExt())
            cArqTrb := ""
            TRB->(DbCloseArea())
            QRY->(DbCloseArea())
        Endif
    EndIf 

Return (.T.)

Static Function MenuDef()
Local aRot := {}

ADD OPTION aRot TITLE "Encerrar OP " ACTION "MsgRun('Coletando dados da(s) OP(s) Selecionada(s)','Encerramento OP',{|| u_KEncerOP() })"  OPERATION 6 ACCESS 0


Return(Aclone(aRot))

Static Function MCFG006TIT(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
Local aColumn
Local bData 	:= {||}
Default nAlign 	:= 1
Default nSize 	:= 20
Default nDecimal:= 0
Default nArrData:= 0

If nArrData > 0
	bData := &("{||" + cCampo +"}")
EndIf

/* Array da coluna
[n[01] Tï¿½tulo da coluna[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Mï¿½scara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a ediï¿½ï¿½o
[n][09] Code-Block de validaï¿½ï¿½o da coluna apï¿½s a ediï¿½ï¿½o
[n][10] Indica se exibe imagem
[n][11] Code-Block de execuï¿½ï¿½o do duplo clique
[n][12] Variï¿½vel a ser utilizada na ediï¿½ï¿½o (ReadVar)
[n][13] Code-Block de execuï¿½ï¿½o do clique no header
[n][14] Indica se a coluna estï¿½ deletada
[n][15] Indica se a coluna serï¿½ exibida nos detalhes do Browse
[n][16] Opï¿½ï¿½es de carga dos dados (Ex: 1=Sim, 2=Nï¿½o)
*/
aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}


User Function kEncerOP()

    Local   cSQL := ''
    Private lMsErroAuto := .F.
    Private lMostraErro := .T.

    
    // Confirma encerramento	                                             
    
    nAviso := Aviso( "Atenção","Confirma o encerramento das OPs ? ", { "Sim", "Não" } )
    If nAviso == 2
        Return
    EndIf

    dbSelectArea("TRB")
    TRB->(DbGoTop())

    While TRB->(!Eof())
        // Verifica apontamento da OP
        If !Empty(TRB->TR_OK) 

            cSQL := "SELECT A.D3_OP,A.D3_TM,A.D3_EMISSAO,A.D3_COD,A.D3_UM,A.D3_LOCAL,A.D3_DOC,A.D3_NUMSEQ " 
            cSQL += " FROM " + RETSQLNAME("SD3") + " AS A (NOLOCK) WHERE "
            cSQL += "A.D3_OP      = '" + TRB->TR_NUM+TRB->TR_ITEM+TRB->TR_SEQUEN  + "' AND "
            cSQL += "A.D3_CF = 'PR0' AND "
            cSQL += "A.D3_ESTORNO <> 'S' AND "
            cSQL += "A.D3_FILIAL='"+cFilAnt+"' AND "
            cSQL += "A.D_E_L_E_T_ = '' ORDER BY A.R_E_C_N_O_ DESC"
            cSQL := ChangeQuery(cSQL)
            TCQUERY cSQL NEW ALIAS "TD3"
            //dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TD3",.F.,.T.)
            
            
            DbSelectArea("TD3")
            DbGoTop()
            
            If TD3->(Eof())
                If MsgYesNo("A OP: "+TRB->TR_NUM+TRB->TR_ITEM+TRB->TR_SEQUEN+" não pode ser encerrada pois não existe apontamento de produção. Deseja Encluir?","Atenção")
                    //Aviso( "Atenção", "A OP: '"+TRB->TR_NUM+TRB->TR_ITEM+TRB->TR_SEQUEN+"' não pode ser encerrada pois não existe apontamento de produção. Exclua a OP para encerrar.", { "OK"} )
                    Begin Transaction 
                    DbSelectArea("SC2")
                    DbSetOrder(1)
                    cOPExcluir:= TRB->TR_NUM+TRB->TR_ITEM+TRB->TR_SEQUEN
                    If SC2->(DbSeek(xFilial("SC2")+Alltrim(cOPExcluir))) // Assegura que está posicionado no OP dentro da SC2.
                        aVetor:={}
                        aVetor:={ {"C2_NUM",SC2->C2_NUM,NIL},}
                        MSExecAuto({|x,y| mata650(x,y)},aVetor,5) //Exclusao

                        lMsErroAuto := .F.
                        MsgRun("Processando Exclusão da OP. Aguarde...","MATA650 - Exclusão de OP",{|| MSExecAuto({|x,y| MATA250(x,y)},aEncerra, 6) })
                            If lMsErroAuto
                                DisarmTransaction()
                            MostraErro()
                            EndIf
                            RecLock("TRB", .F.)
                                TRB->(DBDelete())
                            ("TRB")->(MsUnlock())
                            oBrowse:Refresh(.T.)
                            If ( Select("TD3") <> 0 )
                                dbSelectArea ("TD3")
                                dbCloseArea ()
                            Endif
                    EndIf 
                    End Transaction

                    
                Endif
                
                TD3->(dbCloseArea())
                RecLock("TRB",.F.)
                    TRB->TR_OK := " "
                MsUnlock()
                oBrowse:Refresh(.T.)
            //EndIf
           
            
            Else //If ! TD3->(Eof())
                TCSETFIELD("TD3","D3_EMISSAO","D",8,0)

                aEncerra := { { "D3_OP"		, TD3->D3_OP			, NIL },;
                                { "D3_TM" 		, TD3->D3_TM			, NIL },;
                                { "D3_EMISSAO"	, TD3->D3_EMISSAO		, NIL },;
                                { "D3_COD"		, TD3->D3_COD			, NIL },;
                                { "D3_UM"		, TD3->D3_UM			, NIL },;
                                { "D3_LOCAL"	, TD3->D3_LOCAL		    , NIL },;
                                { "D3_DOC"		, TD3->D3_DOC   		, NIL },;
                                { "D3_NUMSEQ"	, TD3->D3_NUMSEQ  	    , NIL } }

                
                // Encerramento automatico de OP                                       
            
                Begin Transaction 
                                
                    lMsErroAuto := .F.
                    MsgRun("Processando Encerramento da OP. Aguarde...","MATA250 - Encerramento de OP",{|| MSExecAuto({|x,y| MATA250(x,y)},aEncerra, 6) })
                    If lMsErroAuto
                        DisarmTransaction()
                    MostraErro()
                    EndIf
                    RecLock("TRB", .F.)
                        TRB->(DBDelete())
                    ("TRB")->(MsUnlock())
                    oBrowse:Refresh(.T.)
                End Transaction
                
            EndIf 
            If ( Select("TD3") <> 0 )
                dbSelectArea ("TD3")
                dbCloseArea ()
            Endif
        EndIf 
        TRB->(DbSkip())
    End 

Return 
