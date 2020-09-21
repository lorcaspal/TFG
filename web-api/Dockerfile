# Imagen de la versión lite de Debian 9
FROM debian:stretch-slim

# Carpeta donde se guardarán los archivos del servicio
WORKDIR /usr/local/app
# Copiamos la carpeta dist a la carpeta creada anteriormente
COPY dist .

# Creamos las carpetas que usará el servicio para el calculo de imagenes
RUN mkdir -p /usr/local/etc/galeria
RUN mkdir -p /usr/local/etc/coordenadas
RUN mkdir -p /usr/local/etc/tiempo_real

# Actualizamos y añadimos dependencias necesarias
RUN apt-get update
RUN apt-get -y install curl gnupg wget

# Instalamos la versión 10 de NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -
RUN apt-get -y install nodejs

# # Instalamos pm2 para ejecutar el servicio con Cluster
RUN npm install pm2 -g

# Instalamos astrometry (versiones probadas 0.78 y 0.80) y sus archivos
RUN wget http://astrometry.net/downloads/astrometry.net-latest.tar.gz
RUN tar xvzf astrometry.net-latest.tar.gz
RUN rm astrometry.net-*.gz

# RUN apt-get -y install libcairo2-dev libnetpbm10-dev netpbm libpng-dev libjpeg-dev python-numpy python-pyfits python-dev zlib1g-dev libbz2-dev swig libcfitsio-dev python-pip python3-pip
RUN apt-get -yq install libcairo2-dev libnetpbm10-dev netpbm \
                       libpng-dev libjpeg-dev python-numpy \
                       python-pyfits python-dev zlib1g-dev \
                       libbz2-dev swig libcfitsio-dev python-pip python3-pip
                       
RUN pip3 install -U numpy astropy

RUN cd astrometry.net-* && make 
RUN cd astrometry.net-* && make py
RUN cd astrometry.net-* && make extra
RUN cd astrometry.net-* && make install

# Eliminamos la carpeta de instalación de astrometry
RUN rm -r astrometry.net-* 

# Permiso de ejecución a los script ( por si no los tuviese )
RUN chmod +x ./fitsAstrometry/*

# Ejecutamos Script para descargar los archivos fits de las estrellas
RUN ./fitsAstrometry/getIndexFits4100.sh /usr/local/astrometry/data
RUN ./fitsAstrometry/getIndexFits4200.sh /usr/local/astrometry/data
RUN ./fitsAstrometry/getIndexFits5000.sh /usr/local/astrometry/data
RUN ./fitsAstrometry/getIndexFits6000.sh /usr/local/astrometry/data
RUN ./fitsAstrometry/getIndexFits6100.sh /usr/local/astrometry/data

# Añadimos ruta para los comandos de astrometry
ENV PATH="$PATH:/usr/local/astrometry/bin"

# Instalamos los modulos necesarios
RUN npm install

# Levantamos el servicio con la configuración del archivo pm2.json
CMD ["pm2-runtime", "pm2.json"]