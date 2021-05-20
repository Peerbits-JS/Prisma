"use strict";

var $docsservicossubstituicao = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = () => {
        //shown tabs
        $(".clsF3MTabs a[role=tab]").on("shown.bs.tab", (e) => self.ShownTabs(e));
    }

    self.ShownTabs = (e) => {
        let tab = e.currentTarget.hash.replace("#", "");
        
        switch (tab) {
            case "tabArtigos":
                if ($docsservicossubstituicaoartigos.ajax.GetHdsnInstance()) {
                    $docsservicossubstituicaoartigos.ajax.GetHdsnInstance().render();
                }
                break;
        }
    }

    self.EnableDirty = () => GrelhaFormAtivaDesativaBotoesAcoes("F3MGrelhaFormDocumentosVendasServicosSubstituicao", true);

    self.GetModel  = function(model) {
        model.Servico = { DocumentosVendasLinhasGraduacoes: null, Artigos: null };

        model.Servico.DocumentosVendasLinhasGraduacoes = $docsservicossubstituicaograds.ajax.GetGrads();
        if ($docsservicossubstituicaoartigos.ajax.GetHdsnInstance()) {
            model.Servico.Artigos = $docsservicossubstituicaoartigos.ajax.GetHdsnSourceData();
        }

        return model;
    }

    self.ValidaEspecifica = function (grid, model, url) {
        //get grid options
        var options = grid.dataSource.transport.options;
        //set erros 
        var erros = null;
        //valida se nao esta a remover
        if (url !== options.destroy.url) {
            //get grid id
            var gridID = grid.element.attr('id');
            //get and set erros gen
            erros = GrelhaUtilsValida($('#' + gridID + 'Form'));

            if (erros === null) {
                var linhasValidas = $.grep(model['Servico']['Artigos'], (artigo) => artigo.CodigoArtigoOrigem && artigo.CodigoArtigoDestino).length;
            
                if (linhasValidas === 0) {
                    erros = [];
                    erros.push("O documento tem que ter pelo menos uma linha com artigo."); //TODO resx
                }

            }
        }
        //return erros ge || esp
        return erros;
    }

    return parent;

}($docsservicossubstituicao || {}, jQuery));

//actions
var AcoesRetornaModeloEspecifico = $docsservicossubstituicao.ajax.GetModel;
var DocumentosVendasServicosSubstituicaoValidaEspecifica = $docsservicossubstituicao.ajax.ValidaEspecifica;

$(document).ready((e) => $docsservicossubstituicao.ajax.Init());

$(document).ajaxSend((event, jqxhr, settings) => {
    var requestsBarLoding = ['ListaArtigosComboCodigo/ListaCombo', 'ValidaExisteArtigo'];
    KendoBarLoading(null, settings, requestsBarLoding);
}).ajaxStop(() => {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
    });

$(window).resize(function () {
    if (this.resizeTO) clearTimeout(this.resizeTO);
    this.resizeTO = setTimeout(() => {
        $docsservicossubstituicaoartigos.ajax.RedimensionaHT();
    }, 250);
});