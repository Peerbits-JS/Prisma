'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $descontosiva = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //constantes alertas
    var constsAlertas = constsBase.tpalerta;

    //constantes form
    var constIDFormulario = 'F3MFormIVADescontos', constBtnSave = 'btnSave', constBtnRefresh = 'btnRefresh';

    //constantes handsontable
    var IDHDSN = 'hdsnIVA', constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT;

    //colunas handsontable
    var hdsnColumns = {
        ID: 'ID', Codigo: 'Codigo', Descricao: 'Descricao', Taxa: 'Taxa', Desconto: 'Desconto', ValorMinimo: 'ValorMinimo', PCM: 'PCM'
    }

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind init events
        self.BinInitEvents();
    };

    /* @description funcao do doc ready para o bind dos eventos */
    self.BinInitEvents = function () {
        //bind btn save click event
        $('#' + constBtnSave).on('click', function (e) {
            self.ValidaGravaObIVADescontos()
        });

        //bind btn refresh click event
        $('#' + constBtnRefresh).on('click', function (e) {
            self.ValidaRefresh();
        });
    };

    //------------------------------------ H A N D S O N T A B L E
    /* @description funcao que retorna as colunas da HT */
    self.RetornaColunasHT = function () {
        return [
            {
                ID: hdsnColumns.Codigo, Label: resources['Codigo'], TipoEditor: constTipoCompoHT.F3MTexto, readOnly: true, width: 125
            },
            {
                ID: hdsnColumns.Descricao, Label: resources['Descricao'], TipoEditor: constTipoCompoHT.F3MTexto, readOnly: true, width: 250
            },
            //{
            //    ID: 'Taxa', Label: resources['Taxa'], TipoEditor: constTipoCompoHT.F3MNumero, CasasDecimais: 2, readOnly: true, width: 125
            //},
            {
                ID: hdsnColumns.Desconto, Label: resources['PesoDescPerc'], TipoEditor: constTipoCompoHT.F3MNumero, CasasDecimais: 2, width: 180
            },
            {
                ID: hdsnColumns.ValorMinimo, Label: resources['ValorMinPercPV'], TipoEditor: constTipoCompoHT.F3MNumero, CasasDecimais: 2, width: 180
            },
            {
                ID: hdsnColumns.PCM, Label: resources['ValorMinCustMed'], TipoEditor: constTipoCompoHT.F3MCheckBox, width: 180
            },
        ]
    };

    /* @description funcao que constroi a HT */
    self.ConstroiHT = function (inData) {
        //set hdsn height
        var _height = inData.length * 40;

        //build ht
        var hdsn = HandsonTableDesenhaNovo(IDHDSN, inData, _height, self.RetornaColunasHT(), false, null, null, null, null, null);

        //
        hdsn.updateSettings({
            afterChange: self.AfterChangeHT,
            fillHandle: false,
            columnSorting: false,
            rowHeaders: true,
        });

        //remove temp ds from dom
        $('#tempHdsnDS').remove();
    };

    /* @description funcao after change da HT (validacoes) */
    self.AfterChangeHT = function (changes, source) {
        if (source === constSourceHT.LoadData || !UtilsVerificaObjetoNotNullUndefined(changes)) {
            return;
        }
        //set props
        var _hdsn = this;
        var _row = changes[0][0];
        var _prop = changes[0][1];
        var _oldValue = changes[0][2];
        var _newValue = changes[0][3];

        if (_oldValue != _newValue) {
            switch (_prop) {
                case hdsnColumns.Desconto:
                case hdsnColumns.ValorMinimo:
                    //valida if value is not empty
                    if (!(UtilsVerificaObjetoNotNullUndefinedVazio(_newValue))) {
                        _hdsn.getSourceDataAtRow(_row, )[_prop] = 0;
                    }

                    //valida > 100
                    if (_newValue > 100) {
                        _hdsn.getSourceDataAtRow(_row, )[_prop] = 100;
                    }
                    //valida < menor que 0
                    if (_newValue < 0) {
                        _hdsn.getSourceDataAtRow(_row, )[_prop] = 0;
                    }

                    //se esta preenchida e coluna ValorMinimo e valor != 0 entao despisca a coluna PCM
                    if (_prop == hdsnColumns.ValorMinimo && _newValue != 0) {
                        _hdsn.getSourceDataAtRow(_row, )[hdsnColumns.PCM] = false;
                    }

                    //enable save button
                    self.AtivaDesativaBotoes(true);

                    break;

                case hdsnColumns.PCM:
                    //se esta piscada a coluna PCM entao zera a coluna ValorMinimo
                    if (_newValue === true) {
                        _hdsn.getSourceDataAtRow(_row, )[hdsnColumns.ValorMinimo] = 0;
                    }

                    //enable save button
                    self.AtivaDesativaBotoes(true);

                    break;
            }
            //render HT
            _hdsn.render();
        }
    };

    /* @description funcao que faz o request para trazer os dados para a HT */
    self.RefreshHT = function () {
        //get url
        var _url = rootDir + '/Utilitarios/IVADescontos/ListaLinhas';
        //start loading
        KendoLoading($('#' + constIDFormulario), true);
        //sava all
        UtilsChamadaAjax(_url, true, {}, self.SuccessCallbackRefreshHT, function (e) { throw e; }, 1, true);
    };

    /* @description  funcao que faz o load data da HT */
    self.SuccessCallbackRefreshHT = function (inResult) {
        //stop loading
        KendoLoading($('#' + constIDFormulario), false);

        //check if result has errors
        if (!UtilsVerificaObjetoNotNullUndefined(inResult.Errors)) {
            //set new ds to grid
            self.RetornaInstaceHT().loadData(inResult);
        }
    };

    /* @description funcao que retorna a intancia da HT */
    self.RetornaInstaceHT = function () {
        return window.HotRegisterer.bucket[IDHDSN];
    };

    //------------------------------------ A C O E S
    /* @description funcao que grava */
    self.GravaObIVADescontos = function () {
        //get url
        var _url = rootDir + '/Utilitarios/IVADescontos/GravaObIVADescontos';
        //get model 
        var _model = self.RetornaInstaceHT().getSourceData();
        //start loading
        KendoLoading($('#' + constIDFormulario), true);
        //sava all
        UtilsChamadaAjax(_url, true, JSON.stringify({ modelo: _model }), self.SuccessCallbackGravaObIVADescontos, function (e) { throw e; }, 1, true);
    };

    /* @description funcao depois de gravar */
    self.SuccessCallbackGravaObIVADescontos = function (inResult) {
        //stop loading
        KendoLoading($('#' + constIDFormulario), false);
        //check if result has errors
        if (!UtilsVerificaObjetoNotNullUndefined(inResult.Errors)) {
            //notifica success
            UtilsNotifica(base.constantes.tpalerta.s, "Atualizado com sucesso.");
            //disable save button
            self.AtivaDesativaBotoes(false);
            //set new ds to grid
            self.RetornaInstaceHT().loadData(inResult);
        }
    };

    //------------------------------------ V A L I D A C O E S
    /* @description funcao que valida se pode gravar ou existem dados em erro (validacoes) */
    self.ValidaGravaObIVADescontos = function () {
        //get hdsn
        var _hdsn = self.RetornaInstaceHT();
        //get hdsn ds
        var _hdsnDS = _hdsn.getSourceData();
        //validate cells
        _hdsn.validateCells(function (valid) {
            if (valid) {
                //cells is valid
                var _total_descontos = 0;
                $.each(_hdsnDS, function (i, v) { _total_descontos += v.Desconto; });

                if (_total_descontos == 100 || _total_descontos == 0) {
                    //all is valid? oui! let's save it!
                    self.GravaObIVADescontos();
                }
                else {
                    UtilsNotifica(constsAlertas.error, "A soma dos pesos de desconto tem que ser igual a 100%.");
                }
            }
            else {
                //errors on cells
                UtilsNotifica(constsAlertas.error, resources['existem_valores_invalidos']);  //Existem campos em falta e/ou com informação inválida.
            }
        })
    };

    /* @description funcao  que verifica se existem alteracoes na HT para perguntar se deseja perder as alteracoes */
    self.ValidaRefresh = function () {
        if ($('#' + constBtnSave).hasClass('disabled')) {
            //disable save button
            self.AtivaDesativaBotoes(false);
            //refresh grid DS
            self.RefreshHT();
        }
        else {
            UtilsConfirma(constsAlertas.question, resources['confirmacao_sair'], function () {
                //disable save button
                self.AtivaDesativaBotoes(false);
                //refresh grid DS
                self.RefreshHT();
            }, function () { });
        }
    };

    //------------------------------------ F O R M U L A R I O
    /* @description funcao que ativa ou desativa o botao  de gravar*/
    self.AtivaDesativaBotoes = function (inAtiva) {
        inAtiva ? $('#' + constBtnSave).removeClass('disabled') : $('#' + constBtnSave).addClass('disabled');
    };

    return parent;

}($descontosiva || {}, jQuery));

//this
var DescontosIVAInit = $descontosiva.ajax.Init;
//hdsn
var DescontosIVAConstroiHT = $descontosiva.ajax.ConstroiHT;

//doc ready
$(document).ready(function (e) {
    //init fn
    DescontosIVAInit();
});

