#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TBICONN.ch"
#Include "font.CH"
#Include "Topconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATP04   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 27/05/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ TELA DE CONSULTA DE HISTÓRICO DAS NOTAS NO ROMANEIO			   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function AAFATP04(aParam)
 Local   cVar     := Nil
 Local   oGet     := Nil
 Private cAlias   := Alias()
 Private oDlg     := Nil
 Private oLbx     := Nil
 Private aVetor   := {}
 Private oMainWd  := Nil 
                          
  aAdd( aVetor , { "", "", "", "", "", "", "" } )
  Pesquisa(SZE->ZE_DOC, SZE->ZE_SERIE) //  Pesquisa("000056963", "2")
  
  DEFINE MSDIALOG oDlg TITLE "Consulta de histórico das notas em romaneio" From 8,0 To 30,120 OF oMainWd

    @ 015,005 LISTBOX oLbx VAR cVar FIELDS HEADER "Romaneio", "Documento","Serie","Data", "Hora","Usuário","Operação";
				  SIZE 450,135 OF oDlg PIXEL
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| { aVetor[oLbx:nAt,1],;
							  aVetor[oLbx:nAt,2],;
							  aVetor[oLbx:nAt,3],;
							  aVetor[oLbx:nAt,4],;
							  aVetor[oLbx:nAt,5],;
							  aVetor[oLbx:nAt,6],;
							  aVetor[oLbx:nAt,7]}}	
	
  ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED

Return Nil

//*************************************************************************************************

Static Function Pesquisa(cNota, cSerie)
	
  cQry := "SELECT * "
  cQry +=   "FROM "+RetSQLName("SZ4")+" A "	 
  cQry +=  "WHERE A.D_E_L_E_T_ = '' "
  cQry +=    "AND A.Z4_NUMNF   = '" + cNota  +"' "
  cQry +=    "AND A.Z4_SERIE   = '" + cSerie +"' "
  cQry +=  "ORDER BY R_E_C_N_O_ "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )
  TCSetField("QRY","Z4_DATAOP","D",8,0)

  aDel(aVetor,Len(aVetor))
  aSize(aVetor,0)
	
  While !QRY->(Eof())	
    aAdd( aVetor, { QRY->Z4_ROMANEI, QRY->Z4_NUMNF, QRY->Z4_SERIE, QRY->Z4_DATAOP, QRY->Z4_HORAOP, QRY->Z4_USUARIO,QRY->Z4_OPERACA } )
	 lMark := .F.
	 QRY->(DbSkip())		
  End
	
  QRY->(DbCloseArea())
	
  If Len(aVetor) = 0
      aAdd( aVetor , { "", "", "", "", "", "", "" } )
		MsgAlert("Não existe dados para consulta!!!",OemToAnsi("ATENCAO")  )
  EndIf
		 	
Return Nil 

**************************************************************************************

/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/