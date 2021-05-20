"use strict";

var $modelosartigos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constDisabled = base.constantes.grelhaBotoesCls.Disabled;

    self.Init = () => {
    };

    self.TipoArtigoEnviaParams = function (objetoFiltro) {
        var elemAux = $('#IDTipoArtigo');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#IDTipoArtigo');

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDTipoArtigo');

        return objetoFiltro;
    };

    self.comboChange = function (combo) {
        if (combo.dataItem().CodigoSistemaTipoArtigo != 'LO' && combo.dataItem().CodigoSistemaTipoArtigo != 'LC') {
            KendoRetornaElemento($('#IDTipoLente')).value('');
            KendoRetornaElemento($('#IDTipoLente')).enable(false);
            KendoRetornaElemento($('#IDMateriaLente')).value('');
            KendoRetornaElemento($('#IDMateriaLente')).enable(false);
            KendoColocaElementoObrigatorio(($('#IDTipoLente')), false);
            KendoColocaElementoObrigatorio(($('#IDMateriaLente')), false);

            KendoRetornaElemento($('#IDSuperficieLente')).value('');
            KendoRetornaElemento($('#IDSuperficieLente')).enable(false);
            KendoColocaElementoObrigatorio(($('#IDSuperficieLente')), false);
            $('#Fotocromatica').prop(constDisabled, true).parent().parent().addClass(constDisabled);
        }
        else {

            var objetoFiltro = GrelhaUtilsObjetoFiltro();
            self.TipoArtigoEnviaParams(objetoFiltro);

            KendoColocaElementoObrigatorio(($('#IDTipoLente')), true);
            KendoRetornaElemento($('#IDTipoLente')).value('');
            KendoRetornaElemento($('#IDTipoLente')).enable(true);
            KendoRetornaElemento($('#IDTipoLente')).dataSource.read();

            KendoRetornaElemento($('#IDSuperficieLente')).value('');
            KendoRetornaElemento($('#IDSuperficieLente')).enable(true);
            KendoRetornaElemento($('#IDSuperficieLente')).dataSource.read();
            $('#Fotocromatica').prop(constDisabled, false).parent().parent().removeClass(constDisabled);

            if (combo.dataItem().CodigoSistemaTipoArtigo == 'LO') {
                KendoRetornaElemento($('#IDMateriaLente')).value('');
                KendoRetornaElemento($('#IDMateriaLente')).enable(true);
                KendoColocaElementoObrigatorio(($('#IDMateriaLente')), true);
            }
            else {
                KendoRetornaElemento($('#IDMateriaLente')).value('');
                KendoRetornaElemento($('#IDMateriaLente')).enable(false);
                KendoColocaElementoObrigatorio(($('#IDMateriaLente')), false);
            }
        }
    };

    self.FuncEspAdicionaF4ModelosFromArtigos = function (iframeAux) {
        DDLDisabledComValor('#IDTipoArtigo', iframeAux.contents().find('#hdfIDTipoArtigo').val());
        DDLDisabledComValor('#IDMarca', iframeAux.contents().find('#hdfIDMarca').val());
        ModelosArtigosTipoArtigoChange(KendoRetornaElemento($('#IDTipoArtigo')));
    };

    self.FuncEspAdicionaF4ModelosFromCatalogosLentes = function (iframeAux) {
        if (iframeAux.contents().find('#CatalogoLentes').val() != undefined) {
            DDLDisabledComValor('#IDTipoArtigo', iframeAux.contents().find('#hdfIDTipoArtigo').val());
            DDLDisabledComValor('#IDTipoLente', iframeAux.contents().find('#hdfIDTipoLente').val());

            if (iframeAux.contents().find('#hdfCodigoTipoArtigo').val() == 'LO') {
                DDLDisabledComValor('#IDMateriaLente', iframeAux.contents().find('#hdfIDMateriaLente').val());
            }
            else {
                DDLDisabledComValor('#IDMateriaLente', '');
            }
            DDLDisabledComValor('#IDMarca', iframeAux.contents().find('#hdfIDMarca').val());

            $('#Fotocromatica').prop('checked',  iframeAux.contents().find('#fotocromatica').is(':checked'));
            $('#Fotocromatica').prop('disabled', true);

            let indiceRefracao = document.getWindowOrigin().parent.$catalogolentes.ajax.getDataItemSelected("F3MListViewIndices", "IndiceRefracaoAux");
            if (indiceRefracao != null) {
                KendoRetornaElemento($('#IndiceRefracao')).value(indiceRefracao);
                KendoDesativaElemento('IndiceRefracao', true);
            }
        }
        else {
            let windowOrigin = document.getWindowOrigin().parent.$('body');

            DDLDisabledComValor('#IDTipoArtigo', windowOrigin.find('#hdfIDTipoArtigo').val());
            DDLDisabledComValor('#IDTipoLente', windowOrigin.find('#hdfIDTipoLente').val());

            if (windowOrigin.find('#hdfCodigoTipoArtigo').val() == 'LO') {
                DDLDisabledComValor('#IDMateriaLente', windowOrigin.find('#hdfIDMateriaLente').val());
            }
            else {
                DDLDisabledComValor('#IDMateriaLente', '');
            }
            DDLDisabledComValor('#IDMarca', windowOrigin.find('#hdfIDMarca').val());

            let indiceRefracao = document.getWindowOrigin().parent.$catalogolentes.ajax.getDataItemSelected("F3MListViewIndices", "IndiceRefracaoAux");
            if (indiceRefracao != null) {
                KendoRetornaElemento($('#IndiceRefracao')).value(indiceRefracao);
                KendoDesativaElemento('IndiceRefracao', true);
            }

            $('#Fotocromatica').prop('checked', windowOrigin.find('#fotocromatica').is(':checked'));
            $('#Fotocromatica').prop('disabled', true);
        }
    };

    return parent;

}($modelosartigos || {}, jQuery));

var ModelosArtigosTipoArtigoChange = $modelosartigos.ajax.comboChange;
var ModelosArtigosTipoArtigoEnviaParams = $modelosartigos.ajax.TipoArtigoEnviaParams;

//FUNCOES ESPECIFICAS DO F4
var ArtigosFuncEspAdicionaF4Modelos = $modelosartigos.ajax.FuncEspAdicionaF4ModelosFromArtigos;
var CatalogosLentesFuncEspAdicionaF4Modelos = $modelosartigos.ajax.FuncEspAdicionaF4ModelosFromCatalogosLentes;

$(document).ready(() => $modelosartigos.ajax.Init());