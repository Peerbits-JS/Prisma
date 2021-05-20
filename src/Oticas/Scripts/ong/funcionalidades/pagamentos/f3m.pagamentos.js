"use strict";

var $pagamentos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //#region 'Variáveis'
    var constTipoCompoHT = base.constantes.ComponentesHT;
    var constJSONDates = base.constantes.ConvertJSONDate;
    var constTipoDeCampo = base.constantes.TipoDeCampo;
    var SimboloMoedaRefCliente;
    var CasasDecimaisTotais;
    var IDMoeda;
    var ID;

    var Opcao;
    var TipoOpcao = {
        PAG: 'pagamentos',
        AD: 'adiantamentos',
        FROM_DOCSVENDAS: 'pagamentos_fromdocsvendas'
    };

    var isFIRST = true;

    var hdsnColumns = {
        LinhaSelecionada: 'LinhaSelecionada',
        Documento: 'Documento',
        NomeFiscal: 'NomeFiscal',
        DataDocumento: 'DataDocumento',
        DataVencimento: 'DataVencimento',
        TotalMoedaDocumento: 'TotalMoedaDocumento',
        ValorPendente: 'ValorPendente',
        ValorPago: 'ValorPago',
        Natureza: 'DescricaoSistemaNaturezas'
    }
    //#endregion

    var campoIDDocumentoServico = 'IDDocumentoVendaServico';
    var campoEImpFromServicosToDV = 'EImpFromServicosToDV';


    //#region 'Init'
    self.Init = function () {
        self.CarregaVariaveisGlobais();

        switch (Opcao) {
            case TipoOpcao.PAG:
                self.ConstroiHDSN_Pagamentos();
                break;

            case TipoOpcao.AD:
                self.ConstroiHDSN_Adiantamentos();
                break;

            case TipoOpcao.FROM_DOCSVENDAS:
                self.ConstroiHDSN_FROM_DOCSVENDAS();
                break;
        }

        $('#btnRefresh').on('click', function (e) {
            isFIRST = true;

            switch (Opcao) {
                case TipoOpcao.PAG:
                    self.ConstroiHDSN_Pagamentos();
                    break;

                case TipoOpcao.AD:
                    self.ConstroiHDSN_Adiantamentos();
                    break;
            }

            return false;
        });

        $("#btnSave").on('click', function (e) {
            self.GravaLinhas(e);

            return false;
        });

        $('#btnCancelar').on('click', function (e) {
            window.parent.$('#janelaMenu').data('kendoWindow').close();

            return false;
        });

        $('#btnSaveAndPrint').on('click', function (e) {
            self.GravaLinhas(e);

            return false;
        });

        //POSICIONA TITULO
        //var leftRef = $('.FormularioAjudaScroll').offset()['left'];
        //$('.titulo-form.titulo-pos').offset({ left: parseInt(leftRef) + 15 });

    };
    //#endregion

    self.ConstroiFormasPagamento = function (hdsn) {
        var UrlAux = './FormasPagamento';
        var IDMoedaAux = window.parent.$('#IDMoeda').val();
        var IDDocumentoVendaServico = 0

        var boolEImpFromServicosToDV = window.parent.$('#' + campoEImpFromServicosToDV).val() === 'true';
        if (boolEImpFromServicosToDV) {
            isFIRST = false;
            IDDocumentoVendaServico = window.parent.$('#' + campoIDDocumentoServico).val();
        }

        UtilsChamadaAjax(UrlAux, true, ({ IDPagamentoVenda: null, IDMoeda: IDMoedaAux, IDDocumentoVendaServico: IDDocumentoVendaServico }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    $('#dvFormasPagamento').html(res);

                    $('.FormPag').on('change', function (e) {
                        var item = $(e.currentTarget);
                        
                        if (!item.val()) {
                            item.val(parseFloat(item.attr('min')).toFixed(CasasDecimaisTotais))
                        }

                        if (parseFloat(item.val()) < parseFloat(item.attr('min'))) {
                            item.val(parseFloat(item.attr('min')).toFixed(CasasDecimaisTotais))
                        }
                        else {
                            item.val(parseFloat(item.val()).toFixed(CasasDecimaisTotais))
                        }

                        self.Calcula(null, "FormPag", null, null, parseInt(item.attr('id')));

                        return false;
                    });


                    $('.Distribuicao').on('click', function (e) {
                        var idFP = parseInt($($(e.currentTarget).parent()[0]).find('.FormPag').attr('id'));
                        self.Calcula(null, "Distribuicao", null, null, idFP);

                        return false;
                    });

                    //D I S A B L E   E N T E R   K E Y
                    $('input').keydown(function (event) {
                        if (event.keyCode == 13) {
                            event.preventDefault();
                            return false;
                        }
                    });

                    if (hdsn != null && hdsn.getSourceData().length > 0) {
                        hdsn.setDataAtCell(0, 0, true);
                    }
                    else if (hdsn != null && hdsn.getSourceData().length == 0) {
                        window.parent.$('#janelaMenu').data('kendoWindow').close();
                    }
                }
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    //#region 'Handsontable (Colunas / DesenhaNovo)'
    self.ConstroiHDSN_Pagamentos = function () {
        var IDEntidade = KendoRetornaElemento(window.parent.$('#IDEntidade')).value();
        var IDDocumentoVenda = window.parent.$('#IDDocumentoVenda').val();

        var UrlAux = window.location.pathname + '/PreencheModelo_Pagamentos';

        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var ValorAlterado = parseInt(IDEntidade);
        objetoFiltro['CamposFiltrar']['IDDocumentoVenda'] = { 'CampoValor': IDDocumentoVenda, 'CampoTexto': IDDocumentoVenda }
        objetoFiltro['CamposFiltrar']['IDEntidade'] = { 'CampoValor': ValorAlterado, 'CampoTexto': ValorAlterado }
        objetoFiltro['CamposFiltrar']['CasasDecimaisTotais'] = { 'CampoValor': CasasDecimaisTotais, 'CampoTexto': CasasDecimaisTotais }
        objetoFiltro['CamposFiltrar']['IDMoeda'] = { 'CampoValor': IDMoeda, 'CampoTexto': IDMoeda }

        objetoFiltro['CamposFiltrar']['ID'] = { 'CampoValor': ID, 'CampoTexto': ID }

        UtilsChamadaAjax(UrlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                    var _ListOfPendentes = res.ListOfPendentes;

                    for (var i = 0, len = _ListOfPendentes.length; i < len; i++) {
                        _ListOfPendentes[i].DataDocumento = UtilsConverteJSONDate(_ListOfPendentes[i].DataDocumento, constJSONDates.ConvertToDDMMAAAA);
                        _ListOfPendentes[i].DataVencimento = UtilsConverteJSONDate(_ListOfPendentes[i].DataVencimento, constJSONDates.ConvertToDDMMAAAA);
                    }

                    $('#saldo').text(UtilsFormataSeparadoresDecimais_Milhares(res.Saldo.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda));

                    var hdsn = HandsonTableDesenhaNovo('hdsnDocumentos', res.ListOfPendentes, 123, self.RetornaColunasHT(), false, null, null, true);
                    hdsn.updateSettings({
                        afterChange: function (changes, source) {
                            if (source == 'loadData') return

                            self.AfterChange(changes, source, hdsn);
                        },
                        fillHandle: false,
                        afterLoadData: function () {
                        }
                    });

                    if (_ListOfPendentes.length < 3) {
                        HandsonTableStretchHTHeight('hdsnDocumentos', 0);
                    }

                    //if (boolConstroiFormasPagamento) {
                    self.ConstroiFormasPagamento(hdsn);
                    //}
                }
                else {
                    var msg = res.Errors[0].Mensagem;
                    UtilsAlerta(base.constantes.tpalerta.error, msg);
                }
            },
                    function () { return false; }, 1, true);
    };

    self.RetornaColunasHT = function () {
        var result = [
            {
                ID: hdsnColumns.LinhaSelecionada,
                Label: (Opcao == TipoOpcao.AD || TipoOpcao.FROM_DOCSVENDAS) ? '' : '<input id="checkBoxColumn" class="htCheckboxRendererInput" autocomplete="off" type="checkbox" onClick="PagamentosHandsonTableClickHeader(this)">  ',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                width: 40,
                readOnly: (Opcao == TipoOpcao.AD || Opcao == TipoOpcao.FROM_DOCSVENDAS) ? true : false
            },
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
                Label: (window.parent.$('#janelaMenu').data('kendoWindow').options.data["Modo"] == "0" ? SimboloMoedaRefCliente + ' ' + resources['ValorPag'] : SimboloMoedaRefCliente + ' ' + resources['ValorAdi']),
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

        return result;
    };
    //#endregion

    //#region 'Funções especificas Handsontable'
    self.HandsonTableClickHeader = function (chkElem) {
        var colIndex = 0;
        var IDhdsn = 'hdsnDocumentos';
        var chkval = $(chkElem).is(':checked');
        var hdsn = window.HotRegisterer.getInstance(IDhdsn);

        self.Calcula(hdsn, "CheckboxHandsontable", chkval, null);

        var newColHeaders = hdsn.getColHeader();
        newColHeaders[colIndex] = chkval ? self.AdicionaChecked(newColHeaders[colIndex], true) : self.AdicionaChecked(newColHeaders[colIndex], false);
        hdsn.updateSettings({
            colHeaders: newColHeaders
        });
    };

    self.AdicionaChecked = function (inStr, inChecked) {
        if (inChecked) {
            return inStr.replace('type="checkbox"', 'type="checkbox" checked="checked" ')
        }
        else {
            return inStr.replace('checked="checked"', '');
        }
    };

    self.AfterChange = function (changes, source, hdsn) {
        var idLinha = hdsn.getDataAtRowProp(changes[0][0], 'ID');
        var Coluna = changes[0][1];

        if (Coluna == 'LinhaSelecionada' || Coluna == 'ValorPago') {
            self.Calcula(hdsn, Coluna, changes[0][3], idLinha, null);
        }
        else {
            self.Calcula(hdsn, null, changes[0][3], idLinha, null);
        }
    };
    //#endregion

    //#region 'Calculos
    self.Calcula = function (hdsn, CampoAlterado, CampoValor, idLinha, idFormPag) {
        var url = window.location.pathname + '/Calcula';

        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        objetoFiltro['CamposFiltrar']['CampoAlterado'] = { 'CampoValor': CampoAlterado, 'CampoTexto': CampoAlterado };
        objetoFiltro['CamposFiltrar']['CampoValor'] = { 'CampoValor': CampoValor, 'CampoTexto': CampoValor };
        objetoFiltro['CamposFiltrar']['idLinha'] = { 'CampoValor': idLinha, 'CampoTexto': idLinha };
        objetoFiltro['CamposFiltrar']['CasasDecimaisTotais'] = { 'CampoValor': CasasDecimaisTotais, 'CampoTexto': CasasDecimaisTotais };
        objetoFiltro['CamposFiltrar']['idFormPag'] = { 'CampoValor': idFormPag, 'CampoTexto': idFormPag };
        objetoFiltro['CamposFiltrar']['Opcao'] = { 'CampoValor': Opcao, 'CampoTexto': Opcao };

        hdsn = UtilsVerificaObjetoNotNullUndefined(hdsn) ? hdsn : window.HotRegisterer.bucket['hdsnDocumentos'];

        UtilsChamadaAjax(url, true, JSON.stringify({ inObjetoFiltro: objetoFiltro, inModelo: self.PreencheModelo(hdsn) }),
                function (res) {
                    if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                        self.RecebeModelo(res, hdsn);
                    }
                }, function (e) {throw e; }, 1, true);
    };
    //#endregion

    //#region 'Preenche Modelo / Recebe Modelo / Grava Linhas'
    self.PreencheModelo = function (inHdsn) {
        var modelo = new Object;

        modelo.IDEntidade = parseInt(KendoRetornaElemento(window.parent.$('#IDEntidade')).value());

        modelo.TotalPagar = 0;
        modelo.ValorEntregue = 0;
        modelo.Troco = 0;

        modelo.IDContaCaixa = 0;
        let caixaElem = KendoRetornaElemento($('#IDContaCaixa'));

        if (caixaElem) {
            modelo.IDContaCaixa = caixaElem.value();
        }

        modelo.ListOfPendentes = inHdsn.getSourceData();

        modelo.ListOfFormasPagamento = [];

        for (var i = 0, len = $('.FormPag').length; i < len; i++) {
            var PagamentosVendasFormasPagamento = new Object;
            var item = $($('.FormPag')[i])

            PagamentosVendasFormasPagamento.IDFormaPagamento = item.attr('id');
            PagamentosVendasFormasPagamento.Valor = parseFloat(item.val());
            PagamentosVendasFormasPagamento.Aux = (item.hasClass('selfEdit')) ? true : false;

            modelo.ListOfFormasPagamento.push(PagamentosVendasFormasPagamento);
        }

        return modelo;
    };

    self.RecebeModelo = function (res, hdsn) {
        var T = res.TotalPagar;
        var _ListOfPendentes = res.ListOfPendentes;

        if (_ListOfPendentes.length > 0) {
            for (var i = 0, len = res.ListOfPendentes.length; i < len; i++) {
                _ListOfPendentes[i].DataDocumento = UtilsConverteJSONDate(_ListOfPendentes[i].DataDocumento, constJSONDates.ConvertToDDMMAAAA);
                _ListOfPendentes[i].DataVencimento = UtilsConverteJSONDate(_ListOfPendentes[i].DataVencimento, constJSONDates.ConvertToDDMMAAAA);
            }

            hdsn.loadData(_ListOfPendentes);

            if (Opcao == TipoOpcao.PAG || Opcao == TipoOpcao.FROM_DOCSVENDAS) {
                for (var j = 0, lenj = hdsn.countRows() ; j < lenj; j++) {
                    hdsn.getCellMeta(j, 7).readOnly = !(hdsn.getDataAtRowProp(j, hdsnColumns.LinhaSelecionada) && hdsn.getDataAtRowProp(j, 'GereContaCorrente')); //hdsnColumns.ValorPago
                }
            }
            else if (Opcao == TipoOpcao.AD) {
                for (var j = 0, lenj = hdsn.countRows() ; j < lenj; j++) {
                    hdsn.getCellMeta(j, 7).readOnly = false //!(hdsn.getDataAtRowProp(j, hdsnColumns.LinhaSelecionada) && !hdsn.getDataAtRowProp(j, 'GereContaCorrente'));
                }
            }

            var aux = $.grep(hdsn.getSourceData(), function (obj, i) {
                return obj.LinhaSelecionada == false;
            });

            var newColHeaders = hdsn.getColHeader();
            if (aux.length > 0 && $('#checkBoxColumn').is(':checked')) {
                newColHeaders[0] = self.AdicionaChecked(hdsn.getColHeader()[0], false);
            }
            else if ((aux.length == 0 && !$('#checkBoxColumn').is(':checked'))) {
                newColHeaders[0] = self.AdicionaChecked(hdsn.getColHeader()[0], true);
            }

            hdsn.updateSettings({
                colHeaders: newColHeaders,
            });

            hdsn.render();

            var Total = UtilsFormataSeparadoresDecimais_Milhares(res.TotalPagar.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda)

            $('#totalPagar').text(Total);
            $('#totalPagarImprimir').text(Total);

            $('#valorEntrege').text(UtilsFormataSeparadoresDecimais_Milhares(res.ValorEntregue.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda));
            $('#troco').text(UtilsFormataSeparadoresDecimais_Milhares(res.Troco.toFixed(CasasDecimaisTotais), constTipoDeCampo.Moeda));

            self.PreencheFormasPagamento(res);

            if (isFIRST == true) {
                $('.FormPag').val(0);
                var item = $($('.FormPag')[0])
                //item.val(T);
                item.trigger('change');
            }
            isFIRST = false;
        }
    };

    self.GravaLinhas = function (e) {
        var hdsn = window.HotRegisterer.bucket['hdsnDocumentos'];

        if (Opcao === TipoOpcao.FROM_DOCSVENDAS) {
            self.ValidaEGrava_FROM_DOCSVENDAS(e);
        }
        else {
            var url = window.location.pathname + '/GravaLinhas';

            var objetoFiltro = GrelhaUtilsObjetoFiltro();
            var IDTipoDocumentoServico = $('#IDTipoDocumentoServico').val();

            objetoFiltro['CamposFiltrar']['Opcao'] = { 'CampoValor': Opcao, 'CampoTexto': Opcao };
            objetoFiltro['CamposFiltrar']['CasasDecimaisTotais'] = { 'CampoValor': CasasDecimaisTotais, 'CampoTexto': CasasDecimaisTotais };
            objetoFiltro['CamposFiltrar']['IDMoeda'] = { 'CampoValor': IDMoeda, 'CampoTexto': IDMoeda };
            objetoFiltro['CampoValores']['ELinhasTodas'] = { 'CampoValor': true, 'CampoTexto': true };


            if (Opcao == TipoOpcao.AD) {
                objetoFiltro['CamposFiltrar']['iddocumento'] = { 'CampoValor': ID, 'CampoTexto': ID };
                objetoFiltro['CamposFiltrar']['tipodocumento'] = { 'CampoValor': IDTipoDocumentoServico, 'CampoTexto': IDTipoDocumentoServico };
            }

            UtilsChamadaAjax(url, true, JSON.stringify({ inObjetoFiltro: objetoFiltro, modelo: self.PreencheModelo(hdsn) }),
                    function (res) {
                        if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                            if (res['isValid'] == true) {
                                var ID = res['ID'];

                                UtilsNotifica(base.constantes.tpalerta.s, resources.notificacao_grelha_rav);

                                if (e.currentTarget.id === 'btnSaveAndPrint' && (UtilsVerificaObjetoNotNullUndefined(ID))) {
                                    var OpcaoImpressao = Opcao == TipoOpcao.PAG ? 'Recibos' : 'DocumentosVendas';

                                    setTimeout(function (f) {
                                        var modelo = { 'ID': ID };
                                        ImprimirInit(null, modelo, OpcaoImpressao, PagamentosOnClosePrinterModal);
                                    }, 1000);
                                }

                                else if (e.currentTarget.id === 'btnSave') {
                                    //if (Opcao == TipoOpcao.AD) {
                                    var divOverlay = '<div id="overlay' + Opcao + '" class="k-overlay" style="display: block; z-index: 1001; opacity:0"></div>';
                                    $('.FormularioAjudaScroll').append(divOverlay);

                                    setTimeout(function (e) {
                                        window.parent.$('#janelaMenu').data('kendoWindow').close();
                                    }, 1000);
                                    //}
                                    //else {
                                    //    $('#btnRefresh').trigger('click');
                                    //}
                                }
                            }
                        }
                        else {
                            UtilsNotifica(base.constantes.tpalerta[res.TipoAlerta], res.Errors);

                            if (res.isValid === 'false') {
                                isFIRST = true;
                                $('#btnRefresh').trigger('click');
                            }

                        }
                    }, function (e) { }, 1, true);
        }
    };
    //#endregion
    self.PreencheFormasPagamento = function (inRes) {
        var FP = [];

        for (var i = 0, len = $('.FormPag').length; i < len; i++) {
            var PagamentosVendasFormasPagamento = new Object;
            var item = $($('.FormPag')[i])

            PagamentosVendasFormasPagamento.IDFormaPagamento = item.attr('id')
            PagamentosVendasFormasPagamento.Valor = parseFloat(item.val())

            FP.push(PagamentosVendasFormasPagamento);
        }

        for (var i = 0; i < inRes.ListOfFormasPagamento.length; i++) {
            var itemRES = inRes.ListOfFormasPagamento[i];

            for (var j = 0; j < FP.length; j++) {
                var itemFP = FP[j];

                if (itemRES['IDFormaPagamento'] == itemFP['IDFormaPagamento']) {
                    $('#' + itemFP['IDFormaPagamento']).val(parseFloat(itemRES['Valor']).toFixed(CasasDecimaisTotais));
                }
            }
        }
    };

    self.CarregaVariaveisGlobais = function () {
        SimboloMoedaRefCliente = window.parent.$('#SimboloMoedaRefCliente').val();
        CasasDecimaisTotais = window.parent.$('#CasasDecimaisTotais').val();
        IDMoeda = window.parent.$('#IDMoeda').val();
        ID = window.parent.$('#ID').val();
        Opcao = $('#tipopagamento').val();
    };

    self.ConstroiHDSN_Adiantamentos = function () {
        var IDEntidade = KendoRetornaElemento(window.parent.$('#IDEntidade')).value();
        var UrlAux = window.location.pathname + '/PreencheModelo_Adiantamentos';

        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        objetoFiltro['CamposFiltrar']['IDDocumentoVenda'] = { 'CampoValor': ID, 'CampoTexto': ID };
        objetoFiltro['CamposFiltrar']['IDEntidade'] = { 'CampoValor': IDEntidade, 'CampoTexto': IDEntidade };

        UtilsChamadaAjax(UrlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro }),
            function (res) {

                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                    var _ListOfPendentes = res.ListOfPendentes;

                    for (var i = 0, len = _ListOfPendentes.length; i < len; i++) {
                        _ListOfPendentes[i].DataDocumento = UtilsConverteJSONDate(_ListOfPendentes[i].DataDocumento, constJSONDates.ConvertToDDMMAAAA);
                        _ListOfPendentes[i].DataVencimento = UtilsConverteJSONDate(_ListOfPendentes[i].DataVencimento, constJSONDates.ConvertToDDMMAAAA);
                    }

                    var hdsn = HandsonTableDesenhaNovo('hdsnDocumentos', res.ListOfPendentes, 162, self.RetornaColunasHT(), false, null, null, true);
                    hdsn.updateSettings({
                        afterChange: function (changes, source) {
                            if (source == 'loadData') return

                            self.AfterChange(changes, source, hdsn);
                        },
                        fillHandle: false,
                    });

                    if (_ListOfPendentes.length < 5) {
                        HandsonTableStretchHTHeight('hdsnDocumentos', 0);
                    }

                    self.ConstroiFormasPagamento(hdsn);
                }
                else {
                    var msg = res.Errors[0].Mensagem;
                    UtilsAlerta(base.constantes.tpalerta.error, msg);
                }
            },
                    function () { return false; }, 1, true);
    };

    self.ConstroiHDSN_FROM_DOCSVENDAS = function () {
        var urlAux = rootDir + 'PagamentosVendas/PagamentosVendas/PreencheModelo_FROMDOCSVENDAS';

        var model = window.parent.$('#janelaMenu').data('kendoWindow').options.data.modelo;
        var IDEntidade = model['IDEntidade'];

        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        objetoFiltro['CamposFiltrar']['IDEntidade'] = { 'CampoValor': IDEntidade, 'CampoTexto': IDEntidade };

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ inModel: model, inObjFiltro: objetoFiltro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                    var _ListOfPendentes = res.ListOfPendentes;

                    for (var i = 0, len = _ListOfPendentes.length; i < len; i++) {
                        _ListOfPendentes[i].DataDocumento = UtilsConverteJSONDate(_ListOfPendentes[i].DataDocumento, constJSONDates.ConvertToDDMMAAAA);
                        _ListOfPendentes[i].DataVencimento = UtilsConverteJSONDate(_ListOfPendentes[i].DataVencimento, constJSONDates.ConvertToDDMMAAAA);
                    }

                    var hdsn = HandsonTableDesenhaNovo('hdsnDocumentos', res.ListOfPendentes, 162, self.RetornaColunasHT(), false, null, null, true);
                    hdsn.updateSettings({
                        afterChange: function (changes, source) {
                            if (source == 'loadData') return

                            self.AfterChange(changes, source, hdsn);
                        },
                        fillHandle: false,
                    });

                    if (_ListOfPendentes.length < 5) {
                        HandsonTableStretchHTHeight('hdsnDocumentos', 0);
                    }

                    self.ConstroiFormasPagamento(hdsn);
                }
                else {
                    var msg = res.Errors[0].Mensagem;
                    UtilsAlerta(base.constantes.tpalerta.error, msg);
                }
            },
                    function () { return false; }, 1, true);
    };

    self.onClosePrinterModal = function (e) {
        $('#btnRefresh').trigger('click');
    };

    self.ValidaEGrava_FROM_DOCSVENDAS = function (e) {
        var UrlAux = window.location.pathname + '/Valida_FROMDOCSVENDAS';
        var IDhdsn = 'hdsnDocumentos';
        var hdsn = window.HotRegisterer.getInstance(IDhdsn);
        var model = self.PreencheModelo(hdsn);

        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var IDTipoDocumentoServico = $('#IDTipoDocumentoServico').val();

        objetoFiltro['CamposFiltrar']['Opcao'] = { 'CampoValor': Opcao, 'CampoTexto': Opcao };
        objetoFiltro['CamposFiltrar']['CasasDecimaisTotais'] = { 'CampoValor': CasasDecimaisTotais, 'CampoTexto': CasasDecimaisTotais };
        objetoFiltro['CamposFiltrar']['IDMoeda'] = { 'CampoValor': IDMoeda, 'CampoTexto': IDMoeda };

        UtilsChamadaAjax(UrlAux, true, JSON.stringify({ inModelo: model, inObjetoFiltro: objetoFiltro }),
                               function (res) {
                                   if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                                       if (res['isValid'] == true) {
                                           var modelParent = window.parent.$('#janelaMenu').data('kendoWindow').options.data.modelo;

                                           var modelo = self.PreencheModelo(hdsn);

                                           if (model.ListOfPendentes.length > 0) {
                                               for (var i = 0, len = model.ListOfPendentes.length; i < len; i++) {
                                                   model.ListOfPendentes[i].DataCriacao = UtilsConverteJSONDate(model.ListOfPendentes[i].DataCriacao, constJSONDates.ConvertToDDMMAAAA);
                                               }
                                           }

                                           modelParent['PagamentosVendas'] = modelo;
                                           modelParent['BotaoClicado'] = e.currentTarget.id; // PAGAR E IMPRIMIR || PAGAR

                                           window.parent.$('#janelaMenu').data('kendoWindow').options.data.modelo = modelParent;
                                           window.parent.$('#janelaMenu').data('kendoWindow').close();
                                       }
                                   }
                                   else {
                                       UtilsNotifica(base.constantes.tpalerta[res.TipoAlerta], res.Errors);

                                       if (res.isValid === 'false') {
                                           isFIRST = true;
                                           $('#btnRefresh').trigger('click');
                                       }

                                   }
                               }, function (e) { }, 1, true);
    };

    return parent;

}($pagamentos || {}, jQuery));

//#region 'Variáveis Globais'
var PagamentosInit = $pagamentos.ajax.Init;
var PagamentosHandsonTableClickHeader = $pagamentos.ajax.HandsonTableClickHeader;
var PagamentosOnClosePrinterModal = $pagamentos.ajax.onClosePrinterModal;
//#endregion

//#region 'Document Functions'
$(document).ready(function (e) {
    PagamentosInit();
});
//#endregion

$(document).ajaxSend(function (inEvent, jqxhr, inSettings) {
    var requestsBarLoding = ['PagamentosVendas/Calcula'];
    KendoBarLoading(null, inSettings, requestsBarLoding);
}).ajaxStop(function () {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
});