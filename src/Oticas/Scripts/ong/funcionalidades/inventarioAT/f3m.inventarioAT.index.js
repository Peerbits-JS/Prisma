"use strict";

var $inventarioatindex = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ E X P O R T A
    /* @description funcao que faz download do ficheiro (xml /// csv) */
    self.Exporta = function (inElement) {
        //get id
        var id = inElement.getAttribute('f3m-data-id');
        //get file type 
        var idFileType = inElement.getAttribute('f3m-data-file-type');
        //verifica se tem id e tipo
        if (UtilsVerificaObjetoNotNullUndefinedVazio(id) && UtilsVerificaObjetoNotNullUndefinedVazio(idFileType)) {
            $.get(rootDir + 'Utilitarios/InventarioAT/PrepareFileExport' + '?id=' + id + '&fileType=' + idFileType).then(function (data) {
                window.location.href = rootDir + 'Utilitarios/InventarioAT/DownloadFile' + '?id=' + data.id;
                $('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid').dataSource.read();
            });
        }
    };

    return parent;

}($inventarioatindex || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//export
var InventarioATIndexExporta = $inventarioatindex.ajax.Exporta;


$(document).ajaxSend(function (inEvent, jqxhr, inSettings) {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
}).ajaxStop(function () {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
});