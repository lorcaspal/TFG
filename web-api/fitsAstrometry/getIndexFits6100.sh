#!/bin/bash
# Basic if statement
declare -a name[subscript]
if [ $# -eq 1 ]
then
name=(6104-00 6104-01 6104-02 6104-03 6104-04 6104-05 6104-06 6104-07 6104-08 6104-09 6104-10 6104-11 6105-00 6105-01 6105-02 6105-03 6105-04 6105-05 6105-06 6105-07 6105-08 6105-09 6105-10 6105-11 6106-00 6106-01 6106-02 6106-03 6106-04 6106-05 6106-06 6106-07 6106-08 6106-09 6106-10 6106-11)

cadena=''
now=$(date)
printf "Empezando Fits 6100:  %s\n" "$now"
for file in "${!name[@]}";
do
cadena=$cadena"http://data.astrometry.net/6100/index-${name[file]}.fits"$'\n'
done
echo ${cadena} | xargs -n 1 -P 24 wget -qc -t 5 -P $1

else
echo Debe indicar la ruta en la que quiere guardar los archivos.
fi
exit 0