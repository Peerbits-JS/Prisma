"use strict";

var $medicostecnicosindexgrelha = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.EnviaParametros = function (objFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objFiltro, true, 'Ativo', '', true);
        return objFiltro;
    };

    return parent;

}($medicostecnicosindexgrelha || {}, jQuery));

var MedicosTecnicosIndexGrelhaEnviaParametros = $medicostecnicosindexgrelha.ajax.EnviaParametros;