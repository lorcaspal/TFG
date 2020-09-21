var express = require('express');
const chokidar = require("chokidar");
var api = express.Router();
var fs = require('fs');
var shell = require('shelljs');
var chalk = require('chalk'); // Asigna un color a un string por consola.
var redisServer = process.env.REDIS || 'localhost';
var nUtils = require('../utils/nUtils')();
//Variales para tiempo real y chokidar
var watcher;
var countUserWeb = 0;
var countUserMobile = 0;
var conversion = 0;
var paramsWeb;

//Creación del servidor socket.io escuchando por el puerto 3000
var io = require('socket.io')(3000, {
    serveClient: false,
    // below are engine.IO options
    pingInterval: 10000,
    pingTimeout: 5000,
    cookie: false
});

//Uso de redis comunicación adecuada entre dos nodos
const redis = require('socket.io-redis');
io.adapter(redis({
    host: redisServer,
    port: 6379
}));

//Conexion para el envio de la imagen y las dimensiones de la imagen
io.on('connection', (socket) => {
    //Variable para saber en que dispositivo estamos (web o movil)
    var tipo = socket.handshake.query['tipo'];
    //Variable para crear una room unica para cada movil que se conecte
    var uuid = socket.handshake.query['uuid'];
    if (tipo == 'web') {
        //Creamos habitacion star
        socket.join('star');
        io.of('/').adapter.clients(['star'], (err, clients) => {
            countUserWeb = clients.length; //Controlamos la cantidad de clientes en web conectados
            if (countUserWeb == 1) {
                //Cuado se conecta un usuario se activa el tiempo real
                console.log(chalk.green(nUtils.formatDate(new Date()) + ': ') + 'Activando el tiempo real para leer modificaciones en carpeta')
                watcher = chokidar
                    .watch("/usr/local/etc/tiempo_real/", {
                        ignoreInitial: true //Para coger la ultima imagen subida a la carpeta
                    })
                watcher
                    .on("add", path => {
                        //Sacamos las dimensiones de la imagen
                        var sizeOf = require('image-size');
                        sizeOf(path, function (err, dimensions) {
                            if (dimensions != null) {
                                //Convertimos las pixeles a escala
                                conversion = conversionToScale(dimensions.width, dimensions.height);
                            }
                            // Se usa el emit cuando el chokidar detecte una foto nueva y tengamos que pasarsela al cliente
                            // Mandar imagen
                            calculaCoordenadas(path, paramsWeb, function (result) {
                                io.to('star').emit('galeria', result);
                                //Si result tiene valores
                                if (result.params != undefined) {
                                    //Se guardan y se emiten para que flutter pueda acceder a ellos
                                    paramsWeb = result.params;
                                    io.to('star').emit('send_params', result.params);
                                }

                            });
                        });
                        // Conviertes imagen en base64
                        var buff = fs.readFileSync(path);
                        var base64data = buff.toString('base64');
                        //Se guardan los valores en las variables del result
                        var result = {
                            'title': path.replace("/usr/local/etc/tiempo_real/", ""),
                            'message': "Estamos cotejando la imagen, sea paciente :)",
                            'load': true,
                            'image': base64data,
                            'time': ''
                        }

                        //Emite los resultados
                        io.to('star').emit('galeria', result);

                    });

            }
            //Muestra por consola la cantiadad de usuarios conectados en web
            console.log(chalk.keyword('green')(nUtils.formatDate(new Date()) + ': ') + 'Usuario Conectado en web: ' + countUserWeb);

        });



    } else {
        //Creamos habitacion con id única
        socket.join(uuid);
        countUserMobile++
        //Muestra por consola la cantidad de usuarios que hay conectados a movil
        console.log(chalk.keyword('green')(nUtils.formatDate(new Date()) + ': ') + 'Usuario Conectado en móvil: ' + countUserMobile);
        //Escuchamos para recibir la imagen 
        socket.on('received_image', function (result) {
            var split = result.title.split('.');
            var path = split[0].replace(/:/g, '').replace(/ /g, '') + split[1] + '.' + split[2];

            //Para decodificar la imagen
            fs.writeFile('/usr/local/etc/galeria/' + path, result.image, 'base64', function (err, data) {
                //Calculamos las coordenadas de la imagen dada por el movil
                calculaCoordenadas('/usr/local/etc/galeria/' + path, result.params, (data) => {
                    //Emitimos la imagen
                    io.to(uuid).emit('galeria', data);
                    //En el caso de que tengamos las dimensiones
                    if (data.params != undefined) {
                        //Emitimos las dimensiones
                        io.to(uuid).emit('send_params', data.params);
                    }
                })
            })

        });
    }

    //Si se han guardado en la configuración las dimensiones, se reciven y se guardan en paramsWeb.
    socket.on('received_params', (params) => {
        console.log(chalk.keyword('blue')(nUtils.formatDate(new Date()) + ': ') + 'Se han recibido los parámetros', params);
        paramsWeb = params;
    })

    //Si nos salimos de la aplicacion se desconecta el socket
    socket.on('disconnect', (socket) => {
        if (tipo == 'web') {
            io.of('/').adapter.clients(['star'], (err, clients) => {
                //Cogemos la cantidad de usuarios conectados
                countUserWeb = clients.length;
                console.log(chalk.keyword('orange')(nUtils.formatDate(new Date()) + ': ') + 'Usuario desconectado en web: ' + countUserWeb);
                if (countUserWeb == 0 && watcher) {
                    console.log(chalk.keyword('orange')(nUtils.formatDate(new Date()) + ': ') + 'Desactivamos el tiempo real y paramos de leer modificaciones en la carpeta')
                    watcher.close();
                }
            });
        } else {
            countUserMobile--;
            console.log(chalk.keyword('orange')(nUtils.formatDate(new Date()) + ': ') + 'Usuario desconectado en móvil: ' + countUserMobile);
        }




    });
});


//Funcion para calcular las coordenadas
function calculaCoordenadas(path, params, callback) {
    var tiempo1 = new Date();

    //Mostramos por pantalla (en amarillo) que se está calculando la imagen
    console.log(chalk.keyword('yellow')(nUtils.formatDate(new Date()) + ': ') + 'Calculando imagen.....');

    /*Guardamos los parametros que son comunes a todas las llamadas:
        · solve-field: comando para resolución del arcchivo de imagen pasado
        · --cpulimit 300: tiempo limite que espera en segundos para resolver la imagen, en este caso 5 minutos
        · --downsample 4: variable para reducir el tamaño de la imagen y sea más facil encontrarla
        · --scale-units para usar un tipo de unidad de escala (arcominutos o grados)
    */
    var solveField = "solve-field --cpulimit 300 --downsample 4 --scale-units ";

    //Si no se han pasado los parametros de las dimensiones hacemos la conversion de pixeles a escala
    if (params == undefined || params == null) {
        solveField += "degwidth --scale-low " + conversion;
    } else { //Si no, comprobamos que tipo de escala tiene y ponemos el parametro adecuado (degwitdth o arcmindth)
        if (params.scale == "degwidth") {
            //En el caso de grados solo se pasa la dimension más grande
            solveField += "degwidth --scale-low " + params.max;
        } else { //En el caso de arcominutos se deben pasar ambas dimensiones
            solveField += "arcminwidth --scale-low " + params.min + " --scale-high " + params.max;
        }
    }
    //Por último se pasa la ruta donde está la imagen que se quiere cotejar y los resultados se guardaran en /usr/local/etc/coordenadas
    solveField += " " + path + " --overwrite -D /usr/local/etc/coordenadas";
    shell.exec(
        solveField, {
            silent: true //Si silent es true no se muestran la ejecución de solveField por consola
        },
        function (code, stdout, stderr) {
            var dimensiones;
            ///usr/local/etc/tiempo_real/IMG_20200812_235215.jpg
            var message;
            if (code != 0) {
                message = null;
                console.log(chalk.keyword('red')(nUtils.formatDate(new Date()) + ': '), stderr);

            } else {
                //Si no se ha encontrado ninguna estrella se manda mensaje de error
                if (stdout.search(/Did not solve/g) != -1) {
                    message = "No se ha encontrado ninguna estrella :(. Inténtelo de nuevo";
                    console.log(chalk.keyword('red')(nUtils.formatDate(new Date()) + ': ') + 'No se ha encontrado ninguna estrella');
                }
                //En caso contrario se realizan las acciones pertinentes
                else {
                    var salida = stdout.split("\n");
                    //JSON para guardar las dimensiones
                    var newParams = {};
                    //JSON para guardar las coordenadas
                    var coordenadas = {};
                    for (var i in salida) {

                        if (salida[i].search(/Field center/g) == 0) {
                            //Cogemos las coordenadas de ascension recta y declinación recta
                            if (salida[i].search(/H:M:S/g) != -1) {
                                //Nos quedamos solo con las coordenadas en tipo String
                                centros = salida[i].replace("Field center: (RA H:M:S, Dec D:M:S) = (", "").replace(").", "");
                                var dimensionCentros = centros.split(", ");
                                //Guardamos en el array dimensionesCentros cada una de ellas
                                var vRa = dimensionCentros[0];
                                var vDec = dimensionCentros[1];
                                coordenadas.ra = vRa;
                                coordenadas.dec = vDec
                            }
                        } else if (salida[i].search(/Field size/g) == 0) {
                            dimensiones = salida[i].replace("Field size: ", "");

                            //Si las dimensiones son dadas en arcminutos
                            if (salida[i].search(/arcminutes/g) != -1) {
                                dimensiones = dimensiones.replace(" arcminutes", "");
                                //Guardamos el tipo de escala que es en el JSON newParams 
                                newParams.scale = "arcminwidth";

                            }
                            //Si no, si son dadas en grados
                            else {
                                dimensiones = dimensiones.replace(" degrees", "");
                                //Guardamos el tipo de escala que es en el JSON newParams 
                                newParams.scale = "degwidth";

                            }
                            //Separamos los valores que hay a la derecha y a la izquierda de la " x "
                            var dimensionArray = dimensiones.split(" x ");
                            //Guardamos en variables las dos posiciones del array dado despues de hacer la separación
                            var v1 = parseFloat(dimensionArray[0]);
                            var v2 = parseFloat(dimensionArray[1]);

                            //Condición para controlar que el valor mayor siempre este en la variable max.
                            if (v1 > v2) {
                                newParams.max = v1;
                                newParams.min = v2;
                            } else {
                                newParams.max = v2;
                                newParams.min = v1;
                            }
                        } else if (salida[i].search(/Field rotation angle/g) == 0) {

                            //Dejamos solo el string que queremos.
                            var orientation = salida[i].replace("Field rotation angle: up is ", "");
                            //Dividimos y guardamos los valores deseados en un array
                            var orientationArray = orientation.split(" degrees ");
                            var orientationArray2 = orientation.split(" of ");

                            var v1Ori = orientationArray[0];
                            var v2Ori = orientationArray[1].replace(" of N", "");
                            var v3Ori = orientationArray2[1];

                            //Guardamos los valores en el JSON coordenadas.
                            coordenadas.gradosOri = v1Ori;
                            coordenadas.ori1 = v2Ori;
                            coordenadas.ori2 = v3Ori;
                        }


                    }
                }


            }
            var tiempo2 = new Date();
            var tiempoRestante = (tiempo2 - tiempo1);
            //Variable para el guardado del tiempo que ha tardado en encontrar o no las estrellas en la imagen
            var tiempoTotal = new Date(tiempoRestante).toISOString().substr(11, 8)

            //Mostramos por consola el tiempo con color verde
            console.log(chalk.keyword('green')(nUtils.formatDate(new Date()) + ': ') + 'Tiempo total: ' + tiempoTotal);

            //Variable para el guardado de la ruta de la imagen
            var pathCoord = path.replace("galeria", "coordenadas").replace("tiempo_real", "coordenadas").replace(".png", "-ngc.png").replace(".jpg", "-ngc.png");
            var error = false;

            //Si la busqueda falla se guarda la imagen de error (solo muestra puntos) y se envia un mensaje de error
            if (!fs.existsSync(pathCoord)) {
                error = true;
                //Se reemplaza el final del nombre para obtener la imagen de error que devuelve el solve-field
                pathCoord = pathCoord.replace("ngc", "objs");
                message = "No se ha encontrado ninguna estrella :(. Inténtelo de nuevo";
            }

            //Para convertir la imagen dada en la ruta pathCoord a base64
            var buff = fs.readFileSync(pathCoord);
            var base64data = buff.toString('base64');

            //Se crea un JSON con una key asociada a cada una de las variables que necesitamos mostrar
            var result = {
                //reemplazamos la ruta por "", para obtener solo el nombre de la imagen
                title: pathCoord.replace("/usr/local/etc/coordenadas/", ""),
                message: message,
                load: false,
                image: base64data,
                time: tiempoTotal,
                coordenadas: coordenadas
            }

            //Si se han obtenido los valores de las dimensiones (max y min)
            if (params == undefined || params == null && !error) {
                console.log(chalk.keyword('blue')(nUtils.formatDate(new Date()) + ': ') + 'Enviamos valores de la imagen para cálculo eficiente');
                result.params = newParams;
            }
            //Llamada a result para poder acceder a los resultados desde flutter
            callback(result)

        });

}

//Funcion para convertir los pixeles (dimensiones imagen) en escala (dimension soportada por el solve-field)
function conversionToScale(anchoP, altoP) {
    var ancho = anchoP / 3780;
    var alto = altoP / 3780;

    if (ancho > alto) {
        return ancho;
    } else {
        return alto;
    }
}

module.exports = api;