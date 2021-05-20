"use strict";

var $tratamentoslentes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var campoMarcaID = 'IDMarca';
    const CAMPO_MODELO = 'IDModelo'

    self.Init = () =>  { }

    self.ModeloEnviaParametros = function (objetoFiltro) {
        var elemAux = $('#' + campoMarcaID);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoMarcaID);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoMarcaID);

        var elemAux = $('#View');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#View');
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'View');

        return objetoFiltro;
    }

    self.ChangeMarca = function (combo) {
        var cmbMod = KendoRetornaElemento($('#' + CAMPO_MODELO));

        if (UtilsVerificaObjetoNotNullUndefined(cmbMod)) {
            if (combo.selectedIndex == -1) {
                cmbMod.value('');
                cmbMod.enable(false);
            }
            else {
                cmbMod.value('');
                cmbMod.enable(true);
                cmbMod.dataSource.read();
            }
        }
    }

    self.FuncEspAdicionaF4TratamentosFromArtigos = function (iframeAux) {
        DDLDisabledComValor('#IDMarca', iframeAux.contents().find('#hdfIDMarca').val());

        KendoRetornaElemento($('#' + CAMPO_MODELO)).text(iframeAux.contents().find('#hdfDescricaoModelo').val());
        DDLDisabledComValor('#' + CAMPO_MODELO, iframeAux.contents().find('#hdfIDModelo').val());
    };

    self.FuncEspAdicionaF4TratamentosFromCatalogosLentes = function (iframeAux) {
        if (iframeAux.contents().find('#CatalogoLentes').val() != undefined) {
            DDLDisabledComValor('#IDMarca', iframeAux.contents().find('#hdfIDMarca').val());
            DDLDisabledComValor('#IDModelo', iframeAux.contents().find('#hdfIDModelo').val());
        }
        else {
            let windowOrigin = document.getWindowOrigin().parent.$('body');

            DDLDisabledComValor('#IDMarca', windowOrigin.find('#hdfIDMarca').val());

            KendoRetornaElemento($('#' + CAMPO_MODELO)).text(windowOrigin.find('#hdfDescricaoModelo').val());
            DDLDisabledComValor('#IDModelo', windowOrigin.find('#hdfIDModelo').val());
        }
    };

    return parent;

}($tratamentoslentes || {}, jQuery));

var TratamentosLentesModeloEnviaParams = $tratamentoslentes.ajax.ModeloEnviaParametros;
var TratamentosLentesIDMarcaChange = $tratamentoslentes.ajax.ChangeMarca;

//FUNCOES ESPECIFICAS DO F4
var ArtigosFuncEspAdicionaF4Tratamentos = $tratamentoslentes.ajax.FuncEspAdicionaF4TratamentosFromArtigos;
var CatalogosLentesFuncEspAdicionaF4Tratamentos = $tratamentoslentes.ajax.FuncEspAdicionaF4TratamentosFromCatalogosLentes;

$(document).ready(() => $tratamentoslentes.ajax.Init());