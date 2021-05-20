"use strict";

var $artigos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constCamposGen = base.constantes.camposGenericos;
    var campoID = constCamposGen.ID;
    var campoDesc = constCamposGen.Descricao;
    var campoArtID = constCamposGen.IDArtigo;
    var campoEmExec = constCamposGen.IDEmExecucao;

    var constClasses = base.constantes.classes;
    var constClassObr = constClasses.F3MObrigatorio;
    var constClassSemAcesso = constClasses.F3MSemAcesso;
    var cssClassKendoInval = constClasses.F3MKendoInvalido;
    var constClassInputError = constClasses.F3MInputError;
    var constClassFormPrinc = constClasses.FormPrinc;
    var constDisabled = base.constantes.grelhaBotoesCls.Disabled;

    var constTipoCompo = base.constantes.tiposComponentes;
    var cssClassG = constTipoCompo.grelha;
    var cssClassGL = constTipoCompo.grelhaLinhas;
    var cssClassBts = constTipoCompo.grelhaBotoes;

    var constEstados = base.constantes.EstadoFormEAcessos;
    var estadoAdicionar = constEstados.Adicionar;

    var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;

    var constIDsBts = base.constantes.grelhaBotoesIDs;
    var btIDAdd = constIDsBts.Adicionar;
    var btIDEdit = constIDsBts.Alterar;
    var btIDRemove = constIDsBts.Remover;
    var btIDCancelar = constIDsBts.Cancelar;
    var btIDGuardarFecha = constIDsBts.GuardarFecha;

    var constRequired = base.constantes.grelhaBotoesCls.Required;
    var msgErroID = base.constantes.janelasPopupIDs.Erro;

    var gridID = 'F3MGrelhaFormArtigos';
    var colocarGrelhaClass = 'ColocarGrelha';
    var tipoDimensaoID = 'IDTipoDimensao';
    var dimensaoPrimeiraID = 'IDDimensaoPrimeira';
    var dimensaoSegundaID = 'IDDimensaoSegunda';
    var tituloFiosID = 'divTituloFios';
    var SistemaFioID = 'SistemaFio';
    var codSistemaTipoArtigoID = 'CodigoSistemaTipoArtigo';
    var campoFamiliaID = "IDFamilia";
    var campoArmazemID = "IDArmazem";
    var campoIDTtiposComponente = "IDTiposComponente";
    var campoIDCompostoTransformacaoMetodoCusto = "IDCompostoTransformacaoMetodoCusto";

    var campoValorComIva = "ValorComIva";
    var campoValorSemIva = "ValorSemIva";
    var campoTaxaIva = "TaxaIVA";
    var campoUPCPercentagem = "UPCPercentagem";
    var campoUltimoPrecoCusto = "UltimoPrecoCusto";
    var campoPadraoPercentagem = "PadraoPercentagem";
    var campoPadrao = "Padrao";
    var gridArtigosPrecos = "F3MGrelhaArtigosPrecos";
    var campoIDTaxa = "IDTaxa";
    var campoIDDuplica = "IDDuplica";

    var objhdfControla2UndStock = '#hdfControla2UndStock';
    var objhdfExistemMovimentosStock = '#hdfExistemMovimentosStock';

    var taxaIVA = null;
    var ValorPadrao = null;
    var TiposCalculos = {
        CalculoComIVA: 1,
        CalculoSemIVA: 2,
        CalculoPercentagem: 3,
        CalculoPercentagemPadrao: 4
    };

    var classeArtigo = {
        OculosSol: 'OS',
        Aros: 'AR',
        LentesContato: 'LC',
        LentesOftalmicas: 'LO'
    };

    var EDITOU = false;
    var EDITOU_MODELO = false;
    var EDITOU_CODIGO = false;

    var LOS = [];

    self.Init = function () {
        // BOTOES LATERAIS 
        $('.AsideIconsPosition').on('click', function (e) {
            self.CliqueBotaoLateral(e);
        });

        // TABS
        $('.clsF3MTabs a[role=tab]').on('click', function (e) {
            self.CliqueTab(e);
        });
        self.EnableOrDisableTabs($('#GereStock').is(':checked'), ($('#GereLotes').is(':checked')));

        $('#classe').val() != undefined ? self.CarregaPartials($('#classe').val()) : false;

        var fn = window['UtilsObservacoesTrataEspecifico'];
        if (typeof (fn) === 'function') {
            UtilsObservacoesTrataEspecifico("tabObservacoes", "Observacoes");
        }
        $("#Codigo").on("input", function () {
            EDITOU_CODIGO = true;
        })

        $('#Padrao').on('change', function (e) {
            self.PadraoChange(e);
        });

        self.unbindCrudEvents();

        //ESTE TIMEOUT É PARA AO ADICONAR FAZER O OPEN DA COMBO DOS TIPOS DE ARTIGO
        setTimeout(function () {
            if ($('#' + campoEmExec).val() === constEstados.Adicionar) {
                if (!UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoIDDuplica).val())) {
                    KendoRetornaElemento($('#IDTipoArtigo')).open();
                }
            }
        }, 100);
    };

    self.Acoes = function (elemBtID) {
        var valorID = null;
        var formulario = $('#F3MGrelhaFormArtigosForm');
        var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));
        var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
        var gridID = 'F3MGrelhaFormArtigos';

        switch (elemBtID) {
            case constIDsBts.GuardarFecha2:
            case constIDsBts.GuardarFecha:
            case constIDsBts.GuardarCont:
            case constIDsBts.Guardar:
                if (boolModel) {



                    var grid = $('#F3MGrelhaFormArtigos').data('kendoGrid');
                    var modeloForm = grid.dataItem(grid.select());
                    if (modeloForm) {
                        valorID = (UtilsVerificaObjetoNotNullUndefinedVazio(modeloForm[campoID])) ? modeloForm[campoID] : null;
                    }

                    model.ArtigosLentesOftalmicasSuplementos = [];
                    var count = $('#partialLentesOftalmicasSuplementos').find('.checkbox').length;

                    for (var i = 0; i < count; i++) {
                        var obj = {
                            IDSuplementoLente: $($('#partialLentesOftalmicasSuplementos').find('.checkbox')[i]).find('.supsClass').attr('id'),
                            Checked: $($('#partialLentesOftalmicasSuplementos').find('.checkbox')[i]).find('.supsClass').attr('checked') == 'checked' ? true : false
                        }
                        model.ArtigosLentesOftalmicasSuplementos.push(obj);
                    }
                    var options = grid.dataSource.transport.options;
                    var url = (valorID !== null && valorID > 0) ? options.update.url : options.create.url;
                    self.Valida(grid, url, model, elemBtID);
                }

                break;
        }
    };

    self.Valida = function (inGrelha, inURL, inModelo, inElemBtID) {
        var formulario = $('#F3MGrelhaFormArtigosForm');
        var gridID = inGrelha.element.attr('id');
        var urlNovo = $('#' + gridID + 'Form form').attr('action').split('?')[0];

        if (GrelhaUtilsValidaEspecifica(inGrelha, inModelo, urlNovo)) { // && self.errosCount(inGrelha) == 
            GrelhaUtilsValidaEGrava(inGrelha, formulario, urlNovo, inModelo, inElemBtID, self.ValidaEGravaSucesso, null);
        }
    };

    self.ValidaEGravaSucesso = function (resultado, inGrelha, inURL, inElemBtID, modeloLinha) {
        GrelhaFormValidaEGravaSucesso(resultado, inGrelha, inURL, inElemBtID, modeloLinha);
        UtilsBloquearElementos(inGrelha.element, false, true);
    };

    // ENVIO DE IDARTIGO PARA O DATASOURCE DAS GRELHAS DE LINHAS NO ARTIGO
    self.EnviaParametros = function (objetoFiltro) {
        // Mostra labels dos botoes adicionar para os Stocks e Unidades
        if (!$('#F3MGrelhaArtigosArmazensLocalizacoesBtAdd .label-btn-acoes > span').length) {
            $('#F3MGrelhaArtigosArmazensLocalizacoesBtAdd').append('<div class=label-btn-acoes> <span>' + resources.Adicionar + '</span><br><span>' + resources.Armazem + '</span></div>');
        }
        if (!$('#F3MGrelhaArtigosUnidadesBtAdd .label-btn-acoes > span').length) {
            $('#F3MGrelhaArtigosUnidadesBtAdd').append('<div class=label-btn-acoes> <span>' + resources.Adicionar + '</span><br><span>' + resources.Unidade + '</span></div>');
        }

        var elemAux = $('#' + campoID);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoID);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoArtID);

        //idfAMILIA
        elemAux = $('#' + campoFamiliaID);
        elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoFamiliaID);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true);

        //IDDuplica
        elemAux = $('#' + campoIDDuplica);
        elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDDuplica);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true);
        return objetoFiltro
    };

    // FUNCAO COMBO CHANGE ESPECIFICA PARA IDTIPOARTIGO
    self.IDTipoArtigoComboChange = function (combo) {
        var classe = '';
        var codigo = '';

        if (UtilsVerificaObjetoNotNullUndefined(combo)) {
            classe = combo.selectedIndex != -1 ? combo.dataItem().CodigoSistemaTipoArtigo : '';
            codigo = combo.selectedIndex != -1 ? combo.dataItem().Codigo : '';
            EDITOU = true;
            self.CarregaPartials(classe);
            if ($('#ParametroArtigoCodigo').val().toLowerCase() == 'true') {

                if (EDITOU_CODIGO == false) {
                    self.CliqueLoadOpcao(window.location.pathname.replace('IndexGrelha', '') + '/ProximoCodigo', codigo, 'Codigo');
                }
            }
        }
        $('#hdfIDTipoArtigo').val($('#IDTipoArtigo').val());
    };

    self.CarregaPartials = function (classe) {

        var urlAux = window.location.pathname.replace('/IndexGrelha', '');
        var dataAux = {};
        var winErrors = $('#' + msgErroID).data('kendoWindow');

        if (classe == classeArtigo.OculosSol) {
            urlAux += 'OculosSol';
        }
        else if (classe == classeArtigo.Aros) {
            urlAux += 'Aros';
        }
        else if (classe == classeArtigo.LentesContato) {
            urlAux += 'LentesContato'
        }
        else if (classe == classeArtigo.LentesOftalmicas) {
            urlAux += 'LentesOftalmicas'
        }
        else {
            urlAux += '/EmptyPartial'
        }

        if (classe == classeArtigo.Aros || classe == classeArtigo.OculosSol || classe == classeArtigo.LentesContato || classe == classeArtigo.LentesOftalmicas) {
            if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoIDDuplica).val())) {
                dataAux = {
                    AcaoForm: 0,
                    vistaParcial: false,
                    IDArtigo: $('#' + campoIDDuplica).val()
                }
            }
            else {
                dataAux = {
                    AcaoForm: $('#EmExecucao').val(),
                    vistaParcial: false,
                    IDArtigo: EDITOU == true ? '' : $('#ID').val()
                }
            }
        }

        UtilsChamadaAjax(urlAux, true, dataAux,
            function (res) {
                if (res != undefined && res != null) {

                    var elem = $('#partialDiv');
                    elem.html(res);



                    if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
                        if (winErrors.options.visible == true) {
                            GrelhaUtilsValida($('.' + 'FormularioPrincipal'));
                        }
                    }

                    if (classe == classeArtigo.Aros || classe == classeArtigo.OculosSol || classe == classeArtigo.LentesContato || classe == classeArtigo.LentesOftalmicas) {
                        (KendoRetornaElemento($('#IDMarca')).value() == '' || $('#EmExecucao').val() != 0) ? KendoRetornaElemento($('#IDModelo')).enable(false) : KendoRetornaElemento($('#IDModelo')).enable(true);

                        if (EDITOU == true && classe == classeArtigo.LentesOftalmicas) {
                            KendoRetornaElemento($('#IDTratamentoLente')).enable(false);
                            KendoRetornaElemento($('#IDCorLente')).enable(false);
                        }
                    }
                }

                if (classe == classeArtigo.LentesOftalmicas && KendoRetornaElemento($('#IDModelo')).value() != '') {
                    self.CarregaSuplementos();
                }

                var dto = GrelhaFormDTO($('#partialDiv'));
                var modeloForm = GrelhaUtilsGetModeloForm(dto);

                GrelhaUtilsAplicaDirty(modeloForm, dto, 'F3MGrelhaFormArtigos');
                ComboBoxAbrePopup();


                $('#IDMarca').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#IDModelo').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#CodigoCor').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#Tamanho').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#IDTratamentoLente').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#IDCorLente').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#Diametro').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#PotenciaEsferica').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#PotenciaCilindrica').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#Adicao').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#Raio').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });
                $('#Eixo').on('blur', function (ex) {
                    self.AtualizaDescricao();
                });


            }, function (fv) {
            }, 1, true, null, null, 'html', 'GET');


    };


    self.CarregaSuplementos = function () {
        var urlAux = window.location.pathname.replace('/IndexGrelha', '') + 'LentesOftalmicasSuplementos';
        var dataAux = {};

        dataAux = {
            AcaoForm: $('#EmExecucao').val(),
            vistaParcial: false,
            IDModelo: KendoRetornaElemento($('#IDModelo')).value(),
            IDLO: EDITOU_MODELO == true ? '' : $('#IDLenteOftalmica').val()
        };

        UtilsChamadaAjax(urlAux, true, dataAux,
            function (res) {
                if (res != undefined && res != null) {
                    var elem = $('#partialLentesOftalmicasSuplementos');
                    elem.html(res);

                    $('.supsClass').change(function () {

                        if ($(this).is(":checked") == true) {
                            $(this).attr('checked', 'checked');
                        } else {
                            $(this).removeAttr('checked');
                        }
                        GrelhaFormAtivaDesativaBotoesAcoes('F3MGrelhaFormArtigos', true);

                        self.AtualizaDescricao();
                    });

                    if ($('#EmExecucao').val() != 0) {
                        elem.find('.checkbox').addClass('disabled');
                        elem.find('.supsClass').attr('disabled', 'disabled')
                    }

                }
            }, function (fv) {
            }, 1, true, null, null, 'html', 'GET');
    };

    self.ArmazensIDArmazemChange = function (combo) {
        if (UtilsVerificaObjetoNotNullUndefined(combo)) {
            var grid = combo.element.parents('.' + cssClassGL).data('kendoGrid');
            var gridSel = GrelhaRetornaInputsLinha(grid);
            var model = grid.dataItem(gridSel);
            var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
            var campoIDArmLoc = 'IDArmazemLocalizacao';

            if (combo.selectedIndex >= 0) {
                if (UtilsVerificaObjetoNotNullUndefined(combo.dataItem(combo.selectedIndex))) {
                    self.TrataCascadeeTemAcesso(grid, false);
                }
                else {
                    gridSel.find('#' + campoIDArmLoc).val('');
                    if (boolModel) {
                        model[campoIDArmLoc] = '';
                    }
                    self.TrataCascadeeTemAcesso(grid, false);
                }
            }
            else {
                gridSel.find('#' + campoIDArmLoc).val('');
                if (boolModel) {
                    model[campoIDArmLoc] = '';
                }
                self.TrataCascadeeTemAcesso(grid, false);
            }
        }
    }

    self.ArmazensEdit = function (grid, e) {
        //$("#IDArmazemIncluir").val(parseInt($("#IDArmazem").data("kendoComboBox").value()));
        var armaKendo = KendoRetornaElemento($('#' + campoArmazemID));
        var armaPaiKendo = KendoRetornaElemento(window.parent.$('#' + campoArmazemID));

        if (UtilsVerificaObjetoNotNullUndefined(grid) && UtilsVerificaObjetoNotNullUndefined(armaPaiKendo)) {
            var modeloEdicao = grid.dataItem(grid.select())
            if (UtilsVerificaObjetoNotNullUndefinedVazio(modeloEdicao)) {
                if (modeloEdicao.ID != 0) {
                    self.ArmazensLocalizacoesGrelhaDataBound(e);
                }
            }
            var modeloLinha = GrelhaRetornaModeloLinha(grid);
            modeloLinha.IDArmazem = armaPaiKendo.value();
            modeloLinha.DescricaoArmazem = armaPaiKendo.text();
            if (UtilsVerificaObjetoNotNullUndefined(armaKendo)) {
                ComboBoxSetValorTexto(armaKendo, armaPaiKendo.value(), armaPaiKendo.text());
            }
        }
        else {
            self.TrataCascadeeTemAcesso(grid, true);
        }
    }

    self.ArmazensLocalizacoesGrelhaDataBound = function (e) {
        GrelhaDataBound(e);
        var grid = e.sender;
        var armaPaiKendo = KendoRetornaElemento(window.parent.$('#' + campoArmazemID));
        var armaPaiKendoValor = armaPaiKendo.value();
        if (UtilsVerificaObjetoNotNullUndefined(armaPaiKendo) && UtilsVerificaObjetoNotNullUndefined(armaPaiKendoValor)) {
            var arrColuna = [campoArmazemID];
            GrelhaUtilsEscondeColunas(true, grid, arrColuna);
        }
    }

    self.SubFamiliasEdit = function (grid, e) {
        var modeloEdicao = grid.dataItem(grid.select())
        if (UtilsVerificaObjetoNotNullUndefinedVazio(modeloEdicao)) {
            if (modeloEdicao.ID != 0) {
                self.SubFamiliaDataBound(e);
            }
        }
        var subFamiliaKendo = KendoRetornaElemento($('#' + campoFamiliaID));
        var subFamiliaPaiKendo = KendoRetornaElemento(window.parent.$('#' + campoFamiliaID));

        if (UtilsVerificaObjetoNotNullUndefined(subFamiliaPaiKendo) && UtilsVerificaObjetoNotNullUndefined(grid)) {
            var modeloLinha = GrelhaRetornaModeloLinha(grid);
            modeloLinha.IDFamilia = subFamiliaPaiKendo.value();
            modeloLinha.DescricaoFamilia = subFamiliaPaiKendo.text();
            if (UtilsVerificaObjetoNotNullUndefined(subFamiliaKendo)) {
                ComboBoxSetValorTexto(subFamiliaKendo, subFamiliaPaiKendo.value(), subFamiliaPaiKendo.text());
            }
        }
    }

    self.SubFamiliaDataBound = function (e) {
        GrelhaDataBound(e);
        var grid = e.sender;
        var subFamiliaPaiKendo = KendoRetornaElemento(window.parent.$('#' + campoFamiliaID));
        var subFamiliaValor = subFamiliaPaiKendo.value();
        if (UtilsVerificaObjetoNotNullUndefined(subFamiliaPaiKendo) && UtilsVerificaObjetoNotNullUndefined(subFamiliaValor)) {
            var arrColuna = [campoFamiliaID];
            GrelhaUtilsEscondeColunas(true, grid, arrColuna);
        }
    }

    self.PrecosEdit = function (grid, e) {
        //if (e.model.IDAPUnidade == 0) {
        //    var editRow = grid.element.find(".k-grid-edit-row");
        //    var gridItem = grid.dataItem(editRow);
        //    var cmbUnidade = KendoRetornaElemento(grid.element.find(".k-grid-edit-row").find("#IDAPUnidade"));
        //    var cmbUnidadeVenda = KendoRetornaElemento($("#IDUnidadeVenda"));

        //    gridItem.DescricaoAPUnidade = cmbUnidadeVenda.text();
        //    gridItem.IDAPUnidade = cmbUnidadeVenda.value();
        //    cmbUnidade.value(cmbUnidadeVenda.value());
        //    cmbUnidade.text(cmbUnidadeVenda.text());
        //}

        $('#' + campoValorComIva).on('blur', function (ex) {
            self.Calculos(e.model, TiposCalculos.CalculoComIVA);
        });

        $('#' + campoValorSemIva).on('blur', function (ex) {
            self.Calculos(e.model, TiposCalculos.CalculoSemIVA);
        });

        $('#' + campoUPCPercentagem).on('blur', function (ex) {
            self.Calculos(e.model, TiposCalculos.CalculoPercentagem);
        });

        $('#' + campoPadraoPercentagem).on('blur', function (ex) {
            self.Calculos(e.model, TiposCalculos.CalculoPercentagemPadrao);
        });

        taxaIVA = UtilsVerificaObjetoNotNullUndefinedVazio($('#TaxaIVA').val()) == true ? parseFloat($('#TaxaIVA').val().replace(',', '.')) : 0;

        if (!KendoRetornaElemento($('#' + campoIDTaxa)).element.hasClass(base.constantes.classes.F3MSemAcesso)) {
            KendoRetornaElemento($('#' + campoIDTaxa)).enable(false);
        }

        $('#F3MGrelhaArtigosPrecosBtCancel').unbind('click');
        $('#F3MGrelhaArtigosPrecosBtCancel').on('click', function (ex) {
            self.CancelarGLPrecosEspecifica();
        });

        var campoUPC = KendoRetornaElemento($('#' + campoUltimoPrecoCusto));
        if (UtilsVerificaObjetoNotNullUndefinedVazio(campoUPC)) {
            var valueAux = campoUPC.value();
            if (valueAux == 0 || valueAux == null) {
                campoUPC.enable(false);
            }
            else {
                campoUPC.enable(true);
            }
        }

    }

    self.EnableTaxaIva = function () {
        if (!KendoRetornaElemento($('#' + campoIDTaxa)).element.hasClass(base.constantes.classes.F3MSemAcesso)) {
            KendoRetornaElemento($('#' + campoIDTaxa)).enable(true);
        }
    }

    self.CancelarGLPrecosEspecifica = function () {
        self.EnableTaxaIva();
        GrelhaLinhasAction(KendoRetornaElemento($('#' + gridArtigosPrecos)), base.constantes.grelhaBotoesIDs.Cancelar);
    }

    self.TrataCascadeeTemAcesso = function (grid, inEdit) {
        var gridSel = GrelhaRetornaInputsLinha(grid);
        var model = grid.dataItem(gridSel);
        var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
        var cmbLoc = KendoRetornaElemento($(gridSel.find('#IDArmazemLocalizacao')));
        var bloqueiaD1 = true;
        var valarm = model[campoArmazemID];
        // TODO: Corrigir isto (esta a dar erro na Grelha de linhas)
        if (UtilsVerificaObjetoNotNullUndefinedVazio(valarm)) {
            var cmbarti = KendoRetornaElemento($(gridSel.find('#' + campoArmazemID)));
            var cmbartiValor = cmbarti.value();
            if (valarm != cmbartiValor) {
                valarm = cmbartiValor;
            }
        }
        else {
            var cmbarti = KendoRetornaElemento($(gridSel.find('#' + campoArmazemID)));
            valarm = cmbarti.value();
        }

        if (UtilsVerificaObjetoNotNullUndefined(valarm)) {
            bloqueiaD1 = false;
        }

        if (!(cmbLoc.element.hasClass(base.constantes.classes.F3MSemAcesso))) {
            if (bloqueiaD1) {
                if (boolModel) {
                    model['IDArmazemLocalizacao'] = null;
                    model['DescricaoArmazemLocalizacao'] = '';
                }
                if (UtilsVerificaObjetoNotNullUndefined(cmbLoc)) {
                    cmbLoc.text('');
                    cmbLoc.select(-1);
                    cmbLoc.dataSource.data([]);
                    cmbLoc.enable(false);
                }
            }
            else {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(valarm)) {
                    if (UtilsVerificaObjetoNotNullUndefined(cmbLoc)) {
                        cmbLoc.enable(true);
                        if (!inEdit && valarm != model.DescricaoArmazem) {
                            if (boolModel) {
                                model['IDArmazemLocalizacao'] = null;
                                model['DescricaoArmazemLocalizacao'] = '';
                            }
                            cmbLoc.text('');
                            cmbLoc.select(-1);
                            cmbLoc.dataSource.data([]);
                        }
                    }
                }
                else {
                    if (UtilsVerificaObjetoNotNullUndefined(cmbLoc)) {
                        if (!inEdit) {
                            if (boolModel) {
                                model['IDArmazemLocalizacao'] = null;
                                model['DescricaoArmazemLocalizacao'] = '';
                            }
                            cmbLoc.text('');
                            cmbLoc.select(-1);
                            cmbLoc.dataSource.data([]);
                        }
                        cmbLoc.enable(false);
                    }
                }
            }
        } else {
            //nao tem acesso
            if (bloqueiaD1) {
                if (boolModel) {
                    model['IDArmazemLocalizacao'] = null;
                    model['DescricaoArmazemLocalizacao'] = '';
                }
                if (UtilsVerificaObjetoNotNullUndefined(cmbLoc)) {
                    cmbLoc.text('');
                    cmbLoc.select(-1);
                    cmbLoc.dataSource.data([]);
                    cmbLoc.enable(false);
                }
            }
        }
    }

    // CLIQUE NOS BOTOES LATERAIS
    self.CliqueBotaoLateral = function (e) {
        e.preventDefault();
        try {
            var acao = '';
            var elem = $(e.currentTarget);
            var titulo = elem.find('a').text()
            var IDelem = elem.parents('form').find('#' + campoID);
            var IDelemCP = elem.parents('form').find('#Padrao');
            var IDArt = (IDelem.length) ? parseInt(IDelem.val()) : 0;
            var CP = (IDelemCP.length) ? parseInt(IDelemCP.val()) : 0;

            if (elem.hasClass('dimensoes')) acao = 'Dimensoes';
            else if (elem.hasClass('composicao')) acao = 'Composicoes';
            else if (elem.hasClass('artigos_ass')) acao = 'Associados';
            else if (elem.hasClass('artigos_alt')) acao = 'Alternativos';
            else if (elem.hasClass('anexos')) acao = 'Anexos';
            else if (elem.hasClass('especifico')) acao = 'Especificos';
            else if (elem.hasClass('componentes')) acao = 'Componentes';
            else if (elem.hasClass('configdimensoes')) acao = 'DimensoesLinhas';

            if (acao == 'Componentes' && $('.clsBtSaveFecha2.' + constDisabled).length == 0) {
                return UtilsConfirma(base.constantes.tpalerta.question, resources.deve_guardar_alteracoes, function () {
                    $gridutils.ajax.tabClick = "compContainer";
                    $('#' + gridID + base.constantes.grelhaBotoesIDs.GuardarFecha2).trigger('click');
                }, function () {
                    e.target.focus()
                    e.stopImmediatePropagation();
                    return false
                })
            }

            if (acao == 'Componentes' && KendoRetornaElemento($('#' + campoIDTtiposComponente)).value() == 1) {
                $('a[href="#tabDefinicao"]').trigger('click');
                return UtilsAlerta(base.constantes.tpalerta.i, resources.GrupoCompostoNaoDefinido);
            }

            // Caso seja Dimensoes ou Anexos tem que adicionar primeiro o artigo
            if (IDArt === 0 && (elem.hasClass('dimensoes') || elem.hasClass('anexos') || elem.hasClass('configdimensoes'))) {
                var grid = KendoRetornaElemento($("#" + gridID));

                if (!GrelhaUtilsEstaEmEdicao(grid)) {
                    IDelem = $('form').find('#' + campoID);
                    IDArt = (IDelem.length) ? parseInt(IDelem.val()) : 0;
                } else {
                    return UtilsAlerta(base.constantes.tpalerta.i, resources.tem_que_adicionar_artigo)
                }
            }
            // Caso seja Dimensoes tem que gravar primeiro o artigo
            else if ((elem.hasClass('dimensoes') || elem.hasClass('configdimensoes')) && $('.clsBtSaveFecha2.' + constDisabled).length == 0) {
                return UtilsConfirma(base.constantes.tpalerta.question, resources.deve_guardar_alteracoes, function () {
                    // DEFINE VARIAVEL COM CLASSE DA WINDOW PARA ABRIR DEPOIS DE GRAVAR O ARTIGO
                    if (elem.hasClass('configdimensoes')) {
                        $gridutils.ajax.tabClick = "configContainer";
                    } else {
                        $gridutils.ajax.tabClick = "dimContainer";
                    }
                    $('#' + gridID + base.constantes.grelhaBotoesIDs.GuardarFecha2).trigger('click');
                }, function () {
                    e.target.focus()
                    e.stopImmediatePropagation();
                    return false
                })
                //return UtilsAlerta(base.constantes.tpalerta.i, resources.deve_guardar_alteracoes);
            }

            // VALIDACAO DE ENTRADA NAS DIMENSOES
            //|| acao === 'Associados' || acao === 'Alternativos' || acao === 'Componentes'
            if ((acao === 'Dimensoes') || (acao === 'DimensoesLinhas')) {
                var cbTD = $("#" + tipoDimensaoID).data("kendoDropDownList");
                var cbTDVal = (cbTD !== undefined) ? parseInt(cbTD.value()) : 0;
                var cbDP = $("#" + dimensaoPrimeiraID).data("kendoComboBox");
                var cbDPVal = (cbDP !== undefined) ? parseInt(cbDP.value()) : 0;
                var cbDS = $("#" + dimensaoSegundaID).data("kendoComboBox");
                var cbDSVal = (cbDS !== undefined) ? parseInt(cbDS.value()) : 0;

                if (isNaN(cbTDVal) || cbTDVal <= 1 ||
                    (cbTDVal === 2 && isNaN(cbDPVal)) ||
                    (cbTDVal === 3 && (isNaN(cbDPVal) || isNaN(cbDSVal)))) {
                    $('a[href="#tabDefinicao"]').trigger('click')
                    return UtilsAlerta(base.constantes.tpalerta.i, resources.nao_existem_dimensoes)
                }

                if ((acao === 'Dimensoes') || (acao === 'DimensoesLinhas')) {
                    titulo = resources.titulo_artigos_dimensoes.replace('{0}', titulo).replace('{1}', $("#Codigo").val());
                }
            }

            var objData = new Object
            objData = self.RetornaObjetoData(objData, acao)
            objData[campoArtID] = IDArt
            objData.CustoPadrao = CP
            if (acao !== '') {
                var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
                if (acao === 'DimensoesLinhas') {
                    janelaMenuLateral = base.constantes.janelasPopupIDs.Submenu;
                }
                JanelaDesenha(janelaMenuLateral, objData, window.location.pathname + acao, acao, null);
            }
        } catch (e) {
            UtilsAlerta(base.constantes.tpalerta.i, e.message);
        }
        e.stopImmediatePropagation();
    }

    self.EnviaParametrosDimensoes = function (objetoFiltro) {
        var elemAux = $('#' + campoID);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoID);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoID);

        return objetoFiltro;
    };

    // CLIQUE NOS TABS
    self.CliqueTab = function (e) {
        var tabHref = $(e.currentTarget).attr('href');
        var tabHrefAux = tabHref.replace('#tab', '');
        var elem = $(tabHref).find('.' + colocarGrelhaClass);
        var clsEdita = '.editar2';
        var clsApaga = '.apagar2';
        var gridUnidades = '#F3MGrelhaArtigosUnidades';
        var gridIdiomas = '#F3MGrelhaArtigosIdiomas';
        var gridStocks = '#F3MGrelhaArtigosArmazensLocalizacoes';
        var gridLotes = '#F3MGrelhaArtigosLotes';
        var gridPrecos = '#F3MGrelhaArtigosPrecos';

        switch (tabHref) {
            case '#tabDefinicao':
                if ($('#AdicionaF4').length) {
                    self.initCheckBoxesDefinicaoArtigosF4();
                }
                else {
                    self.initCheckBoxesDefinicaoArtigos();
                }
                self.EnableOrDisableDropComposto();

                break;
            case '#tabArmazensLocalizacoes':
                if (gridStocks.length != 0) {
                    $(gridStocks + 'Bts').find($(clsEdita)).addClass('alterar_disabled').removeClass('editar2');
                    $(gridStocks + 'Bts').find($(clsApaga)).addClass('apagar_disabled').removeClass('apagar2');
                    $(gridStocks).find('.k-state-selected').removeClass('k-state-selected');
                }
                if (elem.length && elem.html() === '') {
                    if ($('#AdicionaF4').length) {
                        var urlAux = rootDir + "Artigos/Artigos" + tabHrefAux;
                    }
                    else {
                        var urlAux = window.location.pathname + tabHrefAux;
                    }
                    var dataAux = {
                        vistaParcial: true
                    };
                    UtilsChamadaAjax(urlAux, true, dataAux,
                        function (res) {
                            if (res != undefined && res != null) {
                                var tabHref = $('.clsF3MTabs a.active').attr('href');

                                if (tabHref !== undefined && tabHref !== '') {
                                    var elem = $(tabHref).find('.' + colocarGrelhaClass);

                                    elem.html(res);
                                }
                            }
                        }, function (fv) {
                        }, 1, true, null, null, 'html', 'GET');
                }
                break;
            case '#tabLotes':
                if (gridLotes.length != 0) {
                    $(gridLotes + 'Bts').find($(clsEdita)).addClass('alterar_disabled').removeClass('editar2');
                    $(gridLotes + 'Bts').find($(clsApaga)).addClass('apagar_disabled').removeClass('apagar2');
                    $(gridLotes).find('.k-state-selected').removeClass('k-state-selected');
                }
                if (elem.length && elem.html() === '') {
                    if ($('#AdicionaF4').length) {
                        var urlAux = rootDir + "Artigos/Artigos" + tabHrefAux;
                    }
                    else {
                        var urlAux = window.location.pathname + tabHrefAux;
                    }
                    var dataAux = {
                        vistaParcial: true
                    };
                    UtilsChamadaAjax(urlAux, true, dataAux,
                        function (res) {
                            if (res != undefined && res != null) {
                                var tabHref = $('.clsF3MTabs a.active').attr('href');

                                if (tabHref !== undefined && tabHref !== '') {
                                    var elem = $(tabHref).find('.' + colocarGrelhaClass);

                                    elem.html(res);
                                }
                            }
                        }, function (fv) {
                        }, 1, true, null, null, 'html', 'GET');
                }
                break;
            case '#tabPrecos':
                if (gridPrecos.length != 0) {
                    $(gridPrecos + 'Bts').find($(clsEdita)).addClass('alterar_disabled').removeClass('editar2');
                    $(gridPrecos + 'Bts').find($(clsApaga)).addClass('apagar_disabled').removeClass('apagar2');
                    $(gridPrecos).find('.k-state-selected').removeClass('k-state-selected');
                }
                if (elem.length && elem.html() === '') {
                    if ($('#AdicionaF4').length) {
                        var urlAux = rootDir + "Artigos/Artigos" + tabHrefAux;
                    }
                    else {
                        var urlAux = window.location.pathname + tabHrefAux;
                    }
                    var dataAux = {
                        vistaParcial: true
                    };
                    UtilsChamadaAjax(urlAux, true, dataAux,
                        function (res) {
                            if (res != undefined && res != null) {
                                var tabHref = $('.clsF3MTabs a.active').attr('href');

                                if (tabHref !== undefined && tabHref !== '') {
                                    var elem = $(tabHref).find('.' + colocarGrelhaClass);

                                    elem.html(res);
                                }
                            }
                        }, function (fv) {
                        }, 1, true, null, null, 'html', 'GET');
                }

                break;
            case '#tabUnidades':
                if ($(gridUnidades).length != 0) {
                    $(gridUnidades + 'Bts').find($(clsEdita)).addClass('alterar_disabled').removeClass('editar2');
                    $(gridUnidades + 'Bts').find($(clsApaga)).addClass('apagar_disabled').removeClass('apagar2');
                    $(gridUnidades).find('.k-state-selected').removeClass('k-state-selected');
                }

            case '#tabIdiomas':
                if (gridIdiomas.length != 0) {
                    $(gridIdiomas + 'Bts').find($(clsEdita)).addClass('alterar_disabled').removeClass('editar2');
                    $(gridIdiomas + 'Bts').find($(clsApaga)).addClass('apagar_disabled').removeClass('apagar2');
                    $(gridIdiomas).find('.k-state-selected').removeClass('k-state-selected');
                }
                if (elem.length && elem.html() === '') {
                    if ($('#AdicionaF4').length) {
                        var urlAux = rootDir + "Artigos/Artigos" + tabHrefAux;
                    }
                    else {
                        var urlAux = window.location.pathname + tabHrefAux;
                    }
                    var dataAux = {
                        vistaParcial: true
                    };

                    UtilsChamadaAjax(urlAux, true, dataAux,
                        function (res) {
                            if (res != undefined && res != null) {
                                var tabHref = $('.clsF3MTabs a.active').attr('href');

                                if (tabHref !== undefined && tabHref !== '') {
                                    var elem = $(tabHref).find('.' + colocarGrelhaClass);

                                    elem.html(res);
                                }
                            }
                        }, function (fv) {
                        }, 1, true, null, null, 'html', 'GET');
                }
                break;
            default:
                break;
        }
    }

    self.TipoDimensaoDataBound = function (inDDL) {
        var cmbTD = KendoRetornaElemento($('#' + tipoDimensaoID));
        var dimVal = parseInt(cmbTD.value());

        self.TipoDimensaoSwitch(dimVal);
    };

    // QUANDO A LOOKUP DIMENSOES E ALTERADA
    self.TipoDimensaoChange = function (inDDL) {
        var cmbTP = KendoRetornaElemento($('#IDTipoPreco'));
        var inTarValAux = parseInt(inDDL.value());
        var inTarVal = (isNaN(inTarValAux)) ? 0 : inTarValAux;

        self.TipoDimensaoSwitch(inTarVal);

        if (UtilsVerificaObjetoNotNullUndefined(cmbTP)) {
            cmbTP.dataSource.read();
        }
    }

    self.TipoDimensaoSwitch = function (dimVal) {
        var cmbDP = KendoRetornaElemento($('#' + dimensaoPrimeiraID));
        var cmbDS = KendoRetornaElemento($('#' + dimensaoSegundaID));
        var elems = [cmbDP, cmbDS];

        switch (dimVal) {
            case 0:
            case 1:
                for (var i = 0; i < elems.length; i++) {
                    self.ComboVisivel(elems[i], false);
                }
                break;
            case 2:
                self.ComboVisivel(cmbDP, true);
                self.ComboVisivel(cmbDS, false);
                break;
            case 3:
                for (var i = 0; i < elems.length; i++) {
                    self.ComboVisivel(elems[i], true);
                }
                break;
        }
    }

    // ESCONDE E MOSTRA COMBOS (FUNCAO INTERNA)
    self.ComboVisivel = function (cmb, visivel) {
        if (UtilsVerificaObjetoNotNullUndefined(cmb)) {
            var cmbID = cmb.element.attr('id');
            var label = $('label[for=' + cmbID + ']');

            if (visivel) {
                label.css({
                    'visibility': 'visible'
                });
                cmb.element.parent().show();
            }
            else {
                cmb.value();
                cmb.text('');
                label.css({
                    'visibility': 'hidden'
                });
                cmb.element.parent().hide();
            }
        }
    }

    // INICIA CHECKBOXES DEFINICAO ARTIGOS F4
    self.initCheckBoxesDefinicaoArtigosF4 = function () {
        var cbGereStock = $('#GereStock');
        var cbGereLotes = $('#GereLotes');
        var cbInventariado = $('#Inventariado');

        //var cbNumeroSerie = $('#GereNumeroSerie');
        var cmbSugestao = KendoRetornaElemento($('#IDOrdemLoteApresentar'));
        //var tipoDimElem = $('#' + tipoDimensaoID);

        //self.TipoDimensaoChange(tipoDimElem);

        //PARAMETRIZA CLICKS NAS CHECKS
        cbGereStock.on('click', function (e) {
            self.GereStockClique(e, cbGereLotes, cmbSugestao, cbInventariado);
        });

        cbGereLotes.on('click', function (e) {
            self.ComboVisivel(cmbSugestao, e.target.checked);
            self.EnableOrDisableTabs(true, e.target.checked);
        });

        //tipoDimElem.on('change', function (e) {
        //    self.TipoDimensaoChange($(e.currentTarget));
        //});
    }

    // INICIA CHECKBOXES DEFINICAO ARTIGOS
    self.initCheckBoxesDefinicaoArtigos = function () {
        var cmbSugestao = KendoRetornaElemento($('#IDOrdemLoteApresentar'));
        //var cbNumeroSerie = $('#GereNumeroSerie');
        var cbGereStock = $('#GereStock');
        var cbGereLotes = $('#GereLotes');
        var cbInventariado = $('#Inventariado');
        var tipoDimElem = $('#' + tipoDimensaoID);

        //PARAMETRIZA ESTADO INICIAL
        var form = $('#' + gridID + 'Form form');
        var formValues = GrelhaUtilsGetModeloForm(GrelhaFormDTO(form));

        if (!formValues.GereStock || !formValues.GereLotes) {
            if (!formValues.GereStock) {
                //cbNumeroSerie.prop(constDisabled, true).parent().parent().addClass(constDisabled);
                cbGereLotes.prop(constDisabled, true).parent().parent().addClass(constDisabled);
                cbInventariado.prop(constDisabled, true).parent().parent().addClass(constDisabled);
            }

            self.ComboVisivel(cmbSugestao, false);
        }
        else if (formValues.GereLotes) {
            self.ComboVisivel(cmbSugestao, true);
        }

        //PARAMETRIZA CLICKS NAS CHECKS
        cbGereStock.on('click', function (e) {
            self.GereStockClique(e, cbGereLotes, cmbSugestao, cbInventariado);
        })

        cbGereLotes.on('click', function (e) {
            self.ComboVisivel(cmbSugestao, e.target.checked);
            self.EnableOrDisableTabs(true, e.target.checked);
        })

        //if ($('#' + campoEmExec).val() == base.constantes.EstadoFormEAcessos.Alterar && $('#existeDimensoesLinha1').val() == "True") {

        //    var cmbTipoDimensao = KendoRetornaElemento(tipoDimElem);
        //    var cmbDimensao1 = KendoRetornaElemento($("#" + dimensaoPrimeiraID));
        //    var cmbDimensao2 = KendoRetornaElemento($("#" + dimensaoSegundaID));

        //    if (UtilsVerificaObjetoNotNullUndefined(cmbTipoDimensao) && cmbTipoDimensao.value() > 1) {
        //        cmbTipoDimensao.enable(false);
        //    }

        //    if (UtilsVerificaObjetoNotNullUndefined(cmbDimensao1) && cmbDimensao1.text() != "") {
        //        cmbDimensao1.enable(false);
        //    }

        //    if (UtilsVerificaObjetoNotNullUndefined(cmbDimensao2) && cmbDimensao2.text() != "") {
        //        cmbDimensao2.enable(false);
        //    }
        //}
    }

    // FUNCAO INTERNA CLIQUE CB GERE STOCK
    self.GereStockClique = function (e, cbGereLotes, cmbSugestao, cbInventariado) {
        if (e.target.checked) {
            ///cbNumeroSerie.prop(constDisabled, false).parent().parent().removeClass(constDisabled);
            cbGereLotes.prop(constDisabled, false).parent().parent().removeClass(constDisabled);
            cbInventariado.prop(constDisabled, false).parent().parent().removeClass(constDisabled);
        }
        else {
            //cbNumeroSerie.prop(constDisabled, true).prop('checked', false).parent().parent().addClass(constDisabled);
            cbGereLotes.prop(constDisabled, true).prop('checked', false).parent().parent().addClass(constDisabled);
            cbInventariado.prop(constDisabled, true).prop('checked', false).parent().parent().addClass(constDisabled);

            self.ComboVisivel(cmbSugestao, false);
        }
        self.EnableOrDisableTabs(e.target.checked, false);
    };

    // CONSTROI O OBJETO PARA PASSAR PARA A WINDOW
    self.RetornaObjetoData = function (inData, inAcao) {
        inData.AcaoClicada = inAcao
        if (inAcao = 'Dimensoes') {
            var cbTD = $('#' + tipoDimensaoID).data("kendoDropDownList");
            var cbDP = $('#' + dimensaoPrimeiraID).data("kendoComboBox");

            if (cbTD !== undefined) {
                var cbTDVal = (cbTD !== undefined) ? parseInt(cbTD.value()) : 0;
                if (cbTDVal === 2) {
                    inData.totalDimensoes = 'Uma';
                    inData.IDDimensao1 = cbDP.value();
                    inData.Dimensao1 = cbDP.text();
                }
                else if (cbTDVal === 3) {
                    var cbDS = $('#' + dimensaoSegundaID).data("kendoComboBox");

                    inData.totalDimensoes = 'Duas';
                    inData.IDDimensao1 = cbDP.value();
                    inData.Dimensao1 = cbDP.text();
                    inData.IDDimensao2 = cbDS.value();
                    inData.Dimensao2 = cbDS.text();
                }
            }
        }
        return inData
    }

    // CONSTROI O OBJETO PARA PASSAR PARA A WINDOW
    self.IndexGrelhaDataBound = function (e) {
        var grid = this;
        var gBts = $('.' + cssClassG + cssClassBts);
        gBts.find('#' + btIDAdd).attr('id', 'BtAdiciona');
        gBts.find('#' + btIDEdit).remove();
        gBts.find('#' + btIDRemove).remove();

        GrelhaDataBound(e);
    }

    // CONSTROI O OBJETO PARA PASSAR PARA A WINDOW
    self.InitAdicionaF4 = function (e) {
        var grid = KendoRetornaElemento(window.parent.$('#F3MGrelhaArtigos'));

        $('#' + btIDGuardarFecha + ', #' + btIDCancelar).on('click', function (e) {
            var elemID = $(e.currentTarget).attr('id');
            var form = $('form');
            var jsonData = GrelhaUtilsGetModeloForm(GrelhaFormDTO(form));
            var urlNovo = '';
            var janelaF4 = window.parent.$('#janelaMenu').data('kendoWindow');

            if (elemID == base.constantes.grelhaBotoesIDs.Cancelar) {
                GrelhaFormConfirmacaoCancelarSucesso(grid);
                janelaF4.close();
            }
            else {
                urlNovo = form.attr('action').split('F4?')[0];
                GrelhaFormValida(grid, form, urlNovo, jsonData, elemID);

                var erros = UtilsDesenhaListaErrosHTML(GrelhaUtilsValida(form), true);
                if (!UtilsVerificaObjetoNotNullUndefinedVazio(erros)) {
                    grid.dataSource.read();
                    janelaF4.close();
                }
            }
        })
    }

    self.AALValidaEspecifica = function (grid, data, url) {
        var options = grid.dataSource.transport.options;
        var erros = GrelhaUtilsValida(grid.element);

        if (erros != null) {
            return null;
        }
        var model = GrelhaRetornaModeloLinha(grid);
        var boolModel = UtilsVerificaObjetoNotNullUndefined(model);

        var linhasRepetidas = $.grep(grid.dataItems(), function (item) {
            return (item.DescricaoArmazem == model.DescricaoArmazem && item.uid != model.uid);
        });

        if (linhasRepetidas.length) {
            erros = UtilsAdicionaRegistoArray(erros, resources.artigos_armazem_existente.replace('{0}', linhasRepetidas[0].DescricaoArmazem));
        }

        return erros;
    }

    self.ArmazensDataBound = function (e) {
        if (e.sender._editContainer != undefined) {
            if (e.sender.dataItem(e.sender._editContainer).PorDefeito) {
                var gridDS = e.sender.dataSource.data()
                var gridDSLen = gridDS.length
                for (var i = 0; i < gridDSLen; i++) {
                    if (gridDS[i].uid != e.sender.dataItem(e.sender._editContainer).uid) {
                        gridDS[i].PorDefeito = false
                        GrelhaLinhasColocaLinhaNasLinhasAlteradas(e.sender.element.attr('id'), gridDS[i], estadoAdicionar);
                    }
                }
            }
        }
    }

    self.IDArmazemEnviaParams = function (objetoFiltro) {
        var grid = KendoRetornaElemento($("#F3MGrelhaArtigosArmazensLocalizacoes"));
        var dataItem = grid.dataItem(grid.select());

        if (dataItem != undefined && dataItem.ID > 0) { // ESTA EM EDICAO
            var campoArmazemIncID = campoArmazemID + "Incluir";
            var elemIDArmazem = $("#" + campoArmazemIncID);

            GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elemIDArmazem, true, campoArmazemIncID);

            return objetoFiltro
        }
    }

    self.IDArmazemLocalizacaoEnviaParams = function (objetoFiltro) {

        var elemIDArmazem = $("#" + campoArmazemID);

        if (!elemIDArmazem.length) {
            elemIDArmazem = window.parent.$("#" + campoArmazemID);
        }

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elemIDArmazem, true, campoArmazemID);

        return objetoFiltro
    }

    self.EnableOrDisableDropComposto = function () {
        var dropIDTiposComponente = KendoRetornaElemento($('#' + campoIDTtiposComponente));
        var dropIDCompostoTransformacaoMetodoCusto = KendoRetornaElemento($('#' + campoIDCompostoTransformacaoMetodoCusto));
        var IDMetodoCustoPai = $('#' + campoIDCompostoTransformacaoMetodoCusto).parent();
        var winErrors = $('#' + msgErroID).data('kendoWindow');

        if (UtilsVerificaObjetoNotNullUndefinedVazio(dropIDTiposComponente)) {
            $('#blnExistemComponentes').val() == 'True' ? dropIDTiposComponente.enable(false) : dropIDTiposComponente.enable(true);

            if (dropIDTiposComponente.value() == 3) {
                dropIDCompostoTransformacaoMetodoCusto.enable(true);

                if (!IDMetodoCustoPai.hasClass(constClassObr)) {
                    IDMetodoCustoPai.addClass(constClassObr);
                    dropIDCompostoTransformacaoMetodoCusto.element.addClass(constClassObr);
                    dropIDCompostoTransformacaoMetodoCusto.element.attr(constRequired, constRequired);

                    if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
                        if (winErrors.options.visible == true) {
                            GrelhaUtilsValida($('.' + constClassFormPrinc));
                        }
                    }
                }
            }
            else {
                dropIDCompostoTransformacaoMetodoCusto.value(0);
                dropIDCompostoTransformacaoMetodoCusto.enable(false);

                IDMetodoCustoPai.parent().find('.' + constClassInputError) ? IDMetodoCustoPai.parent().find('.' + constClassInputError).removeClass(constClassInputError) : false;
                IDMetodoCustoPai.find('.' + constClassObr) ? IDMetodoCustoPai.parent().find('.' + constClassObr).removeClass(constClassObr) : false;
                dropIDCompostoTransformacaoMetodoCusto.element.removeClass(cssClassKendoInval);
                dropIDCompostoTransformacaoMetodoCusto.element.removeAttr(constRequired);

                if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
                    if (winErrors.options.visible == true) {
                        GrelhaUtilsValida($('.' + constClassFormPrinc));
                    }
                }
            }
        }
    }

    self.EnableOrDisableTabs = function (blnEnableTabStock, blnEnableTabLotes) {
        var tabArmLocElem = $('a[href="#tabArmazensLocalizacoes"]');
        var tabLotElem = $('a[href="#tabLotes"]');
        if (blnEnableTabStock) {
            tabArmLocElem.parent().removeClass(constDisabled);
            tabArmLocElem.removeClass(constDisabled);
        }
        else {
            tabArmLocElem.parent().addClass(constDisabled);
            tabArmLocElem.addClass(constDisabled);
        }

        if (blnEnableTabLotes) {
            tabLotElem.parent().removeClass(constDisabled);
            tabLotElem.removeClass(constDisabled);
        }
        else {
            tabLotElem.parent().addClass(constDisabled);
            tabLotElem.addClass(constDisabled);
        }
    }

    self.Calculos = function (model, TipoCalculo) {
        /* F Ó R M U L A S 
                PVCIVA =  PVSIVA * (1 + (taxa Iva / 100))
                PVSIVA = PVCIVA / (1 + (taxa Iva / 100))
                %UPC = ((PVSIVA/UPC)-1)*100
        */
        var blnNullOrEmpty = true;
        var valorSemIVA;

        switch (TipoCalculo) {
            case TiposCalculos.CalculoComIVA:
                if (taxaIVA != 0) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoValorComIva).val()) == true) {
                        var valorComIVA = parseFloat($('#' + campoValorComIva).val().replace(',', '.'));
                        KendoRetornaElemento($('#' + campoValorSemIva)).value(valorComIVA / (1 + (taxaIVA / 100)));
                        model[campoValorSemIva] = valorComIVA / (1 + (taxaIVA / 100));
                        blnNullOrEmpty = false;
                    }
                    else {
                        KendoRetornaElemento($('#' + campoValorSemIva)).value("");
                        model[campoValorSemIva] = null;
                        blnNullOrEmpty = true;
                    }
                }
                else {
                    KendoRetornaElemento($('#' + campoValorSemIva)).value($('#' + campoValorComIva).val());
                    model[campoValorSemIva] = model[campoValorComIva];
                    blnNullOrEmpty = false;
                }

                self.PercentagemUltimoPrecoCusto(model, blnNullOrEmpty);
                self.PercentagemPadrao(model, blnNullOrEmpty);
                break;

            case TiposCalculos.CalculoSemIVA:
                if (taxaIVA != 0) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoValorSemIva).val()) == true) {
                        valorSemIVA = parseFloat($('#' + campoValorSemIva).val().replace(',', '.'));
                        KendoRetornaElemento($('#' + campoValorComIva)).value(valorSemIVA * (1 + (taxaIVA / 100)));
                        model[campoValorComIva] = valorSemIVA * (1 + (taxaIVA / 100));
                        blnNullOrEmpty = false;
                    }
                    else {
                        KendoRetornaElemento($('#' + campoValorComIva)).value("");
                        model[campoValorComIva] = null;
                        blnNullOrEmpty = true;
                    }
                }
                else {
                    KendoRetornaElemento($('#' + campoValorComIva)).value($('#' + campoValorSemIva).val());
                    model[campoValorComIva] = model[campoValorSemIva];
                    blnNullOrEmpty = false;
                }

                self.PercentagemUltimoPrecoCusto(model, blnNullOrEmpty);
                self.PercentagemPadrao(model, blnNullOrEmpty);
                break;

            case TiposCalculos.CalculoPercentagem:
                if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoUltimoPrecoCusto).val())) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoUPCPercentagem).val())) {
                        KendoRetornaElemento($('#' + campoValorSemIva)).value(parseFloat($('#' + campoUltimoPrecoCusto).val().replace(',', '.')) * (1 + (parseFloat($('#' + campoUPCPercentagem).val().replace(',', '.')) / 100)));
                        model[campoValorSemIva] = parseFloat($('#' + campoUltimoPrecoCusto).val().replace(',', '.')) * (1 + (parseFloat($('#' + campoUPCPercentagem).val().replace(',', '.')) / 100));

                        valorSemIVA = parseFloat($('#' + campoValorSemIva).val().replace(',', '.'));
                        KendoRetornaElemento($('#' + campoValorComIva)).value(valorSemIVA * (1 + (taxaIVA / 100)));
                        model[campoValorComIva] = valorSemIVA * (1 + (taxaIVA / 100));
                    }
                } else {
                    $('#' + campoValorComIva).trigger('blur');
                }

                break;

            case TiposCalculos.CalculoPercentagemPadrao:
                    if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoPadrao).val())) {
                        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoPadraoPercentagem).val())) {
                            KendoRetornaElemento($('#' + campoValorSemIva)).value(parseFloat($('#' + campoPadrao).val().replace(',', '.')) * (1 + (parseFloat($('#' + campoPadraoPercentagem).val().replace(',', '.')) / 100)));
                            model[campoValorSemIva] = parseFloat($('#' + campoPadrao).val().replace(',', '.')) * (1 + (parseFloat($('#' + campoPadraoPercentagem).val().replace(',', '.')) / 100));

                            valorSemIVA = parseFloat($('#' + campoValorSemIva).val().replace(',', '.'));
                            KendoRetornaElemento($('#' + campoValorComIva)).value(valorSemIVA * (1 + (taxaIVA / 100)));
                            model[campoValorComIva] = valorSemIVA * (1 + (taxaIVA / 100));
                        }
                    } else {
                        $('#' + campoValorComIva).trigger('blur');
                    }

                    break;
        }
    }

    self.PercentagemUltimoPrecoCusto = function (model, blnNullOrEmpty) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + campoUPCPercentagem)))) {
            if (blnNullOrEmpty == true || UtilsVerificaObjetoNotNullUndefinedVazio(UtilsVerificaObjetoNotNullUndefinedVazio()) == false) {
                KendoRetornaElemento($('#' + campoUPCPercentagem)).value("");
                model[campoUPCPercentagem] = null;
            }
            else {
                var calulosAuxiliares;
                if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoUltimoPrecoCusto).val())) {
                    calulosAuxiliares = ((parseFloat($('#' + campoValorSemIva).val().replace(',', '.')) / (parseFloat($('#' + campoUltimoPrecoCusto).val().replace(',', '.'))) || 0) - 1) * 100;
                } else {
                    calulosAuxiliares = Math.abs(((parseFloat($('#' + campoValorSemIva).val().replace(',', '.')) / (parseFloat($('#' + campoUltimoPrecoCusto).val().replace(',', '.'))) || 0) - 1) * 100);
                }

                KendoRetornaElemento($('#' + campoUPCPercentagem)).value(calulosAuxiliares);
                model[campoUPCPercentagem] = calulosAuxiliares;
            }
        }
    }
    self.PercentagemPadrao = function (model, blnNullOrEmpty) {
        debugger
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + campoPadraoPercentagem)))) {
            if (blnNullOrEmpty == true || UtilsVerificaObjetoNotNullUndefinedVazio(UtilsVerificaObjetoNotNullUndefinedVazio()) == false) {
                KendoRetornaElemento($('#' + campoPadraoPercentagem)).value("");
                model[campoPadraoPercentagem] = null;
            }
            else {
                var calulosAuxiliares;
                if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoPadrao).val())) {
                    calulosAuxiliares = ((parseFloat($('#' + campoValorSemIva).val().replace(',', '.')) / (parseFloat($('#' + campoPadrao).val().replace(',', '.'))) || 0) - 1) * 100;
                } else {
                    calulosAuxiliares = 100;
                }

                KendoRetornaElemento($('#' + campoPadraoPercentagem)).value(calulosAuxiliares);
                model[campoPadraoPercentagem] = calulosAuxiliares;
            }
        }
    }

    self.TaxaIVAChange = function (obj) {
        taxaIVA = UtilsVerificaObjetoNotNullUndefinedVazio(obj.dataItem()) == true ? obj.dataItem().Taxa : 0;
        var grid = KendoRetornaElemento($('#' + gridArtigosPrecos));
        var gridDS = grid.dataSource.view();

        $('#' + campoTaxaIva).val(taxaIVA);

        for (var i = 0; i < gridDS.length; i++) {
            gridDS[i][campoValorComIva] = gridDS[i][campoValorSemIva] * (1 + (taxaIVA / 100));
            gridDS[i].dirty = true;
            GrelhaLinhasColocaLinhaNasLinhasAlteradas(gridArtigosPrecos, gridDS[i], constEstados.Adicionar);
        }

        grid.refresh();
        GrelhaLinhasSetDataSourceNaHidden(gridDS, gridArtigosPrecos);
    }


    self.PadraoChange = function (obj) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#Padrao').val())) {
            ValorPadrao = parseFloat($('#Padrao').val().replace(',', '.'));
        }

        var grid = KendoRetornaElemento($('#' + gridArtigosPrecos));
        var gridDS = grid.dataSource.view();

        for (var i = 0; i < gridDS.length; i++) {
            if (ValorPadrao > 0) {
                gridDS[i][campoPadraoPercentagem] = parseFloat((gridDS[i][campoValorSemIva] - ValorPadrao) * 100 / ValorPadrao);
            } else {
                gridDS[i][campoPadraoPercentagem] = 100.00;
            }

            gridDS[i].dirty = true;
            GrelhaLinhasColocaLinhaNasLinhasAlteradas(gridArtigosPrecos, gridDS[i], constEstados.Adicionar);
        }

        grid.refresh();
        GrelhaLinhasSetDataSourceNaHidden(gridDS, gridArtigosPrecos);
    }


    self.ValidaEspecifica = function () {
        if (!KendoRetornaElemento($('#IDTaxa')).element.hasClass(base.constantes.classes.F3MSemAcesso))
            KendoRetornaElemento($('#IDTaxa')).enable(true);
    };

    self.IDModeloEnviaParams = function (objetoFiltro) {
        var elemAux = $('#IDTipoArtigo');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#IDTipoArtigo');

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDTipoArtigo');

        elemAux = $('#IDMarca');
        elem = (elemAux.length) ? elemAux : window.parent.$('#IDMarca');

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDMarca');

        return objetoFiltro;
    };

    self.IDMarcaChange = function (comboMarca) {
        var comboTipoArtigo = KendoRetornaElemento($('#IDTipoArtigo'));
        var comboModelo = KendoRetornaElemento($('#IDModelo'));
        var comboTratamentos = KendoRetornaElemento($('#IDTratamentoLente'));
        var comboCores = KendoRetornaElemento($('#IDCorLente'));

        if (KendoRetornaElemento($('#IDModelo')) != null) {
            comboModelo.value('');

            if (comboMarca.selectedIndex == -1) {
                comboModelo.enable(false)
            } else {
                comboModelo.enable(true);
                comboModelo.dataSource.read();
            }

            if (comboTratamentos != null && comboCores != null) {
                comboTratamentos.value('');
                comboTratamentos.enable(false);

                comboCores.value('');
                comboCores.enable(false);
            }
        }

        $('#hdfIDMarca').val($('#IDMarca').val());
    };

    self.CorLenteEnviaParams = function (objetoFiltro) {
        var elemAux = $('#IDModelo');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#IDModelo');

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDModelo');

        return objetoFiltro;
    };

    self.TratamentosEnviaParams = function (objetoFiltro) {
        var elemAux = $('#IDModelo');
        var elem = (elemAux.length) ? elemAux : window.parent.$('#IDModelo');

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDModelo');

        return objetoFiltro;
    };

    self.ModeloChange = function (combo) {
        var comboTratamentos = KendoRetornaElemento($('#IDTratamentoLente'));
        var comboCores = KendoRetornaElemento($('#IDCorLente'));

        EDITOU_MODELO = true;

        if (combo.selectedIndex == -1) {
            comboTratamentos.value('');
            comboTratamentos.enable(false);

            comboCores.value('');
            comboCores.enable(false);

            $('#hdfIDTipoLente').val('');
            $('#hdfIDMateriaLente').val('');
        }
        else {
            comboTratamentos.enable(true);
            comboTratamentos.value('');
            comboTratamentos.dataSource.read();

            comboCores.enable(true);
            comboCores.value('');
            comboCores.dataSource.read();

            self.CarregaSuplementos();

            $('#hdfIDTipoLente').val(combo.dataItem().IDTipoLente);
            $('#hdfIDMateriaLente').val(combo.dataItem().IDMateriaLente);
        }
        $('#hdfIDModelo').val($('#IDModelo').val());
    };

    self.AtualizaDescricao = function () {
        var classe = '';

        if (UtilsVerificaObjetoNotNullUndefined(KendoRetornaElemento($('#IDTipoArtigo')).dataItem())) {
            classe = KendoRetornaElemento($('#IDTipoArtigo')).dataItem().CodigoSistemaTipoArtigo;
        }
        else {
            classe = $('#classe').val();
        }

        if (classe == classeArtigo.Aros || classe == classeArtigo.OculosSol) {
            var Descricao = KendoRetornaElemento($('#IDMarca')).text() + ' ' + KendoRetornaElemento($('#IDModelo')).text() + ' ' + $('#CodigoCor').val() + ' ' + $('#Tamanho').val() + ' ' + $('#Hastes').val();
        }
        else if (classe == classeArtigo.LentesContato) {
            var desc = [];

            KendoRetornaElemento($('#IDMarca')).text() != '' ? desc.push(KendoRetornaElemento($('#IDMarca')).text()) : false;
            KendoRetornaElemento($('#IDModelo')).text() != '' ? desc.push(KendoRetornaElemento($('#IDModelo')).text()) : false;

            var diam = $('#Diametro').val();
            if ($.isNumeric(diam)) {
                diam = parseFloat(diam).toFixed(2);
                $('#Diametro').val(diam);
            }

            var raio = $('#Raio').val();
            if ($.isNumeric(raio)) {
                raio= parseFloat(raio).toFixed(2);
                $('#Raio').val(raio);
            }

            $('#Diametro').val() != '' ? desc.push(resources['Diam'] + ':' + $('#Diametro').val()) : false;
            $('#Raio').val() != '' && $('#Raio').val() != '0.00' ? desc.push(resources['Raio'] + ':' + $('#Raio').val()) : false;
            $('#PotenciaEsferica').val() != '' && $('#PotenciaEsferica').val() != '0' ? desc.push(resources['Esf'] + ':' + $('#PotenciaEsferica').val()) : false;
            $('#PotenciaCilindrica').val() != '' && $('#PotenciaCilindrica').val() != '0' ? desc.push(resources['Cil'] + ':' + $('#PotenciaCilindrica').val()) : false;
            $('#Eixo').val() != '' && $('#Eixo').val() != '0' ? desc.push(resources['Eixo'] + ':' + $('#Eixo').val()) : false;
            $('#Adicao').val() != '' && $('#Adicao').val() != '0' ? desc.push(resources['Adi'] + ':' + $('#Adicao').val()) : false;
            var Descricao = desc.join(' ');
        }
        else if (classe == classeArtigo.LentesOftalmicas) {
            if ($('#hdfIDTipoLente').val() == 1) {
                KendoRetornaElemento($('#Adicao')).value(0);
            };

            var desc = [];
            KendoRetornaElemento($('#IDMarca')).text() != '' ? desc.push(KendoRetornaElemento($('#IDMarca')).text()) : false;
            KendoRetornaElemento($('#IDModelo')).text() != '' ? desc.push(KendoRetornaElemento($('#IDModelo')).text()) : false;
            KendoRetornaElemento($('#IDTratamentoLente')).text() != '' ? desc.push(KendoRetornaElemento($('#IDTratamentoLente')).text()) : false;
            KendoRetornaElemento($('#IDCorLente')).text() != '' ? desc.push(KendoRetornaElemento($('#IDCorLente')).text()) : false;
            var DescricaoSup = '';

            var count = $('.supsClass').length;

            for (var i = 0; i < count; i++) {
                if ($($('.supsClass')[i]).attr('checked') == 'checked') {
                    DescricaoSup += $($('.supsClass')[i]).parent().text().trim() + ' ';
                }
            }

            $('#Diametro').val() != '' ? desc.push(resources['Diam'] + ':' + $('#Diametro').val()) : false;
            $('#PotenciaEsferica').val() != '' && $('#PotenciaEsferica').val() != '0' ? desc.push(resources['Esf'] + ':' + $('#PotenciaEsferica').val()) : false;
            $('#PotenciaCilindrica').val() != '' && $('#PotenciaCilindrica').val() != '0' ? desc.push(resources['Cil'] + ':' + $('#PotenciaCilindrica').val()) : false;
            $('#Adicao').val() != '' && $('#Adicao').val() != '0' ? desc.push(resources['Adi'] + ':' + $('#Adicao').val()) : false;
            var Descricao = desc.join(' ');

            DescricaoSup != '' ? Descricao += ' (' + DescricaoSup + ')' : Descricao += '';
        }
        else {
            if (UtilsVerificaObjetoNotNullUndefinedVazio($('#Descricao').val())) {
                var Descricao = $('#Descricao').val();
            }
            else {
                var Descricao = KendoRetornaElemento($('#IDMarca')).text();
            }
        }

        $('#' + campoDesc).val(Descricao);
    };

    self.errosCount = function (grid) {
        var erros = GrelhaUtilsValida($('#' + grid.element.attr('id') + 'Form'));
        return erros == null ? 0 : erros.length
    };

    self.ValidaEspecificaForm = function (grid, data, url) {
        var options = grid.dataSource.transport.options;
        var gridID = grid.element.attr('id');
        var erros = GrelhaUtilsValida($('#' + gridID + 'Form'));

        if (erros != null) {
            return null;
        }

        return erros;
    };

    // ID TIPO PRECO ENVIA PARAMS
    self.TipoPrecoEnviaParams = function (objetoFiltro) {
        var elemTipoID = $("#" + tipoDimensaoID);

        if (!elemTipoID.length) {
            elemTipoID = window.parent.$("#" + tipoDimensaoID);
        }

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elemTipoID, true);

        return objetoFiltro
    }

    // ID TIPO PRECO ENVIA PARAMS
    self.CodigoPrecoChange = function (combo) {
        var gridElem = combo.element.parents('.' + cssClassG);
        var gridElemK = KendoRetornaElemento(gridElem);

        if (UtilsVerificaObjetoNotNullUndefined(gridElemK)) {
            var gridDS = gridElemK.dataSource.data();
            var gridSel = gridElemK.select();
            var linIndex = (UtilsVerificaObjetoNotNullUndefined(gridSel)) ? gridElemK.items().index(gridSel) : -1;
            var comboDSSel = combo.dataItem();

            if (gridDS.length > 0 && UtilsVerificaObjetoNotNullUndefined(comboDSSel)) {
                var codTPCombo = comboDSSel[campoID];

                for (var i = 0; i < gridDS.length; i++) {
                    var codTP = gridDS[i]['IDCodigoPreco'];

                    if (codTPCombo === codTP && i !== linIndex) {
                        UtilsAlerta(base.constantes.tpalerta.i, resources.tipo_preco_existente);
                        ComboBoxLimpa(combo);
                    }
                }
            }
        }
    };

    self.unbindCrudEvents = function () {
        $('#F3MGrelhaFormArtigosBtSaveFecha2').unbind('click').click(function (e) {
            e.preventDefault();

            var elemID = $(e.currentTarget).attr('id');
            var elemBtID = elemID.replace('F3MGrelhaFormArtigos', '');
            self.Acoes(elemBtID);

            e.stopImmediatePropagation();
            return false;
        });

        $('#F3MGrelhaFormArtigosBtSaveFecha').unbind('click').click(function (e) {
            e.preventDefault();

            var elemID = $(e.currentTarget).attr('id');
            var elemBtID = elemID.replace('F3MGrelhaFormArtigos', '');
            self.Acoes(elemBtID);

            e.stopImmediatePropagation();
            return false;
        });

        $('#F3MGrelhaFormArtigosBtSaveContinua').unbind('click').click(function (e) {
            e.preventDefault();

            var elemID = $(e.currentTarget).attr('id');
            var elemBtID = elemID.replace('F3MGrelhaFormArtigos', '');
            self.Acoes(elemBtID);

            e.stopImmediatePropagation();
            return false;
        });
    };

    self.CliqueLoadOpcao = function (url, grupo, nome) {
        try {
            var objetoFiltro = GrelhaUtilsObjetoFiltro();
            objetoFiltro.FiltroTexto = grupo;

            var elemAux = $('#Codigo');
            var elem = (elemAux.length) ? elemAux : $('#Codigo').val();
            GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'Codigo');

            UtilsChamadaAjax(url, false, objetoFiltro,
                function (res) {
                    if (UtilsVerificaObjetoNotNullUndefined(res)) {
                        $('#' + nome).val(res);
                    }
                }, function (fv) {
                    throw (fv)
                }, 1, true, null, null, 'html', 'GET');

        } catch (ex) {
        }
    };

    self.RetornaModelo = function () {
        var valorID = null;
        var formulario = $('#AdicionaF4');
        var model = GrelhaUtilsGetModeloForm(GrelhaFormDTO(formulario));

        model.ArtigosLentesOftalmicasSuplementos = [];
        var count = $('#partialLentesOftalmicasSuplementos').find('.checkbox').length;

        for (var i = 0; i < count; i++) {
            var obj = {
                IDSuplementoLente: $($('#partialLentesOftalmicasSuplementos').find('.checkbox')[i]).find('.supsClass').attr('id'),
                Checked: $($('#partialLentesOftalmicasSuplementos').find('.checkbox')[i]).find('.supsClass').attr('checked') == 'checked' ? true : false
            }
            model.ArtigosLentesOftalmicasSuplementos.push(obj);
        }

        return model;
    };

    /* @description Funcao databound para as grelhas de precos, unidades e idiomas */
    self.GridLinsDatabound = function (inEvt) {
        //databound gen
        GrelhaLinhasDataBound(inEvt);

        //if copy mode then reset values 
        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + campoIDDuplica).val()) && $('#' + campoIDDuplica).val().toString() != '0') {
            var _gridID = inEvt.sender.element.attr('id');
            var _gridDS = inEvt.sender.dataSource.data();

            for (var i = 0; i < _gridDS.length; i++) {
                var _item = _gridDS[i];
                //reset values
                _item['ID'] = 0;
                _item['IDArtigo'] = 0
                _item['AcaoCRUD'] = estadoAdicionar;
                _item['Alterada'] = true;
                //add lin to changed lines
                GrelhaLinhasColocaLinhaNasLinhasAlteradas(_gridID, _item, estadoAdicionar);
            }
        }
    };

    return parent

}($artigos || {}, jQuery));

var ArtigosInit = $artigos.ajax.Init;
var ArtigosEnviaParametros = $artigos.ajax.EnviaParametros;
var ArtigosArmazensLocalizacoesEdit = $artigos.ajax.ArmazensEdit;
var ArtigosArmazensLocalizacoesDataBound = $artigos.ajax.ArmazensDataBound;
var ArtigosArmazensLocalizacoesIDArmazemChange = $artigos.ajax.ArmazensIDArmazemChange;
var ArtigosArmazensLocalizacoesIDArmazemEnviaParams = $artigos.ajax.IDArmazemEnviaParams;
var ArtigosArmazensLocalizacoesIDArmazemLocalizacaoEnviaParams = $artigos.ajax.IDArmazemLocalizacaoEnviaParams;
var ArtigosTipoPrecoEnviaParams = $artigos.ajax.TipoPrecoEnviaParams;
var ArtigosTipoDimensaoChange = $artigos.ajax.TipoDimensaoChange;
var ArtigosTipoDimensaoDataBound = $artigos.ajax.TipoDimensaoDataBound;

var ArtigosPrecosGridEdit = $artigos.ajax.PrecosEdit;
var ArtigoPrecoCodigoPrecoChange = $artigos.ajax.CodigoPrecoChange;

var IDTipoArtigoComboChange = $artigos.ajax.IDTipoArtigoComboChange;
var ArtigosIndexGrelhaDataBound = $artigos.ajax.IndexGrelhaDataBound;
var ArtigosInitAdicionaF4 = $artigos.ajax.InitAdicionaF4;
var ArtigosArmazensLocalizacoesValidaEspecifica = $artigos.ajax.AALValidaEspecifica;

var ArtigosSubFamiliasEdit = $artigos.ajax.SubFamiliasEdit;
var ArtigosSubFamiliasDataBound = $artigos.ajax.SubFamiliaDataBound;
var ArtigosArmazensLocalizacoesGrelhaDataBound = $artigos.ajax.ArmazensLocalizacoesGrelhaDataBound;

var ArtigosEnableOrDisableDropComposto = $artigos.ajax.EnableOrDisableDropComposto;

var ArtigosTaxaIVAChange = $artigos.ajax.TaxaIVAChange;
var ArtigosPrecosValidaEspecifica = $artigos.ajax.ValidaEspecifica;
var ArtigosEnableTaxaIva = $artigos.ajax.EnableTaxaIva;
var ArtigosIDModeloEnviaParams = $artigos.ajax.IDModeloEnviaParams;
var ArtigosIDMarcaChange = $artigos.ajax.IDMarcaChange;

var ArtigosIDModeloChange = $artigos.ajax.ModeloChange;
var ArtigosIDCorLenteEnviaParams = $artigos.ajax.CorLenteEnviaParams;
var ArtigosIDTratamentosEnviaParams = $artigos.ajax.TratamentosEnviaParams;

var ArtigosValidaEspecifica = $artigos.ajax.ValidaEspecificaForm;
var ArtigosRetornaModelo = $artigos.ajax.RetornaModelo;

var ArtigosPrecosDatabound = $artigos.ajax.GridLinsDatabound;
var ArtigosUnidadesDatabound = $artigos.ajax.GridLinsDatabound;
var ArtigosIdiomasDatabound = $artigos.ajax.GridLinsDatabound;

$(document).ready(function (e) {
    ArtigosInit();
});