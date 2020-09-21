#!/bin/bash
# Basic if statement
declare -a name[subscript]
if [ $# -eq 1 ]
then
name=(4200-00 4200-01 4200-02 4200-03 4200-04 4200-05 4200-06 4200-07 4200-08 4200-09 4200-10 4200-11 4200-12 4200-13 4200-14 4200-15 4200-16 4200-17 4200-18 4200-19 4200-20 4200-21 4200-22 4200-23 4200-24 4200-25 4200-26 4200-27 4200-28 4200-29 4200-30 4200-31 4200-32 4200-33 4200-34 4200-35 4200-36 4200-37 4200-38 4200-39 4200-40 4200-41 4200-42 4200-43 4200-44 4200-45 4200-46 4200-47 4201-00 4201-01 4201-02 4201-03 4201-04 4201-05 4201-06 4201-07 4201-08 4201-09 4201-10 4201-11 4201-12 4201-13 4201-14 4201-15 4201-16 4201-17 4201-18 4201-19 4201-20 4201-21 4201-22 4201-23 4201-24 4201-25 4201-26 4201-27 4201-28 4201-29 4201-30 4201-31 4201-32 4201-33 4201-34 4201-35 4201-36 4201-37 4201-38 4201-39 4201-40 4201-41 4201-42 4201-43 4201-44 4201-45 4201-46 4201-47 4202-00 4202-01 4202-02 4202-03 4202-04 4202-05 4202-06 4202-07 4202-08 4202-09 4202-10 4202-11 4202-12 4202-13 4202-14 4202-15 4202-16 4202-17 4202-18 4202-19 4202-20 4202-21 4202-22 4202-23 4202-24 4202-25 4202-26 4202-27 4202-28 4202-29 4202-30 4202-31 4202-32 4202-33 4202-34 4202-35 4202-36 4202-37 4202-38 4202-39 4202-40 4202-41 4202-42 4202-43 4202-44 4202-45 4202-46 4202-47 4203-00 4203-01 4203-02 4203-03 4203-04 4203-05 4203-06 4203-07 4203-08 4203-09 4203-10 4203-11 4203-12 4203-13 4203-14 4203-15 4203-16 4203-17 4203-18 4203-19 4203-20 4203-21 4203-22 4203-23 4203-24 4203-25 4203-26 4203-27 4203-28 4203-29 4203-30 4203-31 4203-32 4203-33 4203-34 4203-35 4203-36 4203-37 4203-38 4203-39 4203-40 4203-41 4203-42 4203-43 4203-44 4203-45 4203-46 4203-47 4204-00 4204-01 4204-02 4204-03 4204-04 4204-05 4204-06 4204-07 4204-08 4204-09 4204-10 4204-11 4204-12 4204-13 4204-14 4204-15 4204-16 4204-17 4204-18 4204-19 4204-20 4204-21 4204-22 4204-23 4204-24 4204-25 4204-26 4204-27 4204-28 4204-29 4204-30 4204-31 4204-32 4204-33 4204-34 4204-35 4204-36 4204-37 4204-38 4204-39 4204-40 4204-41 4204-42 4204-43 4204-44 4204-45 4204-46 4204-47 4205-00 4205-01 4205-02 4205-03 4205-04 4205-05 4205-06 4205-07 4205-08 4205-09 4205-10 4205-11 4206-00 4206-01 4206-02 4206-03 4206-04 4206-05 4206-06 4206-07 4206-08 4206-09 4206-10 4206-11 4207-00 4207-01 4207-02 4207-03 4207-04 4207-05 4207-06 4207-07 4207-08 4207-09 4207-10 4207-11 4208 4209 4210 4211 4212 4213 4214 4215 4216 4217 4218 4219)

cadena=''
now=$(date)
printf "Empezando Fits 42000:  %s\n" "$now"
for file in "${!name[@]}";
do
cadena=$cadena"http://data.astrometry.net/4200/index-${name[file]}.fits"$'\n'
done
echo ${cadena} | xargs -n 1 -P 24 wget -qc -t 5 -P $1

else
echo Debe indicar la ruta en la que quiere guardar los archivos.
fi
exit 0