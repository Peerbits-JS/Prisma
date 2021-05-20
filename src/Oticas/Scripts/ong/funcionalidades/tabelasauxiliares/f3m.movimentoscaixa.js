"use strict";

var $movimentoscaixa = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {
    };

    self.FormasPagamentoEnviaParams = function (objetoFiltro) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'Modulo', '', '006');
        return objetoFiltro;
    };
    
    self.FormasPagamentoChange = function (obj) {
        var natureza = UtilsVerificaObjetoNotNullUndefinedVazio(obj.dataItem()) == true ? obj.dataItem().Codigo : 'P';
        $('#Natureza').val(natureza);
    }

    self.AlteraMensagem = function () {
        $('#VerificaCaixaAberta').val(false);

        var grid = KendoRetornaElemento($("#F3MGrelhaFormMovimentosCaixa"));
        GrelhaFormAction(grid, base.constantes.grelhaBotoesIDs.GuardarFecha2);
    }

    /* @description funcao especifica que valida antes de gravar */
    self.ValidaGravaEspecifico = function (evt, inArrTabelas, inGrelha, inFormulario, inURL, inModelo, inElemBtID) {
        var url = rootDir + 'Caixas/MovimentosCaixa/CaixaEstaAberta';

        let contaCaixa = 0;
        let contaCaixaElem = KendoRetornaElemento($('#IDContaCaixa'));

        if (contaCaixaElem) {
            contaCaixa = contaCaixaElem.value() || 0;
        }

        $.post(url, { dataDocumento: $('#DataDocumento').val(), idcontaCaixa: contaCaixa }, (res) => {
            if (res) {
                //grava gen
                GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso);
            }
            else {
                //pergunta
                UtilsConfirma(base.constantes.tpalerta.question, "Este movimento altera os valores de caixa do dia " +  $('#DataDocumento').val() + ". Deseja continuar?", function () {
                    //grava gen
                    GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso);
                }, function () { return false; });
            }
        });
    };

    return parent;

}($movimentoscaixa || {}, jQuery));

var MovimentosCaixaInit = $movimentoscaixa.ajax.Init;
var MovimentosCaixaFormasPagamentoEnviaParams = $movimentoscaixa.ajax.FormasPagamentoEnviaParams;
var MovimentosCaixaFormasPagamentoChange = $movimentoscaixa.ajax.FormasPagamentoChange;
var MovimentosCaixaAlteraMensagem = $movimentoscaixa.ajax.AlteraMensagem;

var ValidaGravaEspecifico = $movimentoscaixa.ajax.ValidaGravaEspecifico;

$(document).ready(function (e) {
    MovimentosCaixaInit();
});
