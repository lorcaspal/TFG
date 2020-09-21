var express = require('express');
var app = express();
var http = require('http').createServer(app);

var api = require("./routes/api");
var nUtils = require('./utils/nUtils')();

//Middleware de terceros
var morgan = require('morgan'); // Muestra información de la petición.
var chalk = require('chalk'); // Asigna un color a un string por consola.
var helmet = require('helmet'); // Ayuda a proteger la aplicación estableciento varias cabeceras HTTP
var bodyParser = require('body-parser'); // Accede a las variables en peticiones POST
var compression = require('compression');
// Variables
var port = process.env.PORT || 3000;
var enviroment = process.env.NODE_ENV || 'development';

app.use(helmet()); // Siempre primero, protección de la aplicación.

app.use(compression());
app.use(bodyParser.urlencoded({
    parameterLimit: 100000,
    limit: '3mb',
    extended: true
}));

var logger = morgan(formatoMorgan);
// Ruta virtual para acceder a la carpeta de views
if (enviroment == 'development') {
    app.use('/vistas', express.static(__dirname + '/views'));

} else {
    app.use('/vistas', express.static('./views'));
}

app.use('/api', logger);
app.get('/', function (req, res) {
    res.redirect('/vistas/web');
});

app.use('/api', api);

// Ejemplo de uso del get
// app.get('/lorena', function (req, res) {
//     res.send('Hello World! Lorena');
// });

//The 404 Route (ALWAYS Keep this as the last route)
app.get('*', function (req, res, next) {
    res.status(404);
    next("Esta página no existe");
});

app.use(errorHandler);



// Puerto de escucha del servidor
http.listen(port, function () {
    console.log(chalk.green('**********************************************************'))
    console.log(chalk.green('*                  Iniciando Servidor                    *'))
    console.log(chalk.green('*                    FIND YOUR STAR                      *'))
    console.log(chalk.green('*                  ' + nUtils.formatDate(new Date()) + '                   *'))
    console.log(chalk.green('**********************************************************'))
    console.log(chalk.blue('Escuchando en el puerto ' + port + '!'));
});



//Función de manejo de errores
function errorHandler(err, req, res, next) {
    // res.status(404);
    res.json({
        error: err
    });
}

//Función para mostrar por consola información de las peticiones con coloritos :)
function formatoMorgan(tokens, req, res) {
    var method = tokens.method(req, res);
    switch (method) {
        case 'GET':
            method = chalk.blue(method);
            break;
        case 'POST':
            method = chalk.green(method);
            break;
        case 'PUT':
            method = chalk.orange(method);
            break;
        case 'DELETE':
            method = chalk.red(method);
            break;
    }
    var status = tokens.status(req, res);
    var url = tokens.url(req, res);
    switch (status) {
        case '404':
            status = chalk.hex('#ffbf00')(status);
            url = chalk.hex('#ffbf00')(url);
            break;
        case '550':
            status = chalk.magenta(status);
            url = chalk.magenta(url);
            break;
        case '500':
            status = chalk.red(status);
            url = chalk.red(url);
            break;
        default:
            status = chalk.green(status);
            url = chalk.green(url);
            break;
    }
    return [
        nUtils.formatDate(new Date()) + ':',
        method,
        url,
        status,
        // tokens.res(req, res, 'content-length'), '-',
        chalk.hex('#f88379')(tokens['response-time'](req, res), 'ms')
    ].join(' ')
}