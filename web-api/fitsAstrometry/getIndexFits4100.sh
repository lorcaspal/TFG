#!/bin/bash
# Basic if statement
declare -a name[subscript]
if [ $# -eq 1 ]
then
name=(4107 4108 4109 4110 4111 4112 4113 4114 4115 4116 4117 4118 4119)

cadena=''
now=$(date)
printf "Empezando Fits 4100:  %s\n" "$now"
for file in "${!name[@]}";
do
cadena=$cadena"http://data.astrometry.net/4100/index-${name[file]}.fits"$'\n'
done
echo ${cadena} | xargs -n 1 -P 24 wget -qc -t 5 -P $1

else
echo Debe indicar la ruta en la que quiere guardar los archivos.
fi
exit 0