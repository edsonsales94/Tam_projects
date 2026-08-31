#Include 'Protheus.ch'

/*/{Protheus.doc} M103NUM
Ponto de entrada para customizar a numeração do Documento de Entrada (MATA103).
@type function
@author Advpl-Peer
@since 30/07/2026
@return character, O novo número do documento fiscal
/*/
User Function M103NUM()
  Local cNumCustom := "40075"
Return(cNumCustom)
