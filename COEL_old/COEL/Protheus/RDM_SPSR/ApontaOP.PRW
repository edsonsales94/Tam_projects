#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ApontaOP º Autor ³ ENGINE LOGISTICA LTDA   º Data ³  06/01/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo desenvolvido para executar os apontamentos de Ordens   º±±
±±º          ³ de Produção, a partir do arquivo SZS criado na base de Dados  º±±
±±º          ³ Microsiga e de uso exclusivo do Sistema de Código de Barras.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sistema de Código de Barras Engine Logística e AP6 Microsiga  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ApontaOP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção  ³ RUNCONT º Autor ³ ENGINE LOGISTICA LTDA      º Data ³  06/01/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo desenvolvido para executar os apontamentos de Ordens   º±±
±±º          ³ de Produção, a partir do arquivo SZS criado na base de Dados  º±±
±±º          ³ Microsiga e de uso exclusivo do Sistema de Código de Barras.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sistema de Código de Barras Engine Logística e AP6 Microsiga  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

//Devem ser passados no array(s) todos os campos obrigatorios
Local _aVetor     := {}
Local lMsErroAuto := .F.
Local nReg        := 0
Local cQuery      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Query para Atualização                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cQuery := "SELECT ZS_FILIAL, ZS_TM, ZS_OP, ZS_COD, ZS_UM, ZS_QUANT, ZS_LOCAL, ZS_PARCTOT "
cQuery := "SELECT * "
cQuery := cQuery + "FROM SZS" + SM0->M0_CODIGO + "0 "
cQuery := cQuery + "WHERE ZS_FILIAL = '"+xFilial("SZS")+"' AND "
cQuery := cQuery + "D_E_L_E_T_ <> '*' AND ZS_STATUS = 'CAD' "
cQuery := cQuery + "ORDER BY ZS_DTGERAC, ZS_HRGERAC"
TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea( "SZS" )
dbSetOrder(1)

dbSelectArea( "TMP" )
dbGoBottom()
nReg := Recno()
dbGoTop()

If nReg > 0

   ProcRegua( nReg ) // Numero de registros a processar

   While ! EOF()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      IncProc()
      
      _aVetor := {{"D3_FILIAL"  ,TMP->ZS_FILIAL   ,NIL},;
                  {"D3_TM"      ,TMP->ZS_TM       ,NIL},;
				  {"D3_OP"      ,TMP->ZS_OP       ,NIL},;
				  {"D3_COD"     ,TMP->ZS_COD      ,NIL},;
				  {"D3_UM"      ,TMP->ZS_UM       ,NIL},;
				  {"D3_QUANT"   ,TMP->ZS_QUANT    ,NIL},;
				  {"D3_LOCAL"   ,TMP->ZS_LOCAL    ,NIL},;
				  {"D3_EMISSAO" ,dDataBase        ,NIL},;
				  {"D3_PARCTOT" ,TMP->ZS_PARCTOT  ,NIL}   }

      MSExecAuto({|x,y| MATA250(x,y)},_aVetor,3)   //Inclusao

      If lMsErroAuto
         Alert("Erro")
         DisarmTransaction()
         break
      Else
         dbSelectArea( "SC2" )
         dbSetOrder(1)
         IF dbSeek( xFilial( "SC2" ) + TMP->ZS_OP )                       // .AND. ;
            //ALLTRIM(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == TMP->ZS_OP .AND. ;
            //! Empty( SC2->C2_DATRF )
            dbSelectArea( "SZS" )
            If dbSeek( xFilial("SZS")+TMP->ZS_OP+TMP->ZS_DTGERAC+TMP->ZS_HRGERAC )
               RecLock("SZS",.F.)
               Replace SZS->ZS_STATUS  with 'EXP',;
                       SZS->ZS_DTIMPOR with DATE(),;
                       SZS->ZS_HRIMPOR with TIME()
               MsUnLock()
            Endif   
         Endif   
      Endif
      dbSelectArea("TMP")
      dbSkip()
   EndDo

   Alert("Fim de Apontamento das Op´s.")
Else
   Alert("Não Houve Apontamento de Op´s.")
EndIf

dbCloseArea("TMP")
Return
