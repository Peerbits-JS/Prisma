"use strict";

var $tiposconsultas = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    const idModulo = 2;
    const tiposEntidade = { receita: 'Receita', relatorio: 'Relatorio' };

    self.ReceitaEnviaParametros = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "IDModulo", '', idModulo);

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "EntidadeAux", '', tiposEntidade.receita);

        return objetoFiltro
    }

    self.RelatorioEnviaParametros = function(objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "IDModulo", '', idModulo);

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "EntidadeAux", '', tiposEntidade.relatorio);

        return objetoFiltro
    };
    
    return parent;

}($tiposconsultas || {}, jQuery));

var TiposConsultasReceitaEnviaParametros = $tiposconsultas.ajax.ReceitaEnviaParametros
var TiposConsultasRelatorioEnviaParametros = $tiposconsultas.ajax.RelatorioEnviaParametros;