"use strict";

var $docsservicossubstituicaoindex = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = () => {
        self.RemoveButtons();
    }

    self.RemoveButtons = () => {
        $('#F3MGrelhaFormDocumentosVendasServicosSubstituicaoBtAdd').remove();
        //$('#F3MGrelhaFormDocumentosVendasServicosSubstituicaoBtRemove').remove();
    }

    return parent;

}($docsservicossubstituicaoindex || {}, jQuery));

$(document).ready(() => $docsservicossubstituicaoindex.ajax.Init());