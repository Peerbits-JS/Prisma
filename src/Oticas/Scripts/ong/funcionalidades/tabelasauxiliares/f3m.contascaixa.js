"use strict";
var $contascaixa = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.EditaContaCaixa = function (_, evt) {
        let modeloLinha = evt.model;
        let temLoja = modeloLinha && modeloLinha.IDLoja > 0;

        KendoDesativaElemento('IDLoja', temLoja);
    };

    return parent;
}($contascaixa || {}, jQuery));

var ContasCaixaEdita = $contascaixa.ajax.EditaContaCaixa;
