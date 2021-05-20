'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $examesladodireito = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes botoes de acoes
    var constBtnAnexos = 'btnAnexos', constNovaConsulta = 'btnNovaConsultaLadoDireito';
     
    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //click to open anexos
        $('#' + constBtnAnexos).on('click', function (e) {
            self.AbreAnexos();
        });
        //click to open nova consulta
        $('#' + constNovaConsulta).on('click', function (e) {
            ExamesIndexAbreTabMarcacoes(e);
        });
    };

    //------------------------------------ B O T O E S     D E     A C O E S
    /* @description funcao que abre a modal dos anexos*/
    self.AbreAnexos = function () {
        //props JanelaDesenha
        var _url = rootDir + '/Exames/ExamesAnexos';
        var _janelaID = base.constantes.janelasPopupIDs.Menu;
        //JanelaDesenha
        JanelaDesenha(_janelaID, self.RetornaObjData(), _url);
    };

    //------------------------------------ F U N C O E S     A U X L I A R E S
    /*@description funcao retorna propiedades para a modal */
    self.RetornaObjData = function () {
        var _objData = {};
        _objData['IDEntidade'] = $('#ID').val();
        _objData.Modo = "0";

        return _objData;
    };

    //------------------------------------ F U N C O E S     E S P E C I F I C A S
    /* @description funcao que retorna o padding especifico de 243 px */
    self.RetornaPadRightEsp = function () {
        return 318;
    };

    return parent;

}($examesladodireito || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var ExamesLadoDireitoInit = $examesladodireito.ajax.Init;
//actions
var ExamesLadoDireitoRetornaHistoricoExame = $examesladodireito.ajax.RetornaHistoricoExame;
var ExamesLadoDireitoRetornaLadoDireitoCompleto = $examesladodireito.ajax.RetornaLadoDireitoCompleto;

//especificas dentro do generico
var FormsAreaSomPadRightEsp = $examesladodireito.ajax.RetornaPadRightEsp;

$(document).ready(function (e) {
    ExamesLadoDireitoInit();
});