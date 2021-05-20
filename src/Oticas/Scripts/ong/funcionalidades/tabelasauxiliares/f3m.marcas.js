"use strict";

var $marcas = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constDisabled = base.constantes.grelhaBotoesCls.Disabled;
    var constCamposGen = base.constantes.camposGenericos;
    var campoEmExec = constCamposGen.IDEmExecucao;

    self.Init = function () {

    };

    self.EditaGrelha = function (grid, e) {
        if ($('#Codigo').val() == '') {
            self.CliqueLoadOpcao(window.location.pathname.replace('IndexGrelha', '') + '/ProximoCodigo', 'Codigo');
        }

        $('#Descricao').focus();
    }

    self.TrataValoresPorDefeito = function (grid, modelo) {
        if (UtilsVerificaObjetoNotNullUndefined(grid)) {
            var rowFicha = grid.tbody.find("tr[data-role='editable']").find("input#" + "Codigo")
            rowFicha.val(0);
        }
    }

    self.CliqueLoadOpcao = function (url, nome) {
        try {
            var objetoFiltro = GrelhaUtilsObjetoFiltro();

            UtilsChamadaAjax(url, false, objetoFiltro,
                function (res) {
                    if (UtilsVerificaObjetoNotNullUndefined(res)) {
                        var grid = $("#F3MGrelhaMarcas").data("kendoGrid");
                        var row= grid.tbody.find("tr[data-role='editable']").find("input#" + nome)
                        row.val(res);
                        row.change();
                    }
                }, function (fv) {
                    throw (fv)
                }, 1, true, null, null, 'html', 'GET');

        } catch (ex) {
        }
    };

    return parent;

}($marcas || {}, jQuery));

var MarcasInit = $marcas.ajax.Init;
var MarcasEditaGrelha = $marcas.ajax.EditaGrelha;

$(document).ready(function (e) {
    MarcasInit();
});