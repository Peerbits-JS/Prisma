"use strict";

var $suplementoslentes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var campoIDMarca = 'IDMarca';
    var campoIDMateriaLente = 'IDMateriaLente';
    var campoIDTipolente = 'IDTipoLente';
    const CAMPO_MODELO = 'IDModelo'

    self.Init = () => { };

    self.ModeloEnviaParametros = function (objetoFiltro) {
        var elemAux = $('#' + campoIDMarca);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDMarca);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoIDMarca);

        var elemAux = $('#' + campoIDMateriaLente);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDMateriaLente);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoIDMateriaLente);

        var elemAux = $('#' + campoIDTipolente);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDTipolente);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoIDTipolente);

        var elemAux = $('#View');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#View');
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'View');

        return objetoFiltro;
    };

    self.TipoLenteEnviaParams = function (objetoFiltro) {
        var elemAux = $('#View');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#View');

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'View');

        return objetoFiltro;
    };

    self.comboChange = function (combo) {
        if (KendoRetornaElemento($('#IDTipoLente')).selectedIndex == 0 || KendoRetornaElemento($('#IDMateriaLente')).selectedIndex == 0 || KendoRetornaElemento($('#IDMarca')).selectedIndex == -1) {
            KendoRetornaElemento($('#IDModelo')).value('');
            KendoRetornaElemento($('#IDModelo')).enable(false);
        }
        else {
            KendoRetornaElemento($('#IDModelo')).value('');
            KendoRetornaElemento($('#IDModelo')).enable(true);
            KendoRetornaElemento($('#IDModelo')).dataSource.read();
        }
    };

    self.SuplementosFuncEspAdicionaF4 = function (iframeAux) {
        if (iframeAux.contents().find('#CatalogoLentes').val() != undefined) {
            DDLDisabledComValor('#IDTipoLente', iframeAux.contents().find('#hdfIDTipoLente').val());
            DDLDisabledComValor('#IDMateriaLente', iframeAux.contents().find('#hdfIDMateriaLente').val());
            DDLDisabledComValor('#IDMarca', iframeAux.contents().find('#hdfIDMarca').val());
            DDLDisabledComValor('#IDModelo', iframeAux.contents().find('#hdfIDModelo').val());
        }
        else {
            let windowOrigin = document.getWindowOrigin().parent.$('body');

            DDLDisabledComValor('#IDTipoLente', windowOrigin.find('#hdfIDTipoLente').val());
            DDLDisabledComValor('#IDMateriaLente', windowOrigin.find('#hdfIDMateriaLente').val());
            DDLDisabledComValor('#IDMarca', windowOrigin.find('#hdfIDMarca').val());

            KendoRetornaElemento($('#' + CAMPO_MODELO)).text(windowOrigin.find('#hdfDescricaoModelo').val());
            DDLDisabledComValor('#IDModelo', windowOrigin.find('#hdfIDModelo').val());
        }
    };

    return parent;

}($suplementoslentes || {}, jQuery));

var SuplementosLentesModeloEnviaParams = $suplementoslentes.ajax.ModeloEnviaParametros;
var SuplementosLentesTipoLenteEnviaParams = $suplementoslentes.ajax.TipoLenteEnviaParams;
var SuplementosLentesComboChange = $suplementoslentes.ajax.comboChange;

//FUNCOES ESPECIFICAS DO F4
var CatalogoLentesSuplementosFuncEspAdicionaF4 = $suplementoslentes.ajax.SuplementosFuncEspAdicionaF4;

$(document).ready(() => $suplementoslentes.ajax.Init());