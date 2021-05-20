"use strict";

var $docsvendas = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //constantes campos genericos
    var constCamposGen = constsBase.camposGenericos;
    var campoID = constCamposGen.ID, campoCod = constCamposGen.Codigo, campoDesc = constCamposGen.Descricao, campoOrdem = constCamposGen.Ordem;
    var campoIDArt = constCamposGen.IDArtigo;

    //constantes acoes
    var campoAcaoFormulario = constCamposGen.AcaoFormulario, campoAcaoCRUD = constCamposGen.AcaoCRUD, campoAcaoUID = constCamposGen.AcaoUID;

    //constantes estados 
    var constEstados = constsBase.EstadoFormEAcessos;

    //constantes tipo de campo
    var constTipoDeCampo = constsBase.TipoDeCampo;

    //constantes objeto filtro
    var constCamposOF = constsBase.camposObjetoFiltro, campoValoresID = constCamposOF.CampoValores, campoTextoID = constCamposOF.CampoTexto;

    //constantes tipos de componentes
    var constTipoComponentes = constsBase.tiposComponentes, campoClicDesc = constTipoComponentes.janela.CampoClicDesc;

    //constantes botoes
    var btnsAcoes = constsBase.grelhaBotoesIDs

    //constantes componentes Handsontable
    var constComponentesHT = constsBase.ComponentesHT;

    //constantes lado direito
    var campoTotalMoedaDocumento = 'TotalMoedaDocumento', campoPercentagemDesconto = 'PercentagemDesconto', campoDescontosLinha = 'DescontosLinha';
    var campoSubTotal = 'idSubTotal', campoIDDescontoLinha = 'idDescontoLinha', campoTotalResumo = 'TotalResumo', campoTotal = 'idTotal', campoIDTotalImposto = 'TotalIva';
    var campoValorDesconto = 'ValorDesconto';
    var campoOutrosDescontos = 'OutrosDescontos';
    var campoTotalEntidade1 = 'TotalEntidade1';
    var campoTotalIva = 'TotalIva';

    //constantes casas decimais
    var campoCasasDecPU = 'CasasDecimaisPrecosUnitarios', campoCasasDecTot = 'CasasDecimaisTotais', campoCasasDecIVA = 'CasasDecimaisIva';

    //constantes importacao
    var campoDocEstaAssinado = 'DocEstaAssinado';
    var campoEImpFromServicosToFT2 = 'EImpFromServicosToFT2', campoEImpFromVendasToNC = 'EImpFromVendasToNC', campoEImpFromServicosToDV = 'EImpFromServicosToDV';

    //constantes campos funcionalidade
    var campoIDMoeda = 'IDMoeda';
    var campoIDEntidade = 'IDEntidade';
    var hdsnID = 'F3MGrelhaDocumentosVendasLinhas';

    //constantes colunas handsontable
    var campoCodArt = 'CodigoArtigo', campoDescArt = 'DescricaoArtigo';
    var campoCampanha = 'Campanha';
    var campoCodigoIva = 'CodigoIva', campoTaxaIVA = 'TaxaIva', campoIDTaxaIVA = 'IDTaxaIva', campoTaxaConv = 'TaxaConversao', campoCodTaxaIVA = 'CodigoTaxaIva';
    var campoQtd = 'Quantidade';
    var campoPrecoUnit = 'PrecoUnitario', campoPrecoUnitEfetivo = 'PrecoUnitarioEfetivo';
    var campoDesconto1 = 'Desconto1', campoValorDescontoLinha = 'ValorDescontoLinha', campoTotalComDescontoLinha = 'TotalComDescontoLinha';
    var campoValorDescontoCabecalho = 'ValorDescontoCabecalho', campoTotalComDescontoCabecalho = 'TotalComDescontoCabecalho';
    var campoValorUnitarioEntidade1 = 'ValorUnitarioEntidade1', campoValorEntidade1 = 'ValorEntidade1';
    var campoValorUnitarioEntidade2 = 'ValorUnitarioEntidade2', campoValorEntidade2 = 'ValorEntidade2';
    var campoTotalFinal = 'TotalFinal'
    var campoDocOrig = 'DocumentoOrigem';
    var campoCodSistTipDocMovStock = 'CodigoSistemaTiposDocumentoMovStock';
    //          lotes
    var campoIDLote = 'IDLote', campoDescLote = 'DescricaoLote', campoDataFabLote = 'DataFabricoLote', campoDataValLote = 'DataValidadeLote', campoGereLotes = 'GereLotes'
    //          armazens
    var campoIDArm = 'IDArmazem', campoDescArm = 'DescricaoArmazem', campoIDArmLoc = 'IDArmazemLocalizacao', campoDescArmLoc = 'DescricaoArmazemLocalizacao';
    var campoIDArmDest = campoIDArm + 'Destino', campoDescArmDest = campoDescArm + 'Destino', campoIDArmLocDest = campoIDArmLoc + 'Destino', campoDescArmLocDest = campoDescArmLoc + 'Destino';
    //          campos a preenger props
    var campoIDUni = 'IDUnidade', campoCodUni = 'CodigoUnidade';
    var campoGereStk = 'GereStock';

    //constantes bind events
    var campoAnexos = 'anexContainer', campoPagamento = 'pagamento', campoEditarPagamento = 'editarPagamento', campoNotacredito = 'notacredito'
    var campoSpanTotalIva = 'spanTotalIva', campoIDEntidade1 = 'IDEntidade1', campoEntidade1Automatica = 'Entidade1Automatica';

    var codSistTipoDocID = 'CodigoSistemaTiposDocumento';
    // CODIGO TIPO DOC MOV STOCK
    var TIPODOC_MOVSTK_TRF = '004';

    //flag para controlo se ja executou a fn DaTotaisDocumento
    self.ExecutouDaTotaisDocumento = true;

    //flags para controlo de quando está com cálculos pendentes e vai gravar (FR /// FS)
    self.fnClick = null;
    self.IsPendingCalcs = false;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //trata bind dos eventos de init
        self.BindInitEvents();

        //trata floating divs
        self.PosicionaFloatingDivs();

        //trata observacoes e avisos
        UtilsObservacoesTrataEspecifico("tabObservacoes", "Observacoes", "Avisos");
    };

    /* @description funcao que faz o bound dos eventos */
    self.BindInitEvents = function () {
        var _idGridForm = $('.' + constTipoComponentes.grelhaForm).attr('id');
        var elemsBtnsAcoes = $('#' + _idGridForm + btnsAcoes.GuardarCont + ', ' + '#' + _idGridForm + btnsAcoes.GuardarCont2 + ', ' + '#' + _idGridForm + btnsAcoes.GuardarFecha + ', ' + '#' + _idGridForm + btnsAcoes.GuardarFecha2);
        
        elemsBtnsAcoes.off('click').on('click', (e) => {
            if (self.IsPendingCalcs) {
                self.fnClick = () => $gridutils.ajax.CliqueBotoes(e);
            }
            else {
                self.fnClick = null;
                $gridutils.ajax.CliqueBotoes(e);
            }
        });

        $('#' + campoSpanTotalIva).on('click', function (e) {
            e.preventDefault();

            DocumentosStockDesenhaHTIncidencias(e);

            //e.stopImmediatePropagation();
            //return false;
        });

        $('#' + campoEntidade1Automatica).on('click', function (e) {
            //e.preventDefault();

            self.CalculaComparticipacoes(e.target.checked);

            //e.stopImmediatePropagation();
            //return false;
        });

        $('#' + campoIDEntidade1).on('change', function (e) {
            self.CalculaComparticipacoes($('#' + campoEntidade1Automatica).checked);
        });

        $('#' + campoNotacredito).on('click', function (e) {
            e.preventDefault();

            self.LerNCExistentes(e);

            e.stopImmediatePropagation();
            return false;
        });

        $('#' + campoEditarPagamento).on('click', function (e) {
            e.preventDefault();

            self.CliqueRecebimentos(e);

            e.stopImmediatePropagation();
            return false;
        });

        $('#' + campoPagamento).on('click', function (e) {
            e.preventDefault();

            self.CliquePagamentos(e);

            e.stopImmediatePropagation();
            return false;
        });

        $('.' + campoAnexos).on('click', function (e) {
            e.preventDefault();

            self.AbreAnexos(e);

            e.stopImmediatePropagation();
            return false;
        });
    };

    /* @description funcao que trata o posicionamento das floating divs */
    self.PosicionaFloatingDivs = function () {
        ElemFloatingMostraPosiciona('elemFloatingDescontos', 0, 0, null, null); //descontos
        //ElemFloatingMostraPosiciona('elemFloatingIncidencias', 0, 0, null, null);
        //F3MFormulariosTrataPosicaoFloatEstadosIncidencias($('#' + campoAcaoFormulario).val());
    };

    //------------------------------------ B O T O E S     L A D O     D I R E I T O
    /* @description funcao que abre a modal dos anexos*/
    self.AbreAnexos = function () {
        //props JanelaDesenha
        var _url = rootDir + '/Documentos/DocumentosVendasAnexos';
        var _janelaID = base.constantes.janelasPopupIDs.Menu;
        //JanelaDesenha
        JanelaDesenha(_janelaID, self.RetornaObjData(), _url);
    };

    /* @description funcao que verifica se o documento tem nc associada */
    self.LerNCExistentes = function (e) {
        var _id = $('#' + campoID).val();
        var _url = rootDir + 'DocumentosVendas/LerNCExistentes';

        UtilsChamadaAjax(_url, true, JSON.stringify({ IDDocumentoVenda: _id }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    if (res != 0) {
                        self.CarregaNC(res);
                    }
                    else {
                        self.GeraNC();
                    }
                }
            }, function (e) { throw e; }, 1, true);
    };

    /* @description funcao que abre em tab a nc associada ao documento de venda*/
    self.CarregaNC = function (inIDNC) {
        //props UtilsAbreTab
        var _url = '/Documentos/DocumentosVendas?IDDrillDown=' + inIDNC;
        var _tabnome = resources['DocumentosVendas'], _tabicon = 'f3icon-doc-finance';
        //UtilsAbreTab
        UtilsAbreTab(_url, _tabnome, _tabicon, null, null, null);
    };

    /* @description funcao que abre em tab um novo documento de venda do tipo nc associada ao documento de venda*/
    self.GeraNC = function () {
        //props UtilsAbreTab
        var _id = $('#' + campoID).val();
        var _url = 'Documentos/DocumentosVendas';
        var _tabnome = resources['DocumentosVendas'], _tabicon = 'f3icon-doc-finance';
        //action result AdicionaEsp
        sessionStorage.setItem('AdicionaEsp', rootDir + _url + '/AdicionaEsp?IDDocumentoVenda=' + _id);
        //UtilsAbreTab
        UtilsAbreTab(_url, _tabnome, _tabicon, null, constEstados.Adicionar, null);
    };

    //------------------------------------ P A G A M E N T O S     E     R E C E B I M E N T O S
    /* @description funcao que abre a modal de pagamentos */
    self.CliquePagamentos = function (e) {
        var _UrlAux = window.location.pathname + '/BlnExistemDocsVendasPendentes';
        var IDEntidadeAux = parseInt($('#' + campoIDEntidade).val());
        var IDMoedaAux = parseInt($('#' + campoIDMoeda).val());
        var IDDocumentoVendaAux = parseInt($('#' + campoID).val());
        var OpcaoAux = 'pagamentos';

        UtilsChamadaAjax(_UrlAux, true, JSON.stringify({
            IDDocumentoVenda: IDDocumentoVendaAux,
            IDEntidade: IDEntidadeAux,
            IDMoeda: IDMoedaAux
        }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    if (res == true) {
                        var _janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
                        var _UrlAuxPagamentosVendas = rootDir + '/PagamentosVendas/PagamentosVendas?' + campoIDEntidade + '=' + IDEntidadeAux + '&' + campoIDMoeda + '=' + IDMoedaAux + '&Opcao=' + OpcaoAux;

                        JanelaDesenha(_janelaMenuLateral, self.RetornaObjData(), _UrlAuxPagamentosVendas, '', null, null, null, null, null, function (inEvt) {
                            inEvt.sender.element.addClass('janela-centrada');
                            janelaRefrescar(inEvt, '', false, 'f3m-window-bg-centrada');
                            FrontendGrelhaLoading();
                        }, self.AtualizaHistorico, null, null, null, null);
                    }
                }
                else {
                    UtilsNotifica(base.constantes.tpalerta[res.TipoAlerta], res.Errors);
                }
            },
            function () { return false; }, 1, true);
    };

    /* @description funcao que abre a modal de recebimentos */
    self.CliqueRecebimentos = function (e) {
        var _UrlAux = window.location.pathname + '/BlnExistemDocsVendasPagamentos';
        var IDDocumentoVendaAux = parseInt($('#' + campoID).val());
        var IDMoedaAux = parseInt($('#' + campoIDMoeda).val());
        var OpcaoAux = 'recebimentos';

        UtilsChamadaAjax(_UrlAux, true, JSON.stringify({
            IDDocumentoVenda: IDDocumentoVendaAux
        }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    if (res == true) {
                        var _janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
                        var _UrlAuxPagamentosVendas = rootDir + '/PagamentosVendas/PagamentosVendas?IDDocumentoVenda=' + IDDocumentoVendaAux + '&' + campoIDMoeda + '=' + IDMoedaAux + '&Opcao=' + OpcaoAux;

                        JanelaDesenha(_janelaMenuLateral, self.RetornaObjData(), _UrlAuxPagamentosVendas, '', null, null, null, null, null, function (inEvt) {
                            inEvt.sender.element.addClass('janela-centrada');
                            janelaRefrescar(inEvt, '', false, 'f3m-window-bg-centrada');
                            FrontendGrelhaLoading();
                        }, self.AtualizaHistorico, null, null, null, null);
                    }
                    else {
                        UtilsNotifica(base.constantes.tpalerta.i, resources.nao_tem_recebimentos);
                    }
                }
            },
            function () { return false; }, 1, true);
    };

    //------------------------------------ H A N D S O N T A B L E     E S P E C I F I C O
    /* @description funcao que adiciona os dados ao indexeddb e desenha a Handsontable*/
    self.ConstroiHT = function (inData) {
        inData = DocumentosStockConverteLinhaDSEmModelo(inData, -1)
        F3MIndexedDBAdicionaRegisto(TipoPai + 'Linhas', inData, function () {
            DocumentosStockDesenhaHTArtigos(inData, true, null, null, null, null, null, null, null);
            //remove temp ds from dom
            $('#tempHdsnDS').remove();
        });
    };

    /* @description funcao que retorna a Handsontable */
    self.RetornaHdsnInstance = function () {
        return window.HotRegisterer.bucket[hdsnID];
    };

    /* @description retorna colunas especificas para grelha de artigos dos documentos de venda */
    self.RetornaColunasHT = function () {
        var moedaRefEmpresa = $('#SimboloMoedaRefEmpresa').val();
        var moedaRefCliente = $('#SimboloMoedaRefCliente').val();
        var intCasasDecTotais = $('#' + campoCasasDecTot).val();
        var intCasasDecPrecosUni = $('#' + campoCasasDecPU).val();
        var intCasasDecIVA = $('#' + campoCasasDecIVA).val();

        var ListaCamposPreencher =
            [{ 'Coluna': campoIDArt, 'Campo': campoID },
            { 'Coluna': campoDesc, 'Campo': campoDesc },
            { 'Coluna': campoIDTaxaIVA, 'Campo': 'IDTaxa' },
            { 'Coluna': campoTaxaIVA, 'Campo': 'Taxa' },
            { 'Coluna': 'IDMarca', 'Campo': 'IDMarca' },
            { 'Coluna': 'DescricaoVariavel', 'Campo': 'DescricaoVariavel' },
            { 'Coluna': 'MotivoIsencaoIva', 'Campo': 'MotivoIsencaoIva' },
            { 'Coluna': 'CodigoMotivoIsencaoIva', 'Campo': 'CodigoMotivoIsencaoIva' },
            { 'Coluna': campoPrecoUnit, 'Campo': 'ValorComIva' },
            { 'Coluna': 'EspacoFiscal', 'Campo': 'EspacoFiscal' },
            { 'Coluna': campoIDUni, 'Campo': campoIDUni },
            { 'Coluna': campoCodArt, 'Campo': campoCodArt },
            { 'Coluna': 'CodigoTipoIva', 'Campo': 'CodigoSistemaTipoIva' },
            { 'Coluna': campoCodigoIva, 'Campo': campoCodigoIva },
            { 'Coluna': campoCodUni, 'Campo': campoCodUni },
            { 'Coluna': 'CodigoBarrasArtigo', 'Campo': 'CodigoBarrasArtigo' },
            { 'Coluna': campoIDLote, 'Campo': campoIDLote },
            { 'Coluna': campoDescLote, 'Campo': campoDescLote },
            { 'Coluna': campoGereLotes, 'Campo': campoGereLotes },
            { 'Coluna': campoGereStk, 'Campo': campoGereStk }];

        if ($('#CodigoSistemaTiposDocumentoMovStock').val() === '003') {
            ListaCamposPreencher.push(
                { 'Coluna': campoIDArm, 'Campo': campoIDArm },
                { 'Coluna': campoDescArm, 'Campo': campoDescArm },
                { 'Coluna': campoIDArmLoc, 'Campo': campoIDArmLoc },
                { 'Coluna': campoDescArmLoc, 'Campo': campoDescArmLoc })
        }
        else if ($('#CodigoSistemaTiposDocumentoMovStock').val() === '002') {
            ListaCamposPreencher.push(
                { 'Coluna': campoIDArmDest, 'Campo': campoIDArm },
                { 'Coluna': campoDescArmDest, 'Campo': campoDescArm },
                { 'Coluna': campoIDArmLocDest, 'Campo': campoIDArmLoc },
                { 'Coluna': campoDescArmLocDest, 'Campo': campoDescArmLoc })
        }

        var listaCamposLote = [
            { 'Coluna': campoIDLote, 'Campo': campoID },
            { 'Coluna': campoDescLote, 'Campo': campoDescLote },
            { 'Coluna': campoDataFabLote, 'Campo': 'DataFabrico' },
            { 'Coluna': campoDataValLote, 'Campo': 'DataValidade' }];

        var listaCamposArm = [
            { 'Coluna': campoIDArm, 'Campo': campoID },
            { 'Coluna': campoDescArm, 'Campo': campoDesc }];

        var listaCamposArmLoc = [
            { 'Coluna': campoIDArmLoc, 'Campo': campoID },
            { 'Coluna': campoDescArmLoc, 'Campo': campoDesc }];

        var listaCamposArmDest = [
            { 'Coluna': campoIDArmDest, 'Campo': campoID },
            { 'Coluna': campoDescArmDest, 'Campo': campoDesc }];

        var listaCamposArmLocDest = [
            { 'Coluna': campoIDArmLocDest, 'Campo': campoID },
            { 'Coluna': campoDescArmLocDest, 'Campo': campoDesc }];

        var columns = [
            {
                ID: campoCodArt,
                TipoEditor: constComponentesHT.F3MLookup,
                Label: resources['Artigo'],
                width: 150,
                Controlador: rootDir + 'Artigos/Artigos/ListaComboCodigo',
                ControladorExtra: rootDir + 'Artigos/Artigos/IndexGrelha',
                ListaCamposPreencher: ListaCamposPreencher,
                CampoTexto: campoCod,
                readOnly: false,
                FuncaoEnviaParams: function (objetoFiltro, hdsn) {
                    return self.EnviaParamsIDArtigo(objetoFiltro);
                }
            }, {
                ID: campoDesc,
                TipoEditor: constComponentesHT.F3MTexto,
                Label: resources[campoDesc],
                width: 300,
                readOnly: true
            }, {
                ID: campoCampanha,
                Label: resources[campoCampanha],
                TipoEditor: constComponentesHT.F3MLookup,
                ListaCamposPreencher: [{ 'Coluna': 'IDCampanha', 'Campo': 'ID' }],
                width: 125,
                Controlador: rootDir + 'TabelasAuxiliares/Campanhas',
                readOnly: true
            }, {
                ID: campoCodigoIva,
                TipoEditor: constComponentesHT.F3MLookup,
                Label: resources[campoCodTaxaIVA],
                CampoTexto: campoCod,
                Controlador: rootDir + 'TabelasAuxiliares/IVA',
                ControladorExtra: rootDir + 'TabelasAuxiliares/IVA/IndexGrelha',
                ListaCamposPreencher: [{ 'Coluna': campoIDTaxaIVA, 'Campo': campoID }, { 'Coluna': campoTaxaIVA, 'Campo': 'Taxa' }],
                width: 125,
                readOnly: true
            }, {
                ID: campoTaxaIVA,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['PercTaxa'],
                CasasDecimais: intCasasDecIVA,
                width: 55,
                readOnly: true
            }]
        // DATA ENTREGA - CASO SEJA UMA ENCOMENDA(COMPRAS/VENDAS) - A SEGUIR A COLUNA % TAXA - MJS
        var codTipoDoc = $('#' + codSistTipoDocID).val();
        if (codTipoDoc === "CmpEncomenda" || codTipoDoc === "VndEncomenda") {
            columns.push({
                ID: 'DataEntrega',
                Label: resources.DataEntrega,
                TipoEditor: constComponentesHT.F3MData,
                EEditavel: true,
                ValidaObrigatorio: true,
                width: 200
            });
        }

        columns.push({
            ID: campoQtd,
            TipoEditor: constComponentesHT.F3MNumero,
            Label: resources['Qtd'],
            CasasDecimais: 0,
            width: 50,
            readOnly: true
        }, {
                ID: campoPrecoUnit,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDPrecoUnitario'],
                CasasDecimais: intCasasDecPrecosUni,
                readOnly: true
            }, {
                ID: campoDesconto1,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['PercentagemDesconto'],
                CasasDecimais: 2,
                readOnly: true
            }, {
                ID: campoValorDescontoLinha,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDVDescLin'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            }, {
                ID: campoTotalComDescontoLinha,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDTotalComDesconto'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            }, {
                ID: campoValorDescontoCabecalho,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDVDescCab'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            }, {
                ID: campoTotalComDescontoCabecalho,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDTotalComDescontoCabecalho'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            }, {
                ID: campoPrecoUnitEfetivo,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDPrecoUnitarioEfetivo'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            }, {
                ID: campoValorUnitarioEntidade1,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDValorUnitarioEntidade1'],
                CasasDecimais: intCasasDecPrecosUni,
                readOnly: true
            }, {
                ID: campoValorEntidade1,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDVComp1'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            },
            {
                ID: campoValorUnitarioEntidade2,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDValorUnitarioEntidade2'],
                CasasDecimais: intCasasDecPrecosUni,
                readOnly: true
            }, {
                ID: campoValorEntidade2,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDVComp2'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            },
            {
                ID: campoTotalFinal,
                TipoEditor: constComponentesHT.F3MNumero,
                Label: resources['MDTotalFinal'],
                CasasDecimais: intCasasDecTotais,
                readOnly: true
            },
            {
                ID: 'MotivoIsencaoIva',
                TipoEditor: constComponentesHT.F3MTexto,
                Label: resources['Motivoisencao'],
                readOnly: true
            },
            {
                ID: campoDocOrig,
                TipoEditor: constComponentesHT.F3MTexto,
                Label: resources['DocRef'],
                width: 150,
                readOnly: true
            },
            {
                ID: campoDescLote,
                Label: resources['Lote'],
                TipoEditor: constComponentesHT.F3MLookup,
                CampoTexto: campoDesc,
                Controlador: rootDir + '/Artigos/ArtigosLotes/',
                ControladorExtra: rootDir + '/Artigos/ArtigosLotes/IndexGrelha',
                AcaoCRUD: constEstados.Adicionar,
                width: 150,
                readOnly: true,
                ListaCamposPreencher: listaCamposLote,
                FuncaoEnviaParams: function (inObjetoFiltro, inGrelhaHTArt, inElem, inColuna) {
                    return self.EnviaParamsLotesArmazens(inObjetoFiltro, inGrelhaHTArt, inElem, inColuna);
                }
            });

        if ($('#' + campoCodSistTipDocMovStock).val() === '003') {
            columns.push({
                ID: campoDescArm,
                Label: resources['ArmazemSaida'],
                TipoEditor: constComponentesHT.F3MLookup,
                Controlador: rootDir + '/TabelasAuxiliares/Armazens',
                ControladorExtra: rootDir + '/TabelasAuxiliares/Armazens/IndexGrelha',
                width: 150,
                readOnly: true,
                ListaCamposPreencher: listaCamposArm,
                FuncaoEnviaParams: function (inObjetoFiltro, inGrelhaHTArt, inElem, inColuna) {
                    return self.EnviaParamsLotesArmazens(inObjetoFiltro, inGrelhaHTArt, inElem, inColuna);
                }
            },
                {
                    ID: campoDescArmLoc,
                    Label: resources['ArmazemLocalizacaoSaida'],
                    TipoEditor: constComponentesHT.F3MLookup,
                    CampoTexto: campoDesc,
                    Controlador: rootDir + '/TabelasAuxiliares/ArmazensLocalizacoes/ListaCombo',
                    ControladorExtra: rootDir + '/TabelasAuxiliares/Localizacoes',
                    width: 150,
                    readOnly: true,
                    ListaCamposPreencher: listaCamposArmLoc,
                    FuncaoEnviaParams: function (inObjetoFiltro, inGrelhaHTArt, inElem, inColuna) {
                        return self.EnviaParamsLotesArmazens(inObjetoFiltro, inGrelhaHTArt, inElem, inColuna);
                    }
                });
        }

        if ($('#' + campoCodSistTipDocMovStock).val() === '002') {
            columns.push({
                ID: campoDescArmDest,
                Label: resources['ArmazemEntrada'],
                TipoEditor: constComponentesHT.F3MLookup,
                Controlador: rootDir + '/TabelasAuxiliares/Armazens',
                ControladorExtra: rootDir + '/TabelasAuxiliares/Armazens/IndexGrelha',
                width: 150,
                readOnly: true,
                ListaCamposPreencher: listaCamposArmDest,
                FuncaoEnviaParams: function (inObjetoFiltro, inGrelhaHTArt, inElem, inColuna) {
                    return self.EnviaParamsLotesArmazens(inObjetoFiltro, inGrelhaHTArt, inElem, inColuna);
                }
            },
                {
                    ID: campoDescArmLocDest,
                    Label: resources['ArmazemLocalizacaoEntrada'],
                    TipoEditor: constComponentesHT.F3MLookup,
                    CampoTexto: campoDesc,
                    Controlador: rootDir + '/TabelasAuxiliares/ArmazensLocalizacoes/ListaCombo',
                    ControladorExtra: rootDir + '/TabelasAuxiliares/Localizacoes',
                    width: 150,
                    readOnly: true,
                    ListaCamposPreencher: listaCamposArmLocDest,
                    FuncaoEnviaParams: function (inObjetoFiltro, inGrelhaHTArt, inElem, inColuna) {
                        return self.EnviaParamsLotesArmazens(inObjetoFiltro, inGrelhaHTArt, inElem, inColuna);
                    }
                });
        }

        return ($.grep(columns, function (Obj, i) {
            return Obj.Label = Obj.Label.replace(moedaRefEmpresa, moedaRefCliente);
        }));
    };

    /* @description Funcao que retorna a ListaSColunasFormatar */
    self.ListaColunasFormatar = function () {
        var blnTrataBloqueio = self.VerificaSeBloqueiaColunas(); // $('#DocEstaAssinado').val() == 'False';

        let cols = [
            {
                IDColunaHT: campoDesc,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: "DescricaoVariavel", TipoPropBloqueio: "boolean",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoCampanha,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "boolean",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoCodigoIva,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "boolean",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoQtd,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoQtd, TipoPropBloqueio: "boolean",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: "number"
            },
            {
                IDColunaHT: campoDesconto1,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoValorDescontoLinha,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoTotalComDescontoLinha,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoValorUnitarioEntidade1,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoValorEntidade1,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoDescLote,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoGereLotes, TipoPropBloqueio: "boolean",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoDescArm,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            },
            {
                IDColunaHT: campoDescArmLoc,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: false, PropNumCasasDecimais: "", TipoPropNumCasasDecimais: ""
            }
        ];
        
        if (!(self.LimiteMaxDesconto() || $('#' + campoDocEstaAssinado).val() == 'True')) {
            cols.push({
                IDColunaHT: campoPrecoUnit,
                TrataBloqueio: blnTrataBloqueio, PropBloqueio: campoIDArt, TipoPropBloqueio: "number",
                TrataNumCasasDecimais: true, PropNumCasasDecimais: campoCasasDecPU, TipoPropNumCasasDecimais: "number"
            });
        }

        return cols;
    };

    /*@description funcao que atribui a linha as propriedades do servidor */
    self.PreenPropsLinDSComInfServEspecifico = function (inLinGrelha, inModeloLinhaDS) {
        inLinGrelha[campoDesconto1] = inModeloLinhaDS[campoDesconto1];
        inLinGrelha[campoValorDescontoLinha] = inModeloLinhaDS[campoValorDescontoLinha]
        inLinGrelha[campoTotalComDescontoLinha] = inModeloLinhaDS[campoTotalComDescontoLinha]
        inLinGrelha[campoValorDescontoCabecalho] = inModeloLinhaDS[campoValorDescontoCabecalho]
        inLinGrelha[campoTotalComDescontoCabecalho] = inModeloLinhaDS[campoTotalComDescontoCabecalho]
        inLinGrelha[campoPrecoUnitEfetivo] = inModeloLinhaDS[campoPrecoUnitEfetivo]
        inLinGrelha[campoValorUnitarioEntidade1] = inModeloLinhaDS[campoValorUnitarioEntidade1]
        inLinGrelha[campoValorEntidade1] = inModeloLinhaDS[campoValorEntidade1]
        inLinGrelha[campoValorUnitarioEntidade2] = inModeloLinhaDS[campoValorUnitarioEntidade2]
        inLinGrelha[campoValorEntidade2] = inModeloLinhaDS[campoValorEntidade2]
        inLinGrelha[campoTotalFinal] = inModeloLinhaDS[campoTotalFinal]
        inLinGrelha['MotivoIsencaoIva'] = inModeloLinhaDS['MotivoIsencaoIva']
    };

    /*@description funcao especifica das vendas que depois de adicionar uma linha atribui o campoAcaoCRUD como adicionar */
    self.AfterCreateRowEspecifico = function (inHdsn) {
        var linhaDS = DocumentosStockRetornaHTDocLinhaDS(true);
        if (UtilsVerificaObjetoNotNullUndefinedVazio(linhaDS) && UtilsVerificaObjetoNotNullUndefinedVazio(linhaDS[0])) {

            if (!linhaDS[0].hasOwnProperty(campoAcaoCRUD)) {
                linhaDS[0][campoAcaoCRUD] = constEstados.Adicionar;
            }
            else {
                for (var prop in linhaDS[0]) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(linhaDS[0][prop])) {
                        linhaDS[0][campoAcaoCRUD] = constEstados.Adicionar;
                        break;
                    }
                }
            }
        }
    };

    /*@description se o doc esta assinado nao ha context menu */
    self.ContextMenuEspecifico = function (inHdsn) {
        var boolDocEstaAssinado = $('#' + campoDocEstaAssinado).val() == 'True';
        //var boolEImpFromServicosToNC = $('#' + campoEImpFromVendasToNC).val() === 'true';
        var boolEImpFromServicosToFT2 = $('#' + campoEImpFromServicosToFT2).val() === 'true';

        if (!(boolDocEstaAssinado || boolEImpFromServicosToFT2)) {
            return DocumentosTodosRetornaHTContextMenu(inHdsn);
        }
        else {
            return null;
        }
    };

    /*@description funcao que verifica se se podem adicionar linhas ou nao */
    self.PermiteAddLinhasEspecifico = function () {
        var boolDocEstaAssinado = $('#' + campoDocEstaAssinado).val() == 'True';
        var boolEImpFromServicosToNC = $('#' + campoEImpFromVendasToNC).val() === 'true';
        var boolEImpFromServicosToFT2 = $('#' + campoEImpFromServicosToFT2).val() === 'true';

        return !(boolDocEstaAssinado || boolEImpFromServicosToNC || boolEImpFromServicosToFT2);
    };

    /*@description funcao que verifica se bloqueia as colunas */
    self.VerificaSeBloqueiaColunas = function () {
        var boolDocEstaAssinado = $('#' + campoDocEstaAssinado).val() == 'True';
        //var boolEImpFromServicosToNC = $('#' + campoEImpFromVendasToNC).val() === 'true';
        var boolEImpFromServicosToFT2 = $('#' + campoEImpFromServicosToFT2).val() === 'true';

        return !(boolDocEstaAssinado || boolEImpFromServicosToFT2);
    };

    /*@description funcao que  trata o bloqueio das colunas */
    self.ConfigColunasBloqueadas = function (inGrelhaHT) {
        if (!($('#' + campoDocEstaAssinado).val() == 'True')) {
            for (var i = 0, len = inGrelhaHT.countRows(); i < len; i++) {
                if (parseInt($('#' + campoAcaoFormulario).val()) != constEstados.Consultar) {
                    var indexColuna = UtilsRetornaIndiceArrayObjetos(inGrelhaHT.getSettings().__proto__.columns, campoDocOrig, campoID);
                    var cellb = inGrelhaHT.getCellMeta(i, indexColuna);
                    var linhaAtualDS = inGrelhaHT.getSourceDataAtRow(i);

                    cellb.readOnly = true;

                    if (UtilsVerificaObjetoNotNullUndefinedVazio(linhaAtualDS[campoDocOrig])) {
                        var colA = UtilsRetornaIndiceArrayObjetos(inGrelhaHT.getSettings().__proto__.columns, campoCodArt, campoID);
                        var cellA = inGrelhaHT.getCellMeta(i, colA);
                        cellA.readOnly = true;
                    }

                    self.TrataBloqueioColDocOrigem(cellb, linhaAtualDS);
                }
                //bloqueia colunas de descontos (UtilizaConfigDescontos == true) */
                self.TrataBloqueioColunasDescontos(inGrelhaHT, i);
            }
        }
    };

    /* @description funcao que trata o bloqueio da coluna documento origem conforme se e importacao, nc ... */
    self.TrataBloqueioColDocOrigem = function (inCurrentCell, inLinhaAtualDS) {
        var boolDocEstaAssinado = $('#' + campoDocEstaAssinado).val() == 'True';
        var boolEImpFromVendasToNC = $('#' + campoEImpFromVendasToNC).val() === 'true';
        var boolEImpFromServicosToDV = $('#' + campoEImpFromServicosToDV).val() === 'true';

        if (!(boolDocEstaAssinado || boolEImpFromVendasToNC || boolEImpFromServicosToDV)) {
            var tdf = $('#TipoFiscal').val();
            if (tdf === 'ND' || tdf === 'NC') {
                inCurrentCell.readOnly = false;
            }
            else {
                inLinhaAtualDS[campoDocOrig] = null;
            }
        }
    };

    /* @description funcao envia parametros das colunas armazens, localizacoes e lotes DocStocksLinhas */
    self.EnviaParamsLotesArmazens = function (inObjFiltro, inGrelhaHTArt, inElem, inColuna) {
        var linhaDS = null;
        if (typeof inGrelhaHTArt === 'string') {
            inGrelhaHTArt = self.RetornaHdsnInstance();
            linhaDS = HandsonTableRetornaLinhaDS(inGrelhaHTArt);
        } else {
            linhaDS = HandsonTableRetornaLinhaDS(inGrelhaHTArt);
        }

        if (linhaDS !== null) {
            var nomeColOF = inObjFiltro[campoValoresID][campoClicDesc];
            var nomeCol = (UtilsVerificaObjetoNotNullUndefined(inColuna)) ? inColuna[campoID] : '';
            if (UtilsVerificaObjetoNotNullUndefined(nomeColOF) && nomeCol === '') {
                nomeCol = nomeColOF[campoTextoID];
            }
            // ID Artigo
            GrelhaUtilsPreencheObjetoFiltroValor(inObjFiltro, true, campoIDArt, linhaDS[campoDescArt], linhaDS[campoIDArt]);
            var IDArmVal = 0;

            if (nomeCol === campoDescArmLoc) {
                // ID Localizacao entrada (coloca -1 para retornar todas as localizaçoes)
                IDArmVal = 0;
                if (UtilsVerificaObjetoNotNullUndefinedVazio(linhaDS[campoIDArm])) {
                    IDArmVal = (linhaDS[campoIDArm] != 0) ? linhaDS[campoIDArm] : null;
                }
                else {
                    if (linhaDS[campoIDArm] != 0 && linhaDS[campoIDArm] != null) {
                        IDArmVal = linhaDS[campoIDArm];
                    }
                }
                if (IDArmVal != 0) {
                    GrelhaUtilsPreencheObjetoFiltroValor(inObjFiltro, true, campoIDArm, linhaDS[campoDescArmDest], IDArmVal);
                }
            }
        }
        return inObjFiltro
    }

    /* @description funcao envia parametros da coluna IDArtigo */
    self.EnviaParamsIDArtigo = function (objetoFiltro) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var taxaConv = parseFloat(KendoRetornaElemento($('#' + campoTaxaConv)).value());
        var IDEnt = $('#' + campoIDEntidade).val();
        var IDMoed = $('#' + campoIDMoeda).val();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, campoTaxaConv, '', taxaConv);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, campoIDEntidade, '', IDEnt);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, campoIDMoeda, '', IDMoed);

        return objetoFiltro;
    }

    /*@description funcao que bloqueia as colunas de descontos (UtilizaConfigDescontos == true) */
    self.TrataBloqueioColunasDescontos = function (inGrelhaHT, inRow) {
        var _boolUtilizaConfigDescontos = $('#UtilizaConfigDescontos').val() == 'True';

        if (_boolUtilizaConfigDescontos) {
            var _indexColunaDesconto = inGrelhaHT.propToCol(campoDesconto1);
            inGrelhaHT.getCellMeta(inRow, _indexColunaDesconto).readOnly = true;

            var _indexColunaDescontoLinha = inGrelhaHT.propToCol(campoValorDescontoLinha);
            inGrelhaHT.getCellMeta(inRow, _indexColunaDescontoLinha).readOnly = true;

            var indexColunaTotalComDescontoLinha = inGrelhaHT.propToCol(campoTotalComDescontoLinha)
            inGrelhaHT.getCellMeta(inRow, indexColunaTotalComDescontoLinha).readOnly = true;
        }
    };

    //------------------------------------ C A B E C A L H O    E S P E C I F I C O
    //TODO MAF
    /*@description funcao especifica de EnviaParams dos TiposDocumento */
    self.TiposDocEnviaParamsEspecifico = function (objetoFiltro) {
        var boolEImpFromVendasToNC = $('#' + campoEImpFromVendasToNC).val() === 'true';
        var boolEImpFromServicosToDV = $('#' + campoEImpFromServicosToDV).val() === 'true';
        var boolEImpFromVendasToFT2 = $('#' + campoEImpFromServicosToFT2).val() === 'true';

        if (boolEImpFromServicosToDV || boolEImpFromVendasToFT2) {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'FiltrarTipoDocumentos', '', 'ftfsfr');
        }
        else if (boolEImpFromVendasToNC) {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'FiltrarTipoDocumentos', '', 'nc');
        }
    };

    self.TiposDocSeriesEnviaParamsEspecifico = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'AreaTemp', '0', '0');
    };

    /*@description funcao especifica do change da Entidade */
    self.TrataInformacaoEntidade = function (inEntSel) {
        DocumentosStockTrataInformacaoEntidade(inEntSel);
    };

    /*@description funcao especifica do change da Entidade */
    self.ChangeEntidade = function (entSel) {
        var boolEImpFromServicosToFT2 = $('#' + campoEImpFromServicosToFT2).val() === 'true';
        //verifica se estamos na passagem de servicos para FT2
        if (!boolEImpFromServicosToFT2) {
            KendoRetornaElemento($('#IDEntidade1')).value(entSel.IDEntidade1);
            KendoRetornaElemento($('#IDEntidade2')).value(entSel.IDEntidade2);
            $('#NumeroBeneficiario1').val(entSel.NumeroBeneficiario1);
            $('#NumeroBeneficiario2').val(entSel.NumeroBeneficiario2);
            $('#Parentesco1').val(entSel.Parentesco1);
            $('#Parentesco2').val(entSel.Parentesco2);
        }

        //notifica com os avisos do cliente
        UtilsNotifica(base.constantes.tpalerta['i'], entSel['Avisos']);
    };

    //------------------------------------ E S T A D O S     E S P E C I F I C O
    /*@description funcao especifica de change do Estado */
    self.ChangeEstado = function (inModeloEstados) {
        self.PodeMudarOEstadoParaAnulado(inModeloEstados);
    };

    /*@description funcao que verifica se o documento pode mudar o estado para anulado */
    self.PodeMudarOEstadoParaAnulado = function (inModeloEstados) {
        var urlAux = rootDir + "DocumentosVendas/ValidaEstado";
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var model = DocumentosTodosRetornaModeloDoc(true);

        UtilsChamadaAjax(urlAux, false, JSON.stringify({ inObjFiltro: objetoFiltro, modelo: model }),
            function (res) {
                self.PodeMudarOEstadoParaAnuladoSuccessCallback(res);
            });
    };

    /*@description funcao sucesso que verifica se o documento pode mudar o estado para anulado */
    self.PodeMudarOEstadoParaAnuladoSuccessCallback = function (res) {
        if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
            if (res.ValidaEstado && res.ValidaEstado != 0) {
                self.PodeMudarOEstadoParaAnuladoNotificacoes(res.ValidaEstado);
            }
            else {
                DocumentoTrataCargaDescarga();
                //RAZAO DE ANULAMENTO DOS DOCUMENTOS
                var blnAcompanhaBens = $('#boolAcompanhaBens').val();
                var codMovStk = $('#CodigoSistemaTiposDocumentoMovStock').val();
                if ((codMovStk === TIPODOC_MOVSTK_TRF && blnAcompanhaBens === "True") || (codMovStk != TIPODOC_MOVSTK_TRF && $('#' + campoDocEstaAssinado).val() === "True")) {
                    DocumentosEstadoAlterado();
                }
            }
        }
    };

    /* @description funcao que notifica as validacoes se pode anular */
    self.PodeMudarOEstadoParaAnuladoNotificacoes = function (idNotificacao) {
        switch (idNotificacao) {
            case 1:
                UtilsNotifica(base.constantes.tpalerta.warn, resources.Aviso_DocTemPagamentos);
                break;

            case 11:
                UtilsNotifica(base.constantes.tpalerta.warn, resources.Aviso_NumDiasAntecedencia);
                break;

            case 12:
                UtilsNotifica(base.constantes.tpalerta.warn, resources.Aviso_NumDiasAnular);
                break;
        }
    }

    //------------------------------------ C A L C U L O S
    /* @description funcao especifica que faz os calculos gerais */
    self.CalculaGeral = function (inModelo, inGrelhaHT, inCampoAlterado, inBoolPreenheCargaDescarga, inIndexLinha) {
        var urlAux = rootDir + 'DocumentosVendas/Calcula';
        var ValorAlterado = $('#' + inCampoAlterado).val();
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        objetoFiltro['CamposFiltrar']['CampoAlterado'] = { 'CampoValor': ValorAlterado, 'CampoTexto': inCampoAlterado };

        if (UtilsVerificaObjetoNotNullUndefined(inGrelhaHT)) {
            if (inGrelhaHT.getSettings().columns.filter(function (f) { return f.ID == inCampoAlterado; }).length > 0) {
                var IDLinha = inGrelhaHT.getDataAtRowProp(inGrelhaHT.getActiveEditor().row, campoOrdem);
                objetoFiltro['CamposFiltrar']['Col'] = { 'CampoValor': inCampoAlterado, 'CampoTexto': inCampoAlterado };
                objetoFiltro['CamposFiltrar']['IDLinha'] = { 'CampoValor': IDLinha, 'CampoTexto': IDLinha };
            }
        }

        var dataAux = { inObjFiltro: objetoFiltro, modelo: inModelo };

        dataAux = constIsSafari ? dataAux : JSON.stringify(dataAux);

        UtilsChamadaAjax(urlAux, true, dataAux,
            function (res) {
                if (!UtilsChamadaAjaxTemErros(res)) {
                    DocumentosSetCalculos(res, inGrelhaHT, inIndexLinha);

                    if (inBoolPreenheCargaDescarga === true) { //Executa o preenchimento da carga / descarga caso haja alteracoes na linha 0 (adionar / remover / mudar artigo / mudar armazem)
                        CargaDescargaPreenchePorDefeito(res);
                    }
                }
            }, function (e) { throw e; }, 1, true);
    };

    ////TODO !!!!! ESTES TOTAIS SAO PROVISORIOS!!!!!
    self.FuncaoProvisoriaCalculaTotais = function (model, inCampoAlt) {
        var urlAux = rootDir + 'Documentos/' + TipoPai + '/DaTotaisDocumento';

        var dataAux = { inModeloStr: LZString.compressToBase64(JSON.stringify(model)) };
        dataAux['ELinhasTodas'] = true;

        if (UtilsVerificaObjetoNotNullUndefinedVazio(inCampoAlt)) {
            dataAux['inCampoAlterado'] = inCampoAlt;
        }

        dataAux = constIsSafari ? dataAux : JSON.stringify(dataAux);

        if (self.ExecutouDaTotaisDocumento === true) {
            self.ExecutouDaTotaisDocumento = false;
            self.IsPendingCalcs = true;

            UtilsChamadaAjax(urlAux, true, dataAux,
                function (res) {
                    if (!UtilsChamadaAjaxTemErros(res)) {
                        //decompress to model
                        res = JSON.parse(LZString.decompressFromBase64(res));


                        DocumentosSetCalculos(res, self.RetornaHdsnInstance(), -1);
                        self.PreencheTotais(res);

                        self.IsPendingCalcs = false;
                        if (typeof (self.fnClick) === 'function') {
                            var fnClickAux = self.fnClick;
                            self.fnClick = null;
                            fnClickAux();
                        }
                    }
                }, function (e) { throw e; }, 1, true);
        }
        else {
            self.ExecutouDaTotaisDocumento = true;
        }
    };

    /* @description funcao preenche os campos de totais de efetuar calculos */
    self.PreencheTotais = function (inRes) {
        var casasDecTotais = $('#' + campoCasasDecTot).val();
        var casasDecPerc = constRefCasasDecimaisPercentagem;
        var Moeda = DocumentosRetornaMoeda();

        //E L E M E N T O S  - B E G I N
        var arrElementos = [
            { Campo: 'TotalResumo', DS: campoTotalMoedaDocumento, CasasDecimais: casasDecTotais },
            { Campo: campoTotalIva, DS: campoTotalIva, CasasDecimais: casasDecTotais },
            { Campo: campoIDDescontoLinha, DS: campoDescontosLinha, CasasDecimais: casasDecTotais },
            { Campo: campoTotalEntidade1, DS: campoTotalEntidade1, CasasDecimais: casasDecTotais },
            { Campo: campoOutrosDescontos, DS: campoOutrosDescontos, CasasDecimais: casasDecTotais },
            { Campo: campoSubTotal, DS: "SubTotal", CasasDecimais: casasDecTotais }];

        for (var i = 0, len = arrElementos.length; i < len; i++) {
            var item = arrElementos[i];
            $('#' + item.Campo).text(UtilsFormataSeparadoresDecimais_Milhares(parseFloat(inRes[item.DS]).toFixed(item.CasasDecimais), constTipoDeCampo.Moeda) + ' ' + Moeda.Simbolo);
        }
        //E L E M E N T O S  -  E N D

        //E L E M E N T O S    K E N D O  -  B E G I N
        var arrElementosKendo = [
            { Campo: campoTotalMoedaDocumento, DS: campoTotalMoedaDocumento, CasasDecimais: casasDecTotais },
            { Campo: 'TotalEntidade2', DS: 'TotalEntidade2', CasasDecimais: casasDecTotais },
            { Campo: campoValorDesconto, DS: campoValorDesconto, CasasDecimais: casasDecTotais },
            { Campo: campoPercentagemDesconto, DS: campoPercentagemDesconto, CasasDecimais: casasDecPerc },
            { Campo: 'TotalPontos', DS: 'TotalPontos', CasasDecimais: casasDecTotais },
            { Campo: 'TotalValesOferta', DS: 'TotalValesOferta', CasasDecimais: casasDecTotais }];

        for (var i = 0, len = arrElementosKendo.length; i < len; i++) {
            var item = arrElementosKendo[i];
            KendoRetornaElemento($('#' + item.Campo)).value(parseFloat(inRes[item.DS]).toFixed(item.CasasDecimais));
        }
        //E L E M E N T O S    K E N D O  -  E N D
    }

    /* @description funcao que efetua os calculos genericos com base nos descontos */
    self.CalculaDescontoGlobal = function (e) {
        self.IsPendingCalcs = true;
        self.CalculaGeral(DocumentosTodosRetornaModeloDoc(true), self.RetornaHdsnInstance(), e.sender.element.attr('id'), false, -1);
    };

    /* @description funcao que efetua os calculos genericos com base nas comparticipacoes */
    self.CalculaComparticipacoes = function (boolchecked) {
        var hdsn = self.RetornaHdsnInstance();
        if (UtilsVerificaObjetoNotNullUndefinedVazio(hdsn)) {
            self.CalculaGeral(DocumentosTodosRetornaModeloDoc(true), hdsn, 'IDEntidade', false, -1);
        }
    };

    /* @description funcao que atribui valores aos campos TotalMoedaDocumento,  PercentagemDesconto e ValorDesconto*/
    self.SetValoresDescontos = function (inModelo, insimboloMoedaRef) {
        var Moeda = DocumentosRetornaMoeda();

        var TotalMoedaDocumento = 0;
        var SubTotal = 0;
        var DescontosLinha = 0;
        var PercentagemDesconto = 0;
        var ValorDesconto = 0;
        var OutrosDescontos = 0;
        var TotalEntidade1 = 0;
        var TotalIva = 0;

        if (UtilsVerificaObjetoNotNullUndefinedVazio(inModelo)) {
            TotalMoedaDocumento = inModelo[campoTotalMoedaDocumento];
            SubTotal = inModelo['SubTotal'];
            DescontosLinha = inModelo['DescontosLinha'];
            PercentagemDesconto = inModelo[campoPercentagemDesconto];
            ValorDesconto = inModelo[campoValorDesconto];
            OutrosDescontos = inModelo[campoOutrosDescontos];
            TotalEntidade1 = inModelo[campoTotalEntidade1];
            TotalIva = inModelo[campoTotalIva];

        //TotalResumo
        $('#' + campoTotalResumo).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(TotalMoedaDocumento).toFixed(Moeda.CD_Totais)), 'Currency') + ' ' + Moeda.Simbolo);

        //Total
        $('#' + campoTotal).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(TotalMoedaDocumento).toFixed(Moeda.CD_Totais)), 'Currency') + ' ' + Moeda.Simbolo);

        //TotalMoedaDocumento
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + campoTotalMoedaDocumento)))) {
            KendoRetornaElemento($('#' + campoTotalMoedaDocumento)).value(TotalMoedaDocumento.toFixed(Moeda.CD_Totais))
        }

        //SubTotal
        $('#' + campoSubTotal).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(SubTotal).toFixed(Moeda.CD_Totais)), 'Currency') + ' ' + Moeda.Simbolo);

        //DescontoLinha
        $('#' + campoIDDescontoLinha).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(DescontosLinha).toFixed(Moeda.CD_Totais)), 'Currency') + ' ' + Moeda.Simbolo);

        //PercentagemDesconto
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + campoPercentagemDesconto)))) {
            KendoRetornaElemento($('#' + campoPercentagemDesconto)).value(PercentagemDesconto.toFixed(6));
        }

        //ValorDesconto
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + campoValorDesconto)))) {
            KendoRetornaElemento($('#' + campoValorDesconto)).value(ValorDesconto.toFixed(Moeda.CD_Totais));
        }

        //Outros Descontos
        $('#' + campoOutrosDescontos).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(OutrosDescontos).toFixed(Moeda.CD_IVA)), 'Currency') + ' ' + Moeda.Simbolo);

        $('#' + campoTotalEntidade1).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(TotalEntidade1).toFixed(Moeda.CD_IVA)), 'Currency') + ' ' + Moeda.Simbolo);

        $('#' + campoIDTotalImposto).text(UtilsFormataSeparadoresDecimais_Milhares((parseFloat(TotalIva).toFixed(Moeda.CD_IVA)), 'Currency') + ' ' + Moeda.Simbolo);
        }
    };

    //------------------------------------ G R A V A     E S P E C I F I C O
    /*@description Modelo dos pagamentos (Formas de pagamento...) */
    self.ModeloPagamentos = null;

    /*@description funcao que envia o modelo para a janela de pagamentos */
    self.EnviaModelo = function (inModelo) {
        var objData = new Object;
        objData['modelo'] = inModelo;
        return objData;
    };

    /*@description funcao que atribui as linhas no indexdb ao modelo */
    self.AtribuiLinhasIndexDB_Modelo = function (inEvent, inArrTabelas, inModelo) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(inEvent)) {
            var modelosIndexDB = inEvent.target.result;

            if (UtilsVerificaObjetoNotNullUndefinedVazio(inArrTabelas) && inArrTabelas.length > 0 && UtilsVerificaObjetoNotNullUndefinedVazio(modelosIndexDB) && modelosIndexDB.length > 0) {
                for (var i = 0; i < inArrTabelas.length; i++) {
                    var tabelaAux = inArrTabelas[i];
                    inModelo[tabelaAux] = modelosIndexDB;
                }
            }
        }
        return inModelo;
    };

    //*@description funcao especifica de gravacao */
    self.ValidaGravaEspecifico = function (inEvent, inTabela, inGrelha, inFormulario, inURL, inModelo, inElemBtID, arg6, arg7, arg8) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(inEvent)) {
            var tabelasIndexDB = inEvent.target.result;

            if (UtilsVerificaObjetoNotNullUndefined(tabelasIndexDB) && tabelasIndexDB.length > 0) {
                F3MIndexedDBRetornaRegistos([tabelasIndexDB[0][campoAcaoUID]], self.ValidaGravaSucessoEspecifico, inGrelha, inFormulario, inURL, inModelo, inElemBtID);
            }
        }
    };

    /*@description funcao especifica de gravacao */
    self.ValidaGravaSucessoEspecifico = function (inEvent, inArrTabelas, inGrelha, inFormulario, inURL, inModelo, inElemBtID, arg6, arg7, arg8) {
        inModelo = self.AtribuiLinhasIndexDB_Modelo(inEvent, inArrTabelas, inModelo);

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(GrelhaUtilsValida(inFormulario))) {
            //get tipo fiscal
            var tipoFiscal = inModelo.TipoFiscal;
            //get id tipo documento origem
            var idTipoDocumentoOrigem = inModelo[TipoPai + 'Linhas'][0]['IDDocumentoOrigem'];
            //se for uma nota de credito e tiver origem -> verifica se existe alguma ncd
            if (UtilsVerificaObjetoNotNullUndefinedVazio(tipoFiscal) && tipoFiscal.toLowerCase() == "nc" && idTipoDocumentoOrigem) {
                self.VerificaSeTemNCDA(inModelo, function () {
                    self.ValidaGravaSucessoEspecificoSuccessCallbak(inGrelha, inFormulario, inURL, inModelo, inElemBtID, arg6, arg7, arg8);
                });
            }
            else {
                self.ValidaGravaSucessoEspecificoSuccessCallbak(inGrelha, inFormulario, inURL, inModelo, inElemBtID, arg6, arg7, arg8);
            }
        }
    };

    /*@description callback da funcao especifica de gravacao */
    self.ValidaGravaSucessoEspecificoSuccessCallbak = function (inGrelha, inFormulario, inURL, inModelo, inElemBtID, arg6, arg7, arg8) {
        //abre os pagamentos se -> estado = efetivo & (tipofiscal = "fs" || tipofiscal = "fr") & tipodoc nao gere pendente & doc nao esta assinado
        if (UtilsVerificaObjetoNotNullUndefinedVazio(inModelo.TipoFiscal) && inModelo.CodigoTipoEstado.toLowerCase() === base.constantes.Estados.Efetivo.toLowerCase() &&
            (inModelo.TipoFiscal.toLowerCase() == "fs" || inModelo.TipoFiscal.toLowerCase() == "fr" || inModelo.TipoFiscal.toLowerCase() == "nc") &&
            inModelo.TipoDocGeraPendente.toLowerCase() == 'false' &&
            !UtilsVerificaObjetoNotNullUndefinedVazio(inModelo.Assinatura)) {

            self.GravaFromPagamentos(inGrelha, inFormulario, inURL, inModelo, inElemBtID);
        }
        else {
            self.ValidaGravaGenerico(inGrelha, inFormulario, inURL, inModelo, inElemBtID);
        }
    };

    /*@description quando é uma FS avre (do vervo avrir) a janela de pagamentos */
    self.GravaFromPagamentos = function (inGrelha, inFormulario, inURL, inModelo, inElemBtID) {
        var urlAux = rootDir + 'DocumentosVendas/ValidaDocumento_FROMPagamentos';
        var IDEntidadeAux = parseInt($('#' + campoIDEntidade).val());
        var IDMoedaAux = parseInt($('#' + campoIDMoeda).val());

        //para nao abrir a janela de pagamentos outra vez, quando da a msg de ruptura de stock
        if ($docTodos.ajax.JaConfirmou === true) {
            $docTodos.ajax.JaConfirmou = null;

            inModelo['PagamentosVendas'] = self.ModeloPagamentos;
            self.ModeloPagamentos = null;

            self.ValidaGravaGenerico(inGrelha, inFormulario, inURL, inModelo, inElemBtID);

            return;
        }
        //end

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ modelo: inModelo }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                    var OpcaoAux = "pagamentos_fromdocsvendas";
                    var _janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
                    var _UrlAuxPagamentosVendas = rootDir + '/PagamentosVendas/PagamentosVendas?' + campoIDEntidade + '=' + IDEntidadeAux + '&' + campoIDMoeda + '=' + IDMoedaAux + '&Opcao=' + OpcaoAux;

                    JanelaDesenha(_janelaMenuLateral, self.EnviaModelo(inModelo), _UrlAuxPagamentosVendas, '', null, null, null, null, null, function (inEvt) {
                        inEvt.sender.element.addClass('janela-centrada');
                        janelaRefrescar(inEvt, '', false, 'f3m-window-bg-centrada');
                        FrontendGrelhaLoading();
                    }, function () {
                        var newModel = $('#' + _janelaMenuLateral).data('kendoWindow').options.data.modelo;

                        if (UtilsVerificaObjetoNotNullUndefined(newModel['PagamentosVendas'])) {
                            self.ValidaGravaGenerico(inGrelha, inFormulario, inURL, newModel, inElemBtID);
                            (newModel['BotaoClicado'] == 'btnSaveAndPrint') ? $gridutils.ajax.idElementoClick = 'F3MGrelhaFormDocumentosVendasBtPrint' : true;
                            self.ModeloPagamentos = newModel['PagamentosVendas'];
                        }
                    }, null, null, null, null);
                }
                else {
                    UtilsAlerta(base.constantes.tpalerta.error, res.Erros[0].Mensagem);
                }
            }, function (e) { }, 1, true);
    };

    /*@description funcao final que grava tudo */
    self.ValidaGravaGenerico = function (inGrelha, inFormulario, inURL, inModelo, inElemBtID) {
        GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso, null);
        GrelhaUtilsBloquearCabecalhoRodape(inGrelha, false);
    };

    /*@description funcao que verifica se tem alguma NCD ou NCDA quando estamos a gravar um NC */
    self.VerificaSeTemNCDA = function (modelo, fnSuccessCallback) {
        //get url
        var _url = rootDir + 'DocumentosVendas/Retorna_DocNCDA';
        //get doc origem
        var _idDocumentoOrigem = modelo[TipoPai + 'Linhas'][0]['IDDocumentoOrigem'];

        $.post(_url, { idDocumentoOrigem: _idDocumentoOrigem }, function (result) {
            self.VerificaSeTemNCDASuccessCallback(result, fnSuccessCallback);
        });
    };

    /*@description funcao que verifica se tem alguma NCD ou NCDA quando estamos a gravar um NC */
    self.VerificaSeTemNCDASuccessCallback = function (result, fnSuccessCallback) {
        if (result) {
            //ask
            UtilsConfirma(base.constantes.tpalerta.question, 'A nota de crédito de adiantamento a dinheiro ' + result + ' irá ser anulada e as respectivas faturas de adiantamento. Deseja continuar?', function () {
                //continue
                fnSuccessCallback();
            }, function () { });
        }
        else {
            //continue
            fnSuccessCallback();
        }
    }

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /*@description funcao retorna propiedades para a modal */
    self.RetornaObjData = function () {
        var _objData = {};
        _objData[campoIDEntidade] = $('#' + campoIDEntidade).val();
        _objData.Modo = "0";

        return _objData;
    };

    /*@description funcao que atualiza o historico */
    self.AtualizaHistorico = function () {
        var _url = rootDir + 'Historicos/Historicos/RetornaHistDocsVendas?IDDocumentoVenda=' + $('#' + campoID).val();

        UtilsChamadaAjax(_url, true, {},
            function (res) {
                $('#tabHistorico').html(res);
                //F3MFormulariosInitHistorico('documentosvendas');
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    self.LimiteMaxDesconto = function () {
        var limiteMaxDesconto = 0;
        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#LimiteMaxDesconto'))) {
            limiteMaxDesconto = $('#LimiteMaxDesconto').val();
        }
        return limiteMaxDesconto > 0;
    };

    return parent;

}($docsvendas || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocumentosVendasConstroiHT = $docsvendas.ajax.ConstroiHT;
var DocumentosVendasInit = $docsvendas.ajax.Init;
var DocumentosVendasEnviaParamsLotesArmazens = $docsvendas.ajax.EnviaParamsLotesArmazens;
var DocumentosVendasDescontoGlobal = $docsvendas.ajax.CalculaDescontoGlobal;
var DocumentosVendasCliquePagamentos = $docsvendas.ajax.CliquePagamentos;
var DocumentosVendasCliqueRecebimentos = $docsvendas.ajax.CliqueRecebimentos;
//calculos
var DocumentosCalculaGeralEspecifico = $docsvendas.ajax.CalculaGeral;
var DocumentosPreencheTotaisEspecifico = $docsvendas.ajax.PreencheTotais;
var DocumentosSetDescontosEspecifico = $docsvendas.ajax.SetValoresDescontos;
//cabecalho
var CabecalhoChangeEntidade = $docsvendas.ajax.ChangeEntidade;
var CabecalhoTrataInformacaoEntidade = $docsvendas.ajax.TrataInformacaoEntidade;
var CabecalhoTiposDocEnviaParamsEspecifico = $docsvendas.ajax.TiposDocEnviaParamsEspecifico;
var CabecalhoTiposDocSeriesEnviaParamsEspecifico = $docsvendas.ajax.TiposDocSeriesEnviaParamsEspecifico;
//estados
var EstadosLadoDireitoChangeEstado = $docsvendas.ajax.ChangeEstado;
//handsontable
var DocumentosRetornaColunasHTEspecifico = $docsvendas.ajax.RetornaColunasHT;
var DocumentosConfigColunasBloqueadasEspecifico = $docsvendas.ajax.ConfigColunasBloqueadas;
var DocumentosAfterCreateRowEspecifico = $docsvendas.ajax.AfterCreateRowEspecifico;
var DocumentosContextMenuEspecifico = $docsvendas.ajax.ContextMenuEspecifico;
var DocumentosPermiteAddLinhasEspecifico = $docsvendas.ajax.PermiteAddLinhasEspecifico;
var DocumentosListaColunasFormatarEspecifico = $docsvendas.ajax.ListaColunasFormatar;
var DocumentosPreenPropsLinDSComInfServEspecifico = $docsvendas.ajax.PreenPropsLinDSComInfServEspecifico;
//grava especifico
var ValidaGravaEspecifico = $docsvendas.ajax.ValidaGravaEspecifico;
//FUNCAO ULTRA MEGA PROVISORIA PARA AS VENDAS
var DocumentosCalculaTotais = $docsvendas.ajax.FuncaoProvisoriaCalculaTotais;

$(document).ready(function (e) {
    DocumentosVendasInit();
});

$(document).ajaxStop(function () {
    //PAGAR E IMPRIMIR
    if (UtilsVerificaObjetoNotNullUndefinedVazio($gridutils.ajax.idElementoClick) && UtilsVerificaObjetoNotNullUndefinedVazio($gridutils.ajax.assinatura)) {
        $('#' + $gridutils.ajax.idElementoClick).trigger('click');
        $gridutils.ajax.idElementoClick = null
    }
    //END IMPRIMIR
});