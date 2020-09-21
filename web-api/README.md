# Find your Star

## Instalación en local (Desarrollo)

### Requisitos

- Node 10 o superior
- Redis Server (`redis-server`)
- [Astrometry](http://astrometry.net/doc/build.html#build)

### Instalación de los archivos FITS para Astrometry

Para descargarse los archivos necesarios de Astrometry habrá que ejecutar los scripts de la carpeta *fitsAstrometry* indicandole en cada script la ruta donde debe guardarse esos ficheros.

        ./fitsAstrometry/getIndexFits4100.sh /usr/local/astrometry/data

### Instalación de módulos

Una vez están todos los requisitos instalados, se procederá a ejecutar el siguiente comando:

        npm install

### Instalación y ejecución de PM2

Para la instalación del módulo

```sh
    sudo npm install pm2 -g
 ```

La configuración del servicio en la ejecución, se puede ver en el archivo `pm2.json`. En este archivo se puede cambiar tanto las instancias a ejecutar como el puerto.


```sh
    pm2 start pm2.json
 ```

## Instalación en local (Producción)

Para una mayor seguridad y minimizado de archivos, se puede crear un servicio que se puede ejecutar en producción.

### Requisitos

- Node 10 o superior
- Redis Server (`redis-server`)
- [Astrometry](http://astrometry.net/doc/build.html#build)

### Instalación de módulos

Una vez están todos los requisitos instalados, se procederá a ejecutar el siguiente comando:

        npm install

### Creación de los archivos en producción

        npm run-script build

Esto genera una carpeta *dist* donde estarán todos los archivos necesarios para ejecutar el servicio.

### Instalación de los archivos FITS para Astrometry

Para descargarse los archivos necesarios de Astrometry habrá que ejecutar los scripts de la carpeta *fitsAstrometry*, dentro de la carpeta *dist*, indicandole en cada script la ruta donde debe guardarse esos ficheros.

        ./fitsAstrometry/getIndexFits4100.sh /usr/local/astrometry/data

### Instalación de módulos

Una vez están todos los requisitos instalados, se procederá a ejecutar el siguiente comando, dentro de la carpeta *dist*:

        npm install

### Instalación y ejecución de PM2

```sh
    sudo npm install pm2 -g
 ```

La configuración del servicio en la ejecución, se puede ver en el archivo `pm2.json`. En este archivo se puede cambiar tanto las instancias a ejecutar como el puerto.


```sh
    pm2 start pm2.json
 ```    

## Instalación en Docker

Para crearnos el contenedor en Docker, es necesario NodeJS para instalar los módulos de desarrollo y construir la carpeta *dist*.

### Requisitos

- Node 10 o superior
- Docker

### Instalación de módulos

Una vez están todos los requisitos instalados, se procederá a ejecutar el siguiente comando:

        npm install

### Creación de los archivos en producción

        npm run-script build

Esto genera una carpeta *dist* donde estarán todos los archivos necesarios para ejecutar el servicio y los que se usaran en la imagen del Docker.

### Creación de la imagen en Docker

        docker build -t find-your-star .

Este comando leerá el archivo *Dockerfile* y ejecutará cada comando dentro de él para construir una imagen de nuestra aplicación.

### Ejecución de Docker con Docker-Compose

Para que la aplicación funcione correctamente es necesario del servicio `server-redis`, por tanto el docker-compose ejecutará tanto el servicio Redis como la aplicación. 

En el archivo *docker-compose.yml* se pueden redirigir tanto el puerto de la web (**80**) como el puerto del socketIO (**3000**) y también cambiar la ruta donde se van a guardar las imágenes que se realizarán con la cámara. 

    ports:
        - "<puerto-socket>:3000"
        - "<puerto-web>:80"
    volumes:
        "<ruta-imagenes>:/usr/local/etc/tiempo_real"

```sh
    docker-compose up
```
