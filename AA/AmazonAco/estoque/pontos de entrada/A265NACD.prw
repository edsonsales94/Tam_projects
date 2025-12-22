#Include 'Protheus.ch'

User Function A265NACD()
    _ldRet := SDA->DA_LOCAL$ Alltrim( SuperGetMv("MV_XARMEND",.F.,"10") )+"/60"        
Return _ldRet

