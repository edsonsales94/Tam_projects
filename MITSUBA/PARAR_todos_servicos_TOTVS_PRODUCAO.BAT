echo script para parar todos os servicos TOTVS da Mitsuba
echo Tazoe 26/092025

echo Deseja continuar???
pause

net stop ".05.TOTVS P12 - CUSTO"
net stop ".06.TOTVS | TAF P12"
net stop ".07.TOTVS P12 - TSS"
net stop ".08.TOTVS P12 - TSS TAF"
net stop ".09.TOTVS P12 - SmartView REST"
net stop ".10.TOTVS P12 - COMPILACAO"
net stop ".04.TOTVS P12 - AppServer_Schedule"
net stop "TReports.Agent"

net stop ".02.TOTVS_P12_Broker_LoadBalance"
net stop ".03.TOTVS P12 - Broker_Remote_Server_01"
net stop ".03.TOTVS P12 - Broker_Remote_Server_02"
net stop ".03.TOTVS P12 - Broker_Remote_Server_03"
net stop ".03.TOTVS P12 - Broker_Remote_Server_04"

net stop ".01.TOTVS | DBAccess64 P12"
net stop "licenseVirtual"

pause
