

USER FUNCTION BENVIA(ADADOS, CVERBO, CENDPOINT, CPATH,CPARTICIO)
    LOCAL _I	:= 0
    LOCAL OOBJ  := NIL               
    LOCAL CRET := U_SNDJSON(ADADOS, CVERBO, CENDPOINT, CPATH)
    LOCAL LSUCESS := VALTYPE(CRET) == "C" .AND. "SUCCESS" $ UPPER(CRET)
    LOCAL NMAXIMO := 1500
    PRIVATE AOBJETO
    PRIVATE OOBJ2 := NIL             
    PRIVATE ORETORNO := NIL

    IF LEN(ALLTRIM(CRET)) > 0
        
        CRET  := U_TiraGraf(decodeutf8(CRET))
        CRET2 := CRET
        
        FWJSONDESERIALIZE(CRET,@OOBJ)
        
        SA1->(DBSETORDER(1))
        IF VALTYPE(OOBJ) == "O"
            IF LSUCESS
                IF CVERBO != "DELETE"           
                    IF (CPARTICIO == "1" .AND. LEN(ADADOS) < NMAXIMO) .OR. CPARTICIO != "1"
                        IF &(CTAB1+"->"+CTAB1+"_TIPO") == "1"//ZM1->ZM1_TIPO == "1"
                            RECLOCK(CTAB1,.F.)
                            &(CTAB1+"->"+CTAB1+"_FLAG") := "S" //ZM1->ZM1_FLAG := "S"
                            (CTAB1)->(MSUNLOCK())					
                        ENDIF
                    ENDIF                        
                ENDIF

                //RODA A FUNÇÃO QUANDO FOR GET
                IF CVERBO != "DELETE" .AND. CMETODO == "3" .AND. CENDPOINT != "RetornoStatus" .AND. CENDPOINT != "RetornoClientes"
                    //TEM QUE PERCORRER O OBJETO E IR GERANDO OS PEDIDOS DE VENDA  
                    AOBJETO := OOBJ:SUCCESS
                    FOR _I := 1 TO LEN(AOBJETO) 
                        FWJSONDESERIALIZE(AOBJETO[_I]:OBJETO_JSON,@OOBJ2)
                        ORETORNO:= OOBJ2				
                        IF !EMPTY(&(CTAB1+"->"+CTAB1+"_FUNCAO"))
                            &(&(CTAB1+"->"+CTAB1+"_FUNCAO"))
                        ENDIF			
                    NEXT _I
                ENDIF
            ELSE
                IF CVERBO != "DELETE" .AND. &(CTAB1+"->"+CTAB1+"_TIPO") == "1"
                    RECLOCK(CTAB1,.F.)
                    &(CTAB1+"->"+CTAB1+"_FLAG") := "" //ZM1->ZM1_FLAG := ""
                    (CTAB1)->(MSUNLOCK())
                ENDIF 			
            ENDIF
        ENDIF
    ENDIF
RETURN
