#!/bin/bash
# Basic if statement
declare -a name[subscript]
if [ $# -eq 1 ]
then
name=(6004-00 6004-01 6004-02 6004-03 6004-04 6004-05 6004-06 6004-07 6004-08 6004-09 6004-10 6004-11 6005-00 6005-01 6005-02 6005-03 6005-04 6005-05 6005-06 6005-07 6005-08 6005-09 6005-10 6005-11 6006-00 6006-01 6006-02 6006-03 6006-04 6006-05 6006-06 6006-07 6006-08 6006-09 6006-10 6006-11)


cadena=''
now=$(date)
printf "Empezando Fits 6000:  %s\n" "$now"
for file in "${!name[@]}";
do
cadena=$cadena"http://data.astrometry.net/6000/index-${name[file]}.fits"$'\n'
done
echo ${cadena} | xargs -n 1 -P 24 wget -qc -t 5 -P $1

else
echo Debe indicar la ruta en la que quiere guardar los archivos.
fi
exit 0