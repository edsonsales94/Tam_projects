#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
/*_________________________________________________________________________________
* ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
* ¦ Program    ¦ M030INC           ¦ Author             ¦ Matheus Vinícius     ¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
* ¦ Description¦ Executado apos uma inclusao na rotina MATA030 - Cad. ClienteS  ¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
* ¦ Date       ¦ 17/06/2020         ¦ Last Modified time ¦  17/06/2020          ¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function M030INC()
    //valida se o usuario nao cancelou a operacao
	FWAlertInfo("PARAMIXB: "+LTrim(Str(PARAMIXB,10)))
	If !(PARAMIXB == 3)
		GZN->(dbSetOrder(2))
    	GZN->(dbGoTop())
	    If !GZN->(dbSeek(XFILIAL("GZN")+SA1->A1_COD+SA1->A1_LOJA,.T.))
    		RecLock("GZN",.T.)
				GZN_FILIAL := XFILIAL("GZN")
				GZN_CODIGO := "000001"
				GZN_SEQ	   :=  GZN->(RecCount())
				GZN_CLIENT := SA1->A1_COD
				GZN_LOJA   := SA1->A1_LOJA
			MsUnLock()
	    Endif
    EndIf
Return
