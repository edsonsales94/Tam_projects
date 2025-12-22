#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณ ApontaOP บ Autor ณ ENGINE LOGISTICA LTDA   บ Data ณ  06/01/03 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo desenvolvido para executar os apontamentos de Ordens   บฑฑ
ฑฑบ          ณ de Produ็ใo, a partir do arquivo SZS criado na base de Dados  บฑฑ
ฑฑบ          ณ Microsiga e de uso exclusivo do Sistema de C๓digo de Barras.  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sistema de C๓digo de Barras Engine Logํstica e AP6 Microsiga  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ApontaOP

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบFun็ใo  ณ RUNCONT บ Autor ณ ENGINE LOGISTICA LTDA      บ Data ณ  06/01/03 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo desenvolvido para executar os apontamentos de Ordens   บฑฑ
ฑฑบ          ณ de Produ็ใo, a partir do arquivo SZS criado na base de Dados  บฑฑ
ฑฑบ          ณ Microsiga e de uso exclusivo do Sistema de C๓digo de Barras.  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sistema de C๓digo de Barras Engine Logํstica e AP6 Microsiga  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

//Devem ser passados no array(s) todos os campos obrigatorios
Local _aVetor     := {}
Local lMsErroAuto := .F.
Local nReg        := 0
Local cQuery      := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Query para Atualiza็ใo                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := "SELECT ZS_FILIAL, ZS_TM, ZS_OP, ZS_COD, ZS_UM, ZS_QUANT, ZS_LOCAL, ZS_PARCTOT "
cQuery := cQuery + "FROM SZS010 WHERE ZS_FILIAL = '"+xFilial("SZS")+"' AND "
cQuery := cQuery + "SZS010.D_E_L_E_T_ <> '*' AND ZS_STATUS = 'CAD' "
cQuery := cQuery + "ORDER BY ZS_DTGERAC, ZS_HRGERAC"
TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea( "SZS" )
dbSetOrder(3)

dbSelectArea( "TMP" )
dbGoBottom()
nReg := Recno()
dbGoTop()

If nReg > 0

   ProcRegua( nReg ) // Numero de registros a processar

   While ! EOF()

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Incrementa a regua                                                  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

      IncProc()
      
      _aVetor:={  {"D3_FILIAL"  ,TMP->ZS_FILIAL         ,NIL},;
                  {"D3_TM"      ,TMP->ZS_TM             ,NIL},;
				  {"D3_OP"      ,TMP->ZS_OP             ,NIL},;
				  {"D3_COD"     ,TMP->ZS_COD            ,NIL},;
				  {"D3_UM"      ,TMP->ZS_UM             ,NIL},;
				  {"D3_QUANT"   ,TMP->ZS_QUANT          ,NIL},;
				  {"D3_LOCAL"   ,TMP->ZS_LOCAL          ,NIL},;
				  {"D3_EMISSAO" ,dDataBase              ,NIL},;
				  {"D3_PARCTOT" ,TMP->ZS_PARCTOT        ,NIL}   }
 // {"D3_LOTECTL" ,substr(TMP->ZS_OP,1,6) ,NIL},;
 // {"D3_DTVALID" ,dDataBase              ,NIL},;

      MSExecAuto({|x,y| MATA250(x,y)},_aVetor,3)   //Inclusao

      If lMsErroAuto
         Alert("Erro")
         DisarmTransaction()
         break
      Else
         dbSelectArea( "SC2" )
         dbSetOrder(1)
         IF SC2->( dbSeek( xFilial( "TMP" ) + TMP->ZS_OP ) ) .AND. ! Empty( SC2->C2_DATRF )
            If SZS->( dbSeek( xFilial( "SZS" ) + TMP->ZS_OP ) )
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

   Alert("Fim de Apontamento das Opดs.")
Else
   Alert("Nใo Houve Apontamento de Opดs.")
EndIf

dbCloseArea("TMP")
Return
