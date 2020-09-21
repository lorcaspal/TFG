var nUtils = function () {
    return {
        formatDate: function(date){
           
            return formatAddZero(date.getDate()) + '/' + formatAddZero((date.getMonth() + 1)) + '/' + formatAddZero(date.getFullYear()) + ' ' + formatAddZero(date.getHours()) + ':' + formatAddZero(date.getMinutes()) + ':' + formatAddZero(date.getSeconds());
        }
    }
};

function formatAddZero(valor){
    return (valor < 10) ? '0' + valor: valor;
}
module.exports = nUtils;