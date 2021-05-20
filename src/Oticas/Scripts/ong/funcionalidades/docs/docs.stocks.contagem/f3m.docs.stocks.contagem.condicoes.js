"use strict";

var $docsstockscontagemcondicoes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //main div container
    var container = 'condicoes';

    //badges
    var badges = {
        IDTipoArtigo: 'CLSF3MLadoEsqTipoArtigo',
        IDMarca: 'CLSF3MLadoEsqMarca',
        Outros: 'CLSF3MLadoEsqOutro'
    };

    //attr tips de contagem
    var tiposcontagem = {
        carregar: 'carregar',
        reiniciar: 'reiniciar'
    };
    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind aplicar filtros
        $('#btnAplicarFiltros').off().on('click', function (e) {
            e.preventDefault();

            self.AplicaFiltros(e);
            //blur button
            this.blur();

            e.stopImmediatePropagation();
            return false;
        });
    };

    //------------------------------------ 
    /* @description funcao do carrega os artigos */
    self.AplicaFiltros = function (e) {
        //get elemento
        var _elem = $(e.target);
        //get tipo de contagem
        var _type = _elem.attr('data-f3mtype');

        switch (_type) {
            case tiposcontagem.carregar:
                //set text and new attr
                //_elem.text('Reiniciar contagem').attr('data-f3mtype', tiposcontagem.reiniciar);
                //bloqueia tudo
                DocsStocksContagemBloqueiaOuDesbloqueiaTudo(true);
                //carrega hdsn
                DocsStocksContagemGrelhaObtemArtigos();
                break;

            case tiposcontagem.reiniciar:
                //set text and new attr
                //_elem.text('Carregar').attr('data-f3mtype', tiposcontagem.carregar);

                //pergunta se pretende reiniciar a contagem - Existem alterações efectuadas neste documento. Deseja continuar?
                UtilsAlerta(base.constantes.tpalerta.question, resources['ReinicarContagemStock'], function () {
                    //desbloqueia tudo
                    DocsStocksContagemBloqueiaOuDesbloqueiaTudo(false);
                    //reset hdsn
                    DocsStocksContagemGrelhaLoadDataHT([]);
                    //set dirty
                    GrelhaFormAtivaDesativaBotoesAcoes("F3MGrelhaFormDocumentosStockContagem", true);
                }, function () { return false; });
                break;
        }
    };

    //------------------------------------ C H A N G E S
    /* @description funcao change do lookup idtipoartigo */
    self.ChangeTipoArtigo = function (inMultiSelect) {
        //set badge text
        $('.' + badges.IDTipoArtigo).text(inMultiSelect.value().length);
    };

    /* @description funcao change do lookup idmarca */
    self.ChangeMarca = function (inMultiSelect) {
        //set badge text
        $('.' + badges.IDMarca).text(inMultiSelect.value().length);
    };

    /* @description funcao change das checkbox */
    self.ChangeOutrasCondicoes = function (e) {
        //set badge text
        $('.' + badges.Outros).text($('.clsF3MOutrasCondicoes :checked').length);
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /* @description funcao que retorna o modelo das condicoes */
    self.RetornaModelCondicoes = function () {
        return GrelhaUtilsGetModeloForm(GrelhaFormDTO($('#' + container)));
    };

    return parent;

}($docsstockscontagemcondicoes || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemCondicoesInit = $docsstockscontagemcondicoes.ajax.Init;
//changes
var DocsStocksContagemCondicoesChangeTipoArtigo = $docsstockscontagemcondicoes.ajax.ChangeTipoArtigo;
var DocsStocksContagemCondicoesChangeMarca = $docsstockscontagemcondicoes.ajax.ChangeMarca;
var DocsStocksContagemCondicoesChangeOutrasCondicoes = $docsstockscontagemcondicoes.ajax.ChangeOutrasCondicoes;
//funcoes auxiliares
var DocsStockContagemCondicoesRetornaModel = $docsstockscontagemcondicoes.ajax.RetornaModelCondicoes;

$(document).ready(function (e) {
    //init
    DocsStocksContagemCondicoesInit();
});