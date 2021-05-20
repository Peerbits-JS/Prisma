"use strict";

var $clientes_esp = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;
    
    //constantes campos genericos
    var constCamposGen = constsBase.camposGenericos;
    var campoID = constCamposGen.ID;

    //constantes estados
    var constEstados = constsBase.EstadoFormEAcessos;

    //constantes campos funcionalidade
    var constNovoDocVenda = 'NovoDocVenda', constNovoServico = 'NovoServico';

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description Funcao document ready */
    self.Init = function () {
        //bind click para gerar doc venda
        $('#' + constNovoDocVenda).on('click', function (e) {
            self.GeraDocVenda(e);
        });

        //bind click para gerar servico
        $('#' + constNovoServico).on('click', function (e) {
            self.GeraServico(e);
        });
    };

    //------------------------------------ B O T O E S     L A D O     D I R E I T O
    /* @description Funcao que gera o documento de venda a partir do cliente*/
    self.GeraDocVenda = function (e) {
        //props UtilsAbreTab
        var _id = $('#' + campoID).val();
        var _url = 'Documentos/DocumentosVendas';
        var _tabnome = resources['DocumentosVendas'], _tabicon = 'f3icon-doc-finance';
        //action result AdicionaEsp
        if (UtilsVerificaObjetoNotNullUndefined($(e).attr('data-arg-extra'))) {
            UtilsAbreTab(_url, _tabnome, _tabicon, '1', '', 'IDEntidade:' + $('#ID').val() + ',DescricaoEntidade:' + $('#Nome').val());
        }
        else {
            sessionStorage.setItem('AdicionaEsp', rootDir + _url + '/AdicionaEsp?IDEntidade=' + _id);
            UtilsAbreTab(_url, _tabnome, _tabicon, null, constEstados.Adicionar, null);
        }
    };

    /* @description Funcao que gera o servico a partir do cliente*/
    self.GeraServico = function (e) {
        //props UtilsAbreTab
        var _id = $('#' + campoID).val();
        var _url = 'Documentos/DocumentosVendasServicos';
        var _tabnome = resources['Servicos'], _tabicon = 'f3icon-glasses';
        //action result AdicionaEsp
        if (UtilsVerificaObjetoNotNullUndefined($(e).attr('data-arg-extra'))) {
            UtilsAbreTab(_url, _tabnome, _tabicon, '1', '', 'IDEntidade:' + $('#ID').val() + ',DescricaoEntidade:' + $('#Nome').val());
        }
        else {
            sessionStorage.setItem('AdicionaEsp', rootDir + _url + '/AdicionaEsp?IDEntidade=' + _id);
            UtilsAbreTab(_url, _tabnome, _tabicon, null, constEstados.Adicionar, null);
        }
    };

    //------------------------------------ B O T O E S     L A D O     D I R E I T O
    /* @description Funcao que abre o pop-up com os avisos do cliente...*/
    self.NotificaAviso = function (inAviso) {
        UtilsNotifica(base.constantes.tpalerta['i'], inAviso);
    };

    self.OpenAppointments = function () {
        var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
        var objData = {};
        var acao = '../Clientes/Clientes/Appointments';
        JanelaDesenha(janelaMenuLateral, objData, acao, acao);
    }

    return parent;

}($clientes_esp || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var ClientesEspInit = $clientes_esp.ajax.Init;
var ClientesEspGeraDocVenda = $clientes_esp.ajax.GeraDocVenda;
var ClientesEspGeraServico = $clientes_esp.ajax.GeraServico;
var ClientesEspNotificaAviso = $clientes_esp.ajax.NotificaAviso;

var ClientesEspOpenAppointments = $clientes_esp.ajax.OpenAppointments;

$(document).ready(function (e) {
    ClientesEspInit();
});


