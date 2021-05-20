"use strict";

var $docstocks = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ H A N D S O N T A B L E
    /*@description funcao especifica das vendas que depois de adicionar uma linha atribui o campoAcaoCRUD como adicionar */
    self.AfterCreateRowEspecifico = function (hdsn, index, amount, source) {
        if ($('#CodigoSistemaTiposDocumento').val() === 'StkTrfArmazCTrans' && index >= 1) {
            var linhaDS = DocumentosStockRetornaHTDocLinhaDS(true);

            if (linhaDS && linhaDS[0] && linhaDS[0].hasOwnProperty('CodigoArtigo') && linhaDS[0]['CodigoArtigo'])
            {
                var linhaDSAnterior = hdsn.getSourceDataAtRow(index - 2);

                if (linhaDSAnterior && linhaDSAnterior['IDArtigo']) {
                    linhaDS[0]['IDArmazemDestino'] = linhaDSAnterior['IDArmazemDestino'];
                    linhaDS[0]['DescricaoArmazemDestino'] = linhaDSAnterior['DescricaoArmazemDestino'];

                    linhaDS[0]['IDArmazemLocalizacaoDestino'] = linhaDSAnterior['IDArmazemLocalizacaoDestino'];
                    linhaDS[0]['CodigoArmazemLocalizacaoDestino'] = linhaDSAnterior['CodigoArmazemLocalizacaoDestino'];
                    linhaDS[0]['DescricaoArmazemLocalizacaoDestino'] = linhaDSAnterior['DescricaoArmazemLocalizacaoDestino'];
                }
            }
        }
    };

    return parent;

}($docstocks || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//handsontable
var DocumentosAfterCreateRowEspecifico = $docstocks.ajax.AfterCreateRowEspecifico;