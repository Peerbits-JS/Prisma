"use strict";

var $docsstockscontagemcab = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;
    //constantes floating divs
    var elemFloatingDocumentoButton = 'elemFloatingDocumentoBt', elemFloatingDocumento = 'elemFloatingDocumento';
    //tipos doc
    var campoTipoDoc = 'IDTipoDocumento', campoTipoDocSeries = 'IDTiposDocumentoSeries', campoNumDoc = 'NumeroDocumento', flgDocSeriesFirstDataBound = 'DocSeriesFirstDataBound';
    var elemFloatingDoc = 'elemFloatingDocumento';
    //hidens tipo doc
    var modulo = 'IDModulo', codModulo = 'CodigoModulo', SistemaTipoDocumento = 'IDSistemaTipoDocumento'

    //arm /// localizacao
    var campoArmazem = 'IDArmazem', campoLocalizacao = 'IDLocalizacao';

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //mostra e posiciona as floating divs
        self.PosicionaFloatingDivs();
    };

    /* @description funcao que mostra e posiciona as floating divs */
    self.PosicionaFloatingDivs = function () {
        //evt click floating tipos doc
        $('#' + elemFloatingDocumentoButton).on('click', function (e) {
            ElemFloatingCliqueElemRef(elemFloatingDocumento, $('#' + elemFloatingDocumento), 0, 0, self.AtualizaLabelDocumento, null);
        });
    };

    //------------------------------------ T I P O S     D O C U M E N T O
    /* @description funcao change do lookup tipos doc */
    self.TiposDocChange = function (inCombo) {
        //get data item
        var _comboDS = inCombo.dataItem();
        //reset series
        self.KendoSetValue(campoTipoDocSeries, null);
        //verifica se existe algum selecionado
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_comboDS) && UtilsVerificaObjetoNotNullUndefinedVazio(inCombo.value())) {
            //ativa
            KendoDesativaElemento(campoTipoDocSeries, false);
            //coloca obrigatorio
            KendoColocaElementoObrigatorio($('#' + campoTipoDocSeries), true);
            //read combo
            KendoRetornaElemento($('#' + campoTipoDocSeries)).dataSource.read();
        }
        else {
            //desativa 
            KendoDesativaElemento(campoTipoDocSeries, true);
        }
    };

    /* @description funcao envia params do lookup dos tipos doc */
    self.TiposDocEnviaParams = function (inObjetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'IDModulo', '', $('#' + modulo).val());
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'CodigoModulo', '', $('#' + codModulo).val());
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'IDSistemaTipoDocumento', '', $('#' + SistemaTipoDocumento).val());
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'CodigoSistemaTiposDocumento', '', 'StkContagemStock');
        
        return inObjetoFiltro;
    };

    //------------------------------------ T I P O S     D O C U M E N T O     S E R I E S
    /* @description funcao envia params do lookup dos tipos doc series*/
    self.TiposDocSeriesEnviaParams = function (inObjetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'ID', '', $('#' + campoTipoDoc).val());

        var elemAux1 = $('#DataOrdemFabrico');
        var elem1 = (elemAux1.length) ? elemAux1 : window.parent.$('#DataOrdemFabrico');
        //
        GrelhaUtilsPreencheObjetoFiltro(inObjetoFiltro, elem1, true, 'DataOrdemFabrico');

        //reset filtro texto
        inObjetoFiltro.FiltroTexto = '';

        return inObjetoFiltro;
    };

    /* @description funcao databound do lookup dos tipos doc series*/
    self.TipoDocSeriesDataBound = function (e) {
        var lngIDTipoDoc = $('#' + campoTipoDoc).val();
        var _idTipoDocSeries = $('#' + campoTipoDocSeries).val();
        var _flgDocSeriesFirstDataBound = $('#' + flgDocSeriesFirstDataBound).val();

        //quando nao tem tipo doc definido por defeito a combo ficava desativa e ao ativar nao ficava obrigatoria
        KendoColocaElementoObrigatorio(e.sender.element, true);

        if (_flgDocSeriesFirstDataBound != 'True') {
            if (UtilsVerificaObjetoNotNullUndefinedVazio(lngIDTipoDoc)) {
                KendoDesativaElemento(campoTipoDocSeries, false);

                var DDLTipoSer = e.sender;
                var serieDS = DDLTipoSer.dataSource.data();

                if (serieDS.length > 0) {
                    for (var i = 0; i < serieDS.length; i++) {
                        var sugeridaPorDefeito = serieDS[i]['SugeridaPorDefeito'];

                        if (sugeridaPorDefeito === true) {
                            self.KendoSetValue(campoTipoDocSeries, serieDS[i]['ID']);
                        }
                    }
                }
            }
            else {
                KendoDesativaElemento(campoTipoDocSeries, true);
            }
        }

        //set flag DocSeriesFirstDataBound to false
        $('#' + flgDocSeriesFirstDataBound).val(false);
    };

    //------------------------------------ N U M E R O      D O C U M E N T O
    /* @description funcao que atualiza o numero documento */
    self.AtualizaLabelDocumento = function () {
        var _tipoDocTxt = '', _serieDocTxt = '', _numeDocTxt = '';



        //tipo doc
        var _tipoDocElem = KendoRetornaElemento($('#' + campoTipoDoc));
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_tipoDocElem)) {
            _tipoDocTxt = UtilsVerificaObjetoNotNullUndefinedVazio(_tipoDocElem.value()) ? _tipoDocElem.text() : ' ';
            var descricao = _tipoDocTxt !== ' ' ? _tipoDocTxt.slice(_tipoDocTxt.indexOf('-') + 2) : resources.Documento;
            $('#' + elemFloatingDoc + ' > label').text(descricao);

            _tipoDocTxt = _tipoDocTxt.slice(0, _tipoDocTxt.indexOf(' '));
        }
        //tipo doc series
        var _seriesDocElem = KendoRetornaElemento($('#' + campoTipoDocSeries));
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_seriesDocElem)) {
            _serieDocTxt = (_seriesDocElem.value() != '') ? _seriesDocElem.text() : ' ';
        }
        //numero doc
        var _numDocElem = KendoRetornaElemento($('#' + campoNumDoc));
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_numDocElem)) {
            _numeDocTxt = (_numDocElem.value() != '' && _numDocElem.value() >= 0 && _numDocElem.value() != null) ? _numDocElem.value() : ' ';
            if (_numeDocTxt != _numDocElem.element.val()) {
                _numeDocTxt = _numDocElem.element.val();
            }
        }

        if (_tipoDocTxt != ' ' && _serieDocTxt != ' ' && _serieDocTxt != resources.selecione_um_item) {
            if (_numeDocTxt == 0) {
                return _tipoDocTxt + ' ' + _serieDocTxt + '/';
            }
            else {
                return _tipoDocTxt + ' ' + _serieDocTxt + '/' + _numeDocTxt;
            }
        }
        else {
            return ' ';
        }
    };

    //------------------------------------ D A T A     D O C U M E N T O
    /* @description funcao change da data documento */
    self.DataDocChange = function (inDate) {
        //get date
        var _date = inDate.sender.element.val();
        ////verifica se a data e valida
        if (!ValidaData(_date)) {
            inDate.sender.value(new Date);
        }
        //get localizacao
        var _idLocalizacao = KendoRetornaElemento($('#' + campoLocalizacao)).value();
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_idLocalizacao)) {
            //atualiza qtd em stock /// diferenca
            $docsstockscontagemgrelha.ajax.AtualizaQtdStock();
        }
    };

    //------------------------------------ A R M A Z E M     / / /     L O C A L I Z A C A O
    /* @description funcao change do lookup armazem */
    self.ArmazemChange = function (inCombo) {
        //get data item
        var _comboDS = inCombo.dataItem();
        //reset localizacao
        self.KendoSetValue(campoLocalizacao, null);
        //verifica se existe algum selecionado
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_comboDS) && UtilsVerificaObjetoNotNullUndefinedVazio(inCombo.value())) {
            //ativa
            KendoDesativaElemento(campoLocalizacao, false);
            //coloca obrigatorio
            KendoColocaElementoObrigatorio($('#' + campoLocalizacao), true);
            //read combo
            KendoRetornaElemento($('#' + campoLocalizacao)).dataSource.read();

        }
        else {
            //desativa 
            KendoDesativaElemento(campoLocalizacao, true);
        }

        $('.clsF3MSemArmazemLocalizacao').removeClass('hidden');
        $('.clsF3MHadnsontable').addClass('hidden');

        $('#btnAplicarFiltros').attr('disabled', 'disabled');

        //reset hdsn
        DocsStocksContagemGrelhaLoadDataHT([]);
    };

    /* @description funcao change do lookup localizacao */
    self.LocalizacaoChange = function (inCombo) {
        //get data item
        var _comboDS = inCombo.dataItem();
        //verifica se existe algum selecionado
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_comboDS) && UtilsVerificaObjetoNotNullUndefinedVazio(inCombo.value())) {
            $('.clsF3MSemArmazemLocalizacao').addClass('hidden');
            $('.clsF3MHadnsontable').removeClass('hidden');

            $('#btnAplicarFiltros').removeAttr('disabled');
        }
        else {
            $('.clsF3MSemArmazemLocalizacao').removeClass('hidden');
            $('.clsF3MHadnsontable').addClass('hidden');

            $('#btnAplicarFiltros').attr('disabled', 'disabled');
        }

        //reset hdsn
        DocsStocksContagemGrelhaLoadDataHT([]);
    };

    /* @description funcao envia params do lookup localizacao */
    self.LocalizacaoEnviaParams = function (inObjetoFiltro) {
        var elemAux = $('#' + campoArmazem);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoArmazem);

        GrelhaUtilsPreencheObjetoFiltro(inObjetoFiltro, elem, true, campoArmazem);

        return inObjetoFiltro;
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /*@description Funcao que atribui o valor a um 'f' + parseInt(3 + 1) */
    self.KendoSetValue = function (inComboID, inValue) {
        var combo = KendoRetornaElemento($('#' + inComboID));
        combo.value(inValue);
        $($(combo.element).parent().find('.clsF3MInput:last')[0]).attr('value', inValue);
        ComboBoxAtivaDesativaDrillDown([$(combo.element).attr('id')]);
    };

    return parent;

}($docsstockscontagemcab || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemCabInit = $docsstockscontagemcab.ajax.Init;
//tipos doc
var DocStocksContagemCabTiposDocChange = $docsstockscontagemcab.ajax.TiposDocChange;
var DocStocksContagemCabTiposDocEnviaParams = $docsstockscontagemcab.ajax.TiposDocEnviaParams;
//tipos doc series
var DocStocksContagemCabTiposDocSeriesEnviaParams = $docsstockscontagemcab.ajax.TiposDocSeriesEnviaParams;
var DocStocksContagemCabTipoDocSeriesDataBound = $docsstockscontagemcab.ajax.TipoDocSeriesDataBound;
//data doc
var DocStocksContagemCabDataDocChange = $docsstockscontagemcab.ajax.DataDocChange;
//armazem / localizacao
var DocStocksContagemCabArmazemChange = $docsstockscontagemcab.ajax.ArmazemChange;
var DocStocksContagemCabLocalizacaoChange = $docsstockscontagemcab.ajax.LocalizacaoChange;
var DocStocksContagemCabLocalizacaoEnviaParams = $docsstockscontagemcab.ajax.LocalizacaoEnviaParams;

$(document).ready(function (e) {
    //init
    DocsStocksContagemCabInit();
});