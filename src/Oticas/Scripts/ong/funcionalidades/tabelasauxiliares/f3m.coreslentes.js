"use strict";

var $coreslentes = (function (parent, $) {
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

    self.FuncEspAdicionaF4CoresFromArtigos = function (iframeAux) {
        KendoRetornaElemento($('#' + CAMPO_MODELO)).text(iframeAux.contents().find('#hdfDescricaoModelo').val());
        DDLDisabledComValor('#' + CAMPO_MODELO, iframeAux.contents().find('#hdfIDModelo').val());

        DDLDisabledComValor('#IDTipoLente', iframeAux.contents().find('#hdfIDTipoLente').val());

        if (iframeAux.contents().find('#hdfCodigoTipoArtigo').val() == 'LO') {
            DDLDisabledComValor('#IDMateriaLente', iframeAux.contents().find('#hdfIDMateriaLente').val());
        }
        else {
            DDLDisabledComValor('#IDMateriaLente', '');
        }
        DDLDisabledComValor('#IDMarca', iframeAux.contents().find('#hdfIDMarca').val());
    };

    self.FuncEspAdicionaF4CoresFromCatalogosLentes = function (iframeAux) {
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

}($coreslentes || {}, jQuery));

var CoresLentesModeloEnviaParams = $coreslentes.ajax.ModeloEnviaParametros;
var CoresLentesTipoLenteEnviaParams = $coreslentes.ajax.TipoLenteEnviaParams;
var CoresLentesComboChange = $coreslentes.ajax.comboChange;

//FUNCOES ESPECIFICAS DO F4
var ArtigosFuncEspAdicionaF4Cores = $coreslentes.ajax.FuncEspAdicionaF4CoresFromArtigos;
var CatalogosLentesFuncEspAdicionaF4Cores = $coreslentes.ajax.FuncEspAdicionaF4CoresFromCatalogosLentes;

$(document).ready(() => $coreslentes.ajax.Init());