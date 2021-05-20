"use strict";

var $docsstockscontagembotoes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //botoes lado direito
    var btnAnexos = 'btnAnexos', btnEfetivar = 'btnEfetivar';

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind anexos
        $('#' + btnAnexos).click((e) => self.AbreAnexos(e));
        //bind efetivar
        $('#' + btnEfetivar).click((e) => self.EfetivarByButton(e));
    };

    //------------------------------------ B O T O E S     A C O E S
    /* @description funcao que abre os anexos */
    self.AbreAnexos = function (e) {
        var _janelaMenuLateral = constsBase.janelasPopupIDs.Menu;
        var _url = rootDir + "/Documentos/DocumentosStockContagemAnexos";
        JanelaDesenha(_janelaMenuLateral, self.RetornaObjData(), _url);
    };

    /* @description funcao que guarda a contagem no estado efetivo */
    self.EfetivarByButton = function (e) {
        //set flag to true
        $('#GravouViaEfetivar').val(true);
        //ativa dirty
        GrelhaFormAtivaDesativaBotoesAcoes("F3MGrelhaFormDocumentosStockContagem", true);
        //save
        $('.clsBtSaveFecha2').trigger('click');
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /*@description funcao retorna propiedades para a modal */
    self.RetornaObjData = function () {
        var objData = {};
        objData['IDEntidade'] = $("#ID").val();
        objData.Modo = "0";

        return objData;
    };

    return parent;

}($docsstockscontagembotoes || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemBotoesInit = $docsstockscontagembotoes.ajax.Init;

$(document).ready(function (e) {
    DocsStocksContagemBotoesInit();
});