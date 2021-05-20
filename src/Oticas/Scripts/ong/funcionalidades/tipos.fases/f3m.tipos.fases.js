"use strict";

var $tipos_fases = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes 
    const sistemaClassificacoesTiposArtigos = 'IDSistemaClassificacoesTiposArtigos', sistemaTiposOlhos = 'IDSistemaTiposOlhos';
    const gridId = 'F3MGrelhaTiposFases';

    //------------------------------------ G R I D
    /* @description Funcao edit da grelha tipos fases */
    self.GridEdit = function (grid, e) {
        if (self.GetCurrentEditorRow().ID === 0) {
            //disabled
            KendoDesativaElemento(sistemaTiposOlhos, true);
        }
    };

    /* @description Funcao que retorna o data item da grid */
    self.GetCurrentEditorRow = function () {
        var elemGrid = KendoRetornaElemento($('#' + gridId));
        return elemGrid.dataItem(elemGrid.tbody.find('tr.k-grid-edit-row'));
    };

    //------------------------------------ S I S T E M A     T I P O S     A R T I G O S
    /* @description Funcao change da combo tipo de artigo */
    self.SistemaClassificacoesTiposArtigosChange = function (sender) {
        var elemTiposOlhos = KendoRetornaElemento($('#' + sistemaTiposOlhos));
        elemTiposOlhos.dataSource.read();

        if (sender.value()) {
            //enable
            KendoDesativaElemento(sistemaTiposOlhos, false);
        }
        else {
            //disable
            elemTiposOlhos.value(null);
            KendoDesativaElemento(sistemaTiposOlhos, true)
        }
    };

    //------------------------------------ S I S T E M A     T I P O S     O L H O S
    /* @description Funcao envia params da combo tipos de olhos */
    self.SistemaTiposOlhosEnviaParams = function (objFiltro) {
        //idSistemaClassificacoesTiposArtigos
        var _idSistemaClassificacoesTiposArtigos = $('#' + sistemaClassificacoesTiposArtigos).val();
        GrelhaUtilsPreencheObjetoFiltroValor(objFiltro, true, sistemaClassificacoesTiposArtigos, null, _idSistemaClassificacoesTiposArtigos);
        //return filtro
        return objFiltro;
    };
    
    return parent;

}($tipos_fases || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//grid
var TiposFasesGridEdit = $tipos_fases.ajax.GridEdit;
//tipos artigos
var TiposFasesSistemaClassificacoesTiposArtigosChange = $tipos_fases.ajax.SistemaClassificacoesTiposArtigosChange;
//tipos olhos
var TiposFasesSistemaTiposOlhosEnviaParams = $tipos_fases.ajax.SistemaTiposOlhosEnviaParams;