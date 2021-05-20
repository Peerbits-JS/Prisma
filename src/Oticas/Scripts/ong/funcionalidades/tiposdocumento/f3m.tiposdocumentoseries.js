"use strict";

var $tiposdocumentoseries = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constCamposGen = base.constantes.camposGenericos;
    var constSourceHT = base.constantes.SourceHT;
    var campoID = constCamposGen.ID;

    var cssClassBts = base.constantes.tiposComponentes.grelhaBotoes;
    var constEstados = base.constantes.EstadoFormEAcessos;
    var estadoEditar = constEstados.Alterar;

    var constIDsBts = base.constantes.grelhaBotoesIDs;
    var btIDGuardar = constIDsBts.Guardar
    var btIDGuardarFechar = constIDsBts.GuardarFecha;
    var btIDGuardarFechar2 = constIDsBts.GuardarFecha2;
    var btIDGuardarCont = constIDsBts.GuardarCont;
    var btIDCancelar = constIDsBts.Cancelar;
    var btIDCancelar2 = constIDsBts.Cancelar2;
    var btIDRemove = constIDsBts.Remover;
    var btIDAdd = constIDsBts.Adicionar;
    var btIDDuplicar = constIDsBts.Duplicar;

    var constGFTDS = 'F3MGrelhaFormTiposDocumentosSeries';
    var constGFTD = 'F3MGrelhaFormTiposDocumento';

    var btsAcoesAdicionar = '#' + constGFTD + btIDGuardarFechar + ', #' + constGFTD + btIDGuardarCont + ', #' + constGFTD + btIDCancelar;
    var btsAcoesAdicionaGeral = '#' + constGFTD + btIDGuardarFechar + ', #' + constGFTD + btIDGuardarCont;
    var btsEditaGeral = '#' + constGFTD + btIDGuardarFechar2 + ', #' + constGFTD + btIDCancelar2;

    var btsEdita = '#' + constGFTDS + btIDGuardarFechar2 + ', #' + constGFTDS + btIDCancelar2;
    var btsCrud = '#' + constGFTDS + btIDAdd + ', #' + constGFTDS + btIDRemove;
    var btsAdiciona = '#' + constGFTDS + btIDGuardarFechar + ', #' + constGFTDS + btIDGuardarCont + ', #' + constGFTDS + btIDCancelar;
    var btDuplica = '#' + constGFTDS + btIDDuplicar;

    var constClasses = base.constantes.classes;
    var constBtsClass = base.constantes.grelhaBotoesCls;
    var btClassRepoe = constBtsClass.Repor;
    var btClassDisabled = constBtsClass.Disabled;
    var btClassInvisivel = constBtsClass.Invisivel;

    var msgErroID = base.constantes.janelasPopupIDs.Erro;
    var constRequired = base.constantes.grelhaBotoesCls.Required;
    var constFormularioPrincipal = 'FormularioPrincipal';

    var ObjetosSeries = {
        'SeriesEditadas': [],
        'SeriesAdicionadas': [],
        'SeriesRemovidas': [],
    };

    var Modulo = {
        Stocks: '001',
        Compras: '003',
        Vendas: '004',
        Producao: '005',
        ContaCorrente: '006'
    };

    var MODULO = $('#Modulo').val();
    var GRID = null;

    self.Init = function () {
        // Mostra label do botao adicionar
        $('#F3MGrelhaFormTiposDocumentosSeriesBtAdd').append('<div class=label-btn-acoes> <span>' + resources.Adicionar + '</span><br><span>' + resources.Serie + '</span></div>');
        //Prepara dirty.
        var edicao = $('#EmExecucao').val();
        if (edicao == estadoEditar) {
            self.TrataModuloDoc();
        }

        var dto = GrelhaFormDTO($('#OpcaoSeries'));
        var modeloForm = GrelhaUtilsGetModeloForm(dto);
        if (!($("#AtivoSerie").prop("checked"))) {
            self.BloqueiaCamposSeries();
        }

        //ALM - desativa o autocomplete do chrome
        FrontendChangeAutocompleteInputs();

        self.AplicaDirtySeries(modeloForm, dto, 'OpcaoSeries');

        $('#AtivoSerie').on('click', function (e) {
            self.AtivoSerieClique(e);
        })

        $('SugeridaPorDefeito').on('click', function (e) {

        })

        $('#F3MGrelhaFormTiposDocumentosSeriesBtCopy').click(function (e) {
            e.preventDefault();
            KendoLoading($('#OpcaoSeries'), true);

            var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
            ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;
            $('#' + ATIVO).removeClass('active');
            $('#ATIVO').val(ATIVO);

            var formulario = $('#OpcaoSeries');
            var model = self.RetornaModeloTiposDocumentosSeries(1);

            self.PreencheViewFromData(model, true);

            $(btsAdiciona).removeClass('invisivel');
            $(btsEdita).addClass('invisivel');
            $(btsCrud).addClass('invisivel');
            $(btDuplica).addClass('invisivel');

            var grid = KendoRetornaElemento($('#' + constGFTD));
            self.AtivaDesativaCabecalhoBtsFormTD(grid, true);

            KendoLoading($('#OpcaoSeries'), false);
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtAdd').click(function (e) {
            e.preventDefault();

            KendoLoading($('#OpcaoSeries'), true);
            var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
            ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;
            //var ATIVO = $('#ATIVO').val(parseInt($('#div_Results').find('.active').attr('id')));
            $('#' + ATIVO).removeClass('active');
            $('#ATIVO').val(ATIVO);

            TiposDocumentoTrataViewSeries(0);
            $('#SerieEdicao').val(true);
            var grid = KendoRetornaElemento($('#' + constGFTD));
            self.AtivaDesativaCabecalhoBtsFormTD(grid, true);
            self.TrataModuloDoc();
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtCancel').click(function (e) {
            e.preventDefault();
            KendoLoading($('#OpcaoSeries'), true);
            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_cancelar_alteracoes,
                function () {
                    var ATIVO = $('#ATIVO').val();
                    if (ATIVO == 0 || ATIVO == '') {
                        $($('#div_Results').children().children()[0]).addClass('active');
                        //var ATIVO = $('#ATIVO').val(($($('#div_Results').children().children()[0]).attr('id')));
                    }
                    else {
                        $('#' + ATIVO).addClass('active');
                    }

                    if (self.VerificaAdicionadas() != null) {
                        self.PreencheViewFromData(self.VerificaAdicionadas())
                    }
                    else {
                        TiposDocumentoTrataViewSeries(ATIVO);
                    }
                    var wnd = $('#' + msgErroID).data('kendoWindow');
                    if (UtilsVerificaObjetoNotNullUndefined(wnd)) {
                        wnd.close();
                    }
                    var grid = KendoRetornaElemento($('#' + constGFTD));
                    self.AtivaDesativaCabecalhoBtsFormTD(grid, false);
                    KendoLoading($('#OpcaoSeries'), false);
                }, function () {
                    KendoLoading($('#OpcaoSeries'), false);
                    return false;
                });
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtCancel2').click(function (e) {
            e.preventDefault();
            KendoLoading($('#OpcaoSeries'), true);
            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_cancelar_alteracoes,
                function () {

                    if (self.VerificaAdicionadas() != null) {
                        self.PreencheViewFromData(self.VerificaAdicionadas())
                    }
                    else {

                        var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
                        ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;
                        $('#ATIVO').val(ATIVO);
                        TiposDocumentoTrataViewSeries(ATIVO);
                    }
                    var wnd = $('#' + msgErroID).data('kendoWindow');
                    if (UtilsVerificaObjetoNotNullUndefined(wnd)) {
                        wnd.close();
                    }
                    var grid = KendoRetornaElemento($('#' + constGFTD));
                    self.AtivaDesativaCabecalhoBtsFormTD(grid, false);
                    KendoLoading($('#OpcaoSeries'), false);
                }, function () {
                    KendoLoading($('#OpcaoSeries'), false);
                    return false;
                });
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveFecha2').click(function (e) {

            var formulario = $('#OpcaoSeries');
            var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));
            var boolModel = UtilsVerificaObjetoNotNullUndefined(model);

            var erros = GrelhaUtilsValida(formulario);
            if (erros != null) {
                return null;
            }
            else {
                if (!($("#AtivoSerie").prop("checked"))) {

                    var objetoFiltro = [];
                    var UrlAux = window.location.pathname.replace('/IndexGrelha', '') + 'Series/PermiteInAtivarSerie';

                    objetoFiltro['IDSerie'] = parseInt($('#div_Results').find('.active').attr('id'));
                    objetoFiltro['IDTipoDoc'] = $('#ID').val();

                    var dadosJSON = JSON.stringify(HandsonTableEnviaParamsHT(objetoFiltro));

                    UtilsChamadaAjax(UrlAux, true, dadosJSON,
                        function (res) {
                            if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                                if (res.blnPermiteInAtivarSerie == true) {
                                    UtilsConfirma(base.constantes.tpalerta.question, resources.ColocaSerieInativa, function () {
                                        self.GravaSerie(model, boolModel);
                                        self.BloqueiaCamposSeries();

                                        $($('.tab-depois li a')[0]).trigger('click')

                                    }, function () { return });

                                } else {

                                    var ano = res.Ano;
                                    var dataSerie = '31/12/' + ano;

                                    UtilsAlerta(base.constantes.tpalerta.error, resources.valida_serie_inativa.replace('{0}', dataSerie));
                                }
                            }
                            else {
                                var msg = res.Errors[0].Mensagem;
                                UtilsAlerta(base.constantes.tpalerta.error, msg);
                            }
                        },
                        function () { return false; }, 1, true);
                }
                else {
                    self.GravaSerie(model, boolModel);
                }
            }

            self.AplicaDirtySeries(model, dto, 'OpcaoSeries');
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveFecha').click(function (e) {
            e.preventDefault();
            KendoLoading($('#OpcaoSeries'), true);
            var formulario = $('#OpcaoSeries');
            var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));
            var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
            if (boolModel) {
                var tipoAcaoSerie = 0;
                var erros = GrelhaUtilsValida(formulario);
                if (erros != null) {
                    KendoLoading($('#OpcaoSeries'), false);
                    return null;
                }
                else {
                    if (self.ValidaCodigoSerie(model.CodigoSerie) === false) {
                        KendoLoading($('#OpcaoSeries'), false);
                        return UtilsAlerta(base.constantes.tpalerta.error, resources['SerieExistente'].replace('{0}', model.CodigoSerie))
                    }

                    if (self.ValidaExpressaoRegularSerie(model.CodigoSerie) === false) {
                        KendoLoading($('#OpcaoSeries'), false);
                        return UtilsAlerta(base.constantes.tpalerta.error, resources.ValidaSerie);
                    }

                    //if (self.ValidaDatasInicialFinal() == false) {
                    //    KendoLoading($('#OpcaoSeries'), false);
                    //    return UtilsAlerta(base.constantes.tpalerta.error, resources['DataFinalSuperiorDataInicial']);
                    //}

                    if (model.CodigoSerie != $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == true) {
                        $('#SeriePorDefeito').val(model.CodigoSerie);
                    }

                    if (model.CodigoSerie == $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == false) {
                        $('#SeriePorDefeito').val('');
                    }

                    ObjetosSeries = TiposDocumentoRetornaObjetoSeries();
                    ObjetosSeries['SeriesAdicionadas'].push(self.RetornaModeloTiposDocumentosSeries(tipoAcaoSerie));

                    self.RefreshTreeAfterInsert();
                    $('.list-group').prepend('<a href="#" id="' + model.CodigoSerie + '" class="list-group-item addedSerie active">' + model.CodigoSerie + '</a>')

                    $('.addedSerie').bind('click', function (e) {
                        var btGravaEdita = $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveFecha2');
                        if (btGravaEdita.hasClass(btClassDisabled) && $(btsAdiciona).hasClass(btClassInvisivel)) {
                            self.AcoesClickAdicionadas(e);
                        }
                        else {
                            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_sair,
                                function () {
                                    self.AcoesClickAdicionadas(e);
                                },
                                function () {
                                    return false;
                                });
                        }
                    });
                    $(btsAdiciona).addClass('invisivel');
                    $(btsEdita).removeClass('invisivel').addClass('disabled');
                    $(btsCrud).removeClass('invisivel');
                    $(btDuplica).removeClass('invisivel');

                    var grid = KendoRetornaElemento($('#' + constGFTD));
                    self.AtivaDesativaCabecalhoBtsFormTD(grid, false);
                    KendoLoading($('#OpcaoSeries'), false);
                }
            }
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveContinua').click(function (e) {
            e.preventDefault();
            KendoLoading($('#OpcaoSeries'), true);
            var formulario = $('#OpcaoSeries');
            var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));
            var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
            if (boolModel) {
                var tipoAcaoSerie = 0;
                var erros = GrelhaUtilsValida(formulario);
                if (erros != null) {
                    KendoLoading($('#OpcaoSeries'), false);
                    return null;
                }
                else {
                    if (self.ValidaCodigoSerie(model.CodigoSerie) === false) {
                        KendoLoading($('#OpcaoSeries'), false);
                        return UtilsAlerta(base.constantes.tpalerta.error, resources['SerieExistente'].replace('{0}', model.CodigoSerie));
                    }
                    if (self.ValidaExpressaoRegularSerie(model.CodigoSerie) === false) {
                        KendoLoading($('#OpcaoSeries'), false);
                        return UtilsAlerta(base.constantes.tpalerta.error, resources.ValidaSerie);
                    }

                    //if (self.ValidaDatasInicialFinal() == false) {
                    //    KendoLoading($('#OpcaoSeries'), false);
                    //    return UtilsAlerta(base.constantes.tpalerta.error, resources['DataFinalSuperiorDataInicial']);
                    //}

                    if (model.CodigoSerie != $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == true) {
                        $('#SeriePorDefeito').val(model.CodigoSerie);
                    }

                    if (model.CodigoSerie == $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == false) {
                        $('#SeriePorDefeito').val('');
                    }

                    ObjetosSeries = TiposDocumentoRetornaObjetoSeries();
                    ObjetosSeries['SeriesAdicionadas'].push(self.RetornaModeloTiposDocumentosSeries(tipoAcaoSerie));

                    self.RefreshTreeAfterInsert();
                    $('.list-group').prepend('<a href="#" id="' + model.CodigoSerie + '" class="list-group-item addedSerie">' + model.CodigoSerie + '</a>')

                    $('.addedSerie').bind('click', function (e) {
                        var btGravaEdita = $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveFecha2');
                        if (btGravaEdita.hasClass(btClassDisabled) && $(btsAdiciona).hasClass(btClassInvisivel)) {
                            self.AcoesClickAdicionadas(e);
                        }
                        else {
                            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_sair,
                                function () {
                                    self.AcoesClickAdicionadas(e);
                                },
                                function () {
                                    return false;
                                });
                        }
                    });

                    TiposDocumentoTrataViewSeries(0);
                    KendoLoading($('#OpcaoSeries'), false);
                    self.TrataModuloDoc();
                }
            }
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentosSeriesBtRemove').click(function (e) {
            e.preventDefault();
            KendoLoading($('#OpcaoSeries'), true);
            var formulario = $('#OpcaoSeries');
            var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));
            var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
            if (boolModel) {

                var boolDocs = (model.BlnTemDocAssoc == "true")

                if (boolDocs) {
                    UtilsConfirma(base.constantes.tpalerta.i, resources.SerieValidaRemocao.replace('{0}', model.CodigoSerie))
                    KendoLoading($('#OpcaoSeries'), false);
                }
                else {
                    UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_remover.replace('{0}', model.CodigoSerie),
                        function () {
                            var tipoAcaoSerie = 2;
                            var serie = model.CodigoSerie;
                            if (model.CodigoSerie == $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == true) {
                                $('#SeriePorDefeito').val('');
                            }
                            var validaRemove = true;
                            ObjetosSeries = TiposDocumentoRetornaObjetoSeries();
                            var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
                            ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;

                            //if (ObjetosSeries.SeriesAdicionadas.length != 0) {
                            for (var i = 0; i < ObjetosSeries.SeriesAdicionadas.length; i++) {
                                if (ObjetosSeries.SeriesAdicionadas[i].CodigoSerie == ATIVO) {
                                    validaRemove = false;
                                    ObjetosSeries.SeriesAdicionadas.splice(i, 1);
                                }
                            }
                            if (validaRemove) {
                                if (ObjetosSeries.SeriesEditadas.length != 0) {
                                    for (var i = 0; i < ObjetosSeries.SeriesEditadas.length; i++) {
                                        if (ObjetosSeries.SeriesEditadas[i].ID == ATIVO) {
                                            ObjetosSeries.SeriesEditadas.splice(i, 1)
                                        }
                                    }
                                }
                                ObjetosSeries['SeriesRemovidas'].push(self.RetornaModeloTiposDocumentosSeries(tipoAcaoSerie));
                            }
                            //}
                            //else {
                            //    if (ObjetosSeries.SeriesEditadas.length != 0) {
                            //        for (var i = 0; i < ObjetosSeries.SeriesEditadas.length; i++) {
                            //            if (ObjetosSeries.SeriesEditadas[i].ID == ATIVO) {
                            //                ObjetosSeries.SeriesEditadas.splice(i, 1)
                            //            }
                            //        }
                            //    }
                            //    ObjetosSeries['SeriesRemovidas'].push(self.RetornaModeloTiposDocumentosSeries(tipoAcaoSerie));
                            //}

                            $('.list-group').find('.active').remove();
                            self.RefreshTreeAfterRemove();
                            var grid = KendoRetornaElemento($('#' + constGFTD));
                            self.AtivaDesativaCabecalhoBtsFormTD(grid, false);
                            KendoLoading($('#OpcaoSeries'), false);
                        },
                        function () {
                            KendoLoading($('#OpcaoSeries'), false);
                            return false
                        });
                }
            }
            e.stopImmediatePropagation();
        });

        $('#F3MGrelhaFormTiposDocumentoBtSaveFecha2').unbind('click').click(function (e) {
            var elemID = $(e.currentTarget).attr('id');
            var elemBtID = elemID.replace(constGFTD, '');
            $('#SerieEdicao').val(true);
            self.Acoes(elemBtID);
        });

        var elemFloatingDocumento = 'elemFloatingDocumentoBt'
        var elemFloatingDoc = 'elemFloatingDocumento';


        //evt click floating tipos doc
        $('#' + elemFloatingDocumento).on('click', function (e) {

            var strIDMapaVistas = $('#IDMapasVistas')[0].value
            var strNomeIDMapaVistas = $('#IDMapasVistas')[0].name;

            var InstanciaSQL = constInstanciaSQL;
            var ServSQL = constServSQL;
            var CodigoEmpresa = constCodigoEmpresa

            var objIDMapaVistas = { 'Name': strNomeIDMapaVistas, 'Value': strIDMapaVistas };
            var objServSQL = { 'Name': 'ServSQL', 'Value': ServSQL };
            var objInstanciaSQL = { 'Name': 'InstanciaSQL', 'Value': InstanciaSQL };
            var objCodigoEmpresa = { 'Name': 'CodigoEmpresa', 'Value': CodigoEmpresa };


            var objParamsEsp = [objIDMapaVistas, objServSQL, objInstanciaSQL, objCodigoEmpresa]

            var dados = KendoRetornaElemento($('#IDMapasVistas')).dataSource.data();

            for (var i = 0; i < dados.length; i++) {
                if (dados[i].ID == strIDMapaVistas) {
                    var mapa = dados[i];
                    var entidade = mapa.Entidade;
                }
            }

            if (mapa.Certificado === true) {

                var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
                var objeto = { model: JSON.stringify({ Entidade: mapa.Entidade, IDMapasVistas: mapa.ID, Modelo: null, ServSQL: ServSQL, InstanciaSQL: InstanciaSQL }) };

                $layout.ajax.OpenTypeKendoWindow(janelaMenuLateral, '../MapasVistas/AtivaDesigner', '350', '250', objeto);
            }
            else {
                var objParam = ImprimirPreencheParametros(mapa.Entidade, null, objParamsEsp);
                ImprimirDesenhaJanelaReportDesigner(objParam, null, 'Report Designer');
            }


        });


        $(btsAcoesAdicionaGeral).unbind('click').click(function (e) {
            var elemID = $(e.currentTarget).attr('id');
            var elemBtID = elemID.replace(constGFTD, '');
            $('#SerieEdicao').val(true);
            self.Acoes(elemBtID);
        });

        //$('#NumUltimoDoc').on('blur', function () {
        //    self.TrataDataUltimoDoc();
        //});

        self.ConstroiHTPermissoes();
        self.TrataChecksValoresPorDefeito();

        if ($('#' + base.constantes.tiposComponentes.splitterID).data('kendoSplitter') != undefined) {
            $('#' + base.constantes.tiposComponentes.splitterID).data('kendoSplitter').bind('resize', self.OnSplitterResizeHT);
        }

        //var tabPermissoes = $('#OpcaoSeries').find('.clsF3MTabs a[href=#tabPermissoes]');
        //VERIFICAR DEPOIS O CLICK DO TAB PERMISSOES E VERIFICAR HANDSONTABLE
        var tabPermissoes = $('#OpcaoSeries').find('.clsF3MTabs a[href=#tabPermissoes]');
        // TABS
        tabPermissoes.on('shown.bs.tab', function (e) {
            if ($('#grelhaPermissoes').hasClass('handsontable')) {
                HandsonTableStretchHTHeight('grelhaPermissoes', 50);
                HandsonTableStretchHTWidthToContainer();

                if (!($("#AtivoSerie").prop("checked")) && $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveFecha2').hasClass('disabled')) {
                    $('.htCheckboxRendererInput').attr('disabled', true)
                }
            }
        });

        $('#' + constIDsBts.GuardarFecha2F4).unbind('click').click(function (e) {
            var elemID = $(e.currentTarget).attr('id');
            var elemBtID = elemID.replace(constGFTD, '');
            $('#SerieEdicao').val(true);
            self.Acoes(elemBtID);
            return false;
        });
    };

    self.GravaSerie = function (model, boolModel) {

        if (self.ValidaCodigoSerie(model.CodigoSerie) === false) {
            KendoLoading($('#OpcaoSeries'), false);
            return UtilsAlerta(base.constantes.tpalerta.error, resources['SerieExistente'].replace('{0}', model.CodigoSerie))
        }

        if (self.ValidaExpressaoRegularSerie(model.CodigoSerie) === false) {
            KendoLoading($('#OpcaoSeries'), false);
            return UtilsAlerta(base.constantes.tpalerta.error, resources.ValidaSerie);
        }

        //if (self.ValidaDatasInicialFinal() == false) {
        //    KendoLoading($('#OpcaoSeries'), false);
        //    return UtilsAlerta(base.constantes.tpalerta.error, resources['DataFinalSuperiorDataInicial']);
        //}

        if (model.CodigoSerie != $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == true) {
            $('#SeriePorDefeito').val(model.CodigoSerie);
        }

        if (model.CodigoSerie == $('#SeriePorDefeito').val() && model.SugeridaPorDefeito == false) {
            $('#SeriePorDefeito').val('');
        }

        var flag = false;
        var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
        //VALIDACAO ID ADICIONADOS PODE SER STRING NA TREE
        ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;
        $('#ATIVO').val(ATIVO);
        var j = 0;

        var addedSeries = TiposDocumentoRetornaObjetoSeries().SeriesAdicionadas
        for (var i = 0; i < addedSeries.length; i++) {

            if (addedSeries[i].CodigoSerie == ATIVO) {
                flag = true;
                j = i;
                break;
            }
        }

        if (flag == false) {
            if (boolModel) {


                var existe = false;
                var q;
                var tipoAcaoSerie = 1;
                var editedSeries = TiposDocumentoRetornaObjetoSeries().SeriesEditadas;
                for (var i = 0; i < editedSeries.length; i++) {
                    if (editedSeries[i].ID == ATIVO) {
                        existe = true;
                        q = i;
                        break;
                    }
                }

                if (existe == true) {
                    TiposDocumentoRetornaObjetoSeries().SeriesEditadas[q] = self.RetornaModeloTiposDocumentosSeries(tipoAcaoSerie);
                }
                else {
                    editedSeries.push(self.RetornaModeloTiposDocumentosSeries(tipoAcaoSerie));
                }
            }


            $('#' + ATIVO).unbind('click').click(function (e) {
                var btGravaEdita = $('#F3MGrelhaFormTiposDocumentosSeriesBtSaveFecha2');
                if (btGravaEdita.hasClass(btClassDisabled) && $(btsAdiciona).hasClass(btClassInvisivel)) {
                    self.AcoesClickEditadas(e);
                }
                else {
                    UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_sair,
                        function () {
                            self.AcoesClickEditadas(e);
                        },
                        function () {
                            return false;
                        });
                }
            });


        }
        else {
            addedSeries[j] = self.RetornaModeloTiposDocumentosSeries(0);
            var serie = model.CodigoSerie;
            $('#div_Results').find('.active').attr('id', serie);
        }

        if (ATIVO != model.CodigoSerie) {
            var serie = model.CodigoSerie;
            $('#div_Results').find('.active').text(serie);
        }

        $(btsEdita).addClass('disabled');
        //$(btsEditaGeral).removeClass('disabled');
        var grid = KendoRetornaElemento($('#' + constGFTD));
        self.AtivaDesativaCabecalhoBtsFormTD(grid, false);



    }

    self.BloqueiaCamposSeries = function () {

        KendoDesativaElemento('DescricaoSerie', true);

        $('#AtivoSerie').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);

        $('#SugeridaPorDefeito').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);

        $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);

        //KendoDesativaElemento('DataInicial', true);

        //KendoDesativaElemento('DataFinal', true);

        KendoDesativaElemento('IDParametrosEmpresaCAE', true);

        KendoDesativaElemento('IDMapasVistas', true);

        KendoDesativaElemento('NumeroVias', true);

        //KendoDesativaElemento('NumUltimoDoc', true);

        //KendoDesativaElemento('DataUltimoDoc', true);


    }

    self.DesbloqueiaCamposSeries = function () {
        KendoDesativaElemento('DescricaoSerie', false);
        $('#AtivoSerie').prop(base.constantes.grelhaBotoesCls.Disabled, false).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
        $('#SugeridaPorDefeito').prop(base.constantes.grelhaBotoesCls.Disabled, false).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
        $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, false).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
        KendoDesativaElemento('IDParametrosEmpresaCAE', false);
        KendoDesativaElemento('IDMapasVistas', false);
        KendoDesativaElemento('NumeroVias', false);
        if (MODULO == Modulo.Vendas && $('#IDLoja').length == 0) {
            $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
        }
    }

    self.TrataModuloDoc = function () {
        var IvaSeries = ['IVAIncluido', 'IVARegimeCaixa'];
        
        if (MODULO === Modulo.ContaCorrente && $('#TipoDoc').val() === "CntCorrLiquidacaoClt" && $('#AcaoFormSeries').val() === constEstados.Adicionar) {
            TiposDocumentoTrataChecksBoxs(IvaSeries, false, true);
            $('#IVAIncluido').prop('checked', true);
        }
        else {
            if (MODULO != Modulo.Vendas && MODULO != Modulo.Compras) {
                TiposDocumentoTrataChecksBoxs(IvaSeries, false, false);
            }
            else {
                TiposDocumentoTrataChecksBoxs(IvaSeries, false, true);
            }
        }
        if (MODULO == Modulo.Vendas && $('#IDLoja').length == 0) {
            $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
        }
    };

    // ACOES DO CLICK NAS SERIES ADICIONADAS
    self.AcoesClickAdicionadas = function (e) {
        $($('.list-group-item')).removeClass('active');
        $(e.target).addClass('active');

        var addedSeries = TiposDocumentoRetornaObjetoSeries().SeriesAdicionadas

        for (var i = 0; i < addedSeries.length; i++) {
            if (addedSeries[i].CodigoSerie == $(e.target).attr('id')) {
                self.PreencheViewFromData(addedSeries[i]);
                return false;
            }
        }
    };

    // ACOES DO CLICK NAS SERIES EDITADAS
    self.AcoesClickEditadas = function (e) {
        $($('.list-group-item')).removeClass('active');
        $(e.target).addClass('active');
        var editedSeries = TiposDocumentoRetornaObjetoSeries().SeriesEditadas

        for (var i = 0; i < editedSeries.length; i++) {
            if (editedSeries[i].ID == $(e.target).attr('id')) {
                self.PreencheViewFromData(editedSeries[i]);
                if (!($("#AtivoSerie").prop("checked"))) {
                    self.BloqueiaCamposSeries();
                }
                else {
                    self.DesbloqueiaCamposSeries();
                }
                return false;
            }
        }

    };

    // APLICA COMPORTAMENTO DIRTY EM EDICAO PARA A OPCAO SERIES
    self.AplicaDirtySeries = function (modelo, DTO, gridID, botoesParaDirty) {
        DTO.Inputs.on('keyup change', function (e) {
            var modeloKendo = new kendo.data.Model(modelo);
            var elem = $(e.currentTarget);
            var elemID = elem.attr('id');
            var elemVal = elem.val();
            var gridElem = $('#' + gridID);

            if (gridElem.length) {
                //var grid = KendoRetornaElemento(gridElem);
                //var eGridForm = self.EFormulario(grid);

                // Para fazer a validacao em checkboxes
                if (elem.attr('type') === base.constantes.Kendo.checkbox) {
                    elemVal = elem.prop('checked');
                }
                //if (elemVal) {
                //    elemVal == "on"
                //}
                modeloKendo.set(elemID, elemVal);

                //// Se e Grelha Form
                //if (eGridForm) {
                //    gridElem = $('#' + gridID + 'Form form');
                //}

                var gridElemsIRLen = gridElem.find('.' + constClasses.F3MInputError).length;

                if (UtilsVerificaObjetoNotNullUndefined(modeloKendo) && modeloKendo.dirty) {
                    var btGrava = $('#' + constGFTDS + btIDGuardar);
                    GrelhaFormAtivaDesativaBotoesAcoes(constGFTDS, true);
                    var grid = KendoRetornaElemento($('#' + constGFTD));
                    self.AtivaDesativaCabecalhoBtsFormTD(grid, true);

                    // Valida seja required e tenha campos com classe "input-error"
                    if (elem.prop(constRequired) && gridElemsIRLen) {
                        GrelhaUtilsValida(gridElem);
                    }
                }
                else if (elem.prop(constRequired) && gridElemsIRLen) {
                    GrelhaUtilsValida(gridElem);
                }
            }
        });
    }

    self.Acoes = function (elemBtID) {
        var valorID = null;
        var formulario = $('#' + constGFTD + 'Form');
        if (formulario.length == 0) { formulario = $('#AdicionaF4'); }

        var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));
        var boolModel = UtilsVerificaObjetoNotNullUndefined(model);

        switch (elemBtID) {
            case constIDsBts.GuardarFecha2:
            case constIDsBts.GuardarFecha:
            case constIDsBts.GuardarCont:
            case constIDsBts.Guardar:
                if (boolModel) {

                    var validaEntidades = false;
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(model.TiposDocumentoTipEntPermDoc)) {
                        for (var i = 0; i < model.TiposDocumentoTipEntPermDoc.length; i++) {
                            if (model.TiposDocumentoTipEntPermDoc[i].checked == true) {
                                validaEntidades = true;
                            }
                        }

                        var TipoDoc = KendoRetornaElemento($('#IDSistemaTiposDocumento'))
                        if (UtilsVerificaObjetoNotNullUndefinedVazio(TipoDoc)) {
                            if ($('#EmExecucao').val() == estadoEditar) {
                                //validaEntidades = ($('#TipoDoc').val() != "ProdFinal") ? validaEntidades : true;
                                validaEntidades = (self.ValidaEntidadeGravacao($('#TipoDoc').val())) ? validaEntidades : true;
                            }
                            else {
                                //validaEntidades = (TipoDoc.dataItem().Tipo != "ProdFinal") ? validaEntidades : true;
                                validaEntidades = (self.ValidaEntidadeGravacao(TipoDoc.dataItem().Tipo)) ? validaEntidades : true;
                            }
                        }

                        if (model.TiposDocumentoTipEntPermDoc.length > 0 && validaEntidades == false) {
                            return UtilsAlerta(base.constantes.tpalerta.i, resources['AssociarEntidades']);
                        }
                    }
                    if (self.ValidaExpressaoRegularSerie(model.Codigo) === false) {
                        return UtilsAlerta(base.constantes.tpalerta.error, resources.ValidaCodTipoDoc);
                    }

                    if ($('#SeriePorDefeito').val() == '') {
                        UtilsAlerta(base.constantes.tpalerta.i, resources['DefinirSeriePorDefeito']);
                    }
                    else {
                        var grid = $('#' + constGFTD).data('kendoGrid');
                        var modeloForm = grid.dataItem(grid.select());
                        if (modeloForm) {
                            valorID = (UtilsVerificaObjetoNotNullUndefinedVazio(modeloForm[campoID])) ? modeloForm[campoID] : null;
                        }
                        self.PreencheModeloOpcaoAberta(model);

                        for (var i = 0; i < model.TiposDocumentoSeries.length; i++) {
                            var dtItem = model.TiposDocumentoSeries[i];

                            if (dtItem['CodigoSerie'] !== $('#SeriePorDefeito').val()) {
                                dtItem['SugeridaPorDefeito'] = false;
                            }
                        }

                        var options = grid.dataSource.transport.options;
                        var url = (valorID !== null && valorID > 0) ? options.update.url : options.create.url;
                        self.Valida(grid, url, model, elemBtID);
                    }
                }
                else {
                    UtilsAlerta(base.constantes.tpalerta.i, resources.existem_campos_invalidos_nas_grelhas);
                }
                break;

            case constIDsBts.GuardarFecha2F4:
                if (boolModel) {

                    var validaEntidades = false;
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(model.TiposDocumentoTipEntPermDoc)) {
                        for (var i = 0; i < model.TiposDocumentoTipEntPermDoc.length; i++) {
                            if (model.TiposDocumentoTipEntPermDoc[i].checked == true) {
                                validaEntidades = true;
                            }
                        }

                        if (model.TiposDocumentoTipEntPermDoc.length > 0 && validaEntidades == false) {
                            return UtilsAlerta(base.constantes.tpalerta.i, resources['AssociarEntidades']);
                        }
                    }
                    if (self.ValidaExpressaoRegularSerie(model.Codigo) === false) {
                        return UtilsAlerta(base.constantes.tpalerta.error, resources.ValidaCodTipoDoc);
                    }

                    if ($('#SeriePorDefeito').val() == '') {
                        UtilsAlerta(base.constantes.tpalerta.i, resources['DefinirSeriePorDefeito']);
                    }
                    else {
                        var grid = TiposDocumentosReturnGRID();
                        self.PreencheModeloOpcaoAberta(model);

                        for (var i = 0; i < model.TiposDocumentoSeries.length; i++) {
                            var dtItem = model.TiposDocumentoSeries[i];

                            if (dtItem['CodigoSerie'] !== $('#SeriePorDefeito').val()) {
                                dtItem['SugeridaPorDefeito'] = false;
                            }
                        }

                        var options = grid.dataSource.transport.options;
                        var url = options.create.url;
                        self.ValidaF4(grid, url, model, elemBtID);
                    }
                }
                else {
                    UtilsAlerta(base.constantes.tpalerta.i, resources.existem_campos_invalidos_nas_grelhas);
                }
                break;
        }
    };

    /* @description valida a entidade em determindo caso não é obrigatorio o preenchimento da entidade */
    self.ValidaEntidadeGravacao = function (inTipoDoc) {
        var blnDesbloqueado = true;

        switch (inTipoDoc) {
            case "ProdFinal":
            case "StkReserva":
            case "StkLibertarReserva":
            case "ProdCusto":
            case "ProdCustoEstorno":
                blnDesbloqueado = false
                break;
            default:
                blnDesbloqueado = true;
        }

        return blnDesbloqueado;
    };

    self.RetornaObjetosSeries = function () {
        return ObjetosSeries;
    }


    //PARA JA NAO USADO
    /* @description Preenche o modelo com a opção aberta, para enviar para servidor */
    self.PreencheModeloOpcaoAberta = function (model) {
        try {
            model.DataCriacao = $("#DataCriacao").val();
            model.UtilizadorCriacao = $("#UtilizadorCriacao").val();
            model.EmExecucao = $("#EmExecucao").val();

        } catch (ex) {
            throw ex;
        }
    }

    /* @description Cria objeto e retorna, apos preencher com os campos da opção series */
    self.RetornaModeloTiposDocumentosSeries = function (tipoAcaoSerie) {
        try {
            var grelhaHT = $('#grelhaPermissoes')
            var IDhdsn = $(grelhaHT.closest('.handsontable.htColumnHeaders')).attr('id');
            var hdsn = window.HotRegisterer.getInstance(IDhdsn);
            var hdsnDataSource = hdsn.getSourceData();
            var objModelo = {};
            //var ddlTDMP = KendoRetornaElemento($('#IDTipoDistMatPrima'));

            if (tipoAcaoSerie === 0) {
                objModelo.ID = 0;
                objModelo.AcaoRemover = false;
            }
            else if (tipoAcaoSerie === 1) {
                var ID = parseInt($('#ATIVO').val());

                if (ID != 0) {
                    objModelo.ID = ID;
                }
                else {
                    objModelo.ID = parseInt($('#div_Results').find('.active').attr('id'));
                }
                objModelo.AcaoRemover = false;
            }
            else if (tipoAcaoSerie === 2) {
                //var ID = parseInt($('#ATIVO').val());
                //if (ID != 0) {
                //    objModelo.ID = ID;
                //}
                //else {
                var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
                ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;
                objModelo.ID = ATIVO;
                //}
                objModelo.AcaoRemover = true;
            }
            objModelo.IDTiposDocumento = $("#ID").val();
            objModelo.AnalisesEstatisticasSerie = $('#AnalisesEstatisticasSerie').is(':checked');
            objModelo.IDParametrosEmpresaCAE = $('#IDParametrosEmpresaCAE').val();
            objModelo.CalculaComissoesSerie = $('#CalculaComissoesSerie').is(':checked');
            //objModelo.DataFinal = $('#DataFinal').val();
            //objModelo.DataInicial = $('#DataInicial').val();
            //objModelo.DataUltimoDoc = $('#DataUltimoDoc').val();
            objModelo.DescricaoSerie = $('#DescricaoSerie').val();
            objModelo.IDSistemaTiposDocumentoComunicacao = $('#IDSistemaTiposDocumentoComunicacao').val();
            objModelo.IDSistemaTiposDocumentoOrigem = $('#IDSistemaTiposDocumentoOrigem').val();
            objModelo.IVAIncluido = $('#IVAIncluido').is(':checked');
            objModelo.IVARegimeCaixa = $('#IVARegimeCaixa').is(':checked');
            //objModelo.NumUltimoDoc = $('#NumUltimoDoc').val();
            objModelo.CodigoSerie = $('#CodigoSerie').val()
            objModelo.AtivoSerie = $('#AtivoSerie').is(':checked');
            objModelo.SugeridaPorDefeito = $('#SugeridaPorDefeito').is(':checked');
            objModelo.DataCriacao = $("#DataCriacao").val();
            objModelo.UtilizadorCriacao = $("#UtilizadorCriacao").val();
            objModelo.EmExecucao = $("#EmExecucao").val();
            objModelo.NumeroVias = $("#NumeroVias").val();
            objModelo.IDMapasVistas = $("#IDMapasVistas").val();
            objModelo.IDLoja = $('#IDLoja').val();
            objModelo.ATCodValidacaoSerie = $("#ATCodValidacaoSerie").val();

            for (var i = 0; i < hdsnDataSource.length; i++) {
                hdsnDataSource[i].DataCriacao = $("#DataCriacao").val();
                hdsnDataSource[i].DataAlteracao = $("#DataCriacao").val();
                if (tipoAcaoSerie === 0) {
                    hdsnDataSource[i].ID = 0;
                    hdsnDataSource[i].IDLinhaTabela = 0;
                }
            }
            objModelo.TiposDocumentoSeriesPermissoes = hdsnDataSource;
            return objModelo;
        } catch (ex) {
            throw ex;
        }
    }

    /* @description VALIDA FORMULARIO DOS TIPOS DE DOCUMENTO */
    self.Valida = function (inGrelha, inURL, inModelo, inElemBtID) {
        var formulario = $('#' + constGFTD + 'Form, #OpcaoSeries');
        var gridID = inGrelha.element.attr('id');
        var urlNovo = $('#' + gridID + 'Form form').attr('action').split('?')[0];
        GrelhaUtilsValidaEGrava(inGrelha, formulario, urlNovo, inModelo, inElemBtID, self.ValidaEGravaSucesso, null);
    }

    /* @description VALIDA FORMULARIO DOS TIPOS DE DOCUMENTO */
    self.ValidaF4 = function (inGrelha, inURL, inModelo, inElemBtID) {
        var formulario = $('#AdicionaF4, #OpcaoSeries');
        var gridID = inGrelha.element.attr('id');
        GrelhaUtilsValidaEGrava(inGrelha, formulario, inURL, inModelo, inElemBtID, self.ValidaEGravaSucessoF4, null);
    }

    self.ValidaEGravaSucesso = function (resultado, inGrelha, inURL, inElemBtID, modeloLinha) {
        GrelhaFormValidaEGravaSucesso(resultado, inGrelha, inURL, inElemBtID, modeloLinha);
        UtilsBloquearElementos(inGrelha.element, false, true);
    };

    self.ValidaEGravaSucessoF4 = function (resultado, inGrelha, inURL, inElemBtID, modeloLinha) {
        var iframeDaCombo = TiposDocumentosReturnIFRAME();
        var idConteudo = "#f3m_tab_conteudo";
        var tabID = window.parent.$(idConteudo).find('.active').attr('id');
        var mensagem = resources.notificacao_grelha_add;
        var janela, combo;

        UtilsNotifica(base.constantes.tpalerta.s, mensagem);
        F4FechaTab(tabID, function () {
            var janelaElem = iframeDaCombo.contents().find('#' + 'IDTipoDocumento' + 'Janela');
            if (janelaElem.length != 0) {
                janela = iframeDaCombo[0].contentWindow.$(janelaElem).data('kendoWindow');
            }

            var comboElem = iframeDaCombo.contents().find('#' + 'IDTipoDocumento');
            if (comboElem.length != 0 && iframeDaCombo.length != 0) {
                combo = iframeDaCombo[0].contentWindow.$(comboElem).data('kendoComboBox');
            }

            if (janela.length != 0 && combo.length != 0) {
                janela.close();
                ComboBoxLimpa(combo);

                var item = resultado.ResultDataSource.Data[0].TiposDocumentoTipEntPermDoc;

                for (var i = 0; i < item.length; i++) {
                    if (item[i].checked == true) {
                        resultado.ResultDataSource.Data[0].EntidadesTipoDoc = [];
                        resultado.ResultDataSource.Data[0].EntidadesTipoDoc.push(item[i].Descricao);
                    }
                }

                ComboBoxSetDataSource(combo, resultado.ResultDataSource.Data[0]);
                combo.dataItem(combo.select(0));
                combo.trigger('change');
                // PARA ATIVAR O DIRTY
                combo.element.change();
            }
        });
    };

    self.DadosHTPermissoes = function () {
        var constTipoCompoHT = base.constantes.ComponentesHT;

        var inDadosHT = [
            {
                ID: 'Descricao',
                Label: "",
                readOnly: true
            },
            {
                ID: 'Consultar',
                Label: '<input class="htCheckboxRendererInput" autocomplete="off" type="checkbox" onClick="TiposDocumentoSeriesHTHeaderClick(this, 1)">  ' + resources['Consultar'],
                TipoEditor: constTipoCompoHT.F3MCheckBox
            }]

        if (constApp.toLowerCase() !== 'prisma') {
            inDadosHT.push(
                {
                    ID: 'Alterar',
                    Label: '<input class="htCheckboxRendererInput" autocomplete="off" type="checkbox" onClick="TiposDocumentoSeriesHTHeaderClick(this, 2)">  ' + resources['Alterar'],
                    TipoEditor: constTipoCompoHT.F3MCheckBox,
                },
                {
                    ID: 'Adicionar',
                    Label: '<input class="htCheckboxRendererInput" autocomplete="off" type="checkbox" onClick="TiposDocumentoSeriesHTHeaderClick(this, 3)">  ' + resources['Adicionar'],
                    TipoEditor: constTipoCompoHT.F3MCheckBox
                },
                {
                    ID: 'Remover',
                    Label: '<input class="htCheckboxRendererInput" autocomplete="off" type="checkbox" onClick="TiposDocumentoSeriesHTHeaderClick(this, 4)">  ' + resources['Remover'],
                    TipoEditor: constTipoCompoHT.F3MCheckBox
                });
        }

        return inDadosHT;
    };

    self.ConstroiHTPermissoes = function () {

        var objetoFiltro = [];
        var UrlAux = window.location.pathname.replace('/IndexGrelha', '') + 'Series/GrelhaExcel';

        objetoFiltro['IDSerie'] = parseInt($('#div_Results').find('.active').attr('id'));
        var dadosJSON = JSON.stringify(HandsonTableEnviaParamsHT(objetoFiltro));


        UtilsChamadaAjax(UrlAux, true, dadosJSON,
            function (res) {


                if ($('#AcaoFormSeries').val() == constEstados.Adicionar) {
                    var aux = res.Data

                    $.grep(aux, function (o, i) {
                        //  if (o.IDPerfis == $('#IDPerfil').val()) {
                        o.Consultar = true
                        o.Alterar = true
                        o.Adicionar = true
                        o.Remover = true
                        //}
                        return o;
                    });
                }

                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    var gridHT = HandsonTableDesenhaNovo('grelhaPermissoes', res.Data, null, self.DadosHTPermissoes(), false, null, null);
                    gridHT.updateSettings({
                        columnSorting: false,
                        height: parseInt($($('#' + 'grelhaPermissoes').children()[0]).find('.htCore').css('height').replace('px', '')),
                        afterChange: function (changes, source) {
                            if (source === constSourceHT.Edit) {
                                GrelhaFormAtivaDesativaBotoesAcoes(constGFTDS, true);
                                var grid = KendoRetornaElemento($('#' + constGFTD));
                                self.AtivaDesativaCabecalhoBtsFormTD(grid, true);
                            }
                        }
                    });
                    HandsonTableStretchHTWidthToContainer();
                }
                else {
                    var msg = res.Errors[0].Mensagem;
                    UtilsAlerta(base.constantes.tpalerta.error, msg);
                }
            },
            function () { return false; }, 1, true);
    };

    self.TiposDocumentoSeriesHTHeaderClick = function (chk, colIndex) {
        var IDhdsn = 'grelhaPermissoes';
        var chkval = $(chk).is(':checked');
        var hdsn = window.HotRegisterer.getInstance(IDhdsn);
        var hdsnDataLen = hdsn.getData().length;

        for (var i = 0; i < hdsnDataLen; i++) {
            hdsn.setDataAtCell(i, colIndex, chkval);
        }

        var newColHeaders = hdsn.getColHeader();
        (chkval) ? newColHeaders[colIndex] = self.AdicionaChecked(newColHeaders[colIndex], true) : newColHeaders[colIndex] = self.AdicionaChecked(newColHeaders[colIndex], false);
        hdsn.updateSettings({ colHeaders: newColHeaders });
        hdsn.render();
    };

    self.AdicionaChecked = function (inStr, inChecked) {
        try {
            if (inChecked) {
                return inStr.replace('type="checkbox"', 'type="checkbox" checked="checked" ')
            } else {
                return inStr.replace('checked="checked"', '');
            }
        } catch (ex) {
            throw ex;
        }
    };

    self.PreencheViewFromData = function (data, boolDuplica) {
        if (boolDuplica == undefined) {
            $('#CodigoSerie').val(data.CodigoSerie);
        }
        else {
            $('#CodigoSerie').val('');
        }

        $('#BlnTemDocAssoc').val(data.BlnTemDocAssoc);
        $('#DescricaoSerie').val(data.DescricaoSerie);
        self.TrataChecks('AtivoSerie', data.AtivoSerie);

        if ($('#SeriePorDefeito').val() == data.CodigoSerie) {
            self.TrataChecks('SugeridaPorDefeito', true);
        }
        else {
            self.TrataChecks('SugeridaPorDefeito', false);
        }

        self.TrataChecks('CalculaComissoesSerie', data.CalculaComissoesSerie);
        self.TrataChecks('AnalisesEstatisticasSerie', data.AnalisesEstatisticasSerie);
        self.TrataChecks('IVAIncluido', data.IVAIncluido);
        self.TrataChecks('IVARegimeCaixa', data.IVARegimeCaixa);

        //$('#DataInicial').val(data.DataInicial);
        //$('#DataFinal').val(data.DataFinal);
        //KendoRetornaElemento($('#NumUltimoDoc')).value(data.NumUltimoDoc);
        //$('#DataUltimoDoc').val(data.DataUltimoDoc);

        KendoRetornaElemento($('#IDSistemaTiposDocumentoOrigem')).value(data.IDSistemaTiposDocumentoOrigem);
        KendoRetornaElemento($('#IDParametrosEmpresaCAE')).value(data.IDParametrosEmpresaCAE);
        KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao')).value(data.IDSistemaTiposDocumentoComunicacao);
        KendoRetornaElemento($('#IDMapasVistas')).value(data.IDMapasVistas);
        KendoRetornaElemento($('#NumeroVias')).value(data.NumeroVias);

        //11-06-2018 - GN PASSOU A SER POSSIVEL ESCOLHER A LOJA NO PRISMA
        var _elemLoja = KendoRetornaElemento($('#IDLoja'));
        if (UtilsVerificaObjetoNotNullUndefined(_elemLoja)) {
            _elemLoja.value(data.IDLoja);
        }

        var gridHT = HandsonTableDesenhaNovo('grelhaPermissoes', data.TiposDocumentoSeriesPermissoes, null, self.DadosHTPermissoes(), false, null, null);
        gridHT.updateSettings({
            columnSorting: false,
            height: parseInt($($('#' + 'grelhaPermissoes').children()[0]).find('.htCore').css('height').replace('px', '')),
            afterChange: function (changes, source) {
                if (source === constSourceHT.Edit) {
                    GrelhaFormAtivaDesativaBotoesAcoes(constGFTDS, true);
                    var grid = KendoRetornaElemento($('#' + constGFTD));
                    self.AtivaDesativaCabecalhoBtsFormTD(grid, true);
                }
            }
        });

        $(btsAdiciona).addClass('invisivel');
        $(btsEdita).removeClass('invisivel').addClass('disabled');
        $(btsCrud).removeClass('invisivel');
        $(btDuplica).removeClass('invisivel');

        //self.TrataDataUltimoDoc();
    };

    self.TrataChecks = function (chk, bool) {
        bool == true ? $('#' + chk).attr('checked', 'checked').prop('checked', true) : $('#' + chk).removeAttr('checked').prop('checked', false);
    };

    self.RefreshTreeAfterInsert = function () {
        if ($('#div_Results').css('display') == 'none') {
            $('#OpcaoSeries').removeClass("col-12").addClass("col-10");
            $('#div_Results').show();

            var tabPerm = $('#OpcaoSeries').find('.clsF3MTabs a[href=#tabPermissoes]');
            if (tabPerm.length > 0) {
                var oblipai = tabPerm.closest('li');
                if (oblipai.length > 0) {
                    if (oblipai.hasClass('active')) {
                        if ($('#grelhaPermissoes').hasClass('handsontable')) {
                            HandsonTableStretchHTHeight('grelhaPermissoes', 50);
                            HandsonTableStretchHTWidthToContainer();
                        }
                    }
                }
            }

        }
    };

    self.RefreshTreeAfterRemove = function () {
        var numberOfItems = $('.list-group').children().length;

        if (numberOfItems == 0) {
            $('#OpcaoSeries').removeClass("col-10").addClass("col-12");
            $('#div_Results').hide();
            TiposDocumentoTrataViewSeries(0);
        }
        else {
            $($('.list-group').children()[0]).click();
        }
    };

    self.VerificaAdicionadas = function () {
        var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
        ATIVO = (isNaN($('#div_Results').find('.active').attr('id'))) ? $('#div_Results').find('.active').attr('id') : ATIVO;
        var addedSeries = TiposDocumentoRetornaObjetoSeries().SeriesAdicionadas
        var result = null;

        for (var i = 0; i < addedSeries.length; i++) {

            if (addedSeries[i].CodigoSerie == ATIVO) {
                result = addedSeries[i];
                break;
            }
        }

        return result;
    };

    self.ValidaExpressaoRegularSerie = function (CodigoSerie) {
        var flag = true
        if (!ValidaisValidSerie(CodigoSerie)) {
            flag = false;
        }
        return flag;
    };

    self.ValidaCodigoSerie = function (CodigoSerie) {
        var numberOfItems = $('.list-group').children().length;
        var flag = true;

        for (var i = 0; i < numberOfItems; i++) {
            if ($('.list-group').children()[i].text == CodigoSerie && $($('.list-group').children()[i]).hasClass('active') == false) {
                flag = false;
                break;
            }
        }

        return flag;
    };

    //self.ValidaDatasInicialFinal = function () {
    //    var dataInicial = $('#DataInicial').val();
    //    var dataFinal = $('#DataFinal').val();
    //    var flag = true;

    //    if (dataInicial != '' && dataFinal != '') {
    //        flag = KendoRetornaElemento($('#DataFinal')).value() > KendoRetornaElemento($('#DataInicial')).value() ? true : false;
    //    }
    //    return flag;
    //};

    self.AtivaDesativaCabecalhoBtsFormTD = function (grid, bool) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(grid)) {
            var gridID = grid.element.attr('id');
            var gridBtsElem = $('#' + gridID + cssClassBts);
            var btRepoe = gridBtsElem.find('.' + btClassRepoe);
            var valorEdicao = $('#EmExecucao').val();

            if (valorEdicao === '0') {
                if (UtilsVerificaObjetoNotNullUndefinedVazio($(btsAcoesAdicionar))) {
                    if (bool) {
                        $(btsAcoesAdicionar).addClass(btClassDisabled);
                    }
                    else {
                        $(btsAcoesAdicionar).removeClass(btClassDisabled);
                    }
                }
            }
            else if (valorEdicao === '1') {
                if (UtilsVerificaObjetoNotNullUndefinedVazio($(btsEditaGeral))) {
                    if (bool) {
                        $(btsEditaGeral).addClass('disabled');
                        gridBtsElem.find('.btsCRUD').addClass(btClassDisabled);
                    }
                    else {
                        $(btsEditaGeral).removeClass('disabled');
                        gridBtsElem.find('.btsCRUD').removeClass(btClassDisabled);
                        btRepoe.addClass(btClassDisabled);
                    }
                }
            }
        }
    };

    //self.TrataDataUltimoDoc = function () {
    //    var campoDataUltimoDoc = '#DataUltimoDoc';
    //    var dtmUltimoDoc = KendoRetornaElemento($(campoDataUltimoDoc));
    //    var dtmUltimoDocParent = $(campoDataUltimoDoc).parent();
    //    var winErrors = $('#' + msgErroID).data('kendoWindow');

    //    if ($('#NumUltimoDoc').val() != '') {
    //        dtmUltimoDocParent.addClass('obrigatorio');
    //        dtmUltimoDoc.element.addClass('obrigatorio');
    //        dtmUltimoDoc.element.attr(constRequired, constRequired);
    //        dtmUltimoDoc.enable(true);
    //    }
    //    else {
    //        dtmUltimoDocParent.parent().find('.input-error').removeClass('input-error');
    //        dtmUltimoDocParent.parent().find('.obrigatorio').removeClass('obrigatorio');
    //        dtmUltimoDoc.element.removeClass('k-invalid');
    //        dtmUltimoDoc.element.removeAttr(constRequired);
    //        dtmUltimoDoc.enable(false);
    //        dtmUltimoDoc.value('');
    //    }

    //    if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
    //        if (winErrors.options.visible == true) {
    //            GrelhaUtilsValida($('.' + constFormularioPrincipal));
    //        }
    //    }
    //};


    self.OrigemEsteSistemaAsDefault = function (e) {
        $('#AcaoFormSeries').val() == 0 ? e.sender.select(1) : false;
    };

    self.TrataChecksValoresPorDefeito = function () {
        if ($('#AcaoFormSeries').val() == 0) {
            self.TrataChecks('IVAIncluido', true);
            if (MODULO == Modulo.Vendas && $('#IDLoja').length == 0) {
                $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
            }
            self.TrataChecks('IVARegimeCaixa', false);
            $('#SeriePorDefeito').val() != '' ? self.TrataChecks('SugeridaPorDefeito', false) : false;
        }

        if ($('#EmExecucao').val() == 0 && $('#SeriePorDefeito').val() == '') {
            self.TrataChecks('SugeridaPorDefeito', true);
        }
    };

    self.CaeEnviaParams = function (objetoFiltro) {
        //var IDEmpresa = $(window.parent.$('.emp-ano')[0]).text();
        //var elemAux = $('#' + campoID);
        //var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoID);

        //GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDEmpresa');

        //return objetoFiltro
    };

    self.OnSplitterResizeHT = function (e) {
        setTimeout(function () {
            HandsonTableStretchHTWidthToContainer();
        }, 100);
    };

    self.AtivoSerieClique = function (e) {
        var chkval = $('#AtivoSerie').is(':checked');
        if (chkval == false) {
            self.TrataChecks('SugeridaPorDefeito', false);
        }
    };

    self.BloqueiaBotao = function (combo) {

        var dtItem = combo.dataItem();

        if (dtItem && (dtItem['MapaBin'] || dtItem['MapaXML'])) {
            $('#elemFloatingDocumentoBt').removeClass('disabled');

        }
        else {
            $('#elemFloatingDocumentoBt').addClass('disabled');
        }
    }

    return parent;

}($tiposdocumentoseries || {}, jQuery));

var TiposDocumentoSeriesInit = $tiposdocumentoseries.ajax.Init;
var TiposDocumentosRetornaModeloTiposDocumentosSeries = $tiposdocumentoseries.ajax.RetornaModeloTiposDocumentosSeries;
var TiposDocumentosRetornaObjetosSeries = $tiposdocumentoseries.ajax.RetornaObjetosSeries;
var TiposDocumentoSeriesHTHeaderClick = $tiposdocumentoseries.ajax.TiposDocumentoSeriesHTHeaderClick;
var OrigemEsteSistemaAsDefault = $tiposdocumentoseries.ajax.OrigemEsteSistemaAsDefault;

//var TiposDocumentoSeriesTrataDataUltimoDoc = $tiposdocumentoseries.ajax.TrataDataUltimoDoc;
var CaeEnviaParams = $tiposdocumentoseries.ajax.CaeEnviaParams;
var TiposDocumentoSeriesAcoesClickEditadas = $tiposdocumentoseries.ajax.AcoesClickEditadas;

//new
var BloqueiaBotoes = $tiposdocumentoseries.ajax.BloqueiaBotao

$(document).ready(function (e) {

    TiposDocumentoSeriesInit();
});