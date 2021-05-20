"use strict";

var $recebimentos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constTipoCompoHT = base.constantes.ComponentesHT;
    var constJSONDates = base.constantes.ConvertJSONDate;
    var constTipoDeCampo = base.constantes.TipoDeCampo;

    var clsPagamentos = 'Pagamentos';
    var IDHDSN = 'hdsnDocumentos';

    var SimboloMoedaRefCliente;
    var CasasDecimaisTotais;
    var IDMoeda;
    var Recibo;
    var PagamentosVendasLinhas;

    var Pagamento;

    var hdsnColumns = {
        Documento: 'Documento',
        NomeFiscal: 'NomeFiscal',
        DataDocumento: 'DataDocumento',
        DataVencimento: 'DataVencimento',
        TotalMoedaDocumento: 'TotalMoedaDocumento',
        ValorPendente: 'ValorPendente',
        ValorPago: 'ValorPago',
        Natureza: 'DescricaoSistemaNaturezas'
    };
    

    /*@description Init */
    self.Init = function () {
        SimboloMoedaRefCliente = window.parent.$('#SimboloMoedaRefCliente').val();
        CasasDecimaisTotais = window.parent.$('#CasasDecimaisTotais').val();
        IDMoeda = window.parent.$('#IDMoeda').val();

        self.UnbindAndBindEvents();

        $($('.Pagamentos')[$('.Pagamentos').length - 1]).trigger('click');

        $('#btnRefresh').on('click', function (e) {
            self.Refresh();

            return false;
        });

        $('#btnPrint').on('click', function (e) {
            var Opcao = 'DocumentosVendas';
            var Controller = 'DocumentosVendas';
            var id = PagamentosVendasLinhas[0].IDDocumentoVenda;

            if (UtilsVerificaObjetoNotNullUndefined(Recibo)) {
                Opcao = 'Recibos';
                Controller = 'Recebimentos'
                id = Recibo.ID;
            }
            var modelo = {};
            modelo = { 'ID': id };

            AcoesImprimirEspecifico(null, modelo, Opcao, Controller);

            return false;
        });

        $('#btnCancelar').on('click', function (e) {
            window.parent.$('#janelaMenu').data('kendoWindow').close();

            return false;
        });

        $('#btnAnular').on('click', function (e) {
            self.VerificaPodeAnular(e);

            return false;
        });

        //POSICIONA TITULO
        //var leftRef = $('.FormularioAjudaScroll').offset()['left'];
        //$('.titulo-form.titulo-pos').offset({ left: parseInt(leftRef) + 15 });
    };

    /*@description funcao que retorna as colunas da HT */
    self.RetornaColunasHT = function () {
        return [
            {
                ID: hdsnColumns.Documento,
                Label: resources['Documento'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                width: 100,
                readOnly: true
            },
            {
                ID: hdsnColumns.NomeFiscal,
                Label: resources['Cliente'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                width: 150,
                readOnly: true,
            },
            {
                ID: hdsnColumns.DataDocumento,
                Label: resources['DataDoc'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                width: 75,
                readOnly: true,
                className: "htRight"
            },
            {
                ID: hdsnColumns.DataVencimento,
                Label: resources['DataVenc'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                width: 75,
                readOnly: true,
                className: "htRight"
            },
            {
                ID: hdsnColumns.TotalMoedaDocumento,
                Label: resources['Total'].replace('{0}', SimboloMoedaRefCliente),
                TipoEditor: constTipoCompoHT.F3MNumero,
                CasasDecimais: CasasDecimaisTotais,
                width: 75,
                readOnly: true
            },
            {
                ID: hdsnColumns.ValorPendente,
                Label: SimboloMoedaRefCliente + ' ' + resources['ValorPend'],
                TipoEditor: constTipoCompoHT.F3MNumero,
                CasasDecimais: CasasDecimaisTotais,
                width: 75,
                readOnly: true
            },
            {
                ID: hdsnColumns.ValorPago,
                Label: SimboloMoedaRefCliente + ' ' + resources['ValorPag'],
                TipoEditor: constTipoCompoHT.F3MNumero,
                CasasDecimais: CasasDecimaisTotais,
                width: 75,
                readOnly: true
            },
            {
                ID: hdsnColumns.Natureza,
                Label: 'D / C',
                TipoEditor: constTipoCompoHT.F3MTexto,
                width: 40,
                readOnly: true,
            }];
    };

    //@description funcao que constroi Janela => Controi Linhas / Formas de Pagamento / Totais
    self.ConstroiJanela = function (inIDPagamentoVenda) {
        var UrlAux = window.location.pathname + '/GetPagamentosVendasLinhas';

        KendoLoading($('#iframeBody'), true);

        UtilsChamadaAjax(UrlAux, true, JSON.stringify({ IDPagamentoVenda: inIDPagamentoVenda }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                    Pagamento = res;

                    self.ConstroiLinhas(res);

                    self.ConstroiFormasPagamento(res);

                    self.ConstroiTotais(res);

                    self.TrataSeAnulado(res);

                    Recibo = res.Recibo;

                    PagamentosVendasLinhas = res.ListOfPendentes;
                }
            }, function () { return false; }, 1, true);
    };

    /*@description funcao que constroi aHT */
    self.ConstroiLinhas = function (data) {
        var item = data.ListOfPendentes;

        for (var i = 0, len = item.length; i < len; i++) {
            item[i].DataDocumento = UtilsConverteJSONDate(item[i].DataDocumento, constJSONDates.ConvertToDDMMAAAA);
            item[i].DataVencimento = UtilsConverteJSONDate(item[i].DataVencimento, constJSONDates.ConvertToDDMMAAAA);
        }

        var hdsn = HandsonTableDesenhaNovo(IDHDSN, item, 162, self.RetornaColunasHT(), false, null, null, true);

        if (item.length < 5) {
            HandsonTableStretchHTHeight(IDHDSN, 0);
        }
    };

    /*@description funcao que constroi as formas de pagamento */
    self.ConstroiFormasPagamento = function (data) {
        var UrlAux = './FormasPagamento';

        UtilsChamadaAjax(UrlAux, true, ({ IDPagamentoVenda: data.ID, IDMoeda: IDMoeda, Opcao: "recebimentos" }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    $('#dvFormasPagamento').html(res);

                    KendoLoading($('#iframeBody'), false);
                }
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    /*@description funcao que constroi os totais */
    self.ConstroiTotais = function (data) {
        $('#total').text(UtilsFormataSeparadoresDecimais_Milhares(data.TotalPagar.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda));
        $('#valorEntrege').text(UtilsFormataSeparadoresDecimais_Milhares(data.ValorEntregue.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda));
        $('#troco').text(UtilsFormataSeparadoresDecimais_Milhares(data.Troco.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda));
    };

    /*@description atualiza */
    self.Refresh = function () {
        var UrlAux = './Recebimentos';
        var IDDocumentoVendaAux = parseInt(window.parent.$('#IDDocumentoVenda').val());

        var ItemsLen = $('.Pagamentos').length;
        var SelectedItem = $('.Pagamentos.active').attr('id');
        //var SelectedItem = $('.Pagamentos.main-btn').attr('id');

        KendoLoading($('#iframeBody'), true);

        UtilsChamadaAjax(UrlAux, true, ({ IDDocumentoVenda: IDDocumentoVendaAux }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    $('#listOfRecebimentos').html(res);

                    self.UnbindAndBindEvents();

                    var NewItemsLen = $('.Pagamentos').length;
                    if (NewItemsLen != ItemsLen) {
                        $($('.Pagamentos')[NewItemsLen - 1]).trigger('click');
                    }
                    else {
                        $('.Pagamentos#' + SelectedItem).trigger('click');
                    }

                    KendoLoading($('#iframeBody'), false);
                }
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    /*@description bind events */
    self.UnbindAndBindEvents = function () {
        $('.' + clsPagamentos).off('click');
        $('.' + clsPagamentos).on('click', function (e) {
            if (parseInt(e.currentTarget.id) !== parseInt($('.' + clsPagamentos + '.active').attr('id'))) {
                $('.' + clsPagamentos).removeClass('active');
                $('#' + e.currentTarget.id).addClass('active');


                self.ConstroiJanela(e.currentTarget.id);
            }
            return false;
        });
    };

    /*@description funcoa que anula */
    self.Anula = function (e) {
        var UrlAux = window.location.pathname + '/Anula';
        var ID = parseInt($('.Pagamentos.active').attr('id'));

        KendoLoading($('#iframeBody'), true);

        UtilsChamadaAjax(UrlAux, true, JSON.stringify({ IDPagamentoVenda: ID }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    KendoLoading($('#iframeBody'), false);
                    //TOTO TRADUCAO
                    UtilsNotifica(base.constantes.tpalerta.s, "Anulado com sucesso!");

                    setTimeout(function (e) {
                        window.parent.$('#janelaMenu').data('kendoWindow').close();
                    }, 1000);
                }
                else {
                    KendoLoading($('#iframeBody'), false);
                    UtilsNotifica(base.constantes.tpalerta[res.TipoAlerta], res.Errors);
                }

            }, function () {
                return false;
            }, 1, true);
    };

    /*@description  funcao que poe a label anulado ... ou então não! */
    self.TrataSeAnulado = function (data) {
        if (data.CodigoTipoEstado === 'ANL') {
            $('#lblAnulado').css('display', 'block');
            $('#btnAnular').css('display', 'none');

        } else {
            $('#lblAnulado').css('display', 'none');
            $('#btnAnular').css('display', 'block');
        }
    };

    /*@description funcao que verifica se pode anular */
    self.VerificaPodeAnular = function (e) {
        var UrlAux = window.location.pathname + '/VerificaPodeAnular';
        var IDPagamentoVenda = parseInt($('.Pagamentos.active').attr('id'));

        UtilsChamadaAjax(UrlAux, true, JSON.stringify({ inIDPagamentoVenda: IDPagamentoVenda }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    UtilsConfirma(base.constantes.tpalerta.question, res.WarningMessage, function () {
                        self.Anula(e);
                    }, function () {
                        e.stopImmediatePropagation();
                    });
                }
                else {
                    UtilsNotifica(base.constantes.tpalerta[res.TipoAlerta], res.Errors);
                }
            }, function () { return false; }, 1, true);
    };

    return parent;

}($recebimentos || {}, jQuery));

var RecebimentosInit = $recebimentos.ajax.Init;

$(document).ready(function (e) {
    RecebimentosInit();
});