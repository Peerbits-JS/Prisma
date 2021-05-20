"use strict";

var $comparticipacoes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {
    };

    self.ValidaEspecifica = function (grid, data, url) {
        var erros = GrelhaUtilsValida($('#' + grid.element.attr('id') + 'Form'));

        if (erros != null) {
            return null;
        }

        if ( UtilsVerificaObjetoNotNullUndefinedVazio($('#PotenciaEsfericaAte').val()) || UtilsVerificaObjetoNotNullUndefinedVazio($('#PotenciaEsfericaDe').val()) ) {
            if (parseFloat($('#PotenciaEsfericaAte').val().replace(',', '.')) < parseFloat($('#PotenciaEsfericaDe').val().replace(',', '.'))) {
                erros = UtilsAdicionaRegistoArray(erros, resources['valida_intervalo_esfera']);
                return erros;
            };
        };

        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#PotenciaCilindricaAte').val()) || UtilsVerificaObjetoNotNullUndefinedVazio($('#PotenciaCilindricaDe').val())) {
            if (parseFloat($('#PotenciaCilindricaAte').val().replace(',', '.')) < parseFloat($('#PotenciaCilindricaDe').val().replace(',', '.'))) {
                erros = UtilsAdicionaRegistoArray(erros, resources['valida_intervalo_cilindro']);
                return erros;
            };
        };

        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#PotenciaPrismaticaAte').val()) || UtilsVerificaObjetoNotNullUndefinedVazio($('#PotenciaPrismaticaDe').val())) {
            if (parseFloat($('#PotenciaPrismaticaAte').val().replace(',', '.')) < parseFloat($('#PotenciaPrismaticaDe').val().replace(',', '.'))) {
                erros = UtilsAdicionaRegistoArray(erros, resources['valida_intervalo_prisma']);
                return erros;
            };
        };
    };
    return parent;

}($comparticipacoes || {}, jQuery));

var ComparticipacoesInit = $comparticipacoes.ajax.Init;
var ComparticipacoesValidaEspecifica = $comparticipacoes.ajax.ValidaEspecifica;

//$(document).ready(function (e) {
//    ComparticipacoesInit();
//});