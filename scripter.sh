#!/bin/bash
awk 'BEGIN { FS = ";" } ; { print $1 }' < planilha.csv > unidades.txt
awk 'BEGIN { FS = ";" } ; { print $2 }' < planilha.csv > alarmes.txt
awk 'BEGIN { FS = ";" } ; { print $3 }' < planilha.csv > cftvs.txt
awk 'BEGIN { FS = ";" } ; { print $4 }' < planilha.csv > routers.txt

IFS=$'\n' read -d '' -r -a unidades < unidades.txt
IFS=$'\n' read -d '' -r -a alarmes < alarmes.txt
IFS=$'\n' read -d '' -r -a cftvs < cftvs.txt
IFS=$'\n' read -d '' -r -a routers < routers.txt

len=${#unidades[@]}
declare -a unis
for (( i=0; i<${len}; i++ ));
do
    unis[$i]=$(echo ${unidades[$i]} | sed 's/ /_/g');
done
counter=0
for (( j=0; j<${len}; j++ ));
do
((++counter))
touch ${unis[$j]}.txt
FILE=${unis[$j]}.txt
/bin/cat <<EOF >$FILE
Method      = Tcp
;--- Common properties ---
;DestFolder = Root\\ITENS-SEG\\
Title       = ${unidades[$j]}-CFTV              
Comment     = port: 80
RelatedURL  = http://${cftvs[$j]} 
CmntPattern = port: %TargetPort%
ScheduleMode= Regular
Schedule    = 
Interval    = 30
Alerts      = 
Alerts2     = 
ReverseAlert= No
UnknownIsBad= Yes
WarningIsBad= Yes
UseCommonLog= Yes
PrivLogMode = Default
CommLogMode = Default
MasterAFresh= No
;--- Test specific properties ---
Host    = ${cftvs[$j]}                        
Port    = 80
Timeout = 5000
EOF
done