"use strict";

var $docsstockscontagem = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //constantes form
    var constAcaoForm = 'EmExecucao', constsAcoes = constsBase.EstadoFormEAcessos;

    //attr tips de contagem
    var tiposcontagem = {
        carregar: 'carregar',
        reiniciar: 'reiniciar'
    };

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind evts
        self.BindInitEvents();
        //trata observacoes - badge
        UtilsObservacoesTrataEspecifico("tabObservacoes", 'Observacoes');
    };

    /* @description funcao bind dos eventos da janela */
    self.BindInitEvents = function () {
        //after shown tabs
        $(".clsF3MTabs a[role=tab]").on("shown.bs.tab", function (e) {
            self.ShownTabs(e);
        });
    };

    //------------------------------------ T A B S
    /* @description funcao after shown tabs */
    self.ShownTabs = function (e) {
        var _tab = e.currentTarget.hash.replace("#", "");

        switch (_tab) {
            case 'tabArtigos':
                //get hdsn
                var _hdsn = DocsStocksContagemGrelhaRetornaHTInstance();

                if (_hdsn) {
                    DocsStocksContagemGrelhaRetornaHTInstance().render();
                }
                break;
        }
    };

    //------------------------------------ E S T A D O S
    /* @description funcao change do estado */
    self.ChangeEstado = function (inModeloEstado) {
        //set flag to true
        $('#AlterouEstado').val(true);

        if ($('#' + constAcaoForm).val() === constsAcoes.Alterar && inModeloEstado[0].CodigoTipoEstado === 'RSC') {
            //self.BloqueiaOuDesbloqueiaTudo(false);
            //$('#btnAplicarFiltros').removeAttr('disabled');
            //
            //var _hdsn = DocsStocksContagemGrelhaRetornaHTInstance();
            //
            //_hdsn.updateSettings({
            //    minSpareRows: 1
            //});
            //
            //DocsStocksContagemGrelhaConfiguraColunasHT(_hdsn);
        }
    };

    //------------------------------------ C R U D
    /* @description funcao que  retorna o modelo esp para gravar*/
    self.RetornaModeloEspecifico = function (inModel) {
        //set filtro
        inModel['Filtro'] = {
            NaoMovimentados: inModel['NaoMovimentados'],
            Inativos: inModel['Inativos'],
            IDTipoArtigo: inModel['IDTipoArtigo'],
            IDMarca: inModel['IDMarca'],
            IDArmazem: inModel['IDArmazem'],
            IDLocalizacao: inModel['IDLocalizacao'],
            DataDocumento: inModel['DataDocumento']
        };

        //set linhas
        inModel['Artigos'] = $docsstockscontagemgrelha.ajax.RetornaHTInstance().getSettings().F3MDataSource.data;
        
        for (var _i = 0; _i < inModel['Artigos'].length; _i++ ) {
            var _linha = inModel['Artigos'][_i];
            //set ordem
            _linha['Ordem'] = _i;
            //set main id
            _linha['IDDocumentoStockContagem'] = UtilsVerificaObjetoNotNullUndefinedVazio(_linha['IDDocumentoStockContagem']) ? _linha['IDDocumentoStockContagem'] : 0;
            _linha['ID'] = UtilsVerificaObjetoNotNullUndefinedVazio(_linha['ID']) ? _linha['ID'] : 0;
            _linha.Alterada = true;
            _linha.Ativo = true;
            _linha.Sistema = false;
            _linha.AcaoFormulario = 0;
        }
        //remove props
        delete inModel['NaoMovimentados'];
        delete inModel['Inativos'];
        delete inModel['IDTipoArtigo'];
        delete inModel['IDMarca'];

        //return model
        return inModel;
    };

    /* @description funcao especifica que valida antes de gravar */
    self.ValidaEspecifica = function (inGrid, inModelo, inUrl) {
        //get grid options
        var options = inGrid.dataSource.transport.options;
        //set erros 
        var erros = null;
        //valida se nao esta a remover
        if (inUrl !== options.destroy.url) {
            //get grid id
            var gridID = inGrid.element.attr('id');
            //get and set erros gen
            erros = GrelhaUtilsValida($('#' + gridID + 'Form'));

            if (erros === null) {
                //verifica se o doc tem linhas
                var _linhasValidas = $.grep(inModelo['Artigos'], (x) => UtilsVerificaObjetoNotNullUndefinedVazio(x['IDArtigo'])).length;

                if (!_linhasValidas) {
                    //erro quando o doc nao tem linhas
                    erros = [];
                    erros.push("Este documento de contagem não contém linhas.");
                }
            }
        }
        //return erros ge || esp
        return erros;
    };

    /* @description funcao especifica que valida antes de gravar */
    self.ValidaGravaEspecifico = function (evt, inArrTabelas, inGrelha, inFormulario, inURL, inModelo, inElemBtID) {
        //get linhas invalidas
        var _linhasInvalidas = $.grep(inModelo['Artigos'], (x) => !UtilsVerificaObjetoNotNullUndefinedVazio(x['IDArtigo'])).length;
        //verifica se existem linhas invalidas
        if (_linhasInvalidas) {
            //pergunta
            UtilsConfirma(base.constantes.tpalerta.question, "Existem artigos/lotes inválidos que não serão incluídos na contagem de stock. Deseja continuar?", function () {
                //grava gen
                GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso);
            }, function () { return false; });
        }
        else {
            //grava gen
            GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso);
        }
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /* @description funcao que  */
    self.BloqueiaOuDesbloqueiaTudo = function (boolBloqueia) {
        //kendo 
        var _elemsKendoDesbloquear = ['IDArmazem', 'IDLocalizacao', 'IDTipoArtigo', 'IDMarca'];

        for (var _i = 0; _i < _elemsKendoDesbloquear.length; _i++) {
            var _itemi = _elemsKendoDesbloquear[_i];
            //desbloqueia
            KendoDesativaElemento(_itemi, boolBloqueia);

            if (!(_itemi === 'IDTipoArtigo' || _itemi === 'IDMarca')) {
                //coloca obrigatorio
                KendoColocaElementoObrigatorio($('#' + _itemi), !boolBloqueia);
            }
        }

        //checkboxs
        var _elemsCheckBoxDesbloquear = ['NaoMovimentados', 'Inativos'];
        for (var _j = 0; _j < _elemsCheckBoxDesbloquear.length; _j++) {
            var _itemj = _elemsCheckBoxDesbloquear[_j];

            if (boolBloqueia) {
                //desbloqueia
                $('#' + _itemj).prop('disabled', true).parent().parent().addClass('disabled');
            }
            else {
                //desbloqueia
                $('#' + _itemj).prop('disabled', false).parent().parent().removeClass('disabled');
            }
        }

        //buttons
        var _elemsButtons = ['btnAplicarFiltros', 'btnContar', 'importar-artigos-contagem', 'btnAtualizar'];
        for (var _k = 0; _k < _elemsButtons.length; _k++) {
            var _itemK = _elemsButtons[_k];

            //debolqueia
            $('#' + _itemK).removeAttr('disabled');
        }

        //trata botao aplicar filtros
        if (boolBloqueia) {
            //set new text and attr
            $('#btnAplicarFiltros').text('Reiniciar contagem').attr('data-f3mtype', tiposcontagem.reiniciar);
        }
        else {
            //set new text and attr
            $('#btnAplicarFiltros').text('Carregar').attr('data-f3mtype', tiposcontagem.carregar);
        }
    };

    return parent;

}($docsstockscontagem || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemInit = $docsstockscontagem.ajax.Init;
//form
var DocsStocksContagemBloqueiaOuDesbloqueiaTudo = $docsstockscontagem.ajax.BloqueiaOuDesbloqueiaTudo;
//actions
var AcoesRetornaModeloEspecifico = $docsstockscontagem.ajax.RetornaModeloEspecifico;
var DocumentosStockContagemValidaEspecifica = $docsstockscontagem.ajax.ValidaEspecifica;
var ValidaGravaEspecifico = $docsstockscontagem.ajax.ValidaGravaEspecifico;
//estados
var EstadosLadoDireitoChangeEstado = $docsstockscontagem.ajax.ChangeEstado;

$(document).ready(function (e) {
    //remove label adicionar registo
    $('#spanSemRegistosForm').remove();
    //init
    DocsStocksContagemInit();
}).ajaxSend(function (inEvent, jqxhr, inSettings) {
    //requests
    //  cab
    var _requestsBarLoding = ['Armazens/ListaCombo', 'ArmazensLocalizacoes/ListaComboCodigo'];
    //  lado esq
    _requestsBarLoding.push('TiposArtigos/ListaCombo', 'Marcas/ListaCombo');
    //  lado dir
    _requestsBarLoding.push('Estados/Lista');
    //  grid
    _requestsBarLoding.push('DocumentosStockContagem/ValidaArtigo', 'Artigos/ListaComboCodigo', 'ArtigosLotes/ListaCombo');
    //  gets
    _requestsBarLoding.push('DocumentosStockContagem/ObtemArtigos');

    KendoBarLoading(null, inSettings, _requestsBarLoding);
}).ajaxStop(function () {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
});