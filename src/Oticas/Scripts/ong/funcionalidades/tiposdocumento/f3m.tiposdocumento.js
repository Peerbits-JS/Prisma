"use strict";

var $tiposdocumento = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var tipoentidadeestado = '#tipoentidadeestado';

    var constCamposGen = base.constantes.camposGenericos;
    var campoID = constCamposGen.ID;
    var campoDesc = constCamposGen.Descricao;
    var campoCod = constCamposGen.Codigo;
    // Variáveis gerais
    var constJSONDates = base.constantes.ConvertJSONDate;

    var campoTiposDocumentoID = "IDTiposDocumento";
    var campoIDModulo = 'IDModulo';
    var campoIDTipoDocumento = "IDSistemaTiposDocumento";
    var campoIDTreeView = "TreeViewTipEntPermDoc";
    var campoSugeridaPorDefeito = "SugeridaPorDefeito";
    var campoIDTipoDocumentoFiscal = "#IDSistemaTiposDocumentoFiscal";
    var campoHiddenTiposDocumento = 'TiposDocumento';
    var acaoForm = $('#' + constCamposGen.IDEmExecucao).val();
    var campoIDMapasVistas = "#IDMapasVistas";
    var campoTiposDocumentoMovStock = '#IDSistemaTiposDocumentoMovStock';
    var campoIDTipoDocReserva = 'IDTipoDocReserva';
    var campoIDTipoDocLibertaReserva = 'IDTipoDocLibertaReserva';
    var campoIDTipoDocCusto = 'IDTipoDocCusto';
    var campoIDTipoDocFinalizacao = 'IDTipoDocFinalizacao';
    var campoIDPrecoUnitario = 'IDSistemaTiposDocumentoPrecoUnitario';
    var campoIDSistemaAcoes = 'IDSistemaAcoes';
    var campoIDCAE = 'IDParametrosEmpresaCAE';
    var campoIDNumVias = 'NumeroVias';

    var constEstados = base.constantes.EstadoFormEAcessos;
    var estadoEditar = constEstados.Alterar;

    var constIDsBts = base.constantes.grelhaBotoesIDs;
    var btIDGuardarFechar = constIDsBts.GuardarFecha;
    var btIDGuardarCont = constIDsBts.GuardarCont;
    var btIDCancelar = constIDsBts.Cancelar;

    var constGFTDS = 'F3MGrelhaFormTiposDocumentosSeries';
    var constGFTD = 'F3MGrelhaFormTiposDocumento';
    var btsAdiciona = '#' + constGFTDS + btIDGuardarFechar + ', #' + constGFTDS + btIDGuardarCont + ', #' + constGFTDS + btIDCancelar;

    var constBtsClass = base.constantes.grelhaBotoesCls;
    var btClassDisabled = constBtsClass.Disabled;
    var btClassInvisivel = constBtsClass.Invisivel;

    var msgErroID = base.constantes.janelasPopupIDs.Erro;
    var constRequired = base.constantes.grelhaBotoesCls.Required;
    var constFormularioPrincipal = 'FormularioPrincipal';

    var constOperadores = base.constantes.Operadores;
    var OperadorEq = constOperadores.Equals;
    var OperadorNeq = constOperadores.NotEquals;

    var allChecks = ['GereStock', 'ReservaStock', 'GereContaCorrente', 'GeraPendente', 'GereCaixasBancos', 'RegistarCosumidorFinal', 'AnalisesEstatisticas', 'CalculaComissoes',
        'ControlaPlafondEntidade', 'AcompanhaBensCirculacao', 'EntregueCliente', 'DocNaoValorizado', 'UltimoPrecoCusto', 'Adiantamento'];

    var Modulo = {
        Stocks: '001',
        Compras: '003',
        Vendas: '004',
        Producao: '005',
        ContaCorrente: '006',
        Oficina: '007',
        SubContratacao: '010'
    };

    /* enums da [tbSistemaTiposDocumentoMovStock] */
    var TiposDocumentoMovStock = {
        NaoMovimenta: 1,
        Entrada: 2,
        Saida: 3,
        Transferencia: 4,
        Vazio: 5,
        Reserva: 6,
        LibertarReserva: 7
    };

    var MODULO = $('#Modulo').val();
    var TIPO_DOC = $('#TipoDoc').val();
    var TIPO_FISC = $('#TipoDoc').val();

    var ObjetosSeries = {
        'SeriesEditadas': [],
        'SeriesAdicionadas': [],
        'SeriesRemovidas': [],
    };

    var GRID = null;
    var IFRAME = null;


    self.Init = function () {
        self.TrataModulo();
        //self.TrataTipoDoc();
        self.TrataTabProducao();
        var valorEdicao = $('#EmExecucao').val();

        if (valorEdicao === constEstados.Adicionar) {
            $('#IDCliente').attr('disabled', 'disabled');
            $('#IDCliente').addClass('disabled');
            self.TrataCamposReserva(false, false);
            self.TrataCamposCusto(false, false);
            self.TrataCamposFinalizacao(false, false);
            self.TrataChecksStocksValoresPorDefeito(true);
            self.TrataViewSeries(0);
        }
        else if (valorEdicao === constEstados.Alterar) {
            if ($('#div_Results').find('.active').length == 0) {
                KendoLoading($('#OpcaoSeries'), true);
                $($('.list-group-item')[0]).addClass('active');

                if (self.VerificaAdicionadas(parseInt($($('.list-group-item')[0]).attr('id'))) === true || valorEdicao == constEstados.Adicionar) {
                    KendoLoading($('#OpcaoSeries'), false);
                }
                else {
                    self.TrataViewSeries($($('.list-group-item')[0]).attr('id'))
                }
            }
        }

        $('.list-group-item').on('click', function (e) {
            e.preventDefault();
            //VALIDA SE ESTA EM EDICAO A SERIE ANTERIOR
            var btGravaEdita = $('#' + constGFTDS + 'BtSaveFecha2');
            if (btGravaEdita.hasClass(btClassDisabled) && $(btsAdiciona).hasClass(btClassInvisivel)) {
                self.AcoesTree(e);
            }
            else {
                UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_sair,
                    function () {
                        self.AcoesTree(e);
                        UtilsJanelaRodape(base.constantes.tpalerta.error, null, true, resources.CelulaErro); // FECHA JANELA 
                    },
                    function () {
                        return false;
                    });
            }
        });

        // TABStocks
        var tabStock = $('.clsF3MTabs a[href=#tabStocks]');
        self.ClickTabStocks(tabStock);
        self.ComportamentosTabStocks();

        self.EnableOrDisableTabs($('#GereStock').is(':checked'), ($('#GereContaCorrente').is(':checked')));

        //PARAMETRIZA CLICKS NAS CHECKS
        $('#GereStock').on('click', function (e) {
            self.GereStockClique(e.target.checked);

        })

        $('#AcompanhaBensCirculacao').on('click', function (e) {
            self.AcompanhaBensCirculacaoClique(e.target.checked);
        });


        $('#GeraPendente').on('click', function (e) {
            var tipoDocFisc = KendoRetornaElemento($(campoIDTipoDocumentoFiscal)).dataItem().Tipo;

            if (tipoDocFisc == 'NC' && $('#GeraPendente').is(':checked') == false) {
                self.TrataCheckBoxs(['GereCaixasBancos'], false, true);
                self.TrataCheckBoxs(['RegistarCosumidorFinal'], true, true, true);
            }
            else if (tipoDocFisc == 'NC' && $('#GeraPendente').is(':checked')) {
                self.TrataCheckBoxs(['GereCaixasBancos', 'RegistarCosumidorFinal'], false, false)
            }
        });

        var tabProducao = $('.clsF3MTabs a[href=#tabProducao]');
        self.ClickTabProducao(tabProducao);
        // Ao clicar no visto de atualização da ficha técnica
        $('#AtualizaFichaTecnica').on('click', function () {
            self.GereActFichaTecnicaClique();
        })

        $('#ReservaStock').on('click', function (e) {
            if (e.target.checked) {
                self.TrataCamposReserva(true, true);
            }
            else {
                self.TrataCamposReserva(false, false);
            }
        });

        // Trata a indicação de conteúdo no campo de observações
        UtilsObservacoesTrataEspecifico("tabObs", "Observacoes");
    };

    self.ClienteEnviaParametros = function (objetoFiltro) {
        var objetoFiltro1 = [];
        var treeview = $("#TreeViewTipEntPermDoc");
        var elemTree = (treeview.length) ? treeview : window.parent.$("#TreeViewTipEntPermDoc");

        var kendoTreeView = elemTree.data("kendoTreeView");
        var sa = [];
        if (UtilsVerificaObjetoNotNullUndefinedVazio(kendoTreeView)) {
            sa = kendoTreeView.dataSource.data().filter(function (f) {
                return f.checked == true;
            });
        }

        if (sa.length != 0) {
            var yy = "";
            for (var i = 0; i < sa.length; i++) {
                var ID = sa[i].ID
                if (i == 0) {
                    yy = yy + ID;
                }
                else {
                    yy = yy + ',' + ID
                }
            }

            objetoFiltro1["Entidades"] = yy;
        }
        var elemAux = $('#IDCliente')
        var elem = (elemAux.length) ? elemAux : window.parent.$('#IDCliente');

        objetoFiltro1["IDCliente"] = elem.val();
        var objeto = HandsonTableEnviaParamsHT(objetoFiltro1);
        return objeto;
    }

    self.AcoesTree = function (e) {
        KendoLoading($('#OpcaoSeries'), true);
        if (self.VerificaAdicionadas(parseInt($(e.target).attr('id'))) === true) {
            KendoLoading($('#OpcaoSeries'), false);
            return false;
        }
        else {
            //aqui

          
            var objSerieEditada =  $.grep(ObjetosSeries.SeriesEditadas, function (obj) {
                return obj.ID === parseInt($(e.target).attr('id'));
            })
            if (UtilsVerificaObjetoNotNullUndefinedVazio(objSerieEditada)) {
                if (objSerieEditada.length > 0) {
                    TiposDocumentoSeriesAcoesClickEditadas(e);
                    KendoLoading($('#OpcaoSeries'), false);
                } else {
                    self.TrataViewSeries(parseInt($(e.target).attr('id')));
                }
            } else {
                self.TrataViewSeries(parseInt($(e.target).attr('id')));
            }
            
        }
        $($('.list-group-item')).removeClass('active');
        $(e.target).addClass('active');
        e.stopImmediatePropagation();
    };

    self.MapasVistasDataBoud = function () {
        if ($('#IDMapasVistas').val() == "") {

            if ($('.list-group-item.active').length == 0) {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDMapasVistas')))) {
                    KendoRetornaElemento($('#IDMapasVistas')).select(function (dataItem) {
                        return dataItem.ID === KendoRetornaElemento($('#IDMapasVistas')).dataSource.data()[0].ID;
                    });
                }
            }
        }
    }


    self.VerificaAdicionadas = function (ID) {
        var ATIVO = parseInt($('#div_Results').find('.active').attr('id'));
        var addedSeries = TiposDocumentoRetornaObjetoSeries().SeriesAdicionadas
        var result = false;

        for (var i = 0; i < addedSeries.length; i++) {
            if (addedSeries[i].CodigoSerie == ID) {
                result = true;
                break;
            }
        }
        return result;
    };

    self.EnviaParametros = function (objetoFiltro) {        
        var elemAux = $('#' + campoID);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoID);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoID);

        return objetoFiltro;
    };

    self.SistemaTiposDocumentoEnviaParams = function (objetoFiltro) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var elemAux = $('#' + campoIDModulo);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDModulo);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoIDModulo);

        return objetoFiltro;
    };

    self.TreeViewEnviaParams = function (objetoFiltro) {
        var elemAux = $('#' + campoIDModulo);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDModulo);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoIDModulo);

        var elemAux2 = $('#' + campoID);
        var elem2 = (elemAux2.length) ? elemAux2 : window.parent.parent.$('#' + campoID);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem2, true, campoTiposDocumentoID);

        if (TIPO_DOC == 'CntCorrLiquidacaoClt') {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'CodigoSistemaTiposDocumento', '', 'CntCorrLiquidacaoClt');
        }
        else if (TIPO_DOC == 'CntCorrLiquidacaoFnd') {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'CodigoSistemaTiposDocumento', '', 'CntCorrLiquidacaoFnd');
        }
       
        return objetoFiltro;
    };

    self.EnviaParametrosModulo = function (objetoFiltro) {
        var elemAux = $('#' + campoHiddenTiposDocumento);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoHiddenTiposDocumento);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoHiddenTiposDocumento);

        return objetoFiltro;
    };

    self.MapasVistasEnviaParametros = function (objetoFiltro) {

        //self.ChamadaMapasVistas();

        var elemAux = $(campoIDMapasVistas);
        var elem = (elemAux.length) ? elemAux : window.parent.$(campoIDMapasVistas);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, 'IDMapasVistas');

        var elemAux1 = $('#' + campoIDModulo);
        var elem1 = (elemAux1.length) ? elemAux1 : window.parent.$('#' + campoIDModulo);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem1, true, 'IDModulo');

        var elemAux2 = $('#' + campoIDTipoDocumento);
        var elem2 = (elemAux2.length) ? elemAux2 : window.parent.$('#' + campoIDTipoDocumento);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem2, true, 'IDSistemaTiposDocumento');

        var elemAux3 = $(campoIDTipoDocumentoFiscal);
        var elem3 = (elemAux3.length) ? elemAux3 : window.parent.$(campoIDTipoDocumentoFiscal);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem3, true, 'IDSistemaTiposDocumentoFiscal');

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IgnoraSubReport', null, true);

        return objetoFiltro;
    };

    self.TiposDocEnviaParams = function (objetoFiltro) {
        var elemAux = $('#' + campoIDTipoDocumento);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDTipoDocumento);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoIDTipoDocumento);

        return objetoFiltro;
    };

    self.EnviaParamsTipoEstados = function (objetoFiltro) {
        var elemAux = $(tipoentidadeestado);
        var elem = (elemAux.length) ? elemAux : window.parent.$(tipoentidadeestado);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true);

        return objetoFiltro;
    };

    self.TreeViewDataBound = function (tree, e) {
        //CREATE MASKED TREE
        if (tree.dataSource.data().length > 0) {
        
            $(tree.element).find('.k-item').css('padding-left', '0px');
            $(tree.element).find('.k-item').css('color', '#333');
        
            for (var i = 0; i < $(tree.element).find('.k-item').length; i++) {
                var checkedNames = $("[name='checkedNodes']")[i];
                if (UtilsVerificaObjetoNotNullUndefinedVazio(checkedNames)) {
                    var element = $("[name='checkedNodes']")[i].outerHTML;
                    var text = $($(tree.element).find('.k-item')[i]).find('.k-in').text()
                    var aux = '<div class=checkbox><label class="checkbox-label">' + text + element + '<span class="checkbox-custom"></span>';
        
                    $($(tree.element).find('.k-item')[i]).find('.k-in').remove();
                    $($(tree.element).find('.k-item')[i]).find('.k-checkbox-wrapper').children(0).remove();
                    $($(tree.element).find('.k-item')[i]).find('.k-checkbox-wrapper').append(aux);
                    $($(tree.element).find('.k-item')[i]).find("input[name='checkedNodes']").addClass('hidden');
                    
                    var objdata = $.grep(tree.dataSource.data(), function (item) {
                        return item.ID == $($(tree.element).find('.k-item')[i]).find('input[type=checkbox]').val();
                    })
        
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(objdata)) {
                        if (objdata.length > 0) {
                            if (objdata[0].enabled === true || self.BloqueiaEntidadeTipoDoc(TIPO_DOC)) {
                                $($(tree.element).find('.k-item')[i]).find('input[type=checkbox]').attr('disabled', 'disabled')
                            }
                        }
                    }
                }
            }
        }
        else {
            $("#EntidadeMaskedTree").attr("hidden", "hidden")
            $('#maskedTree').hide();
        }
    };

    self.BloqueiaEntidadeTipoDoc = function (inTIPO_DOC) {
        var blnResult = false

        switch (inTIPO_DOC) {
            case 'ProdFinal':
            case 'StkReserva':
            case 'StkLibertarReserva':
            case 'ProdCusto':
            case 'ProdCustoEstorno':
                blnResult = true;
                break;

            default:
                blnResult = false;
        }
        return blnResult;
    };

    self.TDSDataBound = function (ddl, e) {
        //$(".spanTeste1").remove();
        //if (tree.dataSource.data().length === 0) {
        //    var span = $('<span />').attr('padding', '0 0 0 16px;').addClass('spanTeste1').html(resources.nao_aplicavel_ao_modulo);
        //    $("#" + campoIDTreeView).append(span);
        //}
        //// change das checkboxes da treeview
        //$(tree.element.find("input[type='checkbox']")).change(function () {
        //    var grid = $("#" + constGFTD).data("kendoGrid");
        //    GrelhaUtilsAtivaDesativaBotoesAcoes(grid, true);
        //})
    };

    self.ModuloChange = function (combo) {
        self.TrataCheckBoxs(['GereStock', 'ReservaStock', 'GereContaCorrente', 'GeraPendente', 'GereCaixasBancos', 'RegistarCosumidorFinal',
            'ControlaPlafondEntidade', 'AnalisesEstatisticas', 'CalculaComissoes', 'AcompanhaBensCirculacao', 'DocNaoValorizado', 'UltimoPrecoCusto', 'Adiantamento'], false, false)

        var dropMapasVistas = KendoRetornaElemento($(campoIDMapasVistas));
        var comboModeloLinha = combo.dataItem();
        var tree = $("#" + campoIDTreeView).data("kendoTreeView");
        var comboCliente = KendoRetornaElemento($('#IDCliente'));
        var campoIDSistemaNaturezas = "#" + "IDSistemaNaturezas";
        var comboNaturezas = KendoRetornaElemento($(campoIDSistemaNaturezas));

        if (acaoForm != 1) {
            self.SetValueOnDropDownList('IDMapasVistas', '')
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(tree))
            tree.dataSource.read();

        MODULO = combo.dataItem().Codigo == undefined ? '' : combo.dataItem().Codigo;
        $('#Modulo').val(MODULO);
        self.TrataModulo();
        self.TrataTabProducao();
        self.GereActFichaTecnicaClique();
        self.BloqueiaDesbloqueiaGenerico('IDMapasVistas', false);
        if ($('#GereStock').is(':checked')) {
            var campoIDSTDPUAux = 'IDSistemaTiposDocumentoPrecoUnitario';
            var campoIDSTDPU = '#' + campoIDSTDPUAux;

            if (MODULO == Modulo.Stocks) {
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '005');
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '005');

                if (TIPO_DOC == 'StkEntStk') {
                    self.SetValueOnDropDownList(campoIDAux2, '002') //002 - Entrada     
                }
                else if (TIPO_DOC == 'StkSaidaStk') {
                    self.SetValueOnDropDownList(campoIDAux2, '003') //003 - Saida
                }
                else if (TIPO_DOC == 'StkTrfArmazCTrans') {
                    self.SetValueOnDropDownList(campoIDAux2, '004') //003 - Transferencia
                }
            }
            else if (MODULO == Modulo.Vendas || MODULO == Modulo.Compras || MODULO == Modulo.SubContratacao) {
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '005');
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '');
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '');
            }
            else if (MODULO == Modulo.Oficina) {
                if (TIPO_DOC == 'SubstituicaoArtigos') {
                    self.SetValueOnDropDownList(campoIDAux2, '003') 
                }
            }
            else {
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '');
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '005');
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '');
            }
        }

        if (MODULO == Modulo.Stocks) {
            self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '003') //003 - Custo médio
            DDLFilterOnDataSource(campoIDSistemaNaturezas, 'Modulo', OperadorEq, MODULO);
            self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', false)
        }
        else if (MODULO == Modulo.Vendas || MODULO == Modulo.Compras || MODULO == Modulo.Producao || MODULO == Modulo.ContaCorrente || MODULO == Modulo.SubContratacao) {
            DDLFilterOnDataSource('#IDSistemaTiposDocumentoPrecoUnitario', campoCod, OperadorNeq, '');
            if (MODULO == Modulo.Vendas) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '005') //003 - Custo médio
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', false)
            }
            else if (MODULO == Modulo.Compras) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '004'); //003 - Custo médio
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', false);
                DDLFilterOnDataSource('#IDSistemaTiposDocumentoPrecoUnitario', campoCod, OperadorNeq, '005');
            }
            else if (MODULO == Modulo.SubContratacao) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '004'); //003 - Custo médio
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', false);
                DDLFilterOnDataSource('#IDSistemaTiposDocumentoPrecoUnitario', campoCod, OperadorNeq, '005');
            }
            else if (MODULO == Modulo.Producao) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '003') //003 - Custo médio
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', false)
            }
            else if (MODULO == Modulo.ContaCorrente) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '001') //003 - Custo médio
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', true)
                
                self.TrataCheckBoxs(['GereContaCorrente'], true, false);
                self.TrataCheckBoxs(['GereCaixasBancos'], false, true)
                self.TrataCamposCusto(false, false);
                self.TrataCamposFinalizacao(false, false);

            }
            else if (MODULO == Modulo.Oficina) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '003') //003 - Custo médio
                DDLFilterOnDataSource(campoIDSistemaNaturezas, 'Modulo', OperadorEq, MODULO);
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', false)
            }
            DDLFilterOnDataSource(campoIDSistemaNaturezas, 'Modulo', OperadorEq, MODULO);
        }
        else {
            self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '') //003 - Custo médio
            self.SetValueOnDropDownList('IDMapasVistas', '')
        }
        KendoRetornaElemento($('#IDSistemaNaturezas')).select(0);
        self.BloqueiaDesbloqueiaNaturezas(true)
        if (UtilsVerificaObjetoNotNullUndefined(dropMapasVistas)) {
            dropMapasVistas.dataSource.read();
        }
        $('#Predefinido').closest('label').html($('#Predefinido').clone()).append(resources.Predefinido)

    };

    self.GuardaDataSourceTreeView = function (treeG, jsonData) {
        var linhas = {};

        linhas['TiposDocumentoTipEntPermDoc'] = [];
        linhas['TiposDocumentoSeries'] = [];

        if (treeG != undefined && $(treeG).data("kendoTreeView") != undefined) {
            var ktreeG = $(treeG).data("kendoTreeView");
            var ktreeGDS = ktreeG.dataSource.data();
            var ktreeGDSLen = ktreeGDS.length;

            for (var i = 0; i < ktreeGDSLen; i++) {
                ktreeGDS[i].DataCriacao = '23-06-1991';
                ktreeGDS[i].DataAlteracao = '23-06-1991';
                ktreeGDS[i].Descricao = ktreeGDS[i].Tipo;
                linhas['TiposDocumentoTipEntPermDoc'].push(ktreeGDS[i]);
            }
        }

        var SerieEmEdicao = $('#SerieEdicao').val();

        if (SerieEmEdicao === "true" || SerieEmEdicao === true) {
            //ObjetosSeries = TiposDocumentosRetornaObjetosSeries();
            if (ObjetosSeries.SeriesAdicionadas.length != 0) {
                for (var i = 0; i < ObjetosSeries.SeriesAdicionadas.length; i++) {
                    linhas['TiposDocumentoSeries'].push(ObjetosSeries.SeriesAdicionadas[i]);
                }
            }
            if (ObjetosSeries.SeriesEditadas.length != 0) {
                for (var i = 0; i < ObjetosSeries.SeriesEditadas.length; i++) {
                    linhas['TiposDocumentoSeries'].push(ObjetosSeries.SeriesEditadas[i]);
                }
            }
            if (ObjetosSeries.SeriesRemovidas.length != 0) {
                for (var i = 0; i < ObjetosSeries.SeriesRemovidas.length; i++) {
                    linhas['TiposDocumentoSeries'].push(ObjetosSeries.SeriesRemovidas[i]);
                }
            }
        }

        $.extend(jsonData, linhas);
    };

    self.RetornaObjetosSeries = function () {
        return ObjetosSeries;
    }

    self.ValidaEspecificaTiposDocumentoSerie = function (grid, data, url) {
        var options = grid.dataSource.transport.options;
        var erros = GrelhaUtilsValida(grid.element);

        if (erros != null) {
            return null;
        }
        if (url !== options.destroy.url) {
            var model = GrelhaRetornaModeloLinha(grid);
            var boolModel = UtilsVerificaObjetoNotNullUndefined(model);

            var linhasRepetidas = $.grep(grid.dataItems(), function (item) {
                return (item.Codigo == model.Codigo && item.uid != model.uid);
            });

            if (linhasRepetidas.length) {
                erros = UtilsAdicionaRegistoArray(erros, resources.serie_existente.replace('{0}', linhasRepetidas[0].Descricao));
            }
            //Valida Série
            var inSerie = model.Codigo;
            if (!ValidaisValidSerie(inSerie)) {
                erros = UtilsAdicionaRegistoArray(erros, resources.ValidaSerie);
            }

            if (erros == null) {
                if (model.SugeridaPorDefeito) {
                    var gridDS = grid.dataSource.view();
                    for (var iCount = 0; iCount < gridDS.length; iCount++) {
                        if (gridDS[iCount][campoCod] !== inSerie) {
                            var cspd = gridDS[iCount][campoSugeridaPorDefeito];
                            if (cspd) {
                                gridDS[iCount][campoSugeridaPorDefeito] = false;
                                gridDS[iCount].dirty = true;
                                GrelhaLinhasColocaLinhaNasLinhasAlteradas(grid.element.attr('id'), gridDS[iCount], estadoEditar);
                            }
                        }
                    }
                }
            }
        }
        return erros;
    };

    self.ValidaEspecificaTiposDocumentoIdiomas = function (grid, data, url) {
        var options = grid.dataSource.transport.options;
        var erros = GrelhaUtilsValida(grid.element);

        if (erros != null) {
            return null;
        }
        var model = GrelhaRetornaModeloLinha(grid);
        var boolModel = UtilsVerificaObjetoNotNullUndefined(model);
        var linhasRepetidas = $.grep(grid.dataItems(), function (item) {
            return (item.IDIdioma == model.IDIdioma && item.uid != model.uid);
        });

        if (linhasRepetidas.length) {
            erros = UtilsAdicionaRegistoArray(erros, resources.idioma_existente.replace('{0}', linhasRepetidas[0].Descricao));
        }
        return erros;
    };

    self.Check = function (tree) {
        var comboCliente = KendoRetornaElemento($('#IDCliente'));
        var grid = $('#' + constGFTD).data("kendoGrid");
        GrelhaUtilsAtivaDesativaBotoesAcoes(grid, true);
        var tree = $("#" + campoIDTreeView).data("kendoTreeView");
        var count = 0;
        var arrTree = tree.dataItems()

        ComboBoxLimpa(comboCliente);
        if (MODULO == Modulo.Stocks) {
            for (var i = 0; i < arrTree.length; i++) {
                if (arrTree[i].checked) {
                    count = count + 1;
                }
            }
            if (count > 0) {
                $('#IDCliente').removeAttr('disabled');
                $('#IDCliente').removeClass('disabled');
                if (UtilsVerificaObjetoNotNullUndefinedVazio(comboCliente)) {
                    comboCliente.element.parent().removeClass('disabled');
                    comboCliente.element.parent().find('.clsF3MInput').removeClass('disabled');
                    comboCliente.enable(true);
                }
            }
            else {
                $('#IDCliente').attr('disabled', 'disabled');
                $('#IDCliente').addClass('disabled');
                if (UtilsVerificaObjetoNotNullUndefinedVazio(comboCliente)) {
                    comboCliente.enable(false);
                    ComboBoxLimpa(comboCliente);
                }
            }
        }
    };

    self.TiposDocChange = function (e) {
        self.TrataCheckBoxs(['GereStock', 'ReservaStock', 'GeraPendente', 'GereContaCorrente', 'GereCaixasBancos', 'RegistarCosumidorFinal',
            'AnalisesEstatisticas', 'CalculaComissoes', 'ControlaPlafondEntidade', 'AcompanhaBensCirculacao', 'DocNaoValorizado', 'UltimoPrecoCusto', 'Adiantamento'], false, false)

        if (acaoForm != 1) {
            self.SetValueOnDropDownList('IDMapasVistas', '')
        }

        TIPO_DOC = e.dataItem().Tipo == undefined ? '' : e.dataItem().Tipo;
        var tree = $("#" + campoIDTreeView).data("kendoTreeView");
        if (UtilsVerificaObjetoNotNullUndefinedVazio(tree)) {
            tree.dataSource.read();
        }
        
        $('#TipoDoc').val(TIPO_DOC);
        self.ValidaDropComunicao(TIPO_DOC);
        if (e.selectedIndex != 0) {
            if (e.dataItem().TipoFiscal == true) {
                self.TiposDocEnviaParams(GrelhaUtilsObjetoFiltro());
                self.EnableOrDisableTipoFiscal(true);
            }
            else {
                self.EnableOrDisableTipoFiscal(false);
            }

            if ($('#IDSistemaTiposLiquidacao').length) {
                if (TIPO_DOC == 'VndFinanceiro' || TIPO_DOC == 'CmpFinanceiro') {
                    DDLEnableOrDisabled('IDSistemaTiposLiquidacao', true);
                    TIPO_DOC == 'VndFinanceiro' ? KendoRetornaElemento($('#IDSistemaTiposLiquidacao')).select(2) : KendoRetornaElemento($('#IDSistemaTiposLiquidacao')).select(3); //Recebimentos
                }
                else if (TIPO_DOC == 'CntCorrLiquidacaoClt' || TIPO_DOC == 'CntCorrLiquidacaoFnd') {
                    DDLEnableOrDisabled('IDSistemaTiposLiquidacao', false);
                }
                else {
                    DDLEnableOrDisabled('IDSistemaTiposLiquidacao', true);
                    KendoRetornaElemento($('#IDSistemaTiposLiquidacao')).enable(false);
                    KendoRetornaElemento($('#IDSistemaTiposLiquidacao')).select(1);
                }
            }
            if (e.dataItem().ActivaPredefTipoDoc == true) {
                $('#Predefinido').closest('label').html($('#Predefinido').clone()).append(resources.PredefinidoTipoDoc)
            }
            else {
                $('#Predefinido').closest('label').html($('#Predefinido').clone()).append(resources.PredefinidoModulo)
            }
        }
        else {
            self.EnableOrDisableTipoFiscal(false);
            if ($('#IDSistemaTiposLiquidacao').length) {
                KendoRetornaElemento($('#IDSistemaTiposLiquidacao')).enable(false);
                KendoRetornaElemento($('#IDSistemaTiposLiquidacao')).select(0);
            }
        }

        if (MODULO == Modulo.Stocks) {
            //self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '003') //003 - Custo médio
            if (TIPO_DOC == 'StkTrfArmazCTrans') {
                DDLFilterOnDataSource("#" + "IDSistemaTiposDocumentoFiscal", 'TipoDoc', OperadorEq, TIPO_DOC);
            }
        }
        else {
            if (TIPO_DOC != '') {
                DDLFilterOnDataSource("#" + "IDSistemaNaturezas", 'TipoDoc', OperadorEq, TIPO_DOC);

                if (MODULO == Modulo.Vendas && (TIPO_DOC == 'VndOrcamento' || TIPO_DOC == 'VndEncomenda')) {
                    DDLFilterOnDataSource("#" + "IDSistemaTiposDocumentoFiscal", 'TipoDoc', OperadorEq, TIPO_DOC);
                }
            } 
        }

        self.TiposDocAux();
    };

    self.TiposDocAux = function () {
        var campoIDSistemaNaturezas = "#" + "IDSistemaNaturezas";
        self.TrataCheckBoxs(['ReservaStock', 'GeraPendente', 'GereContaCorrente', 'GereCaixasBancos', 'RegistarCosumidorFinal',
            'AnalisesEstatisticas', 'CalculaComissoes', 'ControlaPlafondEntidade', 'AcompanhaBensCirculacao', 'DocNaoValorizado', 'UltimoPrecoCusto', 'Adiantamento'], false, false)

        self.TrataCamposReserva(false, false);
        self.TrataCamposCusto(false, false);
        self.TrataCamposFinalizacao(false, false);
        self.TrataCampoQtdOrigem(true, true);
        if (acaoForm != 1) {
             self.SetValueOnDropDownList(campoIDSistemaAcoes, '002'); //AVISA
        }
        self.TrataCampoPrecoUnitario(true, true);
        self.TrataCampoCAE(false, false);
        self.TrataCheckBoxs(['CalculaNecessidades'], false, true);

        if (acaoForm != 1) {
            self.SetValueOnDropDownList('IDMapasVistas', '')
        }
        self.TrataTipoDoc();
        var dropMapasVistas = KendoRetornaElemento($(campoIDMapasVistas));
        self.TrataTabProducao();
        self.GereActFichaTecnicaClique();

        if (MODULO == Modulo.Stocks) {
            //VER CONDIÇÃO
            //CARLOS
            if (TIPO_DOC == 'StkEntStk') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'E', Modulo.Stocks)
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                self.TrataCheckBoxs(['UltimoPrecoCusto'], false, true)
                self.TrataCheckBoxs(['GereStock'], true, false)
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true)
                self.TrataCheckBoxs(['DocNaoValorizado'], false, true)
                $('#IDSistemaTiposDocumentoMovStock').val(2);
            }
            else if (TIPO_DOC == 'StkContagemStock') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'E', Modulo.Stocks)
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                self.TrataCheckBoxs(['UltimoPrecoCusto'], false, true)
                self.TrataCheckBoxs(['GereStock'], true, false)
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true)
                self.TrataCheckBoxs(['DocNaoValorizado'], false, false)
                $('#IDSistemaTiposDocumentoMovStock').val(2);
            }
            else if (TIPO_DOC == 'StkSaidaStk') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'S', Modulo.Stocks)
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                self.TrataCheckBoxs(['GereStock'], true, false);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true)
                self.TrataCheckBoxs(['DocNaoValorizado'], false, true)
                $('#IDSistemaTiposDocumentoMovStock').val(3)
            }
            else if (TIPO_DOC == 'StkTrfArmazCTrans') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'ES', Modulo.Stocks)
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)

                    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                        KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                            return dataItem.Tipo === 'NF';
                        });
                    }
                }
                self.TrataCheckBoxs(['GereStock'], true, false);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true)
                self.TrataCheckBoxs(['DocNaoValorizado'], false, true)
                $('#IDSistemaTiposDocumentoMovStock').val(4)
            }
            else if (TIPO_DOC == 'StkTransfArtComp') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'ES', Modulo.Stocks)
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                self.TrataCheckBoxs(['GereStock'], true, false);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true)
                self.TrataCheckBoxs(['DocNaoValorizado'], false, true)
                $('#IDSistemaTiposDocumentoMovStock').val(4)
            }
            else if (TIPO_DOC == 'StkReserva') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.Stocks);
                    self.BloqueiaDesbloqueiaNaturezas(true);
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001');
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true);
                    self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true);

                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', true);
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '001'); // Não Aplicável 
                }
                self.TrataCheckBoxs(['GereStock'], true, false);
                self.TrataCheckBoxs(['DocNaoValorizado'], true, false);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, false);
                $('#IDSistemaTiposDocumentoMovStock').val(6);
                self.BloqueiaAtivaTreeViewEntidade(true);
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', true);
            }
            else if (TIPO_DOC == 'StkLibertarReserva') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'LR', Modulo.Stocks);
                    self.BloqueiaDesbloqueiaNaturezas(true);
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001');
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true);
                    self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true);

                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', true);
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoPrecoUnitario', '001'); // Não Aplicável
                }
                self.TrataCheckBoxs(['GereStock'], true, false);
                self.TrataCheckBoxs(['DocNaoValorizado'], true, false);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, false);
                $('#IDSistemaTiposDocumentoMovStock').val(7);
                self.BloqueiaAtivaTreeViewEntidade(true);
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoPrecoUnitario', true);
            }
            else {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', '')
                    self.BloqueiaDesbloqueiaNaturezas(true)
                }
                // Ver
                self.TrataCheckBoxs(['GereStock'], false, false);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], false, false)
            }
        }
        else if (MODULO == Modulo.Oficina) {
            if (TIPO_DOC == 'SubstituicaoArtigos') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'ES', Modulo.Oficina, 'SubstituicaoArtigos')
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                self.TrataCheckBoxs(['GereStock'], true, true, true)
                self.TrataCheckBoxs(['DocNaoValorizado'], true, false)
                self.TrataCheckBoxs(['UltimoPrecoCusto', 'GeraPendente', 'GereContaCorrente', 'GereCaixasBancos', 'CalculaComissoes', 'AcompanhaBensCirculacao', 'RegistarCosumidorFinal', 'ReservaStock', 'AnalisesEstatisticas', 'ControlaPlafondEntidade'], false, false)
                $('#IDSistemaTiposDocumentoMovStock').val(1);
                self.TrataCampoNumVias(true, 1);
                self.TrataCheckBoxs(['CalculaNecessidades'], false, false);
            }
        }
        else if (MODULO == Modulo.Vendas) {
            if (TIPO_DOC == 'VndServico') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'R', Modulo.Vendas, 'VndServico')

                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                self.TrataCheckBoxs(['GereStock', 'GeraPendente', 'GereContaCorrente', 'GereCaixasBancos', 'RegistarCosumidorFinal', 'CalculaComissoes', 'AcompanhaBensCirculacao', 'DocNaoValorizado'], false, false)
                self.TrataCheckBoxs(['ReservaStock', 'AnalisesEstatisticas', 'ControlaPlafondEntidade'], false, true);
                $('#IDSistemaTiposDocumentoMovStock').val(1)
            }
            else if (TIPO_DOC == 'VndOrcamento') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'R', Modulo.Vendas, 'VndOrcamento')
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '002')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                        KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                            return dataItem.Tipo === 'OR';
                        });
                    }
                }
              
                $('#IDSistemaTiposDocumentoMovStock').val(1)
                self.TrataCheckBoxs(['GereStock'], false, false)
                self.TrataCheckBoxs(['RegistarCosumidorFinal', 'AnalisesEstatisticas'], false, true);
            }
            else if (TIPO_DOC == 'VndEncomenda') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'R', Modulo.Vendas, 'VndEncomenda')
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '002')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                        KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                            return dataItem.Tipo === 'NE';
                        });
                    }
                }
               
                self.TrataCheckBoxs(['GereStock'], false, false);
                //self.TrataCheckBoxs(['ReservaStock'], true, true);
                //if ($('#ReservaStock').prop('checked')) {
                //    self.TrataCamposReserva(true, true);
                //}
                self.TrataCheckBoxs(['ControlaPlafondEntidade'], false, true);
                $('#IDSistemaTiposDocumentoMovStock').val(1)
            }
            else {
                if (acaoForm != 1) {
                    KendoRetornaElemento($('#IDSistemaNaturezas')).select(0);
                    self.BloqueiaDesbloqueiaNaturezas(true);
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                        KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                            return dataItem.Tipo === '';
                        });
                    }
                }
                //Ver
                self.TrataCheckBoxs(['GereStock'], false, false);
            }
        }
        else if (MODULO == Modulo.Compras) {
            self.TrataCheckBoxs(['UltimoPrecoCusto'], false, true)
            if (TIPO_DOC == 'CmpOrcamento') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'P', Modulo.Compras, 'CmpOrcamento')
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                $('#IDSistemaTiposDocumentoMovStock').val(1)
                self.TrataCheckBoxs(['GereStock'], false, false)
                self.TrataCheckBoxs(['AnalisesEstatisticas'], false, true);
            }
            else if (TIPO_DOC == 'CmpEncomenda') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'P', Modulo.Compras, 'CmpEncomenda')
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                }
                $('#IDSistemaTiposDocumentoMovStock').val(1)
                self.TrataCheckBoxs(['GereStock'], false, false)
                self.TrataCheckBoxs(['AnalisesEstatisticas'], false, true);
            }
            else {
                if (acaoForm != 1) {
                    KendoRetornaElemento($('#IDSistemaNaturezas')).select(0);
                    self.BloqueiaDesbloqueiaNaturezas(true)
                }
                // Ver
                self.TrataCheckBoxs(['GereStock'], false, false)
                self.TrataCheckBoxs(['AnalisesEstatisticas'], false, false);
            }
        }
        else if (MODULO == Modulo.ContaCorrente) {
       
            self.TrataCheckBoxs(['GereContaCorrente'], true, false);
            self.TrataCheckBoxs(['GereCaixasBancos'], false, true)
            self.TrataCamposCusto(false, false);
            self.TrataCamposFinalizacao(false, false);
        }
        else if (MODULO == Modulo.Producao) {
            if (TIPO_DOC == 'ProdFinal') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'E', Modulo.Producao, 'ProdFinal')
                    $('#IDSistemaTiposDocumentoMovStock').val(2);
                    self.BloqueiaDesbloqueiaGenerico(campoIDPrecoUnitario, true);
                    self.SetValueOnDropDownList(campoIDPrecoUnitario, '001'); // Não Aplicável 
                    self.BloqueiaDesbloqueiaGenerico(campoIDSistemaAcoes, true);
                    self.SetValueOnDropDownList(campoIDSistemaAcoes, '001'); // Ignorar 
                    self.BloqueiaDesbloqueiaGenerico(campoIDCAE, true);
                    self.TrataCheckBoxs(['CalculaNecessidades'], false, false);
                }

                self.BloqueiaDesbloqueiaGenerico(campoIDPrecoUnitario, true);
                self.SetValueOnDropDownList(campoIDPrecoUnitario, '001'); // Não Aplicável 
                self.BloqueiaDesbloqueiaGenerico(campoIDSistemaAcoes, true);
                self.SetValueOnDropDownList(campoIDSistemaAcoes, '001'); // Ignorar 
                self.BloqueiaDesbloqueiaGenerico(campoIDCAE, true);
                self.TrataCheckBoxs(['CalculaNecessidades'], false, false);
                self.TrataCamposCusto(false, false);
                self.TrataCamposFinalizacao(false, false);
            }
            else if (TIPO_DOC == 'ProdOrdFab') {
                self.TrataCheckBoxs(['ReservaStock'], true, true);
                if ($('#ReservaStock').prop('checked')) {
                    self.TrataCamposReserva(true, true);
                }
                self.TrataCamposCusto(false, true);
                self.TrataCamposFinalizacao(false, true);
            }
            else if (TIPO_DOC == 'ProdCusto') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'S', Modulo.Producao, 'ProdCusto')
                    $('#IDSistemaTiposDocumentoMovStock').val(3);
                }
            }
            else if (TIPO_DOC == 'ProdCustoEstorno') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownListNatureza('IDSistemaNaturezas', 'E', Modulo.Producao, 'ProdCustoEstorno')
                    $('#IDSistemaTiposDocumentoMovStock').val(2);
                }
            }
        }
        else if (MODULO == Modulo.SubContratacao) {
            if (TIPO_DOC == 'SubContEnvio') {
                if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.SubContratacao)
                    self.BloqueiaDesbloqueiaNaturezas(true)
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', false)
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                        KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                            return dataItem.Tipo === 'GT';
                        });
                    }
                }
                self.TrataCheckBoxs(['GereStock'], true, true, true);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true);
                self.TrataCheckBoxs(['DocNaoValorizado'], true, true, true); 
                $('#IDSistemaTiposDocumentoMovStock').val(4)
            }
            else if (TIPO_DOC == 'SubContRececao') {
                if (acaoForm != 1) {
                    self.EnableOrDisableTipoFiscal(false);
                    self.SetValueOnDropDownList('IDSistemaNaturezas', 'P', Modulo.SubContratacao);
                    self.BloqueiaDesbloqueiaNaturezas(true);
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001');
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true);
                    self.TrataCamposCusto(false, true);
                    self.TrataCamposFinalizacao(false, false);
                }
                self.TrataCheckBoxs(['GereStock'], true, true, true);
                self.TrataCheckBoxs(['AnalisesEstatisticas'], true, true, true);
                self.TrataCheckBoxs(['DocNaoValorizado'], false, true);
                $('#IDSistemaTiposDocumentoMovStock').val(2);
                self.TrataCamposCusto(false, true); 
                self.TrataCamposFinalizacao(false, false);
            }
        }
        if (UtilsVerificaObjetoNotNullUndefined(dropMapasVistas)) {
            dropMapasVistas.dataSource.read();
        }
    }

    self.BloqueiaDesbloqueiaGenerico = function (ddl, bool) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + ddl)))) {
            if (bool) {
                $('#' + ddl).attr('disabled', 'disabled');
                $('#' + ddl).addClass('disabled');
                KendoRetornaElemento($('#' + ddl)).enable(false)
            }
            else {
                $('#' + ddl).removeAttr('disabled');
                $('#' + ddl).removeClass('disabled');
                KendoRetornaElemento($('#' + ddl)).enable(true)
            }
        }
    }

    self.BloqueiaDesbloqueiaNaturezas = function (bool) {

        if (bool) {
            $('#IDSistemaNaturezas').attr('disabled', 'disabled');
            $('#IDSistemaNaturezas').addClass('disabled');
            KendoRetornaElemento($('#IDSistemaNaturezas')).enable(false)
        }
        else {
            $('#IDSistemaNaturezas').removeAttr('disabled');
            $('#IDSistemaNaturezas').removeClass('disabled');
            KendoRetornaElemento($('#IDSistemaNaturezas')).enable(true)
        }
    }

    self.DataBoundNaturezas = function () {

        if (acaoForm == 1) {
            self.SetValueOnDropDownList('IDSistemaNaturezas', $("#NaturVal").val())
        }
    }

    self.TipoFiscalChange = function (e) {
        self.TrataCheckBoxs(['GereStock', 'ReservaStock', 'GeraPendente', 'GereCaixasBancos', 'GereContaCorrente', 'RegistarCosumidorFinal', 'AnalisesEstatisticas',
            'AcompanhaBensCirculacao', 'CalculaComissoes', 'ControlaPlafondEntidade', 'DocNaoValorizado', 'Adiantamento'], false, false)

        if (!$('#ReservaStock').prop('checked')) {
            self.TrataCamposReserva(false, false);
        }

        if (acaoForm == 1) {
            if (MODULO == Modulo.Stocks) {
                DDLFilterOnDataSource("#" + "IDSistemaNaturezas", 'TipoDoc', OperadorEq, MODULO);
            }
            else if (TIPO_DOC != '') {
                DDLFilterOnDataSource("#" + "IDSistemaNaturezas", 'TipoDoc', OperadorEq, TIPO_DOC);
            }
        }

        if ($(campoIDTipoDocumentoFiscal).length && UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($(campoIDTipoDocumentoFiscal)).dataItem().Tipo)) {
            self.TrataCampoQtdOrigem(true, true);
            if (acaoForm != 1) {
                self.SetValueOnDropDownList(campoIDSistemaAcoes, '002'); //AVISA
            }
            
            var tipoDocFisc = KendoRetornaElemento($(campoIDTipoDocumentoFiscal)).dataItem().Tipo;
            TIPO_FISC = tipoDocFisc;

            if (MODULO == Modulo.Compras) {
                if (TIPO_DOC == 'CmpFinanceiro') {
                    if (tipoDocFisc == 'NC') {
                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.Compras, 'CmpFinanceiro')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                        }
                        $('#IDSistemaTiposDocumentoMovStock').val(3)
                    }
                    else {
                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'P', Modulo.Compras, 'CmpFinanceiro')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                        }
                        $('#IDSistemaTiposDocumentoMovStock').val(2)
                    }
                    self.TrataCheckBoxs(['GereStock', 'GereContaCorrente', 'AnalisesEstatisticas'], true, true, true)
                    self.TrataCheckBoxs(['AcompanhaBensCirculacao'], false, true)
                    if (acaoForm != 1) {
                        self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                        self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                    }
                    if (tipoDocFisc == 'NC' || tipoDocFisc == 'ND' || tipoDocFisc == 'FT') {
                        self.TrataCheckBoxs(['GeraPendente'], true, true, true)
                    }
                    if (tipoDocFisc == 'FR' || tipoDocFisc == 'FS') {
                        self.TrataCheckBoxs(['GereCaixasBancos'], true, true, true)
                    }
                }
                else if (TIPO_DOC == 'CmpTransporte') {
                    if (tipoDocFisc == 'GD') {

                        self.TrataCampoNumVias(true, 1);

                        self.TrataCheckBoxs(['AcompanhaBensCirculacao'], false, true);
                        $('#IDSistemaTiposDocumentoMovStock').val(3)

                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.Compras, 'CmpTransporte')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                            if ($('#' + 'AcompanhaBensCirculacao').is(':checked')) {
                                self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', false)
                            }
                            else {
                                self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                            }
                        }
                    }
                    else {

                        self.TrataCampoNumVias(false, 0);

                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'P', Modulo.Compras, 'CmpTransporte')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                            self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                            self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)

                        }
                        else {
                            if ($("#ExisteDocs").val() == "False") {
                                self.BloqueiaDesbloqueiaNaturezas(true)
                            }
                        }
                        $('#IDSistemaTiposDocumentoMovStock').val(2)
                    }
                    self.TrataCheckBoxs(['GereStock'], true, true, true)
                    self.TrataCheckBoxs(['AnalisesEstatisticas', 'DocNaoValorizado'], false, true);
                }
                else if (TIPO_DOC == 'CmpEncomenda') {
                    if ($("#ExisteDocs").val() == false || $("#ExisteDocs").val() == "False") {
                        self.TrataCheckBoxs(['AnalisesEstatisticas'], false, true);
                    }
                }
            }
            else if (MODULO == Modulo.Vendas) {
                if (TIPO_DOC == 'VndFinanceiro') {

                    if (acaoForm == 1) { 
                        self.TrataCampoNumVias(true, 1);
                    }

                    if (tipoDocFisc == 'NC') {
                        self.TrataCheckBoxs(['Adiantamento'], false, false)
                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'P', Modulo.Vendas, 'VndFinanceiro');
                            self.BloqueiaDesbloqueiaNaturezas(true);
                            self.SetValueOnDropDownList(campoIDSistemaAcoes, '003'); // Bloqueia 
                        }
                        $('#IDSistemaTiposDocumentoMovStock').val(2)

                        self.TrataCampoQtdOrigem(false, false);
                        //self.SetValueOnDropDownList(campoIDSistemaAcoes, '003'); // Bloqueia 
                    }
                    else if (tipoDocFisc == 'FR') {
                        self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.Vendas, 'VndFinanceiro');
                        self.BloqueiaDesbloqueiaNaturezas(true);
                        self.TrataCheckBoxs(['Adiantamento'], false, false)
                        $('#IDSistemaTiposDocumentoMovStock').val(3)
                    }
                    else {
                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.Vendas, 'VndFinanceiro')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                        }
                        else {
                            if ($("#ExisteDocs").val() == false || $("#ExisteDocs").val() == "False") {
                                self.BloqueiaDesbloqueiaNaturezas(true)
                            }
                        }
                        if (tipoDocFisc == 'NF') {
                            if (acaoForm != 1) {
                                self.BloqueiaDesbloqueiaNaturezas(false);
                            } else {
                                self.BloqueiaDesbloqueiaNaturezas(true);
                            }
                            var campoIDSistemaNaturezasaux = "#" + "IDSistemaNaturezas";
                            var comboNaturezasaux = KendoRetornaElemento($(campoIDSistemaNaturezasaux));
                            if (comboNaturezasaux.text().toLowerCase() == 'a receber') {
                                $('#IDSistemaTiposDocumentoMovStock').val(TiposDocumentoMovStock.Saida);
                            } else {
                                $('#IDSistemaTiposDocumentoMovStock').val(TiposDocumentoMovStock.Entrada);
                            }

                        } else {
                            $('#IDSistemaTiposDocumentoMovStock').val(TiposDocumentoMovStock.Saida);
                        }
                    }
                    if (tipoDocFisc != 'PF') {
                        self.TrataCheckBoxs(['GereStock', 'GereContaCorrente', 'AnalisesEstatisticas', 'CalculaComissoes', 'ControlaPlafondEntidade'], true, true, true);

                        if (tipoDocFisc == 'FT' || tipoDocFisc == 'FR' || tipoDocFisc == 'FS' || tipoDocFisc == 'ND') {
                            var boolEnable = true;
                            $('#AcompanhaBensCirculacao').attr('disabled', !boolEnable).parent().parent().addClass(boolEnable == true ? '' : 'disabled').removeClass(boolEnable == false ? '' : 'disabled');
                        } else {
                            self.TrataCheckBoxs(['AcompanhaBensCirculacao'], false, true);
                        }

                        if (tipoDocFisc == 'NF') {
                            self.TrataCheckBoxs(['AcompanhaBensCirculacao'], false, false);
                            self.TrataCheckBoxs(['GereStock'], false, true, true);
                            self.TrataCheckBoxs(['GereContaCorrente'], true, true, true);
                            self.TrataCheckBoxs(['UltimoPrecoCusto'], false, false);
                        }
                    } else {
                        $('#IDSistemaTiposDocumentoMovStock').val(1)
                    }
                    if (acaoForm != 1) {
                        self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                        self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                    }
                    if (tipoDocFisc == 'NC' || tipoDocFisc == 'ND' || tipoDocFisc == 'FT' || tipoDocFisc == 'NF') {
                        self.TrataCheckBoxs(['GeraPendente'], true, true, true)
                    }
                    if (tipoDocFisc == 'FR' || tipoDocFisc == 'FS') {
                        self.TrataCheckBoxs(['GereCaixasBancos', 'RegistarCosumidorFinal'], true, true, true)
                    }
                    if (tipoDocFisc == 'NF') {
                        self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoOrigem', true);
                    }
                }
                else if (TIPO_DOC == 'VndTransporte') {

                    if (tipoDocFisc == 'GT' || tipoDocFisc == 'GR' || tipoDocFisc == 'GD') {
                        self.TrataCampoNumVias(true, 1);
                    } else if (tipoDocFisc == 'NF') {
                        self.TrataCampoNumVias(false, 0);
                    }

                    if (tipoDocFisc == 'GD') {
                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'P', Modulo.Vendas, 'VndTransporte')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                            self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                            self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                        }
                        $('#IDSistemaTiposDocumentoMovStock').val(2)
                      
                    }
                    else {
                        if (acaoForm != 1) {
                            self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.Vendas, 'VndTransporte')
                            self.BloqueiaDesbloqueiaNaturezas(true)
                        }
                        if (tipoDocFisc == 'GT' || tipoDocFisc == 'GR' || tipoDocFisc == 'GA') {
                            self.TrataCheckBoxs(['AcompanhaBensCirculacao'], true, true, true)
                            if ($('#' + 'AcompanhaBensCirculacao').is(':checked')) {
                                if (acaoForm != 1) {
                                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', false)
                                }
                            }
                            else {
                                if (acaoForm != 1) {
                                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                                }
                            }
                        }
                        $('#IDSistemaTiposDocumentoMovStock').val(3)
                    }
                    self.TrataCheckBoxs(['GereStock'], true, true, true)
                    self.TrataCheckBoxs(['AnalisesEstatisticas', 'ControlaPlafondEntidade', 'DocNaoValorizado'], false, true)
                }
                else if (TIPO_DOC == 'VndEncomenda') {
                    if ($("#ExisteDocs").val() == false || $("#ExisteDocs").val() == "False") {
                        self.TrataCheckBoxs(['AnalisesEstatisticas'], false, true);
                    }
                    //self.TrataCheckBoxs(['ReservaStock'], true, true, true);
                    //if ($('#ReservaStock').prop('checked')) {
                    //    self.TrataCamposReserva(true, true);
                    //}
                }
            }
            else if (MODULO == Modulo.Producao) {
                if (TIPO_DOC == 'ProdOrdFab') {
                    self.TrataCheckBoxs(['ReservaStock'], true, true, true);
                    if ($('#ReservaStock').prop('checked')) {
                        self.TrataCamposReserva(true, true);
                    }
                    self.TrataCamposCusto(false, true);
                    self.TrataCamposFinalizacao(false, true);
                }
                else if (TIPO_DOC == 'ProdFinal') {
                    self.TrataCamposCusto(false, false);
                    self.TrataCamposFinalizacao(false, false);
                }
            }
            else if (MODULO == Modulo.ContaCorrente) {

                if (TIPO_FISC == 'RG') {
                    self.TrataCampoNumVias(true, 1);
                } else {
                    self.TrataCampoNumVias(false, 0);
                }

                if (TIPO_DOC == 'CntCorrLiquidacaoClt') {
                    if (acaoForm != 1) {
                        self.BloqueiaDesbloqueiaNaturezas(true);
                        self.SetValueOnDropDownList('IDSistemaNaturezas', 'P', Modulo.ContaCorrente, 'CntCorrLiquidacaoClt');
                    }
                }
                else if (TIPO_DOC == 'CntCorrLiquidacaoFnd') {
                    if (acaoForm != 1) {
                        self.BloqueiaDesbloqueiaNaturezas(true);
                        self.SetValueOnDropDownList('IDSistemaNaturezas', 'R', Modulo.ContaCorrente, 'CntCorrLiquidacaoFnd');
                    }
                }
                self.TrataCheckBoxs(['GereContaCorrente'], true, false);
                self.TrataCheckBoxs(['GereCaixasBancos'], false, true)
                self.TrataCamposCusto(false, false);
                self.TrataCamposFinalizacao(false, false);
            }
        }
        else {
            if (acaoForm != 1) {
                self.SetValueOnDropDownList('IDSistemaNaturezas', '')
                //Ver
                self.TrataCheckBoxs(['GereStock'], false, false)
            }
            if (MODULO == Modulo.Vendas) {
                if (TIPO_DOC == 'VndEncomenda') {
                    if ($("#ExisteDocs").val() == false || $("#ExisteDocs").val() == "False") {
                        self.TrataCheckBoxs(['AnalisesEstatisticas'], false, true);
                    }
                    //self.TrataCheckBoxs(['ReservaStock'], true, true, true);
                    //if ($('#ReservaStock').prop('checked')) {
                    //    self.TrataCamposReserva(true, true);
                    //}
                }
            }
            else if (MODULO == Modulo.ContaCorrente) {

                self.TrataCheckBoxs(['GereContaCorrente'], true, false);
                self.TrataCheckBoxs(['GereCaixasBancos'], false, true)
                self.TrataCamposCusto(false, false);
                self.TrataCamposFinalizacao(false, false);
            }
            else if (MODULO == Modulo.Producao) {
                if (TIPO_DOC == 'ProdOrdFab') {
                    self.TrataCheckBoxs(['ReservaStock'], true, true, true);
                    if ($('#ReservaStock').prop('checked')) {
                        self.TrataCamposReserva(true, true);
                    }
                    self.TrataCamposCusto(false, true);
                    self.TrataCamposFinalizacao(false, true);
                }
                else if (TIPO_DOC == 'ProdFinal') {
                    if ($("#ExisteDocs").val() == false || $("#ExisteDocs").val() == "False") {
                        self.TrataCheckBoxs(['AnalisesEstatisticas', 'GereStock'], false, true);
                    }
                }
            }
            else if (MODULO == Modulo.Compras) {
                if (TIPO_DOC == 'CmpEncomenda') {
                    if ($("#ExisteDocs").val() == false || $("#ExisteDocs").val() == "False") {
                        self.TrataCheckBoxs(['AnalisesEstatisticas'], false, true);
                    }
                }
            }
        }
        var dropMapasVistas = KendoRetornaElemento($(campoIDMapasVistas));
        if (UtilsVerificaObjetoNotNullUndefined(dropMapasVistas)) {
            dropMapasVistas.dataSource.read();
        }
        if (acaoForm != 1) {
            self.TrataCampoComunicao();
        }
    };

    self.ValidaDropComunicao = function (tipoDoc) {
        var valorEdicao = $('#EmExecucao').val();
        var ddlTipoDocCom = KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao'));
        if (valorEdicao === constEstados.Adicionar) {
            var SeriesAdicionadas = ObjetosSeries.SeriesAdicionadas;
            if (SeriesAdicionadas.length != 0) {
                // ATRIBUI AO CAMPO COMUNICACAO ABERTO O SEU RESPETIVO VALOR DE ACORDO O TIPO DOC
                self.ValidaTipoDocParaSeries(tipoDoc, ddlTipoDocCom, true);

                for (var i = 0; i < SeriesAdicionadas.length; i++) {
                    if (tipoDoc == 'VndFinanceiro' || tipoDoc == 'CmpFinanceiro') {
                        SeriesAdicionadas[i].IDSistemaTiposDocumentoComunicacao = "2";
                    }
                    else if (tipoDoc == 'VndTransporte' || tipoDoc == 'CmpTransporte') {
                        return false;
                    }
                    else if (tipoDoc != 'VndFinanceiro' || tipoDoc != 'CmpFinanceiro' || tipoDoc != 'VndTransporte' || tipoDoc != 'CmpTransporte') {
                        SeriesAdicionadas[i].IDSistemaTiposDocumentoComunicacao = "1";
                    }
                }
            }
            else {
                self.ValidaTipoDocParaSeries(tipoDoc, ddlTipoDocCom, false);
            }
        }
        else if (valorEdicao === constEstados.Alterar) {
            self.ValidaTipoDocParaSeries(tipoDoc, ddlTipoDocCom, true);
            var SeriesAdicionadas = ObjetosSeries.SeriesAdicionadas;
            var SeriesEditadas = ObjetosSeries.SeriesEditadas;
            if (SeriesAdicionadas.length) {
                self.ValidaTipoDocParaSeries(tipoDoc, ddlTipoDocCom, true);

                for (var i = 0; i < SeriesAdicionadas.length; i++) {
                    if (tipoDoc == 'VndFinanceiro' || tipoDoc == 'CmpFinanceiro') {
                        SeriesAdicionadas[i].IDSistemaTiposDocumentoComunicacao = "2";
                    }
                    else if (tipoDoc == 'VndTransporte' || tipoDoc == 'CmpTransporte') {
                        return false;
                    }
                    else if (tipoDoc != 'VndFinanceiro' || tipoDoc != 'CmpFinanceiro' || tipoDoc != 'VndTransporte' || tipoDoc != 'CmpTransporte') {
                        SeriesAdicionadas[i].IDSistemaTiposDocumentoComunicacao = "1";
                    }
                }
            }
            if (SeriesEditadas.length) {
                self.ValidaTipoDocParaSeries(tipoDoc, ddlTipoDocCom, true);

                for (var i = 0; i < SeriesEditadas.length; i++) {
                    if (tipoDoc == 'VndFinanceiro' || tipoDoc == 'CmpFinanceiro') {
                        SeriesEditadas[i].IDSistemaTiposDocumentoComunicacao = "2";
                    }
                    else if (tipoDoc == 'VndTransporte' || tipoDoc == 'CmpTransporte') {
                        return false;
                    }
                    else if (tipoDoc != 'VndFinanceiro' || tipoDoc != 'CmpFinanceiro' || tipoDoc != 'VndTransporte' || tipoDoc != 'CmpTransporte') {
                        SeriesEditadas[i].IDSistemaTiposDocumentoComunicacao = "1";
                    }
                }
            }
        }
    };

    self.ValidaTipoDocParaSeries = function (tipoDoc, inDDLTipoDocCom, bool) {
        if (UtilsVerificaObjetoNotNullUndefined(inDDLTipoDocCom) && acaoForm != 1) {
            if (bool) {
                if (tipoDoc == "") {
                    if (inDDLTipoDocCom.value() == "") {
                        inDDLTipoDocCom.select(0);
                        inDDLTipoDocCom.enable(true);
                    }
                    else {
                        inDDLTipoDocCom.enable(true);
                        return false;
                    }
                }
                else if (tipoDoc == 'VndFinanceiro' || tipoDoc == 'CmpFinanceiro') {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inDDLTipoDocCom)) {
                        if (inDDLTipoDocCom.value() == "2") {
                            inDDLTipoDocCom.enable(false);
                        }
                        else {
                            inDDLTipoDocCom.value("2");
                            inDDLTipoDocCom.enable(false);
                        }
                    }
                }
                else if (tipoDoc == 'VndTransporte' || tipoDoc == 'CmpTransporte') {
                    if (inDDLTipoDocCom.value() == "") {
                        inDDLTipoDocCom.select(0);
                        inDDLTipoDocCom.enable(true);
                    }
                    else {
                        inDDLTipoDocCom.enable(true);
                        return false;
                    }
                }
                else if (tipoDoc != 'VndFinanceiro' || tipoDoc != 'CmpFinanceiro' || tipoDoc != 'VndTransporte' || tipoDoc != 'CmpTransporte') {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inDDLTipoDocCom)) {
                        if (inDDLTipoDocCom.value() == "1") {
                            inDDLTipoDocCom.enable(false);
                        }
                        else {
                            inDDLTipoDocCom.value("1");
                            inDDLTipoDocCom.enable(false);
                        }
                    }
                }
            }
            else {
                if (tipoDoc == "") {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inDDLTipoDocCom)) {
                        inDDLTipoDocCom.value(0);
                        inDDLTipoDocCom.enable(true);
                    }
                }
                else if (tipoDoc == 'VndFinanceiro' || tipoDoc == 'CmpFinanceiro') {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inDDLTipoDocCom)) {
                        inDDLTipoDocCom.select(2);
                        inDDLTipoDocCom.enable(false);
                    }
                }
                else if (tipoDoc == 'VndTransporte' || tipoDoc == 'CmpTransporte') {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inDDLTipoDocCom)) {
                        inDDLTipoDocCom.value(0);
                        inDDLTipoDocCom.enable(true);
                    }
                }
                else if (tipoDoc != 'VndFinanceiro' || tipoDoc != 'CmpFinanceiro' || tipoDoc != 'VndTransporte' || tipoDoc != 'CmpTransporte') {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inDDLTipoDocCom)) {
                        inDDLTipoDocCom.select(1);
                        inDDLTipoDocCom.enable(false);
                    }
                }
            }
        }
    };

    self.EnableOrDisableTipoFiscal = function (boolEnable) {
        $('#TipoFiscal').val(boolEnable);
        var dropTiposDocFiscal = KendoRetornaElemento($(campoIDTipoDocumentoFiscal));
        var dropTiposDocFiscalParent = $(campoIDTipoDocumentoFiscal).parent();
        var winErrors = $('#' + msgErroID).data('kendoWindow');

        if (boolEnable == true) {
            dropTiposDocFiscalParent.addClass('obrigatorio');
            dropTiposDocFiscal.element.addClass('obrigatorio');
            dropTiposDocFiscal.element.attr(constRequired, constRequired);

            dropTiposDocFiscal.dataSource.read();
            dropTiposDocFiscal.enable(true);
        }
        else {
            dropTiposDocFiscal.value(0);
            dropTiposDocFiscal.enable(false);

            dropTiposDocFiscalParent.parent().find('.input-error').removeClass('input-error');
            dropTiposDocFiscalParent.parent().find('.obrigatorio').removeClass('obrigatorio');
            dropTiposDocFiscal.element.removeClass('k-invalid');
            dropTiposDocFiscal.element.removeAttr(constRequired);
        }
        if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
            if (winErrors.options.visible == true) {
                GrelhaUtilsValida($('.' + constFormularioPrincipal));
            }
        }
    };

    self.TrataCheckBoxs = function (array, boolChecked, boolEnable, boolIgnorarEstado) {
        var check;
        for (var i = 0; i < array.length; i++) {

            check = false;

            if (!((array[i] == "GereStock" || array[i] == "GereContaCorrente" || array[i] == "GeraPendente" || array[i] == "GereCaixasBancos" ||
                array[i] == "AcompanhaBensCirculacao" || array[i] == "DocNaoValorizado") && $("#ExisteDocs").val() == "True" && acaoForm == 1)) {

                if ($('#' + array[i]).is(':checked')) {
                    check = true;
                }
                if (acaoForm == 0) {
                    $('#' + array[i]).prop('checked', boolIgnorarEstado ? boolChecked : boolEnable == true ? $('#' + array[i]).is(':checked') : boolChecked);
                }
                $('#' + array[i]).attr('disabled', !boolEnable).parent().parent().addClass(boolEnable == true ? '' : 'disabled').removeClass(boolEnable == false ? '' : 'disabled');

                if (check && acaoForm == 1) {
                    $('#' + array[i]).prop('checked', true)
                }

                array[i] == 'GereStock' ? $('#' + array[i]).is(':checked') ? self.EnableOrDisableTabs(true, false) : self.EnableOrDisableTabs(false, false) : false;

                //if (array[i] == 'AcompanhaBensCirculacao' && acaoForm == 1) {
                //    self.AcompanhaBensCirculacaoClique(($('#AcompanhaBensCirculacao').is(':checked')))
                //}
            }
        }
    };


    self.TrataModulo = function () {
        var IvaSeries = ['IVAIncluido', 'IVARegimeCaixa'];
        var comboCliente = KendoRetornaElemento($('#IDCliente'));

        if (MODULO != '') {
            if (MODULO == Modulo.Stocks) {
                //$('#IDCliente').removeAttr('disabled');
                //$('#IDCliente').removeClass('disabled');
                //if (UtilsVerificaObjetoNotNullUndefinedVazio(comboCliente)) {
                //    comboCliente.element.parent().removeClass('disabled');
                //    comboCliente.element.parent().find('.clsF3MInput').removeClass('disabled');
                //    comboCliente.enable(true);
                //}
            }
            else {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(comboCliente)) {
                    comboCliente.enable(false);
                    ComboBoxLimpa(comboCliente);
                }
                $('#IDCliente').attr('disabled', 'disabled');
                $('#IDCliente').addClass('disabled');
            }
        }
        else {
            if (UtilsVerificaObjetoNotNullUndefinedVazio(comboCliente)) {
                comboCliente.enable(false);
                ComboBoxLimpa(comboCliente);
            }
            $('#IDCliente').attr('disabled', 'disabled');
            $('#IDCliente').addClass('disabled');
            self.TrataCheckBoxs(allChecks, false, false);
        }
        if (MODULO == Modulo.Vendas || MODULO == Modulo.Compras || MODULO == Modulo.Producao || MODULO == Modulo.ContaCorrente || MODULO == Modulo.Stocks || MODULO == Modulo.SubContratacao || MODULO == Modulo.Oficina) {
            $("#EntidadeMaskedTree").removeAttr("hidden")
            $('#maskedTree').show();

            if (MODULO == Modulo.Producao || MODULO == Modulo.SubContratacao) {
                if (TIPO_DOC == 'ProdOrdFab' || TIPO_DOC == 'SubContRececao') {
                    self.TrataCamposCusto(false, true);

                    if (TIPO_DOC == 'ProdOrdFab') {
                        self.TrataCamposFinalizacao(false, true);
                    }

                } else {
                    self.TrataCamposCusto(false, false);
                    self.TrataCamposFinalizacao(false, false);
                }
            } else {
                self.TrataCamposCusto(false, false);
                self.TrataCamposFinalizacao(false, false);
            }
        }
        else {
            $("#EntidadeMaskedTree").attr("hidden", "hidden")
            $('#maskedTree').hide();
        }

        if (MODULO === Modulo.ContaCorrente && TIPO_DOC === "CntCorrLiquidacaoClt" && $('#AcaoFormSeries').val() === constEstados.Adicionar) {
            self.TrataCheckBoxs(IvaSeries, false, false);
            $('#IVAIncluido').prop('checked', true);
        }
        else {
            if (MODULO != Modulo.Vendas && MODULO != Modulo.Compras) {
                self.TrataCheckBoxs(IvaSeries, false, false);
                if (MODULO == Modulo.Stocks) {
                    $('#IVAIncluido').prop('checked', false);
                }
            }
            else {
                self.TrataCheckBoxs(IvaSeries, false, true);
            }
        }
        if (MODULO === Modulo.Oficina ) {
            self.TrataCheckBoxs(['UltimoPrecoCusto'], false, false)
            self.TrataCheckBoxs(['CalculaNecessidades'], false, false);
        }
        if (MODULO == Modulo.Vendas && $('#IDLoja').length == 0) {
            $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
        }
    };

    self.TrataTipoDoc = function () {
        var gereStock = ['GereStock'];
        var gereContaCorrente = ['GereContaCorrente'];
        var gereCaixasBancos = ['GereCaixasBancos'];
        var docNaoValorizado = ['DocNaoValorizado'];
        var acompBensCirculacao = ['AcompanhaBensCirculacao'];
        var entregCliente = ['EntregueCliente'];
        var IvaSeries = ['IVAIncluido', 'IVARegimeCaixa'];
        var analisesEstatisticas = ['AnalisesEstatisticas'];
        var ultimoPrecoCusto = ['UltimoPrecoCusto'];
        var comboCliente = KendoRetornaElemento($('#IDCliente'));
        var reservaStock = ['ReservaStock'];

        if (TIPO_DOC != '') {
            self.BloqueiaAtivaTreeViewEntidade(false);
            if (acaoForm != 1) {
                self.TrataCampoNumVias(false, 0);
            }

            (TIPO_DOC == 'CntCorrLiquidacaoClt' || TIPO_DOC == 'CntCorrLiquidacaoFnd') ? self.TrataCheckBoxs(gereCaixasBancos, false, true) : self.TrataCheckBoxs(gereCaixasBancos, false, false);
            if (TIPO_DOC == 'ProdOrdFab' && MODULO == Modulo.Producao) {
                self.TrataCheckBoxs(acompBensCirculacao, false, false);
                self.TrataCheckBoxs(entregCliente, false, false);
            }
            if (TIPO_DOC == 'ProdFinal' && MODULO == Modulo.Producao) {
                self.TrataCheckBoxs(gereStock, true, true, true);
                self.TrataCheckBoxs(analisesEstatisticas, true, true, true);
                self.TrataCheckBoxs(ultimoPrecoCusto, false, true, true);
                self.BloqueiaAtivaTreeViewEntidade(true);
            }
            if (MODULO == Modulo.Producao && (TIPO_DOC == 'ProdCusto' || TIPO_DOC == 'ProdCustoEstorno')) {
                self.TrataCheckBoxs(gereStock, true, true, true);
                self.TrataCheckBoxs(analisesEstatisticas, true, true, true);
                self.BloqueiaAtivaTreeViewEntidade(true);
            }
            if (MODULO == Modulo.Stocks) {
                self.TrataCheckBoxs(entregCliente, false, false);
                if (TIPO_DOC == 'StkTrfArmazCTrans') {
                    self.TrataCheckBoxs(acompBensCirculacao, false, true);
                }
                else {
                    self.TrataCheckBoxs(acompBensCirculacao, false, false);
                }
            }

            if (MODULO == Modulo.SubContratacao) {
                self.TrataCheckBoxs(entregCliente, false, false);
                if (TIPO_DOC == 'SubContEnvio') {
                    self.TrataCheckBoxs(acompBensCirculacao, true, true, true);
                    self.TrataCampoNumVias(true, 1);
                }
                else {
                    self.TrataCheckBoxs(acompBensCirculacao, false, false);
                }
            }

            if (TIPO_DOC == 'ProdOrdFab') {
                self.TrataCheckBoxs(reservaStock, true, true, true);
            } else {
                self.TrataCheckBoxs(reservaStock, false, false);
            }

            if (MODULO == Modulo.Stocks || MODULO == Modulo.Compras || MODULO == Modulo.Vendas || MODULO == Modulo.Producao) {
                if (TIPO_DOC == 'CmpOrcamento' || TIPO_DOC == 'VndOrcamento' || TIPO_DOC == 'CmpEncomenda' || TIPO_DOC == 'VndEncomenda' || TIPO_DOC == 'ProdOrdFab') {
                    self.TrataCheckBoxs(gereStock, false, false);
                    if (TIPO_DOC == 'VndOrcamento' || TIPO_DOC == 'VndEncomenda') {
                        self.TrataCampoNumVias(true, 1);
                    }
                }
                else if (TIPO_DOC == 'VndFinanceiro' && MODULO == Modulo.Vendas) {
                    self.TrataCampoNumVias(true, 1);
                }            
            }
            else {
                self.TrataCheckBoxs(gereStock, false, false);
            }
            if (MODULO != Modulo.Vendas && MODULO != Modulo.Compras) {
                self.TrataCheckBoxs(IvaSeries, false, false);
            }
            else {
                self.TrataCheckBoxs(IvaSeries, false, true);
            }
            if (MODULO == Modulo.Vendas && $('#IDLoja').length == 0) {
                $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
            }
            // Se o tipo de documento não é de stocks, a check box dos bens em circulação não pode estar selecionada nem disponível para leitura
            if (MODULO != Modulo.Stocks) {
                //self.TrataCheckBoxs(acompBensCirculacao, false, false);
            };
            if (acaoForm != 1) {
                 self.TrataCampoComunicao();
            }
           
        }
        else {
            self.TrataModulo();
        }
    };

    // Bloqueia ou Ativa a treeview da entidade 
    self.BloqueiaAtivaTreeViewEntidade = function (boolBloquear) {
        if (boolBloquear) {
            $('#' + campoIDTreeView + ' input').attr(btClassDisabled, btClassDisabled);
        } else {
            if ($('#' + campoIDTreeView + ' input').attr(btClassDisabled) === btClassDisabled) {
                $('#' + campoIDTreeView + ' input').removeAttr(btClassDisabled, btClassDisabled);
            }
        }
    };

    // Bloqueia ou Ativa a treeview dos stocks 
    self.BloqueiaAtivaTreeViewStocks = function (boolBloquear) {
        if (boolBloquear) {
            $('#QtdPositivas' + ' input').attr(btClassDisabled, btClassDisabled);
        } else {
            if ($('#QtdPositivas' + ' input').attr(btClassDisabled) === btClassDisabled) {
                $('#QtdPositivas' + ' input').removeAttr(btClassDisabled, btClassDisabled);
            }
        }
    };

    self.TrataTabProducao = function () {
        // Se o módulo é produção
        if (MODULO == Modulo.Producao) {
            // Ativa a tab da produção
            $('a[href="#tabProducao"]').parent().removeClass('disabled');
            $('a[href="#tabProducao"]').removeClass('disabled');
            // Se o tipo de documento é ordem de fabrico
            if (TIPO_DOC == 'ProdOrdFab') {
                self.TrataCheckBoxs(['ReservaStock'], true, true);
            }
            else {
                // Desmarca a check box de atualização da ficha técnica
                self.TrataChecks("AtualizaFichaTecnica", false);
                // Desativa a tab da produção
                $('a[href="#tabProducao"]').parent().addClass('disabled');
                $('a[href="#tabProducao"]').addClass('disabled');
            }
        }
        else {
            // Desmarca a check box de atualização da ficha técnica
            self.TrataChecks("AtualizaFichaTecnica", false);
            // Desativa a tab da produção
            $('a[href="#tabProducao"]').parent().addClass('disabled');
            $('a[href="#tabProducao"]').addClass('disabled');
        }
    };

    self.AvisaAsDefault = function (e) {
        acaoForm == 0 ? e.sender.select(2) : false;
    };

    self.TrataTiposLiquidacao = function (e) {
        if (acaoForm == 0) {
            e.sender.enable(false);
        }
        else {
            if (TIPO_DOC == 'CntCorrLiquidacaoClt' || TIPO_DOC == 'CntCorrLiquidacaoFnd') {
                e.sender.enable(false);
            }
            else {
                self.ddlObrigatorio('IDSistemaTiposLiquidacao');
                (TIPO_DOC == 'VndFinanceiro' || TIPO_DOC == 'CmpFinanceiro') ? e.sender.enable(true) : e.sender.enable(false);
            }
        }
    };

    self.TrataViewSeries = function (code) {
        var urlAux = window.location.pathname.replace('/IndexGrelha', '') + 'Series';
        var dataAux = {
            vistaParcial: true,
            ID: code != undefined ? parseInt(code) : 0,
            defaultSerie: $('#SeriePorDefeito').val(),
            tipoDoc: TIPO_DOC
        };
        UtilsChamadaAjax(urlAux, true, dataAux,
            function (res) {
                if (res != undefined && res != null) {
                    var elem = $('#OpcaoSeries')
                    elem.html(res);
                    self.ValidaTipoDocParaSeries($('#TipoDoc').val(), KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao')), true);
                    //$('#ExisteUltimoDoc').val() == 'False' ? TiposDocumentoSeriesTrataDataUltimoDoc() : false;
                    KendoLoading($('#OpcaoSeries'), false);

                    self.TrataModulo();
                    self.TrataNumeroVias();

                    if (UtilsVerificaObjetoNotNullUndefined(KendoRetornaElemento($('#IDModulo')))) {
                        if (KendoRetornaElemento($('#IDModulo')).value() == "0") {
                            DDLFilterOnDataSource('#IDMapasVistas', campoCod, OperadorNeq, '');
                        }
                    }

                    var tipoDocFisc = KendoRetornaElemento($(campoIDTipoDocumentoFiscal)).dataItem().Tipo;
                    if (tipoDocFisc == 'NF' && $('#TipoDoc').val() == 'VndFinanceiro') {
                        self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoOrigem', true);
                        self.BloqueiaCampoFiscalComunica('001', true); //Não Comunica
                    }

                    if (acaoForm == 1) {
                        if (UtilsVerificaObjetoNotNullUndefinedVazio(ObjetosSeries.SeriesEditadas)) {
                            if (UtilsVerificaObjetoNotNullUndefinedVazio($('#div_Results').find('.active').attr('id'))) {
                                var lngIDSerieAtiva = parseInt($('#div_Results').find('.active').attr('id'));
                                var objSerieAtiva = $.grep(ObjetosSeries.SeriesEditadas, function (obj) {
                                    return obj.ID === lngIDSerieAtiva;
                                });
                                if (UtilsVerificaObjetoNotNullUndefinedVazio(objSerieAtiva)) {
                                    if (objSerieAtiva.length > 0) {
                                        var strCodigoComunicacao = objSerieAtiva[0].CodigoSistemaTiposDocumentoComunicacao;
                                        var cbComunicao = KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao'));

                                        if (UtilsVerificaObjetoNotNullUndefinedVazio(cbComunicao)) {
                                            cbComunicao.dataSource.fetch(function () {
                                                if (UtilsVerificaObjetoNotNullUndefinedVazio(cbComunicao.dataItem())) {
                                                    var data = this.data();

                                                    cbComunicao.select(function (dataItem) {
                                                        return dataItem.Codigo == strCodigoComunicacao;
                                                    });
                                                }
                                            });
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //self.TrataCampoComunicao();
                }
            }, function (fv) {
                KendoLoading($('#OpcaoSeries'), false);
            }, 1, true, null, null, 'html', 'GET');
    };

    self.TrataNumeroVias = function () {
        var tipoDocFisc = KendoRetornaElemento($(campoIDTipoDocumentoFiscal)).dataItem().Tipo;

        if (MODULO == Modulo.Stocks && TIPO_DOC == 'StkTrfArmazCTrans') {
            if ($('#' + 'AcompanhaBensCirculacao').is(':checked')) {
                self.TrataCampoNumVias(true, 1);
            }
        } else if (MODULO == Modulo.Vendas) {
            if (TIPO_DOC == 'VndTransporte') {
                if (tipoDocFisc == 'GT' || tipoDocFisc == 'GR' || tipoDocFisc == 'GD') {
                    self.TrataCampoNumVias(true, 1);
                }
            } else if (TIPO_DOC == 'VndFinanceiro') {
                self.TrataCampoNumVias(true, 1);
            }

        } else if (MODULO == Modulo.Compras) {
            if (TIPO_DOC == 'CmpTransporte' && tipoDocFisc == 'GD') {
                self.TrataCampoNumVias(true, 1);
            }

        } else if (MODULO == Modulo.SubContratacao) {
            if (TIPO_DOC == 'SubContEnvio') {
                self.TrataCampoNumVias(true, 1);
            }
        } else if (MODULO == Modulo.ContaCorrente) {
            if (tipoDocFisc == 'RG') {
                self.TrataCampoNumVias(true, 1);
            }
        }
    };

    self.FiscalDataBound = function (e) {
        var dropTiposDocFiscal = KendoRetornaElemento($(campoIDTipoDocumentoFiscal));
        var dropTiposDocFiscalParent = $(campoIDTipoDocumentoFiscal).parent();

        if ($('#TipoFiscal').val() == 'True' || $('#TipoFiscal').val() == "true") {
            if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTiposDocFiscalParent)) {
                dropTiposDocFiscalParent.addClass('obrigatorio');
            }

            if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTiposDocFiscal)) {
                dropTiposDocFiscal.element.addClass('obrigatorio');
                dropTiposDocFiscal.element.attr(constRequired, constRequired);
                dropTiposDocFiscal.enable(true);
            }
        }
        else {
            if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTiposDocFiscal)) {
                dropTiposDocFiscal.enable(false);
            }
        }
        if (acaoForm == 1) {
            DDLDisabledComValor('#IDSistemaTiposDocumentoFiscal', $('#IDSistemaTiposDocumentoFiscal').val());
        }
        if (MODULO != Modulo.Stocks && TIPO_DOC != 'VndEncomenda' && TIPO_DOC != 'VndOrcamento' && TIPO_DOC != 'CmpOrcamento' && MODULO != Modulo.SubContratacao) {
            self.TipoFiscalChange(e.sender);
        }
        else {
            self.TiposDocAux();
        }
    };

    self.AcompanhaBensCirculacaoClique = function (boolChecked) {
        var comboCliente = KendoRetornaElemento($('#IDCliente'));
        var comboComunica = KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao'));
        var tipoDocFisc = KendoRetornaElemento($(campoIDTipoDocumentoFiscal)).dataItem().Tipo;
        var SeriesAdicionadas = ObjetosSeries.SeriesAdicionadas;
        var SeriesEditadas = ObjetosSeries.SeriesEditadas;
        var dropTipoDocComunicacao = KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao'));
        var objTipoDocComunica = null;

        if (boolChecked) {
            if (MODULO == Modulo.Vendas && TIPO_DOC == 'VndTransporte') {
                if (tipoDocFisc == 'GT' || tipoDocFisc == 'GR' || tipoDocFisc == 'GA') {
                    //if (acaoForm != 1) {
                        self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                        $('#IDSistemaTiposDocumentoComunicacao').removeAttr('disabled').removeClass('disabled');
                        comboComunica.enable(true);
                    //}
                }
            }
            if (MODULO == Modulo.Compras && TIPO_DOC == 'CmpTransporte') {
                if (tipoDocFisc == 'GD') {
                    //if (acaoForm != 1) {
                        self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                        $('#IDSistemaTiposDocumentoComunicacao').removeAttr('disabled').removeClass('disabled');
                        comboComunica.enable(true);
                    //}
                }
            }
            if (TIPO_DOC == 'StkTrfArmazCTrans') {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                $('#IDSistemaTiposDocumentoComunicacao').removeAttr('disabled').removeClass('disabled');
                comboComunica.enable(true);

                if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                    KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                        return dataItem.Tipo === 'GT';
                    });
                }
            }
            if (MODULO == Modulo.SubContratacao && TIPO_DOC == 'SubContEnvio') {
                //if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '003')
                    $('#IDSistemaTiposDocumentoComunicacao').removeAttr('disabled').removeClass('disabled');
                    comboComunica.enable(true);
                //}
                if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                    KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                        return dataItem.Tipo === 'GT';
                    });
                }
            }

            if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTipoDocComunicacao)) {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTipoDocComunicacao.dataSource.data()) && dropTipoDocComunicacao.dataSource.data().length > 0) {
                    objTipoDocComunica = $.grep(dropTipoDocComunicacao.dataSource.data(), function (obj) {
                        return obj.Codigo === "003";
                    })
                }
            }
            //self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)

            if (MODULO == Modulo.SubContratacao && TIPO_DOC == 'SubContRececao') {
                //if (acaoForm != 1) {
                    self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                    self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
                //}

                if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTipoDocComunicacao)) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTipoDocComunicacao.dataSource.data()) && dropTipoDocComunicacao.dataSource.data().length > 0) {
                        objTipoDocComunica = $.grep(dropTipoDocComunicacao.dataSource.data(), function (obj) {
                            return obj.Codigo === "001";
                        })
                    }
                }
            }

            if (MODULO == Modulo.Stocks && TIPO_DOC == 'StkTrfArmazCTrans') {                
                self.TrataCampoNumVias(true, 1);
            }
        }
        else {

            if (MODULO == Modulo.Stocks && TIPO_DOC == 'StkTrfArmazCTrans') {                
                self.TrataCampoNumVias(false, 0);
            }

            if (TIPO_DOC == 'StkTrfArmazCTrans') {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')))) {
                    KendoRetornaElemento($('#IDSistemaTiposDocumentoFiscal')).select(function (dataItem) {
                        return dataItem.Tipo === 'NF';
                    });
                }
            }
            //if (acaoForm != 1) {
                self.SetValueOnDropDownList('IDSistemaTiposDocumentoComunicacao', '001')
                self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true)
            //}

            if (UtilsVerificaObjetoNotNullUndefinedVazio(dropTipoDocComunicacao.dataSource.data()) && dropTipoDocComunicacao.dataSource.data().length > 0) {
                objTipoDocComunica = $.grep(dropTipoDocComunicacao.dataSource.data(), function (obj) {
                    return obj.Codigo === "001";
                })
            }
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(objTipoDocComunica)) {
            if (UtilsVerificaObjetoNotNullUndefinedVazio(SeriesEditadas)) {
                for (var ind = 0; ind < SeriesEditadas.length; ind++) {
                    var objSerieEditada = SeriesEditadas[ind];
                    objSerieEditada.DescricaoSistemaTiposDocumentoComunicacao = objTipoDocComunica[0].Descricao;
                    objSerieEditada.IDSistemaTiposDocumentoComunicacao = objTipoDocComunica[0].ID;
                    objSerieEditada.NumeroVias = $('#' + campoIDNumVias).val();
                }
            }
            if (UtilsVerificaObjetoNotNullUndefinedVazio(SeriesAdicionadas)) {
                for (var fnd = 0; fnd < SeriesAdicionadas.length; fnd++) {
                    var objSerieAdicionada = SeriesAdicionadas[ind];
                    objSerieAdicionada.DescricaoSistemaTiposDocumentoComunicacao = objTipoDocComunica[0].Descricao;
                    objSerieAdicionada.IDSistemaTiposDocumentoComunicacao = objTipoDocComunica[0].ID;
                    objSerieAdicionada.NumeroVias = $('#' + campoIDNumVias).val();
                }
            }
           
        }
    };

    self.GereStockClique = function (boolGereStock) {
        self.EnableOrDisableTabs(boolGereStock, false);

        if (boolGereStock) {
            var campoIDSTDPUAux = 'IDSistemaTiposDocumentoPrecoUnitario';
            var campoIDSTDPU = '#' + campoIDSTDPUAux;

            var campoIDRuturaAux = 'IDSistemaAcoesRupturaStock';
            var campoIDRutura = '#' + campoIDRuturaAux;

            var campoIDStockMinAux = 'IDSistemaAcoesStockMinimo';
            var campoIDStockMin = '#' + campoIDStockMinAux;

            var campoIDStockMaxAux = 'IDSistemaAcoesStockMaximo';
            var campoIDStockMax = '#' + campoIDStockMaxAux;

            //var campoIDRepStockAux = 'IDSistemaAcoesReposicaoStock';
            //var campoIDRepStock = '#' + campoIDRepStockAux;

            if (MODULO == Modulo.Stocks) {
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '005');
                setTimeout(function () {
                    //self.SetValueOnDropDownList(campoIDSTDPUAux, '003') //003 - Custo médio
                    self.SetValueOnDropDownList(campoIDRuturaAux, '002') //002 - Avisa
                    self.SetValueOnDropDownList(campoIDStockMinAux, '002') //002 - Avisa
                    self.SetValueOnDropDownList(campoIDStockMaxAux, '002') //002 - Avisa
                    //self.SetValueOnDropDownList(campoIDRepStockAux, '002') //002 - Avisa
                }, 600);
            }
            else if (MODULO == Modulo.Vendas || MODULO == Modulo.Compras || MODULO == Modulo.SubContratacao || MODULO == Modulo.Oficina) {
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '');

                setTimeout(function () {
                    //self.SetValueOnDropDownList(campoIDSTDPUAux, '005') //005 - Definido para a entidade
                    self.SetValueOnDropDownList(campoIDRuturaAux, '002') //002 - Avisa
                    self.SetValueOnDropDownList(campoIDStockMinAux, '002') //002 - Avisa
                    self.SetValueOnDropDownList(campoIDStockMaxAux, '002') //002 - Avisa
                    //self.SetValueOnDropDownList(campoIDRepStockAux, '002') //002 - Avisa
                }, 600);
            }
            else {
                DDLFilterOnDataSource(campoIDSTDPU, campoCod, OperadorNeq, '');
            }
        }
    };

    self.GereActFichaTecnicaClique = function () {
        var objEstado = KendoRetornaElemento($('#IDEstado'));
        if (UtilsVerificaObjetoNotNullUndefined(objEstado)) {
            if ($('#AtualizaFichaTecnica').is(':checked')) {
                objEstado.enable(true);
                // O estado passa a obrigatório
                objEstado.element.parent().addClass('obrigatorio');
                objEstado.element.parent().find('.clsF3MInput').addClass('obrigatorio');
                objEstado.element.attr(constRequired, constRequired);
            }
            else {
                objEstado.enable(false);
                objEstado.value("");
                // O estado deixa de ser obrigatório
                objEstado.element.parent().removeClass('obrigatorio');
                objEstado.element.parent().find('.input-error').removeClass('input-error');
                objEstado.element.parent().find('.obrigatorio').removeClass('obrigatorio');
                objEstado.element.parent().find('.k-invalid').removeClass('k-invalid');
                objEstado.element.removeAttr(constRequired);
            }
        }
    };

    self.EnableOrDisableTabs = function (blnEnableTabStock, blnEnableTabContaCorrente) {
        if (blnEnableTabStock) {
            $('a[href="#tabStocks"]').parent().removeClass('disabled');
            $('a[href="#tabStocks"]').removeClass('disabled');
            DDLEnableOrDisabled('IDSistemaAcoesRupturaStock', true);
            DDLEnableOrDisabled('IDSistemaAcoesStockMinimo', true);
            DDLEnableOrDisabled('IDSistemaAcoesStockMaximo', true);
            //DDLEnableOrDisabled('IDSistemaAcoesReposicaoStock', true);
            //DDLEnableOrDisabled('IDSistemaTiposDocumentoPrecoUnitario', true);

        } else {
            $('a[href="#tabStocks"]').parent().addClass('disabled');
            $('a[href="#tabStocks"]').addClass('disabled');
            DDLEnableOrDisabled('IDSistemaTiposDocumentoMovStock', false);
            DDLEnableOrDisabled('IDSistemaAcoesRupturaStock', false);
            DDLEnableOrDisabled('IDSistemaAcoesStockMinimo', false);
            DDLEnableOrDisabled('IDSistemaAcoesStockMaximo', false);
            //DDLEnableOrDisabled('IDSistemaAcoesReposicaoStock', false);
            //DDLEnableOrDisabled('IDSistemaTiposDocumentoPrecoUnitario', false);
            self.TrataChecksStocksValoresPorDefeito(true);
        }
    }

    self.ClickTabStocks = function (tab) {
        tab.on('click', function (e) {
            self.ComportamentosTabStocks();
        });
    };

    self.ComportamentosTabStocks = function () {
        //STOCKS LINHAS POSITIVAS
        DDLEnableOrDisabled('IDSistemaAcoesRupturaStock', true);
        DDLEnableOrDisabled('IDSistemaAcoesStockMinimo', true);
        DDLEnableOrDisabled('IDSistemaAcoesStockMaximo', true);
        //DDLEnableOrDisabled('IDSistemaAcoesReposicaoStock', true);
        //DDLEnableOrDisabled('IDSistemaTiposDocumentoPrecoUnitario', true);
        if (MODULO == Modulo.Stocks) {
            $('#QtdPositivas').removeClass("col-6 col-f3m").addClass("col-12 col-f3m");
            self.BloqueiaAtivaTreeViewStocks(false);

            if (TIPO_DOC == 'StkReserva' || TIPO_DOC == 'StkLibertarReserva') {
                self.BloqueiaAtivaTreeViewStocks(true);
            }
        }
        else if (MODULO != Modulo.Stocks && (MODULO != Modulo.ContaCorrente || TIPO_DOC != 'CntCorrLiquidacaoClt' || TIPO_DOC != 'CntCorrLiquidacaoFnd')) {
            if ($('#QtdPositivas').hasClass("col-12")) {
                $('#QtdPositivas').removeClass("col-12").addClass("col-6");
            };
        }
    };

    self.ClickTabProducao = function (tab) {
        tab.on('click', function (e) {
            var winErrors = $('#' + msgErroID).data('kendoWindow');
            self.GereActFichaTecnicaClique();

            if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
                if (winErrors.options.visible == true) {
                    GrelhaUtilsValida($('.' + constFormularioPrincipal));
                }
            }
        });
    };

    self.TrataChecksStocksValoresPorDefeito = function (bool) {
        if (bool) {
            self.TrataChecks('CalculaNecessidades', false);
            self.TrataChecks('CustoMedio', false);
            //self.TrataChecks('UltimoPrecoCusto', false);
            self.TrataChecks('DataPrimeiraEntrada', false);
            self.TrataChecks('DataUltimaEntrada', false);
            self.TrataChecks('DataPrimeiraSaida', false);
            self.TrataChecks('DataUltimaSaida', false);
            if (MODULO == Modulo.Vendas && $('#IDLoja').length == 0) {
                self.TrataChecks('IVAIncluido', true);
                $('#IVAIncluido').prop(base.constantes.grelhaBotoesCls.Disabled, true).parent().parent().addClass(base.constantes.grelhaBotoesCls.Disabled);
            }
        }
    };

    self.TrataChecks = function (chk, bool) {
        bool == true ? $('#' + chk).attr('checked', 'checked').prop('checked', true) : $('#' + chk).removeAttr('checked').prop('checked', false);
    };

    //self.SetValueOnDropDownList = function (ddl, value) {
    //    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + ddl)))) {
    //        KendoRetornaElemento($('#' + ddl)).select(function (dataItem) {
    //            return dataItem.Codigo === value;
    //        });
    //    }
    //};

    self.SetValueOnDropDownList = function (ddl, inValue, inModulo, inTipoDoc) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + ddl)))) {
            var cmb = KendoRetornaElemento($('#' + ddl));
            cmb.select(function (dataItem) {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(dataItem)) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inTipoDoc)) {
                        return dataItem.Codigo === inValue && dataItem.Modulo === inModulo && dataItem.TipoDoc === inTipoDoc;
                    }
                    else if (UtilsVerificaObjetoNotNullUndefinedVazio(inModulo)) {
                        return dataItem.Codigo === inValue && dataItem.Modulo === inModulo;
                    }
                    else {
                        return dataItem.Codigo === inValue;
                    }
                }
            });
        }
    };

    self.SetValueOnDropDownListNatureza = function (ddl, inValue, inModulo, inTipoDoc) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + ddl)))) {
            var cmb = KendoRetornaElemento($('#' + ddl));

            cmb.dataSource.fetch(function () {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(cmb.dataItem())) {
                    var data = this.data();

                    if (UtilsVerificaObjetoNotNullUndefinedVazio(inTipoDoc)) {
                        cmb.select(function (dataItem) {
                            return dataItem.Codigo === inValue && dataItem.Modulo === inModulo && dataItem.TipoDoc === inTipoDoc;
                        });
                    }
                    else if (UtilsVerificaObjetoNotNullUndefinedVazio(inModulo)) {
                        cmb.select(function (dataItem) {
                            return dataItem.Codigo === inValue && dataItem.Modulo === inModulo;
                        });
                    }
                    else {
                        cmb.select(function (dataItem) {
                            return dataItem.Codigo === inValue;
                        });
                    }
                }
            });
        }
    };

    self.ddlObrigatorio = function (ddl) {
        var drop = KendoRetornaElemento($('#' + ddl));
        var dropParent = $('#' + ddl).parent();

        if (UtilsVerificaObjetoNotNullUndefinedVazio(drop)) {
            drop.element.addClass('obrigatorio');
            drop.element.attr(constRequired, constRequired);
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(dropParent)) {
            dropParent.addClass('obrigatorio');
        }         
    };

    self.SetGRIDF4 = function (iFrame, iFrameCombo, campoClicado, tabID) {
        var elemIFRAME = $($($(iFrame[0]).contents().contents().contents()[2]).find('.k-content-frame')[0])[0].contentWindow.$;
        var elemento = $($($($($($($(iFrame[0]).contents().contents().contents()[2]).find('.k-content-frame')[0]).contents().contents().contents()[2])[0]).find('.grelhaform-content')[0]).find('.F3MGrelha')[0])[0];

        GRID = elemIFRAME.data(elemento, 'kendoGrid')
        IFRAME = iFrame;
    };

    self.returnGRID = function () {
        return GRID;
    };

    self.returnIFRAME = function () {
        return IFRAME;
    };

    self.TrataCampoComunicao = function () {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(MODULO)) {
            switch (MODULO) {
                case Modulo.Stocks:
                    if (TIPO_DOC == 'StkEntStk' || TIPO_DOC == 'StkSaidaStk' || TIPO_DOC == 'StkTransfArtComp' ||
                        TIPO_DOC == 'StkReserva' || TIPO_DOC == 'StkLibertarReserva') {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }  

                    if (TIPO_DOC == 'StkTrfArmazCTrans') {
                        var acompanhaBens = $('#' + 'AcompanhaBensCirculacao').is(':checked');
                        if (!acompanhaBens) {
                            self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                        } else {
                            self.BloqueiaCampoFiscalComunica('003'); //Não Comunica
                        }
                    }

                    break;
                case Modulo.Compras:
                    if (TIPO_DOC == 'CmpOrcamento' || TIPO_DOC == 'CmpEncomenda' || TIPO_DOC == 'CmpFinanceiro') {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }
                    if (TIPO_DOC == 'CmpTransporte' && (TIPO_FISC == 'NF' || TIPO_FISC == 'GT' || TIPO_FISC == 'GR')) {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }
                    if (TIPO_DOC == 'CmpTransporte' && (TIPO_FISC == 'GD')) {
                        // SE acompanha bens(D) senão NC(B)
                        var acompanhaBens = $('#' + 'AcompanhaBensCirculacao').is(':checked');

                        if (!acompanhaBens) {
                            self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                        } else {
                            self.BloqueiaCampoFiscalComunica('003'); //Não Comunica
                        }
                    }
                    if (TIPO_DOC == 'CmpFinanceiro' && (TIPO_FISC == 'FT' || TIPO_FISC == 'FS' || TIPO_FISC == 'FR' || TIPO_FISC == 'ND' || TIPO_FISC == 'NC')) {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }
                    break;
                case Modulo.Vendas:
                    if (TIPO_DOC == 'VndServico') {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }

                    if (TIPO_DOC == 'VndOrcamento' || TIPO_DOC == 'VndEncomenda') {
                        self.BloqueiaCampoFiscalComunica('002'); //Comunica Via Saft
                    }

                    if (TIPO_DOC == 'VndFinanceiro' && (TIPO_FISC == 'PF' || TIPO_FISC == 'FT' || TIPO_FISC == 'FS' || TIPO_FISC == 'FR' || TIPO_FISC == 'ND' || TIPO_FISC == 'NC')) {
                        self.BloqueiaCampoFiscalComunica('002'); //Comunica Via Saft
                    }

                    if (TIPO_DOC == 'VndTransporte' && (TIPO_FISC == 'NF' || TIPO_FISC == 'GD')) {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }

                    if (TIPO_DOC == 'VndTransporte' && (TIPO_FISC == 'GA' || TIPO_FISC == 'GT' || TIPO_FISC == 'GR')) {
                        // SE acompanha bens(D) senão NC(B)
                        var acompanhaBens = $('#' + 'AcompanhaBensCirculacao').is(':checked');
                        if (!acompanhaBens) {
                            self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                        } else{
                            self.BloqueiaCampoFiscalComunica('003');
                        }
                    }
                    break;
                case Modulo.Producao:
                    if (TIPO_DOC == 'ProdOrdFab' || TIPO_DOC == 'ProdFinal' || TIPO_DOC == 'ProdCusto' || TIPO_DOC == 'ProdCustoEstorno') {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica

                        if (TIPO_DOC == 'ProdFinal') {
                            self.TrataCampoQtdOrigem(true, false);
                            self.TrataCampoPrecoUnitario(true, false);
                            self.TrataCampoCAE(false, false);                            
                            self.TrataCheckBoxs(['CalculaNecessidades'], false, false);
                        }
                    }
                    break;
                case Modulo.Oficina:
                    if (TIPO_DOC == 'SubstituicaoArtigos') {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                        self.TrataCheckBoxs(['CalculaNecessidades'], false, false);
                    }
                case Modulo.SubContratacao:
                    if (TIPO_DOC == 'SubContEnvio') {
                        var acompanhaBens = $('#' + 'AcompanhaBensCirculacao').is(':checked');
                        if (!acompanhaBens) {
                            self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                        } else {
                            self.BloqueiaCampoFiscalComunica('003'); //Comunica Via Webservice
                        }
                    }
                    if (TIPO_DOC == 'SubContRececao') {
                        self.BloqueiaCampoFiscalComunica('001'); //Não Comunica
                    }
                    break;
                default:
            }
        }
    };

    // bloqueia o campo de comunicação. Passar código por parametro 
    self.BloqueiaCampoFiscalComunica = function (inCodigo) {

        var cbComunicao = KendoRetornaElemento($('#IDSistemaTiposDocumentoComunicacao'));

        if (UtilsVerificaObjetoNotNullUndefinedVazio(cbComunicao)) {
            cbComunicao.dataSource.fetch(function () {
                if (UtilsVerificaObjetoNotNullUndefinedVazio(cbComunicao.dataItem())) {
                    var data = this.data();

                    cbComunicao.select(function (dataItem) {
                        return dataItem.Codigo == inCodigo;
                    });
                }
            });
        }

        self.BloqueiaDesbloqueiaGenerico('IDSistemaTiposDocumentoComunicacao', true);
    };

    /* @description Função de change da combo Natureza */
    self.SisNaturezasChange = function (inEvt) {
        if ((MODULO === Modulo.Compras || MODULO === Modulo.Vendas) && self.IsNullOrEmpty(inEvt) && self.IsNullOrEmpty(inEvt.dataItem())) {
            var _dtItem = inEvt.dataItem();

            switch (_dtItem[campoCod]) {
                case 'P': //pagar
                    $(campoTiposDocumentoMovStock).val(TiposDocumentoMovStock.Entrada);
                    break;

                case 'R': //receber
                    $(campoTiposDocumentoMovStock).val(TiposDocumentoMovStock.Saida);
                    break;
            }
        }
    };

    /* @description Alias da função genérica UtilsVerificaObjetoNotNullUndefinedVazio */
    self.IsNullOrEmpty = function (inObj) {
        return UtilsVerificaObjetoNotNullUndefinedVazio(inObj);
    };

    self.ReservaEnviaParametros = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Stocks);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'StkReserva');
        return objetoFiltro;
    };

    self.LibertarReservaEnviaParametros = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Stocks);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'StkLibertarReserva');
        return objetoFiltro;
    };

    self.CustoEnviaParametros = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Producao);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'ProdCusto');
        return objetoFiltro;
    };

    self.FinalizacaoEnviaParametros = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Producao);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'ProdFinal');
        return objetoFiltro;
    };

     /* @description EnviaParametrosF4 para filtar tipos de documentos (lookups)  */
    self.EnviaParametrosF4 = function (objetoFiltro) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(objetoFiltro.CampoValores.CampoClicadoID)) {
            var campoClicadoID = objetoFiltro.CampoValores.CampoClicadoID.CampoTexto;
            if (campoClicadoID == campoIDTipoDocReserva) {
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Stocks);
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'StkReserva');
            }
            else if (campoClicadoID == campoIDTipoDocLibertaReserva) {
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Stocks);
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'StkLibertarReserva');
            } else if (campoClicadoID == campoIDTipoDocCusto) {
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Producao);
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'ProdCusto');
            } else if (campoClicadoID == campoIDTipoDocFinalizacao) {
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', Modulo.Producao);
                GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoSistemaTiposDocumento", '', 'ProdFinal');
            }
        }

        return objetoFiltro;
    };

    self.TrataCamposReserva = function (boolObg, boolEnable) {
        var valorEdicao = $('#EmExecucao').val();
        var elemReserva = $('#' + campoIDTipoDocReserva);
        var cmbReserva = KendoRetornaElemento(elemReserva);
        var elemLibertaReserva = $('#' + campoIDTipoDocLibertaReserva);
        var cmbLibertaReserva = KendoRetornaElemento(elemLibertaReserva);
        if (boolEnable) {
            elemReserva.removeAttr('disabled');
            elemReserva.removeClass('disabled');
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbReserva)) {
                cmbReserva.element.parent().removeClass('disabled');
                cmbReserva.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbReserva.enable(true);
            }
            elemLibertaReserva.removeAttr('disabled');
            elemLibertaReserva.removeClass('disabled');
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbLibertaReserva)) {
                cmbLibertaReserva.element.parent().removeClass('disabled');
                cmbLibertaReserva.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbLibertaReserva.enable(true);
            }
        }
        else {
            $('#' + campoIDTipoDocReserva).attr('disabled', 'disabled');
            $('#' + campoIDTipoDocReserva).addClass('disabled');
            $('#' + campoIDTipoDocLibertaReserva).attr('disabled', 'disabled');
            $('#' + campoIDTipoDocLibertaReserva).addClass('disabled');
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbReserva)) {
                cmbReserva.enable(false);
            }
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbLibertaReserva)) {
                cmbLibertaReserva.enable(false);
            }
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbReserva)) {
                ComboBoxLimpa(cmbReserva);
            }
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbLibertaReserva)) {
                ComboBoxLimpa(cmbLibertaReserva);
            }
        }

        if (boolObg) {
            KendoColocaElementoObrigatorio(elemReserva, true);
            KendoColocaElementoObrigatorio(elemLibertaReserva, true);
        }
        else {
            KendoColocaElementoObrigatorio(elemReserva, false);
            KendoColocaElementoObrigatorio(elemLibertaReserva, false);
        }

        ComboBoxAtivaDesativaDrillDown([campoIDTipoDocReserva]);
        ComboBoxAtivaDesativaDrillDown([campoIDTipoDocLibertaReserva]);
    };

    self.TrataCamposCusto = function (boolObg, boolEnable) {
        var valorEdicao = $('#EmExecucao').val();
        var elemCusto = $('#' + campoIDTipoDocCusto);
        var cmbCusto = KendoRetornaElemento(elemCusto);
       
        if (boolEnable) {
            elemCusto.removeAttr('disabled');
            elemCusto.removeClass('disabled');
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbCusto)) {
                cmbCusto.element.parent().removeClass('disabled');
                cmbCusto.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbCusto.enable(true);
            }            
        }
        else {
            $('#' + campoIDTipoDocCusto).attr('disabled', 'disabled');
            $('#' + campoIDTipoDocCusto).addClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbCusto)) {
                cmbCusto.enable(false);
            }
            
            //if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbCusto)) {
            //    ComboBoxLimpa(cmbCusto);
            //}            
        }

        if (boolObg) {
            KendoColocaElementoObrigatorio(elemCusto, true);            
        }
        else {
            KendoColocaElementoObrigatorio(elemCusto, false);
        }

        ComboBoxAtivaDesativaDrillDown([campoIDTipoDocCusto]);
    };

    self.TrataCamposFinalizacao = function (boolObg, boolEnable) {        
        var valorEdicao = $('#EmExecucao').val();
        var elemFin = $('#' + campoIDTipoDocFinalizacao);
        var cmbFin = KendoRetornaElemento(elemFin);

        if (boolEnable) {
            elemFin.removeAttr('disabled');
            elemFin.removeClass('disabled');
            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbFin)) {
                cmbFin.element.parent().removeClass('disabled');
                cmbFin.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbFin.enable(true);
            }
        }
        else {
            $('#' + campoIDTipoDocFinalizacao).attr('disabled', 'disabled');
            $('#' + campoIDTipoDocFinalizacao).addClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbFin)) {
                cmbFin.enable(false);
            }

            //if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbCusto)) {
            //    ComboBoxLimpa(cmbCusto);
            //}            
        }

        if (boolObg) {
            KendoColocaElementoObrigatorio(elemFin, true);
        }
        else {
            KendoColocaElementoObrigatorio(elemFin, false);
        }

        ComboBoxAtivaDesativaDrillDown([campoIDTipoDocFinalizacao]);
    };

    self.EnviaParamsPrecoUnit = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "CodigoModulo", '', MODULO);
        return objetoFiltro;
    };

    self.TrataCampoQtdOrigem = function (inBoolObg, inBoolEnable) {        
        var elemQtdOrigem = $('#' + campoIDSistemaAcoes);
        var cmbOrigem = KendoRetornaElemento(elemQtdOrigem);

        if (inBoolEnable) {
            elemQtdOrigem.removeAttr('disabled');
            elemQtdOrigem.removeClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbOrigem)) {
                cmbOrigem.element.parent().removeClass('disabled');
                cmbOrigem.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbOrigem.enable(true);
            }
        }
        else {
            elemQtdOrigem.attr('disabled');
            elemQtdOrigem.addClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbOrigem)) {
                cmbOrigem.enable(false);
            }
        }

        if (inBoolObg) {
            KendoColocaElementoObrigatorio(elemQtdOrigem, true);
        }
        else {
            KendoColocaElementoObrigatorio(elemQtdOrigem, false);
        }
    };

    self.TrataCampoPrecoUnitario = function (inBoolObg, inBoolEnable) {
        var elemPrecUnitario = $('#' + campoIDPrecoUnitario);
        var cmbPrecUnitario = KendoRetornaElemento(elemPrecUnitario);

        if (inBoolEnable) {
            elemPrecUnitario.removeAttr('disabled');
            elemPrecUnitario.removeClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbPrecUnitario)) {
                cmbPrecUnitario.element.parent().removeClass('disabled');
                cmbPrecUnitario.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbPrecUnitario.enable(true);
            }
        }
        else {
            elemPrecUnitario.attr('disabled');
            elemPrecUnitario.addClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbPrecUnitario)) {
                cmbPrecUnitario.enable(false);
            }
        }

        if (inBoolObg) {
            KendoColocaElementoObrigatorio(elemPrecUnitario, true);
        }
        else {
            KendoColocaElementoObrigatorio(elemPrecUnitario, false);
        }
    };

    self.TrataCampoCAE = function (inBoolObg, inBoolEnable) {
        var elemCAE = $('#' + campoIDCAE);
        var cmbCAE = KendoRetornaElemento(elemCAE);

        if (inBoolEnable) {
            elemCAE.removeAttr('disabled');
            elemCAE.removeClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbCAE)) {
                cmbCAE.element.parent().removeClass('disabled');
                cmbCAE.element.parent().find('.clsF3MInput').removeClass('disabled');
                cmbCAE.enable(true);
            }
        }
        else {
            elemCAE.attr('disabled');
            elemCAE.addClass('disabled');

            if (UtilsVerificaObjetoNotNullUndefinedVazio(cmbCAE)) {
                cmbCAE.enable(false);
            }
        }

        if (inBoolObg) {
            KendoColocaElementoObrigatorio(elemCAE, true);
        }
        else {
            KendoColocaElementoObrigatorio(elemCAE, false);
        }
    };

    self.TrataCampoNumVias = function (inBoolObg, inNumViasObg) {

        var elemNumVias = $('#' + campoIDNumVias);
        var numVias = KendoRetornaElemento(elemNumVias);

        if (inBoolObg) {
            KendoColocaElementoObrigatorio(elemNumVias, true);
            elemNumVias.attr(constRequired, constRequired);
        }
        else {
            KendoColocaElementoObrigatorio(elemNumVias, false);
            elemNumVias.removeAttr(constRequired);
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(inNumViasObg)) {
            if (!UtilsVerificaObjetoNotNullUndefinedVazio(numVias)) {
                numVias.options.min = inNumViasObg;
                numVias.value(inNumViasObg); //Atribuir valor por defeito
            }
        }
    };

    self.RetornaSeriesEditadas = function (series) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(series)) {
            for (var ind = 0; ind < series.length; ind++) {
                var objSerie = series[ind];
                if (UtilsVerificaObjetoNotNullUndefinedVazio(objSerie.DataCriacao)) {
                    objSerie.DataCriacao = UtilsConverteJSONDate(objSerie.DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmmSS);
                }
                if (UtilsVerificaObjetoNotNullUndefinedVazio(objSerie.DataAlteracao)) {
                    objSerie.DataAlteracao = UtilsConverteJSONDate(objSerie.DataAlteracao, constJSONDates.ConvertToDDMMAAAAHHmmSS);
                }
                objSerie["EmExecucao"] = 1;
                $.grep(objSerie.TiposDocumentoSeriesPermissoes, function (obj) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(obj.DataCriacao)) {
                        obj.DataCriacao = UtilsConverteJSONDate(obj.DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmmSS);
                    }
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(obj.DataAlteracao)) {
                        obj.DataAlteracao = UtilsConverteJSONDate(obj.DataAlteracao, constJSONDates.ConvertToDDMMAAAAHHmmSS);
                    }
                    return obj;
                });
            }
            ObjetosSeries.SeriesEditadas = series;
        }
    };   
    
    return parent;

}($tiposdocumento || {}, jQuery));

var TiposDocumentoInit = $tiposdocumento.ajax.Init;
var TiposDocumentoSistemaTiposDocumentoEnviaParams = $tiposdocumento.ajax.SistemaTiposDocumentoEnviaParams;
var TiposDocumentoModuloChange = $tiposdocumento.ajax.ModuloChange;
var TiposDocumentoEnviaParametros = $tiposdocumento.ajax.EnviaParametros;
var TiposDocumentoGuardaTreeViewDS = $tiposdocumento.ajax.GuardaDataSourceTreeView;
var TiposDocumentoSeriesValidaEspecifica = $tiposdocumento.ajax.ValidaEspecificaTiposDocumentoSerie;
var TiposDocumentoIdiomasValidaEspecifica = $tiposdocumento.ajax.ValidaEspecificaTiposDocumentoIdiomas;
var TreeViewDataBound = $tiposdocumento.ajax.TreeViewDataBound;
var TreeViewEnviaParams = $tiposdocumento.ajax.TreeViewEnviaParams;
var TiposDocumentoEnviaParamsModulo = $tiposdocumento.ajax.EnviaParametrosModulo;
var TiposDocumentoTiposDocChange = $tiposdocumento.ajax.TiposDocChange;
var TiposDocumentoEnviaParamsTiposDoc = $tiposdocumento.ajax.TiposDocEnviaParams;
var TiposDocumentoEnviaParamsTiposDocFiscal = $tiposdocumento.ajax.TiposDocFiscalEnviaParams;
var TiposDocumentoSistemaTiposDocumentoDataBound = $tiposdocumento.ajax.TDSDataBound;
var TreeViewCheck = $tiposdocumento.ajax.Check;
var TiposDocumentoAvisaAsDefault = $tiposdocumento.ajax.AvisaAsDefault;
var TiposDocmentoTrataTiposLiquidacao = $tiposdocumento.ajax.TrataTiposLiquidacao;
var TiposDocumentoTrataViewSeries = $tiposdocumento.ajax.TrataViewSeries;
var TiposDocumentoRetornaObjetoSeries = $tiposdocumento.ajax.RetornaObjetosSeries;
var TiposDocumentoFiscalDataBound = $tiposdocumento.ajax.FiscalDataBound;
var NaturezasDataBound = $tiposdocumento.ajax.DataBoundNaturezas;
var TiposDocumentoEnviaParamsTipoEstados = $tiposdocumento.ajax.EnviaParamsTipoEstados;
var TiposDocumentoTrataChecksBoxs = $tiposdocumento.ajax.TrataCheckBoxs;
var TiposDocumentoSeriesSetGRIDF4 = $tiposdocumento.ajax.SetGRIDF4;
var TiposDocumentoTipoFiscalChange = $tiposdocumento.ajax.TipoFiscalChange;
var TiposDocumentosReturnGRID = $tiposdocumento.ajax.returnGRID;
var TiposDocumentosReturnIFRAME = $tiposdocumento.ajax.returnIFRAME;
var TiposDocumentoClienteEnviaParametros = $tiposdocumento.ajax.ClienteEnviaParametros;
var TiposDocumentoMapasVistasEnviaParametros = $tiposdocumento.ajax.MapasVistasEnviaParametros;
var TiposDocumentoMapasVistasDataBoud = $tiposdocumento.ajax.MapasVistasDataBoud;
var TiposDocumentoSisNaturezasChange = $tiposdocumento.ajax.SisNaturezasChange;
var TiposDocumentoReservaEnviaParametros = $tiposdocumento.ajax.ReservaEnviaParametros;
var TiposDocumentoLibertaReservaEnviaParametros = $tiposdocumento.ajax.LibertarReservaEnviaParametros;
var TiposDocumentoCustoEnviaParametros = $tiposdocumento.ajax.CustoEnviaParametros;
var TiposDocumentosEnviaParamsPrecoUnit = $tiposdocumento.ajax.EnviaParamsPrecoUnit;
var TiposDocumentoFinalizacaoEnviaParametros = $tiposdocumento.ajax.FinalizacaoEnviaParametros;
var TiposDocumentoEnviaParametrosF4 = $tiposdocumento.ajax.EnviaParametrosF4;

var TiposDocumentosRetornaSeriesEditadas = $tiposdocumento.ajax.RetornaSeriesEditadas;

$(document).ready(function (e) {
    TiposDocumentoInit();
}).ajaxSend(function () {
    if ($('.k-loading-mask').length == 0) {
        LoadingAplicaLoading('F3MGrelhaFormTiposDocumentoForm', null, true);
    }
}).ajaxStop(function () {
    LoadingAplicaLoading('F3MGrelhaFormTiposDocumentoForm', null, false);
    });

