"use strict";

var $tiposdocumento_esp = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    /* @description Funcao envia params da loja */
    self.LojasEnviaParams = function (inObjectoFiltro) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDEmpresa', '', constIDEmpresa);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'EApenasLojasSede', '', true);

        return objetoFiltro;
    };

    return parent;

}($tiposdocumento_esp || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var TiposDocumentoLojasEnviaParams = $tiposdocumento_esp.ajax.LojasEnviaParams

