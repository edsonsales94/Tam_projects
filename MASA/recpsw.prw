#include "protheus.ch"

User Function GetAdminData()
	Local LAMB := RPCSETENV('01','01')
    Local cArqHlp := 'SIGAPSS.SPF'
	Local cChave1	:= ''
	Local cChave2	:= ''
	Local cChave3	:= ''
	Local cHelp		:= ''
	Local aHelp		:= {}
	Local cUser := "000000"
	Local aFields := SPF_GETFIELDS( cArqHlp,1)

	ConOut("Usuário: " + cUser)
	ConOut("MD5: " + aFields[1])
	ConOut("Checksum: " + aFields[2])
Return
